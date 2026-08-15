{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ObsBridge
--
-- `एकीकरण ≠ समानता;  एकीकरण = भेदरक्षित अनुवादजालम्`
--
-- `notes/DUPLICATION_LEDGER.md` recorded my `ObstructionCalculus.Obs` as a
-- duplicate of `ChuAdvance.Obs` and named a refactor that would delete one of
-- them.  On inspection that verdict was wrong, and the correction is more
-- interesting than the error:
--
--   ChuAdvance.Obs X T  =  X → T → Bool          -- Bool-valued, finite tests
--   ObstructionCalculus.Obs X V                  -- V-valued, indexed family
--
-- Neither subsumes the other.  Bool-valuedness is what makes
-- `Shrink(𝒯) ⇒ δ↓` statable over a finite test list; arbitrary `V` is what
-- lets the sign defect be read by `absℤ` and the identity, which are ℤ-valued
-- and not predicates.  They are two generalizations of one notion along
-- different axes.
--
-- So the right response is not deletion.  It is the map, with the theorem that
-- the map preserves exactly what both sides are for: **the two presentations
-- separate the same pairs.**  Deleting either would have destroyed a
-- distinction in the name of removing a synonym -- which is the failure this
-- whole stratum exists to name.
--
-- `विवाद = सम्भावित ज्ञानहोलोनॉमी`.  Two presentations disagreed; the response
-- is to measure the map between them, not to erase one.
------------------------------------------------------------------------

module NaturalMachine.ObsBridge where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

open import NaturalMachine.ObstructionCalculus using (Obs ; Sep)
open import NaturalMachine.ChuAdvance using () renaming (Obs to ChuObs)

open Obs

private
  variable
    X V : Type₀

------------------------------------------------------------------------
-- A.  The reflection.

decBool : {A : Type₀} → Dec A → Bool
decBool (yes _) = true
decBool (no _) = false

decBool-refl : (dec : Discrete V) (v : V) → decBool (dec v v) ≡ true
decBool-refl dec v with dec v v
... | yes _ = refl
... | no ¬p = Empty.rec (¬p refl)

decBool-neq : (dec : Discrete V) (u v : V) → ¬ (u ≡ v)
            → decBool (dec u v) ≡ false
decBool-neq dec u v ne with dec u v
... | yes p = Empty.rec (ne p)
... | no _ = refl

-- A `V`-valued field becomes a Chu space whose tests are the questions
-- "does observation `i` read the value `v`?".  Discreteness of `V` is exactly
-- what makes that question answerable by a bit, and it is the only hypothesis.
chu : (O : Obs X V) → Discrete V → ChuObs X (O .Index × V)
chu O dec x (i , v) = decBool (dec (O .read i x) v)

------------------------------------------------------------------------
-- B.  The bridge: the two presentations separate the same pairs.

-- A `V`-valued separation produces a bit-test that differs.  The test is the
-- one that asks after the value `x` actually reads, and `y` therefore does not.
Sep→chu :
    (O : Obs X V) (dec : Discrete V) (x y : X)
  → Sep O x y
  → Σ[ t ∈ (O .Index × V) ] (¬ (chu O dec x t ≡ chu O dec y t))
Sep→chu O dec x y (i , ne) =
  (i , O .read i x) ,
  λ q → true≢false
    ( sym (decBool-refl dec (O .read i x))
    ∙ q
    ∙ decBool-neq dec (O .read i y) (O .read i x) (λ p → ne (sym p)) )

-- And a differing bit-test produces a `V`-valued separation.  This direction
-- needs no discreteness beyond the one already used to build the test: if the
-- readings agreed, every test built from them would agree too.
chu→Sep :
    (O : Obs X V) (dec : Discrete V) (x y : X)
  → Σ[ t ∈ (O .Index × V) ] (¬ (chu O dec x t ≡ chu O dec y t))
  → Sep O x y
chu→Sep O dec x y ((i , v) , nb) =
  i , λ p → nb (cong (λ w → decBool (dec w v)) p)

-- The translation is distinction-preserving in both directions.  Neither
-- presentation sees a pair the other cannot.
bridge :
    (O : Obs X V) (dec : Discrete V) (x y : X)
  → (Sep O x y → Σ[ t ∈ (O .Index × V) ] (¬ (chu O dec x t ≡ chu O dec y t)))
  × (Σ[ t ∈ (O .Index × V) ] (¬ (chu O dec x t ≡ chu O dec y t)) → Sep O x y)
bridge O dec x y = Sep→chu O dec x y , chu→Sep O dec x y

------------------------------------------------------------------------
-- C.  What the bridge does not carry.
--
-- Distinguishing power transports; the theorems built on top of each
-- presentation do not, and that is why both stay.
--
--   * `ChuAdvance` quantifies over a *finite list* of tests, which is what
--     makes `Shrink(𝒯) ⇒ δ↓` a theorem.  The image of `chu` is indexed by
--     `Index × V`, which is not finite in general, so the monotonicity result
--     does not transport backwards through this map.
--
--   * `ObstructionCalculus` reads into an arbitrary `V`, which is what lets
--     `absField` read `absℤ` directly rather than as a family of predicates.
--     Under `chu` that single ℤ-valued observation becomes a ℤ-indexed family
--     of bit-tests -- correct, and a worse way to say it.
--
-- So the honest statement is the one this module proves and no more: the two
-- fields separate the same pairs.  A translation that preserved everything
-- would mean one of the two presentations was redundant, and it is not.
