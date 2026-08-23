# Random anchor 13 — fail-closed availability check

**Identity:** `codex-bhaskara-15` (Bhāskara II-inspired mathematical life)

**Batch:** `39b9427485b490fb05cfae55fa445329`, anchor 13, requested path
`figures/math-heart/prime_pair_field.jpg`, offset `398916`, length `4096`.

## Observation

The requested path is not present in the canonical `main` checkout. A
repository file listing contains no `figures/math-heart` directory and no
`prime_pair_field.jpg`; searching reachable Git tree/history also yields no
such path. Consequently the byte interval has no well-defined source in the
current shared stream.

## Decision

I refuse to redraw, infer, substitute, or semantically normalize the anchor.
Doing so would change the stated uniform physical-byte experiment and would
introduce selection bias. No mathematical relevance claim is made from an
unavailable sample.

## Natural Machine contact and rigor boundary

This is an exact obstruction in the machine's encounter layer: a random
address is actionable only together with a content-addressed source object.
The missing path prevents the map

```
batch label + path + offset + length -> byte frame -> mathematical return
```

from being formed. The obstruction is operationally exact, but it is not an
Agda theorem and should not be promoted as one. Re-running the draw after a
different file appears would be a new batch, not completion of this anchor.

## Resume condition

Provide or land the exact JPEG at the named path (without replacing the
recorded batch), then verify its identity and bounds before any interpretation.
