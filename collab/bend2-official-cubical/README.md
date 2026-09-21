# A cubical core for the official Bend 2

This directory gives the official public Bend 2 (bendlang/bend `2.0.21`,
commit `6018e28`) a cubical core: paths, transport, composition, Glue and
univalence, higher inductive types, coinduction, and transport that runs
on the compiled C and JavaScript lanes. The equality the language already
has, `{a == b : T}`, is re-read as a path type; nothing that checked
before stops checking, and a program that uses none of it compiles to the
same code at the same speed.

```
./run.sh        # clones upstream at 6018e28, applies cubical.patch, runs every test, checks the Lean file
```

`cubical.patch` is the whole change (`bend2/bend.ts`, `bend2/comp.ts`,
`bend2/base.bend`, and the new `bend2/cubical.lean`). `tests/cubical/` are
33 programs in upstream's format: each ends in the `#|` lines its run must
print. `TECHNICAL_REPORT.md` explains every changed line.

## Three programs

**Function extensionality.** Upstream's own test `proof/no_funext_000`
asserts this is unprovable. It is four lines, and the transported function
runs.

```
# function extensionality is a path lambda: a path between functions is a
# function of the dimension whose faces are the two functions
type N is Data:
  Z{}
  S{p: N}

law add:
  for n: N
  for m: N
  N

def add(n, m):
  match n:
    case Z{}:
      m
    case S{k}:
      S{add(k, m)}

law add_zero:
  for n: N
  {add(n, Z{}) == n : N}

def add_zero(n):
  match n:
    case Z{}:
      {==}
    case S{k}:
      %add_zero(k) : {S{add(k, Z{})} == S{_} : N}; {==}

law add_zero_eta:
  {(x => add(x, Z{})) == (x => x) : N -> N}

def add_zero_eta(): i => x => add_zero(x)(i)

law sym:
  for -A: Type
  for -a: A
  for -b: A
  for p: {a == b : A}
  {b == a : A}

def sym(A, a, b, p): i => p(-i)

law cong:
  for -A: Type
  for -B: Type
  for f: A -> B
  for -a: A
  for -b: A
  for p: {a == b : A}
  {f(a) == f(b) : B}

def cong(A, B, f, a, b, p): i => f(p(i))

law main:
  N

def main(): add_zero_eta()(i0)(S{S{Z{}}})
```
prints
```
S{S{Z{}}}
```

**Transport along univalence, compiled.** `ua` turns the equivalence
`not : Bool ≃ Bool` into a path between types; transport along a list of
it is one `map`, emitted as ordinary code for the C and JS lanes.

```
# transport along a line of datatypes over ua, compiled: the runtime pass
# mints a structural transport for List, pushing the equivalence into
# every element, and along a function line it wraps the function
import Base

def Bool.not.not(b: Bool) -> {Bool.not(Bool.not(b)) == b : Bool}:
  match b:
    case True{}:
      {==}
    case False{}:
      {==}

def notEquiv() -> Equiv(&2, &2, Bool, Bool):
  Equiv.from_iso(~Bool, ~Bool, ~Bool.not, ~Bool.not, ~Bool.not.not, ~Bool.not.not)

def flipAll(xs: List<Bool>) -> List<Bool>:
  coe(i => List<ua(&2, Bool, Bool, notEquiv())(i)>, i0, i1, xs)

def flipFun(f: Bool -> Bool) -> Bool -> Bool:
  coe(i => ua(&2, Bool, Bool, notEquiv())(i) -> ua(&2, Bool, Bool, notEquiv())(i), i0, i1, f)

def main() -> IO(Unit):
  do IO<Unit>:
    IO.print(List.show(~&1, ~Bool, ~Bool.show, flipAll([True{}, False{}, True{}])))
    IO.print(Bool.show(flipFun(x => x)(True{})))
```
prints
```
[False, True, False]
True
```

**A higher inductive type refuses what it must.** `loop` is a path
constructor of the circle; it is not the constant path.

```
# loop is not the constant path: a match arm that maps loop to the
# constant path at base is fine, but loop itself is not {==}
import Base

type S1 is Data:
  base{}
  path loop{}: {base{} == base{} : S1}

law bad:
  {loop{} == {==} : {base{} == base{} : S1}}

def bad(): {==}
```
prints
```
Error:
- expected : loop{}
- observed : {==}
Location: bad
11 | 
12>| def bad(): {==}
13 | 
exit 1
```

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

