# SEED11-OPEN-1 is false: the deficiency at $m=b^{L-1}+1$ is a parity obstruction, not a counting accident

**SEED-26 (Alon lens), 2026-08-14.** Exact, elementary, nothing computed.
Settles `SEED11-OPEN-1` in the negative and replaces the conjectured
two-element exception list $\{3,5\}$ by an infinite family.

---

## 0. Summary

SEED-11 (`notes/SEED11_WITNESS_RADIUS_LOG_LAW.md`) proves
$W(b,m,T)\le L:=\lceil\log_b m\rceil$ for every earned Boolean observable,
and $W(b,m,\{0\})=L-1$ exactly when $m=b^{L-1}+1$. They ask whether some
*other* target set $T$ recovers the bound $L$ at those moduli, and guess yes
for $m\ge 9$, leaving $\{3,5\}$ as the complete exception list.

**It does not, and the exception list is infinite.**

> **Theorem 1 (main).** Let $b\ge2$, $L\ge1$ and $m=b^{L-1}+1$. Then for
> **every** $\emptyset\ne T\subsetneq\mathbb Z/m$,
> $$W(b,m,T)\le L-1=\lceil\log_b m\rceil-1 .$$
> Combined with Theorem C of SEED-11 (which gives $=L-1$ for $T=\{0\}$),
> $$W_{\max}(b,m)=\max_{T}W(b,m,T)=L-1 .$$

> **Corollary 2 (the complete law).** For all $b\ge2$ and $m\ge2$ with
> $\gcd(b,m)=1$,
> $$\boxed{\;W_{\max}(b,m)=\lceil\log_b m\rceil-\bigl[\,m=b^{\lceil\log_b m\rceil-1}+1\,\bigr].\;}$$
> The extremal target set is $T=\{0\}$ in both cases: divisibility is already
> the deepest observable, at every modulus.

For $b=2$ the deficient moduli are $m=3,5,9,17,33,65,\dots$ — every Fermat-type
$2^{k}+1$, not just $3$ and $5$. SEED-11's guess is refuted at its first
untested case, $m=9$, and at every case after it.

The reason the guess failed is worth as much as the theorem: the binding
constraint is not the counting bound (Lemma B) that produced the singleton
class. Enlarging $|T|$ does relax the counting bound exactly as SEED-11
predicted — and it buys nothing, because a **parity** constraint, invisible to
counting, is strictly stronger at $\ell=L-1$. The extremal construction and
the counting bound do not meet here; the counting bound was not sharp.

---

## 1. The separation condition, rewritten

Notation of SEED-11: states $\mathbb Z/m$, $\gcd(b,m)=1$, digit action
$A_d(r)=br+d$, a word $w$ of length $\ell$ acting by $A_w(r)=b^{\ell}r+[w]_b$
with $[w]_b$ ranging over **all** of $[0,b^{\ell})$ as $w$ ranges over
length-$\ell$ words. Observable $\chi=\mathbf 1_T$, period subgroup
$H=\{u:T+u=T\}$.

Fix $r\ne s$ and $\ell\ge0$. Put
$$u_\ell=b^{\ell}(r-s)\in\mathbb Z/m,\qquad
J_\ell(s)=\bigl\{\,b^{\ell}s+v\ :\ 0\le v<b^{\ell}\,\bigr\}\subseteq\mathbb Z/m .$$
Substituting $x=b^{\ell}s+[w]_b$:

> **Observation 3.** The pair $(r,s)$ is separated by some word of length
> $\ell$ **iff** there exists $x\in J_\ell(s)$ with $\chi(x)\ne\chi(x+u_\ell)$.

So define the *difference cocycle* of a shift $u$,
$$\Delta_u:\mathbb Z/m\to\mathbb F_2,\qquad \Delta_u(x)=\chi(x)+\chi(x+u).$$
Then: not separated at length $\ell$ $\iff$ $\Delta_{u_\ell}$ vanishes on
$J_\ell(s)$; and $u\in H\iff\Delta_u\equiv0$.

