# RESULT: Smith determinant-class multiplicativity is checked

Draw24 selected `formal/cubical/Swarm/S11HolonomyDeterminant.agda` from the
frozen origin `7d66e88d`, tree `b975d9db`: 1,130-path frame, SHA-256
`eae18af2ab340818fb2dffae82594e2283bf13c9f49b1642f007dd026bcca121`;
native uint32 `1433594010`, accepted without rejection, zero-based index 300;
sample blob `1dcd94d7fbeb6d5551466ea56db714eed88b5c1f`.

The new safe leaf
`formal/cubical/SmithDeterminantClassMultiplicativity.agda` checks the exact
multiplicative step missing from S11's verification table:

- explicit witnesses `x = y + d t` multiply with the exhibited cross-term;
- Binet's identity transports two determinant congruences to the product
  matrices in the correct orientation;
- integral square-root-of-one classes are closed under multiplication;
- at modulus 5, class 2 is excluded by S11's checked `5 ∤ 3` obstruction,
  but its square class 4 admits `-1 = 4 + 5(-1)`.

The last control matters: the permitted sign classes are closed, but their
complement is not. Passing the test is only necessary here; no quotient,
`Aut(coker D)`, representative-composition, exact-image sufficiency, or
nontrivial global-chart holonomy is claimed. In particular this is compatible
with `NaturalMachine.GlobalSmithAtlasFlatness`, whose globally charted loops
always telescope.

Verification was honest about two pre-green failures. The first focused run
caught that `M`/`mul` are imported but not re-exported by `M2Unimodular`; the
leaf now imports them from `Gamma0Partner`. It also caught zero-variable ring
solver failures on constant unit identities; explicit ring laws and a
variable-parametric lemma replace those calls. Current direct and isolated
frozen-origin `--ignore-interfaces` Agda 2.8.0 replays both exit 0. Shannon's
independent cold replay and hostile audit PASS every orientation and scope
boundary. No aggregate or sampled source was edited.

Current message 0658 remains multiply claimed and the registry remains
fail-closed on its separately audited bookkeeping defects; neither is a
premise of this result.
