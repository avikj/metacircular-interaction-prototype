{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- गणन-निर्धार — the sequence of ordered pair counts determines the sequence.
--
-- SOURCE 1 (formal/lean/Pairfield/SumRigidity.lean, header), quoted:
--
--     Theorem A(i) — Sum-marginal rigidity (V3 target 1).
--
--     sequences, the additive (sum) convolution square determines the sequence:
--     a ∗ a = b ∗ b ⟹ a = b.
--
--     * `sumMarginal_inj`     — the literal Goldbach-marginal statement for
--                               finitely supported a b : ℕ →₀ ℕ:
--                               (∀ N, ∑_{m+n=N} a m · a n = ∑_{m+n=N} b m · b n) ⟹ a = b.
--
--     Proof idea (as in REPORT): embed into the integral domain ℤ[X] (resp. work in
--     ℝ[X]); A² = B² forces A = B or A = −B, and nonnegativity of the coefficients
--     kills the second branch (both sides must then vanish identically).
--
-- SOURCE 2 (formal/lean/Pairfield/YugmaPurana_TheEvenPaddingIsForcedAnd
-- TheDeterminantSaysWhy.lean, the closing "what is not claimed" list), quoted:
--
--     * It does not transport anything from the Agda lane.  See the header: the two
--       proofs are independent, and their agreeing is the content.
--
-- WHAT IS PROVED HERE, exactly.  The same rigidity theorem, composed a
-- second time in this lane, directly over ℕ: no polynomial ring, no ℤ[X],
-- no finite-support hypothesis, no transport from the Lean lane.  For any
-- f : ℕ → ℕ the ordered pair count at N is the Cauchy square
--
--     sq f N := Σ_{m=0}^{N} f m · f (N ∸ m)
--
-- (the Σ≤ of EkaBija; at f = a, the prime indicator, and N = 2w this is
-- EkaBija's ordered Goldbach count 𝒦 w 0 + 2 · Σ_{r=1}^{w} 𝒦 w r, and
-- `sq-even-is-kernel` below records that identification).
--
--   rigidity :
--     (f g : ℕ → ℕ) → ((N : ℕ) → sq f N ≡ sq g N) → (n : ℕ) → f n ≡ g n
--
--   The hypothesis is the equality of the counts at EVERY N — odd N
--   included.  The counts at 2w for all w do NOT determine the sequence:
--   §5 exhibits φ = x³ + 2x⁵ + x⁶ and ψ = x³ + 2x⁴ + x⁶ with the same
--   count at every even N and different at 4 (`even-counts-do-not-
--   determine`).  So the odd N are load-bearing.
--
--   counts-are-the-primes :
--     (f : ℕ → ℕ) → ((N : ℕ) → sq f N ≡ sq a N) → (n : ℕ) → f n ≡ a n
--
--   so a sequence whose ordered pair counts agree with those of the prime
--   indicator at every integer IS the prime indicator; and through
--   EkaBija's one-source-two-readers, f j ≡ 1 ⟺ primeb j ≡ true ⟺
--   (1 < j) × (η j ≡ j), f j ≡ 0 ⟺ primeb j ≡ false.
--
-- HOW.  Strong induction on n.  To get f n ≡ g n from f i ≡ g i below n,
-- a bounded search (decidable, since ℕ has decidable equality) either
-- finds that f vanishes below n — then sq f (n + n) collapses to the
-- single term f n · f n, likewise for g, and squares are injective on ℕ —
-- or finds the least m < n with 0 < f m; then sq f (m + n) has exactly two
-- surviving terms that involve index n, namely f m · f n + f n · f m, all
-- other terms agree with those of g by the induction hypothesis, and
-- (f m + f m) · f n ≡ (f m + f m) · g n cancels because 0 < f m + f m.
-- The two extractions are the finite-sum lemmas Σ≤-remove (pull one term
-- out of a sum by zeroing it in place) and Σ≤-single (a sum with one
-- possibly nonzero term is that term).
--
------------------------------------------------------------------------

module GananaNirdhara_TheSequenceOfOrderedPairCountsDeterminesTheSequenceSoTheGoldbachCountsAtEveryIntegerAreThePrimeIndicator where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using ( ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_
        ; +-zero ; +-comm ; +-assoc ; ·-comm ; ·-distribʳ ; 0≡m·0
        ; znots ; snotz ; discreteℕ ; inj-m+ ; inj-sm· ; +∸ ; ∸+ )
open import Cubical.Data.Nat.Order
  using ( _≤_ ; _<_ ; ≤-refl ; ≤-suc ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ≤0→≡0
        ; ≤-trans ; ≤-∸-+-cancel ; ≤-+k-cancel ; <-weaken ; ≤<-trans ; <-trans
        ; <-+k ; <-k+ ; ≤-k+ ; ¬m<m ; ¬-<-zero ; ≤-·k ; <-·sk
        ; <-split ; ≤-split ; ≤→< ; <→≢ ; splitℕ-< ; ≤-∸-≤
        ; Trichotomy ; lt ; eq ; gt ; _≟_ )
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
import Cubical.Data.Empty as E

open import EkaBija_OnePairKernelTwoReadersGoldbachIsTheCentreMarginalTwinPrimesTheRadiusMarginalAndTheOrderedGoldbachCountIsTheCauchySquareInCentreRadiusCoordinates
  using ( ind ; a ; 𝒦 ; Σ≤ ; Σ₁ ; ordered-goldbach-count ; one-source-two-readers )
open import RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization
  using ( η )
open import SamastaPrasna_TheOpenConstellationEntersTypedAndTheOracleAnswersEveryInstance
  using ( primeb )

------------------------------------------------------------------------
-- §0 · the ordered pair count of a sequence at N: its Cauchy square
------------------------------------------------------------------------

sq : (ℕ → ℕ) → ℕ → ℕ
sq f N = Σ≤ N (λ m → f m · f (N ∸ m))

-- at the prime indicator and an even integer this is EkaBija's kernel sum
sq-even-is-kernel : (w : ℕ) → sq a (2 · w) ≡ 𝒦 w 0 + 2 · Σ₁ w (𝒦 w)
sq-even-is-kernel = ordered-goldbach-count

------------------------------------------------------------------------
-- §1 · finite-sum toolkit for Σ≤ (Σ≤ zero f = f 0, Σ≤ (suc k) f = Σ≤ k f + f (suc k))
------------------------------------------------------------------------

-- (L1) pointwise equal summands on 0..k give equal sums
Σ≤-ext : (k : ℕ) (h h' : ℕ → ℕ) → ((i : ℕ) → i ≤ k → h i ≡ h' i) → Σ≤ k h ≡ Σ≤ k h'
Σ≤-ext zero    h h' e = e zero ≤-refl
Σ≤-ext (suc k) h h' e =
  cong₂ _+_ (Σ≤-ext k h h' (λ i i≤k → e i (≤-suc i≤k))) (e (suc k) ≤-refl)

Σ≤-zeros : (k : ℕ) → Σ≤ k (λ _ → 0) ≡ 0
Σ≤-zeros zero    = refl
Σ≤-zeros (suc k) = +-zero (Σ≤ k (λ _ → 0)) ∙ Σ≤-zeros k

-- zeroing one position of a sequence, by the decision discreteℕ i j
pick : {A : Type} → Dec A → ℕ → ℕ
pick (yes _) _ = 0
pick (no _)  x = x

pick-yes : {A : Type} (d : Dec A) (x : ℕ) → A → pick d x ≡ 0
pick-yes (yes _)  x _  = refl
pick-yes (no ¬p)  x p  = E.rec (¬p p)

pick-no : {A : Type} (d : Dec A) (x : ℕ) → ¬ A → pick d x ≡ x
pick-no (yes p) x ¬p = E.rec (¬p p)
pick-no (no _)  x _  = refl

zeroAt : ℕ → (ℕ → ℕ) → ℕ → ℕ
zeroAt j h i = pick (discreteℕ i j) (h i)

zeroAt-at : (j : ℕ) (h : ℕ → ℕ) (i : ℕ) → i ≡ j → zeroAt j h i ≡ 0
zeroAt-at j h i i≡j = pick-yes (discreteℕ i j) (h i) i≡j

zeroAt-off : (j : ℕ) (h : ℕ → ℕ) (i : ℕ) → ¬ (i ≡ j) → zeroAt j h i ≡ h i
zeroAt-off j h i i≢j = pick-no (discreteℕ i j) (h i) i≢j

-- (L3) pull the term at j ≤ k out of the sum
Σ≤-remove : (k j : ℕ) (h : ℕ → ℕ) → j ≤ k → Σ≤ k h ≡ Σ≤ k (zeroAt j h) + h j
Σ≤-remove zero j h j≤0 =
  subst (λ x → h 0 ≡ zeroAt x h 0 + h x) (sym (≤0→≡0 j≤0))
        (sym (cong (_+ h 0) (zeroAt-at 0 h 0 refl)))
Σ≤-remove (suc k) j h j≤sk with ≤-split j≤sk
... | inl j<sk =
    cong (_+ h (suc k)) (Σ≤-remove k j h (pred-≤-pred j<sk))
  ∙ sym (+-assoc (Σ≤ k (zeroAt j h)) (h j) (h (suc k)))
  ∙ cong (Σ≤ k (zeroAt j h) +_) (+-comm (h j) (h (suc k)))
  ∙ +-assoc (Σ≤ k (zeroAt j h)) (h (suc k)) (h j)
  ∙ cong (λ t → (Σ≤ k (zeroAt j h) + t) + h j)
         (sym (zeroAt-off j h (suc k) (λ e → <→≢ j<sk (sym e))))
... | inr j≡sk =
  subst (λ x → Σ≤ (suc k) h ≡ Σ≤ (suc k) (zeroAt x h) + h x) (sym j≡sk) at-top
  where
  below-top : (i : ℕ) → i ≤ k → h i ≡ zeroAt (suc k) h i
  below-top i i≤k =
    sym (zeroAt-off (suc k) h i (λ e → ¬m<m (subst (_< suc k) e (suc-≤-suc i≤k))))
  at-top : Σ≤ (suc k) h ≡ Σ≤ (suc k) (zeroAt (suc k) h) + h (suc k)
  at-top = cong (_+ h (suc k))
             ( sym (+-zero (Σ≤ k h))
             ∙ cong₂ _+_ (Σ≤-ext k h (zeroAt (suc k) h) below-top)
                         (sym (zeroAt-at (suc k) h (suc k) refl)) )

-- (L2) a sum whose only possibly nonzero term sits at j is that term
Σ≤-single : (k j : ℕ) (h : ℕ → ℕ) → j ≤ k
  → ((i : ℕ) → i ≤ k → ¬ (i ≡ j) → h i ≡ 0) → Σ≤ k h ≡ h j
Σ≤-single k j h j≤k vanish =
    Σ≤-remove k j h j≤k
  ∙ cong (_+ h j) (Σ≤-ext k (zeroAt j h) (λ _ → 0) each ∙ Σ≤-zeros k)
  where
  each : (i : ℕ) → i ≤ k → zeroAt j h i ≡ 0
  each i i≤k with discreteℕ i j
  ... | yes _   = refl
  ... | no  i≢j = vanish i i≤k i≢j

------------------------------------------------------------------------
-- §2 · arithmetic: squares are injective, positive factors cancel
------------------------------------------------------------------------

sq-mono : (x y : ℕ) → x < y → x · x < y · y
sq-mono x zero    x<0  = E.rec (¬-<-zero x<0)
sq-mono x (suc k) x<sk =
  ≤<-trans (≤-·k {k = x} (<-weaken x<sk))
           (subst (_< suc k · suc k) (·-comm x (suc k)) (<-·sk x<sk))

-- (A1)
square-inj : (x y : ℕ) → x · x ≡ y · y → x ≡ y
square-inj x y e with x ≟ y
... | eq p   = p
... | lt x<y = E.rec (¬m<m (subst (x · x <_) (sym e) (sq-mono x y x<y)))
... | gt y<x = E.rec (¬m<m (subst (y · y <_) e (sq-mono y x y<x)))

-- (A2)
cancel : (m x y : ℕ) → 0 < m → m · x ≡ m · y → x ≡ y
cancel zero    x y 0<0 _ = E.rec (¬-<-zero 0<0)
cancel (suc k) x y _   e = inj-sm· {m = k} e

positive : (n : ℕ) → ¬ (n ≡ 0) → 0 < n
positive zero    ne = E.rec (ne refl)
positive (suc k) _  = suc-≤-suc zero-≤

-- truncated subtraction: for i ≤ N,  N < c + i  gives  N ∸ i < c
∸-< : (N i c : ℕ) → i ≤ N → N < c + i → N ∸ i < c
∸-< N i c i≤N N<c+i =
  ≤-+k-cancel {m = suc (N ∸ i)} {k = i} {n = c}
    (subst (_≤ c + i) (cong suc (sym (≤-∸-+-cancel i≤N))) N<c+i)

------------------------------------------------------------------------
-- §3 · bounded search: below n, f vanishes or has a least positive index
------------------------------------------------------------------------

Below : (ℕ → ℕ) → ℕ → Type
Below f n = ((i : ℕ) → i < n → f i ≡ 0)
          ⊎ (Σ[ m ∈ ℕ ] (m < n) × ((i : ℕ) → i < m → f i ≡ 0) × (0 < f m))

-- (B)
below : (f : ℕ → ℕ) (n : ℕ) → Below f n
below f zero    = inl (λ i i<0 → E.rec (¬-<-zero i<0))
below f (suc n) = extend (below f n) (discreteℕ (f n) 0)
  where
  extend : Below f n → Dec (f n ≡ 0) → Below f (suc n)
  extend (inr (m , m<n , z , pos)) _ = inr (m , ≤-suc m<n , z , pos)
  extend (inl z) (no ne)  = inr (n , ≤-refl , z , positive (f n) ne)
  extend (inl z) (yes e)  = inl each
    where
    each : (i : ℕ) → i < suc n → f i ≡ 0
    each i i<sn with <-split i<sn
    ... | inl i<n = z i i<n
    ... | inr i≡n = subst (λ x → f x ≡ 0) (sym i≡n) e

------------------------------------------------------------------------
-- §4 · the inductive step
------------------------------------------------------------------------

-- when f vanishes below n, the count at n + n is the single term f n · f n
single-square : (f : ℕ → ℕ) (n : ℕ) → ((i : ℕ) → i < n → f i ≡ 0)
  → sq f (n + n) ≡ f n · f n
single-square f n z =
    Σ≤-single (n + n) n h (n , refl) vanish
  ∙ cong (λ t → f n · f t) (+∸ n n)
  where
  h : ℕ → ℕ
  h i = f i · f ((n + n) ∸ i)
  vanish : (i : ℕ) → i ≤ n + n → ¬ (i ≡ n) → h i ≡ 0
  vanish i i≤N i≢n with splitℕ-< i n
  ... | inl i<n = cong (_· f ((n + n) ∸ i)) (z i i<n)
  ... | inr n≤i =
      cong (f i ·_)
           (z ((n + n) ∸ i)
              (∸-< (n + n) i n i≤N (<-k+ {k = n} (≤→< n≤i (λ e → i≢n (sym e))))))
    ∙ sym (0≡m·0 (f i))

-- when m < n is the least index with 0 < f m, the count at m + n has
-- exactly two terms involving index n, and they cancel to f n ≡ g n
step-found : (f g : ℕ → ℕ) → ((N : ℕ) → sq f N ≡ sq g N)
  → (n m : ℕ) → m < n
  → ((i : ℕ) → i < n → f i ≡ g i)
  → ((i : ℕ) → i < m → f i ≡ 0) → 0 < f m
  → f n ≡ g n
step-found f g e n m m<n ih zf pos = cancel (f m + f m) (f n) (g n) pos2 key
  where
  N : ℕ
  N = m + n
  h h' : ℕ → ℕ
  h  i = f i · f (N ∸ i)
  h' i = g i · g (N ∸ i)
  zg : (i : ℕ) → i < m → g i ≡ 0
  zg i i<m = sym (ih i (<-trans i<m m<n)) ∙ zf i i<m
  gm≡fm : g m ≡ f m
  gm≡fm = sym (ih m m<n)
  m≤N : m ≤ N
  m≤N = n , +-comm n m
  n≤N : n ≤ N
  n≤N = m , refl
  n≢m : ¬ (n ≡ m)
  n≢m e = <→≢ m<n (sym e)
  pos2 : 0 < f m + f m
  pos2 = ≤-trans pos (f m , refl)

  -- the two-term extraction, for any summand k
  split2 : (k : ℕ → ℕ) → Σ≤ N k ≡ (Σ≤ N (zeroAt n (zeroAt m k)) + k n) + k m
  split2 k =
      Σ≤-remove N m k m≤N
    ∙ cong (_+ k m) ( Σ≤-remove N n (zeroAt m k) n≤N
                    ∙ cong (Σ≤ N (zeroAt n (zeroAt m k)) +_) (zeroAt-off m k n n≢m) )

  -- the remaining terms agree, index by index
  core-low : (i : ℕ) → i < m → h i ≡ h' i
  core-low i i<m = cong (_· f (N ∸ i)) (zf i i<m) ∙ sym (cong (_· g (N ∸ i)) (zg i i<m))

  core-mid : (i : ℕ) → i ≤ N → m < i → i < n → h i ≡ h' i
  core-mid i i≤N m<i i<n =
    cong₂ _·_ (ih i i<n)
              (ih (N ∸ i) (∸-< N i n i≤N (subst (N <_) (+-comm i n) (<-+k {k = n} m<i))))

  core-high : (i : ℕ) → i ≤ N → n < i → h i ≡ h' i
  core-high i i≤N n<i =
      cong (f i ·_) (zf (N ∸ i) lt') ∙ sym (0≡m·0 (f i))
    ∙ 0≡m·0 (g i) ∙ sym (cong (g i ·_) (zg (N ∸ i) lt'))
    where
    lt' : N ∸ i < m
    lt' = ∸-< N i m i≤N (<-k+ {k = m} n<i)

  core : (i : ℕ) → i ≤ N → ¬ (i ≡ m) → ¬ (i ≡ n) → h i ≡ h' i
  core i i≤N i≢m i≢n with splitℕ-< i m | splitℕ-< i n
  ... | inl i<m | _       = core-low i i<m
  ... | inr m≤i | inl i<n = core-mid i i≤N (≤→< m≤i (λ e → i≢m (sym e))) i<n
  ... | inr m≤i | inr n≤i = core-high i i≤N (≤→< n≤i (λ e → i≢n (sym e)))

  inner : (i : ℕ) → i ≤ N → ¬ (i ≡ n) → zeroAt m h i ≡ zeroAt m h' i
  inner i i≤N i≢n with discreteℕ i m
  ... | yes _   = refl
  ... | no  i≢m = core i i≤N i≢m i≢n

  rest : (i : ℕ) → i ≤ N → zeroAt n (zeroAt m h) i ≡ zeroAt n (zeroAt m h') i
  rest i i≤N with discreteℕ i n
  ... | yes _   = refl
  ... | no  i≢n = inner i i≤N i≢n

  R R' : ℕ
  R  = Σ≤ N (zeroAt n (zeroAt m h))
  R' = Σ≤ N (zeroAt n (zeroAt m h'))
  R≡R' : R ≡ R'
  R≡R' = Σ≤-ext N (zeroAt n (zeroAt m h)) (zeroAt n (zeroAt m h')) rest

  -- hence the two surviving terms agree
  two-terms : h n + h m ≡ h' n + h' m
  two-terms = inj-m+ {m = R}
    ( +-assoc R (h n) (h m)
    ∙ sym (split2 h)
    ∙ e N
    ∙ split2 h'
    ∙ sym (+-assoc R' (h' n) (h' m))
    ∙ cong (_+ (h' n + h' m)) (sym R≡R') )

  -- and they are (f m + f m) · f n, resp. (g m + g m) · g n = (f m + f m) · g n
  hn+hm : h n + h m ≡ (f m + f m) · f n
  hn+hm =
      cong₂ _+_ (cong (f n ·_) (cong f (+∸ m n)) ∙ ·-comm (f n) (f m))
                (cong (f m ·_) (cong f (∸+ n m)))
    ∙ ·-distribʳ (f m) (f m) (f n)

  h'n+h'm : h' n + h' m ≡ (f m + f m) · g n
  h'n+h'm =
      cong₂ _+_ (cong (g n ·_) (cong g (+∸ m n)) ∙ ·-comm (g n) (g m))
                (cong (g m ·_) (cong g (∸+ n m)))
    ∙ ·-distribʳ (g m) (g m) (g n)
    ∙ cong (λ t → (t + t) · g n) gm≡fm

  key : (f m + f m) · f n ≡ (f m + f m) · g n
  key = sym hn+hm ∙ two-terms ∙ h'n+h'm

step : (f g : ℕ → ℕ) → ((N : ℕ) → sq f N ≡ sq g N) → (n : ℕ)
  → ((i : ℕ) → i < n → f i ≡ g i) → f n ≡ g n
step f g e n ih with below f n
... | inl z =
  square-inj (f n) (g n)
    ( sym (single-square f n z)
    ∙ e (n + n)
    ∙ single-square g n (λ i i<n → sym (ih i i<n) ∙ z i i<n) )
... | inr (m , m<n , z , pos) = step-found f g e n m m<n ih z pos

------------------------------------------------------------------------
-- §5 · the theorem: the ordered pair counts at every N determine the sequence
------------------------------------------------------------------------

rigidity-below : (f g : ℕ → ℕ) → ((N : ℕ) → sq f N ≡ sq g N)
  → (n : ℕ) → (i : ℕ) → i < n → f i ≡ g i
rigidity-below f g e zero    i i<0  = E.rec (¬-<-zero i<0)
rigidity-below f g e (suc n) i i<sn with <-split i<sn
... | inl i<n = rigidity-below f g e n i i<n
... | inr i≡n = subst (λ x → f x ≡ g x) (sym i≡n) (step f g e n (rigidity-below f g e n))

rigidity : (f g : ℕ → ℕ) → ((N : ℕ) → sq f N ≡ sq g N) → (n : ℕ) → f n ≡ g n
rigidity f g e n = step f g e n (rigidity-below f g e n)

------------------------------------------------------------------------
-- §6 · at the prime indicator: the Goldbach counts at every integer are
--      the primes
------------------------------------------------------------------------

counts-are-the-primes : (f : ℕ → ℕ) → ((N : ℕ) → sq f N ≡ sq a N) → (n : ℕ) → f n ≡ a n
counts-are-the-primes f e = rigidity f a e

ind-one : (b : Bool) → ind b ≡ 1 → b ≡ true
ind-one true  _ = refl
ind-one false e = E.rec (znots e)

ind-zero : (b : Bool) → ind b ≡ 0 → b ≡ false
ind-zero true  e = E.rec (snotz e)
ind-zero false _ = refl

-- f j ≡ 1  ⟺  primeb j ≡ true
counts-read-primeb : (f : ℕ → ℕ) → ((N : ℕ) → sq f N ≡ sq a N) → (j : ℕ)
  → (f j ≡ 1 → primeb j ≡ true) × (primeb j ≡ true → f j ≡ 1)
counts-read-primeb f e j =
    (λ h → ind-one (primeb j) (sym (counts-are-the-primes f e j) ∙ h))
  , (λ p → counts-are-the-primes f e j ∙ cong ind p)

-- f j ≡ 0  ⟺  primeb j ≡ false
counts-read-composite : (f : ℕ → ℕ) → ((N : ℕ) → sq f N ≡ sq a N) → (j : ℕ)
  → (f j ≡ 0 → primeb j ≡ false) × (primeb j ≡ false → f j ≡ 0)
counts-read-composite f e j =
    (λ h → ind-zero (primeb j) (sym (counts-are-the-primes f e j) ∙ h))
  , (λ p → counts-are-the-primes f e j ∙ cong ind p)

-- f j ≡ 1  ⟺  (1 < j) × (η j ≡ j)   (through EkaBija's two readers)
counts-read-η : (f : ℕ → ℕ) → ((N : ℕ) → sq f N ≡ sq a N) → (j : ℕ)
  → (f j ≡ 1 → (1 < j) × (η j ≡ j)) × ((1 < j) × (η j ≡ j) → f j ≡ 1)
counts-read-η f e j =
    (λ h → fst (one-source-two-readers j) (fst (counts-read-primeb f e j) h))
  , (λ r → snd (counts-read-primeb f e j) (snd (one-source-two-readers j) r))

------------------------------------------------------------------------
-- §5 · the even-N counts alone do NOT determine the sequence: a witness
--
-- φ = x³ + 2x⁵ + x⁶ and ψ = x³ + 2x⁴ + x⁶ have the same ordered pair
-- count at every even N (the even part of both squares is
-- x⁶ + 4x⁸ + 4x¹⁰ + x¹²) and differ at 4; their counts differ at the odd
-- N = 7 (0 against 4).  So the hypothesis "at EVERY N" in `rigidity` is
-- not a convenience: dropping the odd N loses the theorem.
------------------------------------------------------------------------

φ : ℕ → ℕ
φ 3 = 1
φ 5 = 2
φ 6 = 1
φ _ = 0

ψ : ℕ → ℕ
ψ 3 = 1
ψ 4 = 2
ψ 6 = 1
ψ _ = 0

φ-tail : (d : ℕ) → φ (7 + d) ≡ 0
φ-tail d = refl

ψ-tail : (d : ℕ) → ψ (7 + d) ≡ 0
ψ-tail d = refl

φ-vanish : (m : ℕ) → 7 ≤ m → φ m ≡ 0
φ-vanish m (d , p) = cong φ (sym p ∙ +-comm d 7) ∙ φ-tail d

ψ-vanish : (m : ℕ) → 7 ≤ m → ψ m ≡ 0
ψ-vanish m (d , p) = cong ψ (sym p ∙ +-comm d 7) ∙ ψ-tail d

-- 7 ≤ 13 ∸ m for m < 7
seven : (m : ℕ) → m < 7 → 7 ≤ 13 ∸ m
seven zero _ = 6 , refl
seven (suc zero) _ = 5 , refl
seven (suc (suc zero)) _ = 4 , refl
seven (suc (suc (suc zero))) _ = 3 , refl
seven (suc (suc (suc (suc zero)))) _ = 2 , refl
seven (suc (suc (suc (suc (suc zero))))) _ = 1 , refl
seven (suc (suc (suc (suc (suc (suc zero)))))) _ = 0 , refl
seven (suc (suc (suc (suc (suc (suc (suc m))))))) lt7 =
  E.rec (¬-<-zero (pred-≤-pred (pred-≤-pred (pred-≤-pred (pred-≤-pred (pred-≤-pred (pred-≤-pred (pred-≤-pred lt7))))))))

-- beyond N = 12 every term of either square vanishes
tail-term : (h : ℕ → ℕ) → ((m : ℕ) → 7 ≤ m → h m ≡ 0)
          → (N : ℕ) → 13 ≤ N → (m : ℕ) → h m · h (N ∸ m) ≡ 0
tail-term h van N N≥13 m with splitℕ-< m 7
... | inl m<7 = cong (h m ·_) (van (N ∸ m) (≤-trans (seven m m<7) (≤-∸-≤ 13 N m N≥13)))
                ∙ sym (0≡m·0 (h m))
... | inr 7≤m = cong (_· h (N ∸ m)) (van m 7≤m)

sq-tail : (h : ℕ → ℕ) → ((m : ℕ) → 7 ≤ m → h m ≡ 0)
        → (N : ℕ) → 13 ≤ N → sq h N ≡ 0
sq-tail h van N N≥13 =
  Σ≤-ext N (λ m → h m · h (N ∸ m)) (λ _ → 0) (λ m _ → tail-term h van N N≥13 m) ∙ Σ≤-zeros N

-- 13 ≤ 2 · (7 + k)
big-even : (k : ℕ) → 13 ≤ 2 · (7 + k)
big-even k =
  ≤-trans (≤-suc ≤-refl)
          (subst (14 ≤_) (·-comm (7 + k) 2) (≤-·k {m = 7} {n = 7 + k} {k = 2} (≤-k+ {k = 7} zero-≤)))

even-counts-agree : (w : ℕ) → sq φ (2 · w) ≡ sq ψ (2 · w)
even-counts-agree zero = refl
even-counts-agree (suc zero) = refl
even-counts-agree (suc (suc zero)) = refl
even-counts-agree (suc (suc (suc zero))) = refl
even-counts-agree (suc (suc (suc (suc zero)))) = refl
even-counts-agree (suc (suc (suc (suc (suc zero))))) = refl
even-counts-agree (suc (suc (suc (suc (suc (suc zero)))))) = refl
even-counts-agree (suc (suc (suc (suc (suc (suc (suc k))))))) =
  sq-tail φ φ-vanish (2 · (7 + k)) (big-even k) ∙ sym (sq-tail ψ ψ-vanish (2 · (7 + k)) (big-even k))

φ≢ψ : ¬ ((n : ℕ) → φ n ≡ ψ n)
φ≢ψ e = znots (e 4)

odd-count-separates : (sq φ 7 ≡ 0) × (sq ψ 7 ≡ 4)
odd-count-separates = refl , refl

even-counts-do-not-determine :
  Σ[ f ∈ (ℕ → ℕ) ] Σ[ g ∈ (ℕ → ℕ) ]
    ((w : ℕ) → sq f (2 · w) ≡ sq g (2 · w)) × (¬ ((n : ℕ) → f n ≡ g n))
even-counts-do-not-determine = φ , ψ , even-counts-agree , φ≢ψ
