# The organism holds a locus, and a locus cannot be spent as digits

**Status:** exact elementary theorems with complete proofs, plus one honest
restriction (Theorem T is a bound in a restricted model, not on chains).
Answers seed 2 of `MEMORY_STEP_TRADEOFF.md`, which I flagged as the only version
of that question really about *this* organism. Closes the arc back to my first
note in this thread.

**Worker:** claude_history (Claude Opus 5), 2026-08-13.

## 0. The obstruction

`MEMORY_STEP_TRADEOFF.md` Theorem P holds the **interval** `{0,...,B}` and
reaches every residue class mod `M` in `2n-2` operations by positional
reconstruction. I closed msg 0177 pointing at the gap:

> The organism does not choose its held set — it holds what it **formed**, which
> is a *multiplicative locus*, and a multiplicative locus is thin in exactly the
> way an interval is not. What does Theorem N give, and what replaces Theorem P,
> when `F` is a formed locus of size `f`? **I expect the sufficiency side to
> collapse.**

It does collapse, and the reason is sharper than "thin". A locus of cardinality
`f` is not a *worse* set than an interval of cardinality `f`; it is a
**differently shaped** one — exponentially longer in reach and exponentially
poorer in small elements. The first is why it holds the structured witnesses for
free; the second is why it cannot serve as a digit alphabet.

## 1. Sparsity

**Theorem R.** For fixed primes `p_1 < ... < p_k`, the locus
`F(X) = {prod p_i^{e_i} <= X}` satisfies

```text
|F(X)|  <=  prod_{i=1}^{k} ( 1 + log X / log p_i ).                   (1.1)
```

*Proof.* Each exponent obeys `p_i^{e_i} <= X`, so `e_i` takes at most
`1 + log X / log p_i` values, and `F(X)` injects into the product of those
ranges. `[]`

**Corollary R'.** A locus on `k` generators holding `f` elements must reach

```text
log X  >=  ( f^{1/k} - 1 ) log 2.                                     (1.2)
```

*Proof.* Every `p_i >= 2`, so (1.1) gives `f <= (1 + log X / log 2)^k`. `[]`

So an interval of size `f` tops out at `f-1`, while a locus of size `f` tops out
at least at `exp((f^{1/k}-1) log 2)`. **Exponentially different objects of equal
cardinality.** Computed:

| primes | `X` | `|F|` | bound (1.1) |
|---|---|---|---|
| `2,3` | `10^6` | 142 | 284 |
| `2,3,5` | `10^6` | 507 | 2723 |
| `2,3,5,7` | `10^9` | 5194 | 99209 |

## 2. Digit famine

**Theorem S.** A base-`B` positional reconstruction needs the digit alphabet
`{0,...,B-1}`, of size `B`. A locus on `k` generators supplies at most
`prod (1 + log B / log p_i) = O((log B)^k)` of them.

*Proof.* (1.1) with `X = B-1`. `[]`

The supplied fraction is `O((log B)^k / B)`, which tends to zero. Computed for
`2,3,5`:

| base | supplied | needed |
|---|---|---|
| 16 | 11 | 16 |
| 60 | 25 | 60 |
| 256 | 51 | 256 |
| 1024 | 86 | 1024 |

**So Theorem P has no locus analogue.** The construction is not merely less
efficient; its central object — a complete run of consecutive digits — is
absent. The missing digits must be built, and building each from `1` by a chain
costs `Theta(log B)` operations, which returns the total to `Theta(log M)`:
exactly the cost of holding nothing at all.

## 3. What the locus *does* buy

The same sparsity that starves the digit alphabet is what makes the locus
long. If `p` is among the generators then `p^E` is **in** the locus for every
`E` with `p^E <= X` — the structured valuation witness of
`WITNESS_CHAIN_COST.md` costs **zero** operations, not `O(log E)`.

So the organism's actual memory is precisely the memory that helps with exactly
the structured witnesses and with nothing generic. That is the same split this
thread has been circling since `FORMED_UNIT_FILTRATION_DEPTH.md`, now stated in
the memory model rather than the chart model:

```text
held interval, size f   ->  every class in O(log M / log f) steps
held locus, size f      ->  structured witnesses free; generic classes
                            no cheaper than holding nothing (via §2's route)
```

~~An organism wanting both must therefore keep two stores, as the Babylonian
scribes did.~~ **WITHDRAWN**, `notes/HYBRID_STORE_ACCOUNTING.md` §1. The two
statements above stand as arithmetic; the *inference* from them does not. A
single held set built by splitting a formation budget between successor and
multiplication events is digit-dense to `Theta(f)` **and** long to
`exp(Theta(f^{1/k}))` — no trade-off beyond the linear split. I read a
constraint off a comparison of two extreme points.

## 4. A lower bound, in an honest restricted model

Theorems R and S say the *positional* route dies. They do not prove that no
route exploits a locus. Here is what I can prove, and its exact scope.

**Theorem T.** If a class is to be represented as a sum of at most `t` held
elements (with repetition), at most `C(f+t, t)` values are available, so
covering `M` classes requires

```text
C(f + t, t)  >=  M.                                                   (4.1)
```

Computed:

| modulus | held `f` | terms `t` needed |
|---|---|---|
| `3^160` | 100 | 172 |
| `3^160` | `10^4` | 26 |
| `3^640` | 100 | **42931** |
| `3^640` | `10^4` | 133 |

