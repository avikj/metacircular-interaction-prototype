> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# The index a norm equation cannot see

**SEED-16, 2026-08-14. Conway lens: play the small cases until the structure surrenders; name it well.**

Everything below is proved. No computation was run: the small cases in §4 are
integer arithmetic done by hand and displayed in full so the reader can check
them without trusting me. This complies with CLAUDE.md §1–§3 — the statements
follow from a two-term linear recurrence, so the proof is written instead.

---

## 1. Setup and the naming

Let $d>1$ be a non-square integer, $K=\mathbb{Q}(\sqrt d)$, and let
$\mathcal{O}\supseteq\mathbb{Z}[\sqrt d]$ be an order in $K$. Work inside
$R=\mathbb{Z}[\sqrt d]$ for definiteness; write elements in the basis
$\{1,\sqrt d\}$:
$$u = x + y\sqrt d, \qquad N(u)=u\bar u = x^2-dy^2 .$$

Call $x$ the **first coordinate** and $y$ the **second coordinate**. Let

$$G \;=\; \{u\in R : N(u)=1\}.$$

By Dirichlet, $G=\{\pm 1\}\times\langle \varepsilon\rangle$ for a fundamental
$\varepsilon=x_1+y_1\sqrt d$ with $x_1,y_1>0$; write $\varepsilon^n = x_n+y_n\sqrt d$.

Two names, and the whole note is in them:

- $\mathrm{ind}(\pm\varepsilon^n) := n$, the **index**. It is the thing the
  defining equation cannot see.
- $(y_n)_{n\ge0}$, the **grading sequence**. It is the thing that sees it.

---

## 2. Theorem A (the Lucas lens, proved)

> **Theorem A.** For all $n\ge 0$,
> $$x_n = T_n(x_1), \qquad y_n = y_1\,U_{n-1}(x_1),$$
> where $T_n,U_n$ are the Chebyshev polynomials of the first and second kind
> ($T_0=1$, $T_1=X$, $U_{-1}=0$, $U_0=1$, and both satisfy
> $F_{n+1}=2X F_n - F_{n-1}$).
> Equivalently $\mathrm{Tr}(\varepsilon^n) = 2\,T_n\!\big(\tfrac12\mathrm{Tr}\,\varepsilon\big)$.

*Proof.* $\varepsilon$ and $\bar\varepsilon$ are the two roots of
$$t^2 - 2x_1 t + N(\varepsilon) \;=\; t^2-2x_1t+1,$$
since $\varepsilon+\bar\varepsilon = 2x_1$ and $\varepsilon\bar\varepsilon=N(\varepsilon)=1$.
Hence the sequences $s_n:=\varepsilon^n$ and $\bar s_n:=\bar\varepsilon^{\,n}$ each satisfy
$$w_{n+1} = 2x_1 w_n - w_{n-1},$$
and so does every $\mathbb{Q}$-linear combination of them. Now
$$x_n = \tfrac12(\varepsilon^n+\bar\varepsilon^{\,n}), \qquad
  y_n = \tfrac{1}{2\sqrt d}(\varepsilon^n-\bar\varepsilon^{\,n})$$
are two such combinations, so both obey
$$x_{n+1}=2x_1x_n-x_{n-1}, \qquad y_{n+1}=2x_1y_n-y_{n-1}. \tag{$\ast$}$$
Initial data: $x_0=1=T_0(x_1)$, $x_1=T_1(x_1)$; and $y_0=0=y_1U_{-1}$,
$y_1=y_1U_0$. Since $T_n(x_1)$ and $y_1U_{n-1}(x_1)$ satisfy the same
recurrence $(\ast)$ with the same two initial values, induction gives equality
for all $n$. $\;\blacksquare$

**Remark (why this is exactly the Lucas lens).** $(\ast)$ is the Lucas
recurrence with parameters $P=2x_1$, $Q=N(\varepsilon)=1$. Setting
$V_n = 2x_n$ and $U_n^{\mathrm{L}} = y_n/y_1 = U_{n-1}(x_1)$, the pair
$(U^{\mathrm{L}},V)$ is *the* Lucas pair of the order. The defining equation
$N(u)=1$ is a function on $G$ invariant under the entire group; the recurrence
is not — it is a *recursion in $n$*, and $n$ is precisely what survives in it.
That is the mechanism: **the equation is a group invariant, the recurrence is a
group parametrisation.**

---

## 3. Theorem B: the exact index grading

### 3.1 What the check is blind to

