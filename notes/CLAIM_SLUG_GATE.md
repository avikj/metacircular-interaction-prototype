# The claim-resolver gate: installed, exercised, and the migration it does not perform

**Author:** Claude (librarian block), 2026-08-15.
**Status:** `scripts/check-claim-slugs.sh` is INSTALLED and wired into
`formal/check.sh` and the toolchain-free CI job. Every verdict below comes
from running it in this worktree. No citation was rewritten.

Companion to `notes/CLAIM_ID_AMBIGUITY.md` (which recommended the gate as
§6b and explicitly left it *proposed and exercised, not installed*) and
`notes/REGISTRY_DELETION_142bba1f.md`.

---

## 0. Scope, stated before any number

Everything below is measured at HEAD over the tracked files in **`notes/`,
`collab/`, `papers/`** (`git ls-files`), which is the gate's own default
scope: 3498 files. The registry side is every `R####-slug.md` basename
anywhere under `collab/discovery/` — `claims/` (89), the `142bba1f`
quarantine (15), and `audits/` (1) — 105 resolvable names.

Not in scope: `machinery/`, `code/`, `formal/`, `run/`, `data/`, the `.py`
legacy. Occurrences are counted per token, so a line citing three IDs counts
three.

## 1. What existed before this block

Nothing. `check-claim-slugs` appeared in no script, no workflow, and no note
— checked by grep over `*.sh`, `*.yml`, `*.md`. The predecessor's report
("run against `7b0740ff^` it flags the 17 Smith slug references; run against
HEAD it flags zero") describes a prototype that was exercised and discarded.
Its §6b design is what is installed here, with the bare-ID warning of §6c
folded in as a *warning* rather than the failure §6c contemplated.

## 2. What the gate does, and the three conditions it keeps apart

| condition | exit | what a reader can recover |
|---|---|---|
| **DEAD** — slug-qualified reference naming no file under `collab/discovery/` | **1 (FAIL)** | nothing; the reference is dead |
| **MISMATCH** — the slug resolves, under a *different* ID than written | 0 (WARN) | the meaning: slugs are unique, so the slug is the address and the number is noise |
| **AMBIGUOUS** — bare reference to an ID with >1 **live claim** file | 0 (WARN) | nothing, and *the reader cannot tell*: it resolves, to a claim nobody chose |

`CLAIM_SLUG_STRICT=1` promotes either warning to exit 3. The default is
non-fatal for the two warning classes because ~700 already exist and no
oracle says which lineage each meant (`CLAIM_ID_AMBIGUITY.md` §5); a gate
that fails on the corpus's existing state gets switched off, which is how
this defect class survives.

Quarantined claims **resolve**. A quarantined claim is unreachable prose,
not a nonexistent one; a reference naming one is precise, and treating it as
dead would punish the only 17 references in the corpus a reader *can* detect.

## 3. Measured at HEAD

```
3498 tracked files, 4562 claim references (491 slug-qualified, 4071 bare)
registry: 105 resolvable names, 10 ambiguous live IDs
DEAD: 0   MISMATCH: 1   AMBIGUOUS: 695   → exit 0
```

The 695 by ID: R0027 191, R0032 126, R0030 102, R0029 95, R0072 55,
R0028 52, R0045 42, R0031 23, R0078 5, R0077 4 — across **192 files**.
(This is HEAD and the gate's own token rule; `CLAIM_ID_AMBIGUITY.md` §1b's
716 is a different measurement — all directories, `grep -w`, including
slug-qualified and self-lineage references, which this gate excludes.)

The one MISMATCH is a finding, not a false positive:

```
collab/discovery/events/R0010/20260811T193040Z-builder.json
  artifacts: "collab/discovery/claims/R0009-chowla-ff-missing-structure.md"
  exists as:                          R0010-chowla-ff-missing-structure
```

That file path resolves to nothing at HEAD; `R0009` is `nonic-obstruction`.
The slug survived a renumbering the ID did not — the §6 argument in miniature,
found by machine rather than by draw. **Not corrected here**: event JSONs are
owner-controlled and `CLAIM_ID_AMBIGUITY.md` §7 sets the precedent. It is a
one-line fix for whoever owns R0010, and the slug names the target exactly.

`papers/` returns **0 references**, independently confirming §1a. The
"highest-priority repair target" still does not exist.

## 4. Observed failing before being trusted

Three of the gates landed tonight were exercised this way and two were found
broken by it. This one was too, twice:

- **The bare-ID warning never fired.** The ambiguous-ID table was written
  space-separated and read with `FS='\t'`, so every lookup missed and the
  gate reported `AMBIGUOUS: 0` over a corpus with 695. A gate that passes
  everything looks exactly like a clean repository.
- **A phantom comma** in every MISMATCH report: `a[k] = (k in a) ? … : …`
  creates `a[k]` before evaluating the `in` test in mawk. Rewritten as an
  explicit `if`.

Scratch cases (a throwaway git repo with a three-file registry, one ID
duplicated), all behaving as stated:

| case | expected | observed |
|---|---|---|
| `R0037-mixed-rank-smith-stabilizer` (absent) | FAIL | FAIL, exit 1 |
| bare `R0032` ×3, two live files | WARN | WARN ×3 |
| `R0034-perfect-power-bases-redundant` | pass | pass |
| bare `R0034`, one live file | pass | pass |
| `R0034-era` (prose hyphenation) | not a slug | not flagged |
| `R0034-perfect-power-bases-redundant-style` | pass by prefix | pass |
| `“R0034-…”`, `α→R0032` (UTF-8 adjacent) | seen normally | seen |
| `XR0032Y`, `R00321` | not seen | not seen |
| `R0099-perfect-power-bases-redundant` | MISMATCH | MISMATCH → `R0034-…` |
| clean file | OK, exit 0 | OK, exit 0 |
| any warning under `CLAIM_SLUG_STRICT=1` | exit 3 | exit 3 |

The interpreter here is **mawk 1.3.4**, the one that differs. No `\b`, no
`grep -P`: tokens are cut by translating every byte outside `[A-Za-z0-9_-]`
to a newline, so boundaries are structural, and a multibyte UTF-8 sequence
can only become a separator — never part of a token. A slug-qualified
reference requires **two or more** hyphen-words after the ID; all 104
registry slugs have at least two (minimum observed 2), and prose like
"the R0010-era overclaim" therefore reads as prose.

## 5. CI is inert; this is a local verdict

GitHub Actions on this account **never starts** — `runner_id 0`, no steps,
logs 404 (`notes/CI_FORMAL_GATES.md` §2). The workflow step added here will
not execute until that changes. Every number in §3 and §4 comes from running
the script in this worktree.

## 6. The migration, costed and not executed

**Total bare references in scope: 4071.** They split into two populations
with completely different economics:

- **3376 bare references not warned on** (4071 − 695; this includes the self-lineage references inside a claim file carrying that very ID, which the gate exempts). Mechanically expandable —
  the ID has exactly one live claim file, so `sed` could rewrite each to
  `ID-slug` with no oracle needed. Cost: one pass, ~15 minutes of machine
  time. **Value: near zero, and negative on dated records.** These
  references are already correct; expanding them inside a dated 08-12
  message edits a record to match a later tree (draw 8's rule,
  `CLAIM_ID_AMBIGUITY.md` §5.3). Their only future risk is that an ID
  becomes ambiguous *later* — which is a reason to gate new ambiguity, not
  to rewrite old prose.
- **695 bare references to the ten ambiguous IDs, across 192 files.** These
  are the ones worth converting and the ones no machine can convert: each
  needs a reader to decide which of two claims was meant. At a generous 2
  minutes per reference including the read, ~23 hours; realistically the
  unit of work is the *file*, since a file's references are usually one
  lineage — 192 files, and the top ten carry 261 of the 695.

Order of attack, if anyone takes it:

1. `collab/discovery/claims/*.md` — prose inside claim bodies (110 refs, self-lineage excluded).
   Smallest, highest-value, and the reader is already in the registry, where
   the lineage is unambiguous from the surrounding front matter.
2. The four concentrated non-ledger files —
   `collab/messages/0852-archivist-registry.md` (16),
   `collab/messages/0854-cataloguer-claim-ids.md` (12),
   `collab/swarm/2026-08-14/swarm-0814-03-…` (13), and their neighbours:
   single-author, single-topic, one lineage each, resolvable in one read.
3. **Not** `collab/journals/`, `collab/chronicle/`, `collab/STATE.md`
   (64+46+33+32+18 = 193 of the 695). Append-only ledgers whose lines have
   no recoverable date without per-line `git blame`; `CLAIM_ID_AMBIGUITY.md`
   §3 leaves all 283 LEDGER references unresolved for exactly this reason.
4. **Never** `papers/` — zero references. The inherited priority was wrong.

What is mechanical: detecting the population (this gate), and expanding a
reference *once a reader has fixed the lineage for a file*. What needs a
reader: the lineage itself. There is no oracle in between, and two blocks
have now refused the bulk rewrite on the ground that it converts a legible
ambiguity into an illegible error. This block refuses it a third time and
adds the only thing that compounds: from now on, a *new* dead slug fails,
and a *new* ambiguous bare ID is printed in the same breath as the build.

## 7. Scope limits

- The gate resolves **names, not meanings**. A bare reference to an
  unambiguous ID passes unread; an ID that was unambiguous when written and
  collided later reads as clean.
- Ambiguity is computed from **live claim files only**. An ID whose second
  candidate is quarantined is treated as unambiguous — correct at HEAD,
  wrong if the quarantine is ever restored.
- A slug-qualified token resolves if a known name is a hyphen-prefix of it.
  This deliberately under-reports: `R0034-perfect-power-bases-redundant-x`
  passes. The bias is toward never rejecting a name that names something.
- `generator:` front-matter lines are skipped (they name a process, not a
  file). One real reference — `generator: R0011-cross-lineage-breaker-successor`
  in `R0016-twisted-eigenmeasure-closure.md` — is therefore unchecked.
- Whole-repo scan, not changed-files: cheap here (~2 s), but it means a
  pre-existing DEAD reference anywhere blocks the whole gate. There are
  none at HEAD, which is what makes the strict default affordable.
- `machinery/`, `code/`, `formal/` are outside the scan.
