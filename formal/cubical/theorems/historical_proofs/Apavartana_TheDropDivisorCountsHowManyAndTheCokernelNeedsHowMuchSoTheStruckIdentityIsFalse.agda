{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अपवर्तन — the reduction, and what it does NOT determine.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS FILE EXISTS.  README movement 65 stated, and on 2026-08-22
-- STRUCK, the identity
--
--     ∑_p #{i : p ∣ dᵢ} · log p  =  ∑_i log dᵢ  =  log |coker(T)_tors|
--
-- for the invariant factors dᵢ of an integer matrix T.  The strike names
-- `D = diag(2,12)` as the counterexample and is prose.  A correction
-- outranks a result in this repository, so the correction is the thing
-- that should be a checked term, and until now it was not.  This file
-- re-derives the counterexample and checks it — every line by `refl`
-- except one negation, which is a `subst` along a family that is Unit at
-- 12 and ⊥ elsewhere.
--
-- ────────────────────────────────────────────────────────────────────
-- TERM.  अपवर्तन (apavartana) — "reduction", the division of two
-- quantities by their common measure, Āryabhaṭa, आर्यभटीयम्, गणितपाद
-- ११–१२ (कुट्टक), 499 CE; the step is standard in Brahmagupta,
-- ब्राह्मस्फुटसिद्धान्त १८, 628 CE, and in Bhāskara II, बीजगणित, 1150 CE.
-- LIMIT: अपवर्तन is attested for the gcd-reduction step.  Its use here
-- as a label for the invariant-factor decomposition of an integer
-- matrix is this corpus's (the naming follows the existing Lean module
-- `Apavartana_…SpecZ…`), and NO Sanskrit source states anything below.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS CHECKED.  Multiplicatively, to stay inside ℕ and away from
-- logarithms: `log` of each side becomes a product of prime powers, and
-- the identity above becomes
--
--     ∏_p p^(#{i : p ∣ dᵢ})   =?=   ∏_i dᵢ
--
-- An invariant factor is carried as its exponent vector over the primes
-- (2,3); `val` turns a vector back into a natural, and §० checks that
-- the three vectors used really do name 2, 6 and 12, so nothing is
-- asserted by hand.
--
--   §१  D = diag(2,12), invariant factors (2,12):
--         drop side  = 2^2 · 3^1 = 12      (p=2 divides both dᵢ;
--                                           p=3 divides one)
--         ∏ dᵢ       = 24  = |coker| = |det|
--         12 ≢ 24.  **The struck identity is false as stated.**
--
--   §२  The repaired identity, ∏_p p^(∑_i v_p(dᵢ)) = ∏_i dᵢ, holds on
--       the same data: 2^3 · 3^1 = 24.  So the defect is exactly
--       "count of i" where "sum of v_p" was needed — HOW MANY against
--       HOW MUCH, which is what the strike says.
--
--   §३  The strike's own strengthening, checked: diag(2,6) and
--       diag(2,12) have the SAME drop side (12) and different products
--       (12 against 24).  So the drop divisor is a strictly lossier
--       invariant than the determinant; the fibre of the drop divisor
--       is not a point.  This is the fibre law applied to movement 65's
--       own price instrument, and it is now a term rather than a
--       sentence.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED, and the fence is large because the arithmetic
-- below is small.
--
-- 1.  **No cokernel is constructed here.**  `|coker(ℤ²/Dℤ²)| = 24` is
--     NOT proved in this file; it is proved for this very matrix in the
--     Lean lane (`Apavartana_…SpecZ…`, `cok_card`).  What this file
--     checks is the ARITHMETIC of the two divisor formulas on the
--     invariant factors, which is where the struck claim broke.  A
--     reader who wants the group must go to the Lean module.
--
-- 2.  **No Smith normal form is computed.**  That diag(2,12) has
--     invariant factors (2,12) and diag(2,6) has (2,6) is used as
--     input, not proved.  It is immediate (2 ∣ 12, 2 ∣ 6, and the
--     matrices are already diagonal with divisibility in order), but
--     immediate is not checked, so it is fenced.
--
-- 3.  **No general theorem.**  A counterexample refutes; it does not
--     establish the repaired identity in general.  §२ checks the
--     repaired formula ON THIS DATUM only.  The general statement
--     ∏_p p^(∑_i v_p(dᵢ)) = ∏_i dᵢ is just unique factorization and is
--     not proved here.
--
-- 4.  **The primes are fixed to {2,3}.**  Every dᵢ occurring below is
--     {2,3}-smooth, so the two-place exponent vector is faithful for
--     this datum and for nothing else.
--
-- CHECKED: Agda 2.6.3 with the `cubical` library as installed in this
-- container (NOT the repository's pin), `--cubical --safe`, no
-- postulates, no holes; `agda --library=cubical -i . <this file>`
-- exits 0.
------------------------------------------------------------------------

module Apavartana_TheDropDivisorCountsHowManyAndTheCokernelNeedsHowMuchSoTheStruckIdentityIsFalse where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc; _+_; _·_; _^_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- ० · An invariant factor, carried as its exponent vector over (2,3).
------------------------------------------------------------------------

घातांक : Type            -- exponent vector (v₂ , v₃)
घातांक = ℕ × ℕ

मान : घातांक → ℕ          -- the natural it names
मान (e₂ , e₃) = (2 ^ e₂) · (3 ^ e₃)

-- The three vectors used below really do name 2, 6, 12.
द्वि षट् द्वादश : घातांक
द्वि     = 1 , 0
षट्      = 1 , 1
द्वादश   = 2 , 1

मान-द्वि     : मान द्वि    ≡ 2
मान-द्वि     = refl
मान-षट्      : मान षट्     ≡ 6
मान-षट्      = refl
मान-द्वादश   : मान द्वादश  ≡ 12
मान-द्वादश   = refl

------------------------------------------------------------------------
-- The two divisor formulas, on a pair of invariant factors.
------------------------------------------------------------------------

-- HOW MANY: the indicator, 0 ↦ 0 and anything positive ↦ 1.
सत् : ℕ → ℕ
सत् zero    = 0
सत् (suc _) = 1

-- ∏_p p^(#{i : p ∣ dᵢ}) — the DROP divisor of the struck identity.
कति : घातांक → घातांक → ℕ
कति (a₂ , a₃) (b₂ , b₃) = (2 ^ (सत् a₂ + सत् b₂)) · (3 ^ (सत् a₃ + सत् b₃))

-- ∏_p p^(∑_i v_p(dᵢ)) — the repaired divisor.
कियत् : घातांक → घातांक → ℕ
कियत् (a₂ , a₃) (b₂ , b₃) = (2 ^ (a₂ + b₂)) · (3 ^ (a₃ + b₃))

-- ∏_i dᵢ — which for a square nonsingular T is |det T| = |coker_tors|.
गुणफल : घातांक → घातांक → ℕ
गुणफल d₁ d₂ = मान d₁ · मान d₂

------------------------------------------------------------------------
-- The one negation.  12 ≢ 24, by a family that is Unit at 12 and ⊥
-- elsewhere: transporting `tt` along a path would inhabit ⊥.
------------------------------------------------------------------------

द्वादशः : ℕ → Type
द्वादशः 12 = Unit
द्वादशः _  = ⊥

न-द्वादश-चतुर्विंशति : ¬ (12 ≡ 24)
न-द्वादश-चतुर्विंशति p = subst द्वादशः p tt

------------------------------------------------------------------------
-- १ · THE STRUCK IDENTITY IS FALSE.  D = diag(2,12).
------------------------------------------------------------------------

कति-द्वादश : कति द्वि द्वादश ≡ 12
कति-द्वादश = refl

गुणफल-द्वादश : गुणफल द्वि द्वादश ≡ 24
गुणफल-द्वादश = refl

-- the refutation.
कति-न-गुणफल : ¬ (कति द्वि द्वादश ≡ गुणफल द्वि द्वादश)
कति-न-गुणफल q = न-द्वादश-चतुर्विंशति (sym कति-द्वादश ∙ q ∙ गुणफल-द्वादश)

------------------------------------------------------------------------
-- २ · THE REPAIRED IDENTITY HOLDS ON THE SAME DATUM.
------------------------------------------------------------------------

कियत्-द्वादश : कियत् द्वि द्वादश ≡ गुणफल द्वि द्वादश
कियत्-द्वादश = refl

------------------------------------------------------------------------
-- ३ · THE DROP DIVISOR IS STRICTLY LOSSIER.  Same drop, different
-- determinant: diag(2,6) against diag(2,12).
------------------------------------------------------------------------

समान-कति : कति द्वि षट् ≡ कति द्वि द्वादश
समान-कति = refl

गुणफल-षट् : गुणफल द्वि षट् ≡ 12
गुणफल-षट् = refl

भिन्न-गुणफल : ¬ (गुणफल द्वि षट् ≡ गुणफल द्वि द्वादश)
भिन्न-गुणफल q = न-द्वादश-चतुर्विंशति (sym गुणफल-षट् ∙ q ∙ गुणफल-द्वादश)
