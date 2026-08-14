{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.LinearOrderFinite
--
-- Closing the honesty gap of `NaturalMachine.AtlasResiduals` §4.
------------------------------------------------------------------------

module NaturalMachine.LinearOrderFinite where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence using (hPropExt)
open import Cubical.Functions.Embedding
open import Cubical.Functions.Surjection
open import Cubical.Functions.Fibration using (totalEquiv)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Unit
open import Cubical.Data.Empty as Empty
open import Cubical.Data.Fin using (Fin ; toℕ ; toℕ-injective) renaming (isSetFin to isSetFinℕ)
open import Cubical.Data.SumFin using (SumFin≃Fin)
open import Cubical.Data.FinSet
open import Cubical.Data.FinSet.Constructors
open import Cubical.Data.FinSet.Cardinality
open import Cubical.HITs.PropositionalTruncation as Prop
open import Cubical.Relation.Nullary

------------------------------------------------------------------------
-- 1.  The structure: a genuine linear order.
------------------------------------------------------------------------

record IsLinOrd {X : Type₀} (_≤_ : X → X → Type₀) : Type₀ where
  constructor islinord
  field
    propValued : (x y : X) → isProp (x ≤ y)
    reflexive  : (x : X) → x ≤ x
    antisym    : (x y : X) → x ≤ y → y ≤ x → x ≡ y
    transitive : (x y z : X) → x ≤ y → y ≤ z → x ≤ z
    total      : (x y : X) → ∥ (x ≤ y) ⊎ (y ≤ x) ∥₁

open IsLinOrd public

LinOrd′ : Type₀ → Type₁
LinOrd′ X = Σ[ _≤_ ∈ (X → X → Type₀) ] IsLinOrd _≤_

isPropIsLinOrd : {X : Type₀} → isSet X → (R : X → X → Type₀) → isProp (IsLinOrd R)
isPropIsLinOrd {X = X} isSetX R p q i = islinord
  (isPropΠ2 (λ _ _ → isPropIsProp) (p .propValued) (q .propValued) i)
  (isPropΠ (λ x → p .propValued x x) (p .reflexive) (q .reflexive) i)
  (isPropΠ2 (λ x y → isPropΠ2 (λ _ _ → isSetX x y)) (p .antisym) (q .antisym) i)
  (isPropΠ (λ x → isPropΠ2 (λ _ z → isPropΠ2 (λ _ _ → p .propValued x z)))
           (p .transitive) (q .transitive) i)
  (isPropΠ2 (λ _ _ → isPropPropTrunc) (p .total) (q .total) i)

LinOrd′≡ : {X : Type₀} → isSet X → {L M : LinOrd′ X} → L .fst ≡ M .fst → L ≡ M
LinOrd′≡ isSetX = Σ≡Prop (isPropIsLinOrd isSetX)

------------------------------------------------------------------------
-- 2.  Two generic finite-set lemmas.
------------------------------------------------------------------------

decNot : {C : Type₀} → Dec C → Dec (¬ C)
decNot (yes p) = no (λ np → np p)
decNot (no ¬p) = yes ¬p

module _ {A : Type₀} (P : A → Type₀)
         (isPropP : (a : A) → isProp (P a))
         (decP : (a : A) → Dec (P a)) where

  private
    Pos : Type₀
    Pos = Σ[ a ∈ A ] P a

    Neg : Type₀
    Neg = Σ[ a ∈ A ] (¬ P a)

    to′ : (a : A) → Dec (P a) → Pos ⊎ Neg
    to′ a (yes p) = inl (a , p)
    to′ a (no ¬p) = inr (a , ¬p)

    to : A → Pos ⊎ Neg
    to a = to′ a (decP a)

    from : Pos ⊎ Neg → A
    from (inl (a , _)) = a
    from (inr (a , _)) = a

    rinv : (s : Pos ⊎ Neg) → to (from s) ≡ s
    rinv (inl (a , p)) = lem (decP a)
      where
        lem : (d : Dec (P a)) → to′ a d ≡ inl (a , p)
        lem (yes q) = cong (λ z → inl (a , z)) (isPropP a q p)
        lem (no ¬q) = Empty.rec (¬q p)
    rinv (inr (a , ¬p)) = lem (decP a)
      where
        lem : (d : Dec (P a)) → to′ a d ≡ inr (a , ¬p)
        lem (yes q) = Empty.rec (¬p q)
        lem (no ¬q) = λ i → inr (a , isProp¬ (P a) ¬q ¬p i)

    linv : (a : A) → from (to a) ≡ a
    linv a = lem (decP a)
      where
        lem : (d : Dec (P a)) → from (to′ a d) ≡ a
        lem (yes q) = refl
        lem (no ¬q) = refl

  -- A type splits along a decidable predicate.
  decSplit≃ : A ≃ ((Σ[ a ∈ A ] P a) ⊎ (Σ[ a ∈ A ] (¬ P a)))
  decSplit≃ = isoToEquiv (iso to from rinv linv)

-- An embedding between finite sets of equal cardinality is surjective.
-- (The finite pigeonhole principle, in the form actually needed below.)
embSurj : (A B : FinSet ℓ-zero) (f : A .fst → B .fst)
        → isEmbedding f → card A ≡ card B → isSurjection f
embSurj A B f emb card≡ b = decide (decFib b)
  where
    Fib : B .fst → Type₀
    Fib y = ∥ fiber f y ∥₁

    decFib : (y : B .fst) → Dec (Fib y)
    decFib y = isFinSet→Dec∥∥ (isFinSetFiber A B f y)

    finPos : isFinSet (Σ[ y ∈ B .fst ] Fib y)
    finPos = isFinSetΣ B (λ y → Fib y , isDecProp→isFinSet isPropPropTrunc (decFib y))

    finNeg : isFinSet (Σ[ y ∈ B .fst ] (¬ Fib y))
    finNeg = isFinSetΣ B (λ y → (¬ Fib y) , isDecProp→isFinSet (isProp¬ _) (decNot (decFib y)))

    A≃Pos : A .fst ≃ (Σ[ y ∈ B .fst ] Fib y)
    A≃Pos = compEquiv (totalEquiv f)
              (Σ-cong-equiv-snd
                (λ y → invEquiv (propTruncIdempotent≃ (isEmbedding→hasPropFibers emb y))))

    cardPos : card (_ , finPos) ≡ card A
    cardPos = sym (cardEquiv A (_ , finPos) ∣ A≃Pos ∣₁)

    split : card B ≡ card (_ , finPos) + card (_ , finNeg)
    split = cardEquiv B (_ , isFinSet⊎ (_ , finPos) (_ , finNeg))
              ∣ decSplit≃ Fib (λ _ → isPropPropTrunc) decFib ∣₁

    decide : Dec (Fib b) → Fib b
    decide (yes p) = p
    decide (no ¬p) = Empty.rec (¬-<-zero (subst (0 <_) cNeg≡0 pos))
      where
        pos : 0 < card (_ , finNeg)
        pos = isInhab→card>0 (_ , finNeg) ∣ b , ¬p ∣₁

        cNeg≡0 : card (_ , finNeg) ≡ 0
        cNeg≡0 =
          sym (inj-m+ {m = card A}
                (+-zero (card A) ∙ card≡ ∙ split ∙ cong (_+ card (_ , finNeg)) cardPos))

-- Cubical's `isFinSet` is stated with `SumFin`; this is the witness for
-- `Cubical.Data.Fin.Fin`, with cardinality definitionally `m`.
finFinℕ : (m : ℕ) → isFinSet (Fin m)
finFinℕ m = m , ∣ invEquiv (SumFin≃Fin m) ∣₁

------------------------------------------------------------------------
-- 3.  Rank: the forward map, and that it is an equivalence.
------------------------------------------------------------------------

module Order (X : Type₀) (finX : isFinSet X) (L : LinOrd′ X) where

  _⊑_ : X → X → Type₀
  _⊑_ = L .fst

  ax : IsLinOrd _⊑_
  ax = L .snd

  isSetX : isSet X
  isSetX = isFinSet→isSet finX

  discX : Discrete X
  discX = isFinSet→Discrete finX

  -- Decidability of the order is DERIVED, not assumed: mere totality
  -- plus decidable equality (which finiteness supplies) forces it,
  -- because antisymmetry makes the two disjuncts mutually exclusive
  -- off the diagonal.
  dec⊑ : (x y : X) → Dec (x ⊑ y)
  dec⊑ x y with discX x y
  ... | yes p = yes (subst (x ⊑_) p (ax .reflexive x))
  ... | no ¬p =
        Prop.rec (isPropDec (ax .propValued x y))
          (λ { (inl le) → yes le
             ; (inr ge) → no (λ le → ¬p (ax .antisym x y le ge)) })
          (ax .total x y)

  _⊏_ : X → X → Type₀
  x ⊏ y = (x ⊑ y) × (¬ x ≡ y)

  isProp⊏ : (x y : X) → isProp (x ⊏ y)
  isProp⊏ x y = isProp× (ax .propValued x y) (isProp¬ _)

  dec⊏ : (x y : X) → Dec (x ⊏ y)
  dec⊏ x y with dec⊑ x y | discX x y
  ... | yes le | no ¬p = yes (le , ¬p)
  ... | yes le | yes p = no (λ q → q .snd p)
  ... | no ¬le | _     = no (λ q → ¬le (q .fst))

  Down : X → Type₀
  Down x = Σ[ z ∈ X ] (z ⊏ x)

  finDown : (x : X) → isFinSet (Down x)
  finDown x =
    isFinSetΣ (X , finX) (λ z → (z ⊏ x) , isDecProp→isFinSet (isProp⊏ z x) (dec⊏ z x))

  isSetDown : (x : X) → isSet (Down x)
  isSetDown x = isSetΣ isSetX (λ z → isProp→isSet (isProp⊏ z x))

  -- The rank of x is the number of elements strictly below it.
  rk : X → ℕ
  rk x = card (Down x , finDown x)

  private
    UD : (x : X) → FinSet ℓ-zero
    UD x = (Unit ⊎ Down x) , isFinSet⊎ (Unit , isFinSetUnit) (Down x , finDown x)

  -- Unit ⊎ Down x ↪ X : the elements below x, together with x itself.
  rk<card : (x : X) → rk x < finX .fst
  rk<card x = card↪Inequality' (UD x) (X , finX) f (injEmbedding isSetX inj)
    where
      f : Unit ⊎ Down x → X
      f (inl _)       = x
      f (inr (z , _)) = z

      inj : {a b : Unit ⊎ Down x} → f a ≡ f b → a ≡ b
      inj {inl _}          {inl _}          _ = refl
      inj {inl _}          {inr (z , z⊏x)}  p = Empty.rec (z⊏x .snd (sym p))
      inj {inr (z , z⊏x)}  {inl _}          p = Empty.rec (z⊏x .snd p)
      inj {inr (z , _)}    {inr (w , _)}    p = cong inr (Σ≡Prop (λ v → isProp⊏ v x) p)

  -- Unit ⊎ Down x ↪ Down y when x ⊏ y : rank is strictly monotone.
  rk-mono : (x y : X) → x ⊏ y → rk x < rk y
  rk-mono x y x⊏y =
    card↪Inequality' (UD x) (Down y , finDown y) f (injEmbedding (isSetDown y) inj)
    where
      below : (z : X) → z ⊏ x → z ⊏ y
      below z z⊏x =
          ax .transitive z x y (z⊏x .fst) (x⊏y .fst)
        , λ q → x⊏y .snd (ax .antisym x y (x⊏y .fst) (subst (_⊑ x) q (z⊏x .fst)))

      f : Unit ⊎ Down x → Down y
      f (inl _)          = x , x⊏y
      f (inr (z , z⊏x))  = z , below z z⊏x

      inj : {a b : Unit ⊎ Down x} → f a ≡ f b → a ≡ b
      inj {inl _}         {inl _}         _ = refl
      inj {inl _}         {inr (z , z⊏x)} p = Empty.rec (z⊏x .snd (sym (cong fst p)))
      inj {inr (z , z⊏x)} {inl _}         p = Empty.rec (z⊏x .snd (cong fst p))
      inj {inr (z , _)}   {inr (w , _)}   p =
        cong inr (Σ≡Prop (λ v → isProp⊏ v x) (cong fst p))

  -- NB: these two are written with an explicit `Dec` argument rather
  -- than `with discX x y`.  With-abstraction normalises the goal to
  -- find occurrences of the scrutinee, and the goal here mentions `rk`,
  -- whose unfolding contains `discX` under `isFinSetΣ`; that normal
  -- form is enormous and typechecking does not terminate in practice.
  rk-≤ : (x y : X) → x ⊑ y → rk x ≤ rk y
  rk-≤ x y le = go (discX x y)
    where
      go : Dec (x ≡ y) → rk x ≤ rk y
      go (yes p) = subst (λ w → rk x ≤ rk w) p ≤-refl
      go (no ¬p) = <-weaken (rk-mono x y (le , ¬p))

  rk-≥ : (x y : X) → rk x ≤ rk y → x ⊑ y
  rk-≥ x y h = Prop.rec (ax .propValued x y) step (ax .total x y)
    where
      go : (y ⊑ x) → Dec (y ≡ x) → x ⊑ y
      go ge (yes p) = subst (x ⊑_) (sym p) (ax .reflexive x)
      go ge (no ¬p) = Empty.rec (<-asym (rk-mono y x (ge , ¬p)) h)

      step : (x ⊑ y) ⊎ (y ⊑ x) → x ⊑ y
      step (inl le) = le
      step (inr ge) = go ge (discX y x)

  rank : X → Fin (finX .fst)
  rank x = rk x , rk<card x

  rank-inj : (x y : X) → rank x ≡ rank y → x ≡ y
  rank-inj x y p =
    ax .antisym x y (rk-≥ x y (subst (rk x ≤_) q ≤-refl))
                    (rk-≥ y x (subst (_≤ rk x) q ≤-refl))
    where
      q : rk x ≡ rk y
      q = cong toℕ p

  isEmbeddingRank : isEmbedding rank
  isEmbeddingRank = injEmbedding isSetFinℕ (λ {x} {y} p → rank-inj x y p)

  isEquivRank : isEquiv rank
  isEquivRank =
    isEmbedding×isSurjection→isEquiv
      ( isEmbeddingRank
      , embSurj (X , finX) (Fin (finX .fst) , finFinℕ (finX .fst)) rank isEmbeddingRank refl )

  rankEquiv : X ≃ Fin (finX .fst)
  rankEquiv = rank , isEquivRank

  -- Rank reflects and preserves the order, as a path of propositions.
  rank-order : (x y : X) → (toℕ (rank x) ≤ toℕ (rank y)) ≡ (x ⊑ y)
  rank-order x y = hPropExt isProp≤ (ax .propValued x y) (rk-≥ x y) (rk-≤ x y)
