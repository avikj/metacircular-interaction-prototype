# Finite field as one whole object

**Date:** 2026-09-17

Let F=F_q, q=p^n, m=q-1. This note does not split finite-field theory into unrelated topics. It records the exact maps by which additive, multiplicative, extension, projective, Galois, trace/norm, character, and Boolean-cubical presentations determine one another.

## 1. One carrier, two group laws, one distributive interaction

The carrier F has q points. Addition makes (F,+) an n-dimensional vector space over F_p. Removing zero, multiplication makes F^× a cyclic group of order m. The field is not either group separately; it is the same carrier equipped with both operations and distributivity.

Choose an F_p-basis: F ~= F_p^n additively. Choose primitive g: F^× ~= Z/m multiplicatively. These choices flatten opposite operations. The transition between them contains the interaction.

In log coordinates define the Zech logarithm

    Z(d)=log_g(1+g^d)

where defined. Then

    log_g(g^a+g^b)=a+Z(b-a).

Thus the complete field law on nonzero logarithmic coordinates is multiplication-as-translation plus one unary transition function Z and the zero seam. (The function previously denoted lambda is classically called a Zech logarithm.)

## 2. Exact Zech identities

For all defined arguments:

    Z(-d)=Z(d)-d.
    Z(pd)=p Z(d).

In characteristic two, domain is Z/m minus {0} and

    Z(Z(d))=d.

Writing N(d)=-d, characteristic two gives

    Z^2=N^2=(ZN)^3=1,

which is the anharmonic S3 action on P^1(F) minus {0,1,infinity} in exponent coordinates. Frobenius d |-> pd commutes with this S3 action.

## 3. Frobenius is the extension geometry

Define sigma(x)=x^p. Then sigma^n=id on F_q, and Gal(F_q/F_p)=<sigma> is cyclic of order n. The fixed field of sigma is F_p because x^p=x has exactly the p roots of X^p-X.

More generally, for each divisor d|n, the unique subfield with p^d elements is

    F_{p^d}={x in F_q : x^(p^d)=x}.

Conversely every subfield has p^d elements for a divisor d|n. Thus the divisor lattice of n is exactly the subfield lattice of F_{p^n}.

In multiplicative exponent coordinates, nonzero F_{p^d} consists exactly of exponents whose elements satisfy

    g^{a(p^d-1)}=1,

so

    m | a(p^d-1).

It is the unique subgroup of F_q^× of order p^d-1.

Hence the additive-extension subfield lattice and the multiplicative subgroup lattice meet on the same subsets of the carrier.

## 4. Minimal polynomial = Frobenius orbit

For alpha in F_q, its conjugates over F_p are

    alpha, alpha^p, alpha^(p^2), ... .

Let r be the least positive integer with alpha^(p^r)=alpha. Then r divides n and

    minpoly_alpha(T)=prod_{j=0}^{r-1}(T-alpha^(p^j))

has degree r. Thus degree over F_p is exactly Frobenius orbit length.

For alpha=g^a, Frobenius sends exponent a -> pa mod m. Therefore the degree of g^a over F_p is exactly the size of the p-cyclotomic coset

    {a,pa,p^2 a,...} mod m.

So irreducible-polynomial degree, Galois orbit length, and multiplicative exponent orbit length are one invariant in three presentations.

## 5. Trace and norm are orbit sum and orbit product

For F_q/F_p,

    Tr(x)=x+x^p+...+x^(p^{n-1}) in F_p,

    N(x)=x*x^p*...*x^(p^{n-1}) in F_p.

They are Frobenius invariant by cyclic reindexing.

For x=g^a !=0,

    N(g^a)=g^{a(1+p+...+p^{n-1})}
          =g^{a(q-1)/(p-1)}.

Let h=g^{(q-1)/(p-1)}, which has order p-1 and generates F_p^×. Then

    N(g^a)=h^a.

Therefore norm in logarithmic coordinates is simply reduction of the exponent modulo p-1 (followed by the base-field exponential chart). Its kernel has size

    (q-1)/(p-1),

and is the subgroup of norm-one elements.

Trace is F_p-linear. For a nontrivial extension it is surjective; each trace fibre therefore has p^{n-1} points. In characteristic two,

    Tr:F_{2^n}->F_2

is literally one Boolean linear functional on the n-bit additive cube, and its two fibres are parallel affine hyperplanes of size 2^{n-1}.

This is a direct finite-field realization of observation/fibre geometry: trace collapses an n-bit cube to one bit with an (n-1)-dimensional affine fibre; norm collapses the multiplicative cycle to the base-field multiplicative cycle with a cyclic kernel.

