{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The exact two-way universal-property form of WalkStream.installStream,
-- together with controls showing that each advertised side condition is
-- independently load-bearing.
------------------------------------------------------------------------

module WalkStreamHypothesisBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; propBiimpl→Equiv)
open import Cubical.Foundations.HLevels
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Nat.GCD
open import Cubical.Data.List
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Unit
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import WalkCapacity
open import WalkForcing
  using (LeastNonDivisor ; coprime-divisors-multiply)
open import WalkStream
  using (2≤→0< ; range1-common ; installStream)

------------------------------------------------------------------------
-- 1. IsLCM is proposition-valued, so two universal-property maps give an
--    actual equivalence of proof types.
------------------------------------------------------------------------

isPropCommonMultiple : (xs : List ℕ) (m : ℕ)
                     → isProp (CommonMultiple xs m)
isPropCommonMultiple []       m = isPropUnit
isPropCommonMultiple (x ∷ xs) m =
  isProp× isProp∣ (isPropCommonMultiple xs m)

isPropIsLCM : (xs : List ℕ) (L : ℕ) → isProp (IsLCM xs L)
isPropIsLCM xs L =
  isProp×
    (isPropCommonMultiple xs L)
    (isPropΠ2 (λ _ _ → isProp∣))

-- Any common multiple of the installed state covers the whole numerical
-- frontier.  Keeping this case split top-level avoids hiding the load-bearing
-- range and least-non-divisor hypotheses inside the equivalence proof.
coversFromInstalled :
  (S : List ℕ) (L q m : ℕ) →
  IsLCM S L →
  LeastNonDivisor L q →
  CommonMultiple (q ∷ S) m →
  (r : ℕ) → 0 < r → r ≤ q → r ∣ m
coversFromInstalled S L q m lcmS lnd installed-common r 0<r r≤q with ≤-split r≤q
coversFromInstalled S L q m lcmS lnd installed-common r 0<r r≤q | inr r≡q =
  subst (_∣ m) (sym r≡q) (installed-common .fst)
coversFromInstalled S L q m lcmS lnd installed-common r 0<r r≤q | inl r<q
  with ≤-split 0<r
coversFromInstalled S L q m lcmS lnd installed-common r 0<r r≤q | inl r<q | inr 1≡r =
  subst (_∣ m) 1≡r (∣-oneˡ m)
coversFromInstalled S L q m lcmS lnd installed-common r 0<r r≤q | inl r<q | inl 1<r =
  ∣-trans (lnd .snd r 1<r r<q) (lcmS .snd m (installed-common .snd))

-- The direction not exported by WalkStream: a frontier LCM is also an LCM
-- of the newly installed state.  The proof uses exactly the same premises.
frontier→installedLCM :
  (S : List ℕ) (L q M : ℕ) →
  2 ≤ q →
  IsLCM S L →
  LeastNonDivisor L q →
  All (λ x → (0 < x) × (x < q)) S →
  IsLCM (range1 q) M →
  IsLCM (q ∷ S) M
frontier→installedLCM S L q M 2≤q lcmS lnd inRange
  (M-common , M-least) =
  (q∣M , mapS S inRange) , least
  where
  q∣M : q ∣ M
  q∣M = All→∈ (_∣ M) (range1 q) M-common
          (∈-range1 q q (2≤→0< q 2≤q) ≤-refl)

  mapS : (ys : List ℕ) →
         All (λ x → (0 < x) × (x < q)) ys →
         All (_∣ M) ys
  mapS []       _        = tt
  mapS (y ∷ ys) (p , ps) =
    All→∈ (_∣ M) (range1 q) M-common
      (∈-range1 y q (p .fst) (<-weaken (p .snd)))
    , mapS ys ps

  least : (m : ℕ) → CommonMultiple (q ∷ S) m → M ∣ m
  least m installed-common =
    M-least m
      (range1-common q m
        (coversFromInstalled S L q m
          lcmS lnd installed-common))

installedLCM≃frontierLCM :
  (S : List ℕ) (L q M : ℕ) →
  2 ≤ q →
  IsLCM S L →
  LeastNonDivisor L q →
  All (λ x → (0 < x) × (x < q)) S →
  IsLCM (q ∷ S) M ≃ IsLCM (range1 q) M
installedLCM≃frontierLCM S L q M 2≤q lcmS lnd inRange =
  propBiimpl→Equiv
    (isPropIsLCM (q ∷ S) M)
    (isPropIsLCM (range1 q) M)
    (installStream S L q M 2≤q lcmS lnd inRange)
    (frontier→installedLCM S L q M 2≤q lcmS lnd inRange)

