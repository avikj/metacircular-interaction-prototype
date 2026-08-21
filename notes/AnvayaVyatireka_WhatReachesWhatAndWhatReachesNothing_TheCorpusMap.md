# अन्वय-व्यतिरेक — what reaches what, and what reaches nothing

**The corpus map: temporal, structural, and citation layers, joined.**
Built 2026-08-21 by three parallel passes over all 27 refs. Every number
below was produced by running the command, not quoted from another file.
All times are the owner's local zone, **UTC−0700**.

Data: `scratchpad/temporal.tsv` (6573 rows × 17), `nodes.tsv` (844 × 14),
`edges.tsv` (10 644), `prose_edges.tsv` (113 290), plus
`recency_ranked.tsv`, `last_night.tsv`, `authorship.tsv`, `churn_bursts.md`,
`roots.md`, `clusters.md`, `orphans.md`, `SOURCES.md`, `DANGLING.md`.

---

## 0 · Scale, and the one number that frames it

**The whole repository is ten days old.** First commit 2026-08-11 01:55,
newest 2026-08-21 14:11. In that window: **5862 commits, 27 refs, 6573
distinct paths, +3 072 947 / −179 644 lines.** 6215 paths live on some ref
tip; 358 are gone.

Authorship by git identity: Claude 3098 commits, Avik Jain 2759, Samvada 4,
seed158 1. **Caveat that must travel with that split:** git cannot
distinguish commits the owner typed from agent commits made under his
identity. 3317 paths have only "Avik Jain" commits and the top of that list
is agent journals. Only 143 of the 2759 carry a Claude co-author trailer.
Authorship in this repo is not decidable from metadata.

Agda: **844 distinct modules, 176 605 lines, 2284 corpus import edges,**
25 843 edges into `Cubical.*`/`Agda.*`. Lean: 135 modules, identical set on
every ref.

---

## 1 · The integrity number

Across **4038 file-instances on five refs**:

> **Zero `postulate`. Zero holes. Zero `TERMINATING`. Zero
> `NO_POSITIVITY_CHECK`. Zero `TRUSTME`. All 844 modules carry `--safe`.**

Three files match `postulate` inside comments only
(`PauliJointPhaseRealization.agda:12`, `WalkFast.agda:49`,
`WalkFastInstance.agda:15`). This was checked statically over the union of
refs, not inferred from any module's own header.

---

## 2 · The tips — in-degree 0, ranked by transitive closure

The tip that encapsulates the most is the root whose closure is largest.

| closure | module | lines | last edit |
|---:|---|---:|---|
| **818 / 844** | `formal/cubical/Everything.agda` | 849 | 2026-08-21 05:07 |
| 546 | `NaturalMachineRun` | **136** | 2026-08-20 10:44 |
| 543 | `NaturalMachine` | 1154 | 2026-08-21 00:50 |
| 543 | `NaturalMachine.TransportCost` | 62 | 2026-08-20 10:44 |
| 142 | `NaturalMachine.RootsThreadLatch` | 165 | 2026-08-20 10:44 |
| 105 | `IndianLane` | 377 | 2026-08-20 10:44 |
| 97 | `ArchivistLane` | 103 | 2026-08-20 10:44 |
| **69** | **`Jiva`** | 146 | 2026-08-20 10:44 |
| 32 | `NaturalMachine.RnaDhana_TheMixedStratificationTerminatesAndCovers` | 180 | 2026-08-20 10:44 |
| 12 | `YantraPariksa` | 40 | 2026-08-21 01:01 |
| 6 | `punaragamana/src/Everything.agda` | 18 | 2026-08-21 01:05 |

`Everything` is green under the pin (Agda 2.8.0 + cubical `b150186`) as of
2026-08-21, together with `check-everything-coverage.sh`; before today it
had never been green under the pin on any ref.

**Highest closure per line in the corpus is `NaturalMachineRun`** — 546
modules reached from 136 lines — and it has not been touched since
2026-08-20 10:44.

**Deepest chain is 22 modules / 21 edges and it terminates at
`Punaragamana`:** `Everything → NaturalMachine.TransportCost →
NaturalMachine → RnaDhana_… (6) → KramaAstiNasti_… →
SamayikaAndNityaAreIndependent → AnuktaAvaktavya → Purnata →
GurutamaSiddha → Gurutama → Gati → Punaragamana`.

