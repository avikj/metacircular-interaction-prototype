# The elementary-context transformation monoid of a finite crystal

## Result

The contextual quotient in `COMPOSITIONAL_CRYSTAL_THEOREM.md` remembers the
states that no linear one-hole experiment can distinguish.  There is a dual finite
object which the quotient did not yet expose: the monoid of distinct
experiments acting on those states.

Let `A` be a finite algebra with signature `Sigma`, let `o:A->Y`, and let

```text
x ~ y  iff  o(C[x]) = o(C[y])
             for every unary polynomial context C[-].
```

Write `Q=A/~`.  Every elementary translation

```text
x |-> f(a_1,...,a_(i-1),x,a_(i+1),...,a_n)
```

descends to an endomap of `Q`.  Let `M_o` be the submonoid of `End(Q)` generated
by these descended translations.

Then:

1. `M_o` is finite and acts faithfully on `Q`;
2. every linear unary context, in which the hole occurs exactly once, induces
   an element of `M_o`, and every element of `M_o` is induced by a composite
   of elementary contexts;
3. for `x,y in A`,

   ```text
   x ~ y  iff  o_bar(m[q(x)]) = o_bar(m[q(y)]) for every m in M_o;
   ```

4. distinct points of `Q` possess a finite separating word in the elementary
   translations; breadth-first generation returns a shortest such word;
5. two context words become equal in `M_o` exactly when they induce the same
   transformation of every contextually distinguishable state.

Thus `Q` is the minimal state for the declared linear contexts and `M_o` is
its effective algebra of generated linear unary experiments. Observation does not sit
outside generation: it determines which generated contexts remain different.

## Proof

The contextual relation is a congruence, so every elementary translation
preserves its classes and descends to `Q`.  Their composites form a finite
submonoid of `End(Q)`, proving finiteness and (2).  It acts faithfully because
`M_o` is defined as a set of endomaps rather than as context words modulo an
unexamined presentation.

Every linear unary context is built by composing elementary translations, so
its action lies in `M_o`. Conversely, every generator is an elementary
context and composition plugs one context into the hole of another.  Statement
(3) is therefore exactly the definition of contextual equivalence with the
quantification replaced by the finite image of all contexts.

If two quotient points had no separating element of `M_o`, representatives of
those points would agree under observation in every unary context, contrary to
their being distinct classes.  Since `M_o` is finite and generated, breadth-
first enumeration finds a shortest separating word.  Finally, equality in
`End(Q)` is pointwise equality on every quotient state, which proves (5).

## Two exact controls

For `A=Z/4Z` under addition and parity observation, the contextual quotient is
`Z/2Z`.  All translations collapse to the two-element transformation group:
identity and parity flip.  Four carrier translations have become two effective
experiments.

For `A=Z/3Z` under addition and observation

```text
o(0)=0,  o(1)=o(2)=1,
```

the present observation merges `1` and `2`, but translation by `1` separates
them.  Hence `Q` has three points and `M_o` is the cyclic three-element
translation group.  The program returns a one-generator separating word for
the pair hidden at time zero.

## Why this changes the route

The current finite crystal had compiled a safe quotient but not the algebra of
ways by which its distinctions become visible.  The new pair

```text
(Q, M_o acting faithfully on Q)
```

is a finite generated-action object.  It is simultaneously:

- the state side and action side of the generalized Myhill--Nerode theorem;
- an executable compression of infinitely many polynomial contexts;
- a source of shortest separating continuations;
- a finite semantic target against which a proposed rewrite presentation can
  be tested;
- the precise finite precursor of the task-relative syntactic monoid and its
  profinite completion described in `GENERATED_ACTION_COMPLETION.md`.

This also answers the immediate operational-site question narrowly.  A family
of raw probes may separate carrier points, while `M_o` records closure under
the algebra's admissible contexts.  The restricted profile

```text
q |-> (o_bar(m q))_(m in M_o)
```

is injective by construction.  It reconstructs the crystal's objects, not all
morphisms of an arbitrary ambient category; no general density theorem is
being claimed.

## Executable artifact

`machinery/context_monoid.py`:

1. computes the existing compositional crystal;
2. descends and deduplicates elementary translations;
3. closes them under composition by breadth-first search;
4. retains a shortest generator word for every effective transformation;
5. emits a shortest observation-separating word for every pair of quotient
   states.

`machinery/test_context_monoid.py` checks the two examples above, duplicate
generator collapse, and a malformed-operation failure control using exact,
dependency-free finite computation.

## Rigor boundary

The theorem above is elementary finite universal algebra and automata theory;
no literature novelty is claimed.  The artifact is new repository capability.
It does not compute the full unary polynomial clone: a variable-sharing term
such as `x XOR x` need not be generated by composing one-occurrence contexts.
It also does not compute a presentation-minimal generating set for `M_o`, prove
a general profinite theorem, handle binding or dependent syntax, invent new
experiments, or establish physical realizability. Those are successor
questions, not consequences of finite closure.
