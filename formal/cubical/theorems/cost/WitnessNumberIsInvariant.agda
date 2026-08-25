{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WitnessNumberIsInvariant
--
-- The standing लाघव thread asks for a measure on presentations stable
-- under अनुवृत्ति / प्रत्याहार / अपवाद.  `Laghava` answered the question
-- it was asked and the answer was no:
--
--     laghava-is-not-semantic :
--       ¬ Σ[ f ∈ (Denotation → ℕ) ] ((e : Expr) → f (eval e) ≡ size e)
--
-- size lives on the presentation, and univalence discards presentations.
--
-- This module records that the deflationary thread produced a measure
-- that DOES survive, and says exactly why the two differ.
--
-- ────────────────────────────────────────────────────────────────────
-- THE MEASURE
--
-- `WitnessNumberIsTwo` fixes it: an absence is measured by the least
-- list of points on which no decoder survives.  Unlike `size`, that
-- quantity is not read off a syntax — it is a property of the pair
-- (decoder space, law).  So:
--
--   §1  it is a `subst` away from being transported along ANY path of
--       decoder systems, hence a univalent invariant by construction;
--   §3  it is PRESERVED by every reindexing of the decoder space, with
--       no hypothesis at all;
--   §4  and REFLECTED by surjective ones — so it depends only on the
--       image, which is the precise sense in which it is not a
--       presentation-level quantity.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY LAGHAVA FAILS AND THIS DOES NOT
--
-- Both are "sizes".  The difference is the direction of the quantifier.
--
--   size    is a function OUT OF the presentation.  Two presentations
--           with one denotation get two values, so no function on
--           denotations reproduces it — `Laghava.laghava-collision` is
--           the pair, and it is a collision in the sense of §4 of
--           `WitnessNumberIsTwo`.
--
--   witness number  is a quantification OVER the decoder space.  Any
--           reindexing feeds the same laws to the same points, so the
--           value cannot move.
--
-- A measure defined by ∀ over a space is invariant under maps into that
-- space; a measure defined by a function out of a space is not.  That is
-- the whole content, and it is why the लाघव answer was no and this one
-- is yes without either being surprising once stated.
--
-- ────────────────────────────────────────────────────────────────────
-- NOT CLAIMED
--
-- That witness number is a substitute for लाघव.  It measures ABSENCES,
-- not presentations, and the लाघव question — is there a stable measure
-- of presentation economy — is still answered no by `Laghava`.  What is
-- claimed is narrower: the deflationary thread's measure is invariant,
-- the economy thread's is not, and the reason is structural rather than
-- accidental.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module WitnessNumberIsInvariant where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; invEq ; equivFun ; secEq)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥ ; isProp⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Relation.Nullary.Properties using (isProp¬)
open import Cubical.Functions.Surjection using (isSurjection)
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁)

open import WitnessNumberIsTwo using (AllHold ; Refutes)

private
  variable
    ℓd ℓd' ℓx ℓ : Level

------------------------------------------------------------------------
-- 1.  A decoder system, and transport along paths of them
------------------------------------------------------------------------

DecoderSystem : (X : Type ℓx) (ℓd ℓ : Level) → Type (ℓ-max ℓx (ℓ-max (ℓ-suc ℓd) (ℓ-suc ℓ)))
DecoderSystem X ℓd ℓ = Σ[ D ∈ Type ℓd ] (D → X → Type ℓ)

RefutesS : {X : Type ℓx} → DecoderSystem X ℓd ℓ → List X → Type (ℓ-max ℓd ℓ)
RefutesS (D , law) xs = (d : D) → ¬ AllHold law d xs

-- univalent invariance, by construction: refutation is a property of the
-- system, so it moves along any path of systems
refutes-transport :
  {X : Type ℓx} (S T : DecoderSystem X ℓd ℓ) → S ≡ T
  → (xs : List X) → RefutesS S xs → RefutesS T xs
refutes-transport S T p xs = subst (λ Z → RefutesS Z xs) p

