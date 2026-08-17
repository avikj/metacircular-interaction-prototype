# Delta 26 — architecture search over equivalent factorizations

The live machine now compares whole architectures, not only routes inside one
architecture.  For the native accepted bounded task `n² ≥ 30` on `[0..20]`, it
constructs two exact factorizations:

- `direct`: materialize all fifteen satisfying witnesses `[6..20]`;
- `least-selector`: expose only the theorem-compiled least witness `6`.

An architecture is evaluated by its boundary continuation transformer: the
minimum total cost it presents to every active declared continuation.  Pareto
comparison is restricted to candidates with exactly equal transformer vectors.
Thus representation economy can never erase a behaviorally different
architecture.

Both candidates compute transformer `[6]`.  Their exact cost pairs
`(materialized routes, active route/context evaluations)` are `(15,15)` and
`(1,1)`.  The compiled selector is therefore the unique Pareto architecture;
the direct architecture has regret `(14,14)` relative to it.

Proof relevance is retained:

- the equivalence witness records the two architecture names and their common
  transformer `[6]`;
- both candidates retain the complete fifteen-route origin fibre;
- the compiled candidate retains a fifteen-entry migration map from every
  original route to `square-threshold/least/6`.

`round1` performs and forces this architecture search and logs candidate count,
transformer equivalences, Pareto count, and aggregate regret.

Replay:

```sh
ghc -O2 -Wall -fforce-recomp machine/MathMachine.hs -o /tmp/math-machine-dso-arch
/tmp/math-machine-dso-arch --dso-architecture-self-test
```

The regret is a finite scoped state/work difference under the declared
continuation family, not a universal runtime or architecture theorem.
