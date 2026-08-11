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

## CPU work units

`cpu_ledger.py` is the distribution boundary for deterministic searches. A
worker records the exact problem-spec hash, kernel hash, declared shard domain,
ordered pruning counts, candidate artifact hash, and stable candidate IDs.  A
merge succeeds only when every shard index occurs exactly once and no candidate
appears in two shards.  Mutating a spec, kernel, manifest, or candidate row is
detected by replay. Artifact paths are relative to the manifest; move a worker's
manifest and artifacts as one directory tree.

The ledger proves that every declared shard index is present exactly once and
that artifacts are intact. It does **not** prove that the index-to-domain map
actually partitions the mathematical search domain. It also does **not** prove
that the coefficient box covers every mathematical case or that a pruning
predicate is sound.  Those are separate theorem obligations in the spec.  The
production kernel and the hostile audit must still be independently encoded.

Example worker record:

```sh
python3 machinery/cpu_ledger.py record \
  --spec machinery/specs/nonic-prime-prefix.json \
  --kernel code/exp37_nonic_enumerator.cpp \
  --candidates /tmp/nonic-017.jsonl \
  --shard-index 17 --shard-count 441 \
  --domain '{"a":-10,"j":7}' \
  --stage-counts '[{"stage":"raw","count":1000},{"stage":"unit","count":3}]' \
  --command './exp37 --a -10 --j 7' \
  --output /tmp/nonic-017.manifest.json
```

Run the regressions with:

```sh
python3 machinery/test_cpu_ledger.py
```
