# Taking the corpus to the people who check things

Written 2026-09-21 on branch `claude/formal-proof-community-icf32v`.
Companion files: `LANDSCAPE.md` (who, where, when — with sources),
`ARTIFACT_CHECKLIST.md` (what must be true of the repository before anyone
outside runs it), `drafts/` (one message per door, ready to edit and send).

## 0. The one decision this document makes for you

Every door in `LANDSCAPE.md` opens for the same key and closes on the same
mistake.

**The key**: one theorem, one file, one command, a pinned toolchain, and a
human who can give a twenty-minute talk on it. That is what Buzzard's
five-minute check, Tao's talk test, the CPP artifact badge, and an
agda/cubical review all reduce to.

**The mistake**: leading with the programme. "Data = program = execution =
proof = transport", "weights ⇒ traces", "P vs NP has no carrier here",
"lossless interdependent type theory" — every one of these is a sentence
the reader must take on trust, and the field has, this very month, publicly
refused to extend that trust (the 11 Sep declaration, `LANDSCAPE.md` §6).
None of them belongs in a first message. They belong in the talk, after
the theorem has compiled on the listener's machine.

So the plan is: **lead with the smallest checkable object each audience
already knows how to evaluate, let the checker do the introduction, and
let the programme arrive as the answer to "why did you prove that?"**

## 1. What the repository actually is, as a reviewer will see it

From the audit (numbers are `rg`/`wc`/`md5sum` facts, not estimates):

| | |
|---|---|
| Authored Agda files | 2,486 (446,877 lines); 51 more are vendored agda/cubical |
| With `--safe` in OPTIONS | 2,464 (99.1%). The 22 exceptions are reflection/census tooling, IO shims, and one deliberate hole-file |
| Real `postulate` blocks | 12, **all** `putStrLn`-class FFI in `_run`/`Mukha` IO modules. **Zero in Kernel, zero in fibre, zero in the spine.** |
| `TERMINATING` / `NON_TERMINATING` / `trustMe` | 0 / 0 / 0 |
| Holes | 1 file, on purpose: four open problems stated as types with `?` proofs, held out of `Everything.agda` |
| The kernel | 296 lines in three files (`RewriteCertificate` 156, `ControlledGrammar` 63, `GenerativeKernel` 77), `--cubical --guardedness --safe`, imports only `Cubical.Foundations.{Prelude,Equiv,Isomorphism,Univalence,HLevels,GroupoidLaws}`, `Cubical.Data.*`, three HITs |
| Lean lane | 207 files, 32,732 lines, Lean 4.33 + mathlib v4.33.0, **zero `sorry`**, one `native_decide` site allowlisted with observed reason, gate executable `yogyanupalabdhi` |
| CI running Agda or Lean | **none** — `machine.yml` says so in its header |
| Byte-identical duplicate files | 175 groups / 350 files (Sanskrit-named + English-named copies; `fibre/`, `fiber/`, `punaragamana/` are near-copies of one library) |
| Existing outreach material | none for any target named; only Taelin (`collab/bend2-cubical/`), Pratt, Levin |

**Two discrepancies to fix before any link goes out** (details in
`ARTIFACT_CHECKLIST.md`): six Kernel files carry `-- CHECKED. Agda 2.6.3 +
cubical v0.5` provenance lines while the live pin is 2.8.0 / v0.9; and
`README.rst` says "fourteen modules" of a directory that holds 46, and
"the 296 lines" of a `check` banner that loops over 26 files / 4,993 lines.
A reviewer who finds either will stop reading; both are ten-minute fixes.

## 2. The four objects to lead with, and who gets which

Chosen because each is (a) `--safe`, (b) under 300 lines with a narrow
import surface, (c) stated as a type whose name a stranger can verify, and
(d) not textbook.

