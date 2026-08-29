{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- फ़र्मा, घन — THE CUBE GATE BELOW THIRTEEN IS SIGNED, AND BOTH
-- NEAR-MISSES ARE ITS TIGHTNESS.
--
-- STATUS.  AWAITING KERNEL.  This container has no agda.  Nothing
-- below is claimed green; the claims are the terms, to be run at the
-- pin (Agda 2.8.0, agda/cubical v0.9) by `sh check --all`.
--
-- THE OCCASION.  A sweep of this corpus for Fermat's Last Theorem
-- found the equation in three rooms and absent from the fourth:
-- the near-misses of n = 3 (RamanujanCubes_… — off by exactly one,
-- both directions), the Fermat primality test (HeadDepthMerge, its
-- blindness pinned at a ≤ e_b(q)), and Fermat's factorization as one
-- projection of the pair conic (PairConic).  The equation itself,
-- x³ + y³ ≡ z³ over positive naturals, had no type here.  This module
-- gives it one, by the corpus's boundary method: the universal claim
-- is a TYPE, the finite gate is PROVED, the restriction map runs in
-- exactly one direction, and no term runs backwards.
--
-- WHAT IS PROVED.
--   · `scan-ok`      — the kernel visits every triple 1 ≤ x,y,z ≤ 12
--                      (1728 leaves) and finds no x³ + y³ ≡ z³, by one
--                      refl, boolean-free: each comparison returns
--                      Maybe (m ≡ n) and the whole scan normalizes to
--                      just tt.
--   · `parts-below`  — a solution's parts are SMALLER than its z: from
--                      y ≥ 1, cube x < cube z, hence x < z, with no
--                      search.  So the z-bound alone confines a
--                      solution to the scanned box.
--   · `gate-below-thirteen` — no solution has z ≤ 12.  The scan and
--                      the confinement, assembled.
--   · `tight-low`, `tight-high` — the gate's equation cannot be
--                      relaxed by one unit in either direction:
--                      6³+8³+1 ≡ 9³ and 9³+10³ ≡ 12³+1, each refl.
--                      Ramanujan's near-misses are not decoration
--                      here; they are the proof that the gate is
--                      exact, not slack.
--   · `restrict`     — FLT₃ implies the gate.  One direction.
--
-- SYĀT — THE CLAIM, EXACTLY.
--   Not that Fermat's Last Theorem for n = 3 is proved here.  It is a
--   theorem of mathematics (Euler announced it in 1770; his argument's
--   ℤ[√−3] step was completed by later hands — Legendre, Kausler, and
--   the modern treatments via ℤ[ω]).  In THIS corpus it is `FLT₃`, a
--   type with no inhabitant written, exactly as Lehmer's question and
--   Ramanujan's 1916 assertion are types.  The distinction matters
--   differently than it does for Lehmer: there the universal is open
--   to mathematics; here it is known outside and unpaid inside.  The
--   type is the record of the debt, and the debt is a descent proof
--   in a quadratic ring, not a bigger scan — no bound on the scan
--   reaches the universal, which is what `restrict` having no
--   converse says as a type.
--   Not anything about n > 3, about ℤ, or about the modularity route.
--   The extent of the search IS the content of the gate's type:
--   twelve, and not a step further.
------------------------------------------------------------------------

module Fermat3Gate_TheCubeGateBelowThirteenIsSignedAndBothNearMissesAreItsTightness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero ; ¬m<m ;
         ≤-trans ; ≤<-trans ; splitℕ-≤ ; ≤-k+ ; ≤-suc)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just ; rec ; ¬nothing≡just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (cube ; S² ; eq?-complete ; loop ; loop-sound ; cube-mono)

------------------------------------------------------------------------
-- §1  The universal claim is a type.  No term below inhabits it.
------------------------------------------------------------------------

FLT₃ : Type
FLT₃ = (x y z : ℕ) → 1 ≤ x → 1 ≤ y → 1 ≤ z → ¬ (S² x y ≡ cube z)

------------------------------------------------------------------------
-- §2  The scan: every triple of 1..12, one normalization.
--     A leaf answers just tt exactly when the cubes do NOT collide;
--     the witness of non-collision is eq? returning nothing, and
--     eq?-complete converts that computation into the refutation.
------------------------------------------------------------------------

leaf : ℕ → ℕ → ℕ → Maybe Unit
leaf x y z = rec (just tt) (λ _ → nothing) (eq? (S² x y) (cube z))

gZ : ℕ → ℕ → ℕ → Maybe Unit
gZ x y z = leaf (suc x) (suc y) (suc z)

