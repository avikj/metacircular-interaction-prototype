# Factor architecture after the reciprocal-decic closure

This note records exact corollaries of the degree-nine classification,
singleton-parity rigidity, the unique odd-carrier theorem, and the audited
reciprocal-decic certificate.  It does **not** claim that general degree ten
is closed.

> ⚠️ **Dependency flag (integration audit, 2026-08-12).** Every sector floor
> below depends on **F8** (`OCTIC_OBSTRUCTION_V2.md`), whose own closing line
> requests a fresh hostile audit of the successor artifact and whose
> predecessor was quarantined for a reversed Graeffe coefficient index
> (msg 0033). That audit is in flight (`CROSSREVIEW_OCTIC_V2.md`); until it
> files, the floors "all factors ≥ 10" and "the frontier is the
> nonreciprocal decic" are **conditional on F8**, not independent of it.
> Nothing here is retracted — the flag records an unaudited load-bearing
> input, per the repo's never-a-silent-gap norm.


Let

$$
F_X(x)=\sum_{p\le X}x^{p-2}.
$$

## 1. Sectorwise degree floor

For every real $X\ge13$:

$$
\begin{array}{c|c}
\text{sector}&\text{proved irreducible-degree lower bound}\\ \hline
\text{all factors}&10\\
\text{reciprocal factors}&12\\
\text{nonreciprocal factors}&10\\
\text{unique odd carrier}&11.
\end{array}
$$

The all-factor floor is the full F1--F9 classification.  For the reciprocal
floor, any odd-degree reciprocal or antireciprocal irreducible has $1$ or
$-1$ as a root and is therefore linear.  Neither $x-1$ nor $x+1$ divides
$F_X$ for $X\ge13$, so every reciprocal irreducible divisor then has even
degree.  `RECIPROCAL_DECIC.md` and the earlier even-degree certificates
exclude every such degree through ten after the global cyclotomic cleanup.
The odd carrier has odd degree, is nonreciprocal, and occurs with
multiplicity one.

Thus the first finite open layer is precisely

$$
\boxed{\text{nonreciprocal degree ten}.}
$$

This is a sector statement, not a proof that such a factor exists.

*Integration cross-reference:* for the reciprocal sector's next layer
(degree twelve), the exact all-degree necessary-condition compiler —
coefficient cage plus residual norm-unit equation, instantiated at degree
twelve — is `RECIPROCAL_TRACE_CAGE.md`.

## 2. Exact shape of a hypothetical decic

If a polynomial divisor of $F_X$ has degree ten, it is already irreducible:
otherwise it would be a product of two nonconstant factors, each of degree at
least ten.  Such an irreducible $q$ must be

- nonreciprocal, by the reciprocal-decic theorem;
- totally nonreal, because the unique real root of $F_X$ belongs to the odd
  carrier;
- monic with constant term $+1$: its constant divides $F_X(0)=1$, and its
  roots occur in complex-conjugate pairs;
- a nonreciprocal algebraic unit, hence subject to Smyth's Mahler-measure
  lower bound;
- a solution of the exact parity unit equation
  $\operatorname{Res}(E,O)=\pm1$.

These properties are the input specification for a future general-decic
kernel.  In particular, another reciprocal trace census cannot close the
remaining layer.

## 3. Factorization normal form

Choose one monic representative from each reciprocal-associate class.  The
factorization can be written

$$
F_X
=G_X
\prod_a R_a^{e_a}
\prod_j q_j^{u_j}(q_j^\dagger)^{v_j},
$$

where $G_X$ is the unique odd carrier, every $R_a$ is reciprocal, and
$\{q_j,q_j^\dagger\}$ are the nonreciprocal reversal orbits.  Then

$$
\deg G_X\ge11,\qquad \deg R_a\ge12,\qquad \deg q_j\ge10.
$$

Consequently the reciprocal sector, counted with multiplicity, has at most

$$
\left\lfloor\frac{\deg F_X-11}{12}\right\rfloor
$$

irreducible factors.  This finite bound is compatible with, but weaker than,
the growing asymptotic factor-degree bounds for sufficiently large $X$.

## 4. Algebraic ambiguity is not set ambiguity

Suppose a degree-ten factor $q$ exists.  It lies in a nonreciprocal reversal
orbit distinct from the odd carrier's orbit.  Since $q(0)=1$, its normalized
reciprocal is the integral monic polynomial $q^\dagger=q^\ast$.  Flip only
one copy of this factor:

$$
A=\frac{F_X}{q}\,q^\dagger\in\mathbb Z[x].
$$

With the normalized reversal convention,

$$
AA^\ast=F_XF_X^\ast.
$$

For complete bookkeeping, let the valuations of $(q,q^\dagger)$ in $F_X$
be $(u,v)$ with $u\ge1$.  Their valuations in
$F_X,A,F_X^\ast,A^\ast$ are respectively

$$
(u,v),\quad(u-1,v+1),\quad(v,u),\quad(v+1,u-1).
$$

The odd carrier has opposite orientations in the starred and unstarred
allocations, while it is unchanged by the decic flip.  These two orbit
ledgers make all four allocations distinct, even when $q^\dagger$ already
divides $F_X$ or $q$ has multiplicity.  Hence a decic factor would create at
least four algebraic spectral allocations

$$
F_X,\quad F_X^\ast,\quad A,\quad A^\ast.
$$

But singleton-parity rigidity says the only $0$--$1$ polynomials with the
prime difference multiset are $F_X$ and its reflection (up to translation).
Therefore $A$ and $A^\ast$ necessarily leave the $0$--$1$ cone.

The obstruction is now localized exactly:

$$
\boxed{\text{a decic factor could create algebraic phase ambiguity, but not
a new homometric prime set}.}
$$

## 5. Finite and asymptotic synthesis

For sufficiently large $X$, the exact floors above combine with
`ASYMPTOTIC_FACTOR_RIGIDITY.md` as follows:

$$
\begin{array}{c|c|c}
\text{sector}&X\ge13&X\to\infty\\ \hline
\text{all factors}&\ge10&
\gg\dfrac{\log_2X(\log_4X)^4}{(\log_3X)^4}\\
\text{reciprocal factors}&\ge12&
\gg\dfrac{\log_2X(\log_4X)^4}{(\log_3X)^4}\\
\text{nonreciprocal factors}&\ge10&
\gg\dfrac{\log_2X\log_4X}{\log_3X}\\
\text{odd carrier}&\ge11&
\gg\dfrac{\log_2X\log_4X}{\log_3X}.
\end{array}
$$

The reciprocal-decic theorem is thus a finite structural calibration.  It
sharpens the symmetry-resolved frontier but does not replace the all-degree
asymptotic theorem and does not prove a new prefix irreducible.

## 6. Domain and trust boundary

The reciprocal-decic exclusion itself holds for every real $X\ge2$; it is
degree-trivial for $2\le X<13$.  The sector architecture above is stated for
$X\ge13$, after the complete low-degree and cyclotomic cleanup.  The
asymptotic comparisons require sufficiently large $X$ and presently have no
small numerical threshold.

The only new input in this note is the audited reciprocal-decic exclusion.
The degree-nine floor, unique odd carrier, reversal-allocation algebra,
singleton-parity rigidity, Smyth bound, and asymptotic estimates are proved
in their respective source notes.  This note is their corollary-level
synthesis; no separate novelty claim is made.
