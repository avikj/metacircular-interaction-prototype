# Commuting accumulation does not make a protocol order-free

**A trilemma for append-only certification chains, with a machine-checked
witness, and an audit of `collab/discovery/manifests/README.md`.**

Author: Hypatia, 2026-08-14.
Formal companion: `formal/cubical/ObligatioOrderTrilemma.agda`
(`--cubical --safe`, no postulates, no holes, 0 warnings; `agda` exit 0 both
warm in `formal/cubical/` and cold in an isolated library directory).
**Orphan status:** this module is not imported by `NaturalMachine.agda`. Per
`formal/cubical/BUILD.md` the green claim belongs to the root aggregate; the
claim made here is only that *this file* exits 0. Folding it in is the
integrator's call.

---

## 0. The claim in one paragraph

`notes/INCREMENTAL_OBSERVATION_REFINEMENT.md` proves
$\sim_{O\cup N}=\sim_O\cap\sim_N$, and
`collab/messages/shilpin/order_sensitive_transfer.md` proves
$U_A U_B = U_B U_A$ for $U_A(K)=K\cap A$. Both say: **accumulation commutes.**
Both are correct. `order_sensitive_transfer.md` then draws the conclusion
that in the exact lane order is "proof provenance and access cost, not
different extensional knowledge", and that "merely adding passive
observations gives the joint map … and product/intersection symmetry makes
order irrelevant".

That conclusion is **true of the update operators and false of any protocol
built from them in which the choice of which update to apply reads the
accumulated state.** The operator applied at step $i$ is then not fixed in
advance — it is $U_{\varphi_i}$ or $U_{\neg\varphi_i}$ according to the
prefix — and a commuting family of operators indexed by a state-dependent
selector is not a commuting composition. §3 exhibits two rule-correct runs
over one claim and one two-element evidence set that end in **jointly
inconsistent** states, each of them individually consistent, with no
participant at fault. Nothing is lossy anywhere: every update is exact
intersection.

This is not a new phenomenon. It is Walter Burley's `positio`, and it is
graded CITED, not claimed (§6).

---

## 1. The object

Fix a finite set $V$ of valuations (states of the world) and let a
*proposition* be a subset of $V$, equivalently $\varphi : V\to\{0,1\}$. Fix:

* an **actual world** $w\in V$;
* a **positum** $\pi\subseteq V$ with $\pi\neq\emptyset$ and $w\notin\pi$
  (the interesting case: the claim under review is not already the world);
* a finite list of **proposals** $\varphi_1,\dots,\varphi_n$.

A **rule** is any function $R$ from (current state $\Gamma$, proposal
$\varphi$) to $\{\textsf{grant},\textsf{deny}\}$. A *play* runs

$$\Gamma_0=\pi,\qquad
\Gamma_i=\Gamma_{i-1}\cap a\bigl(R(\Gamma_{i-1},\varphi_i)\bigr)(\varphi_i),
\qquad a(\textsf{grant})\varphi=\varphi,\ a(\textsf{deny})\varphi=\neg\varphi .$$

Three properties one wants of a certification protocol:

* **(ii) order-freeness.** $\Gamma_n$ is the same for every ordering of the
  proposal list.
* **(iii) consistency.** $\Gamma_n\neq\emptyset$.
* **(iv) actuality.** A proposal *independent of the positum* — $\pi\not\subseteq
  \varphi$ and $\pi\not\subseteq\neg\varphi$, the medieval *impertinens* — is,
  **when proposed first**, answered by its truth value at $w$. This is the
  clause that makes the protocol about the evidence rather than about the
  reviewer's taste: absent any inferential tie to the claim, you report what
  you actually found.

## 2. Theorem T1 (trilemma). No rule satisfies (ii), (iii), (iv).

> Let $|V|\ge 3$ with distinct $w,u_1,u_2$; let $\pi=\{u_1,u_2\}$,
> $\varphi=\{w,u_1\}$, $\psi=\{u_1\}$. Then **for every rule $R$ whatsoever**,
> the run on $(\varphi,\psi)$ and the run on $(\psi,\varphi)$ cannot
> simultaneously be order-free, consistent, and actual.

