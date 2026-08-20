-- runghc -imachine machine/PramanyaCorpusRun.hs
-- Grades the BOOK's own chapters, and then the whole formal corpus, by
-- the rule in machine/Pramanya.hs.
import Pramanya
import PramanyaCorpus
import Anukramani (indexOf, eChapter, ePath)
import System.Directory (listDirectory, doesDirectoryExist)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)
import Data.List (isSuffixOf, sort, sortOn)

sourceIn :: FilePath -> IO [FilePath]
sourceIn d = do
  ok <- doesDirectoryExist d
  if not ok then return [] else do
    ns <- listDirectory d
    parts <- mapM (\n -> do
       let p = d ++ "/" ++ n
       isdir <- doesDirectoryExist p
       if isdir then sourceIn p
       else return [ p | ".agda" `isSuffixOf` n || ".hs" `isSuffixOf` n ]) ns
    return (sort (concat parts))

readUtf8 :: FilePath -> IO String
readUtf8 p = do
  h <- openFile p ReadMode; hSetEncoding h utf8
  s <- hGetContents h; length s `seq` return s

header :: String -> String
header = unlines . take 70 . lines

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8
  ps <- concat <$> mapM sourceIn ["formal/cubical", "machine"]
  bodies <- mapM (\p -> do b <- readUtf8 p; return (p, b)) ps
  let entries   = indexOf ps
      inChapter = [ ePath e | e <- entries, eChapter e /= Nothing ]
      hdrOf p   = header (maybe "" id (lookup p bodies))
      chapterCs = [ fileClaim p (hdrOf p) | p <- inChapter ]
      allCs     = [ fileClaim p (hdrOf p) | (p, _) <- bodies ]

  mapM_ putStrLn (renderCorpus "THE BOOK (files the anukramani places in a chapter)"
                               (report chapterCs))
  putStrLn ""
  putStrLn "  The gate fires only on files that INVOKE a source.  A module"
  putStrLn "  doing pure mathematics and citing no text is not penalised."
  putStrLn ""
  putStrLn "== chapter files that invoke a source and fail the gate =="
  let e = env chapterCs
      bad = sortOn cId [ c | c <- chapterCs, unfit c /= Nothing ]
  putStrLn ("  " ++ show (length bad) ++ " of " ++ show (length chapterCs))
  mapM_ (\c -> putStrLn ("    " ++ cId c ++ "\n        " ++ cText c))
        (take 25 bad)
  if length bad > 25 then putStrLn "    ..." else return ()
  putStrLn ""
  mapM_ putStrLn (renderCorpus "THE WHOLE FORMAL CORPUS" (report allCs))
