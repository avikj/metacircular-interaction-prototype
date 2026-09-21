{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BoundaryBlockGeneral — for every finite receiver f and every finite
-- coefficient signal c, over any commutative ring,
--
--     Σ_{t<W} ( Σ_{k<m} c_k (S^k f)(t) )²
--       ≡  Σ_{k<m} Σ_{l<m} c_k · c_l · ρ(|k − l|),
--
-- where S is the unit right shift, W = m + n is the window holding the
-- shifted receivers, and ρ(d) = Σ_{s<n} f(s) f(s+d) is the receiver's
-- autocorrelation at lag d.  This is BoundaryBlock at arbitrary widths.
--
-- WHAT THIS IS.  The identity behind the prime-boundary document's
-- boundary profile h = f ∗ f̃: driving a receiver f by coefficients c
-- and taking the mean square is the same as pairing the pair field
-- c_k c_l with the autocorrelation of f.  The left side is a sum of
-- squares; so the pairing is non-negative at every autocorrelation
-- receiver by an identity, not by an estimate.
--
--   §1  finite sums over ℕ: extensionality (bounded), linearity,
--       exchange, splitting, and the product of two sums;
--   §2  the shift S, shift-invariance of the inner product
--       ⟨S^k g , S^k h⟩_{k+N} ≡ ⟨g , h⟩_N, and S^{k+d} ≡ S^k ∘ S^d;
--   §3  padding: a receiver vanishing from n on has the same inner
--       product on any longer window;
--   §4  the correlation ⟨S^k f , S^l f⟩_W of two shifted copies is
--       ρ(l − k) when k ≤ l and ρ(k − l) when l ≤ k;
--   §5  THE BLOCK IDENTITY, by bilinearity and §4.
--
-- SYĀT — THE CLAIM, EXACTLY.  Finite sums over a commutative ring, one
-- window, one receiver vanishing beyond n, coefficients read on m slots.
-- No limit, no arithmetic function, no positivity beyond "a sum of
-- squares is a sum of squares".
------------------------------------------------------------------------

module BoundaryBlockGeneral_ForEveryFiniteReceiverAndEveryFiniteCoefficientSignalTheMeanSquareIsThePairFieldPairedWithTheAutocorrelationLags where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; +-comm ; +-zero ; +-suc)
open import Cubical.Data.Nat.Order
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.Ring.Properties using (module RingTheory)
open import Cubical.Algebra.CommRing.Base using (CommRing→Ring)

