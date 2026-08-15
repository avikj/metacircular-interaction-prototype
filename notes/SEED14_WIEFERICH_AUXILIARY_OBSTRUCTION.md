# The general obstruction behind $e_b(q)\ge2$: Teichmüller form, the linear law, and the families it settles

Agent: `SEED-14` (Claude Opus 5), 2026-08-14. Lens: Sophie Germain — *work the
general obstruction; a condition on the auxiliary prime settles a whole family
at once.*

Target: §1 of `WHAT_IS_ACTUALLY_OPEN_across_the_whole_corpus_2026_08_14.md`,
which names the base-$2$, $e\ge2$ case as the residual open case shared by
`EXPOSED_SET`/`PINNING` and `CYCLOTOMIC_SENSOR`/`HEAD_DEPTH_BLINDNESS`.

**Nothing below claims anything about the infinitude of Wieferich primes**, in
any base. §6 states precisely which part is open and why the obstruction proved
here provably stops short of it.

Throughout: $q$ is an odd prime, $b\in\mathbb Z$ with $\gcd(b,q)=1$,
$d=\operatorname{ord}_q(b)$, and
$$e_b(q)\;=\;v_q\!\left(b^{\,d}-1\right)$$
is `CYCLOTOMIC_SENSOR`'s head depth. Recall (`HEAD_DEPTH_BLINDNESS` W3, and
immediately from lifting-the-exponent, since $d\mid q-1$ and $q\nmid q-1$):
$$e_b(q)=v_q\!\left(b^{\,q-1}-1\right).\tag{0}$$
So $e_b(q)\ge2$ is exactly "$q$ is a Wieferich prime for base $b$".

---

## 1. The obstruction is a Teichmüller distance

`CYCLOTOMIC_SENSOR`'s rigor boundary says of $e$: *"the organ neither needs nor
supplies an answer: $e$ is **observed** once per $(p,a)$, never predicted."*
There is a closed form. It does not predict $e$ cheaply — it says exactly what
$e$ measures.

Let $\omega_q:\mathbb Z_q^\times\to\mu_{q-1}(\mathbb Z_q)$ be the Teichmüller
character: $\omega_q(b)$ is the unique $(q-1)$-st root of unity in $\mathbb Z_q$
with $\omega_q(b)\equiv b \pmod q$.

> **Theorem A.** For $\gcd(b,q)=1$,
> $$\boxed{\;e_b(q)\;=\;v_q\!\left(b-\omega_q(b)\right).\;}$$

*Proof.* Write $u=b/\omega_q(b)\in 1+q\mathbb Z_q$. Since
$\omega_q(b)^{q-1}=1$, $(0)$ gives $e_b(q)=v_q(u^{q-1}-1)$. Factor
$u^{q-1}-1=(u-1)\sum_{i=0}^{q-2}u^{i}$; as $u\equiv1\pmod q$ the sum is
$\equiv q-1\not\equiv0\pmod q$, so $v_q(u^{q-1}-1)=v_q(u-1)$. Finally
$\omega_q(b)$ is a unit, so $v_q(u-1)=v_q(b-\omega_q(b))$. $\square$

The value is finite for every $|b|\ge2$: $e_b(q)=\infty$ would force
$b^{q-1}-1=0$ in $\mathbb Z$, i.e. $b=\pm1$.

> **Corollary A1 (four equivalent forms of the obstruction).** For $a\ge1$ the
> following are equivalent:
> 1. $e_b(q)\ge a$;
> 2. $b\equiv\omega_q(b)\pmod{q^a}$;
> 3. $b^{\,q^{a-1}}\equiv b\pmod{q^{a}}$;
> 4. $b$ is a $q^{a-1}$-st power in $(\mathbb Z/q^{a})^\times$.
>
> In particular, **$q$ is a base-$b$ Wieferich prime $\iff b^{q}\equiv b
> \pmod{q^{2}} \iff b$ is a $q$-th power residue mod $q^{2}$.**

*Proof.* (1)$\iff$(2) is Theorem A. For (2)$\iff$(3): with $u$ as above,
$v_q(u^{q^{a-1}}-1)=v_q(u-1)+(a-1)\ge a$, so
$b^{q^{a-1}}\equiv\omega_q(b)\pmod{q^{a}}$ always; substituting gives the
equivalence. (2)$\iff$(4): $(\mathbb Z/q^a)^\times$ is cyclic of order
$q^{a-1}(q-1)$, so its $q^{a-1}$-st powers are precisely its unique subgroup of
order $q-1$, which is the reduction of $\mu_{q-1}(\mathbb Z_q)$. $\square$

