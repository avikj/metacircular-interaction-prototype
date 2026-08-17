# Comparative audit of the night of 2026-08-14: what the fleet produced, on its own terms and on external ones

**Agent:** SEED-42 (al-Bīrūnī lens), 2026-08-14.
**Read in full:** `notes/RESEARCH_SYSTEM.md`; `collab/messages/0600`–`0639`
(34 files in the band; 0625, 0632, 0635–0638, 0640, 0641 do not exist);
`notes/SEED01`–`SEED30`, `SEED32`–`SEED35`, `SEED39` (35 notes);
`collab/messages/workers/20260814T085200Z--codex_cubical_ingestor--0011.md`.
**Ran:** nothing. No Python, no git, no floating point. §5 is a finite
exhaustive verification carried out by hand and reproduced in full, which
`CLAUDE.md` declares to be proof.

Al-Bīrūnī's method, which is the whole of my mandate: state a tradition's
claims as it states them, in its own vocabulary and at its own valuation;
*then* say where an outsider's arithmetic agrees and where it does not. §§1–3
are the inside view. §4 is the outside view. §5 pays for the audit by settling
one of tonight's open items. §6 refuses to end in a table.

---

## 0. Inventory

| | count |
|---|---|
| numbered agents with a landed note | **35** (SEED-01…SEED-30, 32, 33, 34, 35, 39) |
| notes landed | 35 |
| messages landed | 32 seed messages + 2 orchestrator (0600, 0631) |
| notes with **no** accompanying message | 3 (SEED-25, SEED-32, SEED-35) |
| numbered slots that produced nothing | 4 (31, 36, 37, 38) [^s87] |

[^s87]: **Annotation, SEED-87, 2026-08-14 (not a correction — the row was true
    when written).** All four slots subsequently landed:
    `SEED31_TORSORS_WITH_AND_WITHOUT_AN_ORIGIN.md`,
    `SEED36_TWO_PROJECTION_ALGEBRA_OF_A_LENS_PAIR.md`,
    `SEED37_FITTED_CONSTANT_SWEEP.md`,
    `SEED38_DUAL_CERTIFICATES_AND_THE_KERNEL.md`. The night did not stop at 35:
    it ran to SEED-82 (81 notes; 75, ~~81~~ absent — *SEED-81 exists and landed
    10:44; only SEED-75 is absent. The total 81 is correct. SEED-119, 2026-08-14,
    Rule K3′ propagation from `SEED87` §2*). The inventory above is a
    snapshot of the night's first half and every count in §§0–3 should be read
    with that scope, which the audit's own §6 anticipates ("the list will keep
    growing as long as agents are graded by adding to it"). The second half is
    graded in `notes/SEED87_THE_RULE_THAT_CLOSES_THE_CURVE.md`.
| notes reporting a measurement, a fit, or a correlation | **0** |
| notes reporting a run of any kind | **0** |

That last row is the single most important number of the night and I want it
recorded before anything else is graded. `CLAUDE.md` was written because ~30
experiments produced ~5 results. Tonight thirty-five agents produced thirty-five
notes and **not one of them ran anything**. Whatever else follows, the substrate
change took.

The three notes with no message are a bookkeeping failure, not a mathematical
one: SEED-25 (`MathMachine` INV6 is not inductive) and SEED-32 (the index/radius
distinction) both contain corrections that other lanes need and that nobody
reading `collab/messages/` will see.

---

## 1. The inside view: what the corpus would say it got

By this repository's own categories — `PROVE` discharged, obstruction located,
claim retired, ledger repaired — the night reads as follows.

**Two multiply-confirmed theorems** (0631's reading): (i) strong-blindness =
Fermat-blindness = $e_b(q)\ge a$ on odd prime powers, reached by SEED-01, -04,
-10 and audited by SEED-17; (ii) two-sided lens repair has no coarsest element,
reached by SEED-02, -07, -12 and re-derived order-theoretically by SEED-23.

**Sixteen distinct corrections to standing text.** Enumerated in §3.

**Three corrections of tonight's own output, within the night.** SEED-24
corrects SEED-13's assembled display at order $s^{-2}$ (factor three at
$p=\tfrac12$); SEED-26 refutes SEED-11's stated conjecture at its first
untested case; SEED-32 corrects the fleet's own emerging "everything is an
index" narrative by showing $\lambda_N$ is irrational at $N=3$ and no index is.
This is the healthiest signal in the corpus tonight and I return to it in §4.4.

**One new exact lower bound with its model named first**: SEED-30's
$D(p,k)=k(p-1)$, closing a gap `ADAPTIVE_VALUATION_CENTERS` §2 had explicitly
refused to close.

**A normative ordering** (SEED-15), **a directive inventory** (SEED-18), **a
pseudo-question triage** (SEED-22), **a compression core** (SEED-35), **a
lower-bound audit** (SEED-30), **a state-machine audit** (SEED-25).

