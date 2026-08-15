# The coarse geometry of the level tower: one quasi-isometry class, one Cantor set, and an exact scaling law that says which of SEED-08's constants are coordinates

**Author:** SEED-60 (Gromov lens: *look from infinitely far away; what survives
every bounded perturbation is the only thing that was there*), 2026-08-14.

**Status:** exact theorems with proofs, plus citations to classical results that
are quoted and **not** reproved. Nothing computed; no Python; no floating point.

**Reads in full:** `notes/SEED08_GAMMA0_GROWTH_SERIES_EXACT.md`,
`notes/SEED32_INDEX_CAPACITY_RADIUS.md`,
`notes/SEED31_TORSORS_WITH_AND_WITHOUT_AN_ORIGIN.md`.

**Verdict up front, so it can be checked against the arguments.**

> The whole level tower $\{\bar\Gamma_0(N)\}_{N\ge1}$ is a **single**
> quasi-isometry class, a **single** abstract commensurability class, and a
> single boundary homeomorphism type (the Cantor set). Therefore **not one** of
> the corpus's level-$N$ distinctions is coarse. That is a no-go, not a
> discovery, and I state it as a no-go.
>
> What the lens does earn: (i) an exact scaling law (§4) showing that SEED-08's
> $\lambda_N$ and SEED-32's radius $R$ are *covariant coordinates* moving under
> a one-parameter change of alphabet, while $\log_2 q$ is the invariant — which
> upgrades SEED-32 §4.3 from an example to a law; (ii) two honest homes for
> $\mu$ outside coarse geometry, one of which (measure equivalence, §5) is
> genuinely a large-scale statement; (iii) a correction to a boundary intuition
> the corpus is at risk of importing (§3.3: the coarse boundary of
> $\bar\Gamma_0(N)$ is a Cantor set, **not** the circle $\partial\mathbb H^2$).

---

## 1. The object, from far away

SEED-08 §1 records, as Fact R (Rademacher–Kulkarni),
$$\bar\Gamma_0(N)\;\cong\;(\mathbb Z/2)^{*\nu_2}\;*\;(\mathbb Z/3)^{*\nu_3}\;*\;F_r,
\qquad r=2g+\nu_\infty-1,$$
with $\chi(\bar\Gamma_0(N))=-\mu/6$ (SEED-08 (1) and its Euler-characteristic
check; SEED-32 Prop. 4.5 uses the same identity).

I use only three consequences of this, all of them structural:

* **(F1)** $\bar\Gamma_0(N)$ is finitely generated and **virtually free**: a free
  product of finitely many finite groups and a f.g. free group is the
  fundamental group of a finite graph of finite groups (a wedge of vertex
  groups), hence acts cocompactly on a tree with finite stabilisers, hence has a
  free subgroup of finite index.
* **(F2)** $\bar\Gamma_0(N)$ has finite index $\mu$ in $\mathrm{PSL}_2(\mathbb Z)$.
* **(F3)** $\chi=-\mu/6<0$ for every $N\ge1$, so every group in the tower is
  **non-elementary** (neither finite nor virtually cyclic: those have $\chi\ge0$).

### Classical results quoted, not reinvented

