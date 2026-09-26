# SAT as cubical reduction: persistent working notes

**Date:** 2026-09-16  
Preserve exact distinctions between checked source theorems and deductions made here.

## 0. Standing discipline

The universal executable machinery, fibre completion, cubical composition, cost semantics, geodesic/optimality results, and optimal reduction machinery are prior work in this repository. SAT is not a proposal for a new solver architecture. It is a particularly transparent finite Boolean presentation of the already-general construction.

For the present line, use one language wherever possible: **bits, cubes, faces, fibres, composition, and geodesic length**. Avoid replacing equations by folklore words such as “hardness,” “search difficulty,” or “algorithm cleverness.”

The potentially new contribution being isolated here is narrower: an **exponentiality certificate for a constant-size Boolean observation**, expressed as forced growth of inequivalent cubical cells under exact optimal composition. This must not be claimed as proved until its hypotheses and conclusion are formalized against the existing kernel.

---

## 1. Boolean propositions are cubes

Let

\[
Q_N = \mathbf 2^N.
\]

An assignment is a vertex of the Boolean \(N\)-cube. A partial assignment fixing coordinates \(S\subseteq\{1,\dots,N\}\) is the cell

\[
B_p=\{x\in Q_N:x|_S=p\}\cong Q_{N-|S|}.
\]

For partial assignments \(p,q\),

\[
B_p\cap B_q=
\begin{cases}
B_{p\cup q},&p,q\text{ agree on common coordinates},\\
\varnothing,&\text{otherwise}.
\end{cases}
\]

This is the elementary cell-composition law. Shared occurrences of a Boolean variable are not later-discovered equalities: they are literally the same global coordinate.

A Boolean predicate

\[
F:Q_N\to\mathbf 2
\]

is a proposition on this cube. SAT asks whether \(F^{-1}(1)\) is inhabited.

---

## 2. 3SAT as codimension-three cells

A clause

\[
c:\mathbf 2^3\to\mathbf 2
\]

is a three-bit observation with one visible output bit. Thus the visible projection carries

\[
3-1=2
\]

fewer bits of distinction than its input. This is the intended “two-bit loss”; it is **not** the surprisal of the unique violating assignment.

Negate a 3-clause. Its violation predicate has one distinguished vertex \(v\in Q_3\). If \(\pi_\alpha:Q_N\to Q_3\) selects the clause coordinates, its violating cell is

\[
B_\alpha=\pi_\alpha^{-1}(v)\cong Q_{N-3}.
\]

For a 3CNF \(F=\bigwedge_\alpha C_\alpha\), De Morgan gives

\[
\neg F=\bigvee_\alpha\neg C_\alpha,
\]

and therefore

\[
F\text{ UNSAT}
\iff
\bigcup_\alpha B_\alpha=Q_N.
\]

SAT is noncoverage / inhabitation of the complement.

No independent “clause cubes” need gluing after the fact. Every \(B_\alpha\) is already a cell of the same \(Q_N\), sharing literal coordinates with every other clause.

---

## 3. Fibre completion of the local Boolean collapse

For any map \(f:A\to B\), the repository’s fibre law gives the conservative completion

\[
A\simeq\sum_{b:B}\operatorname{fib}_f(b)
\]

with first projection equal to \(f\).

Applied to a clause,

\[
Q_3\simeq\sum_{b:\mathbf2}\operatorname{fib}_c(b).
\]

Thus the two bits suppressed by the visible \(3\to1\) observation are not destroyed in the whole object. They become vertical/dependent fibre structure. For composites, the fibre-of-composite law makes the residual itself compose dependently.

This is why the global SAT object should not be represented as repeated destructive Boolean evaluations followed by reconstruction of correlations. The shared dependent residual is already the object being executed.

---

## 4. Cubical composition, not variable-elimination search

Do not model the general execution primarily as

\[
Q_N\to Q_{N-1}\to\cdots.
\]