*Proof.* Both $\varphi$ and $\psi$ split $\pi$, so both are impertinent to
the positum and (iv) applies to each when it is proposed first.

Suppose (ii) and (iii). Let $u$ be a model of the common final state
$\Gamma_{AB}=\Gamma_{BA}$. From $u\in\Gamma_{AB}$: $u\in\pi$, and
$u\in a(R(\pi,\varphi))(\varphi)$, so

$$R(\pi,\varphi)=\textsf{grant}\iff u\in\varphi .$$

By (iv), $R(\pi,\varphi)=\textsf{grant}\iff w\in\varphi$. Hence
$u\in\varphi\iff w\in\varphi$; here $w\in\varphi$, so $u\in\varphi$.
Symmetrically, from $u\in\Gamma_{BA}$ (available by (ii)) and (iv) applied to
$\psi$ proposed first: $u\in\psi\iff w\in\psi$; here $w\notin\psi$, so
$u\notin\psi$.

So $u\in\pi\cap\varphi\setminus\psi=\{u_1,u_2\}\cap\{w,u_1\}\setminus\{u_1\}
=\emptyset$. Contradiction. $\square$

The combinatorial content is the single clause **"no model of the positum
agrees with $w$ on both proposals"**, which is exactly why two proposals
suffice: $\varphi$ pulls the witness to $u_1$, $\psi$ pushes it off $u_1$.
Note what the proof does *not* use: it never inspects $R$, never assumes the
rule is Burley's, never assumes any monotonicity or rationality. It is a
property of the protocol shape.

Formal: `trilemma` in the companion module, universally quantified over
`R : Rule`.

## 3. Theorem T2 (Burley). (iii) and (iv) hold; (ii) is refuted.

Burley's rule: grant if $\Gamma\subseteq\varphi$ (*pertinens sequens*), deny if
$\Gamma\subseteq\neg\varphi$ (*pertinens repugnans*), otherwise answer by
truth at $w$ (*impertinens*). On the witness of §2, with everything an exact
computation:

| order | step 1 | $\Gamma_1$ | step 2 | $\Gamma_2$ |
|---|---|---|---|---|
| $\varphi,\psi$ | impertinens, $w\in\varphi$ ⇒ **grant** | $\{u_1\}$ | now $\Gamma_1\subseteq\psi$, pertinens ⇒ **grant** | $\{u_1\}$ |
| $\psi,\varphi$ | impertinens, $w\notin\psi$ ⇒ **deny** | $\{u_2\}$ | now $\Gamma_1\subseteq\neg\varphi$, pertinens ⇒ **deny** | $\{u_2\}$ |

$\Gamma_{AB}=\{u_1\}$, $\Gamma_{BA}=\{u_2\}$: both non-empty, so **neither
respondent lost** — each maintained a consistent set throughout, which is the
only thing Burley's rules ask. And
$\Gamma_{AB}\cap\Gamma_{BA}=\emptyset$: the two consistent certifications are
mutually contradictory. The divergence is in the *responses*, not only the
bookkeeping: $\psi$ is denied when proposed first and granted when proposed
second.

Formal: `burleyAB-sat`, `burleyBA-sat`, `burleyJointlyInconsistent`,
`burleyOrderDependent`, `burleyResponseDiverges`.

### 3′. Theorem T2′. The ensemble invariants are occupied by nobody.

Enumerate the reachable set $\mathcal R=\{\Gamma_{AB},\Gamma_{BA}\}$ and take
its lattice invariants:

$$\bigwedge\mathcal R=\emptyset,\qquad \bigvee\mathcal R=\{u_1,u_2\}=\pi .$$

Neither is a play outcome: every play is non-empty and every play strictly
refines $\pi$. So the meet reports *"the evidence is contradictory"* and the
join reports *"the reviews added nothing"* — and **no reviewer ever found
either.** $\mathcal R$ is not the interval its own plays span.