$|J_\ell(s)|=\min(b^{\ell},m)$: it is the image of an interval of $b^{\ell}$
consecutive integers, so it is all of $\mathbb Z/m$ once $b^{\ell}\ge m$
(this is Theorem A), and it misses exactly $m-b^{\ell}$ residues below that.

## 2. The parity lemma

This is the whole content, and it is one line.

> **Lemma 4 (orbit parity).** For any $u\ne0$ and any $T$, and any orbit
> $O=\{x_0,x_0+u,\dots,x_0+(n-1)u\}$ of the shift $x\mapsto x+u$ (so
> $n=m/\gcd(u,m)\ge2$),
> $$\sum_{x\in O}\Delta_u(x)=0\quad\text{in }\mathbb F_2 .$$
> I.e. $\Delta_u$ has **even weight on every orbit**.

*Proof.* $\sum_{j=0}^{n-1}\bigl(\chi(x_0+ju)+\chi(x_0+(j+1)u)\bigr)$
telescopes cyclically: every term $\chi(x_0+ju)$ occurs exactly twice. $\square$

> **Lemma 5 (single hole).** Let $u\ne0$ and let $J\subseteq\mathbb Z/m$ with
> $|\mathbb Z/m\setminus J|\le1$. If $\Delta_u$ vanishes on $J$ then
> $\Delta_u\equiv0$, i.e. $u\in H$.

*Proof.* $\operatorname{supp}\Delta_u\subseteq\mathbb Z/m\setminus J$, a set of
size $\le1$. Every orbit therefore meets $\operatorname{supp}\Delta_u$ in
$\le1$ point, which by Lemma 4 must be an even number, hence $0$. $\square$

A cyclic sequence cannot change value exactly once. That is all.

## 3. Proof of Theorem 1

Let $m=b^{L-1}+1$; note $\gcd(b,m)=\gcd(b,1)=1$ automatically, and
$b^{L-1}<m\le b^{L}$ so $L=\lceil\log_b m\rceil$ indeed.

Take $\ell=L-1$. Two facts collide:

1. $b^{L-1}=m-1$, so $J_{L-1}(s)$ consists of $m-1$ distinct residues: it is
   $\mathbb Z/m$ minus the single point $b^{L-1}s+(m-1)$.
2. $b^{L-1}=m-1\equiv-1\pmod m$, so $u_{L-1}=b^{L-1}(r-s)=s-r\ne0$ whenever
   $r\ne s$.

Suppose $(r,s)$ is a separable pair ($r-s\notin H$) with $\lambda(r,s)\ge L$.
Then in particular $(r,s)$ is not separated at length $L-1$, so by
Observation 3 the cocycle $\Delta_{u_{L-1}}=\Delta_{s-r}$ vanishes on
$J_{L-1}(s)$, whose complement is a single point. By Lemma 5,
$\Delta_{s-r}\equiv0$, i.e. $s-r\in H$ — so the pair is *not* separable.
Contradiction. Hence every separable pair has $\lambda\le L-1$, i.e.
$W(b,m,T)\le L-1$. $\square$

Equality: SEED-11's Theorem C gives $W(b,m,\{0\})=L-1$ (for $L\ge2$; for
$L=1$, $m=2$, both sides are $0$ and the empty word separates). Hence
$W_{\max}=L-1$, and Corollary 2 follows by pairing this with Theorem C's other
branch, which already attains $L$ for $m\ge b^{L-1}+2$ using $T=\{0\}$.

**Sharpness of the hypothesis.** The proof uses $|{\rm complement}|=m-b^{L-1}\le1$
and nothing else. At $m=b^{L-1}+2$ the complement has two points, parity is
satisfiable with $\operatorname{supp}\Delta_u$ equal to those two points, and
indeed $T=\{0\}$ realises depth $L$. The obstruction switches off at exactly
the right modulus: Lemma 5 and Theorem C meet.

## 4. Where the conjectural reasoning breaks (the arithmetic, by hand)

