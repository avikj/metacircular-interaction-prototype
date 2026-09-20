# A cubical core for the official Bend 2

This directory gives the **official public Bend 2** (bendlang/bend, `2.0.21`,
commit `6018e28`) a cubical core: paths, transport, composition, Glue and
univalence, higher inductive types, and transport that *runs* on the
compiled C and JavaScript lanes. It ports the mathematics of
`collab/bend2-cubical` (built on the HVM3 interaction-net fork) onto a
different language implementation: a TypeScript checker (`bend2/bend.ts`,
one linear bidirectional pass, an affine dependent theory with a dead/live
wall), a C/Metal/CUDA/JS compiler (`bend2/comp.ts`) and a Lean spec.
Nothing is copied over: the equality primitive of the official language
(`{a == b : T}`, `{==}`, `%e : P; f`) is *re-read* as a path type, the Kan
operations are term forms with type-directed reduction in the style of the
checker they extend, and the runtime side is a compile-time elaboration
pass, not a new machine.

`cubical.patch` is the whole change against upstream `6018e28`
(`bend2/bend.ts`, `bend2/comp.ts`, `bend2/base.bend`). `tests/cubical/*.bend`
are the tests, in upstream's own format (a file ends in the `#|` lines its
run must print). `run.sh` clones upstream at the pinned commit, applies the
patch, runs the cubical tests (the `compiled_*` ones on the JS lane, and on
the C lane when clang is present), then upstream's interpreter-lane suite.

## The language

| form | meaning | rule |
| --- | --- | --- |
| `Interval`, `i0`, `i1` | the interval and its ends | `Interval : Data`; a dimension is always dead (never runs) |
| `-r`, `r /\ s`, `r \/ s` | De Morgan negation, meet, join | constants fold; two interval terms are convertible iff they agree on every assignment of their atoms |
| `{a == b : T}` | a path type | unchanged syntax, `Data` kind (evidence is erased) |
| `{a == b : i => T(i)}` | a dependent path (PathP) | the carrier is a line `Interval -> Type`; `a : T(i0)`, `b : T(i1)` |
| `i => t` at a path type | path abstraction | `t : T(i)` with `i : +Interval`; the faces `t[i0] ≡ a`, `t[i1] ≡ b` by conversion |
| `p(r)` | path application | `p : {a == b : T}`, `r : Interval` dead, result `T(r)`; `p(i0) ≡ a`, `p(i1) ≡ b` |
| `{==}` | the constant path | unchanged (`a ≡ b`); convertible with any constant path lambda |
| `%e : P; f` | J | unchanged typing; **computes on every path**: `%e : P; f ↦ coe(i => P(e(i), j => e(i /\ j)), i0, i1, f)` when `e` is a non-constant path |
| `coe(L, r, s, x)` | transport | `L` a line `i => T` at `Interval -> Type`, or a path inferred at `{A == B : Type}`; `x : L(r)`; result `L(s)` |
| `hcomp(A, x, [(r == i0, ..) i => u, ..])` | homogeneous composition | tubes on faces, agreeing with `x` at `i0` and with each other where faces meet |
| `Glue(A, [(r == i0, ..) (T, e), ..])` | the Glue type | `e : Equiv(T, A)` on its face, checked live |
| `glue(x, [(f) t, ..])`, `unglue(g)` | its constructor and destructor | `Equiv.fun(e)(t) ≡ x` on each face |
| `ua(A, B, e)` | univalence (Base) | `i => Glue(B, [(i == i0) (A, e), (i == i1) (B, Equiv.id(B))])` |
| `type K .. : c{..}; path c'{fields}: {a == b : K<..>}` | a higher inductive type | a constructor whose tip is a path type into the family, of any dimension |

### Base additions

`isContr`, `fiber`, `isEquiv`, `Equiv` (contractible fibres, the coherent
formulation), `Equiv.id`, `Equiv.fun`, `Equiv.inv`, `Equiv.sec`,
`Equiv.from_iso` (Cubical Agda's `isoToIsEquiv`, `lemIso` transcribed with
`hfill` inlined as `hcomp` with the extra face) and `ua`. The Kan rules
project an equivalence through Base's own `Equiv.fun`/`inv`/`sec`, so a
stuck projection of a variable equivalence is the term the user writes.

### Reduction

- **Endpoints.** A checked def unfolds to its elaborated tree (`Def.w`,
  built by `def_body`, which lowers the annotation cells at their depth and
  re-binds them; a template is closed over its `~` binders), so `term_wnf`
  reads a stuck path's endpoints off its annotation when it is applied to
  `i0`/`i1`; a bound path variable reads them off the context of the check
  in progress (`WNF_CTX`); a raw spine headed by a variable or reference
  goes through `term_pend`. A path constructor applied to an endpoint is
  its declared face (`ctr_face`).
