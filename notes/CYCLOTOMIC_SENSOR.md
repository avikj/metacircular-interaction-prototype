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

## The chart behind the law: the indicator dissolves

Equation (4) explains the *shift*, but Theorem 1 still carries two blemishes:
an indicator $[d\mid n]$, and a separate $p=2$ case with a stray $-1$.  Both
are artifacts of the wrong coordinates.  Factor the family:
$$
  a^{n}-1=\prod_{m\mid n}\Phi_m(a),
  \qquad\text{so}\qquad
  v_p(a^{n}-1)=\sum_{m\mid n} v_p\bigl(\Phi_m(a)\bigr).
  \tag{5}
$$

> **Theorem 3 (chain law).**  Let $p$ be a prime, $p\nmid a$, and set
> $d=\operatorname{ord}_p(a)$ for odd $p$ and $d=1$ for $p=2$.  Define the
> *$p$-chain* $C_{p,a}=\{\,d p^{s} : s\ge0\,\}$ and the *head*
> $$
>   H_{p,a}=\begin{cases}(e), & p \text{ odd},\\ (e_-,e_+), & p=2.\end{cases}
> $$
> Then $v_p(\Phi_m(a))=0$ for every $m\notin C_{p,a}$, and along the chain
> $$
>   v_p\bigl(\Phi_{d p^{s}}(a)\bigr)=
>   \begin{cases} H_{p,a}[s], & s<|H_{p,a}|,\\ 1, & s\ge|H_{p,a}|.\end{cases}
>   \tag{6}
> $$

*Proof (odd $p$).*  If $d\nmid m$ then $v_p(a^{m}-1)=0$ by Theorem 1, and
$\Phi_m(a)\mid a^{m}-1$, so $v_p(\Phi_m(a))=0$.  For $m\mid d$ with $m<d$ the
same argument gives $0$, so (5) at $n=d$ leaves $v_p(\Phi_d(a))=e$.  For
$s\ge1$, subtract (5) at $n=dp^{s-1}$ from (5) at $n=dp^{s}$: the divisors of
$dp^{s}$ that do not divide $dp^{s-1}$ are exactly $d'p^{s}$ with $d'\mid d$,
and each with $d'<d$ contributes $0$ because $p\nmid d$ forces
$d\nmid d'p^{s}$.  The difference of left-hand sides is
$(e+s)-(e+s-1)=1$, so $v_p(\Phi_{dp^{s}}(a))=1$.  Finally, for general
$n=dp^{t}k$ with $p\nmid k$, the terms already accounted for sum to $e+t$,
which is all of $v_p(a^{n}-1)$; since every remaining term is $\ge0$, they all
vanish.

*Proof ($p=2$).*  $\Phi_1(a)=a-1$ and $\Phi_2(a)=a+1$ give the head directly.
For $s\ge2$, $\Phi_{2^{s}}(a)=a^{2^{s-1}}+1$, and $a^{2^{s-1}}$ is an odd
square, hence $\equiv1\pmod 8$, so $v_2=1$.  Off the chain, $m=2^{s}k$ with
$k>1$ odd: the chain terms already sum to $v_2(a^{n}-1)$ by (2), and
nonnegativity kills the rest.  $\square$

Now read the two blemishes off the chart.

- **The indicator is the chain's support.**  $[d\mid n]$ was never a case
  split; it is the statement that $v_p$ is *supported on one chain*.  A
  question about $n$ becomes: which chain elements divide $n$?
- **The shift $v_p(n)$ is a count.**  For $d\mid n$,
  $\#\{s\ge1 : dp^{s}\mid n\}=v_p(n)$.  Each chain step past the head
  contributes exactly one factor of $p$, so the $p$-adic valuation of the
  *exponent* is literally the number of chain steps taken.  Equation (4) is
  no longer a coincidence between two copies of $v_p$; it is a count of the
  same steps performed twice.
- **$p=2$ is not exceptional.**  Its head is two entries long instead of one.
  The stray $-1$ in (2) is bookkeeping: $v_2(n)=t$ names the $t+1$ chain
  elements $1,2,\dots,2^{t}$, of which $2$ are head entries, leaving $t-1$
  ones.  The exception was an artifact of compressing a length-two head into
  a length-one formula.

So the **cyclotomic sensor is exactly a chain plus a finite head**, and the
head has length $1$ or $2$.  Nothing else is stored, and Theorem 2's chart
depth is the cost of observing the head.

The falsifier: `cyclotomic_valuation` versus exact integer $\Phi_m(a)$ computed
by the Möbius product, for $6$ primes, $18$ bases, $m\le49$ — and the
reassembly test summing (6) over divisors back to Theorem 1 for $n\le89$.
Both green; both can only refute.

## The head length is the torsion of the unit filtration

Theorem 3 left one residual: the head has length $1$ at odd $p$ and $2$ at
$p=2$, and I had no formula for the length.  It has one, and the formula
explains rather than records.

Work in $\mathbb Z_p^{\times}$ with the unit filtration
$U_k=1+p^{k}\mathbb Z_p$.  Everything in Theorem 1's proof was one step:

> **Lemma (shift).**  Let $k\ge1$ and $x\in U_k\setminus U_{k+1}$.  If $p$ is
> odd, or if $p=2$ and $k\ge2$, then $x^{p}\in U_{k+1}\setminus U_{k+2}$, i.e.
> $v_p(x^{p}-1)=v_p(x-1)+1$ exactly.

*Proof.*  Write $x=1+t$, $v_p(t)=k$.  Then
$x^{p}-1=pt+\binom p2 t^{2}+\dots+t^{p}$.  The first term has valuation
$k+1$.  For odd $p$: $v_p(\binom p2 t^{2})\ge 1+2k\ge k+2$ and
$v_p(t^{p})=pk\ge k+2$ because $(p-1)k\ge2$.  For $p=2$ the expansion is
$2t+t^{2}$ with $v_2(t^{2})=2k\ge k+2$ exactly when $k\ge2$.  $\square$

At $p=2$, $k=1$ the two terms $2t$ and $t^{2}$ both have valuation $2$ and the
lemma fails.  It fails for a *reason*, and the reason is an element:

$$
  -1\ \in\ U_1\setminus U_2,\qquad (-1)^{2}=1 .
$$

The shift law cannot hold at $k=1$ because $-1$ has finite order.  $U_1$ is
not torsion-free at $p=2$, and $U_2$ is.  So:

> **Theorem 4 (head length).**  The head length of the cyclotomic sensor is
> the least $k_0\ge1$ with $U_{k_0}$ torsion-free, namely
> $$
>   |H_{p,a}| = \Bigl\lfloor \tfrac{1}{p-1}\Bigr\rfloor + 1
>   =\begin{cases}1, & p \text{ odd},\\ 2, & p=2.\end{cases}
>   \tag{7}
> $$
> It depends on $p$ only, never on $a$: the head is exactly the segment of the
> chain traversed before the filtration starts shifting by one, and that
> segment is as long as the $p$-power torsion of $\mathbb Z_p^{\times}$ forces
> it to be.

The classical fact behind (7) is that $U_k$ is torsion-free precisely when
$k>e/(p-1)$, $e$ the absolute ramification index — the same threshold that
makes $\log$ and $\exp$ inverse bijections $U_k\to p^{k}\mathcal O$.  Over
$\mathbb Q_p$, $e=1$, so the threshold is $k>1/(p-1)$: vacuous for odd $p$,
binding exactly at $p=2$, where $\mu_{2}=\{\pm1\}\subset\mathbb Q_2$ is the
only $p$-power root of unity a $p$-adic field gets for free.

So the residual dissolves completely, and the AIME-level irritation *"LTE has
a weird case at $p=2$"* turns out to be the sentence *"$-1$ is a $p$-th root
of unity in $\mathbb Q_p$ exactly when $p=2$."*  Those are the same fact.

**Prediction, not verified here.**  Over a local field $K/\mathbb Q_p$ with
absolute ramification index $e_K$, the same argument gives head length
$\lfloor e_K/(p-1)\rfloor+1$, which is $>1$ for *odd* $p$ as soon as
$e_K\ge p-1$ — for instance $K=\mathbb Q_p(\zeta_p)$.  This corpus has no
local-field machinery, so the statement is recorded as a derived consequence
of standard theory and is **not** tested.  It is the first place the sensor
would need a genuinely new organ rather than an integer pair.

## Reading the chain backwards: the machine names its own primes

Everything above answers *"given $p$, what is $v_p$?"*.  Sitting down at the
executable as a learner exposes the dead spot immediately: **you have to
already know which prime to ask about.**  Handed $2^{23}-1$ cold, the organ has
nothing to say, which is exactly the situation an actual problem presents.

The chain law read backwards fixes this, and it needs no new mathematics.
$p\mid\Phi_m(a)$ means $v_p(\Phi_m(a))\ge1$, which by Theorem 3 means $m$ lies
on $p$'s chain.  That is a strong constraint *on $p$*, not on $m$.

> **Theorem 5 (prime naming).**  Let $m\ge1$ and let $p$ be a prime with
> $p\mid\Phi_m(a)$.  Then exactly one of:
> 1. $\operatorname{ord}_p(a)=m$ — *primitive* — and then $m\mid p-1$; if
>    moreover $m>1$ is odd, then $2m\mid p-1$;
> 2. $p$ is the **largest prime factor of $m$** — *exceptional* — and then
>    $v_p(\Phi_m(a))=1$, the sole carve-out being $(p,m)=(2,2)$.

