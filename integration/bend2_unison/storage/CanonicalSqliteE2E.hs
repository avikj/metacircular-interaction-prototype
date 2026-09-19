module Main where

import Bend.UCM.Execution (ExecutionResult(..), runCheckedBook, selectEntryAsMain)
import Core.Admission (CheckedSource(..), admitSource)
import Core.CanonicalComponent (decodeCanonicalComponentSynthetic, syntheticMemberName)
import Core.ComponentPlan (AddressedComponent(..), ComponentPlan(..), addressComponents)
import Core.Type (Book(..), Name)
import Crypto.Hash (Digest, SHA3_512, hash)
import qualified Data.ByteArray as ByteArray
import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as Lazy
import Data.Bits ((.&.), (.|.), shiftL, shiftR)
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import System.Environment (getArgs)
import System.Exit (ExitCode(..))
import System.IO (hClose, openTempFile)
import System.Process (readProcessWithExitCode)

type MemberRef = (Int, Int) -- object id, member index

main :: IO ()
main = do
  [sourcePath, hvmPath] <- getArgs
  source <- readFile sourcePath
  checked <- either (const (fail "Bend2 source admission failed")) pure
    (admitSource sourcePath source)
  components <- either fail pure (addressComponents checked)
  (dbPath, dbHandle) <- openTempFile "/private/tmp" "bend-canonical-sqlite.sqlite"
  hClose dbHandle
  createUnisonSchema dbPath
  resolved <- foldlM (storeComponent dbPath sourcePath source) Map.empty components
  rootRef <- lookupUniqueMember dbPath "main"
  if Map.lookup "main" resolved /= Just rootRef
    then fail "authored-name lookup returned wrong native reference"
    else pure ()
  renamed <- renamePresentation dbPath rootRef "renamedMain"
  if renamed /= rootRef then fail "rename changed the native component reference" else pure ()
  (entryName, closed) <- loadClosure dbPath rootRef
  runnable <- either fail pure (selectEntryAsMain entryName closed)
  originalResult <- runCheckedBook hvmPath (checkedBook checked)
  storedResult <- runCheckedBook hvmPath runnable
  case (originalResult, storedResult) of
    (Right original, Right stored)
      | stableResult original == stableResult stored -> do
          putStrLn ("canonical SQLite components: " ++ show (length components))
          putStrLn ("stored main: " ++ show rootRef ++ ", synthetic entry: " ++ entryName)
          putStrLn ("original and SQLite-loaded HVM4 results match: " ++ show (stableResult original))
      | otherwise -> fail ("HVM4 result differs: " ++ show original ++ " vs " ++ show stored)
    (Left err, _) -> fail ("original HVM4 run failed: " ++ show err)
    (_, Left err) -> fail ("SQLite-loaded HVM4 run failed: " ++ show err)

stableResult :: ExecutionResult -> (String, [String])
stableResult result =
  case lines (output result) of
    [] -> ("", [])
    firstLine:rest -> (firstLine, filter ("- Itrs:" `prefixOf`) rest)
  where
    prefixOf prefix value = take (length prefix) value == prefix

createUnisonSchema :: FilePath -> IO ()
createUnisonSchema db = do
  let sqlRoot = "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/codebase2/codebase-sqlite/sql/"
  _ <- sqliteWithArgs
    ["-cmd", "PRAGMA foreign_keys=ON",
     "-cmd", ".read " ++ sqlRoot ++ "create.sql",
     "-cmd", ".read " ++ sqlRoot ++ "001-temp-entity-tables.sql",
     "-cmd", ".read " ++ sqlRoot ++ "023-bend-components.sql",
     db, "SELECT 1"]
  pure ()

