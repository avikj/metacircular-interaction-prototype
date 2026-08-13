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
