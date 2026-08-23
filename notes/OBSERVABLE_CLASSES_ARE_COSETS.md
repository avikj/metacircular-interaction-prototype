# Observable classes are cosets — and the parity criterion is one coordinate of a character

**Author.** cf-poincaré (Claude Opus 5), 2026-08-14.
**Module.** `formal/cubical/NaturalMachine/GaugeOrbitClasses.agda`
(`--cubical --guardedness --safe --no-import-sorts`; cold build exit 0, **0
warnings**, no postulates, no holes). **Orphan**: not imported by
`NaturalMachine.agda`, therefore *not* covered by the root aggregate's green
claim — see `formal/cubical/BUILD.md`, which exists because that exact
overstatement was made here before. Folding it in is the integrator's call.
**Consumes.** `TARGET.md` §§1–6, `NaturalMachine/ParitySeparator.agda`,
`NaturalMachine/ChargeCriterion.agda` (cf-sakshi, both landed today);
`notes/GAUGE.md` §F.1 for the torus; `runtime/render/channel.py` for the
vocabulary of §4.
**Does not touch.** `BARRIER.md` Problem 2 and W3 (both under concurrent work
by other seats), Goldbach, twin primes, any arithmetic.

---

## 0. Verdict, up front

`ChargeCriterion` is **correct as written and narrower than it reads.** Its
criterion — *a query set separates σ₊ from its gauge flip iff some query has
odd Ω* — is the evaluation of a **character of the gauge group at one group
element**. Restoring the group gives the theorem `TARGET.md`'s own headline
promises and does not yet have:

> **Theorem (observable classes).** For a query list `qs`, let
> `qs^⊥ = {τ ∈ G : val τ n = +1 for all n ∈ qs}`, a subgroup of the gauge group
> `G = ({±1}^{primes}, ·)`. Then for all sign assignments σ, σ′,
> $$\mathrm{obs}\,\sigma\,qs \;=\; \mathrm{obs}\,\sigma'\,qs
> \quad\Longleftrightarrow\quad \sigma'\sigma \in qs^{\perp}.$$
> The fibres of the transcript map are exactly the cosets of `qs^⊥`.

Checked: `classes-⇒`, `classes-⇐`; subgroup by `ann-unit`, `ann-mul`,
`ann-self-inverse`. An observer restricted to `qs` learns exactly which coset
it is in — no more (blindness, `no-decision⋆`) and no less (the separator is
**constructed**, `charge⇒separator⋆`), for an arbitrary adversary τ and an
arbitrary base point σ, both of which the prior modules fix.

And the correction, with a checked witness (§3): **`AllEven` certifies
blindness to one group element, not to the gauge group.**

---

## 1. Why the group and not the pair — the global argument

`ParitySeparator` treats `Signs` as a set carrying an involution `flip`.
It is not. It is a **torsor** over `G = (ℕ → Bool, pointwise ·)`, which is
`GAUGE.md` §F.1's torus, and `flip` is one element of it, the diagonal
$(-1,-1,\dots)$. Once that is said the right lemma is not `flip-law` but

$$\mathrm{val}(\tau\sigma)(n)\;=\;\mathrm{val}(\tau)(n)\cdot \mathrm{val}(\sigma)(n)
\qquad (\texttt{val-⋆}),$$

i.e. for each `n`, the map $\tau \mapsto \mathrm{val}\,\tau\,n$ is a **character
of G**. `flip-law` is that character evaluated at $\tau_- = (-1,-1,\dots)$, and
`flip-law-again` re-derives it from `val-⋆` in three lines — the check that the
generalisation *contains* the special case rather than resembling it.

Everything else is then formal, and short precisely because it is formal.
`Ω(n) \bmod 2` is not a primitive: it is $\langle e(n), \mathbf 1\rangle$, where
$e(n) \in \bigoplus_p \mathbb F_2$ is the exponent-parity vector of `n` and
$\mathbf 1$ is the diagonal element. The barrier reads one coordinate of a
vector-valued invariant, in the direction $\mathbf 1$, and the corpus had been
reading that coordinate as if it were the invariant.

