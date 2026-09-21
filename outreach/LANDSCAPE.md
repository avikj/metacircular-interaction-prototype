# Landscape: who evaluates this work, how they evaluate it, and when the doors are open

Researched 2026-09-21. Every fact below carries its source. Dates for 2027 events
that have not published a call are projected from the 2026 edition and marked
*projected*; re-verify before acting on them.

The single sentence that every target below agrees on, in their own words:

> "A formally verified proof is, after all, precisely a proof whose correctness
> no longer depends on the reputation or the diligence of its author."
> — Tao, *Mathematics in the age of AI*, ICM 2026 essay (arXiv 2608.16753)

That sentence is the thesis of this repository's `check` script. It is also the
whole reason an outsider can be heard by the people listed here. It cuts both
ways: it is only true of the part of the corpus that actually typechecks
under `--safe` at the pin, and only of the *formal statement*, not of the
prose around it. Everything in `README.md` (the plan) is built on that.

---

## 1. Anders Mörtberg and Andrea Vezzosi (Cubical Agda)

**Who they are now.**
- Mörtberg: associate professor (docent), Computational Mathematics, Stockholm
  University. Primary reviewer on `agda/cubical` ("most topics"). Recent:
  *A Computer Formalisation of the Serre Finiteness Theorem* (Barton, Ljungström,
  Milner, Mörtberg, LICS 2026); *Automating Boundary Filling in Cubical Type
  Theories* (Doré, Cavallo, Mörtberg, FSCD 2024); π₄(S³) (LICS 2023
  distinguished paper). Interests listed: computational justification of
  univalence and HITs, synthetic homotopy theory, formalization.
- Vezzosi: PhD Chalmers 2018 (Abel), postdoc ITU Copenhagen, now Senior Software
  Consultant at MLabs. He wrote the cubical implementation inside Agda; also
  guarded cubical, flat modality, normalization. Public email on his site.

**Where they are reachable.**
- `github.com/agda/cubical` issues and PRs. Master currently targets Agda 2.8.0,
  which is exactly this repository's pin (`setup`: Agda 2.8.0 / cubical v0.9).
- The Discord shared by agda/cubical, agda-unimath and the 1lab (link in the
  agda/cubical README). Reviewers say to ping them there when reviews stall.
- Agda's own Zulip and the Agda issue tracker for anything that is a
  *checker* observation.

**What they evaluate, in order.**
1. Does it load with `--safe --cubical` against a released library version, with
   zero postulates, zero TERMINATING pragmas, zero holes? (They will run it.)
2. Is each module small enough to read, and does the name of the theorem match
   its type?
3. Is anything here a *library-shaped* contribution (a lemma agda/cubical does
   not have, a cleaner proof of one it does), or a *checker* observation (a
   performance pathology, a case where Agda 2.8.0 needs `-M` heap caps to
   decide a boolean)?

**What earns attention from them specifically.** Not the philosophy. Two
things in this repository are shaped exactly like what they publish on:
- The forced-completion / fibre-law spine (`fibre/`), which is ordinary HoTT
  stated cleanly and could be offered upstream as library lemmas.
- The checker-as-computer results: the depth-4096 Rule 30 certificate that
  holds ~10 GB live while deciding one boolean (noted in `check`), and the
  Bend/HVM port that runs cubical transport as runtime data. Mörtberg's
  research statement is "computational justification of univalence"; a
  corpus where `transport (ua e)` is executed on an interaction net is in his
  lane.

Sources: staff.math.su.se/anders.mortberg/ · saizan.github.io ·
github.com/agda/cubical/blob/master/README.md ·
drops.dagstuhl.de/entities/document/10.4230/LIPIcs.LICS.2026.16

---

## 2. Kevin Buzzard (Imperial, Lean / mathlib)

