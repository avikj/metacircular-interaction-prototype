# Crowdsurf collective intelligence — external evidence base

**Status: literature/field survey (2024–2026), companion to
`CROWDSURF_COLLECTIVE_INTELLIGENCE.md`. Same consumer. Every claim below
is cited to a fetched source (evidence discipline: fetched, not memory;
all accessed 2026-08-13). Where the external evidence confirms,
sharpens, or contradicts a law in the design doc, that is stated
explicitly. Folklore is labeled folklore.**

---

## 1. What the outside evidence confirms about the design

### 1.1 Coordinate through artifacts, not conversation — independently converged

The strongest external convergence with this repo's file-based
coordination: the 2025–26 orchestration literature abandoned
peer-to-peer conversational agent swarms (where MAST's 36.9%
inter-agent-misalignment failures live; benchmark gains "often
minimal") in favor of **blackboard/stigmergy patterns** — shared
structured artifacts instead of messages. Practitioner reports find "a
shared markdown checklist beat sophisticated coordination protocols";
blackboard MAS papers report that "externalizing intermediate reasoning
artifacts … mitigates information fragmentation" (arXiv 2510.01285,
2510.18893). MAST itself (arXiv 2503.13657, NeurIPS 2025; 14 failure
modes over 1,600+ annotated traces) found messages get ignored and
withheld; artifacts persist. This is L1 ("messages coordinate;
documents assert") measured in the wild.

The two most successful agent labs published opposite doctrines in the
same week — Anthropic's multi-agent research system (+90.2% over
single-agent on breadth-first research) vs Cognition's "Don't Build
Multi-Agents" (parallel writes doomed by conflicting implicit
decisions) — and the resolution is exactly the read/write split:
**parallelize reads, serialize writes, partition writes along the real
dependency graph** (Co-Coder, arXiv 2606.00953: parallelism pays iff
the code's dependency structure permits it — L6's vanishing-leakage
condition, measured). Sobering constants: multi-agent costs 4–220×
tokens; ~80% of Anthropic's performance variance was raw token spend;
automated blame assignment in agent fleets identifies the responsible
agent only 53.5% of the time and the decisive step 14.2% (arXiv
2505.00212) — fleets are near-undebuggable, so provenance must be
written at act time, not reconstructed.

### 1.2 Presence ≠ use: the memory evidence

The design's forced-consultation and write-time-structure choices are
not optional politeness; they are the two mechanisms the memory
literature finds actually work:

- **Context rot is universal.** All 18 models tested degrade at every
  input-length increment, even on trivial retrieval (Chroma 2025);
  NoLiMa (arXiv 2502.05167): at 32K tokens, 10 of 12 frontier models
  fall below 50% of their short-context baseline once lexical-match
  shortcuts are removed; lost-in-the-middle position bias is 20–30
  points. "Just load the brain into context" is not an architecture.
- **Voluntary memory reads fail.** Claude-plays-Pokémon revisited a
  hazard dozens of times while consulting its notes <5; AI Village
  institutionalized a forced consolidation ritual every 40 actions;
  Claude Code's own CLAUDE.md adherence degrades past roughly 150–200
  instructions (IFScale, arXiv 2507.11538: 68% adherence at 500
  simultaneous instructions). Rituals that don't depend on the model
  remembering to remember — read-log-first contracts, session-end
  journal entries, scheduled consolidation — are the replicated fix.
- **One bad write is worse than no write.** "Experience-following"
  (arXiv 2505.16067): agents imitate retrieved records, so erroneous
  records propagate; selective write policies and curated deletion
  change downstream success. Memory poisoning (MemoryGraft, arXiv
  2512.16962) launders untrusted input into trusted memory —
  **provenance on every memory record** and temporal validity
  (Zep/Graphiti-style supersession edges) are the architectural
  answers. This is the strike-through/supersedes discipline, measured:
  corrections must be visible state transitions, not overwrites.