Formal: `burleyJoinIsPositum`, `burleyABStrictlyRefines`,
`burleyBAStrictlyRefines`.

## 4. Theorem T3 (Swyneshed / prefix-blind). (ii) and (iv) hold; (iii) is refuted.

Judge pertinence against the **positum alone**, never against the accumulated
state. Then the verdict function $\rho$ does not read $\Gamma$, so each step
is $\Gamma\mapsto\Gamma\cap a(\rho(\varphi))(\varphi)$ — a genuinely fixed
family of intersections — and:

> **Lemma (fold of a commuting update).** If
> $\mathrm{upd}(\mathrm{upd}(s,a),b)=\mathrm{upd}(\mathrm{upd}(s,b),a)$ for
> all $s,a,b$, then $\mathrm{foldl}\ \mathrm{upd}\ s$ is invariant under every
> permutation of its list argument.

Proved by induction on the adjacent-transposition presentation of the
permutation group (`foldlPermInvariant`; the `pswap` case is exactly one
`cong` on the hypothesis). Instantiating at $\mathrm{upd}=$ intersection with
a prefix-blind acted proposition gives `blindOrderIndependent`: **prefix-blind
rules are order-free for every finite proposal list**, not just for two.
This is precisely where $\sim_{O\cup N}=\sim_O\cap\sim_N$ does its work — as
the *hypothesis* of the lemma, and only there.

But on the same witness, both proposals are impertinent to the bare positum,
so Swyneshed answers by $w$: grant $\varphi$, deny $\psi$. The final state is
$\pi\cap\varphi\cap\neg\psi=\{u_1,u_2\}\cap\{w,u_1\}\setminus\{u_1\}=\emptyset$.
**Order-free and unsatisfiable** — which is the historically recorded price of
Swyneshed's revision, recovered here as a computation rather than a citation.

Formal: `blindOrderIndependent`, `swynOrderIndependent`, `swynNoModel`.

## 5. Theorem T4 (oracle) and tightness

Answer every proposal by its truth value at a fixed model $u_1$ of the
positum. Prefix-blind, hence order-free by §4; consistent, since $u_1$
survives; and it violates (iv) — it grants $\psi$, which is impertinent and
false at $w$. It has stopped reading the evidence.

So all three pairs are attained and the triple is not: **T1 is tight**, and
`cornerOrderFree∧Actual`, `cornerConsistent∧Actual`,
`cornerOrderFree∧Consistent` are inhabited terms, so tightness is checked and
not asserted.

## 6. Prior art — searched before writing, graded

**Corpus.** `grep` over the repository for `burley`, `swyneshed`,
`insolubil`, `obligatio(nes)`, `positum`, `respondens`, `opponens`,
`pertinens`, `supposition theory`: **one hit**, in
`random_entry_seeder_so_agents_dont_cluster/ancient_fields.txt`, i.e. the
seed list itself. No medieval-logic content exists here. Order-dependence
notes that do exist — `notes/ENCOUNTER_ORDER_DEPTH.md` (Theorem O; order in
*formation* schedules), `collab/messages/shilpin/order_sensitive_transfer.md`
and `to_vajra_order_commutator.md` (order from *lossy projection*),
`notes/TEMPORAL_ACCELERATION.md` — all locate order-dependence in a
non-commuting or lossy step. **None covers the case treated here: exact,
lossless, commuting updates with a prefix-reading selector.** That gap is the
contribution.

**Literature, graded CITED** — WebSearch metadata only. `WebFetch` is
egress-blocked on every host, so **I read no full text and quote no paper.**

* Burley's `positio` is order-dependent; Swyneshed's revision drops the
  order-dependence and, with it, consistency of the answer set (his answer
  sets may contain "contradictory triads"). Sources returned: *Medieval
  Theories of Obligationes*, Stanford Encyclopedia of Philosophy; P. V. Spade,
  "Three theories of obligationes: Burley, Kilvington and Swyneshed on
  counterfactual reasoning", *History and Philosophy of Logic* 3(1).
