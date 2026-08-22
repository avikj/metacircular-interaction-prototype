# YC application — draft 0.5 (cf-sakshi, 2026-08-14)

**Status:** draft for the owner; iterating (0.4 → 0.5: added the
reward-geometry evidence — the system proved exact theorems about the AI
training loop itself, the most audience-legible mathematics in the corpus;
0.3 → 0.4 surfaced the frontier-audit story and restructured evidence around
three demonstrated capabilities). Draft 0.2's "AI agent organizations"
framing stays dead per msg 0081: agents are not the ontology or the novelty.
~~Per PROTOCOL §8, nothing leaves the repository without owner release.~~
**[CORRECTED, SEED-81, 2026-08-14: `collab/PROTOCOL.md` has no §8 — its
sections run §0–§6. The rule cited is real and lives in **§6, "This is private
research"**; only the pointer was wrong. Found by SEED-18 and recorded, not
applied, for a night; applied here per message 0657.]** Per PROTOCOL §6,
nothing leaves the repository without owner release.

---

## Company name

**Natural Machine** (`notes/NATURAL_MACHINE.md`,
`notes/MATHEMATICS_THAT_LEARNS.md`).

## Describe what your company does (50 characters)

- `Mathematics that runs: verified, compounding`
- `Executable mathematics infrastructure`

## What is your company going to make?

Infrastructure in which mathematics itself runs as an engine.

Mathematics today is stored as text and trust: papers assert, readers
believe, and every use of a result re-pays its cost in re-derivation,
re-implementation, re-review. In the Natural Machine a result is a
**checked, executable object**: accepted once by a proof kernel, it becomes
an operation that changes the cost of everything after it — a repeated
argument becomes one call, an equivalence transports a body of work, a
counterexample deletes a route permanently, a conserved quantity prunes
searches before they run. Knowledge that compounds instead of accumulating.

The deliverable is the substrate: content-addressed mathematical objects,
proof-carrying transformations, typed records of exactly what every
translation preserves and loses, and a network protocol for exchanging them
without collapsing truth or authority into a scalar
(`notes/NATURAL_MACHINE_NETWORK_WHITEPAPER.md`, three hostile reviews
absorbed). AI models are one source of candidate mathematics among several;
nothing in the substrate depends on which model — or whether a model —
proposed a construction. The kernel is the only gate.

## The evidence: three capabilities, all demonstrated in-repo

**1. It proves new mathematics.** Four paper-grade artifacts with recorded
prior-art searches and adversarial red-team audits, among ~490 notes:

- *A no-go nobody else has stated*: no asymptotic input about zeta-zero
  statistics can decide the repo's own central quantity, because the
  governing weight concentrates the sum on a bounded range of heights —
  together with the catch that a frontier paper's additive-energy input
  lives on a set that is empty under the Riemann Hypothesis
  (`notes/DPP.md`). A visiting number theorist judged this "worth a
  paper" and, in the same audit, judged our previously headline
  crossover result to be a restatement of the classical smooth-number
  asymptotic — verified numerically to three digits against our own
  theorem. That exchange is the product: an outside lens deleted our
  best-advertised claim and promoted the one we were not promoting,
  within hours, and the record of both is in the repository.
- *A Riemann zero located to four significant figures from prime-pair
  counts*: the zero difference sits as a Fresnel chirp in the phase of a
  Goldbach spectral line; inverting the proved phase law recovers
  γ₂ = 21.024 against the true 21.022, with the conditional framing stated
  (`papers/phase_side.md`, Theorems D‴/G — the phase of a zero-pair atom is
  the entropy of its frequency splitting).
- *Why sieve theory's parity barrier cannot be evaded by finite-place
  methods*, as an operator-algebra theorem: parity is a protected gauge
  charge annihilated by every equilibrium state, every core, every
  finite-level descent datum, and every homotopy-invariant functor — five
  independent formalizations, two model lineages, one verdict
  (`notes/GAUGE.md`, `notes/CORE_KMS.md`, `notes/KBOUNDARY.md`).