**Prior art, stated before the claim.** The mathematics of §1 and §4 is
**classical** and is graded CITED. A completely multiplicative $\pm1$ function
is a homomorphism $\mathbb Q^{\times}_{>0} \to \{\pm1\}$, hence factors through
$\mathbb Q^{\times}_{>0}/(\mathbb Q^{\times}_{>0})^{2}$ — the **square-class
group**, an $\mathbb F_2$-vector space on the primes; the space of such
functions is its $\mathbb F_2$-dual. Searched 2026-08-14 under the standard
names *square class group*, *dual group of the positive rationals*, *completely
multiplicative function*, and separately *parity problem / sign patterns of
Liouville*: the square-class picture is standard (Wikipedia *Square class*;
arXiv:1405.7130 and arXiv:1906.10060 on harmonic analysis on
$\mathbb Q^{\times}_{>0}$), and the parity-problem literature (Tao 2007/2014,
arXiv:1809.03280, arXiv:2412.17199) is about sign *patterns* and dynamical
obstructions, not about this. **Search metadata only — WebFetch is
egress-blocked and I read no full text; none of these is quoted.** A successor
should not repeat these four queries. What is contributed here is therefore
*not* the mathematics but (a) the checked statement in the corpus's own
observable vocabulary, and (b) §3, which is a correction and is not classical
because the object corrected is ours.

## 2. What the theorem says that the pair version cannot

The pair version answers "can this method see parity?". The class version
answers "**what can this method see at all?**", and the answer is a subgroup.
Three consequences that are unavailable at a single orbit:

1. **Separating power is a subgroup index, not a score.** `qs^⊥` is closed
   under the group operations, so the number of distinguishable classes is
   $[G : qs^{\perp}]$, a power of 2. Adding a query either halves the
   annihilator or leaves it *identical*. There is no in-between; see §4.
2. **The criterion is per-adversary and must be quantified as such.**
   `gauge-criterion τ σ qs` is the honest form: charged ⇒ separator (built),
   neutral ⇒ no separator. Dropping τ from the statement is what produced the
   over-reading in §3.
3. **The base point is irrelevant, and that is a theorem rather than an
   assumption.** `ChargeCriterion` tests only $\sigma_+$, remarking that this
   is "a complete test". It is — but only because the action is by a group, so
   the criterion is base-point free; `charge⇒separator⋆` proves this by
   constructing the separator at an arbitrary σ, which costs one real idea:
   the procedure must *compare* the answer against `val σ n` rather than read
   it, since for a general base point the accepting transcript is not all-true.

## 3. The correction, and its witness (checked)

`ChargeCriterion` §6's own example is the witness against the over-reading its
§4b wording invites.

`probe-6` is the query set $\{p_0p_1\}$, $\Omega = 2$. `probe-6-cannot` proves
it admits no procedure separating $\sigma_+$ from its total flip. That is
true. But let $\tau_0$ flip the sign at the single prime $p_0$ — an ordinary
element of the same torus. Then

- $\tau_- \in \texttt{probe-6}^{\perp}$: `false · (false · true) = true` — `refl`;
- $\tau_0 \notin \texttt{probe-6}^{\perp}$: `false · (true · true) = false` — `refl`;

and `even-but-not-blind` packages both halves as one checked term: the same
even-Ω query set is *provably blind* to the total flip and *provably not
blind* to the gauge group, with the separating procedure constructed at **every**
base point σ.

**What this does and does not damage.** It does not damage the barrier: the
parity barrier *is* about the diagonal element, so "all even Ω ⇒ blind to
parity" stands. It damages the sentence **"All even Ω ⇒ provably
parity-blind, not 'has not yet succeeded'"** *when a reader takes
"parity-blind" to mean "sees no gauge structure"* — which is the reading
`TARGET.md`'s framing of the barrier as *the* gauge invariance invites, and
which §4b's own promotion of the criterion to "a test on a method" makes
operationally consequential. A method passing the even-Ω test can be
extracting a great deal of gauge-theoretic information about the sign
assignment; it is merely not extracting the one bit $\langle \cdot,\mathbf
1\rangle$. The honest statement of the test is: *neutral for $\tau_-$*, and
`ParitySeparator`'s ledger already gestures at this ("**NOT claimed either**:
that 'even Ω' is the exact neutral sector for every sieve") without the
statement that makes it precise. This note supplies it.

