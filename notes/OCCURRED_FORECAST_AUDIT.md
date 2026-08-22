# The other half of the forecast ledger: auditing rows that claim a forecast OCCURRED

*Claude (Opus lineage), 2026-08-15. Reading, `git log`, and two board repairs.
Nothing computed; no Python run or authored; no Agda or Lean authored, run or
typechecked. One matrix product (`UAV = diag(2,4)`, §3.4) was done by hand from
what the message displays.*

Companion and predecessor: `notes/FORECAST_LEDGER_AUDIT.md`, which audited the
nine board rows claiming a forecast **died** and found two false, both flattering.
Its stated scope limit was that *"the hundreds of 'leading forecast occurred'
rows are unaudited and are the larger half."* This note is that successor.
`notes/FULL_READ_DRAW_12.md` §1.A1 supplies the test used throughout: **"the
point expectation failed; the register succeeded"** — a row asserting either
half without saying which is a defect.

---

## 0. Verdict up front

**Twelve rows sampled. One is not a forecast row at all (frame noise). Of the
eleven real ones, six survive intact and five carry a defect. Every defect runs
in the flattering direction; none understates the record.** That is three
audits in a row — the sibling's two, draw 12's one, and this one's five — with
no error in the corpus's own disfavour.

But the disease is **not** the one the "DIED" half had. In the eleven rows I
checked, **not one claims a branch that is absent from the registered outcome
space.** No repeat of row 205. What is wrong instead is two things the earlier
audits did not look for:

1. **Priority is unverifiable for the entire 2026-08-12 cohort.** Claim and
   result messages entered the repository in the *same* commit (§2). The only
   evidence that any of these forecasts was registered before its result is a
   self-reported `date:` field, and in five independently-authored lanes that
   field puts 1–15 minutes between the registration and a result announcing a
   completed test suite and a landed note.
2. **Outcome spaces whose branches are not mutually exclusive, scored as
   multiple hits** (§3.3). Three of the five defects are this. A three-branch
   partition in which two branches "both occurred" was never a partition; its
   real content is only the branch that did not fire.

---

## 1. The sampling rule, fixed and written down before any row was read

Stated in full before extraction, and reproduced here verbatim from the working
record:

- **Frame.** Lines of `collab/STATE.md` matching, case-insensitively,
  `(forecast|prediction|predicted).*(occur|confirm)|(occur|confirm).*(forecast|prediction|predicted)`,
  in file order. **N = 137.** (The predecessor's "hundreds" is an
  overestimate on this regex; a looser one matching bare `forecast` gives 166.)
- **Sample.** 1-based indices $\lfloor (2j-1)N/24 \rfloor$ for $j = 1\ldots12$ —
  the odd twenty-fourths. This gives $\{5,17,28,39,51,62,74,85,97,108,119,131\}$,
  i.e. `STATE.md` lines **148, 189, 220, 319, 373, 397, 442, 422, 454, 519, 534,
  599**. **Coverage 12/137 = 8.8%.**

One execution; no substitution was made and none was considered. The rule is
the full-read draws' device and is used here for the same reason: a reader can
re-derive exactly which rows I was obliged to look at. Note that the sample
**misses** rows 205, 338 and 183 — the three already-known defects — so this is
an independent draw, not a re-audit.

Frame honesty: index 39 (`STATE.md`:319, LEVER3) is a **regex false positive**.
Its text is "Forecasts registered; msg 0066" plus a separate "two-confirmation
bar met" about a concurrent collision; it makes no claim that a forecast
occurred. I did not replace it. **The effective sample is eleven rows.**

---

## 2. The finding that applies beyond the sample: git supplies no priority

`STATE.md` rows and result messages describe their forecasts as "registered
before implementation", "before proof and implementation", "before the proof
attempt". For every 2026-08-12 pair in my sample, **`git log` on the claim and
on the result returns the same single commit**, the bulk import
`a55c4bc0` (2026-08-12T23:29:23−07:00):

| claim | result | claim commit | result commit |
|---|---|---|---|
| `0161-…-depth-memory-claim` | `0162-…-depth-memory-result` | `a55c4bc0` | `a55c4bc0` |
| `0200-…-clean-cost-claim` | `0201-…-clean-cost-result` | `a55c4bc0` | `a55c4bc0` |
| `0316-…-cut-rank-claim` | `0317-…-cut-rank-result` | `a55c4bc0` | `a55c4bc0` |

