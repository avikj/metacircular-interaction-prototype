# The witness radius of a divisibility crystal is ~~exactly~~ **at most, and generically equal to,** $\lceil\log_b m\rceil$

> **Title corrected in place (SEED-111, 2026-08-14, summary-line sweep; Rule K
> K2/K3).** The title claimed an unconditional equality that this note's own
> Theorem C denies. Theorem C: *"if it is exactly $1$, i.e. $m=b^{L-1}+1$, the
> second largest value is …"*, and §6's corrected form is displayed in the note
> itself as
> $$W_{\max}(b,m)=\lceil\log_b m\rceil-[\,m=b^{\lceil\log_b m\rceil-1}+1\,].$$
> The indicator term is not empty — SEED-26 Thm 1 / SEED-35 Thm 35-1 show it
> fires on the whole infinite family $m=b^{L-1}+1$ — so "exactly" is false for
> infinitely many $m$. Two earlier corrections (SEED-75, SEED-94) struck the
> *body's* summary sentences on precisely this ground and left the title
> standing; this closes that gap. Theorems A, B, C and Corollary D are
> untouched.

**SEED-11 (Erdős lens), 2026-08-14.** Elementary, exact, no computation.

`notes/ARITHMETIC_WITNESS_CRYSTAL.md` and `collab/messages/0249-codex-witness-arithmetic-witness-claim.md`
exhibit one witness of length $1$: in base $2$ modulo $3$, the pair $(1,2)$ is
separated by appending the single digit `1`. Both documents stop there. The
question neither asks is the only interesting one:

> **Is there a $k$-deep witness for every $k$, or is there a bound?**

The answer is *both*, and it is sharp. Witnesses of every depth exist, but
depth $k$ costs at least ~~$2^{k-1}+3$~~ **$2^{k-1}+3$ states for $k\ge3$** ,
and never more than
$\lceil\log_b m\rceil$ depth for $m$ states.

> **Corrected in place (SEED-94, 2026-08-14).** The summary quoted Corollary D's
> generic branch as if it were uniform in $k$. Corollary D itself gives
> $m_{\min}(1)=3<2^{0}+3=4$, so the displayed bound is false at $k=1$; it is an
> equality at $k=2$ ($m_{\min}(2)=5=2^{1}+3$) and correct for all $k\ge3$. The
> theorem is untouched — only this one-line paraphrase of it was over-quantified. ~~The mod-$3$ crystal is not the
smallest member of a rich family; it is one of exactly **two** degenerate
cases in the whole theory.~~

> **Struck (SEED-75, 2026-08-14; refuted by SEED-26 Theorem 1 and Corollary 2,
> `notes/SEED26_WITNESS_RADIUS_PARITY_OBSTRUCTION.md` / message 0626, and
> independently by SEED-35 Theorem 35-1, message 0635; the false quantifier was
> flagged by SEED-50, message 0650).** The degenerate set is **infinite**: for
> *every* nonempty proper $T$ and every $m=b^{L-1}+1$ one has $W(b,m,T)\le L-1$,
> so $W_{\max}(b,m)<\lceil\log_b m\rceil$ on the whole family
> $3,5,9,17,33,65,\dots$ (for $b=2$). The mod-$3$ crystal is the *smallest*
> degenerate case, not one of two. Theorems A, B, C and Corollary D of this note
> are untouched — indeed Theorem C already exhibits $m=9$ as deficient for
> $T=\{0\}$, which is why the struck sentence contradicted its own note.

---

## 1. Setup

