# Dependent System Optimization — Delta 26

**Date:** 2026-08-14  
**Status:** user-authoritative new research direction; exact finite theorems,
mature-theory inheritance, and an open program.  
**Working term:** Dependent System Optimization (DSO). No novelty claim for
the name.

> Optimize the dependency structure, the interfaces, and the optimizer—not
> merely the variables.

## 0. The great leap

Classical optimization asks

\[
\min_{x\in X}J(x).
\]

Systems optimization usually asks

\[
\min_{x_i\in X_i}\sum_iJ_i(x_i)
\quad\text{subject to fixed coupling constraints.}
\]

The hidden assumption is that the decomposition, variable types, interfaces,
and dependency graph are already correct. In the Library the decisive
difficulty is often caused by those choices: proof cuts, workflow waypoints,
software interfaces, physical slices and observables, sieve visibility and
stopping scales, learning representations, theorem-prover cut languages, and
distributed dual variables or communication cuts.

Those choices change not merely efficiency but what remains feasible,
observable, composable, and provable. Therefore:

\[
\boxed{\text{optimize not only within a dependent system,
but optimize the dependency system itself.}}
\]

The architecture, later-choice types, representation, interface quotient,
decomposition vocabulary, and optimizer are all decision variables.

## 1. Optimization fibration

Let \(B\) be a type or category of architectures, decompositions, contexts, or
representations. For each \(b:B\), let \(E(b):\mathcal U\) be the type of
realizations admissible under \(b\). The total design space is

\[
\boxed{\mathcal E=\sum_{b:B}E(b).}
\]

The projection \(\pi:\mathcal E\to B\) forgets the realization; its fiber at
\(b\) is \(E(b)\). A dependent cost family is

\[
J:\prod_{b:B}E(b)\to\overline{\mathbb R}^{\,m},
\]

with coordinates such as execution, search, coordination, leakage,
verification, fragility, reconfiguration, and negative reuse/option value.
Extensionally one takes the Pareto minimum over \(\mathcal E\), but the
fibration retains which choices exist under an architecture, how realizations
transport, which optimizations compose, where gluing fails, and which changes
preserve semantics. Flattening destroys that structure even when it preserves
the extensional feasible set.

## 2. Semantics and architecture are different bases

Let

\[
\mathsf{Impl}\xrightarrow{\alpha}\mathsf{Arch},
\qquad
\mathsf{Impl}\xrightarrow{\sigma}\mathsf{Beh}.
\]

For target behavior \(T:\mathsf{Beh}\), the exact implementation fiber is

\[
\boxed{\mathsf{Impl}_T=\mathsf{Impl}\times_{\mathsf{Beh}}\{T\}.}
\]

An inhabitant contains an architecture, a realization, and evidence of
external behavior \(T\) (or declared contextual equivalence). Optimization is
fiberwise:

\[
\boxed{\operatorname{OptImpl}(T)=
\operatorname{ParetoMin}_{i:\mathsf{Impl}_T}J(i).}
\]

Univalence belongs in the semantic base, \(T\simeq T'\Rightarrow T=T'\), but
cost generally lives in implementation fibers. Hence:

\[
\boxed{\text{semantic equivalence does not imply cost equality unless cost
structure also transports.}}
\]

## 3. Three levels