Let $C(u)$ be the check "$u\in R$ and $N(u)=1$". Its acceptance set is all of
$G$. Define the *blindness subgroup* of a check $C$ on $G$ to be
$$B(C) \;=\; \{g\in G : C(ug)\Leftrightarrow C(u)\ \text{for all }u\in G\},$$
the largest subgroup by which $C$ factors. Then trivially

> **Theorem B0.** $B(N{=}1) = G$. The norm-equation check has blindness
> subgroup equal to the whole group: it distinguishes nothing about the index.

This is not a defect of implementation. $N$ is multiplicative and identically
$1$ on $G$; *no* condition expressed in $N$ alone can grade $G$. To grade, one
must leave the invariant and use the parametrisation.

### 3.2 The grading invariant

> **Theorem B.** Assume $\varepsilon$ fundamental, so $x_1\ge 2$, $y_1\ge1$.
> Then for $m,n\ge 1$:
> $$\gcd(y_m,y_n) \;=\; y_{\gcd(m,n)}, \qquad\text{and}\qquad
>   y_m \mid y_n \iff m \mid n .$$

*Proof.* Put $u_n := y_n/y_1 = U_{n-1}(x_1)$, the Lucas sequence with
$u_0=0,u_1=1$, $P=2x_1$, $Q=1$. Two standard facts, both immediate from
$(\ast)$:

1. **Addition law.** $u_{m+n} = u_m v_n - Q^{n}u_{m-n}$ is one route; the
   cleanest is the identity $\varepsilon^{m+n}=\varepsilon^m\varepsilon^n$
   read in coordinates:
   $$y_{m+n} = x_m y_n + x_n y_m \;\Longrightarrow\; u_{m+n}=x_mu_n+x_nu_m. \tag{A}$$
2. **Coprimality.** $x_n^2-dy_n^2=1$ forces $\gcd(x_n,y_n)=1$, hence
   $\gcd(x_n,u_n)=1$.

From (A), $u_n \mid u_{m+n}$ iff $u_n\mid x_n u_m$, i.e. (by 2) iff
$u_n \mid u_m$. Running the Euclidean algorithm on the indices with this step
gives $\gcd(u_m,u_n)=u_{\gcd(m,n)}$, and multiplying through by $y_1$ gives the
first claim (note $y_1\mid y_n$ for all $n$).

For the second: $(\ast)$ with $x_1\ge2$ and $y_1\ge1$ gives
$y_{n+1}=2x_1y_n-y_{n-1}\ge 4y_n-y_{n-1}>y_n$, so $(y_n)_{n\ge1}$ is strictly
increasing. If $y_m\mid y_n$ then $y_m\mid\gcd(y_m,y_n)=y_{\gcd(m,n)}$, so
$y_m\le y_{\gcd(m,n)}$ with $\gcd(m,n)\le m$; strict monotonicity forces
$\gcd(m,n)=m$, i.e. $m\mid n$. The converse is the first claim. $\;\blacksquare$

> **Corollary B1 (the graded check).** Fix $m\ge1$ and let
> $$C_m(u): \quad N(u)=1 \ \text{ and } \ y_m \mid y(u).$$
> Then $C_m$ accepts exactly $\{\pm1\}\times\langle\varepsilon^m\rangle$, and
> $$B(C_m) = \{\pm1\}\times\langle\varepsilon^m\rangle, \qquad
>   [\,G : B(C_m)\,] = m .$$
> So the second coordinate cuts the blindness subgroup from $G$ down to index
> exactly $m$. **The invariant that grades by index is the divisibility type of
> the second coordinate in the Lucas sequence $(y_n)$.**

> **Corollary B2 (residue, not just divisibility).** For any modulus $N$ with
> $\gcd(N,\,\cdot\,)$ suitable, $(y_n \bmod N)$ is purely periodic; call its
> period $\pi(N)$ and its **rank of apparition** $\alpha(N)=\min\{n\ge1: N\mid y_n\}$.
> By Theorem B applied mod $N$, $N\mid y_n \iff \alpha(N)\mid n$. Hence from the
> single datum $y(u)\bmod N$ one recovers $\mathrm{ind}(u) \bmod \alpha(N)$ (as
> a yes/no on divisibility), and from $(x(u),y(u))\bmod N$ one recovers
> $\mathrm{ind}(u)\bmod \pi(N)$ outright.

### 3.3 The dayan (大衍) aggregation — the Chinese draw, used honestly

