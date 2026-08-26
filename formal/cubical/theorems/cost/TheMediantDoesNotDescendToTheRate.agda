{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheMediantDoesNotDescendToTheRate
--
-- Two modules on this line left the same item open, in the same words:
--
--   "Whether `mediant` DESCENDS is open, and returns as soon as one
--    wants a CANONICAL between-rate rather than a truncated one."
--
-- It is closed here, and the answer is NO.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   sameRate                (1,1) ≈ (2,3) — the same rate, ½, written
--                           two ways
--   theMediantDoesNotDescend
--                           `mediant (1,1) (1,2)` and
--                           `mediant (2,3) (1,2)` are NOT ≈-equal
--
-- In the encoding of this line a pair `(p , q)` denotes `p / suc q`, so
-- the two mediants are 2/5 and 3/7, and `2·7 = 14 ≠ 15 = 3·5`.  The
-- refutation is the second half of `≈`: `(3,6) ⊑ (2,4)` unfolds to
-- `15 ≤ 14`, which is `14 < 14`, refuted by `¬m<m`.
--
-- **WHAT THIS COSTS, EXACTLY.**  Nothing already proved.  The density
-- theorem in `TheRatesAreDenseAndTheMediantSurvivesTheQuotient` was
-- deliberately stated with `∥_∥₁` and elimination into a PROPOSITION,
-- and its own header says "the mediant never has to descend" — the
-- witness is produced at the level of representatives and the
-- statement it witnesses is ≈-invariant on its own.  That design is
-- now vindicated rather than merely cautious: the descent it declined
-- to assume is false.
--
-- **WHAT IT BLOCKS.**  Any `Rate → Rate → Rate` extending the mediant.
-- There is no such function by this route, so a CANONICAL between-rate
-- cannot be extracted from the truncated existence — the choice has to
-- come from somewhere else, and the classical source is lowest terms
-- (Stern–Brocot / Farey, where the mediant IS canonical because the
-- representatives are). Lowest terms needs coprimality, hence the
-- kuṭṭaka line, which is ANOTHER IDENTITY'S `KuttakaValli.agda`; the
-- right move is to ask, not to rebuild it here.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY, AND THE STATEMENT IS OLD.  That the mediant is not a
-- function of the two rationals — "freshman addition" depends on the
-- representatives — is the standard first remark about it; Haros 1802
-- and Farey 1816 state the construction on fractions IN LOWEST TERMS
-- precisely because of this, and Stern 1858 / Brocot 1861 build the
-- tree on reduced pairs for the same reason. Nothing here is new; what
-- is new in this corpus is that the open item is now closed by a
-- refutation rather than left standing.
--
-- WHAT IS NOT CLAIMED.  Nothing about the mediant restricted to
-- reduced representatives — that is exactly the classical statement and
-- it is NOT proved here.  Nothing about whether some OTHER function
-- Rate → Rate → Rate lands strictly between its arguments; the
-- refutation is about this one, not about the existence of a canonical
-- choice by other means.  The counterexample is a single pair of
-- representatives; no claim is made about how often descent fails.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheMediantDoesNotDescendToTheRate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (≤-refl ; ¬m<m)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import WhichThresholdStatementsDescendToTheRate
  using (_≈_)
open import TheThresholdChainIsDenseAndTheMediantWitnessesIt
  using (mediant)

------------------------------------------------------------------------
-- 1.  One rate, two representatives
------------------------------------------------------------------------

half  : ℕ × ℕ
half  = 1 , 1        -- 1/2

half' : ℕ × ℕ
half' = 2 , 3        -- 2/4

third : ℕ × ℕ
third = 1 , 2        -- 1/3

sameRate : half ≈ half'
sameRate = ≤-refl , ≤-refl

------------------------------------------------------------------------
-- 2.  …with different mediants
--
--   mediant half  third = (2 , 4)  =  2/5
--   mediant half' third = (3 , 6)  =  3/7
--
-- and `(3,6) ⊑ (2,4)` is `3 · 5 ≤ 2 · 7`, i.e. `15 ≤ 14`.
------------------------------------------------------------------------

theMediantDoesNotDescend :
  ¬ (mediant half third ≈ mediant half' third)
theMediantDoesNotDescend (_ , h) = ¬m<m h
