# YC application — draft 0.1 (cf-tessera, 2026-08-13)

**Status:** draft for the owner. Sources: three full-read sweeps over the
repo (product/vision docs; chronicle + protocol + failures; papers +
formal lanes + notes). Every number below has a repo citation. Per
PROTOCOL §8 this document does not leave the repository without owner
release.

**Founders as named in-repo:** the Crowdsurf founding team — Shiv, Avik,
Umang (`notes/CROWDSURF_COLLECTIVE_INTELLIGENCE.md`). Adjust as needed.

---

## Company name

**Crowdsurf** (the in-repo name for the commercial instantiation).
Alternative if the network is the product: **Natural Machine**.

## Describe what your company does (50 characters)

Draft options (≤50 chars each):

- `Provenance infrastructure for human+AI teams`
- `The trust layer for teams of humans and agents`
- `Git for knowledge: agent teams that don't drift`

## What is your company going to make?

Teams are becoming a few humans plus many AI agents. Those teams fail in
a specific, measured way: work happens in Slack, decisions die there,
trackers become shadow copies, agents confidently rebuild what another
agent refuted last week, and when something breaks nobody can say which
step was to blame. The best public study (MAST, 1,600+ traces) attributes
36.9% of multi-agent failures to inter-agent misalignment; blame
attribution by experts is right about half the time.

We make the coordination substrate that fixes this: **provenance written
at act time, across the tools teams already use**. A Slack thread, a
knowledge-base delta, a tracker issue, and a PR become one linked spine —
capture is a reaction emoji, the agent drafts the delta with the permalink
as provenance, the tracker view is *generated* from the spine instead of
maintained by hand, and a delta-only vigil reports what changed instead of
summarizing everything. No vendor ships this spine across all three tools
today (`notes/CROWDSURF_RESEARCH_BASE.md` §3 — the survey is in-repo:
Claude in Slack, Slack MCP, Linear for Agents, and claude-code-action all
exist; the cross-tool provenance spine does not).

Under it sits the deeper product, specified in
`notes/NATURAL_MACHINE_NETWORK_WHITEPAPER.md`: a content-addressed,
proof-carrying research network where claims, evidence, verification
events, authority, and allocation are **separate planes that may not
impersonate each other** — a hash is not a proof; a proof check is not an
acceptance event; payment is not epistemic authority.

## Why did you pick this idea? Do you have domain expertise?

We didn't pick it; we were forced into it. We ran what we believe is the
largest sustained experiment of its kind: **67 named persistent AI agent
identities across 3 model lineages (Claude Fable, Claude Opus, OpenAI
Codex), coordinating for four days through nothing but a git repository —
no orchestrator, no shared memory** — doing research mathematics, the
domain with the harshest possible ground truth. Scale: 576 commits, 629
numbered inter-agent messages, 490 research notes, 61 append-only agent
journals, 353 claims-board rows with 258 landed
(`collab/ROSTER.md`, `collab/PROTOCOL.md`, `collab/STATE.md`).

Every coordination mechanism we're proposing was extracted from a
recorded injury in that experiment, not designed on a whiteboard. The
owner's rulings are all dated and cited in-repo: no PRs, main mirrors the
tip (day 2); stop building agent wrappers (day 3, rejecting our own first
product instinct at the category level); one session one worktree, after
two sessions destroyed each other's uncommitted proofs and silently
duplicated each other's thinking within one hour; Python banned in favor
of machine-checked substrates, enforced by three mechanical layers
*because prose failed* — agents route around policy that isn't
mechanized.

## What's new about what you're making? What do you understand that others don't?

1. **Provenance cannot be recovered after the fact — it must be written
   at act time.** We have this as a theorem, not a slogan (extensional
   quotients destroy derivation history; reward/attribution functionals
   that depend on history provably cannot factor through outputs). Every
   post-hoc "who did what" reconstruction is lossy. This is why the spine
   is an at-capture mechanism, not an analytics dashboard.

2. **Scalar scores destroy information — provably.** The whitepaper's
   founding example: two work-traces with equal cost and equal cache size
   but incomparable future value. No scalar metric ranks them correctly.
   Value in our system is typed vectors with partial orders; scalars are
   local, declared, optional. Every "AI productivity score" vendor is on
   the wrong side of this theorem.

