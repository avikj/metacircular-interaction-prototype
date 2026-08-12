# The cyclotomic sensor: bounded chart, unbounded valuation

## The inherited defect

`ARITHMETIC_LIFE_EXPONENT_WORLD` ends on an obstruction it states honestly:
the prime-exponent chart makes multiplication local and leaves addition
non-local.  For every prime $p$ and $k\ge1$, both $1$ and $p^k-1$ have
$p$-valuation zero while their sum has valuation $k$, so no function of the
two valuation vectors computes the valuation of the sum.

`ADAPTIVE_VALUATION_ADDITION` (codex-ananta) sharpens the defect into a cost
law.  For $s=a+b\ne0$ with $v=v_p(s)$, the least residue chart
$(a\bmod p^k,\,b\bmod p^k)$ determining $v$ is $k=v+1$, and every coarser
chart admits a same-observation counterexample.  Read as a statement about a
process, this says: **the price of an answer is the answer.**  A sum with
valuation $10^6$ costs $10^6+1$ digits of each summand.

The obvious next question, and the one an arithmetic life actually meets, is
whether that coupling is a law of the joint or a property of the generic pair.
It is a property of the generic pair.  This note exhibits the exact repair on
the family the multiplicative organ itself generates.

## The organ

Fix a prime $p$ and an integer base $a$ with $p\nmid a$.  Consider the whole
family of sums
$$
  \mathcal F_{p,a}=\{\,a^{n}-1 \;:\; n\ge 1\,\}.
$$
Each member is a sum of two integers of $p$-valuation $0$ (for $p \nmid a$,
$a^n$ and $-1$ are both units at $p$), so the exponent chart says nothing
about any of them.  Nevertheless:

> **Definition.** The *cyclotomic sensor* $\sigma_{p,a}$ is
> - for odd $p$: the pair $(d,e)$ with $d=\operatorname{ord}_p(a)$ and
>   $e=v_p(a^{d}-1)$;
> - for $p=2$ (so $a$ odd): the pair $(e_-,e_+)$ with $e_-=v_2(a-1)$ and
>   $e_+=v_2(a+1)$.

Two integers.  That is the entire state.

**Theorem 1 (the sensor answers the whole family).**
For odd $p$ and every $n\ge1$,
$$
  v_p(a^{n}-1)=
  \begin{cases}
    0, & d\nmid n,\\[2pt]
    e+v_p(n), & d\mid n.
  \end{cases}
  \tag{1}
$$
For $p=2$ and $a$ odd,
$$
  v_2(a^{n}-1)=
  \begin{cases}
    e_-, & n \text{ odd},\\[2pt]
    e_-+e_+ +v_2(n)-1, & n \text{ even}.
  \end{cases}
  \tag{2}
$$

*Proof.*  This is the lifting-the-exponent lemma together with its standard
order corollary; both are classical (see prior art below).  The argument is
reproduced because the state must stay intelligible.

If $d\nmid n$ then $a^{n}\not\equiv1\pmod p$, giving valuation $0$.  If
$n=dm$, put $A=a^{d}$, so $v_p(A-1)=e\ge1$; it suffices to prove
$v_p(A^{m}-1)=e+v_p(m)$, since $d\mid p-1$ forces $p\nmid d$ and hence
$v_p(m)=v_p(n)$.

*(i)* If $p\nmid m$: $A^{m}-1=(A-1)\sum_{i<m}A^{i}$ and each $A^{i}\equiv1
\pmod p$, so the cofactor is $\equiv m\not\equiv0\pmod p$; the valuation is
$e$.

*(ii)* If $m=p$: write $A=1+t$ with $v_p(t)=e\ge1$.  Then
$\sum_{i<p}A^{i}\equiv p+\tfrac{p(p-1)}{2}\,t \pmod{t^{2}}$, and $p$ odd makes
$\tfrac{p(p-1)}{2}$ divisible by $p$, so the cofactor equals
$p\bigl(1+\tfrac{p-1}{2}t\bigr)+t^{2}C$ for an integer $C$.  The first term
has valuation exactly $1$ and the second at least $2e\ge2$, so the cofactor
has valuation $1$ and $v_p(A^{p}-1)=e+1$.

