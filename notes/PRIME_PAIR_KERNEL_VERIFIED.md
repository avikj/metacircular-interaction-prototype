# The prime-pair kernel of D0018 §G, verified: one correct identity with a
# missing index set, two extraction claims that are a change of variables, and
# one missing $\Gamma(s)$

*Agent seed155, 2026-08-15. Persona lens: Hardy, crossed with the habit of
checking whether a "new identity" is a change of variables before reading
further. It is.*

**Provenance and credit.** The objects $P$, $Z$, $\mathcal K$ and the four
displayed claims examined here are the human owner's, transmitted as
`collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md` §G, and its
own triage §J6 asks precisely for what is done below: *"the identities as
stated … are elementary rearrangements and should be verified as such rather
than cited as insight."* This note derives from the owner artifact; it does not
rewrite it. Nothing here is a relabelling of existing corpus results into the
transmission's vocabulary (§J8) — where the corpus already owns an object, §6
says so in the corpus's own words and stops.

**Substrate.** Hand derivation only. No script written or run, no numerical
value computed, no constant fitted. Everything asserted below is either proved
here or attributed.

---

## 0. Summary, refutable in one reading

| §G claim | verdict |
|---|---|
| $Z(t,\theta)=\sum_{w,r}\Lambda(w-r)\Lambda(w+r)e^{-2tw}e^{2\mathrm ir\theta}$ | **Correct**, and the summand and both exponents are right — but only on the half-integer lattice $L$ of §1. Read over $\mathbb Z^2$ it is **false**: it loses every pair $m+n$ odd, i.e. every odd shift. No Jacobian, no factor 2, diagonal counted once. |
| $\text{Goldbach}=[w^N]\mathcal K$ | Grading is by $2w$, so the functional is "$w=N/2$", not "$w=N$". Corrected, it is exactly $\psi_2(N)=\sum_{a+b=N}\Lambda(a)\Lambda(b)$. Its positivity is equivalent to *$N$ is a sum of two prime powers*, which is **weaker** than Goldbach; the $\Leftrightarrow$ is not available. |
| $\text{twin primes}=[r^1]\mathcal K$ | The functional is the $\theta$-Fourier coefficient at $r=1$; it returns $\sum_n\Lambda(n)\Lambda(n+2)e^{-2tn}$ up to $e^{-2t}$. **Non-vanishing is not the twin conjecture** — it holds already at $w=4$. Infinitude of nonzero terms is the prime-power twin statement, again weaker. |
| does the reformulation carry information? | **No.** §3: $\{\Lambda(a)\Lambda(b)\}$ and $Z$ determine each other, by Fourier uniqueness and the identity theorem for Laplace series. It is a linear bijection of index sets followed by an invertible transform. Clean negative, as expected. |
| $-\zeta'/\zeta(s)=\mathcal M[P](s)$ | **False as printed.** $\mathcal M[P](s)=\Gamma(s)\bigl(-\zeta'/\zeta(s)\bigr)$. Recorded as correction **C1**; it is not cosmetic (§4). |
| $\mathcal K(w,r)\overset{?}{=}\operatorname{Tr}\mathscr K_{w,r}$, "of what representation is $\mathscr Z$ the character?" | Over $\mathbb Z$: **(c), an analogy with no current mathematical content**, and there is an obstruction at the first step (§5.1). Over $\mathbb F_q[T]$: **(a), a named programme** (§5.2). |

The one non-trivial thing the reformulation *does* make visible is that
$Z=|P|^2\ge0$, hence the shift-indexed family of smoothed autocorrelations is a
positive-definite function of the shift (Prop. 2.3). This is Wiener–Khinchin,
it is standard, and it is already how the circle method sees the object; it is
recorded because it is the only structural content, not because it is new.

---

## 1. The identity, with its index set written out

Throughout $z=t+\mathrm i\theta$ with $t>0$, and
$$P(z):=\sum_{n\ge1}\Lambda(n)e^{-nz}.$$

**Lemma 1.1 (convergence).** For $\operatorname{Re}z=t>0$ the series converges
absolutely, since $0\le\Lambda(n)\le\log n$ and $\sum_n(\log n)e^{-nt}<\infty$.
Hence $P$ is holomorphic on $\{\operatorname{Re}z>0\}$ and any rearrangement or
product expansion below is legitimate. $\square$

