{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HomometricPair
--
-- Theorem A(ii) of notes/REPORT.md §2, item 2, made a checked term.
--
-- CLAIM (as stated in REPORT.md §2.2):
--
--     the difference marginal c_a has a genuine kernel: there are 0-1
--     sets that share the same multiset of pairwise differences and are
--     NOT congruent (congruent = related by a translation and/or a
--     reflection of ℤ).  The minimal examples have 6 elements and
--     diameter 11, e.g.
--
--         A = {0,1,2,6,8,11}      B = {0,1,6,7,9,11}.
--
-- The ambient group is ℤ, NOT ℤ/12: the difference multiset is taken in
-- the integers and the diameter-11 statement is a statement about
-- subsets of {0,…,13}.  (Anyone arriving from the music-theory
-- literature, where the analogous relation is the cyclic "Z-relation"
-- mod 12, should note the difference.)
--
-- WHAT IS FORMALIZED HERE (both halves; the equality alone is not the
-- claim):
--
--   * `interval-vector-agree` : the two interval vectors — the counts
--     of each difference 1,…,11 among the 15 unordered pairs — are
--     equal.  `refl`: the kernel computes both.
--   * `A-total`, `B-total`, `A-length`, `B-length` : each set has
--     exactly 15 pairwise differences and all 15 of them are counted by
--     the vector, so the vector really is the whole multiset and no
--     difference escapes the window 1..11.
--   * `not-congruent` : NO translation and no reflection of ℤ carries A
--     to B.  Finite exhaustion over the symmetry types, with the
--     translation parameter eliminated by the head of the sorted list.
--
-- WHAT IS NOT FORMALIZED: minimality ("no homometric pair of diameter
-- ≤ 10", "6 distinct pairs across 12 collision events").  That is a
-- 2^14-subset sweep, a separate and larger kernel run; REPORT.md's
-- minimality clause still rests on the legacy Python search.  This
-- module discharges the existence half only.
--
-- PRIOR ART.  The mathematics is classical and none of it is new here.
-- Homometric (Patterson-equivalent) sets were introduced by A. L.
-- Patterson, "Ambiguities in the X-ray analysis of crystal structures",
-- Phys. Rev. 65 (1944) 195–201 (and already in his 1939 note in Nature
-- 143, 939–940); the polynomial characterization — two sets are
-- homometric iff their generating polynomials arise as f·g and f·g*
-- from a common factorization — is standard and is worked out in
-- J. Rosenblatt and P. D. Seymour, "The structure of homometric sets",
-- SIAM J. Algebraic Discrete Methods 3 (1982) 343–350.  The
-- music-theoretic form (the Z-relation on pitch-class sets, mod 12) is
-- D. Lewin, "The intervallic relations between two collections of
-- notes", J. Music Theory 3 (1959) 298–301.  The specific hexachord
-- pair is, in this literature, an entirely standard example.  **What is
-- new here is only the certificate**: a kernel-checked term replacing an
-- uncertified script.
------------------------------------------------------------------------

module HomometricPair where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; predℕ ; znots)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map ; length)
open import Cubical.Data.Vec using (Vec ; [] ; _∷_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; _×_)
open import Cubical.Data.Empty using (⊥)

------------------------------------------------------------------------
-- 1.  The two sets, as sorted lists of naturals
--
--     Both are normalized: least element 0, greatest element 11.  Every
--     finite subset of ℤ has exactly one translate in this form, which
--     is what makes the exhaustion in §4 finite.
------------------------------------------------------------------------

A B : List ℕ
A = 0 ∷ 1 ∷ 2 ∷ 6 ∷ 8 ∷ 11 ∷ []
B = 0 ∷ 1 ∷ 6 ∷ 7 ∷ 9 ∷ 11 ∷ []

-- the reflection of A inside its own bounding interval, x ↦ 11 ∸ x,
-- listed in increasing order.  (Written out rather than computed by a
-- `reverse ∘ map`, so that the reader can check it by eye; that it IS
-- the reflection is `A-mirror-is-reflection` below, proved by refl.)
mA : List ℕ
mA = 0 ∷ 3 ∷ 5 ∷ 9 ∷ 10 ∷ 11 ∷ []

reflect11 : List ℕ → List ℕ
reflect11 xs = map (λ x → 11 ∸ x) xs

-- 11 ∸ (·) applied to A, read backwards, is mA:
A-mirror-is-reflection : reflect11 A ≡ 11 ∷ 10 ∷ 9 ∷ 5 ∷ 3 ∷ 0 ∷ []
A-mirror-is-reflection = refl

------------------------------------------------------------------------
-- 2.  The difference multiset and the interval vector
------------------------------------------------------------------------

-- all positive differences y ∸ x for x before y in a sorted list
diffs : List ℕ → List ℕ
diffs [] = []
diffs (x ∷ xs) = map (λ y → y ∸ x) xs ++ diffs xs

eqb : ℕ → ℕ → Bool
eqb zero zero = true
eqb zero (suc _) = false
eqb (suc _) zero = false
eqb (suc m) (suc n) = eqb m n

count : ℕ → List ℕ → ℕ
count k [] = 0
count k (x ∷ xs) = if eqb k x then suc (count k xs) else count k xs

