{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CoprimePowers
--
-- `CRTChain` names the one missing piece: that the walk's installed prime
-- powers are pairwise coprime.  This is that piece's algebra, and the
-- algebra is all of it — no primality is needed, only that the BASES are
-- coprime.
--
-- ────────────────────────────────────────────────────────────────────
-- THE STATEMENT
--
-- Coprimality is carried as a Bézout pair, which is what Āryabhaṭa's
-- kuṭṭaka produces (`Kuttaka.bezout`, 499 CE, already checked here):
--
--     Bez a b  =  Σ x, Σ y,  a·x + b·y ≡ 1
--
-- and then
--
--     bez-mul       :  Bez a b → Bez a c → Bez a (b · c)
--     bez-pow       :  Bez a b → (n : ℕ) → Bez a (b ^ n)
--     coprime-powers:  Bez a b → (m n : ℕ) → Bez (a ^ m) (b ^ n)
--
-- `bez-mul` is one polynomial identity:
--
--     (ax + by)(au + cv)  =  a·(axu + cxv + byu)  +  (bc)·(yv)
--
-- so a Bézout certificate for `(a, bc)` is assembled from the two given
-- ones by multiplication.  Everything else is two inductions and a
-- symmetry.
--
-- Concretely, and this is the walk's own case: **8 and 9 are coprime
-- because 2 and 3 are**, with the certificate computed rather than
-- guessed (`bez-8-9`).
--
-- ────────────────────────────────────────────────────────────────────
-- WHY BÉZOUT AND NOT `gcd`
--
-- Because the kuṭṭaka produces a certificate, not a predicate.  Āryabhaṭa's
-- procedure returns the multipliers; `Kuttaka.bezout` returns them as a
-- term; and a certificate composes under multiplication by a ring
-- identity, where `isGCD` would need Euclid's lemma to do the same work.
-- Keeping the witness is what makes this module four theorems long
-- instead of a development.
--
-- That is the kuṭṭaka's own design: *"keep the remainder and recurse on
-- it"* returns a construction, and the construction is what composes.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS STILL MISSING, PRECISELY
--
-- The bridge from `Bez` over ℤ to `isGCD m n 1` over ℕ, which is what
-- `CRTChain.Coprimes` asks for.  It is the standard argument — a common
-- divisor of m and n divides `mx + ny = 1` — and it needs divisibility
-- transfer between ℕ and ℤ that this lane does not carry.  Named here so
-- the gap is one lemma with a name rather than a vague "number theory".
--
-- Also missing, and separately: that distinct PRIMES are coprime.  This
-- module assumes coprime bases and says nothing about how to get them;
-- for the walk's actual moduli they are computed one gcd at a time
-- (`CRTChain.walk8-coprimes`).
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module CoprimePowers where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)


------------------------------------------------------------------------
-- 1.  Coprimality as a kept certificate, over any commutative ring
------------------------------------------------------------------------

private
  variable
    ℓ : Level

module Bezout (R : CommRing ℓ) where

  open CommRingStr (snd R)

  A : Type ℓ
  A = fst R

  Bez : A → A → Type ℓ
  Bez a b = Σ[ x ∈ A ] Σ[ y ∈ A ] ((a · x) + (b · y) ≡ 1r)

  pow : A → ℕ → A
  pow a zero    = 1r
  pow a (suc n) = a · pow a n

  ----------------------------------------------------------------------
  -- 2.  The ring identities the whole module runs on
  ----------------------------------------------------------------------

  private
    symId : (a b x y : A) → (b · y) + (a · x) ≡ (a · x) + (b · y)
    symId a b x y = solve! R

    oneId : (a : A) → (a · 0r) + (1r · 1r) ≡ 1r
    oneId a = solve! R

    -- (ax + by)(au + cv) = a(axu + cxv + byu) + (bc)(yv)
    mulId : (a b c x y u v : A) →
        (a · (((a · x) · u) + (((c · x) · v) + ((b · y) · u))))
        + ((b · c) · (y · v))
      ≡ ((a · x) + (b · y)) · ((a · u) + (c · v))
    mulId a b c x y u v = solve! R

    unitId : (1r · 1r) ≡ 1r
    unitId = solve! R

  ----------------------------------------------------------------------
  -- 3.  The three closure laws
  ----------------------------------------------------------------------

  bez-sym : {a b : A} → Bez a b → Bez b a
  bez-sym {a} {b} (x , y , p) = y , x , symId a b x y ∙ p

  bez-one : (a : A) → Bez a 1r
  bez-one a = 0r , 1r , oneId a

  -- THE COMPOSITION.  One polynomial identity assembles the certificate.
  bez-mul : {a b c : A} → Bez a b → Bez a c → Bez a (b · c)
  bez-mul {a} {b} {c} (x , y , p) (u , v , q) =
      (((a · x) · u) + (((c · x) · v) + ((b · y) · u)))
    , (y · v)
    , ( mulId a b c x y u v
      ∙ cong₂ _·_ p q
      ∙ unitId )

  bez-pow : {a b : A} → Bez a b → (n : ℕ) → Bez a (pow b n)
  bez-pow {a} _   zero    = bez-one a
  bez-pow     bab (suc n) = bez-mul bab (bez-pow bab n)

  -- THE STATEMENT `CRTChain` asked for, modulo the ℕ bridge.
  coprime-powers : {a b : A} → Bez a b → (m n : ℕ) → Bez (pow a m) (pow b n)
  coprime-powers bab m n =
    bez-sym (bez-pow (bez-sym (bez-pow bab n)) m)

------------------------------------------------------------------------
-- 4.  The walk's own case, computed over ℤ.
--
--   2·(−1) + 3·1 = 1, so Bez 2 3;  hence Bez (2³) (3²), i.e. 8 and 9.
--
-- The certificate for 8 and 9 is not guessed — it is what
-- `coprime-powers` builds out of the certificate for 2 and 3.
------------------------------------------------------------------------

open Bezout ℤCommRing

bez-2-3 : Bez (pos 2) (pos 3)
bez-2-3 = negsuc 0 , pos 1 , refl

bez-8-9 : Bez (pow (pos 2) 3) (pow (pos 3) 2)
bez-8-9 = coprime-powers {a = pos 2} {b = pos 3} bez-2-3 3 2

-- and the bases really are 8 and 9
pow-2-3-is-8 : pow (pos 2) 3 ≡ pos 8
pow-2-3-is-8 = refl

pow-3-2-is-9 : pow (pos 3) 2 ≡ pos 9
pow-3-2-is-9 = refl

------------------------------------------------------------------------
-- 5.  What this closes and what it does not.
--
-- CLOSED: the composition law.  Coprimality of powers follows from
-- coprimality of bases by one ring identity plus two inductions, with the
-- Bézout witness carried throughout — which is the kuṭṭaka's output, not
-- a predicate reconstructed after the fact.
--
-- OPEN, and now named as one lemma each:
--   * `Bez a b → isGCD a b 1` over ℕ, to feed `CRTChain.Coprimes`;
--   * distinct primes are coprime, which no part of this module needs but
--     the walk's general frontier does.
------------------------------------------------------------------------