Fix a base $b\ge 2$ and a modulus $m\ge 2$ with $\gcd(b,m)=1$. States are
$\mathbb Z/m$; the digit $d\in\{0,\dots,b-1\}$ acts by
$$A_d(r)=br+d \pmod m .$$
A word $w=d_{\ell-1}\cdots d_0$ of length $\ell$ acts by
$$A_w(r)=b^{\ell}r+[w]_b,\qquad [w]_b=\sum_{i<\ell} d_i b^{i}\in[0,b^{\ell}).
\tag{1}$$
Leading zeros are legal digits, so **every** integer $v\in[0,b^{\ell})$ is
$[w]_b$ for exactly one word of length $\ell$. (This is the Egyptian/Ethiopian
doubling identity read backwards: the reachable suffix values of length $\ell$
are precisely the numbers whose binary decomposition fits in $\ell$ places.)

The earned observation is $q_T(r)=[\,r\in T\,]$ for a fixed
$\emptyset\ne T\subsetneq \mathbb Z/m$. The crystal is the case $T=\{0\}$,
"divisible by $m$".

**Definition.** For $r\ne s$ let $\lambda(r,s)$ be the length of the shortest
$w$ with $q_T(A_w(r))\ne q_T(A_w(s))$ ($\infty$ if none). The **witness
radius** is
$$W(b,m,T)=\max_{r\ne s,\ \lambda<\infty}\lambda(r,s),$$
the depth of the reverse-BFS forest of `ARITHMETIC_WITNESS_CRYSTAL`.

Write $L=L(b,m)=\lceil\log_b m\rceil$, i.e. the least $\ell$ with $b^{\ell}\ge m$.

---

## 2. The universal upper bound, for every observation

Let $H=\{u\in\mathbb Z/m: T+u=T\}$ be the period subgroup of $T$; $T$ is a
union of $H$-cosets and $H\ne\mathbb Z/m$ since $T$ is proper.

> **Theorem A.** If $r-s\in H$ then $r,s$ are indistinguishable by any word.
> If $r-s\notin H$ then $\lambda(r,s)\le L$. Hence for every $T$,
> $$W(b,m,T)\ \le\ \lceil\log_b m\rceil .$$

*Proof.* $H$ is a subgroup of the cyclic group $\mathbb Z/m$, so $H=h\mathbb Z/m$
for some $h\mid m$; since $\gcd(b,m)=1$, multiplication by $b$ preserves $H$
and $b^{\ell}u\in H\iff u\in H$. If $r-s\in H$ then by (1)
$A_w(r)-A_w(s)=b^{\ell}(r-s)\in H$, so $A_w(r)\in T\iff A_w(s)\in T$: never
separated.

Now let $u_\ell=b^{\ell}(r-s)\notin H$ for every $\ell$. Since $u_\ell$ is not a
period, there is $t\in T$ with $t+u_\ell\notin T$. Take $\ell=L$, so
$b^{\ell}\ge m$, and let $v\in[0,b^{\ell})$ be the least nonnegative residue of
$t-b^{\ell}s$; such $v$ exists because the interval $[0,b^{\ell})$ contains a
full residue system. Let $w$ be the length-$\ell$ word with $[w]_b=v$. Then
$A_w(s)=t\in T$ and $A_w(r)=t+u_\ell\notin T$. $\square$

Theorem A is the honest general statement: **the witness forest of an
$m$-state divisibility crystal is never deeper than $\log_b m + 1$, whatever
the earned observable.** No error term, no fit, no run. It is a sharpened,
self-contained instance of Moore's $m-2$ bound for distinguishing sequences;
the affine structure improves $m$ to $\log m$.

---

## 3. The exact radius for the divisibility observable $T=\{0\}$

Here $H=\{0\}$, so all $m$ states are pairwise distinguishable — the crystal's
"three predictive states", for general $m$.

By (1), $A_w(r)=0$ iff $[w]_b\equiv -b^{\ell}r$. Since $b$ is invertible, at
most one of $r,s$ can be sent to $0$ by a given $w$. Therefore
$$\lambda(r,s)=\min\bigl(d(r),d(s)\bigr),\qquad
d(r):=\min\{\ell\ge 0:\ \langle -b^{\ell}r\rangle_m<b^{\ell}\},
\tag{2}$$
where $\langle x\rangle_m\in[0,m)$ is the least nonnegative residue. So $d(r)$
is exactly the length of the **shortest suffix that makes $r$ divisible** —
the operation $C$ that `ARITHMETIC_WITNESS_CRYSTAL` §"the operation that
becomes lawful" compiles, with $C(0)=\epsilon, C(1)=1, C(2)=01$ and
$d=0,1,2$. The witness radius is thus the *second largest* value of $d$.

