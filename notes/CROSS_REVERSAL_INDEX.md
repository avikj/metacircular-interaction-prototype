# The cross-reversal index of a nonreciprocal decic

## 0. Status

This note isolates the first exact invariant that appears when the reciprocal
degree-ten argument is rotated to the nonreciprocal sector. It is a structural
identity, not a factor exclusion:

\[
  \operatorname{Res}(q,q^*)=q(1)q(-1)L^2. \tag{0.1}
\]

The integer \(L\) is a half-degree trace resultant measuring the residual
collision between \(q\) and its reversal. The prime-prefix parity resultant
does not presently control it; the exact witness in §5 has \(L=-7\).

*Integration cross-reference:* the reciprocal-sector argument being rotated
here — the all-degree coefficient cage plus residual norm-unit equation — is
compiled in `RECIPROCAL_TRACE_CAGE.md`.

## 1. Normalizations and trace data

Let

\[
 q=x^{10}+a x^9+b x^8+c x^7+d x^6+e x^5
      +f x^4+h x^3+i x^2+jx+1\in\mathbb Z[x]. \tag{1.1}
\]

The constant \(+1\) is load-bearing. An arbitrary monic unit decic could have
constant \(-1\); in the prime-prefix frontier it is \(+1\) because a totally
nonreal decic has \(q(0)=\prod_{r=1}^{5}|\alpha_r|^2>0\).

Write

\[
 q^*(x)=x^{10}q(x^{-1}),\qquad
 S=\frac{q+q^*}{2},\qquad D=q-q^*. \tag{1.2}
\]

The anti-reciprocal \(D\) vanishes at \(0,1,-1\), so uniquely

\[
 D=x(x^2-1)R, \tag{1.3}
\]

where \(R\in\mathbb Z[x]\) is reciprocal of formal degree six. With
\(T=x+x^{-1}\), there are unique

\[
 S=x^5H(T),\qquad R=x^3K(T), \tag{1.4}
\]

where \(H\in\tfrac12\mathbb Z[T]\) is monic of degree five and
\(K\in\mathbb Z[T]\) has degree at most three.

Put

\[
 p=\frac{a+j}{2},\quad q_2=\frac{b+i}{2},\quad
 q_3=\frac{c+h}{2},\quad q_4=\frac{d+f}{2}.
\]

Then

\[
\begin{aligned}
H(T)={}&T^5+pT^4+(q_2-5)T^3+(q_3-4p)T^2\\
&+(q_4-3q_2+5)T+(e-2q_3+2p). \tag{1.5}
\end{aligned}
\]

For

\[
 u=a-j,\quad v=b-i,\quad w=c-h+a-j,\quad z=d-f+b-i,
\]

one has

\[
 K(T)=uT^3+vT^2+(w-3u)T+(z-2v). \tag{1.6}
\]

## 2. The square-index theorem

**Theorem 2.1.** Under the normalization above, assume that \(q\) is
nonreciprocal, so \(K\ne0\). Then

\[
 \boxed{\operatorname{Res}_x(q,q^*)
 =q(1)q(-1)\operatorname{Res}_T(H,K)^2.} \tag{2.1}
\]

Moreover

\[
 L:=\operatorname{Res}_T(H,K)\in\mathbb Z. \tag{2.2}
\]

If \(q\) is irreducible and nonreciprocal, then \(L\ne0\).

**Proof.** At a root of \(q\), equation (1.3) gives \(q^*=-D\). Since
\(\deg q=10\) is even,

\[
\begin{aligned}
\operatorname{Res}(q,q^*)
 &=\operatorname{Res}(q,D)\\
 &=\operatorname{Res}(q,x)\operatorname{Res}(q,x^2-1)
   \operatorname{Res}(q,R)\\
 &=q(1)q(-1)\operatorname{Res}(q,R). \tag{2.3}
\end{aligned}
\]

Here \(\operatorname{Res}(q,x)=q(0)=1\). Since \(q-S=D/2\) is a
multiple of \(R\) over \(\mathbb Q[x]\),

\[
 \operatorname{Res}(q,R)=\operatorname{Res}(S,R). \tag{2.4}
\]

Pairing \(x,x^{-1}\) above every root of \(K(T)\) gives the reciprocal
trace identity

\[
 \operatorname{Res}_x(S,R)=\operatorname{Res}_T(H,K)^2. \tag{2.5}
\]

If \(m=\deg K<3\), then
\(R=x^{3-m}[x^mK(T)]\). The unused factor contributes
\(\operatorname{Res}(S,x)^{3-m}=S(0)^{3-m}=1\), so no degree correction
occurs.

It remains to prove that the half-integral trace resultant is integral. Put
\(h=2H\in\mathbb Z[T]\). Modulo two,

