-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- runghc -imachine machine/SamshayaRun.hs
import Samshaya
import Naya (Naya(..), Verdict(..), decide)
import System.Directory (listDirectory)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)
import Data.List (isSuffixOf, isInfixOf, sort, sortOn)

readUtf8 :: FilePath -> IO String
readUtf8 p = do
  h <- openFile p ReadMode; hSetEncoding h utf8
  s <- hGetContents h; length s `seq` return s

extract :: FilePath -> String -> [Item]
extract fp src =
  let ls = lines src
  in [ Item fp n tg (unwords (take 3 (drop (n - 1) ls)))
     | (n, l) <- zip [1 ..] ls, Just tg <- [tagOf l] ]
  where
    tagOf l | "PROVE"       `isInfixOf` l = Just Prove
            | "SEARCH"      `isInfixOf` l = Just Search
            | "DEMONSTRATE" `isInfixOf` l = Just Demonstrate
            | otherwise                   = Nothing

-- The optimisation check.  `distinct` groups by content set; the
-- DEFINITION is `sameDoubt`, which calls Naya.decide.  Verify they agree
-- on every pair drawn from a sample before trusting any number below.
checkEquivalence :: [Item] -> (Int, Int)
checkEquivalence its =
  let s = take 60 its
      pairs = [ (a, b) | (i, a) <- zip [0 :: Int ..] s, (j, b) <- zip [0 ..] s, i < j ]
      ok = length [ () | (a, b) <- pairs
                  , sameDoubt a b == (contentWords (itText a) == contentWords (itText b)) ]
  in (ok, length pairs)

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8
  ns <- listDirectory "notes"
  let mds = sort [ "notes/" ++ n | n <- ns, ".md" `isSuffixOf` n ]
  its <- concat <$> mapM (\p -> extract p <$> readUtf8 p) mds
  let (ok, tot) = checkEquivalence its
  putStrLn ("optimisation check: sameDoubt agrees with the grouping key on "
            ++ show ok ++ " of " ++ show tot ++ " sampled pairs")
  if ok /= tot
    then putStrLn "DISAGREEMENT -- refusing to print the survey."
    else do
      let s = survey its
      putStrLn ""
      mapM_ putStrLn (render s)
      putStrLn ""
      putStrLn "== buckets holding more than one tag (one doubt, said twice) =="
      let big = filter ((> 1) . length) (sortOn (negate . length) (sBuckets s))
      putStrLn ("  buckets with >1 member: " ++ show (length big))
      mapM_ (\b -> do
               putStrLn ""
               putStrLn ("  bucket of " ++ show (length b) ++ ":")
               mapM_ (\i -> putStrLn ("    " ++ itFile i ++ ":" ++ show (itLine i)))
                     (take 5 b))
            (take 8 big)
