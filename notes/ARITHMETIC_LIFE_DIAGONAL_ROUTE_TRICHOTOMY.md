# Positive diagonal Smith action trichotomy

**Status:** Lean-checked exact operation and false-formation correction.
No novelty is claimed for Smith normal form or the paired-swap identity.

## 1. Collision in the inherited endpoint

The arithmetic organism ended its previous execution with the instruction:

> attack `diag(a,b)` where `a ∤ b` and earn one mixing operation.

That condition does not determine one next action. For positive `a,b`, there
are three exact cases:

\[
\begin{array}{c|c|c}
\text{condition}&\text{route}&\text{certificate}\
\hline
a\mid b&\texttt{alreadySmith}&I\,\mathrm{diag}(a,b)\,I\
a\nmid b,\ b\mid a&\texttt{swapToSmith}&S\,\mathrm{diag}(a,b)\,S\
a\nmid b,\ b\nmid a&\texttt{nontrivialJoin}&\text{existing total producer}
\end{array}
\]

where

\[
S=\begin{pmatrix}0&1\\1&0\end{pmatrix},\qquad
S\,\operatorname{diag}(a,b)\,S=\operatorname{diag}(b,a).
\]

Thus `diag(6,2)` kills the blanket formation: `6 ∤ 2`, but `2 ∣ 6`,
so paired swap yields the valid Smith endpoint `diag(2,6)` without Euclidean
coordinate mixing.

## 2. Executable operation

`Pairfield.DiagonalSmithRoute` defines `positiveDiagonalRoute` and
`positiveDiagonalCertificate`. The latter returns an independently checkable
`SmithCertificate2`:

- identity certificate in the ordered branch;
- paired-swap certificate in the reverse-ordered branch;
- `GeneralSmith2x2.smithCertificate` in the mutually nondividing branch.

The universal theorem

```lean
positiveDiagonalCertificate_valid
  (ha : 0 < a) (hb : 0 < b) :
  (positiveDiagonalCertificate a b).Valid
```

proves every emitted certificate valid. The two closed-form certificates also
have converses:

```text
identity certificate valid  ↔  a ∣ b
swap certificate valid      ↔  b ∣ a.
```

Consequently `nontrivialJoin` is equivalent to failure of both simple
certificates. `diag(6,10)` is the exact control: neither entry divides the
other, so the dispatcher invokes the already-proved total Smith producer.

## 3. Scope boundary

The checked result does **not** prove that every operation weaker than a
Euclidean join is impossible in the mutually nondividing case. It proves the
sharp declared boundary: neither retaining nor swapping the two diagonal
entries gives a Smith-valid certificate. The general producer supplies a
correct continuation; minimality of its action transcript or coefficient cost
remains open.

The newly delivered action-refinement return changed the computation here:
the old scalar residual `a ∤ b` was split by the next-action coordinate rather
than being treated as one undifferentiated failure.

## 4. Replay

```sh
cd formal/pairfield
lake build Pairfield.DiagonalSmithRoute
```

Focused replay builds 731 jobs. The aggregate `lake build Pairfield` reaches
this module and then fails only in the previously recorded unrelated
`Pairfield.Lowenheim` and `Pairfield.DirectSmith2x2` targets; no aggregate-green
claim is made.

## 5. Correction and next operation: the incomparable branch is a direct kuṭṭaka join

The preceding sections record the first route refinement. Their final branch
has now been made strictly cheaper and more specific:

> ~~Mutual nondivisibility sends a positive diagonal to the general `2×2`
> Smith producer.~~  It sends the diagonal to the existing closed-form
> kuṭṭaka join after one gcd normalization.

Let

\[
g=(a,b),\qquad p=a/g,\qquad q=b/g.
\]

For positive `a,b`, `g>0` and `(p,q)=1`. Executable extended Euclid supplies
integers `x,y` with `xp+yq=1`. Define

\[
L=\begin{pmatrix}x&y\\-q&p\end{pmatrix},\qquad
R=\begin{pmatrix}1&-yq\\1&xp\end{pmatrix}.
\]

Then the already-checked diagonal join gives

\[
\det L=\det R=1,\qquad
L\operatorname{diag}(gp,gq)R=\operatorname{diag}(g,gpq).
\]

`positiveDiagonalJoinPresentation` transports this exact arrow into the common
`IntMat2`/`SmithPresentation` language. `positiveDiagonalCertificate` now uses
it in the `nontrivialJoin` branch; the general producer remains only as the
total wrapper's safe zero-gcd fallback, outside the positive-diagonal theorem.

