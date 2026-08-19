# The square-root horizon is where the walk's per-prime register becomes one bit

**Status: proved, elementary, exact. cf-archivist, 2026-08-14.**
**Joins: U0006 (the founding cubical-lane directive) × Delta 20 §"Prime-Pair
finite experiment" × `WALK_STATE_IS_ITS_LCM.md` × U0017 (information theory).**

No asymptotics are used in the theorem. No experiment was run. Every
ingredient below is classical; the content is the identification, and I say
so plainly rather than dressing a restatement as a discovery.

---

## Why this note exists

Three documents ask the same question in three vocabularies and none of them
cites the others.

**U0006** (owner-supplied, the document that founded `formal/cubical/`):

> At the $\sqrt X$ sieve horizon, we already know the unresolved
> factorization tail is **one bit**. That gives an almost ridiculously
> concrete finite experiment: $B=\mathbf 2$. Can we formally prove: local
> sieve state + one charge bit ⟹ complete factorization state?

**Delta 20** §"Prime-Pair finite experiment", item 1–2 and its closing
criterion:

> Construct a finite arithmetic process … compute Myhill–Nerode classes;
> behavioral Hankel rank. **If minimal behavioral dimension grows sharply
> near the square-root horizon, that is a rigorous finite signature of the
> reconstruction/parity difficulty.**

**`WALK_STATE_IS_ITS_LCM.md`** (this lane, proved): the walk's Nerode state
*is* its lcm, and the reachable state space at frontier $k$ is exactly the
divisor lattice of $\operatorname{cap}(k)=\operatorname{lcm}(1..k)$.

Delta 20 asks someone to *build* a finite arithmetic transition system and
compute its minimal state. **The walk is that system and its minimal state
is already computed in closed form and machine-checked.** So Delta 20's
requested signature can be read off exactly instead of measured — and when
you read it off, U0006's "one bit" is sitting there as a theorem.

---

## 1. The minimal state factors into independent per-prime registers

Write $\operatorname{cap}(k)=\operatorname{lcm}(1..k)=\prod_{p\le k}p^{a_p}$
with $a_p=\lfloor\log_p k\rfloor$.

By `WALK_STATE_IS_ITS_LCM.md` §2 the reachable minimal states at frontier
$k$ are exactly the divisors of $\operatorname{cap}(k)$, and a divisor is
exactly a choice of exponent $b_p\in\{0,1,\dots,a_p\}$ for each $p\le k$.
Hence, as a set,

$$\mathrm{States}(k)\;\cong\;\prod_{p\le k}\{0,1,\dots,a_p\}. \tag{1}$$

**The minimal state of the walk is a product of independent registers, one
per prime, the $p$-th holding $a_p+1$ values.** Nothing couples them: the
divisor lattice of a squarefull number is the product of its prime chains.
This is the walk's version of CRT, and it is why the state is a *number*
rather than a list (§1 of that note) — the number is the register file.

## 2. The register is one bit exactly above the square-root horizon

**Lemma.** For $p\le k$: $\;a_p=1\iff p>\sqrt k$.

*Proof.* $a_p=\lfloor\log_p k\rfloor=1$ iff $p\le k<p^2$, and $p^2>k$ iff
$p>\sqrt k$. $\blacksquare$

That is the whole thing. Combining with (1):

> **Theorem A (bit decomposition of the minimal state).**
> $$\mathrm{States}(k)\;\cong\;\underbrace{\mathbf 2^{\,\pi(k)-\pi(\sqrt k)}}_{\text{one bit per prime above }\sqrt k}\;\times\;\prod_{p\le\sqrt k}\{0,\dots,a_p\}.$$

**Every prime above the square-root horizon contributes exactly one bit to
the walk's minimal state, and every prime below it contributes strictly
more.** The horizon is not imposed, chosen, or asymptotic: it is the exact
locus where $\lfloor\log_p k\rfloor$ drops to $1$.

### What this says about U0006

U0006's "the unresolved factorization tail is one bit" is, in the walk
model, **not a heuristic about tails**. It is the statement $a_p=1$ for
$p\in(\sqrt k,k]$: above the square-root horizon a prime is *present or
absent*, with no multiplicity left to record. The one bit is a per-prime
register width, and $B=\mathbf 2$ is the right fibre because $\{0,\dots,a_p\}$
has two elements there and only there.

U0006 asked whether `local sieve state + one charge bit ⟹ complete state`.
In this model the answer is visible: one bit per high prime is *exactly* the
missing datum, and the count of missing bits is $\pi(k)-\pi(\sqrt k)$, not
one. **U0006's "one bit" is per prime, not per integer** — and that
distinction is the difference between a finite experiment that closes and
one that does not.

### What this says about Delta 20

Delta 20 wanted "minimal behavioral dimension grows sharply near the
square-root horizon" as a *signature to be computed*. Here it is instead a
identity: the per-prime contribution to $\log_2|\mathrm{States}(k)|$ is
$\log_2(a_p+1)$, which is $1$ for $p>\sqrt k$ and $>1$ for $p\le\sqrt k$.
The "sharp growth near the square-root horizon" is the jump of a step
function at $p=\sqrt k$, exactly, unconditionally, with no sampling.

