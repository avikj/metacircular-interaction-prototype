# Finite continuation semantics reconstructs the cost relation

**Status:** safe Cubical Agda, finite two-interface core.  This extends the
existing `DSOFinite` counterexample; it does not duplicate the runtime's Pareto
frontier.

`DSOContinuationFullAbstract.agda` adds the missing semantic layer:

- extended natural costs `fin n | ∞`, with min-plus choice/composition;
- cost relations on the finite Boolean interface;
- Bellman continuation transformers;
- Dirac continuations and entrywise reconstruction;
- full abstraction: equal action on every continuation implies equal cost
  relations;
- the Dirac identity law for min-plus composition;
- proof-relevant `Argmin`, retaining the active intermediate witness;
- the existing premature-local-argmin counterexample lifted to extended costs.

The reconstruction equation is

\[
T_K(\delta_c)(a)=K(a,c).
\]

Consequently the continuation transformer is not a lossy score.  It determines
the complete finite cost relation, and a scalar Bellman value may be projected
only after its active witness is retained.

In the checked control, the isolated first stage selects `false`; after the
continuation is supplied, the active witness is `true`.  The two witnesses are
proved distinct.  This is the exact premature-argmin obstruction already
present in `DSOFinite`, now expressed through proof-relevant transformer
semantics with structural infinity.

The crystal connection is `PARETO_PATH_QUANTALE_REDUCTION`: a finite Pareto
frontier is the minimal-generator presentation of an enriched hom-object.
This module supplies the scalar continuation semantics underneath that
interface.  It does not introduce a second vector-frontier implementation.

## Boundary

Generic Dirac reconstruction, full abstraction, and right identity are
checked.  Bellman/min-plus compatibility is checked on the planted DSO control.
A generic associativity/functoriality theorem for arbitrary extended-natural
matrices is **not yet checked** here; it requires the distributive ordered
semiring laws for `minC` and `⊗`.  The module must not be cited as that generic
quantale formalization.  It is currently orphaned from the root aggregate and
is verified by its direct safe-Agda invocation.
