# The gate is a claim about a state, and it was evidenced by an event

**Author.** claude (Lovelace lineage), build worker, 2026-08-16, at
`main` = `5d011531` ("Route S4: the machine conjectures over 8 symbols and
certifies over 3", 2026-08-16 04:19:58Z).

**Provenance of every number below.** Three sources, never mixed:

* **API** — the GitHub Actions REST API, read this session. Run/job
  metadata, `get_workflow_run_usage`, and a log fetch.
* **RUN** — a command I executed in this container, exit code quoted.
  This container has **no `agda`, `lean`, `lake`, `ghc`, `runghc`,
  `elan`, `cabal`, or `stack`** (checked, all `MISSING`), so every RUN
  below is a toolchain-free shell script.
* **CITE** — a dated claim in a file, attributed to the session that
  made it. I did not reproduce it and do not vouch for it.

I ran no Agda and no Lean. There is no green in this note that I observed.

---

## 0. Verdict in one line

The gate is **not inert in the way the audit phrased it, and the true
shape is worse**: the workflows *do* fire — GitHub creates a run object
for every push, with the right event, the right `head_sha`, an
incrementing `run_number`, and job-level `if:` conditionals correctly
evaluated. What never happens is **runner assignment**. No file in this
repository controls that, so no YAML edit repairs it, and I have written
none.

The consequence stands exactly as the audit stated it: every "checked"
claim in this corpus rests on whichever session last ran a prover by
hand. The last time a **machine** wrote down a per-module result was
**2026-08-14T05:06:10Z**, for **87 modules**, under a toolchain the
schema of the day **did not record**. There are **400** non-`Control`
Agda modules on disk today.

---

## 1. The facts, mechanically

### 1.1 What is registered versus what is on `main`

`main` carries three workflow files. GitHub has **four** registered
workflows, all `state: active` (API):

| registered workflow | id | registered | file on `main`? |
|---|---|---|---|
| `Epistemic registry` — `.github/workflows/epistemic.yml` | 332105957 | 2026-08-11T10:20:21-07:00 | yes |
| `No new Python` — `.github/workflows/no-python.yml` | 333293553 | 2026-08-12T22:04:31-07:00 | yes |
| `Formal lane gates` — `.github/workflows/formal-gates.yml` | 334850281 | 2026-08-14T23:26:04-07:00 | yes |
| `agda` — `.github/workflows/agda.yml` | 335356893 | 2026-08-15T20:45:20-07:00 | **NO** |

The fourth is the finding I did not expect. `.github/workflows/agda.yml`
is described by its own header as *"the first CI job that actually runs a
prover in this repository."* It exists on exactly one ref —
`origin/claude/readme-review-seecrs`, tip `17504036`, 2026-08-16
03:51:19Z — which is **6 commits ahead of `main` and 1475 behind it**
(RUN: `git rev-list --left-right --count`). It was added by commit
`86f1fd96`, 2026-08-16 03:45:17Z, "Build tick 0: ThreeChannels checked,
first prover CI, aggregate red datum", which is **not an ancestor of
`HEAD`** (RUN: `git merge-base --is-ancestor` → NO).

The same commit added `formal/cubical/NaturalMachine/ThreeChannels.agda`
(215 lines, commit message: "NEW, exit 0"). That file exists **nowhere on
`main`** (RUN: `git log --all --oneline -- '*ThreeChannels*'` returns
only `86f1fd96`). The branch's later commit `17504036` also retires
`epistemic.yml` — the contradiction `notes/CI_FORMAL_GATES.md` §4 flagged
as the owner's call — and repairs four modules for v0.5 drift. None of
that is on `main` either.

So the repository's only prover CI, and the work it was written to gate,
are stranded on a branch nobody is rebasing.

### 1.2 The runs never start (API)

Most recent `Formal lane gates` run, `31926383690`, event `push`, branch
`main`, `head_sha` `5d011531`, created 2026-08-16T04:20:03Z:

* job `95114528911` "Aggregate closure and control quarantine (no
  toolchain)": `conclusion: failure`, `started_at` = `created_at` =
  04:20:03Z, `completed_at` 04:20:05Z, **`runner_id: 0`**,
  **`runner_name: ""`**, and the job object carries **no `steps` array
  at all**;
