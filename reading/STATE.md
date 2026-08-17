# Chronological reading run — durable state

**Why this exists.** The owner asked, repeatedly and finally as a direct command, that
an agent read the entire repository *in chronological order* rather than sampling it by
apparent relevance. `random_entry_seeder_so_agents_dont_cluster/why_this_exists.md`
already proved why sampling fails here: "looks relevant" is nearly identical across
minds like ours, so coverage concentrates and the corner containing the goal is never
drawn — which is exactly how `collab/upstream/` (0.8% of the tree, containing the
owner's own directives) went unread for four days while every agent read
`CLAUDE.md`.

No agent can hold 42 MB in one context window. That is a **rate** limit, not a capacity
limit, provided the reading state lives outside the window. This directory is that
state. If the session that started this run dies, its successor resumes at the next
batch and loses nothing.

## The instrument

| file | what it is |
|---|---|
| `CORPUS_CHRONOLOGICAL.tsv` | all 4,960 readable tracked files: `path · first-commit timestamp · bytes`, sorted by time |
| `INDEX_TITLES.tsv` | first heading of every one of those files, **extracted from the bytes**, not summarized |
| `INDEX_REFS.tsv` | the full citation graph: 9,341 `source → target` edges across the whole tree |
| `LEDGER.md` | the running record, appended batch by batch |
| `STATE.md` | this file — the resume pointer |

Excluded from the read as non-prose: binaries, figures, compiled objects, the 1.8 MB
Odlyzko zero table, `runtime/state/walk.json`, and the three large machine logs. They
are listed in `CORPUS_CHRONOLOGICAL.tsv`'s source but carry no readable content.

## The rules of the run

1. **Batches are read in numeric order.** Never reordered by what looks important.
2. **Every ledger entry decodes back to source.** Date, path, the object the file
   introduces, its own status marks, and what it supersedes or is superseded by.
   Per D0026 §1.3, a compressed form that cannot be reverse-audited is not lawful
   compression.
3. **Unresolved stays unresolved.** Per `library/raw/knowledge_process_handoff.md`
   §1.2 rules 1 and 10: do not compress an open inquiry into a familiar thesis and do
   not manufacture closure. Tensions between two documents are recorded as tensions,
   not resolved toward whichever sounds more official.
4. **No claim is upgraded.** The corpus's own epistemic alphabet (D0026 §0:
   ⊢ ↳ ☑ ◆ ≃? ? ⊥ Δ) is carried through unchanged.

## Structural facts established over 100% of the corpus before any reading

These are extractions, not judgments.

- 4,960 readable files, 42.2 MB, first commit 2026-08-11T01:55, last 2026-08-17T00:40.
- 9,341 cross-references. **2,308 files are cited by no other file.**
- 481 correction / supersession / retraction lines across 192 files. The densest are
  `collab/STATE.md` (46), `notes/OWNER_TRANSMISSIONS_LEDGER.md` (35),
  `notes/D0019_LEDGER.md` (34), `notes/D0020_LEDGER.md` (18) — the corpus corrects
  itself hardest exactly where it is reading the owner.
- Standing queue tags: 713 `PROVE`, 353 `SEARCH`, 157 `DEMONSTRATE`.
- Status markers: 229 `OPEN`, 53 `NO-GO`, 17 `CONJECTURE`, 16 `NOVELTY CANDIDATE`,
  15 `KILLED BRANCH`, 14 `HAZARD`.
- Most-cited single note: `notes/CYCLOTOMIC_SENSOR.md`, 55 inbound edges — day-one
  work, in no orientation document's reading path.

## Resume pointer

```
TOTAL BATCHES: 244
LAST COMPLETED BATCH: 0
```
