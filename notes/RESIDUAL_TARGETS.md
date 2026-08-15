# Residual targets: where ϱ has something to bite on, and where it does not

**Scope.** A work queue for the cost-geometry cluster
(`formal/cubical/NaturalMachine/CostGeometry.agda`, `Residual.agda`,
`TransportDiv.agda`, `TransportDivWitness.agda`; `notes/COST_GEOMETRY.md`).
Written by reading `notes/FOREST.md`, `notes/LENS_CHAITIN.md`,
`notes/FIDELITY.md`, `notes/METHOD.md`, `TARGET.md`, and
`WHAT_IS_ACTUALLY_OPEN_across_the_whole_corpus_2026_08_14.md`, then asking
each major lane one question. No computation was run. This is a queue, not
a claim of results.

## 0. The admission test, stated once

`Residual.respond` needs three things before it returns anything but `★`:

1. **Two presentations of one task** — nodes, i.e. carriers *with the
   operation as implemented*, not two descriptions of one program;
2. **δ ≡ 0**: a bridge, `Edge A B × Edge B A`, checked;
3. **ϱ = wHere ⊖ detour ≠ 0**, with the weights honest.

The third is where this queue lives, and it is where the repository's
standing rule bites hardest. `CLAUDE.md`: a fitted constant is not a result.
A **stipulated** constant is not one either, unless the theorem is the
implication *from* the declared cost model — which is exactly the status
`COST_GEOMETRY.md` claims for W2 and should also have claimed for
`TransportDivWitness`.

> **Standing correction, applies to every target below.**
> `TransportDivWitness` discharges ϱ at a single point: word `1000`,
> `wHere = 1000`, `steps = 5`, chart edges 3 each, detour 14. That is one
> scale. `HOLOGRAM.md` §7 is the recorded price of exactly this mistake —
> a constant measured at one scale hid its own $X^{-1/2}$ scaling and moved
> a depth-law exponent from $T\log^2 T$ to $T^{1/2}\log^{3/2}T$. The
> derivable statement in `TransportDivWitness` is not `14 < 1000`; it is
>
> $$\varrho(N) \;=\; N \;-\; \bigl(2c_{\rm out} + c_{\rm back} + \lceil \log_b N\rceil\bigr),$$
>
> i.e. ϱ is $N - \Theta(\log N)$, and the branch is `↝` for all $N$ past an
> explicit threshold. **A residual reported without its parameter dependence
> is a benchmark, and `COST_GEOMETRY.md`'s own rigor boundary already says
> what a table of benchmarks is: a database.** Every entry below states ϱ as
> a function of a size parameter or admits it cannot.

---

## 1. Ranked targets

Ranking criteria, in order: (a) is the bridge already checked *in this
repository*; (b) is the cost gap derivable rather than measurable; (c) does
closing it move a problem someone has written down as open.

### R1 — the walk's divisibility test at frontier $m \ge 8$ · **PROVE**

*(a) checked · (b) derivable · (c) moves a stated open item)*

**Presentations.** One task: decide `q ∤ cap m`, `cap m = lcm(1..m)`.
*Home:* `WalkBridge.next`, a unary divisibility test on `cap m`.
*Chart:* `WalkFast.decIsPrimePower`, deciding prime-power-hood of an object
of size $q$.

**Bridge.** `NaturalMachine.WalkPrimePowers` + `WalkFast.next-characterised`:
the walk's installs are exactly the prime powers in increasing order, so the
two predicates cut out the same set. Checked Agda, `--cubical --safe`, no
postulates, no holes. **This is the only δ ≡ 0 in the corpus whose two sides
have a superexponential cost separation.**

**Cost gap.** Derivable, and derived: the unary test costs $\Theta(\mathrm{cap}\,m) = \Theta(e^{\psi(m)})$
(`WalkBridge` header, read off the definitions — "nothing here is measured");
the chart test costs $O(\sqrt q)$ trial divisions on an object of size $m$.
So $\varrho(m) = e^{\psi(m)} - O(\sqrt{m}\,)$ up to the round trip. PNT gives
$\psi(m)\sim m$: the gap is $e^{m(1+o(1))}$. This is a rate, not a number.

**Status of the payoff.** Unmade. `WalkFast`'s own header: *"the exchange
rate is proved, the exchange has not been made."* `next 8 ≡ 9`, built exactly
as the exchange rate prescribes with every ingredient individually cheap,
still exhausts a 3.5 GB heap. The named suspect is the `with`-abstraction on
`q ≟ next m` inside `next-characterised`.

**Falsifier.** Remove the `with`-abstraction (or otherwise block the
evaluator from forcing `cap m`) and rebuild `next-8`. **If it still blows the
heap, the residual is not in the arithmetic — it is in Agda's kernel**, and
the framework has mislocated it: `Cost` would then be a property of the
evaluator, not a field of the `Presentation`, and `Edge.cost` is measuring
the wrong object. That is a real refutation of `CostGeometry`'s central
modelling choice and it is one rebuild away.

