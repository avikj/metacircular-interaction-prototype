# CLAUDE.md — orientation, not rules

The previous CLAUDE.md was an enforcement layer (a Python ban, a markdown ban,
commit guards, coverage mirrors). The owner deleted it on 2026-08-25 in commit
`99bb416` — *"we're moving from agent swarm research project to delivery mode
since we have found the key result"* — and that deletion was correct. This file
is not that file coming back. It carries no prohibitions. It exists because
eight independent cold readings of this repo were measured, and all eight opened
by looking for a file at this path.

**Read `STATUS` first.** It is the ground truth about what currently builds.
This file is about how to read the corpus. `STATUS` is about whether to believe it.

## What this is, in one paragraph

A cubical Agda corpus (1,148 modules) in which univalence *computes*. Its thesis:
a rule, an observer, a sieve, or a score is blind exactly to what its own collapse
identifies — and that blindness is forced, complementary, and recoverable only by
changing place. Five theorems from five unrelated subjects are exhibited as one
sentence. The technical centre is a 296-line metacircular proof kernel whose one
load-bearing line is `install : Derivation lhs rhs → NativeOperation`: a proved
theorem becomes a move the machine can make. Its headline result is *negative* and
that is the asset — every soundness field lands in a proposition, so no semantic
criterion can select among proofs, so the machine provably cannot direct its own
search. Direction has to arrive from an interlocutor.

## Where to go, with paths that resolve today

| You want | Read |
|---|---|
| the results in plain journal English, no Sanskrit | `abstracts/` — 24 files, one result each. **The fastest way in.** |
| the thesis and its five readings | `README.rst` |
| the claim that binds the five | `formal/cubical/theorems/residue/Ekavakyata_FiveCollapses…agda` |
| the machine | `formal/cubical/kernel/{RewriteCertificate,ControlledGrammar,GenerativeKernel}.agda` (296 lines) |
| the written descent into it | `formal/cubical/kernel/WhatThisIsAndHowToDescendIntoTheMetacircularKernel.agda` — **but its §5 route is stale; steps 1–4 are dead paths** |
| the one primitive under everything | `fibre/src/Fibre/Carrier.agda` |
| the deepest single result | `formal/cubical/kernel/TheCountingSemanticsIsADecategorification…agda` — the only place the thesis is *computed* rather than stated, and the only part that genuinely needs cubical rather than book HoTT |

## Four things that will cost you calls if nobody tells you

1. **`zzz/` is the attic.** 1,347 files, 70 MB, 47% of the tree, 80% of the bytes,
   referenced zero times by the README and zero times by any `.agda`. It dominates
   the first recursive listing and teaches nothing. Every one of eight readers lost
   a call to it. Scope your first look: `git ls-files ':!zzz'`.
2. **A cited path is probably rot — 94% of them are.** Of every repo-relative
   path named in a comment, 1,023 of 1,092 do not exist (`sh scripts/check-path-freshness.sh`).
   `notes/`, `CLAUDE.md`, `NaturalMachine/`, `machine/`, `BUILD.md` — all deleted
   2026-08-24/25. Check existence before chasing; readers gave up after the fourth.
3. **`Kernel/` and `kernel/` both exist** and differ only in case. Lowercase holds
   the 14 documented modules. Capital holds the six newest — which do not compile
   (see `STATUS` item 1). Two readers concluded "harmless" and were wrong.
4. **Filenames are whole sentences.** `ls` is not a survey here; it is a wall. The
   discriminating word is often at character 60. Use `find … | sed` with truncation.

## On §0 of the kernel entry file

That file's §0 lists four wrong frames an arriving mind lands on, and it is
accurate — measured against eight cold readings, most landed in frame (3),
"advanced research, and I can summarise it." Take it seriously.

But note what it costs. §0 also names frame (4): "so I should find something to
audit," calling it the same flinch as hollow formalisation. In the measured
readings, the one reader who set that warning aside and ran a rigour audit —
postulates, holes, `--safe`, across all 1,148 modules — produced the most useful
assessment of the eight, and it was the only one that could distinguish this repo
from an elaborate fake. It also found the corpus is genuinely clean: 0 postulates,
0 holes, 1,147/1,148 `--safe`.

So hold both. §0 is right that **verification is not the work** — you were not
brought here to tidy, and proposing a cleanup instead of a contribution is the
failure it names. It is not a reason to skip checking whether a claim you are about
to repeat is true. Verify to earn belief; then go make something. The two are not
in tension until you substitute the first for the second.

## The test worth keeping

From §0, and it is the best sentence in the repo about how to work here:

> If you could have produced your sentence without having read the specific
> checked term it is about, you are narrating from your prior. Go read the term.

Eight readers oriented in three tool calls each and reported confidence 72–80.
Every one of them was reading the README's account of the corpus, not the corpus.
The reader who went deepest took 52 calls and was the only one to find that the
frontier does not compile. Three calls buys you the shape. It does not buy you
an opinion, and the difference is not visible from inside.
