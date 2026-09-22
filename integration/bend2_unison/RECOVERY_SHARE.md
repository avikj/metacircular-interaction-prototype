# Bend2/HVM Unison integration

## Patch overlays

The patch artifacts are:

* `cli/ucm-bend-artifact-cache.patch`
* `cli/ucm-bend-divergent-merge.patch`
* `cli/ucm-bend-view-display.patch`
* `storage/unison-bend-role-graph.patch`

They are applied in their documented order after the base core.

## Core inventory

The core includes pure
Haskell modules under `admission/Core`, `reify/Core`, `storage/Core`, and
`execution/Core`; fixture Bend files under `admission/fixtures`; Python live smoke
tests under `cli`; and a single canonical integration README. The source names are:

* `reify/Core/Reify.hs`, for converting checked Bend members into the canonical
  structural component representation and preserving authored presentations.
* `storage/Core/ComponentPlan.hs`, for component membership, SCC ordering, canonical
  bytes, dependencies, and deterministic object identities.
* `storage/Core/FlatCodec.hs`, for the versioned canonical structural codec and
  decode/validation round trips.
* `storage/Core/SemanticIdentity.hs`, for the checked semantic identity index. The
  sound initial implementation intentionally handles the closed Nat numeral,
  lambda, and application fragment, confirms equality with Bend `Core.Equal.equal`,
  and preserves structural objects and provenance.
* `storage/Core/SyncEnvelope.hs`, for JSON and CBOR native entity envelopes, source
  provenance, spans, dependencies, and validation.
* `storage/NativeTransactionRoundtrip.hs`, `storage/ProtocolHttpRoundtrip.hs`,
  `storage/SyncWireTest.hs`, and `storage/DependencyGraphTest.hs`.
* `execution/Core/HVM4.hs` or its equivalent adapter, for invoking the pinned HVM4
  binary, collecting result text, interaction count, heap size, and trace data.

The fixtures include the cubical path transport Bend program, imported
multi-file Bend members, and the minimal direct HVM regression. The known canonical
fixture is `collab/bend2-interactive-cubical/path_transport.bend`; its direct HVM result is
`0 #4992`, with 4992 interactions and heap size 22157. A reduced `t_fwd_neg.bend`
fixture reports 146 interactions and heap size 3701.

## API contract

The admission layer must accept UTF-8 Bend source and emit one checked member record
per declaration. A member record carries its logical namespace path, source file,
member name, declaration kind, checked type, authored source bytes, start/end byte
offsets, and native structural term. A file may import another Bend file. Imported
members retain their own source path and offsets; the importing file must not flatten
or overwrite provenance.

Reification produces a closed canonical term graph. Names are excluded from structural
hashing where the term graph permits it, while authored names and source spans remain
separate metadata. Recursive groups are encoded as deterministic SCCs. The canonical
codec is version tagged and rejects malformed tags, lengths, references, and trailing
bytes. Dependency extraction records term references and type references; when a
definition also has an associated HIT slot, conservative dual-role edges are allowed.

Native storage uses the existing Unison SQLite object database. Native Bend objects
must be identifiable as a separate object-kind/type-4 envelope, but use the same
transaction and branch machinery as ordinary Unison objects. Every stored entity must
round trip exact canonical bytes, dependency list, authored presentation bytes, and
per-member source spans. Temporary sync entities must validate hashes before import.

Execution accepts a stored native term or checked member, closes unused definitions,
invokes HVM4, and returns the machine result plus interaction and heap counters. The
adapter must never invoke the legacy HVM3 path for a Bend member. The fixture regression
must remain `0 #4992` after storage export/import and after sync.

## Exact live acceptance tests

The main UCM smoke test is `cli/live_ucm_smoke.py UCM_BIN HVM4_BIN`. It creates a fresh
codebase, loads `path_transport.bend`, checks `ls`, `find`, and `signature`, runs the
main member and the file, checks result and counters, renames and undoes, updates the
term, checks history, forks a branch, updates and merges, and verifies file watcher
admission. The expected result is `0 #4992` and 4992 interactions for the original
fixture; an updated zero term gives `1 #0`.

`cli/live_import_smoke.py` tests explicit imports. It verifies that `main` belongs to
the main file while imported `two` belongs to `Library.bend`, including the UTF-8 pi
comment span. The HTTP root and nested subterm endpoint and LSP cross-file definition
lookup must report the same paths and byte ranges.

`cli/live_sync_smoke.py` creates two fresh codebases and exercises native
`sync.to-file` and `sync.from-file`. Exactly 22 native type-4 objects, the HIT name,
and two causal history states must move. Destination undo must restore the prior main
and HVM must still produce `0 #4992`.

`cli/headless_http_smoke.py` starts UCM without a PTY and checks authenticated native
subterm HTTP, browser HTML, branch-aware term links, and HIT links. The local LSP
smoke checks empty diagnostics, typed hover, and go-to-definition.

The pure storage acceptance commands are the compiled test executables listed above.
`NativeTransactionRoundtrip` must store 22 components, export/import them through a
temporary entity, and reproduce canonical bytes and HVM output. `ProtocolHttpRoundtrip`
tests the loopback Share v1 request/response shape; it is not production Share.