**Definition 1.2 (the index set).**
$$L:=\Bigl\{(w,r)\in\tfrac12\mathbb Z\times\tfrac12\mathbb Z\ :\ w-r\in\mathbb Z_{\ge1},\ w+r\in\mathbb Z_{\ge1}\Bigr\}.$$
Equivalently: $2w,2r\in\mathbb Z$, $w-r\in\mathbb Z$ (so $w$ and $r$ are *both*
integers or *both* in $\tfrac12+\mathbb Z$), and $w\ge|r|+1$.

**Proposition 1.3 (exact form of the §G identity).** The map
$$\Phi:\mathbb Z_{\ge1}^2\to L,\qquad \Phi(m,n)=\Bigl(\tfrac{m+n}2,\ \tfrac{n-m}2\Bigr)$$
is a bijection, with inverse $(w,r)\mapsto(m,n)=(w-r,w+r)$. Consequently, for
all $t>0$ and all real $\theta$,
$$Z(t,\theta):=P(t+\mathrm i\theta)P(t-\mathrm i\theta)
=\sum_{(w,r)\in L}\Lambda(w-r)\Lambda(w+r)\,e^{-2tw}e^{2\mathrm ir\theta},$$
the sum being absolutely convergent.

*Proof.* $\Phi$ is injective and lands in $L$ by construction, and $(w,r)\mapsto(w-r,w+r)$
is a two-sided inverse on $L$ by Definition 1.2. Expanding the product (Lemma 1.1
licenses the Cauchy product),
$$P(t+\mathrm i\theta)P(t-\mathrm i\theta)=\sum_{m,n\ge1}\Lambda(m)\Lambda(n)e^{-(m+n)t}e^{-\mathrm i(m-n)\theta},$$
and under $\Phi$: $m+n=2w$, $n-m=2r$, so $e^{-(m+n)t}=e^{-2tw}$ and
$e^{-\mathrm i(m-n)\theta}=e^{2\mathrm ir\theta}$. Re-indexing an absolutely
convergent sum along a bijection changes nothing. $\square$

**Remarks — the four questions the mandate asks, answered explicitly.**

1. **Integers or half-integers?** Both, coupled: $w,r$ range over $L$, and $L$ is
   *not* $\mathbb Z^2$ and *not* $(\tfrac12\mathbb Z)^2$. It is the index-2
   sublattice-plus-coset $\{(w,r):w-r\in\mathbb Z\}$ intersected with $w\pm r\ge1$.
2. **Is $w\pm r\ge1$ required?** Yes, and it is not automatic; it is the image of
   $m,n\ge1$. One may drop it only by adopting $\Lambda(k)=0$ for $k\le0$, which
   is a convention, not a theorem, and must then be stated.
3. **Jacobian or factor of 2?** Neither. $\Phi$ is a bijection of *discrete* sets;
   Jacobians belong to the continuous change of variables, and importing one here
   (the linear map has determinant $\tfrac12$) would be an error. There is no
   double counting to correct: each ordered pair $(m,n)$ has exactly one preimage.
4. **Does the diagonal contribute?** Yes, once. $m=n$ $\iff$ $r=0$, giving
   $\sum_{w\ge1}\Lambda(w)^2e^{-2tw}$, and $\mathcal K(w,0)=\Lambda(w)^2$. It is
   not doubled and not omitted.

**Corollary 1.4 (how the identity fails as printed).** §G writes
"$\sum_{w,r}$" with no index set. If a reader takes $w,r\in\mathbb Z$ — the
default reading, and the one the notation $[w^N]$, $[r^1]$ encourages — the
right-hand side omits exactly the pairs $(m,n)$ with $m+n$ odd, i.e. **all odd
shifts $n-m$**. The omission is non-empty and non-negligible: $m=2,n=3$ gives
$w=\tfrac52$, $r=\tfrac12$ and $\Lambda(2)\Lambda(3)=\log2\log3\ne0$. This is the
single repair the identity needs, and with Definition 1.2 supplied it is
otherwise exactly right, summand, both exponents, and all.

Note also $\mathcal K(w,r)=\mathcal K(w,-r)$, so the $r$-sum is symmetric and
$Z$ is real — as it must be, $Z(t,\theta)=|P(t+\mathrm i\theta)|^2$ for real $t,\theta$.

---

## 2. What the two coefficient functionals actually are

The variable graded by $t$ is $2w$, and the variable graded by $\theta$ is $2r$.
Both extraction claims in §G are stated in $w$ and $r$; the factor $2$ must be
carried, and §G does not carry it.

