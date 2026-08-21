> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

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
