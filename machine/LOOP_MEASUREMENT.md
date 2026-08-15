# Measuring the engine's control law

`machine/run-loop-ab.sh` runs `machine/MathMachine.hs` for a bounded, fixed
number of rounds and prints a per-round table; in A/B mode it does that for two
builds and prints the deltas. This file is what it produced on 2026-08-15.

**The first version of this measurement reported that theorem yield could not
discriminate anything, because the Agda gate accepted only `refl` and both
builds proved the same four definitional equations. That cap is gone.** The
certificate generator (`machine/Certificate.hs`) now emits induction skeletons,
covers the whole vocabulary, and produces no `KERNEL-SKIP` at all. The yield
column is live, and everything below is the re-measurement.

---

## 1. Verdict

At a 15-round budget, on the unseeded start:

- **The certificate is what moved yield.** 4 theorems → 7, including
  `(x+(y+z)) = ((x+y)+z)` — associativity of `+`, proved by induction. No
  amount of control law could have produced that line, because `refl` cannot
  check it. Seeded, round 0 goes 4 → 14 and `KERNEL-SKIP` disappears entirely.
- **The control law's effect on yield is not zero. It is negative, and it was
  hidden by the broken gate.** With the certificate held fixed and *only* the
  growth trigger reverted (arm D), the old boolean rule reaches **16 theorems
  in 15 rounds where the new rule reaches 7** — and it does so having
  enumerated slightly *fewer* terms (131,188 vs 143,080) and spent 6.4× *less*
  engine CPU. On this budget the new control law is worse on every axis except
  mean `pruned%`.
- **This inverts the previous report, and the previous report was not wrong.**
  Under a `refl`-only gate the control law's yield delta really was exactly
  zero (arm A, re-measured today: 4 theorems either way, 7.8× fewer terms).
  Widening the vocabulary was worthless then because nothing about the new
  symbols could be proved. Once the prover can discharge definitional facts
  about `max`, `-` and `le`, **widening is where the theorems are**, and the
  new rule's whole mechanism is to classify a barren round as `resonance` and
  deepen instead — multiplying the term space geometrically rather than
  reaching the cheap new symbols.
- **`GATE` has still never refused and `ROUTE` has still never fired** — in
  every run below that contains those rules at all, under either certificate,
  seeded and unseeded, with yield live. That is a finding about the rules
  rather than about the budget: the expectation that installing theorems would
  give them their first chance to bind was reasonable, and it did not happen.
  §8 gives the structural reason why neither can fire at this length.

The honest one-line summary: **the certificate is a clear win; the control law
was a win when measured against a gate that could not prove anything, and is a
loss now that the gate can.**

## 2. The design

Three of the four cells are real revisions. Nothing is a hand-built hybrid
except the fourth, which is one line and is described in §6.

| cell | revision | control law | certificate | memory |
|---|---|---|---|---|
| old / old | `6835a4e3` | boolean "nothing proved" | `refl` only | absent |
| new / old | `9283c75e` | KFlow + gate + min-plus | `refl` only | absent |
| new / new | working tree `6b7ca8b6` | KFlow + gate + min-plus | induction skeletons | present, inert |
| old / new | synthesised, §6 | boolean "nothing proved" | induction skeletons | present, inert |

| arm | comparison | isolates |
|---|---|---|
| **A** | `6835a4e3` → `9283c75e` | the control law, gate held at `refl` |
| **B** | `9283c75e` → working tree | the certificate, control law held new |
| **C** | `6835a4e3` → working tree | the compound (what was asked for) |
| **D** | synthesised old-flow → working tree | the control law, gate held at induction |

Memory (`machine/library.terms`) is **off** in every arm. A build that predates
the feature ignores the file, so seeding it would hand the newer build theorems
the older one cannot see, and the A/B would be measuring the seed. `--memory`
exists for the separate question in §7.

## 3. Exact commands

