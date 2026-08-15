{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PolarityClosure
--
-- THE BIRKHOFF POLARITY OF A RELATION, AND THE VACUITY OF THE BOOLEAN
-- GLOSS.
--
-- Companion prose: `notes/APOHA_AND_POLARITY.md` (2026-08-15), which
-- identifies D0020 §5's apoha display and §7's two-sided evaluation
-- with the closure operator of `notes/CHANGING_TESTS_VERSUS_SHRINKING.md`
-- Prop. 6.3 — the ANTITONE one, A(S) = {t : ∼_S ⊆ ∼_{t}}, the
-- derivation closure of the formal context (X × X, T, Rᶜ).  It is NOT
-- Theorem B's monotone redundancy closure C_σ; §3 of that note corrects
-- D0020 §J3's pointer on exactly this point, and this module formalises
-- the antitone one.
--
-- Sibling module: `ExclusionScope.agda` (genius-02, 2026-08-14), which
-- settles exclusion on Eq(X) — the repository's actual meaning-carriers
-- — and finds the relative pseudo-complement repair FAILS for |X| ≥ 3.
-- That module is about Eq(X); this one is about the powerset P(X) and
-- about polarities of an arbitrary relation.  They are the two halves of
-- APOHA_AND_POLARITY §4.1's pairing ("the gloss is either vacuous or
-- unavailable"): ExclusionScope owns "unavailable", this module owns
-- "vacuous".  Nothing here duplicates it — no statement of
-- ExclusionScope is restated, and no lattice of equivalence relations
-- appears below.
--
-- CONTENTS (all --safe, no postulates, no holes):
--
--   §1  `Polarity`.  For an arbitrary ε : A → B → Type, the two polarity
--       maps ⊥⁺, ⊥⁻ are antitone (`perp⁺-anti`, `perp⁻-anti`), form a
--       Galois connection (`galois-→`, `galois-←`), and cl = ⊥⁺ then ⊥⁻
--       is extensive (`cl-ext`), monotone (`cl-mono`) and idempotent
--       (`cl-idem`).  UNCONDITIONALLY: no hypothesis whatever on ε, on
--       A, on B, or on the subsets.  This is APOHA_AND_POLARITY §2's
--       "yes, unconditionally", as a term.
--
--   §2  THE SHARP FINDING.  Read D0020 §5's Boolean gloss
--       ⟦गो⟧ = ¬⟦अगो⟧ as the DEFINITION of ⊥ — i.e. A = B = X and
--       ε = inequality.  Then
--         `perp-is-complement` : α⊥ is the complement of α, and
--         `cl-is-¬¬`          : cl α is the DOUBLE COMPLEMENT ¬¬α,
--       both unconditionally, and
--         `cl-identity-on-Dec`: cl α = α whenever α is pointwise
--                               decidable — in particular
--         `boolean-gloss-vacuous` for α : X → Bool.
--       So the boxed display α ↦ α^⊥⊥ is the IDENTITY MAP and carries
--       zero content.  Every set is closed; the concept lattice is the
--       whole powerset.
--
--       CONSTRUCTIVE REFINEMENT, not in the note.  What holds for every
--       α is cl α = ¬¬α, and that is the identity exactly when α is
--       decidable.  The note's "α^⊥⊥ = X \ (X \ α) = α" silently uses
--       excluded middle.  The vacuity claim survives — sets in a
--       "pre-given universe" in the classical reading are decidable
--       subsets, and the Bool-valued corollary is the honest form of it
--       — but the general statement of the identity is FALSE without
--       decidability, and this module states which one it proves.
--
--   §3  THE CONTRAST.  Vacuity is a property of the Boolean gloss, not
--       of the construction.  `cl-not-identity` exhibits a specific ε
--       (on Unit, the total relation) with cl ≠ id, as a term of type
--       ¬ (∀ α → cl α ⊆ α).  A one-point contrast is enough and is the
--       smallest one; no finite search is needed.
--
--   §4  THE OPEN EDGE of the note, settled.  For an indexed family
--       ε_ι, the flattening ε̂(ξ,(ι,κ)) := ε_ι(ξ,κ) gives
--         `flatten` : cl_ε̂ α = ⋂_ι cl_{ε_ι} α    (both inclusions),
--       matching Def. B.3's C(S) = ⋂_σ C_σ(S), and therefore
--         `intersection-idem` : that intersection IS idempotent —
--       not because intersections of closures are (they are not), but
--       because this one is itself a double polar.  This is the note's
--       §2 remark discharged as a proof rather than an explanation.
--
-- Subset equality is bi-inclusion `_≐_` throughout, never a path: the
-- subsets here are arbitrary Type-valued predicates, not h-propositions,
-- so propositional extensionality is unavailable and pretending
-- otherwise would need a truncation the mathematics does not want.
-- Every statement below is therefore an inclusion or a pair of them.
------------------------------------------------------------------------

module PolarityClosure where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_; _,_; fst; snd)
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Bool using (Bool; true; false)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_; Dec; yes; no)