* job `95114529285` "lake build (opt-in…)": `conclusion: skipped` — the
  `if: github.event_name == 'workflow_dispatch'` **was evaluated**;
* `get_workflow_run_usage`: `UBUNTU total_ms: 0`, both `job_runs`
  `duration_ms: 0`, against `run_duration_ms: 4000`;
* `get_job_logs` for `95114528911`: **HTTP 404**.

Zero billable milliseconds, no runner ever assigned, no logs to 404
*from*, and a two-second wall clock. The same signature on the stranded
prover job: run `31924998915` (2026-08-16T03:45:20Z), `UBUNTU total_ms:
0`, one job `duration_ms: 0`, `run_duration_ms: 3000`.

Conclusions sampled (API), all `failure`, no exceptions:

| sample | window | result |
|---|---|---|
| 30 most recent runs, all workflows | to 2026-08-16T04:20Z | 30/30 `failure` |
| `no-python.yml`, run_numbers 1306–1335 of 2295 | 2026-08-14T10:21:44Z – 10:24:55Z | 30/30 `failure` |
| `epistemic.yml`, run_numbers 2783–2812 of 3772 | 2026-08-14T10:21:43Z – 10:24:52Z | 30/30 `failure` |
| `agda.yml`, both runs | 2026-08-16T03:45:20Z, 03:51:23Z | 2/2 `failure` |

**Limit of this evidence, stated rather than elided.** GitHub caps
pagination of this endpoint at 1000 items. `epistemic.yml` has 3772 runs
and `no-python.yml` has 2295; I could reach neither back to run 1. So the
claim is *"every run I could reach is a `failure` that was never
dispatched"*, not *"no run in this repository's history has ever
executed"*. `notes/CI_FORMAL_GATES.md` §2 (claude, Babbage lineage,
2026-08-15) hedged identically, independently, one day earlier. Two
sessions hitting the same wall is not confirmation of the stronger claim.

### 1.3 The local layer is still off (RUN)

`git config core.hooksPath` → **empty, exit 1**: unset. So
`.githooks/pre-commit` — which `CLAUDE.md` describes as "enabled
repo-wide via `core.hooksPath`" — is not running in this checkout.
Unchanged since `CI_FORMAL_GATES.md` §2 recorded it on 2026-08-15. I did
not set it, for the reason that note gives and I verified: that hook also
refuses any commit off `main`, and seven `claude/*` branches are live
(RUN: `git for-each-ref`).

Of the four layers `CLAUDE.md` names as enforcing the Python ban —
PreToolUse hook, pre-commit hook, CI, prose — exactly one is live here.

### 1.4 What the cheap gates say today (RUN, this container, `5d011531`)

I executed all six toolchain-free scripts. Five are green. One is not:

```
./scripts/check-agda-closure.sh          EXIT=1     <-- RED
./scripts/check-lean-globs.sh            EXIT=0
./scripts/check-agda-pragmas.sh          EXIT=0     418 files, 418 assert --safe
./scripts/check-lean-example-oracles.sh  EXIT=0
./scripts/check-claim-slugs.sh           EXIT=0     (warnings non-fatal)
./scripts/check-no-silent-deletion.sh    EXIT=0
```

The red, in full:

```
aggregate roots : Everything NaturalMachine
modules on disk : 400 (excluding NaturalMachine.Control.*)
reached         : 379

FAIL: 21 module(s) are outside the aggregate's import closure.
    ORPHAN CyclotomicMined            ORPHAN EGBSpanWeave
    ORPHAN EGBCycleHolonomy           ORPHAN EGBSuccessorCost
    ORPHAN EGBDetConservation         ORPHAN EGBTwoFibrations
    ORPHAN EGBFalsifierAsymmetry      ORPHAN FactoryVICoolingKill
    ORPHAN EGBPairComposition         ORPHAN FactoryVICore
    ORPHAN EGBPairConic               ORPHAN MachineLibrary
    ORPHAN EGBPhiIdempotent           ORPHAN MachineMinted.Everything
    ORPHAN EGBResidueGlue             ORPHAN MachineMinted.ThresholdQ29
    ORPHAN EGBReversalInvariant       ORPHAN MachineMinted.ThresholdQ31
                                      ORPHAN MachineMinted.W4CountsFresh
                                      ORPHAN MachineMinted.WieferichWindow3512to3700
                                      ORPHAN ObligationMinCut
```

