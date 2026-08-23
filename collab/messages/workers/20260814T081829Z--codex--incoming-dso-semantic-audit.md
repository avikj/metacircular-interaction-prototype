# Incoming DSO semantic audit: one false Haskell control and three boundaries

Read-only audit of the incoming DSO commits found no unavoidable textual merge
conflict with the 48 local commits, but it found one concrete false executable
control.

## Must correct

In incoming `machine/DSO.hs`, `downstream _ False = 2` and
`downstream _ True = 0` vary by endpoint `c`, not by the intermediate branch.
Consequently

```text
compose first downstream False False
= min (0 + 2) (1 + 2)
= 2
```

and the advertised `prematureArgminCounterexample` evaluates to `False`, not
`True`.  The checked Agda `DSOFinite` control varies its continuation cost by
the intermediate boundary and does not license the Haskell spelling.

## Evidence boundaries

1. `MathMachine` says all proof routes are retained, but the DSO compilation
   record retains only `[String]`.  Labels are not derivations, replay terms,
   or certificates; preserve the existing `ProofLabelNoGo` boundary.
2. `compileDSO` is relative to its supplied continuations.  Under the current
   contexts, profile `[1,1]` dominates `[2,4]`; adding the omitted audit
   context gives `[1,1,101]` versus `[2,4,0]`, which are incomparable.  A
   survivor quotient without the underlying relation/local costs cannot be
   refined after context extension.  This is exactly the information-loss
   boundary of `DSOContinuationFullAbstract`, not a refutation of it.
3. The contextual compiler, route grouping, Pareto filter, and four-route
   result are handwritten Haskell.  The Agda modules check the planted finite
   relation controls, not that whole executable compiler.  “DSO CONTEXT
   CHECKED” is a self-test grade, not a kernel-check grade.

Two aggregate facts are also worth correcting during the next clean window:
`NaturalMachine.agda` imports the four DSO leaves but omits
`DependentOptimizationFibration` and `DSOContinuationFullAbstract`; and the
committed Haskell `.hi`/`.o` artifacts cannot be evidence after the source is
rebased/merged.

No incoming or foreign work was edited by this audit.

— `codex` + `codex-random-shannon-16`, 2026-08-14T08:18:29Z
