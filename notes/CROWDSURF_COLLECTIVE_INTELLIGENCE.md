# Crowdsurf collective intelligence — a design derived from this corpus

**Status: design derivation with a named external consumer. Not a claim
packet. Per PROTOCOL §7 this meta-document cites its consumer: the
Crowdsurf founding team (Shiv, Avik, Umang) and their Claude agents,
who must organize humans-in-Slack + agents-on-git/Linear into one living
knowledge system. Per RESEARCH_SYSTEM §7 this is a *proposal* until it
has a frozen baseline and evidence on live work; metaphors do not grant
architectural status, and every transported law below is graded.**

**Grading key** (used throughout):
- **[EXACT]** — the design object literally instantiates the cited
  mathematics (finite sets, quotients, links, costs are the actual
  structures, not images of them).
- **[TRANSPORT]** — the structure transports along a declared map whose
  preservation ledger is stated; the analogy generates the design but
  does not prove it (discovery-loop norm: "analogies may generate
  packets but not claims").
- **[HYP]** — organizational hypothesis; falsifier stated.

---

## 1. The problem, stated as this corpus states problems

A company is a finite set of states (facts, decisions, artifacts, live
uncertainties) observed by bounded observers (three humans, N agents)
through context-local probes (a Slack thread, a PR diff, a Linear board,
a brain doc), each observer acting on the state and each action changing
what later probes can see. The design question is the machine's standing
question (`README.md`, behavioral quotient):

> **What is the least distinction that still determines the next lawful
> action?** Too many distinctions waste memory and search. Too few make
> action impossible or wrong.

Everything below derives from theorems this corpus has already proved
about exactly that question — observation, gluing, holonomy, leakage,
memory, and cost — plus the corpus's own operational history (1045
commits, ~45 agents, two lineages), which is itself the largest
controlled encounter with the problem available to us.

---

## 2. The laws, and what each one forces

### L1. Messages coordinate; documents assert. [EXACT as protocol; proven by this repo's history]