Form (4) is the reason this note is written in Germain's lens: **the Wieferich
condition is a power-residue condition**, the same species of object Germain's
auxiliary-prime method manipulates. Form (3) is the cheapest test: one
exponentiation mod $q^2$, no order computation. It recovers
`EXPOSED_SET` Lemma W and `HEAD_DEPTH_BLINDNESS` W4 as the special case
$a=2$ of a group-theoretic statement, and it explains W4's index: the blind
bases at depth $a$ are the $q^{a-1}$-st powers, of index $q^{a-1}$.

## 2. The obstruction is *linear*, and that settles the multiplicative family

> **Theorem B.** The Fermat quotient
> $\varphi_q(b)=\dfrac{b^{q-1}-1}{q}\bmod q$ induces a **surjective group
> homomorphism** $\varphi_q:(\mathbb Z/q^{2})^\times\twoheadrightarrow(\mathbb
> F_q,+)$ whose kernel is $W(q)=\{b: e_b(q)\ge2\}=\mu_{q-1}$.

*Proof.* Kernel: $\varphi_q(b)=0\iff q^2\mid b^{q-1}-1\iff e_b(q)\ge2$, which by
A1(4) is $\mu_{q-1}$, of index $q$. That $W(q)$ is a subgroup of index $q$ in a
cyclic group makes the quotient $\cong\mathbb Z/q$; $\varphi_q$ is a
homomorphism onto it because $b\mapsto b^{q-1}$ maps $(\mathbb Z/q^2)^\times$
onto $1+q\mathbb Z/q^2\mathbb Z$ and $(1+qx)(1+qy)=1+q(x+y)$ mod $q^2$.
$\square$

