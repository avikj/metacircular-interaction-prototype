{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कक्ष्या — ध्रुवं कक्ष्यायां स्थिरम् ।
--
-- (the conserved quantity is constant along the orbit.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  `Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThere
-- IsNoSymmetry.agda` §४ names its own open item, verbatim:
--
--     "The conserved quantity here is `f` itself: `संरक्षणम्` says exactly
--      that `f` is Φ-invariant, so `f` descends to the orbits.  That is a
--      `FactorsThrough` obligation ... so 'the charge is a function on the
--      quotient, not on the cover' is stateable here and is not stated yet."
--
-- This states it.  Dhruva's §१ gives one step — `f (Φ a) ≡ f a` — and that
-- alone leaves open whether the charge could drift along a long orbit.  It
-- cannot: §२ below is the induction, and its content is that the charge
-- cannot distinguish ANY two points of an orbit, at ANY distance.  That is
-- what "a function on the quotient rather than on the cover" says without
-- introducing a quotient type: the cover's points are separated by Φ, and
-- the charge is blind to every one of those separations.
--
-- WHY IT IS WORTH A TERM AND NOT A REMARK.  The one-step law is a
-- hypothesis about a generator; the orbit law is a statement about the
-- ORBIT, which is the object `Dhruva` §१ actually identifies with the
-- gauge orbit and the fibre.  Without §२, "the gauge orbit is the fibre"
-- is asserted of a set nothing has been proved constant on.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.
--
-- **Not a quotient.**  No orbit space is constructed and no universal
-- property is proved.  `Φ` is a bare endomorphism with no inverse, so its
-- orbits are forward orbits only and the relation `a ~ Φⁿ a` is not shown
-- to be an equivalence relation.  A genuine descent statement — `f`
-- factoring through `A / ~` — needs that and is NOT here.
--
-- **Not Noether.**  Everything `Dhruva`'s header fences applies unchanged:
-- no Lagrangian, no variation, no continuity, and the second theorem's
-- dichotomy needs transitivity, which is not stated.
--
-- TERM.  कक्ष्या — in the siddhāntic astronomical tradition, the orbit or
-- orbital circle of a planet (standard from Āryabhaṭa, आर्यभटीयम्, 499,
-- and through the Sūryasiddhānta).  LIMIT: attested for a planetary orbit;
-- its use here for the forward orbit of an endomorphism is this corpus's,
-- and no text is claimed for the application.  No source states anything
-- below.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 — the container, NOT the
-- repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes, exit 0.  `Dhruva` itself was re-checked under this same toolchain
-- at the same time and also exits 0, so the import is not resting on the
-- pin either.
------------------------------------------------------------------------

module Kaksya_TheChargeIsConstantAlongTheWholeOrbitAndNotOnlyAcrossOneStep where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (संरक्षणम्)

private variable ℓ : Level

module _ {A B : Type ℓ} (f : A → B) (Φ : A → A) where

------------------------------------------------------------------------
-- १ · कक्ष्या — the forward orbit, as an iteration of the flow.
--
-- `Φ` is a bare endomorphism, so this is the forward orbit and nothing
-- more: no inverse is available and none is used.
------------------------------------------------------------------------

  कक्ष्या : ℕ → A → A
  कक्ष्या zero    a = a
  कक्ष्या (suc n) a = Φ (कक्ष्या n a)

------------------------------------------------------------------------
-- २ · ध्रुवं कक्ष्यायां स्थिरम् — THE CHARGE IS CONSTANT ALONG THE ORBIT.
--
-- Dhruva §१ gives one step.  This is every step, by induction, and the
-- proof is the one-step law composed with the tail.
--
-- Read at the physics: the observable cannot distinguish any two points
-- of one orbit, however far apart along the flow.  That is the exact
-- content of "the charge is a function on the quotient, not on the
-- cover" — stated on the cover, where it is provable without building a
-- quotient.
------------------------------------------------------------------------

  ध्रुवं-कक्ष्यायाम् : संरक्षणम् f Φ → (n : ℕ) (a : A) → f (कक्ष्या n a) ≡ f a
  ध्रुवं-कक्ष्यायाम् cons zero    a = refl
  ध्रुवं-कक्ष्यायाम् cons (suc n) a = cons (कक्ष्या n a) ∙ ध्रुवं-कक्ष्यायाम् cons n a

------------------------------------------------------------------------
-- ३ · अभेदः — and therefore no two points of an orbit are separated by
--     the charge.  This is §२ read as the blindness it is: for any two
--     stations `m`, `n` on one orbit, the observable agrees.
------------------------------------------------------------------------

  कक्ष्या-अभेदः : संरक्षणम् f Φ → (m n : ℕ) (a : A)
                → f (कक्ष्या m a) ≡ f (कक्ष्या n a)
  कक्ष्या-अभेदः cons m n a =
    ध्रुवं-कक्ष्यायाम् cons m a ∙ sym (ध्रुवं-कक्ष्यायाम् cons n a)

------------------------------------------------------------------------
-- ४ · शेषः — what this opens and does not close.
--
-- The genuine descent statement needs the orbit RELATION and its
-- quotient, and `Φ` without an inverse does not give an equivalence
-- relation — `a ~ Φⁿ a` is reflexive and transitive and not symmetric.
-- So the honest next rung is either (a) require `Φ` to be an equivalence
-- and take the groupoid it generates, or (b) state descent along the
-- reflexive-transitive closure and accept a preorder rather than a
-- quotient.  Neither is done here, and §२–§३ are true without either.
------------------------------------------------------------------------
