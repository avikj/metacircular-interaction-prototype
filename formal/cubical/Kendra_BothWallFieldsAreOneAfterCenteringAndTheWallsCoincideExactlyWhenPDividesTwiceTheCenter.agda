-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- केन्द्रम् — both wall fields are one after centering, and the two walls
-- coincide exactly when p divides twice the center.
--
-- THE CENTERING, checked as type equality — not equivalence, EQUALITY.
-- Goldbach's local condition at an odd prime p for the even number
-- N = 2m is two walls on the summand x:
--
--     x ≢ 0 (mod p)   and   x ≢ N (mod p).
--
-- Substitute x = m + y — measure from the center — and the two walls
-- become the SYMMETRIC pair y ≢ ±m (mod p).  The twin condition
-- n ≢ 0, −2 (mod p) under y = n + 1 becomes y ≢ ±1 (mod p).  Both
-- problems inhabit the one two-wall field
--
--     क्षेत्रम् p a y  =  ¬ p ∣ (y − a)  ×  ¬ p ∣ (y + a),
--
-- Goldbach at a = m = N/2, twins at a = 1.  Here the two substitutions
-- are PATHS between the wall types (गोल-केन्द्रीकरणम्, यमल-केन्द्रीकरणम्):
-- the centered field is not analogous to the uncentered conditions, it
-- is the same type transported along ring identities of ℤ.
--
-- AND THE DEGENERACY IS AN IFF (भित्ति-सङ्गमः / भित्ति-भेदः): the two walls
-- impose the same condition for every y exactly when p ∣ 2a = a + a.
-- Forward: if p ∣ a+a, each wall shifts onto the other by that multiple.
-- Converse: instantiate y = a; the lower wall is p ∣ 0, trivially
-- inhabited, so wall-agreement at that point forces p ∣ a+a.  This is
-- the exact support of the mean-field dichotomy: the local factor is
-- (1 − 2/p) where the walls are distinct and (1 − 1/p) where they merge
-- — the numerators p−2 and p−1 count survivors per period.
--
-- ON THE NAME.  केन्द्र (kendra) is the siddhāntas' own technical term for
-- the anomaly — the angular coordinate measured FROM THE CENTER (a Greek
-- loan, κέντρον, fully absorbed: Sūryasiddhānta; Brahmagupta's
-- manda-kendra, Brāhmasphuṭasiddhānta, 628).  It names exactly this
-- module's move: replace the raw coordinate by the deviation from the
-- mean point and the symmetry appears.  No claim that any siddhānta
-- treats sieve walls; the term is used for its literal geometric
-- content.  The centered field was stated by the owner this session,
-- 2026-08-23; the type-level identities are built here.
--
-- दोषलेखः, scope.  Exact and local: the affine normalization and the
-- wall dichotomy, over ℤ with divisibility as data (Σ, untruncated).
-- NOT built: the per-period survivor counts p−2 / p−1 as cardinality
-- theorems, the Fourier crystal r_{p,a}, the CRT ray decomposition, and
-- the signed inequality over rays — named as the open frame, in order.
------------------------------------------------------------------------

module Kendra_BothWallFieldsAreOneAfterCenteringAndTheWallsCoincideExactlyWhenPDividesTwiceTheCenter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int
  using ( ℤ ; pos ; negsuc ; _+_ ; _-_ ; -_ ; _·_
        ; +Comm ; +Assoc ; -Dist+ ; minusPlus ; plusMinus ; -Cancel
        ; ·DistL+ ; -DistL· )
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- १ · divisibility as data, and the universal two-wall field.
------------------------------------------------------------------------

_∣_ : ℤ → ℤ → Type
d ∣ k = Σ[ c ∈ ℤ ] c · d ≡ k

क्षेत्रम् : (p a y : ℤ) → Type
क्षेत्रम् p a y = (¬ p ∣ (y - a)) × (¬ p ∣ (y + a))

------------------------------------------------------------------------
-- २ · गोल-केन्द्रीकरणम् — Goldbach's two walls at N = m + m, centered.
-- The uncentered condition on the summand x = m + y IS the field at
-- center m: a path of types, componentwise along ring identities.
------------------------------------------------------------------------

गोल-भित्ती : (p m x : ℤ) → Type
गोल-भित्ती p m x = (¬ p ∣ (x - (m + m))) × (¬ p ∣ x)

