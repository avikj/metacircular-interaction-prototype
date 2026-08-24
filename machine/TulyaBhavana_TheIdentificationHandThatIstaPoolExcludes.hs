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

-- तुल्यभावना — TulyaBhavana: the second hand, and why the first one alone
-- reached nothing the kernel asked for.
--
-- BRAHMAGUPTA, Brāhmasphuṭasiddhānta 18 (628), states his composition rule in
-- TWO cases, and the tradition names them separately:
--
--   समासभावना  samāsa-bhāvanā — compose two DIFFERENT solutions.
--   तुल्यभावना  tulya-bhāvanā  — compose a solution WITH ITSELF.
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE.  This does not claim that
-- Brahmagupta wrote a superposition rule for equations, or that he
-- considered term algebras at all.  What is his is the SHAPE of the move
-- — two established results in, a third out, the invariant carried by
-- algebra rather than checked by a test — and the two names for its two
-- cases.  The transcription into equations is machine/BhavanaTheorem.hs's;
-- this file adds one operation to it and measures what that operation
-- reaches.  Nor is it claimed that identification is the only thing
-- missing: the run below names every demand it does not reach.
--
-- The second is not a degenerate case of the first.  It is the only move
-- available when you hold exactly one solution, which is the situation the
-- cakravāla starts in, and `machine/Nalanda.hs` carries it under that name:
--
--     tulya d t = bhavana d t t
--
-- WHAT THIS FILE MEASURES.  `machine/BhavanaTheorem.hs` implements
-- samāsa-bhāvanā for the machine's own theorems — two equations in, a third
-- out, nothing tested — and `machine/TwoHands.hs` runs it against the lemmas
-- the Agda kernel actually stalled on and recorded in machine/machine.log.
-- That run's result, reproduced here as the control arm:
--
--     samāsa produced                     3109
--     prakṣepa of base produced           1317
--     prakṣepa of composites produced   101809
--     distinct truths reachable          99345
--     lemmas the kernel demanded             9
--       already known outright               3
--       reached by the two hands             0     <---
--       still out of reach                   6
--
-- Ninety-nine thousand true equations, and not one of the six the kernel was
-- waiting for.  That is the number this file exists to explain, because the
-- explanation is not "composition is weak."
--
-- THE FIRST MISS IS ONE STEP AWAY.  The kernel demanded
--
--     x = x + (0 · x)
--
-- and the base holds both halves of it: `x = x + 0` (library.terms line 135)
-- and `0 = 0 · x` (line 3).  `composePair` rewrites the `0` in `x + 0` by the
-- second equation read right-to-left and returns
--
--     x = x + (0 · y)
--
-- with `y` fresh, because `renameApart` — correctly, for samāsa — makes the
-- two equations share no variable.  The demanded lemma is that equation with
-- y and x IDENTIFIED.  Identification is tulya-bhāvanā.
--
-- AND THE POOL FORBIDS IT, IN ONE CONJUNCT.  `BhavanaTheorem.istaPool` is
--
--     istaPool eqs = nub [ u | ... , tsize u <= 3, not (isVar u) ]
--
-- so prakṣepa may substitute any small non-variable term for a variable and
-- may never substitute a VARIABLE for a variable.  Every instance it can
-- form keeps distinct variables distinct.  The samāsa hand separates
-- variables and the prakṣepa hand cannot put them back together, so the
-- pair of hands is closed under a restriction neither of them announces.
--
-- WHAT IS ADDED HERE.  One operation, `tulya`: for each equation and each
-- pair of its distinct variables, the instance identifying them.  It is a
-- SPECIALISATION of a theorem, so it is true whenever its input is, by
-- substitution alone — the same reason `composePair`'s outputs are true, and
-- it is tested here for the same reason: to check THIS FILE, not the
-- mathematics.
--
-- WHAT IS NOT CLAIMED.  This does not claim that Brahmagupta wrote a
-- superposition rule for equations, or that he considered term algebras
-- at all: what is his is the SHAPE of the move — two established results
-- in, a third out, the invariant carried by algebra and not by a test —
-- and the two names for its two cases.  The transcription into equations
-- is `machine/BhavanaTheorem.hs`'s and this file is one operation added to
-- it.  It is also not claimed that identification is the only thing
-- missing; the
-- run below reports exactly which of the six misses it reaches and which it
-- does not, and the ones it does not are named.  Nor that reaching a demanded
-- lemma as a composed equation means the Agda kernel will discharge it: the
-- kernel is the authority and this file never calls it.
--
-- EXACT, and no clock is read: every number printed is a set cardinality.
--
-- Build and run, from the repository root:
--
--     runghc -imachine machine/TulyaBhavana_TheIdentificationHandThatIstaPoolExcludes.hs

import qualified BhavanaTheorem as B
import qualified Obstruction as OB
import Data.List (isInfixOf, nub)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import System.IO