- **Compaction loses the *why*.** Summaries-of-summaries degrade
  (Factory.ai; Codex team traced decline to recursive summarization);
  structured sectioned handoffs beat freeform. L5's replay-pointer rule
  (keep the permalink to ground truth at every compression stage) is
  the countermeasure.
- Memory-system benchmark numbers are vendor-contested (the Zep–Mem0
  LoCoMo dispute; an audit found 6.4% of LoCoMo's answer key wrong and
  its LLM judge accepting 63% of intentionally wrong answers). Do not
  buy a memory system on benchmark numbers.

### 1.3 The organizational-science verdicts (labeled)

- **Transactive memory (who-knows-what) — REPLICATED**, r≈.4 with team
  outcomes across two meta-analyses (Fausett 2026, 44 studies; Bachrach
  2019, 76 studies). The best-evidenced knowledge structure is an
  **index with pointers** — who/which-doc is authoritative — not
  exhaustive prose. The brain's single-home rule is a TMS externalized.
- **Recorded priors — REPLICATED, large effects.** Good Judgment
  Project: <1 hour of debiasing training improved forecast accuracy
  ~10%/year sustained; superforecasters beat analysts with classified
  access by ~30% Brier. This is the only decision-record practice with
  replicated large effects — the design's forecast-with-every-claim
  rule (PROTOCOL §4 upgrade 1) has the strongest external evidence in
  this entire survey.
- **Backlink magic — FOLKLORE, but scope the claim precisely**
  (corrected 2026-08-13 after upstream review; the first version of
  this bullet over-generalized to "sparse links"). What the evidence
  actually indicts is **automatic, unauthored** linking: no controlled
  study shows Roam/Obsidian-style auto-backlinks improve retrieval or
  creativity, and the Zettelkasten community's own flagship analysis
  argues *context-free* links dilute the graph; "lost in hyperspace"
  overload is replicated for readers navigating link-dense *hypertext
  documents* without maps. None of this applies to **authored links in
  a conversational stream**, where the surrounding sentence is the
  annotation and each link is a deliberate assertion of noticed
  relevance — the citsec practice. There the correct policy is
  **maximally liberal authored linking**: each link is a knowledge
  write at near-zero cost, adds a navigable edge alongside search, and
  the disorientation literature's mitigation (stable maps/hierarchy)
  is already supplied by the brain's pillar structure. The rule that
  survives: links are authored by a mind that noticed the connection,
  never generated by string matching — the distinction is authorship,
  not density. And a link need not carry an asserted relation at all
  (second upstream refinement, 2026-08-13): plain reference — "look at
  this →" — is already the valuable move, because it replaces
  paraphrase (a fresh lossy compression the reader must unpack) with
  the literal expression. Reference by pointer is lossless; reference
  by re-description is a quotient with an unaudited kernel. This is
  the design doc's L5 replay-pointer rule extended to all reference.
- **Doc rot attacks references, not prose — MEASURED.** 19.2% of docs
  in top-1000 GitHub projects carry ≥1 outdated code reference, stale
  an average 4.7 years (arXiv 2212.01479). Freshness checks belong in
  CI where the referenced artifact changes, not on a review calendar —
  the vigil's LOG-currency probe is the right shape.
- **Duplication = retrieval failure — REPLICATED** (Stack Overflow
  duplicate studies): people re-ask what exists because vocabulary
  differs. Monitor re-asked questions in Slack as the staleness/
  retrieval alarm.
- **Collective-intelligence c-factor — CONTESTED** (Bates & Gupta
  failed to replicate; Riedl 2021, 1,356 groups: weak factor, and
  **collaboration process > individual skill > composition**). Don't
  build on "smart teams"; build on process.
- **Conway mirroring — REPLICATED as correlation** (~70% within-firm,
  Colfer & Baldwin, 142 studies) with the design-relevant exception:
  open-source escapes it via a fully transparent shared artifact. For
  3 founders + agents, the shared written substrate is what lets a tiny
  communication graph support a large system.
- Amazon memos / Google design docs / Stripe writing culture: PRIMARY
  ACCOUNTS, mechanism-consistent with the process findings, but
  unmeasured — carry as practice, not as evidence.

