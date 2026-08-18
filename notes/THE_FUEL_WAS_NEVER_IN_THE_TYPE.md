# The fuel was never in the type

*A criterion for finding places where a `refl` is standing in for a
theorem, derived from one instance, checked at three, and applicable
without reading any proof.*

Status: every claim below is a checked Agda term unless marked
otherwise. Modules are `--safe`, no postulates, no holes, under Agda
2.6.3 / cubical v0.5 (the container, not the repository pin).

---

## 1. How it started

`FrontierList.logOf p k` computes the largest `i` with `p^i ≤ k`. It is
used to build `frontierList k`, which the walk's residue counts rest on.
It is defined as a gas-driven climb whose gas budget is `k` itself:

```agda
expOf p k zero    = 0
expOf p k (suc g) with ≤Dec (p ^ (suc (expOf p k g))) k
... | yes _ = suc (expOf p k g)
... | no  _ = expOf p k g

logOf p k = expOf p k k
```

Nothing in this repository proved the budget adequate. The whole weight
was carried by `frontier8 = refl` — one computed instance at `k = 8`.

`NaturalMachine.ExponentBound` supplies the missing specification, in
both directions and about the actual function rather than a copy:

```agda
logOf-le : 0 < k → p ^ (logOf p k) ≤ k
logOf-lt : 1 < p → k < p ^ (suc (logOf p k))
```

The second is the one with content. The climb obeys a dichotomy — after
`g` steps it has either advanced once per step or already saturated —
and saturation must occur by step `k`, since a climb that advanced `k`
times would give `p^k ≤ k` against `k < p^k`. That last inequality is
proved from nothing by induction, using only `x < p · x` for positive
`x`.

## 2. The question that mattered more

Twenty modules here are fuel-driven. Why did *this* one escape?

The answer is a type-level criterion, and it is sharp.

**Safe shape.** Budget as a hypothesis, postcondition in the result:

```agda
factorise-fuel  : … → n ≤ fuel → Factorisation n
primeDivisor-fuel : … → n ≤ fuel → Σ[ p ] (IsPrime p × (p ∣ n))
pFree-fuel      : … → m ≤ fuel → Split p m
decay-fuel      : … → n ≤ fuel → Σ[ k ] iterate f k n ≡ 0
WalkJumps.strip : … → j ≤ fuel → Strip p j
```

For these there is nothing left to prove. Adequacy is a projection of
the result.

**Risky shape.** Budget as bare data, result as bare data:

```agda
FrontierList.expOf   : ℕ → ℕ → ℕ → ℕ
HeadDepthMerge.powMod : ℕ → ℕ → ℕ → ℕ → ℕ
```

**A third shape**, which is fine and should not be confused with either:
fuel as an *index of the statement*, with adequacy as a named
hypothesis. `ObservableHorizon`'s `BoundedFutureEq step observe fuel` is
defined at that fuel, and its theorems are explicitly conditional on
`ObservableClosesAt step observe fuel`. Nothing is hidden.

## 3. "Bare data cannot carry adequacy" is a slogan until it is a collision

It is one. `NaturalMachine.FuelAdequacyIsACollision`, at base 2, with
input `(k , gas)`:

```
expOf 2 2 1  =  1  =  expOf 2 8 1
saturated (2 , 1) = true    -- 2² = 4 > 2, the climb is finished
saturated (8 , 1) = false   -- 2² = 4 ≤ 8, it has further to go
```

so by this corpus's own `TranscriptDescent.collisionObstructsDecoder`,

```agda
fuel-adequacy-does-not-factor : ¬ FactorsThrough bare saturated
```

The repair is in the same idiom: a collision names the missing
distinction, here `k`, and `FactorsThrough withK saturated` holds with
the decoder written out. That is the weak form of the type the five safe
functions already have.

## 4. It is systematic, not a pair of anecdotes

A first pass claimed the criterion found "one more, and only one". That
was wrong, and wrong in the way the criterion predicts: the search read
top-level *signatures containing the word* `fuel`, which is exactly the
search that cannot see functions whose fuel is unnamed. The correction
is recorded in `PowModHasTheSameShape` §6 and carried by
`NaturalMachine.ExhaustionIsSystematic`.

The right search is over bare arrow chains. Their exhaustion branches:

| module | function | exhaustion default | also legitimate when |
|---|---|---|---|
| TransmissionRefutations | `gcdF zero a _` | `a` | `b ≡ 0` |
| TransmissionRefutations | `quoF zero _ _` | `zero` | `n < d` |
| TransmissionRefutations | `remF zero n _` | `n` | `n < d` |
| TransmissionRefutations | `spfF zero _ n` | `n` | `n` prime |
| SieveFiber | `divF zero d n` | `zero` | `n < d` |
| SieveFiber | `modF zero d n` | `n` | `n < d` |
| SieveFiber | `omegaF zero d n` | `zero` | no factor in range |
| Gamma0Index | `gcdF zero a b` | `a` | `b ≡ 0` |
| HeadDepthMerge | `powMod zero m b e` | `1 %% m` | `e ≡ 0` |

Every one defaults, on exhaustion, to a value that is *also* a
legitimate output. **That is forced, not careless.** A total function
into `ℕ` must return some natural number when the fuel runs out, and
every natural number is some call's legitimate answer. The collision
follows from totality.

Three of these are checked as collisions (`powMod`, `remF`, `divF`) in
three subsystems by three hands, sharing one packaging `Site run good`.
The other six are read from their exhaustion branch only and are named
as such.

## 5. The cheap surrogate fails too

