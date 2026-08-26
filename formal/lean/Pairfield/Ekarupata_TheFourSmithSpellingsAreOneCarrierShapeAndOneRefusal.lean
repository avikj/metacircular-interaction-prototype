import Pairfield.LosslessReturn_TheDeterminedFieldRidesFree
import Pairfield.GeneralSmith2x2
import Pairfield.DirectSmith2x2
import Pairfield.ComputableSmith2x2

/-!
# एकरूपता — the four Smith spellings are one Carrier shape, and one of them is not

## On the name

*Ekarūpatā* (एकरूपता), "having one form / uniformity of form", is ordinary
Sanskrit and is used here in its plain sense. **The application of it as a
module name is made here; no text and no technical sense from any śāstra is
claimed for it.** See `LosslessReturn_TheDeterminedFieldRidesFree.lean` for the
same declaration about the head term of that family.

## Added, not edited

`GeneralSmith2x2.lean`, `DirectSmith2x2.lean`, `ComputableSmith2x2.lean` and
`SmithPresentation.lean` are untouched. Four seats wrote four structures around
the same map; this file says what the four are, from outside, by `Equiv`. §६ of
spellings of one object is a stated equivalence, not three deletions.

## The shape

Every one of the four is built around the same map

    f (L, R)  =  L · A · R

and a field holding its value, with a `replay` equation pinning that field. So
the question for each is only: **which fiber of `f` is this?**

| structure | file | verdict |
|---|---|---|
| `Reduction A` | `GeneralSmith2x2` | Carrier — target is a field |
| `UnitDetCapability A` | `DirectSmith2x2` | Carrier — `normal` is a field |
| `Certificate A` | `ComputableSmith2x2` | Carrier with a predicate on the carried datum |
| `SmithPresentation A B` | `SmithPresentation` | **not** a Carrier — target is an index |

The last is the interesting one and it is a refusal, not an omission. Making
the target an index turns the graph fiber into the **preimage** fiber, and the
preimage is not a singleton and need not be inhabited at all:
`natAbs_det_eq` below extracts the invariant that obstructs it, and
`isEmpty_presentation_one_to_diagonal_two_two` exhibits a genuinely empty one.
`GeneralSmith2x2`'s own docstring says in prose that `Reduction A` "is
`Σ B, SmithPresentation A B`"; `reductionEquivSigmaPresentation` is that
sentence as a theorem, and it is exactly the Carrier-as-Σ reading — summing the
indexed family over its index recovers the Carrier, which recovers the base.

## What is NOT true, said plainly

The four are **not** equivalent to each other. They live over three different
matrix carriers (`Pairfield.IntMat2`, `Matrix (Fin 2) (Fin 2) ℤ`,
`ComputableSmith2x2.Mat2`) and impose three different side conditions
(`natAbs det = 1`, two-sided integral inverse, `det = 1`). What is shared is
the *shape*: one map, one determined field, one replay witness. Claiming more
than that would be the flattening this repository's own protocol warns about.

One thing fell out that is not about Carriers at all, and is recorded because
finding it was free: in `UnitDetCapability`, `rightInverse` reads
`A * left = 1`, not `A * right = 1`. So the `right` field is constrained by
nothing except the replay equation it feeds, and the equivalence below shows it
as a bare `Mat2` factor — full degrees of freedom. This is reported, not
touched.
-/

namespace Pairfield.LosslessReturn.Smith

open Pairfield Pairfield.LosslessReturn

/-! ## 1. `GeneralSmith2x2.Reduction` -/

