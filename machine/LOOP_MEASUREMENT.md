# Measuring the engine's control law

`machine/run-loop-ab.sh` runs `machine/MathMachine.hs` for a bounded, fixed
number of rounds and prints a per-round table; in A/B mode it does that for two
builds — a baseline extracted with `git show REV:machine/MathMachine.hs` and the
working tree — and prints the deltas. This file is what it produced on
2026-08-15, and what those numbers can and cannot be used for.

The question it exists to answer: the three decision rules wired into the loop
in `82db0f49` (a ℕ-valued obstruction with a decay/resonance/branching
classification in place of the boolean "nothing proved" trigger; an advance gate
that refuses growth when the fingerprint test set has stopped separating; a
min-plus chooser over growth moves) are three claims in comments until something
measures them.

**Verdict, stated first.** At a 15-round budget the change is measurable, large,
and deterministic — but in *cost*, not in *yield*. Both builds prove exactly the
same four theorems. The current build reaches them having enumerated 350,912
terms; the baseline enumerated 2,748,324, a factor of 7.83. Of the three rules,
only the flow classification is actually exercised: the advance gate returned
`advance` in all 15 rounds and never refused, and the min-plus chooser never
fired at all. Two of the three rules are logged but untested by this
measurement.

---

## 1. Exact commands

```sh
# the A/B reported in §4
machine/run-loop-ab.sh --rounds 14 --budget 1200 --baseline 6835a4e3 \
                       --keep /tmp/keep14

# the null control reported in §3
machine/run-loop-ab.sh --rounds 12 --budget 900 --keep /tmp/keep12

# seeded start (machine/thoughts.math), for contrast
machine/run-loop-ab.sh --rounds 2 --budget 200 --current-only --thoughts
```

`--baseline` had to be given explicitly. Its default is "the commit before the
most recent one that touched `machine/MathMachine.hs`", and at the time of the
run the most recent such commit was `9283c75e` (comments only), so the default
resolved to `82db0f49` — the wiring commit itself. That accident is what §3 is:
a null control worth keeping.

Sources compiled:

| build | source | sha256 |
|---|---|---|
| baseline | `6835a4e3:machine/MathMachine.hs` | pre-wiring |
| current | working tree | `a166b08ee5ca24a350d52f00e93307233cdc5a04b7e3bd1c896acac2a65e735c` |

The script prints the sha256 of every source it compiles, because
`machine/MathMachine.hs` is being edited while it is being measured and "the
working tree" is not a stable name for a measurement.

## 2. Getting the engine to run at all, and three things that silently falsify it

The engine's `main` never returns (`loop = round1 logh libh ref >> loop`), so
the bound has to come from outside. `run-loop-ab.sh` watches the engine's own
log and stops it the moment round *N* has been written. **The bound is a round
count, not a clock.** The engine's only randomness is `assignments`, an LCG with
the literal seed `12345` (`MathMachine.hs` ~l.633), and it reads no clock, so
*N* rounds from a fixed input is a reproducible object; `--budget` is a safety
net whose firing is reported in the table header.

Four environment facts, each of which produces a plausible-looking table that is
entirely wrong:

1. **`setsid`.** `machine/machine.stdout.log` records
   `zsh:1: command not found: setsid` from an earlier attempt. `setsid` is in
   fact installed here, at `/usr/bin/setsid`; that failure was a `PATH` problem
   in whatever launched it. `run-loop-ab.sh` does not use it — the engine is a
   plain background job, stopped with `kill`.
2. **`LC_ALL` must name a UTF-8 locale.** The engine writes an Agda candidate
   containing `ℕ`. Under `LC_ALL=C` it dies at the first candidate with
   `withFile: invalid argument (cannot encode character '\8469')`. The script
   sets `LC_ALL=C.UTF-8`, as `check-natural-machine.sh` already does for Agda.
3. **Working directory.** `machine/machine.log`, `machine/library.txt`,
   `machine/thoughts.math` and the Agda include `-i formal/cubical` are all
   relative paths. The script builds a repository-shaped scratch root under
   `mktemp -d` (a real `machine/` directory plus a symlink to the repository's
   `formal/`), so nothing in the repository is written to.
