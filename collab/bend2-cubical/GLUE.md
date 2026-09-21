# Glue â” the type former for edge 1

Edge 1 was: `hcomp` in `Set` beyond the composite shape has no rule, because
CCHM handles composition in the universe via `Glue`. This adds `Glue` as a
sound type former.

## Added (in `cubical-paths.patch`)

- `Glue A [(Ï,T,e)]` â” the Glue type: `A : Set`, and on extent `Ï` a partial
  type `T : Set` with forward map `e : T â’ A`.
- `glue A [(Ï,t)] a` and `unglue g` â” the constructor and destructor.
- Parser (`Glue(A, [(Ï,T,e), â¦])`, `glue(A, x, [(Ï,t), â¦])`, `unglue(g)`),
  formation typing (infer), and all traversals (bind/deps/rewrite/equal/
  flatten/whnf/normal/dup).

## Reductions â” sound, and verified (`glue.bend`, 2â“ definitional)

- `Glue A [(i1, T, e), â¦] â‰¡ T` â” on a true face the Glue type IS the partial
  type. Checked: `Glue(A,[(i1,T,e)]) == T` by `finally`.
- `glue A [(i1, t), â¦] a â‰¡ t`   â” glue on a true face is the section.
- `unglue (glue A [(Ï,t)] a) â‰¡ a` â” unglue returns the base. Checked:
  `unglue(glue(A,x,[(i0,x)])) == x` by `finally`.
- False faces (`i0`) are dropped; otherwise the terms are stuck data.

These reductions do **not** consume `e` except at a true face (where Glue = T
and glue = t need no equivalence), so they cannot misuse a non-equivalence.

## Soundness check â” adversarial, and it FAILS as it must

`glue_mustfail.bend`: `Glue(Nat, [(i0, Bool, e)]) == Bool` by `finally` is
**rejected** (`â—`). A Glue at a *false* face does not collapse to its partial
type, so the boundary rule cannot be used to coerce `Nat` to `Bool`. No
soundness hole is opened. Full repo suite after this change: 267 â“, â— only in
the deliberate must-fails (`hfill`, `uaequiv_mustfail`, `uaroundtrip`,
`glue_mustfail`).

## Reconciliation

The parser for `Glue(...)/glue(...)/unglue(...)` had not reached `main` (the
committed whole-file `.hs` copies were from a divergent tree and lacked it, so
`glue.bend` parsed on no binary built from `main`). Glue is now integrated
into the single canonical source, `cubical-paths.patch`: Type constructors,
formation typing, all traversals (bind/deps/rewrite/equal/flatten/whnf/normal/
dup/analysis/totality/epNormCtx), the parser, and the emitters (erased targets:
Glue type erases, `glue` â’ its base after normalisation; `--to-hvm4-full`:
runtime `@glueT/@glue/@unglue` with the same boundary rules). Verified:
`glue.bend` 2â“, `glue_mustfail.bend` â— (must), full suite unchanged, and on the
full runtime `@glueT(#Nat,[(#I1,#Bool,e)]) â’ #Bool`, `@unglue(@glue(â¦,1)) â’ 1`.
The stale `.hs` copies were removed; the patch is the only source of truth.

## Kan rules (verified by execution)

Both rules are in `cubical-paths.patch`:

1. **Transport through Glue** (`whnfCoe`, `Glu` case): with `e : Equiv T A`
   coherent (Î f. âˆy. isContr(fiber f y), core `equivTy`), `coe` along a
   Glue line computes: unglue at `r` (on a true face, `fst(e)`), transport the
   base along the `A`-line, on each face live at `s` take `t1 = eâ»Â a1'` from
   the fibre's centre and correct `a1'` along the centre's path, glue back.
   `uaglue.bend` (26 â“): `uaG(e) = <i> Glue(B, [(inot i, A, e), (i, B, idEquiv B)])`
   and **`uaG_beta` is definitional for an abstract `e`**; the concrete `negE`
   (from `lemIso`) transports both ways.
2. **`hcomp` in `Set` = Glue** (`whnfHCm`): `hcomp(Set, [Ï â¦ u], A)` with
   live faces is `Glue A [Ï â¦ (u@i1, transpEquiv u)]`, `transpEquiv u` being
   the transport of the identity equivalence through `k â¦ Equiv(u@i1, u@inot k)`
   (pathToEquiv of the reversed tube, computed by `coe` through Î/Î /Path).
   `hcompset.bend` (10 â“): a 2-dimensional composition in `Set` with a face
   on a second interval variable `j` â” transport along it at symbolic `j`
   computes (`viaSq_T`), as do compositions with non-constant base lines.

The composite shape is recognised first (cheaper, same answer); every
other shape goes through Glue.

Must-fails: `glue_mustfail.bend` â” a Glue at a false face does not collapse
(`evil` â—), a bare function is not accepted as `e` (`notEquiv` â—), a glue
whose section is incoherent with its base is rejected (`incoherent` â—).

Implementation note: the transported base is evaluated strictly inside the
rule; left as an unevaluated `Coe` thunk it is re-read inside the
equivalence's own nested transports under the shared coe marker and yields a
wrong value (observed and fixed; `twist3` probe).
