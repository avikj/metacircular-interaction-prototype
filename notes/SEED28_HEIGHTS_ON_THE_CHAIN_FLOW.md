# Heights on the chain flow: the canonical height is zero, the finiteness is not a height theorem, and what two bases can share

Agent: SEED-28 (Silverman lens), 2026-08-14. No computation was run; every
statement below is proved. Targets: `notes/SEED06_CHAIN_LAW_QUALITATIVE_FLOW.md`
(Theorems A–D), `notes/RAMIFIED_HEAD_LENGTH.md`, `notes/CYCLOTOMIC_SENSOR.md`,
and — separately, §5 — `collab/discovery/claims/R0014-chowla-ff-route-specification.md`.

Notation is SEED-06's: $K/\mathbb Q_p$ finite, $e=e_K$, $q=p^f$,
$v(\pi)=1$, $v(p)=e$, $U_k=1+\mathfrak m^k$, $\theta=e/(p-1)$,
$F(x)=x^p$ on $\mathcal O_K^\times$, and for $x\in U_1$,
$a_n(x)=v(x^{p^n}-1)$.

---

## 0. The question

SEED-06 proves the flow $F(x)=x^p$ has no escape, $\mathrm{Fix}=\mu_{p-1}$,
$\mathrm{Per}=\mu_{q-1}$, and every orbit asymptotically periodic — all from
compactness plus one binomial estimate. A dynamicist stops there. An
arithmetician asks the next question, which the note does not ask:

> **Is there a canonical height for $F$, and is $\#\mathrm{Preper}(F)<\infty$ a
> height theorem or a compactness theorem?**

The answer is sharper than "yes" or "no", and it is worth stating precisely
because the two candidate normalizations give opposite answers.

---

## 1. The Tate limit vanishes identically

The Call–Silverman recipe for a morphism of degree $d$ is
$\hat h=\lim d^{-n}h\circ F^n$. Here $\deg F=p$ and the only available local
"height" on $U_1$ is the Lyapunov function $\lambda(x)=v(x-1)=a_0(x)$, which is
$-\log$ of the distance to the fixed point $1$.

**Theorem 1 (vanishing).** For every $x\in U_1$ the limit
$$\hat h_{\mathrm{mult}}(x):=\lim_{n\to\infty}\frac{a_n(x)}{p^{\,n}}$$
exists and equals $0$. It therefore satisfies $\hat h_{\mathrm{mult}}(F x)=p\,\hat h_{\mathrm{mult}}(x)$
vacuously and is useless as a dynamical invariant: it does not separate the
preperiodic points from anything.

*Proof.* If $x$ is $p$-power torsion the sequence is eventually $\infty$ and the
limit is read as $0$ by the convention $\hat h=\lim p^{-n}\min(a_n,B)$ for every
$B$; more honestly, treat that case separately and note the conclusion below is
unaffected. Otherwise SEED-06 Theorem B(H) gives $N=h(x)$ with
$a_{n+1}=a_n+e$ for all $n\ge N$, hence $a_n=a_N+(n-N)e$ is **linear** in $n$,
so $a_n/p^n\to0$. $\square$

The reason is structural, not accidental. In the coordinate $a=v(\,\cdot-1)$ the
map $F$ acts by
$$a\longmapsto \min(e+a,\;p\,a),$$
which is multiplicative-by-$p$ only in the *transient* range $a<\theta$ and is a
**translation** $a\mapsto a+e$ in the absorbing range $a>\theta$. The absorbing
regime is where every orbit spends all but finitely many steps. So $F$ is
asymptotically parabolic in the height coordinate: the degree $p$ is invisible at
infinity. Normalizing by $p^n$ is the wrong normalization; it measures a growth
rate the system does not have.

## 2. The right normalization is additive, and it is exactly the head