(The multiplicativity $\varphi_q(bc)\equiv\varphi_q(b)+\varphi_q(c)$ is
Eisenstein's 1850 logarithmic rule; see §7.)

Consequences — each is an entire family settled by one linear equation over
$\mathbb F_q$:

> **B1 (powers).** $e_{b^{k}}(q)\ge2\iff q\mid k\,\varphi_q(b)$. Hence if
> $e_b(q)=1$ then $e_{b^{k}}(q)\ge2\iff q\mid k$.
>
> **B2 (unconditional positive family).** For **every** odd prime $q$ and every
> $c$ prime to $q$: $e_{c^{q}}(q)\ge2$. Every perfect $q$-th power is a base for
> which $q$ is Wieferich; by A1(4) *every* Wieferich base mod $q^2$ arises this
> way.
>
> **B3 (the auxiliary-base move — Germain's shape).** Let $b_1$ satisfy
> $e_{b_1}(q)=1$. Then for **every** $b$ prime to $q$, exactly one
> $i\in\{0,\dots,q-1\}$ satisfies $e_{b\,b_1^{\,i}}(q)\ge2$, namely
> $i\equiv-\varphi_q(b)\varphi_q(b_1)^{-1}\pmod q$.
>
> **B4 (exact count over bases, with its error term).** For $X\ge1$,
> $$\#\{1\le b\le X:\gcd(b,q)=1,\;e_b(q)\ge2\}=(q-1)\left\lfloor
> \frac{X}{q^{2}}\right\rfloor+r,\qquad 0\le r\le q-1 .$$

*Proofs.* B1: $\varphi_q(b^k)=k\varphi_q(b)$. B2: $k=q$ in B1. B3:
$\varphi_q(bb_1^i)=\varphi_q(b)+i\varphi_q(b_1)$ is a bijective affine map of
$\mathbb F_q$ in $i$ once $\varphi_q(b_1)\ne0$; exactly one $i$ hits $0$. B4:
$W(q)$ is a union of exactly $q-1$ residue classes mod $q^{2}$. $\square$

B4 is stated to replace, with an exact statement, the transposed $1/q$ reading
that `HEAD_DEPTH_BLINDNESS` explicitly warns against: the density $1/q$ is a
theorem **over bases at fixed $q$**, with error at most $q-1$, and is not a
statement about primes at fixed base.

B3 is the honest Germain analogy and also its honest limit: shifting the *base*
by an auxiliary element always produces Wieferich pairs, because the base
variable ranges over a group. The prime variable does not, which is §6.

## 3. The obstruction, read across $(b,q)$: a repeated cyclotomic factor

> **Theorem C.** With $d=\operatorname{ord}_q(b)$,
> $$e_b(q)\;=\;v_q\!\left(\Phi_d(b)\right).$$
> Hence $q$ is a base-$b$ Wieferich prime $\iff q^{2}\mid\Phi_{d}(b)$.

*Proof.* $b^{d}-1=\prod_{m\mid d}\Phi_m(b)$. If $m\mid d$ and $m<d$ then
$q\nmid\Phi_m(b)$, since $q\mid\Phi_m(b)$ implies $b^{m}\equiv1\pmod q$,
contradicting $\operatorname{ord}_q(b)=d$. So all $q$-adic valuation sits in the
top factor. (No exceptional case: $q\mid d$ is impossible because $d\mid q-1$.)
$\square$

So the base-$b$ Wieferich primes are exactly the primes occurring to
multiplicity $\ge2$ in the sequence $\bigl(\Phi_n(b)\bigr)_{n\ge1}$ — the
*repeated primitive divisors*. This is the general obstruction: not a property
of $q$ alone, but the failure of a single cyclotomic value to be squarefree at
$q$.

## 4. The auxiliary-prime condition that settles a whole family unconditionally

Germain's move is to impose a condition on the auxiliary prime and dispose of
every member of a family at once. Here the condition is *size*, and it is
sharp enough to be useful.

> **Theorem D (size obstruction).** Let $b\ge2$ and $d=\operatorname{ord}_q(b)$.
> Then
> $$(b-1)^{\varphi(d)}\;\le\;\Phi_d(b)\;\le\;(b+1)^{\varphi(d)},$$
> and consequently
> $$\boxed{\;q>(b+1)^{\varphi(\operatorname{ord}_q(b))/2}\;\Longrightarrow\;
> e_b(q)=1.\;}$$
> Equivalently: $e_b(q)\ge2$ **forces**
> $\varphi(\operatorname{ord}_q(b))\ \ge\ \dfrac{2\log q}{\log (b+1)}$, and more
> generally $e_b(q)\ge a$ forces $\varphi(\operatorname{ord}_q(b))\ge a\log
> q/\log(b+1)$.

*Proof.* $\Phi_d(b)=\prod_{\zeta}(b-\zeta)$ over the $\varphi(d)$ primitive
$d$-th roots of unity, and $b-1\le|b-\zeta|\le b+1$ for $b\ge2$. By Theorem C,
$e_b(q)\ge a$ gives $q^{a}\mid\Phi_d(b)$, so $q^{a}\le\Phi_d(b)\le
(b+1)^{\varphi(d)}$. $\square$

Families settled outright, with no hypothesis of any kind:

> **D1.** If $\operatorname{ord}_q(b)\in\{1,2,3,4,6\}$ (i.e. $\varphi(d)\le2$)
> and $q>b+1$, then $e_b(q)=1$. Explicitly, for $q>b+1$ dividing one of
> $b-1,\;b+1,\;b^{2}+b+1,\;b^{2}+1,\;b^{2}-b+1$, the prime $q$ is not a base-$b$
> Wieferich prime. For $d\in\{1,2\}$ the threshold improves to $q>\sqrt{b+1}$:
> $q\,\|\,(b-1)$ or $q\,\|\,(b+1)$ already gives $e_b(q)=1$.
>
> **D2 (large primitive divisors).** If $q\mid\Phi_d(b)$ and
> $q>\sqrt{\Phi_d(b)}$ then $e_b(q)=1$. In particular **every prime value
> $\Phi_d(b)=q$ produces a non-Wieferich prime** for base $b$.
>
> **D3 (the congruence conditions on $b$, in both directions).** Fix $q$.
> *Forced:* $b\equiv\zeta\pmod{q^{2}}$ for any $\zeta\in\mu_{q-1}$ — equivalently
> $b\equiv c^{q}\pmod{q^{2}}$ for some $c$; this includes $b\equiv\pm1\pmod{q^2}$.
> *Forbidden:* $b\equiv\zeta+cq\pmod{q^{2}}$ with $q\nmid c$; concretely
> $q\,\|\,(b-1)$ or $q\,\|\,(b+1)$.
> No condition on $b$ modulo $q^{2}$ can decide $e_b(q)\ge3$: the deciding
> subgroups are nested, $\mu_{q-1}\subset(\mathbb Z/q^{a})^\times$ at level
> $q^{a}$, so depth $a$ is a congruence condition mod $q^{a}$ and nothing coarser.

Sanity checks of the classical data against Theorem D, which the theorem
predicts must pass (it is a necessary condition, not a search):
$q=1093$, $b=2$, $d=364$, $\varphi(364)=144\ge 2\log1093/\log3=12.73$ ✓;
$q=3511$, $d=1755$, $\varphi(1755)=864\ge14.87$ ✓.

## 5. Where the obstruction provably stops: the Germain-pair boundary

Theorem D kills every $q$ at which $b$ has *small* multiplicative order. The
opposite extreme is exactly the classical Germain-pair family, and there the
obstruction is vacuous — worth stating, because it marks the reach of the method
rather than hiding it.

> **Proposition E.** Let $p\equiv3\pmod4$ be prime with $q=2p+1$ prime. Then
> $\operatorname{ord}_q(2)=p$, so $e_2(q)=v_q(2^{p}-1)$, and Theorem D's
> hypothesis reads $q>3^{(q-3)/4}$, which fails for every $q\ge11$. ~~The size
> obstruction says nothing about $(2,q)$ for Sophie Germain pairs.~~ **[SEED-95:
> over-wide by one member — corrected below; the pair $q=7$ *is* settled.]**

*Proof.* $q=2p+1\equiv7\pmod 8$, so $2$ is a quadratic residue mod $q$ and
$2^{p}=2^{(q-1)/2}\equiv1\pmod q$. As $p$ is prime and $2\not\equiv1$, the order
is $p$. Then $\varphi(p)=p-1=(q-3)/2$ and $(b+1)^{\varphi(d)/2}=3^{(q-3)/4}$.
$\square$

~~The size obstruction says nothing about $(2,q)$ for Sophie Germain pairs.~~
**[Struck by SEED-95, 2026-08-14, Rule K1/K3.]** The last sentence of
Proposition E is over-wide by exactly one member of its own family. The
smallest $p\equiv3\pmod4$ with $q=2p+1$ prime is $p=3$, $q=7$, and there
$d=\operatorname{ord}_7(2)=3$, $\varphi(3)=2$, so the threshold is
$(b+1)^{\varphi(d)/2}=3^{1}=3<7=q$: Theorem D **does** apply and gives
$e_2(7)=1$. The displayed inequality in Proposition E is correct as stated —
it fails for every $q\ge11$ — and $q=7$ is below that bound. Corrected
statement: *the size obstruction says nothing about $(2,q)$ for any Sophie
Germain pair with $q\ge11$, and settles the single pair $q=7$.* Nothing else in
§5 or §6 depends on the struck sentence.

This is the general shape of the limitation: the elementary obstruction is a
*size* obstruction, and it is powerless precisely where $b$ generates a large
subgroup — which is the generic case, and the only case in which the infinitude
questions live.

**Currency annotation (SEED-95, 2026-08-14, Rule K1): how Theorem D meets the
CRT synchronisation clause.** This note was written before
`SEED66_CRT_SYNCHRONISATION.md` and `SEED68_REFEREEING_THE_REFEREE.md` landed.
Those notes make the interaction derivable rather than speculative, so it is
written here rather than left as a question.

Let $n=\prod_{j\le k}q_j^{a_j}$ be odd and $\gcd(b,n)=1$. `SEED-66` Lemma 2 /
`SEED-10` Lemma 0 give that any strong or Fermat non-witness satisfies
$e_b(q_j)\ge a_j$ for every $j$; `SEED-66` Theorem N (sharpened) / `SEED-68`
Theorem D give that the *remaining* clause is $v_1=\dots=v_k=:v$ with
$v_j=v_2(\operatorname{ord}_{q_j}b)$. Two consequences, both immediate from
Theorem D above:

> **E1 (the blindness-depth clause is where Theorem D acts).** For any slot with
> $a_j\ge2$, blindness forces $e_b(q_j)\ge a_j\ge2$, so by Theorem D
> $$\varphi\bigl(\operatorname{ord}_{q_j}b\bigr)\ \ge\ \frac{a_j\log q_j}{\log(b+1)} .$$
> Theorem D therefore prunes the *ambient* calendar of `SEED-66` §1 (the
> condition $e_j\ge a_j$), not its synchronisation clause. Squarefree $n$ — every
> $a_j=1$ — is untouched, which is why Carmichael-type $n$ never meet this
> obstruction.
>
> **E2 (the size obstruction cannot bite at a high shell).** Write
> $d_j=2^{v}u_j$ with $u_j$ odd. For $v\ge1$, $\varphi(d_j)=2^{v-1}\varphi(u_j)
> \ge 2^{v-1}$. So the necessary condition of Theorem D is satisfied
> automatically once $2^{v-1}\ge a_j\log q_j/\log(b+1)$, i.e. Theorem D can
> exclude a synchronisation shell $v$ only when
> $$v\ <\ 1+\log_2\!\frac{a_j\log q_j}{\log(b+1)} .$$
> The shells `SEED-66` Theorem X weights most heavily (large $w$, weight
> $2^{k(w-1)}$) are exactly the ones the size obstruction cannot reach.

Neither statement is measured; both are one substitution into Theorem D. The
verdict for §6 is unchanged: the synchronisation clause is a $2$-adic
consistency condition (`SEED-68` §5.1) and Theorem D is a size condition on
$\varphi(d)$, and they constrain disjoint parts of the tape $(d_j,e_j)$.

## 6. Exactly what is open

Everything in §§1–5 is unconditional. The following are **not** claimed and
**not** proved here:

1. **Infinitude of base-$b$ Wieferich primes.** For no base $b$ is it known
   whether infinitely many, or only finitely many, primes $q$ have
   $e_b(q)\ge2$. Base $2$: only $1093$ and $3511$ are known, and the search
   bound is prior art (§7). Nothing above bears on this, and B4 must not be
   transposed into a density claim over $q$ — see the warning in
   `HEAD_DEPTH_BLINDNESS`, which I am reinforcing rather than weakening.
2. **Infinitude of base-$b$ non-Wieferich primes** is also open
   unconditionally. It follows from the $abc$ conjecture (Silverman 1988: at
   least $\gg\log x$ up to $x$). Theorem D2 is the elementary skeleton of that
   implication: a non-Wieferich prime is *produced* by any $d$ for which
   $\Phi_d(b)$ has a prime factor exceeding $\sqrt{\Phi_d(b)}$. The open input
   is exactly the supply of such $d$ — i.e. large prime factors of cyclotomic
   values — and that is where $abc$-strength is consumed. The gap is therefore
   located precisely, not merely named.
3. **$e_2(q)\ge3$**: no example is known; nothing here forbids one. Theorem D
   only says it would require $\varphi(\operatorname{ord}_q(2))\ge3\log
   q/\log3$.
4. **`HEAD_DEPTH_BLINDNESS` seed 1** (the strong-test analogue of W3) is
   untouched. Corollary A1 sharpens only the Fermat side; the strong-test
   correction term remains open and `PINNING`'s hybrid sensor still has only the
   Fermat upper bound.

## 7. Prior art — consumed, not reproved

Searched before writing, per `CLAUDE.md`. **All the mathematics in §§1–5 is
classical**; I claim no novelty for any statement, only for the assembly and for
the identification with this corpus's objects.

- **Wieferich (1909)**, *Zum letzten Fermat'schen Theorem*, J. reine angew.
  Math. 136 — the condition $2^{p-1}\equiv1\pmod{p^2}$ and its role in case I of
  FLT. **Mirimanoff (1910)** for base 3. These are the historical companions of
  Germain's auxiliary-prime theorem, which is why the lens fits the object.
- **Eisenstein (1850)** — the logarithmic rule
  $\varphi_p(ab)\equiv\varphi_p(a)+\varphi_p(b)$. Theorem B is this plus the
  identification of the kernel; both classical.
- **Teichmüller lifts / Hensel** — Theorem A and Corollary A1 are the standard
  description of $\mu_{q-1}\subset\mathbb Z_q^\times$ and of the $q^{a-1}$-st
  powers in the cyclic group $(\mathbb Z/q^a)^\times$; textbook $p$-adics.
- **Zsigmondy (1892), Birkhoff–Vandiver (1904)**, and the standard theory of
  primitive prime divisors — Theorem C ($e_b(q)=v_q(\Phi_d(b))$) and the bounds
  $(b-1)^{\varphi(d)}\le\Phi_d(b)\le(b+1)^{\varphi(d)}$ of Theorem D are
  standard there. The equivalence "$q$ base-$b$ Wieferich $\iff q^2\mid\Phi_n(b)$
  for the relevant $n$" appears in the literature on prime divisors of
  cyclotomic values (e.g. work on sparse values of $\Phi_n$ and Wieferich
  primes, J. Number Theory 2019).
- **Silverman (1988)**, *Wieferich's criterion and the $abc$-conjecture*, J.
  Number Theory 30, 226–237 — $abc\Rightarrow\gg\log x$ non-Wieferich primes
  base $a$. **Graves–Murty (2013)** and successors for progressions $q\equiv1
  \pmod k$; recent extensions to number fields (arXiv:2503.19144).
- **Search bounds**: Dorais–Klyve (2011), $2$-Wieferich search to
  $6.7\times10^{15}$; Crandall–Dilcher–Pomerance (1997). Quoted as prior art in
  `PINNING` already.
- **Suzuki (1994)** — $\ell^{p-1}\equiv1\pmod{p^2}$ for all primes $\ell\le113$
  if case I of FLT fails; the Furtwängler (1912) / Vandiver line. Cited to place
  Germain's method beside Wieferich's, not used.

**What is not in the literature, as far as I can tell, and is the only thing
offered as new:** the identification of this corpus's head depth with a
Teichmüller distance, $e_b(q)=v_q(b-\omega_q(b))=v_q(\Phi_{\operatorname{ord}_q
(b)}(b))$, which supplies a closed form where `CYCLOTOMIC_SENSOR` recorded
"observed, never predicted"; the statement of `HEAD_DEPTH_BLINDNESS` W4 as the
$a$-th-power-residue description A1(4) (which gives the index $q^{a-1}$ as a
corollary rather than a computation); and B4 as the exact replacement, with
error term, for the $1/q$ reading that note forbade.

## 8. What this does for the corpus's §1 merge

`WHAT_IS_ACTUALLY_OPEN` §1 asks for one quantity computed once. Corollary A1(3)
gives the cheapest such computation:
$$e_b(q)\ \ge a\quad\Longleftrightarrow\quad b^{\,q^{a-1}}\equiv b\pmod{q^{a}},$$
one modular exponentiation, **no order computation, no factorization of
$q-1$** — where the present organs compute $\operatorname{ord}_q(b)$ first.
That is a strictly cheaper single routine serving `CYCLOTOMIC_SENSOR`'s head
depth, `HEAD_DEPTH_BLINDNESS`'s blindness depth, and `PINNING`/`EXPOSED_SET`'s
Wieferich exception. The merge the corpus keeps asking for is one function of
$(b,q,a)$ and the above is its body.

## 9. Honesty ledger

- §§1–5: proved, unconditional, no computation used or needed. The two numerical
  lines in §4 are consistency checks of a *necessary* condition against numbers
  already in `PINNING`; they are not evidence for anything and nothing depends
  on them.
- §6: nothing about infinitude is claimed. Item 2 asserts only that Theorem D2
  is the elementary half of Silverman's implication, which is a statement about
  the shape of the argument, not a new result.
- No Python was run. No file in `machinery/` was executed or written.
- Scope: $q$ odd throughout. $q=2$ is untouched, as in `HEAD_DEPTH_BLINDNESS`
  (the head is two entries long there and $(\mathbb Z/2^a)^\times$ is not
  cyclic, so A1(4) fails verbatim).

## Successor seeds

1. **PROVE** — $q=2$. $(\mathbb Z/2^{a})^\times\cong\mathbb Z/2\times\mathbb
   Z/2^{a-2}$; the Teichmüller argument of Theorem A splits into a sign and a
   $1$-unit part, which should be exactly `CYCLOTOMIC_SENSOR`'s two-entry head
   $(e_-,e_+)$. This is `HEAD_DEPTH_BLINDNESS` seed 2 and Theorem A makes it a
   half-page.
2. **PROVE** — the strong-test correction term (`HEAD_DEPTH_BLINDNESS` seed 1),
   still open, now with A1(3) as the cheap Fermat side to subtract from.
3. **PROVE** — is there an analogue of Theorem D for the *residual* family
   $n=q^{a}r$ of `EXPOSED_SET` seed 1? The strong test on a semiprime is
   governed by $\operatorname{ord}_q$ and $\operatorname{ord}_r$; Theorem D
   bounds what a small-order prime can hide, which is the same species of size
   obstruction.
