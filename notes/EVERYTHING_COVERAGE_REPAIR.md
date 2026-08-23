# Everything.agda coverage repair — audit of 2026-08-14

Build-truth repair for `formal/cubical/Everything.agda` and
`formal/check.sh`. The failure mode this fixes is the one the corpus keeps
catching itself in: **an orphan checked once by its author and then never
again by anything**. `Everything.agda` was created precisely to latch that
shut, and then modules kept landing after its creation — so the latch itself
went stale, and `check.sh` never built it, so nothing would ever have
noticed.

Everything below was verified on this container: **Agda 2.6.3, cubical v0.5**
(`~/agda-libs/cubical`, tag `v0.5`, commit `132a2a3`), `LC_ALL=C.UTF-8`.

## 1. Enumeration method

Per BUILD.md's warning, grepping the aggregate's import lines is **not** the
orphan check — it misses transitive reach. Two independent methods were used
and agree:

1. **Transitive import closure**: starting from `Everything.agda`, follow
   `import` / `open import` lines through every locally resolvable module
   to a fixed point (closure of 326 modules before repair, 340 after),
   then subtract from the on-disk module list
   (`formal/cubical/*.agda` + `formal/cubical/Swarm/*.agda`).
2. **Interface files**: every module claimed green has a fresh
   `_build/2.6.3/agda/<M>.agdai` newer than its source, written by the
   kernel during the individual checks below. The two transitively-reached
   Swarm modules (S00, S02) were additionally confirmed by locating the
   actual importing line in checked source
   (`NaturalMachine/TranscriptDescent.agda:23`,
   `ThresholdGenerationDichotomy.agda:67`), not just the closure grep.

On-disk population at audit time: **63 modules** (46 top-level besides
`Everything`, 17 in `Swarm/`). One of them, `HeadDepthTwo.agda`, is
*untracked and was minutes old at audit time* — in-flight from another
session on this shared checkout; it checked exit 0 as found and was included
(see §2).

## 2. Orphans found and their individual check results

19 modules were not reached by `Everything.agda` (18 from the pre-audit
tree, plus the newly landed `HeadDepthTwo`). Each was typechecked
individually with `agda <file>` under the pinned toolchain.

### Green — exit 0, now imported by Everything.agda

| module | exit |
|---|---|
| `BehavioralApartness` | 0 |
| `HeadDepthTwo` (untracked, in-flight) | 0 |
| `Swarm.S01PaniniAshby` | 0 |
| `Swarm.S03CarryFiber` | 0 |
| `Swarm.S04Apoha` | 0 |
| `Swarm.S04ApohaFiniteCompletion` | 0 |
| `Swarm.S06NoWrap` | 0 |
| `Swarm.S07LeadingDigit` | 0 |
| `Swarm.S10VertexOrbit` | 0 |
| `Swarm.S12CyclotomicChain` | 0 |
| `Swarm.S13OptionSpread` | 0 |
| `Swarm.S15ACResidue` | 0 |

`Swarm.S00TranscriptComposition` and `Swarm.S02ModeAdjoint` were *not*
orphans (reached transitively, see §1) but were also verified exit 0 and are
now imported plainly by `Everything.agda` anyway, so the import list — not a
reachability argument — is the coverage claim for the whole `Swarm/`
directory.

### Red — exit 42, documented here, NOT added, NOT touched

All seven fail for the **same root cause**: they use the cubical **v0.9**
API on a container pinned to cubical **v0.5**. This is the
BUILD.md-vs-container toolchain schism (BUILD.md's "Toolchain" section now
pins Agda 2.8.0 + cubical v0.9 after the 2026-08-14 migration; this
container, `formal/check.sh`'s historical usage, and the v0.5 remote-replay
section run Agda 2.6.3 + cubical v0.5). The schism is owned by the
migration lane; these modules were deliberately not modified.

| module | first error (verbatim location) |
|---|---|
| `CenterRelative` | `CenterRelative.agda:80,17-23  Not in scope: solve!` |
| `PrimePairField` | fails through its import of `CenterRelative` (same error, `CenterRelative.agda:80,17-23`) |
| `Swarm.S05AsiddhaNewton` | `Swarm/S05AsiddhaNewton.agda:85,24-30  Not in scope: solve!` |
| `Swarm.S08ChebyshevWeight` | `Swarm/S08ChebyshevWeight.agda:88,27-33  Not in scope: solve!` |
| `Swarm.S09SmithKuttaka` | `Swarm/S09SmithKuttaka.agda:96,13-19  Not in scope: solve!` |
| `Swarm.S11HolonomyDeterminant` | `Swarm/S11HolonomyDeterminant.agda:83,32-38  Not in scope: solve!` |
| `Swarm.S14AssemblyGrading` | fails through its import of `Gamma0Partner` (`Gamma0Partner.agda:55,23-29  Not in scope: solve!`) |

