# Toolchain skew and the exact coverage of tonight's green claim

2026-08-15, Claude (release-engineering pass, branch
`claude/collaborative-subagents-loop-ekfugp`).

Everything below was measured in this container, by running `agda` myself.
No exit code here is quoted from another agent's report.

## 0. The container is not the pin

| | pinned by `formal/cubical/BUILD.md` | installed here |
|---|---|---|
| Agda | 2.8.0 | **2.6.3** |
| cubical | v0.9 (release tag) | **v0.5**, at `/root/agda-libs/cubical` |

`LC_ALL=C.UTF-8` is mandatory and is *not* cosmetic. Without it Agda dies
inside `commitBuffer` while printing any message containing `λ`, and returns
a nonzero exit that has nothing to do with the mathematics. In my first
sweep this produced two false failures
(`NaturalMachine/FillabilityCertificate.agda` "exit 42", `PolarityClosure`
with a truncated message). Both numbers in the table below are from the
re-run under `C.UTF-8`. BUILD.md already warns about this; the warning is
correct and I am adding the evidence that it bites the *exit code*, not only
the readability.

## 1. The root aggregate is red, and it is not tonight's fault

```
$ cd formal/cubical && LC_ALL=C.UTF-8 agda NaturalMachine.agda
/home/user/math/formal/cubical/NaturalMachine/PathIsSymmetry.agda:98,50-58
Not in scope: SymGroup
EXIT=42
```

Verified, not assumed:

- The offending line is `ΩGroup≃Symmetric : … → GroupEquiv (ΩGroup X isSetX)
  (SymGroup X isSetX)` at `PathIsSymmetry.agda:98`.
- cubical **v0.5** spells this `Symmetric-Group`
  (`/root/agda-libs/cubical/Cubical/Algebra/SymmetricGroup.agda:19`), and
  exports no `SymGroup` at all. v0.9 renamed it. The source is correct for
  the pin and wrong only for the library that happens to be installed here.
- `git log 0d066a92..HEAD -- NaturalMachine/PathIsSymmetry.agda` is **empty**.
  The file has not been touched on this branch. Its last commit is
  `fb8783f9`, before the merge-base. The failure predates all of tonight's
  work.

**Nothing was edited to make this go away.** Rewriting `SymGroup` to
`Symmetric-Group` would turn a file that is right under the pin into a file
that is wrong under the pin, in exchange for a green tick in a scratch
container. I found no genuinely version-neutral spelling: v0.5 exports only
`Symmetric-Group`, v0.9 only `SymGroup`, and `--safe` cubical Agda has no
conditional-compilation escape. If someone wants a neutral form it would
have to be a one-line shim module that is itself version-specific, which
just relocates the skew. **Proposal only; not applied.**

Consequence, and this is the part BUILD.md does not currently say: because
the root aborts at `PathIsSymmetry`, a root run in this container checks
*nothing after it*. The root's exit code is therefore not evidence about
tonight's modules in either direction. Per-module runs are.

## 2. The table

All runs: `cd formal/cubical && LC_ALL=C.UTF-8 agda <file>; echo EXIT=$?`,
Agda 2.6.3 + cubical v0.5. File list from
`git diff --name-status 0d066a92..HEAD` plus `git diff` for the uncommitted
working tree — not guessed.

| module | exit | reachable from root `NaturalMachine.agda`? | imports |
|---|---|---|---|
| `Everything.agda` (aggregate, M) | **42** | — (is an aggregate) | repo (imports the root) |
| `NaturalMachine.agda` (aggregate, M) | **42** | — (is the root) | repo |
| `PolarityClosure.agda` (A) | **42** | **no — orphan** | cubical stdlib only |
| `SimplicialDefectFailure.agda` (A) | 0 | **no — orphan** | cubical stdlib only |
| `StagewiseComposite.agda` (A) | 0 | via `Everything.agda` (not the root) | cubical stdlib only |
| `NaturalMachine/DecategorifiedDefect.agda` (A) | 0 | yes | cubical stdlib only |
| `NaturalMachine/FillabilityCertificate.agda` (A) | 0 | yes | cubical stdlib only |
| `NaturalMachine/LineWorldTransport.agda` (A, M) | 0 | yes | cubical stdlib only |
| `NaturalMachine/RepairTorsor.agda` (A) | 0 | yes | cubical stdlib only |
| `NaturalMachine/Control/QuantifierDrop.agda` (A) | **42 — as required** | no, and must never be | `NaturalMachine.LineWorldTransport` |

`A` = added on this branch, `M` = modified. Both aggregate 42s are the same
single `PathIsSymmetry` scope error; `Everything.agda` inherits it by
importing the root.

Two rows need reading carefully:

- **`QuantifierDrop.agda` exiting 42 is the pass condition, not a failure.**
  It lives in `NaturalMachine/Control/`, which BUILD.md and `Everything.agda`
  both declare permanently excluded because its contents are deliberately
  false statements that *must* fail. I confirmed the failure is the intended
  one: the reported mismatch is on `mod5 (c₁ f + c₂ f · val s)` at
  `QuantifierDrop.agda:80`, i.e. the dropped quantifier, not a stray syntax
  error. It is also the only file tonight that imports a repository module
  rather than only the stdlib — which is what makes it a real control.

- **`PolarityClosure.agda` genuinely does not check here**, and the reason is
  not the v0.5/v0.9 skew:

  ```
  PolarityClosure.agda:103,1-4
  Multiple definitions of Sub. Previous definition at
  /usr/share/libghc-agda-dev/lib/prim/Agda/Builtin/Cubical/Sub.agda:7,19-22
  ```

  It defines `Sub : ∀ {ℓ} → Type ℓ → Type (ℓ-suc ℓ)`, clashing with the
  Agda *builtin* `Sub`, which comes from the compiler's own `prim` bundle,
  not from the cubical library. Whether 2.8.0 still brings that name into
  scope at this import set is exactly the kind of thing I cannot settle
  without the pinned toolchain, so I record it as unresolved rather than
  renaming someone else's identifier. It is an orphan — no file imports it —
  so it endangers no aggregate today.

## 3. Audit of the import lines added to the aggregates tonight

This is the check BUILD.md exists to force, so here it is line by line, read
out of the files rather than out of anyone's summary.

`formal/cubical/NaturalMachine.agda` gained four imports:

| added import | standalone exit here | verdict |
|---|---|---|
| `import NaturalMachine.DecategorifiedDefect` | 0 | keep |
| `import NaturalMachine.RepairTorsor` | 0 | keep |
| `import NaturalMachine.FillabilityCertificate` | 0 | keep |
| `import NaturalMachine.LineWorldTransport` | 0 | keep |

`formal/cubical/Everything.agda` gained one:

| added import | standalone exit here | verdict |
|---|---|---|
| `import StagewiseComposite` | 0 | keep |

**No import line was removed, because every module added to an aggregate
tonight does check standalone in this container.** Task 3 anticipated a
defect of the "added to the aggregate without checking" kind; on the evidence
it did not occur tonight. I want to be precise about what that clears and
what it does not: it clears the modules under 2.6.3/v0.5. It does not clear
them under the pin, which no one here can run.

Two smaller observations while reading:

- An earlier state of `NaturalMachine.agda` had
  `import NaturalMachine.FillabilityCertificate` **twice** (once at line 520,
  once appended after `base10-is-10`). The working tree now has it once, at
  line 520. I confirmed this by reading the file, not from the diff:
  `grep -n FillabilityCertificate NaturalMachine.agda` returns exactly one
  line. No action needed. (Duplicate imports are legal in Agda, so this was
  never a build break — only a tidiness question, and it is already tidy.)
- The `[CORRECTED, SEED-81]` block that a previous agent added to
  `Everything.agda` is really there — I read it. Its claim that
  `BehavioralApartness`, `PrimePairField` and `CenterRelative` are orphans
  is outside my tasking and I did not re-verify it. Its stated reason for
  not folding them in ("there is no Agda in this container") is **false in
  this container** — Agda 2.6.3 is installed and I used it. That comment was
  presumably written in a different container; it should not be read as a
  current statement about tooling availability.

## 4. What the amendment to BUILD.md says

Appended to `formal/cubical/BUILD.md`, dated and attributed, by addition
only — no existing sentence was altered or deleted. It records the
container/pin discrepancy, states that per-module exit 0 under 2.6.3/v0.5 is
precisely what tonight's modules have, and names the modules whose
pinned-toolchain check is **outstanding**.

## 5. Scope limits

Stated plainly, because a green claim is only worth its boundary:

1. **Every exit code above is Agda 2.6.3 + cubical v0.5.** None of them is
   evidence about Agda 2.8.0 + cubical v0.9. A module can pass on the older
   pair and fail on the newer one (renames run both ways) and vice versa.
2. **The root and `Everything.agda` were not made green and no attempt was
   made to make them green.** BUILD.md's central identity — "the root exits
   0" and "the directory checks" are the same claim — is genuinely suspended
   in this container, and remains suspended after this pass. I documented the
   suspension instead of dissolving it.
3. I checked **only** the files that `git diff` against merge-base
   `0d066a92` reports as added or modified, plus the two aggregates. Modules
   untouched on this branch were not swept; the corpus as a whole is not
   audited here.
4. `PolarityClosure.agda`'s `Sub` clash is **diagnosed, not resolved**. I do
   not know whether it also fails under the pin.
5. I did not verify the *mathematical content* of any module — only that the
   typechecker accepts or rejects the file. Exit 0 says the terms check; it
   says nothing about whether they state what their comments claim.
6. `QuantifierDrop.agda`'s failure was confirmed to be the *intended* one by
   reading the error message. I did not verify that it is the *only* way that
   file could fail, i.e. that a future edit could not make it fail for an
   unrelated reason and still look like a passing control. That is a real
   weakness of failure-as-pass controls generally, not a finding about this
   file.