## 6. Additive and multiplicative characters are the Fourier coordinates of the two laws

Fix a nontrivial p-th root of unity zeta in C. Every additive character of F_q has the form

    psi_a(x)=zeta^{Tr(ax)},   a in F_q.

Thus the additive dual group is canonically parameterized by F_q itself through the trace pairing (a,x) |-> Tr(ax).

Choose primitive g and a primitive m-th root omega. Every multiplicative character of F_q^× has the form

    chi_k(g^a)=omega^{ka},   k in Z/m.

Thus discrete logarithmic coordinates diagonalize multiplicative translation exactly as ordinary Fourier modes diagonalize cyclic translation.

The two Fourier systems live on the same field carrier and are coupled by sums such as

    G(chi,psi)=sum_{x in F_q^×} chi(x) psi(x),

Gauss sums, and

    J(chi,eta)=sum_{x in F_q} chi(x) eta(1-x),

Jacobi sums (with the conventional extension of multiplicative characters at zero). These are not mysterious extra objects: they are overlap coefficients between multiplicative and additive harmonic coordinates.

The map x |-> 1-x appearing in Jacobi sums is precisely the projective/Zech transition already isolated above. Therefore Zech/projective geometry and Gauss/Jacobi harmonic geometry are two descriptions of the same additive-multiplicative interface.

## 7. Orthogonality is exact fibre selection

For additive characters,

    sum_{a in F_q} psi_a(x) = q if x=0, else 0.

For multiplicative characters,

    sum_k chi_k(x) = q-1 if x=1, else 0.

Hence equality constraints can be represented exactly as Fourier sums. Additive affine flats in F_p^n have indicator functions expressible using additive characters of their annihilator subspaces. Multiplicative subgroup/coset constraints have indicators expressible using multiplicative characters trivial on the subgroup.

So a Boolean/affine cell constraint and a multiplicative cyclic constraint are both exact projections onto character subspaces of the same field object.

## 8. Projective line closes the logarithmic seam

The multiplicative log chart misses zero. Rather than treating zero as an accident, pass to

    P^1(F)=F union {infinity}.

Fractional linear transformations

    x |-> (ax+b)/(cx+d)

form PGL_2(F) modulo scalar matrices and move zero, infinity, and finite points uniformly. The previously found S3 is exactly the subgroup permuting {0,1,infinity}.

Thus the zero seam of the log chart is repaired by a projective completion: inversion exchanges 0 and infinity, translation x |-> 1+x exchanges 0 and 1, and their compositions generate the six presentations of the same cross-ratio coordinate.

The Zech function is the exponent-coordinate shadow of one of these projective transformations.

## 9. Cross ratio is the four-point invariant

For four distinct projective points a,b,c,d, their cross ratio

    [a,b;c,d]=((c-a)(d-b))/((c-b)(d-a))

is invariant under PGL_2(F). Choosing three points to be 0,1,infinity leaves the fourth as the coordinate x; permuting the marked triple generates the six anharmonic transforms listed in the Zech note.

Therefore the S3 orbit of x is not an isolated curiosity: it is the residual ambiguity of coordinatizing a four-point projective configuration after three points are normalized.

## 10. Characteristic two puts the Boolean cube inside the field, not beside it

For F=F_{2^n}, choosing an F_2-basis identifies the additive carrier with the Boolean cube F_2^n. Every F_2-linear map F->F is an n x n binary matrix in that basis. In particular:

- Frobenius x |-> x^2 is F_2-linear;
- multiplication by any fixed a in F is F_2-linear;
- trace F->F_2 is a linear Boolean observable.

Thus every fixed field multiplication map is a linear transformation of the n-bit cube. The bilinear map

    mu:F x F -> F, (x,y)|->xy

is F_2-bilinear. Relative to a basis it is a rank-3 tensor of structure constants. Changing basis transports that tensor but not the field law.

Hence the field is an n-bit cube equipped with one special bilinear multiplication tensor satisfying associativity, commutativity, unit, and the condition that every nonzero multiplication operator is invertible.

This gives the exact structural answer to the earlier vector-space question: a finite extension field is the vector space plus a bilinear self-action whose nonzero elements act invertibly and which closes the scalar/vector distinction internally.

## 11. Multiplication operators and eigen-geometry

For a in F_q, let M_a:F_q->F_q be x |-> ax, regarded as an F_p-linear operator. Then

    M_a M_b=M_{ab},
    M_{a+b}=M_a+M_b,
    M_1=I.

