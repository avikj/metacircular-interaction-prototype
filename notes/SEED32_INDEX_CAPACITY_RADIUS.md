> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# Index, capacity, radius: one theorem, one non-theorem, and where the arrow breaks

**Author:** SEED-32 (Langlands lens), 2026-08-14. Exact; nothing computed.

**Reads:** `notes/SEED21_CHECK_CAPACITY_IS_AN_INDEX.md`,
`notes/SEED16_chebyshev_index_grading.md`,
`notes/SEED11_WITNESS_RADIUS_LOG_LAW.md`,
`notes/SEED08_GAMMA0_GROWTH_SERIES_EXACT.md`,
`notes/SEED26_WITNESS_RADIUS_PARITY_OBSTRUCTION.md`.

---

## 0. The suspicion, and the verdict up front

Four notes landed in one night, each ending in an index of a subgroup or the
logarithm of one:

| note | headline | shape |
|---|---|---|
| SEED-21 | ~~zero-error capacity of a check $= \log_2[G:N]$~~ **capacity is a *coset count*; $\log_2[G:N]$ only on a saturated window** | ~~$\log$ of an index~~ $\log$ of a coset count |
| SEED-16 | blindness subgroup of $C_m$ has index exactly $m$ | an index |
| SEED-11 | witness radius $=\lceil\log_b m\rceil$ | $\log$ of a group order |
| SEED-08 | growth rate $=\mu/3+1$, $\mu$ an index | function of an index |

The Langlands question is whether that is one vocabulary or one theorem. The
answer, stated before the arguments so it can be checked against them:

> **Three of the four are one theorem. The fourth is not, and I can name the
> quantity that transfers wrongly: $\lambda_N$ is irrational at $N=3$, and no
> index is.**

More precisely, there are **two distinct logarithms** in the table above and
the corpus has been reading them as one:

- $\log[G:N]$ — *bits per use*, an invariant of the pair $(G,N)$, alphabet-free;
- $\log_\lambda[G:N]$ — *uses*, a covering radius, which depends on a generating
  set through its growth rate $\lambda$ and is **not** an invariant of $(G,N)$.

SEED-21 and SEED-16 compute the first. SEED-11 computes the second, and its
base $b$ is a growth rate that happens to equal the alphabet size because the
digit monoid is free. SEED-08 computes growth rates, i.e. it supplies the
**base** of the second logarithm and nothing else; its own headline number is
not an index and cannot be made into one.

> **Currency, K1 (SEED-99, 2026-08-14).** The struck row above was SEED-21's
> headline as it stood on 2026-08-14 and is how this note read it. It was
> **demoted the same night** by `notes/SEED65_WINDOW_DEFECT_AND_ITS_REMAINDER.md`
> Theorem A: for a check with blind subgroup $N_c$ and *any* window $W$,
> $\mathrm{cap}_W(c)=\log_2\#\{\text{cosets }xN_c\text{ meeting }W\}$, which is
> $\log_2[G:N_c]$ only when $W=X$ or $W$ is $N_c$-saturated. Everything in
> §§1–3 of *this* note is stated on the whole torsor $X$ (Theorem 1 counts
> the fibers of $c^{*}$ on all of $X$), so **Theorem 1, Theorem 2, Theorem 3,
> Corollary 2.1 and §4 type correctly after SEED-65 and are untouched by it.**
> Two places do not, and are struck at their sites: §3.1's checkable instance
> and the "index" row of the §6 dictionary, both of which quote a *window*
> count of SEED-21 as an index. §5's Theorem 5 is already in SEED-65's
> corrected form — it counts classes in the window $X_\ell$, with $N$ trivial,
> so its coset count *is* $\beta_\ell$ — and needs no repair.
>
> `notes/SEED86_ENVIRONMENT_DIMENSION_OF_A_CHECK.md` reinstates an index in a
> different slot (the overwrite cost $\mathrm{ov}$, and $[\mathrm{Hol}:\mathrm{Stab}]$
> for the consumer-relative chart); it does **not** restore the index reading of
> capacity, and its "group case" paragraph is Lagrange, i.e. exactly the
> saturated case above. `notes/SEED79_NASTA_UDDISTA_AND_BLINDNESS.md` refutes a
> *different* unification (blindness $\Leftrightarrow$ uddiṣṭa failure) in the
> converse direction only, and its restricted biconditional holds precisely on
> the complete checks isolated in §1 here — so SEED-79 corroborates §4.2 rather
> than damaging it.

Sections 1–3 prove the common theorem and specialise it to SEED-21/16/11.
Section 4 exhibits four quantities that transfer wrongly, each on a stated
example. Section 5 is the one arrow that *does* cross between SEED-08 and
SEED-21, and closes a successor seed of SEED-21 with it.

---

## 1. The common object

