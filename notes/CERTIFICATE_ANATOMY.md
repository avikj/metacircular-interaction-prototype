# Certificate anatomy: where the organism's senses are forced

> **Retitled 2026-08-12.** The original title, *"Sensor freedom exists only
> where the anatomy cannot be permanent"*, asserted the slogan that
> [`PINNING.md`](PINNING.md) refutes. Theorems F and G's table stand; the
> exclusion does not.

Auditor: `claude_arithmetic_breaker` (Claude Opus 5), 2026-08-12.
Closes seed 1′ of `notes/ARITHMETIC_LIFE_ADVERSARIAL_AUDIT.md`, open since
session 1 and deferred five times.

## The question

T5 of that audit proved that under the **residue-divisibility** certificate —
"$n$ is prime iff no active modulus $\le\sqrt n$ divides it" — the organism's
sensor set has **zero degrees of freedom**: soundness holds iff every prime
below the frontier is active, and any omission is falsified by a prime square.
The anatomy is not selected, it is forced by the certificate form. So no
process, however encounter-driven, can be credited with discovering it.

The escape recorded there was that T5 is conditional. Under a Fermat/Pratt-style
certificate the sensor is a **base**, not a modulus, and bases are not forced by
divisibility — so, I wrote, "the anatomy might finally have choices to make".

It does. But not where it can keep them.

## Theorem F — on a Carmichael number the Fermat test *is* trial division

> **Theorem F.** Let $n$ be a Carmichael number and $2\le a\le n-1$. Then
> $$a^{\,n-1}\not\equiv1 \pmod n \iff \gcd(a,n)>1 .$$

*Proof.* ($\Leftarrow$) Put $g=\gcd(a,n)>1$. If $a^{n-1}\equiv1\pmod n$ then
$g\mid n\mid a^{n-1}-1$, while $g\mid a\mid a^{n-1}$; so $g\mid1$, a
contradiction. ($\Rightarrow$) Suppose $\gcd(a,n)=1$. For each prime $p\mid n$
the order of $a$ mod $p$ divides $p-1$, which divides $n-1$ by Korselt's
criterion, so $a^{n-1}\equiv1\pmod p$. As $n$ is squarefree, CRT gives
$a^{n-1}\equiv1\pmod n$. $\square$

> **Corollary.** A Fermat anatomy $A$ refutes a Carmichael $n$ **iff** some
> element of $A$ shares a prime factor with $n$; and the least such element is
> a prime divisor of $n$.

So on the Carmichael family the Fermat scheme carries no information that trial
division does not, and soundness there forces the anatomy to contain a prime
divisor of each — **T5's forcing, recovered inside the scheme that was supposed
to escape it.** Every unit is inert: at $n=561$ all $319$ units are inert, at
$n=8911$ all $7127$ are. The freedom is total on generic inputs and exactly nil
on the inputs where the test is weakest.

Verified for every Carmichael number below $10^4$ (561, 1105, 1729, 2465, 2821,
6601, 8911): the refuter set and the non-unit set are *identical*, and the least
refuter is always a prime divisor. Korselt's criterion is also checked against
its defining property for every odd composite below 3000.

## The strong scheme has real freedom, and cannot retain it

The Miller–Rabin test has no Carmichael analogue. By Rabin's theorem at least
$3/4$ of bases witness every odd composite, so at each $n$ there are many
admissible one-sensor anatomies — genuine choice, of the kind T5 showed does not
exist for moduli. But:

- fixed anatomy $\{2\}$ certifies **2047** $=23\cdot89$ as prime;
- fixed anatomy $\{2,3\}$ certifies **1373653** as prime.

Both verified *least* by exhaustive scan here, not cited. Enlarging the anatomy
only moves the failure: $3$ refutes 2047, and then $\{2,3\}$ fails later.

> **Theorem G (the trade).** Across the three certificate forms the organism can
> hold:
>
> | scheme | anatomy | sound with a fixed anatomy? |
> |---|---|---|
> | divisibility | **forced** — exactly $\mathcal P(\lfloor\sqrt n\rfloor)$ (T5) | yes |
> | Fermat | free on generic $n$; **forced back to divisibility** on Carmichael $n$ (Thm F) | no |
> | strong | **genuinely free** at every $n$ (Rabin) | no — 2047, 1373653 |
>
> ~~Freedom and permanence are exclusive. Where the anatomy is determined it can
> be retained; where it can be chosen it must be re-chosen.~~
>
> **STRUCK 2026-08-12 by the author, see [`PINNING.md`](PINNING.md).** The table
> above is correct for these three schemes, but the slogan over-generalizes and
> the mechanism proposed for it is wrong. Forcing is **pinning**, not
> permanence: an anatomy is forced exactly on the non-instances refuted by only
> one sensor. Give each prime sensor a second refutation mode (divisibility *or*
> strong witness) and pinning vanishes while permanence survives — verified
> exhaustively for every frontier `B <= 100`: zero pinned composites and all
> `pi(B)` sensors individually droppable, against zero droppable under pure
> divisibility. Freedom and permanence therefore coexist.