**His stated evaluation procedure, verbatim.** From the July 2026 Xena post
*Human mathematicians are being outcounterexampled*: when handed an
AI-generated informal argument he replied "I am not reading AI-generated
informal mathematics" and asked for the Lean. Once given Lean, he reports it
took five minutes to confirm three things: the definitions come from mathlib
(not re-defined to be trivial), the formal statement matches the claimed
theorem, and the proof compiles. He then points people at pull requests.
He also states (as a mathlib maintainer) that mathlib will not accept AI
*reviews*, and that reviewers are reluctant to review AI-generated code because
most of it is poor.

**What that means for this repository.**
- The only thing to send him is the Lean lane (`formal/lean`, Lean 4.33 +
  mathlib v4.33.0, `lake build`, then `lake exe yogyanupalabdhi` as an axiom
  gate with a written allowlist). It must be sent as: exact statement, exact
  build command, exact axiom report. Nothing else.
- His five-minute check is precisely the check the axiom-gate executable was
  built to make trivial. Lead with that.
- He does not respond to "world-changing"; he responds to a green build and a
  statement he can read. The Cubical Agda corpus is outside his tooling; do
  not send it to him first.

**Channels.** Lean Zulip (real name required; introduce in `#new members`,
then one topic with a minimal, complete, buildable example); mathstodon
`@xenaproject`; the Xena blog. He publicly engages with outsiders who bring
compiling Lean.

Sources: xenaproject.wordpress.com/2026/07/20/... ·
leanprover-community.github.io/meet.html

---

## 3. Emily Riehl, the HoTT Zulip, the Univalent Foundations community

**Riehl now.** ICM 2026 invited sectional speaker (topology), *Synthetic
perspectives on higher structures*. PI (with Shulman and Awodey) on an AFOSR
project *Proof assistants for formalization of higher category theory*,
2026–27. Runs the Rzk / sHoTT formalization of synthetic ∞-categories
(`rzk-lang/sHoTT`, own Zulip). Sits on the Mathlib Initiative strategic
advisory board. JHU email public.

**The community.**
- HoTT Zulip (`hott.zulipchat.com`): open sign-up, no invitation. Self-described
  "friendly and relaxed ... Coq, Agda, Cubical TT, and other systems". The
  right place for "here is a checked development, here is what it says".
- The HomotopyTypeTheory Google group: announcements and CFPs.
- agda-unimath (Rijke, Bakke): explicit "contributions welcome within any
  topic", fork/branch/PR, strong style conventions, statement of inclusivity.
- The 1lab: this repository's own site already vendors the 1lab frontend, so
  the corpus reads like a 1lab-style development to that community.

**HoTT/UF workshop.** 2026 edition: 1–2 June, Aarhus; 1–2 page abstracts via
EasyChair; abstracts closed 27 March, notification 28 April; organizers
Cherubini, Ljungström (Mörtberg's group), Gratzer, Pujet. 2027: not yet
announced. *Projected*: call ~January 2027, deadline ~March 2027.

**What this community evaluates.** Whether the mathematics is *new to HoTT*,
or a known fact under a new name. The fibre law `A ≃ Σ b. fib f b` and
"completions of a map form a contractible type" are textbook (HoTT book
§4.8) and will be recognised as such instantly; naming them as the
contribution costs credibility. What is *not* textbook and would be read:
the interactive coalgebra / coinductive answer-stream results
(`silence-is-determinism`), the crossing-length geodesic, and the executable
runtime for transport. Lead with those and cite the book for the rest.

Sources: emilyriehl.github.io · hott-uf.github.io/2026 · hott.zulipchat.com ·
unimath.github.io/agda-unimath/CONTRIBUTING.html

---

## 4. Topos Institute (Berkeley) — Spivak, Fong, CatColab

**Why they are the nearest door.** They are in Berkeley. Their stated
recruiting path is "practitioners, mathematicians, and students who have an
affinity for our research, through public events, pedagogical materials, and
visiting researcher programs" (Strategic Plan 2025–2028). Their colloquium
themes explicitly include "foundation models emphasizing pure theory (logic,
categories, type theory)" and "technologies and tools translating
mathematical ideas into viable software". The README's framing — local-first
state, composable witnessed interaction, traces as the unit of value,
"consensus is not the primitive" — is closer to Topos's systems-science
programme than to any proof-assistant venue.