**Why first.** It is the only target where all three criteria hold, and it
is the instance the residual cluster was built for. `TransportDiv`'s header
already says so; what it carries is the toy weight, not the frontier one.

---

### R2 — audit burden: meet-over-paths versus min cut · **PROVE / DEMONSTRATE**

*(a) proved on paper, formal fragment only · (b) derivable · (c) moves §3 of the 08-14 sweep)*

**Presentations.** One task: the minimum cost of re-auditing this corpus.
*Home:* `OBLIGATION.md` Cor. O2.4, a meet over all derivation paths — path-set
cardinality, exponential in the dependency DAG.
*Chart:* Theorem O3, the same quantity as a **min cut**, polynomial time, with
max-flow certifying a matching lower bound (Cor. O3.1).

**Bridge.** Theorems O1–O6 are proved in the note; the equivalence is
max-flow–min-cut, classical. Partial Agda:
`formal/cubical/ExtremalDescription.agda` §4 (min cut 1, least certificate 2).
The bridge has a **side condition that is exactly the `★` branch**: it holds
only if every edge mode is identity, constant, or clamp. `OBLIGATION.md`
carries this as a permanent obligation — a mode outside that class silently
degrades the cheap side from exact to conservative, i.e. δ ≢ 0 and the
detour computes a different object. That side condition is checkable, and
checking it is part of this target.

**Cost gap.** Derivable: $\varrho = |{\rm paths}| - O(|E|\cdot|V|)$ on the
actual DAG, both sides exact combinatorics on files sitting in the tree. No
floating point anywhere.

**Falsifier.** Run the extraction. If the use-mode classifier emits `UNKNOWN`
on enough edges that the min cut differs between the optimistic and
pessimistic completions, **the gap is in the input data, not between two
presentations**, and the residual framework has nothing to say — it prices
routes, not missing labels. `OBLIGATION.md` §11 item 4 already names this
risk; computing the cut under both completions is the discriminating
observation.

**Why second and not first.** The bridge is not checked here (one §4 fragment
is), and the object being audited is the corpus's own bookkeeping rather than
its mathematics. But criterion (c) is unusually strong: the 08-14 sweep calls
this "a stated, specified, exact computation that was never run," and §7's
absence is what leaves Cor. O2.4 with no number.

---

### R3 — $e_b(q)$: one quantity, two organs · **DEMONSTRATE**

*(a) bridge proved, one page · (b) derivable and exact, but $O(1)$ · (c) moves §1 of the 08-14 sweep)*

**Presentations.** One quantity, $e_b(q) = v_q\!\left(b^{\,{\rm ord}_q(b)}-1\right)$.
*Home:* `CYCLOTOMIC_SENSOR`'s head depth, formed in one organ.
*Chart:* the exact depth at which base $b$ goes blind to $q^a$
(`HEAD_DEPTH_BLINDNESS` Thm W3), formed independently in two others
(`certificate_anatomy`, `pinning`). Its $b=2,\;e\ge2$ case is the Wieferich
condition, which is `EXPOSED_SET`/`PINNING`'s residual open case.

**Bridge.** Theorem W3, proved, elementary, one page:
$b$ fails to refute $q^a$ by the Fermat test $\iff e_b(q) \ge a$.

**Cost gap.** Exactly derivable and exactly bounded:
$\varrho = \mathrm{cost}(e_b(q))$, once. The merged presentation forms the
quantity once and reads both consequences; the unmerged forms it twice. **This
is a shared subexpression, not a geometry.** By `CostGeometry` T2 a speedup
forces a *strictly better* neighbour, and here neither presentation is better
than the other — they are equal, and the saving is the duplication. Reported
honestly: ϱ is a constant factor, with no size parameter to scale in.

**Falsifier.** If forming $e_b(q)$ is cheap relative to everything else each
organ does, ϱ is a rounding error and this is a code-hygiene item wearing a
theorem's clothes. Price $\mathrm{ord}_q(b)$ against the surrounding sensor
work; if the ratio is $o(1)$, strike this from the residual queue and leave
it as the merge the sweep already calls for on mathematical grounds.

**Caveat on the queue tag.** The sweep calls this "the strongest item on the
list," but its strength is that a *machine* change and a *mathematical*
identity are the same act — not that ϱ is large. The live `PROVE` item in
that lane is the strong-test analogue (is the bound an equality, or is there
a correction term?), and `PINNING`'s hybrid sensor uses the strong mode, so
the sharp statement is the strong one. Under `CLAUDE.md`'s queue discipline
the `PROVE` item outranks this `DEMONSTRATE` one.

