# Orphan sweep 3: the 83 modules `Everything.agda` did not name, and the pin that turned out to be in this container after all

**Claude, 2026-08-19, librarian pass.** Every exit code below was produced by
me, in this container, by running the command shown. None is quoted from
another agent's report. Each is labelled with its toolchain, per
`notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md`'s standing rule.

Starting commit for the coverage figures: **`eeae2361`**. The tree moved under
me while the sweep ran (§7) — that is recorded rather than smoothed over.

---

## 0. The headline, and it is a correction to my own brief

I was told, as verified context, that this container has Agda 2.6.3 + cubical
v0.5 via a **scratchpad** clone, that the declared pin (Agda 2.8.0 + cubical
v0.9 at `b150186`) is **not here**, that `./check.sh` exits 2 before reaching
Agda, and that I must therefore not call anything a pin check.

**Two of those four are false as of 2026-08-19 23:27Z, and I checked rather
than inherited.**

| claim in my brief | what I measured | command |
|---|---|---|
| cubical registered via a *scratchpad* clone | **false** — `/root/agda-libs/cubical`, tag `v0.5`, commit `132a2a3` | `cat ~/.agda/libraries`; `git -C /root/agda-libs/cubical describe --tags` |
| the pin is **not** in this container | **false** — Agda **2.8.0** at `/root/Agda-2.8.0/dist-newstyle/build/x86_64-linux/ghc-9.4.7/Agda-2.8.0/x/agda/build/agda/agda`, and cubical **v0.9 at commit `b150186`** at `/root/agda-libs/cubical-v0.9` | `… /agda --version` → `Agda version 2.8.0`; `git -C /root/agda-libs/cubical-v0.9 describe --tags` → `v0.9`, `log -1` → `b150186` |
| `./check.sh` exits 2 before reaching Agda | **false when pointed at the pin** — it prints `RUNNING AGAINST THE PIN` and returns 0 on a green module | `AGDA_PIN=… AGDA_CUBICAL_LIB=/root/agda-libs/cubical-v0.9 NM_MODULES="Ananta.agda" ./check.sh` → `CHECKSH_EXIT=0` |
| Agda 2.6.3 is the default `agda` | **true** | `agda --version` → `Agda version 2.6.3` |

`check.sh`'s own header (lines 8–27) still says "THIS CONTAINER CANNOT REACH
THAT PIN", citing a `cabal update` 403 and a v0.9 checkout *deliberately
renamed* to `cubical-v0.9-needs-agda-2.7-plus` so the script would not select
it. That header was true when written and is now stale: someone built Agda
2.8.0 into `/root/Agda-2.8.0` and unparked the library. I did not do either;
I found an Agda 2.8.0 process of another lane running while I worked
(`ps`, pid 13112, `--library-file=/tmp/tmp.LXf7tCMrId`). The header is not
edited here — it belongs to whoever owns the script — but **it should be,
and until it is, a reader of `check.sh` will conclude the opposite of the
truth.**

Consequence for this note: **the sweep below is a PIN sweep**, run through
`check.sh` under `LC_ALL=C.UTF-8`, and I say so with the exact binary and
library paths rather than a bare "EXIT=0". Where I also ran the container
toolchain (Agda 2.6.3 + `/root/agda-libs/cubical` v0.5), the table says so.

---

## 1. ROT-BACK: the dangling import does not exist at `eeae2361`, and I can name what did

My brief reported ROT-BACK 1 — one import naming a missing file — and asked
me to determine whether it was deleted, renamed, or never existed.

```
cd /home/user/math/formal/cubical && LC_ALL=C.UTF-8 ./check-everything-coverage.sh
```

at `eeae2361` prints **no ROT-BACK section at all** (the script emits one only
when the count is non-zero; `nb=0`). Independently, resolving every import
line by hand:

```sh
grep -E '^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+' Everything.agda \
  | sed -E 's/^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+//; s/[[:space:]].*$//' \
  | sort -u | while read m; do p=$(echo "$m"|tr '.' '/').agda; [ -f "$p" ] || echo "DANGLING: $m"; done
```

prints nothing. **Absence stated with its delimitor** (per
`notes/NO_BARE_ABSENCES.md`): what is absent is *any module name appearing on
an anchored `import` line of `formal/cubical/Everything.agda` for which
`<name with dots→slashes>.agda` does not exist relative to
`formal/cubical/`*; the locus is that file at commit `eeae2361`; the
delimitor is the latch's own resolution rule (step 3b of
`check-everything-coverage.sh`), which is path-existence, not name resolution
by Agda.

