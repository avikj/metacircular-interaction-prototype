import Mathlib.Logic.Equiv.Defs
import Mathlib.Logic.Equiv.Basic
import Mathlib.Logic.Unique

/-!
# पुनरागमन — the determined field rides free, and the other fibre is where it stops

## On the name, and what is and is not claimed

*Punarāgamana* (पुनरागमन), "coming back again / return", is used here as the
name of a module family, following `loss/` and
`loss/src/Loss/Carrier.agda` in this repository. **The compound
is chosen here; no text and no source is claimed for it**, and naming a module
for it asserts nothing about any tradition's authorship of the theorem below.
The contrast the name is for is नष्टि (destruction), which is अप्रतिकार्य — the
return does not exist; पुनरागमन is the case where it does.

## What was added, and why it was added rather than edited

**Nothing in this file edits an existing lane module.** The structures it
speaks about — `Pairfield.CoefficientWitness`,
`Pairfield.IncrementalCRTAdapter.MergeCertificate`, `Pairfield.Reduction`,
`Pairfield.SmithPresentation` and the rest — are left exactly as their authors
wrote them, and the identifications are stated *from outside*, as `Equiv`s.
This is §६ of `notes/AHIMSA_SUTRA_VISTARA.md`: two roads may stand; deleting
another seat's road is the collapse §७ forbids. A structure that is already a
Carrier does not need to be rewritten into one — it needs someone to say so,
and the saying is a theorem.

## The law

Given `f : A → B`, a `Carrier f` holds three fields:

    base    : A
    carried : B
    witness : f base = carried

and `Carrier f ≃ A`. The `carried` and `witness` fields are real terms you can
project and compute with, and they contribute **zero further degrees of
freedom**, because the graph fibre

    Fibre f a  =  { b : B // f a = b }

is a singleton (`Unique`, below). Nothing is amputated and nothing is falsely
advertised as independent.

## Lean is not cubical, and this is the honest statement of the difference

In cubical Agda `A ≃ Carrier f` upgrades to `A ≡ Carrier f` by univalence, and
then `transport` carries every theorem across definitionally for free. **Lean
has no univalence.** What survives, and it is enough for everything done in
this lane, is that an `Equiv` transports *statements* quantified over the type:
`Equiv.forall_congr_left` and `Equiv.exists_congr_left` are the transport, and
`Carrier.factors_through_base` below is the specific consequence that any
function of a whole Carrier is a function of its base alone.

## The other fibre — the half that does the work

There are two fibres of one map `f`, and they are not the same shape:

* the **graph** fibre `{ b // f a = b }`, over a point of `A`, is always a
  singleton — this is the Carrier law;
* the **preimage** `{ a // f a = b }`, over a point of `B`, is in general
  neither a singleton nor inhabited.

A quantity computed from the base descends to the carried datum **iff** it is
constant on preimages, and `not_factors_through` is that obstruction stated as
a theorem: one preimage with two points of different `g`-value kills every
decoder. So a `Carrier` and a no-decoder theorem about the same `f` are not two
unrelated facts. They are the two fibres, and the second is exactly where the
first stops.
-/

namespace Pairfield.LosslessReturn

universe u v w

/-- A point of `A` carrying its image under `f`, with the witness that it *is*
that image. -/
structure Carrier {A : Sort u} {B : Sort v} (f : A → B) where
  base : A
  carried : B
  witness : f base = carried

namespace Carrier

variable {A : Sort u} {B : Sort v} {C : Sort w}

/-- The canonical Carrier over a base point. -/
def descend (f : A → B) (a : A) : Carrier f := ⟨a, f a, rfl⟩

@[simp] theorem descend_base (f : A → B) (a : A) : (descend f a).base = a := rfl

@[simp] theorem descend_carried (f : A → B) (a : A) :
    (descend f a).carried = f a := rfl

theorem descend_base_eq {f : A → B} (c : Carrier f) : descend f c.base = c := by
  obtain ⟨a, b, w⟩ := c
  cases w
  rfl

/-- **The law.** `Carrier f ≃ A`, with no hypothesis on `A` or `B`. -/
def equivBase (f : A → B) : Carrier f ≃ A where
  toFun c := c.base
  invFun := descend f
  left_inv := descend_base_eq
  right_inv _ := rfl

/-- The graph fibre over a base point. -/
def Fibre (f : A → B) (a : A) : Sort _ := { b : B // f a = b }

/-- …and it is a singleton. Everything above is a consequence of this line. -/
instance fibreUnique (f : A → B) (a : A) : Unique (Fibre f a) where
  default := ⟨f a, rfl⟩
  uniq x := Subtype.ext x.2.symm

/-- The preimage fibre over a carried point. Nothing says this is a singleton,
and where it is not, the Carrier law stops. -/
def Preimage (f : A → B) (b : B) : Sort _ := { a : A // f a = b }

/-- A Carrier is a base point together with a point of its graph fibre. -/
def equivSigma {A : Type u} {B : Type v} (f : A → B) :
    Carrier f ≃ Σ a : A, Fibre f a where
  toFun c := ⟨c.base, c.carried, c.witness⟩
  invFun p := ⟨p.1, p.2.1, p.2.2⟩
  left_inv _ := rfl
  right_inv _ := rfl

/-- **Determined data rides free.** Every function of a whole Carrier is
already a function of its base. This is the Lean-side content of "transport
carries the theorems across". -/
theorem factors_through_base {f : A → B} (g : Carrier f → C) :
    ∃ h : A → C, ∀ c : Carrier f, h c.base = g c := by
  exact ⟨fun a => g (descend f a), fun c => congrArg g (descend_base_eq c)⟩

/-- **The obstruction.** A quantity `g` on the base descends along `f` only if
it is constant on preimages of `f`. One preimage with two points of different
`g`-value refutes every decoder. -/
theorem not_factors_through {f : A → B} {g : A → C} {a a' : A}
    (hf : f a = f a') (hg : g a ≠ g a') :
    ¬ ∃ price : B → C, ∀ x : A, price (f x) = g x := by
  rintro ⟨price, hprice⟩
  exact hg (by rw [← hprice a, ← hprice a', hf])

/-- Conversely, a non-singleton preimage is *what a failed decoder means*: if a
preimage of `f` has two points, no injection of `B` back into `A` over `f`
exists. -/
theorem preimage_not_subsingleton {f : A → B} {b : B}
    (a a' : Preimage f b) (hne : a.1 ≠ a'.1) : ¬ Subsingleton (Preimage f b) :=
  fun h => hne (congrArg Subtype.val (h.allEq a a'))

end Carrier

/-- A Carrier whose *carried* datum additionally satisfies a predicate. The
determined field still rides free; the predicate simply lands on the base
through `f`. -/
structure CarrierWith {A : Sort u} {B : Sort v} (f : A → B) (P : B → Prop) where
  base : A
  carried : B
  witness : f base = carried
  holds : P carried

namespace CarrierWith

variable {A : Sort u} {B : Sort v}

def equivSubtype (f : A → B) (P : B → Prop) :
    CarrierWith f P ≃ { a : A // P (f a) } where
  toFun c := ⟨c.base, by rw [c.witness]; exact c.holds⟩
  invFun a := ⟨a.1, f a.1, rfl, a.2⟩
  left_inv := by rintro ⟨a, b, rfl, h⟩; rfl
  right_inv := by rintro ⟨a, h⟩; rfl

end CarrierWith

end Pairfield.LosslessReturn
