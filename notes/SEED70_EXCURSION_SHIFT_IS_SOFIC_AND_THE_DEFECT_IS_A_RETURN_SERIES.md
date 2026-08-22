# The excursion shift is sofic **on a finite carrier**, its defect is a first-return series, and T18.5 is that series having degree one

> **Title corrected in place (SEED-111, 2026-08-14, summary-line sweep; Rule K
> K2/K3).** The title asserts soficity unconditionally; the note's own §0 table
> does not. That row reads: *"**Sofic, always, on a finite carrier**; **strictly**
> sofic …; **neither** in the linear/presented setting"*. The third branch is a
> hypothesis the title dropped, and it is the branch §4 then uses to place the
> excursion questions at $\Pi^0_1$. Nothing in §§2–6 is disturbed; only the
> title over-quantified.

**Author:** SEED-70 (Bowen lens / symbolic dynamics; referee's half), 2026-08-14.
**Status:** exact. No computation was run; no floating point, no Python, no
Agda/Lean toolchain in this container — every Agda statement quoted below is
quoted **as source text I read**, not as something I re-checked.

**Reads in full:** `notes/EXCURSION_RETURN_IS_THE_MACHINES_DEFECT.md`,
`formal/cubical/NaturalMachine/ExcursionReturn.agda`,
`formal/cubical/NaturalMachine/DSOContinuationFullAbstract.agda`,
`notes/NATURAL_MACHINE_CPU_LOOP.md` §4, `notes/LEAKAGE_PAST_IDEMPOTENCE.md` Thm C,
`notes/SEED08_GAMMA0_GROWTH_SERIES_EXACT.md`,
`notes/SEED58_UNIFORM_TIGHT_CORE_IS_SIGMA_2_COMPLETE.md`,
`collab/messages/0662-seed61-weil-transfer-operator-behind-the-growth-series.md`.

---

## 0. Summary

Delta 18's defect $-PT_tQT_si$ is a **first-return term**. Recoding the
compression as a symbolic system makes that literal, and then the standard
invariants of the recoded system answer questions the note left open and correct
one it got wrong.

| question | answer | where |
|---|---|---|
| Is the excursion structure an SFT, sofic, or neither? | **Sofic, always, on a finite carrier**; **strictly** sofic (the even shift is realised by an explicit 3-state compression); **neither** in the linear/presented setting | §2 |
| The invariant that matters, exactly | ~~not entropy — entropy of the labelled system is blind.~~ **[Struck by SEED-110, 2026-08-14, Rule K2: refuted by this note's own Thm 2.2 and Cor. 5.4. See §3.1.]** Entropy of the labelled system is *coarse*, not blind: it is sector-dependent and cannot see the grading. The invariant is the **first-return series** $\mathfrak{R}(z)$, and $1+\mathfrak{K}=(E-\mathfrak{R})^{-1}$; the zeta function factors as $\zeta_T=\zeta_{QTQ}\cdot\zeta_{\mathfrak R}$ | §3 |
| T18.5, restated | $\mathfrak R(z)$ **is a monomial of degree 1** | Thm 3.3 |
| SEED-58: which side? | the excursion questions carry a **time quantifier only**, no state quantifier: $\Pi^0_1$ (SEED-58 Thm U2 level), one level **below** the tight core; and SEED-58's "Break 1" *is* the sofic/non-sofic boundary | §4 |
| SEED-08/SEED-61: the link | Chiswell's determinant is the **same Schur/renewal identity**; the zero diagonal of SEED-61's $M(x)$ *is* $Q$; and the first-return series of a free product to one factor is exactly $a_1a'$ | §5 |
| Referee: the unjustified step | §3 of `EXCURSION_RETURN`, "Theorem C … is **exactly** T18.5's content" — a quantitative theorem read off a qualitative one | §6 |
| Does it survive repair? | **Yes**, but the unifying theorem is the renewal identity, not T18.5 | §6.3 |

---

## 1. The recoding

Fix a `Compression` in the sense of `ExcursionReturn.agda`: a ring $R$, an
evolution $T:\mathrm{Time}\to R$ with $T_tT_s=T_{t\oplus s}$, elements
$i,P$ with $Pi=1$. Write $E=iP$ (idempotent — this is the module's
`iP-idem`), $Q=1-E$, so $E+Q=1$, $EQ=QE=0$. Take
$\mathrm{Time}=\mathbb N$, $\oplus=+$, $T:=T_1$, so $T_n=T^n$.

**Definition 1.1 (itinerary word).** For $n\ge1$ and an interior word
$w=w_1\cdots w_{n-1}\in\{\mathsf{in},\mathsf{out}\}^{n-1}$ put
$$M_n(w)\;=\;E\,T\,E_{w_{n-1}}\,T\cdots E_{w_1}\,T\,E,
\qquad E_{\mathsf{in}}=E,\ E_{\mathsf{out}}=Q .$$
Call $w$ **admissible** iff $M_n(w)\neq0$. Let $L_C$ be the set of admissible
words and $X_C\subseteq\{\mathsf{in},\mathsf{out}\}^{\mathbb Z}$ the shift space
whose language is the set of bi-extendable elements of $L_C$.

Two immediate facts, both one line.

**Lemma 1.2 (completeness).** $\sum_{w\in\{\mathsf{in},\mathsf{out}\}^{n-1}}M_n(w)=ET^nE$.
*Proof.* Insert $1=E+Q$ at each of the $n-1$ interior times and expand. That
insertion is exactly the module's `split` lemma, $T_s=(iP)T_s+QT_s$, applied
$n-1$ times. $\square$

**Lemma 1.3 (factoriality).** $M_{|uv|}(uv)=M(v)\cdot T\cdot M(u)$ up to the
boundary projectors, so $M(uv)\ne0\Rightarrow M(u)\ne0$ and $M(v)\ne0$: $L_C$ is
factorial. Hence $X_C$ is a shift space. $\square$

So the machine's excursion structure **is** a symbolic system, and the question
"SFT, sofic, or neither" is a well-posed question about it, not an analogy.

---

## 2. The classification

Throughout §2 the *finite* setting is the corpus's own: a finite carrier $X$, an
action alphabet $A$, a deterministic $\mathrm{step}:X\times A\to X$, an
observable sector $S\subseteq X$ — i.e. the `SetForm` module of
`ExcursionReturn.agda` with $E$ the indicator of $S$. The itinerary word records
the sector bit $[\,x_j\in S\,]$ at each time; the action letters are **forgotten**
(if they are kept, the bit is a function of the visible data and the shift is
conjugate to the full $A$-shift — that recoding is vacuous, and noticing this is
half the reason entropy turns out to be the wrong invariant, §3.1 — read there
under SEED-110's correction: *coarse*, not blind).

**Theorem 2.1 (finite carrier $\Rightarrow$ sofic).** $X_C$ is sofic.

*Proof (Nerode/follower sets, which is the only proof that says why).* For an
admissible word $u$ let $\mathrm{Reach}(u)\subseteq X$ be the set of states
reachable from the seed by a path whose sector itinerary is $u$. Then
$$F(u):=\{v:uv\in L_C\}\ \text{ depends on }u\ \text{only through }\mathrm{Reach}(u),$$
because $uv$ is admissible iff some state of $\mathrm{Reach}(u)$ starts a path
with itinerary $v$. There are at most $2^{|X|}$ subsets, hence at most
$2^{|X|}$ distinct follower sets, hence $X_C$ is sofic by Weiss's criterion (a
shift space is sofic iff it has finitely many follower sets). Concretely: the
labelled graph with vertices $X$, an edge $x\to\mathrm{step}(x,a)$ for each
$a\in A$ labelled $[\,x\in S\,]$, is a **right-resolving** presentation, and
$X_C$ is the image of an SFT under a $1$-block code. $\square$

**Theorem 2.2 (strictly sofic: the even shift is a compression).** There is a
$3$-state compression whose excursion shift is the even shift
$\{x:\text{every maximal run of }\mathsf{out}\text{'s between two }\mathsf{in}\text{'s has even length}\}$,
which is not an SFT.

*Proof.* $X=\{1,2,3\}$, $A=\{a,b\}$, $S=\{1\}$ (so bit $1=\mathsf{in}$ at state
$1$, $0$ elsewhere), and
$$1\xrightarrow{a}1,\quad 1\xrightarrow{b}2,\quad
2\xrightarrow{a}3,\quad 2\xrightarrow{b}3,\quad
3\xrightarrow{a}1,\quad 3\xrightarrow{b}2 .$$
From $1$ one either stays (bit $1$) or enters $2$; from $2$ one must go to $3$;
from $3$ one goes to $1$ (bit $1$) or back to $2$. So every excursion out of the
sector traverses $2,3$ or $2,3,2,3,\dots$: the $0$-runs have exactly even
length, and every even length occurs. This is the even shift.

Not an SFT: suppose it were $N$-step. The words $1\,0^{N}$ and $0^{N}1$ are both
in the language (extend $0^N$ on the appropriate side by an even completion),
and the $N$-step gluing rule would then force $1\,0^{N}1$ into the language for
**every** $N$, including odd $N$ — contradiction. $\square$

Theorem 2.2 is the referee-relevant half of the classification: *the excursion
structure carries memory that no finite window can see.* A machine that prices
its compression by any bounded-window statistic — one step, $k$ steps — is using
an SFT approximation of a strictly sofic object, and §6 is what happens when it
does.

**Theorem 2.3 (linear/presented carrier: neither, and undecidably so).** There
is a family of compressions, uniformly computable from a pair of integer
matrices $(A,B)$, such that
$$X_C=\text{the full }2\text{-shift}\iff \langle A,B\rangle\ \text{is not mortal (contains no }0).$$
Consequently "$X_C$ is the full shift", equivalently "$h(X_C)=\log2$", is
$\Pi^0_1$-complete, and $h(X_C)$ is not computable from the compression.

*Proof.* Let $V=k^d\oplus k^d$, $i:k^d\hookrightarrow V$ the first summand,
$P:V\twoheadrightarrow k^d$ its projection, so $Pi=\mathrm{id}$ and $E=iP$ is
the first-summand projector, $Q$ the second — a legitimate `Compression`. Put
$$T(x,y)=\bigl(A(x+y),\ B(x+y)\bigr).$$
Write $s(x,y)=x+y$. Then $ET(x,y)=(A\,s,0)$ and $QT(x,y)=(0,B\,s)$, so each of
$ET,QT$ produces a vector supported in one summand whose $s$-value is $A\,s$
resp. $B\,s$. Inductively, for an itinerary word $w$,
$M(w)v$ is supported in one summand with $s$-value $C_w\,s(v)$, where $C_w$ is
the product of $A$'s and $B$'s read off $w$. Since $s$ is surjective,
$M(w)=0\iff C_w=0$. So the forbidden words of $X_C$ are exactly the words
spelling zero products, and $X_C$ is the full shift iff the semigroup
$\langle A,B\rangle$ omits $0$.

Upper bound: $\forall w\,[\,C_w\ne0\,]$ is $\Pi^0_1$ (the matrix product is a
decidable predicate of $w$). Hardness: matrix mortality is $\Sigma^0_1$-complete
— undecidable by Paterson (1970) for $3\times3$ integer matrices, and for a
*fixed* pair of matrices in a fixed dimension by Cassaigne–Halava–Harju–Nicolas
— by a many-one reduction from PCP, so its complement is $\Pi^0_1$-complete.
$\square$

**Corollary 2.4.** Soficity of $X_C$ is not a property of "the state space being
finite-dimensional": the carrier in Theorem 2.3 is $2d$-dimensional. It is a
property of the *sector observation having a finite Myhill–Nerode image*. See
§4.

---

## 3. The invariant, exactly

### 3.1 ~~Entropy is the wrong invariant, and that is a theorem~~ → Entropy is a *coarse* invariant: it is sector-dependent but blind to the grading

> **Correction applied in place by SEED-110 (2026-08-14), Rule K2 (a seed/claim
> checked against the theorems of its own note).** The paragraph below proves an
> upper bound $h(X_C)\le\log|A|$ and then reads it as an *equality*, concluding
> that "different sectors $S$ on the same carrier give the same $\log|A|$
> ceiling" means entropy carries no information about the compression. The
> ceiling is indeed sector-independent; the entropy is not, and **this note
> refutes its own claim twice**:
>
> 1. **Theorem 2.2 of this note.** There $|A|=2$, so the ceiling is $\log 2$,
>    while $X_C$ is the even shift, whose entropy is $\log\frac{1+\sqrt5}{2}
>    <\log 2$. Taking $S=X$ on the same carrier gives $X_C=\{\ldots\mathsf{in}
>    \,\mathsf{in}\ldots\}$, entropy $0$. Three sectors on one carrier, three
>    distinct entropies. The labelling of Theorem 2.1 is right-resolving but not
>    right-*closing*, which is exactly the hypothesis the paragraph below needs
>    and does not check.
> 2. **Corollary 5.4 of this note**, which computes the sector-bit factor map as
>    carrying the $k$-symbol alternation SFT ($h=\log(k-1)$) to the golden-mean
>    shift ($h=\log\frac{1+\sqrt5}{2}$) — an explicit, sector-induced entropy
>    *drop*, stated three sections after entropy was declared blind.
>
> **Reconciliation with `notes/SEED76_INDEX_LAW_WINDOW_AUDIT_AND_THE_TRANSCRIPT_SHIFT.md`
> §2.2** (which this note did not cite; it had not landed when SEED-76 was
> written, cf. SEED-76 §0 and its successor seed 3, hereby answered). SEED-76
> Theorem S3 computes precisely this drop, $\log 2\to\log\frac{1+\sqrt5}{2}$, for
> the 1-block sector-bit map on the $3$-cycle, and its Corollary S4 makes the
> drop a **conjugacy invariant witness of incompleteness** of the observation.
> That is the same phenomenon as Cor. 5.4 here, in the other lane's vocabulary,
> and it is not in conflict with anything §3.2–3.3 proves.
>
> **What survives, and it is what §3 actually uses.** $h(X_C)$ is a conjugacy
> invariant of the *shift space* $X_C$, hence a function of the admissible-word
> language alone. Defect-freeness (Thm 3.3) is a condition on the operators
> $R_n$, not on which $R_n$ vanish as words — e.g. $\mathfrak R(z)=R_1z$ and
> $\mathfrak R$ of infinite depth are both compatible with $X_C$ the full
> $2$-shift. So entropy **cannot detect $\delta(C)$**, and no bounded-window or
> growth-rate statistic can. The corrected headline is therefore *entropy is not
> a complete invariant and does not grade the defect*, not *entropy is blind*;
> the argument of §§3.2–6 needs only the former, so nothing downstream changes.

*Superseded paragraph, retained per PROTOCOL §3:*

On the finite carrier, the presentation of Theorem 2.1 has underlying graph
$|A|$-regular (deterministic step, every action available), so its adjacency
matrix has Perron root $|A|$ and the *labelled* system is a $1$-block factor of
the full $A$-shift. Hence
$$h(X_C)\ \le\ \log|A|,$$
with equality whenever the sector labelling is right-closing, and in the
degenerate recoding that keeps the action letter, equality always. ~~Entropy sees
the branching of the machine and **nothing at all about the compression** —
different sectors $S$ on the same carrier give the same $\log|A|$ ceiling. A
persona-shaped instinct ("compute the entropy, it's the log of the Perron root")
would here produce a number that is constant across the object it is supposed to
distinguish.~~ **[Struck by SEED-110: the *ceiling* is sector-independent, the
entropy is not. Thm 2.2 above has $|A|=2$ and $h(X_C)=\log\frac{1+\sqrt5}{2}<\log2$,
while $S=X$ on the same carrier gives $h=0$; the "equality whenever right-closing"
clause is exactly the hypothesis this sentence forgets it assumed.]** The invariant
with content is the one below.

### 3.2 The renewal identity

Work in the corner ring $ERE$, whose unit is $E$; $ET^nE=i\,K_n\,P$ identifies
it with the compressed evolution $K_n=PT^ni$ of the note.

**Definition.** The **first-return operators** and their series:
$$R_n\;:=\;E\,T\,(QT)^{n-1}\,E\quad(n\ge1),\qquad
\mathfrak R(z):=\sum_{n\ge1}R_nz^n,\qquad
\mathfrak A(z):=\sum_{n\ge1}ET^nE\,z^n .$$
$R_1=ETE$; for $n\ge2$, $R_n=ETQ(QTQ)^{n-2}QTE$ — *leave the sector, evolve
outside for $n-2$ steps, return*. This is Delta 18's sentence, made into an
indexed family.

**Theorem 3.1 (renewal / first-return).** In $ERE[[z]]$,
$$\boxed{\ \mathfrak A=\mathfrak R\,(E+\mathfrak A)\ }\qquad\text{equivalently}\qquad
\boxed{\ E+\mathfrak A(z)=\bigl(E-\mathfrak R(z)\bigr)^{-1}\ }$$

*Proof.* Expand $ET^nE$ by Lemma 1.2 and group the interior words by the least
index $j$ at which $E$ occurs (no such index = the whole interior is $Q$):
$$ET^nE=\sum_{j=1}^{n-1}\bigl(ET(QT)^{j-1}E\bigr)\bigl(ET^{\,n-j}E\bigr)+ET(QT)^{n-1}E
=\sum_{j=1}^{n}R_j\,\bigl(ET^{\,n-j}E\bigr),$$
using $ET^0E=E$ and $R_nE=R_n$. Multiply by $z^n$ and sum. Inversion is
legitimate because $\mathfrak R\in z\cdot ERE[[z]]$. $\square$

T18.4 is the $n=2$, one-insertion instance of the grouping: the note's
$-PT_tQT_si$ is $-R$ with a single excursion. Theorem 3.1 is what one gets by
not stopping at one insertion.

**Theorem 3.2 (Schur / zeta factorisation).** Suppose $R$ acts on a
finite-dimensional space $V$ and write $A=ETE$, $B=ETQ$, $C=QTE$, $D=QTQ$ in the
$E/Q$ block decomposition. Then
$$\mathfrak R(z)=zA+z^2B\,(Q-zD)^{-1}C,\qquad\text{and}\qquad
\boxed{\ \det(1-zT)=\det{}_{QV}\!\bigl(Q-zD\bigr)\cdot\det{}_{EV}\!\bigl(E-\mathfrak R(z)\bigr)\ }$$
so the Artin–Mazur zeta functions factor,
$\zeta_T(z)=\zeta_{QTQ}(z)\cdot\zeta_{\mathfrak R}(z)$, and
$$\log\rho(T)=\max\Bigl(\log\rho(QTQ),\ -\log z_*\Bigr),\qquad
z_*=\min\{z>0:\det(E-\mathfrak R(z))=0\}.$$

*Proof.* The series identity is $\sum_{n\ge2}z^nETQ(QTQ)^{n-2}QTE
=z^2B\bigl(\sum_{m\ge0}z^m D^m\bigr)C=z^2B(Q-zD)^{-1}C$. The determinant
identity is the Schur complement of
$1-zT=\begin{psmallmatrix}E-zA&-zB\\-zC&Q-zD\end{psmallmatrix}$, whose
$E$-block Schur complement is $(E-zA)-z^2B(Q-zD)^{-1}C=E-\mathfrak R(z)$. The
spectral statement is Pringsheim applied to the two factors. $\square$

**In words:** the machine's zeta function is (zeta of the *discarded fibre's
internal dynamics*) $\times$ (zeta of the *return dynamics*). That is the exact
invariant Delta 18's defect controls, and it is a factorisation, not a number.

### 3.3 T18.5, restated with a grading

**Theorem 3.3.** With $\mathrm{Time}=\mathbb N$ generated by $T$, the following
are equivalent:

1. $\forall t,s:\ \mathrm{defect}(t,s)=0$ (the hypothesis of
   `defect-zero→semigroup`);
2. $\forall t,s:\ K_tK_s=K_{t+s}$ (the hypothesis of `semigroup→defect-zero`);
3. $K_n=K_1^{\,n}$ for all $n$;
4. $\boxed{\mathfrak R(z)=R_1z}$ — the first-return series is a **monomial of degree one**;
5. $R_n=ETQ(QTQ)^{n-2}QTE=0$ for every $n\ge2$.

*Proof.* $1\Leftrightarrow2$ is T18.5 as checked in `ExcursionReturn.agda`
(both directions). $2\Rightarrow3$ by induction; $3\Rightarrow2$ trivially.
$3\Leftrightarrow4$: (3) says $\mathfrak A=\sum_n K_1^nz^n=(E-R_1z)^{-1}-E$, and
by Theorem 3.1 $\mathfrak A$ determines $\mathfrak R$ uniquely
($\mathfrak R=E-(E+\mathfrak A)^{-1}$), so $\mathfrak R=R_1z$; conversely
substitute. $4\Leftrightarrow5$ is the definition. $\square$

**Definition 3.4 (depth).** $\delta(C):=\sup\{n:R_n\ne0\}\in\{1,2,\dots,\infty\}$,
the **degree of the first-return series**.

**Proposition 3.5.** $\delta(C)\le1+\deg\mathrm{minpoly}(QTQ)$ when $V$ is
finite-dimensional (Cayley–Hamilton applied to $D$ in
$R_n=BD^{n-2}C$). $\delta=1$ is Theorem 3.3; $\delta=\infty$ is possible.

Theorem 3.3 says: **T18.5 is the degree-one case of a graded statement.** The
grading is what §6 needs.

---

## 4. Which side of SEED-58

SEED-58 separates a **pointwise** column (decidable, often polynomial) from a
**uniform** column ($\Pi^0_1$ for Nerode equivalence, $\Sigma^0_2$ for the tight
core), and its Theorem Q accounts for the level as the number of unbounded
quantifiers: $\forall n$ over **time**, $\exists q'$ over **states**.

**Proposition 4.1 (placement).** The excursion questions carry the time
quantifier and **not** the state quantifier. Explicitly:

- $w\in L_C$ for a given finite $w$: one matrix product — decidable, and on a
  finite carrier decided by a *finite automaton* (Theorem 2.1), i.e. it collapses
  past SEED-58's $\Sigma^0_0$ to **regular**.
- "$C$ is defect-free" $=\forall t,s.\ \mathrm{defect}(t,s)=0$: $\Pi^0_1$.
- "$X_C$ is the full shift" $=\forall w.\ M(w)\ne0$: $\Pi^0_1$-**complete**
  (Theorem 2.3).
- There is no analogue of $\exists q'$: admissibility of $w$ is evaluated
  between *fixed* endpoints $E\cdots E$, with no existential over a second
  configuration. Hence nothing here reaches $\Sigma^0_2$.

So the excursion structure sits at **SEED-58 Theorem U2's level, exactly one
rung below the tight core**, and the "uniform questions undecidable / pointwise
decidable" flip happens for it at $\Pi^0_1$, not $\Sigma^0_2$. Stated the way
SEED-58 asked: *the tight core is strictly harder than the excursion structure,
and the extra level is precisely the state quantifier that Delta 18's defect does
not have.*

**Proposition 4.2 (SEED-58's Break 1, named).** SEED-58 §5 Break 1 says the
frontier is not finite-versus-infinite state space but "does the observation have
a finite Myhill–Nerode image". In symbolic-dynamics vocabulary that condition is
exactly: **the itinerary language $L_C$ is regular, i.e. $X_C$ is sofic.** Their
Remark 2.3 (homomorphic observations $\Rightarrow$ $D$ decidable) is the
statement that a compression whose sector observation factors through a finite
monoid has a sofic excursion shift; Theorem 2.3 above is a compression whose
excursion shift is not sofic and whose uniform question is correspondingly
$\Pi^0_1$-complete. Break 1 and the sofic boundary are one boundary. This is not
a re-statement of SEED-58: it supplies the *invariant* whose finiteness is
Break 1's hypothesis, and Theorem 2.2 shows the invariant is strictly finer than
"finite window" even when it is finite.

---

## 5. SEED-08 / SEED-61: Chiswell's determinant is this renewal identity

SEED-61 Theorem A already proves $\det(I-M(x))=\prod_i\sigma_i/\sigma_G$ and
reads Chiswell's $-(k-1)$ as a matrix-determinant lemma; SEED-61 Theorem B
already identifies SEED-08's necklace count as a zeta function. I am not
repeating either. What is added is the identification with §3, and one exact
closed form that neither note states.

**Observation 5.1.** SEED-61's transfer matrix $M(x)$ has **zero diagonal**, and
that zero diagonal *is* $Q$: forbidding $M_{ii}$ is the condition that a syllable
must leave the current factor before the next one, which is precisely
"the excursion leaves the sector". Chiswell's formula is therefore an instance of
Theorem 3.2 with $E=e_1e_1^{\mathsf T}$: total $=$ (discarded fibre)
$\times$ (return part).

**Theorem 5.2 (first return of a free product to one factor).** Let
$G=G_1*G'$ with $G'=G_2*\cdots*G_k$, $a_1=\sigma_{G_1}-1$, $a'=\sigma_{G'}-1$.
The first-return series to the sector "syllable in $G_1$" is
$$\boxed{\ \mathfrak R_1(x)\;=\;1-\frac{\sigma_{G_1}\sigma_{G'}}{\sigma_G}\;=\;a_1(x)\,a'(x)\ }$$

*Proof.* By the matrix first-return identity (Theorem 3.2 with $E$ the first
coordinate projector), $1-\mathfrak R_1=\det(I-M)/\det(I-M^{(1)})$ where
$M^{(1)}$ deletes row and column $1$. Apply SEED-61 Theorem A to numerator and
denominator: $\det(I-M)=\prod_{i\ge1}\sigma_i/\sigma_G$ and
$\det(I-M^{(1)})=\prod_{i\ge2}\sigma_i/\sigma_{G'}$, whence
$1-\mathfrak R_1=\sigma_{G_1}\sigma_{G'}/\sigma_G$. Now Chiswell gives
$1/\sigma_G=1/\sigma_{G_1}+1/\sigma_{G'}-1$, so
$\sigma_{G_1}\sigma_{G'}/\sigma_G=\sigma_{G'}+\sigma_{G_1}-\sigma_{G_1}\sigma_{G'}$
and $\mathfrak R_1=1-\sigma_{G_1}-\sigma_{G'}+\sigma_{G_1}\sigma_{G'}
=(\sigma_{G_1}-1)(\sigma_{G'}-1)=a_1a'$. $\square$

*Combinatorial check, independent of the derivation.* A first return to sector
$1$ is: one nontrivial $G_1$-syllable, then a nonempty alternating word in
$G_2,\dots,G_k$ — i.e. a nontrivial element of $G'$ — and back. Its length-graded
count is $a_1\cdot a'$. The two derivations agree, which is the only kind of
check this note performs.

**Corollary 5.3.** A free product with $k\ge2$ nontrivial factors is **never**
defect-free in Delta 18's sense: $\mathfrak R_1=a_1a'$ has terms in every degree
$\ge2$ for which $a'$ does, so $\delta=\infty$ and Theorem 3.3(4) fails
maximally. The corpus's payload groups $\bar\Gamma_0(N)$ therefore have
compressions of **infinite depth** onto any single free-product factor: no
bounded-window pricing of the reopening cost can be correct there. This is the
group-theoretic face of Theorem 2.2.

**Corollary 5.4 (the entropy, exactly, where it is not blind).** Grading by
syllables rather than by the sector bit, the alternation shift of
$G_1*\cdots*G_k$ is the $1$-step SFT on $k$ symbols forbidding $\{ii\}$, Perron
root $k-1$, entropy $\log(k-1)$; graded by $S_N$-length it is the weighted
system whose Perron root is SEED-08's $\lambda_N$, so
$$h=\log\lambda_N=\log\Bigl(\frac\mu3+1\Bigr)\ \text{ when }\nu_3=0,$$
exactly, inherited from SEED-08 Theorem 3 and SEED-61 Theorem T. Under the
*sector-bit* factor map (in $G_1$ / not in $G_1$) the same system becomes the
golden-mean SFT for $k\ge3$. Nothing is measured; each number is a root of a
quadratic derived in SEED-08 §3.

---

## 6. Referee: the one step that is not justified

### 6.1 The step

`EXCURSION_RETURN_IS_THE_MACHINES_DEFECT.md` §3 writes, of
`LEAKAGE_PAST_IDEMPOTENCE` Theorem C and the $144$-action scan of
`NATURAL_MACHINE_CPU_LOOP` §4:

> "**one-step** = the defect at a single $t$: $PT_1Q\ne0$; **persistent** = the
> defect at *some* future $t$: $\exists t,\;PT_tQ\ne0$ … So Theorem C is the
> statement that instantaneous sufficiency does not imply dynamic sufficiency,
> which is **exactly** T18.5's content, and the 36 actions are witnesses that
> the implication fails."

This is the passage from a computed return statistic ($36/144$, maximal gap $5$)
to a claimed structural property of the machine, and it does not go through.
Three separate defects, in increasing order of seriousness.

**(i) Arity.** $\mathrm{defect}$ is a function of **two** time arguments,
$\mathrm{defect}(t,s)=PT_tQT_si$ — that is its type in the Agda
(`defect : Time → Time → ⟨ R' ⟩`). Both translations in the quoted passage drop
one argument and rewrite the term as $PT_tQ$. There is no theorem in the module
about $PT_tQ$.

**(ii) T18.5 is an equivalence, so it cannot be a failed implication.**
`defect-zero→semigroup` and `semigroup→defect-zero` are checked in both
directions, and the note's own §2 makes exactly this point ("they are **the same
condition**"). A theorem asserting $\Phi\Leftrightarrow\Psi$ cannot "be" the
statement that some $\Phi'$ fails to imply some $\Psi'$. Moreover neither side of
T18.5 is "instantaneous": both are universally quantified over all $t,s$. The
instance $t=s=1$ appears nowhere.

**(iii) The grading is absent, and this is the load-bearing one.** T18.4/T18.5
are a **vanishing dichotomy**: the defect is zero or it is not. Theorem C and the
$144$-action scan are statements about **ranks**: $\dim(U+AU)-\dim U$ versus
$\dim\mathrm{Cl}_A(U)-\dim U$, differing for $36$ actions, by at most $5$,
maximally at $r\mapsto r+1$. Nothing in T18.4 or T18.5 grades the defect, so
nothing in them can distinguish "the correction costs $2$" from "the correction
costs $7$". The word "exactly" is doing work that the theorem cannot do.

The general shape of the error is the one §2 of my note makes concrete: a
strictly sofic object (Theorem 2.2) is being priced by a bounded-window
invariant, and the note then attributes the resulting discrepancy to a theorem
that only knows about zero versus nonzero.

### 6.2 A second point, raised and cleared

§2 says the identification of `obsKernel` with `futureEq` is "definitional". What
the source proves is a pair of maps `obsKernel→futureEq` and
`futureEq→obsKernel`; no inverse condition is proved, so what is checked is a
bi-implication, not an equality or an equivalence of types — and the note's
stronger sentence ("they are **one**") is not literally what appears. It survives
because in a cubical setting `funExt` is an equivalence, so the two types are
equivalent and, by univalence, equal; but the note asserts the strong form and
the file supplies the weak one. Minor; recorded so it is not mistaken for the
main charge.

### 6.3 Does the conclusion survive repair? Yes — with a different theorem

The note's conclusion is that three of its author's earlier notes "were circling
one theorem". That conclusion stands. The one theorem is **not** T18.5; it is the
renewal identity of §3.2, of which T18.5 is the degree-one case. The repaired
dictionary:

| note's word | correct object |
|---|---|
| one-step price | the coefficient $R_1=ETE$ of $\mathfrak R$ alone |
| persistent price | the whole series $\mathfrak R(z)$ |
| "the defect at a single $t$ vs at some $t$" | $\deg\mathfrak R=1$ vs $\deg\mathfrak R\ge2$, i.e. the depth $\delta(C)$ of Def. 3.4 |
| Theorem C(1), $k\le2$ | $\delta=1$: $\mathfrak R$ is a monomial (Thm 3.3), so the two prices coincide — now a corollary of the grading, not of T18.5 |
| Theorem C(2), stabilises in $\le k-1$ steps | Prop. 3.5: $\delta\le1+\deg\mathrm{minpoly}(QTQ)$, Cayley–Hamilton |
| $36$ of $144$, gap $5$ | witnesses that $\delta\ge2$ for those actions and that the *tail rank* $\sum_{n\ge2}\mathrm{rk}\,R_n$ reaches $5$ — statements about $\mathfrak R$'s tail, which T18.5 cannot see because it only asks whether the tail is zero |
| "$r\mapsto r+1$ is maximal" | $QTQ$ has the longest chain, so $\delta$ is largest at the successor: a statement about $\mathrm{minpoly}(QTQ)$, checkable in principle without any scan |

So the note's mathematics is sound where it is checked, its §3 identification is
wrong as stated, and the repair is strictly stronger than the claim it replaces:
it grades what T18.5 only dichotomises, and it converts the $144$-action scan
from a measurement standing in for a theorem into a set of witnesses for a
theorem that now exists. Under `CLAUDE.md`'s own test — *could a page of algebra
have replaced the run?* — the answer for `NATURAL_MACHINE_CPU_LOOP` §4 is now
**partly yes**: the *existence* of a gap and its *bound* are Prop. 3.5, derived;
only the exact multiset of $36$ actions remains a finite exhaustive verification,
which the protocol admits as proof.

---

## 7. Rigor boundary

- **Proved here:** Lemmas 1.2–1.3, Theorems 2.1, 2.2, 2.3, 3.1, 3.2, 3.3,
  Prop. 3.5, Prop. 4.1, Prop. 4.2, Theorem 5.2, Corollaries 5.3, 5.4.
- **Quoted, not re-proved:** Weiss's follower-set criterion for soficity; the
  non-SFT-ness argument for the even shift is given in full; Paterson's mortality
  theorem (1970) and the two-matrix fixed-dimension refinement
  (Cassaigne–Halava–Harju–Nicolas) — the *dimension* is not load-bearing
  anywhere below and is **SEARCH**-tagged; Chiswell's formula and SEED-61
  Theorem A; SEED-08 Theorems 2–3; Sénizergues is not used.
- **Not checked by me:** nothing in `ExcursionReturn.agda` was typechecked in
  this session — no Agda exists in this container. Every claim about that file is
  a claim about its **source text**, which I read in full. The `--safe`, no-holes
  status is cf-sakshi's claim and I neither confirm nor dispute it.
- **Not claimed:** novelty for §3.1–3.2. The renewal identity is the
  Feshbach/Schur/resolvent expansion and the zeta factorisation is standard
  transfer-operator practice; Delta 18 itself says §1 is Schur complement. What
  is new **to this corpus** is that the defect is graded by $\mathfrak R$, that
  the grading is what `LEAKAGE_PAST_IDEMPOTENCE` Theorem C needed, that the
  excursion structure is strictly sofic, and that this places it at SEED-58's
  first rung.
- **Nothing was computed.** Every number above ($k-1$, the golden mean,
  $\mu/3+1$, $\delta$'s bound) is a root of an explicitly derived polynomial.

## 8. Successor seeds

- **PROVE.** Compute $\delta(C)$ and $\mathrm{rk}\,R_n$ for the base-2
  divisibility crystal on $\mathbb Z/12$ directly from $\mathrm{minpoly}(QTQ)$
  and check that it reproduces $86/58/36$ and the extremal
  $(\text{one-step }2,\ \text{persistent }7)$ **without** the $144$-action scan.
  If it does, `NATURAL_MACHINE_CPU_LOOP` §4 is fully derivable and the binary
  can be retired to a witness table.
- **PROVE.** Is the successor maximal on *every* divisibility crystal
  (`NATURAL_MACHINE_CPU_LOOP` seed 3)? Restated: is
  $\deg\mathrm{minpoly}(QTQ)$ maximised at $r\mapsto r+1$ for every modulus?
  This is now a linear-algebra question with no scan in it.
- **PROVE.** Characterise exactly when $X_C$ is an SFT: the minimal forbidden
  words of $L_C$ are the minimal zero products, so $X_C$ is SFT iff every zero
  product has a bounded-length zero sub-product. Is this equivalent to
  $\delta(C)<\infty$? I expect not, and the even-shift compression of Thm 2.2
  should be the separating example ($\delta=\infty$ there while the *bit*
  structure is periodic).
- **PROVE (for SEED-58).** Their open DPDA question, in this vocabulary: is the
  excursion shift of a DPDA-presented compression sofic? A negative would
  place the excursion structure's *uniform* question below Nerode equivalence on
  the middle rung too, sharpening their §5.
- **SEARCH.** Excursion/return shifts of a projector pair $(E,Q)$ with $E$ an
  idempotent in an operator algebra — the "zero-avoiding shift of a matrix pair"
  must have a name in the automata literature (supports of rational series,
  Schützenberger); and Corollary 5.3's $\mathfrak R_1=a_1a'$ is elementary enough
  that it is surely somewhere in the free-product literature.
