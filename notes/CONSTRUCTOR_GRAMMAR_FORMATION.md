# Observable formation as a shortest generated proof

A catalog says which observations already exist. A constructor grammar says
how observations can come into existence.

Take programs `q_m(x)=x mod m`, initially only `q_2`, with two constructors

- `q_m -> q_(m+1)`, cost one;
- `q_m -> q_(2m)`, cost one.

For a live collision `(a,b)`, call a reachable program successful when
`q_m(a) != q_m(b)`.

**Formation theorem.** In any finite nonnegatively weighted constructor graph,
Dijkstra search stopped at the first successful program returns a minimum-cost
separating observation. Its predecessor path is a replayable derivation
certificate. If newly formed programs become zero-cost starting points for the
next encounter, rerunning the same construction gives the correct updated
policy.

**Proof.** Add a formal sink joined by a zero-cost edge from every separating
program. The claim is the shortest-path theorem; predecessor replay proves the
program was generated and reaches a separator. Adding a formed program to the
source set changes distances but not the theorem. ∎

For `(2,4)`, mod 2 collides and one increment forms mod 3. For `(14,26)`, the
difference is 12, so mod 2, 3, 4, and 6 all collide; the least-cost path is

`mod 2 -> mod 4 -> mod 5`,

and mod 5 separates. A catalog scanned in order `(mod 7, mod 5)` chooses mod 7
instead. That choice is not mathematics; it is accidental call-order policy.

This supplies a compact answer to the current formation question. The system
does not optimize over arbitrary concept vectors. It constructs candidate
observations in a typed language, stops when one resolves a live obstruction,
and retains the proof so future construction costs change.

## Rigor boundary

Shortest paths are standard. The contribution here is their precise role in
the arithmetic organism and the executable fail-closed interface. The cost
model prices formation of a program, not evaluation time or physical storage
of all values it can observe. The grammar remains externally declared; grammar
extension is a higher formation problem. Dynamic negative-cost constructors
are excluded. No global claim is made that residue observations suffice.