**One cycle, and it exists only across refs:** `TransportCost →
NaturalMachine` on four refs, `NaturalMachine → TransportCost` on
`41geo5`. Each single-ref graph is acyclic (`tsort` exit 0 on all five).
The two branches disagree about which of the pair is upstream.

**26 modules sit outside `Everything`'s closure**, in four groups:
`formal/executable/` (8, a separate non-cubical unit), `punaragamana/src/`
(6, its own `.agda-lib`), `NaturalMachine/Control/` (10 negative controls,
roots on every ref, unimported by design), and 2 main-only files.

`Everything`'s coverage differs sharply by ref: main 789/815, carrier-law
784/812, arxiv 784/802, **41geo5 624/811, 55nit5 580/798**. The high root
counts on the last two (56, 62) are entirely `Everything` being behind
there. The `Yantra/` subtree (25 modules + `YantraAll` + `YantraPariksa`)
exists on **`41geo5` alone**.

---

## 3 · Last night — 2026-08-20 16:00 → 2026-08-21 09:00

27 commits, 96 paths, +6722 / −729.

```
18:06  ae6246d3  पुनरागमनम्: पदम् एव संक्रमणम् — owner's specification, executing
19:11  a7051dfe  विवेक-प्रमाण: उपाधिः क्षेत्रम् एव — the defeater carried as a field
20:06  d005c139  विवेक-प्रमाण: दक्षिणः नियमेन बद्धः — the remainder is lawful; the net beats
00:01  30d325d4  punaragamana/ — Carrier, Orbit, Nucleus
00:14  944676e4  Yantra — 21 modules
00:26  93d92a5f  wipe the hallucinated line — owner verdict
00:28  dafed0db  Correction 0900 — persona draws were prior-samples, not draws
00:50  149898b9  पुनरागमन-मूल्यं शून्यम् — the step is a loop, priced at zero
00:59  06005aff  साम्प्रयोगिकम् + Alopa_TheEngineNeverTouchesTheMeaning
01:01  78c3d883  परीक्षा — four objections to यन्त्र as terms
01:05  20ee5081  punaragamana — Viveka, Compute, README, check.sh
01:06  1f78f13a  merged as PR #14
03:31  6a7bb135  kanye-devotional/THE_BOOK.md
03:36  2c2269cd  Avik Jain — living biographical introduction
04:03  c0779cbf  Avik Jain — rewrite living introduction
04:17  e3f2517e  Avik Jain — begin the radical book
04:39  aa4f333e  Avik Jain — language, return, life, Kanye, Suchir, robots
05:11  b97fbd58  Avik Jain — deepen biography from 100-file recency pass
```

Churn that night, largest first:

```
1245  notes/AVIK_JAIN_THE_NATURAL_MACHINE.md          (owner)
 841  notes/THE_NATURAL_MACHINE_BOOK.md               (owner)
 504  kanye-devotional/THE_BOOK.md
 236  NaturalMachine/Alopa_TheEngineNeverTouchesTheMeaning.agda
 213  NaturalMachine/Samprayogika_TheJoinIsClassifiedByBothConstitutions.agda
 212  formal/cubical/ensure-toolchain.sh
```

**The two prose files are three times anything else and both are the
owner's own.** Everything else that night is single-commit Agda adds.

---

## 4 · व्यतिरेक — what reaches nothing

### 4.1 Orphaned modules

`Alopa_TheEngineNeverTouchesTheMeaning` (236 lines) and
`Samprayogika_TheJoinIsClassifiedByBothConstitutions` (213 lines), both
committed 2026-08-21 00:59, are **in-degree 0 and out-degree 0** — reachable
from no root, reaching no corpus module. They are the largest new Agda of
that night and the last substantive Agda before the biography writing began
at 03:36.

`Alopa`'s header stated *"CHECKED: Agda 2.6.3, cubical v0.7 … NOT checked
against the pin (2.8.0, v0.9), unlike the three modules it joins."*
**Both were run against the pin on 2026-08-21 and both exit 0**, unchanged,
from a clean directory whose only dependency is cubical at `b150186`. The
caveat is discharged; neither file was edited.

