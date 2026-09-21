{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- ChuDefect — the quantitative form of ChuAdvance.
--
-- ChuAdvance states the guard qualitatively: `agree-drop` says that dropping
-- tests never creates a distinction, and `zero-defect-is-not-truth` exhibits a
-- space whose defect vanishes for a reason that has nothing to do with the
-- space.  Here the defect is a natural number and the slogan becomes an
-- inequality:
--
--     δ(e, 𝒯, xs)  ≤  δ(e, 𝒯 ++ 𝒮, xs)          defect-mono
--     δ(e, [], xs) ≡ 0                            defect-[]
--     δ(e, 𝒯, xs) ≡ #pairs(xs) ⇒ 𝒯 separates xs  defect-separates
--
-- **The content is the monotonicity, not the counting.**  Counting is a choice
-- of bookkeeping; nothing here depends on which bookkeeping is chosen.  What is
-- proved is (i) that the bookkeeping is monotone in 𝒯 — so "Shrink(𝒯) ⇒ δ↓" is
-- an inequality between numbers, not a slogan — and (ii) that it saturates
-- exactly when 𝒯 separates the points it was measured on.  Together these say
-- that δ = 0 is a statement about 𝒯 (it is *forced* when 𝒯 = [], for every
-- space whatever) while δ = #pairs is a statement about X.
--
-- Conventions, stated once:
--
--   * δ counts **ordered** pairs of *positions* in the point list `xs`,
--     diagonal included.  The diagonal contributes 0 (a test cannot separate a
--     point from itself), and each separated unordered pair contributes 2, so
--     this δ is twice the unordered count; the choice is immaterial to every
--     theorem below and it avoids carrying an index order around.
--   * The saturation bound `pairs d xs` is the same ordered count taken with
--     "some test separates" replaced by "the points are distinct".  For a
--     duplicate-free `xs` of length n it is n² − n; that numeric identity is
--     not needed and is not proved.
--   * Decidable equality on X is a **hypothesis** (`Discrete X`), never an
--     assumption about what X is.  It is used only for the saturation bound;
--     `defect`, `defect-mono` and `defect-[]` do not mention it.

module ChuDefect where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; _or_ ; true≢false ; false≢true)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; znots ; snotz)
open import Cubical.Data.Nat.Order
  using (_≤_ ; zero-≤ ; ≤-refl ; ≤-trans ; ≤-antisym ; ≤-+k ; ≤-k+ ; ≤-+k-cancel ; ≤-k+-cancel)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

open import ChuAdvance using (Obs ; Agree ; Separates)

private
  variable
    A X T : Type₀

--------------------------------------------------------------------------
-- Bookkeeping: Bool as a 0/1 weight, and sums over a list
--------------------------------------------------------------------------

b2n : Bool → ℕ
b2n true  = 1
b2n false = 0

-- The only two facts about b2n that are used.
b2n≤ : (p q : Bool) → (p ≡ true → q ≡ true) → b2n p ≤ b2n q
b2n≤ false q _   = zero-≤
b2n≤ true  q imp = subst (λ z → b2n true ≤ b2n z) (sym (imp refl)) ≤-refl

b2n-inj : (p q : Bool) → b2n p ≡ b2n q → p ≡ q
b2n-inj false false _ = refl
b2n-inj false true  r = ⊥.rec (znots r)
b2n-inj true  false r = ⊥.rec (snotz r)
b2n-inj true  true  _ = refl

sumL : (A → ℕ) → List A → ℕ
sumL f []       = 0
sumL f (a ∷ as) = f a + sumL f as

sumL-zero : (f : A → ℕ) (l : List A) → ((a : A) → f a ≡ 0) → sumL f l ≡ 0
sumL-zero f []       h = refl
sumL-zero f (a ∷ as) h = cong₂ _+_ (h a) (sumL-zero f as h)

sum-mono : (f g : A → ℕ) → ((a : A) → f a ≤ g a) → (l : List A) → sumL f l ≤ sumL g l
sum-mono f g h []       = ≤-refl
sum-mono f g h (a ∷ as) = ≤-trans (≤-+k (h a)) (≤-k+ (sum-mono f g h as))

-- A sum that is pointwise ≤ another and equal to it is pointwise equal to it.
-- This is the whole arithmetic content of `defect-separates`.
+-split : {a b c d : ℕ} → a ≤ c → b ≤ d → a + b ≡ c + d → (a ≡ c) × (b ≡ d)
+-split {a} {b} {c} {d} ac bd eq =
    ≤-antisym ac (≤-+k-cancel {m = c} {k = b} {n = a}
                    (subst (λ z → c + b ≤ z) (sym eq) (≤-k+ bd)))
  , ≤-antisym bd (≤-k+-cancel {k = a} {m = d} {n = b}
                    (subst (λ z → a + d ≤ z) (sym eq) (≤-+k ac)))

