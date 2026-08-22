# The gates, made mechanical — and the reason none of them fires yet

**Author.** claude (Babbage lineage), 2026-08-15. *A discipline that depends
on someone remembering is not a discipline.*

Two audits tonight found the same defect in two lanes
(`notes/PIN_SWEEP_NATURALMACHINE.md`, `notes/LEAN_LANE_AUDIT.md`): a
whole-tree green claim resting on an aggregate that did not reach the whole
tree. Both were discoverable in seconds. Both went undiscovered for a day,
and the Agda one went undiscovered *twice*, because the check lived in prose
("run this one command") rather than in machinery. This note records the
machinery, and — the part that matters more — the fact that the repository's
CI has not executed a single step in its entire recorded history.

---

## 1. What now exists

### `scripts/check-agda-closure.sh` — no Agda required

BFS of the transitive import closure of the aggregate roots
(`Everything.agda`, `NaturalMachine.agda`) over the `.agda` files in
`formal/cubical/`, restricted to modules that exist locally. Two failure
conditions, in the two opposite directions BUILD.md's prose already named:

- **orphans** — any local module outside the closure. Nothing rechecks it,
  so no aggregate's exit code covers it;
- **imported controls** — any import of `NaturalMachine.Control.*` from
  outside `Control/`. Those modules are deliberately false statements that
  MUST fail to typecheck; importing one would make an aggregate red for a
  reason that is not a defect. `ControlledGrammar` and `Controls` are matched
  correctly (the prefix tested is `NaturalMachine.Control.`, with the dot).

Run here, on the working tree and independently on a clean `git archive` of
HEAD — same answer both times:

```
$ ./scripts/check-agda-closure.sh
aggregate roots : Everything NaturalMachine
modules on disk : 359 (excluding NaturalMachine.Control.*)
reached         : 357

FAIL: 2 module(s) are outside the aggregate's import closure.
    ORPHAN NaturalMachine.DSONucleusMiddleAssociativityAudit
    ORPHAN NaturalMachine.DSONucleusResidualAudit
EXIT=1
```

**The check fails right now, and the two survivors are the interesting ones.**
Of the 34 orphans the pin sweep found, 32 have been folded into the roots by
the sibling lanes since. The two that remain are exactly the two the pin
sweep could not finish: `DSONucleusMiddleAssociativityAudit` and
`DSONucleusResidualAudit`, still typechecking after 41 and 30 minutes when
that pass stopped waiting, with no exit code recorded for either. That is not
a coincidence — they are unimported *because* nobody can afford to import
them. The choice they force is a real one (make them cheap, gate them
separately, or delete them), and the value of the script is that it will keep
forcing it instead of letting them drift back out of view.

I have deliberately **not** closed those two myself. Folding an unbounded
typecheck into `Everything.agda` would make the root's cost unbounded, and I
have no exit code for either module; that is their owners' call, and it is
now a call the repository cannot forget to make.

Scope: this is text analysis of import lines. It says **nothing** about
whether any module typechecks. It is the cheap half of the gate, and the
cheap half is the half that was missing.

### `scripts/check-lean-globs.sh` — no Lean, no mathlib required

The Lean answer is better than a check, because the defect is closable at the
root: `globs = ["Pairfield", "Pairfield.+"]` makes every file under
`Pairfield/` a build target, so a module cannot hide by not being imported
and the orphan enumeration becomes unnecessary. That line **is present in the
working tree** — added by the Curry-lineage audit, uncommitted at the time of
writing, and I have not committed another agent's edit.

So the script's primary job is to guard the line, not to recount. It fails if
the glob is gone, and in that case falls back to enumerating what is thereby
built by nothing:

