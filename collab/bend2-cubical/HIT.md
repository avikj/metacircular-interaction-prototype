# The general HIT schema — `hit` declarations

**State: implemented, in the checker, the normaliser and the full runtime.
Eight files, 110 ✓ / 7 deliberate ✗; suite 96 files, bad = 0.** This closes
§D of REMAINING.md, the last substantive item on the cubical completeness audit.

Until now every higher inductive type was a hardcoded `Term` constructor
(SetQuotient, `S1`, `Trunc`): four to five constructors each, threaded by hand
through every traversal in the compiler. A new HIT cost a compiler pass. Now a
HIT costs a declaration:

```
hit Susp<A: Set>:
  case @north
  case @south
  path @merid(a: A): Susp/north(A) ~> Susp/south(A)
```

## Syntax

```
hit Name<p1: T1, p2: T2>:                 -- parameters: a dependent telescope
  case @tag(f1: A1, f2: A2)               -- point constructor (fields: a dependent telescope)
  path @tag(f: A): lhs ~> rhs             -- path constructor; lhs, rhs : Name(p1, p2)
```

A field whose type is headed by `Name` itself is *recursive*. Constructors,
type and eliminator are referred to by the generated names:

| generated | type |
|---|---|
| `Name` | `Π params. Set` |
| `Name/tag` (point) | `Π params. Π fields. Name(params)` |
| `Name/tag` (path) | `Π params. Π fields. Path(Name(params), lhs, rhs)` |
| `Name/elim` | `Π params. Π (P : Name(params) -> Set). Π (x : Name(params)). Π branches. P(x)` |

where the branch for a point constructor is
`Π fields. Π (ih : P(f) | f recursive). P(Name/tag(params, fields))` and the
branch for a path constructor is
`Π fields. Π ihs. PathP(λi. P(Name/tag(params, fields) @ i), ⟦lhs⟧, ⟦rhs⟧)`.
The *image* `⟦e⟧` of an endpoint under the eliminator is the point branch
applied to the fields (recursive arguments again by `⟦-⟧`) when `e` is a point
constructor, and the induction hypothesis when `e` is a recursive field.
Anything else is rejected at declaration time: its image would be the
eliminator itself, which is not in scope in its own branch's type.

Parameters are explicit everywhere (Bend2 has no implicit arguments); that is
what makes every constructor *inferable* rather than check-only.

## What it is, in the compiler

Four generic `Term` forms replace the per-HIT constructors:

| form | meaning |
|---|---|
| `HTy n ps` | the type `Name(params)` |
| `HPt n ps c fs` | a point constructor |
| `HPa n ps c fs` | a path constructor — a *path* value |
| `HEl n ps P x bs` | the dependent eliminator |

The constructor signatures live in the `Book` (`HitSig`, `HitCtor`), which now
carries a second map. Each constructor's whole telescope is stored as ONE
closed term, `hcTele = λ params. Π fields. END`, with END the type or the
path type with its endpoints. Instantiating a constructor is applying `hcTele`
to the parameters and peeling one Π per field (`hitInst` in `Core/WHNF.hs`);
the same object serves the checker (field typing, `checkTele`), the
normaliser (`hitEnds`: the endpoints of a path constructor) and the emitter.

Reduction (`Core/WHNF.hs`):

- `Name/tag(ps, fs) @ i0 ⟶ lhs`, `@ i1 ⟶ rhs` (`whnfPAp`, endpoints read off the
  instantiated telescope).
- `Name/elim(ps, P, Name/tag(fs), bs) ⟶ b_tag(fs, ihs)` and
  `Name/elim(ps, P, Name/tag(fs) @ i, bs) ⟶ b_tag(fs, ihs) @ i`, with each
  induction hypothesis the eliminator itself on the recursive field
  (`whnfHEl`); superpositions commute.
- `coe` along a line `λi. Name(ps(i))` whose PARAMETERS vary: a point
  constructor is rebuilt at the parameters of `P(s)` with every field
  transported along its own type line, dependent fields seeing the earlier
  fields transported to the same `i`; a path constructor applied at `j` is
  treated the same and re-applied at `j`. A constant line is the identity by
  regularity, as before. A neutral element stays stuck.
- `hcomp` in a HIT stays STUCK, in the checker and on the runtime: for a
  higher inductive type a composite is a canonical form (that is where the
  higher structure comes from). Confirmed by execution: `hcomp(Circle, [(φ,
  loop)], base)` at a symbolic `φ` is `#HCm{#Hit_Circle, …}` on HVM4.

The declaration is checked by the checker itself, not trusted: the generated
definitions carry every well-formedness obligation (parameter and field types
are `Set`s, endpoints have the HIT type, the eliminator's declared type is
exactly what the checker computes for `HEl` from the signature), so an
inconsistent declaration shows up as a ✗ on `Name/…`.

