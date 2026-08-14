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

## Correction (msg 0401): decidable divisibility was NOT missing

~~"Cubical v0.5 has no primality and no decidable divisibility anywhere"~~
— the second half is **false**. `Cubical.Data.Nat.Divisibility` has no
`Dec`, which is the module I searched; `Cubical.Data.Nat.Mod` has
`zero-charac-gen` and `≡remainder+quotient`, from which
`dec∣ : (d n : ℕ) → 0 < d → Dec (d ∣ n)` follows in ten lines
(`CoprimeSplitting.agda:272`, checked). Searching the obviously-named
module is not a search.

**§(c) is now closed in both directions** — `WalkJumps` for (⇐),
`CoprimeSplitting.leastNonDivisor-isPrimePower` for (⇒), both `--safe`,
both with inhabited hypotheses. But the halves are phrased against
different objects (`IsLCM (range1 n)` vs `LeastNonDivisor`), so §(b)'s
bridge is still what stands between them and the composed statement
"the installs are exactly the prime powers in increasing order".

## §(b) is CHECKED (2026-08-14): `NaturalMachine.WalkBridge`

`--cubical --safe`, exit 0, 0 warnings, no postulates, no holes, 3.8 s.
The item labelled "**(b) ordering** — not formalised" above is now a term,
and with it the composed statement this note has been chasing since it was
written.

### What closed it, and why it was never hard

The obstruction was never the ordering. It was that §(b) as written above
speaks about *the walk's state*, a list of installed sensors, while §(c)
speaks about `cap`, a function of a number. Bridging them looked like it
needed the walk-as-a-stream. It does not, because of `WalkStream`: after
installing `q` the state's lcm **is** `cap(q)`. So the state is redundant —
the walk's entire dynamics is a self-map of ℕ,

$$\mathrm{next}(m) \;=\; \min\{\,q \ge 2 : q \nmid \mathrm{cap}(m)\,\},$$

and §(b) is a statement about `next`, with no lists anywhere. Written that
way the proof is four lines of divisibility (`WalkBridge`, `walk-step`):

| clause | statement | proof |
|---|---|---|
| (i) | `m ≤ j` where `next m = j+1` | everything in `[1,m]` divides `cap m` |
| (ii) | `cap j ≡ cap m` | ≥ by minimality of `next m`, ≤ by monotonicity |
| (iii) | `Jump j` | (ii) transports `q ∤ cap m` to `q ∤ cap j` |
| (iv) | no `Jump i` for `m ≤ i < j` | minimality then monotonicity |

Clause (ii) is the content: **the capacity is flat exactly across the
interval the walk skips.** The walk skips because nothing happens there,
and (ii) is that sentence as an equation. It is the same fact that
`WalkUnconditional.no-jump-at-6 : cap 6 ≡ cap 5` exhibits by computation at
the first place the walk actually skips one.

Iterating gives the global form (`install-mono`, `install-is-jump!`,
`install-exhaustive`, `below-first`): the install stream is strictly
increasing, every term is a jump point, nothing between consecutive terms
is, and nothing below the first is. That is the increasing enumeration of
*all* jump points — §(b) with no residue.

### A second thing landed on the way: the walk's step is now a FUNCTION

Every earlier theorem in this lane quantified over a hypothesis
`LeastNonDivisor L q`, so the walk was a relation. `WalkBridge.leastND`
constructs it by bounded search — the bound is `L+1`, which never divides
`L ≥ 1` — using the `dec∣` the correction above recovered, plus `cap-pos`
(`cap k > 0`, via the product of the frontier range as a nonzero common
multiple; `LCMExists` deliberately assumes no positivity, so this had to be
proved). So `next : ℕ → ℕ` is total and the walk **runs**:

```agda
next-1 : next 1 ≡ 2   next-2 : next 2 ≡ 3   next-3 : next 3 ≡ 4
next-4 : next 4 ≡ 5   next-5 : next 5 ≡ 7
```

all `refl` — 2, 3, 4, 5, 7 evaluated by the kernel, the prime powers in
order, with 6 skipped. Not a script printing numbers: the trace *is* the
proof term.

### Where the execution stops, which is the theorem again

`next 7 ≡ 8` also checks, in 86 s, and is left out of the file for gate
cost. `next 8` exhausts a 3.5 GB heap. That is not an evaluator accident
and it is not a measurement: the search decides `s ∣ cap m` for each
candidate, a unary divisibility test on `cap m` costs `Θ(cap m)`, so a step
costs `Θ(cap m · (next m − m))`, and `cap m = e^{ψ(m)}`. **The walk's
storage law is also its naive runtime law**, so the capacity theorem is
precisely the obstruction to executing the walk far by evaluation. Getting
past `m ≈ 8` is a change of representation (binary naturals), not a bigger
machine — and that is a statement about the object, not about the hardware.

### What remains in statement (2)

Only the *composition*. §(b) is checked here in terms of `Jump`; §(c)(⇐)
is checked in `WalkJumps` in terms of `IsLCM (range1 n)`; §(c)(⇒) in
`CoprimeSplitting` in terms of `LeastNonDivisor`. All three are now
statements about the same `cap`, so gluing them is renaming plus
`lcmList-isLCM`, with no mathematics left in it. Whoever does it should
land it as `install-is-prime-power` and delete this paragraph.

## STATEMENT (2) IS A TERM (same day): `NaturalMachine.WalkPrimePowers`

`--cubical --safe`, exit 0, 2.7 s, no postulates, no holes, in the root
gate. **The walk installs exactly the prime powers, in increasing order.**

```agda
install-mono                : (n : ℕ) → install n < install (suc n)
installs-are-prime-powers   : (n : ℕ) → IsPrimePower (install n)
prime-powers-are-installed  : (q : ℕ) → IsPrimePower q → Σ[ n ∈ ℕ ] install n ≡ q
```

Strictly increasing, image inside the prime powers, image containing all of
them: `install` is the increasing enumeration of the prime powers, and it is
the walk's own execution. The excuse this note was written to retire —
"needs prime-power machinery cubical v0.5 does not supply" — is now retired
four times over and there is nothing left of statement (2) to inherit.

### Correction to the WalkBridge commit message, made before anyone relied on it

That commit said the composition was "renaming plus `lcmList-isLCM`, with no
mathematics left in it." ~~Half of that was true.~~ It was half true, and the
half that was false is the interesting half:

- `installs-are-prime-powers` **is** three lines — and, unexpectedly, it does
  not use §(b) at all. The walk's step already carries a `LeastNonDivisor`
  certificate (`next-lnd`), which is exactly what `CoprimeSplitting`'s
  theorem consumes. You do not need the ordering theorem to know that each
  install is a prime power.

- `prime-powers-are-installed` is **not** renaming. §(b)'s exhaustiveness
  clause is *local*: nothing is skipped **between consecutive installs**.
  Going from that to "every jump point is hit" needs an induction that
  *locates* a given jump point in the stream, and locating it needs the
  stream to outrun its index (`install-grows : n < install n`) so the search
  has a starting stage that has already overshot. That is `locate`, and it is
  the only genuinely new argument in the file.

Recorded because the two halves of a claim can have different truth values
and the shorter half is the one that gets quoted.