## 4. The argument with `TARGET.md` §2: W4 cannot be a theorem about query sets

`TARGET.md` orders its wins W1 < W2 < W3 < W4, with

> **W4 — the coupling theorem.** … how much archimedean input, at what depth,
> buys how much parity information.

**At the exact algebraic layer this quantity does not exist, and §7 of the
module is the witness.** `val` is a monoid homomorphism
$(\mathrm{Number},{+}{+}) \to (\{\pm1\},\cdot)$ (`val-++`; the cited lemma is
the operation clause alone, and for monoids the unit clause is independent —
it holds definitionally, `val σ [] = +1`, which is exactly why `val-++ σ [] n`
discharges to `refl` at `GaugeOrbitClasses.agda:437`. [Ground checked and
clause supplied in place by seed132, 2026-08-14, by reading the module; no
typechecking was run. Nothing below uses the unit clause — the argument that
follows consumes only multiplicativity and exponent 2 — so no claim moves.]),
and $\{\pm1\}$ has
exponent 2, so for every `k`

$$\mathrm{val}\,\sigma\,(k^2) = +1 \quad\text{for every }\sigma
\qquad(\texttt{square-neutral}),$$

hence a query at $k^2$ lies in **every** annihilator. Appending it changes no
annihilator (`square-free-of-charge`) and splits no observable class
(`square-adds-no-class`), while naming an arbitrarily large number; and a query
set built entirely of squares is annihilated by the whole group
(`all-squares-blind`). So: **an unbounded family of arbitrarily large queries
whose separating power is exactly zero, forever.** Not small — zero.

Therefore separating power is not monotone in size, not monotone in the number
of queries, and not improvable by any computation on the answers
(`no-decision⋆` is `cong`). "How much parity information" is a question about a
$\mathbb Z/2$-valued character; the only honest answers are 0 and 1 per pair,
and in aggregate an $\mathbb F_2$-dimension.

The constructive half, which is why this is a sharpening and not merely an
objection: **W4, if it is a theorem, is a theorem about a norm, not about a
query set.** The gradient that W4 expects is real, but it lives in how well a
neutral observable *approximates* a charged one in some analytic norm — an
$L^2$ distance, an error term — and not in the algebra of what is read.
Splitting W4 into

- **W4a (algebraic, done, negative):** the separating power of a query set is
  $[G : qs^{\perp}]$ and is unaffected by size — this note;
- **W4b (metric, open):** for a *fixed* neutral query set, how well can a
  charged observable be approximated, and at what cost in archimedean input,

is what the two halves actually are. Conflating them is how a "measured
coupling exponent" would get published for a quantity that is exactly 0 or 1 —
which is `CLAUDE.md`'s recorded failure mode with the sign reversed: not a
fitted constant standing in for $\tfrac14$, but a fitted *gradient* standing in
for a step function.

**On §0's triage, briefly, since I was invited to argue with it.** I accept
Fermat and Goldbach/twin-primes. I do **not** accept "RH: not a target, a
tool". The triage's own reason — everything in the corpus is *downstream* of
the zeros — is a statement about where this corpus currently reads, and by the
theorem above that is a statement about a query set, which is exactly the kind
of thing that changes when the vocabulary changes. `FF_PAIRFIELD.md` §4 is the
existence proof: it moved the place, and half the corpus's "spectral" structure
turned out to be archimedean dressing. The triage row should read *"not a
target **with the present readings**"*, which is a weaker and defensible claim.

## 5. Two lenses, disagreeing (the assignment's question)

- **Darwin** (variation + selection + time): methods are a population, the
  barrier is a selection filter, and one expects a *fitness gradient* — partial
  charge, incremental improvement, W4's continuum. Darwin predicts more/larger
  queries buy more separating power.
- **Kovalevskaya** (the singular case others avoided): the avoided case here is
  the **partial flip** — everyone looks at the diagonal because the word is
  "parity" — and the **degenerate query**, the square. Taking both: §3 shows the
  partial flip is visible to a query the diagonal cannot see, and §4 shows the
  degenerate query is invisible to everything. Separating power is a subgroup
  index and jumps by a factor of 1 or 2.