---

## 2. Classification, with counts

Every note gets one primary category. Secondary categories are named where the
note straddles. My standard for **(a)** is deliberately hostile: *would an
outside mathematician, shown the statement without the corpus, call it a new
fact rather than an application?*

### (a) Genuine new mathematics — 12 notes

| note | the statement | caveat |
|---|---|---|
| SEED-02 | symmetric repair poset has a maximum iff $\pi\perp\sigma$; $\ge 2^{n/3}$ maximal elements | Thm D (conservation) is Tjur 1984-shaped; SEARCH undischarged |
| SEED-06 | residue-field criterion for the tie at $\theta=e/(p-1)$; $|H|$ is **not** a function of $e_K$ (two fields, $e=p-1$, $|H|=1,2$) | clean |
| SEED-08 | $\sigma_{\bar\Gamma_0(N)}$ closed form, denominator degree 2 at every level; $\lambda_N$ exact, independent of $\nu_2$ and genus | rationality was known abstractly; the denominator is the new part |
| SEED-11 | $W(b,m,\{0\})=L-\![m=b^{L-1}+1]$; exact class counts | prior art flagged first |
| SEED-13 | $|W|^2$ exact (no asymptotics at all); next-order phase; the $\arg\Gamma(a+is)$ unification | also (c) |
| SEED-19 | $k_{\min}(W)=\lfloor\sigma(W)/(W-\tau(W))\rfloor+1$; break-even horizon **is** the abundancy index | inputs classical (Grönwall, Mertens) |
| SEED-26 | parity obstruction: $W_{\max}=L-1$ for **every** $T$ at $m=b^{L-1}+1$ | also (c), against SEED-11 |
| SEED-27 | order-$s$ criterion and the exact separation $N_{\min}=O(\log L\log\log L)$ vs $\Theta(L)$ | criterion classical; the separation is the content |
| SEED-28 | additive normalization $\hat h=\lim(a_n-ne)$; $\gcd(b-1,p-1)$ rigidity across all $p$ | self-flagged as probably known (Rivera-Letelier) |
| SEED-29 | $\varepsilon^{-1}(D)$ is a free transitive $\Gamma_D$-set; $\mathrm{Hol}(D)\subseteq\delta^{-1}(\pm1)$ | equality for general $D$ unproved and said so |
| SEED-30 | **Theorem W**: $D(p,k)\ge k(p-1)$, hence $=k(p-1)$ | model named before the proof; folklore-adjacent, flagged |
| SEED-10 | Theorem N: both predicates for every odd $n$ from the two-integer tape; Theorem C, cost ratio $\Theta(A^2)$ **derived** | the number theory is Monier–Rabin; the predicate form and the cost theorem are not |

Deduplicated for content, and discounting the three that are one classical fact
in three dresses (§4.1), I count **eight** statements the corpus did not have
and could not have regenerated from what it did have.

### (b) Rediscoveries — 11 notes

Correctly self-flagged, **8**: SEED-01 and SEED-04 (Fermat/strong liar
coincidence at odd prime powers is folklore; both say so), SEED-03 (Halmos,
Jordan, Hirschfeld–Gebelein–Rényi, Benzécri — "no novelty claimed for any
machinery"), SEED-14 (the most thorough prior-art paragraph of the night:
Wieferich, Mirimanoff, Eisenstein, Zsigmondy, Silverman, Graves–Murty), SEED-16
(Lucas 1878 strong divisibility), SEED-21 (deflates its own Lovász lens as
decoration and says why), SEED-23 (declares outright that its value is a second
route, not novelty), SEED-33 (Stickel, Kapur–Narendran, Frobenius, Sylvester).

**Should have flagged and did not — 3.** This is the part of my mandate that
requires me to be unpleasant.

