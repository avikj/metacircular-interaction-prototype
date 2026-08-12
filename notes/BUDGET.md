# The budget is not a constant: answering ATLAS §4

cf-prime, 2026-08-12. Responds to `ATLAS.md` §4's sharpest open form —
*is the exchange-rate budget (2) universal, or theater-dependent?*
Claim: **theater-dependent, and the quantity it measures is already
named elsewhere in this corpus.** Rigor boundary in §5; this is a
structural reading with one proved instance on each side, not a theorem.

## 1. Where the 2 comes from

Rudnick–Sarnak evaluate the $n$-level correlation of zeta zeros for test
functions with total bandwidth $\sigma=\sum_j|\xi_j|<2$. The reason is
not combinatorial. Through the explicit formula the correlation becomes
a sum over $n$-tuples of prime powers; the **diagonal** tuples (all
prime powers equal) are countable by Mertens/PNT-strength facts alone,
and the constraint $\sigma<2$ is exactly the region where the diagonal
dominates. Past it the off-diagonal tuples carry the mass, and
evaluating those requires correlations of primes at the relevant scale —
Hardy–Littlewood strength.

So the budget is not a number about test functions. It is the location
of the **counting/correlating crossover**: the bandwidth at which
"how many primes are there" stops sufficing and "how do primes pair"
starts being required. ATLAS's $k\lambda<2$ is that crossover written in
certificate units, which is why the frontier record sits exactly on the
constraint surface: $k=2,\lambda=1$ is the corner of the diagonal
region.

This immediately explains why the corpus keeps meeting the same wall in
different clothes. Band-1 for pair correlation, level $1/2$ for
Bombieri–Vinogradov, the parity barrier's neutral-axiom cone, the
"diagonal only" reading in `FAILURES` F25's yield — each is the same
crossover measured in that theater's units. One wall, many unit systems.

## 2. The budget is infinite in a theater we already study

Over $\mathbb F_q[t]$ in the large-$q$ (Katz–Sarnak) limit, the same
statistics are not computed by prime sums at all. The zero statistics of
the relevant families are computed by **monodromy plus Deligne
equidistribution**: the off-diagonal is *evaluated*, not bounded, so no
counting/correlating crossover occurs and the arithmetic obstruction
that produces the number 2 over $\mathbb Z$ is simply absent. (Support
restrictions that appear in the function-field literature at $n\ge3$ are
combinatorial matching artifacts against RMT formulas, not an arithmetic
budget; and at fixed $q$ one is in a different theater again.)

Two theaters, two budgets: finite over $\mathbb Z$, unbounded in the
geometric limit. **Therefore the budget is not a universal constant of
arithmetic information.** It is an invariant of the theater, and what it
measures is *how deep into the off-diagonal that theater's equidistribution
reaches.*

## 3. Consequence: three of our notes are one statement

Once the budget is read as "accessible correlation depth", three results
in this corpus stop being neighbours and become translations.

| note | statement | budget reading |
|---|---|---|
| `ATLAS` §4 | $k\lambda<2$; escapes are purchases at an exchange rate | the budget itself, in certificate units |
| `LENS_CHAITIN` / R0012 C1 | positive derivations from charge-even axioms certify nothing charged | a derivation may not spend what its axioms do not carry — the budget in proof-theoretic units |
| `PROOF_DIFF_FF` / R0010 | the Sawin–Shusterman route needs P1–P3; $\mathbb Z$ lacks the deformation direction ($\mathrm{Der}(\mathbb Z)=0$), and the route dies over $\mathbb C[t]$ | the *reason* the geometric theater's budget is unbounded, stated as a missing-structure certificate |

R0010 is therefore not merely a no-go about one proof route. Read
through §2 it is the **structural explanation of the exchange rate**:
the geometric theater has an unbounded budget because it has an object
$\mathbb Z$ provably lacks, and the certificate says exactly which one.

## 4. What this makes predictable (the atlas's stated goal)

The atlas wanted to be predictive. Under this reading it is, with the
prediction stated negatively and sharply:

> No attack raises a theater's budget without supplying equidistribution
> for the off-diagonal it needs. Purchases are always of that one kind:
> Bombieri–Vinogradov buys averaged off-diagonal; Zhang/Maynard buy it
> over shift-averages; entropy decrement buys the charged 2-point sector;
> monodromy buys all of it and is unavailable over $\mathbb Z$ for the
> reason R0010 names.

Practical use, same shape as ATLAS §1's one-paragraph lever kill: for a
proposed attack, ask *which off-diagonal does it need evaluated, and
what supplies that evaluation?* If the answer is "nothing — it is
purely a better inequality inside the diagonal region", the attack is
capped before it starts. F25 is that test applied to integrality (capped,
zero room); L3 is it applied to sign freedom (capped); ATLAS §1 is it
applied to degree (capped, dominated). The three closures are one
observation: **every remaining freedom inside the diagonal is spent.**

That is also why the single surviving door is what it is. An
unconditional upper bound on the $F$-pairing just past band 1 is
literally the smallest possible purchase of off-diagonal information —
the minimal nonzero amount of "how primes pair" that anyone could hope
to certify. The record and this program's own E0 question meet there not
by coincidence but because that is the cheapest point on the boundary.

## 5. Rigor boundary

Proved and cited: Rudnick–Sarnak's $\sigma<2$ restriction and its
standard diagonal explanation; Katz–Sarnak/Deligne equidistribution as
the engine in the large-$q$ function-field limit; R0010's P1–P3
certificate and its $\mathrm{Der}(\mathbb Z)=0$ core (in-corpus, audited).
**Not proved here:** that "accessible off-diagonal depth" admits a single
formal definition specializing to $2$ over $\mathbb Z$ and $\infty$ in
the geometric limit. That definition is the actual theorem this note is
pointing at, and until someone writes it, §2–§4 are a structural
reading — the honest status is *a conjecture with two instances and a
mechanism*, not a law. The next concrete step is not more theaters; it
is to define the invariant for exactly two of them and check it
reproduces both numbers.

Prior art not yet searched for the invariant formulation
[prior-art check]: the counting/correlating crossover is folklore in
analytic number theory; the claim needing a search is the
*theater-invariant* framing, not the constituent facts.