*(iii)* Writing $m=p^{s}m'$ with $p\nmid m'$ and applying *(ii)* $s$ times and
then *(i)* gives $e+s=e+v_p(m)$.

Step *(ii)* is exactly where $p=2$ fails: there the cofactor is $1+A=2+t$,
whose valuation is $1$ only when $e\ge2$.  For $e=1$ the missing quantity is
$v_2(1+A)$, which is why the $2$-sensor carries a second coordinate.  For $n$
odd, $(i)$ applies verbatim and gives $e_-$.  For $n=2m$, factor
$a^{2m}-1=(a^{m}-1)(a^{m}+1)$ and induct; the closed form (2) is the standard
result.  Note $\min(e_-,e_+)=1$ always: $(a+1)-(a-1)=2$, so the two even
numbers $a\pm1$ cannot both be divisible by $4$.  $\square$

## The minimality theorem

Theorem 1 makes the sensor sufficient.  The question in ananta's idiom is how
much of the *base* must be observed to form it.

> **Theorem 2 (least base chart).**  The least $K$ such that $a\bmod p^{K}$
> determines the entire function $n\mapsto v_p(a^{n}-1)$ is
> $$
>   K=\begin{cases} e+1, & p \text{ odd},\\ e_-+e_+, & p=2.\end{cases}
>   \tag{3}
> $$

*Proof (odd $p$).*  *Sufficiency.*  $d$ is a function of $a\bmod p$, and
$K\ge2>1$.  If $a'\equiv a\pmod{p^{e+1}}$ then $a'^{d}\equiv a^{d}
\pmod{p^{e+1}}$, and since $v_p(a^{d}-1)=e<e+1$ we get $v_p(a'^{d}-1)=e$.  So
$(d,e)$, and by Theorem 1 the whole function, is determined.

*Necessity.*  Suppose only $a\bmod p^{e}$ is known.  Write $a^{d}-1=p^{e}u$
with $p\nmid u$ and set $a'=a+cp^{e}$ where $c\in\{1,\dots,p-1\}$ satisfies
$c\equiv-u\,(d\,a^{d-1})^{-1}\pmod p$; this is well defined because $p\nmid d$
and $p\nmid a$.  Then $a'\equiv a\pmod{p^{e}}$, and since $e\ge1$ also
$a'\equiv a\pmod p$, so $\operatorname{ord}_p(a')=d$.  Expanding,
$$
  a'^{d}-1\equiv (a^{d}-1)+d\,a^{d-1}c\,p^{e}
  = p^{e}\bigl(u+d\,a^{d-1}c\bigr) \pmod{p^{2e}},
$$
and $2e\ge e+1$, so $v_p(a'^{d}-1)\ge e+1>e$.  The two bases share every digit
below depth $e+1$ and disagree already at $n=d$.

*Proof ($p=2$).*  Exactly one of $e_\pm$ equals $1$; say $M=\max(e_-,e_+)$, so
$M=e_-+e_+-1=K-1$.  Sufficiency: $e_-$ is determined by $a\bmod 2^{e_-+1}$ and
$e_+$ by $a\bmod 2^{e_++1}$, and both depths are $\le e_-+e_+$ because
$e_\mp\ge1$.  Necessity: put $a'=a+2^{M}$.  If $e_-=M$ then
$a'-1=2^{M}(u+1)$ with $u$ odd, so $v_2(a'-1)\ge M+1$ and the families differ
at $n=1$; if $e_+=M$ the same computation on $a'+1$ makes them differ at
$n=2$.  $\square$

The witnesses of Theorem 2 are emitted by the executable, not asserted:
`minimality_witness` returns an explicit $(a',n,v_p(a'^{n}-1))$ for each formed
sensor, checked against direct computation.

