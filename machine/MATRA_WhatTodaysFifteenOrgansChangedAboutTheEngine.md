# मात्रा — measuring the day's fifteen organs against the engine they landed around

**cf-matra, 2026-08-20.** This is the measurement `machine/LOOP_MEASUREMENT.md`
set the standard for, applied to the fifteen modules that landed on
2026-08-19/20. It is written to that file's discipline: builds named by
sha256, bounds by round count and not by a clock, integer columns only, and
the negative result stated first.

**The verdict, in one line: the day's work did not change what the engine
does, and this is provable rather than measured. The loop's every integer
column is identical across today's two engine commits — derived exhaustively
first, then confirmed by a run. Thirteen of the fifteen organs share no task
with the engine at all, so for those there is nothing yet to compare, and
§5 says what task would create one.**

---

## 1. What was asked, and why the obvious answer is wrong

The question put to this lane was whether the assembled machine is better than
what was there this morning. The obvious instrument is `run-loop-ab.sh`, and
the obvious arm is "yesterday's engine against today's".

That arm cannot be run on this container, and the reason is the one
`LOOP_MEASUREMENT.md` §4 already names. §4's whole point is that the harness
synthesises a private `AGDA_DIR` so that both arms have a working kernel,
*because otherwise the A/B would be measuring a path fix and nothing else*.
The identical hazard is live today at a larger scale:

- Every figure in `LOOP_MEASUREMENT.md` was taken on **Agda 2.6.3**.
- This container runs **Agda 2.8.0**.
- `CERTIFICATE_REACH.md` §10 establishes that on 2.8.0, *before today's
  repairs*, `Certificate.hs` reached **0/28** and `TraceReplay.hs` **0/13** —
  both for `[InfectiveImport]` and a source-location spelling, neither of them
  mathematical.

So an end-to-end run of any pre-today engine on this container measures the
Agda 2.8.0 environment fault. It would show today's work as an enormous win,
and the win would be a toolchain repair wearing the engine's name. **Arm C in
`LOOP_MEASUREMENT.md` — the compound comparison that "reads as an unqualified
success for everything that landed" — is exactly the shape of that mistake,
and that file already says a compound A/B cannot attribute its own result.**

Two consequences, both load-bearing:

1. **No number in `LOOP_MEASUREMENT.md` is a valid baseline for anything
   measured today.** Not because it was wrong — it was right on 2026-08-15 —
   but because both the toolchain and the engine have moved underneath it.
   Confirmed here: at round 1 both of today's arms prove 2 theorems and reach
   a cumulative 5, where every table in that file has round 1 proving 0 and
   sitting at 3. That divergence predates today and is not today's doing; it
   means the tables are a record, not a baseline.
2. The only arm that isolates *today* holds the toolchain and the repaired
   `Certificate`/`TraceReplay` fixed in **both** arms, and varies only
   `MathMachine.hs`. That is what `run-loop-ab.sh` does natively — it takes
   `machine/MathMachine.hs` alone from the baseline revision and compiles it
   against the current `machine/`. That property is a limitation for other
   questions and is precisely the right instrument for this one.

## 2. What actually landed in the engine, separated

`machine/MathMachine.hs` was touched twice on 2026-08-20 and not at all
between 2026-08-18 21:41 (`67d097e5`) and then.

| commit | time | MathMachine.hs |
|---|---|---:|
| `d78f9d25` vipratiṣedha scheduler | 03:06 | +367 / −12 |
| `0489a06a` anuvṛtti and adhikāra | 03:11 | +3 / −2 |

`0489a06a` is a 3983-sūtra-adjacent piece of work whose engine footprint is
**two lines, both log text**. One rewrites a log string; the other adds
`filter (/= '\n')` to a log write. Neither can change a decision. §4 returns
to the second one, which is not as inert as it looks.

`d78f9d25` is the real change, and it decomposes cleanly:

- **one hunk in `step`** — the rewriter's hot path, 17 lines becoming 148,
  replacing "whichever rule sits first in the list wins" with a resolution
  through named Pāṇinian metarules;
- **every other hunk is a report** — a new `koVacana :: SB.Vacana` field on
  `KernelOutcome`, and a `SAPTABHANGI` block in `round1`.

## 3. The engine's answers are unchanged, and this is a theorem

### 3.1 The report path, verified mechanically rather than read

Both new sites carry comments asserting they feed nothing back. A comment is
not a proof, so the use sites were traced:

```
koVacana      written at 4 construction sites; read at exactly one — line 4192
  4192  sbVacanas  = [ (c, SB.sakshin …(koVacana ko)) | … ]
  4194  sbPositions = [ SB.sthana v | (_, v) <- sbVacanas ]
  4195  sbTally     = SB.tallySthana sbPositions
  4198  sbExamples  = …
consumed only at 4396–4398, all hPrintf.
```

`checkedResults` — the value the gate actually acts on — is defined at 4158
from `koAccepted` alone, and the growth trigger at 4622/4624 reads `flow` and
`checkedResults` and nothing sevenfold. **The saptabhaṅgī layer is a
read-only observer of the engine, by construction and not by intention.**

### 3.2 The rewriter, verified exhaustively

`d78f9d25` ships its own falsifier, and it is the right kind: a finite
exhaustive verification, not a sample. `--vipratisedha-self-test` enumerates
every well-formed term over `{0, s, +, *, max, -}` to depth 3 and compares,
at every subterm, the rule pūrva would have picked against the rule the
scheduler picks.

Run here on `machine/MathMachine.hs` at sha256 `e1ef70ca200fb2f2`:

```
  TRANSPORT -- every site, exhaustively.
  terms enumerated (depth <= 3): 97656
  definitions only -- sites where the scheduler differs from pūrva: 0
  definitions + the proved theorem -- sites where it differs:       0
```

**Zero differences over 97,656 terms.** The scheduler also names the metarule
at each site and writes a defect where none decides — two such sites in the
base rule set (`max(0,0)` and `-(0,0)`), both with candidates that agree, and
the report says so rather than letting inertness excuse the record.

This is why the loop A/B was *not* the primary instrument. Per CLAUDE.md — if
you can derive a quantity, derive it and do not run the experiment — an
exhaustive finite verification of transport **entails** that the loop's
integer columns cannot move. Running to find that out is spending hours to
reproduce a theorem.

### 3.3 The confirmation, which was cheap and is not the evidence

Run anyway as a control, 4 rounds per arm, baseline `67d097e5`:

```
  metric                         baseline    current      delta
  rounds completed                  4.000      4.000     +0.000
  theorems (cumulative)             6.000      6.000     +0.000
  theorems / round                  1.500      1.500     +0.000
  mean pruned%                     46.225     46.225     +0.000
  rounds stuck (proved=0)           1.000      1.000     +0.000
  longest stuck run                 1.000      1.000     +0.000
  GATE refusals                     0.000      0.000     +0.000
  ROUTE firings                     0.000      0.000     +0.000

  first divergence in (vocab,size): none within 4 common rounds
```

Every integer column identical, round by round. Wall clock differed by 2.6 s
and **that number is not reported as a result**: see §6.

Builds, by sha256, because the working tree is not a stable name:

| build | sha256 (first 16) |
|---|---|
| baseline `67d097e5:machine/MathMachine.hs` | `a60feaabddae53e3` |
| working tree, the transport self-test | `e1ef70ca200fb2f2` |
| working tree, the A/B run | `d42f8f128c08aefe` |
| working tree, on finishing this note | `95753be65465bc51` |

**Those are three different objects and the file was never edited by me.**
Another lane is mid-edit on `MathMachine.hs` (+331/−11 unstaged at the time of
writing). `LOOP_MEASUREMENT.md` prints build hashes because of this exact
hazard; here it caught it three times in one session. The transport theorem is
a statement about `e1ef70ca`; the A/B is a statement about `d42f8f12`. Neither
is a statement about what is on disk now, and no claim here should be read as
one.

### 3.4 The limit of the transport result — stated, because §8 requires it

