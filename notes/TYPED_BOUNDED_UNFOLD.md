# Unary unfolding already carries the bounded-language theorem

Take the unary term calculus `x | h(t)` and interpret heads as endomorphisms of
`Q^3`. Install the definition

`M(x) := A(P(x))`.

Substitution proves structurally that eliminating `M` preserves denotation.
It also changes size: `D(M(x))` has invocation size two, while its base unfold
`D(A(P(x)))` has size three. In the matrices of
`RESIDUAL_LANGUAGE_GROWTH`, the denotation `DAP` is absent from the old
budget-two language and present after installing `M`.

Hence the current unary constructor is enough. What `GenerativeLoop` lacks is
not syntax but (1) an algebra interpreting heads and bodies, (2) semantic
preservation of unfold, and (3) separate invocation/unfolded costs. Its root
matcher reads only names, so it cannot state this strict denotation result.

`CompileBridge.agda` (`98991fa`) already proves a different, complementary
statement: task demand forces installation of a named checkpoint capability,
which flips a stipulated compiler to a cheaper replay-equal plan; it also
proves that vocabulary state alone underdetermines answers. The result here
does not duplicate that bridge. It supplies the missing body-sensitive case:
the installed definition has a matrix denotation, its unfold is proved equal,
and composing that body creates the next budget-reachable denotation.

There is a second boundary. `WitnessPolicy.inform` chooses the failed term's
recorded argument as the body. This is an informative abbreviation, but it is
not in general a synthesis procedure for the generic body `A(P(x))`; that body
must be extracted from a semantic certificate such as `QAP=BC` and proved base
covered. No additional term constructor repairs that gap.

The executable model checks semantic preservation for every installed-macro
term through size three, strict budget-two growth, and base coverage.

## Hostile closure: installation does not derive its price

Let a macro `M` unfold to a base word of minimum primitive cost `ell`, and give
`M` declared invocation cost `c`. For every continuation `w` of primitive cost
`d`, the macro spelling reaches `wM` within budget `B` exactly when
`d+c <= B`; its displayed unfold needs `d+ell <= B`. Thus this witness creates
a strict bounded-language gain precisely on the integer interval

`d+c <= B < d+ell`.

In the example, `(d,c,ell,B)=(1,1,2,2)`. If `M` is charged its unfolded cost
`c=ell=2`, the entire weighted denotation language agrees with the primitive
one at every budget: replacing each `M` by its body preserves both denotation
and cost. The tests verify equality at budget three and the exact threshold at
budget two.

Therefore the smallest false generalization in the new spine is: “installing
an informative definition causes future generative progress.” Installation
plus semantic unfold does not suffice. Progress additionally assumes a cost
model in which invoking the installed artifact is cheaper than its least base
realization. The repository can certify a proposed implementation/cost and
apply its break-even law; it does not yet derive invocation cost from the term
calculus or execute/measure a representation that earns it. This is the live
blocker to calling the spine self-modifying without qualification.

A second, logically independent input remains external: the projector `P`,
future operator/task, and allowed morphism class. Residual and minimal carrier
are forced only after these are supplied. Nothing in this finite calculus
selects the next observation or task whose failure should drive generation.