------------------------------------------------------------------------
-- 2. Dropping 2 ≤ q: every other premise holds at q=0, but the new-state
--    LCM 0 is not the LCM of the empty frontier.
------------------------------------------------------------------------

zero∤one : ¬ (0 ∣ 1)
zero∤one p = znots (∣-zeroˡ p)

lcm-empty-one : IsLCM [] 1
lcm-empty-one = tt , λ m _ → ∣-oneˡ m

leastNonDivisor-one-zero : LeastNonDivisor 1 0
leastNonDivisor-one-zero =
  zero∤one , λ r 2≤r r<0 → Empty.rec (¬-<-zero r<0)

lcm-zero-singleton : IsLCM (0 ∷ []) 0
lcm-zero-singleton =
  (∣-zeroʳ 0 , tt) , λ m common → common .fst

zero-not-lcm-empty-frontier : ¬ IsLCM (range1 0) 0
zero-not-lcm-empty-frontier (_ , least) = zero∤one (least 1 tt)

not-two≤zero : ¬ (2 ≤ 0)
not-two≤zero 2≤0 = snotz (≤0→≡0 2≤0)

lower-bound-control :
    IsLCM [] 1
  × LeastNonDivisor 1 0
  × All (λ x → (0 < x) × (x < 0)) []
  × IsLCM (0 ∷ []) 0
  × (¬ IsLCM (range1 0) 0)
  × (¬ (2 ≤ 0))
lower-bound-control =
  lcm-empty-one , leastNonDivisor-one-zero , tt , lcm-zero-singleton
  , zero-not-lcm-empty-frontier , not-two≤zero

------------------------------------------------------------------------
-- 3. Dropping the installed-address range: [3] has LCM 3 and q=2 is its
--    least non-divisor; [2,3] has LCM 6, not the frontier [2,1]'s LCM.
------------------------------------------------------------------------

¬2∣3 : ¬ (2 ∣ 3)
¬2∣3 p = go (∣-untrunc p)
  where
  go : Σ[ c ∈ ℕ ] c · 2 ≡ 3 → ⊥
  go (zero          , e) = znots e
  go (suc zero      , e) = znots (injSuc (injSuc e))
  go (suc (suc c)   , e) = snotz (injSuc (injSuc (injSuc e)))

lcm-three-singleton : IsLCM (3 ∷ []) 3
lcm-three-singleton =
  (∣-refl refl , tt) , λ m common → common .fst

leastNonDivisor-three-two : LeastNonDivisor 3 2
leastNonDivisor-three-two =
  ¬2∣3 , λ r 2≤r r<2 → Empty.rec (¬m<m (≤<-trans 2≤r r<2))

gcd-two-three : isGCD 2 3 1
gcd-two-three = gcdIsGCD 2 3

lcm-two-three-six : IsLCM (2 ∷ 3 ∷ []) 6
lcm-two-three-six =
  (∣-left 3 , ∣-right 2 , tt)
  , λ m common →
      coprime-divisors-multiply 2 3 m gcd-two-three
        (common .fst) (common .snd .fst)

three-not-in-frontier-two :
  ¬ All (λ x → (0 < x) × (x < 2)) (3 ∷ [])
three-not-in-frontier-two ((0<3 , 3<2) , _) =
  ¬m<m (≤<-trans (≤-suc ≤-refl) 3<2)

¬6∣2 : ¬ (6 ∣ 2)
¬6∣2 p =
  snotz (≤0→≡0
    (pred-≤-pred (pred-≤-pred (m∣sn→m≤sn p))))

range-two-common-at-two : CommonMultiple (range1 2) 2
range-two-common-at-two = ∣-refl refl , ∣-oneˡ 2 , tt

six-not-lcm-frontier-two : ¬ IsLCM (range1 2) 6
six-not-lcm-frontier-two (_ , least) =
  ¬6∣2 (least 2 range-two-common-at-two)

installed-range-control :
    (2 ≤ 2)
  × IsLCM (3 ∷ []) 3
  × LeastNonDivisor 3 2
  × IsLCM (2 ∷ 3 ∷ []) 6
  × (¬ All (λ x → (0 < x) × (x < 2)) (3 ∷ []))
  × (¬ IsLCM (range1 2) 6)
installed-range-control =
  ≤-refl , lcm-three-singleton , leastNonDivisor-three-two
  , lcm-two-three-six , three-not-in-frontier-two
  , six-not-lcm-frontier-two