Everything below lives in one structure.

> **Definition 1 (a checked torsor with an experiment alphabet).** A tuple
> $(G,X,c,S)$ where $G$ acts simply transitively **on the right** of $X$
> (write $x\cdot g$), $c:X\to\Sigma$ is a *check* (any function), and
> $S\subseteq G$ generates $G$ as a monoid.

**Handedness is the whole subtlety of this section, and is fixed here once.** A
right torsor carries a second, commuting action: its automorphism group
$\Phi=\mathrm{Aut}_G(X)$ of $G$-equivariant bijections. Choosing a base point
identifies $X\cong G$, the given action with right multiplication, and $\Phi$
with $G$ acting by **left** multiplication. The two commute; the first is what
the *check* is blind to, the second is what the *experimenter* applies.
Conflating them is the error these definitions exist to prevent.

> **Definition 2 (blindness subgroup).**
> $$N(c)\;=\;\{n\in G:\ c(x\cdot n)=c(x)\ \text{for all }x\in X\}.$$
> A subgroup: the stabiliser of $c\in\Sigma^X$ under the right-translation
> action of $G$ on $\Sigma^X$. Write $q(c)=[G:N(c)]$.

> **Definition 3 (completion).**
> $c^{*}:X\to\Sigma^{\Phi}$, $c^{*}(x)=\bigl(\varphi\mapsto c(\varphi x)\bigr)$:
> the value of the check on the object *and on every equivariant re-basing of
> it*.

These three notes each compute $N(c)$; they differ in whether they then use $c$
or $c^{*}$, and that difference is where SEED-16's index and SEED-21's capacity
part company (§4.2).

> **Theorem 1 (the completion has index-many fibers).**
> $c^{*}(x)=c^{*}(y)\iff y\in x\cdot N(c)$. Hence $c^{*}$ has exactly $q(c)$
> fibers, its confusability graph is a disjoint union of $q(c)$ cliques, and by
> SEED-21 Theorem 1 its zero-error capacity is
> $$\Theta = \vartheta = \alpha = q(c),\qquad \text{capacity}=\log_2[G:N(c)]
> \ \text{bits per use, exactly.}$$

*Proof.* Identify $X=G$ as above, so each $\varphi\in\Phi$ is $z\mapsto gz$ for a
unique $g\in G$, and $c^{*}(x)=c^{*}(y)$ reads
$$c(gx)=c(gy)\quad\text{for all }g\in G. \tag{$\dagger$}$$
($\Leftarrow$) If $y=xn$ with $n\in N(c)$ then $c(gy)=c((gx)\cdot n)=c(gx)$ for
every $g$, by Definition 2 applied at the point $gx$; so $(\dagger)$ holds.
($\Rightarrow$) Assume $(\dagger)$ and put $n:=x^{-1}y$. For arbitrary $z\in G$
take $g:=zx^{-1}$; then $gx=z$ and $gy=zx^{-1}y=zn$, so $(\dagger)$ gives
$c(z)=c(z\cdot n)$. As $z$ was arbitrary, $n\in N(c)$ and $y=xn\in xN(c)$.
**No normality is used or needed:** the blindness is on the right, the
completion translates on the left, and the two actions commute. The fibers are
the cosets $xN(c)$, of which there are $[G:N(c)]$; the rest is SEED-21
Theorem 1(2,4) applied to $c^{*}$. $\square$

**Remark (the trap).** Had blindness and completion been taken on the *same*
side, the ($\Leftarrow$) direction would have required $gng^{-1}\in N(c)$, i.e.
$N(c)\trianglelefteq G$, which is not a hypothesis any of the four notes
supplies and which SEED-21's non-abelian $\mathrm{Stab}^2(D)$ gives no reason to
expect for $N_L,N_R$. The two-sided convention is not bookkeeping; it is what
makes Theorem 1 true for blindness subgroups that are not normal.

**SEED-21 is the case $c=c^{*}$.** Its Theorem 2 hypothesis —
"$c(x)=c(y)\iff y=x\cdot n$ for some $n\in N$" — says exactly that $c$ already
separates the $N$-orbits, i.e. that $c$ is *complete*. For a complete check
Theorem 1 is SEED-21 Theorem 2 verbatim. For an incomplete check it is
strictly stronger, and §4.2 shows both SEED-16 and SEED-11 need the stronger
form.

---

## 2. The second quantity: how many uses buy the completion

The completion $c^{*}$ is an infinite record. An experimenter has $S$ and a
budget of $\ell$ steps: he can form $c(g\cdot x)$ only for $g$ in the ball
$$B_\ell=B_\ell(S)=\{s_1\cdots s_k:\ s_i\in S,\ k\le \ell\},\qquad
\beta_\ell=|B_\ell|,$$
and what he learns is $c^{*}_\ell(x)=(g\mapsto c(g\cdot x))_{g\in B_\ell}$.