```sh
machine/run-loop-ab.sh --rounds 14 --budget 1800 --baseline 6835a4e3 --keep DIR  # arm C
machine/run-loop-ab.sh --rounds 14 --budget 1800 --baseline 9283c75e --keep DIR  # arm B
machine/run-loop-ab.sh --rounds 14 --budget 1800 --baseline-variant old-flow \
                       --keep DIR                                                # arm D
machine/run-loop-ab.sh --rounds 1 --current-only --thoughts --keep DIR           # §7
```

Sources compiled, by sha256 — the engine is edited while it is measured, so
"the working tree" is not a stable name and the script prints the hash of
everything it builds:

| build | sha256 (first 16) |
|---|---|
| `6835a4e3` | `2bd0fa99cdc00f78` |
| `9283c75e` | `b0a9c4d5d0ea96ff` |
| working tree, arms B and C | `6b7ca8b622e0f5ce` |
| working tree, arm D | `69546da7e09667a8` (see §6.1 — same behaviour, checked) |
| arm D variant, cut from the above | `306530e057d0450b` |

**The bound is a round count, not a clock.** `main` never returns, so the script
watches the engine's own log and stops it when round *N* appears. The engine's
only randomness is an LCG with the literal seed `12345` and it reads no clock,
so *N* rounds from a fixed input is a reproducible object. Confirmed three ways
here: `9283c75e` reproduced the previous session's run of the same source
bit-for-bit; the two independent `current` runs (arms B and C) agree exactly at
143,080 terms, 13,767 conjectures, 7 theorems; and arm C's baseline reproduced
its own earlier run's rounds 0–10 exactly.

## 4. Environment: the control that makes the A/B mean anything

`6835a4e3`'s gate is **broken in a stock environment** — it runs
`agda -i formal/cubical -i <tmpdir>`, and `-i` adds include paths without making
Agda read a library, so every candidate dies on `Failed to find source of module
Cubical.Foundations.Prelude` and is logged as a `KERNEL-REJECT` indistinguishable
from a false statement. The current tree fixes this inside the engine by passing
`--library=cubical`.

If the baseline were left broken, the A/B would be measuring that path fix and
nothing else. The script therefore synthesises a private `AGDA_DIR` whose
`defaults` names the installed cubical library, which repairs the old gate
externally, so both arms of every comparison have a working kernel. It does not
touch `~/.agda`. Two further facts handled the same way: `LC_ALL` must name a
UTF-8 locale (the candidate contains `ℕ`), and the engine's relative paths mean
it must run from a repository-shaped directory — the script builds one under
`mktemp -d` with a symlink to `formal/`, so nothing in the repository is written
to. `setsid`, blamed in `machine/machine.stdout.log`, is present at
`/usr/bin/setsid`; that failure was a `PATH` problem and the script does not use
it.

Candidates are written to `/tmp` by `Certificate.hs` and cleaned up in a
`finally`; no `Candidate_*` file was left in `formal/cubical` by any run here.

## 5. Arms A, B, C

### Arm A — the control law alone, gate held at `refl`

`6835a4e3` → `9283c75e`, 15 rounds. Both columns are the baseline arms of the
two runs in §3 — `6835a4e3` is arm C's baseline and `9283c75e` is arm B's — so
this arm costs no extra run and is measured under identical conditions to the
rest. It also reproduces the first version of this measurement exactly, which is
the cross-session determinism check.

| | `6835a4e3` | `9283c75e` |
|---|---:|---:|
| theorems | 4 | 4 |
| library contents | identical | identical |
| terms enumerated | 2,748,324 | 350,912 |
| conjectures | 272,212 | 36,701 |
| engine CPU | 106.45 s | 14.08 s |
| mean pruned% | 52.7 | 61.0 |
| longest stuck run | 12 | 10 |

**Yield delta: exactly zero. Cost delta: 7.8× fewer terms.** First divergence at
round 2 — the baseline widens the vocabulary on a barren round, the new law
classifies it `resonance` and deepens instead. The baseline has spent every
growth move by round 11 (vocabulary 8 of 8, horizon 7) and then cycles between
637,852 and 376,636 terms proving nothing.

### Arm B — the certificate alone, control law held new

`9283c75e` → working tree, 15 rounds.

