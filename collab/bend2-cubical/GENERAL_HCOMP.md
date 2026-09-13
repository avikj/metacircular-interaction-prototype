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

## Unified constructor (merged from the parallel implementation)

The two general-hcomp implementations were merged into ONE constructor:
`HCm A [(φ, u)] base`. The binary `hcomp(A, r, u0, u1, base)` is parser
sugar for faces `[(inot(r), u0), (r, u1)]`; `hcompN(A, [(φ,u),..], base)`
is the general form. Differences from the first `HCmN` version:

- **Faces are arbitrary interval formulas** (`iand`/`ior`/`inot`), not just
  literals. A face φ is put in DNF; the tube's `k=i0` boundary is checked
  on **every cell**; adjacency is checked on every cell of `φ ∧ ψ`
  (`hcompfaces.bend`: `ior(i, j)` face, three cells, checks).
- **Adjacency endpoint-normalises** both restricted tubes (`epNormCtx`)
  before conversion — without this `p0(x)@i0` and `p0(a1)@i0` do not meet
  at `a0`, and `isPropIsContr` fails. With it, `isprop.bend` is green on
  the unified constructor.
- Reduction: any face ⇓ `i1` yields that tube's cap (WHNF and epNormCtx).
- `Pth` transport in `whnfCoe` and `dup`/`normal`/emitters use the same
  constructor; no second representation.

Verified (this session): `isprop.bend` 3✓, `hcompfaces.bend` 4✓, all prior
files unchanged (39/11/10/12/8/7/9/11/2/3/2/7 ✓, 0 ✗), `uaRoundTrip` still
correctly fails at the raw-Iso level.

## Reverse univalence round trip — CLOSED (`uaequiv.bend`, 17✓ 0✗)

`uaEquivRoundTrip : Path(Equiv(A,B), pathToEquiv(A,B, uaE(A,B,e)), e)` checks,
at the coherent (contractible-fibre) level, for an arbitrary `e : Equiv(A,B)`.

Proof shape: `<i> (f, isPropIsEquiv(A,B,f, sndE(pathToEquiv(uaE(f,h))), h) @ i)`.
The first component is `f` on the nose (uaβ + regularity on the constant
`A`-line, then λ-η: the transported function is `λx. f(x)`); the second is the
prop-filler on `isEquiv` (`isPropIsEquiv` = pointwise `isPropIsContr`, the
4-face `hcompN`).

Two checker gaps had to close for it:

- **Ref-headed endpoints** (`spineType`, `Ref` case — same hunk as
  REF_ENDPOINTS.md): `isPropIsContr(_,h0 y,h1 y) @ i0 ≡ h0 y`.
- **`epNormCtx` traverses `SigM`** (`~x{(,):f}`), so the endpoint of
  `match contr((x,<_>f x)) @ i0 {(z,_): z}` reduces through the match to
  `match cen {(z,_): z}` and meets `invC(...)(cen,contr)` — this is `retC`,
  the retraction read off the contractible fibre.

`uaE` builds the path from the coherent data via `invC/secC/retC` (the
inverse, section and retraction extracted from `isContr(fiber f y)`), so no
raw `Iso` is assumed; `uaroundtrip.bend`'s raw-Iso reverse trip still ✗, as
it must.

Note: `equiv.bend` carries a *probe* `isPropIsContr` written with the binary
`hcomp` (its comment says so); it ✗ by design — the proof is `isprop.bend`.
