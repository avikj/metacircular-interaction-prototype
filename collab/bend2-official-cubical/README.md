# A cubical core for the official Bend 2

This directory gives the official public Bend 2 (bendlang/bend `2.0.21`,
commit `6018e28`) a cubical core: paths, transport, composition, Glue and
univalence, higher inductive types, coinduction, and transport that runs
on the compiled C and JavaScript lanes. The equality the language already
has, `{a == b : T}`, is re-read as a path type.

Two facts locate it. Upstream ships a test, `proof/no_funext_000`,
asserting that function extensionality is **unprovable**; here it is four
lines, and the function it identifies runs. Upstream 2.0.21 **faults with
a memory error** on the matrix program filed as issue #901; here that
program prints its answer on the C lane, because the rule that faulted is
replaced by one the checker's own kinds decide.

Nothing that checked before stops checking, and a program that uses none
of this compiles to the same code at the same speed.

```
./run.sh        # clones upstream at 6018e28, applies cubical.patch, runs every test, checks the Lean file
```

`cubical.patch` is the whole change (`bend2/bend.ts`, `bend2/comp.ts`,
`bend2/base.bend`, and the new `bend2/cubical.lean`). `tests/cubical/` are
33 programs in upstream's format: each ends in the `#|` lines its run must
print. The second half of this document, from **Evidence 1** on, is the
formal rules, every changed line, every test, the method behind the
numbers, and the mechanization.

## Three programs

**Function extensionality.** Two functions that agree at every argument
are equal, and the identification computes. `add_zero` is the ordinary
inductive proof that `add(n, Z{}) == n`; the path below turns it into an
equality of the two functions, and applying that equality at `i0` runs.

```
law add_zero_eta:
  {(x => add(x, Z{})) == (x => x) : N -> N}

def add_zero_eta(): i => x => add_zero(x)(i)

def main(): add_zero_eta()(i0)(S{S{Z{}}})
```
prints
```
S{S{Z{}}}
```

The same file derives symmetry as `i => p(-i)` and congruence as
`i => f(p(i))`, each one line (`funext.bend`, shown in full there).

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

Each item says what upstream lacks and why, then the rule that supplies
it, where that rule is written down, and the tests. Every claim about
upstream was run on pristine `2.0.21`. `j_index.bend` pins the one thing
upstream already had: J transports a value along an index proof, and
still does.

**Equations built by abstraction, computing on every path.** Upstream's
only way to introduce an equation is `{==}` (check-rfl is the sole
introduction rule for `Eql`), so every equation is reflexivity up to J, and
J is stuck on an open proof. Here `i => t` introduces a path with its faces
checked by conversion, `p(r)` eliminates it, and J steps on every path as
transport along the connection square. The rules are in Evidence 1.2 and
1.3; the tests are `j.bend` and `coe.bend`.

**Function extensionality.** An equation between functions can only be
`{==}`, and two syntactically different functions are not convertible;
there is no way to build the equation from pointwise evidence. Here funext
is a four-line path, `i => x => p(x)(i)`, checked by its faces
(`funext.bend`, check-path in Evidence 1.2). It costs nothing at runtime:
the path is erased. Upstream's `proof/no_funext_000` asserts
unprovability, and is one of the four suite answers this port changes on
purpose.

**Univalence.** `{A == B : Type}` has one inhabitant, `{==}`,
which requires `A` and `B` convertible; transport along it is the
identity. There is no term that turns two functions and two round-trip
proofs into an equation of types. Here `ua(e) : {A == B : Kind(q)}` is a
definition in Base (a `Glue` line, Evidence 4), transport along it runs
`e`'s function, and `Equiv.of_path(ua(e))` is `e` again: `ua.bend`,
`ua_round.bend`, `fibre.bend`, `compiled_coe.bend`, `compiled_path.bend`.
A universe path costs a pair of closures at runtime; transporting along it
is one call, and along a list of them one map, which is the conversion you
would have written. Upstream refuses `coe` and `ua` as undefined names.

**Quotients and truncation.** A `type` declares constructors whose tip is the
family; there is no way to declare an equation as a constructor, so a
quotient can only be simulated by a chosen normal form nothing enforces.
Here `path c{fields}: {a == b : K<..>}` declares a path constructor, and a
`match` on the family must supply its arm at the path over the motive, so
a function out of the quotient is refused unless it respects the relation
(check-mat in Evidence 1.2, the eliminator rules in Evidence 1.3). Tests:
`hit_quot.bend`, `hit_circle.bend`, `hit_trunc.bend`,
`hit_susp_torus.bend`, `hit_mustfail_loop.bend`. It costs nothing at
runtime: a path constructor is erased, so a quotient is represented by its
underlying data. Upstream's parser rejects `path` in a `type` block.

**Coinduction.** Every live self-call must descend on a column of the
definition's case tree (`term_descend`); a self-call under a constructor's
lambda descends on nothing and is refused. Here a self-call under a
constructor's delayed field, observed only through dimensions, is
productive: each observation unfolds one constructor. The definition is
marked corecursive, stays folded while printed or compared, and a
bisimulation is a corecursive path checked one unfolding at a time
(`stream.bend`, `stream_mustfail.bend`; the guard is in Evidence 2.7). It
costs nothing: the closure is the same closure. Upstream refuses `ones =
mk{1n, _ => ones}` with its descent error, and its own `halt/strict_descent`
pins that refusal.

**Copyable proof functions.** No function type is `Data` (`infer-all` gives
every `All` the kind `Type`), so a proof-valued function is affine: not a
`+` binder, not a field of a `Data` type. Here a function into an equation
is `Data` whatever its domain, since it has no runtime content to copy, and
the omega attack this could open (a copyable function inside its own domain)
is closed by a positivity check on datatype fields (infer-all in Evidence
1.2, the check in Evidence 2.9). That is what makes `isContr`, `isEquiv` and
`Equiv` ordinary Base definitions. Tests: `proof_fn_copy.bend`,
`proof_fn_kind.bend` (a proof function over closures, used twice and stored
in a record), `positivity_mustfail.bend`. It costs nothing: the function is
erased. Upstream refuses `+h: @x:Nat -> {x == x : Nat}` and a `Data` field
of that type, both with "expected Data, observed Type".

**Transport on the native lanes.** Upstream has nothing to transport: its only
type path is `{==}`. Here a universe path compiles to its equivalence;
`coe` along a datatype line to a minted structural map; along a function
line to a wrapper; a path applied to an endpoint to that endpoint; a path
constructor at literal dimensions to its boundary. The C, JS and
interpreter lanes agree. The elaboration is Evidence 2.5 and the emitter
changes are Evidence 3. Tests: `compiled.bend`, `compiled_coe.bend`,
`compiled_fibre.bend`, `compiled_path.bend`, `hit_susp_torus.bend`,
built and run on both lanes.

## What can no longer go wrong

