# The rational circle as an atlas: five charts, checked transition maps, an exact residual group, and the chart/ambient completion

**Task:** execute `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §4 (reachable points and the
beyond) and §6 (polyglot assimilation) on the constitution's *own* canonical model,
$S^1(\mathbb{Q})$ — as mathematics, not as metaphor. The note supplies the five
native languages, every pairwise transition map with a proof and an exact machine
check, the translation residual named as a group with its fiber count proved, and
the completion theorems (reachability, approximation rate, omitted locus,
pass/fail under completion) with honest classical-vs-new attribution.

**Code:** `code/exp61_rational_circle_atlas.py` → `figures/exp61_approx_exponent.png`,
`figures/exp61_covering.png`, `figures/exp61_rank_rate.png`,
`figures/exp61_circle_chart.png`; full printed output archived at
`data/exp61_out.txt`; summary at `data/exp61_atlas.json`; Diophantine arrays at
`data/exp61_diophantine.npz`. Exact integer / `Fraction` arithmetic throughout
except where a measurement is explicitly labelled MEASURED (float64 angles).
Runtime ≈ 3 min, numpy + matplotlib only. Every number quoted below is printed by
that script.

**Status: PENDING HOSTILE AUDIT.** Grades are stated per item: **PROVED** (proof
written here), **CLASSICAL** (known; proof quoted or given for completeness),
**MEASURED** (numerics only, exponent/constant fits), **FETCHED** / 
**UNVERIFIED-MEMORY** for literature. This note creates only `exp61`-namespace
files and edits nothing existing.

**Scope note.** This is a new direction. The free generators of $S^1(\mathbb{Q})$
happen to be indexed by primes $\equiv 1 \bmod 4$; **no** connection to the repo's
prime-pair field / RH program is claimed, used, or implied anywhere below.

---

## 0. The object and its conventions

$$S^1(\mathbb{Q}) \;=\; \{\,w = x+iy \in \mathbb{Q}(i) \;:\; x^2+y^2 = 1\,\}
\;\subset\; S^1 \subset \mathbb{C}.$$

Write $w = (a + ib)/c$ in lowest terms, $\gcd(a,b,c)=1$, $c>0$; $a^2+b^2=c^2$.
The **height** of $w$ is $\mathrm{ht}(w) := c$, the common denominator. The four
points $\mu_4 = \{1,i,-1,-i\}$ have height $1$; we call them the **cusps** (the
name is earned in §5.3). For $w \ne \mu_4$ exactly one of $a,b$ is even.

Angular distance is $d(\theta,\theta') = $ the circular distance in $[0,\pi]$;
$\delta(\theta,H) := \min\{\, d(\theta,\arg w) : w \in S^1(\mathbb{Q}),\ \mathrm{ht}(w)\le H \,\}$.

Counting anchor (CLASSICAL, Lehmer 1900): the number of primitive triples with
$c \le H$ is $\sim H/(2\pi)$. Measured:

```
  primitive triples with c <= 100000: 15919
  Lehmer 1900 asymptotic  c_max/(2*pi) = 15915.5   ratio measured/predicted = 1.00022
```

---

## 1. The five charts (exact domains)

| # | Chart | Set | Native strength |
|---|-------|-----|-----------------|
| 1 | **PT** | primitive triples $(a,b,c)$, $a^2+b^2=c^2$, $\gcd=1$, $a$ odd, $b$ even, $a,b,c>0$ | integrality; the Diophantine equation |
| 2 | **T** | $t \in \mathbb{P}^1(\mathbb{Q}) = \mathbb{Q}\cup\{\infty\}$, $\;w = \left(\frac{1-t^2}{1+t^2},\frac{2t}{1+t^2}\right)$ | reachability; a *bijective* global parametrization |
| 3 | **Z** | primitive $z = m+in \in \mathbb{Z}[i]$ (i.e. $\gcd(m,n)=1$), modulo $\{\pm1\}$; $\;w = z/\bar z$ | UFD structure; the group law; the height |
| 4 | **BH** | words in $\{A,B,C\}^\ast$, the Barning–Hall ternary tree rooted at $(3,4,5)$ | recursion; descent; finite generation |
| 5 | **CF** | canonical continued fraction $t=[0;a_1,\dots,a_k]$, $a_k\ge2$ / Stern–Brocot address in $\{L,R\}^\ast$ | metric approximation; Farey/mediant order |

The Barning–Hall matrices, acting on the column $(a,b,c)^{\mathsf T}$:

$$A=\begin{pmatrix}1&-2&2\\2&-1&2\\2&-2&3\end{pmatrix},\quad
B=\begin{pmatrix}1&2&2\\2&1&2\\2&2&3\end{pmatrix},\quad
C=\begin{pmatrix}-1&2&2\\-2&1&2\\-2&2&3\end{pmatrix}.$$

```
  A(3,4,5) = (5, 12, 13)
  B(3,4,5) = (21, 20, 29)
  C(3,4,5) = (15, 8, 17)
  (label convention differs across sources; ours is fixed by these images)
