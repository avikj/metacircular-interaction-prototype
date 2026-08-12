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
