# Constraint algebra at length five: exact Walsh facets and a stationary countermodel

**Status:** R0021 seed/formalizing. Exact obstruction recovered from the
orphaned `code/exp53_window5_polytope.py`. This note audits a proof step; it
does **not** claim a counterexample to the Liouville 24-pattern theorem.

## 1. Verdict first

The five-window correlation algebra has a sharp ten-zero stationary model.
For $\varepsilon\in\{\pm1\}^5$, put

$$
\begin{aligned}
32\mu_{a,b,c}(\varepsilon)=1
&+a(\varepsilon_1\varepsilon_2\varepsilon_3\varepsilon_4
    +\varepsilon_2\varepsilon_3\varepsilon_4\varepsilon_5)\\
&+b(\varepsilon_1\varepsilon_3\varepsilon_4\varepsilon_5
    +\varepsilon_1\varepsilon_2\varepsilon_3\varepsilon_5)
 +c\varepsilon_1\varepsilon_2\varepsilon_4\varepsilon_5.
\end{aligned}
\tag{1.1}
$$

At

$$ (a,b,c)=\left(\frac13,\frac13,\frac13\right), \tag{1.2} $$

all 32 masses are nonnegative, sum to one, and exactly ten vanish. The
four-bit prefix and suffix marginals agree, so this is not merely a local
table: it extends to a stationary binary process.

This directly falsifies the sentence in the nonzero-$(a,b,c)$ case of the
published proof of Tao--Teräväinen, Theorem 1.14, that each of the three
displayed flips changes a zero probability and hence every four-orbit has at
most one zero. For example, at (1.2),

$$
(+,+,+,+,-)\longmapsto(-,+,+,+,+)
\tag{1.3}
$$

under the first flip, and both masses are zero. Here
$\varepsilon_1=-\varepsilon_5$, so flipping both endpoints does not change
the $a$-term at all.

The arithmetic theorem is not refuted by (1.2). The stationary process
constructed below is not known to be completely multiplicative or compatible
with Liouville's dilation action. The exact yield is narrower and important:
the correlation inputs explicitly listed before the orbit count do not prove
the advertised 24-positive-pattern conclusion. Any repair must use an
additional arithmetic or higher-window constraint.

## 2. The complete continuous polytope

Set $s=\varepsilon_1\varepsilon_5$ and
$t=\varepsilon_2\varepsilon_4$. The 32 masses split into four classes, each
of size eight:

| class | $(s,t)$ | value of $32\mu$ | multiplicity of each displayed value |
|---|---:|---|---:|
| A | $(+1,+1)$ | $1+c+2ax+2by$, $x,y\in\{\pm1\}$ | 2 |
| B | $(+1,-1)$ | $1-c-2ax$, $x\in\{\pm1\}$ | 4 |
| C | $(-1,+1)$ | $1-c-2by$, $y\in\{\pm1\}$ | 4 |
| D | $(-1,-1)$ | $1+c$ | 8 |

Consequently, nonnegativity of all 32 masses is **equivalent** to

$$
-1\le c\le1,\qquad
2|a|\le1-c,\qquad
2|b|\le1-c,\qquad
2(|a|+|b|)\le1+c.
\tag{2.1}
$$

This is the full continuous classification. The bounds in the interrupted
WIP's grid, $|a|\le1/2$ and $|b|,|c|\le2/3$, were a search box, not a theorem.

### Theorem 2.1 (sharp zero count away from the $c$ endpoints)

Assume (2.1) and $|c|<1$. At most ten of the 32 masses vanish. Equality holds
exactly at

$$ c=\frac13,\qquad |a|=|b|=\frac13. \tag{2.2} $$

**Proof.** Class D has no zeros. Each of B and C has either zero or four zero
patterns, and has four precisely when the corresponding inequality
$2|a|\le1-c$ or $2|b|\le1-c$ is an equality.

In class A, because $1+c>0$, at most two of the four signed affine values can
vanish if one of $a,b$ is zero, and at most one can vanish if both are
nonzero. Their pattern contributions are therefore at most four and two,
respectively.

If both B and C vanish, then

$$ |a|=|b|=\frac{1-c}{2}. $$

The A inequality in (2.1) forces $c\ge1/3$. At $c=1/3$ exactly one A value
also vanishes, contributing $4+4+2=10$ patterns; for $c>1/3$ every A value is
positive and the total is eight. If exactly one of B,C vanishes, its four
zeros plus the at-most-four A zeros give at most eight. If neither vanishes,
class A contributes at most four. This proves the bound and its equality
classification. $\square$

The endpoint hypothesis matters: at $(a,b,c)=(0,0,\pm1)$ there are sixteen
zeros. Tao--Teräväinen's strict bound $|c|<1$ excludes those points.

## 3. Exact stationary extension

Regard a five-bit word as a directed edge in the order-four binary de Bruijn
graph, from its first four bits to its last four bits. Summing (1.1) over the
last bit gives the outgoing mass at a state
$v=(\varepsilon_1,\ldots,\varepsilon_4)$:

$$
\pi(v)=\frac{1+a\varepsilon_1\varepsilon_2
                    \varepsilon_3\varepsilon_4}{16}.
\tag{3.1}
$$

Summing over the first bit gives exactly the same expression for the incoming
mass. Thus (1.1) is a conserved de Bruijn flow whenever it is nonnegative.
At (1.2), every $\pi(v)$ is positive. The transition probabilities

$$
K(v,\varepsilon_5)=
\frac{\mu_{1/3,1/3,1/3}(\varepsilon_1,\ldots,\varepsilon_5)}{\pi(v)}
\tag{3.2}
$$

therefore define a stationary order-four Markov chain whose five-window law
is precisely the countermodel.

Walsh inversion is exact: all nonempty coefficients vanish except

$$
\widehat\mu(1234)=\widehat\mu(2345)=a,quad
\widehat\mu(1345)=\widehat\mu(1235)=b,quad
\widehat\mu(1245)=c.
\tag{3.3}
$$

Hence the model has every odd-order and every two-point coefficient equal to
zero on this window, has the shift and reversal equalities used in the paper,
and satisfies $|a|\le1/2$ and $|c|<1$. Stationarity alone cannot repair the
orbit count.

## 4. Audit of the published step

The primary checked texts are arXiv:1904.05096v2 and the open-access journal
version, Forum of Mathematics, Sigma 7 (2019), e33, Section 7. They contain
the same nonzero-case argument.

Before that case split, the proof uses:

1. odd-order logarithmic Chowla to remove odd Walsh coefficients;
2. two-point logarithmic Chowla to remove two-point coefficients;
3. shift invariance to identify the two consecutive coefficients as $a$;
4. the isotopy formula to identify the reflected coefficients as $b$;
5. a consecutive-correlation estimate giving $|a|\le1/2$; and
6. a propagation argument giving $|c|<1$.

The table (1.2) satisfies every corresponding five-window condition. The
fault is the assertion that nonzero $a$ makes the endpoint flip change every
probability. Its actual difference is proportional to
$a(\varepsilon_1+\varepsilon_5)$, which is zero whenever the endpoints are
opposite. The analogous middle flip can likewise fix values when
$\varepsilon_2=-\varepsilon_4$.

No author or journal corrigendum was found in the initial primary-source
search. That search result does not establish novelty, and R0021 remains
non-load-bearing pending independent audit and external review.

## 5. What the orphaned exp53 did and did not establish

| WIP item | recovered verdict |
|---|---|
| Walsh transcription | correct exact identity |
| four-class table | correct when the two reflected coefficients are equal |
| counts 10 at $(1/3,1/3,1/3)$ and 8 at $(1/2,0,0)$ | correct |
| “polytope maximum” from a step-$1/60$ grid | invalid certificate type; replaced by Theorem 2.1 |
| uniqueness of grid maximizers | advertised but not checked by the old return condition |
| four $\mathbb F_2[u]$ products | correct identities |
| finite Liouville regression | irrelevant to the theorem and removed |

The auxiliary polynomial identities are

$$
\begin{aligned}
(u+u^2+u^3+u^4)(1+u)&=u+u^5,\\
(u+u^2+u^4+u^5)(u+u^2+u^3)&=u^2+u^8,\\
(u+u^2+u^3+u^5)(1+u+u^3)&=u+u^8,\\
(u+u^3+u^4+u^5)(1+u^2+u^3)&=u+u^8
\end{aligned}
\tag{5.1}
$$

over $\mathbb F_2[u]$. They show how an **extremal**, almost-sure four-point
relation would propagate to a forbidden two-point relation. At the sharp
table the correlations are $\pm1/3$, not $\pm1$, so (5.1) does not exclude
it. The WIP contained no argument connecting these identities to the required
ten-zero exclusion.

## 6. The exact missing structure

A repair of the 24-pattern conclusion must rule out the four vertices (2.2),
or otherwise show that no Liouville generalized limit has more than eight
zero atoms. Because those vertices already extend to stationary processes,
the missing premise cannot be only positivity, five-window Walsh symmetry, or
shift invariance. It must use information such as:

- compatibility of higher windows under the complete-multiplicative dilation
  identities;
- a quantitative non-extremality statement coupling several four-point
  correlations, stronger than their individual bounds; or
- another arithmetic pattern theorem that directly forces an atom absent at
  every vertex (2.2).

This is the useful Workstream C outcome: the constraint graph locates the
first exact stationary false model and names the extra interface that an
arithmetic proof must cross.

## 7. Replay

Run:

```text
python3 code/exp53_window5_polytope.py
```

The script uses exact rationals, checks all 32 patterns and all 31 nonempty
Walsh coefficients, constructs every transition row, includes a planted
nonstationary control, and exhibits the broken flip explicitly. It performs no
scan or empirical Liouville computation.
