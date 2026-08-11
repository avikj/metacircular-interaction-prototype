# KBOUNDARY: is sieve parity a K-theoretic boundary class of the affine Toeplitz extension?

Owner: fleet-kboundary. Executes the program spearhead (HANDOFF_EXTERNAL §3,
FAREY_TRANSFER §3), with the functorial upgrade of UNIFICATION §3 (Machine 2)
and the pre-registered prediction of TOY_OBSTRUCTION §5 as the hypothesis
under test. All literature inputs below were fetched from the primary sources
this session (arXiv PDFs, extracted and read; exact locations cited).

## 0. Verdict (outcome type: (ii) proven vanishing/no-go, with one isolated residue of type (iii))

**Theorem K (parity K-blindness of the affine Toeplitz extension).**
Let $0\to I\to\mathcal T\xrightarrow{\pi} Q_{\mathbb N}\to 0$ be the boundary
extension of the Laca–Raeburn Toeplitz algebra
$\mathcal T=\mathcal T(\mathbb N\rtimes\mathbb N^\times)$ over Cuntz's
$Q_{\mathbb N}$, and let $\alpha_\lambda$ be the Liouville gauge automorphism
($\alpha_\lambda(s_n)=\lambda(n)s_n$, GAUGE.md Lemma F.1). Then:

1. (§3) $K_0(\mathcal T)=\mathbb Z[1]$, $K_1(\mathcal T)=0$, and
   $\pi_*=0$ on $K_0$; hence the index map
   $\partial:K_1(Q_{\mathbb N})\to K_0(I)$ is **injective** and
   $\partial:K_0(Q_{\mathbb N})\to K_1(I)$ is an **isomorphism**. The
   extension is maximally non-degenerate: *every* nonzero class of
   $Q_{\mathbb N}$ bounds. No vanishing is forced by the six-term sequence.
2. (§4) Nevertheless the parity twist contributes the zero class, because it
   never defines a class: $\alpha_\lambda$ is an **outer** automorphism
   (proved here), implemented by no unitary in $Q_{\mathbb N}$, in
   $\mathcal T=M(\mathcal T)$, or in any Fredholm-compatible completion; and
   $\alpha_\lambda$ lies on the **connected** gauge torus
   $\mathbb T^{\mathcal P}$, so $(\alpha_\lambda)_*=\mathrm{id}$ on all
   $K$-groups, $[\alpha_\lambda]=[\mathrm{id}]$ in $KK$, and every
   difference-type invariant (mapping torus, Pimsner–Voiculescu, twisted
   Busby/Ext class, Fredholm pairing) **vanishes identically**. The groups
   that force this: $\pi_0(\mathbb T^{\mathcal P})=0$, homotopy invariance of
   $KK$, $K_1(\mathcal T)=0$, $[1_{Q_{\mathbb N}}]=0$.
3. (§5) The one invariant not killed by connectedness — the order-2 crossed
   product comparison — is computed:
   $Q_{\mathbb N}\rtimes_{\alpha_\lambda}\mathbb Z/2$ is Morita equivalent to
   the **parity core** ($=$ the stabilized
   $C_0(\mathbb A_f)\rtimes(\mathbb Q\rtimes H_{\mathrm{even}})$, and to
   $Q^{\mathrm{even}}$ of CORE_KMS), and its K-groups are
   $(\mathbb Z^{(\infty)},\mathbb Z^{(\infty)})$ — **abstractly identical**
   to $K_*(Q_{\mathbb N}\rtimes_{\mathrm{triv}}\mathbb Z/2)$. Parity is not
   detected. (One stage-triviality lemma inherited verbatim from Cuntz's own
   K-computation is flagged; and the equivariant $R(\mathbb Z/2)$-module
   refinement is the single isolated residue.)
