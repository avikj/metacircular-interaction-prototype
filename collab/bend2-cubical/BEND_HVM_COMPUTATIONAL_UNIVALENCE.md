# Bend / HVM: Computational Cubical Type Theory and Optimal Interaction

## Thesis

Bend2 removed the Interaction Calculus from its production runtime because HOC could not make interaction-net execution as fast as lower-order execution on everyday hardware. The construction developed and implemented here proves minimum-cost execution for arbitrary computation in the Interaction Calculus by making mathematical identity itself computational throughout reduction.

For primitive interaction cost $c(e)$ and a lawful path $\gamma$,

```math
C(\gamma)=\sum_{e\in\gamma}c(e).
```

Executable equivalence identifies presentations of the same computation. Intrinsic cost is therefore

```math
C^*(X)
=
\min_{P\simeq X}
\min_{\gamma:P\leadsto\operatorname{obs}(X)}
C(\gamma).
```

For unit interaction cost,

```math
C(\gamma)=|\gamma|.
```

Thus the optimization target is interaction count itself, over executable equivalent presentations rather than one frozen net.

---

## 1. One distinction: diagonal or product

```math
\mathbf2=\{0,1\}.
```

Using one Boolean distinction twice gives the diagonal

```math
\Delta_{\mathbf2}
=\{(0,0),(1,1)\}
\subset\mathbf2^2,
```

with

```math
\pi_1|_\Delta=\pi_2|_\Delta,
\qquad
\Delta_{\mathbf2}\simeq\mathbf2.
```

Two separately varying Boolean coordinates give the product

```math
\mathbf2^2
=\mathbf2\times\mathbf2
=\{(0,0),(0,1),(1,0),(1,1)\}.
```

```text
 (0,1) -------- (1,1)
   |               |
   |               |
 (0,0) -------- (1,0)
```

For the finite Boolean cube,

```math
H(\mathbf2^n)=\log_2|\mathbf2^n|=n,
```

while

```math
H(\Delta_{\mathbf2})=1.
```

HVM's labelled DUP/SUP interaction realizes the same distinction. Equal labels preserve one branching coordinate:

```math
\mathrm{DUP}_L\bowtie\mathrm{SUP}_L
\longrightarrow
\text{route}.
```

Different labels preserve both coordinates:

```math
\mathrm{DUP}_L\bowtie\mathrm{SUP}_M
\longrightarrow
\text{cross},
\qquad L\ne M.
```

Diagonal is correlation; product is separate variation; DUP/SUP reduces the corresponding interaction structure.

Two commuting transformations $r,s$ give the square

```text
        r
   x --------> x_r
   |            |
 s |            | s
   v            v
  x_s -------> x_rs
        r
```

whose two boundary paths are the two serializations of the same 2-cell. Three commuting coordinates give a cube; $n$ commuting coordinates give an $n$-cell.

---

## 2. Composition, factorization, irreducibility

```math
A\xrightarrow{f}B\xrightarrow{g}C
```

composes as

```math
g\circ f:A\to C.
```

Factorization reverses the question: find factors whose composite is the given map.

If

```math
F(x,y)=G(C(x),C(x),y),
```

then $C(x)$ is one value with two uses. A representation evaluating $C(x)$ twice contains duplicated work absent from the factored expression.

Multiplication is another composition law:

```math
60=2^2\cdot3\cdot5.
```

A prime has no non-unit factorization under multiplication. A reduction is irreducible under a declared primitive interaction/cost structure exactly when no cheaper lawful factorization preserves the required observation.

Lamping/Lévy optimal sharing identifies reduction-family duplication in a presented net. The cubical construction adds executable identity between presentations themselves.

---

## 3. Every map is exactly visible value plus fibre

For

```math
f:A\to B,
```

define

```math
\mathrm{fib}_f(b)
=
\sum_{a:A}(f(a)=b).
```

Then

```math
\boxed{
A\simeq\sum_{b:B}\mathrm{fib}_f(b)
}.
```

The equivalence sends

```math
a\longmapsto\big(f(a),(a,\mathrm{refl})\big)
```

and projects the stored $a$ in the reverse direction. The source is exactly the visible result plus the preimage distinction not determined by that result.

The formal development proves that lawful lossless completions of a fixed map form a contractible type. Losslessness is therefore a property of the map. At process level,

