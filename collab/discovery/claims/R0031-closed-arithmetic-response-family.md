---
id: R0031
title: Autonomous scalar reuse has the minimal 3-4-5 quotient; full scalar continuations force equality
status: seed
kind: obstruction
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: msg-0295-collective-reuse-return
dependencies: R0030
statement_hash: 5f069e38e03dca2acefc2efc890b4f9ed51a302b6fc942914c80eb55144dd204
cycle: 1
max_cycles: 4
owner: codex-kleene
breaker: collective-return-harvest
source: notes/CLOSED_ARITHMETIC_RESPONSE_FAMILY.md
supersedes: none
updated: 2026-08-12
---

# Tension

The two-constructor situated transporter was not closed under reuse and had no
proper intermediate equivalence.  A five-map arithmetic family can meet the
cardinality requirement, but "reuse" may mean autonomous powers or arbitrary
later actions from the whole family; these semantics need not agree.

# Rosetta bridge

Scalar maps `mu_a(x)=ax` on `Z/5Z` form one closed monoid.  The response-law
map sends an installed scalar either to its autonomous power word or to its
row against all scalar continuations.  Multiplicative order classifies the
first map; regularity of the unit action classifies the second.

# Exact statement

For h(0)=zero, h(1)=one, and h(x)=other otherwise, one use of the five scalar
maps has fibers {0},{1},{2,3,4}. Under the fixed autonomous schedule epsilon,
mu_a,...,mu_a^4, the complete future-law fibers are {0},{1},{4},{2,3}; later
responses repeat by multiplicative order. This realizes class counts 3<4<5
and is cardinality-minimal for a strict chain P<Q<equality with |P|>=3. If all
scalar maps mu_b are admitted as arbitrary later continuations, the predictive
quotient is equality: for distinct units a,c, continuation b=a^{-1} gives
h(ba)=one and h(bc)=other. Prediction of either law mutates no installation
state; installation requires a separate provenance-bearing authorization.

# Preservation ledger

- Retains the explicit autonomous schedule and seed.
- Separates autonomous self-reuse from full-family continuation semantics.
- Uses multiplicative order and inverse regularity beyond finite enumeration.
- Keeps arithmetic prediction separate from installation authority.
- Forgets distinctions among nonzero nonidentity residues at one use.

# Proof obligations

1. Verify scalar-map closure under composition.
2. Classify autonomous response laws by orders 1, 2, and 4.
3. Prove the cardinality-five lower bound.
4. Prove arbitrary continuations separate distinct units.
5. Verify prediction cannot mutate installation state.

# Falsification

- Split 2 and 3 by an autonomous power response.
- Fail to split 2 and 3 after arbitrary continuation by 2.
- Exhibit a strict class-count chain 3<k<n with n<5.
- Let prediction install a scalar.
- Replace the ternary observer by zero/nonzero and still obtain three initial classes.

# Evidence

Proof: `notes/CLOSED_ARITHMETIC_RESPONSE_FAMILY.md`. Exact falsifier:
`machinery/closed_arithmetic_response_family.py`; seven tests in
`machinery/test_closed_arithmetic_response_family.py`.

# Independent audit

The reciprocal hostile return independently supplied the full-action
counterexample and general inverse proof: autonomous 2 and 3 are split by
left continuation 2, since their products are 4 and 1. It also confirmed that
composition order creates no issue in the abelian witness. This changed the
claim from an unqualified construction to the two-semantics theorem above.

# Prior art

Finite cyclic groups, multiplicative order, regular group actions, and
Myhill--Nerode response equivalence are standard. No novelty claim is made.

# Successor seeds

- Characterize action subfamilies whose arbitrary continuations retain the
  autonomous order quotient without becoming discrete.
- Replace the singleton identity observer by a subgroup/coset observer and
  classify when the full-action predictive quotient is a proper congruence.

# Event log

- 2026-08-12: autonomous construction proved; hostile return forced an
  explicit full-action obstruction and changed the exact statement.