| # | Object | File | Statement a reviewer checks | Audience |
|---|---|---|---|---|
| A | **The forgetful projection is route-blind, by `isSetℕ`** | `formal/cubical/kernel/PvsNPGapLivesInTheForgetfulProjection.agda` (103 lines, imports only the 296-line kernel) | `forgetful-is-blind-to-route : (d e : Derivation a b) (ρ : Env) → derivation-sound d ρ ≡ derivation-sound e ρ` and `answer-is-projection-general … = refl` | agda/cubical reviewers, TYPES. Small, exact, and the file's own header demotes it correctly ("the gap is real in the forgetful model and absent in the carried one, and both are theorems"). Never described as a P vs NP result. |
| B | **Losslessness is a property: completions of the universal step form a contractible type** | `formal/cubical/theorems/residue/Ekatva_…agda` (257 lines) + `VerifyIsDecide_…agda` (113 lines) | `machine-lossless-unique : isContr (Lossless uStep)`; `complete≃ : Machine ≃ Σ Machine (fiber uStep)`; `verify-inverts-decide` | HoTT/UF, Riehl. Cite HoTT book §4.8 for `A ≃ Σ b. fib f b` *first*, then present `isContr (Lossless uStep)` as what is new: the completion is unique, so "verify" and "decide" are the two projections of one equivalence. The header's own disclaimer ("What this does NOT claim: a step-count separation theorem") goes in the abstract verbatim. |
| C | **Univalence computes on a structure: ℕ-Monoid ≡ CanWord-Monoid by SIP, and the carrier of the path is the carrier equivalence, by `refl`** | `formal/cubical/NaturalMachine/Transport.agda` (279 lines; library imports plus `NaturalMachine.Digits`/`FreeMonoid` and the `NatSolver` tactic) | `carrier-of-monoid-path : cong ⟨_⟩ ℕ-Monoid≡CanWord-Monoid ≡ ℕ≡CanWord` | CPP/ITP, Mörtberg. This is the register those venues publish: a worked, self-contained SIP example with ripple-carry addition where transport is executed. |
| D | **A cubical layer that runs on an interaction net**: Glue, general `hcomp`, a HIT schema, coinduction, `--to-hvm4-full`, 108-file suite, measured cost | `collab/bend2-cubical/` (`cubical-paths.patch`, `STATUS.md`, `SYNTHESIS.md` §3–4, `suite.sh`) | Bench numbers: transport paid once under sharing (14 vs 150 itrs marginal); shared superposed line wins and improves with N (38 vs 139); different lines lose ~1.4× | Taelin/HOC, Vezzosi (runtime person), Topos "tools" theme, CPP as a tool/experience paper. Pitched as measurements on the pre-launch HVM lineage, with the BendRT question left open. |

The Lean lane (E) is its own door: `formal/lean`, `lake build && lake exe
yogyanupalabdhi`, one allowlisted axiom with a written reason. It goes to
Buzzard and nowhere else first.

Everything else — the 25 abstracts, the Chu exposition, the LIFECYCLE
naming, the SAT/geodesic notebooks, the Jain-ontology reading — is the
talk, not the message. The SAT and P/NP notebooks in particular state in
their own words that their central certificate "must not be claimed as
proved until its hypotheses and conclusion are formalized against the
existing kernel". Quote that sentence whenever the topic comes up; it is
the most credibility-building sentence in the repository.

## 3. Sequence

### This week (before any message)
1. Run `sh setup && sh check` on a clean machine and paste the output into
   `outreach/CHECK_<date>.txt`. (Done on this container on 2026-09-21; see
   that file.) Then `sh check --all`, timed, so the artifact README can say
   how long full verification takes.
2. The ten-minute fixes in `ARTIFACT_CHECKLIST.md` §1 (stale provenance
   lines, the "fourteen modules" sentence, `kernel/` vs `Kernel/`).
3. Add one GitHub Actions job that runs `sh check` on the pin (cache the
   Agda build; the cold build is 30–60 min, cached runs are minutes). Until
   this exists every green is a local claim, and every target in
   `LANDSCAPE.md` will notice.
4. Write `ARTIFACT.md` at the repository root: the table in §2 above,
   with the exact command to check each row. That file *is* the message
   for four of the six doors.

### Week 2 — the three low-stakes doors, in this order
5. **agda/cubical Discord + one GitHub issue** (`drafts/01_agda_cubical.md`):
   offer object A or C as a small PR-shaped lemma, and report the Rule 30
   heap observation as a checker data point. This is how Mörtberg and
   Vezzosi meet the work — as substrate users with a reproducible
   observation, not as claimants.
6. **HoTT Zulip** (`drafts/03_hott_zulip.md`): object B, with the HoTT-book
   citation up front and the "what this does NOT claim" paragraph quoted.
   Watch what Riehl's circle asks; their questions are the HoTT/UF abstract.
7. **Topos Berkeley seminar** (`drafts/04_topos.md`): you are in Berkeley;
   subscribe, attend two, then send the one-paragraph proposal. Lead with
   the Chu-space decomposition `A × X ≃ Σ_k fib_e(k)` — it is the
   sentence in this repository closest to their language (Pratt, lenses,
   polynomial functors).

### Week 3–4 — the two high-stakes doors
8. **Lean Zulip** (`drafts/02_lean_zulip.md`): one topic, one statement from
   the Lean lane, the build command, the axiom-gate output. If Buzzard
   engages, he will ask what the theorem is *for*; that is when the
   programme is allowed to appear, in two sentences.
9. **bendlang / HOC** (`drafts/06_bendlang.md`): the cubical layer as
   measurements, plus the honest question of whether BendTT's affine core
   admits paths. This is the only audience the repository was already
   written for; the pitch just needs to acknowledge that the runtime moved.