```

**Chart-naming residual, recorded per §6 ("shared spelling is not shared meaning").**
The matrix *triple* is standard (FETCHED: Wikipedia "Tree of primitive Pythagorean
triples", citing Barning 1963 and Hall 1970, gives exactly these three matrices),
but the *assignment of the names $B,C$ to children* is not stable: the extraction we
obtained from that page listed $B\mapsto(15,8,17)$, $C\mapsto(21,20,29)$, the
opposite of the matrices as displayed — we did **not** confirm which of the two is
the page's actual text, so we record only that the naming is unreliable. Our labels
are pinned by the images above, not by a name, and any cross-source transport of a
Barning–Hall *word* must carry the labelling as data.

---

## 2. The transition maps, with proofs

Throughout put $z = m+in$ with $m>n>0$, $\gcd(m,n)=1$, $m+n$ odd (the **Euclid
domain** $E$), and $t = n/m \in (0,1)$.

### 2.1 $\mathbf{T \to PT}$ and back (CLASSICAL: Euclid)

$$\Phi(t) = (m^2-n^2,\; 2mn,\; m^2+n^2), \qquad
\Phi^{-1}(a,b,c) = \frac{b}{c+a}.$$

*Proof of well-definedness and bijectivity on $E \leftrightarrow$ PT.* Given
$t=n/m \in E$: $a=m^2-n^2$ is odd and $b=2mn$ even since $m+n$ is odd; if a prime
$p$ divided $a,b,c$ then $p\mid c\pm a$, i.e. $p \mid 2m^2, 2n^2$, and $p$ is odd
(as $a$ is odd), so $p\mid m,n$, contradicting $\gcd(m,n)=1$. Conversely for a
primitive triple, $a$ odd forces $c$ odd, and $\left(\frac{c+a}{2}\right)\left(\frac{c-a}{2}\right)=\left(\frac b2\right)^2$
with the two factors coprime, so each is a square: $\frac{c+a}2 = m^2$,
$\frac{c-a}2 = n^2$, giving $t=b/(c+a)=n/m$ and $\Phi(t)=(a,b,c)$. Coprimality and
opposite parity of $m,n$ follow from primitivity. $\square$

Verified: `chart1 <-> chart2 round trip on all triples (Euclid branch)  15919 triples`.

**Where it is *not* a bijection, exactly.** The stereographic map
$t\mapsto\left(\frac{1-t^2}{1+t^2},\frac{2t}{1+t^2}\right)$ is a bijection
$\mathbb{P}^1(\mathbb{Q}) \to S^1(\mathbb{Q})$ (§5.1), but its restriction to *all*
reduced $n/m \in (0,1)$ is $2{:}1$ onto PT, not $1{:}1$: the parity condition is
not vacuous. The second (both-odd) preimage is the image of the first under

$$\iota: t \mapsto \frac{1-t}{1+t} \qquad\text{i.e.}\qquad \frac nm \mapsto \frac{m-n}{m+n},$$

which is $\theta \mapsto \pi/2-\theta$, i.e. the **leg swap**. If $p/q=\iota(t)$
with $p,q$ both odd, the triple is $\left(pq,\ \tfrac{q^2-p^2}2,\ \tfrac{p^2+q^2}2\right)$.
Verified: `chart2 both-odd branch t -> (1-t)/(1+t) recovers the same triple`, and
CONTROL-A below rejects the false claim that the parity condition may be dropped.

### 2.2 $\mathbf{Z \to PT}$: squaring (CLASSICAL)

$z^2 = (m^2-n^2) + i(2mn) = a+ib$, exactly. Verified on all $15919$ triples.
Equivalently $w = z^2/N(z) = z/\bar z$.

### 2.3 $\mathbf{BH}$: the $(m,n)$-form of the three moves (PROVED here; the tree is CLASSICAL)

In Euclid coordinates the three matrices become

$$A:(m,n)\mapsto(2m-n,\,m),\qquad B:(m,n)\mapsto(2m+n,\,m),\qquad C:(m,n)\mapsto(m+2n,\,n),$$

i.e. $\begin{pmatrix}2&-1\\1&0\end{pmatrix},\begin{pmatrix}2&1\\1&0\end{pmatrix},\begin{pmatrix}1&2\\0&1\end{pmatrix}$
acting on $(m,n)^{\mathsf T}$.

*Proof.* Direct substitution; e.g. for $A$, $(2m-n)^2-m^2 = 3m^2-4mn+n^2 = a-2b+2c$,
$2(2m-n)m = 4m^2-2mn = 2a-b+2c$, $(2m-n)^2+m^2 = 5m^2-4mn+n^2 = 2a-2b+3c$. Each
image again lies in $E$: the matrices are unimodular up to sign and preserve
$\gcd=1$; $m+n$ odd is preserved because each new pair is $\{$old $m$, old
$m\pm$ old $n$ or old $n$, old $m+2n\}$, whose sums are $m+n$ or $2m+n+n\equiv m+n$. $\square$

Verified: `(m,n)-form of the three moves agrees with the 3x3 matrices`.

**Descent (the inverse map), PROVED.** For $(M,N)\in E$ with $(M,N)\ne(2,1)$
exactly one of the following holds, and gives the unique parent:

$$\tfrac M2<N<M \Rightarrow A,\ \text{parent }(N,\,2N-M);\qquad
\tfrac M3<N<\tfrac M2 \Rightarrow B,\ \text{parent }(N,\,M-2N);\qquad
N<\tfrac M3 \Rightarrow C,\ \text{parent }(M-2N,\,N).$$

*Proof.* The three preimage formulas are forced by inverting the three matrices;
each requires its parent to satisfy $0<n<m$, which translates exactly into the
three stated intervals. The boundaries $N=M/2$ and $N=M/3$ are excluded by
$\gcd(M,N)=1$ unless $(M,N)=(2,1)$ or $(3,1)$; and $(3,1)$ has $M+N$ even, so it
is not in $E$. The intervals partition $(0,M)$, so the parent exists and is unique;
$M$ strictly decreases, so the descent terminates at the root $(2,1)=(3,4,5)$. $\square$

This *is* the Barning–Hall theorem (CLASSICAL: Barning 1963, Hall 1970 — FETCHED)
restated so that it is executable. Verified:
`Barning--Hall: descent word re-evaluates to the triple  15919 triples`,
`Barning--Hall words are pairwise distinct (injectivity)`,
`word set is prefix-closed`, and
`levels 0..5 are complete ternary (3^k nodes)` (level 6 has $725/729$; the four
missing words are exactly $BBBBBA, BBBBBB, BBBBBC, CBBBBB$, with
$c = 100385,\,195025,\,100381,\,111865$ — all $B$-heavy, since $B$ is the
fastest-growing move, expansion factor $1+\sqrt2$ per step on $m$).

### 2.4 $\mathbf{BH \to CF}$: the tree acts on continued fractions (PROVED here)

Write $t=[0;a_1,\dots,a_k]$ with $a_k\ge2$. Then, with the canonicalisation
rewrites $[\dots,x,0,y,\dots] \to [\dots,x{+}y,\dots]$ and $[\dots,x,1] \to [\dots,x{+}1]$
(both value-preserving):

$$\boxed{\;A:\;[0;a_1,\dots] \mapsto [0;1,1,a_1-1,a_2,\dots],\qquad
B:\;\mapsto[0;2,a_1,a_2,\dots],\qquad
C:\;\mapsto[0;a_1+2,a_2,\dots]\;}$$

with root $t=1/2=[0;2]$.

*Proof.* In $t$-coordinates the three moves are the Möbius maps
$A: t\mapsto \frac{1}{2-t}$, $B: t\mapsto\frac{1}{2+t}$, $C: t\mapsto\frac{t}{1+2t}$
(read off from §2.3). Then: $C$ gives $\frac{1}{2+1/t}$, and $1/t=[a_1;a_2,\dots]$,
so $C(t)=[0;a_1+2,a_2,\dots]$. $B$ gives $\frac1{2+t}$ with $2+t=[2;a_1,a_2,\dots]$,
so $B(t)=[0;2,a_1,\dots]$. $A$: $2-t = 1+(1-t)$ and $1-t=[0;1,a_1-1,a_2,\dots]$,
so $2-t=[1;1,a_1-1,a_2,\dots]$ and $A(t)=[0;1,1,a_1-1,a_2,\dots]$. The
canonicalisation is needed exactly when $a_1=1$ (zero collapse) or when the result
ends in $1$ (only from the root). $\square$

Verified on every triple: `BH word -> CF dictionary  A:[1,1,a1-1,..]  B:[2,a1,..]  C:[a1+2,..]  15919 triples`.
CONTROL-D plants the near-miss rule "$A$ prepends $[1,1]$ verbatim" and it is
rejected on $2692/3000$ cases.

*Remark (why this map is worth having).* It converts a statement about the
recursive generation of triples into a statement about the digits of a real
approximation, so §5's Diophantine estimates and §2.3's tree become the same
object. This is precisely the constitution's §5 "mathematics changes the search
metric": after this dictionary, badly-approximable directions and Barning–Hall
word statistics are one question.

### 2.5 $\mathbf{CF \to SB}$ (CLASSICAL) and the parity monodromy (PROVED here)

The Stern–Brocot (mediant) address of $t=[0;a_1,\dots,a_k]$ is the run-length word
$L^{a_1-1}R^{a_2}L^{a_3}\cdots$ with the **final** exponent decremented by one.
Verified against direct mediant search on $8000$ fractions.

**Proposition (parity residual).** Let $\rho(\text{word}) \in SL_2(\mathbb{F}_2)$
be the image of the Stern–Brocot word under $L\mapsto\binom{1\ 0}{1\ 1}$,
$R\mapsto\binom{1\ 1}{0\ 1}$ reduced mod $2$. Then the parity of $m+n$ is a
function of $\rho$ alone: the Euclid domain is $\rho^{-1}(\text{4 of the 6
elements})$, the both-odd domain the remaining $2$.

*Proof.* Writing $M$ for the $2\times2$ matrix of bounding fractions of the node,
$(m,n)^{\mathsf T} = M_0\,\rho\,(1,1)^{\mathsf T}$ for a fixed $M_0$, so
$(m,n) \bmod 2$ depends only on $\rho \bmod 2$; $m+n$ odd $\iff (m,n)\not\equiv(1,1)$
$\iff \rho(1,1)^{\mathsf T} \ne v_0$ for one fixed nonzero $v_0\in\mathbb{F}_2^2$.
The map $\rho \mapsto \rho(1,1)^{\mathsf T}$ from $SL_2(\mathbb{F}_2)\cong S_3$
(order 6) to the three nonzero vectors is $2{:}1$, giving $2$ excluded and $4$
admitted classes. $\square$

```
  SL2(F_2) classes on the Euclid (opposite-parity) domain: 4
  SL2(F_2) classes on the both-odd domain:                2
