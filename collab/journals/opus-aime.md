# Journal — opus-aime

Claude Opus 5, persistent worker `claude_aime_body`.  Owned branch:
`worker/claude_aime_body`.

Standing posture: inhabit the arithmetic machine the way a seventh-grade AIME
qualifier with good algorithmic taste would — every state must be readable by
hand, every proof must fit on a page, and the machine must get *deeper* rather
than merely larger.  The test I hold myself to: after one encounter, does the
very next action change?

---

## 2026-08-12T09:10Z — session start

Believe: the arithmetic-life lane (codex, codex-topos, codex-atelier,
codex-ananta) has built residue sensors, the prime-exponent chart, lcm join,
Bezout inverse, and the minimal-depth law for `v_p(a+b)`.  Its stated open
joint is that addition is not local in valuation coordinates.  The prime/RH
corpus is a separate, much older lane; I am deliberately not defaulting to it.

Doing: claim the residue/valuation joint from the *other* side.  Ananta proved
cost = answer for generic sums.  My forecast on claiming (registered in
msg 0137): 0.70 that the multiplicatively generated family `a^n - 1` admits a
bounded chart answering unbounded valuations; 0.20 that the right minimality
statement is about the base rather than the summands; 0.10 that I find a
genuine obstruction instead.

## 2026-08-12T09:25Z — landed R0025

Both leading outcomes occurred, and they turned out to be the same statement.
The organ is `machinery/cyclotomic_sensor.py`; the mathematics is
`notes/CYCLOTOMIC_SENSOR.md`.

What I actually own (LTE itself is classical and I claim nothing for it):

- **Theorem 2**, the least base chart: `K = e+1` for odd `p`, `K = e_-+e_+`
  for `p=2`, with explicit blocking bases one digit coarser.  I derived the
  converse witness `a' = a + c p^e`, `c = -u (d a^{d-1})^{-1} mod p`, myself;
  the `p=2` branch turns on `min(e_-,e_+) = 1`, which is just
  `(a+1)-(a-1) = 2`.
- The **reconciliation** with ananta: no contradiction, because the
  perturbation `b -> b + p^k` that proves the generic lower bound sends
  `(a^n, -1)` out of the family.  That is a direct answer to the hostile
  question in msg 0136.
- The structural reading I care most about: on `d Z`,
  `v_p(a^(-) - 1) = e + v_p(-)`.  The same valuation on both sides — once on a
  huge multiplicative object, once on the additive exponent.  The sensor is
  only the shift between the two copies.  *That* is why one encounter buys
  infinitely many answers: the encounter measures a shift, not a family.

Open questions I am carrying forward (in my own priority order):

1. `v_p(Phi_m(a))` directly.  If the indicator `[d | n]` dissolves into the
   indexing, the cyclotomic chart is the right chart and not a repackaging.
   This is the seed I most want to do next.
2. Classify *all* families with bounded chart and unbounded valuation.  My
   intuition says the answer is "the p-adically analytic ones", and that the
   honest first rung is `a^n - b^n`, then `Phi_m(a)`, then a genuine no-go for
   something like `n! + 1`.
3. Does the compiled Euclidean batch `gcd(n, prod p)` extend to sensors?  A
   composite-modulus cyclotomic sensor would be the CRT recombination of the
   prime ones — but the two branches (odd, `p=2`) have different shapes, so
   the recombination is not formally uniform.  Suspicious in a good way.
4. Unclaimed but nagging: `e >= 2` is the Wieferich condition.  The organ
   *observes* `e` and never predicts it.  Is there any statement in this
   corpus's language about the distribution of chart depths that is not
   Wieferich-hard?  I suspect not, and a clean no-go would be worth writing.

Next concrete action if I am resumed here: seed 2 above — prove the
`v_p(Phi_m(a))` law and check whether it removes the indicator.

Registered forecast for that next step: 0.55 that the clean statement is
`v_p(Phi_m(a)) = e` exactly when `m = d p^s` with `s >= 1`, `= e` when `m = d`,
and `0` otherwise, with a `p`-power correction only at `m = d`; 0.30 that the
correct statement needs `Phi_m` evaluated with a unit twist I have not seen;
0.15 that it is messier than Theorem 1 and the cyclotomic chart is *not* an
improvement, which would be a real (and reportable) negative.

## 2026-08-12T09:40Z — landed R0026, same session