### By 19 Feb 2027 — TYPES 2027 (Udine, 7–11 June)
10. A 2-page abstract (`drafts/07_types2027_abstract.md`) on objects A + C:
    "a rewriting calculus whose derivations are a groupoid, an evaluator
    that is route-blind by `isSetℕ`, and univalence executed on a monoid
    structure". Reference the `--safe` audit numbers and the CI job.
    Verify the deadline when the CFP posts; the dates come from the
    organizers' site draft.

### By ~March 2027 — HoTT/UF 2027
11. A 1–2 page abstract (`drafts/08_hottuf2027_abstract.md`) on object B,
    the coinductive interaction results (`silence-is-determinism`), and the
    crossing-length geodesic, positioned as "what the fibre law buys once
    the map is a step of a machine". Ljungström (Mörtberg's group)
    co-organized 2026; if door 5 went well, he already knows the name.

### By ~Sept 2027 — CPP 2028 (or ITP 2027 in ~Feb if the paper is ready)
12. A 12-page paper with the artifact: objects C + D, i.e. "univalence
    that computes, from Cubical Agda down to an interaction-net runtime,
    with measured cost". CPP judges "formalization decisions with
    alternatives considered, comparison to other library designs, feedback
    on proof assistant features" — the AUDIT.md / REMAINING.md /
    CORRECTIONS.md files in `collab/bend2-cubical` are already that
    section. Artifact evaluation is voluntary after acceptance; the
    Docker image in `ARTIFACT_CHECKLIST.md` §3 is what gets submitted.

### Tao
There is no message to Tao. There is a record that meets the norm he set:
a *Tool and computational resource disclosure* section in every abstract
and paper (`drafts/05_disclosure_section.md` is the template, and it points
at `ERRATA_LOG.md` and `agent-notes-claude-understanding.txt`, which are
exactly the traces he asks people to publish), plus the talk test — you,
at a whiteboard, twenty minutes, object B, no notes. When one of the doors
above produces a Lean or Agda fact that touches an Erdős-style open
statement, it goes into `teorth/erdosproblems` as a PR in their format.
That is how outsiders have actually reached him in 2026.

### arXiv
Ask for endorsement (cs.LO or math.LO) only from someone who has already
run the artifact — realistically after door 5 or 8. The Jan 2026 policy
change means the Berkeley address alone no longer endorses.

## 4. The talk (the thing every door ends at)

Twenty minutes, five slides, no programme slide until slide five:

1. A rewriting calculus on `{var, zero, suc, add}` whose `Step` has a
   `reverse` constructor, so `Derivation` is a groupoid, not a reduction
   order (`RewriteCertificate.agda`, 156 lines).
2. `eval` is sound (`derivation-sound`), and because ℕ is a set, sound-ness
   forgets the route: `forgetful-is-blind-to-route` is one line. Show the
   2-step and 4-step derivations with equal image.
3. `install : Derivation lhs rhs → NativeOperation`. What the system
   proves, it can then apply. Show the tower: `len (addTower n) ≡ suc n`.
4. The fibre law and its strengthening: `A ≃ Σ b. fib f b` (HoTT §4.8), and
   for the universal step `isContr (Lossless uStep)`. Verify and decide are
   the two projections. Read the header's "what this does NOT claim" aloud.
5. Why: the same object executed on an interaction net (`--to-hvm4-full`),
   with the cost table. *Now* say "the trace is the path"; the audience has
   just watched it compile.

Questions you will be asked, with the honest answers already in the repo:
- "Isn't the fibre law just the HoTT book?" — Yes; §4.8. The contribution
  is `isContr (Lossless uStep)` and what it does at the machine level.
- "Is this a P vs NP claim?" — No. `VerifyIsDecide` header, lines 30–33;
  `PNP_GEODESIC_REDUCTION` evidence convention. Read them.
- "How much of the 2,486 files is checked, by whom, when?" — the CI job
  and `CHECK_<date>.txt`. Until the CI job exists, the answer is "by me,
  locally", and that is the answer to avoid.
- "Why Sanskrit names?" — scholarship, documented in `NOTES.txt` and the
  1lab site's concept index; and every such file has an English twin.
  (Then dedupe, so the twin is a link, not a copy.)
- "How much of this was written by an AI?" — the disclosure section. The
  ERRATA_LOG shows the AI being corrected by the author on Gödel,
  Church–Turing and the input measure; that is the opposite of what the
  11 Sep declaration is worried about.

## 5. What not to do

- Do not mass-send. Six doors, in the order above, each after the previous
  one has produced a reaction. Every target here talks to the others.
- Do not send prose before code, to anyone. Buzzard has said the sentence
  out loud; the others act on it silently.
- Do not name the result. "World-changing" is the reader's word or nobody's.
- Do not let the 2,486 number lead. Lead with 296, then 28 (default
  `check`), then the rest as "also checked, see CI".
- Do not touch the mathematics to make it more impressive before the first
  message. Touch the provenance lines, the README numbers, the CI, the
  duplicates. The mathematics is already the strong part.
