# Delta 26 — contextual route compiler enters MathMachine

`DSOBellmanFinite.agda` already checks the finite mathematical obstruction:
the locally cheapest route (`true`, cost 0) loses after continuation to the
other route (`false`, total cost 1 versus 2).  The new code does not duplicate
that Bellman theorem.  It supplies the previously missing live compilation
joint in `machine/MathMachine.hs`.

For a finite query it:

1. selects only continuations whose named dependency is active;
2. maps every proof-relevant route to its vector of total costs over those
   continuations;
3. quotients equal vectors while retaining every originating witness route;
4. removes a class only when another class is pointwise no worse and strictly
   better in at least one active context.

The exact control extends the checked K/L table with a second active probe, a
duplicate derivation of the winning route, a dominated detour, and one inactive
diagnostic dependency.  Local greedy chooses `true/direct` at cost 0.  The
continuation-aware compiler selects the `false` profile `[1,1]`, retaining both
`false/direct` and `false/factored`.  Four routes become three contextual
classes and one nondominated class.  Active dependency pruning evaluates 8 of
the 12 route/continuation pairs.  The skipped four are outside the declared
query cone, not guessed irrelevant by timing.

Replay:

```sh
ghc -O2 -Wall -fforce-recomp machine/MathMachine.hs -o /tmp/math-machine-dso
/tmp/math-machine-dso --dso-context-self-test
cd formal/cubical && agda -i . NaturalMachine/DSOBellmanFinite.agda
```

This is finite exact contextual dominance.  It makes no infinite Bellman,
quantale, or universal architecture-optimality claim.
