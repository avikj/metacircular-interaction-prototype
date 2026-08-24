-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

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

-- | Prose belonging to a chapter: the same classifier over notes/*.md.
--   ADDED 2026-08-20, cf-archivist, and the reason matters more than the code.
--
--   The owner's directive this program implements (f0a9c28c) is: "this is a
--   book about India and nothing else -- translation and scholarship primary,
--   the Agda/Haskell/HCI work an APPENDIX."  The program scanned
--   ["formal/cubical","machine"] for .agda and .hs, and reported the result as
--   "the book is N% of this corpus."
--
--   So the instrument built to keep scholarship primary could see only the
--   appendix.  The 3,337 markdown files were not in the denominator OR the
--   numerator, and the one way to move the number was to write more Agda --
--   which is the behaviour the frame exists to correct.
--
--   This does NOT redefine the headline ratio; that number is the owner's
--   diagnostic and moving it is not mine to do, least of all by a change that
--   would count my own night's notes.  The prose is reported SEPARATELY and
--   labelled, and the output says the two must not be summed.
prose :: FilePath -> IO [FilePath]
prose d = do
  ok <- doesDirectoryExist d
  if not ok then return [] else do
    ns <- listDirectory d
    return (sort [ d ++ "/" ++ n | n <- ns, ".md" `isSuffixOf` n ])

main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  hSetEncoding stdout utf8
  ps <- concat <$> mapM sourceIn ["formal/cubical", "machine"]
  mapM_ putStrLn (render (indexOf ps))
  ms <- prose "notes"
  let pes     = indexOf ms
      placed  = [ e | e <- pes, eChapter e /= Nothing ]
  putStrLn ""
  putStrLn "## Prose in the chapters — reported separately, and NOT to be added"
  putStrLn ""
  putStrLn "The ratio above counts `.agda` and `.hs` under `formal/cubical` and"
  putStrLn "`machine` only. It is a statement about the APPENDIX, and the frame"
  putStrLn "it serves says the appendix is not the book. These two figures have"
  putStrLn "different denominators and different meanings; summing them, or"
  putStrLn "quoting either as \"the book is N% of the repository\", is wrong."
  putStrLn ""
  putStrLn ("  notes/*.md scanned            : " ++ show (length ms))
  putStrLn ("  reaching a chapter by its key : " ++ show (length placed))
  putStrLn ""
  putStrLn "A note that reaches no chapter is not thereby apparatus -- the keys"
  putStrLn "are filename substrings, so a chapter's scholarship under an English"
  putStrLn "title is invisible here exactly as it was invisible in the code scan."
  putStrLn "This count is a lower bound and is only worth reading as one."
  mapM_ (\e -> putStrLn ("    ch " ++ maybe "?" show (eChapter e) ++ "  " ++ ePath e))
        placed
