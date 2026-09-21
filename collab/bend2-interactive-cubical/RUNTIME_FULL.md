# `--to-hvm4-full` â” the cubical calculus as a runtime, nothing erased

The README's machine is the fabric of paths: a trace *is* a path, traces
compose, invert and carry higher coherences, and knowledge is partial. So the
compiled program must keep every cubical object alive at runtime. This target
does. `Target/HVM4Full.hs` (in `cubical-paths.patch`) emits Bend2 terms with
**no erasure and no compile-time normalisation**; the prelude is
`Core.WHNF`'s cubical reduction rewritten as an HVM4 program.

| object | runtime representation |
|---|---|
| interval | data: `#I0`, `#I1`, symbolic `#INot{i}`, `#IAnd{i,j}`, `#IOr{i,j}` (`@inot/@iand/@ior` evaluate when they can) |
| value path `<i> t` | data `#PLm{Î»i. t}`; `p @ r` is `@pathAt(p, r)` |
| universe path | data `#UaU{A,B,f,g}`, `#CompU{P,Q}` (`hcomp` in `Set`), endpoints by `@pL/@pR`, symbolic application `#At{p,i}` |
| type | data: `#Bool`, `#Nat`, `#Set`, `#Pi{A,B}`, `#Sig{A,B}`, `#Path{A,u,v}`, â¦ |
| `coe(L, r, s, x)` | `@coe`: if `r`,`s` agree â’ `x`; else evaluate `L(#IMark)` and **dispatch on the type former at runtime**: rigid â’ `x`; `#Pi` â’ conjugate domain/codomain lines; `#Sig` â’ componentwise along the filled first component; `#Path` â’ the hcomp-conjugation square; `#At{p,i}` â’ `@coeU` on the universe path (`ua` â’ `f`/`g`; composite â’ sequential) |
| `hcompN(A, faces, base)` | `@hcomp`: evaluates each face; a true face returns its tube's top; all-false returns the base; **otherwise it is stuck data `#HCm{A, faces, base}`** â” partial knowledge, decided when a later application fixes the interval |
| superposed line `&L{A i, B i}` | **no rule**: the `@coe` dispatch is a match, HVM4 commutes a match over a superposition, and the same-label dup of the transported value annihilates â” the fibre routing (DUP-SUP) is the net's own interaction |

## Verified on the full runtime (HVM4, `-C10`)

All values agree with the checker's normaliser (`bend f.bend`) and with the
erased targets; interactions are now the cost of the *runtime* dispatch.