```
$ ./scripts/check-lean-globs.sh                       # working tree, glob present
OK: lakefile.toml declares globs covering Pairfield.+ ;
    every module under Pairfield/ is a build target, so orphans are impossible.
EXIT=0

$ ./scripts/check-lean-globs.sh                       # clean checkout of HEAD
FAIL: lakefile.toml's [[lean_lib]] Pairfield has no globs = [..., "Pairfield.+"].
Modules built by nothing (17):
    ORPHAN Pairfield.ArbitrarySmithClosure
    ... (15 more) ...
    ORPHAN Pairfield.VandermondeFrequencyResponse
EXIT=1
```

Both branches exercised. Note 17, where `LEAN_LANE_AUDIT.md` said 21 and
SEED-85 said 16 then 13: four have been imported since. The number moving
again, on the same night the note was written, is the argument for the glob
and against any list.

### `.github/workflows/formal-gates.yml`

Both scripts on every push and pull request — they need no toolchain, so
there is no honest reason for them not to gate. Plus a `lake build` job
behind `workflow_dispatch` only.

---

## 2. The thing you should read this note for: **CI has never run**

Both existing workflows have been failing on every commit. I looked at the
runs rather than at the badge.

- Every one of the 30 most recent runs across both workflows: `failure`.
  (The API caps paging past 1000 items, so "every run ever" is not something
  I can assert; every run I could reach failed.)
- A representative run, `31869242480` (`No new Python`, main,
  06:21:29–06:21:31Z): **one job, `runner_id: 0`, `runner_name: ""`, no
  steps array at all.**
- `get_workflow_run_usage` for it: `UBUNTU total_ms: 0`, `duration_ms: 0`,
  against a wall-clock `run_duration_ms: 3000`.
- Job logs: **HTTP 404**, because there are none.

Zero billable milliseconds, no runner ever assigned, no logs to 404 *from*.
The jobs are not failing; they are never starting. That is the signature of a
repository whose Actions jobs cannot be scheduled at all — an exhausted
spending limit or usage quota on the account, or Actions disabled/restricted
for this repository — and **not** of anything wrong in the two YAML files.
Nothing inside this repository can fix it. It is an owner action in GitHub's
billing/Actions settings.

The consequence is blunt and I would rather write it than let a green-looking
workflow file imply otherwise: **the workflow I added in §1 will not run
either, until that setting is fixed.** What I have added is correct and
inert. Wiring the checks in was still the right move — the file is the thing
that starts working the moment the account does, and the alternative (another
paragraph of prose saying "run this command") is precisely the failure mode
that produced both of tonight's audits.

**Meanwhile the local layer is also off.** `git config core.hooksPath` is
**unset** in this checkout, so `.githooks/pre-commit` — the Python gate
CLAUDE.md describes as "enabled repo-wide via `core.hooksPath`" — is not
running here at all. I did not set it, and I recommend nobody sets it
casually: that hook also refuses any commit off `main`, and several agents
are currently working on `claude/collaborative-subagents-loop-*` branches.
Turning it on right now would block them. Owner's call; flagged, not taken.

So, stated plainly: of the four layers CLAUDE.md describes as enforcing the
Python ban — PreToolUse hook, pre-commit hook, CI, prose — in this checkout
exactly one is live.

## 3. What remains manual, precisely

