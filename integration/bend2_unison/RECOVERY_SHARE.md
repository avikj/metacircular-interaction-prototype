# Bend2/HVM Unison integration recovery log

This file is the durable handoff for recovery after the first integration pass was
partly deleted from the working tree. It is deliberately kept inside the integration
directory and is updated before each meaningful recovery batch. Every source recovery
must be committed immediately. The repository contains substantial unrelated changes;
recovery work must stage only files below `integration/bend2_unison` unless a specific
Unison overlay is being restored.

## Incident and current evidence

The first implementation was developed in a shared checkout with many files untracked.
An agent cleanup removed the untracked source files before they were committed. The
following commits are the durable checkpoints known at recovery start:

* `32ac713ef` recorded surviving integration artifacts.
* `d460461a3` recovered and committed `admission/Core/Admission.hs`.

Git history does not contain the other deleted source modules. Git object inspection
did not expose additional unreachable commits. Several independent temporary Unison
checkouts, generated patch files, compiler objects, binaries, logs, and the Bend/HVM
source trees remain available. These are the recovery evidence. Do not claim that a
temporary compiled binary proves source recovery: source and reproducible build inputs
are required.

## Surviving files

The current integration directory has the following important surviving material.

`admission/Core/Admission.hs` is the restored native admission implementation. It
contains the Bend source parser/admission boundary, member metadata, authored source
provenance, byte spans, checked type information, and native component plan generation.
It is the starting point for restoring the rest of the pure core.

`storage/Core/*.hi` and `storage/Core/*.o` are compiler products for the deleted pure
storage modules. Their presence can help identify exported symbols with `ghc -ddump-
iface`, but object files are not a substitute for source and should not be checked in
as the only implementation. The relevant modules are `ComponentPlan`, `FlatCodec`,
`SemanticIdentity`, and `SyncEnvelope`.

The storage tests whose compiler products remain are `NativeTransactionRoundtrip`,
`ProtocolHttpRoundtrip`, `SyncWireTest`, and `DependencyGraphTest`. Their source is
missing and should be reconstructed from the APIs exercised by the compiled objects,
the generated patch overlays, and the recorded command logs.

The patch artifacts currently present are:

* `cli/ucm-bend-artifact-cache.patch`
* `cli/ucm-bend-divergent-merge.patch`
* `cli/ucm-bend-view-display.patch`
* `storage/unison-bend-role-graph.patch`

These are small later overlays, not the complete original integration. They should be
preserved verbatim and applied in their documented order after the base core is
restored. Earlier larger overlays may be present in temporary checkouts and must be
copied into this directory only after comparing them byte-for-byte.

## Deleted or missing core inventory

The missing core is known from the prior build and test records. It included pure
Haskell modules under `admission/Core`, `reify/Core`, `storage/Core`, and
`execution/Core`; fixture Bend files under `admission/fixtures`; Python live smoke
tests under `cli`; and a single canonical integration README. The exact source names
to locate or recreate are:

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

The missing fixtures include the cubical path transport Bend program, imported
multi-file Bend members, and the minimal direct HVM regression. The known canonical
fixture is `collab/bend2-cubical/path_transport.bend`; its direct HVM result is
`0 #4992`, with 4992 interactions and heap size 22157. A reduced `t_fwd_neg.bend`
fixture reports 146 interactions and heap size 3701. These are stable recovery
anchors, not new claims about the cubical implementation.

## Recovered API contract

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
definition also has an associated HIT slot, conservative dual-role edges are allowed
until origin-role metadata is restored.

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
tests the loopback Share v1 request/response shape; it is not production Share. The
Share server itself must be tested separately with PostgreSQL and Hasql before a
production readiness claim.

## Temporary evidence and builds

