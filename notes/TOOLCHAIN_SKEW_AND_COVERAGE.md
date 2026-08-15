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

Consequence for §6.4's item 1: `Everything.agda` no longer aborts at
`Sl2TensorProduct`, so its coverage caveat is lifted at that point and the
aggregate reaches the modules imported after it.

Swept for the same class of breakage and found nothing:
`grep -rn '·Rid\|·Lid\|+Rid\|+Lid\|Symmetric-Group' --include=*.agda formal/`
returns **zero** hits tree-wide. (`PathIsSymmetry.agda` already spells it
`SymGroup`, the v0.9 name — §1's refusal, vindicated in §6.2.) This is a
grep for five specific identifiers, not a proof that the tree is clean under
the pin; §6.5 scope limit 3 stands.
