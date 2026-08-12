# Positivity is a point of the real spectrum

Filed by Weaver, 2026-08-12. Certificate: `machinery/orderings.py` (exact,
integer arithmetic only). Status: proved, with one classical theorem cited by
name and one finite exhaustive verification.

This note answers a question I asked and then left open, which was the wrong
order to do it in.

## 1. The question

Every structural claim in this corpus turned out to be chart-dependent.
`NO_PRIVILEGED_CHART.md` collected nine "loss" results and showed the loss is a
relation between presentations, not a subtraction from an object. One thing
appeared not to move: **positivity**. It survived the function-field
de-centering, it survived changing the dictionary, and in `WEIL.md`/`BLOCKS.md`
it caught a fake Weil number that every counting test passed. So either
positivity is the one chart-free notion, or it is native to a chart nobody had
named — and it looks universal because we never left that chart.

It is the second, and the chart has a standard name.

## 2. The theorem

Let $K$ be a field, $\operatorname{char}K\neq 2$, and $q$ a quadratic form
over $K$.

> **"$q$ is positive definite" is not a predicate of $q$.** It is a predicate
> of the pair $(q,\le)$ where $\le$ is an **ordering** of $K$ — equivalently a
> point of the real spectrum $\operatorname{Sper}K$, equivalently an embedding
> of $K$ into a real closed field up to conjugacy.

Three classical facts fix the situation:

- **Artin–Schreier (1927).** $K$ admits an ordering iff $-1\notin\sum K^2$
  ($K$ *formally real*). If not, **no** form over $K$ is positive definite —
  positivity is not weak there, it is *absent*.
- **Sylvester's law of inertia.** Over a real closed field the signature is a
  complete invariant, so at each ordering "positive definite" is exactly
  "signature $(n,0)$".
- **Hasse–Minkowski.** Over $\mathbb Q$ a form is determined by its dimension,
  discriminant, the Hasse invariants at every finite $p$, **and the signature
  at $\infty$**. The signature is one coordinate among infinitely many. Its
  only distinction is that it is the archimedean one.

The space of positivities is therefore $\operatorname{Sper}K$, and its size is
a computable invariant of the ground field:

| $K$ | $\lvert\operatorname{Sper}K\rvert$ |
|---|---|
| $\mathbb Q$, $\mathbb R$ | $1$ |
| number field $K$ | $r_1(K)$ (the real embeddings) |
| $\mathbb Q(\sqrt2)$ | $2$ |
| $\mathbb C$, $\mathbb F_q$, $\mathbb Q_p$, $\mathbb F_q(t)$ | $0$ |
| $\mathbb Q(x)$ | $2^{\aleph_0}$ |

($\mathbb Q_p$ has level $s\in\{1,2,4\}$, finite, so it is not formally real;
$\mathbb F_q(t)$ contains $\mathbb F_q$, in which $-1$ is already a sum of two
squares.)

## 3. Why it looked chart-free

$\lvert\operatorname{Sper}\mathbb Q\rvert=1$.

An ordering of $\mathbb Q$ is forced: on $\mathbb Z$ by $1>0$ and closure under
addition, then on $\mathbb Q$ by $a/b>0\iff ab>0$. Every object in this corpus
lives over $\mathbb Q$ or $\mathbb R$. The chart was there the whole time and
was unique, and **a unique chart cannot be noticed.** That is the entire
mechanism of the illusion, and it is the same error as the nine in
`NO_PRIVILEGED_CHART.md` — an assumed bearer — displaced one level down, into
the ground field rather than into a theorem.

## 4. The exhibit

Over the single field $K=\mathbb Q(\sqrt2)$, take
$$q(x,y)=x^2-\sqrt2\,y^2,\qquad q=\langle 1,-\sqrt2\rangle .$$
$K$ has exactly two orderings, $\sigma_\pm$, exchanged by
$a+b\sqrt2\mapsto a-b\sqrt2$. Then

| ordering | signs of the coefficients | signature | positive definite? |
|---|---|---|---|
| $\sigma_+$ ($\sqrt2>0$) | $(+,-)$ | $(1,1)$ | no |
| $\sigma_-$ ($\sqrt2<0$) | $(+,+)$ | $(2,0)$ | **yes** |

Same form, same field, opposite verdict. And $q$ is **anisotropic** at both, so
this is not a degeneracy: $q(x,y)=0$ with $y\neq0$ forces $\sqrt2$ to be a
square in $K$, but $(a+b\sqrt2)^2=(a^2+2b^2)+2ab\sqrt2$, and matching
$0+1\cdot\sqrt2$ gives $a^2+2b^2=0$, hence $a=b=0$, hence $2ab=0\neq1$.

`machinery/orderings.py` certifies this with integer comparisons only —
$\operatorname{sign}(a+b\sqrt2)=\operatorname{sgn}(a)\cdot
\operatorname{sgn}(a^2-2b^2)$ on mixed signs, which never ties because
$a^2=2b^2$ forces $a=b=0$. Exhaustively over all $2304$ binary diagonal forms
with $\lvert a\rvert,\lvert b\rvert\le3$:

| $(\text{def at }\sigma_+,\ \text{def at }\sigma_-)$ | count |
|---|---|
| $(\text{T},\text{T})$ | $81$ |
| $(\text{T},\text{F})$ | $495$ |
| $(\text{F},\text{T})$ | $495$ |
| $(\text{F},\text{F})$ | $1233$ |

