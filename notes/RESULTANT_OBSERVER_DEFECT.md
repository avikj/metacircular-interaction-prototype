# The resultant as an observer-defect module

## 0. Result

Two exact constructions give the parity resultant an operational meaning that
is absent from its determinant formula alone.

First, if

\[
g(x)=E(x^2)+xO(x^2),
\]

then the self-fiber product of the root scheme under the observation
\(x\mapsto x^2\) splits into the diagonal and a reflected-collision scheme.
The length of the latter is

\[
2\deg\gcd(E,O).
\]

Thus \(\operatorname{Res}(E,O)\ne0\) says exactly that forgetting the sign of a
root loses no root identity, including scheme-theoretic multiplicity.

Second, for monic \(f\in\mathbb Z[x]\), the finite module

\[
\mathcal D(f,g):=\operatorname{coker}
 \left(m_g:\mathbb Z[x]/(f)\longrightarrow\mathbb Z[x]/(f)\right)
\]

has order \(|\operatorname{Res}(f,g)|\). At a prime \(p\), its number of
independent mod-\(p\) coordinates is

\[
d_p=\deg\gcd(\bar f,\bar g).
\]

The same \(d_p\) is the dimension of the information lost by observing a state
only after multiplication by \(g\), and also the dimension of the modular
cokernel syndrome. The two spaces have equal dimension by rank-nullity; they
are not canonically identical.

For the live decic witness \(q_1\), the already computed integer

\[
\operatorname{Res}(q_1,q_1^*)=735=3\cdot5\cdot7^2
\]

therefore has an exact finite-place reading. The defect dimensions are
\(d_3=1,d_5=1,d_7=2\), and the mod-\(7\) component is precisely the
two-coordinate reciprocal-collision syndrome used by the existing finite
falsifier.

This is a common mathematical lift of the resultant certificates and the
finite observer calculations. It is not a claim that every resultant bound is
an information theorem, nor that modular collision data proves the global
prime-prefix exclusion.

## 1. Reflection collisions as a fiber product

Let \(k\) be a field of characteristic different from \(2\), and let
\(0\ne g\in k[x]\) satisfy \(g(0)\ne0\). Write uniquely

\[
g(x)=E(x^2)+xO(x^2),\qquad E,O\in k[y].                 \tag{1.1}
\]

Put

\[
R_g=\operatorname{Spec}k[x]/(g)
\]

and let \(q:R_g\to\mathbb A^1_k\) be induced by \(y\mapsto x^2\). Its
self-fiber product has coordinate ring

\[
k[x,z]/(g(x),g(z),x^2-z^2).                            \tag{1.2}
\]

Because \(g(0)\ne0\), both \(x\) and \(z\) are units on this fiber product.
The ideals \((z-x)\) and \((z+x)\) are therefore comaximal: their sum contains
\(2x\). The Chinese remainder theorem gives a scheme-theoretic decomposition

\[
\boxed{
R_g\times_{\mathbb A^1}R_g\cong R_g\sqcup C_g,
}\qquad
C_g=\operatorname{Spec}k[x]/(g(x),g(-x)).              \tag{1.3}
\]

The first component is the diagonal. The second records pairs \((r,-r)\) of
roots that the observation \(r\mapsto r^2\) identifies. No squarefree or
reduced hypothesis is being used.

On \(C_g\), \(2\) and \(x\) are units, so (1.1) gives

\[
(g(x),g(-x))=(E(x^2),O(x^2)).                          \tag{1.4}
\]

If \(h=\gcd(E,O)\) is monic, Bézout's identity and substitution show that the
last ideal is \((h(x^2))\). Hence

\[
C_g\cong\operatorname{Spec}k[x]/(h(x^2)),
\qquad
\operatorname{length}_k(C_g)=2\deg h.                 \tag{1.5}
\]

Define

\[
\boxed{\kappa(g):=\tfrac12\operatorname{length}_k(C_g)
                 =\deg\gcd(E,O).}                     \tag{1.6}
\]

This formula is valid over nonsplit fields and includes nonreduced
multiplicity. It follows that \(q\) is a scheme monomorphism, indeed a finite
closed immersion onto its image, exactly when \(\kappa(g)=0\). On geometric
points,

\[
r\longmapsto r^2\text{ is injective on the roots of }g
\quad\Longleftrightarrow\quad
\kappa(g)=0
\quad\Longleftrightarrow\quad
\operatorname{Res}_y(E,O)\ne0.                        \tag{1.7}
\]

For \(\deg g\ge1\), the maximum geometric fiber size of this observer is one
when the resultant is nonzero and two when it vanishes. That set-theoretic
fiber size must not be confused with the scheme length \(2\kappa(g)\).

In the exact setting of `PARITY_RESULTANT.md`, a monic divisor \(g\) of the
prime prefix satisfies

\[
\operatorname{Res}_x(g(x),g(-x))
 =2^{\deg g}\operatorname{Res}_y(E,O)^2,
\qquad
\operatorname{Res}_y(E,O)=\pm1.                       \tag{1.8}
\]