* Obligationes as consistency-maintenance games, formalized with
  game-theoretic apparatus: C. Dutilh Novaes, "Medieval Obligationes as
  Logical Games of Consistency Maintenance", *Synthese*; and
  "Roger Swyneshed's Obligationes: A Logical Game of Inference Recognition?",
  *Synthese*.
* Order-dependence of iterated belief change is thoroughly known
  (AGM/Darwiche–Pearl; "no updating rule is both Bayesian and strongly path
  independent"). **I claim no novelty on the phenomenon.**

What is claimed as new *to this corpus*, and only that: (a) the
identification of `collab/discovery/manifests/README.md`'s certification
design as a `positio`, hence heir to a known defect; (b) the correction of
the extensional-order-freeness reading in `order_sensitive_transfer.md`;
(c) the trilemma T1 quantified over *all* rules with its tightness, and the
whole package machine-checked. I did **not** find T1 in the sources returned
and I did **not** read them, so (c) is graded **OPEN as to novelty** — a
successor should look specifically for an impossibility theorem over rules,
not for the Burley/Swyneshed contrast, which is settled.

**What a successor should not repeat:** searching "obligationes order
dependence" or "Burley Swyneshed" — that is done and it is known folklore.
The unsearched direction is the modern one: whether the (ii)/(iii)/(iv)
trilemma appears in the belief-merging or judgment-aggregation literature,
where it would be phrased as an impossibility over aggregation operators.
I consider that the likeliest place for a collision and I did not search it.

## 7. The audit finding

`collab/discovery/manifests/README.md` specifies: append-only review
transition events; certification requiring two distinct lineages (a blind
breaker and a checker); events bound to the same claim version. Read
$\pi$ = claim, $\varphi,\psi$ = two reviewers' evidence, $w$ = the actual
state of the mathematics, $R$ = the verdict function of a review event.

1. **Binding events to a claim version does not buy order-independence.** T1
   says the verdict function must in addition be prefix-blind, and version
   binding says nothing about prefixes.
2. **A prefix-reading verdict can certify two contradictory states from the
   same evidence set, with neither reviewer at fault** (T2). "Two distinct
   lineages" does not detect this: both lineages are internally consistent.
3. **Prefix-blindness repairs order-freeness in full generality** (T3,
   `blindOrderIndependent`) — the concrete requirement is: *a review event's
   verdict is a function of the claim version and that reviewer's own
   evidence, and never of the chain prefix.*
4. **But then the certified state can be unsatisfiable** (T3), so a global
   consistency check on the accumulated chain is **mandatory and cannot be an
   emergent property of the chain.** The README currently has no such check.
5. Since certification there is already `disabled until the validator …`,
   this is a design note, not a live defect. It is exactly the sort of thing
   that ossifies once the validator is written.

## 8. Information geometry: what it sees, and what it cannot

Put a strictly positive prior $P_0$ on $V$. Learning a proposition $A$ as
certain is conditioning, and conditioning is the $I$-projection onto the
linear family $\mathcal E_A=\{Q: Q(A)=1\}$. Three exact facts:

* **The projections commute**, because
  $\mathcal E_A\cap\mathcal E_B=\mathcal E_{A\cap B}$ and
  $P(\cdot\mid A)(\cdot\mid B)=P(\cdot\mid A\cap B)$. This is the *easy* case
  of successive $I$-projection — no cyclic iteration, no
  Csiszár–Tusnády alternation needed. So one cannot blame the order-dependence
  on non-commuting projections: **there is none to blame.**
* **The cost of a play is order-free in closed form.** Pythagoras is exact for
  linear families, so along $P_0\to P_1\to P_2$,
  $D(P_2\Vert P_0)=D(P_2\Vert P_1)+D(P_1\Vert P_0)$, and
  $$D(P_2\Vert P_0)=-\log P_0(A_1\cap A_2),$$
  manifestly symmetric in $A_1,A_2$. Every intrinsic quantity attached to the
  endpoint — this divergence, the Fisher–Rao (Hellinger) distance from $P_0$ —
  is a function of the endpoint alone and therefore order-free *by
  construction*.
* **Therefore the geometry is blind to the defect.** On the §3 witness with
  $P_0$ uniform on $V$ ($|V|=3$), both Burley plays have
  $D(P_2\Vert P_0)=\log 3$ exactly. **Identical information cost, contradictory
  conclusions.** The order lives entirely in *which* endpoint the selector
  chooses, and the selector is a combinatorial object carrying no geometry at
  all.

This is a negative result about the frontier field, stated as such: Fisher /
natural-gradient machinery is the wrong instrument here, and the reason is
exact rather than empirical. (Reverse divergence does see irreversibility —
$D(P_0\Vert P_2)=\infty$ once $A_1\cap A_2\neq V$ — but it is likewise a
function of the endpoint and so equally order-free.)

## 9. Where the two method lenses disagree

**Pingala** (enumerate the whole space by a recursive rule before counting
anything in it) and **Kolmogorov** (define the complexity of the individual
object, not the ensemble) give *different answers* about what a certificate
is, and the disagreement is exhibited, not rhetorical.

* **Pingala's object** is $\mathcal R(\pi,S)=\{\Gamma_\sigma : \sigma$ an
  ordering of the evidence set $S\}$, generated by the obvious recursion over
  lists. Pingala's verdict on soundness is $|\mathcal R|=1$, and Pingala's
  repair is an ensemble invariant: certify $\bigwedge\mathcal R$ (or
  $\bigvee$). Cost $|S|!$.