```

This is the exact sense in which the Stern–Brocot chart "records the parity/Farey
structure": it carries an $S_3$-valued monodromy of which the triple chart sees
only a two-valued shadow.

### 2.6 Summary table of transition maps

| From → To | Map | Status | Fiber |
|---|---|---|---|
| T → PT | $t=n/m \mapsto (m^2{-}n^2,2mn,m^2{+}n^2)$ on $E$ | CLASSICAL, proved §2.1 | $1{:}1$ |
| PT → T | $(a,b,c)\mapsto b/(c{+}a)$ | CLASSICAL | $1{:}1$ |
| T (all of $(0,1)$) → PT | as above with parity split | PROVED §2.1 | $2{:}1$, fiber $=\langle\iota\rangle\cong\mathbb{Z}/2$ (leg swap) |
| Z → PT | $z\mapsto z^2$ | CLASSICAL | $1{:}1$ on $E$ |
| Z → S¹(ℚ) | $z\mapsto z/\bar z$ | PROVED §3.1 | $\{\pm z\}$ |
| PT ↔ BH | descent / matrix product | CLASSICAL (Barning–Hall), executable form proved §2.3 | $1{:}1$ |
| BH → CF | $A,B,C$ digit rules | **PROVED here** §2.4 | $1{:}1$ |
| CF ↔ SB | run-length encoding | CLASSICAL | $1{:}1$ |
| SB → parity | $\rho\in SL_2(\mathbb{F}_2)$ | **PROVED here** §2.5 | $2{:}1$ onto the 3 vectors |
| S¹(ℚ) → PT | orbit map | **PROVED §3.2** | $8{:}1$, fiber $=D_4$ |

---

## 3. The residual: an exact fiber theorem

### 3.1 The Gaussian chart is a bijection modulo $\pm1$

**Theorem 3.1 (PROVED).** Let $G'=\{z\in\mathbb{Z}[i]\setminus\{0\}:\gcd(\Re z,\Im z)=1\}$.
Then $\varphi(z) = z/\bar z$ maps $G'$ onto $S^1(\mathbb{Q})$, and
$\varphi(z)=\varphi(z') \iff z'=\pm z$. Hence $\varphi: G'/\{\pm1\}\xrightarrow{\ \sim\ } S^1(\mathbb{Q})$.

*Proof.* **Surjectivity.** Given $w=(a+ib)/c$ primitive, $N(a+ib)=c^2$. Since
$\gcd(a,b)=1$, no rational prime divides $a+ib$, so its $\mathbb{Z}[i]$-factorization
contains, for each split prime, only one of the two conjugates; hence every
exponent in $N=c^2$ is even and $a+ib = u\,\zeta^2$ with $u$ a unit. If $a$ is odd,
$u\in\{\pm1\}$ and $a+ib=(\pm\zeta)^2 =: z^2$, so $w = z^2/N(z) = \varphi(z)$; $z$
is primitive since $a+ib$ is. If $a$ is even then $b$ is odd and $-i(a+ib)$ has odd
real part, so $w = i\varphi(z)$ for some $z$; and $i\varphi(z) = \varphi((1+i)z)$
because $(1+i)/(1-i)=i$, with $(1+i)z$ again primitive when $N(z)$ is odd.
**Injectivity.** $\varphi(z)=\varphi(z')\iff z\bar z' \in\mathbb{R}\cap\mathbb{Z}[i]=\mathbb{Z}$.
If $N(z)$ is odd then $\gcd(z,\bar z)=1$, so $z\bar z = N(z)$ divides $z\bar z'=:r$,
whence $\bar z' = (r/N(z))\bar z$ and primitivity forces $z'=\pm z$. If $N(z)$ is
even, write $z=(1+i)\zeta$ with $\zeta$ primitive of odd norm and repeat. Finally
the odd-norm and even-norm classes cannot collide, since $\varphi(\text{odd norm})$
has odd numerator in its real part while $i\cdot(\text{that})$ has even. $\square$

Corollary: the height satisfies $\mathrm{ht}(\varphi(z)) = N(z)$ when $N(z)$ is odd.

### 3.2 The residual group is $D_4$, and the fiber count is exactly $8$

Let $r:w\mapsto iw$ and $s:w\mapsto \bar w = w^{-1}$ on $S^1(\mathbb{Q})$. Then
$srs^{-1}=r^{-1}$ and $r^4=s^2=1$, so $\langle r,s\rangle \cong D_4$ (order 8), the
symmetry group of the square, acting by $w\mapsto i^k w^{\pm1}$.

On the Gaussian chart these generators are:

$$r \;=\; \text{multiplication by the ramified prime } (1+i),\qquad
s \;=\; \text{complex conjugation of } \mathbb{Z}[i].$$

Verified: `multiplication by the ramified prime (1+i) on Z[i] induces w -> i*w`,
`Gaussian conjugation induces w -> w^{-1}`. (The *unit* group $\mathbb{Z}[i]^\times$
acts only through $\mathbb{Z}/2$: $\varphi(iz)=-\varphi(z)=r^2\varphi(z)$, kernel
$\{\pm1\}$. The full order-4 rotation comes from the ramified prime, not from the
units — this is the one place where a plausible slogan ("the residual is
units × conjugation, $4\times2=8$") is *numerically* right and *structurally*
wrong, and the code checks the structural version.)

**Theorem 3.2 (fiber theorem, PROVED).** $D_4$ acts on $S^1(\mathbb{Q})$ with
exactly one non-free orbit, namely $\mu_4=\{1,i,-1,-i\}$, of size $4$ and
stabilizer $\mathbb{Z}/2$. Every other orbit is free of size $8$, and

$$\mathrm{PT}\;\cong\;\bigl(S^1(\mathbb{Q})\setminus\mu_4\bigr)/D_4 ,\qquad
\#\{w:\mathrm{ht}(w)\le H\} \;=\; 8\cdot\#\{\text{primitive triples}: c\le H\} + 4 .$$

*Proof.* $g=r^k s^{\varepsilon}$ fixes $w$ iff $i^k w^{\varepsilon}=w$. For
$\varepsilon=+1$ this forces $i^k=1$, $g=1$. For $\varepsilon=-1$ it forces
$w^2=i^{-k}\in\mu_4$, i.e. $w\in\mu_8\cap S^1(\mathbb{Q})$. A primitive $8$th root
of unity has irrational coordinates, so $w\in\mu_4$; and each $w\in\mu_4$ then has
exactly one nontrivial stabilizing element (take $k$ with $i^{-k}=w^2$). Hence
$|\mathrm{Stab}(w)|=2$ on $\mu_4$ and $1$ elsewhere, so $|\mathrm{orbit}|=4$ on
$\mu_4$ (which is a single orbit, being $\langle r\rangle$) and $8$ elsewhere.
Each free orbit $\{(\pm a\pm ib)/c,(\pm b \pm ia)/c\}$ contains exactly two points
with both coordinates positive, of which exactly one has odd real numerator; that
is the primitive triple. $\square$

Machine confirmation at $H=10^5$:

```
  rational points with height c <= 100000: 127356
  [OK]  fiber identity  |S^1(Q)_{<=H}| = 8*|PT_{<=H}| + 4  127356 == 8*15919+4 = 127356
  D4 orbit size census: {8: 15919, 4: 1}
  [OK]  exactly one non-free D4 orbit, of size 4 (= mu_4)
  [OK]  stabilizer orders are 1 (generic) and 2 (on mu_4 only)  {1: 127352, 2: 4}