## 3. Two information rates of one machine, and the two prime-counting functions

The same minimal machine has two different sizes, and they are the two
classical prime-counting functions.

**How many bits to NAME a state** — $\log_2$ of the number of Nerode
classes:

$$\log_2|\mathrm{States}(k)| \;=\; \bigl(\pi(k)-\pi(\sqrt k)\bigr)\;+\;\sum_{p\le\sqrt k}\log_2(a_p+1). \tag{2}$$

**How many bits to HOLD a state** — the register width, i.e. $\log_2$ of the
largest state:

$$\log_2\operatorname{cap}(k)\;=\;\frac{\psi(k)}{\ln 2},\qquad \psi=\text{Chebyshev}. \tag{3}$$

The correction sum in (2) is small: there are $\pi(\sqrt k)$ terms, each at
most $\log_2(\log_2 k+1)$, so it is $O\!\left(\frac{\sqrt k\,\log\log k}{\log k}\right)$.
Therefore

$$\log_2|\mathrm{States}(k)|\;=\;\pi(k)+O\!\left(\tfrac{\sqrt k\log\log k}{\log k}\right),
\qquad
\log_2\bigl(\max \mathrm{States}(k)\bigr)=\frac{\psi(k)}{\ln 2}.$$

> **Theorem B (two-rate law).** For the walk's minimal machine at frontier
> $k$: the *address length* of the state space is $\pi(k)$ up to
> $O(\sqrt k\log\log k/\log k)$, while the *register width* is
> $\psi(k)/\ln 2$. Their ratio tends to $\log k$.

So the two prime-counting functions are not two facts about primes here;
they are **two information measures of one machine**:

| classical object | machine meaning |
|---|---|
| $\pi(k)$ | how many independent registers — the address length of a state |
| $\psi(k)$ | how wide the register file — the number of bits a state occupies |
| $\psi(k)/\pi(k)\to\log k$ | bits per register, i.e. the average prime power's size |

And the two great statements about them become statements about the machine:

- **PNT** $\psi(k)\sim k$: the register file grows at a constant rate of
  $1/\ln 2$ bits per unit of frontier.
- **RH** $\psi(k)=k+O(\sqrt k\log^2k)$: **the register width is
  square-root-regular.** RH is a regularity statement about the memory law
  of a minimal lossless machine, not about zeros of a function — in this
  model, and only for this model, but exactly.

This is the U0017 reading (information theory as the unifying lens) with
nothing metaphorical in it: every quantity above is a bit-count of a state
space that `NaturalMachine.Walk*.agda` characterises with an exit code.

## 4. What is and is not new

**Not new.** $d(\operatorname{lcm}(1..k))=\prod_p(a_p+1)$,
$\log\operatorname{lcm}(1..k)=\psi(k)$, $a_p=1\iff p>\sqrt k$, and both
RH and PNT in $\psi$ form. Every line is classical and elementary; a
number theorist would call §§1–3 bookkeeping.

**New here.** The identification of that bookkeeping with the *minimal
state* of a machine this repository has proved things about — so that
U0006's one bit, Delta 20's square-root signature, and the walk's capacity
law are three readings of $\lfloor\log_p k\rfloor$. Nobody had joined them,
and each of the three documents was carrying the question as open.

**Not claimed.** Nothing about RH is proved, weakened, or approached. §3
translates RH into this vocabulary; a translation is not a result, and the
translation is only faithful for this machine. I am recording it because
U0016 says the corpus is likely sitting on unharvested joins, and this one
was three documents apart.

## 5. The next exact step, stated so it can be taken or refused

Theorem A is finite, elementary, and has no asymptotics — it is
`--safe`-checkable as it stands. `WALK_STATE_IS_ITS_LCM.md` §4 already flags
its §2(⊇) as the natural next Agda target and gives the proof strategy
(build $F_d$ from prime powers, use the `WalkForcing` coprime-multiplication
lemma). Theorem A is that plus the one-line Lemma of §2.

The honest open question this raises, which I do **not** know the answer to:
the walk is a *lossless* machine, so its state is the full divisor lattice.
The sieve is *lossy* — it observes only $p\le\sqrt X$. Delta 20's
$\mathrm{Ker}(q_z)\subseteq\;\sim_{\text{beh}}$ test asks precisely whether
the low-prime registers determine the high-prime ones for the prime-pair
task. Theorem A says the registers are **independent as a set**, which is
exactly why they cannot: a product has no cross-constraints. If that is the
whole reason the sieve loses parity, then the parity obstruction is the
statement that a product of registers has no section from a proper subfactor
— and that is a triviality dressed as a barrier, which would be worth
knowing. If it is *not* the whole reason, the missing structure is a
constraint on which divisors are *reachable by the pair process* as opposed
to by the walk, and naming that constraint is the real work.

I do not have that answer and am not going to imply I do.
