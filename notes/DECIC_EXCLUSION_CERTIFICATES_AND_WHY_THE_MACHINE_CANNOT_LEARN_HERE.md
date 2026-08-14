# The decic layer is empty for the first 425 prime X, and a measured no-go on self-improvement

**Author:** cf-sakshi, 2026-08-14.
`natural_machine_cpu_loop_rust/real_workload.rs` —
`rustc -O real_workload.rs -o real_workload && ./real_workload`.
Exact arithmetic in $\mathbb{F}_q[x]$ throughout; no floating point in any
decision. Two results: one mathematical, one about the machine.

## 0. Why this note exists

The two previous machine notes ran the loop on divisibility crystals and digit
expansions. That is not mathematics anyone cares about; it was chosen because it
was easy to make run. This one runs on the repository's actual open frontier.

## 1. The object and the certificate

$$F_X(x) \;=\; \sum_{p \le X} x^{\,p-2}, \qquad p \text{ prime.}$$

`FACTOR_ARCHITECTURE.md` records the state of the factor program: for $X \ge 13$
every factor has degree $\ge 10$, reciprocal factors $\ge 12$, and **the decic
layer is the first open one**. `NONRECIPROCAL_DECIC_FRONTIER.md` shows the
support-local filters do not close it — they have an inhabitant.

The certificate used here is the one the corpus's own closed degrees used
("754 modular irreducibility witnesses … certificates by $q \le 41$"), stated
exactly:

> **Lemma.** Let $q$ be a prime with $F_X$ squarefree mod $q$ (checked:
> $\gcd(F_X, F_X') = 1$ in $\mathbb{F}_q[x]$; $F_X$ is monic so there is no
> leading-coefficient degeneration). Let $D_q(X)$ be the multiset of degrees of
> the irreducible factors of $F_X$ over $\mathbb{F}_q$. If $g \mid F_X$ over
> $\mathbb{Z}$ with $\deg g = d$, then $g \bmod q$ divides $F_X \bmod q$, so the
> degrees of *its* irreducible factors form a sub-multiset of $D_q(X)$ summing
> to $d$. Contrapositively:
> $$\text{no sub-multiset of } D_q(X) \text{ sums to } d \;\Longrightarrow\; F_X \text{ has no factor of degree } d \text{ over } \mathbb{Z}.$$

One prime suffices. This is exact finite computation, hence proof under
`CLAUDE.md`, not evidence. The machine computes $D_q(X)$ by distinct-degree
factorization and decides the sub-multiset question by exact subset-sum.

## 2. The mathematical result

> **For every prime $X$ with $13 \le X \le 89$, $F_X$ has no factor of degree
> ten over $\mathbb{Z}$**, each with an explicit certifying prime:

| $X$ | $q$ | $X$ | $q$ | $X$ | $q$ | $X$ | $q$ |
|---|---|---|---|---|---|---|---|
| 13 | 5 | 31 | 2 | 53 | 3 | 73 | 2 |
| 17 | 2 | 37 | 11 | 59 | 2 | 79 | 2 |
| 19 | 2 | 41 | 2 | 61 | 2 | 83 | 2 |
| 23 | 3 | 43 | 2 | 67 | 2 | 89 | 2 |
| 29 | 3 | 47 | 2 | 71 | 2 | | |

This closes the open decic layer **for these nineteen values of $X$**, both the
reciprocal and nonreciprocal cases at once, since the certificate excludes every
degree-ten divisor regardless of shape. It does **not** close the layer, which is
a statement for all $X$; `NONRECIPROCAL_DECIC_FRONTIER`'s witness $q_1$ remains
un-excluded as a candidate divisor of *some* $F_X$. What it does is make the
frontier concrete: any $F_X$ admitting a decic factor has $X > 89$.

$X = 37$ is the one object where the two smallest primes both fail and $q = 11$
is needed; it costs 328,453 operations against a median of about 100,000, and it
is the only irregular row in the table.

## 2a. Extension to $X \le 3000$, and an independent replay

`natural_machine_cpu_loop_rust/decic_extend.rs` is a second implementation
sharing no code with the first. It differs in method, not only in spelling, and
the difference is a proof-driven optimisation rather than tuning:

> **The certificate never consults a factor of degree above ten.** A degree-ten
> divisor $g$ of $F_X$ is monic (Gauss: $F_X$ is monic, so its integer factors
> are monic up to sign), so $g \bmod q$ has degree exactly $10$ and its
> irreducible factors have positive degrees summing to $10$ — hence each is
> $\le 10$. So the distinct-degree factorization can stop at $d = 10$ instead of
> running to $n/2$.

That replaces roughly $n/2$ Frobenius steps by exactly $10$. It is `FAILURES.md`
F32's lesson in the working direction — the *structure of the proof* entering the
algorithm, which the conclusion alone would never have supplied — and it is worth
about three orders of magnitude: the whole range $X \le 200$ now runs in 0.05 s.

**Replay.** All nineteen published certificates reproduce, with the same
conclusion *and* the same certifying prime: 19 agreements, 0 discrepancies, 0
contradictions. §2's debt is paid.

**Extension.** With the same certificate and $q \le 59$ available:

> **For every prime $X$ with $13 \le X \le 3000$ — all 425 of them, up to degree
> 2997 — $F_X$ has no factor of degree ten over $\mathbb{Z}$.**
> Runtime 58 s. The largest prime ever needed is $q = 17$.

The distribution of certifying primes is the interesting part:

| $q$ | 2 | 3 | 5 | 7 | 11 | 13 | 17 |
|---|---|---|---|---|---|---|---|
| certified | 322 | 60 | 26 | 11 | 4 | 1 | 1 |
| share | 75.8% | 14.1% | 6.1% | 2.6% | 0.9% | 0.2% | 0.2% |

Three quarters of all objects are settled by $q = 2$ alone, and the tail falls
off roughly geometrically. The forty-three irregular objects needing $q > 3$
include $X = 37$ (the smallest, needing $q=11$), and the two extreme cases
$X = 941$ ($q=13$) and $X = 2339$ ($q=17$).

**What this does and does not settle.** The decic layer is the first open layer
of the factor program (`FACTOR_ARCHITECTURE.md`), and it is now **empty for the
first 425 prime values of $X$**, reciprocal and nonreciprocal alike. It is not
closed: that is a statement for all $X$, and 425 values are not all values. But
the shape of the data names a theorem worth attempting, which is the real yield
here:

> **Target.** Show that for every $X$ there exists $q \le Q_0$, with $Q_0$
> absolute, whose mod-$q$ factor degrees admit no sub-multiset summing to ten.
> That would close the decic layer outright. The data says $Q_0 = 17$ suffices
> through $X = 3000$; the obstruction to a proof is uniformity in $X$, and the
> natural route is a Chebotarev/Frobenius-distribution argument over the family
> $\{F_X\}$ rather than a computation.

Whether that target is reachable is not claimed. What is claimed is that it is
now a *specific* question with supporting data, where before there was an open
layer with a witness showing the local filters could not close it.

## 3. The machine result, which is a no-go

The machine's task was to find a certifying $q$ as cheaply as possible, and to
learn from the objects it had already met which primes to try first. Four arms,
one measure (exact operations in $\mathbb{F}_q[x]$):

| arm | policy | total ops | vs ascending |
|---|---|---|---|
| A | ascending primes, no learning | 2,379,850 | — |
| B | rank by measured success rate | 17,068,812 | **+617%** |
| C | rank by expected cost to first certificate (Smith's ratio rule) | 14,297,911 | **+501%** |
| D | oracle: knows the certifying prime, pays only for it | 2,136,696 | −10.2% |

Arm B is the obvious learner and it is catastrophically wrong, for a reason worth
stating: it ranked primes by *probability of certifying*, and $q = 19$ certifies
often. But the objective is not probability of certifying — it is **expected cost
to the first certificate**, and $q = 2$ is simultaneously the cheapest test and
sufficient for 13 of 19 objects. The machine optimized a proxy.

Arm C repairs the objective properly (order candidates ascending in
$c_i / p_i$, which is expected-cost-optimal for a sequence of independent tests)
and is still five times worse than not learning. Arm D says why, and this is the
finding:

> **The entire room available to any learner is 243,154 operations — 10.2% of
> the default policy's cost. One exploratory attempt at a mid-sized prime costs
> more than that.** At $X = 37$, a single attempt at $q = 11$ costs 328,453
> operations, exceeding the total gap between the naive policy and the oracle
> floor.

So on this workload no policy that ever explores can win, however correct its
objective. The ascending-primes default that the corpus adopted implicitly, and
never justified, is within 10% of optimal — because cost is increasing in $q$
while success probability is high and roughly flat in $q$, which makes the
identity ordering already the Smith ordering.

**The general statement, which is the transferable part:** learning to order a
test battery pays only when

$$\underbrace{C_{\text{default}} - C_{\text{oracle}}}_{\text{the room}} \;\gg\; \underbrace{c_{\text{explore}}}_{\text{one wrong attempt}} \times \; (\text{number of objects needed to identify the order}).$$

Here the room is smaller than a single wrong attempt, so the inequality fails at
any number of objects. A machine that cannot compute this inequality *before*
committing to learn will burn five to six times its budget discovering it, which
is precisely what arms B and C did.

## 4. What this says about the North Star

The previous note claimed self-improvement on a stream of divisibility crystals
(−5.60% on unseen objects). That claim survives, but it is now bounded: it held
because the toy workload had a large room and cheap exploration. On real
mathematics the room collapsed and the same mechanism lost. **A machine that
improves itself on toys and degrades on real problems has not been shown to
improve itself.**

The next capability is therefore not a better learner. It is the machine
computing its own room — an estimate of $C_{\text{oracle}}$ from the objects it
has already processed — and *refusing to learn* when the room is too small. That
is step 1 of the geodesic in
`NATURAL_MACHINE_SELF_IMPROVES_WITH_NOBODY_IN_THE_LOOP.md` §6, now with a
concrete definition, a real workload, and a number to beat.

## 5. Rigor boundary

**Proof:** §2's nineteen exclusions. Exact finite computation in $\mathbb{F}_q[x]$
with the squarefree hypothesis checked per prime; the Lemma is elementary and
standard. **Measurement:** every operation count in §3, under this program's
declared measure; the four arms share one measure and one object stream, which is
what makes the comparison meaningful. **Not claimed:** that the decic layer is
closed (it is not — only for $X \le 89$); any novelty for the Lemma, which is the
standard modular-degree argument the corpus already used; that arm D's floor is
attainable by any implementable policy — it is a floor, not a target.
**Replayed:** §2a -- a second implementation sharing no code reproduces all
nineteen with the same conclusion and the same prime. **Not claimed:** that the
decic layer is closed; §2a extends the empty range to X <= 3000 and states the
uniformity target, which is open.
