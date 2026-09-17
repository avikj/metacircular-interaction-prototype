# Finite-field logarithmic cube identities

**Date:** 2026-09-17

This note continues the SAT/cubical-geodesic line in exact finite-field coordinates. No complexity folklore is used. The objects are finite fields, cyclic multiplicative coordinates, affine/additive coordinates, fibres, and exact transformations.

## 1. Two exact coordinate systems on the same finite field

Let q=p^n and let F=GF(q). The additive carrier is an n-dimensional vector space over GF(p). For p=2 it is literally an n-bit affine cube GF(2)^n.

The nonzero carrier F^× is cyclic of order m=q-1. Choose a primitive element g. Then

    exp_g : Z/m -> F^×,  a |-> g^a

is a group isomorphism, with inverse log_g. Multiplication becomes addition:

    log_g(g^a g^b) = a+b mod m.

Thus multiplication is flat translation in logarithmic coordinates.

## 2. Transport field addition into logarithmic coordinates

For a,b in Z/m with g^a+g^b != 0, define

    a boxplus b = log_g(g^a+g^b).

Factor g^a:

    g^a+g^b = g^a(1+g^(b-a)).

Define the one-variable logarithmic addition residual

    lambda(d) = log_g(1+g^d)

on the domain D = {d : 1+g^d != 0}. Then exactly

    a boxplus b = a + lambda(b-a).

So the two-input field addition law factors through one absolute translation coordinate a and one relative coordinate d=b-a. All nonlinear incidence is concentrated in lambda.

The exceptional locus is 1+g^d=0, equivalently g^d=-1. In odd characteristic, m is even and the unique exceptional exponent is d=m/2. In characteristic two, -1=1 and the unique exceptional exponent is d=0.

## 3. Inversion identity

For every d for which both sides are defined,

    1+g^(-d) = g^(-d)(1+g^d).

Taking logarithms gives

    lambda(-d) = lambda(d)-d mod m.

Equivalently

    lambda(d) = d + lambda(-d).

This is exactly commutativity of transported addition:

    a + lambda(b-a) = b + lambda(a-b).

## 4. Frobenius equivariance

In characteristic p,

    (1+x)^p = 1+x^p.

Therefore

    1+g^(pd) = (1+g^d)^p,

and hence

    lambda(pd) = p lambda(d) mod m.

Iterating,

    lambda(p^k d) = p^k lambda(d) mod m.

Since p^n=q == 1 mod (q-1), the nth iterate returns. Thus lambda commutes with the Frobenius permutation d |-> pd of exponent coordinates and descends orbitwise to p-cyclotomic cosets modulo q-1.

## 5. Characteristic two: lambda is an involution

Now q=2^n, m=q-1, D=Z/m \ {0}. For d != 0,

    g^(lambda(d)) = 1+g^d.

Apply 1+(-) again. Since 1+1=0,

    1+g^(lambda(d)) = 1+(1+g^d)=g^d.

Therefore

    lambda(lambda(d)) = d.

There are no fixed points: lambda(d)=d would imply 1+g^d=g^d and hence 1=0. Thus lambda is a fixed-point-free involution of the q-2 nonzero exponent differences.

Combined with Frobenius,

    lambda(2d)=2lambda(d),

so this involution commutes with the doubling/Frobenius action.

## 6. The anharmonic S3 action appears exactly

Still in characteristic two, work on

    U = F \ {0,1}.

Define

    A(x)=1+x,
    B(x)=x^(-1).

Both preserve U and satisfy

    A^2 = id,
    B^2 = id.

Moreover

    AB(x) = 1+x^(-1) = (x+1)/x.

A direct calculation gives

    (AB)^2(x)=1/(x+1),
    (AB)^3(x)=x.

Hence

    A^2=B^2=(AB)^3=id.

These generate the anharmonic S3 action permuting the three marked points {0,1,infinity} of the projective line P^1(F).

In logarithmic exponent coordinates x=g^d:

    B corresponds to N(d)=-d,
    A corresponds to L(d)=lambda(d).

Therefore on D=Z/m\{0},

    L^2=N^2=(LN)^3=id.

The six transforms of a generic exponent d are the logarithmic presentations of

    x,
    1+x,
    1/x,
    1/(1+x),
    x/(1+x),
    (1+x)/x.

Thus the elementary field-addition residual is not an arbitrary lookup table: it carries an exact projective S3 symmetry.

## 7. Orbit sizes and exceptional stabilizers

Generic S3 orbits have six points. Smaller orbits occur exactly at nontrivial stabilizers.

A fixes x iff 1+x=x, impossible in any field.

B fixes x iff x^2=1. In characteristic two this gives x=1, excluded from U, so B has no fixed point on U.

The third transposition x |-> x/(1+x) similarly has no fixed point on U in characteristic two.

