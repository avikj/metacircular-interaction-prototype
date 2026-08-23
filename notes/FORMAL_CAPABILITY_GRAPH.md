# Formal capability graph: checked joints, not an import catalog

## Result

Two native proof-language modules now index the capabilities that actually
compose:

- `formal/pairfield/Pairfield/CapabilityGraph.lean` contains typed terms for
  the diagonal Smith producer to presentation to certificate to Boolean
  checker chain, the complete unimodular `2×2` certificate stratum, explicit
  rank-one outer-product/Bézout witnesses, and the observed-action to
  residual-language to behavioral-consumer chain.
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

1. ~~**Arbitrary integral `2×2` matrix to Smith presentation.**~~  **CLOSED
   2026-08-12 by `claude_certificate_compiler`**, see
   [`GENERAL_SMITH_PRODUCER.md`](GENERAL_SMITH_PRODUCER.md).  The inhabitant is
   `Pairfield.arbitrarySmithPresentation'` in
   `formal/pairfield/Pairfield/GeneralSmith2x2.lean`, built from the total
   executable producer `Pairfield.smith`.  **The type below needs one repair
   before it can be inhabited:** `X × (P ∧ Q)` does not elaborate, because `×`
   is `Prod : Type u → Type v → Type _` and the conjunction is a `Prop`;
   replacing the product by a subtype `{ _p : X // P ∧ Q }` preserves the
   intended content and does elaborate.  Reproduced verbatim in a Mathlib-free
   environment.  Nothing else in this file is affected — and that is the point:
   an uninhabited type is the one declaration nothing downstream typechecks
   against, so recording open edges as types (which is right) needs a bare
   `#check` beside each one to force elaboration. `smithCertificate_valid` proves
   the emitted certificate valid for *every* input, so no witness extraction is
   needed after all.  Recording this joint as an uninhabited **type** rather
   than as prose is what made the closure one import; that is a reusable
   property of this file's design, not of the Smith problem.

   The struck text, for the record: *"Lean names the required dependent output
   as `ArbitrarySmithPresentation`.  The current graph closes diagonal coprime
   joins, every determinant `±1` matrix, and rank-one matrices supplied with
   exact outer-product/Bézout witnesses, then checks their certificates.  It
   does not yet extract those witnesses from a bare singular matrix or reduce
   every full-rank nonunimodular input."*
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

   **Refinement 2026-08-14.**
   `formal/cubical/ResponseCharacterKickback.agda` now checks the algebraic
   boundary of this joint: a clean returned response eigenstate induces a
   response-group character; the Boolean character supplies the Grover sign,
   while every additive-trit sign character is trivial. This does **not** close
   the circuit-semantics joint above. It replaces one untyped open edge by a
   typed fork and identifies exactly which interface a future circuit must
   realize.

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
  Pairfield.MyhillNerodeAdapter Pairfield.RankOneSmith2x2
lake env lean Pairfield/CapabilityGraph.lean

cd ../..
agda --ignore-interfaces -i formal/cubical \
  formal/cubical/NaturalMachine/CapabilityGraph.agda
```
