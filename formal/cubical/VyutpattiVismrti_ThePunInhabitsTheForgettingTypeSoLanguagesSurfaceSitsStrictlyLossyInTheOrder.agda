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
-- व्युत्पत्ति-विस्मृति — the pun inhabits the forgetting type, so the
-- surface of language sits strictly lossy in the loss order.
--
-- Joins two modules landed hours apart tonight:
--
--   Vyapti_TheLossOrder…  defines विस्मृतिः Φ for a FLOW Φ : A → A —
--     Σ[ a ] Σ[ a' ] (Φ a ≡ Φ a') × ¬ (a ≡ a') — and proves a
--     reversible flow forgets nothing (समत्वे-न-विस्मृतिः).
--
--   Vyutpatti_TheSurfaceForm…  proves language's surface map collides
--     (the śleṣa: two derivations, one spelling) and admits no faithful
--     reader.
--
-- This module is the one-term bridge: the erasure type generalizes
-- verbatim from flows to arbitrary maps f : A → B (same Σ, codomain
-- freed — the generalization is this file's, not Vyapti's, and is
-- flagged as such), the pun inhabits it, and Vyapti's own emptiness
-- lemma transposes: an equivalence has empty forgetting, so an
-- inhabited forgetting refutes equivalence.  Language's surface map is
-- thereby PLACED: strictly above the lossless pole, by a checked
-- witness rather than by philosophy of language.  What the tradition
-- plays as śleṣa, the loss order books as विस्मृति — one object,
-- two standpoints, both now terms.
------------------------------------------------------------------------

module VyutpattiVismrti_ThePunInhabitsTheForgettingTypeSoLanguagesSurfaceSitsStrictlyLossyInTheOrder where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma using (Σ; _,_; _×_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Vyutpatti_TheSurfaceFormIsALossyProjectionOfDerivationAndMeaningRidesTheDerivation
  using (Derivation; root; dhA; dhB; Surface; surface; collision; no-faithful-reader)

private
  variable
    ℓ ℓ' : Level

-- the forgetting type, freed from the endomap: Vyapti §६'s Σ with the
-- codomain generalized (the generalization is made here).
विस्मृति : {A : Type ℓ} {B : Type ℓ'} → (A → B) → Type (ℓ-max ℓ ℓ')
विस्मृति {A = A} f = Σ[ a ∈ A ] Σ[ a' ∈ A ] (f a ≡ f a') × (¬ (a ≡ a'))

-- an equivalence forgets nothing — Vyapti ६·१, transposed verbatim.
समत्वे-न-विस्मृति : {A : Type ℓ} {B : Type ℓ'} {f : A → B}
  → isEquiv f → ¬ विस्मृति f
समत्वे-न-विस्मृति {f = f} e (a , a' , q , n) =
  n (sym (retEq (f , e) a) ∙ cong (invEq (f , e)) q ∙ retEq (f , e) a')

-- THE PUN IS THE INHABITANT.  Two derivations, one spelling, provably
-- distinct — the śleṣa as a point of the forgetting type.
roots-differ : root dhA ≡ root dhB → ⊥
roots-differ p = no-faithful-reader ((λ _ → root dhA) , refl , p)

श्लेष-विस्मृति : विस्मृति surface
श्लेष-विस्मृति = root dhA , root dhB , collision , roots-differ

-- and therefore the surface of language is NOT an equivalence — placed
-- strictly above the lossless pole of the loss order, by a witness.
surface-not-equiv : isEquiv surface → ⊥
surface-not-equiv e = समत्वे-न-विस्मृति e श्लेष-विस्मृति
