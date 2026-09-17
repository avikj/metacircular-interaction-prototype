# Types Are Processes â” Transformations Are Executable

Pratt's *Types as Processes* asks how far the static/dynamic distinction survives once type constructors and process constructors are placed in the same semantic setting. *Gates Accept Concurrent Behavior*, dialectic lambda calculus, linear logic, and transformational mathematics pursue the same boundary from different directions: propositions accept behavior; transformations themselves become first-class mathematical content; state/event polarity is structural rather than an afterthought.

The cubical/dependent construction closes this boundary mechanically. A type is not merely a static label on a separate process. It is the space in which the construction lives; terms inhabit it; paths are executable identifications; dependent paths permit the ambient type to vary during the transformation; composition/filling supplies coherent higher composition.

Univalence is decisive. An equivalence `A â‰ B` becomes a path `A =_U B`, and coercion along that path computes the equivalence. A theorem that two structured presentations are equivalent therefore does not end with an external correspondence: every dependent construction over one presentation can be transported to the other.

Dynamic reflection lifts this through continuing behavior. If `Î¦ : A â’ A` and `e : A â‰ A'`, conjugate dynamics `Î¦' = e Î¦ eâ»Â` commute with the whole coinductive unfolding. The future does not need to be re-derived after a change of presentation; it transports.

Metacircularity closes the remaining meta/object split. An interaction can establish a typed transformation; that transformation remains an inhabitant of the same executable universe and can be installed as a subsequent operation. `IntrinsicRewrite`, self-presentation, and productive propagation make âthe mathematics changes the mathematicsâ a checked lifecycle rather than a metaprogramming slogan.

This is the point at which Pratt's transformational mathematics meets Lossless Interdependent Type Theory: type/process, assertion/action, representation/transformation, and proof/execution become roles within one continuing constructive object. The runtime realization is [The Interactive Symbolic Computer](10-interactive-symbolic-computer.md).

## Canonical checked construction

Dynamic carrier/transport: [`Nucleus.agda`](../../fibre/src/Fibre/Nucleus.agda). Universal family: [`Visvarupa...agda`](../../fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda). Metacircular lifecycle source: [`LIFECYCLE.rst`](../../LIFECYCLE.rst) plus the repository's `IntrinsicRewrite` / `ProductiveIndraNet` theorem modules.

## External coordinates

[Vaughan Pratt, Types as Processes via Chu Spaces](https://scholar.google.com/scholar?q=Vaughan+Pratt+Types+as+Processes+Chu), [linear logic](https://plato.stanford.edu/entries/logic-linear/), [univalence](https://ncatlab.org/nlab/show/univalence+axiom).
