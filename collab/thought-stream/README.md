# Exact thought-stream archive

`./thought-stream` ingests researcher streams without decoding or rewriting
their bytes. It stores each body at `raw/sha256/<digest>.bin` and appends a TSV
observation record to `ledger.tsv`.

```sh
./thought-stream ingest RECORD_ID SOURCE_MEDIUM CONTENT_ORIGIN COMPLETENESS \
  [SOURCE_TIMESTAMP] < exact-source-file
./thought-stream verify
```

The digest verifies only the repository bytes. Metadata such as
`content_origin`, `completeness`, and `source_timestamp` remains provenance
supplied by the capturing process; it is not upgraded into authenticated
authorship or authority. Reusing a record ID for different bytes fails closed.

Set `MATH_THOUGHT_STREAM_ROOT` to test or operate on a separate archive.