---

### R4 — the explicit formula, both directions · **SEARCH first**

*(a) not checked anywhere in `formal/` · (b) derivable · (c) moves nothing)*

**Presentations.** One task: $\psi(X)$, or any prime-counting functional.
*Home:* a sum over primes. *Chart:* a sum over zeros.

**Bridge.** The explicit formula. It is the corpus's most-used single tool —
D‴, G, E2, H, I1, I2 all ride on it (`METHOD.md` §2 dispatches half the
experiment triage with it) — and a grep of `formal/`, excluding vendored
Mathlib under `.lake/`, returns **no occurrence of it in any repo-authored
source.** So the bridge that carries the most weight in this repository is
the one bridge that has never been written as a term.

**Cost gap.** Derivable in both directions, and they land in different
branches:
- **`↝` (locations).** Zero-side evaluation with error $X/T$ beats sieving.
  Real, and **prior art kills it**: Lagarias–Odlyzko (1987) and
  Odlyzko–Schönhage are exactly this detour. The framework describes a known
  algorithm retrospectively; it does not find one.
- **`↻` (correlations).** `HOLOGRAM.md` Theorem K: correlation-grade
  information about the zeros costs $X \sim \exp(cT\log^2 T)$ against
  $X\sim\mathrm{poly}(T)$ for locations. Here ϱ is *negative* and derivably
  so. `Residual.respond` returns `↻` and `↻-is-flat` gives `NoSpeedup`. That
  is the correct answer and it carries no programme.

**Falsifier / disposition.** None needed — this entry exists to stop the
candidate being re-proposed. **Do the `SEARCH` before anything else here**;
`CLAUDE.md` requires prior art before the experiment, and three results in
this corpus were rediscoveries found only at audit time. The one thing worth
doing is formalizing the bridge itself, and that is a `PROVE` item in the
analytic lane, not a residual item.

---

### R5 — coarsest lens repair: enumeration versus a refinement fixpoint · **PROVE**

*(a) δ ≡ 0 free, but the second presentation does not exist · (b) conditional · (c) the item two authors say they most want)*

**Presentations.** Given partitions $\pi,\sigma$ of a finite set, find the
coarsest $\rho \succeq \pi$ commuting with $\sigma$.
*Home:* exhaustive enumeration over the partition lattice, $\mathrm{Bell}(n)$.
*Chart:* a partition-refinement fixpoint — **conjectural; nobody has built one.**

**Bridge.** Free, and this is the unusual feature: `LENS_REPAIR` proves the
coarsest repair is *unique* (the commutant is join-closed), so any two correct
procedures compute the same object and δ ≡ 0 holds without a translation being
exhibited. Uniqueness is the bridge.

**Cost gap.** $\mathrm{Bell}(n)$ against polynomial — but only if the chart
exists. Local search provably stalls (the merge graph is not connected), so
the obvious construction is dead.

**What the framework actually says here, and it is a limitation.** `Γ↝` is
min-plus over a *list* of neighbours, and `Γ↝-never-worse` on the empty list
returns `wHere`. The whole difficulty is **constructing** the neighbour, and
min-plus cannot construct one. `T2` says a speedup forces a strictly better
presentation to exist; it does not produce it. So the residual framework
reduces this problem to itself.

**Falsifier.** A hardness reduction. If computing the coarsest repair is
NP-hard, then (modulo P ≠ NP) no cheap neighbour exists, `Γ↝` is `↻` for
every neighbour list, and the framework's verdict is correct and empty. **That
is the discriminating observation and nobody has attempted it.** It is
self-contained combinatorics needing no corpus context, which the 08-14 sweep
already flags as the most delegable item in the repository.

---

### R6 — definitional rigidity as a proof-length residual · **PROVE**

*(a) proved on paper, not formalized · (b) not derivable as things stand · (c) unclear)*

**Presentations.** One object: the meaning of a `riemannZeta`-class symbol.
*Home:* the full analytic definition (continuation, functional equation).
*Chart:* `DEFINITIONAL_RIGIDITY.md` Theorem R's web of **size 2** —
complete multiplicativity plus $D_a(2) = \pi^2/6$ — which pins $a \equiv 1$
with no functional equation and no analytic continuation at all.

**Bridge.** Theorem R, proved (extremality of an absolutely convergent Euler
product at $|a(p)|\le1$). Note the audit history: R0018's original statement
was **refuted as written** (the $a(0)=0$, $a(n)=1$ counterexample); the
corrected positive-integer theorem lives in `EXPOSED_POINT_RIGIDITY`/R0019.
Any residual claim must be against the corrected statement.

**Cost currency.** `CostGeometry` licenses this explicitly — only `+`, `≤`,
`<` are used, so every theorem holds for proof length as readily as for
steps.

