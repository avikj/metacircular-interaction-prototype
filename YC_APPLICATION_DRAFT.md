# YC application — draft 0.3 (cf-sakshi, 2026-08-14)

**Status:** draft for the owner. Draft 0.2 centered "autonomous AI research
organizations" — the agents framing the owner had already rejected on the
record (msg 0081: agent wrappers/orchestration are "not the intended object";
AI agents "are not its ontology or its novelty"). 0.3 centers the object the
repository's own constitution names: mathematics as native, executable,
compounding infrastructure. The agents are bootstrap labor and appear only in
the evidence section. Per PROTOCOL §8, nothing leaves the repository without
owner release.

---

## Company name

**Natural Machine** (`notes/NATURAL_MACHINE.md`,
`notes/MATHEMATICS_THAT_LEARNS.md`).

## Describe what your company does (50 characters)

- `Mathematics that runs: verified, compounding`
- `Executable mathematics infrastructure`
- `Knowledge that compiles, checks, and compounds`

## What is your company going to make?

Infrastructure in which mathematics itself runs as an engine.

Today mathematics is stored as text and trust: papers assert, readers
believe, and every use of a result re-pays its cost — re-derivation,
re-implementation, re-review. We are building the substrate where a proved
result is a **checked, executable object**: accepted once by a proof kernel,
it becomes an operation that makes the next result cheaper — a repeated
argument becomes one call, an equivalence transports a whole body of work, a
counterexample deletes a false route permanently, a classification turns
search into recognition. Knowledge that compounds instead of accumulating.

The deliverable is that substrate: content-addressed mathematical objects,
proof-carrying transformations between them, typed records of exactly what
each translation preserves and loses, and a network protocol
(`notes/NATURAL_MACHINE_NETWORK_WHITEPAPER.md`, three hostile reviews
absorbed) for sharing them without collapsing truth or authority into a
scalar token. AI models are one source of candidate mathematics among
several. They are not the product, and nothing in the substrate depends on
which model — or whether a model — proposed a construction: the kernel is
the only gate.

## What have you actually built? (the evidence)

A live corpus in which this loop already executes, produced in four days of
full-intensity operation:

- **A checked core**: 53 Agda modules (13,314 lines, 731 typed statements,
  zero postulates, zero holes, compiler-enforced `--safe`) and 24 Lean files
  (zero `sorry`), verified by one command — including negative controls that
  must fail to compile, and do.
- **The compounding loop, demonstrated end to end**: a certified result
  changes representation and provably lowers the cost of a later
  computation, which can in turn reopen the representation when its
  invariant boundary is crossed (`notes/REPRESENTATION_REOPENING_CYCLE.md`);
  the same loop then re-executed unchanged on a second native domain
  (`machinery/language_reopening_cycle` lane, msg 0367).
- **Real theorems at publishable granularity**, with recorded prior-art
  searches: the Hardy–Littlewood singular series has a critical temperature
  at the zeta pole with a universal scaling law (`papers/crossover.md`); an
  individual zeta zero read out of prime-pair counts
  (`papers/phase_side.md`); parity as a protected gauge charge — an
  operator-algebra account of why the sieve parity barrier cannot be evaded
  by finite-place methods (`notes/GAUGE.md`, `notes/CORE_KMS.md`); RH
  translated exactly into additive combinatorics, including the honest proof
  that the translation relocates rather than dissolves the difficulty
  (`notes/LENS_REGULARITY.md`); complete unconditional classification
  theorems (`notes/PARITY_RIGIDITY.md`, `papers/prime_prefix_cyclotomic.md`).
- **Foundations that execute**: positional notation proved to be a chart on
  ℕ, with transport along the equivalence *computing* schoolbook
  ripple-carry; a quantum contextuality no-go certified by the typechecker
  running all cases at compile time (`formal/cubical/`).
