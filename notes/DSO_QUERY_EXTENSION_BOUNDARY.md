# DSO query extension: a bounded fail-closed control

**Status:** executable Haskell regression over one finite declared continuation
family.  The safe Agda theorem `DSOContinuationFullAbstract` supplies the exact
all-continuations contrast; it does not verify the Haskell compiler or its
string labels.

## Corrected two-stage control

`machine/DSO.hs` composes cost relations through the intermediate boundary
`b`:

\[
(K\star L)(a,c)=\min_b\bigl(K(a,b)+L(b,c)\bigr).
\]

The downstream cost must therefore vary in its first argument.  With rows as
inputs and columns as outputs, the corrected tables are

\[
K=\begin{bmatrix}0&1\\3&3\end{bmatrix},\qquad
L=\begin{bmatrix}2&2\\0&0\end{bmatrix},\qquad
K\star L=\begin{bmatrix}1&1\\3&3\end{bmatrix}.
\]

Thus the locally cheaper intermediate state at input `false` costs `0`, but
the other state gives the cheaper composite cost `1 < 2`.  The executable
`prematureArgminCounterexample` now evaluates to `True`.  The previous spelling
varied `L` by the final endpoint instead, making both intermediate branches pay
the same downstream cost for a fixed endpoint and making the advertised
control false.

## What a declared query forgets

The finite `MathMachine.compileDSO` control has four labelled routes and three
continuations.  The labels identify runtime inputs; they are not derivations,
proof terms, replay certificates, or checked witnesses.

For active dependencies `["answer"]`, the observed contexts are `goal` and
`robustness`:

| route label(s) | profile | status |
|---|---:|---|
| `false/direct`, `false/factored` | `[1,1]` | sole surviving class |
| `true/direct` | `[2,4]` | dominated |
| `true/detour` | `[5,7]` | dominated |

Extending the dependencies to `["answer","audit"]` activates `diagnostic`:

| route label(s) | extended profile | status |
|---|---:|---|
| `false/direct`, `false/factored` | `[1,1,101]` | survives |
| `true/direct` | `[2,4,0]` | survives; resurrected |
| `true/detour` | `[5,7,3]` | dominated |

The first two extended profiles are incomparable.  The small-query survivor
quotient contains no cost data for `true/direct`, so it cannot itself refine to
the large-query frontier.  This is exact information loss at the boundary of
the declared observation family, not a failure of Pareto pruning within that
family.

`checkDSOQueryExtension` recompiles from the raw routes, compares stable route
labels, and rejects reuse when a label absent from the old frontier reappears.
On this control its exact result is

```text
Left ["true/direct"]
```

This is a fail-closed runtime guard under the bounded assumption that route
labels are stable identifiers.  It is not a semantic certificate for label
uniqueness, continuation equality, or proof preservation.  The machine's live
round currently recompiles its stored `DSOTask`; consumers that cache a
`DSOCompilation` must still apply the guard or retain the raw routes.

## Relation to full abstraction

`formal/cubical/NaturalMachine/DSOContinuationFullAbstract.agda` proves that a
finite extended-natural cost relation can be reconstructed from its Bellman
action on **every** continuation: Dirac continuations expose each matrix entry.
That transformer is information-complete.  `compileDSO`, by contrast, observes
only a finite declared family and then retains cost profiles plus string
labels.  Extension instability is precisely the gap between those two
observation boundaries.

The Agda theorem does not check the handwritten grouping, Pareto filter,
extension guard, or Haskell output.  The Haskell result is an executable
regression, while the generic all-continuations reconstruction is the checked
theorem.

## Replay

The focused source replay on GHC 9.12.2 produced

```text
[[0,1],[3,3]]
[[2,2],[0,0]]
[[1,1],[3,3]]
True
DSO CONTEXT CHECKED: local=true/0 contextual=false/1 routes=4 classes=3 survivors=1 origin-labels=2 continuation-evals=12->8 query-extension-rejected=true/direct
```

Compilation completed with pre-existing warnings about one unused import, two
unused matches, and two partial `head` calls.  No new warning points at the DSO
orientation or extension guard.