-- the interval vector: multiplicity of the differences 1,2,…,11
iv : List ℕ → Vec ℕ 11
iv s = c 1 ∷ c 2 ∷ c 3 ∷ c 4 ∷ c 5 ∷ c 6 ∷ c 7 ∷ c 8 ∷ c 9 ∷ c 10 ∷ c 11 ∷ []
  where c : ℕ → ℕ
        c k = count k (diffs s)

sumV : {n : ℕ} → Vec ℕ n → ℕ
sumV [] = 0
sumV (x ∷ xs) = x + sumV xs

------------------------------------------------------------------------
--   The homometry half.
------------------------------------------------------------------------

-- both sets have the same interval vector; the kernel computes both
interval-vector-agree : iv A ≡ iv B
interval-vector-agree = refl

-- and it is (2,2,1,1,2,2,1,1,1,1,1)
interval-vector-value : iv A ≡ 2 ∷ 2 ∷ 1 ∷ 1 ∷ 2 ∷ 2 ∷ 1 ∷ 1 ∷ 1 ∷ 1 ∷ 1 ∷ []
interval-vector-value = refl

-- no difference escapes the window 1..11: the vector accounts for all
-- 15 unordered pairs of a 6-element set, so equality of the vectors is
-- equality of the full difference multisets.
A-length B-length : ℕ
A-length = length (diffs A)
B-length = length (diffs B)

A-has-15-differences : length (diffs A) ≡ 15
A-has-15-differences = refl

B-has-15-differences : length (diffs B) ≡ 15
B-has-15-differences = refl

A-total : sumV (iv A) ≡ 15
A-total = refl

B-total : sumV (iv B) ≡ 15
B-total = refl

------------------------------------------------------------------------
-- 3.  Congruence
--
--   Two finite subsets of ℤ are congruent when one is carried to the
--   other by x ↦ x + t or x ↦ t ∸ x for some t ∈ ℤ.  Both A and B are
--   normalized (least element 0), and translation preserves the sorted
--   order while reflection reverses it, so a congruence between them is
--   one of exactly four shapes, with the translation parameter a
--   natural number in one direction or the other:
--
--       B = A + t,   A = B + t,   B = mA + t,   mA = B + t.
--
--   This is the (elementary, and here *assumed*) reduction from ℤ to ℕ;
--   it is a definition in this module, not a theorem of it.  Everything
--   after the definition is proved.
------------------------------------------------------------------------

shift : ℕ → List ℕ → List ℕ
shift t xs = map (λ x → x + t) xs

-- `Congruent s ms u`: s (whose normalized reflection is ms) is carried
-- to u by a translation, or by a reflection followed by a translation.
Congruent : List ℕ → List ℕ → List ℕ → Type
Congruent s ms u = (Σ[ t ∈ ℕ ] shift t s ≡ u)
                 ⊎ ((Σ[ t ∈ ℕ ] s ≡ shift t u)
                 ⊎ ((Σ[ t ∈ ℕ ] shift t ms ≡ u)
                 ⊎  (Σ[ t ∈ ℕ ] ms ≡ shift t u)))

------------------------------------------------------------------------
-- 4.  The non-congruence half
------------------------------------------------------------------------

hd : List ℕ → ℕ
hd [] = 0
hd (x ∷ _) = x

-- the two numeric separations used below
¬2≡6 : 2 ≡ 6 → ⊥
¬2≡6 p = znots (cong (λ n → predℕ (predℕ n)) p)

¬5≡6 : 5 ≡ 6 → ⊥
¬5≡6 p = znots (cong (λ n → predℕ (predℕ (predℕ (predℕ (predℕ n))))) p)

-- third entry of a list (0-indexed 2)
nth2 : List ℕ → ℕ
nth2 (_ ∷ _ ∷ x ∷ _) = x
nth2 _ = 0

not-congruent : Congruent A mA B → ⊥
not-congruent (inl (t , p)) =
  -- head of shift t A is 0 + t = t, head of B is 0, so t ≡ 0,
  -- whence shift 0 A ≡ A (all entries literal: x + 0 reduces) and A ≡ B
  ¬2≡6 (cong nth2 (subst (λ s → shift s A ≡ B) (cong hd p) p))
not-congruent (inr (inl (t , p))) =
  ¬2≡6 (cong nth2 (subst (λ s → A ≡ shift s B) (sym (cong hd p)) p))
not-congruent (inr (inr (inl (t , p)))) =
  ¬5≡6 (cong nth2 (subst (λ s → shift s mA ≡ B) (cong hd p) p))
not-congruent (inr (inr (inr (t , p)))) =
  ¬5≡6 (cong nth2 (subst (λ s → mA ≡ shift s B) (sym (cong hd p)) p))

-- Non-vacuity control: `Congruent` is inhabitable — A is congruent to
-- itself (translation by 0), and mA is congruent to A (its reflection).
-- Without these, `not-congruent` could be a theorem about an empty type.
control-self : Congruent A mA A
control-self = inl (0 , refl)

control-mirror : Congruent mA A A
control-mirror = inr (inr (inl (0 , refl)))

------------------------------------------------------------------------
-- 5.  The statement of Theorem A(ii), existence half
------------------------------------------------------------------------

homometric-and-non-congruent : (iv A ≡ iv B) × (Congruent A mA B → ⊥)
homometric-and-non-congruent = interval-vector-agree , not-congruent
