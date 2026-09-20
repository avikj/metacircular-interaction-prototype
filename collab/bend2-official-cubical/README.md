# A cubical core for the official Bend 2

This directory ports the cubical work of `collab/bend2-cubical` (built on
the HVM3 interaction-net fork, DKormann/Bend2) onto the **official public
Bend 2** (bendlang/bend, `2.0.21`, commit `6018e28`), which is a different
language implementation: a TypeScript checker (`bend2/bend.ts`, one linear
bidirectional pass, an affine dependent theory with a dead/live wall), a
C/Metal/CUDA/JS compiler (`bend2/comp.ts`) and a Lean spec (`bend.lean`).
Nothing is copied over: the equality primitive of the official language
(`{a == b : T}`, `{==}`, `%e : P; f`) is *re-read* as a path type, and the
Kan operations are added as term forms with type-directed reduction, in
the style of the checker they extend.

`cubical.patch` is the whole change against upstream `6018e28`
(`bend2/bend.ts` and `bend2/comp.ts` only). `tests/cubical/*.bend` are the
new tests, in upstream's own format (a file ending in the `#|` lines its run
must print). `run.sh` clones upstream at the pinned commit, applies the
patch, and runs the cubical tests plus the whole interpreter-lane suite.

## What the core adds (slice 1: checker and interpreter)

| form | meaning | rule |
| --- | --- | --- |
| `Interval`, `i0`, `i1` | the interval and its ends | `Interval : Data`; a dimension is always dead (never runs) |
| `-r`, `r /\ s`, `r \/ s` | De Morgan negation, meet, join | constants fold in `term_wnf`; two interval terms are convertible iff they agree on every assignment of their atoms (a truth table over the free De Morgan algebra) |
| `{a == b : T}` | a path type, `Path T a b` | unchanged syntax, `Data` kind (evidence is erased) |
| `{a == b : i => T(i)}` | a dependent path, `PathP` | the carrier is a line `Interval -> Type`; `a : T(i0)`, `b : T(i1)` |
| `i => t` at a path type | path abstraction | `check-path`: `t : T(i)` with `i : +Interval`, and the faces `t[i0] ≡ a`, `t[i1] ≡ b` by conversion |
| `p(r)` | path application | `infer-papp`: `p : {a == b : T}`, `r : Interval` dead, result `T(r)`; `p(i0)` reduces to `a` and `p(i1)` to `b` |
| `{==}` | the constant path | unchanged (`a ≡ b`) |
| `%e : P; f` | J | unchanged typing; **computes on every path**: `%e : P; f  ↦  coe(i => P(e(i), j => e(i /\ j)), i0, i1, f)` when `e` is a non-constant path lambda (still `f` on `{==}` and constant paths) |
| `coe(L, r, s, x)` | transport along a line or a path in `Type` | `L` is `i => T` checked at `Interval -> Type`, or a term inferred at `{A == B : Type}`; `x : L(r)`; result `L(s)` |
| `hcomp(A, x, [(r == i0, ..) i => u, ..])` | homogeneous composition | `x : A`; each tube `u : Interval -> A` on its face; `u(i0) ≡ x` on the face; tubes agree where faces meet; result `A` |

### Reduction