**They disagree, and Kovalevskaya wins on the exact layer, provably.**
`square-adds-no-class` is a checked counterexample to the gradient. Darwin is
not wrong about the enterprise — method variation *is* how the odd-Ω queries got
found — but the fitness landscape he needs is a landscape on *approximations*,
not on query sets, and that is W4b. The lens disagreement is therefore not a
tie: it localises exactly which of W4's two halves each lens is entitled to.

**Where the ancient lens is load-bearing rather than ornamental.** Eudoxus's
theory of proportion (Elements V, def. 4 — the Archimedean condition: for
magnitudes $a,b$ some $na$ exceeds $b$) is the hypothesis that makes "how much"
a *question*. The gauge group fails it: $n\cdot x \in \{0,x\}$. So "how much
charge does this query carry" is not an unanswered question but a **malformed**
one, in the precise sense the Greeks isolated. Archimedes' own division of
labour is the corpus's protocol — the *Method* gets the answer mechanically,
then exhaustion proves it — and here the mechanical stage is exactly what
manufactures the illusion of a gradient (`LIOUVILLE.md`'s correlation
0.9999–1.0000, quoted approvingly in `TARGET.md` §1), while the exhaustion
stage returns an object with two values.

**And the frontier lens, likewise.** Efficient coding (Barlow/Attneave) says a
code must not spend capacity on distinctions no task uses; `runtime/render/channel.py`
implements exactly that as `over_separations`, and its Proposition ("no channel
gains information": `|image| ≤ |L|`, the induced partition is a coarsening of
equality) is §5's theorem with the group forgotten. What the group adds is that
the partition is not merely *some* coarsening but a **homogeneous** one — the
"neural manifold" of transcripts is a coset space, flat, of dimension
$\log_2 [G : qs^{\perp}]$. That is a much stronger statement than
`channel.py` can make, and it is available only because a group acts. Against
predictive coding I record a genuine mismatch rather than an analogy: predictive
coding assumes the residual carries what the prediction missed; here the
residual $\sigma'\sigma$ is *annihilated*, so there is a component of the state
that no amount of residual processing recovers.

## 6. Rigor boundary / honesty ledger

- **PROVED (machine-checked, cold build exit 0, 0 warnings, no postulates, no
  holes):** `val-⋆`; `flip-law-again` (so `flip-law` is a corollary);
  `qs^⊥` a subgroup; `obs-agree⋆` / `no-decision⋆`; `charge⇒separator⋆`
  (constructed, arbitrary τ and σ); `gauge-criterion`; **`classes-⇐` /
  `classes-⇒`** (the class theorem); `even-but-not-blind` (§3's witness);
  `val-++`, `square-neutral`, `square-invisible`, `square-free-of-charge`,
  `square-adds-no-class`, `all-squares-blind` (§4's no-gradient family).
- **CITED, not read.** The square-class picture and the $\mathbb F_2$-duality
  are classical; graded from search metadata only, no full text opened. See §1.
- **REFUTED.** The reading "`AllEven` ⇒ blind to the gauge structure", by
  `even-but-not-blind`. Also refuted: any statement of the form "separating
  power grows with the size or number of queries", by `square-adds-no-class`.
- **NOT REFUTED, and I say so plainly.** `ChargeCriterion`'s theorem,
  `ParitySeparator`'s theorem, and `TARGET.md`'s choice of target. §3 is a
  scope correction to prose, not a counterexample to a theorem.
- **OPEN.** (i) W4b, the metric half — untouched here, and I make no
  conjecture about it. (ii) The $\mathbb F_2$-rank formula
  $\#\text{classes} = 2^{\operatorname{rank}\{e(n)\}}$: true and easy on paper,
  **not formalised** — it needs finite-dimensional linear algebra over
  $\mathbb F_2$ that this module does not build, and I decline to assert it as
  checked. (iii) The full square-class statement (val is constant on square
  classes *in any arrangement of factors*) needs permutation-invariance of
  `val`, which is **not proved**; §7 proves only the concatenated form.
- **No computation was run.** No numerics, no floating point, no Python, no
  fitted anything. The only new verification is the Agda module.
- **Standing-queue tag.** `[PROVE]` discharged for the class theorem.
  New `[PROVE]` opened: W4b as stated in §4, for whoever wants the metric lane.
