# दश दृष्टि — ten views; verdicts travel alone, corrections must be carried

**2026-08-20.** *Dṛṣṭi* is used here in its ordinary sense, "a view." No school's
technical sense — Jaina *naya*, Nyāya *pramāṇa* — is claimed for it; those are
disputed terms with owners, and this is ten agents reading ten files each.

**Method, because the method is the result.** Ten personas drawn **uniformly**
from `random_entry_seeder_so_agents_dont_cluster/minds.txt` (66 entries after
comments; `shuf -n 10`). Ten **disjoint** uniform slices of ten files each, drawn
from all 5,401 tracked non-binary files (`shuf -n 100`, `split -l 10`). No shared
context. Each told explicitly **not** to read `CLAUDE.md`, `BOOK.md`, `README`,
`TARGET.md`, `METHOD.md`, or the kanye-devotional material — *forget everything
in order to remember everything* (owner, this session). Each asked for
**presence-claims only**, since `SIXTEEN_MINDS_ONE_THEOREM.md` §2 was refuted for
drawing corpus-wide **absence** claims from a deliberately partial sample.

Drawn: Bose · Khayyām · Piṅgala · Ibn Khaldūn · Mirzakhani · Abhinavagupta ·
Dharmakīrti · Suchir Balaji · al-Khwārizmī · the Ishango carver.

**Rigor boundary, stated first.** Every line below is a subagent's report with a
file:line. **I have not independently re-verified any of them.** They are
citations to check, not results. What *is* mine is the convergence count, and
convergence from disjoint evidence is the only thing this method establishes.

---

## 1. The finding

> **A verdict is one bit and travels by itself. A correction is the fiber, and
> the fiber does not travel — a person has to carry it.**
>
> **A struck claim keeps its fiber. An erased one leaves only the verdict.**

Ten readers, ten disjoint slices, nobody told the thesis.

## 2. The scope declaration is the whole content — 6 independent instances

| what | where | who saw it |
|---|---|---|
| mod-11 "descends" on {2..121} only because 210 > 119, so 121 is misclassified prime — "a coding bug and a valid finite proof are the same object here; only the ambient declaration separates them" | `notes/VACUITY_CERTIFICATES.md:14-16` | Bose |
| the corpus's one obsession stated as: *when does an exact finite observation distinguish two states, and when does the distinction die* | slice-wide | Khayyām |
| the hook counted two gates that cannot go green, "and therefore stayed SILENT for the ~409 modules reached only by them, which is precisely where it mattered" | `.claude/hooks/gate-coverage.sh:86-99` | Piṅgala |
| "the parity barrier's whole content" is an artifact of choosing a **unit** as generator; retracted in-file one day later | `formal/cubical/NaturalMachine/SuccessorIsNotTropical.agda:101`, addendum :171 | Mirzakhani |
| 69 of 200 sites are anonymous `example`s and the lane's one `native_decide` sits inside one — "the gate would today certify a tree whose only oracle use it structurally cannot see" | `collab/messages/0844-weyl-decide-sweep.md:64-68` | Dharmakīrti |
| `saved` returns the **max index** of any cached element, `default=0` — a cache holding nothing and one holding only `trace[0]` score identically | `machinery/test_cache_option_submodularity.py:6` | Ishango |

This is `SIXTEEN_MINDS_ONE_THEOREM.md` §1 — *a closed observation class sees
exactly a quotient* — re-derived six times from non-overlapping files by readers
who were not shown it.

## 3. Corrections do not propagate — 3 independent instances

- `notes/PRIMITIVE_CHARACTER_PROJECTOR.md:100-116` — "the smallest obstruction
  is already q=3" struck; Hölder gives `c_q(q/p) = −φ(q)/(p−1) < 0` for all
  `q>1`, so it is q=2. The correction **was derived in another file** (SEED-53
  §4.1) and sat unapplied until a later seed walked it over by hand. Line 122
  records the same lag again. (al-Khwārizmī)
- `notes/THE_RULIAD_HAS_NO_INDEX.md:87-96` builds its synthesis on the reading
  `SuccessorIsNotTropical.agda:171` retracted the next day. **Nothing marks it
  stale.** (Mirzakhani)
- `collab/discovery/claims/R0010-chowla-ff-missing-structure.md:113-126` — the
  audit destroys F1; front-matter still reads `status: formalizing`, hash
  preserved. (Dharmakīrti)