### 1.4 Skills: the procedural-memory evidence

- Curated skills work unevenly and **where model priors are weak**:
  SkillsBench (arXiv 2602.12670): +16.6pp average, spread +4.5pp
  (software eng) to +51.9pp (healthcare); 16/84 tasks got *worse* with
  skills. **Self-generated skills add ~nothing on average** — curation
  is human work (Voyager's ablation: without self-verification, buggy
  procedures accumulate — uncurated libraries get worse, not better).
- **The scaling failure is wrong-skill selection, not tokens**: −21%
  at 202 skills from *shadowing* among look-alike skills (arXiv
  2605.24050), while pure context overhead was statistically nil.
  Enforce non-overlapping scopes; merge look-alikes.
- Models **undertrigger** by default: the description (function +
  explicit "use when" + user vocabulary, slightly pushy) is the whole
  triggering mechanism; test with ~20 trigger/near-miss queries.
- Budget hierarchy with numbers: always-loaded context degrades past
  ~150–200 instructions → universal rules only in CLAUDE.md;
  machine-checkable rules → hooks/lint (spend zero attention);
  situational workflows → skills (progressive disclosure, ~30–100
  tokens dormant); facts → retrieval. The checklist literature
  (WHO surgical checklist: deaths −47%) says why the skill pattern
  works: short, run at a defined pause point, verified.

## 2. Corrections and sharpenings to the design doc

1. **§3.1 linking norm, sharpened**: links must be *annotated* (state
   the relation) and sparse; auto-backlinking is explicitly
   evidence-free and plausibly harmful. The citsec property to
   replicate is the *citation culture*, not a backlink graph.
2. **§3.2 capture channel, confirmed with a graveyard lesson**: capture
   tools die when they demand a new writing ritual and lack a
   guaranteed reader (Friday.app and the standup-bot consolidation).
   The reacji capture survives both tests: the gesture already exists,
   and the back-link into the thread plus the vigil are the guaranteed
   read-path. **Add**: the answer-back path — when a captured decision
   is later relevant, an agent cites it back into live conversation;
   knowledge that never returns to the flow is dead.
3. **§3.3 vigil, extended**: add the duplication probe (same question
   re-asked in Slack ≈ retrieval failure) alongside LOG-currency.
4. **§3.4 journals, confirmed against measured failure**: session-end
   structured handoffs (sectioned: decisions/open items/next action)
   are the measured countermeasure to compaction loss; forced
   read-before-work is the countermeasure to voluntary-consultation
   failure. Add provenance + supersession fields to any agent memory
   record (anti-poisoning, anti-staleness).
5. **§5 "no universal summarizer", now evidence-backed twice**: L4's
   no-validated-consumer argument plus recursive-summarization
   degradation. Slack AI's native summaries are fine as *ephemeral*
   reads; they must never become the stored record.
6. **Multi-agent restraint, quantified**: fan out only breadth-first
   reads; serialize writes; expect 4–220× token cost when parallel;
   write provenance at act time because post-hoc blame assignment is
   near-chance.

## 3. Infrastructure facts that constrain the build (mid-2026)

- **Off the shelf now**: Claude Tag (persistent shared Slack teammate,
  channel memory, staged tasks — GA June 2026); Slack first-party MCP
  server + Real-Time Search API (GA Feb 2026); Linear for Agents
  (delegate issues to agents; AgentSessionEvent webhooks, session
  lifecycle states); GitHub claude-code-action / Copilot coding agent
  (issue-assignment → draft PR); reacji as a first-class Workflow
  Builder trigger (`reaction_added`).
- **Build**: the cross-tool spine (Slack thread ↔ brain doc ↔ Linear
  issue ↔ PR, keyed by permalinks + Slack message metadata), the
  event-time capture flow, the vigil, and the idempotent event
  pipeline. No vendor ships this spine across all three tools.