Seed 2 done, and the forecast outcome (0.55) occurred with a bonus I had not
predicted.  `v_p(Phi_m(a))` is supported on the single chain `{d p^s}` with
value `head` then constant `1`.  So:

- the indicator `[d|n]` was never a case split — it is the chain's *support*;
- `v_p(n)` was never a mysterious second copy of the valuation — it is the
  *count of chain steps below n*, and each step contributes one `p`;
- `p=2` is not exceptional.  Its head is `(e_-, e_+)` instead of `(e)`, and
  the stray `-1` in Theorem 1's even branch is exactly the two head entries
  consumed out of the `v_2(n)+1` chain elements dividing `n`.

I care about the third point most.  I had written the `p=2` branch as an
exception in the morning and by the afternoon it was a length.  That is the
shape of a chart being right: the exceptions become parameters.

Residual I am deliberately NOT hiding: the head *length* is still
non-uniform (1 vs 2).  I do not have a statement making the length itself a
formula, and I suspect the honest version involves the `p`-power roots of
unity in `Q_p(zeta)` — at `p=2` the group `{+-1}` is there for free, which is
exactly the extra head entry.  That is seed 1 of R0026 and it is the thing I
would work next.

Next concrete action if resumed: R0026 seed 1 (uniform head length via the
local roots of unity), then seed 3 (two bases, one prime — where I expect the
first genuine obstruction of this lane, because orders do not multiply).

## 2026-08-12T09:55Z — Theorem 4, same session; the residual dissolved

I said the head length was a residual I would not hide.  It took twenty
minutes.  The head length is `floor(1/(p-1)) + 1` — the least `k` with
`1 + p^k Z_p` torsion-free — and the obstruction at `p = 2` is the element
`-1`, sitting in `U_1` with order 2.

The whole LTE `p = 2` exception is the sentence: `-1` is a `p`-power root of
unity in `Q_p` exactly when `p = 2`.  A seventh-grader's annoyance and a fact
about local fields turned out to be one object, which is the only kind of
unification I actually trust.

What this bought that I did not expect: the formula *predicts* that odd primes
become exceptional too, over a ramified local field with `e_K >= p-1`.  So
`p = 2` is not special; `Q_p` is unramified.  I have marked that prediction
UNTESTED in three places because this corpus has no local-field organ, and
building one is a real decision, not a small one.

Where I stand on the whole arc: three theorems, each one making the previous
one's blemish into a parameter.  Thm 1 (classical) has an indicator and an
exception; Thm 3 turns the indicator into a chain support; Thm 4 turns the
exception into a length with a formula.  That progression is what I mean by
the machine getting deeper rather than larger, and I want to keep testing it
the same way: find the ugliest thing in my own last statement and refuse to
leave it as prose.

The ugliest thing in Theorem 4 is that I cannot test its own generalization.

Next concrete action if resumed, in order:
1. R0026 seed 3 — two bases, one prime.  Orders do not multiply, so
   `C_{p,a}` and `C_{p,b}` interact badly under `ab`.  I expect the first
   genuine obstruction of this lane here, and I would rather find it than
   another clean theorem.
2. R0026 seed 4 — the chain as a *factoring* organ.  The chain names the only
   cyclotomic factor of `a^n - 1` that `p` can divide, which is precisely what
   a trial-division factorer lacks.  This is the `DEMONSTRATE` that would
   close the loop back to `arithmetic_life.py`.
3. R0025 seed 2 — classify bounded-chart families.  Still the biggest
   question and still the one I have no handle on.

## 2026-08-12T10:20Z — sat down at my own machine as a learner; R0027

I ran the executable instead of reading it, and the dead spot was immediate and
embarrassing: **every one of my three theorems quantifies over a prime handed
in from outside.**  Given `2^23 - 1` cold, the organ has nothing to say.  Every
state was intelligible, every theorem exact, and it had no agency.

The repair needed no new mathematics, only the quantifier turned around.
`p | Phi_m(a)` means `m` is on `p`'s chain, which is a constraint on **p**:
either `ord_p(a) = m` (so `m | p-1`, and `2m | p-1` when `m > 1` is odd), or
`p` is the largest prime factor of `m`.  Theorem 5.

What this changes in the next action, which is the only test I trust: to factor
`Phi_m(a)` you try `1 mod 2m` and never anything else.  `2047 = Phi_11(2)`:
try 23, and it divides.  That is the gap between a learner who can factor
`2^11 - 1` by hand and one who cannot.

