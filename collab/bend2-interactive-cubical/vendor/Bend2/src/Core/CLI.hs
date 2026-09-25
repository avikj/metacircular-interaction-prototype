module Core.CLI 
  ( parseFile
  , checkDefinitions
  , runMain
  , processFile
  , processFileToJS
  , processFileToHVM
  , processFileToHVM4
  , processFileToHVM4Raw
  , processFileToHVM4Full
  , processFileInteract
  , processFileCheckNet
  , processFileTotal
  , listDependencies
  ) where

import Control.Monad (unless, forM_)
import qualified Data.Map as M
import qualified Data.Set as S
import System.Environment (getArgs, lookupEnv)
import System.Exit (exitFailure)
import System.Process (readProcessWithExitCode, createProcess, proc, CreateProcess(..), StdStream(..), waitForProcess)
import System.Exit (ExitCode(..))
import Control.Exception (catch, finally, evaluate, IOException)
import GHC.IO.Handle (hDuplicate, hDuplicateTo)
import System.IO (stdout, stderr, hFlush, hSetBuffering, BufferMode(..), hGetLine, hPutStrLn, hPutStr, hClose, isEOF, openTempFile)

import Core.Bind
import Core.Adjust (hitify)
import Core.Check
import Core.Collapse
import Core.Deps
import Core.Import (autoImport, mergeBooks)
import System.Directory (doesFileExist, getTemporaryDirectory, removeFile)
import Core.Equal (equal)
import Core.Parse.Book (doParseBook)
import Core.Analysis
import qualified Target.HVM4Full as HVM4Full
import Core.Totality
import Core.Type
import Core.WHNF

import qualified Target.JavaScript as JS
import qualified Target.HVM as HVM
import qualified Target.HVM4 as HVM4

-- | Parse a Bend file into a Book. A line `import Path/To/File` (no alias)
-- loads that file's definitions, unqualified, first from the importing
-- file's directory and then from the working directory — a module, so a
-- library file can be shared by many files instead of one file per name.
parseFile :: FilePath -> IO Book
parseFile file = do
  book <- loadFile S.empty file
  autoImport (takeDirectory file) book
  where
    takeDirectory path = reverse . dropWhile (/= '/') . reverse $ path

