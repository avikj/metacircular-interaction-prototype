# Glue — the type former for edge 1 (partial progress, stated exactly)

Edge 1 was: `hcomp` in `Set` beyond the composite shape has no rule, because
CCHM handles composition in the universe via `Glue`. This adds `Glue` as a
sound type former. It does **not** yet close edge 1 — see "What this does NOT
do" below. Nothing here is faked past the soundness frontier.

## Added (in `cubical-paths.patch`)

- `Glue A [(φ,T,e)]` — the Glue type: `A : Set`, and on extent `φ` a partial
  type `T : Set` with forward map `e : T → A`.
- `glue A [(φ,t)] a` and `unglue g` — the constructor and destructor.
- Parser (`Glue(A, [(φ,T,e), …])`, `glue(A, x, [(φ,t), …])`, `unglue(g)`),
  formation typing (infer), and all traversals (bind/deps/rewrite/equal/
  flatten/whnf/normal/dup).

## Reductions — sound, and verified (`glue.bend`, 2✓ definitional)

- `Glue A [(i1, T, e), …] ≡ T` — on a true face the Glue type IS the partial
  type. Checked: `Glue(A,[(i1,T,e)]) == T` by `finally`.
- `glue A [(i1, t), …] a ≡ t`   — glue on a true face is the section.
- `unglue (glue A [(φ,t)] a) ≡ a` — unglue returns the base. Checked:
  `unglue(glue(A,x,[(i0,x)])) == x` by `finally`.
- False faces (`i0`) are dropped; otherwise the terms are stuck data.

These reductions do **not** consume `e` except at a true face (where Glue = T
and glue = t need no equivalence), so they cannot misuse a non-equivalence.

## Soundness check — adversarial, and it FAILS as it must

`glue_mustfail.bend`: `Glue(Nat, [(i0, Bool, e)]) == Bool` by `finally` is
**rejected** (`✗`). A Glue at a *false* face does not collapse to its partial
type, so the boundary rule cannot be used to coerce `Nat` to `Bool`. No
soundness hole is opened. Full repo suite after this change: 267 ✓, ✗ only in
the deliberate must-fails (`hfill`, `uaequiv_mustfail`, `uaroundtrip`,
`glue_mustfail`).

## What this does NOT do (edge 1 is NOT closed)

The two Kan reductions that would make `Glue` actually *compute* transport —
and thus close edge 1 — are deliberately **not** implemented, because each is
soundness-critical and a wrong version silently makes the logic inconsistent:

1. **`coe` through `Glue`** (transp-Glue): transporting a value across a
   `Glue` type. This is the CCHM equation that *uses* `e` as a genuine
   equivalence (its `isContr`-fibre data), off the faces. Implementing it
   correctly requires the equivalence's inverse and the fibre contraction,
   composed under `hcomp`. Left stuck.
2. **`hcomp` in `Set` → `Glue`**: the rule `hcomp^i Set [φ↦T] A =
   Glue A [φ ↦ (T i1, transp-equiv)]` that would make composition in the
   universe reduce to a Glue. The `transp-equiv` it builds is exactly the
   contractible-fibre equivalence from a line of types; wiring it soundly
   depends on (1). Left stuck.

So: `Glue` now **exists** as a sound type former with checked definitional
boundary laws, which is real progress — the object edge 1 needs is present and
its non-Kan laws hold and are verified. But transport *through* Glue, the part
that makes `hcomp`-in-`Set` and univalence-by-Glue compute, remains the honest
open frontier, together with edge 2 (symbolic-endpoint `transp`/`comp`). Both
are the same missing primitive: `comp` (heterogeneous composition), whose Glue
instance is (1). That is where the next work is, and it is genuinely the
soundness-critical core of CCHM — not a printer change.

## Reconciliation (later session)

The parser for `Glue(...)/glue(...)/unglue(...)` had not reached `main` (the
committed whole-file `.hs` copies were from a divergent tree and lacked it, so
`glue.bend` parsed on no binary built from `main`). Glue is now integrated
into the single canonical source, `cubical-paths.patch`: Type constructors,
formation typing, all traversals (bind/deps/rewrite/equal/flatten/whnf/normal/
dup/analysis/totality/epNormCtx), the parser, and the emitters (erased targets:
Glue type erases, `glue` → its base after normalisation; `--to-hvm4-full`:
runtime `@glueT/@glue/@unglue` with the same boundary rules). Verified:
`glue.bend` 2✓, `glue_mustfail.bend` ✗ (must), full suite unchanged, and on the
full runtime `@glueT(#Nat,[(#I1,#Bool,e)]) ⇒ #Bool`, `@unglue(@glue(…,1)) ⇒ 1`.
Kan rules for Glue remain unimplemented, as stated above. The stale `.hs`
copies were removed; the patch is the only source of truth.

## Kan rules — IMPLEMENTED (later session; verified by execution)

Both rules the previous section left open are now in `cubical-paths.patch`:

1. **Transport through Glue** (`whnfCoe`, `Glu` case): with `e : Equiv T A`
   coherent (Σ f. ∀y. isContr(fiber f y), core `equivTy`), `coe` along a
   Glue line computes: unglue at `r` (on a true face, `fst(e)`), transport the
   base along the `A`-line, on each face live at `s` take `t1 = e⁻¹ a1'` from
   the fibre's centre and correct `a1'` along the centre's path, glue back.
   `uaglue.bend` (26 ✓): `uaG(e) = <i> Glue(B, [(inot i, A, e), (i, B, idEquiv B)])`
   and **`uaG_beta` is definitional for an abstract `e`**; the concrete `negE`
   (from `lemIso`) transports both ways.
2. **`hcomp` in `Set` = Glue** (`whnfHCm`): `hcomp(Set, [φ ↦ u], A)` with
   live faces is `Glue A [φ ↦ (u@i1, transpEquiv u)]`, `transpEquiv u` being
   the transport of the identity equivalence through `k ↦ Equiv(u@i1, u@inot k)`
   (pathToEquiv of the reversed tube, computed by `coe` through Σ/Π/Path).
   `hcompset.bend` (10 ✓): a 2-dimensional composition in `Set` with a face
   on a second interval variable `j` — transport along it at symbolic `j`
   computes (`viaSq_T`), as do compositions with non-constant base lines.

The composite shape is still recognised first (cheaper, same answer); every
other shape now goes through Glue instead of being stuck.

Must-fails: `glue_mustfail.bend` — a Glue at a false face does not collapse
(`evil` ✗), a bare function is not accepted as `e` (`notEquiv` ✗), a glue
whose section is incoherent with its base is rejected (`incoherent` ✗).

Implementation note: the transported base is evaluated strictly inside the
rule; left as an unevaluated `Coe` thunk it is re-read inside the
equivalence's own nested transports under the shared coe marker and yields a
wrong value (observed and fixed; `twist3` probe).
