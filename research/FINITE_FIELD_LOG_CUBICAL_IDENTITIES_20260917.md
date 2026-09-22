# Finite-field logarithmic cube identities — theorem-grade ledger

**Purpose:** persistent source of truth for the finite-field/logarithmic branch of the cubical SAT/geodesic work. Everything below is either an elementary theorem proved inline or explicitly marked as an interpretation.

## 0. Notation and the exact object

Let `p` be prime, `n >= 1`, and

\[
q=p^n.
\]

There exists, up to field isomorphism, a unique finite field with `q` elements. Denote it

\[
F=\mathbb F_q=\mathbb F_{p^n}.
\]

Its characteristic is `p`, so adding `1` to itself `p` times gives zero. It contains a canonical copy of the prime field `F_p`.

As a vector space over `F_p`, `F_q` has dimension `n`. Choosing an `F_p`-basis `e_1,...,e_n` gives a coordinate isomorphism of additive groups

\[
(\mathbb F_q,+)\cong(\mathbb F_p^n,+),
\qquad
x=\sum_i a_i e_i\longleftrightarrow(a_1,...,a_n).
\]

This is basis-dependent as a coordinate map but basis-independent as the statement that the additive group is an `n`-dimensional `F_p` vector space. For `p=2`, each `a_i` is a bit, so the underlying additive carrier is literally the Boolean vertex cube `\{0,1\}^n` with XOR as addition.

Remove zero. The multiplicative group

\[
\mathbb F_q^\times=\mathbb F_q\setminus\{0\}
\]

has `q-1` elements and is cyclic. Put

\[
m=q-1.
\]

Choose a primitive element `g`, meaning an element of multiplicative order exactly `m`. Then every nonzero field element occurs uniquely as `g^a` for `a` modulo `m`. Hence

\[
\exp_g:\mathbb Z/m\mathbb Z\overset\cong\longrightarrow\mathbb F_q^\times,
\qquad a\mapsto g^a,
\]

is a group isomorphism, with inverse `log_g`.

Thus the same field has two exact presentations relevant here:

\[
(\mathbb F_q,+)\cong(\mathbb F_p)^n
\]

and

\[
(\mathbb F_q^\times,\cdot)\cong\mathbb Z/(q-1)\mathbb Z.
\]

They preserve different operations. The first linearizes **field addition**; the second linearizes **field multiplication**. They are not an isomorphism between the two displayed groups, which even have different cardinalities (`q` versus `q-1`). They are two coordinate views of overlapping structure on the same field carrier.

Under the logarithmic chart,

\[
\log_g(g^ag^b)=a+b\pmod m.
\]

Changing primitive generator from `g` to `g^u`, with `gcd(u,m)=1`, rescales logarithmic coordinates by the unit `u^{-1}` modulo `m`. Therefore the particular exponent labels are chart data, while the cyclic multiplicative geometry is intrinsic.

---

## 1. Transport field addition into logarithmic coordinates

For `a,b in Z/m` with `g^a+g^b != 0`, define

\[
a\boxplus b=\log_g(g^a+g^b).
\]

Factor:

\[
g^a+g^b=g^a(1+g^{b-a}).
\]

Define the one-variable logarithmic addition residual

\[
\lambda(d)=\log_g(1+g^d)
\]

on

\[
D=\{d\in\mathbb Z/m:1+g^d\ne0\}.
\]

### Theorem 1.1 — relative-coordinate factorization

\[
\boxed{a\boxplus b=a+\lambda(b-a)\pmod m.}
\]

**Proof.** Apply `log_g` to `g^a(1+g^{b-a})`; logarithm converts multiplication into addition. ∎

Hence the two-input addition law in multiplicative coordinates consists of one absolute translation coordinate `a` plus one relative coordinate `d=b-a`. All nontrivial interaction between the additive and multiplicative presentations is concentrated in `lambda` and the point where it is undefined.

### Theorem 1.2 — exact seam

`lambda(d)` is undefined exactly when `g^d=-1`.

- If `p` is odd, `m` is even and the unique seam is `d=m/2`.
- If `p=2`, `-1=1` and the unique seam is `d=0`.

**Proof.** `1+g^d=0 iff g^d=-1`. In a cyclic group there is a unique order-two element when `m` is even, namely `g^{m/2}`. In characteristic two, `-1=1=g^0`. ∎

---

## 2. Exact identities of lambda

### Theorem 2.1 — inversion identity

Whenever defined,

\[
\boxed{\lambda(-d)=\lambda(d)-d\pmod m.}
\]

**Proof.**

\[
1+g^{-d}=g^{-d}(1+g^d).
\]

Take logarithms. ∎

