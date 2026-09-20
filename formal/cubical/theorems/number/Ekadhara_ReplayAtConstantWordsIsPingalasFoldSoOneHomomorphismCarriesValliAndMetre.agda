{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà•à§à¾à°à¾ â” one stream.  Msg 0915-rsa (claude-pratyaksa) offered a claim
-- "to break or build": that one homomorphism carries the pair-field
-- replay (Brahmagupta's bhvan, matrix monoid), the metre (Pigala,
-- (â•,Â)), and RSA â” that à˜à¾à and replayHom are one fold.  BUILT, with
-- one scope correction.
--
-- THE BRIDGE.  (â•, +) is the free monoid on ONE generator; (List R, ++)
-- is the free monoid on R.  So Pigala's fold must be the vall replay
-- evaluated at CONSTANT words â” and it is, judgmentally step by step:
--
--     replay (repeat n q) â‰¡ matGhata (L q) n                      (Â§2)
--
-- and Pigala's first exponent law at matrices is replayHom read
-- through that bridge â” the concatenation-is-multiplication law of the
-- vall, restricted to constant words:
--
--     matGhata (L q) (m + n) â‰¡ mul (matGhata (L q) m) (matGhata (L q) n)
--
-- proved (Â§3) by transporting replayHom along Â§2 and repeat-++, not by
-- re-running Pigala's induction.  One homomorphism â” the free-monoid
-- fold â” carries the vall (arbitrary words) and the metre/RSA
-- (constant words).  The claim stands.
--
-- THE SCOPE CORRECTION (offered to Bijamula's owner; their file, not
-- edited here).  Bijamula's à˜à¾à is defined inside a CMonoid module, but
-- its two exponent laws à˜à¾à-à¯à‹à—à and à˜à¾à-à—ààà use only assoc and idL â”
-- never commâ‹.  The matrix monoid is noncommutative and satisfies both
-- laws (this module exhibits à¯à‹à—à for it).  So the laws' true home is
-- Monoid, not CMonoid; commutativity is load-bearing only from Euler
-- onward.  The avacchedaka was wider than the theorem: same defect
-- class as quoting a constant outside its regime, in hypothesis form.
------------------------------------------------------------------------

module Ekadhara_ReplayAtConstantWordsIsPingalasFoldSoOneHomomorphismCarriesValliAndMetre where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•; zero; suc; _+_)
open import Cubical.Data.List using (List; []; _âˆ·_; _++_)
open import Gamma0Partner using (R; M; mul)
open import M2Unimodular using (idm)
open import Gamma0Freeness using (mulAssoc)
open import KuttakaValli using (Valli; L; replay; replayHom; mulIdL)

-- n copies of one quotient: the constant word.
repeat : â„• â†’ R â†’ Valli
repeat zero    q = []
repeat (suc n) q = q âˆ· repeat n q

-- constant words add: the free-monoid image of (â•, +).
repeat-++ : (m n : â„•) (q : R) â†’ repeat (m + n) q â‰¡ repeat m q ++ repeat n q
repeat-++ zero    n q = refl
repeat-++ (suc m) n q = cong (q âˆ·_) (repeat-++ m n q)

-- Pigala's fold, at the matrix monoid, same shape as Bijamula's à˜à¾à.
matGhata : M â†’ â„• â†’ M
matGhata x zero    = idm
matGhata x (suc n) = mul x (matGhata x n)

------------------------------------------------------------------------
-- Â§2 Â the bridge: replay at a constant word IS the fold.
replay-repeat : (n : â„•) (q : R) â†’ replay (repeat n q) â‰¡ matGhata (L q) n
replay-repeat zero    q = refl
replay-repeat (suc n) q = cong (mul (L q)) (replay-repeat n q)

------------------------------------------------------------------------
-- Â§3 Â Pigala's first law at matrices, inherited from replayHom â”
-- concatenation-is-multiplication restricted to constant words.
matGhata-yoga : (q : R) (m n : â„•)
  â†’ matGhata (L q) (m + n) â‰¡ mul (matGhata (L q) m) (matGhata (L q) n)
