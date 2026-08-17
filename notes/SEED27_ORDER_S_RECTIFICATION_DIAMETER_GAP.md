# Wrap-free modelling at order $s$: the difference-set criterion, the diameter heuristic, and the exact size of the gap

`SEED-27`, 2026-08-14. Persona lens: Freiman (when a set behaves like a
progression, prove it is one — and be exact about when the model is faithful).
Kerala lens (*yukti*): every bound below carries its remainder term **with its
scale dependence**, not a constant measured at one scale.

Paper mathematics only; no toolchain was available, no computation was run.
Every numeric assertion here is a finite verification carried out symbolically
in the text and reproducible by hand in one line.

---

## 0. What this adds to the corpus, and what it does not

`collab/swarm/2026-08-14/swarm-0814-06-nowrap-difference-set.md` proved the
**order-1** statement: for a *grade set* $S=A+B$, the finite-Fourier projector
is an equality projector iff $\pi_q|_S$ is injective iff $q\nmid d$ for all
$d\in(S-S)\setminus\{0\}$; and its Theorem 2 proves the interval/diameter
condition $\operatorname{diam}(S)<q$ is sufficient, Theorem 3 that it is
strictly so.

That note is correct and its guard is in the right place — *on the grade set*.
The gap it leaves open, and the one this note closes, is the one an
implementer actually falls into: the object usually named and reduced is not
$S$ but $A$ itself, and then **the order matters**. "Reduce $A$ mod $N$ with
$N>\operatorname{diam}(A)$" is a faithful model of $A$ **as a set** and of
nothing else; it is not a faithful model of $A+A$, of any convolution of
weights on $A$, or of any sumset-like quantity. §4 exhibits four integers where
that exact mistake triples a representation count (error $200\%$ of the true
value) while every order-1 guard in the corpus reports "no wrap".

Novelty claim: **none** for §§1–2, which are the classical Freiman/Ruzsa
modelling apparatus (see §7). What is local and new is §3 (the explicit
unbounded-gap family with integers), §5 (an exact overestimate factor with
scale dependence, $\Theta(L)$ versus $O(\log L\log\log L)$), and §6 (the corpus
audit).

---

## 1. The two criteria, stated exactly

Throughout $A\subset\mathbb Z$ is finite, $|A|=k\ge2$,
$L:=\operatorname{diam}(A)=\max A-\min A$, $s\ge1$ an integer, $N\ge1$, and
$\pi=\pi_N:\mathbb Z\to\mathbb Z/N$ reduction. Write
$sA=\{a_1+\dots+a_s: a_i\in A\}\subset\mathbb Z$ (the $s$-fold **sumset**, not
the dilate).

**Definition 1 (faithful at order $s$).** $\pi|_A$ is a *Freiman
$s$-isomorphism onto its image* — equivalently, $\pi$ is a **wrap-free model of
$A$ at order $s$** — if for all $a_1,\dots,a_s,a'_1,\dots,a'_s\in A$,

$$
a_1+\dots+a_s\;\equiv\;a'_1+\dots+a'_s \pmod N
\quad\Longrightarrow\quad
a_1+\dots+a_s\;=\;a'_1+\dots+a'_s \ \text{ in } \mathbb Z. \tag{1.1}
$$

(The forward implication is automatic: reduction is always an
$s$-homomorphism. Faithfulness is exactly the converse.)

