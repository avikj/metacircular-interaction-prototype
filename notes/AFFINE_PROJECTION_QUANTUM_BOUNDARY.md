# The eliminated gcd is exact coherent projection memory

**Status.** Exact finite arithmetic/quantum correspondence with a decisive
interface no-go; author-proved in safe Cubical Agda, independent audit
unassigned. The number theory and finite dilation theorem are standard. The
result joins two already-landed repository interfaces and claims no novelty.

## 1. Arithmetic projection has a uniform kernel fibre

For

\[
  ax+by\equiv c\pmod m,
\]

put

\[
  g=\gcd(b,m),\qquad h=\gcd(a,g)=\gcd(a,b,m).
\]

`ARITHMETIC_LIFE_BINARY_PROJECTION` proves that an `x` extends to a full
solution exactly when

\[
  ax\equiv c\pmod g.                                    \tag{1}
\]

Assume the equation is compatible, equivalently `h | c`. Equation (1) is one
class modulo `g/h`, so among residues modulo `m` the projected solution set
has

\[
  |P|=\frac{mh}{g}                                      \tag{2}
\]

elements. For each admitted `x`, multiplication by `b` has kernel size `g`,
so the reconstruction fibre contains exactly

\[
  |\pi^{-1}(x)|=g                                       \tag{3}
\]

compatible `y` values. Hence the full solution set has

\[
  |S|=|P|g=mh.                                          \tag{4}
\]

Equivalently, `S` is a torsor over the kernel of multiplication by `b` above
each projected point. A solved reconstruction coset

\[
  y=y_0+\frac m g t,\qquad t\in\mathbb Z/g\mathbb Z,    \tag{5}
\]

is an explicit fibre trivialisation, not merely a count.

## 2. Exact coherent cost of eliminating the coordinate

Let

\[
  \pi:S\longrightarrow P,\qquad (x,y)\longmapsto x
\]

be pointwise variable elimination on the basis of actual solutions. The
coherent-overwrite theorem gives

\[
  \boxed{d_E(\pi)=g=\gcd(b,m).}                         \tag{6}
\]

The lower bound is unavoidable: all `g` basis solutions above a fixed `x`
produce the same visible output and therefore need distinct environment
records. Formula (5) attains the bound by retaining the kernel coordinate
`t`. Thus the arithmetic obstruction, classical solution multiplicity, and
minimum exact coherent environment are the same integer.

This is the first live fibre histogram requested by R0065. It also states
precisely what later reconstruction costs: retain `t`, or keep `y`; the
projected `x` alone cannot recover which member of its reconstruction coset
was present.

## 3. Decisive no-go: a symbolic coset is not the projected coordinate

The arithmetic solver returns the one symbolic statement describing all
projected solutions, for example `x = 4 mod 5`. That is not the codomain `P`
of the pointwise map above. If every basis solution is overwritten by this
single description, the map

\[
  \sigma:S\longrightarrow\{\text{the solution-coset description}\}
\]

is constant, so

\[
  \boxed{d_E(\sigma)=|S|=mh.}                           \tag{7}
\]

Using (6) to price (7) silently identifies a set-valued theorem about an
equation with a state transformation on a particular solution. No quantum
encoding repairs that type error; their fibres are different.

There is a third lawful interface. A classical solver maps an **equation
description** `(a,b,c,m)` to its symbolic solution coset. Its source is a
space of equations, not `S`, so neither (6) nor (7) prices it without first
declaring that source chart. “The solver output is a coset” therefore carries
no intrinsic coherent-memory number.

## 4. Exact finite control

For

\[
  6x+10y\equiv14\pmod {30},
\]

we have `g=10` and `h=2`. Exact arithmetic gives

```text
projected x:  x = 4 mod 5       (6 residues mod 30)
reconstruction: y = y0(x) mod 3 (10 residues mod 30 for each x)
full solutions: 6 * 10 = 60.
```

Therefore:

```text
retain actual x, erase y coherently:       environment dimension 10
retain only the one symbolic x-coset text: environment dimension 60
solve from an equation description:        separately typed process
```

`NaturalMachine.AffineProjectionQuantumBoundary` represents the proved
solution chart as `Fin 6 × Fin 10`. It checks:

- every projection fibre is isomorphic to `Fin 10`;
- every exact projection certificate alphabet contains `Fin 10`;
- the kernel coordinate attains that lower bound;
- the symbolic summary is constant and its fibre is the full solution chart;
- the identity solution coordinate attains that sixty-state lower bound.

Focused and root `--cubical --safe --no-import-sorts` builds exit zero. The
root emits only the repository's pre-existing unsupported-indexed-match
warnings; the new module emits none.

## 5. Changed next move

1. Type every elimination consumer as one of: solution-set description,
   pointwise coordinate projection, or coherent state transformation.
2. When reconstruction is promised, retain the actual kernel/torsor coordinate
   supplied by the solved fibre—not only `g` and not only a representative.
3. For coupled systems, transport the same question to the kernel of the
   projected module map or Smith presentation. Do not multiply scalar gcd
   prices without the alignment data already required by
   `QUANTUM_QUOTIENT_COMPOSITION`.
4. Treat equation-solving cost separately from state-erasure cost. A theorem
   describing a solution set is not itself a channel acting on every solution.

No gate-count, thermodynamic erasure, approximate compression,
infinite-dimensional, or physical-realization claim is made.

