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
3. **`PROVE` — classify the bounded-chart families.**  Theorem 2 says
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