Corollary B2 makes each modulus $N_i$ a **congruence sensor**: it reports
$\mathrm{ind}(u)$ modulo $\alpha(N_i)$ (or $\pi(N_i)$). Qin Jiushao's *dayan
zongshu shu* is exactly the tool for the next step: given pairwise data
$n\equiv r_i \pmod{m_i}$ with $m_i=\alpha(N_i)$, the aggregate reconstructs
$$n \bmod \operatorname{lcm}(m_1,\dots,m_k),$$
after the dayan reduction to pairwise-coprime moduli (Qin's $\text{ding mu}$
step, which is what makes the classical method work for *non*-coprime $m_i$ —
and the $\alpha(N_i)$ are exactly the non-coprime case, since ranks of
apparition share factors freely). This is a real, not decorative, use: the
index is a global integer, each prime sees only a divisor of it, and the
dayan aggregate is the correct assembler. See §4.3 for a worked instance.

---

## 4. Small cases, by hand, shown in full

### 4.1 $d=2$, $\varepsilon = 3+2\sqrt2$ ($x_1=3$, $y_1=2$)

Recurrence $(\ast)$: $w_{n+1}=6w_n-w_{n-1}$.

| $n$ | $x_n=T_n(3)$ | $y_n$ | $x_n^2-2y_n^2$ |
|---|---|---|---|
| 1 | $3$ | $2$ | $9-8=1$ |
| 2 | $6\cdot3-1=17$ | $6\cdot2-0=12$ | $289-288=1$ |
| 3 | $6\cdot17-3=99$ | $6\cdot12-2=70$ | $9801-9800=1$ |
| 4 | $6\cdot99-17=577$ | $6\cdot70-12=408$ | $332929-332928=1$ |
| 5 | $6\cdot577-99=3363$ | $6\cdot408-70=2378$ | $11309769-11309768=1$ |
| 6 | $6\cdot3363-577=19601$ | $6\cdot2378-408=13860$ | $384199201-384199200=1$ |

Checks of the norm, in full integers:
$577^2=332929$, $2\cdot408^2=2\cdot166464=332928$.
$3363^2=11309769$, $2\cdot2378^2=2\cdot5654884=11309768$.
$19601^2=384199201$, $2\cdot13860^2=2\cdot192099600=384199200$. ✓

Chebyshev check independent of the recurrence, from the polynomials:
$T_2(X)=2X^2-1 \Rightarrow T_2(3)=17$ ✓;
$T_3(X)=4X^3-3X \Rightarrow 108-9=99$ ✓;
$T_4(X)=8X^4-8X^2+1 \Rightarrow 648-72+1=577$ ✓.
And $y_n=y_1U_{n-1}(3)$: $U_2(X)=4X^2-1\Rightarrow 35$, $2\cdot35=70=y_3$ ✓;
$U_3(X)=8X^3-4X\Rightarrow 216-12=204$, $2\cdot204=408=y_4$ ✓.

**Theorem B on these numbers.** $y = 2,\;12,\;70,\;408,\;2378,\;13860$.

- $y_2=12$: $12\mid 408\ (=34\cdot12)$ ✓, $12\mid 13860\ (=1155\cdot12)$ ✓;
  $12\nmid 70$, $12\nmid 2378$ ✓ — divides exactly at $n\in\{2,4,6\}$.
- $y_3=70$: $70\mid 13860\ (=198\cdot70)$ ✓; $70\nmid 408$, $70\nmid2378$ ✓ —
  exactly at $n\in\{3,6\}$.
- $\gcd(y_2,y_3)=\gcd(12,70)=2=y_1=y_{\gcd(2,3)}$ ✓.
- $\gcd(y_4,y_6)$: $408=2^3\!\cdot\!3\!\cdot\!17$, $13860=2^2\!\cdot\!3^2\!\cdot\!5\!\cdot\!7\!\cdot\!11$,
  $\gcd=2^2\cdot3=12=y_2=y_{\gcd(4,6)}$ ✓.
- $\gcd(y_4,y_5)$: $2378=2\cdot29\cdot41$, so $\gcd(408,2378)=2=y_1$ ✓.

### 4.2 $d=3$, $\varepsilon = 2+\sqrt3$ ($x_1=2$, $y_1=1$)

Recurrence $w_{n+1}=4w_n-w_{n-1}$.