gY : ℕ → ℕ → Maybe Unit
gY x y = loop (gZ x y) 11

gX : ℕ → Maybe Unit
gX x = loop (gY x) 11

scan : Maybe Unit
scan = loop gX 11

-- THE SCAN: 1728 triples, largest comparison 12³ + 12³ = 3456 against
-- 12³ = 1728, in unary, one refl.
scan-ok : scan ≡ just tt
scan-ok = refl

leaf-sound : (x y z : ℕ) → leaf x y z ≡ just tt → ¬ (S² x y ≡ cube z)
leaf-sound x y z h sums = go (eq? (S² x y) (cube z)) refl
  where
  go : (w : Maybe (S² x y ≡ cube z)) → eq? (S² x y) (cube z) ≡ w → ⊥
  go (just q) pw =
    ¬nothing≡just
      (sym (cong (rec (just tt) (λ _ → nothing)) pw) ∙ h)
  go nothing  pw = eq?-complete _ _ pw sums

-- The boxed gate: no collision anywhere in the scanned box.
gate-boxed : (x y z : ℕ) → x ≤ 11 → y ≤ 11 → z ≤ 11 →
             ¬ (S² (suc x) (suc y) ≡ cube (suc z))
gate-boxed x y z hx hy hz =
  leaf-sound (suc x) (suc y) (suc z)
    (loop-sound (gZ x y) 11
      (loop-sound (gY x) 11
        (loop-sound gX 11 scan-ok x hx) y hy) z hz)

------------------------------------------------------------------------
-- §3  Confinement: a solution's parts sit below its z, with no search.
--     From y ≥ 1 the second cube contributes at least one unit, so
--     cube x < cube z; and cube-mono read contrapositively turns the
--     strict cube inequality into x < z.
------------------------------------------------------------------------

parts-below : (x y z : ℕ) → 1 ≤ y → S² x y ≡ cube z → x < z
parts-below x y z hy sums = go (splitℕ-≤ (suc x) z)
  where
  one≤cubey : 1 ≤ cube y
  one≤cubey = cube-mono hy

  cubex<cubez : cube x < cube z
  cubex<cubez =
    subst (_≤ cube z) (sym (+-comm 1 (cube x)))
      (subst (cube x + 1 ≤_) sums (≤-k+ {k = cube x} one≤cubey))

  go : (suc x ≤ z) ⊎ (z < suc x) → x < z
  go (inl h) = h
  go (inr h) =
    Empty.rec (¬m<m (≤<-trans (cube-mono (pred-≤-pred h)) cubex<cubez))

------------------------------------------------------------------------
-- §4  THE GATE.  No solution has z ≤ 12.
------------------------------------------------------------------------

Gate12 : Type
Gate12 = (x y z : ℕ) → 1 ≤ x → 1 ≤ y → 1 ≤ z → z ≤ 12 →
         ¬ (S² x y ≡ cube z)

gate-below-thirteen : Gate12
gate-below-thirteen zero    y z px _ _ _ _ = Empty.rec (¬-<-zero px)
gate-below-thirteen (suc x) zero z _ py _ _ _ = Empty.rec (¬-<-zero py)
gate-below-thirteen (suc x) (suc y) zero _ _ pz _ _ = Empty.rec (¬-<-zero pz)
gate-below-thirteen (suc x) (suc y) (suc z) _ py _ hz sums =
  gate-boxed x y z
    (≤-suc (pred-≤-pred (pred-≤-pred
      (≤-trans (parts-below (suc x) (suc y) (suc z) py sums) hz))))
    (≤-suc (pred-≤-pred (pred-≤-pred
      (≤-trans (parts-below (suc y) (suc x) (suc z)
                 (suc-≤-suc zero-≤)
                 (+-comm (cube (suc y)) (cube (suc x)) ∙ sums)) hz))))
    (pred-≤-pred hz)
    sums

------------------------------------------------------------------------
-- §5  TIGHTNESS.  The near-misses are the proof the gate is exact:
--     one unit of slack in either direction and it falls.
------------------------------------------------------------------------

tight-low : cube 6 + cube 8 + 1 ≡ cube 9
tight-low = refl

tight-high : cube 9 + cube 10 ≡ cube 12 + 1
tight-high = refl

------------------------------------------------------------------------
-- §6  The restriction runs one way.  No converse term is written, and
--     none is writable from the scan: the type records the debt.
------------------------------------------------------------------------

restrict : FLT₃ → Gate12
restrict flt x y z px py pz _ = flt x y z px py pz
