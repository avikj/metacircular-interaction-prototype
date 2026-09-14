# HANDOFF — state of the cubical Bend2 work (read this first if you are a fresh agent)

Everything below is on `main`. The patched compiler lives OUTSIDE the repo in a
container (`/tmp/Bend2`); to rebuild from the repo:

    git clone https://github.com/DKormann/Bend2 /tmp/Bend2 && cd /tmp/Bend2 && git checkout f026483
    git apply collab/bend2-cubical/cubical-paths.patch      # the whole cubical layer + emitters
    # HVM3 as a local package: clone HigherOrderCO/HVM3 to /tmp/HVM3, patch Runtime.c to
    #   #include "runtime/reduce/ref.c" and "ref_sup.c"; cabal.project: packages: . /tmp/HVM3
    export PATH="$HOME/.ghcup/bin:$PATH" LC_ALL=C.utf8 LANG=C.utf8   # LC_ALL is MANDATORY
    cabal build exe:bend                                     # GHC 9.12.2, cabal 3.18
    # HVM4: clone HigherOrderCO/HVM4 to /tmp/HVM4; gcc -O2 -o src/hvm src/hvm.c ; `hvm f.hvm4 -s -C10`

Run: `bend f.bend` (checks + runs; `bend check` is NOT a subcommand; count ✓/✗ lines).
Targets: `--to-hvm4` (normalised), `--to-hvm4-raw` (no normalisation, strict),
`--to-hvm4-full` (FULL cubical runtime: nothing erased), `--to-hvm` (HVM3), `--total`.

## What the user wants (their words, condensed)
The README's Interactive Symbolic Computer: the trace IS the path
(data = program = execution = proof = transport); traces compose, invert, have
higher coherences; knowledge is partial. So EVERYTHING cubical must be a RUNTIME
object, no erasure, no compile-time normalisation. No overclaiming; verify by
execution; push/pull main every few minutes; never idle; no questions.

## Where things stand (all verified by execution; see STATUS.md for the table)
- Checker: full CCHM layer, general hcompN, hfill, coherent univalence round
  trip, the fibre law A ≃ Σ B (fiber f) as a coherent Equiv (`fibrelaw.bend`).
- `--to-hvm4-full` (Target/HVM4Full.hs, in the patch): intervals, paths
  (#PLm / #UaU / #CompU data), TYPES (#Bool, #Pi, #Sig, #Path …), coe (@coe,
  runtime dispatch on the type former at a symbolic interval) and hcomp
  (@hcomp; faces evaluated at runtime; STUCK DATA #HCm when a face is symbolic)
  are all runtime. Verified: chain.bend 12 transports (itrs 134–1121),
  fibre law present/retrieve/contraction, t_* — all correct on the net;
  a composite applied at a symbolic interval stays `#HCm{…}` and is decided
  when the interval is (partial knowledge). See RUNTIME_FULL.md (being written).
- Native DUP-SUP routing confirmed on HVM4: a match commutes over a
  superposition and same-label dups annihilate (probe: `@f(&L{#A,#B},&L{1,2})`
  → branches get 1 and 2). `supline.bend` is the Bend2 test for it (next).

## Done since: supline.bend (6✓; full runtime &0{0,1}, native routing) and
isprop_run.bend (5✓; 4-face composite decided at every corner) recorded in
RUNTIME_FULL.md; STATUS.md updated.

## Reconciled with parallel agents (latest)
Folded into the patch from other agents: epNormCtx recursing into coe
(fromPathP), interval idempotence (iSyntEq), and Glue (their parser was missing
on main — now in the patch; see GLUE.md). `forced.bend` 44✓, `fpp_fromPathP`
2✓, `glue.bend` 2✓ on the patch binary. The whole-file .hs copies in this
directory were deleted: cubical-paths.patch is the ONLY source of truth. If
you see loose .hs files here again, diff them against the patch-applied tree
and fold real deltas into the patch.

## Kan rules DONE in the checker (uaglue.bend, hcompset.bend; GLUE.md)
Transport through Glue and hcomp-in-Set-as-Glue are implemented and green.
Full runtime (--to-hvm4-full) now has the same Kan rules (@coeGlue, hcomp at
#Set -> #Glue, @transpEquiv); verified uaglue/hcompset on HVM4. Resolved: the
isprop_run residual-DUP issue (static dup labels; prelude linearized —
never `λ&` a value just because it is used in several match arms).

## The forcing theorem RUNS (forcing_run.bend, 82✓; FORCING.md RUN section)
Both instances (recording trace / contractible trace) observed on HVM4 full
runtime with values matching the normaliser.

## The coinductive calculus + braid fabric carried (interaction.bend, braid.bend; INTERACTION.md)
Two checker fixes went in with it (rewrite descends into application heads;
same-head conversion before unfolding recursive type families). Also merged
the SetQuotient HIT from a parallel agent (QUOTIENT.md) into the patch.

## Next steps (if continuing)
1. Exercise dependent Π/Σ lines and a path BETWEEN universe paths (a higher
   coherence of traces) on --to-hvm4-full; add to RUNTIME_FULL.md.
2. hcomp in Set beyond the composite shape (would need Glue-style rules).
3. Keep every claim tied to a run; keep pushing main.
