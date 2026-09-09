{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SquareClass
--
-- `GaugeOrbitClasses` (theorems/physics) states, in its SYĀT paragraph:
--
--   * The full square-class theorem — that val σ m = val σ n whenever m
--     and n differ by a square in any arrangement — needs invariance of
--     `val` under permutation of the factor multiset, which is NOT
--     proved here.  §7 proves the concatenated form
--     `val σ (m ++ (k ++ k)) ≡ val σ m`, which is the core and avoids
--     permutation machinery.
--
-- This module closes that absence.  The permutation machinery now
-- exists in the corpus — `Insert`/`Perm`/`_≈_` and the embedding
-- `permIsAnAdjacentChain` (theorems/walks), `perm-sym`/`perm-trans`
-- (PermSankramana), and `count-perm` in `Bahulya` (Ekatva) — and the
-- only new arithmetic is that ParitySeparator's `_·_` is commutative,
-- which that module already proves (`·-comm`).
--
-- PROVED HERE (no holes, no postulates, --safe):
--
--   §1  val-≈        val σ m ≡ val σ n  whenever  m ≈ n
--                    (≈nil: refl; ≈cons: cong; ≈swap: commutativity of
--                    `_·_` conjugated by associativity; ≈trans: ∙)
--       val-Perm     … whenever Perm m n           (via permIsAnAdjacentChain)
--       val-Insert   val σ ys ≡ σ x · val σ xs whenever Insert x xs ys
--                    (a second, direct route to val-Perm, val-Perm′)
--       val-count    on ℕ, … whenever every factor has the same count
--                    in m and in n (Bahulya.गणना at discreteℕ, count-perm)
--       obs-Perm     rearranging a query changes no transcript
--
--   §2  the full square-class theorem, in the module's own terms.
--       Three formulations of "m and n differ by a square in any
--       arrangement", each proved to force val σ m ≡ val σ n for EVERY σ:
--
--       SquareTimes m n   :=  Σ k. Perm (m ++ (k ++ k)) n
--                    n is some arrangement of m times a square
--                    (square-class, and square-class-≈ for _≈_)
--       SameSquareClass m n :=  Σ r k k'. Perm (r ++ (k ++ k)) m
--                                        × Perm (r ++ (k' ++ k')) n
--                    a common square-free core, in any arrangement
--                    (square-class-sym; SameSquareClass is reflexive and
--                    symmetric, and symmetric is what SquareTimes is not)
--       ProductIsSquare m n :=  Σ k. Perm (m ++ n) (k ++ k)
--                    the classical form: m ~ n iff m·n is a square
--                    (square-class-prod, using ·-cancel: a · b ≡ true → a ≡ b)
--
--       square-class-adds-no-class   replacing a query by one in the
--                    same square class splits no observable class,
--                    extending GaugeOrbitClasses.square-adds-no-class
--
--   §3  a checked instance at the module's own gauge elements τ₀, τ₋:
--       m = p₀p₁p₀ is an arrangement of p₁ · p₀², so val agrees on p₁
--       and on p₀p₁p₀ — by the theorem, and also by `refl`.
--
-- NOT PROVED (and not claimed): the converse — that val σ m ≡ val σ n
-- for every σ forces m and n into one square class.  That is the
-- statement that the characters separate the square-class group, and
-- it needs a separator constructed from the factor multiset (the
-- sign assignment that flips exactly the primes of odd count in m ++ n);
-- GaugeOrbitClasses does not state it as an absence and it is left open.
--
-- No arithmetic beyond Bool; `Number` is `List ℕ` as in ParitySeparator.
--
-- Agda reports `UnsupportedIndexedMatch` warnings while checking this
-- file; all of them come from the imported PermSankramana module
-- (`insert-comm`, `exchange`), none from definitions here.
------------------------------------------------------------------------

module SquareClass_TheValuationIsInvariantUnderPermutationSoFactorListsDifferingByASquareInAnyArrangementHaveTheSameSign where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map ; _++_)

open import ParitySeparator using (Signs ; Number ; val ; obs ; _·_ ; ·-assoc ; ·-comm)
open import GaugeOrbitClasses
  using (val-++ ; square-neutral ; square-invisible ; ·-self ; ·-unit-r ; τ₀ ; τ₋ ; τ₊)

open import TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
  using (Insert ; here ; there ; Perm ; pnil ; pcons
       ; _≈_ ; ≈nil ; ≈cons ; ≈swap ; ≈trans ; ≈-refl ; permIsAnAdjacentChain)
open import PermSankramana_ThePermutationRelationIsTransitiveBecauseTwoInsertionsCommuteSoTheFourConstructorRelationIsContainedInPermAndBothAreEquivalenceRelations
  using (perm-refl ; perm-sym ; perm-trans ; ≈→Perm)
open import Ekatva_TheFirmFactorisationIsUniqueTwoPrimeListsWithOneProductAreAPermutationSoTheValuationIsWellDefinedAndPermIsExactlySameCount
  using (module Bahulya)

