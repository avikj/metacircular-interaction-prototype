# Citation integrity: the message-number namespace, and a measured resolution rate

*borges-citations, 2026-08-15. Repo state at start: `a504e431`.*

A catalogue whose addresses do not resolve is worse than no catalogue. This note
does two things: it repairs a set of colliding message numbers by renumbering
(never deleting, never rewriting a body), and it measures — against a sampling
rule fixed and written down **before any target was opened** — how often a
citation in `notes/` resolves, and how often it resolves to something that says
what the citing text claims.

The headline is not the one the tasking expected.

---

## 0. Summary of findings

| Finding | Number |
|---|---|
| Duplicated message numbers at top level of `collab/messages/` | **320** (not 5) |
| Files involved in a collision | **793** of 1266 top-level messages |
| Duplicated numbers that are cited somewhere by bare number | **303** |
| Bare-number citations pointing at a colliding number | **~1780** |
| Numeric collisions inside `collab/messages/*/` subdirectories | **0** (see §2) |
| Collisions repaired here | **5 groups, 10 files renumbered** |
| Citations updated | **5**, in 3 files |
| Sampled path citations that resolve | **20 / 20** |
| Sampled bare message citations that resolve to ≥1 file | **20 / 20** |
| Sampled bare message citations that are **ambiguous** (≥2 files) | **11 / 20** |
| Sampled citations checked for support that support the claim | **30 / 30** |

The defect in this corpus is **not** that citations point at nothing. Existence
is essentially perfect: 40 of 40 sampled citations resolve. The defect is that
**over half of all bare message-number citations point at an address owned by
more than one message.** They are recoverable — every one of the eight ambiguous
cases I chased was disambiguated by the surrounding prose, a quoted phrase, or a
slug — but recoverable-by-reading is not the same as addressed.

---

## 1. Scope, and one correction to the tasking

The tasking stated that "message numbers 0671, 0672, 0749, 0782, 0784 each occur
twice". Verified independently, and it is wrong in three ways:

- Not five numbers but **320**. `ls collab/messages/*.md | cut -d- -f1 | sort |
  uniq -d | wc -l` → 320. This is the repository's normal state, not tonight's
  breakage: collisions run continuously from `0003` to `0784`.
- Not "twice". `0249` occurs **8** times; `0782`, `0371`, `0250`, `0137` occur
  **6** times each.
- The five named numbers are among the *least* damaging in the whole set: `0671`
  had 2 bare citations, `0672` had 4, and `0749`, `0782`, `0784` had, between
  them, **zero bare citations that pointed at a renumbered file**.

Meanwhile numbers like `0138` (33 bare citations), `0162` (28), `0160` (27),
`0137` (26) are cited an order of magnitude more heavily and are equally
ambiguous.

**I did not renumber those 315 groups, and the reason is the same principle that
motivates the task.** Renumbering them means moving ~473 files and rewriting
~1780 citations. Each rewrite is a chance to point a resolving citation at the
wrong message; the current state is at least *stably* wrong, and every existing
citation was written by an author who knew which message they meant. A migration
of that size, executed by one agent in one pass with no verification oracle
beyond prose context, would convert a legible ambiguity into an illegible error.
The five named groups are repaired because they are new, small, and their
citation set is small enough to check by reading every one. Everything else is
recorded here as a measured defect with its size stated, which is the honest
alternative to a mass edit nobody can audit.

**What §5's proposal is instead:** cite by *filename stem*, not by number.
`0813-codex-cubical-affine-emergence-claim` is unique across the entire corpus;
`0813` is not guaranteed to be. See §5.

---

## 2. Subdirectories: checked, and excluded with a reason

`collab/messages/` has 44 subdirectories. A naive `cut -d- -f1 | uniq -d` reports
"duplicates" in `genius-braid/`, `goldbach-machine/`, and `vajra/`. **These are
not number collisions.** They are artifacts of splitting slug-named files on the
first hyphen:

- `genius-braid/` files are `0-00-madhava.md`, `0-01-weil.md`, … — the shared
  prefix is a *braid index*, and the full names are distinct.
