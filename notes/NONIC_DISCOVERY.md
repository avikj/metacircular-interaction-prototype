# Nonic factor discovery: proved search reduction

This note records the exact reduction used by `code/exp37_nonic_discovery.py`
and `code/exp37_nonic_enumerator.cpp`.  It is a workload/candidate census, not
yet a classification theorem.

Write a putative irreducible nonic factor as

$$
g=x^9+ax^8+bx^7+cx^6+dx^5+ex^4+fx^3+hx^2+jx+1.
$$

The constant term is one.  Splitting parity gives

$$
E=1+hy+ey^2+cy^3+ay^4,
\qquad
O=j+fy+dy^2+by^3+y^4,
$$

and `PARITY_RESULTANT.md` proves

$$
\operatorname{Res}(E,O)=\pm1.
$$

## Negative-root window

An irreducible odd-degree factor owns the unique negative root $-t$ of the
prime-prefix polynomial.  Degree nine forces the prefix to contain $F_{11}$.
The odd-support geometric-series inequality gives

$$
t>\lambda=\frac{\sqrt5-1}{2}>\frac{309}{500},
$$

while direct exact evaluation gives $F_{11}(-79/125)<0$.  Since
$F_X(-s)=1-\sum_{3\le p\le X}s^{p-2}$ is strictly decreasing in $s>0$ and
later prefixes only add negative terms,

$$
\boxed{\frac{309}{500}<t<\frac{79}{125}.}
$$

An irreducible nonic has no other real root, hence its sign at the two
endpoints is fixed.  The enumerator uses the exact necessary inequalities
$g(-309/500)>0>g(-79/125)$.

## Safe coefficient box

Let the other roots form four conjugate pairs of radii $r_1,\ldots,r_4$.
Then

$$
t(r_1r_2r_3r_4)^2=1,
\qquad
\lambda<r_i<2.
$$

The coefficient absolute values are bounded by coefficients of

$$
(1+tz)\prod_{i=1}^4(1+r_i z)^2.
$$

For fixed $t$, every coefficient is a symmetric sum of exponentials of linear
forms in $\log r_i$, hence convex.  On the fixed-sum log polytope a maximum is
attained at a vertex.  Three radii are endpoints.  The only feasible vertex
type is

$$
\left\{2,\lambda,\lambda,
\frac{\varphi^2}{2\sqrt t}\right\}.
$$

Indeed, zero upper endpoints force the remaining radius above $2$, while two
or more upper endpoints force it below $\lambda$.  Group the varying factors:

$$
(1+tz)\left(1+\frac{\varphi^2}{2\sqrt t}z\right)^2.
$$

Its nonconstant coefficients are

$$
t+\varphi^2t^{-1/2},\qquad
\frac{\varphi^4}{4t}+\varphi^2\sqrt t,\qquad
\frac{\varphi^4}{4}.
$$

The first two decrease throughout the root window and the third is constant.
Thus the strict supremum occurs as $t\downarrow\lambda$.  Exact rational upper
bounds

$$
\lambda<0.618034,\quad
\varphi<1.618034,\quad
\sqrt\varphi<1.27202
$$

then give the safe integer box

$$
\boxed{
|a|\le10, |b|\le46, |c|\le116, |d|\le181,
|e|\le180, |f|\le115, |h|\le45, |j|\le10.
}
$$

The script verifies the defining rational/algebraic inequalities and every
integer rounding exactly.

## First Graeffe box

Direct expansion of

$$
G(y)=E(y)^2-yO(y)^2
$$

in ascending powers gives

$$
\begin{aligned}
[y^1]G&=2h-j^2,\\
[y^2]G&=2e+h^2-2jf,\\
[y^3]G&=2c+2he-2jd-f^2,\\
[y^4]G&=2a+2hc+e^2-2jb-2fd,\\
[y^5]G&=2ha+2ec-2j-2fb-d^2,\\
[y^6]G&=2ea+c^2-2f-2db,\\
[y^7]G&=2ca-2d-b^2,\\
[y^8]G&=a^2-2b.
\end{aligned}
$$

Applying the preceding vertex argument to squared radii bounds the elementary
symmetric vector from the leading side by

$$
(15,95,300,516,493,270,85,14).
$$

Since $G=-\prod_i(y-\alpha_i^2)$, $e_k$ controls $[y^{9-k}]G$.
The vector must therefore be reversed when indexed by ascending exponent:

$$
\boxed{(14,85,270,493,516,300,95,15).}
$$

This association is stored by exponent in
`machinery/specs/nonic-graeffe-exp37.json`; the generated C++ header is checked
byte-for-byte before enumeration.  The contract prevents an orientation
mistake but does not itself prove the analytic majorant.

## Proved elimination prefilters

Let $g_k=[y^k]G$ and put

$$
u=g_2=2e+h^2-2jf.
$$

The enumerator uses only the triangle-inequality consequences

$$
|g_3-hg_2|\le270+85|h|,
\qquad
|g_6-ag_2|\le300+85|a|.
$$

Their exact expansions are

$$
g_3-hg_2=-f^2+2hjf+2c-2jd-h^3,
$$

$$
g_6-ag_2=2ajf-ah^2+c^2-2f-2db.
$$

Sparse symbolic expansion in Python verifies both identities.  An independent
SymPy/Z3 audit also confirmed that these implications admit no false pruning.

## Current epistemic status

Every active pruning condition is now a named theorem or audited algebraic
lemma.  The complete 441-shard census gives the exact pipeline

$$
191{,}960{,}552{,}091
\longrightarrow 5{,}956{,}908{,}483
\longrightarrow 835{,}048{,}914
\longrightarrow 226{,}514{,}912
\longrightarrow \boxed{22{,}077}.
$$

The stages are respectively the raw $(c,d,f)$ workload, the two proved
elimination prefilters, scalar Graeffe constraints, the full first-Graeffe
box, and the parity unit-resultant test.  All 441 $(a,j)$ shards completed and
their CPU-ledger manifests merge to

```text
5f50abbacc69c2e9d9150920a67d64904f725ff71fe7fc06a304400f3bd66de2
```

The sorted plain-tuple candidate digest is

```text
ce9a01ba00db63b6a55b03348d68d4c1e7463c2a7a021077618b83f4bca415d9
```

The compact machine-readable record is `data/exp37_nonic_workload.json`.
This establishes only the exact finite candidate workload.  It is not a
degree-nine classification theorem.  Hostile proof audit, independent census
reproduction, root-count, irreducibility, prefix, and infinite-tail stages
remain necessary before such a theorem can be claimed.
