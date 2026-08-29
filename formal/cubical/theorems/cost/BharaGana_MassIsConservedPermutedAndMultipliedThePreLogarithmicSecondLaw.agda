{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भार-गण — the weight calculus.
--
-- THE WEIGHTED SECOND LAW, PRE-LOGARITHM.  The counting second law
-- tracked distinctions; weights refine counts, and their algebra is
-- the second law's multiplicative face:
--
--   §1  MASS IS CONSERVED BY MERGING: pushing a weight forward along
--       the erasing map sums it — nothing of the measure is lost when
--       the support collapses; the support shrinks, the mass arrives
--       intact.  (Conservation, weighted.)
--
--   §2  MASS IS PERMUTED BY REVERSIBLE MAPS: reindexing along the
--       flip preserves it, by commutativity.  (Reversibility moves
--       measure, never makes or destroys it.)
--
--   §3  MASS MULTIPLIES UNDER INDEPENDENCE: the product weight's
--       total is the product of the totals, by the two
--       distributivities proved from scratch.  This is exactly the
--       identity the logarithm will read additively — entropies add
--       BECAUSE masses multiply, and the multiplication is the
--       theorem while the logarithm is a change of notation for it.
--
-- Conservation, reversibility, independence: the three axioms of the
-- measure-level second law, each a term, none needing a real number.
--
-- SYĀT — THE CLAIM, EXACTLY.  Weights on the two-point space with
-- ℕ-mass; the logarithm (reals, and the additive reading) and larger
-- index types are the standing constructions.
------------------------------------------------------------------------

module BharaGana_MassIsConservedPermutedAndMultipliedThePreLogarithmicSecondLaw where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-assoc ; +-comm)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.Sigma using (_×_ ; _,_)

------------------------------------------------------------------------
-- १ · Weights, mass, and conservation under merging.
------------------------------------------------------------------------

Bhāra : Type₀
Bhāra = Bool → ℕ

māna : Bhāra → ℕ
māna w = w true + w false

-- The erasing pushforward: both points land on one.
saṃkoca : Bhāra → ℕ
saṃkoca w = w true + w false

saṃkoca-māna : (w : Bhāra) → saṃkoca w ≡ māna w
saṃkoca-māna w = refl

------------------------------------------------------------------------
-- २ · Reversible reindexing permutes the mass.
------------------------------------------------------------------------

viparyaya-māna : (w : Bhāra) → māna (λ b → w (not b)) ≡ māna w
viparyaya-māna w = +-comm (w false) (w true)

------------------------------------------------------------------------
-- ३ · Independence multiplies the mass.
------------------------------------------------------------------------

guṇa-viṣama : (a b m : ℕ) → (a + b) · m ≡ a · m + b · m
guṇa-viṣama zero    b m = refl
guṇa-viṣama (suc a) b m =
  cong (m +_) (guṇa-viṣama a b m) ∙ +-assoc m (a · m) (b · m)

guṇa-sama : (a c d : ℕ) → a · (c + d) ≡ a · c + a · d
guṇa-sama zero    c d = refl
guṇa-sama (suc a) c d =
  cong ((c + d) +_) (guṇa-sama a c d)
  ∙ sym (+-assoc c d (a · c + a · d))
  ∙ cong (c +_)
      (+-assoc d (a · c) (a · d)
       ∙ cong (_+ a · d) (+-comm d (a · c))
       ∙ sym (+-assoc (a · c) d (a · d)))
  ∙ +-assoc c (a · c) (d + a · d)

-- The product weight on the four-point plane, and its mass.
_⊠_ : Bhāra → Bhāra → (Bool × Bool → ℕ)
(w ⊠ v) (b , c) = w b · v c

māna² : (Bool × Bool → ℕ) → ℕ
māna² u = (u (true , true) + u (true , false))
        + (u (false , true) + u (false , false))

svātantrya-guṇa : (w v : Bhāra) → māna² (w ⊠ v) ≡ māna w · māna v
svātantrya-guṇa w v =
  cong₂ _+_ (sym (guṇa-sama (w true) (v true) (v false)))
            (sym (guṇa-sama (w false) (v true) (v false)))
  ∙ sym (guṇa-viṣama (w true) (w false) (v true + v false))
