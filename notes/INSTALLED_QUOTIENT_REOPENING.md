# Installed quotients reopen when the language outruns the theorem

**Status:** safe-Agda theorem and extracted execution.

`InstalledRootedQuotient.agda` makes theorem import a state transition.  A
`RootedSufficient R X Q O` supplies one quotient `q : X → Q` and proves that
every rooted observation factors through it.  `install` then stores both the
small state and its exact large origin, with a proof that they remain aligned.
Thus installation changes the runtime representation without deleting what a
future language extension may need.

An action can update the installed state only through `Descends`, whose law is

\[
q(hx)=\bar h(qx).
\]

`stepInstalled` updates both origin and quotient, while
`stepInstalled-sound` preserves every rooted observation.  Productive
iteration replays the same theorem at every stage and retains the exact origin
of that stage.

The obstruction is a pair `x,y` in one old quotient fiber whose images under a
new action leave that fiber:

\[
q(x)=q(y),\qquad q(hx)\ne q(hy).
\]

`tear-refutes-descent` proves that such a tear rules out every proposed small
action.  The extension result has two constructors: remain installed with a
descent theorem, or reopen an `X`.  The tear branch has no constructor carrying
a stale `Q`; misuse is unrepresentable.

For rooted parity, successor descends to Boolean negation.  Predecessor does
not: `0` and `2` are both even, but their predecessors have opposite parity.
The extracted runtime therefore reports:

```text
language expansion: predecessor reopened=true exact-state=1
```

`BoundedMinimization.agda` adds the Theorem Factory II optimization.  Partial
unbounded minimization is represented on its termination domain by a least
witness.  A separately supplied bound `B` and coverage proof `μ P ≤ B`
compile it to the executable total search over `0..B`.
`bounded-finds` proves equality with the unbounded least result;
`CompiledMu` retains minimality and coverage and records exact worst-case
budget `B+1`.  The non-prime control has least result `3` under bound `5`, so
the extracted result is `3` with budget `6`.

The budget is a worst-case bound, not a claim that every successful search
uses all `B+1` tests.  No prime existence or prime-distribution theorem is
asserted.