-- counting factors of a Number, at the corpus's own count
open Bahulya discreteℕ using (गणना ; count-perm ; perm-count)

------------------------------------------------------------------------
-- §1  `val σ` is invariant under permutation of the factor multiset.
--
-- The single computation: the swap case, which is commutativity of
-- `_·_` moved past one factor by associativity.  Everything else is
-- structural.
------------------------------------------------------------------------

swap-factors : (a b v : Bool) → a · (b · v) ≡ b · (a · v)
swap-factors a b v =
    sym (·-assoc a b v)
  ∙ cong (λ z → z · v) (·-comm a b)
  ∙ ·-assoc b a v

val-≈ : (σ : Signs) {m n : Number} → m ≈ n → val σ m ≡ val σ n
val-≈ σ ≈nil                             = refl
val-≈ σ (≈cons {p = p} e)                = cong (λ z → σ p · z) (val-≈ σ e)
val-≈ σ (≈swap {p = p} {q = q} {xs = xs}) = swap-factors (σ p) (σ q) (val σ xs)
val-≈ σ (≈trans e f)                     = val-≈ σ e ∙ val-≈ σ f

val-Perm : (σ : Signs) {m n : Number} → Perm m n → val σ m ≡ val σ n
val-Perm σ p = val-≈ σ (permIsAnAdjacentChain p)

-- The direct route, not through adjacent chains: an insertion
-- contributes exactly the inserted factor.
val-Insert : (σ : Signs) {x : ℕ} {xs ys : Number}
           → Insert x xs ys → val σ ys ≡ σ x · val σ xs
val-Insert σ here                        = refl
val-Insert σ {x = x} (there {y = y} {xs = xs} ins) =
    cong (λ z → σ y · z) (val-Insert σ ins)
  ∙ swap-factors (σ y) (σ x) (val σ xs)

val-Perm′ : (σ : Signs) {m n : Number} → Perm m n → val σ m ≡ val σ n
val-Perm′ σ pnil                     = refl
val-Perm′ σ (pcons {x = x} p ins) =
    cong (λ z → σ x · z) (val-Perm′ σ p)
  ∙ sym (val-Insert σ ins)

-- On the discrete factor type ℕ, equal counts of every factor is the
-- same as being a permutation (Ekatva), so `val` reads only the counts.
val-count : (σ : Signs) (m n : Number)
          → ((z : ℕ) → गणना z m ≡ गणना z n) → val σ m ≡ val σ n
val-count σ m n h = val-Perm σ (count-perm m n h)

-- …and conversely a permutation preserves counts, so the two
-- hypotheses are interchangeable (the direction the module needs is
-- val-count; this one records that nothing was lost).
count-of-Perm : {m n : Number} → Perm m n → (z : ℕ) → गणना z m ≡ गणना z n
count-of-Perm = perm-count

-- Rearranging a query changes no transcript at all.
obs-Perm : (σ : Signs) (qs : List Number) {m n : Number}
         → Perm m n → obs σ (m ∷ qs) ≡ obs σ (n ∷ qs)
obs-Perm σ qs p = cong (λ b → b ∷ obs σ qs) (val-Perm σ p)

------------------------------------------------------------------------
-- §2  THE FULL SQUARE-CLASS THEOREM.
--
-- GaugeOrbitClasses §7: `val σ (m ++ (k ++ k)) ≡ val σ m` for the
-- square appended at the end.  With §1 the square may sit anywhere in
-- the factor list, and the two lists need not even share a common
-- arrangement of the remaining factors.
------------------------------------------------------------------------

-- (a)  n is an arrangement of m times a square.
SquareTimes : Number → Number → Type
SquareTimes m n = Σ[ k ∈ Number ] Perm (m ++ (k ++ k)) n

square-class : (σ : Signs) (m n : Number) → SquareTimes m n → val σ m ≡ val σ n
square-class σ m n (k , p) =
    sym (square-invisible σ m k)
  ∙ val-Perm σ p

-- the same with the corpus's four-constructor relation
square-class-≈ : (σ : Signs) (m n : Number)
               → Σ[ k ∈ Number ] ((m ++ (k ++ k)) ≈ n) → val σ m ≡ val σ n
square-class-≈ σ m n (k , e) = square-class σ m n (k , ≈→Perm e)

