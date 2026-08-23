# The loop with nobody in it: ~~5.6% fewer kernel steps on domains it had never seen, with the null control holding~~ 5.70% fewer kernel steps on domains it had never seen — and the strict null control does **not** hold

**Author:** cf-sakshi, 2026-08-14. **Status:** executable, measured, with two
controls. `natural_machine_cpu_loop_rust/evolve.rs` —
`rustc -O evolve.rs -o evolve && ./evolve`. Exact integers, ~~deterministic,~~
**deterministic only as of the 2026-08-16 fix (§7); this word was false when it
was written,** no model anywhere in the loop.

> **CORRECTION, 2026-08-16 (see §7).** The program was **not** deterministic
> when this note was written: `mine` broke gain-ties by `HashMap` iteration
> order, which Rust randomises per process. Every figure below marked with a
> strike-through was one draw from a distribution the note did not know it was
> sampling. The tie-break is now canonical (lexicographically least maximiser)
> and the program is deterministic; the corrected figures follow each struck
> one. **The headline survives and the null control does not.** Nothing is
> deleted — the struck text is what was published and what the record has to
> keep.

## 0. What was wrong with version 1

`notes/NATURAL_MACHINE_CPU_LOOP.md` reported a loop that ran. It had **me in it
at three points**: I chose the domain, I chose the workload, and I chose which
mined block to install. A machine with external steps in its loop does not
improve itself — it is improved, and the improvement is the operator's.

Version 2 removes all three:

| external step | replaced by |
|---|---|
| a chosen domain | an **enumerated stream**: every divisibility crystal for base 2–4, modulus 2–60, in fixed order, no selection. The machine meets whatever comes next. |
| a chosen workload | **derived canonically**: the base-$b$ expansions of $1..40$. The machine is tested on the numbers themselves. |
| a chosen install | the machine's **own kernel counters** against its own declared measure, with a **persistent library** so a decision at domain 7 changes what happens at domain 160. |

## 1. The claim, stated so it can fail

Self-improvement is not "it compresses." It is: *what it learned on earlier
objects lowers the cost of later objects that did not exist for it when it
learned.* Three arms, same stream, same measure, all costs net of installation:

- **A — no library ever.** The machine that cannot learn.
- **B — learned library.** Mines a block from each domain's own workload,
  installs it into the library, carries it forward.
- **C — null control.** A library of the *same size* filled with arbitrary
  blocks. It must not help. If it does, the measure is measuring itself.
  **It does help, at the default seed and at 20 of 60 seeds (§2.1). The claim
  was stated so it could fail, and it failed; what replaces it is the paired
  comparison B-vs-C, which does not.**

## 2. Result

**The block immediately below is what was published: one process's draw, from a
distribution the note did not know it was sampling. It is kept verbatim, with
each superseded line marked. The corrected block follows it.**

```
  total kernel steps over the whole 177-domain stream
    no library           1191167
    learned library      1121224   (-5.87%)      <-- STRUCK: varied 1121166..1121229 across six runs
    null library         1192713   (+0.13%)      <-- STRUCK: varied -0.03%..+0.14% across six runs

  SECOND HALF ONLY -- domains unseen when the library was built
    no library            900573
    learned library       850123   (-5.60%)      <-- STRUCK
    null library          902498   (+0.21%)      <-- STRUCK

  SELF-IMPROVEMENT (learned beats no-library on unseen domains): true
  NULL CONTROL     (arbitrary library must NOT beat no-library): true   <-- STRUCK: false under canonical mining
```

**Corrected, 2026-08-16, canonical tie-breaking, byte-identical over 8 runs:**

```
  total kernel steps over the whole 177-domain stream
    no library           1191167
    learned library      1119984   (-5.98%)
    null library         1178046   (-1.10%)
    library size at end: 3          (was 7 -- see §3)

  SECOND HALF ONLY -- domains unseen when the library was built
    no library            900573
    learned library       849203   (-5.70%)
    null library          891479   (-1.01%)

  SELF-IMPROVEMENT (learned beats no-library on unseen domains): true
  NULL CONTROL     (one seed only -- see the seed sweep, not this line): false
  SEPARATION       (learned beats the SAME-SIZE arbitrary library): true  (849203 vs 891479)
```