```

CONTROL-B plants "the fiber has size 4" and it is rejected ($127356 \ne 63680$).

### 3.3 The residual ledger — what each chart records that the others do not

An untranslatable residual is mathematical information (§6). Named exactly:

| Chart | Records | Does **not** record | Residual group / set |
|---|---|---|---|
| **PT** | integrality, the equation | the sign/quadrant and leg order of the ambient point | $D_4$, order 8, free off $\mu_4$ (Thm 3.2) |
| **T** | reachability, a global order compatible with the circle order; **nothing lost** ($1{:}1$) | the group law (it becomes $t\oplus s=\frac{t+s}{1-ts}$) and any base-point-free description ($t=\infty \mapsto -1$) | trivial fiber; a *structural* residual only |
| **Z** | the UFD factorization, the group law, the height as a norm | — ($1{:}1$ modulo $\pm1$) | $\{\pm1\}$ before quotient; $D_4$ generated by $(1+i)$ and conjugation |
| **BH** | a descent path and a depth; makes finite generation visible | the height ordering (depth and height are wildly incomparable: depth $\le 222$ at $c\le10^5$) | trivial fiber over PT; the word is a *canonical form*, not extra information |
| **CF/SB** | the metric approximation data (convergents), the Farey/mediant order, and the $SL_2(\mathbb{F}_2)$ parity monodromy | integrality of the triple; the group law | over PT: trivial on $E$; $\mathbb{Z}/2 = \langle \iota\rangle$ on all of $(0,1)$ |

Two further residuals worth naming, both PROVED:

1. **The leg-order $\mathbb{Z}/2$ admits two inequivalent normalizations.** "$a$
   odd" (arithmetic) and "$a>b$" (metric) each select one point per free orbit, but
   they select *different* points: e.g. $(3,4,5)$ has $a<b$, $(15,8,17)$ has $a>b$,
   yet both are "$a$ odd". Any transport that silently swaps normalizations is a
   silent application of a nontrivial element of $D_4$.
2. **The BH word is a canonical form, not information.** Because PT $\leftrightarrow$
   $\{A,B,C\}^\ast$ is a bijection, the word is recoverable from the triple. The
   honest §6 statement is therefore: *the residual here is presentation-level
   (§7 of the constitution: presentation identity $\ne$ object identity), not
   extensional.* Contrast with $D_4$, which is genuinely non-recoverable.

---

## 4. The group law survives the chart: classification and verification

**Theorem 4.1 (CLASSICAL; Lin Tan, *Math. Magazine* 69 (1996) 163–171 — FETCHED via
Wikipedia "Group of rational points on the unit circle", which cites it).**

$$S^1(\mathbb{Q}) \;\cong\; \mathbb{Z}/4 \;\oplus\; \bigoplus_{p\,\equiv\,1\ (4)} \mathbb{Z},$$

torsion $\mu_4$ generated by $i$, and one free generator $g_p = \pi_p/\bar\pi_p$ per
prime $p\equiv1\bmod4$ (for a choice of Gaussian prime $\pi_p$ above $p$).

*Proof (given for completeness; the route is standard).* By Hilbert 90 the map
$\mathbb{Q}(i)^\times \to S^1(\mathbb{Q})$, $z\mapsto z/\bar z$, is surjective with
kernel $\mathbb{Q}^\times$, so $S^1(\mathbb{Q})\cong\mathbb{Q}(i)^\times/\mathbb{Q}^\times$.
Now $\mathbb{Q}(i)^\times \cong \mathbb{Z}[i]^\times \times \bigoplus_{\pi}\mathbb{Z}$
over Gaussian primes $\pi$, and $\mathbb{Q}^\times$ is generated by $-1$, $2=-i(1+i)^2$,
the inert $q\equiv3\ (4)$, and $p=\pi_p\bar\pi_p$. In the quotient: inert primes
die; $\bar\pi_p \equiv \pi_p^{-1}$, leaving one $\mathbb{Z}$ per $p\equiv1\ (4)$;
and $\langle(1+i)\rangle$ becomes cyclic of order 4 because $(1+i)^2 = 2i \equiv i$
(a unit, and $\ne1$ in the quotient) while $(1+i)^4=-4\equiv 1$. Under
$z\mapsto z/\bar z$, $(1+i)\mapsto i$,
so the $\mathbb{Z}/4$ is exactly $\mu_4$. $\square$

Two consequences that the computation checks *exactly* (not statistically):

**Proposition 4.2 (height is an $\ell^1$ norm on the free part; PROVED).** If
$w = i^{k}\prod_p g_p^{e_p}$ then $\mathrm{ht}(w) = \prod_p p^{|e_p|}$.

*Proof.* Write $w=\varphi(z)$ with $z$ primitive; $z = u\prod_p \pi_p^{a_p}\bar\pi_p^{b_p}$
and primitivity forces $\min(a_p,b_p)=0$, so $e_p = a_p-b_p$ has $|e_p|=a_p+b_p$
and $N(z)=\prod p^{a_p+b_p}=\prod p^{|e_p|}$; the height is $N(z)$ by Cor. 3.1. $\square$

So $\log \mathrm{ht}$ is the weighted $\ell^1$ norm $\sum_p |e_p|\log p$ — the
height is a *norm on a free abelian group*, and cancellation of height under
multiplication happens **only within a single prime**.

```
  [OK]  every hypotenuse c factors into primes = 1 mod 4
  [OK]  height law  c(w) = prod_p p^{|e_p|}  exactly  15919 points
  [OK]  reconstruction  w = (u/ubar) * prod_p g_p^{e_p}  exactly
  [OK]  group law: exponent vectors add under multiplication (4000 random pairs)
  [OK]  height of the product = prod p^{|e_p+e'_p|} (cancellation only within p)
  [OK]  no primitive point of height>1 has finite order <= 12 (Niven)  torsion = mu_4 only
```

CONTROL-E plants "$(4/5,3/5)$ generates the $p=5$ component" (it is $i\,\overline{g_5}$,
in the same $D_4$ orbit but not a power of $g_5$) and it is rejected.

The torsion statement is CLASSICAL (Niven's theorem: the only rational points on
$S^1$ at rational angle are $\mu_4$ — FETCHED, Wikipedia "Niven's theorem").

---

## 5. Chart versus ambient completion (constitution §4)

### 5.1 (i) Exact reachability certificate

**Theorem 5.1 (CLASSICAL).** Stereographic projection from $(-1,0)$,
$t\mapsto\left(\frac{1-t^2}{1+t^2},\frac{2t}{1+t^2}\right)$, is a **bijection**
$\mathbb{P}^1(\mathbb{Q})\to S^1(\mathbb{Q})$; with $t=n/m$ in lowest terms and
$m+n$ odd it restricts to Euclid's bijection onto primitive triples (§2.1).

*Proof.* The line through $(-1,0)$ of rational slope $t/1$... more precisely, for
$w=(x,y)\in S^1$ with $w\ne(-1,0)$, $t=y/(1+x)$ is the unique parameter, rational
iff $x,y$ are (one direction is the displayed formula; the other is the formula for
$t$). $t=\infty$ corresponds to $(-1,0)$. $\square$

So the chart is **onto**: no rational point of the circle is missed. This is the
"exact image and reachability certificate" the constitution asks for, and it is
what makes the failures below informative rather than trivial.

### 5.2 (ii) Density with a rate — the exponent is $1$, and there are *two* exponents

**Theorem 5.2 (intrinsic Dirichlet; CLASSICAL).** There is $C$ such that for every
$\alpha\in S^n$ there are infinitely many rational $p/q\in S^n$ with
$\|\alpha-p/q\|<C/q$. FETCHED verbatim from Kleinbock–Merrill, *Rational
approximation on spheres*, Israel J. Math. **209** (2015) 293–322,
[arXiv:1301.0989](https://arxiv.org/abs/1301.0989), Theorem 1.1; the same paper
records that for $n=1$ Fukshansky (via Hlawka 1980) gives $C=2\sqrt2$ **[rider
checked and confirmed, seed139 2026-08-14: `ar5iv.labs.arxiv.org/html/1301.0989`
carries, verbatim, "Previously Fukshansky [15] used a theorem of Hlawka [20] about
approximations of real numbers by Pythagorean triples to establish Theorem 1.1 in
the special case of $S^1$, and showed that one can take $C=2\sqrt2$", with
[20] = E. Hlawka, Bonner Math. Schriften 121, Bonn, 1980. Both names and the year
are the paper's own, not this note's inference]**, and defines
$\mathrm{BA}(S^n)$, proving it is **thick** (Theorem 1.2) and Lebesgue-null.

*Proof for $n=1$ in our normalization, PROVED.* Reduce by $D_4$ to
$\theta\in[0,\pi/4]$, so $t_0=\tan(\theta/2)\in[0,\sqrt2-1]$. For a convergent
$p_k/q_k$ of $t_0$, $|t_0-p_k/q_k| < 1/q_k^2$; since $|\frac{d\theta}{dt}|=\frac2{1+t^2}\le2$
and $c=p_k^2+q_k^2\le2q_k^2$, the corresponding rational point satisfies
$|\theta-\arg w| \le 2/q_k^2 \le 4/c$. Infinitely many convergents exist for
irrational $t_0$. $\square$

**Theorem 5.3 (matching lower bound on the badly-approximable set; PROVED).**
$\theta \in \mathrm{BA}(S^1)$ (i.e. $|\theta-\arg w|>c_0/\mathrm{ht}(w)$ for all $w$)
**iff** $t_0=\tan(\theta/2)$ has bounded partial quotients.

*Proof.* Both directions are the same estimate run backwards: on the fundamental
octant $\frac12|\theta-\arg w| \le |t_0-p/q| \le 2|\theta-\arg w|$ and
$q^2\le c\le 2q^2$; and $|t_0-p/q|\ge \kappa/q^2$ for all $p/q$ iff the partial
quotients of $t_0$ are bounded (classical CF theory). $\square$

So the **approximation exponent is $1$ in the height**, two-sided on the badly
approximable set. MEASURED (median over $3000$ uniform random angles; see
`figures/exp61_approx_exponent.png`):

```
  fitted exponent (median, H>=300):  -0.9965   (predicted -1)
  fitted exponent (median, all H):   -1.0005
  rms residual: free 0.0132 | exponent -1 0.0146 | -1/2 0.8778 | -2 1.7743
  median constant: median_theta delta * H -> 1.2736;  perfectly equispaced points
      of the same count would give pi^2/8 = 1.2337
```

The wrong-exponent controls $-1/2$ and $-2$ are rejected by factors $60\times$ and
$120\times$ in rms. ~~The measured constant $1.274$ versus the perfectly-equispaced
value $\pi^2/8=1.234$ is a quantitative statement that rational points of bounded
height are close to (but not exactly) equidistributed — consistent with, and much
weaker than, the (classical and elementary) equidistribution of the arguments of
primitive lattice points, which is what Pythagorean angles are.~~

> **Struck (SEED-109, 2026-08-14, Rule K3; requested by SEED-05 in
> `collab/messages/0605-seed05-euler-rational-circle-void-law.md`, proved in
> `notes/SEED05_RATIONAL_CIRCLE_VOID_LAW.md`, never applied until now).** The
> $1.274$-versus-$\pi^2/8$ comparison carries no equidistribution content: the
> void law has tail $\mathbb P(H\delta>t)\sim\frac{4}{\pi^2t}$, so
> $\mathbb E_\theta[H\delta_H]=\frac{2}{\pi^2}\log H+O(1)$ — it agrees with
> $\pi^2/8$ only near $H\approx440$ and is $1.9\times$ it at $H=10^5$. The
> median is the one statistic that stays bounded, which is why the fit looked
> stable; its closed form is not derived (SEED-05 seed 1). The count
> $N(H)=\frac4\pi H+O(H^{1/2})$ is a residue of
> $Z(s)=4\zeta(s)L(s,\chi_4)/(\zeta(2s)(1+2^{-s}))$ and is what still "passes".
> **Quoting $1.274$ against $\pi^2/8$ as evidence of equidistribution is
> forbidden from here on.** The $-1$ exponent itself is unaffected.

Two specific directions, MEASURED, confirming the two-sidedness:

```
  [OK] golden direction: delta*H stays bounded (badly approximable)  max = 2.192
  [OK] Liouville direction: delta*H dips far below the golden floor  min = 2.205e-02
```

**Theorem 5.4 (the uniform/covering exponent is $1/2$, with a sharp constant; the
upper bound is CLASSICAL, the sharpness and constant PROVED here).**
Kleinbock–Merrill Theorem 4.1 (FETCHED): every $\alpha\in S^n$ is
$(C,\tfrac12,\tfrac12)$-uniformly Dirichlet, i.e. for every $N>1$ there is $p/q\in S^n$
with $q\le N$ and $\|\alpha-p/q\| < C/(q^{1/2}N^{1/2})$ — in particular
$\sup_\theta\delta(\theta,H)\ll H^{-1/2}$. For $n=1$ this exponent is **sharp**, the
extremal directions are the cusps, and

$$\delta_{\mathrm{cusp}}(H)\;:=\;\arctan\!\bigl(1/q^*\bigr),\quad q^*=\max\{q \text{ odd}: \tfrac{1+q^2}2\le H\},
\qquad \delta_{\mathrm{cusp}}(H)\,\sqrt H \longrightarrow \tfrac1{\sqrt2},$$

where $\delta_{\mathrm{cusp}}(H)$ is **proved** to be the half-width of the gap
adjacent to each cusp, hence a lower bound for $\sup_\theta\delta(\theta,H)$; that
it is *equal* to the supremum (i.e. that the cusp gap is the widest gap) is
**MEASURED** on all 22 height scales, not proved.

*Proof.* **Exact cusp exclusion.** Let $w \in S^1(\mathbb{Q})\setminus\mu_4$ be at
angular distance $\delta$ from its nearest cusp. Reducing by $D_4$ to the cusp $1$,
$w$ has parameter $t=\tan(\delta/2)=p/q$ in lowest terms with $p\ge1$, hence
$q \ge \cot(\delta/2)$, and $\mathrm{ht}(w)\ge (p^2+q^2)/2 \ge (1+\cot^2(\delta/2))/2$:

$$\boxed{\;\mathrm{ht}(w)\;\ge\;\frac{1}{2\sin^2(\delta/2)}\;}$$

with **equality exactly** when $t=1/q$ with $q$ odd (then $p=1$ and $q=\cot(\delta/2)$
must be an integer, and $\mathrm{ht}=(1+q^2)/2$ requires $q$ odd). Inverting: no
point of height $\le H$ lies within $2\arcsin(1/\sqrt{2H})$ of a cusp, and the
bound is attained. The nearest point to the cusp $1$ among heights $\le H$ is
therefore $t=1/q^*$: a competitor $t=p/q$ with $p\ge2$ and $p/q<1/q^*$ needs
$q>2q^*$, hence height $>2q^{*2}>H$. Since the cusp itself lies in
$S^1(\mathbb{Q})$ (height 1), the gap adjacent to it has half-width exactly
$\delta_{\mathrm{cusp}}(H)=\arctan(1/q^*)$, and
$\arctan(1/q^*)\sqrt H \to 1/\sqrt2$ because $q^*=\sqrt{2H}(1+o(1))$. Combined
with Kleinbock–Merrill's $\sup_\theta\delta \ll H^{-1/2}$, the exponent $1/2$ is
sharp. $\square$

MEASURED, on all $127\,352$ non-cusp points of height $\le10^5$:

```
  exact cusp exclusion:  min over all 127352 non-cusp points of
      2 c sin^2(delta/2) = 1.000000000000   (predicted exactly 1)
  equality cases (t = 1/q, q odd): 1784
  fitted covering exponent (H>=1000): -0.5038
  sharp constant:  sup_theta delta * sqrt(H) -> 1/sqrt(2) = 0.707107;
      measured at H=100000: 0.707443
  [OK] for every H in the grid the widest gap has a cusp of mu_4 as an endpoint
```

The $1784$ equality cases are exactly the $D_4$-orbits of $t=1/q$ for the $223$ odd
$q\in[3,447]$ ($223\times8=1784$), and the measured supremum agrees with the closed
form to every printed digit: $q^*=447$, $\arctan(1/447)=2.237132733\cdot10^{-3}$
versus measured $2.2371\cdot10^{-3}$; $\arctan(1/447)\sqrt{10^5}=0.7074434865$
versus measured $0.707443$.

See `figures/exp61_covering.png` and the right panel of
`figures/exp61_circle_chart.png`, where the envelope $c = 1/(2\sin^2(\delta/2))$ is
the exact lower boundary of the point cloud.

**This is the substantive §4 finding.** The *same* countable set has approximation
exponent $1$ (typical/infinitely-often) and covering exponent $1/2$ (uniform), and
the gap between them is concentrated on a set of four points — the $D_4$-fixed
orbit. **The residual group of §3 and the metric obstruction of §5 are the same
object.** The chart's own symmetry group predicts where the chart is worst.

*Honest discrepancy report.* The naive whole-range fit of the covering exponent
gives $-0.5283$, not $-0.5$; restricting to $H\ge1000$ gives $-0.5038$. The
discrepancy is a finite-size effect (the constant approaches $1/\sqrt2$ from above,
as the printed table shows), not a different exponent; we report both fits rather
than only the flattering one. The exponent-$1$ fit needed no such restriction.

### 5.3 (iii) The omitted locus, and what fails under completion

$S^1(\mathbb{Q})$ is countable, hence Lebesgue-null and meager in $S^1$. "Measure
zero is not informational irrelevance" (§4): the omitted locus has structure.

**The extremal obstruction is $\mathrm{BA}(S^1)$**, characterized exactly in
Theorem 5.3 as $\{\theta : \tan(\theta/2)$ has bounded partial quotients$\}$. It is
null but thick (Hausdorff dimension 1 in every open set — CLASSICAL, KM Thm 1.2,
FETCHED), so it is invisible to measure and maximal for dimension: the omitted
points that are *hardest* to reach form a fractal of full dimension.

**Pass/fail under completion.**

| Structure | Passes to $S^1$? | Statement |
|---|---|---|
| **Group law** | **PASSES** | $S^1(\mathbb{Q})\le S^1$ is a subgroup (Thm 4.1); this is the one structure that survives intact |
| Density / closure | PASSES | $\overline{S^1(\mathbb{Q})}=S^1$ (Thm 5.1 + density of $\mathbb{Q}$) |
| Cyclic order, metric | PASSES | inherited |
| Equidistribution of bounded height | PASSES on the mean count only | ~~measured constant $1.274$ vs $\pi^2/8$~~ — struck, see the note below §5.2 |
| **Completeness** | FAILS | Cauchy sequences of rational points converge to irrational points; $S^1(\mathbb{Q})$ is not complete |
| **Compactness** | FAILS | not closed in $S^1$; not even locally compact |
| **Connectedness / IVT** | FAILS | $S^1(\mathbb{Q})$ is countable metrizable without isolated points, hence homeomorphic to $\mathbb{Q}$ (Sierpiński; CLASSICAL): totally disconnected, zero-dimensional |
| **Haar measure** | FAILS | as a topological group in the subspace topology it is not locally compact, so no Haar measure exists; the induced measure from $S^1$ is $0$ |
| **Divisibility** | FAILS | $S^1$ is divisible; $\mathbb{Z}/4\oplus\bigoplus\mathbb{Z}$ is not. E.g. $g_5$ has no square root in $S^1(\mathbb{Q})$ (its exponent vector would be $\tfrac12$) |
| **Torsion** | FAILS (drastically) | $S^1$ has torsion $\mathbb{Q}/\mathbb{Z}$; $S^1(\mathbb{Q})$ has torsion $\mu_4$ only (Niven) |
| **Uniform approximability** | FAILS in a *quantified* way | exponent drops from $1$ to $1/2$ at the four cusps (Thm 5.4) |

**A structural point the table makes visible (PROVED).** "Completion" is
*ambiguous* here and the two meanings disagree. The **topological** completion of
the chart is $S^1$ (uncountable, connected, divisible). The **algebraic** completion
(divisible hull) of $\mathbb{Z}/4\oplus\bigoplus_{p\equiv1(4)}\mathbb{Z}$ is
$\mathbb{Z}(2^\infty)\oplus\bigoplus_{p\equiv1(4)}\mathbb{Q}$, which is *countable*
and is **not** isomorphic to any subgroup-with-the-right-topology of $S^1$ in a
canonical way; in particular it is not $S^1\cong\mathbb{Q}/\mathbb{Z}\oplus\mathbb{Q}^{(\mathfrak{c})}$.
So the constitution's instruction "record its ambient object, closure, completion"
has, for this model, **two different correct answers**, and they are not comparable.
That is itself the §4 lesson in its sharpest form.

### 5.4 (iv) A question visible only through the chart↔ambient relation

> **Question (rank–approximation trade-off).** For a finite set $P$ of primes
> $\equiv1\bmod4$, let $\Gamma_P=\mu_4\oplus\bigoplus_{p\in P}\langle g_p\rangle \le S^1(\mathbb{Q})$,
> a subgroup of rank $r=|P|$, dense in $S^1$ for every $r\ge1$. Define
> $\delta_P(\theta,H)$ using only points of $\Gamma_P$. **How does the
> approximation rate depend on $r$, and is the dependence governed by the
> Diophantine properties of the angles $\arg g_p$?**

Neither half of the question is visible in one language. The *rank* is purely a
chart notion (it lives in the free abelian group of §4); the *rate* is purely
ambient (it lives in the metric of $S^1$). The height law of Prop. 4.2 is the
bridge: points of $\Gamma_P$ of height $\le H$ are exactly the lattice points of
$\mathbb{Z}^r$ in the weighted $\ell^1$ ball $\sum_{p}|e_p|\log p \le \log H$, so
their number is $\asymp (\log H)^r$ rather than $\asymp H$.

> **Amended in place — SEED-119, 2026-08-14, executing
> `notes/SEED88_RANK_ORBIT_HAAR_RATE.md` §8 item 4 (Rule K3). The three
> substantive claims below were checked against SEED-88 §§1–4 before applying.**
>
> 1. ~~"this requires genuine equidistribution of the $r$-dimensional orbit …
>    exactly a linear-forms-in-logarithms question"~~ — **withdrawn.** The
>    equidistribution is not open and needs no Baker: $\overline{\Gamma_P}=\mathbb T$
>    and the unique invariant measure is Haar, by a Pontryagin-annihilator argument
>    resting on nothing beyond unique factorization in $\mathbb Z[i]$ (SEED-88
>    Lemmas 1.1–1.3). Qualitative equidistribution of the *height-ordered* sets is
>    then unconditional, because the weighted $\ell^1$ balls are Følner (SEED-88
>    Lemma 5.1, Cor. 5.2).
> 2. ~~"the count heuristic gives $\delta_P\asymp(\log H)^{-r}$"~~ — **mis-located.**
>    The part of that law which is true is a counting statement and uses no
>    dynamics: the *mean* gap is $2\pi/\#\Gamma_P(H)$ by definition, and
>    $\#\Gamma_P(H)=\frac{2^{r+2}}{r!\prod_{p\in P}\log p}(\log H)^r+O((\log H)^{r-1})$
>    exactly (SEED-88 Thm 2.1, Cor. 2.2).
> 3. ~~"PROVED for $r=1$"~~ and ~~"$\asymp(\log H)^{-r}$"~~ — **overstated; the
>    exponent $-r$ is proved in one direction only.** The provable envelope is
>    $c_1(P)(\log H)^{-r}\le\sup_\theta\delta_P\le c_2(P,\kappa)(\log H)^{-1/(\kappa+1)}$
>    (SEED-88 Cor. 2.3 + Thm 3.1), improving to $(\log H)^{-1/\kappa}$ at $r=1$
>    (Prop. 4.1). $\sup_\theta\delta_P\asymp1/\log H$ at $r=1$ holds **iff** the
>    partial quotients of $\arg g_p/2\pi$ are bounded, which is not known for a
>    single $p$; non-Liouville is not enough. The fitted exponents displayed below
>    are therefore **class (S)**: sample statistics of a quantity whose provable
>    envelope has different exponents at its two ends, consistent with the lower
>    bound and with nothing else. **Not quotable as the exponent.**

**Heuristic answer, ~~PROVED for $r=1$~~ PROVED as a lower bound only / MEASURED for $r=2,3$.** For $r=1$ the points
are $\{i^k g_p^n\}$ and the rate is governed by the three-distance theorem for
$n\arg g_p$: $\delta_P \asymp 1/N \asymp 1/\log H$, provided $\arg g_p/2\pi$ is not
Liouville — which it is not, by Baker's theorem on linear forms in logarithms
(CLASSICAL input; we do not reprove it). For general $r$ the count heuristic gives
$\delta_P \asymp (\log H)^{-r}$, and this requires genuine equidistribution of the
$r$-dimensional orbit, i.e. quantitative independence of $\arg g_{p_1},\dots,\arg g_{p_r}$
over $\mathbb{Q}$ together with $\pi$ — exactly a linear-forms-in-logarithms
question. MEASURED with $p=5,13,17$ (`figures/exp61_rank_rate.png`):

```
  rank 1: fitted exponent of delta vs log(H) = -1.046   (predicted -1)
  rank 2: fitted exponent of delta vs log(H) = -1.975   (predicted -2)
  rank 3: fitted exponent of delta vs log(H) = -3.056   (predicted -3)
```

So the answer is: **the approximation rate collapses from polynomial to
polylogarithmic the moment the group rank is finite**, at the precise order
$(\log H)^{-r}$. Full rank buys exponent $1$ in $H$; every finite truncation of the
prime index set buys exponent $0$. The set of primes $\equiv1\bmod4$ is not a
convenience of the classification — it is metrically load-bearing.

This is the §5 payoff too: after Prop. 4.2, "how well does a subgroup approximate"
and "how many lattice points in an $\ell^1$ ball" are the *same* question, so an
entire body of lattice-point technique becomes adjacent to a Diophantine question
about $S^1$ that previously had no obvious handle.

---

## 6. Designed annihilation: the control ledger

Per `collab/PROTOCOL.md` §7 and msg 0073, the headline claims ship with their own
falsifiers. All nine planted-false statements were run through the *same* verifier
as the true claims and all nine were rejected.

| ID | Planted-false claim | Kills what | Verdict |
|---|---|---|---|
| **A** | "the Euclid domain is all reduced fractions in $(0,1)$" (parity condition vacuous) | §2.1 bijectivity | REJECTED — $(1,3),(1,5),(1,7),\dots$ omitted |
| **B** | "the fiber of $\mathrm{PT}\leftarrow S^1(\mathbb{Q})$ has size 4" | Thm 3.2 | REJECTED — $127356\ne4\cdot15919+4$ |
| **C** | Barning–Hall matrix $A$ with entry $(3,3)$ changed $3\to2$ | §2.3 | REJECTED — $2000/2000$ images non-Pythagorean; $A'(3,4,5)=(5,12,8)$ |
| **D** | "$A$ acts on the CF by prepending $[1,1]$ verbatim" (no $a_1-1$) | §2.4 | REJECTED — $2692/3000$ mismatches |
| **E** | "$(4/5,3/5)$ generates the $p=5$ component" | Thm 4.1 generators | REJECTED — it is $i\overline{g_5}$, not a power of $g_5$ |
| **F** | "the approximation exponent is $-1/2$" | Thm 5.2 | REJECTED — rms $0.878$ vs $0.015$ |
| **G** | "the approximation exponent is $-2$" | Thm 5.2 | REJECTED — rms $1.774$ vs $0.015$ |
| **H** | "the covering constant is $1$" | Thm 5.4 constant | REJECTED — measured $0.7074$ |
| **I** | "the sharp cusp bound is $c\ge1/\sin^2(\delta/2)$" (factor 2 removable) | Thm 5.4 sharpness | REJECTED — $t=1/q$, $q$ odd, attains the factor-2 version |

Round-trip assertions (Task C(a)) are exact and exhaustive on the stated range:
chart 1↔2, 1↔3, 1↔4, 4↔5, 5↔SB, and the group-theoretic reconstruction
$w = (u/\bar u)\prod g_p^{e_p}$, each on all $15919$ primitive triples with
$c\le10^5$ (some on stated subsamples, noted in the log). Final line of
`data/exp61_out.txt`:

```
  ALL CHECKS PASSED; ALL PLANTED-FALSE CONTROLS REJECTED.
```

### 6.1 What was **not** verified (Task C(d))

Stated explicitly so an auditor does not have to infer it:

1. **Nothing is verified above $c=10^5$.** All exact claims are theorems with
   proofs here; the computation confirms them on $15919$ triples / $127356$ points
   only. The Barning–Hall tree is complete only through level 5 in this window.
2. **The Diophantine exponents are MEASURED, not proved, as *fits*.** Theorem 5.2
   and 5.4's exponents are proved; the *numbers* $-0.9965$, $-0.5038$ are least-squares
   fits over $22$ height scales with $3000$ random angles, in float64.
3. **The rank-$r$ rates for $r=2,3$ are MEASURED only.** The $(\log H)^{-r}$ law is
   a counting heuristic plus equidistribution; ~~the equidistribution input is a
   genuine open-flavoured question (quantitative linear independence of
   $\arg g_p$ over $\mathbb{Q}+\mathbb{Q}\pi$). We did not prove it and did not
   invoke an effective form of Baker's theorem.~~
   **Corrected in place (SEED-119, 2026-08-14, Rule K1/K3, on the authority of
   `notes/SEED88_RANK_ORBIT_HAAR_RATE.md`; see the amendment box at §5.5).** The
   equidistribution input is **not open** — it is Haar, constructed
   unconditionally (SEED-88 Lemma 1.3), and joint linear independence of the
   $\arg g_p$ is not needed even for a *rate*: one coordinate's effective
   irrationality measure suffices (SEED-88 Rmk 3.2). What is actually unclosed is
   the **envelope** — $\gg(\log H)^{-r}$ against $\ll(\log H)^{-1/(\kappa+1)}$ —
   so $-r$ is proved only as a lower bound, for $r=1$ as well as $r=2,3$. The
   sharp rate is a **bounded-partial-quotient** question, not a
   linear-independence one. This item as originally written told the reader that
   a solved problem is open and that an open problem is measured.
4. **The BA/Liouville comparison is two hand-picked directions**, not a measure- or
   dimension-theoretic statement. We did not compute Hausdorff dimensions.
5. **No formalization.** Nothing here is checked in Lean or Cubical Agda. The
   constitution's §7 layer (content-addressed presentations, checked transports) is
   *not* exercised; the transition maps of §2 are exactly the kind of object that
   would deserve it, and that remains a stated debt.
6. **Literature search was targeted, not exhaustive.** Specifically we did not
   search for prior art on the *sharp constant* $1/\sqrt2$ in Thm 5.4, nor on the
   BH$\to$CF digit dictionary of §2.4; both are elementary enough that prior
   appearances are likely (see §7).
7. **The $\mathbb{Z}[i]$ factorization used a $10^5$ smallest-prime-factor sieve**;
   no independent primality certification was performed.

---

## 7. Attribution: classical, and plausibly new

**CLASSICAL (cited, and re-proved here only for executability):** Euclid's
parametrization and stereographic bijectivity (§2.1, §5.1); the Gaussian-integer
description and $c=\prod p^{e}$ with $p\equiv1\ (4)$ (§3.1, §4); the Barning–Hall
ternary tree (§2.3; **FETCHED**: Wikipedia "Tree of primitive Pythagorean triples",
citing Barning 1963 and Hall, *Math. Gazette* 54 (1970) 377–379); the group
structure $\mathbb{Z}/4\oplus\bigoplus_{p\equiv1(4)}\mathbb{Z}$ (§4; **FETCHED**:
Wikipedia "Group of rational points on the unit circle", citing Lin Tan, *Math.
Magazine* 69 (1996) 163–171 — the *Magazine article itself was not read*, so the
attribution rests on the encyclopedia's citation: label **śabda / weakest pramāṇa**);
Niven's theorem (§4, FETCHED); the Stern–Brocot run-length encoding of a continued
fraction (§2.5); Lehmer's $H/(2\pi)$ count (§0, FETCHED); intrinsic Dirichlet and
badly-approximable thickness on $S^n$ (§5.2, §5.4; **FETCHED with theorem text
extracted from the PDF**: Kleinbock–Merrill, Israel J. Math 209 (2015) 293–322,
arXiv:1301.0989, Theorems 1.1, 1.2, 4.1, and their attribution of $C=2\sqrt2$ for
$n=1$ to Fukshansky via Hlawka 1980).

**Written here, novelty NOT claimed without a search (see §6.1 item 6) — these are
elementary and are offered as *executable, checked* statements rather than as
discoveries:**

- §2.4 the explicit Barning–Hall $\to$ continued-fraction digit dictionary
  ($A:[1,1,a_1{-}1,\dots]$, $B:[2,a_1,\dots]$, $C:[a_1{+}2,\dots]$) with its
  canonicalisation rewrites, verified on all triples with $c\le10^5$.
- §2.5 the $SL_2(\mathbb{F}_2)$ parity monodromy identifying the Euclid domain as
  4 of the 6 Stern–Brocot mod-2 classes.
- §3.2 the fiber theorem in the stated exact form (fiber $=D_4$, single non-free
  orbit $\mu_4$, count identity $8\cdot\#\mathrm{PT}+4$), together with the
  identification of the rotation generator as multiplication by the **ramified
  prime $(1+i)$** rather than by a unit.
- §4 Prop. 4.2, the height-as-$\ell^1$-norm statement $\mathrm{ht}=\prod p^{|e_p|}$.
- §5.4 the exact cusp-exclusion inequality $\mathrm{ht}(w)\ge 1/(2\sin^2(\delta/2))$
  with its equality case $t=1/q$, $q$ odd; the resulting sharpness of
  Kleinbock–Merrill's uniform exponent $b=1/2$ for $n=1$; and the sharp constant
  $\sup_\theta\delta(\theta,H)\sqrt H \to 1/\sqrt2$.
- §5.3 the observation that the topological and algebraic completions of this chart
  are both correct and mutually incomparable.
- §5.4 the rank–approximation trade-off question and its $(\log H)^{-r}$ law.

The genuinely *interesting* item, and the one an audit should attack first, is the
coincidence in §5.4: the group that measures the failure of translation between
charts ($D_4$) is the same group whose fixed orbit measures the failure of the
chart to approximate the ambient space uniformly. If that is a known statement, it
should be cited; if it is a coincidence of this model only, that is worth knowing.

---

## 8. Reproduction

```
python3 code/exp61_rational_circle_atlas.py     # ~3 min, exits 0 iff all checks pass
```

Exit status is the verdict: nonzero if any check fails **or** any planted-false
control is accepted.

---

**Status: PENDING HOSTILE AUDIT.**
