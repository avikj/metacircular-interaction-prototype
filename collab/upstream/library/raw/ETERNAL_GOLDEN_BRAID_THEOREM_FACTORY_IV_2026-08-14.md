# Eternal Golden Braid — Theorem Factory IV

<!-- Provenance: received verbatim from the human owner in a Claude Code session,
     2026-08-14. Transcription artifacts from the source medium (LaTeX brackets
     rendered as [ ... ], stray line breaks, a dropped "=" in Theorem 58's display)
     are preserved as received. Lineage: continuation of
     UNIVALENT_PERSPECTIVAL_THEOREM_FACTORY_DELTA_14_2026-08-13.md (= Factory I).
     Factories II and III are NOT present in this repository — the same
     absent-source defect recorded for Deltas 17/18 in msg 0466. Their theorem
     numbers (50, 54, 55, 62-63, 70-71, 73 and "Factory III radius transfer")
     are cited here but their full statements are not locally recoverable.
     Receiving audit: notes/FACTORY_IV_CHEN_CORNER_AUDIT.md.
     Formalized core: formal/cubical/NaturalMachine/ChenProjector.agda. -->

The Chen completion, double channel projection, and the two-defect corner

The previous factory reduced twin primes to a finite radius-transfer problem. The next layer identifies a second, transverse reduction that has already been achieved by classical sieve theory.

The two reductions meet at one missing corner.

⸻

I. The Chen-completed prime-pair field

Allow signed (r) so that one leg may be distinguished as the prime leg. Define

[
\mathsf C(w,r)
:=
\operatorname{Prime}(w-r)
\times
\bigl[\Omega(w+r)\in{1,2}\bigr].
]

A point consists of:

* a center (w);
* a relative coordinate (r);
* a prime (w-r);
* and a second leg (w+r) that is either prime or semiprime.

Let

[
c:\mathsf C(w,r)\to{1,2}
]

be the factorization-charge map

[
c=\Omega(w+r).
]

Then the exact oriented prime-pair field is its charge-one fiber:

[
\boxed{
PP(w,r)
\simeq
\operatorname{fib}_{c}(1).
}
]

This is the first exact common enlargement of Goldbach and twins that is already inhabited by mature theorems.

Chen's Goldbach theorem says that every sufficiently large even integer is a prime plus an integer with at most two prime factors. Thus every sufficiently large center fiber of (\mathsf C) is inhabited. (arXiv)

Chen's twin theorem says that infinitely many primes (p) have (p+2) prime or semiprime. Thus the radius-one slice of (\mathsf C) is unbounded. Green and Tao use a quantitative version giving (\gg N/\log^2N) such points in dyadic intervals. (arXiv)

Maynard–Tao and Polymath8b provide the other transverse face: infinitely many exact prime pairs occur at some unknown radius

[
1\le r_0\le123.
]

Equivalently, the exact charge-one field is recurrent somewhere inside a finite radius band. (arXiv)

Therefore the current unconditional theorem geometry is:

[
\boxed{
\begin{array}{ll}
\text{Maynard–Polymath face}:&
c=1,\quad r\in{1,\ldots,123}\text{ unresolved},\[1mm]
\text{Chen face}:&
r=1,\quad c\in{1,2}\text{ unresolved}.
\end{array}
}
]

The twin-prime target is their intersection:

[
\boxed{
(r,c)=(1,1).
}
]

This is not a metaphorical square. The two axes are exact arithmetic indices.

⸻

II. Parity becomes informationally complete after Chen

Let

[
\lambda(n)=(-1)^{\Omega(n)}
]

be the Liouville function.

On unrestricted integers, parity forgets enormous charge information:

[
1,3,5,\ldots\mapsto-1,
\qquad
2,4,6,\ldots\mapsto+1.
]

But on the Chen envelope, only charges one and two remain. The map

[
{1,2}\longrightarrow{-1,+1},
\qquad
c\longmapsto(-1)^c
]

is a bijection.

Theorem 58 — Exact Chen projector

For every admissible (w,r),

[
\boxed{
\mathbf 1_{PP(w,r)}

\mathbf 1_{\mathsf C(w,r)}
\frac{1-\lambda(w+r)}2.
}
]

Proof

On (\mathsf C):

* (\Omega(w+r)=1) means (w+r) is prime and (\lambda(w+r)=-1);
* (\Omega(w+r)=2) means (w+r) is semiprime and (\lambda(w+r)=+1).

Thus ((1-\lambda)/2) is exactly the charge-one projector. ∎

This sharply revises the parity story.

After a (P_2) envelope has been proved, the problem is not that parity remains too coarse to recover charge. Within charges ({1,2}), parity recovers charge exactly.

The remaining problem is:

[
\boxed{
\text{prove that the odd-charge sector has mass inside the proven two-charge field.}
}
]

The exact pointwise identity and its interpretation are recorded in the persistent theorem artifact.

⸻

III. One center–radius–charge generating field

Define the formal Laurent series

[
\mathcal C(q,u,z)

\sum_w\sum_{r\in\mathbb Z}
\mathbf 1_{\mathsf C(w,r)}
q^w u^r z^{\Omega(w+r)}.
]

Only the powers (z) and (z^2) occur.

Therefore the exact oriented prime-pair field is

[
\boxed{
\mathcal P(q,u)

\frac{\mathcal C(q,u,1)-\mathcal C(q,u,-1)}2.
}
]

The conjectures are transverse coefficient statements:

[
\text{Goldbach at center }w
\quad\Longleftrightarrow\quad
[q^w]\mathcal P(q,1)>0,
]

while

[
\text{twins through center }w
\quad\Longleftrightarrow\quad
[q^wu]\mathcal P(q,u)>0.
]

This means the same operation is missing in both directions:

[
\mathcal C
\quad\xrightarrow{\ (1-\lambda)/2\ }\quad
\mathcal P.
]

Chen proves center coverage and radius-one recurrence before projection. Goldbach and twins demand that those properties survive the odd-charge projection.

⸻

IV. Parity saturation is the exact remaining scalar obstruction

Define the Chen count and signed Chen count in a fixed center fiber:

[
C_G(w)
:=
\sum_r\mathbf 1_{\mathsf C(w,r)},
]

[
L_G(w)
:=
\sum_r
\mathbf 1_{\mathsf C(w,r)}
\lambda(w+r).
]

Let (G(w)) be the oriented exact Goldbach count. Then

[
\boxed{
G(w)=\frac{C_G(w)-L_G(w)}2.
}
]

Since Chen gives (C_G(w)>0) for every sufficiently large (w),

[
\boxed{
\text{Goldbach at }2w
\iff
L_G(w)<C_G(w).
}
]

A Goldbach counterexample would therefore be a center fiber in which every available Chen witness has charge two:

[
L_G(w)=C_G(w).
]

For the radius-one slice, define

[
C_T(X)
:=
\sum_{w\le X}\mathbf 1_{\mathsf C(w,1)},
]

[
L_T(X)
:=
\sum_{w\le X}
\mathbf 1_{\mathsf C(w,1)}
\lambda(w+1).
]

Then the twin count is

[
\boxed{
T(X)=\frac{C_T(X)-L_T(X)}2.
}
]

Consequently,

[
\boxed{
\text{twin recurrence}
\iff
C_T(X)-L_T(X)\longrightarrow\infty.
}
]

If twins were finite, while the quantitative Chen count tends to infinity, then necessarily

[
\boxed{
\frac{L_T(X)}{C_T(X)}\longrightarrow1.
}
]

So a world with finitely many twins is not an amorphous failure. It is forced into asymptotic even-charge saturation inside the exact radius-one Chen field.

A genuine quantitative finish would be an independently obtained estimate such as

[
L_T(X)\le(1-\delta)C_T(X)
]

for some fixed (\delta>0). It would imply

[
T(X)\ge\frac{\delta}{2}C_T(X)\to\infty.
]

The complete identities and anti-saturation specification are in Theorems 62–63 and 73.

⸻

V. Why Maynard's theorem does not already select radius one

Let (H\subset\mathbb Z) be a finite admissible tuple and define

[
x_h(n)=\mathbf 1_{\operatorname{Prime}(n+h)}.
]

Let

[
S_H(n)=\sum_{h\in H}x_h(n)
]

be the number of occupied prime positions. For each (d>0), let

[
E_{H,d}(n)

\sum_{h,h+d\in H}x_h(n)x_{h+d}(n)
]

count prime pairs at exact difference (d).

Define

[
Q_{H,n}(\theta)

\sum_{h\in H}x_h(n)e^{ih\theta}.
]

Theorem 50 — Exact angular decomposition

[
\boxed{
\binom{S_H(n)}2

\sum_{d>0}E_{H,d}(n)
}
]

and

[
\boxed{
|Q_{H,n}(\theta)|^2

S_H(n)
+
2\sum_{d>0}E_{H,d}(n)\cos(d\theta).
}
]

Thus Maynard's conclusion that at least two tuple positions are prime gives positive total pair energy:

[
\sum_dE_{H,d}>0.
]

But twins require the single Fourier channel

[
E_{H,2}>0.
]

This is exactly the angular-resolution problem.

More strongly, let (G_d(H)) join positions separated by (d). Every (m)-point occupancy forces a (d)-pair exactly when

[
m>\alpha(G_d(H)),
]

where (\alpha) is the independence number.

Because (G_d(H)) is a union of paths,

[
\alpha(G_d(H))
\ge
\left\lceil\frac{|H|}{2}\right\rceil.
]

Therefore a low-occupancy conclusion such as "at least two primes among fifty shifts" cannot combinatorially force any prescribed gap.

The bounded-gap face contains exact charge but only aggregate angular energy.

The Chen face contains the exact angular channel but only a two-charge envelope.

That is the precise complementarity.

⸻

VI. Local singular-series data cannot rank every radius toward one

For gap (2r), the prime-pair singular series is

[
\mathfrak S(2r)

2C_2
\prod_{\substack{p\mid r\p>2}}
\frac{p-1}{p-2}.
]

Theorem 54 — Radical degeneracy

The value (\mathfrak S(2r)):

* depends only on the odd square-free radical of (r);
* satisfies
    [
    \mathfrak S(2r)\ge\mathfrak S(2);
    ]
* equals the twin value whenever
    [
    r=1,2,4,8,\ldots.
    ]

Therefore no radius ranking depending only on the singular series can have radius one as its unique minimum.

Local Hardy–Littlewood density does not produce the transfer Lyapunov function required by Factory III. It cannot even distinguish the twin radius from every power-of-two radius.

⸻

VII. The recurrent-radius set is far larger than one unknown seed

Let

[
\mathcal R_\infty

{r:C_r\text{ is unbounded}}.
]

Huang and Wu proved that the set (D=2\mathcal R_\infty) of infinitely recurring prime differences is a (\Delta_{721}^{*})-set: it intersects the difference set of every (721)-element subset of (\mathbb N). (arXiv)

Applying their theorem to doubled sets gives:

Theorem 55 — Radius recurrence is (\Delta_{721}^{*})

For every (721)-element set (A), there exist (a<b) in (A) such that

[
b-a\in\mathcal R_\infty.
]

In particular, for every (m\ge1), some

[
jm,\qquad1\le j\le720,
]

is a recurrent radius.

This yields a second compiler.

If a certified transfer basin (B) contains

[
\Delta(A)
]

for one (721)-point configuration (A), then some recurrent radius lies in (B); if every radius in (B) transfers to one, twins follow.

But largeness alone is insufficient. The set (m\mathbb N) is syndetic and (\Delta_{m+1}^{*}), yet omits (1). A descent or purification law remains necessary.

⸻

VIII. The rough Chen boundary is genuinely bilinear

Green and Tao use a quantitative Chen set in which (p+2) is prime or

[
p+2=ab
]

with both prime factors satisfying

[
a,b>p^{3/11}.
]

They quote (\gg N/\log^2N) such primes in ((N/2,N]), and prove (\gg N^2/\log^6N) three-term arithmetic progressions of Chen primes. (arXiv)

If twins were finite, then for all sufficiently large scales almost all of this Chen mass would lie in the semiprime branch. Yet every such (p+2) would pass all divisibility tests by primes

[
\ell\le p^{3/11}.
]

The charge-two information would reside entirely in the unresolved bilinear tail.

Even more concretely, infinitely many Chen progressions would have

[
p_i+2=a_ib_i
]

for (i=1,2,3), with

[
p_1+p_3=2p_2.
]

Substitution yields

[
\boxed{
a_1b_1+a_3b_3=2a_2b_2,
}
]

while every

[
a_ib_i-2
]

is prime.

So under twin failure, the boundary generates an exact additive relation among three bilinear prime products. That is a real next object, not a renamed obstruction.

⸻

IX. The newest factorization-defect coordinate

For (n) in the prime-or-semiprime envelope, define

[
\sigma(n)

\begin{cases}
0,&n\text{ prime},\[1mm]
\dfrac{\log a}{\log n},
&n=ab,\quad a\le b,\quad a,b\text{ prime}.
\end{cases}
]

Then semiprimes occupy

[
0<\sigma\le\frac12,
]

while exact primes have (\sigma=0).

If

[
a\le b^\alpha,
]

then

[
\boxed{
\sigma(n)\le\frac{\alpha}{1+\alpha}.
}
]

A very recent Li–Liu preprint claims unconditionally:

* every sufficiently large even (N) has a representation
    [
    N=p+rq,\qquad r\le q^{0.9},
    ]
    corresponding to
    [
    \sigma\le\frac9{19};
    ]
* infinitely many primes (p) satisfy
    [
    p+2=rq,\qquad r\le q^{0.75},
    ]
    corresponding to
    [
    \sigma\le\frac37.
    ]

The manuscript is an August 2026 arXiv preprint and should be treated as a current frontier claim pending ordinary scrutiny, not yet as settled inherited literature. (arXiv)

This is genuine movement toward the prime face:

[
\frac12
\longrightarrow
\frac9{19}
\quad\text{and}\quad
\frac12
\longrightarrow
\frac37.
]

But it does not cross the discrete charge boundary.

Indeed:

Theorem 68 — Continuous near-primality does not isolate primes

[
\boxed{
\inf_{\Omega(n)=2}\sigma(n)=0.
}
]

Take (n=2q) with (q) prime:

[
\sigma(2q)

\frac{\log2}{\log(2q)}
\to0.
]

Thus semiprimes can approach the prime face arbitrarily closely in this continuous coordinate. Even a sequence of improving exponent theorems need not produce an exact prime unless the descent contains additional structure forcing attainment, not merely convergence.

The charge/parity coordinate remains indispensable.

⸻

X. The mixed radius–charge compiler

Let

[
e=\Omega-1\in{0,1}.
]

The state space is

[
V_R

{1,\ldots,R}\times{0,1}.
]

Interpret:

[
(r,0)

\text{an exact prime pair at radius }r,
]

[
(r,1)

\text{a prime–semiprime pair at radius }r.
]

The target is

[
(1,0).
]

Define the rank

[
\boxed{
\kappa(r,e)=2(r-1)+e.
}
]

Its unique zero is ((1,0)).

Theorem 70 — Mixed-corner descent

Suppose a cofinal witness family begins at some state (v_0), and every reachable non-target state has a bounded proof-carrying transition

[
v\to v'
]

such that:

[
\kappa(v')<\kappa(v),
]

and the center strictly increases.

Then twin primes are infinite.

Proof

Starting beyond an arbitrary center bound, follow transitions. The center remains beyond the input bound, while the natural-number rank strictly decreases. The process terminates at its unique rank-zero state ((1,0)). ∎

This is strictly weaker than exact radius descent.

Factory III allowed only

[
(r,0)\to(s,0),
\qquad s<r.
]

The mixed compiler permits

[
(r,0)\to(r-1,1).
]

It may trade one unit of factorization charge for one unit of radius progress, then eventually purify through

[
(1,1)\to(1,0).
]

That matters. It allows the Maynard and Chen techniques to interact without demanding that every intermediate theorem preserve exact primality on both legs.

The rank, seed interfaces, and canonical consequence map

[
BG_R\times\Theta_{\mathrm{corner}}(R)
\longrightarrow
T_{\mathrm{gen}}
]

are formalized in Theorems 70–71.

⸻

XI. The projectors commute; the information does not

Let (P_r) extract radius one and (P_c) extract charge one.

Then

[
\boxed{
P_rP_c=P_cP_r.
}
]

So the hard corner is not caused by operator noncommutation.

Yet the two known statements

[
\sum_{r\le123}P_c\mathcal C
\quad\text{is recurrent}
]

and

[
P_r(P_{c=1}+P_{c=2})\mathcal C
\quad\text{is recurrent}
]

do not imply

[
P_rP_c\mathcal C
\quad\text{is recurrent}.
]

A nonnegative field may place all exact-prime mass at radius two and all radius-one mass at charge two.

Therefore the true problem is:

[
\boxed{
\text{a marginal-to-joint lower-bound problem}.
}
]

The missing theorem must create positive dependence between the favorable radius and charge events, transport mass from one face to the other, or cancel the even-charge saturation.

⸻

XII. The closest current (\Theta)-component

Define

[
\Theta_{\mathrm{Chen}}

\Big(
\mathsf C,;
\text{center/radius projections},;
\text{charge grading},;
\text{Liouville involution},;
\text{odd-charge projector},;
\text{anti-saturation proofs}
\Big).
]

The first five components now exist exactly.

The open arithmetic component is:

[
\boxed{
L_G(w)<C_G(w)
\quad\text{for every large center},
}
]

and

[
\boxed{
C_T(X)-L_T(X)\to\infty
\quad\text{on the radius-one slice}.
}
]

These are Goldbach and twins as two transverse anti-saturation laws of the same completed field.

The next theorem should therefore be one of four things:

[
\boxed{
\begin{aligned}
&\text{an angular estimate extracting }d=2\text{ from Maynard pair energy};\
&\text{a Chen-conditioned Liouville cancellation theorem};\
&\text{a bounded mixed edge }(r,0)\to(s,1)\text{ or }(1,1)\to(1,0);\
&\text{a difference-rich transfer basin forced to contain a recurrent radius}.
\end{aligned}
}
]

This is now one exact field, two exact projections, two already inhabited faces, and one missing corner.

The Braid has not finished the theorem.

But it has produced a substantially sharper place at which the theorem must be born.