```
== baseline 9283c75e ==  (stop reason: rounds-reached)
round vocab size     terms  pruned%     conj   fresh proved   cum   cpu_s  wall_s assign  flow           gate      route   grow
    0     3    4        80     35.0        8       8      3     3    0.01    2.24     40  branching      advance   -       -
    1     3    4        80     57.5        2       2      0     3    0.00    0.74     40  decay          advance   -       -
    2     3    4        80     57.5        2       0      0     3    0.00    0.00     40  resonance      advance   -       deepen
    3     3    5       308     67.2       25      23      0     3    0.04    8.14     40  branching/hold advance   -       -
    4     3    5       308     67.2       25       0      0     3    0.00    0.00     40  resonance      advance   -       -
    5     3    5       748     55.3       74      74      0     3    0.04    1.59     40  branching/hold advance   -       -
    6     3    5       748     55.3       74       0      0     3    0.01    0.00     40  resonance      advance   -       deepen
    7     3    6      3436     65.5      302     228      0     3    0.11    0.85     40  branching/hold advance   -       -
    8     3    6      3436     65.5      302       0      0     3    0.03    0.11     40  resonance      advance   -       deepen
    9     3    7     16492     73.2     1201     899      0     3    0.45    0.43     40  branching/hold advance   -       -
   10     3    7     16492     73.2     1201       0      0     3    0.20    0.21     40  resonance      advance   -       widen
   11     4    7     58332     57.1     6878    6878      1     4    3.02    5.92     40  branching      advance   -       -
   12     4    7     58332     63.0     6002    6002      0     4    3.12    5.40     40  decay          advance   -       -
   13     4    7     58332     63.0     6002       0      0     4    0.87    0.85     40  resonance      advance   -       widen
   14     5    7    133708     60.2    14603   14603      0     4    6.18    7.63     40  branching/hold advance   -       -
  rounds=15  theorems=4  theorems/round=0.267
  cpu=14.08s  wall=34.11s
  pruned% 35.0 -> 60.2  mean=61.0   rounds stuck (proved=0)=13  longest stuck run=10
  GATE refusals=0  ROUTE firings=0   assignments 40 -> 40  (constant)
```

The `current` table is in arm C below (same binary, same configuration, and the
integer columns are identical between the two invocations). Deltas:

```
  metric                         baseline    current      delta
  theorems (cumulative)             4.000      7.000     +3.000
  theorems / round                  0.267      0.467     +0.200
  mean pruned%                     61.047     59.327     -1.720
  rounds stuck (proved=0)          13.000     12.000     -1.000
  longest stuck run                10.000      6.000     -4.000
  wall seconds total               34.110    214.990   +180.880
  engine cpu seconds total         14.080     48.970    +34.890
  GATE refusals                     0.000      0.000     +0.000
  ROUTE firings                     0.000      0.000     +0.000
```

**The certificate buys +3 theorems and costs 6.3× the wall clock.** Note the
mean pruned% goes *down* by 1.7 while the endpoint goes *up* (60.2 → 67.0): the
current build spends rounds 8–10 at 45–53% right after widening into `*`, where
it has few applicable rules yet, and then recovers past the baseline. **The mean
is a misleading summary of this quantity and the trajectory is not** — which is
why the script now prints the per-round `pruned%` series for both arms rather
than only its average.

### Arm C — the compound (the comparison that was requested)

`6835a4e3` → working tree, 15 rounds.

