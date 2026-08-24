-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Pañcāvayava — पञ्चावयव, the five-membered inference: nothing leaves this
-- module as established without an EXAMPLE in which the pervasion was
-- exhibited, and without its pramāṇa attached.
--
-- ================================================================ THE DEFECT
--
-- `machine/Pramana.hs` records HOW a claim was established — the pramāṇa, the
-- naya, the delimitor, the round — and it is the right record.  What it does
-- not do is REFUSE.  Any caller can build a `Justification` and pair it with
-- anything; the record is a field, not a gate.  So the engine can still hold a
-- claim whose justification is a well-formed description of a proof nobody
-- exhibited, which is the same shape as `ANEKANTA.md` §19's `Khandita at []`:
-- a verdict asserting a witness it does not have.
--
-- And separately, `MathMachine`'s conjecture generator declares two terms
-- equal because forty evaluations agreed (`ANEKANTA.md` §12), with the
-- coverage measured at 0.61% of the box at arity four.  Forty agreements are
-- forty instances.  Instances are not a pervasion, and the difference has a
-- name.
--
-- =========================================================== NYĀYA'S FIVE
--
-- Gautama, *Nyāyasūtra* 1.1.32, with Vātsyāyana's *Nyāyabhāṣya*: an inference
-- offered to another has five members and the traditional example runs
--
--   pratijñā    the hill has fire
--   hetu        because it has smoke
--   udāharaṇa   wherever smoke, there fire — AS IN THE KITCHEN
--   upanaya     this hill is so qualified (it has smoke)
--   nigamana    therefore the hill has fire
--
-- The member this module is built around is the THIRD.  The udāharaṇa is not
-- a restatement of the pervasion and it is not an illustration for the reader:
-- the pervasion must be EXHIBITED at a witnessed locus (the *sapakṣa*, the
-- similar instance).  A syllogism offered with no such locus is not merely
-- unpersuasive; it is defective, and the defect has a name in the enumerated
-- points of defeat — *nyūna*, a missing member.
--
-- Buddhist logicians reduce the five to two or three (Dignāga; Dharmakīrti):
-- the two members addressed to another, on the grounds that upanaya and
-- nigamana add nothing an opponent did not already have.  THAT DISPUTE IS NOT
-- SETTLED HERE and this module does not pretend the five-member form is the
-- only one; what it takes from Nyāya is the mandatory example, which the
-- Buddhist reduction does not remove — Dignāga's *dṛṣṭānta* carries the same
-- burden by a different route (the *trairūpya*, the three characteristics of a
-- valid reason, whose second and third are presence in the similar instance
-- and absence in the dissimilar instance).  Both schools demand the instance.
-- They dispute how many members say so.
--
-- GRADE.  No critical edition opened; sūtra numbers and school attributions
-- carried from this repository's `ANEKANTA.md` §4, §12 and
-- `notes/INDIC_FORMAL_TRADITIONS_MAP.md`, śabda at that grade.
--
-- ========================================================== WHAT IS ENFORCED
--
-- `Siddhanta` is ABSTRACT.  The only constructor is `infer`, and `infer`:
--
--   1. refuses with `Nyuna "udaharana"` when no example is offered.  A
--      pervasion asserted with no witnessed instance does not become a
--      conclusion here, whatever else is right about it;
--   2. VERIFIES the example rather than believing it, by evaluating both sides
--      of the claim at the stated assignment with `Obstruction.evalT` — the
--      engine's own semantics, imported rather than restated, because two
--      copies of an evaluator let an example be witnessed under one and false
--      under the other;
--   3. refuses with `Badhita` when the example does not in fact exhibit the
--      claim (the two sides disagree there) — overridden by pratyakṣa, with
--      the assignment carried;
--   4. refuses with `Nyuna "hetu"` / `Nyuna "upanaya"` when those members are
--      blank, because a member offered as an empty string is a missing member
--      with better manners;
--   5. and on success attaches the `Pramana.Justification` — the means, the
--      naya, the delimitor, the round — so that `siddhantaJustification` is
--      total and there is no path to a held result whose means of knowing is
--      absent.
--
-- WHAT THIS IS NOT.  Not a proof checker.  A verified udāharaṇa is a witnessed
-- instance, which is exactly one instance; `ANEKANTA.md` §12 says the sound
-- half of sampling is REFUTATION and this module keeps that asymmetry — a
-- failing example kills the inference outright (2), a passing example does not
-- establish the pervasion, it discharges the third member.  What establishes
-- the pervasion in this engine is the kernel, and the naya recorded in the
-- justification says which kernel standpoint was asked.  Anyone reading a
-- `Siddhanta` as a theorem has read it wrong, and `renderSiddhanta` prints the
-- extent and the naya on the same line as the claim so that the misreading
-- costs an act of ignoring rather than an act of not noticing.

