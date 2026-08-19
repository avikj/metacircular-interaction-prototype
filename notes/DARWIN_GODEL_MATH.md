# Darwin Gödel Machine pilot study (optional search-policy prior art)

**Status: quarantined experimental design, not canonical architecture.**  The
current system is described by `RESEARCH_SYSTEM.md`.  This note remains as a
source audit and possible future controlled experiment; its evolutionary and
biological language is not used to explain the operating research system.

`machinery/evolution/` supplies only an inert exact-record validator; no
sandbox, mutator, evaluator, parent selector, or controller is implemented.
The design below studies one useful idea from the Darwin Gödel Machine
(DGM)—an archive of branching, empirically evaluated agent scaffolds—to this
repository.  It does **not** import DGM's benchmark claims as evidence about
mathematical discovery, and it does not authorize publishing or exporting any
repository material.

## 1. What the DGM result does and does not establish

Zhang, Hu, Lu, Lange, and Clune's
[Darwin Gödel Machine paper](https://arxiv.org/abs/2505.22954) starts with one
coding-agent scaffold.  A foundation model diagnoses a selected parent's
benchmark failures, the selected agent edits its own code, and the resulting
child is evaluated.  Functioning children enter a growing archive.  Parents
are sampled with weight

\[
  w_i=
  \frac{1}{1+\exp[-10(\alpha_i-0.5)]}\,
  \frac{1}{1+n_i},
\]

where \(\alpha_i\) is benchmark accuracy and \(n_i\) is the number of
functioning children.  Thus a high-scoring but underexplored node is favored,
while every eligible node has nonzero probability.  The reported runs improved
performance from 20.0% to 50.0% on the designated 200-task SWE-bench Verified
evaluation and from 14.2% to 30.7% on full Polyglot.  The reported one-run
subset baselines and ablations did worse.  These are substantial empirical
results
for evolving coding-agent tools and workflows.

This is not the original Gödel-machine guarantee.  A theoretical Gödel machine
adopts a rewrite only after proving that the rewrite increases expected utility
under its formal axioms.  DGM instead estimates a rewrite's usefulness on a
finite, noisy benchmark.  Consequently:

- a measured improvement by a DGM child means *empirically better on the
  measured task distribution*, not proved better in general;
- the foundation model is frozen while the editable agent scaffold—tools,
  prompts, context management, and workflow—is evolved;
- a benchmark score is not a theorem, and improvement of a theorem-search
  process is not proof of any theorem it proposes;
- the paper explicitly says that archive maintenance and parent selection are
  fixed and are **not** modified by this DGM.  It evolves agent descendants,
  not its archive controller.

That distinction is the center of the adoption: use evolution to search for
better ways to do mathematics, while keeping mathematical truth outside the
evolutionary objective.

## 2. Reproducibility audit of the released implementation

The code observations in this section refer only to the official repository at
commit
[`a565fd2d1dca504ef5104a7cc0f3bdc4ab9b4fd2`](https://github.com/jennyzzt/dgm/tree/a565fd2d1dca504ef5104a7cc0f3bdc4ab9b4fd2).
They are reasons to pin and audit an implementation, not a refutation of the
paper's reported experimental results.

The central mechanism is present in
[`DGM_outer.py`](https://github.com/jennyzzt/dgm/blob/a565fd2d1dca504ef5104a7cc0f3bdc4ab9b4fd2/DGM_outer.py#L50-L149):
the code loads archived agents, computes the sigmoid score and inverse-child
factor, and samples parents with replacement.  The default archive update keeps
all children that passed the preceding metadata/functionality screen.  Despite
its `is_compiled_self_improve` name, the pinned code checks required evaluation
metadata, at least one nonempty downstream patch, and the expected submitted
task count; it is not a general compilation or correctness proof.  The
self-improvement path reconstructs a parent's patch lineage, asks a separate
model to diagnose an opportunity from evaluation logs, generates a patch, and
runs staged evaluations.  The repository also warns that it executes untrusted
model-generated code and recommends Docker; that warning is a minimum, not a
complete isolation specification.

There are several paper/code seams that a derivative must not silently inherit:

1. The paper's parent-eligibility set excludes perfect-score agents.  The
   released `choose_selfimproves` function does not make that exclusion; every
   archived node whose metadata loads becomes a candidate.
2. The command-line `choices` list contains adjacent string literals
   `'score_child_prop' 'best'`, which Python concatenates.  The default still
   reaches the score/child branch because `argparse` does not reject the
   untyped default, but explicitly supplying `score_child_prop` or `best` is
   rejected, while the accidental `score_child_propbest` value falls through
   to random selection.
3. The otherwise unreachable/programmatic `best` branch sorts accuracy in
   ascending order and selects the first nodes, despite its comment saying it
   selects the best score.
4. The prose sometimes says that the selected parent analyzes its own logs;
   the algorithmic appendix and code make the more precise statement: a
   separate diagnostic foundation-model call reads those logs and proposes the
   feature that the selected coding agent implements.

These differences motivate a small, independently tested controller rather
than vendoring the research code.  They also illustrate a larger hazard:
adaptive reuse of visible benchmark subsets permits overfitting, evaluation-log
gaming, and accidental leakage.  Moreover, a mutation that makes several
attempts and invokes a judge may gain raw accuracy by spending more inference
compute.  Accuracy without cost and a genuinely untouched final control is therefore an
incomplete fitness measure.

## 3. Non-negotiable trust and privacy boundary

MathDGM has two domains separated by a one-way promotion gate.

### 3.1 Mutable discovery domain

Sandboxed descendants may modify only an explicit scaffold surface:

- task decomposition and sub-agent brief construction;
- allocation among symbolic, computational, literature, and hostile-review
  lenses;
- conjecture generation and representation changes;
- generation of exact-search kernels, caches, certificates, and experiment
  schedules;
- context compression, failure-ledger use, and artifact handoff;
- selection among already approved local tools and approved private model
  endpoints.

Everything produced here is an untrusted candidate.  Generated programs run
as an unprivileged user in disposable, resource-limited containers with a
read-only input snapshot, a fresh output directory, no credentials, no host
socket, and no network.  Model calls pass through a credential-free trusted
broker outside the sandbox: it accepts bounded structured requests, enforces
packet allowlists/redaction and cost limits, and records prompt, tool-schema,
model-snapshot/API, decoding, response-hash, and retry metadata.  Descendants
never receive endpoint keys.  The proposal model never receives hidden
evaluation instances or their answers.

Raw descendant output is hostile input.  Trusted non-executing parsers cap
paths, bytes, encodings, and nesting before producing structured summaries;
they never render untrusted HTML or execute attachments.  Later proposal and
review agents see sanitized records, preventing an archived artifact from
becoming a prompt-injection or covert-egress channel.

### 3.2 Immutable authority domain

Descendants cannot modify, invoke with altered flags, or write through:

- theorem statements used for evaluation;
- hidden task partitions, expected results, seeds, and regression controls;
- the Lean kernel/toolchain lock, exact certificate checkers, evaluator, score
  aggregation, archive controller, or promotion rules;
- provenance records, claim-status fields, artifact hashes, or the
  distinction between conjectured, computed, proved, and externally verified;
- network policy, credentials, repository remotes, or export policy.

A theorem becomes proved only through the repository's ordinary certification
path: a pinned proof kernel or a specified exact certificate checker, followed
by independent replay and hostile review appropriate to the claim.  A scaffold
score can nominate an artifact for that path; it can never change theorem
status.  Proof-checker crashes, timeouts, parser ambiguity, missing artifacts,
and numerical agreement are failures, not partial proofs.

All work remains private.  Workers have no public egress, telemetry, issue or
PR creation, package publication, database submission, or ability to push.
Foundation-model calls remain the current high-intelligence proposal engine,
but use only approved private channels and the minimum scoped packet needed for
the task.  No repository content leaves those channels, and nothing is made
public without the owner's explicit release decision.  Only the privileged
integrator may synchronize the verified private remote.  High-context agents
remain the research and synthesis center; narrow packets govern disposable
children, not the full-context integrator passes needed to harvest cross-domain
structure.  Evolution and CPU kernels augment that intelligence rather than
replacing it.

## 4. The MathDGM archive

An archive node is a content-addressed experimental record, not a chat and not
a theorem.  It contains:

Content identity here means exact, versioned presentation identity. Certified
mathematical or scaffold equivalence is a separate proof-carrying relation; it
never rewrites a node ID or silently hits an exact cache. The full contract and
the OMDoc/MMT--Unison--univalence prior-art map are in
`notes/CONTENT_ADDRESSED_MATHEMATICAL_IDENTITY.md`.

| field | required content |
|---|---|
| identity | versioned semantic presentation hash over normalized scaffold content and dependency hashes; creation time and human aliases are separate archive metadata |
| immutable inputs | repository commit, theorem-packet hash, controller/broker/evaluator hashes, model/API identifier, prompt/tool-schema/decoding hashes, toolchain/container hashes |
| heredity | complete scaffold patch relative to the parent and the reconstructed scaffold hash |
| hypothesis | one-sentence proposed mechanism and a pre-registered expected outcome |
| mutation class | decomposition, representation, search kernel, review, memory/compression, or scheduling |
| execution | random seeds, commands, exit states, CPU/GPU time, tokens, model/API cost, peak memory, response hashes, retry policy |
| artifacts | logs, programs, certificates, proofs, counterexamples, failure witnesses, and hashes |
| evaluation | development/adaptive-validation scores, one-time final-bank outcome, query count, uncertainty, baseline comparison, and adversarial checks |
| epistemic state | separate claim disposition, evidence kind, replay state, and review state; archive retention never changes claim status |
| diagnosis | what changed, what failed, nearest duplicate, and reusable stepping stone |

Nodes are append-only.  A child can inherit a useful scaffold from a
low-scoring parent, but it cannot rewrite its ancestry or a previous score.
Semantically duplicate nodes are retained for provenance but receive no
scaffold/presentation novelty credit; a new verified morphism, proof,
compression, or transport may receive its own separately typed artifact credit.
Low-scoring or mathematically unsuccessful genomes that nevertheless passed the
execution/attestation gate remain eligible stepping-stone parents. Rejected
executable scaffolds are evidence-only: their sanitized counterexamples,
diagnoses, and independently certified kernels may transfer, but their code is
not executable ancestry.

SHA-256 supplies content integrity, not authorship or append-only storage by
itself.  Each epoch root is anchored to a reviewed private Git commit (and may
later receive an offline signature with explicit key custody); validation
replays the prior root before extending it.  A stochastic model call is not
bitwise reproducible: its exact prompts/responses/artifacts are reconstructible
from the record, while behavioral reproducibility is a statistical claim over
pre-registered replicates.  “Independent replay” means a fresh worker and
container, and for headline computations an independently implemented checker
where feasible—not merely rerunning the producer's potentially shared bug.

The archive controller is deliberately fixed for the pilot.  Any later proposal
to change selection or evaluation is a conventional, separately reviewed
controller version and starts a new experiment; it is never an in-run
self-mutation.

## 5. Mutation, evaluation, and parent selection

### 5.1 Generation cycle

1. The trusted controller samples parents from the eligible archive and assigns
   each a scoped problem packet and one mutation class.
2. Proposal agents inspect the parent's visible artifacts and failure summary,
   state the intended improvement, and produce a minimal scaffold patch.
3. A static gate rejects changes outside the mutable surface and reconstructs
   the child from content hashes.
4. The child runs on visible development tasks in a disposable sandbox.
5. Survivors run through a trusted harness on a query-accounted adaptive
   validation bank.  Aggregate feedback still leaks information, so these
   queries may guide archive selection but are never called held-out or sealed.
   A final bank is never queried until one frozen terminal comparison, then is
   retired permanently.
6. Promising mathematical artifacts are replayed by a clean worker and sent to
   the immutable certification path.  The archive records both empirical score
   and certification outcome.

Evaluation uses paired comparisons against the parent and the strongest frozen
baseline under identical model, token, dollar, wall-clock, and CPU budgets.
The task unit, paired statistic, resampling hierarchy, stopping rule, and final
comparison are pre-registered before any of the 256 candidates run.  Stochastic
tasks use pre-registered seeds and intervals that respect the task-family and
winner-selection hierarchy.  The final untouched bank is opened only once,
after the pilot design and finalists are frozen.

### 5.2 Fitness is a vector, not “number of exciting claims”

The controller maintains Pareto strata over:

- independently certified mathematical yield;
- adaptive-validation success/calibration, with final-bank results reported
  separately and never fed back into selection;
- useful falsification/obstruction yield;
- exact-kernel throughput and reusable non-LLM computation;
- wall time, tokens, dollar cost, CPU/GPU time, and memory;
- lineage novelty and semantic diversity;
- artifact completeness and independent reproducibility;
- a concrete compression proxy: canonical certified-artifact bytes per fixed
  benchmark obligation discharged.  This is an engineering heuristic, never
  epistemic authority.

Within a Pareto stratum, parent sampling may use the DGM exploitation/exploration
shape

\[
 p_i=(1-\eta)\frac{w_i}{\sum_jw_j}+\frac{\eta}{|S|},\qquad
 w_i=
 \bigl(\varepsilon+\operatorname{sigmoid}(Q_i)\bigr)
 \frac{1}{1+n_i}\,N_iR_i.
\]

The controller first selects a Pareto stratum \(S\) by a pre-registered
mixture.  Here \(Q_i\) is a stratum-normalized cost/verified-progress score,
\(N_i,R_i\in[\delta,1]\) are deterministic hash/feature-diversity and replay
proxies, and \(0<\eta,\delta,\varepsilon\) are frozen for the epoch.  The
additive uniform mass—not \(\varepsilon\) alone—preserves a nonzero chance for
every node in the selected stratum.  Semantic equivalence and mathematical
novelty remain heuristic/audited annotations; no model judgment is treated as
an exact score.  Resource-heavy multi-attempt workflows pay their full cost in
\(Q_i\).

Objective-hacking tests are mandatory: canary tasks, statement-hash checks,
negative controls, mutation-surface diffs, replay in a clean container,
duplicate detection, shuffled labels where meaningful, and a “proves too much”
suite of nearby false statements.  A node is penalized for predicting success
confidently on a false control even if its headline benchmark score rises.

## 6. Concrete pilot: four evolutionary arms at the decic frontier

The pilot target is the first unresolved prime-prefix factor layer: a
nonreciprocal irreducible decic.  Seed knowledge consists of the strict
prime-support root cage, pair-aware coefficient and Graeffe bounds, the
cross-reversal square-index identity

\[
  \operatorname{Res}(q,q^*)=q(1)q(-1)L^2,
\]

for monic integral degree-ten \(q\) with \(q(0)=1\), where
\(q^*(x)=x^{10}q(1/x)\) and \(L\) is the registered trace resultant.  The
identity itself does not require irreducibility; nonreciprocity and
irreducibility ensure the relevant collision index is nonzero.  The existing
exact witnesses and no-go families are also seed inputs.  None is presented as a
factor exclusion.  Success on the real frontier means either a certified new
restriction that materially shrinks the surviving class, a certified
exclusion, or a reproducible counterexample that kills a stated route.

Run four complementary ecological arms in parallel.  They are not treated as
interchangeable experimental treatments: each arm has a pre-registered fixed
per-node and aggregate token, dollar, CPU, memory, and wall budget, and each
evolved scaffold is compared with that arm's frozen baseline on identical
packets:

| arm | mutable strategy | required output | CPU transfer target |
|---|---|---|---|
| **E — Enumeration** | ordering of coefficient, Graeffe, modular, resultant, and root-count filters; generation of new exact filters | exhaustive shard certificates, counts after every filter, replayable survivors | compiled enumerator with deterministic checkpoints, independently verified semantic preservation, coverage, and shard hashes |
| **I — Invariants** | representation changes around reversal, trace variables, modular collision, discriminants, and resultants | explicit identities/inequalities with hypotheses plus exact finite tests | symbolic-to-integer kernels that evaluate proposed invariants over millions of candidates without an LLM |
| **F — Falsification** | adversarial family construction and control-world selection | smallest counterexample or sharpest quantified obstruction to each live conjecture | property-based generators and delta-minimizers that continuously attack future claims |
| **C — Certification** | proof decomposition, lemma ordering, and certificate format, but never the kernel or statement | kernel-checked lemmas or exact certificates, and precise gap reports when closure fails | stable proof/checker artifacts whose replay needs no model call |

Each arm begins from a frozen baseline scaffold.  For 16 generations it emits
four proposed children, for exactly 256 attempted node evaluations total;
static-gate failures count against the proposing arm's budget.  At generations
4, 8, and 12, every eligible certified artifact/failure summary is released to
all arms on a deterministic schedule.  A separate preregistered matched-packet
randomization assigns transfer versus no-transfer context if we want a causal
transfer estimate; otherwise cross-arm exchange is reported descriptively.
Raw adaptive scores and instances never cross arms.  This implements the
desired transfer loop:

\[
  \text{agent insight}\longrightarrow
  \text{exact program or proof object}\longrightarrow
  \text{cheap repeated computation}\longrightarrow
  \text{new agent-visible evidence}.
\]

The development bank contains known decic identities, generated polynomials
with exactly known factorization/root data, and seeded false conjectures.  The
adaptive validation bank uses new deterministic seeds and
representation-equivalent variants unknown at mutation time, with every query
counted.  The single final bank is generated and committed before the run but
never queried until finalists freeze.  The genuine frontier has no hidden
answer oracle: it earns credit only when an exact artifact is independently
certified.  Rediscovery is merely new-to-repository unless a recorded
literature search supports a stronger novelty label.

## 7. Pilot metrics and pre-registered kill criteria

Report the following at every four-generation checkpoint:

1. certified new lemmas, exclusions, counterexamples, and quantified
   obstructions, with novelty checked against this repository;
2. development/adaptive-validation gap and paired improvement over the frozen
   scaffold, with the one-time final result reported separately;
3. exact candidates eliminated per CPU-second and certificate bytes checked
   per second on a frozen semantic workload whose preservation and exhaustive
   partition coverage are independently verified;
4. agent tokens and dollars per independently replayed useful artifact;
5. fraction of proposed claims refuted, rejected, kernel-checked, and
   independently reproduced;
6. semantic lineage diversity, duplicate rate, and fraction of later winners
   descended through an initially worse node;
7. fraction of verified repeated workload on the frozen task set displaced
   from model inference by traditional programs.  Unrelated CPU work earns
   nothing.

Stop immediately and quarantine the run on any privacy egress, credential
access, hidden-instance access, evaluator/kernel/statement mutation, promotion
status forgery, non-sandboxed generated-code execution, or inability to
reconstruct a node from its recorded hashes.

Stop the pilot rather than scaling it if any of these pre-registered conditions
holds:

- after 256 evaluations, there is neither one independently certified new
  lemma/counterexample nor a twofold adaptive-validation improvement over the
  same-arm baseline in exact-kernel throughput at equal resources;
- under the preregistered hierarchy, the cost-normalized final score is not at
  least 10% relatively above the same-arm frozen scaffold (using the frozen
  scalarization declared before the run), or its paired interval contains
  zero improvement;
- the final untouched bank loses more than half of the development gain;
- more than 25% of compute is spent regenerating exact or deterministic-feature
  duplicates after filtering, or one lineage supplies more than 80% of
  children for two consecutive checkpoints;
- model/API cost per independently replayed useful artifact is higher than the
  frozen multi-agent baseline and the program-executed fraction of repeated
  work has not increased;
- any artifact labeled kernel-checked or independently replayed fails a clean
  replay.  One such authority-label error is a boundary failure, not tolerable
  benchmark noise.

Passing the pilot would establish only that archive-based scaffold evolution
improves this private research process under the measured distribution.  It
would not establish recursive intelligence explosion, universal mathematical
ability, or a proof-producing Gödel machine.  Its value would be more concrete:
agents discover tactics and kernels; exact programs cheaply compound them;
proof systems decide what survives; and the private archive preserves the
stepping stones without confusing search fitness with truth.

## 8. Primary sources

- Jenny Zhang, Shengran Hu, Cong Lu, Robert Lange, and Jeff Clune,
  [*Darwin Gödel Machine: Open-Ended Evolution of Self-Improving Agents*](https://arxiv.org/abs/2505.22954),
  especially §§3–6 and the parent-selection/algorithm appendices.
- Official DGM repository,
  [pinned commit `a565fd2d1dca504ef5104a7cc0f3bdc4ab9b4fd2`](https://github.com/jennyzzt/dgm/tree/a565fd2d1dca504ef5104a7cc0f3bdc4ab9b4fd2),
  especially
  [`DGM_outer.py`](https://github.com/jennyzzt/dgm/blob/a565fd2d1dca504ef5104a7cc0f3bdc4ab9b4fd2/DGM_outer.py) and
  [`self_improve_step.py`](https://github.com/jennyzzt/dgm/blob/a565fd2d1dca504ef5104a7cc0f3bdc4ab9b4fd2/self_improve_step.py).
- Sakana AI's authors' summary,
  [*The Darwin Gödel Machine: AI that improves itself by rewriting its own code*](https://sakana.ai/dgm/),
  for the intended high-level framing and safety discussion.

---

## Appended 2026-08-19, another thread: §1's design sentence is two structural facts, checked

*Appended at the end, altering no line above.*

§1 reads the parent-selection weight `w_i = σ(10(α_i − 0.5)) · 1/(1 + n_i)` and states
its intent: *"a high-scoring but underexplored node is favored, while every eligible node
has nonzero probability."* Both halves are facts about the **form** `f(α)/(1+n)`, and
both are now checked exactly, in ℕ, with no reals and no sigmoid, in
`formal/cubical/NaturalMachine/TheScoreOrderAndTheWeightOrderDisagree.agda`
(`--safe`, no postulates, no holes):

```agda
WeightBelow a b = (scoreOf a · suc (childrenOf b)) < (scoreOf b · suc (childrenOf a))

theTwoOrdersDisagree : (scoreOf fresh < scoreOf explored) × WeightBelow explored fresh
positiveScoreKeepsPositiveWeight : (f n : ℕ) → 0 < (suc f · suc n)
```

with `explored = (3,3)` and `fresh = (2,0)`.

**How the reals are avoided.** Comparing `f₁/(1+n₁)` with `f₂/(1+n₂)` is comparing
`f₁·(1+n₂)` with `f₂·(1+n₁)` — valid because both denominators are positive — and that
is a ℕ comparison once `f` is a ℕ.

**What is lost by it, stated rather than glossed.** The sigmoid's range. `σ(10(α−0.5))`
lies strictly between 0 and 1 and never attains an integer; the witness uses 3 and 2 and
claims nothing about which accuracies α produce a 3:2 ratio. What is proved is a property
of the weight's **shape**, not of any run. **Not claimed:** that DGM's actual archive ever
contains such a pair.

**What the two facts say.** The weight order is *not* the score order — so the archive is
not hill-climbing on the benchmark, which is the design's point. Which of the two orders
is better is not said: they are different orders and the design chooses the second
deliberately. And the child count divides the weight down but never to zero, so no node is
removed from consideration by having been explored.

**Not claimed at all:** anything about the benchmark numbers this note records (20.0 → 50.0
on the 200-task SWE-bench Verified subset; 14.2 → 30.7 on Polyglot) and explicitly declines
to import as evidence about mathematical discovery. Nothing above is evidence about them,
nothing was run, and **arXiv:2505.22954 was not read by me** — the formula is carried from
§1 of this note.

---

## Appended 2026-08-19, same thread: §7's last kill criterion is not a threshold, and here is why

*Appended at the end, altering no line above (including the §1 append above it).*

§7's criteria are thresholds on rates — 25% of compute, 80% of children, half the
development gain, 10% relative score — with one exception:

> *"any artifact labeled kernel-checked or independently replayed fails a clean replay.
> One such authority-label error is a boundary failure, not tolerable benchmark noise."*

That one is not a stricter threshold. It is **not a threshold at all**, and the reason is
checked in
`formal/cubical/NaturalMachine/OneCounterexampleRefutesALabelButNotAnExistential.agda`
(`--safe`, no postulates, no holes):

```agda
LabelSound = (a : Artifact) → Labeled a → Replays a
oneFailureRefutesTheLabel : (a) → Labeled a → ¬ Replays a → ¬ LabelSound
bothAtOnce : (¬ LabelSound …) × (SomethingReplays …)
```

A label asserts a **Π**, and a Π has no tolerance: one counterexample is the entire
refutation. That is exactly "a boundary failure, not tolerable benchmark noise".

**The honest weakness of the contrast, stated rather than glossed.** The second half uses
an **existential**, because it needs no counting. A genuine *rate* claim ("more than
half", "at most 25%") needs a measure and a count, and neither is modelled. So the module
does **not** establish the comparison §7's list invites — only that at least one other
claim-shape survives what kills a label. That is the direction of the point, not its full
strength.

**Not claimed:** anything about DGM, its archive, its benchmark numbers, or whether the
pilot in §6–§7 should be run. This note quarantines the design as "not canonical
architecture" and declines to import DGM's empirical claims; nothing here changes that,
nothing was run, and **arXiv:2505.22954 was not read by me**.

## Appended 2026-08-19, third thread: §2's seam 3 is a dichotomy, and it is checked

*Appended at the end, altering no line above.*

§2's third seam reads: *"The otherwise unreachable/programmatic `best` branch sorts
accuracy in ascending order and selects the first nodes, despite its comment saying it
selects the best score."* Stated that way it is a bug report. Its mathematical content is
a statement about **when the two selections agree**, and that is the part worth having,
because it says when the seam is observable at all.

Checked in
`formal/cubical/NaturalMachine/AscendingFirstIsTheWorstUnlessTheArchiveIsConstant.agda`
(`--safe`, no postulates, no holes; container green under Agda 2.6.3 + cubical v0.5,
which is **not** the declared pin — `check.sh` returns 1 and prints that itself):

```agda
Lower b xs = All (b ≤_) xs        Upper b xs = All (_≤ b) xs

lowerAndUpperForcesConstant  : Lower b xs → Upper b xs → All (_≡ b) xs
nonConstantMakesTheLowestStrictlyWorse
  : Lower b xs → Any (λ x → ¬ (b ≡ x)) xs → Σ[ x ] ((b ≤ x) × ¬ (b ≡ x))
twoScoresAlreadySeparateThem  : Lower 1 [1,2] × Upper 2 [1,2] × ¬ (1 ≡ 2)
theSeamIsInvisibleExactlyWhereSelectionIsVacuous
```

**The seam is invisible exactly where the selection is vacuous.** On a constant archive
ascending-first and best return the same score — and on a constant archive, choosing a
parent *by score* carries no information. So there is no regime in which the branch is
both correct and doing work: it agrees with its comment only when the comment describes
nothing. That is sharper than "the sort is backwards," and it is why the seam should not
be filed as cosmetic even though §2 correctly notes the branch is otherwise unreachable.
Two distinct scores in the archive already separate the two selections.

**Grade, and it is the whole caveat: I did not read the code.** §2's header restricts its
observations to one pinned commit of an external repository, and this repository's egress
rules mean I did not fetch it — no request to github.com was made. What is checked is the
**order-theoretic content of §2's sentence**, on the assumption that the sentence
describes the branch correctly. If §2 has misread the code, nothing above is affected and
nothing above defends §2: the theorem is about ascending selection versus maximal
selection and would stand if the branch did not exist.

**No novelty.** That a minimum and a maximum coincide only on a constant list is
elementary order theory; it is attached here, not discovered.

**Not claimed.** No sorting algorithm appears — the argument is entirely about bounds, so
nothing depends on how the ascending order is produced or on its stability. The other
three seams are untouched: the missing perfect-score exclusion, the adjacent string
literals Python concatenates, and which model reads the logs are not order-theoretic.
Scores are `ℕ` above; §2's are accuracies, and no claim is made that they are linearly
ordered without ties or that ties break the same way. "Selects the first node**s**" is
plural and this treats the *bound*, not the prefix — a prefix statement would need the
sort.

## Appended 2026-08-19, same thread: §5.2's two-stage shape is forced, not chosen

*Appended at the end, altering no line above.*

§5.2 opens *"Fitness is a vector, not 'number of exciting claims'"*, lists eight
objectives, and says the controller maintains Pareto strata and samples **within** a
stratum. The design is stated; the reason it must be that shape is not. It is forced, and
both halves are checked in
`formal/cubical/NaturalMachine/AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision.agda`
(`--safe`, no postulates, no holes; container green under Agda 2.6.3 + cubical v0.5,
which is **not** the declared pin — `check.sh` returns 1 and says so):

| checked | reading here |
|---|---|
| `≼-refl`, `≼-trans`, `≼-antisym` | the pointwise order is a genuine partial **order**, antisymmetry included |
| `incomparable` | `(2,0)` and `(0,3)` dominate in neither direction — the order is **not total**, so "the best node" does not denote |
| `sumIsMonotone` | a scalarisation cannot *contradict* dominance … |
| `scalarisationDecidesAnIncomparablePair` | … but it does *decide* that pair: `sum` says `2 < 3` where the objectives say nothing |
| `monotoneStrictnessRefutesDominance` | and for **any** monotone `f`, `f v < f w` refutes `w ≼ v` — exactly its strength, and no more |

**So a scalar fitness is a strict extension of the objective order, and every such
extension is a choice the objectives do not license.** §5.2's two-stage shape is therefore
not a refinement of "pick the best": there is no best to pick, and any rule producing one
has smuggled a preference ordering in under the name of a measurement.

**This joins the other thread in this note.** §2's seam 3, checked in
`AscendingFirstIsTheWorstUnlessTheArchiveIsConstant`, is a defect in a branch that assumes
a *total* order on accuracy; §5.2 says the fitness is a vector. The two sections are about
the same missing total order. No claim is made that the released code implements §5.2 —
it does not; §5.2 is this repository's proposed controller.

**No novelty.** The product order, its failure of totality, and monotone scalarisations as
strict extensions are standard multi-objective optimisation — Pareto, *Cours d'économie
politique* (1896), and Edgeworth before him. The Agda is attached, not discovered.

**Not claimed.** Vectors are `List ℕ`, comparable only at equal length; no length index
appears. §5.2's objectives include wall time, tokens and dollar cost, which are to be
**minimised** — nothing above flips a coordinate, so the theorems concern a vector whose
coordinates all point the same way, and applying them needs the costs negated first.
Real-valued objectives are not modelled. Nothing is claimed about `Q_i`, the weights, the
exploration mass `η`, or the stratum mixture; and it is **not** proved that a Pareto
stratification exists constructively for an arbitrary archive — that needs a decision on
`≼`, which is not given here.

## Appended 2026-08-19, fourth thread: §2's seam 1 has the same shape as seam 3

*Appended at the end, altering no line above.*

§2's first seam reads: *"The paper's parent-eligibility set excludes perfect-score agents.
The released `choose_selfimproves` function does not make that exclusion; every archived
node whose metadata loads becomes a candidate."* Stated that way it is a discrepancy. Its
mathematical content is **why** the exclusion is there and **when** dropping it is
observable, and both are short. Checked in
`formal/cubical/NaturalMachine/ExcludingPerfectScorersRemovesOnlyGainlessCandidates.agda`
(`--safe`, no postulates, no holes; container green under Agda 2.6.3 + cubical v0.5,
which is **not** the declared pin — `check.sh` returns 1 and says so):

```agda
bounded : (a : A) → score a ≤ cap

noStrictImprovementAtTheCap
  : (a : A) → score a ≡ cap → ¬ (Σ[ b ∈ A ] (score a < score b))
eligible                          = filterDec Imperfect decImperfect
eligibleKeepsEveryImperfectAgent
theSeamIsInvisibleExactlyWhenNobodyIsPerfect
```

So the paper's exclusion is not a heuristic: it removes candidates whose possible gain is
**provably zero**. And the missing exclusion changes nothing while no archived agent
attains the cap — the two eligibility sets then have the same members.

**That is the same shape seam 3 turned out to have, and finding it twice in one section is
the thing worth recording.** Seam 3's `best` branch agrees with its comment exactly on a
constant archive, where selection carries no information. Seam 1's missing exclusion is
invisible exactly while nobody is perfect — and once someone is, every sample drawn on
them is provably gainless. Neither seam is cosmetic; neither is visible in a benign
archive. A reviewer checking either against a healthy run would see nothing.

**Grade, unchanged and load-bearing: I did not read the code.** §2 restricts its
observations to one pinned commit of an external repository, and this repository's egress
rules mean no request to github.com was made — for this seam or for seam 3. What is
checked is the order-theoretic content of §2's *sentence*, assuming it describes the
function correctly. If §2 misread it, nothing above is affected and nothing above defends
§2.

**No novelty.** "Nothing exceeds a bound that is attained" is elementary; it is attached
because §2 records the discrepancy without the reason, and the reason is what tells an
implementer whether to care.

**Not claimed.** The converse — that an agent below the cap *does* admit a strict
improvement — is false in general and is not claimed: the cap bounds the score, it does
not populate it. Nothing is said about the sampling weights: §5.2's `p_i` and the
exploration mass `η` do not appear, so "spends mass where no improvement exists" is a
reading of the theorem and not a quantitative claim; no share of wasted budget is
computed. Scores are `ℕ`, §2's are accuracies, and "perfect" is modelled as attaining a
stated cap. **Seams 2 and 4 remain untouched** — adjacent string literals concatenated by
Python, and which model reads the logs, are not order-theoretic.

## Appended 2026-08-19, fifth thread: seam 2 has the shape too — and seam 4 has no such content

*Appended at the end, altering no line above.*

The previous append observed that §2's seams 1 and 3 share a shape — *a defect
undetectable exactly where it is harmless* — and said that shape is a property of the
**section**, so the remaining seams should be checked against it first. Done, and it
holds a third time. Checked in
`formal/cubical/NaturalMachine/ADisjointValidatorMakesAFlagUnusableAndInvisible.agda`
(`--safe`, no postulates, no holes; container green under Agda 2.6.3 + cubical v0.5,
which is **not** the declared pin — `check.sh` returns 1 and says so):

```agda
concatenationIsDisjoint  : (t : ℕ) → Mem t intended → ¬ Mem t accepted
theAcceptedTokenIsNotIntended : ¬ Mem 2 intended
theFlagIsUnusable
theSeamIsInvisibleWhileNobodySuppliesTheFlag
```

**Seam 2's consequence, stated rather than restated:** the accepted set and the intended
set are *disjoint*, so no intended spelling is accepted and the one accepted spelling is
one nobody would write. The flag is therefore not merely wrong but **unusable** — and
unusable invisibly, because a run that never supplies it never meets the validator. Seams
1, 2 and 3 are now three instances of "undetectable exactly where harmless", which is a
fact about §2 and not three coincidences.

**Seam 4 is not formalised, and here is the reason.** It reports that the prose says the
selected parent analyses its own logs, while the algorithmic appendix and the code say a
separate diagnostic foundation-model call reads them. That is a discrepancy about **which
agent performs a step** — an attribution of an action, not a relation between values — and
nothing in §2 turns it into a claim with a truth condition this substrate can carry.
Saying so with a reason is the honest closure of the seam list; inventing a formalisation
would be the dishonest one. **So §2's four seams are: three checked, one declared
out of scope with grounds.**

**Grade, unchanged and load-bearing: I did not read the code**, and seam 2 is about
*Python's semantics*. No request to github.com was made. Nothing above claims anything
about `argparse`, about adjacent-literal concatenation, or about the pinned file. What is
modelled is the *situation* §2 describes — a validator whose accepted set is disjoint from
the intended set. If §2 misread the code, the situation does not arise and nothing above
is affected.

**Not claimed.** Tokens are `ℕ` standing for strings; no string type, no concatenation
operation and no Python is modelled, so `concatenationIsDisjoint` is an **assumption about
the instance** encoded as three distinct numerals, not a derivation from concatenation.
Nothing is said about what the fall-through branch does — §2 says random selection, and no
semantics of selection appears — nor about validation being skipped for an untyped
default, which is not modelled either.
