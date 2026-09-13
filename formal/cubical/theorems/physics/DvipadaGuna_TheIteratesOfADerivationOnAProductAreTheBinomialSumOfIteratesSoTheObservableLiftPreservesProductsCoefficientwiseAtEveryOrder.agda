{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- द्विपद-गुण — the binomial product.
--
-- On observables of the source the lift 𝓛 h = Dh[F] is a derivation.
-- Its iterates on a product are the binomial sum of iterates
--
--     𝓛ⁿ (h · k)  ≡  Σ_{a+b=n} C(a+b, a) · 𝓛ᵃ h · 𝓛ᵇ k ,
--
-- so the formal exponential of 𝓛 preserves products coefficientwise
-- and evaluation at the actual source remains a multiplicative
-- character at every order.  (Handoff §37, [S17].)
--
-- The sum over a + b = n is written by recursion on n, with the
-- binomial as a function of the pair (a, b), so no truncated
-- subtraction and no side condition j ≤ n ever enters: the Pascal
-- step is an exact re-indexing lemma proved for every "row function"
-- that satisfies Pascal's rule, and the binomial is just one of them.
------------------------------------------------------------------------
module DvipadaGuna_TheIteratesOfADerivationOnAProductAreTheBinomialSumOfIteratesSoTheObservableLiftPreservesProductsCoefficientwiseAtEveryOrder where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc) renaming (_+_ to _+ℕ_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.Ring using (module RingTheory)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- The binomial as a function of the pair:  Cb a b = C(a+b, a).
------------------------------------------------------------------------

Cb : ℕ → ℕ → ℕ
Cb zero    b       = 1
Cb (suc a) zero    = 1
Cb (suc a) (suc b) = Cb a (suc b) +ℕ Cb (suc a) b

-- sanity: C(4,2) = 6, C(5,2) = 10, C(3,1) = 3
_ : Cb 2 2 ≡ 6
_ = refl
_ : Cb 2 3 ≡ 10
_ = refl
_ : Cb 1 2 ≡ 3
_ = refl

------------------------------------------------------------------------
module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)
  open RingTheory (CommRing→Ring R)

  private
    A = ⟨ R ⟩

  scale : ℕ → A → A
  scale zero    x = 0r
  scale (suc n) x = x + scale n x

  -- the sum over all pairs (a, b) with a + b = n
  D : (n : ℕ) → (ℕ → ℕ → A) → A
  D zero    f = f zero zero
  D (suc n) f = f zero (suc n) + D n (λ a b → f (suc a) b)

  private
    scale-add : (n : ℕ) (x y : A) → scale n (x + y) ≡ scale n x + scale n y
    scale-add zero    x y = sym (+IdR 0r)
    scale-add (suc n) x y =
        cong ((x + y) +_) (scale-add n x y)
      ∙ +ShufflePairs x y (scale n x) (scale n y)

    scale-+ : (m n : ℕ) (x : A) → scale (m +ℕ n) x ≡ scale m x + scale n x
    scale-+ zero    n x = sym (+IdL (scale n x))
    scale-+ (suc m) n x = cong (x +_) (scale-+ m n x) ∙ +Assoc x (scale m x) (scale n x)

    D-add : (n : ℕ) (f g : ℕ → ℕ → A)
      → D n (λ a b → f a b + g a b) ≡ D n f + D n g
    D-add zero    f g = refl
    D-add (suc n) f g =
        cong ((f zero (suc n) + g zero (suc n)) +_) (D-add n (λ a b → f (suc a) b) (λ a b → g (suc a) b))
      ∙ +ShufflePairs (f zero (suc n)) (g zero (suc n)) _ _

    D-ext : (n : ℕ) {f g : ℕ → ℕ → A} → ((a b : ℕ) → f a b ≡ g a b) → D n f ≡ D n g
    D-ext zero    h = h zero zero
    D-ext (suc n) h = cong₂ _+_ (h zero (suc n)) (D-ext n (λ a b → h (suc a) b))

  ----------------------------------------------------------------
  -- १ · THE PASCAL RE-INDEXING, for every row function.
  --
  -- c is any ℕ-valued function of the pair with
  --   c (suc a) (suc b) ≡ c a (suc b) + c (suc a) b   (Pascal)
  --   c (suc a) zero    ≡ c a zero                    (left edge)
  --   c zero (suc b)    ≡ c zero b                    (top edge)
  -- Both edges and Pascal survive the shift c ↦ c ∘ suc, which is
  -- what the induction needs.
  ----------------------------------------------------------------

  private
    Rest : (n : ℕ) (c : ℕ → ℕ → ℕ) (g : ℕ → ℕ → A) → A
    Rest zero    c g = 0r
    Rest (suc m) c g = D m (λ a b → scale (c (suc a) b) (g a (suc b)))

    -- the row shifted by one in the first slot equals the row itself
    -- plus the same sum with the second slot shifted
    shift-row : (n : ℕ) (c : ℕ → ℕ → ℕ)
      → (pascal : (a b : ℕ) → c (suc a) (suc b) ≡ c a (suc b) +ℕ c (suc a) b)
      → (left : (a : ℕ) → c (suc a) zero ≡ c a zero)
      → (g : ℕ → ℕ → A)
      → D n (λ a b → scale (c (suc a) b) (g a b))
        ≡ D n (λ a b → scale (c a b) (g a b)) + Rest n c g
    shift-row zero c pascal left g =
        cong (λ z → scale z (g zero zero)) (left zero) ∙ sym (+IdR _)
    shift-row (suc m) c pascal left g =
        cong₂ _+_ (cong (λ z → scale z (g zero (suc m))) (pascal zero m)
                   ∙ scale-+ (c zero (suc m)) (c (suc zero) m) (g zero (suc m)))
                  (shift-row m (λ a b → c (suc a) b)
                             (λ a b → pascal (suc a) b) (λ a → left (suc a))
                             (λ a b → g (suc a) b))
      ∙ +ShufflePairs (scale (c zero (suc m)) (g zero (suc m)))
                      (scale (c (suc zero) m) (g zero (suc m)))
                      (D m (λ a b → scale (c (suc a) b) (g (suc a) b)))
                      (Rest m (λ a b → c (suc a) b) (λ a b → g (suc a) b))
      ∙ cong ((scale (c zero (suc m)) (g zero (suc m)) + D m (λ a b → scale (c (suc a) b) (g (suc a) b))) +_) (tail m)
      where
        -- scale (c 1 m) (g 0 (suc m)) + Rest m (c∘suc) (g∘suc)
        --   ≡ D m (λ a b → scale (c (suc a) b) (g a (suc b)))
        tail : (m : ℕ)
          → scale (c (suc zero) m) (g zero (suc m))
              + Rest m (λ a b → c (suc a) b) (λ a b → g (suc a) b)
            ≡ D m (λ a b → scale (c (suc a) b) (g a (suc b)))
        tail zero    = +IdR _
        tail (suc k) = refl

    pascal-D : (n : ℕ) (c : ℕ → ℕ → ℕ)
      → (pascal : (a b : ℕ) → c (suc a) (suc b) ≡ c a (suc b) +ℕ c (suc a) b)
      → (left : (a : ℕ) → c (suc a) zero ≡ c a zero)
      → (top : (b : ℕ) → c zero (suc b) ≡ c zero b)
      → (g : ℕ → ℕ → A)
      → D (suc n) (λ a b → scale (c a b) (g a b))
        ≡ D n (λ a b → scale (c a b) (g (suc a) b)) + D n (λ a b → scale (c a b) (g a (suc b)))
    pascal-D n c pascal left top g =
        cong (scale (c zero (suc n)) (g zero (suc n)) +_)
             (shift-row n c pascal left (λ a b → g (suc a) b))
      ∙ +Assoc _ _ _
      ∙ cong (_+ Rest n c (λ a b → g (suc a) b))
             (+Comm (scale (c zero (suc n)) (g zero (suc n))) (D n (λ a b → scale (c a b) (g (suc a) b))))
      ∙ sym (+Assoc _ _ _)
      ∙ cong (D n (λ a b → scale (c a b) (g (suc a) b)) +_) (edge n)
      where
        edge : (n : ℕ)
          → scale (c zero (suc n)) (g zero (suc n)) + Rest n c (λ a b → g (suc a) b)
            ≡ D n (λ a b → scale (c a b) (g a (suc b)))
        edge zero    = +IdR _ ∙ cong (λ z → scale z (g zero (suc zero))) (top zero)
        edge (suc m) = cong (λ z → scale z (g zero (suc (suc m))) + Rest (suc m) c (λ a b → g (suc a) b)) (top (suc m))

  -- the binomial satisfies all three rules
  private
    Cb-pascal : (a b : ℕ) → Cb (suc a) (suc b) ≡ Cb a (suc b) +ℕ Cb (suc a) b
    Cb-pascal a b = refl
    Cb-left : (a : ℕ) → Cb (suc a) zero ≡ Cb a zero
    Cb-left zero    = refl
    Cb-left (suc a) = refl
    Cb-top : (b : ℕ) → Cb zero (suc b) ≡ Cb zero b
    Cb-top b = refl

  ----------------------------------------------------------------
  -- २ · THE ITERATED LEIBNIZ LAW.
  ----------------------------------------------------------------

  module _ (𝓛 : A → A)
           (𝓛-add  : (x y : A) → 𝓛 (x + y) ≡ 𝓛 x + 𝓛 y)
           (𝓛-leib : (x y : A) → 𝓛 (x · y) ≡ 𝓛 x · y + x · 𝓛 y)
           where

    -- iterates
    𝓛^ : ℕ → A → A
    𝓛^ zero    x = x
    𝓛^ (suc n) x = 𝓛 (𝓛^ n x)

    -- the binomial sum of iterates
    binomial-sum : (n : ℕ) (h k : A) → A
    binomial-sum n h k = D n (λ a b → scale (Cb a b) (𝓛^ a h · 𝓛^ b k))

    private
      𝓛-zero : 𝓛 0r ≡ 0r
      𝓛-zero = sym ( sym (+InvR (𝓛 0r)) ∙ cong (_+ (- (𝓛 0r))) h ∙ cancelR (𝓛 0r) (𝓛 0r) )
        where
          h : 𝓛 0r ≡ 𝓛 0r + 𝓛 0r
          h = cong 𝓛 (sym (+IdR 0r)) ∙ 𝓛-add 0r 0r
          cancelR : (x y : A) → (x + y) + (- y) ≡ x
          cancelR x y = sym (+Assoc x y (- y)) ∙ cong (x +_) (+InvR y) ∙ +IdR x

      𝓛-scale : (n : ℕ) (x : A) → 𝓛 (scale n x) ≡ scale n (𝓛 x)
      𝓛-scale zero    x = 𝓛-zero
      𝓛-scale (suc n) x = 𝓛-add x (scale n x) ∙ cong (𝓛 x +_) (𝓛-scale n x)

      𝓛-D : (n : ℕ) (f : ℕ → ℕ → A) → 𝓛 (D n f) ≡ D n (λ a b → 𝓛 (f a b))
      𝓛-D zero    f = refl
      𝓛-D (suc n) f = 𝓛-add _ _ ∙ cong (𝓛 (f zero (suc n)) +_) (𝓛-D n (λ a b → f (suc a) b))

    -- one derivative of the binomial sum is the next binomial sum
    step : (n : ℕ) (h k : A) → 𝓛 (binomial-sum n h k) ≡ binomial-sum (suc n) h k
    step n h k =
        𝓛-D n _
      ∙ D-ext n (λ a b → 𝓛-scale (Cb a b) _
                       ∙ cong (scale (Cb a b)) (𝓛-leib (𝓛^ a h) (𝓛^ b k))
                       ∙ scale-add (Cb a b) _ _)
      ∙ D-add n _ _
      ∙ sym (pascal-D n Cb Cb-pascal Cb-left Cb-top (λ a b → 𝓛^ a h · 𝓛^ b k))

    -- THE THEOREM:  𝓛ⁿ (h · k) ≡ Σ_{a+b=n} C(a+b,a) 𝓛ᵃ h · 𝓛ᵇ k
    iterated-leibniz : (n : ℕ) (h k : A) → 𝓛^ n (h · k) ≡ binomial-sum n h k
    iterated-leibniz zero    h k = sym (+IdR (h · k))
    iterated-leibniz (suc n) h k = cong 𝓛 (iterated-leibniz n h k) ∙ step n h k

    -- the second order, unfolded (in the sum's own order, a = 0, 1, 2):
    --   𝓛²(hk) = h·𝓛²k + 2 𝓛h·𝓛k + 𝓛²h·k
    second-order : (h k : A)
      → 𝓛 (𝓛 (h · k))
        ≡ (h · 𝓛 (𝓛 k) + 0r) + (((𝓛 h · 𝓛 k) + ((𝓛 h · 𝓛 k) + 0r)) + (𝓛 (𝓛 h) · k + 0r))
    second-order h k = iterated-leibniz 2 h k