**What it was, traced rather than guessed.** The only recent candidate is
`import CakravalaDescent` (`Everything.agda:578`), added by commit
`a1e105bd` — a commit whose entire subject is *"the dangling citation that
pointed at it"*. In **git**, the import line and `CakravalaDescent.agda`
always co-exist:

| commit | `^import CakravalaDescent$` | `CakravalaDescent.agda` in tree |
|---|---|---|
| `dfe6f1cc` | 0 | absent |
| `3cf77ff1` | 1 | present |
| `1e15b517` | 1 | present |
| `eeae2361` | 1 | present |

So the file was **not deleted, not renamed, and did not fail to exist** in any
committed state. The file's mtime is `23:16:33Z`, the timestamp of merge
`3cf77ff1`; the merge that brought this branch to `eeae2361` finished at
`23:19:02Z`.

**Diagnosis, and it is a defect in the instrument, not in the corpus:**
`check-everything-coverage.sh` reads `Everything.agda` with `grep` and tests
the files with `[ -f ]` — **two reads of the working tree with no atomicity
guard**. Run during a `git merge`'s checkout, it can see the new import line
before the new file lands, and report rot-back where git has none. That is
precisely the third destructive-event shape this corpus watches for
(`notes/REGISTRY_DELETION_142bba1f.md`) inverted into a *false* alarm — and
it is the `yogya-anupalabdhi` failure of
`MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md`'s last addendum in a new
place: **a checker that cannot tell "absent file" from "file not checked out
yet" reports the same thing for both.**

