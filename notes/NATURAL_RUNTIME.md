# `natural`: compiled, resumable research state

**Status:** implemented read-only kernel. `RESEARCH_SYSTEM.md` remains the
architecture authority; claim packets, events, source artifacts, messages,
journals, and Git remain the data authority.

## Outcome

`code/natural.py` compiles the previously fragmented research graph into one
deterministic, content-addressed projection. It does not maintain a database
and never mutates packet status. Re-running it against the same bytes produces
the same `natural-research-graph-v1` SHA-256.

The compiled graph contains:

- claim metadata and normalized statement identity;
- exact statements, proof obligations, falsifiers, evidence, audits, and
  successor seeds;
- append-only event history;
- dependency and supersession edges plus reverse-impact queries;
- source and event-artifact existence, hashes, and claim backlinks;
- recent coordination messages; and
- the latest durable entry from every agent journal.

This is the shortest-build-path step requested by `RESEARCH_SYSTEM` §9(2):
claims, obligations, evidence, and dependencies are now queryable together.
It is a projection of existing authority, not new epistemic authority.

## Commands

```text
python3 code/natural.py summary
python3 code/natural.py show R0021
python3 code/natural.py impact R0005
python3 code/natural.py frontier
python3 code/natural.py resume --agent codex
python3 code/natural.py validate
python3 code/natural.py snapshot --output /tmp/research-graph.json
```

Every human query except `validate` and `snapshot` also accepts `--json`.
`snapshot` is the explicit opt-in write boundary; all other commands are
read-only. The snapshot path is user-selected and is not canonical state.

### `summary`

Reports the graph hash, claim/status counts, active packet cycles, owners, and
issue counts.

### `show RNNNN`

Returns the exact statement, obligations, falsifiers, evidence, audit state,
successor seeds, hashes, events, and artifacts for one claim.

### `impact RNNNN`

Traverses direct and transitive dependencies and reverse dependents, and shows
supersession in both directions. It is descriptive only: reverse-dependency
impact is not a truth score or automatic allocation command.

### `frontier`

Shows active claims with their obligations/successors and compiles the open
breaker queue from explicit packet fields.

### `resume --agent NAME`

Combines the selected journal's latest durable entry with branch/HEAD,
worktree status, recent commits, active ownership/review assignments, recent
messages, and graph issues. This is the continuously resumable handoff that
was previously reconstructed by reading several files manually.

### `validate`

Runs the existing packet validator, checks dependency cycles, supersession
targets, active dependencies on terminal claims, and source/artifact
existence. Missing authoritative sources are errors. Missing historical event
artifacts are warnings because two such legacy references currently exist;
`--strict-artifacts` makes warnings fail.

Artifact paths are confined to the repository root before any file is read or
hashed. Absolute paths, parent traversal, and symlink escapes are hard errors;
the compiler cannot turn a malformed historical event into an unintended
filesystem reader.

## Current-state yield

The first compilation exposes two already-existing provenance debts:

1. R0010 references the pre-renumbering packet path
   `collab/discovery/claims/R0009-chowla-ff-missing-structure.md`.
2. R0012 references absent `data/exp46_out.txt`.

The runtime reports these explicitly and keeps normal validation green; strict
artifact mode fails. It does not rewrite append-only historical events to hide
the defects.

## Trust boundary

`natural` may compile, hash, query, and warn. It may not:

- promote, certify, refute, quarantine, or supersede a claim;
- infer theorem equivalence from prose, shared sources, or similar hashes;
- repair an append-only event silently;
- rank scientific value with a permanent scalar; or
- treat a generated snapshot as more authoritative than its inputs.

The implementation imports the existing discovery validator instead of
forking its packet semantics. Tests cover deterministic hashing, statement and
event preservation, dependency/supersession direction, missing-artifact
visibility, resumption, snapshot replay, and unknown-claim failure.
