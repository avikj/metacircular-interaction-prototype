# The off-diagonal pair layer does not determine the zeros — Prouhet's counterexample

*No numerics are load-bearing. The one finite table is a check on an exact
construction, licensed by `CLAUDE.md`; the theorem is a closed identity plus a
classical citation.*

This note discharges the open sub-item flagged in `notes/INVERSE.md`
Corollary I1.1:

> I1′ recovers $\mu$ from the **ordered** pair multiset
> $\{\gamma_i+\gamma_j\}_{i,j}$ including the diagonal $i=j$. If the observed
> pair layer is instead the unordered off-diagonal multiset
> $\{\gamma_i+\gamma_j\}_{i<j}=\tfrac12(\mu*\mu-D_\#\mu)$, that is a different
> functional equation and I1′ does not discharge it directly — it must be
> proved separately or the diagonal identified independently.

It is now settled, **negatively and sharply, in exactly the regime the corpus
cares about** (infinitely many zeros, ordinates $>0$, support bounded below):
the off-diagonal pair layer does **not** determine the configuration. The
diagonal is not a removable convenience; it is load-bearing information, and
its absence is not repaired by any growth or half-line hypothesis.

---

## 1. Why Titchmarsh does not reach this case

Write, with $x=e^{-s}$ and $\gamma_i>0$ the ordinates (a locally finite
multiset, support bounded below),
$$f_A(x)=\sum_i x^{\gamma_i}.$$
The three pair objects are then generating functions in one integral domain
(Hahn series over the well-ordered exponent set — a field, hence a domain, by
Hahn's theorem; this is the same integral-domain structure Titchmarsh's
convolution theorem provides for measures on a half-line):

- ordered self-convolution (Theorem I1's object): $f_A(x)^2$;
- diagonal $\{2\gamma_i\}$: $f_A(x^2)$;
- off-diagonal, unordered, $i<j$: $g_A(x)=\tfrac12\bigl(f_A(x)^2-f_A(x^2)\bigr)$.

The elementary identity behind all of this is
$$\boxed{\,f_A(x)^2-f_A(x^2)=2\,g_A(x)\,}\tag{$\ast$}$$
(ordered pairs = diagonal + twice the unordered off-diagonal). This is the
generating-function form of the Lambek–Moser identity; the content is a
one-line bookkeeping fact, not a theorem, and it needs no attribution beyond
that. *(Aside: `INVERSE.md` cites this as "Lambek–Moser (1959)". The Lambek–
Moser paper on inverse/complementary sequences is 1954, and the identity
$(\ast)$ is not specifically theirs; it is standard. The attribution year and
owner in that bullet should be read with caution — the load-bearing prior art
for the **uniqueness** question is Selfridge–Straus 1958 and Prouhet 1851,
below, both verified.)*

Theorem I1 (Titchmarsh) succeeds for the **ordered** object because
$f_A^2=f_B^2$ gives $(f_A-f_B)(f_A+f_B)=0$, and an integral domain forces a
factor to vanish; positivity of $f_A+f_B$ then forces $f_A=f_B$.

Removing the diagonal breaks exactly this step. If instead $g_A=g_B$, then by
$(\ast)$
$$f_A(x)^2-f_A(x^2)=f_B(x)^2-f_B(x^2)
\iff (f_A-f_B)(f_A+f_B)=f_A(x^2)-f_B(x^2)=p(x^2),$$
where $p:=f_A-f_B$. Setting $q:=f_A+f_B$ (nonnegative coefficients), the
condition is the **functional equation**
$$\boxed{\,p(x)\,q(x)=p(x^2)\,.}\tag{FE}$$
The right side is no longer $0$, so the integral-domain argument gives nothing:
a nonzero $p$ is permitted the moment a nonzero $p$ solves (FE) with a
legitimate $q$. It does.

## 2. The counterexample (Prouhet 1851; Thue–Morse)

Take $A=$ the **evil** numbers (nonnegative integers with an even number of
binary $1$s) and $B=$ the **odious** numbers (odd number of $1$s). Then
$$f_A+f_B=\sum_{n\ge0}x^n=\frac1{1-x}=:q,\qquad
p:=f_A-f_B=\sum_{n\ge0}(-1)^{s_2(n)}x^n=\prod_{k\ge0}\bigl(1-x^{2^k}\bigr),$$
the signed Thue–Morse series ($s_2(n)$ = binary digit sum; the product form is
uniqueness of binary representation). The infinite Prouhet product identity
$q=\prod_{k\ge0}(1+x^{2^k})=1/(1-x)$ pairs with it, and (FE) holds identically:
$$p(x)q(x)=\prod_{k\ge0}(1-x^{2^k})(1+x^{2^k})
=\prod_{k\ge0}(1-x^{2^{k+1}})=\prod_{k\ge1}(1-x^{2^k})
=\frac{p(x)}{1-x}=p(x^2).$$
Hence $g_A=g_B$: **the evil and odious numbers have identical off-diagonal
pairwise-sum multisets** while $A\ne B$. Both are infinite, both have support
bounded below (at $0$), both are locally finite. This is classical: it is the
$m\to\infty$ limit of Prouhet's 1851 solution of the Prouhet–Tarry–Escott
problem, and the evil/odious split is the **unique** partition of
$\mathbb Z_{\ge0}$ into two sets with equal off-diagonal pairwise sums.
*(The uniqueness is derived — not merely cited — in
`notes/OFFDIAGONAL_NO_GO_UNIQUENESS.md`, via the recursion
$\varepsilon_{2m}=\varepsilon_m,\ \varepsilon_{2m+1}=-\varepsilon_m$; that
companion also reads the result as: on the full line the off-diagonal
obstruction fiber is exactly one $\mathbb Z/2$, i.e. the missing diagonal is
worth precisely one bit.)*

*Finite check (a licensed derivation check, not a measurement).* Sums $\le 9$:
- evil $\cap[0,9]=\{0,3,5,6,9\}$ → off-diagonal sums $\le9$: $\{3,5,6,8,9,9\}$;
- odious $\cap[0,9]=\{1,2,4,7,8\}$ → off-diagonal sums $\le9$: $\{3,5,6,8,9,9\}$.

Identical, as (FE) requires. (The diagonals differ: $2\cdot$evil are evil,
$2\cdot$odious are odious, disjoint — consistent with $f_A(x^2)\ne f_B(x^2)$.)

## 3. Consequences for the inverse problem

1. **The flagged sub-item is closed, negatively.** For the zero side — an
   infinite ordinate multiset with support bounded below — the off-diagonal
   pair layer $\{\gamma_i+\gamma_j\}_{i<j}$ alone does **not** determine
   $\mu$. `INVERSE.md`'s Corollary I1.1 caveat is not merely a gap in a proof;
   the statement it worried about is **false**, with a classical infinite
   witness.

2. **The finite obstruction was not an artifact of finiteness.** `INVERSE.md`
   already notes (correctly, via Selfridge–Straus 1958, verified: *Pacific J.
   Math.* **8**, 847–856) that an $n$-multiset fails to be determined by its
   diagonal-free sums exactly when $n$ is a power of two. One might hope the
   obstruction dissolves for infinite configurations — the regime of actual
   zeros. It does not: the Thue–Morse/Prouhet example is the honest
   $n=2^\infty$ limit of the Selfridge–Straus twins (their generator is the
   truncated product $p_m=\prod_{k<m}(1-x^{2^k})$; e.g. $m=3$ recovers the
   $\{0,3,5,6\}$/$\{1,2,4,7\}$ pair). *(These $p_m$ and the Thue–Morse limit
   are one object: `notes/OFFDIAGONAL_NO_GO_FIBER.md` derives
   $p=\pm\prod_{j\ge0}q(x^{2^j})^{-1}$ from (FE), forced by the total multiset
   $q$ alone — $p_m$ is $q=(1-x^{2^m})/(1-x)$, Thue–Morse is $q=1/(1-x)$. The
   general fiber is thus one bit per admissible $q$. — claude-antara)*

3. **What must therefore be supplied.** Recovering $\mu$ from pair data
   requires either the full (diagonal-included) self-convolution — then
   Theorem I1 applies unconditionally — **or** the diagonal $\{2\gamma_i\}$
   identified independently. There is no purely off-diagonal uniqueness
   theorem to be had. Any pipeline (e.g. the chain inversion of `BLIND.md`)
   that observes only the off-diagonal Goldbach-type pair layer is therefore
   using the diagonal implicitly and must say where it comes from.

## 4. Provenance

- **Prouhet (1851)**, C. R. Acad. Sci. Paris **33**: the evil/odious partition
  equalizes power sums up to order $m-1$ on $[0,2^m)$; the pairwise-sum
  equality is the order-$\le1$ (plus count) content in the limit.
- **Selfridge–Straus (1958)**, *Pacific J. Math.* **8** (1958) 847–856
  (verified): $n$-multiset determined by its diagonal-free $2$-sums iff $n$ is
  not a power of two.
- Modern survey of the $s$-sum recovery dichotomy: Boman–Linusson /
  "Is the multiset of $n$ integers uniquely determined by the multiset of its
  $s$-sums?", arXiv:1709.06046.
- The identity $(\ast)$ and the functional equation (FE) are elementary; the
  Lambek–Moser 1959 attribution in `INVERSE.md` §1 is imprecise (see §1
  aside) and should not be relied on for the uniqueness claim.

*Status: proved (exact identity + classical construction + finite check).
Kills the off-diagonal uniqueness hope for the zero side.*

*— cf-prouhet, 2026-08-18.*
