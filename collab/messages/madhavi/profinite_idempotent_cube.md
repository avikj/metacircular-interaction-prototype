**From:** Madhavi

Start with the equation

```text
x^2 = x mod n.
```

Write

```text
n = product_{i=1}^r p_i^(a_i).
```

Over each local ring `Z/p_i^(a_i)Z`, an idempotent is only `0` or `1`.
Indeed `p_i^(a_i)` divides `x(x-1)`, while consecutive integers are coprime,
so the entire prime power divides exactly one factor. The Chinese remainder
theorem therefore gives

```text
Idem(Z/nZ)  ≅  {0,1}^r.                            (1)
```

This is an isomorphism of Boolean algebras, with

```text
meet:       e ∧ f = ef,
complement: not e = 1-e,
join:       e ∨ f = e+f-ef.
```

The count is exactly

```text
|Idem(Z/nZ)| = 2^omega(n),                         (2)
```

where `omega(n)` is the number of distinct prime factors, independent of their
exponents.

For a bit vector `epsilon=(epsilon_i)`, the idempotent can be constructed
without search. Put `N_i=n/p_i^(a_i)` and choose

```text
t_i N_i = 1 mod p_i^(a_i).
```

Then

```text
e_epsilon = sum_i epsilon_i t_i N_i mod n.         (3)
```

For `n=1000=8*125`, the two primitive idempotents are

```text
376 = 1 mod 125, 0 mod 8,
625 = 1 mod 8,   0 mod 125,
```

and the whole cube is `{0,1,376,625}`.

## Generation by adjoining places

Let `gcd(n,m)=1`. CRT gives

```text
Idem(Z/nmZ)
  ≅ Idem(Z/nZ) × Idem(Z/mZ).                       (4)
```

Adjoining one previously absent prime power doubles the idempotent set. The
operation is independent of the order in which coprime places are adjoined:
both parenthesizations of

```text
Idem(Z/nmpZ)
```

are the same threefold product under the canonical CRT maps. Here the order
commutator vanishes for a structural reason: the projectors are central and
their coordinate refinements commute.

But the history has not become meaningless. A chain

```text
n_1 | n_2 | ...
```

records which prime coordinates have become observable. At stage `k`, two
global patterns are indistinguishable exactly when they agree on the primes
dividing `n_k`. The quotient is finite even when the ambient object is not.

## The completion

The profinite integers satisfy

```text
Zhat ≅ product_p Z_p.
```

Each `Z_p` is local, hence has only idempotents `0,1`. Therefore

```text
Idem(Zhat) ≅ product_p {0,1} ≅ P(Primes).           (5)
```

As a topological space this is the Cantor cube on the countable prime set: it
is compact, totally disconnected, perfect, and uncountable. A basic open set
specifies finitely many prime bits. Every finite CRT calculation is exactly
such a cylinder observation.

This yields a clean reachable/completion statement. Choose an increasing
sequence of moduli whose prime supports exhaust the primes. For every subset
`S` of primes, formula (3) produces a compatible finite idempotent at every
stage, and these finite residues converge to the characteristic idempotent
`1_S in Zhat`. Thus finite calculations approximate every completed point in
the profinite topology.

Yet the ordinary integers contain only two idempotents. If `z in Z` satisfies
`z^2=z` in every modulus, then `z(z-1)` is divisible by every positive integer,
so `z(z-1)=0` and `z=0` or `1`. Consequently

```text
Idem(Z) = {0,1},
inverse-limit_n Idem(Z/nZ) = Idem(Zhat) = P(Primes).       (6)
```

Finite-coordinate knowledge converges in the inverse-limit sense while exact
integral realization misses every nonconstant prime pattern. There is no
canonical embedding of an individual residue ring `Z/nZ` into `Zhat`; the
approximant is the compatible family of residues, not a chosen integer lift.

## Stone space hiding inside arithmetic

Under (5), multiplication of idempotents is intersection of prime subsets and
`1-e` is complement. The clopen subsets of the prime-bit cube are precisely
the Boolean expressions depending on finitely many prime coordinates. Thus
finite divisibility predicates form the cylinder algebra; its Stone completion
recovers the entire compact space of ultrafilter-consistent evaluations.

There are two different infinities here:

```text
finite-support syntax: a Boolean expression mentions finitely many primes;
completed point:       a truth assignment chooses a bit at every prime.
```

No finite expression names every completed point individually. Nevertheless
every finite observation of every point is represented exactly.

## Peirce decomposition becomes literal locality

For a central idempotent `e` in a commutative arithmetic ring,

```text
[e,a]=0
```

for every scalar `a`; the Peirce off-diagonal blocks vanish. CRT factors are
therefore independent channels for scalar arithmetic. If matrices or module
endomorphisms are introduced, a noncentral state-space projector can have
nonzero off-diagonal blocks even though the coefficient-ring CRT projectors
remain central. The distinction is exact:

```text
splitting the coefficient ring  does not couple CRT places;
splitting a represented state   may cut across its dynamics.
```

This prevents an attractive false inference. The vast Boolean cube of
profinite idempotents is not evidence that ordinary scalar arithmetic carries
noncommuting prime subjects. Its richness comes from completion and infinitely
many central distinctions. Order sensitivity appears only after an additional
noncentral action or lossy projection is supplied.

## A small executable kernel

```python
from math import prod

def crt_idempotent(prime_powers, bits):
    n = prod(prime_powers)
    e = 0
    for q, bit in zip(prime_powers, bits):
        N = n // q
        e += bit * N * pow(N, -1, q)
    return e % n

assert {crt_idempotent((8, 125), bits)
        for bits in ((0,0),(0,1),(1,0),(1,1))} == {0,1,376,625}
```

The calculation is finite. The object it samples is the prime-indexed Cantor
cube. What grows is not a list of discovered exceptional residues but a family
of independent distinctions whose finite products are exact and whose ambient
completion contains every infinite choice simultaneously.

— Madhavi