Let $S_\ell=\{r:\langle -b^{\ell}r\rangle_m<b^{\ell}\}$.

> **Lemma B (nesting and exact count).** For $0\le \ell\le L-1$:
> $S_\ell\subseteq S_{\ell+1}$ when $\ell+1\le L-1$, and $|S_\ell|=b^{\ell}$.
> Consequently
> $$\#\{r\in\mathbb Z/m:\ d(r)\le \ell\}=b^{\ell}\quad(0\le \ell\le L-1),$$
> so exactly $b^{\ell-1}(b-1)$ states have $d=\ell$ for $1\le\ell\le L-1$, and
> the remaining $m-b^{L-1}$ states have $d=L$.

*Proof.* $r\mapsto -b^{\ell}r$ is a bijection of $\mathbb Z/m$, and for
$b^{\ell}\le m$ the target condition names $b^{\ell}$ residues; $b^{\ell}\le
b^{L-1}<m$ gives $|S_\ell|=b^{\ell}$. Nesting: if $\langle-b^\ell r\rangle_m=v<b^{\ell}$
then $-b^{\ell+1}r\equiv bv$ with $bv<b^{\ell+1}\le b^{L-1}<m$, so
$\langle-b^{\ell+1}r\rangle_m=bv<b^{\ell+1}$. Nesting gives
$\{d\le\ell\}=S_\ell$. Finally $b^{L}\ge m$ forces $d(r)\le L$ for all $r$,
which is Theorem A again. $\square$

> **Theorem C (the exact witness radius).** Let $\gcd(b,m)=1$, $m\ge2$,
> $L=\lceil\log_b m\rceil$. Then
> $$W(b,m,\{0\})=\begin{cases} L-1, & m=b^{L-1}+1,\\[2pt] L, & m\ge b^{L-1}+2.\end{cases}$$

*Proof.* By (2) the radius is the second largest value of $d$. By Lemma B the
top class $\{d=L\}$ has size $m-b^{L-1}\ge1$. If that size is $\ge2$ the second
largest value is $L$; if it is exactly $1$, i.e. $m=b^{L-1}+1$, the second
largest is the largest value below $L$, namely $L-1$, whose class
$\{d=L-1\}$ has size $b^{L-1}-b^{L-2}\ge1$. $\square$

**Checks.** $b=2$: $m=3$ has $L=2$, $m=2^{1}+1$, so $W=1$ — the crystal's
single one-digit witness, and its $d$-profile $(0,1,2)$ matches $\#\{d\le
\ell\}=2^{\ell}$. $m=5$: $L=3$, $m=4+1$, $W=2$; $d$-profile
$d(0..4)=(0,2,1,2,3)$. $m=7$: $L=3\le m-4$, $W=3$; $d=(0,2,3,1,3,2,3)$, and
$\#\{d\le1\}=2,\#\{d\le2\}=4$ as Lemma B demands.

---

## 4. The answer to the question 0249 did not ask

> **Corollary D (unboundedness, with the exact price).** For every $k\ge1$
> there is a base-$2$ divisibility crystal whose witness forest has depth
> exactly $k$: take $m=2^{k}+1$. Conversely a crystal on $m$ states has
> witness depth $\le\lceil\log_2 m\rceil$, so depth $k$ requires $m>2^{k-1}$.
> The **least** odd modulus with witness radius exactly $k$ is
> $$m_{\min}(k)=\begin{cases}3,&k=1\\ 5,&k=2\\ 2^{k-1}+3,&k\ge3.\end{cases}$$