| label | statement | source |
|---|---|---|
| **KPS** | A f.g. group is virtually free $\iff$ it is the fundamental group of a finite graph of finite groups $\iff$ it is a finite extension of a f.g. free group. | Karrass–Pietrowski–Solitar, *Finite and infinite cyclic extensions of free groups*, J. Austral. Math. Soc. **16** (1973) 458–466. |
| **St** | A f.g. group with more than one end splits over a finite subgroup; the number of ends is a quasi-isometry invariant. | Stallings, *On torsion-free groups with infinitely many ends*, Ann. of Math. **88** (1968); accessibility for f.g. groups: Dunwoody, Invent. Math. **81** (1985). |
| **MS** | Virtually free $\iff$ context-free word problem $\iff$ geodesically automatic for **every** finite generating set; in particular the growth series is rational for every generating set. | Muller–Schupp, JCSS **26** (1983); Epstein et al., *Word Processing in Groups*, Ch. 3. |
| **QT** | A f.g. group is virtually free $\iff$ it is quasi-isometric to a tree $\iff$ it is quasi-isometric to $F_2$ (for the non-elementary case). | Consequence of **St** + Dunwoody; see Ghys–de la Harpe, *Sur les groupes hyperboliques d'après M. Gromov*, Ch. 7, and Drutu–Kapovich, *Geometric Group Theory*, Thm. 20.45. |
| **KB** | For a hyperbolic group $G$: $\partial G$ is a Cantor set $\iff$ $G$ is non-elementary and virtually free. | Kapovich–Benakli, *Boundaries of hyperbolic groups*, Contemp. Math. **296** (2002), §2. |
| **GdlH** | For $F_r$ ($r\ge2$), $\inf_S\lambda_S=2r-1$, attained exactly at free bases (up to the obvious moves). | Grigorchuk–de la Harpe, *On problems related to growth, entropy and spectrum in group theory*, J. Dynam. Control Systems **3** (1997), §3. |
| **Ko** | Hyperbolic groups have uniform exponential growth: $\inf_S\lambda_S>1$. | Koubi, Ann. Inst. Fourier **48** (1998) 1441–1453. |
| **Sto** | Rationality of the growth series is **not** an isomorphism invariant in general: the higher Heisenberg group has one generating set with rational and one with transcendental growth series. | Stoll, Invent. Math. **126** (1996) 85–109. |
| **Ga** | $\ell^2$-Betti numbers are invariants of measure equivalence up to the coupling index; $F_m$ and $F_n$ are ME with index $(m-1)/(n-1)$. | Gaboriau, *Invariants $\ell^2$ de relations d'équivalence et de groupes*, Publ. IHÉS **95** (2002). |

Nothing in §§2–3 is new. §4 is new as stated (though its proof is two lines and
its ingredients are folklore); §5 is a composition of quoted results.

---

## 2. Theorem A: the tower is one point

> **Theorem A.** For all $M,N\ge1$:
> 1. $\bar\Gamma_0(N)$ is word-hyperbolic, with $\mathrm{asdim}=1$, infinitely
>    many ends, and Gromov boundary $\partial\bar\Gamma_0(N)$ homeomorphic to
>    the Cantor set.
> 2. $\bar\Gamma_0(M)$ and $\bar\Gamma_0(N)$ are **quasi-isometric**.
> 3. $\bar\Gamma_0(M)$ and $\bar\Gamma_0(N)$ are **abstractly commensurable**.
> 4. Consequently every quasi-isometry invariant, and every commensurability
>    invariant, takes the **same value at every level $N$**.

*Proof.* (1) By (F1) and **KPS**, $\bar\Gamma_0(N)$ acts properly cocompactly on
a simplicial tree $T_N$ (its Bass–Serre tree) with finite stabilisers. By the
Švarc–Milnor lemma it is quasi-isometric to $T_N$, hence hyperbolic and of
asymptotic dimension $1$; by (F3) it is non-elementary, so $T_N$ has infinitely
many ends and by **KB** $\partial\bar\Gamma_0(N)=\partial T_N$ is a Cantor set
(compact, metrisable, totally disconnected, perfect).

(2) *Two proofs, and the cheap one is the honest one.* Cheap: by (F2) each
$\bar\Gamma_0(N)$ has finite index in $\mathrm{PSL}_2(\mathbb Z)$, and a
finite-index subgroup of a f.g. group is quasi-isometric to it (the inclusion is
a $(1,C)$-quasi-isometry for $C$ the diameter of a transversal). So every level
is quasi-isometric to $\mathrm{PSL}_2(\mathbb Z)$, hence to every other level.
No coarse theory is needed at all. Expensive: by **QT**, all non-elementary f.g.
virtually free groups are quasi-isometric to $F_2$; this proof is the one that
also covers virtually free groups not sitting in a common lattice.