## The answer to seed 1′, and what it does to the organism

~~**Sensor selection is a real phenomenon only under the strong certificate, and
only for anatomies chosen per encounter and then discarded.**~~ **Withdrawn as
stated ([`PINNING.md`](PINNING.md)): a hybrid sensor with two refutation modes is
both retained and genuinely selected. What survives is narrower and still
useful — *this* anatomy has no choice because *this* scheme pins every prime
square.**

~~The permanent anatomy of `ARITHMETIC_LIFE_FIRST_EXECUTION` equation (5) — the
retained tuple $(q_2,q_3,q_5,q_7,q_{11})$ — is incompatible with the only
certificate class that offers a choice to make. I record this as a no-go for
permanence, not for selection.~~ **Also struck ([`PINNING.md`](PINNING.md)): it
depended on the slogan. The corrected reading of (5) is that its anatomy is
forced because its scheme pins every prime square, and that adding a second
refutation mode to the same sensors keeps the retention while removing the
forcing. So (5) is not evidence of learning, but neither is it an obstruction to
learning — the route "encounter-driven selection with a retained anatomy" is
*open*, and `machinery/pinning.py` is a construction of it.**

What T5 and Theorem F jointly establish, and what survives all of this: within
the *divisibility* scheme and within the *Fermat* scheme on Carmichael numbers,
the anatomy is forced. `FAILURES.md` F30 is extended twice — once for those two
schemes, once to record that the general exclusion I inferred from them is
false.

## Prior art, searched before writing

Korselt's criterion (1899); Carmichael numbers (1910); Rabin's $3/4$ witness
bound (1980); the least strong pseudoprimes to $\{2\}$ and $\{2,3\}$
(Pomerance–Selfridge–Wagstaff 1980). **No novelty is claimed for any of these**,
and Theorem F is a routine consequence of Korselt that any number theorist would
write down. What is new here is only the reading: which certificate forms leave
the organism's anatomy free. (The further inference that freedom and permanence
are exclusive is struck above; forcing is pinning, and pinning is removable.)
Grep over `notes/`, `machinery/`, `collab/` found no prior occurrence of
Carmichael numbers or the strong test in this corpus.

## Scope limits

- Theorem F is exactly about Carmichael numbers. For non-Carmichael composites
  the Fermat scheme does have real freedom; the point is that soundness is
  decided on the hard family, not the generic one.
- I verify Rabin's bound as a **falsifier only** for odd composites below 2000;
  the $3/4$ theorem is consumed, not reproved.
- The two least-pseudoprime claims *are* proofs: exhaustive scan over all odd
  composites below the stated value.
- Nothing here addresses Pratt certificates proper (a primitive root plus a
  factorization of $n-1$). Those are *succinct* rather than *sensor-based*, and
  I do not think the anatomy question is even well posed for them — that is
  seed 1 below.

## Replay

```
cd machinery
python3 certificate_anatomy.py                   # Theorem F across all Carmichaels < 10^4
python3 -m unittest test_certificate_anatomy -v  # 11 tests
```

## Successor seeds

1. **PROVE** — Pratt certificates. A Pratt certificate is a recursive object,
   not a retained sensor, so "anatomy" may not be the right question. Is there a
   certificate class with *both* freedom and permanence, or is Theorem G's
   exclusion general? I suspect it is general and that the reason is the one T5
   found: permanence requires the certificate to be decided by a fixed finite
   test set, and a fixed finite test set is either complete (hence forced) or
   incomplete (hence unsound).
2. **PROVE** — quantify. Under the strong scheme, what is the least
   $k$ such that some $k$-element base set is sound for all $n\le N$? For
   $N<2047$, $k=1$ suffices. The growth of that function is the exact price of
   permanence, and it is bounded below by the strong-pseudoprime records.
3. **DEMONSTRATE** — the organism currently has no strong-test organ. Adding one
   would be the first sensor in the corpus that must be *forgotten* after use.
   That is a genuinely new state transition and would be worth executing.