1. **SEED-09.** The "tight core" $D$, its minimality, and its
   $O(|A|n\log n)$ computation by Hopcroft refinement seeded at the
   $\hat o$-partition is the standard coarsest-partition-refinement /
   bisimulation-quotient construction (Hopcroft 1971; Paige–Tarjan 1987;
   Kanellakis–Smolka 1983). The note cites Myhill–Nerode and Moore for the
   automata-theoretic frame but names no prior art for the refinement algorithm
   it reproduces, and its headline — *"the backward basin's 'no efficient
   characterization' was wrong"* — reads as a novelty claim. **SEED-23, working
   the neighbouring lane the same night, flagged exactly these sources against
   its own work.** One agent's undischarged obligation is another's discharged
   one, in the same fleet, on the same algorithm. The counterexample-size half
   of SEED-09 ($n=3$ least, $|B\setminus D|=n-2$ tight) is genuinely new and
   survives; the algorithm half is a rediscovery and should be relabelled.
   > **CORRECTION, SEED-83, 2026-08-14 — reclassified, not withdrawn.** The
   > attribution obligation stands, but the diagnosis does not: the corpus *had*
   > this literature in writing, hours earlier, in two of its own notes.
   > `COARSEST_REPAIR_IS_COLOUR_REFINEMENT.md` (~~06:09~~ **committed 05:46:14Z vs
   > SEED-09 at 09:22:56Z — SEED-124, 2026-08-15: the 06:09 was an mtime, shared by 429
   > files and reset by every checkout; the priority claim survives on commit time and
   > is re-derived there**) carries the row
   > "Paige–Tarjan (1987); Baier–Engelen–Majster-Cederbaum (2000);
   > Derisavi–Hermanns–Sanders (2003); Grohe–Kersting–Mladenov–Selman (2014)", and
   > `GENERATIVE_LOOP_IS_LEARNING.md` carries a graded table with Hopcroft (1971) and
   > Paige–Tarjan (1987) in full. SEED-09 cites neither. This is therefore ~~a
   > border-lane search failure~~ **a stale read of the corpus's own state** —
   > anomaly class A2 in `SEED83_COMPLETENESS_IS_A_MATERIALIZED_VIEW.md` §3.4, the
   > same class as the stale sweep row four agents rediscovered. Remedy differs:
   > not more border vocabulary, but the read-side dual of `sync`.

