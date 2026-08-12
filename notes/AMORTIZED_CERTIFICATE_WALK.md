# A certificate can choose a route only relative to a horizon

Suppose a compiled mathematical carrier costs `C` once, an old query costs
`D`, and a compiled query costs `S`, all in one declared cost unit. For `k`
future queries,

```text
old(k)      = kD,
compiled(k) = C+kS.
```

## Exact break-even theorem

There is a strict compiled-route gain exactly when

```text
k(D-S) > C.                                                (1)
```

If `D<=S`, no nonnegative horizon gives a strict gain. If `D>S`, the least
profitable integer horizon is

```text
k_min = floor(C/(D-S))+1.                                  (2)
```

This follows by subtracting `kS` from both total costs. The `+1` is necessary
because the desired inequality is strict; equality is a hostile boundary,
not a gain.

For the `W=30` cyclotomic sieve certificate,

```text
C=72 compiled trace cells,  D=30 residue checks,  S=8 divisor terms.
```

Under the declared unit-cost model, `D-S=22`, hence `k_min=4`. At three
queries, compilation costs `72+3*8=96`, versus `90` directly. At four it
costs `104`, versus `120`, a strict gain of `16`.

The counts above are a deliberately explicit cost model, not a wall-clock
claim: a trace-cell compilation, residue check, and divisor lookup are being
assigned one unit each. If their machine costs differ, replace the three
integers by measured or proved commensurate costs; equations (1) and (2) do
not change.

## What the walk can and cannot derive

`machinery/amortized_certificate_walk.py` consumes the actual
`SieveIngestionCertificate` fields. Given a declared future horizon, it
selects the old or compiled route by checking (1), so the certificate changes
execution at the fourth query rather than appearing as inert metadata.

It cannot derive an offline-optimal install decision from the current state
alone when the horizon is unknown. Before any query, the machine state and
cost certificate are identical in these two futures:

```text
future A ends after 3 queries: optimal action is do not compile;
future B ends after 4 queries: optimal action is compile now.
```

Any horizon-free deterministic decision makes the same choice on that shared
prefix and is therefore wrong for one continuation. This is not a software
defect. The missing horizon, distribution, regret objective, or competitive
policy is a genuine input. Hardcoding “install at four” would silently change
the problem from offline total-cost minimization to an online policy.

Thus the costed walk can derive **admissibility relative to a supplied task
horizon**. It cannot infer the horizon from the certificate it is evaluating.

Replay:

```text
python3 machinery/amortized_certificate_walk.py
python3 -m unittest machinery.test_amortized_certificate_walk
```