For the hostile control `diag(6,10)`, `g=2`, `(p,q)=(3,5)`, and the executable
Bézout coefficients are `(x,y)=(2,-1)`. Lean checks the emitted data exactly:

\[
\begin{pmatrix}2&-1\\-5&3\end{pmatrix}
\begin{pmatrix}6&0\\0&10\end{pmatrix}
\begin{pmatrix}1&5\\1&6\end{pmatrix}
=\begin{pmatrix}2&0\\0&30\end{pmatrix}.
\]

This kills a second false formation: mutual nondivisibility does not require
entering a general alternating matrix descent. It requires formation of a
Bézout witness for the normalized pair, after which the matrix action is a
closed formula.

The cost boundary is retained rather than hidden. A `SmithPresentation` treats
the two accumulated unimodular matrices as one presentation arrow; a grammar
of one-sided matrix multiplications sees two actions; a grammar of elementary
shears must also price the Euclidean history that formed `x,y`. Therefore this
result does **not** prove an intrinsic minimal operation count. It identifies
the missing cost coordinate and changes the dispatcher without pretending that
coefficient formation is free.

Replay now builds 830 focused jobs:

```sh
cd formal/pairfield
lake build Pairfield.DiagonalSmithRoute
```

## 6. Fixed-alphabet minimum: four left actions and two right actions

The preceding cost boundary is now split exactly. Historical transcript length
still does not descend through the endpoint matrices, but the *minimum* word
length for the fixed `diag(6,10)` matrices exists and is six in the declared
alphabet

\[
E(t)=\begin{pmatrix}0&1\\1&-t\end{pmatrix},\qquad t\in\mathbb Z.
\]

For the left temporal convention, a three-step word has the form

\[
E(c)E(b)E(a)=
\begin{pmatrix}
-b&1+ab\\
1+bc&-a-c-abc
\end{pmatrix}.
\]

Equating its first three entries with
`L=[[2,-1],[-5,3]]` forces `b=-2`, `a=1`, and `c=3`. The remaining entry is
then `2`, not `3`. Words of lengths zero, one, and two already fail from their
displayed entries (`I`, top-left `0`, and top-left `1`, respectively). Hence
every left word for `L` has length at least four, attained by

\[
L=E(2)E(1)E(1)E(0).
\]

On the right, a zero-step word has top-right entry zero and a one-step word
has top-left entry zero, while `R=[[1,5],[1,6]]`; thus two steps are necessary
and are attained by `R=E(-1)E(-5)`. Lean combines the independent bounds:

```lean
kuttaka610Transcript_actionCost_minimal
```

maps any transcript with the same accumulated left and right matrices to the
inequality `6 ≤ actionCost`. Therefore:

> ~~Minimal word length for the fixed certificate remains open.~~
> It is exactly six in the one-sided `E(q)` alphabet.

This is not a contradiction with `no_historical_actionCost_decoder`: the
eight-step padded word still proves that the history actually taken is absent
from the endpoint. Nor does the theorem price formation or bit-height of an
arbitrary integer quotient `q`; that is the next typed cost coordinate.

## 7. Cache-relative quotient acquisition is a state transition

The next coordinate is now typed in the smallest exact model that distinguishes
application from acquisition.  Let `K` be a retained list of integer
coefficients.  Replaying `E(q)` costs one action, plus one acquisition exactly
when `q` is absent from `K`; the transition then retains `q`.  For a quotient
word `u`, write

```text
Φ(K,u) = final retained cache,
C(K,u) = applications + first acquisitions.
```

Lean checks both composition laws for arbitrary integer words:

\[
 \Phi(K,u{+\!+}v)=\Phi(\Phi(K,u),v),
 \qquad
 C(K,u{+\!+}v)=C(K,u)+C(\Phi(K,u),v).
\]

Thus the cost is an additive cocycle only after its intermediate cache state
is threaded.  The transcript exposes a declared left-then-right coefficient
serialization

```text
[0, 1, 1, 2, -1, -5].
```

It has six applications and five distinct coefficients.  Consequently Lean
checks

```text
cachedActionCost [] kuttaka610Transcript = 11
cachedActionCost [0,1,2,-1,-5] kuttaka610Transcript = 6.
```