A 3-cycle fixes x when

    (x+1)/x = x,

so

    x^2+x+1=0.

Equivalently x is a nontrivial cube root of unity. Such points exist in GF(2^n) exactly when 3 divides 2^n-1, i.e. n is even. Then the two roots form one S3 orbit of size two; otherwise every orbit in U has size six.

Since |U|=2^n-2, this gives the exact divisibility check:

- n odd: 2^n-2 is divisible by 6 and all U decomposes into 6-orbits;
- n even: two exceptional cube roots form a 2-orbit and the remaining 2^n-4 points decompose into 6-orbits.

## 8. Frobenius and S3 commute

Every S3 transformation above is defined over the prime field GF(2), so Frobenius sigma(x)=x^2 commutes with it:

    sigma(Ax)=A(sigma x),
    sigma(Bx)=B(sigma x).

In exponent coordinates this is exactly

    2 lambda(d)=lambda(2d),
    -2d=2(-d).

Hence U carries a commuting action of S3 and the cyclic Galois group Gal(GF(2^n)/GF(2))=<sigma>. The logarithmic residual geometry is organized by joint S3 x C_n orbits, with stabilizer intersections determining orbit contraction.

## 9. Discrete logarithm as an exact chart and its seam

The logarithm is not a map F -> Z/m: zero is missing. The exact chart is

    F^× ~= Z/m.

Field multiplication is closed in this chart. Field addition is not: the diagonal a=b in characteristic two maps to zero,

    g^a+g^a=0.

Thus the additive law transported through the multiplicative chart has an exact seam at relative coordinate d=0. Away from that seam, all addition is encoded by lambda.

This is the finite-field instance of the repository's general presentation/fibre distinction: a chart can flatten one operation completely while moving the residual structure of another operation into a transition/fibre at the chart boundary.

## 10. Prime fields as the no-zero-divisor locus

For Z/nZ, multiplication by a nonzero a has kernel

    ker(mu_a) = {x : ax=0 mod n}.

If n=p is prime, every nonzero a is invertible, so every such kernel is {0}. Conversely, if n is composite, choose a proper divisor d with 1<d<n. Then d*(n/d)=0 mod n with both factors nonzero. Therefore

    n prime
    iff
    for every a != 0, ker(mu_a)={0}
    iff
    every nonzero multiplication map mu_a is a permutation
    iff
    (Z/nZ)^× = (Z/nZ)\{0}.

So primality is exactly the statement that the multiplicative geometry has no nontrivial zero fibre away from the origin.

## 11. Affine Boolean geometry and 3SAT

For q=2^N, the additive carrier GF(2)^N is exactly the Boolean N-cube. A partial Boolean assignment fixing k coordinates is an affine coordinate flat of codimension k. A violated 3SAT clause is a codimension-three coordinate flat. Compatible clause intersections are intersections of such affine flats; incompatible intersections are empty.

Thus the previously derived SAT inclusion-exclusion identity is literally finite affine incidence geometry:

    #SAT(F) = sum_{T compatible} (-1)^|T| 2^(N-r(T)).

The exponent N-r(T) is the affine dimension of the intersection flat. The overlap tower is therefore a dimension-weighted incidence transform of the clause-flat arrangement.

## 12. Exact relation to the geodesic line

The field calculation gives a concrete warning and a concrete opportunity.

Warning: an operation that appears globally nonlinear in one coordinate system may become translation in an equivalent chart. Multiplication on F^× is the canonical example. Therefore a lower-bound certificate cannot charge coordinate syntax; it must survive exact chart transport.

Opportunity: after transporting multiplication to addition, the entire interaction between the additive and multiplicative structures is concentrated in lambda and its seam. lambda is constrained by:

    lambda(-d)=lambda(d)-d,
    lambda(pd)=p lambda(d),

and in characteristic two additionally

    lambda^2=id,
    N^2=id,
    (lambda N)^3=id.

Thus the residual is already highly quotiented by exact symmetry. Any geodesic potential on this field geometry should be constant/equivariant on these exact orbit identifications rather than charging six equivalent projective presentations separately.

## 13. Immediate compression of the whole picture

For GF(2^n):

    additive geometry      = n-bit affine cube,
    multiplicative geometry = cyclic (2^n-1)-gon in exponent coordinates,
    multiplication         = exponent translation,
    addition               = a + lambda(b-a),
    additive-zero seam     = b-a=0,
    projective symmetry    = S3 generated by lambda and exponent negation,
    Galois symmetry        = d |-> 2d,
    joint exact symmetry   = commuting S3 and C_n actions.

So the same finite object simultaneously presents a cube, a cyclic logarithmic chart, a projective line with three marked points, and a Galois orbit geometry. These are not analogies: the maps above are explicit identities between the presentations.