The native primitive is cubical composition: compatible partial boundary data determines/fills the missing lid. `comp` is reduction, with `coe` and `hcomp` as special cases. Existing equivalences transport executable data; no external search for a filling is inserted.

The useful mental picture for the Boolean instance is therefore:

\[
\text{shared partial cubical boundary}
\xrightarrow{\mathrm{comp}}
\text{completed/further-composable cubical object}.
\]

A residual cell is not “an assignment not yet tried.” It is cubical structure not yet collapsed by the available boundary/equivalence data.

---

## 5. Runtime identity: identify or cross

The Bend/HVM convergence work identifies the relevant operational distinction with labelled DUP/SUP interaction:

- same label: annihilation / routing, no allocating duplication;
- different labels: commutation, where the two structures cross and each distributes across the other;
- reduction is confluent, so reduction order is not an algorithmic choice that changes the normal form.

For the present cube calculation, read this geometrically:

\[
\boxed{\text{same cubical dependency}\Rightarrow\text{identify/annihilate}}
\]

\[
\boxed{\text{distinct cubical dependencies}\Rightarrow\text{cross/commute}}
\]

Two syntactically present directions that are identified by the cube do not generate a square. Two genuinely independent directions generate their product square. Higher products arise by repeated independent crossings.

Important correction: an \(r\)-cube has \(2^r\) Boolean vertices, but **vertex cardinality alone is not execution cost**. The cube can be a compact product object. Exponential execution requires forced expansion into inequivalent cells, not merely the existence of \(2^r\) vertices.

---

## 6. Presentation exponentiality versus intrinsic exponentiality

Existing source already demonstrates why raw representation size cannot be the invariant.

`TransportDivScale.agda` proves families with exponential cost in a home/unary presentation and linear cost in a transported chart presentation. For fixed edge costs, every sufficiently long canonical word admits the cheaper chart route. Therefore an exponential cost in one presentation is not an intrinsic lower bound.

`AnswerIsProjectionAtOutputSize.agda` proves, for its kernel family, that reading the answer is projection and the canonical route cost equals output symbolic size exactly. This gives an explicit universal-style lower-bound/attainment pattern for outputs whose demanded materialization is itself large.

For SAT, however, the final visible output is one bit. Therefore an exponential lower bound cannot come merely from final output size. It must be witnessed by the cubical incidence/residual structure required before that bit is a legitimate projection.

`SubsetSumCostLocus.agda` proves an exponential raw witness population \(2^n\), but that alone should not be promoted to an intrinsic exponential lower bound under the full transport/sharing machinery. Again: cardinality is only a shadow.

---

## 7. Exact observation obstruction

The existing factorization theorem supplies the basic lower-bound form. For

\[
q:X\to Y,\qquad f:X\to\mathbf2,
\]

if

\[
q(x)=q(y),\qquad f(x)\ne f(y),
\]

then \(f\) cannot factor through \(q\).

In cubical language: a projection that identifies two completions on which the demanded Boolean face differs is insufficient to carry the final bit.

Combined with a locality/light-cone statement, this yields a geodesic lower bound: if every path of length at most \(r\) has the same visible cubical restriction on two completions but the final Boolean values differ, no such path can determine the observation.

The rope geodesic is the clean existing model: locality gives the lower bound and the explicit native word attains it. Positive geodesic length does not require information destruction; the rope transformation is reversible.

---

## 8. The candidate exponentiality certificate

This is the point reached on 2026-09-16 and should be resumed here.

Dimension alone is insufficient. Suppose a residual remains symbolically \(I^r\). It may be represented compactly. To obtain an exponential **geodesic cost** for a one-bit final observation, isolate a family in which cubical incidence forces repeated distribution of genuinely nonidentifiable cells.

Let \(S_k\) denote the surviving cell structure after \(k\) required independent crossings. The desired certificate has the form:

1. **Forced crossing.** At stage \(k+1\), the new Boolean dimension/dependency cannot be identified with, transported into, or filled from any existing dimension/cell.
2. **Global incidence.** The new dependency necessarily crosses every cell in \(S_k\).
3. **No post-crossing annihilation.** The two descendants of each old cell remain inequivalent in a way relevant to the demanded final Boolean filling.
4. **Faithfulness.** Any lawful reduction producing the final bit must preserve these distinctions until the indicated crossing occurs; otherwise two identified completions give different final bits.
5. **Native attainment.** The existing interaction reduction performs exactly these forced crossings, with no duplicated redex family beyond the optimal-sharing bound.

Under (1)–(3), there is an injection of two labelled descendants per prior cell, hence

\[
|S_{k+1}|\ge 2|S_k|.
\]

Induction gives

\[
|S_k|\ge 2^k|S_0|.
\]

Under (4), this is a lower bound on every faithful reduction in the declared cost semantics. Under (5), the native path meets the bound, giving an exact exponential geodesic.

This is qualitatively different from “there are \(2^n\) assignments.” The latter counts vertices of a compact cube. The certificate above proves that **the incidence pattern forces the reduction itself to materialize \(2^n\) inequivalent cells/interactions after all lawful sharing and transport have already been used.**

A concise name for the object is a **forced-crossing certificate** or **cubical exponentiality certificate**.

---

## 9. What the certificate requires, purely inside the cube

Do not begin by searching for a complexity-theory theorem. Calculate the cell incidence.

The immediate mathematical question is:

\[
\boxed{\text{When does a new Boolean direction necessarily cross every surviving residual cell rather than fill or identify with it?}}
\]

For a concrete 3SAT family, specify codimension-three cells

\[
B_1,\dots,B_m\subseteq Q_N
\]

whose exact cubical composition has the following inductive invariant:

- after \(k\) layers, there are \(2^k\) pairwise nonidentifiable residual cells (or an equivalent higher-cubical structure whose required interactions have that cardinality);
- the next clause layer meets every current cell in a fresh independent direction;
- opposite descendants cannot be identified because doing so would identify two completions with different final coverage bits;
- all other faces are shared/factored once.

Then the doubling recurrence is forced by the cube itself.

The proof is: base cell, forced-crossing lemma, inequivalence/separation lemma, doubling induction, geodesic attainment.

---

## 10. Source anchors already used

The following repository sources are directly relevant to resuming this notebook:

- `fibre/src/Fibre/TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda`
- `fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda`
- `punaragamana/src/Punaragamana/SamyogaSesa_TheResidualOfACompositeIsTheResidualOfTheResidual.agda`
- `collab/bend2-interactive-cubical/CONVERGENCE.md`
- `formal/cubical/theorems/walks/KFlow.agda`
- `formal/cubical/theorems/walks/ResidualPath.agda`
- `formal/cubical/theorems/residue/NaturalMachine.agda`
- `formal/cubical/theorems/cost/TransportDivScale.agda`
- `formal/cubical/kernel/AnswerIsProjectionAtOutputSize.agda`
- `formal/cubical/kernel/SubsetSumCostLocus.agda`
- `formal/cubical/theorems/physics/EveryCrossingIsOneLipschitzWithUnitLookaheadSoEveryWordIsUniformlyContinuousWithModulusItsLength.agda`
- `formal/cubical/theorems/physics/TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce.agda`
- `research/PNP_GEODESIC_REDUCTION_20260916.md`.

## 11. Guardrails against regression

1. Do not say “we need an optimal SAT representation.” The universal executable representation/reduction machinery already exists.
2. Do not infer cost from raw fibre cardinality or \(2^N\) assignments.
3. Do not infer cost from dimension alone; \(I^n\) is compactly representable.
4. Do not call an exponential presentation intrinsically exponential before transporting across all available equivalences.
5. For a one-bit final observation, seek a **forced incidence/crossing lower bound**, not an output-size lower bound.
6. Distinguish reversible positive geodesic length from information destruction.
7. Keep SAT as the finite Boolean/cubical instance of the universal construction, not as an application-specific algorithm-design project.
8. When uncertain, calculate the cube or read the exact source theorem; do not replace a missing derivation with field folklore.