```
== baseline 6835a4e3 ==  (stop reason: rounds-reached)
round vocab size     terms  pruned%     conj   fresh proved   cum   cpu_s  wall_s assign  flow           gate      route   grow
    0     3    4        80     35.0        8       8      3     3    0.01    2.33      -  -              -         -       -
    1     3    4        80     57.5        2       2      0     3    0.00    0.74      -  -              -         -       widen
    2     4    4       144     45.1        9       9      1     4    0.01    2.21      -  -              -         -       -
    3     4    4       144     49.3        7       7      0     4    0.01    1.49      -  -              -         -       -
    4     4    4       284     39.8       27      27      0     4    0.01    1.48      -  -              -         -       deepen
    5     4    5      1628     50.4      166     139      0     4    0.10    9.62      -  -              -         -       widen
    6     5    5      2764     49.0      318     318      0     4    0.13    1.69      -  -              -         -       deepen
    7     5    6     18252     54.1     1950    1632      0     4    0.61    0.53      -  -              -         -       widen
    8     6    6     29884     52.7     2889    2889      0     4    1.00    2.53      -  -              -         -       deepen
    9     6    7    250300     59.5    22917   20030      0     4    9.28    9.36      -  -              -         -       widen
   10     7    7    415788     59.0    40352   40352      0     4   15.47   16.90      -  -              -         -       widen
   11     8    7    637852     56.6    67323   67323      0     4   25.81   27.19      -  -              -         -       -
   12     8    7    376636     62.9    34392   34392      0     4   16.72   18.26      -  -              -         -       -
   13     8    7    637852     56.4    67460   46643      0     4   22.35   24.19      -  -              -         -       -
   14     8    7    376636     62.9    34392   30040      0     4   14.94   16.64      -  -              -         -       -
  rounds=15  theorems=4  theorems/round=0.267
  cpu=106.45s  wall=135.16s
  pruned% 35.0 -> 62.9  mean=52.7   rounds stuck (proved=0)=13  longest stuck run=12
  GATE refusals=0  ROUTE firings=0

== current worktree ==  (stop reason: rounds-reached)
round vocab size     terms  pruned%     conj   fresh proved   cum   cpu_s  wall_s assign  flow           gate      route   grow
    0     3    4        80     35.0        8       8      3     3    0.01    2.49     40  branching      advance   -       -
    1     3    4        80     57.5        2       2      0     3    0.01    1.54     40  decay          advance   -       -
    2     3    4        80     57.5        2       0      0     3    0.00    0.00     40  resonance      advance   -       deepen
    3     3    5       308     67.2       25      23      1     4    0.14   47.03     40  branching      advance   -       -
    4     3    5       308     76.0       12      12      0     4    0.07   22.01     40  decay          advance   -       -
    5     3    5       308     76.0       12       0      0     4    0.00    0.00     40  resonance      advance   -       -
    6     3    5       748     57.8       66      66      0     4    0.09   21.06     40  branching/hold advance   -       -
    7     3    5       748     57.8       66       0      0     4    0.01    0.00     40  resonance      advance   -       widen
    8     4    5      1628     45.3      210     210      3     7    0.30   43.02     40  branching      advance   -       -
    9     4    5      1628     52.7      176     176      0     7    0.23   33.61     40  decay          advance   -       -
   10     4    5      1628     52.7      176       0      0     7    0.02    0.00     40  resonance      advance   -       deepen
   11     4    6      9436     60.2      982     808      0     7    1.11    2.66     40  branching/hold advance   -       -
   12     4    6      9436     60.2      982       0      0     7    0.12    0.11     40  resonance      advance   -       deepen
   13     4    7     58332     67.0     5524    4580      0     7   45.91   46.26     40  branching/hold advance   -       -
   14     4    7     58332     67.0     5524       0      0     7    0.91    0.84     40  resonance      advance   -       widen
  rounds=15  theorems=7  theorems/round=0.467
  cpu=48.93s  wall=220.63s
  pruned% 35.0 -> 67.0  mean=59.3   rounds stuck (proved=0)=12  longest stuck run=6
  GATE refusals=0  ROUTE firings=0   assignments 40 -> 40  (constant)
```

The two trajectories the control law is supposed to influence, round by round:

