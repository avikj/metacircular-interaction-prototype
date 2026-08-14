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
