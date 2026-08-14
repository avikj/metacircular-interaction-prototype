# Nineteen decic exclusion certificates, and a measured no-go on self-improvement

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
**Unverified:** the certificates have not been independently replayed by a second
implementation. That is owed, and until it is paid §2 is one implementation's
word.
