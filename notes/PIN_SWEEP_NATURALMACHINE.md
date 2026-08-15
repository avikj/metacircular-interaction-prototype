# The root aggregate does *not* reach every module in `NaturalMachine/`

Pin sweep of `formal/cubical/NaturalMachine/`, 2026-08-15, Claude
(Dijkstra-lineage build pass). Owner decision of today: **sources track the
pin** (Agda 2.8.0 + cubical v0.9). Every exit code below was produced in this
container by me, under that toolchain, with `LC_ALL=C.UTF-8` set. Nothing is
quoted from another agent's report.

Repository snapshot: `80ca9023` plus the uncommitted working-tree state at
05:30Z (other sessions were landing modules while this ran; see §5).

## 0. What the task was, and what it turned into

The assignment was a per-module sweep of ~200 modules under the pin, with a
stated shortcut: `formal/cubical/BUILD.md` asserts that the root aggregate
`NaturalMachine.agda` transitively imports **every** module in
`NaturalMachine/`, so a green root would make the sweep redundant. The
instruction was to verify that assertion first.

**It is false, and that is the result of this pass.** The root reaches 238 of
the 272 modules. **34 modules are orphans** — outside the root's closure, and
therefore outside every green claim that has ever been made by quoting the
root's exit code. Five further orphans live in `NaturalMachine/Control/` and
are supposed to be orphans.

BUILD.md predicted this failure mode in its own text — *"a hand-maintained
list of orphans rots in both directions"* — and then had its "CLOSED
2026-08-14" claim rot in exactly that way within the same day: 26 of the 34
orphans have a last-commit date of 2026-08-14 itself, 8 of 2026-08-15, and
two predate the claim (`QuadraticRefinement`, 2026-08-12; `TransportCost`,
2026-08-13).

## 1. Reachability, established two independent ways

Neither method is a grep of the root's import lines, which BUILD.md correctly
says gives the wrong answer.

1. **Source-level transitive closure.** BFS from `NaturalMachine` over
   `^\s*(open\s+)?import\s+<name>` in each reached file, restricted to
   `NaturalMachine.*`. 238 modules reached.
2. **Interface files, the ground truth BUILD.md names.** After the root run
   below completed, `find _build -name '*.agdai' -path '*NaturalMachine*'`
   listed exactly 238 modules.

The two sets are **equal** — `comm` reports no element on either side. The
`.agdai` snapshot was taken before any orphan was compiled into that
`_build`, so it is not contaminated by this sweep's own runs.

Independently: every `Checking NaturalMachine.*` line the root emitted names
a module in the BFS set; none names a module outside it.

## 2. The root under the pin

```
$ cd <copy of formal/cubical> && LC_ALL=C.UTF-8 \
    <scratchpad>/Agda-2.8.0/.../agda --library-file=<v0.9 libraries> NaturalMachine.agda
EXIT=0
```

Zero errors. This reproduces `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.2's
root result on a tree that has moved since, and it is a genuine statement
about 238 modules. It is **not** a statement about the directory, and anyone
who has been quoting it as one has been overstating by 34 modules.

## 3. The orphans, run individually under the pin

Each was run standalone: `agda --library-file=<v0.9> <file>` with
`LC_ALL=C.UTF-8`, from a tree whose `_build` had been warmed by the root run
above (so a red result is the module's own, not a dependency's).

**Green under the pin (31 of 34):**

`AdvanceGate`, `BraidCoherenceBoundary`, `CarryClassNonzero`, `ChuAdvance`,
`CompressionDefectRegularWitness`, `CostGeometry`, `CostGeometryWitness`,
`DSOFactorRankFinite`, `DeclaredRootedProfiles`, `EndObstruction`,
`EndianAtlasReplay`, `FiniteEquivalenceBridge`, `FutureSeparation`, `Gamma0`,
`GeneratedGrammarDescentBoundary`, `GroupCohomologyH2`, `KFlow`,
`OperationalCoverageCounterexample`, `OracleQueries`,
`PhysicalLearningQuotient`, `PolyHaythamResponseCostNoGo`,
`QuadraticRefinement`, `QuestionMachine`, `QuotientUnitSourceCutBoundary`,
`Residual`, `RootedGrothendieck`, `StructuredSymmetryTransport`,
`TransportCost`, `TransportDiv`, `TransportDivWitness`, `Vacuity` — all
`EXIT=0`.

**One red, and it is not a rename:**

```
NaturalMachine/PolynomialAttachmentGrowth.agda:56.62-75: error:
  [UnsolvedMetaVariables]   EXIT=42
```

Line 56 is the middle of `old-cannot-fill`:

```agda
old-cannot-fill : {S : Signature} (term : Term S) → ¬ (embed term ≡ filler)
old-cannot-fill term equality =
  false≢true (sym (old-is-not-filler term) ∙ cong isFiller equality ∙ filler-is-new)
