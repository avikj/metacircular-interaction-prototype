{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अपसारण-नियम — the displacement law.
--
-- RESOLUTION TOWARD ABSTRACT 24'S THERMODYNAMIC SENTENCE.  That
-- abstract stated no erasure bound was derived.  The bound's logical
-- core is derivable, and here it is:
--
--   §1  THE DISPLACEMENT THEOREM, generic.  Let a total dynamics act
--       on system × environment and be injective — reversibility, in
--       exactly the sense abstract 24 uses.  If the dynamics merges
--       two distinct system states at some environment state (the
--       system marginal erases), then the environment marginal MUST
--       separate them.  Reversibility conserves distinctions, so
--       erasure never destroys a bit: it exports it.  The proof is
--       four lines: agreeing on both components would make the merged
--       pair equal under an injection.
--
--   §2  THE REVERSIBLE ERASER, exhibited: the swap.  With the
--       environment prepared at false, the system marginal after the
--       swap is constant — erasure by refl — and the environment
--       marginal carries the bit out, also by refl; the exported
--       distinction is exhibited at the named pair.  One gate, all
--       three faces: reversible, erasing, displacing.
--
-- WHERE THE HEAT LIVES, read against the corpus.  Abstract 24 proves
-- a reversible structure carries no intrinsic cost — there is nowhere
-- in the dynamics for the erasure cost to be.  This file shows where
-- it goes instead: into the ENVIRONMENT'S KEPT FIBRE.  Erasure cost
-- is not a property of the invertible dynamics (graded-or-invertible
-- forbids it) but of the marginal you chose to stop watching — the
-- lossless completion keeps what the projection drops, and the
-- thermodynamic name for that kept fibre is heat.  The kT ln 2 of the
-- laboratory is this counting statement composed with a unit of
-- account; the counting statement is the theorem.
--
-- SYĀT — THE CLAIM, EXACTLY.  Distinctions are counted, not weighed:
-- no reals, no logarithm, no temperature — those are the next
-- constructions (a measure theory over the kept fibre).  The
-- conservation-of-distinctions law and the displacement of erasure
-- into the environment are no longer among the absences.
------------------------------------------------------------------------

module ApasaranaNiyama_ReversibilityConservesDistinctionsSoErasureIsDisplacementIntoTheEnvironmentNeverDestruction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- १ · The displacement theorem.
------------------------------------------------------------------------

module _ {S : Type ℓ} {E : Type ℓ'}
         (R : S × E → S × E)
         (viloma : (p q : S × E) → R p ≡ R q → p ≡ q) where

  apasāraṇa : (s₁ s₂ : S) (e : E)
            → (s₁ ≡ s₂ → ⊥)
            → fst (R (s₁ , e)) ≡ fst (R (s₂ , e))
            → snd (R (s₁ , e)) ≡ snd (R (s₂ , e))
            → ⊥
  apasāraṇa s₁ s₂ e bheda mṛjana vilaya =
    bheda (cong fst (viloma (s₁ , e) (s₂ , e) (λ i → mṛjana i , vilaya i)))

------------------------------------------------------------------------
-- २ · The reversible eraser: the swap, at a prepared environment.
------------------------------------------------------------------------

parivṛtti : Bool × Bool → Bool × Bool
parivṛtti (s , e) = e , s

parivṛtti-viloma : (p q : Bool × Bool) → parivṛtti p ≡ parivṛtti q → p ≡ q
parivṛtti-viloma p q h = cong parivṛtti h

-- Erasure, by refl: at environment false, the system marginal is
-- constant across the two system states.
mṛjana : fst (parivṛtti (true , false)) ≡ fst (parivṛtti (false , false))
mṛjana = refl

-- Export, by refl: the environment marginal carries the bit out.
niryāta : snd (parivṛtti (true , false)) ≡ true
niryāta = refl

-- The displaced distinction, exhibited: after the erasing gate, the
-- environment separates what the system no longer can.
apasārita-bheda : snd (parivṛtti (true , false)) ≡ snd (parivṛtti (false , false)) → ⊥
apasārita-bheda = true≢false

-- And the general law lands on the instance: the swap could not have
-- done otherwise, being reversible.
avaśya-apasāraṇa : snd (parivṛtti (true , false)) ≡ snd (parivṛtti (false , false)) → ⊥
avaśya-apasāraṇa =
  apasāraṇa parivṛtti parivṛtti-viloma true false false
    (λ p → true≢false p) mṛjana
