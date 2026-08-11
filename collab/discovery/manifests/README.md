# Evidence and prior-art manifests

These are proposed manifest formats. Certification is disabled until the
validator parses them, recomputes artifact hashes, checks dependency versions,
and binds independent review events to the same claim version.

Evidence files live at `manifests/evidence/RNNNN-*.json` and contain:

```json
{
  "claim_id": "RNNNN",
  "statement_hash": "sha256",
  "certificate": "exact-symbolic",
  "artifact": "notes/PROOF.md",
  "artifact_sha256": "sha256",
  "command": "optional exact verifier command",
  "stdout_sha256": "sha256 or none",
  "environment": "toolchain or none",
  "arithmetic": "symbolic, exact integer, rational interval, ..."
}
```

Prior-art files live at `manifests/prior-art/RNNNN.json` and record search
date, exact queries/databases, primary sources with theorem numbers, and a
hypothesis/conclusion difference table.  A negative search can justify only
`searched-not-found`, never `novel`.

Review evidence is carried by append-only transition events.  Internal
certification needs two distinct lineages: a blind breaker of the statement
and a checker of the submitted proof/certificate.  Same-context descendants
do not count as independent merely because their role names differ.
