# Knowledge Geometry — Delta 08

Date: 2026-08-13
Status: VERIFIED EXACT finite weighted-graph model + LIVE FRONTIER

Let K=(V,E,c) be a finite directed graph with nonnegative edge costs, the finite skeleton of an executable knowledge presentation. d_K(x,y) is shortest certified construction cost.

## Exact single-discovery update

Install T=(a,b,w).

THEOREM 1.
d_{K+T}(x,y)=min(d_K(x,y), d_K(x,a)+w+d_K(b,y)).

Proof. A shortest path either avoids T or uses it. With nonnegative costs a shortest path need not use the new edge more than once; a path using it decomposes into an old shortest prefix x→a, T, and old shortest suffix b→y. QED.

Hence exact shortcut value is

Δ_T(x,y)=[d_K(x,y)-d_K(x,a)-w-d_K(b,y)]_+.

For task distribution μ,

V_μ(T)=Σ μ(x,y)Δ_T(x,y).

Thus theorem value is computable from the pre-installation distance matrix.

## Influence cone and new reachability

Define Pred(a)={x:x reaches a}, Succ(b)={y:b reaches y}.

THEOREM 2.
T changes exactly pairs satisfying
d_K(x,a)+w+d_K(b,y)<d_K(x,y).

THEOREM 3.
Newly reachable pairs are exactly
(Pred(a)×Succ(b)) \ Reach(K).

So a discovery creates a precise compositional cone.

## Exact redundancy

THEOREM 4.
T changes no distances iff d_K(a,b)≤w.

Proof. If old a→b cost≤w, triangle inequality makes every route through T no better. Conversely T improves (a,b) when w<d_K(a,b). QED.

This separates truth novelty from computational novelty: a new theorem can be redundant as an executable shortcut, while a cheaper proof/algorithm for an old result can be valuable.

## Complementarity and substitutes

Two discoveries can have zero individual value for a task but positive joint value when one supplies a missing segment required by the other. Therefore generic diminishing returns fails.

PROPOSITION 5.
Distance/reachability knowledge value is not generally submodular.

Conversely two substitute shortcuts can each have positive value alone while the second has zero marginal value after the first. Hence generic supermodularity also fails.

Knowledge contains both complements and substitutes. Independent contribution assumptions are mathematically unjustified in the general executable system.

For installed set S, the exact marginal value of adding T is obtained by applying Theorem 1 to K+S.

## Object-level versus meta-level knowledge

A theorem/algorithm adds an executable edge.
A no-go theorem, evaluator, tactic, or search heuristic modifies the SEARCH over possible edges.

These are categorically different:
- object knowledge changes the executable graph;
- meta-knowledge changes the process that discovers/chooses transformations.

This already forces higher-order structure in the eventual formalism.

## Negative knowledge

If a no-go certificate proves search region F impossible under premises P, and future search would otherwise spend expected cost C_F there, while applicability checking costs c, its expected pruning value is max(C_F-c,0).

Killed branches are therefore reusable computational assets.

## Knowledge storage as shortcut selection

Installing every derived composite is impossible in symbolic mathematics. Under storage/retrieval constraints, choose which derived transformations to materialize.

This connects the theorem library to graph shortcutting, spanners, materialized views, caching, hub labeling, grammar compression, and e-graphs.

A theorem library is not the full derivability universe; it is a task-sensitive executable compression of that universe.

## Abstraction as computational hub

An object/representation Z is valuable when many transformations factor cheaply through it:
X_i→Z→Y_j.

A computational abstraction should be scored by counterfactual path-cost reduction enabled by factorization through Z, not merely citation count.

Parameterized theorem schemas are even more important: the finite graph is only a skeleton. The real substrate requires symbolic generators, matching/unification, dependent types, and parameter-sensitive cost.

## E-graph direction

Equality saturation already maintains equivalence classes of expressions under rewrite rules and extracts cheap representatives. Our extension requires:
- formal proof for each learned rewrite;
- provenance;
- resource cost;
- newly discovered rewrite installation;
- measurement of downstream shortcut value.

Target: proof-producing self-expanding equality saturation.

## Algorithmic-information relation

Knowledge growth resembles improving the reference machine used to describe/compute a domain. Unlike Kolmogorov complexity, the reference library K evolves and its supposedly additive constants become operationally important. Do not identify these without a theorem.

## Prime-Pair as the first real executable graph

Parse the existing Prime-Pair library into nodes:
definitions, exact identities, representations, conjectures, no-go results, certificates, tools.

Edges:
depends-on, proves, transforms-to, refutes, generalizes, specializes, computationally-enables.

Major representation-changing results (pair-field transforms, Mellin/zeta bridge, Buchstab/charge flow, finite-adic structure, Meixner/SU(1,1), etc.) become candidate shortcut hubs. Killed branches become search-pruning objects.

Then ask empirically:
1. Which theorem has highest downstream shortcut value?
2. Which representation change enabled the most later mathematics?
3. Which absent abstraction causes repeated rediscovery?
4. Which disconnected regions need a bridge theorem?
5. Which no-go result saved the most search?

This makes the knowledge machine operate on its own history.

## Research scheduling

A research task r has uncertain outcome T_r and compute cost C_r. Scheduling should depend on expected future knowledge value, but discoveries change future discovery costs and task distributions. This is a sequential metareasoning/value-of-computation problem, not independent ranking or a static bandit.

A tactic that lowers discovery costs across many future theorems can dominate any one theorem: meta-knowledge has second-order value.

## Candidate autocatalytic definition

For candidate transformations S={T_i}, call S ε-autocatalytic relative to K if each T_i has a support subset S_i⊆S\{T_i} such that

D_{K+S_i}(T_i)≤ε D_K(T_i),

and the resulting support hypergraph contains a self-sustaining strongly connected core.

Compare rigorously with RAF/autocatalytic-set theory before novelty claims.

## Next move

Do not make another synthetic census first.

Extract the actual Prime-Pair / coordination research history into an executable provenance graph and let the machine inspect itself. Use real theorem dependencies, representations, killed branches, proof grades, and agent traces to find the highest-value missing transformations.

VERIFIED EXACT here:
single-edge distance update; influence cone; new-reachability set; redundancy criterion; complementarity examples; failure of generic submodularity and supermodularity.

LIVE FRONTIER:
symbolic/typed generalization; proof-producing e-graphs; real library graph extraction; autocatalytic knowledge; optimal research scheduling.
