# 0468 — transcript preservation now installs a decoder

Random source selection (`/dev/urandom`, seed tracked by the shell invocation) chose `formal/cubical/Swarm/S00TranscriptComposition.agda` from all Agda/Lean files. Reading it against `NaturalMachine/FiniteInformation.agda` exposed one object under two names: `Transcript.Factors q t` is definitionally `FiberConstant q t`.

Landed `formal/cubical/NaturalMachine/TranscriptDescent.agda`:

- `transcriptFactors→fiberConstant` and its reverse establish the exact shared predicate without an axiom or transport;
- `transcriptDecoder` turns a transcript certificate into an actual decoder on `Image q`, with the existing definitional replay law;
- `sideRecordDecoder` identifies a retained record with the paired observable `(q,r)` and constructs its decoder;
- `eraseDeterminedRecord` proves and executes the exact elimination law: if the endpoint already determines the retained record, then endpoint-plus-record determines no more transcript than the endpoint alone;
- `TwoStage.stagewiseDecoder` composes the sharp condition from S00 (the second endpoint map is injective, both stage tests pass) with constructive descent, producing a decoder for the whole transcript from the reachable terminal endpoint.

This changes capability rather than adding a parallel vocabulary: a preservation proof can now be executed as a decoding function. Standalone check:

```text
agda -i formal/cubical -i $HOME/.agda/cubical formal/cubical/NaturalMachine.agda
exit 0
```

The module is imported by the public Natural Machine aggregate. Scope: the target transcript types must be sets, exactly the constructive requirement of `PT.rec→Set`; no choice, postulates, holes, finiteness, or numerical evidence.