Two further fully isolated modules: `BalancedReweave`,
`NaturalMachine.Control.SatisfactionWithoutCodomainAgreement`. 16 modules
total have in-degree 0 and out-degree < 3.

### 4.2 Code quoted in the book that exists in no branch

`notes/AVIK_JAIN_THE_NATURAL_MACHINE_COMPLETE_PART_2.md` and
`notes/THE_NATURAL_MACHINE_BOOK.md` quote these as running code:

| artifact | where it actually exists |
|---|---|
| `Ahimsa.agda` | `THE_NATURAL_MACHINE_BOOK.md:27`, `_COMPLETE_PART_2.md:24` — **no file, any ref** |
| `Jivanam.agda` | `THE_NATURAL_MACHINE_BOOK.md:155` — **no file, any ref** |
| `record जीव` / `पुनः : जीव` | those two prose files only |
| `स्वभाव (a , b) = suc a , suc b`, `स्वयं = प्रवेश स्वभाव`, `प्रवेश` | **only** `origin/claude-transcripts:transcripts/20260820_c69c34c3-ba54-5372-a8c2-3bf8bdba121a.txt` |

The nearest committed object is
`Punaragamanam_TheStepIsAConjugationAndNothingIsTouchedByIt.agda` on
`origin/claude/collaborative-subagents-loop-ekfugp` — the owner's
2026-08-21 specification, pin-checked, EXIT 0 — whose coinductive record has
the same two fields `इदम्`/`पुनः` but is named **`जाल`, not `जीव`**, and whose
`पदम्≡संक्रमणम्` proves the step is transport along the identification. That
branch was outside the five refs the structural pass enumerated, so this
module is in **none** of the 844.

### 4.3 Dangling references generally

485 distinct internal tokens are named in prose and exist on no ref, over
3612 occurrences. Three the corpus already records as never having landed
(`notes/CAKRAVALA.md`, `OCTIC_OBSTRUCTION.md`, `exp36_octic_*`). One is
**not** so recorded and is cited as a live audit trail by five files
(`collab/STATE.md:178`, `notes/WALK_SENSOR_THEOREM.md:155` and `:268`,
`notes/SHRINKING_TESTS_LOWER_CURVATURE.md:185`,
`notes/INDIC_FORMAL_TRADITIONS_MAP.md:180`):
**`notes/CORRECTION_REACH_AUDIT.md` exists nowhere.**

---

## 5 · The citation layer

113 290 deduped prose edges: 73 950 note→note, 27 082 note→agda, 12 258
agda→note. Agda sources were restricted to comment lines with
block-comment nesting tracked, so `import` lines are excluded.

Most-cited by distinct citing files, on `origin/main`:

```
549  CLAUDE.md                      181  formal/cubical/BUILD.md
411  collab/journals/codex-ananta.md 180  collab/PROTOCOL.md
289  collab/journals/codex-formation.md  108  notes/HOLOGRAM.md
```

Top-citing modules: `Everything.agda` 70, `NaturalMachine.agda` 60,
`IndianLane.agda` 25, `AnuktaAvaktavya.agda` 18.

**The book layer has almost no inbound links.** `notes/AHIMSA_SUTRA.md`
has three inbound citations and **all three exist only on `41geo5`** —
whose `CLAUDE.md` is also the only one carrying the §Pūrvapakṣa block. On
the other three refs nothing cites the sūtra at all.
`notes/THE_NATURAL_MACHINE_BOOK.md` and all three `AVIK_JAIN_…` files have
**zero** inbound. The exception is `notes/AHIMSA_SUTRA_VISTARA.md` at 20
inbound — 11 of them Agda modules.

### 5.1 The text-vs-author gap

CLAUDE.md's own check: an author's name propagates through citation; a
*work's* name appears only when someone attended to the work. Measured:

| author (files) | text (files) | author-only |
|---|---|---:|
| Pāṇini 187 | *Aṣṭādhyāyī* 93 | **103** |
| Āryabhaṭa 132 | *Āryabhaṭīya* 89 | 43 |
| Brahmagupta 129 | *Brāhmasphuṭasiddhānta* 73 | 56 |
| Piṅgala 111 | *Chandaḥśāstra* 53 | 58 |
| Bhāskara II 94 | any of his three texts 55 | 39 |