- **coe** by the shape of the line's body at a fresh dimension: identity on
  constants, kinds, `Interval`, path types with erased content; functions
  contravariantly; constructors fieldwise along dependent field lines
  (every ADT of the book, no per-type code); a path constructor applied to
  dimensions fieldwise with the dimensions kept; an hcomp cell of a family
  commutes; a line of path types reparametrizes to `i0..i1` and composes in
  the carrier; **Glue** is CCHM transport (unglue at `r`, transport the base,
  invert through the contractible fibre on each face live at `s`, correct
  along the fibre's path, glue back).
- **hcomp**: a face that holds is the tube at `i1`; functions pointwise;
  paths in the carrier with the endpoints as faces; constructors fieldwise
  when every tube is that constructor; **in `Type`** a Glue over the base
  with the transport equivalence of each tube; **at a Glue** inside each
  partial type and in the base with the fillers' images as extra faces.
- **HIT eliminators**: a `match` needs an arm per constructor, path ones
  included; a path arm lands in the path over the motive between the
  eliminator's values at the constructor's endpoints (nested by dimension;
  the eliminator's value is the definition's own application where the
  match does not compute, so recursive arms line up); the match on a path
  constructor applied to dimensions is the arm at the fields then the
  dimensions; the match on an hcomp cell composes along the motive over the
  filler with the tubes eliminated.

### The wall, kept

Bend's consistency is the dead/live wall: dead code (types, erased
arguments, equation endpoints) may diverge or inhabit `Empty`, and nothing
dead ever counts as live evidence. The cubical core draws the line where the
official checker draws it for `%e : P; f` (its equation is live):

- a path lambda's body, a `coe` line or path, `hcomp`'s tubes, `glue`'s
  sections and the equivalences inside a `Glue` are checked at the ambient
  demand: a path built in live code is live evidence, and an erased
  hypothesis cannot transport a live value (`must_fail_dead_coe`);
- dimensions, faces, the carrier types and the Glue base are dead.

Consequences: a value of an abstract type used twice in a filler needs its
type to be `Data` (`+y`), a path used twice is `+p` (paths are `Data`), and
a function used twice is a template parameter (`~f`: a template is a
theorem, a closure is affine). `Equiv.from_iso` and the fibre law are
written that way.

### Runtime

The compiler erases types, so before emission `term_uncoe` runs every Kan
node of a checked tree to ordinary code: `coe_step` with the value symbolic
handles functions, kinds, Glue (`ua`: the equivalence's function forward,
its inverse backward, through Base's own defs) and lines of path types; a
datatype line with a symbolic value becomes a *minted transport def*
(`coe~n`), a lambda-match pushing the transport into every constructor's
fields, recursive lines reaching the def itself (a `List<ua(e)(i)>` line
mints exactly `List.map` of `e`); an `hcomp`, `glue` or `unglue` with
decided faces is its value there; a rewrite along a path is J as transport.
`term_unpath` then erases path lambdas and path constructors at path types
and resolves path applications at literal endpoints. What no runtime value
carries is a transport along a *variable* path in `Type`, and the compiler
refuses it by name.

## Verification

- `funext`, `coe`, `j`, `hcomp`, `must_fail_face`, `must_fail_dead_coe`:
  paths, transport by shape, J on non-constant paths, hand-written fillers,
  the face check and the wall.
- `ua`: `ua` of the identity is the identity by computation, both ways; the
  faces of `ua` are its types; **ua-beta is definitional for an abstract
  equivalence**: `coe(ua(A, B, e), i0, i1, x) ≡ Equiv.fun(A, B, e)(x)`.
- `fibre`: the fibre law `A ≃ &b:B -> fiber f b` for every `f` over `Data`
  carriers, as a coherent equivalence through `Equiv.from_iso`, then
  `losslessPath = ua(totalEquiv f)`; `present = coe(losslessPath, i0, i1)`
  **is the factoring `a => (f(a), a, {==})` definitionally**, and
  `retrieve` after `present` is the identity; run at `f = not`.
- `hit_circle`, `hit_quot`, `hit_trunc`, `hit_mustfail_loop`: the circle
  (faces of `loop`, eliminators, a loop-dependent one), a set quotient with
  parameters (faces mention the fields, the recursor on `eq` is the arm
  definitionally), propositional truncation (a recursive path constructor,
  the recursor into a proposition by its recursive results, the eliminator
  on an hcomp cell with a symbolic face); `loop` is not `{==}`.
- `compiled`, `compiled_coe`: on the C and JS lanes, a funext-transported
  function runs; transport along `List<ua(not)(i)>` flips every element and
  along a function line wraps the function. The fibre law's instance
  (`present`, `retrieve` at `not`) runs on both lanes too
  (`False True True False`).
- Upstream's interpreter-lane suite (931 files): every file the unpatched
  checker passes still passes (927), except `proof/no_funext_000`, which
  asserts that funext is *unprovable* and now fails as intended; upstream's
  pinned parse errors (`~`, `!`, a `:` after a constructor) are untouched,
  which is why negation is `-r` and a path constructor is introduced by
  `path`.

## What is left

- **Runtime**: a transport along a variable path in `Type` (the path's
  runtime content would be its transport pair); an `hcomp`/`glue` whose
  face is a dimension variable in live code (they arise only under erased
  binders, so this is a diagnostic today).
- **HITs**: two-dimensional path constructors typecheck by the same rule
  but have no test yet; `coe` along a HIT line whose parameters move is the
  fieldwise rule (tested through `Quot`'s shapes only indirectly).
- **Coinduction**: the official Bend is strict and demands descent, so a
  coinductive record (the corpus's `Answers`, `IExec`) needs guarded
  corecursion and lazy fields, which are a runtime change, not a checker
  rule; the fibre law that is the corpus's "lossless inference" is here,
  and applies to those records once they exist.
- The Lean spec (`bend.lean`) does not model the new forms.