canon :: (B.Term, B.Term) -> (B.Term, B.Term)
canon (l, r) =
  let m = M.fromList (zip (nub (varsOf l ++ varsOf r)) [0 ..])
      f (B.V i) = B.V (M.findWithDefault i i m)
      f (B.F g ts) = B.F g (map f ts)
      (a, b) = (f l, f r)
  in if a <= b then (a, b) else (b, a)

varsOf :: B.Term -> [Int]
varsOf (B.V i) = [i]
varsOf (B.F _ ts) = concatMap varsOf ts

fromOb :: OB.Term -> B.Term
fromOb (OB.V i) = B.V i
fromOb (OB.F f ts) = B.F f (map fromOb ts)

-- तुल्यभावना.  For every equation and every ordered pair of distinct
-- variables in it, the instance that identifies the two.  A specialisation of
-- a true equation is true; nothing is searched and nothing is tested.
tulya :: [(B.Term, B.Term)] -> [(B.Term, B.Term)]
tulya eqs =
  S.toList (S.fromList
    [ (B.applySubst s l, B.applySubst s r)
    | (l, r) <- eqs
    , let vs = nub (varsOf l ++ varsOf r)
    , i <- vs, j <- vs, i /= j
    , let s = M.singleton i (B.V j)
    , B.applySubst s l /= B.applySubst s r ])

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hl <- openFile "machine/machine.log" ReadMode
  hSetEncoding hl utf8
  ls <- lines <$> hGetContents hl
  hb <- openFile "machine/library.terms" ReadMode
  hSetEncoding hb utf8
  lib <- hGetContents hb
  let rejects  = [ l | l <- ls, "KERNEL-REJECT" `isInfixOf` l ]
      demanded = S.toList (S.fromList
                   [ canon (fromOb a, fromOb b)
                   | (p, _) <- OB.curriculum rejects, let (a, b) = p ])
      base     = nub (B.parseLibraryPublic lib ++ B.definingEquations)
      pool     = B.istaPool base
      composed = B.bhavana base
      inst0    = B.praksepa pool base
      inst1    = B.praksepa pool composed
      -- the two hands, exactly as machine/TwoHands.hs has them
      twoHands = composed ++ inst0 ++ inst1
      -- the third hand: identification, applied to everything the first two
      -- produced as well as to the base
      tulyaOf  = tulya (base ++ twoHands)
      known    = S.fromList (map canon base)
      reach2   = S.fromList (map canon twoHands)
      reach3   = S.union reach2 (S.fromList (map canon tulyaOf))
      hitK     = [ g | g <- demanded, S.member g known ]
      rest     = [ g | g <- demanded, not (S.member g known) ]
      hit2     = [ g | g <- rest, S.member g reach2 ]
      hit3     = [ g | g <- rest, not (S.member g reach2), S.member g reach3 ]
      miss3    = [ g | g <- rest, not (S.member g reach3) ]
      -- the implementation check.  A composed or identified equation cannot be
      -- false if its inputs are true, so a disagreement with the vocabulary's
      -- semantics is a defect in this file or in BhavanaTheorem, never in
      -- Brahmagupta.  Sampled over the identified set, which is what is new
      -- here; BhavanaTheorem.selfTest already covers its own outputs.
      bad = [ e | e <- tulyaOf, not (B.semanticsAgree e) ]
  putStrLn "तुल्यभावना — the identification hand, against the kernel's own demands."
  putStrLn ""
  putStrLn ("  base facts (theorems + axioms):     " ++ show (length base))
  putStrLn ("  ista pool (chosen values):          " ++ show (length pool))
  putStrLn ("  samasa produced:                    " ++ show (length composed))
  putStrLn ("  praksepa of base produced:          " ++ show (length inst0))
  putStrLn ("  praksepa of composites produced:    " ++ show (length inst1))
  putStrLn ("  TULYA produced (new here):          " ++ show (length tulyaOf))
  putStrLn ""
  putStrLn ("  distinct truths, two hands:         " ++ show (S.size reach2))
  putStrLn ("  distinct truths, three hands:       " ++ show (S.size reach3))
  putStrLn ""
  putStrLn ("  lemmas the kernel demanded:         " ++ show (length demanded))
  putStrLn ("    already known outright:           " ++ show (length hitK))
  putStrLn ("    reached by samasa + praksepa:     " ++ show (length hit2))
  putStrLn ("    reached ONLY with tulya:          " ++ show (length hit3))
  putStrLn ("    still out of reach:               " ++ show (length miss3))
  putStrLn ""
  putStrLn ("  implementation check -- identified equations disagreeing with"
            ++ " the semantics: " ++ show (length bad)
            ++ "  (must be 0: a specialisation of a truth is a truth)")
  putStrLn ""
  putStrLn "  -- reached only with tulya --"
  mapM_ (\(a,b) -> putStrLn ("     " ++ show a ++ " = " ++ show b)) hit3
  putStrLn ""
  putStrLn "  -- still out of reach, with all three hands --"
  mapM_ (\(a,b) -> putStrLn ("     " ++ show a ++ " = " ++ show b)) miss3