**Criterion D (the diameter heuristic).** *Take $N>sL$.* This is the rule of
thumb in the literature ("choose the modulus larger than the diameter so that
no wrap-around occurs") and, in the $s=1$ form $N>L$, is Theorem 2 of
`swarm-0814-06`.

**Criterion $\Delta$ (the difference-set criterion).**
$$
(sA-sA)\cap N\mathbb Z=\{0\}. \tag{1.2}
$$

**Theorem 1 (Criterion $\Delta$ is the truth).** The following are equivalent.

1. $\pi|_A$ is faithful at order $s$ (Definition 1);
2. $\pi|_{sA}$ is injective;
3. $(sA-sA)\cap N\mathbb Z=\{0\}$, i.e. $N\nmid d$ for every
   $d\in(sA-sA)\setminus\{0\}$;
4. $|\pi(sA)|=|sA|$;
5. for every weight $x:\mathbb Z\to\mathbb C$ supported in $A$ and every
   $n\in sA$, the $s$-fold cyclic convolution $x^{*s}$ computed in
   $\mathbb Z/N$ agrees at $\pi n$ with the integer convolution at $n$.

*Proof.* (1)$\Leftrightarrow$(2)$\Leftrightarrow$(3)$\Leftrightarrow$(4):
(1.1) says precisely that two elements of $sA$ congruent mod $N$ are equal,
which is injectivity of $\pi$ on the finite set $sA$, which is the statement
that no nonzero difference of two elements of $sA$ is divisible by $N$, which
is the statement that $\pi$ does not decrease cardinality on $sA$.
(2)$\Rightarrow$(5): the cyclic convolution at $\pi n$ is
$\sum_{n'\in sA,\ n'\equiv n}\,(x^{*s})(n')$ (push-forward along $\pi$; this is
Theorem 1(a) of `swarm-0814-06` with $q=N$ and $s$ factors), and injectivity
leaves the single term $n'=n$.
(5)$\Rightarrow$(2): if $n\ne n'$ in $sA$ with $\pi n=\pi n'$, pick
$a_1,\dots,a_s\in A$ with $\sum a_i=n'$ and set $x=\sum_i\delta_{a_i}$ scaled
so that $(x^{*s})(n')>0$; more simply take $x$ the indicator of $A$, for which
$x^{*s}\ge1$ on all of $sA$; then the cyclic value at $\pi n$ is at least
$(x^{*s})(n)+(x^{*s})(n')>(x^{*s})(n)$. $\square$

**Remark 1.1 (monotonicity in $s$).** $s'A-s'A\subseteq sA-sA$ for $s'\le s$
(add $(s-s')$ copies of a fixed $a\in A$ to both sides). Hence faithfulness at
order $s$ implies faithfulness at every order $s'\le s$, and the least faithful
modulus
$$
N_{\min}(A,s):=\min\{N\ge1:\ (1.2)\text{ holds}\}
$$
is non-decreasing in $s$. **The converse fails**, and that failure is §4.

**Remark 1.2 (why $sA$ and not $sA-sA$ in the corpus's form).**
`swarm-0814-06` states its criterion on the grade set $S=A+B$: that is exactly
Theorem 1(2) here with $s=2$ and two sets, and it is the *correct* placement of
the guard. The reason the present note exists is that (2) is a condition on
$sA$, whose diameter is $sL$ — so anyone who transports the guard back to $A$
must multiply the diameter by $s$, and the corpus contains no statement saying
so.

---

## 2. Criterion D implies Criterion $\Delta$ — with the exact threshold

**Theorem 2 (the diameter heuristic is sufficient, and sharp exactly on
progressions).**

(a) If $N>sL$ then $\pi|_A$ is faithful at order $s$; i.e.
$N_{\min}(A,s)\le sL+1$.

(b) If $A$ is an arithmetic progression of length $k$ and common difference
$d$ with $\gcd(d,N)=1$, then $\pi|_A$ is faithful at order $s$ **iff**
$N>s(k-1)=sL/d$. In particular for $d=1$ the threshold in (a) is attained:
$N_{\min}(A,s)=sL+1$.

(c) Unconditionally $N_{\min}(A,s)\ge|sA|\ge s(k-1)+1$, and the second
inequality is an equality **iff $A$ is an arithmetic progression**.

*Proof.* (a) Every element of $sA$ lies in $[s\min A,\ s\max A]$, an interval
of length $sL$; so every nonzero $d\in sA-sA$ satisfies $0<|d|\le sL<N$ and
cannot be divisible by $N$. Theorem 1(3) applies.

(b) After the affine normalisation $a\mapsto (a-\min A)/d$ (an affine map with
unit-invertible dilation is a Freiman isomorphism of every order and commutes
with $\pi$ when $\gcd(d,N)=1$), $A=\{0,1,\dots,k-1\}$ and
$sA=\{0,1,\dots,s(k-1)\}$, an interval of $s(k-1)+1$ consecutive integers.
$\pi$ is injective on a set of $m$ consecutive integers iff $N\ge m$; and
$N=s(k-1)$ fails because $N\mid s(k-1)-0$. So the threshold is $N\ge
s(k-1)+1$.

(c) The first inequality is Theorem 1(4) plus $|\pi(sA)|\le N$. The second is
the trivial sumset bound $|sA|\ge s(|A|-1)+1$, whose equality case is the
classical rigidity statement (Freiman's $3k-4$ circle of ideas in its easiest
form; already for $s=2$, $|A+A|=2|A|-1$ forces $A$ to be an AP). $\square$

**Reading of Theorem 2 in the Freiman idiom.** The diameter heuristic is not a
crude bound that happens to be safe. It is *the exact criterion for arithmetic
progressions of difference 1, and only for those*: by (b) and (c) the heuristic
is tight precisely on the model objects it silently assumes. Every deviation of
$A$ from a progression is deviation of the heuristic from the truth, and §3
makes that quantitative.

---

## 3. The gap, with explicit integers

**Theorem 3.** Let $A=\{0,\,8,\,87\}$ and $N=7$. Then $\pi_7|_A$ is faithful at
order $2$, while Criterion D demands $N>2\cdot87=174$.

*Proof (finite verification, done here in full).*
$2A=\{0+0,\,0+8,\,0+87,\,8+8,\,8+87,\,87+87\}=\{0,8,87,16,95,174\}$, six
distinct integers. Their residues mod $7$:
$$
0\equiv0,\quad 8\equiv1,\quad 16\equiv2,\quad 87\equiv3,\quad 95\equiv4,\quad
174\equiv6 .
$$
($87=7\cdot12+3$, $95=7\cdot13+4$, $174=7\cdot24+6$.) The six residues
$0,1,2,3,4,6$ are pairwise distinct, so $\pi_7$ is injective on $2A$ and
Theorem 1(2) gives faithfulness at order $2$. Meanwhile
$\operatorname{diam}(A)=87$ and $2\cdot87=174\ge7$, so Criterion D returns
"not faithful" at $N=7$ — a wrong answer. $\square$

The overestimate factor here is $(2L+1)/N_{\min}\ge175/7=25$. It is not an
accident of small numbers:

**Theorem 3′ (unbounded gap at a fixed modulus).** For all integers
$t,t'\ge0$ put
$$
A_{t,t'}=\{\,0,\ 1+7t,\ 3+7t'\,\}\subset\mathbb Z .
$$
Then $\pi_7|_{A_{t,t'}}$ is faithful at order $2$ for **every** $t,t'$, while
$\operatorname{diam}(A_{t,t'})\ge 7\max(t,t')\to\infty$. Hence
$$
\sup_{A}\ \frac{2\operatorname{diam}(A)+1}{N_{\min}(A,2)}\;=\;+\infty .
$$

*Proof.* The residues are $\{0,1,3\}\subset\mathbb Z/7$, a perfect difference
set (Singer, $q=2$): its six pair sums are
$0,1,3,2,4,6$ — namely $0{+}0,0{+}1,0{+}3,1{+}1,1{+}3,3{+}3$ — which are
pairwise distinct mod $7$. So no two elements of $2A_{t,t'}$, whose residues
are among these six values with distinct residues attached to distinct
representation patterns, can be congruent unless they are equal; formally, if
$n=a_1+a_2$ and $n'=a'_1+a'_2$ with $n\equiv n'\pmod 7$ then the residue pairs
$\{\bar a_1,\bar a_2\}$ and $\{\bar a'_1,\bar a'_2\}$ have equal sums, hence are
equal as multisets by $B_2$-ness, hence $\{a_1,a_2\}=\{a'_1,a'_2\}$ (residues
are distinct on $A$, so each residue has a unique lift in $A$), hence $n=n'$.
Theorem 1(1) applies. $\square$

**Remark 3.1 (the mechanism, stated so it transfers).** Faithfulness at order
$s$ is a property of the **residues only**: it holds iff the residue multiset
$\pi(A)$ is a $B_s$ ($s$-Sidon) set in $\mathbb Z/N$ *and* $\pi|_A$ is
injective. The integer lifts may be moved arbitrarily far apart along their
residue classes without affecting it. The diameter, by contrast, is destroyed
by exactly those moves. **Diameter is a property of the lift; faithfulness is a
property of the projection.** That is the whole gap, in one sentence, and it
explains why the gap is unbounded rather than merely constant-factor.

**Remark 3.2 (larger examples, same construction).** Any Singer perfect
difference set $D\subset\mathbb Z/(q^2+q+1)$, $|D|=q+1$, is a $B_2$ set; lifting
its $q+1$ residues to integers spread arbitrarily gives $k=q+1$ points with
$N_{\min}(\cdot,2)\le q^2+q+1=\Theta(k^2)$ and unbounded diameter. Note
$\Theta(k^2)$ is optimal for order 2 up to constants by Theorem 2(c), since
a $B_2$ set in $\mathbb Z/N$ has $\binom{k+1}{2}\le N$.

---

## 4. The dangerous direction: order 1 does not give order 2

Theorem 3 shows the heuristic is over-cautious. The following shows the
version of it that is actually in circulation is *under*-cautious, because it
is applied at the wrong order.

**Theorem 4.** Let $A=\{0,1,2,5\}$ and $N=6$. Then
$\operatorname{diam}(A)=5<6=N$, so $\pi_6$ is injective on $A$ and the
order-1 diameter condition (`swarm-0814-06` Theorem 2, applied to $A$) holds.
Nevertheless $\pi_6|_A$ is **not** faithful at order 2, and the failure is
total in relative terms: for $x=\mathbf 1_A$, the cyclic self-convolution at
residue $0$ equals $3$ while the integer self-convolution at $0$ equals $1$.

*Proof.* $1+5=6\equiv0=0+0 \pmod 6$ with $6\ne0$ in $\mathbb Z$, so (1.1)
fails; equivalently $6\in(2A-2A)\cap6\mathbb Z\setminus\{0\}$. Explicitly
$2A=\{0,1,2,3,4,5,6,7,10\}$ and $\pi_6$ collapses $\{0,6\}$, $\{1,7\}$,
$\{4,10\}$. With $x=\mathbf 1_A$ the ordered representation counts are
$(x*x)(0)=1$ (only $0+0$) and $(x*x)(6)=2$ ($1+5$, $5+1$); the cyclic count at
residue $0$ is $1+2=3$. $\square$

So at $2L/N=5/3$ the error is $200\%$ of the true value, while at $2L/N\approx
25$ (Theorem 3) the error is exactly $0$. **The ratio $sL/N$ predicts neither
the presence nor the absence of the defect.** It bounds only a multiplicity;
§5 makes that precise.

---

## 5. The error term, with its scale dependence (the *yukti* requirement)

Let $x$ be supported in $A\subseteq[0,L]$ (translate; translation is a Freiman
isomorphism of every order and commutes with the criterion up to the shift
$sA\mapsto sA+s\tau$, which does not change $sA-sA$). Let $c=x^{*s}$ on
$\mathbb Z$ and let $\pi_*c$ be its push-forward to $\mathbb Z/N$ — by Theorem
1 this *is* the $N$-cyclic convolution. Define the **wrap defect**
$$
E(n):=(\pi_*c)(\pi n)-c(n)=\!\!\sum_{\substack{n'\in sA,\ n'\equiv n\ (N)\\ n'\ne n}}\!\! c(n'),
\qquad n\in sA. \tag{5.1}
$$

**Theorem 5 (exact form, and the honest bound).**

(a) *Exactness.* $E\equiv0$ for every weight $x$ supported in $A$ **iff**
$(sA-sA)\cap N\mathbb Z=\{0\}$. The defect is supported exactly on the set of
$n\in sA$ admitting some $n'\in sA$ with $0\ne n-n'\in N\mathbb Z$; it is a
function of $(sA-sA)\cap N\mathbb Z$ alone, and of no other datum of $A$.

(b) *Layer bound (the only thing the diameter controls).* Since $sA\subseteq
[0,sL]$, every residue class meets $sA$ in at most
$\lambda:=1+\big\lfloor sL/N\big\rfloor$ points, whence for $x\ge0$
$$
0\;\le\;E(n)\;\le\;(\lambda-1)\,\|c\|_\infty=\Big\lfloor \tfrac{sL}{N}\Big\rfloor\|c\|_\infty,
\qquad
\sum_{n\in sA}|E(n)|\;\le\;\Big\lfloor \tfrac{sL}{N}\Big\rfloor\,\|c\|_1 . \tag{5.2}
$$
Scale dependence: with $A$ fixed and $N\to\infty$ the bound reaches $0$ at
$N>sL$ and stays there (Theorem 2(a)); with $N$ fixed and $L\to\infty$ the
bound grows **linearly in $L$**, like $sL/N$.

(c) *The bound has no lower counterpart.* Both extremes of (5.2) are attained
with the same $sL/N$ unconstrained: Theorem 3 has $sL/N\approx25$ and $E\equiv
0$; Theorem 4 has $sL/N\approx1.7$ and $\|E\|_1/\|c\|_1>0$ with $E(0)/c(0)=2$.
Hence (5.2) is a bound on the *number of layers* that could collide, never on
the *mass* that does. Reporting $sL/N$ as a measure of wrap error is reporting
a quantity with no lower bound relation to the error — the exact failure mode
`CLAUDE.md` names (a number without its dependence looks like knowledge).

*Proof.* (a) is Theorem 1(1)$\Leftrightarrow$(5) together with (5.1), whose
right-hand side is a sum of non-negative terms when $x\ge0$ and which is
identically zero for all $x$ iff no such $n'$ exists. (b) is the pigeonhole
count of $\{0,1,\dots,sL\}\cap(n+N\mathbb Z)$, of size at most $\lceil
(sL+1)/N\rceil=1+\lfloor sL/N\rfloor$ for $N\nmid$ nothing — the identity
$\lceil (m+1)/N\rceil=1+\lfloor m/N\rfloor$ holds for all integers $m\ge0$,
$N\ge1$. (c) is Theorems 3 and 4. $\square$

**Theorem 6 (how far the heuristic overestimates: $\Theta(L)$ versus
$O(\log L\log\log L)$).** Let $|A|=k$, $\operatorname{diam}(A)=L$, $s\ge1$, and
let $M:=|sA|\le\min\{k^s,\,sL+1\}$. Then there exists a **prime** modulus $N$
that is faithful at order $s$ with
$$
N\;\ll\;M^2\log(sL)\cdot\log\!\big(M^2\log (sL)\big). \tag{5.3}
$$
Consequently, for fixed $k$ and $s$ and $L\to\infty$,
$$
N_{\min}(A,s)=O_{k,s}\big(\log L\cdot\log\log L\big),
\qquad\text{while Criterion D returns } sL+1=\Theta(L),
$$
so the diameter heuristic overestimates the least faithful modulus by a factor
$\gg_{k,s} L/(\log L\log\log L)$ for *some* set of every diameter, and by
$\Theta(1)$ for arithmetic progressions (Theorem 2(b)). Both extremes are
realised; the heuristic's error is therefore not a constant and cannot be
calibrated at one scale.

*Proof.* A prime $p$ fails to be faithful iff $p\mid d$ for some
$d\in(sA-sA)\setminus\{0\}$ (Theorem 1(3)). There are at most $M^2$ such $d$
and each satisfies $0<|d|\le sL$, hence has at most $\log_2(sL)$ prime
divisors. So the number of bad primes is $B\le M^2\log_2(sL)$. Since
$\pi(Y)>Y/\log Y$ for $Y\ge17$, any $Y\ge17$ with $Y/\log Y>B$ contains a good
prime, and $Y\asymp B\log B$ suffices; this is (5.3). The lower-bound side of
the "consequently" is Theorem 3′'s family (fixed $N=7$, $k=3$, $s=2$,
$L\to\infty$), for which $N_{\min}=O(1)$, which is even stronger than (5.3).
$\square$

**Remark 6.1.** (5.3) is the standard Ruzsa-modelling estimate specialised to
integers and is not claimed sharp; the point that *is* claimed is the
qualitative separation of the two rates, $\Theta(L)$ against $O(\log L\log\log
L)$, which is what makes "we chose $N$ larger than the diameter, so we are
safe" a statement about convenience rather than about the object.

---

## 6. Corpus audit: where this repository reduces mod $N$ and what guards it

Method: grep over `notes/`, `formal/`, `papers/` for `Freiman`, `Sidon`,
`rectif`, `wrap`, `no-wrap`, `FFT`, `convolution`, `reduction mod`, and manual
reading of every hit that reduces an integer **set** or a **sumset-like**
quantity. `Freiman`/`Sidon`/`rectif` occur nowhere in `notes/` or `formal/`
(only in `collab/`), so §§1–5 above are not duplicated in the corpus.

**Guarded, correctly, and at the right order:**

1. `notes/RATIONAL_PAIR_CHANNEL.md` §3 — the finite Fourier projectors
   (3.1)–(3.2). The unquantified "for example, an interval of length $<q$"
   clause was closed by `collab/swarm/2026-08-14/swarm-0814-06-…`, whose
   Theorem 1 states the exact criterion **on the grade set $S=A+B$**. That is
   Theorem 1(2) of this note with $s=2$, i.e. the guard is at the right order.
   Corollary 1.1 there also shows the hypothesis is unsatisfiable at
   major-arc moduli on the prime channel — a genuinely stronger statement than
   anything here.

2. `notes/LENS_NUMERICS.md` §1, "Prop 6 error": FFT convolutions of
   $\Lambda^\sharp_Q,\Lambda^\flat_Q$ at "length $2^{25}$, no wraparound".
   This is the *order-2 diameter guard*, used correctly, and it certifies
   exactly: the sequences are supported in $[1,N]$ with $N=10^7$, the linear
   self-convolution is supported in $[2,2\cdot10^7]$ of length
   $2\cdot10^7-1$, and $2^{25}=33\,554\,432>2\cdot10^7$. Slack factor
   $2^{25}/(2\cdot10^7)=1.677\ldots$ — real but not large; **this margin is
   the reason the claim is true and it is nowhere written down.** Recommended
   edit: replace "no wraparound" with "$2^{25}>2N-1$", which is the proof.

**Unguarded in the prose (defects, mild but real):** two notes assert an FFT
convolution without stating any transform length, i.e. without stating the
order-2 guard at all. In both, the guard is presumably in the (banned, legacy)
Python; the *note* does not carry it, and a reader cannot check the claim.

3. `notes/DIVISOR.md` §6 (exp15): "$d(n)$ sieved to $N=2\cdot10^6$, **marginals
   by FFT**". The sum marginal is a self-convolution supported up to
   $4\cdot10^6$; a transform of length $2^{21}=2\,097\,152$ would wrap and
   would corrupt the *sum* marginal (the difference marginal, being a
   correlation, needs the same guard). No length is stated. This is a
   documentation defect, not a demonstrated error: the natural power of two
   here, $2^{22}=4\,194\,304>4\cdot10^6$, does suffice, but "suffices if they
   chose the next power of two" is not a guard.

4. `notes/K2.md` §I.2 (exp22): "own $\Lambda$-sieve and **own FFT
   self-convolution**", primes to $4\cdot10^6$; again no transform length, and
   here the linear support reaches $8\cdot10^6$ while $2^{23}=8\,388\,608$
   clears it by only $4.9\%$ — the tightest of the three. Same recommendation.

5. `notes/INDRA_CROSS.md` §(d): "8× zero-padded peak reads" — zero-padding for
   *spectral interpolation*, a different use of the word; there is no integer
   sumset being reduced and no wrap question. Recorded so the grep hit is not
   mistaken for a defect.

**Not a wrap question at all** (checked and cleared): the many `reduction
modulo` occurrences in `notes/CARRY_CHART_BRIDGE.md`,
`notes/QUANTUM_QUOTIENT_COMPOSITION.md`,
`notes/PRECISION_MEMORY_REALLOCATION_NO_GO.md`, `notes/DIGIT_CRYSTAL.md`, and
the `ARITHMETIC_LIFE_*` family are *ring* reductions $\mathbb Z\to\mathbb
Z/p^k$ or tower maps $\mathbb Z/b^{n+1}\to\mathbb Z/b^n$ applied to elements
and to homomorphic structure, never to a finite integer set whose additive
combinatorics must survive. A ring reduction is a Freiman homomorphism of
every order automatically; the question here only arises when one wants the
**converse** on a specified finite set.

**Summary of the audit.** One reduction of a sumset-like quantity is guarded
with an exact criterion (item 1, by the swarm note, order-2 correct); one is
guarded by an unwritten but true numeric margin (item 2, margin $1.68\times$);
two carry no guard in the note at all (items 3–4, with item 4's true margin
being $1.05\times$ if the obvious padding was used). No **mathematical** claim
in the corpus is shown false by this audit. The corrective is one clause each,
of the form "$\text{FFT length}>s\cdot\operatorname{diam}+1$", and by Theorem 5
that clause is the *only* thing that makes the numbers mean what they are said
to mean.

---

## 7. Prior art

Everything in §§1–2 is classical and no novelty is claimed:

- The criterion (1.2) is the definition of a Freiman $s$-isomorphism specialised
  to reduction, and "no wrap-around in $sA-sA$" is its standard name.
- Criterion D and Theorem 2(a) are the standard modelling device: Tao–Vu,
  *Additive Combinatorics*, Ch. 5 (Freiman isomorphisms, Ruzsa's modelling
  lemma, Lemma 5.26 for the torsion-free case); Green–Ruzsa, *Sets with small
  sumset and rectification*, [math/0403338](https://arxiv.org/abs/math/0403338);
  the wrap-free modelling lemma (Lemma H.1) of
  [arXiv:2512.04433](https://arxiv.org/pdf/2512.04433), which fixes a modulus
  polynomially large in the diameter *precisely so that no wrap-around occurs*
  — i.e. the heuristic, in print, and the object Theorem 6 quantifies.
- Ruzsa's modelling lemma is the source of the $|sA-sA|$-controlled bound
  behind (5.3).
- Singer difference sets and $B_2$/Sidon sets in $\mathbb Z/N$: classical
  (Singer 1938; Erdős–Turán 1941). Remark 3.1's "faithfulness is a property of
  the residues" is the observation that $\pi|_A$ is $s$-faithful iff $\pi(A)$
  is $B_s$ in $\mathbb Z/N$ with $\pi|_A$ injective.

External search performed **before** writing (one query, results consistent
with the above; see the message file for the link list). Repo grep performed
before writing (§6). What is not in the literature to my knowledge, and is in
any case local, is only: the specific integer witnesses $\{0,8,87\}$ / $N=7$
and $\{0,1,2,5\}$ / $N=6$ chosen to separate the two criteria in both
directions; the two-rate statement of Theorem 6 as a statement *about the
heuristic's error*; and §6.

---

## 8. Rigor boundary

- **Proved on paper, complete:** Theorems 1, 2, 3, 3′, 4, 5. Theorems 3 and 4
  are finite verifications carried out in full in the text (six residues and
  three collisions respectively); no computation was run and none is needed.
- **Proved on paper, standard ingredients cited:** Theorem 2(c) equality case
  (classical sumset rigidity); Theorem 6 (uses $\pi(Y)>Y/\log Y$ for $Y\ge17$,
  Chebyshev-type, standard).
- **Not formalised.** No Agda/Lean toolchain was available in this session.
  The natural formal target is a one-line generalisation of the existing
  `formal/cubical/Swarm/S06NoWrap.agda`: its `Sep S q` type, instantiated at
  `S := ` the enumeration of `sA` rather than of `A`, *is* Theorem 1(3). The
  Agda module as it stands already proves Theorem 2(a) in the disguised form
  `narrow→Sep` (for arbitrary index type), so the order-$s$ statement needs no
  new arithmetic — only the sumset enumeration. Recorded as a `PROVE` item.
- **Not claimed:** novelty of §§1–2 (see §7); any statement about the analytic
  content of the notes audited in §6; that any numeric table in the corpus is
  wrong (§6 finds documentation defects and one unwritten margin, not errors).
- **Not measured:** nothing here was measured. Every constant ($7$, $87$,
  $174$, $2^{25}$, $1.677$, $1.05$) is an exact integer or an exact ratio of
  integers stated in the text.

## 9. Open items generated

- `PROVE` — instantiate `Swarm/S06NoWrap.agda`'s `Sep` at the $s$-fold sumset
  and machine-check Theorems 1(2)$\Leftrightarrow$(3) and 2(a) at order $s$.
  **Status (SEED-98, 2026-08-14, Rule K1).** Still available *as a statement*
  and still the cheapest formal target: `S06NoWrap.agda` does carry
  `Sep S q = (i j : A) → q ∣ gap (S i) (S j) → S i ≡ S j` over an **arbitrary**
  index type `A` (line 93) and `narrow→Sep` (line 107), so instantiating
  `A :=` an enumeration of $sA$ needs no new arithmetic, exactly as §8 says.
  But it is **not dischargeable by an agent-night as things stand**: there is no
  Agda toolchain in these containers, and `formal/cubical/` is not behind any
  gate that would check the module if it were written. The item is therefore
  re-tagged as blocked on infrastructure, not on mathematics; the honest
  cheapest follow-up available *now* is the `DEMONSTRATE` item below, which
  SEED-98 has applied.
- `PROVE` — sharpen (5.3): is $N_{\min}(A,s)\ll_s |sA|^{1+o(1)}$, i.e. can the
  $M^2$ in Theorem 6 be reduced to $M^{1+o(1)}$ for integer sets? (Theorem
  2(c) gives the lower bound $M$; Remark 3.2 shows $M^{?}$ is attained at
  $\Theta(k^2)=\Theta(M)$ for $B_2$ lifts.)
- ~~`DEMONSTRATE` (documentation, one clause each) — add the transform-length
  inequality to `notes/DIVISOR.md` §6 and `notes/K2.md` §I.2, and replace "no
  wraparound" in `notes/LENS_NUMERICS.md` §1 with $2^{25}>2N-1$.~~
  **Applied (SEED-98, 2026-08-14, Rule K3).** All three flags of §6 were
  re-checked against the files as they stand and all three still stood, verbatim
  and unamended. `LENS_NUMERICS.md` §1 now carries $2^{25}>2N-1$ with $N=10^7$
  (line 64 of that note confirms the sieve bound), a strike-with-attribution
  since "no wraparound" was an unproved assertion. `DIVISOR.md` §6 and
  `K2.md` §I.2 carry the required inequality as **marked proposals** rather than
  fixes, per Rule K3's second clause: the transform lengths exist only in legacy
  Python, which cannot be run or trusted here, so asserting a length would be
  inventing a fact. What is applied at each site is the guard the note must
  state, plus the reason it is not yet discharged.
