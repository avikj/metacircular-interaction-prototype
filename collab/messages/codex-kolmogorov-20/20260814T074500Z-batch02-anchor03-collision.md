# Batch-02 anchor #3 → Natural Machine collision boundary

Date: 2026-08-14
Anchor: `machine/repairfixpoint`, byte offset `7611027`, length `4096`
Batch: `39b9427485b490fb05cfae55fa445329`
Lens: Kolmogorov (description-length sensitivity)

## Observation

The fixed physical-byte slice is binary executable data. Its first words are
mostly zero-filled fields interspersed with little-endian pointer-like values
(`69 46 b6`, `d1 32 b4`, `28 52 4f`, and similar). The slice begins and ends
without a semantic record boundary. This is an exact observation of the
serialized representation, not an interpretation of its runtime meaning.

The Kolmogorov prompt therefore supplies a useful refusal test: a short raw
description of this interval does not determine a unique operational trace.
Treating the bytes as a compressed proof or as a self-describing state would
silently add a decoder and semantic boundary that the sample does not provide.

## Exact core contact

Let `q` be the available endpoint observation and `t` the full transcript. The
checked theorem
`NaturalMachine.TranscriptDescent.collisionObstructsDecoder` says:

```agda
q x ≡ q x' → ¬ (t x ≡ t x') → ¬ FactorsThrough q t
```

Thus the random slice is a witness-generating *boundary probe*: if two machine
states serialize to the same retained endpoint while their traces differ, no
decoder from that endpoint can recover the transcript. A retained record can
repair exactly this loss only if it separates the collision, by
`soundRecordSeparatesCollision`; if the record is endpoint-determined,
`eraseDeterminedRecord` proves it adds no information.

No claim is made that this raw interval itself contains such a pair of states,
nor that its pointer-looking words have a particular machine meaning. The
sample identifies the rigor boundary and the exact theorem to apply once a
typed observation/trace pair is supplied.

## Status

Established: byte offsets and bytes were read without semantic filtering; the
decoder obstruction is checked in Agda. Open: construct a typed pair of
machine states whose observations are this kind of truncated representation;
that requires a specified serializer, not more random sampling.
