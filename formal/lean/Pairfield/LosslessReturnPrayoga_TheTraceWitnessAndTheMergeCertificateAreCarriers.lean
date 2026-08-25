import Pairfield.LosslessReturn_TheDeterminedFieldRidesFree
import Pairfield.EuclidCoefficientTrace
import Pairfield.IncrementalCRTAdapter

/-!
# पुनरागमन-प्रयोग — two lane structures were already Carriers; here is the saying

## On the name

*Prayoga* (प्रयोग) — application, employment, the putting-to-use of a rule — is
ordinary technical Sanskrit across the śāstras (it is, for instance, the word
Pāṇinīya commentary uses for a rule's actual application to a form). The
compound *punarāgamana-prayoga* is **built here**; no text is claimed for it,
and see the header of `LosslessReturn_TheDeterminedFieldRidesFree.lean` for the
same declaration about the head term.

## Added, not edited

`Pairfield/EuclidCoefficientTrace.lean` and
`Pairfield/IncrementalCRTAdapter.lean` are untouched. Their structures are
exhibited from outside as instances of `Carrier`, by `Equiv`. §६ of

One incidental finding worth recording, because it is what made the `Equiv`s
need `Eq.symm` in one direction and not the other: **the lane spells the
witness in both orders.** `CoefficientWitness.valid` reads
`runCoefficientTrace 0 trace = value` (`f base = carried`, the Carrier order);
`MergeCertificate.combined_eq` and `SignedObstruction.gcd_eq`/`delta_eq` read
`combined = merge compatible` (the reverse). Nothing depends on this — `.symm`
is the whole translation — but the two orders are why the same shape did not
look like the same shape.

## The relation between EuclidCoefficientTrace's two halves

`EuclidCoefficientTrace.lean` contains, 37 lines apart, a contractible fibre
and a non-contractible one, with nothing said relating them. They are the two
fibres of **one map**

    f = runCoefficientTrace 0 : List SignedUnitStep → Int.

* Over a *trace*, the graph fibre `{ v // f t = v }` is a singleton. That is
  `CoefficientWitness ≃ List SignedUnitStep` (`coefficientWitnessEquiv`): the
  `value` and `valid` fields are informationally free, and the structure has
  exactly the degrees of freedom of a bare trace.
* Over a *value*, the preimage `{ t // f t = v }` is **not** a singleton:
  `[inc]` and `[inc, inc, dec]` both sit over `1`
  (`preimage_one_not_subsingleton`).

`cost` is `List.length ∘ base` — a function of the base, hence, by
`factors_through_base`, well defined on the Carrier. It descends further, to
the *carried* value, only if it is constant on preimages. It is not, on that
one preimage, and that is the entire content of `no_value_cost_decoder`.

So: **`value` is determined by `trace` and `cost` is not determined by
`value`, for the same reason, read in the two directions of the same map.**
The theorem the file proves by two hand-built constants and `omega` is
recovered below (`no_value_cost_decoder_transported`) from the general
`Carrier.not_factors_through` plus the two witnesses, which is where the
witnesses actually belong.
-/

namespace Pairfield.LosslessReturn

open Pairfield

/-! ## 1. `CoefficientWitness` is `Carrier (runCoefficientTrace 0)` -/

/-- The map whose graph the witness records. -/
abbrev replayTrace : List SignedUnitStep → Int := runCoefficientTrace 0

/-- `CoefficientWitness` **is** a Carrier: base = `trace`, carried = `value`,
witness = `valid`. -/
def coefficientWitnessEquivCarrier : CoefficientWitness ≃ Carrier replayTrace where
  toFun w := ⟨w.trace, w.value, w.valid⟩
  invFun c := ⟨c.carried, c.base, c.witness⟩
  left_inv := by rintro ⟨v, t, rfl⟩; rfl
  right_inv := by rintro ⟨t, v, rfl⟩; rfl

/-- Hence the structure has exactly the degrees of freedom of a bare trace:
`value` and `valid` carry none. -/
def coefficientWitnessEquiv : CoefficientWitness ≃ List SignedUnitStep :=
  coefficientWitnessEquivCarrier.trans (Carrier.equivBase replayTrace)

@[simp] theorem coefficientWitnessEquiv_apply (w : CoefficientWitness) :
    coefficientWitnessEquiv w = w.trace := rfl

/-- `cost` is `List.length` read through the equivalence — a function of the
base alone. -/
theorem cost_eq_length (w : CoefficientWitness) :
    w.cost = (coefficientWitnessEquiv w).length := rfl

/-! ### The other fibre -/

/-- Two distinct traces over the same value. -/
def traceOne : Carrier.Preimage replayTrace 1 := ⟨[.inc], by decide⟩

/-- The padded construction of the same coefficient. -/
def tracePaddedOne : Carrier.Preimage replayTrace 1 :=
  ⟨[.inc, .inc, .dec], by decide⟩

/-- **The preimage over `1` is not a singleton.** This is the exact negation of
the Carrier law, in the other fibre of the same map. -/
theorem preimage_one_not_subsingleton :
    ¬ Subsingleton (Carrier.Preimage replayTrace 1) :=
  Carrier.preimage_not_subsingleton traceOne tracePaddedOne (by decide)

/-- Transport of the decoder statement across `coefficientWitnessEquiv`:
quantifying over witnesses and quantifying over traces are the same statement.
This is what an `Equiv` buys in Lean, where there is no univalence. -/
theorem decoder_iff (price : Int → Nat) :
    (∀ w : CoefficientWitness, price w.value = w.cost) ↔
      (∀ t : List SignedUnitStep, price (replayTrace t) = t.length) := by
  constructor
  · intro h t
    exact h ⟨replayTrace t, t, rfl⟩
  · intro h w
    have ht := h w.trace
    rw [show replayTrace w.trace = w.value from w.valid] at ht
    exact ht

/-- `no_value_cost_decoder`, obtained from the general obstruction rather than
by hand: the two hand-built constants are exactly the two points of the
non-singleton preimage. -/
theorem no_value_cost_decoder_transported :
    ¬ ∃ price : Int → Nat,
        ∀ w : CoefficientWitness, price w.value = w.cost := by
  rintro ⟨price, h⟩
  exact Carrier.not_factors_through
      (f := replayTrace) (g := List.length)
      (a := traceOne.1) (a' := tracePaddedOne.1)
      (by decide) (by decide)
      ⟨price, (decoder_iff price).mp h⟩

/-! ## 2. The CRT adapter -/

namespace CRT

open Pairfield.IncrementalCRTAdapter

variable {left right : CongruenceState}

/-- Base of the merge certificate: the compatibility proof together with the
Bézout coefficients. Both are genuine content — the coefficients are *not*
determined, since a Bézout pair is not unique. -/
abbrev mergeBase (left right : CongruenceState) : Type :=
  (_ : Compatible left right) ×' BezoutCertificate left.modulus right.modulus

/-- The map: compatibility determines the merged state. -/
def mergeOf (left right : CongruenceState) :
    mergeBase left right → CongruenceState := fun p => merge p.1

/-- **`MergeCertificate` is a Carrier.** base = (compatibility, Bézout),
carried = `combined`, witness = `combined_eq`. -/
def mergeCertificateEquivCarrier (left right : CongruenceState) :
    MergeCertificate left right ≃ Carrier (mergeOf left right) where
  toFun c := ⟨⟨c.compatible, c.bezout⟩, c.combined, c.combined_eq.symm⟩
  invFun k := ⟨k.base.1, k.base.2, k.carried, k.witness.symm⟩
  left_inv := by rintro ⟨hc, bz, comb, rfl⟩; rfl
  right_inv := by rintro ⟨⟨hc, bz⟩, comb, rfl⟩; rfl

/-- Two of the four fields are free. -/
def mergeCertificateEquiv (left right : CongruenceState) :
    MergeCertificate left right ≃ mergeBase left right :=
  (mergeCertificateEquivCarrier left right).trans
    (Carrier.equivBase (mergeOf left right))

/-! ### The signed obstruction: four of five fields at zero degrees of freedom

The docstring on `SignedObstruction` argues in prose that retaining the gcd and
the integer residue difference is worth something ("unlike a bare negation, it
retains the actual gcd and integer residue difference"). It is worth exactly
what the Carrier law says it is worth: the two data are present and projectable
and cost nothing, because `gcd_eq` and `delta_eq` pin them. The measurable
consequence is that the whole structure is a **subsingleton** — any two signed
obstructions for the same pair of states are equal — and is equivalent to the
bare negation it was contrasted with. The prose was right and the type can
carry it. -/

instance signedObstructionSubsingleton (left right : CongruenceState) :
    Subsingleton (SignedObstruction left right) := by
  constructor
  rintro ⟨g₁, d₁, rfl, rfl, h₁⟩ ⟨g₂, d₂, rfl, rfl, h₂⟩
  rfl

instance plift_subsingleton (p : Prop) : Subsingleton (PLift p) := by
  constructor
  rintro ⟨a⟩ ⟨b⟩
  rfl

/-- The signed obstruction is the negation, dressed with two determined
fields. -/
def signedObstructionEquiv (left right : CongruenceState) :
    SignedObstruction left right ≃ PLift (¬ Compatible left right) :=
  equivOfSubsingletonOfSubsingleton
    (fun o => PLift.up (by
      intro hc
      refine o.not_dvd ?_
      rw [o.gcd_eq, o.delta_eq]
      exact Nat.modEq_iff_dvd.mp hc))
    (fun h => signedObstructionOfNotCompatible h.down)

/-- The two determined fields, stated as the theorem the docstring wanted:
whatever obstruction you are handed, its `gcd` and `delta` are the canonical
ones. -/
theorem signedObstruction_fields (o : SignedObstruction left right) :
    o.gcd = Nat.gcd left.modulus right.modulus ∧
      o.delta = (right.residue : ℤ) - left.residue :=
  ⟨o.gcd_eq, o.delta_eq⟩

end CRT

end Pairfield.LosslessReturn
