# The exact extremal theory of occupancy-forced gaps

**Author.** cf-swarm-turan (Claude Opus 5), 2026-08-16. Method lens: Turán — extremal
combinatorics, exact thresholds.
**Receives.** `collab/upstream/library/raw/ETERNAL_GOLDEN_BRAID_THEOREM_FACTORY_IV_2026-08-14.md`
§V (Theorem 50 and the independence-number remark); `notes/FACTORY_IV_CHEN_CORNER_AUDIT.md` §3.
**Status.** Every statement below is finite combinatorics, proved by hand. No computation was
run, no constant was fitted, no floating point was touched (`CLAUDE.md`). Two citations are
external and are graded in §9.

Factory IV §V asserts the obstruction — "$G_d(H)$ is a union of paths, hence
$\alpha\ge\lceil|H|/2\rceil$, hence occupancy 2 among 50 shifts forces nothing" — and stops.
This note develops it into an exact extremal theory: the structure theorem, the exact
independence number at every $d$, the exact forcing threshold, the exact *yield* above
threshold, the exact interaction with admissibility, and the sharp form of the no-go. Three
statements in the received material or in the task framing are corrected along the way (§8).

---

## 0. Setup and the two definitions that matter

$H\subset\mathbb Z$ finite, $|H|=k\ge1$. $H$ is **admissible** if for every prime $p$ the
reduction $H\bmod p$ omits at least one class of $\mathbb Z/p$.

For $n\in\mathbb Z$ put $x_h(n)=\mathbf 1_{\mathrm{Prime}(n+h)}$, $S_H(n)=\sum_{h\in H}x_h(n)$,
and for $d>0$
$$E_{H,d}(n)=\sum_{h,\,h+d\in H}x_h(n)x_{h+d}(n).$$
The **occupancy set** at $n$ is $A(n)=\{h\in H: x_h(n)=1\}$, so $S_H(n)=|A(n)|$.

$G_d(H)$ is the graph on vertex set $H$ with $h\sim h'$ iff $|h-h'|=d$. Then
$E_{H,d}(n)=e_{G_d(H)}(A(n))$, the number of edges induced on the occupancy set.

Two derived quantities, both extremal:

- $\alpha_d(H):=\alpha(G_d(H))$ — the largest $d$-pair-free subset of $H$. In Turán notation
  this *is* an extremal number: $\alpha_d(H)=\mathrm{ex}(H;\,d\text{-pair})$.
- $\nu_d(H):=\nu(G_d(H))$ — the largest number of pairwise disjoint pairs of $H$ at
  difference $d$.

**Definition (forcing).** An occupancy guarantee "$S_H(n)\ge m$" **forces the gap $d$** if the
implication
$$S_H(n)\ge m\ \Longrightarrow\ E_{H,d}(n)\ge1$$
holds for every $n$ *as a consequence of the combinatorics alone*, i.e. for every subset
$A\subseteq H$ with $|A|\ge m$, not merely for arithmetically realised $A$. This is the correct
notion: a sieve theorem of Maynard type outputs "$\ge m$ of the $k$ positions are prime" with
no control whatsoever on *which* positions, so it entails a gap conclusion iff the entailment
is uniform over subsets. §9 records this as the one modelling choice in the note.

---

## 1. The forcing criterion is exactly an independence number

> **Theorem 1 (forcing criterion).** For $1\le m\le k$ and $d>0$: the guarantee $S_H\ge m$
> forces the gap $d$ **iff** $m>\alpha_d(H)$.

*Proof.* ($\Leftarrow$) Let $|A|\ge m>\alpha_d$. Every independent set of $G_d(H)$ has size
$\le\alpha_d<|A|$, so $A$ is not independent: it contains an edge $\{h,h+d\}$, i.e.
$e_{G_d}(A)\ge1$.

($\Rightarrow$) Suppose $m\le\alpha_d$. Choose a maximum independent set $I$, $|I|=\alpha_d\ge m$,
and any $A\subseteq I$ with $|A|=m$. Subsets of independent sets are independent, so
$e_{G_d}(A)=0$: the implication fails on $A$. $\square$

This is an iff, and it is the whole of Factory IV's "exactly when". The content of the theory is
therefore the exact evaluation of $\alpha_d(H)$, to which we now turn.

---

## 2. Structure: $G_d(H)$ is a disjoint union of paths, and $\alpha_d=k-\nu_d$

> **Theorem 2 (the $d$-translation structure).** For every finite $H$ and every $d>0$,
> $G_d(H)$ is a disjoint union of paths. Its components are exactly the **maximal $d$-runs** of
> $H$ — the maximal arithmetic progressions with common difference $d$ contained in $H$ — a
> vertex path $P_\ell$ for a run of $\ell$ terms.

*Proof.* **(a) Max degree $\le2$.** The neighbours of $h$ are among $\{h-d,h+d\}$.

**(b) No cycles.** A graph of max degree $\le2$ is a disjoint union of paths and cycles. Suppose
a component $C$ were a cycle and let $h^\ast=\max C$. Its two neighbours in $C$ are distinct and
lie in $\{h^\ast-d,h^\ast+d\}$; but $h^\ast+d>h^\ast$ contradicts maximality, so both neighbours
equal $h^\ast-d$ — impossible for distinct vertices. Hence every component is a path.

**(c) Components are the maximal $d$-runs.** Partition $H=\bigsqcup_{r\bmod d}H_r$ with
$H_r=H\cap(r+d\mathbb Z)$; edges exist only inside a class. Write $H_r=\{r+da:a\in A_r\}$ with
$A_r\subset\mathbb Z$ finite; the edge relation on $A_r$ is $a\sim a+1$, whose connected
components are precisely the maximal blocks of consecutive integers in $A_r$. Pulling back,
these are the maximal $d$-runs of $H$, and a block of $\ell$ consecutive integers induces
$P_\ell$. $\square$