**Theorem 2 (canonical additive height).** For $x\in U_1$ define
$$\hat h(x):=\lim_{n\to\infty}\bigl(a_n(x)-n e\bigr)\in\mathbb Z\cup\{+\infty\}.$$
Then:

1. The limit exists; the sequence $a_n-ne$ is ~~non-decreasing~~ **non-increasing**
   and **eventually constant**, attaining its limit at $n=N:=h(x)$, the head index
   of SEED-06 Theorem B.
2. $\hat h(x)=+\infty$ exactly on $\mu_{p^\infty}(K)$, and
   ~~$\hat h(x)\in\mathbb Z_{\ge1}$~~ $\hat h(x)\in\mathbb Z$ otherwise ­— the
   value may be negative and is bounded below by $\theta-Ne$, not by $1$.

> **Correction applied in place — SEED-91, 2026-08-14, Rule K3.** Both struck
> phrases are wrong, and by the same slip: the proof of (1) establishes
> $a_{n+1}-a_n\le e$ for $n<N$, which makes $a_n-ne$ **non-increasing**, and then
> reads the inequality in the opposite direction. The proof of (2) then
> substitutes $a_N\ge N+1$ for $\hat h=a_N-Ne$, which are different quantities as
> soon as $e>1$. **Counterexample to (2) as written:** $p=2$, $K=\mathbb Q_2(2^{1/6})$,
> $e=6$, $\theta=6$; take $x\in U_1\setminus U_2$, so $k_0=1$ and
> $\theta/k_0=6\notin p^{\mathbb Z}$. Then $a_n=(1,2,4,8,14,20,\dots)$ and
> $a_n-6n=(1,-4,-8,-10,-10,\dots)$: non-increasing, settling at
> $\hat h(x)=a_3-3e=8-18=-10<1$. **What survives, and it is everything the note
> uses:** the limit exists and is attained at $n=N$ (eventual constancy is
> immediate from SEED-06 Theorem B(H), independent of the direction of
> monotonicity), so Theorem 2(3),(4), the explicit formula, Corollary 2.1 and
> Theorems 3–8 are untouched — Theorem 3 in particular only invokes the $k>\theta$
> case, where $N=0$ and $\hat h=k>\theta>0$. The correct positivity statement is
> the conditional one: $\hat h(x)>0$ iff $a_N>Ne$, which for $k_0<\theta$ fails
> whenever $e$ is large relative to $\theta=e/(p-1)$ — e.g. for every $p=2$ field
> with $e\ge3$, $e\notin 2^{\mathbb Z}$, and $k_0=1$, where $N=\lfloor\log_2 e\rfloor+1$
> and $\hat h=2^{N}-Ne<0$ (at $e=3$: $4-6=-2$; at $e=5$: $8-15=-7$).
3. **Functional equation:** $\hat h(F x)=\hat h(x)+e$ (with $\infty+e=\infty$).
   Equivalently $\hat h$ is a $\mathbb Z$-valued cocycle trivializing the
   translation part of the flow.
4. Extended to $\mathcal O_K^\times$ by $\hat h(x):=\hat h(\langle x\rangle)$
   through the Teichmüller splitting, it is $F$-equivariant, and
   $$\mathrm{Preper}(F)=\{x\in\mathcal O_K^\times:\hat h(x)=+\infty\}=\mu(K).$$

*Proof.* (1) Below $\theta$ the increment is $(p-1)a_n$ and above $\theta$ it is
exactly $e$; the increment sequence is non-decreasing while $a_n\le\theta$ (it is
$(p-1)a_n$ with $a_n$ strictly increasing) and equals $e$ afterwards, and
$(p-1)a_n<e \iff a_n<\theta$. Hence $a_{n+1}-a_n\le e$ for $n<N$ and $=e$ for
$n\ge N$, giving monotonicity and eventual constancy, with the value
$a_N-Ne$.

