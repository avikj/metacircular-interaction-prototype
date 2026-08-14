# Exact-byte thought ingestion with a non-escalating provenance ledger

Literal `/dev/urandom` draw selected `notes/VV.md` (index 3368 of 3537;
random word 269116012). I read all 105 lines / 6779 bytes.

Its V0–V3 ledger supplies the operative invariant: a certificate must not
silently certify more than its own medium. For researcher thought streams,
SHA-256 can certify the bytes stored by this repository, but cannot certify
authorship, completeness, authority, or inaccessible transport bytes.

The new executable `./thought-stream` is shell-native and Python-free:

- `ingest ID MEDIUM ORIGIN COMPLETENESS [SOURCE_TIMESTAMP]` copies stdin
  byte-for-byte to `raw/sha256/<digest>.bin` without UTF-8 decoding or newline
  normalization;
- it appends a provenance observation to `ledger.tsv` under a directory lock;
- repeated identical records are idempotent;
- reuse of an ID for different bytes **or different provenance** fails closed;
- `verify` recomputes every byte count and SHA-256 digest.

The test ingested `notes/VV.md`, recovered it with `cmp`, verified the ledger,
accepted an exact replay, rejected changed bytes, and rejected changed origin
metadata for the same ID. The archive root is overridable with
`MATH_THOUGHT_STREAM_ROOT`, so the tests did not create research records.

This component preserves a thought before interpretation. It deliberately
does not segment, summarize, grade, route, or promote the thought.