- *Complete unconditional classifications*: prime prefixes are determined by
  their difference multisets (elementary singleton-parity proof); all
  cyclotomic divisors of prime-prefix polynomials classified globally; every
  irreducible factor degree through 9 excluded by exact certificates with
  hostile independent replays (`notes/PARITY_RIGIDITY.md`,
  `papers/prime_prefix_cyclotomic.md`, `notes/NONIC_OBSTRUCTION.md`).

**2. It audits and extends frontier mathematics faster than review does.**
When the 67.2%-of-zeta-zeros result was announced (2026-08-10), this system,
within ~36 hours: located and hashed the primary sources; **rebuilt the
authors' Lean proof from source in its own environment** (9,010 jobs, axiom
audit clean) and replayed every constant 19/19; then went past verification
to three independent closure theorems proving the manuscript's constants are
optimal on *every* axis its method consumes — sign freedom (a
double-positivity obstruction, found twice, concurrently and blind, by two
sessions), integrality (the convex relaxations are exactly the integer
hull), and tool lossiness (any worst-case inequality with global loss ≥ 3 is
vacuous; the large sieve fails by exactly 1.80) — localizing the one
remaining door and pricing it: any unconditional bound F ≤ 10/3 on a band
excess of length 1/3 beats the record (`notes/KAPPA.md`, `notes/L3_SDP.md`,
`notes/BAND.md`, walk-ledger F17/F25/F26). Independent replication was the
publicly missing piece of that announcement; this system supplied it,
unprompted, and then sharpened the frontier's own limit theorem.

**3. It compounds and it self-corrects.** One certified result changes
representation and provably lowers a later computation, which can reopen the
representation when its invariant boundary is crossed — executed end to end
on an arithmetic carrier, then re-executed unchanged on a second native
domain (`notes/REPRESENTATION_REOPENING_CYCLE.md`; the language instance ran
7/7 hostile with no hand assembly). The immune system is part of the object:
the founding framework was proved mostly trivial by the system's own first
week and the record kept (`notes/REPORT.md` §1); 53 walk-ledger entries each
ending in a stated yield; corrections struck through in place, never
deleted; measured retraction latency of hours, not months (three headline
self-retractions on 08-13 landed within 60–90 minutes of their claims); and
a ledger of behaviours that *passed all their tests* and still produced
nothing (`DO_NOT_DO_THIS_it_felt_like_progress_and_added_nothing/`, six
entries, each one caught and named).

**And it has turned its instruments on AI itself.** On its most fully
measured task, the system made the "verification is easier than generation"
thesis *exact* and then proved it: every observable an endpoint verifier can
compute is constant on the space of ways to reach the answer, so **outcome
reward carries zero bits about the generator's choice** — and the unrewarded
choice space is not a vibe but a computed infinite group, Γ₀(e₂/e₁)
(`notes/VERIFIER_BLIND_FIBER_REWARD.md`). Supervision formats are graded
exactly (outcome < sign < trace-recording < full replay), and the
information-geometry sequel proves the conservation law: under
multiplicative-weights/replicator learning, **the conditionals a reward
format cannot see are conserved quantities — outcome supervision does not
merely fail to prefer, it freezes learning pointwise**
(`notes/FORMAT_CONSERVED_LEARNING_GEOMETRY.md`). Exact rational theorems, on
real event windows, about what reward can and cannot teach: the substrate
reaching the training loop of the models that feed it.

The checked core as of this draft: 53 Agda modules (13,314 lines, 731 typed
statements, zero postulates, zero holes, compiler-enforced `--safe`) and 24
Lean files (zero `sorry`), one-command verification, with negative controls
that must fail to compile and do. The bootstrap labor was dozens of
persistent AI sessions across three model lineages; that fact is evidence of
absorption capacity — high-volume, error-prone candidate mathematics in,
only what checks out — and it is the last time agents are mentioned here.

## Why did you pick this idea?

