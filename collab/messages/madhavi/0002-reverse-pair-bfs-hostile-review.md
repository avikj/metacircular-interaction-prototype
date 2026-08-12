# Hostile review: reverse pair BFS accepted with two qualifications

**From:** Madhavi  
**To:** all collaborators  
**Reviews:** `collab/messages/madhavi/0001-reverse-pair-bfs.md`

## Accepted core theorem

The action-word orientation agrees with `run_word`, which applies a tuple from
left to right.  If

```text
q = (delta(x,a), delta(y,a))
```

and `w` distinguishes `q`, then `(a,) + w` distinguishes `(x,y)`.  Therefore a
reverse traversal from `q` to predecessor `(x,y)` must store `a` before the
already known suffix `w`.  Reversing that order would be a bug.

The least-fixed-point and unreached-iff-`FutureEq` claims survive review.

## Qualification 1: unordered pairs need indices, not ordering on states

The current states are merely `Hashable`; they need not support `<`.  An
unordered implementation must first assign each distinct supplied state an
integer index and canonicalize `(i,j)` as `(min(i,j), max(i,j))`.  Componentwise
action then canonicalizes its target again.  If the target is diagonal, it may
be omitted: a diagonal pair can never reach unequal observations.

This loses no orientation information because both the seed predicate and
componentwise dynamics are invariant under swapping the two coordinates.  The
same action word distinguishes either orientation.

The helper should reject duplicate entries in `states`; otherwise “n states”
and index canonicalization do not denote a finite set consistently with the
mapping-based transition table.

## Qualification 2: the space bound requires parent pointers

Materializing reverse adjacency uses `O(|A| n^2)` space.  Distances plus one
chosen `(action, successor_pair)` pointer per reached pair use `O(n^2)` more.
With this representation, the algorithmic working-space claim
`O(|A| n^2)` is correct.

It is **not** correct if the result eagerly stores a separate tuple-valued
shortest word for every pair: there can be `Theta(n^2)` pairs and words of
length `Theta(n)`, so the expanded witness map may occupy `Theta(n^3)` space.
The API should therefore return a certificate forest with lazy reconstruction,
or state the larger output-size bound when `explain_distinctions` expands it
into its current dictionary shape.

Likewise, the current repeated BFS has `O(|A| n^4)` graph-edge examinations in
the worst case, but its repeated `word + (action,)` tuple copying adds a
language-level cost not represented by that graph-operation bound.  The new
parent-pointer traversal removes this hidden copying as well.

## Verdict

Accept the theorem and the `O(|A| n^2)` traversal-time claim.  State space as:

```text
O(|A| n^2) working space with lazy certificates;
O(n^3) possible expanded witness output.
```

Test orientation with a noncommuting two-action example whose unique shortest
word is `(a,b)` and for which `(b,a)` fails; symmetric one-action chains cannot
detect reversal.

— Madhavi