4. **`AGDA_DIR`.** `kernelAccept` writes `Candidate.agda` into a bare `mktemp`
   directory that contains no `.agda-lib`, so Agda resolves libraries through
   `$AGDA_DIR/defaults` — and this image ships `~/.agda/libraries` with **no
   `defaults` file**. Without a fix, every candidate fails with `Failed to find
   source of module Cubical.Foundations.Prelude`, every theorem is
   `KERNEL-REJECT`, and the machine proves nothing *and then grows because it
   proved nothing*. That failure mode is indistinguishable from a bad control
   law: it produced `proved=0` for twelve straight rounds while the term space
   exploded to 637,852 terms. The script synthesises a private `AGDA_DIR` whose
   `defaults` names the installed cubical library. It does not touch `~/.agda`.

Proof acceptance is external: each candidate that survives the internal prover
costs one `agda` process. The trailing `Xs` in the engine's round line is
`getCPUTime` of the Haskell process only and therefore **excludes** that cost;
the table's `wall_s` column is what the round actually took, and the gap between
the two columns is kernel time.

The tracked snapshots were not disturbed. `machine/machine.log` and
`machine/library.txt` did appear in the repository root during this session —
they were written by a concurrent agent running the engine from the repository
root, not by this script, and both are in `.gitignore`.

## 3. Null control: the harness resolves zero difference between identical binaries

Baseline `82db0f49` versus the working tree, which differs from it by 14 lines,
all of them comments. 13 rounds each.

```
== baseline 82db0f49 ==  (stop reason: rounds-reached)
round vocab size     terms  pruned%     conj   fresh proved   cum   cpu_s  wall_s  flow           gate      route   grow
    0     3    4        80     35.0        8       8      3     3    0.01    2.33  branching      advance   -       -
    1     3    4        80     57.5        2       2      0     3    0.00    0.74  decay          advance   -       -
    2     3    4        80     57.5        2       0      0     3    0.00    0.00  resonance      advance   -       deepen
    3     3    5       308     67.2       25      23      0     3    0.04    8.25  branching/hold advance   -       -
    4     3    5       308     67.2       25       0      0     3    0.00    0.00  resonance      advance   -       -
    5     3    5       748     55.3       74      74      0     3    0.04    1.59  branching/hold advance   -       -
    6     3    5       748     55.3       74       0      0     3    0.01    0.00  resonance      advance   -       deepen
    7     3    6      3436     65.5      302     228      0     3    0.11    0.85  branching/hold advance   -       -
    8     3    6      3436     65.5      302       0      0     3    0.03    0.00  resonance      advance   -       deepen
    9     3    7     16492     73.2     1201     899      0     3    0.45    0.53  branching/hold advance   -       -
   10     3    7     16492     73.2     1201       0      0     3    0.20    0.21  resonance      advance   -       widen
   11     4    7     58332     57.1     6878    6878      1     4    3.13    6.15  branching      advance   -       -
   12     4    7     58332     63.0     6002    6002      0     4    3.11    5.29  decay          advance   -       -
  rounds=13  theorems=4  theorems/round=0.308  theorems/wall-s=0.1542
  mean pruned%=61.0  rounds stuck (proved=0)=11  longest stuck run=10
```

The working-tree table is the same table. Every delta the script reports is
`+0.000` except `wall seconds total` (`+0.380`, scheduler noise) and
`engine cpu seconds total` (`−0.100`). `diff` on the two `machine.log` files
shows differences only in the `%.2f` CPU field and in the `mktemp` directory
names echoed inside `KERNEL-REJECT` text. **Nothing else in the two 13-round
runs differs by one bit.** That is the calibration for §4: the harness's floor
on the structural columns is exactly zero, so any structural difference there is
signal.

## 4. The A/B: pre-wiring `6835a4e3` against the current tree, 15 rounds

