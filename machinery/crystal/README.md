> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# `crystal` — a mathematical runtime, seed

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

Design and honest limits: `notes/RUNTIME.md`.

```
python3 machinery/crystal/demo.py             # compile a theory; ledger
python3 machinery/crystal/demo_transport.py   # decide a theory never compiled
python3 machinery/crystal/demo_obstruction.py # read a FAILED transport as mathematics
python3 machinery/crystal/demo_chakravala.py  # residuals driving the next move
python3 machinery/crystal/test_crystal.py -v  # 53 tests
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
| `obstruction.py` | failed transports kept as objects: the residual as a presented theory extension, classified FATAL / EXTENDS / UNORIENTABLE / EXHAUSTED / OUT_OF_SCOPE |
| `demo.py` | acceptance test: compile a theory, decide independent problems |
| `demo_transport.py` | acceptance test: decide a theory that was never compiled |
| `chakravala.py` | the cycle: each verdict selects its own next move; terminates by a lexicographic measure |
| `demo_obstruction.py` | acceptance test: a failed map must yield a true theorem |
| `demo_chakravala.py` | acceptance test: the cycle closes without blind retry |
| `test_crystal.py` | tests, including confluence of the result, a proves-too-much control, and rejection of a mistyped map |

**Failed transports are kept, not discarded** (`obstruction.py`). The
residual of a map that fails to be an interpretation is the presented theory
extension the target would have needed; completing it answers. From
right-zero → left-zero the machine derives a theorem nobody gave it — a
semigroup that is both has exactly one element, witness `?x = ?y`. From
monoid → pointed semigroup it names the two unit rules that were missing.

The absence of an answer is **typed**, never one null: `UNORIENTABLE` (this
order cannot see it — change the order, more budget is certain waste),
`EXHAUSTED` (a fact about what we spent; divergence is undecidable and is
not claimed), `OUT_OF_SCOPE` (the map has a gap; there is no mathematics
here). Merging them was a real defect, found by mutation testing before it
was understood: the mutant deleting the budget check survived.

Mutation-tested: 14 injected defects, 13 die. The one survivor is documented
in place as provably unreachable under LPO rather than hidden.

Algorithms are classical and cited in `kernel.py`'s docstring — Knuth–Bendix
1970, Kamin–Levy LPO, Robinson unification, content addressing. None of them
is claimed as new. What is being tried out is the composition: derivations
retained on every rule, exact addresses, and a ledger that makes "this
theorem made later work cheaper" a number instead of a belief.
