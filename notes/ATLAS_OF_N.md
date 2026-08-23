# The atlas of $\mathbb{N}$: seven charts, their transition maps, and the residuals as homotopy

**Task.** Execute `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §4 (reachable chart vs. ambient
completion), §6 (polyglot atlas with *preserved translation residuals*), §7
(Voevodskian identity) and §8 (duality crystals) on the deepest available instance of
"what is the object, and what is merely a chart of it?" — the natural numbers.
Method imitated from `RATIONAL_CIRCLE_ATLAS.md` (charts, proved transition maps,
residual group acting on fibers, what survives completion); subject matter entirely
different.

**Status: PENDING HOSTILE AUDIT.** This note contains **no numerical work**: no
scripts, no measurements, no fitted constants, no code. It creates only this file and
edits nothing existing. Every assertion is a definition, a theorem with a proof, a
quoted theorem from `DIGIT_CRYSTAL.md`, or a labelled literature citation.

**Novelty.** Essentially every ingredient below is classical; §9 says so line by line.
The claim to originality is exactly three things and nothing more: (i) the *assembled*
atlas — seven presentations of one object with every adjacent transition map proved and
every residual named; (ii) the **residual table** of §8, in which each residual is
identified with homotopy of the pre-truncation object; (iii) the **exact form of the
dependency theorem** (§4) and its statement that positional notation is a chart of
$\pi_0$ requiring three choices while symmetry/generation requires zero. Be blunt: none
of the individual lemmas would surprise a category theorist, a set theorist, or a
number theorist. The assembly is the deliverable.

**Headline, in one sentence.** *A natural number is a connected component; the numeral
is $\pi_0$; the space over that component is $BS_n$; and base-$b$ positional notation is
a coordinate system on the truncation requiring a finite quotient, a trivialization of a
$\mathbb{Z}/2$-torsor, and a nonzero degree-two cohomology class — none of which
$\mathbb{N}$ supplies.*

---

## 0. Two levels, and the conventions

Everything below distinguishes two levels of the same object.

- **Pre-truncation.** A groupoid (equivalently, in univalent foundations, a $1$-type)
  whose objects have automorphisms. The relevant one is $\mathbb{F} :=
  \operatorname{core}(\mathbf{FinSet})$, finite sets and bijections.
- **Post-truncation.** A set, obtained by $\pi_0$ (in HoTT: the set-truncation
  $\lVert-\rVert_0$). This is $\mathbb{N}$.

The distinction is not decoration. Every residual in this note is the difference
between these two levels, or a chart datum introduced below the truncation.

Notation: $[n] := \{1,\dots,n\}$, $[0] := \varnothing$. $\mathbf{Set}$ is ordinary sets;
all category-theoretic statements are over $\mathbf{Set}$ unless stated otherwise, and
where a statement is sensitive to the ambient category this is flagged. $P$ denotes the
set of prime numbers. $A_b := \{0,1,\dots,b-1\}$ for a base $b \ge 2$; $A_b^{(\mathbb{N})}$
denotes finitely-supported sequences $\mathbb{N} \to A_b$. Digit conventions
(little-endian, $L_n$, $\pi_n$, $\varsigma_n$, $\mathbb{Z}_b$, the odometer $T$) are
those of `DIGIT_CRYSTAL.md` §0 and are used without restatement.

---

## 1. The seven charts

| # | Chart | Native definition | Universal property / characterization | Makes easy | Level |
|---|---|---|---|---|---|
| **(a)** | Peano | initial algebra of $X \mapsto 1+X$ | initial object in $(1+X)\text{-}\mathbf{Alg}$ | recursion, induction | post |
| **(b)** | tally | free monoid on one generator | $\operatorname{Hom}_{\mathbf{Mon}}(\mathbb{N},M)\cong U(M)$ | iteration, concatenation, actions | post |
| **(c)** | cardinals | $\pi_0$ of finite sets & bijections | $(\mathbb{F},\sqcup,\varnothing)$ = free symmetric monoidal category on one object | bijective proofs, $+,\times$, exponentials | **pre** |
| **(d)** | ordinals $<\omega$ | finite well-orders | $\omega$ = least infinite ordinal | order, comparison, well-founded recursion | post (rigidified) |
| **(e)** | base $b$ | digit words with carrying | *(none — see §4)*; orbit of $0$ under a free affine monoid action | computation, size estimation | post + 3 choices |
| **(f)** | primes | free commutative monoid on $P$ | $\operatorname{Hom}_{\mathbf{CMon}}(\mathbb{N}_{>0},M)\cong M^{P}$ | divisibility, multiplicativity | post |
| **(g)** | Stern–Brocot | $\{L,R\}^*$ / continued fractions | free monoid on two generators, bijective onto $\mathbb{Q}_{>0}$ | approximation, mediants | extension chart |

### 1(a) Initial algebra of $X \mapsto 1+X$

In a category $\mathcal{C}$ with terminal object $1$ and binary coproducts, put
$F(X) = 1+X$. An $F$-algebra is a triple $(X,\, x_0 : 1 \to X,\, f : X \to X)$;
a morphism $(X,x_0,f) \to (Y,y_0,g)$ is $h$ with $h x_0 = y_0$ and $hf = gh$.
$\mathbb{N} = (\mathbb{N}, 0, s)$ is the initial $F$-algebra in $\mathbf{Set}$.
This is Lawvere's *natural numbers object* (**CLASSICAL**; §9).

**Proposition 1.1 (Lambek).** If $\alpha : F(N) \to N$ is an initial $F$-algebra then
$\alpha$ is an isomorphism; i.e. $1 + \mathbb{N} \cong \mathbb{N}$ canonically.

*Proof.* $F(\alpha) : F(F(N)) \to F(N)$ is an $F$-algebra, so there is a unique algebra
map $h : N \to F(N)$, i.e. $h\alpha = F(\alpha)F(h)$. Then $\alpha h : N \to N$ is an
algebra endomorphism of the initial object, hence $\alpha h = \mathrm{id}$. And
$h\alpha = F(\alpha)F(h) = F(\alpha h) = F(\mathrm{id}) = \mathrm{id}$. $\square$

**Proposition 1.2 (induction = no proper subalgebra).** If $S \subseteq \mathbb{N}$
with $0 \in S$ and $s(S) \subseteq S$, then $S = \mathbb{N}$.

*Proof.* $(S,0,s|_S)$ is an $F$-algebra; let $u : \mathbb{N} \to S$ be the unique algebra
map and $\iota : S \hookrightarrow \mathbb{N}$ the inclusion, which is an algebra map.
Then $\iota u : \mathbb{N}\to\mathbb{N}$ is an algebra endomorphism of the initial
object, hence $\iota u = \mathrm{id}_{\mathbb{N}}$, so $\iota$ is surjective. $\square$

So **induction is not an axiom adjoined to this chart; it is initiality**. Record this:
it is the structure that no completion of $\mathbb{N}$ retains (Theorem 5.1).

### 1(b) Free monoid on one generator

$(\mathbb{N},+,0)$ is free on $\{1\}$: for every monoid $M$ and $m \in M$ there is a
unique monoid homomorphism $\varphi : \mathbb{N} \to M$ with $\varphi(1) = m$, namely
$\varphi(n) = m^n$. Equivalently $\operatorname{Hom}_{\mathbf{Mon}}(\mathbb{N},M)
\cong U(M)$ naturally. Specializing $M = \operatorname{End}(X)$:

> an $\mathbb{N}$-action on $X$ *is* an endomorphism of $X$.

This is the precise sense in which $\mathbb{N}$ is **the shape of iteration**: it is the
free object classifying "do a thing, repeatedly, a finite number of times."

### 1(c) Finite cardinals — the pre-truncation chart

Let $\mathbb{F} := \operatorname{core}(\mathbf{FinSet})$, the groupoid of finite sets and
bijections, with $\sqcup$ (unit $\varnothing$) and $\times$ (unit $[1]$).

**Universal property (CLASSICAL, FETCHED).** nLab, *FinSet*: "As a groupoid itself, the
core of FinSet is (with the operation of disjoint union) the free symmetric monoidal
category on one object." Equivalently, nLab *permutation groupoid*: the permutation
groupoid is the free strict symmetric monoidal category on one object, its connected
components are the deloopings of the symmetric groups, and in skeletal form its tensor
is addition of natural numbers.

$\mathbb{N} := \pi_0(\mathbb{F})$, with $+ = \sqcup$ and $\times = \times$. Chart (c) is
the *decategorified* chart; §2.2 computes exactly what decategorification discards.

### 1(d) Ordinals below $\omega$

$\omega$ is the least infinite ordinal; its elements are the finite ordinals. Ordinal
arithmetic is defined on order types: $\alpha+\beta$ is the order type of a copy of
$\alpha$ followed by a copy of $\beta$; $\alpha\cdot\beta$ is $\beta$ copies of
$\alpha$. Characterization: $(\mathbb{N},<)$ is, up to unique isomorphism, the unique
infinite well-order all of whose proper initial segments are finite.

The relevant groupoid is $\operatorname{core}(\mathbf{FinLin})$, finite linearly ordered
sets and order isomorphisms.

### 1(e) Base-$b$ digit words with carrying

Fix $b \ge 2$. The chart is $L : A_b^{(\mathbb{N})} \to \mathbb{N}$,
$L(c) = \sum_i c_i b^i$ (Theorem 2.7). Its *native* operation is **not** addition: it is
concatenation, which by `DIGIT_CRYSTAL.md` Lemma 0.1 is the composition of the free
affine monoid $M_b = \Phi(A_b^*) \subset \operatorname{Aff}(\mathbb{Z})$ generated by
$\gamma_d : x \mapsto bx+d$, with positional evaluation being the orbit of $0$.
Addition must be *reconstructed*, and the reconstruction is exactly the carry cocycle
(Proposition 2.11).

This chart is the one that dominates human numerical education. §4 is about that.

### 1(f) The free commutative monoid on the primes

$(\mathbb{N}_{>0},\times,1)$ with the map $e : \bigoplus_{p\in P}\mathbb{N} \to
\mathbb{N}_{>0}$, $e((a_p)) = \prod_p p^{a_p}$.

**Unique factorization is a chart-defining statement, not a theorem about numbers**: it
says exactly that $e$ is an isomorphism, i.e. that this monoid is *free*. Its universal
property — for every commutative monoid $M$ and every $f : P \to M$ there is a unique
monoid map $\mathbb{N}_{>0} \to M$ extending $f$ — is, verbatim, "a completely
multiplicative function is freely determined by its values on the primes." (Compare
`DEFINITIONAL_RIGIDITY.md`'s Theorem R, where the minimal relational web pinning $\zeta$
begins with complete multiplicativity; the connection is that both are consequences of
freeness of this chart, and nothing stronger is asserted here.)

### 1(g) Stern–Brocot / continued fractions (extension chart)

$\mathbb{Q}_{>0} \leftrightarrow \{L,R\}^*$ bijectively, via mediants; the run-length
encoding of the continued fraction is the Stern–Brocot address. This is the natural
*extension* chart: it presents not $\mathbb{N}$ but its field-of-fractions completion's
positive part, and it does so by a free monoid on two generators. Proved transition maps
and the $SL_2(\mathbb{F}_2)$ parity monodromy are in `RATIONAL_CIRCLE_ATLAS.md` §2.4–2.5
and are not reproved here. Its role below is only as the completion chart in §5.

---

## 2. Transition maps, with proofs, and the residuals

Per charter §6, the content is not the dictionary but the **untranslatable residual**.
Each subsection ends by naming the residual as a group, a functor, or an explicit extra
datum.

### 2.1 (a) $\leftrightarrow$ (b): the residual is *nothing*, and here is precisely why

**Theorem 2.1.** Let $(N,0,s)$ be an initial $(1+X)$-algebra in $\mathbf{Set}$. Define
$n+m := u_n(m)$, where $u_n : (N,0,s) \to (N,n,s)$ is the unique algebra map. Then
$(N,+,0)$ is a commutative monoid, free on $\{s(0)\}$. Conversely, if $(M,\cdot,e)$ is a
free monoid on $\{x\}$ then $(M, e, (-)\cdot x)$ is an initial $(1+X)$-algebra. The two
constructions are mutually inverse.

*Proof.* By construction $n+0 = u_n(0) = n$ and $n+s(m) = u_n(s m) = s(u_n m) = s(n+m)$.

*Left unit.* $m \mapsto 0+m$ is the algebra map $(N,0,s)\to(N,0,s)$, hence
$\mathrm{id}$.

*Associativity.* Fix $n,p$. Both $m \mapsto (n+p)+m$ and $m \mapsto n+(p+m)$ send $0$ to
$n+p$ and commute with $s$, hence both are *the* algebra map $(N,0,s)\to(N,n+p,s)$;
by uniqueness they agree.

*Commutativity.* First $s(n)+m = s(n+m)$: both sides, as functions of $m$, send $0$ to
$s(n)$ and commute with $s$; apply uniqueness. Then $n+m=m+n$ by induction
(Proposition 1.2) on $m$: base $n+0=n=0+n$; step $n+s(m) = s(n+m) = s(m+n) = s(m)+n$.

*Freeness.* Put $1 := s(0)$; induction gives $s^k(0) = \underbrace{1+\cdots+1}_{k}$.
Given a monoid $M$ and $m \in M$, let $\varphi : (N,0,s) \to (M, e, r_m)$ be the unique
algebra map, where $r_m(x) = x\cdot m$. Then $\varphi(0)=e$ and $\varphi(s n)=\varphi(n)m$,
and $\varphi(n+n')=\varphi(n)\varphi(n')$ by induction on $n'$. Any monoid map
$\psi$ with $\psi(1)=m$ satisfies $\psi(sn)=\psi(n+1)=\psi(n)m$, so $\psi$ is an algebra
map, hence $\psi=\varphi$.

*Converse.* Let $M$ be free on $\{x\}$ and $(X,a,f)$ any $(1+X)$-algebra. Freeness gives
a unique monoid map $\theta : M \to \operatorname{End}(X)$ with $\theta(x)=f$; its image
lies in the commutative submonoid generated by $f$. Put $h(m) := \theta(m)(a)$. Then
$h(e)=a$ and $h(mx) = \theta(m)\theta(x)(a) = \theta(x)\theta(m)(a) = f(h(m))$, so $h$ is
an algebra map. Uniqueness: $M=\{x^n\}$ and any algebra map is forced on $x^n$ to be
$f^n(a)$. Mutual inverseness is immediate on generators. $\square$

**Residual 2.1: the trivial group.** Three independent statements of this, each stronger
than the previous:

1. Both objects are **initial** — the first in $(1+X)\text{-}\mathbf{Alg}$, the second in
   pointed monoids — so the comparison isomorphism is not merely available but
   **unique**. In univalent language (§3): the type of isomorphisms between two initial
   objects is *contractible*, not merely inhabited.
2. The two signatures are **definitional expansions of each other**: $s(n) := n+1$ and
   $n+m := s^m(n)$, each definable from the other by the primitive recursion the other
   supplies. Hence the categories of models are *isomorphic*, not merely equivalent.
3. $\operatorname{Aut}(\mathbb{N},0,s) = \{\mathrm{id}\}$ and
   $\operatorname{Aut}(\mathbb{N},+,0) = \{\mathrm{id}\}$. (For the second: a monoid
   automorphism permutes the $+$-irreducibles; $n$ is irreducible iff $n \ne 0$ and $n$
   is not a sum of two nonzero elements, iff $n=1$; so $\varphi(1)=1$ and hence
   $\varphi = \mathrm{id}$.)

*Honest scope.* Statement (a) makes sense in any category with $1$ and $+$; statement
(b) is about monoids. The identification above is proved in $\mathbf{Set}$. In a general
topos with NNO the corresponding statement holds but requires the standard internal
recursion machinery; nothing here depends on it.

### 2.2 (c) $\to$ (a),(b): the residual is $S_n$ — the sharpest one

**Theorem 2.2 (component decomposition).** $\mathbb{F} \simeq \coprod_{n\ge 0} BS_n$,
where $BS_n$ is the one-object groupoid with automorphism group $S_n$.

*Proof.* Every finite set $X$ admits a bijection $X \cong [n]$ for some $n$, and $n$ is
unique: if $[n]\cong[m]$ with $n<m$ then there is an injection $[m]\hookrightarrow[n]$,
contradicting the pigeonhole principle (proved by induction, i.e. from chart (a)). So
the objects of $\mathbb{F}$ fall into connected components indexed by $\mathbb{N}$.
Each component $\mathbb{F}_n$ is a connected groupoid; the full subgroupoid on the single
object $[n]$ is $B\operatorname{Aut}([n]) = BS_n$ and is fully faithful and essentially
surjective in $\mathbb{F}_n$, hence an equivalence. $\square$

**Theorem 2.3 (the decategorification residual).** Let $|{-}| : \mathbb{F} \to \mathbb{N}$
be $\pi_0$, with $\mathbb{N}$ regarded as a discrete groupoid. Then:

1. $|{-}|$ is strong symmetric monoidal $(\mathbb{F},\sqcup,\varnothing) \to
   (\mathbb{N},+,0)$ and $(\mathbb{F},\times,[1]) \to (\mathbb{N},\times,1)$;
2. it is bijective on isomorphism classes and **not faithful** for $n \ge 2$: the fibre
   of $\operatorname{Aut}(X) \to \operatorname{Aut}(n) = \{\mathrm{id}\}$ is
   $\operatorname{Aut}(X) \cong S_n$;
3. the homotopy fibre over $n$ is $BS_n$ (Theorem 2.2);
4. for $|X| = n$, the set $\operatorname{Iso}(X,[n])$ is a **torsor** under $S_n$: free
   and transitive, of cardinality $n!$.

*Proof.* (1) Explicit bijections $[m]\sqcup[n]\cong[m+n]$ and $[m]\times[n]\cong[mn]$;
strength (coherence) is the standard associativity/symmetry check. (2),(3) Theorem 2.2.
(4) $S_n$ acts by post-composition; given $f,g \in \operatorname{Iso}(X,[n])$, the
element $gf^{-1} \in S_n$ is the unique one carrying $f$ to $g$. $\square$

**Residual 2.2: $S_n$, and it is *precisely* what decategorification forgets.**

A set has automorphisms; the number naming it does not. The number is not a small object;
it is the **connected component** of an object that is not small. Three sharp
consequences, each a form of "identity is relational" (charter §7,
`DEPENDENT_ORIGINATION.md` §1):

- "$|X| = |Y|$" is not primitive data. It is the *truncation of a structure*: the type of
  bijections $X \cong Y$, which is nonempty but never a singleton for $n \ge 2$.
  Equality of numbers is the propositional shadow of an $S_n$-torsor.
- **Commutativity of $+$ is a shadow of a symmetry.** The isomorphism
  $\sigma_{X,Y} : X\sqcup Y \cong Y\sqcup X$ decategorifies to the *equation*
  $m+n = n+m$; the coherence datum $\sigma_{Y,X}\sigma_{X,Y} = \mathrm{id}$ becomes an
  equation between equations and is invisible downstream. The chart (a)/(b) axiom is the
  chart (c) datum, flattened.
- The Cubical seed of `PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §12.1 (loops at the canonical
  $n$-element `FinSet` are group-equivalent to `FinSymGroup n`, carrier equivalent to
  `Fin (n!)`) is exactly Theorem 2.2 + Theorem 2.3(4), machine-checked. This note does
  not replay that proof and claims nothing from it.