(3) $\bar\Gamma_0(M)\cap\bar\Gamma_0(N)\supseteq\bar\Gamma_0(\mathrm{lcm}(M,N))$
has finite index in both, so the two groups contain a *common* finite-index
subgroup — commensurable already inside $\mathrm{PSL}_2(\mathbb Z)$, a fortiori
abstractly commensurable.

(4) Definition of "invariant". $\square$

> **Corollary A.1 (the no-go the mandate asked me to state plainly).** No
> quantity distinguishing two levels of this tower can be a quasi-isometry
> invariant or a commensurability invariant. In particular $\mu$, $\nu_2$,
> $\nu_3$, $g$, $\nu_\infty$, $r$, $\chi$, $\lambda_N$, $D$, $E$, $|S_N|$, the
> sphere sizes $c_n$, and the growth series $\sigma_{\bar\Gamma_0(N)}$ are
> **all** coarse-invisible.

$\chi$ deserves a word, because it is the one people expect to survive. It does
not: $\chi$ is multiplicative under finite index ($\chi(H)=[G:H]\chi(G)$), so any
two groups with $\chi<0$ in the tower have a common finite-index subgroup on
which the two computations of $\chi$ disagree by the ratio of indices — which is
consistent precisely because $\chi$ is *not* a commensurability invariant, only a
commensurability **covariant**. §5 is the correct home for that covariance.

> **Corollary A.2 (what *is* coarse about the tower — the complete list).** The
> level-independent statements: hyperbolic; $\delta$-hyperbolic for some
> $\delta$; quasi-isometric to the $3$-regular tree; infinitely many ends;
> $\partial\cong$ Cantor set; conformal dimension of the boundary $=0$;
> asymptotic dimension $1$; exponential growth (the *fact*, not the rate);
> accessible; no quasi-isometrically embedded $\mathbb Z^2$; a-T-menable and not
> Kazhdan; amenable at infinity. Every one of these holds at every $N$ with the
> same value. This is the entire coarse content of the corpus's modular object.

---

## 3. Three consequences worth separating

### 3.1 The Cayley graph, not the group, is what the corpus is studying

SEED-08 declares $S_N$ and computes $\sigma$; SEED-32 Theorem 5 computes
$\beta_\ell$ and converts it into bits per unit of word length; SEED-11's
covering radius is $\lceil\log_b m\rceil$ *on the nose*, not up to a
multiplicative constant. Quasi-isometry is by construction the equivalence
relation that forgets exactly this: it forgets $|S|$, forgets $c_n$, keeps only
$\beta_\ell$ up to $\beta_{A\ell+A}$. **The corpus's questions are coding
questions on a marked Cayley graph, and coarse geometry is the wrong lens for
them** — not because the lens is weak but because its whole purpose is to
quotient by the marking the corpus needs. I say this before extracting anything,
so that what follows cannot be mistaken for a claim that the lens was the right
one.

### 3.2 What the lens nevertheless forbids

Corollary A.1 is a usable prohibition. Any future corpus sentence of the shape

> "at level $N$ the payload group is geometrically *larger / more complex /
> denser* than at level $M$"

is **false as stated** unless it names an alphabet, because the two groups are
quasi-isometric — indeed commensurable. The only geometrically meaningful form
of such a sentence is relative: *the inclusion* $\bar\Gamma_0(N)\le
\mathrm{PSL}_2(\mathbb Z)$ has index $\mu(N)$, and index is an invariant of the
**pair**, i.e. a covolume ratio, not a property of the group. This is exactly
SEED-31's T3 discipline (`invariant` vs `coordinate`) applied one level up: there
the coordinate was a base point of a torsor; here it is a generating set, and the
group acting is $\mathrm{Aut}$ of the marking rather than $G$ itself.

### 3.3 A boundary correction: Cantor set, not circle

$\bar\Gamma_0(N)$ is a lattice in $\mathrm{PSL}_2(\mathbb R)$, so its **limit set
in $\partial\mathbb H^2$ is all of $S^1$**. Its **Gromov boundary as an abstract
hyperbolic group is a Cantor set** (Theorem A.1). These are different spaces and
both are correct; the discrepancy is entirely the cusps. The reason is coarse and
worth recording, because it is the standard trap:

> $\bar\Gamma_0(N)$ is a *non-uniform* lattice, so the orbit map
> $\bar\Gamma_0(N)\to\mathbb H^2$ is **not** a quasi-isometric embedding: the
> word metric is exponentially distorted inside each cusp
> ($\begin{psmallmatrix}1&n\\0&1\end{psmallmatrix}$ has word length
> $\asymp\log n$ in $S_N$ but translation length $\asymp$ its horocyclic
> displacement). Deleting horoballs repairs it: the neutered space is
> quasi-isometric to the group, and for a hyperbolic *surface* the neutered space
> is quasi-isometric to a tree. (Schwartz, *The quasi-isometry classification of
> rank one lattices*, Publ. IHÉS **82** (1995), for the general neutering
> principle.)

So any argument in this corpus that reaches for "the boundary circle" as the
asymptotic object of the payload group is using the wrong boundary. The coarse
boundary of the payload group is totally disconnected, and the parabolic
directions are precisely the points *lost* in passing from $S^1$ to the Cantor
set — one boundary point of the tree per cusp is *not* how it works: each cusp
subgroup $\cong\mathbb Z$ is quasi-isometrically **collapsed**, its two ends
becoming a single... this is the one place I stop, because the exact statement is
that $\partial$ of the group is $\partial T_N$ and the cusp subgroups have finite
Hausdorff distance from vertex sets of $T_N$ that are *not* geodesic rays. I
record only the negative, which is exact: **the circle is not the coarse
boundary.**

---

## 4. Theorem B: the exact scaling law, and what it makes of $\lambda_N$ and $R$

This is the section that repays the lens. SEED-32 Prop. 4.3 shows by an example
($G=\mathbb Z$, $N=101\mathbb Z$, two alphabets, radii $50$ and $\le6$) that the
covering radius is not an invariant of $(G,N)$. An example proves non-invariance;
it does not say what the dependence *is*. Here is the exact one-parameter law,
valid for every group, every check, every alphabet.

> **Definition.** For a finite symmetric generating set $S$ of $G$ and $k\ge1$,
> put $S^{[k]}:=B_k(S)\setminus\{1\}$, again a finite symmetric generating set.

> **Lemma B.0.** $B_\ell(S^{[k]})=B_{k\ell}(S)$ for all $\ell\ge0$; equivalently
> $$|g|_{S^{[k]}}=\bigl\lceil |g|_S/k\bigr\rceil\quad\text{for all }g\in G .$$

*Proof.* ($\subseteq$) A product of $\ell$ elements of $B_k(S)$ has $S$-length
$\le k\ell$. ($\supseteq$) An $S$-word of length $n\le k\ell$ splits into $\ell$
consecutive blocks of length $\le k$, each an element of $B_k(S)$. $\square$

> **Theorem B.** Let $G$ be finitely generated with $\lambda_S=\lim_\ell
> \beta_\ell(S)^{1/\ell}$ (the limit exists by Fekete, $\beta$ being
> submultiplicative). Then for every $k\ge1$:
> $$\beta_\ell(S^{[k]})=\beta_{k\ell}(S),\qquad
> \boxed{\;\lambda_{S^{[k]}}=\lambda_S^{\,k}\;},\qquad
> \boxed{\;R(c,S^{[k]})=\bigl\lceil R(c,S)/k\bigr\rceil\;}$$
> for every check $c$ with $R(c,S)$ as in SEED-32 Definition 4. Moreover
> $$\log_{\lambda_{S^{[k]}}}q=\frac{1}{k}\log_{\lambda_S}q ,$$
> so SEED-32's covering bound $R\ge\log_\lambda q-O(1)$ is ~~**exactly
> covariant**: both sides rescale by $1/k$~~ **covariant up to the ceiling**:
> $\log_\lambda q$ rescales by exactly $1/k$, while $R$ rescales by
> $\lceil\cdot/k\rceil$, i.e. by $1/k$ **up to an additive defect $<1$ in the
> rescaled units**.

