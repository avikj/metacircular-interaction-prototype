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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DisclosureDimension
--
-- The typed obstruction behind notes/DISCLOSURE_DIMENSION.md.
--
-- CONTEXT.  For a linear observation quotient q : V -> W over a field,
-- the minimal number of scalars that must be disclosed alongside q x to
-- determine x is exactly dim (ker q) (Theorem 1 of the note, one line of
-- rank-nullity).  Because dim ker is ADDITIVE along composites of
-- surjections, that number is a dimension in the honest sense.
--
-- This module checks that the SET-LEVEL analogue is NOT.  Define, for a
-- map q : A -> B, a "disclosure with alphabet X" to be d : A -> X such
-- that (q , d) is jointly injective:
--
--     Sep q d  =  forall x y -> q x == q y -> d x == d y -> x == y.
--
-- Exhibited below: q1 : Three -> Bool and q2 : Bool -> Unit, each of
-- which admits a disclosure over the TWO-letter alphabet Bool, whose
-- composite q21 : Three -> Unit admits NO disclosure over Bool, but does
-- admit one over the three-letter alphabet Three.
--
-- Hence minimal alphabet size is  2, 2  on the factors and  3  on the
-- composite, and 3 < 2 * 2 STRICTLY.  Minimal alphabet is therefore
-- strictly submultiplicative, so its logarithm is not additive, so it is
-- not a dimension of anything.  This is the exact reason the flow
-- instance (COORDINATION_THEOREMS_XXIX 804-833) and the finite-set
-- instances (msg 0264's dilation dimension, msg 0249's cache fiber) are
-- not two costumes of one invariant: the linear invariant is a SUM over
-- a composite, the finite-set invariant is a MAX over fibres, and max
-- does not add.
--
-- CHECKED ON THE PIN: `NM_MODULES="DisclosureDimension.agda" ./check.sh`
-- reports  EXIT 0  with  agda 2.8.0 (/root/Agda-2.8.0/...) and cubical
-- /root/agda-libs/cubical-v0.9 at tag v0.9, commit b150186 -- i.e. the
-- pin declared in BUILD.md and in check.sh's own header, verified by
-- check.sh itself and not by a bare `agda -i .`.  No postulates, no
-- holes, --safe.  (This supersedes, for this module only,
-- notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md's report that
-- check.sh exits 2 here: the pin toolchain is now present on this
-- container.  That note's re-grading of ITS OWN earlier greens stands.)
------------------------------------------------------------------------

module DisclosureDimension where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Data.Sigma using (_×_)

------------------------------------------------------------------------
-- The three-letter alphabet, and its discreteness in the only two forms
-- we need.

data Three : Type where
  a b c : Three

-- Separating functions, used to prove the three points pairwise distinct.

fab : Three → Bool
fab a = true
fab b = false
fab c = false

fac : Three → Bool
fac a = true
fac b = false
fac c = false

fbc : Three → Bool
fbc a = false
fbc b = true
fbc c = false

a≢b : a ≡ b → ⊥
a≢b p = true≢false (cong fab p)

a≢c : a ≡ c → ⊥
a≢c p = true≢false (cong fac p)

b≢c : b ≡ c → ⊥
b≢c p = true≢false (cong fbc p)

------------------------------------------------------------------------
-- Disclosure.

-- d discloses q  iff  (q , d) is jointly injective.
Sep : {A B X : Type} → (A → B) → (A → X) → Type
Sep {A = A} q d = (x y : A) → q x ≡ q y → d x ≡ d y → x ≡ y

------------------------------------------------------------------------
-- The two factors.  q1 merges a with b; q2 merges the two remaining
-- classes.  Each has a two-letter disclosure.

q1 : Three → Bool
q1 a = true
q1 b = true
q1 c = false

d1 : Three → Bool
d1 a = true
d1 b = false
d1 c = true

-- Factor 1 admits a two-letter disclosure.
factor1-two-letters : Sep q1 d1
factor1-two-letters a a _ _ = refl
factor1-two-letters a b _ q = ⊥-rec (true≢false q)
factor1-two-letters a c p _ = ⊥-rec (true≢false p)
factor1-two-letters b a _ q = ⊥-rec (true≢false (sym q))
factor1-two-letters b b _ _ = refl
factor1-two-letters b c p _ = ⊥-rec (true≢false p)
factor1-two-letters c a p _ = ⊥-rec (true≢false (sym p))
factor1-two-letters c b p _ = ⊥-rec (true≢false (sym p))
factor1-two-letters c c _ _ = refl

q2 : Bool → Unit
q2 _ = tt

-- Factor 2 admits a two-letter disclosure (the identity on Bool).
factor2-two-letters : Sep q2 (λ (x : Bool) → x)
factor2-two-letters _ _ _ q = q

------------------------------------------------------------------------
-- The composite.

q21 : Three → Unit
q21 x = q2 (q1 x)

-- Pigeonhole on three Booleans, by exhaustive case analysis.
three-into-two : (u v w : Bool)
               → (u ≡ v → ⊥) → (u ≡ w → ⊥) → (v ≡ w → ⊥) → ⊥
three-into-two true  true  _     p _ _ = p refl
three-into-two false false _     p _ _ = p refl
three-into-two true  false true  _ q _ = q refl
three-into-two false true  false _ q _ = q refl
three-into-two true  false false _ _ r = r refl
three-into-two false true  true  _ _ r = r refl

-- The composite admits NO two-letter disclosure.
composite-not-two-letters : (d : Three → Bool) → Sep q21 d → ⊥
composite-not-two-letters d s =
  three-into-two (d a) (d b) (d c)
    (λ p → a≢b (s a b refl p))
    (λ p → a≢c (s a c refl p))
    (λ p → b≢c (s b c refl p))

-- The composite does admit a three-letter disclosure.
composite-three-letters : Sep q21 (λ (x : Three) → x)
composite-three-letters _ _ _ q = q

------------------------------------------------------------------------
-- Conclusion, as a type.
--
-- Read together: minAlphabet q1 = 2, minAlphabet q2 = 2, and
-- minAlphabet (q2 . q1) = 3.  Were the invariant a dimension, its
-- logarithm would be additive and the composite would require the full
-- 2 * 2 = 4 letters.  It requires 3.  The defect is exactly the failure
-- of "max over fibres" to be additive, and it is why the flow instance
-- (a nullity) and the finite-set instances (a max fibre size) are
-- different invariants.

Submultiplicative-Strictly : Type
Submultiplicative-Strictly =
    Sep q1 d1
  × (Sep q2 (λ (x : Bool) → x))
  × ((d : Three → Bool) → Sep q21 d → ⊥)
  × (Sep q21 (λ (x : Three) → x))

theorem : Submultiplicative-Strictly
theorem = factor1-two-letters
        , factor2-two-letters
        , composite-not-two-letters
        , composite-three-letters
