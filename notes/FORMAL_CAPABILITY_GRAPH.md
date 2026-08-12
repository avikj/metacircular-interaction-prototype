# Formal capability graph: checked joints, not an import catalog

## Result

Two native proof-language modules now index the capabilities that actually
compose:

- `formal/pairfield/Pairfield/CapabilityGraph.lean` contains typed terms for
  the diagonal Smith producer to presentation to certificate to Boolean
  checker chain, the complete unimodular `2×2` certificate stratum, and the
  observed-action to residual-language to behavioral-consumer chain.
- `formal/cubical/NaturalMachine/CapabilityGraph.agda` contains the symmetry
  carrier fork and the native Smith dependent eliminator.  Every closed edge
  is checked by Lean or Cubical Agda; an import without a term is not counted.

The graph exposed one important correction.  The Cubical symmetry chain is
not

```text
factorial cardinality -> permutation action -> observational stabilizer.
```

It is

```text
                         -> factorial cardinality (lossy)
permutation carrier -----|
                         -> register action -> response/stabilizer
```

The count `n!` cannot reconstruct an action.  Both projections originate in
the proof-relevant carrier `Fin n ≣ Fin n`.  Encoding the tempting linear
chain would manufacture a nonexistent edge precisely where decategorification
forgot the executable datum.

## First open typed joints

1. **Arbitrary integral `2×2` matrix to Smith presentation.**  Lean names the
   required dependent output as `ArbitrarySmithPresentation`.  The current
   graph closes diagonal coprime joins and every determinant `±1` matrix, then
   checks their certificates.  It does not yet construct a presentation for
   every rank-one/nonunimodular input.
2. **Symmetry response equality to an observational-class carrier.**  Cubical
   Agda names the required interface as `ObservationalClassCompiler`: a class
   type, class map, and an equivalence between class equality and equality of
   complete declared responses.  The repository currently has the relation
   and stabilizer laws, not this quotient carrier.
3. **Classical response oracle to coherent phase oracle.**  The worker result
   in `collab/messages/workers/20260812T161511.752509Z--codex_quantum_process--0016.md`
   proves its query separation only relative to a coherent phase-threshold
   oracle and explicitly leaves compute--phase--uncompute pricing open.  No
   native quantum circuit semantics implementing that adapter is present in
   the checked Lean/Cubical graph, so no edge is asserted here.  This is an
   upstream semantic gap, not a missing import.

## Rigor boundary

The Lean and Agda source files are kernel-checked capability witnesses.  This
note explains their topology and the open API types.  It does not prove that
the named open interfaces are uninhabitable; “open” means no checked inhabitant
is installed in the repository.  The quantum boundary is a provenance link to
an exact worker artifact, not a formal theorem in either current proof kernel.

## Replay

```sh
cd formal/pairfield
lake build Pairfield.ComputableSmith2x2Adapter Pairfield.DirectSmith2x2 \
  Pairfield.MyhillNerodeAdapter
lake env lean Pairfield/CapabilityGraph.lean

cd ../..
agda --ignore-interfaces -i formal/cubical \
  formal/cubical/NaturalMachine/CapabilityGraph.agda
```
