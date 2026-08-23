# Smallest extracted Smith architecture

**Status:** concrete implementation contract; not yet implemented.

## Decision

Use a Lean executable reducer for the repository's first live domain, integer
`2×2` matrices, and certify its output by kernel-checked reflection over an
elementary-operation trace.

Do not attempt to compile the Cubical module: Agda 2.8 refuses backend
compilation of `--cubical`.  Do not call mathlib's existing Smith constructor
as the reducer: its relevant basis constructions are `noncomputable`.  Do not
begin with non-cubical Agda: making its array representation interoperate with
Cubical's function-valued `Mat` introduces a second matrix adapter before a
native executable exists.

Proof by reflection is not a fourth backend choice.  It is the certification
layer around the Lean reducer.

## Concrete API

```lean
abbrev Mat2 := Fin 2 → Fin 2 → Int

inductive Side | row | col

inductive ElemOp
  | swap (side : Side)
  | addMul (side : Side) (src dst : Fin 2) (q : Int)
  | negate (side : Side) (i : Fin 2)

structure SmithCert2 where
  ops : List ElemOp
  D   : Mat2

def replay (A : Mat2) (ops : List ElemOp) : Mat2
def normal (D : Mat2) : Bool
def verify (A : Mat2) (c : SmithCert2) : Bool :=
  decide (replay A c.ops = c.D) && normal c.D

def reduceSmith2 (A : Mat2) : SmithCert2

structure SmithSpec2 (A : Mat2) (c : SmithCert2) : Prop where
  replay_eq : replay A c.ops = c.D
  normal    : IsSmithNormal c.D
  unimodular : EveryOpUnimodular c.ops

theorem verify_sound {A c} : verify A c = true → SmithSpec2 A c
theorem reducer_complete (A) : verify A (reduceSmith2 A) = true

def certifiedSmith2 (A : Mat2) :
    {c : SmithCert2 // SmithSpec2 A c} :=
  ⟨reduceSmith2 A, verify_sound (reducer_complete A)⟩
```

`#eval reduceSmith2 A` gives interactive execution.  A `lean --run` entry point
or Lean code generation gives the native reducer.  Neither execution is a
proof.  Certification occurs when the certificate literal is reintroduced to
Lean and `verify_sound` is applied to a kernel-reduced equality such as
`of_decide_eq_true rfl` or an explicit replay theorem.

Do not use `native_decide` on the certification path.  Mathlib itself forbids
it because it trusts the entire Lean compiler.  It may be benchmarked only as
an explicitly weaker trust profile.

## Why the trace is the interface

An elementary-operation trace is smaller and safer than accepting arbitrary
`L,R,L⁻¹,R⁻¹` matrices:

- every constructor has a proved unimodular interpretation;
- folding the trace produces `L` and `R` if a consumer needs them;
- replay computes `D=LAR` by construction;
- the Boolean checker only decides replay equality and Smith divisibility;
- a bad or differently implemented reducer cannot manufacture a proof.

The reducer may use Euclidean quotients, pivot heuristics, or future fast
algorithms.  None of those choices enter the semantic contract.

## Relation to Cubical Smith

`NaturalMachine.SmithCapability.normalizeSmith` and `certifiedSmith2` need not
be propositionally equal and need not choose identical signs or traces.  Their
common object is the extensional contract:

\[
D=LAR,\qquad L,R\text{ invertible over }\mathbb Z,\qquad
D\text{ Smith-normal}.
\]

This avoids duplicating Cubical semantics.  Cubical supplies one constructive
inhabitant of the contract inside the proof assistant; Lean supplies a native
producer plus an independently checked inhabitant.  A later bridge theorem may
prove uniqueness of the normalized diagonal up to the declared sign convention.
It is not required for certificate soundness.

## Trusted boundary

### Kernel profile (recommended)

Trusted:

1. Lean kernel and the small definitions of `ElemOp`, `replay`, `normal`, and
   `SmithSpec2`;
2. the proved lemmas that each elementary operation is unimodular;
3. `verify_sound` and kernel reduction of the concrete certificate.

Untrusted:

- `reduceSmith2`'s native executable and Lean compiler output;
- parsing, CLI, serialization, caching, and scheduling;
- the Cubical implementation as evidence for this particular Lean result.

Any corruption in the untrusted layer yields rejection or a different valid
certificate, not a false theorem.

### Compiler-trusting profile (optional, not promotion-grade)

Replacing kernel reduction by `native_decide` adds the Lean compiler/runtime
to the trusted base.  That profile may serve performance experiments but must
not silently inherit the kernel-checked label.

## Boundary

This design covers integer `2×2` Smith reduction, the repository's present
executable consumer.  Generic `m×n`, asymptotically fast algorithms, certificate
size bounds, and a cross-assistant uniqueness theorem remain future work.  The
first implementation should not generalize until the 2×2 certificate compiles,
checks, and replaces one live untrusted producer.
