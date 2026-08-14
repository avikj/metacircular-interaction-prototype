# Naṣṭa and uddiṣṭa: the index maps of this corpus, and why "blind to a subgroup" is *not* "uddiṣṭa is ill-defined"

**Agent:** SEED-79 (Piṅgala lens: enumerate the whole space by a recursive rule
before counting anything in it; the pratyāya algorithms are a bijection between
patterns and their indices, and the bijection is the theorem).
**Date:** 2026-08-14. **Status:** proofs only. No run, no float, no fitted
quantity, no `.py` executed or created. Two files were read as text only
(`machinery/test_pentagram_labels.py` — unrelated; and the legacy scripts cited
by SEED-55, not re-read here).

**Reads in full:** `notes/SEED16_chebyshev_index_grading.md`,
`notes/SEED21_CHECK_CAPACITY_IS_AN_INDEX.md`,
`notes/SEED29_ROUTE_HOLONOMY_TORSOR.md`,
`notes/SEED32_INDEX_CAPACITY_RADIUS.md`,
`notes/SEED55_REWRITE_HOLONOMY_IS_SIX_NOT_TWELVE.md`,
`collab/messages/workers/20260814T082735Z--codex_cubical_ingestor--0008.md`.

---

## 0. The verdict, up front

The mandate asks whether

> "the check is blind to a subgroup" (SEED-21 / SEED-32) is the same statement as
> "uddiṣṭa is not well-defined".

**It is not, and the failure is one-directional and exactly locatable.**

> **Verdict.** Blindness ⟹ uddiṣṭa fails, always (Prop. 3.2). The converse is
> **false**: §4 exhibits a check on this corpus's own unit group whose blindness
> subgroup is *trivial* and whose uddiṣṭa map is nevertheless two-to-one — the
> **trace check**, whose fibres are the orbits of $n\mapsto -n$, an
> *automorphism* of the index group, not a translation of it. The converse
> becomes true exactly on the class SEED-32 already isolated for a different
> reason: $\Phi$-invariant (= *complete*) checks (Thm. 3.4). And even where the
> biconditional holds, the *numbers* still differ (SEED-32 Prop. 4.2), which is
> a second, independent gap.
>
> So the honest slogan is:
> **blindness is uddiṣṭa failing uniformly in the base point; uddiṣṭa failure is
> blindness at one point.** The corpus's `B(c)` is not "the reason `c` confuses
> things"; it is "the confusion that happens everywhere at once".

Sections 1–2 set up naṣṭa/uddiṣṭa in general and give the corpus's three
instances with exact costs. Section 3 proves the one direction and the
restricted biconditional. Section 4 refutes the converse. Section 5 gives the
~~three-tier~~ **six-row (tiers 0, 1, 1′, 2, 3, ∞ — SEED-115, 2026-08-14, Rule
K2: the summary line disagreed with its own §5 table, which has six rows)**
hierarchy that replaces the failed unification, and §6 sharpens
SEED-16 with the tier-2 example it did not have.

---

## 1. Prastāra, naṣṭa, uddiṣṭa in general

Piṅgala's three pratyāyas on the $2^n$ laghu–guru patterns of an $n$-syllable
metre are: **prastāra**, the recursive rule that lays out the whole table;
**naṣṭa**, "the lost one" — given an index, produce the pattern; **uddiṣṭa**,
"the pointed-at one" — given a pattern, produce its index. The mathematical
content is that naṣṭa and uddiṣṭa are mutually inverse and each costs one pass.

The corpus has repeatedly assumed that the structure making this work is a
**torsor**. It is not. The following is the right hypothesis, and it is strictly
weaker.

> **Definition 1 (an indexed enumeration).** An *indexed enumeration* is a triple
> $(X,\;I,\;\rho)$ where $I$ is a set of *indices* carrying a well-founded
> "predecessor" relation, and $\rho$ is a **unique-decomposition rule**: a
> bijection
> $$\rho:\;X \;\xrightarrow{\ \sim\ }\; \coprod_{a\in A} X_a$$
> onto a disjoint union of strictly smaller enumerations, matched with the same
> decomposition of $I$. Naṣṭa $\mathcal N: I\to X$ and uddiṣṭa
> $\mathcal U: X\to I$ are then defined by mutual recursion on the
> decomposition.

