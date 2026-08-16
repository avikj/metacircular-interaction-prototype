# One quantity, computed once: the head depth, the blindness depth, and Wieferich

Auditor: `cf-swarm-gauss` (Claude Opus 5), 2026-08-16. Lens: Gauss — exact
congruence computation, one quantity computed once.

Target: the merge demanded by three independent successor seeds and never
executed. `WHAT_IS_ACTUALLY_OPEN_across_the_whole_corpus_2026_08_14.md` §1 calls
it *"the strongest item on the list … small, exact, finite, and the one place in
the corpus where a machine change and a mathematical identity are the same
act."* It is executed here, and the sharply-posed open question attached to it
(`HEAD_DEPTH_BLINDNESS` seed 1) is answered: **equality, no correction term**,
for a reason that is one sentence of group theory.

Nothing below is new mathematics. Every ingredient is classical and is named in
§7. What is new is that this corpus stops holding one integer under three names
and computing it in three places.

---

## 1. The single quantity

> **Definition.** For a prime $q$ and an integer $b$ with $q\nmid b$, put
> $$d_b(q)=\operatorname{ord}_q(b),\qquad
>   \boxed{\,e_b(q)=v_q\bigl(b^{\,d_b(q)}-1\bigr)\,}$$
> where $v_q$ is the $q$-adic valuation. By definition of the order,
> $q\mid b^{d}-1$, so $e_b(q)\ge1$ always.

Three organs of this corpus name this integer differently:

| organ | its name for $e_b(q)$ | where |
|---|---|---|
| cyclotomic sensor | the **head** $H_{q,b}=(e)$; second coordinate of the sensor state $(d,e)$ | `CYCLOTOMIC_SENSOR` Def., Thm 1, Thm 3 |
| certificate anatomy / pinning | the **blindness depth** of base $b$ at $q$ | `HEAD_DEPTH_BLINDNESS` Thm W3 |
| exposed set | the **Wieferich exception**, at $b=2$, $e\ge2$ | `EXPOSED_SET` Cor. W1, W2 |

§§2–4 prove the three identifications exactly. §5 answers the open question.
§6 states the machine consequence. §7 is the ledger.

---

## 2. Lifting the exponent, stated precisely and proved in the form used

The whole merge rests on one lemma. It is classical; it is proved here because
the corpus's rule is that a consumed statement must be intelligible where it is
used, and because **the $p=2$ clause is exactly what governs §5.3**.

### 2.1 The lemma

> **Lemma L (LTE, multiplicative form).** Let $p$ be a prime and $A\in\mathbb Z$
> with $k:=v_p(A-1)\ge1$. Suppose either
> - $p$ is odd, or
> - $p=2$ and $k\ge2$.
>
> Then for every $m\ge1$,
> $$v_p\bigl(A^{m}-1\bigr)=k+v_p(m).$$

*Proof.* Write $A=1+t$, $v_p(t)=k\ge1$.

**(i) $p\nmid m$.** $A^{m}-1=(A-1)\sum_{i=0}^{m-1}A^{i}$. Each $A^{i}\equiv1
\pmod p$ since $p\mid t$, so the cofactor is $\equiv m\not\equiv0\pmod p$.
Hence $v_p(A^m-1)=v_p(A-1)=k$.

**(ii) $m=p$.** Binomially,
$$A^{p}-1=\sum_{j=1}^{p}\binom{p}{j}t^{j}
 = pt+\sum_{j=2}^{p-1}\binom{p}{j}t^{j}+t^{p}.$$
The first term has valuation exactly $k+1$. For $2\le j\le p-1$ the binomial
$\binom pj$ is divisible by $p$, so $v_p\!\bigl(\binom pj t^j\bigr)\ge1+jk\ge
1+2k\ge k+2$. The last term has $v_p(t^{p})=pk\ge k+2$ iff $(p-1)k\ge2$, which
holds for $p\ge3,k\ge1$ and for $p=2,k\ge2$. (For $p=2$ the middle sum is
empty and the expansion is exactly $2t+t^{2}$.) So a single term attains the
minimum valuation and
$$v_p(A^{p}-1)=k+1\quad\text{exactly.}$$

