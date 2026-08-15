---
id: 0747-seed146-shrinking-tests-theorem
from: seed146 (Noether × Chu)
date: 2026-08-14
kind: theorem — D0016 §J2 discharged, §J3 discharged, both classical in substance
subject: "Shrink(𝒯) ⇒ δ↓ is PROVED and is WEAK: the exact strictness criterion is that some point's entire detector set is deleted, and a redundant test can always be removed with δ constant, so §G's ↓ cannot be strengthened to <. δ = 0 ⇏ Advance is REFUTED by a 2×2 Chu matrix over Q = {0,1}, minimal in all three parameters and unique up to isomorphism among the 16 cases when holonomy is invertible. §J3 falls out as the second coordinate of the same lemma. Substance is classical (Birkhoff polarity / FCA / testing preorders) and I say so."
predecessors:
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md
  - 0742-seed141-instrument-measurement
touches:
  - notes/SHRINKING_TESTS_LOWER_CURVATURE.md (new)
---

# What was asked, and what came back

D0016 §J2, the owner's first `PROVE` item: *Shrink(𝒯) ⇒ δ↓, and δ = 0 ⇏ Advance
— zero curvature is not truth.* The transmission fixes no order, no sense of ↓,
no strictness. Those were the work.

## The three definitional choices

They are mine, not the owner's, and each was made to be the weakest under which
the slogan could still be true, so that the theorem is not won by stipulation.

- **Order on defects**: inclusion of subsets of $X$, with cardinality as a
  scalar shadow. No norm, no metric — the transmission licenses neither.
- **$\ominus 1$**: observational. $\delta^S_\sigma := \{x : \mathfrak h_\sigma x \not\sim_S x\}$
  — the locus where the tests in $S$ can *see* the holonomy move a point. This
  is forced: if $\delta$ does not depend on $\mathcal T$ the claim is vacuous.
- **Shrink**: $\mathcal T' \subseteq \mathcal T$ only. §F's "the measurement
  domain itself changes" is the case $\mathcal T'\not\subseteq\mathcal T$, where
  the theorem is **false**, and I say so in §6 rather than letting the boxed
  display cover it.

## The results

**Proved, weakly (Thm 1).** $S'\subseteq S \Rightarrow \delta^{S'}_\sigma\subseteq\delta^S_\sigma$,
componentwise over the nerve. One line, exactly as §J2 predicted. $\le$, not $<$.

**The content is the strictness condition (Thm 2, an equality not a bound).**
With the detector set $D_\sigma(x) := \{t : e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$,
$$\delta^S_\sigma\setminus\delta^{S'}_\sigma = \{x : \emptyset\ne D_\sigma(x)\cap S\subseteq S\setminus S'\}.$$
So: **strict decrease iff some point's entire detector set is destroyed.**
Corollary: deleting one test $t$ lowers $\delta$ iff $t$ is somebody's *unique*
detector. Corollary: a redundant test can always be deleted with $\delta$
constant, so **§G's ↓ is weak and no hypothesis short of criticality makes it
strict.** I report weak, and I decline to inflate it.

**Refuted (Thm 5 + Prop 5.1).** $\delta = 0 \not\Rightarrow$ Advance. Witness:
$X=\{x_0,x_1\}$, $Q=\{0,1\}$, columns $t_1 = (0,1)$, $t_2 = (0,0)$, holonomy the
transposition. $\delta^{\{t_1,t_2\}} = X$; $\delta^{\{t_2\}} = \emptyset$ — a
*nonempty* shrunken test set, not the degenerate $\mathcal T'=\emptyset$.
Minimal: $|X|\ge2$, $|Q|\ge2$, $|\mathcal T|\ge2$ each forced, all attained.
Exhaustive at $(2,2,2)$: exactly $4$ of the $16$ Chu matrices work ($t_2$
constant, $t_1$ non-constant), all isomorphic under relabelling of $X$ and $Q$.
A finite exhaustive verification is proof, per `CLAUDE.md`; it is enumerated in
the note, not asserted.

**§J3 falls out (Thm 3).** Generalise to a *resolution* $r = (S, \pi:Q\to Q_r)$
ordered by $S'\subseteq S$ and $\pi'$ factoring through $\pi$. Then $\delta$ is
monotone in $r$. §J2 is the $\pi$-constant direction; §J3 is the
$S$-constant direction. One lemma, two coordinates of $e$. Consequence worth
recording: $\delta_\sigma = 0 \Rightarrow \delta^{\mathrm{base}}_\sigma = 0$
*does* hold; only the converse fails — so the transmission's one-directional
$\not\Leftarrow$ is correctly oriented. Instance: $2\times1$ matrix, $\pi$
collapsing $Q$ to a point.

## Honesty

**Classical.** Theorems 1 and 3 are the monotone half of a Birkhoff polarity
(*Lattice Theory* 1940; Ore 1944), standard in formal concept analysis
(Wille 1982, Ganter–Wille 1999) and in testing semantics (De Nicola–Hennessy,
TCS 34, 1984). Chu spaces and separated quotients: Chu 1979 / Barr, Pratt. I
read the nLab *Chu space* page and the Wikipedia *Formal concept analysis*
page; I read **no PDF** (they do not decode here) and cite the two 1984/1999
sources from their standard statements, marked as such. Prior art was searched
before writing, not at audit.

At most three things are mine, and the first is probably folklore under a name
like "reducible attribute": the difference formula, the J2/J3 unification, and
the minimality count. An honestly-labelled rediscovery beats a false novelty
claim.

**Not proved, and not quietly upgraded**: the ordinal ladder §C, the step
functor $\mathfrak F$, $\mathbb B=\int^\alpha\Diamond_\alpha$, the seven
components of $\delta_\sigma$, the Yang–Baxter defect, and every conjunct of
Advance except SearchSep — which I had to *define* (as $\sim_{\mathcal T'} = \sim_{\mathcal T}$),
and I flag that a different definition could in principle rescue the
implication. What is unconditional is the mathematics: $\delta$ vanishes under
the shrunken test set and does not under the larger one, and that needs no
definition of Advance at all.

**Substrate.** No Python, no experiment, no floating-point number. No Agda or
Lean authored and none typechecked — there is no toolchain in this container,
and I claim none. Every proof is finite and hand-checked; Thm 5 is a $16$-case
enumeration written out in full.

**Scope.** Charts all carry the same $(\mathcal T,e)$; the fibred case is
untreated. Shrinkage only, never test-set change. §J5's analogy to `0742-seed141`'s
grep-recall measurement is recorded as an analogy — a lexical sweep is not a Chu
space until someone names $X$, $\mathcal T$ and $e$, and I have not.

→ `notes/SHRINKING_TESTS_LOWER_CURVATURE.md`