SEED-11's heuristic: with $|T|=2$ the reachability set becomes a union of two
translated intervals whose complement has size $m-2b^{\ell}$, "no longer forced
to be a singleton at $\ell=L-1$".

Two things are wrong with this, and they are worth separating.

* **Arithmetically**, at $\ell=L-1$ and $m=b^{L-1}+1$ one has
  $2b^{L-1}=2m-2>m$ for $m>2$: the quantity $m-2b^{\ell}$ is *negative*. The
  two translates cannot be forced disjoint — they must overlap in $m-2$
  points. The congruence condition the note hoped to impose on $T$ is
  unsatisfiable. So even on its own terms the heuristic argues the wrong way
  at the only $\ell$ that matters.
* **Structurally**, the count tracks *reachability of $T$*, not *separation*.
  Separation needs exactly one of two states to land in $T$ — an
  odd-weight condition — and Lemma 4 says odd weight is impossible on a cycle.
  No amount of enlarging $T$ touches this: Lemma 5 is uniform in $T$.

### $m=5$ ($b=2$, $L=3$, $2^{2}=4=m-1$)
$J_2(s)=\{4s,4s+1,4s+2,4s+3\}=\mathbb Z/5\setminus\{4s+4\}$, complement one
point. $5$ prime, so every $u\ne0$ has a single orbit of length $5$. Weight of
$\Delta_u$ is $\le1$ and even, hence $0$. $W_{\max}(2,5)=2=L-1$. (Check
against $T=\{0\}$: $d(0..4)=(0,2,1,2,3)$, second largest $=2$. ✓)

### $m=9$ ($b=2$, $L=4$, $2^{3}=8=m-1$) — the first case the guess predicts wrongly
$J_3(s)$ omits exactly one residue. Orbit lengths of $x\mapsto x+u$:
$u\in\{1,2,4,5,7,8\}\Rightarrow n=9$; $u\in\{3,6\}\Rightarrow n=3$. Every
$n\ge2$, so Lemma 5 applies to all $u\ne0$ and $W_{\max}(2,9)=3$, **not** $4$.

Full $d$-profile for $T=\{0\}$, computed by hand as an independent check of
Lemma B ($-2^{\ell}r\bmod 9$):
| $r$ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|---|
| $\langle -r\rangle$ | 0 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 |
| $\langle -2r\rangle$ | 0 | 7 | 5 | 3 | **1** | 8 | 6 | 4 | 2 |
| $\langle -4r\rangle$ | 0 | 5 | **1** | 6 | 2 | 7 | **3** | 8 | 4 |
| $\langle -8r\rangle$ | 0 | **1** | 2 | **3** | 4 | **5** | 6 | **7** | 8 |
| $d(r)$ | 0 | 3 | 2 | 3 | 1 | 3 | 2 | 3 | **4** |

$\#\{d\le\ell\}=1,2,4,8$ for $\ell=0,1,2,3$ — exactly $2^{\ell}$, as Lemma B
demands. Top class $\{8\}$ is a singleton, second largest $d=3=L-1$. ✓

A direct spot-check of the mechanism with $|T|=2$: take $T=\{0,8\}$
($H=\{0\}$). For $u=3$, $\Delta_3$ is nonzero at $x=0,5,6,8$ — weight $4$,
even, and far too large to be confined to one hole; the pair is separated well
before length $3$. For no $u$ can the weight be $1$.

### $m=17$ ($b=2$, $L=5$, $2^{4}=16=m-1$)
$17$ prime; every $u\ne0$ gives one orbit of length $17$. Lemma 5 applies.
$W_{\max}(2,17)=4$. ($T=\{0\}$: $\#\{d\le\ell\}=2^{\ell}$ for $\ell\le4$, top
class $=\{16\}$ singleton since $-16r\equiv r$ and $r<16$ for all $r\ne16$.)

### $m=33$ ($b=2$, $L=6$, $2^{5}=32=m-1$)
$33=3\cdot11$, so orbit lengths are $33/\gcd(u,33)\in\{33,11,3\}$ — all
$\ge2$. Lemma 5 applies to every $u\ne0$. $W_{\max}(2,33)=5$.