| round | pruned% base | pruned% cur | theorems base | theorems cur |
|---|---:|---:|---:|---:|
| 0 | 35.0 | 35.0 | 3 | 3 |
| 1 | 57.5 | 57.5 | 3 | 3 |
| 2 | 45.1 | 57.5 | 4 | 3 |
| 3 | 49.3 | 67.2 | 4 | 4 |
| 4 | 39.8 | 76.0 | 4 | 4 |
| 5 | 50.4 | 76.0 | 4 | 4 |
| 6 | 49.0 | 57.8 | 4 | 4 |
| 7 | 54.1 | 57.8 | 4 | 4 |
| 8 | 52.7 | 45.3 | 4 | 7 |
| 9 | 59.5 | 52.7 | 4 | 7 |
| 10 | 59.0 | 52.7 | 4 | 7 |
| 11 | 56.6 | 60.2 | 4 | 7 |
| 12 | 62.9 | 60.2 | 4 | 7 |
| 13 | 56.4 | 67.0 | 4 | 7 |
| 14 | 62.9 | 67.0 | 4 | 7 |

Load-independent totals:

| quantity | `6835a4e3` | working tree | ratio |
|---|---:|---:|---:|
| terms enumerated | 2,748,324 | 143,080 | 19.2× |
| conjectures formed | 272,212 | 13,767 | 19.8× |
| `KERNEL-ACCEPT` | 4 | 7 | |
| `KERNEL-REJECT` | 34 | 33 | |
| `KERNEL-SKIP` | 65 | **0** | |
| engine CPU | 106.45 s | 48.93 s | 2.2× |

The current library, all seven lines:

```
x            = (0+x)          [induction on x]
s(x)         = (s(0)+x)       [induction on x]
(s(x)+y)     = s((x+y))       [induction on y]
(x+(y+z))    = ((x+y)+z)      [induction on x]
0            = (0*x)          [induction on x]
x            = (s(0)*x)       [induction on x]
(s(x)*y)     = (y+(x*y))      [induction on y]
```

The fourth line is associativity of `+`. It is the qualitative result: `refl`
cannot check it, so it could not appear in any earlier run at any budget.

## 6. Arm D — the control law with yield live

Arms A, B and C cannot answer "does the control law matter now that theorems
install", because the two changes landed in different commits and no revision
carries the old control law together with the new certificate. That cell is,
however, exactly one line — the growth trigger:

```
6835a4e3     let stuck = null checkedResults
working tree let stuck = flow == Resonance && null checkedResults
```

`--baseline-variant old-flow` builds the baseline from the **current** source
with that one line reverted and nothing else touched; the script verifies the
substitution matches exactly once and aborts otherwise, because a variant that
silently failed to apply would be the current build wearing a baseline's label
and would report "no difference" for the most flattering possible reason. The
diff against the current source is one line, verified.

Carrying the other two rules along is sound here precisely because every table
in this document reports `GATE refusals=0` and `ROUTE firings=0`: they are
inert, so reverting the trigger reverts the whole control law's observable
behaviour. **If a future run shows a nonzero count in either column, this
variant stops being a single-factor control and the comparison becomes
three-factor again.**

### 6.1 Arm D result — the control law costs 9 theorems

```
== baseline variant:old-flow ==  (stop reason: rounds-reached)
round vocab size     terms  pruned%     conj   fresh proved   cum   cpu_s  wall_s assign  flow           gate      route   grow
    0     3    4        80     35.0        8       8      3     3    0.01    2.31     40  branching      advance   -       -
    1     3    4        80     57.5        2       2      0     3    0.00    1.47     40  decay          advance   -       widen
    2     4    4       144     45.1        9       9      2     5    0.02    5.51     40  branching      advance   -       -
    3     4    4       144     51.4        6       6      0     5    0.01    1.58     40  decay          advance   -       -
    4     4    4       284     40.8       26      26      0     5    0.01    1.37     40  branching/hold advance   -       deepen
    5     4    5      1628     51.2      161     135      1     6    0.22   55.85     40  branching      advance   -       -
    6     4    5      1628     52.9      148     148      1     7    0.37   49.11     40  branching      advance   -       -
    7     4    5      1628     54.0      146     146      0     7    0.28   43.94     40  decay          advance   -       widen
    8     5    5      2764     51.1      298     298      3    10    0.26   28.88     40  branching      advance   -       -
    9     5    5      2764     54.6      265     265      0    10    0.27   28.44     40  decay          advance   -       widen
   10     6    5      4156     53.1      366     366      3    13    0.32   26.32     40  branching      advance   -       -
   11     6    5      4156     55.9      335     335      0    13    0.30   19.67     40  decay          advance   -       widen
   12     7    5      5804     54.7      533     533      0    13    0.31   20.01     40  branching/hold advance   -       deepen
   13     7    6     44332     57.2     3897    3369      0    13    1.40    1.38     40  branching/hold advance   -       widen
   14     8    6     61596     53.5     6098    6098      3    16    3.19   34.02     40  branching      advance   -       -
  rounds=15  theorems=16  theorems/round=1.067
  cpu=6.97s  wall=319.86s
  pruned% 35.0 -> 53.5  mean=51.2   rounds stuck (proved=0)=8  longest stuck run=3
  GATE refusals=0  ROUTE firings=0   assignments 40 -> 40  (constant)
```