**Proposition 2.1 ($w$-extraction).** Put $\psi_2(N):=\sum_{a+b=N}\Lambda(a)\Lambda(b)$
($a,b\ge1$). Then $Z(t,0)=P(t)^2=\sum_{N\ge2}\psi_2(N)e^{-Nt}$, and for each
$N\ge2$,
$$\psi_2(N)=\sum_{r\,:\,(N/2,\,r)\in L}\mathcal K\bigl(\tfrac N2,r\bigr).$$
So the functional "$[w^N]\mathcal K$" is: *set $\theta=0$, take the coefficient
of $e^{-Nt}$*, equivalently *fix $w=N/2$ and sum over all admissible $r$*. For
odd $N$ this lives on the half-integer coset — which is why Corollary 1.4
matters here and not only in principle.

*Proof.* Cauchy product of $P(t)$ with itself, absolutely convergent; then
Proposition 1.3 with $\theta=0$ and $2w=N$. $\square$

**Proposition 2.2 ($r$-extraction).** For fixed $t>0$, $\theta\mapsto Z(t,\theta)$
is continuous and $2\pi$-periodic (every exponent $2r$ is an integer). Its
Fourier coefficients are, for each $r\in\tfrac12\mathbb Z$ with $h:=2r\ge0$,
$$c_r(t):=\frac1{2\pi}\int_0^{2\pi}Z(t,\theta)e^{-2\mathrm ir\theta}\,d\theta
=\sum_{w:(w,r)\in L}\mathcal K(w,r)e^{-2tw}
=e^{-th}\sum_{n\ge1}\Lambda(n)\Lambda(n+h)\,e^{-2tn}.$$
In particular $[r^1]\mathcal K$ returns $e^{-2t}\sum_{n\ge1}\Lambda(n)\Lambda(n+2)e^{-2tn}$:
the Laplace-smoothed twin-prime-power correlation.

*Proof.* Termwise integration (absolute convergence) and orthogonality of
$e^{\mathrm ik\theta}$, $k=2r\in\mathbb Z$, on $[0,2\pi)$; then substitute
$w=n+r$, $m=n$ from Proposition 1.3. $\square$

**Proposition 2.3 (the only structural content, and it is standard).**
$Z(t,\cdot)\ge0$, being $|P(t+\mathrm i\theta)|^2$. By Herglotz/Bochner applied
to the Fourier coefficients of a nonnegative continuous periodic function, the
family $h\mapsto \sum_n\Lambda(n)\Lambda(n+h)e^{-2tn}$ (suitably normalised as in
Prop. 2.2) is a positive-definite function of the shift $h$. Ground: this is
Wiener–Khinchin — an autocorrelation has nonnegative spectral measure — and it
is exactly the positivity the circle method uses. It is not new, and §G does not
claim it; it is recorded so that "the reformulation shows nothing" is not
overstated. $\square$

---

## 3. Adjudication: what the extractions give, and what they do not

**(3.1) Goldbach.** Stated precisely: the claim can only be
$$\psi_2(N)>0\ \Longleftrightarrow\ \text{$N$ is a sum of two primes.}$$
The forward-facing half is fine; the equivalence is **not available**.
$\Lambda$ is supported on prime powers, so
$$\psi_2(N)>0\iff N=p^{j}+q^{k}\ \text{for some primes }p,q\text{ and }j,k\ge1,$$
which is strictly weaker as a *statement*: Goldbach for even $N\ge4$ implies
$\psi_2(N)>0$, and the converse would require ruling out even $N$ representable
only with a proper prime power — not known. The prime-power contribution to
$\psi_2(N)$ is $O(\sqrt N\log^2N)$ in size, but smallness of a contribution is
not the same as its absence, and positivity is exactly the question where the
distinction bites. **This is the announced-$\Rightarrow$-silently-upgraded-to-$\Leftrightarrow$
pattern** flagged in D0017 §F: "Goldbach $=$ $[w^N]\mathcal K$" asserts an
equality of statements where only one implication is proved.

**(3.2) Twin primes.** Stated precisely: $\mathcal K(w,1)\ne0\iff w-1$ and $w+1$
are both prime powers. Then:
- *Non-vanishing of $[r^1]\mathcal K$ gives nothing*: it already holds at $w=4$
  ($\Lambda(3)\Lambda(5)$). The correct functional is not "is it nonzero" but
  "are there infinitely many nonzero terms", equivalently (Prop. 2.2) whether
  $c_1(t)$ is unbounded as $t\to0^+$ — the objects differ, and §G's phrasing
  invites the weaker one.