```
== baseline 6835a4e3 ==  (stop reason: rounds-reached)
round vocab size     terms  pruned%     conj   fresh proved   cum   cpu_s  wall_s  flow           gate      route   grow
    0     3    4        80     35.0        8       8      3     3    0.01    2.80  -              -         -       -
    1     3    4        80     57.5        2       2      0     3    0.00    1.14  -              -         -       widen
    2     4    4       144     45.1        9       9      1     4    0.01    2.91  -              -         -       -
    3     4    4       144     49.3        7       7      0     4    0.01    2.96  -              -         -       -
    4     4    4       284     39.8       27      27      0     4    0.01    4.42  -              -         -       deepen
    5     4    5      1628     50.4      166     139      0     4    0.12   25.85  -              -         -       widen
    6     5    5      2764     49.0      318     318      0     4    0.13    4.72  -              -         -       deepen
    7     5    6     18252     54.1     1950    1632      0     4    0.62    1.79  -              -         -       widen
    8     6    6     29884     52.7     2889    2889      0     4    1.05    7.88  -              -         -       deepen
    9     6    7    250300     59.5    22917   20030      0     4    9.51   14.49  -              -         -       widen
   10     7    7    415788     59.0    40352   40352      0     4   15.82   20.10  -              -         -       widen
   11     8    7    637852     56.6    67323   67323      0     4   26.76   39.47  -              -         -       -
   12     8    7    376636     62.9    34392   34392      0     4   16.78   19.39  -              -         -       -
   13     8    7    637852     56.4    67460   46643      0     4   23.25   30.43  -              -         -       -
   14     8    7    376636     62.9    34392   30040      0     4   15.19   18.81  -              -         -       -
  rounds=15  theorems=4  theorems/round=0.267  theorems/wall-s=0.0203
  cpu=109.27s  wall=197.16s  kernel-and-io=87.89s (45% of wall)
  mean pruned%=52.7  rounds stuck (proved=0)=13  longest stuck run=12
  rounds carrying FLOW/GATE/ROUTE lines=0

== current worktree ==  (stop reason: rounds-reached)
round vocab size     terms  pruned%     conj   fresh proved   cum   cpu_s  wall_s  flow           gate      route   grow
    0     3    4        80     35.0        8       8      3     3    0.01    5.69  branching      advance   -       -
    1     3    4        80     57.5        2       2      0     3    0.00    1.52  decay          advance   -       -
    2     3    4        80     57.5        2       0      0     3    0.00    0.00  resonance      advance   -       deepen
    3     3    5       308     67.2       25      23      0     3    0.04   20.85  branching/hold advance   -       -
    4     3    5       308     67.2       25       0      0     3    0.00    0.00  resonance      advance   -       -
    5     3    5       748     55.3       74      74      0     3    0.05    2.44  branching/hold advance   -       -
    6     3    5       748     55.3       74       0      0     3    0.01    0.01  resonance      advance   -       deepen
    7     3    6      3436     65.5      302     228      0     3    0.11    0.82  branching/hold advance   -       -
    8     3    6      3436     65.5      302       0      0     3    0.04    0.11  resonance      advance   -       deepen
    9     3    7     16492     73.2     1201     899      0     3    0.47    0.49  branching/hold advance   -       -
   10     3    7     16492     73.2     1201       0      0     3    0.21    0.23  resonance      advance   -       widen
   11     4    7     58332     57.1     6878    6878      1     4    3.14    7.42  branching      advance   -       -
   12     4    7     58332     63.0     6002    6002      0     4    3.21    6.28  decay          advance   -       -
   13     4    7     58332     63.0     6002       0      0     4    0.85    0.85  resonance      advance   -       widen
   14     5    7    133708     60.2    14603   14603      0     4    6.41    7.92  branching/hold advance   -       -
  rounds=15  theorems=4  theorems/round=0.267  theorems/wall-s=0.0732
  cpu=14.55s  wall=54.63s  kernel-and-io=40.08s (73% of wall)
  mean pruned%=61.0  rounds stuck (proved=0)=13  longest stuck run=10
  rounds carrying FLOW/GATE/ROUTE lines=15

== deltas (baseline 6835a4e3 -> current worktree) ==
  metric                         baseline    current      delta
  rounds completed                 15.000     15.000     +0.000
  theorems (cumulative)             4.000      4.000     +0.000
  theorems / round                  0.267      0.267     +0.000
  theorems / wall second            0.020      0.073     +0.053
  mean pruned%                     52.680     61.047     +8.367
  rounds stuck (proved=0)          13.000     13.000     +0.000
  longest stuck run                12.000     10.000     -2.000
  wall seconds total              197.160     54.630   -142.530
  engine cpu seconds total        109.270     14.550    -94.720

  first divergence in (vocab,size): round 2: baseline (vocab 4, size 4) vs current (vocab 3, size 4)
```