| check | can CI run it? | why |
|---|---|---|
| Agda import closure + control quarantine | **yes**, wired | text only |
| Lean `globs` guard | **yes**, wired | text only |
| `lake build` (Lean lane) | opt-in `workflow_dispatch` | `lake exe cache get` fetches ~8690 oleans, ~10 GB. Reproduced in a container by `LEAN_LANE_AUDIT.md`; **never observed in a runner**, since no runner has executed a step here. Gating pushes on a 10 GB download is not a trade I would make even if it worked. |
| `agda NaturalMachine.agda` / `Everything.agda` under the pin | **no** | Agda 2.8.0 is a ~75-minute build from Hackage against GHC 9.4.7 (`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1); no runner image carries it, and `/usr/bin/agda` here is 2.6.3, a different toolchain from the pin. A cached binary artifact would make this feasible; building it is a session's work and nobody should pretend the current CI would run the result. |
| does a module say what its comments claim | **no**, and never | `LEAN_LANE_AUDIT.md` §6 |

`formal/check.sh` remains the local whole-lane gate and still requires both
toolchains.

## 4. The contradiction, reported not resolved — **owner's call**

`.github/workflows/epistemic.yml` runs `python3` three times:

```yaml
- run: python3 code/discovery_loop.py validate
- run: python3 machinery/validate.py
- run: python3 -m unittest discover -s machinery -p 'test_*.py'
```

(`code/discovery_loop.py` and `machinery/validate.py` exist; `machinery/`
holds 282 `test_*.py`.) The repository's only mechanically enforced rule is
the Python ban, and the repository's other CI job is a Python interpreter.
That is the contradiction, and it is genuinely awkward — but note what §2
does to it: **those three lines have never executed.** The epistemic registry
is not "a working check that the ban would disable". It is an unrun check
written in a banned language.

I have not touched that file. CLAUDE.md's escape hatch exists so in-flight
work is never destroyed, and deciding which way this falls is not a
sweeping agent's decision. The options, with their costs:

1. **Leave it.** Cost: the ban's one piece of machinery sits next to a
   contradiction of it, and the next agent to read `.github/` learns that the
   rules are negotiable. Benefit: zero risk to whatever the registry validates
   — but see §2; the benefit being protected is currently zero.
2. **Delete `epistemic.yml`.** Cost: the discovery-state validation loses its
   (never-fired) CI home; if the account's Actions are ever restored, that
   validation silently does not come back with them. Benefit: the workflow
   directory stops contradicting CLAUDE.md.
3. **Port the three entry points to Agda or Lean.** The honest fix and much
   the most expensive: `machinery/` is 282 test files. Nobody should start
   this without knowing what the registry is actually for.
4. **Grandfather it explicitly** — a comment in the workflow and a line in
   CLAUDE.md saying the epistemic registry is legacy Python, frozen, not to
   be extended. Cheapest thing that removes the appearance of a double
   standard without pretending to have done the port. My preference if the
   owner does not want to spend the port.

I flag this as the owner's decision and take none of the four.

## 5. Scope limits

- The scripts are text analysis. Neither compiles anything, and a green
  closure check is compatible with a red tree. Do not quote either as a
  green claim; quote them as "nothing is hiding from the aggregate".
- The Agda BFS follows `^\s*(open\s+)?import\s+M` after stripping `--`
  comments. Agda permits imports inside modules and parameterised module
  applications; a module reached *only* by a form this regex misses would be
  reported as a false orphan. None is at present — the pin sweep's BFS agreed
  exactly with the `.agdai` ground truth on 238 modules
  (`PIN_SWEEP_NATURALMACHINE.md` §1), which is the strongest evidence
  available that this regex is faithful to this corpus. It is evidence about
  this corpus, not a theorem about Agda's grammar.
- I did not run `lake build` or `agda`. Every exit code above is from the two
  scripts. The build verdicts I cite belong to `LEAN_LANE_AUDIT.md` and
  `PIN_SWEEP_NATURALMACHINE.md` and are theirs, not reproduced here.
- The CI diagnosis in §2 is from the Actions API: run/job metadata, usage,
  and a 404 on logs. I cannot see the account's billing page, so
  "quota or Actions disabled" is the reading those five facts force, not
  something I read off a settings screen. Whoever can see that page should
  confirm which.
- `formal/pairfield/lakefile.toml`, `formal/cubical/NaturalMachine.agda`,
  `formal/cubical/Everything.agda` and
  `Pairfield/HeadDepthBlindnessAdapter.lean` had uncommitted changes by other
  sessions while I worked. I committed none of them. The HEAD-versus-working-
  tree runs above are the same measurement taken twice for exactly that
  reason.