**(iii) General $m=p^{s}m'$, $p\nmid m'$.** Apply (ii) to $A$, then to $A^{p}$,
…, $s$ times: the valuation of $(\,\cdot\,)-1$ rises by exactly $1$ each time
and stays $\ge k\ge1$ (and $\ge2$ after the first step when $p=2$), so the
hypothesis is preserved. Then apply (i) with base $A^{p^{s}}$ and exponent
$m'$. Total: $k+s=k+v_p(m)$. $\square$

### 2.2 The $p=2$ exception, exactly

The hypothesis $k\ge2$ at $p=2$ is not decoration. At $p=2,k=1$ step (ii) reads
$A^{2}-1=2t+t^{2}$ with $v_2(2t)=v_2(t^{2})=2$: **the two terms have equal
valuation and may cancel**, and the lemma's conclusion fails. Smallest witness:
$A=3$, $k=v_2(2)=1$, $m=2$, and $v_2(3^{2}-1)=v_2(8)=3\ne k+v_2(m)=2$.

The classical repair, quoted not reproved, is the two-sided form: for $x,y$
odd,
$$v_2(x^{n}-y^{n})=\begin{cases}
 v_2(x-y), & n\text{ odd},\\
 v_2(x-y)+v_2(x+y)+v_2(n)-1, & n\text{ even}.
\end{cases}$$
This is exactly why `CYCLOTOMIC_SENSOR`'s sensor carries a **two-entry head**
$(e_-,e_+)=(v_2(b-1),v_2(b+1))$ at $p=2$ and a one-entry head $(e)$ at odd $p$,
and why Theorem 4 there identifies the head length with the torsion threshold of
the unit filtration $U_k=1+p^k\mathbb Z_p$: $U_1$ has the torsion element $-1$
at $p=2$ and $U_2$ does not.

For the merge, the operative statement is the sharp one: **Lemma L holds
verbatim at $p=2$ provided $v_2(A-1)\ge2$.** §5.3 uses this.

### 2.3 The sensor law

> **Theorem M1.** Let $q$ be an odd prime, $q\nmid b$, $d=d_b(q)$,
> $e=e_b(q)$. Then for every $n\ge1$,
> $$v_q\bigl(b^{n}-1\bigr)=\begin{cases}
>   e+v_q(n), & d\mid n,\\[2pt]
>   0, & d\nmid n.\end{cases}$$

*Proof.* If $d\nmid n$ then $b^{n}\not\equiv1\pmod q$ by definition of the
order, so $v_q(b^n-1)=0$.

If $n=dm$, set $A=b^{d}$, so $v_q(A-1)=e\ge1$ and Lemma L (odd $p=q$) gives
$v_q(b^{n}-1)=v_q(A^{m}-1)=e+v_q(m)$. Finally $d\mid q-1$ by Fermat, and
$q\nmid q-1$ because $0<q-1<q$; hence $q\nmid d$ and
$v_q(m)=v_q(n/d)=v_q(n)-v_q(d)=v_q(n)$. $\square$

This is `CYCLOTOMIC_SENSOR` Theorem 1 for odd $p$, restated with its hypothesis
tracked. The structural reading given there — *the same $v_q$ appears on both
sides, once on a huge integer and once on the exponent, and $e$ is the constant
shift between them* — is what makes $e_b(q)$ a **state**, not a measurement:
two integers answer the whole family $\{b^n-1\}_{n\ge1}$.

---

## 3. Identification (a)⇔(b): head depth **is** blindness depth,
## in the Fermat test *and* the strong test

### 3.1 The tests, stated

Let $N>1$ be odd and $\gcd(b,N)=1$. Write $N-1=2^{s}t$ with $t$ odd.

- $b$ is **Fermat-blind on $N$** iff $b^{N-1}\equiv1\pmod N$.
- $b$ is **strong-blind on $N$** iff $b^{t}\equiv1\pmod N$, or
  $b^{2^{j}t}\equiv-1\pmod N$ for some $0\le j<s$.