The second-half figure is the one that means anything: those domains were not in
existence for the library when it was built, installation cost is charged in
full, ~~and the arbitrary-library control comes out **slightly worse** than not
learning at all — which is correct, since installing a block that never matches
is pure cost.~~ **and the arbitrary-library control comes out 1.01% *better*
than not learning at all — so the strict null control fails.** Arm A is
unchanged (900573; it never had a library and never had a tie to break), and
the headline is slightly *stronger* than published: −5.70% rather than −5.60%,
now as a property of the source rather than of one process.

### 2.1 What the null control actually does, with its seed dependence

The published `+0.21%` was one draw of a `Rng(0x5EED)` library and was read as
if it were a verdict. It is not one. Sweeping the arm-C seed over `1..60`
(arms A and B do not read the seed and do not move), the second-half arm-C
figure is:

| statistic | arm C, second half |
|---|---|
| range | **−4.61% … +3.42%** |
| median | +0.90% |
| mean | +0.54% |
| seeds where the arbitrary library **beats** no-library | **20 / 60** |
| seeds where the arbitrary library beats the **learned** library (−5.70%) | **0 / 60** |

So: an arbitrary same-size library is centred near zero and helps *by chance*
one time in three. A single seed can therefore report either verdict, and the
original `true` was not evidence that arbitrary blocks do not help — it was a
coin that landed. **The separation is what is seed-independent**: the learned
library beat the arbitrary one at 60 seeds out of 60, and the best arbitrary
draw observed (−4.61%) still lost to arm B's −5.70%.

Why the control got weaker rather than stronger under the fix: the null library
is *size-matched* to the learned one, which canonical mining shrank from 7
blocks to 3 (§3). Three draws is a high-variance estimator, and the residual
effect it estimates is not zero — folding shortens words whatever the block is,
so *any* macro that matches at all buys something. That is a defect in the
measure, stated here and not smoothed over: the measure rewards folding per se.
What is attributable to *what was learned* is only the gap between the arms —
**4.7 percentage points** at the default seed (−5.70% vs −1.01%), and **6.6
points** against the median arbitrary draw (−5.70% vs +0.90%). It is not the
full −5.70%, and the pre-fix note read it as if it were.

This is `runtime/CRYSTAL.md` §0's seed criterion satisfied at the level of a
*stream* rather than a single hand-built pair, and it is the criterion version 1
**failed** at one pass (`NATURAL_MACHINE_CPU_LOOP` §3). What changed is not the
mechanism but the economics: one macro against one unseen workload does not repay
its transport, while a library amortised across 88 unseen domains does.

## 3. What it learned, unprompted

~~The seven-block library below is an artifact of the randomised tie-break: the
five base-4 entries are five members of one five-way tie, entered in whatever
order the allocator produced. Three consecutive pre-fix runs gave three
different orderings and three different sets.~~

```
    block [1,0] over base 2, learned at domain 0
    block [1,0] over base 3, learned at domain 1
    block [2,0] over base 4, learned at domain 2      <-- STRUCK
    block [1,1] over base 4, learned at domain 5      <-- STRUCK
    block [1,2] over base 4, learned at domain 8      <-- STRUCK
    block [1,3] over base 4, learned at domain 14     <-- STRUCK
    block [1,0] over base 4, learned at domain 32     <-- STRUCK
```

**Corrected, canonical mining — the library is three blocks, not seven:**

```
    block [1,0] over base 2, learned at domain 0
    block [1,0] over base 3, learned at domain 1
    block [1,0] over base 4, learned at domain 2
```

~~It found `[1,0]` first in **every** base.~~ **At base 4 it found no such
thing, and the struck table above says so on its own face: it lists `[2,0]`
at domain 2 and `[1,0]` only at domain 32. The narrative sentence contradicted
the note's own printed evidence.** What counting actually gives, as a finite
exhaustive fact over the base-$b$ expansions of $1..40$ and all block lengths
$2..6$ (so this is a proof, not a measurement):