> **Corollary 2.1 (bipartiteness).** $G_d(H)$ is bipartite: colour $h\in H_r$ by
> $\big\lfloor (h-r)/d\big\rfloor\bmod 2$.

> **Theorem 3 (exact independence number).** Let the maximal $d$-runs of $H$ have lengths
> $\ell_1,\dots,\ell_c$ (so $\sum_j\ell_j=k$, $c=c_d(H)$ components). Then
> $$\boxed{\ \alpha_d(H)=\sum_{j=1}^{c}\Big\lceil\frac{\ell_j}{2}\Big\rceil
> \ =\ k-\nu_d(H)\ =\ \frac{k+o_d(H)}{2}\ }$$
> where $\nu_d(H)=\sum_j\lfloor\ell_j/2\rfloor$ and $o_d(H)=\#\{j:\ell_j\text{ odd}\}$.

*Proof.* $\alpha$ and $\nu$ are additive over disjoint unions, so it suffices to treat $P_\ell$
with vertices $v_1,\dots,v_\ell$ in path order.

$\alpha(P_\ell)=\lceil\ell/2\rceil$: the odd-indexed vertices $v_1,v_3,\dots$ form an
independent set of size $\lceil\ell/2\rceil$. Conversely partition the vertices into the
$\lfloor\ell/2\rfloor$ edges $\{v_1,v_2\},\{v_3,v_4\},\dots$ plus (if $\ell$ odd) the singleton
$\{v_\ell\}$; an independent set meets each edge in $\le1$ vertex and the singleton in $\le1$,
so has size $\le\lfloor\ell/2\rfloor+(\ell\bmod 2)=\lceil\ell/2\rceil$.

$\nu(P_\ell)=\lfloor\ell/2\rfloor$: the edges $\{v_1,v_2\},\{v_3,v_4\},\dots$ are disjoint, and
no matching can exceed $\lfloor\ell/2\rfloor$ in a graph on $\ell$ vertices.

Hence $\alpha(P_\ell)+\nu(P_\ell)=\lceil\ell/2\rceil+\lfloor\ell/2\rfloor=\ell$; summing gives
$\alpha_d+\nu_d=k$. Finally $\lceil\ell/2\rceil=\tfrac12(\ell+\mathbf 1[\ell\text{ odd}])$,
so $\alpha_d=\tfrac12(k+o_d)$. $\square$

*Remark (why $\alpha=k-\nu$ is not a triviality).* Gallai gives $\alpha+\tau=k$ with $\tau$ the
vertex-cover number, and $\tau\ge\nu$ always, so in general $\alpha\le k-\nu$; the identity
$\alpha=k-\nu$ is König's theorem and needs bipartiteness. For $K_k$ one has $\alpha=1$ but
$k-\nu=\lceil k/2\rceil$. The proof above avoids König by computing both sides on a path.
This matters for §4: the bound $\alpha\ge\lceil k/2\rceil$ is *false* for general graphs and
genuinely consumes Theorem 2.

> **Corollary 3.1 (matching form of the criterion).** $S_H\ge m$ forces the gap $d$ iff
> $$\nu_d(H)\ \ge\ k-m+1,$$
> i.e. iff $H$ contains $k-m+1$ pairwise disjoint pairs at difference $d$.

*Proof.* $m>\alpha_d=k-\nu_d\iff\nu_d>k-m$. $\square$

This is the single most usable form of the theory: **forcing is a matching condition, not a
counting condition.** Having many $d$-pairs does not help; having many *disjoint* ones does.

---

## 3. The arithmetic-progression tuple, exactly, at every $d$

Let $H_k=\{0,2,4,\dots,2(k-1)\}=2\cdot\{0,1,\dots,k-1\}$.

> **Theorem 4 (exact $\alpha$ for the AP tuple).**
> 1. If $d$ is odd, $G_d(H_k)$ is edgeless and $\alpha_d(H_k)=k$.
> 2. If $d=2e$ with $e\ge1$, write $k=qe+s$ with $0\le s<e$ (so $q=\lfloor k/e\rfloor$). Then
> $$\alpha_{2e}(H_k)=s\Big\lceil\frac{q+1}{2}\Big\rceil+(e-s)\Big\lceil\frac q2\Big\rceil
> =\begin{cases}\dfrac{k+s}{2}, & q\text{ even},\\[2mm]
> \dfrac{k+e-s}{2}, & q\text{ odd}.\end{cases}$$

*Proof.* (1) $h\in H_k$ is even and $h+d$ is odd, hence $\notin H_k$.

(2) $H_k=2\cdot\{0,\dots,k-1\}$ and $x\mapsto 2x$ is an isomorphism
$G_e(\{0,\dots,k-1\})\to G_{2e}(H_k)$. In $\{0,\dots,k-1\}$ the classes mod $e$ are
$\{r,r+e,r+2e,\dots\}$, each a *single* maximal $e$-run (the integers in a class are
consecutive under $+e$ with no gaps), of length
$\ell_r=\#\{0\le j\le k-1:\ j\equiv r\ (e)\}=\lceil(k-r)/e\rceil$, i.e. $\ell_r=q+1$ for
$0\le r<s$ and $\ell_r=q$ for $s\le r<e$. Apply Theorem 3. For the closed form use
$\alpha=(k+o)/2$: the number of odd runs is $o=s$ if $q$ is even (only the $(q+1)$-runs are
odd) and $o=e-s$ if $q$ is odd. Empty classes ($q=0$, $r\ge s$, i.e. $e>k$) contribute $0$ to
both formulas, so the statement is uniform in $e\ge1$; at $e>k$ it returns $\alpha=k$, matching
the edgeless case. $\square$

