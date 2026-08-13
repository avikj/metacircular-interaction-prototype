# Equality of process-POVM statistics and realization cost

**Status:** exact finite-dimensional quotient theorem, legal counterexample,
and primary-prior-art bridge. No empirical or autonomous-formation claim.

QUANTUM_TESTER_FORMATION_BOUNDARY.md characterized when a tester response
adds a distinction on a declared comb model. This note asks when two legal
tester outcomes make exactly the same distinctions, and what is destroyed
when they are identified. The standard objects are a restriction map and its
kernel, classical statistical experiments and Blackwell comparison, quotient
operator systems, and implementation-dependent resource costs. No new
composite object is introduced.

## 1. Keep the objects typed

Let \(V\) be the finite-dimensional real vector space spanned by Hermitian
tester-outcome representatives for fixed process types. Let \(\mathcal C\) be
a declared class of deterministic combs, paired with \(V\) by
\(\langle e,W\rangle=\operatorname{Tr}(eW)\).

Keep apart: an outcome \(e\in V\); a complete legal tester
\(\mathsf T=(e_a)_a\), including positivity and normalization; its induced
statistical experiment
\(p_{\mathsf T}(a\mid W)=\langle e_a,W\rangle\); a physical implementation
\(i\) with preparation, ancilla, control, measurement, and calibration; a
declared resource cost \(c(i)\); and the later task-relative predictive
quotient. An outcome operator is neither a complete tester nor a laboratory.

## 2. Kernel and quotient of the restriction map

Define

\[
N_{\mathcal C}=\{h\in V:\langle h,W\rangle=0
\text{ for every }W\in\mathcal C\},
\]

and define \(e\sim_{\mathcal C}f\) when their probabilities agree on every
declared process.

**Theorem 2.1 (kernel of the restriction map).**

\[
e\sim_{\mathcal C}f\quad\Longleftrightarrow\quad e-f\in N_{\mathcal C}.
\]

The response map

\[
\Phi_{\mathcal C}:V\to\mathbb R^{\mathcal C},\qquad
\Phi_{\mathcal C}(e)(W)=\langle e,W\rangle
\]

induces \(V/N_{\mathcal C}\cong\operatorname{im}\Phi_{\mathcal C}\).
For complete testers with a common labelled outcome set, equality of induced
experiments is componentwise equality in this quotient.

**Proof.** The equivalence is the definition after subtracting responses.
Thus \(\ker\Phi_{\mathcal C}=N_{\mathcal C}\), and the first isomorphism
theorem gives the result. ∎

**Corollary 2.2.** The affine-functional separation proved in
QUANTUM_TESTER_FORMATION_BOUNDARY.md is the dual statement: a new response
adds a distinction precisely when its class lies outside the span of the old
classes in \(V/N_{\mathcal C}\).

Tester constraints do not break the theorem. They restrict which points and
tuples in \(V\) are legal, and the equivalence is restricted to that subset.
The quotient of the legal subset need not itself be a cone or vector space;
legal testers must not silently be replaced by all of \(V/N_{\mathcal C}\).

## 3. Same legal tester, different cost

For any nonempty \(\mathcal C\), consider the binary tester that ignores the
process and returns a fair coin:

\[
p(0\mid W)=p(1\mid W)=\tfrac12\qquad(\forall W\in\mathcal C).
\]

It has two legal implementations:

1. use free classical randomness and no coherent quantum ancilla;
2. prepare a qubit in \(|+\rangle\), measure it in the computational basis,
   and never couple it to the process.

Both induce the same tester on every comb. Under the explicitly declared cost

\[
c(i)=\text{maximum coherent quantum ancilla dimension used by }i,
\]

with classical randomness free, their costs are \(1\) and \(2\). This is not
a universal thermodynamic claim; it is an exact failure of descent for one
typed resource convention.

Let \(\pi:I\to\mathsf{Test}_{\mathcal C}\) send an implementation to its
process-POVM response-equivalence class.

**Theorem 3.1 (factorization criterion).** A cost \(c:I\to R\) factors as
\(c=\bar c\circ\pi\) iff it is constant on every preimage
\(\pi^{-1}(t)\).

**Proof.** Factorization forces equal values on equal images. Conversely,
define \(\bar c(t)\) to be the common value on the preimage. ∎

Thus coherent ancilla dimension does not descend in the example. Neither do
calibration history, device location, noise, energy, duration, failure modes,
or provenance unless each is constant on every preimage. One may define

\[
c_{\min}(t)=\inf\{c(i):\pi(i)=t\},
\]

but this is a new optimization functional. It forgets attainment,
nonminimal implementations, multi-resource trade-offs, robustness, and the
path by which the tester was made. The attainable set or Pareto frontier of
the preimage retains
more of the physical object than one scalar.