------------------------------------------------------------------------
-- §0.  Subsets, inclusion, bi-inclusion.
------------------------------------------------------------------------

Sub : ∀ {ℓ} → Type ℓ → Type (ℓ-suc ℓ)
Sub {ℓ} T = T → Type ℓ

module _ {ℓ} {T : Type ℓ} where

  _⊑_ : Sub T → Sub T → Type ℓ
  α ⊑ β = (t : T) → α t → β t

  infix 4 _⊑_

  ⊑-refl : (α : Sub T) → α ⊑ α
  ⊑-refl α t x = x

  ⊑-trans : {α β γ : Sub T} → α ⊑ β → β ⊑ γ → α ⊑ γ
  ⊑-trans f g t x = g t (f t x)

  -- Bi-inclusion: the equality of subsets used everywhere below.
  _≐_ : Sub T → Sub T → Type ℓ
  α ≐ β = (α ⊑ β) × (β ⊑ α)

  infix 4 _≐_

  ≐-refl : (α : Sub T) → α ≐ α
  ≐-refl α = ⊑-refl α , ⊑-refl α

  ≐-sym : {α β : Sub T} → α ≐ β → β ≐ α
  ≐-sym (f , g) = g , f

  ≐-trans : {α β γ : Sub T} → α ≐ β → β ≐ γ → α ≐ γ
  ≐-trans (f , f') (g , g') = ⊑-trans f g , ⊑-trans g' f'

------------------------------------------------------------------------
-- §1.  The polarity of an arbitrary relation.
--
--   ε : A → B → Type ℓ   is D0020 §7's two-sided evaluation
--   (χ⁺ = A the witnesses साक्षी, χ⁻ = B the counter-witnesses
--   प्रतिसाक्षी), equivalently the incidence I = ε⁻¹(1) of the formal
--   context (A , B , I) of Wille 1982.  Under APOHA_AND_POLARITY §2's
--   dictionary: A = X × X, B = T, ε = Rᶜ = "t does not separate the
--   pair", and cl on the B-side is Prop. 6.3's A(S).
------------------------------------------------------------------------