Thus every factor covered by that theorem has \(\kappa(g)=0\): quotienting its
root scheme by reflection creates no off-diagonal collision, even
scheme-theoretically. The unit condition is stronger than nonvanishing and
comes from divisibility into the special prime-prefix polynomial, not from the
fiber-product theorem alone.

## 2. The integral defect module

Let \(f\in\mathbb Z[x]\) be monic of degree \(n\), let

\[
A_f=\mathbb Z[x]/(f),
\]

and let \(m_g:A_f\to A_f\) be multiplication by \(g\in\mathbb Z[x]\).
Monicity makes \(A_f\) free with basis \(1,x,\ldots,x^{n-1}\). With the
convention

\[
\operatorname{Res}(f,g)=\prod_{f(\alpha)=0}g(\alpha),
\]

one has

\[
\det(m_g)=\operatorname{Res}(f,g).                    \tag{2.1}
\]

Consequently, if the resultant is nonzero, then

\[
\boxed{
\mathcal D(f,g):=\operatorname{coker}(m_g)
\text{ is finite and }
|\mathcal D(f,g)|=|\operatorname{Res}(f,g)|.}          \tag{2.2}
\]

For every prime \(p\), right-exact base change gives

\[
\begin{aligned}
\mathcal D(f,g)\otimes\mathbb F_p
 &\cong\operatorname{coker}(m_g\otimes\mathbb F_p)\\
 &\cong\mathbb F_p[x]/(\bar f,\bar g)\\
 &\cong\mathbb F_p[x]/\gcd(\bar f,\bar g).
\end{aligned}                                         \tag{2.3}
\]

Therefore

\[
\boxed{
d_p:=\dim_{\mathbb F_p}
  (\mathcal D(f,g)\otimes\mathbb F_p)
 =\deg\gcd(\bar f,\bar g).}                           \tag{2.4}
\]

The Smith normal form of \(m_g\) implies

\[
v_p(\operatorname{Res}(f,g))\ge d_p.                  \tag{2.5}
\]

Equality holds exactly when the \(p\)-primary part of \(\mathcal D(f,g)\) is
elementary abelian, equivalently when no Smith invariant contains \(p^2\).
It should not be called transversality without further geometric hypotheses.
The excess

\[
v_p(\operatorname{Res})-d_p
\]

measures higher \(p\)-power thickness invisible after reduction modulo \(p\).

### 2.1 Defect modules compose by extensions

The module, unlike its order, retains how polynomial factors interact. Let
\(g,h\in\mathbb Z[x]\), and assume \(\operatorname{Res}(f,g)\ne0\). Then
multiplication by \(g\) is injective on the free abelian group \(A_f\), and

\[
\boxed{
0\longrightarrow\mathcal D(f,h)
 \xrightarrow{\;\times g\;}\mathcal D(f,gh)
 \longrightarrow\mathcal D(f,g)\longrightarrow0.}     \tag{2.6}
\]

Explicitly, the first map sends \(a\bmod hA_f\) to
\(ga\bmod ghA_f\), and the second sends \(a\bmod ghA_f\) to
\(a\bmod gA_f\). The first is well-defined; if \(ga=ghb\), injectivity of
\(m_g\) gives \(a=hb\). The kernel of the second map is
\(gA_f/ghA_f\), exactly the image of the first.

If \(\operatorname{Res}(f,h)\ne0\) as well, all three modules are finite.
Taking their orders recovers

\[
|\operatorname{Res}(f,gh)|
 =|\operatorname{Res}(f,g)|\,|\operatorname{Res}(f,h)|. \tag{2.7}
\]

But (2.6) need not split. With \(f=x\), so that \(A_f=\mathbb Z\), and
\(g=h=p\), it is

\[
0\longrightarrow\mathbb Z/p
 \xrightarrow{\;\times p\;}\mathbb Z/p^2
 \longrightarrow\mathbb Z/p\longrightarrow0.          \tag{2.8}
\]

Thus scalar resultant multiplicativity is the decategorified order identity
of a potentially nontrivial extension. For an ordered factorization
\(g_1\cdots g_r\), successive applications give a canonical filtration of
\(\mathcal D(f,g_1\cdots g_r)\) whose successive quotients are the individual
defect modules; the filtration depends on the ordering, while the middle
module does not.

The interaction is supported exactly at shared bad primes. If

\[
\gcd(\operatorname{Res}(f,g),\operatorname{Res}(f,h))=1,
\]

then the outer modules in (2.6) have coprime orders, so both
\(\operatorname{Ext}^1_{\mathbb Z}\) and \(\operatorname{Hom}_{\mathbb Z}\)
between them vanish. The extension splits uniquely:

\[
\mathcal D(f,gh)\cong\mathcal D(f,h)\oplus\mathcal D(f,g). \tag{2.9}
\]

Therefore only primes dividing both resultants require joint factor analysis.
At every other prime the local defect is inherited from a single factor.
Repeated factors are the opposite extreme: they form successive
self-extensions in which higher \(p\)-power thickness can accumulate, as
\(\mathbb Z/p^r\) does for \(f=x\) and \(g=p\).

