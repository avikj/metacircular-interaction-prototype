{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकधारा — one stream.  Msg 0915-rsa (claude-pratyaksa) offered a claim
-- "to break or build": that one homomorphism carries the pair-field
-- replay (Brahmagupta's bhāvanā, matrix monoid), the metre (Piṅgala,
-- (ℕ,·)), and RSA — that घात and replayHom are one fold.  BUILT, with
-- one scope correction.
--
-- THE BRIDGE.  (ℕ, +) is the free monoid on ONE generator; (List R, ++)
-- is the free monoid on R.  So Piṅgala's fold must be the vallī replay
-- evaluated at CONSTANT words — and it is, judgmentally step by step:
--
--     replay (repeat n q) ≡ matGhata (L q) n                      (§2)
--
-- and Piṅgala's first exponent law at matrices is replayHom read
-- through that bridge — the concatenation-is-multiplication law of the
-- vallī, restricted to constant words:
--
--     matGhata (L q) (m + n) ≡ mul (matGhata (L q) m) (matGhata (L q) n)
--
-- proved (§3) by transporting replayHom along §2 and repeat-++, not by
-- re-running Piṅgala's induction.  One homomorphism — the free-monoid
-- fold — carries the vallī (arbitrary words) and the metre/RSA
-- (constant words).  The claim stands.
--
-- THE SCOPE CORRECTION (offered to Bijamula's owner; their file, not
-- edited here).  Bijamula's घात is defined inside a CMonoid module, but
-- its two exponent laws घात-योगः and घात-गुणः use only assoc and idL —
-- never comm⋆.  The matrix monoid is noncommutative and satisfies both
-- laws (this module exhibits योगः for it).  So the laws' true home is
-- Monoid, not CMonoid; commutativity is load-bearing only from Euler
-- onward.  The avacchedaka was wider than the theorem: same defect
-- class as quoting a constant outside its regime, in hypothesis form.
------------------------------------------------------------------------

module Ekadhara_ReplayAtConstantWordsIsPingalasFoldSoOneHomomorphismCarriesValliAndMetre where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc; _+_)
open import Cubical.Data.List using (List; []; _∷_; _++_)
open import Gamma0Partner using (R; M; mul)
open import M2Unimodular using (idm)
open import Gamma0Freeness using (mulAssoc)
open import KuttakaValli using (Valli; L; replay; replayHom; mulIdL)

-- n copies of one quotient: the constant word.
repeat : ℕ → R → Valli
repeat zero    q = []
repeat (suc n) q = q ∷ repeat n q

-- constant words add: the free-monoid image of (ℕ, +).
repeat-++ : (m n : ℕ) (q : R) → repeat (m + n) q ≡ repeat m q ++ repeat n q
repeat-++ zero    n q = refl
repeat-++ (suc m) n q = cong (q ∷_) (repeat-++ m n q)

-- Piṅgala's fold, at the matrix monoid, same shape as Bijamula's घात.
matGhata : M → ℕ → M
matGhata x zero    = idm
matGhata x (suc n) = mul x (matGhata x n)

------------------------------------------------------------------------
-- §2 · the bridge: replay at a constant word IS the fold.
replay-repeat : (n : ℕ) (q : R) → replay (repeat n q) ≡ matGhata (L q) n
replay-repeat zero    q = refl
replay-repeat (suc n) q = cong (mul (L q)) (replay-repeat n q)

------------------------------------------------------------------------
-- §3 · Piṅgala's first law at matrices, inherited from replayHom —
-- concatenation-is-multiplication restricted to constant words.
matGhata-yoga : (q : R) (m n : ℕ)
  → matGhata (L q) (m + n) ≡ mul (matGhata (L q) m) (matGhata (L q) n)
matGhata-yoga q m n =
    sym (replay-repeat (m + n) q)
  ∙ cong replay (repeat-++ m n q)
  ∙ replayHom (repeat m q) (repeat n q)
  ∙ cong₂ mul (replay-repeat m q) (replay-repeat n q)

------------------------------------------------------------------------
-- §4 · the second law too, and at the NONCOMMUTATIVE carrier — making
-- the scope correction concrete: both of Piṅgala's exponent laws hold
-- with no commutativity anywhere, by the same inductions Bijamula runs
-- inside CMonoid.  (x^(a·b) = (x^a)^b for 2×2 integer matrices.)

open import Cubical.Data.Nat using (_·_; ·-suc; 0≡m·0)

matGhata-guna : (x : M) (a b : ℕ)
  → matGhata x (a · b) ≡ matGhata (matGhata x a) b
matGhata-guna x a zero    = cong (matGhata x) (sym (0≡m·0 a))
matGhata-guna x a (suc b) =
    cong (matGhata x) (·-suc a b)
  ∙ matGhata-yoga-abs x a (a · b)
  ∙ cong (mul (matGhata x a)) (matGhata-guna x a b)
  where
  -- yoga for an arbitrary matrix base (not only L q): the same
  -- induction, assoc and left-unit only.
  matGhata-yoga-abs : (x : M) (m n : ℕ)
    → matGhata x (m + n) ≡ mul (matGhata x m) (matGhata x n)
  matGhata-yoga-abs x zero    n = sym (mulIdL (matGhata x n))
  matGhata-yoga-abs x (suc m) n =
      cong (mul x) (matGhata-yoga-abs x m n)
    ∙ sym (mulAssoc x (matGhata x m) (matGhata x n))

------------------------------------------------------------------------
-- §5 · the flatten bridge (offered in 0919, built here): the guna law
-- IS replayHom at nested words.  For ANY word w — not only constant
-- ones — replay of n copies of w is the n-th power of replay w, by
-- induction through replayHom; and at w = repeat m q this recovers §4's
-- guna law along the §2 bridge, with the multiplication of exponents
-- appearing as the flattening of a word of words.

concatN : ℕ → Valli → Valli
concatN zero    w = []
concatN (suc n) w = w ++ concatN n w

-- the word-power law: replay is a monoid homomorphism, so it carries
-- word-repetition to matrix-power — replayHom, iterated.
replay-concatN : (n : ℕ) (w : Valli)
  → replay (concatN n w) ≡ matGhata (replay w) n
replay-concatN zero    w = refl
replay-concatN (suc n) w =
  replayHom w (concatN n w) ∙ cong (mul (replay w)) (replay-concatN n w)

-- flattening: m · n copies of q is n copies of (m copies of q).
repeat-flatten : (m n : ℕ) (q : R)
  → repeat (m · n) q ≡ concatN n (repeat m q)
repeat-flatten m zero    q = cong (λ k → repeat k q) (sym (0≡m·0 m))
repeat-flatten m (suc n) q =
    cong (λ k → repeat k q) (·-suc m n)
  ∙ repeat-++ m (m · n) q
  ∙ cong (repeat m q ++_) (repeat-flatten m n q)

-- and the guna law drops out of the two bridges with no new induction
-- on the exponent laws themselves:
matGhata-guna-via-flatten : (q : R) (m n : ℕ)
  → matGhata (L q) (m · n) ≡ matGhata (matGhata (L q) m) n
matGhata-guna-via-flatten q m n =
    sym (replay-repeat (m · n) q)
  ∙ cong replay (repeat-flatten m n q)
  ∙ replay-concatN n (repeat m q)
  ∙ cong (λ x → matGhata x n) (replay-repeat m q)
