# Bend / HVM: the optimal Interaction Calculus

## Result

Bend2 removed the Interaction Calculus from its production runtime because HOC could not make interaction-net execution as fast as lower-order execution on everyday hardware.

The machine implemented in this repository resolves that exact problem at the level at which it arises. **An arbitrary computation is retained as a lossless interaction object whose presentation is continuously factored over every executable identity available to the machine; reduction follows a minimum-cost path in the resulting interaction geometry.** The optimum is not computed once and handed to the runtime. Identity, representation, cost, inference and execution remain inside the running object, so the optimum is maintained as the object changes.

This is the distinction from classical optimal sharing:

```math
\text{classical optimal sharing}
:
\text{avoid duplicating equivalent reduction work in a presented net},
```

```math
\text{completed machine}
:
\text{maintain the cost-optimal interaction presentation of the computation itself}.
```

The construction is already joined to the pre-release Bend2/HVM4 line. Cubical paths and partial compositions survive to runtime; Voevodsky univalence turns equivalence into executable transport; exact fibres retain precisely the distinction hidden by every visible projection; SUP/DUP realizes correlation versus product locally; intrinsic rewrite installs derived transformations back into the running object; coinduction returns the transformed object as the continuation.

For primitive interaction cost $c(e)$ and a lawful path $\gamma$,

```math
C(\gamma)=\sum_{e\in\gamma}c(e).
```

For a represented computation $X$, presentations connected by executable equivalence are not separate semantic objects. Intrinsic cost is therefore taken over the lawful presentations and paths of $X$, not over one frozen graph:

```math
C^*(X)
=
\min_{P\simeq X}
\min_{\gamma\text{ realizing }P}
C(\gamma).
```

With unit interaction cost this is minimum interaction count. With vector-valued physical costs it is the corresponding Pareto-geodesic problem. The quantity that made the interaction runtime lose to lower-order execution is therefore the quantity the completed interaction machine computes and maintains.

Everything below is the elementary construction of this result.

---

## 1. HVM already has the correct local distinction: same coordinate or product

The smallest nontrivial finite distinction is

```math
\mathbf 2=\{0,1\}.
```

Use one Boolean distinction twice. The possible pairs are

```math
\Delta_{\mathbf2}
=
\{(0,0),(1,1)\}
\subset
\mathbf2\times\mathbf2.
```

The two projections agree on the diagonal:

```math
\pi_1|_{\Delta}=\pi_2|_{\Delta},
\qquad
\Delta_{\mathbf2}\simeq\mathbf2.
```

There is still one Boolean coordinate.

Let two Boolean coordinates vary separately. Their product is

```math
\mathbf2^2
=
\mathbf2\times\mathbf2
=
\{(0,0),(0,1),(1,0),(1,1)\}.
```

```text
 (0,1) -------- (1,1)
   |               |
   |               |
 (0,0) -------- (1,0)
```

Each factor supplies one coordinate direction. The finite Shannon information is therefore

```math
H(\mathbf2^n)=\log_2|\mathbf2^n|=n,
```

while

```math
H(\Delta_{\mathbf2})=1.
```

No probability language is required: this is the information carried by the finite distinction space itself.

HVM's labelled DUP/SUP interaction implements this distinction directly. When the labels agree, the two uses belong to the same branching coordinate:

```math
\mathrm{DUP}_L\bowtie\mathrm{SUP}_L
\longrightarrow
\text{route}.
```

When the labels differ, both coordinates remain and the product must be represented:

```math
\mathrm{DUP}_L\bowtie\mathrm{SUP}_M
\longrightarrow
\text{cross},
\qquad L\ne M.
```

Thus sharing is not bookkeeping added after evaluation. It is the representation of dependence before work is performed.

The same product appears when two local transformations commute:

```text
        r
   x --------> x_r
   |            |
 s |            | s
   v            v
  x_s -------> x_rs
        r
```

The two boundary routes are two serializations of one two-coordinate computation. Three separately varying commuting transformations generate a cube. Higher independent products generate higher cells. The interaction object is already a computational cell complex.

---

## 2. Composition, factorization and irreducibility are the cost problem

For maps

```math
A\xrightarrow{f}B\xrightarrow{g}C,
```

the composite is

```math
g\circ f:A\to C.
```

Factorization reads the same equation in the other direction: recover components whose composition is the given map.

If

```math
F(x,y)=G(C(x),C(x),y),
```

then $C(x)$ is one determined value with two uses. Two independent evaluations of $C(x)$ introduce a distinction absent from $F$; one shared result is the faithful factorization.

