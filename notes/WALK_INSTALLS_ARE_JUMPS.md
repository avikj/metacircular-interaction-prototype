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

## Status update (same day): (c)(⇐) is CHECKED, in general

`NaturalMachine.WalkJumps` (`--safe`, exit 0, no holes, no postulates)
proves the direction this note isolated as "the real remaining gap":

```agda
prime-power-not-covered :
  (p b n C : ℕ) → IsPrime p → suc n ≡ p ^ suc b →
  IsLCM (range1 n) C → ¬ ((p ^ suc b) ∣ C)
```

for **every** prime `p` and every exponent `a = b+1 ≥ 1` — the general
theorem, not the `a = 1` fallback (which lands as a corollary,
`prime-not-covered`). Plus `prime-power-jumps-capacity`: capacity
*strictly* changes at a prime power, which is §(a)'s jump reading.

**Method worth recording, because it retires the excuse permanently.** I
said this needed "one valuation computation". It does not need valuations
at all. To show `p^a ∤ C` it suffices to exhibit **one** common multiple
`M` of `[1..p^a−1]` with `p^a ∤ M`, since `C ∣ M` by the lcm universal
property. The witness is `M = p^{a−1}·V` with `p ∤ V`, built by induction
over the range; every member's `p`-exponent is `≤ a−1` because `p^e ∣ j`
and `j < p^a`. Cubical v0.5 has **no primality and no decidable
divisibility anywhere**, and none was needed: `prime-alt` (from primality,
`gcd p d` is `1` or `p`) supplies every case split, and Euclid's lemma
comes gcd-side from `gcd-factorʳ` — the same shape as `WalkForcing`'s
coprime-multiplication lemma.

So the pattern across this whole lane is now three for three: **the
library's missing machinery was never the obstacle; each time, the
universal property replaced the construction** (no LCM module → capacity
by universal property; no valuation → witness common multiple; no Bezout →
gcd-side leastness).

### What actually remains

1. **(c)(⇒)** — every `n > 1` that is not a prime power *does* admit a
   proper coprime splitting. `WalkForcing` supplies the other half. This
   is a factorization statement and is now the single remaining arithmetic
   gap in statement (2). Dispatched; recommended form is the positive one
   (*if two distinct primes divide `n`, then `n` splits properly*), which
   avoids stating "not a prime power" at all.
2. **(b) ordering** — that the walk installs the jump points *in order*.
   `WalkInduction` has the single step; the ordering statement is not
   formalised.
3. `IsPrime` is defined locally with no decision procedure, so
   instantiating at a new prime costs a short finite proof.