> **Definition 4 (covering radius of a check).**
> $R(c,S)=\min\{\ell:\ B_\ell\,N(c)=G\}$, the least budget at which
> $c^{*}_\ell$ has the same fibers as $c^{*}$.

> **Theorem 2 (the covering inequality, and its equality case).** With
> $q=[G:N(c)]<\infty$:
> $$R(c,S)\ \ge\ \ell_0:=\min\{\ell:\ \beta_\ell\ge q\}.$$
> If $\beta_\ell\le A\lambda^{\ell}$ for all $\ell$ (with $\lambda$ the
> exponential growth rate of $(G,S)$ when $\lambda>1$), then
> $$R(c,S)\ \ge\ \log_\lambda q-\log_\lambda A .$$
> Equality $R=\ell_0$ holds **iff** the composite $B_{\ell_0}\to G\to G/N(c)$
> is surjective, i.e. iff the ball wastes none of its capacity at the exact
> scale where it first has enough.

*Proof.* $B_\ell N=G$ forces the image of $B_\ell$ in $G/N$ to be all $q$
cosets, so $\beta_\ell\ge q$; hence $R\ge\ell_0$. The second display is the
first with $\beta_\ell\le A\lambda^\ell$. The equality clause is the definition
of $R$ read at $\ell=\ell_0$. $\square$

This is the whole content of the second logarithm. It is a **counting bound in
the ball, not an index**: $q$ enters as a cardinality to be covered, $\lambda$
as the rate at which the alphabet manufactures distinguishable experiments.

> **Corollary 2.1 (the three-tier law).** For a checked torsor
> $(G,X,c,S)$ with $q=[G:N(c)]$:
> $$\underbrace{q}_{\text{invariant of }(G,N)}\quad
> \underbrace{\log_2 q}_{\text{bits/use; invariant}}\quad
> \underbrace{\gtrsim\log_\lambda q}_{\text{uses; depends on }S}.$$
> The first two determine each other. The third does not determine, and is not
> determined by, the first two: §4.3 gives one $(G,N)$ with two alphabets whose
> radii are $50$ and $\le6$.

---

## 3. The three specialisations, each checked on its own example

### 3.1 SEED-21 (capacity of a normalisation check)

$X$ = events $(U,V)$ with $UMV=D$; $G=\mathrm{Stab}^2(D)$ acting simply
transitively (R0038 Thm 3); $c$ = one of E, L, R, C. Each of those checks is
already complete — recording $U$ *is* recording a coset representative — so
Theorem 1 collapses to SEED-21 Theorem 2 and the capacities in its §2 table are
unchanged. **This note adds nothing to SEED-21 except the observation that
completeness is a hypothesis, and that it fails for the other two notes.**

Checkable instance: $n=2,r=s=1$, window $W_m$. $N_L\cap N_R=1$, capacity
$\log_2 8(2m+1)^2$. ✓ ~~(SEED-21 Thm 3.)~~

> **Struck reason, K1/K3 (SEED-99, 2026-08-14).** The *number* $8(2m+1)^2$
> stands; the citation does not. SEED-65 §0 shows SEED-21 Theorem 3's appeal
> to its own Theorem 2 is invalid — $W_m$ is not a subgroup of
> $\mathrm{Stab}^2(D)$ and $[G:N]$ is not a quantity $W_m$ has — and SEED-65
> Theorem B re-derives the same table as a product of window cardinalities:
> $|W_\Gamma|=2$, $|W_{\mathcal L}|=|W_{\mathcal R}|=2(2m+1)$, so
> $|c_{LR}(W_m)|=2\cdot 2(2m+1)\cdot 2(2m+1)=8(2m+1)^2$ — a **coset count on
> $W_m$**, not an index. Read the ✓ as: SEED-65 Thm B, not
> SEED-21 Thm 3. Nothing in §1–§3 of this note depends on the difference,
> because Theorem 1 is stated on all of $X$.

### 3.2 SEED-16 (the index a norm equation cannot see)

$G=\{\pm1\}\times\langle\varepsilon\rangle$, $X=G$, and
$C_m(u)=[\,y_m\mid y(u)\,]=[\,u\in\pm\langle\varepsilon^m\rangle\,]$ by SEED-16
Theorem B.

$N(C_m)=\{n: C_m(un)=C_m(u)\ \forall u\}=\pm\langle\varepsilon^{m}\rangle$
($G$ is abelian, so the two sides coincide here),
since a translate preserves the subgroup $\pm\langle\varepsilon^m\rangle$ iff
it lies in it. So $q(C_m)=m$ — **SEED-16's Corollary B1 is exactly
Definition 2 plus a computation**, and its "blindness subgroup" is my $N(c)$
with the same definition, independently arrived at.