\[
 x^5h(T)=q+q^*\equiv q-q^*
 =x^4(x^2+1)K(T)=x^5TK(T).
\]

The Laurent embedding is injective, hence \(h\equiv TK\pmod2\) and

\[
 J:=\frac{h-TK}{2}\in\mathbb Z[T]. \tag{2.6}
\]

Since \(\deg(TK)\le4\), the polynomial \(J\) is monic of degree five, the
same degree as \(H\). For \(m=\deg K\), reduction modulo \(K\) and scaling
therefore give

\[
 \operatorname{Res}(h,K)=2^m\operatorname{Res}(J,K)
 =2^m\operatorname{Res}(H,K).
\]

Thus \(L=\operatorname{Res}(J,K)\in\mathbb Z\). If an irreducible
nonreciprocal \(q\) had \(L=0\), then \(q\) and \(q^*\) would share a root,
forcing the equal-degree monic irreducibles to be equal. \(\square\)

## 3. Index interpretation

For irreducible nonreciprocal \(q\), the ring
\(A_q=\mathbb Z[x]/(q)\) is free of rank ten.
Multiplication by the class of \(q^*\) has determinant
\(\operatorname{Res}(q,q^*)\). Therefore

\[
 [A_q:q^*A_q]=|q(1)q(-1)|L^2. \tag{3.1}
\]

The endpoint factors are the two fixed-point contributions of reversal;
\(L^2\) is the residual square factor in this lattice index. No separate
lattice whose index is \(L^2\) is asserted.

## 4. Prime-support restrictions

For

\[
 F_X(x)=1+\sum_{3\le p\le X}x^{p-2},
\]

a divisor \(q\mid F_X\) satisfies

\[
 q(1)\mid\pi(X),\qquad q(-1)\mid2-\pi(X), \tag{4.1}
\]

and hence

\[
 \gcd(q(1),q(-1))\mid2. \tag{4.2}
\]

The parity unit gives the same local conclusion: if
\(q=E(x^2)+xO(x^2)\) and \(\operatorname{Res}(E,O)=\pm1\), then
\(\gcd(E(1),O(1))=1\), while \(q(\pm1)=E(1)\pm O(1)\).

Equations (4.1)--(4.2) tether the nonsquare part of (2.1) to adjacent prime
counts. Prime support gives substantially more than the endpoints.

Let \(N=\max\{p\le X\}-2\). Then

\[
 F_X=1+\sum_{\substack{1\le j\le N\\j\ {\rm odd}}}\epsilon_jx^j,
 \qquad \epsilon_j\in\{0,1\},\quad\epsilon_N=1.
\]

Every root \(z\) of \(F_X\) obeys the strict cage

\[
 \boxed{\varphi^{-1}<|z|<\sqrt2.} \tag{4.3}
\]

For the inner bound, \(r\le\varphi^{-1}\) would give

\[
 1\le\sum_{j\in\operatorname{supp}(F_X)\setminus\{0\}}r^j
 \le\sum_{\substack{1\le j\le N\\j\ {\rm odd}}}r^j
 <\sum_{\substack{j\ge1\\j\ {\rm odd}}}r^j
 =\frac r{1-r^2}\le1.
\]

For the outer bound, the leading term gives
\(r^N\le1+\sum_{j\le N-2,\ j\ {\rm odd}}r^j\). After division by \(r^N\),
the right side decreases in \(r\), and at \(r=\sqrt2\), with \(N=2m+1\),
it is

\[
 1-2^{-m}(1-2^{-1/2})<1,
\]

a contradiction.

For a totally nonreal decic factor, write the five conjugate-pair radii as
\(r_1,\ldots,r_5\). They lie in (4.3) and have product one. The closed
log-radius polytope has one vertex orbit

\[
 (A,A,B,B,C),\qquad
 A=\sqrt2,\quad B=\varphi^{-1},\quad C=\frac{\varphi^2}{2}. \tag{4.4}
\]

Indeed four coordinates are at bounds, and only two upper plus two lower
coordinates leave a feasible compensator. Convexity of
\(\sum_i\log(1+e^{x_i})\) then gives

\[
 1\le q(1),q(-1)\le1241. \tag{4.5}
\]

There is also a uniform cross-index bound. For a conjugate pair
\(\alpha,\bar\alpha\) of radius \(r\), its ordered self-block in
\(\prod_{u,v}(1-uv)\) is at most

\[
 |1-\alpha^2|^2|1-r^2|^2\le(1-r^4)^2<9.
\]

For two distinct pairs \(i<j\), the ordered cross-block is at most
\((1+r_ir_j)^8\). The logarithm of the product of cross-block bounds is
again symmetric convex, hence maximized at (4.4). At least one \(r_i\le1\);
for that pair

