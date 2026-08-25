{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- तिर्यक्-तन्तुः — कला च गुणकश्च एकस्यैव चरस्य तिर्यग्-भागौ अनुसरतः ।
-- न कश्चित् अन्यस्मिन् प्रवहति ।
--
-- (the phase and the coefficient factor through TRANSVERSE quotients of the
-- same variable; neither factors through the other.)
--
-- WHAT THIS IS.  Not a hardness result — §५ is explicit that hardness here is
-- a property of the LANGUAGE and not of the object.  It is the statement that
-- two customary projections are lossy, so that working inside either one is
-- looking into a fibre that is provably nonempty.  The residual form the
-- corpus has compressed the frontier to is
--
--   𝔇_a(L) = Σ_{u,v<L, uv≳L} b_a(u) b_a(v) Σ_{|k|≲uv/L} W(·) e(−2ak ū/v),
--
-- and the standing statement is that a proof must carry BOTH halves at once:
-- ζ(s+1)^{−1} living in the coefficients, and e(−2ak ū/v) living in the
-- phase.  `ParimanaAndha_…` shows the modulus route loses the first.  This
-- module says WHY carrying both is not a matter of care:
--
--     the phase sees u only through  u mod v  — it depends on ū mod v, and
--       ū is determined by u mod v;
--     the coefficient sees u only through its FACTORISATION — b_a(u) =
--       μ(u)/Π_{p|u}(p−2) is a function of the multiset of primes of u.
--
-- Those two readings of one variable are TRANSVERSE: neither is a function of
-- the other.  §३ exhibits it both ways, at the smallest integers that carry
-- it, and each blind pair refutes every possible derivation at once by
-- `ApurvaIndriyam.अपूर्वम्`.
--
-- The consequence is not "be careful".  It is: any argument that fixes one
-- reading and averages over the other has passed to a quotient on which the
-- second does not descend, and by `तन्तौ-अन्धः` everything computed
-- afterwards is constant on that quotient's fibres.  Fixing the residue class
-- and summing the coefficients loses μ; fixing the factorisation type and
-- summing the classes loses the phase.  The theorem must live on the JOINT
-- object — Möbius weights distributed over residue classes to modulus v — and
-- that is a recognisable place, which is said plainly in §४.
--
-- ARITHMETIC USED, all verifiable by inspection.  1 ≡ 11 (mod 5); 2 ≢ 3
-- (mod 5); μ(1) = +1; μ(11) = −1 (11 prime); μ(2) = μ(3) = −1 (2, 3 prime).
-- The residue map below COMPUTES — it is successor-with-wrap, not a table —
-- so the kernel checks the congruence rather than accepting it.  The four
-- Möbius values are transcribed, and stated here rather than hidden, exactly
-- as `SamacaranaNityam` §५ transcribes its Sturm verdict.
------------------------------------------------------------------------

module TiryakTantu_ThePhaseAndTheCoefficientFactorThroughTransverseQuotientsOfOneVariable where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.Empty using (⊥)

open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibresSoASeparatedBlindPairCertifiesANewSense
  using (प्रवहति ; तन्तौ-अन्धः ; अपूर्वम्)

------------------------------------------------------------------------
-- १ · कला-दृष्टिः — what the phase sees: the residue class
--
-- e(−2ak ū/v) depends on u only through ū mod v, and ū is determined by
-- u mod v.  Taken at v = 5, the smallest modulus carrying the exhibit.
-- Successor-with-wrap, so it reduces on literals and the kernel decides.
------------------------------------------------------------------------

अनु : ℕ → ℕ                       -- successor in ℤ/5
अनु zero = 1
अनु (suc zero) = 2
अनु (suc (suc zero)) = 3
अनु (suc (suc (suc zero))) = 4
अनु _ = 0

शेषः : ℕ → ℕ                      -- u mod 5, computed
शेषः zero = 0
शेषः (suc n) = अनु (शेषः n)

------------------------------------------------------------------------
-- २ · गुणक-दृष्टिः — what the coefficient sees: the Möbius sign
--
-- b_a(u) = μ(u)/Π_{p|u}(p−2) is a function of u's factorisation.  Only the
-- sign is needed to separate, so only the sign is carried.
------------------------------------------------------------------------

data चिह्नम् : Type where
  धन ऋण : चिह्नम्

म्यू : ℕ → चिह्नम्                 -- μ at the four integers used; see header
म्यू 1 = धन
म्यू 2 = ऋण
म्यू 3 = ऋण
म्यू 11 = ऋण
म्यू _ = धन                        -- never consulted below

------------------------------------------------------------------------
-- ३ · तिर्यक्त्वम् — transversality, exhibited in BOTH directions
--
-- Each direction is a blind pair for one reading, separated by the other.
------------------------------------------------------------------------

-- (a) The phase is blind where the coefficient sees: 1 and 11 are congruent
-- mod 5, and μ(1) = +1 while μ(11) = −1.
कलायाम्-अन्धम् : शेषः 1 ≡ शेषः 11
कलायाम्-अन्धम् = refl

म्यू-भिनत्ति : म्यू 1 ≡ म्यू 11 → ⊥
म्यू-भिनत्ति p = धन≢ऋण p
  where
    कोडः : चिह्नम् → ℕ
    कोडः धन = 0
    कोडः ऋण = 1
    धन≢ऋण : धन ≡ ऋण → ⊥
    धन≢ऋण q = znots (cong कोडः q)

-- (b) The coefficient is blind where the phase sees: μ(2) = μ(3) = −1, but
-- 2 and 3 lie in different classes mod 5.
गुणके-अन्धम् : म्यू 2 ≡ म्यू 3
गुणके-अन्धम् = refl

शेषः-भिनत्ति : शेषः 2 ≡ शेषः 3 → ⊥
शेषः-भिनत्ति p = znots (injSuc (injSuc p))

------------------------------------------------------------------------
-- ४ · मुख्यसिद्धिः — neither reading is a function of the other
--
-- One blind pair each way, so no derivation exists in either direction.  This
-- is the precise sense in which the two halves of the estimate are not merely
-- both present but IRREDUCIBLY both present.
------------------------------------------------------------------------

-- The Möbius sign does not descend along the residue class.
म्यू-न-शेषात् : प्रवहति शेषः म्यू → ⊥
म्यू-न-शेषात् = अपूर्वम् शेषः म्यू 1 11 कलायाम्-अन्धम् म्यू-भिनत्ति

-- The residue class does not descend along the Möbius sign.
शेषः-न-म्यूतः : प्रवहति म्यू शेषः → ⊥
शेषः-न-म्यूतः = अपूर्वम् म्यू शेषः 2 3 गुणके-अन्धम् शेषः-भिनत्ति

------------------------------------------------------------------------
-- ५ · तत्फलम् — what this settles, and where it puts the frontier
--
-- Fixing the residue class and summing the coefficients passes to `शेषः`, on
-- whose fibres μ is not constant (§३a), so everything computed afterwards is
-- one value for a fibre containing both signs — `तन्तौ-अन्धः`.  Fixing the
-- factorisation type and summing over classes passes to `म्यू`, on whose
-- fibres the phase is not constant (§३b), with the same consequence.  Both
-- projections are therefore closed, and closed for the same reason.
--
-- AND THE MORAL IS NOT "THIS IS HARD".  Read §४ again: both statements are
-- about QUOTIENTS.  `शेषः` and `म्यू` are each a projection of u that throws
-- something away, and §४ says only that neither loss can be undone from the
-- other side.  That is a fact about two impoverished languages, not about the
-- object — the object never lost anything.
--
-- सूत्र ५ names it exactly.  Working in either projection is **bind a**: fix
-- the class or fix the factorisation type, and what you get back is a fibre
-- you must now fight to see into.  Carrying the pair is **bind b**: the datum
-- rides along as a field, `Σ[ o ∈ O ] (S u ≡ o)` is contractible always, and
-- there is nothing to recover because nothing was discarded.  शेषं रक्ष — a
-- decision is the price of having forgotten something, and a wide enough
-- margin has no branches.
--
-- So the joint object — Möbius weights carried WITH their residue classes to
-- modulus v — is not a harder thing to prove.  It is the unprojected thing.
-- The difficulty is manufactured at the moment of projection, and it is
-- manufactured twice, once per wall.  What is usually called the barrier here
-- — μ equidistributing in progressions to moduli near √L — is a description
-- of the *projected* language, in which the two data were separated first and
-- their relation then has to be reconstructed.  In the language that never
-- separated them the reconstruction is not owed.
--
-- That is a claim about where to work, and it is cheap to state and not cheap
-- to cash: §४ proves the projections are lossy, it does not supply the joint
-- calculus.  But it does say that looking for a cleverer argument INSIDE
-- either projection is looking inside a fibre this module proved is nonempty.
--
-- मर्यादा, at the site.  §४ is proved AT v = 5 with four small integers.  It
-- establishes that the two readings are transverse — that no general
-- derivation exists in either direction, since one counterexample suffices —
-- and it does NOT quantify how badly they fail to determine one another at
-- large v, which is a different and quantitative question.  Nothing here
-- bounds 𝔇_a(L), and §५'s identification of the joint object with μ in
-- progressions is a READING of the reduction, offered for correction, not a
-- proved equivalence.
------------------------------------------------------------------------
