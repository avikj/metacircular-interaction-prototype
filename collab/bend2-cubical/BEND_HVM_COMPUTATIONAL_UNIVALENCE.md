# Bend / HVM: Computational Cubical Type Theory and Optimal Interaction

## Thesis

Bend2 left the Interaction Calculus because HOC could not make interaction-net execution as fast as lower-order execution on everyday hardware.

We give Bend/HVM computational cubical type theory: identity, equivalence and higher-dimensional composition compute directly in the Interaction Calculus.

Equivalent computations are identified during reduction; correlated work is shared; independent work composes; and the interaction representation remains fully factored as computation proceeds.

The accompanying proofs establish the stronger optimality result: for arbitrary computation, reduction follows a minimum-cost path through equivalent interaction presentations. With unit-cost interactions, this is minimum interaction count.

That is the quantity for which Bend2 left interaction nets.

For primitive interaction cost $c(e)$ and a reduction path $\gamma$,

```math
C(\gamma)=\sum_{e\in\gamma}c(e).
```

A potential $\Phi$—a remaining-work measure—with $\Phi(t)=0$ on normal forms and

```math
\Phi(u)\le c(u,v)+\Phi(v)
```

for every primitive reduction step satisfies

```math
\Phi(s)\le C(\gamma)
```

for every reduction $\gamma:s\leadsto t$ to normal form. This is the potential method from amortized analysis: one primitive reduction cannot decrease the remaining-work measure by more than the cost charged to that reduction. If equality holds at every step of one reduction, its accumulated cost meets the lower bound exactly, so no equivalent reduction is cheaper. Under unit interaction cost, it has minimum interaction count.

---

## 1. Sharing and independence are different Boolean spaces

Start with one Boolean value $b\in\mathbf2=\{0,1\}$. If a program uses that same value in two places, the pair of observed values can only be

```math
(b,b)\in\{(0,0),(1,1)\}.
```

In mathematics this correlated pair-space is the diagonal

```math
\Delta_{\mathbf2}=\{(0,0),(1,1)\}\subset\mathbf2\times\mathbf2.
```

It still carries only the original one-bit choice:

```math
\Delta_{\mathbf2}\simeq\mathbf2,\qquad \pi_1|_\Delta=\pi_2|_\Delta.
```

If the values come from two independent choices, all four pairs are possible—the Cartesian product:

```math
\mathbf2\times\mathbf2=\{(0,0),(0,1),(1,0),(1,1)\}.
```

```text
 (0,1) -------- (1,1)
   |               |
   |               |
 (0,0) -------- (1,0)
```

HVM represents a binary alternative as a labelled SUP node. The label names the choice: $\mathrm{SUP}_L(x_0,x_1)$ carries the two alternatives of one Boolean coordinate $L$. DUP is explicit sharing: it gives two uses of one value.

When a DUP labelled $L$ meets a SUP carrying the same label, both uses must see the same branch. The possible paired observations are therefore only $(x_0,x_0)$ and $(x_1,x_1)$: the diagonal above. When the labels differ, they name different choices, so both coordinates remain and their four combinations form the product square.

Shannon information counts exactly this distinction space:

```math
H(\mathbf2^n)=\log_2|\mathbf2^n|=n,\qquad H(\Delta_{\mathbf2})=1.
```

The corresponding equal-label interaction routes one shared choice:

```math
\mathrm{DUP}_L\bowtie\mathrm{SUP}_L\longrightarrow\text{route}.
```

The different-label interaction preserves both choice coordinates and crosses them:

```math
\mathrm{DUP}_L\bowtie\mathrm{SUP}_M\longrightarrow\text{cross},\qquad L\ne M.
```

A product of independently varying coordinates is already a cube. Two transformations $r$ and $s$ that vary independently and commute form the two coordinate directions of a square:

```text
        r
   x --------> x_r
   |            |
 s |            | s
   v            v
  x_s -------> x_rs
        r
```

The two paths around the boundary are equal composites. Three independently varying commuting transformations give the coordinate directions of a cube; higher products give higher-dimensional cells.

---

## 2. Composition, factorization, irreducibility

```math
A\xrightarrow{f}B\xrightarrow{g}C
```

composes as

```math
g\circ f:A\to C.
```

Composition builds a transformation from parts; factorization recovers such parts. For a given map $h:A\to C$, find $f:A\to B$ and $g:B\to C$ with $h=g\circ f$.

If

```math
F(x,y)=G(C(x),C(x),y),
```

then $C(x)$ is one value with two uses. A representation evaluating $C(x)$ twice contains duplicated work absent from the factored expression.