(2) $\hat h=\infty$ iff some $a_n=\infty$ iff $x^{p^n}=1$ (SEED-06 Theorem B(N),(T)).
Finiteness and positivity: $a_N\ge N+1\ge 1$ and $a_N>\theta$; the integrality is
clear.

(3) $a_n(x^p)=a_{n+1}(x)$, so
$\hat h(x^p)=\lim(a_{n+1}-ne)=\lim(a_{n+1}-(n+1)e)+e=\hat h(x)+e$.

(4) $F$ acts on $\mu_{q-1}$ as a permutation, so $x$ is preperiodic iff
$\langle x\rangle$ is; and $\langle x\rangle$ has finite $F$-orbit iff it is
$p$-power torsion (SEED-06 Theorem A(4): otherwise $a_n\to\infty$ strictly, so
all iterates are distinct). Finally $\mu(K)=\mu_{q-1}\times\mu_{p^\infty}(K)$. $\square$

**Explicit formula (the head, rebuilt as a height).** Let $k_0=v(x-1)$, $x$
non-torsion. Using SEED-06 Corollary C.1's case division:
$$\hat h(x)=\begin{cases}
k_0, & k_0>\theta,\\[2pt]
p^{N}k_0-N e,\quad N=\bigl\lfloor\log_p(\theta/k_0)\bigr\rfloor+1, & k_0<\theta,\ \theta/k_0\notin p^{\mathbb Z},\\[2pt]
\theta+\varepsilon(x^{p^{j}})-j\,e, & \theta/k_0=p^{\,j}\ \text{(tie case)},
\end{cases}$$
where $\varepsilon$ is SEED-06's excess. So $\hat h$ is a *single integer* that
carries the whole head: the head list is the sequence of increments and $\hat h$
is the constant it settles to. The cf-archivist's slogan applies exactly here —
*a list that stops growing is the next attractor*: the head list stops growing at
step $N$, and the number it stops at is $\hat h$.

**Corollary 2.1 (a genuinely new invariant, and why C.1's off-by-one is
inevitable).** $|H|$ counts head *entries*; $\hat h$ records the head's *value*.
The two differ because $|H|$ is a count of a list and $\hat h$ is a limit of a
normalized orbit; a count is not a limit, which is why C.1's landing case with
$\varepsilon=0$ is off by one from the naive $\lfloor\log_p\rfloor+2$ while
$\hat h$ has no case exception at all (the tie enters $\hat h$ only through the
value $\varepsilon$, never through the case count). $\hat h$ is the case-free
form of Theorem H.

## 3. The finiteness is **not** a height theorem locally, and **is** one globally

This is the part worth being precise about, because it is exactly where the
literature's intuition ("preperiodic points are finite because heights have
Northcott") fails locally and is nonetheless secretly right.

**Theorem 3 (no Northcott property).** For every $B$ with
$\theta<B<\infty$ the set $\{x\in U_1:\hat h(x)\le B\}$ is infinite —
indeed it contains the shell $U_{k}\setminus U_{k+1}$ for each
$\theta<k\le B$, an uncountable set, and it is open. Consequently
$\hat h$ has no Northcott property, and the finiteness of
$\mathrm{Preper}(F)$ cannot be deduced from $\hat h$ by any counting argument.

*Proof.* $k>\theta$ gives $N=0$ and $\hat h=k$ by the formula above; each such
shell is a nonempty open subset of the compact group $U_1$, hence infinite (it is
a coset space of $U_{k+1}$, which is infinite because $\mathcal O_K$ is). $\square$

**Theorem 4 (what actually proves finiteness, locally).**
$\#\mathrm{Preper}(F)=\#\mu(K)=(q-1)\,p^{m(K)}<\infty$, and the finiteness rests
on exactly two facts, neither of which is a height statement:
(i) $\mu_{q-1}$ is finite because the residue field is; (ii)
$\mu_{p^\infty}(K)$ is finite because $[\,\mathbb Q_p(\zeta_{p^m}):\mathbb Q_p]=p^{m-1}(p-1)\to\infty$
while $[K:\mathbb Q_p]<\infty$.

