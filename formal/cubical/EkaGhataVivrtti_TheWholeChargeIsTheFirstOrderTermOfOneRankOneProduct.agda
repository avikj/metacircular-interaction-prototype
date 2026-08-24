-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}
--
-- एक-घात-विवृत्तिः — one product, expanded to first order.
--
-- THE QUESTION THIS ASKS, and it is asked because nobody in this corpus has:
-- every rank statement about the squarefree prime charge is about EXACT
-- realization by t-independent products.  `PrimeChargeArbitraryRank` proves
-- rank exactly n; `PrimeChargeUnboundedLocalRank` proves no finite number of
-- channels serves all place sets.  Both quantify over sums of pure products
-- with constant coefficients.
--
-- Analysis never needs that.  An estimate needs an approximation with
-- controlled constants, and the gap between exact realization and
-- approximation is where a whole class of constructions lives — for tensors
-- it is the gap between rank and border rank, and the phrase "border rank"
-- appears nowhere in this corpus.
--
-- Asked and answered here in a form sharper than a limit: not a degenerating
-- family, an identity.
module EkaGhataVivrtti_TheWholeChargeIsTheFirstOrderTermOfOneRankOneProduct where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; true; false)
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Int using (ℤ; pos; -_; _+_; _·_; +Comm; ·Comm)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)

open import OjaYugma_TheSquarefreeChargeIsTheActivePlaceCountTimesTheParityCharacter
  using (चिह्नम्; सक्रियम्; ओजः; पर्यायः; आवेशः)

-- ------------------------------------------------------- the one product
-- ONE pure product over the places, with one parameter in it.  At t = 0 it
-- is the parity character; the claim is about its first-order term.
घातः : ℤ → List Bool → ℤ
घातः t [] = pos (suc zero)
घातः t (b ∷ bs) = (चिह्नम् b + सक्रियम् b · t) · घातः t bs

-- everything of order t² and beyond, defined rather than estimated.
शेषः : ℤ → List Bool → ℤ
शेषः t [] = pos zero
शेषः t (b ∷ bs) =
  (चिह्नम् b · शेषः t bs) + ((सक्रियम् b · आवेशः bs) + ((सक्रियम् b · शेषः t bs) · t))

-- ------------------------------------------------------ the ring identity
-- One step of the expansion, as a bare polynomial identity in six variables.
पद-विस्तारः : (c s t p a r : ℤ)
  → (c + s · t) · (p + ((a · t) + (r · (t · t))))
    ≡ (c · p) + ((((s · p) + (c · a)) · t)
                 + (((c · r) + ((s · a) + ((s · r) · t))) · (t · t)))
पद-विस्तारः = solve ℤCommRing

-- ---------------------------------------------------------- the statement
--
--     घातः t bs  ≡  पर्यायः bs  +  आवेशः bs · t  +  शेषः t bs · t²
--
-- ONE rank-one product carries the parity character as its constant term and
-- THE ENTIRE n-place charge as its first-order term.  No limit is taken and
-- no coefficient blows up: the remainder is an explicit polynomial.
घात-विवृत्तिः : (t : ℤ) (bs : List Bool)
  → घातः t bs ≡ पर्यायः bs + ((आवेशः bs · t) + (शेषः t bs · (t · t)))
घात-विवृत्तिः t [] = refl
घात-विवृत्तिः t (b ∷ bs) =
  cong ((चिह्नम् b + सक्रियम् b · t) ·_) (घात-विवृत्तिः t bs)
  ∙ पद-विस्तारः (चिह्नम् b) (सक्रियम् b) t (पर्यायः bs) (आवेशः bs) (शेषः t bs)