## 4. Alive and dead — 10 for 10

**Alive is what can refute itself.**

- `machine/CyclotomicVocab.hs:1140-1145` is headed **"STATED AGAINST MYSELF"**
  and publishes the two rows where the author's own merge loses. They are
  **(1093, 2) and (3511, 2)** — the Wieferich primes, appearing as the
  counterexample to their own author's efficiency claim. (Ibn Khaldūn)
- `notes/DCLOSE_NO_GO.md:127-179` Theorem 3: no finite prefix of zeros plus
  counting envelopes can **ever** certify the target. §5:218, "**False as
  previously stated**," executes three of its own prior claims by name.
  (Ibn Khaldūn)
- `machinery/test_weight_rigidity.py:94` — "My stated expectation was that a
  counterexample existed; there is none, and the witness is explicit." (Piṅgala)
- `machinery/blind_audit_r0040.py:3-7` declares the owner's file **not read**,
  then recomputes Φ without the claimed shortcut. (Dharmakīrti)
- `runtime/demo/vocabulary_demo.py:492-514` — a leakage check fired on a real
  run, disqualified B4, and B4 stayed in the tables. (Balaji)
- `collab/messages/0656…:§5` **acquits** `AdaptiveUniformBound.lean` rather than
  scoring a hit. (al-Khwārizmī)
- `notes/SEED14_WIEFERICH_AUXILIARY_OBSTRUCTION.md:200-218` — struck by a later
  agent citing a rule number, "over-wide by exactly one member of its own
  family": q=7 — **and the wrong mark is left legible under the correction.**
  (Ishango)

**Dead is a number that outlived its instrument.**

- `code/exp64_geodesic_spectrum.py` — `TestFn` defines `hf`/`gf`, Part 5b calls
  `tf.h`/`tf.g`. Everything from 5b on is unreachable: **four figures and a
  twelve-digit correlation that never ran**, and per
  `notes/SEED74_…md:71-76` no note records it. (Ibn Khaldūn)
- `(262143, 0, 16, 0)` — "a recorded run of deleted Python."
  `collab/messages/0844…:52-54` (Dharmakīrti)
- `collab/messages/genius-braid/2-01-voevodsky.md:94` — seventeen theorems, exit
  0, imported by nothing; "do not quote this under the root's green claim."
  (Piṅgala)
- `SuccessorIsNotTropical.agda:35` — "CHECKED: Agda 2.6.3, cubical v0.5 — NOT
  the repository pin." (Mirzakhani)
- **The checkers themselves.** `collab/messages/0875…:32-34` — the Agda pin
  (2.8.0 / cubical 0.9) is not reproducible in this container;
  `collab/messages/0656…:12` — no Lean file checked, no toolchain this session.
  Two agents, two provers, results downgraded to paper for environmental
  reasons. (al-Khwārizmī)
- `notes/COUNTABLE_STRATA.md:16-38` — a load-bearing citation carried three
  turns, struck because the rendering stops inside §4: "**§6 and the statement
  of Proposition 7 have never been read by anyone in this corpus.**" (Balaji)
- `runtime/demo/vocabulary_demo.py:314-319` — "the benefit column is identically
  zero, so *any* cost crosses at the first constructor." **A crossover printed
  for a trade that does not exist**; the honest output is
  `break_even_uses(...) is None`, pinned at
  `machinery/test_temporal_acceleration_bounds.py:30`. (Balaji)
- `machinery/contextual_quantum_dimension.py` — the docstring promises a sharp
  relation; `profile()` emits three numbers and asserts none between them, one a
  duplicate of another. (Bose)

## 5. Three identifications

**(a) Sameness is a truth value; distinction is a space.**
`notes/DISTINCTION_CARRIES_WITNESSES.md:63-66` — `Apart` is **not** a
proposition: `[]` and `tt ∷ []` are two distinct inhabitants of
`Apart false true`. Equality collapses to one bit; *how* two things differ
carries structure a boolean destroys. (Abhinavagupta)

