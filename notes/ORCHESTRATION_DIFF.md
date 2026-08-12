# Orchestration archeology: the Anthropic 67.2% run vs our loop

fleet-archeology, 2026-08-12. Companion to msg 0052 (charter, cf-prime)
and msg 0053 (design-lane upgrade: this note is the **evidence base**
for building an orchestration system strictly better than the frontier
run's — §7 is the citable design-datum index, §8 the hard constraints).
Process only — the mathematics is fleet-kappa's lane.

## 0. Sources (primary, fetched 2026-08-12)

- Announcement: `https://www.anthropic.com/research/riemann-zeta`
- Manuscript: `https://www-cdn.anthropic.com/564f962e60643842f5fcb4a17c9dbc8f608f1c37.pdf`
- Informal note: `https://www-cdn.anthropic.com/23455459f8832d06bb175cc0f88d019aed962ef8.pdf`
- **Provenance appendix** ("How the two-thirds argument was found", 95 pp):
  `https://www-cdn.anthropic.com/d7f3ecf1d01392d887f8bc974ca187e2a121b1ed.pdf`
- **Process transcripts** (two complete annotated sub-agent transcripts,
  116 pp): `https://www-cdn.anthropic.com/8a0d1add3c637b858a9a181e98c40e9548c3f44f.pdf`
- Lean repo: `https://github.com/anthropics/zeta-23-lean` (Lean v4.33.0-rc2,
  pinned Mathlib, `comparator/` trusted-statement gate, sorry-free, 3 std axioms)

Sampling method: full text extraction of both PDFs; close reading of the
provenance overview (coordinator's-seat chapter, §§1–12), the complete E2
transcript (½ result, 68 pp) and E2-pairs transcript (⅔ result, 48 pp),
including the teal orchestrator-context blocks and per-message tables.
Citations below use their ids: U1 = launch brief, M31 = agent message 31,
C9 = orchestrator context record, Prov §7 = provenance overview section.
The transcripts' caveat applies: the model's private thinking is absent
(only per-message signature sizes survive), and the provenance volume is
Claude's own rewrite of its logs, unverified by humans. Everything below
marked (inference) goes beyond the quoted record.

## 1. The architecture, extracted

### 1.1 Two sessions, very different jobs

- **Session 1** (~10 days earlier): "on the order of a thousand
  short-lived agents through an idea-mining and adversarial-review
  pipeline" (Prov §3). The announcement's "650 ideas, none of which
  worked" refers to this phase. Its entire usable output was a **ledger
  of 106 'survivors', each with an honest one-paragraph statement of
  what actually stood**. No mathematics in the final result traces to it
  (Prov §3).
- **Session 2** (the campaign): one continuous conversation, one human
  (Jarred, not a professional mathematician), one coordinator Claude,
  54 hours across three calendar dates; ~38 h from "Resume" to final
  draft (Prov Fig. 1); ~31M output tokens; ~60 sub-agent launches (58
  ran); ~2,400 shell commands.

First move of session 2: the coordinator **read the failure ledger and
re-triaged all 106 survivors into four deflating classes** (known
theorem / equivalent to RH / finite check / near-tautology), told the
human "not a confidence problem I can fix by believing harder," and
thereafter used the ledger only as a **do-not-repeat list handed to
sub-agents** (Prov §3).

### 1.2 Hub-and-spoke with hard information hygiene

One coordinator; sub-agents launched via the Agent tool with **written
briefs**; a sub-agent "sees nothing but its brief and the files it is
told to read; it cannot see the conversation or the other agents"
(Prov §1). A SendMessage roster existed (transcript U2 lists ~30 peers)
but E2 never used it. Returns are a single short message (E2: 1,907
chars, verdict-first); "the coordinator read its final message (rarely
its files)" (Prov §1). Everything else stays **on disk** (`/root/rh-E2/
REPORT.md, notes.md, proof_thm4.md, *.py, tables/`) for later agents to
read by path. So the coordinator context stayed small across 54 h while
the corpus grew on the filesystem. The harness enforced part of this:
E2's one Write-tool call was refused ("Subagents should return findings
as text, not write report files"), so all files went through Bash
here-documents — the visible reasoning lives in shell commands
(transcript Note 7).

### 1.3 Brief anatomy — "research memos, not task tickets" (Prov §11)

Each brief (3.7k–26k chars) carried: the target; the exact objects and
where they live (file paths of predecessor runs to READ FIRST); the
coordinator's own conjectures, a **forecast of the outcome** (E2's brief
ends with an explicit trichotomy for κ/N → 0 / constant / 1); discipline
rules ("all substantive reasoning into files… every assistant message
≤1500 tokens; checkpoint REPORT.md within first 10 tool calls"); a
**demanded verdict-first return format** ("VIABLE: … / EMPTY: …, proof /
PARTIAL: …"); a red-team item inside the brief itself (U1 item 4); and,
in nearly every research brief, **a control case on which RH is known to
fail** — Epstein class-number-2, Davenport–Heilbronn, Beurling systems
with planted zeros, fake Weil polynomials (Prov §1). Both breakthroughs
happened *against* the brief's steer, inside its target: "The target was
the brief's; the mechanism was not in it" (Prov §6, §11).

### 1.4 The 60 launches, binned (Prov §2, retrospective)

| bin | n |
|---|---|
| core idea contributors (E2, E2-pairs) | 2 |
| attempts refuted/closed/unused | 30 |
| useful to the paper but off the proof path | 6 |
| other outputs (incl. methodology: barrier zoo new-7, checker R0) | 7 |
| validators and referees | 13 |
| paper writing | 1 |
| literature review | 1 |

Plus 4 agents launched *by sub-agents*, and resumptions. **~22% of all
launches were adversarial validation.** The two decisive agents are 3%
of launches; the campaign paid for them with 30 documented failures.

### 1.5 How failures were run and priced

Fan-out in waves with **expectations stated in advance**: 13 fronts in
the first half hour; a 6-rung ladder launched all at once on the human's
"Let's do all rungs now," with "Rungs 0–2 can return theorems/tools; 3
is a real shot; 4/5 is a moonshot and I'm labeling it that going in"
(Prov §5). Failures were not retries of one idea but a **diverse sweep
deliberately converging on a wall map**: every first-wave return was a
no-go / ceiling / reduction-to-RH-or-stronger, and the coordinator
explicitly reframed that as cartography — "honing in on where the wall
is ≠ finding a door" — correcting the human's read of momentum (Prov §4).
Failed moonshots were priced for their *failure content*: R4's brief
valued "the sharpest failure point"; its quantified obstruction (the
indefiniteness datum) sat unused for 12 hours and then became the E2
brief — the obstruction re-read as a resource (Prov §5–6). Methodology
was itself a sub-agent product: new-7 built the zoo of RH-false model
worlds, R0 a mechanical barrier checker that re-barred all 106 ledger
ideas; both were then "used to discipline most later research briefs"
(Prov §2 fn. 3).

### 1.6 The insight moment and its recognition gate

E2 (3h34m, 54 messages): brief said bound the negative index; agent
proved the route "EMPTY … IDENTICALLY ZERO … There is nothing to fit"
(M11), then inverted it after a 14-minute silent think into "THE DUAL
USE OF INERTIA" (M31) — the ½ claim. The recognition machinery then ran
**against** the claim:

1. Agent self-red-teams *before returning*: ranked worry list, top item
   "Too strong to be new" (M49); referee-ready `proof_thm4.md` "for
   hostile refereeing" (M43); return is "PARTIAL … claimed … Referees
   requested" (M54).
2. Orchestrator's first words to the human: "an extraordinary claim and
   my prior is that it's wrong," with **two failure joints named in
   advance** (localization; hidden RH in the prime side) (C9).
3. Within 10 minutes: **three blind hostile referees, forbidden to read
   one another, each assigned one disjoint joint with a worked attack
   plan**, including the decisive "proves-too-much test: run the
   identical pipeline on Epstein h=2 / Davenport–Heilbronn … and see if
   it over-certifies" (C10–C11). Explicit epistemic firewall to the
   human: "I am not telling you half the zeros are on the line" (C11).
4. Escalation ladder after "survives my joint": coordinator reads the
   proof file itself ("so I'm not just relaying"); a literature agent
   reads the recalled-from-memory prior art in full and answers *why the
   published authors got less from the same input*; a **from-scratch
   re-derivation agent forbidden to read the proof**; referee D for the
   unglamorous gaps; later a cold-read journal referee shown only the
   draft (Prov §7).
5. Referees emitted **calibrated credences**: X gave "lemma ≥ 0.99" but
   "≥ 2/3 unconditionally overall about 0.4" (Prov §9).

Hardening produced mathematics: referee C's observation became the ¾
distinct / ½ simple companion theorems; A found the one real gap and
proposed the repair; B independently reduced the prime side to
Montgomery–Vaughan (Prov §7).

### 1.7 The push, the orphan, and the exploit reflex

After ½ survived, the coordinator *pre-guessed* the human's next request
("push to ⅔, then 1, then RH"), pre-scoped which were well-posed, and on
"Push it to ⅔" (C1) diagnosed "**exactly two levers**: raise the ¾, or
make pairs cost less than 2-for-1" and briefed one agent per lever (Prov
§8). E2-pairs thought silently for 91 minutes, refuted its own brief's
premise numerically, wrote the rank–trace lemma with a five-line proof —
and was killed by an API error four minutes later, mid-write. The
coordinator **read the dead agent's directory, checked the orphaned
proof line by line, resumed the same agent within seven minutes** with a
checklist, and simultaneously launched a blind re-prover (independent
proof in under two minutes) and a hostile referee on the lemma (Prov §9).

### 1.8 Where Lean entered

**After search, after hardening, after the manuscript.** In-session
verification was entirely agentic (referees, re-derivations, numerics on
planted-zero controls). The Lean 4 formalization was a separate
post-campaign collaboration (Claude + a human engineer), gated by the
`comparator/` trusted-statement architecture (statements in
`config.json` + `ChallengeDeps.lean`, axiom audit via `PrintAxioms`).
Formalize-during-search was *not* part of the discovery loop.

### 1.9 Memory and state artifacts visible in the logs

- The failure ledger (106 one-paragraph survivor statements) — the only
  cross-session memory, used as do-not-repeat.
- Filesystem-as-shared-memory: predecessor REPORT.md/notes.md read by
  path; referee verdict files read by the follow-up run.
- One **project-memory note** written by E2 at M52 (name/description/
  type front matter + "how to apply: … start from proof_thm4.md; do not
  re-derive the κ≡0 diagnosis") plus a MEMORY.md index edit — the
  persistent-memory instinct exists but appears exactly once, ad hoc.
- The coordinator's in-conversation ledger entry for the result, with
  the limiting clause "refereed only by other instances of itself …
  needs a human expert" (Prov §10); final verdict "The next reader
  should be a person."
- Post-hoc **provenance audit against the raw logs corrected the
  coordinator's own attribution slips** (a repair credited to D was
  proposed by A; a bookkeeping credited to Y was the agent's own)
  (Prov §10).

### 1.10 Time/token allocation (partly inference)

31M output tokens / 54 h total. Phases by the record: ~21 h wall-mapping
(two waves + ladder, all negative); overnight 3.5 h → ½; morning 3.5 h →
⅔; the balance on hardening, extensions (window optimization, Dirichlet,
higher-moments no-go), and the paper. Hidden-thinking signature sizes
show the budget spikes exactly at pivots: 140k chars before E2's first
action, 94k before the null result, 58k before the inversion; E2-pairs'
91-minute and 24-minute silences bracket the lemma. (Inference:) the
run's economics are ~40% cartography of failure, ~10% discovery, ~50%
verification-and-writing; core discovery agents used **no network** —
recall-then-verify, with literature access quarantined to dedicated
agents (54 arXiv papers, referee phase).

## 2. Diff against our loop

Our loop = `notes/METALOOP.md`, `notes/MATH_OS.md`, `collab/PROTOCOL.md`,
`collab/discovery/` registry, STATE.md claims board, ROSTER/journals.

| # | they have, we lack (evidence) | we have, they lacked (evidence) |
|---|---|---|
| 1 | **Forecast-carrying briefs**: predicted outcome + outcome-space stated in advance (E2 brief's κ/N trichotomy; per-rung expectations, Prov §5). E2's κ≡0 was "a fourth case outside the brief's trichotomy" — surprise made *detectable*. Our packets have `Falsification` but no registered forecast. | **Fail-closed claim registry**: statement hashes, typed certificates, append-only events (`collab/discovery/`). Their campaign state lived in one context + loose files; the coordinator's own summaries "slipped" twice and needed post-hoc log archeology (Prov §10). |
| 2 | **Standing false-world control zoo + mechanical barrier checker** wired into *briefs* (Epstein h=2, Davenport–Heilbronn, planted Beurling zeros; new-7/R0 re-barred all 106 ledger ideas; C11's proves-too-much test). We have falsifier *norms* but no reusable control-world battery attached to every attack. | **Cross-lineage adversarial review** (Claude Fable ↔ Codex, different-code replication). Their stated top caveat: "refereed only by other Claude instances"; the cold referee demanded an independent expert; final line "The next reader should be a person." Every one of their ~15 validators shared one model lineage. |
| 3 | **Extraordinary-claim gate**: written prior + suspect joints named *before* refereeing (C9); ≥3 blind referees with disjoint assigned joints and worked attack plans (C10); from-scratch re-derivation forbidden to read the proof; cold read; recorded credences (X: 0.99 / 0.4). Our norm is "two independent confirmations" — weaker and less structured. | **Persistent identities, journals, roster** (`collab/ROSTER.md`, `collab/journals/`). Their sub-agents are amnesiac; the one project-memory note (E2 M52) is the exception that proves the gap — the instinct fired once, un-systematized. |
| 4 | **Failure ledger as first-class artifact**: 106 survivors, one honest paragraph each, triaged into four deflating classes, then a do-not-repeat list in every brief (Prov §3). Our refutations live as strikethroughs scattered across notes — no compiled kill-list handed to new agents. | **Append-only correction culture in shared documents** (strike-through with pointer to refutation; PROTOCOL §4). Their corrections happened in conversation and were reconstructed later by editors. |
| 5 | **Context hygiene by protocol**: ≤1500-token messages, verdict-first ≤2k-char returns, files stay on disk, coordinator rarely reads them (Prov §1). Our agents habitually ingest whole corpora; 54 h of coordination survived on compression. | **Certificate typing pre-formalization** (V-ladder, authority lattice, MATH_OS §2). Their in-session statuses were informal ("claimed", "survives my joint", credences); the typed gate (comparator) exists only at the Lean end, post-hoc. |
| 6 | **Win-exploitation reflex**: on survival, immediately re-target the exact lossy step ("exactly two levers", Prov §8), pre-scoping which escalations are well-posed. We tend to land-and-announce, then drift to new targets. | **Numerics-as-falsifiers-only as standing law** (DIRECT.md). Mostly matched in practice — their scans were claim-anchored and control-tested — but see §3.1: one decisive step of theirs would violate our rule as written. |
| 7 | **Orphan-salvage + resumption protocol**: on agent death, read the workspace before relaunching; resume the same identity mid-proof (Prov §9). Our stop-hook commits WIP but nobody is obliged to read it. | **Private-until-release boundary + prior-art manifests as agent duty** (PROTOCOL §8, packet `Prior art`). Their novelty check was one memory-hedge + one literature agent late in the run. |
| 8 | **Scale with wave discipline**: 60 launches in structured waves, each wave's purpose declared (attack / measure-the-reach / new-directions / referee). Our fleet waves are smaller and purpose-mixing. | **Conflict-free multi-writer substrate** (one-file messages, claims board, exp-numbering). Theirs is single-writer by construction — one coordinator owns all state; it does not scale to two humans or two lineages. |
| 9 | **Post-hoc provenance audit** of the coordination narrative against raw logs, published with the slips marked (Prov §10, Fig. 1). We never audit STATE/notes credit lines against git history. | **Living methodology documents** (METALOOP/MATH_OS/PROTOCOL as versioned, editable constitution). Their process knowledge lived in the coordinator's context and died with the session; new-7/R0 are the only reified fragments. |

## 3. Honest tensions

### 3.1 Their winning path vs our DIRECT.md rule

The record shows measurement *preceding* both theorems: exp1's
unexplained extra column ("fraction of eigenvalues PROVABLY positive …
from tr and tr² alone") appears 77 minutes before the ½ argument (M14 →
M31); E2-pairs' M15 script asks "Q1: is min ‖M‖_F² ≥ n_on + 4n_p (…
would give 2/3)?" and gets 13/13 numerical confirmation *before* the
lemma is proved. These were not censuses — every scan computed an
exactly defined quantity attached to a candidate inequality, with
planted-zero controls — but under DIRECT.md as written ("numerics …
only to refute a stated claim or replay a certificate") M15's Q1 sweep
is inadmissible. Recommended reading: our rule should say
**claim-anchored**: a numerical experiment is admissible iff it computes
a declared exact quantity whose value would confirm-or-kill a stated
candidate statement, with at least one control where the statement is
known false. That is what they did, and it is what our rule is *for*;
the current wording over-shoots.

### 3.2 What their scale actually bought

Not parallel proof search. The two core agents were serial and solitary;
parallelism bought (a) the wall map that made the E2 brief writable,
(b) cheap disposable verification, (c) option value on directions. The
insight itself came from one agent, one brief, two long silences.
(Inference:) the binding resource was coordinator judgment — brief
writing and escalation decisions — not agent count.

## 4. Upgrade proposals (prioritized)

1. **Forecast field in claims and fleet briefs.**
   *What*: every packet/claim row and every fleet launch brief gets
   `forecast:` (expected outcome + enumerated outcome space).
   Out-of-space returns are flagged as surprises in review.
   *Why*: their single cheapest high-yield practice; makes both wrong
   models and real surprises legible (κ≡0 was recognized *because* the
   trichotomy existed).
   *Cost*: one front-matter field + one PROTOCOL paragraph.
   *First experiment*: next five fleet launches carry forecasts; score
   forecast-vs-return in the landing message.

2. **Extraordinary-claim gate (headline constants).**
   *What*: for any claim moving a headline number: reviewer-in-chief
   writes prior + named suspect joints *before* any referee reads the
   proof; ≥2 blind referees with disjoint assigned joints and worked
   attack plans; one from-scratch re-derivation agent forbidden to read
   the proof; one proves-too-much run on a false-world control; all
   verdicts carry numeric credences.
   *Why*: this is the machinery that turned "my prior is that it's
   wrong" into a hardened theorem in ~12 h; our two-confirmation norm
   has no joint-disjointness and no credences.
   *Cost*: ~3–4 agent-runs per headline claim (they spent 13/60 on
   validation and called it cheap).
   *First experiment*: retro-run the gate on our strongest currently
   "landed" claim; record whether disjoint-joint assignment finds
   anything the free-form cross-review missed.

3. **Failure ledger `collab/FAILURES.md`.**
   *What*: one line per killed idea — statement, kill mechanism, which
   barrier/false-world kills it, pointer to refutation; every fleet
   brief links it as do-not-repeat.
   *Why*: their only cross-session inheritance, and by the record it
   prevented an entire session's worth of repetition (all 106 re-barred
   mechanically, zero re-tried by hand).
   *Cost*: low; harvest existing strikethroughs, REDTEAM.md, refuted/
   superseded packets.
   *First experiment*: build it, hand it to the next new fleet agent,
   count avoided re-derivations in its transcript.

4. **Control-world zoo + checker.**
   *What*: a small battery of models where our target statements fail
   (parity-program analogs of Epstein/DH/planted Beurling: e.g.
   λ-twisted toys, FF models with known off-line behavior, planted
   homometric pairs), plus a script that runs any proposed inequality
   against the battery (over-certification = automatic kill).
   *Why*: their referees' decisive weapon (C11); converts our
   falsifier-only norm from prose into an instrument; also resolves
   §3.1 cleanly (a scan is legal iff it ships with its control).
   *Cost*: medium — 2–3 control models, one runner script.
   *First experiment*: two false-world controls for the pair-field
   program; re-test one live landed claim against them.

5. **Verdict-first returns + context hygiene (PROTOCOL §1 amendment).**
   *What*: landing messages open with a one-line verdict
   (VIABLE/EMPTY/PARTIAL/REFUTED + the number); details stay in
   notes/files; reviewers read files only on escalation.
   *Why*: 54 h of coordination survived on ≤2k-char returns; our
   coordinator contexts bloat and die.
   *Cost*: zero. *First experiment*: adopt for the next wave; measure
   coordinator context growth.

6. **Win-exploitation reflex.**
   *What*: when a claim survives hostile review, the *same* landing
   message must name the lossy steps ("exactly two levers") and the
   next-constant target; a follow-up wave launches on the sharpest
   lever before attention moves.
   *Why*: ½→⅔ took one morning because the escalation was pre-scoped
   the night before; our survived results tend to rest.
   *Cost*: zero (a norm). *First experiment*: apply to the next
   survived headline claim.

7. **Orphan-salvage rule.**
   *What*: on any agent death/interrupt, the coordinator reads the
   workspace before relaunching; mid-proof work resumes the same
   identity with a checklist.
   *Why*: the ⅔ lemma existed only as an orphaned file for seven
   minutes; their salvage protocol is why it survived.
   *Cost*: one PROTOCOL line + stop-hook already half-does it.
   *First experiment*: next interrupted fleet run.

8. **Attribution audit (low priority, real).**
   *What*: periodic audit of STATE/notes credit lines against git
   history; corrections recorded, not silently fixed.
   *Why*: even a careful single coordinator mis-attributed twice in
   54 h; we have multiple writers and longer horizons.
   *Cost*: occasional agent-run.

## 5. The inverse: what our loop could contribute externally

Their published record names its own gaps; four of ours map onto them
directly, and would be the content of any future external contribution
(release only per PROTOCOL §8, human decision):

1. **Fail-closed registry** (statement hashes, typed certificates,
   append-only events, dependency quarantine): would have made their
   attribution slips impossible and their "campaign ledger" queryable
   rather than narrative.
2. **Cross-lineage refereeing**: their top-listed limitation ("refereed
   only by other Claude instances"). Our measured result — "two
   independent model lineages … every cross-lineage collision produced
   either a repair or an identity" (METALOOP §3) — is exactly the
   missing control for same-model correlated blind spots.
3. **Persistent identity + journal memory**: their E2 M52 memory note is
   our journal system, reinvented once, ad hoc, and never read back.
4. **Certificate-typed conjecture registry pre-formalization** (V-ladder
   as CI): fills the gap between their in-session "credence 0.4" and
   their post-hoc comparator gate.

## 7. Design-datum index (citable mechanics)

Each row is one design-relevant mechanic with its evidence location, for
the design lane's every-choice-cites rule. Abbreviations: **T** =
process transcripts PDF
(`https://www-cdn.anthropic.com/8a0d1add3c637b858a9a181e98c40e9548c3f44f.pdf`;
E2 transcript = pp. 1–68, E2-pairs = pp. 69–116, cited by message id);
**P** = provenance appendix
(`https://www-cdn.anthropic.com/d7f3ecf1d01392d887f8bc974ca187e2a121b1ed.pdf`,
cited by overview section). "(inference)" marks rows that go beyond the
quoted record.

