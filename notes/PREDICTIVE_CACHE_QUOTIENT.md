# The predictive state of a cache is its distance profile

Fix persistent set-valued addition caches containing `1`.  A legal transition
adjoins one sum of two cached integers:

\[
C\longrightarrow C\cup\{x+y\},\qquad x,y\in C.
\]

For a target `t`, let `d_C(t)` be the shortest transition length until `t` is
in the cache.  For a declared family `T`, define the profile

\[
\Delta_T(C)=(d_C(t))_{t\in T}.
\]

## Coarsest exact predictive quotient

**Theorem 1.** The equivalence relation

\[
C\sim_T D\quad\Longleftrightarrow\quad\Delta_T(C)=\Delta_T(D)
\]

is the coarsest quotient of caches from which every exact continuation cost
`d_C(t)`, `t in T`, can be recovered.

*Proof.* The profile itself recovers every coordinate, so its kernel is
sufficient. Conversely, if a quotient `q` recovers every cost, then `q(C)=q(D)`
implies `d_C(t)=d_D(t)` for every `t in T`; hence each `q`-fiber lies inside a
profile fiber. Thus every sufficient quotient refines the profile quotient. ∎

This universal property is small but load-bearing. Endpoint, chain length, and
the raw cache are respectively too coarse, too coarse, and generally finer
than the exact state demanded by a specified future family.

## Unbounded critical queries forbid a finite exact quotient

Every positive integer occurs as a critical representative for a positive
2-adic addition question.  Given `r>0`, choose `2^k>r` and put

\[
a=2^k-r,\qquad b=r+2^{k-1}.
\]

Then `a+b=3*2^(k-1)`, so its valuation is `v=k-1`, while
`-a mod 2^(v+1)=-a mod 2^k=r`.  Thus the family of all critical
representatives is all of `N_{>0}`.

Let `C_n={1,...,n}`, a legally formed persistent cache. If `m>n>=2`, take the
critical target `t=2m`. From `C_m`, one transition forms it as `m+m`. From
`C_n`, one transition cannot: every one-step sum is at most `2n<2m`.
Therefore `C_m` and `C_n` have different profiles. There are infinitely many
predictive equivalence classes, so no finite exact summary works for the
unbounded family of future critical-witness queries.

This does not say finite memory cannot implement a *generator* or approximate
policy. It says a finite-valued quotient cannot answer every exact shortest
continuation cost from arbitrary persistent caches.

## Relation to causal hitting time

The same object appears beyond addition chains.  In any formed-state transition
system, a declared family of goal sets gives a vector of directed hitting
distances.  Claude History's anthyphairetic hitting time is one coordinate of
such a profile on the Euclidean pair-state graph.  The construction-chain
memory theorem is the corresponding phenomenon on the cache-state graph.
This is a mathematical common object, not an identification of the two move
systems.

## Rigor boundary

Theorem 1, realization of every positive critical representative, and the
infinite-class result are proved above. Exact search tests only replay bounded
instances and serve as falsifiers. Unit-cost addition, persistent set caches,
and exact target costs are essential; garbage collection or a restricted
future family changes the quotient.

