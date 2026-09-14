# General higher inductive types — the declaration schema

Every HIT the corpus uses is now ONE mechanism: a `type` declaration with
`path` clauses. The three constructors that were hardcoded into the compiler
(the set quotient, the circle, propositional truncation) are re-expressed
through it (`hit_quotient_suite.bend`, `hit_circle_suite.bend`,
`hit_truncation_suite.bend`, `hit_effective_suite.bend` are the suite's own
files rewritten on the schema, definitional for definitional, 23✓ for the
effectivity theorem). Cubical Agda's `data` with path constructors is no
longer needed for anything the corpus does.

## Syntax

```
type Pushout(A: Set, B: Set, C: Set, f: C -> A, g: C -> B):
  case @inl:
    a: A
  case @inr:
    b: B
  path @glue(c: C): Path(Pushout(A, B, C, f, g), @inl{f(c)}, @inr{g(c)})

type Torus:
  case @pt:
  path @p: Path(Torus, @pt, @pt)
  path @q: Path(Torus, @pt, @pt)
  path @surf: PathP(lambda i. Path(Torus, @p @ i, @p @ i), @q, @q)

type Quotient(A: Set, R: A -> A -> Set):
  case @cl:
    a: A
  path @eq(a: A, b: A, r: R(a, b)): Path(Quotient(A, R), @cl{a}, @cl{b})
  path @sq(x: Quotient(A, R), y: Quotient(A, R),
           p: Path(Quotient(A, R), x, y), q: Path(Quotient(A, R), x, y)):
    Path(Path(Quotient(A, R), x, y), p, q)
```

- `case @c:` followed by `name: Type` fields is a point constructor (as before).
- `path @c(fields): T` is a path constructor: `T` is a `Path`/`PathP` into the
  HIT of any nesting depth (its dimension). Fields may mention the HIT itself,
  including under function types (`f: Circle -> HTrunc(A)`, hub and spoke).
  Endpoints are arbitrary terms in the parameters and fields.
- A `type` with at least one `path` clause is a HIT; its type former is
  opaque (it does not unfold to a Σ), and constructor names are global.
- Constructors are written `@c{args}` (`@c` when there are no fields), and a
  path constructor is applied to intervals with `@`: `@glue{c} @ i`,
  `(@surf @ i) @ j`.
- Elimination: `hrec(x) { @c1: b1 ; @c2: b2 ; ... }` (the recursor, motive =
  the goal) and `helim(x, P) { ... }` (the dependent eliminator, motive `P`).
  A branch for a constructor with fields `f1..fn` is a function of the fields;
  for a path constructor it lands in the PathP over the motive whose
  endpoints are the eliminator on the declared endpoints. A branch may call
  the definition it lives in on the recursive fields (that is how the
  truncation branches are discharged: `sB(rec(x), rec(y), <i> rec(p @ i),
  <i> rec(q @ i))`).

## Typing

- `T(ps)` is checked against the declared parameter telescope.
- `@c{as}` is typed like every Bend constructor: against its goal. The
  parameters are read off the goal (`T(ps)` itself, or the `Path` type of a
  path constructor, peeled to the HIT). In an inferring position of a
  parametric HIT, annotate: `@glue{c}::Pushout(A, B, C, f, g)` — the
  annotation names the HIT and supplies the parameters.
- `hrec`/`helim`: the scrutinee's type must be `T(ps)`; every declared
  constructor needs exactly one branch; a point branch has type
  `fields -> P(@c{fields})`; an n-path branch has type
  `fields -> PathP(i. ... P(@c{fields} @ i ...)) (E lhs) (E rhs)`, nested to
  depth n, where `E` is this eliminator. The boundary agreement is therefore
  checked by the existing typed endpoint law, nothing HIT-specific.
- Declarations are checked: the telescope is a type and every constructor's
  closed Π-type is a type (so endpoints must inhabit the HIT).

## Reduction (checker and HVM4 full runtime alike)

- `@c{as} @ i0`, `@ i1`: the declared endpoint (with parameters and fields
  substituted). At a symbolic interval the constructor stays canonical.
- `hrec/helim(@c{as} @ i1 .. @ ik)` = the branch applied to the fields, then
  to the intervals.
- The eliminator commutes over superpositions (DUP-SUP, natively on the net).
- `helim` of an `hcomp` in the HIT is `comp` along the motive over the filler
  with the tubes eliminated (CCHM); `hrec` has no motive and stays stuck there.
- `coe` along a line `i. T(ps(i))` of a parametric HIT pushes into the
  constructors, each field carried along its own dependent type line; a HIT
  without parameters is rigid (identity), by the existing regularity check.
- Runtime (`--to-hvm4-full`): `#HT_T{ps}` is the type, `#C_T_c{ps, as}` a
  point, a path constructor is `#PLm{λi. @P_T_c(ps, as, i)}` with a generated
  `@P_T_c` that reduces at literal endpoints and is the canonical
  `#P_T_c{ps, as, i}` otherwise; a generated `@E_T` is the eliminator, with
  the `#HCm` case as `@compAt` over `@hfillAt`. Parameters a term does not
  carry are erased (`&{}`) at runtime.

## Files

| HIT | file | checks |
|---|---|---|
| circle | `hit_circle.bend`, `hit_circle_suite.bend` | rec/elim β on point and loop definitional; runs (`True`) |
| suspension, spheres | `hit_susp.bend`, `hit_sn.bend` | β-rules; `coe` through `Susp(ua(not) @ i)` pushes into `merid` |
| pushout | `hit_pushout.bend` | endpoints mention the parameters; annotated form |
| torus, Klein bottle | `hit_torus.bend`, `hit_klein.bend` | 2-path constructors; every literal corner definitional |
| set quotient | `hit_quot.bend`, `hit_quotient_suite.bend`, `hit_effective_suite.bend` | recursor into a set; effectivity `[a]==[b] ⇒ R a b` 23✓ |
| propositional truncation | `hit_trunc.bend`, `hit_truncation_suite.bend` | `isProp` by construction; recursor into a prop |
| set truncation | `hit_settrunc.bend` | 2-path constructor over recursive fields |
| hub-and-spoke truncation | `hit_ntrunc.bend` | function field into the HIT |
| must-fail | `hit_circle_mustfail.bend` | wrong boundary and missing branch rejected |

Still hardcoded and now redundant: `Quot/qcl/qeq/qsquash/qrec`, `S1/s1base/
s1loop/srec`, `Trunc/tin/tsquash/trec` — kept so the older suite files check
unchanged; their keywords are reserved, so a declared HIT cannot be named
`Trunc` or use `trec` as a definition name.
