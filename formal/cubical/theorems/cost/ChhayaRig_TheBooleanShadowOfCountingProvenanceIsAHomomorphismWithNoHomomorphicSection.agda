{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- छाया-रिग् — the shadow rig.
--
-- RESOLUTION OF A FORMER SCOPE LINE.  Abstract 06 proved that lineage
-- cannot be recovered from answers and its closing section said the
-- provenance-semiring reading was absent — no semiring, no forgetful
-- homomorphism to the booleans.  This file ends that absence:
--
--   §1  The rigs exist: the counting rig (ℕ, 0, 1, +, ·) — bag/how-many
--       provenance — and the boolean rig (Bool, false, true, or, and) —
--       which/lineage-erased provenance.
--
--   §2  The forgetful map IS a homomorphism: positivity carries 0, 1,
--       + and · of counts to false, true, or and and of booleans, each
--       preservation proved (two of them definitional per case).
--
--   §3  THE NO-SECTION THEOREM, which is abstract 06's "no boolean
--       summary carries the trail" in its algebraic strongest form:
--       no additive section exists.  Any map σ : Bool → ℕ that
--       preserves addition and is inverted by the shadow dies on
--       idempotence: true or true = true forces σ true ≡ σ true + σ
--       true, so σ true = 0, so its shadow is false, not true.  The
--       counting provenance provably cannot be reconstituted from its
--       boolean shadow by ANY homomorphic means — decategorification
--       has no algebraic inverse, as a theorem rather than a slogan.
--
-- Weights ⇒ traces, at the semiring level: the shadow is cheap in one
-- direction and impossible in the other, and the impossibility is one
-- idempotence away.
--
-- SYĀT — THE CLAIM, EXACTLY.  Relational algebra and a query language
-- remain absent — those are the next constructions; the semiring
-- reading of abstract 06 is no longer among the absences.
------------------------------------------------------------------------

module ChhayaRig_TheBooleanShadowOfCountingProvenanceIsAHomomorphismWithNoHomomorphicSection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; injSuc ; snotz)
open import Cubical.Data.Bool using (Bool ; true ; false ; _or_ ; _and_ ; true≢false)
open import Cubical.Data.Empty using (⊥ ; rec)

------------------------------------------------------------------------
-- १ · The shadow, and its homomorphism laws.
------------------------------------------------------------------------

chāyā : ℕ → Bool
chāyā zero    = false
chāyā (suc _) = true

chāyā-śūnya : chāyā 0 ≡ false
chāyā-śūnya = refl

chāyā-eka : chāyā 1 ≡ true
chāyā-eka = refl

chāyā-yoga : (m n : ℕ) → chāyā (m + n) ≡ chāyā m or chāyā n
chāyā-yoga zero    n = refl
chāyā-yoga (suc m) n = refl

guṇya-śūnya : (m : ℕ) → m · zero ≡ zero
guṇya-śūnya zero    = refl
guṇya-śūnya (suc m) = guṇya-śūnya m

chāyā-guṇa : (m n : ℕ) → chāyā (m · n) ≡ chāyā m and chāyā n
chāyā-guṇa zero    n       = refl
chāyā-guṇa (suc m) zero    = cong chāyā (guṇya-śūnya (suc m))
chāyā-guṇa (suc m) (suc n) = refl

------------------------------------------------------------------------
-- २ · No additive section.  The two lemmas, then the theorem.
------------------------------------------------------------------------

-- Nothing exceeds itself by a positive amount.
na-adhika : (m k : ℕ) → m ≡ m + suc k → ⊥
na-adhika zero    k p = snotz (sym p)
na-adhika (suc m) k p = na-adhika m k (injSuc p)

-- Only zero doubles to itself.
dviguṇa-śūnya : (n : ℕ) → n ≡ n + n → n ≡ zero
dviguṇa-śūnya zero    _ = refl
dviguṇa-śūnya (suc k) p = rec (na-adhika k k (injSuc p))

-- THE THEOREM.  σ preserves or/+ and is sectioned by the shadow — ⊥.
na-praticchāyā : (σ : Bool → ℕ)
               → ((a b : Bool) → σ (a or b) ≡ σ a + σ b)
               → ((b : Bool) → chāyā (σ b) ≡ b)
               → ⊥
na-praticchāyā σ yoga khaṇḍa =
  true≢false
    (sym (khaṇḍa true)
     ∙ cong chāyā (dviguṇa-śūnya (σ true) (yoga true true)))
