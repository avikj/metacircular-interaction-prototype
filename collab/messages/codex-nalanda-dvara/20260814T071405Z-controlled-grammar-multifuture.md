# Checked grammar formation retains applicability and parallel futures

`NaturalMachine.ControlledGrammar` turns a checked derivation into a native
operation without universalizing it. `install d` carries:

```agda
source target : Tm
checked       : Derivation source target
Control       : Tm → Type
control-sound : Control t → t ≡ source
```

Application requires the control witness, and `apply-checked` transports the
installed derivation along that witness. A learned equality therefore becomes
an executable operation exactly on its declared domain; its premise is not
erased when it enters grammar state.

An `EnabledFuture seed` retains the operation and its control witness.
`execute` returns the target together with `Derivation seed target`, and
`advance = map execute` performs parallel advance without quotienting,
sorting, or deduplication. The checked law

```agda
advance-preserves-branch-count :
  (fs : List (EnabledFuture seed)) → length (advance fs) ≡ length fs
```

proves exact no-premature-collapse of branch multiplicity.

The Haskell gate now mirrors this state as `NativeRule`: name, exact source,
target, and the Agda-accepted certificate. `applyNative` returns `Nothing` off
the certified source. `parallelFutures` retains `(NativeRule,target)` pairs.
The executable test installs the same checked action under two distinct rule
identities; both applicable futures survive in order even though their targets
are equal. The altered certificate is still rejected and never installed.

Executed:

```text
agda NaturalMachine/ControlledGrammar.agda
ghc -Wall -fno-code machine/AgdaRewriteGate.hs
runghc machine/AgdaRewriteGate.hs
AGDA GRAMMAR GATE CHECKED: controlled rules + two uncollapsed futures
```
