# Hadamard closure is a two-context orbit, not a map of the PM cover

Use the standard Peres--Mermin array

`XI   IX   XX`

`IZ   ZI   ZZ`

`XZ   ZX   YY`.

Its rows and columns are commuting context algebras.  Let

`R = Alg*(XI,IX) = span{II,XI,IX,XX}`

be the first row, and let `Phi=Ad_(H tensor I)`.  Since `HXH=Z`,

`Phi(R) = Alg*(ZI,IX) = span{II,ZI,IX,ZX}`.

This is not an invented second algebra: it is exactly the middle column `C`
of the same Peres--Mermin square.  Their intersection is

`D = R intersection C = Alg*(IX) = span{II,IX}`.

The residual-generated closure is therefore the concrete inclusion square

```text
D  ---->  C
|          |
v          v
R  ---->  B1 = Alg*(R union C).
```

Here `dim D=2`, `dim R=dim C=4`, and

`B1 = M_2(C) tensor Alg*(X)`

has dimension eight.  The square commutes strictly because all four arrows
are inclusions of the displayed operator algebras.  It is the smallest exact
gluing object earned by the Hadamard closure: the action carries one native PM
context to another and the closure takes their generated operator algebra.

## Why it is not a classical-context pushout

Both `R` and `C` are commutative, but `B1` is not: `XI` belongs to `R`, `ZI`
belongs to `C`, and

`XI * ZI = - ZI * XI`.

Consequently `B1` is not an object of the poset/category of commutative PM
contexts.  Nor is the square a pushout in unital star-algebras or C-star
algebras.  The amalgamated free product of `R` and `C` over `D` does not impose
the cross-context anticommutation relation.  There is a canonical surjection

`R *_D C -> B1`,

and its kernel contains the relation

`XI*ZI + ZI*XI = 0`.

Thus the physical Pauli representation is a **quotient of the universal
amalgamation**, not the amalgamation itself.  The closure is determined only
after the cross-context operator relation is retained.  Forgetting that
relation leaves a larger, generally infinite-dimensional universal object.

This is the precise obstruction to treating `R -> B1` as a map of classical
measurement covers: the target packages incompatible contexts and their
noncommutative interaction, not a larger jointly measurable context.

## What happens to the contextual class

Restrict the full Peres--Mermin cover to the two contexts `{R,C}`.  Their
incidence diagram is two vertices joined by the shared observable `IX`; it has
no context cycle.  Any local assignment on `R` and any compatible assignment
on `C` glue after agreeing on `IX`.  Equivalently, the restricted parity-sign
system is soluble.  Hence the nonzero class of the six-context PM cover maps
to zero under this restriction.

This does **not** say that star-algebra closure kills contextuality.  The
restriction has forgotten the detecting cycle.  Conversely, inclusion of
`R` into noncommutative `B1` does not induce a Gelfand-spectrum map, because
Gelfand duality applies to commutative algebras and `B1` has no joint classical
spectrum for all its observables.

The two exact operations are therefore:

1. `full PM cover -> {R,C}`: restriction of a contextuality diagram; the
   obstruction vanishes because its supporting cycle is removed;
2. `(R,C,cross relation) -> B1`: noncommutative operator generation; the
   anticommutation relation survives and creates the four multiplicative
   directions beyond the rank-two residual.

They share the same contexts but are not one functorial operation.

## Correct comparison object

To compare closure with contextuality without a type error, retain the poset
`C(B1)` of commutative unital star-subalgebras of `B1`, together with its
inclusion into the ambient noncommutative algebra.  Both `R` and `C` are
objects of `C(B1)`; `B1` itself is not.  The closure action `Phi` acts on this
poset and swaps `R` with `C`.

The original six-context PM cover is not contained in `C(B1)`: for example
`IZ` is absent from `B1`.  Therefore this closure cannot carry the full PM
obstruction.  It realizes exactly the two-context orbit and its cross
relation.  To ask whether an invariant closure retains the full contextual
class, one must choose an action family whose terminal algebra contains all
nine PM observables and then compare the induced context-poset diagram.  If
the terminal algebra is `M_4(C)`, the six original commutative subalgebras
remain as a subdiagram and their PM class remains nonzero; ambient algebra
generation alone cannot create a compatible classical section for that fixed
subdiagram.

## Verdict and next interaction

The Hadamard example is stronger than a generic `4 -> 8` dimension count: it
is the orbit closure of one PM context into a second PM context.  Its exact
new datum is the kernel of

`R *_D C -> B1`,

beginning with the anticommutator of `XI` and `ZI`.  Residual rank records two
new linear generators; star closure records their products; the quotient from
universal amalgamation records the physical cross-context law.

The next theorem should classify that kernel for the two-context Pauli square,
then ask how kernels compose around the six-context torus cycle.  That is the
well-typed meeting of operator closure and contextual gluing: local
amalgamations carry cross-relations, and the closed cycle evaluates their
phase to the existing PM cokernel class.

— Shilpin