Suggested repair, for whoever owns the script (not applied here — it is not
my file and the fix needs its owner's judgement): resolve imports against
`git ls-files` / `git show HEAD:` rather than the working tree, or refuse to
run when `git status --porcelain` reports a merge in progress.

**Nothing was restored, because nothing was lost.**

---

## 2. Scope, stated as a count with its scope quoted

At `eeae2361`, the latch's enumeration scope is **197 modules**: the
`formal/cubical/*.agda` top level (181 files, minus `Everything.agda` itself
= 180) plus `formal/cubical/Swarm/*.agda` (17). It is *not* "197 top-level
modules" — 17 of them are in `Swarm/`. The `NaturalMachine/` subtree
(including `NaturalMachine/Control/`, which must never be reached) is
deliberately outside this enumeration and is covered transitively through the
`NaturalMachine` root import.

Of those 197, **83 were named by no import line** (ROT-FORWARD 83), and one
import line was duplicated (`HeadDepthTwo`, a non-fatal WARNING).

---

## 3. The cycle trap, checked before folding

`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §7.3 records
`NaturalMachine/TransportCost.agda:30`, which does `open import
NaturalMachine` — so listing it in the root is a `[CyclicModuleDependency]`
and it can never be reached from there. The analogous trap for this latch is
an orphan that imports `Everything`. Checked over all 83, with the same
anchored-import delimitor the latch uses:

```sh
while read m; do grep -Eq '^[[:space:]]*(open[[:space:]]+)?import[[:space:]]+Everything([[:space:]]|$)' "$m.agda" && echo "CYCLE: $m"; done < orphans.txt
```

**Zero cycles.** Re-checked for `DisclosureDimension` (§7) separately: also
none. So every module folded in below is reachable from `Everything` in
principle, and the fold-in cannot be self-defeating in the §7.3 way.

---

## 4. The sweep: 83 modules, individually, under the pin

```
cd /home/user/math/formal/cubical
AGDA_PIN=/root/Agda-2.8.0/dist-newstyle/build/x86_64-linux/ghc-9.4.7/Agda-2.8.0/x/agda/build/agda/agda \
AGDA_CUBICAL_LIB=/root/agda-libs/cubical-v0.9 \
NM_MODULES="<the 83, space-separated>" ./check.sh
```

`check.sh` announced `RUNNING AGAINST THE PIN` — `agda 2.8.0`, `cubical
/root/agda-libs/cubical-v0.9`, `locale LC_ALL=C.UTF-8` — and ran all 83
without stopping at the first red. **`CHECKSH_EXIT=1`**, which is correct:
its contract is exit 0 only if *every* module exited 0.

**Result: 59 × `EXIT=0`, 24 × `EXIT=42`. Zero timeouts, zero exit 137.**

### 4.1 Green under the pin — 59, all folded in

`AksaraDviguna` `AmshaSatyayantra` `Ananta` `AnuktaAvaktavya` `ArchivistLane`
`Asiddhatva` `AsiddhavatRegime` `BhavanaKrida` `Bija` `ChitiDvipada`
`Citighana` `Dvipada` `Gati` `Gurutama` `GurutamaSiddha` `Khahara`
`MatraSamasa` `MatraVarnaGuru` `Matramerus` `Meru` `MeruKarna` `MeruSammiti`
`Narayana` `NarayanaKarna` `NarayanaSamasa` `Niksepa` `Panini` `PanktiYoga`
`PingalaGhata` `PingalaPrastara` `PingalaSatya` `PrastaraPankti` `Purnata`
`Sadhyata` `SamasaDvi` `SamasaDviAmsa` `SamasaEkAmsa` `SamasaEka`
`SamasaEkagra` `SamasaMeru` `SamasaMeruN` `SamasaNyuna` `Samasesha`
`Sankalita` `SaptabhangiNaya` `Satyayantra` `SatyayantraSamyoga` `SeamClosed`
`Setu` `Shadrasa` `Shredhi` `Sthairya`
`Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction` `TraceCorpus`
`VaraSankalita` `VargaGulma` `Vargacitighana` `Yugapat` `Yuti`

Each: **`EXIT=0` (pin: Agda 2.8.0 + cubical v0.9 @ `b150186`, via `check.sh`,
`LC_ALL=C.UTF-8`)**. Each is `--safe` by its own `OPTIONS` pragma; `check.sh`
reports `errors: 0` for all 59, and `warning lines: 7` for `ArchivistLane`
only, 0 for the rest.

### 4.2 Red under the pin — 24, each with its first error

| module | missing/ambiguous name | first error site (pin) | container (2.6.3 + v0.5) |
|---|---|---|---|
| Ardhaccheda | `solve` | `Vargana.agda:67.17-22` | EXIT=0 |
| BhavanaSamuha | `solve` | `Brahmagupta.agda:47.19-24` | EXIT=0 |
| Brahmagupta | `solve` | `Brahmagupta.agda:47.19-24` | EXIT=0 |
| Cakravala | `solve` | `Brahmagupta.agda:47.19-24` | EXIT=0 |
| CakravalaBound | `solve` | `CakravalaBound.agda:141.13-18` | EXIT=0 |
| CakravalaNat | `solve` | `CakravalaNat.agda:84.14-19` | EXIT=0 |
| CakravalaWitness | `solve` | `BhavanaSemiring.agda:69.12-17` | EXIT=0 |
| DviGhataVargana | `solve` | `Vargana.agda:67.17-22` | EXIT=0 |
| Dvikarani | `solve` | `Dvikarani.agda:85.16-21` | EXIT=0 |
| GhanaBaddha | `solve` | `GhanaBaddha.agda:39.14-19` | EXIT=0 |
| GrahaYuti | `solve` | `YugapatZ.agda:44.11-16` | EXIT=0 |
| GunaDhana | `solve` | `Vargana.agda:67.17-22` | EXIT=0 |
| IndianLane | `solve` | `Kuttaka.agda:87.15-20` | EXIT=0 |
| Jiva | `solve` | `YugapatZ.agda:44.11-16` | EXIT=0 |
| KuttakaCRT | `solve` | `YugapatZ.agda:44.11-16` | EXIT=0 |
| Madhava | `·Rid` | `Madhava.agda:57.30-34` | EXIT=0 |
| SamanyaGhata | `solve` | `Vargana.agda:67.17-22` | EXIT=0 |
| Shunya | `solve` | `Shunya.agda:63.16-21` | EXIT=0 |
| **SubgroupIndex** | `⟪_⟫` **ambiguous** | `SubgroupIndex.agda:155.45-50` | **EXIT=42** |
| Sulba | `solve` | `Sulba.agda:42.15-20` | EXIT=0 |
| Trikarani | `solve` | `Trikarani.agda:71.16-21` | EXIT=0 |
| Vargana | `solve` | `Vargana.agda:67.17-22` | EXIT=0 |
| VargaprakritiSreni | `solve` | `Brahmagupta.agda:47.19-24` | EXIT=0 |
| YugapatZ | `solve` | `YugapatZ.agda:44.11-16` | EXIT=0 |

Cause histogram under the pin: **22 `solve`, 1 `·Rid`, 1 `⟪_⟫` ambiguity.**

The container column is a second, independent run — `LC_ALL=C.UTF-8 agda -i .
<M>.agda` with `/usr/bin/agda` 2.6.3 against `/root/agda-libs/cubical` v0.5 —
performed on exactly these 24, precisely so the classification in §5 rests on
two toolchains rather than one. **23 of 24 are container-green.**

---

## 5. Classification, and the OUTSTANDING list

The task's category (a) was "a v0.9-only name that cannot work here". **What
this sweep found is that category running backwards**, and that is the single
most useful thing in this note:

- **(a′) v0.5-only name under the v0.9 pin — 23 modules.** Everything except
  `SubgroupIndex` in §4.2. They typecheck under 2.6.3 + v0.5 and fail under
  2.8.0 + v0.9, on `solve` (v0.9 spells the CommRing solver `solve!`; Agda
  even offers the suggestion, *"did you mean
  `Cubical.Tactics.CommRingSolver.Reflection.solve!`?"*, at `Sulba.agda:42`)
  and on `·Rid` (v0.9 spells it `·IdR`). **Not folded in.** The repair is a
  source rename owned by the lane that wrote them, not an import line in
  `Everything.agda`, and folding them in would put 23 known-red modules
  behind a name.
- **(b) a genuine error — 1 module: `SubgroupIndex`.** It is red on **both**
  toolchains with the **same** first error: `⟪_⟫` is ambiguous between
  `Cubical.Relation.Nullary.⟪_⟫` (opened at `SubgroupIndex.agda:101`) and
  `Cubical.Algebra.Group.Subgroup.⟪_⟫` (opened at line 115). This is not pin
  drift; it is two `open`s in one file. The fix is a `using`/`hiding` or a
  qualification at line 155, and it is a two-token edit.
- **(c) must fail by design — 0 modules.** Stated with its delimitor: within
  the latch's enumeration scope (top-level `*.agda` + `Swarm/*.agda` at
  `eeae2361`), no module carries a "must not typecheck" marker; the only such
  set in this repository is `NaturalMachine/Control/`, which is **outside**
  this scope and is reached by nothing (`Everything.agda` lines 65–68).

### OUTSTANDING — the 24 the latch is still red on, and why each is deliberate

**OUTSTANDING-A (23): pin-red, container-green, cause is a v0.5 spelling.**
Ardhaccheda, BhavanaSamuha, Brahmagupta, Cakravala, CakravalaBound,
CakravalaNat, CakravalaWitness, DviGhataVargana, Dvikarani, GhanaBaddha,
GrahaYuti, GunaDhana, IndianLane, Jiva, KuttakaCRT, Madhava, SamanyaGhata,
Shunya, Sulba, Trikarani, Vargana, VargaprakritiSreni, YugapatZ.
*Unblocked by:* renaming `solve` → `solve!` and `·Rid` → `·IdR` in the **six
files that actually carry the occurrences** — `Vargana.agda:67`,
`Brahmagupta.agda:47`, `YugapatZ.agda:44`, `Dvikarani.agda:85`,
`GhanaBaddha.agda:39`, `CakravalaBound.agda:141`, `CakravalaNat.agda:84`,
`Shunya.agda:63`, `Sulba.agda:42`, `Trikarani.agda:71`, `Madhava.agda:57` —
plus, outside the orphan set, `Kuttaka.agda:87` and `BhavanaSemiring.agda:69`.
The dependents clear themselves.

**OUTSTANDING-B (1): `SubgroupIndex`** — a real ambiguity at
`SubgroupIndex.agda:155`, red on both toolchains, blocking nothing else.

---

## 6. The registered prediction, tested — and it half-held

`notes/CONTAINER_PIN_AUDIT.md` §2 registered a prediction *before* its audit:
which modules use `solve!` and `SymGroup` in code, hence which are red on the
container. §3 then honestly re-graded it as "a right theory with a wrong
list". My brief asked me to test that registered prediction against my reds,
on the ground that a tested registered prediction is worth more than a sweep.
Here is the test, and it is worth reporting in three parts.

**(i) Applied to the 83, the prediction names exactly one module.** Grepping
the 83 for the four v0.9-only names the audit ended up naming (`solve!`,
`solveℕ!`, `SymGroup`, `·IdR`), with `--` line comments stripped:
**`SubgroupIndex` alone**, on `·IdR`. Every other one of the 83 is predicted
green *on the container*.

**(ii) The verdict held; the mechanism did not.** `SubgroupIndex` is indeed
container-red (`EXIT=42`, Agda 2.6.3 + v0.5). But its first error is **not**
`·IdR`: it is the `⟪_⟫` ambiguity, identical to the one it hits under the
pin. And the audit's premise for that row is checkable and **wrong** —
`·IdR` is present in cubical **v0.5**: `grep -rl '·IdR'
/root/agda-libs/cubical/Cubical/` matches **80 files**, and
`Cubical/Algebra/Monoid/Base.agda:32` declares `·IdR : (x : A) → x · ε ≡ x`.
So the audit's fourth "v0.9-only name" is not v0.9-only at all. (This is a
claim about **file contents**, stated with its command, not about name
resolution — the compiler's verdict is the `EXIT=42` above, and it names a
different cause.)

**(iii) The prediction's theory is incomplete in a way the sweep exposes.**
`CONTAINER_PIN_AUDIT.md` §3 concluded "every one of the 23 failures is pin
drift, and there is no second cause". Over **this** population there *is* a
second cause — `SubgroupIndex`'s double-`open` — and, far more importantly,
the drift is **bidirectional**: 23 of my 24 reds are modules written for the
container that the *pin* rejects. The audit could not see that direction
because it only ran the container. So: the registered prediction held on its
one in-scope verdict, failed on that verdict's stated reason, and its
governing sentence ("no second cause") does not survive contact with a
different population. **That is a more useful outcome than a clean pass**,
and it is only visible because §2 was committed before §3.

---

## 7. The tree moved while this ran — recorded, per §7.5's own rule

`TOOLCHAIN_SKEW_AND_COVERAGE.md` §7.5 warns: *"regenerate the list, do not
quote it."* It happened again, twice, in ninety minutes:

1. **`DisclosureDimension.agda`** appeared at `23:25:57Z` — committed by
   another lane as `cb441fc6`, after my 83-module list was frozen at
   `23:22Z`. It is a **84th** orphan by the same latch. I did not quietly
   extend the population: I ran it separately under the same pin
   (`RUNNING AGAINST THE PIN`, `EXIT=0`, `CHECKSH_EXIT=0`), checked it for the
   §3 cycle (none), and folded it in with a comment saying exactly this.
2. `HEAD` moved from `eeae2361` to `cb441fc6` beneath me, and another agent
   has `formal/cubical/NaturalMachine.agda` modified and two untracked
   `NaturalMachine/*.agda` files in this shared worktree. **I staged only my
   own files.** Nothing here is a claim about their work.

**Also abandoned, and recorded rather than deleted:** my first sweep was a
container sweep (`LC_ALL=C.UTF-8 agda -i . <M>.agda`, Agda 2.6.3 + v0.5). It
reached **4 of 83** in five minutes — `AksaraDviguna`, `AmshaSatyayantra`,
`Ananta`, `AnuktaAvaktavya`, all `EXIT=0` — and then spent ten minutes inside
`ArchivistLane`'s 57-module closure. I killed it when I discovered the pin was
available, because a pin result strictly dominates a container result for a
fold-in decision, and re-ran the container toolchain only where it was
diagnostically load-bearing (the 24 reds, §4.2). Those four container greens
are stated here so the abandoned run is not a silent absence.

---

## 8. What changed in `Everything.agda`, and what the latch says now

Three edits, all additive except one deletion of a duplicate:

1. **+59 imports** (§4.1) under a block header that names the pin binary, the
   library commit, the locale, and the count.
2. **+1 import**, `DisclosureDimension` (§7.1), with its own provenance note.
3. **−1 duplicate** `import HeadDepthTwo` at the old line 237 — the latch's
   non-fatal WARNING. The module stays imported once, at line 187, under the
   fuller comment; the deleted line's comment is **kept in place as a
   comment**, because it says something the surviving one does not, and it
   now records that the duplicate was removed and when.

Re-run, same command, same commit-of-record for the file:

```
cd /home/user/math/formal/cubical && LC_ALL=C.UTF-8 ./check-everything-coverage.sh
```

```
   modules on disk (top-level + Swarm, excl. Everything): 198
   distinct import lines in Everything.agda             : 180
ROT-FORWARD (24): …the 24 modules of §5's OUTSTANDING lists…
LATCH_EXIT=1
```

- **ROT-BACK: 0.**
- **Duplicate WARNING: gone.**
- **ROT-FORWARD: 83 → 24**, and the 24 are exactly §5's OUTSTANDING-A (23) +
  OUTSTANDING-B (1). The latch's red is now **a stated set with a per-module
  first error and a named repair**, not a heap.

The latch still exits 1, and it **should**: 24 modules genuinely are not
covered. Closing it requires the source renames of OUTSTANDING-A and the
two-token fix of OUTSTANDING-B, neither of which is an import-list edit.

---

## 9. Scope limits

1. **A green coverage latch is not a build**, and this note does not claim
   one. What it adds to the corpus is the *second* conjunct of
   `EVERYTHING_COVERAGE_LATCH.md`'s honest aggregate claim, for 60 modules:
   each of the 59 + `DisclosureDimension` exited 0 **individually** under the
   pin. I did **not** run `Everything.agda` itself.
2. **And I could not have gotten 0 if I had.** `Everything.agda` was already
   red under the pin *before* my edit, and I have the evidence without a
   separate run: `CakravalaWitness` fails at `BhavanaSemiring.agda:69`, and
   `IndianLane` at `Kuttaka.agda:87` — and `Everything.agda` has imported both
   `BhavanaSemiring` and `Kuttaka` since 2026-08-18. So the aggregate's exit
   code is red on the pin for reasons that predate and outlive this pass.
   **Folding in 60 green modules does not change it and is not claimed to.**
   This also disposes of the instruction I was given to protect the
   aggregate's greenness by withholding: there was no greenness to protect on
   either toolchain. I withheld the 24 anyway, for the better reason in §5 —
   a known-red module behind an import line is a name standing in for a check.
3. **`EXIT=0` is typechecking, not truth-in-comments** (§5.5 of
   `TOOLCHAIN_SKEW_AND_COVERAGE.md`, unchanged). I read none of the 60
   modules' mathematics.
4. **The container column of §4.2 covers 24 modules, not 83.** For the other
   59 I have a pin verdict only, plus four container greens from the
   abandoned run (§7). No claim is made about the container status of the
   remaining 55.
5. **Everything here is a snapshot**, and the tree demonstrably moves faster
   than the note (§7). Regenerate the list; do not quote it.

---

## 10. The `comp` clash: named, located, repaired, and re-checked on both toolchains

While this pass ran, the coordinator sent a correction confirming §0
independently (the pin is reachable; `check.sh` announces `RUNNING AGAINST
THE PIN`) and added a measurement I did not have: their default
`LC_ALL=C.UTF-8 ./check.sh` on the pin gave

```
EXIT 0   -- NaturalMachine.agda
EXIT 42  -- Everything.agda   : name clash on `comp` against Cubical/Core/Primitives.agda:16
EXIT 42  -- IndianLane.agda   : Kuttaka.agda:87.15-20 [NotInScope] `solve`
CHECKSH_EXIT=1
```

(That is their run, labelled as theirs. The `IndianLane` row reproduces my
§4.2 row exactly, from a separate invocation — two independent runs agreeing
on a first error and a column number.)

**Which module defines `comp`:** `NaturalMachine/GterTwoCoordinate.agda:205`,
`comp : Rel Σ₀ Σ₁ → Rel Σ₁ Σ₂ → Bool`, found by
`grep -rn "comp : Rel" --include=*.agda .` over `formal/cubical/` — **one
match, no others**. It is reached from `Everything.agda:432`
(`import NaturalMachine.GterTwoCoordinate`), which is why it is the
aggregate's first error rather than the subtree root's: `NaturalMachine.agda`
does not import it.

**It was already on record, and misdiagnosed.**
`NaturalMachine/TheTwoPigeonholesAreInterderivableSoNothingAboutFiniteSetsIsLeftInTheOpenItem.agda`
§0 reports the same module at the same line — *"GTER_EXIT=42 … Multiple
definitions of comp"* — under the container, and then conjectures: *"under
the declared pin it evidently does not fire."* **That conjecture is
refuted.** It fires under the pin too, as a name clash while scope-checking
the same signature. The same §0 files it under "three distinct causes, all
from the container not being the pin"; this one is not a container artefact
at all. A shadowing of a `--cubical` primitive is toolchain-independent, and
that is the general lesson worth keeping: `solve`/`solve!` drift is a fact
about *library versions*, a `comp` clash is a fact about *this source file*,
and lumping them under "pin skew" put a fixable defect in the excused pile
for as long as nobody could run the pin.

**Repair, and it is the mechanical rename the coordinator sanctioned:**
`comp` → `compCut` at its definition (`:205`), its body, and its single use
site (`cell`, `:215` pre-edit). Three tokens. The four witnesses, the two
independence theorems, `sepOf`/`compOf` and every stated result are
untouched; the D0026 §7.3 name is recorded in the comment so the
correspondence with the source paper is not lost.

**Re-checked, and this is the whole point of doing it here rather than
handing it on:**

```
cd formal/cubical
AGDA_PIN=…/Agda-2.8.0/…/agda AGDA_CUBICAL_LIB=/root/agda-libs/cubical-v0.9 \
  NM_MODULES="NaturalMachine/GterTwoCoordinate.agda" ./check.sh
  → RUNNING AGAINST THE PIN;  EXIT=0 (errors: 0, warnings: 0);  CHECKSH_EXIT=0
LC_ALL=C.UTF-8 agda -i . NaturalMachine/GterTwoCoordinate.agda
  → EXIT=0  (container: Agda 2.6.3 + cubical v0.5 @132a2a3 — NOT the pin)
```

**Green on both toolchains, where it was red on both.** The module's header
claim — *"Nothing here is measured, fitted, or floating-point"* — is now
checkable by anyone, which it had not been on either toolchain; I make no
claim about whether it is true, only that the kernel now gets to look.

### 10.1 What `Everything.agda` will fail on next — derived, not measured

I am **not** supplying an exit code for `Everything.agda`. I started
`NM_MODULES="Everything.agda" ./check.sh` under the pin and it had not
returned when this note was committed, on a container running at least one
other agent's Agda 2.8.0 against the same `_build/2.8.0` interfaces. Per
§7.2 of `TOOLCHAIN_SKEW_AND_COVERAGE.md`'s precedent, **UNRUN is reported as
UNRUN**, not rounded to a verdict in either direction.

What I can state without the run, because it follows from measurements I did
make: **`Everything.agda` is still red under the pin after the `comp`
repair.** It imports `BhavanaSemiring` and `Kuttaka`; §4.2 records
`CakravalaWitness` failing at `BhavanaSemiring.agda:69.12-17` and
`IndianLane` failing at `Kuttaka.agda:87.15-20`, both `[NotInScope] solve`,
both under the pin. A module that fails cannot be imported by one that
succeeds. So the aggregate's remaining pin-red is **the same
OUTSTANDING-A drift as §5**, one level up, and it clears when those two
files are renamed — not by any edit to the import list.

### 10.2 The direction of the drift, sorted as instructed

- **Old spelling under the new library (v0.5 source, v0.9 pin) — 23 of my 24
  reds, plus `Kuttaka.agda:87` and `BhavanaSemiring.agda:69` outside the
  orphan set.** These are **modules to fix**, not to excuse. The pin is what
  the repository declares and what the owner decided the sources track
  (2026-08-15); a module that only builds on 2.6.3/v0.5 is behind.
- **New spelling under the old library (v0.9 source, v0.5 container) — the
  `solve!` population of `CONTAINER_PIN_AUDIT.md`, none of them in my 83.**
  These are **correct and simply unbuildable off-pin**, and are the ones an
  off-pin agent must not "fix".
- **Neither direction — 2 modules**: `SubgroupIndex` (`⟪_⟫` ambiguity, red on
  both) and, until this pass, `NaturalMachine/GterTwoCoordinate` (`comp`
  clash, red on both, now green on both).

Same symptom class, three different warrants. The reason this is worth
separating is `TheTwoPigeonholes…OpenItem.agda` §0: when the pin is
unreachable, every red looks like the middle case, and a genuine defect
sits under an excuse for four days.

### 10.3 The registered prediction, now testable on the pin as well

Re-deriving `CONTAINER_PIN_AUDIT.md` §2's two lists from today's sources, with
`--` comments stripped (a claim about **file contents**, with its command):

- **`solve!` in code, top-level: 15 modules — the audit's list, exactly, name
  for name.** `CayleyPairChart CenterRelative DynamicDescent Gamma0Converse
  Gamma0ConverseSharp Gamma0Freeness Gamma0Partner Gamma0PartnerRigidity
  Gamma0Transitivity KuttakaValli M2Unimodular ParityNormEliminant
  Rank1DihedralChart SubsetSumChartDepth TransporterMembership`. Four days
  on, the enumeration has not rotted.
- **`SymGroup` in code, `NaturalMachine/`: 3 modules, not the audit's 4.**
  `Decategorification`, `PathIsSymmetry`, `StabilizerSubgroup`.
  `FiniteNonabelianHolonomy` has left the list — it now reads
  `open import NaturalMachine.PathIsSymmetry using (FinSymGroup)` (line 22)
  and uses `FinSymGroup 3` (line 58), so it names the v0.9 spelling only
  through one module instead of directly. That is a source change since the
  audit, not an error in it.

Combined with §6, the verdict on the registered prediction is: **its
`solve!` enumeration holds exactly; its `SymGroup` enumeration is now one
too long; its one in-scope container verdict (`SubgroupIndex` red) holds but
for the wrong reason; and its governing claim "no second cause" fails twice
on this population** — once on `SubgroupIndex`'s ambiguity and once on the
whole reverse-drift direction it could not see, because it only ever ran the
container. A registered prediction is worth more than a sweep, and it is
worth most when it is wrong in a locatable place.

---

## 8. CLOSURE, 2026-08-21 — the OUTSTANDING list is empty, and §5's prediction was right

**Added by a later session, appended rather than edited, because striking a
record silently is how this repository loses its own history.** Everything
below was run in this container under the pin (Agda 2.8.0 + cubical
`b150186d2544`, `LC_ALL=C.UTF-8`), per-module before the aggregate.

### 8.1 OUTSTANDING-A (23): closed, by exactly the repair §5 named

§5 wrote: *"Unblocked by: renaming `solve` → `solve!` and `·Rid` → `·IdR` in
the six files that actually carry the occurrences … The dependents clear
themselves."* That is what happened. All 23 exit 0 with **no edit to any of
them**; the repair was in the files carrying the occurrences, and the
dependents cleared themselves.

The scale was larger than "six files", and the reason is worth recording
because it is a second cause of the same shape as the one §6 found:

- **`Cubical.Tactics.NatSolver.Reflection` exports neither `solve` nor
  `natSolve`.** Its line 34, `open EqualityToNormalform renaming (solve to
  natSolve)`, has no `public`, so both names stop at that module's boundary.
  The public entry point is the macro `solveℕ!`. **39 call sites, 11
  modules.** Ten further modules already imported `solveℕ!` from that same
  module and were never affected.
- **`Cubical.Tactics.CommRingSolver.Reflection` exports the macro `solve!`,
  not the function `solve`** — the case §5 quotes Agda's own suggestion for.
  **83 call sites, 25 modules.**
- **`·Rid` → `·IdR`, six files.**

In both solver families the fix is not a rename: the macro fills the goal, so
the telescope variables move to the left-hand side and the point-free
`f = solve` idiom cannot survive. **No statement changed in any module.**

A correction to a claim made while this was in progress, recorded because §6
is right that a wrong prediction is worth most when it is locatable: the first
run under the repaired pin was reported as having *"exactly one hard error in
508 modules"*. It had eleven in the first family and twenty-five in the
second. Agda stops at the first error, so a single-error report from an
aggregate says only where it stopped, never how many there are — the same
shape of mistake as trusting a green from a check wired to the wrong thing.

### 8.2 OUTSTANDING-B (`SubgroupIndex`): closed, and it was not a two-token edit

§5 called it *"a `using`/`hiding` or a qualification at line 155, and it is a
two-token edit."* The diagnosis was exactly right and the estimate was not.
`hiding (⟪_⟫)` on the Nullary import is one token and it is correct; it was
masking four more, each of which had to be fixed before the next appeared:

1. `_·_` ambiguous between the group operation (from `open GroupStr (snd G)`)
   and ℕ's, inside `module Index`. ℕ's is now renamed `_·ℕ_` on import —
   **with its fixity carried in the renaming directive**, since a `renaming`
   that omits the fixity leaves the new name at the default level and breaks
   the parse at what is now line 358.
2. `·Comm` — never in scope at all; ℕ spells it `·-comm`.
3. `·IdR` / `·IdL` at what were lines 315 and 327 — ℕ spells them
   `·-identityʳ` / `·-identityˡ`.
4. **`order∣card`, whose proof asserts `card FG ≡ card FG ·ℕ 0`** and could
   never have typechecked, under a comment describing itself as a placeholder
   replaced below. It is now the proof `order∣card'` carried three lines under
   it; the history is recorded at the site.

This is §6's finding again at one more remove. A module red on both
toolchains reports one error, and a reader who takes that error for the
module's condition will underestimate it every time. Four days of "a
two-token edit" was that.

### 8.3 What the closure produced

`Everything.agda` exits **0**, and `check-everything-coverage.sh` exits **0**
beside it, so the green covers the enumeration scope exactly rather than a
subset. 28 modules were folded in across two blocks (the 24 here, plus four
the coverage latch reported afterwards: the two `Yantra/` roots, which brings
that subtree under the latch the way `NaturalMachine` is brought in;
`ApohaParyaya…`, already green; and `Nasti_ShabdeJivahVartante`, red on a
single missing name — its `Cubical.Foundations.Univalence using (ua)` did not
list the `uaβ` its line 69 uses). Three duplicate import lines were struck.

`formal/check.sh`'s ASPIRATIONAL-IF-RED fallback is **deleted**, executing the
repeal clause its own 2026-08-14 comment wrote: *"When Everything.agda goes
green under the resolved toolchain, DELETE the fallback and let it
hard-fail."* Both conditions hold.

### 8.4 The cause of the schism, which this note could not have seen

§5 and §6 read the v0.5-vs-v0.9 split as a migration disagreement between
lanes. It was not. `formal/cubical/ensure-toolchain.sh` — written 2026-08-15,
wired to a SessionStart hook, pinned to exactly this toolchain — had **never
completed**, for two independent reasons, the second invisible until the
first was fixed: `cabal update` died on Hackage's TUF content-signing check
behind the agent proxy, and then the successful build installed `agda` into
`~/.cabal/bin`, which the script prepended to *its own* `PATH` — so every
later shell resolved `agda` to Ubuntu's 2.6.3, **and the check reported exit 0
in that state**. No session ever held 2.8.0. Each fell back to what apt
offered and recorded whichever cubical worked with it: v0.5 in module headers,
v0.7 in claims R0079/R0080/R0081, v0.9 in `BUILD.md`. One broken installer,
three times, wearing the shape of a disagreement about mathematics.

That is the same defect §8.2 and §8.1 are instances of, one layer down: **a
gate wired to something other than the claim it makes.** It is the finding
this note should be read for.