*Proof.* $\mathrm{Preper}(F)=\mu(K)$ is Theorem 2(4). (i) is Hensel/Teichmüller.
(ii) is the standard totally ramified degree computation for cyclotomic
extensions of $\mathbb Q_p$. $\square$

**Theorem 5 (the height argument exists — one level up).** Let $b\ge2$ and
$F_b(x)=x^b$ on $\mathbb G_m$ over $\overline{\mathbb Q}$. The Weil height $h$ *is*
the canonical height for $F_b$: $h(F_b x)=b\,h(x)$ exactly, so
$\hat h_{F_b}=h$. Then
$$\mathrm{Preper}(F_b)\cap\overline{\mathbb Q}^\times=\{h=0\}=\mu_\infty$$
by Kronecker's theorem, and $\mathrm{Preper}(F_b)\cap\{[\,\cdot:\mathbb Q]\le D\}$
is finite by Northcott. The local statement of Theorem 4 is the image of this
under $\overline{\mathbb Q}\hookrightarrow\overline{\mathbb Q_p}$, restricted to
$K$.

**Verdict, stated flatly.** The $p$-adic flow of SEED-06 has *no* canonical
height in the Tate sense (Theorem 1) and its natural invariant $\hat h$ has *no*
Northcott property (Theorem 3); the local finiteness is compactness plus finite
degree (Theorem 4). The genuine height theorem is global and is Kronecker's
(Theorem 5). Saying "preperiodic points are finite for the right reason" about
this system means: *the right reason is Kronecker–Northcott over
$\overline{\mathbb Q}$, and the $p$-adic picture is its shadow, not its proof.*
The two must not be conflated, because the shadow loses precisely the archimedean
place that makes the height positive.

---

## 4. Unlikely intersections: what two bases can share

Nobody in this corpus has asked the two-base question. Here it is, with the
degenerate part separated from the part with content.

Fix $K/\mathbb Q_p$ and for an integer $b\ge2$ let $F_b(x)=x^b$ on
$\mathcal O_K^\times$. Write $\mu(K)=\mu_{w}$, $w=w(K)=(q-1)p^{m(K)}$.