The theorem `no_cache_independent_actionCost` uses this collision to refute
every proposed `price : DiagonalEuclidTranscript → Nat` that is required to
equal marginal cached cost for all initial caches.  This is the exact
`diag(6,10)` instance of the corpus's F42 yield: formation cost is a transition
on `(object, cache)`, not a static attribute of the object.

The scope is deliberately narrow.  Unit first acquisition is a declared
model, not the bit complexity of forming `q`; the transcript did not record an
original left/right interleaving, so left-then-right is an explicit pricing
serialization; no eviction, provenance DAG, alternative construction policy,
or optimal quotient-production theorem is claimed.  Those require more state,
not a reinterpretation of this scalar.

## 8. A replayable signed coefficient operation

The opaque first-acquisition unit now has one exact refinement.  In the
declared alphabet

```text
inc : z ↦ z + 1,
dec : z ↦ z - 1,
```

`runCoefficientTrace` starts from an integer and replays a word with its head
acting first.  Lean proves the threading law

\[
 \operatorname{run}(z,u{+\!+}v)
 =\operatorname{run}(\operatorname{run}(z,u),v).
\]

A `CoefficientWitness` packages an integer value, a signed trace from zero,
and a proof that replay reaches that value.  Erasing a list of these witnesses
to its values commutes exactly with the value-cache transition:

```lean
WitnessedCoefficientWord.finalCache_eq_valueCache
```

The witness-weighted word cost charges one for each Euclidean action and, on a
cache miss, the length of the supplied coefficient trace.  Its append theorem
is again a state-threaded cocycle.  For the checked `diag(6,10)` word, witnesses
for

```text
[0, 1, 1, 2, -1, -5]
```

replay exactly and erase to the existing transcript.  The total is `15` from
an empty value cache and `6` when all five values are retained.

This refinement also kills a false formation exactly.  The coefficient `1`
has both the valid trace `[inc]`, of cost one, and the valid trace
`[inc,inc,dec]`, of cost three.  Therefore no function of the resulting
integer alone can recover historical formation work; Lean proves
`CoefficientWitness.no_value_cost_decoder` from the two certificates.

The boundary exposed by the Weyl cache return remains intact.  Signed-unary
length is replay work in one linear grammar, not bit complexity or an optimal
addition-chain cost.  Shared subexpressions would require a witness DAG and
can exhibit complementarity; no submodularity, greedy, eviction, or
left/right-interleaving theorem is inferred here.

Focused replay builds 831 jobs and the aggregate `lake build Pairfield` builds
8,783 jobs, with inherited linter warnings only.

## 9. The first proposed shared prefix is a false formation

The next attempted DAG was not accepted merely because it displayed a shared
node.  The checked transcript needs coefficients `2` and `-1`, and the path

```text
0 --inc--> 1 --inc--> 2
              \\--dec,dec--> -1
```

does form both values.  `CoefficientEdge` now makes each arrow replayable;
`CoefficientEdge.trans` composes arrows, and `cost_trans` proves that their
signed-unit lengths add exactly.

If this fork is forced, the cache work-saved values for retaining neither
endpoint, only `2`, only `-1`, or both are `0,1,2,4`.  Thus the marginal saving
of `-1` rises from `2` to `3` after `2` is retained.  The Weyl
shared-prerequisite calculation is real for that declared recipe.

But it is not the cost geometry of the current coefficient grammar.  The
legal direct edge `0 --dec--> -1` costs one, whereas the route through `1`
costs three.  Forming `2` directly and `-1` directly costs `3`; the proposed
shared fork costs `4` from empty.  Lean checks something stronger for the four
endpoint-cache states: `optimalPairCost_eq_directPairCost`.  The recipe minimum
always selects the direct-pair cost.  Its work-saved table is `0,2,1,3`,
satisfying the modular equality instead of the forced fork's strict
complementarity.

Therefore the formation “coefficient `1` is a load-bearing shared prerequisite
for forming the kuṭṭaka coefficients `2` and `-1`” is false in the signed-unary
grammar.  A displayed common ancestor is not yet a reusable dependency; all
admissible shorter constructions must participate in the price.  This is the
arithmetic analogue of the live DAG rejection: structural sharing earns a
changed cost only after it survives comparison with the representation's
existing canonical routes.

This fixed no-go does not prove that all signed-unary cache objectives are
modular, classify optimal multi-target traces, or touch addition-chain DAGs.
It removes one tempting fork and leaves the general recipe-minimized boundary
open.  Focused replay builds 832 jobs; aggregate `lake build Pairfield` builds
8,790 jobs with inherited linter warnings only.
