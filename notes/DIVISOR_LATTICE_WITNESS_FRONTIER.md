# Exact recovery on the divisor lattice needs one witness per prime direction

**Status.** Exact finite arithmetic corollary of
`ANTICHAIN_FORMATION_SUFFICIENCY.md`. This is a native non-chain application,
not a quantum-memory or probabilistic claim.

## 1. The lens lattice

Fix `N ≥ 2` and let `X = Z/NZ`. For every positive divisor `d | N`, let

```text
q_d : Z/NZ -> Z/dZ
```

be reduction modulo `d`. Order these charts by divisibility: `d | e` means
`q_e` refines `q_d`. The divisor poset is a finite lattice, usually not a
chain.

Fix `x ∈ X` and take the task to be exact recovery,

```text
T(z) = z.
```

On the ambient set `X`, only `q_N` is sufficient at `x`. Indeed, `q_N` is the
identity chart. If `d < N`, then `x+d` is distinct from `x` in `Z/NZ` but has
the same residue modulo `d`. Thus the ambient minimal antichain is `{N}`.

## 2. Prime-frontier theorem

Let `S ⊆ X` contain `x`, and write `ω(N)` for the number of distinct prime
divisors of `N`.

**Theorem.** The following are equivalent.

1. The unique formation-relative minimal sufficient chart at `x` is still
   `q_N`.
2. For every prime `p | N`, there is a point `y_p ∈ S`, `y_p != x`, such that

   ```text
   y_p = x  (mod N/p).                                      (P_p)
   ```

Moreover the witnesses belonging to distinct primes must be distinct.
Consequently every exact-recovery-faithful formed set satisfies

```text
|S| ≥ 1 + ω(N),
```

and this bound is sharp, attained by

```text
S_x = {x} ∪ {x + N/p : p | N prime}.
```

**Proof.** In the divisor lattice, the maximal proper divisors of `N` are
exactly `N/p` for the distinct primes `p | N`. Since the ambient sufficient
upper set is `{N}`, these maximal proper divisors are precisely the ambient
failure frontier. The frontier theorem says that `q_N` remains the unique
minimal sufficient chart exactly when every `q_(N/p)` retains a collision
witness, which is condition `(P_p)`.

Suppose one `y` witnesses both primes `p != q`. Then `y-x` is divisible by
both `N/p` and `N/q`. Their least common multiple is `N`, so `y=x` in `Z/NZ`,
contrary to the witness condition. Hence distinct prime directions require
distinct points and `|S| ≥ 1+ω(N)`.

For sharpness, `x+N/p` is distinct from `x` modulo `N` and agrees with it
modulo `N/p`. These points are pairwise distinct by the preceding argument,
so `S_x` supplies every frontier witness with exactly `1+ω(N)` points. ∎

## 3. Controls

- `N=12`: the frontier is `{6,4}`. At `x=0`, the formed set `{0,6,4}` is
  faithful. `{0,6}` is not: modulo `4` becomes sufficient on that formed set,
  so exact recovery no longer needs the ambient chart `mod 12`.
- `N=p^k`: the frontier has the single chart `p^(k-1)`, despite the chain of
  all lower powers. Two points, `x` and `x+p^(k-1)`, suffice. Counting prime
  powers instead of prime directions would overcount.
- `N=pq` with distinct primes: no single nontrivial point can witness both
  `mod p` and `mod q`; doing so would make it equal to `x` by CRT. This is the
  lower-bound control.

## 4. Relation to nearby arithmetic results

`CHINESE_REMAINDER_GLUE.md` describes compatibility and the residual fiber
when two residue views are combined. Here the object is different: the whole
divisor lattice is already available, and the question is which ambient
*minimality counterexamples* remain present after restricting its domain.
The equality `lcm(N/p,N/q)=N` is the exact joint: it says two distinct maximal
failure directions have trivial common collision fiber.

The number `1+ω(N)` is not the coherent environment dimension from
`ARITHMETIC_QUOTIENT_QUANTUM_DILATION.md`. That dimension prices reversible
overwriting of one declared quotient and is a maximum fiber size. Nor is this
a controller-memory lower bound. The present number is the least cardinality
of a formed subset that preserves the ambient minimal chart for the exact
identity task.

## 5. Boundary

- Proved: the prime-indexed frontier, equivalence, distinctness, lower bound,
  and sharp construction.
- Not claimed: a minimum for other tasks, non-divisor chart families,
  infinite profinite domains, physical memory, or a probability that naturally
  generated formation sets contain the witnesses.
- Prior art: the divisor-lattice facts and CRT step are elementary. No
  literature search was performed and no novelty claim is made.

