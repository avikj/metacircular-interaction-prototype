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

## Post-census exact filtering

The discovery-only successor `code/exp41_nonic_postcensus.py` applies exact
Sturm and Routh--Cayley tests to the 22,077 unit-resultant tuples.  The exact
candidate ledgers are

$$
22{,}077\longrightarrow6{,}082\longrightarrow768,
$$

where the last set has exactly one real root and all nine roots in the relaxed
rational annulus

$$
\frac{617}{1000}<|z|<\frac{20001}{10000}.
$$

No Routh table was degenerate.  Reciprocity gives no fixed point and no
two-element orbit contained in this 768-tuple set.  This is expected rather
than paradoxical: reciprocity preserves reducibility and the annulus, but
sends the distinguished negative root $-t$ to $-1/t$ and therefore does not
preserve the small negative-root window.

An additional exact Routh count at radius $2$ removes one tuple,

$$
(a,b,c,d,e,f,h,j)=(0,6,0,8,0,0,0,0),
$$

which has only seven roots in $|z|<2$.  Thus the strict prime-prefix root box
contains $767$ tuples.  No radius-two Routh table is degenerate.

Exact degree-nine Rabin tests over finite fields give irreducibility witnesses
for 754 tuples.  Twelve further tuples have explicit integer factorization
witnesses, all recorded in `data/exp41_nonic_postcensus.json`.  The sole
remaining tuple is

$$
g(x)=x^9+4x^3+1.
$$

It has the candidate Cohn witness

$$
g(6)=10{,}078{,}561,
$$

which exact trial division verifies is prime, while the coefficients of $g$
are base-six digits.  Brillhart--Filaseta--Odlyzko's arbitrary-base form of
Cohn's criterion therefore proves this singleton irreducible (Canad. J. Math.
33 (1981), Corollary 2, DOI 10.4153/CJM-1981-080-0).

As a separate completeness cross-check, every possible monic integral factor
of degree at most four was enumerated using the strict root bound $|z|<2$.
For degree $k$, integrality and

$$
|e_\ell|<\binom{k}{\ell}2^\ell
$$

give 89,352 factor candidates in total.  All thirteen inputs to this search
have separately certified root count nine in $|z|<2$.  The search finds
exactly the same twelve reducibles and no factor of $x^9+4x^3+1$.  Independent
hostile replay accepted the factor-box completeness, every Rabin assignment,
all explicit products, and the Cohn witness.  Thus the post-census
irreducibility partition is exact; the overall nonic obstruction still
requires the separately audited prime-prefix/tail layer.

## Odd-degree resultant-tail closure

The tail layer is now independently audited, conditional on the upstream
exp37 census.  Let $-t$ be the unique negative root of an irreducible nonic
candidate and let $r_1,\ldots,r_4$ be the moduli of its four complex-conjugate
pairs.  If $g$ divides a later prime prefix $F_X$ after a prime cutoff $q$,
write

$$
F_X=F_q+T.
$$

At every root $\alpha$ of $g$, $F_q(\alpha)=-T(\alpha)$.  If $N$ is the
exponent of the first prime monomial after $q$, all tail exponents are odd,
so at the negative root

$$
|T(-t)|\le \frac{t^N}{1-t^2}.
$$

At either root in the $i$th complex pair, use the finite-prefix bound

$$
|F_q(\alpha)|\le
B_q(r_i),
\qquad
B_q(r)=\sum_{p\le q}r^{p-2}.
$$

Multiplying the nine root evaluations gives the exact necessary inequality

$$
\boxed{
|\operatorname{Res}(g,F_q)|(1-t^2)
\le
t^N\prod_{i=1}^4 B_q(r_i)^2.
}
$$

Both certificate scripts replace $t,r_i$ by exact rational upper bounds, for
which the right side is monotone.  `code/exp42_nonic_tail_discovery.py` uses
12 negative-root and 10 complex-radius bisections.  On the strict set of 755
irreducibles it checks 3,556 exact resultants, finds no prefix divisor, and
certifies every candidate by cutoff $41$:

$$
\begin{array}{c|rrrrrrrr}
q&13&17&19&23&29&31&37&41\\ \hline
\#&10&137&127&345&78&43&12&3.
\end{array}
$$

The minimum strict margin is greater than $277$.  The independent hostile
replay `code/audit42_nonic_tail.py` uses finer 20/16-step radius bounds and
constructs every $F_q$ directly before exact division, rather than using the
production power recurrence.  It checks 3,544 resultants and independently
closes all 755 candidates with minimum margin greater than $10{,}422$.

~~At this stage the combined theorem remained unpromoted pending the exp37
convex-box and full-census audit.~~  That independent audit subsequently
reproduced all 441 shards and accepted the reduction.  The integrated theorem
and fresh no-checkpoint replay are now recorded in `NONIC_OBSTRUCTION.md` and
`code/exp44_nonic_certificate.py`.