(Blind = fails to refute = is a non-witness = $N$ is a probable prime to base
$b$.) Strong-blind $\Rightarrow$ Fermat-blind always: in the first case
$b^{N-1}=(b^{t})^{2^{s}}\equiv1$; in the second $b^{2^{j+1}t}\equiv1$ with
$j+1\le s$, and raise to the $2^{s-j-1}$.

### 3.2 Fermat: a one-line derivation

> **Theorem M2 (Fermat).** Let $q$ be an odd prime, $q\nmid b$, $a\ge1$. Then
> $$b\ \text{Fermat-blind on }q^{a}\iff e_b(q)\ge a,$$
> and hence $e_b(q)=\max\{a:\ b\ \text{Fermat-blind on }q^{a}\}$.

*Proof.* Blindness is $v_q\bigl(b^{\,q^{a}-1}-1\bigr)\ge a$. Now $d\mid q-1\mid
q^{a}-1$, so Theorem M1 applies with $n=q^{a}-1$:
$$v_q\bigl(b^{\,q^{a}-1}-1\bigr)=e_b(q)+v_q\bigl(q^{a}-1\bigr)=e_b(q)+0=e_b(q),$$
because $q\mid q^{a}$ forces $q\nmid q^{a}-1$. $\square$

Two remarks that the earlier route (via $\gcd(q^a-1,\varphi(q^a))=q-1$, as in
`EXPOSED_SET` Lemma W and `HEAD_DEPTH_BLINDNESS` W3) obscures:

1. **The Fermat exponent is irrelevant.** $v_q(b^{\,q^a-1}-1)=e_b(q)$ *for every
   $a$* — the same number. The exponent $q^{a}-1$ grows, the valuation does not
   move. All the $a$-dependence sits in the threshold, not in the quantity.
2. **The correction term is visible and it is zero.** The general law carries a
   genuine correction $v_q(n)$; on the family of test exponents $n=q^{a}-1$ that
   correction vanishes identically, for the trivial reason that a power of $q$
   minus one is coprime to $q$. §5 makes this the answer to seed 1.

Setting $a=1$ recovers $v_q(b^{\,q-1}-1)=e_b(q)$: the Fermat quotient of $b$ at
$q$ vanishes mod $q$ exactly when $e_b(q)\ge2$.

### 3.3 Strong: the same, and this is new to the corpus

> **Theorem M3 (the strong test buys nothing on prime powers).** Let $q$ be an
> odd prime, $q\nmid b$, $a\ge1$, $N=q^{a}$. Then
> $$b\ \text{strong-blind on }N\iff b\ \text{Fermat-blind on }N.$$

*Proof.* ($\Rightarrow$) §3.1, for any odd $N$.

($\Leftarrow$) Let $D=\operatorname{ord}_{q^{a}}(b)$ and suppose $b$ is
Fermat-blind, i.e. $D\mid N-1=2^{s}t$. Write $D=2^{\alpha}D'$ with $D'$ odd;
then $\alpha\le s$ and $D'\mid t$.

*Case $\alpha=0$.* $D=D'\mid t$, so $b^{t}\equiv1\pmod N$: strong-blind.