**Cost gap: not derivable, and that is the honest verdict.** Nobody has priced
a single downstream theorem via the web against via the definition. Until one
is priced, ϱ is unknown in sign, and `T1` is the live risk: if deriving
anything from the web requires reconstructing the definition first, the far
presentation is *not* better at the work and no detour wins, whatever the
translation costs.

**Falsifier.** Take one theorem that currently consumes `riemannZeta`'s full
definition. Derive it from $W_R$ alone. If the derivation must first recover
continuation or the functional equation, the detour cost exceeds the direct
cost, T1 applies, and **the rigidity programme is a fidelity result with no
cost content** — which would be a perfectly good outcome for FIDELITY and a
null result for this queue. `RUNTIME.md` §4 item 5 states the general form of
this test: until some real result makes another real result cheaper, the loop
is demonstrated and not applied.

---

## 2. Where this framework does NOT apply

Stated plainly, because the failure mode this cluster invites is treating
every hard thing as a slow thing.

**A parity obstruction is not a slow algorithm.** `ParitySeparator.agda`
proves `obs-agree`: an observer with parity-neutral queries produces *the same
list of answers* on $\sigma$ and on its gauge flip $\sigma'$ — an equality of
lists, not an estimate — and `no-decision` follows by `cong`. There is no work
to relocate because there is no information to relocate. `Residual.ϱ` prices
routes; here every route of every length returns the same value. `GAUGE.md`
Theorem F is the same statement upstream: the unique KMS state annihilates
every charged observable, so sieve blindness is an exact invariance, not a
want of technique. **Adding compute changes nothing, at any cost, in any
currency.** `ChargeCriterion.agda` is the sharp form: separating power is a
function of the *charge* of the query, not of its size — which is precisely a
statement that cost is the wrong coordinate.

**Theorem K is a cost statement in the dead branch.** `HOLOGRAM.md`'s depth
law is genuinely about cost, and the framework handles it correctly by
returning `↻`. That is a certificate that a route is dead, not a research
programme. Do not mine `↻` entries for work.

**The Selberg pair is semantic, not computational.** `LENS_CHAITIN.md`
Lemma C1: two states in one exact axiom fiber bound any fiber-valid
conclusion by the *worse* endpoint, and (1.2) makes that bound zero for the
prime target. δ ≡ 0 holds by construction and ϱ is not merely zero — it is
undefined, because $\min(T(\nu_+),T(\nu_-))$ does not move with effort. The
note's own §5 warns against reading proof-time lower bounds off a parity
label; the same warning covers reading a cost gap off one.

**Chowla / `FOREST.md` §3 has no bridge, and its absence is the theorem.**
The shift does not preserve $\mathcal M$, and $ST_m = T_m S^m$ is exactly the
statement that the two actions do not jointly diagonalize. `Γ↝` needs edges;
here the mathematics is that the edge is not there. Manufacturing one would
be manufacturing the conjecture.

**The κ = 2/3 lane is an inequality, not an equivalence.** The finite Gabor
compression of Weil's Hermitian form is *lossy by design* — that is what makes
the argument unconditional. δ ≢ 0, so `respond` returns `★` and the four
equivalence-side responses apply, not ϱ. `BAND.md`'s exchange rate
$V^*(B) = (2B-1)/(3B-2)$ prices an **unknown analytic constant**, not a route
through a second presentation; reading it as a cost geometry misdescribes it.

**Siegel zeros (`WIDTH.md` §3) have no second presentation at all.** A power
saving at one real character of one modulus is a missing theorem. There is
nothing to detour through. The 08-14 sweep records this as the one item
*correctly* parked; it should be cited against proposals, not worked.

**Homometry is the mirror configuration and must not be confused with a
residual.** `FIDELITY.md`'s failure catalog — thin webs admitting two meanings
— is *two objects, one shadow*: the observations agree and the objects differ.
A residual needs *one object, two presentations*: the objects agree and the
costs differ. `SieveFiber.agda` sits on the homometry side (the fiber of the
quotient map, the residual bit $\varepsilon_X$ removed). Reading a homometric
pair as a bridge is the standing error this section exists to prevent.

---

## 3. What would falsify the cluster as a whole

One observation, and R1 supplies it: **if `next 8` still fails after the
`with`-abstraction is removed, `Cost` is a property of the evaluator rather
than a field of the presentation**, and `Edge`'s two-field design — the
formal content of `TransportCost`'s lesson — is measuring the wrong object.

Short of that, the weaker and more likely outcome is the one
`COST_GEOMETRY.md` names itself: if no known fast algorithm ever appears as
the cheap route *without being told to*, the graph is a table of measurements.
Every entry above is written so that its ϱ carries a size parameter, because
a table of measurements is what a queue of single-point weights becomes.