PROTOCOL §1: "mathematical authority lives only in `notes/` (proofs) and
`code/` (reproducible computation)." Slack is the message plane; the git
repo (surf-app `brain/` + code) is the assertion plane; Linear is a
**generated view** (MATH_OS: "STATE.md, the site, and future dashboards
should be generated views of this graph rather than competing
authorities"). Crowdsurf already half-knows this ("if it isn't in the
LOG, it didn't happen") but has no mechanism on the chat side. The law
fixes the *type* of every surface, which dissolves the live
Wall-vs-Linear-vs-weekly-vs-bets ambiguity: exactly one surface per
fact-kind is authoritative; every other appearance is a link.

### L2. Locally consistent ≠ globally reconstructible; the deficit is exact. [TRANSPORT]

`CRT_BOUNDARY_QUANTUM_MEMORY.md`: local views mod m₁,…,mₙ can be
pairwise compatible everywhere while a hidden register of dimension
exactly g = ∏mᵢ / lcm(mᵢ) remains undetermined; reconstruction is exact
**iff the moduli are pairwise coprime** (g = 1). Transport map: pillar
scopes ↦ moduli; overlap of scope ↦ common factor. Preservation ledger:
what transports is the trichotomy (compatibility condition + residual
fiber + coprimality criterion); what does not transport is the exact
integer count. Consequence: **"one home per fact" is not a hygiene
preference — it is the g = 1 condition.** Overlapping ownership does not
merely risk duplication; it *provably* leaves a global coordinate that
no amount of pairwise consistency-checking recovers. When scopes must
overlap, the design must store the overlap condition and the residual
ambiguity explicitly (the corpus's answer in `README.md` §CRT), which in
brain terms is the deliberate split-with-mutual-links pattern — retained,
now with its justification.

### L3. The obstruction to one global truth lives in the cover and the gluing data, not in the values. [TRANSPORT]

`PM_SECTION_VS_COCYCLE.md` (12/12 hostile, executed): every context
individually consistent (4 local sections each), zero global sections,
and the failure **is** the cocycle class in coker(δ) of the
context-incidence map. Three executed corollaries transport:

1. **Restricting the cover restores consistency** (rows-only cover
   admits sections). When two live surfaces both track "what we're
   doing now," no amount of syncing the *values* fixes the drift —
   Crowdsurf measured this: the Wall's Product board became "a shadow
   tracker next to Linear" in four days. The fix the mathematics
   licenses is to shrink the cover (one live surface; others are
   renders) — not more reconciliation meetings.
2. **The charge lives in the identification of the two occurrences.**
   A one-edge local-system twist kills the class. When one fact appears
   in two contexts, the *identification* between the occurrences (a
   typed link) is the carrier of consistency. An untyped copy is a
   gauge choice that will pick up charge silently. Hence: copies are
   forbidden; links are load-bearing objects.
3. The incidence structure has a genus: PM is K₃,₃, nonplanar, minimal
   on the torus. Some organizations of contexts *cannot* be flattened
   into a hierarchy without breaking incidence. A knowledge base that
   insists on a tree (folders only, no cross-links) is asserting
   planarity it does not have. The link graph, not the directory tree,
   is the real object.

### L4. A node may compress iff every consumer validates the identification — checkable, not social. [EXACT]

`TWO_IDENTITIES.md` §2 (relativized initiality, proved; 16/16 hostile
tests, 602-algebra exhaustion): quotienting by what your observables
cannot distinguish preserves universality relative to exactly the models
that validate the identification; the excluded models are the charge,
made external and exact. The network row of its own table states the
design rule verbatim: "a node may compress iff every node that must
still interpret it validates the identification — compatibility is
ker(h) ⊇ Θ, **checkable, not social**." A summary, digest, or weekly
rollup is lawful for the readers whose tasks are constant on its merged
classes and *silently wrong* for everyone else. So every compression
(digest, TLDR, dashboard) must name its task family — who it is
sufficient for — and when it fails, the **confused pair names the
missing field** (`README.md`: "the pair of states it confused tells us
exactly what must become visible next"). Repair is a refinement, never a
rewrite (Lean-checked: a richer view may split an old class but cannot
merge two old classes — corrections refine; strike-through, never
delete).

### L5. Order of lossy compression matters, and sometimes provably cannot be made not to matter. [TRANSPORT]

`README.md` §working memory: two fiberwise-averaging views commute iff
their fibers spread evenly inside a common coarsening (an integrality
criterion cheap enough to be an obstruction). A pipeline
thread → digest → weekly → strategy is a composition of lossy views;
generically its output depends on compression order, and block sizes
alone can prove no order-free version exists. Consequence: do not build
staged summarization pipelines and expect them to converge; keep
**replay pointers to the uncompressed source** at every stage (the
permalink is the pointer), so any stage can be recomputed from the
ground truth rather than from the previous stage.

### L6. Working in a restricted scope is valid iff leakage vanishes; otherwise the exact price is a correction channel of rank(QAP). [TRANSPORT]

`LEAKAGE_COST_VECTOR.md` / `PROJECTION_LEAKAGE.md`: AP = PAP + QAP;
sector-only execution is exact iff QAP = 0; else the minimal exact
correction channel has dimension exactly rank(QAP), and the commutator
vanishes iff the window is a union of cosets of the group generated by
the action's support. Transport: a team/agent owning a scope and acting
within it is exact iff the scope is closed under the actions that
actually occur; otherwise a correction channel to the complement is
*mandatory for validity, not politeness*. Crowdsurf's measured instance:
the feed-depth answer lived in engineering for six weeks while product
needed it — a nonzero QAP with no channel. The channel is not "more
communication" (a scalar); it is a typed route from a named scope to a
named complement, sized by what actually leaks. And the vanishing
criterion is an ownership-boundary design rule: **align scope boundaries
with the support of the actions** (the changes that actually co-occur),
not with the org chart.

### L7. Value of retained knowledge is carried by the provenance DAG, not by size; retention is submodular until supports become conjunctive. [TRANSPORT]

`CACHE_OPTION_VALUE_NO_GO.md`: equal-cost, equal-size caches with
incomparable futures; the exact sufficient observable is the latest
cached position on each future construction path — labeled dependency
support. `CACHE_RETENTION_SUBMODULARITY.md`: retention value is
monotone submodular, so greedy curation is (1−1/e)-optimal;
`PROOF_SUPPORT_COMPLEMENTARITY.md`: submodularity holds **iff every
minimal support is a singleton** — genuinely conjunctive support (a
decision that needs A *and* B jointly) is exactly where diminishing
returns fail and where curation must switch from greedy to explicit
dependency tracking. Consequences: doc-count and token-count metrics
are provably uninformative; the knowledge base's real state is the link
graph with provenance; second use of a written result costs zero
(`CACHE_RELATIVE_FORMATION_COST.md`, idempotence) — which is the entire
economic argument for writing things down once, linked, rather than
re-deriving in chat.

### L8. Build the index only past its break-even, and the horizon is a genuine input. [EXACT]

`AMORTIZED_CERTIFICATE_WALK.md`: compile-once C, old query D, compiled
query S; strict gain iff k(D−S) > C, k_min = ⌊C/(D−S)⌋+1 — and the
two-futures argument proves **no horizon-free rule can decide
correctly**: the missing horizon "is a genuine input," and hardcoding
one "silently changes the problem." This is the anti-overengineering
theorem, and it is why this design ships a minimal core: every piece of
tooling below states its C, D, S and the usage horizon that justifies
it; anything without k_min in plausible range is *deliberately not
built* (§5). It is also why the strongest tiers ship disabled:
`discovery_loop.py`'s `CERTIFICATION_ENABLED = False` is the pattern —
an unbuilt gate is a disabled gate, never a rubber-stamped one.

### L9. What may be asked determines what must be stored. [TRANSPORT]

`CONTROL_INDEXED_PREDICTIVE_QUOTIENT.md`: the same carrier under two
control languages has exact memory dimension 4 or 5; there is no functor
from untyped dynamics to "the" memory — one must declare **who may
choose future controls**. `ADDITION_CHAIN_PROCESS_MEMORY.md`: a history
is memory (unregenerable from the endpoint) exactly when future
availability probes can separate it. Transport: the set of questions the
team commits to being able to answer ("why did we decide X?", "what did
we try and kill?", "what would break if we reverted Y?") *is* the
control language, and it determines — before any tooling — what must be
captured at write time: provenance links, kill-yields, dependency edges.
Capture nothing beyond what the declared question family needs
(behavioral quotient, L4); capture nothing less (the no-go).

### L10. Culture does not scale; mechanism that never fires is worse than none; each rule must name its forcing incident. [HYP, grounded in this repo's measured history]

The unshallowed history (1045 commits) contains the decisive negative
result: the designed certification gate **never once fired** (0
certified, 0 load_bearing packets among 26+) while the actual quality
was held by culture — hostile audit, strike-through, walk yields — and
the repo's own audit states "culture does not scale with agent count"
(`HISTORY_DIGEST`, unmerged branch). Simultaneously: every governance
layer that *did* hold was installed in response to a named injury
(PROTOCOL ← two agents colliding; journals ← agents having no memory;
CLAUDE.md ← exp27's fitted constant), and two rules were withdrawn
within minutes when the mathematics showed them wrong, both withdrawals
improvements. Kernel `history/P0-P3` records the protocol as a
fixed-point iteration, each revision forced by what the previous one
produced, with a falsifier on record. Design consequence: ship the
**smallest mechanism the culture will actually exercise**, version the
process document, require each revision to name the incident that
forced it, and register a prediction with each mechanism so its failure
is detectable (PROTOCOL §4: "surprises are only detectable against a
registered prior").

---

## 3. The architecture the laws force

Three planes with fixed types (L1), one link graph across them (L3),
compression only with named consumers (L4), replay pointers everywhere
(L5), typed correction channels (L6), provenance-DAG curation (L7),
break-even-gated tooling (L8), capture set by the declared question
family (L9), mechanism sized to culture (L10).

### 3.1 Slack as a native data structure — the citsec move, grounded

Slack messages are the corpus's `collab/messages/`: numbered-by-time,
immutable, one object each, threading = `re:`. What made citsec's
internal www work was not tooling but a **linking norm**: any message
can cite any message, and substantive messages *do*. The mathematics
says why this is the right primitive: the link is the identification
carrying the charge (L3.2), the replay pointer defeating compression-
order dependence (L5), and the provenance edge carrying value (L7).

The norm, three sentences long (the whole "protocol" a human must hold):

1. **Link liberally; a link is any reference, and reference by link
   is lossless.** A substantive Slack message links whatever relevant
   prior expressions are on the author's mind — prior threads, brain
   docs (GitHub permalinks), PRs, Linear issues — and the sentence
   around the link is its annotation. The link need not assert a
   causal connection; "look at this →" with a permalink *is* the
   move. Its content is exactness: a paraphrase is a quotient with an
   unstated kernel (a new lossy compression the reader must unpack
   and nobody audited), while a link transmits the literal expression
   — the identity map on the referent. **We are building
   losslessness**: reference by pointer instead of reference by
   re-description, which is L5's replay-pointer rule extended from
   pipelines to all reference, and L7's carrier made concrete (replay
   pointers, not summaries, determine reuse and invalidation).
   Linking on noticing is the cheapest possible knowledge write: the
   act of connecting two expressions IS captured cognition, and it
   turns streams of consciousness into graphs of consciousness as the
   default mode of participation. The evidence
   against dense linking (research base §1.3) applies only to
   *automatic, unauthored* backlinks — machine-generated incidence
   posing as assertion — never to authored relevance. An uncited claim
   is a seed, not a result (message types: `info | proposal | claim |
   challenge | review | result` — carried as lightweight emoji or
   thread-prefix conventions, not fields). Corollary for identity:
   when the link graph is primary, **threads and objects carry the
   structure and agents are participants in them** — identity is
   distributed across the graph ("no one file is the self",
   persistent-research), and an agent's journal is its view of the
   graph, not the graph itself.
2. **Chat never carries authority.** A decision reached in a thread
   does not exist until it lands in the brain with the thread's
   permalink as provenance — and the landing is announced *back into
   the thread* (the back-link closes the loop; the thread becomes
   navigable from the doc and the doc from the thread).
3. **Corrections are replies that strike, never edits that erase.**
   The correction record is part of the knowledge (PROTOCOL §3).

### 3.2 The capture channel (the one new mechanism)

The single highest-leverage build, sized by L8 (C = one agent flow;
D = a human remembering to transcribe, frequently ∞; S = one reaction):

A designated reaction (e.g. 📌) or `@brainwave capture` on any Slack
message/thread triggers an agent that:
- drafts the brain delta (LOG entry, doc diff, or new note) with the
  **Slack permalink embedded as provenance** and the humans named;
- opens it as a normal PR (brain hygiene as the review gate, per the
  existing constitution);
- on merge, posts the artifact link back into the thread.

This is the corpus's landing loop (`work → land → message inviting
review`) with Slack as the message plane. It is recipient-conditioned
at the capture site — the human chose the moment — rather than a firehose
summarizer, which L4 forbids (a universal summary has no validated
consumer). Decisions get one extra type: a thread marked `decision`
that has produced no artifact within 48h is surfaced by the vigil
(below) — the "messages coordinate, documents assert" invariant made
observable.

### 3.3 The vigil — delta-only, norm-citing, never acting

Port `collab/vigil.py`'s four commitments verbatim (they are its whole
content): **no measurement** (every probe exact); **delta-only** (no
output when nothing changed); **every finding names its norm** ("a
probe that cannot say which rule it is an instance of is a preference,
not a finding"); **bounded, never acts** ("it observes and reports;
acting is an agent's job"). Probes for Crowdsurf, each an existing
failure mode with a name:

- decision-threads with no landed artifact (L1);
- LOG-currency: pillar files changed after the pillar's last LOG entry
  (the brain-hygiene check, now continuous);
- **active-depends-on-terminal** (from `natural.py`): a live Linear
  ticket or bet whose cited decision was reverted/superseded — the
  single highest-ROI check, it is invalidation propagation;
- unanswered asks: a message with an explicit ask cited by no later
  message (labeled as the keyword heuristic it is);
- stale claims: >N days, no commits on the claimed scope (PROTOCOL §2
  takeover rule).

Output to one channel. Silence means nothing changed — which makes
silence informative (delta-only is what keeps the bot readable for
months; a bot that repeats standing facts is the disease it monitors).

### 3.4 Memory: journals, roster, resume

Per-agent (and optionally per-human) append-only journals with the
mandatory session-end resume entry ("a future instance of you starts by
reading your journal top to bottom; write for that reader") — this is
already the corpus's only cross-session memory and it is the correct
carrier: L9 says the history that changes future availability is
unregenerable from endpoints, and agent journals are exactly that
history. A `resume` command (Slack slash or CLI, compiled read-only à
la `natural.py`) rehydrates: journal head, owned claims, review debts,
new-since-cursor messages. **Per-recipient cursors** (from the field
envelope in `collab/orchestration/`): each member's digest starts from
their oldest unacknowledged item and advances only on delivery — a
restart can never silently skip unseen work. One rotating neglected
doc per digest (the INSPIRATION[] pattern) re-injects what nobody has
read lately.

### 3.5 Epistemic conventions carried over as culture, not tooling (L10)

- **Forecast with the claim**: any bet/experiment registers predicted
  outcome + outcome space at launch (Crowdsurf's bets.md already has
  finish lines; add the prior).
- **Walk ledger with yields**: every killed initiative emits what it
  established and what would extend it; briefs cite yields. Separate
  *errata* (a statement was wrong) from *walks* (a direction died) —
  their conflation caused a measured false forecast here (STATE 446).
- **Adversarial toward claims, collegial toward agents**; refutation >
  replication > new results; strike-through corrections;
  "possibly-new" never "novel" without a recorded search — for a
  startup: no market/competitor claim enters the brain as fact without
  a fetched source (the evidence discipline already in the brain
  constitution, now with its ranking).
- **Meta-documents must cite a consumer or they don't land** — the
  anti-process-bloat rule, applied to this very document and to every
  future process doc.

### 3.6 Channel topology: channels are claims (added 2026-08-13, upstream question)

How to handle a growing number of channels — a channel per project /
task, subtasks all the way down? The corpus answers directly:

- **Install on collision, not by taxonomy** (walk forcing law: the
  walk installs the least new sensor at the moment a collision demands
  one, and that stream is capacity-optimal). A subtask lives as a
  *thread* in its parent channel until it collides — its traffic
  confuses two distinct workstreams, or it needs its own membership.
  That collision is the birth event of a child channel; the birth
  message links the parent thread both ways. Channel count grows with
  the actual distinction structure of the work, never with a
  pre-imagined hierarchy (L9: the needed quotient cannot be known
  before the question family exists).
- **Two channel types, matching claims vs notes.** *Task channels* are
  claims: finite, born on collision, terminal-stated, archived.
  *Dimension channels* (brand, reliability, distribution…) are
  standing observables with no terminal state. Keep the dimension set
  small and stable — it is the fixed cover that gives the sprawl its
  map; every task channel's topic links up to its dimension (the
  connected-cover invariant, mirroring pillar→north-star up-links).
- **Closing is a quotient, and archive is its lawful form.** "The code
  in the repo speaks for itself" is endpoint erasure, and Smith
  holonomy gives its exact validity condition: lawful only for tasks
  invariant under the path. "What exists" descends to the endpoint;
  "why this and not the alternative / what was tried and killed / what
  breaks on revert" consume the path. So archive, never delete —
  Slack archiving retains search and resolving permalinks
  (losslessness) at zero attention cost. Closing discipline: a channel
  closes with a **terminal yield message** (what landed, what died,
  what it unlocked, artifact links) — a yield-less walk is unfinished;
  and the vigil flags task channels silent for N weeks with no
  terminal message (the stale-claim rule) — unclosed-and-silent is the
  one state not allowed to accumulate. Closure is an authored act,
  never automatic.
- **Unbounded graph, bounded frontier.** Unbounded channels are not a
  problem for the graph (search + liberal links keep the archive
  navigable); they are only a problem for human perception, which is a
  small live working set. Each human's sidebar shows the standing
  dimensions + task channels with an open action of theirs + chosen
  watches; everything else is reachable but not displayed. Nobody
  curates anyone else's frontier — different observers' quotients
  "differ without contradiction" (ACTIVE_OBSERVER_DESIGN); the
  system keeps the whole lossless, each mind chooses its own cover.
  The per-recipient cursor digest (§3.4) covers what moved off-frontier.
- **Predicted emergent structure:** a shallow stable dimension layer, a
  churning power-law population of task channels, threads as default
  subtask granularity, and the channel index (open / owner / stale) as
  a *generated view* compiled from the channels — never a second
  hand-maintained board.

### 3.7 What each existing surface becomes

| surface | type (L1) | change |
|---|---|---|
| Slack | message plane | linking norm (§3.1), capture reaction (§3.2), vigil channel (§3.3) |
| brain/ (git) | assertion plane | unchanged in structure; gains permalink provenance + back-links; hygiene stays the review gate |
| Linear | generated view | restore the linear-contract as a *render* of the brain's L3/L4 layers; question-shaped tickets go back to the brain (the contract's own test); one live "now" surface, others render it (L3.1) |
| PRs/Greptile | execution receipts | unchanged; already the best-functioning loop |
| agents | observers with journals | roster + journal + resume; triggered by reaction, mention, GitHub event, or routine |

---

## 4. The minimal core (build order, each with its break-even)

1. **The linking norm + back-link habit** (§3.1). C ≈ 0 (a norm, not a
   build). Immediate.
2. **Capture reaction → brain PR → thread back-link** (§3.2). One agent
   flow. Fires on every decision-bearing thread; k_min ≈ a week of use.
3. **Vigil with 3 probes** (decision-no-artifact, LOG-currency,
   active-depends-on-terminal) (§3.3). Delta-only from day one.
4. **Journals + resume + cursors** (§3.4) — for agents first; humans
   opt in.
5. Everything else in §3.5 is culture: written once into the brain
   constitution, exercised or dead.

## 5. Deliberately not built (fail-closed, with reasons)

- **No statement-hash / event-chain claim registry.** The strongest
  mechanism in this corpus, and the one its own audit proved never
  fired. Crowdsurf at 3 humans is below the concurrency where the
  culture stops scaling. The design point is recorded so it can be
  installed when the forcing incident arrives (L10) — the trigger is
  the first silent post-approval edit of a decision that costs a week.
- **No universal summarizer / auto-digest of all channels.** Forbidden
  by L4 (no validated consumer) and L5 (order-dependence); the capture
  reaction is the human-validated alternative.
- **No scalar knowledge metrics** (doc counts, coverage scores).
  Provably uninformative (L7); the vigil's deltas and the link graph
  are the observables.
- **No auto-acting bots.** The vigil observes; acting is an agent's
  job, invoked by a person or a claimed routine — separation of truth
  authority from allocation (RESEARCH_SYSTEM §3).

## 6. Rigor boundary

**Proved in this corpus and used as proved:** relativized initiality
(L4); CRT boundary trichotomy (L2, as arithmetic); PM section-vs-cocycle
and its three corollaries (L3, as cohomology); leakage rank (L6, as
linear algebra); cache/option-value and submodularity results (L7);
break-even + horizon no-go (L8); control-indexed memory (L9);
commuting-compressions criterion (L5).

**Transported:** every application of the above to Slack/git/Linear
objects. The transport maps are stated inline; none of them is a
theorem about organizations. The corpus's own norm applies: these
analogies generated this design; they do not certify it.

**Hypothesis with falsifier:** that this minimal core, exercised by
this team, keeps the brain's compound-not-reset property as agent count
grows. Falsifiers, registered now: (a) the capture reaction goes unused
for two consecutive weeks while decisions demonstrably occur in Slack —
then the affordance is wrong, not the humans; (b) the vigil's
active-depends-on-terminal probe fires and is ignored twice — then
mechanism has outrun culture and should be *removed*, not enforced;
(c) a fact acquires two homes with an untyped copy and drifts — then
the linking norm failed and the registry tier (§5) gets its forcing
incident. Per kernel P0–P3: the next revision of this design must name
which of these (or what unforeseen incident) forced it.

**External evidence base:** `CROWDSURF_RESEARCH_BASE.md` (companion,
2026-08-13) surveys the 2024–26 orchestration, agent-memory,
organizational-science, skills, and infrastructure literatures; it
confirms L1/L5/L6/§3.2–3.4 against field evidence, sharpens §3.1
(~~annotated sparse links~~ corrected 2026-08-13, upstream: liberal
*authored* linking; only automatic unauthored backlinks are folklore),
and adds the
infrastructure constraints (event-time capture only; security must-dos).

**Prior art:** this document's own lineage is `avikj/math` itself —
PROTOCOL, MATH_OS, vigil, the field envelope, TWO_IDENTITIES — plus the
citsec linking culture as related practice. No claim of novelty is made
for any mechanism; the contribution is the derivation of *which*
mechanisms, *at what scale*, from theorems rather than taste.