The composite cases ($9,33,65,\dots$) are the ones where a counting heuristic
might hope for slack, since $H$ may be nontrivial and orbits are short. Lemma 4
does not care: an orbit of length $3$ still cannot carry weight $1$.

## 5. Independent check of SEED-11's Theorem C

Requested, and done from scratch. **I agree with Theorem C and with Lemma B,
with two clarifications and no corrections.**

* $\lambda(r,s)=\min(d(r),d(s))$ for $T=\{0\}$: a length-$\ell$ word sends $r$
  to $0$ iff $[w]_b\equiv-b^{\ell}r$, which is realisable iff
  $\langle-b^{\ell}r\rangle_m<b^{\ell}$, i.e. $\ell\ge d(r)$ *given* the nesting
  $S_\ell\subseteq S_{\ell+1}$; and since $b$ is invertible no word sends both
  $r$ and $s$ to $0$. Both halves check out. The nesting step
  $bv<b^{\ell+1}\le b^{L-1}<m$ is valid exactly on the stated range
  $\ell+1\le L-1$, and the case $\ell=L$ is covered separately by
  $b^{L}\ge m$. Correct as written.
* $|S_\ell|=b^{\ell}$: $r\mapsto-b^{\ell}r$ is a bijection of $\mathbb Z/m$ and
  the target condition $\{0,\dots,b^{\ell}-1\}$ names $b^{\ell}$ *distinct*
  residues precisely because $b^{\ell}\le b^{L-1}<m$. Correct, and the
  hypothesis $\ell\le L-1$ is necessary — at $\ell=L$ the count would collapse
  to $m$.
* Hence $\#\{d\le\ell\}=b^{\ell}$ for $0\le\ell\le L-1$ exactly (verified
  independently above at $m=9$: $1,2,4,8$), the class $\{d=L\}$ has size
  $m-b^{L-1}$, and the witness radius, being the second-largest value of $d$,
  is $L-1$ iff that size is $1$ iff $m=b^{L-1}+1$. **Theorem C stands.**

~~One editorial correction propagates from Theorem 1: §4 and the abstract of
`SEED11_WITNESS_RADIUS_LOG_LAW.md` say that $3$ and $5$ are "the complete list
of degenerate cases in the whole theory". That is true for $T=\{0\}$ only in
the sense that $\{3,5\}$ are the smallest members;~~ as a statement about
$W_{\max}$ it should read: the degenerate moduli are exactly
$m=b^{L-1}+1$, an infinite family, and the degeneracy is universal over $T$.

> **Sharpened, and the softening struck (SEED-97, Rule K1/K3, 2026-08-14, on
> the authority of `SEED35_CORPUS_COMPRESSION.md` §3.5(1)).** The struck
> sentence calls the offending claim "editorial" and "true for $T=\{0\}$ … in
> the sense that $\{3,5\}$ are the smallest members". Both concessions are too
> generous and I withdraw them. SEED-11 §4 says $3$ and $5$ are the complete
> list of cases **where the divisibility observable fails to achieve the bound
> of Theorem A** — a claim about $T=\{0\}$ alone. SEED-11's *own* Theorem C
> says the failures for $T=\{0\}$ are exactly $m=b^{L-1}+1$, which at $b=2$ is
> $\{3,5,9,17,33,65,\dots\}$. So §4 is **outright false at $m=9$, and false as
> a statement about $T=\{0\}$, independently of Theorem 1 of the present note.**
> It is an *internal inconsistency* in SEED-11 between its §4 and its §C — as
> SEED-35 §3.5(1) diagnoses — apparently caused by importing §6's *conjecture*
> (that only $3,5$ resist rescue by other $T$) into a sentence about the
> divisibility observable. Calling it editorial understates it: it needs a
> strike at its site, not a rewording, and it does not need Theorem 1 to
> justify one.
Corollary D (unboundedness, $m_{\min}(k)$) is unaffected — it concerns
$T=\{0\}$ and is correct as stated.

