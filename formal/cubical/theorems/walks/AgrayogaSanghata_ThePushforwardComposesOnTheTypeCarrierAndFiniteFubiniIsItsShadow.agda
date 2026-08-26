{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अग्रयोग-सङ्घातः — the pushforward composes on the Type carrier, and
-- every finite Fubini is its shadow.
--
-- THE JOIN THIS LANDS.  The owner's transmission (2026-08-23) names the
-- next finite theorem: g_!(f_!w) ≡ (g∘f)_!w — Fubini as transport,
-- needing two receipts: (1) the equivalence between the index types,
-- (2) invariance of the fold under that reindexing.  Receipt (1) has
-- been checked in this tree since SankramanaSesa §3 under the name
-- शेष-सङ्घातः — residuals compose, `शेष (g∘f) c ≃ Σ[w ∈ शेष g c] शेष f
-- (fst w)` — and nobody had told the measure lane.  This module cashes
-- it at the TOP of the carrier table: for W = Type, "sum over the
-- fiber" IS Σ, the pushforward is
--
--     अग्रयोगः f F y  =  Σ[ u ∈ शेष f y ] F (fst u)
--
-- and Fubini is not a fold identity but an EQUIVALENCE OF TYPES —
-- proved below as शेष-सङ्घातः composed with Σ-associativity, nothing
-- else.  The load-bearing computational fact: सङ्घातः's forward map is
-- `fwd (a , p) = ((f a , p) , (a , refl))`, so the base point is
-- preserved DEFINITIONALLY (`fst (snd (fwd v)) ≐ fst v`), which is why
-- `Σ-cong-equiv-fst` applies with no transport residue: this Fubini is
-- judgmentally flat in the coordinate that matters.
--
-- WHY THE TYPE ROW IS THE MASTER.  The carrier table (Bool reachability,
-- ℕ counting, tropical cost, ℝ₊ probability, ℂ amplitude, Type the full
-- uncollapsed history fiber) is a ladder of lawful forgettings.  Every
-- W-valued finite Fubini is THIS equivalence read through a fold: apply
-- an enumeration-invariant `total` (the measure lane's receipt, its
-- permutation-invariance probe on the नाडी route as this is written) to
-- both sides, and the fold's invariance under the reindexing that THIS
-- module exhibits is exactly receipt (2).  So the division of labour,
-- named for the fleet: the equivalence receipt is here and in
-- SankramanaSesa; the fold receipt is the measure lane's; their
-- composition is W-Fubini for every carrier in the table at once.
-- Functoriality of pushforward = change of variables = Fubini: one
-- theorem, and on the Type row it costs two library lemmas.
--
-- COMPOUND BUILT HERE (naming rule, note 2): अग्रयोग (the forward
-- yoking — the pushforward), सङ्घात (composition/stacking, following
-- SankramanaSesa's शेष-सङ्घातः).  No source text is claimed for the
-- compound; the mathematics is HoTT-standard (Σ over a fiber; the
-- composite-fiber splitting is HoTT 4.8.2's neighbourhood), composed.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5 (the live carrier), exit 0, no
-- postulates, no holes.
------------------------------------------------------------------------

module AgrayogaSanghata_ThePushforwardComposesOnTheTypeCarrierAndFiniteFubiniIsItsShadow where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function using (_∘_ ; idfun)
open import Cubical.Data.Sigma
  using (Σ-syntax ; _,_ ; Σ-assoc-≃ ; Σ-cong-equiv-fst ; Σ-contractFst)

open import SankramanaSesa_EveryTransportOwesItsResidual
  using (शेष ; शेष-सङ्घातः)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- १ · अग्रयोगः — the pushforward on the Type carrier.  What lives over
-- an observed point is: a residual (a preimage with its witness),
-- together with the family's content at that preimage.  The dependent
-- sum IS the integral; no fold, no enumeration, nothing forgotten.
------------------------------------------------------------------------

अग्रयोगः : {A B : Type ℓ} (f : A → B) (F : A → Type ℓ) → B → Type ℓ
अग्रयोगः f F y = Σ[ u ∈ शेष f y ] F (fst u)

------------------------------------------------------------------------
-- २ · THE THEOREM.  Pushing forward in two stages is pushing forward
-- once along the composite — as an equivalence of types, at every point
-- of the far codomain.  Receipt (1) is शेष-सङ्घातः; the regrouping is
-- Σ-associativity; the family congruence is definitional because
-- सङ्घातः preserves the base point on the nose.
------------------------------------------------------------------------

module _ {A B C : Type ℓ} (f : A → B) (g : B → C) (F : A → Type ℓ) (z : C) where

  अग्रयोग-सङ्घातः : अग्रयोगः (g ∘ f) F z ≃ अग्रयोगः g (अग्रयोगः f F) z
  अग्रयोग-सङ्घातः =
    compEquiv
      (Σ-cong-equiv-fst {B = λ q → F (fst (snd q))} (शेष-सङ्घातः f g z))
      (Σ-assoc-≃)

------------------------------------------------------------------------
-- ३ · The identity law, for the record: pushing forward along the
-- identity changes nothing but the dress.  The residual of id at a is
-- the inverse-singleton Σ[x] (x ≡ a) — contractible with centre
-- (a , refl) — so the pushforward contracts back to the family, and
-- with the theorem above this makes अग्रयोगः a functor up to
-- equivalence: identity to identity, composition to composition.
------------------------------------------------------------------------

module _ {A : Type ℓ} (F : A → Type ℓ) (a : A) where

  private
    -- the standard contraction of Σ[x] (x ≡ a), written out so the
    -- centre is visibly (a , refl) and nothing is imported for it
    सङ्कोचः : isContr (शेष (idfun A) a)
    सङ्कोचः = (a , refl) , λ { (x , p) i → p (~ i) , λ j → p (~ i ∨ j) }

  अग्रयोग-अभिज्ञानम् : अग्रयोगः (idfun A) F a ≃ F a
  अग्रयोग-अभिज्ञानम् = Σ-contractFst सङ्कोचः