------------------------------------------------------------------------
-- 2.  Reindexing the decoder space, on the nose
--
-- `AllHold` recurses on the list, so at a variable list neither side
-- reduces and the two readings must be related by an induction rather
-- than by definitional equality.  Both directions are the same three
-- lines.
------------------------------------------------------------------------

reindex : {D : Type ℓd} {D' : Type ℓd'} {X : Type ℓx}
        → (D' → D) → (D → X → Type ℓ) → (D' → X → Type ℓ)
reindex f law d' = law (f d')

allHold-out : {D : Type ℓd} {D' : Type ℓd'} {X : Type ℓx}
              (f : D' → D) (law : D → X → Type ℓ) (d' : D') (xs : List X)
            → AllHold (reindex f law) d' xs → AllHold law (f d') xs
allHold-out f law d' []       h = h
allHold-out f law d' (x ∷ xs) h = h .fst , allHold-out f law d' xs (h .snd)

allHold-in : {D : Type ℓd} {D' : Type ℓd'} {X : Type ℓx}
             (f : D' → D) (law : D → X → Type ℓ) (d' : D') (xs : List X)
           → AllHold law (f d') xs → AllHold (reindex f law) d' xs
allHold-in f law d' []       h = h
allHold-in f law d' (x ∷ xs) h = h .fst , allHold-in f law d' xs (h .snd)

------------------------------------------------------------------------
-- 3.  PRESERVED by every reindexing, with no hypothesis
------------------------------------------------------------------------

refutes-reindex :
  {D : Type ℓd} {D' : Type ℓd'} {X : Type ℓx}
  (f : D' → D) (law : D → X → Type ℓ) (xs : List X)
  → Refutes law xs → Refutes (reindex f law) xs
refutes-reindex f law xs ref d' h = ref (f d') (allHold-out f law d' xs h)

------------------------------------------------------------------------
-- 4.  REFLECTED by surjective ones — it depends only on the image
------------------------------------------------------------------------

refutes-reflect :
  {D : Type ℓd} {D' : Type ℓd'} {X : Type ℓx}
  (f : D' → D) → isSurjection f
  → (law : D → X → Type ℓ) (xs : List X)
  → Refutes (reindex f law) xs → Refutes law xs
refutes-reflect f surj law xs ref d h =
  PT.rec isProp⊥
         (λ fib → ref (fib .fst)
                    (allHold-in f law (fib .fst) xs
                      (subst (λ z → AllHold law z xs) (sym (fib .snd)) h)))
         (surj d)

------------------------------------------------------------------------
-- 5.  Equivalences are the special case, both directions
------------------------------------------------------------------------

equiv→surj : {D : Type ℓd} {D' : Type ℓd'} (e : D' ≃ D) → isSurjection (equivFun e)
equiv→surj e d = PT.∣ invEq e d , secEq e d ∣₁

refutes-≃ :
  {D : Type ℓd} {D' : Type ℓd'} {X : Type ℓx}
  (e : D' ≃ D) (law : D → X → Type ℓ) (xs : List X)
  → Refutes law xs → Refutes (reindex (equivFun e) law) xs
refutes-≃ e law xs = refutes-reindex (equivFun e) law xs

refutes-≃-back :
  {D : Type ℓd} {D' : Type ℓd'} {X : Type ℓx}
  (e : D' ≃ D) (law : D → X → Type ℓ) (xs : List X)
  → Refutes (reindex (equivFun e) law) xs → Refutes law xs
refutes-≃-back e law xs = refutes-reflect (equivFun e) (equiv→surj e) law xs

------------------------------------------------------------------------
-- 6.  The contrast, side by side.
--
--   Laghava.laghava-is-not-semantic
--       ¬ Σ[ f ∈ (Denotation → ℕ) ] ((e : Expr) → f (eval e) ≡ size e)
--   here §3, §4
--       Refutes law xs is preserved by every reindexing of the decoder
--       space and reflected by every surjection onto it
--
-- A measure defined by ∀ over a space is invariant under maps into that
-- space.  A measure defined by a function out of a space is not.
------------------------------------------------------------------------
