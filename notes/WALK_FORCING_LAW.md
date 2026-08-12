# The walk's forcing law

**Status: proved (one page, elementary); executable witness
`runtime/walk.py`; proposed for formalization over
`NaturalMachine.CountedDigits` + `NaturalMachine/ResidueTransport.agda`
(msgs 0345/0346).**

## Setting

The walk (`runtime/walk.py`) is the fold of one algebra over ℕ: state
`(n, S)` with `S` a finite set of moduli; invariant **losslessness** — the
observation `n ↦ (n mod m)_{m∈S}` is injective on the walked prefix
`[0, n]`, equivalently (CRT) `lcm(S) > n`. When `n` reaches `lcm(S)` the
invariant breaks (n collides with 0) and the machine installs the least
`q ≥ 2` with `q ∤ lcm(S)`.

## Theorem (forcing law)

Along the walk from `S = ∅`:

1. every installed sensor is a prime power;
2. the installed sequence is exactly the prime powers in increasing order
   `2, 3, 4, 5, 7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, …`;
3. after installing `q`, `lcm(S) = lcm(1, …, q)`;
4. hence the machine's storage is `log lcm(1..q) = ψ(q)`, the Chebyshev
   function of its frontier: the prime number theorem is the exact
   asymptotic of the walk's memory, and the primes are the walk's forced
   memory rather than an input.

## Proof

*(1) The least non-divisor of any `L ≥ 1` is a prime power.* Let `q` be
least with `q ∤ L` and suppose `q = ab` with `gcd(a,b) = 1`, `1 < a, b < q`.
By minimality `a | L` and `b | L`; coprimality gives `ab | L`, i.e.
`q | L` — contradiction. So `q` has a single prime divisor. ∎

*(3) by induction, and (2) with it.* Initially `S = ∅`, `lcm = 1 =
lcm(1..1)`. Suppose before an install `lcm(S) = lcm(1..m)` for some `m`,
and let `q` be the least non-divisor. Every `r < q` divides `lcm(S)`, so
`lcm(S) = lcm(1..q−1)`, and after installing, `lcm(S′) = lcm(1..q)`.
Since `q` is the least integer not dividing `lcm(1..q−1)`, and every
integer that is not a prime power divides the lcm of its proper prime-power
parts (all `< q`, hence all dividing), `q` is the least prime power
greater than the previous install. Induction closes: the installs are the
prime powers in order, each installed at `n = lcm(1..previous)`. ∎

*(4)* `log lcm(1..q) = Σ_{p^k ≤ q} log p = ψ(q)` by definition. ∎

## What is executed vs. what is checked

`runtime/walk.py` executes the walk with certificates at every frontier:
prime-power certificate at install time, CRT section (reconstruction of
`n` from its residues, run not asserted), p-adic tower projection
compatibility, and the product decomposition `ℤ/lcm ≅ ∏_p ℤ/p^{v_p}`.
Measured storage at frontier 457: 1.4485 bits/unit against the PNT limit
`log₂ e ≈ 1.4427`.

None of this is machine-checked. The natural joint with the checked lane:

- `CountedDigits` (0346) already identifies literal successor with one
  `sucC` transition — the walk's `suc` is their counted step.
- `ResidueTransport` (0345) admits any `Observation A = ℕ → A` as data
  over the core — but its observations are *supplied*. The forcing law is
  the statement that the walk's observations are *forced*: the unique
  minimal-install trajectory maintaining injectivity on the prefix.
- Proposed checked statement, in their vocabulary: for the counted run,
  define `collide S n = (n mod lcm S ≡ 0)` and
  `force S = least q with ¬(q ∣ lcm S)`; then (i) `force S` is a prime
  power (statement (1) above — pure `Data.Nat`, no new machinery), and
  (ii) the induced stream of installs equals the ordered prime-power
  stream. Statement (i) is a candidate first target: its proof above is
  three lines of coprime divisibility, all in the installed libraries.

## Boundary

The forcing law is additive: it never demands that the machine *notice*
`4 = 2²` (the certificates notice it; no task forces it). The first task
that forces valuation — multiplicative losslessness, where the machine
must reconstruct products, not just points — is open, and is the walk's
next distinction in the sense of `TWO_IDENTITIES.md` §1.
