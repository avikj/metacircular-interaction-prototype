# The machine: an optimal architecture for executing mathematics

*Design document. Written from inside a natural experiment — this repository
executed ~40 turns of mathematics across four agent branches, and its cost
structure is now measurable to the token. Everything below is calibrated on
that data rather than on intuition about how research "should" go.*

---

## 1. "Optimal", defined precisely

### 1.1 The state space

A **knowledge state** $S=(\mathcal K,\prec,\tau)$ is a finite set of
statements $\mathcal K$, a dependency partial order $\prec$, and a **type
map** $\tau:\mathcal K\to\mathsf{Types}$ with
$$\mathsf{Types}=\{\textsf{proved},\ \textsf{certified},\ \textsf{cited},\
\textsf{conjectured},\ \textsf{measured},\ \textsf{refuted}\}.$$
The distinction between `proved` (a derivation exists and has been
adversarially verified), `certified` (an exact symbolic computation produced
a proof object — an irreducibility certificate, a resultant, an exhaustive
finite check), and `measured` (a floating-point number with no derivation)
is **load-bearing and mechanically enforced**; §5 shows that every error this
repository produced came from a type confusion between the last two.

A **goal** $G$ is a statement together with a required type (usually
`proved`).

### 1.2 The metric

A **move** $m$ transforms $S\to S'$ at cost $c(m)$ measured in the only
currency that is actually scarce: **tokens across all agents, including
every downstream token the move causes**. That last clause is what makes the
metric honest — a move that introduces a wrong node costs its own production
*plus* the audit that catches it, *plus* the retraction, *plus* the
correction propagated to every dependent node.

$$c_{\text{true}}(m)\;=\;c_{\text{prod}}(m)\;+\;\Pr[\text{wrong}]\cdot
\bigl(c_{\text{audit}}+c_{\text{retract}}+c_{\text{propagate}}\bigr).$$

### 1.3 Geodesic

$d(S,G)=\min_{\text{paths}}\sum_i c_{\text{true}}(m_i)$, and the **geodesic**
is the minimizing path. Two immediate observations, both essential:

- **$d$ is uncomputable in the strong sense**: knowing $d(S,G)$ essentially
  requires knowing the proof. So no machine executes the true geodesic; a
  machine executes $A^\ast$ search under a heuristic $h\approx d$, and *the
  entire quality of the machine is the quality of $h$*.
- **Geodesy is not a property of results, it is a property of routes.** Two
  routes can reach the identical statement at costs differing by $10^2$–$10^3$
  (§2). Optimality is therefore about route selection, not about output.

### 1.4 The heuristic that this corpus actually validates

$$h(S)\;=\;\min_{\text{technique }t\ \in\ \mathcal T}\
\bigl[\text{len}(t\text{-derivation})\ /\ \text{conf}(t\ \text{applies})\bigr]$$
over a **technique library** $\mathcal T$. For this domain the library that
covered *every* structural law produced here is small:

> Stirling/saddle point · explicit formula · stationary phase (WKB) ·
> Mellin–Laplace transform · integral-domain / unique-factorization argument
> · standard asymptotics (Mertens, Hardy's Ramanujan expansion) · Tauberian
> transfer · superresolution/sampling theory.

Eight techniques. Theorems D‴, D‴-$k$, G, E2, H, H′, I1, I2, M1, Lemma N and
K′ are all one or two library hits. **The correct primitive move is
technique-matching, not experimentation.**

---

## 2. The natural experiment: measured cost ratios

Four cases where this repository took both routes and the costs are known:

| statement | measurement route | derivation route | ratio |
|---|---|---|---|
| running law of block constants (`M1`) | exp27 script + run + write-up + cross-review round + retraction + 3-file correction | 6-line Mertens computation | $\gtrsim10^2$ |
| entropy phase law + coherence + $k$-body ladder | exp12 + exp17 + exp22 + exp30 (4 experiments, ~600 lines, 4 write-ups) | one stationary-phase computation (`I2`) | $\sim10^2$ |
| arithmetic noise floor (`Lemma N`) | exp6b + exp41 threshold, propagated into `K` | one explicit-formula line | $\gtrsim10^2$ |
| block spectral support (`E2`) | exp11 + figures + audit | two lines of explicit formula | $\sim10^2$ |

**Score: 2 of ~30 experiments were on-geodesic** (both were `certified`
symbolic, i.e. proof objects, not measurements). Three measurements put
*wrong numbers* into the record.

### 2.1 Why measurement is off-geodesic — the structural argument

The cost ratio is not the deep point; this is:

> **A measurement of a derivable quantity has no error-detection mechanism.**

When you derive, the derivation checks itself: a wrong step usually fails to
typecheck against the technique's hypotheses. When you fit, a wrong answer
looks exactly like a right one. $0.362$ and the true $\tfrac14$ are
indistinguishable *within the measurement route* — the discrepancy is only
visible from the derivation you skipped. Hence $\Pr[\text{wrong}]$ is high
**and** undetectable-in-route, which is precisely the term that dominates
$c_{\text{true}}$.

Worse, and this is the subtlest lesson: **a constant measured at one scale
hides its scaling.** The floor $\varepsilon\approx10^{-3}$ was correct at
$X=10^7$ and useless as knowledge, because the content was
$\varepsilon=X^{-1/2}$ — and substituting the derived form changed a headline
exponent from $T\log^2T$ to $T^{1/2}\log^{3/2}T$. A number without its
parameter-dependence is worse than no number: it looks like knowledge and
silently freezes a variable.

---

## 3. Architecture

### 3.1 Core: $A^\ast$ over a typed proof DAG

The machine maintains the DAG, not a linear transcript. Each node carries
`{statement, type, derivation-or-gap, verifier-signature, prior-art-status,
cost-spent, dependents}`. The main loop:

1. **Frontier scoring.** For each open node, run technique-matching against
   $\mathcal T$; score by $\Delta h/\text{cost}$.
2. **Fan-out.** Dispatch the top $W$ nodes to worker subagents concurrently.
   Each returns *one of*: a derivation, a reduction to new subgoals, or
   `no-technique-matched`.
3. **Gate.** Nothing enters the DAG as `proved` without passing §3.2.
4. **Repeat**, re-scoring the frontier (a returned reduction changes $h$
   everywhere downstream).

### 3.2 The three mandatory gates

These are not review steps; they are **type constructors**. A node cannot
acquire a type without them.

- **Adversarial verify** (`→ proved`). An independent agent that is shown the
  *statement only*, never the candidate derivation, and is instructed to
  re-derive or refute. Anchoring is the failure mode; withholding the
  derivation is the fix. Empirically this is the single highest-value
  subagent role in this repository: the audit branch caught three real
  errors, including one ($c_2$) that had already been published in a commit
  message, a note, and a paper section.
- **Prior-art gate** (`→ cited` or clears novelty). Runs **concurrently with**
  the proof attempt, not after — it is independent work, so serializing it is
  pure critical-path waste. This repository found three rediscoveries only at
  audit time (Theorems H/H′ ⊂ Cantarini–Gambini–Zaccagnini; the twisted
  identity ⊂ Bhowmik–Halupczok–Matsumoto–Suzuki; K0 ⊂ superresolution
  theory), all of which a parallel search would have caught before the work.
- **Type-propagation check.** If any ancestor is `measured` or
  `conjectured`, the descendant inherits a visible unproved-input edge. The
  $c_2$ and $0.362$ incidents are exactly failures of this check: a
  `measured` value was cited as if `proved` and propagated silently.

### 3.3 Computation as a typed side-channel

Computation is *not* a move in the search; it is an oracle with two ports:

- **certified port** — input: a decidable finite question; output: a **proof
  object** (certificate, resultant, exhaustive enumeration). Always allowed;
  this is proof by other means.
- **exploratory port** — output: a number. Its result may enter the DAG
  **only** as type `conjectured`, may never be cited in a derivation, and its
  emission automatically creates a `PROVE` node ("derive this quantity, with
  its parameter dependence"). This makes the Lemma N failure mode
  structurally impossible: no measured constant can persist without an open
  obligation to derive it.

### 3.4 Subagent roles (the minimal sufficient set)

`prover` (technique-matched derivation) · `verifier` (adversarial,
statement-only) · `librarian` (prior art, concurrent) · `reducer`
(decompose a goal into subgoals; the only role allowed to *grow* the DAG's
frontier) · `certifier` (exact symbolic computation) · `curator` (detects
duplicate nodes, merges homotopic routes, retires abandoned lines).

The `curator` is the role this repository never had, and its absence is
visible: the corpus **accreted** — nothing was ever abandoned or merged, so
the DAG became 73 notes with duplicate numbering across branches and a
three-way merge plan needed at the end.

---

## 4. Throughput

With $W$ workers, wall-clock $\approx\max\bigl(\text{critical path},\
\text{total work}/W\bigr)$, so the design targets are: shorten the critical
path, and push everything else off it.

**This session, re-planned.** Its actual mathematical content is 12 nodes,
of which the longest dependent chain is 5:
$$\text{D}‴\ \to\ \text{I2}\ \to\ \text{G}\ \to\ \text{K0/K}\ \to\ \text{Lemma N}\to \text{K}'$$
Everything else — I1, H, H′, E2, M1, the family classification, the barrier
taxonomy — is **independent** and parallelizes completely. At $W=4$ the
session is $\approx5$ sequential rounds instead of $\approx40$ turns, at
roughly $10^{-2}$ of the tokens.

Three throughput rules follow:

1. **Parallelize verification, never derivation.** Derivations on a chain are
   inherently serial; verification, prior art, and independent lemmas are
   embarrassingly parallel. Spend $W$ there.
2. **Fan out on *approaches*, not on *parameters*.** The judge-panel pattern
   (N independent attacks, keep the best, graft the runners-up) is on-geodesic;
   sweeping a parameter grid is the measurement anti-pattern wearing a
   parallel hat.
3. **Bound accretion.** Every fan-out must terminate in a merge by the
   `curator`, or throughput gains are consumed by later reconciliation — as
   they were here.

---

## 5. The transfer: this corpus's own mathematics, as search policy

The most valuable design input is the barrier program itself. Its content,
stripped of number theory:

> **Barriers are relative to a probe class. Within a class, resolving finer
> structure costs exponentially; across classes, the same information may be
> cheap.**

Three probe classes were identified here (finite-multiplicative /
additive-windowed / global-multiplicative), and the one conjecture that ever
yielded (logarithmic Chowla) yielded to the class the others never touch.
As a search policy this says:

- **Detect barrier regimes.** When marginal cost per unit progress starts
  growing super-linearly along a line of attack, the machine is inside a
  barrier for its current presentation. The correct response is **not** more
  compute.
- **Switch presentation, don't increase resolution.** Change the interface
  through which the object is accessed — different transform, different
  category, different invariant — because the exponential cost is a property
  of the access mode, not of the truth.
- **Corollary for the heuristic $h$:** $h$ must be *presentation-indexed*.
  A statement's distance is not a single number; it is a vector over probe
  classes, and the geodesic routinely changes class mid-path.

This is also why the machine must never treat "more precision" as progress:
by Theorem K′, precision buys resolution only as $\varepsilon^{1/(2p-1)}$
against demands that grow super-exponentially in cluster size. The
arithmetic instance is a theorem; the design lesson is a policy.

---

## 6. What remains genuinely hard

Honesty about the parts the architecture does not solve:

1. **The heuristic $h$ is the whole problem.** Technique-matching handles the
   one-or-two-hit statements — which, empirically, is *most* of what a
   research session produces, but by construction not the interesting
   residue. For the D″ off-diagonal bound (the one hard item in this repo),
   no library hit exists and $h$ is uninformative.
2. **Knowing when to abandon.** No principled stopping rule; the `curator`
   currently needs a human-grade taste judgment.
3. **Exploration.** Pure $A^\ast$ under a technique-match heuristic can only
   find what the library reaches. Genuine discovery requires wide,
   low-prior fan-out — the one legitimate role for exploration, and the
   thing the strict proof-only protocol must be careful not to strangle.
   Current compromise: exploration is licensed, but its outputs are typed
   `conjectured` and carry mandatory derive-obligations.
4. **Cost estimation before the fact.** $\Pr[\text{wrong}]$ is estimated from
   this one session; it is not calibrated across domains.

---

## 7. Minimal specification (what to build first)

If only one component is built, build the **typed DAG with the three gates**.
It is cheap, it is mechanical, and it would have prevented every error this
repository produced. The $A^\ast$ scheduler and the subagent fleet are
throughput multipliers on top; the type discipline is the thing that makes
the multiplied output *correct*.

Order: typed DAG + gates → curator → concurrent librarian → technique-matched
prover → $A^\ast$ frontier scoring → judge-panel exploration.
