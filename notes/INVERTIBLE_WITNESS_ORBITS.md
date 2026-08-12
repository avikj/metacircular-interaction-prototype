# Invertible dynamics collapse witness reachability to pair orbits

Let a finite alphabet act on a finite set `X` by permutations.  Write `G` for
the generated permutation group and let `G` act diagonally on `X×X`:

\[
g\cdot(x,y)=(gx,gy).
\]

For a family `N` of observations, call `(u,v)` an `N`-seed when some
`n∈N` satisfies `n(u)≠n(v)`.

**Theorem.** A pair `(x,y)` is distinguishable by a future word followed by an
observation in `N` if and only if its diagonal `G`-orbit contains an `N`-seed.

**Proof.** A distinguishing word induces an element of `G` and sends `(x,y)`
to a seed.  Conversely an orbit element is induced by a word: the generators
are permutations of a finite set, so the monoid they generate is already a
group (a sufficiently high positive power supplies each inverse).  Hence any
seed in the orbit is reachable by an admitted positive word. □

Consequently, after deleting a subfamily `R⊆N`, the semantic status of a
pair changes exactly when its diagonal orbit contained an `N`-seed but contains
no `(N\R)`-seed.  One seed-count or surviving-label set per diagonal orbit is
therefore sufficient for exact insertion and deletion of **equivalence**.

Shortest certificates remain metric data.  Removing the nearest seed can
increase shortest witness length while leaving the orbit split, so distances
or predecessor DAGs still require repair.  The theorem separates semantic
maintenance from shortest-proof maintenance.

## Covering-space realization

For a connected finite covering, loop lifting supplies a monodromy group on a
fiber.  Diagonal pair-orbits classify which ordered sheet pairs can be moved
into one another by common loop experiments.  A coloring distinguishes an
entire pair-orbit precisely when it differs at one pair in that orbit.

This statement concerns monodromy, not the deck group.  It fails for general
noninvertible transition systems: a pair may lie in the backward basin of a
seed without the seed lying in its strongly connected component.

## Rigor boundary

The theorem is finite and deterministic and assumes every action generator is
invertible.  It gives an exact dynamic semantic quotient, not a bound for
maintaining shortest words, compressed symbolic orbits, or infinite group
actions.