The `current` arm is the arm C table above, integer-for-integer. Deltas:

```
  metric                         baseline    current      delta
  theorems (cumulative)            16.000      7.000     -9.000
  theorems / round                  1.067      0.467     -0.600
  mean pruned%                     51.200     59.327     +8.127
  rounds stuck (proved=0)           8.000     12.000     +4.000
  longest stuck run                 3.000      6.000     +3.000
  wall seconds total              319.860    210.550   -109.310
  engine cpu seconds total          6.970     44.770    +37.800
  GATE refusals                     0.000      0.000     +0.000
  ROUTE firings                     0.000      0.000     +0.000
```

| quantity | old-flow variant | current (new flow) |
|---|---:|---:|
| theorems | **16** | 7 |
| terms enumerated | 131,188 | 143,080 |
| conjectures | 12,298 | 13,767 |
| engine CPU | 6.97 s | 44.77 s |
| `KERNEL-ACCEPT` | 16 | 7 |
| `KERNEL-REJECT` | 65 | 33 |
| `KERNEL-SKIP` | 0 | 0 |
| vocabulary reached by round 14 | 8 of 8 | 4 of 8 |
| horizon reached by round 14 | 6 | 7 |

**The mechanism is visible in the last two rows.** The old rule widens on every
barren round and is at vocabulary 8, horizon 6 by round 14; the new rule
classifies barren rounds as `resonance`, deepens, and is at vocabulary 4,
horizon 7. Deepening costs `r_b` per step (§9) and buys nothing the machine
cannot already normalise; widening costs one new symbol and exposes a fresh
family of definitional facts the certificate can now discharge. The variant's
extra nine theorems are exactly those: three about `max`, three about `-`,
three about `le` — all symbols the current build never reached.

The variant's library, all 16 lines (the current build's 7 are a prefix of the
first seven modulo ordering):

```
x         = (0+x)        s(x)   = (s(0)+x)      (s(x)+y) = s((x+y))
0         = (0*x)        x      = (s(0)*x)      (x+(y+z)) = ((x+y)+z)
(s(x)*y)  = (y+(x*y))
x         = (x max x)    s(x)   = (x max s(x))  s(x)    = (s(x) max x)
0         = -(x,x)       0      = -(x,s(x))     s(0)    = -(s(x),x)
0         = le(s(x),x)   s(0)   = le(x,x)       s(0)    = le(x,s(x))
```

**A caveat on this arm that must not be lost.** `machine/MathMachine.hs` was
edited between arm C and arm D — the `current` source hash moved from
`6b7ca8b622e0f5ce` to `69546da7e09667a8`. The variant was cut from the *newer*
source, so arm D is internally consistent, and the two `current` runs
(different hashes, separate invocations) agree in **every integer column**, so
the edit changed no observable behaviour over these 15 rounds. That was checked,
not assumed.

## 7. Reproducing the reported "14 at round 0", and what it decomposes into

Seeded (`--thoughts`), no memory, round 0 — identical control law, identical
term space, the certificate the only difference:

| | `9283c75e` (`refl`) | working tree (induction) |
|---|---:|---:|
| terms | 400 | 400 |
| pruned% round 0 | 32.2 | 32.2 |
| pruned% round 1 | 38.2 | **48.0** |
| theorems at round 0 | 4 | **14** |
| `KERNEL-ACCEPT` | 4 | 14 |
| `KERNEL-REJECT` | 5 | 5 |
| `KERNEL-SKIP` | **33** | **0** |

The reported figures reproduce exactly: `known=14`, pruned 32.2% → 48.0%. They
are **the certificate, not the memory** — the run above has no memory file. The
compounding claim is visible in the pruned step: +6.0 points under `refl`,
+15.8 points under induction, from the same starting term space.

With `--memory` the same endpoint is reached differently: `proved=10` new plus 4
re-admitted through the gate, `known=14`. Startup re-admission is
vocabulary-limited — at the unseeded start only 4 of the 15 remembered
equations are expressible in a 3-symbol vocabulary and the other 11 are not
re-admitted at round 0.

## 8. `GATE` and `ROUTE`: still silent, and that is now a finding

Across every 15-round run in this document — both control laws, `refl` gate and
induction gate, seeded and unseeded — `GATE` returned `advance` in every single
round and `ROUTE` never fired once. `assignments` stayed at 40 throughout, so
`mAssign` never left its initial value.

The parser no longer assumes it will. `assignments` is read off the `GATE` line
into its own column, a refusal is normalised out of `gateName`'s
`"refused: <reason>"` rendering, and the footer prints the observed range and
says whether it moved. Since a refusal doubles `mAssign` (capped at `8·kAssign`
= 320), a refusal would be visible as a step in that column and in the reported
range.

Why they stay silent is structural, not budgetary:

- `ROUTE` consults `gammaRoute (mCosts m2) …` and takes a move only when a cost
  for it has been **recorded**. Fifteen rounds do not accumulate one, so the
  ladder decides every time. The rule is wired and never consulted.
- `GATE` refuses only when the assignments separate nothing. With 40 random
  environments over a term space that stays behaviourally diverse, the defect
  never reaches zero. Reaching the refusing branch needs a deliberately small
  `kAssign`, not a longer run.

## 9. Scaling, re-read against the new numbers

**Term space.** Terms are built from `kVars = 3` variables, the constant `0`,
the unary `s`, and `b = vocab − 2` binary symbols. With `t_n` the number of
terms of size `n` and `T(x) = Σ t_n xⁿ`, the grammar (atom | `s(u)` | `f(u,v)`)
gives `T = a·x + x·T + b·x·T²` with `a = kVars + 1 = 4`, so
`T(x) = ((1−x) − √((1−x)² − 4ab·x²)) / (2bx)`. The dominant singularity is the
branch point where `(1−x)² = 4ab·x²`, giving `ρ_b = 1/(1 + 4√b)` and

    Σ_{n ≤ s} t_n  =  Θ( r_b^s · s^(−3/2) ),      r_b = 1 + 4√b.

This is unchanged by the new certificate — it is a fact about the generator.
What the improved pruning changes is **which `(vocab, size)` the machine visits
and how long it stays**, not the growth rate at fixed vocabulary.

The constant does have to be re-read, and the reason is worth stating: `terms`
is `genTermsModulo`'s output, which quotients by *currently proved*
commutativity and associativity. Those facts come and go as rules are
re-oriented, so **the count at a fixed `(vocab, size)` is not constant across
rounds** — arm C's current run shows 308 and then 748 terms at vocabulary 3,
horizon 5, with no growth move between. Ratios are therefore only meaningful
between rounds in the same AC state. Taking them from arm C's current run at
vocabulary 4, where the state is stable across rounds 8–14:

| vocab | b | sizes 5 → 6 → 7 | observed ratios | bound `1 + 4√b` |
|---|---|---|---|---|
| 4 | 2 | 1628 → 9436 → 58332 | 5.80, 6.18 | 6.657 |

The ratios rise monotonically toward the bound from below, which is what
`t_n ~ C·r^n·n^{−3/2}` predicts and a fitted exponent would not have told you.