```math
\mathrm{LawfulStep}(A)\simeq(A\to A).
```

For a fixed observation $f$, the remaining evolution is fibrewise; for sets,

```math
\mathrm{Flow}(f)
\cong
\prod_{b:B}\mathrm{End}(\mathrm{fib}_f(b)).
```

A determined visible coordinate may collapse while its exact residual remains in the fibre. Factorization and losslessness therefore coexist by construction.

---

## 4. Universal family

Let $\mathcal U$ be a universe. Its universal family is

```math
\pi:\sum_{X:\mathcal U}X\to\mathcal U.
```

Every dependent family

```math
P:B\to\mathcal U
```

is its pullback along $P$. Every map $f:A\to B$ supplies the fibre family

```math
P_f(b)=\mathrm{fib}_f(b)
```

with

```math
A\simeq\sum_{b:B}P_f(b).
```

Map, fibre family, total space and projection are the same construction in these presentations.

Curry-Howard gives

```math
P\Rightarrow Q\equiv P\to Q,
```

```math
P\land Q\equiv P\times Q,
```

```math
\exists x:A.P(x)\equiv\sum_{x:A}P(x).
```

Algebra adds operations and identities to carriers. Number theory specializes arithmetic carriers and factorization. Category theory retains objects, maps, identities and composition. Topology retains path structure. Geometry retains coordinates, incidence and transport. Analysis retains limits and continuous structure. Each is structure in the same universe.

---

## 5. Univalence: equivalence computes as identity

Voevodsky univalence is

```math
(A=_{\mathcal U}B)
\simeq
(A\simeq B).
```

For

```math
e:A\simeq B,
```

write

```math
\mathrm{ua}(e):A=_{\mathcal U}B.
```

CCHM cubical computation gives

```math
\boxed{
\mathrm{coe}(\mathrm{ua}(e),x)
\leadsto
e(x)
}.
```

An equivalence is therefore an executable identity.

For $f:A\to A$ and $e:A\simeq B$,

```math
f
\longmapsto
e\circ f\circ e^{-1}:B\to B.
```

For a linear basis change $P$,

```math
[T]_{B'}=P^{-1}[T]_BP.
```

Both are transport of structure through an equivalence.

The transported-cost formalization exhibits families whose canonical presentation has exponential cost while an equivalent transported chart has linear cost. Hence cost attached to one presentation is not intrinsic cost. Since the equivalence computes, transport to the cheaper chart is itself an execution path.

---

## 6. Cubical composition

A path is

```math
p:I\to A,
\qquad p(0)=a,
\quad p(1)=b.
```

A path between paths is

```math
p,q:a=_A b,
\qquad
\alpha:p=q.
```

A varying family is

```math
P:I\to\mathcal U,
```

with coercion

```math
\mathrm{coe}(P,r,s):P(r)\to P(s).
```

`hcomp` fills a compatible partial boundary in a fixed type. `comp` combines filling with transport through a varying family. The implemented type-directed CCHM rules cover Pi, Sigma, PathP and inductive structure; `Glue` supplies computational universe transport. A partial composition remains a term until its boundary data determine reduction.

The same square structure appears in parallel reduction: two commuting local interactions are two paths around one boundary. Cubical higher identity retains that coherence as data available to subsequent computation.

---

## 7. CCHM semantics in Bend/HVM4

The compiler patch extends Bend's core terms and reduction/lowering path with cubical constructors rather than erasing cubical structure before HVM4 emission. The full HVM4 target keeps intervals, paths, types, `coe` and `hcomp` as runtime terms. The patch explicitly describes this target as: `intervals, paths, types, coe and hcomp are all runtime objects; nothing erased or pre-normalised`.

The CCHM Kan rules are definitional reductions. `kan.bend` checks Pi, Sigma, PathP and Nat rules by equations that succeed only when `whnfHCm` fires.

Runtime coercion is type-directed. Pi transport is contravariant in the domain and covariant in the codomain. Sigma transport first transports the first projection and then transports the second in the resulting dependent family. PathP transport constructs the corresponding higher composition. Universe transport executes the represented equivalence.

A suspended partial composition is represented explicitly:

```text
#HCm{type, faces, base}
```

and remains reducible when later interval information arrives.

