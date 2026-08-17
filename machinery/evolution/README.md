# Private candidate/evaluation record kernel

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

The directory name and several schema fields retain legacy evolutionary
terminology.  They describe versioned candidate configurations and evaluation
observations; they do not make Darwin Gödel Machine search part of the system
architecture.  See `notes/RESEARCH_SYSTEM.md` for the canonical description.
The remainder uses `genome` only where it is the frozen v1 wire-format name.

This directory is the smallest inert substrate for testing candidate
configuration and evaluation records. It validates content-addressed records. It does **not**
run an agent, apply a mutation, access a network, modify itself, select a
champion, or change the status of a mathematical claim.

## Trust boundary

The only mutable file namespace a genome may name is
`collab/evolution/candidates/`. A genome cannot name the validator, any other
file in `machinery/`, the claim registry, formal proofs, CI, agent rules, the
protocol, or the append-only archive. Deletion is not a v1 operation. These
checks are necessary metadata checks, not an execution sandbox; a future
executor must enforce the same policy independently in an OS-level isolated
worktree.

An evaluation has `claim_effect: "none"`. Its `retained` event means only that
the genome may be referenced as a parent in this experimental archive. It
does not mean that code is trusted, a proof is valid, a claim is promoted, or
the genome may enter the trusted computing base. The existing proof notes,
exact certificate machinery, hostile review, and formal kernels remain the
authority.

Resource declarations are nonnegative bounded integers, and use cannot
exceed the declared limit. A passing run must carry at least one exact
measurement, one artifact, and nonzero CPU, wall-clock, or model-token use.
Scores are reduced rational numbers. JSON floats, NaN/infinities, duplicate
keys, unknown fields, noncanonical JSONL, ambiguous paths, broken content
hashes, and illegal state transitions fail closed. Raw JSON, JSONL archives,
records, nesting, strings, integers, and CAS artifacts all have hard bounds;
parser depth and integer-limit failures become validation failures rather than
interpreter crashes.

Candidate paths use canonical lowercase printable ASCII components only. Control characters,
Unicode normalization aliases, traversal, and any component named `.git`,
`.claude`, `.codex`, or `AGENTS.md` are forbidden. CAS objects are opened
read-only with no-follow semantics and must be regular files with the claimed
typed content hash. These checks still do not make an executor: a future
executor must use an isolated filesystem, reject symlinks at every traversed
component, pin file modes (v1 means regular non-executable data), use
descriptor-relative/no-follow writes, and verify the base snapshot before
applying any mutation.

## Three record types

- A **genome** binds a base revision and snapshot artifact, parent genome IDs,
  hash-addressed objectives/dependencies, a canonical reconstruction manifest,
  and the before/after hashes of an allowlisted set of candidate files. Parent
  IDs must occur earlier in the genome archive.
  `created_at` is archive metadata and is deliberately excluded from the
  semantic genome ID.
- An **evaluation** binds a genome, evaluator, task set, seed set, exact
  measurements, artifacts, protocol, environment/model manifest, resource
  policy, declared limits, and bounded resource accounting. A deterministic
  run has a memoization key over exactly that execution contract. A stochastic
  observation has no cache key and instead carries a unique content-addressed
  nonce and replicate number, so independent observations are never collapsed.
- An **event** is one link in the global append-only state chain:
  `proposed -> evaluating -> evaluated`, with further evaluation cycles
  permitted before `retained|rejected -> retired`. Only the most recent
  passing evaluation may enter `retained`.

`retained` is fail-closed in archive validation. It requires a local CAS that
resolves every genome dependency, lifecycle reason through retention, and retained-evaluation input/output,
an exact reconstruction manifest, and a local canonical trust policy that
allowlists both the evaluator artifact and the exact evaluator-attestation
artifact. The attestation binds the complete evaluation record modulo its own
ID/hash. This is a local custody boundary, not a signature scheme: whoever
controls the trust-policy file controls eligibility, so that file must be
supplied by the trusted integrator and never writable by a candidate.

Every JSONL line must equal the UTF-8 output of `canonical_json_bytes(record)`
followed by one newline. When prior archive paths are supplied, each current
file must contain its prior bytes as an exact prefix. The validator also
checks that every genome is proposed, every evaluation is finished exactly
once, parent genomes are retained before use, times are monotone, and event
sequence/predecessor links are exact.

The machine-readable schemas in `schemas/` document the wire shape and reject
unknown fields. JSON Schema cannot detect duplicate keys, recompute hashes,
check canonical byte encoding, or enforce cross-file history; `validator.py`
is therefore the authoritative validator.

## Content identity and the Unison-like constraint

V1 adopts one narrow idea associated with content-addressed systems such as
Unison: semantic records refer to immutable content hashes rather than mutable
human names. A genome's dependency-closure hash binds its sorted parent IDs
and direct dependency hashes. Since each parent ID binds its own record, this
commits recursively to the ancestor graph. Every hash preimage is length-framed
by a versioned type domain (`artifact`, record kind, dependency edge set,
deterministic evaluation cache, or attestation core); an artifact containing
another kind's projection bytes cannot alias that kind's ID without a SHA-256
collision. Public set-valued hash helpers sort and deduplicate their inputs.
`structural_diff` compares those graphs; it never compares labels or prose.
Aliases, UI names, and a future
"champion" pointer belong in a non-authoritative view outside these records
and never enter an object ID or evaluation cache key.

This is **not** Unison, a code runtime, or a claim that arbitrary program or
mathematical equivalence is decidable. Different content IDs may still denote
equivalent objects.

For future proof-relevant identity, the reserved extension is a separate
content-addressed equivalence-witness record binding:

1. source and target object hashes;
2. an exact equivalence-theory/checker version hash; and
3. a checker-verifiable certificate hash.

A class view would be a deterministic snapshot hash over sorted object IDs,
sorted accepted witness IDs, and the equivalence-theory version. No union may
ever be created from an LLM similarity judgment, a name match, or an
unverified isomorphism. V1 deliberately does not implement that record until
there is a concrete checker and certificate language; attempting universal
isomorphism canonicalization would make the identity layer unsound.

Exact object IDs would remain permanent even after equivalence witnesses are
added. A connected-component or equivalence-class hash can only be a versioned
derived view: later witnesses merge components nonlocally, and quotienting
would discard which equivalence/path (and eventually which higher coherence)
justified transport. This is the proof-relevant boundary behind the
Unison-like naming layer.

## Use

Validate one JSON object:

```sh
python3 machinery/evolution/validator.py record genome genome.json
```

Validate the cross-linked archive and an optional byte-prefix predecessor:

```sh
python3 machinery/evolution/validator.py archive \
  --genomes genomes.jsonl \
  --evaluations evaluations.jsonl \
  --events events.jsonl \
  --previous-genomes previous/genomes.jsonl \
  --previous-evaluations previous/evaluations.jsonl \
  --previous-events previous/events.jsonl \
  --cas /trusted/read-only/cas \
  --trust-policy /trusted/math-dgm-trust-policy.json
```

The CAS layout is one regular file per typed artifact ID, named by the 64 hex
digits after `sha256:`. Structured manifests, attestations, and the trust
policy use `canonical_json_bytes` with no trailing newline. Prefix checks are
relative to the explicitly supplied prior snapshots; SHA-256 alone does not
provide durable append-only storage or authorship.

Run the regression suite:

```sh
python3 machinery/evolution/test_validator.py
```