\[
 (1-r_i^4)^2<(1-B^4)^2
 =\frac{35-15\sqrt5}{2}<\frac34.
\]

Exact rational enclosures of \(A,B,C\) at the vertex now give

\[
 0<|\operatorname{Res}(q,q^*)|<6\cdot10^{28},
 \qquad \boxed{|L|<2.5\cdot10^{14}.} \tag{4.6}
\]

This is a uniform finite target, not an exclusion. It is sharp only at the
level of the stated radius/triangle relaxation.

Finally, if \(F_X=qg\), multiplicativity of resultants yields

\[
 L^2\mid\operatorname{Res}(F_X,F_X^*). \tag{4.7}
\]

For an odd prime \(\ell\mid L\) not dividing \(q(1)q(-1)\), the polynomial
\(\gcd(F_X,F_X^*)\) modulo \(\ell\) has degree at least two: the common
reciprocal roots are not \(\pm1\). This gives a tiny candidate-specific
modular collision test after factoring \(L\).

## 5. A support-compatible nonunit cross index

Consider

\[
 q_1=x^{10}+x^8+x^2+x+1. \tag{5.1}
\]

It is irreducible, totally nonreal, nonreciprocal, satisfies the parity unit,
and all its roots lie in \(4/5<|z|<6/5\), so it survives the sharp support
cage. These statements are independently certified in
*NONRECIPROCAL_DECIC_FRONTIER.md*. Its trace data are

\[
\begin{aligned}
H_1&=T^5+\tfrac12T^4-4T^3-2T^2+2T+1,\\
K_1&=-T^3+2T.
\end{aligned}
\]

Exact determinants give

\[
 \operatorname{Res}(H_1,K_1)=-7.
\]

This last identity is immediate from
\(K_1=-T(T^2-2)\), \(H_1(0)=1\), and
\(H_1(\pm\sqrt2)=-1\mp2\sqrt2\). Since
\(q_1(1)=5\) and \(q_1(-1)=3\),

\[
 \operatorname{Res}(q_1,q_1^*)=5\cdot3\cdot7^2=735. \tag{5.2}
\]

Thus even parity unit, irreducibility, total nonreality, and the full sharp
support cage do not force \(L\) to be a unit. If \(q_1\mid F_X\), the endpoint
conditions would first require

\[
 \pi(X)\equiv5\pmod {15}. \tag{5.3}
\]

Modulo seven,
\(\gcd(q_1,q_1')=1\) but
\(\gcd(q_1,q_1^*)=x^2+4x+1\). Therefore \(7\mid L\) records a reciprocal
collision, not discriminant ramification. The witness is not claimed to
divide any \(F_X\).

## 6. Why support is load-bearing

The local algebraic package alone does not even bound \(L\). For every
positive multiple \(n\) of seven, set

\[
 Q_n=x^{10}+n^2x^8+x^2+x+1. \tag{6.1}
\]

This polynomial is positive on \(\mathbb R\), nonreciprocal, and has

\[
 E=y^5+n^2y^4+y+1,\qquad O=1,
\]

so \(\operatorname{Res}(E,O)=1\). Its endpoint values \(n^2+4,n^2+2\)
have gcd at most two. Reduction modulo seven is the fixed polynomial
\(x^{10}+x^2+x+1\), which passes Rabin's degree-ten irreducibility
criterion; hence every \(Q_n\) is irreducible over \(\mathbb Z\).

Writing \(v=n^2\), exact elimination gives

\[
 L(v)=1+3v-22v^2+14v^3-2v^4-4v^5+4v^6-v^7. \tag{6.2}
\]

Thus \(|L(n^2)|\sim n^{14}\) is unbounded under irreducibility, total
nonreality, nonreciprocity, parity unit, and endpoint compatibility. Every
member of this family is killed by (4.3): Newton's identity gives
\(\sum\alpha_i^2=-2n^2\), whereas \(|\alpha_i|<\sqrt2\) would force
\(|\sum\alpha_i^2|<20\). The finite bound (4.6) therefore comes from sparse
support geometry, not the local resultant algebra.

## 7. Rigor and novelty boundary

Proved here are the integral trace decomposition, square factorization,
nonvanishing for irreducible nonreciprocal \(q\), the endpoint/index
interpretations, the sharp support cage, and the finite bounds and modular
collision condition (4.5)--(4.7). Not proved are a unit law or sufficiently
strong divisibility restriction on \(L\), or a nonreciprocal degree-ten
exclusion.

Reversal resultants, trace substitutions, and resultant-as-index
interpretations are standard algebraic tools. No targeted literature search
for this exact packaging has been recorded, so this note makes no novelty
claim. Its project-specific value is to turn “nonreciprocal” from the absence
of symmetry into one explicit half-degree integer target.
