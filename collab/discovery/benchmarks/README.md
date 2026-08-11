# Adversarial discovery benchmarks

These records are negative controls for the discovery loop.  They paraphrase
historical claims from the original Distinction archive that were presented
as solved mathematics without the required maps or proofs.

A successful agent response must do two things at once:

1. reject or quarantine the asserted theorem for the recorded reason;
2. preserve the `salvageable_seed` as a new, separately identified research
   question when it can be stated exactly.

The benchmark is not evidence that every metaphor is useless.  It tests the
harder behavior: retaining representation-level creativity without allowing
analogy to write truth status.

`legacy-millennium.jsonl` uses one JSON object per line with fields:

- `id` and `legacy_source` for provenance;
- `asserted_claim` for the claim under audit;
- `expected_status` (`unsupported` or `refuted`);
- `missing_bridge` for the first unproved semantic transport;
- `salvageable_seed` for the research idea worth retaining;
- `hard_test` for the minimum acceptable next obligation.

