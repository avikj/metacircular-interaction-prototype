# Exact classification of septic factors

For

$$
F_X(x)=\sum_{p\le X}x^{p-2},
$$

the exact certificate `code/exp33_septic_certificate.py` proves:

$$
\boxed{F_X\text{ has an irreducible degree-seven factor iff }11\le X<13.}
$$

The factor is

$$
H_7(x)=x^7+x^6-x^4+x^2+2x+1,
$$

and

$$
F_{11}(x)=(x^2-x+1)H_7(x)=\Phi_6(x)H_7(x).
$$

## Structural reduction

Every $F_X$ has exactly one real zero, which is negative.  Therefore an
irreducible odd-degree factor must own that zero.  Write it as $-t$ and a
putative monic septic as

$$
g=x^7+a x^6+b x^5+c x^4+d x^3+e x^2+f x+1.
$$

Its constant is $+1$: the other six roots form conjugate pairs and the
product of all seven roots is negative.  Splitting parity gives

$$
g(x)=E(x^2)+xO(x^2),
$$

$$
E(y)=a y^3+c y^2+e y+1,\qquad
O(y)=y^3+b y^2+d y+f.
$$

As in the even-degree cases, $F_X(x)+F_X(-x)=2$ and resultant
multiplicativity force

$$
\boxed{\operatorname{Res}(E,O)=\pm1.}
$$

The degree condition implies $X\ge11$.  Put

$$
\ell=\frac{309}{500},\qquad u=\frac{79}{125}.
$$

The odd-support triangle inequality gives $t>\varphi^{-1}>\ell$, while the
exact inequality $F_{11}(-u)<0$ and monotonicity give $t<u$.

If the other roots form conjugate pairs of radii $r_1,r_2,r_3$, then

$$
t(r_1r_2r_3)^2=1,qquad \varphi^{-1}<r_i<2.
$$

The coefficient majorant is

$$
(1+t z)\prod_{i=1}^3(1+r_i z)^2.
$$

In logarithmic variables its coefficients are convex on the polytope cut
out by the product relation and the root bounds, so maxima occur at vertices.
There are twelve labelled vertices, two modulo permutation of the radii:
one for each endpoint of the $t$ interval.  At an endpoint the three radii
are

$$
\left\{\varphi^{-1},2,\frac{\varphi}{2\sqrt t}\right\}.
$$

Writing the last radius as $v$, the majorant factors as
$[(1+\varphi^{-1}z)(1+2z)]^2(1+tz)(1+vz)^2$.  The last factor's first two
coefficients are

$$
B_1=\varphi t^{-1/2}+t,
\qquad
B_2=\frac{\varphi^2}{4t}+\varphi\sqrt t;
$$

both decrease on the permitted $t$ interval, while its third coefficient
is $\varphi^2/4$.  Hence every coefficient maximum occurs at the lower
endpoint $t=\varphi^{-1}$, with radius multiset

$$
\left\{\varphi^{-1},2,\frac{\varphi^{3/2}}2\right\}.
$$

The rational majorants $\sqrt5<2.238$, $\varphi<1.619$ and
$\sqrt\varphi<1.273$ give respective elementary-symmetric bounds

$$
7.919,\quad25.720,\quad44.428,\quad44.197,\quad25.400,\quad7.835.
$$

Thus the safe integer box is

$$
|a|,|f|\le7,\qquad |b|,|e|\le25,\qquad |c|,|d|\le44.
$$

## Exact finite reduction

Set

$$
A=c-ab,qquad B=e-ad,qquad C=1-af.
$$

Replacing $E$ by $E-aO=Ay^2+By+C$ expresses the parity resultant as a
cubic norm.  The embedded C++ helper enumerates the coefficient box with
signed 128-bit integer arithmetic.  Python independently recomputes every
surviving resultant by a Bareiss determinant.

The exact reduction is

$$
90{,}893{,}475\ \text{five-tuples}
\longrightarrow21{,}647{,}831\ \text{scalar-window tuples}
\longrightarrow2{,}266\ \text{unit-resultant tuples}
$$

$$
\longrightarrow537\ \text{one-real tuples}
\longrightarrow37\ \text{rational-annulus tuples}.
$$

The last root filter uses exact Cayley--Routh counts in
$|z|<617/1000$ and $|z|<20001/10000$.  It is deliberately a rational
superset of the true annulus.  No numerical roots participate in an
assertion.

## Scalar prefix and tail decisions

For a surviving candidate let

$$
A_q(s)=F_q(-s)=1-\sum_{3\le p\le q}s^{p-2}.
$$

The unique root modulus $t$ is isolated exactly by rational bisection.  If
$A_q(t)<0$, every later prime term makes it still more negative.  If it is
positive, all future prime powers are bounded by the all-odd tail

$$
\frac{t^{p_{\rm next}-2}}{1-t^2}.
$$

Equivalently, define

$$
J_q(s)=(1-s^2)A_q(s)-s^{p_{\rm next}-2}.
$$

The script proves by exact Sturm counts that both $A_q$ and $J_q$ are
strictly decreasing throughout the isolating interval.  Exact resultants
guard every zero decision.  The 37 cases split as follows:

| decision | cutoff | count |
|---|---:|---:|
| tail positive | 11 | 27 |
| tail positive | 13 | 2 |
| tail positive | 19 | 1 |
| already negative | 11 | 1 |
| already negative | 13 | 4 |
| already negative | 23 | 1 |
| exact zero | 11 | 1 |

The sole zero is $H_7$.  It is irreducible by the certificate's complete
degree-at-most-three factor search: every root has modulus below $2$, so all
possible monic integral quadratic and cubic factors lie in the searched
coefficient boxes.  Once the next term $-t^{11}$ is added at $p=13$, the
negative-root value becomes strictly negative, so $H_7$ never recurs.

The minimum exact positive-tail and negative margins are printed as
fractions by the script; their decimal sizes are respectively about
$6.3842\times10^{-5}$ and $3.3410\times10^{-5}$.

## Consequences and prior-art boundary

Together with the degree-two, degree-four, and degree-six obstructions and
the uniqueness of the odd carrier, this implies that $F_{13}$ and $F_{17}$
are irreducible.  At $F_{19}$ the only remaining proper degree partition is
$8+9$.

The finite enumeration, Sturm theory, Routh criterion, and resultant-tail
bound are classical machinery.  Nearby prior art includes Saux Picart and
Brunie--Saux Picart on exact Schur--Cohn algorithms,
Odlyzko--Poonen on zeros of $0,1$ polynomials, and
Drungilas--Jankauskas--Siurys on Newman/Littlewood multiples of Borwein
polynomials.  No novelty claim is made here without a dedicated comparison;
the specialized content is the parity-unit reduction plus the complete
prime-prefix scalar closure.