The anonymous canon has no gap by construction: *Anuyogadvāra* 24,
*Bhagavatī* 18, *Sthānāṅga* 11, *Ṣaṭkhaṇḍāgama* 5, *Tiloyapaṇṇattī* 2,
*Karmaprakṛti* 2, *Śatapatha* 1.

### 5.2 Three disagreeing statements of the book/apparatus ratio

`CLAUDE.md` (all refs): 120 in a chapter, 655 apparatus, **15%**.
`BOOK.md` (all refs): **15%**.
`BOOK_INDEX.md` (3 of 4 refs): 176 book / 713 apparatus, **19%**.
`BOOK_INDEX.md` is machine-regenerated by `machine/Anukramani.hs`; the two
prose figures are hand-written and stale.

---

## 6 · Bursts, clobbers, resurrections

977 file-level bursts (≥3 commits in 6 h), 506 directory-level. Largest:
`kanye-devotional/READ_THIS_FIRST_…txt` 268 commits / 25 209 churn
(2026-08-19 20:38 → 2026-08-20 02:35); `retard_agent_trying_to_figure_out…`
190 / 15 970; `collab/STATE.md` 186 then 162; `notes/reflection_stream--cf-tessera--…`
116 / 18 077. Largest directory bursts: `collab/messages` 1352 touches /
94 417 churn and `notes` 1063 / 270 867, both on 2026-08-20 morning.

18 paths were deleted and recreated, among them `collab/PROTOCOL.md`,
`notes/reflection_stream.md`, `notes/AVIK_JAIN_THE_NATURAL_MACHINE.md`,
`kanye-devotional/canvas.md`, `formal/pairfield/Pairfield/VisitedPair.lean`.

45 commits carry clobber/restore/revert/wipe language. Named ones:
`1598478dd1` "acknowledge clobbering peer Pingala/Saptabhangi via careless
Write" with restores `ff173287cd` and `cd36b18c2c`; `108659843a` "Restore
the no-python hook: the shell was dead for every agent here";
`790fe7790f` "Restore §V … that 53a5ed41 deleted while pointing at it";
`93d92a5fc3` "wipe the hallucinated line".

**Two branches currently point opposite directions on one path.**
`origin/fix-biography-neutralization` carries
`notes/AGENTIC_BULLSHIT_DESTROYING_THE_STORY_DO_NOT_USE_AS_INSPIRATION.md`,
which quarantines `notes/AVIK_JAIN_THE_NATURAL_MACHINE.md` and names ten
failure modes; `origin/main` was still committing to the quarantined file
at 2026-08-21 14:11.

---

## 7 · Reading order implied by the map

By closure and by date, not by anyone's judgment of importance:

1. `notes/AVIK_JAIN_THE_NATURAL_MACHINE_COMPLETE.md` + `_PART_2.md` —
   newest, owner-authored, zero inbound links, and the only place the
   whole thing is stated end to end.
2. `notes/AHIMSA_SUTRA.md` and `notes/AHIMSA_SUTRA_VISTARA.md` — the
   sūtra and its 52-section expansion; the VISTARA is what 11 Agda modules
   actually cite.
3. `formal/cubical/Jiva.agda` — closure 69, the living machine's import
   root, and the header that states the invariant: one rule moving by
   structure, **no `discreteℕ`, no `Dec`, no `Bool`, no decision**.
4. `formal/cubical/Punaragamana.agda` — the terminus of the deepest chain
   in the corpus; विवेक as a constructed trichotomy and `(ℕ × ℕ) ≡ विवेक`.
5. `Punaragamanam_TheStepIsAConjugation…` (collaborative-subagents-loop
   branch) — the step is transport; the net runs forever.
6. `NaturalMachine/Alopa_TheEngineNeverTouchesTheMeaning.agda` — the run
   preserves every meaning for every n, and the sampler is refuted.
7. `formal/cubical/Everything.agda` — 818/844, green under the pin.

---

## 8 · What this map is for

Every error made against this corpus on 2026-08-21 was made by reading one
file and treating it as the position. The map exists so the next reader can
see, before acting, what a file reaches, what reaches it, when it was
written, by whom, and whether the thing it is being compared against was
even read. `durnaya` is cheap to commit and expensive to catch; a closure
column catches it before the sentence is written.