*Proof.*  By Theorem 3, $m=dp^{s}$ with $d=\operatorname{ord}_p(a)$ (and $d=1$
at $p=2$).  If $s=0$ then $m=d=\operatorname{ord}_p(a)$, so $m\mid p-1$.  If in
addition $m>1$ is odd then $p$ is odd — for $p=2$ forces $d=1$, hence
$m=2^{s}$, impossible for odd $m>1$ — so $2\mid p-1$; as $\gcd(2,m)=1$ this
gives $2m\mid p-1$.  If $s\ge1$ then $p\mid m$, and $d\mid p-1$ makes every
prime factor of $d$ smaller than $p$; since $m=dp^{s}$, $p$ is the largest
prime factor of $m$.  The valuation is the chain entry $H[s]$, which is $1$
whenever $s\ge|H|$; by Theorem 4, $|H|=1$ for odd $p$ and $2$ for $p=2$, so the
only $s\ge1$ with $s<|H|$ is $p=2,s=1$, i.e. $m=2$.  $\square$

The three theorems are now doing one job.  Theorem 3 gives the chain, Theorem 4
gives its head length, and Theorem 5 is the same statement with the quantifier
turned around: *the chain constrains $p$ as tightly as it constrains $m$.*

**What this changes in the next action.**  To factor $\Phi_m(a)$ by trial
division, the candidate set drops from every integer to a single residue class:
$$
  p\equiv 1 \pmod{2m}\ (m>1 \text{ odd}),\qquad
  p\equiv 1 \pmod{m}\ (m \text{ even}),
$$
plus one explicit exceptional candidate.  At a common search bound the guided
scan tests $\lfloor B/2m\rfloor$ candidates where the blind scan tests
$\lfloor B/2\rfloor$: a factor of exactly $m$, derived, not measured.
Equivalently, at a common *budget* the guided scan reaches $m$ times further
along the number line.  (Dirichlet then says the class contains the expected
density of primes, but no density statement is needed for the exact count.)

$2047=\Phi_{11}(2)$: try $23,45,67,89,\dots$, and $23$ divides at once —
$2047=23\cdot 89$, both $\equiv1\bmod22$.  This is the difference between a
learner who can factor $2^{11}-1$ by hand and one who cannot.

**Honest limits, executed rather than asserted.**  The organ reduces the search
space by $m$; it does not make factoring easy, and it must not pretend to.
`factor_cyclotomic` carries a budget, and an exhausted budget returns a typed
incomplete answer carrying the surviving cofactor — never a silently truncated
factorization.  On $\Phi_{31}(10)$ (31 digits) with $150{,}000$ trial divisions
each, the guided scan returns $2791$ and $6943319$ and the blind scan returns
only $2791$; both report themselves incomplete, and the guided cofactor
multiplies back exactly.

## Routing the integer: two independent gains

Theorem 5 gave the organ prime candidates, and sitting down again exposed the
next dead spot at once.  A learner is not handed $\Phi_m(a)$.  A learner is
handed **a number**.  Asked to factor $2^{35}-1$, the machine had two organs
that were strangers: `arithmetic_life` ground out $16{,}777$ prime sensors up
to $185{,}363$ to find a single factor, while the cyclotomic organ sitting in
the same process already knew that every prime factor lies in one of four
sparse progressions.

The route is $a^{n}-1=\prod_{m\mid n}\Phi_m(a)$: factor the pieces, not the
number.  What makes this worth a theorem rather than a refactor is that it
carries **two independent gains**, and only one of them is Theorem 5.

> **Theorem 6 (degree and congruence).**  Let $a\ge2$, $n\ge1$,
> $N=a^{n}-1$.
> 1. *(degree)* For every $m\mid n$, $\varphi(m)\le\varphi(n)$ and
>    $(a-1)^{\varphi(m)}\le\Phi_m(a)\le(a+1)^{\varphi(m)}$.  So the deepest
>    candidate any piece requires is $a^{\varphi(n)/2}$ up to a factor
>    $(1\pm1/a)^{\varphi(n)/2}$, where scanning $N$ head-on requires
>    $a^{n/2}$.  The reduction is $a^{(n-\varphi(n))/2}$.
> 2. *(congruence)* Inside each piece, Theorem 5 confines the scan to one
>    residue class, dividing the candidate count by a further $m$.
>
> The two are independent: (1) is the degree drop of the cyclotomic
> factorization and holds even with no congruence information; (2) is the
> congruence and holds even at $m=n$ where (1) gives nothing.

*Proof.*  $\Phi_m(a)=\prod_{\zeta}(a-\zeta)$ over primitive $m$-th roots of
unity, so $(a-1)^{\varphi(m)}\le|\Phi_m(a)|\le(a+1)^{\varphi(m)}$ termwise.
$\varphi(m)\mid\varphi(n)$ for $m\mid n$, hence $\varphi(m)\le\varphi(n)$.  The
count statement is Theorem 5.  $\square$

**The route helps exactly when $n$ is composite, and the theorem says so.**
$n-\varphi(n)=1$ precisely when $n$ is prime, so for prime exponents gain (1)
is a factor of $\sqrt a$ — nothing.  For $n=60$, $\varphi(60)=16$ and the
reduction is $2^{22}$.  This is not a hope about hard cases; it is a computed
number that the executable reports per encounter, with its own negative
control built in:

| $a^{n}-1$ | blind bound | routed bound | trial divisions | complete |
|---|---|---|---|---|
| $2^{23}-1$ | $2896$ | $2896$ | $10$ | yes |
| $2^{35}-1$ | $185{,}363$ | $2954$ | $7$ | yes |
| $2^{36}-1$ | $262{,}143$ | $63$ | $9$ | yes |
| $2^{60}-1$ | $1{,}073{,}741{,}823$ | $283$ | $12$ | yes |
| $10^{12}-1$ | $999{,}999$ | $99$ | $20$ | yes |

The first row is the control: $23$ is prime, and the bound does not move.
The fourth row is the whole point — $2^{60}-1$, nineteen digits, factored
completely into eleven primes in **twelve trial divisions**.

## The loop closes

`ArithmeticLife` was built to *accumulate prime sensors*, one grind at a time,
and `CyclotomicOrgan.form` is gated on having earned one.  So routing does not
merely answer faster; it feeds the organ that gates it.

```text
factor 2^60 - 1   →  v_1321 is REFUSED (no earned mod-1321 sense)
                  ↓  route through Phi_m, 12 trial divisions
                  →  1321 installed as an earned sensor
                  →  v_1321(2^n - 1) answerable for EVERY n
                     ord_1321(2) = 60, so v_1321(2^79260 - 1) = 2
```

A prime the blind organ would have reached only after a $10^{9}$-deep grind is
earned in twelve divisions, and with it an infinite family of valuations that
the machine refused to discuss one step earlier.  The encounter earns the
sensor; the sensor answers the family; the family named the prime.  That is
the first place in this note where the three theorems close on each other
rather than stacking.

## The organ chooses: guaranteed acquisition

Third sitting, and the dead spot this time is not an answer the machine gets
wrong.  It is that **every encounter is proposed by me.**  I asked the organ
for a new prime sensor and it had no operation that could suggest one.  So I
guessed:

```text
route(2, 13)  ->  earned 8191
route(2,  6)  ->  earned nothing
route(2, 18)  ->  earned 19, 73
```

The machine had walked into exponent $6$, paid for it, and received nothing —
with no way to know in advance, and no memory that would stop it repeating.
And $(a,n)=(2,6)$ is not a random miss: it is *the* classical exception in
Zsigmondy's theorem.  The organ's own Theorem 5 decides it in three lines.

Call a prime $p$ a **primitive** divisor of $\Phi_n(a)$ when
$\operatorname{ord}_p(a)=n$.  Such a $p$ divides no $a^{k}-1$ with $k<n$, so it
is genuinely new relative to every earlier encounter with this base.

> **Theorem 7 (guaranteed acquisition).**  Let $a\ge2$, $n\ge1$, and let $P$ be
> the largest prime factor of $n$ (none for $n=1$).  Then $\Phi_n(a)$ has **no**
> primitive prime divisor if and only if
> $$
>   \Phi_n(a)\in\{1,P\},
> $$
> except at $n=2$, where the condition is that $\Phi_2(a)=a+1$ be a power of
> $2$.

*Proof.*  By Theorem 5 every prime divisor of $\Phi_n(a)$ is primitive or
equals $P$, and in the latter case $v_P(\Phi_n(a))=1$ unless $(P,n)=(2,2)$.
So if no primitive divisor exists, $\Phi_n(a)$ is a power of $P$ with exponent
at most $1$ — that is, $1$ or $P$ — with the single carve-out $n=2$, where the
exceptional prime is $2$ and the head has length two, permitting $a+1=2^{k}$.
For $n=1$ there is no exceptional prime at all, so every divisor is primitive
and the only failure is $\Phi_1(a)=a-1=1$.  $\square$

Two things make this the right kind of statement.

**It is decidable without factoring.**  The test compares $\Phi_n(a)$ against a
number no larger than $n$.  The organ never factors anything to decide whether
an encounter is worth paying for; it decides first and pays second.

