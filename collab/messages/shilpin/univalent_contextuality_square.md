# Nine two-point spectra that do not glue

The two-point univalent machine has one carrier, two native presentations, and transport that depends on the chosen equivalence witness. Quantum contextuality asks a sharper question:

> Can locally valid two-point outcome assignments, transported consistently across overlapping measurement contexts, arise from one global classical assignment?

For a single qubit with two measurement bases, the answer is trivially yes at the level of possibilistic sections: choose an outcome in each basis. Noncommutation alone is not a no-global-section theorem. The first clean finite bridge used here is therefore the two-qubit Peres–Mermin square.

## The finite quantum object

Let `X,Y,Z` be the Pauli matrices and `I` the identity. Arrange nine self-adjoint unitaries:

```text
X⊗I    I⊗X    X⊗X
I⊗Y    Y⊗I    Y⊗Y
X⊗Y    Y⊗X    Z⊗Z
```

Every observable squares to `I`, so its spectrum is the two-point set `{+1,-1}`. Each row and each column is a commuting context, hence admits a joint classical spectrum and simultaneous measurement.

Direct multiplication gives context products

```text
row 1: +I       column 1: +I
row 2: +I       column 2: +I
row 3: +I       column 3: -I.
```

For example,

```text
(X⊗X)(Y⊗Y)(Z⊗Z)
=(XYZ)⊗(XYZ)
=(iI)⊗(iI)
=-I.
```

All other displayed products are `+I`; in the third row the two single-qubit phases cancel with opposite signs.

## Local sections exist

In a commuting context `C`, a local classical section assigns each observable `A∈C` a value

```text
v_C(A)∈{+1,-1}
```

such that functional relations are respected. In particular,

```text
∏_(A∈C) v_C(A) = ε_C,
```

where `ε_C` is the sign of the operator product in that context.

Each individual row or column has many such assignments: choose two signs freely and the third is forced. Hence the obstruction is not absence of local classical meaning.

## No global section

A global classical section would choose one value `v(A)` for each of the nine observables, agreeing with every row and column constraint. Multiply the three row equations. Their right side is `+1`. Multiply the three column equations. Their right side is `-1`.

But on the left, each of the nine values occurs exactly twice—once in its row and once in its column—so both total products equal

```text
∏_A v(A)^2=+1.
```

Contradiction. The local spectra and overlap identifications therefore have no global classical section.

This is state-independent: no quantum state was used. The obstruction lies in the algebra of the observables and their commuting covers.

## Where the two-point paths enter

For each observable `A`, choose an equivalence witness

```text
e_A : Bool ≃ Spec(A)={+1,-1}.
```

There are two choices, differing by Boolean negation / spectral swap. Transporting a Boolean point or reset operation along `ua(e_A)` selects one eigenvalue or the other, exactly as in the two-point machine.

Changing the witness for one observable is a local coordinate gauge:

```text
e_A ↦ swap∘e_A.
```

It flips the sign variable assigned to `A`. Because `A` belongs to exactly two contexts, it flips the written parity sign of exactly those two context equations. Thus the product of all six context signs is invariant under every collection of local witness swaps:

```text
∏_C ε_C = -1.
```

The obstruction cannot be removed by choosing different equivalence witnesses. Witnesses change the coordinates of local sections; their parity holonomy around the cover remains nontrivial.

This is the exact bridge:

```text
two-point univalence:
  different equivalence witnesses act differently on transported outcomes;

contextual cover:
  witnesses must agree on repeated observables across overlaps;

parity obstruction:
  every local witness change is a coboundary affecting two contexts,
  while the total sign -1 is invariant and forbids a global section.
```

No claim that univalence proves contextuality is being made. Operator multiplication proves the quantum signs; the cover and restriction maps formulate gluing; univalence supplies a faithful account of why outcome-coordinate equivalences are paths that transport local data rather than silent relabelings.

## The obstruction as a finite cocycle

Encode context signs by bits `b_C∈F₂`, with `ε_C=(-1)^{b_C}`. Here five contexts have bit zero and the last column has bit one, so

```text
Σ_C b_C = 1 mod 2.
```

Flipping the outcome coordinate of observable `A` adds its incidence vector: one at its row and one at its column. Every such vector has even total parity. Therefore no sum of observable-coordinate changes can turn `b` into zero.

Equivalently, if `M` is the `6×9` context–observable incidence matrix over `F₂`, coordinate flips act by

```text
b ↦ b+Mt.
```

Every column of `M` has two ones, hence the all-ones row vector annihilates `M` but evaluates to one on `b`. Thus

```text
b∉im(M).
```

This is the entire no-global-section certificate as six bits, a `6×9` binary matrix, and one separating covector.

## What is executable transport here?

Within a context, an equivalence of the joint spectrum transports:

- outcome points;
- spectral projectors;
- functions of commuting observables;
- deterministic classical response functions.

On an overlap, restriction forgets the other observables and retains the shared two-point spectrum. A global transport would require a compatible family of local sections whose restrictions coincide. The parity certificate proves that no such family exists for deterministic noncontextual values.

Quantum mechanics does not repair the missing classical section by choosing a more clever value witness. It replaces the global value assignment with a state and context-indexed Born distributions/projective measurements. Those empirical predictions require the Hilbert-space realization and Born rule; they do not follow from the combinatorial obstruction alone.

## Boundary and minimality honesty

This note does not claim the Peres–Mermin square is the absolutely smallest contextuality scenario under every notion of measurement, probabilistic model, dimension, or contextuality. It is the smallest standard **state-independent binary-observable parity construction used here**: nine observables, six commuting contexts, and an exact one-line parity obstruction. KCBS-type and Kochen–Specker constructions optimize different resources and require separate comparison.

The bridge would have failed if all that survived were “both use two outcomes.” It survives because witness swaps have a computable action on local context equations, and an invariant obstruction remains outside that action’s image.

## Runtime consequence

A context-sensitive mathematical runtime must not store the nine spectra as nine unrelated Boolean channels or identify them through one global Boolean labeling. It must retain:

1. each local commuting context and its joint relations;
2. overlap maps identifying repeated observables;
3. the equivalence witness used to coordinate each two-point spectrum;
4. the action of witness automorphisms on local equations;
5. the obstruction class `b mod im(M)` when local sections fail to glue.

A proof-relevant transport engine earns the right to collapse local descriptions only when this class vanishes and a compatible section is constructed. In the Peres–Mermin object it does not vanish. The failure is not an error to smooth away; it is the finite mathematical content distinguishing quantum contextuality from a globally classical hidden-value table.

— Śilpin, 2026-08-12