गोल-केन्द्रीकरणम् : (p m y : ℤ) → गोल-भित्ती p m (m + y) ≡ क्षेत्रम् p m y
गोल-केन्द्रीकरणम् p m y i =
  (¬ p ∣ ऊन i) × (¬ p ∣ अधिक i)
  where
    -- (m + y) − (m + m) ≡ y − m
    ऊन : (m + y) - (m + m) ≡ y - m
    ऊन = cong ((m + y) +_) (-Dist+ m m)
       ∙ +Assoc (m + y) (- m) (- m)
       ∙ cong (_+ (- m))
           ( cong (_+ (- m)) (+Comm m y)
           ∙ plusMinus m y )
    -- m + y ≡ y + m
    अधिक : m + y ≡ y + m
    अधिक = +Comm m y

------------------------------------------------------------------------
-- ३ · यमल-केन्द्रीकरणम् — the twin walls n ≢ 0, −2, centered at y = n + 1.
-- The same field at center 1.
------------------------------------------------------------------------

यमल-भित्ती : (p n : ℤ) → Type
यमल-भित्ती p n = (¬ p ∣ n) × (¬ p ∣ (n + pos 2))

यमल-केन्द्रीकरणम् : (p n : ℤ) → यमल-भित्ती p n ≡ क्षेत्रम् p (pos 1) (n + pos 1)
यमल-केन्द्रीकरणम् p n i =
  (¬ p ∣ ऊन i) × (¬ p ∣ अधिक i)
  where
    -- n ≡ (n + 1) − 1
    ऊन : n ≡ (n + pos 1) - pos 1
    ऊन = sym (plusMinus (pos 1) n)
    -- n + 2 ≡ (n + 1) + 1, by associativity (definitionally close)
    अधिक : n + pos 2 ≡ (n + pos 1) + pos 1
    अधिक = +Assoc n (pos 1) (pos 1)

------------------------------------------------------------------------
-- ४ · the dichotomy: the walls coincide for every y iff p ∣ a + a.
------------------------------------------------------------------------

-- forward: p ∣ a + a lets each wall slide onto the other.
भित्ति-सङ्गमः : (p a : ℤ) → p ∣ (a + a)
             → (y : ℤ) → (p ∣ (y - a) → p ∣ (y + a)) × (p ∣ (y + a) → p ∣ (y - a))
भित्ति-सङ्गमः p a (c , cp) y = ऊर्ध्वम् , अधः
  where
    -- (y − a) + (a + a) ≡ y + a
    सेतुः : (y - a) + (a + a) ≡ y + a
    सेतुः = +Assoc (y - a) a a ∙ cong (_+ a) (minusPlus a y)
    ऊर्ध्वम् : p ∣ (y - a) → p ∣ (y + a)
    ऊर्ध्वम् (d , dp) =
      d + c , ·DistL+' ∙ cong₂ _+_ dp cp ∙ सेतुः
      where
        ·DistL+' : (d + c) · p ≡ d · p + c · p
        ·DistL+' = ·DistL+ d c p
    अधः : p ∣ (y + a) → p ∣ (y - a)
    अधः (d , dp) =
      d - c , ·DistL+'' ∙ cong₂ _+_ dp (-DistL·' ∙ cong -_ cp)
              ∙ sym (चालनम्)
      where
        ·DistL+'' : (d - c) · p ≡ d · p + (- c) · p
        ·DistL+'' = ·DistL+ d (- c) p
        -DistL·' : (- c) · p ≡ - (c · p)
        -DistL·' = sym (-DistL· c p)
        -- (y − a) ≡ (y + a) + −(a + a)
        चालनम् : y - a ≡ (y + a) + - (a + a)
        चालनम् = sym ( cong ((y + a) +_) (-Dist+ a a)
                    ∙ +Assoc (y + a) (- a) (- a)
                    ∙ cong (_+ (- a)) (plusMinus a y) )

-- converse: agreement at the single point y = a already forces p ∣ a + a.
भित्ति-भेदः : (p a : ℤ) → ((y : ℤ) → p ∣ (y - a) → p ∣ (y + a)) → p ∣ (a + a)
भित्ति-भेदः p a slide =
  slide a (pos 0 , शून्यम्)
  where
    -- 0 · p ≡ a − a
    शून्यम् : pos 0 · p ≡ a - a
    शून्यम् = sym (-Cancel a)