**It reproduces the classical exception list, derived rather than looked up.**
Sweeping $2\le a\le19$, $1\le n\le18$ and comparing the criterion against an
actual search for a primitive divisor gives zero mismatches and exactly
$$
  (a,n)\in\{(2,1),\ (2,6)\}\ \cup\ \{(a,2): a+1 \text{ a power of }2\},
$$
which is Bang's and Zsigmondy's list.  The famous exception $(2,6)$ appears
here as the sentence $\Phi_6(2)=3=P$: the only prime available was the
exceptional one.  That the chain law lands exactly on the classical exceptions
is the strongest evidence so far that it is the right object, because the
exceptions were never fitted — they are what the criterion says when it says
"nothing here".

## Declining is the point

`CyclotomicOrgan.propose_encounter(a)` returns the least exponent not yet
covered whose encounter is *guaranteed* to earn a prime the organ cannot
already hold.  Run from an empty organ at $a=2$:

```text
proposed n =  2  ->  new prime 3
proposed n =  3  ->  new prime 7
proposed n =  4  ->  new prime 5
proposed n =  5  ->  new prime 31
proposed n =  7  ->  new prime 127
proposed n =  8  ->  new prime 17
proposed n =  9  ->  new prime 73
proposed n = 10  ->  new prime 11
proposed n = 11  ->  new primes 23, 89
```

Nine encounters, nine acquisitions, no waste.  $n=1$ and $n=6$ are never
proposed, and each is declined for a stated reason it can print.

This is the first operation in the organ that **chooses** rather than answers,
and what makes it a choice is the refusal.  An organ that accepts every
encounter is not selecting; it is being fed.  The mathematical content of the
agency is entirely in the negative case — the cases where the theorem says
*do not bother* — and those cases are exactly the classical exceptions.

## The organ was promising what it could not deliver

Fourth sitting.  The organ chooses now, so I let it choose repeatedly and
watched whether its guarantee survived.  It does not.  Force it to the frontier
and it proposes $n=61$, spends its entire budget of $200{,}000$ trial
divisions, and earns **nothing**:

```text
organ proposes n = 61 ; primitive divisor exists? True
  delivered factors: ()   complete = False
  cofactor: 2305843009213693951
```

The primitive prime is $2^{61}-1$ itself, sitting in the cofactor unrecognised.
Theorem 7's guarantee is about **existence**; the routing's delivery is about
**budget**; and the organ had conflated them.  It promised, failed, and said
nothing about the failure beyond a boolean.

The repair needs a second refusal, and to state it I need a lower bound on
$\Phi_n(a)$ that the earlier $(a-1)^{\varphi(n)}$ cannot give at $a=2$.

> **Lemma.**  For every $a\ge2$ and $n\ge1$,
> $$\Phi_n(a) \;>\; \frac{a^{\varphi(n)}}{8}.$$

*Proof.*  $\Phi_n(a)=\prod_{d\mid n}(a^{d}-1)^{\mu(n/d)}$, so
$$
  \log\Phi_n(a)=\sum_{d\mid n}\mu(n/d)\bigl[d\log a+\log(1-a^{-d})\bigr]
  =\varphi(n)\log a+\sum_{d\mid n}\mu(n/d)\log(1-a^{-d}),
$$
using $\sum_{d\mid n}\mu(n/d)\,d=\varphi(n)$.  Since $a\ge2$ gives
$a^{-d}\le\tfrac12$, and $|\log(1-x)|\le 2x$ on $[0,\tfrac12]$, the tail is
bounded by $\sum_{d\ge1}2a^{-d}=2/(a-1)\le2$.  Hence
$\Phi_n(a)\ge a^{\varphi(n)}e^{-2}>a^{\varphi(n)}/8$.  $\square$

This is the bound the earlier sections wanted and did not have: it is
non-vacuous at $a=2$, where $(a-1)^{\varphi(n)}=1$ says nothing.

> **Theorem 8 (affordable horizon).**  Fix $a\ge2$ and a budget $B$ of trial
> divisions.  The guided scan of $\Phi_n(a)$ is guaranteed to finish when
> $\sqrt{\Phi_n(a)}/\mathrm{step}(n)\le B$.  Since
> $\mathrm{step}(n)\le 2n$ and $\Phi_n(a)>a^{\varphi(n)}/8$, this forces
> $$
>   \varphi(n)\,\log a \;\le\; 2\log(6nB).
>   \tag{8}
> $$
> Because $\varphi(n)\ge\sqrt n$ for $n>6$, (8) fails for all large $n$, so
> **the affordable set is finite** and an explicit bound is the least
> $N>(4/\log a)^{2}$ with $\sqrt N\log a>2\log(6NB)$ — past that point the gap
> is increasing, so the search for the horizon terminates with a proof rather
> than at a chosen cutoff.

## The horizon is a sublevel set of $\varphi$, not an interval

This is the part I did not expect.  At $a=2$, $B=200{,}000$ the proved bound is
$N=4151$, and inside it exactly $101$ exponents are affordable — the largest
being $\mathbf{210}$.  Meanwhile $61$ is **not** affordable.

| $n$ | $\varphi(n)$ | worst-case candidates | affordable? |
|---|---|---|---|
| $53$ | $52$ | $895{,}344$ | no |
| $61$ | $60$ | $12{,}446{,}725$ | no |
| $210$ | $48$ | $70{,}535$ | yes |

So the organ's reachable world is not bounded by *size*.  $2^{210}-1$ has $64$
digits and $2^{61}-1$ has $19$, and the big one is the reachable one.  What
bounds the horizon is $\varphi(n)$: the reachable set is a sublevel set
$\{\,n:\varphi(n)\lesssim 2\log(6nB)/\log a\,\}$, and $\varphi$ is small exactly
at the highly composite $n$.  An organ with a fixed budget can see arbitrarily
far out along the smooth exponents and is walled off from the primes.

That inverts the naive picture of a growing frontier.  The machine does not
run out of reach gradually; it runs out along one direction (prime and
near-prime exponents) while remaining wide open along another.

## Two refusals, kept apart

`refusal(a, n, B)` returns the reason or `None`, and there are now exactly two
kinds, each licensed by a theorem:

```text
n =   6 -> Phi_6(2) = 3 = the largest prime factor of 6: every prime here is
           the exceptional one, so nothing is primitive     (Theorem 7)
n =  61 -> a primitive prime exists but is not reachable: the guided scan
           needs up to 12446725 trial divisions, budget is 200000 (Theorem 8)
n = 210 -> None
```

Merging them would be the same defect as the crystal runtime's merged
`UNORIENTABLE`/`EXHAUSTED` (`machinery/crystal/README.md`): one says *there is
nothing here*, the other says *there is something here and I cannot reach it*,
and only the second is repaired by a larger budget.  Keeping them apart is
what makes the horizon a statement about this organ rather than about
arithmetic.

## What a bigger budget buys: the law, and the stair

Fifth sitting.  The organ knows its horizon, so I asked it the question that
follows: *if I double my budget, how much further do I see?*

```text
B = 200000  reachable = 101
B = 400000  reachable = 101
```

Nothing.  And the organ could say nothing about why, or what would help — it
had a count and no law, which is precisely the debt I filed against myself in
the previous section.  Two repairs are needed, and they are different in kind:
the asymptotic law, and the exact next stair.

### The law

The affordable set is $\{n:\varphi(n)\le x_B\}$.  Two inputs pin $x_B$.

First, the lemma's proof gives more than the lemma.  The tail bound was
two-sided all along:
$$
  \bigl|\log\Phi_n(a)-\varphi(n)\log a\bigr| \;\le\; \frac{2}{a-1},
  \tag{9}
$$
an **absolute** constant, independent of $n$.  So affordability,
$\sqrt{\Phi_n(a)}/\mathrm{step}(n)\le B$, reads
$\varphi(n)\log a\le 2\log B+2\log \mathrm{step}(n)+O(1)$, and since
$\mathrm{step}(n)\le 2n$ with $n\le x_B^{2}$,
$$
  x_B=\frac{2\log B}{\log a}\bigl(1+o(1)\bigr).
$$

Second, the density of totient values is classical:
$\#\{n:\varphi(n)\le x\}\sim Ax$ with
$A=\zeta(2)\zeta(3)/\zeta(6)=1.9435964\ldots$

> **Theorem 9 (reachable count).**  For fixed $a\ge2$, as $B\to\infty$,
> $$
>   \#\{\text{reachable }n\}\;=\;\frac{2A}{\log a}\,\log B\,\bigl(1+o(1)\bigr),
> $$
> and inverting, the budget required for $k$ reachable exponents is
> $B=a^{\,k/2A+o(k)}$.  **Each additional exponent costs a fixed multiplicative
> factor $a^{1/2A}$ of budget** — about $1.195$ at $a=2$.

The organ's world grows *logarithmically* in what it can spend.  That is the
honest reading of the horizon, and it is a statement about the machine, not
about arithmetic.

**Falsifier, and nothing fitted.**  The derived slope at $a=2$ is
$2A\log 10/\log 2 = 12.913$ reachable exponents per decade of budget.
Computed over twelve decades, $10^{2}$ to $10^{14}$: $53\to213$, a slope of
$13.33$.  Three percent.  The constant $A$ is derived from the totient density
and the $2/\log a$ from (9); the sweep can only refute them.