| base | maximal gain | attained by | reuses |
|---|---|---|---|
| 2 | 44 | `[1,0]` **uniquely** | 46 |
| 3 | 18 | `[1,0]` **uniquely** | 20 |
| 4 | 5 | `[1,0]`, `[1,1]`, `[1,2]`, `[1,3]`, `[2,0]` — a **five-way tie** | 7 each |

So the honest statement is: **at bases 2 and 3 the machine found $[1,0]$ by
counting, and it is the unique maximiser there.** At base 4 counting does not
single out any block; five are exactly equally reused, and $[1,0]$ now appears
only because "lexicographically least" is the convention the fix installs. A
convention is not a discovery, and the two must not be reported in the same
sentence.

Where the observation does hold it holds cleanly. In the digit action
$r \mapsto br+d$ the block $[1,0]$ is $r \mapsto b(br+1) = b^2 r + b$ — at bases
2 and 3 the machine's first discovery, in each alphabet independently, is the
composite that advances two positions and carries a one, and nobody suggested
it. The base-4 degeneracy has a reason of its own: base-4 expansions of $1..40$
are at most three digits, so every length-2 block that occurs at all occurs
about equally often and the counting has nothing to separate (§4).

## 4. The honest defect in the result

~~**The gain is entirely absent at base 4** (`+0.00%` at domains 20, 80, 140)
despite five base-4 macros in the library.~~ **Corrected: the gain at base 4 is
small but non-zero — `−0.40%`, `−0.30%`, `−0.18%` at domains 20, 80, 140 —
because canonical mining leaves *one* base-4 macro in the library instead of
five. Four of the five were paying installation cost in every base-4 domain and
collecting nothing; the `+0.00%` was those four cancelling the one that worked.
The defect was therefore worse than reported, and the fix for the *tie-break*
partially fixed it by accident.** Base-4 expansions of $1..40$ are at
most three digits long, so a length-2 block rarely has room to fold. The
improvement is real but **concentrated where words are long**, and the machine
currently has no way to notice this and stop paying base-4 installation costs
that never repay. That is the next defect to fix and it is stated here rather
than smoothed over: a library that cannot predict its own applicability pays
everywhere and collects somewhere. **The sharpened version of the task: the
machine cannot notice a five-way tie either, and a tie is precisely the signal
that its measure has stopped discriminating.**

## 5. Rigor boundary

**Measured, not proved:** every kernel-step count. They are counts of this
program's operations under this program's declared measure; a different measure
gives different numbers. The three arms share one measure, one stream and one
workload, which is what makes the comparison meaningful ~~and the null control
decisive~~ — **but the null control is not decisive and never was: it is one
draw of an arbitrary library, and §2.1 shows both verdicts are reachable by
changing its seed alone. A boolean printed from one sample is not a control.**

**Reproducible, as of 2026-08-16:** the program is a function of its source.
`rustc -O evolve.rs -o evolve && ./evolve` prints identical bytes on every run
(checked: identical MD5 over 8 runs), and `./evolve <seed>` moves arm C only.
Before the fix this was false and the note asserted it anyway.

**Proved and re-proved at every use:** each macro's transition table is
*constructed* by composing its block on every state, then verified exhaustively
against its expansion — a finite exhaustive check, per `CLAUDE.md`. A macro is
never trusted across domains; the check is re-run in each.

**Not claimed:** that the machine discovers objectives, chooses what to study, or
rewrites its own kernel. It rewrites its **action language** — that is the only
self-rewriting demonstrated. §6 says what the next rewrite is.

**Substrate defect, unchanged from version 1:** Rust, because this container has
no Agda and no Lean and egress to fetch a toolchain is blocked (403). The Lean
port is owed.

## 6. The geodesic from here

The machine now rewrites its action language with nobody in the loop. Three
further rewrites are needed before it is the interface for mathematics, in
dependency order — each strictly harder, none requiring a model:

1. **Rewrite its own cost model.** It currently has one declared measure and
   cannot notice that base-4 installs never repay. A machine that maintains a
   *predictor of its own applicability* and prunes the library by it is one that
   revises its own objective function — the first genuinely reflective step, and
   §4's defect is the concrete task.
2. **Rewrite its own domain generator.** The stream is exhaustive but the
   *family* was written by hand. Wolfram's move (upstream U0003, U0011) is to
   enumerate the simple programs themselves and let the interesting families be
   found rather than specified.
3. **Rewrite its own source.** The Frankenstein step. Agda is open source and the
   surgery is the right instinct, but note what it actually requires: not editing
   Agda, but making the machine's installs *emit checked terms* so that the
   library is a set of proofs and the cost reduction is a theorem rather than a
   counter. That is the only version of self-rewriting that cannot lie about
   itself, and it is blocked here only by a missing toolchain, not by an idea.

## 7. Correction record — the determinism overclaim (2026-08-16)

**What was wrong.** `mine` selected the highest-gain block with a strict
`gain > best` test while iterating a `HashMap` directly. Rust's default hasher
seeds from the OS per process, so gain-*ties* were broken by allocator state.
Ties are not exotic here: at base 4, five length-2 blocks are reused exactly 7
times each (§3), so the library's base-4 contents were decided by nothing at
all. The header of `evolve.rs` and the status line of this note both said
"deterministic". Neither had checked.

**How it was caught.** By running the same binary six times. The whole-stream
learned total moved over `1121166..1121229`, the arm-C figure over
`−0.03%..+0.14%`, and three consecutive runs produced three different libraries
in three different orders. One of those six runs would have printed a *failing*
whole-stream null control. The published `+0.13% / +0.21%, control holds` was
the draw that happened to be in the buffer on 2026-08-14.

**The fix.** `mine` now returns a canonical maximiser: greatest gain, ties
broken by the lexicographically least block, which is a total order and so
makes the fold independent of `HashMap` traversal order. That was the program's
only nondeterminism. Arm C's seed is now an explicit optional argument
(`./evolve <seed>`, default `0x5EED`) so its dependence can be exhibited rather
than hidden, which is what §2.1 does.

**What changed, and what did not.**

| claim | before | after | verdict |
|---|---|---|---|
| arm A, second half (no library) | 900573 | 900573 | unchanged — arm A has no ties |
| arm B, second half (learned) | 850123 (−5.60%) | **849203 (−5.70%)** | survives, marginally stronger, now reproducible |
| arm C, second half (arbitrary) | 902498 (+0.21%) | **891479 (−1.01%)** | **reverses** |
| library size | 7 | **3** | four of the seven were tie-noise |
| SELF-IMPROVEMENT | true | **true** | **survives** |
| strict NULL CONTROL | true | **false** (fails at 20/60 seeds) | **withdrawn** |
| SEPARATION (B beats C) | not reported | **true, 60/60 seeds** | this is the robust claim |
| "found `[1,0]` first in every base" | asserted | **false at base 4** (five-way tie) | **withdrawn** |

**What this cost, and the lesson in the local idiom.** `CLAUDE.md` says a
number without its $X$-dependence is worse than no number, because it looks
like knowledge. This note published four numbers without their *seed*
dependence, and one of them (`+0.21%`) was load-bearing enough to reach the
title. The dependence was not even hard to find — it is six runs of an existing
binary, which is less work than the original measurement. The applicable rule is
the one already in the file: *the content is the error term*. A program that
prints a different number each time it runs has an error term of its own
making, and the first duty of a measurement harness is to not be a source of
noise.

**Scope.** Only `mine`'s tie-break, arm C's seed plumbing, and the reporting
lines changed. The kernel counters, the domain stream, the workload, `install`'s
exhaustive replay check, and arms A and B's logic are untouched — arm A's totals
are byte-identical before and after, which is the check that the fix did not
quietly move the baseline.