private
  +-assoc' : (a b c : ℕ) → a + (b + c) ≡ (a + b) + c
  +-assoc' zero b c = refl
  +-assoc' (suc a) b c = cong suc (+-assoc' a b c)

  -- m + n ≡ k + (n + (m ∸ k)) when k < m
  window : (m n k : ℕ) → k < m → m + n ≡ k + (n + (m ∸ k))
  window m n k k<m =
    cong (_+ n) (sym (≤-∸-+-cancel (<-weaken k<m)) ∙ +-comm (m ∸ k) k)
    ∙ sym (+-assoc' k (m ∸ k) n) ∙ cong (k +_) (+-comm (m ∸ k) n)

  -- k + (l ∸ k) ≡ l when k ≤ l
  split : (k l : ℕ) → k ≤ l → k + (l ∸ k) ≡ l
  split k l k≤l = +-comm k (l ∸ k) ∙ ≤-∸-+-cancel k≤l

  ≰→≥ : (k l : ℕ) → ¬ (k ≤ l) → l ≤ k
  ≰→≥ k l k≰l = <-weaken (<-asym' (λ p → k≰l (pred-≤-pred p)))

module General {ℓ : Level} (R' : CommRing ℓ) where

  open CommRingStr (R' .snd) renaming (_+_ to _+r_ ; _·_ to _·r_ ; -_ to neg)
  open RingTheory (CommRing→Ring R') using (0LeftAnnihilates ; 0RightAnnihilates)

  private
    K : Type ℓ
    K = fst R'

  Sig : Type ℓ
  Sig = ℕ → K

  ----------------------------------------------------------------------
  -- §1  finite sums
  ----------------------------------------------------------------------

  sum : ℕ → Sig → K
  sum zero g = 0r
  sum (suc N) g = g 0 +r sum N (g ∘ suc)

  -- extensionality below the bound
  sum-ext< : (N : ℕ) {g h : Sig} → ((t : ℕ) → t < N → g t ≡ h t) → sum N g ≡ sum N h
  sum-ext< zero e = refl
  sum-ext< (suc N) e =
    cong₂ _+r_ (e 0 (suc-≤-suc zero-≤)) (sum-ext< N (λ t t<N → e (suc t) (suc-≤-suc t<N)))

  sum-ext : (N : ℕ) {g h : Sig} → ((t : ℕ) → g t ≡ h t) → sum N g ≡ sum N h
  sum-ext N e = sum-ext< N (λ t _ → e t)

  sum-0 : (N : ℕ) → sum N (λ _ → 0r) ≡ 0r
  sum-0 zero = refl
  sum-0 (suc N) = cong (0r +r_) (sum-0 N) ∙ +IdR 0r

  sum-+ : (N : ℕ) (g h : Sig) → sum N (λ t → g t +r h t) ≡ sum N g +r sum N h
  sum-+ zero g h = sym (+IdR 0r)
  sum-+ (suc N) g h =
    cong ((g 0 +r h 0) +r_) (sum-+ N (g ∘ suc) (h ∘ suc)) ∙ shuffle _ _ _ _
    where
      shuffle : (a b c d : K) → (a +r b) +r (c +r d) ≡ (a +r c) +r (b +r d)
      shuffle a b c d =
        sym (+Assoc _ _ _) ∙ cong (a +r_) (+Assoc _ _ _ ∙ cong (_+r d) (+Comm b c) ∙ sym (+Assoc _ _ _))
        ∙ +Assoc _ _ _

  sum-·l : (N : ℕ) (a : K) (g : Sig) → sum N (λ t → a ·r g t) ≡ a ·r sum N g
  sum-·l zero a g = sym (0RightAnnihilates a)
  sum-·l (suc N) a g = cong (a ·r g 0 +r_) (sum-·l N a (g ∘ suc)) ∙ sym (·DistR+ _ _ _)

  sum-·r : (N : ℕ) (a : K) (g : Sig) → sum N (λ t → g t ·r a) ≡ sum N g ·r a
  sum-·r N a g = sum-ext N (λ t → ·Comm _ _) ∙ sum-·l N a g ∙ ·Comm _ _

  sum-swap : (M N : ℕ) (F : ℕ → ℕ → K)
           → sum M (λ i → sum N (λ j → F i j)) ≡ sum N (λ j → sum M (λ i → F i j))
  sum-swap zero N F = sym (sum-0 N)
  sum-swap (suc M) N F =
    cong (sum N (F 0) +r_) (sum-swap M N (λ i j → F (suc i) j)) ∙ sym (sum-+ N _ _)

  -- a sum over l + N splits into the first l terms and the rest
  sum-split : (l N : ℕ) (g : Sig) → sum (l + N) g ≡ sum l g +r sum N (λ s → g (l + s))
  sum-split zero N g = sym (+IdL _)
  sum-split (suc l) N g =
    cong (g 0 +r_) (sum-split l N (g ∘ suc)) ∙ +Assoc _ _ _

  -- the product of two sums is the double sum of products
  sum-prod : (M : ℕ) (a b : Sig) → sum M a ·r sum M b ≡ sum M (λ k → sum M (λ l → a k ·r b l))
  sum-prod M a b =
    sym (sum-·r M (sum M b) a) ∙ sum-ext M (λ k → sym (sum-·l M (a k) b))

  ----------------------------------------------------------------------
  -- §2  the shift and the inner product
  ----------------------------------------------------------------------

  sh : Sig → Sig
  sh g zero = 0r
  sh g (suc t) = g t

  S : ℕ → Sig → Sig
  S zero g = g
  S (suc k) g = sh (S k g)

  ip : ℕ → Sig → Sig → K
  ip N g h = sum N (λ t → g t ·r h t)

  ip-comm : (N : ℕ) (g h : Sig) → ip N g h ≡ ip N h g
  ip-comm N g h = sum-ext N (λ t → ·Comm _ _)

  sh-ip : (N : ℕ) (g h : Sig) → ip (suc N) (sh g) (sh h) ≡ ip N g h
  sh-ip N g h = cong (_+r ip N g h) (0LeftAnnihilates 0r) ∙ +IdL _

  S-ip : (k N : ℕ) (g h : Sig) → ip (k + N) (S k g) (S k h) ≡ ip N g h
  S-ip zero N g h = refl
  S-ip (suc k) N g h = sh-ip (k + N) (S k g) (S k h) ∙ S-ip k N g h

  S-comp : (k d : ℕ) (g : Sig) → S (k + d) g ≡ S k (S d g)
  S-comp zero d g = refl
  S-comp (suc k) d g = cong sh (S-comp k d g)

  ----------------------------------------------------------------------
  -- §3  padding
  ----------------------------------------------------------------------

  Vanish : Sig → ℕ → Type ℓ
  Vanish f n = (t : ℕ) → n ≤ t → f t ≡ 0r

  pad : (n E : ℕ) (f h : Sig) → Vanish f n → ip (n + E) f h ≡ ip n f h
  pad n E f h v =
    sum-split n E (λ t → f t ·r h t)
    ∙ cong (ip n f h +r_)
        (sum-ext E (λ s → cong (_·r h (n + s)) (v (n + s) ≤SumLeft) ∙ 0LeftAnnihilates _)
         ∙ sum-0 E)
    ∙ +IdR _

  ----------------------------------------------------------------------
  -- §4  correlations of shifted copies are autocorrelation lags
  ----------------------------------------------------------------------

  -- the autocorrelation of f at lag d, on the window n
  ρ : (n : ℕ) (f : Sig) → ℕ → K
  ρ n f d = ip n f (S d f)

  -- ⟨S^k f , S^{k+d} f⟩ on a window k + n + E is ρ(d)
  corr-≤ : (n : ℕ) (f : Sig) → Vanish f n → (k d E : ℕ)
         → ip (k + (n + E)) (S k f) (S (k + d) f) ≡ ρ n f d
  corr-≤ n f v k d E =
    cong (ip (k + (n + E)) (S k f)) (S-comp k d f)
    ∙ S-ip k (n + E) f (S d f)
    ∙ pad n E f (S d f) v

  -- the lag |k − l|, decided
  lag : ℕ → ℕ → ℕ
  lag k l with ≤Dec k l
  ... | yes _ = l ∸ k
  ... | no _  = k ∸ l

  corr : (m n : ℕ) (f : Sig) → Vanish f n → (k l : ℕ) → k < m → l < m
       → ip (m + n) (S k f) (S l f) ≡ ρ n f (lag k l)
  corr m n f v k l k<m l<m with ≤Dec k l
  ... | yes k≤l =
    cong (λ W → ip W (S k f) (S l f)) (window m n k k<m)
    ∙ cong (λ j → ip (k + (n + (m ∸ k))) (S k f) (S j f)) (sym (split k l k≤l))
    ∙ corr-≤ n f v k (l ∸ k) (m ∸ k)
  ... | no k≰l =
    ip-comm (m + n) (S k f) (S l f)
    ∙ cong (λ W → ip W (S l f) (S k f)) (window m n l l<m)
    ∙ cong (λ j → ip (l + (n + (m ∸ l))) (S l f) (S j f)) (sym (split l k (≰→≥ k l k≰l)))
    ∙ corr-≤ n f v l (k ∸ l) (m ∸ l)

  ----------------------------------------------------------------------
  -- §5  THE BLOCK IDENTITY
  ----------------------------------------------------------------------

  -- the received signal: coefficients c on m slots driving the receiver
  received : (m : ℕ) (c f : Sig) → Sig
  received m c f t = sum m (λ k → c k ·r S k f t)

  meanSquare : (m n : ℕ) (c f : Sig) → K
  meanSquare m n c f = ip (m + n) (received m c f) (received m c f)

  pairing : (m n : ℕ) (c f : Sig) → K
  pairing m n c f = sum m (λ k → sum m (λ l → c k ·r c l ·r ρ n f (lag k l)))

  block : (m n : ℕ) (c f : Sig) → Vanish f n → meanSquare m n c f ≡ pairing m n c f
  block m n c f v =
    -- expand the square into a double sum under the t-sum
    sum-ext W (λ t → sum-prod m (λ k → c k ·r S k f t) (λ l → c l ·r S l f t))
    -- pull the t-sum inside both index sums
    ∙ sum-swap W m _
    ∙ sum-ext m (λ k → sum-swap W m _)
    -- and read each correlation as a lag
    ∙ sum-ext< m (λ k k<m → sum-ext< m (λ l l<m → term k l k<m l<m))
    where
      W : ℕ
      W = m + n

      rearr : (a b x y : K) → (a ·r x) ·r (b ·r y) ≡ (a ·r b) ·r (x ·r y)
      rearr a b x y =
        sym (·Assoc _ _ _) ∙ cong (a ·r_) (·Assoc _ _ _ ∙ cong (_·r y) (·Comm x b) ∙ sym (·Assoc _ _ _))
        ∙ ·Assoc _ _ _

      term : (k l : ℕ) → k < m → l < m
           → sum W (λ t → (c k ·r S k f t) ·r (c l ·r S l f t)) ≡ c k ·r c l ·r ρ n f (lag k l)
      term k l k<m l<m =
        sum-ext W (λ t → rearr (c k) (c l) (S k f t) (S l f t))
        ∙ sum-·l W (c k ·r c l) (λ t → S k f t ·r S l f t)
        ∙ cong ((c k ·r c l) ·r_) (corr m n f v k l k<m l<m)

------------------------------------------------------------------------
-- §6  Over ℤ: the fixed-size instance of BoundaryBlock recovered.
------------------------------------------------------------------------

open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)

open General ℤCommRing

-- the receiver (1,1,1,1) on four slots, zero after
box : Sig
box t with <Dec t 4
... | yes _ = pos 1
... | no _  = pos 0

box-vanishes : Vanish box 4
box-vanishes t 4≤t with <Dec t 4
... | yes t<4 = ⊥-rec (<-asym t<4 4≤t)
... | no _ = refl

-- the coefficients (1,−1,1) on three slots
alt : Sig
alt zero = pos 1
alt (suc zero) = negsuc 0
alt (suc (suc zero)) = pos 1
alt _ = pos 0

-- both sides compute to 4, as in BoundaryBlock
general-at-alternating : meanSquare 3 4 alt box ≡ pos 4
general-at-alternating = refl

pairing-general-at-alternating : pairing 3 4 alt box ≡ pos 4
pairing-general-at-alternating = refl

block-at-alternating : meanSquare 3 4 alt box ≡ pairing 3 4 alt box
block-at-alternating = block 3 4 alt box box-vanishes