module Polarity {ℓ} {A B : Type ℓ} (ε : A → B → Type ℓ) where

  -- α ↦ α^⊥ for α ⊆ A:  the counter-witnesses that ε-relate to all of α.
  perp⁺ : Sub A → Sub B
  perp⁺ α b = (a : A) → α a → ε a b

  -- β ↦ β^⊥ for β ⊆ B:  the mirror half.
  perp⁻ : Sub B → Sub A
  perp⁻ β a = (b : B) → β b → ε a b

  -- Both maps are ANTITONE.
  perp⁺-anti : {α α' : Sub A} → α ⊑ α' → perp⁺ α' ⊑ perp⁺ α
  perp⁺-anti s b h a αa = h a (s a αa)

  perp⁻-anti : {β β' : Sub B} → β ⊑ β' → perp⁻ β' ⊑ perp⁻ β
  perp⁻-anti s a h b βb = h b (s b βb)

  -- The GALOIS CONNECTION (antitone form):  α ⊆ β^⊥  ⟺  β ⊆ α^⊥.
  -- Both directions are the same swap of the two universal quantifiers,
  -- which is why no hypothesis on ε is ever needed.
  galois-→ : {α : Sub A} {β : Sub B} → α ⊑ perp⁻ β → β ⊑ perp⁺ α
  galois-→ h b βb a αa = h a αa b βb

  galois-← : {α : Sub A} {β : Sub B} → β ⊑ perp⁺ α → α ⊑ perp⁻ β
  galois-← h a αa b βb = h b βb a αa

  -- The two unit inclusions.
  unit⁺ : (α : Sub A) → α ⊑ perp⁻ (perp⁺ α)
  unit⁺ α = galois-← (⊑-refl (perp⁺ α))

  unit⁻ : (β : Sub B) → β ⊑ perp⁺ (perp⁻ β)
  unit⁻ β = galois-→ (⊑-refl (perp⁻ β))

  -- THE CLOSURE OPERATOR α ↦ α^⊥⊥ on the A-side.
  cl : Sub A → Sub A
  cl α = perp⁻ (perp⁺ α)

  cl-ext : (α : Sub A) → α ⊑ cl α
  cl-ext = unit⁺

  cl-mono : {α α' : Sub A} → α ⊑ α' → cl α ⊑ cl α'
  cl-mono s = perp⁻-anti (perp⁺-anti s)

  cl-cong : {α α' : Sub A} → α ≐ α' → cl α ≐ cl α'
  cl-cong (f , g) = cl-mono f , cl-mono g

  -- The triple-polar identity α^⊥ = α^⊥⊥⊥, from which idempotence.
  triple : (α : Sub A) → perp⁺ (cl α) ≐ perp⁺ α
  triple α = perp⁺-anti (cl-ext α) , unit⁻ (perp⁺ α)

  -- IDEMPOTENCE, UNCONDITIONALLY.  No hypothesis on ε: this is
  -- APOHA_AND_POLARITY §2's answer to D0020 §J3, as a term.
  cl-idem : (α : Sub A) → cl (cl α) ≐ cl α
  cl-idem α = perp⁻-anti (snd (triple α)) , perp⁻-anti (fst (triple α))

  -- Same three properties on the mirror (B-) side, for free.  The note
  -- flags the χ⁺-side closure as never used by the repository; here it
  -- is, at no cost, since the construction is symmetric in the two
  -- sorts.  (What it CONTAINS on the pair-context is a separate
  -- question and is not addressed here.)
  cl' : Sub B → Sub B
  cl' β = perp⁺ (perp⁻ β)

  cl'-ext : (β : Sub B) → β ⊑ cl' β
  cl'-ext = unit⁻

  cl'-mono : {β β' : Sub B} → β ⊑ β' → cl' β ⊑ cl' β'
  cl'-mono s = perp⁺-anti (perp⁻-anti s)

  cl'-idem : (β : Sub B) → cl' (cl' β) ≐ cl' β
  cl'-idem β =
      perp⁺-anti (perp⁻-anti (cl'-ext β))
    , perp⁺-anti (unit⁺ (perp⁻ β))

------------------------------------------------------------------------
-- §2.  THE BOOLEAN GLOSS, AND ITS VACUITY.
--
-- D0020 §5 writes ⟦गो⟧ = ¬⟦अगो⟧ (Boolean complement in a pre-given
-- universe) in the same breath as the boxed α ↦ α^⊥⊥.  Read the first
-- as the definition of the second: A = B = X and ε(ξ,κ) = (ξ ≠ κ).
------------------------------------------------------------------------

module BooleanGloss {ℓ} (X : Type ℓ) where

  -- ε = inequality on a pre-given universe.
  ε≠ : X → X → Type ℓ
  ε≠ x y = ¬ (x ≡ y)

  open Polarity ε≠ public

  -- α^⊥ IS the complement.  Unconditional; the backward direction is
  -- the only place a path is transported.
  perp-is-complement : (α : Sub X) → perp⁺ α ≐ (λ x → ¬ (α x))
  perp-is-complement α =
      (λ y h αy → h y αy refl)
    , (λ y n a αa p → n (subst α p αa))

  -- α^⊥⊥ IS the double complement.  Unconditional.
  cl-is-¬¬ : (α : Sub X) → cl α ≐ (λ x → ¬ ¬ (α x))
  cl-is-¬¬ α =
      (λ x h n → h x (λ a αa p → n (subst α p αa)) refl)
    , (λ x nn b hb p → nn (λ αx → hb x αx p))

  -- ... hence THE CLOSURE IS THE IDENTITY on decidable subsets, which
  -- is what "a subset of a pre-given universe" means classically.
  -- THE BOXED DISPLAY IS VACUOUS.
  cl-identity-on-Dec : (α : Sub X) → ((x : X) → Dec (α x)) → cl α ≐ α
  cl-identity-on-Dec α d =
      (λ x h → ¬¬-out x (fst (cl-is-¬¬ α) x h))
    , cl-ext α
    where
    ¬¬-out : (x : X) → ¬ ¬ (α x) → α x
    ¬¬-out x nn with d x
    ... | yes p = p
    ... | no  k = Cubical.Data.Empty.rec (nn k)

-- The Bool-valued corollary: a subset given by a characteristic
-- function is decidable, so for it the closure is literally the
-- identity map.  This is the vacuity of D0020 §5's boxed display, as a
-- term.
module BooleanGlossVacuous {ℓ} (X : Type ℓ) where

  open BooleanGloss X

  El : Bool → Type ℓ
  El true  = Lift Unit
  El false = Lift ⊥

  El-Dec : (b : Bool) → Dec (El b)
  El-Dec true  = yes (lift tt)
  El-Dec false = no (λ z → lower z)

  boolean-gloss-vacuous : (χ : X → Bool) → cl (λ x → El (χ x)) ≐ (λ x → El (χ x))
  boolean-gloss-vacuous χ =
    cl-identity-on-Dec (λ x → El (χ x)) (λ x → El-Dec (χ x))

------------------------------------------------------------------------
-- §3.  THE CONTRAST: vacuity belongs to the gloss, not to the
-- construction.
--
-- One point and the TOTAL relation already break it: every subset has
-- the full set as its closure, so the empty subset is not closed.
------------------------------------------------------------------------

module Contrast where

  εtotal : Unit → Unit → Type₀
  εtotal _ _ = Unit

  open Polarity εtotal

  ∅ : Sub Unit
  ∅ _ = ⊥

  -- The closure of ∅ is inhabited at the point, while ∅ is not.
  cl-∅-full : cl ∅ tt
  cl-∅-full _ _ = tt

  -- Hence cl is NOT the identity for this ε: it is not deflationary.
  cl-not-identity : ¬ ((α : Sub Unit) → cl α ⊑ α)
  cl-not-identity h = h ∅ tt cl-∅-full

------------------------------------------------------------------------
-- §4.  THE INDEXED CASE, AND THE OPEN EDGE.
--
-- D0020 §6 carries an indexed family ε_ι — genuinely three-place.
-- APOHA_AND_POLARITY §2 flattens it: ε̂(ξ,(ι,κ)) := ε_ι(ξ,κ) on
-- A × (I × B).  The claim to check is
--     α^⊥̂⊥̂ = ⋂_ι α^⊥_ι⊥_ι,
-- matching Def. B.3's C(S) = ⋂_σ C_σ(S), together with the note's
-- remark that idempotence of an intersection of closures is not
-- automatic.  Both are settled below: the identity is two inclusions of
-- pure quantifier reassociation, and idempotence follows because the
-- intersection is itself a double polar, so §1's `cl-idem` applies.
------------------------------------------------------------------------

module Indexed {ℓ} {I A B : Type ℓ} (ε : I → A → B → Type ℓ) where

  -- the flattened two-place datum
  ε̂ : A → (I × B) → Type ℓ
  ε̂ a ib = ε (fst ib) a (snd ib)

  open Polarity ε̂ using () renaming (cl to clHat; cl-idem to clHat-idem; cl-cong to clHat-cong)

  -- the closure at index ι
  clAt : I → Sub A → Sub A
  clAt i = Polarity.cl (ε i)

  -- the intersection of the indexed closures — Def. B.3's shape
  ⋂cl : Sub A → Sub A
  ⋂cl α a = (i : I) → clAt i α a

  -- THE FLATTENING.  Both inclusions; Σ-eta does the work.
  flatten : (α : Sub A) → clHat α ≐ ⋂cl α
  flatten α =
      (λ a h i b hb → h (i , b) hb)
    , (λ a h ib hb → h a' (fst ib) (snd ib) hb)
    where
    a' : A → A
    a' x = x
    -- (the `where` is only to keep the two arguments of `h` readable;
    --  `h` has type (i : I) (b : B) → … after unfolding ⋂cl at `a`)

  -- IDEMPOTENCE OF THE INTERSECTION.  Not inherited from "intersection
  -- of closures" — that inference is invalid in general, which is
  -- exactly what Def. B.3 flags — but from the fact that this
  -- particular intersection IS a double polar.
  intersection-idem : (α : Sub A) → ⋂cl (⋂cl α) ≐ ⋂cl α
  intersection-idem α =
    ≐-trans (≐-sym (flatten (⋂cl α)))
      (≐-trans (clHat-cong (≐-sym (flatten α)))
        (≐-trans (clHat-idem α) (flatten α)))

  -- ... and it is a closure operator outright.
  intersection-ext : (α : Sub A) → α ⊑ ⋂cl α
  intersection-ext α a αa i = Polarity.cl-ext (ε i) α a αa

  intersection-mono : {α α' : Sub A} → α ⊑ α' → ⋂cl α ⊑ ⋂cl α'
  intersection-mono s a h i = Polarity.cl-mono (ε _) s a (h i)