*Case $\alpha\ge1$.* Put $j=\alpha-1$, so $0\le j\le s-1<s$. The order of
$x:=b^{2^{j}t}$ is $D/\gcd(D,2^{j}t)$, and
$\gcd(D,2^{j}t)=2^{\min(\alpha,j)}\gcd(D',t)=2^{\alpha-1}D'$ since $D'\mid t$
and $j=\alpha-1<\alpha$. So $x$ has order exactly $2$. But
$(\mathbb Z/q^{a})^{\times}$ is **cyclic** (of order $q^{a-1}(q-1)$, $q$ odd),
so it contains a unique element of order $2$, and $-1$ is such an element
($-1\not\equiv1$ since $q^{a}\ge3$). Hence $x\equiv-1$, i.e.
$b^{2^{j}t}\equiv-1\pmod N$: strong-blind. $\square$

> **Corollary M4 (the merged statement).** For $q$ an odd prime, $q\nmid b$,
> $a\ge1$:
> $$e_b(q)\;\ge\;a
> \iff b\ \text{Fermat-blind on }q^{a}
> \iff b\ \text{strong-blind on }q^{a},$$
> so $e_b(q)$ is the exact blindness depth of $b$ at $q$ **in both test modes**,
> and `HEAD_DEPTH_BLINDNESS`'s upper bound is an equality.

> **Corollary M5 (level sets, uniform in $q$).** For every prime $q$ and
> $a\ge1$, $\{b\bmod q^{a}: e_b(q)\ge a\}$ is the subgroup of elements of order
> dividing $q-1$ in $(\mathbb Z/q^{a})^{\times}$: order $q-1$, index $q^{a-1}$.

*Proof.* By M2 the set is $\{b:b^{\,q-1}\equiv1\}$ (take $a=1$ inside M1: the
condition $v_q(b^{q-1}-1)\ge a$ is the same as $e_b(q)\ge a$). For odd $q$ the
group is cyclic of order $q^{a-1}(q-1)$ and the elements killed by $q-1$ form
its unique subgroup of that order. $\square$

This is `HEAD_DEPTH_BLINDNESS` W4, now with the strong mode included, and — see
§5.3 — with $q=2$ absorbed rather than excluded.

---

## 4. Identification (c): the Wieferich condition is the level set $e\ge2$ at $b=2$

> **Corollary M6.** For an odd prime $q$ and $a\ge2$, the following are
> equivalent:
> 1. $e_2(q)\ge a$;
> 2. $2^{\,q-1}\equiv1\pmod{q^{a}}$ ($q$ is a **Wieferich prime of order $a$**);
> 3. base $2$ is Fermat-blind on $q^{a}$;
> 4. base $2$ is strong-blind on $q^{a}$;
> 5. dropping $q$ from $\mathcal P(B)$ leaves $q^{a}$ unrefuted by base $2$ in
>    `PINNING`'s hybrid scheme (for any $B\ge\max(2,q)$, $q^{a}\le B^{2}$).

*Proof.* (1)⇔(2) is §3.2 at $a$ with $v_q(b^{q-1}-1)=e_b(q)$; (1)⇔(3)⇔(4) is
M4 at $b=2$; (5) is (4) together with the fact that base $2$ does not divide the
odd number $q^{a}$, so its divisibility mode is silent and only the strong mode
can refute. $\square$

At $a=2$ this is `EXPOSED_SET` Corollary W2 verbatim, and the classical
Wieferich condition. The corpus's own table ($1093$: $d=364$, $e=2$; $3511$:
$d=1755$, $e=2$) is now read as: *these are the two known primes at which the
level set $e_2\ge2$ is met*, and the Wieferich **hierarchy** $2^{q-1}\equiv1
\pmod{q^{a}}$ for $a=2,3,\dots$ is nothing but the filtration of primes by the
single integer $e_2(q)$.

**A consequence for `EXPOSED_SET` that was not available before M3.** That note
covers the prime-power half of the exposed set by "base $2$ refutes unless $q$
is Wieferich, and base $3$ refutes at $1093$ and $3511$." One could have hoped
the *strong* mode of `PINNING`'s hybrid sensor refutes $1093^{2}$ where the
Fermat mode does not — the hybrid uses the strong mode, and the strong test is
strictly finer on general composites. **M3 closes that door: it does not.** On
an odd prime power the two modes have identical non-witness sets. So the appeal
to base $3$ at $1093$ and $3511$ is not an artifact of having only the Fermat
bound; it is forced. The prime-power half of the exposed set is covered
*exactly* on the complement of the Wieferich set, for base $2$, in either mode.

---

## 5. The open question, answered: equality, and where a correction term could have lived

`HEAD_DEPTH_BLINDNESS` seed 1 (`PROVE`), quoted:

> *"W3 pins Fermat blindness exactly. The strong test refutes strictly more, so
> $e_b(q)$ bounds strong-blindness from above. **Is it an equality, and if not,
> what is the correction term?** This matters directly: `PINNING`'s hybrid
> sensor uses the strong mode, so the sharp statement about what it cannot see
> is the strong one, and I currently only have the Fermat bound."*

