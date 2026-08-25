{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समविभागः — transitive symmetry, normalization, and unique division
-- force the uniform measure.
--
-- TERM.  सम (equal) and विभाग (division, apportionment) are ordinary
-- Sanskrit; the compound सम-विभाग, "the equal apportionment", is built
-- HERE for this object and no source is claimed for it (CLAUDE.md,
-- naming rule, note 2).
--
-- SEED.  The owner's transmission of 2026-08-23 ("the fibre of
-- forgetting"), term 2 of the four determined landings:
--
--     Transitive(G ↷ X) → Invariant(w) → Normalized(w)
--       → UniqueNDivision(W, n) → the weight rule is unique.
--
-- For n equivalent outcomes it forces 1/n: finite Haar measure in the
-- repository's carrier language.  The landed two-outcome theorem
-- (`EkatvaMatraDvaya_…`, this directory) is the n = 2 instance: at
-- X = Fin 2 the iterate गुणः 1 y is y +ᵂ y, so this module's
-- `divideUniquely` hypothesis is EXACTLY that module's
-- `halvesUniquely`, over Fin 2 in place of Bool.  (The Bool ≃ Fin 2
-- shim is not built here; the correspondence is stated, not wired.)
--
-- ONE FINDING BEYOND THE TRANSMISSION'S STATEMENT, visible only once
-- the proof is written: THE GROUP LAWS ARE NEVER CONSUMED.  G below is
-- a bare type with a bare action function — no unit, no composition,
-- no inverses, no associativity.  Transitivity of the action and
-- invariance of the weight are the whole input.  So the theorem is
-- sharper than "finite Haar": any transitive family of symmetries,
-- lawless or not, already forces uniformity.  The group structure is
-- required to EXHIBIT transitive symmetry families, not to spend them.
--
-- WHAT IS PROVED.
--
--   साम्यम्        invariance under a transitive action makes the
--                 weight constant — two lines, no group laws.
--   योग-गुणः      the total of a constant weight is the n-fold sum.
--   भागः          every normalized invariant weight exhibits w(x₀) as
--                 an n-th part of 𝟙.
--   समविभागः      THE THEOREM: if n-th parts of 𝟙 are unique
--                 (isProp (Σ y, गुणः y ≡ 𝟙)), any two normalized
--                 invariant weights agree pointwise.
--   अस्ति         existence: an n-th part of 𝟙 yields the uniform
--                 rule, normalized and invariant under EVERY action.
--   एकाकित्वम्     packaging: over a set W, with an n-th part given,
--                 the type of normalized invariant weight rules is
--                 contractible — isContr(WeightRule), as transmitted.
--
-- WHAT IS NOT CLAIMED.  Steps 3–5 of the transmitted Born ladder
-- (equal-amplitude refinement, rational weights by fibre pushforward,
-- continuity/noncontextual extension) are NOT touched: they stay
-- distinct and open, per the transmission's own instruction that they
-- must not be collapsed into "Gleason handles it".  Nothing here is
-- about amplitudes; this is the finite uniform-orbit floor only.
------------------------------------------------------------------------

module SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isPropΠ ; isPropΠ2)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- The sums.  The carrier needs only _+ᵂ_ and 𝟙; no zero element is
-- ever required, because X = Fin (suc m) is nonempty and every fold
-- is over suc m elements.
------------------------------------------------------------------------

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W) where

  total : (m : ℕ) → (Fin (suc m) → W) → W
  total zero    w = w fzero
  total (suc m) w = w fzero +ᵂ total m (λ i → w (fsuc i))

  -- the (m+1)-fold sum of one element.
  गुणः : (m : ℕ) → W → W
  गुणः zero    y = y
  गुणः (suc m) y = y +ᵂ गुणः m y

  -- total respects pointwise identification.
  total-ext : (m : ℕ) (w v : Fin (suc m) → W)
            → ((i : Fin (suc m)) → w i ≡ v i)
            → total m w ≡ total m v
  total-ext zero    w v h = h fzero
  total-ext (suc m) w v h =
    λ j → h fzero j +ᵂ total-ext m (λ i → w (fsuc i)) (λ i → v (fsuc i))
                                   (λ i → h (fsuc i)) j

  -- the total of a constant family is the fold.
  total-const : (m : ℕ) (y : W) → total m (λ _ → y) ≡ गुणः m y
  total-const zero    y = refl
  total-const (suc m) y = cong (y +ᵂ_) (total-const m y)

