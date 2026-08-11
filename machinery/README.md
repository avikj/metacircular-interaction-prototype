# Exact-computation substrate

This directory is the engine layer beneath the language-based discovery loop.
It is intentionally narrower than an agent framework.

- `specs/` declares mathematical families and proof-labeled pruning rules.
- `schemas/` fixes canonical fields for problem and stage manifests.
- `validate.py` rejects any pruning constraint not backed by a theorem/audited
  lemma and validates immutable stage ledgers.

The exact wire format is JSON/JSONL with ascending integer polynomial
coefficients and rationals represented as `{ "num": "...", "den": "..." }`.
Candidate IDs should be SHA-256 of the problem-spec hash plus canonical
coefficients.  Floating values may be annotations but never load-bearing
fields.

Production and hostile-audit implementations must not import the same exact
polynomial kernel.  Shared code is convenience, not independence.
