# Accepted AC theory compiles binary trees to multiset representatives

When a binary symbol has both accepted commutativity and associativity laws,
`MathMachine` now generates its terms as sorted operand multisets encoded by a
fixed right bracketing. It rejects a candidate constructor if the left child
would continue the same operation or if the flattened operands are not in the
machine's reduction order.

The exact scoped control compares the old binary grammar followed by the AC
canonical map with the compiled grammar followed by that same map:

```text
all binary syntax trees: 471
AC multiset representatives: 34
never constructed: 437 (92.8%)
canonical coverage: exact
```

Law recognition no longer depends on variables being literally `x,y,z` or on
their numeric indices. It matches the variable-incidence diagram, requires two
distinct variables for commutativity and three for associativity, and accepts
either orientation. Controls use indices `9,4` and `8,3,11`.

This remains deliberately scoped: no unit, idempotence, distributivity, or
interaction between different AC symbols is inferred.
