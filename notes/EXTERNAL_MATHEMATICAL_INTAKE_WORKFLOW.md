# External mathematics: six-stage intake workflow

This is an operational companion to
[`EXTERNAL_MATHEMATICAL_INTAKE_BOUNDARY.md`](EXTERNAL_MATHEMATICAL_INTAKE_BOUNDARY.md).
It describes how a university paper, lecture note, repository, or user-relayed
statement becomes (or fails to become) a capability.  It is a process
specification, not evidence for any theorem.

## The record carried through every stage

Use one content-addressed intake record with these fields.  Empty fields are
`missing`, never inferred:

```text
intake_id, source_kind, source_uri_or_citation, observed_at_utc
source_bytes_hash, source_version, licence_or_access_limit
statement_exact, statement_hash, hypotheses, notation_map
translation_files, dependency_lock, checker_and_version, axioms
replay_command, replay_artifact_hash, replay_verdict
independent_audit, authority_events, capability_scope, residuals
```

`statement_hash` is over the exact statement bytes, including whitespace and
encoding.  A relay, abstract, search result, or quotation gets
`source_kind=indirect`/`partial`; missing source bytes are not reconstructed.

## Six stages and gates

1. **Source.** Preserve permitted bytes (or an explicit partial record), URI or
   bibliographic identity, retrieval time, version, access/licence limits, and
   hash.  Record what was observed, not what the source is presumed to say.
   Gate: provenance is complete enough to retrieve or audit the observation.

2. **Statement.** Transcribe one exact mathematical claim, its scope and
   hypotheses, then hash it. Separate quoted source text from repository
   paraphrase. Register known/possibly-new status and a falsifier.  Gate:
   another reader can identify exactly which claim is under consideration.

3. **Formalization.** Write a typed translation in Agda (`--cubical --safe`)
   or Lean, naming universes, conventions, and theorems actually asserted.
   Attach a notation/definition map and list every translation residual.  A
   checked surrogate does not certify that the source intended that surrogate.
   Gate: the translation compiles with no holes or unlisted axioms.

4. **Dependencies.** Freeze direct imports, library commits, compiler/kernel
   versions, and transitive axioms in a lock record.  Distinguish source
   dependencies from checker dependencies.  External packages and hosted
   outputs remain quarantined candidates.  Gate: a clean checkout can resolve
   the declared environment without ambient network state.

5. **Replay.** Run the declared command from the frozen environment and retain
   stdout/stderr, exit status, artifact hashes, and a negative control or exact
   counterexample where applicable.  An independent audit re-derives or
   attacks the translation.  Verdicts are `unchecked`, `replayed`,
   `kernel-checked`, or `kernel-checked-with-assumptions`; numerics are
   falsifiers only.  Gate: replay is deterministic and the audit records what
   remains unverified.

6. **Capability.** Only after the prior gates may an append-only authority
   event promote a *scoped* capability: name the formal operation, accepted
   theorem(s), imports, and consumers allowed to depend on it.  Record cost or
   option-value claims separately from correctness.  A capability is a
   reusable checked operation, not a citation, package installation, or trust
   score.  Gate: a consumer can reject the record if provenance, statement,
   replay, dependencies, or current authority is missing or revoked.

## State transitions

```text
observed → transcribed → translated → locked → replayed → audited
                                                    ↘ rejected/refuted
audited + scoped authority → capability
capability --revocation--> quarantined (history retained)
```

Promotion never mutates or deletes earlier records.  A failed translation,
counterexample, source ambiguity, or revoked dependency remains a durable
residual and may motivate a successor intake.  Formal checking and installation
authority are independent coordinates: either can advance while the other
stays quarantined.

## Minimal handoff

The only load-bearing handoff is a pointer to the intake record plus
`capability_scope` and the exact replay command.  Consumers must not depend on
the raw paper, a model summary, an unpinned package, or an unscoped theorem
name.  This keeps external mathematics useful as a source of questions while
making its transition into machine capability auditable and reversible.

