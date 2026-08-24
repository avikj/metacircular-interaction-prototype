# Running the Machine

*For operators: how to start, observe, and verify the autonomous loop.
Everything here is reproducible; where a command produces a number, the
number in your run is the truth and this document is only the map.*

## 0. Prerequisites

The cubical lane bootstraps its own toolchain: `punaragamana/check.sh`
installs the pinned Agda + cubical library from nothing and checks its
lane (exit 0 = green). GHC is required for the driver. No Python
(repository policy; the `legacy/` runtime seed predates the ban and is
quarantined there).

## 1. Verify before trusting (always available)

```sh
# check any single module the way the machine's judge does
cd formal/cubical && LC_ALL=C.UTF-8 agda <Module>.agda   # exit 0 = kernel accepts

# check the crystal's current rendering (all landed theorems, one module)
cd formal/cubical && LC_ALL=C.UTF-8 agda Sphatika.agda
```

## 2. One completion round by hand

```sh
# build the driver once
ghc -O2 -threaded -imachine \
  machine/Sphatika_TheCrystalGrowsByItsOwnStallsAndEveryTheoremStrengthensTheNext.hs \
  -o /tmp/sphatika-bin

# prove the current frontier (lands into machine/sphatika.crystal,
# re-renders formal/cubical/Sphatika.agda, installs landings as rules)
LC_ALL=C.UTF-8 /tmp/sphatika-bin machine/sanghatta-report-current.txt

# re-derive the frontier from the (now larger) rule library
LC_ALL=C.UTF-8 runghc -imachine \
  machine/Sanghatta_TheCriticalPairsOfTheInstalledRulesNameTheLibrarysIncompleteness.hs \
  > machine/sanghatta-report-current.txt
```

## 3. Rounds to fixpoint, unattended

```sh
SPHATIKA_BIN=/tmp/sphatika-bin sh machine/sphatika-rounds.sh 24
# halts itself only when a round adds no lemma AND the frontier is
# unchanged (completion's own fixpoint), or the round cap is hit.
```

## 4. Forever (rounds + self-commit)

```sh
SPHATIKA_BIN=/tmp/sphatika-bin sh machine/sphatika-forever.sh &
# loops rounds; every 5 minutes commits and pushes the machine's own
# artifacts (crystal, rendering, rule library, frontier, log), every
# path named.  The log is collab/orchestration/sphatika.log.
```

## 5. Exchange between nodes

```sh
# adopt a peer crystal through YOUR kernel (no sender trust):
LC_ALL=C.UTF-8 /tmp/sphatika-bin --exchange path/to/peer/sphatika.crystal
# every row is re-judged locally; citations remapped in dependency
# order; refusals receipted.  A refused row costs one kernel run —
# that is the entire security model.
```

## 6. What to watch

- `machine/sphatika.crystal` — the store: one theorem per row
  (name, lhs, rhs, proof), append-only, single-writer-locked.
- `machine/library.terms` — the rule library; growth here is the
  return edge working; provenance rides in the third field.
- `machine/sanghatta-report-current.txt` — the frontier; pairs that
  disappear were joined by installed rules; pairs that appear are the
  machine's own new questions.
- `collab/orchestration/sphatika.log` — landings (`landed`), refusals
  with reasons, residual firings (`stalls; residual enters`), installs
  (`installed as rules`), round boundaries.

## 7. Operational doctrines (learned the expensive way, kept short)

- One writer per crystal; a stale lock from a dead process is reaped,
  never raced.
- Set UTF-8 explicitly on every file handle and every child process;
  the ambient locale has broken this pipeline four separate times.
- A killed pass is safe: the crystal is append-only and idempotent to
  re-enter; receipts stamped with a superseded proposer version are
  re-asked, landings never are.
- The kernel's throughput is the system's speed of light; parallelism
  (4-wide shape judging) buys wall-clock but nothing outruns the judge.