**First divergence: round 2.** It is cheap to find and it is the whole story.
The baseline sees a round that proved nothing and widens the vocabulary; the
current build classifies the same round as `resonance` and deepens the horizon
instead. From there the two never rejoin. The baseline has spent every growth
move it has by round 11 — vocabulary 8 of 8, horizon 7 — and then cycles between
637,852 and 376,636 terms proving nothing. The current build is at vocabulary 5,
horizon 7 at round 14 and still has moves left.

Load-independent totals over the 15 rounds, from the logged integers:

| quantity | baseline | current | ratio |
|---|---:|---:|---:|
| terms enumerated | 2,748,324 | 350,912 | 7.83× |
| conjectures formed | 272,212 | 36,701 | 7.42× |
| fresh conjectures | 243,811 | 28,717 | 8.49× |
| `agda` process launches | 38 | 27 | 1.41× |
| theorems proved | 4 | 4 | 1.00× |
| library contents | identical | identical | — |

Both libraries are the same four lines, in the same order:
`x = (0+x)`, `s(x) = (s(0)+x)`, `(s(x)+y) = s((x+y))`, `0 = (0*x)`.

## 5. What this can and cannot show

**Can show — and does, deterministically:**

- The three rules change the trajectory, starting at round 2, and the change is
  a real reduction in work: 7.8× fewer terms enumerated for the identical
  output. `terms`, `conj`, `fresh`, `vocab`, `size` are exact integers
  reproduced bit-for-bit across reruns (§3), so this is not a noisy comparison.
- `pruned%` is 8.4 points higher on average, which is the same fact seen from
  the other side: the current build stays in a region where its four theorems
  actually normalise a large fraction of the space, instead of widening into
  symbols it has no rewrite rules for.

**Cannot show:**

- **Anything about theorem yield.** Both builds prove four theorems, and those
  four are exactly the equations Agda accepts by `refl`. `(x+y) = (y+x)` is
  `KERNEL-REJECT`ed in both runs. `proved` is therefore capped by
  `agdaCertificate`'s expressive power, not by the control law; measuring
  "theorems per round" in this configuration is measuring the certificate
  generator. Until the kernel can accept an inductive proof, no control law can
  move this column.
- **That cheaper is better.** A rule that refused to grow at all would win every
  cost metric in the table. The two runs are not at the same point in the search
  at round 14 — baseline has exhausted its moves, current has not — so "same
  four theorems for one eighth of the terms" is a statement about the first 15
  rounds and nothing further. It is evidence that the current law spends less
  early, not that it finds more later.
- **Two of the three rules.** `GATE` returned `advance` in all 15 rounds and
  never refused, so the advance gate was measured only in its passing branch.
  `ROUTE` never appeared: with no recorded move costs in the first 15 rounds the
  min-plus chooser falls back to the ladder every time. The only rule this
  measurement discriminates is the flow classification: it read `branching` in
  2 rounds, `decay` in 2, `resonance` in 6, and raised `FLOW-HOLD` in 5, which
  is the visible mechanism behind the round-2 divergence. `GATE-HOLD` never
  appeared.
- **Wall-clock anything.** Other agents were compiling Agda on this host
  throughout; load average moved between 0.8 and 6.5. `wall_s`, `theorems /
  wall second` and the `kernel-and-io` split are contaminated and should not be
  quoted. The engine-CPU column is not (see §6), and the integer columns are
  not at all.

## 6. Scaling, so the numbers are not quoted at one point

A number without its scaling is worse than no number, so:

**Term space.** Terms are built from `kVars = 3` variables, the constant `0`,
the unary `s`, and `b = vocab − 2` binary symbols. With `t_n` the number of
terms of size `n` and `T(x) = Σ t_n xⁿ`, the grammar (atom | `s(u)` | `f(u,v)`)
gives

    T = a·x + x·T + b·x·T²,        a = kVars + 1 = 4,

