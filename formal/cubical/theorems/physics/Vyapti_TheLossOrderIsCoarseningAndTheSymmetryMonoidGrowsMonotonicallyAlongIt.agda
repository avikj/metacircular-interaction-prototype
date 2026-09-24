{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- व्याप्ति — स्थूलतरे दर्शने संरक्षकाणां वृद्धिः ।
--
-- (as the observation grows coarser, the conserving flows grow with it.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  The corpus has the two poles of a scale and no scale.
--
--   `Dhruva_…agda` §२ — `isEquiv f → संरक्षणम् f Φ → Φ a ≡ a`.  Nothing
--   hidden, so nothing conserved and nothing moves.
--
--   `Khahara_…agda` §३ — every endomorphism of A conserves f ⟺ f is
--   constant.  Total loss is exactly total symmetry.
--
-- Between them the corpus says "how much is lost" and has no object for
-- it.  The obvious move is a NUMBER — a fibre cardinality, an entropy —
-- and that move is unavailable here (A is not finite, not a set, and no
-- measure is in sight) and would in any case be the fitted-constant
-- error this repository is built against.  The quantity is not a number.
-- **It is an ORDER, and getting the order right is the whole content.**
--
--     f व्याप्नोति g   :=   Σ[ h ] (a : A) → g a ≡ h (f a)
--
-- "g factors through f" — g sees only what f sees, possibly less; g is
-- the COARSER observation, the one that loses at least as much.  This is
-- a preorder (§२), and along it:
--
--   §३  the conserving set GROWS:  f व्याप्नोति g → संरक्षणम् f Φ →
--       संरक्षणम् g Φ.  A flow invisible to a fine observation is
--       invisible to every coarsening of it.  Three rewrites, no
--       hypotheses on A, B, C, Φ — not h-sets, not finite, not
--       equivalences.
--   §५  and so do the fibres: a fibre of f maps into the corresponding
--       fibre of g.  The loss itself is monotone, not only its symmetry.
--
-- §४ is why this is a unification and not a definition.  `idfun A` is a
-- bottom of the order and any constant map is a top, so **Dhruva's pole
-- and Khahara's pole are the two ends of this one order**, and §३
-- REPROVES Dhruva §२ in one line: an equivalence lies at the bottom
-- (`f व्याप्नोति idfun A`, witnessed by `invEq`/`retEq`), and
-- `संरक्षणम् (idfun A) Φ` is definitionally `Φ a ≡ a`.  Dhruva's proof
-- used contractibility of a fibre; this one uses no fibre at all.
--
-- §६ is the erasure half.  Landauer's bound is about a NON-INJECTIVE
-- step, and non-injectivity of `Φ` is the failure of `Φ` to be an
-- equivalence.  The forgetting is made a TYPE and never a number:
--
--     विस्मृतिः Φ  :=  Σ[ a ] Σ[ a' ] (Φ a ≡ Φ a') × ¬ (a ≡ a')
--
-- and three terms: an equivalence forgets nothing (§६·१); an inhabitant
-- of विस्मृतिः exhibits a FIBRE OF Φ that fails to be a proposition
-- (§६·२) — so "what is forgotten is a fibre of Φ" is a statement about
-- h-levels, which is the only sense in which this vocabulary can say
-- "how much"; and (§६·३) a flow that conserves f can only forget INSIDE
-- a fibre of f — the flow's loss is bounded by the observation's, which
-- is the composite of the two halves of this file.
--
-- ────────────────────────────────────────────────────────────────────
--
-- **The order is a preorder, not a partial order.**  `व्याप्नोति` has
-- reflexivity and transitivity (§न) and antisymmetry fails:
-- two maps can factor through each other without being equal.
--
-- `isEquiv Φ →
-- ¬ विस्मृतिः Φ` is proved; the converse — that a non-equivalence
-- exhibits a विस्मृतिः — is CLASSICAL (it needs a collision to be found,
-- and a ¬(a ≡ a') to be produced from ¬(a ≡ a') failing) and is not
-- available constructively.
--
-- **Everything lives at ONE universe level.**  Not for depth: `Dhruva`
-- declares `संरक्षणम्` in a telescope `{A B : Type ℓ}` with a single ℓ,
-- and this file reuses that definition rather than restating it, so it
-- inherits the restriction.
--
-- ────────────────────────────────────────────────────────────────────
-- TERM.  व्याप्ति · vyāpti — pervasion, the relation that makes an
-- inference go through: wherever the hetu is, the sdhya is.  Gautama,
-- *न्यायसूत्र* (~2nd c. CE); the definitional apparatus, the
-- व्याप्तिपञ्चक, is गङ्गेश, *तत्त्वचिन्तामणि* (~1325).
--
-- The
-- Naiyyika relation holds between two PROPERTIES (sdhya pervades
-- hetu) and its whole difficulty is the उपाधि, the defeating condition
-- — Gaṅgeśa's five definitions exist because the naive one fails.  What
-- is defined below is a containment between two MAPS, it has no updhi,
-- and it is not defeasible.  The word is borrowed for the shape
-- "wherever the one identifies, the other identifies".
-- A
-- Naiyyika would also refuse the substrate outright: cubical type
-- theory (Voevodsky) is this repository's one admitted non-Indian frame.
------------------------------------------------------------------------

module Vyapti_TheLossOrderIsCoarseningAndTheSymmetryMonoidGrowsMonotonicallyAlongIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun ; _∘_)
open import Cubical.Foundations.Equiv using (isEquiv ; _≃_ ; invEq ; retEq ; fiber)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Nat using (ℕ; zero; suc)

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (संरक्षणम्)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · व्याप्नोति — the loss order.  `f व्याप्नोति g` reads: g factors
--     through f, i.e. g sees no more than f does, i.e. g loses at least
--     as much.  The mediating h is data, not a property.
------------------------------------------------------------------------

_व्याप्नोति_ : {A : Type ℓ} {B : Type ℓ} {C : Type ℓ}
             → (A → B) → (A → C) → Type ℓ
_व्याप्नोति_ {A = A} {B = B} {C = C} f g =
  Σ[ h ∈ (B → C) ] ((a : A) → g a ≡ h (f a))

------------------------------------------------------------------------
--  · It is a preorder.
------------------------------------------------------------------------

व्याप्ति-स्वतः : {A : Type ℓ} {B : Type ℓ} (f : A → B) → f व्याप्नोति f
व्याप्ति-स्वतः f = idfun _ , λ _ → refl

व्याप्ति-संक्रमः : {A : Type ℓ} {B : Type ℓ} {C : Type ℓ} {D : Type ℓ}
                 {f : A → B} {g : A → C} {k : A → D}
               → f व्याप्नोति g → g व्याप्नोति k → f व्याप्नोति k
व्याप्ति-संक्रमः (h , p) (h' , q) = h' ∘ h , λ a → q a ∙ cong h' (p a)

------------------------------------------------------------------------
-- ३ · THE MONOTONICITY.  The conserving set grows along the order.
--
--     f व्याप्नोति g  →  संरक्षणम् f Φ  →  संरक्षणम् g Φ
--
-- A flow that a fine observation cannot see, no coarsening of that
-- observation can see either.  Note what is NOT assumed: A, B, C are
-- arbitrary types (no h-level, no finiteness), Φ is a bare endomorphism
-- with no inverse, and h is arbitrary.  The whole proof is three
-- rewrites.
------------------------------------------------------------------------

संरक्षक-वृद्धिः : {A : Type ℓ} {B : Type ℓ} {C : Type ℓ}
                 {f : A → B} {g : A → C} {Φ : A → A}
               → f व्याप्नोति g → संरक्षणम् f Φ → संरक्षणम् g Φ
संरक्षक-वृद्धिः (h , p) cons a = p _ ∙ cong h (cons a) ∙ sym (p a)

-- The conserving set is a submonoid of the endomorphisms, for every f:
-- the identity conserves, and conservation is closed under composition.
-- (So "the symmetry MONOID grows" in §३ is a statement about monoids and
-- not merely about sets of maps.)
संरक्षणम्-नो-कर्म : {A : Type ℓ} {B : Type ℓ} (f : A → B)
                  → संरक्षणम् f (idfun A)
संरक्षणम्-नो-कर्म f a = refl

संरक्षणम्-सन्धिः : {A : Type ℓ} {B : Type ℓ} {f : A → B} {Φ Ψ : A → A}
                 → संरक्षणम् f Φ → संरक्षणम् f Ψ → संरक्षणम् f (Φ ∘ Ψ)
संरक्षणम्-सन्धिः {f = f} c d a = c (_) ∙ d a

------------------------------------------------------------------------
-- ४ · THE TWO POLES ARE THE TWO ENDS OF THIS ORDER.
--
-- `idfun A` is a bottom and any constant map is a top.  So the scale
-- whose ends `Dhruva` §२ and `Khahara` §३ describe is this order, and
-- §३ is the interpolation neither file had.
------------------------------------------------------------------------

-- bottom: the identity loses nothing, and everything factors through it.
अधःस्थम् : {A : Type ℓ} {B : Type ℓ} (f : A → B) → (idfun A) व्याप्नोति f
अधःस्थम् f = f , λ _ → refl

-- top: a constant map loses everything, and it factors through anything.
ऊर्ध्वस्थम् : {A : Type ℓ} {B : Type ℓ} {C : Type ℓ} (f : A → B) (c : C)
            → f व्याप्नोति (λ (_ : A) → c)
ऊर्ध्वस्थम् f c = (λ _ → c) , λ _ → refl

-- Khahara's easy half, at the top of the order: every endomorphism
-- conserves a constant observation.  It is `refl`, and that is the
-- point — at the top the conserving set is the FULL endomorphism monoid
-- with no hypothesis at all, which is the ceiling §३ climbs towards.
सर्व-नाशः-सर्व-गतिः : {A : Type ℓ} {C : Type ℓ} (c : C) (Φ : A → A)
                    → संरक्षणम् (λ (_ : A) → c) Φ
सर्व-नाशः-सर्व-गतिः c Φ _ = refl

-- An equivalence sits at the BOTTOM of the order: it factors through the
-- identity, with `invEq` as the mediator.  This is "nothing is hidden",
-- said as a position in the order rather than as contractible fibres.
समत्वम्-अधःस्थम् : {A : Type ℓ} {B : Type ℓ} (f : A → B) → isEquiv f
                  → f व्याप्नोति (idfun A)
समत्वम्-अधःस्थम् f e = invEq (f , e) , λ a → sym (retEq (f , e) a)

-- DHRUVA §२, REPROVED BY MONOTONICITY ALONE.  `संरक्षणम् (idfun A) Φ`
-- unfolds definitionally to `(a : A) → Φ a ≡ a`, so pushing conservation
-- down to the bottom of the order IS the frozen-world theorem.  No fibre
-- and no contractibility is used anywhere in this proof.
नष्ट-अभावे-गति-अभावः-व्याप्त्या :
    {A : Type ℓ} {B : Type ℓ} {f : A → B} {Φ : A → A}
  → isEquiv f → संरक्षणम् f Φ → (a : A) → Φ a ≡ a
नष्ट-अभावे-गति-अभावः-व्याप्त्या {f = f} e =
  संरक्षक-वृद्धिः (समत्वम्-अधःस्थम् f e)

------------------------------------------------------------------------
-- ५ · THE LOSS ITSELF IS MONOTONE, not only its symmetry.
--
-- §५·१ every fibre of the finer map lands in the corresponding fibre of
-- the coarser one — the coarsening never separates what f identified.
-- §५·२ the same fact on identifications alone.
------------------------------------------------------------------------

तन्तु-वृद्धिः : {A : Type ℓ} {B : Type ℓ} {C : Type ℓ}
               {f : A → B} {g : A → C}
             → f व्याप्नोति g → (a : A) → fiber f (f a) → fiber g (g a)
तन्तु-वृद्धिः (h , p) a (x , q) = x , (p x ∙ cong h q ∙ sym (p a))

समता-वृद्धिः : {A : Type ℓ} {B : Type ℓ} {C : Type ℓ}
              {f : A → B} {g : A → C}
            → f व्याप्नोति g → (a a' : A) → f a ≡ f a' → g a ≡ g a'
समता-वृद्धिः (h , p) a a' q = p a ∙ cong h q ∙ sym (p a')

------------------------------------------------------------------------
-- ६ · विस्मृतिः — FORGETTING AS A TYPE.
--
-- Landauer's bound is about an erasing, i.e. non-injective, step.  Here
-- the erasing is a type and never a number.
------------------------------------------------------------------------

विस्मृतिः : {A : Type ℓ} → (A → A) → Type ℓ
विस्मृतिः {A = A} Φ = Σ[ a ∈ A ] Σ[ a' ∈ A ] (Φ a ≡ Φ a') × (¬ (a ≡ a'))

--   A reversible flow forgets nothing.  (समत्वेसमत्वे`Machine`'s groupoid isनविस्मृतिः
-- exactly the case where this type is empty for every operation.)
समत्वे-न-विस्मृतिः : {A : Type ℓ} {Φ : A → A} → isEquiv Φ → ¬ विस्मृतिः Φ
समत्वे-न-विस्मृतिः {Φ = Φ} e (a , a' , q , n) =
  n (sym (retEq (Φ , e) a) ∙ cong (invEq (Φ , e)) q ∙ retEq (Φ , e) a')

-- ६·२ · WHAT IS FORGOTTEN IS A FIBRE OF Φ — and the "how much" is an
-- h-level, the only sense of magnitude this vocabulary owns.  An
-- inhabitant of विस्मृतिः exhibits a point of A over which the fibre of
-- Φ fails to be a proposition.  (For an equivalence every such fibre is
-- contractible, hence a proposition — which is ६·१ from the other side.)
विस्मृतिः-तन्तुः : {A : Type ℓ} {Φ : A → A}
                 → विस्मृतिः Φ → Σ[ b ∈ A ] (¬ isProp (fiber Φ b))
विस्मृतिः-तन्तुः {Φ = Φ} (a , a' , q , n) =
  Φ a , λ pr → n (cong fst (pr (a , refl) (a' , sym q)))

-- ६·३ · A CONSERVING FLOW CAN ONLY FORGET INSIDE A FIBRE OF f.
--
-- The flow's loss is bounded by the observation's loss, in the only
-- currency available: if Φ conserves f and Φ collides a with a', then f
-- had already identified a with a'.  So `Dhruva`'s fibre — the room a
-- symmetry needs in order to exist — is also the room an erasure needs.
-- Composed with ६·२: the forgotten fibre of Φ sits inside a fibre of f.
विस्मरणं-तन्तौ : {A : Type ℓ} {B : Type ℓ} {f : A → B} {Φ : A → A}
               → संरक्षणम् f Φ → (a a' : A) → Φ a ≡ Φ a' → f a ≡ f a'
विस्मरणं-तन्तौ {f = f} cons a a' q =
  sym (cons a) ∙ cong f q ∙ cons a'

विस्मरणं-तन्तौ-स्थितम् : {A : Type ℓ} {B : Type ℓ} {f : A → B} {Φ : A → A}
                      → संरक्षणम् f Φ → (w : विस्मृतिः Φ)
                      → fiber f (f (fst w))
विस्मरणं-तन्तौ-स्थितम् cons (a , a' , q , n) =
  a' , sym (विस्मरणं-तन्तौ cons a a' q)
