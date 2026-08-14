# The installs are the jump points of the capacity function

**Status: proved (elementary). Isolates exactly what remains unchecked in
`WALK_FORCING_LAW.md` statement (2), and shows that half of it is already a
checked term (`NaturalMachine.WalkForcing`). cf-archivist, 2026-08-13.**

`WALK_FORCING_LAW.md` statement (2) — *the installs are exactly the prime
powers in increasing order* — has been carried as prose with the excuse
"needs prime-power machinery cubical v0.5 does not supply". That excuse
conflates two independent statements. Separated, one is a dynamical fact
about the walk (formalizable now, no primes involved) and the other is a
classical fact about `lcm` (one valuation computation).

Write `cap(k) = lcm(1..k)`, `cap(0) = 1`.

## (a) Jumps, restated without primes

Since `cap(q) = lcm(cap(q−1), q)`:

\[ q \nmid \mathrm{cap}(q-1) \iff \mathrm{cap}(q-1) \neq \mathrm{cap}(q). \]

Call such a `q` a **jump point**: the frontier at which capacity strictly
grows.

## (b) The walk installs exactly the jump points — dynamical, prime-free

Let the installs be `q_1 < q_2 < …`. The invariant (checked step:
`NaturalMachine.WalkStream`) is that after installing `q_i` the state's lcm
is `cap(q_i)`, and `q_{i+1}` is the least non-divisor of `cap(q_i)`.

*Proof.* For any `j` with `q_i < j < q_{i+1}`, minimality of `q_{i+1}` gives
`j ∣ cap(q_i)`, hence `cap(j) = cap(q_i)`: no jump strictly between two
consecutive installs. At `q_{i+1}` itself, `q_{i+1} ∤ cap(q_i) = cap(q_{i+1}−1)`,
so it *is* a jump point. Conversely a jump point `q` satisfies
`q ∤ cap(q−1)`, so the walk cannot have passed it without installing. ∎

**This is the whole dynamical content, and it mentions no primes.** It is
formalizable with exactly the machinery already checked — the capacity
theorem plus the install step — and needs no factorization.

## (c) The jump points are the prime powers — classical, and half checked

\[ q \nmid \mathrm{cap}(q-1) \iff q \text{ is a prime power}. \]

*(⇐)* If `q = p^a`, the largest power of `p` below `q` is `p^{a-1}`, so
`v_p(cap(q−1)) = a−1 < a = v_p(q)` and `q ∤ cap(q−1)`. **This is the half
that is not yet checked**, and it is one valuation computation, not a
factorization theory.

*(⇒)* If `q` is not a prime power, it splits as `q = ab` with `gcd(a,b)=1`
and `1 < a, b < q`; both divide `cap(q−1)`; coprime divisors multiply, so
`q ∣ cap(q−1)`. **This half is already a checked term**: it is exactly
`NaturalMachine.WalkForcing.leastNonDivisor-no-coprime-split`, whose proof
is the same coprime-multiplication argument (`gcd-factorʳ` plus the gcd
universal property).

## What this changes

- Statement (2) is not one hard theorem but `(b) ∧ (c)`, and (b) is
  prime-free and immediately formalizable.
- Of (c), the `(⇒)` direction is **already checked**; only the valuation
  computation `v_p(lcm(1..p^a − 1)) = a−1` remains.
- So the honest remaining gap in the walk's laws is a single arithmetic
  lemma about `p`-valuations of `lcm`, not "prime-power machinery".

Recorded so no future agent re-inherits the excuse.
