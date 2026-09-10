{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- Perm-सङ्क्रमणम् — the transitivity `TheConverseContainmentReducesTo
-- PermTransitivity…` left as a hypothesis.
--
-- That module said, exactly: "Transitivity of `Perm` is NOT proved and
-- NOT refuted — it is true and standard … it needs an exchange lemma
-- moving an `Insert` past a `Perm`, which is NOT written here and is
-- NOT assumed to be hard."  Here is the exchange lemma, and it rests on
-- one fact: two insertions commute.  Nothing about the element type is
-- assumed — no decidable equality, no set-ness.
--
--   १  insert-comm : Insert y vs ws → Insert x us vs
--                    → Σ ts. Insert x ts ws × Insert y us ts
--   २  exchange    : Insert x ys zs → Perm zs ws
--                    → Σ ws'. Insert x ws' ws × Perm ys ws'
--   ३  perm-trans  : Perm xs ys → Perm ys zs → Perm xs zs
--   ४  ≈→Perm      : the four-constructor relation is contained in Perm,
--                    the converse of `permIsAnAdjacentChain`; so the two
--                    relations are logically the same.
--   ५  both are equivalence relations: refl, sym, trans for each.
--
-- CHECKED at the pin.  Agda warns `UnsupportedIndexedMatch` on
-- `insert-comm` and `exchange`: the clauses rely on injectivity of `_∷_`
-- in an indexed match, so those two functions will not COMPUTE on
-- transports.  They type-check; the relations are used only logically
-- here, as in the corpus's other modules that carry the same warning.
--
-- With `Ekatva_…` (which adds decidable equality and gets "same count of
-- every element"), the three presentations of "same list up to order" in
-- the corpus are now one relation.
------------------------------------------------------------------------
module PermSankramana_ThePermutationRelationIsTransitiveBecauseTwoInsertionsCommuteSoTheFourConstructorRelationIsContainedInPermAndBothAreEquivalenceRelations where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)

open import TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
  using (Insert ; here ; there ; Perm ; pnil ; pcons ; _≈_ ; ≈nil ; ≈cons ; ≈swap ; ≈trans
        ; ≈-refl ; permIsAnAdjacentChain)

module _ {A : Type} where

  -- १ · two insertions commute
  insert-comm : {x y : A} {us vs ws : List A}
              → Insert y vs ws → Insert x us vs
              → Σ[ ts ∈ List A ] (Insert x ts ws × Insert y us ts)
  insert-comm {x} {y} {us} here ins = (y ∷ us) , there ins , here
  insert-comm (there ins₁) here = _ , here , ins₁
  insert-comm (there {y = z} ins₁) (there ins₂) =
    let (ts₀ , insx , insy) = insert-comm ins₁ ins₂
    in  (z ∷ ts₀) , there insx , there insy

  -- २ · an insertion moves past a Perm
  exchange : {x : A} {ys zs ws : List A}
           → Insert x ys zs → Perm zs ws
           → Σ[ ws' ∈ List A ] (Insert x ws' ws × Perm ys ws')
  exchange here        (pcons p ins') = _ , ins' , p
  exchange (there ins) (pcons p ins') =
    let (ws₀' , insx , rest) = exchange ins p
        (ts , insx' , insy)  = insert-comm ins' insx
    in  ts , insx' , pcons rest insy

  -- ३ · transitivity
  perm-trans : {xs ys zs : List A} → Perm xs ys → Perm ys zs → Perm xs zs
  perm-trans pnil          q = q
  perm-trans (pcons p ins) q =
    let (zs' , ins' , p') = exchange ins q
    in  pcons (perm-trans p p') ins'

  -- ४ · the four-constructor relation is contained in Perm
  perm-refl : (xs : List A) → Perm xs xs
  perm-refl []       = pnil
  perm-refl (x ∷ xs) = pcons (perm-refl xs) here

  perm-swap : (p q : A) (xs : List A) → Perm (p ∷ q ∷ xs) (q ∷ p ∷ xs)
  perm-swap p q xs = pcons (perm-refl (q ∷ xs)) (there here)

  ≈→Perm : {xs ys : List A} → xs ≈ ys → Perm xs ys
  ≈→Perm ≈nil                          = pnil
  ≈→Perm (≈cons h)                     = pcons (≈→Perm h) here
  ≈→Perm (≈swap {p = p} {q = q} {xs = xs}) = perm-swap p q xs
  ≈→Perm (≈trans h k)                  = perm-trans (≈→Perm h) (≈→Perm k)

  Perm→≈ : {xs ys : List A} → Perm xs ys → xs ≈ ys
  Perm→≈ = permIsAnAdjacentChain

  -- ५ · both are equivalence relations
  ≈-sym : {xs ys : List A} → xs ≈ ys → ys ≈ xs
  ≈-sym ≈nil         = ≈nil
  ≈-sym (≈cons h)    = ≈cons (≈-sym h)
  ≈-sym ≈swap        = ≈swap
  ≈-sym (≈trans h k) = ≈trans (≈-sym k) (≈-sym h)

  perm-sym : {xs ys : List A} → Perm xs ys → Perm ys xs
  perm-sym p = ≈→Perm (≈-sym (Perm→≈ p))

  ≈-trans : {xs ys zs : List A} → xs ≈ ys → ys ≈ zs → xs ≈ zs
  ≈-trans = ≈trans