## What you can now write

Each item says what upstream lacks and why, then the rule, then the test.
Every "upstream" claim was run on pristine `2.0.21`; `j_index.bend` pins
the one thing upstream already had (J transports a value along an index
proof, and still does).

**Equations built by abstraction, computing on every path.** Upstream's
only way to introduce an equation is `{==}` (check-rfl is the sole
introduction rule for `Eql`), so every equation is reflexivity up to J, and
J is stuck on an open proof. Here `i => t` introduces a path with its faces
checked by conversion, `p(r)` eliminates it, and J steps on every path as
transport along the connection square. `j.bend`, `coe.bend`.

**Function extensionality.** An equation between functions can only be
`{==}`, and two syntactically different functions are not convertible;
there is no way to build the equation from pointwise evidence. Funext is a four-line path: `i => x => p(x)(i)`, checked
by its faces. `funext.bend`. Cost: none; the path is
erased. Verified: upstream's `proof/no_funext_000` asserts
unprovability and is the one intended divergence of the suite.

**Univalence.** `{A == B : Type}` has one inhabitant, `{==}`,
which requires `A` and `B` convertible; transport along it is the
identity. There is no term that turns two functions and two round-trip
proofs into an equation of types. `ua(e) : {A == B : Kind(q)}` is a definition (a `Glue`
line), transport along it runs `e`'s function, and `Equiv.of_path(ua(e))`
is `e` again. `ua.bend`, `ua_round.bend`, `fibre.bend`,
`compiled_coe.bend`, `compiled_path.bend`. Cost: a universe path is a
pair of closures at runtime; a transport along it is one call, along a
list of them one map, which is the hand-written conversion. Verified:
upstream refuses `coe` and `ua` as undefined names.

**Quotients and truncation.** A `type` declares constructors whose tip is the
family; there is no way to declare an equation as a constructor, so a
quotient can only be simulated by a chosen normal form nothing enforces.
`path c{fields}: {a == b : K<..>}` declares a path
constructor; `match` on the family must supply its arm at the path over
the motive, so a function out of the quotient is refused unless it
respects the relation. `hit_quot.bend`, `hit_circle.bend`,
`hit_trunc.bend`, `hit_susp_torus.bend`, `hit_mustfail_loop.bend`.
Cost: none at runtime; a path constructor is erased, so a quotient is
represented by its underlying data. Verified: upstream's parser
rejects `path` in a `type` block.

**Coinduction.** Every live self-call must descend on a column
of the definition's case tree (`term_descend`); a self-call under a
constructor's lambda descends on nothing and is refused. A self-call under a constructor's delayed field, observed
only through dimensions, is productive: each observation unfolds one
constructor. The definition is marked corecursive, stays folded while
printed or compared, and a bisimulation is a corecursive path checked
one unfolding at a time. `stream.bend`,
`stream_mustfail.bend`. Cost: none; the closure is the same closure.
Verified: upstream refuses `ones = mk{1n, _ => ones}` with its descent
error, and its own `halt/strict_descent` pins that refusal (the second
intended divergence).

**Copyable proof functions.** No function type is `Data` (`infer-all` gives
every `All` the kind `Type`), so a proof-valued function is affine: not a
`+` binder, not a field of a `Data` type. A function into an equation is `Data`, whatever its
domain, since it has no runtime content to copy; the omega attack this
could open (a copyable function inside its own domain) is closed by a
positivity check on datatype fields. `isContr`, `isEquiv`, `Equiv` are
ordinary Base definitions. `proof_fn_copy.bend`,
`proof_fn_kind.bend` (a proof function over closures, used twice and
stored in a record), `positivity_mustfail.bend`. Cost: none; the function is erased.
Verified: upstream refuses `+h: @x:Nat -> {x == x : Nat}` and a `Data`
field of that type, both with "expected Data, observed Type".

**Transport on the native lanes.** Upstream has nothing to transport: its only
type path is `{==}`. A universe path compiles to its equivalence; `coe` along a
datatype line to a minted structural map; along a function line to a
wrapper; a path applied to an endpoint to that endpoint; a path
constructor at literal dimensions to its boundary. The C, JS and
interpreter lanes agree. `compiled*.bend`,
`hit_susp_torus.bend` on all lanes.

