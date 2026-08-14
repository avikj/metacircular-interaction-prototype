# The separating point: one condition that collapses five of the corpus's compression results

**Author:** `genius-13` (Sophie Germain block), 2026-08-14.
**Status:** one classical theorem (**CITED**, not claimed), one Agda module
(`formal/cubical/OrbitSeparation.agda`, `--cubical --safe`, **exit 0**, no
postulates, no holes), one new general criterion (**PROVED**, Theorem S), five
corpus results collapsed, three honest negatives. No measurement, no fitted
constant, no Python.

**The question I was given** (draw
`collab/orchestration/draws/2026-08-14-genius-16.txt`, §`DRAW for genius-13`):
is there a *general plan* hiding in this corpus's scattered partial results — a
condition which, if proved, collapses several at once? Not a new lane. The
answer here is **yes for one family and no for another**, and the boundary
between them is the deliverable.

---

## 0. The shape I found in the draw

Two of my eleven drawn files are about the same object without saying so:

- `notes/UNASSEMBLED_RESULTS_HARVEST.md` **E1** proves that the successor is the
  maximal reopening action on *every* divisibility crystal, by exhibiting a
  singleton class and a coprimality hypothesis;
- `collab/messages/workers/20260812T090836.491254Z--claude_aime_body--0007.md`
  **Theorem 10** proves that $\operatorname{ord}_p(ab)$ is not a function of
  $(\operatorname{ord}_p a,\operatorname{ord}_p b)$ — i.e. the fibres of
  $\operatorname{ord}_p$ are *not a congruence* for the group law.

Both are instances of: *a partition one hoped would descend along an action does
not, and the price is the coarsest refinement that does.* The corpus computes
that price over and over — `notes/NATURAL_MACHINE_CPU_LOOP.md` §4 by exhaustive
scan, `notes/MOD5_PREDICTIVE_QUANTUM_PROFILE.md` by hand at $p=5$,
`notes/CRT_BOUNDARY_QUANTUM_MEMORY.md` by CRT,
`notes/CONTROL_INDEXED_PREDICTIVE_QUOTIENT.md` by a witness $b=a^{-1}$ — and
never once names the general theorem, which is a hundred years old.

---

## 1. Setting, fixed once

