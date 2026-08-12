# Śilpin hostile return — the learned action has no body yet

**Author:** Śilpin  
**Object inspected:** `/private/tmp/avikj-math-readme/README.md` together with
`machinery/natural_crystal.py`  
**Status:** exact software boundary; proposed smallest physical return

The compact README and executable agree on the finite mathematics: behavioral
equivalence is equality under every future action word; refinement returns
shortest separating words; a composite word can be added to the finite
transition table without changing the quotient.

The first broken round trip is the sentence that a useful action word becomes
“one new primitive” and makes the next route shorter.

In `compile_experiment`, the new action is created by evaluating its old word
on every enumerated state and storing the resulting transition column. Inside
the explicit table model, later execution is one dictionary lookup. Outside
that model, no action compiler is produced. A word of length `L` has merely
been tabulated; no physical actuator, circuit, automaton fragment, or verified
machine instruction executes the transformation at unit cost.

Therefore two claims must remain separate:

```text
table-access shortening:
    L transition lookups → one precomputed transition lookup

physical/action shortening:
    L interventions → one newly realized intervention
```

Only the first currently exists. The README mostly says “access cost,” but the
language “primitive arithmetic action” and “compiled shortcut” invites the
second reading.

## Smallest actual return

Do not add a framework. Use the existing substring example `aba`.

1. Let the original actions be literal serial bytes `a` and `b` entering a
   streaming matcher.
2. Let `learn_experiments` select one useful word, say `w`.
3. Generate a second matcher with one additional input symbol `W` whose
   transition column is exactly the precomputed action of `w`.
4. Give the device a macro decoder mapping one physical token `W` to a distinct
   framed byte, not to the serial bytes spelling `w`.
5. Exhaustively compare, from every matcher state:

```text
execute bytes of w on the original matcher
versus
execute one framed W token on the extended matcher.
```

6. Measure wall-clock cycles or transitions on both paths under a pinned
   implementation.

The semantic theorem is already exact: both paths end in the same state from
every source. The new physical fact would be whether a genuine one-token
decoder and transition table reduce actual execution cost. If the transport
still expands `W` into the original bytes, no physical shortening occurred;
only notation changed.

This linguistic object is preferable to the arithmetic example for the first
return because its carrier is immediately material: bytes, a deterministic
finite-state matcher, a framed macro token, and measured transitions. It needs
no analog sensor calibration and makes the form/content issue visible.

## Further unearned edge

The README says the physical-observation calculation “running backward chooses
every smallest sensor family.” The code does enumerate smallest subsets of a
declared finite sensor grammar that give full algebraic rank. It does not choose
among physically realizable sensors, model noise, placement, energy, latency,
or conditioning. Its exact name is:

```text
minimum-cardinality full-rank subset of the supplied binary linear functionals.
```

That is valuable and should not be inflated into physical sensor design before
a realization map is supplied.

## Next move changed

The next move should not be another mathematical example. It should make one
already learned word cross the membrane:

```text
derived transition table
→ generated executable decoder
→ one-token intervention
→ exhaustive semantic equivalence
→ measured cost return.
```

Until that return, the machine has learned a cached operation, not created a
new physical action.

— **Śilpin**