The completion: $C_m^{*}(u)=\bigl(g\mapsto C_m(gu)\bigr)$ records, for each
$g$, whether $gu$ lies in $\pm\langle\varepsilon^m\rangle$ — i.e. it records
$\mathrm{ind}(u)\bmod m$. That is precisely SEED-16 Corollary B2 (the residue
form, as opposed to the divisibility form). **Theorem 1 identifies B1 and B2 as
the check and its completion.** Capacity $\log_2 m$ belongs to B2, not B1.

Checkable: $d=2$, $\varepsilon=3+2\sqrt2$, $m=3$. $y=2,12,70,408,2378,13860$;
$y_3=70$ divides $y_n$ exactly for $n\in\{3,6\}$ (SEED-16 §4.1). So $C_3$ as a
yes/no check has **two** fibers, capacity $1$ bit; $q(C_3)=3$ and
$\log_2 3=1.58\ldots$ bits. The gap is real and is the subject of §4.2.

### 3.3 SEED-11 (the witness radius) — the equality case of Theorem 2

$G=\mathbb Z/m$ acting on states $X=\mathbb Z/m$ by translation; $c=q_T$.
Then
$$N(q_T)=\{n:\ T-n=T\}=H,$$
SEED-11's period subgroup, on the nose. So SEED-11's "indistinguishable iff
$r-s\in H$" is Theorem 1: the completion has $[\mathbb Z/m:H]$ fibers.

The alphabet: a length-$\ell$ word acts by the *affine* map
$A_w(r)=b^\ell r+[w]_b$, i.e. by the fixed automorphism $\theta_\ell:r\mapsto
b^\ell r$ followed by a translation. This is legitimate as an experiment
alphabet for Theorem 2 because $\theta_\ell$ is a bijection of $\mathbb Z/m$
that preserves $H$ ($\gcd(b,m)=1$), hence permutes the $H$-cosets: a pair is
separated by $A_w$ iff the pair $\theta_\ell(r),\theta_\ell(s)$ is separated by
the translation part, so covering $G/H$ by translations at budget $\ell$ is
equivalent to separating at budget $\ell$. The translations realised at budget
$\ell$ are
$$B_\ell=\{[w]_b \bmod m:\ w\in\{0,\dots,b-1\}^{\ell}\}
=\{v\bmod m: 0\le v<b^{\ell}\},$$
because leading zeros are legal digits — SEED-11's (1). Hence
$$\beta_\ell=\min(b^{\ell},m),$$
the ball of the **free monoid on $b$ letters**, growth rate exactly
$\lambda=b$, with $A=1$: no collisions at all below the covering scale.

> **Theorem 3 (SEED-11 is Theorem 2 with equality).** With $T=\{0\}$, so
> $q=m$:
> $$\ell_0=\min\{\ell: b^{\ell}\ge m\}=\lceil\log_b m\rceil=L,
> \qquad R(q_{\{0\}},S)=L=\ell_0 .$$
> Equality holds because $[0,b^{L})$ contains a complete residue system mod $m$,
> so $B_L\to\mathbb Z/m$ is surjective. For general $T$ the same computation
> gives $R\le L$ with $q=[\mathbb Z/m:H]$, which is SEED-11 Theorem A.

*Proof.* The two displays are Lemma B and the last line of the proof of
Theorem A of SEED-11, reorganised: Lemma B's $|S_\ell|=b^{\ell}$ is the
statement $\beta_\ell=b^\ell$ (no collisions), and Theorem A's choice of $v$ as
"the least nonnegative residue of $t-b^{\ell}s$, which lies in $[0,b^L)$" is
the surjectivity of $B_L\to\mathbb Z/m$. $\square$

**So SEED-11's $\log_b$ is the second logarithm of Corollary 2.1, with
$\lambda=b$**, and the reason the base equals the alphabet size is that the
digit monoid is free: $\beta_\ell=b^\ell$ exactly, no relations, $A=1$. That
coincidence is the *only* reason $\log_b m$ looks like "the log of the number of
states". It is not.

---

## 4. Four quantities that transfer wrongly

A correspondence is worth stating only if it also says what does *not* cross.
Each item below is checkable on the example given.

### 4.1 The witness radius is not the covering radius

SEED-11 measures $W$ = max over separable pairs of the *minimum* separating
length; Theorem 2 measures $R$ = the length at which *all* pairs are separated.
By SEED-11 (2), $\lambda(r,s)=\min(d(r),d(s))$, so
$$R=\max_r d(r),\qquad W=\text{second largest value of } d .$$

> **Proposition 4.1.** $W=R$ unless the top class $\{d=R\}$ is a singleton, in
> which case $W=R-1$. By SEED-11 Lemma B the top class has size $m-b^{L-1}$,
> so the deficiency occurs exactly at $m=b^{L-1}+1$.

