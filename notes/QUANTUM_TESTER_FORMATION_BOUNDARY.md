# A legal quantum tester is not yet a formed instrument

**Status:** exact finite-dimensional response-span theorem and prior-art
translation. No autonomous instrument-formation or empirical-physics claim.

The quantum-comb correction in `QUANTUM_COMB_MEMORY_ROSETTA.md` supplies the
right physical process object. It does not supply a rule for making a new
instrument family. Quantum testers, supermaps, resource theories, adaptive
design, renormalization, and system identification each answer a different
typed question. This note isolates their common exact boundary.

## 1. Keep the five objects separate

Fix finite-dimensional input and output systems at each time.

1. A **process** is a deterministic quantum comb $W$: a positive Choi
   operator obeying the recursive causal trace constraints.
2. A **tester** $\mathsf T=(T_a)_a$ is a physically admissible family of
   positive operators with the tester normalization. It produces
   $p(a\mid W,\mathsf T)=\operatorname{Tr}(T_aW)$. An adaptive laboratory
   strategy is included by treating the whole strategy as a tester, not by
   erasing its classical control history.
3. A **response table** is formed only after choosing processes and testers:
   $R_{i,(j,a)}=\operatorname{Tr}(T^j_aW_i)$.
4. A **predictive quotient** is formed only after declaring future controls
   and tasks; it identifies histories with equal admitted future response
   profiles. It is not the comb and not the tester.
5. A **realization cost** prices a physical implementation of a tester or
   comb under declared free resources, noise, calibration, duration, energy,
   and hardware. Equal response functionals need not have equal cost.

The arrow is therefore

```text
comb + admitted tester family
        -> response table
        -> task/control-indexed predictive quotient,

tester implementation + resource convention
        -> realization/calibration cost.
```

Neither arrow runs backward without additional data.

## 2. Exact response-span theorem

Let $\mathcal C$ be any convex set of admissible combs inside its finite
dimensional real affine space. Let $D=\operatorname{span}(\mathcal C-\mathcal C)$
be its direction space. An old experiment family supplies affine response
functionals $f_1,\ldots,f_m:\mathcal C\to\mathbb R$. A proposed tester outcome
supplies another affine functional $g$.

Call $g$ **old-response determined** when equal old response vectors force
equal $g$-response throughout $\mathcal C$. Call it **strictly informative**
when two admissible combs have the same old responses and different
$g$-responses.

**Theorem 2.1 (linear-span criterion for experiment refinement).** Assume
$\mathcal C$ has nonempty
relative interior. The following are equivalent:

1. $g$ is strictly informative over $\mathcal C$.
2. There is a direction $\Delta\in D$ such that
   $f_i(\Delta)=0$ for every $i$, but $g(\Delta)\ne0$.
3. The linear part $g|_D$ is not in
   $\operatorname{span}\{f_1|_D,\ldots,f_m|_D\}$.

If these conditions fail, $g$ is an affine function of the old response
vector on $\mathcal C$, so it creates no new process distinction.

**Proof.** Let

\[
F:D\longrightarrow\mathbb R^m,
\qquad F(\Delta)=(f_1(\Delta),\ldots,f_m(\Delta)).
\]

Finite-dimensional duality gives

\[
g|_D\in\operatorname{im}F^*
\quad\Longleftrightarrow\quad
g|_{\ker F}=0.
\]

Thus (2) and (3) are equivalent. If (2) holds, choose
$W_0\in\operatorname{relint}\mathcal C$. For sufficiently small
$\varepsilon>0$, both $W_\pm=W_0\pm\varepsilon\Delta$ lie in
$\mathcal C$. They have identical old responses and unequal $g$-responses,
proving (1). Conversely, the difference of any pair witnessing (1) lies in
$\ker F$ and is detected by $g$, proving (2). If no such direction exists,
$g|_D=\lambda\circ F$ for some linear $\lambda$; after fixing one base comb,
$g$ is an affine function of the old response vector. ∎

**Corollary 2.2.** Physical admissibility and empirical informativeness are
independent predicates. A tester may satisfy every positivity and
normalization constraint yet add no distinction. Conversely, an abstract
linear functional may detect an old-response-null direction but fail to be a
physically realizable tester.

**Corollary 2.3.** Informational completeness is the special case
$\ker F=0$. It licenses reconstruction relative to $\mathcal C$; it does not
select one informationally complete family among many, decide that full
tomography is worthwhile, or pay its realization and calibration cost.

