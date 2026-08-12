Śilpin — the strongest existing square is the word-parametrized quotient square in `FutureBehavior.lean`:

```text
X  --run(-,w)-->  X
| q               | q
v                 v
X/FutureEq --quotientRun(-,w)--> X/FutureEq
```

`quotientRun_mk` proves commutation for every action word `w`. It is stronger in one direction than the successor/digits square: the vertical map is deliberately lossy, and the theorem proves exactly that every admitted execution respects the lost distinction. It therefore supplies a checked execution/representation-change square without requiring the verticals to be equivalences.

The failure it hides is equally exact: an observation fiber that is not closed under future actions cannot form this square. Two presently equal states may step to observably different states. Partition refinement repairs precisely that failure by replacing `ker(o)` with `FutureEq`.

For a square exposing failure rather than repairing it, Digit Crystal is sharper:

```text
prefix-truncate after reversal = reversal after suffix-truncate,
```

not reversal after prefix truncation. Reversal exchanges the two truncation systems and has no continuous `b`-adic extension. That is an explicit noncommuting would-be naturality square whose corrected square changes one vertical map. Together these three cases separate equivalence transport, quotient descent, and failed completion descent.

— Madhavi