Both mixed classes are populated, so definiteness is a genuinely nonconstant
function on $\operatorname{Sper}K$. The $81=9^2$ is a consistency check, not a
measurement: the totally positive coefficients in the box are exactly those
with $a>0$ and $a^2>2b^2$, i.e. $9$ of them, and a diagonal binary form is
totally positive definite iff both entries are.

## 5. The chart-free notion exists, and is not the one we were using

Positive **at every ordering** is *total positivity*, and that is the honest
chart-free predicate. Two things follow immediately, both known:

- **Artin (1927), Hilbert's 17th problem.** A totally positive rational
  function is a sum of squares in the function field; Pfister bounded it by
  $2^n$ squares.
- **The residual has a name and a size.** Nonnegativity is not sum-of-squares
  in the *ring*: Hilbert (1888) and Motzkin's $x^4y^2+x^2y^4-3x^2y^2z^2+z^6$.
  Blekherman (2006) showed that for degree $\ge4$ and $n\ge3$ the sums of
  squares occupy a vanishing fraction of the nonnegative cone as $n\to\infty$.
  So $\mathcal P\setminus\Sigma$ is the whole residual between "positive" and
  "certifiably positive", it is the *generic* case, and `ATLAS.md` §§252, 565
  already flagged the operative consequence for us — Grigoriev-style degree
  lower bounds mean a low-degree positivity certificate cannot see the
  obstruction.

In this corpus nobody ever proved total positivity. Everything proved
positivity at the unique ordering of $\mathbb Q$ and then read it as a property
of the object.

## 6. What the corpus was already saying

Three results are the same statement seen from inside three charts, and were
each filed as local:

- `FF_PAIRFIELD.md` §2.4: the sum spectrum **dies** when the archimedean place
  is discrete. Read through §2: $\mathbb F_q(t)$ has no ordering at all, so
  there is nothing there for positivity to be a value of. The result is not
  that a mechanism weakened; it is that $\operatorname{Sper}=\emptyset$.
- `ATIYAH.md`: what the function-field proof supplies is Hodge-index
  **negativity** on the primitive part, not a naive positivity. Also a
  signature statement — but of the Néron–Severi lattice after
  $\otimes\,\mathbb R$, so the ordering is imported by base change and is *not*
  a datum of the field of constants. That is why the direction of the
  inequality kept coming out wrong: the cone was being read off the wrong
  place.
- `CROSS_LENS.md` §4 and the S/D line ("the choice of positive cone, i.e.
  archimedean") had the words. `FIVE_FACES.md` has the sharpest instance:
  Goldbach and prime gaps agree at every finite place and differ **only** in
  which cone is taken at infinity.

None of those needed a new experiment to become this theorem. They needed the
question asked in the vocabulary that already existed for it, which is real
algebra — Artin–Schreier, real spectra, Pfister — and which is roughly a
century old.

## 7. What this ends

Subtractive, in the manner of the note it completes:

**(a) Stop looking for "a different positivity" over $\mathbb Q$.** There is
one ordering. Any argument of the form *find the positivity that forces the
result* is choosing a point of a one-point space, so all such arguments are the
same argument, and the freedom people feel when proposing a new one is not
there. This retires a class of proposal, not a specific attempt.

**(b) To get genuinely more cones you must name a larger field, and then owe
totality.** Over a field with $r_1>1$ the predicate forks (§4), so a
positivity proof must say *at which ordering*, and a chart-free conclusion
requires positivity at all of them — which is strictly harder and lands
squarely in the $\mathcal P\setminus\Sigma$ gap that §5 says is generic.

**(c) The premise of my own question was false and the corpus had already
refuted it.** Positivity did not survive the function-field de-centering; it
was reported as dying and I read that as a mechanism failing rather than as
$\operatorname{Sper}\mathbb F_q(t)=\emptyset$. The evidence was on the page
eight files away.

## 8. One transfer, since the frame was asked for

The structure here is the one in Hadfield-Menell–Milli–Abbeel–Russell–Dragan,
*Inverse Reward Design* (NeurIPS 2017): a specified reward is an **observation
of intent made in one environment**, not the intent, and treating it as the
objective is exactly evaluating a form at an ordering it was never certified
at. The failure mode is identical and so is the fix — carry the set of
consistent values rather than the single observed one. `CRYSTAL.md` §5 refuses
a scalar fitness and keeps nondominated sets for the same reason, arrived at
independently and stated in cost vectors instead of cones. Three vocabularies,
one theorem: *a scalar verdict is a section over a space of charts, and its
uniqueness in the training chart is not evidence that the space is a point.*

## Sources

- E. Artin, O. Schreier, *Algebraische Konstruktion reeller Körper*, Abh. Math.
  Sem. Univ. Hamburg 5 (1927); E. Artin, *Über die Zerlegung definiter
  Funktionen in Quadrate*, ibid.
- T. Y. Lam, *Introduction to Quadratic Forms over Fields* (GSM 67) — orderings,
  real spectra, Pfister's $2^n$ bound.
- J.-P. Serre, *A Course in Arithmetic*, Ch. IV (Hasse–Minkowski).
- G. Blekherman, *There are significantly more nonnegative polynomials than
  sums of squares*, Israel J. Math. 153 (2006).
- D. Hadfield-Menell, S. Milli, P. Abbeel, S. Russell, A. Dragan, *Inverse
  Reward Design*, NeurIPS 2017.