## What can no longer go wrong

- **Foreign code cannot deliver evidence** (issue #874, closed uniformly).
  A C library cannot return "this buffer is null-terminated" as a proof;
  it returns the buffer and the proof is built in Bend. A JS callback
  cannot return "these types are equal." A host may return data, a
  handle, a kind, a callback that returns data, or an equation the checker
  can already close; never a path with distinct ends, a universe path, a
  dependent codomain or an empty type. Checked at the declaration and at
  every call that instantiates a type parameter. `issue_874*.bend`.
- **Template binder names cannot collide** (#905). `def cast(~T, ~x: T,
  ~T)` no longer typechecks as an unsafe cast. `issue_905.bend`.
- **A raw read of a shared node cannot be emitted** (#901). Any program
  over an indexed family (matrices, sized vectors, protocol states) that
  the C emitter's ownership analysis mishandles now runs or stops with an
  error; it cannot corrupt memory. The reporter's matrix product runs at
  every depth. `issue_901.bend`, `issue_853.bend`.
- **The interval decision procedure is mechanized** (`bend2/cubical.lean`).
  Stating the decision procedure in Lean showed that a two-valued table
  decides a Boolean algebra, not the free De Morgan algebra the theory
  requires; the procedure evaluates in the four-element De Morgan algebra
  and is proved sound and strictly finer. `demorgan.bend`.

## What it costs

| what | cost |
| --- | --- |
| a program with no path operation | none: same code, same speed (benches within 1%) |
| checking a proof with dimension variables | a table of at most 4^8 cases; real proofs have two or three atoms |
| a transport along an index proof | the identity |
| a transport along a list of equivalences | one map over the list |
| a transport along a function line | one wrapper |
| a universe path at runtime | a pair of closures, spent once or passed as a `~` template |
| a read of a `Data` node on the C lane | one predictable branch |

The one rule that shapes new code: a path between *types* is affine, like
the closures it holds. It constrains nothing that existed before.

## Verification

| what | result |
| --- | --- |
| `tests/cubical` | 33 of 33, the compiled ones on the C and JS lanes |
| `bend2/cubical.lean` | checks under Lean 4.34, no `sorry` |
| upstream interpreter suite, 931 files | 923 pass; 4 fail on unpatched upstream too; 4 change on purpose (below) |
| upstream io suite, 139 files | identical output |
| upstream compiled lanes, every Base program with a `main` in `run compile io check eval base spec` | identical output, one added refusal (a universe-path `main` cannot be printed) |
| upstream benches `bfs`, `queens`, `tree-matmul`, sequential | within 1% |

The four intended divergences: `proof/no_funext_000` asserts funext is
unprovable and now fails; `halt/strict_descent` refused a productive
self-call and now accepts it; `halt/duplicate_deferred` and
`grade/reject_leak` are refused one step earlier (by affinity, and because
a universe path is not `Data`). Upstream's pinned parse errors for `~`,
`!` and `:` are untouched, which is why negation is `-r` and a path
constructor is introduced by `path`.

## Design

### One principle, four boundaries

Every rule this port adds is one question asked at a boundary: *what is
the runtime content of this thing?* Bend's kinds already classify types
by it (`Data` copies freely, `Type` holds closures), and cubical type
theory has the matching fact that a path is erasable everywhere except in
a universe, where its content is an equivalence, a pair of closures. So:
a path type over data is `Data` and a universe path is `Type` (the kind
rule); a function into an equation is `Data` (the proof-function rule); a
host may deliver a value only when its runtime representation is its
meaning, data or an equation the checker already closes, whose null is
exactly `{==}` (the foreign rule); and the C lane takes a node through its
refcount tag exactly when its kind says it may be copied (the read rule).

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

## What is left

- A composition or glue whose face is a dimension *variable* in live code
  (it cannot arise: dimensions are dead, so this is a diagnostic).
- The Lean spec (`bend.lean`) does not carry the new forms' metatheory:
  `cubical.lean` specifies the fragment's rules and proves the interval,
  but canonicity for `coe`/`hcomp`/`Glue`, the kind rule for proof-valued
  functions with its positivity condition, and the guarded self-call are
  stated, not proved.
- The emitter is not a term of the language: ownership is now decided by
  kinds for reads, but sealing still relies on the hot walk, and the
  lowering as a whole is trusted, not proved.