The same composition/factorization distinction is elementary in arithmetic:

```math
60=2^2\cdot3\cdot5.
```

A prime is irreducible for multiplication because every factorization has a unit factor. Computational irreducibility is the same statement after the rewrite relation and cost model have been specified: no lower-cost factorization computes the same demanded result.

Lamping/Lévy optimal sharing removes duplicated work belonging to the same reduction family inside a presented net. Here equivalent presentations are themselves connected by executable cubical paths, so factorization is not restricted to the net initially presented.

---

## 3. Every map is exactly visible value plus fibre

Now apply factorization to an arbitrary computation or observation

```math
f:A\to B.
```

For an output $b:B$, define its fibre—the inputs together with proofs that they map to $b$—by

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

and projects the stored $a$ in the reverse direction. The source is therefore exactly the visible result together with the fibre over that result—the complete distinction the observation leaves unresolved.

A lossless completion means precisely such a reconstruction of the source from visible output plus residual fibre. The formal development proves that the type of lawful completions of a fixed map is contractible: there is, up to identity, exactly one such completion. Losslessness is therefore a property forced by the map, not an optimizer choice. At process level,

```math
\mathrm{LawfulStep}(A)\simeq(A\to A).
```

For a fixed visible map $f$, every transformation that leaves $f$ unchanged acts fibrewise; for sets,

```math
\mathrm{Flow}(f)
\cong
\prod_{b:B}\mathrm{End}(\mathrm{fib}_f(b)).
```

A determined visible coordinate may collapse while its exact residual remains in the fibre. Factorization and losslessness therefore coexist by construction.

---

## 4. Universal family

A universe $\mathcal U$ is a type whose elements are themselves types. Its universal family is

```math
\pi:\sum_{X:\mathcal U}X\to\mathcal U.
```

A dependent family—one type $P(b)$ for each $b:B$—

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

For $f:A\to B$, the map determines the family $b\mapsto\mathrm{fib}_f(b)$, and the total space of that family reconstructs $A$. These are equivalent presentations of the same dependent object.

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

Algebra is types equipped with operations and equations; number theory specializes arithmetic types and their factorization; category theory organizes objects, maps, identities and composition; topology retains paths and higher paths; geometry organizes coordinates, incidence and transport; analysis adds limits and continuous structure. Each is expressible as dependent structure in the same universe, so its maps and equivalences enter the same identity calculus.

---

## 5. Univalence: equivalence computes as identity

The previous section internalized families of types. Voevodsky's univalence internalizes equivalence between types as identity in that universe:

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

In CCHM this is not merely propositional: transport along the identity computes the equivalence. Equivalence is executable identity.

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

The conjugation formula and change-of-basis formula are the same operation: transport a transformation through an equivalence.

The transported-cost formalization exhibits families whose canonical presentation has exponential cost while an equivalent transported chart has linear cost. Hence cost attached to one presentation is not intrinsic cost. Since the equivalence computes, transport to the cheaper chart is itself an execution path.

---

## 6. Cubical composition

Cubical type theory represents an identity as a path over an interval $I$:

```math
p:I\to A,
\qquad p(0)=a,
\quad p(1)=b.
```

Identities themselves have identities, represented as higher-dimensional paths:

```math
p,q:a=_A b,
\qquad
\alpha:p=q.
```

A type may vary along the same interval:

```math
P:I\to\mathcal U,
```

with coercion

```math
\mathrm{coe}(P,r,s):P(r)\to P(s).
```

Kan composition is the operation that completes coherent partial cubes. `hcomp` fills a compatible partial boundary in a fixed type; `comp` performs the same completion while the type itself varies, combining filling with transport. The implemented type-directed CCHM rules cover Pi, Sigma, PathP and inductive structure; `Glue` supplies computational universe transport. A partial composition remains a term until its boundary data determine reduction.

When two local reductions commute, their two execution orders are the two boundary paths of this square and the commuting proof is the 2-cell between them. Higher commuting diagrams are higher cubical cells. Thus parallel reduction coherence is represented by the same path/composition structure that CCHM computes.

---

## 7. The mathematics executes in Bend/HVM4

The preceding operations are the semantics added to Bend/HVM4. The Bend patch adds the cubical constructors to the core term language and carries them through definitional reduction, evaluation and HVM4 lowering. The full HVM4 target retains intervals, paths, types, `coe` and `hcomp` as reducible terms instead of erasing or pre-normalizing them.

The CCHM Kan laws are implemented as definitional reductions. `kan.bend` checks the Pi, Sigma, PathP and Nat equations at definitional equality; those checks succeed only when `whnfHCm` performs the corresponding composition rule.