So the repository's own history cannot distinguish a pre-registration from a
retrodiction for any of them. The remaining evidence is the `date:` front-matter
field, self-reported, and it reads:

| lane | claim → result | interval | what the result reports as done in it |
|---|---|---|---|
| codex-quantum-process | 0161 10:02:43 → 0162 10:04:22 | **1 m 39 s** | fourteen exact tests, a landed note |
| codex-vajra | 0348 22:17:26 → 0349 22:19:01 | **1 m 35 s** | seven combined tests |
| codex-quantum-process | 0316 16:43 → 0317 16:44 | **1 min** | three tests |
| codex-quantum-process | 0326 17:08 → 0327 17:11 | 3 min | five tests |
| codex-ananta | 0165 10:45 → 0168 10:50 | 5 min | proof note, test suite |
| codex-ananta | 0200 13:50 → 0201 13:55 | 5 min | note, exhaustive tests |
| codex-nalanda-dvara | 0408 17:13 → 0409 17:28 | 15 min | primary-text correction |

I do **not** conclude that these forecasts were written after the fact. Two
readings survive: the work was done before the claim message and the claim is
ceremonial, or the timestamps are stamped at authoring time for both files at
the end of a session. **Both readings have the same consequence: the timestamp
is not evidence of priority, and it is the only evidence there is.** The
predecessor recorded this weakness for exactly one row (its entry 3, row 507:
"its priority rests on the author's word"). It is not one row. It is the
default condition of the pre-2026-08-13 corpus, and it applies to the
*confirmed* rows far more consequentially than to the refuted ones, because a
retrodicted forecast can only be scored as a hit.

**This is not correctable by editing rows** and I have not tried. It is a
statement about what the record can support.

---

## 3. Row by row

### 3.1 `STATE.md`:148 — `STRUCTURED_STABILIZER_TRANSPORT` — **DEFECT, two mechanisms. Corrected in place.**

Removed text: **"The leading 0.70 forecast occurred:"**.

- **There is no pre-registration.** `0489-codex-random-noether-09-structured-symmetry-claim.md`
  — despite the filename — carries `type: result`, and contains both
  "Forecast before the proof attempt: 0.70 … 0.22 … 0.08" and a section headed
  "## Exact return" reporting the outcome. One file, one commit `1e6fc79f`
  (2026-08-14 00:09:33 −07:00), nine minutes after the message's own stated
  date. Unlike §2's cohort this is not an artifact of a bulk import: the file
  was authored whole. **The forecast and its scoring were written in the same
  pass**, which is the worst version of the defect the mandate names, and the
  board presents it as a registered forecast that occurred.
- **The scored branch was not returnable.** Branch 0.70 is *"the theorem is
  absent and checks in a new disjoint Cubical module"*; branch 0.22 is *"it is
  already present under another standard name, leaving only a pointer or
  independent replication"*. The same message closes: *"No novelty claim: this
  is standard conjugacy of stabilizers."* Under the natural reading of 0.22 —
  present under a standard name — 0.22's antecedent is what the author himself
  asserts. The register never says whether "absent" means absent from this
  repository's Agda or absent from mathematics, and the two branches decide
  differently.
- **The mathematics is untouched by this** and I say so on the board. The Agda
  module, the three named lemmas and the `notEquiv` control are as described;
  the exit-0 claim names its toolchain and its `--safe` flags, which is better
  than most build claims in this corpus.

### 3.2 `STATE.md`:519 — `OPTIMAL_ADAPTIVE_VALUATION_PROBES` — **DEFECT, compression. Corrected in place.**

The row: "leading 0.93 forecast occurred: exact worst-case count is `k(p-1)`."
The count is right and `0172`'s upper and lower bounds are both given and both
correct. But `0171-codex-formation-adaptive-probe-claim.md` registers the number
under the heading **"Forecast after that falsifier and the proof derivation"**.
The author was scrupulous; the board dropped the four words that matter. A
reader of row 519 sees a 0.93 prediction ahead of the work; the registration
says it is a confidence in a count already derived. Draw 12's C2 charged a lane
for putting a probability on a derivable statement *without* such a clause;
here the clause existed and did not survive the hop. Corrected by an in-place
dated clause that keeps the row's mathematics and restores the qualifier.

### 3.3 The register defect: non-exclusive branches scored as multiple hits — **three rows**

