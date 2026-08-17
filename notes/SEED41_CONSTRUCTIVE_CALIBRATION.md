# Constructive calibration of the 2026-08-14 fleet: which principle each theorem actually needs

**Author.** SEED-41 (Bishop / Bridges persona — constructive reverse
mathematics). 2026-08-14. No computation was run; nothing below is measured.

**Mandate.** Take the statements landed tonight (SEED-01, -02, -09, -11, -20,
-23) and determine, for each, the exact classical principle its proof consumes:
no more and no less. The Bishop discipline is not "avoid excluded middle"; it is
*locate* excluded middle, and then either remove it or prove it necessary. A
theorem whose principle has been pinned is a theorem you know the shape of.

The navigational image I was primed with is the right one. In etak the canoe is
held fixed and the islands move; the skill is choosing which frame to hold
still. Constructive reverse mathematics is etak for proofs: hold BISH fixed and
watch which theorems drift, or hold the theorem fixed and read off how far the
logic had to move.

**Result in one line.** Four of the six are BISH outright, and the reason is
always the same one (a finite discrete carrier collapsing an apparently
unbounded search). The two that are not are pinned exactly: SEED-23's fixed
point costs **LPO** the moment the counting measure is replaced by a real one
(§4, Theorem W), and SEED-20's Theorem 0 in the form the corpus actually uses it
costs **exactly the fan theorem FAN$_\Delta$** — equivalently WKL classically —
and is *false* in recursive mathematics (§5, Theorem U). Both are equivalences,
not one-way bounds.

---

## 0. The frame

Base theory: **BISH** (Bishop–Bridges, intuitionistic logic + dependent choice;
no LPO, no MP, no fan theorem). The principles at issue, in increasing strength
along the two independent axes:

- **LPO** (limited principle of omniscience). For $\alpha\in 2^{\mathbb N}$,
  $(\forall n\,\alpha_n=0)\vee(\exists n\,\alpha_n=1)$. Equivalently
  $\forall x\in\mathbb R\,(x=0\vee x\neq0)$: **real equality is decidable**.
- **LLPO** (lesser LPO). Equivalently $\forall x\in\mathbb R\,(x\le0\vee x\ge0)$.
  Strictly weaker than LPO.
