-- Generate the book's index.  Run from the repository root:
--     runghc -imachine machine/AnukramaniRun.hs > BOOK_INDEX.md
import Anukramani
import System.Directory (listDirectory, doesDirectoryExist)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)
import Data.List (isSuffixOf, sort)

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

main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  hSetEncoding stdout utf8
  ps <- concat <$> mapM sourceIn ["formal/cubical", "machine"]
  mapM_ putStrLn (render (indexOf ps))
