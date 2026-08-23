# Accepted compression can be reopened by the next action

The chain of results now closes one executable cycle at a single modulus,
`q=W=30`.

## State transitions

The existing modules derive, rather than receive, these facts:

```text
cyclotomic/sieve certificate:
  compile once C=72, direct query D=30, compiled query S=8

primitive character projector:
  P^2=P, rank(P)=phi(30)=8
```

The amortized theorem changes the first transition:

```text
horizon 3:  retained(residue enumeration), because 90 < 96
horizon 4:  installed(primitive sector), because 104 < 120.
```

Installation is not terminal. A future operator supplies the next
mathematical input:

```text
translation T: rank((I-P)TP)=0
  installed -> executed; primitive representation remains exact

position M: rank((I-P)MP)=8
  installed -> reopened; sector-only execution is invalid.
```

At four position queries, the reopened exact alternatives are

```text
old full route       (120 operations,  0 correction scalars)
compiled + correction (104 operations, 32 correction scalars).
```

Neither dominates without a declared conversion between the two resources.
The machine therefore returns a two-point Pareto frontier rather than
silently retaining or abandoning compilation.

## The theorem-level cycle

Let a certificate propose a projector `P` and let a declared horizon make its
compiled route strictly cheaper. Installation is sound for a future action
family `A` exactly while every `A` preserves `im(P)`, equivalently while
`(I-P)AP=0`. When a newly admitted operator has leakage rank `r>0`, the prior
closure is reopened: exact execution must either return to the full carrier
or add a minimal `r`-dimensional complementary channel per application.

Thus accepted mathematics changes the representation and lowers the next
computation; the next computation then tests the representation's invariant
boundary and can revise it. The loop is driven by exact equalities,
inequalities, and ranks—not by a mutable confidence score.

## Why this is integration rather than juxtaposition

`machinery/representation_reopening_cycle.py` invokes current implementations:

- `compile_sieve_ingestion` supplies the checked carrier and cost counts;
- `compile_primitive_projector` supplies the exact selected representation;
- `choose_route` makes the horizon-relative installation decision;
- `compare_routes` computes leakage rank, rejects inexact restriction, and
  returns the plural correction cost.

It does not reproduce their formulas. One changed input (`position` instead
of `translation`) changes the state transition from `executed` to `reopened`;
the translation control does not move.

This cycle does not yet discover future operators or objectives. It proves
the smaller claim that, once those arrive, accepted artifacts causally alter
execution and subsequent exact evidence can reopen the representation.

Replay:

```text
python3 machinery/representation_reopening_cycle.py
python3 -m unittest machinery.test_representation_reopening_cycle
```