`notes/AGDA_COVERAGE_INVENTORY.md`, written **2026-08-16 03:43** — some
36 minutes before `HEAD` — states "**0 non-Control orphans**". Both
statements were true when made. That is the whole point: a hand-checked
count is a photograph, and the corpus moves faster than the shutter. The
mechanical check that would have caught the drift within seconds exists,
is wired into `formal-gates.yml`, and **has never once been executed by
CI**.

So `formal-gates.yml` would be **red on the current `HEAD`** if a runner
ever picked it up. Its inertness is not merely the absence of a green; it
is the concealment of a live red.

---

## 2. Adjudication, per workflow file

The task offered four categories. None of them fits, and saying so
precisely is more useful than forcing one:

> (a) cannot trigger · (b) triggers but checks nothing load-bearing ·
> (c) would work but no runner has the toolchain · (d) does run

The observed category is a fifth:

> **(e) triggers correctly, is scheduled, evaluates its own conditionals,
> and is never dispatched to a runner.**

| file | triggers? | dispatched? | load-bearing if it ran? | verdict |
|---|---|---|---|---|
| `epistemic.yml` | **yes** — `on: push, pull_request`, no filters; 3772 runs | **never** (§1.2) | it would run `python3` three times, which `CLAUDE.md` bans repo-wide | **(e)**, and a contradiction that has never had the chance to matter. `CI_FORMAL_GATES.md` §4's four options remain open, all owner's call. The stranded branch already chose option 2; `main` has not. |
| `no-python.yml` | **yes**; 2295 runs | **never** | yes, and correct: `fetch-depth: 0`, base from `event.before` with a `HEAD~1` fallback. RUN: `git diff --name-only --diff-filter=AM HEAD~1 HEAD` → no `.py`, so it would pass on this commit | **(e)** |
| `formal-gates.yml` → `import-closure` | **yes**; 30 runs reachable | **never** | **yes, maximally** — six real checks, no toolchain needed, and one of them is **red right now** (§1.4) | **(e)**, hiding a live red |
| `formal-gates.yml` → `lean-build` | **yes**, and its `if:` **is** evaluated — job `95114529285` was correctly `skipped` on the push | never dispatched; never `workflow_dispatch`ed either | would need `elan` + a ~10 GB mathlib cache; **never observed in a runner** | **(e)** for the skip decision; untested beyond it |
| `agda.yml` *(registered, not on `main`)* | **yes**, on pushes to `claude/readme-review-seecrs` only; 2 runs | **never** | the only job in the repo that would run a prover — but its module set is a **hand-list of 7**, the exact defect four other hand-lists in this corpus have already demonstrated, and it targets **Agda 2.6.3 + cubical v0.5**, which is not `main`'s pin (`formal/cubical/BUILD.md`: **Agda 2.8.0 + cubical v0.9**) | **(e)**, and **stranded**: 1475 commits behind `main` |

### Why I wrote no corrected YAML

Because I can state exactly why these do not fire, and the reason is not
in the files. GitHub's scheduler already accepts all four, creates run
objects from them, resolves `paths:` filters, and evaluates job-level
`if:` expressions. A two-second `failure` with `runner_id: 0`,
`runner_name: ""`, no `steps` array, `0` billable milliseconds, and a 404
on logs is the signature of a repository or account whose Actions jobs
**cannot be dispatched at all** — an exhausted spending limit, Actions
disabled or restricted for this repository, or an org policy block. It is
not the signature of a bad trigger, a bad `runs-on`, or a bad branch
filter, all of which produce runs that *start* and then fail visibly with
logs.

I cannot see the billing page. That is the reading these six facts force,
not something I read off a settings screen — the same boundary
`CI_FORMAL_GATES.md` §2 drew. **It is an owner action in GitHub's
billing/Actions settings and nothing in this repository can substitute
for it.**

Editing the YAML and presenting it as a repair would be, precisely, a
change to a file offered as evidence about a state. That is the error
this note is named for.

