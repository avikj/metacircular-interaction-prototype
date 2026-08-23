# Smith determinant classes multiply

## Result

`formal/cubical/SmithDeterminantClassMultiplicativity.agda` checks the
multiplicative step left informal by
`formal/cubical/Swarm/S11HolonomyDeterminant.agda`.

For integers, define the proof-relevant congruence witness

```text
Modulo d x y = Σ t : ℤ, x = y + d t.
```

The checked theorem `modulo-mul` sends witnesses

```text
x  = y  + d s
x′ = y′ + d t
```

to the exhibited witness

```text
x x′ = y y′ + d (y t + y′ s + d s t).
```

Using the existing checked Binet identity `M2Unimodular.detMul`,
`determinant-product-class` therefore proves

```text
det H  ≈ det C  (mod d)
det K  ≈ det B  (mod d)
--------------------------------
det(HK) ≈ det(CB) (mod d).
```

This is the exact witness-level content of multiplicativity of the
determinant class.  `det-shift-class` also repackages S11's checked
representative-change polynomial for
`D = diag(d, q d)` in the same `Modulo` type.

## The sign-class boundary

The leaf defines

```text
SignClass d δ = Σ ε t : ℤ,
  (ε = δ + d t) × (ε² = 1).
```

This is a witness that a residue class passes the necessary integral
determinant condition.  `sign-class-mul` proves these witnesses are closed
under multiplication.

The modulus-five control prevents a tempting converse reading:

- `five-two-excluded` reuses S11's `squareObstruction` and `5 ∤ 3` to
  prove that class `2` has no such lift;
- `five-two-square-allowed` exhibits `-1 = 2·2 + 5(-1)`, so the square of
  that excluded class does have a sign witness;
- `excluded-times-excluded-can-be-allowed` packages the two facts.

Thus the sign classes are multiplicatively closed, but their complement is
not.  In particular, “fails the determinant test” is not itself a subgroup
or a conserved Boolean under multiplication.

## Relation to the sampled source

The sampled S11 leaf already checks two ingredients:

1. replacing a representative `C` by `C + D E` changes its determinant by
   an exhibited multiple of the first Smith invariant `d`;
2. for `d = 5`, the class of `diag(2,1)` cannot be represented by an
   integral matrix whose determinant squares to one.

Its accompanying
`collab/swarm/2026-08-14/swarm-0814-11-holonomy-determinant.md` states that
the induced determinant is multiplicative, but its verification table does
not contain that law.  The present leaf supplies precisely that missing
algebraic step.  It does not formalize the accompanying note's prose proof
of the exact image.

## Scope fences

- `Modulo` is an explicit Sigma witness, not a constructed quotient ring.
- No type `Aut(coker D)` is defined here, and no map from a Smith-event
  torsor to such an automorphism group is packaged.
- Passing `SignClass` is only the necessary determinant test.  The leaf does
  **not** prove that every passing class has a holonomy lift.  The CRT,
  cofactor, and `SLₙ(ℤ) → SLₙ(ℤ/N)` sufficiency argument in the swarm
  note remains prose-grade.
- The theorem does not prove that arbitrary matrix representative relations
  compose.  It assumes the two determinant congruence witnesses and
  transports them through the already checked determinant product identity.
- `NaturalMachine.GlobalSmithAtlasFlatness` concerns transition maps of
  globally defined charts on one common type, whose closed loops telescope.
  Nothing here produces a nonidentity global-chart loop: this leaf concerns
  multiplicative residue information for matrix representatives.
- There is no classification for every modulus, no cardinality/index result,
  no Smith-normal-form algorithm, and no runtime or physical claim.
- The determinant-class analogy is not a reduction of historical or
  contemplative accounts of holonomy, relation, or reflection to this
  arithmetic invariant.

## Verification

The leaf is Cubical Agda with `--safe`, no holes, and no postulates.  It was
checked under Agda 2.8.0 with the repository Cubical library by an
ignored-interface replay:

```text
cd formal/cubical
agda --ignore-interfaces -i . SmithDeterminantClassMultiplicativity.agda
```

The command exited `0`.

## Draw provenance

The read-only draw was frozen at origin/main
`7d66e88d354b324dbbc05ae81409ef2e4618bd92`, tree
`b975d9dbcbd3c0b54d77b6cd09c77f4320a0c6b3`.  The C-sorted semantic frame
contained 1,130 tracked `.agda`, `.lean`, and `.md` files under `formal/`,
`notes/`, and `papers/` after build/Python exclusions and removal of the 23
prior samples; its SHA-256 was
`eae18af2ab340818fb2dffae82594e2283bf13c9f49b1642f007dd026bcca121`.
With rejection limit `4294967280`, the sole native `/dev/urandom` uint32
`1433594010` was accepted without rejection and selected zero-based index
`300`: `formal/cubical/Swarm/S11HolonomyDeterminant.agda`, blob
`1dcd94d7fbeb6d5551466ea56db714eed88b5c1f`.