Computationally, the complete Smith data are obtained from the determinantal
divisors: put \(\Delta_0=1\), and let \(\Delta_k\) be the gcd of the
\(k\)-by-\(k\) minors of the
multiplication matrix, then the Smith factors satisfy
\(s_k=\Delta_k/\Delta_{k-1}\), with
\(\Delta_n=|\operatorname{Res}(f,g)|\). Equivalently, the resultant generates
the zeroth Fitting ideal; the higher determinantal/Fitting ideals give finer
invariants of the module. No multiplicativity of those higher ideals is
asserted here.

## 3. Observer loss and syndrome

Let

\[
V_p=\mathbb F_p[x]/(\bar f)
\]

and observe a state \(v\in V_p\) through the linear map \(m_{\bar g}v\).
Equation (2.4) and rank-nullity give

\[
\dim\ker m_{\bar g}=d_p,
\qquad
\dim\operatorname{coker}m_{\bar g}=d_p.               \tag{3.1}
\]

Every nonempty observer fiber, equivalently every fiber over the image of
\(m_{\bar g}\), therefore contains \(p^{d_p}\) states. Any zero-error
side channel that reconstructs \(v\) from \(m_{\bar g}v\) needs at least
\(p^{d_p}\) symbols; equality is achievable after choosing a vector-space
complement.

The cokernel gives a different but equally sized object: the obstruction
syndrome

\[
V_p/\operatorname{im}m_{\bar g}
 \cong\mathbb F_p[x]/\gcd(\bar f,\bar g).              \tag{3.2}
\]

Kernel and cokernel are related by rank-nullity or a chosen duality, not by a
canonical identity. The first measures missing side information; the second
is where a divisibility remainder lives.

## 4. The decic witness

For

\[
q_1=x^{10}+x^8+x^2+x+1,
\qquad g=q_1^*:=x^{10}q_1(x^{-1}),
\]

the existing exact computation gives

\[
\operatorname{Res}(q_1,q_1^*)=735=3\cdot5\cdot7^2.    \tag{4.1}
\]

Euclidean gcd calculations give

\[
\begin{array}{c|c|c}
p&\gcd(\bar q_1,\bar q_1^*)&d_p\\ \hline
3&x+1&1\\
5&x+4&1\\
7&x^2+4x+1&2.
\end{array}                                           \tag{4.2}
\]

At every prime dividing \(735\), valuation equals dimension. Hence,
noncanonically as an additive group,

\[
\mathcal D(q_1,q_1^*)
 \cong\mathbb Z/3\oplus\mathbb Z/5
       \oplus(\mathbb Z/7)^2.                         \tag{4.3}
\]

At \(p=7\), put \(h_7=x^2+4x+1\). The existing remainder

\[
F_X\bmod h_7
\]

is exactly the class of \(F_X\) in the two-dimensional cokernel
\(\mathbb F_7[x]/(h_7)\). The two syndrome equations are independent. The
cokernel has \(49\) syndrome values, of which zero is one; equivalently, the
earlier four-counter map accepts \(7^2\) of its \(7^4\) abstract inputs. The
square \(7^2\) in (4.1) is therefore the order of this local defect module. It also
implies a two-dimensional kernel side-information requirement, but the two
interpretations are not canonically the same coordinates.

Finally, the elementary identity

\[
\log|\operatorname{Res}(f,g)|
 =\sum_p v_p(\operatorname{Res}(f,g))\log p            \tag{4.4}
\]

shows the integral determinant magnitude as the total finite-place defect
thickness. For \(q_1\),

\[
\log735=\log3+\log5+2\log7.                           \tag{4.5}
\]

The same integer used in the archimedean exclusion estimate decomposes into
the dimensions and higher thicknesses of the finite observer defects.

## 5. Boundary and next question

The module \(\mathcal D(f,g)\) does not identify which modular collision is
relevant to a proposed divisor; `GLOBAL_CHARGE_DYNAMICS.md` already proves
that an unlocalized collision can accept where the divisor-specific syndrome
rejects. Nor does the order of the module alone retain its invariant-factor
decomposition.

The next exact question is therefore not whether every resultant is
“information.” It is:

> Which resultant-based exclusion certificates factor through the full defect
> module or one of its localized quotients, and when does retaining that module
> strictly strengthen the scalar determinant test?

That question has a finite answer for each certificate and a planted control:
two integer linear maps can have equal determinant but nonisomorphic cokernel
modules. The planted pair in `exp62_resultant_observer_defect.py` can also be
realized as multiplication maps in
\(\mathbb Z[x]/(x(x-1))\): multiplication by \(1+3x\) has CRT matrix
\(\operatorname{diag}(1,4)\), whereas multiplication by \(2\) has matrix
\(\operatorname{diag}(2,2)\). Any proposed strengthening must distinguish such
a pair and reduce work on an independent factor-exclusion instance.