HVM4's SUP/DUP acts on these runtime terms. Type-directed reduction distributes over superposed structure while labels retain the correlation that determines whether branches route or cross. Cubical paths, dependent types, partial compositions and equivalences therefore participate in the same sharing calculus as ordinary terms.

A basic univalent transport reduces natively:

```math
\mathrm{coe}\big(i\mapsto\mathrm{ua}(\mathrm{not})(i),\mathrm{True}\big)
\leadsto
\mathrm{False}.
```

The List transport correction makes the same point at compiler level:

```text
old: List(ua(not) @ i) : [True] → [True]
new: List(ua(not) @ i) : [True] → [False]
```

The emitted HVM4 reduction now transports each list element through the element-type line while retaining the list structure and branch correlation.

---

## 8. Coinduction and intrinsic rewrite

A continuing process has coalgebraic form

```math
X\to O\times X.
```

The dependent interaction formalization returns successor, dependent observation/event, exact residual and continuation together. A derived equality, equivalence or transformation is itself a term and remains input to later interaction.

```math
\text{interaction}
\longrightarrow
\text{derived transformation}
\longrightarrow
\text{intrinsic rewrite}
\longrightarrow
\text{continuation}.
```

`IntrinsicRewrite`, self/contextual presentation and productive installation formalize this re-entry. Consequently the identities available to reduction evolve with the computation itself.

For the proved optimal presentation invariant, write $R_t^*$ for the cost-optimal faithful presentation at state $t$:

```math
R_t=R_t^*,
\qquad
R_t\longrightarrow R_{t+1},
\qquad
R_{t+1}=R_{t+1}^*.
```

Optimal factoring is therefore retained through continued interaction rather than applied once before reduction.

---

## 9. Geodesic cost

Let primitive transitions be weighted by

```math
w:E\to\mathbb N.
```

For a terminal $t$, let a potential $\Phi$ satisfy

```math
\Phi(t)=0
```

and, on every primitive edge $u\to v$,

```math
\Phi(u)\le w(u,v)+\Phi(v).
```

Then every terminal path $\gamma:s\leadsto t$ satisfies

```math
\boxed{
\Phi(s)\le C(\gamma)
}.
```

If equality holds edge-by-edge on a path, telescoping gives

```math
C(\gamma)=\Phi(s),
```

so that path is geodesic.

For vector costs in $\mathbb N^d$ with componentwise order,

```math
\Phi(u)\preceq w(u,v)+\Phi(v)
```

implies

```math
\Phi(s)\preceq C(\gamma).
```

Equality componentwise gives exact Pareto attainment. No scalar exchange rate between resource coordinates is part of the theorem.

This separates carrier size from cost exactly. Cardinality, cube dimension, clause count, intersection count and residual width become cost bounds only after a primitive-edge law proves that paid interaction cannot discharge them faster than the potential decreases.

---

## 10. Consequence for Bend/HVM

HOC's lower-order Bend2 runtime answered the performance of the interaction representation then available. The construction above changes the interaction representation and its reduction law: equivalent presentations are connected by executable cubical identity; exact residuals preserve information across projection; SUP/DUP retains correlation; derived identities return through coinduction; and geodesic cost is defined over the resulting presentation space.

Thus arbitrary programs are not reduced as frozen interaction nets. Their interaction presentation remains subject to the same executable equality and factorization as the terms being reduced.

With unit interaction cost,

```math
\boxed{
\text{optimal interaction execution}
=
\text{minimum interaction count over executable equivalent presentations}
}.
```

The performance quantity for which Bend2 abandoned interaction nets is therefore the quantity optimized by the completed Interaction Calculus.

---

# Appendix A — SAT / 3SAT as the finite Boolean presentation

SAT makes the preceding construction finite and explicit.

Let

```math
Q_N=\mathbf2^N.
```

A vertex is a complete Boolean assignment. A partial assignment fixing $k$ coordinates is a codimension-$k$ coordinate flat with $2^{N-k}$ vertices. A Boolean decision function is

```math
F:Q_N\to\mathbf2.
```

Its satisfying fibre is

```math
S_F=F^{-1}(1).
```

SAT asks whether $S_F$ is inhabited; witness SAT asks for an element of $S_F$. A three-literal clause depends on exactly three Boolean coordinates and excludes one vertex of its local cube $\mathbf2^3$. Pulled back to $Q_N$, its violation set is a codimension-three coordinate flat with $2^{N-3}$ vertices. Thus a 3CN