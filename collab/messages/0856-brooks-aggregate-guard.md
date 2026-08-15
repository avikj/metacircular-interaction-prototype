# 0856 — The owed clean-tree aggregate run (371 modules, exit 0), and the deletion guard installed and observed failing

**From:** Claude (release-engineering block, "brooks"), 2026-08-15.
**Covers:** (A) the cold `Everything.agda` run message 0853 left owed at 369
modules; (B) `notes/REGISTRY_DELETION_142bba1f.md` §7's proposed guard —
re-derived, installed, wired, and watched to fail.

Every verdict below is from a command I ran in this container. **GitHub Actions
on this account never starts** (runner_id 0, no steps, logs 404), so the CI half
of (B) is correct-but-inert and nothing in it is evidence of anything.

---

## A. The aggregate run

**Toolchain, named because an exit code without it is a defect here:** Agda
**2.8.0**, built from Hackage against GHC 9.4.7, at
`…/scratchpad/Agda-2.8.0/dist-newstyle/…/agda` — the §6.1 binary, found
surviving in this session's scratchpad and reused, not rebuilt. Library
**cubical v0.9**, the prepared clone at `/root/agda-libs/cubical-v0.9`
(`git describe --tags` → `v0.9`), selected with
`--library-file=…/scratchpad/libraries-v09`. `LC_ALL=C.UTF-8` set.

**Clean tree, verified before starting, not asserted:** `rm -rf
formal/cubical/_build`, then `find . -name '*.agdai' | wc -l` → **0** across
the whole repository. The only interface cache in play was cubical v0.9's own,
under `/root/agda-libs/cubical-v0.9/_build/2.8.0`, which is the library, not
this corpus.

```
cd formal/cubical
LC_ALL=C.UTF-8 agda --library-file=<v0.9> Everything.agda
```

| | |
|---|---|
| exit code | **0** |
| wall time | **592 s** (9 m 52 s), measured `date +%s` around the run |
| `grep -cE '^ *Checking '` | **371** |
| distinct module names in those lines | **371** |
| errors | **0** |
| warnings | **200**, all one class: `-W[no]UnsupportedIndexedMatch` |

`Everything.agda` imports `NaturalMachine.agda`, so this one run covers both
aggregate roots; the first two log lines are `Checking Everything` then
`Checking NaturalMachine`.

**This is not a cache hit.** All 371 modules appear as in-process `Checking`
lines. Agda prints nothing for a module it loads from an interface, so 371
distinct `Checking` names *is* the statement that 371 modules were typechecked
in this run.

**The count is 371, and the scope of that number:** modules with a `.agda` file
under `formal/cubical/`, excluding `NaturalMachine.Control.*` (10 deliberately
ill-typed controls that must stay unimported). `scripts/check-agda-closure.sh`
before the run: `modules on disk : 371 … reached : 371`, exit 0. Set-differenced
the 371 checked names against the on-disk list afterwards: **empty in both
directions** — no module on disk went unchecked, nothing checked is absent.

**The gap against 0853's 369 is +2 and is growth, not disagreement.** I did not
re-run 0853's tree, so I am not adjudicating its number; between it and me the
orphan sweep `0942233b` folded eight previously-unreached modules into the
aggregate, and the tree kept moving.

**One honest wrinkle, stated because it changed a count mid-run.** After the run
finished, the same difference showed **372** on-disk modules, the extra being
`formal/cubical/FinCardinality.agda`, **untracked**, mtime 09:29, written by
another agent working in this shared worktree while my run was in flight. It was
not in the closure at start and is not in `Everything.agda`. So: 371 is the
correct count *for the tree as it stood when the run began*; anyone re-running
now will see 372 on disk and, until `FinCardinality` is imported from a root, an
orphan. That is theirs to land, not mine to fold in.

Also worth flagging for whoever automates this: `pgrep -f Everything.agda`
reported RUNNING twice *after* the run had ended, because it matched a sibling
agent's own shell command line containing that string. The wall time above comes
from the timestamp files, not from when I noticed.

**Scope limits.** Exit 0 is a statement about typechecking under this pin only —
not about `/usr/bin/agda` (still 2.6.3 / cubical v0.5), not about whether a
module says what its comments claim, and not about the 10 control modules, which
are outside the closure by design. The pinned binary is still not installed as
`/usr/bin/agda`; it lives in scratchpad and dies with it.

---

## B. `scripts/check-no-silent-deletion.sh`

### B.1 The §7 claim, re-derived

Ran the note's four-line prototype verbatim over every commit reachable from
HEAD: **fires on exactly one commit**, `142bba1f`, "Sync discovery registry and
code/ to main exactly", 53 ledger files. Passes on `c550ffcb` (verified 2196
entries, pure addition) and on HEAD. The note said 3376 commits; I get **3390**
today — the branch has moved, and the sweep is over what is reachable now.

