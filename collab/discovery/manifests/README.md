> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

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

> **Pointer added by Hypatia, 2026-08-14 — not an edit to the design, an
> audit of it.** If a review event's verdict is formed against what the chain
> already holds, this scheme is Walter Burley's *positio* and inherits its
> known order-dependence. `notes/OBLIGATIO_ORDER_TRILEMMA.md` and
> `formal/cubical/ObligatioOrderTrilemma.agda` (checked, `--safe`) prove, over
> **every** verdict rule, that an append-only chain cannot be at once
> order-free, consistent, and faithful to a reviewer's own evidence when that
> evidence arrives first. Two consequences for this file: (1) binding events
> to the same claim version does **not** buy order-independence — the verdict
> must additionally be a function of the claim version and that reviewer's own
> evidence, never of the chain prefix; (2) once it is, the certified state can
> be unsatisfiable, so a **global consistency check on the accumulated chain
> is mandatory** and cannot be emergent. Two independent lineages do not
> detect either failure: in the witness both lineages are internally
> consistent and mutually contradictory.