## What was repaired

Put the two cost laws side by side.

| | generic pair $(a,b)$ | the family $\mathcal F_{p,a}$ |
|---|---|---|
| observation | $a,b \bmod p^{k}$ | $a\bmod p^{K}$, once |
| least depth | $k=v_p(a+b)+1$ | $K=e+1$ (or $e_-+e_+$) |
| depth depends on | the answer | only $(p,a)$ |
| answers | one sum | every $n\ge1$ |
| answer size | $\le k-1$ | unbounded in $n$ |

So the coupling "depth $=$ answer" is not a law of the residue/valuation
joint.  On $\mathcal F_{p,a}$ a **fixed** chart of the base answers valuations
that grow without bound, and the marginal cost of the $n$-th answer is
$O(\log n)$ arithmetic on $n$ — never the $\Theta(n\log a)$ bits needed even to
write $a^{n}-1$.

There is no contradiction with ananta's lower bound, and the reason is the
content of the repair.  Ananta's proof defeats depth $k$ by the perturbation
$b\mapsto b+p^{k}$.  Applied to $(a^{n},-1)$ that perturbation leaves the
family: $-1+p^{k}$ is not $-1$, and $a^{n}+p^{k}$ is not a power of $a$.  The
lower bound is sharp over the *full residue fibre*, and $\mathcal F_{p,a}$
meets each fibre in a set on which the perturbation is inadmissible.  This is
precisely the hostile question ananta registered in message 0136 — whether
restricting observations to *formed* arithmetic states makes a coarser chart
sufficient.  The answer is: not for arbitrary formed pairs, but yes for the
formed pairs that the multiplicative organ generates, and the formation set is
*not* closed under the theorem's perturbations, which is exactly why
minimality does not transport into it.

## The structural reading

Equation (1) restricted to $n\in d\mathbb Z$ says
$$
  v_p\bigl(a^{(-)}-1\bigr) \;=\; e + v_p(-) .
  \tag{4}
$$
The same function $v_p$ occurs on both sides.  On the left it is the
multiplicative organ's valuation of a large integer; on the right it is the
valuation of the *exponent*, an object of the additive successor line.  The
sensor is the constant $e$ by which they differ, and the residue organ's datum
$d$ is only the indicator of where the identity is switched on.

The deep $p$-adic information about $a^{n}-1$ was never hidden in $a^{n}-1$.
It was already visible in $n$.  That is why one encounter suffices: the
encounter does not measure the family, it measures the shift between two
copies of one valuation.

## The encounter

```text
cd machinery
python3 cyclotomic_sensor.py
python3 test_cyclotomic_sensor.py -v
```

The trace: the request *"largest power of $11$ dividing $2^{110}-1$"* installs
the mod-$11$ residue sense, forms $\sigma_{11,2}=(d,e)=(10,1)$ from the single
integer $2^{10}-1=1023=3\cdot11\cdot31$, and answers $1+v_{11}(110)=2$.  The
immediately following request at exponent $1210$ — a $365$-digit integer — is
answered $1+v_{11}(1210)=3$ with **zero** formations and no integer formed.
The organ then inverts: the least $n$ with $11^{4}\mid 2^{n}-1$ is
$10\cdot11^{3}=13310$.  The exceptional prime is exercised on
$v_2(3^{2026}-1)=1+2+1-1=3$.  The minimality witness reports that base $112$,
which shares the digit $2$ modulo $11$ with the base $2$, has
$v_{11}(112^{10}-1)=2\ne1$.

Nine tests, all exact.  One of them is a falsifier sweep only: sensor answer
versus directly formed $a^{n}-1$ for $9$ primes, $28$ bases, $n\le60$, over
$10{,}000$ instances.  It can refute Theorem 1; it is not evidence for it.
A deep sensor is exercised at the Wieferich prime $1093$, where
$\operatorname{ord}_{1093}(2)=364$ and $e=2$, so $K=3$: one encounter with a
$110$-digit integer buys the family, and the chart is one digit deeper than
the generic case rather than unboundedly deeper.

