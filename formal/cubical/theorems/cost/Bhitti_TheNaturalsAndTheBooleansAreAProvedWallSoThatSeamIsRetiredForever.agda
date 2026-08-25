{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भित्तिः — a wall.  The first ford-graph receipt of the SECOND kind.
--
-- THE ECONOMY HAS TWO ASSETS AND THE LOOP ONLY MINTS ONE.  A ford is a
-- landed equivalence; it creates m×n free crossings between the components
-- it joins.  A WALL is a proved ¬(A ≃ B); it creates none, and it retires a
-- candidate merge PERMANENTLY, which is worth almost as much and costs far
-- less.  तपस् template-matches for fords and can never produce a wall.
-- `README.md:172` already states the end state — "full connectivity is
-- refuted forever (¬(Unit ≃ Bool), seven walls): many nets with proved
-- boundaries, anekāntavāda as network topology" — but the walls are not in
-- crossing from an impossible one.
--
-- THIS WALL, and why this one.  On the snapshot (111 fords, 137 banks, 48
-- components) the two largest components are headed by `Bool` (8 banks) and
-- by `ℕ`/`ℕ × ℕ` — 6 and 7 banks, joined into 13 by
-- `SetuYugma_…AndVivekaIsTheNaturalNumbers`.  So `ℕ ≃ Bool` is the single
-- largest candidate merge in the corpus, 13 × 8 = 104 crossings.  It is
-- impossible, and this file says so with a term.  Those 104 leave the
-- candidate set for good.
--
-- Corrects my own claim of an hour ago, already struck in
-- `collab/journals/opus-mira.md`: I priced the graph as if any two
-- components could be joined for the cost of one edge.  They cannot.  The
-- ceiling is not the complete graph; it is the sum over GENUINE equivalence
-- classes, and sorting the ~47 candidate merges into fords and walls is the
-- actual open work.
--
-- The mathematics is elementary and classical (a finite type is not
-- equivalent to ℕ; pigeonhole).  No source is claimed for it.  भित्ति is
-- ordinary Sanskrit for a wall; the usage is the corpus's own ("seven
-- walls"); the compound is built here, 2026-08-22.
------------------------------------------------------------------------

module Bhitti_TheNaturalsAndTheBooleansAreAProvedWallSoThatSeamIsRetiredForever where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq ; retEq)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; injSuc ; znots)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)

------------------------------------------------------------------------
-- १ · कोष्ठकन्याय — the pigeonhole, at its smallest: of any three booleans,
-- two agree.  Eight cases, each `refl`.
------------------------------------------------------------------------

त्रयाणां-द्वौ : (a b c : Bool) → (a ≡ b) ⊎ ((a ≡ c) ⊎ (b ≡ c))
त्रयाणां-द्वौ true  true  _     = inl refl
त्रयाणां-द्वौ false false _     = inl refl
त्रयाणां-द्वौ true  false true  = inr (inl refl)
त्रयाणां-द्वौ false true  false = inr (inl refl)
त्रयाणां-द्वौ true  false false = inr (inr refl)
त्रयाणां-द्वौ false true  true  = inr (inr refl)

------------------------------------------------------------------------
-- २ · An equivalence is injective: its retraction carries the collision back.
------------------------------------------------------------------------

अभेद : {A B : Type} (e : A ≃ B) {x y : A} → equivFun e x ≡ equivFun e y → x ≡ y
अभेद e {x} {y} p = sym (retEq e x) ∙ cong (invEq e) p ∙ retEq e y

------------------------------------------------------------------------
-- ३ · भित्तिः — ℕ ≄ Bool.  Three naturals, two booleans; the collision the
-- pigeonhole forces is undone by injectivity into a false equation on ℕ.
------------------------------------------------------------------------

भित्तिः : (ℕ ≃ Bool) → ⊥
भित्तिः e with त्रयाणां-द्वौ (equivFun e 0) (equivFun e 1) (equivFun e 2)
... | inl p       = znots (अभेद e p)                    -- 0 ≡ 1
... | inr (inl p) = znots (अभेद e p)                    -- 0 ≡ 2
... | inr (inr p) = znots (injSuc (अभेद e p))           -- 1 ≡ 2, so 0 ≡ 1

------------------------------------------------------------------------
-- ४ · The graph statement.  Recorded as a comment because the ford graph
-- is data and not a type: the pair (⟨lib⟩.ℕ, ⟨lib⟩.Bool) is now a WALL and
-- must never again be counted as an unminted seam.  Suggested row shape for
--
--     wallId                        bankA        bankB
--     Bhitti_…ForEver.भित्तिः        ⟨lib⟩.ℕ      ⟨lib⟩.Bool
--
-- 13 × 8 = 104 crossings retired.  Not lost — they were never available.
------------------------------------------------------------------------