> **Lemma 1.1 (the pratyāya lemma).** For any indexed enumeration,
> $\mathcal U\circ\mathcal N=\mathrm{id}_I$ and
> $\mathcal N\circ\mathcal U=\mathrm{id}_X$, and each costs one traversal of the
> decomposition depth.
>
> *Proof.* Induction on the well-founded relation. At each stage $\rho$ is a
> bijection matching the $X$-side block with the $I$-side block, so the recursive
> calls are between corresponding smaller enumerations, where the statement holds
> by hypothesis; the base case is a singleton. $\blacksquare$

This is trivial, and saying it is the point: **the bijection is the theorem, and
the theorem needs unique decomposition, nothing more.** Three specialisations,
of decreasing structure:

- **Free group case (Piṅgala's own).** $X=\{L,G\}^n$, $I=\{1,\dots,2^n\}$,
  $\rho$ = "split on the first syllable". Naṣṭa is repeated halving, uddiṣṭa is
  repeated doubling; each is $\Theta(n)$ syllable-steps, and the bijection is
  base-2 numeration. Here $X$ *is* a torsor, under $(\mathbb Z/2)^n$.
- **No group at all (mātrā-vṛtta / mātrāmeru).** $X$ = the sequences of laghu
  ($1$ mātrā) and guru ($2$ mātrās) of total weight $m$; $|X|=F_{m+1}$, the
  mātrāmeru. $\rho$ splits on the first symbol into weight $m-1$ and $m-2$
  blocks — Piṅgala's recursion, and Fibonacci's. Naṣṭa and uddiṣṭa in the
  *lexicographic* index are the **Zeckendorf** expansion and its inverse: greedy
  subtraction of the largest Fibonacci number $\le$ the residue, which never
  takes two consecutive ones, and which is unique because
  $F_{k}+F_{k-2}+F_{k-4}+\dots < F_{k+1}$. Cost $\Theta(m)$ each.
  **No group acts on $X$ compatibly with $\rho$, and both maps exist anyway.**
- **Torsor case (SEED-29, SEED-31).** $X$ a right $G$-torsor with base point
  $x_0$, $I=G$: $\mathcal N(g)=x_0\cdot g$, $\mathcal U(x)=$ the unique $g$ with
  $x_0\cdot g=x$. Lemma 1.1 here is simple transitivity.

> **Corollary 1.2 (a corrective to the torsor framing).** The torsor hypothesis
> of SEED-29 Thm A and SEED-31 is *sufficient but not necessary* for an index
> calculus. What a route type needs in order to have naṣṭa/uddiṣṭa is a
> unique-decomposition rule on routes; the group structure is a bonus that makes
> $\mathcal U$ a single subtraction instead of a traversal. The mātrā case shows
> the two can be separated.

---

## 2. The corpus's three indexed objects, with exact costs

Throughout, "cost" means an exact operation count derived from the definitions —
no measurement is involved, and each bound is attained.

### 2.1 Powers of a fundamental unit (SEED-16)

$R=\mathbb Z[\sqrt d]$, $G=\{u: N(u)=1\}=\{\pm1\}\times\langle\varepsilon\rangle$,
$\varepsilon=x_1+y_1\sqrt d$, $\varepsilon^n=x_n+y_n\sqrt d$,
$x_n=T_n(x_1)$, $y_n=y_1U_{n-1}(x_1)$ (SEED-16 Thm A). Index set
$I=\{\pm1\}\times\mathbb Z$.

**Naṣṭa** $\mathcal N(\sigma,n)=\sigma\varepsilon^{\,n}$.
*Cost.* By the prastāra rule $(\ast)$, $w_{k+1}=2x_1w_k-w_{k-1}$: $n$ steps,
each on integers of $\le n\log_2\varepsilon+O(1)$ bits, so
$\Theta(n^2\log^2\varepsilon)$ bit operations naïvely. By binary powering with
the Chebyshev doubling identities $T_{2k}=2T_k^2-1$,
$U_{2k-1}=2T_kU_{k-1}$, it is $\Theta(\log n)$ ring multiplications, i.e.
$\Theta\!\big(M(n\log\varepsilon)\big)$ bit operations, which is
**optimal up to the multiplication constant, because the output already has
$\Theta(n\log\varepsilon)$ bits.** Naṣṭa is output-size bounded.

**Uddiṣṭa** $\mathcal U(u)=(\mathrm{sgn},\,n)$, exactly and without floating
point:
1. $\sigma:=\mathrm{sgn}(x(u))$; replace $u$ by $\sigma u$, so $x>0$.
2. $n\ge0$ iff $y\ge0$; replace $u$ by $\bar u=u^{-1}$ if $y<0$ and record the
   sign of the index.
3. Find $\lfloor\log_2 n\rfloor$ by doubling: compute $\varepsilon^{2^k}$ for
   $k=0,1,2,\dots$ and compare with $u$ (integer comparison of the first
   coordinates suffices, since $x_n$ is strictly increasing for $n\ge0$), until
   $x(\varepsilon^{2^k})>x(u)$. Then binary-search the remaining bits, each test
   being one multiplication and one comparison.

*Cost.* $\Theta(\log n)$ exact integer comparisons and multiplications on
operands of $\le n\log_2\varepsilon+O(1)$ bits — again
$\Theta(M(n\log\varepsilon))$, quasi-linear in the **input** size. So

> **Proposition 2.1.** For the unit group, naṣṭa and uddiṣṭa are mutually
> inverse (Lemma 1.1 in the torsor case) and both run in time quasi-linear in
> the bit length of the object. Step 3 is literally Piṅgala's doubling: the
> uddiṣṭa of a metre is computed by doubling from the last syllable, and the
> uddiṣṭa of a unit is computed by doubling from $\varepsilon$.

**The cheap sensor form.** SEED-16 Cor. B2: reduce mod $N$. Then
$\mathcal U(u)\bmod \pi(N)$ is read off from $(x,y)\bmod N$ in
$O(\pi(N))$ table look-ups after $O(\pi(N))$ precomputation, on operands of
$O(\log N)$ bits — independent of $n$. Aggregating several moduli by Qin's
dayan recovers $n \bmod \mathrm{lcm}$. This is the *only* sublinear uddiṣṭa
available, and it is partial by construction.

### 2.2 Routes to a Smith normal form (SEED-29)

$X=\mathrm{Fib}(M)$, a torsor under $\Gamma_D$ (SEED-29 Thm A). Fix a base route
$(U_0,V_0)$.
**Naṣṭa** $\mathcal N(H)=(HU_0,\,V_0K_H)$, $K_H=D^{-1}H^{-1}D$: two $n\times n$
integer multiplications and one exact division by the diagonal $D$,
$O(n^\omega)$ ring operations.
**Uddiṣṭa** $\mathcal U(U,V)=UU_0^{-1}$: one inverse of a unimodular matrix and
one multiplication, $O(n^\omega)$. Mutually inverse by Thm A's freeness.
**Both are exact and both are cheap** — the route index is *not* hard to
recover; what is hard is that most consumers never see $U$.

### 2.3 Cells in a rewrite schedule (SEED-55)

$X$ = rewrite paths $A_0=\mathrm{diag}(2,3,2)\rightsquigarrow D=\mathrm{diag}(1,2,6)$.
SEED-55 §2 gives the prastāra explicitly: two families, each
"one non-idle cell, $m\ge0$ idle cells, one non-idle cell, then an arbitrary
word of idle cells at $s_3$", with a free Bézout parameter $t\in\mathbb Z$ per
cell. So
$$I \;=\; \{\mathrm{I},\mathrm{II}\}\times \mathbb Z_{\ge0}\times \mathbb Z^{\,\text{cells}}\times(\text{words in the two idle cells at }s_3),$$
and **naṣṭa is a $\Theta(\text{path length})$ product of displayed $3\times3$
matrices**; uddiṣṭa on the path itself is a parse of the word, also linear.
That much is a genuine indexed enumeration.

What fails is uddiṣṭa **through the consumer**: the induced
$\rho:\text{paths}\to \mathrm{Aut}(A)$ has image $G_{\text{rewrite}}\cong S_3$ of
order $6$, and by SEED-55 Prop. 3.4 every path has $\psi(U)=u_{32}\equiv1\pmod 3$.
Read in the present language:

> **Proposition 2.2.** The 3-primary coordinate $\psi$ is a check on rewrite
> paths whose value set is a **singleton**. Its blindness subgroup is
> everything, its zero-error capacity is $0$ bits (SEED-21 Thm 1), and the
> uddiṣṭa map through $\psi$ is maximally ill-defined. SEED-55's theorem is
> exactly the statement that this particular pratyāya has capacity zero, and the
> index-$2$ defect $[\mathrm{Hol}(D):G_{\text{rewrite}}]=2$ is the size of what
> the enumeration never reaches — not what a check fails to see. **These are
> different failures and SEED-55 correctly kept them apart**: one is a
> non-surjective naṣṭa, the other a non-injective uddiṣṭa.

---

## 3. Blindness implies uddiṣṭa failure; and the exact converse

Fix the SEED-32 conventions (handedness matters and is fixed there once):
$X$ a **right** $G$-torsor, $\Phi=\mathrm{Aut}_G(X)\cong G$ acting on the left
and commuting with the right action, $c:X\to\Sigma$ a check, and
$$B(c)\;=\;\{n\in G:\ c(x\cdot n)=c(x)\ \ \forall x\in X\}$$
its blindness subgroup (SEED-16 §3.1, SEED-21 Thm 2, SEED-32 Def. 2 — three
independent arrivals at the same definition).

> **Definition 3.1 (uddiṣṭa through a check).** Fix $x_0$, so
> $\mathcal U:X\to G$ is the torsor uddiṣṭa. *Uddiṣṭa through $c$* is the
> partial map $\mathcal U_c:c(X)\to G$ that is asked to satisfy
> $\mathcal U_c(c(x))=\mathcal U(x)$. It is **well-defined** iff $c$ is
> injective.

> **Proposition 3.2 (one direction, unconditional).** If $B(c)\neq\{1\}$ then
> $\mathcal U_c$ is not well-defined. More precisely, the partition of $X$ into
> $B(c)$-cosets **refines** the fibre partition of $c$, so
> $$\#\text{fibres of }c\ \le\ [G:B(c)],$$
> and $\mathcal U_c$ is well-defined only as a map into $G/B(c)$ at best.
>
> *Proof.* If $y=x\cdot n$ with $n\in B(c)$ then $c(y)=c(x)$ by definition, so
> each coset lies within one fibre; a nontrivial $n\in B(c)$ therefore gives
> $x\neq x\cdot n$ with equal check values. $\blacksquare$

Note the inequality direction: fibres are *coarser*, so the index
$[G:B(c)]$ is an **upper** bound on distinguishing power, never a lower one.
This is precisely SEED-32 Prop. 4.2 seen from the index side ($C_3$ on $d=2$:
$[G:B]=3$, fibres $=2$).

> **Definition 3.3 ($\Phi$-invariant = complete).** $c$ is **$\Phi$-invariant**
> if its fibre partition is preserved by the left action: $c(x)=c(y)$ implies
> $c(gx)=c(gy)$ for all $g$. (SEED-32's "complete" checks satisfy this, since
> for them fibres *are* the $B(c)$-cosets, which the commuting left action
> permutes.)

> **Theorem 3.4 (the exact biconditional).** For $\Phi$-invariant $c$:
> $$\mathcal U_c \text{ is ill-defined}\iff B(c)\neq\{1\},$$
> and moreover the fibres of $c$ are exactly the $B(c)$-cosets, so
> $\#\text{fibres}=[G:B(c)]$ and SEED-21's capacity $\log_2[G:B(c)]$ is attained
> by $c$ itself rather than by its completion.
>
> *Proof.* ($\Leftarrow$) is Prop. 3.2. ($\Rightarrow$): suppose $c$ is not
> injective, so $c(x)=c(x\cdot n)$ for some $x$ and some $n\neq1$ (write the two
> colliding points as $x$ and $x\cdot n$, possible by simple transitivity). Let
> $z\in X$ be arbitrary and write $z=g\cdot x$ with $g\in\Phi$ (the left action
> is transitive). The two actions commute, so $g\cdot(x\cdot n)=(g\cdot x)\cdot n
> =z\cdot n$. $\Phi$-invariance applied to the collision $c(x)=c(x\cdot n)$ gives
> $c(g x)=c(g(x n))$, i.e. $c(z)=c(z\cdot n)$. As $z$ was arbitrary, $n\in B(c)$
> and $B(c)\neq\{1\}$. For the "moreover": each fibre is a union of cosets by
> Prop. 3.2; conversely if $c(x)=c(y)$, put $n=\mathcal U(x)^{-1}\mathcal U(y)$
> and the argument just given puts $n\in B(c)$, so $y\in xB(c)$. $\blacksquare$

> **Corollary 3.5 (the practical test).** Every check that is a **group
> homomorphism** $c:G\to\Sigma$, or more generally a $G$-equivariant map to a
> $G$-set, is $\Phi$-invariant, so for it the mandate's identification holds
> exactly, with $B(c)=\ker c$ and fibres $=$ cosets. This is why the corpus kept
> finding the identification true: SEED-29's cokernel consumer $h:\Gamma_D\to
> \mathrm{Aut}(\mathrm{coker}\,D)$ is a homomorphism ($B=\ker h$, fibres = its
> cosets, image $\mathrm{Hol}(D)$), SEED-21's transcript checks record coset
> representatives, and SEED-55's $\rho$ is a monoid map. **Every worked instance
> in the corpus is in the $\Phi$-invariant class.** That is a fact about the
> corpus's checks, not a theorem about checks.

> **Corollary 3.6 (SEED-16's $C_m$ is the boundary case).** The subgroup-
> membership check $C_m=\mathbf 1_{H}$, $H=\pm\langle\varepsilon^m\rangle$, has
> $B(C_m)=H$ (SEED-16 Cor. B1) but only two fibres, $H$ and $G\setminus H$. It is
> $\Phi$-invariant iff $[G:H]\le2$, i.e. iff $m\le2$. For $m\ge3$ the
> biconditional of Thm 3.4 still holds *as a boolean* (both sides are true) but
> the cardinalities diverge — SEED-32 Prop. 4.2. So there are **two independent
> gaps**, and they should not be conflated:
> *(i) the boolean gap* (§4 below: one side true, the other false), and
> *(ii) the quantitative gap* (here: both true, numbers different).

---

## 4. The refutation: a check with trivial blindness whose uddiṣṭa fails

The converse of Prop. 3.2 is what the mandate's unification needs, and it is
false. The counterexample is not manufactured; it is the check SEED-16 spends
its Theorem A on.

> **Theorem 4.1 (separating example — the trace check).** Let
> $G=\{\pm1\}\times\langle\varepsilon\rangle$ as in §2.1 and let
> $$\mathrm{tr}:G\to\mathbb Z,\qquad \mathrm{tr}(u)=u+\bar u=2x(u)$$
> be the **trace check** (equivalently, "record the first coordinate"). Then
> $$B(\mathrm{tr})=\{1\},\qquad\text{yet}\qquad \mathrm{tr}(\varepsilon^{\,n})=\mathrm{tr}(\varepsilon^{-n})\ \ \forall n,$$
> so $\mathcal U_{\mathrm{tr}}$ is two-to-one on $\{n\neq0\}$ and not
> well-defined. Hence **blindness is strictly stronger than uddiṣṭa failure.**
>
> *Proof.* *Non-injectivity.* $x_n=T_n(x_1)$ and $T_{-n}=T_n$ (immediate from
> $T_n(\cos\theta)=\cos n\theta$, or from the recursion run backwards:
> $w_{-1}=2x_1w_0-w_1=2x_1-x_1=x_1=w_1$, and induction). Equivalently
> $\overline{\varepsilon^{\,n}}=\varepsilon^{-n}$ since $N(\varepsilon)=1$, and
> conjugation fixes the trace. So $\mathrm{tr}$ identifies $\varepsilon^n$ with
> $\varepsilon^{-n}$, distinct for $n\neq0$ because $\varepsilon>1$.
>
> *Trivial blindness.* Let $g=\sigma\varepsilon^{\,k}\in B(\mathrm{tr})$, so
> $x_{n+k}=x_n$ for all $n$ when $\sigma=+1$. Taking $n\to\infty$ and using
> $x_n\sim\tfrac12\varepsilon^{\,n}\to\infty$ strictly increasing for $n\ge0$
> (SEED-16 §3.2: $x_{n+1}=2x_1x_n-x_{n-1}>x_n$ for $x_1\ge2$) forces $k=0$. If
> $\sigma=-1$ then $x(ug)=-x(u)$, which equals $x(u)$ only if $x(u)=0$, false for
> $u=1$. So $B(\mathrm{tr})=\{1\}$. $\blacksquare$

**Where the collision lives.** The fibre partition of $\mathrm{tr}$ is the orbit
partition of the group $\langle\iota\rangle\cong\mathbb Z/2$, $\iota(u)=\bar u$
— an **automorphism** of $G$ (indeed the generator of
$\mathrm{Gal}(K/\mathbb Q)$, acting on indices by $n\mapsto -n$), not a
translation by an element of $G$. Blindness subgroups by construction only see
translations. The natural home for both is the **holomorph**
$\mathrm{Hol}(G)=G\rtimes\mathrm{Aut}(G)$:

> **Definition 4.2 (pratyāya stabiliser).**
> $\Pi(c)=\{\theta\in\mathrm{Hol}(G):\ c\circ\theta=c\}$. Then
> $B(c)=\Pi(c)\cap G$ is its translation part.

> **Corollary 4.3.** $\Pi(\mathrm{tr})\supseteq\langle\iota\rangle$ while
> $B(\mathrm{tr})=\Pi(\mathrm{tr})\cap G=\{1\}$: the corpus's blindness
> subgroup is the projection of $\Pi$ to the translation factor, and that
> projection kills exactly the automorphism part. **This is the whole of the
> discrepancy in this example.**

**But $\Pi$ does not rescue the unification either**, and I state the limit
rather than overselling the repair:

> **Proposition 4.4 (no group explains every collision).** Let
> $G=\mathbb Z$ and $c:\mathbb Z\to\{0,1\}$ with $c^{-1}(0)=\{0,1,3\}$. Then $c$
> is non-injective (one fibre has size $3$), and $\Pi(c)=\{1\}$, hence also
> $B(c)=\Pi(c)\cap G=\{0\}$.
>
> *Proof.* $\mathrm{Hol}(\mathbb Z)$ is the group of affine maps
> $n\mapsto\pm n+a$, and such a map preserves $c$ iff it preserves
> $F:=\{0,1,3\}$ setwise. A translation $n\mapsto n+a$ preserving a nonempty
> finite set must have $a=0$ (compare maxima). A reflection $n\mapsto a-n$
> requires $F$ symmetric about $a/2$; matching $\min$ and $\max$ forces $a=3$,
> and then $3-1=2\notin F$. So $\Pi(c)=\{1\}$ while $\mathcal U_c$ is $3$-to-$1$
> on that fibre. $\blacksquare$
>
> Consequently: **every partition is the orbit partition of *some* group of
> bijections of $X$** (take the product of the symmetric groups on the blocks),
> so the statement "uddiṣṭa failure is blindness to a subgroup" is vacuously
> true if the subgroup may live in $\mathrm{Sym}(X)$, and false for every group
> small enough to be informative ($G$, or $\mathrm{Hol}(G)$). The content is
> entirely in *which* group is permitted.

---

## 5. The hierarchy that replaces the unification

Putting §3 and §4 together, with a corpus instance for each tier:

| tier | condition on $c$ | what fails | corpus instance | capacity |
|---|---|---|---|---|
| 0 | $c$ injective | nothing; $\mathcal U_c$ exists | joint transcript $L\wedge R$ (SEED-21 §2) | $\log_2\lvert X\rvert$ |
| 1 | $B(c)\ne1$, fibres $=$ cosets ($\Phi$-invariant) | $\mathcal U_c$ lands in $G/B(c)$, exactly | cokernel consumer $h$ (SEED-29 Thm B); left transcript $L$ | $\log_2[G:B(c)]$ |
| 1′ | $B(c)\ne1$, fibres strictly coarser | $\mathcal U_c$ loses *more* than $B(c)$ | $C_m$, $m\ge3$ (SEED-16 Cor. B1) | $\log_2\#\text{fibres}<\log_2[G:B]$ |
| 2 | $B(c)=1$, $\Pi(c)\ne1$ | $\mathcal U_c$ fails by an **automorphism** | **trace check** (Thm 4.1); fibres $\{\pm n\}$ | exactly one bit below tier $0$ |
| 3 | $\Pi(c)=1$, $c$ non-injective | $\mathcal U_c$ fails with no group at all | Prop. 4.4 | $\log_2\#\text{fibres}$ |
| $\infty$ | $c$ constant | $\mathcal U_c$ carries nothing | endpoint check $\varepsilon$ (SEED-21 §2 E); $\psi$ on rewrites (Prop. 2.2) | $0$ |

Each row is realised, and ~~the containments $0\subsetneq1\subsetneq1'\subsetneq
2\subsetneq3$ are strict by the instances named.~~

> **Struck (SEED-94, 2026-08-14).** The tiers are ~~**pairwise disjoint**~~
> **pairwise disjoint with one exception, stated in the annotation below
> (SEED-115)**, not
> nested: tier 0 requires $c$ injective and tiers 1–3 require it non-injective,
> so no containment $0\subseteq1$ can hold, and tiers 1/1′ ($B(c)\neq1$) are
> disjoint from tiers 2/3 ($B(c)=1$) by their defining conditions. What the
> instances establish is the correct and sufficient claim: **every row is
> nonempty**, and the rows are totally ordered by *severity of uddiṣṭa failure*,
> not by inclusion. Nothing else in §5 or in the verdict of §0 depends on the
> struck sentence — the refutation of the unification needs only that rows 2 and
> 3 are nonempty, which Thm 4.1 and Prop. 4.4 supply. **The mandate's identification
is the assertion that rows $2$ and $3$ are empty. Row $3$ is a construction; row
$2$ is a check this corpus already uses.**

> **Correction to the correction (SEED-115, 2026-08-14, Rule K2/K3; checked
> against this note's own §5 table and Thm 3.4).** SEED-94's replacement claim
> **"pairwise disjoint"** is false for one pair, and the failure is visible in
> the table it was correcting: **row $\infty$ is contained in row $1$.** If $c$
> is constant on $X$ (row $\infty$) then $B(c)=G$, and the single fibre $X$ is
> exactly one coset of $B(c)=G$ — so $c$ satisfies row $1$'s condition
> "$B(c)\ne1$, fibres $=$ cosets" whenever $|X|>1$. Consistently, row $1$'s
> capacity $\log_2[G:B(c)]=\log_2 1=0$ agrees with row $\infty$'s $0$. Row
> $\infty$ is therefore not a separate tier but the **extreme case of tier 1,
> $B(c)=G$**, listed separately because it is the corpus's degenerate instance
> ($\psi$ on rewrites, Prop. 2.2).
>
> The correct statement is: **rows $0,1,1',2,3$ are pairwise disjoint, row
> $\infty\subsetneq$ row $1$, and every row is nonempty.** Disjointness of the
> five holds for the reasons SEED-94 gives, plus one SEED-94 left implicit:
> row 3 requires $\Pi(c)=1$, hence $B(c)=\Pi(c)\cap G=1$ (Def. 4.2), so row 3
> is disjoint from rows 1 and 1′ as well as from row 2.
>
> **Nothing above or below this annotation changes.** SEED-94's operative
> conclusion — that the rows are ordered by *severity of uddiṣṭa failure* and
> not by inclusion, and that the refutation needs only rows 2 and 3 nonempty —
> survives verbatim; row $\infty$'s containment in row 1 is at the *opposite*
> end of the table from rows 2 and 3 and touches neither Thm 4.1 nor Prop. 4.4
> nor the verdict of §0.

> **Consequence for SEED-21 and SEED-32.** SEED-21's Theorem 2 hypothesis
> ("$c(x)=c(y)\iff y=x\cdot n$, $n\in N$") is precisely "tier $\le1$", and
> SEED-32 §3.1's observation that completeness is a hypothesis is the same
> boundary. Neither note is wrong; what neither states is that the hypothesis
> can fail *upward* (tier 2) as well as *downward* (tier 1′). SEED-32 refused to
> unify index with capacity on the grounds that one is a $(G,N)$-invariant and
> the other is not; **I refuse to unify blindness with uddiṣṭa failure on the
> grounds that one is a subgroup of $G$ and the other is a partition of $X$, and
> the passage from partitions to subgroups is exactly the loss of the
> automorphism part.**

---

## 6. What this sharpens in SEED-16

SEED-16's headline is that "the linear recurrence remembers which power you are
at while the defining equation cannot". Theorem 4.1 says this is true **up to
sign and no further** for the first coordinate alone:

> **Proposition 6.1 (exact uddiṣṭa content of each Chebyshev coordinate).**
> With $x_n=T_n(x_1)$, $y_n=y_1U_{n-1}(x_1)$ and $n\in\mathbb Z$:
> $$x_{-n}=x_n\ (T\ \text{even}),\qquad y_{-n}=-y_n\ (U_{-n-1}=-U_{n-1}).$$
> Hence
> - the **first** coordinate determines $\lvert n\rvert$ and nothing more:
>   $\mathcal U_{x}$ is well-defined on $\mathbb Z/\langle\pm\rangle$, tier 2;
> - the **second** coordinate determines $n$ up to nothing extra on
>   $\langle\varepsilon\rangle$ once its sign is read, but is blind to the
>   global sign $\sigma$ only in combination — precisely,
>   $y(\sigma\varepsilon^n)=\sigma y_n$, so $\mathcal U_y$ determines
>   $\sigma\cdot\mathrm{sgn}(n)$ and $\lvert n\rvert$, again a two-to-one map
>   (fibres $\{(\sigma,n),(-\sigma,-n)\}$), tier 2 with the *same* automorphism;
> - the **pair** $(x,y)$ is injective on $G$: tier 0, and this is why the
>   uddiṣṭa algorithm of §2.1 needs both.
>
> *Proof.* Evenness of $T_n$ and oddness of $U_{n-1}$ under $n\mapsto-n$ follow
> from $\varepsilon^{-n}=\overline{\varepsilon^{\,n}}=x_n-y_n\sqrt d$, which is
> the statement $x_{-n}=x_n$, $y_{-n}=-y_n$ read in the basis $\{1,\sqrt d\}$.
> Injectivity of the pair is the definition of the basis. $\blacksquare$

So the corrected slogan for SEED-16 is: **the trace remembers how far you have
gone, not which way; the second coordinate remembers the way. Uddiṣṭa needs
both, and the group-theoretic reason is that the missing datum is a Galois
automorphism, invisible to any blindness subgroup.**

This also gives SEED-16 §3.1 its missing companion. That section proves
$B(N{=}1)=G$: the norm check is tier $\infty$. Theorem 4.1 supplies the other
end: the trace check is tier 2, $B=1$, and still cannot index. **A trivial
blindness subgroup is not a certificate that a check indexes.**

---

## 7. Rigor boundary

**Proved here in full:** Lemma 1.1 and Cor. 1.2; the Zeckendorf
unique-decomposition statement for mātrā-vṛttas (classical, greedy argument
sketched, cited as classical — Zeckendorf 1972, and Piṅgala's own naṣṭa for the
$2^n$ case, both prior art, searched before writing); Prop. 2.1 and the cost
statements of §2 (exact operation counts derived from the recurrences and the
displayed algorithms, with $M(\cdot)$ left as the multiplication cost — no
constant is fitted and no run was made); Prop. 2.2 (a restatement of SEED-55
Prop. 3.4 in check language); Prop. 3.2, Thm 3.4, Cors. 3.5, 3.6; Thm 4.1 and
Cor. 4.3; Prop. 4.4; Prop. 6.1.

**Cited, not reproved:** SEED-16 Thms A, B, Cors. B1, B2; SEED-21 Thms 1, 2;
SEED-29 Thms A, B and §5; SEED-32 Thm 1 and Props. 4.2, 4.3; SEED-55 Prop. 3.4
and §5.

**Not claimed:** no novelty for Lemma 1.1 (it is the pratyāya pair, ~200 BCE),
for the Chebyshev parities, or for the holomorph. What is offered as new is
(i) the tier table of §5 with a corpus instance in every row, (ii) Thm 3.4 —
the exact hypothesis ($\Phi$-invariance) under which "blind to a subgroup" and
"uddiṣṭa ill-defined" coincide, with the base-point-uniformity proof, and
(iii) Thm 4.1 / Prop. 6.1 — the trace check as a tier-2 witness, which refutes
the mandate's unification using an object SEED-16 had already put on the table.

**Not proved:** whether every tier-2 check arising naturally in this corpus has
$\Pi(c)$ generated by a Galois or duality involution. I suspect it (the two
candidates I can see, conjugation on $R$ and transpose-inverse on $\Gamma_D$,
are both involutions) but have not looked systematically, and it is not used
above.

No floating-point quantity appears. Nothing was measured. No `.py` file was
executed or created.

## 8. Standing queue

1. `PROVE` — Compute $\Pi(c)$, not merely $B(c)$, for SEED-21's four
   normalisation checks E, L, R, C. The transpose-inverse involution of
   $\mathrm{GL}_n(\mathbb Z)$ exchanges the left and right transcripts; if it
   lies in $\Pi(c_L)\cdot\Pi(c_R)$ the "corner leaks to both sides" remark of
   SEED-21 §2 acquires an exact symmetry statement, and the capacity table may
   need a tier-2 row.
2. `PROVE` — Is $G_{\text{rewrite}}$ (SEED-55) the image of a *naṣṭa* map that
   is non-surjective for a tier reason, i.e. does the index-$2$ defect equal
   $\Pi/B$ for some involution of $\mathrm{Aut}(A)$? SEED-55's missing coset is
   inversion of the $3$-primary part, which *is* an involution; the question is
   whether it is realised in $\Pi$ of any check on paths.
3. `SEARCH` — Any check in this repository at tier 3 (non-injective with
   $\Pi=1$). Prop. 4.4 shows they exist abstractly; if none occurs here, then
   every corpus check is explained by a group and §5's row 3 can be recorded as
   empty-in-practice — which would be worth knowing, and is a search, not a
   computation.
4. `DEMONSTRATE` (Agda, `formal/cubical/`) — Lemma 1.1 for the fixed-width word
   enumeration of `codex_cubical_ingestor` worker-0008: `canonicalize` /
   `normalizeMSD` there are naṣṭa and uddiṣṭa for positional numeration, and
   that note's "exact naturality locus" is the statement that the two pratyāyas
   commute with digit deletion exactly off the zero-value stratum. Stating it as
   Lemma 1.1 plus a boundary condition would connect that lane to this one.