**Two concrete channels.**
- *Berkeley Seminar*: weekly, in person, open to the public, Wells Fargo
  building 6th floor, "usually Topos researchers, occasional guest speakers",
  recorded to YouTube. Subscribe / propose:
  `berkeley-seminar+subscribe@topos.institute`. Sept 2026 speakers: Spivak
  (Categories by Kan extension), Péroux (promonads).
- *Topos Colloquium*: Thursdays 17:00 UTC on Zoom, recorded. Contact for
  the colloquium itself: `david+colloquium@topos.institute`.
- CatColab v0.5 shipped March 2026; Spivak's database/lens/polynomial-functor
  lineage is the mathematical vocabulary they will translate this work into.

**What they evaluate.** Whether there is a *category* here they can draw:
what are the objects, what are the morphisms (traces), what is composition,
what is the double-categorical structure of "paths between paths". The
trace-algebra section of the README is already in that shape.

Sources: topos.institute/events/topos-colloquium/ ·
topos.institute/events/berkeley-seminar/ · topos.institute/strategic-plan/

---

## 5. Artifact-evaluated venues — the calendar

| Venue | Status as of 2026-09-21 | Next realistic deadline | Format |
|---|---|---|---|
| **CPP 2027** (Mexico City, 11–12 Jan 2027, with POPL) | **Closed.** Abstracts 3 Sep, papers 10 Sep 2026. Chairs Cohen (Inria), Swamy (MSR). | CPP 2028, *projected* ~early Sep 2027 | 12 pp ACM sigplan, lightweight double-blind, artifact evaluation voluntary after conditional accept, ACM AI-use policy applies |
| **TYPES 2027** (Udine, 7–11 June 2027) | Site scaffolded; dates from the organizers' site draft | **Abstracts 19 Feb 2027**, notification 22 Mar, camera-ready 30 Apr (*verify when CFP posts*) | 2-page abstract (prior editions); post-proceedings LIPIcs |
| **HoTT/UF 2027** | Not announced | *projected* ~March 2027 | 1–2 page abstract, EasyChair |
| **ITP 2027** | Not announced (ITP 2026: Lisbon, FLoC, abstracts 12 Feb / papers 19 Feb 2026) | *projected* ~Feb 2027 | full paper, LIPIcs |
| **LICS 2027** (Montreal, 21–24 June 2027) | CFP not out (LICS 2026: abstracts 15 Jan / papers 22 Jan) | *projected* ~mid-Jan 2027 | 12 pp, double-blind; topics include "logical aspects of computational complexity" |
| **FSCD 2027** | Late Aug / early Sep 2027 (steering committee) | *projected* ~Feb 2027 | LIPIcs |
| Journals: LMCS, Journal of Formalized Reasoning, JAR | rolling | any time | JFR is the natural home for "here is a checked development and what it took" |

**What "artifact-evaluated" actually requires** (from the CPP 2027 call): the
paper is judged on "thorough theoretical discussion, detailed formalization
decisions with alternatives considered, examination of related literature,
comparison to other library designs, feedback on proof assistant features".
The artifact is a separate, voluntary, post-acceptance submission. So the
proof is *not* the submission at CPP; the *paper about the proof* is, and
the proof supports it. Where the proof genuinely *is* the submission is
HoTT/UF and TYPES (abstract + repository) and the library PR route
(agda/cubical, agda-unimath).

**arXiv.** Since 21 Jan 2026 an institutional email no longer auto-endorses a
first-time submitter. A first `cs.LO` / `math.LO` / `math.CT` submission needs an
endorser. Ask one of the people above *after* they have read the artifact,
never before.

Sources: popl27.sigplan.org/home/CPP-2027 · itp-conference-2026.github.io ·
lics.siglog.org/lics26/cfp.php · hott-uf.github.io/2026 ·
github.com/miculan/types2027.github.io/pull/1 ·
blog.arxiv.org/2026/01/21/attention-authors-updated-endorsement-policy/