- **Foreign code cannot deliver evidence** (issue #874, closed uniformly).
  A C library cannot return "this buffer is null-terminated" as a proof;
  it returns the buffer and the proof is built in Bend. A JS callback
  cannot return "these types are equal." A host may return data, a
  handle, a kind, a callback that returns data, or an equation the checker
  can already close; never a path with distinct ends, a universe path, a
  dependent codomain or an empty type. Checked at the declaration and at
  every call that instantiates a type parameter. The rule is
  `term_transportable` (Evidence 2.9); the tests are `issue_874.bend`,
  `issue_874_false.bend`, `issue_874_empty.bend`, `issue_874_poly.bend`.
- **Template binder names cannot collide** (#905). `def cast(~T, ~x: T,
  ~T)` no longer typechecks as an unsafe cast (Evidence 2.9,
  `issue_905.bend`).
- **A raw read of a shared node cannot be emitted** (#901). Any program
  over an indexed family (matrices, sized vectors, protocol states) that
  the C emitter's ownership analysis mishandles now runs or stops with an
  error; it cannot corrupt memory. The reporter's matrix product runs at
  every depth, on the C lane. The rule is the take rule and the completed
  hot walk (Evidence 3); the tests are `issue_901.bend` and
  `issue_853.bend`.
- **Interval conversion cannot silently decide the wrong algebra**
  (`bend2/cubical.lean`). The interval is the free De Morgan algebra, not
  a Boolean one: a two-valued table would accept `{==}` at
  `{i /\ -i == i0 : Interval}`, which is not a law. Conversion evaluates
  in the four-element De Morgan algebra, which generates the variety, and
  the Lean file proves the folds sound, the relation a congruence with
  every De Morgan law, and the two-valued table strictly coarser with that
  counterexample (Evidence 7, `demorgan.bend`).

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

How each number was obtained is Evidence 6; every test is listed in
Evidence 5.

| what | result |
| --- | --- |
| `tests/cubical` | 33 of 33, the compiled ones on the C and JS lanes |
| `bend2/cubical.lean` | checks under Lean 4.34, no `sorry` |
| upstream interpreter suite, 931 files | 923 pass; the 8 that do not are 4 that fail on unpatched upstream too and 4 this port changes on purpose (below) |
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
Four rules, one question. The wall below is where the question is asked
of evidence itself.

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

## The second fork, and what it is for

This one is the adoption case: the smallest cubical core that the public
Bend 2 can take, against upstream's own issues and its own test suite.
`collab/bend2-interactive-cubical/` is the other half of the argument -- the
same theory taken as far as it goes, on DKormann/Bend2 and the HVM runtime:
general `hcomp`, `Glue`, higher inductive types by a general schema, set
quotients, genuine coinduction, and transport that runs on interaction nets.
It exists to answer "does this scale past the demo", and it is built and run
by one command (`run.sh`), 118 files.

Three things it has established that bear on this document, each measured
against the built checker rather than argued:

- **Regularity is decided up to conversion, not syntax.** `coe` fires the
  identity rule when the line, applied at a marker dimension and normalised,
  no longer mentions it. `regularity.bend` shows lines that mention the
  dimension in the source and still transport as the identity: through a
  definition that discards it, under a De Morgan meet `k /\ -k` (its own
  element, not `i0`), through an `hcomp` whose faces and cap agree where
  `k \/ -k` is not `i1`, and through a `Glue` of identity equivalences.
  This is where Cubical Agda puts `transp`'s side condition too.
- **The whole lane is total or productive, and now gated.** `suite.sh` runs
  every file under `--total`; 114 of 118 are `[total]` or `[productive]`
  throughout, and the four that are not are registered and deliberate.
- **Univalence needs one construction, not two.** The Glue line gives
  `ua`'s computation rules definitionally in both directions, so the
  primitive earns nothing in the checker. What kept it alive was the
  runtime: `isSetLine` decided which path lambdas become a `(fwd, bwd)`
  pair and did not list `Glue`, so a CCHM univalence path emitted as an
  empty superposition -- silently. `glue-emit.patch` fixes that in both
  emitters. The bug had hidden because the obvious test equivalence is
  negation, which is its own inverse.

## What is left

- A composition or glue whose face is a dimension *variable* in live code
  (it cannot arise: dimensions are dead, so this is a diagnostic).
- The Lean spec (`bend.lean`) does not carry the new forms' metatheory:
  `cubical.lean` specifies the fragment's rules and proves the interval,
  but canonicity for `coe`/`hcomp`/`Glue`, the kind rule for proof-valued
  functions with its positivity condition, and the guarded self-call are
  stated, not proved. Canonicity for full CCHM is Huber's thesis, and no
  language ships with it for its own core; what is missing here is the
  delimited version -- determinism and subject reduction for the fragment
  §6 already states -- not the open problem.
- The emitter is not a term of the language: ownership is now decided by
  kinds for reads, but sealing still relies on the hot walk, and the
  lowering as a whole is trusted, not proved.

---

# Evidence

Everything above is a claim. Everything below is where each claim is
checked: the rules as inference rules, every hunk of `cubical.patch` by
its anchor, the Base additions, every test with what it pins, how the
verification numbers were obtained, and the Lean file.

## Evidence 1. The rules, formally

### 1.1 Syntax

| form | meaning | parser |
| --- | --- | --- |
| `Interval` | the interval type | keyword, `Itv` |
| `i0`, `i1` | the endpoints | keywords, `Dim(0)`, `Dim(1)` |
| `-r` | De Morgan negation | prefix `-` at precedence 12 in term position, `Ineg` |
| `r /\ s` | meet | infix at level 11 (binds tighter than `\/`), `Imin` |
| `r \/ s` | join | infix at level 10, `Imax` |
| `{a == b : T}` | path type (`Path T a b`) | unchanged, `Eql` |
| `{a == b : i => T}` | dependent path (`PathP`) | unchanged; the carrier is a lambda |
| `i => t` at a path type | path abstraction | unchanged, `Lam` checked against `Eql` |
| `p(r)` | path application | unchanged, `App` inferred against `Eql` |
| `{==}` | the constant path | unchanged, `Rfl` |
| `%e : P; f` | J | unchanged, `Rwt`; now computes on every path |
| `coe(A, r, s, x)` | transport along `A` from `r` to `s` | `Coe`; four arguments exactly |
| `hcomp(A, x, [(r == i0, ..) i => u, ..])` | homogeneous composition | `Hcm`; a system of faces |
| `Glue(A, [(f) (T, e), ..])` | a Glue type | `Glu` |
| `glue(x, [(f) t, ..])` | a Glue value | `Gle` |
| `unglue(g)` | the base of a Glue value | `Ung` |
| `path c{fields}: {a == b : K<..>}` in a `type` | a path constructor | `Ctr.p` = dimension |

A *face* is a conjunction of constraints `r == i0` or `r == i1` (either
side may be the literal); a *system* is a bracketed, comma separated list
of `(face) body`.

### 1.2 Typing rules

Written as upstream writes its rules in comments: `Γ ⊢ t : T ~ u` means `t`
checks at `T` with uses `u`. "dead" means checked at demand `None()`.

```
------------------------------------------------ infer-itv
Γ ⊢ Interval : Data       Γ ⊢ i0, i1 : Interval

Γ ⊢ r : Interval    Γ ⊢ s : Interval     (dead)
------------------------------------------------ infer-dim
Γ ⊢ -r, r /\ s, r \/ s : Interval ~ {}

Γ ⊢ T : Type  (or  Γ ⊢ T : Interval -> Type)
Γ ⊢ a : T (or T(i0))    Γ ⊢ b : T (or T(i1))    (dead)
------------------------------------------------ infer-eql
Γ ⊢ {a == b : T} : Kind(q)
   where q = &1 if T's carrier is a kind (a universe path is affine), &2 otherwise

T ≡ {a == b : L}
Γ , i : +Interval ⊢ f(i) : L(i) ~ u        f(i0) ≡ a     f(i1) ≡ b
------------------------------------------------ check-path
Γ ⊢ i => f : T ~ u - i

Γ ⊢ p : {a == b : T} ~ pu     Γ ⊢ r : Interval (dead)
------------------------------------------------ infer-papp
Γ ⊢ p(r) : T(r) ~ pu           (T(r) = T when T is not a line)

Γ ⊢ A : Interval -> Type (at the ambient demand)   or   Γ ⊢ A : {X == Y : Type}
Γ ⊢ r, s : Interval (dead)      Γ ⊢ x : A(r) ~ u
------------------------------------------------ infer-coe
Γ ⊢ coe(A, r, s, x) : A(s) ~ Au + u

Γ ⊢ A : Type (dead)     Γ ⊢ x : A ~ xu
Γ[σk] ⊢ uk : Interval -> A[σk] ~ uk      uk(i0) ≡ x[σk]      uj ≡ uk where faces meet
------------------------------------------------ infer-hcomp
Γ ⊢ hcomp(A, x, [(fk) uk, ..]) : A ~ xu + (u1 | .. | un)

Γ ⊢ A : Kind(q)     Γ[σk] ⊢ Tk : Kind(q) (dead)     Γ[σk] ⊢ ek : Equiv(q, q, Tk, A[σk]) ~ uk
------------------------------------------------ infer-glue
Γ ⊢ Glue(A, [(fk) (Tk, ek), ..]) : Kind(q) ~ u1 | .. | un

T ≡ Glue(A, [(fk) (Tk, ek), ..])
Γ ⊢ x : A ~ xu     Γ[σk] ⊢ tk : Tk ~ uk     Equiv.fun(ek)(tk) ≡ x[σk]     every face has its section
------------------------------------------------ check-glue
Γ ⊢ glue(x, [(fk) tk, ..]) : T ~ xu + (u1 | .. | un)

Γ ⊢ g : Glue(A, ..) ~ u
------------------------------------------------ infer-unglue
Γ ⊢ unglue(g) : A ~ u

Γ ⊢ A : Kind(_)     Γ, x:A ⊢ B : Kind(_)     B ≡ {_ == _ : _}
------------------------------------------------ infer-all (proof-valued)
Γ ⊢ @x:A -> B : Data

type K: path c{xs}: {a == b : L}     (L's carrier is K at its own parameters)
Γ ⊢ xs : the fields' telescope at K's parameters
------------------------------------------------ check-ctr (path)
Γ ⊢ c{xs} : {a == b : L}[xs]        Γ ⊢ c{xs}(r1)..(rn) : L[xs](r1)..(rn)

match on K, arm for a path constructor c{xs} with tip {a == b : L}:
------------------------------------------------ check-mat (path arm)
Γ, xs ⊢ h : {E(a) == E(b) : i => P(c{xs}(i))}   (nested once per dimension; E the eliminator)
```

`σk` is the substitution the face `fk` induces (each dimension variable it
fixes replaced by its literal), computed by `face_check` and applied by
`term_subst`.

### 1.3 Reduction (`term_wnf`)

- **Interval constants fold.** `-i0 ↦ i1`, `--r ↦ r`, `i0 /\ r ↦ i0`,
  `i1 /\ r ↦ r`, `i1 \/ r ↦ i1`, `i0 \/ r ↦ r`, and symmetrically.
- **Endpoints.** A term annotated (or, in the check's context, a variable
  typed) at `{a == b : T}` and applied to `i0` (`i1`) steps to `a` (`b`).
  A path constructor applied to a literal dimension steps to that face of
  its tip (`ctr_face`).
- **J on a path.** `%e : P; f ↦ f` when `e` is `{==}` or a constant path
  lambda; otherwise `%e : P; f ↦ coe(i => P(e(i), j => e(i /\ j)), i0, i1,
  f)`, the transport along the connection square.
- **coe** (`coe_step`) by the shape of the line's body at the sentinel
  dimension: `r ≡ s` (as interval terms) or a body not mentioning the
  dimension is the identity; a kind, `Quant`, `Interval` is the identity;
  a function type transports contravariantly in the domain and along the
  codomain; a line of path types reparametrizes `r..s` onto `i0..i1` and
  composes in the carrier with the endpoints' transports as faces; a
  `Glue` line follows CCHM (unglue at `r`, transport the base, invert the
  equivalence on each face live at `s`, correct along the section, glue);
  a datatype line transports a constructor fieldwise (each field's line is
  the telescope at the parameters of `i`, opened on the earlier fields
  carried to `i`), commutes with an `hcomp` cell, and keeps a path
  constructor's dimensions; a neutral line is stuck.
- **hcomp** (`hcm_step`): a face that holds is its tube at `i1`; dead faces
  drop; in a universe it is a `Glue` (each face's tube-top glued to the
  base along transport back down the tube); at a `Glue` type it composes
  in each partial type and in the base; at a function type pointwise; at
  a path type in the carrier with the endpoints as two more faces; at a
  datatype fieldwise when every tube is that constructor; else stuck.
- **Glue / glue / unglue.** A `Glue` with a true face is that partial type;
  with no live face it is its base. A `glue` with a true face is that
  section; with none it is its base. `unglue(glue(x, ..)) ↦ x`; `unglue`
  of a value whose (annotated) Glue type has a true face is the
  equivalence's function applied; when the type is not a Glue, `unglue g
  ↦ g`.
- **A match on a path constructor** applied to dimensions: the arm at the
  fields, then at the dimensions. **A match on an hcomp cell** of the
  family: the eliminator composes along its motive over the filler.
- **A checked def unfolds to its elaborated tree** (`Def.w`); a productive
  def stays folded under `WNF_LAZY`.

### 1.4 Conversion (`term_compare`)

- Two interval terms are convertible iff they agree under every valuation
  of their atoms in the four-element De Morgan algebra DM4 (at most 8
  atoms). DM4 generates the variety of De Morgan algebras, so this is
  exactly equality in the free De Morgan algebra, the CCHM interval. A
  two-valued table would also validate `i /\ -i == i0`, which the interval
  does not have; `bend2/cubical.lean` proves the difference and the
  soundness of the folds (Evidence 7).
- `{==}` against a path lambda: the lambda must be a constant path.
- Same-head shortcut: the same definition at convertible arguments is
  convertible before either unfolds (a corecursive def would unfold
  forever).
- Both sides are run through `term_pend` after `term_wnf`: a raw goal's
  variable- or reference-headed spine applied to an endpoint reads that
  endpoint off the head's type, inferred in the context.
- Structural cases for `Itv`, `Glu`, `Gle`, `Ung`, `Hcm`, `Coe`; `All`
  extends the context under its binder; every recursive call threads `ctx`.

---

## Evidence 2. The checker, every hunk (`bend2/bend.ts`)

Each entry names the hunk by its upstream anchor (`@-N`, the line in the
unpatched file) and its position in `cubical.patch` (`patch:L`), then says
what the lines do and why they exist. Hunks are in file order.

### 2.1 Syntax and constructors

**`@-292` (patch:3) — the term union.** `Ann` gains an optional flag `a?:
Bool` ("by the checker"): the checker's own annotations (`Infer`/`Check`
wrappers) are marked `a: true`, so later passes can tell an annotation the
checker placed (whose type may be read as a fact) from one the user wrote
(which is a claim to be checked). Ten term forms are added: `Itv`, `Dim`,
`Ineg`, `Imin`, `Imax`, `Coe`, `Hcm`, `Glu`, `Gle`, `Ung`, with the field
names used throughout (`Coe.A` line, `.r` from, `.e` to, `.x` value;
`Hcm.A` type, `.x` base, `.sys` faces; `Glu.A` base, `.sys` of `GFace`;
`Gle.x` base, `.sys` of `Face`; `Ung.g`). Two record types are introduced:
`Face<T> = { f: Array<[T, 0|1]>; u: T }` (a conjunction of constraints "r
== i_d", and the term it cuts) and `GFace<T> = { f, T, e, q? }` (a partial
type, its equivalence, and optionally the pair of kind quantities the
equivalence was checked at, recorded by `infer-glue` so reduction can
project it with the right `Kinds`).

**`@-303` (patch:26) — declarations.** `Ctr.p?: number` is a constructor's
path dimension (0 or absent for an ordinary constructor). `Def` gains `w?:
HTerm` (the memoized running body built from the elaborated tree), `o?:
Array<[Name, Name]>` (a template's opaque constants paired with their
binder names, for closing the tree over them), and `c?: Bool` (marked
corecursive).

**`@-333` (patch:39) — the machine.** `LHS.g?: "ctr" | "delay"` is the
guard state of the check in progress: `"ctr"` under a constructor's
fields, `"delay"` under a lambda that is itself under a constructor (a
delayed field). The `MAT` frame gains `T?: HTerm`, the type annotation the
matched term carried, so a match on an `hcomp` cell can find its motive.

**`@-431` (patch:52) — constructors.** `Ann` takes the flag. Smart
constructors `Itv`, `Dim`, `Ineg`, `Imin`, `Imax`, `Coe`, `Hcm`, `Glu`,
`Gle`, `Ung`, and the two mappers `face_map`, `gface_map` that apply a
function to every term inside a system (used by every traversal below).

**`@-465` (patch:111) — `Infer`/`Check`.** Both wrap the elaborated term in
an annotation flagged `a: true`.

### 2.2 Higher/lower and the book

**`@-706`, `@-714`, `@-733` (patch:125, 134, 143) — `term_higher` with
`keep`.** A third parameter `keep: boolean` makes an unbound variable stay a
`Var` (with its index) instead of becoming a `Ref` by name. The runtime
elaboration needs this: it lowers terms above every index in use
(`1 << 24`), rebinds some variables and must keep the rest as variables, not
turn them into references to nonexistent definitions. Every recursive call
threads `keep`. The `App` case is also changed: the beta step now reads
through a checker annotation (`Ann` with `a: true`) and through a share
cell (`Var` with `i < 0` and a value) before testing for a `Lam`, so that
the elaborated tree, in which every lambda is annotated, still beta-reduces
when rebuilt; a user annotation is not read through ("an annotated lambda
applied is checked at its annotation"). The ten new forms are traversed.

**`@-872` (patch:279) — `term_lower`.** `Ann` keeps its flag; the ten new
forms are traversed.

**`@-972` (patch:316) — the family of a constructor, and path
constructors.** `book_fam` now normalizes with `term_wnf` rather than
`term_strip` and, on reaching an `Eql` tip, descends through the path
type's carrier (and through a line, applied at the sentinel) to find the
family: a path constructor's tip is `{a == b : K<..>}` or `{a == b : i =>
{.. : K<..>}}`, and the family is `K`. Three helpers are added:
`eql_carrier(book, t)` walks the same way from any type and returns the
`ADT` or `null`; `ctr_tip(book, ctr, xs)` instantiates a constructor's
telescope at unknown parameters (`Var("?", DUMMY_I)`, parameters are
erased from a constructor) and the fields `xs`, returning the tip;
`ctr_face(book, ctr, xs, rs)` applies the tip to the dimensions `rs` and,
at the first literal one, returns the corresponding face (`a` at `i0`, `b`
at `i1`) applied to the remaining dimensions, or `null` when the face
mentions the unknown parameters (then the face is not computable from the
constructor alone and is left stuck).

**`@-1480` (patch:391) — `term_show`.** The printer for the ten forms:
`Interval`, `i0`/`i1`, `-r` at precedence 12, `/\` at 11, `\/` at 10,
`coe(..)`, `hcomp(A, x, [(r == i0) u, ..])`, `Glue(..)`, `glue(..)`,
`unglue(..)`. These are the spellings the error messages print.

### 2.3 The parser

**`@-1532` (patch:433) — keywords.** `Interval i0 i1 coe hcomp Glue glue
unglue` are reserved.

**`@-1799` (patch:441) — atoms.** `Interval`, `i0`, `i1`; `coe(` takes
exactly four comma separated terms (else "coe(A, r, s, x) with four
arguments (a line i => T, two endpoints and a value)"); `hcomp(A, x, sys)`;
`Glue(A, sys)` where each face's body is a parenthesized pair `(T, e)`;
`glue(x, sys)`; `unglue(g)`.

**`@-1857` (patch:504) — prefix `-`.** In term position a leading `-` is
interval negation at precedence 12. In a telescope or a `let`, `-` still
heads a binder as upstream's quantity marker (the parser reaches this case
only in `parse_term_base`, where a quantity is not expected). This is why
negation is `-r` and not `~r`: upstream pins parse errors for `~` and `!`
in tests, and those pins are untouched.

**`@-2158` (patch:518) — infix `/\` and `\/`.** Added to the operator loop
at levels 11 and 10, above upstream's `&` (`Min`) and below the arithmetic
operators, right-nesting like the rest.

**`@-2184` (patch:535) — `parse_faces`.** The generic system parser: `[`,
then zero or more `( constraints ) body`, each constraint `l == r` with one
side a literal dimension (either order; else "a face (r == i0 or r ==
i1)"), commas optional between constraints and between faces, `]`. The
`body` is a callback so `hcomp`/`glue` (a term) and `Glue` (a pair) share
it.

**`@-2589`, `@-2596` (patch:579, 592) — `path` constructors in `type`.** In
a `type` block, a line beginning with the word `path` followed by a name
declares a path constructor: after its field telescope and a `:`, its tip
is parsed as a term, and its dimension is counted as the number of nested
`Eql`s through their carriers (a lambda carrier is entered). A `path`
constructor whose tip is not an `Eql` is refused ("a path type {a == b :
K<..>} (a constructor's tip)"). The constructor record carries `p: dim`;
an ordinary constructor's tip stays `ADT(k, params)` with `p: 0`. The
regular-expression guard (`/^path\s+[A-Za-z_]/`) keeps a constructor that
happens to be *named* `path` working.

### 2.4 `term_wnf`, the frame machine

**`@-2856` (patch:615) — two module-level switches and the variable case.**
`WNF_CTX: Ctx | null` is the context of the check in progress (set by
`term_infer`/`term_check` around their bodies, see `@-3274` and `@-3466`):
when a *variable* (index `i >= 0`, no value) is at the head and the top
frame is an application to a literal dimension, its type is looked up in
that context and, if it is a path type, the endpoint is taken. This is how
a raw goal such as a law's statement `p(i0)` computes without the goal
having been elaborated. `WNF_LAZY: boolean` makes a productive (`Def.c`)
definition stay folded (see `@-2950`); it is set by `term_snf`'s lambda
case and `term_compare`'s eta case. A local `matT` remembers the annotation
a `Mat` was found under so the `MAT` frame can carry it.

**`@-2875` (patch:660) — annotations, path constructors, the interval, and
the Kan forms.**
- `Ann`: an annotated term applied to a literal dimension steps to the
  endpoint read off the annotation when it is a path type; a `Mat` under
  an annotation records the annotation in `matT`. Then the annotation is
  dropped and evaluation continues into the term, as upstream did.
- `Ctr`: a path constructor (`Ctr.p > 0`) applied to up to `p` dimensions
  asks `ctr_face` for its face at the first literal one and steps to it.
- `Ineg`, `Imin`, `Imax`: the De Morgan constant folds listed in III.3
  (`--r ↦ r` included), leaving a normal form over atoms otherwise.
- `Coe`: `coe_step`, else stuck. `Hcm`: `hcm_step`, else stuck.
- `Glu`: a true face is its type; dead faces are filtered; an empty system
  is the base.
- `Gle`: likewise with sections and the base value.
- `Ung`: `unglue(glue(x, ..)) ↦ x`; otherwise the argument is *forced* (not
  normalized) to find its annotation: if the annotated type is a `Glue`
  with a true face, the result is `Equiv.fun(e)(g)` with the face's
  recorded `Kinds` (or `KINDS_TYPE`); if the type is not a `Glue` at all
  (the Glue reduced away), `unglue` is the identity; else stuck.

**`@-2912` (patch:825) — the `MAT` frame.** Carries `T: matT` and resets
it.

**`@-2929` (patch:839) — J.** `Rwt` steps to `f` when the evidence is `{==}`
*or* a lambda whose body at the sentinel does not mention it (a constant
path). A non-constant path lambda becomes the transport along the
connection square: `coe(i => P(e(i), j => e(i /\ j)), i0, i1, f)`. Note the
motive `P` takes the endpoint and the path to it, in that order, as
upstream's `Rwt.p` is `_ => e => P`.

**`@-2950` (patch:858) — `Ref` unfolding.** A reference stays stuck when
`WNF_LAZY` is on and the def is corecursive. Otherwise a checked def
unfolds to `tld.w ??= def_body(tld.e, tld.x, tld.o)`, its elaborated tree
closed over its templates' opaque constants, and a def without a tree
(Base's natives, a bodiless law) unfolds to `tld.v` as before.

**`@-3010` (patch:876) — matching on a HIT.** Inside the `MAT` frame's back
step, before the ordinary constructor case: (1) if the scrutinee is a path
constructor applied to exactly its dimensions, the chain of arms is walked
to the arm of that constructor and the arm is applied to the fields, then
to the dimensions (frames pushed in reverse order so they pop in order);
if the arm is absent the match is re-applied stuck. (2) If the scrutinee is
an `hcomp` cell and the frame carries the motive's type `T` (an `All`),
the eliminator `E` commutes with the composition: the result is
`hcomp(P(cell), coe(i => P(hfill_i), i0, i1, E(x)), [ (f) i => coe(line, i,
i1, E(u(i))) ])`, the standard rule for eliminating a composite (the
filler `hfill_at` is the composite with an extra face `j == i0 ↦ x`).

**`@-3092`, `@-3122` (patch:932, 947) — `term_snf`.** The strong normalizer
sets `WNF_LAZY` while normalizing a lambda's body (a corecursive value
prints one unfolding); the ten forms are traversed.

### 2.5 The running body and the compiler-facing passes (patch:947 continued)

This is the largest hunk (948 lines). It holds, in order:

**`term_prune(tm)`.** Drops annotations at a kind (`Typ`, `Qnt`), which
would otherwise weaken a type's own kind (`U32 : Data` annotated `Type`),
and keeps every other annotation: a path needs its endpoints, and the
compiler needs its layouts.

**`def_body(e, x, os)`.** Builds `Def.w`: the elaborated tree `e` is raised,
lowered at depth `x` (the number of `~` binders the tree was checked past),
pruned, and, for a template, its opaque constants are turned back into
variables (`term_refsub`) and closed under `x` leading lambdas named after
the binders; the result is raised again. A template thus unfolds to the
tree it checked, not to its raw body.

**`term_unpath(book, tm, d, mint)`.** The compiler-facing rewrite of a
checked tree (called from `comp.ts`'s `def_body`):
- an annotated lambda, constructor or `{==}` at a path type is *erased*
  to `{==}` (a zero box), unless the path is in a universe, in which case
  the value is its equivalence: `Equiv.id(q, A)` for `{==}`, and
  `Equiv.of_path(q, A, B, lam)` for a lambda, run through `kan_run` so
  the `coe` inside `Equiv.of_path` becomes code;
- an application to a literal dimension whose function carries a path
  annotation is the endpoint (lowered at the tree's depth and annotated
  with the carrier at that dimension); a lambda result is returned bare
  because the enclosing code applies it;
- an application to a literal dimension whose head is a path constructor
  is its boundary, computed by `term_wnf` (an endpoint read off an
  annotation arrives unannotated, so it is asked again here: this is the
  torus corner `surf{}(i1)(i0)`);
- everything else is traversed structurally.
A path applied to a dimension *variable* stays and is refused by the
compiler by name.

**Runtime transport: `Mint`, `mint_new`, `term_open`, `term_ann`,
`path_in_type`, `kan_die`, `term_frees`, `term_rebind`, `mint_adt`,
`kan_run`, `kan_run_go`, `kan_walk`, `term_uncoe`.**
- `Mint` is the minting state: the book (the minted defs are added to it),
  a global memo (closed lines) and a per-def local memo (open lines), and
  a counter for names `coe~0`, `coe~1`, …
- `term_open` says whether a term has a free variable with an index below
  the sentinel; `term_ann` reads the annotation a term carries through its
  share cells; `path_in_type` recognizes `{A == B : Kind(q)}` and returns
  `A`, `B`, `q`.
- `kan_die` is the compiler's refusal, with the note "a path in Type has
  no runtime value; transport along ua(e), a line of datatypes, functions
  or paths compiles, a variable path in Type does not."
- `term_frees` collects the free variables of a term with the type each is
  annotated at (annotations are the only source of types after lowering,
  so a variable seen under an `Ann` records that annotation's type;
  indices `>= 1 << 24` are the lowering's own and are skipped).
  `term_rebind` re-binds a chosen set of them.
- `mint_adt(m, L, r, s, adt)` mints the structural transport along a
  datatype line `L` from `r` to `s`. The key is the line's body at the
  sentinel plus the endpoints; open lines memoize locally. The free
  variables of `L`, `r`, `s` become leading parameters (a type among them
  erased); a free variable without an annotated type, or a live one that
  is affine (a universe path or a function: the transport is pushed into
  every field and would spend it once per field) is refused with "pass it
  as a ~ template". The def's type is `@vs.. -> @x:L(r) -> L(s)`; its body
  is a match with one arm per *point* constructor (path constructors are
  skipped: they are erased at runtime), each arm a lambda over the fields
  that rebuilds the constructor with every field transported along its own
  line (the telescope at the parameters of `i`, opened on the earlier
  fields carried to `i`, exactly `coe_step`'s rule), each field's `coe` run
  through `kan_run` recursively (so a recursive line reaches the def
  itself through the memo). Arms and the result are annotated with their
  types so the compiler can lay them out. The def is registered twice:
  first with an `Efq` body so the recursive `kan_run` finds the name, then
  with the real body and its lowered tree `e`.
- `kan_run(m, t)` runs one Kan node to code. It first reads the node's own
  type (`A(s)` for a `coe`, `A` for an `hcomp`); if that type is a path
  type, the node is *evidence*: erased to `{==}` unless it is a universe
  path, in which case it is `Equiv.of_path` of the node. Otherwise
  `kan_run_go` runs it and the result is annotated with the type.
- `kan_run_go` after `term_wnf`: a `Coe` whose line is a universe *path
  variable* applied to the dimension (recognized by applying the line to
  the sentinel and finding `p(SENT)` with `p` annotated at a universe path)
  becomes `Equiv.fun(p)` (from `i0` to `i1`) or `Equiv.inv(p)` (from `i1`
  to `i0`) applied to the transported value, the identity when `r ≡ s`,
  and a refusal at a non-literal dimension; a `Coe` whose line's body is a
  datatype becomes a call of the minted transport; any other `Coe` is
  refused with the body shown. An `Hcm` or `Gle` with every face dead is
  its base; with an undecided face it is refused. `Ung` is refused (its
  type was not decided). `Rwt` is J as transport and recurses. Anything
  else is walked.
- `kan_walk` walks a term running its Kan nodes and erasing evidence: an
  annotation at a non-universe path type is replaced by `{==}` (so
  `kan_run` never descends into erased evidence, which is what an `hcomp`
  with an undecided face inside a proof needed), a universe path is left
  for `term_unpath`.
- `term_uncoe(m, e)` is the entry point: if the tree has no Kan node it is
  returned unchanged (no cost for ordinary code), else it is raised with
  `keep`, walked, and lowered.

**The interval: `SENT_I`, `SENT`, `term_sent`, `term_mentions`,
`term_names`, `itv_is`, `itv_key`, `itv_atoms`, `itv_eval`, `itv_eq`.**
`SENT = Var("i", 1 << 30)` is the sentinel dimension a line is opened at.
`term_sent` substitutes it. `term_mentions(t, i)` asks whether a term
mentions a variable index (default the sentinel); `term_names(t, k)`
whether it mentions a family or definition by name (used by positivity and
transportability). `itv_eq` decides equality in the free De Morgan algebra:
collect the atoms of both sides (any stuck non-interval term, keyed by its
syntax, a variable by its index), and evaluate both sides under every DM4
valuation of at most 8 atoms (`DM4_MIN`, `DM4_MAX`, `DM4_NEG` are the
algebra's tables, `0 < a, b < 1`, `a` and `b` each its own negation); more
atoms are conservatively unequal.

**`coe_line`, `coe_step`.** `coe_line(A, f)` builds the line `i => f(A(i),
i)`. `coe_step` is III.3's transport, case by case; two details matter:
the `All` case transports the argument *backwards* first (`coe(dom, s, r,
y)`) and the codomain line is opened on the argument carried to `i`; the
`Eql` case's reparametrization is `(-i /\ r) \/ (i /\ s)`, which is `r` at
`i0` and `s` at `i1`, so the composed path's faces are the endpoints'
transports along the original line. The `Glu` case is the CCHM
`transpGlue`: with `at(i)` reading the Glue at `i` (base and live faces),
`aR0` is the base at `r` (the value itself if no face is live there, the
equivalence's function applied on a true face, `unglue` otherwise),
`a1p = coe(base line, r, s, aR0)`, `t1 = Equiv.inv(e)(a1p)` on each face
live at `s`, and the base is corrected by an `hcomp` whose tubes are the
sections `Equiv.sec(e)(t1)(-j)`, then glued with the `t1`s. The `ADT` case
handles an `hcomp` cell (transport commutes with composition), a path
constructor applied to dimensions (fields transport, dimensions stay),
and the fieldwise rule.

**`face_holds`, `face_dead`, `hfill_at`, the `Equiv` helpers, `transp_equiv`,
`hcm_step`.** `Kinds = [HTerm, HTerm]` are the two kind quantities an
`Equiv` is instantiated at, `KINDS_TYPE` both `&1`. `equiv_ty(q, T, A)` is
`Equiv(q0, q1, T, A)`; `equiv_fun/inv/sec` are Base's projections applied
(so a stuck projection of a variable equivalence is the same term the user
writes, and the checker's and the runtime's notions coincide).
`transp_equiv(u)` is the equivalence `u(i1) ≃ u(i0)` obtained by carrying
`Equiv.id` along `k => Equiv(u(i1), u(-k))`. `hcm_step` is III.3's
composition; the `Typ` case is the Glue with `T = u(i1)` and `e =
transp_equiv(u)` per face; the `Glu` case builds the base composite with
the unglued tubes plus, per partial type, a face forcing the image of the
partial filler, and glues the partial composites.

**`term_subst(ctx, t, d, sub)`.** A term under a substitution of some
context variables: lowered at depth `d` and rebound, each unsubstituted
variable to itself (named from the context's scope).

### 2.6 Conversion

**`@-3139` (patch:1896) — `term_pend` and the head of `term_compare`.**
`term_pend` is described in III.4: it infers the head's type in the
context (`term_infer` with an empty LHS, errors swallowed), walks the
spine through `Eql` (taking the endpoint at a literal and the carrier's
line otherwise) and `All` (instantiating), and recurses on what results.
`term_compare` gains a `ctx` parameter (default empty), the same-head
shortcut, `term_pend` on both sides, the interval case, the `{==}` against
path lambda case, and `WNF_LAZY` around the eta case. **`@-3173`, `@-3192`,
`@-3214`, `@-3242` (patch:1986–2103)** thread `ctx` through every recursive
call, extend it under `All`, and add the structural cases for `Itv`,
`Glu`, `Gle`, `Ung`, `Hcm`, `Coe` (faces compared constraint by
constraint, literal and term).

### 2.7 Inference

**`@-3274` (patch:2116) — `term_infer` wraps `term_infer_go`** setting
`WNF_CTX` for the duration.

**`@-3331` (patch:2133) — `Ref`: foreign calls and guarded self-calls.**
Two additions in the reference case, after template instantiation. (1)
When the reference is a foreign def with a saturated spine, its return type
is instantiated at the arguments and, if it is `IO(P)` with `P` not
transportable, the call is refused ("a transportable payload at this
foreign call …"): this is the call-site half of #874, for polymorphic
foreign defs. Note `term_strip`, not `term_wnf`: `IO` is itself a def and
must not be unfolded before its head is read. (2) The descent check is
relaxed by the guard: a self-call is *guarded* when the LHS is in `"delay"`
state, the call is saturated, and every extra argument is a literal
dimension or a variable of type `Interval` (so the delayed field is
observed at most through dimensions, never eliminated). A guarded
non-decreasing self-call is accepted and marks the def corecursive; the
error message for the unguarded case is upstream's, verbatim.

**`@-3382` (patch:2175) — `All`'s kind, and the six new inference cases.**
`infer-all`: if the codomain (at a fresh variable) is an `Eql`, the kind is
`Data` (the positivity side of this is in `book_valid`, `@-3822`). Then `Itv`, `Dim`, `Ineg`, `Imin`/`Imax`, `Coe`, `Hcm`, `Glu`,
`Ung` exactly as III.2 states them. In `Coe`, a line written `i => T` is
checked at `Interval -> Type` at the ambient demand `qt`; anything else is
inferred and must have a universe path type. In `Hcm`, tubes are checked at
demand `qt` against `Interval -> A[σ]`, the `i0` agreement and the pairwise
agreement on overlapping faces are conversion checks with the two
substitutions merged (a pair of faces that fix the same variable to
different literals does not overlap and is skipped), and the uses of the
tubes are joined (`quant_join`, like match arms) then added to the base's.
In `Glu`, the base's kind `qA` is inferred and each partial type is checked
at `Kind(qA)`, each equivalence at `Equiv(qA, qA, T, A[σ])` at demand `qt`,
and the pair `[qA, qA]` is lowered and recorded in the face.

**`@-3403` (patch:2321) — `App`: path application and the guard reset.**
If the function's type is an `Eql`, the argument is checked dead at
`Interval` and the result type is the carrier at that dimension. Otherwise
the argument is checked with the guard cleared (`g: undefined`): an
argument position is an elimination, never a delay.

**`@-3426` (patch:2343) — `Eql`.** The carrier may be a line (a lambda), in
which case it is checked at `Interval -> Type` and the endpoints at its
ends; the kind is `Type` when the carrier (at the sentinel) is a kind, else
`Data`.

**`@-3449` (patch:2367) — a parameterless family's path constructor
infers**, so that `loop{}` can appear in inference position. Then
`face_check` (each constraint checked dead at `Interval`, and the
substitution of the variables it fixes) and the module-level `MAT_TOP`,
the eliminator a residual match chain belongs to (set while the rest of a
match is checked, so that a later arm's path goal uses the *full*
eliminator, not the chain from that arm on).

### 2.8 Checking

**`@-3466` (patch:2410) — `term_check` wraps `term_check_go`** setting
`WNF_CTX`.

**`@-3481` (patch:2427) — `check-glue`, path constructors applied, and
`check-path`.** `Gle` against a `Glue` type: the base is checked at the
base type; each section's face must match a face of the type (by `itv_eq`
on each constraint); the section is checked at the partial type under the
face's substitution; `Equiv.fun(e)(t) ≡ x` under it; every face of the type
must have a section. `App` with a path constructor head applied to at most
its dimensions, at a goal in its family (an `ADT` or a path type whose
carrier is the family): the fields are checked against the telescope at
the carrier's parameters, each dimension is checked dead, the type is
walked through the `Eql`s, and the result is compared `LE` against the
goal; every intermediate application is annotated (so the tree can read
its faces). `Lam` against an `Eql`: `check-path` as III.2 says; the
dimension is bound `+` (a dimension may be mentioned any number of times)
and dropped from the uses; both faces are checked by conversion with the
note "the path's face at i0 must be that endpoint". The ordinary `Lam`
case sets the guard to `"delay"` when a guard is active (a lambda under a
constructor is a delayed field).

**`@-3515` (patch:2534) — `Let`** clears the guard for its values.

**`@-3538`, `@-3554` (patch:2543, 2568) — `Ctr`.** Against a path type: the
constructor must be a path constructor whose family is the carrier; fields
checked against the telescope at the carrier's parameters; the tip compared
`LE` to the goal. The ordinary case passes the guard `"ctr"` (or keeps
`"delay"`) into the fields.

**`@-3603`, `@-3618` (patch:2577, 2621) — `check-mat` with path arms.** For
a path constructor the arm's goal is `path_goal(tip, c{xs})`: for a tip
`{a == b : L}` it is `{lift(a) == lift(b) : i => path_goal(L(i), c{xs}(i))}`,
nested once per dimension, where `lift` applies the eliminator at an
endpoint (through the match when it computes, else as the definition's
own stuck self-call `lhs.t(a)`, the same term the arm's recursive calls
are). The eliminator `top` is the match itself when it is the first arm or
`MAT_TOP` for a residual chain; `MAT_TOP` is saved, cleared for the arm,
set to `top` for the rest, and restored.

**`@-3633`, `@-3663`, `@-3678` (patch:2643–2670)** pass `ctx` to the three
conversion checks in `Rfl`, `Rwt` and the fallback.

### 2.9 Definitions, transportability, validation

**`@-3696` (patch:2670) — `def_check` and `term_refsub`.** A `~` binder's
opaque constant is named `k~name`, or `k~j~name` when an earlier binder has
the same name (#905). The pairs are recorded in `Def.o`, and the body is
checked at depth `def.x` so that `def_body` can close the tree over the
binders. `term_refsub` replaces each opaque constant `Ref` by the variable
of its binder.

**`@-3780` (patch:2733) — `term_transportable`.** The foreign-payload rule,
case by case: a kind is transportable; a function is when its codomain
does not depend on the argument and is transportable; an equation is when
its carrier is not a kind and its ends are convertible; a datatype is when
it has at least one constructor, no path constructor, and every *live*
field of every constructor (at the parameters given) is transportable
(recursion through a family already being examined is allowed);
quantities are; a type variable is (the instantiating call is checked);
an application headed by a bodiless Base law (a handle such as `Chan(A)`)
is; anything else is not.

**`@-3822` (patch:2807) — `book_valid`, ADTs.** After each field is
kind-checked, a field that is a function whose inferred kind is copyable
(`Many`) and whose domain mentions the family is refused as a non-positive
occurrence. A telescope tipped at a path type is a path constructor: the
tip is checked as a type at the constructor's depth and its carrier must
be the family at its own parameters.

**`@-3856` (patch:2839) — `book_valid`, foreign defs and corecursion.** A
foreign def's `IO(P)` payload must be transportable (the declaration half
of #874). After `def_check`, a def marked corecursive during its check
copies the mark (`dec.c`) into the definition kept in the book.

---

## Evidence 3. The compiler, every hunk (`bend2/comp.ts`)

**`@-793` (patch:2867) — children.** The tree walker that lists a node's
live children knows the Kan forms: a `coe`'s value, an `hcomp`'s and a
`glue`'s base and tubes, an `unglue`'s argument. (Types and dimensions are
not children: they are dead.)

**`@-908` (patch:2878) — `ty_wnf`.** A type that is a universe path is laid
out as `Equiv(q, q, A, B)`: the compiler sees a pair of closures (a boxed
record) wherever the checker sees `{A == B : Kind(q)}`. This single line
is what makes a universe path a value on every lane.

**`@-945` (patch:2897) — `ty_clo`.** `Interval` and `Glue` are types that
hold no closure (a dimension is dead; a Glue's runtime value is its base's
or a section's, decided before emission).

**`@-1055` (patch:2906) — a diagnostic.** "a constructor outside a
datatype" now names the constructor and the type it was found at.

**`@-1063`, `@-1659` — `adt_copies` and the take rule.** `adt_copies(book,
k)` says whether the family of constructor `k` is `Data`-kinded (its
declared kind, read off its telescope's tip; an unknown family counts as
copyable). In `node_fields`, an owned node (`brwl` has no root for it) is
taken through `ctr_take` when its constructor is hot, static, *or its
family copies*. The checker allows a value to be used more than once only
at a `Data` type, so a `Type`-kinded family (closures inside) is never
shared and its raw read is provably safe; every `Data` node goes through
the tag check, so the hot walk can no longer cause a raw read of a shared
node. `ctr_take` on an unshared node is the raw read plus one branch;
upstream's `bfs`, `queens` and `tree-matmul` benches, sequential, are
within 1% of upstream after the change.

**`@-1406` (patch:2915) — `def_body` runs the two passes.** A module-level
`Mint` is bound to the book being compiled, its local memo reset per def,
and the tree handed to the emitter is `term_unpath(term_uncoe(e))`: Kan
nodes to code, paths to evidence or equivalences. Minted `coe~n` defs land
in the book and are compiled like any other def.

**`@-1699` (patch:2931) — `facts_hot` walks nested matches.** The fix for
#901: when the type being heated is a `Mat` (a match stuck on an open
scrutinee) and heating is forced, every arm and the end of the chain are
heated as types. Before, `facts_fam` walked only the outer arms of a
family's body, and a family over two indices (`match r c`, a nest) never
heated its inner constructors.

**`@-2461`, `@-3130` (patch:2947, 2955) — refusals.** A `Coe`, `Hcm`, `Gle`
or `Ung` reaching the C or JS expression emitter is a bug in the passes
above, refused with "a live coe, hcomp or glue (transport is checked and
interpreted, not compiled yet)".

**`@-3141` (patch:2963) — a diagnostic.** "an untyped lambda" prints the
lambda.

---

## Evidence 4. The Base library (`bend2/base.bend`, `@-419`, patch:2974)

A `# Cubical` section after `Equal.*`. Every def takes the kind
quantities of its carriers as leading arguments (`a`, `b`), so that the
same definitions serve `Data` and `Type` carriers, and so that
`isContr` over `Data` is itself `Data` (a proof function has its domain's
kind, Evidence 2).

| def | statement | notes |
| --- | --- | --- |
| `isContr(a, -A)` | `&c:A -> @w:A -> {c == w : A}` | a Sigma with a proof-valued second component |
| `fiber(a, b, -A, -B, f, y)` | `&x:A -> {f(x) == y : B}` | |
| `isEquiv(a, b, -A, -B, f)` | `@y:B -> isContr(fiber f y)` | |
| `Equiv(a, b, -A, -B)` | `&f:(A -> B) -> isEquiv f` | a pair of closures: `Type` |
| `isContr.centre`, `isContr.contr` | the projections | by tuple match |
| `Equiv.id.contr(a, -A, -y, w)` | `(y, {==}) == w` in the fibre of the identity | the path `i => (p(-i), j => p(-i \/ j))`, a connection |
| `Equiv.id(a, -A)` | `Equiv(A, A)` | `(x => x, y => ((y, {==}), contr))` |
| `Equiv.fun`, `Equiv.inv.at`, `Equiv.inv`, `Equiv.sec.at`, `Equiv.sec` | the function, its inverse (the centre of the fibre), and the section `f(inv(y)) == y` | these are what `equiv_fun/inv/sec` in bend.ts apply |
| `Equiv.iso.fill0`, `.fill2`, `.sq`, `.sq1`, `.lem`, `.contr` | the proof that an isomorphism has contractible fibres | Cubical.Foundations.Isomorphism's `lemIso`, transcribed; `hfill` inlined as `hcomp` with the extra face; over `Data` carriers, the functions as `~` templates |
| `Equiv.from_iso(~A, ~B, ~f, ~g, ~s, ~t)` | `Equiv(&2, &2, A, B)` from `f`, `g`, `s: f(g(y)) == y`, `t: g(f(x)) == x` | `(f, y => ((g(y), s(y)), w => iso.contr(y, w)))` |
| `isContr.prop(-A: Data, +c0, +c1)` | `c0 == c1` | a four-face composite in the carrier |
| `isEquiv.prop(-A, -B, -f, h0, h1)` | `h0 == h1` | pointwise from `isContr.prop` |
| `ua(a, -A, -B, e)` | `{A == B : Kind(a)}` | `i => Glue(B, [(i == i0) (A, e), (i == i1) (B, Equiv.id(B))])` |
| `Equiv.of_path(a, -A, -B, p)` | `Equiv(A, B)` | `coe(i => Equiv(A, p(i)), i0, i1, Equiv.id(A))` |

Two consequences the tests pin: **ua-beta is definitional** for an
abstract equivalence, `coe(ua(e), i0, i1, x) ≡ Equiv.fun(e)(x)` (the
`Glue` line's transport at `i0` reads the face `(A, e)`, at `i1` the
identity); and the **round trip** `Equiv.of_path(ua(e)) ≡ e` holds with
the function by computation and the proof by `isEquiv.prop`.

---

## Evidence 5. Every test (`tests/cubical/`)

Each file is upstream's format. "Lanes" says where `run.sh` runs it:
every file on check + interpret; the ones marked C/JS also compiled.

| file | what it pins | expects | lanes |
| --- | --- | --- | --- |
| `funext.bend` | funext as a path lambda, symmetry `p(-i)`, congruence; the transported function runs | `S{S{Z{}}}` | interp |
| `coe.bend` | transport along a hypothesis path in `Type`, constant lines, `i => List<p(i)>` on a constructor, a `PathP` witness, a connection square with De Morgan faces | `([1n, 2n], 3n)` | interp |
| `j.bend` | J on non-constant paths (`Equal.trans`, `Equal.sym`) with computing faces; `coe` along a line of path types | `S{Z{}}` | interp |
| `hcomp.bend` | a hand-written square filler; a composite in `Nat` pushes into the literal | `2n` | interp |
| `must_fail_face.bend` | a path lambda whose face is not the endpoint | error `expected b / observed p(i0)` | interp |
| `must_fail_dead_coe.bend` | the wall: an erased `-p` does not transport a live value | error `expected -p / observed p` | interp |
| `ua.bend` | `ua` of an equivalence; transport along it is the function, by computation | `3n` | interp |
| `ua_round.bend` | `Equiv.of_path(ua(e)) ≡ e`, function by computation, proof by `isEquiv.prop` | `False{}` | interp |
| `fibre.bend` | the fibre law `A ≃ &b:B -> fiber f b` through `Equiv.from_iso`; `present = coe(ua(..), i0, i1)` is the factoring `a => (f(a), a, {==})` definitionally | `((False{}, True{}), True{}, False{})` | interp |
| `hit_circle.bend` | `S1`: faces of `loop`, eliminators, a loop-dependent one | `True{}` | interp |
| `hit_mustfail_loop.bend` | `loop` is not `{==}` | error `expected loop{} / observed {==}` | interp |
| `hit_quot.bend` | a set quotient with parameters; the recursor respects the relation by the path arm | `1n` | interp |
| `hit_trunc.bend` | propositional truncation, a recursive path constructor; the recursor into a proposition; the eliminator on an hcomp cell with a symbolic face | `Unit{}` | interp |
| `hit_susp_torus.bend` | transport along `Susp<ua(not)(i)>` pushes into `merid`'s field; the torus's two-dimensional `surf` with computing corners and edges; an eliminator with a two-dimensional arm | `True{}` | interp, JS, C |
| `stream.bend` | a stream as a record with a delayed tail; a guarded self-call; a bisimulation as a corecursive path; a corecursive value prints one unfolding | `([5n, 6n, 7n], mk{1n, _ => ones})` | interp |
| `stream_mustfail.bend` | a self-call under the delay but eliminated there is not guarded | upstream's descent error | interp |
| `positivity_mustfail.bend` | a copyable proof function may not take the family it is a field of | error "a positive occurrence of T" | interp |
| `compiled.bend` | a funext-transported function runs | `2` | interp, JS, C |
| `compiled_coe.bend` | transport along `List<ua(not)(i)>` flips every element (a minted transport); along a function line wraps the function | `[False, True, False]` / `True` | interp, JS, C |
| `compiled_fibre.bend` | the fibre law's `present` and `retrieve` at `f = not`, run | `False True True False` | interp, JS, C |
| `compiled_path.bend` | a universe path as a runtime argument, spent once; a stored trace replayed; a list line over a template path | `False True` / `[False, True]` / `True` | interp, JS, C |
| `issue_874.bend` (+ `issue_874.js`) | a foreign def returning `{Unit == F32 : Type}` is refused at the declaration | error, payload named | interp |
| `issue_874_false.bend` | a foreign def returning `{0 == 1 : U32}` is refused | error | interp |
| `issue_874_empty.bend` | a foreign def returning `Empty` is refused | error | interp |
| `issue_874_poly.bend` | `relay(T)` is declarable; the call at a path is refused | error at `main` | interp |
| `issue_905.bend` | `def cast(~T, ~x: T, ~T)` is refused with the two constants named | `expected cast~2~T / observed cast~T` | interp |
| `issue_852.bend` | a nat-literal pattern with fields is refused (upstream's fix, pinned) | error | interp |
| `issue_853.bend` | the reporter's program prints 5 on the C lane (upstream's fix, pinned) | `5` | interp, JS, C |
| `issue_901.bend` | the reporter's matrix product at depth 2 (upstream faults) | `64` | interp, JS, C |
| `j_index.bend` | what upstream already had, pinned as such: J transports a value along an index proof, and prints the same on both trees | `V{[7n, 8n]}` | interp |
| `proof_fn_copy.bend` | a proof-valued function over `Nat` is a `+` binder and a `Data` field (upstream: "expected Data, observed Type") | `Unit{}` | interp |
| `proof_fn_kind.bend` | a proof function over a domain of closures is `Data`: used twice and stored in a record (upstream refuses both) | `Unit{}` | interp |
| `demorgan.bend` | the De Morgan, absorption, idempotence and involution laws hold by conversion; `{==}` at `{i /\ -i == i0 : Interval}` is refused | error, `expected i /\ -i / observed i0` | interp |

`issue_874.js` is the whole host side of #874: `function forge_eql(kont) {
return { $: "Rfl" }; }`, a JavaScript function that returns the encoding
of `{==}`. On upstream this is accepted and the program transports `Unit`
to `F32` along it. On the fork the declaration is refused before any host
code is consulted.

---

## Evidence 6. How the numbers were obtained

**Cubical tests.** 33 of 33 from a fresh clone through `run.sh`. Seven of
them are built and run on the JS lane, and on the C lane when clang is
present: `compiled`, `compiled_coe`, `compiled_fibre`, `compiled_path`,
`hit_susp_torus`, `issue_853`, `issue_901`. The rest are checked and
interpreted.

**Upstream's interpreter-lane suite** (`proof check eval stuck halt grade
spec comptime flatten parse show printer base rfc state`, 931 files): 923
pass, 8 fail. Four fail identically on the unpatched tree (a stale
line-number pin in `check/template_inst_cycle`; `check/unsafe_loop`,
`check/unsafe_many`, `comptime/unsafe` time out on `@unsafe` loops). Four
are answers this port changes on purpose:

| test | upstream pins | the fork | the rule |
| --- | --- | --- | --- |
| `proof/no_funext_000` | funext is unprovable | provable: `i => x => add_zero(x)(i)` | check-path |
| `halt/strict_descent` | a self-call under a constructor is refused | `Sup{x => mk(x)}` is productive, accepted | guarded corecursion |
| `halt/duplicate_deferred` | refused by descent | refused one step earlier, by affinity (`x consumed more than once`) | the same program, an earlier wall |
| `grade/reject_leak` | refused for the leak | refused one step earlier: a universe-path field is not `Data` | Eql over a universe is `Type` |

**Upstream's io suite** (139 files, the JS lane through the interpreter):
every file prints what upstream prints.

**Upstream's compiled lanes** (JS and C, every Base program with a `main`
in `run`, `compile`, `io`, `check`, `eval`, `base`, `spec`; about 360
programs, each built twice): identical to upstream, with one added refusal:
`check/type_erased_runtime` has `main : {U32 == U32 : Type}`, a universe
path, which is an equivalence at runtime here and so, like a function,
"cannot be printed" by the compiled lanes (the interpreter still prints
`{==}`).

**Method.** The scratch harness runs `bun bend2/main.ts` on each file and
compares its `#|` lines (`exit N` lines dropped, trailing whitespace
trimmed) with the output; the compiled-lane harness builds `-o x.js` and
`-o x` (clang) and runs both. Baselines are the unpatched tree run the same
way, so a failure counts only when the two trees differ.

---

## Evidence 7. The mechanization (`bend2/cubical.lean`) and the trust boundaries

`bend2/cubical.lean` is checked by Lean 4.34 with no imports and no
`sorry` (638 lines). Upstream's `bend.lean` checks under the same
toolchain in about 90 seconds; the two are independent files.

**§1 DM4.** The four-element De Morgan algebra as an inductive with `neg`,
`min`, `max`; every lattice law (commutativity, associativity,
idempotence, absorption, distributivity, the bounds), the De Morgan laws
and involution, each by finite case analysis; and `not_boolean`: `a /\ -a
≠ 0`.

**§2 Interval terms and `Eq`.** `Itv` (atoms by number, `i0`, `i1`, `neg`,
`min`, `max`), evaluation under a valuation `Nat → DM4`, and `Eq r s := ∀
ρ, eval ρ r = eval ρ s`. `Eq` is reflexive, symmetric, transitive, a
congruence for the three operators, and every De Morgan law holds as an
`Eq` between terms. This is the specification of interval conversion;
`itv_eq` in bend.ts computes it (the citation, not proved here: DM4
generates the variety, Kalman 1958, so `Eq` is equality in the free De
Morgan algebra).

**§3 The folds.** `Fold` lists exactly the eleven rewrites `term_wnf`
applies in its `Ineg`, `Imin`, `Imax` cases; `fold_sound` proves each is an
`Eq`.

**§4 Why DM4.** `EqBool` is agreement under `{0, 1}` valuations only.
`Eq.toBool`: `Eq` refines `EqBool`. `eq_strictly_finer`: `i /\ -i` and
`i0` are `EqBool` but not `Eq` (the valuation sending the atom to `a`
separates them). This is why the procedure evaluates in DM4: a two-valued
table would accept `{==}` at `{i /\ -i == i0 : Interval}`, an unsound
judgemental equality.

**§5 Canonicity of the interval.** `Fold1` is a fold anywhere under the
operators and `Folds` its reflexive-transitive closure, both proved sound.
`closed_endpoint`: a closed interval term is `Eq` to `i0` or `i1`.
`closed_folds`: the folds reach that endpoint, which is what `term_wnf`
computes when it normalizes a face or a coe's endpoints.

**§6 The fragment.** `CTerm` (the fragment's nodes over opaque core
terms, dimensions de Bruijn), dimension substitution, faces with `Holds`
and `Dead` (`holds_not_dead`: exclusive), `Step` with the rules of Evidence 1.3
that need only the fragment (path beta, the endpoint rules off an
annotation, J on the constant path and J as transport along the
connection square, `coe` at equal endpoints or along a constant line,
`hcomp`/`Glue`/`glue` at a face that holds or with every face dead,
`unglue` of a `glue`), and `Has`, the typing rules of Evidence 1.2
parametric in the core's conversion and typing (`Judg`). The Kan rules by
type shape (the function and constructor cases of `coe_step`/`hcm_step`)
are stated in Evidence 1 against `bend.lean`'s core and not transcribed.

**The trust boundaries, after this work.** From the outside in:

1. *The source theory* (CCHM): a constructive model and canonicity exist
   in the literature; the port adds nothing the model does not have,
   except the affine kind of universe paths, which restricts, not extends.
2. *The checker*: `bend.lean` for the core; `cubical.lean` for the
   interval (proved) and the fragment's rules (specified). The residual
   trust is that the TypeScript matches the two files.
3. *The lowering*: reads decided by kinds (proved safe by the checker's own
   affinity), seals by the hot walk (complete over every syntactic form,
   fail-stop when wrong). The residual trust is the walk and the rest of
   the emitter, which is not a term of the language.
4. *The runtime*: the refcount cells, atomics and allocator, unstated.
5. *The host*: typed by transportability; delivers data, never evidence.

---

## Appendix A. How to run

```
cd collab/bend2-official-cubical
./run.sh [/path/to/work/dir]      # clones upstream at 6018e28, applies the patch, runs everything
```

To check one file against the patched tree in place:

```
bun bend2/main.ts tests/cubical/ua.bend            # check + interpret
bun bend2/main.ts tests/cubical/compiled.bend -o x.js && bun x.js
bun bend2/main.ts tests/cubical/compiled.bend -o x && ./x
```

## Appendix B. Hunk index

`bend2/bend.ts`: `@-292 @-303 @-333 @-431 @-465 @-706 @-714 @-733 @-872
@-972 @-1480 @-1532 @-1799 @-1857 @-2158 @-2184 @-2589 @-2596 @-2856 @-2875
@-2912 @-2929 @-2950 @-3010 @-3092 @-3122 @-3139 @-3173 @-3192 @-3214
@-3242 @-3274 @-3331 @-3382 @-3403 @-3426 @-3449 @-3466 @-3481 @-3515
@-3538 @-3554 @-3603 @-3618 @-3633 @-3663 @-3678 @-3696 @-3780 @-3822
@-3856` (54 hunks, all covered in Evidence 2).

`bend2/comp.ts`: `@-793 @-908 @-945 @-1055 @-1063 @-1406 @-1659 @-1699
@-2461 @-3130 @-3141` (11 hunks, Evidence 3).

`bend2/base.bend`: `@-419` (1 hunk, Evidence 4).

`bend2/cubical.lean`: a new file (Evidence 7).