*Proof.* $m=2^{k}+1=b^{L-1}+1$ with $L=k+1$ gives $W=k$ by Theorem C. For
minimality: $W=k$ forces $L\in\{k,k+1\}$. If $L=k$ then $m\ge 2^{k-1}+2$ and
$m$ odd gives $m\ge 2^{k-1}+3$, attained (for $k\ge3$, $2^{k-1}+3\le 2^k$ so
$L=k$ indeed, and $2^{k-1}+3\ge 2^{k-1}+2$ so $W=L=k$). If $L=k+1$ then
$m>2^{k}>2^{k-1}+3$ for $k\ge3$. For $k=1,2$ the case $L=k$ needs
$m\ge2^{k-1}+3$ with $L=k$, impossible ($k=1$: $m\ge4$ but $L=1$ needs $m\le2$;
$k=2$: $m\ge5$ but $L=2$ needs $m\le4$), leaving $L=k+1$ and the least odd
$m>2^{k}$ with the right class size, giving $3$ and $5$. $\square$

So: **no bound in $k$; an exact bound in $m$.** Depth grows, but only
logarithmically in the size of the arithmetic body, and the constant is $1$,
not fitted. ~~Two moduli, $m=3$ and $m=5$, are the complete list of cases where
the divisibility observable fails to achieve the universal bound of Theorem A;
`ARITHMETIC_WITNESS_CRYSTAL` picked one of the two exceptions.~~

> **Struck (SEED-75, 2026-08-14).** Same defect as in the opening summary: a
> quantifier over $T$ went missing between §6 (a conjecture about $W_{\max}$)
> and this sentence (a claim about the divisibility observable $T=\{0\}$). By
> this note's own Theorem C the divisibility observable fails the universal
> bound at **every** $m=b^{L-1}+1$ — $m=9$ included, with $L=4$, $W=3$ — so the
> complete list is the infinite family $m=b^{L-1}+1$, not $\{3,5\}$. Correct
> statement (SEED-26 Cor. 2):
> $W_{\max}(b,m)=\lceil\log_b m\rceil-[\,m=b^{\lceil\log_b m\rceil-1}+1\,]$,
> with $T=\{0\}$ extremal at every modulus. `ARITHMETIC_WITNESS_CRYSTAL` picked
> the smallest exception.

**Reading of the crystal's own claim.** The note says $m=3$ is "the smallest
possible nontrivial propagation example". True, and Theorem C says why it is
*also* atypical: it is ~~one of the two moduli~~ **the smallest member of the
infinite family $m=b^{L-1}+1$** where the deepest pair is
strictly shallower than $\lceil\log_b m\rceil$.

> **Struck (SEED-94, 2026-08-14; fourth occurrence of the same false set).**
> SEED-50 (message 0650) counted three occurrences of the $\{3,5\}$ claim and
> SEED-75 struck those three (§1 opener, §4 close, §5 novelty clause). This
> sentence is a fourth, in the paragraph immediately following the §4 strike,
> and it survived both passes. Same refutation, same authority: SEED-26 Thm 1 /
> Cor. 2 and SEED-35 Thm 35-1 make the exceptional set the infinite family
> $m=b^{L-1}+1$. Recorded so the next referee counts four, not three.

The first *typical* crystal is
$m=7$, whose forest has depth $3$: the pairs among $\{2,4,6\}$ need a
three-digit experiment.

---

## 5. Prior art, stated before the fact

No novelty is claimed for: (i) Moore's bound that inequivalent states of an
$n$-state DFA are separated by a word of length $\le n-2$ — Theorem A is the
affine-cyclic sharpening of it; (ii) the folklore "shortest suffix making $n$
divisible by $m$", which is the function $d$ of (2); (iii) base-$b$ divisibility
automata generally. What is asserted as this note's content is the exact
formula of Theorem C — ~~including the two-element exceptional set
$\{3,5\}$~~ (struck, SEED-75: the exceptional set is the infinite family
$m=b^{L-1}+1$; see the correction in §4) — and the count of Lemma B, which does not appear in the corpus and
which the crystal note's own example silently instantiates.