### The stair

The law is smooth.  The organ's experience is a staircase, because $\varphi$
takes values in a sparse set.  `next_budget_step` returns the exact height of
the next stair and what it buys:

| current $B$ | next stair | factor | buys |
|---|---|---|---|
| $200{,}000$ | $516{,}928$ | $2.58\times$ | $n=106$ |
| $600{,}000$ | $828{,}506$ | $1.38\times$ | $n=81$ |
| $2{,}000{,}000$ | $2{,}069{,}794$ | $1.03\times$ | $n=116$ |

So the honest answer to *"should I double?"* is **no — you need $2.58\times$,
and it buys exponent 106.**  The treads scatter around the derived average
factor $1.195$ exactly as a staircase around its secant.

The search for the cheapest unreachable encounter is bounded by a theorem
rather than a guess: any encounter costing at most $C$ satisfies
$\varphi(n)\log a\le2\log(6nC)$, hence lies below
$\texttt{acquisition\_horizon}(a,C)$, and the executable checks that its
answer's own horizon fits inside the ceiling it searched.

### Why 106 and not 53

The cheapest next stair at $B=200{,}000$ is index $106$, not the smaller $53$,
and the reason is exact.  For odd $m>1$, $\Phi_{2m}(x)=\Phi_m(-x)$, so
$$
  \Phi_{106}(2)=\Phi_{53}(-2)=\frac{2^{53}+1}{3},
  \qquad
  \Phi_{53}(2)=2^{53}-1 .
$$
The same degree $\varphi=52$, the same progression modulus $106$, and a factor
$3$ smaller — hence a scan bound smaller by exactly $\sqrt3$, and
$895{,}344/516{,}928=1.7320\ldots$  The organ's cheapest next acquisition is
determined by a reflection identity, not by size ordering.

## Two bases: a no-go, and the operation that survives it

Five successive successor lists ended at the same unclaimed item — *how do the
chains for two bases interact?* — and the sixth sitting finally forced it.  I
worked base $2$ until the organ held $\{3,5,7,11,17,31,73,127\}$, then asked
it about base $3$:

```text
route(3, 4)  ->  Phi_4(3) = 10 = 2 * 5   genuinely new: []
```

Nothing.  $5$ was already held from base $2$, where $\operatorname{ord}_5(2)=4$
— and the organ had no way to know, because **every guarantee in this note has
been per base.**  Theorem 7 promises a prime primitive for *this* base; it says
nothing about the organ's other holdings.

### The obstruction is real and exact

The natural hope is that the sensor at $p$ for base $ab$ is built from the
sensors for $a$ and $b$.  It is not.

> **Theorem 10 (no composition in the base).**  $\operatorname{ord}_p(ab)$ is
> not a function of $\bigl(\operatorname{ord}_p(a),\operatorname{ord}_p(b)\bigr)$.

*Witness at $p=7$.*  $\operatorname{ord}_7(2)=3$ and $\operatorname{ord}_7(4)=3$,
while $2\cdot4=8\equiv1$, so $\operatorname{ord}_7(2\cdot4)=1$.  But
$\operatorname{ord}_7(2)=3$ and $\operatorname{ord}_7(2)=3$ with
$2\cdot2=4$ give $\operatorname{ord}_7(4)=3$.  Same order pair $(3,3)$, product
orders $1$ and $3$.  $\square$

The executable searches for such a witness at any prime rather than quoting
one, and finds them at $7,11,13,17,19$.  So the multi-base question that five
packets deferred has a **clean negative answer**: sensors do not compose
multiplicatively in the base, and no bookkeeping will make them.

That kills the route I had been holding open — and it is worth more than
another chart, because it is the first genuine no-go in this lane.

### What survives: transport, not composition

The obstruction is to *composing* sensors.  It is not an obstruction to
*computing* them, and the difference is the whole repair.

If the organ holds $p$, then $\operatorname{ord}_p(b)$ is cheap — one order
computation modulo a prime it already has.  So the organ can map its entire
history into the new base's exponent coordinates before spending anything:

> A held prime $p$ is a primitive divisor of $\Phi_m(b)$ exactly when
> $\operatorname{ord}_p(b)=m$.

Each held prime is therefore re-delivered by **exactly one** exponent of the
new base, and the organ can name it.  For the holdings above, transported into
base $3$:

| base-3 exponent | held primes it re-delivers | residual | fresh? |
|---|---|---|---|
| $4$ | $5$ | $1$ | no |
| $5$ | $11$ | $1$ | no |
| $6$ | $7$ | $1$ | no |
| $12$ | $73$ | $1$ | no |
| $16$ | $17$ | $193$ | **yes** |

### Theorem 11: freshness decided without factoring

> **Theorem 11 (fresh acquisition).**  Let $H=\{p \text{ held}:
> \operatorname{ord}_p(b)=m\}$ and put
> $$
>   R \;=\; \Phi_m(b)\Big/\Bigl(P^{\,v_P}\prod_{p\in H}p^{\,e_p}\Bigr),
> $$
> where $e_p=v_p(\Phi_m(b))$ is read off $p$'s own chain head and $P$ is the
> largest prime factor of $m$.  Then $\Phi_m(b)$ has a primitive prime divisor
> the organ does **not** hold if and only if $R>1$.

*Proof.*  By Theorem 5 every prime divisor of $\Phi_m(b)$ is primitive or is
$P$.  The held primitive ones are exactly $H$, each occurring to the power
$e_p$ by Theorem 3's head.  Dividing them and the $P$-part out leaves precisely
the unheld primitive part.  $\square$

Nothing is factored.  $H$ comes from orders modulo primes already held, the
~~$e_p$ come from sensors already formed~~, and $P$ comes from $m$.

> **Correction applied in place — SEED-119, 2026-08-14, Rule K3, executing
> `notes/SEED89_THE_LONG_COUNT_REPAIR.md` §8 item 3 and carrying
> `notes/SEED78_THE_CYCLOTOMIC_COMMA.md` §4's repair to its site. Neither had
> been applied here; the arithmetic below was re-checked by hand before
> striking.**
>
> **The defect.** $e_p$ is **base-dependent**, so a head "already formed" at some
> other base is not the head at $b$. Witness (SEED-78 §4): $\operatorname{ord}_5(2)
> =\operatorname{ord}_5(7)=4$, but $e_5=v_5(2^4-1)=v_5(15)=1$ while
> $e_5=v_5(7^4-1)=v_5(2400)=2$. Transporting the stored head $e_5=1$ into $b=7$
> gives $R=\Phi_4(7)/(P^{v_P}\cdot5^{1})=50/(2\cdot5)=5>1$, i.e. **"fresh" — and
> it is false**: $\Phi_4(7)=50=2\cdot5^2$ holds no unheld primitive prime. The
> theorem is correct; this sentence's *sourcing* of $e_p$ is not.
>
> **Repair (SEED-78).** Recompute at $b$: $e_p:=v_p\bigl(b^{\operatorname{ord}_p(b)}-1\bigr)$,
> one modular exponentiation per held prime. Still nothing factored.
>
> **Cheaper repair where it applies (SEED-89 §5.1), with its own guard.** Store,
> per held prime $p$, the pair $(r,\tilde e_p(r))$ — the non-power root of the
> base tower and the head read at the root — and, per base, the single integer
> $\kappa:=v_p(k)$ where $b=r^{k}$; then $e_p(b)=\tilde e_p(r)+v_p(k)$ (SEED-78
> Thm A), an addition rather than an exponentiation. **Guard, and it is the point:
> the tag applies iff $b$ is a power of $r$; otherwise recompute.** Bases $2$ and
> $7$ lie in different orbits of $(\mathbb Z_{\ge1},\cdot)$, so no index mediates
> them — an *untagged* head silently applies everywhere, which is exactly how the
> witness above passes. Tagging makes the illegal transport syntactically
> detectable.

Applied to the
collision the organ walked into: $\Phi_4(3)=10$, $H=\{5\}$ with $e_5=1$,
$P=2$, so $R=10/(5\cdot2)=1$ — **not fresh**, decided in advance.

`propose_fresh_encounter` uses it, and the per-base guarantee is finally
closed across bases.  From holdings earned at base $2$:

```text
base 3 fresh proposal n =  1  ->  new prime 2
base 3 fresh proposal n =  3  ->  new prime 13
base 3 fresh proposal n =  7  ->  new prime 1093
base 3 fresh proposal n =  8  ->  new prime 41
base 3 fresh proposal n =  9  ->  new prime 757
base 3 fresh proposal n = 10  ->  new prime 61
```

Six proposals, six genuinely new primes, and the exponents $4,5,6,12$ are
skipped because the organ can see they are already harvested.  The Wieferich
prime $1093$ arrives at base $3$, exponent $7$ — a prime the base-2 organ met
only as a curiosity in a hand-supplied test, now earned by a machine that chose
to go and get it.

## Going after a named prime — and what that does not buy

Seventh sitting.  Every operation so far takes an encounter and reports what
came out.  A learner who wants a *particular* prime has nothing to ask.  So I
asked by hand for $1093$:

| base $b$ | $\operatorname{ord}_{1093}(b)$ | $\varphi$ | cost |
|---|---|---|---|
| $2$ | $364$ | $144$ | astronomical |
| $3$ | $\mathbf 7$ | $6$ | $\mathbf 4$ |
| $5$ | $1092$ | $288$ | astronomical |
| $9$ | $7$ | $6$ | $57$ |
| $11$ | $13$ | $12$ | $71{,}464$ |

Four trial divisions from base $3$; permanently out of reach from base $2$.
**The base is a free parameter that swings the cost by every order of
magnitude available, and the organ never optimised over it.**

`target(p, bases, budget)` now does.  For a prime $p$ and a fixed repertoire,
$p\mid\Phi_n(b)$ forces either $n=\operatorname{ord}_p(b)$ (primitive) or
$n=\operatorname{ord}_p(b)\,p^{s}$ with $s\ge1$ (exceptional); every $s$ is
tried, and the loop terminates because $\varphi(dp^{s})\to\infty$.  Results
over bases $2,\dots,11$:

```text
1093        -> base 3,  exponent 7,   primitive,       4 divisions
41          -> base 2,  exponent 20,  primitive,       2 divisions
65537       -> base 2,  exponent 32,  primitive,      10 divisions
641         -> base 2,  exponent 64,  primitive,    1026 divisions
2147483647  -> base 2,  exponent 31,  primitive,     749 divisions
3511        -> no route over this repertoire within budget
```

The Fermat prime $65537$ arrives at $\operatorname{ord}(2)=32$, the Mersenne
prime $2^{31}-1$ at exponent $31$, and $3511$ — the second known Wieferich
prime — is refused, honestly.

### Theorem 12: planning is scheduling, not extension

The organ can now go after a specified object.  It is worth asking immediately
whether that buys anything, and the answer is no.

> **Theorem 12.**  Fix a finite base repertoire $\mathcal B$ and a budget $B$.
> Let $T$ be the set of primes for which `target` returns a route, and $E$ the
> set of primes obtained by routing *every* affordable encounter over
> $\mathcal B$.  Then $T=E$.

*Proof.*  $(\subseteq)$  A route is an affordable encounter over $\mathcal B$;
routing it is part of the exhaustive sweep and yields $p$.  $(\supseteq)$  If
$p\in E$ it came from an affordable $(b,n)$ with $b\in\mathcal B$; by Theorem 5
either $n=\operatorname{ord}_p(b)$ or $n=\operatorname{ord}_p(b)p^{s}$, and
`target` tries every such index at every base, so it finds that route or a
cheaper one.  $\square$

So **targeting reorders acquisitions; it cannot extend them.**  The reachable
set is the horizon of Theorem 8 taken over the repertoire, and no amount of
planning enlarges it.  What planning buys is order: $1093$ arrives in four
divisions instead of after an exhaustive sweep of base 3.

The test asserts the equality exactly — for every prime below $400$,
targetable if and only if exhaustively reached, over bases $\{2,3,5\}$ at
budget $3000$.

### The theorem has content only because the vocabulary is bounded

There is a degenerate escape, and stating it is the honest part.  If the
repertoire is unconstrained, targeting is trivial:
$$
  \Phi_1(p+1)=(p+1)-1=p,
$$
so **any** prime is earned in one trial division by choosing $b=p+1$, $n=1$.
The executable confirms this for $1093$, $3511$, $65537$, $2^{31}-1$.

That is not a loophole to be patched; it is the boundary of the question.
"Can this organ go after what it wants?" is empty unless the organ's
vocabulary is fixed in advance.  With $\mathcal B$ free, the answer is *always
yes and always vacuous*; with $\mathcal B$ fixed, Theorem 12 says the answer is
*exactly as often as exploring would have found it*.  The agency is real and
it is entirely in the scheduling.

## Choosing the repertoire: the first move, one level up

Eighth sitting, and the probe is embarrassingly short.  Every operation in
this note takes a base:

```text
propose_encounter(base, ...)   propose_fresh_encounter(base, ...)
route(base, ...)               target(prime, bases, ...)
```

**Where do the bases come from?**  From me, for eight increments.  That is
precisely the defect Theorem 5 fixed for the prime — a datum the organ cannot
produce itself, sitting in the interface — recurring one level up and
invisible because I kept supplying it.

Working base $4$ shows the cost immediately:

$$
  4^{3}-1 \;=\; 2^{6}-1 .
$$

A base-$4$ encounter is a base-$2$ encounter wearing a disguise.

> **Theorem 13 (perfect powers are redundant bases).**  For $k\ge2$,
> $(c^{k})^{n}-1=c^{kn}-1$, so $\mathcal F_{c^{k}}\subseteq\mathcal F_{c}$ and
> every prime earnable from base $c^{k}$ is earnable from base $c$.
> Moreover, if $p$ is a primitive divisor of $\Phi_n(c^{k})$ then
> $\operatorname{ord}_p(c)=d$ with $n=d/\gcd(d,k)$, and
> $$
>   \varphi(d)\;\le\;k\,\varphi(n),
> $$
> so the root's route is no larger in degree: the redundancy is a genuine
> saving, not a formality.

*Proof.*  The identity is immediate.  For the second part,
$\operatorname{ord}_p(c^{k})=d/\gcd(d,k)$ is standard; writing $g=\gcd(d,k)$
and $d=gn$, submultiplicativity gives $\varphi(gn)\le g\,\varphi(n)\le
k\,\varphi(n)$.  $\square$

So an organ choosing its own repertoire keeps the non-powers and declines the
rest, **with the identity as the reason**:

```text
proposes: 2, 3, 5, 6, 7, 10, 11, 12, 13, 14, 15, 17
declines: 4, 8, 9, 16, 25, 27, 32, 36

base_refusal(8)  = "8 = 2^3, and (2^3)^n - 1 = 2^(3n) - 1: every encounter
                    here is a base-2 encounter at 3 times the exponent"
base_refusal(36) = "36 = 6^2, ... a base-6 encounter at 2 times the exponent"
```

### This is the lane's own first move

`ARITHMETIC_LIFE_FIRST_EXECUTION` opens with exactly this argument, one level
down.  Its equation (3) is
$$
  d=ab,\ a>1 \quad\Longrightarrow\quad d\mid n \;\Rightarrow\; a\mid n,
$$
so a composite modulus contributes no new test, and the retained sensors are
the irreducible moduli.  Theorem 13 is the same move on bases: a perfect-power
base contributes no new family, and the retained bases are the non-powers.

I did not go looking for that echo; I went looking for a reason to prefer one
base over another, and the reason turned out to be the argument this whole
lane started with, eight increments and one level of abstraction away.  What
makes it more than a pleasing coincidence is that both are instances of the
same shape — *an object built from another by a structure-preserving operation
tests nothing the constituent does not* — and in both cases the retained set is
the set of objects irreducible for that operation.  Multiplication of moduli
gave the primes; exponentiation of bases gives the non-powers.

## The third level: where the pattern stops

I ended the previous section pleased, and immediately suspicious.  Two
instances and an elegant shape is exactly how one talks oneself into a law
that is not there, so the ninth sitting went looking for a third instance in
order to kill the idea rather than confirm it.

The organ has three input slots: the **modulus**, the **base**, the
**exponent**.  Two are prunable.  Is the third?

A composite exponent $n=mk$ has $b^{m}-1\mid b^{n}-1$, so the family member at
$n$ *contains* the one at $m$ — the same shape as the other two levels.  Is the
extra part empty?

```text
b=2, n=12: Phi_12(2) =  13, primes dividing no b^m - 1 with m<12: [13]
b=2, n=20: Phi_20(2) = 205, primes dividing no b^m - 1 with m<20: [41]
b=3, n= 9: Phi_9(3)  = 757, primes dividing no b^m - 1 with m< 9: [757]
b=2, n= 6: Phi_6(2)  =   3, primes dividing no b^m - 1 with m< 6: []
b=2, n= 1: Phi_1(2)  =   1, primes dividing no b^m - 1 with m< 1: []
```

**No.**  And the only failures are $(2,6)$ and $(2,1)$ — precisely the
Zsigmondy exceptions of Theorem 7, arrived at from the other side.

> **Theorem 14 (the trichotomy, and its boundary).**  The three slots differ
> exactly in whether the refinement quotient is trivial.
>
> 1. *Moduli under multiplication.*  For $d=ab$ with $a>1$, the mod-$d$
>    divisibility test **factors through** mod-$a$: there is no quotient at
>    all.  Retained set: the primes.
>    (`ARITHMETIC_LIFE_FIRST_EXECUTION` eq. (3).)
> 2. *Bases under exponentiation.*  $\mathcal F_{c^{k}}\subseteq\mathcal F_{c}$
>    as sets of integers: the quotient is a reindexing and produces no new
>    objects.  Retained set: the non-powers.  (Theorem 13.)
> 3. *Exponents under multiplication.*  For $m\mid n$, $m<n$,
>    $b^{n}-1=(b^{m}-1)\,Q$ with $\Phi_n(b)\mid Q$, and by Theorem 7
>    $\Phi_n(b)$ carries a primitive prime outside the classical exception
>    list.  **The quotient is nontrivial, so no exponent is redundant.**
>
> Hence the pattern has exactly two instances, and its boundary is Zsigmondy.

