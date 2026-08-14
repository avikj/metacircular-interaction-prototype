# Optimization through forgetting

Many useful representations are obtained by forgetting structure.  A chain
complex can be viewed without its group action, a physical experiment without
its calibrated noise law, and a Horn rule without the weakening contexts in
which it must remain valid.  Forgetting can make an optimization problem
smaller.  It can also change its answer.

This note records the common exact boundary.  It is not a claim that symmetry,
logic, and statistical experiments are the same object.  They instantiate the
same lifting question, and their different residuals are the information that
the abstraction removed.

## 1. Feasible lifts, not resemblance

Let `U : C -> D` forget structure.  Fix structured objects `A,B`, feasible
morphisms `F_C(A,B)`, and relaxed feasible morphisms `F_D(UA,UB)`, with

\[
  U(F_C(A,B))\subseteq F_D(UA,UB).
\]

For a relaxed candidate `p`, its exact residual is the lifting fiber

\[
  \operatorname{Lift}_U(p)=\{f\in F_C(A,B):U(f)=p\}.
\]

Suppose costs lie in a product order and are preserved by forgetting:
`c_C(f)=c_D(Uf)`.  If `p` is Pareto-optimal downstairs, then every element of
`Lift_U(p)` is Pareto-optimal upstairs.  Indeed, an upstairs dominator would
forget to a downstairs dominator.  Consequently

\[
 \text{optimize then lift is valid at }p
 \quad\Longleftrightarrow\quad
 \operatorname{Lift}_U(p)\ne\varnothing.
\]

> **Constructive pointer (genius-10, 2026-08-14).**  In `--cubical --safe`
> the displayed biconditional is three different statements, because
> `Lift_U(p) ≠ ∅` is `¬¬Lift_U(p)`, step 4 of §5 needs an element of
> `Lift_U(p)`, and `∥Lift_U(p)∥₁` sits between them.  The Pareto sentence
> above is constructive and hypothesis-free; the biconditional, at the
> generality stated here, is equivalent to excluded middle; and the
> repair is the discreteness hypothesis this section already invokes two
> paragraphs below.  Checked, exit 0, no postulates:
> `formal/cubical/LiftingFiberResidue.agda`.  Nothing in this note is
> retracted by that module.

It is valid on the whole relaxed frontier exactly when that frontier lies in
the image of the structured feasible hom-set.  The smallest counterexample has
two parallel relaxed arrows `p,q : s -> t`, with costs `0,1`, while only `q`
has a structured lift.  The unique relaxed optimum is not executable upstairs.

No faithfulness assumption on `U` is needed.  Exact cost factorization prevents
two morphisms in one `U`-fiber from strictly dominating one another.  The
equivalence above concerns lifting the particular chosen downstairs optimum;
it does not identify the complete upstairs and downstairs frontiers.  It can
fail if forgetting drops, bounds, or merely estimates a cost coordinate.

If forgetting also deletes cost coordinates, the residual cannot honestly be
compressed to one penalty.  Retain the Pareto antichain of costs in each
lifting fiber.  For discrete feasible candidate sets, taking the scalar
infimum over each fiber is the left Kan extension of cost along the candidate
map.  For non-discrete or enriched categories the indexing object is a comma
category and need not reduce to the strict fiber.  Optimizing any cheaper
surrogate is sound only when its chosen minimizer also minimizes the true fiber
cost and the infimum is attained.

## 2. Equations expose an empty fiber

When the structured category is presented by operations and equations, a lift
can be checked by commuting squares.  For an action of a presented monoid `M`,
a function `f : X -> Y` is an equivariant lift precisely when

\[
  f(x\cdot m)=f(x)\cdot m
\]

for every generator `m`; the law for all words follows by induction.  A failed
generator square is a finite witness that the lifting fiber is empty.

Horn weakening is the same mechanism in its native order.  A certified rule
`U -> b` is not merely a shortcut at the base set `U`.  It denotes the
compatible family

\[
  S\longrightarrow S\cup\{b\},\qquad S\supseteq U.
\]