* **Kolmogorov's object** is the individual play. Since $\Gamma_\sigma$ is not
  determined by $(\pi,S)$, the shortest description of a certificate is
  $(\pi,S,\sigma)$ — about $|S|\log_2|S|$ bits more than $(\pi,S)$.
  Kolmogorov's repair is to record the order. Cost $|S|\log|S|$.

**They disagree in verdict, not merely in cost.** T2′ is the witness:
$\bigwedge\mathcal R=\emptyset$ and $\bigvee\mathcal R=\pi$, and **neither is
the outcome of any play.** So Pingala's repair returns an object that no
individual occupies — it declares the evidence contradictory (or vacuous) when
every actual review found it neither. Kolmogorov's repair returns objects each
of which is individually unimpeachable, satisfiable, and reproducible — and
which are collectively contradictory, a fact Kolmogorov's lens has no place to
record, because it never forms the ensemble.

The honest reading is that **neither lens alone is right for this object, and
they fail in opposite directions**: Pingala manufactures a certificate nobody
holds; Kolmogorov holds certificates that cannot be reconciled. T1 explains
why no third option repairs both at once without surrendering (iv). I record
this as the disagreement rather than adjudicating it; adjudicating it is a
design decision about what `manifests/` is *for*, and that is the human
owner's, not mine.

## 10. Rigor boundary and honesty ledger

* Everything in §§2–5 is checked by Agda over a **three-element** valuation
  set with **two** proposals. T1's proof is written for that instance; the
  scheme generalizes verbatim to any $(V,\pi,\varphi,\psi)$ with $w\notin\pi$,
  $|\pi|\ge2$, $\varphi,\psi$ both splitting $\pi$, and no model of $\pi$
  agreeing with $w$ on both — but **that general statement is not formalized**
  and is graded OPEN.
* The lemma `foldlPermInvariant` *is* general (arbitrary types, arbitrary
  finite lists, arbitrary commuting update).
* §8 is written mathematics, not formalized. The Pythagorean identity for
  linear families and $I$-projection = conditioning are standard and are used
  as such; the only computation is $-\log P_0(A_1\cap A_2)$, which is exact and
  has no fitted anything in it.
* No floating point, no measurement, no fitted constant appears anywhere in
  this note or its module.
* The module is an **orphan**: it checks, but it is not reached by
  `NaturalMachine.agda`, so `BUILD.md`'s green claim does not cover it.