Transport depends on the type being transported, so runtime coercion is type-directed. Pi transport is contravariant in the domain and covariant in the codomain. Sigma transport first transports the first projection and then transports the second in the resulting dependent family. PathP transport constructs the corresponding higher composition. Universe transport executes the represented equivalence.

An unresolved composition remains explicitly represented:

```text
#HCm{type, faces, base}
```

and remains reducible when later interval information arrives.

HVM4 SUP/DUP therefore acts on cubical terms themselves. Type-directed reduction distributes through superposition, while labels retain which alternatives are one correlated choice and which are independent coordinates. Paths, dependent types, partial compositions and equivalences participate directly in sharing and reduction.

A basic univalent transport reduces natively:

```math
\mathrm{coe}\big(i\mapsto\mathrm{ua}(\mathrm{not})(i),\mathrm{True}\big)
\leadsto
\mathrm{False}.
```

Dependent List transport exposes the same semantics in emitted code:

```text
old: List(ua(not) @ i) : [True] → [True]
new: List(ua(not) @ i) : [True] → [False]
```

The emitted HVM4 reduction now transports each list element through the element-type line while retaining the list structure and branch correlation.

---

## 8. Coinduction and intrinsic rewrite

Reduction need not terminate after producing one result. A process that returns an observation and continues has the coalgebraic form

```math
X\to O\times X.
```

The dependent interaction formalization refines this form: one interaction returns the successor state, its dependent observation/event, the exact residual of that observation, and the continuation together. A derived equality, equivalence or transformation is itself a term and remains input to later interaction.

```math
\text{interaction}
\longrightarrow
\text{derived transformation}
\longrightarrow
\text{intrinsic rewrite}
\longrightarrow
\text{continuation}.
```

`IntrinsicRewrite` installs a derived rewrite at its proved locus; self/contextual presentation retains the residual needed to reconstruct the source; productive installation propagates the installed transformation into future observations. The set of executable identities therefore grows by computation itself.

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

## 9. Exact reduction-cost certificates

Now put a cost model on the reducer. Assign each primitive reduction a cost:

```math
w:E\to\mathbb N.
```

A potential $\Phi$ is a remaining-work measure. For a normal form $t$, require

```math
\Phi(t)=0
```

and, for every primitive reduction $u\to v$,

```math
\Phi(u)\le w(u,v)+\Phi(v).
```

Then every reduction $\gamma:s\leadsto t$ satisfies

```math
\boxed{
\Phi(s)\le C(\gamma)
}.
```

If equality holds edge-by-edge on a path, telescoping gives

```math
C(\gamma)=\Phi(s),
```

so that reduction attains the lower bound exactly and is minimum-cost.

For vector costs in $\mathbb N^d$ with componentwise order,

```math
\Phi(u)\preceq w(u,v)+\Phi(v)
```

implies

```math
\Phi(s)\preceq C(\gamma).
```

Componentwise equality gives exact Pareto attainment: no competing reduction improves any resource coordinate below the certified vector. No scalar exchange rate between resource coordinates is part of the theorem.

This is the compiler-theoretic distinction between representation size and execution cost: state-space size and reduction cost are different invariants. Cardinality, cube dimension, clause count, intersection count and residual width become cost lower bounds only after proving that one primitive reduction can discharge at most its charged amount of that quantity.

---

## 10. Consequence for Bend/HVM

HOC compared lower-order execution with the interaction representation then available. CCHM changes the object being compared: equivalent interaction presentations are connected by executable identity; fibre completion preserves the exact residual of every projection; SUP/DUP preserves correlation; and transformations proved during reduction are installed into subsequent reduction.

An interaction presentation is therefore not frozen at compilation. It is itself transformed by the executable equalities and factorizations discovered during reduction.

With unit interaction cost,

```math
\boxed{
\text{optimal interaction execution}
=
\text{minimum interaction count over executable equivalent presentations}
}.
```

Under unit-cost interaction reduction, the resulting minimum-cost theorem minimizes the exact quantity that motivated Bend2's move away from interaction nets: interaction count.

---

# Appendix A — SAT / 3SAT: the finite Boolean presentation

SAT is the finite Boolean specialization of the preceding map/fibre construction. For $F:\mathbf2^N\to\mathbf2$, SAT asks whether the fibre over $1$ is inhabited; witness SAT asks for a point in that fibre.

```math
Q_N=\mathbf2^N,
\qquad
F:Q_N\to\mathbf2.
```