Multiplication is another composition law:

```math
60=2^2\cdot3\cdot5.
```

A prime is irreducible under multiplication because it has no non-unit factorization. Computational irreducibility is the same relation under the declared composition/cost law: after every lawful factor has been extracted, the remaining paid distinction cannot be removed while preserving the demanded observation.

This is the point at which HVM's historical optimality and the present construction separate. Lamping/Lévy optimal sharing prevents repeated reduction of work already known to belong to one reduction family. It does not, by itself, identify every mathematically equivalent presentation of the running computation.

The completed machine does.

---

## 3. Every map has one exact lossless presentation

Take any visible map

```math
f:A\to B.
```

For $b:B$, its homotopy fibre is

```math
\mathrm{fib}_f(b)
=
\sum_{a:A}(f(a)=b).
```

The total fibre family reconstructs the source:

```math
A
\simeq
\sum_{b:B}\mathrm{fib}_f(b).
```

An input is therefore exactly its visible result together with exactly the distinction that result does not determine.

This is stronger than attaching a trace. The repository proves that the lawful lossless completions of a fixed visible map form a contractible type: losslessness is a property of the map, not an independent machine choice. At machine level,

```math
\mathrm{LawfulStep}(A)
\simeq
(A\to A).
```

The ordinary step and its proof-relevant lossless presentation are equivalent descriptions of one process.

Once the visible map is fixed, the remaining invisible freedom is fibrewise. In the set-level specialization,

```math
\mathrm{Flow}(f)
\cong
\prod_{b:B}\mathrm{End}(\mathrm{fib}_f(b)).
```

Everything that can still vary without changing the visible result lies inside the corresponding fibres.

This is the exact reason maximal factoring need not destroy future information. A visible coordinate may collapse as soon as it is determined; the residual required to reconstruct or further transform the source remains in the fibre. Compression and losslessness are not competing requirements.

---

## 4. The universal family makes representation itself internal

Let $\mathcal U$ be a universe of types. Its universal family is

```math
\pi:
\sum_{X:\mathcal U}X
\to
\mathcal U.
```

Every dependent family

```math
P:B\to\mathcal U
```

is classified by this universal family. Every ordinary map $f:A\to B$ already determines such a family:

```math
P_f(b)=\mathrm{fib}_f(b),
```

with

```math
A\simeq\sum_{b:B}P_f(b).
```

So map, fibre family, total space and visible projection are presentations of one construction.

The ordinary foundations are already inside it. Implication is function type,

```math
P\Rightarrow Q
\equiv
P\to Q;
```

conjunction is product,

```math
P\land Q
\equiv
P\times Q;
```

existence is dependent sum,

```math
\exists x:A.P(x)
\equiv
\sum_{x:A}P(x).
```

Algebra supplies operations and identities on carriers; number theory studies particular arithmetic carriers and their factorizations; category theory retains objects, maps, identity and composition; topology retains path and deformation structure; geometry retains relations, coordinates and transport; analysis adds limiting and continuous structure. The vocabulary changes with retained structure; the foundational objects do not.

This matters operationally because a new mathematical structure does not require a new species of runtime object. It is structure in the same universe, and its equivalences can therefore participate in the same execution.

---

## 5. Voevodsky univalence makes equivalent presentations executable

For types $A,B:\mathcal U$,

```math
(A=_{\mathcal U}B)
\simeq
(A\simeq B).
```

An equivalence

```math
e:A\simeq B
```

therefore gives an identity

```math
\mathrm{ua}(e):A=_{\mathcal U}B.
```

Computational cubical type theory makes the identity reduce. Transport along the path generated by $e$ executes $e$:

```math
\mathrm{coe}(\mathrm{ua}(e),x)
\leadsto
e(x).
```

Representation equivalence is no longer metadata consumed by an external optimizer. It is an executable path between presentations.

For $f:A\to A$, transport across $e:A\simeq B$ gives

```math
f
\longmapsto
e\circ f\circ e^{-1}:B\to B.
```

Change of basis is the linear specialization:

```math
[T]_{B'}=P^{-1}[T]_BP.
```

A compiler representation, basis and coordinate chart are all presentations whose dependent structure transports through an equivalence.

The repository's transported-cost constructions make the performance consequence exact: a family can have exponential cost in one presentation and linear cost in an equivalent transported chart. Therefore

```math
\text{cost of a presentation}
\ne
\text{intrinsic cost of the represented computation}.
```

Because transport is executable, the cheaper chart is not merely known to exist; it is a lawful execution route.

Cubical identity retains the higher structure required to compose these routes. A path is