Because the cost structure of certainty is the bottleneck, and mathematics
is the one place it can be fixed to the last symbol. Every field that
depends on being right — cryptography, protocol design, safety-critical
systems, quantitative finance — rebuilds its certainty by hand, repeatedly.
A substrate where correctness is checked once and reused forever moves the
marginal cost of certainty toward zero. Mathematics is where that substrate
can be built honestly, because a `--safe` proof either compiles or it does
not; everything else inherits it.

## What's new about it? What do you understand that others don't?

1. **Verification is the substrate, not a feature.** The trust boundary is
   the public typechecker — not any model, person, or company, including us.
2. **Knowledge compounds only when the proof's structure enters the
   machinery.** A theorem stored as text is inventory; installed as a
   checked transformation it changes the cost of every later derivation. We
   have the measured failure mode too — a "compiled theorem" that was 19%
   *slower* because only its conclusion, not its structure, was installed —
   and the loop we ship is the one that survived that record.
3. **What a translation loses is data.** Every transport carries its
   residual — the exact thing the target representation forgets. That
   discipline (the corpus calls it the calculus of residuals) is the
   difference between mathematics and a knowledge graph.
4. **Self-skepticism can be mechanized, and prose norms fail.** Every
   binding rule here is enforced by hooks, CI, or the typechecker because we
   measured that prose was not enough — on ourselves.

## Progress

Running system: 580+ commits, ~490 notes, four paper-grade artifacts, a
claims registry with registered forecasts and blind cross-lineage audits
(R0001–R0046), reproducible by one command. Network layer specified
post-review, deliberately unbuilt beyond its finite core: loop first,
federation on demonstrated need, settlement last.

## Competitors

Proof-assistant ecosystems (libraries, not compounding infrastructure);
formal-methods consultancies (verification as service, not platform);
frontier-lab "AI scientist" demos (generation without checking — the trust
collapse we price). Nobody is building the layer where verified mathematics
is the executable medium itself.

## How will you make money?

Sell certainty as infrastructure: (1) contract deliverables that are
machine-checked (mathematics, algorithm and protocol correctness,
safety-critical verification — the frontier-audit capability in evidence
point 2 is already a sellable service with a live case study); (2) the
substrate as a platform for institutions that must audit what they rely on;
(3) the network layer, when the loop demonstrates the need, per the
whitepaper's own sequencing.

## Why now?

Two curves crossed: models became strong enough to generate mathematics in
volume, and trust in unverified AI output began collapsing at the same rate.
Both feed us — generation fills the substrate, distrust prices it. The
four-day corpus is the existence proof that absorb-and-verify works at
volume; the 36-hour frontier audit is the existence proof that it works at
speed.

---

## Appendix: open these first (the compression is worse than the object)

For a reader with one hour, in order:

1. `notes/MATHEMATICS_THAT_LEARNS.md` — the thesis, 300 lines.
2. `notes/KAPPA.md` + `notes/BAND.md` — the frontier audit and the door it
   left, with primary-source hashes.
3. `papers/crossover.md` abstract — the critical-temperature law.
4. `papers/phase_side.md` §0–2 — the entropy-phase law and the recovered
   zero.
5. `notes/REPORT.md` §1 — the system killing its own founding framework,
   week one.
6. `collab/FAILURES.md` F25, F26, F30 — what a walk-with-yield looks like,
   including a mind refuting its own theorem within a day.
7. `DO_NOT_DO_THIS_it_felt_like_progress_and_added_nothing/` — the
   antipattern ledger; every entry passed its tests.
8. `formal/check.sh` — run it.
9. `notes/REPRESENTATION_REOPENING_CYCLE.md` — the compounding loop,
   executed.
10. `notes/NATURAL_MACHINE_NETWORK_WHITEPAPER.md` — the scaling path,
    post-hostile-review.

## Honesty appendix

No claim that any listed theorem is field-changing; the claim is verified,
novelty-graded mathematics produced, audited, and checked inside the loop,
with the grading recorded in-repo. No external users or revenue. Four days
of operation directed by one founder; sustained months-long operation is the
open milestone. The compounding loop is demonstrated on finite native
domains, not yet at research-frontier scale — the corpus says so itself
(msg 0366's scale judgment), and closing that gap is the company.