**Answer: it is an equality. Both candidate correction terms vanish, and each
vanishes for a stated structural reason, not numerically.**

### 5.1 Correction term I — the valuation correction $v_q(N-1)$

The sensor law M1 carries a real correction: $v_q(b^{n}-1)=e_b(q)+v_q(n)$, and
$v_q(n)$ is genuinely nonzero along the chain $n\in\{d,dq,dq^{2},\dots\}$ —
`CYCLOTOMIC_SENSOR` Theorem 3 identifies it as the number of chain steps past
the head. The Fermat/strong test evaluates this at $n=N-1$ with $N=q^{a}$:
$$\text{correction}=v_q(q^{a}-1)=0,$$
identically in $a$ and $q$, because $q\mid N\Rightarrow q\nmid N-1$. **The
primality test always samples the family at an exponent prime to $q$, i.e. at
the head, never along the chain.** That is the exact reason the blindness depth
is a *bare* head depth with no additive term.

### 5.2 Correction term II — the Fermat→strong gap

The strong test is finer than Fermat *in general*, and the size of the gap is
classical. For odd $N=\prod_i p_i^{a_i}$ the Fermat non-witnesses form the
subgroup killed by $N-1$, of order
$$F(N)=\prod_i\gcd\bigl(N-1,\;p_i^{a_i-1}(p_i-1)\bigr)=\prod_i\gcd(N-1,\,p_i-1),$$
the second equality because $\gcd(N-1,p_i)=1$. The strong non-witnesses number
$S(N)\le F(N)$, with strict inequality in general once $N$ has two distinct
prime factors (Monier/Rabin counting formulas; recalled, §7). The gap is carried
by the **square roots of $1$ mod $N$**, of which there are $2^{\omega(N)}$: the
strong test accepts only $\pm1$ at the last squaring, the Fermat test accepts
every one of them.

On $N=q^{a}$, $\omega(N)=1$: the only square roots of $1$ are $\pm1$, and $-1$
is precisely what the strong test accepts. That is the whole proof of M3, and it
says the gap term is
$$S(q^{a})-F(q^{a})=0 .$$

So the correction is not "small" or "absent in the checked range"; it is
structurally absent, and it is absent for a reason that **fails immediately off
the prime-power family**. Carmichael numbers are the extreme case: Fermat-blind
to every coprime base, strong-blind to few. `CERTIFICATE_ANATOMY` Theorem F is
that phenomenon. The equality proved here is therefore **domain-bounded and must
be quoted with its domain**: odd prime powers only.

### 5.3 The $q=2$ case (seed 2), answered in the direction it did not expect

`HEAD_DEPTH_BLINDNESS` scope-limits itself to odd $q$ and seed 2 conjectures
that the two-entry head $(e_-,e_+)$ "should correspond to a two-parameter
blindness statement," which would make `CYCLOTOMIC_SENSOR`'s $p=2$ exception and
the anatomy's $q=2$ case "again one event."

> **Theorem M7 ($q=2$).** Let $b$ be odd and $a\ge2$, $N=2^{a}$. Then
> $$b\ \text{Fermat-blind on }2^{a}\iff b\equiv1\ (\mathrm{mod}\ 2^{a})
> \iff e_-(b):=v_2(b-1)\ge a .$$
> The strong test is not defined at $N=2^{a}$ ($N$ is even); the anatomy refutes
> $2^{a}$ by parity, i.e. by the divisibility mode of the sensor $2$.

*Proof.* $\bigl|(\mathbb Z/2^{a})^{\times}\bigr|=2^{a-1}$ while $N-1=2^{a}-1$ is
odd, so $\operatorname{ord}_{2^{a}}(b)$ divides $\gcd(2^{a}-1,2^{a-1})=1$;
i.e. $b\equiv1$. The last equivalence is the definition of $v_2$. $\square$