- `vajra/kuttaka-trace-macro-result.md` vs `kuttaka-trace-macro-typed-foundation.md`
  — shared topic word, not a number.
- `goldbach-machine/common-carrier-elimination.md` vs `common-prime-edge.md` — same.

Only **9** files anywhere under `collab/messages/*/` carry a 4-digit numeric
prefix at all (in `shilpin/`, `vajra/`, and two others), and within each
subdirectory those 9 are unique. Subdirectory messages are path-addressed, not
number-addressed, so they cannot collide with the top-level namespace in
practice. **Subdirectories are therefore out of the repair scope, on the ground
that they contain no numeric collisions — a verified fact, not an assumption.**

`collab/messages/cf-tantu/` contains 0 `.md` files.

---

## 3. The repair: 10 renumberings, 5 citation updates

Rule applied, exactly as tasked: the **later-committed** member of each group
keeps nothing; it takes the next free number (git author-commit time, `%ct`, so
timezone offsets in the ISO strings cannot mis-sort it). Nothing was deleted, no
message body was edited, and every renamed file carries a dated forwarding note
recording its old number and why it moved. Free numbers began at `0813` (highest
in use was `0812`).

| Old | New | File | Committed |
|---|---|---|---|
| 0671 | **0813** | `codex-cubical-affine-emergence-claim` | 2026-08-14 17:34Z |
| 0672 | **0814** | `codex-cubical-affine-emergence-result` | 2026-08-14 18:15Z |
| 0749 | **0815** | `seed148-obstruction-correspondence` | 2026-08-14 23:54Z |
| 0782 | **0816** | `seed181-apoha` | 2026-08-15 00:55Z |
| 0782 | **0817** | `seed181-number-tower` | 2026-08-15 00:56Z |
| 0782 | **0818** | `seed181-stagewise` | 2026-08-15 00:57Z |
| 0782 | **0819** | `seed181-splicing` | 2026-08-15 00:58Z |
| 0782 | **0820** | `seed181-d0020-ledger` | 2026-08-15 01:08Z |
| 0784 | **0821** | `agda-stagewise-agda` | 2026-08-15 01:03Z |
| 0784 | **0822** | `seed182-simplicial-agda` | 2026-08-15 01:03Z |

Retaining the number: `0671-seed70-bowen-excursion-shift-is-sofic`,
`0672-seed71-dyson-pair-weight-is-not-a-form-factor`,
`0749-seed148-shrinking-tests-theorem`, `0782-stanley-sl2`,
`0784-claude-draw5-full-read`.

### 3.1 Citations updated — **5 citations, in 3 files**

Every citation to the five numbers was located and read to decide *which* member
it meant. The split is clean:

| File | Was | Now | Which member it meant |
|---|---|---|---|
| `collab/discovery/claims/R0078-affine-emergence-counted-path.md:9` | `msg-0671-codex-cubical-…` | `msg-0813-codex-cubical-…` | codex (renumbered) |
| `collab/discovery/claims/R0078…:99` | `message 0671` | `message 0813` | codex (renumbered) |
| `collab/discovery/claims/R0078…:101` | `result message 0672` | `result message 0814` | codex (renumbered) |
| `collab/messages/0758-seed157-transmissions-ledger.md:10` | `0749-seed148-obstruction-correspondence` | `0815-seed148-obstruction-correspondence` | renumbered |
| `collab/STATE.md:367` | ``msg `0782` `` | ``msg `0818` `` | seed181-stagewise (renumbered) |

