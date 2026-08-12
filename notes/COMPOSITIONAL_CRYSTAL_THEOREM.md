# The compositional crystal theorem

## Exact finite theorem

Let `A` be a finite algebra with basic operations `Sigma` and let
`o:A -> Y` be an observation. A unary polynomial context is a term built from
the operations, constants from `A`, and one distinguished hole. Define

\[
x\equiv_o y
\quad\Longleftrightarrow\quad
o(C[x])=o(C[y])\quad\text{for every unary context }C[-]. \tag{1}
\]

Then:

1. `equiv_o` is the greatest `Sigma`-congruence contained in `ker(o)`;
2. every basic operation descends uniquely to `A/equiv_o`;
3. the quotient projection `q:A -> A/equiv_o` has the universal property that
   any map constant on its fibers factors uniquely through `q`; in particular,
   every algebra homomorphism whose kernel contains `equiv_o` factors uniquely
   as an algebra homomorphism;
4. for finite `A`, refinement under elementary one-hole translations
   `f(a_1,...,-,...,a_n)` computes `equiv_o`.

**Proof.** Equality under all contexts is an equivalence relation and lies in
`ker(o)` by the identity context. If `x_i equiv_o y_i`, replace the arguments
of a basic operation one at a time. Every outer context composed with the
resulting elementary one-hole context preserves the observation, so
`f(x_1,...,x_n) equiv_o f(y_1,...,y_n)`. Thus it is a congruence. Conversely,
if `R` is any congruence in `ker(o)`, induction on contexts gives
`x R y => C[x] R C[y]`, hence equal observations, so `R` is contained in
`equiv_o`. This proves (1). Congruence gives (2), and the standard quotient
argument gives (3). Elementary translations generate every unary polynomial
context under composition, so stable finite partition refinement gives (4).

## The leap

This theorem is the exact compatibility joint among the three crystal axes:

\[
\begin{array}{c}
\text{generation: operations build terms and contexts},\\
\text{observation: }o\text{ supplies the visible distinction},\\
\text{behavior: contexts act as intervention words},\\
\text{crystallization: the greatest invisible congruence is quotiented}.\\
\end{array}                                           \tag{2}
\]

The quotient kernel is an equational theory, not discarded anonymous data.
The fibers retain its concrete dependent origins. If `A` is a term algebra,
the quotient is its syntactic algebra relative to the observation; this is the
universal-algebraic/Myhill--Nerode pattern.

This does **not** prove Voevodsky's general Initiality Conjecture. It proves a
finite universal property after the algebra and its operations have already
been constructed. Initiality of a raw dependent type theory's term C-system is
substantially harder because binding, substitution, judgement formation, and
definitional equality must first be made into the correct structured category.

## Engine law

Never promote a raw observational quotient. First close observation under all
admissible compositional contexts. The resulting equivalence is precisely the
largest safe compression. If it is trivial, the lenses are compositionally
complete. If it is nontrivial, every identified pair is a certified invisible
equation. Adding a new lens refines the theory; adding a new operation adds new
contexts and may split old classes.

`machinery/compositional_crystal.py` implements the finite theorem and emits
the quotient operations, origin fibers, and invisible equations.

## Proof-relevant separation

The complementary certificate is constructive. For every pair not identified
by `equiv_o`, the finite refinement graph contains a path to a pair already
separated by `o`. Reading that path as nested elementary translations produces
a context `C[-]` with unequal outputs. Breadth-first/backward refinement yields
a shortest number of elementary contexts. The runtime emits such a context for
every inequivalent pair.

Thus the finite crystal is epistemically complete in both directions:

\[
\begin{array}{ll}
x\equiv_o y & \leadsto \text{an invisible equation valid in every context},\\
x\not\equiv_o y & \leadsto \text{an executable distinguishing experiment}.
\end{array}                                           \tag{3}
\]

The quotient no longer merely reports blindness. It synthesizes the least-depth
lens needed to resolve every resolvable ambiguity. Adding the synthesized
contexts as named probes converts behavioral evidence into a reusable tool.

## Contextual dimension

For finite `A`, elementary translations generate a finite transformation
monoid. Each transformation is a unary context behavior. Define

\[
\operatorname{cdim}_o(A)=min\{|S|:
x\mapsto(o(C[x]))_{C\in S}\text{ separates }A/{\equiv_o}\}. \tag{4}
\]

This is an exact minimum hitting-set problem: each context covers the pairs it
distinguishes, and all inequivalent pairs must be covered. The runtime enumerates
the finite context transformation monoid, retains a shortest word for every
transformation, and emits a minimum separating context basis.

Consequently the number of necessary crystal faces is a computed invariant. A
duality, trinity, quaternity, or twelvefold family is significant only when
`cdim` forces that cardinality under the declared operations and observation.

## Observability bridge

For a linear system `x -> A x` observed by `C x`, contextual invisibility is

\[
\mathcal N=\bigcap_{k\ge0}\ker(CA^k),               \tag{5}
\]

the largest `A`-invariant subspace contained in `ker C`. The finite
compositional theorem replaces linear powers by all polynomial contexts and
subspaces by congruences:

\[
\equiv_o=\bigcap_{D[-]}\ker(o\circ D),               \tag{6}
\]

the greatest operation-invariant equivalence contained in `ker o`. Thus the
natural crystal is a nonlinear algebraic observability construction. Its
distinguishing contexts are experiments; `cdim` is a minimum experiment basis;
its equivalence fibers are the structurally unobservable states.