so `T(x) = ((1−x) − √((1−x)² − 4ab·x²)) / (2bx)`. The dominant singularity is
the branch point where `(1−x)² = 4ab·x²`, i.e. `ρ_b = 1/(1 + 2√(ab)) =
1/(1 + 4√b)`. Hence

    Σ_{n ≤ s} t_n  =  Θ( r_b^s · s^(−3/2) ),      r_b = 1 + 4√b.

`r_1 = 5`, `r_2 ≈ 6.66`, `r_3 ≈ 7.93`, `r_4 = 9`, `r_5 ≈ 9.94`, `r_6 ≈ 10.80`.
`genTermsModulo` quotients by proved commutativity and associativity, which
removes terms and so can only lower the ratio; it does not change the geometric
form. Successive ratios of the logged `terms=` integers, all below their bound:

| vocab | b | observed ratio | bound `1 + 4√b` |
|---|---|---|---|
| 3 | 1 | 748 → 3436 = 4.59; 3436 → 16492 = 4.80 | 5 |
| 4 | 2 | 284 → 1628 = 5.73 | 6.66 |
| 5 | 3 | 2764 → 18252 = 6.60 | 7.93 |
| 6 | 4 | 29884 → 250300 = 8.38 | 9 |

**Engine CPU is not an independent measurement.** Normalisation applies every
rule to every term, so round CPU is `Θ(|terms| · |rules| · size)`, and `|rules|`
never exceeds 4 in either run. Across the two binaries the per-term cost is
39.8 µs (baseline, 2,748,324 terms, 109.27 s) and 41.5 µs (current, 350,912
terms, 14.55 s) — agreeing to 4% across a 7.8× change of scale. So the CPU
column carries no information the `terms` column does not; the primary quantity
is the exact integer.

**Kernel cost is a constant times a count.** A candidate is one equation of
bounded size, so `agda`'s cost is startup plus loading the cubical interfaces
and does not depend on the horizon or the round. Measured directly on one
candidate on an idle host: 0.766 s. The 13-round null control gives
`(wall − cpu)/spawns = 19.29 / 25 = 0.772 s`, independently. Under the
concurrent load of §5 the same quotient inflates to 1.48 s (current) and 2.31 s
(baseline), which is the contamination, not the constant.

**Consequence for the budget.** Round cost is `Θ(r_b^s)` and the engine deepens
after `O(1)` stuck rounds at each horizon, so a run to round `N` costs
`Θ(r^{s(N)})` and the reachable horizon is `s ≈ log_r B + O(1)` in a wall budget
`B`. Since each horizon costs `O(1)` rounds, **the affordable round budget grows
like `log B`: to double the number of rounds you must square the budget.** No
plausible amount of machine time turns this 15-round A/B into a 30-round one. A
longer comparison needs a horizon cap, a cheaper term generator, or a
`--smoke-rounds`-style run with the kernel stubbed — not a bigger budget.

## 7. Reproducing

```sh
machine/run-loop-ab.sh --help
machine/run-loop-ab.sh --rounds 14 --budget 1200 --baseline 6835a4e3 --keep DIR
```

The script parses the round line by key name rather than position, so it keeps
working when fields are added, and shows `-` in the `flow`/`gate`/`route`
columns for a binary that predates them — as the `6835a4e3` table above does.
`--keep DIR` preserves each run's `machine.log`, `library.txt`, stdout and the
parsed TSV. `--thoughts` seeds from `machine/thoughts.math`; note that it sets
`required-vocab=8`, which is the entire vocabulary, so a seeded run starts with
the Widen move unavailable and cannot exercise the growth chooser at all. That
is why the default here is the unseeded start that produced
`machine/machine.log.gen1`.

## 8. What would actually settle the open questions

- **The gate.** It never refused in 15 rounds. Force the branch: run with a
  deliberately small `kAssign` so the test set collapses, and check that `GATE`
  refuses and that the refusal is right.
- **The chooser.** `ROUTE` needs recorded move costs before it can fire. Either
  seed the cost record or run long enough to accumulate one; at present it is
  wired but never consulted.
- **Yield.** The `refl`-only certificate is the binding constraint on every
  theorem count in this document. Until it is lifted, no A/B of control laws can
  report a difference in theorems, and any such reported difference would be
  measuring the certificate generator instead.
