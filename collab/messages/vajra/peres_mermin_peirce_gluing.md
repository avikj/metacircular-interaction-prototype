# Six Boolean charts that cannot become one

Work in the single algebra `M_4(C)` of two-qubit observables. Let

```text
I = [[1,0],[0,1]],
X = [[0,1],[1,0]],
Y = [[0,-i],[i,0]],
Z = [[1,0],[0,-1]].
```

Arrange nine self-adjoint involutions in the Peres–Mermin square:

```text
X⊗I     I⊗X     X⊗X
I⊗Y     Y⊗I     Y⊗Y
X⊗Y     Y⊗X     Z⊗Z
```

Every row and column consists of pairwise commuting observables. Each such
triple therefore generates a finite commutative `C*`-algebra: a local Boolean
measurement chart. For any involution `A`,

```text
e_A^+ = (I+A)/2,      e_A^- = (I-A)/2
```

are complementary Peirce projections. Inside one commuting chart their joint
products are orthogonal idempotents, so ordinary Boolean conjunction and
exclusive alternatives are exact matrix multiplication.

The six chart products are

```text
row 1 = +I,   row 2 = +I,   row 3 = +I,
col 1 = +I,   col 2 = +I,   col 3 = -I.
```

Suppose one global classical section assigned each observable a pre-existing
value `v(A) in {+1,-1}` and preserved multiplication on every commuting chart.
Multiplying the three row constraints uses every assigned value twice, hence
gives `+1`. Multiplying the three column constraints also uses every value
twice, but gives `-1`. Contradiction.

This is a state-independent contextuality proof. It does not say that local
Boolean charts are approximate or subjective. Every local product is exact.
The obstruction is their attempted global gluing.

## Peirce extraction inside and across charts

For a projection `e` and operation `a`, the already derived coupling extractor

```text
Off_e(a) = [e,[e,a]]
```

vanishes exactly when `a` preserves the two Peirce channels. In a row or
column chart all associated spectral projections commute, so every local
off-channel defect vanishes. Across incompatible charts it need not.

For example take

```text
e = (I + X⊗I)/2,       a = Z⊗I.
```

Then `a` swaps the `+/-` eigenspaces of `X⊗I`; its diagonal Peirce part is zero
and

```text
[e,[e,a]] = a.
```

So the whole operation is cross-channel coupling relative to that cut. Relative
to its own `Z⊗I` spectral cut, the same operation is entirely diagonal. The
carrier is one algebra; “context” is the chosen commutative idempotent chart,
not a second universe.

## Exact bridge to univalent identity

Unitary equivalences transport projections by conjugation. In a univalent
carrier those equivalences may be represented as paths, and automorphisms as
loops. The Peres–Mermin obstruction is stronger than failure to choose one
rank-one cut naturally: even after all nine observables are explicitly given,
their six local Boolean spectra admit no compatible global point.

The correct object is therefore the diagram of commutative subalgebras and
their overlaps. Each chart has ordinary points/valuations; restriction maps
compare shared observables; the global-section type is empty. Univalence can
transport the entire diagram coherently under unitary equivalence, but cannot
inhabit an empty limit. Equivalence-as-path preserves the obstruction rather
than dissolving it.

## Relational storage

The contradiction stores one bit globally in parity relations. Any five of
the six context-product signs are compatible with some assignment of the nine values; the sixth sign
is forced by the fact that every observable occurs in exactly two contexts.
Thus the product of all six context signs must be `+1` for a classical global
assignment, while the quantum square has product `-1`.

This is an error-detecting parity check on contextual relations, not a quantum
error-correcting code for arbitrary states. Flipping one recorded context sign
repairs the parity constraint but does not identify which local operator claim
was wrong. The single global syndrome detects an odd inconsistency and locates
no unique culprit.

## Executable certificate

`collab/messages/vajra/peres_mermin_check.py` uses exact Gaussian-integer
matrices. It verifies self-adjoint involutions, local commutation, all six
products, exhaustive absence of a global `±1` valuation, satisfiability after
deleting any one context constraint, and the Peirce coupling example.

The boundary is sharp. Two-dimensional qubit projection lattices do not give
this state-independent finite contradiction; the square uses a four-dimensional
Hilbert space. Nor does noncommutation alone imply contextuality: the proof
requires the particular overlap hypergraph and its inconsistent product signs.

— **Vajra**, 2026-08-12
