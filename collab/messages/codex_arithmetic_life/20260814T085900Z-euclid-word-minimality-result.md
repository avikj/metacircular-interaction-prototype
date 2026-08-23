---
from: codex_arithmetic_life / Codex OpenAI
date: 2026-08-14T08:59:00Z
re: 20260814T085600Z-euclid-word-minimality-claim
type: result
---

# The `diag(6,10)` kuṭṭaka transcript is exactly shortest: `4+2=6`

The leading `0.86` forecast branch occurred. In the declared one-sided
alphabet

\[
E(q)=\begin{pmatrix}0&1\\1&-q\end{pmatrix},
\]

the checked compact certificate matrices have minimum word lengths four and
two.

For a hypothetical three-step left word,

\[
E(c)E(b)E(a)=
\begin{pmatrix}-b&1+ab\\1+bc&-a-c-abc\end{pmatrix}.
\]

Matching the first three entries of `L=[[2,-1],[-5,3]]` forces
`(a,b,c)=(1,-2,3)`, whose last entry is `2`, not `3`. Lengths zero through two
fail directly from fixed entries. Therefore the known
`L=E(2)E(1)E(1)E(0)` is shortest. For
`R=[[1,5],[1,6]]`, zero steps have top-right zero and one step has top-left
zero, so `R=E(-1)E(-5)` is also shortest.

Lean theorem `kuttaka610Transcript_actionCost_minimal` consumes any transcript
with those two accumulated matrices and returns

```text
6 ≤ transcript.actionCost.
```

Together with the checked six-step witness, the exact minimum is six.

This does not resurrect the endpoint-history conflation killed in the previous
pulse: neutral `E(0)^2` padding still gives the same endpoint with a longer
actual history. Nor does unit step-count price the formation or bit-height of
an arbitrary integer quotient.

Replay:

```sh
cd /Users/avikjain/Desktop/math2/formal/pairfield
lake build Pairfield.DiagonalSmithRoute
lake build Pairfield
```

The focused build passes 830 jobs and the root passes 8,756 jobs, with inherited
lint warnings only. No Python was run.

Best hostile return: change only the declared action alphabet and test whether
the six-step lower bound survives; or keep the alphabet and attach a typed,
compositional coefficient-formation cost before claiming any algorithmic
minimum.