loadFile :: S.Set FilePath -> FilePath -> IO Book
loadFile visited file = do
  content <- readFile file
  let (loads, content') = splitLoads content
      dir = reverse . dropWhile (/= '/') . reverse $ file
  case doParseBook file content' of
    Left err -> do
      putStrLn $ err
      exitFailure
    Right book -> do
      deps <- mapM (loadDep dir) loads
      -- constructors of HITs declared in an imported module are only
      -- recognisable once the modules are merged: convert them now
      let merged = foldl mergeBooks book deps
      return (rehitify merged)
  where
    visited' = S.insert file visited
    loadDep dir p = do
      let local = dir ++ p ++ ".bend"
          cwd   = p ++ ".bend"
      lExists <- doesFileExist local
      let path = if lExists then local else cwd
      if path `S.member` visited' then return (Book M.empty M.empty) else do
        exists <- doesFileExist path
        if not exists
          then do putStrLn ("import: file not found: " ++ path); exitFailure
          else loadFile visited' path

rehitify :: Book -> Book
rehitify book@(Book defs hits) = Book (M.map (\(i, t, ty) -> (i, hitify book t, hitify book ty)) defs) hits

-- an `import X` line without `as` is a module load; it is blanked (line
-- numbers preserved) so the parser only sees aliased imports
splitLoads :: String -> ([String], String)
splitLoads src = (concatMap fst ls, unlines (map snd ls))
  where
    ls = map one (lines src)
    one l = case words l of
      ["import", p] -> ([p], "")
      _             -> ([], l)

-- | Type-check all definitions in a book
checkDefinitions :: Book -> IO ()
checkDefinitions book@(Book defs hits) = do
  okHits  <- checkHits book (M.toList hits)
  success <- checkAll book (M.toList defs)
  unless okHits exitFailure
  unless success exitFailure
  where
    checkDef book term typ = do
      check 0 noSpan book (Ctx []) typ Set
      check 0 noSpan book (Ctx []) term typ
      return ()
    checkAll :: Book -> [(Name, Defn)] -> IO Bool
    checkAll _ [] = return True
    checkAll bBook ((name, (_, term, typ)):rest) = do
      case checkDef bBook term typ of
        Done () -> do
          putStrLn $ "\x1b[32m✓ " ++ name ++ "\x1b[0m " ++ reportLine (analyze bBook name term typ)
          checkAll bBook rest
        Fail e -> do
          putStrLn $ "\x1b[31m✗ " ++ name ++ "\x1b[0m"
          putStrLn $ show e
          _ <- checkAll bBook rest
          return False

-- | Check every HIT declaration: the parameter telescope is a type, and each
-- constructor's closed Pi-type is a type (which checks its fields and, for a
-- path constructor, that its endpoints inhabit the HIT).
checkHits :: Book -> [(Name, HitDecl)] -> IO Bool
checkHits _ [] = return True
checkHits book ((name, h) : rest) = do
  let r = do
        check 0 noSpan book (Ctx []) (hitType h) Set
        mapM_ (\(_, k) -> check 0 noSpan book (Ctx []) (ctorType k) Set) (hitCtors h)
  case r of
    Done () -> do
      putStrLn $ "\x1b[32m✓ " ++ name ++ "\x1b[0m [HIT: " ++ unwords [ "@" ++ c ++ (if ctorDim k > 0 then "/" ++ show (ctorDim k) else "") | (c, k) <- hitCtors h ] ++ "]"
      checkHits book rest
    Fail e -> do
      putStrLn $ "\x1b[31m✗ " ++ name ++ "\x1b[0m"
      putStrLn $ show e
      _ <- checkHits book rest
      return False

-- | Run the main function from a book
runMain :: Book -> IO ()
runMain book = do
  case deref book "main" of
    Nothing -> do
      return ()
    Just _ -> do
      let mainCall = Ref "main"
      case infer 0 noSpan book (Ctx []) mainCall of
        Fail e -> do
          putStrLn $ show e
          exitFailure
        Done typ -> do
          let results = flatten $ collapse 0 book $ normalCap 400 0 book mainCall
          putStrLn ""
          forM_ results $ \ term -> do
            print term

-- | Process a Bend file: parse, check, and run
processFile :: FilePath -> IO ()
processFile file = do
  book <- parseFile file
  checkDefinitions book
  runMain book

-- | Try to format JavaScript code using prettier if available
formatJavaScript :: String -> IO String
formatJavaScript jsCode = do
  -- Try npx prettier first
  tryPrettier "npx" ["prettier", "--parser", "babel"] jsCode
    `catch` (\(_ :: IOException) -> 
      -- Try global prettier
      tryPrettier "prettier" ["--parser", "babel"] jsCode
        `catch` (\(_ :: IOException) -> return jsCode))
  where
    tryPrettier cmd args input = do
      (exitCode, stdout, stderr) <- readProcessWithExitCode cmd args input
      case exitCode of
        ExitSuccess -> return stdout
        _ -> return input

-- | Process a Bend file and compile to JavaScript
processFileToJS :: FilePath -> IO ()
processFileToJS file = do
  book <- parseFile file
  let jsCode = JS.compile book
  formattedJS <- formatJavaScript jsCode
  putStrLn formattedJS

-- | Process a Bend file and compile to HVM
processFileToHVM :: FilePath -> IO ()
processFileToHVM file = do
  book <- parseFile file
  let hvmCode = HVM.compile book
  putStrLn hvmCode

-- | Process a Bend file and compile to HVM4 surface syntax
processFileToHVM4 :: FilePath -> IO ()
processFileToHVM4 file = do
  book <- parseFile file
  putStrLn (HVM4.compile book)