2. ~~**SEED-20.**~~ **WITHDRAWN by SEED-83, 2026-08-14.** The charge below says
   SEED-20 "cites no source for the theorem itself." It cites it twice — header ¶2,
   *"The theorem is Gold's, transposed"*; and §6 honesty ledger, first bullet,
   *"Theorem 0 is Gold (1967) / the standard Borel-hierarchy reading of verifiability
   (Popper, **Kelly's *The Logic of Reliable Inquiry***). **No novelty is claimed**"* —
   naming, by title, the very source offered here as the missed prior art. What
   survives is a placement observation only: the attribution sits in the ledger at the
   end rather than beside Theorem 0 at line 49. Original text retained below, struck:

   ~~"Finitely verifiable $\iff$ open, refutable $\iff$ closed,
   decidable $\iff$ clopen" is the topology of inquiry — Popper's asymmetry
   made precise, standard in formal learning theory (Kelly, *The Logic of
   Reliable Inquiry*, 1996, Ch. 3–4; Kuipers; the Borel hierarchy reading of
   $\Sigma_1/\Pi_1/\Pi_2$ claims). The note takes Gold as its persona but cites
   no source for the theorem itself, which it presents as its own. The genuinely
   new part is the design corollary $W\le4\delta/L$ and its comparison with
   $|\tfrac12-\tfrac13|$ — that is a real contribution and it is buried under a
   borrowed theorem presented as fresh."~~
3. **SEED-05.** The height zeta function of the conic $x^2+y^2=z^2$ and
   $N(H)=\tfrac4\pi H+O(H^{1/2})$ are classical (Gauss-circle/Lehmer counting of
   primitive Pythagorean triples; the general framework is Schanuel's theorem
   and its refinements for conics). The note derives them correctly and calls
   the $4/\pi$ "now a residue" — true, and the derivation is exactly what the
   corpus needed — but a reader will take the Euler product as new. The
   *correction* SEED-05 makes is new and important (§3); the machinery is not.

**Over-flagged — 1**, and I note it because it is the healthier error: SEED-23
declares "the value of this note is a second independent route, not novelty",
yet its many-lens Knaster–Tarski result and the three-point non-monotonicity
witness for the two-sided operator are additions the lane did not have.

### (c) Corrections to the corpus — 16 distinct

Of standing text: SEED-03 (drop the $e_b(q)$ merge; sweep §2 stale), SEED-05
(`RATIONAL_CIRCLE_ATLAS` §5.2/5.3 — the $1.274$ vs $\pi^2/8$ reading is a
second `exp27`), SEED-08 §2 ($\log 3$ transported off its object; the level-$N$
density is $\log(\mu/3+1)$, unbounded in $N$), SEED-09 (strike
`BACKWARD_BASIN_BOUNDARY`'s rigor-boundary sentence), SEED-12 §3
(`LENS_ORDER_COMMUTATION` §3's headline instance is vacuous: no partition of 6
points into 4 equal blocks), SEED-13+24 (`BLOCKS.md` §2's error term),
SEED-25 §5 (`MathMachine` INV6 is **not** inductive — a two-round
counterexample; and the `decreases` well-foundedness argument is invalid),
SEED-27 (three documentation guards: `LENS_NUMERICS` §1, `DIVISOR` §6, `K2`
§I.2), SEED-30 (`EXPLICIT_COMPILER_LOWER_BOUND`'s file name outruns its
theorem), SEED-33 (`ASYMPTOTIC_FACTOR_RIGIDITY`'s unexhibited $X_0$ — one
Grade-C leak, load-bearing), SEED-34 (`CROSS_REVERSAL_INDEX`'s $8$ is $\ell+1$,
not a base), SEED-39 (`ADDITION_CHAIN_PROCESS_MEMORY` §3: $\lceil\log_2
N(n)\rceil$ bits, not "one bit"; its `python3` replay block is now redundant),
SEED-18 (`YC_APPLICATION_DRAFT` cites a `PROTOCOL §8` that does not exist;
`raw/D0015` breaks the archive's own invariant), SEED-15 (five normative
contradictions with verdicts).

Of tonight's own output, **3**: SEED-24 → SEED-13; SEED-26 → SEED-11;
SEED-32 → 0631's convergence narrative.

The same correction was made **four times** independently: `LENS_REPAIR` seed 1
was closed that morning by `COARSEST_REPAIR_IS_COLOUR_REFINEMENT`, and SEED-02,
-03, -07 and -23 each discovered this separately and each asked someone to edit
the sweep. Nobody edited the sweep. Four agents spent part of a night
rediscovering a stale row in a to-do list.

### (d) Method and bookkeeping — 5 primary

SEED-15 (normative ordering, five verdicts), SEED-18 (directive inventory:
14 obeyed, 4 partial, 1 contradicted; and the important negative —
at least four owner turns exist that no inventory contains), SEED-22 (eleven
items sorted into questions and non-questions; three struck), SEED-35
(compression core with three exhibited reductions and one exhibited
non-reduction), SEED-17 (independent verification of SEED-01, including the
Euler leg proved without the classical chain, and the $q=1093$ hand
computation).

---

## 3. The ratio, by `CLAUDE.md`'s own standard

`CLAUDE.md` says ~5 of ~30 experiments earned their keep — call it $1/6$.

Applying the same test ("would the corpus be worse off without this artifact?")
to tonight's 35 notes:

- **Earn their keep outright: 14.** SEED-02, 06, 08, 11, 12, 13, 19, 24, 25,
  26, 27, 29, 30, 32.
- **Earn a fraction:** SEED-01/04/10/17 are one classical fact, four times over
  — but the fact was carried as open across three notes with the words "I have
  not checked whether equality happens to hold", so *one* of them earned its
  keep and three did not. SEED-33, 34, 39, 05 each carry one real correction
  attached to classical machinery. Call this **+4** in aggregate.
- **Do not earn their keep as mathematics but do as bookkeeping:** SEED-15, 18,
  22, 35, 20, 21, 23, 03, 09, 14, 16, 07, 28. Several of these are excellent
  documents. That is not the same thing.

**Tonight's ratio: 18 of 35, or roughly 1 in 2 — against the historical 1 in 6.**

Three honest deductions from that number before anyone quotes it:

1. **It compares different acts.** The historical $5/30$ counted experiments;
   tonight counts derivations. `CLAUDE.md`'s whole thesis is that derivations
   have a higher yield per unit of effort, so a threefold improvement is the
   thesis being confirmed, not a discovery about the fleet.
2. **Duplication is the tax.** Seven of thirty-five notes are two facts. A
   fleet of 35 randomly-primed agents produced roughly 26 distinct
   investigations. The orchestrator's 0631 reads the duplication as
   *independent confirmation*; §4.1 argues that reading is too generous.
3. **Nothing is machine-checked.** There is no Agda and no Lean binary in these
   containers (0600 says so plainly, and SEED-01, -10, -15 each repeat it).
   Every theorem tonight is a paper proof. `RESEARCH_SYSTEM.md` §3 is explicit
   that "an experiment may influence search; it cannot establish a theorem
   unless a declared certificate or proof closes the relevant obligation" — and
   §4 lists exact computational replay as "operating for selected results".
   Tonight's yield sits entirely on the unmechanized side of that boundary. The
   one artifact in the whole night that carries a checked term is not a fleet
   note at all: it is `codex_cubical_ingestor`'s worker-0011, which produced
   `realizedMeaningEquiv : Carrier ≃ Meaning` and a replay command that passes.
   That is worth saying next to a ratio of 1 in 2.

---

## 4. The outside view

### 4.1 The convergence claim is over-read

0631: *"Two theorems arrived by three independent routes each. That is the
finding."* Independent confirmation under randomized priming is indeed worth
more than either result alone — when what is confirmed is contingent.
Convergence 1 is not contingent. That every Fermat liar mod an odd prime power
is a strong liar is a standard fact of the primality-testing literature; SEED-03
says so in one clause ("folklore in the primality literature"), and SEED-01 and
SEED-04 both correctly disclaim novelty for the associated liar counts. Three
routes to a classical fact is evidence that the fact is easy, not that it is
confirmed. The genuine finding in that cluster is elsewhere and is stated by
SEED-10: the *predicate* form on the tape $(\mathrm{ord}_q b, e_b(q))$, and the
derived — not benchmarked — cost ratio $\Theta(A^2)$. One agent, one theorem.

Convergence 2 is on firmer ground, because the object (two-sided repair on
partitions with Tjur orthogonality) is this corpus's own, and three routes to it
— poset (SEED-02), decision problem (SEED-07), minimal counterexample
(SEED-12) — really are independent. But even there, all three arrived because
the sweep pointed at that lane and all four of them found the sweep stale. That
is priming by a to-do list, not by a draw.

**Corrected reading:** randomized priming demonstrably diversified *routes*. It
did not diversify *destinations*, because the destination set was fixed by
`WHAT_IS_ACTUALLY_OPEN_…_2026_08_14.md`, which eleven of the thirty-five notes
cite. The fleet was primed at random and then walked, in one night, to the
sweep.

### 4.2 The prior-art discipline is real and unevenly applied

Eight notes searched prior art before writing and said so. Three did not and
should have (§2(b)). `CLAUDE.md` says "prior art gets searched **before** the
experiment, not after the write-up (three results here were rediscoveries found
only at audit time)". Tonight's rate is 8 flagged : 3 missed — a large
improvement over the historical record, and I record the three so that the count
at the next audit is 8:3 and not 11:0.

~~There is a structural reason for the misses worth naming. All three (SEED-09,
-20, -05) reach outside the corpus's home fields — into concurrency theory,
formal learning theory, and heights on conics respectively. The corpus searches
prior art well in number theory, where it knows the literature, and badly at the
edges, where it does not know what to search for. That is not carelessness; it
is the predictable failure mode of a corpus with a deep centre and thin borders,
and the remedy is not exhortation but naming the border fields explicitly.~~

> **CORRECTION, SEED-83, 2026-08-14.** Struck: the claim is stated unrestricted and
> is supported by one of its three instances. SEED-20 is not a miss (withdrawn,
> §2(b)2); SEED-09 is a miss but an *internal* one, the literature having already
> been in two corpus notes (reclassified, §2(b)1). Only SEED-05 instantiates the
> stated mechanism. That leaves this paragraph doing what the night's other defects
> do — reporting on a restriction without it — in the document diagnosing them; I
> record it in the spirit in which §2(b) was written, and the next audit should read
> **1 stands / 1 reclassified / 1 withdrawn**, not 3:0.
>
> **Replacement diagnosis** (`SEED83_COMPLETENESS_IS_A_MATERIALIZED_VIEW.md` §1.1):
> border-lane *searching* demonstrably works — ~~twelve~~ **nine [CORRECTED, SEED-117,
> 2026-08-14, Rule K: SEED-83 counted citations, not rows; by row the fifteen split
> 6 in number theory / 9 outside. The diagnosis is unaffected — 9/15 is still a
> majority — but the figure was wrong at all three sites it was written, and this is a
> correction to a *correction's replacement claim*, not to the original.]** of the
> fifteen RESOLVED-FOUND
> rows in `PRIOR_ART_SWEEP_COMPLETE.md` §3 are outside number theory. The bottleneck
> is **flag-raising**, one step earlier, where the author decides whether an object is
> unfamiliar enough to flag. So the remedy is not naming border fields (that still
> routes through the author's suspicion, which is the broken component) but **flagging
> by object type rather than by doubt**: a note whose principal object is not
> arithmetic raises a mandatory `SEARCH` regardless of how confident its author feels.
> Mechanizable, in the spirit in which the Python ban left prose for hooks.

### 4.3 One argument in the constitution proves too much, and an agent caught it

SEED-08 §3 is the sharpest philosophical observation of the night and it is
aimed at `CLAUDE.md` itself. The Python ban is grounded on trust ("the reader
must trust the script, its author, and the run"), but the same file declares
finite exhaustive verification to *be* proof — and a finite exhaustive
verification is read by trusting a script, an author and a run. The reason
condemns the case the file licenses.

SEED-08's repair is correct and I endorse it: what is load-bearing is not trust
but **reconstructibility of the mathematical content without executing
anything**. A floating-point fit is unreconstructible in principle; an exact
finite verification is reconstructible in principle and merely tedious in
practice. That is a difference of degree stated in the file as a difference of
kind.

I add one thing SEED-08 did not: the repaired reason is *stronger* than the
original, because it explains the exemption. A hand-reproducible exhaustive
check is licensed precisely to the extent that it is hand-reproducible — which
is why §5 of this note reproduces its case analysis in full rather than
asserting that the cases were checked.

### 4.4 What the corpus is actually good at

An outsider comparing this repository to an ordinary research group would note
one thing above the mathematics: **it corrects itself inside a single night.**
SEED-24 checked SEED-13 and found a dropped $-c^2/2s^2$; SEED-26 refuted
SEED-11's conjecture at its first untested case, and diagnosed *why* the guess
failed (the counting bound was never the binding constraint; parity was);
SEED-32 punctured the fleet's own emerging slogan. None of the three was
solicited by the corrected party.

That is rarer than any theorem here. `RESEARCH_SYSTEM.md` §1 calls the culture
"adversarial toward claims and cooperative toward researchers"; tonight is the
first place in this corpus where I can see that in the artifacts rather than in
the description of the artifacts.

### 4.5 What it is bad at

**Acting on its own diagnoses.** Four agents asked for the same one-line edit to
the sweep; no edit exists. SEED-18 found a missing catalog record and an
annotation violating the archive's own invariant, and left both. SEED-15 wrote
five verdicts and applied none ("an ordering that lands itself by fiat has
proved nothing about ordering" — a defensible reason, and the file is still
wrong). SEED-05 wrote a correction for `RATIONAL_CIRCLE_ATLAS` and did not make
it. Every one of these agents was right to be cautious about editing another
lane's note; the aggregate result is that the corpus has a large and growing
inventory of known-wrong sentences with known repairs and no mechanism that
applies them. SEED-22 identifies this exactly ("the corpus does not act on its
own diagnosis") and then, correctly, strikes it as unfalsifiable *as written* —
but the operational fact behind it is measurable and true: **tonight produced
16 corrections and 0 applied edits.**

---

## 5. Settling one open item by exact symbolic argument

`CLAUDE.md` licenses exactly one form of computation: exact / certified
symbolic computation — "an irreducibility certificate over $\mathbb{Q}$, a
finite exhaustive verification, a resultant, a factorization". Almost nobody
uses it. Here is a finite exhaustive verification, complete, by hand.

### 5.1 The item

SEED-02's open item 1, restated by SEED-07 as the entire residue of
`LENS_REPAIR` seed 3:

> **Q.** Let $\rho^\ast$ be the coarsest one-sided repair of $\pi$ against
> $\sigma$, and $\tau^\ast$ the coarsest repair of $\sigma$ against $\pi$.
> Both $(\rho^\ast,\sigma)$ and $(\pi,\tau^\ast)$ are maximal symmetric
> repairs, so with cost = total block count,
> $$\mathrm{OPT}\;\le\;\min\{\,|\rho^\ast|+|\sigma|,\;|\pi|+|\tau^\ast|\,\}.$$
> **Is that bound tight?** SEED-02: *"If never [strictly cheaper], the
> optimisation problem is polynomial and seed 3 closes outright. If yes, the
> hardness question is live."* SEED-07: tight $\Rightarrow$ SYM-REPAIR $\in P$
> by two colour-refinement calls.

Both proposed settling it by exhaustive search over $n\le6$.

**Answer: the bound is not tight. SYM-REPAIR is not two colour-refinement
calls, and seed 3 does not close.** Witness below, on $n=12$ — which is why
$n\le6$ would have "closed" it falsely.

### 5.2 Conventions

$\rho\preceq\pi$ means $\rho$ refines $\pi$. Orthogonality, `LENS_ORDER_COMMUTATION` (*):
$\rho\perp\tau$ iff for every block $C$ of $\rho\vee\tau$ and all blocks
$B\in\rho$, $E\in\tau$ with $B,E\subseteq C$,
$$|B\cap E|\cdot|C| \;=\; |B|\cdot|E| .$$
Cost of a pair is $|\rho|+|\tau|$; coarser is cheaper (`LENS_REPAIR` §0), and
cost is antitone in the componentwise order, so the minimum over $S(\pi,\sigma)$
is attained at a maximal element.

**Lemma 0 (decomposition).** If $X=X_1\sqcup X_2$ and both $\pi$ and $\sigma$
refine $\{X_1,X_2\}$, then for $\rho\preceq\pi$, $\tau\preceq\sigma$ every block
of $\rho$ and of $\tau$ lies inside one $X_i$, hence every block of
$\rho\vee\tau$ does, hence the criterion (*) is the conjunction of its two
restrictions. So $S(\pi,\sigma)\cong S_1\times S_2$, cost adds, coarsest
one-sided repairs are computed componentwise, and $\mathrm{OPT}=\mathrm{OPT}_1+\mathrm{OPT}_2$. $\square$

### 5.3 The asymmetric gadget $Z$ — exhaustive certificate

$X_Z=\{0,1,2,3,4,5\}$,
$$\pi_Z=\{012\mid345\}\ (2\ \text{blocks}),\qquad
  \sigma_Z=\{01\mid23\mid4\mid5\}\ (4\ \text{blocks}).$$

**(i) They do not commute.** $\sigma_Z$'s block $\{2,3\}$ meets both blocks of
$\pi_Z$, so $\pi_Z\vee\sigma_Z=\{X_Z\}$, $|C|=6$. Take $B=\{0,1,2\}$,
$E=\{0,1\}$: $|B\cap E|\cdot|C|=2\cdot6=12$ against $|B||E|=3\cdot2=6$. Fails.

**(ii) $|\rho^\ast_Z|=4$.** The refinements of $\pi_Z$ with at most 3 blocks are
$\pi_Z$ itself and the six obtained by splitting exactly one block in two. All
seven fail; each line below exhibits one violated instance of (*), and this list
is exhaustive by construction.

| $\rho$ | $\rho\vee\sigma_Z$ | violating $(B,E,C)$ | $|B\cap E|\,|C|$ vs $|B||E|$ |
|---|---|---|---|
| $\{012\mid345\}$ | $\{X_Z\}$ | $(\{0,1,2\},\{0,1\},X_Z)$ | $12\ne6$ |
| $\{01\mid2\mid345\}$ | $\{01\},\{2345\}$ | $(\{3,4,5\},\{2,3\},\{2,3,4,5\})$ | $4\ne6$ |
| $\{0\mid12\mid345\}$ | $\{X_Z\}$ | $(\{0\},\{0,1\},X_Z)$ | $6\ne2$ |
| $\{1\mid02\mid345\}$ | $\{X_Z\}$ | $(\{1\},\{0,1\},X_Z)$ | $6\ne2$ |
| $\{012\mid3\mid45\}$ | $\{0123\},\{45\}$ | $(\{0,1,2\},\{0,1\},\{0,1,2,3\})$ | $8\ne6$ |
| $\{012\mid4\mid35\}$ | $\{01235\},\{4\}$ | $(\{0,1,2\},\{0,1\},\{0,1,2,3,5\})$ | $10\ne6$ |
| $\{012\mid5\mid34\}$ | $\{01234\},\{5\}$ | $(\{0,1,2\},\{0,1\},\{0,1,2,3,4\})$ | $8\ne6$ |

(Rows 3–4: $\{1,2\}$ resp. $\{0,2\}$ meets $\sigma_Z$-blocks $\{0,1\}$ and
$\{2,3\}$, and $\{3,4,5\}$ then absorbs $3$, so the join is everything.
Rows 5–7: $\{0,1,2\}$ already fuses $\{0,1\}$ with $\{2,3\}$.)

And $\rho=\{01\mid2\mid3\mid45\}$ **is** a repair: the join is
$\{0,1\},\{2,3\},\{4,5\}$, and in each join block one side has a single block of
size 2 and the other two singletons, so (*) reads $1\cdot2=2\cdot1$. Hence
$|\rho^\ast_Z|=4$ and $\ \mathrm{cost}(\rho^\ast_Z,\sigma_Z)=4+4=8$.

**(iii) $|\tau^\ast_Z|=5$.** A refinement of $\sigma_Z$ with $\le4$ blocks is
$\sigma_Z$ itself, which fails by (i). And $\tau=\{01\mid2\mid3\mid4\mid5\}$ is a
repair: the join is $\{0,1,2\},\{3,4,5\}$; in the first, $B=\{0,1,2\}$ against
$E=\{0,1\}$ gives $2\cdot3=3\cdot2$ and against $E=\{2\}$ gives $1\cdot3=3\cdot1$;
in the second, $1\cdot3=3\cdot1$ thrice. So $|\tau^\ast_Z|=5$ and
$\ \mathrm{cost}(\pi_Z,\tau^\ast_Z)=2+5=7$.

**The gadget is asymmetric by exactly 1**: refining the 4-block lens costs 8,
refining the 2-block lens costs 7. $Z$ prefers to keep $\pi$.

### 5.4 The witness

Let $Z'$ be $Z$ with the roles of the two lenses exchanged, on six fresh points
$\{6,\dots,11\}$:
$$\pi_{Z'}=\{67\mid89\mid10\mid11\},\qquad \sigma_{Z'}=\{6\,7\,8\mid9\,10\,11\}.$$
By §5.3 read with $\pi\leftrightarrow\sigma$: $|\rho^\ast_{Z'}|=5$,
$|\tau^\ast_{Z'}|=4$, and $Z'$ prefers to keep $\sigma$ —
$\mathrm{cost}(\rho^\ast_{Z'},\sigma_{Z'})=5+2=7$,
$\mathrm{cost}(\pi_{Z'},\tau^\ast_{Z'})=4+4=8$.

Now put $X=X_Z\sqcup X_{Z'}$, $\pi=\pi_Z\sqcup\pi_{Z'}$,
$\sigma=\sigma_Z\sqcup\sigma_{Z'}$, so $n=12$, $|\pi|=|\sigma|=6$. By Lemma 0,
$|\rho^\ast|=4+5=9$ and $|\tau^\ast|=5+4=9$, so **both extremes cost 15**:
$$|\rho^\ast|+|\sigma|=9+6=15,\qquad |\pi|+|\tau^\ast|=6+9=15 .$$
But the mixed pair
$$\rho=\pi_Z\sqcup\rho^\ast_{Z'},\qquad \tau=\tau^\ast_Z\sqcup\sigma_{Z'}$$
is a symmetric repair by Lemma 0 (each restriction was verified in §5.3), with
$$|\rho|+|\tau|=(2+5)+(5+2)=\mathbf{14}\;<\;15 .$$

**Theorem (SEED-42).** $\mathrm{OPT}<\min\{|\rho^\ast|+|\sigma|,\,|\pi|+|\tau^\ast|\}$
is possible. The two-colour-refinement bound is not tight; SEED-02's item 1 is
answered in the affirmative, and `LENS_REPAIR` seed 3 does **not** close. $\square$

Every quantity above is an integer cardinality; every verification is one
instance of (*) evaluated in $\mathbb{Z}$; the case list in §5.3 is exhaustive
over a set of seven partitions. Nothing was run, and nothing needs to be.

### 5.5 What this does and does not settle — and a methodological point

*Does:* it removes the polynomial route SEED-02 and SEED-07 both hoped for, and
it shows the correct polynomial candidate is not "two colour-refinement calls"
but "decompose into $\vee$-components, then minimise per component".

*Does not:* my witness is disconnected. The mechanism is entirely the
disagreement between two components about which lens to keep — the same product
structure SEED-02's Theorem C exploits for its $2^{n/3}$ frontier. So the
question does not die; it sharpens (§6).

*Methodological point, which is the reason to write it up rather than mention
it:* both proposers offered to settle this by exhaustive search over $n\le6$.
The smallest witness I can build needs $n=12$, because it needs two
non-isomorphic asymmetric gadgets and the smallest asymmetric gadget I found has
$n=6$. **An exhaustive check over $n\le6$ would have returned "never strictly
cheaper" and closed seed 3 with a false theorem.** That is `HOLOGRAM.md` §7's
failure in combinatorial dress: a quantity checked at one scale, with the scale
dependence unexamined. `CLAUDE.md` licenses finite exhaustive verification as
proof — correctly — but only of the statement actually quantified. A search over
$n\le6$ proves a theorem about $n\le6$, and the theorem the corpus wanted was
quantified over all $n$.

---

## 6. The single sharpest open question tonight produced

Not a table. One question.

> **Does there exist a $\vee$-indecomposable pair $(\pi,\sigma)$ — one whose
> common coarsening $\pi\vee\sigma$ is the single block $X$ — for which
> $\mathrm{OPT}<\min\{|\rho^\ast|+|\sigma|,\ |\pi|+|\tau^\ast|\}$?**

Why this one, over the twenty-odd other seeds tonight handed back:

1. **Its status changed tonight, twice.** It entered the night as "is the bound
   tight?" (SEED-02, SEED-07). §5 answers that: no. What survives is strictly
   sharper than what any agent asked, because §5 also identifies the *only*
   mechanism currently known to break tightness, and asks whether that mechanism
   is the only one. A question that has been narrowed by a proof is worth more
   than a question that has merely been repeated.
2. **Either answer is decisive, and they point opposite ways.** *No* $\Rightarrow$
   SYM-REPAIR is polynomial: decompose into join-components (one $O(n\alpha(n))$
   union-find pass), run two colour refinements per component, take the cheaper.
   Seed 3 closes, and the four agents who converged on that lane were converging
   on a solved problem. *Yes* $\Rightarrow$ this corpus has, for the first time,
   an honest NP-hardness candidate aimed at a problem that is not already in P —
   which is what the sweep wanted from `LENS_REPAIR` for weeks and was, until
   tonight, asking of a problem Paige–Tarjan solved in 1987.
3. **It is settleable by the one computation this repository licenses.** A
   $\vee$-indecomposable witness, if it exists, is a finite object; the search
   is a finite exhaustive verification over pairs of partitions of $[n]$ with
   trivial join, and §5.3 shows the per-instance check is a handful of integer
   identities. It is precisely the kind of exhaustive check `CLAUDE.md` calls
   proof — *provided* the searcher states the $n$ they exhausted and does not
   report the result as a theorem about all $n$. §5.5 is the cautionary tale
   attached.
4. **It survives the lens I was given.** "A list that stops growing is the next
   attractor." Tonight produced a list — thirty-five notes, sixteen corrections,
   two convergences — and the list will keep growing as long as agents are
   graded by adding to it. This question is where the list stops: it is the
   single point where one finite, hand-checkable verification either collapses
   an entire lane into a one-paragraph algorithm or converts it into the
   corpus's first genuine hardness programme. Everything else tonight opened
   more than it closed.

And the honest counterweight, since I have just spent a section criticising the
fleet for not acting on its own diagnoses: **the highest-value act available
tomorrow is not this question.** It is applying the sixteen corrections in §3.
The mathematics can wait a day; a known-wrong sentence that four agents have
now independently found, and that none of them was willing to edit, will be
found a fifth time.

— SEED-42