The pinned Unison source is commit `84b95a623711b57b9ff7163f124b214d626b81e4`, found
in several `/private/tmp/unison-*` checkouts. The most complete build trees include
`/private/tmp/unison-bend-exact-20260917` and
`/private/tmp/unison-bend-desktop-final-check`. Compare these trees for overlay source
before copying. Build logs under `/private/tmp` include the strict UCM builds,
semantic build, headless HTTP run, and Share builds.

The reproducible preparation script, once recovered, must vendor HVM3/highlight,
apply Bend parser metadata and ordered native overlays, then build `unison-cli-main`
with the direct Command Line Tools compiler. A pristine patch-only dry run and a full
independent clean build previously passed through UCM registration. Re-run those
checks after every recovered source batch.

## Recovery procedure

First recover pure source from any temporary checkout or agent workspace and compare
its imports and exported symbols against the surviving `.hi` interfaces. Copy with
`apply_patch`, stage only the recovered file, and commit immediately. Record the commit,
source, and evidence here. Next reconstruct the fixtures and pure tests, then rebuild
the storage round trip. Only after pure tests pass should the UCM overlays be reapplied.
Finally run the live UCM, import, sync, HTTP, LSP, desktop, and Share checks.

Every agent must read this file before editing, append a short timestamped note after
each unit of work, and communicate collisions to the other agents. No cleanup agent
may delete untracked files. Use `git status --short` before and after each operation;
commit integration files at least once per minute while active. If a generated build
tree is needed, place it under `/private/tmp` and leave the source and patch in Git.

## Known limitations to preserve honestly

General mathematical semantic identity for arbitrary dependent terms, paths, HITs,
and recursive programs is not yet implemented merely because the cubical checker can
prove equality. The checked narrow identity index must remain sound and versioned.
Structural addresses and authored provenance must remain available even when semantic
peers are displayed. The local loopback Share protocol is a fixture; production
authentication, PostgreSQL migrations, and remote push/pull require their own run.
The Desktop renderer build and backend link resolution have been exercised, but GUI
click automation was unavailable. These limitations do not justify redesigning the
Bend language or adding a second source syntax.

## Recovery notes

* 2026-09-17: created this handoff after confirming only admission source, later
  overlays, tests' compiler products, and build evidence survived in the workspace.

* 2026-09-17: regenerated `storage/unison-share-server-bend.patch` from the
  intact `/private/tmp/share-bend-baseline` and
  `/private/tmp/share-bend-forward-green.9IaP9w` trees. It covers backend,
  PostgreSQL causal/entity/serialization/sync modules, web sync modules,
  SyncV2 queries, the Bend migration, and `stack.yaml`. The patch has 905
  unified-diff lines and portable `a/` and `b/` paths. Forward application was
  verified with `patch -p1 --dry-run` against the baseline; all 11 expected
  files patched and the command exited zero. Commits: `6ed19b36e` ledger,
  `6e5ce3edd` recovered patch, `ec5ec87e9` portable paths.

* Build evidence recovered from `/private/tmp/share-bend-server-build9.log`:
  Stack compiled all 192 Share modules, linked the `share-api` executable,
  and registered the library successfully. PostgreSQL 15.4 evidence is in
  `/private/tmp/share-pg15-migrations.log`: the native migration applied with
  `ALTER TYPE`, native table/index/function creation, and zero errors. The
  fixture `/private/tmp/share-pg15-bend-fixture.log` inserted 22 native rows
  in one transaction and committed successfully. These are local source and
  database checks; authenticated remote Share push/pull is still an explicit
  production gate.

* Reverse application was also verified against
  `/private/tmp/share-bend-forward-green.9IaP9w` with
  `patch -R -p1 --dry-run`; all 11 files reversed and the command exited
  zero. The recovered artifact is therefore bidirectionally portable.

* Added `storage/regenerate_share_patch.sh` so the patch can be rebuilt from
  any clean and forward source pair. A generated patch was independently
  forward dry-run against the baseline and patched the same 11 files with
  exit status zero. Diff timestamps make raw patch checksums differ between
  runs; file contents and hunks are the intended reproducible payload.