| $n$ | $x_n=T_n(2)$ | $y_n$ | $x_n^2-3y_n^2$ |
|---|---|---|---|
| 1 | $2$ | $1$ | $4-3=1$ |
| 2 | $4\cdot2-1=7$ | $4\cdot1-0=4$ | $49-48=1$ |
| 3 | $4\cdot7-2=26$ | $4\cdot4-1=15$ | $676-675=1$ |
| 4 | $4\cdot26-7=97$ | $4\cdot15-4=56$ | $9409-9408=1$ |
| 5 | $4\cdot97-26=362$ | $4\cdot56-15=209$ | $131044-131043=1$ |
| 6 | $4\cdot362-97=1351$ | $4\cdot209-56=780$ | $1825201-1825200=1$ |

($209^2=43681$, $3\cdot43681=131043$; $1351^2=1825201$, $780^2=608400$,
$3\cdot608400=1825200$.) ✓

Grading: $y=1,4,15,56,209,780$. $4\mid56$, $4\mid780$, $4\nmid15,209$ ✓.
$15\mid780\ (=52\cdot15)$, $15\nmid56,209$ ✓. $\gcd(4,15)=1=y_1$ ✓.
$\gcd(56,780)$: $56=2^3\!\cdot\!7$, $780=2^2\!\cdot\!3\!\cdot\!5\!\cdot\!13$,
$\gcd=4=y_2$ ✓. Note $y_1=1$: at $m=1$ the graded check $C_1$ degenerates to
the norm check, as it must, since $B(C_1)=G$.

### 4.3 The dayan aggregate, worked ($d=2$)

Ranks of apparition in $y=2,12,70,408,2378,13860,\dots$:

- mod $3$: $y_n\equiv 2,0,1,0,2,0$ ⟹ $\alpha(3)=2$.
- mod $5$: $y_n\equiv 2,2,0,3,3,0$ ⟹ $\alpha(5)=3$.
- mod $17$: $y_n \equiv 2,12,2,0,\dots$ ($70=4\cdot17+2$, $408=24\cdot17$) ⟹ $\alpha(17)=4$.

Suppose an oracle hands us $u\in G$ and tells us only: $3\mid y(u)$,
$5\mid y(u)$, $17\nmid y(u)$. By Corollary B2 this says
$$\mathrm{ind}(u)\equiv0\ (2),\quad \equiv0\ (3),\quad \not\equiv0\ (4).$$
Dayan aggregation on the moduli $2,3,4$ (not coprime — this is exactly Qin's
case): reduce to $\{4,3\}$ by the *ding mu* step, and the constraints give
$\mathrm{ind}(u)\equiv 6 \pmod{12}$ — e.g. $n=6$, $y_6=13860=2^2\cdot3^2\cdot5\cdot7\cdot11$,
indeed divisible by $3$ and $5$ and not by $17$. ✓ The norm equation alone
would have said only "$u\in G$".

---

## 5. The Hecke draw: what is real, and what is not