1. **State optimization:** fixed \(b\), minimize over \(x:E(b)\).
2. **Architecture optimization:** choose \(b\), then minimize in its fiber.
3. **Optimization-system optimization:** mutate
   \((B,E,\sigma,J,\mathcal O)\rightsquigarrow
   (B',E',\sigma',J',\mathcal O')\).

A valid Level-2 rewrite carries semantic preservation or declared refinement,
safety/invariant preservation, cost comparison, migration of existing
realizations, and verifier legitimacy.

## 4. Architecture regret

For scalar cost let

\[
J_b^\star=\inf_{x:E(b)}J(b,x),
\qquad
J^\star=\inf_{b:B}J_b^\star.
\]

Then

\[
\boxed{
J(b,x)-J^\star=
\underbrace{J(b,x)-J_b^\star}_{\text{within-architecture error}}+
\underbrace{J_b^\star-J^\star}_{\text{architecture error}}.}
\]

A better solver inside \(b\) can reduce only the first term:

\[
\boxed{\text{optimizing harder inside the wrong dependency structure cannot
remove architecture regret.}}
\]

Pareto settings require dominance gaps or set-valued front comparison instead
of subtraction.

## 5. Decomposition obstruction is infinite architecture regret

Let \(R\subseteq A\times C\) be the endpoint relation and materialize an
intermediate type \(B\):

\[
A\xrightarrow{T}B\xrightarrow{S}C,
\qquad R_B=S\circ T.
\]

If \(R_B\subsetneq R\), then valid endpoint pairs in
\(R\setminus R_B\) are unrepresentable, so their architecture-level optimum
is \(+\infty\).

**Theorem 5.1 — no local optimizer repairs decomposition loss.** An algorithm
restricted to witnesses through \(B\) cannot realize a pair in
\(R\setminus(S\circ T)\).

**Proof.** Every output has an intermediate witness \(b:B\), hence lies in
\(S\circ T\). QED.

\[
\boxed{\text{the chosen intermediate ontology can create impossibility.}}
\]

## 6. The subsystem is a continuation transformer

Represent an open subsystem from boundary \(A\) to boundary \(B\) by an
extended-real cost relation

\[
K:A\times B\to[0,\infty],
\]

where \(+\infty\) means infeasible. A future context is
\(V:B\to[0,\infty]\). Define

\[
\boxed{\mathcal B_K(V)(a)=
\inf_{b:B}\left[K(a,b)+V(b)\right].}
\]

Thus \(\mathcal B_K\) maps a future objective to the present objective it
induces. This—not an isolated local minimum—is the subsystem’s compositional
optimization behavior.

## 7. Infimal composition and Bellman functoriality

For \(K:A\times B\to[0,\infty]\) and
\(L:B\times C\to[0,\infty]\), define

\[
\boxed{(L\star K)(a,c)=
\inf_{b:B}[K(a,b)+L(b,c)].}
\]

The identity is the zero diagonal and \(+\infty\) off diagonal. This is
min-plus/quantale-valued relational composition.

**Theorem 7.1 — Bellman functoriality.**

\[
\boxed{\mathcal B_{L\star K}=\mathcal B_K\circ\mathcal B_L.}
\]

It follows by reassociating the two infima and addition. Dependent subsystem
composition becomes ordinary composition of continuation transformers.

## 8. Optimization Yoneda

For \(b:B\), let the Dirac continuation \(\delta_b\) be zero at \(b\) and
\(+\infty\) elsewhere.

**Theorem 8.1 — reconstruction.**

\[
\boxed{K(a,b)=\mathcal B_K(\delta_b)(a).}
\]

Only \(b\) contributes a finite term. Hence:

**Corollary 8.2 — full abstraction.** If
\(\mathcal B_K(V)=\mathcal B_{K'}(V)\) for every continuation \(V\), then
\(K=K'\). The map \(K\mapsto\mathcal B_K\) is faithful:

\[
\boxed{\text{an open subsystem is determined by its action on every future
value landscape.}}
\]

## 9. Context-relative equivalence and dominance

For a declared continuation family
\(\mathcal V\subseteq[0,\infty]^B\), define

\[
K\equiv_{\mathcal V}K'
\iff
\mathcal B_K(V)=\mathcal B_{K'}(V)\quad\forall V\in\mathcal V,
\]

and

\[
K\preceq_{\mathcal V}K'
\iff
\mathcal B_K(V)\le\mathcal B_{K'}(V)\quad\forall V\in\mathcal V.
\]

These are optimization-aware contextual equivalence and dominance. Only they
justify exact deduplication or pruning.

## 10. Premature local optimization is unsound

Let \(A=C=\{\ast\}\), \(B=\{b_1,b_2\}\), and

\[
K(\ast,b_1)=0,\quad K(\ast,b_2)=1,
\]

\[
L(b_1,\ast)=+\infty,\quad L(b_2,\ast)=0.
\]

Locally \(b_1\) is cheaper, but retaining only it makes the composite
infeasible; the true composite costs \(1\) through \(b_2\).

**Theorem 10.1.**

\[
\boxed{\operatorname{Argmin}(L\star K)\ne
\operatorname{Argmin}(L)\star\operatorname{Argmin}(K)}
\]

in general. A locally dominated-looking implementation may be globally
essential because of continuation compatibility.
