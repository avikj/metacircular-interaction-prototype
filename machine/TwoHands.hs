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

-- TwoHands -- run with: runghc -imachine machine/TwoHands.hs
-- Generation with two hands: samasa (compose two facts) and praksepa
-- (instantiate one fact at a chosen value).  How much of the kernel's
-- demanded curriculum falls out, with no term enumeration anywhere?
--
-- The previous attempt composed over the INSTANTIATED set -- ~5000 equations,
-- 25M pairs -- and was killed at 1800s.  That was not Brahmagupta's shape:
-- the cakravala composes the base with the trivial triple and instantiates,
-- it does not compose instances of instances.  Fixed here, and dedup moved
-- from nub (quadratic) to Set.
import qualified BhavanaTheorem as B
import qualified Obstruction as OB
import Data.List (isInfixOf, nub)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import System.IO

canon :: (B.Term, B.Term) -> (B.Term, B.Term)
canon (l, r) =
  let m = M.fromList (zip (nub (vars l ++ vars r)) [0 ..])
      f (B.V i) = B.V (M.findWithDefault i i m)
      f (B.F g ts) = B.F g (map f ts)
      (a, b) = (f l, f r)
  in if a <= b then (a, b) else (b, a)
  where
    vars (B.V i) = [i]
    vars (B.F _ ts) = concatMap vars ts

fromOb :: OB.Term -> B.Term
fromOb (OB.V i) = B.V i
fromOb (OB.F f ts) = B.F f (map fromOb ts)

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hl <- openFile "machine/machine.log" ReadMode
  hSetEncoding hl utf8
  ls <- lines <$> hGetContents hl
  hb <- openFile "machine/library.terms" ReadMode
  hSetEncoding hb utf8
  lib <- hGetContents hb
  let rejects   = [ l | l <- ls, "KERNEL-REJECT" `isInfixOf` l ]
      demanded  = S.toList (S.fromList
                    [ canon (fromOb a, fromOb b)
                    | (p, _) <- OB.curriculum rejects, let (a, b) = p ])
      base      = nub (B.parseLibraryPublic lib ++ B.definingEquations)
      pool      = B.istaPool base
      composed  = B.bhavana base                       -- samasa, base only
      inst0     = B.praksepa pool base                 -- praksepa of the base
      inst1     = B.praksepa pool composed             -- praksepa of composites
      known     = S.fromList (map canon base)
      reach     = S.fromList (map canon (composed ++ inst0 ++ inst1))
      hitK      = [ g | g <- demanded, S.member g known ]
      hitR      = [ g | g <- demanded, not (S.member g known), S.member g reach ]
      miss      = [ g | g <- demanded, not (S.member g known), not (S.member g reach) ]
  putStrLn ("  base facts (theorems + axioms):     " ++ show (length base))
  putStrLn ("  ista pool (chosen values):          " ++ show (length pool))
  putStrLn ("  samasa produced:                    " ++ show (length composed))
  putStrLn ("  praksepa of base produced:          " ++ show (length inst0))
  putStrLn ("  praksepa of composites produced:    " ++ show (length inst1))
  putStrLn ("  distinct truths reachable:          " ++ show (S.size reach))
  putStrLn ""
  putStrLn ("  lemmas the kernel demanded:         " ++ show (length demanded))
  putStrLn ("    already known outright:           " ++ show (length hitK))
  putStrLn ("    reached by the two hands:         " ++ show (length hitR))
  putStrLn ("    still out of reach:               " ++ show (length miss))
  putStrLn ("  COVERAGE: " ++ show (length hitK + length hitR)
            ++ " of " ++ show (length demanded))
  putStrLn ""
  putStrLn "  -- still out of reach, the first eight --"
  mapM_ (\(a,b) -> putStrLn ("     " ++ show a ++ " = " ++ show b)) (take 8 miss)
