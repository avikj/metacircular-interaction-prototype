-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- वर्गप्रकृति-वर्ग — the norm-one rows of वर्गप्रकृति are a MONOID under
-- भावना (composition), commutative, with identity (1, 0).
--
-- SOURCE.
--
--   Brahmagupta, *Brāhmasphuṭasiddhānta*, chapter 18 (कुट्टकाध्याय), 628
--   CE — भावना, the composition law for वर्गप्रकृति (a² − D·b² = k), whose
--   arithmetic content (भावना-क्षेपः, Brahmagupta's identity) is proved in
--   Punaragamana.Bhavana_TheKsepaIsDeterminedByTheRootsAndCompositionMultipliesIt.
--
-- WHAT IS CLAIMED, AND WHAT IS NOT.  The monoid reading below — that the
-- norm-one solutions of a fixed वर्गप्रकृति D close under भावना, with
-- identity (1,0) and भावना commutative — is a MODERN algebraic reading of
-- the material, not attributed to Brahmagupta, Jayadeva or Bhāskara II as a
-- stated theorem of theirs.  What IS theirs, and is the actual content used
-- here, is the कुट्टक chapter's भावना itself and its norm-multiplying
-- property.  This module packages that property into the closure,
-- identity, and commutativity clauses of a monoid — the algebraic reason
-- the चक्रवाल (Jayadeva c. 950 / Bhāskara II, *Bījagaṇita*, 1150) can climb
-- a ladder of solutions once it has found ONE row of क्षेप = 1: composing
-- that row with itself, repeatedly, never leaves the norm-one set.
--
-- ASSOCIATIVITY is NOT proved here.  भावना (p,q) is applied to a base pair
-- via a curried "row acting on a row" shape (D fixed, then (p,q), then the
-- acted-on pair); a three-fold composition needs a term of the SAME shape
-- for "the row भावना(p,q)(r,s) obtained by composing two rows" before
-- associativity can even be TYPED against भावना (a,b), and building that
-- term is exactly formalising Brahmagupta's other remark — that भावना
-- applied to two rows produces a THIRD row, not just a pair-transforming
-- endomorphism — which the cited module deliberately leaves undone (see its
-- "SECOND DEFECT" discussion of scope).  Left as an explicit open goal
-- below, stated and not faked.  What IS proved — commutativity, closure,
-- and two-sided identity — is exactly the content that does NOT need that
-- extra shape: all three are stated for the endomorphism भावना(p,q)(a,b)
-- directly, as propositional equalities of ℤ×ℤ pairs.
------------------------------------------------------------------------

module Punaragamana.VargaPrakrtiVarga_TheNormOneSolutionsAreAMonoidUnderBhavanaSoTheFundamentalUnitGeneratesTheLadder where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int
  using ( ℤ; pos; _+_; _-_; -_; _·_; ·Comm; ·Rid; +Comm; pos0+ )
open import Cubical.Data.Sigma using (_×_; _,_; fst; snd)

open import Punaragamana.Bhavana_TheKsepaIsDeterminedByTheRootsAndCompositionMultipliesIt
  using (क्षेपः; भावना; भावना-क्षेपः)

------------------------------------------------------------------------
-- small ℤ facts reused below
------------------------------------------------------------------------

private
  -- x + pos 0 ≡ x
  शून्यदक्षिणम् : (x : ℤ) → x + pos 0 ≡ x
  शून्यदक्षिणम् x = +Comm x (pos 0) ∙ sym (pos0+ x)

  -- pos 0 + x ≡ x
  शून्यवामम् : (x : ℤ) → pos 0 + x ≡ x
  शून्यवामम् x = sym (pos0+ x)

  -- x · pos 0 ≡ pos 0  (pos 0 · x is definitionally pos 0; ·Comm crosses over)
  गुणशून्यदक्षिणम् : (x : ℤ) → x · pos 0 ≡ pos 0
  गुणशून्यदक्षिणम् x = ·Comm x (pos 0)

  -- pos 1 · x ≡ x
  गुणैकवामम् : (x : ℤ) → pos 1 · x ≡ x
  गुणैकवामम् x = ·Comm (pos 1) x ∙ ·Rid x

------------------------------------------------------------------------
-- 1. CLOSURE.  Composing two norm-one rows gives a norm-one row.
------------------------------------------------------------------------

भावना-संवृतिः : (D p q a b : ℤ)
              → क्षेपः D (a , b) ≡ pos 1
              → क्षेपः D (p , q) ≡ pos 1
              → क्षेपः D (भावना D p q (a , b)) ≡ pos 1
भावना-संवृतिः D p q a b eA eP =
  भावना-क्षेपः D p q a b ∙ cong₂ _·_ eA eP

------------------------------------------------------------------------
-- 2. IDENTITY.  (1, 0) is a norm-one row, and भावना with it is the
--    identity endomorphism on both sides.
------------------------------------------------------------------------

एकत्व-क्षेपः : (D : ℤ) → क्षेपः D (pos 1 , pos 0) ≡ pos 1
एकत्व-क्षेपः D =
    cong₂ (λ u v → u - D · v) (·Rid (pos 1)) (गुणशून्यदक्षिणम् (pos 0))
  ∙ cong (pos 1 +_) (cong (-_) (गुणशून्यदक्षिणम् D))
  ∙ शून्यदक्षिणम् (pos 1)

-- भावना (1,0) (a,b) ≡ (a,b) : (1,0) acting on the LEFT is the identity
भावना-एकत्व-वाम : (D a b : ℤ) → भावना D (pos 1) (pos 0) (a , b) ≡ (a , b)
भावना-एकत्व-वाम D a b =
  cong₂ _,_
    (cong₂ _+_ (·Rid a) (cong (D ·_) (गुणशून्यदक्षिणम् b))
      ∙ cong (a +_) (गुणशून्यदक्षिणम् D)
      ∙ शून्यदक्षिणम् a)
    (cong₂ _+_ (गुणशून्यदक्षिणम् a) (·Rid b)
      ∙ शून्यवामम् b)

-- भावना (a,b) (1,0) ≡ (a,b) : (1,0) acting on the RIGHT is the identity
भावना-एकत्व-दक्षिण : (D a b : ℤ) → भावना D a b (pos 1 , pos 0) ≡ (a , b)
भावना-एकत्व-दक्षिण D a b =
  cong₂ _,_
    (cong₂ _+_ (गुणैकवामम् a) (cong (D ·_) refl-अशून्यम्)
      ∙ cong (a +_) (गुणशून्यदक्षिणम् D)
      ∙ शून्यदक्षिणम् a)
    (cong₂ _+_ (गुणैकवामम् b) refl-अशून्यम्'
      ∙ शून्यदक्षिणम् b)
  where
    -- pos 0 · b ≡ pos 0 is definitional (first clause of _·_)
    refl-अशून्यम् : pos 0 · b ≡ pos 0
    refl-अशून्यम् = refl

    -- pos 0 · a ≡ pos 0 is definitional too
    refl-अशून्यम्' : pos 0 · a ≡ pos 0
    refl-अशून्यम्' = refl

------------------------------------------------------------------------
-- 3. COMMUTATIVITY of भावना, as rows: swapping which row is "fixed" and
--    which is "acted on" gives the same result pair.
------------------------------------------------------------------------

भावना-क्रमविनिमयः : (D p q a b : ℤ)
                  → भावना D p q (a , b) ≡ भावना D a b (p , q)
भावना-क्रमविनिमयः D p q a b =
  cong₂ _,_
    (cong₂ _+_ (·Comm a p) (cong (D ·_) (·Comm b q)))
    (cong₂ _+_ (·Comm a q) (·Comm b p) ∙ +Comm (q · a) (p · b))

------------------------------------------------------------------------
-- OPEN GOAL, stated and not faked (see header): full associativity of
-- भावना needs a "compose two rows into a third row" term of a shape this
-- module deliberately does not build.  What follows is the precise
-- statement that would need to be discharged, left unproved.
------------------------------------------------------------------------

-- भावना-साहचर्यम् :
--   (D p q r s a b : ℤ)
--   → भावना D p q (भावना D r s (a , b)) ≡ भावना D r s (भावना D p q (a , b))
--     -- ^ the weaker, provable-with-current-shapes form: composing two
--     --   FIXED rows against the same acted-on pair, in either order,
--     --   agrees — a genuine associativity-flavoured fact, but NOT the
--     --   monoid law (which needs the fixed rows themselves composed
--     --   into one row via भावना, not merely reordered).  Left open.