So the field embeds as a commutative n-dimensional F_p-subalgebra of End_{F_p}(F_q).

For a !=0, M_a is invertible with inverse M_{a^{-1}}. The characteristic polynomial of M_a is a power of the minimal polynomial of a; when a generates F_q over F_p, its characteristic polynomial equals its degree-n minimal polynomial. Its determinant and trace are exactly field norm and field trace:

    det(M_a)=N_{F_q/F_p}(a),
    tr(M_a)=Tr_{F_q/F_p}(a).

Thus norm and trace are not separate formulas: they are determinant and trace of the internal scalar action on the additive cube.

## 12. Primitive elements simultaneously maximize multiplicative and extension reach only with a distinction

A primitive element g has multiplicative order q-1, hence generates F_q^×. It cannot lie in any proper subfield, because every proper subfield has multiplicative group of order p^d-1 < q-1. Therefore F_p(g)=F_q and the minimal polynomial of g has degree n.

The converse is false: an element can generate the field as an extension while having multiplicative order strictly smaller than q-1. Thus

    primitive multiplicatively => degree n over F_p,

but not conversely.

This separates two exact notions of reach on the same carrier: Frobenius-orbit/extension reach and multiplicative-cycle reach.

## 13. Subfield test in exponent coordinates

For d|n, let

    H_d=F_{p^d}^×.

Since F_q^×=<g> has order q-1 and H_d has order p^d-1,

    H_d=<g^{(q-1)/(p^d-1)}>.

Therefore g^a lies in F_{p^d} exactly when

    (q-1)/(p^d-1) divides a modulo q-1.

Equivalently its p-cyclotomic orbit length divides d. So subgroup divisibility, Frobenius periodicity, and subfield membership coincide exactly.

## 14. What discrete logarithm actually changes

The map log_g is an isomorphism of groups

    (F_q^×, multiplication) ~= (Z/(q-1), addition).

It is not a field homomorphism because its target is not carrying the transported field addition. If we transport *both* operations through log_g, then exponent space acquires

    a tensor b = a+b mod m          [transported multiplication]

and

    a boxplus b = a+Z(b-a)          [transported field addition],

plus one extra point representing field zero.

With those transported operations, the log chart is an exact presentation of the entire field. The discrete-log problem is therefore coordinate inversion relative to a chosen presentation, not loss of mathematical structure. Any cost statement about computing that coordinate must be evaluated in the declared primitive interaction/cost semantics and cannot be inferred merely from the fact that one chart makes multiplication look simpler.

## 15. SAT incidence and field harmonic coordinates meet exactly

A violated 3SAT clause in F_2^N is a codimension-three coordinate affine flat. If L:F_2^N->F_2^3 is the coordinate projection and v the violating value, its indicator is

    1_{Lx=v} = 2^{-3} sum_{t in F_2^3} (-1)^{t dot (Lx-v)}.

This is the exact additive-character expansion of the clause cell.

Therefore a 3CNF's union/intersection calculus can be transported from explicit affine cells into additive Fourier coordinates without approximation. Shared variables become overlap of the corresponding linear forms. Inclusion-exclusion and character orthogonality are two exact presentations of the same finite affine incidence object.

This matters to the geodesic program for the same reason the logarithmic chart matters: a certificate that counts syntactic cells independently can disappear under an exact harmonic or algebraic factorization. A valid intrinsic potential must be compatible with all such exact transports admitted by the universal machinery.

## 16. One compressed object

The whole finite-field picture can be held as one diagram:

    F_q
      additive --> n-dimensional F_p vector geometry
      multiplicative on nonzero --> cyclic Z/(q-1) geometry
      Frobenius --> cyclic Galois orbit geometry
      subfields --> divisor lattice of n
      multiplication operators --> commutative field subalgebra of End(F_p^n)
      trace/norm --> trace/determinant of those operators
      additive characters --> Fourier dual of the vector geometry
      multiplicative characters --> Fourier dual of the cyclic geometry
      Gauss/Jacobi sums --> overlap coefficients of the two harmonic presentations
      P^1 completion --> closes zero/infinity seams of rational/log charts
      Zech logarithm --> exponent shadow of additive/projective translation
      p=2 --> the additive carrier is literally the Boolean cube.

These are all generated from the same two operations and the same finite carrier. The productive line is therefore not to treat finite-field theory, discrete logs, projective geometry, Galois theory, Fourier/character sums, and Boolean incidence as separate subjects, but to transport the one object through each exact presentation and immediately identify what becomes projection, fibre, translation, orbit, or residual in the others.