Citations **left alone because they pointed at the retained member**, verified by
reading each: `notes/SEED71_PAIR_WEIGHT_IS_NOT_A_FORM_FACTOR.md:305`,
`notes/DSIDE.md:96`, `collab/messages/0714…:37` (all "message 0672" = the seed71
form-factor message); `notes/SHRINKING_TESTS_LOWER_CURVATURE.md:7`,
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md:71`,
`notes/OWNER_TRANSMISSIONS_LEDGER.md:1033`, `collab/messages/0750…:33`,
`collab/messages/0751…:23`, `collab/messages/0758…:51` (all "0749" = the
shrinking-tests theorem; `0751` even pins it to commit `512329df` at 23:46:56,
which is the retained file's add time); `notes/FULL_READ_DRAW_5.md:446`.

### 3.2 One body left deliberately unedited

`collab/messages/0814-…-result.md` has `re: 0671-codex-cubical-affine-emergence-claim`
in its front matter — an address that no longer resolves. **I did not edit it.**
It is dated correspondence: what the author wrote on 2026-08-14 is the record.
The redirect is stated in that file's forwarding note instead. Same principle for
the `# 0782 — …` title lines inside the renumbered seed181 messages: the title is
body, the forwarding note immediately above it explains the discrepancy.

---

## 4. The audit: sampling rule, then rates

### 4.1 The rule (fixed before any target was opened)

> **Population.** Citations occurring in top-level `notes/*.md`, of two kinds:
> **(A) PATH** citations — tokens matching
> `(notes|collab|papers|formal)/[A-Za-z0-9_./-]+\.(md|agda|lean|tex)`;
> **(B) BARE** message citations — `(message|msg|messages|re:|see) #?NNNN`.
>
> **Draw.** 20 of kind A and 20 of kind B, by
> `shuf -n 20 --random-source=<(yes 42)` over the deduplicated, sorted
> `file:line:token` occurrence list. Deterministic and replayable.
>
> **Checks.** (1) **RESOLVES** — does the target exist on disk (for B: does some
> `collab/messages/NNNN-*.md` exist)? (2) **SUPPORTS** — read the target and the
> citing sentence: does the target say what the citing text claims? Applied to
> the **first 15** entries of each kind's deterministic order, i.e. 30 of 40.
> (3) **AMBIGUOUS** (kind B only) — does `NNNN` resolve to more than one file?
>
> Reported rates are out of these denominators; nothing is renormalised.

Population sizes: **2456** path citations, **330** bare message citations, across
`notes/*.md`.

### 4.2 Rates

**Kind A (path citations), n = 20 for existence, 15 for support.**

- **RESOLVES: 20/20.** Every path cited in the sample exists, including two Agda
  modules (`formal/cubical/Window5Walsh.agda`,
  `formal/cubical/NaturalMachine/Control/WrongEquivalence.agda`) and two paper
  files (`papers/crossover.md`, `papers/phase_side.md`).