```

The unsolved meta is `filler-is-new`'s implicit `{S}`. 2.6.3 guessed it from
the composition; 2.8.0 does not. **Repaired, and the repair is two tokens
that change no statement and no proof term:** bind the implicit in the clause
and pass it, `old-cannot-fill {S} term equality = … ∙ filler-is-new {S}`. The
signature, the type of every subterm, and the theorem are untouched; the only
well-typed instantiation is the one the composition already forces, which is
why this is an annotation and not a mathematical choice. Verified `EXIT=0`
under the pin after the edit.

I have **not** claimed this makes the file green under 2.6.3/v0.5 — I did not
run it there, and per the owner's decision I did not need to.

**Two not completed — recorded, not guessed:**

`DSONucleusMiddleAssociativityAudit.agda` and `DSONucleusResidualAudit.agda`
were **still typechecking after 41 and 30 minutes** respectively when I
stopped waiting, on a container running a dozen other agents' Agda processes
concurrently, and neither had returned. Those are observed lower bounds on
one loaded machine, not measurements of the modules' cost, and I am not
turning them into one: I do not know whether either terminates, and the
container's load is not controlled. Their content explains it: the first is
64 exhaustive `middle-assoc` cases, each a `funExt` over four `refl`
normalisations of a min/max product; the second decides pointwise integer
order on generated profiles by `≤Dec`. **I have no exit code for these two
and I am not supplying one.** Note what the reachability finding implies
about them: they are orphans, so nothing has ever re-run them since they
landed, and no `.agdai` for either exists anywhere in the repository's
`_build` under 2.6.3 *or* 2.8.0. That is the standing cost of an orphan, and
it is the same cost this note's main finding is about.

## 4. `NaturalMachine/Control/` — failure is the pass condition

All five Control modules exit 42, and — checked by reading each error, not by
reading the exit code — each fails with `[UnequalTerms]` at the intended
mathematical site, not with a scope or rename error:

| module | line | error |
|---|---|---|
| `Control/InflationFlattened.agda` | 91.28-32 | `k0 != kι of type H2` |
| `Control/MaximizerWithoutNonvanishing.agda` | 84.23-34 | `NonVanishing W → Σ-syntax Pt (MaxAt W) !=< Σ Pt (MaxAt W)` |
| `Control/QuantifierDrop.agda` | 80.26-41 | `rollover (val s + 0 · val s) != mod5 …` |
| `Control/WrongEquivalence.agda` | 37.63-65 | `Unit !=< (Canonical w)` |
| `Control/WrongFirstStep.agda` | 59.25-29 | `0 != 1 of type Nat` |

These are passes. They are not defects and must not be added to any
aggregate. Note the standing weakness of failure-as-pass controls, already
recorded in `TOOLCHAIN_SKEW_AND_COVERAGE.md` §5.6 and unchanged by this pass:
exit 42 plus an eyeballed error message is weaker than a proof that the file
cannot fail for an unrelated reason. Reading the message is what distinguishes
a control from a broken file, and it is why §3 above records diagnoses rather
than exit codes alone.

## 5. Scope limits

1. The pinned Agda is **not** `/usr/bin/agda` (still 2.6.3). It is the
   2.8.0 binary built from Hackage against GHC 9.4.7 by the pass recorded in
   `TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1, surviving in this session's
   scratchpad; the v0.9 clone is `/root/agda-libs/cubical-v0.9`. I did not
   rebuild it — I located it and confirmed `--version` reports 2.8.0. When
   the scratchpad goes, so does the environment; §6.1's recipe is what
   survives.
2. Upstream's v0.9 `.agda-lib` names the library `cubical-0.9`. Rather than
   edit the shared clone while sibling sessions were reading it, I set
   `depend: cubical-0.9` in **my scratchpad copy** of
   `natural-machine.agda-lib`. No repository file was changed for this.
3. Runs were made in a scratchpad copy of `formal/cubical`; no v0.9 interface
   file entered the repository's `_build`.
4. Other sessions were adding modules to `NaturalMachine/` during this pass —
   the directory grew by three files between my snapshot and the end of the
   run (`SpernerFromSl2.agda` among them). The orphan list is a snapshot,
   which is precisely why BUILD.md's mechanical check must be run rather than
   this note quoted.
5. Top-level `formal/cubical/*.agda` is another agent's lane and was not
   touched here — including `NaturalMachine.agda` itself, which is where the
   34 missing imports belong. As this note was being written that lane had an
   uncommitted diff adding 26 of them (plus `PiPartialOnEveryPrime`,
   `SpernerFromSl2` and two `WFIScratch` modules that landed after my
   snapshot). Note that its list includes `PolynomialAttachmentGrowth`: had
   §3's implicit-argument repair not landed first, folding that module in
   would have turned the root red.
6. Exit 0 is a statement about typechecking, not about whether a module says
   what its comments claim.