Equivalently `lambda(d)=d+lambda(-d)`. Substituting `d=b-a` recovers commutativity of field addition in log coordinates.

### Theorem 2.2 — Frobenius equivariance

For every `d` in the domain,

\[
\boxed{\lambda(pd)=p\lambda(d)\pmod m.}
\]

More generally,

\[
\lambda(p^kd)=p^k\lambda(d)\pmod m.
\]

**Proof.** In characteristic `p`, `(1+x)^p=1+x^p`. Therefore

\[
1+g^{pd}=(1+g^d)^p.
\]

Take logarithms. Iterate. ∎

Since `p^n=q == 1 mod (q-1)`, exponent multiplication by `p` has order dividing `n`. Thus `lambda` respects the `p`-cyclotomic/Frobenius orbit decomposition modulo `m`.

### Theorem 2.3 — characteristic-two involution

Let `q=2^n`, `m=q-1`, `D=Z/m \ {0}`. Then

\[
\boxed{\lambda^2=\mathrm{id}_D.}
\]

Moreover `lambda` has no fixed points on `D`.

**Proof.** If `g^{lambda(d)}=1+g^d`, then

\[
1+g^{\lambda(d)}=1+(1+g^d)=g^d
\]

because `1+1=0`. Taking logs gives `lambda(lambda(d))=d`. If `lambda(d)=d`, then `1+g^d=g^d`, hence `1=0`, contradiction. ∎

Thus the `q-2` admissible nonzero relative exponents pair exactly under `lambda`.

---

## 3. Projective S3 geometry in characteristic two

Let

\[
U=\mathbb F_{2^n}\setminus\{0,1\}.
\]

Define

\[
A(x)=1+x,\qquad B(x)=x^{-1}.
\]

### Theorem 3.1 — anharmonic relations

\[
\boxed{A^2=B^2=(AB)^3=\mathrm{id}.}
\]

**Proof.** `A^2(x)=1+(1+x)=x`; `B^2(x)=x`. Also

\[
AB(x)=1+x^{-1}=\frac{x+1}{x},
\]

\[
(AB)^2(x)=\frac1{x+1},
\]

and applying once more gives `x`. ∎

Hence `A,B` generate the standard anharmonic `S_3` action permuting the marked projective points `{0,1,infinity}`.

Under `x=g^d`, define `L(d)=lambda(d)` and `N(d)=-d`. Then

\[
\boxed{L^2=N^2=(LN)^3=\mathrm{id}.}
\]

The six generic transforms correspond to

\[
x,\quad1+x,\quad1/x,\quad1/(1+x),\quad x/(1+x),\quad(1+x)/x.
\]

Thus `lambda` is not arbitrary finite data; it is one generator of an exact projective symmetry action.

### Theorem 3.2 — orbit sizes

Generic `S_3` orbits in `U` have size six. In characteristic two, transpositions have no fixed points in `U`. A 3-cycle fixes precisely the roots of

\[
x^2+x+1=0.
\]

These are the nontrivial cube roots of unity. They exist in `F_{2^n}` iff `3 | (2^n-1)`, equivalently iff `n` is even.

Therefore:

- `n` odd: every point of `U` lies in a six-element `S_3` orbit;
- `n` even: the two nontrivial cube roots form one two-element orbit, and every remaining point lies in a six-element orbit.

**Proof.** Orbit-stabilizer plus the displayed fixed-point equations. `2^n mod 3` alternates `2,1`, so divisibility occurs exactly for even `n`. ∎

---

## 4. Galois/Frobenius geometry and compatibility

The Frobenius automorphism is

\[
\sigma(x)=x^p.
\]

For `F_{p^n}/F_p`, the Galois group is cyclic of order `n`, generated by `sigma`.

### Theorem 4.1 — Frobenius in exponent coordinates

\[
\boxed{\log_g(\sigma(g^d))=pd\pmod m.}
\]

So Galois evolution is multiplication of exponent coordinates by `p` modulo `m`.

### Theorem 4.2 — in characteristic two, Frobenius commutes with the projective S3 action

For `A(x)=1+x`, `B(x)=x^{-1}`, `sigma(x)=x^2`,

\[
\sigma A=A\sigma,\qquad \sigma B=B\sigma.
\]

**Proof.** `(1+x)^2=1+x^2` and `(x^{-1})^2=(x^2)^{-1}`. ∎

In exponent coordinates this is

\[
\lambda(2d)=2\lambda(d),\qquad -2d=2(-d).
\]

Hence the logarithmic residual geometry carries commuting `S_3` and cyclic Galois actions. Its exact quotient can therefore be organized by joint orbits and stabilizers; equivalent orbit points must not be charged as independent structure in any presentation-invariant cost.

