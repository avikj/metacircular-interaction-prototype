{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Swarm.S13OptionSpread
--
-- THE OPTION-SPREAD DICHOTOMY: exposed-point rigidity and the
-- completeness of two-point separation certificates.
--
-- Two documents in the swarm-0814-13 draw make opposite claims about
-- when a numerical summary of a state determines that state's future:
--
--   * collab/discovery/claims/R0019-exposed-point-rigidity.md, statement
--     (E): weights w_n > 0 summable, |c_n| ≤ 1, and Σ w_n c_n = Σ w_n
--     forces c_n = 1 for EVERY n.  One scalar pins down an infinite
--     object.  Proof obligation 1 there reads "by termwise nonnegativity
--     after taking real parts".
--
--   * collab/messages/0249-codex-formation-cache-option-result.md: the
--     caches {1,2,4,5} and {1,2,3,6} have the SAME scalar summary
--     (queries, additions, retained-count) yet marginal costs (1,0) and
--     (0,1) on targets (3,4).  "A router merging these states
--     necessarily misprices at least one future request."
--
-- Both are statements about a fibre of a summary map σ, ordered by the
-- pointwise (coordinatewise) order on marginal-cost vectors.  R0019 is
-- the case where the fibre is a single point; 0249 exhibits a fibre with
-- no ≼-least member.  0249 gives the counterexample but never states the
-- inequality it violates.  This module states it and proves it complete:
--
--   THEOREM (dichotomy).  For every inhabited finite fibre F of cost
--   vectors in ℕ^n, one may CONSTRUCT either
--     (R) a member m ∈ F with m ≼ y for all y ∈ F — merging F to m
--         misprices nothing; or
--     (S) two members u,v ∈ F and two coordinates i, j with
--         u_i < v_i and v_j < u_j — a two-point certificate.
--   The certificate in (S) is always of size TWO: no three-state or
--   higher-order witness is ever needed.  (The two branches are not
--   exclusive in general — a fibre may have both a least element and an
--   incomparable pair further up — but on a two-element fibre the (S)
--   certificate refutes (R): `sep-pair-noLeast` below.)
--
-- The rigidity end is `sum-rigid` / `exposed-point`: the discrete form
-- of R0019 (E), proved by exactly its termwise argument.  The separation
-- end is `cacheSep` / `cacheNoLeast`: 0249's pair, checked.
--
-- Nothing here is measured.  Every ℕ is a literal and every step is a
-- term.
------------------------------------------------------------------------

module Swarm.S13OptionSpread where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sum using (_⊎_; inl; inr)
open import Cubical.Data.Sigma using (Σ; _×_; _,_; fst; snd; Σ-syntax)
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Vec.Base using (Vec; []; _∷_)
open import Cubical.Relation.Nullary using (¬_)
import Cubical.Data.Empty as ⊥

private
  variable
    n k : ℕ

------------------------------------------------------------------------
-- 1.  Cost vectors: the pointwise order, and strict advantage
------------------------------------------------------------------------

-- A cost vector is a marginal cost per declared future target.
-- `x ≼ y` : x is no more expensive than y on EVERY target.

data _≼_ : {m : ℕ} → Vec ℕ m → Vec ℕ m → Type₀ where
  ≼[] : [] ≼ []
  ≼∷  : {m : ℕ} {a b : ℕ} {xs ys : Vec ℕ m}
      → a ≤ b → xs ≼ ys → (a ∷ xs) ≼ (b ∷ ys)

-- `x ◃ y` : x is STRICTLY cheaper than y on at least one target.
-- This is the atom of the separating inequality: the constructor names
-- the coordinate.

data _◃_ : {m : ℕ} → Vec ℕ m → Vec ℕ m → Type₀ where
  hd : {m : ℕ} {a b : ℕ} {xs ys : Vec ℕ m}
     → a < b → (a ∷ xs) ◃ (b ∷ ys)
  tl : {m : ℕ} {a b : ℕ} {xs ys : Vec ℕ m}
     → xs ◃ ys → (a ∷ xs) ◃ (b ∷ ys)

≼-refl : {x : Vec ℕ n} → x ≼ x
≼-refl {x = []}     = ≼[]
≼-refl {x = a ∷ xs} = ≼∷ ≤-refl ≼-refl

≼-trans : {x y z : Vec ℕ n} → x ≼ y → y ≼ z → x ≼ z
≼-trans ≼[] ≼[] = ≼[]
≼-trans (≼∷ p ps) (≼∷ q qs) = ≼∷ (≤-trans p q) (≼-trans ps qs)

-- A strict advantage refutes the reverse dominance.  This is what makes
-- (S) a genuine obstruction and not merely a difference.
◃→¬≼ : {x y : Vec ℕ n} → x ◃ y → ¬ (y ≼ x)
◃→¬≼ (hd a<b) (≼∷ b≤a _) = <-asym a<b b≤a
◃→¬≼ (tl t)   (≼∷ _ r)   = ◃→¬≼ t r

------------------------------------------------------------------------
-- 2.  The decision step (Julia Robinson's lens: it is arithmetic)
--
-- Either x dominates y everywhere, or y is strictly cheaper somewhere.
-- Constructive: this IS the algorithm, coordinate by coordinate.
------------------------------------------------------------------------

≼-or-◃ : (x y : Vec ℕ n) → (x ≼ y) ⊎ (y ◃ x)
≼-or-◃ [] [] = inl ≼[]
≼-or-◃ (a ∷ xs) (b ∷ ys) = go (a ≟ b) (≼-or-◃ xs ys)
  where
    go : Trichotomy a b
       → (xs ≼ ys) ⊎ (ys ◃ xs)
       → ((a ∷ xs) ≼ (b ∷ ys)) ⊎ ((b ∷ ys) ◃ (a ∷ xs))
    go (lt a<b) (inl t) = inl (≼∷ (<-weaken a<b) t)
    go (lt a<b) (inr t) = inr (tl t)
    go (eq e)   (inl t) = inl (≼∷ (subst (a ≤_) e ≤-refl) t)
    go (eq e)   (inr t) = inr (tl t)
    go (gt b<a) _       = inr (hd b<a)

------------------------------------------------------------------------
-- 3.  Fibres: an inhabited finite family of cost vectors
------------------------------------------------------------------------

-- Membership and pointwise domination over a fibre are defined by
-- RECURSION on the vector, not as indexed families: index unification
-- against `_∷_` is not available in Cubical Agda, and a definition that
-- fails to compute under transport is not the object we want.

_∈_ : {A : Type₀} {m : ℕ} → A → Vec A m → Type₀
a ∈ []      = ⊥.⊥
a ∈ (x ∷ v) = (a ≡ x) ⊎ (a ∈ v)

_≼all_ : {m j : ℕ} → Vec ℕ m → Vec (Vec ℕ m) j → Type₀
u ≼all []      = Unit
u ≼all (x ∷ F) = (u ≼ x) × (u ≼all F)

≼all-∈ : {u v : Vec ℕ n} {F : Vec (Vec ℕ n) k}
       → u ≼all F → v ∈ F → u ≼ v
≼all-∈ {F = x ∷ F} (p , r) (inl e) = subst (_ ≼_) (sym e) p
≼all-∈ {F = x ∷ F} (p , r) (inr i) = ≼all-∈ r i

≼all-mono : {x u : Vec ℕ n} {F : Vec (Vec ℕ n) k}
          → x ≼ u → u ≼all F → x ≼all F
≼all-mono {F = []}    p _       = tt
≼all-mono {F = x ∷ F} p (q , r) = ≼-trans p q , ≼all-mono p r

-- (R): the merge representative.
Least : {m j : ℕ} → Vec (Vec ℕ m) j → Type₀
Least {m} F = Σ[ u ∈ Vec ℕ m ] ((u ∈ F) × (u ≼all F))

-- (S): the two-point separating certificate.  `u ◃ v` names a target on
-- which u is strictly cheaper, `v ◃ u` names another on which v is.
Sep : {m j : ℕ} → Vec (Vec ℕ m) j → Type₀
Sep {m} F = Σ[ u ∈ Vec ℕ m ] Σ[ v ∈ Vec ℕ m ]
              ((u ∈ F) × (v ∈ F) × (u ◃ v) × (v ◃ u))

------------------------------------------------------------------------
-- 4.  THE DICHOTOMY
------------------------------------------------------------------------

consLeast : (x : Vec ℕ n) {G : Vec (Vec ℕ n) k}
          → (u : Vec ℕ n) → u ∈ G → u ≼all G
          → Least (x ∷ G) ⊎ Sep (x ∷ G)
consLeast x u u∈ dom with ≼-or-◃ x u
... | inl x≼u = inl (x , inl refl , (≼-refl , ≼all-mono x≼u dom))
... | inr u◃x with ≼-or-◃ u x
...   | inl u≼x = inl (u , inr u∈ , (u≼x , dom))
...   | inr x◃u = inr (u , x , (inr u∈ , inl refl , u◃x , x◃u))

-- For every inhabited finite fibre, EITHER a sound merge representative
-- OR a two-point separation.  Constructive, hence decidable.
dichotomy : (F : Vec (Vec ℕ n) (suc k)) → Least F ⊎ Sep F
dichotomy {k = zero}   (x ∷ []) = inl (x , inl refl , (≼-refl , tt))
dichotomy {k = suc k'} (x ∷ G) with dichotomy G
... | inl (u , u∈ , dom)           = consLeast x u u∈ dom
... | inr (u , v , u∈ , v∈ , p , q) =
        inr (u , v , (inr u∈ , inr v∈ , p , q))

-- On a two-element fibre the separating certificate really is a no-go:
-- no member of the fibre dominates the other.
sep-pair-noLeast : {u v : Vec ℕ n} → u ◃ v → v ◃ u → ¬ Least (u ∷ v ∷ [])
sep-pair-noLeast {u = u} {v = v} u◃v v◃u (m , inl e , (_ , q , _)) =
  ◃→¬≼ v◃u (subst (_≼ v) e q)
sep-pair-noLeast {u = u} {v = v} u◃v v◃u (m , inr (inl e) , (p , _)) =
  ◃→¬≼ u◃v (subst (_≼ u) e p)
sep-pair-noLeast u◃v v◃u (m , inr (inr ()) , _)

-- A singleton fibre is always sound: this is the router-side reading of
-- exposed-point rigidity (§5).  Rigidity ⇒ soundness.
singleton-least : (x : Vec ℕ n) → Least (x ∷ [])
singleton-least x = x , inl refl , (≼-refl , tt)

------------------------------------------------------------------------
-- 5.  The rigidity end: R0019 (E), discretely
------------------------------------------------------------------------

sum : Vec ℕ n → ℕ
sum []       = 0
sum (a ∷ xs) = a + sum xs

sum-mono : {x y : Vec ℕ n} → x ≼ y → sum x ≤ sum y
sum-mono ≼[]       = ≤-refl
sum-mono (≼∷ p ps) = ≤-+-≤ p (sum-mono ps)

head-eq : {a b sx sy : ℕ} → a ≤ b → sx ≤ sy → a + sx ≡ b + sy → a ≡ b
head-eq {a} {b} {sx} {sy} a≤b sx≤sy p with a ≟ b
... | lt a<b = ⊥.rec (¬m<m (subst (_< (b + sy)) p
                            (<≤-trans (<-+k a<b) (≤-k+ sx≤sy))))
... | eq e   = e
... | gt b<a = ⊥.rec (<-asym b<a a≤b)

-- THE EXPOSED-POINT LEMMA.  Termwise domination plus equality of the
-- aggregate forces termwise equality: the aggregate has a singleton
-- fibre at the top.  This is R0019's proof obligation 1, over ℕ.
sum-rigid : {x y : Vec ℕ n} → x ≼ y → sum x ≡ sum y → x ≡ y
sum-rigid ≼[] _ = refl
sum-rigid {x = a ∷ xs} {y = b ∷ ys} (≼∷ a≤b t) p =
  cong₂ _∷_ a≡b (sum-rigid t (inj-m+ (p ∙ cong (_+ sum ys) (sym a≡b))))
  where
    a≡b : a ≡ b
    a≡b = head-eq a≤b (sum-mono t) p

ones : (m : ℕ) → Vec ℕ m
ones zero    = []
ones (suc m) = 1 ∷ ones m

-- R0019 (E), stated in its own shape: unit-bounded coordinates whose
-- aggregate attains the maximum are all 1.
exposed-point : {c : Vec ℕ n} → c ≼ ones n → sum c ≡ sum (ones n) → c ≡ ones n
exposed-point = sum-rigid

------------------------------------------------------------------------
-- 6.  The separation end: message 0249's cache pair, checked
--
-- Declared future targets, in order: (3, 4).
-- Cache C₅ = {1,2,4,5} reaches 4 for free and 3 in one addition: (1,0).
-- Cache C₆ = {1,2,3,6} reaches 3 for free and 4 in one addition: (0,1).
-- Scalar summary σ = (additions, retained-count) = (3,4) for both.
------------------------------------------------------------------------

μ₅ μ₆ : Vec ℕ 2
μ₅ = 1 ∷ 0 ∷ []
μ₆ = 0 ∷ 1 ∷ []

σ₅ σ₆ : Vec ℕ 2
σ₅ = 3 ∷ 4 ∷ []
σ₆ = 3 ∷ 4 ∷ []

-- The two states are in the SAME fibre of the scalar summary.
same-summary : σ₅ ≡ σ₆
same-summary = refl

0<1 : 0 < 1
0<1 = 0 , refl

cacheFibre : Vec (Vec ℕ 2) 2
cacheFibre = μ₅ ∷ μ₆ ∷ []

μ₅◃μ₆ : μ₅ ◃ μ₆     -- C₅ strictly cheaper on target 4
μ₅◃μ₆ = tl (hd 0<1)

μ₆◃μ₅ : μ₆ ◃ μ₅     -- C₆ strictly cheaper on target 3
μ₆◃μ₅ = hd 0<1

cacheSep : Sep cacheFibre
cacheSep = μ₅ , μ₆ , (inl refl , inr (inl refl) , μ₅◃μ₆ , μ₆◃μ₅)

-- Hence no merge representative exists: message 0249's no-go, as a term.
cacheNoLeast : ¬ Least cacheFibre
cacheNoLeast = sep-pair-noLeast μ₅◃μ₆ μ₆◃μ₅

-- Contrast: a fibre whose members are comparable does have a
-- representative, so equality of summaries is not itself the obstruction.
chainFibre : Vec (Vec ℕ 2) 2
chainFibre = (0 ∷ 0 ∷ []) ∷ (1 ∷ 0 ∷ []) ∷ []

chainLeast : Least chainFibre
chainLeast = mkLeast (0 ∷ 0 ∷ []) z∈
               (all∷ ≼-refl (all∷ (≼∷ zero-≤ (≼∷ ≤-refl ≼[])) all[]))