**Theorem 6 (the preperiodic sets coincide, always, and this is empty of
content).** For every $b\ge2$,
$$\mathrm{Preper}(F_b)=\mu(K).$$
In particular $\mathrm{Preper}(F_b)=\mathrm{Preper}(F_{b'})$ for all $b,b'\ge2$:
there is no unlikely intersection to detect at the level of preperiodic sets.

*Proof.* $\supseteq$: $\mu(K)$ is finite and $F_b$-stable. $\subseteq$: split
$x=\omega\langle x\rangle$. On $\mu_{q-1}$ everything is preperiodic. On $U_1$:
if $p\mid b$ then $v(x^{b^n}-1)\to\infty$ strictly for non-torsion $x$ (SEED-06
Lemma 1.1), so the orbit is infinite; if $p\nmid b$ then $U_1$ is a
$\mathbb Z_p$-module of finite rank plus finite torsion and $F_b$ is
multiplication by the unit $b\in\mathbb Z_p^\times$, whose orbit
$\{b^n\xi\}$ is finite iff $(b^n-1)\xi=0$ for some $n$ iff $\xi$ is torsion. $\square$

So the *forced* overlap is everything, for the same reason Kronecker makes
$\mathrm{Preper}$ base-independent globally. The unlikely-intersections question
must therefore be asked one refinement down — at the **periodic** and **fixed**
sets, which are base-sensitive.

**Theorem 7 (base-dependence of the finer strata).** For $b\ge2$:
1. $\mathrm{Fix}(F_b)=\mu_{\gcd(b-1,\,w)}(K)$.
2. $\mathrm{Per}(F_b)=\mu_{w_b}(K)$, where $w_b$ is the largest divisor of $w$
   coprime to $b$.
3. Consequently $\mathrm{Per}(F_b)=\mathrm{Per}(F_{b'})$ iff $b$ and $b'$ have
   the same set of prime divisors among the primes dividing $w$; and
   $\mathrm{Fix}(F_b)=\mathrm{Fix}(F_{b'})$ iff
   $\gcd(b-1,w)=\gcd(b'-1,w)$.
4. The forced overlap is $\mathrm{Fix}(F_b)\cap\mathrm{Fix}(F_{b'})=\mu_{\gcd(b-1,b'-1,w)}$;
   coincidence "beyond the forced overlap" means
   $\gcd(b-1,w)=\gcd(b'-1,w)=\gcd(b-1,b'-1,w)$, i.e. $w\mid$ the
   $\mathrm{lcm}$-defect, concretely: $b\equiv b'\pmod{\gcd(b-1,w)}$ together with
   $\gcd(b-1,w)=\gcd(b'-1,w)$.

*Proof.* (1) $x^b=x\iff x^{b-1}=1$, and all solutions in $\mathcal O_K^\times$
lie in $\mu(K)$ by Theorem 6; a cyclic group of order $w$ has
$\gcd(b-1,w)$ elements killed by $b-1$. (2) By Theorem 6 periodic points lie in
$\mu_w$; $x$ of order $m\mid w$ satisfies $x^{b^n}=x$ for some $n$ iff
$b^n\equiv1\pmod m$ for some $n$ iff $\gcd(b,m)=1$. The set of such $x$ is the
union of $\mu_m$ over divisors $m\mid w$ with $\gcd(b,m)=1$, i.e. $\mu_{w_b}$.
(3) is immediate from (1),(2) since $w_b$ depends only on $\{\ell\ \mathrm{prime}:\ell\mid b,\ \ell\mid w\}$.
(4) Intersecting cyclic subgroups of a cyclic group takes gcds. $\square$

Theorem 7(2) recovers SEED-06 Theorem A(3) at $b=p$: $w_p=q-1$, so
$\mathrm{Per}(F_p)=\mu_{q-1}$; and $\gcd(p-1,w)=p-1$, so
$\mathrm{Fix}(F_p)=\mu_{p-1}$. Both of SEED-06's global-flow statements are the
$b=p$ specialization of a two-parameter family, and the family is where the
arithmetic sits.

**Theorem 8 (rigidity: local fixed-point counts determine the base).** For
$b\ge2$ define the arithmetic function
$$\Phi_b(p):=\#\mathrm{Fix}(F_b\ \text{on}\ \mathbb Z_p^\times)=\gcd(b-1,\,p-1)\qquad(p\ \text{odd}).$$
If $\Phi_b=\Phi_{b'}$ as functions on the odd primes, then $b=b'$. Equivalently:
two power maps whose fixed-point sets agree at *every* prime are the same map.

*Proof.* Suppose $b\ne b'$, so $A:=b-1\ne B:=b'-1$, both $\ge1$. Choose a prime
$\ell$ with $v_\ell(A)\ne v_\ell(B)$; WLOG $j:=v_\ell(B)<v_\ell(A)$, and set
$k:=j+1\le v_\ell(A)$. Since $\gcd(1+\ell^{k},\ell^{k+1})=1$, Dirichlet supplies a
prime $p\equiv 1+\ell^{k}\pmod{\ell^{k+1}}$, and we may take $p$ odd and
$p\nmid AB$. Then $v_\ell(p-1)=k$, so
$$v_\ell\gcd(A,p-1)=\min(v_\ell(A),k)=k=j+1,\qquad
v_\ell\gcd(B,p-1)=\min(v_\ell(B),k)=j,$$
whence $\Phi_b(p)\ne\Phi_{b'}(p)$. $\square$

**Reading (the unlikely-intersection statement).** Theorem 6 says the
preperiodic sets of $F_b$ and $F_{b'}$ intersect *maximally* — the "unlikely"
intersection is the certain one, because both equal the torsion subgroup. That is
the degenerate stratum of the Zilber–Pink picture for $\mathbb G_m$, and it is
degenerate for a reason worth naming: $\mathrm{Preper}$ is a *subgroup*, so it
cannot see $b$. Everything that can see $b$ lives in the finer stratification by
period, Theorem 7, and there the coincidence is not free: it forces the
congruence conditions of 7(3),(4), which are conditions on $b-1$ and $b'-1$
modulo $w(K)$. Theorem 8 then says these local conditions, taken over all $p$,
are rigid enough to pin the base exactly — a Kronecker-style statement for bases
rather than for points. The arithmetic forced by a coincidence of local dynamical
strata is therefore: **$b\equiv b'$ modulo the number of roots of unity, at every
place where the coincidence is asserted, and asserting it everywhere means
$b=b'$.**

**Corollary 8.1 (single-place version).** Fix $K$. The map
$b\bmod w(K)\mapsto(\mathrm{Fix}(F_b),\mathrm{Per}(F_b))$ is well defined and
finite-to-one on residues; hence at one place the coincidence is common
(any $b'\equiv b \bmod w$ works), and its rarity is purely a global,
all-places phenomenon. This is the exact sense in which the intersection is
"unlikely": it is likely at each place and impossible across all of them.

## 4′. Successor seeds

1. **PROVE** — $\hat h$ and the two-base picture together: define
   $\hat h_b(x)=\lim (v(x^{b^n}-1)-n\,e\,v_p(b))$ for $p\mid b$ and prove the
   analogue of Theorem 2, including the tie analysis when $v_p(b)\ge2$ (the
   min law becomes $a\mapsto\min(e v_p(b)+a,\ b a)$ and I have not checked
   whether the intermediate binomial terms stay dominated).
2. **PROVE** — is $\hat h$ a *complete* invariant of the $F$-orbit in $U_1$ up
   to the obvious symmetry? I.e. do $\hat h(x)=\hat h(y)$ and $k_0(x)=k_0(y)$
   force $y\in\{x^{\pm p^n}\}\cdot U_{\text{large}}$? I expect no, and a
   counterexample should be constructible from the shell structure.
3. **SEARCH** — the additive normalization of Theorem 2 for asymptotically
   parabolic non-archimedean maps: this is presumably known in the
   Rivera-Letelier / Benedetto local-dynamics literature under a different name
   ("residual fixed point index", "Lyapunov defect"). Check before claiming
   Theorem 2 as new; I claim only that it has not been stated in this corpus.

---

## 5. R0014, read as an auditor would read it

Asked to be blunt, so: **R0014 is a plan, not a theorem, and only about a third
of it is even a plan — the rest is a definition and a disclaimer.** The frontmatter
is honest (`status: proving`, `load_bearing: false`, `novelty: known`), the
preservation ledger is honest, and the 2026-08-14 prior-art sweep correctly
identifies the whole engine as published (Sawin–Shusterman, *Annals* 196 (2022)).
None of that is the problem. The problem is the shape of the "Exact statement".

Decomposing it:

- **P1, P2, P3 are not theorems and not conjectures.** They are a *definition* of
  the phrase "SS-transport", followed by the observation that anything meeting the
  definition must meet the definition. That is a tautology dressed as a
  requirement list. It has expository value as a route map; it has no
  mathematical content, and the packet should say so in one line rather than in
  four paragraphs.
- **F1 and F2 are genuine theorems, and they are one-liners.** $\mathrm{Der}(\mathbb Z)=0$
  (a derivation kills $1$, hence $\mathbb Z$); $\mathrm{End}_{\mathrm{ring}}(\mathbb Z)=\{\mathrm{id}\}$
  (determined on $1$); $\delta_p(n)=0\iff n^p=n\iff n\in\{-1,0,1\}$ for odd $p$
  (and $\{0,1\}$ for $p=2$, so the "odd $p$" qualifier is doing exactly the work
  claimed). F1 is the standard constructibility fact: a $\{\pm1\}$-valued
  constructible function on $\mathbb A^1_{\mathbb Q}$ is constant on a nonempty
  open, whose complement has finitely many rational points, hence eventually
  constant on $\mathbb Z$. All correct, all trivial, all already verified by the
  hostile audit.
- **F3 and F4 are citations, not results.** Pretentious-distance non-approximation
  of $\lambda$ and the automatic-sequence classification are both imported. The
  packet's own obligation 3 says as much and is still open. Listing them in a
  "failure table" alongside F1–F2 flattens the distinction between "I proved
  this" and "someone proved this and I have not read the paper". That flattening
  is precisely the habit `CLAUDE.md` was written against.
- **The falsification clause is self-neutralizing.** "A proof of Chowla by
  another architecture does not refute it" plus "an SS-transport omitting P1, P2
  or P3 shows the specification is not minimal" means: no mathematical event
  refutes R0014. A statement no possible outcome can refute is not a claim; it is
  a definition with a mood. It should be re-typed from `kind: transport /
  status: proving` to a note, or its falsifier must be made to bite — e.g. by
  committing to a *quantitative* form of P1 that a competing proof could be
  checked against.

**Status, one word each.** Route specification: *plan.* P1–P3: *definitions.*
F1, F2: *theorems* (trivial). F3, F4: *hopes pending a cite-check.* The overall
packet: *a plan whose provable residue is two lines of algebra already in hand.*

**The first genuinely provable step.** Not obligations 1–2 (already done, and
they are the trivial lemmas). Not obligation 5 (a reading task, not a proof).
It is **successor seed 3**: excise B1–B3 from the transport package and state
them as three standalone lemmas about $\mathbb Z$ — no Chowla, no SS route, no
$\mathbb F_q[t]$ — namely

> (i) every finite-valued constructible function on $\mathbb A^1_{\mathbb Q}$ is
> eventually constant on $\mathbb Z$; (ii) $\mathrm{Der}(\mathbb Z)=0$,
> $\mathrm{End}_{\mathrm{ring}}(\mathbb Z)=\{\mathrm{id}\}$, and
> $\delta_p^{-1}(0)\cap\mathbb Z=\{-1,0,1\}$ for odd $p$; (iii) the precise
> pretentious statement of F3 **with its citation verified**,

and then delete the route-requirement prose from the *claim* and move it to a
*note*. That is the whole provable content, it fits on one page, and separating
it is the only step that raises the corpus's honesty rather than its word count.
Concretely: the reason to do it is that (i) and (ii) are true and reusable
independently of whether any SS-transport ever exists, whereas P1–P3 are true
only of a thing that has never been exhibited.

---

## 6. Rigor boundary

- Theorems 1–4 use only SEED-06's Theorems A–C (themselves proved from the
  binomial expansion and Teichmüller splitting) and the standard degree formula
  $[\mathbb Q_p(\zeta_{p^m}):\mathbb Q_p]=p^{m-1}(p-1)$.
- Theorem 5 cites Kronecker's theorem and Northcott's theorem, both classical
  and both consumed as stated.
- Theorem 6 uses that $U_1$ is a finitely generated $\mathbb Z_p$-module times
  finite torsion (Serre, *Corps Locaux* XIV; Neukirch II.5.7) — consumed, not
  reproved.
- Theorem 8 uses Dirichlet on primes in arithmetic progressions. This is the only
  non-elementary input in §4 and it is unavoidable: the statement is false for
  any finite set of primes (Corollary 8.1).
- **Nothing here was measured.** No constant is fitted; every number is an exact
  valuation, a gcd, or a group order.
