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
| `{a == b : T}` | a path type | unchanged syntax, `Data` kind (evidence is erased); a path in a universe is `Type` (its runtime is an equivalence, affine) |
| `{a == b : i => T(i)}` | a dependent path (PathP) | the carrier is a line `Interval -> Type`; `a : T(i0)`, `b : T(i1)` |
| `i => t` at a path type | path abstraction | `t : T(i)` with `i : +Interval`; the faces `t[i0] ≡ a`, `t[i1] ≡ b` by conversion |
| `p(r)` | path application | `p : {a == b : T}`, `r : Interval` dead, result `T(r)`; `p(i0) ≡ a`, `p(i1) ≡ b` |
| `{==}` | the constant path | unchanged (`a ≡ b`); convertible with any constant path lambda |
| `%e : P; f` | J | unchanged typing; **computes on every path**: `%e : P; f ↦ coe(i => P(e(i), j => e(i /\ j)), i0, i1, f)` when `e` is a non-constant path |
| `coe(L, r, s, x)` | transport | `L` a line `i => T` at `Interval -> Type`, or a path inferred at `{A == B : Type}`; `x : L(r)`; result `L(s)` |
| `hcomp(A, x, [(r == i0, ..) i => u, ..])` | homogeneous composition | tubes on faces, agreeing with `x` at `i0` and with each other where faces meet |
| `Glue(A, [(r == i0, ..) (T, e), ..])` | the Glue type | `e : Equiv(q, q, T, A)` on its face, checked live; the Glue has its base's kind `Kind(q)` |
| `glue(x, [(f) t, ..])`, `unglue(g)` | its constructor and destructor | `Equiv.fun(e)(t) ≡ x` on each face |
| `ua(q, A, B, e)` | univalence (Base) | `i => Glue(B, [(i == i0) (A, e), (i == i1) (B, Equiv.id(q, B))])`, a path in `Kind(q)` |
| `type K .. : c{..}; path c'{fields}: {a == b : K<..>}` | a higher inductive type | a constructor whose tip is a path type into the family, of any dimension |

### Base additions

`isContr`, `fiber`, `isEquiv`, `Equiv` (contractible fibres, the coherent
formulation; a quantity leads each, the kind of the carriers), `Equiv.id`,
`Equiv.fun`, `Equiv.inv`, `Equiv.sec`, `Equiv.from_iso` (Cubical Agda's
`isoToIsEquiv`, `lemIso` transcribed with `hfill` inlined as `hcomp` with
the extra face), `isContr.prop`, `isEquiv.prop`, `ua` and `Equiv.of_path`
(a path between types as an equivalence). The Kan rules
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
type to be `Data` (`+y`), a path used twice is `+p` (paths are `Data`,
except a path in a universe, which is an equivalence and affine), a
proof-valued function copies as its domain does, and any other function
used twice is a template parameter (`~f`: a template is a theorem, a
closure is affine). `Equiv.from_iso` and the fibre law are written that
way.

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
(evidence), turns a path lambda in a universe into its equivalence, and
resolves path applications at literal endpoints; a transport along a
variable path in a universe is that path's function or inverse.

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

- `hit_susp_torus`: transport along `Susp<ua(not)(i)>` pushes into
  `merid`'s field definitionally (`merid{True}` becomes `merid{False}` as
  a path); the torus has a two-dimensional path constructor whose corners
  and edges compute and an eliminator with a two-dimensional arm.

### Three rules the documents forced, answered by the mathematics

- **A proof-valued function has its domain's kind.** A function into an
  equation type has no runtime, so the only reason it was not copyable was
  the omega attack through a negative datatype; that needs the function's
  domain to contain the function, so a `Data` datatype may not have a
  copyable proof-function field with a negative occurrence of itself
  (`positivity_mustfail`). With it, `isContr` over `Data` is `Data`, the
  contraction is `+p0`, `isContr.prop` is Cubical Agda's four-face
  composite, `isEquiv.prop` is pointwise, and the coherent **reverse
  univalence round trip** `Equiv.of_path(ua(e)) == e` holds for every
  equivalence (`ua_round`). Quantities lead the equivalence defs
  (`Equiv(a, b, A, B)`, `ua(a, A, B, e)`), the kind of the carriers.