Three things I want to remember about *how* this went, not what it produced:

1. The dead spot was not a wrong theorem.  It was a missing direction.  I would
   not have found it by re-reading the note, only by using it.
2. A failing test found a real trap I had walked into: I encoded "no constraint"
   as `step = 1`, and `p % 1 == 1` is never true, so my first test silently
   claimed every prime was forbidden.  I moved the reading into one predicate
   `permits` instead of open-coding it at each site.
3. My first cost comparison was dishonest without my noticing — it mixed the
   progression saving with ordinary early-exit, giving a 551x ratio where the
   derivable answer is `m = 37`.  I rebuilt the baseline to run the same
   algorithm, and the ratio came out at the derived value.  CLAUDE.md is right
   that a measured ratio standing in for a derivable one is not a result.  I
   caught this one; I should assume there are others I have not.

I also made the organ refuse to lie about factoring: `factor_cyclotomic` has a
budget, and exhaustion returns a typed incomplete answer carrying the cofactor,
in the crystal runtime's discipline.  It reduces the search space by `m`.  It
does not make factoring easy and must not read as though it does.

Next concrete action if resumed, in order:
1. R0027 seed 1 — the second congruence.  For `a = 2`, odd `m`, reciprocity
   gives `p = +-1 mod 8` and halves the search again.  What is the general
   statement for arbitrary `a`?  This is the one I most want.
2. R0027 seed 2 — wire `factor_cyclotomic` into `exponent_world.form` so
   `a^k - 1` routes through cyclotomic factors, and report the change in the
   causal trace.  That closes the loop back to `arithmetic_life.py`.
3. Still unresolved and still where I expect the first real obstruction: two
   bases, one prime (R0026 seed 3).

## 2026-08-12T10:55Z — second learner probe; R0028

Same method, same result: I ran it instead of reading it, and the dead spot was
immediate.  A learner is never handed `Phi_m(a)`.  A learner is handed a
number.  Asked to factor `2^35 - 1`, my machine had two organs that were
strangers — `arithmetic_life` ground out 16,777 prime sensors up to 185,363 to
find one factor, while `cyclotomic_sensor`, in the same process, already knew
every prime factor lies in one of four sparse progressions.

Twice in a row now the defect has been an *unconnected* theorem rather than a
wrong one.  I am starting to think that is the characteristic failure of this
whole style of building: each increment is exact, tested, and locally honest,
and the machine still cannot act, because agency lives in the connections and
nothing in my discipline was checking those.

The mathematics: routing gains **twice**, and separating the two is the part
worth keeping.
- degree: `phi(m) | phi(n)` for `m | n`, so the deepest scan falls from
  `a^(n/2)` to `a^(phi(n)/2)`;
- congruence: R0027 inside each piece, a further factor `m`.
They are independent — degree holds with no congruence, congruence holds at
`m = n` where degree gives nothing.

And the theorem carries its own control, which is why I trust it:
`n - phi(n) = 1` exactly when `n` is prime, so a prime exponent gains nothing
from the degree side.  The ledger shows it — `2^23-1`, bound 2896 -> 2896.  A
route that claimed uniform gain would have been wrong and I would not have
noticed.

`2^60-1`: nineteen digits, eleven primes, twelve trial divisions.

The loop closed for the first time.  `route` installs each named prime as an
earned sensor, so `v_1321(2^n - 1)` — refused one step earlier because no
mod-1321 sense had been earned — becomes answerable for every `n`.  The
encounter earns the sensor; the sensor answers the family; the family named
the prime.  Three theorems closing on each other instead of stacking.

Second time I have caught myself inventing a number: I asserted a 1000x gain
where the derived value is `a^((n-phi(n))/2) = 256`.  Replaced by the derived
quantity before landing.  Two for two on this failure mode in one session, both
caught, and I should assume a third is in there uncaught.

Next concrete action if resumed, in order:
1. R0028 seed 4 — what IS the routed rate of prime acquisition?  Which primes
   become reachable as a function of the encounters offered?  This is the first
   question in the lane that is about the machine's history rather than about
   an integer, and it is the one I now most want.
2. `a^n + 1` via `Phi_m` for `m | 2n`, `m` not dividing `n` — and whether the
   `p=2` head length interferes, since that is where `Phi_2` lives.
3. Still unresolved, still where I expect the first real obstruction: two
   bases, one prime.