4. (§4.4) Sharp contrast, from the same source: the **reflection** charge
   $n\mapsto -n$ (the program's E1/J-symmetry) **is** K-visible — Cuntz's
   $Q_{\mathbb Z}=Q_{\mathbb N}\rtimes\mathbb Z/2$ has genuinely different
   K-theory (K-parity shift; the dihedral Bunce–Deddens core has
   $K_1=0$). The two $\mathbb Z/2$-charges of the program separate cleanly:
   reflection acts by $-1$ on $K_1$ of the core, Liouville acts by $+1$ on
   everything.

**Answer to the spearhead question: NO — and the no-go is a theorem one
level deeper than Theorem F.** Equilibrium states kill charge by uniqueness
(F); K-theory kills charge by homotopy-invariance plus connectedness of the
charge group. The pre-registered prediction of TOY_OBSTRUCTION §5
(annihilation, not obstruction; $\partial[\lambda\text{-twist}]=0$; no
torsion localizing at $p=2k-1$) is **confirmed and strengthened**: the class
does not merely die under $\partial$ — $\partial$ is faithful, and the twist
dies upstream, before any boundary map can act (§7).

---

## 1. The extension and the precise identification of the ideal $I$

$\mathcal T:=C^*_\lambda(\mathbb N\rtimes\mathbb N^\times)$, the Toeplitz
algebra of the affine (ax+b) semigroup over $\mathbb N$ (Laca–Raeburn,
Adv. Math. 225 (2010) 643–688): generated on
$\ell^2(P)$, $P=\mathbb N\rtimes\mathbb N^\times$, by the isometries
$T_{(b,a)}\xi_{(m,c)}=\xi_{(b+am,\,ac)}$. Universal presentation: isometries
$t=T_{(1,1)}$ (additive) and $t_p=T_{(0,p)}$ (multiplicative) with Nica
covariance. $\mathbb N\rtimes\mathbb N^\times$ is quasi-lattice ordered in
$\mathbb Q\rtimes\mathbb Q_{>0}^\times$ (Laca–Raeburn) and Nica-amenable, so
full $=$ reduced.

Cuntz's $Q_{\mathbb N}$ (arXiv math/0611541) is the quotient making $t$ a
unitary $u$ and imposing $\sum_{k=0}^{n-1}u^ke_nu^{-k}=1$. Equivalently
(Crisp–Laca boundary theory / Laca–Raeburn): $Q_{\mathbb N}$ is the boundary
quotient, and

$$I=\ker\pi=\big\langle\, d_p:=1-\textstyle\sum_{k=0}^{p-1}t^k(t_pt_p^*)t^{*k}\ \ (p\ \text{prime}),\ \ 1-tt^*\,\big\rangle .$$

**What $I$ is (Echterhoff–Laca, arXiv:1201.5632; their intro states the
method applies verbatim to $\mathcal T(\mathbb N\rtimes\mathbb N^\times)$).**
$\operatorname{Prim}\mathcal T\cong 2^{\mathcal P}$ ($\mathcal P$ = primes)
with the *power-cofinite topology*: basic opens
$U_G=\{T\subseteq\mathcal P: T\cap G=\emptyset\}$, $G$ finite (EL Lemma 3.2,
Theorem 3.6). Closed ideals of $\mathcal T$ $\leftrightarrow$ open subsets of
$2^{\mathcal P}$ (EL Remark 3.7). Consequences:

- **$I=I_{\mathcal P}$ is the unique maximal ideal** — the point
  $\mathcal P\in 2^{\mathcal P}$ is the unique closed point, and
  $\mathcal T/I_{\mathcal P}$ is the **only simple quotient**, the boundary
  algebra (EL Remark 3.9). $\operatorname{Prim} I=2^{\mathcal P}
  \setminus\{\mathcal P\}=\bigcup_p U_{\{p\}}$: the primitive spectrum of
  $I$ is the set of *proper* subsets of the primes.
- **No composition series bottom, and $I$ is very far from the compacts**:
  the lattice of opens of $2^{\mathcal P}$ has no minimal nonzero element
  (inside any nonempty open $U_G$ sits $U_{G\cup\{p\}}\subsetneq U_G$
  properly, nonempty), so $\mathcal T$ has **no minimal ideal**.

**Lemma 1.1.** $\mathcal T\cap\mathcal K(\ell^2 P)=0$: the Toeplitz algebra
of the affine semigroup contains no nonzero compact operator.

*Proof.* $J:=\mathcal T\cap\mathcal K$ is a closed ideal of $\mathcal T$. A
C\*-subalgebra of $\mathcal K(H)$ is a $c_0$-direct sum of elementary
algebras, so $\operatorname{Prim}J$ is discrete, in particular $T_1$. But
$\operatorname{Prim}J$ is an open subset of $2^{\mathcal P}$, and every
nonempty open contains a pair $\emptyset,\{q\}$ with
$\{q\}\in\overline{\{\emptyset\}}$ (Lemma 3.1 of EL: closure of the class of
$A$ is $\{B\supseteq A\}$), which is not $T_1$. So $J=0$. $\square$

So there is **no classical Fredholm index in this extension**: $\partial$
takes values in $K_0(I)$ for the large, infinitely-stratified ideal $I$, not
in $K_0(\mathcal K)=\mathbb Z$. (E.g. $1-tt^*\in I$ is the projection onto
$\{\xi_{(0,a)}\}\cong\ell^2(\mathbb N^\times)$ — infinite rank, consistent
with Lemma 1.1.) This settles the task's "identify $I$ precisely — it is NOT
plain compacts" in the sharpest form.

## 2. K-theory inputs (fetched from the sources)

**(A) $K_*(Q_{\mathbb N})$ — Cuntz, math/0611541, §5.** Quoting the
mechanism, which we reuse in §5: $Q_{\mathbb N}=F\rtimes\mathbb N^\times$
where $F=C^*(u,\{e_n\})$ is the Bunce–Deddens algebra of type
$\prod_p p^\infty$, with
$$K_0(F)=\mathbb Q,\qquad K_1(F)=\mathbb Z,$$
and $Q_{\mathbb N}=\varinjlim B_n$, $B_n=C^*(F,s_{p_1},\dots,s_{p_n})$.
Cuntz's Theorem 5.1: $K_0(B_n)\cong\mathbb Z^{2^{n-1}}\cong K_1(B_n)$, via
iterated Pimsner–Voiculescu with the two computed lemmas (his proof):
$\operatorname{Ad}s_2$ induces **multiplication by 2 on $K_0(F)=\mathbb Q$**
and **the identity on $K_1(F)=\mathbb Z$**; each later
$\operatorname{Ad}s_{p_i}$ induces the identity on the accumulated $K_0$ and
$K_1$ ("each consecutive prime doubles the number of generators"). Hence

$$K_0(Q_{\mathbb N})\cong\mathbb Z^{(\infty)},\qquad
K_1(Q_{\mathbb N})\cong\mathbb Z^{(\infty)}\quad\text{(countable-rank free abelian)} .$$

Confirmed independently by Barlak–Omland–Stammeier (arXiv:1512.04496, intro):
"If $S$ is the set of all primes, then $Q_S$ coincides with the algebra
$Q_{\mathbb N}$ from [Cun08] and it follows that $K_i(Q_S)=\mathbb Z^\infty$
for $i=0,1$ and $[1]=0$."

**$[1_{Q_{\mathbb N}}]=0$, hand proof:** $t_0:=s_2$, $t_1:=us_2$ satisfy
$t_0t_0^*+t_1t_1^*=e_2+ue_2u^{-1}=1$: a **unital copy of $\mathcal O_2$
inside $Q_{\mathbb N}$**, and $[1]=0$ in $K_0(\mathcal O_2)$.

Also needed below: $[u]\ne 0$ in $K_1(Q_{\mathbb N})$ — in Cuntz's tower the
generator of $K_1(F)=\mathbb Z$ (the odometer class) maps injectively at
every PV stage (it generates a $\operatorname{coker}(1-\mathrm{id})$ summand
each time), surviving into the limit.

**(B) $K_*(\mathcal T)$ — via Cuntz–Echterhoff–Li, arXiv:1201.4680.** Their
main theorem: for a countable left Ore semigroup $P$ with independent
constructible right ideals whose enveloping group $G$ satisfies Baum–Connes
with coefficients,
$K_*(C^*_\lambda(P))\cong\bigoplus_{[X]\in G\backslash\mathcal I}
K_*(C^*_r(G_X))$, $\mathcal I$ = the $G$-saturation of the nonempty
constructible right ideals in $\mathcal P(G)$, $G_X$ = stabilizers
(their Theorem 7.3 / Corollary 7.4; applied to ax+b-semigroups in §8.2).

Hypothesis check for $P=\mathbb N\rtimes\mathbb N^\times$,
$G=\mathbb Q\rtimes\mathbb Q_{>0}^\times$:
*left Ore*: cancellative, and $P(b,a)\cap P(d,c)\ni$ common left multiples by
the CRT-free computation $(x+cb,ca)=(x'+ad,ac)$, solvable in
$x,x'\in\mathbb N$ ✓. *Constructible right ideals*: principal right ideals
are $(b,a)P=(b+a\mathbb N)\times a\mathbb N^\times$; intersections of
translates are again of the form $X_{t,l}=(t+l\mathbb N)\times
l\mathbb N^\times$ (CRT in the additive part, lcm in the multiplicative
part), and left-inverse images preserve the form. *Independence*: if
$X_{t,l}=\bigcup_iX_{t_i,l_i}$ then, picking the element $(t,l)\in X_{t,l}$,
some $X_{t_i,l_i}\ni(t,l)$ forces $l_i\mid l$ and $l\mid l_i$, so $l_i=l$,
then $t_i=t$ ✓. *Baum–Connes*: $G$ is solvable, hence amenable, hence
satisfies BC with coefficients ✓.

*Orbit analysis*: $g\cdot X_{t,l}=(q+r\mathbb N)\times r\mathbb N^\times$
with $(q,r)=(c+\gamma t,\gamma l)$ for $g=(c,\gamma)$, and the set determines
$(q,r)$ (both coordinates are minima). So $G$ acts **simply transitively** on
$\mathcal I\setminus\{\emptyset\}$: one orbit, trivial stabilizer — this is
the point where $\mathbb N\rtimes\mathbb N^\times$ differs from
$R\rtimes R^\times$ (where the stabilizer of $I\times I^\times$ is
$I\rtimes R^*$, CEL §8.2): $t+l\mathbb N$ is not a group, so nothing
stabilizes. Hence

$$K_0(\mathcal T(\mathbb N\rtimes\mathbb N^\times))=\mathbb Z\cdot[1],\qquad
K_1(\mathcal T(\mathbb N\rtimes\mathbb N^\times))=0 ,$$

the generator being $[e_X]$ for the orbit representative $X=P$, i.e. $[1]$.
(Sanity check on the method: for $P=\mathbb N^\times$ it gives
$K_*(\bigotimes_p\mathcal T_p)=(\mathbb Z[1],0)$ ✓.) **The Toeplitz lift is a
K-theoretic point.**

## 3. The six-term sequence: $\partial$ is as nonzero as it can be

$$\begin{array}{ccccc}
K_0(I) & \to & \mathbb Z[1_{\mathcal T}] & \xrightarrow{\pi_*} & K_0(Q_{\mathbb N})=\mathbb Z^{(\infty)}\\
\uparrow\partial & & & & \downarrow\partial\\
K_1(Q_{\mathbb N})=\mathbb Z^{(\infty)} & \leftarrow & 0=K_1(\mathcal T) & \leftarrow & K_1(I)
\end{array}$$

$\pi_*[1_{\mathcal T}]=[1_{Q_{\mathbb N}}]=0$ (§2(A)), and $K_0(\mathcal T)$
is generated by $[1]$, so $\pi_*=0$ on $K_0$ (it is trivially $0$ on
$K_1$). Exactness then gives:

- $\partial:K_0(Q_{\mathbb N})\xrightarrow{\ \cong\ }K_1(I)\cong\mathbb Z^{(\infty)}$;
- $0\to K_1(Q_{\mathbb N})\xrightarrow{\partial}K_0(I)\to\mathbb Z\to 0$,
  split (free quotient), so $K_0(I)\cong\mathbb Z^{(\infty)}\oplus\mathbb Z
  \cong\mathbb Z^{(\infty)}$;
- **$\partial$ is injective on $K_1(Q_{\mathbb N})$.**

Interpretation: since $K_*(\mathcal T)=K_*(\mathbb C)$, the extension is a
K-theoretic *resolution* of $Q_{\mathbb N}$: the boundary map is faithful,
and the entire (huge) K-theory of the boundary quotient is realized as
boundary data in the ideal. Example of a genuinely nonzero boundary class:
$\partial[u]=-[1-tt^*]\ne 0$ in $K_0(I)$ — the **additive** (gauge-neutral)
direction carries a nonzero generalized index. So if the parity twist
defined any nonzero $K_1(Q_{\mathbb N})$-class, its boundary class would
automatically be nonzero. Everything therefore hinges on whether the twist
defines a class at all.

## 4. The parity twist defines no class: the annihilation theorem

### 4.1 No implementing unitary anywhere

**Lemma 4.1 ($\alpha_g$ is outer for every $g\ne 1$ in the gauge torus; in
particular $\alpha_\lambda$ is outer).** Suppose
$\alpha_g=\operatorname{Ad}w$, $w\in Q_{\mathbb N}$ unitary. Since
$\alpha_g$ fixes the canonical Cartan masa $C(\hat{\mathbb Z})\subset
Q_{\mathbb N}$ pointwise (it fixes $u$ and all $e_n$), $w$ commutes with
$C(\hat{\mathbb Z})$, hence $w\in C(\hat{\mathbb Z})$ (masa: the
Deaconu–Renault groupoid of $Q_{\mathbb N}$ is topologically principal —
points of $\hat{\mathbb Z}$ with trivial isotropy under
$x\mapsto ax+b$ are dense, cf. EL Lemma 3.4). Writing
$s_pfs_p^*=(f\circ m_p^{-1})e_p$ for $f\in C(\hat{\mathbb Z})$, the relation
$ws_pw^*=g(p)s_p$ forces $w(py)\overline{w(y)}=g(p)$ for all
$y\in\hat{\mathbb Z}$; at the fixed point $y=0$ this gives
$g(p)=|w(0)|^2=1$ for every $p$. $\square$

The same holds in $\mathcal T$: an inner lift would descend to an inner
$\alpha_\lambda$ on the quotient. At the spatial level the lift *is*
unitarily implemented: $W_\lambda\xi_{(m,a)}=\lambda(a)\xi_{(m,a)}$
satisfies $\operatorname{Ad}W_\lambda=\tilde\alpha_\lambda$ on
$\mathcal T$. But:

- $W_\lambda\notin\mathcal T=M(\mathcal T)$ ($\mathcal T$ is unital): a
  diagonal element of $\mathcal T$ lies in the Nica diagonal $C(\Omega)=
  \overline{\operatorname{span}}\{e_X\}$, and $\lambda$ oscillates on every
  constructible set ($\lambda(ln)$ takes both signs as $n$ varies), so
  $\operatorname{dist}(W_\lambda,C(\Omega))\ge 1$. This is GAUGE.md Lemma
  F.2 (boundary-invisibility of $\lambda$) reappearing at the Toeplitz
  level: **$\lambda$ does not extend to the Nica spectrum**, just as it does
  not extend to $\hat{\mathbb Z}$.
- $W_\lambda$ is not Fredholm-compatible with the extension:
  $[W_\lambda,T_{(0,p)}]=(\lambda(p)-1)T_{(0,p)}=-2T_{(0,p)}$ for odd-parity
  $p$, which lies in neither $I$ nor $\mathcal K$ (its image in
  $Q_{\mathbb N}$ is $-2s_p\ne0$). So there is no Fredholm module, no
  Toeplitz-type "symbol-unitary with compact defect", and — with Lemma 1.1 —
  no classical index anywhere in sight. This also disposes of the
  Exel/Ruelle candidate (task item (b)): the $\lambda$-weighted branch/
  transfer operators (e.g. $\sum_p\lambda(p)p^{-s}\,t_p$-type elements)
  are elements of $\mathcal T$ whose commutators with the algebra are
  *large* modulo $I$; the twist is a **charge, not an index**.

### 4.2 Homotopy annihilation (the mechanism)

The gauge torus $G=\mathbb T^{\mathcal P}$ acts point-norm continuously on
$Q_{\mathbb N}$, on $\mathcal T$, and on $I$ (the defining relations are
homogeneous; continuity on finite words, then density). The path
$g(\theta)=(e^{i\pi\theta},e^{i\pi\theta},\dots)$, $\theta\in[0,1]$, is a
continuous path of automorphisms from $\mathrm{id}$ to $\alpha_\lambda$
(the diagonal "$\Omega$-grading circle action" evaluated at $\pi$;
$g(1)(n)=e^{i\pi\Omega(n)}=\lambda(n)$). Hence:

**Theorem 4.2 (annihilation).** (i) $(\alpha_\lambda)_*=\mathrm{id}$ on
$K_*(Q_{\mathbb N})$, $K_*(\mathcal T)$, $K_*(I)$, and
$[\alpha_\lambda]=[\mathrm{id}]$ in $KK(Q_{\mathbb N},Q_{\mathbb N})$
(homotopy invariance).
(ii) The mapping torus $M_{\alpha_\lambda}$ is homotopy-equivalent to
$M_{\mathrm{id}}=Q_{\mathbb N}\otimes C(\mathbb T)$ in K-theory; all
Pimsner–Voiculescu invariants of $Q_{\mathbb N}\rtimes_{\alpha_\lambda}
\mathbb Z$ coincide with those of the trivial action.
(iii) The $\lambda$-twisted extension equals the untwisted one in
$\operatorname{Ext}(Q_{\mathbb N},I)\cong KK^1(Q_{\mathbb N},I)$: with
Busby invariant $\tau$, one has
$\tau\circ\alpha_\lambda=\sigma(\tilde\alpha_\lambda|_I)\circ\tau$ (the lift
$\tilde\alpha_\lambda$ preserves $I$ and conjugates the extension to
itself), and $(\tilde\alpha_\lambda|_I)_*=\mathrm{id}$ in $KK$ by (i); hence
$[\tau\circ\alpha_\lambda]=[\tau]$.
(iv) Consequently **every invariant of the pair (extension,
$\alpha_\lambda$) that is natural in $KK$ and homotopy-invariant in the
twist takes its value at the identity twist: the parity class is $0$ in
every receptacle.** $\square$

The vanishing is *not arithmetic*: the identical statement holds for every
element of $\mathbb T^{\mathcal P}$ — the whole charge group of Theorem F is
connected, and **K-theory cannot see individual points of a connected group
of symmetries**. Even the boundary-visible charges die: a real Dirichlet
character $\chi$ *does* define a unitary $u_\chi\in C(\hat{\mathbb Z})
\subset Q_{\mathbb N}$, but $K_1(C(\hat{\mathbb Z}))=0$ (total
disconnectedness), so $[u_\chi]=0$ as well. All multiplicative-character
data — visible or invisible to the profinite boundary — is K-trivial;
$K_1(Q_{\mathbb N})$ is generated by additive/mixed (gauge-neutral) classes
($[u]$ and its exterior products with prime directions, per Cuntz's tower).

### 4.3 Why this is one level deeper than Theorem F

Theorem F: the *unique KMS state* annihilates every charged sector
(uniqueness $\Rightarrow$ gauge invariance $\Rightarrow$ isotypic
vanishing). Here: the *K-functor* annihilates every charged twist
(homotopy invariance $\Rightarrow$ connected-group invariance). CORE_KMS
closed the state-theoretic escape routes; Theorem 4.2 closes the
index-theoretic ones. Both are instances of one schema (UNIFICATION §2):
the observable functor is a twirl — over the gauge group in F, over
homotopy in K — and $\lambda$ is in the twirl's kernel both times.

### 4.4 Control experiment: the reflection charge IS K-visible

Cuntz, math/0611541 §7: $Q_{\mathbb Z}=Q_{\mathbb N}\rtimes\mathbb Z/2$
(adjoining $s_{-1}$: $u\mapsto u^*$ — the program's reflection/J-symmetry,
E1). This $\mathbb Z/2$ is *not* on the connected gauge torus, acts by $-1$
on $K_1(F)=\mathbb Z$, and its crossed products have genuinely different
K-theory: the fixed-point core is the dihedral Bunce–Deddens algebra
$F'=F\rtimes\mathbb Z/2$ with $K_0(A'_n)=\mathbb Z^3$, $K_1(A'_n)=0$
(Cuntz Lemma 7.3) — versus $(K_0,K_1)=(\mathbb Q^2,\mathbb Z^2)$ for the
trivial-action comparison $F\oplus F$ — and the abstract of the paper
records the resulting "shift of parity from $K_0$ to $K_1$" in
$K_*(Q_{\mathbb Z})$. **The two $\mathbb Z/2$-symmetries of the pair-field
program separate in K-theory**: the archimedean sign sector (reflection,
which exchanges Goldbach and gap data, E1) is K-detected; the finite-place
parity charge (Liouville) is K-invisible. This is a precise operator
K-theoretic echo of E1's "their difference is archimedean only".

## 5. The residual invariant: order-2 crossed products (task candidate (a))

Connectedness does not kill the comparison
$Q_{\mathbb N}\rtimes_{\alpha_\lambda}\mathbb Z/2$ vs
$Q_{\mathbb N}\rtimes_{\mathrm{triv}}\mathbb Z/2$ (the deformation
$\alpha_{g(\theta)}$ passes through non-involutive automorphisms, breaking
$\mathbb Z/2$-equivariance). This is computed as follows.

### 5.1 Untwisting to the parity core

Work stably: $Q_{\mathbb N}\otimes\mathcal K\cong C_0(\mathbb A_f)\rtimes G$,
$G=\mathbb Q\rtimes\mathbb Q_{>0}^\times$ (Cuntz math/0611541, abstract and
§6; $Q_{\mathbb N}=1_{\hat{\mathbb Z}}$-full-corner). Under this
identification $\alpha_\lambda$ is the **dual-character action**
$\hat\alpha_\chi(U_g)=\chi(g)U_g$, $\chi(b,a)=\lambda(a)$ (a genuine
character of $G$; the corner intertwines the two, as $\hat\alpha_\chi$ fixes
$1_{\hat{\mathbb Z}}$).

**Proposition 5.1 (graded untwisting).** Let $A=B\rtimes G$ with its
$\chi$-grading $A=A_0\oplus A_1$, $A_0=B\rtimes\ker\chi$, and let
$v:=U_{(0,2)}\in M(A)$ (an odd unitary multiplier). Then
$$\varphi:\ A\rtimes_{\hat\alpha_\chi}\mathbb Z/2\ \xrightarrow{\ \cong\ }\ M_2(A_0),\qquad
a_0\mapsto\begin{pmatrix}a_0&0\\0&v^*a_0v\end{pmatrix},\quad
a_1\mapsto\begin{pmatrix}0&a_1v\\v^*a_1&0\end{pmatrix},\quad
w\mapsto\begin{pmatrix}1&0\\0&-1\end{pmatrix}.$$
*Proof.* Multiplicativity and $*$-compatibility are direct checks (all
verified: $a_0b_1$, $a_1b_1$, $wa_1w=-a_1$ cases); injectivity because the
four matrix entries recover the four components $a_0\pm b_0$, $a_1\pm b_1$
of $a_0+a_1+b_0w+b_1w$; surjectivity from $\varphi(a_0(1\pm w))/2$ and
$\varphi(a_1(1\pm w))/2$ using $A_1=vA_0$. $\square$

(Toy validation: $B=\mathbb C$, $G=\mathbb Z$, $\chi(n)=(-1)^n$, $v=z$:
$C(\mathbb T)\rtimes_{\pi\text{-rotation}}\mathbb Z/2\cong
M_2(C^*(2\mathbb Z))$ ✓, the classical free-action answer.)

**Warning recorded for successors (a trap we fell into and dismantled):**
the dual $\mathbb Z/2$-action on $A\rtimes_{\hat\alpha_\chi}\mathbb Z/2$ is
**not** inner: the would-be conjugating element
$\big(\begin{smallmatrix}0&v\\v^*&0\end{smallmatrix}\big)$ has *odd*
entries, hence lies outside $M(M_2(A_0))$. (In the toy model the two
candidate conclusions differ visibly: $C(\mathbb T)\otimes M_2$ vs
$M_2(C(\mathbb T))^{\oplus 2}$; Takai duality picks the first.) Any argument
using that innerness — e.g. to split the double crossed product — is wrong.

With $H_{\mathrm{even}}:=\ker(\lambda:\mathbb Q_{>0}^\times\to\pm1)$ (the
index-2 subgroup of even total valuation; free abelian with basis
$\{4\}\cup\{2p:p\ \text{odd prime}\}$):

**Corollary 5.2.** $Q_{\mathbb N}\rtimes_{\alpha_\lambda}\mathbb Z/2$ is
Morita equivalent to
$C_0(\mathbb A_f)\rtimes(\mathbb Q\rtimes H_{\mathrm{even}})$, and to the
parity core $Q^{\mathrm{even}}=Q_{\mathbb N}^{\alpha_\lambda}$ (full corner
by $\frac{1+w}{2}$; fullness from simplicity of the crossed product —
$\alpha_\lambda$ is outer by Lemma 4.1, $Q_{\mathbb N}$ simple, Kishimoto).
$\square$

So candidate (a) of the task is *literally the K-theory of the parity core*
— the object CORE_KMS §5 proved equilibrium-trivial. K-theory of the
neutral world vs. K-theory of the full algebra: the exact K-analog of the
CORE_KMS question.

### 5.2 The computation

Run Cuntz's §5 induction (§2(A) above) over $H_{\mathrm{even}}$ instead of
$\mathbb Q_{>0}^\times$, i.e. adjoin the isometries $s_4,s_{2p}$ to $F$. The
stage inputs are the same two lemmas, now for $r\in\{4,2p\}$:
$(\operatorname{Ad}s_r)_*=\times r$ on $K_0(F)=\mathbb Q$ (trace scaling:
$\mu(r\hat{\mathbb Z})=1/r$, and the trace is faithful on $K_0(F)$) and
$=\mathrm{id}$ on $K_1(F)=\mathbb Z$ (multiplicativity from Cuntz's prime
case: $(m_4)_*=(m_2)_*^2$, $(m_{2p})_*=(m_2)_*(m_p)_*$). First PV stage
(generator $4$): $1-\times4$ invertible on $\mathbb Q$, identity on
$\mathbb Z$, gives $(\mathbb Z,\mathbb Z)$; each later generator acts
trivially and doubles, *by the same stage-triviality that Cuntz asserts and
uses for his tower* ("in the following steps $\alpha_i$ induces 1 on $K_0$
and on $K_1$", proof of his Thm 5.1). Hence, modulo that inherited lemma
(flagged in §5.3):

$$K_*\!\big(Q_{\mathbb N}\rtimes_{\alpha_\lambda}\mathbb Z/2\big)
= K_*(Q^{\mathrm{even}})
\cong(\mathbb Z^{(\infty)},\ \mathbb Z^{(\infty)}),$$

which is **abstractly isomorphic** to
$K_*(Q_{\mathbb N}\rtimes_{\mathrm{triv}}\mathbb Z/2)
=K_*(Q_{\mathbb N})^{\oplus2}=(\mathbb Z^{(\infty)},\mathbb Z^{(\infty)})$.

**Parity is not detected by the K-groups of the order-2 crossed product.**
Both sides are countable-rank free abelian in both degrees; no torsion
appears anywhere in the towers (all cokernels free), in particular no
torsion class "localizing at $p=2k-1$" exists — indeed no $k$ exists: the
algebraic setup is $k$-independent (it knows the Liouville *character*, not
any $k$-point correlation problem), so the toy's falsifier (a rationally
invisible torsion class localized at $p^*=2k-1$) is structurally
unrealizable here. The finite-place annihilation $I_p=(p+1-2k)/(p+1)$ lives
in the *state/correlation* layer, not in the algebra's K-theory.

### 5.3 The isolated residue (the honest (iii)-part)

Two items remain open, precisely delimited:

1. **Stage-triviality for the $H_{\mathrm{even}}$-tower.** Cuntz's proof of
   his Theorem 5.1 asserts the analogous triviality for his tower without
   printed detail; the potential failure mode is a unipotent Bott-mixing
   term $N$ (extension of $\mathrm{id}$ by $\mathrm{id}$ need not be
   $\mathrm{id}$), which for the *full* tower is excluded by his stated
   result (and independently by Barlak–Omland–Stammeier's free-rank
   $2^{|S|-1}$ count and the torsion-freeness of the final answer, which a
   nonzero $N$ or a sign on $K_1(F)$ would violate). The identical
   verification for the basis $\{4,2p\}$ is a finite check with the same
   mechanism; nothing suggests a difference.
2. **The equivariant refinement.** The comparison as
   $R(\mathbb Z/2)$-modules ($K^{\mathbb Z/2}_*$ via Green–Julg, i.e. the
   dual-action module structure on the two crossed products) is *not*
   computed here — see the §5.1 warning: the dual action is not inner, and
   its $K_*$-action on $K_*(C_0(\mathbb A_f)\rtimes(\mathbb Q\rtimes
   H_{\mathrm{even}}))$ (it is the automorphism $m_2$) is exactly the datum
   the module structure needs. The modern machinery of arXiv:2407.01952
   (groupoid homology spectral sequences for algebraic actions; it
   re-derives Cuntz–Li and resolves the BOS conjecture) computes such
   things; this is the one well-posed computation that could still refine
   the answer. Note however the *shape* of any refinement is constrained in
   advance: whatever it detects, it detects **uniformly in the charge**
   (the computation never used which character of $\mathbb T^{\mathcal P}$
   of order 2 was taken, only that it is one — e.g. a real-Dirichlet-pattern
   twist gives the same structure), so it cannot separate the
   boundary-invisible parity charge from boundary-visible charges: it would
   measure "twistedness", not arithmetic parity.

## 6. The functorial question (UNIFICATION §3, Machine 2; coordinator's (a)–(c))

**(a) The functor that would be needed.** On triples $(A,\ G\curvearrowright
A,\ \chi\in\widehat G)$ — algebra with compact charge-group action and a
distinguished charge — with morphisms the equivariant maps of canonical
Toeplitz-type resolutions $0\to I_A\to T_A\to A\to0$, one would need
$\mathcal F(A,G,\chi)=$ (boundary/obstruction class of the $\chi$-twist) in
$K_0(I_A)$ (or $\operatorname{Ext}(A,I_A)$), natural in the triple.

**(b) Functoriality across the two computable instances.** It holds — in
the only way it can: **$\mathcal F$ is the zero functor in the twist
variable**, in both instances, for matching reasons:

| | toy presheaf (TOY_OBSTRUCTION) | affine Toeplitz (here) |
|---|---|---|
| receptacle | Čech $H^{\ge1}$, $\varprojlim^1$ | $K_0(I)$, $\operatorname{Ext}(Q,I)$, $KK^{\mathbb Z/2}$ |
| receptacle status | structurally zero (cofinal clopen partitions) | huge and faithfully fed by $\partial$ (§3) |
| why the class dies | zero bonding map at $p^*$: annihilated before gluing | no unitary + connectedness: annihilated before $\partial$ |
| what survives | completion artifact, charge-blind | crossed-product data, charge-blind (§5.3.2) |

The two mechanisms are one fact in two categories: $\lambda$ is an
*infinitely supported* charge — a point of
$\prod_p\mathbb Z/2\setminus\bigoplus_p\mathbb Z/2$ (toy), equivalently of
the connected completion $\mathbb T^{\mathcal P}$ with no disconnected
finite-level shadow (here) — and both invariants only see finite/
disconnected data. The assignment (charge killed by quotient) $\mapsto$
(boundary class) is functorial *and identically zero* on the program's
table.

**(c) The deflation, stated as a theorem.** *K-theory of the affine
Toeplitz extension sees the extension's topology — completely
($\partial$ faithful, $\mathcal T$ a K-point, $\operatorname{Prim}$ the full
power-set topology) — and sees no analytic parity information: all
charge-twist invariants vanish by Theorem 4.2, and the surviving order-2
crossed product has the K-theory of the untwisted one.* Decided before the
program builds on it, as the strategic review demanded.

## 7. Reconciliation with the pre-registered prediction (TOY_OBSTRUCTION §5)

Prediction: $\partial[\lambda\text{-twist}]=0$; any nonzero contribution a
Milnor-$\varprojlim^1$/completion term, not localized at $p=2k-1$;
falsifier: rationally-invisible torsion localizing at $p^*$.

Findings: **confirmed, and strengthened in one direction the toy could not
see.** (1) $\partial[\lambda]$ is zero in the strongest sense — there is no
$K_1(Q_{\mathbb N})$-element for $\partial$ to act on (no unitary exists:
Lemma 4.1, §4.1), and every constructed invariant vanishes (Theorem 4.2);
meanwhile $\partial$ itself is *injective* (§3), so the death is entirely
upstream — precisely the toy's "annihilated by an exact local projector
before any index can be charged", with "local projector" here read as
"connected-group twirl". (2) No torsion and no $\varprojlim^1$ terms arose
at all (all limits had injective connecting maps, all groups free); the
falsifier is not triggered, and §5.2 shows it is structurally untriggerable
($k$-independence). (3) The strengthening: the toy could not see the
*positive* side — that the extension's boundary map is faithful and the
reflection charge IS detected (§4.4). K-theory is not weak; it is
charge-blind. The productive continuation is therefore exactly the toy's
conclusion: not obstruction theory over the neutral world, but the
minimal-enlargement question — and §4.4 adds a concrete hint that the
archimedean/reflection direction is where K-visible structure lives.

**What any future "parity index" must evade (checklist for successors):**
it must not be a homotopy-invariant functor of the twist (Theorem 4.2), not
a KMS/state functional (Theorem F, CORE_KMS), not a bare K-group of the
order-2 crossed product (§5.2). Candidates outside all three fences:
non-homotopy-invariant secondary invariants on the Bunce–Deddens core (de la
Harpe–Skandalis determinant / rotation-number pairings against the unique
trace $\tau_0$ of CORE_KMS), cyclic cocycles of unbounded degree, or the
equivariant module refinement of §5.3.2 (though pre-constrained to be
charge-blind). 

## 8. Sources (all fetched and read this session) and verification ledger

- J. Cuntz, *C\*-algebras associated with the ax+b-semigroup over* $\mathbb N$,
  arXiv:math/0611541 (K-theory: Thm 5.1 and its proof; KMS: Thm 4.3;
  $Q_{\mathbb Z}$, dihedral BD core, Lemma 7.3; stabilization
  $\cong C_0(\mathbb A_f)\rtimes P^+_{\mathbb Q}$).
- S. Barlak, T. Omland, N. Stammeier, *On the K-theory of C\*-algebras
  arising from integral dynamics*, arXiv:1512.04496 (explicit statement
  $K_i(Q_{\mathbb N})=\mathbb Z^\infty$, $[1]=0$; free-rank $2^{|S|-1}$;
  torsion by $\gcd(p-1)$ for finite $S$).
- J. Cuntz, S. Echterhoff, X. Li, *On the K-theory of the C\*-algebra
  generated by the left regular representation of an Ore semigroup*,
  arXiv:1201.4680 (main theorem §7.3/7.4; ax+b-semigroups §8.2; our
  Toeplitz computation §2(B) applies it to
  $\mathbb N\rtimes\mathbb N^\times$).
- S. Echterhoff, M. Laca, *The primitive ideal space of the C\*-algebra of
  the affine semigroup of algebraic integers*, arXiv:1201.5632
  ($\operatorname{Prim}\cong2^{\mathcal P}$ power-cofinite, Thm 3.6; unique
  maximal ideal & simple boundary quotient, Rmk 3.9; essential freeness,
  Lem 3.4; applicability to $\mathcal T(\mathbb N\rtimes\mathbb N^\times)$
  stated in their introduction).
- M. Laca, I. Raeburn, *Phase transition on the Toeplitz algebra of the
  affine semigroup over the natural numbers*, Adv. Math. 225 (2010) 643–688
  (presentation of $\mathcal T$, quasi-lattice order, KMS simplex).
- arXiv:2407.01952 (groupoid homology & K-theory for algebraic actions;
  recovers Cuntz–Li/Li–Lück; tool for §5.3.2).

New proofs contained here (V1): Lemma 1.1 ($\mathcal T\cap\mathcal K=0$);
§2(B) orbit analysis (simply transitive saturation, $K_*(\mathcal T)=
(\mathbb Z,0)$); §3 six-term consequences; Lemma 4.1 (outerness via Cartan
masa and the fixed point $0\in\hat{\mathbb Z}$); Theorem 4.2; Prop 5.1 and
Cor 5.2 (untwisting to the parity core; validated on the $C(\mathbb T)$
toy); §5.2 modulo the flagged stage lemma. Known-input dependencies and the
two open residues are exactly as flagged in §5.3.

Cross-references: GAUGE.md (F.1, F.2, Theorem F), CORE_KMS.md (Theorems 1–4,
parity core), FAREY_TRANSFER.md §3 (the question), UNIFICATION.md §§2–3,
TOY_OBSTRUCTION.md §5 (interface reconciled in §7), HANDOFF_EXTERNAL §3.

— fleet-kboundary, 2026-08-11.