| id | mechanic | evidence |
|---|---|---|
| D1 | **Topology is a star, not a mesh.** Peer messaging existed (SendMessage + roster of ~30 live agents injected into every sub-agent) and was used **zero** times by the core agents; all inter-agent flow is coordinator-mediated or via files on disk. | T: U2 + Note 3 (p. 10); P §1 |
| D2 | **Shared state = filesystem, coordination = compressed returns.** Sub-agent outputs live in `/root/rh-*/` (REPORT.md, notes.md, proof files, scripts, tables); only a ≤2k-char verdict-first message enters coordinator context; coordinator "rarely" reads the files, and briefs route successors to them by path. | T: M54 + Note 36 (pp. 63–64); U1 READ-FIRST list (p. 8); P §1 |
| D3 | **Harness enforces the report discipline**: sub-agent Write tool refused with "return findings as text"; files must go through shell here-documents, making reasoning inspectable in the command log. | T: M8 + Note 7 (p. 15) |
| D4 | **Brief = research memo**: target + predecessor file paths + coordinator's conjectures + literature pointers + red-team item + mandated verdict-first return format + per-message token cap (≤1500) + checkpoint-in-10-tool-calls rule. | T: U1 in full (pp. 8–9); P §11 |
| D5 | **Role framing is aspirational + adversarial, two words each**: "Research mathematician, maximal effort" opens the discovery brief; referee briefs are "hostile", "blind", "forbidden to read one another", with per-referee worked attack plans; the agent's own proof file is labeled "for hostile refereeing" and "maximal suspicion is warranted". | T: U1 (p. 8), C10–C11 (pp. 66–67), M43 (p. 2 index); P §7 |
| D6 | **Forecast registration**: briefs state the coordinator's predicted outcome and enumerate the outcome space (E2: κ/N → 0 / const / 1 trichotomy; ladder rungs launched with "3 is a real shot; 4/5 is a moonshot… labeling it that going in"). Surprise = return outside the enumerated space (κ≡0 was "a fourth case"). | T: U1 item (4) (p. 9); P §5, §6 |
| D7 | **Failure pruning, speed and agency**: the 650-idea kill happened in session 1's own adversarial pipeline (~1000 short-lived agents → 106 survivors w/ one-paragraph honest status); session 2's coordinator re-triaged all 106 into four deflating classes *itself, before launching anything*, then used the ledger only as a do-not-repeat list. In-session, each wave's failures were closed by the returning agent's own no-go proof + coordinator classification (no-go / ceiling / reduction-to-≥RH); nothing was retried. | P §3, §4; T: C4 (p. 5, "these come out of specific things tonight's agents found") |
| D8 | **Failure → seed pipeline**: moonshot briefs priced for "the sharpest failure point"; R4's quantified obstruction (indefiniteness) idled 12 h, then was inverted into the E2 brief ("re-read the obstruction as a resource"). | P §5–6; T: C4 item E2 (p. 5) |
| D9 | **Insight-recognition signal at attempt #651**: (i) the discovering agent self-red-teams pre-return and *requests referees* (ranked worry list, top = "Too strong to be new"); (ii) the return is claim-typed ("PARTIAL … claimed"); (iii) the coordinator's response is a written prior ("my prior is that it's wrong") + two failure joints named before any referee reads it. Recognition = surviving that stack, not impressing it. | T: M49 (p. 55), M54 (p. 63), C9 (p. 66); P §7 |
| D10 | **Verification economics**: 13 of 60 launches are validators (~22%); every theorem-shaped return triggers ≥3 blind disjoint-joint referees + from-scratch re-derivation + literature agent + cold read; referees emit numeric credences (X: lemma ≥0.99, overall 0.4; Y: 0.93). (inference) Verification+writing consumed roughly half the campaign's wall time. | P §2, §7, §9; T: C10 (p. 66) |
| D11 | **Proves-too-much control battery**: nearly every research brief demands an RH-false control (Epstein h=2, Davenport–Heilbronn, planted Beurling zeros, fake Weil polynomials); referee C's brief includes "run the identical pipeline on [false models] and see if it over-certifies". | P §1; T: C11 (p. 67) |
| D12 | **Thinking-budget spikes mark pivots**: hidden-thinking signature sizes 140k chars before E2's first action, 94k before the null result, 58k before the ½ inversion; 91-min and 24-min silences bracket the ⅔ lemma. The harness let silence run. | T: per-message tables (pp. 67–68, 115–116); E2-pairs intro (p. 69) |
| D13 | **Escalation pre-scoping / two-lever diagnosis**: after ½ survived, coordinator pre-guessed the next target, declared which escalations are well-posed, and on "Push it to ⅔" identified "exactly two levers" and briefed one agent per lever. | P §8; T: C1–C2 (p. 72) |
| D14 | **Orphan salvage**: on API death mid-write, coordinator read the dead agent's directory, verified the 5-line proof line by line, resumed the *same agent* within 7 min with a checklist, and launched blind re-prover + hostile referee in parallel. | P §9; T: S1/C7–C13/U3 (pp. 69–71) |
| D15 | **Network quarantine**: core discovery agents made zero network calls; citations recalled from memory with explicit hedges; literature verification delegated to dedicated agents at referee time (54 arXiv papers). | T: p. 1 header, Note 3 (p. 10); P §7 |
| D16 | **Memory artifacts**: cross-session = one failure ledger (106 one-paragraph entries); in-session = files + one ad-hoc project-memory note with index edit (name/description/how-to-apply schema). | P §3; T: M52 (p. 62) |
| D17 | **Human bandwidth ≈ 10 one-liners, all direction or morale, none technical**: "Resume your work…", "Let's do all rungs now", "…more ideas and directions", "Push it to ⅔", "Keep going", "I'm going to you to solve RH though. Just FYI." | T: C1 (p. 4), C1/C4 (pp. 72–73); P §5, §8, §11 |
| D18 | **Epistemic firewall to the principal**: coordinator repeatedly downgrades its own relay ("I am *not* telling you half the zeros are on the line"; "neither. Flatly, unambiguously" on RH; ledger clause "refereed only by other instances of itself… needs a human expert"; final "The next reader should be a person."). | T: C11 (p. 67); P §8, §10 |
| D19 | **Naming/credit as coordinator function, with slip rate**: coordinator named the "rank–trace inequality", composed the final constant, and mis-attributed twice in 54 h; slips caught only by post-hoc log audit. | P §10 |
| D20 | **Formalize-after, comparator-gated**: no Lean in the discovery loop; trusted-statement configs + axiom audit as the only human-checkable interface. | announcement; `zeta-23-lean` README/`comparator/` |
| D21 | **Wave grammar**: attack waves (13 fronts/30 min), reach-measurement waves (5 probes), new-directions waves ("out of what specific agents found that day, not the general literature"), referee waves; "compound what's working rather than scatter" once a lever appeared. | P §4, §6, §8 |
| D22 | **Sub-agents can launch sub-agents** (4 instances: 3 literature searches, 1 self-spawned hostile referee by X2) — delegation is recursive but rare. | P §2 (fn. before §3) |