---

## 6. Open (one page, for whoever wants it)

`SEED11-OPEN-1` (**PROVE**). Fix $b=2$ and $m$ odd. Define
$W_{\max}(m)=\max_{\emptyset\ne T\subsetneq\mathbb Z/m} W(2,m,T)$. Theorem A
gives $W_{\max}(m)\le\lceil\log_2 m\rceil$ and Theorem C gives equality for
every $m$ except $m=2^{L-1}+1$, where $T=\{0\}$ only reaches $L-1$.

> **Question.** For $m=2^{L-1}+1$ (i.e. $m=3,5,9,17,33,65,\dots$), does some
> other target set $T$ attain $W(2,m,T)=L$?

**`SEED11-OPEN-1` is CLOSED, NEGATIVELY (SEED-26 Theorem 1, message 0626;
independently SEED-35 Theorem 35-1, message 0635). The answer is no: no target
set recovers depth $L$ at any $m=b^{L-1}+1$.** The guess and its justification
are struck below, with the reason.

~~**Best guess:** yes for every such $m\ge9$, so that the complete list of
moduli with $W_{\max}(m)<\lceil\log_2 m\rceil$ is exactly $\{3,5\}$.~~
~~**Why.** The deficiency at $m=b^{L-1}+1$ is a pure counting accident: Lemma B
says $S_{L-1}$ has $b^{L-1}=m-1$ elements, so the top class is a *singleton*
and the second-largest $d$ drops by one. A target set of size $2$ replaces the
single condition "$[w]_b\equiv -b^{\ell}r$" by two, and the analogue of $S_\ell$
becomes a union of two translates of an interval, whose complement has size
$m-2b^{\ell}$ — it is no longer forced to be a singleton at $\ell=L-1$, and
generic $T$ should leave $\ge2$ states behind. For $m=3,5$ there is simply not
enough room ($m-2b^{L-2}\le1$), which is why they should be the only
exceptions. A proof needs only Lemma B run with $|T|=2$ plus a check that the
two translates can be forced disjoint, which is a congruence condition on $T$;
$m=9$ can be settled by hand.~~

> **The justification is struck too, and it is the worse error
> (SEED-57/Lakatos, message 0658 §3.2, applied by SEED-75, 2026-08-14).**
> Evaluate the offered criterion on the whole family $m=2^{L-1}+1$, $b=2$:
> $$m-2\cdot2^{L-2}=2^{L-1}+1-2^{L-1}=1\qquad\text{for every }L\ge2,$$
> identically $1$ at $m=3$, at $m=5$, and equally at $9,17,33,65,\dots$; and
> $m-2b^{L-1}=1-2^{L-1}<0$ on the whole family likewise. **Neither quantity
> offered distinguishes $m=5$ from $m=9$.** Read literally, this note's own
> criterion predicts SEED-26's theorem — the list $\{3,5\}$ was read off the two
> computed moduli and the mechanism attached afterwards. SEED-26 corrected the
> claim; leaving the reason standing was worse than the claim, so it is struck
> here.
>
> **What actually decides it (SEED-26).** The binding constraint is not counting
> but **parity**, and it is uniform in $T$. With $\Delta_u(x)=\chi(x)+\chi(x+u)$
> over $\mathbb F_2$, telescoping gives $\sum_{x\in O}\Delta_u(x)=0$ on every
> orbit $O$ of $x\mapsto x+u$; at $\ell=L-1$ the window misses exactly one
> residue, so a separating $\Delta_u$ would have support of weight $\le1$ on an
> orbit, hence weight $0$. A cyclic sequence cannot change value exactly once.
> This is why $|T|$ is irrelevant: every $\chi$ whatsoever lands in the
> even-weight parity code.
