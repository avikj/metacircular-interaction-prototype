{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकत्व — oneness.  LOSSLESSNESS IS A PROPERTY, NOT A STRUCTURE.
--
-- Vishvayantra's trace-is-fiber says any lawful trace family is
-- fiberwise equivalent to the fibre family.  This file proves the
-- sharpest possible strengthening: the TYPE of lossless completions of
-- a fixed map,
--
--   Lossless f  =  Σ (T : B → Type). Σ (e : A ≃ Σ B T). π₁ ∘ e ∼ f
--
-- is CONTRACTIBLE.  There is, up to a path, exactly one way to
-- complete a computation losslessly; the completion is not a choice a
-- designer makes but a property the map already has.  A lossless
-- machine cannot be built two ways.
--
-- The proof is a chain of eight equivalences, each explicit:
--
--   Lossless f
--     ≃ Σ T. Σ (w : sections-over-f). isEquiv w          (regroup)
--     ≃ Σ T. Σ (s : Π a. T (f a)). isEquiv (a ↦ (f a, s a))
--                                          (a map over f IS a section)
--     ≃ Σ T. Σ (φ : Π b. fib f b → T b). isEquiv (tot φ ∘ e_f)
--                                          (a section IS a fiberwise map)
--     ≃ Σ T. Σ φ. Π b. isEquiv (φ b)      (total ↔ fiberwise, both props)
--     ≃ Σ T. Π b. (fib f b ≃ T b)         (choice, definitionally)
--     ≃ Σ T. Π b. (T b ≃ fib f b)         (flip through univalence)
--     ≃ Π b. Σ X. (X ≃ fib f b)           (choice again)
--     — and the last is a product of equivalence-singletons,
--       contractible by univalence (EquivContr).
--
-- Instantiated at the machine: `machine-lossless-unique` — the
-- universal step has exactly one lossless completion, the one
-- Vishvayantra built.
------------------------------------------------------------------------

module Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Equiv.Fiberwise using (fiberEquiv ; totalEquiv)
open import Cubical.Foundations.Univalence using (univalence ; EquivContr)
open import Cubical.Foundations.HLevels
  using (isContrΠ ; isPropΠ ; isOfHLevelRespectEquiv)
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Sigma

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (Machine ; uStep ; lossless ; losslessIso)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §0  The object.
------------------------------------------------------------------------

Lossless : {A B : Type ℓ} (f : A → B) → Type (ℓ-suc ℓ)
Lossless {ℓ} {A} {B} f =
  Σ[ T ∈ (B → Type ℓ) ]
  Σ[ e ∈ (A ≃ Σ B T) ]
  ((a : A) → fst (equivFun e a) ≡ f a)

-- The inhabitant Vishvayantra built, for any map: the fibre family.
canonical-lossless : {A B : Type ℓ} (f : A → B) → Lossless f
canonical-lossless f = fiber f , lossless f , λ a → refl

------------------------------------------------------------------------
-- §1  Two small generic tools, both with refl round trips.
------------------------------------------------------------------------

-- Type-theoretic choice, as a definitional isomorphism.
ΠΣ-swap : {ℓx ℓy ℓz : Level}
  {X : Type ℓx} {Y : X → Type ℓy} {Z : (x : X) → Y x → Type ℓz} →
  Iso ((x : X) → Σ (Y x) (Z x))
      (Σ ((x : X) → Y x) (λ h → (x : X) → Z x (h x)))
Iso.fun ΠΣ-swap h = (λ x → fst (h x)) , (λ x → snd (h x))
Iso.inv ΠΣ-swap (h , k) x = h x , k x
Iso.rightInv ΠΣ-swap _ = refl
Iso.leftInv  ΠΣ-swap _ = refl

-- Independent components of a Σ commute.
Σ-flip23 : {X : Type ℓ} {P Q : X → Type ℓ} →
  Iso (Σ X (λ x → P x × Q x)) (Σ X (λ x → Q x × P x))
Iso.fun Σ-flip23 (x , p , q) = x , q , p
Iso.inv Σ-flip23 (x , q , p) = x , p , q
Iso.rightInv Σ-flip23 _ = refl
Iso.leftInv  Σ-flip23 _ = refl

-- An equivalence flips, through univalence and the definitional
-- involutivity of sym.
flipEquiv : {X Y : Type ℓ} → (X ≃ Y) ≃ (Y ≃ X)
flipEquiv {X = X} {Y = Y} =
  compEquiv (invEquiv univalence)
            (compEquiv (isoToEquiv symIso) univalence)
  where
  symIso : Iso (X ≡ Y) (Y ≡ X)
  Iso.fun symIso = sym
  Iso.inv symIso = sym
  Iso.rightInv symIso _ = refl
  Iso.leftInv  symIso _ = refl

------------------------------------------------------------------------
-- §2  A map over f is a section; a section is a fiberwise map.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) (T : B → Type ℓ) where

  -- Maps A → Σ B T lying over f, with the lying-over datum carried.
  Over : Type ℓ
  Over = Σ[ g ∈ (A → Σ B T) ] ((a : A) → fst (g a) ≡ f a)

  -- A map over f is exactly a section of T along f, and the forward
  -- direction is definitional: s ↦ (a ↦ (f a , s a), a ↦ refl).
  sectionIso : Iso ((a : A) → T (f a)) Over
  Iso.fun sectionIso s = (λ a → f a , s a) , (λ a → refl)
  Iso.inv sectionIso (g , v) a = subst T (v a) (snd (g a))
  Iso.rightInv sectionIso (g , v) =
    ΣPathP ( funExt (λ a i → v a (~ i) , subst-filler T (v a) (snd (g a)) (~ i))
           , λ i a j → v a (~ i ∨ j) )
  Iso.leftInv sectionIso s = funExt (λ a → substRefl {B = T} (s a))

  -- A section of T along f is exactly a fiberwise map out of the fibre
  -- family, and the forward direction is definitional.
  fiberwiseIso : Iso ((b : B) → fiber f b → T b) ((a : A) → T (f a))
  Iso.fun fiberwiseIso φ a = φ (f a) (a , refl)
  Iso.inv fiberwiseIso s b w = subst T (snd w) (s (fst w))
  Iso.rightInv fiberwiseIso s = funExt (λ a → substRefl {B = T} (s a))
  Iso.leftInv fiberwiseIso φ =
    funExt (λ b → funExt (λ w →
      J (λ b' p → subst T p (φ (f (fst w)) (fst w , refl)) ≡ φ b' (fst w , p))
        (substRefl {B = T} (φ (f (fst w)) (fst w , refl)))
        (snd w)))

  -- The total map of a fiberwise map.
  tot : ((b : B) → fiber f b → T b) → Σ B (fiber f) → Σ B T
  tot φ (b , w) = b , φ b w

  -- The section's map-over-f is definitionally tot φ ∘ e_f, so
  -- invertibility of the one is invertibility of the other, and both
  -- are propositions.
  overEquiv-is-fiberwiseEquiv : (φ : (b : B) → fiber f b → T b) →
    isEquiv (λ a → (f a , φ (f a) (a , refl))) ≃ ((b : B) → isEquiv (φ b))
  overEquiv-is-fiberwiseEquiv φ =
    propBiimpl→Equiv (isPropIsEquiv _) (isPropΠ (λ _ → isPropIsEquiv _)) to from
    where
    gφ : A → Σ B T
    gφ a = f a , φ (f a) (a , refl)

    h : (w : Σ B (fiber f)) → gφ (Iso.inv (losslessIso f) w) ≡ tot φ w
    h (b , a , p) =
      J (λ b' p' → gφ a ≡ (b' , φ b' (a , p'))) refl p

    to : isEquiv gφ → (b : B) → isEquiv (φ b)
    to eg = fiberEquiv (fiber f) T φ
              (subst isEquiv (funExt h)
                (snd (compEquiv (invEquiv (lossless f)) (gφ , eg))))

    from : ((b : B) → isEquiv (φ b)) → isEquiv gφ
    from fx = snd (compEquiv (lossless f) (tot φ , totalEquiv (fiber f) T φ fx))

------------------------------------------------------------------------
-- §3  The chain, per trace family.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) where

  private
    step1 : (T : B → Type ℓ) →
      (Σ[ e ∈ (A ≃ Σ B T) ] ((a : A) → fst (equivFun e a) ≡ f a))
        ≃ (Σ[ w ∈ Over f T ] isEquiv (fst w))
    step1 T =
      compEquiv Σ-assoc-≃
        (compEquiv (isoToEquiv Σ-flip23) (invEquiv Σ-assoc-≃))

    step23 : (T : B → Type ℓ) →
      (Σ[ w ∈ Over f T ] isEquiv (fst w))
        ≃ (Σ[ φ ∈ ((b : B) → fiber f b → T b) ]
            isEquiv (λ a → (f a , φ (f a) (a , refl))))
    step23 T = invEquiv
      (Σ-cong-equiv-fst {B = λ w → isEquiv (fst w)}
        (isoToEquiv (compIso (fiberwiseIso f T) (sectionIso f T))))

    step4 : (T : B → Type ℓ) →
      (Σ[ φ ∈ ((b : B) → fiber f b → T b) ]
         isEquiv (λ a → (f a , φ (f a) (a , refl))))
        ≃ (Σ[ φ ∈ ((b : B) → fiber f b → T b) ] ((b : B) → isEquiv (φ b)))
    step4 T = Σ-cong-equiv-snd (overEquiv-is-fiberwiseEquiv f T)

    step5 : (T : B → Type ℓ) →
      (Σ[ φ ∈ ((b : B) → fiber f b → T b) ] ((b : B) → isEquiv (φ b)))
        ≃ ((b : B) → fiber f b ≃ T b)
    step5 T = invEquiv (isoToEquiv ΠΣ-swap)

    step6 : (T : B → Type ℓ) →
      ((b : B) → fiber f b ≃ T b) ≃ ((b : B) → T b ≃ fiber f b)
    step6 T = equivΠCod (λ b → flipEquiv)

  -- Losslessness, fully unwound: a completion of f is exactly a family
  -- pointwise equivalent to the fibre family.
  lossless-unwound :
    Lossless f ≃ ((b : B) → Σ[ X ∈ Type ℓ ] (X ≃ fiber f b))
  lossless-unwound =
    compEquiv
      (Σ-cong-equiv-snd (λ T →
        compEquiv (step1 T) (compEquiv (step23 T)
          (compEquiv (step4 T) (compEquiv (step5 T) (step6 T))))))
      (invEquiv (isoToEquiv
        (ΠΣ-swap {X = B} {Y = λ _ → Type ℓ} {Z = λ b X → X ≃ fiber f b})))

  -- THE THEOREM.  The completions form a contractible type: a product
  -- of equivalence-singletons, one per output, each contractible by
  -- univalence.  Losslessness is a property of f, not a structure
  -- placed on it.
  losslessness-is-a-property : isContr (Lossless f)
  losslessness-is-a-property =
    isOfHLevelRespectEquiv 0
      (invEquiv lossless-unwound)
      (isContrΠ (λ b → EquivContr (fiber f b)))

------------------------------------------------------------------------
-- §4  At the machine.
------------------------------------------------------------------------

-- The universal step has exactly one lossless completion — the one
-- Vishvayantra built is not an example, it is the inhabitant.
machine-lossless-unique : isContr (Lossless uStep)
machine-lossless-unique = losslessness-is-a-property uStep

machine-lossless-canonical : Lossless uStep
machine-lossless-canonical = canonical-lossless uStep
