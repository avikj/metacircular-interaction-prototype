{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_TheCostFlipIsFaithfulBelowTheCap
--
-- ऋणधन · ṛṇa-dhana — debt and asset.  Brahmagupta,
-- *Brāhmasphuṭasiddhānta*, 628, states the arithmetic of **dhana**
-- (asset, the quantity read as gain) and **ṛṇa** (debt, the same
-- magnitude read as loss) together with śūnya, in the chapter that
-- also carries the kuṭṭaka.  A cost coordinate and a benefit
-- coordinate in this module are one magnitude under those two
-- readings, and the whole subject of the module is what it costs to
-- turn one reading into the other.  **No claim is made that
-- Brahmagupta proved anything below**: the debt/asset distinction is
-- his, the cap and its adjunction are not, and the theorem is
-- elementary.  The name leads with the term because the structure is
-- named there first and the English is the translation, not the other
-- way round (human owner, 2026-08-19).
--
-- ────────────────────────────────────────────────────────────────────
-- `FlippingACostCoordinateIsSoundButNotFaithful` proved that mixed
-- dominance implies product dominance of the capped-and-subtracted
-- vectors, refuted the unrestricted converse, and said:
--
--   "No RESTRICTED converse is proved: presumably `flipIsSound`'s
--    converse holds once every cost is `≤ cap`, and that is NOT checked
--    here."
--
-- It is checked here, and the hypothesis needed is weaker than the one
-- guessed there.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   boundedSum          `y ≤ c → (c ∸ y) + y ≤ c` — the half of the
--                       monus identity the bound actually buys
--   capReflects         `y ≤ c → c ∸ x ≤ c ∸ y → y ≤ x`: below the cap
--                       the ṛṇa reading reflects the dhana one
--   Bounded cap ds v    a recursive family: every COST entry of v is
--                       `≤ cap`; benefit entries are unconstrained
--   flipReflectsBelowTheCap
--                       `Bounded cap ds w → flipWith cap ds v ≼
--                        flipWith cap ds w → Dom ds v w`
--   flipIsFaithfulBelowTheCap
--                       with `flipIsSound`, the two orders agree
--
-- **THE HYPOTHESIS IS ONE-SIDED, AND THAT IS THE CONTENT.**  The
-- earlier module's guess was "once every cost is ≤ cap".  Only the
-- costs of `w` — the DOMINATING vector, the one claimed better — need
-- the bound; `v`'s costs may exceed the cap arbitrarily.  The reason is
-- visible in `capReflects`: the bound is used to turn `(c ∸ y) + y`
-- back into `c`, and `y` is `w`'s entry.  So a cap has to be chosen
-- above the costs of the candidates one wants to CONCLUDE ARE BETTER,
-- not above every cost in the archive.  That is a materially weaker
-- modelling obligation than the one the Pareto line has been carrying.
--
-- The refutation still stands and is consistent: its witness has
-- `cap = 3` with `w`'s cost `7`, which fails `Bounded`.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Truncated subtraction reflecting the reversed order
-- below the truncation point is elementary, and the two library facts
-- doing the work (`≤-∸-+-cancel`, `≤-k+-cancel`) are cubical's.  The
-- Galois-adjunction framing of monus is Birkhoff/Ore-era lattice
-- theory.
--
-- SYĀT — THE CLAIM, EXACTLY.  The cap is still a single number shared by all
-- cost coordinates; per-coordinate caps are not modelled, though the
-- one-sided hypothesis suggests they would be the honest version.
-- Nothing here transports `stratum`, `maximalExists` or the
-- stratification along the flip — the certificate line and the Pareto
-- line still carry the obligation for their own statements, and this
-- module only makes it dischargeable.  Nothing says how a cap should
-- be chosen in practice.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module RnaDhana_TheCostFlipIsFaithfulBelowTheCap where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; +-zero ; +-suc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; ≤-refl ; ≤-trans ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero
        ; ≤-∸-+-cancel ; ≤-k+-cancel)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import MinPlusResiduationIsAGaloisConnectionAtOneCut
  using (∸-adjˡ)
open import FlippingACostCoordinateIsSoundButNotFaithful
  using (Vec ; Dom ; flipWith ; flipIsSound)
open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_≼_)

------------------------------------------------------------------------
-- 1.  What the bound buys, at one coordinate
------------------------------------------------------------------------

boundedSum : (c y : ℕ) → y ≤ c → (c ∸ y) + y ≤ c
boundedSum c y h = subst (_≤ c) (sym (≤-∸-+-cancel h)) ≤-refl

capReflects : (c x y : ℕ) → y ≤ c → c ∸ x ≤ c ∸ y → y ≤ x
capReflects c x y ybound h =
  ≤-k+-cancel (subst (_≤ (c ∸ y) + x) (sym (≤-∸-+-cancel ybound))
                     (∸-adjˡ c x (c ∸ y) h))

------------------------------------------------------------------------
-- 2.  Bounded on the dominating side only
------------------------------------------------------------------------

Bounded : (cap : ℕ) (ds : List Bool) → Vec ds → Type
Bounded cap []           _        = Unit
Bounded cap (true  ∷ ds) (x , xs) = Bounded cap ds xs
Bounded cap (false ∷ ds) (x , xs) = (x ≤ cap) × Bounded cap ds xs

------------------------------------------------------------------------
-- 3.  The restricted converse
------------------------------------------------------------------------

flipReflectsBelowTheCap :
  (cap : ℕ) (ds : List Bool) (v w : Vec ds)
  → Bounded cap ds w
  → flipWith cap ds v ≼ flipWith cap ds w → Dom ds v w
flipReflectsBelowTheCap cap []           _        _        _        _ = tt
flipReflectsBelowTheCap cap (true  ∷ ds) (x , xs) (y , ys) b (le , r) =
  le , flipReflectsBelowTheCap cap ds xs ys b r
flipReflectsBelowTheCap cap (false ∷ ds) (x , xs) (y , ys) (yb , b) (le , r) =
  capReflects cap x y yb le , flipReflectsBelowTheCap cap ds xs ys b r

flipIsFaithfulBelowTheCap :
  (cap : ℕ) (ds : List Bool) (v w : Vec ds)
  → Bounded cap ds w
  → (Dom ds v w → flipWith cap ds v ≼ flipWith cap ds w)
  × (flipWith cap ds v ≼ flipWith cap ds w → Dom ds v w)
flipIsFaithfulBelowTheCap cap ds v w b =
    flipIsSound cap ds v w
  , flipReflectsBelowTheCap cap ds v w b

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The item left open above — "the cap is still a single
-- number shared by all cost coordinates; per-coordinate caps are not
-- modelled, though the one-sided hypothesis suggests they would be the
-- honest version" — is closed in
-- `RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
-- The generalisation costs nothing: `flipCapsIsSound`,
-- `flipCapsReflect` and `flipCapsFaithful` are this module's theorems
-- coordinate by coordinate, with `capReflects` reused unchanged.  Two
-- things it buys.  Benefit coordinates carry NO cap at all in `Caps
-- ds`, which the single number could not express; and
-- `oneCapIsTheSpecialCase` shows `flipWithCaps ds (constCaps cap ds)`
-- is `flipWith cap ds` pointwise, so nothing here is superseded — it
-- is the constant assignment of the general statement.
--
-- The modelling point, which is why it is worth the module: a single
-- cap forces one number above every cost in every coordinate, so a
-- dollar cost and a wall time must share a ceiling and are silently
-- made commensurable.
------------------------------------------------------------------------
