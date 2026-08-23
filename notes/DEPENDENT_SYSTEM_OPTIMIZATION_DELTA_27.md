# Dependent System Optimization — Delta 27

**Bellman representation, semantic dependency rank, and the Isbell
optimization nucleus**

Date: 2026-08-14  
Status: exact finite/quantale theorems, mature-theory inheritance, and a new
synthesis/program  
Depends on: `notes/DEPENDENT_SYSTEM_OPTIMIZATION.md` (Delta 26)  
Novelty: no novelty claim for inherited semiring, quantale, Isbell, tropical
rank, formal-concept, communication-complexity, or automata results.

The 2026 trellis calibration in §34 is user-supplied ancestry. It remains an
un-pinned prior-art claim until the exact paper and theorem are attached and
read. That provenance boundary does not affect the finite theorems below.

## 0. Executive leap

Delta 26 identified an open costed subsystem with its continuation action

\[
K:A\times B\to\overline{\mathbb R},\qquad
\mathcal B_K(V)(a)=\inf_b\bigl(K(a,b)+V(b)\bigr).
\]

Delta 27 separates two new questions:

\[
\boxed{\text{What is the smallest exact intermediate dependency object
through which }K\text{ factors?}}
\]

\[
\boxed{\text{What canonical complete semantic dependency object does }K
\text{ generate?}}
\]

For finite scalar-cost matrices, the first answer is min-plus factor rank. For
a quantale-valued profunctor, the second is its Isbell hull/nucleus:

\[
\boxed{\begin{aligned}
\operatorname{rank}_{\min+}(K)
  &=\text{smallest number of exact latent dependency modes},\\
\operatorname{Isb}(K)
  &=\text{complete space of saturated dependency modes}.
\end{aligned}}
\]

The architecture compiler must find a smallest or best finite generating
family *inside* the optimization nucleus. Canonical completion and minimal
implementation are different objects.

## 1. Tropical cost semiring

Let

\[
\mathbb T=(\overline{\mathbb R},\min,+,+\infty,0).
\]

Tropical addition chooses the cheaper alternative; tropical multiplication
composes costs; infinity means infeasible. A finite subsystem is a matrix
\(K\in\mathbb T^{A\times B}\), with

\[
(L\star K)(a,c)=\min_b\bigl(K(a,b)+L(b,c)\bigr).
\]

This is shortest-path/dynamic-programming composition. Extended-value
subtraction is not used without a separate convention; §§20–24 restrict the
explicit conjugacy formulas to finite real-valued matrices.

## 2. Free complete min-plus semimodules

The value space \(\mathbb T^B\) has pointwise minimum and scalar translation.
For