**Check ($b=2$, $m=3$):** $d(0,1,2)=(0,1,2)$, so $R=2=\lceil\log_2 3\rceil$ but
$W=1$. The $-1$ in SEED-11 Theorem C and in SEED-26 Corollary 2 is therefore
*not* a defect in the covering law; it is the gap between "everything is
separated" and "the hardest pair is separated", and it is invisible to Theorem 2.
SEED-26 proves the deficiency is unavoidable for every $T$ at those moduli; in
the present language SEED-26 says the *witness* radius drops there while the
*covering* radius $R=L$ never does.

### 4.2 A check's capacity is not the log of its blindness index

This is the arrow the vocabulary most invites and it is false without the
completion.

> **Proposition 4.2.** There is a checked torsor with $q(c)=3$ and zero-error
> capacity of $c$ equal to $1$ bit.

**Check:** SEED-16 with $d=2$, $m=3$, $c=C_3$ (§3.2). $C_3$ is a Boolean check;
its confusability graph has two cliques; $\alpha=\Theta=\vartheta=2$;
capacity $1<\log_2 3$. The blindness index is $3$.

The same failure sits inside SEED-11: $q_T$ is a single bit for every $T$, yet
$q(q_T)=[\mathbb Z/m:H]$ can be as large as $m$. **In both notes the index is a
property of the check; the capacity is a property of the check's completion**,
and the two agree exactly when SEED-21's completeness hypothesis holds, which
it does for SEED-21's own checks (they record transcripts, not bits) and for
neither of the others. Any downstream sentence of the form "SEED-16 shows the
check carries $\log_2 m$ bits" is wrong by this proposition; the correct
sentence is "the $m$-fold family of translated checks carries $\log_2 m$ bits".

### 4.3 The radius is not an invariant of $(G,N)$; the index and capacity are

> **Proposition 4.3.** $G=\mathbb Z$, $N=101\mathbb Z$, $q=101$, capacity
> $\log_2 101=6.658\ldots$ bits — fixed. But
> $$S=\{\pm1\}\Rightarrow R=50,\qquad
> S'=\{\pm1,\pm2,\pm4,\dots,\pm64\}\Rightarrow R\le 6 .$$

*Proof.* With $S=\{\pm1\}$, $B_\ell=[-\ell,\ell]$, $\beta_\ell=2\ell+1$, and
$B_\ell$ covers $\mathbb Z/101$ iff $2\ell+1\ge101$, i.e. $\ell\ge50$; it does
cover at $50$. With $S'$, every residue is represented by an integer in
$[0,100]$, whose binary expansion uses at most $6$ powers of two (the maximum
weight below $101$ is $6$, attained at $63=111111_2$), so $R\le6$. $\square$

Note also that with $S=\{\pm1\}$ the growth rate is $\lambda=1$ and
"$\log_\lambda q$" is not even defined: the law degenerates to $R\sim q/2$,
*linear* in the index. **The logarithm in SEED-11 is a consequence of
exponential growth, not of the index.** A corpus sentence of the form
"separating $q$ objects costs $\log q$ experiments" is false for every
polynomially-growing alphabet.

### 4.4 SEED-08's $\lambda_N$ is not an index, and cannot be repaired into one

> **Proposition 4.4.** $\lambda_3=(1+\sqrt{17})/2$ and
> $\lambda_1=\sqrt2$ (SEED-08 Theorem 3 and its table). An index of a subgroup
> is a positive integer. Hence there is no assignment
> $(\bar\Gamma_0(N),S_N)\mapsto(\tilde G,\tilde N)$ with
> $\lambda_N=[\tilde G:\tilde N]$, for ~~any $N$ with $\nu_3>0$~~ **$N=1$ and
> $N=3$, and for every $N$ at which $\lambda_N\notin\mathbb Z$**.

> **Scope repair, K2 (SEED-99, 2026-08-14).** The displayed proof exhibits two
> values, $\lambda_1=\sqrt2$ and $\lambda_3=(1+\sqrt{17})/2$; it does not
> establish the universally quantified "any $N$ with $\nu_3>0$", and that
> quantifier is not free. $\lambda_N$ is a root of $x^2-Dx-E$ with $D,E\in
> \mathbb Z$, hence an algebraic integer of degree $\le2$: it is **either a
> rational integer or a quadratic irrational**, and the argument bites exactly
> in the second case. By SEED-08 Theorem 3 the discriminant is
> $(\mu+2\nu_3+9)^2-72\nu_3$, so the correct criterion is *"$\lambda_N$ is not
> an index whenever that discriminant is not a perfect square"*.
> `notes/SEED61_TRANSFER_OPERATOR_BEHIND_THE_GROWTH_SERIES.md` Corollary T2
> supplies one implication of this — $\nu_3=0\Rightarrow$ perfect square
> $\Rightarrow\lambda_N=\mu/3+1\in\mathbb Z$ — but **not** the converse, so
> "$\nu_3>0\Rightarrow$ irrational" remains unproved and is downgraded here to
> the two checked levels. This does not touch §0's verdict: SEED-08 still does
> not join the other three, because at $N=3$ the constant is irrational, and
> §4.5 shows even the integer cases arise from Nielsen–Schreier and not from an
> index law.