A vertex of $Q_N$ is a complete assignment. A partial assignment fixing $k$ coordinates is a Boolean subcube of codimension $k$ with $2^{N-k}$ vertices. The satisfying fibre is

```math
S_F=F^{-1}(1).
```

SAT asks whether $S_F$ is inhabited; witness SAT asks for an element of $S_F$. In type-theoretic form,

```math
\mathrm{Dec}_F=\|S_F\|,
\qquad
\mathrm{Wit}_F=S_F.
```

The canonical truncation

```math
\tau:S_F\to\|S_F\|
```

forgets exactly which satisfying vertex was supplied. For inhabited decision $p:\|S_F\|$, the checked truncation-fibre theorem specializes to

```math
\mathrm{fib}_\tau(p)\simeq S_F.
```

Decision and witness are therefore two projections of the same Boolean fibre, not two unrelated problems.

## A.1 One 3-clause is one local 3-cube map

A clause on three distinct variables is a map

```math
c:\mathbf2^3\to\mathbf2.
```

Exactly one of the eight local vertices falsifies it. In $Q_N$, its violation set $V_C$ fixes those three coordinates:

```math
V_C\cong Q_{N-3},
\qquad
|V_C|=2^{N-3}.
```

The clause is therefore a local three-coordinate relation with a one-bit visible result. Its exact lossless presentation is the general fibre identity specialized to $c$:

```math
\mathbf2^3
\simeq
\sum_{b:\mathbf2}\mathrm{fib}_c(b).
```

This is the elementary reason 3CNF is cubical: every clause is a three-coordinate Boolean cell, and a formula composes these local cells over shared coordinates.

## A.2 A 3CNF is exactly a union-of-subcubes problem

For

```math
F=\bigwedge_{\alpha=1}^m C_\alpha,
```

let $V_\alpha\subseteq Q_N$ be the violating subcube of clause $C_\alpha$. Then

```math
F(x)=0
\iff
x\in\bigcup_{\alpha=1}^mV_\alpha,
```

hence

```math
F\text{ UNSAT}
\iff
\bigcup_{\alpha=1}^mV_\alpha=Q_N.
```

For a set $T$ of clauses, their violation intersection is either empty, when their fixed coordinates conflict, or one partial-assignment cube:

```math
\bigcap_{\alpha\in T}V_\alpha
=
\begin{cases}
B_{p_T},&T\text{ compatible},\\
\varnothing,&T\text{ incompatible}.
\end{cases}
```

If $r(T)$ distinct coordinates are fixed by a compatible $T$,

```math
\left|\bigcap_{\alpha\in T}V_\alpha\right|
=2^{N-r(T)}.
```

Thus every overlap is exactly shared Boolean coordinate information.

## A.3 Violation multiplicity gives exact global identities

Define

```math
\nu(x)=\#\{\alpha:x\in V_\alpha\}.
```

Double-counting assignment/clause incidences gives

```math
\boxed{
\sum_{x\in Q_N}\nu(x)=m2^{N-3}.
}
```

If $F$ is UNSAT then $\nu(x)\ge1$ for every vertex, so

```math
\boxed{m\ge8.}
```

At equality,

```math
m=8
\quad\Longrightarrow\quad
\nu(x)=1
\text{ for every }x,
```

so the eight violating cubes partition $Q_N$.

For arbitrary UNSAT 3CNF,

```math
\boxed{
\sum_x(\nu(x)-1)
=(m-8)2^{N-3}.
}
```

For arbitrary $F$, let $U=\#S_F$ and

```math
E=\sum_{x:\nu(x)>0}(\nu(x)-1).
```

Then

```math
\boxed{
U=2^N+E-m2^{N-3}.
}
```

The satisfying count is exactly uncovered Boolean volume after overlap multiplicity is restored.

## A.4 The entire intersection geometry is the factorial-moment tower

Define

```math
M_r=\sum_{x\in Q_N}\binom{\nu(x)}r.
```

Then

```math
\boxed{
M_r=
\sum_{\substack{T\subseteq[m]\\|T|=r}}
\left|\bigcap_{\alpha\in T}V_\alpha\right|.
}
```

Equivalently,

```math
M_r=
\sum_{\substack{|T|=r\\T\text{ compatible}}}
2^{N-r(T)}.
```

Inclusion-exclusion is therefore

```math
\boxed{
\#\mathrm{SAT}(F)
=
\sum_{r=0}^{m}(-1)^rM_r.
}
```

The alternating sum is exactly the number of vertices left uncovered by the violating subcubes: the cardinality of the satisfying fibre.

## A.5 Complete future equality is the exact residual quotient

