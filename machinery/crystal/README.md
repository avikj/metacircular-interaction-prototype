# `crystal` — a mathematical runtime, seed

Design and honest limits: `notes/RUNTIME.md`.

```
python3 machinery/crystal/demo.py             # compile a theory; ledger
python3 machinery/crystal/demo_transport.py   # decide a theory never compiled
python3 machinery/crystal/test_crystal.py -v  # 35 tests
```

Native state is content-addressed typed terms plus *checked transformations*
between them. The point is that accepted mathematics is stored in executable
form, so proving something changes what the runtime can do and how cheaply.

**Measured claim.** Three group axioms in (associativity, left identity,
left inverse). Ten independent problems, fixed before compilation and never
seen by the compiler. Before: 1 of 10 decided, 53,870 search nodes spent.
After: 10 of 10 decided in 16 rewrite steps total. Nine problems moved from
*unreachable within budget* to *terminating in 1–3 steps*. The compiled
system is exactly the canonical ten-rule system for group theory, which is
how you can tell it is right and not merely plausible.

**Failure modes, also measured.** Abelian groups: commutativity is reported
`unorientable` and the theory compiles only partially. Bands: the loop
diverges, emitting an infinite family of ever-longer correct rules. Both are
in `notes/RUNTIME.md` §4 with the terms printed.

**The second edge type.** `transport.py` adds interpretations between
theories: a declared signature map, accepted only if every source axiom
becomes a theorem of the target. Once checked, the source theory's problems
are decided by the target's compiled system — the source is never compiled.
Measured: right-zero semigroups decided in 8 steps by the left-zero system,
on one map checked in 4. The type is not decoration — the two theories are
anti-isomorphic, and the same map declared as a plain isomorphism is
rejected. Since the mistyped map is the identity on terms, accepting it
would have returned `a*b = b` as false.

| file | contents |
|---|---|
| `kernel.py` | terms + addressing, matching, unification, LPO, rewriting, critical pairs, completion, the cost ledger, and the uncompiled-search baseline |
| `transport.py` | interpretations between theories, checked, with transport |
| `demo.py` | acceptance test: compile a theory, decide independent problems |
| `demo_transport.py` | acceptance test: decide a theory that was never compiled |
| `test_crystal.py` | tests, including confluence of the result, a proves-too-much control, and rejection of a mistyped map |

Algorithms are classical and cited in `kernel.py`'s docstring — Knuth–Bendix
1970, Kamin–Levy LPO, Robinson unification, content addressing. None of them
is claimed as new. What is being tried out is the composition: derivations
retained on every rule, exact addresses, and a ledger that makes "this
theorem made later work cheaper" a number instead of a belief.
