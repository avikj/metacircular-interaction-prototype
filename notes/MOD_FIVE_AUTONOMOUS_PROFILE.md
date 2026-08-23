# The autonomous mod-five profile stabilizes at horizon two

## Process interface

Fix an installed multiplier `a : ZMod 5`, start at one, and observe after
`n` autonomous uses whether `a^n` is `zero`, `one`, or `other`.  No multiplier
may be selected later as an external intervention.  This interface distinction
is load-bearing: the selectable-scalar process has a different quotient.

The checked leaf is

`formal/pairfield/Pairfield/ModFiveAutonomousProfile.lean`.

## Exact stabilization

Frobenius on `ZMod 5` gives `a^5=a`.  The leaf turns this into the response
recurrence

\[
r_a(n+5)=r_a(n+1).
\]

Thus every response trace is four-periodic after its common seed at exponent
zero.  A finite check on the five installed multipliers proves that agreement
at exponents `0,1,2` already forces agreement at exponents `3,4`.  Strong
induction through the recurrence then proves the exact equivalence

```text
ForeverEq a b  <->  horizonTwoProfile a = horizonTwoProfile b.
```

The finite table is used only for the first five responses; the theorem about
all natural exponents is derived from the algebraic recurrence.

## Exact four-class kernel

An explicit `Fin 4` classifier labels

```text
{0}, {1}, {4}, {2,3}.
```

It is surjective, and equality of its labels is equivalent to complete trace
equality.  Hence it presents the exact predictive kernel rather than a merely
sound finite observation.

Both strict boundaries are checked:

- `2` and `4` agree through exponent one, but their square responses are
  `other` and `one`; horizon one is insufficient.
- `2` and `3` are distinct constructors but remain equal at every autonomous
  response; constructor identity is strictly finer than this task requires.

## Universal finite code bound

Suppose an arbitrary code type receives every installed multiplier and a
decoder exactly returns its `Fin 4` predictive class.  Choosing one explicit
representative of each class injects `Fin 4` into the code.  Therefore every
finite exact code alphabet has cardinality at least four.  Encoding directly
by the classifier attains cardinality four.

This is a classical deterministic zero-error code theorem.  It does not prove
the sampled note's Hilbert-support orthogonality statement, construct density
operators or a physical memory, or establish a quantum dimension theorem.

## Relation to existing results

`notes/SEPARATING_POINT_COLLAPSE.md` already states the general autonomous
prime formula `d(p-1)+1` in prose, and `OrbitSeparation.agda` checks the
different selectable/invertible separating-point collapse.  The present leaf
adds the missing checked `p=5` autonomous instance: the finite-horizon iff,
the exact class kernel, its surjectivity, strict controls, and the universal
finite code bound with attainment.  No novelty is claimed for finite-state
periodicity or quotient minimization.

No theorem here covers selectable multipliers, optimal experiment design,
arbitrary primes, the divisor-count formula, coherent control, a quantum
speedup, process tensors, thermodynamics, or installation authority.

## Literal Draw 8 provenance

The no-redraw encounter froze freshly fetched origin commit
`a0002dd7dda7c606b8097de89d12ffbbaf061a99`, tree
`5ebe0ea45a36382f0af09c7e1b035da36828ef88`, and a C-sorted frame of 1,077
tracked semantic `.agda`, `.lean`, and `.md` paths under `formal/`, `notes/`,
and `papers/`, excluding build products and this identity's seven earlier
samples.  The frame SHA-256 was
`f0a26e7e90abb330d774b590c64e9f46c3fab4eac4ec15243edbeb5b641e7e38`.
With rejection limit `4294967223`, the sole `/dev/urandom` uint32
`1975215554` was accepted with zero rejections at zero-based index 785
(position 786), selecting `notes/MOD5_PREDICTIVE_QUANTUM_PROFILE.md`, blob
`638e942e2f8f24a39994fdf56cb6f6e57037cde1`.  There was no redraw.

Focused replay:

```sh
cd formal/pairfield
lake env lean Pairfield/ModFiveAutonomousProfile.lean
```
