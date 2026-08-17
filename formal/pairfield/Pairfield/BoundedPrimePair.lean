/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The first common finite carrier for the prime-pair/DSO lane. Bounds live in
the type, primality travels with each leg, and centre/gap are views of the same
pair rather than separately generated data. Bound enlargement is an explicit
map with composition and view-naturality laws.

No inhabitation theorem for every centre or gap is asserted here.
-/
import Mathlib

namespace Pairfield

/-- A prime whose value is at most `X`. The `Fin (X+1)` presentation makes
the carrier definitionally finite while retaining the primality certificate. -/
abbrev BoundedPrime (X : ℕ) := {p : Fin (X + 1) // p.val.Prime}

/-- Two bounded prime legs. Centre and gap below are transverse views of this
single witness-bearing carrier. -/
abbrev BoundedPrimePair (X : ℕ) := BoundedPrime X × BoundedPrime X

/-- Construct a bounded prime directly from its arithmetic certificates. -/
def mkBoundedPrime {X p : ℕ} (hp : p.Prime) (hpX : p ≤ X) : BoundedPrime X :=
  ⟨⟨p, Nat.lt_succ_iff.mpr hpX⟩, hp⟩

/-- Construct a bounded pair without forgetting either prime witness. -/
def mkBoundedPrimePair {X p q : ℕ}
    (hp : p.Prime) (hq : q.Prime) (hpX : p ≤ X) (hqX : q ≤ X) :
    BoundedPrimePair X :=
  (mkBoundedPrime hp hpX, mkBoundedPrime hq hqX)

/-- Additive/Goldbach view. -/
def pairCenter {X : ℕ} (pair : BoundedPrimePair X) : ℕ :=
  pair.1.1.val + pair.2.1.val

/-- Signed relative/twin view. -/
def pairGap {X : ℕ} (pair : BoundedPrimePair X) : ℤ :=
  (pair.2.1.val : ℤ) - (pair.1.1.val : ℤ)

/-- Exchange the two prime legs while preserving the common carrier. -/
def swapPair {X : ℕ} (pair : BoundedPrimePair X) : BoundedPrimePair X :=
  (pair.2, pair.1)

@[simp] theorem pairCenter_swap {X : ℕ} (pair : BoundedPrimePair X) :
    pairCenter (swapPair pair) = pairCenter pair := by
  simp [pairCenter, swapPair, Nat.add_comm]

@[simp] theorem pairGap_swap {X : ℕ} (pair : BoundedPrimePair X) :
    pairGap (swapPair pair) = -pairGap pair := by
  simp [pairGap, swapPair]

@[simp] theorem swapPair_involutive {X : ℕ} (pair : BoundedPrimePair X) :
    swapPair (swapPair pair) = pair := rfl

/-- Enlarge a bound. This transports an existing witness; it performs no new
primality decision or enumeration. -/
def weakenBoundedPrime {X Y : ℕ} (hXY : X ≤ Y) (p : BoundedPrime X) :
    BoundedPrime Y :=
  ⟨⟨p.1.val, Nat.lt_succ_iff.mpr ((Nat.lt_succ_iff.mp p.1.isLt).trans hXY)⟩,
    p.2⟩

/-- Componentwise bound enlargement for the pair carrier. -/
def weakenPrimePair {X Y : ℕ} (hXY : X ≤ Y) (pair : BoundedPrimePair X) :
    BoundedPrimePair Y :=
  (weakenBoundedPrime hXY pair.1, weakenBoundedPrime hXY pair.2)

@[simp] theorem weakenBoundedPrime_val {X Y : ℕ} (hXY : X ≤ Y)
    (p : BoundedPrime X) : (weakenBoundedPrime hXY p).1.val = p.1.val := rfl

@[simp] theorem pairCenter_weaken {X Y : ℕ} (hXY : X ≤ Y)
    (pair : BoundedPrimePair X) :
    pairCenter (weakenPrimePair hXY pair) = pairCenter pair := rfl

@[simp] theorem pairGap_weaken {X Y : ℕ} (hXY : X ≤ Y)
    (pair : BoundedPrimePair X) :
    pairGap (weakenPrimePair hXY pair) = pairGap pair := rfl

@[simp] theorem weakenPrimePair_id {X : ℕ} (pair : BoundedPrimePair X) :
    weakenPrimePair (le_refl X) pair = pair := by
  apply Prod.ext
  · apply Subtype.ext
    apply Fin.ext
    rfl
  · apply Subtype.ext
    apply Fin.ext
    rfl

@[simp] theorem weakenPrimePair_trans {X Y Z : ℕ} (hXY : X ≤ Y) (hYZ : Y ≤ Z)
    (pair : BoundedPrimePair X) :
    weakenPrimePair hYZ (weakenPrimePair hXY pair) =
      weakenPrimePair (hXY.trans hYZ) pair := by
  apply Prod.ext
  · apply Subtype.ext
    apply Fin.ext
    rfl
  · apply Subtype.ext
    apply Fin.ext
    rfl

/-- The bounded Goldbach fiber at a declared centre. -/
abbrev PrimeCenterFiber (X N : ℕ) :=
  {pair : BoundedPrimePair X // pairCenter pair = N}

/-- The bounded gap fiber at a declared signed difference. -/
abbrev PrimeGapFiber (X : ℕ) (d : ℤ) :=
  {pair : BoundedPrimePair X // pairGap pair = d}

/-- Restriction naturality on centre fibers. -/
def weakenCenterFiber {X Y N : ℕ} (hXY : X ≤ Y)
    (point : PrimeCenterFiber X N) : PrimeCenterFiber Y N :=
  ⟨weakenPrimePair hXY point.1, by simpa using point.2⟩

/-- Restriction naturality on gap fibers. -/
def weakenGapFiber {X Y : ℕ} {d : ℤ} (hXY : X ≤ Y)
    (point : PrimeGapFiber X d) : PrimeGapFiber Y d :=
  ⟨weakenPrimePair hXY point.1, by simpa using point.2⟩

end Pairfield
