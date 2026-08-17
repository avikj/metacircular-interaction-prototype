# A proved commutativity law now removes syntax before generation

`MathMachine` now compiles an accepted theorem
`f(x,y) = f(y,x)` into its generative grammar. For such a binary symbol it
constructs only the `cmpTerm`-ordered representative of each transposition
orbit. Activation is derived from `mKnown`; no operation is declared
commutative by host-language opinion.

The scoped exact control uses the grammar `{0,+}`, two variables, and size at
most seven. Generate-then-normalize under the two directed uses of
commutativity and canonical-generation-then-normalize produce exactly the same
normal-form set. State counts are:

```text
raw ordered syntax:       471
orbit representatives:   102
terms never constructed: 369 (78.3%)
```

This is the requested theorem-induced optimization: an accepted symmetry
changes the future constructor, rather than adding a cache around obsolete
syntax. The proof boundary is scoped to one binary commutativity action;
associativity, idempotence, and interacting AC theories require their own
canonical combinatorial species and are not inferred.