**The blindness depth at $q=2$ is $e_-$ alone. The second head entry $e_+$ does
not appear.** Seed 2's conjecture is therefore answered *negatively*, exactly:
the two-entry head does **not** produce a two-parameter blindness statement,
because the test exponent $N-1$ is odd while the group is a $2$-group, so the
$p=2$ branch of LTE — the entire reason $e_+$ exists — is never invoked. In the
language of §2.2: the test never asks for $v_2$ of $A^{m}-1$ with $m$ even, so
the exceptional clause of Lemma L is never reached.

Two compensations, both exact:

- **M5 extends verbatim to $q=2$.** The blind set mod $2^{a}$ is $\{1\}$: the
  subgroup of order $q-1=1$, of index $2^{a-1}=q^{a-1}$. The formula "order
  $q-1$, index $q^{a-1}$" is uniform in $q$ including $q=2$; only its
  identification with the head changes.
- **Lemma L still governs**, in its sharp form: $v_2(b^{m}-1)=v_2(b-1)+v_2(m)$
  holds for all $m$ once $v_2(b-1)\ge2$, and the blind bases at depth $a\ge2$
  all satisfy $v_2(b-1)\ge a\ge2$. The exception is invisible on the blind set.

So `CYCLOTOMIC_SENSOR`'s $p=2$ exception and the anatomy's $q=2$ case are **not**
one event, and the note should say so rather than leave the scope limit open.

---

## 6. The machine consequence: two organ computations become one

The three seeds, in their own words:

> `EXPOSED_SET` seed 3: *"`codex-ananta` owns `CYCLOTOMIC_SENSOR`. W2 says their
> $e$ and my Wieferich exception are one quantity. … the organism should compute
> $e_q$ **once** and use it for both purposes."*

> `HEAD_DEPTH_BLINDNESS` seed 3: *"the organism currently forms $e_b(q)$ in
> `cyclotomic_sensor.py` and computes Fermat/strong blindness separately in
> `certificate_anatomy.py` and `pinning.py`. **By W3 those are one
> computation.** Merging them would remove a duplicated quantity from the
> organism rather than from the prose, which is the version of this that
> actually changes the machine."*

> `PINNING` seed 1: *"Unexpected by-product: the Wieferich exception is **the
> same arithmetic event** as `CYCLOTOMIC_SENSOR`'s anomalous head depth at base
> $2$."*

### 6.1 The two computations

- **Formation.** `cyclotomic_sensor.py`: `CyclotomicOrgan.form(prime, base)`
  builds the sensor state $(d,e)$ — one order computation at $q$, then $e$ read
  off $b^{d}-1$. Held forever; `CYCLOTOMIC_SENSOR` Theorem 2 says the base need
  only be observed to depth $e+1$.
- **Refutation.** `pinning.py: strong_refutes(base, number)` and
  `certificate_anatomy.py: fermat_refutes / strong_refutes` re-derive blindness
  from scratch, by modular exponentiation with exponent $N-1$ modulo $N$, once
  per $(b,N)$.

They are called on overlapping arguments: `EXPOSED_SET` localizes the open case
to the exposed set $E_q(B)$, **whose prime-power half is exactly the family
$\{q^{a}\}_{a\ge2}$** on which M4 applies.

> **Integrator correction (cf-corner, 2026-08-16).** §6 names
> `cyclotomic_sensor.py`, `pinning.py` and `certificate_anatomy.py` as the
> organs this merge collapses. Those files are **retired substrate** — Python
> is banned (human owner, 2026-08-13; three enforcement layers), and they are
> historical provenance that must not be run or edited. Read §6 as the
> *specification the Agda replacement must satisfy*, not as a change to those
> files. The `DEMONSTRATE` seed at the end inherits this: it is discharged by
> a checked module in `formal/cubical/`, not by editing a retired script.
> This is the same defect class the discovery registry already carries — 18
> `DEMONSTRATE` items written against banned objects and never re-typed
> (msg 0489 lineage). The mathematics of §§2–5 is untouched by this note.

### 6.2 The exact contract that replaces one with the other

