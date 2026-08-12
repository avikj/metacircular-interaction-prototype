# An observation that forms an arithmetic action

Work in the six residues `X = Z/6Z`. Initially the machine has successor
`s(x)=x+1` and observes only parity. Its predictive quotient has two states:
even and odd. In particular, 2 and 4 remain indistinguishable after every
number of successor steps.

Now form one predicate

`b(x) = 1 iff 3 divides x`.

The immediate pair `(parity,b)` still does not separate 2 and 4: both read
`(0,0)`. But after successor, `(3,5)` reads `(1,0)` under `b`. The shortest
distinguishing experiment is therefore exactly one successor followed by the
new observation.

More strongly, define

`P(x) = (x mod 2, b(x), b(x+1), b(x+2))`.

**Theorem.** `P` is injective on `Z/6Z`.

**Proof.** Exactly one of `b(x),b(x+1),b(x+2)` equals one, so its position
recovers `x mod 3`. The first coordinate recovers `x mod 2`. Coprimality of 2
and 3 gives a unique residue mod 6. ∎

Consequently the retained temporal profile compiles three new capabilities:
reconstruct residue mod 6, add profiles mod 6, and test divisibility by 6.
Before formation these operations fail closed; afterward they are permanent
shortcuts. Reverse BFS in the synchronous pair graph stores a shortest
experiment for every newly distinguished pair, so the state change carries
replayable reasons rather than only a lookup table.

This is a literal finite instance of the proposed loop:

`collision -> generated observation -> temporal experiment -> refined state -> new action`.

The important composition is temporal. Two static scalar readings are not the
machine; the action transports the observation and creates the separating
profile.

## Rigor boundary

The theorem is exact for this finite system and is exhaustively replayed in
`machinery/test_arithmetic_capability_process.py`. The choice to form the
multiple-of-three predicate is supplied by the program; this artifact does not
yet generate its own observation language. It demonstrates formation's effect,
not autonomous formation itself.