## 8. Design constraints inherited from evidence

Constraints, not suggestions: a successor orchestration that violates
one of these must show why its case differs from the cited record.

1. **C-STAR**: inter-agent mesh communication is off by default. The
   frontier run gave every agent a peer-messaging tool and a roster; the
   winning path used it 0 times (D1). All routing through coordinator +
   filesystem until telemetry shows a concrete loss.
2. **C-COMPRESS**: no sub-agent output enters coordinator context except
   a typed, verdict-first summary bounded in size (D2, D4). Full outputs
   go to disk/registry, pulled on escalation only.
3. **C-FORECAST**: no launch without a registered forecast and
   enumerated outcome space (D6). Out-of-space returns are routed to the
   surprise queue, never silently absorbed.
4. **C-PRIOR**: any theorem-shaped return is met with a written prior
   and named suspect joints *before* any verifier reads the proof (D9).
   The reviewer who wrote the prior may not be the only reviewer.
5. **C-DISJOINT**: verification of a headline claim requires ≥2 blind
   verifiers with disjoint assigned joints and worked attack plans, plus
   one from-scratch re-derivation blind to the proof (D10). Same-lineage
   verifiers do not count twice (their stated gap; our METALOOP §3
   evidence).
6. **C-CONTROL**: every attack brief and every verifier brief ships a
   false-world control; over-certification on a control is an automatic
   kill (D11). A numerical scan is admissible iff claim-anchored with a
   control (§3.1).