-- | Compile to HVM4 WITHOUT compile-time normalisation (net does the work)
processFileToHVM4Raw :: FilePath -> IO ()
processFileToHVM4Raw file = do
  book <- parseFile file
  putStrLn (HVM4.compileRaw book)

-- | List all dependencies of a Bend file (including transitive dependencies)
listDependencies :: FilePath -> IO ()
listDependencies file = do
  -- Parse and auto-import the file
  book <- parseFile file
  -- Collect all refs from the fully imported book
  let allRefs = collectAllRefs book
  -- Print all refs (these are all the dependencies)
  mapM_ putStrLn (S.toList allRefs)

-- | Collect all refs from a Book
collectAllRefs :: Book -> S.Set Name
collectAllRefs (Book defs _) = 
  S.unions $ map collectRefsFromDefn (M.elems defs)
  where
    collectRefsFromDefn (_, term, typ) = S.union (getDeps term) (getDeps typ)

-- | Gated mode: check everything, then refuse the file if any definition is
-- [unchecked] by the totality classifier (structural descent / guarded
-- corecursion are the only accepted shapes).
processFileTotal :: FilePath -> IO ()
processFileTotal file = do
  book@(Book defs _) <- parseFile file
  checkDefinitions book
  let bad = [ name | (name, (_, term, typ)) <- M.toList defs
                   , Unchecked <- [rTot (analyze book name term typ)] ]
  if null bad
    then putStrLn "\x1b[32m--total: every definition is [total] or [productive]\x1b[0m"
    else do
      putStrLn $ "\x1b[31m--total: refused, [unchecked]: " ++ unwords bad ++ "\x1b[0m"
      exitFailure

-- | Compile to HVM4 with the FULL cubical runtime (intervals, paths, types,
-- coe and hcomp are all runtime objects; nothing erased or pre-normalised)
processFileToHVM4Full :: FilePath -> IO ()
processFileToHVM4Full file = do
  book <- parseFile file
  -- Only a checked book is a complex: an ill-typed term has no cells to emit.
  -- The check report goes to stderr so stdout stays exactly the HVM4 program.
  hFlush stdout
  saved <- hDuplicate stdout
  hDuplicateTo stderr stdout
  checkDefinitions book `finally` (hFlush stdout >> hDuplicateTo saved stdout)
  -- emit all or nothing: a refused cell must not leave a partial program
  let prog = HVM4Full.compileFull book
  _ <- evaluate (length prog)
  putStrLn prog