| program | result | itrs |
|---|---|---|
| `t_fwd_neg / t_bwd_neg / t_fwd_id / t_bwd_id` | 0 / 0 / 1 / 1 | 123 / 126 / 44 / 45 |
| `chain.bend` `viaNegNeg True/False` (composite) | 1 / 0 | 537 / 539 |
| `viaNeg3`, `viaNeg3Bwd` (three equivalences) | 0/1, 0/1 | 1096â“1121 |
| `viaInv` (inverse line) | 0 / 1 | 140 / 134 |
| `viaPi` (Î  line) / `viaSig` (Î line) | 0/1 / 0/1 | 282/273 / 275/265 |
| `fibrelaw.bend` `presentNeg True/False` | 0 / 1 | 207 / 196 |
| `retrieveNeg True/False` (`coe` back along `uaE(totalEquiv)`) | 1 / 0 | 409 / 409 |
| `contrNeg0 / contrNeg1` â” the fibre-contraction path (`lemIso`'s 4-face `hcompN`s run on the net) | 0 / 0 | 223 / 191 |
| `supline.bend` â” `coe` along `&0{negPath@i, Bool}` of `&0{True,True}` | `&0{0,1}` = `&0{False,True}` | 195 |
| `isprop_run.bend` â” `isPropIsContr`'s 4-face composite at `(i1,i0)` and every other corner | `()` | 168 |

Partial knowledge, observed: `pcompH(...) @ #IVar{0}` on the net is
`#HCm{#Nat, #Cons{#Face{#IVar{0}, â¦}, #Cons{#Face{#INot{#IVar{0}}, â¦}}}, #Zer}` â”
a stuck composition carrying its faces; the same term at `#I0` is `#Zer`, at
`#I1` the tube's top. The face is decided by whoever later supplies the interval.

## Comparison points kept

`--to-hvm4` (normalise-then-erase), `--to-hvm4-raw` (erase, strict, universe
paths as Church pairs) and `--to-hvm` (HVM3) remain, so the cost of erasure vs
runtime can be read side by side (e.g. `viaNeg3`: 31 itrs erased, 1106 full).

## Kan rules on the runtime (later session)

`@coe` on a `#Glue{A, faces}` line (`@coeGlue`) and `@hcomp` at `#Set`
(`#Glue` over the base with `@transpEquiv` of each tube â” pathToEquiv computed
by the runtime `@coe` through Î/Î /Path type data) mirror the checker's rules.
Faces are read off the line at the marker and instantiated at `r`/`s` by
interval substitution (`@substI`), since re-evaluating the line at a literal
endpoint lets a true face collapse the Glue to its partial type. Verified:

| program | result | itrs |
|---|---|---|
| `uaglue.bend` `viaGlue True/False` (ua derived from Glue) | 0 / 1 | 797 / 789 |
| `viaGlueBwd True/False` | 0 / 1 | 811 / 802 |
| `hcompset.bend` `viaSq(i0)` (2-dim universe composition; equivalence computed on the net) | 0 | 1935 |
| `viaSq(i1)` | 0 | 147 |
| `viaTwist True/False` (non-constant base line) | 1 / 0 | 587 / 589 |
| whole earlier matrix (chain, fibre law, contraction, superposed line) | unchanged | â” |

A glue value with no live faces is its base; a Glue type keeps its faces
(types are consumed only by `@coe`). Binders now get globally unique names.

## Set-quotient recursor on the full runtime (added)

`Quo`/`QCl`/`QEq`/`QSq`/`QRec` now emit to `--to-hvm4-full`: `@qrec` computes
`qrec([a]) â’ f a` and `qrec(eq/ a b w @ i) â’ resp a b w @ i` (with `@pathAt`
giving `eq/ @ i0 = [a]`, `@ i1 = [b]`), commuting over `Sup` natively. Verified:
`qrec(qcl 3n, dbl) â’ 6`, `qrec(qeq(2n,2n,refl)@i0, dbl) â’ 4`; `minmachine`,
`quotient`, `nerode_effective_closed` all emit and run. Previously the full-runtime
emitter threw on the quotient constructors; the whole suite now emits with no
crashes.

## Not runtime yet / caveats

- `coe` to a *symbolic* endpoint stays stuck (`@dir` = 2); the runtime
  `pathToEquiv` therefore carries stuck proof components, but the function
  and the fibre centre (inverse) compute, which is what transport needs.
- (resolved) `isprop_run.bend` left residual DUP nodes at three corners. Cause:
  HVM4 auto-dup labels are static per binder, so `@pathAt`'s `Î»&p` (cloned
  only because `p` was used in three match *arms*) duplicated an argument
  that already contained another `@pathAt` instance's dup with the same
  label. Fix: prelude functions never clone a value merely for use in
  different arms (match first, bind per arm). Now `#One` at all four corners
  (104â“157 itrs).
- Dependent Î /Î lines go through the generic `@coe`. Over a varying base the
  family receives a transport **to a symbolic endpoint** (`coe râ’i`), which
  this prelude leaves stuck (`#StuckCoe`); a family that does not inspect it
  still computes (probe: `Î b:(negPath@i). Nat` transports `(True, 3n)` to
  `3n` on the net), one that does would need `transp` with a symbolic
  endpoint (Glue-style `unglue`). Note the checker rejects that probe's
  well-typedness anyway (`b : negPath@i` is not `Bool`), correctly.
- Traces are inspectable data: `@main = @negNeg` prints
  `#CompU{Î»i. â¦#At{#UaU{#Bool,#Bool,neg,neg}, i}â¦, Î»i. â¦}` â” the composite
  path itself, faces and all. Paths between universe paths are `#PLm` over
  these; representable, not yet exercised beyond `refl`.