### 2.3 (d) $\leftrightarrow$ (c): rigidification, and a residual supported at $\omega$

**Proposition 2.4.** $\operatorname{core}(\mathbf{FinLin})$ is equivalent to the
*discrete* groupoid $\mathbb{N}$: any two finite linear orders of the same cardinality
are **uniquely** isomorphic, and a finite linear order has no nontrivial automorphism.

*Proof.* Induction on $n$: the minimum must map to the minimum, and delete it. $\square$

**Theorem 2.5 (chart (d) trivializes the residual instead of forgetting it).** Let
$U : \operatorname{core}(\mathbf{FinLin}) \to \mathbb{F}$ forget the order. For an
$n$-element set $X$, the fibre $U^{-1}(X) = \{\text{linear orders on } X\}$ is a torsor
under $\operatorname{Aut}(X) = S_n$, of cardinality $n!$. Hence:

> charts (a),(b) reach $\mathbb{N}$ from (c) by **truncating** — discarding
> $\operatorname{Aut}$; chart (d) reaches $\mathbb{N}$ from (c) by **rigidifying** —
> killing $\operatorname{Aut}$ by adding a trivializing datum.

*Proof.* $S_n$ acts on linear orders by transport; transitively (any two orders on a
finite set differ by a unique relabelling) and freely (a permutation preserving a linear
order is the identity). $\square$

**Theorem 2.6 (finite ordinal arithmetic = finite cardinal arithmetic; the divergence is
exactly at $\omega$).**

1. For $m,n < \omega$, ordinal $m+n$ = cardinal $m+n$ and ordinal $m\cdot n$ = cardinal
   $m\cdot n$.
2. Ordinal $+$ and $\cdot$ are not commutative: $1+\omega = \omega \ne \omega+1$ and
   $2\cdot\omega = \omega \ne \omega\cdot 2 = \omega+\omega$.

*Proof.* (1) Ordinal addition satisfies $\alpha+0=\alpha$,
$\alpha+(\beta+1)=(\alpha+\beta)+1$, $\alpha+\lambda = \sup_{\beta<\lambda}(\alpha+\beta)$.
For $\beta<\omega$ no limit case ever occurs, so $\alpha+{-}$ restricted to $\omega$
satisfies the same primitive recursion that defines cardinal addition via chart (a);
by uniqueness of recursion (initiality, Theorem 2.1) the two agree. Same argument for
$\cdot$. (2) A point followed by $\mathbb{N}$ has order type $\omega$; $\omega+1$ has a
maximum and $\omega$ does not. $\omega$ copies of a $2$-element order concatenate to
$\omega$; $2$ copies of $\omega$ give $\omega+\omega \ne \omega$ (the latter has an
element with infinitely many predecessors). $\square$

**Residual 2.3: the linear order — a residual with zero content on $\mathbb{N}$ and full
content on the completion.** Chart (d) knows *which copy came first*. Below $\omega$
that knowledge is arithmetically inert (Theorem 2.6(1)). Above $\omega$ it is everything
(Theorem 2.6(2)). This is a residual, not a defect: it is the exact reason $\mathbf{Ord}$
and $\mathbf{Card}$ are two incomparable completions of the same $\mathbb{N}$ (§5.4).

### 2.4 (a) $\leftrightarrow$ (e): the positional chart and its three residuals

**Theorem 2.7 (existence and uniqueness of base-$b$ representation).** For $b\ge2$ the
map $L : A_b^{(\mathbb{N})} \to \mathbb{N}$, $L(c)=\sum_i c_i b^i$, is a bijection.