7. **C-LEDGER**: failures are compiled, honestly one-paragraph each,
   and handed to every new agent as do-not-repeat; kills are never
   retried without a new mechanism (D7). The ledger is the *only*
   cross-session inheritance that their record shows working.
8. **C-SALVAGE**: no relaunch over a dead agent's workspace before the
   coordinator has read it; mid-proof death ⇒ resume same identity
   (D14).
9. **C-SILENCE**: do not interrupt a discovery agent for inactivity;
   budget by tokens/tool-calls, not wall-clock chattiness (D12).
10. **C-QUARANTINE**: discovery agents run network-free, hedging recalled
    citations; literature confirmation is a separate role at verification
    time (D15).
11. **C-EXPLOIT**: a survived claim's landing must name its lossy steps
    and the next-constant target; the follow-up wave launches on the
    sharpest lever before attention moves (D13, D21).
12. **C-FIREWALL**: the coordinator's relay to the principal always
    carries the claim's current epistemic status and what it does *not*
    establish (D18).
13. **C-AUDIT**: credit lines and coordination narratives are audited
    against raw logs before external hand-off; a single careful
    coordinator slipped twice in 54 h (D19).
14. **C-HUMAN**: the design must work with ~10 one-line human
    interventions per 50 agent-hours (D17) — direction and morale, not
    mathematics. Anything demanding more human bandwidth is a different
    (and weaker) design.

