# Closed-unitary boundary for a finite syntactic monoid

## Question

The arithmetic organism has acquired a finite synchronized transformation
monoid `M`: its elements are the effective state transformations induced by
action words, with word composition as multiplication. Can this whole object
be represented faithfully as closed quantum dynamics on one Hilbert space?

Here **closed-unitary representation** means an injective monoid homomorphism

`rho : M -> U(H)`, `rho(ab)=rho(a)rho(b)`, `rho(1)=I`.

This is deliberately stronger than implementing each action separately by a
unitary dilation. It asks that the effective action itself, with no retained
environment or history, be a unitary and that composition remain exact.

## The theorem

**Theorem.** A finite monoid has a faithful closed-unitary representation if
and only if it is a group.

**Proof.** If `rho : M -> U(H)` is injective, cancellation in the unitary group
pulls back to `M`: from `ab=ac`, multiplication by `rho(a)^{-1}` gives
`rho(b)=rho(c)`, hence `b=c`; similarly on the right. Thus `M` is cancellative.
For each `a in M`, left multiplication `L_a : x |-> ax` is then injective and,
because `M` is finite, surjective. Therefore `ab=1` for some `b`. Likewise
right multiplication is surjective, so `ca=1` for some `c`; associativity
gives `c=c(ab)=(ca)b=b`. Every element is invertible, so `M` is a group.

Conversely, every finite group acts faithfully on the Hilbert space with basis
`{|g> : g in M}` by the left regular permutation representation. These
permutation matrices are unitary and multiply exactly as the group does. QED.

There is a one-line local obstruction. If `e^2=e`, then any unitary image
satisfies `rho(e)^2=rho(e)`, and multiplication by `rho(e)^{-1}` yields
`rho(e)=I`. Hence every idempotent is collapsed to the identity. A reset map
`r(x)=x_0` is a nonidentity idempotent, so the two-element monoid `{1,r}`
already has no faithful closed-unitary representation.

For a finite transformation monoid, being a group is equivalent to every
transformation being bijective. If the generators are permutations, their
finite closure contains their inverses (a sufficiently high positive power),
and is a group. If the closure contains a merger, reset, projection, or any
noninjective map, it is not a group and the theorem applies.

## Exact correspondence and the residual

The group of units `U(M)` is exactly the largest part of the action algebra
that can be represented faithfully by closed unitaries under the theorem's
interface. The remaining actions are not “approximately quantum”; they are
irreversible at the predictive quotient.

For an individual deterministic transformation `f : X -> Y`, a coherent
implementation is still possible as an isometry

`|x> |0> |-> |f(x)> |g_x>`,

where garbage states belonging to a common output fiber must be mutually
orthogonal. The minimum environment dimension is therefore

`max_y |f^{-1}(y)|`.

That is a dilation, not a unitary representation of `f` on the quotient
alone. Under repeated composition, the environment/history must remain
available or be uncomputed from other retained information. Discarding it
gives a channel; measuring it gives an instrument. Neither operation turns
the non-group monoid into closed reversible dynamics.

## Change to organism motion

Do not seek one faithful closed-unitary model of the synchronized syntactic
monoid unless the computed monoid is a group. Instead compute, together:

1. its unit group, which supports native reversible compilation;
2. each nonunit's fiber profile, which prices a one-step coherent dilation;
3. the history/alignment needed for compositions of nonunits;
4. the chosen operational quotient: retained environment, discarded channel,
   measured instrument, or explicitly lossy group quotient.

This partition preserves the distinctions among predictive quotient, process
tensor, reversible computation, causal order, and memory. The monoid describes
effective compositional actions. A unitary dilation adds hidden reversible
degrees of freedom. A channel describes what remains after those degrees are
discarded. None by itself supplies indefinite causal order or spacetime.

## Rigor boundary

Proved here: the finite-monoid equivalence, the idempotent obstruction, and
the finite-transformation-monoid bijectivity criterion. The fiber-dimension
statement is reproved by orthogonality of inputs in each common-output fiber
and attained by fiber labels; it agrees with the earlier coherent quotient
dilation theorem.

Not claimed: that every useful quantum realization must be a faithful closed
representation; that channels cannot offer computational advantages; that a
minimal dilation composes with independently minimal dilations; or that the
monoid alone determines a process tensor, causal order, memory cost, or
spacetime interpretation.