{-# LANGUAGE LambdaCase #-}

module Pancavayava_TheInferenceCarriesItsWitnessedExampleOrItIsNotOne
  ( Avayava(..)
  , avayavaName
  , Pratijna(..)
  , Hetu(..)
  , Udaharana(..)
  , Upanaya(..)
  , Siddhanta
  , siddhantaClaim
  , siddhantaJustification
  , siddhantaUdaharana
  , renderSiddhanta
  , infer
  , Defeat(..)
  , renderDefeat
  , selfTest
  ) where

import Obstruction (Term, evalT, showClaim, parseAgdaTerm)
import Pramana
  ( Justification(..), Pramana(..), Naya(..), Avacchedaka(..), Provenance(..)
  , nayaNote, pramanaName )
import Hetvabhasa_TheRefusalNamesItsDefectOrItIsNotARefusal
  ( Hetvabhasa(..), Overridden(..), Nigrahasthana(..)
  , hetvabhasaWitness, nigrahasthanaName, nigrahasthanaEvidence
  , hetvabhasaKind, hetvabhasaName )

-- ===================================================================
-- THE FIVE MEMBERS.

data Avayava = APratijna | AHetu | AUdaharana | AUpanaya | ANigamana
  deriving (Eq, Ord, Show)

avayavaName :: Avayava -> String
avayavaName = \case
  APratijna  -> "pratijna"
  AHetu      -> "hetu"
  AUdaharana -> "udaharana"
  AUpanaya   -> "upanaya"
  ANigamana  -> "nigamana"

-- The thesis: the two sides of the claim, as terms, not as a rendered string.
-- Terms because the example is going to be EVALUATED against them, and a
-- string cannot be evaluated without a second parser, and a second parser is a
-- second semantics.
data Pratijna = Pratijna
  { pjLhs :: Term
  , pjRhs :: Term
  } deriving (Eq, Show)

-- The reason, with the standpoint it is offered under.  `Pramana.Naya` rather
-- than a new type: the whole point of that module is that the standpoint is
-- what the kernel was asked, and a second notion of standpoint here would let
-- a justification record one and the inference use another.
data Hetu = Hetu
  { htReason :: String
  , htNaya   :: Naya
  } deriving (Eq, Show)

-- The example.  A concrete assignment — the sapakṣa — at which the pervasion
-- is to be exhibited.  Nothing is trusted here: `infer` recomputes both sides
-- at this assignment and compares, so `udWhy` is a label and `udAt` is the
-- claim.
data Udaharana = Udaharana
  { udAt  :: [Integer]
  , udWhy :: String       -- ^ what makes this a similar instance, in words
  } deriving (Eq, Show)

-- The application: this case is so qualified.
newtype Upanaya = Upanaya { upText :: String } deriving (Eq, Show)

-- The conclusion.  ABSTRACT: no exported constructor, so a `Siddhanta` in
-- scope is one that went through `infer`.
data Siddhanta = Siddhanta
  { sdClaim :: (Term, Term)
  , sdJust  :: Justification
  , sdUdah  :: (Udaharana, Integer, Integer)  -- ^ the example AND the two
                                              --   values computed at it, so
                                              --   the witness is the numbers
                                              --   rather than the promise
  } deriving (Eq, Show)

siddhantaClaim :: Siddhanta -> (Term, Term)
siddhantaClaim = sdClaim

-- Total.  This is the property the module exists for: there is no `Siddhanta`
-- without a justification, so no result in this lane is held without its means
-- of knowing.
siddhantaJustification :: Siddhanta -> Justification
siddhantaJustification = sdJust

siddhantaUdaharana :: Siddhanta -> (Udaharana, Integer, Integer)
siddhantaUdaharana = sdUdah

-- ===================================================================
-- DEFEAT.  Two kinds, kept apart because they are two different objects in
-- the tradition and demand two different repairs: a missing or superfluous
-- MEMBER is a nigrahasthāna (a point of defeat in the encounter), a defective
-- REASON is a hetvābhāsa.  Collapsing them into one `Left String` is the
-- durnaya again, one layer out.
data Defeat
  = ByNigrahasthana Nigrahasthana
  | ByHetvabhasa Hetvabhasa
  deriving (Eq, Show)

renderDefeat :: Defeat -> String
renderDefeat = \case
  ByNigrahasthana n ->
    nigrahasthanaName n ++ "  [" ++ unwords (nigrahasthanaEvidence n) ++ "]"
  ByHetvabhasa h ->
    hetvabhasaName (hetvabhasaKind h) ++ "  [" ++ unwords (hetvabhasaWitness h) ++ "]"

-- ===================================================================
-- THE GATE.
infer
  :: Pratijna
  -> Hetu
  -> Maybe Udaharana
  -> Upanaya
  -> Avacchedaka
  -> Provenance
  -> Either Defeat Siddhanta
infer pj ht mud up av pv
  | null (htReason ht) =
      Left (ByNigrahasthana (Nyuna (avayavaName AHetu)))
  | null (upText up) =
      Left (ByNigrahasthana (Nyuna (avayavaName AUpanaya)))
  | Nothing <- mud =
      Left (ByNigrahasthana (Nyuna (avayavaName AUdaharana)))
  | Just ud <- mud, null (udAt ud) =
      Left (ByNigrahasthana (Nyuna (avayavaName AUdaharana ++ " (offered with "
              ++ "no assignment: a similar instance that names no instance)")))
  | Just ud <- mud =
      let l = evalT (udAt ud) (pjLhs pj)
          r = evalT (udAt ud) (pjRhs pj)
          claim = showClaim (pjLhs pj, pjRhs pj)
      in if l /= r
           then Left (ByHetvabhasa (Badhita (Overridden (udAt ud) claim
                  ("pratyaksa: the offered udaharana gives " ++ show l
                   ++ " and " ++ show r ++ ", so the example exhibits the "
                   ++ "pervasion failing, not holding"))))
           else Right Siddhanta
                  { sdClaim = (pjLhs pj, pjRhs pj)
                  , sdJust  = Justification
                      { jPramana     = Anumana (htNaya ht)
                      , jNaya        = htNaya ht
                      , jAvacchedaka = av
                      , jProvenance  = pv
                      }
                  , sdUdah = (ud, l, r)
                  }

renderSiddhanta :: Siddhanta -> String
renderSiddhanta s =
  showClaim (sdClaim s)
    ++ "  |  pramana=" ++ pramanaName (jPramana (sdJust s))
    ++ "  naya=" ++ nayaNote (jNaya (sdJust s))
    ++ "  vocab=" ++ show (avVocabulary (jAvacchedaka (sdJust s)))
    ++ "  udaharana=" ++ show (udAt u) ++ " both sides " ++ show l
    ++ "  round=" ++ show (provRound (jProvenance (sdJust s)))
  where (u, l, _) = sdUdah s

-- ===================================================================
-- CHECKED IN-PROCESS.  Run by `Nyayapariksa_RunThePramanaLayer`.

selfTest :: [String]
selfTest = concat
  [ check "an inference with no udaharana is defeated by nyuna"
      (case infer plus0 hetu Nothing upa av pv of
         Left (ByNigrahasthana (Nyuna m)) -> m == "udaharana"
         _                                -> False)
  , check "an udaharana with no assignment is also nyuna"
      (case infer plus0 hetu (Just (Udaharana [] "the kitchen")) upa av pv of
         Left (ByNigrahasthana (Nyuna _)) -> True
         _                                -> False)
  , check "an example that does NOT exhibit the claim defeats it as badhita"
      (case infer falseClaim hetu (Just (Udaharana [2] "x = 2")) upa av pv of
         Left (ByHetvabhasa (Badhita o)) -> badhitaAt o == [2]
         _                               -> False)
  , check "a missing hetu is nyuna, not silently accepted"
      (case infer plus0 (Hetu "" NRefl) (Just good) upa av pv of
         Left (ByNigrahasthana (Nyuna m)) -> m == "hetu"
         _                                -> False)
  , check "a missing upanaya is nyuna"
      (case infer plus0 hetu (Just good) (Upanaya "") av pv of
         Left (ByNigrahasthana (Nyuna m)) -> m == "upanaya"
         _                                -> False)
  , check "a complete inference is admitted and carries its justification"
      (case infer plus0 hetu (Just good) upa av pv of
         Right sd -> jNaya (siddhantaJustification sd) == NInduction 'x' (Just "refl")
         _        -> False)
  , check "the admitted conclusion carries the COMPUTED values, not the promise"
      (case infer plus0 hetu (Just good) upa av pv of
         Right sd -> let (_, l, r) = siddhantaUdaharana sd in l == 3 && r == 3
         _        -> False)
  , check "the rendered conclusion names the pramana, the naya and the example"
      (case infer plus0 hetu (Just good) upa av pv of
         Right sd -> let t = renderSiddhanta sd
                     in has "pramana=anumana" t && has "udaharana=" t
                        && has "naya=induction on x" t
         _        -> False)
  , check "defeats render with their evidence, never as a bare name"
      (case infer plus0 hetu Nothing upa av pv of
         Left d -> has "[" (renderDefeat d) && length (renderDefeat d) > 20
         _      -> False)
  ]
  where
    check msg ok = if ok then [] else ["FAIL: " ++ msg]
    tm s = maybe (error ("selfTest: unparsable term " ++ s)) id (parseAgdaTerm s)
    -- x + 0 = x, true, and the example at x = 3 exhibits it
    plus0      = Pratijna (tm "x + 0") (tm "x")
    -- x + 0 = s(x), false, and the example at x = 2 exhibits the failure
    falseClaim = Pratijna (tm "x + 0") (tm "suc(x)")
    good = Udaharana [3] "x = 3, where both sides reduce"
    hetu = Hetu "the definitional equations orient this way" (NInduction 'x' (Just "refl"))
    upa  = Upanaya "this goal is of that form"
    av   = Avacchedaka "_==_ on N" ["0", "s", "+"] 3 7
    pv   = Provenance 0 1
    has needle hay = any (pre needle) (sufs hay)
    sufs s = s : case s of { [] -> [] ; (_:t) -> sufs t }
    pre [] _ = True
    pre _ [] = False
    pre (a:as) (b:bs) = a == b && pre as bs