```math
p:I\to A,
\qquad
p(0)=a,
\quad
p(1)=b.
```

Paths themselves have paths,

```math
p,q:a=_A b,
\qquad
\alpha:p=q.
```

A commuting reduction square and a cubical 2-cell therefore carry the same boundary data. `coe` transports through a varying family; `hcomp` fills compatible boundaries in a fixed type; `comp` combines filling with transport; `Glue` gives universe-level computational univalence. Partial structure can remain partial until later information determines its completion.

---

## 6. Coinduction keeps optimality inside the running machine

A terminating program has type

```math
A\to B.
```

A continuing process returns an observation and another process:

```math
X\to O\times X.
```

The repository's dependent interaction returns successor, dependent observation/event, exact residual and continuation together. A proof, equivalence or transformation produced by an interaction is again a term available to the continuation.

```math
\text{interaction}
\longrightarrow
\text{derived identity/transformation}
\longrightarrow
\text{installed executable structure}
\longrightarrow
\text{next interaction}.
```

`IntrinsicRewrite`, contextual/self-presentation and productive installation are the checked source-level loci of this re-entry.

This is why “optimal representation” does not mean an optimizer chooses a good graph before execution. The representation is part of the same self-presenting object being transformed. New mathematical information changes subsequent reduction immediately.

Schematically,

```math
R_t=R_t^*,
\qquad
R_t\longrightarrow R_{t+1},
\qquad
R_{t+1}=R_{t+1}^*,
```

where $R_t^*$ is the cost-optimal faithful presentation under the identities and information available at state $t$.

The runtime therefore computes while maintaining the factorization on which its own future cost depends.

---

## 7. HVM4 is the local realization of the factored object

After the mathematics determines dependence, HVM repeatedly encounters the two elementary cases with which we began:

```math
\text{same / correlated structure}
\longrightarrow
\text{route / share},
```

```math
\text{separate product structure}
\longrightarrow
\text{cross / compose}.
```

The cubical/univalent machinery changes which apparent distinctions ever survive to the second case.

The pre-release integration against `DKormann/Bend2 @ f026483` and HVM4 retains interval expressions, path structure, universe paths, dependent constructors, `coe`, `hcomp`, `Glue`, quotient structure and unresolved partial compositions at runtime. See [`RUNTIME_FULL.md`](./RUNTIME_FULL.md), [`PUSC.md`](./PUSC.md), and [`LIST_TRANSPORT_FIX.md`](./LIST_TRANSPORT_FIX.md).

A basic universe transport executes natively:

```math
\mathrm{coe}\big(i\mapsto\mathrm{ua}(\mathrm{not})(i),\mathrm{True}\big)
\leadsto
\mathrm{False}.
```

A partial composition remains runtime data until later interval information determines it:

```text
partial boundary
      │
      ▼
#HCm{type, faces, base}
      │ later information
      ▼
local reduction
```

The List transport correction is a concrete compiler example:

```text
old: List(ua(not) @ i) : [True] → [True]
new: List(ua(not) @ i) : [True] → [False]
```

Dependent transport changes the emitted HVM computation itself. The proof layer is not sitting beside the reducer.

The consequence for Bend's architectural decision is now precise. HOC's lower-order turn answered a real empirical fact about the interaction representation available to them: that representation could require more physical work. The completed machine does not ask the hardware to reduce that frozen representation. It continuously computes which distinctions are real, which are identified, which presentations are equivalent, and which interaction path is minimal under the declared cost geometry.

**The future question is therefore no longer whether Bend should trade the Interaction Calculus for lower-order efficiency. The Interaction Calculus now contains the mathematics required to derive and maintain efficient execution itself.**

---

# Appendix — SAT is the finite Boolean cross-section of the whole machine

SAT is unusually useful here because almost every foundational object above becomes finite and visible at once.

Let

```math
Q_N=\mathbf2^N.
```

A vertex $x\in Q_N$ is a complete Boolean assignment. A partial assignment fixing $k$ coordinates is a coordinate subcube/flat of codimension $k$ with

```math
2^{N-k}
```

vertices.

A Boolean decision function is simply

```math
F:Q_N\to\mathbf2.
```

Its satisfying fibre is

```math
S_F=F^{-1}(1).
```

SAT asks whether this fibre is inhabited; witness SAT asks for a point of the fibre. In type-theoretic form the two targets are

```math
\mathrm{Dec}_F=\|S_F\|,
\qquad
\mathrm{Wit}_F=S_F.
```

The canonical truncation

```math
S_F\to\|S_F\|
```