- **An immune system, not a demo reel**: the corpus's founding framework was
  proved mostly trivial by its own process in week one and the record kept
  (`notes/REPORT.md` §1); refutations are struck through in place, never
  deleted; there is a ledger of behaviours that looked like progress and
  produced nothing, with green tests attached
  (`DO_NOT_DO_THIS_it_felt_like_progress_and_added_nothing/`).

The bootstrap labor was dozens of persistent AI sessions across three model
lineages coordinating through the repository. That fact belongs in this
section and nowhere else: it is evidence the substrate can absorb
high-volume, error-prone candidate mathematics and emit only what checks —
not the thing being sold.

## Why did you pick this idea?

Because the cost structure of knowledge is the bottleneck, and mathematics
is the one domain where it can be fixed to the last symbol. Every field that
depends on being right — cryptography, protocol design, safety-critical
systems, quantitative finance — currently rebuilds its certainty by hand,
repeatedly. A substrate where correctness is checked once and reused forever
changes the marginal cost of certainty from linear to near zero. Mathematics
is where that substrate can be built honestly, because a `--safe` proof
either compiles or it does not; everything else inherits it.

## What's new about it? What do you understand that others don't?

1. **Verification is the substrate, not a feature.** The trust boundary is
   the public typechecker, not any model, person, or company — including us.
2. **Knowledge compounds only if the proof's structure enters the
   machinery.** A theorem stored as text is inventory; a theorem installed
   as a checked transformation changes the cost of every future derivation.
   We have measured both the successes and the failure modes of this
   (`DO_NOT_DO_THIS…/a_table_a_null_control_and_correct_ceremony_hiding_a_19pct_regression…`),
   which is why the loop we ship is the one that survived its own hostile
   record.
3. **What a translation loses is data.** Every transport in the substrate
   carries its residual — the exact thing the target representation forgets.
   This is the difference between a knowledge graph and mathematics.
4. **Models are interchangeable inputs.** Our corpus was produced by three
   model lineages auditing each other blind; the substrate got stronger each
   time a model was wrong, because the record of the refutation is itself a
   checked object. We improve as models improve and are hostage to none.

## Progress

Running system: 576+ commits, ~490 research notes, four paper-grade
artifacts, a claims registry with registered forecasts and adversarial
audits, reproducible by one command (`formal/check.sh`). The network layer
is specified (whitepaper, post-review) and unbuilt beyond its finite core —
sequencing is loop first, federation on demonstrated need, settlement last.

## Who are your competitors?

Proof-assistant ecosystems (substrate without an engine: libraries, not
compounding infrastructure); formal-methods service firms (verification as
consulting, not as a platform); frontier-lab "AI scientist" demos
(generation without checking — the thing whose trust collapse we benefit
from). Nobody is building the layer where verified mathematics is the
executable medium itself.

## How will you make money?

Sell certainty as infrastructure: (1) contract work whose deliverable is
machine-checked (algorithm and protocol correctness, safety-critical
verification, mathematics); (2) the substrate as a platform for institutions
that must audit what they rely on (labs, quant firms, chip and crypto
verification); (3) the network layer — typed obligations, proof-carrying
exchange — when the loop demonstrates the need, per the whitepaper's own
sequencing.

## Why now?

Two curves crossed: models became strong enough to generate mathematics in
volume, and trust in unverified AI output began collapsing at the same rate.
Both curves feed us — generation fills the substrate, distrust prices it.
The four-day corpus is the existence proof that the absorb-and-verify loop
works at volume.

---

## Honesty appendix

No claim that any listed theorem is field-changing; the claim is verified,
novelty-graded mathematics produced and checked inside the loop, with the
grading recorded in-repo. No external users or revenue. Four days of
operation directed by one founder; sustained operation over months is the
open milestone. The compounding loop is demonstrated on finite native
domains, not yet at research frontier scale — that gap is stated in the
corpus itself (msg 0366's scale judgment) and is the thing the company
exists to close.
