{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ParityNormEliminant
--
-- Exact certification of the algebra underneath the parity/resultant
-- lane of this corpus:
--
--   notes/PARITY_RESULTANT.md   Theorem 1b, equations (2.2), (2.3), (5.1)
--   notes/QUINTIC_OBSTRUCTION.md equations (1.3), (1.5)
--   notes/CUBIC_OBSTRUCTION.md
--
-- Those notes compute three resultants by hand -- a 3x3 and a 4x4
-- Sylvester determinant, and a degree-10 reflection product -- and every
-- later step (the coefficient boxes, the 1591-solution enumeration, the
-- 18 surviving quintic candidates) rests on them being right.  Each is a
-- finite exact identity over an arbitrary commutative ring, so under
-- CLAUDE.md it is provable rather than measurable, and it is proved here.
--
-- Nothing analytic is claimed: root locations, Sturm counts and tail
-- certificates are not in this file and are not certified by it.
------------------------------------------------------------------------

module ParityNormEliminant where

open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open CommRingStr (ℤCommRing .snd)

private
  R : Type
  R = fst ℤCommRing

------------------------------------------------------------------------
-- 1.  The even/odd (parity) decomposition
--
-- Every P in Z[x] is P(x) = E(x^2) + x O(x^2).  For the two shapes the
-- corpus needs -- a monic quartic and a monic quintic with constant
-- term 1 -- E and O are:
--
--   quartic  g = x^4 + a x^3 + b x^2 + c x + 1 ,  E = y^2+by+1, O = ay+c
--   quintic  g = x^5 + a x^4 + b x^3 + c x^2 + d x + 1 ,
--                                        E = ay^2+cy+1, O = y^2+by+d
------------------------------------------------------------------------

-- quintic shape
Eq : R → R → R → R
Eq a c y = a · (y · y) + c · y + 1r

Oq : R → R → R → R
Oq b d y = y · y + b · y + d

gq : R → R → R → R → R → R
gq a b c d x = Eq a c (x · x) + x · Oq b d (x · x)

-- the reflection g(-x): same E, negated odd part
gqm : R → R → R → R → R → R
gqm a b c d x = Eq a c (x · x) - x · Oq b d (x · x)

-- the reflection norm  H(y) = E(y)^2 - y O(y)^2
Hq : R → R → R → R → R → R
Hq a b c d y = Eq a c y · Eq a c y - y · (Oq b d y · Oq b d y)

-- quartic shape
Ec : R → R → R
Ec b y = y · y + b · y + 1r

Oc : R → R → R → R
Oc a c y = a · y + c

gc : R → R → R → R → R
gc a b c x = Ec b (x · x) + x · Oc a c (x · x)

gcm : R → R → R → R → R
gcm a b c x = Ec b (x · x) - x · Oc a c (x · x)

Hc : R → R → R → R → R
Hc a b c y = Ec b y · Ec b y - y · (Oc a c y · Oc a c y)

------------------------------------------------------------------------
-- 2.  The reflection identity  g(x) g(-x) = H(x^2)
--
-- This is the engine of the whole lane: it is what turns a divisibility
-- in x into one in y = x^2, halving the degree.  For the quintic it is a
-- degree-10 identity in five indeterminates.
------------------------------------------------------------------------

-- The identity is not special to degree 4 or 5: it is the difference of
-- squares in the parity decomposition, and holds for every polynomial at
-- once.  Proving it in this generic form is both cheaper and stronger
-- than proving the two instances separately.
reflect-generic : (e o x : R) → (e + x · o) · (e - x · o) ≡ e · e - (x · x) · (o · o)
reflect-generic = solve ℤCommRing

reflect-quintic : (a b c d x : R) → gq a b c d x · gqm a b c d x ≡ Hq a b c d (x · x)
reflect-quintic a b c d x = reflect-generic (Eq a c (x · x)) (Oq b d (x · x)) x

reflect-quartic : (a b c x : R) → gc a b c x · gcm a b c x ≡ Hc a b c (x · x)
reflect-quartic a b c x = reflect-generic (Ec b (x · x)) (Oc a c (x · x)) x

-- The stated coefficient forms really are the even and odd parts, i.e.
-- gq is literally the monic quintic with the advertised coefficients.
gq-coeffs : (a b c d x : R) →
  gq a b c d x
  ≡ x · x · x · x · x + a · (x · x · x · x) + b · (x · x · x)
    + c · (x · x) + d · x + 1r
gq-coeffs = solve ℤCommRing

gqm-coeffs : (a b c d x : R) → gqm a b c d x ≡ gq a b c d (- x)
gqm-coeffs = solve ℤCommRing

gc-coeffs : (a b c x : R) →
  gc a b c x ≡ x · x · x · x + a · (x · x · x) + b · (x · x) + c · x + 1r
gc-coeffs = solve ℤCommRing

gcm-coeffs : (a b c x : R) → gcm a b c x ≡ gc a b c (- x)
gcm-coeffs = solve ℤCommRing

------------------------------------------------------------------------
-- 3.  The two Sylvester determinants, computed exactly
--
-- QUINTIC_OBSTRUCTION.md (1.5) asserts
--
--     Res_y(O,E) = (1-ad)^2 - (c-ab)(b-cd)          for O = y^2+by+d,
--                                                       E = ay^2+cy+1
--
-- PARITY_RESULTANT.md (2.3) asserts
--
--     Res_y(O,E) = a^2 - abc + c^2                  for O = ay+c,
--                                                       E = y^2+by+1
--
-- Both are checked here in the two independent ways a resultant can be
-- presented: as the Sylvester determinant (Laplace-expanded, no root
-- extraction) and as the product of E over the roots of O (the form the
-- notes actually argue with).  Agreement of the two is not automatic --
-- it is the classical theorem -- so proving both pins the closed form
-- from either side and catches a sign or transposition error in either.
------------------------------------------------------------------------

-- the claimed closed forms
Dq : R → R → R → R → R
Dq a b c d = (1r - a · d) · (1r - a · d) - (c - a · b) · (b - c · d)

Dc : R → R → R → R
Dc a b c = a · a - a · (b · c) + c · c

-- 3a.  Sylvester determinants.
--
-- Syl(O,E) for two quadratics is the 4x4 matrix
--
--     [ 1 b d 0 ]
--     [ 0 1 b d ]
--     [ a c 1 0 ]
--     [ 0 a c 1 ]
--
-- expanded down the first column (only rows 1 and 3 are nonzero there);
-- the two 3x3 minors are written out by the rule of Sarrus.

private
  det3 : R → R → R → R → R → R → R → R → R → R
  det3 m₁₁ m₁₂ m₁₃ m₂₁ m₂₂ m₂₃ m₃₁ m₃₂ m₃₃ =
      m₁₁ · (m₂₂ · m₃₃ - m₂₃ · m₃₂)
    - m₁₂ · (m₂₁ · m₃₃ - m₂₃ · m₃₁)
    + m₁₃ · (m₂₁ · m₃₂ - m₂₂ · m₃₁)

-- 4x4 Sylvester determinant of (y^2+by+d , ay^2+cy+1), Laplace along
-- column 1: cofactor signs (+ at row 1, + at row 3).
sylQuintic : R → R → R → R → R
sylQuintic a b c d =
    det3 1r b d   c 1r 0r   a c 1r
  + a · det3 b d 0r   1r b d   a c 1r

syl-quintic-closed : (a b c d : R) → sylQuintic a b c d ≡ Dq a b c d
syl-quintic-closed = solve ℤCommRing

-- Syl(O,E) for O = ay+c (degree 1) and E = y^2+by+1 (degree 2) is 3x3:
--
--     [ a c 0 ]
--     [ 0 a c ]
--     [ 1 b 1 ]

sylQuartic : R → R → R → R
sylQuartic a b c = det3 a c 0r   0r a c   1r b 1r

syl-quartic-closed : (a b c : R) → sylQuartic a b c ≡ Dc a b c
syl-quartic-closed = solve ℤCommRing

-- 3b.  The same quantities as products over the roots of O.
--
-- Instead of postulating roots, we present them: for the quintic,
-- b and d are the elementary symmetric functions of two indeterminates
-- y1, y2 (b = -(y1+y2), d = y1 y2), and the identity says that the
-- product E(y1)E(y2) is the stated integer polynomial in a,b,c,d.

res-quintic-roots : (a c y₁ y₂ : R) →
    Eq a c y₁ · Eq a c y₂
  ≡ Dq a (- (y₁ + y₂)) c (y₁ · y₂)
res-quintic-roots = solve ℤCommRing

-- For the quartic, O = ay+c has the single root y₀ with a y₀ = -c, and
-- Res(O,E) = a^2 E(y₀).  Presenting the root as y₀ and c as -(a y₀):
res-quartic-root : (a b y₀ : R) →
    a · a · Ec b y₀ ≡ Dc a b (- (a · y₀))
res-quartic-root = solve ℤCommRing

------------------------------------------------------------------------
-- 4.  The Bezout / constant-even-part identity
--
-- PARITY_RESULTANT.md (5.1): writing a cofactor as q(x) = U(x^2)+x V(x^2),
-- the condition "the even part of g q is the constant 1" is exactly
--
--     E U + y O V = 1 .
--
-- The identity certified here is the algebraic step behind it: the even
-- and odd parts of the product g*q are (EU + y OV) and (EV + OU).
------------------------------------------------------------------------

split-even : (a b c d u v x : R) →
    gq a b c d x · (u + x · v)
  ≡ (Eq a c (x · x) · u + (x · x) · (Oq b d (x · x) · v))
    + x · (Eq a c (x · x) · v + Oq b d (x · x) · u)
split-even = solve ℤCommRing

------------------------------------------------------------------------
-- 5.  The norm of a prime-prefix polynomial
--
-- With P(x) = 1 + x A(x^2) -- the shape forced by "every prime above 2
-- is odd", so every exponent p-2 above the constant term is odd -- the
-- parity identity P(x) + P(-x) = 2 holds, and the reflection norm of P
-- is a polynomial in y alone:
--
--     P(x) P(-x) = 1 - y A(y)^2      at  y = x^2 .
--
-- This is the object the note calls N_X.  It depends on the cutoff only,
-- not on any candidate factor.
------------------------------------------------------------------------

parity-identity : (A x : R) → (1r + x · A) + (1r - x · A) ≡ 1r + 1r
parity-identity = solve ℤCommRing

norm-of-prefix : (A x : R) → (1r + x · A) · (1r - x · A) ≡ 1r - (x · x) · (A · A)
norm-of-prefix = solve ℤCommRing