---

## 6. The pin was obtained. Results under Agda 2.8.0 + cubical v0.9

2026-08-15, Claude (pinned-toolchain pass, branch
`claude/collaborative-subagents-loop-ekfugp`). **Addition only** — nothing
above this heading was altered. Sections 0–5 remain correct as statements
about Agda 2.6.3 / cubical v0.5; this section supersedes their *scope limit
1* ("none of them is evidence about 2.8.0 / v0.9") by supplying the missing
runs.

### 6.1 How the pin was obtained

Both halves, in this container, in about 75 minutes of wall clock:

- **Library half — trivial.** `git clone --depth 1 --branch v0.9
  https://github.com/agda/cubical /root/agda-libs/cubical-v0.9`. The
  outbound proxy permits github.com and hackage.haskell.org (verified:
  `git ls-remote` lists all tags v0.1…v0.9; a HEAD on the Agda-2.8.0
  tarball returns 200). **The existing v0.5 clone at
  `/root/agda-libs/cubical` was not touched**, and neither was
  `~/.agda/libraries`; the v0.9 clone is selected per-run with
  `--library-file`.
- **v0.9 alone does not work.** cubical v0.9 uses `opaque` blocks, which
  Agda 2.6.3 cannot parse — it dies at
  `Cubical/Foundations/Structure.agda:28` with a parse error, i.e. inside
  the *library*, before any repository module is reached. The library half
  is therefore useless without the compiler half. (v0.6, v0.7 and v0.8
  contain no `opaque`; v0.8 *does* parse under 2.6.3, but fails inside
  `Cubical/Categories/NaturalTransformation/Properties.agda` with unsolved
  metas, so it is not a usable intermediate either. Neither v0.6–v0.8 nor
  v0.5 exports `SymGroup`; the `Symmetric-Group` → `SymGroup` rename is a
  **v0.8 → v0.9** change, confirmed by reading both files.)
- **Compiler half — buildable.** `apt-get install cabal-install` (3.8.1.0),
  `cabal update`, `cabal get Agda-2.8.0`, then `cabal build exe:agda
  --ghc-options=-j4` with the system GHC 9.4.7. Agda 2.8.0's `tested-with`
  lists GHC 9.4.8; 9.4.7 built it without a single error. Two snags worth
  recording: `cabal install Agda-2.8.0` fails outright under cabal 3.8
  ("Could not find module: Agda.Benchmarking" during its sdist step) — use
  `cabal get` + `cabal build` in the unpacked tree instead; and the built
  binary looks for its `prim` bundle in
  `/root/.cabal/share/x86_64-linux-ghc-9.4.7/Agda-2.8.0`, which `cabal
  build` does not populate, so `src/data/` must be copied there by hand.
- One deviation from a literal pin, stated so nobody is misled: upstream's
  `cubical.agda-lib` for v0.9 names the library **`cubical-0.9`**, while
  `formal/cubical/natural-machine.agda-lib` says `depend: cubical`. I
  renamed the field to `cubical` **in my own v0.9 clone**. Whoever
  reproduces the pin must do the same, or add the version-suffixed name to
  the `depend` line. This is a naming question only; no source was changed.
- Runs were made in a **copy** of `formal/cubical` under the scratchpad, so
  no v0.9 interface file ever entered the repository's `_build`. The
  repository working tree is byte-identical to what I found.

`LC_ALL=C.UTF-8` was set for every run, under both toolchains. §0's warning
holds under 2.8.0 as well.

### 6.2 The table, against the pin

`agda 2.8.0 --library-file=<v0.9> <file>; echo EXIT=$?`. The 2.6.3/v0.5
column is **my own re-run tonight**, not a quotation of §2 — every one of
its eleven numbers reproduced §2 exactly.

| module | 2.6.3 / v0.5 | **2.8.0 / v0.9 (the pin)** | |
|---|---|---|---|
| `NaturalMachine.agda` (root aggregate) | 42 | **0** | **the root is green under the pin** |
| `Everything.agda` (aggregate) | 42 | **42** | new, real failure — see 6.4 |
| `StagewiseComposite.agda` | 0 | **0** | discharged |
| `SimplicialDefectFailure.agda` | 0 | **0** | discharged |
| `Sl2DivisorLattice.agda` | 0 | **0** | discharged |
| `NaturalMachine/DecategorifiedDefect.agda` | 0 | **0** | discharged |
| `NaturalMachine/RepairTorsor.agda` | 0 | **0** | discharged |
| `NaturalMachine/FillabilityCertificate.agda` | 0 | **0** | discharged |
| `NaturalMachine/LineWorldTransport.agda` | 0 | **0** | discharged |
| `NaturalMachine/Control/QuantifierDrop.agda` | 42 | **42** | control still passes — see 6.3 |
| `PolarityClosure.agda` | 42 | **42** | still broken — see 6.3 |
| `Sl2TensorProduct.agda` | 0 | **42** | **green under v0.5, red under the pin** |

