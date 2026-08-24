-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

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
-- D0020 §J3's pointer on exactly this point, and it is the antitone one
-- that is formalised below.  Every map called `perp` here reverses
-- inclusion, which is the check that the right closure is in hand.
--
-- Sibling module: `ExclusionScope.agda` (genius-02, 2026-08-14), which
-- settles exclusion on Eq(X) — the repository's actual meaning-carriers
-- — and finds the relative pseudo-complement repair FAILS for |X| ≥ 3.
-- That module is about Eq(X); this one is about the powerset P(X) and
-- about polarities of an arbitrary relation.  They are the two halves of
-- APOHA_AND_POLARITY §4.1's pairing ("the gloss is either vacuous or
-- unavailable"): ExclusionScope owns "unavailable", this module owns
-- "vacuous".  Nothing here duplicates it — no statement of
-- ExclusionScope is restated and no lattice of equivalence relations
-- appears below.
--
-- CONTENTS (all --safe, no postulates, no holes):
--
--   §1  `Polarity`.  For an arbitrary ε : A → B → Type, the two polarity
--       maps perp⁺, perp⁻ are antitone (`perp⁺-anti`, `perp⁻-anti`),
--       form a Galois connection (`galois-→`, `galois-←`), and
--       cl = perp⁻ ∘ perp⁺ is extensive (`cl-ext`), monotone
--       (`cl-mono`) and idempotent (`cl-idem`).  UNCONDITIONALLY: no
--       hypothesis whatever on ε, on A, on B, or on the subsets.  This
--       is APOHA_AND_POLARITY §2's "yes, unconditionally" as a term,
--       and answers D0020 §J3's question.  The mirror closure `cl'` on
--       the χ⁺ side — which the note flags as never used by the
--       repository — comes free by symmetry.
--
--   §2  THE SHARP FINDING.  Read D0020 §5's Boolean gloss
--       ⟦गो⟧ = ¬⟦अगो⟧ as the DEFINITION of ⊥ — i.e. A = B = X and
--       ε = inequality.  Then
--         `perp-is-complement` : α^⊥ is the complement of α, and
--         `cl-is-¬¬`          : α^⊥⊥ is the DOUBLE COMPLEMENT ¬¬α,
--       both unconditionally, and
--         `cl-identity-on-Dec`: α^⊥⊥ = α whenever α is pointwise
--                               decidable, in particular
--         `boolean-gloss-vacuous` for α given by a characteristic
--                               function X → Bool.
--       So the boxed display α ↦ α^⊥⊥ is the IDENTITY MAP and carries
--       zero content: every set is closed, the concept lattice is the
--       whole powerset.
--
--       CONSTRUCTIVE REFINEMENT, not in the note.  What holds for EVERY
--       α is cl α = ¬¬α; that is the identity exactly when α is
--       decidable.  The note's "α^⊥⊥ = X \ (X \ α) = α" silently uses
--       excluded middle.  The vacuity claim survives — a subset of a
--       "pre-given universe" in the classical reading is a decidable
--       one, and the Bool-valued corollary is the honest form of it —
--       but the unrestricted identity is NOT constructively provable,
--       and this module states which of the two it proves.
--
--   §3  THE CONTRAST.  Vacuity is a property of the Boolean gloss, not
--       of the construction.  `cl-not-identity` exhibits a specific ε
--       (one point, the total relation) with cl ≠ id, as a term of type
--       ¬ ((α : Pow Unit) → cl α ⊑ α).  A one-point contrast is the
--       smallest possible and needs no finite search.
--
--   §3b THE CONTRAST, NON-DEGENERATE.  §3's witness has the constant
--       full map as its closure, which invites the reply that the only
--       alternative to the identity is triviality.  `Contrast2` refutes
--       that on a TWO-point universe (X = Bool, i.e. Fin 2), with
--       ε(x,y) = (x ≡ true): `cl-T` shows {true} is closed (so cl is
--       not constant) while `cl-F-not-identity` shows {false} is not
--       (so cl is not the identity).  A genuine closure, strictly
--       between the two degenerate ones, at |X| = 2.
--
--   §4  THE OPEN EDGE of the note, settled.  For an indexed family ε_ι,
--       the flattening ε̂(ξ,(ι,κ)) := ε_ι(ξ,κ) gives
--         `flatten` : cl_ε̂ α = ⋂_ι cl_{ε_ι} α    (both inclusions),
--       matching Def. B.3's C(S) = ⋂_σ C_σ(S), and therefore
--         `intersection-idem` : that intersection IS idempotent —
--       not because intersections of closure operators are (they are
--       not, which is what Def. B.3 flags), but because this
--       particular intersection is itself a double polar.  The note
--       calls this an explanation; here it is a proof.
--
-- Subset equality is bi-inclusion `_≐_` throughout, never a path: the
-- subsets here are arbitrary Type-valued predicates, not
-- h-propositions, so propositional extensionality is unavailable and
-- pretending otherwise would need a truncation the mathematics does not
-- want.  Every statement below is therefore an inclusion or a pair of
-- them.
------------------------------------------------------------------------

module PolarityClosure where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_)
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Bool using (Bool; true; false; true≢false)
open import Cubical.Data.Empty using (⊥; rec)
open import Cubical.Relation.Nullary using (¬_; Dec; yes; no)

------------------------------------------------------------------------
-- §0.  Subsets, inclusion, bi-inclusion.
------------------------------------------------------------------------

Pow : ∀ {ℓ} → Type ℓ → Type (ℓ-suc ℓ)
Pow {ℓ} T = T → Type ℓ

module _ {ℓ} {T : Type ℓ} where

  infix 4 _⊑_ _≐_

  _⊑_ : Pow T → Pow T → Type ℓ
  α ⊑ β = (t : T) → α t → β t

  ⊑-refl : (α : Pow T) → α ⊑ α
  ⊑-refl α t x = x

  ⊑-trans : {α β γ : Pow T} → α ⊑ β → β ⊑ γ → α ⊑ γ
  ⊑-trans f g t x = g t (f t x)

  -- Bi-inclusion: the equality of subsets used everywhere below.
  _≐_ : Pow T → Pow T → Type ℓ
  α ≐ β = (α ⊑ β) × (β ⊑ α)

  ≐-refl : (α : Pow T) → α ≐ α
  ≐-refl α = ⊑-refl α , ⊑-refl α

  ≐-sym : {α β : Pow T} → α ≐ β → β ≐ α
  ≐-sym (f , g) = g , f

  ≐-trans : {α β γ : Pow T} → α ≐ β → β ≐ γ → α ≐ γ
  ≐-trans (f , f') (g , g') = ⊑-trans f g , ⊑-trans g' f'

------------------------------------------------------------------------
-- §1.  The polarity of an arbitrary relation.
--
--   ε : A → B → Type ℓ   is D0020 §7's two-sided evaluation
--   (χ⁺ = A, the witnesses साक्षी; χ⁻ = B, the counter-witnesses
--   प्रतिसाक्षी), equivalently the incidence I = ε⁻¹(1) of the formal
--   context (A , B , I) of Wille 1982.  Under APOHA_AND_POLARITY §2's
--   dictionary: A = X × X, B = T, ε = Rᶜ = "t does not separate the
--   pair", and `cl` on the B-side is Prop. 6.3's A(S).
------------------------------------------------------------------------

module Polarity {ℓ} {A B : Type ℓ} (ε : A → B → Type ℓ) where

  -- α ↦ α^⊥ for α ⊆ A: the counter-witnesses ε-related to all of α.
  perp⁺ : Pow A → Pow B
  perp⁺ α b = (a : A) → α a → ε a b

  -- β ↦ β^⊥ for β ⊆ B: the mirror half.
  perp⁻ : Pow B → Pow A
  perp⁻ β a = (b : B) → β b → ε a b

  -- Both maps are ANTITONE.
  perp⁺-anti : {α α' : Pow A} → α ⊑ α' → perp⁺ α' ⊑ perp⁺ α
  perp⁺-anti s b h a αa = h a (s a αa)

  perp⁻-anti : {β β' : Pow B} → β ⊑ β' → perp⁻ β' ⊑ perp⁻ β
  perp⁻-anti s a h b βb = h b (s b βb)

  -- The GALOIS CONNECTION (antitone form): α ⊆ β^⊥ ⟺ β ⊆ α^⊥.
  -- Both directions are the same swap of two universal quantifiers,
  -- which is why no hypothesis on ε is ever needed.
  galois-→ : {α : Pow A} {β : Pow B} → α ⊑ perp⁻ β → β ⊑ perp⁺ α
  galois-→ h b βb a αa = h a αa b βb

  galois-← : {α : Pow A} {β : Pow B} → β ⊑ perp⁺ α → α ⊑ perp⁻ β
  galois-← h a αa b βb = h b βb a αa

  -- The two unit inclusions.
  unit⁺ : (α : Pow A) → α ⊑ perp⁻ (perp⁺ α)
  unit⁺ α = galois-← (⊑-refl (perp⁺ α))

  unit⁻ : (β : Pow B) → β ⊑ perp⁺ (perp⁻ β)
  unit⁻ β = galois-→ (⊑-refl (perp⁻ β))

  -- THE CLOSURE OPERATOR α ↦ α^⊥⊥ on the A-side.
  cl : Pow A → Pow A
  cl α = perp⁻ (perp⁺ α)

  cl-ext : (α : Pow A) → α ⊑ cl α
  cl-ext = unit⁺

  cl-mono : {α α' : Pow A} → α ⊑ α' → cl α ⊑ cl α'
  cl-mono s = perp⁻-anti (perp⁺-anti s)

  cl-cong : {α α' : Pow A} → α ≐ α' → cl α ≐ cl α'
  cl-cong (f , g) = cl-mono f , cl-mono g

  -- The triple-polar identity α^⊥ = α^⊥⊥⊥, whence idempotence.
  triple : (α : Pow A) → perp⁺ (cl α) ≐ perp⁺ α
  triple α = perp⁺-anti (cl-ext α) , unit⁻ (perp⁺ α)

  -- IDEMPOTENCE, UNCONDITIONALLY.  No hypothesis on ε.
  cl-idem : (α : Pow A) → cl (cl α) ≐ cl α
  cl-idem α = perp⁻-anti (snd (triple α)) , perp⁻-anti (fst (triple α))

  -- The mirror closure on the χ⁺ side, free by symmetry.
  cl' : Pow B → Pow B
  cl' β = perp⁺ (perp⁻ β)

  cl'-ext : (β : Pow B) → β ⊑ cl' β
  cl'-ext = unit⁻

  cl'-mono : {β β' : Pow B} → β ⊑ β' → cl' β ⊑ cl' β'
  cl'-mono s = perp⁺-anti (perp⁻-anti s)

  cl'-idem : (β : Pow B) → cl' (cl' β) ≐ cl' β
  cl'-idem β =
      perp⁺-anti (unit⁺ (perp⁻ β))
    , perp⁺-anti (perp⁻-anti (cl'-ext β))

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

  -- α^⊥ IS the complement.  Unconditional.
  perp-is-complement : (α : Pow X) → perp⁺ α ≐ (λ x → ¬ (α x))
  perp-is-complement α =
      (λ y h αy → h y αy refl)
    , (λ y n a αa p → n (subst α p αa))

  -- α^⊥⊥ IS the double complement.  Unconditional.
  cl-is-¬¬ : (α : Pow X) → cl α ≐ (λ x → ¬ ¬ (α x))
  cl-is-¬¬ α =
      (λ x h n → h x (λ a αa p → n (subst α p αa)) refl)
    , (λ x nn b hb p → nn (λ αx → hb x αx p))

  -- ... hence THE CLOSURE IS THE IDENTITY on decidable subsets, which
  -- is what "a subset of a pre-given universe" means classically.
  -- THE BOXED DISPLAY IS VACUOUS.
  ¬¬-out : (α : Pow X) (x : X) → Dec (α x) → ¬ ¬ (α x) → α x
  ¬¬-out α x (yes p) nn = p
  ¬¬-out α x (no k)  nn = rec (nn k)

  cl-identity-on-Dec : (α : Pow X) → ((x : X) → Dec (α x)) → cl α ≐ α
  cl-identity-on-Dec α d =
      (λ x h → ¬¬-out α x (d x) (fst (cl-is-¬¬ α) x h))
    , cl-ext α

-- The Bool-valued corollary, at ℓ-zero to keep the characteristic
-- function's fibres literally Unit and ⊥: a subset given by a
-- characteristic function is decidable, so for it the closure is the
-- identity map.  This is the vacuity of D0020 §5's boxed display as a
-- term.
module BooleanGlossVacuous (X : Type₀) where

  open BooleanGloss X public

  El : Bool → Type₀
  El true  = Unit
  El false = ⊥

  El-Dec : (b : Bool) → Dec (El b)
  El-Dec true  = yes tt
  El-Dec false = no (λ z → z)

  boolean-gloss-vacuous :
    (χ : X → Bool) → cl (λ x → El (χ x)) ≐ (λ x → El (χ x))
  boolean-gloss-vacuous χ =
    cl-identity-on-Dec (λ x → El (χ x)) (λ x → El-Dec (χ x))

------------------------------------------------------------------------
-- §3.  THE CONTRAST: vacuity belongs to the gloss, not to the
-- construction.
--
-- One point and the TOTAL relation already break it: every subset has
-- the full set as its double polar, so the empty subset is not closed.
------------------------------------------------------------------------

module Contrast where

  εtotal : Unit → Unit → Type₀
  εtotal _ _ = Unit

  open Polarity εtotal

  ∅ : Pow Unit
  ∅ _ = ⊥

  -- The closure of ∅ is inhabited at the point, while ∅ is not.
  cl-∅-full : cl ∅ tt
  cl-∅-full _ _ = tt

  -- Hence cl is NOT the identity for this ε: it is not deflationary.
  cl-not-identity : ¬ ((α : Pow Unit) → cl α ⊑ α)
  cl-not-identity h = h ∅ tt cl-∅-full

------------------------------------------------------------------------
-- §3b.  A SHARPER CONTRAST, ON A TWO-POINT UNIVERSE.
--
-- §3 is the smallest possible witness, but it is open to the reply
-- that a one-point universe with the total relation is degenerate: its
-- closure is the CONSTANT map to the full set, so one might suspect
-- that the only alternatives to "identity" are "everything".  They are
-- not.  Take X = Bool (a two-element universe, i.e. Fin 2) and the
-- b-independent relation
--
--     ε(x , y) := (x ≡ true)
--
-- — a legitimate two-sided evaluation in the sense of D0020 §7: the
-- witness ξ is ε-related to a counter-witness κ iff ξ is `true`,
-- irrespective of κ.  For this ε:
--
--   * `cl-T-closed`   : the subset {true} IS closed, so cl is not the
--                       constant full map; and
--   * `cl-F-true`     : the subset {false} is NOT closed — its double
--                       polar contains `true` — so cl is not the
--                       identity either.
--
-- Hence on a universe of size 2 the closure operator can be a genuine,
-- non-degenerate closure: strictly between the identity (which is what
-- §2 shows the Boolean gloss ε = (≠) forces) and the constant map.
-- Vacuity is therefore a property of the GLOSS, not of the size of the
-- universe and not of the construction.
------------------------------------------------------------------------

module Contrast2 where

  -- ε(x , y) = (x ≡ true), independent of the second argument.
  εT : Bool → Bool → Type₀
  εT x _ = x ≡ true

  open Polarity εT

  T F : Pow Bool
  T x = x ≡ true
  F x = x ≡ false

  -- {true} is closed: cl T ⊑ T (and T ⊑ cl T is `cl-ext`).
  cl-T-closed : cl T ⊑ T
  cl-T-closed a h = h true (λ x p → p)

  cl-T : cl T ≐ T
  cl-T = cl-T-closed , cl-ext T

  -- {false} is not closed: `true` lies in its double polar, because
  -- the polar of {false} is empty (nothing ε-related to `false`).
  cl-F-true : cl F true
  cl-F-true b h = refl

  -- ... and `true` is not in {false}.
  ¬F-true : ¬ (F true)
  ¬F-true p = true≢false p

  -- So for this ε the closure is NOT the identity, on a two-point
  -- universe, with a non-empty proper subset as the witness.
  cl-F-not-identity : ¬ (cl F ⊑ F)
  cl-F-not-identity h = ¬F-true (h true cl-F-true)

------------------------------------------------------------------------
-- §4.  THE INDEXED CASE, AND THE OPEN EDGE.
--
-- D0020 §6 carries an indexed family ε_ι — genuinely three-place.
-- APOHA_AND_POLARITY §2 flattens it: ε̂(ξ,(ι,κ)) := ε_ι(ξ,κ) on
-- A × (I × B).  The claim to check is
--     α^⊥̂⊥̂ = ⋂_ι α^⊥_ι⊥_ι,
-- matching Def. B.3's C(S) = ⋂_σ C_σ(S), together with the note's
-- remark that idempotence of an intersection of closures is not
-- automatic.  Both are settled here: the identity is two inclusions of
-- pure quantifier reassociation (Σ-eta does the rest), and idempotence
-- follows because the intersection is itself a double polar, so §1's
-- `cl-idem` applies to it directly.
------------------------------------------------------------------------

module Indexed {ℓ} {I A B : Type ℓ} (ε : I → A → B → Type ℓ) where

  -- the flattened two-place datum
  ε̂ : A → (I × B) → Type ℓ
  ε̂ a ib = ε (fst ib) a (snd ib)

  open Polarity ε̂ using ()
    renaming (cl to clHat; cl-idem to clHat-idem; cl-cong to clHat-cong)

  -- the closure at index ι
  clAt : I → Pow A → Pow A
  clAt i = Polarity.cl (ε i)

  -- the intersection of the indexed closures — Def. B.3's shape
  ⋂cl : Pow A → Pow A
  ⋂cl α a = (i : I) → clAt i α a

  -- THE FLATTENING, both inclusions.
  flatten : (α : Pow A) → clHat α ≐ ⋂cl α
  flatten α =
      (λ a h i b hb → h (i , b) hb)
    , (λ a h ib hb → h (fst ib) (snd ib) hb)

  -- IDEMPOTENCE OF THE INTERSECTION.  Not inherited from "intersection
  -- of closures" — that inference is invalid in general, which is
  -- exactly what Def. B.3 flags — but from the fact that this
  -- particular intersection IS a double polar.
  intersection-idem : (α : Pow A) → ⋂cl (⋂cl α) ≐ ⋂cl α
  intersection-idem α =
    ≐-trans (≐-sym (flatten (⋂cl α)))
      (≐-trans (clHat-cong (≐-sym (flatten α)))
        (≐-trans (clHat-idem α) (flatten α)))

  -- ... and it is a closure operator outright.
  intersection-ext : (α : Pow A) → α ⊑ ⋂cl α
  intersection-ext α a αa i = Polarity.cl-ext (ε i) α a αa

  intersection-mono : {α α' : Pow A} → α ⊑ α' → ⋂cl α ⊑ ⋂cl α'
  intersection-mono s a h i = Polarity.cl-mono (ε i) s a (h i)
