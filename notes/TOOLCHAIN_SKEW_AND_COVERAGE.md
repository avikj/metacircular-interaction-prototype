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