That is a better outcome than a third confirmation.  A pattern that held at
every level would have been suspicious precisely because nothing would have
stopped it; instead it stops at the one place where this lane's deepest
consumed theorem lives, and the theorem is *why* it stops.  Redundancy at a
level is the triviality of the quotient at that level, and the exponent level
is exactly where the quotient stops being trivial.

`exponent_redundancy_witness` returns the prime, not the boolean.  Deciding
that a witness exists is free (Theorem 7, no factoring); exhibiting one costs a
scan, and the two failure modes — *no witness exists* and *I cannot afford to
find one* — are kept apart for the same reason Theorems 7 and 8 are.

## The interface, completely accounted for

Nine sittings ago this organ took three data from outside and had an opinion
about none of them.  It now has:

| slot | operation | retained | prunable | by |
|---|---|---|---|---|
| modulus | multiplication | primes | yes | eq. (3) |
| base | exponentiation | non-powers | yes | Theorem 13 |
| exponent | multiplication | all of them | **no** | Theorem 14 |

Every input is either **chosen by the organ** or **proved unprunable**.
Nothing is handed in without either a selection rule or a theorem saying no
selection rule can exist.  That is the closure of the arc this note has been
walking since the machine could not say no: the last unexamined slot turned
out to be unexaminable, and the reason is a theorem rather than a gap.

## Deep or wide: the interleaving the organ did not have

The interface was complete, so the tenth sitting ran the organ with *no input
at all* — let it pick base and exponent and go.  Fourteen steps:

```text
step  0: base  2, n=2 -> [3]        step  7: base 12, n=2 -> [13]
step  1: base  3, n=1 -> [2]        step  8: base 13, n=3 -> [61]
step  2: base  5, n=3 -> [31]       step  9: base 14, n=3 -> [211]
step  3: base  6, n=1 -> [5]        step 10: base 15, n=3 -> [241]
...
```

**It works each base exactly once and abandons it.**  Base $2$ alone has about
a hundred affordable exponents at this budget; the organ used one and moved
on.  Two proposal operations, each correct within its own slot, and no rule
for interleaving them — so the naive alternation is a rule by accident.

The cost model already decides this, and I had never read it that way.

> **Theorem 15 (the interleaving scalar and the crossover).**  From the R0030
> lemma, $\log\Phi_n(b)=\varphi(n)\log b+O(1)$ with the error an absolute
> constant, so
> $$
>   \log\operatorname{cost}(b,n)
>   \;=\;\tfrac{\varphi(n)}{2}\log b-\log \mathrm{step}(n)+O(1).
> $$
> Cheapest-first over the whole grid is therefore ordering by the single
> scalar $\varphi(n)\log b-2\log\mathrm{step}(n)$ — one number spanning both
> slots.  Comparing the two available moves from $(b,n)$:
> $$
>   \text{raise }\varphi\text{ by }2:\ \times b,
>   \qquad
>   \text{raise the base by }1:\ \times\bigl(\tfrac{b+1}{b}\bigr)^{\varphi/2},
> $$
> which are equal exactly at
> $$
>   \varphi \;=\; \frac{2\log b}{\log\!\left(1+\tfrac1b\right)}
>   \;\approx\; 2b\log b .
> $$
> **Below that totient, widen; above it, deepen.**

At base $2$ the crossover is $3.42$.  So past the very smallest totients the
organ should stay in base $2$ and go deeper — the exact opposite of working
one encounter per base, and the exact opposite of what I guessed before
computing it.

| $b$ | crossover $\varphi$ |
|---|---|
| $2$ | $3.42$ |
| $3$ | $7.64$ |
| $5$ | $17.65$ |
| $10$ | $48.32$ |
| $100$ | $925.63$ |

With `propose_next` ordering by cost across both slots, the same fourteen
steps become:

```text
base 2: n = 3, 4, 5, 7, 8, 9, 10, 12, 14, 15, 18, 20, 24, 30
        -> 7, {3,5}, 31, 127, 17, 73, 11, 13, 43, 151, 19, 41, 241, 331
then base 3: n = 1, 10 -> 2, 61
```

Fourteen consecutive encounters in base $2$ reaching exponent $30$, and only
then a widening — matching the crossover rather than an alternation I imposed.

**A bookkeeping defect the rewrite exposed.**  `route` marked only the
exponent $n$ as covered, but `factor_power_minus_one` routes through every
$\Phi_m$ with $m\mid n$, so all divisors of $n$ are worked.  The old
`propose_encounter` masked this by testing divisibility rather than
membership; the new global search did not, and the organ would have re-paid
for exponents it had already factored.  Now `route` records the divisors it
actually visited.

## Is cheapest-first optimal?  Bounded locally, and the organ says by how much

Theorem 15 gave the organ an order and I flagged, three times, that the order
minimises cost per **guaranteed** acquisition — one prime, by Zsigmondy —
while an encounter can yield several.  A yield-aware rule might beat it.  The
eleventh sitting is that question, and it turns out to be answerable, because
the yield is boundable without factoring anything.

> **Theorem 16 (yield bound, and local optimality).**  Let $Y(b,n)$ be the
> number of *primitive* prime divisors of $\Phi_n(b)$.  Every such prime
> satisfies $\operatorname{ord}_p(b)=n$, hence $n\mid p-1$ and $p\ge n+1$; and
> $\Phi_n(b)\le(b+1)^{\varphi(n)}$.  So $(n+1)^{Y}\le(b+1)^{\varphi(n)}$, i.e.
> $$
>   Y(b,n)\;\le\;\frac{\varphi(n)\log(b+1)}{\log(n+1)} .
> $$
> Consequently, for two candidate encounters with $\operatorname{cost}_1\le
> \operatorname{cost}_2$, a yield-aware ordering can prefer the second only if
> $$
>   \operatorname{cost}_2 \;<\; Y(b_2,n_2)\cdot\operatorname{cost}_1 ,
> $$
> because $Y\ge1$ on the cheaper side by Zsigmondy.  **Outside that window,
> cheapest-first is optimal whatever the actual yields are.**

The bound is the point.  Cost varies like $b^{\varphi(n)/2}$ — exponentially —
while the yield bound is $\varphi(n)\log b/\log n$, *polylogarithmic in the
cost*.  So a yield advantage can never overturn an exponential cost gap; it
can only reorder near-ties.  Cheapest-first is wrong at most locally, and the
locality is computable per pair.

The bound is not vacuous: swept over $2\le b\le7$, $1\le n\le25$ against real
factorizations it is never violated **and is attained** — at $(b,n)=(2,2)$,
where $\Phi_2(2)=3$ has exactly one primitive prime and the bound is one.

### The organ reports the size of its own uncertainty

`optimality_certificate` returns the choice together with how much of the grid
it *provably* beats and how much is contested:

```text
step 0: pick (2,3)   provably beats 179, contested 55   (yield bound 1)
step 1: pick (2,4)   provably beats 178, contested 55   (yield bound 1)
step 2: pick (2,5)   provably beats 177, contested 54   (yield bound 2)
step 3: pick (2,7)   provably beats 177, contested 53   (yield bound 3)
```

No factoring is done to produce that split — the bound comes from $\varphi(n)$
and $\log b$ alone.  And the contested count never reaches zero, which is
correct and worth saying plainly: **near-ties always exist, so a greedy choice
is never fully certified, and an organ that reported "optimal" would be
overclaiming.**  What it can honestly report is *optimal against 177 of 232
alternatives, undecided against 55*.

This also closes a joint I left open in the previous section.  I noted there
that at small totients the integer flooring makes many encounters tie at cost
$2$, so the crossover explains the observed order rather than predicting each
swap.  Those ties are exactly the contested set: the window where the cost
model does not separate, and the window where yield could matter, are the same
window.

## The contested window is irreducible — and purchasable

I closed the previous section with the contested set as an open item and said I
expected deciding it to be genuinely hard, because it needs a *lower* bound on
the yield and Zsigmondy gives only one.  The twelfth sitting asked whether a
better lower bound could exist at all.  It cannot.

> **Theorem 17.**
> 1. *The lower bound is sharp.*  Whenever the primitive part of $\Phi_n(b)$ is
>    a single prime, $Y(b,n)=1$ exactly, however large the upper bound of
>    Theorem 16 happens to be.  Witnesses at base $2$:
>    $$
>      \Phi_7(2)=127,\quad \Phi_{13}(2)=8191,\quad \Phi_{17}(2)=131071,
>    $$
>    all prime, with $Y=1$ against bounds $3$, $4$, $6$.
> 2. *Hence the window cannot be narrowed.*  No argument from $(b,n)$ alone can
>    improve $Y\ge1$, so the contested set of Theorem 16 is exactly as large as
>    the bounds allow, and no sharper bound will shrink it.
> 3. *But it can be bought.*  Factoring both primitive parts gives the exact
>    yields, at a price quotable in advance: $\operatorname{cost}_1+
>    \operatorname{cost}_2$ trial divisions.

Part 2 is the honest answer to the question I left open, and it is a no-go of a
particular kind: **the organ's residual uncertainty about its own optimality is
not a gap in my analysis.  It is a feature of the problem.**  Deciding a
near-tie requires exactly the work the ordering exists to schedule.

### Buying a verdict

`quote_resolution` prices the decision, `resolve_contested` pays it:

```text
choice (2,3), contested rivals: 52
   vs (2,5):  quote 4  ->  (2,3) beats (2,5),  yields 1 vs 1, price 4
   vs (2,7):  quote 4  ->  (2,3) beats (2,7),  yields 1 vs 1, price 4
   vs (2,11): quote 6  ->  (2,3) beats (2,11), yields 1 vs 2, price 6
   vs (2,53): quote 895346 -> declined, exceeds budget
```

The last row is the point about typing again: that refusal is about
**affordability**, not about existence.  The verdict is there to be had; this
organ cannot pay for it.

So the organ now stands in three distinct relations to its own next choice:

| | what it can say |
|---|---|
| outside the window | *optimal, proved, free* (Theorem 16) |
| inside the window, affordable | *optimal, bought, price stated* (Theorem 17.3) |
| inside the window, unaffordable | *undecided, and here is what deciding costs* |

The third row is new and is the one I would not have written a sitting ago.
An organ that can quote the price of a certainty it does not have is in a
better epistemic position than one that merely reports uncertainty, and the
quote costs nothing to produce.

## The contest dissolves: resolving a near-tie *is* doing the work

I ended the previous section pleased with three epistemic positions, the third
being *undecided, and deciding costs 895346*.  The thirteenth sitting went to
attack the loophole I had left, and found something better and less flattering:
**that third position is empty**, and the example I used to illustrate it was
not a contested pair at all.

> **Theorem 18.**  Let $(b_2,n_2)$ be *contested* against the choice
> $(b_1,n_1)$ — that is, not certified by Theorem 16, so
> $\operatorname{cost}_2 < Y_2\operatorname{cost}_1$.  Then the price of
> resolving the pair satisfies
> $$
>   \operatorname{cost}_1+\operatorname{cost}_2
>   \;<\;\bigl(1+Y_2\bigr)\operatorname{cost}_1,
>   \qquad
>   Y_2\le\frac{\varphi(n_2)\log(b_2+1)}{\log(n_2+1)} .
> $$
> Since $Y$ is polylogarithmic where cost is exponential, **every near-tie is
> resolvable at a polylogarithmic multiple of the encounter the organ was
> already going to make.**

Measured across the whole contested set at two budgets: the worst resolution
price is $4.5\times$ the encounter itself.  Contested pairs are cheap
*because* they are contested — being a near-tie in cost is exactly what makes
the second one affordable.

That kills the third position.  There is no state in which the organ cannot
afford to decide a near-tie it actually faces.  My $(2,53)$ illustration was a
pair I chose by hand; run through the certification it is **certified, not
contested** — its cost exceeds $14\times$ the choice while $Y(2,53)\le14$.  I
had exhibited an unaffordable resolution without checking it was a resolution
anyone would need.

### And the resolution is not overhead

Here is the part that changes the picture rather than correcting it.  To
resolve a near-tie the organ factors both primitive parts.  **Factoring a
primitive part is exactly what routing an encounter does.**  So the price of
the verdict is the price of performing the two encounters — and both are
encounters the organ wants, being among the cheapest available.

Yet `resolve_contested` was a pure function: it factored, read off the two
yields, and threw the factorizations away.

```text
resolve_contested((2,3), (2,11))  ->  verdict, price 6
primes held before: []      primes held after: []
```

It had just factored $\Phi_3(2)=7$ and $\Phi_{11}(2)=23\cdot89$, paid for all
of it, and kept none of it.  `resolve_and_keep` routes both instead:

```text
resolve_and_keep((2,3), (2,11))  ->  same verdict, same price
primes now held: [7, 23, 89]
routed: {2: [1, 3, 11]}
```

So the cost of certainty is not a tax on the acquisition — it *is* the
acquisition, and the verdict falls out as a by-product.  Which deflates three
sittings of my own work in a useful direction: **within the contested set, the
order does not matter, because the organ should simply do all of them.**  They
are all cheap, all wanted, and choosing between them costs the same as doing
both.

The ordering theorems keep their content outside the window, where the cost
gaps are exponential and the choice is real.  Inside it, the honest advice is
not *choose better* but *stop choosing*.

## The loophole, closed: knowledge is continuous in effort

Twice I recorded the loophole in my own no-go and twice I went somewhere else.
Theorem 17 says no bound *on $(b,n)$ alone* improves $Y\ge1$.  A partial scan
is not such a bound.

> **Theorem 19 (partial-scan bracket).**  Scan the progression for
> $\Phi_n(b)$ through its first $e$ candidates, reaching limit $L$, finding
> distinct primitive primes $p_1,\dots,p_k$ and leaving cofactor $R$ after the
> exceptional prime is stripped.  Every surviving prime factor of $R$ is
> primitive and exceeds $\max(L,n)$.  Hence
> $$
>   k+[R>1] \;\le\; Y(b,n) \;\le\; k+\max\{\,j:\max(L,n)^{\,j}<R\,\},
> $$
> and if $L^{2}\ge R>1$ the cofactor is prime, so both bounds equal $k+1$.

Both ends move with effort, and they meet long before the scan finishes:

| $(b,n)$ | true $Y$ | a priori bound | full scan | bracket at effort 10 | exact at |
|---|---|---|---|---|---|
| $(2,29)$ | 3 | 9 | 401 | $[2,3]$ | **20** |
| $(5,19)$ | 3 | 10 | 57,466 | $[2,5]$ | **166** |
| $(2,41)$ | 2 | 11 | 18,086 | $[1,4]$ | **164** |

For $(5,19)$ the yield is known exactly after $166$ candidates where the full
scan costs $57{,}466$ — a factor of $346$.

**But those three rows are cherry-picked, and I wrote a sentence claiming
"almost all of it arrives early" before measuring.**  The fifteenth sitting
measured it, and found the sentence wrong — then found the *measurement* wrong
too, in two independent ways.

### Two corrections, and the sharp statement

First, the baseline.  I compared the exactness effort against
`scan_cost`, which is the **worst-case** bound (the price if $\Phi_n(b)$ were
prime).  The scan actually performed stops as soon as `candidate^2` exceeds
the running cofactor, which is usually far sooner.  Comparing against a budget
nobody spends is the same category error I corrected in the routing ledger ten
sittings ago.

Second, the bracket was loose.  Its primality test asked whether the *last
tested candidate* squared exceeded the cofactor — so when the very first
candidate already exceeded $\sqrt R$, nothing had been tested, and a prime
cofactor went unrecognised.  $\Phi_5(2)=31$ with step $10$: the first candidate
is $11>\sqrt{31}$, so the scan is already complete and the bracket still
reported $[1,2]$.  The correct test is the loop's own exit condition.

With both repaired the ratio is not a distribution at all:

> **Theorem 20(i).**  The bracket becomes exact at *exactly* the effort at
> which the scan terminates.  Both are the single test
> $\text{candidate}^{2}>R$.  Measured over the same 57 encounters: minimum,
> median and maximum of exactness-effort / actual-scan are all $1.000$.

So the bracket buys **nothing** as a way of learning a yield.  Knowing
$Y(b,n)$ costs a full scan, exactly, always.

### But deciding is not knowing

The operational question was never *what is the yield*.  It is *which of two
encounters is better*, and that needs only

$$
  \frac{\operatorname{cost}_1}{\text{low}_1}\;\le\;
  \frac{\operatorname{cost}_2}{\text{high}_2},
$$

which asks the *ratio* of two brackets to fall the right way — not either
bracket to be tight.

> **Theorem 20(ii).**  Comparisons settle long before exactness.  Over the
> contested rivals of $(2,3)$: several decided at effort **zero**, median
> effort under half the full resolution price.

| rival | decided at effort | full resolution |
|---|---|---|
| $(2,9)$ | **0** | 2 |
| $(2,15)$ | **0** | 2 |
| $(5,4)$ | **0** | 2 |
| $(2,11)$ | 2 | 3 |
| $(2,13)$ | 2 | 5 |

**The organ never needs to know a yield; it needs to decide an order, and
deciding is the cheaper question.**  That is the honest content of the
bracket, and it is not what I claimed for it in either of the two previous
sittings.

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
- **Proved here:** Theorem 19.  The floor on surviving primes is R0027's
  congruence plus the scan's own limit, and the counting is integer arithmetic
  with no logarithm trusted.  Elementary and standard practice in incremental
  trial division; **no novelty claimed**.  **Not claimed:** any bound on the
  effort at which the bracket becomes exact — the three rows are observations,
  and the general question is how far one must scan before `L^2 >= R`, which
  depends on the second-largest prime factor and is not controlled here.
- **Proved here:** Theorem 17.  Part 1 is exhibition — the named cyclotomic
  values are prime, which is a finite exact check, and the yields are computed
  by complete factorization.  Part 2 follows: a uniform lower bound `Y >= 2`
  is contradicted by a single witness.  Part 3 is the definition of the price
  plus R0030's completeness guarantee.  **Not claimed:** that `Y = 1` occurs
  infinitely often — that would need infinitely many Mersenne-type primes and
  is open.  What is proved is only that no uniform improvement exists, which
  one witness settles.