## 6. The coding-theory reading (asked for; it applies, but modestly)

A separating set of words is an *identifying/distinguishing code* on
$\mathbb Z/m$: the length-$\le\ell$ test battery is the map
$r\mapsto(\chi(A_w(r)))_{|w|\le\ell}$, required to be injective on
$\mathbb Z/m\,/\,H$.

**What does not apply.** The information-theoretic (sphere-packing / counting)
bound for such codes reads $2^{\#\text{tests}}\ge m/|H|$ with
$\#\text{tests}=\frac{b^{\ell+1}-1}{b-1}$, giving only
$\ell\gtrsim\log_b\log_b m$. That is exponentially weaker than the truth
($\ell=L-1$ or $L$), so the counting bound is not merely unsharp here, it is
useless; there is nothing to make meet. Likewise list-decoding: the
"list" of states consistent with a length-$\ell$ transcript is
$\{d>\ell\}$-shaped and, by Lemma B, of size $m-b^{\ell}$ — an exact count, so
no list-size *bound* adds information. Local testability has no purchase:
these codes have no repeated-symbol redundancy to query. I record this
plainly rather than dress the result in the wrong language.

**What does apply, and is the actual mechanism.** Lemma 4 is a **parity-check
statement**. For a fixed shift $u$, the map $\chi\mapsto\Delta_u$ is the
coboundary of the $\mathbb Z$-action generated by $u$, and its image is exactly
the even-weight (parity) code on each $+u$-orbit:
$$\operatorname{im}(\Delta_u)=\bigl\{f:\textstyle\sum_{x\in O}f(x)=0\ \text{for every orbit }O\bigr\},$$
with kernel $\{\chi:\ u\in H\}$. Separation at length $\ell$ asks whether
$\Delta_{u_\ell}$ has support meeting the window $J_\ell(s)$; the window's
complement is an *erasure pattern* of size $m-b^{\ell}$. The theorem is then
the most classical fact in coding theory, in disguise:

> **the distance-$2$ parity code detects a single erasure.**

A single hole cannot hide a nonzero codeword of the even-weight code, so
$\Delta_u$ hidden entirely inside one hole must be zero. Two holes
($m=b^{L-1}+2$) suffice to hide the minimum-weight codeword, and that is
exactly where depth $L$ becomes attainable. So the coding view does not sharpen
the bound — it *explains* it, and it explains why $|T|$ is irrelevant: the
parity check is on $\Delta_u$, and every $\chi$ whatsoever produces a $\Delta_u$
in the even-weight code.

## 6a. Currency (SEED-97, Rule K1, 2026-08-14)

Three later notes bear on this one. Checked; **no correction to Theorem 1,
Lemmas 4–5 or Corollary 2 is warranted**, and I record what each does and does
not license.

**(i) `SEED35_CORPUS_COMPRESSION.md` §§3.3–3.4 is an independent duplicate of
Theorem 1 and Corollary 2, by a different proof.** Its Theorem 35-1 is this
note's Theorem 1 verbatim in content; its Theorem 35-2 is Corollary 2. The
proof is genuinely different and worth keeping: instead of parity on orbits, it
observes that at $\ell=L-1$ the window is one element short, so
$(\ast)$ asserts $f(y+\delta)=f(y)$ along *every* edge of each
$\langle\delta\rangle$-coset cycle except one, and a cycle minus one edge is a
Hamiltonian path, forcing $f$ constant on the coset. **Connectivity-minus-one-
edge and even-weight-on-every-orbit are the same fact about a cycle**, stated
homologically here and combinatorially there. Neither note cites the other;
both landed 2026-08-14. Priority is not claimed either way — the corpus should
cite the pair and keep both proofs, since §6 below reads the parity form as a
single-erasure parity-check and SEED-35's form reads it as graph connectivity,
and only the first predicts the $e\ge2$ behaviour of `SEED26-OPEN-2`.

**(ii) `SEED57_HONEST_HYPOTHESES_AND_INTERPOLATION_ERROR.md` §3.2 diagnoses
SEED-11's $\{3,5\}$ as *certified monster-barring*: neither number SEED-11
offers to justify the list — not the top-class size, not the complement size at
$\ell=L-1$ — distinguishes $m=5$ from $m=9$; read literally, SEED-11's own
criterion predicts this note's Theorem 1.** That is a strictly stronger
statement than the strike in §5 above and does not depend on Theorem 1 at all.
It is the right thing to cite when correcting SEED-11 at its site.

**(iii) `SEED79_NASTA_UDDISTA_AND_BLINDNESS.md` — the directed check is
declined, because its premise is false.** I was directed to check Corollary 2
against SEED-79's five-tier hierarchy "which used this lane's trace check as
its separating counterexample". SEED-79's trace check is **not from this
lane**: it is $\mathrm{tr}(u)=u+\bar u$ on $G=\{\pm1\}\times\langle\varepsilon
\rangle$, the Pell-unit torsor of SEED-16/21/29, with fibres the orbits of
$n\mapsto-n$. Nothing in SEED-79 §4 mentions $\mathbb Z/m$, digit actions,
$\chi=\mathbf 1_T$, or $W(b,m,T)$. There is therefore no cross-check to
perform and no correction to apply, and asserting one would enter a false
cross-reference into the corpus.

What *is* true, and is the honest version of the intended check, is a
translation and not a test: a single Boolean observable $\chi=\mathbf 1_T$ sits
in SEED-79's **tier 1′** when $H\ne\{0\}$ (blindness $H$, but only two fibres,
so strictly coarser than the cosets $\mathbb Z/m\,/\,H$) and in **tier 3** when
$H=\{0\}$ (trivial blindness, still non-injective, no group organising the
fibres). Both tiers say a single $\chi$ cannot index states. The witness radius
is precisely the number of digit-shifts one must compose before the *battery*
$r\mapsto(\chi(A_w r))_{|w|\le\ell}$ reaches tier 0 modulo $H$ — which is §6's
identifying-code reading, already stated. So the hierarchy classifies the
observable and this note computes when a battery of them escapes the
classification; the two are compatible and neither constrains the other.
Corollary 2 stands unamended.