For an observed transition system $(X,A,\mathrm{step},\mathrm{observe})$, define

```math
x\sim y
\iff
\forall w\in A^*,
\quad
\mathrm{observe}(\mathrm{run}(x,w))
=
\mathrm{observe}(\mathrm{run}(y,w)).
```

The checked Myhill-Nerode development proves that this is the greatest observation-compatible step congruence and that $X/{\sim}$ is the minimal fully abstract quotient. A single continuation with different observations proves nonidentification; child separation lifts to parent separation.

For a fixed coordinate order and Boolean map $f:Q_n\to\mathbf2$, a prefix $a\in Q_k$ has residual

```math
f_a:Q_{n-k}\to\mathbf2,
\qquad
f_a(z)=f(a,z).
```

Two prefixes have the same complete future exactly when

```math
f_a=f_b.
```

Thus the exact residual population at depth $k$ is the number of distinct residual functions, not the number of prefixes.

## A.6 Cardinality is not interaction cost

The SAT derivations prove this separation by explicit counterexamples.

For

```math
\mathrm{IP}_n(x,y)
=
\bigoplus_{i=1}^{n}x_i y_i,
```

one coordinate order has $2^n$ distinct midpoint residuals, while an equivalent interleaved presentation has constant local control. Exponential residual population in one chart is therefore not an intrinsic lower bound.

Likewise,

```math
F_n=
\bigwedge_{i=1}^{n-2}
(x_i\vee x_{i+1}\vee x_{i+2})
```

has exponentially many satisfying vertices, but its satisfying count obeys the constant-order recurrence

```math
A_n=A_{n-1}+A_{n-2}+A_{n-3},
```

and its complete-future continuation state needs only the trailing zero-run $0,1,2$ (plus an optional dead state).

Hence

```math
\boxed{
\text{semantic carrier cardinality}
\ne
\text{metric path length}
}
```

in general.

## A.7 The exact complexity interface is a reduction-cost certificate

The same potential method now applies to SAT. A semantic quantity becomes a reduction-cost lower bound only after proving how much one primitive reduction can decrease it. If

```math
\Phi(t)=0
```

and every primitive reduction $u\to v$ obeys

```math
\Phi(u)\le w(u,v)+\Phi(v),
```

then every reduction to normal form obeys

```math
\Phi(s)\le C(\gamma).
```

If equality holds step-by-step on a reduction, that reduction attains the lower bound and is minimum-cost. For unit interactions, an integer remaining-work measure that decreases by at most one per primitive reduction is a literal interaction-count lower bound.

For vector costs in $\mathbb N^d$,

```math
\Phi(u)\preceq w(u,v)+\Phi(v)
```

gives

```math
\Phi(s)\preceq C(\gamma).
```

Componentwise equality along a reduction proves exact Pareto attainment. The checked Pareto development separately proves that scalarization is extra policy: two componentwise-monotone scalar objectives can select opposite points of one incomparable frontier.

SAT therefore gives a finite instance of the complete chain: Boolean coordinates; local three-coordinate constraints; composition through shared coordinates; exact fibres; decision versus witness; quotient by complete future equality; equivalent factorizations; and a per-reduction remaining-work certificate proving an exact interaction-count lower bound.

---

# TL;DR

We provide CCHM computational cubical type theory semantics to Bend/HVM4 via first-class interval expressions and De Morgan interval operations; Path/PathP abstraction, application and endpoint computation; type-directed coe; CCHM Kan hcomp/comp; universe paths and Glue; dependent Pi/Sigma/PathP transport; higher-inductive path/quotient structure; suspended partial compositions retained as HVM4 terms; and corresponding extensions to Bend's core terms, definitional equality/type-directed reduction, evaluator and HVM4 lowering, yielding computational univalence and higher identity inside interaction reduction: constructed equivalences execute as transport; paths, dependent types, partial compositions and transformations remain reducible; HVM4 SUP/DUP reduces over that cubical structure while preserving branch correlation; exact fibres retain every distinction hidden by a projection; and intrinsic rewrite with coinductive continuation returns derived transformations to subsequent interaction, and prove exact fibre decomposition for every map; contractibility of lawful lossless completion; $\mathrm{LawfulStep}(A)\simeq(A\to A)$; universal classification of dependent families; computational univalence; fibrewise characterization of observation-preserving evolution; complete-future minimal quotients; closure of derived transformations under continued interaction; exact transport between equivalent cost presentations; scalar and vector reduction-cost certificates; and minimum-cost reduction whenever the proved per-reduction cost bound is attained—minimum interaction count for unit costs and exact Pareto attainment for vector-valued costs.