## The runtime (`--to-hvm4-full`)

Nothing is erased. The type is data `#Hit_Name{params}`, constructors are
data `#Hit_Name_tag{params, fields}` (a path constructor is a path value that
`@pathAt` reaches through `@hitAt`), and per program the emitter GENERATES
from the signatures:

| function | role |
|---|---|
| `@hitAt` | endpoints of every path constructor at `#I0`/`#I1`; `#At{ctor, i}` at a symbolic `i` |
| `@hitCoe` | `@coe` along a HIT line: rebuilt at the parameters of `L(s)` (read by `@hit_Name_p<k>`), each field `@coe`d along its own type line |
| `@hit_Name_elim` | the eliminator: branch on a point constructor, `@pathAt(branch, i)` on `#At{path-ctor, i}`, induction hypotheses as recursive calls, stuck data otherwise |

All binder names in the generated code are deterministic and globally unique
(HVM4 derives a `λ&` clone label from the binder's name).

Verified by execution, normaliser and HVM4 agreeing on every `main`:

| file | ✓ | runtime `main` | itrs |
|---|---|---|---|
| `hit_circle.bend` — `Circle`, dependent eliminator, loop inverse and composite | 19 | `1` | 27 |
| `hit_susp.bend` — `Susp<A>`, **transport along `Susp(ua(neg) @ i)`** | 23 | `1` | 99 |
| `hit_pushout.bend` — `Push<A,B,C,f,g>`, endpoints `inl(f(c))`, `inr(g(c))`, the cocone map | 15 | `1` | 80 |
| `hit_trunc.bend` — `Tr<A>`, recursive path-constructor fields, IHs, dependent elimination | 14 | `#One` | 47 |
| `hit_quot.bend` — `Q<A, R>`, the quotient's generators, descent | 12 | `#One` | 53 |
| `hit_interval.bend` — `I`, contractible, function extensionality from it | 12 | `1` | 29 |
| `hit_tree.bend` — recursive POINT fields, swap path, `anyTrue` respects it | 15 | `1` | 211 |
| `hit_mustfail.bend` — 7 proofs that must not go through (see below) | 9 | — | — |

Symbolic probes on HVM4 (hand-edited `@main`, partial knowledge as data):

- `coe(λi. Susp(ua(neg) @ i), i0, i1, merid(True) @ #IVar{0})` ⟶
  `#At{#Hit_Susp_merid{#Bool, 0}, #IVar{0}}` — the meridian's field was
  transported (`True ↦ False`) and the result is stuck on the unknown
  interval, exactly as in the checker (`transportMerid`, definitional).
- `toUnit(Tr/sq(in True, in False) @ #IVar{0})` ⟶ `#One` in 144
  interactions: the eliminator recursed into both induction hypotheses and
  applied the path branch at the symbolic interval.
- `hcomp(Circle, [(#IVar{0}, loop)], base)` ⟶ stuck `#HCm{…}` (2277 itrs of
  face evaluation, no reduction of the composite).

## Soundness probes (`hit_mustfail.bend`, all rejected)

1. `loop` is not `refl`: `Circle` is not a set.
2. A loop branch from `b` to `c ≠ b` is refused: path branches must have the
   endpoints the point branches dictate.
3. The two poles of `Susp(Unit)` cannot go to `True` and `False` in `Bool`.
4. A missing branch is not a proof (`IncompleteMatch`).
5. The eliminator's result is `P(x)`, not an arbitrary type.
6. A field must have the declared type.
7. The endpoints of a path constructor are the declared ones.

Also rejected, at declaration time (a parse error, so not in the suite): a
path constructor whose endpoint is neither a point constructor applied to
its arguments nor a recursive field.

## Limitations, stated

- **One-dimensional path constructors only.** No `PathP`-typed or square
  constructors, so no torus, no set truncation, no 2-cells; the quotient
  declared with the schema is the 1-skeleton (which is all `rec` into a set
  uses). The built-in `Quot`/`squash/` keeps its set-truncation.
- **Recursive fields must be at the same parameters** (`Name(p1, p2)` with
  the declared parameters). A recursive field at other parameters is
  detected as recursive and then fails to type in `Name/elim`, loudly.
- **No indices**, only parameters. **No nested recursion** (`List(Name)`
  fields get no induction hypothesis).
- **Endpoint shapes** are restricted as described above.
- `coe` through a HIT line is defined on constructors; on a neutral element
  it is stuck (there is no `transp` structure for a general HIT here, as in
  Cubical Agda's `transp` on HITs, which also computes only on constructors).
- The three hardcoded HITs remain as they were; `hit_circle`, `hit_trunc`
  and `hit_quot` show the schema re-derives them.