## 4. Blackwell comparison is a coarser equivalence relation

A complete tester induces the classical statistical experiment

\[
\mathcal E_{\mathsf T}
=\bigl(A,\{p_{\mathsf T}(\,\cdot\mid W):W\in\mathcal C\}\bigr).
\]

Theorem 2.1 is equality of this parameterized table for a fixed labelled
outcome set. Blackwell comparison instead asks whether one experiment is a
Markov-kernel postprocessing of another, equivalently in the classical theorem
whether it is never better in any decision problem. Hence response equality
implies Blackwell equivalence, but not conversely.

**Counterexample 4.1.** Experiment \(E\) has one outcome of probability one.
Experiment \(F\) has two fair-coin outcomes independent of \(W\). A stochastic
map splits \(E\)'s outcome into a coin; another forgets \(F\)'s coin. They are
mutually Blackwell garblings and decision-equivalent, but have different
outcome sets and response tables.

So equality modulo \(N_{\mathcal C}\) is the equality kernel *before*
decision-theoretic postprocessing. Blackwell equivalence is appropriate only
when outcome randomization and forgetting are declared free. Quantum
Blackwell theorems replace classical garblings by the relevant positive or
completely positive maps under additional hypotheses; they still do not
identify physical implementations or their costs.

## 5. Quotient operator systems: the matrix-ordered refinement

Suppose the outcome representatives lie in an operator system \(\mathcal S\)
whose order unit \(u\) is the deterministic effect
\(\langle u,W\rangle=1\) on \(\mathcal C\), and suppose \(\mathcal C\) is
compact. Evaluation gives a unital positive map into the commutative response
function system:

\[
q_{\mathcal C}:\mathcal S\to C(\mathcal C),\qquad
q_{\mathcal C}(e)(W)=\langle e,W\rangle.
\]

Positivity into a commutative C*-algebra implies complete positivity, so
\(N_{\mathcal C}=\ker q_{\mathcal C}\) is an operator-system kernel. The
operator-system quotient \(\mathcal S/N_{\mathcal C}\), with its
Archimedeanized matrix cones, is the right carrier when positivity must remain
stable under ancillary matrix levels.

The raw vector quotient classifies scalar response equality. The
operator-system quotient retains matrix order. The concrete image is the
response function system. Legal normalized tester tuples remain a
distinguished subset. Kavruk--Paulsen--Todorov--Tomforde show that
operator-system quotients need not agree with the corresponding
operator-space quotients, so the ordered structure cannot be inferred from
the bare annihilator quotient.

## 6. Primary-prior-art pins

- Mário Ziman, [*Process POVM: A mathematical framework for the description
  of process tomography experiments*](https://arxiv.org/abs/0802.3862)
  (2008), defines process effects and their normalization, proves every
  process POVM implementable, states informational completeness as a span
  condition, and explicitly notes nonunique experimental realization.
- David Blackwell, [*Equivalent comparisons of
  experiments*](https://doi.org/10.1214/aoms/1177729032), *Annals of
  Mathematical Statistics* 24 (1953), 265--272. Francesco Buscemi,
  [*Comparison of quantum statistical models: equivalent conditions for
  sufficiency*](https://arxiv.org/abs/1004.3794), supplies a quantum
  Blackwell--Sherman--Stein extension using statistical morphisms and
  completely positive coarse-grainings.
- Kavruk, Paulsen, Todorov, and Tomforde,
  [*Quotients, exactness, and nuclearity in the operator system
  category*](https://arxiv.org/abs/1008.2811), defines operator-system
  quotients and proves their operator-space structure can differ from the
  ordinary operator-space quotient.

These sources were fetched and read at the cited claims on 2026-08-13. No
novelty is claimed for process POVMs, response kernels, Blackwell comparison,
or operator-system quotients.

## 7. Rigor boundary and changed machine

**Proved here:** Theorems 2.1 and 3.1, Corollary 2.2, and both finite
counterexamples.

**Prior-art translation:** process-POVM legality and nonunique realization,
Blackwell comparison, quantum sufficiency, and operator-system quotient order.

**Not proved:** that the one-slot PPOVM source exhausts multi-time comb
testers; a universal cost; equality of hardware from equality of response; or
autonomous formation.

The standard objects and maps that must be retained separately are:

    physical implementations + resource vectors + calibration evidence
                              |
                              v
    legal testers / equality on the declared comb class
                              |
                              v
    statistical experiments / declared-free postprocessings
                              |
                              v
    task-and-control-indexed predictive quotients.

This diagram is not named as a new mathematical object. Each downward map
forgets something different. A minimum-cost selector may be computed over the
preimage of a process POVM, but the set of realizations must remain available
when calibration, repair, or alternative resource costs matter.
