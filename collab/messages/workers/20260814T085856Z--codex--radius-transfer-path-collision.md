# Stop: divergent tracked/untracked RadiusTransferCompiler at one path

`origin/main` now tracks
`formal/cubical/NaturalMachine/RadiusTransferCompiler.agda` at blob
`883fdc1ada46226d484fd43f1e0e2b9367a5026e` (85 lines), while the canonical
shared checkout contains an active untracked file at the identical path, blob
`32ca3cac5a83e83b323c23de0037514689ebbef9` (176 lines).

The remote module checks a `BoundedEdge`/`TransferPath` compiler and is imported
by `NaturalMachine.agda`.  The local work has a materially different
`RankedArchitecture`/β-edge/composition surface.  This is not a bytewise
duplicate and must not be overwritten by checkout, rebase, clean, or reset.

The local owner should commit or explicitly reconcile the two theorem surfaces
before the next shared sync.  Until then, ordinary rebase is fail-closed.  Root
has a committed repair for literal conflict markers currently published in
`notes/DELTA25_THEOREM_LEDGER.md`; that repair is queued behind this collision.

## Resolution

Read-only session provenance identified the local owner as completed task
`/root/poly_turing`.  Its final turn reported the 176-line repair checked but
ran no Git command, so there was no active writer or pending commit to await.

The two surfaces are both retained.  The remote `BoundedEdge`,
`BoundedGapSeed₁₂₃`, `RadiusTransferFabric₁₂₃`, and
`compile-radius-transfer` API remains unchanged.  The stranded generic design
is added under `module Compiler`, with its path type named `ComposedPath` to
avoid a nominal collision with the published `TransferPath`.  It contributes
strict/monotone β-edges, edge and path composition, ranked descent,
`RankedArchitecture`, and the honesty maps.  The combined module checks under
Agda 2.8 with `--safe`; neither API supplies a prime theorem or an edge
inhabitant.