-- Membership, spelled out so that nothing about X is assumed.
_∈L_ : A → List A → Type₀
a ∈L []       = ⊥
a ∈L (x ∷ xs) = (a ≡ x) ⊎ (a ∈L xs)

sum-pointwise :
    (f g : A → ℕ) (h : (a : A) → f a ≤ g a) (l : List A)
  → sumL f l ≡ sumL g l
  → (a : A) → a ∈L l → f a ≡ g a
sum-pointwise f g h []      eq a m       = ⊥.rec m
sum-pointwise f g h (b ∷ l) eq a (inl p) =
  subst (λ z → f z ≡ g z) (sym p) (fst (+-split (h b) (sum-mono f g h l) eq))
sum-pointwise f g h (b ∷ l) eq a (inr m) =
  sum-pointwise f g h l (snd (+-split (h b) (sum-mono f g h l) eq)) a m

--------------------------------------------------------------------------
-- "some test in 𝒯 separates x from y", as a Bool
--------------------------------------------------------------------------

diff : Bool → Bool → Bool
diff true  true  = false
diff true  false = true
diff false true  = true
diff false false = false

diff-refl : (b : Bool) → diff b b ≡ false
diff-refl true  = refl
diff-refl false = refl

agree→diff-false : (b c : Bool) → b ≡ c → diff b c ≡ false
agree→diff-false b c p = cong (diff b) (sym p) ∙ diff-refl b

-- sep e ts x y ≡ true  ⇔  some t ∈ ts has e x t ≠ e y t.
sep : Obs X T → List T → X → X → Bool
sep e []       x y = false
sep e (t ∷ ts) x y = diff (e x t) (e y t) or sep e ts x y

-- Agreement on 𝒯 is exactly the vanishing of sep on 𝒯 (the direction used).
agree→sep-false :
    (e : Obs X T) (ts : List T) (x y : X) → Agree e ts x y → sep e ts x y ≡ false
agree→sep-false e []       x y a       = refl
agree→sep-false e (t ∷ ts) x y (p , a) =
  cong (_or sep e ts x y) (agree→diff-false (e x t) (e y t) p)
    ∙ agree→sep-false e ts x y a

≡→Agree : (e : Obs X T) (ts : List T) (x y : X) → x ≡ y → Agree e ts x y
≡→Agree e []       x y p = tt
≡→Agree e (t ∷ ts) x y p = cong (λ z → e z t) p , ≡→Agree e ts x y p

--------------------------------------------------------------------------
-- Shrink(𝒯) ⇒ δ↓ : the pointwise step
--------------------------------------------------------------------------