The root run emits 186 `UnsupportedIndexedMatch` warnings and **zero**
errors. That is the documented F39 boundary, and it means BUILD.md's central
identity — "the root exits 0" — is **true under the pin**, and was only ever
suspended by the container skew. §1's `PathIsSymmetry` failure was exactly
what it was diagnosed to be: v0.5 not having `SymGroup`. v0.9 defines
`SymGroup : (X : Type ℓ) → isSet X → Group ℓ` at
`Cubical/Algebra/SymmetricGroup.agda:28`, matching line 98's use. **Nothing
was edited to achieve this**; the un-edited file was right all along, which
is the vindication of §1's refusal.

### 6.3 The two failures that were already known, under the pin

- **`NaturalMachine/Control/QuantifierDrop.agda` still exits 42, and still
  for the intended reason.** Under 2.8.0 the error carries a machine-readable
  tag: `QuantifierDrop.agda:80.26-41: error: [UnequalTerms]`, on
  `rollover (val s + 0 · val s) … != mod5 (c₁ f + c₂ f · val s)` — the
  dropped quantifier, at the same line, not a syntax accident. The control
  is valid under the pin.
- **`PolarityClosure.agda` still exits 42, and §2's open question is now
  closed against it.** `PolarityClosure.agda:103.1-4: error:
  [ClashingDefinition] Multiple definitions of Sub. Previous definition at
  …/Agda-2.8.0/lib/prim/Agda/Builtin/Cubical/Sub.agda:7.19-22`. The builtin
  `Sub` is still in scope at this import set in 2.8.0, so this is **not** a
  toolchain artefact: the module is genuinely broken under the pin and needs
  its identifier renamed. That is for the agent already working on it; I did
  not touch the file.

### 6.4 The finding this exercise existed to produce

**`Sl2TensorProduct.agda` checks under 2.6.3/v0.5 and does not check under
the pin.**

```
Sl2TensorProduct.agda:115.29-33: error: [NotInScope]
Not in scope: ·Rid
```

Line 114–115 is `·1ₗ x = ·Comm (pos 1) x ∙ ·Rid x`. The name is
`Cubical.Data.Int.Properties.·Rid`, present in v0.5 at `Int/Properties.agda:417`
and **renamed to `·IdR` in v0.9** (`Int/Properties.agda:1184`). It is a single
error and, on the evidence of this one run, a one-token one.

Two consequences, and I am stating both rather than the flattering one:

1. `Everything.agda` is **red under the pin**, and this is its cause: it
   aborts at `Sl2TensorProduct` and therefore checks nothing imported after
   it. Its exit code is not evidence about those later modules in either
   direction — the same caveat §1 attached to the root under v0.5 now
   attaches to `Everything.agda` under the pin.
2. `collab/messages/0798-claude-sl2-tensor.md` reported this module as
   "exit 0" and correctly flagged the pin check as outstanding. That flag
   was load-bearing and the honest framing paid: the pin check is now done,
   and it is red. The claim in 0798 is not withdrawn — the module does check
   under 2.6.3/v0.5 — but it does **not** hold under the toolchain BUILD.md
   pins, and no claim about `Sl2TensorProduct` should be made without saying
   which.

**I did not fix it.** A rename from `·Rid` to `·IdR` would make the module
right under the pin and wrong under the only compiler installed as
`/usr/bin/agda` here, which is the exact trade §1 refused in the other
direction. The choice of which toolchain the sources track is the owner's,
not a build agent's, and it should be made once for the whole tree rather
than file by file. Recorded, not repaired.

### 6.5 Scope limits

1. Everything in 6.2 is **Agda 2.8.0 built from Hackage against GHC 9.4.7**,
   not a distributed 2.8.0 binary, plus **cubical v0.9 at tag
   `b150186d`**. I regard that as the pin; someone who does not should say so.
2. The pinned Agda is **not installed** as `/usr/bin/agda` and I did not
   install it there — `/usr/bin/agda` is still 2.6.3. The binary lives in the
   session scratchpad and will vanish with it. What survives this pass is
   the *result table* and the recipe in 6.1, not a working environment.
3. Only the twelve modules in 6.2 were run against the pin. The rest of the
   corpus is unswept under 2.8.0/v0.9, and given the `·Rid` finding, the
   prior expectation should now be that **other untouched modules are red
   under the pin too**. `Everything.agda` aborting early means it has not
   ruled that out.
4. Exit 0 remains a statement about typechecking, not about whether a module
   says what its comments claim (§5.5 unchanged).
5. I did not modify `PathIsSymmetry.agda`, `Sl2TensorProduct.agda`,
   `PolarityClosure.agda`, or any other source file. The only file I edited
   under `/root` is the `name:` field of my own v0.9 clone's `.agda-lib`
   (6.1).

### 6.6 Addendum, 2026-08-15: `PolarityClosure.agda` is repaired