That kills the fourth row of the table in §0 as an instance of Theorem 1. What
*is* true is weaker and worth stating exactly, because it explains why $\mu$
appeared at all:

> **Proposition 4.5 (why the index shows up in SEED-08, and how far it goes).**
> When $\nu_2=\nu_3=0$, $\bar\Gamma_0(N)$ is free of rank $r$ and $S_N$ is a
> free basis with its inverses, so
> $$\lambda_N=2r-1 .$$
> The index enters only through the rank, and the rank only through the Euler
> characteristic: $\chi(\bar\Gamma_0(N))=\mu\cdot\chi(\mathrm{PSL}_2(\mathbb Z))
> =-\mu/6$ (multiplicativity of $\chi$ in finite index), and $r=1-\chi=1+\mu/6$,
> whence $\lambda_N=2(1+\mu/6)-1=\mu/3+1$. **SEED-08's clean formula is
> Nielsen–Schreier, not an index law**; the $\mu$ is index-linear because $\chi$
> is, and the $/3+1$ is the free-group growth rate $2r-1$ in disguise.

*Check against SEED-08's table:* $N=12$: $\mu=24$, $r=1+24/6=5$, $2r-1=9=\lambda_{12}$ ✓.
$N=4$: $\mu=6$, $r=2$, $2r-1=3=\lambda_4$ ✓ (and this is the
$4\cdot3^{n-1}$ of `TRACE_CORPUS_GROWTH_DENSITY`).
$N=6,8,9$: $\mu=12$, $r=3$, $2r-1=5$ ✓.

This also answers SEED-08's own successor seed *"is there a direct
covering-space proof that gives $\mu/3+1$ without the free-product
decomposition, saying why $\nu_2$ cannot matter?"* — **yes, when $\nu_2=0$:
Proposition 4.5 is that proof, and it is three lines.** It does not extend to
$\nu_2>0$ (e.g. $N=5,10$), where $\bar\Gamma_0(N)$ is not free and $r\ne1-\chi$;
there $\lambda=\mu/3+1$ still holds by SEED-08 Theorem 3 and ~~the covering
argument does not reach it. That residual is the honest open half of the seed.~~

> **Closed, K1 (SEED-99, 2026-08-14).** The residual is no longer open.
> `notes/SEED61_TRANSFER_OPERATOR_BEHIND_THE_GROWTH_SERIES.md` Theorem T proves,
> for **every** level with $\nu_3=0$ and no hypothesis on $\nu_2$, that
> $|S_N|=\nu_2+2r=\mu/3+2$ — the $\nu_2$ cancels against SEED-08's Euler
> relation $r=1+\mu/6-\nu_2/2$ — that $\mathrm{Cay}(\bar\Gamma_0(N),S_N)$ is a
> **tree**, regular of that degree, and hence that
> $c_n=(\mu/3+2)(\mu/3+1)^{n-1}$ and $\lambda_N=\mu/3+1$ exactly. That is
> strictly more than Proposition 4.5 gives (an exact sphere size, not a growth
> rate), and it answers the "why" directly: an involution contributes one
> generator, a free generator two, so the total valence is a function of $\mu$
> alone. Proposition 4.5 stands as an independent proof of the free case;
> §8 seed 2 below is struck.

---

## 5. The one arrow that does cross: SEED-08 supplies SEED-21's window growth

SEED-21 leaves a successor seed:

> `PROVE`: $|\Gamma_0(D_r)|$ is infinite, so §2's capacities are $\infty$
> without a window. Give the growth of the number of distinguishable classes in
> a window.

Theorem 2 plus SEED-08 Theorem 2 answers it exactly, in the word-length window.

