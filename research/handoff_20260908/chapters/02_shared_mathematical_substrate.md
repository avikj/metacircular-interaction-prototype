# Part II. Shared source, fibre, history, and kernel calculus

## 7. The whole diagram is the object

The old comprehensive handoff [S00] repeatedly corrects the same error: the object is not just a carrier plus an evocative action. It is

\[
(\text{carrier},\text{maps},\text{source image},\text{fibres},\text{actions},\text{required diagrams}).
\]

Two constructions can have the same fibre and the same point motion while failing for different reasons. A right-inverse obstruction, a nontrivial loop transport, a failure of an observable to descend, a negative quadratic form, and a nonclosed limiting image are different assertions. Exhibit an adapter before identifying their obstruction values.

For \(f:A\to B\), the canonical proof-relevant completion is

\[
A\simeq\sum_{b:B}\operatorname{fib}_f(b),\qquad
\operatorname{fib}_f(b)=\sum_{a:A}(f(a)=b).
\]

Its inverse returns the stored source. The repository's `Ekatva`/`Fibre.LawfulStep` work identifies the canonical lossless completion and the exact equation connecting the visible projection to the declared transition. A random equivalence with the same cardinality is not that completion.

For a source-dependent property \(P:A\to\mathcal U\), transport the full dependent family, not merely the Boolean answer that a witness exists. In particular, finite compatible observations do not automatically provide an admissible infinite source. The source image can be a strict subset of its completion.

## 8. The complete fibre of a quadratic diagonal

This was an important early correction in the conversation and remains load-bearing throughout NS.

Let \(Q:V\to W\) be the diagonal of a bilinear map over a real vector space. Define

\[
S_Q(x,y)=\frac{Q(x+y)-Q(x)-Q(y)}2.
\]

Then \(S_Q\) is symmetric bilinear, \(S_Q(x,x)=Q(x)\), and every bilinear realization is uniquely

\[
\boxed{b=S_Q+a,\qquad a(x,y)=-a(y,x).}
\]

Proof: expanding \(Q(x+y)\) gives \(S_Q=(b+b^{op})/2\). If two realizations have the same diagonal, their difference has zero diagonal; polarization makes it alternating. Conversely an alternating addition does not change the diagonal.

Thus the realization fibre is an affine space modelled on \(\operatorname{Hom}(\Lambda^2V,W)\). This is algebraic; it does not say every realization preserves an independently specified interface or norm.

For \(V=W\), the frozen action \(A_x(y)=b(x,y)\) is not determined by the autonomous field. At \(x_0\ne0\), any linear \(G\) with \(Gx_0=0\) can be added to that frozen action: choose \(\ell(x_0)=1\) and put

\[
a(x,y)=\ell(x)Gy-\ell(y)Gx.
\]

Then \(a(x_0,y)=Gy\) while \(a(x,x)=0\). In finite dimensions this can change the off-source spectrum arbitrarily on a complement of \(x_0\).

The actual derivative is invariant:

\[
DQ(x)y=b(x,y)+b(y,x)=2S_Q(x,y).
\]

For \(F(x)=Lx+Q(x)\), \(DF(x)=L+2S_Q(x,-)\).

### 8.1 Exact midpoint secant

For a quadratic nonlinearity,

\[
\boxed{Q(a+b)-Q(a)=DQ(a+b/2)b.}
\]

With a linear part this becomes

\[
F(a+b)-F(a)=[L+DQ(a+b/2)]b.
\]

Freezing at \(a\) loses \(Q(b)\); freezing at \(a+b\) doubles it. The midpoint is forced by the exact polynomial identity, not chosen as a model. This is the key later nonlinear-memory representation [S19].

### 8.2 Coherent variations at every order

For a differentiable family of actual classical solutions and a nonempty finite label set \(I\), write \(U_I\) for the mixed parameter derivative and \(u=U_\varnothing\). Then

\[
\boxed{
\partial_tU_I=[L+2S_Q(u,-)]U_I+
\sum_{\varnothing\ne J\subsetneq I}S_Q(U_J,U_{I\setminus J}).
}
\]

For an affine initial family, first derivatives have the prescribed initial directions and higher mixed derivatives start at zero. Every occurrence of the same source is differentiated. No alternating choice of bilinear representation changes the hierarchy. The formula organizes complete labelled binary histories; it does not assert convergence of an infinite Taylor series beyond the shared classical interval.

## 9. A concrete Beltrami regression control

For smooth divergence-free fields,

\[
N(u)=\mathbb P(u\times\operatorname{curl}u),
\quad A_uv=\mathbb P(u\times\operatorname{curl}v),
\quad K_uv=\mathbb P(v\times\operatorname{curl}u).
\]

Both frozen operators reproduce the same source trajectory: \(A_uu=K_uu=N(u)\). The derivative is their sum:

\[
DN(u)v=A_uv+K_uv
=-\mathbb P((u\cdot\nabla)v+(v\cdot\nabla)u).
\]

On the \(2\pi\)-torus let \(E_\lambda=\{u:\operatorname{curl}u=\lambda u\}\). For \(u,v\in E_\lambda\),

\[
A_uv=\lambda\mathbb P(u\times v),\qquad
K_uv=-\lambda\mathbb P(u\times v),\qquad DN(u)v=0.
\]

The exact solution family is \(u_\varepsilon(t)=e^{-\nu\lambda^2t}(u+\varepsilon v)\). Its actual variation stays in the same eigenspace.

For \(p=e_1,q=e_2\), choose positive-helicity vectors

\[
h_p=(0,1,i)/\sqrt2,\qquad h_q=(-1,0,i)/\sqrt2.
\]