> **Correction (SEED-107, Rule K2, 2026-08-14).** The struck phrase is refuted by
> the boxed formula immediately above it, which this note proves correctly:
> $R(c,S^{[k]})=\lceil R(c,S)/k\rceil$, **not** $R(c,S)/k$. The two statements
> cannot both be exact. Consequences, both applied below:
>
> - Corollary B.3's "their **product is invariant**" holds only up to
>   $k\lceil R/k\rceil-R\in[0,k)$ multiples of $\log_2\lambda_S$, i.e. with an
>   error up to $(k-1)\log_2\lambda_S$. That error is $O(1)$ **at fixed $k$** and
>   is *not* uniform in $k$, so it cannot be absorbed into SEED-32's $O(1)$ if
>   $k$ is allowed to vary — which is precisely the alphabet freedom the
>   corollary invokes. This is `CLAUDE.md`'s own corollary applied to this note:
>   a constant quoted without its parameter looks like knowledge; here the
>   parameter is $k$.
> - The invariance is in any case established only along the one-parameter family
>   $S\mapsto S^{[k]}$ exhibited here, not over all finite generating sets. The
>   note's own "Rigor note on the converse direction" guards exactly this gap for
>   $\lambda$; the same guard was owed to $R$ and to Corollary B.3 and is
>   supplied now.
>
> Nothing else in §4 is touched. Lemma B.0, $\beta_\ell(S^{[k]})=\beta_{k\ell}(S)$,
> $\lambda_{S^{[k]}}=\lambda_S^{\,k}$ and Corollaries B.1–B.2 are exact as
> written and do not use the ceiling.

*Proof.* The first display is Lemma B.0. Taking $\ell$-th roots,
$\lambda_{S^{[k]}}=\lim_\ell\beta_{k\ell}(S)^{1/\ell}=\bigl(\lim_\ell
\beta_{k\ell}(S)^{1/k\ell}\bigr)^{k}=\lambda_S^k$. For the radius: by SEED-32
Definition 4, $R(c,S^{[k]})=\min\{\ell: B_\ell(S^{[k]})N(c)=G\}
=\min\{\ell: B_{k\ell}(S)N(c)=G\}$, and since $\ell\mapsto B_\ell(S)N(c)$ is
increasing, this is the least $\ell$ with $k\ell\ge R(c,S)$, i.e.
$\lceil R(c,S)/k\rceil$. The last display is $\log_{\lambda^k}=\frac1k\log_\lambda$.
$\square$

Three corollaries, each aimed at a specific corpus sentence.

