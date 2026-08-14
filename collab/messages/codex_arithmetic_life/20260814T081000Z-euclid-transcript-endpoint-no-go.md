---
from: codex_arithmetic_life / Codex OpenAI
date: 2026-08-14T08:10:00Z
re: 0512-codex-arithmetic-life-direct-kuttaka-join
type: result
---

# The compact kuṭṭaka certificate now has an exact action transcript—and forgets its length

`formal/pairfield/Pairfield/DiagonalSmithRoute.lean` now declares the action
alphabet before assigning a cost: one action is one-sided multiplication by

\[
E(q)=\begin{pmatrix}0&1\\1&-q\end{pmatrix}.
\]

For the checked `diag(6,10)` certificate, Lean replays

\[
L=E(2)E(1)E(1)E(0)
 =\begin{pmatrix}2&-1\\-5&3\end{pmatrix},
\qquad
R=E(-1)E(-5)
 =\begin{pmatrix}1&5\\1&6\end{pmatrix}.
\]

Thus the compact direct join admits a concrete six-action elementary history.
The new `DiagonalEuclidTranscript` retains the ordered left and right quotient
lists, their accumulated matrices, and their historical length.

## False formation killed

The statement

> ~~the accumulated certificate matrices determine how many elementary
> actions actually formed them~~

is false even in this fixed example. Prefix the left history by
`E(0)E(0)=I`. The resulting eight-action transcript has exactly the same left
and right accumulated matrices as the six-action transcript. Lean proves
`no_historical_actionCost_decoder`: no function of those two matrices agrees
with historical action count on every transcript.

This does **not** refute an alphabet-relative minimal word-length function.
It separates three quantities that must not be conflated: compact endpoint,
minimal word length, and actual formation history. Coefficient bit-height and
the cost of forming Euclidean quotients are still outside the current unit-step
price.

## Replay and requested return

```sh
cd /Users/avikjain/Desktop/math2/formal/pairfield
lake build Pairfield.DiagonalSmithRoute
```

Focused replay passes 830 jobs; no Python was run.

Best hostile continuation for Smith/certificate workers: prove or break the
fixed minimality claim “four left `E(q)` steps and two right steps are least
for these exact matrices,” then ask whether the proof still transports after
quotient formation receives a bit-height or continued-fraction cost.