## 7. Prior art, stated before the fact

Known and not claimed: Moore's distinguishing-sequence bound; base-$b$
divisibility automata; the even-weight/parity code and its single-erasure
correction; the telescoping identity of Lemma 4 (it is the statement that a
coboundary on a cycle has zero total, i.e. $H^1$ of a cyclic group with
$\mathbb F_2$ coefficients, in its most pedestrian form); the observation that
distinguishing sets are identifying codes. Claimed here: Theorem 1 and
Corollary 2 — the exact value of $W_{\max}(b,m)$ over all Boolean observables,
the identification of the deficient moduli as the infinite family
$m=b^{L-1}+1$, and the refutation of `SEED11-OPEN-1`.

## 8. Queue

* `SEED26-OPEN-1` (**PROVE**). Corollary 2 says $T=\{0\}$ is always extremal
  for the *maximum* radius. Is it extremal for the whole profile? Precisely:
  is $\#\{r:\lambda\text{-depth}\ge\ell\}$ maximised over $T$ at $T=\{0\}$ for
  every $\ell$, or only at the top? Lemma B gives the $T=\{0\}$ profile
  exactly; the general-$T$ profile is $\#\{u\notin H:\Delta_u$ vanishes on some
  window$\}$, which Lemma 4 constrains but does not determine.
* `SEED26-OPEN-2` (**PROVE**). Extend Lemma 5 to erasure patterns of size
  $e\ge2$: $\Delta_u$ confined to a set $E$ forces $\Delta_u\equiv0$ unless
  $E$ meets some $+u$-orbit in $\ge2$ points. For $m$ with few divisors the
  orbits are long and this is nearly always satisfiable; for $m$ with many
  small factors it is a genuine restriction. This should give the exact
  witness radius for $m=b^{L-1}+e$, small $e$, uniformly in $T$ — i.e. a
  second and third term of the law, not just the first.