---

## 6. The Tao-era "AI + formal proof" door — what it is and what it is not

**The open door, stated precisely.** Tao's ICM 2026 essay (§6, §8) says:
formal verification removes reputation from the correctness question; authors
should "transparently disclose the use of automated tools, including large
language models" in a *Tool and computational resource disclosure* section;
give "precise and complete references to previous results"; and pass the
talk test — "if the authors cannot convincingly demonstrate that they are
able to give a clear, expert-level talk on their results, one that is
correct and properly attributed, then the result should not be published."
Earlier (Apr 2026): if you could not present the output in a class and
answer questions without further AI help, it should not be in your workflow.

**The door that closed this month.** On 11 Sep 2026 Tao and 24 other Fields
medallists published *A Severe Misalignment of AI in Mathematics* (7,200+
signatories by 16 Sep). Its complaint is exactly: results "announced in a
rush, leaving no time for a proper writeup, the isolation of new methods and
ideas, and citing relevant previous work". The 12 Sep guest post on his blog
(*After Math*, De Toffoli & Duede) adds: a Lean certificate is a *logical*
proof, not yet an *intelligible* one.

**How outsiders have actually gotten through.** The `teorth/erdosproblems`
repository accepts PRs recording contributions with: exact statement,
Lean/mathlib pins, reproduction commands, who did what (AI standalone vs.
AI-with-named-humans), and recorded local verification. That is the template.
People get engaged there by bringing one checkable thing with a pin and a
command, not by bringing a programme.

**Consequences for this repository, bluntly.**
1. The ERRATA_LOG and agent-notes files are an asset under the disclosure
   norm, not an embarrassment: they are the "chat logs and traces" he asks
   for. Keep them, cite them.
2. "P vs NP" must not appear in any first message. The repository's own
   research note says "No theorem below claims a standard P/NP resolution".
   The first message names one theorem, one file, one command.
3. Any first contact must come with a human-language writeup that cites the
   prior art (HoTT book §4.8 for the fibre law, CCHM for the type theory,
   Pratt for Chu spaces, Lafont/Mazza for interaction nets, Bennett for
   reversible cost). The "rush announcement, no citations" pattern is the
   one the field just publicly rejected.

Sources: arxiv.org/abs/2608.16753 · terrytao.wordpress.com/2026/09/11/... ·
terrytao.wordpress.com/2026/09/12/after-math/ · teorth.github.io/tao-web/ai-views.html ·
github.com/teorth/erdosproblems/wiki/AI-contributions-to-Erdős-problems

---

## 7. Higher Order Company / Taelin (the runtime the collab work targets)

**What changed on 17 Sep 2026.** Bend 2 went public at `bendlang/bend`:
affine dependent types (BendTT), `LAWS.bend` proof obligations on every edit,
compiles to C / Metal / CUDA / JS via **BendRT**, *not* HVM. The README says
the compiler is "99% AI-written" and "not fully audited". Apache-2.0. No
mention of paths, cubical structure, univalence, quotients or HITs anywhere
in the launch material. Community: the HOC / Bend Discord (~6.6k members),
GitHub issues, Taelin on X.

**Where this repository stands relative to that.** `collab/bend2-cubical`
patches the *pre-launch* lineage (`DKormann/Bend2 @ f026483` + HVM3/HVM4)
with a full CCHM layer (Glue, general hcomp, HIT schema, coinduction, a
108-file suite, `--to-hvm4-full`). That is a real engineering result on a
runtime the company has now set aside. The honest pitch is therefore: "here
is what a cubical layer costs and buys on an interaction-net runtime,
measured; here is the question of whether BendRT's affine core admits it."
Not "we cubicalised Bend 2".

Sources: github.com/bendlang/bend · bend2.dev/notes/what-is-bend2/ ·
discord.com/invite/hoc-higher-order-community-912426566838013994