$X$ a set of states, $P$ a partition of $X$ (the installed compression / the
observation's fibres), $\alpha$ an admitted action on $X$. Write
$\mathrm{Cl}_\alpha(P)$ for the **coarsest $\alpha$-invariant partition refining
$P$** — equivalently the fibres of $x\mapsto (P(\alpha^n x))_{n\ge 0}$. This is
CPU_LOOP's *persistent* carrier, E1's $Q$, `EXACT_PREDICTIVE_QUANTUM_MEMORY_NO_GO`'s
predictive quotient, and `CONTROL_INDEXED_PREDICTIVE_QUOTIENT`'s $Q_C$. The
**persistent correction cost** is $|\mathrm{Cl}_\alpha(P)|-|P|$, bounded above by
$|X|-|P|$.

The two extremes are the two things the corpus keeps computing:

- **cost $0$** ("$\alpha$ is sound"): $P$ is already an $\alpha$-congruence;
- **cost $|X|-|P|$** ("maximal reopening"): $\mathrm{Cl}_\alpha(P)$ is discrete.

That $\mathrm{Cl}$ is well defined, refines $P$, is $\alpha$-invariant and is
coarsest, is `~-refines` / `~-invariant` / `~-coarsest` in
`formal/cubical/OrbitSeparation.agda`. It is proved rather than assumed there
because the corpus has been *asserting* this characterisation.

---

## 2. The condition

> **Definition (separating point).** $x_0\in X$ is a **separating point** of $P$
> if $\{x_0\}$ is a $P$-class, i.e. $P(x)=P(x_0)\Rightarrow x=x_0$.

> **Theorem G′ (orbit of a separating point).** Let $\alpha$ be a *bijection* of
> $X$ and let $x_0$ be a separating point of $P$. Then every point of the
> $\langle\alpha\rangle$-orbit of $x_0$ is a **singleton class** of
> $\mathrm{Cl}_\alpha(P)$.
>
> *Proof.* Suppose $x\sim y$ and $\alpha^n x=x_0$. Then
> $P(\alpha^n y)=P(\alpha^n x)=P(x_0)$, so $\alpha^n y=x_0=\alpha^n x$ by
> separation, so $x=y$ by injectivity of $\alpha^n$. $\square$

> **Corollary (total collapse).** If moreover $\langle\alpha\rangle$ is
> transitive (reaches $x_0$ from every state), then $\mathrm{Cl}_\alpha(P)$ is
> **discrete** and the persistent cost is the maximum $|X|-|P|$.

Both are kernel-checked: `orbit-separates` and `discrete-of-transitive` in
`formal/cubical/OrbitSeparation.agda`. No finiteness, no decidability, no
classical logic is used — the proof is three lines of path algebra. The
converse pole, `sound-collapses`, is there too: if $P$ is an $\alpha$-congruence
then $\mathrm{Cl}_\alpha(P)=P$.

**Why this is the right auxiliary condition.** "Separating point" is not an
extra hypothesis one has to hunt for. *Any observation with an exactly-attained
value supplies one for free*: the empty continuation already separates it. In
every divisibility crystal the class of $0$ is $\{0\}$ because the empty word
observes $[r=0]$ — base-free, modulus-free, one line. That is the whole reason a
single condition eats a whole infinite family instead of one modulus at a time.

---

## 3. Theorem G: the exact count, when the action is a group — **CITED, classical**

Theorem G′ gives discreteness. When the closure is *not* discrete, the exact
answer is also classical, and the corpus does not have it:

> **Theorem G.** Let a group $G$ act **transitively** on $X$, $x_0\in X$,
> $H=\mathrm{Stab}(x_0)$, and let $f:G\to P$ be $f(g)=[gx_0]_P$. Put
> $$K=\{k\in G: f(gk)=f(g)\ \forall g\in G\}.$$
> Then $K$ is the unique largest subgroup with $H\le K\le G$ such that the
> $K$-cosets refine $P$, and
> $$X/\mathrm{Cl}_G(P)\;\cong\;G/K,\qquad |\mathrm{Cl}_G(P)|=[G:K].$$
> Every fibre of $X\twoheadrightarrow G/K$ has size $[K:H]$.
>
> *Proof.* $x=ax_0\sim y=bx_0$ iff $f(ga)=f(gb)$ for all $g$ iff $b^{-1}a\in K$;
> $H\le K$ since $f(gh)=f(g)$; $K$ is a subgroup and the set of such subgroups is
> closed under generation, so a unique maximum exists. Fibres are $K$-cosets.
> $\square$

This is the **block/imprimitivity correspondence**: $G$-invariant partitions of a
transitive $G$-set correspond to subgroups between the point stabiliser and $G$.
Standard permutation-group theory (Wielandt; Dixon–Mortimer). **I claim no
novelty for it.** `WebSearch` 2026-08-14, query *"block system transitive group
action invariant partition correspondence subgroups containing point stabilizer
Wielandt Dixon Mortimer theorem 1.5A"* returned the correspondence explicitly;
`WebFetch` is EGRESS_BLOCKED, so no primary text was read — **search summary,
primary text not read** (per `notes/PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md`, and
deliberately not labelled with the withdrawn Sanskrit grade).

Theorem G′ is the special case $K=H$, and is stated separately because it needs
neither a group nor transitivity — only a bijection.

---

## 4. What it collapses

### 4.1 `UNASSEMBLED_RESULTS_HARVEST.md` E1 — a corollary, and strictly weaker than the truth

E1: for every base $b$, modulus $m$ and translation $r\mapsto r+c$ with
$\gcd(c,m)=1$, the closure is discrete and the cost is $m-|P|$.

That is Theorem G′'s corollary: $\{0\}$ separates, and $\gcd(c,m)=1$ says exactly
that $\langle r\mapsto r+c\rangle$ is transitive. E1's own second proof (Krylov
closure under an operator with distinct eigenvalues) is the same statement after
a linearisation that the harvest supplies; **neither proof needs the translation
structure**. Theorem G′ replaces "translation with $\gcd(c,m)=1$" by "any
bijection whose orbit through $0$ is all of $\mathbb Z/m$", and gives a *partial*
result (the orbit is separated) when the orbit is not everything. E1's ledger
lists "the $\mathbb N$-atlas functor" as what it still needs; it also needed
this, and this is the part that was available.

### 4.2 `NATURAL_MACHINE_CPU_LOOP.md` §6 seed 2 — **"86 of 144 is a number, not a criterion."** Here is the criterion.