------------------------------------------------------------------------
-- The theorem, over a bare transitive action.
------------------------------------------------------------------------

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W) (𝟙 : W) (m : ℕ)
         {G : Type ℓ'} (_·_ : G → Fin (suc m) → Fin (suc m))
         (सङ्क्रामकता : (x y : Fin (suc m)) → Σ[ g ∈ G ] (g · x) ≡ y)
         (divideUniquely : isProp (Σ[ y ∈ W ] गुणः _+ᵂ_ m y ≡ 𝟙)) where

  -- a normalized, invariant weight rule.
  record समभारिन् (w : Fin (suc m) → W) : Type (ℓ-max ℓ ℓ') where
    field
      योगः  : total _+ᵂ_ m w ≡ 𝟙
      अन्वयः : (g : G) (x : Fin (suc m)) → w (g · x) ≡ w x

  open समभारिन्

  -- invariance + transitivity ⟹ constancy.  No group laws consumed.
  साम्यम् : (w : Fin (suc m) → W) → समभारिन् w
          → (x y : Fin (suc m)) → w x ≡ w y
  साम्यम् w s x y with सङ्क्रामकता y x
  ... | g , p = sym (cong w p) ∙ अन्वयः s g y

  -- every rule exhibits w(fzero) as an (m+1)-th part of 𝟙.
  भागः : (w : Fin (suc m) → W) → समभारिन् w
       → Σ[ y ∈ W ] गुणः _+ᵂ_ m y ≡ 𝟙
  भागः w s = w fzero ,
    ( sym (total-const _+ᵂ_ m (w fzero))
    ∙ sym (total-ext _+ᵂ_ m w (λ _ → w fzero) (λ i → साम्यम् w s i fzero))
    ∙ योगः s )

  -- THE THEOREM: the weight rule is unique, pointwise.
  समविभागः : (w w' : Fin (suc m) → W)
           → समभारिन् w → समभारिन् w'
           → (x : Fin (suc m)) → w x ≡ w' x
  समविभागः w w' s s' x =
      साम्यम् w s x fzero
    ∙ cong fst (divideUniquely (भागः w s) (भागः w' s'))
    ∙ साम्यम् w' s' fzero x

  -- existence: an (m+1)-th part of 𝟙 yields the uniform rule.
  अस्ति : (द : Σ[ y ∈ W ] गुणः _+ᵂ_ m y ≡ 𝟙)
        → Σ[ w ∈ (Fin (suc m) → W) ] समभारिन् w
  अस्ति (y , p) = (λ _ → y) ,
    record { योगः = total-const _+ᵂ_ m y ∙ p
           ; अन्वयः = λ _ _ → refl }

  -- packaging, as transmitted: over a set W the rule type contracts.
  एकाकित्वम् : isSet W
            → (द : Σ[ y ∈ W ] गुणः _+ᵂ_ m y ≡ 𝟙)
            → isContr (Σ[ w ∈ (Fin (suc m) → W) ] समभारिन् w)
  एकाकित्वम् isSetW द = अस्ति द , contract where
    isProp-समभारिन् : (w : Fin (suc m) → W) → isProp (समभारिन् w)
    isProp-समभारिन् w s t i = record
      { योगः  = isSetW _ _ (योगः s) (योगः t) i
      ; अन्वयः = isPropΠ2 (λ g x → isSetW _ _) (अन्वयः s) (अन्वयः t) i }
    contract : (r : Σ[ w ∈ (Fin (suc m) → W) ] समभारिन् w)
             → अस्ति द ≡ r
    contract (w , s) = Σ≡Prop isProp-समभारिन्
      (funExt (λ x → समविभागः _ w (snd (अस्ति द)) s x))