\[
\delta_b(b')=\begin{cases}0&b'=b,\\+\infty&b'\ne b,
\end{cases}
\]

every value decomposes as

\[
\boxed{V=\bigoplus_{b:B}V(b)\odot\delta_b.}
\]

## 3. Bellman representation theorem

A map \(F:\mathbb T^B\to\mathbb T^A\) is **complete min-plus linear** when it
preserves arbitrary pointwise infima and scalar translations:

\[
F\left(\bigoplus_iV_i\right)=\bigoplus_iF(V_i),\qquad
F(\lambda\odot V)=\lambda\odot F(V).
\]

**Theorem 27.2 — Bellman representation.** Every such map has a unique matrix
\(K_F:A\times B\to\overline{\mathbb R}\) with

\[
F=\mathcal B_{K_F},\qquad
\boxed{K_F(a,b)=F(\delta_b)(a).}
\]

Indeed,

\[
F(V)(a)=\min_b\bigl(V(b)+F(\delta_b)(a)\bigr).
\]

Evaluation on all Dirac values proves uniqueness.

## 4. Full abstraction of continuation semantics

\[
\boxed{
\mathbb T^{A\times B}\cong
\operatorname{Hom}_{\mathbb T\text{-Sup}}(\mathbb T^B,\mathbb T^A).
}
\]

The assignment reverses boundary direction and respects composition:

\[
\mathcal B_{L\star K}=\mathcal B_K\circ\mathcal B_L.
\]

All scalar boundary-cost information is retained by the action on *every*
future value. This is the exact semantic category for initial scalar DSO.

## 5. Exact architecture factorization

An interface \(B\) for \(K:A\rightsquigarrow C\) is a pair

\[
M:A\rightsquigarrow B,\qquad L:B\rightsquigarrow C
\]

with

\[
\boxed{K=L\star M},\qquad
K(a,c)=\min_b\bigl(M(a,b)+L(b,c)\bigr).
\]

Equivalently,

\[
\mathcal B_K=\mathcal B_M\circ\mathcal B_L.
\]

Each \(b\) is a latent dependency mode, not merely an embedding coordinate.

## 6. Semantic dependency rank

For finite \(A,C\), define

\[
\boxed{
\operatorname{rank}_{\min+}(K)=
\min\{|B|:K=L\star M\}.
}
\]

Equivalently it is the least \(r\) such that

\[
\boxed{K(a,c)=\min_{1\le i\le r}\bigl(x_i(a)+y_i(c)\bigr).}
\]

This is exactly the minimum cardinality of an exact latent interface and hence
a semantics-level lower bound on architecture width.

## 7. Rank is not runtime complexity

Large factor rank says that no small exact separable interface exists. It does
not rule out a specialized polynomial-time evaluator exploiting some other
structure. Semantic rank measures dependency/representation
incompressibility, not generic computational complexity.

## 8. Gauge invariance

For finite boundary potentials \(\alpha:A\to\mathbb R\) and
\(\beta:C\to\mathbb R\), let

\[
K'(a,c)=\alpha(a)+K(a,c)+\beta(c).
\]

Then

\[
\boxed{\operatorname{rank}_{\min+}(K')=
\operatorname{rank}_{\min+}(K).}
\]

Shift every upstream/downstream factor and apply inverse shifts for the two
inequalities. Rank is likewise invariant under row/column relabeling and exact
boundary bijections.

## 9. Rank-one criterion

Rank one means \(K(a,c)=x(a)+y(c)\). Therefore every additive \(2\times2\)
minor satisfies

\[
\boxed{K(a,c)+K(a',c')=K(a,c')+K(a',c).}
\]

One violation proves factor rank at least two. Higher lower bounds may use
tropically nonsingular minors, subject to the standard inequality

\[
\operatorname{tropicalRank}(K)\le
\operatorname{factorRank}_{\min+}(K).
\]

The inequivalent notions called “tropical rank” must not be conflated.

## 10. Boolean specialization

Embed a relation \(R\subseteq A\times C\) by

\[
K_R(a,c)=\begin{cases}0&R(a,c),\\+\infty&\neg R(a,c).
\end{cases}
\]

Then

\[
\boxed{\operatorname{rank}_{\min+}(K_R)=
\text{minimum number of all-true rectangles covering }R.}
\]

This is Boolean factor rank. A latent mode is a certificate consisting of an
upstream membership test and downstream membership test.

## 11. Communication lower bound

Under the standard nondeterministic Boolean communication convention, an
interface with \(r\) certificate classes costs \(\lceil\log_2r\rceil\) bits
to name, and each certificate class is a true rectangle. Hence

\[
\boxed{N^1(R)=\left\lceil
\log_2\operatorname{rank}_{\mathbb B}(R)\right\rceil}
\]

with local verification cost excluded by that convention.

## 12. Fooling-set lower bound

A Boolean fooling set is a family \((a_i,c_i)\in R\) such that no all-true
rectangle contains two chosen pairs. A fooling set of size \(m\) forces every
rectangle cover, hence every exact latent interface, to have size at least
\(m\).

## 13. Context-restricted semantic rank

For \(\mathcal V\subseteq\mathbb T^C\), let

\[
\operatorname{rank}_{\mathcal V}(K)
\]

be the least \(|B|\) for which

\[
\mathcal B_M\mathcal B_L(V)=\mathcal B_K(V)
\quad\forall V\in\mathcal V.
\]

If every Dirac continuation belongs to \(\mathcal V\), Dirac reconstruction
gives

\[
\boxed{\operatorname{rank}_{\mathcal V}(K)=
\operatorname{rank}_{\min+}(K).}
\]

A smaller context family may legitimately admit a smaller interface only when
the excluded futures are truly out of scope.

## 14. Context growth and option value

If \(\mathcal V_1\subseteq\mathcal V_2\), then

\[
\boxed{\operatorname{rank}_{\mathcal V_1}(K)\le
\operatorname{rank}_{\mathcal V_2}(K).}
\]

More possible futures cannot decrease the minimum exact dependency width.
This is option monotonicity at rank level.

## 15. Safe approximate dependency rank

A factorized approximation \(\widehat K=L\star M\) is safely
\(\varepsilon\)-accurate when

\[
\boxed{K(a,c)\le\widehat K(a,c)\le K(a,c)+\varepsilon.}
\]

Its least interface width is
\(\operatorname{rank}^{\mathrm{safe}}_\varepsilon(K)\). For every continuation,

\[
\boxed{\mathcal B_K(V)\le\mathcal B_{\widehat K}(V)
\le\mathcal B_K(V)+\varepsilon.}
\]

The first inequality is monotonicity; the second follows by evaluating an
arbitrarily near-optimal endpoint for \(K\). The one-sided condition forbids an
approximation from inventing infeasible or unrealistically cheap paths.

## 16. Proof-relevant implementation rank

Let \(\mathbf K:A\times C\to\mathcal U\) be an implementation-valued relation
with witness costs. Its scalar decategorification is

\[
K(a,c)=\inf_{w:\mathbf K(a,c)}\operatorname{cost}(w).
\]

A witness-preserving factorization through \(B\) is an equivalence

\[
\boxed{
\mathbf K(a,c)\simeq
\sum_{b:B}\mathbf M(a,b)\times\mathbf L(b,c),
}
\]

or the appropriate proof-relevant coend when symmetries are present, with
additive costs. Let \(\operatorname{wrank}(\mathbf K)\) be its least width.
Decategorification gives

\[
\boxed{\operatorname{rank}_{\min+}(K)\le
\operatorname{wrank}(\mathbf K).}
\]

## 17. Strict loss under decategorification

For \(A=C=\{0,1\}\), take finite CW witness types

\[
\mathbf K(0,0)=\mathbf K(1,1)=S^1,
\qquad
\mathbf K(0,1)=\mathbf K(1,0)=\mathbf 1,
\]

all at cost zero. The scalar matrix is constantly zero and has min-plus rank
one. A rank-one witness factorization would make the Euler-characteristic
matrix an outer product, but

\[
\begin{bmatrix}0&1\\1&0\end{bmatrix}
\]

has determinant \(-1\). Hence witness rank is strictly larger than scalar
rank. Equal optimal values need not preserve proof identity, provenance,
topology, alternatives, or future composability.

## 18. Quantale generalization

For a commutative quantale \(Q\), a \(Q\)-matrix
\(K:A\nrightarrow C\) is a quantale-valued profunctor with composition

\[
(L\circ M)(a,c)=\bigvee_bM(a,b)\otimes L(b,c).
\]

These matrices form a quantaloid: homs are complete lattices, composition
preserves arbitrary joins, and right extensions/liftings exist. Boolean
relations, min/max-plus quantities, fuzzy relations, Lawvere metrics, and
suitably defined Pareto resource semantics are specializations.

## 19. Residuation synthesizes the missing side

Given \(X:A\nrightarrow B\) and \(K:A\nrightarrow C\), the right extension
\(K\swarrow X:B\nrightarrow C\) is the greatest \(Y\) with
\(Y\circ X\le_QK\). Dually, \(Y\searrow K\) is the greatest compatible
upstream factor. Thus

\[
Y\le K\swarrow X
\iff Y\circ X\le K
\iff X\le Y\searrow K.
\]

Architecture repair therefore has exact adjoint synthesis operators; it is
not necessarily blind search.

## 20. Explicit min-plus conjugacy

For finite real-valued \(K\), a sound rank-one majorant satisfies
\(K(a,c)\le x(a)+y(c)\). Define

\[
\boxed{K^\uparrow x(c)=\sup_a\bigl(K(a,c)-x(a)\bigr)},
\]

\[
\boxed{K^\downarrow y(a)=\sup_c\bigl(K(a,c)-y(c)\bigr)}.
\]

These are the least compatible downstream/upstream potentials and form an
antitone Galois correspondence. The finite-real hypothesis avoids undefined
extended-real subtraction.

## 21. Optimization nucleus

Define

\[
\boxed{
\operatorname{Nuc}(K)=
\{(x,y):y=K^\uparrow x,\ x=K^\downarrow y\}.
}
\]

Abstractly,

\[
\operatorname{Isb}(K)=
\{(X,Y):Y=K\swarrow X,\ X=Y\searrow K\}.
\]

This is the Isbell hull/nucleus of the profunctor.

## 22. Nucleus modes are tight majorants

Every nucleus pair obeys \(K(a,c)\le x(a)+y(c)\), and neither profile can be
reduced independently while remaining sound against the other. The two
profiles are the upstream burden of entering a latent mode and the downstream
burden of completing from it; mutual conjugacy makes both saturated.

## 23. Saturation theorem

Suppose \(K\le x+y\), and set

\[
\bar y=K^\uparrow x,
\qquad
\bar x=K^\downarrow\bar y.
\]

Then

1. \((\bar x,\bar y)\in\operatorname{Nuc}(K)\);
2. \(K\le\bar x+\bar y\);
3. \(\bar x+\bar y\le x+y\).

Minimality gives \(\bar y\le y\); soundness of \(x+\bar y\) gives
\(\bar x\le x\); the Galois closure identities give the remaining fixed-point
equation.

## 24. Nucleus cover theorem

For finite real-valued \(K\),

\[
\boxed{
\operatorname{rank}_{\min+}(K)=
\min\left\{r:
K=\min_{1\le i\le r}(x_i+y_i),\ (x_i,y_i)\in\operatorname{Nuc}(K)
\right\}.
}
\]

Every nucleus cover is a factorization. Conversely, saturate every term of an
optimal factorization. Each new term stays above \(K\) and below the old term,
so their lower envelope remains exactly \(K\) without increasing the number
of modes.

## 25. The central duality

\[
\boxed{\begin{aligned}
\operatorname{Nuc}(K)
  &=\text{all saturated exact dependency concepts},\\
\operatorname{rank}_{\min+}(K)
  &=\text{smallest number whose lower envelope is }K.
\end{aligned}}
\]

Architecture synthesis therefore splits into semantic completion of the
nucleus and finite generation/cover inside it. This is the **nucleus
compiler**.

## 26. Mature specializations

- For a Boolean relation, the nucleus is the formal concept lattice.
- For a poset order, it is the Dedekind–MacNeille completion.
- For a Lawvere metric, Isbell completion gives the directed tight span or
  generalized injective hull.
- For vector/dual pairing, it recovers lower-semicontinuous convex functions
  and Legendre–Fenchel conjugacy.
- For tropical matrices, it is a complete semi-tropical semimodule generated
  by row/column data.

The common operation is completing a relation into the stable dual concepts it
already implies.

## 27. Boolean concepts

For \(R\subseteq A\times C\), a formal concept is a pair \((X,Y)\) satisfying

\[
Y=\{c:\forall a\in X,\ R(a,c)\},
\qquad
X=\{a:\forall c\in Y,\ R(a,c)\}.
\]

Then \(X\times Y\subseteq R\) is a maximal true rectangle. Every Boolean
rectangle can be saturated to a concept rectangle without increasing cover
size. Hence Boolean rank is the minimum number of formal concepts covering the
relation. The lattice is the complete interface; a minimum concept cover is a
smallest exact finite interface.

## 28. Canonical versus minimal

The nucleus is canonical but may be large or infinite. A minimum-rank
factorization is small but can be nonunique, hard to compute, unstable,
context-dependent, or destructive of witness structure. The compiler must
preserve both the nucleus as semantic reference and selected finite generators
as executable architectures.

## 29. Architecture synthesis by conjugate closure

A finite search loop may:

1. propose upstream potentials \(x_i\);
2. compute \(y_i=K^\uparrow x_i\);
3. tighten \(x_i\leftarrow K^\downarrow y_i\);
4. form \(\widehat K=\min_i(x_i+y_i)\);
5. measure the conservative gap \(\widehat K-K\ge0\);
6. add, split, or move modes until the contextual error target is met.

Each retained mode is saturated. No global convergence or optimality claim is
made for naïve alternating updates.

## 30. Active dependency cells

For a factorization, define

\[
\operatorname{Act}(a,c)=
\operatorname*{argmin}_i\bigl(x_i(a)+y_i(c)\bigr).
\]

Different modes govern different cells of \(A\times C\). Ties lie on tropical
walls and remain proof-relevant when downstream behavior depends on the
realizing mode.

## 31. Rank stratification under change

For \(K_\theta\), parameter space is stratified by factor/contextual rank,
nucleus combinatorics, active cells, and wall crossings. Perturbations can
preserve rank, move active regions, split modes, or cause discontinuous rank
jumps. These are dependency phase transitions.

## 32. Sequential systems and behavioral Hankel matrices

For \(f:\Sigma^*\to\overline{\mathbb R}\), define

\[
\boxed{H_f(u,v)=f(uv).}
\]

A finite-state min-plus realization with state carrier \(B\) factors this
past–future matrix through \(B\). Hence every finite submatrix satisfies

\[
\operatorname{rank}_{\min+}(H_f)\le|B|.
\]

These rank lower bounds are state-complexity lower bounds. A converse needs
compatibility with action-induced shifts and is not automatic for arbitrary
semirings.

## 33. Relation to Myhill–Nerode

For a Boolean language,

\[
H_L(u,v)=\mathbf 1[uv\in L].
\]

Equality of rows is Myhill–Nerode equivalence. Three distinct objects meet:

\[
\boxed{\begin{aligned}
\text{behavioral quotient}&=\text{future-indistinguishable histories},\\
\text{Boolean/Hankel rank}&=\text{latent certificates or modes required},\\
\text{concept nucleus}&=\text{all stable past–future concepts}.
\end{aligned}}
\]

## 34. Trellis calibration — source pin required

The supplied Delta reports a 2026 result for binary linear codes. For the
conditional decoding matrix across a coordinate cut,

\[
W(x_L,x_R)=d\bigl((x_L,x_R),C\bigr),
\]

it states that min-plus factor rank and tropical rank both equal \(2^s\), with
\(s\) the classical minimum trellis-state exponent at the cut. If the precise
source confirms this statement, it is a powerful calibration: conditional
optimal-value matrices can encode exact interface complexity; rank may be
exponential while global optimization remains polynomial; bounded-radius
views may miss a nonlocal dependency state. Until the paper/theorem is pinned,
this paragraph is ancestry to verify, not a repository theorem.

## 35. Multiobjective extension

Choose a quantale of upward-closed feasible resource sets or Pareto antichains
with a proved monoidal convolution. A matrix then stores boundary tradeoff
sets, composition convolves resources and Pareto-reduces, continuations carry
future antichain objectives, and the nucleus stores saturated dual Pareto
concepts. Scalar formulas do not transfer until the chosen representation's
quantale laws are checked.

## 36. Rank-aware certified self-improvement

A rewrite between two factorizations of the same semantics may improve
interface width, runtime, verification, communication, context coverage,
approximation, or witness preservation. Its certificate should contain:

- semantic/contextual equivalence;
- cost/Pareto comparison;
- rank or interface-size comparison;
- proof that no supported future is lost;
- provenance/migration from old modes to new.

A rank decrease is not an improvement if obtained by silently shrinking the
context family, decategorifying witnesses, underestimating cost, or deleting
option value.

## 37. Architecture invention as nucleus discovery

New contexts, witness topology, cost dimensions, constraints, or theorems can
change the semantic relation itself:

\[
K\rightsquigarrow K',
\qquad
\operatorname{Nuc}(K)\rightsquigarrow\operatorname{Nuc}(K').
\]

Self-improving DSO alternates between completing the present semantics and
revising them when new distinctions become operational. It is not one fixed
low-rank problem.

## 38. Research memory as a past–future matrix

Let \(H\) be research histories, \(T\) future theorem tasks, and \(K(h,t)\) the
least additional verified cost of solving \(t\) from \(h\). The nucleus holds
saturated research concepts; a finite memory selects generators. Then

\[
\boxed{\operatorname{rank}_{\min+}(K)=
\text{minimum latent memory width preserving exact future task costs}.}
\]

A prose summary is warranted only relative to a declared task family and a
safe approximation claim.

## 39. Agent-swarm coordination

Rows may be local states/artifacts, columns future subtasks, entries remaining
certified costs, and latent modes reusable theorems or interfaces. Factor rank
lower-bounds exact shared semantic state; Boolean rank lower-bounds certificate
coordination; contextual rank prices the mission; the nucleus is the complete
space of saturated reusable concepts. A scheduler should seek artifacts that
create low-cost modes, safely reduce rank, split a false mode, transport across
many columns, or collapse modes by proved equivalence.

## 40. Prime-Pair calibration

At finite scale \(X\), construct a precise matrix \(K_X(u,v)\) where:

- \(u\) is a proof-relevant arithmetic state (sieve observation, charge,
  affine/Buchstab state, spectral packet, or bounded certificate context);
- \(v\) is a future continuation (scale refinement, shift, centre/gap query,
  charge-one test, boundary evaluation, or proof obligation);
- \(K_X(u,v)\) is the least additional *certified* work for the selected
  Prime-Pair target.

Then compute or lower-bound

\[
\operatorname{rank}_{\min+}(K_X),\qquad
\operatorname{rank}_{\mathcal V_X}(K_X),\qquad
\operatorname{Nuc}(K_X).
\]

Concrete hypotheses:

- **H27.1 — critical rank growth.** Near \(z\sim\sqrt X\), exact semantic rank
  grows faster than in subcritical smoothed regimes.
- **H27.2 — parity as missing generator.** Small-prime sieve states generate a
  proper subsemimodule; charge-one distinctions require another saturated
  mode.
- **H27.3 — separating continuations.** Equal visible sieve states admit a
  future whose costs differ; families of separators yield fooling sets or
  tropical minors.
- **H27.4 — breakthrough criterion.** A representation matters if it lowers
  contextual rank, supplies missing nucleus generators, proves a safe error
  bound, or separates and excludes an architecture class.

This program requires the bounded proof-relevant prime-pair carrier currently
being installed; a matrix of undocumented heuristic costs would not qualify.

## 41. Refoliation/physics calibration

For boundary hypersurfaces, factor transport as

\[
K=K_{\Sigma\to\mathrm{out}}\star K_{\mathrm{in}\to\Sigma}.
\]

Minimal exact rank measures boundary state crossing the cut. Refoliation asks
whether different factorization paths have equal continuation transformers.
The nucleus supplies saturated boundary concepts; anomaly/curvature occurs
when factorizations are path-dependent, modes fail to transport, or cuts need
incompatible interfaces. This is shared grammar, not an identification of
arithmetic with gravity.

## 42. Relation to the Eternal Golden Braid

A DSO factorization is one concrete dependency braid. Its nucleus contains all
saturated concepts licensed by complete boundary semantics. A finite
factorization selects strands; failure produces a separator or rank lower
bound; a semantic discovery changes the nucleus. The exact local question is
which dependencies the next weave must retain—no larger metaphysical claim is
needed.

## 43. Theorem ledger

Inherited/proved at mathematical level in Delta 27:

1. Bellman representation of complete min-plus linear maps.
2. Full abstraction by continuation transformers.
3. Exact interface width equals min-plus factor rank.
4. Rank-one additive-minor identity.
5. Boolean rank equals minimum true-rectangle cover.
6. Standard nondeterministic coordination bound.
7. Context-rank monotonicity.
8. Dirac-complete contextual rank equals full rank.
9. Conservative factorization gives uniform Bellman error.
10. Scalar rank lower-bounds proof-relevant witness rank.
11. Strict decategorification example via Euler characteristic.
12. Isbell conjugacy/residuation.
13. Nucleus modes are saturated rank-one majorants.
14. Termwise factor saturation.
15. Factor rank equals minimum nucleus-mode cover.
16. Boolean nucleus is the formal concept lattice.
17. Sequential realizations factor behavioral Hankel matrices.

“Inherited/proved” here does not mean every item is already kernel-checked in
this repository. The checked-foothold ledger below names only replayed local
formalizations.

Open/programmatic:

18. efficient finite nucleus generation;
19. exact/approximate minimum nucleus cover;
20. context-restricted tropical factorization algorithms;
21. proof-relevant or homotopical nuclei;
22. a checked Pareto-antichain quantale;
23. rank stability under rewrites;
24. Prime-Pair critical-rank growth;
25. arithmetic fooling sets/tropical minors;
26. nucleus-based research memory;
27. a certified self-improving factorization compiler.

## 44. Executable compiler sketch

Input \((A,C,K,\mathcal V,\varepsilon,\text{proof requirements})\).

1. **Semantic audit:** verify the relation and contexts; keep implementation
   witnesses separate from scalar costs.
2. **Nucleus generation:** propose \(x\), close by
   \(y=K^\uparrow x\), \(x\leftarrow K^\downarrow y\), retain fixed modes.
3. **Rank lower bounds:** fooling sets, additive minors, tropical minors,
   information cuts, witness-topology invariants.
4. **Finite cover:** optimize rank, execution, verification, communication,
   safe error, and option value.
5. **Context verification:** prove exact equality or the one-sided
   \(\varepsilon\) Bellman bound for all required contexts.
6. **Proof-relevant lift:** show scalar modes admit compatible witnesses.
7. **Persist:** relation, modes, generators, lower-bound certificates,
   contexts, approximation, provenance, and rewrite proof.

## 45. Immediate experiments

- **Boolean:** compare Boolean rank, concept-lattice size, minimum concept
  cover, Myhill–Nerode quotient, and fooling-set bounds on finite relations.
- **Tropical:** compute rank-one saturation, small nucleus covers, and tropical
  lower bounds; compare arbitrary and nucleus-restricted factorizations.
- **Sequential:** compare state count, Hankel factor rank, behavioral quotient,
  and contextual rank on finite weighted automata.
- **Proof-relevant:** construct equal cost decategorifications with unequal
  witness rank.
- **Prime-Pair:** define a non-heuristic bounded past/future matrix, compute its
  observational quotient, produce separating futures, and locate certified
  rank changes without treating a finite scan as number theory.

## 46. Deep compression

Delta 26:

\[
\text{a subsystem is its continuation transformer}.
\]

Delta 27:

\[
\boxed{\text{an architecture is a factorization of that transformer}},
\]

\[
\boxed{\text{exact dependency width is min-plus/quantale factor rank}},
\]

\[
\boxed{\operatorname{Nuc}(K)=
\text{the canonical complete space of saturated dual modes}}.
\]

Thus DSO is completion into the nucleus plus selection of a finite,
context-safe generating architecture.

## 47. Sanskrit compression

केवलं मूल्यं न पश्य।

Do not look only at value.

मूल्यस्य सर्वभविष्यसन्दर्भेषु क्रियां पश्य।

Look at its action on every future context.

व्यवस्थायाः न्यूनतममध्यरूपसंख्या तस्य min-plus-rank इति।

The minimum number of intermediate dependency forms is its min-plus rank.

सम्पूर्णाः परिपक्वाः मध्यभावाः तस्य Isbell-nucleus इति।

The totality of saturated intermediate concepts is its Isbell nucleus.

स्थानीयं न्यूनतमं canonical न आवश्यकम्।

The local minimum need not be canonical.

पूर्णं canonical रूपं लघु न आवश्यकम्।

The canonical complete form need not be small.

अतः प्रथमं semantics पूर्णीकुरु। ततः तस्य सुरक्षितं लघुतमजनकसमूहं
अन्विष्य।

First complete the semantics. Then find its smallest safe generating family.

## 48. Primary ancestry

- Lawvere: generalized metric spaces enriched over \([0,\infty]\).
- Quantales, quantaloids, \(Q\)-matrices, residuation.
- Pavlović: profunctor nuclei and enriched formal concept analysis.
- Willerton: Isbell completions, tight spans, semi-tropical modules, and
  Legendre–Fenchel duality through a nucleus.
- Fujii: Isbell hulls of quantale matrices and complete semimodules.
- Formal Concept Analysis and rectangle covers.
- Tropical factor/Barvinok rank and tropical rank.
- Weighted automata and behavioral Hankel matrices.
- Boolean communication complexity.
- The user-supplied 2026 trellis result, pending an exact bibliographic pin.

## Checked footholds in the repository

At this ingestion point:

- `NaturalMachine.DSOMinPlusFinite` checks arbitrary finite min-plus matrix
  composition, Bellman functoriality, associativity, identities, and an argmin
  witness fiber.
- `NaturalMachine.DSOContinuationFullAbstract` checks finite Dirac
  reconstruction/full abstraction on the existing extended-natural carrier.
- `NaturalMachine.DSORankFinite`, `DSOFactorRankFinite`,
  `DSONucleusFinite`, and `BehavioralHankel` are concurrent work. They are not
  called landed until committed and replayed through the aggregate.
- `Pairfield.PrimePairDecomposition` checks the actual prime-triplet
  classification and a real `{0,4}` endpoint destroyed by the `+2` waypoint.
- `Pairfield.BoundedPrimePair` now supplies a finite witness-bearing carrier;
  its integration and first declared past/future matrix remain active work.