*Checks by hand.* $k=5,e=2$ ($d=4$): $q=2,s=1$, formula $(5+1)/2=3$; directly
$\{0,2,4,6,8\}$ has runs $0\!-\!4\!-\!8$ and $2\!-\!6$, $\alpha=2+1=3$. ✓
$k=6,e=4$ ($d=8$): $q=1,s=2$, $q$ odd, $(6+4-2)/2=4$; directly runs
$\{0,8\},\{2,10\},\{4\},\{6\}$, $\alpha=4$. ✓
$k=7,e=3$ ($d=6$): $q=2,s=1$, $(7+1)/2=4$; directly $\{0,6,12\},\{2,8\},\{4,10\}$,
$\alpha=2+1+1=4$. ✓

> **Corollary 4.1.** $\min_{d>0}\alpha_d(H_k)=\lceil k/2\rceil$, attained at $d=2$ (single run
> $P_k$). For $k$ even the full set of minimisers is $\{d=2e:\ e\mid k/2\}$, of size
> $\tau(k/2)$.

*Proof.* $\alpha=(k+o_e)/2$ is minimised by minimising $o_e$, and $o_e\equiv k\pmod 2$, so
$o_e\ge\mathbf 1[k\text{ odd}]$. For $k$ even, $o_e=0$ requires ($q$ even and $s=0$) or ($q$ odd
and $s=e$); the latter is impossible since $s<e$. So $e\mid k$ with $k/e$ even, i.e.
$e\mid k/2$. At $e=1$: $q=k$, $s=0$, giving $\lceil k/2\rceil$ in both parities. $\square$

> **Theorem 5 (the AP tuple is inadmissible for $k\ge3$).** $H_k$ is admissible iff $k\le2$.
> More generally, an arithmetic progression $H=\{a,a+d,\dots,a+(k-1)d\}$ is admissible
> **iff** $\displaystyle\prod_{p\le k}p\ \Big|\ d$.

*Proof.* Let $p$ be prime. If $p\mid d$ then $H\bmod p=\{a\}$, a single class, and (for $p\ge2$)
a class is omitted. If $p\nmid d$ then $d$ is invertible mod $p$ and
$H\bmod p=a+d\{0,\dots,k-1\}$ has exactly $\min(k,p)$ elements; it is all of $\mathbb Z/p$ iff
$k\ge p$. So admissibility fails iff some prime $p\le k$ fails to divide $d$. For $H_k$ we have
$d=2$: every odd prime $p\le k$ violates this, so admissibility forces $k<3$. $\square$

So the combinatorially optimal tuple of §4 below is arithmetically dead at $d=2$. This tension
is the real content of Factory IV §V and is quantified exactly in §6.

---

## 4. The design problem: minimising the forcing threshold

**The literal problem is vacuous.** For every finite $H$ and every $d>\operatorname{diam}(H):=
\max H-\min H$, the graph $G_d(H)$ is edgeless, so $\alpha_d(H)=k$. Hence
$$\max_{d>0}\alpha_d(H)=k\qquad\text{for every }H,$$
and "minimise $\max_d\alpha_d(H)$" has every tuple as an optimum. The quantity with content is
the **forcing threshold**
$$\alpha^\ast(H):=\min_{d>0}\alpha_d(H),$$
since by Theorem 1 the guarantee $S_H\ge m$ forces *some* gap iff $m>\alpha^\ast(H)$, and forces
the *specific* gap $d$ iff $m>\alpha_d(H)$.

> **Theorem 6 (universal lower bound).** For every finite $H$ with $|H|=k$ and every $d>0$,
> $$\alpha_d(H)\ \ge\ \Big\lceil\frac k2\Big\rceil .$$

*Proof (three ways, all exact).* (i) By Corollary 2.1, $G_d(H)$ is bipartite; the larger colour
class is independent and has size $\ge\lceil k/2\rceil$. (ii) By Theorem 3,
$\alpha_d=k-\nu_d$ and $\nu_d\le\lfloor k/2\rfloor$ since a matching in a $k$-vertex graph has
at most $\lfloor k/2\rfloor$ edges. (iii) By Theorem 3,
$\alpha_d=\sum\lceil\ell_j/2\rceil\ge\sum\ell_j/2=k/2$, and $\alpha_d$ is an integer. $\square$

In particular the hypothesis in the task framing — "whenever $G_d(H)$ is a perfect matching or
sparser" — is unnecessary: the bound is unconditional on these graphs. If $G_d(H)$ *is* a
perfect matching then $\alpha_d=k/2$ exactly; deleting edges only increases $\alpha$
(independence is monotone under edge deletion), which recovers the "or sparser" clause as a
special case.

> **Theorem 7 (exact equality characterisation).** $\alpha_d(H)=\lceil k/2\rceil$ **iff**
> $\nu_d(H)=\lfloor k/2\rfloor$, **iff** $G_d(H)$ has a perfect matching ($k$ even) or a
> near-perfect matching missing one vertex ($k$ odd), **iff** in terms of the $d$-run lengths:
> $$k\text{ even}:\ \text{every run has even length};\qquad
> k\text{ odd}:\ \text{exactly one run has odd length}.$$

*Proof.* $\alpha_d=k-\nu_d$ (Theorem 3) turns $\alpha_d=\lceil k/2\rceil$ into
$\nu_d=\lfloor k/2\rfloor$, which is the maximum possible, i.e. a (near-)perfect matching. In
run language, $\alpha_d=(k+o_d)/2$ equals $(k+\mathbf 1[k\text{ odd}])/2$ iff
$o_d=\mathbf 1[k\text{ odd}]$; and $o_d\equiv k\pmod2$ always. $\square$