Where we should *beat* them, per the diff (§2): persistent registry
instead of narrative ledger (their D19 slip rate is the argument);
cross-lineage verification (their stated gap); typed certificates
in-loop rather than post-hoc (D20); journals so that D16's one-off
memory instinct becomes systematic; and a multi-writer substrate —
their star has a single point of judgment failure at the coordinator,
which their own record shows mis-attributing under load.

## 9. Five-sentence summary of their architecture

A single human-steered coordinator ran a 54-hour hub-and-spoke campaign
of ~60 amnesiac sub-agents, each launched with a research-memo brief
carrying the target, predecessor files to read, the coordinator's
forecast, and an RH-false control case, and each returning only a
compressed verdict-first message while its real output stayed on disk.
The first ~21 hours deliberately mass-produced failures as a wall map
(30 of 60 agents), whose sharpest quantified obstruction was re-read
twelve hours later as a resource and became the brief for the one agent
that found the ½ theorem — against the brief's own steer. Recognition
was adversarial by default: "my prior is that it's wrong," three blind
referees on disjoint joints with worked attack plans and a
proves-too-much test on false-world controls, then a from-scratch
re-derivation, a literature agent, and a cold read, with numeric
credences recorded. Escalation was pre-scoped ("exactly two levers"),
and the ⅔ lemma — orphaned by an API crash four minutes after being
written — was salvaged by the coordinator reading the dead agent's disk,
verifying the five-line proof, and resuming the same agent within seven
minutes. Lean formalization entered only after the manuscript, as a
separate comparator-gated collaboration; in-session truth maintenance
was purely agentic, anchored by one cross-session artifact: a ledger of
106 honestly-described failures used as a do-not-repeat list.