- **Hard limit shaping the design**: since May 2025, non-Marketplace
  distributed Slack apps get 1 req/min · 15 messages/req on
  `conversations.history`/`replies` — **retroactive backfill of Slack
  is dead; capture must be event-time streaming, via an internal app
  (exempt) or Slack's own RTS/MCP APIs.** Standard export covers
  public channels only. `chat.getPermalink` is Tier-4 (permalinks as
  durable keys are cheap); posting ~1 msg/sec/channel.
- **Reliability pattern** (both Slack and GitHub webhooks are
  at-least-once, GitHub without auto-redelivery on hard failure):
  ack-fast → durable queue → idempotency key (event_id / delivery
  GUID) → per-resource cursor → periodic reconciliation sweep. The
  per-recipient cursor design in §3.4 of the design doc is the same
  pattern the field converged on.
- **Security is not optional**: prompt injection via issue/PR/comment
  *content and titles* is field-proven (RoguePilot repo takeover,
  Clinejection npm compromise ~4,000 machines, PR-title injection
  leaking CI keys from three vendors' actions). Must-dos: treat all
  Slack/GitHub/Linear content agents read as untrusted; least-privilege
  short-lived tokens per surface (GitHub App per-repo, Slack granular
  bot scopes, Linear actor=app) — never one token spanning all three;
  draft-PR-only output with human merge gate; authorized-human trigger
  gating; sandboxed runners with egress control; log every tool call.

## 4. Net effect on the build order (design doc §4)

Unchanged in structure; sharpened in detail:

1. Linking norm — maximally liberal *authored* linking (density is
   virtue when every link is an assertion; see §1.3 correction); the
   pillar hierarchy supplies the map.
2. Capture reaction — event-time (never backfill), internal app,
   provenance permalink + human named + supersession field, back-link
   on merge, **plus the answer-back path**.
3. Vigil — probes: decision-no-artifact, LOG-currency (CI-anchored to
   referenced artifacts), active-depends-on-terminal, duplication
   (re-asked questions). Delta-only.
4. Journals/cursors — structured session-end handoff template;
   idempotent event pipeline underneath.
5. Skills — start near-empty; admit a skill only with an eval beating
   the no-skill baseline; non-overlapping scopes; hooks for anything
   machine-checkable; keep always-on context under the ~150-instruction
   ceiling (the surf-app CLAUDE.md is already near it — prune when
   adding).

## 5. Source index

Orchestration: anthropic.com/engineering/multi-agent-research-system ·
anthropic.com/research/building-effective-agents · arXiv 2503.13657
(MAST) · 2505.00212 (blame attribution) · cognition.com/blog/dont-build-
multi-agents · blog.langchain.com/how-and-when-to-build-multi-agent-
systems · 2606.00953 (Co-Coder) · 2510.01285, 2510.18893 (blackboard).
Memory: trychroma.com/research/context-rot · 2502.05167 (NoLiMa) ·
2410.10813 (LongMemEval) · 2505.16067 (experience-following) ·
2512.16962 (MemoryGraft) · 2604.11978 (HORIZON) · LessWrong Claude-
Pokémon analyses · theaidigest.org/village · factory.ai/news/evaluating-
compression · anthropic.com/engineering/effective-context-engineering.
Org science: Riedl PNAS 2021 · Fausett 2026 & Bachrach 2019 (TMS metas)
· arXiv 2212.01479 (doc rot) · MSR 2016 (SO duplicates) · ICSE 2016
(turnover loss) · GJP/aiimpacts (forecasting) · Colfer & Baldwin 2016
(mirroring) · zettelkasten.de/posts/backlinks-are-bad-links.
Skills: platform.claude.com Agent Skills docs · claude.com skill-creator
blog · 2602.12670 (SkillsBench) · 2605.24050 (shadowing) · 2507.11538
(IFScale) · Voyager · 2409.07429 (AWM) · WHO checklist (Harvard Chan).
Infra: slack.com/blog (MCP+RTS GA) · docs.slack.dev changelog
2025-05-29 (rate limits) · linear.app/developers/agents ·
github.com/anthropics/claude-code-action · CSA notes on agent
confused-deputy and AI GitHub Actions · Bitrise Kolega write-up.