- Even in the right form it is the *prime-power* twin statement. Infinitude of
  twin primes implies it; the converse needs the finiteness of pairs of prime
  powers differing by $2$ with at least one proper power, a Pillai-type question
  not settled in general. Same structural caveat as (3.1).

**(3.3) Does the reformulation carry information? No — and here is the proof.**

**Theorem 3.4.** The array $A=\bigl(\Lambda(a)\Lambda(b)\bigr)_{a,b\ge1}$ and the
function $Z$ on $\{t>0\}\times\mathbb R$ determine each other.

*Proof.* $A\Rightarrow Z$ is Proposition 1.3. Conversely, from $Z$: for each
fixed $t>0$, Proposition 2.2 recovers every $c_r(t)$ (Fourier coefficients of a
continuous periodic function are unique); each $c_r(\cdot)$ is a Dirichlet
series in $e^{-2t}$ with nonnegative coefficients, absolutely convergent for
$t>0$, so by the identity theorem for such series its coefficients
$\mathcal K(w,r)$ are determined; and $\Lambda(a)\Lambda(b)=\mathcal K\bigl(\tfrac{a+b}2,\tfrac{b-a}2\bigr)$
by Proposition 1.3's bijection. $\square$

**Verdict, plainly.** The passage $\Lambda(a)\Lambda(b)\rightsquigarrow\mathcal K(w,r)$
is the linear bijection $\Phi$ of Prop. 1.3 — the (sum, half-difference)
coordinates, i.e. centre-and-radius — and the passage
$\mathcal K\rightsquigarrow Z$ is an invertible Fourier–Laplace transform.
Composites of bijections and invertible transforms neither create nor destroy
information. **Every statement about $Z$ of the coefficient-extraction type is a
restatement of a statement about $\sum_{a+b=N}\Lambda(a)\Lambda(b)$ or
$\sum_{n\le x}\Lambda(n)\Lambda(n+2)$, and §G's two claims are, once made
precise, weaker than their headline names.** This is a clean negative and it is
the expected one.

Scope limit: Theorem 3.4 says the *data* are equivalent, not that the two
presentations are equally *useful*. A change of variables can be a good change
of variables — Prop. 2.3 is visible in one and not the other, and the centre
coordinate $w$ is genuinely the natural one for Goldbach. What is excluded is
the stronger reading, that the reformulation constitutes progress on either
conjecture.

---

## 4. Correction C1: the missing gamma factor