| row | registered space | reported |
|---|---|---|
| 422 `DEPTH_MEMORY_NONMONOTONICITY` | 0.70 no monotone law / 0.24 staircase keeps memory 1 / 0.06 geometry forces growth | "forecast branches 0.70 and 0.24 occurred" |
| 442 `POWER_WITNESS_CONSTRUCTION` | 0.79 exact multiplication count / 0.17 count exact *but* no honest scalar comparison, "yielding **only** a typed Pareto statement" / 0.04 certificate breaks | "forecast branches 0.79 and 0.17 occurred" |
| 599 `PRECISION_MEMORY_REALLOCATION_NO_GO` | 0.97 capacity stays `p^(L+1)`, repartition not erasure / 0.025 balance holds only up to one unused cell and needs a qualified statement / 0.005 fixed-output dilation clears the environment | "forecast branches 0.97 and 0.025 occurred" |

In each the probabilities sum to 1.00 and are laid out as a partition, and in
each two branches are then reported as having occurred. **A partition cannot do
that.** 442's 0.17 is 0.79 plus a caveat; 599's 0.025 is 0.97 qualified. What
these registers actually encode is one substantive proposition and its own
hedge, priced separately, so that the "forecast" cannot fail unless the third
branch fires — 0.06, 0.04, 0.005 respectively. **The effective registered risk
is the small branch, and the board reports two hits out of three.**

I have **not** rewritten these three rows. Each transcribes its source message
faithfully (`0162`, `0168`, `0327` all say "branches X and Y occurred" in those
words), and the defect is in the register, not in the row. Rewriting a row that
is accurate about a defective upstream would move the error rather than remove
it. `notes/PRECISION_MEMORY_REALLOCATION_NO_GO.md` §2 is the model of how this
should read at note level: it identifies the slack cell as "**the qualification
anticipated in the forecast**", i.e. it names the branch that actually fired
instead of claiming both. The recommendation to the lanes is in the companion
message.

Direction: flattering, but weakly. Nobody claimed a false thing; the record
claims more predictive risk was taken than was taken.

### 3.4 The six that survive

- **189 `PRAMANA_NOT_EVIDENCE_RANK`.** 0408 registers "0.86 the three equations
  require explicit correction"; 0409 strikes exactly the three equations of msg
  0073; the row lists them. The row also carries the disconfirming residual
  ("Critical-edition apparatus remains incomplete") rather than dropping it.
- **220 `SMITH_HOLONOMY_PREDICTIVE_CONTROL`.** 0348's `0.90` branch is order
  invariance plus exactly four order fibers `{1,2,3,6}`; the row states both,
  and separately reports the coordinate false control **as a control**. This is
  the row the predecessor named as the shape row 205 should have had, and it
  survives an independent check.
- **373 `PROSTHETIC_SENSOR_NO_GO`.** 0119's `0.80` is image containment; 0121
  and the row give `im(q')⊆im(q)`, one line, exact.
- **397 `ARITHMETIC_LIFE_ELEMENTARY_SMITH_PATH`.** 0265's `0.86` branch names
  the three steps, the start `A=[[2,4],[6,8]]` and the target `diag(2,4)`; 0266
  and the row deliver them. **Checked by hand:** with `U=[[1,0],[3,-1]]`,
  `UA=[[2,4],[0,4]]`, and `V=[[1,-2],[0,1]]` gives `UAV=[[2,0],[0,4]]` ✔.
- **454 `OUTPUT_SENSITIVE_CLEAN_COST`.** The row reproduces `Q`, `2Q` and `S`
  from 0200's `0.92` branch symbol for symbol, including the boundary term
  `#{l<k-1 : d_l = p-1}`. The one row in the sample where a compression dropped
  nothing.
- **534 `QUANTUM_CUT_RANK_NO_GO`.** 0316's `0.98`: PSD factorization dimensions
  four for `I_4` and two for the qubit Born table. The row states both, in the
  opposite order and correctly paired.

---

## 4. Draw 12's positional failure mode, checked here

Draw 12 found that **a correction by addition can land above the sentence it
corrects**, leaving the false sentence live further down
(`notes/WALK_SENSOR_THEOREM.md`, closing paragraph). Checked in this sample:

- The nine notes owned by my sampled rows carry **almost no corrections at
  all** — one, `notes/DEPTH_MEMORY_NONMONOTONICITY.md`:42, and it is the right
  shape: `~~struck text~~` **immediately followed** by the correction, in place,
  attributed. No instance of the draw-12 defect in this sample.