Grothendieck-lineage pass, same day. §6.3's diagnosis was exactly right and
the repair is exactly the one it named: the module's own `Sub` was renamed
to `Pow` (the powerset-of, which is what it is). Nothing else was needed —
the clash was the *only* error, not the first of several.

`agda 2.8.0 --library-file=<v0.9> PolarityClosure.agda` → **EXIT=0**, and
`/usr/bin/agda` (2.6.3 / v0.5) → **EXIT=0** as well. The rename is
toolchain-neutral, so unlike §6.4's `·Rid`/`·IdR` it forces no choice
between the two: the `PolarityClosure` row of §6.2's table now reads **0 /
0**. The module was added to `Everything.agda`; that aggregate remains red
under the pin for §6.4's unrelated reason.

The pinned binary from §6.1 was still present in this session's scratchpad
and was reused rather than rebuilt; §6.5 scope limit 2 stands unchanged for
anyone starting fresh.

### 6.7 Addendum, 2026-08-15: `Sl2TensorProduct.agda` is repaired (Noether pass)

Under the owner's 2026-08-15 instruction that **the sources track the pin**,
§6.4's recorded-not-repaired finding is now repaired. §6.4's guess that it
was "on the evidence of this one run, a one-token" fix is **verified, not
assumed**: I made the rename, re-ran from a *clean* copy of `formal/cubical`
with no `_build`, and the module went straight to EXIT=0. Agda reports one
scope error at a time, so this could have hidden further v0.5-only names; it
did not. **The full list of names changed is one:**

| line | v0.5 (was) | v0.9 (now) |
|---|---|---|
| 115 | `·Rid` | `·IdR` |

```
$ cd <clean copy of formal/cubical> && LC_ALL=C.UTF-8 \
    <scratchpad>/Agda-2.8.0/.../agda --library-file=<v0.9> Sl2TensorProduct.agda
Checking Sl2TensorProduct (…/Sl2TensorProduct.agda).
 Checking Sl2DivisorLattice (…/Sl2DivisorLattice.agda).
EXIT=0
```

The trade §6.4 declined is now taken deliberately and in the direction the
owner chose: the module is **green under the pin and red under
`/usr/bin/agda` (2.6.3 / v0.5)**, which has no `·IdR`. That is the intended
state for every source file in this tree, not a regression. The
`Sl2TensorProduct.agda` row of §6.2 now reads **42 / 0**.

Consequence for §6.4's item 1, and it is stronger than "the abort moved":
**`Everything.agda` is green under the pin.**

```
$ cd <fresh copy of formal/cubical, _build removed> && LC_ALL=C.UTF-8 \
    <scratchpad>/Agda-2.8.0/.../agda --library-file=<v0.9> Everything.agda
… 315 modules checked, 0 errors, 194 UnsupportedIndexedMatch warnings …
EXIT=0
```

§6.4 item 1 is therefore **withdrawn, not merely narrowed**: the aggregate's
exit code is once again evidence about every module it imports, and that
evidence is positive. Two honesty notes on this run, because the first
attempt did not earn the claim:

- My first `Everything.agda` run reused `.agdai` interfaces that my own
  clean `Sl2TensorProduct` check had just written, so it was not a
  from-scratch aggregate and I did not publish it. The numbers above are a
  **second** run in a fresh copy with `_build` deleted, in which
  `Sl2TensorProduct` is genuinely re-checked (it appears as a `Checking`
  line, not as a cache hit).
- That second copy was taken **after** merging `origin/main`, so it covers
  315 modules rather than the first run's 162 — it includes sibling work
  landed today, among it §6.6's `PolarityClosure` repair. The larger number
  is the stricter test, not a different one.

This supersedes §6.2's `Everything.agda` row (**42 → 0**) and §6.5 scope
limit 3 to the extent that the aggregate covers it: what remains unswept
under the pin is any module `Everything.agda` does not import.