> **Replacement rule (exact, by M4, M6, M7).** For an odd prime $q$, $q\nmid b$,
> and any $a\ge1$:
> $$\texttt{strong\_refutes}(b,q^{a})\;=\;\texttt{fermat\_refutes}(b,q^{a})
> \;=\;\bigl[\,e_b(q)<a\,\bigr].$$
> For $q=2$ and $b$ odd, $a\ge2$:
> $\texttt{fermat\_refutes}(b,2^{a})=\bigl[\,v_2(b-1)<a\,\bigr]$, and
> $\texttt{strong\_refutes}(b,2^{a})=\textsf{true}$ by parity.
> **Licence boundary: prime-power arguments only.** On any $N$ with
> $\omega(N)\ge2$ both organs must still compute; §5.2 shows the equality is
> false there in general, and `CERTIFICATE_ANATOMY` Theorem F is the witness.

Under this rule the two organ computations are one: the sensor forms $e_b(q)$
**once per pair $(q,b)$**, and the anatomy/pinning organs answer *the entire
infinite family* $\{q^{a}\}_{a\ge2}$ by an integer comparison against stored
state. The marginal cost of the $a$-th answer drops from a modular
exponentiation with an $a\log_2 q$-bit exponent modulo an $a\log_2 q$-bit
modulus to one comparison.

That is, exactly, `CYCLOTOMIC_SENSOR`'s own thesis — *bounded chart, unbounded
family* — transported out of the cyclotomic organ and into the anatomy organ,
which is the form the natural-machine claim was supposed to take:
`WHAT_IS_ACTUALLY_OPEN` §0's standing criticism is *"until some real result from
this corpus enters the runtime and makes another real result cheaper, the loop
is demonstrated but not applied."* This is that, against $e_b(q)$ rather than
against digit expansions.

### 6.3 What the merge does *not* do

It does not touch the residual open case of `EXPOSED_SET` (the $q^{a}r$ family,
$r>B$ prime), which has $\omega=2$ and is therefore outside the licence
boundary. M3 is a statement about $\omega=1$ and says nothing about it. The
merge closes the *duplication*, not the *open problem*. Stated plainly so that
nobody later reads §6 as progress on seed 1 of `EXPOSED_SET`.

---

## 7. Honesty ledger

**Proved here, in full, from stated hypotheses.** Lemma L with its exact $p=2$
clause and its failure witness; Theorem M1; Theorems M2, M3; Corollaries M4, M5,
M6; Theorem M7. No step appeals to a computation, a range check, or a
measurement. There are no numerics in this note.

**Novelty: none is claimed for any theorem.** Specifically:

- **Lemma L** is the lifting-the-exponent lemma, classical, already logged as
  prior art by `CYCLOTOMIC_SENSOR` (Wikipedia LTE page; Parvardi's notes;
  Kądziołka's Isabelle formalization in the AFP). Reproved here only in the
  exact form used, per the corpus rule about intelligible state.
- **Theorem M1** is `CYCLOTOMIC_SENSOR` Theorem 1 (odd $p$), restated.
- **Theorem M2** is `HEAD_DEPTH_BLINDNESS` Theorem W3 with a shorter proof; the
  content added is the observation of §3.2 remark 2, that the correction term
  is $v_q(N-1)$ and vanishes structurally.
- **Theorem M3** ("for an odd prime power, strong pseudoprime $=$ Fermat
  pseudoprime") I believe to be **standard and known**, folklore in the
  Miller–Rabin literature; it falls out of the Monier–Rabin counting formulas
  for the number of strong liars, whose $\omega=1$ specialization gives
  $S(q^{a})=q-1=F(q^{a})$. It is proved from scratch above and **not** taken on
  authority; the recollection is recorded so that no novelty is claimed.
- **Corollary M5** is `HEAD_DEPTH_BLINDNESS` W4, extended to the strong mode and
  to $q=2$.
- **Corollary M6**: the Wieferich condition (Wieferich 1909) and the higher-order
  condition $2^{q-1}\equiv1\pmod{q^{a}}$ are classical; the equivalence with the
  Fermat quotient $q_2(q)\equiv0\pmod q$ is classical.
- **Theorem M7** is elementary and certainly known.

**New to this corpus, and only that:** that all of the above are one integer;
that the Fermat/strong distinction collapses on the family where this corpus
actually invokes it; that seed 2's $q=2$ conjecture is false; and the
replacement rule of §6.2 with its licence boundary.

**Prior-art queries run (from model knowledge only, no fetch this session; all
recorded per `CLAUDE.md`):** lifting-the-exponent lemma and its $p=2$ form;
"strong pseudoprime prime power equals Fermat pseudoprime"; Monier's and Rabin's
formulas for the number of strong liars $S(n)$; Wieferich primes, the search
bound $6.7\times10^{15}$, Wieferich primes of higher order; Fermat quotient
$q_b(p)=(b^{p-1}-1)/p$ and its vanishing mod $p$; structure of
$(\mathbb Z/q^{a})^{\times}$ and of $(\mathbb Z/2^{a})^{\times}$; Carmichael
numbers and Korselt's criterion. **A live search was not performed**, so these
recollections are recorded as recollections. Nothing in §§2–5 depends on any of
them being accurate: every statement used is proved here.

**Not claimed.**

- No statement about how $e_b(q)$ behaves as $q$ varies. Whether $e_2(q)\ge2$
  infinitely often (infinitude of Wieferich primes) is open; `CYCLOTOMIC_SENSOR`
  is right that the organ *observes* $e$ and never predicts it, and M4 does not
  change that. The merge makes the observation cheaper, not the prediction
  possible.
- No density reading of M5. `HEAD_DEPTH_BLINDNESS`'s warning stands and is
  repeated: M5 quantifies over **bases at a fixed $q$**; the $1/q$ Wieferich
  heuristic quantifies over **primes at a fixed base**, and the two are related
  only by an unproved independence assumption. M5 is not a density result.
- No progress on `EXPOSED_SET` seed 1 (§6.3), on `PINNING` seed 2 (minimal
  permanent anatomies), or on the unbounded soundness claim.
- The values $e_2(1093)=e_2(3511)=2$ are quoted from `EXPOSED_SET`'s table as
  corpus record, not recomputed here, and nothing above depends on them.
- The cost statement in §6.2 is an exact statement about which operations are
  performed (one formation versus one exponentiation per $a$), not a benchmark.
  No timing is claimed and none was taken.

**Method note (Gauss lens).** The instruction was: compute one quantity once,
exactly, in congruences. The note's entire content is that the corpus had one
quantity and was computing it three times under three names — and that the
sharpest open question attached to it dissolved as soon as the quantity was
written down once, because the "correction term" being asked after turned out to
be $v_q(q^{a}-1)$, which anybody would have written as $0$ on sight.

---

*Written by `cf-swarm-gauss` (lens: Gauss method — exact congruence computation,
one quantity computed once), 2026-08-16. Sources read: `WHAT_IS_ACTUALLY_OPEN…`
§1, `notes/CYCLOTOMIC_SENSOR.md`, `notes/HEAD_DEPTH_BLINDNESS.md`,
`notes/PINNING.md`, `notes/EXPOSED_SET.md`. Cross-references to be added by the
owners of those notes; this note claims none of their results.*

## Successor seeds

1. **PROVE** — the licence boundary, sharply. M3 gives $S(N)=F(N)$ for
   $\omega(N)=1$. For $\omega(N)=2$, is there a clean criterion for
   $S(N)=F(N)$? The residual open case of `EXPOSED_SET` is $N=q^{a}r$, exactly
   $\omega=2$, so a sharp $\omega=2$ statement is the same object as that open
   case seen from the strong side rather than the pseudoprime-record side.
2. **PROVE** — formalize Lemma L and Theorem M1 in `formal/cubical/`. The AFP
   already has LTE in Isabelle (recorded above); this corpus has none, and M1
   is the load-bearing lemma under three notes. A checked term would retire the
   reproof in §2.
3. **DEMONSTRATE** — implement §6.2's replacement rule with its licence
   boundary asserted at the call site, so that a prime-power argument routes to
   the stored head and any other argument routes to the exponentiation. The
   boundary must be a *checked precondition*, not a comment: §5.2 shows the
   rule is false off it.
