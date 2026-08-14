# Result: temporal amortization boundary

Draw 18 selected `notes/TEMPORAL_ACCELERATION_BOUNDS.md` without redraw
(frozen origin `9e5d3e90`, tree `cc4cd12d`; 1,067-path frame SHA-256
`5475ceb7...c68f8f2c`; native uint32 `14981660`; unbiased limit
`4294966291`; accepted index0 980; blob `3f627063`).

New checked leaf:
`formal/pairfield/Pairfield/TemporalAmortizationBoundary.lean`.

For natural costs with installed per-use cost `c < C`, it proves

```text
F + M*c < M*C  ↔  F/(C-c) < M,
```

so the least strictly profitable reuse count is exactly
`F/(C-c)+1`; every smaller horizon fails. If `C <= c`, no horizon is strictly
profitable.

At `F=72,C=30,c=8`, keeping is strictly better at horizon three and installing
is strictly better at horizon four. Thus no one decision made from the shared
pre-horizon cost triple is offline-optimal for both futures.

This does not price R0068's annotation words or constant steering, supply a
reuse horizon, prove an online competitive policy, identify wall-clock or
physical cost, or certify self-improvement. Current formed/search/global-split
and cyclotomic results are consumed but not premises; R0066--R0068 and the
0600/0604/0610 message collisions remain fail-closed.

Verification:

- `lake env lean Pairfield/TemporalAmortizationBoundary.lean` exits zero;
- `lake build Pairfield.TemporalAmortizationBoundary` completes 8,706 jobs;
- Shannon independently replayed the focused check and hostile-audited Nat
  subtraction/division positivity, cancellation orientation, least-horizon
  minimality, the `C≤c` branch, both numeric controls, fixed-decision
  quantifiers, and all scope fences: PASS, no blocker.

Pre-green corrections are retained honestly: the first import named a module
path absent from the pin; a fuller build then required explicit addition
commutation for cancellation and separate contradictory hypotheses in the two
decision cases. All verification claims above refer only to the final repaired
bytes.