> **Correction.** "A single Hamiltonian path in the $d$-graph" is **sufficient but not
> necessary**. $G_d(H)=P_k$ gives $\alpha=\lceil k/2\rceil$, but so does any union of even paths:
> for $k=4$, $H=\{0,d,100,100+d\}$ has $G_d(H)=P_2\sqcup P_2$ and $\alpha_d=1+1=2=\lceil4/2\rceil$
> while $G_d(H)$ is disconnected. The exact criterion is Theorem 7, a matching condition, not a
> connectivity condition. (Connectivity re-enters in §5, where it controls the *yield*.)

> **Theorem 8 (the exact occupancy threshold for any single-gap forcing).**
> $$\min_{\substack{H\ \mathrm{admissible}\\ |H|=k}}\ \alpha^\ast(H)\ =\ \Big\lceil\frac k2\Big\rceil,$$
> hence the least occupancy $m$ for which *some* admissible $k$-tuple has *some* forced gap is
> $$\boxed{\ m_{\min}(k)=\Big\lceil\frac k2\Big\rceil+1\ }$$
> and this is attained, for every $k\ge2$, at $d=2$.

*Proof.* Lower bound: Theorem 6 plus Theorem 1.

Attainment. Let $P=\prod_{p\le k}p$. For $k$ even set
$$H=\bigcup_{i=1}^{k/2}\{\,iP,\ iP+2\,\}.$$
*Admissible:* for $p>k$ we have $|H|=k<p$, so a class is omitted. For $p\le k$ every $iP\equiv0$,
so $H\bmod p\subseteq\{0,2\}$; for $p=2$ this is $\{0\}$ and for odd $p\le k$ it has $\le2<p$
elements. *Structure:* the only differences of $2$ inside $H$ are the $k/2$ listed pairs (all
other differences are $\equiv0$ or $\pm2\pmod P$ with $|{\cdot}|\ge P-2>2$), so $G_2(H)$ is a
perfect matching and $\alpha_2(H)=k/2$ by Theorem 7. For $k$ odd take the same construction with
$(k-1)/2$ pairs and one extra point $\big(\tfrac{k+1}{2}\big)P$, giving one $P_1$ run and hence
$o_2=1$, $\alpha_2=(k+1)/2=\lceil k/2\rceil$. $\square$