-- (b)  m and n have a common core r, each times a square, in any
--      arrangement.  This is the symmetric form: "differ by a square".
SameSquareClass : Number → Number → Type
SameSquareClass m n =
  Σ[ r ∈ Number ] Σ[ k ∈ Number ] Σ[ k' ∈ Number ]
    (Perm (r ++ (k ++ k)) m × Perm (r ++ (k' ++ k')) n)

square-class-sym : (σ : Signs) (m n : Number)
                 → SameSquareClass m n → val σ m ≡ val σ n
square-class-sym σ m n (r , k , k' , p , q) =
    sym (square-class σ r m (k , p))
  ∙ square-class σ r n (k' , q)

-- `m ++ []` is not `m` definitionally; the permutation is by induction,
-- so no transport appears.
perm-unit-r : (m : Number) → Perm (m ++ []) m
perm-unit-r []      = pnil
perm-unit-r (x ∷ m) = pcons (perm-unit-r m) here

SameSquareClass-refl : (m : Number) → SameSquareClass m m
SameSquareClass-refl m =
  m , [] , [] , perm-unit-r m , perm-unit-r m

SameSquareClass-sym : (m n : Number) → SameSquareClass m n → SameSquareClass n m
SameSquareClass-sym m n (r , k , k' , p , q) = r , k' , k , q , p

-- SquareTimes is contained in SameSquareClass (take r = m, k' = []).
SquareTimes⊂SameSquareClass : (m n : Number) → SquareTimes m n → SameSquareClass m n
SquareTimes⊂SameSquareClass m n (k , p) =
  m , [] , k , perm-unit-r m , p

-- (c)  The classical form: m ~ n iff m · n is a square.  Since {±1}
--      has exponent 2 this is exactly what a character can see.
ProductIsSquare : Number → Number → Type
ProductIsSquare m n = Σ[ k ∈ Number ] Perm (m ++ n) (k ++ k)

·-cancel : (a b : Bool) → a · b ≡ true → a ≡ b
·-cancel true  true  _ = refl
·-cancel true  false e = sym e
·-cancel false true  e = e
·-cancel false false _ = refl

square-class-prod : (σ : Signs) (m n : Number)
                  → ProductIsSquare m n → val σ m ≡ val σ n
square-class-prod σ m n (k , p) =
  ·-cancel (val σ m) (val σ n)
    ( sym (val-++ σ m n)
    ∙ val-Perm σ p
    ∙ square-neutral σ k )

-- Replacing a query by any member of its square class splits no
-- observable class — GaugeOrbitClasses.square-adds-no-class with the
-- square in any arrangement and the base query allowed to move too.
square-class-adds-no-class : (qs : List Number) (m n : Number) (σ σ' : Signs)
                           → SameSquareClass m n
                           → obs σ (m ∷ qs) ≡ obs σ' (m ∷ qs)
                           → obs σ (n ∷ qs) ≡ obs σ' (n ∷ qs)
square-class-adds-no-class qs m n σ σ' c e =
    cong₂ _∷_ (sym (square-class-sym σ m n c)) refl
  ∙ e
  ∙ cong₂ _∷_ (square-class-sym σ' m n c) refl

------------------------------------------------------------------------
-- §3  A checked instance.
--
-- p₀p₁p₀ is an arrangement of p₁ · p₀², with the square NOT at the end:
-- exactly the case §7 of GaugeOrbitClasses could not reach.  At the
-- module's own τ₀ (flip p₀ only) and τ₋ (flip everything), val agrees
-- on p₁ and on p₀p₁p₀, by the theorem — and the same equation is
-- `refl`, so the theorem is checked against the computation.
------------------------------------------------------------------------

p₁ : Number
p₁ = 1 ∷ []

p₀p₁p₀ : Number
p₀p₁p₀ = 0 ∷ 1 ∷ 0 ∷ []

-- p₀p₁p₀ is a rearrangement of p₁ ++ (p₀ ++ p₀) = p₁p₀p₀
p₀p₁p₀-is-p₁-times-a-square : SquareTimes p₁ p₀p₁p₀
p₀p₁p₀-is-p₁-times-a-square =
  (0 ∷ []) , pcons (perm-refl (0 ∷ 0 ∷ [])) (there here)

instance-τ₀ : val τ₀ p₁ ≡ val τ₀ p₀p₁p₀
instance-τ₀ = square-class τ₀ p₁ p₀p₁p₀ p₀p₁p₀-is-p₁-times-a-square

instance-τ₋ : val τ₋ p₁ ≡ val τ₋ p₀p₁p₀
instance-τ₋ = square-class τ₋ p₁ p₀p₁p₀ p₀p₁p₀-is-p₁-times-a-square

instance-τ₀-refl : val τ₀ p₁ ≡ val τ₀ p₀p₁p₀
instance-τ₀-refl = refl

instance-τ₋-refl : val τ₋ p₁ ≡ val τ₋ p₀p₁p₀
instance-τ₋-refl = refl

-- and by the count criterion: every factor has the same count in
-- p₁p₀p₀ and in p₀p₁p₀, so val agrees, for every σ at once.
instance-count : (σ : Signs) → val σ (1 ∷ 0 ∷ 0 ∷ []) ≡ val σ p₀p₁p₀
instance-count σ =
  val-count σ (1 ∷ 0 ∷ 0 ∷ []) p₀p₁p₀
    (perm-count (pcons (perm-refl (0 ∷ 0 ∷ [])) (there here)))
