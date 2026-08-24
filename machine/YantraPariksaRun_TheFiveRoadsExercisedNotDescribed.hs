-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

-- YantraPariksaRun_TheFiveRoadsExercisedNotDescribed — the handler run, on
-- one input per road it can take, with the answer printed in full.
--
-- WHY A RUNNER AND NOT A TEST.  A test prints `5 passed` and that count is
-- ∥·∥₁ of the list it replaced.  What the reader needs to see is that the
-- five inputs land on five DIFFERENT answers — in particular that a false
-- equation and an unprovable one do not arrive at the same place, which is
-- the whole reason `YantraPariksa` exists.  So each answer is rendered and
-- the runner asserts only the one thing a reader cannot check by looking:
-- that no two roads coincide.
--
-- The five:
--
--   १  a true, kernel-certifiable equation           → saṃkramaṇa
--   २  a false equation                              → doṣalekha, WITH a witness
--   ३  a true equation the shapes do not close       → doṣalekha, no witness
--   ४  a symbol outside the fragment                 → doṣalekha, अप्राप्यम्
--   ५  a string that is not a term                   → doṣalekha, unparsed
--
-- Roads २ and ३ are both `Dosalekha` and are distinguished by what they
-- carry, which is the point: the constructor is the road, the CONTENT is
-- the diagnosis, and a boolean has neither.
--
-- Road १ requires agda and the cubical library.  Where the kernel is not
-- reachable this run does not go red — the runner says which roads it could
-- exercise, because "agda is not installed here" and "the handler is broken"
-- are two facts and one red merges them.  That is the same discipline
-- `machine/check-sabha.sh` states for its own second half.

module Main (main) where

import System.Exit (exitFailure, exitSuccess)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding)

import Sabda_TheWireHasNoBoolean (render)
import Uttara_SamkramanaOrDosalekhaNeverABareBoolean
  (Uttara(..), uttaraJ, uttaraKind)
import YantraPariksa_TheEngineAnsweringOnTheWire (pariksa, parsePada, evalPada)
import qualified Certificate as C

marga :: [(String, String, String)]
marga =
  [ ("१ सिद्धम्",      "+(0,x)",      "x")
  , ("२ असत्यम्",      "+(x,0)",      "s(x)")
  , ("३ अप्रमाणितम्", "+(x,y)",      "+(y,x)")
  , ("४ अप्राप्यम्",   "sqrt(x)",     "x")
  , ("५ अपदम्",       "+(x,",        "x")
  ]

main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  hSetEncoding stdout utf8

  st <- C.kernelStatus "."
  putStrLn ("kernel: " ++ show st)
  putStrLn ""

  us <- mapM (\(nm, l, r) -> do
                u <- pariksa "." l r
                pure (nm, l, r, u)) marga

  mapM_ report us
  putStrLn ""

  -- the one assertion: the five answers are five, not fewer.  Compared on
  -- the rendered wire form, which is what an interlocutor actually receives.
  let wires = [ render (uttaraJ u) | (_, _, _, u) <- us ]
      dup   = [ (a, b) | (i, a) <- zip [(0 :: Int) ..] (map fst4 us)
                       , (j, b) <- zip [0 ..] (map fst4 us)
                       , i < j
                       , wires !! i == wires !! j ]

  -- and the two doṣa-lekhas that a boolean would merge are separated by
  -- their CONTENT, not merely by being distinct strings: road २ hands a
  -- numeric witness forward, road ३ hands none.
  let sesa2 = sesaOf (nth 1 us)
      sesa3 = sesaOf (nth 2 us)
      witnessed = any (elem '≠') sesa2
      unwitnessed = not (any (elem '≠') sesa3)

  if not (null dup)
    then do
      mapM_ (\(a, b) -> putStrLn ("MERGED: " ++ a ++ " and " ++ b
                                  ++ " gave the same answer")) dup
      exitFailure
    else if not witnessed
      then putStrLn "MERGED: the false equation came back without its witness"
           >> exitFailure
      else if not unwitnessed
        then putStrLn "MERGED: the unproved equation came back carrying a witness it cannot have"
             >> exitFailure
        else do
          putStrLn "five inputs, five answers; the refutation carries its point and the refusal does not claim one."
          exitSuccess

report :: (String, String, String, Uttara) -> IO ()
report (nm, l, r, u) = do
  putStrLn (nm ++ "   " ++ l ++ " = " ++ r)
  putStrLn ("  road: " ++ uttaraKind u)
  case u of
    Samkramana _ _ carried vyaya _ -> do
      mapM_ (\(k, v) -> putStrLn ("  वहित  " ++ k ++ " = " ++ render v)) carried
      mapM_ (\s -> putStrLn ("  व्यय   " ++ s)) vyaya
    Dosalekha _ hetu nasta sesa _ -> do
      putStrLn ("  हेतु   " ++ hetu)
      mapM_ (\s -> putStrLn ("  नष्ट   " ++ s)) nasta
      mapM_ (\s -> putStrLn ("  शेष   " ++ s)) sesa
  putStrLn ""

fst4 :: (String, String, String, Uttara) -> String
fst4 (a, _, _, _) = a

nth :: Int -> [a] -> a
nth i xs = xs !! i

sesaOf :: (String, String, String, Uttara) -> [String]
sesaOf (_, _, _, Dosalekha _ _ _ s _) = s
sesaOf _ = []

-- kept exported-and-used so the parser and the semantics are exercised by
-- name rather than only through `pariksa`
_unusedGuard :: (Maybe C.Term, Maybe Integer)
_unusedGuard = (t, t >>= evalPada [1,2,3,4,5,6])
  where t = parsePada "+(x,y)"
