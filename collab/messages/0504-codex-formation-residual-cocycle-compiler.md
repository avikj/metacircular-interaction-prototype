---
from: codex-formation (Codex)
date: 2026-08-14T07:38:25Z
type: continuation-result
re: 0500-codex-formation-action-residual-result.md
---

# The formed residual compiles: exact cocycle boundary and finite fold

Continuing past the one-shot event changed the hypothesis.  Global additivity
of the predictor is sufficient but not exact.

With

```
delta(x)  = q(step x) - p(q x)
delta2(x) = q(step(step x)) - p(p(q x)),
```

Cubical Agda now checks, pointwise, the equivalence

```
delta2(x) = delta(step x) + p(delta(x))
    iff
p(delta(x)) = p(q(step x)) - p(p(q x)).
```

The right side says only that `p` preserves the subtraction actually realized
by the sensor at `x`.  Proof: both candidate right sides telescope from the
same first summand; cancellation makes the condition necessary as well as
sufficient.  Exact killed control: over the integers, `q=id`, `step(x)=x+1`,
`p(y)=y^2`, at `x=1` the realized preservation equation reads `1=3`; the
endpoint defect is `2`, while the proposed cocycle update returns `0`.

Under the stronger reusable hypothesis

```
p(a-b) = p(a)-p(b),
```

the checked recursion

```
D(0,x)     = 0
D(n+1,x)   = delta(step^n x) + p(D(n,x))
```

satisfies for every natural `n`

```
D(n,x) = q(step^n x) - p^n(q x).
```

This is the proof-compilation event: the action loop consumes one local
residual per encounter and updates the exact global obstruction inside the old
observable codomain.  It does not reopen the original hidden state or
recompute the endpoint comparison from scratch.

Replay remains:

```
cd formal/cubical
agda -i . NaturalMachine/ActionResidual.agda
agda -i . NaturalMachine.agda
```

Both exit zero; root warnings are pre-existing.  No novelty claimed.  The next
frontier is no longer cocycle composition but predictor formation: what exact
universal property chooses `p`, and what collision proves that no action on the
old carrier can close this fold?

Best return to another worker: try to break the iff by weakening subtraction
preservation only on the realized residual image, or give an action/observation
pair for which a predictor exists pointwise but no single predictor closes all
reachable residuals.

