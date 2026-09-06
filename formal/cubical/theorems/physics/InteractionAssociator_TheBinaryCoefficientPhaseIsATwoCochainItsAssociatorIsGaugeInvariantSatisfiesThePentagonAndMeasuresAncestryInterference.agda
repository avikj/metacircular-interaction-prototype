{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- InteractionAssociator — the binary interaction coefficient c(p, q) of a
-- quadratic mode system (p + q → p + q) is a 2-cochain on the abelian
-- group of modes with values in a commutative ring, and the comparison
-- of the two binary derivations of p + q + r,
--
--     Ω(p,q,r) = c(p,q) c(p+q,r) / ( c(q,r) c(p,q+r) ),
--
-- is its coboundary.  Three facts, over any abelian group G of modes and
-- any commutative ring R, with Ω kept as a numerator/denominator pair
-- so that no inverse is needed:
--
--   §1  GAUGE INVARIANCE: under c(p,q) ↦ χ(p) χ(q) χ̄(p+q) c(p,q) with
--       χ χ̄ = 1, both numerator and denominator of Ω acquire the same
--       factor χ(p)χ(q)χ(r)χ̄(p+q+r), so Ω is unchanged as a ratio;
--   §2  THE PENTAGON:  N(p,q,r) N(p,q+r,s) N(q,r,s) · D(p+q,r,s) D(p,q,r+s)
--                    ≡ D(p,q,r) D(p,q+r,s) D(q,r,s) · N(p+q,r,s) N(p,q,r+s),
--       the cross-multiplied form of Ω(p,q,r)Ω(p,q+r,s)Ω(q,r,s) =
--       Ω(p+q,r,s)Ω(p,q,r+s); every c cancels, after the two
--       associativity rewrites (p+q)+r = p+(q+r), (q+r)+s = q+(r+s);
--   §3  INTERFERENCE: for path magnitudes X, Y and a unit phase ω with
--       ω ω̄ = 1, (X + Yω)(X + Yω̄) ≡ (X + Y)² − X·Y·(2 − ω − ω̄): the
--       squared ancestry amplitude is the independent-path envelope
--       (X + Y)² less exactly 2XY(1 − cos ϑ);
--   §4  over the Eisenstein integers ℤ[ω], ω² + ω + 1 = 0, at the value
--       Ω = ω = e^{2πi/3} of the orthogonal-cube channel with X = Y = 1:
--       (1 + ω)(1 + ω̄) = 1, so the amplitude is half the envelope.
--
-- READING.  The two derivations ((p q) r) and (p (q r)) of one Fourier
-- descendant are two coterminal histories; Ω is what an evaluator
-- valued in the ring's units sees between them.  It is a coboundary,
-- so its class in H³ is trivial wherever c is globally defined; a value
-- Ω ≠ 1 obstructs flattening c to an associative cocycle by a mode
-- gauge, and nothing more.  The pentagon says the comparisons around
-- the associahedron are coherent.
--
-- SYĀT.  Ring identities in the values of c, over an abstract abelian
-- group of modes; the Waleffe coefficient itself, its helical geometry,
-- and the Navier–Stokes equation are NOT here.  The numerical values on
-- the orthogonal cube were computed outside the kernel and enter only
-- as the instance in §4.
------------------------------------------------------------------------

module InteractionAssociator_TheBinaryCoefficientPhaseIsATwoCochainItsAssociatorIsGaugeInvariantSatisfiesThePentagonAndMeasuresAncestryInterference where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Algebra.AbGroup
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module Assoc {ℓ ℓ' : Level} (G : AbGroup ℓ) (R' : CommRing ℓ') where

  open AbGroupStr (G .snd) using (_+_) renaming (+Assoc to +AssocG)
  open CommRingStr (R' .snd) renaming (_+_ to _+r_ ; _·_ to _·r_ ; -_ to neg)

  private
    K : Type ℓ'
    K = fst R'
    M : Type ℓ
    M = ⟨ G ⟩

  -- a 2-cochain: the coefficient of the interaction p + q → p + q
  Cochain : Type (ℓ-max ℓ ℓ')
  Cochain = M → M → K

  -- the associator as a numerator/denominator pair
  N D : Cochain → M → M → M → K
  N c p q r = c p q ·r c (p + q) r
  D c p q r = c q r ·r c p (q + r)

  ----------------------------------------------------------------------
  -- §1  gauge invariance
  ----------------------------------------------------------------------

  gauge : (χ χ̄ : M → K) → Cochain → Cochain
  gauge χ χ̄ c p q = χ p ·r χ q ·r χ̄ (p + q) ·r c p q

  Unit : (χ χ̄ : M → K) → Type (ℓ-max ℓ ℓ')
  Unit χ χ̄ = ∀ x → χ x ·r χ̄ x ≡ 1r

  -- the common factor
  Φ : (χ χ̄ : M → K) → M → M → M → K
  Φ χ χ̄ p q r = χ p ·r χ q ·r χ r ·r χ̄ ((p + q) + r)

  N-gauge : (χ χ̄ : M → K) → Unit χ χ̄ → (c : Cochain) (p q r : M)
          → N (gauge χ χ̄ c) p q r ≡ Φ χ χ̄ p q r ·r N c p q r
  N-gauge χ χ̄ u c p q r =
    expand (χ p) (χ q) (χ̄ (p + q)) (c p q) (χ (p + q)) (χ r) (χ̄ ((p + q) + r)) (c (p + q) r)
    ∙ cong (λ v → v ·r (χ p ·r χ q ·r χ r ·r χ̄ ((p + q) + r) ·r (c p q ·r c (p + q) r))) (u (p + q))
    ∙ ·IdL _
    where
      expand : (a b b̄ x a' r' c̄ y : K)
             → (a ·r b ·r b̄ ·r x) ·r (a' ·r r' ·r c̄ ·r y) ≡ (a' ·r b̄) ·r (a ·r b ·r r' ·r c̄ ·r (x ·r y))
      expand a b b̄ x a' r' c̄ y = solve! R'

  D-gauge : (χ χ̄ : M → K) → Unit χ χ̄ → (c : Cochain) (p q r : M)
          → D (gauge χ χ̄ c) p q r ≡ Φ χ χ̄ p q r ·r D c p q r
  D-gauge χ χ̄ u c p q r =
    cong (λ z → gauge χ χ̄ c q r ·r (χ p ·r χ (q + r) ·r χ̄ z ·r c p (q + r))) (+AssocG p q r)
    ∙ expand (χ q) (χ r) (χ̄ (q + r)) (c q r) (χ p) (χ (q + r)) (χ̄ ((p + q) + r)) (c p (q + r))
    ∙ cong (λ v → v ·r (χ p ·r χ q ·r χ r ·r χ̄ ((p + q) + r) ·r (c q r ·r c p (q + r)))) (u (q + r))
    ∙ ·IdL _
    where
      expand : (b r' b̄ x a a' c̄ y : K)
             → (b ·r r' ·r b̄ ·r x) ·r (a ·r a' ·r c̄ ·r y) ≡ (a' ·r b̄) ·r (a ·r b ·r r' ·r c̄ ·r (x ·r y))
      expand b r' b̄ x a a' c̄ y = solve! R'

  -- hence, cross-multiplied, the gauged and ungauged associators agree
  Ω-gauge-invariant : (χ χ̄ : M → K) → Unit χ χ̄ → (c : Cochain) (p q r : M)
                    → N (gauge χ χ̄ c) p q r ·r D c p q r ≡ N c p q r ·r D (gauge χ χ̄ c) p q r
  Ω-gauge-invariant χ χ̄ u c p q r =
    cong (_·r D c p q r) (N-gauge χ χ̄ u c p q r)
    ∙ swap (Φ χ χ̄ p q r) (N c p q r) (D c p q r)
    ∙ cong (N c p q r ·r_) (sym (D-gauge χ χ̄ u c p q r))
    where
      swap : (f n d : K) → (f ·r n) ·r d ≡ n ·r (f ·r d)
      swap f n d = solve! R'

  ----------------------------------------------------------------------
  -- §2  the pentagon
  ----------------------------------------------------------------------

  pentagon : (c : Cochain) (p q r s : M)
           → N c p q r ·r N c p (q + r) s ·r N c q r s ·r (D c (p + q) r s ·r D c p q (r + s))
           ≡ D c p q r ·r D c p (q + r) s ·r D c q r s ·r (N c (p + q) r s ·r N c p q (r + s))
  pentagon c p q r s =
    -- align the associated atom c (p + (q + r)) s on the left …
    cong (λ x → N c p q r ·r (c p (q + r) ·r c x s) ·r N c q r s ·r (D c (p + q) r s ·r D c p q (r + s)))
         (+AssocG p q r)
    ∙ identity (c p q) (c (p + q) r) (c p (q + r)) (c ((p + q) + r) s) (c q r) (c (q + r) s)
               (c r s) (c (p + q) (r + s)) (c q (r + s)) (c p (q + (r + s)))
    -- … and the associated atom c p ((q + r) + s) on the right
    ∙ cong (λ y → D c p q r ·r (c (q + r) s ·r c p y) ·r D c q r s ·r (N c (p + q) r s ·r N c p q (r + s)))
           (+AssocG q r s)
    where
      identity : (a b d e f g h i j k : K)
               → (a ·r b) ·r (d ·r e) ·r (f ·r g) ·r ((h ·r i) ·r (j ·r k))
               ≡ (f ·r d) ·r (g ·r k) ·r (h ·r j) ·r ((b ·r e) ·r (a ·r i))
      identity a b d e f g h i j k = solve! R'

  ----------------------------------------------------------------------
  -- §3  interference
  ----------------------------------------------------------------------

  interference : (X Y ω ω̄ : K) → ω ·r ω̄ ≡ 1r
               → (X +r Y ·r ω) ·r (X +r Y ·r ω̄)
               ≡ (X +r Y) ·r (X +r Y) +r neg (X ·r Y ·r ((1r +r 1r) +r neg ω +r neg ω̄))
  interference X Y ω ω̄ u =
    expand X Y ω ω̄ ∙ cong (λ v → X ·r X +r Y ·r Y ·r v +r X ·r Y ·r (ω +r ω̄)) u ∙ regroup X Y ω ω̄
    where
      expand : (X Y ω ω̄ : K) → (X +r Y ·r ω) ·r (X +r Y ·r ω̄) ≡ X ·r X +r Y ·r Y ·r (ω ·r ω̄) +r X ·r Y ·r (ω +r ω̄)
      expand X Y ω ω̄ = solve! R'
      regroup : (X Y ω ω̄ : K) → X ·r X +r Y ·r Y ·r 1r +r X ·r Y ·r (ω +r ω̄)
                               ≡ (X +r Y) ·r (X +r Y) +r neg (X ·r Y ·r ((1r +r 1r) +r neg ω +r neg ω̄))
      regroup X Y ω ω̄ = solve! R'

------------------------------------------------------------------------
-- §4  the Eisenstein integers and the orthogonal-cube value
------------------------------------------------------------------------

-- a + b ω with ω² = −1 − ω
Eis : Type
Eis = ℤ × ℤ

open import Cubical.Data.Int using (_+_ ; _·_ ; -_)

_+e_ : Eis → Eis → Eis
(a , b) +e (c , d) = (a + c , b + d)

_·e_ : Eis → Eis → Eis
(a , b) ·e (c , d) = (a · c + (- (b · d)) , a · d + b · c + (- (b · d)))

ω ω̄ 1e : Eis
ω = (pos 0 , pos 1)
ω̄ = (negsuc 0 , negsuc 0)      -- ω̄ = ω² = −1 − ω
1e = (pos 1 , pos 0)

ω-unit : ω ·e ω̄ ≡ 1e
ω-unit = refl

-- X = Y = 1: the two-history amplitude squared is (1 + ω)(1 + ω̄) = 1,
-- against the envelope (1 + 1)² = 4: exactly one half in amplitude
cube-amplitude² : (1e +e ω) ·e (1e +e ω̄) ≡ 1e
cube-amplitude² = refl

envelope² : (1e +e 1e) ·e (1e +e 1e) ≡ (pos 4 , pos 0)
envelope² = refl
