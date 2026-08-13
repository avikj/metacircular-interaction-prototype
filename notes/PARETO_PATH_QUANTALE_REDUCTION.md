# The Pareto machine is one enriched path completion

## Reduction

“A cost-enriched dependent category plus Pareto closure” sounds like three
structures.  For the finite continuation systems currently in the repository,
it is one standard universal object.

Let `S` be the state type and `Lawful(s)` the state-dependent move type, with
target `next(s,m)`.  This is a typed directed graph (equivalently, a dependent
polynomial transition signature).  Let costs lie in a commutative ordered
monoid

\[
(C,+,0,\le),
\]

where addition is monotone in both arguments.  Form `Up(C)`, the upward-closed
subsets of `C`, ordered by reverse inclusion if smaller cost is better.  Give it

\[
U\oplus V=U\cup V,
\qquad
U\otimes V=\uparrow\{u+v:u\in U,v\in V\}.
\]

Then `Up(C)` is an idempotent ordered semiring (and, with arbitrary unions, a
commutative quantale).

There is one essential separation.  The **directed derivation direction** is
the free `Up(C)`-enriched category on the lawful transition graph.  Its
hom-value `H(s,t)` is exactly the upward closure of costs of lawful paths from
`s` to `t`.  Semantic identity/equivalence is not another costed arrow in this
category.

When derivations must transport across proof-relevant equivalences, the
smallest unified object is the generated **double category/equipment**:

- horizontal arrows are directed derivations, enriched in `Up(C)`;
- vertical arrows are equivalences/representation changes;
- squares witness that a derivation transports compatibly across an
  equivalence.

This is not ornamental 2-dimensional language.  It is forced by the following
no-go.  If an additive nonnegative cost is assigned to an invertible arrow
`g`, then

\[
0=c(1)=c(g g^{-1})=c(g)+c(g^{-1}),
\]

so both costs vanish.  A single cost-enriched groupoid therefore erases every
nontrivial route cost.  Directed execution and semantic equivalence can
interact by squares but cannot be identified.

- state dependence is already the typing of horizontal generators;
- sequential execution is enriched composition;
- alternative paths are idempotent join;
- cost accumulation is the monoidal product;
- the Pareto frontier is the set of minimal generators of a finitely generated
  hom-value.

Thus Pareto closure is not an additional agent, policy, or categorical layer.
It is the finite normal form of a horizontal enriched hom-object.
`CoherentSection` in `LawfulContinuationCore` is the vertical gluing/transport
question.  A transport square can connect it to execution, but cost cannot be
placed on its invertible carry maps without collapsing to zero.

## Executable consequence: local pruning is exact

For finite cost sets `A,B subset C`, write `Min(A)` for their nondominated
elements.  Monotonicity of `+` gives

\[
\boxed{
\operatorname{Min}(A+B)
=
\operatorname{Min}(\operatorname{Min}(A)+\operatorname{Min}(B)).
}
\]

Indeed, every `a in A` is dominated by some minimal `a0 in Min(A)` and every
`b` by some `b0`; hence `a0+b0 <= a+b`.  Conversely the right side is a subset
of `A+B`, and both sides generate the same upward closure.

Therefore a finite acyclic lawful system can compute exact route frontiers by
dynamic programming:

```text
frontier(stop at s) = {0}
frontier(s) = Min union_{m : Lawful(s)}
                    (cost(s,m) + frontier(next(s,m))).
```

Dominated partial routes may be deleted immediately and can never become
nondominated after a common continuation.  This is the exact reusable
consequence for the wheel/reopening cycle: `(104,32)` and `(120,0)` remain as
two generators of one hom-value; a later action composes onto both, and local
Pareto normalization is semantics-preserving.

## Reopening

A newly admitted operator does not mutate the enriched category mysteriously.
It adds typed generators, or invalidates a proposed quotient functor because
the operator has nonzero leakage.  The universal map from the old free
enriched path category into the enlarged one preserves every old path; new
paths can strictly shrink a hom-value.  “Reopening” is therefore ordinary
monotone extension of a free enriched category together with failure of a
previous representation map to be functorial on the enlarged signature.

## Exact boundary

The reduction needs the declared cost algebra.  If continuation can lower a
cost coordinate, if resource effects depend on hidden state, or if histories
share caches so that path cost is not additive, plain `C` is insufficient.
The repair is not a looser Pareto heuristic: enlarge the state until cost is a
monotone compositional annotation.  This is precisely what the repository's
cache-relative formation results already forced.

For cyclic graphs, a finite Pareto presentation need not exist: incomparable
costs may accumulate indefinitely.  The free quantale-enriched category still
exists, but finite antichain execution requires a well-founded bound, widening,
or a proof that cycles have nonnegative progress forcing stabilization.  This
matches the explicit bounded-fixpoint warning in `runtime/SCALE.md`.

## Rigor boundary

The horizontal enriched-category identification, the groupoid-cost no-go, and
local-pruning identity are standard consequences of ordered-monoid
monotonicity.  This note does not claim novelty.  It diagnoses the exact
simpler universal property already instantiated by the repository: a
cost-enriched derivation category, an equivalence groupoid, and their transport
squares (freely, an equipment), rather than one undifferentiated dependent
category. `LawfulContinuationCore.agda` currently checks typed paths and
coherent sections but does not formalize `Up(C)` or the transport squares; the
runtime executes finite Pareto extraction with explicit bounds. A
kernel-checked generic pruning theorem remains an available consolidation, not
a missing mathematical idea.