The obvious escape is to test convergence instead of correctness: *did
one more unit of fuel change the answer?* For the subtractive loops it
works. For `powMod` it does not, because the recursion halves the
exponent:

```
powMod 1 7 2 4  ≡  1  ≡  powMod 2 7 2 4      while 2⁴ mod 7 = 2
```

Exhaustion there is **stable across a step**. Checked as
`ExhaustionIsSystematic.PowMod.stable-but-wrong`.

## 6. An author had already seen it, and filed it as a range

`HeadDepthMergeBreaker` records:

> `-- powMod fuel exhaustion silently returns 1 %% m: with fuel 1, 2^4`
> `-- mod 7 comes out 1; the true value is 2 … In the certified range`
> `-- e ≤ 23^4 − 1 < 2^40 so fuel 40 never exhausts, but the wart is`
> `-- real outside it.`
> `edge-powMod-fuel-wart : HDM.powMod 1 7 2 4 ≡ 1`

A `refl` at one input plus an adequacy claim in prose — arrived at
independently, and filed as a caveat about a range rather than as a fact
about a type. Nothing here disputes that range claim. What the criterion
adds is that the range claim is the *only* thing that can save the call
site, because no decoder on the returned number can.

Not claimed anywhere in this thread: that any of these functions is
called outside its adequate range. That is a separate audit and it has
not been done.

## 7. The criterion, for the next agent

> A fuelled function whose fuel is bare data and whose result is bare
> data has an adequacy obligation the type system will not carry, so it
> will be carried by a `refl` at one input or by nothing at all.
> Grepping for `fuel` is the search that misses them, because the risky
> ones do not name their fuel parameter.

`expOf : ℕ → ℕ → ℕ → ℕ`. `powMod : ℕ → ℕ → ℕ → ℕ → ℕ`. Both invisible
to the obvious grep; both survived that way.

The repair is what the rest of the corpus already does — budget as
hypothesis, `Σ` as result — which is why `factorise-fuel`,
`primeDivisor-fuel`, `pFree-fuel`, `decay-fuel` and `strip` never needed
a theorem.

## 8. What it bought

Specifying `logOf` unblocked the item `FrontierDivides` §2 had called
the hard half and said "no amount of certificate-composition produces
it". `NaturalMachine.FrontierDividesHard` now proves

```agda
frontier-divides-hard : 0 < m → m ≤ k → m ∣ prodOf (frontierList k)
```

by strong induction peeling one prime at a time, closing each step with
the same `FinCardinality.gauss` the other half uses. With both halves,
`prodOf (frontierList k)` satisfies the universal property of
lcm(1 … k) — which is how CLAUDE.md requires lcm facts be stated in a
lane with no LCM module, and it is a theorem now instead of a `refl` at
`k = 8`.

The sentence in that header was wrong about the *kind* of the gap. What
was missing was duller than "existence of prime factorisation": a
specification that did not exist, a membership lemma, and a three-line
coprimality lemma. The asymmetry between the halves is a factor of six
modules, not a difference in kind.

## 9. Modules

| module | contains |
|---|---|
| `NaturalMachine.ExponentBound` | `logOf-le`, `logOf-lt`, `k<p^k`, `exponent-bounded` |
| `NaturalMachine.FuelAdequacyIsACollision` | first collision, criterion, repair |
| `NaturalMachine.PowModHasTheSameShape` | second site; §6 carries the correction |
| `NaturalMachine.ExhaustionIsSystematic` | `Site` packaging, three checked sites |
| `NaturalMachine.FrontierMember` | `frontier-member` |
| `NaturalMachine.PrimeCofactorCoprime` | `prime-power-∤-coprime` |
| `NaturalMachine.FrontierDividesHard` | the hard half |

All latched in `NaturalMachine.RootsThreadLatch`, which fails the build
the moment any of them rots.

## 10. Four wrong estimates, and the rule

This thread offered four estimates of what remained and all four were
wrong — three in `Sankalita`, one here ("the only one of the three that
needs Euclid", for a piece that needed three lines and no Euclid). The
rule that came out of them is: **name what is open, do not estimate its
size.** It is kept in the module headers above, and it was broken once
more inside a sentence that was otherwise explaining what remained,
which is where these keep hiding.

---

## 11. Addendum: the same shape one level up, and a distinction

`FrontierList.countAt` gave the frontier's residue count only at a `k`
you name, because its two hypotheses were of the form

```agda
isYes (decAllPrime (frontierList k)) ≡ true
```

supplied as `refl` at each concrete `k`. Same arrangement: a procedure
run at one input standing in for a theorem about all of them.
`NaturalMachine.FrontierIsWellFormed` proves both — the filter admits
`n` only in the branch where `decIsPrime n` said `yes`, and that
branch's witness *is* the proof; `downFrom` is strictly descending, so
its head exceeds every tail element — and gives

```agda
frontier-count-at : (k : ℕ)
                  → Fin (prodOf (frontierList k)) ≃ VecOf (frontierList k)
```

taking only `k`.

**But the severity differs, and the difference is worth keeping.** A
`Dec` run at one input cannot lie about that input: `countAt 8 refl refl`
was always a correct statement about `k = 8`. A fuelled bare-ℕ
computation checked at one input *can* lie about a different input while
looking identical, which is what §3–§5 prove. Both are stand-ins; only
one is unsound at the site where it stands.

So the criterion has two tiers:

- **incomplete** — a decision procedure discharged per instance. The
  statements are true; the generality is missing.
- **unsound-shaped** — a fuelled computation into bare data. The
  returned value provably cannot report its own adequacy, so a passing
  instance is not evidence about any other.

Both are worth closing. Only the second is worth closing first.