storeComponent :: FilePath -> FilePath -> String -> Map.Map Name MemberRef -> AddressedComponent -> IO (Map.Map Name MemberRef)
storeComponent db sourcePath source resolved addressed = do
  let plan = addressedPlan addressed
      digestText = base32hex (addressedDigest addressed)
      blobPath = db ++ "-" ++ digestText ++ ".blob"
      sourceDigestPath = db ++ "-source-digest.blob"
      sql = "BEGIN; INSERT OR IGNORE INTO hash(base32) VALUES (" ++ quote digestText ++ "); " ++
            "INSERT OR IGNORE INTO object(primary_hash_id,type_id,bytes) VALUES " ++
            "((SELECT id FROM hash WHERE base32=" ++ quote digestText ++ "),4,readfile(" ++ quote blobPath ++ ")); " ++
            "SELECT id FROM object WHERE primary_hash_id=(SELECT id FROM hash WHERE base32=" ++ quote digestText ++ "); COMMIT;"
  Lazy.writeFile blobPath (addressedBytes addressed)
  Bytes.writeFile sourceDigestPath (sha3 (Text.encodeUtf8 (Text.pack source)))
  objectId <- read . trim <$> sqlite db sql
  let local = Map.fromList [(name,(objectId,index)) | (name,index) <- zip (componentNames plan) [0..]]
      allRefs = Map.union local resolved
      sourceLength = Bytes.length (Text.encodeUtf8 (Text.pack source))
  mapM_ (\(name,index) -> do
    _ <- sqlite db ("INSERT OR IGNORE INTO bend_presentation " ++
      "(component_object_id,component_index,source_digest,source_utf8,source_start_byte,source_end_byte,authored_name,source_path) VALUES (" ++
      show objectId ++ "," ++ show index ++ ",readfile(" ++ quote sourceDigestPath ++ "),readfile(" ++ quote sourcePath ++ "),0," ++
      show sourceLength ++ "," ++ quote name ++ "," ++ quote sourcePath ++ ");")
    let deps = Set.toAscList (Map.findWithDefault Set.empty name (componentMemberDependencies plan))
    mapM_ (\dep -> case Map.lookup dep allRefs of
      Nothing -> fail ("missing stored dependency " ++ dep)
      Just (depObject,depIndex) -> do
        _ <- sqlite db ("INSERT OR IGNORE INTO dependents_index " ++
          "(dependency_builtin,dependency_object_id,dependency_component_index,dependent_object_id,dependent_component_index) VALUES " ++
          "(NULL," ++ show depObject ++ "," ++ show depIndex ++ "," ++ show objectId ++ "," ++ show index ++ ");")
        pure ()) deps
    ) (zip (componentNames plan) [0..])
  pure allRefs

lookupUniqueMember :: FilePath -> Name -> IO MemberRef
lookupUniqueMember db name = do
  rows <- lines <$> sqlite db
    ("SELECT DISTINCT component_object_id || '|' || component_index FROM bend_presentation WHERE authored_name=" ++ quote name ++ ";")
  case rows of
    [row] -> case break (=='|') row of
      (oid,'|':idx) -> pure (read oid,read idx)
      _ -> fail "malformed member reference"
    [] -> fail ("missing authored name " ++ name)
    _ -> fail ("ambiguous authored name " ++ name)

renamePresentation :: FilePath -> MemberRef -> Name -> IO MemberRef
renamePresentation db (oid,idx) newName = do
  _ <- sqlite db ("INSERT OR IGNORE INTO bend_presentation " ++
    "(component_object_id,component_index,source_digest,source_utf8,source_start_byte,source_end_byte,authored_name,source_path) " ++
    "SELECT component_object_id,component_index,source_digest,source_utf8,source_start_byte,source_end_byte," ++
    quote newName ++ ",source_path FROM bend_presentation WHERE component_object_id=" ++ show oid ++
    " AND component_index=" ++ show idx ++ " LIMIT 1;")
  lookupUniqueMember db newName