private
  or-mono : (b c c' : Bool) → (c ≡ true → c' ≡ true) → (b or c) ≡ true → (b or c') ≡ true
  or-mono true  c c' _   _ = refl
  or-mono false c c' imp s = imp s

sep-mono :
    (e : Obs X T) (ts ss : List T) (x y : X)
  → sep e ts x y ≡ true → sep e (ts ++ ss) x y ≡ true
sep-mono e []       ss x y s = ⊥.rec (false≢true s)
sep-mono e (t ∷ ts) ss x y s =
  or-mono (diff (e x t) (e y t)) (sep e ts x y) (sep e (ts ++ ss) x y)
          (sep-mono e ts ss x y) s

--------------------------------------------------------------------------
-- The defect as a number
--------------------------------------------------------------------------

row : Obs X T → List T → List X → X → ℕ
row e ts xs x = sumL (λ y → b2n (sep e ts x y)) xs

-- δ(e, 𝒯, xs) : the number of ordered pairs of positions in xs that some test
-- in 𝒯 separates.
defect : Obs X T → List T → List X → ℕ
defect e ts xs = sumL (row e ts xs) xs

-- 1.  δ([]) = 0, for every observation and every point list: the empty test
--     list makes every pair agree, so a vanishing defect is never evidence.
defect-[] : (e : Obs X T) (xs : List X) → defect e [] xs ≡ 0
defect-[] e xs = sumL-zero (row e [] xs) xs (λ x → sumL-zero _ xs (λ y → refl))

-- 2.  Shrink(𝒯) ⇒ δ↓, as an inequality between numbers.
defect-mono :
    (e : Obs X T) (ts ss : List T) (xs : List X)
  → defect e ts xs ≤ defect e (ts ++ ss) xs
defect-mono e ts ss xs =
  sum-mono (row e ts xs) (row e (ts ++ ss) xs)
    (λ x → sum-mono _ _ (λ y → b2n≤ (sep e ts x y) (sep e (ts ++ ss) x y)
                                    (sep-mono e ts ss x y)) xs)
    xs

--------------------------------------------------------------------------
-- Saturation : δ = #pairs ⇒ separation on xs
--------------------------------------------------------------------------

private
  decB : {B : Type₀} → Dec B → Bool
  decB (yes _) = false
  decB (no  _) = true

  decB-false : {B : Type₀} (u : Dec B) → decB u ≡ false → B
  decB-false (yes p) _ = p
  decB-false (no ¬p) q = ⊥.rec (true≢false q)

  decB-cases : {B : Type₀} (u : Dec B) → (decB u ≡ true) ⊎ B
  decB-cases (yes p) = inr p
  decB-cases (no ¬p) = inl refl

-- dist d x y ≡ true  ⇔  x ≠ y.
dist : Discrete X → X → X → Bool
dist d x y = decB (d x y)

dist-false→≡ : (d : Discrete X) (x y : X) → dist d x y ≡ false → x ≡ y
dist-false→≡ d x y q = decB-false (d x y) q

-- A test can only separate points that are in fact distinct.
sep→dist :
    (d : Discrete X) (e : Obs X T) (ts : List T) (x y : X)
  → sep e ts x y ≡ true → dist d x y ≡ true
sep→dist d e ts x y s with decB-cases (d x y)
... | inl q = q
... | inr p = ⊥.rec (true≢false (sym s ∙ agree→sep-false e ts x y (≡→Agree e ts x y p)))

cell-mono :
    (d : Discrete X) (e : Obs X T) (ts : List T) (x y : X)
  → b2n (sep e ts x y) ≤ b2n (dist d x y)
cell-mono d e ts x y = b2n≤ (sep e ts x y) (dist d x y) (sep→dist d e ts x y)

drow : Discrete X → List X → X → ℕ
drow d xs x = sumL (λ y → b2n (dist d x y)) xs

-- The saturation bound: ordered pairs of positions in xs carrying distinct
-- points.  (n² − n for duplicate-free xs of length n; not needed below.)
pairs : Discrete X → List X → ℕ
pairs d xs = sumL (drow d xs) xs

defect≤pairs :
    (d : Discrete X) (e : Obs X T) (ts : List T) (xs : List X)
  → defect e ts xs ≤ pairs d xs
defect≤pairs d e ts xs =
  sum-mono (row e ts xs) (drow d xs)
    (λ x → sum-mono _ _ (cell-mono d e ts x) xs)
    xs

-- Separation, restricted to the points actually counted.
Separates-on : Obs X T → List T → List X → Type₀
Separates-on {X = X} e ts xs =
  (x y : X) → x ∈L xs → y ∈L xs → Agree e ts x y → x ≡ y

-- 3.  A saturated defect *is* separation on xs.  This is the converse guard:
--     δ = 0 says nothing about X, δ = #pairs says everything (about xs).
defect-separates :
    {X T : Type₀} (d : Discrete X) (e : Obs X T) (ts : List T) (xs : List X)
  → defect e ts xs ≡ pairs d xs
  → Separates-on e ts xs
defect-separates d e ts xs eq x y mx my ag =
  dist-false→≡ d x y (b2n-inj (dist d x y) false (sym cell ∙ cong b2n sepf))
  where
    rowEq : row e ts xs x ≡ drow d xs x
    rowEq = sum-pointwise (row e ts xs) (drow d xs)
              (λ x' → sum-mono _ _ (cell-mono d e ts x') xs) xs eq x mx

    cell : b2n (sep e ts x y) ≡ b2n (dist d x y)
    cell = sum-pointwise (λ y' → b2n (sep e ts x y')) (λ y' → b2n (dist d x y'))
             (cell-mono d e ts x) xs rowEq y my

    sepf : sep e ts x y ≡ false
    sepf = agree→sep-false e ts x y ag

--------------------------------------------------------------------------
-- The ChuAdvance witness, quantified
--------------------------------------------------------------------------

private
  open import Cubical.Data.Bool using (_≟_)

  read : Obs Bool Bool
  read x _ = x

  points : List Bool
  points = true ∷ false ∷ []

-- zero-defect-is-not-truth, with numbers: on two genuinely distinct points the
-- saturation bound is 2, and the empty test list scores 0 — the gap is a
-- property of 𝒯, and one honest test closes it.
gap-[] : defect read [] points ≡ 0
gap-[] = refl

gap-bound : pairs _≟_ points ≡ 2
gap-bound = refl

gap-closed : defect read (true ∷ []) points ≡ pairs _≟_ points
gap-closed = refl

-- and hence, by defect-separates, the one-test list separates the two points.
gap-separates : Separates-on read (true ∷ []) points
gap-separates = defect-separates _≟_ read (true ∷ []) points gap-closed