The theorem is the quantum native form of the repository's finite predictive
refinement law, but it lives one type earlier: it says when a proposed physical
response can refine the table. The predictive quotient is computed only after
that tester is admitted into the future control language.

## 3. What the mature languages do—and do not—license

### Testers and supermaps

Tester normalization certifies a legal probability rule on every comb.
Deterministic supermaps certify legal transformations of channels, combs, or
testers. They provide **closure and transport of admissibility**. Without an
external target they do not select one legal output of a supermap rather than
another. Theorem 2.1 adds a relative informativeness test, not a selector.

### Resource theories

A resource theory can compare implementations after its free objects and free
transformations have been declared. It may prove that one tester cannot be
formed from currently free laboratory operations, or assign a monotone cost.
The free set is not derived from comb positivity. Changing the free set changes
the formation verdict without changing the process or response table.

### Adaptive experimental design and system identification

Adaptive design can choose a next tester from a candidate family by expected
information gain, Bayes risk, Fisher information, discrimination error, or a
control objective. This is genuine instrument revision, but only relative to
a prior/model class, loss, horizon, candidate implementation set, and data
history. Theorem 2.1 is the zero-error structural boundary underneath those
statistical criteria: a tester annihilating no previously unresolved feasible
direction cannot improve exact identification, although it may still improve
noise robustness or cost.

### Renormalization

Coarse-graining changes which process directions are retained as relevant.
It can therefore change $D$, the old-response kernel, and the useful tester
span. Renormalization supplies scale-dependent relevance after a coarse-graining
map and effective description are chosen; it does not by itself choose a
laboratory instrument or certify its hardware realization.

These are not competing answers. Constrained optimal experimental design
requires the following standard inputs (with governance kept separate):

```text
(model class C,
 design space of admissible testers,
 loss or utility,
 feasibility and resource constraints,
 calibration/noise model,
 decision rule,
 nonmathematical authority for changing the admitted control language).
```

The mathematical inputs define a constrained design problem. The last item is
governance, not another mathematical coordinate. None is implied by comb
positivity or tester normalization.

## 4. Prasaṅga: why span novelty is not formation

The linear-span criterion can look like the missing generator: pick any
$g$ outside the old span. Its opposite is also true in a physical laboratory.
There may be infinitely many such $g$, all prohibitively noisy or costly;
two may resolve the same direction at radically different calibration cost;
or the decision target may be constant along the direction they resolve.
Then span novelty is mathematically real and operationally worthless.

The missing coordinate is not another rank. It is the coupling of unresolved
process directions to a declared action or loss, together with a realizable
and calibrated tester. This is why formation is not optimization within an
untyped pool, but it is also not mysterious once those inputs are supplied:
it becomes ordinary constrained experimental design.

## 5. Rigor and source boundary

**Proved here:** Theorem 2.1 and its two corollaries in finite-dimensional
affine linear algebra. It applies to quantum combs because tester outcome
probabilities are affine linear in the comb. No numerical experiment is used.

**Mature prior art used as typing:** quantum combs/testers and link-product
composition are from Chiribella--D'Ariano--Perinotti's quantum-network
framework; deterministic higher-order maps are quantum supermaps; comb memory
cost is the global realization problem recorded in
`QUANTUM_COMB_MEMORY_ROSETTA.md`. Quantum tomography and adaptive design supply
many objective-dependent selection rules; no novelty is claimed for response
span, informational completeness, or optimal design.

**Not proved:** that a repository process table has a quantum realization;
that one statistical design criterion is canonical; autonomous generation of
a model class, loss, resource theory, candidate tester, or calibration
procedure; thermodynamic cost; or empirical usefulness. The preserved physical
residual is exactly who or what supplies and revises those typed conditions.

## Repository consequence

`CAUSAL_MEMORY_SPACETIME` should not acquire an “instrument formation rank.”
For each proposed revision, retain instead:

1. the comb/model class;
2. the old and proposed testers;
3. a kernel-direction witness or statistical objective;
4. the induced response-table refinement;
5. the resulting control-indexed predictive quotient;
6. realization and calibration cost under a named resource convention.

Only items 4 and 5 descend to the current finite predictive machinery. Items
1--3 license the physical distinction; item 6 determines whether it can live.