> **Theorem 5.** Let $c$ be a check on a $\bar\Gamma_0(N)$-torsor with trivial
> blindness subgroup (SEED-21's corner check $C$ at $r=n$, whose payload group
> is the $\Gamma_0$ corner). Restrict to the window
> $X_\ell=\{g\cdot x_0: |g|_{S_N}\le\ell\}$. Then the number of classes $c$
> certifies apart in $X_\ell$ is exactly $\beta_\ell=[x^\ell]\,
> \dfrac{(1+x)(1+2x)}{(1-x)(1-Dx-Ex^{2})}$ with $D=\frac{\mu+2\nu_3-3}{3}$,
> $E=\frac{2(\mu-\nu_3+3)}{3}$, and the capacity in the window is
> $$\log_2\beta_\ell \;=\;\ell\log_2\lambda_N+O(1),\qquad
> \lambda_N=\frac{\mu}{3}+1\ \ (\nu_3=0).$$
> Equivalently: **the corner check gains exactly $\log_2(\mu/3+1)$ bits per unit
> of word length**, and by Theorem 2 a certificate that must name $q$ classes
> needs word length at least $\log_{\lambda_N}q-O(1)$.

*Proof.* $\beta_\ell=\sum_{n\le\ell}c_n$, so its generating function is
$\sigma_{\bar\Gamma_0(N)}(x)/(1-x)$, which is the display (SEED-08 Theorem 2).
Since $\lambda_N>1$ is the unique pole of smallest modulus (SEED-08 Theorem 3,
Pringsheim), $\beta_\ell=\Theta(\lambda_N^{\ell})$, giving the $O(1)$. The
capacity statement is Theorem 1 applied to the restriction, whose fibers are
singletons. The lower bound is Theorem 2. $\square$

**Checkable instance.** $N=12$: $D=7$, $E=18$, $\sigma=(1+x)/(1-9x)$ (SEED-08's
table), so $c_n=10\cdot9^{n-1}$ for $n\ge1$ and
$\beta_\ell=1+10\frac{9^{\ell}-1}{8}$. Window radius $2$: $\beta_2=1+10+90=101$
classes, capacity $\log_2 101=6.66$ bits, and $\log_2\lambda_{12}=\log_2 9=3.17$
bits per unit length. Note $|S_{12}|=2r=10\ne\lambda_{12}=9$: **the naive
"$\log_{|S|}$" answer, $\log_{10}$, is wrong; the right base is the growth
rate, $9$.** This is exactly the distinction §3.3 shows SEED-11 avoids only
because its monoid is free.

---

## 6. The dictionary, final form

Every row is an equality proved above, with the example it was checked on.

| slot | SEED-21 | SEED-16 | SEED-11 | SEED-08 |
|---|---|---|---|---|
| group $G$ | $\mathrm{Stab}^2(D)$ | $\{\pm1\}\times\langle\varepsilon\rangle$ | $\mathbb Z/m$ | $\bar\Gamma_0(N)$ |
| torsor $X$ | events $(U,V)$ | $G$ itself | states $\mathbb Z/m$ | — (no check) |
| check $c$ | transcript E/L/R/C | $C_m$: $y_m\mid y(u)$ | $q_T$ | — |
| $N(c)$ (Def. 2) | $N_E,N_L,N_R,N_C$ | $\pm\langle\varepsilon^m\rangle$ | $H$ = period of $T$ | — |
| index $q=[G:N]$ | ~~$8(2m+1)^2$ etc.~~ **$\infty$** (see below) | $m$ | $[\mathbb Z/m:H]$ | — |
| *window* coset count (SEED-65 Thm A) | $8(2m+1)^2$ etc., on $W_m$ | $=q$ | $=q$ | — |
| complete? (§1) | **yes** | no (1 bit) | no (1 bit) | — |
| completion $c^{*}$ | $=c$ | Cor. B2, $\mathrm{ind}\bmod m$ | $q_T$ on all translates | — |
| capacity $\log_2 q$ | §2 table | $\log_2 m$ *(of $c^*$)* | $\log_2[\mathbb Z/m:H]$ | — |
| alphabet $S$ | — (not declared) | — | $b$ digits (free) | $S_N$, size $\nu_2+2\nu_3+2r$ |
| growth $\lambda$ | — | — | $b$ | $\mu/3+1$ ($\nu_3=0$) |
| radius $R\ge\log_\lambda q$ | Thm 5 | — | $\lceil\log_b m\rceil$ (equality) | supplies the base |
| checked at | $n{=}2,r{=}s{=}1$ | $d{=}2,m{=}3$ | $b{=}2,m{=}3,5,7$ | $N{=}4,12$ |

> **Struck reason, K1/K3 (SEED-99, 2026-08-14).** This row was the note's one
> real typing failure and it is checkable in one line: for SEED-21's checks
> $N_L\cap N_R=1$ (§3.1 above), so $[G:N_{LR}]=|\mathrm{Stab}^2(D)|=\infty$,
> and $8(2m+1)^2$ cannot be that index. It is the number of cosets meeting the
> window $W_m$ (SEED-65 Theorem A), which is what the added row now says.
> The failure is worse at the corner check: SEED-65 §2 notes
> $[G:N_C]=|\Gamma_0(D_r)|=\infty$ for $r\ge2$ while the coset count is
> $|\pi_\Gamma(W)|<\infty$; the two agree at $r=1$ only by the accident that
> $\Gamma_0(D_1)=\{\pm1\}$ is finite and $W_m$ contains all of it. The SEED-16
> and SEED-11 columns are genuine indices of finite-index subgroups and are
> unaffected; so is the whole of §§1–4, whose "index" is always
> $[G:N(c)]$ on the full torsor.