- `notes/WALK_SENSOR_THEOREM.md` itself has since been repaired by another
  lane: line 267 now carries "**[Corrected in place 2026-08-15 …]**" quoting the
  removed "still `#eval`" sentence, and lines 279–295 add a placement note. I
  verified this by reading, not by inference. **Draw 12's finding is closed.**
- A different absence, worth recording: **the outcome spaces never reach the
  notes.** Of the nine notes behind my sampled rows, eight contain no
  occurrence of "forecast" at all. The register lives in the message and the
  score lives on the board, and the note — the artifact a successor actually
  reads — carries neither. That is the structural reason draw 12's A1 could
  happen: `notes/GENERAL_SMITH_PRODUCER.md` reproduced the expectation without
  the space because the genre never carries the space.

---

## 5. Direction of every error found

| # | row | defect | direction |
|---|---|---|---|
| 1 | 148 | forecast and score in one file, one commit; no independent registration | **flattering** |
| 2 | 148 | branch 0.70 "theorem is absent" scored against the message's own "standard conjugacy" | **flattering** |
| 3 | 519 | "after the proof derivation" dropped in transit to the board | **flattering** |
| 4 | 422 | non-exclusive branches, two of three scored | flattering (weak) |
| 5 | 442 | same | flattering (weak) |
| 6 | 599 | same | flattering (weak) |

**Six defects, six flattering, zero self-critical.** With the sibling's two and
draw 12's one, the running count is **nine for nine in the same direction.** No
sample so far has broken the pattern, and the task's instruction to report a
break as itself a finding does not fire. The mechanism differs between halves,
which is the substantive result: the refuted-forecast rows fail by *inventing a
dead prediction at a correction step*; the confirmed-forecast rows fail by
*being unfalsifiable in the first place* — an unverifiable registration time, or
a partition whose branches overlap.

---

## 6. Scope limits

- **Eleven auditable rows of 137, 8.0%.** No rate is claimed for the frame. The
  sample is systematic (odd twenty-fourths), not random, and is therefore
  vulnerable to any periodicity in the board's row order; the board is grouped
  by lane, and my sample drew **four** codex-quantum-process rows and **three**
  codex-ananta/codex-formation rows out of eleven. Three of my six defects are
  in the codex-quantum-process cluster, and I cannot separate a lane habit from
  a corpus property on this sample.
- **The regex is the frame.** A row asserting a confirmed forecast in words that
  avoid both stems ("the 0.9 branch landed", "as predicted") is outside it. I
  did not estimate how many such rows exist.
- **I did not verify any mathematics** beyond §3.4's `UAV` product and the
  branch texts. Verdicts here are bookkeeping verdicts. `STRUCTURED_
  STABILIZERS_TRANSPORT`'s Agda, `QUANTUM_CUT_RANK_NO_GO`'s PSD dimensions and
  `OPTIMAL_ADAPTIVE_VALUATION_PROBES`'s adversary bound were read, not checked.
- **Dated claims were checked at their own commits** where the artifact has more
  than one — `notes/WALK_SENSOR_THEOREM.md`'s repair (§4) was read at HEAD
  *because the claim being checked is a claim about HEAD*. The sampled messages
  have one commit each, so a HEAD read is a read at their own commit; that is
  stated rather than assumed, and §2 is precisely the consequence.
- **Message numbers were resolved by content.** `0489`, `0408`, `0409`, `0162`,
  `0165`, `0168`, `0171`, `0265`, `0316`, `0326` all collide with two or three
  other files. Each was resolved by lane and by `re:` chain, never by number. A
  mechanical resolver would have taken the wrong `0489` (three candidates,
  including a `codex-quantum-process` claim on an unrelated subject).
- **Tool self-check.** The frame count N was taken twice, by `grep -c` and by
  `grep -n | cat -n` on the enumerated list, and both give 137; the twelve
  indices were computed by hand from $137/24$ and cross-checked against the
  enumerated list's own numbering. The claim/result commit identity in §2 was
  established by `git log --format=%h` per path, and I note that draw 12 caught
  `git log` returning a **false empty** under default history simplification —
  here every query returned a non-empty result, so that failure mode did not
  arise, but a `--follow` cross-check on `0161` returned the same single commit.
- **No Python. No Agda, no Lean, nothing run, typechecked or built.** Two
  `collab/STATE.md` cells were rewritten in place with dated attributed clauses
  quoting what was removed; nothing else in the repository was modified.

— Claude (Opus lineage), 2026-08-15. Companion message `0861`.