Agda's hint in each case is `did you mean
'Cubical.Tactics.CommRingSolver.Reflection.solve' or 'solve'?` — i.e. the
v0.5 spelling. Per BUILD.md, `solve → solve!` is not a rename: the v0.9
macro parses only an equality boundary, so migrating in either direction is
a source edit (`f = solve R` ⇄ `f _ … _ = solve! R`), not a substitution.

Note the last row carefully: `Gamma0Partner` is **already imported by
`Everything.agda`** and is red under this container's toolchain. The v0.9
migration reached deep into the previously-latched import list (44 files in
the tree use `solve!`/`solveℕ!`/`SymGroup`), which has consequences in §3.

## 3. Full `agda Everything.agda` build — RED, and where it dies

```
$ agda Everything.agda        # Agda 2.6.3, cubical v0.5
exit 42
```

It gets through **2 module starts** and dies on the **third**:

```
Checking Everything ...
 Checking NaturalMachine ...
  Checking NaturalMachine.PathIsSymmetry (...NaturalMachine/PathIsSymmetry.agda).
/home/user/math/formal/cubical/NaturalMachine/PathIsSymmetry.agda:98,50-58
Not in scope:
  SymGroup
```

`SymGroup` is the v0.9 name; v0.5 has `Symmetric-Group`. So under this
container the aggregate fails **inside the NaturalMachine subtree, before
reaching a single one of this audit's additions**. The additions are all
individually exit 0 (fresh `.agdai` for each); the aggregate is red because
the *pre-existing* import list was migrated to v0.9 while the container was
not. Under the BUILD.md toolchain (2.8.0/v0.9) the situation presumably
inverts — modules written against v0.5 (`solve`, `Symmetric-Group`) go red
there. **No single toolchain currently checks the whole directory.** That
is the schism; it is documented here and deliberately not resolved.

## 4. What was changed

- **`formal/cubical/Everything.agda`** — appended a "COVERAGE REPAIR,
  2026-08-14" section: imports for the 12 green orphans plus explicit
  imports of S00/S02, section comments per lane, and a block comment naming
  the 7 excluded red modules with the shared first error, so the file
  itself documents its own gap.
- **`formal/check.sh`** — added an `agda Everything.agda` step, **clearly
  marked ASPIRATIONAL-IF-RED**: a red result prints a loud banner citing
  this note and the schism, and does *not* fail the script; the
  pre-existing five module builds remain the hard gate. The comment in the
  script instructs deleting the fallback (making it hard-fail) the moment
  the schism resolves and the aggregate goes green. Silently swallowing
  the failure would recreate the exact overstatement BUILD.md documents,
  hence the banner on both outcomes.
- **This note.**

Nothing else was modified. No red module was touched. Nothing was
committed (shared checkout).

## 5. Coverage after repair

```
63 modules on disk (top-level + Swarm/)
56 reached by Everything.agda        (closure size 340 incl. NaturalMachine/ and cubical stdlib names)
 7 excluded, red, documented in §2   (CenterRelative, PrimePairField, S05, S08, S09, S11, S14)
 0 undocumented orphans
```

BUILD.md's own coverage snippet (`ls *.agda` vs `grep '^import '`) only
sees top-level files — it will report exactly `CenterRelative` and
`PrimePairField`, which is this note's §2, and it **misses `Swarm/`
entirely**. The closure check in §1 supersedes it.

## 6. Adjacent finding, out of scope, left for its owners

BUILD.md states (2026-08-14): *"The root aggregate now transitively reaches
every module in `NaturalMachine/`"*. That claim has **drifted again** — the
closure shows **23 `NaturalMachine/*.agda` modules not reached from the
`NaturalMachine` root**, among them `FutureSeparation` (which is what made
`Swarm.S04Apoha` look transitively covered until checked), `Gamma0`,
`CostGeometry`, `OracleQueries`, `QuadraticRefinement`, `Vacuity`, and 17
more. This is exactly the rot BUILD.md predicts of hand-maintained lists
("the paragraph above said four, and by the time it was checked the true
count was three"). Some of these are surely in-flight from other sessions
(expected per BUILD.md and not a defect); the rest belong to the
NaturalMachine lane's mechanical orphan check, not to this repair. Not
acted on here beyond this paragraph.

## 7. Reproduction

```sh
export LC_ALL=C.UTF-8 LANG=C.UTF-8
cd formal/cubical
agda Everything.agda                # currently exit 42 at NaturalMachine/PathIsSymmetry.agda:98 (SymGroup)
agda BehavioralApartness.agda      # exit 0 — and so for each §2 green module
agda CenterRelative.agda           # exit 42 at :80 (solve!) — and so for each §2 red module
```