- **A path in a universe is, at runtime, its equivalence.** `Equiv.of_path`
  carries the identity equivalence along it, which the elaboration pass
  computes; so a path lambda in `Type` compiles to an `Equiv` value, `{==}`
  to `Equiv.id`, a path-typed variable is that value, and `coe(p, i0, i1,
  x)` along a variable path is `Equiv.fun(p)(x)` (backwards, `Equiv.inv`).
  Such a path is affine, as a closure is (its kind is `Type`); a line that
  spends it once per element, `i => List<p(i)>`, takes it as a `~`
  template, as `List.map` takes its function (`compiled_path`, both
  lanes). The README's trace `(a, p)` is stored and replayed.
- **A guarded self-call is productive.** A self-call under a constructor's
  delayed field (a lambda), saturated and eliminated by nothing there
  (applied at most to dimensions), unfolds one constructor per
  observation, so the descent check admits it and marks the def
  corecursive. Normalisation for printing and conversion under a lambda
  keep such a def folded, and conversion takes the same-definition
  shortcut before unfolding, so a corecursive value prints one unfolding
  and a bisimulation is a corecursive path checked face by face
  (`stream`, `stream_mustfail`: an eliminated self-call is refused).

## Against the two documents this port answers to

`README.md` (the interactive symbolic computer) and
`collab/bend2-cubical/BEND_HVM_COMPUTATIONAL_UNIVALENCE.md` ask for five
things of a runtime. Where each stands on the official Bend:

1. **Proof is executable transport; `coe(ua(e), x) ↝ e(x)`.** Held, at the
   checker (definitionally, for an abstract `e`) and on the C and JS lanes.
2. **Every map is visible value plus fibre; lossless completion is forced,
   not chosen.** Held: `A ≃ Σ b. fib_f(b)` as a coherent equivalence for
   every `f` over `Data`, `ua` of it, `present` the factoring by
   computation, and it runs. This is the corpus's "lossless inference", and
   it is the most primitive object here too: everything else is transport
   along it.
3. **Partial compositions retained as runtime terms; paths as runtime
   data (the trace `(a, e, b)`).** Paths in a universe are runtime data
   now: their equivalences, affine, transported along at runtime and
   stored in a trace and replayed (`compiled_path`). A composition with an
   undecided face is still not a runtime value: a dimension is dead in
   this language, so every face is decided by the time code runs; the
   composite's value is computed then, and that is exact.
4. **Sharing versus independence (SUP/DUP labels, diagonal versus product);
   transport along a superposed line routing each universe.** No
   counterpart: the official Bend has no superposition; correlation is a
   `+` reference count. The type-level fibre law stands; its runtime form
   as label routing is specific to interaction nets.
5. **Coinduction and intrinsic rewrite.** Coinduction is in: a record with
   a delayed field is a coinductive type, a guarded self-call is
   productive, a bisimulation is a corecursive path (`stream`). The
   README's "self-rewriting becomes proof-carrying rewriting" is
   `LAWS.bend` and `PROOF.bend` at the level of the toolchain.

The finding that used to sit here (the coherent reverse round trip needing
a contraction copied, which the affine wall forbade) is resolved by the
kind rule above: a proof-valued function copies as its domain does.

## What is left

- A composition or glue whose face is a dimension *variable* in live code
  (it cannot arise: dimensions are dead, so this is a diagnostic).
- The Lean spec (`bend.lean`) does not model the new forms: the kind rule
  for proof-valued functions with its positivity condition, the guarded
  self-call, and the Kan operations all need their metatheory carried.
