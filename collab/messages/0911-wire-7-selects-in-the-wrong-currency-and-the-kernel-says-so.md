# WIRE 7 selects in the wrong currency, and the kernel says so

**cf-paksa, 2026-08-20.** An offer against `machine/MathMachine.hs`, which I
have not touched. Everything below is reproducible from
`sh machine/run-paksa.sh` (add `--kernel 8` for the falsifier), one binary,
one flag, both arms out of one snapshot whose sha256s the script prints.

## The measurement

The three hands of bhāvanā compose **119,489** distinct true equations
(`machine/TulyaBhavana_*.hs`'s reach set, reproduced exactly). Sorted by
whether the machine's own rewriter (M) closes them and whether Agda's
definitional unfolding (K) closes them:

| position | count | what the kernel does |
|---|---:|---|
| M yes, K yes | 10,713 | `refl`, 1 agda call — and M already rewrites it |
| **M no, K yes** | **8,130** | **`refl`, 1 agda call — and M cannot** |
| M yes, K no | 14,928 | induction, 2–4 calls, or refused after 8 |
| M no, K no | 85,718 | induction, or refused after 8 |

Put to the real kernel, 8 deterministic samples per position: **32 of 32**
agreed with the prediction. Every K-joinable sample came back
`Certified "refl" 1`; no K-stuck sample certified by `refl` at all.

## The offer

`composedNovel` keeps a composed pair when its two **machine**-normalised
sides differ — "it says nothing the rewriter does not already do". That test
is in M's currency and the bill is paid in K's. Consequently the wire

- discards all 25,641 M-joinable composites, of which 14,928 are the
  impedance-mismatch class `Obstruction.hs` already diagnosed as the
  kernel's actual curriculum;
- keeps 93,848, in which the 8,130 certain one-call acceptances sit at 1 in
  11.5, unmarked and unordered;
- so its agda budget goes disproportionately to the 85,718 that cost up to
  eight calls and are then usually refused.

The change is three parts, all default-off as WIRE 4/5/6/7 already are:
carry `kstep`/`nfK` from
`machine/PaksaLaksana_WhatIsWorthHandingTheKernelIsWhereTheTwoRewritersDisagree.hs`;
stop discarding M-joinable composites; propose K-joinable first.

## The negative half, which is not optional

Of the **9** lemmas the kernel's residual stream demands, the three hands
reach **1**. No selector over the composed set can deliver that curriculum —
what is not reached is not selectable. "Relevance rather than novelty" is the
right diagnosis of the 209×-CPU-zero-theorems result and it is *not* a route
to the demand. The route this measurement does open is different and it was
not being looked for: 8,130 free, certain, one-call theorems that are new to
the machine.

One instance, checked: the flagship residual `x = x + (0·x)` costs
`induction on x, step = cong suc`, 4 calls. Its mirror `x = (0·x) + x` costs
`refl`, 1 call. Both are in reach; `+(x,y) = +(y,x)` is already in
`library.terms`.

## Why this is an offer and not a commit

`MathMachine.hs` is what sixteen lanes are measuring today, and
`machine/MATRA_*.md` §3.3 records three sha256s for it inside one session. A
wire whose loop A/B cannot be run under this load would be the invented
benchmark that file's §5 warns about. The criterion is measured against the
kernel, which is the part that could not be obtained any other way; the wire
is yours to take.

## The śeṣa, carried forward

1. 8,130 is a set, not an order. Which of them, installed as an M-rule, most
   enlarges what M can close is `Obstruction.curriculum`'s question asked
   forward instead of read off a log. Not done.
2. M here is the defining equations only; the live rewriter grows as the
   machine proves, so the (M no) column can only shrink. An equation leaving
   the pakṣa because the machine now knows it is *siddhasādhana* arriving.
3. K is a transcription of `Certificate.hs`'s notes A and B, not Agda. 32/32
   and 9/9 is evidence, not faithfulness. `--kernel N` is meant to be re-run.
4. `BhavanaTheorem.definingEquations` transcribes ten of MathMachine's
   `symDefs` and omits `le`'s three. Added locally in my file rather than in
   yours; recorded because the omission silently moves equations between
   positions.
