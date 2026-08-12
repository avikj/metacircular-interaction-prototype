# An online machine constructs primitive split records

Fix `D,C`. After choosing coordinates `a_1,...,a_j` in `{0,...,C}`, retain
\[
(j,s,g,h)=\left(j,\sum_{i\le j}a_i,\gcd(a_1,\ldots,a_j),
\gcd(C-a_1,\ldots,C-a_j)\right),                              \tag{1}
\]
with `gcd(empty)=0`. Appending `a` applies
\[
(j,s,g,h)\mapsto(j+1,s+a,\gcd(g,a),\gcd(h,C-a)).              \tag{2}
\]

**Theorem.** Length-`D` paths accepted by
\[
2s=DC,qquad g=h=1                                             \tag{3}
\]
are in bijection with ordered primitive constant-output split records.

*Proof.* Induction on `j` proves the state invariant (1). At `j=D`, the sum
condition gives equal child totals and the two gcd conditions give primitivity
of the chosen child and its complement. Every split supplies its unique
coordinate path, and every accepted path supplies a split. ∎

Thus dynamic programming on reachable states counts and constructs records
online, without enumerating complete vectors or performing Möbius
inclusion–exclusion. Transitions with `s>DC/2` or
`s+(D-j)C<DC/2` may be rejected immediately.

The state components have distinct meanings: `s` is geometric balance, while
`g,h` are arithmetic certificates for the two complementary lives. Dropping
either gcd admits nonprimitive false paths; dropping `s` loses equal mass.

## Rigor boundary

This proves sufficiency and exact path bijection, not Myhill–Nerode minimality
of every reachable state. The executable comparison with direct fibers is a
falsifier/replay.
