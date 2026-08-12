# Reverse pair BFS computes the entire finite future

**From:** Madhavi  
**To:** all collaborators  
**Status:** exact theorem and implementation candidate; not yet implemented

Let `X` be a finite set of `n` states, `A` a finite action alphabet,
`delta : X x A -> X` a total deterministic transition, and `obs : X -> O`.
Put a directed `a`-edge on the product by

```text
(x,y) --a--> (delta(x,a), delta(y,a)).
```

Let `B = {(x,y) | obs(x) != obs(y)}`.  Build reverse adjacency once and run
multi-source breadth-first search from every vertex of `B`.

## Theorem

For every `(x,y)`:

1. its reverse-BFS distance from `B` is exactly the minimum length of a word
   `w` for which `obs(run(x,w)) != obs(run(y,w))`;
2. it is unreached exactly when `FutureEq delta obs x y` holds;
3. storing the action on the first discovering reverse edge reconstructs a
   shortest distinguishing word;
4. the maximum finite distance is the exact distinction horizon.

Thus one traversal computes the behavioral quotient, every shortest
counterexample to equality, and the horizon simultaneously in
`O(|A| n^2)` time and space.  Using unordered pairs halves the vertices but is
not required.  The current `explain_distinctions` invokes a fresh pair-BFS for
each unordered pair, so its worst-case time is `O(|A| n^4)`.

## Proof

The empty word distinguishes precisely the vertices in `B`.  For a nonempty
word `a :: w`, the pair `(x,y)` is distinguished by `a :: w` precisely when
its `a`-successor is distinguished by `w`.  Induction on word length therefore
identifies the `k`th reverse-BFS layer with pairs whose shortest distinguishing
word has length `k`.  The unreached complement is observation-equal and closed
under every componentwise action; conversely, any pair outside `FutureEq` has
some finite distinguishing word and hence a path to `B`.

Equivalently, the distinguishable-pair relation is the least fixed point of

```text
Phi(S) = B union {(x,y) | exists a, (delta(x,a),delta(y,a)) in S},
```

while `FutureEq` is its complement, the greatest action-stable relation inside
the kernel of `obs`.

## Exact boundary

Generic reachability on the `n^2`-vertex product only gives a quadratic path
bound.  The sharper `max(n-2,0)` witness bound in
`notes/FINITE_FUTURE_HORIZON.md` comes from refinement of equivalence classes,
not from graph size.  The implementation should retain that assertion as an
independent structural check; reverse BFS computes exact distances but does
not by itself explain the linear bound.

## Replay path

Replace the repeated calls in `explain_distinctions` by one helper returning a
map from every unordered pair to `None` or its stored shortest word.  Compare
the resulting maps byte-for-byte against the current implementation in the
existing exhaustive suite of all 5,898 tiny worlds.  Also check every returned
word by `run_word`, and check that deleting its final action makes its prefix
non-distinguishing.

— Madhavi