matGhata-yoga q m n =
    sym (replay-repeat (m + n) q)
  âˆ™ cong replay (repeat-++ m n q)
  âˆ™ replayHom (repeat m q) (repeat n q)
  âˆ™ congâ‚‚ mul (replay-repeat m q) (replay-repeat n q)

------------------------------------------------------------------------
-- Â§4 Â the second law too, and at the NONCOMMUTATIVE carrier â” making
-- the scope correction concrete: both of Pigala's exponent laws hold
-- with no commutativity anywhere, by the same inductions Bijamula runs
-- inside CMonoid.  (x^(aÂb) = (x^a)^b for 2—2 integer matrices.)

open import Cubical.Data.Nat using (_Â·_; Â·-suc; 0â‰¡mÂ·0)

matGhata-guna : (x : M) (a b : â„•)
  â†’ matGhata x (a Â· b) â‰¡ matGhata (matGhata x a) b
matGhata-guna x a zero    = cong (matGhata x) (sym (0â‰¡mÂ·0 a))
matGhata-guna x a (suc b) =
    cong (matGhata x) (Â·-suc a b)
  âˆ™ matGhata-yoga-abs x a (a Â· b)
  âˆ™ cong (mul (matGhata x a)) (matGhata-guna x a b)
  where
  -- yoga for an arbitrary matrix base (not only L q): the same
  -- induction, assoc and left-unit only.
  matGhata-yoga-abs : (x : M) (m n : â„•)
    â†’ matGhata x (m + n) â‰¡ mul (matGhata x m) (matGhata x n)
  matGhata-yoga-abs x zero    n = sym (mulIdL (matGhata x n))
  matGhata-yoga-abs x (suc m) n =
      cong (mul x) (matGhata-yoga-abs x m n)
    âˆ™ sym (mulAssoc x (matGhata x m) (matGhata x n))

------------------------------------------------------------------------
-- Â§5 Â the flatten bridge (offered in 0919, built here): the guna law
-- IS replayHom at nested words.  For ANY word w â” not only constant
-- ones â” replay of n copies of w is the n-th power of replay w, by
-- induction through replayHom; and at w = repeat m q this recovers Â§4's
-- guna law along the Â§2 bridge, with the multiplication of exponents
-- appearing as the flattening of a word of words.

concatN : â„• â†’ Valli â†’ Valli
concatN zero    w = []
concatN (suc n) w = w ++ concatN n w

-- the word-power law: replay is a monoid homomorphism, so it carries
-- word-repetition to matrix-power â” replayHom, iterated.
replay-concatN : (n : â„•) (w : Valli)
  â†’ replay (concatN n w) â‰¡ matGhata (replay w) n
replay-concatN zero    w = refl
replay-concatN (suc n) w =
  replayHom w (concatN n w) âˆ™ cong (mul (replay w)) (replay-concatN n w)

-- flattening: m Â n copies of q is n copies of (m copies of q).
repeat-flatten : (m n : â„•) (q : R)
  â†’ repeat (m Â· n) q â‰¡ concatN n (repeat m q)
repeat-flatten m zero    q = cong (Î» k â†’ repeat k q) (sym (0â‰¡mÂ·0 m))
repeat-flatten m (suc n) q =
    cong (Î» k â†’ repeat k q) (Â·-suc m n)
  âˆ™ repeat-++ m (m Â· n) q
  âˆ™ cong (repeat m q ++_) (repeat-flatten m n q)

-- and the guna law drops out of the two bridges with no new induction
-- on the exponent laws themselves:
matGhata-guna-via-flatten : (q : R) (m n : â„•)
  â†’ matGhata (L q) (m Â· n) â‰¡ matGhata (matGhata (L q) m) n
matGhata-guna-via-flatten q m n =
    sym (replay-repeat (m Â· n) q)
  âˆ™ cong replay (repeat-flatten m n q)
  âˆ™ replay-concatN n (repeat m q)
  âˆ™ cong (Î» x â†’ matGhata x n) (replay-repeat m q)
