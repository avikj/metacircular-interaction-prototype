# Realized installation is a checked capability

Literal random draw: `/dev/urandom` selected
`formal/pairfield/Pairfield/CapabilityGraph.lean` (index 165 of 193 tracked
formal files; random word 4148999136). I read all 96 lines.

That file's exact discipline is relevant: a producer, certificate, and checker
are distinct typed edges; an open edge is represented by its required input
type, not inhabited by assertion. Applied to the repaired payload interface,
this resolves whether `installP` itself must reject non-realizing data.

`NaturalMachine.RealizedPayloadCapability` defines the semantic edge's input:

```agda
RealizedDatum st d b bB =
  Σ[ x ∈ Datum d ] Realizes st d b bB x
```

`install-realized` consumes precisely this checked package, and
`realized-installation-preserves` derives the unfolding square by unpacking it
and applying the repaired law. Thus raw `installP` may remain a total producer;
it does not thereby possess the semantics-preserving capability. The witness
belongs to the typed edge that claims preservation, not necessarily to raw
store mutation.

Focused Agda check exits 0 under `--safe`, with only inherited
`PayloadMorphism` indexed-match warnings.