/-- A unimodular pair — the honest base of every 2×2 Smith presentation over
`IntMat2`. -/
abbrev UnimodularPair : Type :=
  { p : IntMat2 × IntMat2 // p.1.unimodular ∧ p.2.unimodular }

/-- The map `f (L, R) = L · A · R`. -/
def conjugate (A : IntMat2) (p : UnimodularPair) : IntMat2 := p.1.1 * A * p.1.2

/-- **`Reduction A` is a Carrier.** base = the unimodular pair,
carried = `target`, witness = `replay`. -/
def reductionEquivCarrier (A : IntMat2) :
    Reduction A ≃ Carrier (conjugate A) where
  toFun r := ⟨⟨(r.left, r.right), r.left_unimodular, r.right_unimodular⟩,
    r.target, r.replay.symm⟩
  invFun c := ⟨c.base.1.1, c.base.1.2, c.carried, c.witness.symm,
    c.base.2.1, c.base.2.2⟩
  left_inv := by rintro ⟨L, R, T, rfl, hL, hR⟩; rfl
  right_inv := by rintro ⟨⟨⟨L, R⟩, hL, hR⟩, T, rfl⟩; rfl

/-- Three of the six fields carry no information. -/
def reductionEquiv (A : IntMat2) : Reduction A ≃ UnimodularPair :=
  (reductionEquivCarrier A).trans (Carrier.equivBase (conjugate A))

/-! ## 2. `SmithPresentation` refuses, and the refusal is the preimage -/

/-- The indexed spelling is the **preimage** fiber of the same map. -/
def presentationEquivPreimage (A B : IntMat2) :
    SmithPresentation A B ≃ { p : UnimodularPair // conjugate A p = B } where
  toFun p := ⟨⟨(p.left, p.right), p.left_unimodular, p.right_unimodular⟩,
    p.replay.symm⟩
  invFun q := ⟨q.1.1.1, q.1.1.2, q.2.symm, q.1.2.1, q.1.2.2⟩
  left_inv := by rintro ⟨L, R, h, hL, hR⟩; rfl
  right_inv := by rintro ⟨⟨⟨L, R⟩, hL, hR⟩, h⟩; rfl

/-- Summing the indexed family over its index recovers the Carrier. This is
`GeneralSmith2x2`'s prose docstring, as a theorem. -/
def reductionEquivSigmaPresentation (A : IntMat2) :
    Reduction A ≃ Σ B : IntMat2, SmithPresentation A B where
  toFun r := ⟨r.target, r.left, r.right, r.replay,
    r.left_unimodular, r.right_unimodular⟩
  invFun p := ⟨p.2.left, p.2.right, p.1, p.2.replay,
    p.2.left_unimodular, p.2.right_unimodular⟩
  left_inv _ := rfl
  right_inv _ := rfl

/-- **The invariant that obstructs the preimage.** A presentation preserves the
absolute determinant, so most preimages are empty. -/
theorem natAbs_det_eq {A B : IntMat2} (p : SmithPresentation A B) :
    B.det.natAbs = A.det.natAbs := by
  have hL : p.left.det.natAbs = 1 := p.left_unimodular
  have hR : p.right.det.natAbs = 1 := p.right_unimodular
  rw [p.replay, IntMat2.det_mul, IntMat2.det_mul, Int.natAbs_mul, Int.natAbs_mul,
    hL, hR, one_mul, mul_one]

/-- An empty preimage, exhibited. There is no presentation of the identity
whose target is `diagonal 2 2` — so `SmithPresentation` is not equivalent to
its base, and cannot be, for any general reason. -/
theorem isEmpty_presentation_one_to_diagonal_two_two :
    IsEmpty (SmithPresentation IntMat2.one (IntMat2.diagonal 2 2)) := by
  constructor
  intro p
  have h := natAbs_det_eq p
  simp [IntMat2.det, IntMat2.diagonal, IntMat2.one] at h

/-! ## 3. `DirectSmith2x2.UnitDetCapability` -/

namespace Direct

open Pairfield.DirectSmith2x2

/-- Base: an integrally invertible left transform, plus a completely
unconstrained right factor. -/
abbrev DirectBase (A : Mat2) : Type :=
  { L : Mat2 // L * A = 1 ∧ A * L = 1 } × Mat2

/-- The same map `f (L, R) = L · A · R`, over mathlib matrices. -/
def conjugate (A : Mat2) (p : DirectBase A) : Mat2 := p.1.1 * A * p.2

/-- **`UnitDetCapability A` is a Carrier**: `normal` and `replay` are free. -/
def unitDetEquivCarrier (A : Mat2) :
    UnitDetCapability A ≃ Carrier (conjugate A) where
  toFun c := ⟨(⟨c.left, c.leftInverse, c.rightInverse⟩, c.right),
    c.normal, c.replay.symm⟩
  invFun k := ⟨k.base.1.1, k.base.2, k.carried, k.witness.symm,
    k.base.1.2.1, k.base.1.2.2⟩
  left_inv := by rintro ⟨L, R, N, rfl, h₁, h₂⟩; rfl
  right_inv := by rintro ⟨⟨⟨L, h₁, h₂⟩, R⟩, N, rfl⟩; rfl

/-- Of six fields, two are determined and one (`right`) is unconstrained. -/
def unitDetEquiv (A : Mat2) : UnitDetCapability A ≃ DirectBase A :=
  (unitDetEquivCarrier A).trans (Carrier.equivBase (conjugate A))

end Direct

/-! ## 4. `ComputableSmith2x2.Certificate` -/

namespace Computable

open Pairfield.ComputableSmith2x2

/-- Base: a pair of determinant-one matrices. -/
abbrev UnitDetPair : Type := { p : Mat2 × Mat2 // det p.1 = 1 ∧ det p.2 = 1 }

/-- The same map again, in this file's own matrix spelling. -/
def conjugate (A : Mat2) (p : UnitDetPair) : Mat2 := mul (mul p.1.1 A) p.1.2

/-- The Smith divisibility chain — a predicate on the *carried* datum, which is
why this one is a `CarrierWith` and not a bare `Carrier`. -/
def SmithChain (D : Mat2) : Prop := D.a11 ∣ D.a22

/-- **`Certificate A` is a Carrier with a predicate on the carried datum.** -/
def certificateEquivCarrierWith (A : Mat2) :
    Certificate A ≃ CarrierWith (conjugate A) SmithChain where
  toFun c := ⟨⟨(c.L, c.R), c.detL, c.detR⟩, c.D, c.replay, c.smithChain⟩
  invFun k := ⟨k.base.1.1, k.carried, k.base.1.2, k.witness,
    k.base.2.1, k.base.2.2, k.holds⟩
  left_inv := by rintro ⟨L, D, R, rfl, h₁, h₂, h₃⟩; rfl
  right_inv := by rintro ⟨⟨⟨L, R⟩, h₁, h₂⟩, D, rfl, h₃⟩; rfl

/-- `D` and `replay` carry nothing; the chain condition lands on the base. -/
def certificateEquiv (A : Mat2) :
    Certificate A ≃ { p : UnitDetPair // SmithChain (conjugate A p) } :=
  (certificateEquivCarrierWith A).trans
    (CarrierWith.equivSubtype (conjugate A) SmithChain)

end Computable

end Pairfield.LosslessReturn.Smith