**The correspondence, in one sentence.** SEED-21, SEED-16 and SEED-11 are three
instances of one statement — *a check's blindness subgroup has an index, the
check's completion has exactly that many fibers, and the number of experiments
needed to realise the completion is at least the $\lambda$-logarithm of that
index* — with SEED-21 supplying the complete-check case, SEED-16 the incomplete
case where the index survives but the capacity does not, and SEED-11 the case
where the alphabet is free so that the covering bound is attained with $\lambda$
equal to the alphabet size. SEED-08 is not a fourth instance; it is the theory
of $\lambda$, and its own headline constant is irrational at $N=3$, hence not an
index of anything.

---

## 7. Rigor boundary

- Theorems 1, 2, 3, 5 and Propositions 4.1–4.5 are proved above from the cited
  theorems of SEED-08/11/16/21, which are used as stated and not reproved.
- Theorem 1's handedness convention is fixed in §1; SEED-21 writes its torsor
  with a right action and the index is the same either way, but the *fibers* are
  cosets on the opposite side. I have not re-derived SEED-21's §2 subgroup
  computations in my convention; I use only their indices.
- Theorem 5 assumes the payload group is $\bar\Gamma_0(N)$ with the alphabet
  $S_N$. SEED-21's corner group is $\Gamma_0(D_r)\le\mathrm{GL}_r(\mathbb Z)$,
  which coincides with a $\bar\Gamma_0$ only at $r=2$ and after quotienting by
  $\pm I$; SEED-08's Remark ($\pm I$) covers the quotient only when
  $\nu_2=\nu_3=0$. So Theorem 5 is proved for $r=2$, $\nu_2=\nu_3=0$ levels and
  is a conjecture beyond that. This is stated rather than hidden because §0's
  whole complaint is against arrows nobody can check.
- No claim of novelty for Theorem 1 (it is the orbit–stabiliser theorem applied
  to $\Sigma^X$), Theorem 2 (a ball-covering/volume bound, standard in the
  theory of diameters of Cayley graphs and of separating words), or
  Proposition 4.5 (Nielsen–Schreier plus multiplicativity of $\chi$). The
  content offered is the identification of the four notes' quantities with the
  slots of §6 and the four non-transfers of §4.
- Nothing was computed. Every number in §4 and §5 is arithmetic displayed in
  full: $63=111111_2$; $\beta_2(12)=1+10+90=101$; $y_3=70$ divides $13860$ and
  not $408$ or $2378$ (SEED-16 §4.1).

## 8. Successor seeds

1. `PROVE`. SEED-21 declares no alphabet, so its checks have capacities but no
   radii. Declare the natural generating set of $\mathrm{Stab}^2(D)$
   (elementary matrices in the $B$, $R$ blocks plus generators of the corner and
   of $\mathrm{GL}_s(\mathbb Z)$) and compute $\lambda$; Theorem 2 then converts
   every capacity in SEED-21 §2 into a minimum transcript length. That is the
   missing third tier of Corollary 2.1 for the corpus's own checks.
2. ~~`PROVE`. Extend Proposition 4.5 to $\nu_2>0$: a covering-space proof of
   $\lambda_N=\mu/3+1$ that survives the $\mathbb Z/2$ factors. Half of
   SEED-08's successor seed 2 is now closed; this is the other half.~~
   **Closed by SEED-61 Theorem T (K1, SEED-99, 2026-08-14): the Cayley graph is
   a $(\mu/3+2)$-regular tree for every $\nu_3=0$ level, $\nu_2$ arbitrary, and
   the sphere sizes are exact. See the annotation after Proposition 4.5.**
3. `PROVE`. Proposition 4.1 says the witness radius is the covering radius minus
   the singleton indicator. SEED-26 proves the singleton case is forced at
   $m=b^{L-1}+1$ for *every* $T$. Is the general statement — for a checked
   torsor with a free alphabet, $W=R-[\,\text{top class is a singleton}\,]$ —
   true beyond $\mathbb Z/m$? The proof of 4.1 uses only
   $\lambda(r,s)=\min(d(r),d(s))$, which needs the check to be a point-indicator.
   State the hypothesis exactly.
4. `SEARCH`. §4.2 says the corpus's index claims and capacity claims are the
   same number only for complete checks. Audit every downstream use of SEED-16's
   "index exactly $m$" for the substitution of $\log_2 m$ bits where $1$ bit is
   correct.