---

## 5. Prime geometry as exact fibre geometry

Consider the ring `Z/nZ` and multiplication map

\[
\mu_a(x)=ax.
\]

### Theorem 5.1 — primality equivalences

For `n>1`, the following are equivalent:

1. `n` is prime;
2. every nonzero residue is a unit;
3. every `mu_a` with `a != 0` is a permutation;
4. every such `mu_a` has zero fibre/kernel exactly `{0}`;
5. there are no nonzero zero divisors.

**Proof.** If `n=p` is prime, `Z/pZ` is a field. Conversely if `n=rs` with `1<r,s<n`, then the nonzero classes of `r,s` satisfy `rs=0 mod n`, producing a nontrivial zero fibre. ∎

Thus the prime/composite boundary is literally a change in multiplicative fibre geometry: at a prime modulus every nonzero multiplicative direction is invertible; at a composite modulus some nonzero direction collapses distinct points into the zero fibre.

---

## 6. Boolean cube / affine geometry / SAT

For `p=2`,

\[
(\mathbb F_2)^N=\{0,1\}^N
\]

as sets, with vector addition equal to bitwise XOR.

A partial assignment fixing `k` coordinates is a coordinate affine flat of codimension `k`, hence has `2^{N-k}` vertices. A violated exactly-three-literal clause fixes three coordinates and is a codimension-three coordinate flat.

For a 3CNF with violated flats `V_alpha`,

\[
F\text{ UNSAT}\iff\bigcup_\alpha V_\alpha=\mathbb F_2^N.
\]

If `T` is a compatible clause subset and `r(T)` is the number of distinct coordinates fixed by its union, then

\[
\bigcap_{\alpha\in T}V_\alpha\cong\mathbb F_2^{N-r(T)}
\]

and therefore

\[
\boxed{
\#SAT(F)=\sum_{T\text{ compatible}}(-1)^{|T|}2^{N-r(T)}.
}
\]

This is inclusion-exclusion written entirely as finite affine incidence geometry. The exponent is the dimension of the actual intersection flat.

A crucial control already derived in the SAT notebook: exponentially many distinct intersections do not imply exponential intrinsic reduction cost. Pairwise-disjoint 3-clauses have `2^m` distinct compatible intersections but the entire satisfying object factors as a product of `m` seven-point local pieces. Thus cardinality of vertices/intersections is not geodesic length.

---

## 7. Exact presentation lesson

The two finite-field charts provide the cleanest elementary example of the repository's general presentation principle.

In additive coordinates `F_p^n`, addition is componentwise linear while multiplication is the structured operation determined by the chosen field extension.

In multiplicative log coordinates `Z/(q-1)`, multiplication becomes ordinary cyclic addition, while field addition becomes

\[
a\boxplus b=a+\lambda(b-a)
\]

with a one-point seam where the sum is zero.

Therefore operation cost visible in one syntax cannot by itself be intrinsic. Exact equivalences can move structure between the carrier, the operation, and a residual/seam. A presentation-invariant geodesic certificate must survive these transports.

This is directly consonant with the existing repository results that equivalent output coordinates preserve fibres proof-relevantly and that mutually simulating action presentations induce isomorphic complete-future quotients.

---

## 8. Theorem-grade bridge to the geodesic work

Let a primitive reduction graph have weighted edges `u -> v` of cost `w(u,v)`. A potential `Phi` with

\[
\Phi(t)=0
\]

on terminal states and

\[
\Phi(u)\le w(u,v)+\Phi(v)
\]

on every primitive edge gives, by summing along any terminal path,

\[
\operatorname{cost}(\gamma)\ge\Phi(u_0).
\]

If a native path has equality at every edge, its cost equals `Phi(u_0)` and it is geodesic. This is the exact local-to-global lower-bound mechanism already isolated in the SAT derivation.

For finite-field/logarithmic geometry, any such `Phi` intended to be intrinsic must respect the exact equivalences above. In particular, in characteristic two it cannot distinguish points solely because they lie in different representatives of the same projective/Galois orbit unless the primitive cost semantics itself distinguishes them. The identities `lambda^2=id`, `(lambda N)^3=id`, and Frobenius equivariance are therefore exact reductions of the coordinate space on which a legitimate potential is constructed.

This paragraph is an interpretation/application of the proved identities, not an additional finite-field theorem.

---

## 9. Compact resume table

For `F=F_{2^n}` and primitive `g`:

| Object | Exact presentation |
|---|---|
| additive carrier | `F_2^n`, an `n`-bit affine cube |
| nonzero multiplic