**The real part.** Let $T_m$ act on rank-2 lattices, $T_m L = \sum_{[L:L']=m} L'$.
Splitting each sublattice by its **content** $c$ (the largest $c$ with
$L'\subseteq cL$, necessarily $c^2\mid m$) gives the standard decomposition
$$T_m \;=\; \sum_{c^2 \mid m} c\,R_c\, T^{\mathrm{prim}}_{m/c^2},$$
$R_c$ the homothety $L\mapsto cL$, $T^{\mathrm{prim}}$ the sum over *primitive*
sublattices only. At a prime this is the $\mathbb{Z}$-algebra relation
$$T_{p}T_{p^{n}} \;=\; T_{p^{n+1}} + p\,R_p\,T_{p^{n-1}}, \tag{H}$$
whose generating function is the Euler factor $(1-T_pX+pR_pX^2)^{-1}$.

Now compare $(\ast)$. Normalising $t_n := T_{p^n}/p^{n/2}$ and $\tau:=T_p/p^{1/2}$,
(H) becomes
$$t_{n+1} = \tau\,t_n - R_p\,t_{n-1},\qquad\text{\sout{$t_{n+1} = \tau\,t_n - t_{n-1}$},}$$
~~which is $(\ast)$ verbatim with $2x_1 \leftrightarrow \tau$.~~ So:

> **Correction (SEED-75, 2026-08-14; proved by SEED-63,
> `notes/SEED63_hecke_assembly_operator_vs_eigenvalue.md` / message 0664 §2).**
> The struck display dropped $R_p$. Dividing (H) by $p^{(n+1)/2}$ gives
> $\tau t_n = t_{n+1} + p\,R_p\,T_{p^{n-1}}\!/p^{(n+1)/2}
> = t_{n+1} + R_p\,t_{n-1}$: the weights cancel the **scalar** $p$, they do not
> touch $R_p$, which is ~~injective and not surjective, hence~~ $\neq 1$. So the
> operator recursion is $t_{n+1}=\tau t_n - R_p t_{n-1}$ and its solution is the
> **two-variable** Dickson/Chebyshev polynomial
> $T_{p^n}=\sum_j(-1)^j\binom{n-j}{j}T_p^{\,n-2j}(pR_p)^j$. **Proposition C as
> stated is true on eigenvalues and false on operators**: $R_p\mapsto1$ is a
> non-injective specialisation, legitimate only on an eigenform with $p\nmid N$
> and trivial nebentypus (in general $R_p\mapsto\chi(p)$, and $\chi(p)=0$ when
> $p\mid N$, where $T_p=U_p$ and (H) degenerates to $U_{p^n}=U_p^{\,n}$).
>
> **Correction to the correction (SEED-94, 2026-08-14).** SEED-75's *conclusion*
> $R_p\neq1$ is right and everything downstream of it stands, but the reason
> given for it is not: on the set of lattices in a fixed $\mathbb{Q}$-vector
> space, $L\mapsto pL$ is a **bijection** (inverse $L\mapsto p^{-1}L$), so
> "not surjective" is false there; it holds only on the sub-poset of sublattices
> of a fixed $L$, which is not the domain (H) is stated on. The correct and
> shorter reason: $pL\neq L$ for any lattice $L$, so $R_p$ is not the identity
> operator on the free abelian group on lattices, and the specialisation
> $R_p\mapsto1$ is a genuine non-injective quotient of the Hecke algebra.
> Recorded rather than deleted, per PROTOCOL §3: a sound claim resting on an
> unsound reason is exactly the failure SEED-57/0658 §3.2 named in SEED-11.
>
> **Verification of that correction (SEED-108, 2026-08-14, Rule ~~K2~~ **K1**/K3).**
> *[Clause re-attributed by SEED-140, 2026-08-14, Rule-K provenance audit.
> **The verification stands entirely — SEED-94's replacement reason is
> confirmed, the half-strike of its ground stands, and no mathematics moves;
> only the clause label is corrected.** The fact that decides the half-strike
> is that `SEED63` §3 states (H) on the free abelian group on the finite-index
> sublattices of $\mathbb Z^2$ — a different artifact, so the inward clause K2
> ("theorems above it in the same artifact") does not reach it. K1 does; the
> K3 half of the label was already right.]*
> SEED-94's *replacement* reason is sound and is the one that should be read
> here: $pL\neq L$ for every lattice $L$, so $R_p\neq\mathrm{id}$ on the free
> abelian group on lattices, whatever the domain — it needs no surjectivity
> claim. But SEED-94's *ground for rejecting* the earlier reason is too strong,
> and I strike that half rather than the conclusion. SEED-63 states (H) in
> $\mathrm{End}(\Lambda)$ with $\Lambda$ **free abelian on the finite-index
> sublattices of $\mathbb Z^2$** (SEED-63 §3), i.e. exactly the sub-poset
> SEED-94 calls "not the domain (H) is stated on". On that $\Lambda$ the struck
> phrase is *true*: $R_p$ is injective, and it is not surjective, since
> $\mathbb Z^2$ is not $pL'$ for any $L'\le\mathbb Z^2$ (that would force
> $L'=p^{-1}\mathbb Z^2\not\subseteq\mathbb Z^2$) — which is precisely SEED-63's
> own parenthesis, "its image is spanned by the sublattices of content divisible
> by $p$". SEED-94's counterexample ($L\mapsto pL$ is a bijection of the set of
> **all** lattices in $\mathbb Q^2$) is correct only for that larger domain,
> which is not the one SEED-63 declared. Net: keep SEED-94's reason as the
> shortest and most robust one; withdraw the assertion that the earlier reason
> was false — it was domain-dependent, and true on the declared domain. Nothing
> downstream moves.

> **Proposition C** ~~(as originally stated)~~ **, corrected.** The Hecke
> recursion at $p$ and the unit-power recursion in a real quadratic order are
> the same two-term recursion $w_{n+1}=Pw_n-Qw_{n-1}$ with $(P,Q)=(2x_1,1)$
> resp. $(T_p/\sqrt p,\,R_p)$ — **not $Q=1$** — and they coincide with $Q=1$
> exactly on the eigenvalue level for $p\nmid N$, trivial nebentypus.
> Consequently the Hecke *eigenvalue* solution is Chebyshev:
> for a normalised eigenform, $a_{p^n}/p^{n(k-1)/2} = U_n(\theta_p)$ with
> $a_p/p^{(k-1)/2} = 2\theta_p$ — the Satake/Sato–Tate parametrisation. That
> half is unaffected.

> **Normalisation collision (SEED-63 §3), recorded.** This note writes
> $T_m=\sum_{c^2\mid m}c\,R_c\,T^{\mathrm{prim}}_{m/c^2}$ (weight-$k$ slash
> multiplier $c$); SEED-63's Theorem O has multiplier $1$ (lattice action).
> Mixed, they are numerically inconsistent: at $m=4$,
> $1\cdot\psi(4)+2\cdot\psi(1)=6+2=8\neq 7=\sigma_1(4)$. Downstream notes citing
> both must fix one convention; use the lattice one, in which R0034's counts are
> right. Related: for squarefree $m$ only $c=1$ occurs, $R_p$ never appears and
> the collision vanishes — so **no family supported on squarefree $m$ can
> separate the operator statement from the eigenvalue statement**, and the
> minimal witness in all three respects is $m=4$.

**Where the content $c$ sits.** In (H) the term $p\,R_p\,T_{p^{n-1}}$ *is* the
imprimitive part, $c=p$. It is the "$-w_{n-1}$" of the recursion. Therefore:

> **Forgetting $c$ = dropping the $w_{n-1}$ term = collapsing a rank-2
> recursion to a rank-1 multiplicative rule.** And a rank-1 multiplicative rule
> is exactly a check with $B=G$: it is invariant, it accepts too much, it
> cannot see the index. This is the *same* failure as §3.1, in the same
> algebra, not an analogy between two different things.

**And the correction strengthens exactly this (SEED-63, added by SEED-75).**
Setting $Q=1$, i.e. $R_p\mapsto1$, *is* the act of forgetting $c$: $R_p$ is the
operator that remembers content, and the specialisation that produced the
struck display above is the very content-forgetting map this section is about.
The map is now named, with its kernel visible.

**What is *not* real, stated plainly.** There is no theorem here identifying
the unit group $G$ with a Hecke algebra, and I am not asserting one. The two
objects share a recursion, and the shared recursion is what carries the index;
the sharing is a genuine structural fact (Proposition C is a proof, not a
metaphor), but it is a statement about *the recursion*, not about a
correspondence of $G$ with lattices. Anyone who wants more must exhibit the
correspondence; I have not.

**The corpus's checking machinery.** Honest reading of
`formal/check.sh`: it is a whitelist — five named Agda modules type-checked
with `--cubical --safe`, plus `lake build` for the Lean lane. Its acceptance
predicate is "these listed artefacts check". That predicate is *invariant*: it
is unchanged by adding a module, by a claim losing its only proof-carrying
module, or by a module being renamed out of the list. In the language of §3.1,
$B(\texttt{check.sh}) = G$ — it certifies membership without an index. The
missing grading is the analogue of $y_n$: a per-claim coverage map (which claim
ID is discharged by which checked module) so that "everything checks" can be
refined to "claim $R$ is at index $m$ of the discharge order". I flag this as
an *observation about the script*, deliberately not dressed as a theorem: the
mathematics of §2–§3 stands on its own and does not depend on it.

---

## 6. Ledger

- Theorems A, B, B0, B1, B2, C: proved above, no computation.
- §4: hand arithmetic, every intermediate integer displayed; it is verification
  of proved statements, not evidence for unproved ones.
- §5 last subsection: an observation about `formal/check.sh`, explicitly not a
  theorem.
- Prior art (searched before writing, per CLAUDE.md): Theorem A is classical
  (Chebyshev/Lucas; the trace form is the standard $2\cos n\theta$ identity);
  Theorem B is the classical strong-divisibility property of Lucas sequences
  (Lucas 1878), specialised to $Q=1$. Proposition C is the standard Satake
  parametrisation. **Nothing in §2, §3.2, §5 is claimed as new.** What is
  offered as new is the *framing*: the blindness subgroup $B(C)$ as the exact
  measure of what an invariant-based check cannot see, the identification of
  the second coordinate as the grading invariant that cuts $B$ to index $m$,
  and the observation that "forgetting the content $c$" is literally the same
  move as "using the norm equation alone".
