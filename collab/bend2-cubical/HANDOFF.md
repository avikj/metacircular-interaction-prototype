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

## Immediate next steps
1. Run `supline.bend` and `isprop_run.bend` on `--to-hvm4-full`; record.
2. Write RUNTIME_FULL.md (table of what is runtime now, numbers), update
   STATUS.md / README.md; note that `--to-hvm4`/`raw` remain as the erased
   comparison points.
3. Not yet runtime in full mode: general hcomp in Set beyond the composite
   shape (stays stuck data), dependent Π/Σ are handled by @coe generically
   (untested), higher paths between universe paths.