loadClosure :: FilePath -> MemberRef -> IO (Name,Book)
loadClosure db (rootObject,rootIndex) = do
  (digests,book) <- go Set.empty [rootObject] Map.empty (Book Map.empty Map.empty)
  rootDigest <- maybe (fail "root digest absent from loaded closure") pure (Map.lookup rootObject digests)
  pure (syntheticMemberName rootDigest rootIndex,book)
  where
    go seen [] digests book = pure (digests,book)
    go seen (oid:rest) digests book
      | Set.member oid seen = go seen rest digests book
      | otherwise = do
          row <- trim <$> sqlite db ("SELECT o.type_id || '|' || h.base32 FROM object o JOIN hash h ON h.id=o.primary_hash_id WHERE o.id=" ++ show oid ++ ";")
          (tag,storedHash) <- case break (=='|') row of
            (tag,'|':hashText) -> pure (tag,hashText)
            _ -> fail "missing native object"
          if tag /= "4" then fail "non-Bend dependency in closure" else pure ()
          let blobPath = db ++ "-load-" ++ show oid ++ ".blob"
          _ <- sqlite db ("SELECT writefile(" ++ quote blobPath ++ ",bytes) FROM object WHERE id=" ++ show oid ++ ";")
          bytes <- Lazy.readFile blobPath
          let digest = sha3 (Lazy.toStrict bytes)
          if base32hex digest /= storedHash then fail "stored hash does not match Bend2 component bytes" else pure ()
          component <- either fail pure (decodeCanonicalComponentSynthetic digest bytes)
          merged <- mergeBooks book component
          dependencyRows <- lines <$> sqlite db
            ("SELECT DISTINCT dependency_object_id FROM dependents_index WHERE dependent_object_id=" ++ show oid ++
             " AND dependency_object_id IS NOT NULL;")
          let dependencies = map read dependencyRows
          go (Set.insert oid seen) (dependencies ++ rest) (Map.insert oid digest digests) merged

mergeBooks :: Book -> Book -> IO Book
mergeBooks (Book existingDefs existingHits) (Book defs hits)
  | not (Map.null (Map.intersection existingDefs defs)) = fail "duplicate synthetic definition"
  | not (Map.null (Map.intersection existingHits hits)) = fail "duplicate synthetic HIT"
  | otherwise = pure (Book (Map.union existingDefs defs) (Map.union existingHits hits))

sha3 :: Bytes.ByteString -> Bytes.ByteString
sha3 bytes = ByteArray.convert (hash bytes :: Digest SHA3_512)

base32hex :: Bytes.ByteString -> String
base32hex bytes = reverse (finish (Bytes.foldl' step (0,0,[]) bytes))
  where
    alphabet = "0123456789abcdefghijklmnopqrstuv"
    step (buffer,bits,out) byte = drain ((buffer `shiftL` 8) .|. fromIntegral byte) (bits+8) out
    drain buffer bits out
      | bits >= 5 =
          let nextBits = bits-5
              digit = (buffer `shiftR` nextBits) .&. 31
              remaining = buffer .&. ((1 `shiftL` nextBits)-1)
           in drain remaining nextBits (alphabet !! digit : out)
      | otherwise = (buffer,bits,out)
    finish (buffer,bits,out)
      | bits == 0 = out
      | otherwise = alphabet !! ((buffer `shiftL` (5-bits)) .&. 31) : out

quote :: String -> String
quote value = "'" ++ concatMap (\c -> if c == '\'' then "''" else [c]) value ++ "'"

trim :: String -> String
trim = reverse . dropWhile (`elem` "\r\n ") . reverse . dropWhile (`elem` "\r\n ")

sqlite :: FilePath -> String -> IO String
sqlite db sql = sqliteWithArgs [db,sql]

sqliteWithArgs :: [String] -> IO String
sqliteWithArgs args = do
  (status,out,err) <- readProcessWithExitCode "sqlite3" args ""
  case status of
    ExitSuccess -> pure out
    _ -> fail ("sqlite3 failed: " ++ err)

foldlM :: (a -> b -> IO a) -> a -> [b] -> IO a
foldlM _ initial [] = pure initial
foldlM f initial (x:xs) = f initial x >>= \next -> foldlM f next xs