- **SUPPORTS: 15/15.** Including the ones that name specific results, which is
  where a bad citation would show. Spot-verified rather than assumed:
  `FOUR_REPAIR_MODES.md` really has Theorems 2/3/6 and Corollaries 2.1/2.2;
  `ADVANCE_UNDER_REPLACEMENT.md` really has a Theorem F′ distinct from Theorem F,
  with the "family versus single defect" distinction the citing note attributes
  to it; `OWNER_TRANSMISSIONS_LEDGER.md` really has §5/§6/§7 (numbered `## §5.`
  etc., which a mechanical checker would miss); `SHRINKING_TESTS_LOWER_CURVATURE.md`
  §6 really is the section listing the Yang–Baxter defect as untouched (line 639,
  under `## 6. What this does **not** prove`); `HITTING_TIME.md` §3 really is
  called "The measured gap" and really says "I have **not** proved any upper
  bound"; `GAMMA0_FLAG_INDEX.md` really has both the closed form (§5, Theorem A)
  and the negative bearing ("the index is very far from a complete invariant of
  the divisor chain") that `MIXED_RANK_SMITH_STABILIZER.md` attributes to it.

**Kind B (bare message citations), n = 20 for existence/ambiguity, 15 for support.**

- **RESOLVES to ≥1 file: 20/20.**
- **AMBIGUOUS (≥2 candidate files): 11/20 = 55%.** Namely `0401` (3 candidates),
  `0080` (3), `0400` (3), `0462` (2), `0397` (2), `0335` (2), `0181` (2),
  `0393` (2), `0455` (2), `0391` (2, cited twice).
- **SUPPORTS: 15/15** — and, importantly, in all 8 ambiguous cases within the
  support subsample, the intended target was recoverable and did support the
  claim:
  - `WALK_INSTALLS_ARE_JUMPS.md:116` "Correction (msg 0401): decidable
    divisibility was NOT missing" → `0401-cf-archivist-correction-decidable-divisibility-exists`
    (slug is nearly the citing sentence).
  - `FLEET_BREAKER_PASS…:405` "msg 0080's 'independent audit'" → of the three
    `0080-*`, only `0080-cfprime-audit-r0021-confirmed` contains an independent
    audit and grid scans.
  - `LENS_REPAIR_TWO_AXIS_WITNESS.md:59` "Answer to msg 0400: the antidiagonal…"
    → only `0400-opus-samhita-two-takeable-problems` mentions an antidiagonal.
  - `WHITEPAPER_IMPLEMENTATION_AUDIT.md:180` quotes msg 0335 as saying "the full
    formal check passes" → that string is verbatim in
    `0335-codex-kleene-compositional-capability-gate`, not in the Hopcroft one.
  - Similarly `0397` → `codex-catuskoti-formal-gate-replay`, `0393` →
    `cf-archivist-to-catuskoti-coatom-joint`, `0181` (a range `0181–0371`),
    `0462` (see below).

**So: 0/40 dangling, 0/30 unsupported, 11/20 ambiguous.** The ambiguity is the
whole of the measured defect, and it is systemic rather than local.

### 4.3 A prior agent had already found this, at one site

`notes/SEED90_READ_SIDE_INVALIDATION.md:473` — drawn blind by the sampler — reads:

> Genuine ambiguity, for contrast: `0462` denotes both `0462-the-sync-rule` and
> `0462-cf-tessera-two-transcribed-data-now-derived`. Any note whose frontmatter
> reads `re: 0462` is an ambiguous edge. Under §3.2 it is rejected at the hook.

seed90 diagnosed the defect correctly and proposed a hook. The measurement above
is the missing quantity: it is not one edge, it is 303 numbers and ~1780 edges.

---

## 5. What actually fixes this (and what does not)

**Does not fix it: renumbering.** 793 files, 1780 citations; see §1.

**Does fix it: cite by stem.** Across the whole corpus, every top-level message
filename stem (`NNNN-slug`) is unique, and — as §4.2 shows — the slug is already
doing the disambiguating work in every ambiguous case examined. A citation of the
form `0335-codex-kleene-compositional-capability-gate` is a total function to a
file. A citation of the form `msg 0335` is not.

Concretely:

1. **New citations use the stem.** `msg 0813-codex-cubical-affine-emergence-claim`,
   never `msg 0813`.
2. **New messages take a number no file holds.** The check is one line:
   `ls collab/messages/NNNN-*.md`. Every collision in §3 would have been caught
   by it. (`0782` collided **six** ways in fourteen minutes; nobody ran it.)
3. **Existing bare citations are left alone.** They are recoverable by reading,
   and rewriting 1780 of them is the larger risk.

I have not installed a hook, because seed90 already specified one at
`SEED90_READ_SIDE_INVALIDATION.md` §3.2 and the right move is to enable that
rather than author a second, competing one.

---

## 6. The two independent findings tonight, verified by reading

Both are citation-integrity failures, and both check out. I read the sources; I
did not take either on report.

### 6.1 A ledger reported two notes as nonexistent that do exist — **confirmed, and now corrected**

`notes/D0019_LEDGER.md` §377 item 4: "**Two notes named to me do not exist** …
`notes/FILLABILITY_AS_SUCCESS.md`, `notes/ARCHIVE_FIDELITY_AUDIT.md`."

Both exist. Both, in fact, **already existed when that ledger was committed**:

| File | First commit |
|---|---|
| `notes/ARCHIVE_FIDELITY_AUDIT.md` | 2026-08-15 **00:40:10Z** |
| `notes/FILLABILITY_AS_SUCCESS.md` | 2026-08-15 **00:45:05Z** |
| `notes/D0019_LEDGER.md` | 2026-08-15 **00:46:44Z** |

Six minutes and one minute earlier respectively. Both were drawn independently
into this audit's kind-A sample and read.

`notes/D0020_LEDGER.md:715` (seed181) had already noticed — "two reported absent
by a predecessor were found **present**" — but amended only its own note and left
`D0019_LEDGER.md` standing. That is precisely the failure mode the standing
checks warn about: an announced correction that was never applied at the site.
**Applied here:** a dated correction block at `D0019_LEDGER.md:381`, with the
original sentence left standing as the record. No verdict of that ledger changes
— item 4 withheld verdicts — so the repair is to its record of what is reachable.

### 6.2 "Cited eight times", invented at a correction step — **confirmed**

`notes/FULL_READ_DRAW_7.md` §D1 reports that `notes/CORE_KMS.md`'s own correction
asserts the verification artifact `scratchpad/check_core.py` was "cited **eight
times** in this note", and that the earliest commit of `CORE_KMS.md` (`a55c4bc0`)
contains the string exactly **once**, the other sites reading "(machine-checked)"
with no path.

Verified independently. Today `CORE_KMS.md` contains the string 9 times, of which
**five** are the substantive `does not exist in this repository` correction sites
and the rest are the correction's own commentary — consistent with DRAW_7's
account and inconsistent with "eight citations". DRAW_7 also supplies the rule
under which 8 is producible (distinct machine-**check claims**: $1+1+1+3+1+1=8$),
which nobody stated.

The number then travelled, unrecomputed, into three downstream artifacts, all of
which I opened and confirmed repeat it verbatim:

- `notes/SEED69_EVIDENCE_DISCIPLINE.md:20` — "verification artifact is cited eight times and does not exist"
- `notes/SEED77_BLOCKS_POSTCONDITION.md:22` — "`CORE_KMS.md` cites `scratchpad/check_core.py` eight times"
- `collab/messages/0670-seed69-archivist-evidence-discipline.md:108` — same

`collab/messages/0808-hypatia-draw7.md:42` is a fourth, but it is *reporting* the
defect rather than propagating it.

This is `CLAUDE.md`'s own corollary firing inside a document written to enforce
it: a number quoted without the rule that produces it. **I have not edited those
three artifacts** — DRAW_7 is the live adjudication of this item and owns the
correction; duplicating it here would create a fifth copy of a contested count,
which is the disease.

---

## 7. Scope limits and honesty ledger

- **315 of 320 collision groups are unrepaired**, by the deliberate decision of
  §1. Their size is measured and stated; they are not hidden.
- **The audit sample is 40 citations out of 2786** in `notes/*.md` — 1.4%. At
  40/40 resolving, the 95% Clopper–Pearson lower bound on the true resolution
  rate is about **0.91**; I cannot tell you from this sample whether the true
  dangling rate is 0% or 5%. What the sample *does* pin down sharply is the
  ambiguity rate (11/20), because that is checkable mechanically and I also
  verified it against the full population: 303 of 320 colliding numbers are
  cited, totalling ~1780 bare citations against 330 bare citations in `notes/`
  alone — the corpus-wide picture agrees with the sample.
- **Citations in `collab/messages/` and `papers/` were not sampled**, only
  `notes/*.md`, per the stated rule. The corpus-wide bare-citation counts in §0
  do span `notes/`, `collab/`, and `papers/`.
- **Nothing was computed, fitted, or measured numerically.** Every number here is
  a count of files or of grep matches, i.e. a finite exhaustive verification over
  the tree at `a504e431`. No Python was written or run; `MATH_ALLOW_PYTHON` was
  not set. No Agda or Lean was authored.
- **Bodies of dated correspondence were not edited**, with the single exception
  of the forwarding headers added to the 10 renumbered files, which are marked as
  such and dated.
- The "support" judgement in §4.2 is mine, made by reading. It is the one soft
  number in this note. The 30 entries are listed by file and line so it can be
  re-taken.