Their cross product at \(k=p+q\) is \((i,-i,1)/2\), transverse to \(k\), and its negative-helicity projection is nonzero:

\[
\Pi_-(k)(h_p\times h_q)
=\frac14\bigl(i(1-1/\sqrt2),-i(1-1/\sqrt2),1-\sqrt2\bigr).
\]

Thus a single frozen factor can exhibit opposite-helicity leakage that the actual common-source derivative cancels exactly. Add conjugate negative modes for real fields. This control does not assert invariance of the full one-helicity space under unrestricted NS; it concerns one fixed curl eigenspace.

## 10. Compatible CRT histories are not independent products

Let

\[
C_m=\operatorname{lcm}(1,\ldots,m),\quad C_0=1,\quad
O_m=\mathbb Z/C_m\mathbb Z,
\]

and \(r_m:O_{m+1}\to O_m\) be reduction. On \(P_n=\prod_{m<n}O_m\), define

\[
(\Delta_nx)_m=x_m-r_m(x_{m+1}).
\]

The endpoint-plus-defect map

\[
x\longmapsto\left(x_{n-1},\Delta_nx\right)
\]

is a group isomorphism

\[
P_n\simeq O_{n-1}\times\prod_{m<n-1}O_m.
\]

Its inverse descends recursively: \(x_{n-1}=a\), \(x_m=e_m+r_m(x_{m+1})\). Therefore

\[
|P_n|=\prod_{m<n}C_m,\qquad
|\ker\Delta_n|=C_{n-1}.
\]

For capacities \((1,1,2,6)\), there are 12 arbitrary records but only 6 compatible histories. The earlier DMR elementary product identity remains true as an ambient cardinality identity; interpreting that product as coherent observations of one integer was false.

Uniform endpoint measure makes every marginal uniform, but its joint entropy is \(\log C_{n-1}\), not \(\sum_{m<n}\log C_m\). Its relative entropy against the independent product with the same marginals is their difference.

The inverse limit is \(\widehat{\mathbb Z}\), not the embedded image of \(\mathbb Z\). For \(C_m=2^{a_m}b_m\) with \(b_m\) odd, take the CRT solution

\[
x_m=0\pmod{2^{a_m}},\qquad x_m=1\pmod{b_m}.
\]

All finite prefixes are realized by integers and all overlaps agree. No single integer realizes the whole history: divisibility by every power of two forces zero, contradicting the mod-three condition. This is an explicit empty original-source fibre despite perfect finite compatibility.

For a weak-star compact class of positive measures with fixed mass, a different compactness theorem can still supply a global object. The compact admissible class is the hypothesis; do not transport that conclusion to smooth NS histories merely by using the same words “inverse limit.”

## 11. Return algebra, exact quotients, and history dependence

For a linear evolution \(T\) with complementary projections \(P,Q\),

\[
(PTP)^2-PT^2P=-PTQTP.
\]

The correct invisible subspace is

\[
N_{obs}=\bigcap_{n\ge0}\ker(PT^n),
\]

not \(\ker P\). The repository's `ObservabilityQuotient` proves forward invariance of future equality and supplies a finite three-state separator for instantaneous equality versus future equality. Its current code points to stronger maximality results elsewhere; read those instead of treating the early header as a permanent limit.

The saved Delta 19 [S25] gives

\[
F_1=PTP,\quad F_m=PTQ(QTQ)^{m-2}QTP\ (m\ge2),
\]
\[
K_n=\sum_{m=1}^nF_mK_{n-m},\qquad K(z)=(I-F(z))^{-1},
\]

and the Schur complement

\[
P(\lambda I-T)^{-1}P
=[\lambda I-A-B(\lambda I-D)^{-1}C]^{-1}.
\]

These are exact algebraic identities, formal or analytic on the stated resolvent domain. A linear semigroup formula does not become an exact nonlinear source reduction without an actual nonlinear lift or secant construction. The later chapters supply both.

## 12. General two-metric algebra

Let \(J=J^*=J^{-1}\) and \(T\) be bounded invertible with \(T^*JT=J\). Then

\[
C=T^*T=JT^{-1}JT>0,\qquad JCJ=C^{-1}.
\]

Consequently \(A=\tfrac12\log C\) is self-adjoint and anti-commutes with \(J\). Along a differentiable path with generator \(G=T'T^{-1}\),

\[
G^*J+JG=0,
\quad
G=\begin{pmatrix}K_+&B\\B^*&K_-\end{pmatrix},
\quad K_\pm^*=-K_\pm.
\]

Thus

\[
\operatorname{Sym}G=\begin{pmatrix}0&B\\B^*&0\end{pmatrix},
\quad \|\operatorname{Sym}G\|=\|B\|,
\]
\[
\frac12\frac d{dt}\|x\|^2=2\Re\langle x_+,Bx_-\rangle.
\]

For a path starting at the identity, with integrable bounded symmetric part,

\[
\frac12\|\log(T^*T)\|\le\int\|B(t)\|dt.
\]

The reciprocal cycle \(JTJT^{-1}\) equals \((T^*T)^{-1}\). The research alternated orientations; compare formulas using the actual definition, not just the word “holonomy.”

A zero coboundary and a zero cohomology class differ. If \(b(g,x)=F(gx)-F(x)\), it is a coboundary for every \(F\), so its class is always zero. Descent requires \(b\) itself to vanish. Separately, an additive character \(n\mapsto nA\) for a trivial group action is a genuine degree-one cocycle whose class vanishes iff \(A=0\). These are different coefficient/action diagrams.

On a set/0-type base, all identity loops are trivial. Multiple fibre elements do not by themselves create monodromy. A nontrivial automorphism cycle lives in the declared groupoid/universe/transport diagram, not in the bare set of roots.