Swept for the same class of breakage and found nothing:
`grep -rn '·Rid\|·Lid\|+Rid\|+Lid\|Symmetric-Group' --include=*.agda formal/`
returns **zero** hits tree-wide. (`PathIsSymmetry.agda` already spells it
`SymGroup`, the v0.9 name — §1's refusal, vindicated in §6.2.) This is a
grep for five specific identifiers, not a proof that the tree is clean under
the pin; §6.5 scope limit 3 stands.

---

## 7. The orphans of `Everything.agda`, swept and folded in

2026-08-15, Claude (Euclid-lineage orphan pass). **Addition only** —
nothing above this heading was altered. §6.7 established that
`Everything.agda` exits 0 under the pin over 315 modules from a clean tree.
That claim was true and it was also a claim about *the modules
`Everything.agda` imports*. This section is about the ones it did not.

Every exit code below was produced by me in this container under the pin —
Agda 2.8.0 (the §6.1 binary, still alive in this session's scratchpad;
`--version` confirmed, not rebuilt) plus cubical v0.9 at
`/root/agda-libs/cubical-v0.9`, `LC_ALL=C.UTF-8` set for every run. No exit
code here is quoted from another agent's report, including for modules a
sibling pass had already run.

### 7.1 The closure, derived rather than trusted

BFS from `Everything` over `^\s*(open\s+)?import\s+<name>` in each reached
file, restricted to modules that exist as files under `formal/cubical/`,
diffed against `find . -name '*.agda'`. At the start of the pass: **367
files, 322 reached, 45 not.**

The 45 split cleanly:

- **9 in `NaturalMachine/Control/`**, which must *never* be reached. I ran
  the opposite check they require: `grep -rn 'NaturalMachine.Control'
  --include=*.agda` over the whole directory returns, outside `Control/`
  itself, **only comment lines** — in `NaturalMachine.agda`,
  `Everything.agda`, `ConstantBoundNotFunctionBound`,
  `ComparisonNeedNotBeInjective`, `LineWorldTransport`, `CompileBridge`,
  `ReachableFromStart`, `FiniteWorldMaximizer`, `InflationVersusSubgroup`,
  `Controls`. Not one is an import. (`NaturalMachine.ControlledGrammar` and
  `NaturalMachine.Controls` are different modules whose names merely share
  a prefix; both are legitimately imported.) The exclusion holds.
- **36 genuine orphans**: 30 under `NaturalMachine/`, `CenterRelative`,
  `PrimePairField`, `SimplicialDefectFailure`, and five `Swarm/` modules.

`SimplicialDefectFailure.agda` was an orphan, exactly as its own author
reported — verified, not taken on the report.

### 7.2 Results under the pin

**Green (exit 0), individually, before being folded in — 33 modules:**

`CenterRelative`, `PrimePairField`, `SimplicialDefectFailure`,
`Swarm/{S05AsiddhaNewton, S08ChebyshevWeight, S09SmithKuttaka,
S11HolonomyDeterminant, S14AssemblyGrading}`, and under `NaturalMachine/`:
`BraidCoherenceBoundary`, `CarryClassNonzero`,
`CompressionDefectRegularWitness`, `DSOFactorRankFinite`,
`DeclaredRootedProfiles`, `EndianAtlasReplay`, `FiniteEquivalenceBridge`,
`FutureSeparation`, `Gamma0`, `GeneratedGrammarDescentBoundary`,
`GroupCohomologyH2`, `OperationalCoverageCounterexample`, `OracleQueries`,
`PhysicalLearningQuotient`, `PiPartialOnEveryPrime`,
`PolyHaythamResponseCostNoGo`, `PolynomialAttachmentGrowth`,
`QuadraticRefinement`, `QuotientUnitSourceCutBoundary`,
`RootedGrothendieck`, `SpernerFromSl2`, `StructuredSymmetryTransport`,
`TransportCost`, `Vacuity`, `WFIScratch1`, `WFIScratch2`.

Two of these need their history stated rather than their exit code alone:

- `PolynomialAttachmentGrowth.agda` exited **42**
  (`[UnsolvedMetaVariables]` at 56.62-75) in my working copy, and **0**
  after I re-ran it against the *working tree* version. The difference is a
  sibling's uncommitted two-token repair (`{S}` bound and passed), which
  landed between my copy and my run. I confirmed this **by diffing the two
  files**, not by believing the coincidence: the only difference is those
  two tokens. The 42 is a fact about a stale copy and is recorded so that
  it is not mistaken for a fact about the module.
- `WFIScratch1`/`WFIScratch2` were green and were then **deleted from the
  tree** by another lane (commit `3b4846c6`) between the sweep and the
  fold-in. They are not imported, because there is nothing to import.

**Not folded in — 3 modules, and the reason is not a typecheck verdict:**

| module | status |
|---|---|
| `NaturalMachine/WalkFastInstance.agda` | **exit 137** — SIGKILL, the OOM killer, on a container running several agents' Agda processes at load ~4.5. Not a typecheck result in either direction. (Folded in by a sibling lane later in the hour; its exit code under the pin remains unestablished *by me*.) |
| `NaturalMachine/DSONucleusMiddleAssociativityAudit.agda` | **UNRUN.** Had not returned after >25 min under the pin. Killed to free the container. |
| `NaturalMachine/DSONucleusResidualAudit.agda` | **UNRUN.** Same, >15 min. |

I am supplying no exit code for the last two. `notes/PIN_SWEEP_NATURALMACHINE.md`
§3 reached the same wall independently at 41 and 30 minutes; that is
corroboration of the wall, not of any verdict.

### 7.3 A real defect the fold-in exposed: a cyclic import

`NaturalMachine/TransportCost.agda` line 30 is `open import NaturalMachine`
— it imports the **root aggregate itself**. Adding it to the root's import
list is therefore a `[CyclicModuleDependency]`, and the first clean run
failed on exactly that:

```
NaturalMachine.agda? no —
NaturalMachine/TransportCost.agda:30.1-27: error: [CyclicModuleDependency]
  NaturalMachine importing NaturalMachine.TransportCost importing NaturalMachine
```

This is worth naming because it is a *structural* orphan, not an accidental
one: `TransportCost` **can never** be reached from the root, no matter how
diligently the root is maintained, so BUILD.md's mechanical check ("run the
root, then look for missing `.agdai`") can never clear it. It is imported
from `Everything.agda` instead, which sits above the root in the dependency
order. Any future module that `open import`s the root inherits the same
constraint.

### 7.4 The clean run

Aggregates edited: 26 imports appended to `NaturalMachine.agda` (the
`NaturalMachine/` orphans), 9 to `Everything.agda` (`CenterRelative`,
`PrimePairField`, `SimplicialDefectFailure`, the five `Swarm` modules,
`TransportCost`, and `HomometricPair` — see below). The
"NOT imported, deliberately … when the schism resolves, fold them in"
block in `Everything.agda` is **superseded by addition**: the schism it
names was the v0.9 `solve!` API, the owner's 2026-08-15 decision is that
the sources track the pin, and all seven of those modules are green under
it. Its text was not deleted.

```
$ cp -r formal/cubical <scratchpad>/euclidfinal3 && rm -rf <…>/_build
$ cd <…>/euclidfinal3 && LC_ALL=C.UTF-8 \
    <scratchpad>/Agda-2.8.0/.../agda --library-file=<v0.9> Everything.agda
EXIT=0
```

- **358 modules checked** (`Checking …` lines; every one of them names a
  file inside the fresh copy — there is no cache hit in the log).
- **0 errors.**
- 200 `UnsupportedIndexedMatch` warnings — the documented F39 boundary, and
  the only warning class emitted.
- The copy had **no `_build` and no `.agdai` anywhere** (`find … -name
  '*.agdai' | wc -l` = 0 before the run). This is a from-scratch check, not
  a re-use of the interfaces my own per-module sweep had just written. Two
  earlier attempts were **discarded rather than published**: the first
  failed on §7.3's cycle, the second on a copy taken in the instant a
  sibling's merge had `WFIScratch1/2` transiently absent.

This supersedes §6.7's **315** with **358**, and does so because the
aggregate now covers 33 modules it did not cover then, not because the
toolchain changed.

### 7.5 Scope limits

1. The corpus moved *while this ran*. Between the closure computation and
   the final run the directory went 367 → 369 files, `WFIScratch1/2` were
   deleted, `WalkFastInstance` was folded in by a sibling, and
   `HomometricPair.agda` appeared as a brand-new orphan (run under the pin,
   EXIT=0, folded in). Everything here is a snapshot. The corpus's own
   standing conclusion applies to this note as much as to the ones before
   it: **regenerate the list, do not quote it.**
2. After the final run the only modules outside `Everything.agda`'s closure
   are the 9 in `NaturalMachine/Control/` (correct) and the two
   `DSONucleus*Audit` modules (§7.2). That is the residue, and it is
   honest to call it the *only* residue as of commit time — no later.
3. Exit 0 is a statement about typechecking, not about whether a module
   says what its comments claim (§5.5, unchanged).
4. The pinned Agda is still **not** `/usr/bin/agda` (2.6.3). §6.5's limit 2
   stands: what survives this session is this table and §6.1's recipe.
5. I did not run anything under 2.6.3/v0.5. Per the owner's decision the
   pin is the toolchain the sources track, and several modules folded in
   here (every `solve!` user) are certainly red under v0.5.

## 8. The exit-137 withholding, discharged

2026-08-15, Claude (Landau-lineage pass). **Addition only** — nothing above
this heading was altered, including §7.2's table, whose `WalkFastInstance`
row I am superseding rather than editing. Every exit code, wall time and
memory figure below was produced by me in this container under the pin:
Agda 2.8.0 (the §6.1 binary, still alive in this session's scratchpad;
`--version` confirmed, **not rebuilt**) + cubical v0.9 at
`/root/agda-libs/cubical-v0.9`, `LC_ALL=C.UTF-8` on every run.

### 8.1 The withholding was right and the verdict is 0

§7.2 withheld `NaturalMachine/WalkFastInstance.agda` at **exit 137** —
SIGKILL, the OOM killer — and refused to call it a typecheck verdict. That
refusal was correct, and it was also the only thing standing between this
module and a false record in either direction.

Re-run under the pin from a tree with **no `_build` and no `.agdai`**:

```
WFI_EXIT=0   wall=13-15s   peak RSS=333-388 MB (two clean runs)   11 modules
```

**No source change was needed and none was made** to obtain this. The
module's own header diagnoses its historical blow-up correctly — the
conversion checker comparing the goal's `next 8` against a second,
independently elaborated `next 8`, cured by binding `facts m 1≤m` with a
`let` that carries *no type signature* — and that diagnosis holds under
2.8.0's conversion checker as well as the 2.6.3 one it was bisected
against. The statements `next 8 ≡ 9`, `next 9 ≡ 11`, `next 10 ≡ 11` are
unchanged, as is every proof of them.

**The order of magnitude is the whole point.** A module needing under 400 MB does not OOM a
16 GB container. The 137 was contention — several agents' Agda processes at
load ~4.5 — precisely as §7.2 suspected. The estimate, stated rather than
gestured at: the module wants about 2.5% of this container's memory, so the
gap between "was killed" and "is unbounded" is a factor of forty, and
nothing about `cap 8 = lcm(1..8) = 840` in unary was ever being normalised.

### 8.2 A measurement trap, recorded because I fell into it twice

My first two attempts reported a peak RSS of **5412 kB** — the *same* number
for an 11 s run and a 166 s run, which is what exposed it. Backgrounding a
`cd … && export … && agda …` compound with `&` makes `$!` the **subshell's**
PID, so `/proc/$!/status` meters bash, not Agda. The figures above and the two
aggregate figures below come from a wrapper script that `exec`s the binary.
An identical peak across runs of different length is the tell.

### 8.3 The aggregates, re-run from a clean tree

`WalkFastInstance` was already imported by `NaturalMachine.agda` (line 658)
— folded in by the sibling lane §7.2 names, *without* an exit code, which
left the root depending on a module whose verdict was unestablished. That is
now closed. Both runs below started from a copy with `_build` removed and
`find -name '*.agdai' | wc -l` = **0**, verified before each run; neither
reuses interfaces written by the run before it.

| aggregate root | exit | modules | errors | wall | peak RSS |
|---|---|---|---|---|---|
| `NaturalMachine.agda` | **0** | 293 | **0** | 138 s | 1237 MB |
| `Everything.agda` | **0** | 359 | **0** | 300 s | 1486 MB |

The 192 warnings under the `NaturalMachine` root are all
`UnsupportedIndexedMatch`, the documented F39 boundary, and there are zero
errors. `WalkFastInstance` is checked at line 1177 of the root log.

`bash scripts/check-agda-closure.sh` exits **1**, on exactly two modules:
`NaturalMachine.DSONucleusMiddleAssociativityAudit` and
`NaturalMachine.DSONucleusResidualAudit` — §7.2's other two withholdings,
which belong to a sibling lane working on them now. `WalkFastInstance` is
inside the closure and is not among them.

### 8.4 Scope limits

1. This pass establishes an exit code for **one** module and re-establishes
   it for the two aggregate roots. It says nothing about the two
   `DSONucleus*Audit` orphans, which I deliberately did not run or touch.
2. Exit 0 is a statement about typechecking, not about whether the module's
   header says what it does. I *read* the header and its bisection log, and
   the code matches its description; I did not re-run the bisection, so the
   per-row timings in that log remain 2.6.3/v0.5 figures and are labelled as
   such in the file.
3. §6.5 limit 2 stands unchanged: the pinned Agda is still not
   `/usr/bin/agda` (2.6.3), and the binary vanishes with this session's
   scratchpad. What survives is this table and §6.1's recipe.
4. I ran nothing under 2.6.3/v0.5. Per the owner's decision the sources
   track the pin.

### 6.6 Warm rebuild of the pin, and a usable second toolchain (2026-08-15, Kronecker)

Two additions to §6.1, both measured in this container today.

- **The pin's binary rebuilds warm in ~11 minutes, not 75.** The Agda 2.8.0
  executable was gone but `~/.cabal/packages` and
  `~/.cabal/share/x86_64-linux-ghc-9.4.7/Agda-2.8.0` (the `prim` bundle) had
  survived, so `cabal get Agda-2.8.0 && cabal build exe:agda
  --ghc-options=-j4` only had to compile and link `Main`. §6.1's 75 minutes
  is the cold figure and remains correct; check for the cabal store before
  paying it. The binary is at
  `/root/Agda-2.8.0/dist-newstyle/build/x86_64-linux/ghc-9.4.7/Agda-2.8.0/x/agda/build/agda/agda`.
- **Agda 2.6.3 + cubical v0.8 is a usable fast lane for the DSONucleus
  subtree**, which §6.2 did not record. v0.5 has no `Cubical.Data.Int.min`
  or `max` at all, which is why 2.6.3 looked useless here; v0.8 has both,
  parses under 2.6.3, and typechecks the whole
  `DSONucleusExecutionCalibration → OneSidedProduct → MiddleProduct →
  {MiddleAssociativityAudit, ResidualAudit}` chain. It is not the pin and no
  green claim should be made from it alone. It is safe for *numerical*
  questions in this subtree specifically: `min`, `max`, `sucℤ`, `predℤ`,
  `_+_`, `_-_` and `≤Dec` are byte-identical between v0.8 and v0.9 (diffed,
  2026-08-15) — which is why a refutation found under v0.8 there could be
  trusted enough to be worth the pin rebuild that confirmed it. See
  `collab/messages/0842-kronecker-audits.md`.
