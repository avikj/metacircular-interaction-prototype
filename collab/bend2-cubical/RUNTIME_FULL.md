# `--to-hvm4-full` — the cubical calculus as a runtime, nothing erased

The README's machine is the fabric of paths: a trace *is* a path, traces
compose, invert and carry higher coherences, and knowledge is partial. So the
compiled program must keep every cubical object alive at runtime. This target
does. `Target/HVM4Full.hs` (in `cubical-paths.patch`) emits Bend2 terms with
**no erasure and no compile-time normalisation**; the prelude is
`Core.WHNF`'s cubical reduction rewritten as an HVM4 program.

| object | runtime representation |
|---|---|
| interval | data: `#I0`, `#I1`, symbolic `#INot{i}`, `#IAnd{i,j}`, `#IOr{i,j}` (`@inot/@iand/@ior` evaluate when they can) |
| value path `<i> t` | data `#PLm{λi. t}`; `p @ r` is `@pathAt(p, r)` |
| universe path | data `#UaU{A,B,f,g}`, `#CompU{P,Q}` (`hcomp` in `Set`), endpoints by `@pL/@pR`, symbolic application `#At{p,i}` |
| type | data: `#Bool`, `#Nat`, `#Set`, `#Pi{A,B}`, `#Sig{A,B}`, `#Path{A,u,v}`, … |
| `coe(L, r, s, x)` | `@coe`: if `r`,`s` agree → `x`; else evaluate `L(#IMark)` and **dispatch on the type former at runtime**: rigid → `x`; `#Pi` → conjugate domain/codomain lines; `#Sig` → componentwise along the filled first component; `#Path` → the hcomp-conjugation square; `#At{p,i}` → `@coeU` on the universe path (`ua` → `f`/`g`; composite → sequential) |
| `hcompN(A, faces, base)` | `@hcomp`: evaluates each face; a true face returns its tube's top; all-false returns the base; **otherwise it is stuck data `#HCm{A, faces, base}`** — partial knowledge, decided when a later application fixes the interval |
| superposed line `&L{A i, B i}` | **no rule**: the `@coe` dispatch is a match, HVM4 commutes a match over a superposition, and the same-label dup of the transported value annihilates — the fibre routing (DUP-SUP) is the net's own interaction |

## Verified on the full runtime (HVM4, `-C10`)

All values agree with the checker's normaliser (`bend f.bend`) and with the
erased targets; interactions are now the cost of the *runtime* dispatch.

| program | result | itrs |
|---|---|---|
| `t_fwd_neg / t_bwd_neg / t_fwd_id / t_bwd_id` | 0 / 0 / 1 / 1 | 123 / 126 / 44 / 45 |
| `chain.bend` `viaNegNeg True/False` (composite) | 1 / 0 | 537 / 539 |
| `viaNeg3`, `viaNeg3Bwd` (three equivalences) | 0/1, 0/1 | 1096–1121 |
| `viaInv` (inverse line) | 0 / 1 | 140 / 134 |
| `viaPi` (Π line) / `viaSig` (Σ line) | 0/1 / 0/1 | 282/273 / 275/265 |
| `fibrelaw.bend` `presentNeg True/False` | 0 / 1 | 207 / 196 |
| `retrieveNeg True/False` (`coe` back along `uaE(totalEquiv)`) | 1 / 0 | 409 / 409 |
| `contrNeg0 / contrNeg1` — the fibre-contraction path (`lemIso`'s 4-face `hcompN`s run on the net) | 0 / 0 | 223 / 191 |
| `supline.bend` — `coe` along `&0{negPath@i, Bool}` of `&0{True,True}` | `&0{0,1}` = `&0{False,True}` | 195 |
| `isprop_run.bend` — `isPropIsContr`'s 4-face composite at `(i1,i0)` and every other corner | `()` | 168 |

Partial knowledge, observed: `pcompH(...) @ #IVar{0}` on the net is
`#HCm{#Nat, #Cons{#Face{#IVar{0}, …}, #Cons{#Face{#INot{#IVar{0}}, …}}}, #Zer}` —
a stuck composition carrying its faces; the same term at `#I0` is `#Zer`, at
`#I1` the tube's top. The face is decided by whoever later supplies the interval.

## Comparison points kept

`--to-hvm4` (normalise-then-erase), `--to-hvm4-raw` (erase, strict, universe
paths as Church pairs) and `--to-hvm` (HVM3) remain, so the cost of erasure vs
runtime can be read side by side (e.g. `viaNeg3`: 31 itrs erased, 1106 full).

## Not runtime yet / caveats

- `hcomp` in `Set` outside the composite shape stays stuck data (no `Glue`).
- Dependent Π/Σ lines go through the generic `@coe` (correct by construction
  of the rule, exercised only non-dependently so far).
- Paths between universe paths (higher coherences of traces) are ordinary
  `#PLm` data over `#UaU/#CompU` — representable, not yet exercised.