*Proof.* *Surjectivity*, by strong induction: $L(0)=0$; for $n\ge1$ write $n = bq+r$ with
$0\le r<b$ (division with remainder, itself proved by induction from chart (a)). Since
$b\ge2$ and $n\ge1$ we have $q \le n/b < n$, so by induction $q = L(c')$ for some
finitely supported $c'$; then $n = L(r,c'_0,c'_1,\dots)$, again finitely supported.
*Injectivity*: if $L(c)=L(d)=n$ then $c_0 \equiv n \equiv d_0 \pmod b$ with
$c_0,d_0 \in [0,b)$, so $c_0=d_0$; subtracting and dividing by $b$ reduces to the strictly
smaller value $(n-c_0)/b$, and induction closes. $\square$

The three residuals of this chart are the base, the endianness and the carry. Each is
proved to be a genuine, non-removable datum.

#### (i) The base: an invariant, and infinitely many incomparable choices

**Proposition 2.8 (change of base).** Let $b,b' \ge 2$ and let $\operatorname{rad}$ denote
the radical (product of distinct prime divisors). The identity map $\mathbb{N}\to\mathbb{N}$
extends to a continuous map $\mathbb{Z}_b \to \mathbb{Z}_{b'}$ **iff**
$\operatorname{rad}(b') \mid \operatorname{rad}(b)$; the extension is then unique and is
the canonical projection $\prod_{p\mid b}\mathbb{Z}_p \twoheadrightarrow
\prod_{p\mid b'}\mathbb{Z}_p$.

*Proof.* ($\Leftarrow$) If every prime dividing $b'$ divides $b$, then for each $m$ there
is $n$ with $b'^m \mid b^n$; hence $b^n \mid (x-y) \Rightarrow b'^m \mid (x-y)$, so
$\mathrm{id}$ is uniformly continuous from $(\mathbb{N},|\cdot|_b)$ to
$(\mathbb{N},|\cdot|_{b'})$. As $\mathbb{N}$ is dense in $\mathbb{Z}_b$ and
$\mathbb{Z}_{b'}$ is complete Hausdorff, the extension exists and is unique; it is a ring
map by density, hence the CRT projection. ($\Rightarrow$) Suppose $p \mid b'$ but
$p \nmid b$. Then $b^k \to 0$ in $\mathbb{Z}_b$, while $|b^k|_{b'} = 1$ for all $k$
because $v_p(b^k) = 0$. A continuous extension $f$ would satisfy $f(0)=0$ (it restricts to
$\mathrm{id}$ on $\mathbb{N}$) and $f(b^k)=b^k \to f(0)=0$ in $\mathbb{Z}_{b'}$,
contradicting $|b^k|_{b'} = 1$. $\square$

**Corollary 2.8.1.** The chart invariant of the base is exactly $\operatorname{rad}(b)$.
Up to continuous intertranslation the family of positional charts is indexed by the
nonempty finite sets of primes, an infinite index set, and *no* universal property of
$\mathbb{N}$ distinguishes a member of it. Binary digits do not continuously determine
decimal digits; decimal digits do continuously determine binary ones.

**Proposition 2.9 (locality of divisibility; where charts (e) and (f) overlap).** Let
$d \ge 1$, $k \ge 0$. The residue $n \bmod d$ is a function of the last $k$ base-$b$
digits of $n$ **iff** $d \mid b^k$.

*Proof.* "Function of the last $k$ digits" means $n \bmod d$ factors through
$n \bmod b^k$, i.e. $b^k\mathbb{Z} \subseteq d\mathbb{Z}$, i.e. $d \mid b^k$. $\square$

So the positional chart trivializes exactly the divisibility questions at primes dividing
$b$ and no others: charts (e) and (f) share precisely $\{p : p \mid b\}$. Everything
elementary schooling calls a "divisibility trick" is Proposition 2.9 plus a digit-sum
identity, i.e. `DIGIT_CRYSTAL.md` (2.1).

#### (ii) Endianness: a $\mathbb{Z}/2$-torsor, trivialized in coordinates and not in structure

The following restates, without re-deriving, the theorems of `DIGIT_CRYSTAL.md` §4.

**Proposition 2.10 (the endian torsor).** Let $\mathcal{T} := \{\pi,\varsigma\}$ be the
two truncation systems on the family $(\mathbb{Z}/b^n)_n$ ($\pi_n$ deletes the *most*
significant digit; $\varsigma_n$ deletes the *least*). Then:

1. Reversal $R$ conjugates $\pi$ into $\varsigma$ and $\varsigma$ into $\pi$: this is
   `DIGIT_CRYSTAL.md` Theorem 4.2, $\pi_n R_{n+1} = R_n \varsigma_n$ and
   $\varsigma_n R_{n+1} = R_n \pi_n$, together with $R_n^2 = \mathrm{id}$. Since
   $\pi \ne \varsigma$ (Theorem 4.2(2): the agreement locus is only the $b$ constant
   strings, defect fraction exactly $1-b^{-n}$), the action of
   $\mathbb{Z}/2 = \langle R\rangle$ on $\mathcal{T}$ is free and transitive:
   **$\mathcal{T}$ is a $\mathbb{Z}/2$-torsor.**
2. The two limits $\mathbb{Z}_b = \varprojlim(\pi)$ and $\Sigma_b = \varprojlim(\varsigma)$
   are homeomorphic via $R_\infty$, and in the canonical digit charts
   $J \circ R_\infty = L$ (`DIGIT_CRYSTAL.md` Theorem 4.4): **the transport is the
   identity on digit sequences.** The torsor is trivialized by the value map.
3. Nevertheless only $\varprojlim(\pi)$ admits a group structure making the canonical
   projections homomorphisms (`DIGIT_CRYSTAL.md` Lemma 4.1). So the two sheets are *not*
   interchangeable as structures.

**Residual 2.4: the endian class $\mathbb{Z}/2$.** Geometrically: $\mathcal{T}$ is a
two-element covering of the chart over the object; its deck transformation acts
*trivially on fibre coordinates* (that is exactly what $J\circ R_\infty = L$ says — the
covering admits a section furnished by the value map), and *nontrivially on the
structures the fibres carry* (only one sheet supports $+$, the odometer, and the carry
cocycle). The precise consequence is `DIGIT_CRYSTAL.md` Corollary 4.5: the Klein-four
symmetry $\langle D,E\rangle$ of every finite digit chart maps to
$\operatorname{Homeo}(\mathbb{Z}_b)$ with kernel exactly $\langle D\rangle$.

*Guardrail.* "Covering" here means precisely "a $\mathbb{Z}/2$-torsor of truncation
systems," nothing more. No nontrivial homotopy of $\mathbb{N}$ or of $\mathbb{Z}_b$ is
being claimed; the residual is a chart-frame datum, not $\pi_1$ of the object. §3.4 says
this again in univalent language and repeats the warning.

#### (iii) The carry: a nonzero cohomology class, hence unremovable

**Proposition 2.11 (carrying is a nonsplit extension class).** Fix $b\ge2$, $n\ge1$.
Consider
$$0 \longrightarrow b^n\mathbb{Z}/b^{n+1}\mathbb{Z} \longrightarrow \mathbb{Z}/b^{n+1}
\overset{\pi_n}{\longrightarrow} \mathbb{Z}/b^{n} \longrightarrow 0,$$
with kernel $\cong \mathbb{Z}/b$, and let $s_n : \mathbb{Z}/b^n \to \mathbb{Z}/b^{n+1}$
be the digit section (least nonnegative representative). Its coboundary
$$c_n(u,v) \;=\; s_n(u)+s_n(v)-s_n(u+v) \;=\; b^n\cdot\big\lfloor (\tilde u+\tilde v)/b^n\big\rfloor
\;\in\; b^n\mathbb{Z}/b^{n+1}$$
is exactly "$1$ iff the addition carries out of position $n-1$". It is a normalized
$2$-cocycle, and its class in $H^2(\mathbb{Z}/b^n;\mathbb{Z}/b) \cong \mathbb{Z}/b$ is
**nonzero**.

*Proof.* That $c_n$ is a $2$-cocycle is the standard fact that the coboundary of any
set-theoretic section of a central extension is one. For $H^2$: with trivial action,
$H^2(\mathbb{Z}/m;A) \cong A/mA$; here $A = \mathbb{Z}/b$ and $m=b^n$ with $n\ge1$, so
$A/mA = \mathbb{Z}/b$. The class vanishes iff the extension splits, iff
$\mathbb{Z}/b^{n+1} \cong \mathbb{Z}/b^n \oplus \mathbb{Z}/b$ as abelian groups. But the
right side has exponent $\operatorname{lcm}(b^n,b) = b^n < b^{n+1}$, the exponent of the
left side. So the class is nonzero. $\square$

**Corollary 2.11.1.** *No choice of digit set eliminates carrying.* A carry-free
positional system for $\mathbb{Z}/b^{n+1}$ over $\mathbb{Z}/b^n$ would be precisely a
group-theoretic splitting of the above extension, which does not exist for $b\ge2$.

**Residual 2.5: the carry cocycle $[c_n]\ne 0$ in $H^2(\mathbb{Z}/b^n;\mathbb{Z}/b)$.**
It is not bookkeeping and not an artifact of the alphabet $\{0,\dots,b-1\}$; it is the
extension class of the chart. (**CLASSICAL**; Isaksen, *A cohomological viewpoint on
elementary school arithmetic*, Amer. Math. Monthly 109 (2002) 796–805 — see §9 for the
citation's pramāṇa grade. The digit-sum form of the same phenomenon is
`DIGIT_CRYSTAL.md` (2.1)–(2.2), which also proves that the complement $E$ exchanges carry
with borrow while reversal $D$ exchanges trailing with *leading*.)

### 2.5 (a) $\leftrightarrow$ (f): the residual is the additive structure

**Theorem 2.12 (FTA as a chart statement; CLASSICAL).** $e : \bigoplus_{p\in P}\mathbb{N}
\to (\mathbb{N}_{>0},\times)$, $(a_p)\mapsto\prod p^{a_p}$, is an isomorphism of
commutative monoids.

*Sketch, to display the dependency.* Surjectivity: strong induction — every $n>1$ has a
least divisor $>1$, which is prime. Injectivity: Euclid's lemma ($p \mid ab \Rightarrow
p\mid a$ or $p\mid b$), from Bézout, from division with remainder, from the well-ordering
of $\mathbb{N}$. **Every step is an instance of induction, i.e. of chart (a).** Chart (f)
is proved *from* chart (a) and not conversely; this is used in §4. $\square$

**Theorem 2.13 (the exact residual).**

1. $\operatorname{Aut}(\mathbb{N}_{>0},\times) \cong \operatorname{Sym}(P)$, of
   cardinality $2^{\aleph_0}$.
2. $\operatorname{Aut}(\mathbb{N},+,\times) = \{\mathrm{id}\}$, and likewise
   $\operatorname{Aut}(\mathbb{N}_{>0},+,\times) = \{\mathrm{id}\}$.
3. For $\sigma \in \operatorname{Sym}(P)$ let $\hat\sigma$ be the induced multiplicative
   automorphism and $a +_\sigma b := \hat\sigma(\hat\sigma^{-1}a + \hat\sigma^{-1}b)$.
   Then $(\mathbb{N}_{>0},+_\sigma,\times)$ is a semiring isomorphic to
   $(\mathbb{N}_{>0},+,\times)$, and $+_\sigma = +$ iff $\sigma = \mathrm{id}$. Hence
   there are exactly $2^{\aleph_0}$ distinct additive structures compatible with the
   given multiplication.

*Proof.* (1) In a free commutative monoid the irreducibles are exactly the free
generators (an element is irreducible iff its exponent vector has total weight $1$). An
automorphism permutes irreducibles and, by freeness, is determined by that permutation;
conversely every permutation extends. $P$ is countably infinite (Euclid), so
$|\operatorname{Sym}(P)| = 2^{\aleph_0}$. (2) $0$ and $1$ are characterized as the
neutral elements, hence fixed; every $n$ is $1+\cdots+1$, hence fixed. (3) $\hat\sigma$
is by construction an isomorphism $(\mathbb{N}_{>0},+,\times)\to
(\mathbb{N}_{>0},+_\sigma,\times)$. If $+_\sigma = +$ then $\hat\sigma \in
\operatorname{Aut}(\mathbb{N}_{>0},+,\times) = \{\mathrm{id}\}$ by (2), so
$\sigma = \mathrm{id}$. $\square$

**Residual 2.6: addition — and it is exactly the rigidifier.** The forgetful map
$\operatorname{Aut}(\mathbb{N},+,\times) \to \operatorname{Aut}(\mathbb{N}_{>0},\times)$
is the inclusion of the trivial group into a group of cardinality $2^{\aleph_0}$. The
multiplicative chart is maximally floppy; adjoining $+$ rigidifies it completely.

**Corollary 2.13.1 (what the multiplicative chart cannot express).** Any $S \subseteq
\mathbb{N}_{>0}$ invariant under $\operatorname{Aut}(\mathbb{N}_{>0},\times)$ is a union
of $\operatorname{Sym}(P)$-orbits, hence determined by the multiset of exponents alone.
In particular the set $\{p \in P : p+2 \in P\}$ is not such a set: it contains $3$ and
omits $23$, so a transposition of $P$ moves it.

> **Guardrail, stated as strongly as the charter requires.** Corollary 2.13.1 is a
> triviality about the weakness of the multiplicative monoid as a structure. It says
> that additive conditions are not expressible in chart (f), and **nothing else**. It is
> not an explanation of, and implies nothing whatsoever about, the difficulty of
> Goldbach, twin primes, $abc$, RH, or any other open problem. The charter
> (`PYTHAGOREAN_EUCLIDEAN_MACHINE.md` §2: "aesthetic resonance without reconstruction
> becomes mythology") forbids that inflation, and this note makes no such claim.
> The honest content is: *additive–multiplicative interaction problems are not
> expressible in either chart alone; each is invisible to the other's automorphism
> group.* That is a statement about charts.

### 2.6 Summary of the transition maps

| From $\to$ To | Map | Status | Fibre / residual |
|---|---|---|---|
| (a) $\leftrightarrow$ (b) | $s \leftrightarrow +1$ | proved §2.1 | trivial group; **contractible** space of comparisons |
| (c) $\to$ (a),(b) | $\pi_0$ | proved §2.2 | $S_n$; homotopy fibre $BS_n$ |
| (d) $\to$ (c) | forget the order | proved §2.3 | $S_n$-torsor of linear orders |
| (d) $\to$ (a) | $\omega \cong \mathbb{N}$ | proved §2.3 | trivial on $\mathbb{N}$; nontrivial at $\omega$ |
| (a) $\to$ (e) | $L^{-1}$, base $b$ | proved §2.4 | base ($\operatorname{rad} b$), endian $\mathbb{Z}/2$, carry $[c_n]\ne0$ |
| (e) $\to$ (f) | — | Prop. 2.9 | shared locus exactly $\{p \mid b\}$ |
| (a) $\to$ (f) | FTA | classical, §2.5 | $\operatorname{Sym}(P)$ vs. trivial: addition |
| (f) $\to$ (g) | $\mathbb{Q}_{>0} = $ group completion | §5.3 | free abelian on $P$ |

---

## 3. The univalent restatement: every residual is homotopy

This section is the hinge, not an appendix. Charter §7 (Voevodskian identity: equivalence
may support identity *only for the specified structure*; automorphisms can matter) is
what makes the residual table of §2 a single statement rather than a list.

### 3.1 The type of finite types

Work in univalent foundations. For $n : \mathbb{N}$ define

$$BS_n \;:\equiv\; \textstyle\sum_{X:\mathcal{U}} \lVert X \simeq \mathrm{Fin}\,n \rVert,
\qquad
\mathbf{FinType} \;:\equiv\; \textstyle\sum_{X:\mathcal{U}} \exists n.\, \lVert X \simeq \mathrm{Fin}\,n\rVert .$$

$BS_n$ is *the type of $n$-element types*, pointed at $\mathrm{Fin}\,n$
(**FETCHED**: Mangel–Rijke, *Delooping the sign homomorphism in univalent mathematics*,
arXiv:2301.10011, abstract: "The $n$-th abstract symmetric group $S_n$ of all bijections
$[n]\simeq[n]$, for instance, corresponds to the concrete group of all $n$-element types.
The sign homomorphism from $S_n$ to $S_2$ should therefore correspond to a pointed map
from the type $BS_n$ of all $n$-element types to the type $BS_2$ of all $2$-element
types.").

**Theorem 3.1 (univalent form of Theorems 2.2 and 2.3).**

1. $\mathbf{FinType} \simeq \sum_{n:\mathbb{N}} BS_n$.
2. $BS_n$ is connected, and $\Omega(BS_n,\mathrm{Fin}\,n) \simeq
   (\mathrm{Fin}\,n \simeq \mathrm{Fin}\,n) \simeq S_n$.
3. $\lVert \mathbf{FinType}\rVert_0 \simeq \mathbb{N}$.

*Proof.* (1) By definition, being finite is $\exists n.\lVert X\simeq \mathrm{Fin}\,n\rVert$,
and the $n$ is unique (a mere proposition) by the pigeonhole principle, so the
existential may be replaced by a $\Sigma$. (2) Connectedness is the propositional
truncation in the definition. The loop space computation is **univalence**:
$\mathrm{Id}_{\mathcal{U}}(X,Y) \simeq (X\simeq Y)$, and a path in $BS_n$ is a path in
$\mathcal{U}$ together with a path in a proposition, hence just the former. (3)
$\pi_0$ of a $\Sigma$ over a set is the $\Sigma$ of the $\pi_0$'s, and
$\lVert BS_n\rVert_0 \simeq \mathbf{1}$ by connectedness. $\square$

> **The statement of the atlas.** *A natural number is a connected component of the type
> of finite types. The numeral is $\pi_0$. The space over that component is $BS_n$, whose
> fundamental group is $S_n$.* The "residual $S_n$ of decategorification" is therefore
> not a group somebody chose to remember: it is $\pi_1$ of the object that truncation
> collapses.

Univalence is exactly what makes $BS_n$ a *space* rather than a formal symbol. Without
it, $\mathrm{Id}_{\mathcal{U}}(X,Y)$ is opaque and $BS_n$ is a name; with it, the
identity type of the universe *is* the type of bijections, and the loop space *is* the
symmetric group. Symbol and geometry are forced to agree because the symbolic statement
"$m=n$" is the set-truncation of the geometric object "the type of bijections."

### 3.2 Ordinals: the total space of the universal torsor

**Theorem 3.2 (univalent form of Theorem 2.5).** For each $n$,
$$\textstyle\sum_{X : BS_n} \mathrm{LinOrd}(X) \quad\text{is contractible.}$$

*Proof.* A linear order on an $n$-element type $X$ is the same datum as an equivalence
$X \simeq \mathrm{Fin}\,n$ (send the $k$-th smallest element to $k$; conversely transport
the standard order). So the displayed type is equivalent to
$\sum_{X:\mathcal{U}}(X \simeq \mathrm{Fin}\,n)$, which by univalence is equivalent to
$\sum_{X:\mathcal{U}}(X = \mathrm{Fin}\,n)$, a based path space, which is contractible.
$\square$

This is the universal cover $ES_n \to BS_n$: chart (d) is the **total space**, chart (c)
is the **base**, charts (a),(b) are the **set-truncation of the base**. Charts (c)+order
and chart (a) have the same $\pi_0$ for completely different reasons — one because its
total space is contractible, the other because it is a truncation — and *that* is why
their arithmetics diverge at $\omega$: contractibility of the finite total spaces has no
infinite analogue. Well-orders on an infinite set are neither unique nor uniquely
isomorphic, so $\sum_{X}\mathrm{WellOrd}(X)$ over an infinite cardinality is not
contractible, and ordinal addition stops being commutative exactly there.

### 3.3 Multiplication: what the space over chart (f) is, and the honest negative

The additive chart categorifies perfectly: $(\mathbb{F},\sqcup)$ is the free symmetric
monoidal category on one object and its $\pi_0$ is the free commutative monoid on one
generator.

For the multiplicative chart the corresponding question is: *is
$(\mathbb{F}_{\ge1},\times)$ the free symmetric monoidal groupoid on the primes?* This is
answerable and the answer is **no**; §6 proves it, with an exact index. So: the space
over chart (f) exists (the free symmetric monoidal groupoid on
$\coprod_{p\in P}BS_p$) but it is **not** the multiplicative structure of
$\mathbf{FinType}$. *Unique factorization is a $\pi_0$-statement with no groupoid-level
counterpart except at the irreducibles.* This is stated as a limitation, not as a
mystery, and §6 gives the obstruction.

### 3.4 Digits: a torsor of frames, not a $\pi_1$

Proposition 2.10 in this language: the two truncation systems form a $\mathbb{Z}/2$-torsor
$\mathcal{T}$, i.e. a point of $B(\mathbb{Z}/2)$ = the type of $2$-element types. The
digit-value map trivializes it ($J\circ R_\infty = L$, `DIGIT_CRYSTAL.md` Thm 4.4), so
transport along the deck transformation is the identity *in digit coordinates*. What is
not trivialized is the structure: only one sheet carries the group law
(`DIGIT_CRYSTAL.md` Lemma 4.1), so $\langle D\rangle$ is exactly the kernel of the map
from the chart's Klein-four symmetry to $\operatorname{Homeo}(\mathbb{Z}_b)$
(Corollary 4.5).

**Honest limit.** This is a torsor of *chart frames*, not $\pi_1$ of $\mathbb{N}$ or of
$\mathbb{Z}_b$. Unlike Residual 2.2 ($=\pi_1 BS_n$) and Residual 2.3 ($=$ the universal
torsor of Theorem 3.2), the endian $\mathbb{Z}/2$ is *not* a homotopy group of the
object; the slogan "every residual is homotopy" is true for (c),(d) exactly and true for
(e) only in the weaker sense of "a torsor under a group acting on charts." Saying
otherwise would be exactly the metaphor-promotion the charter forbids.

---

## 4. The dependency theorem (the education inversion, made exact)

**Definition 4.1 (choice-free presentation).** A *presentation scheme* for $\mathbb{N}$
is a family $\Theta$ assigning to each parameter $\theta$ in a parameter class $\mathcal{P}$
a structure $\Theta(\theta)$ together with an identification with $\mathbb{N}$. The
scheme is **choice-free** if $\mathcal{P}$ is a point — equivalently, if the presentation
is given by a universal property mentioning no parameters, so that the presenting object
is determined up to a *contractible* space of identifications.

**Theorem 4.2 (Dependency).**

**(1) Charts (a), (b), (c), (d) are choice-free.**
- (a) is "the initial $(1+X)$-algebra": initial objects are unique up to unique
  isomorphism, and by Theorem 3.1's framing the type of such identifications is
  contractible. No parameter.
- (b) is "the free monoid on the terminal object": the terminal object $1$ is itself
  unique up to unique isomorphism, so "one generator" is not a choice. No parameter.
- (c) is "the free symmetric monoidal category on one object", then $\pi_0$. Same
  argument. No parameter.
- (d) is "the least infinite ordinal". No parameter.

**(2) Chart (e) is the value of a construction $\mathrm{Dig}(b,\varepsilon,s)$ on three
parameters, none of them supplied by $\mathbb{N}$, and it presupposes chart (a) besides.**
- **(i) a base** $b \ge 2$ — equivalently a finite quotient $\mathbb{N} \twoheadrightarrow
  \mathbb{Z}/b$, equivalently the multiplicative submonoid $\{b^n\}$. Nonredundant by
  Proposition 2.8/Corollary 2.8.1: $\operatorname{rad}(b)$ is a chart invariant and
  distinct radicals give charts with no continuous intertranslation.
- **(ii) an endianness** $\varepsilon\in\mathbb{Z}/2$ — a trivialization of the torsor
  $\mathcal{T}$ of Proposition 2.10. Nonredundant: only one sheet admits a group-valued
  limit (`DIGIT_CRYSTAL.md` Lemma 4.1), and the chart symmetry group drops from
  $(\mathbb{Z}/2)^2$ to $\mathbb{Z}/2$ on the completion with kernel exactly the
  endian generator (Corollary 4.5).
- **(iii) a digit section** $s$ (a transversal for $\mathbb{Z}/b$ in $\mathbb{Z}$), whose
  coboundary is the carry. Nonredundant, and irreducibly so: by Proposition 2.11 the
  class $[c_n]$ is nonzero for *every* choice, so no section makes the chart carry-free
  (Corollary 2.11.1).
- **presupposition:** $\mathrm{Dig}$ is *defined using chart (a)*. The alphabet
  $\{0,\dots,b-1\}$ is an initial segment produced by iterating the successor; the
  evaluation $\sum c_i b^i$ uses $+$ and $\times$, which are defined by primitive
  recursion (Theorem 2.1); the existence-and-uniqueness proof (Theorem 2.7) is an
  induction. Charts (a)–(d) use none of $b$, $\varepsilon$, $s$.

**(3) The exact statement.**

> **Positional notation is a chart of $\pi_0$ requiring three choices — a finite quotient
> (the base), a trivialization of a $\mathbb{Z}/2$-torsor (the endianness), and a
> $2$-cocycle representative whose class is never zero (the carry) — on top of a
> generator/successor which it does not supply and which charts (a)–(d) do.
> Symmetry and generation require zero choices, because they live one level up, before
> truncation: chart (c) presents the *type* whose $\pi_0$ is $\mathbb{N}$, and its
> universal property is parameter-free.**

**(4) The asymmetry of definability, stated so it cannot be over-read.** The map
$\{\text{base-}b\text{ charts}\} \to \{\text{chart (a)}\}$ is surjective with fibres
indexed by the parameter space of (2); there is no section singled out by any universal
property of $\mathbb{N}$. The claim is **not** that $b$ is undefinable from $\mathbb{N}$
— of course $10$ is a definable element of $(\mathbb{N},+,\times)$. The claim is that $b$
is not **forced**: the characterizations of $\mathbb{N}$ in charts (a)–(d) mention no
base, no orientation, and no cocycle, while chart (e) cannot be written down until all
three are fixed. That is the dependency order, and it is a mathematical fact about the
definitions, provable from Theorem 2.1, Theorem 2.7, Proposition 2.8, Proposition 2.10
and Proposition 2.11.

**Corollary 4.3 (pedagogical corollary — dependency order only).** A curriculum ordered
by the mathematics' own dependency order introduces generation (successor, iteration,
free monoid) and symmetry (bijection, $S_n$, the groupoid of finite sets) **before**
positional notation, because positional notation is definable from them plus three
choices and they are not definable from it without those choices being made first. In
the language of §3: **teaching numerals first teaches $\pi_0$ first — the shadow before
the space.** "Group theory before place values" is exactly "geometry before its
truncation."

> **This corollary is a claim about dependency order and nothing else.** It is *not* an
> empirical claim about how humans learn, in what order they should be taught, what is
> pedagogically effective, or what any curriculum ought to do. This note contains no
> empirical content of any kind and cannot support such a claim; anyone quoting
> Corollary 4.3 as evidence about learners is misquoting it.
> `DEPENDENT_ORIGINATION.md` §4 filed this idea as an open lane and labelled it
> speculation. This note supplies the *dependency half* exactly and explicitly declines
> to upgrade the empirical half.

---

## 5. Completions (charter §4)

$\mathbb{N}$ has several ambient completions, one per structure completed along. The
recurring finding — already recorded once in `RATIONAL_CIRCLE_ATLAS.md` §5.3 — is that
**completion is a functor of a structure, not of a set**, so a chart carrying two
structures has two completions, and they need not be comparable.

### 5.0 The structure that dies first, and everywhere

**Theorem 5.1.** No completion of $\mathbb{N}$ retains induction. Precisely: if $C$ is a
$(1+X)$-algebra containing $\mathbb{N}$ as a proper subalgebra (same $0$, $s|_{\mathbb{N}}$
the successor), then $C$ is not an initial $(1+X)$-algebra and Proposition 1.2 fails in
$C$ with witness $S=\mathbb{N}$.

*Proof.* $\mathbb{N} \subsetneq C$ is a proper subalgebra; Proposition 1.2 applied to $C$
would force $\mathbb{N}=C$. $\square$

Already $\mathbb{Z}$ falsifies induction ($\mathbb{N}\subsetneq\mathbb{Z}$ contains $0$
and is closed under successor). Chart (a)'s entire content is the first casualty of every
completion in this section.

### 5.1 Group completion $\to \mathbb{Z}$

$K(\mathbb{N},+) = \mathbb{Z}$, the left adjoint to $\mathbf{Ab}\to\mathbf{CMon}$
evaluated at $\mathbb{N}$ (CLASSICAL: Grothendieck group).
**Passes:** $+$, $\times$, the total order (as an ordered ring), cancellation,
$\operatorname{Aut}(\mathbb{Z},+,\times)=\{\mathrm{id}\}$.
**Dies:** induction (Theorem 5.1), well-ordering, the initial-algebra property,
$\operatorname{Aut}(\mathbb{Z},+)=\{\pm1\}$ is now nontrivial (a residual *created* by
completion).

### 5.2 Field of fractions $\to \mathbb{Q}$

Localization at $\mathbb{N}_{>0}$, universal among ring maps inverting nonzero integers.
**Passes:** $+,\times$, the total order, density in $\mathbb{R}$.
**Dies:** discreteness (no successor: $\mathbb{Q}$ has no least positive element, so
chart (a) has no analogue at all), well-ordering, and unique factorization becomes
$\mathbb{Z}$-graded rather than $\mathbb{N}$-graded (§5.3).

### 5.3 Two group completions of one set

$(\mathbb{N},+) \rightsquigarrow \mathbb{Z}$, free abelian of rank $1$.
$(\mathbb{N}_{>0},\times) \rightsquigarrow \mathbb{Q}_{>0} \cong \bigoplus_{p\in P}\mathbb{Z}$,
free abelian of countably infinite rank.
Both receive $\mathbb{N}_{>0}$; they are not isomorphic (rank $1$ vs. rank $\aleph_0$)
and there is no group map between them restricting to the identity on
$\mathbb{N}_{>0}$ (such a map would have to be additive and multiplicative
simultaneously). **First instance of two incomparable completions of one chart, obtained
by completing along two different structures on the same set.**

### 5.4 Order completion: $\mathbf{Ord}$ vs. $\mathbf{Card}$ — second instance

The Dedekind–MacNeille completion of the poset $(\mathbb{N},\le)$ is $\mathbb{N}\cup\{\infty\}
= \omega+1$. Continuing past it gives the ordinals; continuing chart (c) past it gives the
cardinals. Both extend $\mathbb{N}$ with $+$ and $\times$; both restrict to the *same*
arithmetic on $\mathbb{N}$ (Theorem 2.6(1)); and they disagree:

| | $\mathbf{Ord}$ | $\mathbf{Card}$ |
|---|---|---|
| completes | chart (d) | chart (c) |
| $+$ commutative? | **no** ($1+\omega\ne\omega+1$) | yes |
| $\cdot$ commutative? | **no** ($2\cdot\omega\ne\omega\cdot2$) | yes |
| cancellation | left only | fails badly |
| comparison map | $\alpha\mapsto|\alpha|$: surjective, not injective | $\kappa\mapsto$ initial ordinal: injective, not additive |

Neither map is an isomorphism: $|{-}|$ is not injective, and the initial-ordinal map does
not preserve $+$ ($\aleph_0+\aleph_0=\aleph_0 \mapsto \omega$, but
$\omega+\omega\ne\omega$). **Second instance.** And note what it certifies: Residual 2.3
(the linear order) is inert on $\mathbb{N}$ and is exactly what separates the two
completions.

### 5.5 Metric completions: $\mathbb{R}$ and $\mathbb{Z}_b$ — third instance, the sharpest

**Proposition 5.2.** $(\mathbb{N},|\cdot|_\infty)$ is already complete (distinct integers
are at distance $\ge1$, so Cauchy sequences are eventually constant), whereas
$(\mathbb{N},|\cdot|_b)$ is not, and its completion is $\mathbb{Z}_b =
\varprojlim_n\mathbb{Z}/b^n$.

So the archimedean route to $\mathbb{R}$ passes through §5.2 first: $\mathbb{R}$ is a
completion of $\mathbb{Q}$, not directly of $\mathbb{N}$. Ostrowski's theorem
(**CLASSICAL, FETCHED**) says these are *all* of them: every nontrivial absolute value on
$\mathbb{Q}$ is equivalent to $|\cdot|_\infty$ or to some $|\cdot|_p$. The
incomparability is therefore a classification, not a curiosity.

**Theorem 5.3 (the sharp contrast).** $\mathbb{N} \subset \mathbb{R}$ is **closed and
discrete**; $\mathbb{N}\subset\mathbb{Z}_b$ is **dense**. Moreover there is no continuous
map in either direction restricting to the identity on $\mathbb{N}$.

*Proof.* Closed and discrete in $\mathbb{R}$: distinct integers are $\ge1$ apart. Dense in
$\mathbb{Z}_b$: by construction of the inverse limit, each $\mathbb{Z}/b^n$ is hit by
$\{0,\dots,b^n-1\}$. No map $\mathbb{R}\to\mathbb{Z}_b$: $\mathbb{R}$ is connected and
$\mathbb{Z}_b$ is totally disconnected, so any continuous map is constant, which cannot
restrict to $\mathrm{id}$ on $\mathbb{N}$. No map $\mathbb{Z}_b\to\mathbb{R}$:
$\mathbb{Z}_b$ is compact so the image is bounded, but $\mathbb{N}$ is unbounded in
$\mathbb{R}$. $\square$

**Structures:** $+$ and $\times$ pass to both. Order passes to $\mathbb{R}$ only (a
compact Hausdorff topological group admits no compatible translation-invariant total
order unless trivial). The successor passes to both, but on $\mathbb{Z}_b$ it becomes the
**odometer** $T(x)=x+1$, and $\mathbb{N}$ is now a dense proper subset closed under $T$
containing $0$ — i.e. exactly the failure of induction (Theorem 5.1) made visible as a
dynamical fact. Integrality dies in $\mathbb{R}$ (density of $\mathbb{Q}$); the order and
archimedean comparison die in $\mathbb{Z}_b$; $\mathbb{Z}_b$ has zero divisors when $b$ is
not a prime power.

**Naming the recurring phenomenon.** Three instances here (§5.3, §5.4, §5.5) plus the one
recorded in `RATIONAL_CIRCLE_ATLAS.md` §5.3 (topological completion $S^1$ vs. algebraic
divisible hull, "two different correct answers"). The observation, stated as an
observation and *not* as a theorem:

> **Two-completions.** "The completion of a chart" is not well-posed. A chart carries
> several structures; completing along different ones yields objects that may be
> incomparable, and the difference between them is exactly a residual that was inert on
> the chart. In each of the four instances the residual responsible is identifiable:
> the choice of monoid ($+$ vs. $\times$), the linear order, the absolute value, and the
> topology-vs-algebra split.

### 5.6 Profinite completion $\hat{\mathbb{Z}}$ and the odometer

$\hat{\mathbb{Z}} = \varprojlim_n \mathbb{Z}/n \cong \prod_{p}\mathbb{Z}_p$
(**CLASSICAL, FETCHED**: nLab, *profinite completion of the integers*; the product
decomposition is CRT, and $\mathbb{Z}\hookrightarrow\prod_p\mathbb{Z}_p$ is the diagonal
embedding with dense image). Universal property: terminal among profinite groups
receiving a map from $\mathbb{Z}$ with dense image.

**Dynamical presentation.** $T(x)=x+1$ on $\hat{\mathbb{Z}}$ is a minimal equicontinuous
homeomorphism — the *odometer* or *adding machine*; odometers are, up to topological
conjugacy, exactly the equicontinuous Cantor minimal systems (**CLASSICAL**; §9 grades
this citation). $(\hat{\mathbb{Z}},T)$ is the universal one: every $\mathbb{Z}_b$ is the
quotient $\prod_p\mathbb{Z}_p \twoheadrightarrow \prod_{p\mid b}\mathbb{Z}_p$, equivariantly.

**Proposition 5.4 (place value *is* the odometer, exactly).** Base-$b$ positional
notation is the coordinate system on the quotient $\mathbb{Z}_b$ of $\hat{\mathbb{Z}}$
furnished by the cofinal tower $(\mathbb{Z}/b^n)_n$. The tower $\{b^n\}$ is cofinal in the
divisibility order only among $\{m : \operatorname{rad}(m)\mid\operatorname{rad}(b)\}$;
hence **no single positional chart sees $\hat{\mathbb{Z}}$**, and
$\hat{\mathbb{Z}} = \varprojlim_b \mathbb{Z}_b$ over the radical-divisibility order.

*Proof.* Cofinality: $m \mid b^n$ for some $n$ iff every prime of $m$ divides $b$. The
limit statement follows since $\{b^n : b\ge2, n\ge1\}$ is cofinal in $(\mathbb{N}_{>0},\mid)$.
$\square$

`DEPENDENT_ORIGINATION.md` §4 asserted "place value *is* the odometer" informally and
filed it as an open lane. Proposition 5.4 plus Proposition 2.11 (carrying as the extension
class) is its exact form: *digits are coordinates on a quotient of $\hat{\mathbb{Z}}$, and
carrying is the cocycle of the tower.*

**Passes to $\hat{\mathbb{Z}}$:** $+$, $\times$ (it is a topological ring), the successor
(as the odometer), all congruence information.
**Dies:** the order, induction, integrality, being a domain ($\prod_p\mathbb{Z}_p$ has
zero divisors), and the archimedean size comparison that makes chart (e)'s leading digit
meaningful — which is `DIGIT_CRYSTAL.md` Theorem 4.2/4.3 again, from the other side.

---

## 6. The crystal (charter §8): worked, and **refuted**

Charter §8 demands: name both dualities and their domains; construct every corner; prove
or refute involutivity; compare the composites; classify fixed points and holonomy; feed
the residual back. Proposed pair: $D$ = decategorification ($\mathbf{FinType}\to\mathbb{N}$),
$E$ = the multiplicative/additive chart swap.

**Step 1 — domains.** $D$ is defined on symmetric monoidal groupoids, valued in
commutative monoids. $E$ is defined on the two-element set of monoid structures
$\{(\mathbb{N},+),(\mathbb{N}_{>0},\times)\}$.

**Step 3 — involutivity: REFUTED for $D$.** $D = \pi_0$ has no canonical inverse.
Categorification is a *choice*, not an operation: Baez–Dolan (**FETCHED**, arXiv
math/0004133, abstract: "Categorification is the process of replacing equations by
isomorphisms") present it explicitly as a creative act with no canonical inverse to
decategorification. Concretely, $\mathbb{N}$ admits many inequivalent symmetric monoidal
groupoids with $\pi_0 = \mathbb{N}$ — e.g. $\mathbb{F}$ itself, and the discrete groupoid
$\mathbb{N}$. So $D^2$ is not defined, the four-corner square cannot be built, and
**the crystal does not exist. It is dropped, per the charter's instruction not to force
it.**

**What the attempt produced instead (and this is worth keeping).** The one honest square
one *can* draw compares two free symmetric monoidal groupoids over the same $\pi_0$.

Let $\mathcal{P} := \coprod_{p\in P} BS_p$ and let $\mathrm{Sym}(\mathcal{P})$ be the free
symmetric monoidal groupoid on it: its components are indexed by finitely supported
exponent vectors $(a_p)$, with automorphism group $\prod_p (S_p \wr S_{a_p})$. Let
$$\Pi : \mathrm{Sym}(\mathcal{P}) \longrightarrow (\mathbb{F}_{\ge1},\times)$$
send a multiset to the product of the corresponding sets.

**Theorem 6.1 (unique factorization does not categorify).** $\Pi$ is bijective on $\pi_0$
(this is exactly Theorem 2.12, FTA) and faithful, but it is **full precisely at the
components $n=1$ and $n$ prime**. For composite $n = \prod_p p^{a_p}$ the image of
$\prod_p(S_p\wr S_{a_p})$ in $S_n$ is a proper subgroup of index
$$\big[S_n : \textstyle\prod_p (S_p\wr S_{a_p})\big] \;=\; \frac{n!}{\prod_p (p!)^{a_p}\,a_p!}\;>\;1 .$$

*Proof.* $\pi_0$-bijectivity is FTA. *Faithfulness*: an automorphism of the product
structure acting trivially on the product set $\prod_{p,i}[p]$ must be trivial on each
factor, since each factor has $p\ge2$ elements and hence at least two distinct coordinate
values to detect a nontrivial permutation. *Fullness at $n=p$*: then $a_p=1$ and the group
is $S_p\wr S_1 = S_p = S_n$; at $n=1$ both groups are trivial. *Properness for composite
$n$*: write $n=ab$ with $a,b\ge2$ by splitting the multiset. The image preserves the
partition of $[n]$ into the $a$ fibres of the first projection, each of size $b$. That
partition is not the only partition of $[n]$ into $a$ blocks of size $b$ (swap two points
lying in different blocks to obtain another), and $S_n$ acts transitively on the set of
such partitions, so the stabilizer — which contains the image — is a proper subgroup. The
order of the image is $\prod_p(p!)^{a_p}a_p!$ by faithfulness. $\square$

**The residual, stated.**

> **Addition categorifies; multiplication does not categorify freely.** $(\mathbb{F},\sqcup)$
> *is* the free symmetric monoidal category on one object, so $(\mathbb{N},+)$ is the
> $\pi_0$ of a free structure and nothing is lost but $\pi_1$. $(\mathbb{F}_{\ge1},\times)$
> is *not* the free symmetric monoidal groupoid on the primes: the comparison map is
> faithful and $\pi_0$-bijective but never full above the irreducibles, with residual
> index $n!/\prod_p (p!)^{a_p}a_p!$. An $n$-element set has automorphisms that no
> factorization of $n$ can see.

This is the structural form of "the additive and multiplicative charts do not commute,"
and it is stated with no claim about any open problem — the same guardrail as
Corollary 2.13.1 applies verbatim. **Verdict on §8: no crystal. Residual retained.**

---

## 7. Why the two halves must say the same thing

Charter §2 asks for Pythagorean perception and Euclidean reconstruction, and warns that
resonance without reconstruction is mythology. Univalent foundations is the setting in
which the warning has teeth automatically, and this is the reason §3 is structural rather
than decorative.

In univalent foundations an identity is a **path**. "These two presentations are the same
object" is therefore not a metatheoretic remark made in the margin; it is an inhabitant of
a type inside the theory, and transport along it carries every structure — including the
automorphisms — with it. Consequently:

- a *transition map* in this atlas is an equivalence, i.e. a path, and by univalence a
  path in $\mathcal{U}$ **is** a bijection;
- a *residual* is the automorphism group of the endpoint, i.e. the loop space at it;
- "the residual is nothing" (§2.1) upgrades from "there exists an isomorphism" to "the
  type of isomorphisms is contractible" — a strictly stronger statement that is
  expressible only because identity is an object;
- a symbol cannot drift from its geometry, because the symbolic statement ($m=n$) is
  *defined* as the truncation of the geometric one (the type of bijections).

Voevodsky's own stated motivation was precisely the drift of symbol from content.
**FETCHED** (Quanta Magazine, *Will Computers Redefine the Roots of Math?*, 2015): "In
1999 he discovered an error in a paper he had written seven years earlier"; the article
reports that in an IAS newsletter piece Voevodsky "wrote that the experience scared him.
He began to worry that unless he formalized his work on the computer, he wouldn't have
complete confidence that it was correct," and quotes him directly: *"The world of
mathematics is becoming very large, the complexity of mathematics is becoming very high,
and there is a danger of an accumulation of mistakes."* (The frequently repeated further
detail that the error was the Kapranov–Voevodsky argument refuted by Simpson's
counterexample was **not** verified in this session and is not asserted here.)

**Formalization targets for the sibling Cubical lane.** The statements in this note that
are worth machine-checking, in dependency order: Theorem 2.1 (charts (a)$\equiv$(b), with
the *contractibility* of the comparison type, not merely its inhabitation); Theorem 3.1
(the $\coprod BS_n$ decomposition and $\Omega BS_n \simeq S_n$ — the §12.1 seed already
covers the loop-group half); Theorem 3.2 (contractibility of
$\sum_{X:BS_n}\mathrm{LinOrd}(X)$, a two-line univalent proof that is the whole content of
"ordinals rigidify what cardinals truncate"); Theorem 2.7 ($\mathbb{N}\simeq$ digit words)
together with Proposition 2.11 (the carry class), which is the pair that makes
Theorem 4.2's dependency claim machine-visible.

*Status (2026-08-14).* Checked in `formal/cubical/NaturalMachine/AtlasResiduals.agda`
(Agda 2.6.3 + cubical v0.5, `--safe`, exit 0 standalone and via the root
`NaturalMachine.agda`): Theorem 2.1's contractibility half — `ℕ-isInitial`,
`ℕ-recursor-unique`, `ℕ-algebra-endo-is-id`, and Residual 2.1(1) in general as
`isContrAlgIso` (the type of algebra isomorphisms between two initial algebras is
contractible) — and the **univalence half** of Theorem 3.2, `isContrOrdTotal`,
which defines $\mathrm{LinOrd}(X) := (X\simeq\mathrm{Fin}\,n)$ by fiat and therefore
proves the based-path-space contractibility but **not** the order-theoretic
identification.

*Theorem 3.2, status (2026-08-14): **RESOLVED in full**.* The order-theoretic half is
now checked in `formal/cubical/NaturalMachine/LinearOrderFinite.agda` (same toolchain,
`--safe`, no postulates, no holes, exit 0 standalone and via the root aggregate, which
imports it). That module defines $\mathrm{LinOrd}'(X)$ as a genuine order structure — a
relation with prop-valuedness, reflexivity, antisymmetry, transitivity and **mere**
(truncated) totality; decidability of the order is *derived* there from mere totality
plus the decidable equality that finiteness supplies, not assumed, so the axioms are
exactly the classical ones and none is constructively stronger — and proves
`linOrd′≃` $:\ \mathrm{LinOrd}'(X)\simeq(X\simeq\mathrm{Fin}\,n)$ for every $X$ with
$\lVert X\simeq\mathrm{Fin}\,n\rVert_1$: forward the rank map
$x\mapsto\#\{z\mid z<x\}$, proved an equivalence (injective by antisymmetry, surjective
by a finite pigeonhole proved there by counting fibres), backward transport of the
standard order, with both round trips as paths. Composing it fibrewise with
`isContrOrdTotal` gives `isContrOrdTotal′`: $\sum_{X:BS_n}\mathrm{LinOrd}'(X)$ is
contractible — Theorem 3.2 as stated in §3.2, with orders and not rank listings in the
fibre. The proof counts down-sets rather than inducting on $n$; the obligation as
recorded in `AtlasResiduals` predicted an induction, and was wrong about the method,
not the content. Prior art, per `notes/HOTT_ECOSYSTEM_MAP.md`: UniMath states this
existence direction and `Abort`s it; mathlib4 has it classically as `monoEquivOfFin`;
no surveyed constructive library has it.

Theorem 3.1's loop-group half was already covered by
`PathIsSymmetry`/`Decategorification`; Theorem 2.7 + Proposition 2.11 remain unclaimed.

*Theorem 2.7, status (2026-08-14): **already discharged, and not by this pass** — the
sentence immediately above is superseded on this point.* Theorem 2.7 has been in the
Cubical lane since the digit chart was first built, under the corpus's own name rather
than the note's: `formal/cubical/NaturalMachine/Digits.agda` defines the base-$b$ chart
for `b = 2 + k` (so $b\ge2$ holds by construction, not by hypothesis) and proves
`ℕ≃CanWord : ℕ ≃ CanWord` (line 309), with `value` the positional sum $\sum c_ib^i$,
`value-digits` the surjectivity round trip, and `value-inj`/`digits-value` the
uniqueness round trip; `ℕ≡CanWord = ua ℕ≃CanWord` is the path. One reindexing separates
it from the statement in §2.4: the note's domain is $A_b^{(\mathbb{N})}$, finitely
supported digit *sequences*, while `CanWord` is the *canonical word* normal form (a
list whose last digit is positive) — the standard normal form of a finitely supported
sequence, and `isPropCanonical` makes the canonicity datum a proposition, so the two
domains agree. Downstream, `Transport.agda` and `TransportMul.agda` already transport
$+$ and $\times$ across this equivalence and land the odometer `sucC` as the transported
successor. Nothing about Theorem 2.7 was re-proved for this note; it should be cited,
not re-formalized.

*Proposition 2.11, status (2026-08-14): **Corollary 2.11.1 RESOLVED
constructively; the classical Mathlib $H^2$ carrier is now CHECKED; identification
of the explicit carry cocycle remains OPEN.*** Checked in
`formal/cubical/NaturalMachine/CarryObstruction.agda` (Agda 2.6.3 + cubical v0.5,
`--safe`, no postulates, no holes, exit 0 standalone; not yet imported by the root
aggregate `NaturalMachine.agda`, which was separately re-verified exit 0 unchanged
today). The module proves the *consequence with the content* — "no choice of digit set
eliminates carrying" — by the exponent argument the proof of Proposition 2.11 gives,
and it needs no cohomology machinery, which is why it was reachable at all: cubical v0.5
has `Cubical.Algebra.Group` and `Cubical.Cohomology.EilenbergMacLane`, but the latter is
cohomology of *spaces*; group cohomology of $\mathbb{Z}/m$ with a cocycle model is
absent there, in agda-unimath's `group-theory/`, and in 1lab's `Algebra/Group/`.
(mathlib4 has the general vocabulary — `GroupTheory/GroupExtension/` with `Section` and
`Splitting`, plus `GroupTheory/Exponent` — classically; no surveyed constructive library
has the specific nonsplitting.)

Three separated layers, so the group theory does not smuggle in arithmetic and vice
versa. **(1)** `Splitting.kills`: if $\pi:G\to Q$ is a homomorphism of an *abelian* $G$,
$s$ a homomorphic section, and one $m:\mathbb{N}$ annihilates both $Q$ and $\ker\pi$,
then $m$ annihilates $G$ — *splitting cannot raise the exponent*. This is the note's
$\operatorname{lcm}(b^n,b)=b^n$ step, stated with no cyclic group in sight.
**(2)** `Carry.carry-free→pres`: for a bare set-theoretic section, the coboundary
$c(u,v)=s(u)s(v)s(uv)^{-1}$ vanishes identically iff $s$ is a homomorphism — this is
what makes "carry-free" and "split" the same statement, i.e. it is Corollary 2.11.1's
"would be precisely a group-theoretic splitting", proved rather than asserted. That the
object is the one the note names is recorded by `carry-inKer` (it is a 2-cochain valued
in $\ker\pi$), `carry-normR`/`carry-normL` (normalized, for a normalized section) and
`carry-cocycle` (the 2-cocycle identity $c(u,v)+c(u+v,w)=c(v,w)+c(u,v+w)$, for abelian
$G$). **(3)** `Cyclic`: for the reduction $\mathbb{Z}/(N\!\cdot\!e)\to\mathbb{Z}/N$ with
$e\mid N$ and $e\ge2$ — built on the library's `ℤGroup/_`, `Fin`, `_+ₘ_` and
`Cubical.Data.Nat.Mod` — all three hypotheses of (1) hold with $m=N$ (`selfkill`,
`kill-ker`), while $N\cdot1\neq0$ (`pow-one`, `N<M`), so `no-hom-section` and hence
`no-carry-free`. `BasePower k n'` specializes to $b=2+k$, $n=1+n'$, giving
`carry-unremovable` and `extension-does-not-split`: **for every $b\ge2$, every $n\ge1$
and every section whatever of $\mathbb{Z}/b^{n+1}\to\mathbb{Z}/b^n$, it is false that
all carries vanish.** The hypothesis $n\ge1$ is not decorative and is visible in the
proof: it is exactly what makes $e=b$ divide $N=b^n$, i.e. what lets the single exponent
$b^n$ annihilate the kernel as well as the quotient. Non-vacuity is recorded, not
assumed: `stdSection` is the schoolbook least-representative digit set, `stdSection-sect`
proves it is a section, and `std-carries` is the instance for it.

Two honest boundaries. (i) **Cubical Agda still does not construct $H^2$.** The note's
Proposition 2.11 says $[c_n]\ne0$ in
$H^2(\mathbb{Z}/b^n;\mathbb{Z}/b)\cong\mathbb{Z}/b$; the Cubical module proves only
that $c_n$ is a normalized 2-cocycle valued in the kernel and that it cannot be made to
vanish, which is $[c_n]\ne0$ *stated without the group it lives in*. Building $H^2$ of
a cyclic group constructively, and identifying it with $A/mA$, remains open.

There is now a separate **classical/noncomputable Lean closure of the carrier** in
`formal/pairfield/Pairfield/CarryCohomologyAdapter.lean`, imported by the Pairfield
root.  It specializes Mathlib's finite-cyclic periodic resolution to
$G=\operatorname{Multiplicative}(\mathbb{Z}/N)$ acting trivially on
$A=\mathbb{Z}/b$.  The checked theorem `norm_eq_zero` proves that $b\mid N$ makes the
cyclic norm identically zero, and `degreeTwoClass_ne_zero` uses
`Rep.FiniteCyclicGroup.groupCohomologyπEven_eq_zero_iff` to prove that the positive-even
class represented by the invariant $1$ is nonzero for $2\le b$.  The focused
2,392-job build and the 8,771-job Pairfield root build pass, with no `sorry`, `admit`,
or declared axiom in the adapter.

**Native-lineage return: ACCEPT-NARROW.** This closes the classical Mathlib $H^2$
carrier/nontriviality, not Proposition 2.11's displayed identification of the
*specific* digit-section cocycle.  That distinction is essential for composite $b$:
a nonzero element of $\mathbb{Z}/b$ need not be the generator $1$.  The exact remaining
comparison square is now named:

1. construct $\kappa:\ker(\mathbb{Z}/(Nb)\to\mathbb{Z}/N)\simeq\mathbb{Z}/b$ with
   $\kappa(Na)=a$, and check the induced action is trivial;
2. transport `CarryObstruction.carryOf` through $\kappa$ to a Mathlib
   `groupCohomology.cocycles₂` term `digitCarryCocycle`;
3. prove, up to the conventionally determined sign,
   `groupCohomology.H2π (coefficients N b) digitCarryCocycle = degreeTwoClass N b`.

At chain level the missing bar-to-periodic comparison sends a normalized cocycle $c$
to $\sum_{i=0}^{N-1}c(g^i,g)$; for the schoolbook carry exactly the final summand is
$1$.  Mathlib exposes both endpoint maps (`H2π` and `groupCohomologyπEven`) but the
adapter does not yet relate them.  Packaging the full displayed isomorphism
$H^2\cong\mathbb{Z}/b$, rather than only a nonzero class, is a second small classical
debt.  The residual table's $H^2$ wording is therefore supported by two checked
endpoints, while the cross-resolution and cross-prover identification remains explicit
debt.
(ii) **The moduli are $b^n$ up to a checked path, not on the nose.** Agda must see the
modulus as a literal successor for `ℤGroup/_` to be the $\mathbb{Z}/m$ branch rather
than $\mathbb{Z}$, and `b ^ n` does not reduce to `suc _` for variable `n`; so `BasePower`
uses `bpow j = suc (bp j)` and exports `bpow≡ : bpow j ≡ b ^ j`, `N≡ : N ≡ b ^ n`,
`M≡b : M ≡ b ^ (suc n)`. The identification is a checked term, and four definitional
sanity checks pin the arithmetic ($b=2,n=1$: $\mathbb{Z}/4\to\mathbb{Z}/2$; $b=3,n=2$:
$\mathbb{Z}/27\to\mathbb{Z}/9$). Also not claimed: the closed form
$c_n(u,v)=b^n\lfloor(\tilde u+\tilde v)/b^n\rfloor$, and any *exhibited* carrying pair —
the theorem is $\neg\forall$, which constructively does not hand back the witnessing
$(u,v)$.

With this, §7's list is discharged in full except for the comparison identifying the
explicit carry cocycle with Mathlib's periodic class, and for a constructive Cubical
$H^2$ object: Theorem 2.1 and Theorem 3.2 (`AtlasResiduals`, `LinearOrderFinite`),
Theorem 3.1's loop half (`PathIsSymmetry`/`Decategorification`), Theorem 2.7 (`Digits`),
Corollary 2.11.1 (`CarryObstruction`), and the classical nonzero degree-two carrier
(`CarryCohomologyAdapter`). Theorem 4.2(2)(iii)'s "nonredundant, and irreducibly so" is
machine-visible: the third parameter of $\mathrm{Dig}(b,\varepsilon,s)$ cannot be chosen
away.

---

## 8. The residual table

| Transition | Residual | Named as | Homotopy reading | Where proved |
|---|---|---|---|---|
| (a) $\leftrightarrow$ (b) | **nothing** | trivial group | comparison type is **contractible** | Thm 2.1, §2.1 |
| (c) $\to$ (a),(b) | **$S_n$** | $\operatorname{Aut}$ of a finite set | $\pi_1(BS_n)$; truncation collapses it | Thms 2.2, 2.3, 3.1 |
| (d) $\to$ (c) | **linear order** | $S_n$-torsor of orders | $ES_n\to BS_n$; total space contractible | Thm 2.5, Thm 3.2 |
| (d) $\to$ (a) | inert on $\mathbb{N}$ | order-concatenation datum | visible only past $\omega$ | Thm 2.6 |
| (a) $\to$ (e), base | **$\operatorname{rad}(b)$** | choice of finite quotient | index set = finite sets of primes | Prop. 2.8 |
| (a) $\to$ (e), endian | **$\mathbb{Z}/2$** | torsor of truncation systems | trivialized in coordinates, not in structure | Prop. 2.10 (`DIGIT_CRYSTAL`) |
| (a) $\to$ (e), carry | **$[c_n]\ne0$** | class in $H^2(\mathbb{Z}/b^n;\mathbb{Z}/b)$ | nonsplit extension; unremovable | Prop. 2.11 |
| (e) $\leftrightarrow$ (f) | shared locus $\{p\mid b\}$ | — | — | Prop. 2.9 |
| (a) $\to$ (f) | **addition** | $\operatorname{Sym}(P)$, size $2^{\aleph_0}$, vs. $\{\mathrm{id}\}$ | no free categorification (Thm 6.1) | Thm 2.13, Thm 6.1 |
| $\mathbb{N}\to$ any completion | **induction** | initiality | dies everywhere, first at $\mathbb{Z}$ | Thm 5.1 |

---

## 9. Attribution: classical, fetched, assembled

Labels per `collab/messages/0073-weaver-prasanga-norms.md` §1 (pramāṇa discipline):
**FETCHED** = source retrieved in this session; **UNVERIFIED-MEMORY** = recalled, not
retrieved, not to be relied on; **HERE** = written in this note; **CLASSICAL** = known
mathematics regardless of which source is cited.

| Statement | Grade |
|---|---|
| Natural numbers object; initial algebra of $1+X$; induction $=$ initiality | **CLASSICAL**, Lawvere. **FETCHED**: nLab *natural numbers object* — "ℕ is the initial algebra for the endofunctor X ↦ 1 + X", crediting Lawvere (1963); and Lawvere, *An Elementary Theory of the Category of Sets*, PNAS 52 (1964) 1506–1511, in which the existence of an NNO is an axiom (retrieved as search result + PNAS listing; the PNAS article text itself was **not read** — śabda, weakest pramāṇa). Props. 1.1, 1.2 proved **HERE** for self-containment. |
| $(\mathbb{N},+,0)$ free monoid on one generator; equivalence with the NNO | **CLASSICAL / folklore.** Theorem 2.1 proved **HERE** from scratch, because the *contractibility* of the comparison (not mere existence) is the load-bearing part of §2.1 and §4. |
| Categorification; $\mathbb{F}$ as the categorified $\mathbb{N}$; decategorification loses $S_n$ | **CLASSICAL.** **FETCHED**: Baez–Dolan, *From Finite Sets to Feynman Diagrams*, arXiv:math/0004133, in *Mathematics Unlimited — 2001 and Beyond*, Springer 2001, pp. 29–50; abstract confirms "Categorification is the process of replacing equations by isomorphisms" and that finite sets with $\sqcup,\times$ categorify $\mathbb{N}$ with $+,\times$. Thms 2.2, 2.3 proved **HERE**. |
| $\operatorname{core}(\mathbf{FinSet})$ = free symmetric monoidal category on one object; components are $BS_n$ | **CLASSICAL.** **FETCHED**: nLab *FinSet* — "As a groupoid itself, the core of FinSet is (with the operation of disjoint union) the free symmetric monoidal category on one object"; nLab *permutation groupoid* — the permutation groupoid is the free strict symmetric monoidal category on one object, its connected components are the deloopings of the symmetric groups. |
| $BS_n$ = the type of $n$-element types; $\Omega BS_n \simeq S_n$ by univalence | **CLASSICAL** in univalent mathematics. **FETCHED**: Mangel–Rijke, *Delooping the sign homomorphism in univalent mathematics*, arXiv:2301.10011, abstract (quoted in §3.1). Rijke, *Introduction to Homotopy Type Theory*, CUP (Cambridge Studies in Advanced Math. 219), chapter on finite types — **FETCHED as bibliographic record only, book not read**. Thms 3.1, 3.2 proved **HERE**; Thm 3.2's two-line proof is elementary and surely folklore. |
| Ordinal vs. cardinal arithmetic; agreement below $\omega$; $1+\omega\ne\omega+1$ | **CLASSICAL** (any set theory text; **UNVERIFIED-MEMORY** for a specific citation). Thm 2.6 proved **HERE**. |
| Existence and uniqueness of base-$b$ representation | **CLASSICAL / folklore.** Thm 2.7 proved **HERE**. |
| Carrying as a $2$-cocycle of a nonsplit extension | **CLASSICAL.** **FETCHED (bibliographic record + abstract-level description only; the article was not read)**: D. C. Isaksen, *A cohomological viewpoint on elementary school arithmetic*, Amer. Math. Monthly **109** (2002), no. 9, 796–805; also nLab *carrying*. Prop. 2.11 is proved **HERE** so nothing rests on the citation. |
| Endian class; reversal does not descend to $\mathbb{Z}_b$; $J\circ R_\infty=L$; $\ker=\langle D\rangle$ | **Quoted, not re-derived**, from `DIGIT_CRYSTAL.md` Lemma 4.1, Thms 4.2–4.4, Cor. 4.5 (that note grades them itself). Prop. 2.10's packaging as a $\mathbb{Z}/2$-torsor of truncation systems is **HERE**. |
| Fundamental theorem of arithmetic; free commutative monoid on $P$ | **CLASSICAL** (Euclid, Gauss). Thm 2.12 sketched **HERE** only to display the dependency on induction. |
| $\operatorname{Aut}(\mathbb{N}_{>0},\times)\cong\operatorname{Sym}(P)$ | **CLASSICAL / elementary folklore** (**UNVERIFIED-MEMORY** for a citation). Thm 2.13 proved **HERE**; the *contrast* with $\operatorname{Aut}(\mathbb{N},+,\times)=1$, and the count $2^{\aleph_0}$ of compatible additions, is the packaging this note contributes. |
| Grothendieck group completion; field of fractions | **CLASSICAL**, **UNVERIFIED-MEMORY** for a citation; both are standard universal-algebra constructions. |
| Ostrowski's theorem | **CLASSICAL.** **FETCHED**: Wikipedia *Ostrowski's theorem* + K. Conrad's and Stanford course notes appearing in the same search — every nontrivial absolute value on $\mathbb{Q}$ is equivalent to $|\cdot|_\infty$ or a $p$-adic one (Ostrowski 1916). |
| $\hat{\mathbb{Z}} \cong \prod_p\mathbb{Z}_p$; universal property of profinite completion | **CLASSICAL.** **FETCHED**: nLab *profinite completion of the integers* and *profinite group*; Ribes–Zalesskii, *Profinite Groups* (Springer) as the standard reference — **bibliographic record only, book not read**. |
| Odometers are exactly the equicontinuous Cantor minimal systems; $(\hat{\mathbb{Z}},T)$ universal | **CLASSICAL** in topological dynamics. **FETCHED at search-summary level only** (2026-08-12; no primary source read). Graded **śabda / weakest**; nothing in this note depends on it — Prop. 5.4 is proved from cofinality alone. |
| Voevodsky's motivation | **FETCHED**: Quanta Magazine, *Will Computers Redefine the Roots of Math?* (2015), quoted in §7. The IAS essay itself returned HTTP 403 and was **not** read. |
| Two-completions phenomenon in $S^1(\mathbb{Q})$ | Recorded in `RATIONAL_CIRCLE_ATLAS.md` §5.3; cited, not reproved. |

**Assembled here, and claimed as such:**

1. The **atlas as a whole**: seven presentations of $\mathbb{N}$ with every adjacent
   transition map proved and every residual named (§1, §2, §8).
2. The **residual table** of §8 with its homotopy column, and in particular the
   identification of Residual 2.2 with $\pi_1(BS_n)$ and Residual 2.3 with the universal
   cover $ES_n\to BS_n$ (Theorem 3.2). Both are one-line consequences of standard
   univalent facts; the claim is the *organization*, not the mathematics.
3. The **dependency theorem** (Theorem 4.2) in its exact form — three parameters, each
   proved nonredundant by a separate mechanism (radical invariance, torsor
   nontrivialization of structure, nonvanishing $H^2$).
4. **Theorem 6.1**, the exact non-fullness of the factorization functor with index
   $n!/\prod_p (p!)^{a_p}a_p!$, and the resulting statement that unique factorization
   categorifies only at the irreducibles. Elementary; likely folklore in the
   categorification community; **no literature search for prior art on it was performed**
   (see §10).
5. The naming of the **two-completions phenomenon** across four instances.

That list is the whole claim. Everything else is classical mathematics restated so that
the atlas is executable and auditable.

---

## 10. Designed annihilation, and what was NOT established

Per `collab/messages/0073-weaver-prasanga-norms.md` §2: a claim ships with its own
annihilation apparatus or it is not a claim. This note runs no experiments, so the
apparatus is stated as falsification conditions — each is a mathematical statement whose
proof would kill the corresponding claim.

| # | Claim | Falsified by |
|---|---|---|
| A1 | Residual (a)$\leftrightarrow$(b) is trivial | exhibiting a nonidentity element of $\operatorname{Aut}(\mathbb{N},0,s)$ or of $\operatorname{Aut}(\mathbb{N},+,0)$; or two initial $(1+X)$-algebras with a non-unique comparison |
| A2 | Decategorification residual is exactly $S_n$ | a finite set with $\operatorname{Aut}\ne S_{|X|}$; or a component of $\mathbb{F}$ that is not connected; or a proof that $\lVert\mathbf{FinType}\rVert_0\not\simeq\mathbb{N}$ |
| A3 | $\sum_{X:BS_n}\mathrm{LinOrd}(X)$ is contractible (Thm 3.2) | any $n$ and two linear orders on an $n$-element type not connected by a path in the total type; equivalently a failure of $\sum_X(X\simeq A)$ to be contractible, i.e. a failure of univalence |
| A4 | Ordinal and cardinal arithmetic agree below $\omega$ and diverge at $\omega$ | finite $m,n$ with ordinal $m+n\ne$ cardinal $m+n$ (kills the agreement); or a proof that $1+\omega=\omega+1$ (kills the divergence) |
| A5 | Carrying is unremovable (Prop. 2.11, Cor. 2.11.1) | a digit set $A'\subset\mathbb{Z}$ of size $b$ for which base-$b$ addition on $\mathbb{Z}/b^{n+1}$ is digitwise — equivalently a splitting $\mathbb{Z}/b^{n+1}\cong\mathbb{Z}/b^n\oplus\mathbb{Z}/b$ |
| A6 | $\operatorname{rad}(b)$ is a chart invariant (Prop. 2.8) | a continuous map $\mathbb{Z}_2\to\mathbb{Z}_{10}$ restricting to the identity on $\mathbb{N}$ |
| A7 | Addition is the residual of chart (f) (Thm 2.13) | a nonidentity $\sigma\in\operatorname{Sym}(P)$ with $+_\sigma=+$; or a nonidentity semiring automorphism of $\mathbb{N}$ |
| A8 | The dependency theorem's three parameters are each nonredundant (Thm 4.2) | a definition of base-$b$ notation that fixes $b$ without choosing it, or that is endian-neutral while carrying $+$, or that is carry-free |
| A9 | Unique factorization does not categorify (Thm 6.1) | a composite $n$ for which $\prod_p(S_p\wr S_{a_p})=S_n$; e.g. any proof that the product-structure stabilizer is all of $S_4$ |
| A10 | No crystal (§6) | a canonical involutive inverse to $\pi_0$ on symmetric monoidal groupoids — i.e. a functorial categorification — which would rebuild the square |

A verifier that rejects everything is worthless, so the positive control is explicit:
**A5 and A9 are both "proper subgroup / nonsplit extension" claims, and the same argument
that kills a carry-free digit set (A5) *accepts* fullness at $n$ prime in A9.** The
machinery discriminates.

### What this note did NOT establish

1. **No numerics, no formalization.** Nothing here is machine-checked. §7 lists the
   targets; that is a stated debt, not a result. In particular the univalent statements of
   §3 are written in informal HoTT and have not been type-checked.
2. **No literature search on the assembled items.** Specifically, no search was performed
   for prior art on Theorem 6.1 (the index $n!/\prod_p(p!)^{a_p}a_p!$), on the exact
   parameter count of Theorem 4.2, or on the "two-completions" framing. All are elementary
   enough that prior appearances are likely. **Absence of a located source is not evidence
   of novelty**, and this note does not treat it as such.

   > **PRIOR-ART SWEEP 2026-08-14 — searched; search-summary (śabda) grade, `WebFetch`
   > EGRESS_BLOCKED so no source text was read.** **Theorem 6.1's index: RESOLVED-FOUND,
   > and it is textbook.** The number $n!/\prod_p(p!)^{a_p}a_p!$ is the classical count of
   > the set partitions of an $n$-set having exactly $a_p$ blocks of size $p$ for each $p$
   > — the denominator being $|\prod_p(S_p\wr S_{a_p})|$, so the index is a Young-type
   > coset count, standard enumerative combinatorics (Stanley, *EC1* §1.3; it appears in
   > this exact displayed form in ordinary multinomial-coefficient lecture notes). §9
   > item 4's own reading — "elementary; likely folklore in the categorification
   > community" — is right about the number and understates how standard it is: **the
   > arithmetic of Theorem 6.1 is known mathematics; only the reading of it as
   > non-fullness of a factorization functor is the note's packaging.** That reading sits
   > inside an existing programme: Baez–Dolan, *From Finite Sets to Feynman Diagrams*,
   > arXiv:math/0004133, is the standard reference for $\mathbf{FinSet}$ with
   > $\sqcup,\times$ as the categorification of $(\mathbb N,+,\cdot)$, and the failure of
   > arithmetic identities to lift is a recognised genre there. **Theorem 4.2's parameter
   > count and the "two-completions" framing: RESOLVED-NO-MATCH** — queries: *index of
   > wreath product stabilizer of prime factorization n!/prod (p!)^{a_p} a_p! symmetric
   > group unique factorization does not categorify*; *number of set partitions into a_p
   > blocks of size p classical multinomial*; *categorification of natural numbers finite
   > sets groupoid unique factorization fails multiplication not full functor Baez Dolan*.
   > Absence of a located source is still not evidence of novelty. Attribution status
   > only; no theorem here is weakened, strengthened, or restated.
3. **No claim about any open problem.** Corollary 2.13.1 and §6 say only what charts can
   express. Nothing here bears on Goldbach, twin primes, $abc$, RH, or the repo's
   prime-pair field, and no result of that programme is used.
4. **No empirical claim about learning.** Corollary 4.3 is about dependency order. This
   note contains no data, no learner, no curriculum trial, and cannot be cited as
   evidence about education.
5. **Chart (g) is not developed.** Stern–Brocot appears only as a pointer to
   `RATIONAL_CIRCLE_ATLAS.md`; no transition map from (g) to (a)–(f) is proved here.
6. **Chart (e) is developed only for integer $b\ge2$.** Nothing is proved for negative
   bases, non-integer bases, signed digit sets, mixed radix, or non-free numeration
   systems (Zeckendorf), where `DIGIT_CRYSTAL.md` Lemma 0.1 already fails — that note's
   §8.5 says so and the limitation is inherited.
7. **The ambient category is $\mathbf{Set}$.** Statements (a)–(d) are proved over
   $\mathbf{Set}$; the topos-internal versions are standard but are not written out, and
   §2.1 flags the one place where the ambient matters.
8. **"Every residual is homotopy" is proved for (c) and (d) and is false as stated for
   (e).** §3.4 says so explicitly. The endian $\mathbb{Z}/2$ is a torsor of chart frames,
   not a homotopy group of $\mathbb{N}$; anyone quoting the slogan without that caveat is
   overstating this note.
9. **The odometer citation is the weakest link.** The dynamical characterization of
   odometers is graded śabda at search-summary level. Proposition 5.4 does not use it.
10. **No claim that these seven charts are exhaustive.** They are seven charts that admit
    proved transition maps. Others exist (Church numerals, Conway games, the Grothendieck
    ring of finite sets, surreal $\omega$, Zeckendorf) and are not treated.

---

**Status: PENDING HOSTILE AUDIT.**