- **Endpoints.** The checker's elaborated tree annotates every node with
  its type (`Ann(x, cell)`). A checked def now unfolds to that tree
  (`Def.w`, built by `def_body`, which rebinds the cells' types at their
  depth), so `term_wnf` reads a stuck path's endpoints off its annotation
  when it is applied to `i0`/`i1`. Raw goals (a law's statement) go through
  `term_pend`, which infers the type of a variable- or reference-headed
  spine in the context to do the same. This is what makes
  `Equal.sym(N, a, b, p)(i0) ≡ b` a fact of evaluation.
- **coe** by the shape of the line's body at a fresh dimension: `r ≡ s` or
  a body that does not mention the dimension is the identity; kinds,
  `Quant`, `Interval` are the identity; a function transports
  contravariantly in the domain and along the codomain; a constructor of a
  datatype transports fieldwise, each field's line the constructor
  telescope at the parameters of `i`, opened on the earlier fields carried
  to `i` (so every ADT of the book gets transport for free, no per-type
  code); a line of **path types** reparametrizes the line from `r`..`s` to
  `i0`..`i1` (`(-i /\ r) \/ (i /\ s)`) and composes in the carrier with the
  endpoints' own transports as faces. A neutral path in `Type` is stuck
  (that is where `Glue`/`ua` go, slice 2).
- **hcomp**: a face that holds is the tube's value at `i1`; else a function
  composes pointwise, a path composes in its carrier with its endpoints as
  two more faces, and a constructor of a datatype composes fieldwise when
  every tube is that constructor. A composite in `Type` is stuck (slice 2).

### The wall, kept

Bend's consistency comes from the dead/live wall, not from a universe
hierarchy: dead code (types, erased arguments, equation endpoints) may
diverge or inhabit `Empty`, and nothing dead ever counts as live evidence.
The cubical core keeps that discipline exactly where the official checker
draws it for `%e : P; f` (its equation `e` is live):

- a path lambda's body is checked at the ambient demand, so a path built
  in live code is live evidence and cannot re-export an erased hypothesis
  (`i => e(i)` with `-e` is refused);
- `coe`'s line or path is checked at the ambient demand
  (`tests/cubical/must_fail_dead_coe.bend`: an erased `-p : {A == B : Type}`
  does not transport a live value); dimensions `r`, `s` are dead;
- `hcomp`'s tubes are live (a face that holds *is* the value); the base
  and the tubes join their measures like match arms.

Consequences a Bend user will meet: a `cong` written cubically takes its
function live (`for f: A -> B`, consumed once in `i => f(p(i))`), while
Base's `Equal.cong` with `-f` still checks through J. Both are correct
Bend.

### Compiled lanes (C, JS)

A path has no runtime. For the compiler, `term_unpath` rewrites the
checked tree: a path lambda becomes the erased evidence (`{==}`, a zero
box), and a path applied to a *literal* endpoint becomes that endpoint,
read off its annotation. So `add_zero_eta()(i1)(2n)` compiles to
`(x => x)(2n)` on every lane. A live `coe`, `hcomp`, or a path applied to a
dimension variable is refused by the compiler with a clear message; those
need the runtime slice below. `%e : P; f` compiles to `f`, as upstream,
which is exact until `ua` exists (every type path is the identity on
runtime data until then).

## Verification

- `tests/cubical/funext.bend`: funext, symmetry (`p(-i)`), congruence; the
  transported function runs (`main` normalizes to `2n`).
- `tests/cubical/coe.bend`: transport along a hypothesis path in `Type`,
  along constant lines (definitionally the identity), along `i => List<p(i)>`
  on a constructor, a `PathP` witness `i => coe(p, i0, i, x)`, and a
  connection square `j => i => p(i /\ j)` with its De Morgan faces.
- `tests/cubical/j.bend`: J on a non-constant path (`Equal.trans`,
  `Equal.sym` from Base) has computing faces; `coe` along a line of path
  types has computing faces.
- `tests/cubical/hcomp.bend`: a hand-written square filler (`comp`) with
  both faces computing; a composite in `Nat` pushes into the literal.
- `must_fail_face.bend`, `must_fail_dead_coe.bend`: the face check and the
  wall refuse what they must, with the messages pinned.
- Upstream's own interpreter-lane suite (`tests/{proof,check,eval,stuck,
  halt,grade,spec,comptime,flatten,parse,show,printer,base,rfc,state}`,
  931 files): the patched checker passes every file the unpatched one
  passes (927; the 4 others time out on `@unsafe` loops on both), except
  `proof/no_funext_000`, which asserts that funext is *unprovable* and now
  fails as intended (`x => add_zero(x)` at a path type binds `x :
  Interval`; the funext proof is `i => x => add_zero(x)(i)`).

## What is not in slice 1, and the plan

1. **Glue / `ua` (slice 2).** `Glue(A, [(φ) (T, e)])`, `glue`, `unglue`,
   the Kan rules for `coe`/`hcomp` at `Glue`, and `ua : Equiv(A, B) -> {A
   == B : Type}` with `coe(ua(e), i0, i1, x) ≡ e.to(x)`. All the machinery
   this needs (faces, `coe_step` by type shape, `hcm_step`) is in place; the
   rules are the CCHM ones already written down in
   `collab/bend2-cubical/GLUE.md` and `UNIVALENCE.md` for the other
   runtime. Composition in `Type` (`hcomp` at `Typ`) is `Glue` too.
2. **Higher inductive types (slice 3).** `type S1 is Data: base{}; loop:
   {base == base : S1}`: a constructor whose telescope tips at a path type
   of the family. `check-mat` on a HIT takes an extra arm per path
   constructor checked at the motive's `PathP`, with faces; `coe_step` and
   `hcm_step` at a HIT are the fieldwise rules plus the path constructors'
   boundaries; the general schema is the one of
   `collab/bend2-cubical/HITS.md`.
3. **Runtime transport (slice 4).** The compiler erases types, so a live
   `coe` needs runtime content: a path in `Type` compiles to its transport
   pair (`to`, `from`) built by `comp.ts` from the line's *syntax* by the
   same type-directed rules `coe_step` uses (structural over ADTs and
   functions, identity on constants), bottoming out at `ua(e)` (the
   equivalence's functions) and at path variables (which then carry the
   pair). `hcomp` on data compiles to the constructor push. This is the
   piece that is genuinely different from the interaction-net fork (where
   `HVM4Full` generated per-HIT runtime code): here it is one emitter
   pass over the annotated tree.
4. The Lean spec (`bend.lean`) does not model the new forms yet.
