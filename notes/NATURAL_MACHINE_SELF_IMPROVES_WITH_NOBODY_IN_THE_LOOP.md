# The loop with nobody in it: 5.6% fewer kernel steps on domains it had never seen, with the null control holding

**Author:** cf-sakshi, 2026-08-14. **Status:** executable, measured, with two
controls. `natural_machine_cpu_loop_rust/evolve.rs` —
`rustc -O evolve.rs -o evolve && ./evolve`. Exact integers, deterministic, no
model anywhere in the loop.

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

## 2. Result

```
  total kernel steps over the whole 177-domain stream
    no library           1191167
    learned library      1121224   (-5.87%)
    null library         1192713   (+0.13%)

  SECOND HALF ONLY -- domains unseen when the library was built
    no library            900573
    learned library       850123   (-5.60%)
    null library          902498   (+0.21%)

  SELF-IMPROVEMENT (learned beats no-library on unseen domains): true
  NULL CONTROL     (arbitrary library must NOT beat no-library): true
```

The second-half figure is the one that means anything: those domains were not in
existence for the library when it was built, installation cost is charged in
full, and the arbitrary-library control comes out **slightly worse** than not
learning at all — which is correct, since installing a block that never matches
is pure cost.

This is `runtime/CRYSTAL.md` §0's seed criterion satisfied at the level of a
*stream* rather than a single hand-built pair, and it is the criterion version 1
**failed** at one pass (`NATURAL_MACHINE_CPU_LOOP` §3). What changed is not the
mechanism but the economics: one macro against one unseen workload does not repay
its transport, while a library amortised across 88 unseen domains does.

## 3. What it learned, unprompted

```
    block [1,0] over base 2, learned at domain 0
    block [1,0] over base 3, learned at domain 1
    block [2,0] over base 4, learned at domain 2
    block [1,1] over base 4, learned at domain 5
    block [1,2] over base 4, learned at domain 8
    block [1,3] over base 4, learned at domain 14
    block [1,0] over base 4, learned at domain 32
```

It found `[1,0]` first in **every** base. In the digit action $r \mapsto br+d$
the block $[1,0]$ is $r \mapsto b(br+1) = b^2 r + b$ — the machine's first
discovery, in each alphabet independently, is the composite that advances two
positions and carries a one. Nobody suggested it; it is the most reused block in
the expansions of the first forty integers, and the machine found it by counting.

## 4. The honest defect in the result

**The gain is entirely absent at base 4** (`+0.00%` at domains 20, 80, 140)
despite five base-4 macros in the library. Base-4 expansions of $1..40$ are at
most three digits long, so a length-2 block rarely has room to fold. The
improvement is real but **concentrated where words are long**, and the machine
currently has no way to notice this and stop paying base-4 installation costs
that never repay. That is the next defect to fix and it is stated here rather
than smoothed over: a library that cannot predict its own applicability pays
everywhere and collects somewhere.

## 5. Rigor boundary

**Measured, not proved:** every kernel-step count. They are counts of this
program's operations under this program's declared measure; a different measure
gives different numbers. The three arms share one measure, one stream and one
workload, which is what makes the comparison meaningful and the null control
decisive.

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
