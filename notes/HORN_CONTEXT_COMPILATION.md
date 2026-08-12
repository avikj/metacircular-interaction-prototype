# Context-indexed compilation for finite Horn systems

## Exact carrier

Let `P` be a finite atom set.  A partial proof state is a subset `S` of facts
already available.  A fact-adding Horn rule

```text
U -> b
```

is enabled when `U` is contained in `S` and moves `S` to `S union {b}` at its
declared nonnegative access cost.  States are deliberately not fully closed
theories: full deductive closure would already contain every derived
conclusion and would erase the access-cost phenomenon being measured.

Suppose a nonempty old derivation from `U` certifies `b`.  Installing it as a
macro of access cost `c` is conservative.  By weakening, the same certificate
is valid in every context `S` containing `U`.  The compiled rule is therefore
the edge family

```text
e_S : S -> S union {b}
```

over all `S` containing `U` but not `b`.

## Exact update theorem

Let `D` be the exact all-pairs distance on the old subset-state graph.  Then

```text
D'(X,Y) = min(
  D(X,Y),
  min over enabling S of D(X,S) + c + D(S union {b},Y)
).
```

**Proof.**  Horn transitions only add facts.  After one productive use of the
new macro, `b` is present forever, so that path cannot productively use the
macro again.  Every augmented path either avoids the macro or factors through
exactly one enabling edge `e_S`.  Minimizing its old prefix and suffix gives
the formula, and each displayed candidate is realizable.

The macro is conservative for Horn entailment: it adds only a conclusion
already derivable from its premises.  It need not preserve reachability among
literal partial-knowledge subsets.  A multi-step validation may use an
intermediate fact `x`; the macro can reach `S union {b}` transactionally
without permanently installing `x`, whereas primitive state transitions reach
`S union {x,b}`.  The implementation reports such newly reachable operational
pairs with old distance infinity.  If exact subset-state reachability must be
preserved, restrict certificates to an already existing single transition or
make the macro target retain every installed intermediate fact.

The update is a minimum of context-indexed min-plus outer products.  It is not
generally one rank-one relaxation.

## Small rank-one obstruction

Let an existing expensive certified rule be `{a,b} -> c`, compile a cheaper
access macro for it, and add an irrelevant atom `d`.
Compilation must accelerate both

```text
{a,b}   -> {a,b,c}
{a,b,d} -> {a,b,c,d}.
```

Installing only the first edge cannot accelerate the second.  The monotone
state graph has no path `{a,b,d} -> {a,b}` because no transition deletes `d`.
Thus a single fixed source/target edge fails to express Horn weakening.  The
test checks this with the existing expensive direct transition as certificate,
so reachability stays fixed and only the metric contracts.  A separate hostile
test records the multi-step intermediate-fact boundary described above.

## Executable construction

`machinery/horn_metric.py`:

- enumerates the finite partial-knowledge powerset;
- compiles every primitive Horn rule in every enabling context;
- replays a proposed macro certificate from its declared premises;
- lifts the certified rule to its complete weakening family;
- performs the context-indexed min-plus update;
- independently recomputes APSP after adding all macro edges and fails closed
  on disagreement;
- emits validation cost, macro instances, exact witnesses, and the strict
  influence cone.

Replay:

```bash
python3 -m unittest machinery/test_horn_metric.py
```

## Scope boundary

This is finite, propositional, monotone, single-conclusion Horn inference.

- A deletion rule invalidates the one-use proof and the subset order.
- A linear-resource rule consumes multiplicity and needs multiset or linear
  proof states.
- Bindings, unification, dependent contexts, theorem schemas, and shared DAG
  pricing are not represented.
- The explicit state space has size `2^|P|`; the theorem is local in the state
  graph but not polynomial in the number of atoms.
- Validation cost is the primitive certificate sum.  Access cost is the
  installed macro cost.  Neither is mathematical truth or research value.

Deletion and linear-resource inputs are rejected explicitly rather than
flattened into unsound Horn edges.

The next mathematical target is a symbolic version of the context-indexed
minimum that avoids enumerating all subsets when rule premises have bounded
width or the implication hypergraph has bounded treewidth.