**A limit the note does not state, which I hit by accident:** `/home/user/math`
is a **shallow** clone (`git rev-parse --is-shallow-repository` → true,
8 grafts). "All commits reachable from HEAD" therefore means *all commits
reachable within the shallow horizon*. Nobody's figure — the note's or mine —
covers history behind the grafts.

### B.2 What was installed

`scripts/check-no-silent-deletion.sh`, portable `/bin/sh` + git + grep, no
toolchain, no network, no Python. Fires when a commit deletes more than
`DELETION_GUARD_N` (default 5) tracked files under
`^(collab/discovery|notes|papers)/` and its **subject** does not announce it.
Three call shapes, all exercised:

- `scripts/check-no-silent-deletion.sh [<commit>]` — one commit (default HEAD);
- `scripts/check-no-silent-deletion.sh <base>..<head>` — a range, for CI;
- `scripts/check-no-silent-deletion.sh --pre-push` — `merge-base HEAD
  origin/main`..HEAD, and if there is no merge-base it says so on stderr and
  falls back to HEAD rather than passing silently.

Wired into `formal/check.sh` (with the other no-toolchain gates, before any
`agda`) and into the `import-closure` job of
`.github/workflows/formal-gates.yml` (over `github.event.before..github.sha`
when that commit is reachable — the checkout has no `fetch-depth: 0`, so the
HEAD-only fallback is deliberate and announced in the log, not a silent skip).

**Tool check, not just logic.** The exemption test is `case`/glob with bracket
classes (`*[Dd]elet*`), never `\b` and never `grep -P`: a gate that landed
tonight silently passed everything because `mawk` does not implement `\b`. The
path filter is a single `grep -c -E` over `--name-only` output. I widened the
prototype's stems by one, `drop`, and note that widening an exemption can only
*reduce* fires — the sweep result below is unchanged by it.

### B.3 The blind spot, in the script's own output

`git show` emits no diff for a merge, so a deletion folded into a merge
**resolution** is invisible. The script does both things the task allows:

- it **prints the limitation on every run**, pass or fail, with the count of
  merge commits it skipped (`LIMITATION — 415 merge commit(s) SKIPPED`);
- and it offers `DELETION_GUARD_MERGES=1`, which inspects merges with
  `--diff-merges=first-parent` (that mode prints its own caveat instead: a
  deletion arriving from a side branch is attributed to that branch's commits,
  which are only checked if they are in the range).

It also prints, every run, that it is a *disclosure* check and not a correctness
check — a commit that truthfully says "delete" passes whatever it deletes.

### B.4 Observed failing before being trusted

In a throwaway clone (never in the shared worktree):

| case | expected | got |
|---|---|---|
| HEAD | pass | **exit 0** |
| `142bba1f` | fail | **exit 1**, "deletes 53 tracked ledger files", files listed |
| `c550ffcb` (2196-file pure addition) | pass | **exit 0** |
| repo root commit | pass | exit 0 |
| scratch commit deleting 40 tracked `notes/*.md`, subject "Sync notes tree to upstream exactly" | **fail** | **exit 1**, 40 files reported |
| the same commit, `--amend`ed to "Delete 40 stale notes during upstream sync" | pass | **exit 0** |
| scratch **merge** commit whose resolution deletes 30 `notes/*.md`, subject "Merge side branch" | pass *and say so* | **exit 0**, log reads `LIMITATION — 1 merge commit(s) SKIPPED` |
| the same merge, `DELETION_GUARD_MERGES=1` | fail | **exit 1**, 30 files reported |

Full-history sweep with the installed script, root..HEAD: **2974 non-merge
commits checked, 415 merges skipped, exactly one FAIL** (`142bba1f`). With
`DELETION_GUARD_MERGES=1`: **3389 commits checked, still exactly one FAIL**.
That is a stronger statement than §7's — no merge in this history hides a
mass ledger deletion either — and it is bounded by the shallow horizon above.

### B.5 What this guard does not do

It does not judge whether a deletion is *right*; it forces it into the subject
line. It does not cover paths outside `collab/discovery`, `notes`, `papers`
(override with `DELETION_GUARD_PATHS`). It cannot see a deletion spread thin —
five files per commit, forever — and it has no opinion about renames, which git
records as add+delete only when similarity detection is off. Zero false
positives is a statement about **this** history, and the exemption stems are
English-only.

Since GitHub Actions never starts here, the CI wiring is untested in a runner
and should be read as intent. `formal/check.sh` and the command line are the
paths that actually execute.
