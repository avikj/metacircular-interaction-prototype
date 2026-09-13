# General hcomp (CCHM cofibration systems) — the reverse-univalence unblock

The prior cubical Bend2 had only a binary-face `hcomp(A,r,u0,u1,base)`, which
cannot express a composition whose faces lie on two independent interval
variables. That blocked `isPropIsContr` (contractibility is a proposition),
and therefore the reverse univalence round trip / coherent equivalences —
CORRECTIONS.md correctly listed these as open. They are no longer blocked on a
missing former.

## What was added

A general cofibration-system composition:

    hcompN(A, [(face, tube), ...], base)

- `face` is an interval formula (`i`, `inot(i)`, …); `tube` a k-line in `A`;
  `base` the cap at k=i0.
- **Reduction** (WHNF and epNormCtx): a satisfied face yields that tube's top;
  an all-false system yields the cap; otherwise neutral.
- **Checker**: each tube's k=i0 end agrees with the base under its own face
  (mirrors the binary side conditions), and tubes agree pairwise where faces on
  distinct variables overlap — so the reduction is order-independent (sound).
- The load-bearing fix: `epNormCtx` (the context-aware endpoint normalizer) now
  reduces `hcompN` on satisfied faces, so a 4-face boundary like `p(w)@i1`
  endpoint-reduces to `w`. Without it the system reduces but its boundaries
  don't normalize and the proof won't close.

## Validated (GHC 9.12.2 / cabal 3.18, rebuilt and rerun in-environment)

- **`isprop.bend` — `isPropIsContr` CHECKS GREEN.** Contractibility is a
  proposition, proved with the exact 4-face system the binary `hcomp` could not
  express. This is the lemma the reverse univalence round trip needs.
- **`equiv.bend`** — the coherent-equivalence foundation
  (`isContr`/`fiber`/`isEquiv`/`Equiv`/`isContrSingl`/`idEquiv`) — green.
- **No regression**: cubical suites green, stock examples 39/39, and native
  cubical transport (`applyPath`/`sup_transport --to-hvm4`) still faithful.

## What remains (now ordinary library work, not a missing primitive)

Assemble `isPropIsEquiv` (from `isPropIsContr` + `isProp` of a Π) and the
reverse round trip `pathToEquiv(ua e) = e`. These are proofs on top of the
primitive now present, not a blocked type former.