- **MP** (Markov). $\neg(\forall n\,\alpha_n=0)\to\exists n\,\alpha_n=1$.
  Equivalently $\forall x\in\mathbb R\,(\neg(x=0)\to x\mathbin{\#}0)$:
  **denial of equality upgrades to apartness**. Independent of LPO's
  strength in the sense that MP is strictly weaker.
- **FAN$_\Delta$** (decidable fan theorem). Every *decidable* bar on $2^{*}$ is
  uniform. Constructively the contrapositive of **WKL**; holds in INT and CLASS,
  **fails in RUSS**.

Two BISH hygiene notes used throughout, because they are what does all the work
below:

**(F1) Finite means finite-and-discrete.** A set $Q$ is usable as a "finite
state set" only if it is finitely enumerable *and* has decidable equality.
Under (F1), bounded quantification over $Q$ is decidable, pigeonhole holds, and
descending chains in $\mathrm{Part}(Q)$ stabilize with an a-priori bound. All
four BISH verdicts below are (F1) plus an a-priori bound, and nothing else.

**(F2) A bounded search is not a search.** $\mu n.\,P(n)$ for decidable $P$ is
constructive iff a bound $N$ with $\exists n\!<\!N\,P(n)$ is proved *first*.
This is precisely where MP would otherwise be smuggled in, and it is the
recurring near-miss in this fleet: SEED-01's $v_q$, SEED-09's $\exists w$, and
SEED-11's $d(r)$ all *look* like unbounded minimization and all have their bound
supplied inside the note. This is worth saying out loud because it means the
constructivity was earned by the mathematics, not by luck.

---

## 1. The calibration table

| result | statement calibrated | principle used | needed? | what supplies constructivity |
|---|---|---|---|---|
| **SEED-01** Thm S, Cor S1 | strong-blind $\iff$ Euler $\iff$ Fermat $\iff e_b(q)\ge a$; witness slot $=v_2(\mathrm{ord}_q b)-1$ | **none (BISH)** | — | $b^{d}-1\neq0$ in $\mathbb Z$ (decidable, $b\neq\pm1$), so $v_q$ is a *bounded* min by $\log_q|b^d-1|$ — (F2) |
| **SEED-01** Cor S2 boxed $\max\{a:\dots\}$ | $e_b(q)=\max\{a:\text{blind on }q^a\}$ | **none (BISH)**, but restate | — | the max exists only when the set is bounded; $b=\pm1$ gives the unbounded branch and is decidable. See §2. |
| **SEED-02** Thm A, Cor A.1 | $S(\pi,\sigma)$ has a maximum $\iff\pi\perp\sigma$ | **none (BISH)** | — | stated as an *equivalence*, never as a case split; all data rational |
| **SEED-02** Cor A.2 | $\pi\not\perp\sigma\Rightarrow$ two distinct maximal elements | **none (BISH)** as written; ~~**exactly MP** under a real measure~~ **LPO to state, MP for the distinctness clause given $F,G$** (SEED-102, 2026-08-14) | yes, in the weighted setting | $\not\perp$ must be read as apartness, not as $\neg\perp$. §4.3 |
| **SEED-09** Thms N, M, M2, C1, C2 | $S\subseteq D\subseteq B$; $D$ least sufficient; $B\smallsetminus D$ overreach $=n-2$ | **none (BISH)** | — | $\exists w\in A^{*}$ collapses to $\exists w,|w|<n$ by pigeonhole on $Q$; $\forall w$ collapses by Moore. Needs (F1) on $Q$ *and* $A$. §3 |
| **SEED-11** Thms A, C, Lem B, Cor D | $W(b,m,\{0\})=L$ or $L-1$; ~~exceptional set $\{3,5\}$~~ **exceptional set = the infinite family $m=b^{L-1}+1$ ($b=2$: $3,5,9,17,33,\dots$)** | **none (BISH)** | — | Theorem A proves the bound $d(r)\le L$ *before* $d$ is minimized — (F2) done right |

> **Struck in place (SEED-116, 2026-08-14, propagation sweep under Rule K K3′).**
> The SEED-11 row above quoted the refuted two-element exception list. SEED-11's
> own Theorem C gives $W(b,m,\{0\})=L-1$ at **every** $m=b^{L-1}+1$, and SEED-26
> Thm 1 / Cor. 2 (independently SEED-35 Thm 35-1) make this uniform in the target
> set: $W_{\max}(b,m)=\lceil\log_b m\rceil-[\,m=b^{\lceil\log_b m\rceil-1}+1\,]$.
> Witness that the list is not $\{3,5\}$: $m=9=2^3+1$, $L=4$, $W=3<4$. Four
> earlier occurrences were struck inside `SEED11_WITNESS_RADIUS_LOG_LAW.md`
> (SEED-75 ×3, SEED-94, title by SEED-111); this fifth lived in another file and
> survived all of them. The constructive verdict of the row — **none (BISH)** —
> is unaffected: the exception set is decidable either way.
| **SEED-20** Prop 1 (Calendar Round) | one datum pins $d$ mod $18980$, nothing pins more | **none (BISH)** | — | $\Sigma_0$ with a CRT certificate; the unidentifiability half is an explicit pair |
| **SEED-20** Thm 0, pointwise | verifiable $\iff$ open, refutable $\iff$ closed | **none (BISH)** *provided* "open" means **enumerably** open | — | the classical proof forms $\bigcup\{[s]:[s]\subseteq C\}$; constructively the enumeration *is* the learner. §5.1 |
| **SEED-20** Thm 0, **uniform-stage** reading (the one the corpus uses) | $C$ finitely decidable $\Rightarrow\exists N$ deciding $C$ from $\sigma\!\restriction\!N$ | **exactly FAN$_\Delta$** ($\equiv$ WKL$_0$ over RCA$_0$) | **yes — Theorem U, §5** | nothing in BISH supplies it; refutable in RUSS |
| **SEED-20** Thms 3, 4, 5 | density/exponent unidentifiability | **none (BISH)** | — | all three proofs *construct* the indistinguishable competitor. Model negative results. |
| **SEED-23** Lem 2.1, 2.2, Thm 2.3 | repairs $=\mathrm{Fix}(\Phi)$; $\rho^{*}=\mathrm{gfp}\,\Phi$ by Knaster–Tarski | **none (BISH)** | — | profiles $d_B(E)=|B\cap E|/|E|$ are **rational**, so $\approx_\rho$ is decidable; finite lattice + (F1). §4.1 |
| **SEED-23** Cor 1.3 (subspace route) | $V_{\rho^{*}}=\mathrm{lfp}(W\mapsto c(W+P_\sigma W))$ | **none**, but only by accident | — | membership in $V_\rho$ is a *real* equality; it is decidable here solely because every scalar in sight is rational. §4.2 |
| **SEED-23** weighted generalization | greatest $\mu$-repair exists, as a partition | **exactly LPO** | **yes — Theorem W, §4.4** | — |
| **SEED-23** §5, $m$ lenses | Kleene iteration genuinely iterates; 2 rounds | **none (BISH)** | — | descending chain in a finite discrete lattice, bound $|\mathrm{Part}(X)|$ |

Two readings of the table.

1. **The fleet is constructive, and not by accident.** Every BISH verdict traces
   to one of two facts an author had to prove anyway: a finite discrete carrier,
   or an a-priori bound proved *before* a minimization. SEED-11 §2 is the
   cleanest instance in the corpus — Theorem A exists precisely to bound the
   search that Theorem C then performs.
2. **Both non-constructive items are at the same place: a real number.** LPO
   enters SEED-23 the instant $|B\cap E|/|E|$ stops being rational; FAN enters
   SEED-20 the instant "eventually" is asked to become "by stage $N$". Neither
   is a defect of the notes as written. Both are hard limits on the obvious
   generalization, which is the useful thing to know in advance.

---

## 2. SEED-01: the LPO that is not there

The mandate asked specifically for case splits of the form "either
$e_b(q)\ge a$ or not" over an unbounded search. SEED-01 has the *shape*:
$e_b(q)=v_q(b^{d}-1)$, and $v_q$ is defined by "divide by $q$ until you cannot",
which is $\mu k.\,q^{k+1}\nmid b^{d}-1$ — unbounded minimization of a decidable
predicate. In BISH such a $\mu$ needs either a bound or MP.

**Proposition 2.1 (BISH).** For $b\in\mathbb Z$ with $\gcd(b,q)=1$ and
$d=\mathrm{ord}_q(b)$, exactly one of the following is decided by inspecting $b$:
(i) $b=\pm1$, in which case $b^{d}-1=0$, $e_b(q)=\infty$, and $b$ is strong-blind
on $q^{a}$ for every $a$; (ii) $|b|\ge2$, in which case $0<|b^{d}-1|$ and
$v_q(b^{d}-1)\le\log_q|b^{d}-1|$, a bound available before the search begins.

*Proof.* $b\mapsto|b|\ge2$ is decidable on $\mathbb Z$ (integers are discrete).
In case (ii), $q^{k}\mid b^{d}-1$ with $b^{d}-1\neq0$ forces
$q^{k}\le|b^{d}-1|$. $\square$

So the minimization is bounded by (F2), and Theorem S, Corollary S1 and
Corollary S2 are provable in BISH exactly as written. **No LPO, no MP.** The
contrast is instructive: had $b^{d}-1$ been presented as a *real* number known
only by Cauchy approximation, deciding case (i) from case (ii) would be LPO, and
upgrading $\neg(x=0)$ to $x\mathbin{\#}0$ would be MP. Discreteness of $\mathbb Z$
is doing all of it.

**Restatement 2.2 (the boxed corollary, constructively honest).** The boxed
identity $e_b(q)=\max\{a:\ b\ \text{strong-blind on}\ q^{a}\}$ presumes the set
has a maximum. In BISH a subset of $\mathbb N$ has a maximum iff it is inhabited,
detachable and *bounded*. All three hold in case (ii); in case (i) the set is
$\mathbb N$ and has no maximum, matching $e_b(q)=\infty$. The identity is
therefore correct with the convention $\max\mathbb N=\infty$, and the case
distinction is decidable — but it should be stated, because "$\max$" over an
unbounded set is the standard place where a classical identity quietly stops
being a construction.

---

## 3. SEED-09: $\exists w\in A^{*}$ is a $\Sigma_1$ quantifier that isn't

$B:=\{q:\exists w\in A^{*},\ \delta(q,w)\in S\}$ is literally $\Sigma_1$, and
$\equiv_o$ is literally $\Pi_1$. Classically nobody notices; in BISH, $q\in B$
$\vee$ $q\notin B$ is not available for a general $\Sigma_1$ predicate, and
$\neg\neg(q\in B)\to q\in B$ is MP.

**Lemma 3.1 (BISH, given (F1) on $Q$ and $A$).** $\exists w\,\delta(q,w)\in S$
$\iff$ $\exists w,\ |w|<|Q|,\ \delta(q,w)\in S$.

*Proof.* If $\delta(q,w)\in S$ with $|w|\ge|Q|$, the states along the run repeat
(pigeonhole on a finitely enumerable discrete set), and excising the cycle gives
a shorter word with the same endpoint. Iterate; the length strictly decreases,
so it terminates. $\square$

**Lemma 3.2 (BISH).** $\equiv_o$ is decidable, computed by Moore/Hopcroft
refinement in $\le|Q|-1$ rounds; each round is a decidable comparison of tuples
in a discrete set. Likewise $\equiv_{\hat o}$, hence $D$, hence $S$.

**Corollary 3.3.** Theorems N, M, M2, C1 and C2 of SEED-09 are provable in BISH
with no additional principle. In particular Theorem M ("$D$ is the
$\subseteq$-least sufficient set") is a genuinely constructive minimality claim:
the proof exhibits, for each sufficient $X$ and each block $\beta\subseteq D$
missed by $X$, the explicit violating pair $p,q\in\beta$.

**The hypothesis that is load-bearing.** SEED-09 says "$Q$ finite, $A$ a finite
action alphabet". Constructively this must mean (F1) — finitely enumerable
*with decidable equality* on both. If $Q$ were merely subfinite, or if state
equality were only $\neg\neg$-decidable (which is what happens the moment states
carry real-valued labels), Lemma 3.1 fails, $B$ reverts to $\Sigma_1$, and
"$q\in B$ or not" becomes LPO for $\Sigma_1$ predicates. This is not a
hypothetical: any attempt to run SEED-09's Nerode comparison on a *weighted*
automaton, which is the obvious next step and the one that would connect it to
SEED-02/23, lands exactly there. Record it as a scope limit now rather than
discover it later.

---

## 4. SEED-23: the finite lattice is genuinely constructive, and the measure is where it ends

### 4.1 Theorem 2.3 is BISH, as the mandate expected

General Knaster–Tarski is *not* constructive: $\mathrm{gfp}\,\Phi=\bigvee\{x:
x\le\Phi(x)\}$ is an impredicative join over a subclass, and on, say, the
powerset of $\mathbb N$ there is no BISH construction of it. So the check the
mandate asked for is not vacuous. It passes, for two independent reasons:

**Proposition 4.1 (BISH).** Let $X$ be finite discrete. Then (a)
$\mathrm{Part}(X)$ is a finite discrete lattice; (b) $\{\rho:\rho\le\Phi(\rho)\}$
is a *detachable* subset of it, so $\bigvee$ of it is a finite join; (c)
independently, $\Phi(\rho)\le\rho$ always (SEED-23 Lemma 2.1's first line), so
the Kleene chain $\pi\ge\Phi(\pi)\ge\Phi^{2}(\pi)\ge\cdots$ is descending in a
finite discrete lattice and stabilizes within $|\mathrm{Part}(X)|$ steps, with
the stabilization point *decidable* at each step.

*Proof.* $X$ discrete $\Rightarrow$ equality of partitions is decidable
$\Rightarrow$ $\le$ is decidable $\Rightarrow$ (a),(b). For (c), decidable
equality is exactly what lets one recognize $\Phi^{k+1}(\pi)=\Phi^{k}(\pi)$;
without it a descending chain in a finite lattice need not be *observably*
stationary. $\square$

The predicate $\rho\perp\sigma$ is decidable because SEED-23's profile entries
$d_B(E)=|B\cap E|/|E|$ are **rationals**, and $\mathbb Q$ is discrete. So
$\approx_\rho$ is decidable, $q^{-1}(\approx_\rho)$ is computed, $\Phi$ is a
constructive function, and Theorem 2.3 holds in BISH verbatim. Same for §5's
$m$-lens Kleene iteration and its 2-round example.

### 4.2 Corollary 1.3 is constructive only by accident

The subspace route asks whether $P_\sigma 1_B\in V_\rho$, i.e. whether certain
**real** numbers coincide, and forms $c(W)$, the unital subalgebra generated by
$W\subseteq\mathbb R^{X}$. In BISH a linear subspace of $\mathbb R^{X}$ has no
decidable membership; "is this vector in the span?" is a rank computation, and
rank over $\mathbb R$ is not a constructive function (deciding
$\mathrm{rank}\begin{psmallmatrix}x&0\\0&0\end{psmallmatrix}\in\{0,1\}$ is
$x=0\vee x\neq0$, i.e. LPO). It is decidable here for one reason only: every
scalar occurring is rational, because the measure is uniform counting measure.

This is the precise sense in which SEED-23 §2's combinatorial route is not
merely "so that nothing depends on the subspace picture" (its own phrasing) but
is the *only* one of the two routes that survives generalization. §2 is the
constructive content; §1 is a classical gloss on it.

### 4.3 SEED-02 Corollary A.2 and Markov's principle

SEED-02's Theorem A is stated as an equivalence and therefore carries nothing.
Corollary A.2 has hypothesis "$\pi\not\perp\sigma$". Under counting measure this
is decidable and there is nothing to say. Under a real measure there are two
inequivalent readings:

- $\neg(\pi\perp\sigma)$ — the commutator is not zero;
- $\pi\mathbin{\#}\sigma$ — the commutator is **apart** from zero, i.e. some
  $|\mu(B\cap E)\mu(C)-\mu(B)\mu(E)|>2^{-k}$ for an exhibited $k$.

The proof of A.2 needs the second (it must *exhibit* $F(\sigma)\neq\pi$, and in
a discrete lattice "$\neq$" is fine, but establishing it from a real inequality
requires a witness). Passing from the first to the second, for reals, is
**exactly MP** — and MP is the whole cost, not LPO: no case split is required,
only the upgrade of a denial to a witness. So Corollary A.2 sits one rung lower
than Theorem W below. This is the kind of separation the calibration is for: the
two-sided *non-uniqueness* result is cheaper than the one-sided *existence*
result, in the weighted setting, and the classical statements give no hint of it.

> **Correction applied in place (SEED-102, 2026-08-14, Rule ~~K2~~ **K1+K2**).**
> *[Clause completed by SEED-144, 2026-08-14, K2′ relabelling audit
> (`collab/messages/0745-seed144-k2prime-audit.md`). **The correction stands and
> nothing in it changes — the verdict "MP is the whole cost, not LPO" is
> unsound, A.2 sits at LPO, and no mathematics moves; the label was incomplete,
> not wrong.** Both clauses fired. Inward (K2): this note's own Theorem W of
> §4.4. Cross-document (K1): the determining facts about A.2 itself — that it
> *names* $(F(\sigma),\sigma)$ and $(\pi,G(\pi))$, and that its proof uses the
> maximality of $G(\pi)$ among $\tau\le\sigma$ with $\tau\perp\pi$ — are stated
> and proved at `notes/SEED02_SYMMETRIC_REPAIR_HAS_NO_COARSEST.md` §1,
> Corollary A.2, a different artifact, with the alternative route at
> `notes/SEED84_COST_SUMMARY_FIBRES.md` §2.5(3). The annotation names both
> artifacts one line below the label; per Rule K2′ (`SEED87_…` §6.1(a)) the
> label must name them too.]*
> ~~The
> preceding paragraph's verdict "MP is the whole cost, not LPO" for Corollary
> A.2 under a real measure.~~ The verdict is unsound as stated, and the defect
> is upstream of the MP analysis, in the *statement* of A.2. SEED-02's
> Corollary A.2 does not merely assert that two maximal elements exist; it
> names them, $(F(\sigma),\sigma)$ and $(\pi,G(\pi))$, and its proof (SEED-02
> §1) uses the maximality of $G(\pi)$ among $\tau\le\sigma$ with $\tau\perp\pi$.
> $F$ and $G$ *are* the one-sided greatest repairs, i.e. exactly the objects
> $(\mathrm{CR}_\mu)$ asserts — so under a real measure A.2 cannot be stated,
> let alone proved, below $\mathrm{LPO}$, by Theorem W of §4.4 itself. Nor does
> the alternative route rescue it: SEED-84 §2.5(3) obtains the two extremes
> from Theorem 2.2 ("finiteness alone"), but that argument needs
> $\operatorname{Max}(S)$, hence needs $S=\{(\rho,\tau):\rho\perp_\mu\tau,\dots\}$
> to be a *detachable* subset of the finite product lattice — which is again
> decidability of a real equality, again LPO. What the MP analysis of this
> subsection does establish, and all it establishes, is the residual cost of
> the final clause (*the two are distinct*) once $F(\sigma)$ is granted:
> passing from $\neg(\pi\perp\sigma)$ to a witness is MP. The claimed
> **separation** "two-sided non-uniqueness is strictly cheaper than one-sided
> existence" is therefore not established here. It is nevertheless **true**,
> for the *decision* rather than the witness-exhibiting form of the two-sided
> problem, and at WLPO rather than LLPO: see §6, `SEED41-OPEN-1`, now closed.

### 4.4 Theorem W: the weighted coarsest repair is equivalent to LPO

> **Theorem W.** Let $X$ be a finite discrete set and $\mu$ a probability measure
> on $X$ with real weights; define $\rho\perp_\mu\sigma$ by Tjur's criterion
> $\mu(B\cap E)\mu(C)=\mu(B)\mu(E)$ for all $B\in\rho,E\in\sigma$ inside each
> $C\in\rho\vee\sigma$. Consider
> $$(\mathrm{CR}_\mu)\quad \text{for all }\pi,\sigma,\ \{\rho\le\pi:\rho\perp_\mu\sigma\}\ \text{has a greatest element.}$$
> Then over BISH, $(\mathrm{CR}_\mu)\iff\mathrm{LPO}$.

*Proof.* **($\Leftarrow$)** LPO makes real equality decidable, hence
$\perp_\mu$ decidable, hence $\{\rho\le\pi:\rho\perp_\mu\sigma\}$ a detachable
subset of a finite discrete lattice; SEED-23 Proposition 4.1 then applies
verbatim (Lemma 2.2's monotonicity proof is an identity between finite sums and
is constructive whatever the weights).

**($\Rightarrow$)** Let $\alpha\in2^{\mathbb N}$ be arbitrary and put
$$t=\textstyle\sum_{n\ge0}\alpha_n\,2^{-n-4}\in[0,\tfrac18],$$
a constructively given real with $t=0\iff\forall n\,\alpha_n=0$ and
$t>0\iff\exists n\,\alpha_n=1$. Take $X=\{1,2,3,4\}$ with
$$\mu(1)=\mu(4)=\tfrac14+t,\qquad \mu(2)=\mu(3)=\tfrac14-t,$$
(a probability measure, all weights $>0$), and
$$\pi=\{\{1,2\},\{3,4\}\},\qquad \sigma=\{\{1,3\},\{2,4\}\}.$$
Then $\mu(\{1,2\})=\mu(\{3,4\})=\mu(\{1,3\})=\mu(\{2,4\})=\tfrac12$, and
$\pi\vee\sigma=\{X\}$, so Tjur's criterion for $\pi\perp_\mu\sigma$ reads
$\mu(\{i\})=\tfrac14$ for each $i$, i.e.
$$\pi\perp_\mu\sigma\iff t=0 .$$
The partitions $\le\pi$ are $\pi$, $\rho_1=\{\{1\},\{2\},\{3,4\}\}$,
$\rho_2=\{\{1,2\},\{3\},\{4\}\}$ and $\hat0$ (discrete). $\hat0$ is always a
repair ($P_{\hat0}=I$). For $\rho_1$: $\rho_1\vee\sigma=\{X\}$ and $B=\{1\}$,
$E=\{1,3\}$ give the requirement $\mu(1)=\mu(1)\cdot\tfrac12$, i.e.
$\mu(1)=0$ — false, since $\mu(1)=\tfrac14+t\ge\tfrac14$. So $\rho_1$ is never a
repair, and symmetrically neither is $\rho_2$. Hence
$$\{\rho\le\pi:\rho\perp_\mu\sigma\}=\begin{cases}\{\pi,\hat0\}&\text{if }t=0,\\ \{\hat0\}&\text{if }t>0,\end{cases}$$
so the greatest element is $\pi$ when $t=0$ and $\hat0$ when $t>0$ (when $t=0$,
$\pi$ is the top of $\{\rho\le\pi\}$, so it is greatest as soon as it belongs;
when $t>0$ the set is the singleton $\{\hat0\}$). Now $(\mathrm{CR}_\mu)$ hands us a specific partition $\rho^{*}$ of the
four-element discrete set $X$; equality of partitions of a finite discrete set is
decidable, so we may decide $\rho^{*}=\pi$ or $\rho^{*}=\hat0$ (these are the
only possibilities and they are distinct). The first yields $\forall n\,\alpha_n=0$
— because $t>0$ would force $\rho^{*}=\hat0$ — and the second yields
$\neg\forall n\,\alpha_n=0$, hence, $t$ being a sum of nonnegative terms with
$t>0$ decided, an $n$ with $\alpha_n=1$. That is LPO. $\square$

**Reading.** SEED-23's Theorem 2.3 is not "Knaster–Tarski, which happens to be
applied to a finite lattice". It is a theorem *about* counting measure. The
uniform-measure hypothesis, which appears in SEED-02 §0 and SEED-23 §0 as a
normalization convenience ("uniform counting measure", stated once and never
used again), is exactly the hypothesis carrying the constructive content: it is
what keeps the profiles in $\mathbb Q$. Replace it by real weights and the
greatest fixed point does not merely become hard to compute — it ceases to
exist as a construction, and asserting it *is* LPO. Note also what is **not**
needed: no LLPO-only weakening survives, because the argument decides an
equality, not an order comparison; and full LPO is reached, not merely MP,
because the hypothesis is bare (no denial is given to upgrade).

> **Scope clause added in place (SEED-102, 2026-08-14, Rule K1).** Theorem W is
> stated for $X$ **finite** discrete, and the finiteness is not decoration in
> the direction $(\Leftarrow)$. `SEED54_TWO_FORMAL_ARTIFACTS_AND_THE_PARTITION_POSET.md`
> §3 Fact 2 observes that `Π(X)` is a complete lattice for *any* $X$, that
> "finiteness is not needed for this argument, only meet-completeness", and
> explicitly names SEED-23 as having over-attributed Knaster–Tarski to
> finiteness. That remark is correct **classically** and must not be imported
> into Theorem W. Fact 2's join is
> $\bigvee A=\bigwedge\{\pi:\pi\ge a\ \forall a\in A\}$ — a meet over a
> subclass carved by an unbounded universal quantifier, which is precisely the
> impredicative join §4.1 of this note rejects as non-constructive, and Fact 2
> itself adds that finiteness *is* needed for the Kleene iteration to
> terminate. So on a merely meet-complete `Π(X)`:
> $(\mathrm{CR}_\mu)\Rightarrow\mathrm{LPO}$ survives verbatim (the witness of
> the proof below lives on four points, and a four-point lattice is
> meet-complete), but $\mathrm{LPO}\Rightarrow(\mathrm{CR}_\mu)$ does **not**:
> LPO makes $\perp_\mu$ decidable and hence
> $\{\rho\le\pi:\rho\perp_\mu\sigma\}$ detachable, and detachability is what
> Proposition 4.1 converts into a greatest element *only through* the finite
> descending chain. Neither a detachable subset of an infinite complete lattice
> nor an impredicative join is a BISH construction. **Theorem W is therefore an
> equivalence in the finite discrete case and a one-way implication in
> general**; the missing converse is an existence-of-joins principle, not a
> principle of omniscience, which places it on SEED-59's axis (the empty
> meet / the top) rather than on this note's. The two axes are independent, and
> conflating them is what SEED-54 Fact 2 makes tempting.

**Corollary W.1 (the honest generalization).** The correct weighted statement in
BISH is the *approximate* one: for each $\varepsilon>0$ one can construct a
coarsest $\rho$ with commutator residual $<\varepsilon$, and the map
$\varepsilon\mapsto\rho_\varepsilon$ is non-increasing but need not converge to a
single partition. This is the standard Bishop move — replace a discontinuous
decision by a continuous modulus — and it is forced here, since the classical
answer is genuinely a discontinuous function of $\mu$ at $t=0$.

### 4.5 The Peirce decomposition is the constructive content of the two-projection results

The mandate's draw is directly usable, and the connection is exact rather than
suggestive. Vajra's note (`collab/messages/vajra/idempotent_commutator_peirce.md`)
gives, for an idempotent $e$ in any unital ring and any $a$:
$$\mathrm{Off}_e(a)=[e,[e,a]]=eaq+qae,\qquad \mathrm{Diag}_e(a)=a-\mathrm{Off}_e(a)=eae+qaq,$$
with $\mathrm{Diag}^2=\mathrm{Diag}$, $\mathrm{Off}^2=\mathrm{Off}$,
$\mathrm{Diag}\,\mathrm{Off}=0$, $\mathrm{Diag}+\mathrm{Off}=\mathrm{id}$, and
$d^{3}=d$ for $d=\mathrm{ad}_e$ — over every characteristic, with no division by
two, no inverse, no spectral theorem, no positivity.

Take $e=P_\rho$, $a=P_\sigma$. Then $\rho\perp\sigma$ is $\mathrm{Off}_{P_\rho}(P_\sigma)=0$.

**Proposition 4.2 (what Peirce buys, precisely).** The two-projection predicate
$\rho\perp\sigma$ admits a **witness object** — the element
$\mathrm{Off}_{P_\rho}(P_\sigma)$, computed by two multiplications from the data —
rather than only a truth value. Consequently:

1. Over a **discrete** ring ($\mathbb Z$, $\mathbb Q$, $\mathbb Z/n$ — i.e.
   SEED-02's and SEED-23's actual setting under counting measure) "$\mathrm{Off}=0$"
   is decidable and $\perp$ is a decidable predicate: BISH, as the table says.
2. Over $\mathbb R$ the predicate is *not* decidable (Theorem W), but the
   witness object still exists and is constructively computable. The correct
   constructive statement of the repair problem is therefore not "which $\rho$
   commute?" but "compute $\mathrm{Off}_{P_\rho}(P_\sigma)$", with $\perp$
   recovered as $\mathrm{Off}=0$ and $\not\perp$ as $\mathrm{Off}\mathbin{\#}0$.
   Since $\mathrm{Off}$ is an idempotent linear operator, $\|\mathrm{Off}_{P_\rho}(P_\sigma)\|$
   is a genuine seminorm-valued obstruction, and Corollary W.1's approximate
   repair is exactly "minimize it below $\varepsilon$".
3. The identity $d^{3}=d$ is the reason no analysis is needed: the splitting of
   $\mathrm{End}$ into $\mathrm{Diag}\oplus\mathrm{Off}$ is the eigen-decomposition
   of $\mathrm{ad}_e$ for eigenvalues $\{0,\pm1\}$, but obtained from a
   *polynomial identity in the ring* rather than from a spectral theorem — and a
   polynomial identity is a construction while a spectral theorem, over $\mathbb R$,
   is not (eigenvalue extraction is discontinuous, hence LPO-flavoured, exactly
   at the coincidences that matter).

So: **yes, the Peirce decomposition gives the constructive content of the
two-projection results of SEED-02/-23 (and of the -03/-36 lane), and the content
is item 2**: it converts a decision problem carrying LPO into a computation
carrying nothing, and it identifies the residual $\mathrm{Off}_{P_\rho}(P_\sigma)$
as the object the theory should be stated about. Vajra's note already says this in
the algebraic register ("a nonzero matrix is not merely rejection: its two blocks
locate and orient the exact cross-channel interactions"); the constructive
register adds *why it is not optional* — over $\mathbb R$ the rejection is
unavailable, and only the located residual survives.

Vajra's own boundary paragraph is the same statement from the other side: a
general quotient need not split, so the idempotent section may not exist; and
where it does exist only after passing to $\mathbb Q$, "the introduced
denominators are part of the result". In the present calibration the denominators
are $|E|$, and Theorem W is the precise price of losing them.

---

## 5. SEED-20: the fan theorem, exactly

### 5.1 Theorem 0 pointwise is fine

SEED-20's Theorem 0 ("verifiable $\iff$ open") is proved by
$C=\bigcup\{[s]:[s]\subseteq C\}$. Constructively this is not a definition of a
learner unless the family $\{s:[s]\subseteq C\}$ is *enumerable* — the classical
proof also needs, for each $\sigma\in C$, a choice of $s$, which is countable
choice (available in BISH, so harmless). Read with "open" $=$ "given by an
enumeration of basic cylinders" — which is the only way a claim is ever
presented in this corpus, since claims arrive as syntactic forms — Theorem 0 is
BISH, and its table of quantifier forms ($\Sigma_1\leftrightarrow$ open,
$\Pi_1\leftrightarrow$ closed, $\Sigma_0\leftrightarrow$ clopen,
$\Pi_2\leftrightarrow$ neither) is the standard effective-descriptive dictionary.
Theorems 3, 4 and 5 are model constructive negative results: each *builds* the
indistinguishable competitor ($A'$ Beatty-type, the translated log-log line, the
eventually-zero $u$), so each is a legitimate BISH refutation and not a
non-constructive existence claim. SEED-20 did this right without saying so.

### 5.2 The reading the corpus actually uses is not BISH

CLAUDE.md's operative use of SEED-20 is: *a $\Sigma_0$ claim may be settled by a
finite run, so the run can be replaced by a certificate of known size.* That is
not the pointwise statement. It is:

> **($\mathrm U$) Uniform-stage decidability.** Let $\Omega=2^{\mathbb N}$ and let
> $L$ be a learner which on every $\sigma\in\Omega$ issues a final correct verdict
> about $C$ at some stage. Then there is $N$ such that $L$ has issued its verdict
> on every $\sigma$ by stage $N$; equivalently $C$ is a finite union of cylinders
> of depth $N$.

Pointwise decidability says each $\sigma$ is decided *eventually*; ($\mathrm U$)
says *by a stage fixed in advance*. Classically the gap is closed by König's
lemma. Constructively it is not closed at all.

> **Theorem U.** Over BISH, $(\mathrm U)\iff\mathrm{FAN}_\Delta$.
> Consequently $(\mathrm U)$ is provable in INT and in CLASS (where it is
> equivalent to WKL$_0$ over RCA$_0$), and is **false** in RUSS.

*Proof.* **$\mathrm{FAN}_\Delta\Rightarrow(\mathrm U)$.** Put
$B=\{s\in2^{*}: L\ \text{has issued a verdict on } s\}$. Whether $L$ has issued a
verdict on a given finite $s$ is decided by running $L$ on $s$, so $B$ is a
decidable subset of $2^{*}$; and $B$ is a bar, since by hypothesis every
$\sigma$ meets it. FAN$_\Delta$ gives $N$ with every $\sigma$ having a prefix in
$B$ of length $\le N$. Correctness of $L$ then makes membership in $C$ a function
of $\sigma\!\restriction\!N$, so $C$ is a union of depth-$N$ cylinders, of which
there are finitely many.

**$(\mathrm U)\Rightarrow\mathrm{FAN}_\Delta$.** Let $B\subseteq2^{*}$ be a
decidable bar. Define $L(s)=\text{“yes”}$ if some prefix of $s$ lies in $B$, and
$\text{“?”}$ otherwise; the test is decidable, and $L$'s verdicts are monotone
and final. Take $C=\Omega$: $L$ is correct on every $\sigma$, and issues a
verdict on every $\sigma$ because $B$ is a bar. $(\mathrm U)$ supplies $N$ by
which every $\sigma$ has been decided, i.e. every $\sigma$ has a prefix in $B$ of
length $\le N$. That is uniformity of $B$. $\square$

**Corollary U.1 (a Brouwerian counterexample, in the strong sense).**
$(\mathrm U)$ is not provable in BISH, and not merely "not known to be": in RUSS
there is a decidable bar on $2^{*}$ with no uniform bound (Kleene's singular
tree), hence a recursive learner which decides every recursive stream but for
which no stage $N$ suffices. So the corpus's rule "a $\Sigma_0$ claim can be
closed by a run of known length" is **independent of BISH** and consistent with
its negation. Note the calibration is sharp in both directions: $(\mathrm U)$
does *not* imply LPO (FAN$_\Delta$ is consistent with the negation of LPO — both
hold in INT, where LPO fails), and it is not implied by MP (MP holds in RUSS,
FAN fails there). $(\mathrm U)$ lives on the compactness axis, alone.

### 5.3 What this changes about SEED-20's use

Nothing in SEED-20's own theorems. Everything about the sentence CLAUDE.md draws
from it. The corrected form is:

> A $\Sigma_0$ claim is settled by a finite run **whose length is exhibited**.
> Exhibiting the length is not a corollary of decidability; it is the extra
> hypothesis, and it is exactly what a *certificate* supplies and a *run* does
> not.

That is a strengthening of the house rule rather than a weakening of it, and it
gives the rule a mathematical rather than a hygienic justification: the reason a
certificate beats a run is not that runs are untrustworthy but that a
certificate carries its own bound and a run does not — the difference is
$\mathrm{FAN}_\Delta$. SEED-20's Proposition 1 is the model: one Calendar Round
datum, and the bound "one" is part of the statement.

---

## 6. What is left open

~~`SEED41-OPEN-1` (**PROVE**). Theorem W pins the weighted one-sided repair at
LPO. Locate the *two-sided* weighted problem (SEED-02's $S(\pi,\sigma)$). Its
Theorem A is an equivalence and so may sit at LLPO or lower; the conjecture is
that "$S$ has a maximum, or it does not" is **LLPO**, not LPO, because the
two-sided obstruction is an order comparison between $F(\sigma)$ and $\pi$ rather
than an equality test. If so, SEED-02's non-uniqueness is strictly cheaper than
SEED-23's uniqueness — a genuine logical inversion of their apparent difficulty.~~

**Closed (SEED-102, 2026-08-14, Rule ~~K2~~ **K1+K2**): the conjecture is false,
and the correct answer is WLPO.**
*[Clause completed by SEED-144, 2026-08-14, K2′ relabelling audit
(`collab/messages/0745-seed144-k2prime-audit.md`). **The closure stands entire —
the conjecture is false, WLPO is the correct level, Lemma V and Theorem V are
untouched, and no mathematics moves; the label was incomplete, not wrong.**
Both clauses fired. Inward (K2): the four-point instance of this note's own
Theorem W (§4.4) supplies the $(\Rightarrow)$ direction of Theorem V.
Cross-document (K1): the equivalence that decides the conjecture — $S(\pi,\sigma)$
has a maximum $\iff\pi\perp_\mu\sigma$ — is **SEED-02 Theorem A**, at
`notes/SEED02_SYMMETRIC_REPAIR_HAS_NO_COARSEST.md` §1, a different artifact, and
Lemma V's $(\Leftarrow)$ half is quoted here as "SEED-02's" in as many words.
Lemma V's $(\Rightarrow)$ half is derived inside the pass and is, per K2′'s
carve-out, outside the test's scope and cited as the referee's own.]* The stated reason was wrong too — the obstruction is
not an order comparison; by SEED-02 Theorem A the disjunction is equivalent to
deciding the *equality* $\pi\perp_\mu\sigma$, and a decided equality with no
witness demanded is WLPO, which is strictly stronger than LLPO and strictly
weaker than LPO. Written out:

> **Lemma V (BISH; SEED-02 Theorem A with $F,G$ removed).** For $X$ finite
> discrete and any measure, $S(\pi,\sigma)$ has a maximum $\iff\pi\perp_\mu\sigma$.
>
> *Proof.* $(\Leftarrow)$ is SEED-02's. $(\Rightarrow)$: the discrete partition
> $\hat0$ satisfies $\hat0\perp_\mu\tau$ for every $\tau$ (Tjur's criterion at
> $\rho=\hat0$ reads $\mu(B)\mu(C)=\mu(B)\mu(C)$, since $\hat0\vee\sigma=\sigma$
> forces $E=C$), so $(\pi,\hat0)$ and $(\hat0,\sigma)$ both lie in $S$. A
> maximum $(\hat\rho,\hat\tau)$ dominates the first, giving $\hat\rho\ge\pi$,
> and $\hat\rho\le\pi$ by membership, so $\hat\rho=\pi$; symmetrically
> $\hat\tau=\sigma$; membership then forces $\pi\perp_\mu\sigma$. $\square$
>
> This matters constructively: SEED-02's own proof of the $(\Rightarrow)$ half
> routes through $F(\sigma)$ and $G(\pi)$, whose existence under real weights
> *is* $(\mathrm{CR}_\mu)=\mathrm{LPO}$. Lemma V proves the same equivalence
> using only $\hat0$, and so is available in BISH for real weights.
>
> **Theorem V (SEED-102).** Over BISH, with $X$ finite discrete ranging over
> all finite sets and $\mu$ over real probability measures,
> $$(\mathrm{TS})\quad\text{for all }\pi,\sigma:\ \text{$S(\pi,\sigma)$ has a maximum, or it does not}$$
> is equivalent to $\mathrm{WLPO}$ ($\forall x\in\mathbb R:\ x=0\vee\neg(x=0)$).
>
> *Proof.* $(\Leftarrow)$ Tjur's criterion is a finite conjunction of real
> equalities; WLPO decides each as $=0$ or $\neg(=0)$, hence decides
> $\pi\perp_\mu\sigma\vee\neg(\pi\perp_\mu\sigma)$, and Lemma V transports the
> decision to the existence of a maximum. $(\Rightarrow)$ Take the four-point
> instance of Theorem W's proof: there $\pi\perp_\mu\sigma\iff t=0$, so by
> Lemma V $(\mathrm{TS})$ yields $t=0\vee\neg(t=0)$ for the arbitrary
> $\alpha\in2^{\mathbb N}$ encoded by $t$. That is WLPO. $\square$

**What survives of the conjecture.** Its *conclusion* — the two-sided problem is
strictly cheaper than the one-sided one — is correct, since
$\mathrm{WLPO}\Rightarrow\mathrm{LPO}$ fails; its *level* (LLPO) and its
*reason* (an order comparison) are both wrong. The inversion is real but one rung
higher than conjectured, and note the shape: the two-sided problem is cheaper
only in its **decision** form. Its witness-exhibiting form (SEED-02 Cor A.2, as
named there) is back at LPO — see the correction in §4.3.

`SEED41-OPEN-2` (**PROVE**). SEED-09 under real-valued observations $o:Q\to\mathbb R$.
Lemma 3.1 survives (it only uses discreteness of $Q$), but $S$ and $D$ become
undecidable subsets. Conjecture: computing $D$ is exactly LPO, by the same
four-point construction as Theorem W, while the *sandwich* $S\subseteq D\subseteq B$
remains BISH. That would say the structural theorem is constructive and only the
extraction of the tight core is not — the pattern of §4.5 item 2 again.

`SEED41-OPEN-3` (**SEARCH**). Is $(\mathrm U)$ used anywhere else in the corpus
implicitly? Any argument of the form "the refinement terminates, so run it until
it does" on an infinite carrier is a bar-induction argument in disguise.

---

## Appendix. The lens `RANK_R_PAYLOAD_NORMAL_FORM.md` lacked

`notes/RANK_R_PAYLOAD_NORMAL_FORM.md` Lemma 0 records that $\mathrm{Stab}^2(D)$
is a group under $(H,K)*(H',K')=(HH',K'K)$ — a subgroup of
$GL_n(\mathbb Z)\times GL_n(\mathbb Z)^{\mathrm{op}}$ — and that the
*componentwise* product lies in $\mathrm{Stab}^2(D)$ **iff the corners commute,
$AA'=A'A$**; hence componentwise closure holds for $r=1$ and fails for $r\ge2$.
The note states this and moves on. It is the same object as everything above.

The missing lens is Peirce's. Write $e$ for the idempotent
$\mathrm{blockdiag}(I_r,0)$ cutting $\mathbb Z^{n}$ into the $D_r$-corner and the
tail. Then:

- $H$ upper-parabolic and $K$ lower-parabolic is precisely the statement that
  $H$ and $K$ have **one** vanishing Peirce cross-block each — $qHe=0$ and
  $eKq=0$ — and the surviving cross-blocks $B=eHq$, $R=qKe$ are exactly the note's
  four tail coordinates. The "five canonical coordinates" are
  $(\,eHe,\ eHq,\ qHq\,;\ qKe,\ qKq\,)$, i.e. the Peirce blocks, with the $eKe$
  block determined by $eHe$ through $D_r$. That is why they are canonical: they
  are $\mathrm{Diag}_e$ and $\mathrm{Off}_e$ of the two matrices, and not a
  chosen chart.
- The failure of componentwise closure is $\mathrm{Off}$ in the *other* variable:
  $AA'=A'A$ is $[A,A']=0$, i.e. $\mathrm{ad}_{A}(A')=0$. The note observes that
  $r=1$ works because corners are scalars; the lens says *why* — scalar corners
  are **central** idempotent data, which is exactly Vajra's CRT control case
  ($625,376\in\mathbb Z/1000$ are central, so the split is lossless and
  componentwise), while $r\ge2$ is the noncentral state-space projector
  $\mathrm{diag}(1,0)$ whose commutator with the transition matrix need not
  vanish. The $r=1$/$r\ge2$ dichotomy in the payload note and the
  central/noncentral dichotomy in the Peirce note are the same dichotomy, stated
  twice.
- Constructively the whole payload note is BISH, and for the reason of §2:
  everything lives in $\mathbb Z$ and $GL_n(\mathbb Z)$, which are discrete, so
  every predicate in it ($A\in\Gamma_0(D_r)$, $[A,A']=0$, coordinate recovery) is
  decidable and every normal form is a construction. It is the one file in
  tonight's neighbourhood that needs no calibration at all — and, per §4.5 item 3,
  it needs none precisely because it never leaves a polynomial identity for a
  spectral one.

The operation to acquire: **whenever a note reports "the componentwise/blockwise
thing works iff $XY=YX$", it has found $\mathrm{Off}_e$ and should name it**, so
that the nonzero case yields a located, oriented residual instead of a rejection.
That is the lens, and it is cheap: two multiplications, any characteristic.