> **Corollary 8.1 (admissibility is combinatorially free).** For every finite $H_0$ with
> $|H_0|=k$ and every $\lambda$ divisible by $\prod_{p\le k}p$, the dilate $H=\lambda H_0$ is
> admissible and $\alpha_{\lambda d}(H)=\alpha_d(H_0)$ for all $d$, while $G_{d'}(H)$ is
> edgeless for $\lambda\nmid d'$. Hence the extremal theory of $\alpha_\bullet$ over admissible
> tuples is *identical* to that over arbitrary tuples.

*Proof.* Admissibility: as in Theorem 8 ($H\bmod p$ is a single class for $p\le k$; automatic
for $p>k$). $x\mapsto\lambda x$ is a graph isomorphism $G_d(H_0)\to G_{\lambda d}(\lambda H_0)$,
and a difference $d'$ realised in $\lambda H_0$ is a multiple of $\lambda$. $\square$

**Reading.** Admissibility does not obstruct the *threshold* at all — Theorem 8 exhibits
admissible tuples achieving the absolute minimum $\lceil k/2\rceil$ at the twin radius $d=2$
itself. What admissibility obstructs is the *yield*, via §6. The obstruction Factory IV §V
attributes to angular resolution is, in exact form, an **occupancy-density** obstruction:
forcing needs $m>k/2$, full stop.

---

## 5. Above threshold: the exact number of forced gaps (Turán function)

Theorem 1 answers "is a pair forced?". The extremal question one level up is "how many?".

> **Theorem 9 (exact forced-pair count).** Fix $H$, $d$, and let $\alpha=\alpha_d(H)$,
> $\nu=\nu_d(H)=k-\alpha$, and $c^{\mathrm{ev}}=c^{\mathrm{ev}}_d(H)$ the number of $d$-runs of
> even length. For $0\le m\le k$ put $i=(m-\alpha)^+$. Then
> $$E^d_{\min}(m):=\min_{|A|=m}e_{G_d(H)}(A)
> \ =\ \min\big(i,\ c^{\mathrm{ev}}\big)\ +\ 2\big(i-c^{\mathrm{ev}}\big)^+ .$$

*Proof.* **Single path.** In $P_\ell$, a $t$-subset $A$ induces a disjoint union of $b$ maximal
runs of sizes $t_1,\dots,t_b$, with $e(A)=\sum(t_i-1)=t-b$. Realising $b$ runs needs $b-1$
separating unchosen vertices, so $t+(b-1)\le\ell$, i.e. $b\le\min(t,\ell-t+1)$; and any such $b$
is realisable. Hence
$$f_\ell(t):=\min_{|A|=t}e_{P_\ell}(A)=t-\min(t,\ell-t+1)=\max(0,\ 2t-\ell-1).$$
(Consistency: $f_\ell(t)=0\iff t\le\lceil\ell/2\rceil=\alpha(P_\ell)$. ✓)

**Increment profile.** $f_\ell$ is convex on $\{0,\dots,\ell\}$, being $\max(0,\text{affine})$;
its increment sequence is
$$\ell\text{ even}:\ (\underbrace{0,\dots,0}_{\ell/2},\,1,\,\underbrace{2,\dots,2}_{\ell/2-1}),
\qquad
\ell\text{ odd}:\ (\underbrace{0,\dots,0}_{(\ell+1)/2},\,\underbrace{2,\dots,2}_{(\ell-1)/2}).$$
(Verify $\ell=4$: $f=0,0,0,1,3$, increments $0,0,1,2$. $\ell=5$: $f=0,0,0,0,2,4$, increments
$0,0,0,2,2$.)

**Assembly.** Minimising the separable convex $\sum_jf_{\ell_j}(t_j)$ subject to
$\sum_jt_j=m$, $0\le t_j\le\ell_j$, is solved by taking the $m$ smallest pooled increments
(standard greedy for separable convex objectives over a box-constrained simplex; convexity makes
the marginal costs nondecreasing within each component, so no exchange improves the greedy
choice). The pooled multiset contains $\sum_j\lceil\ell_j/2\rceil=\alpha$ zeros, then one $1$
for each even run ($c^{\mathrm{ev}}$ of them), then $\nu-c^{\mathrm{ev}}$ twos — total
$\alpha+\nu=k$ increments, as it must be. Taking the $m$ smallest gives the stated value.
$\square$

*Consistency check at $m=k$.* $E^d_{\min}(k)=c^{\mathrm{ev}}+2(\nu-c^{\mathrm{ev}})
=2\nu-c^{\mathrm{ev}}=(k-o_d)-c^{\mathrm{ev}}=k-c_d$, which is the total edge count of a forest
with $k$ vertices and $c_d$ components. ✓

> **Theorem 10 (the yield optimum is the Hamiltonian path — uniquely).** For every $H$, $d$, $m$,
> $$E^d_{\min}(m)\ \le\ \max\big(0,\ 2m-k-1\big),$$
> with equality (for some $m>\alpha_d$) **iff** $G_d(H)$ is a single path $P_k$, i.e. iff $H$ is
> an arithmetic progression with common difference $d$.

*Proof.* With $i=(m-\alpha_d)^+$, Theorem 9 gives
$E^d_{\min}(m)=\min(i,c^{\mathrm{ev}})+2(i-c^{\mathrm{ev}})^+\le 2i$, with equality iff $i=0$ or
$c^{\mathrm{ev}}=0$. Also $\alpha_d\ge\lceil k/2\rceil$ (Theorem 6), so
$2i\le 2m-2\lceil k/2\rceil\le 2m-k$.

*Case $c^{\mathrm{ev}}=0$* (all runs odd): then $o_d=c_d$ and $\alpha_d=(k+c_d)/2$, so
$E^d_{\min}(m)=2i=2m-k-c_d\le 2m-k-1$, with equality iff $c_d=1$, i.e. $G_d(H)=P_k$ with $k$
odd.

*Case $c^{\mathrm{ev}}\ge1$ and $i\ge1$:* $E^d_{\min}=2i-\min(i,c^{\mathrm{ev}})\le 2i-1
\le 2m-2\alpha_d-1\le 2m-k-1$, with equality forcing $\min(i,c^{\mathrm{ev}})=1$ and
$\alpha_d=k/2$ ($k$ even, all runs even by Theorem 7) and $c^{\mathrm{ev}}=c_d=1$: again
$G_d(H)=P_k$. Conversely $G_d(H)=P_k$ gives $E^d_{\min}(m)=f_k(m)=\max(0,2m-k-1)$. $\square$

So there are **two different optima**, and they are different tuples:

| objective | optimum | value |
|---|---|---|
| minimise the threshold $\alpha_d$ | any (near-)perfect $d$-matching (Thm 7) | $\alpha_d=\lceil k/2\rceil$ |
| maximise the yield $E^d_{\min}(m)$ | the single $d$-path, $H$ an AP (Thm 10) | $2m-k-1$ |

They agree at $m=\alpha_d+1$, where both force exactly one pair. Above threshold the path has
slope $2$ and the matching slope $1$:
$$G_d=\text{perfect matching}:\ E^d_{\min}(m)=m-\tfrac k2;\qquad
G_d=P_k:\ E^d_{\min}(m)=2m-k-1.$$

---

## 6. What admissibility actually costs: runs are short

> **Theorem 11 (run-length bound).** Let $H$ be admissible and suppose $H$ contains an
> arithmetic progression of $\ell$ terms with common difference $d$. Then every prime
> $p\le\ell$ divides $d$. Equivalently,
> $$\ell\ <\ q(d):=\text{the least prime not dividing }d,
> \qquad\text{and}\qquad \prod_{p<q(d)}p\ \Big|\ d .$$
> In particular the maximal $d$-run length in an admissible tuple satisfies
> $\ell\le q(d)-1=(1+o(1))\log d$.

*Proof.* If $p\le\ell$ and $p\nmid d$, then the sub-progression $\{a,a+d,\dots,a+(p-1)d\}$
reduces mod $p$ to $a+d\{0,\dots,p-1\}=\mathbb Z/p$, so $H$ covers every class mod $p$ —
contradiction. The asymptotic is $\theta\big(q(d)^-\big)\le\log d$ and the prime number
theorem. $\square$

> **Corollary 11.1 (the twin channel is always a matching).** For admissible $H$, every
> $2$-run has length $\le2$: $q(2)=3$. Hence $G_2(H)$ is a matching together with isolated
> vertices, $c^{\mathrm{ev}}_2=\nu_2$, and
> $$\alpha_2(H)=k-\nu_2(H)\ \ge\ \Big\lceil\frac k2\Big\rceil,\qquad
> E^2_{\min}(m)=\big(m-\alpha_2(H)\big)^+ .$$
> The twin channel is therefore *provably* stuck at yield slope $1$: it can attain the optimal
> threshold (Theorem 8) but never the optimal yield.

*Proof.* If $\{a,a+2,a+4\}\subseteq H$ then $H\bmod3\supseteq\{a,a+2,a+1\}=\mathbb Z/3$. With all
runs of length $\le2$ every run is a $P_1$ or a $P_2$, so $c^{\mathrm{ev}}=\#\{P_2\}=\nu_2\ge i$
for all $i\le\nu_2$, and Theorem 9 collapses to $\min(i,c^{\mathrm{ev}})=i$. $\square$

> **Theorem 12 (the yield optimum has a primorial radius).** If $H$ is admissible, $|H|=k$, and
> $E^d_{\min}$ attains the optimum $2m-k-1$ of Theorem 10, then $H$ is a $d$-AP of length $k$
> and therefore
> $$\prod_{p\le k}p\ \Big|\ d,\qquad\text{so}\qquad d\ \ge\ \prod_{p\le k}p=e^{(1+o(1))k}.$$

*Proof.* Theorem 10 gives $H$ a $d$-AP of $k$ terms; Theorem 5 gives the divisibility. $\square$

**This is the exact trade-off, and it is a theorem, not a heuristic.** Maximal forcing power per
unit of occupancy is achieved *only* by tuples whose forced gap is at least the primorial of $k$
— for $k=50$, $d\ge\prod_{p\le50}p$, a $63$-digit number. Small radii, and $d=2$ in particular,
are available (Theorem 8) but only in the matching regime, at yield slope $1$.

---

## 7. The sharp form of "bounded gaps cannot select a radius"

> **Theorem 13 (occupancy 2).** Let $|H|=k$ and $d>0$. The guarantee $S_H\ge2$ forces the gap
> $d$ **iff** $\alpha_d(H)=1$, **iff** $k=2$ and $H=\{h,h+d\}$.

*Proof.* By Theorem 1, forcing at $m=2$ means $\alpha_d(H)\le1$; since $H\ne\emptyset$,
$\alpha_d\ge1$, so $\alpha_d=1$. By Theorem 6, $1=\alpha_d\ge\lceil k/2\rceil$ forces $k\le2$.
If $k=1$ then $G_d$ is edgeless and $\alpha_d=1$ but no pair exists — the "forced" conclusion
$E_{H,d}\ge1$ is false, and indeed $S_H\ge2$ is vacuous for $k=1$; the criterion of Theorem 1 is
stated for $m\le k$, excluding this. So $k=2$, and $\alpha_d=1$ requires $G_d(H)$ to have its
one possible edge: $H=\{h,h+d\}$. Conversely such $H$ has $\alpha_d=1<2$. $\square$

> **Corollary 13.1 (the no-go is circular in the only surviving case).** For $H=\{h,h+d\}$
> admissible, $d$ must be even (otherwise $H\bmod2=\{0,1\}$), and the statement "at least $2$ of
> the $2$ positions are prime" **is** the statement "$n+h$ and $n+h+d$ are both prime". Occupancy
> $2$ forces a gap only in the degenerate case where the hypothesis equals the conclusion. This
> is the sharp form of Factory IV §V's assertion.

> **Theorem 14 (the $k=50$, $m=2$ ledger).** Let $H$ be *any* admissible tuple with $|H|=50$.
> Then for every $d>0$:
> $$\alpha_d(H)\ \ge\ 25,$$
> so **no** $d$ whatsoever is forced by occupancy $2$; nor by occupancy $3,4,\dots,25$. The
> least occupancy that can force any gap in a $50$-tuple is
> $$m_{\min}(50)=\Big\lceil\tfrac{50}{2}\Big\rceil+1=26,$$
> an exact deficit of $26-2=24$ over the Maynard–Tao/Polymath8b conclusion. Moreover this
> threshold *is* attainable at the twin radius: the tuple
> $H=\bigcup_{i=1}^{25}\{iP,iP+2\}$, $P=\prod_{p\le50}p$, is admissible with
> $\alpha_2(H)=25$, so
> $$\text{“}\ge26\text{ of these }50\text{ shifts are prime''}\ \Longrightarrow\ \text{twin primes.}$$

*Proof.* Theorem 6 with $k=50$; Theorem 1; Theorem 8's construction with $k=50$. $\square$

**The gap to Maynard, quantified exactly.** Forcing requires the occupancy *fraction*
$m/k>1/2$. The Maynard–Tao sieve delivers $\mathrm{DHL}(k,m)$ only for $k$ exponential in $m$:
$k\ge m^2e^{4m+6}$ suffices [CITED, §9], and the method's own ceiling is
$m\le\big(\tfrac12+o(1)\big)\log k$ at $\theta=1/2$ (respectively $(1+o(1))\log k$ under
Elliott–Halberstam), because the sieve criterion is $\theta M_k>2m$ with the variational
constant $M_k=\log k-O(1)$ [CITED-UNVERIFIED, §9]. Either way
$$\frac mk\ \le\ \frac{(1+o(1))\log k}{k}\ \longrightarrow\ 0,
\qquad\text{while forcing needs}\qquad \frac mk>\frac12 .$$
The two regimes are separated by an exponential, not a constant. **No improvement of the
Maynard–Tao numerology — not $k=50$, not $k=6$, not any fixed $k$ with $m=2$ — can ever cross
the threshold**, because the threshold is linear in $k$ and the method is logarithmic. This
sharpens Factory IV §V: the obstruction is not that the Fourier channel $E_{H,2}$ is one of
many (an "angular resolution" problem); it is that the occupancy density is on the wrong side of
$1/2$, and $1/2$ is exact.

**Corrected reading of Theorem 50's inequality.** Factory IV writes
$\alpha(G_d(H))\ge\lceil|H|/2\rceil$ "because $G_d(H)$ is a union of paths". The union-of-paths
claim is true and is Theorem 2 here (it needs the acyclicity argument, not just $\Delta\le2$),
and the inequality does consume it — via bipartiteness or via $\alpha=k-\nu$; the same
inequality is false for graphs of the same matching number in general (§2, Remark).

---

## 8. Prior art (searched **before** the write-up, per `CLAUDE.md`)

- **Extremal sets avoiding a fixed difference.** The infinite/density analogue of Theorems 6–7 is
  classical: Motzkin's problem on sets with missing differences, solved for $|M|\le2$ by
  **Cantor and Gordon, "Sets of integers with missing differences", JCTA 14 (1973)**, giving
  $\mu(\{d\})=1/2$ for a single forbidden difference. Theorems 3, 6, 7 are the exact finite
  version on an arbitrary host set $H$ (with the extra content that the exact value is
  $k-\nu_d$, and the equality characterisation). **Grade: rederivation of a classical density
  fact, with new exact finite content.** No novelty is claimed for the $1/2$.
- **$\alpha,\nu$ of a union of paths; König/Gallai.** Folklore. Reproved here in closed form so
  the note is self-contained.
- **Theorem 9's $f_\ell(t)=\max(0,2t-\ell-1)$** is the standard "runs and gaps" count; the
  assembled Theorem 9 and the yield dichotomy of Theorem 10 I did not find in the literature and
  do not claim as new without a fuller search (obligation recorded in §10).
- **Theorem 11 / Corollary 11.1** (admissibility caps $d$-runs at $q(d)-1$; $G_2$ is a matching)
  is elementary and is surely known to specialists in prime tuples, though I have not located a
  statement of it; the corollary "the twin channel of an admissible tuple is always a matching"
  is the form worth quoting.
- **Factory IV §V / Theorem 50** is the local antecedent, and the audit note
  `notes/FACTORY_IV_CHEN_CORNER_AUDIT.md` §3 already grades it "correct, standard, and the right
  explanation". This note supplies what §3 says is missing: the development.

---

## 9. Honesty ledger

**Modelling choice (the one place a reader may disagree).** "Forcing" is defined as a
combinatorial entailment, uniform over occupancy subsets (§0). This is the right notion for
grading a sieve output that names no positions, and it is what Factory IV's "$m>\alpha$"
already means. It is *not* a claim that every independent set is arithmetically realised: for a
particular $H$, some independent $A$ might never occur as $A(n)$. The theorems below the
definition are therefore statements about **what a sieve theorem of the stated shape can and
cannot entail**, not about the primes. A stronger arithmetic input naming positions would escape
Theorem 13 — and no such input exists.

**Citations.** Two external facts are used only in the closing quantification of §7 and in
§8, and are graded:
- `CITED` — Polymath8b: $k=50$ suffices for $m=2$ at $\theta=1/2$, and Engelsma's admissible
  $50$-tuple of diameter $246$ is of minimal diameter; hence $H\le246$. (The task framing
  attributes $k=50$ to Maynard; Maynard's own paper gives $k=105$ with $H\le600$. Corrected.)
  Verified against the Polymath wiki and the Polymath8b retrospective (arXiv:1409.8361).
- `CITED` — Maynard, *Small gaps between primes* (arXiv:1311.4600): $\mathrm{DHL}(k,m)$ holds
  for $k\ge m^2e^{4m+6}$, and $H_m\le m^3e^{4m+5}$.
- `CITED-UNVERIFIED` — the Polymath8b asymptotic $M_k=\log k-O(1)$ and the consequent method
  ceiling $m\le(\tfrac12+o(1))\log k$ at $\theta=1/2$. I did not read the source in this
  session. **Nothing in §§1–6 depends on it**; it enters only to say that $m/k\to0$, which
  already follows from the verified $k\ge m^2e^{4m+6}$.

**No numerics.** No experiment was run; no constant was fitted; no Python was executed and
`MATH_ALLOW_PYTHON` was not set. Every count in §§1–7 is derived by hand, and the six worked
instances (after Theorem 4, after Theorem 9, in §4's counterexample, in §11's $k=4$ case) are
hand verifications of proved formulas, not measurements. Per `CLAUDE.md`: the theorem each would
have replaced is stated *and proved* in the same place.

**What is conjectural.** Exactly §11, and it is labelled there. Nothing in §§1–7 is
conjectural.

**Corrections issued.** Three, all against material this note received:
1. $\max_d\alpha_d(H)=k$ for every $H$ (§4), so the design problem as literally posed —
   minimise $\max_d\alpha_d$ — is vacuous. Replaced by $\alpha^\ast=\min_d\alpha_d$.
2. "Hamiltonian path" is sufficient but not necessary for $\alpha_d=\lceil k/2\rceil$ (§4,
   Correction). The exact criterion is a (near-)perfect matching. The Hamiltonian path *is* the
   exact optimum for a different objective (Theorem 10) — the two were conflated.
3. $k=50$ is Polymath8b, not Maynard (§9).

---

## 10. Queue

- `PROVE` Theorem 9's greedy step is stated with the standard separable-convex argument. Write
  it out as an exchange argument in `formal/cubical/` (the objects are finite lists of naturals;
  this is an Agda-sized statement, not a Lean one).
- `PROVE` Conjecture A below for $k=6,8$ by hand (the $k=4$ case is done in §11).
- `SEARCH` Theorems 9–10 (minimum induced edges of an $m$-subset of a linear forest; the
  slope-1 vs slope-2 dichotomy) against the extremal-graph literature — likely known as a
  "Turán problem for paths in linear forests". Discharge before any novelty claim.
- `SEARCH` Theorem 11 / Corollary 11.1 in the prime-tuples literature (Hensley–Richards,
  Engelsma's admissible-tuple tables, Polymath8a §"narrow admissible tuples") — the constraint
  "no $3$-term AP of difference $2$" is exactly the kind of thing tuple-search code enforces, so
  a statement probably exists.
- `PROVE` the exact value of $\max_H\nu_2(H)$ over admissible $H$ with prescribed diameter
  (Theorem 8 gives $\lfloor k/2\rfloor$ with unbounded diameter; the diameter-constrained
  version is the quantity a real tuple search would want).

---

## 11. Conjecture (clearly labelled: **CONJECTURE**, no computation behind it)

Define the **forced-gap set** and its extremal size
$$D_m(H):=\{d>0:\ m>\alpha_d(H)\}=\{d>0:\ \nu_d(H)\ge k-m+1\},\qquad
\Phi(k,m):=\max_{\substack{H\ \mathrm{admissible}\\|H|=k}}|D_m(H)| .$$

**What is proved.**

- (P1) $\Phi(k,m)=0$ for $m\le\lceil k/2\rceil$ (Theorem 6). Sharp: $\Phi(k,\lceil k/2\rceil+1)\ge1$
  (Theorem 8).
- (P2) $\Phi(k,k)=\binom k2$: at full occupancy every realised difference is forced, and
  $|(H-H)\cap\mathbb Z_{>0}|\le\binom k2$ with equality for a Sidon set, which may be taken
  admissible by Corollary 8.1.
- (P3) **Counting bound.** $\sum_{d>0}e_d(H)=\binom k2$ where $e_d=\#\{h\in H:h+d\in H\}$, and
  every $d\in D_m$ has $e_d\ge\nu_d\ge k-m+1$; hence
  $$\Phi(k,m)\ \le\ \frac{\binom k2}{\,k-m+1\,}.$$
  At $m=k$ this is tight (P2); at the threshold $m=\tfrac k2+1$ it gives $\Phi\le k-1$.
- (P4) **Cyclotomic obstruction at the threshold.** For $k$ even, $d\in D_{k/2+1}(H)$ iff
  $G_d(H)$ has a perfect matching, iff $H=B\sqcup(B+d)$, iff the $0/1$-polynomial
  $F_H(z)=\sum_{h\in H}z^{h-\min H}$ factors as $(1+z^d)B(z)$ with $B$ a $0/1$-polynomial.
  Since $\Phi_{2d}\mid 1+z^{d'}$ iff $d\mid d'$ and $2d\nmid d'$, the cyclotomics $\Phi_{2d}$ for
  distinct $d$ are distinct irreducible factors of $F_H$, so
  $$\sum_{d\in D_{k/2+1}(H)}\varphi(2d)\ \le\ \deg F_H=\operatorname{diam}(H).$$
- (P5) $\Phi(4,3)=2$. *Proof:* the largest difference of a $4$-set occurs exactly once, so
  $e_{d_{\max}}=1<2$; three differences each with $\nu=2$ would need $6=\binom42$ edges split
  $2{+}2{+}2$ over exactly three values, impossible. And $H=\lambda\{0,1,2,3\}$ achieves $2$
  (differences $\lambda,2\lambda$). Note $2=\tau(4/2)$.
- (P6) For the dilated interval $H=\lambda\{0,\dots,k-1\}$ ($k$ even,
  $\prod_{p\le k}p\mid\lambda$), $D_{k/2+1}(H)=\{\lambda e:\ e\mid k/2\}$ exactly, of size
  $\tau(k/2)$ (Corollary 4.1 + Corollary 8.1).

**CONJECTURE A (collapse at the matching threshold).** For $k$ even,
$$\Phi\big(k,\tfrac k2+1\big)\ =\ \tau(k/2)\ =\ \exp\!\Big(O\Big(\frac{\log k}{\log\log k}\Big)\Big)
\ =\ k^{o(1)},$$
attained by the dilated interval of (P6). In particular the counting bound (P3) overestimates by
a factor $k^{1-o(1)}$ at the threshold. *Basis:* (P5) is the only case verified; (P4) is the
mechanism (a perfect $d$-matching is a genuine polynomial factorisation, and distinct $d$ impose
distinct cyclotomic factors, which is a far stiffer constraint than edge-counting); the natural
competitor constructions — dissociated cubes $F=\prod_{i\le t}(1+z^{a_i})$, giving $t=\log_2k$,
and products of short intervals $\prod_i\frac{z^{n_i\delta_i}-1}{z^{\delta_i}-1}$, giving
$\prod_i\tau(n_i/2)$ — all tie with or lose to $\tau(k/2)$ by hand.

**CONJECTURE B (sharp transition).** Writing $m=k-j+1$ (so forcing $d$ means $\nu_d\ge j$):
$\Phi(k,k-j+1)=k^{2-o(1)}$ for every $j=o(k)$, and $\Phi(k,k-j+1)=k^{o(1)}$ only in the range
$j=(1/2-o(1))k$, i.e. the forced-gap set collapses from polynomial to sub-polynomial exactly at
the perfect-matching threshold and nowhere earlier. *Basis:* none beyond (P2), (P3), and
Conjecture A. **This is a conjecture in the strict sense of `CLAUDE.md`: it is a target for a
proof, not a summary of evidence, and it should not be cited as anything else.**

**What a proof of Conjecture A would buy.** It is the exact statement that a tuple cannot be
good at forcing *many different* radii at once — the combinatorial shadow of the "no singular
series ranks the radii" no-go of Factory IV §VI (Theorem 54). If both hold, the picture is
complete on the combinatorial side: an occupancy guarantee below $k/2$ forces nothing (Theorem
6), at $k/2+1$ forces at most $k^{o(1)}$ radii (Conjecture A), and the optimal-yield tuple has
primorial radius (Theorem 12). Nothing in that picture is available to a sieve with
$m=O(\log k)$.

---

*Signed:* **cf-swarm-turan**, 2026-08-16.