**Kernel cost: the constant that actually changed.** The old gate spent one
`agda` process per verdict. The new one tries induction skeletons and spends a
**mean of 5.2 calls per verdict** (208 calls over 40 verdicts in arm C's current
run). A single candidate check on an idle host is 0.766 s, independently
recovered as 0.772 s from an earlier null control. So the per-verdict kernel
cost went from ≈0.77 s to ≈4.0 s, and that — not the term space — is why the
current build's wall clock is 6.3× the baseline's in arm B while its engine CPU
is lower. Wall figures here are additionally contaminated by other agents
compiling Agda on this host (load 0.8–6.5); the integer columns are not.

**Consequence for the budget.** Round cost is `Θ(r_b^s)` and the engine deepens
after `O(1)` stuck rounds at each horizon, so the reachable horizon in a wall
budget `B` is `s ≈ log_r B + O(1)` and **the affordable round budget grows like
`log B`: to double the number of rounds you must square the budget.** The
certificate's 5.2× kernel multiplier shifts that curve down by a constant, it
does not change its shape. A longer comparison needs a horizon cap or a cheaper
generator, not more machine time.

## 10. What this can and cannot show

**Can show:**

- The certificate lifted yield: 4 → 7 theorems unseeded, 4 → 14 at seeded round
  0, `KERNEL-SKIP` eliminated as a category (65 → 0), and an inductive theorem
  in the library that `refl` could not have admitted.
- Under a `refl` gate the control law lowered cost without touching yield
  (arm A: theorems 4 → 4, terms 7.8× fewer).
- Under the induction gate the same control law **costs 9 theorems and saves
  nothing** (arm D: 16 → 7 theorems, 131,188 → 143,080 terms, 6.97 s → 44.77 s
  engine CPU). The sign of its effect depends on the prover it is steering.
- These are exact integers, reproduced across separate invocations, across
  sessions, and across two source hashes of the same behaviour.

**A note on how nearly this was missed.** Arm C — the compound comparison that
was actually requested, pre-wiring baseline against the current tree — shows
4 → 7 theorems and 19.2× fewer terms, and reads as an unqualified success for
everything that landed. It is only when the certificate is held fixed and the
one-line growth trigger is varied alone that the control law's contribution
separates out with the opposite sign. A compound A/B across two changes cannot
attribute its own result, and this one would have credited the control law with
the certificate's win.

**Cannot show:**

- **That the pruned% mean improved.** It did not, in arm B — it fell 1.7 points
  while the endpoint rose 6.8. Anyone quoting a mean here is quoting an
  artefact of when the machine widens.
- **Anything about `GATE` or `ROUTE`.** They never fired. Their correctness is
  untested by every run in this document, in both branches for `GATE` and
  entirely for `ROUTE`.
- **That 15 rounds is where the interesting behaviour is.** Both builds are
  still climbing at round 14 and neither has exhausted its vocabulary except
  the pre-wiring baseline, which exhausted its own by round 11 and then spun.
- **Wall-clock anything**, for the contamination reasons in §9.

## 11. What would settle the rest

- **The trigger, which is now the live question.** Arm D says the `resonance`
  classification is picking the wrong move on this budget: it deepens where
  widening is cheaper *and* more productive. Whether that survives past round 14
  is genuinely open — the old rule exhausts its vocabulary at round 14 and, on
  the evidence of arm C's baseline, then spins. The natural next measurement is
  arm D extended until the variant runs out of symbols, which is the first
  round at which the frugal rule could start repaying its deficit.
- **The gate.** Run with a deliberately small `kAssign` so the test set
  collapses, and check that `GATE` refuses, that `mAssign` doubles, and that
  the `assign` column steps — the harness will now show all three.
- **The chooser.** `ROUTE` needs a recorded move cost before it can fire.
  Either seed `mCosts` or establish that 15 rounds cannot produce one, in which
  case the min-plus rule is unreachable in any run of this length and should be
  described that way. Note that if `ROUTE` ever does fire, the arm D variant
  stops being a single-factor control (§6).
- **Yield past round 14.** The horizon cap, not the budget, is the lever.