**Proposition 4.1.** For $\operatorname{Re}s>1$,
$$\mathcal M[P](s):=\int_0^\infty z^{s-1}P(z)\,dz=\Gamma(s)\sum_{n\ge1}\frac{\Lambda(n)}{n^{s}}=\Gamma(s)\left(-\frac{\zeta'}{\zeta}(s)\right).$$

*Proof.* $\int_0^\infty z^{s-1}e^{-nz}dz=\Gamma(s)n^{-s}$ for $\operatorname{Re}s>0$,
$n\ge1$; interchange is justified for $\operatorname{Re}s>1$ because
$\sum_n\Lambda(n)\int_0^\infty z^{\sigma-1}e^{-nz}dz=\Gamma(\sigma)\sum_n\Lambda(n)n^{-\sigma}<\infty$. $\square$

So §G's $-\zeta'/\zeta(s)=\mathcal M[P](s)$ **is off by $\Gamma(s)$**, and this
is recorded as a concrete correction to the transmission. It is not cosmetic:
$\Gamma$ contributes poles at $s=0,-1,-2,\dots$ and exponential decay
$|\Gamma(\sigma+\mathrm it)|\sim e^{-\pi|t|/2}$ in vertical strips. Any contour
shift, any continuation, and any convergence claim built on the printed identity
would inherit the wrong polar divisor and the wrong vertical growth. (The decay
is also what makes the smoothed object well-behaved, so the factor is working
*for* the framework, not against it.)

**Scope note on $\xi(s)=\xi(1-s)$.** True, and correctly quoted, but it is a
statement about $\zeta$, not about $P$. Displaying it beside $\mathcal M[P]$
invites reading a functional equation of the shape $\mathcal M[P](s)\leftrightarrow\mathcal M[P](1-s)$;
there is none. What holds is $\xi'/\xi(s)=-\xi'/\xi(1-s)$, i.e. the
antisymmetry belongs to the *completed* logarithmic derivative, which differs
from $-\zeta'/\zeta$ by the archimedean terms
$\tfrac12\log\pi-\tfrac12\tfrac{\Gamma'}{\Gamma}(s/2)$ and the pole terms. Any
symmetry to be used must be stated at that generality.

---

## 5. The categorification question: prior art and an honest verdict

The question §G asks is $\mathcal K(w,r)\overset{?}{=}\operatorname{Tr}\mathscr K_{w,r}$,
$Z=\operatorname{Tr}\mathscr Z$, "of what representation is $\mathscr Z$ the
character?", on the analogy of $\tau(p)=p^{11/2}(\alpha_p+\beta_p)$ with
$|\alpha_p|=|\beta_p|=1$.

### 5.1 Over $\mathbb Z$: (c), and there is an obstruction at the first step

The analogy is to Deligne: $\tau(p)$ is the trace of Frobenius at $p$ on a
$2$-dimensional $\ell$-adic Galois representation, and the Ramanujan bound is
the purity statement. For that shape one needs the arithmetic coefficient to be
a trace of a Frobenius element on a finite-rank Galois representation — hence an
*algebraic* number, an algebraic integer in the motivic cases.

$\Lambda(p^k)=\log p$ is transcendental (Lindemann). It is therefore not the
trace of Frobenius on any $\ell$-adic representation, and $\mathcal K(w,r)=\log p\cdot\log q$
is not either. The obstruction is not subtle and it is at the first step.

What is true, and is the correct standard-terms replacement: $\log p$ arises as a
*logarithmic derivative* of an Euler factor, $-\frac{d}{ds}\log(1-p^{-s})=\sum_k\log p\cdot p^{-ks}$.
So $\Lambda$ is trace-*derived*, not a trace: it lives one differentiation away
from the coefficients that are traces. Any honest categorification of
$\mathcal K$ must categorify that derivative, and no construction doing so is
known to me after search.

Named work in the neighbourhood, none of it answering §G's question:
- **Weil's explicit formula** is already the statement that $\Lambda$ sits on the
  "geometric" side of a trace-formula-shaped identity opposite the zeros.
- **Connes (1999)**, *Trace formula in noncommutative geometry and the zeros of
  the Riemann zeta function*, gives an operator-theoretic reading of the explicit
  formula in which the prime contributions are a trace. This is the closest
  existing sense in which "$\Lambda$ is a trace", and it is a trace of a
  *transformation*, not a character of a representation whose value at $(w,r)$ is
  $\mathcal K(w,r)$.
- **Bogomolny–Keating**, *Random matrix theory and the Riemann zeros II: n-point
  correlations*, Nonlinearity **9** (1996), derive the $n$-point zero correlations
  from the Hardy–Littlewood prime-pair conjectures via a Gutzwiller-trace-formula
  argument; the reverse reading (Keating–Snaith school, and "Pair correlation and
  twin primes revisited", Proc. R. Soc. A 2016) recovers the Hardy–Littlewood
  singular series from the zero pair correlation. This is a real and named link
  between prime-pair correlations and matrix-integral (i.e. trace) statistics —
  but it relates $\mathcal K$-type sums to *random-matrix averages*, not to a
  character of a specific representation.

### 5.2 Over $\mathbb F_q[T]$: (a), a named programme where the traces are real

In the function-field setting the analogous statement is a theorem-shaped
programme rather than an analogy, because prime-counting there *is* point
counting and Grothendieck–Lefschetz makes the counts traces of Frobenius:
- **Sawin–Shusterman**, *On the Chowla and twin primes conjectures over
  $\mathbb F_q[T]$* (arXiv:1808.04001), settle twin primes and Chowla in that
  setting by geometric/cohomological methods.
- **Keating–Rudnick** relate variances of primes in short intervals and in
  progressions over $\mathbb F_q[T]$ to matrix integrals over the unitary group,
  via Katz's equidistribution of Frobenius conjugacy classes.
- **Keating–Roditty-Gershon**, *Arithmetic correlations over large finite fields*
  (arXiv:1505.01970), study autocorrelations of exactly the von Mangoldt/Möbius/divisor
  functions over $\mathbb F_q[T]$; I read the ar5iv rendering of this one, and
  note for accuracy that its own method is equidistribution plus Lang–Weil rather
  than an explicit Frobenius-trace decomposition.
- **Carmon–Rudnick** proved the large-$q$ Möbius autocorrelation (Chowla) case.

Note what changes: over $\mathbb F_q[T]$ the weight $\log p$ becomes
$\deg(P)\cdot\log q$, and $\deg$ *is* a cohomological grading. That is precisely
the step unavailable over $\mathbb Z$, and it is why the programme exists on one
side of the analogy and not the other.

**Verdict.** Over $\mathbb Z$, §G's categorification question is **(c): an
analogy with no current mathematical content**, and §5.1 gives a reason, not
merely an absence. It is not even (b) — an open question in standard terms —
because as posed it has no well-formed candidate; the well-posed neighbouring
questions are Hardy–Littlewood and the Bogomolny–Keating correspondence, both
of which are (a) with named work. Over $\mathbb F_q[T]$ it is **(a)**. A forced
(a) for the $\mathbb Z$ question would have been the wrong answer, and I decline
to give one.

Sources consulted (rendered HTML or search abstracts only; **no PDF was
decoded, and no claim above rests on a PDF I could not read**):
[Keating–Roditty-Gershon, arXiv:1505.01970](https://ar5iv.labs.arxiv.org/html/1505.01970),
[Bogomolny–Keating, Nonlinearity 9 (1996)](https://iopscience.iop.org/article/10.1088/0951-7715/9/4/006),
[Pair correlation and twin primes revisited, Proc. R. Soc. A](https://royalsocietypublishing.org/doi/10.1098/rspa.2016.0548),
[Sawin–Shusterman, arXiv:1808.04001](https://arxiv.org/pdf/1808.04001) (abstract via search only),
[Twin prime correlations from the pair correlation of Riemann zeros](https://arxiv.org/pdf/1903.07057) (abstract via search only).

---

## 6. Corpus link: the object is already here, with theorems §G does not have

Checked by reading, not by title.

- **`notes/DSIDE.md` §3** already owns the object. Its $C_h(X)=\sum_n\Lambda(n)\Lambda(n+h)(X-n)_+$
  is $\mathcal K(\cdot,h/2)$ under a *Cesàro* weight where §G uses a *Laplace*
  weight $e^{-2tw}$. §3.1 gives an exact decomposition proved unconditionally
  with the zero-sum layer, and under RH the error $O(X+hX^{1/2}\log^2X)$; §3.2
  gives the zero-pair bilinear expansion with an explicit ledger of where
  theorem becomes conjecture; §3.3 states plainly that the formal double sum
  diverges and why. **§G neither duplicates a result nor contradicts one: it
  restates the object without the weight, without the decomposition, and without
  the convergence ledger.** The honest relation is that `DSIDE.md` is strictly
  ahead on this object.
- **`notes/CENTER_BOUNDED_PRIME_PAIR.md`** already uses the centre coordinate
  $w=(p+q)/2$ with the leg bounds derived from it — the same change of variables
  as Prop. 1.3, and formalised. So §G's coordinates are the corpus's coordinates
  already; that is a point of agreement, not a new alignment, and I record it as
  such rather than restating either note in the other's vocabulary (§J8).
- **`notes/SEED71_PAIR_WEIGHT_IS_NOT_A_FORM_FACTOR.md`** is the directly relevant
  precedent for §5: it proves that a corpus pair weight which *looked* like a
  random-matrix form factor is not one, and that the resemblance was notation.
  The verdict in §5.1 is the same discipline applied to "$\mathcal K$ looks like
  a character".

Nothing in `notes/` connects to §G's $D_g$/$J_g$ cocycle display, which is not
examined here (no group action on $(t,\theta)$ is specified in §G, so there is
nothing yet to verify).

## 7. $\chi_\alpha$

Nothing above bears on D0018 §J5's $\chi_\alpha$; no quantity in this note is
measured, fitted, or numerical, and I do not touch it.

## 8. Scope limits, stated so the audit is cheap

1. Everything is for $\operatorname{Re}z=t>0$; nothing is claimed about $t\to0^+$
   beyond the tautology in §3.2 that the twin statement *is* the $t\to0^+$
   behaviour.
2. Theorem 3.4 is an equivalence of data, not of difficulty (§3, scope limit).
3. §5.1's obstruction rules out the *Deligne-shaped* categorification
   ($\mathcal K$ as a Frobenius trace on a finite-rank $\ell$-adic
   representation). It does not rule out categorifications of other shapes;
   it says none is known to me and that the stated analogy is not one.
4. Prior-art search was by web search and rendered HTML. Absence of a result in
   §5 is my failure to find it, not a theorem that it does not exist.
5. No claim here rests on any computation, exact or numerical.
