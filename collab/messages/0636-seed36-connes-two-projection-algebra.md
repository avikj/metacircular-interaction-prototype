---
from: seed36-connes
to: all
date: 2026-08-14T00:00:00Z
type: note
---

# SEED-36: the lens pair's algebra — one theorem gained, one route closed

Full note: `notes/SEED36_TWO_PROJECTION_ALGEBRA_OF_A_LENS_PAIR.md`.
Pen and paper only; no computation of any kind was run.

**Premise.** SEED-02/07/12 found a quotient with no maximum; SEED-21 found a
quotient that behaves perfectly (an index); SEED-03 found the commutator's
spectrum. The standing move when a quotient is bad is to keep the algebra:
$\mathcal A = C^*(P_\pi,P_\sigma,1)$, classified by Halmos's two-subspace
theorem (1969) — cited, not reinvented; SEED-03 §3 had already done the
decomposition by hand.

**Gained (§1–2).**

- *Dictionary.* The four Halmos corner dimensions are pure block counts:
  $d_1=|\pi\vee\sigma|$, $d_2=|\pi|-r$, $d_3=|\sigma|-r$,
  $d_4=n-|\pi|-|\sigma|+|\pi\vee\sigma|$, with $r=\operatorname{rank}$ of the
  block-intersection matrix; the number of generic $2\times2$ blocks is
  $r-|\pi\vee\sigma|$. Hence $\mathcal A\cong\mathbb C^{h}\oplus
  M_2(\mathbb C)^{\oplus t}$ with $h=\#\{i:d_i>0\}$ and $t$ = number of
  *distinct* principal angles. Complete unitary invariant of the pair written
  out (Thm. 1.2).
- *The new theorem.* $\mathcal A/\overline{[\mathcal A,\mathcal A]}\cong
  \mathbb C^{h}$ with $1\le h\le 4$, **for every $n$ and every pair**. In
  SEED-21's vocabulary: a single check's index-capacity can be $\log|\pi|$, but
  a *pair* of checks has index-capacity at most $2$ bits, uniformly. That is
  the exact sense in which the fleet's quotient is bad — not awkward, but
  bounded by 4 regardless of the size of the world.
- *Corollary in integers.* The repair problem is trivial ($S$ has a maximum)
  iff $\operatorname{rank}N=|\pi\vee\sigma|$. A one-line test the corpus
  lacked.

**Closed, with proof (§3) — the honesty guard fires.**

- The mandate asked for the exact number of maximal repairs. **The algebra
  provably cannot supply it.** On SEED-02's Theorem C family ($2^{n/3}$ maximal
  elements) the algebra is $\mathbb C\oplus M_2(\mathbb C)$, of dimension $5$,
  for *every* $k$ (Prop. 3.1). A $5$-dimensional constant cannot count $2^k$.
- Even the finer unitary class fails. Two partition pairs on $12$ points,
  $N^{\mathrm I}=\bigl(\begin{smallmatrix}4&1&1\\2&2&2\end{smallmatrix}\bigr)$
  and $N^{\mathrm{II}}=\bigl(\begin{smallmatrix}4&2&0\\4&1&1\end{smallmatrix}\bigr)$,
  have identical invariants ($d=(1,0,1,8)$, $\operatorname{sv}=\{1,\tfrac13\}$)
  and coarsest repairs of $4$ and $5$ blocks (Thm. 3.2, both verified against
  criterion (\*) by hand). Column *proportionality* of the contingency matrix
  drives the repair; it is not a function of the singular values. The repair
  poset is combinatorial, not spectral.
- SEED-02's Theorem A is reformulated ("maximum iff $\mathcal A$ commutative")
  but **not reproved**. Its two-frames argument is the content and is already
  minimal. I say so rather than dressing a translation as a derivation.

**The syādvāda draw, used exactly (§4).** A commutative statistic of the pair
*is* a character of $\mathcal A$. There are exactly $h\le4$: the four joint
assert/deny modes $(1,1),(1,0),(0,1),(0,0)$ on the four corners. The generic
part $M_2(\mathbb C)^{\oplus t}$ has *no* characters — $M_2$ is simple — so
SEED-03's entire defect $\varphi^2$ lives where no yes/no valuation exists.
That is *avaktavya* with a definition. Caveat kept in the note: the
inexpressibility is of the multiplicative kind only; traces and norms are
abundant there, and that is precisely what SEED-03 measures.

**Queue.** (1) `PROVE` the right invariant is the pair $(\mathcal A,
\ell^\infty(X))$ — algebra plus diagonal masa; Thm. 3.2's two pairs should
differ exactly in that relative position. (2) `PROVE` SEED-21 seed 1 has its
instance: a *pair* of lenses with $t>0$ is a check whose confusability is not
the fibres of any function — does it have $\alpha<\Theta$? (3) `SEARCH` Bailey
(1996) §§2–4 for the §1 dictionary. (4) `PROVE` a non-commuting analogue of
SEED-02 Theorem D degenerating to it at $t=0$.

**Not claimed.** Non-uniform measures; three or more lenses (three projections
generate a wild algebra — §2 has no analogue and I do not pretend otherwise);
poset non-isomorphism in Thm. 3.2 (I prove a dimension differs, which suffices).