---

## 3. When was the last recorded green, and for what

**Machine-recorded, in-tree, dated** — `collab/orchestration/machine-ledger.tsv`,
complete, all five data rows:

```
utc                    cycle toolchain modules green fiber fiber_env aggregate walk
2026-08-14T04:32:17Z   0     -         84      84    0     0         0         next5≡7
2026-08-14T04:37:33Z   1     -         85      85    0     0         0         next5≡7
2026-08-14T04:55:11Z   2     -         86      86    0     0         0         next5≡7
2026-08-14T05:06:10Z   3     -         87      87    0     0         0         next5≡7
2026-08-14T17:19:14Z   4     absent    315     0     0     315       127       next5≡7
```

**The last recorded green is cycle 3, `2026-08-14T05:06:10Z`: 87 modules
invoked, 87 exit 0, aggregate `NaturalMachine.agda` exit 0.** Three
things must be said next to it:

1. Its `toolchain` column is `-`. The column did not exist when the row
   was written; the schema migration of 2026-08-16 (recorded in
   `run_the_natural_machine_forever`'s header) backfilled `-` rather than
   guess. **We do not know which compiler produced that green.**
2. It names **87 modules and not which 87**. The ledger is counts. The
   companion file that names modules, `collab/orchestration/open-fibers.md`,
   is *regenerated every cycle* — it says so in its own first line — and
   names only the reds. **No green module has ever been named in a
   durable file by any machine in this repository.**
3. There are **400** non-`Control` modules on disk today (RUN). Even
   taken at face value, cycle 3 covers at most 21.75% of the present
   tree, and `notes/BUILD_COVERAGE_IS_A_CHANNEL.md` gives the exact
   ambiguity of what it omits: the fibre over the observation has size
   `2^|I \ C|`, and that is a theorem, not an estimate.

Cycle 4, the only later row, has `toolchain: absent` and `aggregate:
127`. It checked nothing: 315 invocations of a command that was not
there. It is the row that once read as "the corpus died in twelve hours"
and is the reason the schema now carries a toolchain column at all.

**Prose-recorded, dated, by the session that ran it** (CITE — I did not
reproduce any of these):

* `notes/AXIOM_GATE.md`, 2026-08-15, Milner lineage: `lake build` in
  `formal/pairfield/` → *"Build completed successfully (8839 jobs), exit
  0, twice"*, Lean 4.33.0 + mathlib v4.33.0, in-container; `lake exe
  axiom_gate` clean but for 2 allowlisted theorems in
  `DiagonalSmithRoute`. **This is the strongest dated green in the
  corpus, and it is a paragraph.**
* `notes/AGDA_COVERAGE_LEDGER.md`, rows A2/A5/B8/B9/B10/B11: `EXIT=0`
  **under the pin**, run 2026-08-15, for `HomometricPair`, the six
  `Gamma0*` modules, `PrimePairField`, `KuttakaValli`,
  `Gamma0IndexExponent`, and `lake build Pairfield.ParityRigidity`.
* Commit `86f1fd96`, 2026-08-16 03:45:17Z, on the stranded branch:
  `ThreeChannels.agda` "exit 0", and — in the same message — *"Root
  aggregate recorded RED in-container at `PathIsSymmetry` (SymGroup not
  in scope, v0.5 drift)"*. A red datum, honestly recorded, on a branch no
  one on `main` will read.

Every one of these is a sentence a human typed about a run a human
started. That is the entire mechanised-evidence base of this corpus.

*(Aside, since dates are the currency of this note:
`collab/messages/0863-…` is headed **2026-08-17**, while the commit that
landed it is 2026-08-16 04:19:58Z and today is 2026-08-16. A one-day
forward slip in a header. Noted, not struck — it is the author's file.)*

---

## 4. The fix: `scripts/gate-record.sh`

One self-contained bash script (no Python; the ban is enforced by a
PreToolUse hook, a pre-commit hook, CI, and prose, and I add nothing to
the pile). It exists because the gap is narrower and more embarrassing
than "no CI": **this repository has never had a file in which a green,
per module, could be written down and survive the session that observed
it.**

```
./scripts/gate-record.sh              check every module, append rows
./scripts/gate-record.sh --dry-run    print the enumeration; append nothing;
                                      needs no toolchain
GATE_LEAN=1 ./scripts/gate-record.sh  also record the Lean lane, per module
```

It appends to `collab/orchestration/module-gate-record.tsv`, one row per
module per run, header written once, never rewritten:

```
run_utc  commit  dirty  toolchain  cubical  pin  host  kind  module  exit  secs  verdict
```

Five rules, each paid for by a defect already documented in this corpus:

1. **Enumerate, never list.** The module set comes from `find`. Hand-lists
   have rotted here at least four times: `Everything.agda`'s import list
   (SEED-81, and again today — §1.4), `lean_lib Pairfield` without
   `globs` (`LEAN_LANE_AUDIT.md`, 21 modules built by nothing), the pin
   sweep's 34 Agda orphans, and the 7-module list inside the stranded
   `agda.yml`.
2. **Per module, never the aggregate alone.** `run_the_natural_machine_forever`
   names three defects that survive any check reading aggregate *output*
   instead of `$?` per module. The two roots are still checked — as rows,
   marked `kind=aggregate`.
3. **The toolchain is part of the observation.** Every row carries the
   Agda version, the cubical library identified **by content** (`SymGroup`
   in `Cubical/Algebra/SymmetricGroup.agda`, the test
   `formal/cubical/check.sh` established), and whether the pair **is** the
   pin. `LC_ALL=C.UTF-8` is exported unconditionally before anything runs.
4. **The environment's exit is not Agda's verdict.** `exit >= 124` →
   `fiber_env` (124 watchdog, 125–127 could-not-run, 128+n signal). Such a
   row assigns no mathematical work and must never be repaired by editing
   a module.
5. **No toolchain means zero rows.** With no `agda` on `PATH` the script
   appends *nothing* and exits 2. A check that cannot start performed 0
   checks; it did not perform N failed ones.

Two further points where I deliberately did not simplify:

* **`NaturalMachine/Control/` is excluded from the module set** (10 files),
  because those are deliberately false statements that must fail — counting
  a designed refutation as a fiber is a false red, which is a false green
  with the sign flipped. But they are then checked **separately** as
  controls, and a control that returns 0 is recorded
  `control-FALSE-GREEN`. Nobody would otherwise ever see that.
* **It takes the same `_build` mutex** (`formal/cubical/_build/.gate.lock`,
  same path, same protocol) that `run_the_natural_machine_forever` uses,
  so the two serialise **against each other** and not merely against
  themselves. Two writers into one shared `.agdai` produce a corrupt
  interface read back as a false fiber — the exact false red this whole
  file exists to prevent, arriving through the filesystem.

### What I actually exercised (RUN, this container)

* `bash -n` clean.
* `--dry-run`: enumerates **400** modules + **10** controls, matching an
  independent `find`; appends nothing; exit 0.
* No-toolchain path: refuses, appends nothing, **exit 2**; the ledger file
  is **not created** (verified absent afterwards).
* Against a **stub** compiler on `PATH` (a shell script that reports
  `Agda version 2.8.0` and returns chosen exit codes — `GATE_LEDGER`
  pointed at a scratch file so no fiction entered the repository): all
  four verdict branches produced correct rows — `green` ×398, `fiber` (1),
  `fiber_env` (127), `control-red-as-designed` ×10 — the two roots came
  out `kind=aggregate`, 411 lines were appended (1 header + 410), the lock
  was released, and the run exited 1. A second stub returning 0
  everywhere produced `control-FALSE-GREEN` ×10, as designed.

---

## 5. What is STILL unverified after this fix

This is the section that matters. **A script nobody runs is the same
rumour one level up**, and I would rather write that sentence myself than
have it written about me.

1. **I have never seen this script invoke Agda.** Its stub run proves the
   plumbing — enumeration, classification, appending, locking, exit code.
   It proves nothing about the Agda invocation path: `--library-file`
   versus `-i .`, the 900-second watchdog, or the classifier's behaviour
   against real Agda exit codes. **The first toolchain-bearing session to
   run it is testing it, not using it, and should say so in the message
   it writes.**
2. **Exit 42 is a live ambiguity I did not resolve.** This corpus
   documents 42 as both a genuine version-skew red
   (`AGDA_COVERAGE_LEDGER.md` B9/B10/B11: "EXIT=42 under 2.6.3/v0.5") and
   as a pure locale failure (`formal/cubical/check.sh` §1: both compilers
   "die trying to print non-ASCII and return 42 for that reason alone").
   My classifier calls 42 a `fiber`. Forcing `LC_ALL=C.UTF-8` should
   exclude the locale cause by construction — *should*. I have not
   observed it. If a run comes back with many 42s, suspect the locale
   before suspecting the mathematics.
3. **The last machine-written green is still 2026-08-14T05:06:10Z, for 87
   unnamed modules, under an unnamed toolchain.** My script does not
   change that and cannot. It changes only what the *next* toolchain-
   bearing session is able to leave behind. Until such a session runs,
   the honest statement about this corpus is unchanged: **nobody knows
   when the tree last typechecked, or which parts of it did.**
4. **It records exit codes, not meanings.** `LEAN_LANE_AUDIT.md` §6:
   nothing here checks whether a module proves what its comments claim.
   An exit-0 row is a claim about typechecking and about nothing else.
5. **Its coverage is everything under `formal/cubical/` and, opt-in,
   everything under `formal/pairfield/Pairfield/`.** The 8 files under
   `formal/executable/` are not
   enumerated. Per `BUILD_COVERAGE_IS_A_CHANNEL.md` the fibre over what it
   observes has size `2^|omitted|`, exactly — so this omission is a
   measured hole, not a rounding error.
6. **It is wired into nothing.** `formal/check.sh` does not call it, no
   workflow calls it, `run_the_natural_machine_forever` does not call it.
   I did not wire it, on purpose: making `./run`'s exit code depend on a
   code path I have never executed would be the same overstatement in a
   new place. **Wiring it into `formal/check.sh` is the correct next move
   and belongs to the first session that has watched it work.**
7. **CI is still inert and I did not repair it, because it is not
   repairable from here.** Owner action, GitHub billing/Actions settings.
   Until then `formal-gates.yml` continues to hide a red (§1.4) rather
   than merely to withhold a green.
8. **`core.hooksPath` is still unset.** I did not set it; the same hook
   refuses commits off `main` and seven `claude/*` branches are live.
   Owner's call, flagged twice now.
9. **`agda.yml` and `ThreeChannels.agda` are still stranded** on
   `claude/readme-review-seecrs`, 1475 commits behind `main`. I did not
   cherry-pick them. Restoring `agda.yml` verbatim would import a
   7-module hand-list (defect 1 above) pinned to Agda 2.6.3 + cubical
   v0.5, which is **not** `main`'s pin — and it would land a workflow that
   still cannot be dispatched. Restoring `ThreeChannels.agda` would land
   215 lines of Agda that no toolchain in my reach can check. Both are
   real work and both deserve better than a blind rebase by an agent with
   no compiler. **Flagged for their owner, taken by me: nothing.**
10. **I did not commit** — and something else did, which is itself worth
    recording. I left `scripts/gate-record.sh` untracked in the working
    tree. At **2026-08-16 04:30:58Z** a sibling session's snapshot
    committer swept it into `349c2412` ("gate-record.sh: turn a green
    into a durable per-module record (snapshot; worker active)"). That
    was not my act and I did not review it; the file it committed is the
    file described above, byte for byte, but the commit subject is not
    mine and the reader should attribute it accordingly. `HEAD` moved
    `5d011531` → `c7598362` → `dd4aa880` → `349c2412` while I wrote this
    note. **Every measurement in §§1–3 was taken at `5d011531` and is
    stamped with it.** Re-run at `349c2412`,
    `scripts/check-agda-closure.sh` still returns **1** with the same 21
    orphans, 379 of 400 reached — so §1.4 survives the move. Nothing else
    was re-measured. This note itself is still untracked.

Nothing in this note is a green. The one thing I established with an exit
code is a **red**: `scripts/check-agda-closure.sh` returns 1 at
`5d011531`, 21 orphans, and no CI run has ever been in a position to tell
anyone.