Installing only the base edge forgets the context action.  With an irrelevant
atom `d`, the absent edge from `{a,b,d}` to `{a,b,c,d}` is the smallest witness.
The logical closure may remain unchanged while literal partial-state
reachability changes, because a macro can hide intermediate facts.  Thus the
compiled theorem is a context-indexed natural operation, not a rank-one graph
edge.

## 3. Fixed points do not commute with minimization

Let a finite group `G` act on a nonempty finite feasible set `M`, assume
`M^G` is nonempty, and let `f : M -> R` be invariant.  Then

\[
 \min_{M^G}f=\min_M f
 \quad\Longleftrightarrow\quad
 \operatorname{Argmin}_M(f)\cap M^G\ne\varnothing.
\]

This elementary identity is the exact obstruction behind the reflected
interval in `EQUIVARIANT_MORSE_OBSTRUCTION.md`: ordinary cancellation leaves
one cell, but the chosen integral cellular presentation has no nonempty
reflection-stable matching and leaves three.

The denominator is also visible algebraically.  If a finite `G`-set `X` has
orbit sizes `n_1,...,n_r`, augmentation on invariant integral chains has image

\[
 \varepsilon(\mathbb Z[X]^G)=\gcd(n_1,\ldots,n_r)\mathbb Z.
\]

An equivariant integral section exists exactly when that gcd is one.  Over the
rationals an orbit can be averaged using `1/n_i`.  The missing denominator is
not philosophical residue: it is the exact price of the forgotten symmetry
in that presentation.  Subdivision may create fixed cells and change the
price, so this is not an invariant prohibition on equivariant reduction.

## 4. Decision-sufficiency is the statistical lift

Let an implementable experiment be a Markov kernel `E : X -> Delta(Y)`, and
let a statistic `T : Y -> Z` produce the quotient experiment
`Q=T \circ E`.  If
there is a state-independent recovery kernel `R` with

\[
 E=R\circ Q,
\]

then `E` and `Q` are Blackwell-equivalent and have identical Bayes risk for
every decision problem.  For one fixed decision problem it is enough that some
Bayes-optimal full-observation rule factor as `delta=bar(delta) \circ T`, when
`T` is deterministic.  For a stochastic statistic, a decision kernel after
`Z` must attain the same Bayes risk.  This is the statistical form of a
nonempty lift: the forgotten observation can be reconstructed, or it was
irrelevant to the declared decision.

Data processing alone gives only that `Q` is no more informative than `E`; it
does not preserve rankings among different experiments.  A four-wire exact
counterexample makes the failure small.  With equal priors, let probe `A`
encode the hypotheses as `0000,0111` and probe `B` as `0000,1000`.  Under an
abstract independent IID bit-flip model with error `1/10`, maximum-likelihood
decoding gives

\[
 P_{err}(A)=3(1/10)^2(9/10)+(1/10)^3=7/250,
 \qquad P_{err}(B)=1/10.
\]

Now retain independence but let the first wire have error `1/10` and the
other three error `2/5`.  Unchanged coordinates cancel from the likelihood
ratio, and

\[
 P_{err}(A)=3(2/5)^2(3/5)+(2/5)^3=44/125,
 \qquad P_{err}(B)=1/10.
\]

The physical ranking is reversed.  No tie convention is needed because the
informative distances are odd.

The robust probe in `DEFECT_PROBE_REALIZATION.md` is therefore optimal only
inside its declared exchangeable IID channel, or under a stronger sufficiency
witness showing that the likelihood ratio depends only on Hamming distance.
With heterogeneous or correlated hardware, the implementable kernels—not the
quotient distance—must be optimized.

## 5. The common operation

The reusable construction is now compact:

1. state the structure being forgotten;
2. compute an optimum in the smaller representation;
3. ask for a lift, recovery map, or complete family of commuting squares;
4. if it exists, transport the optimum with its witness;
5. if it does not, retain the residual: an empty fiber, failed square, orbit
   denominator, or ranking-reversal experiment;
6. change the representation only through an explicit refinement such as a
   new context, subdivision, calibration, or coefficient extension.

Compression is therefore not the deletion of distinctions.  It is a map with
a domain of valid transport.  Outside that domain, the obstruction describes
exactly which distinction the next representation must restore.
