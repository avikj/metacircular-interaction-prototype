# Proof-carrying min-plus compilation

## Exact finite theorem

Let `G=(V,E)` be a finite directed graph whose edges are checked primitive
proof steps with nonnegative access costs.  Let `D(x,y)` be its exact shortest
path distance, with infinity when `y` is unreachable from `x`.

Suppose an existing nonempty edge path `pi:u -> v` has been checked.  Install
it as a macro edge `e:u -> v` of nonnegative access cost `c`, while retaining
`pi` as its validation expansion.  Then:

1. reachability and theorem closure do not change;
2. every new access distance is

   ```text
   D'(x,y) = min(D(x,y), D(x,u) + c + D(v,y));
   ```

3. all new distances are computed by one `O(|V|^2)` min-plus outer-product
   relaxation after the old all-pairs distances are known;
4. the strict influence cone of the installed theorem is exactly

   ```text
   I_e = {(x,y) : D(x,u)+c+D(v,y) < D(x,y)};
   ```

5. validation cost remains the sum of primitive costs along `pi`, even when
   future access uses `e` at cost `c`.

**Proof.**  The macro expands to an old path, so it creates no new reachable
pair.  With nonnegative costs, a shortest augmented path can be chosen simple
and therefore uses the new edge at most once.  A path avoiding it costs at
least `D(x,y)`.  A path using it factors into an old path `x -> u`, the macro,
and an old path `v -> y`; minimizing the old parts gives the displayed second
term.  Both terms are realizable, proving equality.  The remaining statements
follow directly.

This is the exact finite mechanism by which accepted mathematics changes the
cost geometry of later mathematics without rewriting theorem closure.

## Executable artifact

`machinery/proof_metric.py` provides:

- exact integer/Fraction edge costs;
- exact Floyd--Warshall distances with replayable edge witnesses;
- certificate validation against an existing contiguous path;
- macro installation by the `O(n^2)` theorem update;
- independent fresh APSP recomputation, failing closed on disagreement;
- the strict influence cone, old/new costs, validation cost, and macro
  expansion.

Replay:

```bash
python3 -m unittest machinery/test_proof_metric.py
```

The tests cover fractional costs, exact influence, unchanged reachability,
non-improving macros, unknown/discontinuous/wrong-endpoint/negative
certificates, duplicate names, undeclared endpoints, zero-cost cycles, and the
hyperedge boundary.

## What becomes a new operation

A theorem is installed as two linked objects:

```text
access edge:       a cheap operation available to later searches;
validation path:   the pinned primitive derivation replayed when trust changes.
```

The influence cone is not a citation count.  It is the exact set of ordered
goals whose shortest known access proof strictly decreases under the declared
cost model.  Sequential theorem installations are incremental
Floyd--Warshall relaxations.  This supplies a finite compiler target for the
repository's claim that understanding must change subsequent mathematical
motion.

## Boundary and obstruction

The graph theorem does not cover arbitrary proof systems.  A Horn rule

```text
{a,b} -> c
```

cannot be flattened to the edge `a -> c`: doing so silently drops premise
`b`.  Multi-premise inference needs an AND/OR hypergraph, weighted operad, or
another carrier whose states include proved-premise sets.  The implementation
therefore rejects `HyperRule` inputs rather than manufacturing a graph result.

Further boundaries:

- unification, binders, dependent contexts, and theorem schemas are not fixed
  graph endpoints;
- access costs are declared nonnegative; truth, novelty, empirical support,
  and authorization are not encoded by them;
- zero-cost cycles preserve distances but can make shortest provenance
  nonunique;
- revoking a primitive dependency must quarantine every macro whose expansion
  uses it and recompute affected distances; deletion is not the insertion
  theorem proved here;
- the implementation is a standalone exact kernel and has no authority to
  promote repository claims.

## Dependencies and next theorem

This construction harvests two existing lines without modifying either:

- `notes/GENERATED_ACTION_COMPLETION.md` separates semantic closure from the
  access metric changed by a conservative proof shortcut;
- `notes/PERSISTENT_CONSTRUCTIVE_SALON.md` requires immutable, replayable
  judgment dependencies.

The next theorem should lift the compiler from ordinary paths to finite Horn
hypergraphs.  The correct distance is the minimum derivation-tree cost, not a
pairwise path metric.  A compiled lemma remains conservative when its
certificate is a valid old derivation tree; the open problem is an exact
incremental update law and influence object that does not recompute every
downstream proof tree.