- **Proved here:** Theorem 16.  The yield bound is elementary — `p = 1 mod n`
  forces `p >= n+1`, and `Phi_n(b) <= (b+1)^phi(n)` is the same product bound
  used in R0028.  **No novelty claimed.**  **Not claimed:** that the bound is
  sharp beyond the small cases where it is attained, nor any lower bound on the
  yield beyond Zsigmondy's one.  The local-optimality consequence is arithmetic
  on the two bounds, and it establishes only that cheapest-first cannot be
  wrong across an exponential cost gap — it does **not** decide the near-ties,
  and the executable reports them as contested rather than resolving them.
- **Proved here:** Theorem 15.  The cost expansion is R0030's lemma read as an
  asymptotic in both variables; the crossover is elementary calculus on the two
  move ratios.  Elementary and surely known in the folklore of special-form
  factoring, where one does in practice push a single base far before changing
  it; **no novelty is claimed**.  **Not claimed:** that cheapest-first is
  *optimal*.  It minimises cost per guaranteed acquisition, and since an
  encounter can yield more than one prime, a yield-aware rule could beat it.
  The greedy order is derived from the cost model, not shown to be best.
- **Proved here, on a consumed classical input:** Theorem 14.  Parts 1 and 2
  are eq. (3) and Theorem 13; part 3 is Theorem 7 (Bang/Zsigmondy), consumed.
  What is proved here is only the *trichotomy* — that the three slots differ
  exactly in the triviality of the quotient — which is a statement about this
  organ's interface, not about arithmetic.  **Not claimed:** that three slots
  are all there are.  A different organ with a different interface would have
  a different table, and the pattern's "exactly two instances" is a fact about
  this construction rather than a law.
- **Proved here:** Theorem 13.  The identity `(c^k)^n - 1 = c^(kn) - 1` and
  `ord_p(c^k) = ord_p(c)/gcd(ord_p(c), k)` are elementary and standard; the
  submultiplicativity `phi(gn) <= g phi(n)` likewise.  No novelty is claimed.
  What is recorded is that this is the criterion by which an organ can choose
  its own repertoire, and that it is the lane's opening argument recurring one
  level up.  **Not claimed:** that non-powers are the *optimal* repertoire —
  only that powers are redundant.  Which non-powers are worth working, and in
  what order, is not settled here.
- **Proved here:** Theorem 12 and the degenerate-repertoire remark.  Both are
  elementary consequences of Theorem 5 plus the definition of order; no novelty
  is claimed.  The content is that the equality `T = E` is *exact* rather than
  approximate, so no scheduling heuristic can ever enlarge the reachable set —
  a statement about this organ, not about arithmetic.
- **Proved here:** Theorems 10 and 11.  Theorem 10 is a no-go with an explicit
  witness the executable rediscovers rather than quotes; the underlying fact
  (order is not multiplicative) is elementary and certainly known, and no
  novelty is claimed — what is recorded is that it *is* the obstruction the
  multi-base question runs into.  Theorem 11 is Theorem 5 applied to the
  residual after dividing out held primes, and is elementary.
- **Proved here, on a consumed classical input:** Theorem 9.  The two-sided
  bound (9) is my own lemma's proof read fully rather than one-sidedly.  The
  totient density `#{n : phi(n) <= x} ~ zeta(2)zeta(3)/zeta(6) x` is classical
  and is **consumed, not derived**.  The slope `2A/log a` and the budget factor
  `a^(1/2A)` follow; the twelve-decade sweep is a falsifier of those derived
  constants and fits nothing.  The `o(1)` is not made effective here: the
  correction is `O(log log B)` and I have not bounded its constant, so the
  *offset* of the count is not claimed, only its rate.
- **Proved here:** the lemma `Phi_n(a) > a^phi(n)/8` and Theorem 8.  The
  lemma's ingredients (the Mobius form of `Phi_n`, `sum mu(n/d) d = phi(n)`,
  `phi(n) >= sqrt(n)` for `n > 6`) are standard; the assembly into a finiteness
  statement about *this organ's* reachable set is what the note adds.  The
  horizon's shape — a sublevel set of `phi`, so that exponent 210 is reachable
  where 61 is not — is derived and then exhibited, not measured.
- **Proved here:** Theorem 7, from Theorem 5 alone.  The *conclusion* — that
  a primitive prime divisor exists outside an explicit finite list — is
  Bang (1886) and Zsigmondy (1892) and is classical; what is derived here is
  the criterion in the form "`Phi_n(a)` is 1 or the largest prime factor of
  `n`", which is decidable without factoring.  **I do not claim to have
  reproved Zsigmondy**: closing the criterion into the classical finite list
  requires lower bounds on `Phi_n(a)` that are easy for `a >= 3` and genuinely
  delicate at `a = 2`, and I have verified the list by exhaustive sweep rather
  than derived it in general.  The sweep is a falsifier, not the proof.
- **Proved here:** Theorem 6.  The bounds `(a-1)^phi(m) <= Phi_m(a) <=
  (a+1)^phi(m)` and `phi(m) | phi(n)` for `m | n` are standard; the statement
  that the two gains are *independent*, with the prime-exponent case as the
  built-in negative control, is the framing this note adds.  The per-encounter
  ledger reports exact integer counts, and the predicted ratio
  `a^((n-phi(n))/2)` is asserted in the tests within a factor of `a` — derived,
  never fitted.  Routing through cyclotomic factors is standard practice
  (Cunningham tables); no novelty is claimed.
- **Proved here, classical in content:** Theorem 5.  That a prime divisor of
  `Phi_m(a)` is primitive or is the largest prime factor of `m` is the standard
  lemma behind Bang (1886) and Zsigmondy (1892), and the resulting
  `p = 1 mod 2m` search rule is classical practice in Mersenne/Cunningham
  factoring.  The derivation here is from Theorem 3 by turning the quantifier
  around; no novelty is claimed.  The exact candidate-count ratio `m` is
  derived, not fitted.
- **Proved here:** Theorem 4's shift lemma and the identification of the head
  length with the torsion threshold of the unit filtration.  The threshold
  fact ($U_k$ torsion-free iff $k>e/(p-1)$) is standard local field theory,
  consumed and cited, not reproved.  The local-field generalization
  $\lfloor e_K/(p-1)\rfloor+1$ is a **derived prediction and is not tested**.
- **Proved here, classical in content:** Theorem 3.  The cyclotomic valuation
  formula is standard (it is the engine of Bang's and Zsigmondy's theorems);
  the derivation given is from Theorem 1 by divisor differencing, and the
  chain/head reformulation — in particular the observation that it removes the
  $p=2$ exception rather than special-casing it — is the framing this note
  adds.  No novelty is claimed for the formula.
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

0. ~~**`PROVE` — uniform head length.**~~  DONE: Theorem 4.  The head length
   is $\lfloor 1/(p-1)\rfloor+1$, the torsion threshold of $U_k$, and the
   obstruction at $p=2$ is the element $-1$.  Open successor: verify the
   local-field form $\lfloor e_K/(p-1)\rfloor+1$, which needs an organ this
   corpus does not have.
1. ~~**`PROVE` — the cyclotomic refinement.**~~  DONE: Theorem 3 above.  The
   indicator dissolved into the chain's support and the $p=2$ exception
   dissolved into a longer head, which is the sign the chart is right.
2. ~~**`DEMONSTRATE` — wire the organ into the factorer.**~~  DONE:
   `CyclotomicOrgan.route` factors `a^n - 1` through its pieces and installs
   every named prime as an earned sensor, so a refused valuation question
   becomes answerable in the same encounter.
3. **`PROVE` — close Theorem 7 into the classical list.**  For `a >= 3` and
   `n >= 3`, `(a-1)^phi(n) > n` except at `n in {4,6}`, both checkable
   directly, which finishes that half.  The `a = 2` half needs a real lower
   bound on `Phi_n(2)` and is the delicate part of Zsigmondy.  Until then the
   criterion is exact and the *list* is cited, not derived.
4. **`PROVE` — classify the bounded-chart families.**  Theorem 2 says
   $\mathcal F_{p,a}$ has a finite base chart.  Which subsets
   $S\subseteq\mathbb Z$ admit a finite observation of a generating datum
   determining $v_p$ on all of $S$?  Conjecturally these are exactly the
   images of $\mathbb Z_p$-analytic families; the honest first step is
   $a^{n}-b^{n}$ and $\Phi_m(a)$.
3. **`PROVE` — composite moduli.**  The sensor is defined one prime at a time.
   Does the CRT recombination of sensors give a local-global statement for
   $v$ against a composite $W=\prod p$, i.e. does the compiled Euclidean batch
   of `arithmetic_life.py` extend to the cyclotomic family?
4. ~~**`DEMONSTRATE` — the AIME encounter.**~~  DONE by Theorem 5 and
   `factor_cyclotomic`: the organ now names its own prime candidates instead of
   waiting to be handed one.  Remaining: wire it into `exponent_world.form` so
   that a request for $n=a^{k}-1$ routes through the cyclotomic factors before
   trial division, and report the change in formed factor events.
5. **`PROVE` — how far does naming go?**  Theorem 5 restricts $p$ to one class
   mod $2m$.  Is there a second, independent congruence?  For $a=2$ the
   classical answer is yes — $p\equiv\pm1\bmod 8$ by quadratic reciprocity,
   since $2$ is a QR mod $p$ when $\operatorname{ord}_p(2)$ is odd — which
   would halve the search again.  State the general reciprocity constraint for
   arbitrary $a$, or show it does not exist.
