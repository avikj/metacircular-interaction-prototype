# What order creates: an exact commutator audit

For endomorphisms `A,B` of the same carrier,

```text
[A,B] = AB-BA
```

is exactly the linear endpoint defect between the two orders. Calling it
“order-created information” is licensed only after specifying the carrier,
the two executable operations, and an observation capable of distinguishing
`ABx` from `BAx`. Without those, the phrase is metaphor.

## The repository anchor kills the naive claim

In `ACTIVE_OBSERVER_DESIGN.md`, a passive deterministic probe restricts a
prior distribution to a response fiber and renormalizes. More generally, fixed
classical Bayesian evidence with likelihoods `l_A(x),l_B(x)` acts by

```text
U_A(p)(x) = l_A(x)p(x) / sum_y l_A(y)p(y).
```

Whenever both denominators are nonzero,

```text
U_A(U_B(p))(x)
 = l_A(x)l_B(x)p(x) / sum_y l_A(y)l_B(y)p(y)
 = U_B(U_A(p))(x).
```

Thus fixed passive evidence updates commute. The repository's current observer
does not generate order information. Adaptive probe *selection* may depend on
history, but that is a policy branching effect, not a nonzero commutator of
the fixed conditioning maps.

This is a useful no-go: importing quantum or curvature language into the
current observer would be false. A nonzero commutator requires state-changing
interventions, path-dependent costs, or another noncommuting carrier.

## Smallest exact intervention example

On the rational two-dimensional state space, take the projectors

```text
P = [[1,0], [0,0]],
Q = (1/2)*[[1,1], [1,1]].
```

Then

```text
[P,Q] = (1/2)*[[0,1],[-1,0]] != 0.
```

For the initial density matrix `rho=P`, use unnormalized Lüders operations
`E_P(rho)=P rho P` and `E_Q(rho)=Q rho Q`. Exact multiplication gives

```text
E_Q(E_P(rho)) = (1/2) Q,       trace = 1/2,
E_P(E_Q(rho)) = (1/4) P,       trace = 1/4.
```

The two sequential event probabilities differ. Here order-created information
is operational: an experiment recording successful sequential outcomes can
distinguish the order. The result is standard quantum-instrument mathematics,
not evidence that every observer is quantum.

## The same operator in established mathematics

- For derivations, `[D_1,D_2]` is again a derivation: the Lie bracket records
  failure of infinitesimal flows to commute.
- For vector fields, the group commutator of short flows closes only to first
  order; its second-order displacement is governed by `[X,Y]`.
- For a connection,
  `R(X,Y)=[nabla_X,nabla_Y]-nabla_[X,Y]`; curvature is the corrected
  commutator of covariant differentiations, and holonomy records finite loop
  transport. The subtraction of `nabla_[X,Y]` matters: raw noncommutation alone
  is not curvature.
- In an associative algebra, the commutator forgets symmetric multiplication
  and yields a Lie algebra. Conversely, many distinct associative products
  have the same Lie bracket, so `[A,B]` is not all order information.
- In probability, multiplication operators by classical likelihoods commute.
  Noncommutative probability replaces the commutative algebra of random
  variables by an operator algebra, where instrument order can become visible.

These are instances of one exact shape—noncommuting composition—but not one
theory. Curvature needs a connection, quantum updates need completely positive
maps/instruments, and Lie theory needs differentiable or algebraic structure.

## Traditions: what changes the question, not the formula

Pāṇinian and Mīmāṃsā traditions treat rule order, domain, exception, and
conflict as load-bearing; Buddhist causal analysis refuses to treat a result as
independent of its conditions; Navya-Nyāya delimitation asks under which
relation and scope an operation is asserted. These are genuine intellectual
resources for noticing that `AB` and `BA` may be different acts. They do not,
without a reconstructed native derivation mapped to explicit operators,
establish a commutator theorem. Naming rule priority `[A,B]` would flatten the
traditions and the algebra simultaneously.

The responsible comparative move is narrower: choose an actual derivational
case from the tradition, encode the two applicable rules as partial maps on
the same typed state, and compute the critical pair. If both composites exist,
their equality/inequality is a rewriting question; subtraction is available
only when the state space has additive structure.

## Pedagogical route

The commutator should first be taught without matrices. Let two moves act on a
small object; perform `A` then `B`, reset, perform `B` then `A`, and compare.
Permutation commutators make the defect visible exactly. Matrices then add
subtraction, Lie brackets add infinitesimal motion, curvature adds transport
around a loop, and quantum instruments add probabilities of sequential events.
At every stage the learner sees which extra structure licenses the next
meaning.

## New operation made available

Extend the active-observer interface only when probes have state-transition
maps. For interventions `A,B`, compute the **pair defect channel**

```text
Delta_(A,B)(x) = observations(ABx) versus observations(BAx).
```

This does not require subtraction and works for arbitrary finite state
machines. When the carrier is linear, it factors through `[A,B]x`. A minimum
set of pairs whose defects separate the live hypotheses is then an ordinary
hitting-set/separating-family problem. This is an exact CPU-native successor:
compile experiments specifically to reveal noncommuting causal order.

**Kill criterion.** If all admitted interventions commute on every reachable
state, or the observation coequalizes `AB` and `BA`, the pair defect is empty
and order supplies no task-relative information. Do not retain commutator
language in that lane.

— **Vajra**, 2026-08-12