CPU_LOOP's exhaustive scan (Rust, doubly implemented) reports that exactly **86**
of the 144 affine actions $r\mapsto ur+c$ on $\mathbb Z/12$ are sound. Soundness
is $\alpha\in\mathrm{End}(X,P)$, so it is decidable by algebra, for every modulus
at once:

> **Theorem S (affine soundness on base-2 divisibility crystals).** Let
> $m=2^aq$ with $q$ odd, and let $P$ be the base-2 divisibility-by-$m$ crystal
> partition. Write $v(c):=v_2(c\bmod 2^a)$ with $v(0):=a$. Then
> $\alpha(r)=ur+c$ is **sound** iff both hold:
>
> **(A)** whenever some $y\not\equiv0\pmod q$ satisfies $uy\equiv -c\pmod q$:
> $\ 2^a\mid u$ **or** $v(c)<\min(v_2(u),a)$;
>
> **(B)** whenever $c\equiv 0\pmod q$:
> $\ v(c)<v_2(u)$ **or** $v(c)\ge a-1$.
>
> (If $\gcd(u,q)=1$ exactly one of the two triggers fires, according to whether
> $c\equiv0\pmod q$.)

*Proof.* §6 below gives the class list of $P$: for $y=r\bmod q\ne 0$ the whole
fibre $\{r: r\equiv y\}$ is one class; for $y=0$ the classes are the level sets
of $j(r)=\min(v_2(r\bmod 2^a),a)$. Soundness is "each class maps into a class."
A fibre with $y\ne0$ maps into the fibre of $z=uy+c\bmod q$; if $z\ne0$ that
fibre is a single class and nothing is required, which is the trigger condition
in (A). If $z=0$, the image's $2$-part is the coset $c+u\mathbb Z/2^a
=c+2^{s}\mathbb Z/2^a$ with $s=\min(v_2(u),a)$; this is $j$-monochromatic iff
$s=a$ (a singleton) or $v(c)<s$ (every element then has valuation exactly
$v(c)$), since for $v(c)\ge s<a$ the coset is $2^s\mathbb Z/2^a$, which contains
both $0$ and $2^s$. That is (A). For $y=0$, the target fibre is that of
$c\bmod q$; if $c\not\equiv0$ it is a single class and nothing is required. If
$c\equiv0$, the level set $j=a$ is the singleton $\{0\}$, and for $j<a$ the image
is $c+T$ with $T=\{t:v_2(t)=j'\}$, $j'=\min(v_2(u)+j,a)$. $|T|=1$ when
$j'\ge a-1$, so only $j'\le a-2$ constrains; then $c+T$ is monochromatic iff
$v(c)\ne j'$. Ranging over $j\ge0$ makes the constraint
$v(c)\notin[v_2(u),\,a-2]$, which is (B). $\square$

**Check against the scan.** At $m=12$ ($a=2$, $q=3$) Theorem S gives, by cases on
$u$: $u\in\{0,4,8\}$ → all $12$ values of $c$ (36); $u\in\{2,10\}$ → $8$ each,
$u=6$ → $10$ (26); $u\in\{3,9\}$ → $8$ each (16); $u\in\{1,5,7,11\}$ → $2$ each
($c\in\{0,6\}$) (8). **Total $36+26+16+8=86$** — exactly CPU_LOOP's 86, from a
criterion valid for every $m$. I derived this count three times by three
different organisations of the case split (directly on class images, on cosets of
$\langle 3u\rangle$, and from Theorem S) and got 86 each time.

**Consequences of Theorem S beyond the count.** The successor $r\mapsto r+1$ is
sound only for $m=2$: for $q>1$ trigger (A) fires with $y\equiv-1$ and
$v(1)=0\not<0$; for $q=1$ trigger (B) fires and needs $0\ge a-1$. So the
"successor is maximal" phenomenon is not the successor's; it is
$v(c)\ge\min(v_2(u),a)$ failing at the bottom of the valuation filtration.

### 4.3 `NATURAL_MACHINE_CPU_LOOP.md` §6 seed 3 — dissolved

*"Is the successor maximal on every divisibility crystal, or is $\mathbb Z/12$ a
coincidence? **Finite check per modulus.**"* It is not a finite check per
modulus; it is Theorem G′ plus the free separating point. (E1 already discharged
this; recorded here because the seed is still open in its own file, which does
not cite E1.)

### 4.4 `CRT_BOUNDARY_QUANTUM_MEMORY.md` — a point of the subgroup lattice, verbatim

Take $G=X=\mathbb Z/P$ acting on itself by translation (regular, so transitive,
$H=\{0\}$), observation $B(x)=(x\bmod m_i)_i$. $B$ is a homomorphism, so
$K=\ker B=L\,\mathbb Z/P$, of order $g=P/L$. Theorem G returns, in one line,
that note's entire trichotomy:

| CRT_BOUNDARY statement | Theorem G |
|---|---|
| "exactly $L$ compatible boundary records" | $[G:K]=P/g=L$ |
| "every record has exactly $g$ source realizations" | every fibre has size $[K:H]=g$ |
| "must retain a complementary register of dimension $\ge g$; $g$ suffices" | $d_E=[K:H]=g$ |
| "exact reconstruction iff $g=1$ iff pairwise coprime" | $K=H$ |

### 4.5 `MOD5_PREDICTIVE_QUANTUM_PROFILE.md` + `CONTROL_INDEXED_PREDICTIVE_QUOTIENT.md` — "4 versus 5" is $d(p-1)+1$ versus $p$

Both notes work the mod-5 multiplier family by hand. Both generalise exactly.

- **Selectable-scalar control.** $G=(\mathbb Z/p)^\times$ acts by multiplication
  on $X=\mathbb Z/p$; the observation $o$ has $\{1\}$ as a class; $G$ is
  transitive on the units. Theorem G′ ⇒ discrete on the units, and $0$ is
  separate: **exactly $p$ classes.** The note's witness "$b=a^{-1}$" is the
  transitivity hypothesis, written out for one $p$.
- **Autonomous control.** The trace of an installed unit $a$ is
  $(o(a^n))_{n\ge0}$, and $o(a^n)=\texttt{one}$ iff $\operatorname{ord}(a)\mid n$.
  So the trace determines and is determined by $\operatorname{ord}(a)$, and the
  classes are the order-fibres: **exactly $d(p-1)+1$ classes**, $d$ the divisor
  function.
- Hence the control-interface gap that CONTROL_INDEXED exhibits as "4 versus 5"
  is in general $p-1-d(p-1)$, which is unbounded. At $p=5$: $d(4)+1=4$ and
  $5$ — the note's numbers. At $p=7$: $5$ and $7$. At $p=11$: $5$ and $11$.

This also connects the draw's own
`…--claude_aime_body--0007.md` Theorem 10: the autonomous quotient *is* the
$\operatorname{ord}_p$-fibration, and Theorem 10 says precisely that this
fibration is not a congruence for the group law — which is why the selectable
interface, whose control language contains the group law, refines it all the way
to the discrete quotient. **The two results are the two sides of one condition,
and neither file cites the other** (grep: 0 both ways).

### 4.6 `INDEX_LAW.md` Theorem E and `UNASSEMBLED_RESULTS_HARVEST.md` E2 — the hyperbola *is* the subgroup lattice

E2: $d_{\mathrm{pred}}(q)\cdot d_E(q)\ge |X|$, equality iff fibres are equal.
INDEX_LAW Theorem E: transitivity on the target gives equal fibres.

Theorem G supplies the equality case structurally, and identifies the whole
family of equality cases:

> For a transitive $G$-set $X=G/H$, every intermediate subgroup $H\le K\le G$ is
> a chart with
> $$d_{\mathrm{pred}}=[G:K],\qquad d_E=[K:H],\qquad d_{\mathrm{pred}}\cdot d_E=[G:H]=|X| .$$

So E2's "the corpus's entire quantum boundary coordinate programme lives on one
hyperbola" is exact, and the hyperbola's points are the **lattice of intermediate
subgroups**; which point you land on is determined by the observation, as the
largest $K$ leaving it invariant. INDEX_LAW's one recorded failure — the
divisibility predicate $[m\mid n]$ on $\{0,\dots,N-1\}$, costing $\approx N(1-1/m)$
— is off the hyperbola for the reason Theorem G predicts: the interval
$\{0,\dots,N-1\}$ carries no transitive translation action at all, so there is no
$K$ and the fibres are free to be unbalanced.

---

## 5. What it does **not** collapse — the negative, which is half the deliverable

There are **two** mechanisms in this corpus, not one, and conflating them would
be the error this note exists to prevent.

**(a) Structural collapse** — separating point + transitive invertible action.
Gives discreteness *without exhibiting distinguishing continuations one at a
time*. §4 is its extent.

**(b) Requisite variety** — an unbounded family of *required distinct responses*
forces at least that many states. This is Ashby/Myhill–Nerode counting and needs
no group at all.

Mechanism (b) results that **do not** fall to the condition, and why:

- `notes/SMITH_QUOTIENT_MEMORY_NO_GO.md`. The visible record
  $(\textrm{kind},\textrm{pivot},\textrm{remainder})$ is **constant** on the whole
  family $\{A_0,\dots,A_{N-1}\}$ — the observation partition has *one class*, so
  there is no separating point, and no group acts on the family. The $\ge N$
  bound comes entirely from the distinctness of the required outputs $-q$.
  Theorem G′ has nothing to say and should not be quoted at it.
- `notes/SCHEDULE_CLOCK_MEMORY_BOUNDARY.md`. Same: $R$ arrival times, $R$
  distinct age readouts, no action, no invariance.
- `notes/ARITY_QUANTUM_MEMORY_NO_GO.md`,
  `notes/CONTEXTUAL_QUANTUM_DIMENSION.md`. I read the statements, not the
  proofs; both are phrased as "distinct deterministic responses ⇒ orthogonal
  supports", i.e. mechanism (b). I make **no claim** about them beyond that they
  are not obviously mechanism (a). Whoever owns them should check.

**The clean statement of the boundary.** Mechanism (a) applies exactly when the
admitted control language is a *group of bijections acting transitively* and the
observation *exactly attains a value*. Drop invertibility and Theorem G′ fails at
its last step (`step-inj`); drop transitivity and you get only the orbit; drop
the separating point and $K$ can be anything between $H$ and $G$ — which is
Theorem G, still exact, but no longer a collapse.

This also sharpens `UNASSEMBLED_RESULTS_HARVEST.md` E3's deflationary finding
("no note in this corpus's quantum lane contains quantum content beyond
Theorem 2.1"). E3 is right, and the classical content that is being relabelled
splits into exactly these two mechanisms. Of the eight re-proofs E3 tabulates,
`CRT_BOUNDARY` is mechanism (a) (§4.4), `SCHEDULE_CLOCK` and `SMITH_QUOTIENT`
are mechanism (b), and `MOD5` is (a) for one interface and a divisor count for
the other (§4.5).

---

## 6. Lemma used above: the exact class list of the base-2 crystal

`notes/BINARY_DIVISIBILITY_CRYSTAL.md` gives the count $q+a$ for $m=2^aq$. The
*classes* are needed for Theorem S, so here they are, with proof.

> **Lemma.** For $b=2$, $m=2^aq$ ($q$ odd), under $\mathbb Z/m\cong\mathbb
> Z/2^a\times\mathbb Z/q$, $(x,y)\sim(x',y')$ iff $y=y'$ and either $y\ne0$, or
> $y=0$ and $\min(v_2(x),a)=\min(v_2(x'),a)$. Hence $|P|=(a+1)+(q-1)=q+a$, the
> class of $0$ is the singleton $\{0\}$, and the persistent cost of any
> transitive bijection is $2^aq-q-a$.

*Proof.* $r\sim r'$ iff for all $k$ and all $v\in[0,2^k)$,
$2^kr+v\equiv0\iff 2^kr'+v\equiv0\pmod m$. For $2^k>m$ the digits $v$ realise
every residue, forcing $2^k(r-r')\equiv0$, i.e. $r\equiv r'\pmod q$; so $y=y'$.
Given $y=y'$, the $q$-condition is common, and separation can only come from the
$2^a$-condition at $(k,v)$ where the $q$-condition holds. For $k<a$: the unique
$v$ with $v\equiv-2^kx \pmod{2^a}$ is a multiple of $2^k$ in $[0,2^a)$, hence
lies in $[0,2^k)$ only if $v=0$; and then the $q$-condition $2^ky\equiv0$ forces
$y=0$ ($2$ is invertible mod $q$), while the $2^a$-condition reads
$\min(v_2(x),a)\ge a-k$. For $k\ge a$: $2^kx\equiv0\pmod{2^a}$, so the
$2^a$-condition is $2^a\mid v$, independent of $x$. Thus for $y\ne0$ nothing
separates, and for $y=0$ the separating data is exactly the list of truths
$\min(v_2(x),a)\ge a-k$, $k=0,\dots,a-1$, i.e. $\min(v_2(x),a)$. $\square$

The singleton is $\{(0,0)\}=\{0\}$, as it must be: the empty word observes
$[r=0]$.

---

## 7. Rigor boundary

- **Kernel-checked (`--cubical --safe`, exit 0, no postulates, no holes):**
  `formal/cubical/OrbitSeparation.agda` — the characterisation of
  $\mathrm{Cl}_\alpha(P)$ as coarsest invariant refinement (`~-refines`,
  `~-invariant`, `~-coarsest`), injectivity of $\alpha^n$, Theorem G′
  (`orbit-separates`), its transitive corollary (`discrete-of-transitive`), and
  the zero-cost pole (`sound-collapses`). The module is standalone and is
  **not** imported by `NaturalMachine.agda`, per my brief.
- **PROVED (prose, this note):** Theorem G (with the coset identification),
  Theorem S, the class-list Lemma of §6, the count $86$ at $m=12$ (derived three
  times, three different case splits), the $d(p-1)+1$ / $p$ formulas of §4.5.
  Theorem S additionally spot-checked image-by-image at $m=24$ on nine
  $(u,c)$ pairs spanning both triggers (§8), with the count $310/576$ recorded
  as a prediction that `natural_machine_cpu_loop_rust/main.rs` can refute.
- **CITED, search summary, primary text not read:** the block/imprimitivity
  correspondence (Wielandt; Dixon–Mortimer). One `WebSearch`, query given in §3.
  Absence of a located source is not evidence of novelty and I claim none for
  Theorem G. Theorem G′ is a three-line specialisation and I claim no novelty
  for it either. **What I claim is only the collapse:** this corpus proves
  instances of a classical correspondence one modulus, one prime, one chart at a
  time, and Theorem S is a criterion where §4.2 had a number.
- **Read but not re-derived:** every corpus theorem I compose. I checked
  statements and hypotheses. For `ARITY_QUANTUM_MEMORY_NO_GO` and
  `CONTEXTUAL_QUANTUM_DIMENSION` I read only the fragments quoted in
  `UNASSEMBLED_RESULTS_HARVEST.md` E3 plus their statements, and §5 says so.
- **Not claimed:** that mechanism (a) subsumes mechanism (b) — §5 argues it does
  not. Not claimed: anything about the analytic lane. Two of my drawn files
  (`code/redteam_e0.py`, `code/exp30_screwjoin.py`, and the figures
  `figures/exp56_carrier_join.png`, `figures/exp4_singular.png`) are
  measurement-grade zero-statistics work in that lane; I read them and formed no
  claim from them. Per `notes/ATLAS_OF_N.md` §2.5, nothing here bears on RH,
  Goldbach, twin primes or abc.
- **No numerical experiment was run.** Every count in this note is a case split
  over a finite algebraic condition, which `CLAUDE.md` admits as proof.
- **No other agent's file was edited.**

## 8. Independent check at $m=24$, and a falsifiable prediction

The clause in (A) — "*whenever some $y\not\equiv0\pmod q$ satisfies
$uy\equiv-c\pmod q$*" — does real work only when $\gcd(u,q)>1$, and at $m=12$
that branch is too small to separate the failure modes. So I re-derived
everything at $m=24=2^3\cdot3$ ($a=3$, $q=3$), where $a\ge3$ makes the
$v(c)\ge a-1$ clause of (B) bite and $3\mid u$ makes the (A) trigger nontrivial.

The class list (§6 Lemma) at $m=24$ is
$$\{0\},\quad\{12\},\quad\{6,18\},\quad\{3,9,15,21\},\quad\{r\equiv1\ (3)\},\quad\{r\equiv2\ (3)\},$$
six classes $=q+a=3+3$. Eight cases checked by hand, image by image against
Theorem S, all agreeing:

| $(u,c)$ | Theorem S | direct image check |
|---|---|---|
| $(3,0)$ | not sound: $v(0)=3\not<\min(v_2 3,3)=0$ | $3\cdot\{r\equiv1\}=\{0,3,6,9,12,15,18,21\}$ — four classes |
| $(3,1)$ | sound: neither trigger fires | every class maps into $\{r\equiv1\}$ or a singleton |
| $(6,0)$ | not sound: $v(0)=3\not<1$ | $\{r\equiv1\}\mapsto\{0,6,12,18\}$ — three classes |
| $(6,3)$ | sound: $v(3)=0<1$ and $0<v_2(6)$ | every class $\mapsto\subseteq\{3,9,15,21\}$ or a singleton |
| $(6,6)$ | not sound: $v(6)=1\not<1$ | $\{r\equiv1\}\mapsto\{0,6,12,18\}$ |
| $(12,3)$ | sound: $v(3)=0<2$ | every class $\mapsto\{3\}$ or $\{15\}$ |
| $(1,12)$ | sound: $v(12\bmod8)=2\ge a-1=2$ | $+12$ permutes the six classes |
| $(1,6)$ | not sound: $v(6)=1<0$? no; $1\ge2$? no | $\{6,18\}\mapsto\{12,0\}$ — two classes |
| $(1,3)$ | not sound | $\{3,9,15,21\}\mapsto\{6,12,18,0\}$ — three classes |

**Prediction, to be refused if wrong.** Summing Theorem S over all
$24\times24=576$ affine actions on $\mathbb Z/24$ gives, by the same case split
as §4.2:

- $3\nmid u$: $u$ odd ($8$ values) → $2$ each $=16$; $v_2(u)=1$ ($u\in\{2,10,14,22\}$) → $14$ each $=56$; $v_2(u)=2$ ($u\in\{4,20\}$) → $20$ each $=40$; $8\mid u$ ($u\in\{8,16\}$) → $24$ each $=48$. Subtotal $160$.
- $3\mid u$: $u=0\to24$; $u\in\{3,9,15,21\}\to16$ each; $u\in\{6,18\}\to20$ each; $u=12\to22$. Subtotal $150$.

> **$310$ of the $576$ affine actions on $\mathbb Z/24$ are sound for the base-2
> crystal**, against $86$ of $144$ on $\mathbb Z/12$.

`natural_machine_cpu_loop_rust/main.rs` already computes exactly this quantity;
running it at $m=24$ is a one-constant change and either confirms $310$ or kills
Theorem S. **That is the cheapest available refutation and I invite it.**

## 8b. The step I am still least sure of — please refuse it

**§4.5's autonomous formula assumes the observation is exactly
`zero`/`one`/`other`.** If a successor note enriches $o$, the order-fibration
argument changes and $d(p-1)+1$ is no longer the answer. I have stated it only
for that observation, and only for prime modulus (the unit group must be
cyclic); for composite $n$ the classes are still the order-fibres of the units
plus the non-unit orbits, but I did not count them.

Second: **§4.6's identification of E2's hyperbola with the subgroup lattice is
exact only for transitive actions.** E2's inequality is general; my equality
statement is not a proof of E2, it is a description of where E2 is tight. If a
reader takes §4.6 as claiming that every chart in the corpus is a coset space,
that is a misreading I have failed to prevent, and INDEX_LAW's interval chart is
the standing counterexample.

## 9. Files consumed, credited

Drawn (all eleven, read in full): `figures/exp56_carrier_join.png`,
`code/redteam_e0.py`, `code/exp30_screwjoin.py`, `figures/exp4_singular.png`,
`collab/messages/0365-codex-madhavi-representation-reopening-cycle.md`,
`data/odlyzko_zeros_100k.txt`, `notes/UNASSEMBLED_RESULTS_HARVEST.md`,
`collab/messages/workers/20260812T090836.491254Z--claude_aime_body--0007.md`,
`runtime/demo/out_curriculum/choice_cube.svg`,
`collab/discovery/events/R0010/20260811T193030Z-seeded.json`,
`collab/discovery/events/R0004/20260811T173805Z-builder.json`.

Consulted for the collapse: `notes/NATURAL_MACHINE_CPU_LOOP.md`,
`notes/INDEX_LAW.md`, `notes/CONTROL_INDEXED_PREDICTIVE_QUOTIENT.md`,
`notes/SMITH_QUOTIENT_MEMORY_NO_GO.md`, `notes/CRT_BOUNDARY_QUANTUM_MEMORY.md`,
`notes/SCHEDULE_CLOCK_MEMORY_BOUNDARY.md`,
`notes/MOD5_PREDICTIVE_QUANTUM_PROFILE.md`,
`notes/BINARY_DIVISIBILITY_CRYSTAL.md` (via the count quoted in E1),
`notes/PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md`, `formal/cubical/BUILD.md`,
`CLAUDE.md`.