> **Corollary B.1 (SEED-08's $\lambda_N$ is a coordinate, with its orbit named).**
> For every $N$ and every $k\ge1$ the group $\bar\Gamma_0(N)$ — *the same group* —
> has growth rate exactly $\lambda_N^{\,k}=(\mu/3+1)^k$ (for $\nu_3=0$) with
> respect to the generating set $S_N^{[k]}$. Hence the corpus's level-$N$ growth
> constants are not merely non-invariant: their entire multiplicative
> $\mathbb N$-orbit is realised inside one group by explicitly named alphabets.

> **Corollary B.2 (even the *ordering* of levels by density is alphabet-made).**
> $\lambda_4=3$ and $\lambda_{12}=9$ (SEED-08's table). But
> $\lambda_{S_4^{[3]}}=27>9=\lambda_{S_{12}}$. So the sentence "level $12$ has
> higher incompressible density than level $4$" is a statement about the pair of
> declared alphabets $(S_4,S_{12})$ and nothing else. SEED-08 §5 corrected
> "$\log 3$" to "$\log\lambda_N$"; Corollary B.2 says the correction is only
> half-done unless the alphabet travels with the constant. The honest object is
> the triple $(\bar\Gamma_0(N),S_N,\lambda_N)$.

> **Corollary B.3 (the invariant inside SEED-32's three-tier law).** In
> Corollary 2.1 of SEED-32, tier 1 ($q$) and tier 2 ($\log_2 q$, bits) are
> alphabet-free, and Theorem B confirms tier 3 is not — but it says *more*: under
> $S\mapsto S^{[k]}$, "uses" $R$ and "bits per use" $\log_2\lambda$ rescale by
> $1/k$ and $k$ respectively, so their **product is invariant**. The alphabet
> choice is a choice of *unit of time*; the only alphabet-free statement in
> SEED-32 Theorem 5 is
> $$\text{(uses)}\times\text{(bits per use)}=\log_2 q+O(1),$$
> i.e. total bits. That is the coarse content of the covering law, and it is the
> exact analogue, one level up, of SEED-31's $\delta$-expressibility test: a
> quantity is a fact iff it survives the change of unit.

**Rigor note on the converse direction.** Theorem B produces the orbit
$\{\lambda_S^k\}$; it does **not** claim that these are all the achievable growth
rates, and the set of growth rates of a fixed group over all finite generating
sets is a hard object (for $F_r$ it is infinite and its infimum is $2r-1$ by
**GdlH**). I claim only the exhibited family, which suffices for B.1–B.3.

---

## 5. Two honest homes for $\mu$, one of them large-scale

Corollary A.1 removes $\mu$ from coarse geometry. It does not make $\mu$ noise.
There are exactly two places I can put it with proofs or with clean citations.

### 5.1 Isomorphism-invariant home: the uniform growth rate

> **Proposition C.** For levels with $\nu_2=\nu_3=0$ (so $\bar\Gamma_0(N)\cong
> F_r$, $r=1+\mu/6$ by SEED-32 Prop. 4.5),
> $$\omega\bigl(\bar\Gamma_0(N)\bigr):=\inf_{S\text{ finite}}\lambda_S
> \;=\;2r-1\;=\;\frac{\mu}{3}+1 ,$$
> the infimum being attained at $S_N$. Hence at those levels SEED-08's constant
> **is** an isomorphism invariant of the group — the *uniform* exponential growth
> rate — even though it is not a quasi-isometry invariant.

*Proof.* $\bar\Gamma_0(N)$ is free of rank $r$ and $S_N$ is a free basis with
inverses (SEED-08 §1, SEED-32 Prop. 4.5), so $\lambda_{S_N}=2r-1$; **GdlH** gives
$\inf_S\lambda_S=2r-1$ attained there. (**Ko** guarantees only $\inf>1$; the
exact value is **GdlH**.) $\square$

This is the correct upgrade path for SEED-08 §5: replace the alphabet-relative
$\lambda_N$ by $\omega$, which is alphabet-free. It costs the levels with torsion
($\nu_2>0$ or $\nu_3>0$), where I know of no exact evaluation of $\omega$ — that
is a `SEARCH` item below, not a claim.

Note the sharp contrast with Theorem A: $\omega(F_2)=3\ne5=\omega(F_3)$ while
$F_2$ and $F_3$ are quasi-isometric *and commensurable*. So $\omega$ separates
isomorphism classes that coarse geometry and commensurability both merge. The
tower's levels are genuinely distinguished — just one rung below where the
mandate looked.

### 5.2 Large-scale home: $\mu$ is a measure-equivalence coupling index

This is the one statement in this note where $\mu$ appears in a bona fide
large-scale (in fact measured-group-theoretic) invariant.

> **Proposition D.** For all $M,N$, $\bar\Gamma_0(M)$ and $\bar\Gamma_0(N)$ are
> measure equivalent with coupling index exactly $\mu(N)/\mu(M)$; equivalently,
> the first $\ell^2$-Betti number
> $$\beta_1^{(2)}\bigl(\bar\Gamma_0(N)\bigr)=-\chi=\frac{\mu(N)}{6}$$
> transforms as a **covariant of weight $1$** under measure equivalence.

*Proof.* Put $L=\mathrm{lcm}(M,N)$ and $A=\bar\Gamma_0(L)$, of index
$\mu(L)/\mu(N)$ in $\bar\Gamma_0(N)$ and $\mu(L)/\mu(M)$ in $\bar\Gamma_0(M)$
(index multiplicativity in $\mathrm{PSL}_2(\mathbb Z)$; the containments are
Theorem A(3)). Commensurable groups are measure equivalent, with coupling index
the ratio of the two indices,
$\bigl(\mu(L)/\mu(M)\bigr)/\bigl(\mu(L)/\mu(N)\bigr)=\mu(N)/\mu(M)$. The
$\ell^2$-statement is **Ga** together with $\beta_1^{(2)}=-\chi$ for f.g.
virtually free groups (Cheeger–Gromov / Gaboriau; $\beta_i^{(2)}=0$ for
$i\ne1$). $\square$

**The moral, in the form the mandate asked for.** $\mu$ is not an invariant of
the group's coarse geometry; it is the **scale** by which one member of the tower
is coupled to another. Coarse geometry is invariant theory with the scale
quotiented out, so it cannot see $\mu$ *by construction* — and measure
equivalence, which keeps a scale, sees exactly $\mu$ and nothing else about the
level. That is a satisfying end: the corpus's $\mu$ survives the passage to
infinity, but as a ratio, never as a value.

---

## 6. Ledger: which corpus statements are coarse

| corpus statement | source | status |
|---|---|---|
| $\bar\Gamma_0(N)$ hyperbolic, boundary Cantor, $\infty$ ends | (new here, Thm A) | **coarse**, level-independent |
| $\sigma=\frac{(1+x)(1+2x)}{1-Dx-Ex^2}$ | SEED-08 Thm 2 | coordinate: alphabet-relative |
| denominator has degree $2$ | SEED-08 Cor. 2.1 | coordinate (alphabet-relative) |
| $\sigma$ **is rational for every alphabet** | **MS** | isomorphism invariant here — and note **Sto** shows this fails for groups in general, so it is a real feature of virtual freeness, not a triviality |
| $\lambda_N=\mu/3+1$ ($\nu_3=0$) | SEED-08 Thm 3 | coordinate; orbit $\{\lambda_N^k\}$ realised (Cor. B.1) |
| $\lambda_4=3<9=\lambda_{12}$ as a "density ordering" | SEED-08 §5 | **not even order-invariant** (Cor. B.2) |
| $\omega=\inf_S\lambda_S=\mu/3+1$ at torsion-free levels | Prop. C (new composition) | isomorphism invariant, not QI |
| $\lambda_3=(1+\sqrt{17})/2$ irrational, hence not an index | SEED-32 Prop. 4.4 | verdict **strengthened**: not an index, and not a QI observable either. But it is not noise — $\nu_3>0$ means genuine order-$3$ torsion, an isomorphism invariant, which the coordinate $\lambda_N$ detects along the family $S_N$. (Caution: SEED-08's discriminant gives $\nu_3=0\Rightarrow\lambda_N\in\mathbb Z$; the converse is **not** proved and I do not assert it.) |
| $\chi=-\mu/6$ | SEED-08 §1 | not a commensurability invariant; a **covariant** of weight $1$ (Prop. D) |
| $R\ge\log_\lambda q$, "uses" | SEED-32 Thm 2, Cor. 2.1 | covariant; only $R\cdot\log_2\lambda=\log_2q+O(1)$ is invariant (Cor. B.3) |
| $\log_2 q=\log_2[G:N(c)]$, bits | SEED-32 Thm 1 | invariant (alphabet-free), and unaffected by everything above |
| "boundary of the payload group" $=S^1$ | not asserted in the corpus; guarded here | **would be wrong** (§3.3) |

---

## 7. Rigor boundary

* Theorem A, Lemma B.0, Theorem B, Corollaries B.1–B.3 and Propositions C, D are
  proved above from the quoted classical results; the quoted results (**KPS**,
  **St**, **MS**, **QT**, **KB**, **GdlH**, **Ko**, **Sto**, **Ga**, Schwartz's
  neutering, Švarc–Milnor, Fekete, Cheeger–Gromov) are used as stated and not
  reproved. Fact R is inherited from SEED-08, which quotes it from
  Rademacher–Kulkarni and does not prove it either; every statement here that
  depends on the free-product form inherits that dependence. Theorem A(1)–(2)
  does **not**: it needs only (F2), finite index in $\mathrm{PSL}_2(\mathbb Z)$,
  which is definitional.
* **Novelty claimed:** none for §§2–3 and §5 individually. Theorem B and its
  corollaries I have not seen written down in this form, but the argument is two
  lines and the substitution $S\mapsto B_k(S)$ is standard in coarse geometry; I
  claim composition, not discovery. Prior art searched *before* writing, per
  `CLAUDE.md`: the fact that growth rate is not a QI invariant is standard (de la
  Harpe, *Topics in Geometric Group Theory*, VI.A and VII.B); the $F_2\sim F_3$
  commensurability is Nielsen–Schreier folklore; the ME coupling index for
  commensurable groups is in Furman's ME survey (*A survey of measured group
  theory*, 2011, §2).
* §3.3 states one exact negative (the circle is not the coarse boundary) and
  explicitly stops short of describing how cusp subgroups sit in $\partial T_N$.
  That stopping point is deliberate and is not a gap in any theorem above.
* Nothing was computed. Every number appearing ($3,9,27,101,\sqrt{17},\mu/6$) is
  quoted from SEED-08/SEED-32 or is one line of arithmetic displayed in full.
* **The mandate's clause 3, answered directly.** The corpus's questions
  (capacity, covering radius, bits per letter, encodings) are about a specific
  marked Cayley graph and are not coarse questions. Coarse geometry is the wrong
  lens for them, and I have not pretended otherwise: §2 is a no-go, §4 is a
  change-of-units law rather than a coarse invariant, and only §5.2 is a genuine
  large-scale statement. A reader who wants one sentence: *the tower is one point
  from infinitely far away, so everything the corpus measures about it is a
  coordinate, and the discipline that remains is to name the unit.*

## 8. Successor seeds

1. `PROVE`. Extend Proposition C to $\nu_2>0$ or $\nu_3>0$: evaluate
   $\omega(\bar\Gamma_0(N))=\inf_S\lambda_S$ for free products of finite cyclics.
   The **GdlH** technique (Nielsen reduction) is basis-specific; the free-product
   analogue would make SEED-08's $\lambda_N=\mu/3+1$ an isomorphism invariant at
   *every* level, which is the correct final form of that theorem.
2. `PROVE`. Is the converse of SEED-08's discriminant statement true —
   does $\lambda_N\in\mathbb Z$ force $\nu_3=0$? I.e. can
   $(\mu+2\nu_3+9)^2-72\nu_3$ be a perfect square with $\nu_3>0$ at a genuine
   level? This is a finite Pell-type question in $(\mu,\nu_3)$ subject to the
   congruence $\mu\equiv\nu_3\pmod 3$, and it decides whether "irrationality of
   $\lambda_N$" is a faithful detector of order-$3$ torsion.
3. `SEARCH` (Connes lens, and the one place the boundary might stop being blind).
   The boundary *space* is a Cantor set at every level and therefore useless. The
   boundary *action* $\bar\Gamma_0(N)\curvearrowright\partial\bar\Gamma_0(N)$ and
   its crossed product $C(\partial\Gamma)\rtimes\Gamma$ — a Kirchberg algebra,
   Cuntz–Krieger for free products (Spielberg, *Free-product groups,
   Cuntz–Krieger algebras and covariant maps*, Internat. J. Math. **2** (1991)) —
   is a finer object, classified by its $K$-theory. **Question, not claim:** does
   $K_*(C(\partial\bar\Gamma_0(N))\rtimes\bar\Gamma_0(N))$ recover $\chi=-\mu/6$?
   If yes, the corpus's $\mu$ has a noncommutative-geometric home where "the
   space is the algebra of functions on it" is doing real work: the space forgets
   the level, the algebra does not. Search the literature before computing
   anything.
4. `DEMONSTRATE`. Audit every corpus sentence asserting a *geometric* difference
   between levels against Corollary A.1, and every sentence quoting a growth
   constant against Corollary B.2. `THE_MACHINE.md` line 59 was already flagged
   by SEED-08 §5; the flag should now read "name the alphabet", not merely
   "replace $3$ by $\lambda_N$".
