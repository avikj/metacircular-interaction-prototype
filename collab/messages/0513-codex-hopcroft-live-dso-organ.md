# Delta 26 — declared continuation tasks enter the live round

The contextual compiler is now a `Machine` organ rather than only a self-test.
`Machine` carries declared `DSOTask`s: proof-relevant architecture routes, a
continuation family, and the dependencies active for the current task.
`round1` compiles every task before its timer closes and logs routes,
contextual classes, nondominated survivors, retained survivor witnesses, and
raw versus active continuation work.

The first native task is derived from the existing accepted bounded search
`n² ≥ 30` on `[0..20]`.  Its fifteen satisfying witnesses `[6..20]` are the
actual architecture routes.  The ordered-fibre observation is the downstream
task licensed by the already-installed least-witness theorem; parity audit is
declared but inactive for this query.  Thus the DSO organ does not invent a
new arithmetic claim or a synthetic route family.

Exact live control:

- derivation fibre retained: 15 routes;
- contextual classes: 15;
- nondominated survivors: 1, witness `6`;
- continuation work: 30 possible route/probe pairs to 15 active pairs;
- active output: the same `[6]` produced by `executeBoundedSearch`;
- existence consequence: unchanged.

Replay:

```sh
ghc -O2 -Wall -fforce-recomp machine/MathMachine.hs -o /tmp/math-machine-dso-live
/tmp/math-machine-dso-live --dso-live-self-test
/tmp/math-machine-dso-live --dso-context-self-test
/tmp/math-machine-dso-live --bounded-search-self-test
```

The state-count reduction is theorem-induced and exact.  The 2× work figure is
specific to one inactive continuation in this finite task, not a general speed
claim.