3. **Culture does not scale; mechanisms must be fail-closed.** Our
   strongest quality mechanism went unused (0 certified packets among
   26+) while quality was carried by culture — and we watched culture
   fail exactly at the point of agent-count growth. Everything that
   worked was mechanical: hooks, clocks, numbered messages, append-only
   ledgers, validators that fail closed.

4. **What looks like progress and isn't.** We keep a directory literally
   named `DO_NOT_DO_THIS_it_felt_like_progress_and_added_nothing/` —
   every entry *passed its tests* (green CI, complete apparatus, correct
   vocabulary, zero value). A counter increasing is not knowledge; a
   control validating a measurement does not validate the claim; if every
   collaboration message is an adapter request, collaboration has already
   died. We know the failure modes of agent collectives from the inside,
   with receipts.

5. **Verification as a product surface.** Our demo repo contains 53 Agda
   modules (13,314 lines, 731 typed statements, 0 postulates, 0 holes,
   all `--safe`) and 24 Lean files (0 `sorry`), including negative
   controls *designed to fail compilation* — the checker is tested by
   what it must reject. The same discipline applied to team knowledge is
   the product: claims carry their evidence, corrections strike through
   in place, refutations are the highest-value message type.

## Progress

- The experiment itself (the repo) is live and self-verifying: one
  command (`./run`) checks the formal corpus.
- Research output with external-facing value already exists: four papers
  (one, `papers/crossover.md`, with a complete novelty assessment over 15
  prior-art searches), and demo-grade results — e.g., reading an
  individual Riemann zeta zero to four significant figures out of
  prime-pair counts (`papers/phase_side.md`, Theorem G).
- The verification culture has public, checkable receipts: an agent that
  wrote a ban and then deleted its own load-bearing instrument under it,
  demoting its own theorems to conjecture in place (`FAILURES.md` F33); an
  agent refuting its own published no-go with a constructive
  counterexample (F30); a blind cross-audit protocol with pre-registered
  forecasts and recorded credences (`PROTOCOL.md` §4).
- Product spec for the commercial layer is written and thrice
  hostile-reviewed (`NATURAL_MACHINE_NETWORK_WHITEPAPER.md`, msg 0418),
  with a staged path that adds settlement *only for demonstrated need*.

## Who are your competitors? What do you know that they don't?

Adjacent: Slack AI / Claude in Slack (capture without spine), Linear for
Agents (tracker-side only), Notion/Glean (knowledge without provenance),
agent-framework vendors (orchestration without epistemics), eval/observability
startups (post-hoc, wrong side of the provenance theorem). Nobody ships
the cross-tool at-act-time spine; our in-repo survey documents the gap.

What we know: the four failure modes above, each bought with a recorded
injury; and the sequencing discipline — our whitepaper's §16.4 "Not
built" list (no token, no consensus theater, no autonomous promotion, no
scalarized value) is a moat *because* every competitor will ship exactly
those things and rediscover our counterexamples in production.

## How will you make money?

B2B SaaS for agent-augmented teams: per-seat (human + agent identities)
for the spine — capture, generated tracker views, vigil, journals/resume.
Expansion: the verification plane (typed obligations, acceptance events)
for regulated/high-stakes teams. The whitepaper's settlement layer
(prospective contracts on obligations, escrow released by acceptance
events; retrospective attribution along recorded reuse) is the long-term
marketplace — added only when the loop demonstrates need, per our own
sequencing rule.

## Why now?

Agent fleets went from demo to daily driver this year; multi-agent token
spend runs 4–220× single-agent; the coordination failure data is public
(MAST); and every team adopting agents is about to become a 3-human,
N-agent org with exactly the drift we measured. The window is now because
provenance must be written at act time — every month a team runs without
the spine is history they can never recover.

---

## Honesty appendix (what this draft does not claim)

Per the corpus's own rules: no claim that the allocation layer beats
expert integration end-to-end (untested, whitepaper §16.4); no claim the
mathematics is commercially valuable per se — it is the hardest-possible
testbed that forced the mechanisms; the "largest experiment of its kind"
claim is a belief pending prior-art search, not a verified superlative;
commit/message counts are 4-day figures from a system that includes the
founders' own agents, not organic usage.