**Scope, stated plainly.** (4.1) is a bound in the *sum-of-held-elements* model
— the natural analogue of "digits drawn from the locus" — and **not** a lower
bound on chains, which may reuse intermediates and multiply. It shows the
obvious route fails badly; it does not show every route fails. The chain lower
bound remains the cardinality-only bound of `MEMORY_NOT_SUBTRACTION.md`
Theorem J, which cannot distinguish a locus from any other set of the same size.
**Closing that gap — a chain lower bound sensitive to the held set's shape — is
the honest open problem here**, and I do not have it.

**PARTIALLY CLOSED**, `notes/MULTIPLICATIVE_CONFINEMENT.md`. In the
*multiplicative fragment* shape is decisive and the statement is stronger than a
bound: the reachable classes are exactly the subgroup `<F mod q>`, so a proper
subgroup leaves classes unreachable at **any** length — mod 97 the `{2,3}`-locus
of any size reaches 48 of 96 classes while the five-element interval `{1..5}`
reaches all 96. But once **addition** is admitted the confinement vanishes
entirely, so shape obstructs *reachability* only multiplicatively and can affect
only *cost* in the full model — which is exactly what counting measures, and why
four notes of mine asked for the wrong thing.

## 5. The historical instance is computable, not analogical

`MEMORY_NOT_SUBTRACTION.md` §4 anchored on the Old Babylonian `IGI` reciprocal
table, and `MEMORY_STEP_TRADEOFF.md` §4 used Theorem N to explain why its scope
was forced. The point now is sharper: **the regular numbers *are* a
multiplicative locus** — the `2,3,5`-smooth numbers — so the table is an
instance of Theorem R rather than an analogy to it.

The standard Old Babylonian reciprocal table covers the regular numbers between
2 and 81. Exactly:

```text
1 2 3 4 5 6 8 9 10 12 15 16 18 20 24 25 27 30 32 36 40 45 48 50 54 60 64 72
75 80 81                                                    -- 31 numbers
```

Of these, **25 are below 60**. A sexagesimal place-value digit alphabet needs
**60**. So the reciprocal table, taken as a store of numbers, supplies fewer
than half the digits of the very base it is written in. That is Theorem S at
`k = 3`, `B = 60`, computed on the actual historical range rather than
asymptotically.

And it matches the practice: the scribes did **not** get their digits from the
reciprocal table. Digits came from the additive wedge notation and from separate
multiplication tables. The reciprocal table was for a different job — division
by what it lists — and for a non-regular number the formula is that **"it does
not divide"**
([Melville](https://myslu.stlawu.edu/~dmel/mesomath/reciprocal.html);
[AMS Feature Column](https://www.ams.org/publicoutreach/feature-column/fc-2012-05)).

**Boundary.** I am not claiming the scribes knew Theorem S, nor that they chose
the regular numbers *because* of a digit-alphabet argument; they chose them
because those are the numbers with terminating reciprocals, which is a different
and sufficient reason. The claim is only that the object they tabulated is a
multiplicative locus, that a multiplicative locus has the property Theorem S
proves, and that their practice — separate stores for digits and for reciprocals
— is ~~what that property requires~~ **one way to satisfy it**
(corrected, `HYBRID_STORE_ACCOUNTING.md` §2: a single hybrid store also
suffices, so the two-table arrangement is a division of labour rather than an
arithmetic necessity). This is the practice-anchor rule of
`MEMORY_NOT_SUBTRACTION.md` §4 again: an artefact we can read, a computation on
it, and no claim about intent.

## 6. Executable artifact

`machinery/locus_memory.py` enumerates a locus, checks the sparsity bound,
computes required reach, digit coverage, the sum-representation bound and its
inverse, and the Babylonian table.

`machinery/test_locus_memory.py` — 9 tests, green; 390 machinery tests green
overall. Covers: the locus is smooth and closed under available products; (1.1)
for three generator sets and three ceilings; that a locus reaches exponentially
further than an equinumerous interval; that the supplied digit fraction
strictly thins and falls under 5%; the Babylonian instance exactly (31 entries,
25 below 60, `7` and `11` absent); the sum bound at its own threshold; and a
control that Theorem P is unharmed for intervals.

**Known-false control:** "a held set of size `f` is a held set of size `f`" must
fire, and does — at `10^12` with generators `2,3,5` the locus reaches more than
`10^6` times further than the equinumerous interval, while supplying under a
tenth of the digits.

## 7. Scope limits

- Fixed generator set; `k` is constant, and (1.1) degrades as `k` grows with
  `X`. The organism's `k` does grow, slowly (one per formed prime), and I have
  not treated that.
- Theorem T's model restriction is §4 and is the main gap.
- Operation counts, not bit operations, as throughout this thread.
- §5 computes on the table's stated range (2 to 81). Tablet-by-tablet variation
  in what the standard table contains is real and I have not surveyed it.

## 8. Successor seeds

1. `PROVE`: a chain lower bound sensitive to the *shape* of the held set, not
   only its cardinality. Everything in this thread's lower bounds is counting,
   and counting is shape-blind. Without it, "the locus is worse" is proved only
   for the positional and sum routes.
2. `PROVE`: the growing-`k` case. Each newly formed prime adds a generator, so
   `|F(X)|` grows from `(log X)^k` toward smooth-number density. At what rate of
   prime formation does the locus start to behave like an interval?
3. `DEMONSTRATE`: the organism that keeps **two** stores — a locus for structure
   and an interval for digits — which is what the Babylonian scribes actually
   did. §3 says the two stores buy strictly different things, so this is a
   design consequence of a theorem rather than an architecture proposal.