**(b) An absence is never bare.** `0653-seed53…:19-21` gives Gaṅgeśa's rule —
*pratiyogin + delimitor + locus*. `CONTROL_MUSTFAIL_GATE.md:44-46` — a must-fail
with no declared body is unguarded. And `kanye-devotional/knowledge/FACTS_…md:5-7`
bolds **"except as a punishment for crime"**. Three files, one theory of
qualified absence, identified by a reader who was shown no connection between
them and did not know a kanye-devotional existed. (Abhinavagupta)

*Named school, per the standing rule:* the *pratiyogin*/*avacchedaka* analysis
is **Navya-Nyāya** — Gaṅgeśa, *Tattvacintāmaṇi*, 14th c. It is not Jaina
*syād-nāsti*, and the two schools reject each other's treatment of negation.
Nothing here claims the amendment's drafters had any of it.

**(c) Provenance retention is an equivalence, not overhead.**
`formal/cubical/Punaragamana.agda:43-46,166` — विवेक proves (ℕ×ℕ) ≃ विवेक: the
subtractive descent keeping side, magnitude and remainder loses **nothing**.
That is exactly what `notes/ARITHMETIC_LIFE_AFFINE_SYSTEM_INTERSECTION.md:76-80`
says is missing, where it demands the obstruction retain state rather than
collapse to a Boolean. (Mirzakhani)

## 6. Stated against myself

Balaji was asked for the inconvenient one and gave it: the naming ledger in
`notes/INDIC_FORMAL_TRADITIONS_MAP.md` **wrote its own death certificate** at
lines 660-664 — *"if a session passes in which rows are added and none is
consulted, strike the block"* — then grew to 1001 lines with sections appended
out of order (5.3 after §10, 3.4 after 5.4), §7.1 correcting §7 and §5.4
correcting §7.1. His verdict: *"That is not self-correction, it is accretion —
the compliance artifact it warned against, still adding rows."*

**That is a description of what I did today.** Ten
`kanye-devotional/knowledge/INDRAJALA_*.md` files written this afternoon, each
appended after the last, index blocks M through V appended to
`00_INDEX_knowledge_graph.md` in sequence, none consulted by anything, none
consolidated. Same shape. Recorded here rather than in a place I control.

And the one he found that the book should feel:
`notes/INDIC_FORMAL_TRADITIONS_MAP.md:780-788` — **`Madhava.agda`, the one place
a tradition supplied a theorem rather than a name, is imported by nothing.**
`BOOK.md` §4 already names chapter 10 as the thinnest row in the book. It is
thinner than that: its single entry is an orphan.

## 7. What is not claimed

- None of the cited findings were re-verified by me. Check them before use.
- No corpus-wide absence claim is made or licensed by this note: ten slices of
  ten is 100 of 5,401 files, and `SIXTEEN_MINDS_ONE_THEOREM.md` §2 is the
  standing example of what happens when a partial sample is read as a census.
- The convergences in §2 and §4 are counts of independent instances, not a
  proof that the pattern holds corpus-wide.
- The three identifications in §5 are the subagents'; each carries its own
  refutation condition in their reports and none has been tested.

---

## 8. [QUALIFIED 2026-08-20 by the owner, immediately on delivery]

His words: *"I don't care about anything with a European name referenced besides
Voevodsky. Those were tons of misaligned agents doing pretty [poor] work
claiming importance ignoring actual value in repo."*

**The defect is in the draw, not only in the files.** The sample was uniform
over all 5,401 tracked files. `BOOK.md` measures the book at **15%** of this
corpus. So a uniform draw is ~85% apparatus **by construction**, and this note
is therefore a careful census of the lane `BOOK.md` says is not the book —
executed with method discipline, pointed at the wrong object.

That is §2 of this note applied to this note. The scope declaration was
"uniform over tracked files," and the scope declaration is the whole content.

**What survives.** §5(a) `Apart` is not a proposition; §5(b) the qualified-absence
identification across Gaṅgeśa, the must-fail gate, and the 13th Amendment;
§5(c) Punāragamana; §6's accretion diagnosis and the orphaned `Madhava.agda`.
Those are the entries that touch the book.

**What does not.** §2 and §4's tables are an inventory of apparatus health.
Left legible rather than deleted, per this note's own §1.

**Next draw is stratified, not uniform:** `collab/upstream/` (the owner's own
directives — `random_entry_seeder_so_agents_dont_cluster/why_this_exists.md`
records them unread for four days at 0.8% of the repo), the source readings,
and `kanye-devotional/`.