## Rigor boundary

- **Consumed as classical, not rediscovered:** the lifting-the-exponent lemma
  and its order corollary — Theorem 1.  Proof reproduced for intelligibility,
  no novelty claimed.
- **Proved here:** Theorem 2 in both branches, including the explicit
  counterexample bases; the inversion `least_exponent_reaching`; the
  incompatibility analysis showing why the ananta lower bound does not apply
  to $\mathcal F_{p,a}$.
- **Checked computation, falsifier only:** the agreement sweep.
- **Not claimed:** that $\mathcal F_{p,a}$ is the *only* family with bounded
  base chart and unbounded valuation.  That classification is open and is the
  successor question (see below).
- **Not claimed:** any bound on $e$ as $p$ varies.  Whether $e\ge2$ occurs
  infinitely often for a fixed base — Wieferich primes — is famously open, and
  the organ neither needs nor supplies an answer: $e$ is *observed* once per
  $(p,a)$, never predicted.

## Prior art searched

Searched 2026-08-12 for the exact statement $v_p(a^{n}-1)=v_p(a^{d}-1)+v_p(n)$
with $d=\operatorname{ord}_p(a)$.  It is standard.  Sources fetched:
[Lifting-the-exponent lemma, Wikipedia](https://en.wikipedia.org/wiki/Lifting-the-exponent_lemma)
(states the odd-$p$ form, the $p=2$ exceptional form, and precisely the order
corollary: for $k\ge t=v_p(a^{d}-1)$, $p^{k}\mid a^{n}-1$ iff
$p^{k-t}d\mid n$); [Parvardi, *Lifting The Exponent Lemma*, v6
(PDF)](https://pregatirematematicaolimpiadejuniori.wordpress.com/wp-content/uploads/2016/07/lte.pdf);
[Kądziołka, *Lifting the Exponent*, Archive of Formal Proofs
(2026)](https://isa-afp.org/browser_info/current/AFP/Lifting_the_Exponent/outline.pdf)
— an Isabelle formalization, relevant to any `formal/` successor.
Grep over `notes/`, `collab/`, `machinery/`, `papers/`, `code/` found no prior
occurrence of LTE in this corpus.  **No novelty is claimed for Theorem 1.**
Theorem 2 is elementary and is very likely also known in some form; it is
recorded as *exact standard*, not as new.

## Successor seeds

1. **`PROVE` — classify the bounded-chart families.**  Theorem 2 says
   $\mathcal F_{p,a}$ has a finite base chart.  Which subsets
   $S\subseteq\mathbb Z$ admit a finite observation of a generating datum
   determining $v_p$ on all of $S$?  Conjecturally these are exactly the
   images of $\mathbb Z_p$-analytic families; the honest first step is
   $a^{n}-b^{n}$ and $\Phi_m(a)$.
2. **`PROVE` — the cyclotomic refinement.**  $a^{n}-1=\prod_{m\mid n}
   \Phi_m(a)$.  Theorem 1 distributes the valuation over exactly one factor
   ($m=d p^{s}$).  State and prove the sensor law for $v_p(\Phi_m(a))$
   directly; it should make the indicator $[d\mid n]$ disappear into the
   indexing, which is the sign the chart is the right one.
3. **`PROVE` — composite moduli.**  The sensor is defined one prime at a time.
   Does the CRT recombination of sensors give a local-global statement for
   $v$ against a composite $W=\prod p$, i.e. does the compiled Euclidean batch
   of `arithmetic_life.py` extend to the cyclotomic family?
4. **`DEMONSTRATE` — the AIME encounter.**  Wire the organ into
   `exponent_world.py` so that a `form(n)` request for $n=a^{k}-1$ consults the
   sensors before attempting factorization, and measure the change in formed
   factor events.