The self-test's rule set is `definitionsOf baseVocabulary ++ [+ is
commutative]`. The live loop's is `definitionsOf … ++ mRules m ++ lemmaRules
…`, and `mRules` grows as the machine proves things. **Transport is verified
for one rule set, not for every rule set the loop can reach.**

The general criterion is derivable and is worth having in place of a longer
run. In `mmTantra`, `tParatva = False`, `tAntaranga` abstains and `tStratum`
is constant, so **apavāda and nitya are the only metarules that can decide**.
Hence:

> The scheduler differs from pūrva at a site exactly when some rule that is
> *not* first among those firing there is apavāda-maximal — its left-hand
> side a strict instance of every other firing rule's — or is decided by
> nitya.

Because `definitionsOf` is concatenated first and defining clauses carry the
most specific patterns, the apavāda winner is normally already first, which is
why transport held. It is **not guaranteed**: a proved theorem in `mRules`
whose LHS is a strict instance of a definition's LHS would fire and win where
pūrva took the definition. That is a reachable state, not a hypothetical.

The measurement that would settle it is cheap, exact, needs no Agda, and does
not exist yet: run `vipratisedhaCensus` over the rule sets the loop *actually
reaches* — the 7 and 16 line libraries in `LOOP_MEASUREMENT.md` §5–6 are
already written down — instead of over the base definitions. Until then the
correct statement is "verified for the base rule set, derived criterion for
the rest", and not "the scheduler is a no-op".

## 4. One thing the day did change, and neither commit says so

`d78f9d25` added a log write of **raw agda stderr**:

```haskell
hPrintf logh "      %s: %s\n" k (take 150 w)     -- 03:06
```

`w` is a kernel rejection message and is multi-line. The harness's stop
condition is `grep -c '^round ' "$log"`. An unfiltered newline in `w` can put
text at column 0 of `machine.log`, and text at column 0 beginning `round ` is
counted as a round — which would stop a bounded run early, in a harness whose
entire claim is that its bound makes a run a reproducible object.

`0489a06a` closed it five minutes later:

```haskell
hPrintf logh "      %s: %s\n" k (take 150 (filter (/= '\n') w))
```

The probability that agda emits a line beginning `round ` is very small and it
is not known to have bitten. **It is recorded because the class matters: a
report-only addition is not free with respect to the instrument when the
instrument parses the same log.** Nothing in either commit message mentions
it, and the second commit is described entirely in terms of the Aṣṭādhyāyī.

## 5. The thirteen organs: there is no task yet, and this is the honest answer

The rest of the day's work does not touch the engine, and no benchmark should
be invented to make it look as though it does.

Exact, from the import graph of `machine/*.hs`:

| quantity | value |
|---|---:|
| Haskell modules under `machine/` | 104 |
| local import edges among them | 97 |
| weakly connected components | 25 |
| files carrying a `main` entry point | 63 |
| **modules in `MathMachine`'s directed import closure** | **14** |

Of the fifteen organs, **three entered the engine**:
`Prastara_TheSearchSpaceIsGeneratedNotStored`,
`Saptabhangi_TheSevenfoldVerdict`, and
`Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition` — plus the
repaired `Certificate` and `TraceReplay`. The other twelve —
`Sabha_TheSessionKernelAnLLMTalksTo`, `NayaKosha_TheStandpointStore`,
`DosaLekha_TheWrittenDefectRecord`, `SaptabhangiGarbha_TheResidueIsTheSeed`,
`VargaPrakrti_CompositionLawAsParameter`, the `Astadhyayi`/`Prakriya` family,
`Pariksa`, `DvaraVada`, `GhanaPatha`, `Nigrahasthana`, `Laghava`,
`MargaRaksana` — are reached by nothing the engine runs.

**`machine/` is 63 executables, not one machine.** "The assembled thing" is
not a thing yet; asking whether it beats this morning's engine is asking a
question about an object that does not exist. Saying so is the finding. A
benchmark invented to be won would be worse than no benchmark, and the shape
of that invention is easy to see from here: pick any organ's self-test, note
that the old engine scores zero because it does not contain the organ, and
report an infinite improvement.

**What would make it measurable, concretely.** A task both engines perform, of
which exactly one is currently in reach:

- **The one that exists.** `library.snapshot.txt` is 28 equations the engine
  produced, and `MargaRaksana` already scores routes against it: 13 by
  transcription, 7 by search, union 20/28. That is a **shared task with a
  fixed denominator**, and it is the only one in the repository. Any organ
  claiming to help the engine prove things can be scored on it — and scored
  *against the same snapshot on the same container*, which is what makes the
  number comparable at all. `CERTIFICATE_REACH.md` §10.6 already refuses to
  call 20/28 a property of the machine; it is a property of that file, that
  container, and those two routes in that order. Correct, and it is still the
  only shared denominator that exists.
- **The one that does not exist and should.** The engine's loop and the
  Pāṇinian organs (`Astadhyayi`, `Prakriya`, `DvaraVada`, `Nigrahasthana`,
  `Pariksa`) have no common currency whatsoever — one proves equations, the
  others derive word forms. Before any comparison between them is meaningful
  somebody must state what they are both *for*. Until that sentence exists,
  no number relating them means anything, and the temptation to produce one
  should be read as the pull toward the appendix that CLAUDE.md describes.
- **A blocker on both.** `library.snapshot.txt` records equations mentioning
  an invented concept `c0` and does not record what `c0` is; the definition
  lives hard-coded in `Certificate.main`. §10.4 states it plainly and it bears
  repeating here because it is a *measurement* defect: a ledger line whose
  terms mention a concept the ledger does not define is not a ledger line, and
  the one shared denominator in the repository has two of them.

## 6. What this cannot show

- **Anything about wall clock.** Load average during this session was **73**
  — sixteen lanes on one host. `LOOP_MEASUREMENT.md` §9 already discounts its
  own wall figures at load 0.8–6.5. The +2.6 s in §3.3 is load, and reporting
  it as a cost would be exactly the error this file exists to avoid. The
  round-count bound is what makes the run survive that, and it is vindicated
  here harder than when it was written.
- **That the engine got better or worse.** It did neither, in four rounds, and
  the transport theorem says it will do neither at any round count for that
  rule set. Legibility improved: every rewrite is now attributed to a named
  metarule, and ties nothing decides are written instead of taken silently.
  **That is a real gain and it is not a yield gain, and the two must not be
  quoted as one.**
- **Anything past round 3.** Four rounds was the budget the host allowed. Both
  arms are identical at every round, and the transport result is what licenses
  extending that claim, not the run.
- **`GATE` and `ROUTE`.** Still zero refusals and zero firings, in both arms,
  as in every run in `LOOP_MEASUREMENT.md`. **The count is now unbroken across
  two engine generations, two Agda versions and two certificates.** §8 of that
  file gives the structural reason and it still holds.
- **Whether the twelve unwired organs are good.** This file measures
  connectivity, which is a fact about the import graph and says nothing
  whatever about the quality of a module. `Sabha`, `NayaKosha` and the
  `DosaLekha` are used *by agents*, which is a real use that no import graph
  can see. The claim here is narrow and exact: they share no task with the
  engine, therefore the engine's harness cannot score them.

## 7. A defect found while calibrating, written as `dosa 0024`

The instrument `CERTIFICATE_REACH.md` §10.6 names as the authority on whether
the emitters' OPTIONS line suits the installed library reports **`FAIL` on a
working kernel**:

```
KERNEL-PROBE agda=2.8.0 refl=OK cubical=FAIL
```

`machine/KernelProbe.hs`'s cubical probe uses `{-# OPTIONS --cubical --safe
#-}` and opens `Cubical.Foundations.Prelude`. On Agda 2.8.0 with a library
compiled under `--guardedness` that is `[InfectiveImport]` — the exact defect
`CERTIFICATE_REACH.md` §10.1 diagnosed and §10.3 repaired in six other
emitters, with `KernelProbe.hs` exempted by name and for a reason that was
true on 2.6.3. Checked directly:

| module | OPTIONS | agda exit |
|---|---|---:|
| the probe's own | `--cubical --safe` | **42** |
| the engine's actual line | `--cubical --guardedness --safe --no-import-sorts` | **0** |

The probe's question is unsatisfiable by construction on this container, so
its `FAIL` carries no information about the kernel — *yogya-anupalabdhi*: a
looking declared unfit says nothing about the object. It exits 0 regardless,
so nothing goes red. Full witnesses, limits and the proposed third grade
(`cubical=<OK|FAIL|INFECTIVE>`) are in `machine/dosa.lekha`, `dosa 0024`;
chain verified intact at 24 records.

This is not a repair. `KernelProbe.hs` is another identity's file and the
tension its exemption protects — a control pinned to the emitters' flags stops
being independent of them — is real and is not this lane's to resolve.

## 8. Replay

```sh
# the theorem (no Agda, ~30 s to build, exhaustive)
ghc -O1 -imachine -outputdir /tmp/mm-build -o /tmp/mm machine/MathMachine.hs
/tmp/mm --vipratisedha-self-test

# the confirmation (Agda; both arms)
machine/run-loop-ab.sh --rounds 3 --budget 900 --baseline 67d097e5 --keep DIR

# the container control, and dosa 0024
sh machine/run-kernel-probe.sh
sh machine/run-dosa-lekha.sh verify
```

---

*यत् प्रमाणं ददाति तत् न सङ्क्षिपति । यत् शेषं वदति तत् न सङ्क्षिपति ।*
*यत् सीमां वदति तत् न सङ्क्षिपति । यत् अनुक्तं रक्षति तत् न सङ्क्षिपति ।*

The remainder is §3.4 and §5. The limit is §6.