-- ---------------------------------------------------------------- मर्यादा
--
-- WHAT THIS DOES AND DOES NOT SAY, because the two are easy to run together.
--
-- It does NOT contradict `squarefreeChargeCube_rankExactly n`.  That theorem
-- counts realizations of the charge as a sum of pure products with CONSTANT
-- coefficients, and n of them are needed, for every n.  A one-parameter
-- family read at its first order is not in that class, so the rank theorems
-- stand exactly as stated and say nothing about this.
--
-- What it says is that the class was the limitor.  One product, one
-- parameter, one derivative, and the whole n-place charge is there — with an
-- explicit remainder rather than a limit, so nothing blows up and no
-- constant is hidden.  This is the border-rank phenomenon (the `W` tensor
-- has rank n and border rank 2) written as an identity instead of a
-- degeneration.
--
-- And the parameter carries more than the charge.  घातः t bs is a polynomial
-- in t whose k-th coefficient is the sum over k-marked places; the charge is
-- k = 1 and पर्यायः is k = 0.  A rank obstruction applies to each coefficient
-- separately.  None of them applies to the product that generates all of
-- them at once.
--
-- NOT here: any analytic claim.  Whether a Kuznetsov-type kernel admits the
-- corresponding parameter — a derivative in a spectral variable of a single
-- separable kernel — is a question about that kernel and not about this
-- identity.  What this removes is the belief that the rank theorems already
-- forbid it.

-- ------------------------------------------------------------- the tower
-- The machine's own reading of this residue, asked of `garbha.dhara` with
-- the two standpoints — "n constant-coefficient products are needed" and
-- "one product carries it at first order" — was a stream in which every born
-- position keeps the second standpoint as its base and adds ONE MORE Arpita,
-- forking asserted/withheld at the tip.  The rank standpoint drops out of
-- the born pair after the first birth.
--
-- Arpita^k is reading to order k.  The stream is the expansion, and it says
-- the object to define next is the k-marked charge — which is what follows.

-- the k-marked charge: choose k places to be active-marked, sign the rest.
-- k = 0 is the parity character; k = 1 is the squarefree charge.
विवृत्तिः : List Bool → ℕ → ℤ
विवृत्तिः [] zero = pos (suc zero)
विवृत्तिः [] (suc k) = pos zero
विवृत्तिः (b ∷ bs) zero = चिह्नम् b · विवृत्तिः bs zero
विवृत्तिः (b ∷ bs) (suc k) =
  चिह्नम् b · विवृत्तिः bs (suc k) + सक्रियम् b · विवृत्तिः bs k

-- level 0 IS the parity character
विवृत्ति-शून्यम् : (bs : List Bool) → विवृत्तिः bs zero ≡ पर्यायः bs
विवृत्ति-शून्यम् [] = refl
विवृत्ति-शून्यम् (b ∷ bs) = cong (चिह्नम् b ·_) (विवृत्ति-शून्यम् bs)

-- level 1 IS the squarefree charge
विवृत्ति-एकम् : (bs : List Bool) → विवृत्तिः bs (suc zero) ≡ आवेशः bs
विवृत्ति-एकम् [] = refl
विवृत्ति-एकम् (b ∷ bs) =
  cong₂ _+_ (cong (चिह्नम् b ·_) (विवृत्ति-एकम् bs))
            (cong (सक्रियम् b ·_) (विवृत्ति-शून्यम् bs))
  ∙ +Comm (चिह्नम् b · आवेशः bs) (सक्रियम् b · पर्यायः bs)

-- and the remainder of घातः, read at t = 0, is level 2 — so the parameter is
-- generating the tower and not merely its first two rungs.
विवृत्ति-द्वयम् : (bs : List Bool)
  → शेषः (pos zero) bs ≡ विवृत्तिः bs (suc (suc zero))
विवृत्ति-द्वयम् [] = refl
विवृत्ति-द्वयम् (b ∷ bs) =
  cong (λ z → चिह्नम् b · शेषः (pos zero) bs + (सक्रियम् b · आवेशः bs + z))
       (·Comm (सक्रियम् b · शेषः (pos zero) bs) (pos zero))
  ∙ cong₂ _+_ (cong (चिह्नम् b ·_) (विवृत्ति-द्वयम् bs))
              (cong (सक्रियम् b ·_) (sym (विवृत्ति-एकम् bs)))
