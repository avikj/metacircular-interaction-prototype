# Higher inductive types — `hit` declarations, at Cubical Agda `data` generality

**State: implemented, in the checker, the normaliser and the full runtime.
Twelve files, 189 ✓ and 7 deliberate ✗; suite 100 files, bad = 0; every
`main` agrees between the normaliser and HVM4.** This closes §D of
REMAINING.md, the last substantive item of the cubical completeness audit.

A higher inductive type is declared, not hardcoded:

```
hit Name<p1: T1, p2: T2>(i1: I1, i2: I2):          -- uniform parameters, indices
  case @tag(f1: A1, f2: A2) -> Name(p1, p2, e1, e2)  -- point constructor (target optional without indices)
  path @tag(f1: A1): T                               -- path constructor: T any iterated Path/PathP type over Name(…)
  path @tag(f1: A1): lhs ~> rhs                      -- sugar for Path(Name(params), lhs, rhs)
```

This is the shape of a Cubical Agda `data` declaration, which is what the
corpus's Agda uses (122 indexed families, path-typed fields throughout, an
interval-argument constructor `genB : (i : I) → … → Gen S (bin i a b)`):

- **parameters** are uniform (Agda's rule: a varying one is an index);
- **indices** are a dependent telescope; each point constructor declares its
  target `Name(params, indices)`;
- **fields** are a dependent telescope of ANY types — other types, paths,
  intervals, the HIT itself at any indices, other HITs;
- **path constructors** declare their type: `Path`, or an iterated `PathP`
  for squares and higher cells, with ANY well-typed terms of the HIT as
  faces (constructor terms, fields, compositions, whatever is typeable); the
  checker validates the whole boundary, corner compatibility included, when
  it checks `Name/tag`'s type as a `Set`;
- the **eliminator** `Name/elim(params, P, indices, x, branches)` is
  dependent, with motive `P : Π indices. Name(params, indices) -> Set`;
  recursion is by named definitions, exactly as in Agda's pattern matching.

Generated: `Name : Π params. Π indices. Set`, `Name/tag : Π params. Π fields.
END`. `Name/elim` is not a definition but syntax (Core.Adjust.elimSugar): its
type would mention the eliminator applied to the very branches being typed,
which no Π-telescope can express, so the checker types each use with every
branch in hand.

## Computation rules (checker and runtime alike)

| term | reduces to |
|---|---|
| `Name/tag(ps, fs) @ i1 … @ ik` at a literal `ik` | the face read off the declared path type walked down `i1 … i(k-1)` |
| `Name/elim(…, Name/tag(fs), bs)` | `b_tag(fs)` |
| `Name/elim(…, Name/tag(fs) @ i1 … @ ik, bs)` | `b_tag(fs) @ i1 … @ ik` |
| `Name/elim(…, hcomp(Name(…), [φ ↦ u], x), bs)` | `comp(λi. P(idx, hfill [φ ↦ u] x i), [φ ↦ elim(u)], elim(x))` — functions out of a HIT compute on composites |
| `coe(λi. Name(ps(i)), r, s, Name/tag(fs))` (no indices) | `Name/tag(fs')` at the parameters of `P(s)`, each field transported along its own type line (dependent fields see the earlier ones transported to the same `i`); a cell likewise, re-applied to its intervals; an hcomp cell commutes with the transport |
| `coe` along a line of an INDEXED family with varying arguments | stuck: the result lives in another fibre and has no constructor form; the element is still there, of the right type |
| `hcomp` in a HIT | STUCK — for a higher inductive type a composite is a canonical form; that is where the higher structure comes from |
| superpositions | commute with every rule above |

Eliminator branch types (`Core/Check.hs`, `hitBranchType`): a point branch is
`Π fields. P(idx_c(fields), Name/tag(params, fields))`; a path branch is
`Π fields. Br(T, Name/tag(params, fields))` with
`Br(Name(ps, idx), e) = P(idx, e)` and
`Br(PathP(L, a, b), e) = PathP(λi. Br(L i, e @ i), ⟦a⟧, ⟦b⟧)`, the image `⟦t⟧`
of a face being the eliminator itself on `t`, pointwise when `t` is a path.
Because the eliminator computes on constructors, cells and hcomps, and
recursion goes through the user's named definition, faces may be any terms of
the HIT: a nested constructor term's two images are compared by evaluation.
(`hit_tree.bend` shows the checker catching a real error this way: the two
faces of `assoc` have images `add(add(x,y),z)` and `add(x,add(y,z))`, so the
branch must be the associativity of addition; a constant branch is rejected.)

## In the compiler

Four generic `Term` forms carry all HITs; signatures live in the `Book`:

| form | meaning |
|---|---|
| `HTy n args` | `Name(params, indices)` |
| `HPt n ps c fs` | a point constructor |
| `HPa n ps c fs` | a path constructor — a cell, applied to intervals with `@` |
| `HEl n ps P ix x bs` | the eliminator |

Each constructor's whole telescope is ONE closed term, `hcTele = λ params. Π
fields. END`; instantiating it is applying and peeling (`hitInst`,
`Core/WHNF.hs`), which serves the checker (`checkTele`), the normaliser
(`hitEndAt`: faces of a cell; `whnfHEl`) and the emitter. Three changes to the
pre-existing checker were needed and are general improvements, each exposed
by a recursive definition where the hardcoded primitives had hidden it: the
hcomp rules dispatch on the type's normal form rather than its syntax
(`whnfHCm`); face-cell restriction substitutes an interval variable
syntactically (`substVar`) — the semantic `rewrite` re-normalises under
binders and unfolds a recursive definition stuck on a variable forever; and
the conversion checker's same-head shortcut sees through PATH applications
and neutral heads (`Core/Equal.hs`, `sameHead`) — comparing
`addAssoc(p, size(y), size(z)) @ i` with the same spine whose argument is
the unfolding of `size(y)` used to unfold `addAssoc` instead and regenerate
the same shape one level deeper, forever. `p @ i @ j` is left
associative (an n-dimensional cell).

## The runtime (`--to-hvm4-full`)

Nothing is erased. The type is data `#Hit_Name{args}`, constructors are data
`#Hit_Name_tag{params, fields}`, a cell is `#At{…{ctor, i1}…, ik}`. Per
program the emitter GENERATES from the signatures: `@hitAt` (a cell at an
interval: walks the constructor's declared path type, as runtime data, down
the applied dimensions and reads the face; `#At{cell, j}` at a symbolic `j`),
`@hitCoe` (transport along a HIT line, fields along their type lines, cells
under their intervals, hcomp cells commuted; indexed families stuck as in the
checker), `@hit_Name_elim` (branch on a constructor, `@pathAt(elim(p), i)` on
a cell, dependent composition over the filler on an hcomp cell, stuck data
otherwise). Spine walks are unrolled to the program's maximal dimension
instead of written recursively: HVM4's normal-form printer expands the arms
of a match stuck on a free variable, so ANY function that recurses through a
pattern variable diverges when printed inside a lambda — a user's `add`
included (verified: `@main = @add` never prints). Unrolling keeps path
VALUES printable; the eliminator's recursion through an hcomp cell's base
is the same ordinary recursion as the user's own functions.

All binder names in the generated code are deterministic and globally unique
(HVM4 derives a `λ&` clone label from the binder's name and counts a name's
uses across a whole definition).

## Verified by execution — normaliser and HVM4 agreeing on every `main`

| file | what it declares and proves | ✓ | runtime `main` | itrs |
|---|---|---|---|---|
| `hit_circle.bend` | `Circle`; dependent eliminator; loop inverse and composite | 18 | `1` | 42 |
| `hit_susp.bend` | `Susp<A>`; **transport along `Susp(ua(neg) @ i)`**: `merid(True) ↦ merid(False)`, both directions, definitionally | 22 | `1` | 117 |
| `hit_pushout.bend` | `Push<A,B,C,f,g>`; faces `inl(f(c))`, `inr(g(c))`; the cocone map | 14 | `1` | 99 |
| `hit_trunc.bend` | `Tr<A>`; recursive path fields; recursion by a named def; dependent elimination; **elimination through an hcomp cell, definitional** | 14 | `#One` | 66 |
| `hit_quot.bend` | `Q<A, R>`; the quotient's generators; descent | 11 | `#One` | 71 |
| `hit_interval.bend` | `I`; contractible; function extensionality from it | 11 | `1` | 43 |
| `hit_tree.bend` | `Tree` (swap path), `Tree2` (assoc path over nested constructor terms, branch = associativity of `add`) | 22 | `4` | 360 |
| `hit_torus.bend` | `Torus`: a **square** `surf : PathP(λi. Path(T, l1@i, l1@i), l2, l2)`; four faces definitional; identity and a map to the circle by elimination; the diagonal loop | 19 | `#Hit_Circle_base` | 84 |
| `hit_settrunc.bend` | `STr<A>`: set truncation, a square between any two parallel paths (recursive path FIELDS as faces); `isSet`; recursor into a set and identity by elimination | 14 | `#Hit_STr_in{Bool,1}` | 22 |
| `hit_indexed.bend` | `Reach<S, step>(s, t)`: an indexed family with path-typed fields, indexed motive, dependent elimination; `Gen(A: Set)`: an **interval-argument constructor whose target index moves along a universe path** (`genB(i, l, r) : Gen(notPath() @ i)`) | 21 | `2` | 123 |
| `hit_hcomp.bend` | the eliminator on hcomp cells (constant and general motive, Kan laws), transport commuting with hcomp along `Susp(ua)` | 16 | `1` | 107 |
| `hit_mustfail.bend` | 7 proofs that must not go through (below) | 7 | — | — |

Symbolic probes on HVM4 (hand-edited `@main`; partial knowledge as data):

- `toCircle(surf @ i @ i1)` at a symbolic `i` ⟶ `#At{#Hit_Circle_loop, #IVar{0}}`: the square's face, mapped.
- `surf @ i0 @ j` at a symbolic `j` ⟶ `#At{#Hit_Torus_l2, #IVar{1}}`: a face of a 2-cell read off its declared type at runtime.
- `idT(surf @ i @ j)`, fully symbolic ⟶ `#At{#At{#Hit_Torus_surf, #IVar{0}}, #IVar{1}}`: the eliminator through a 2-dimensional cell.
- `sq(x, y, p, q) @ i @ i0` ⟶ `p @ i` = `in(True)`: a set-truncation square's face is its path FIELD.
- `toBool(hcomp(Circle, [(#IVar{0}, loop)], base))` ⟶ `1`: the eliminator through an hcomp cell whose face is undecided (Bool's Kan rule then decides it).
- `coe(λi. Susp(ua(neg)@i), i0, i1, merid(True) @ #IVar{0})` ⟶ `#At{#Hit_Susp_merid{Bool, 0}, #IVar{0}}`: a cell transported, field moved along the parameter line, stuck on the unknown interval.
- `count` over `genB(#IVar{0}, …)`, an indexed cell over a moving index ⟶ `2`.

## Soundness probes (`hit_mustfail.bend`, all rejected)

1. `loop` is not `refl`: `Circle` is not a set.
2. A loop branch from `b` to `c ≠ b` is refused: a path branch's faces are the images the point branches dictate.
3. The two poles of `Susp(Unit)` cannot go to `True` and `False` in `Bool`.
4. A missing branch is not a proof (a partial `Name/elim` is a function, and rejected against `Bool`).
5. The eliminator's result is `P(x)`, not an arbitrary type.
6. A field must have the declared type.
7. The faces of a path constructor are the declared ones.

Rejected at declaration time (parse errors, so not in the suite): a
non-uniform parameter (the message says to make it an index), an indexed
point constructor without a target, `lhs ~> rhs` sugar under indices, and a
path constructor whose declared type is not an iterated path type over the
HIT (this one is a ✗ on `Name/tag`).

## What is not here, stated exactly

- Implicit arguments and universe levels: Bend2 has neither (`Set : Set`),
  independent of HITs.
- Strict positivity: Bend2 does not check it for `type` declarations either.
- Transport along a line of an indexed family with varying arguments is
  stuck (see the rule table); the element exists, it does not compute to a
  constructor. Along varying parameters of a non-indexed HIT it computes.
- Printing a recursive function AS A VALUE on HVM4 does not terminate; this
  is the runtime's normal-form printer and applies to every recursive Bend2
  function, not to HITs in particular.
- The three hardcoded HITs (`Quot`/`squash/`, `S1`, `Trunc`) remain;
  `hit_circle`, `hit_trunc`, `hit_quot` and `hit_settrunc` re-derive them,
  set truncation included.