-- | Checking on the net (One §14, the verify projection): the program is the
-- book's cells, the checker's cells, and a root that runs the checker over
-- every definition of the file: (its code, its type's code, its book id).
-- The runtime prints one (book id, result) per definition, in this order
-- (0 checks, 1 mismatch, 2 cannot infer, 3 not yet on the net).
processFileCheckNet :: FilePath -> FilePath -> IO ()
processFileCheckNet file checker = do
  Book defs hits  <- parseFile file
  Book cdefs _    <- parseFile checker
  let merged = Book (M.union defs cdefs) hits
      entry n = "#Pair{@@code(@" ++ HVM4Full.defName n ++ "), #Pair{@@code(@" ++ HVM4Full.typeName n ++ "), @@idof(@" ++ HVM4Full.defName n ++ ")}}"
      table   = foldr (\n acc -> "#Con{" ++ entry n ++ ", " ++ acc ++ "}") "#Nil" (M.keys defs)
      list xs = foldr (\x acc -> "#Con{" ++ x ++ ", " ++ acc ++ "}") "#Nil" xs
      -- the prelude's references the checker reads in static code, and the
      -- runtime cells it builds with (in Check.bend's order)
      preIds  = list [ "@@idof(@" ++ f ++ ")" | f <- ["inot", "iand", "ior", "pathAt", "coe", "hcomp", "glueT", "glue", "unglue", "trec", "srec", "pout", "transp", "outS", "qrec", "pow", "u64ToChar", "pbndL"] ]
      cells   = list ["#CompU{0, 0}", "#UaU{0, 0, 0, 0, 0, 0}", "#PLm{0}", "#Itv", "#I0", "#I1", "#Path{0, 0, 0}", "#Cons{0, 0}", "#Face{0, 0}", "#GFace{0, 0, 0}", "#INot{0}", "#IAnd{0, 0}", "#IOr{0, 0}"]
      prog    = HVM4Full.compileCells merged ++ "@main = @" ++ HVM4Full.defName "Chk/all" ++ "(" ++ table ++ ")(" ++ preIds ++ ")(" ++ cells ++ ")\n"
  _ <- evaluate (length prog)
  putStrLn prog

-- | A machine that asks (One §7).  The runtime keeps its heap and the current
-- typed point; each question names a map f : A -> B of the program, checked
-- here against the point's type, and the answer is the law's step `present`:
-- (A, a) becomes (Σ b:B. fiber f b, (f a, (a, refl))), whose type is tracked
-- for the next question.  Input lines: NAME (ask), :type, or EOF.
processFileInteract :: FilePath -> IO ()
processFileInteract file = do
  book@(Book defs _) <- parseFile file
  hFlush stdout
  saved <- hDuplicate stdout
  hDuplicateTo stderr stdout
  checkDefinitions book `finally` (hFlush stdout >> hDuplicateTo saved stdout)
  mainTy <- case M.lookup "main" defs of
    Just (_, _, ty) -> return ty
    Nothing         -> hPutStrLn stderr "interact: no main" >> exitFailure
  let prog = HVM4Full.compileFull book
  _ <- evaluate (length prog)
  tmp       <- getTemporaryDirectory
  (path, h) <- openTempFile tmp "interact.hvm4"
  hPutStr h prog >> hClose h
  hvm <- maybe "hvm" id <$> lookupEnv "HVM"
  (Just hin, Just hout, _, ph) <-
    createProcess (proc hvm [path, "--interact"]) { std_in = CreatePipe, std_out = CreatePipe }
  hSetBuffering hin LineBuffering
  hSetBuffering stdout LineBuffering
  let answer = do
        l <- hGetLine hout
        putStrLn l
        unless (l == "- End") answer
      refuse m = putStrLn ("! " ++ m) >> putStrLn "- End"
      loop ty = do
        eof <- isEOF
        unless eof $ do
          q <- filter (/= '\r') <$> getLine
          case words q of
            []        -> loop ty
            [":type"] -> putStrLn (show ty) >> putStrLn "- End" >> loop ty
            [name]    -> case M.lookup name defs of
              Nothing -> refuse ("no definition " ++ name) >> loop ty
              Just (_, _, fty) -> case cut (force book fty) of
                All dom cod ->
                  let cb = case cut cod of { Lam _ b -> b depMarker ; _ -> App cod depMarker }
                  in if occursDep cb
                       then refuse (name ++ " is a dependent map; only non-dependent maps are asked yet") >> loop ty
                     else if not (equal 0 book dom ty)
                       then refuse (name ++ " expects " ++ show dom ++ ", the point has type " ++ show ty) >> loop ty
                     else do
                       -- One §1: present a = (f a, (a, refl)) : Σ b:B. fiber f b,
                       -- as a Core term over the typed point, through the one emitter
                       let f     = Ref name
                           ty'   = Sig cb (Lam "b" (\b -> Sig ty (Lam "x" (\x -> Pth (Lam "_" (\_ -> cb)) (App f x) b))))
                           step  = Lam "pt" (\pt -> SigM pt (Lam "A" (\_ -> Lam "a" (\a ->
                                     Tup ty' (Tup (App f a) (Tup a (PLm "i" (\_ -> App f a))))))))
                       hPutStrLn hin (HVM4Full.emitFull book step)
                       answer
                       loop ty'
                _ -> refuse (name ++ " is not a map") >> loop ty
            _ -> refuse "usage: NAME | :type" >> loop ty
  answer
  loop mainTy
  hClose hin
  _ <- waitForProcess ph
  removeFile path
