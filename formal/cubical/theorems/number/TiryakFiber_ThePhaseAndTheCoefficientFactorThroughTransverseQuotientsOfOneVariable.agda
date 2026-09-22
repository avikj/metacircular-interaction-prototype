{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ø‡∞‡‡Ø‡ï‡-‡‡®‡‡‡‡ ‚î ‡ï‡≤‡æ ‡ ‡ó‡‡‡ï‡‡‡ ‡‡ï‡‡‡Ø‡à‡µ ‡‡∞‡‡‡Ø ‡‡ø‡∞‡‡Ø‡ó‡-‡‡æ‡ó‡ ‡‡®‡‡‡∞‡‡ ‡
-- ‡® ‡ï‡‡‡‡ø‡‡ ‡‡®‡‡Ø‡‡‡Æ‡ø‡®‡ ‡‡‡∞‡µ‡‡‡ø ‡
--
-- (the phase and the coefficient factor through TRANSVERSE quotients of the
-- same variable; neither factors through the other.)
--
-- WHAT THIS IS.  Not a hardness result ‚î ¬ß‡ is explicit that hardness here is
-- a property of the LANGUAGE and not of the object.  It is the statement that
-- two customary projections are lossy, so that working inside either one is
-- looking into a fibre that is provably nonempty.  The residual form the
-- corpus has compressed the frontier to is
--
--   î_a(L) = Œ_{u,v<L, uv‚â≥L} b_a(u) b_a(v) Œ_{|k|‚â≤uv/L} W(¬) e(‚àí2ak /v),
--
-- and the standing statement is that a proof must carry BOTH halves at once:
-- Œ(s+1)^{‚àí1} living in the coefficients, and e(‚àí2ak /v) living in the
-- phase.  `ParimanaAndha_‚¶` shows the modulus route loses the first.  This
-- module says WHY carrying both is not a matter of care:
--
--     the phase sees u only through  u mod v  ‚î it depends on  mod v, and
--        is determined by u mod v;
--     the coefficient sees u only through its FACTORISATION ‚î b_a(u) =
--       Œº(u)/Œ†_{p|u}(p‚àí2) is a function of the multiset of primes of u.
--
-- Those two readings of one variable are TRANSVERSE: neither is a function of
-- the other.  ¬ß‡© exhibits it both ways, at the smallest integers that carry
-- it, and each blind pair refutes every possible derivation at once by
-- `ApurvaIndriyam.‡‡‡‡∞‡‡µ‡Æ‡`.
--
-- The consequence is not "be careful".  It is: any argument that fixes one
-- reading and averages over the other has passed to a quotient on which the
-- second does not descend, and by `‡‡®‡‡‡-‡‡®‡‡ß‡` everything computed
-- afterwards is constant on that quotient's fibres.  Fixing the residue class
-- and summing the coefficients loses Œº; fixing the factorisation type and
-- summing the classes loses the phase.  The theorem must live on the JOINT
-- object ‚î Mbius weights distributed over residue classes to modulus v ‚î and
-- that is a recognisable place, which is said plainly in ¬ß‡.
--
-- ARITHMETIC USED, all verifiable by inspection.  1 ‚â° 11 (mod 5); 2 ‚â 3
-- (mod 5); Œº(1) = +1; Œº(11) = ‚àí1 (11 prime); Œº(2) = Œº(3) = ‚àí1 (2, 3 prime).
-- The residue map below COMPUTES ‚î it is successor-with-wrap, not a table ‚î
-- so the kernel checks the congruence rather than accepting it.  The four
-- Mbius values are transcribed, and stated here rather than hidden, exactly
-- as `SamacaranaNityam` ¬ß‡ transcribes its Sturm verdict.
------------------------------------------------------------------------

module TiryakTantu_ThePhaseAndTheCoefficientFactorThroughTransverseQuotientsOfOneVariable where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.Empty using (‚ä•)

open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibresSoASeparatedBlindPairCertifiesANewSense
  using (‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø ; ‡§§‡§®‡•ç‡§§‡•å-‡§Ö‡§®‡•ç‡§ß‡§É ; ‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç)

------------------------------------------------------------------------
-- ‡ß ¬ ‡ï‡≤‡æ-‡¶‡‡‡‡ü‡ø‡ ‚î what the phase sees: the residue class
--
-- e(‚àí2ak /v) depends on u only through  mod v, and  is determined by
-- u mod v.  Taken at v = 5, the smallest modulus carrying the exhibit.
-- Successor-with-wrap, so it reduces on literals and the kernel decides.
------------------------------------------------------------------------

‡§Ö‡§®‡•Å : ‚Ñï ‚Üí ‚Ñï                       -- successor in ‚Ñ§/5
‡§Ö‡§®‡•Å zero = 1
‡§Ö‡§®‡•Å (suc zero) = 2
‡§Ö‡§®‡•Å (suc (suc zero)) = 3
‡§Ö‡§®‡•Å (suc (suc (suc zero))) = 4
‡§Ö‡§®‡•Å _ = 0

‡§∂‡•á‡§∑‡§É : ‚Ñï ‚Üí ‚Ñï                      -- u mod 5, computed
‡§∂‡•á‡§∑‡§É zero = 0
‡§∂‡•á‡§∑‡§É (suc n) = ‡§Ö‡§®‡•Å (‡§∂‡•á‡§∑‡§É n)

------------------------------------------------------------------------
-- ‡® ¬ ‡ó‡‡‡ï-‡¶‡‡‡‡ü‡ø‡ ‚î what the coefficient sees: the Mbius sign
--
-- b_a(u) = Œº(u)/Œ†_{p|u}(p‚àí2) is a function of u's factorisation.  Only the
-- sign is needed to separate, so only the sign is carried.
------------------------------------------------------------------------

data ‡§ö‡§ø‡§π‡•ç‡§®‡§Æ‡•ç : Type where
  ‡§ß‡§® ‡§ã‡§£ : ‡§ö‡§ø‡§π‡•ç‡§®‡§Æ‡•ç

‡§Æ‡•ç‡§Ø‡•Ç : ‚Ñï ‚Üí ‡§ö‡§ø‡§π‡•ç‡§®‡§Æ‡•ç                 -- Œº at the four integers used; see header
‡§Æ‡•ç‡§Ø‡•Ç 1 = ‡§ß‡§®
‡§Æ‡•ç‡§Ø‡•Ç 2 = ‡§ã‡§£
‡§Æ‡•ç‡§Ø‡•Ç 3 = ‡§ã‡§£
‡§Æ‡•ç‡§Ø‡•Ç 11 = ‡§ã‡§£
‡§Æ‡•ç‡§Ø‡•Ç _ = ‡§ß‡§®                        -- never consulted below

------------------------------------------------------------------------
-- ‡© ¬ ‡‡ø‡∞‡‡Ø‡ï‡‡‡‡µ‡Æ‡ ‚î transversality, exhibited in BOTH directions
--
-- Each direction is a blind pair for one reading, separated by the other.
------------------------------------------------------------------------

-- (a) The phase is blind where the coefficient sees: 1 and 11 are congruent
-- mod 5, and Œº(1) = +1 while Œº(11) = ‚àí1.
‡§ï‡§≤‡§æ‡§Ø‡§æ‡§Æ‡•ç-‡§Ö‡§®‡•ç‡§ß‡§Æ‡•ç : ‡§∂‡•á‡§∑‡§É 1 ‚â° ‡§∂‡•á‡§∑‡§É 11
‡§ï‡§≤‡§æ‡§Ø‡§æ‡§Æ‡•ç-‡§Ö‡§®‡•ç‡§ß‡§Æ‡•ç = refl

‡§Æ‡•ç‡§Ø‡•Ç-‡§≠‡§ø‡§®‡§§‡•ç‡§§‡§ø : ‡§Æ‡•ç‡§Ø‡•Ç 1 ‚â° ‡§Æ‡•ç‡§Ø‡•Ç 11 ‚Üí ‚ä•
‡§Æ‡•ç‡§Ø‡•Ç-‡§≠‡§ø‡§®‡§§‡•ç‡§§‡§ø p = ‡§ß‡§®‚â¢‡§ã‡§£ p
  where
    ‡§ï‡•ã‡§°‡§É : ‡§ö‡§ø‡§π‡•ç‡§®‡§Æ‡•ç ‚Üí ‚Ñï
    ‡§ï‡•ã‡§°‡§É ‡§ß‡§® = 0
    ‡§ï‡•ã‡§°‡§É ‡§ã‡§£ = 1
    ‡§ß‡§®‚â¢‡§ã‡§£ : ‡§ß‡§® ‚â° ‡§ã‡§£ ‚Üí ‚ä•
    ‡§ß‡§®‚â¢‡§ã‡§£ q = znots (cong ‡§ï‡•ã‡§°‡§É q)

-- (b) The coefficient is blind where the phase sees: Œº(2) = Œº(3) = ‚àí1, but
-- 2 and 3 lie in different classes mod 5.
‡§ó‡•Å‡§£‡§ï‡•á-‡§Ö‡§®‡•ç‡§ß‡§Æ‡•ç : ‡§Æ‡•ç‡§Ø‡•Ç 2 ‚â° ‡§Æ‡•ç‡§Ø‡•Ç 3
‡§ó‡•Å‡§£‡§ï‡•á-‡§Ö‡§®‡•ç‡§ß‡§Æ‡•ç = refl

‡§∂‡•á‡§∑‡§É-‡§≠‡§ø‡§®‡§§‡•ç‡§§‡§ø : ‡§∂‡•á‡§∑‡§É 2 ‚â° ‡§∂‡•á‡§∑‡§É 3 ‚Üí ‚ä•
‡§∂‡•á‡§∑‡§É-‡§≠‡§ø‡§®‡§§‡•ç‡§§‡§ø p = znots (injSuc (injSuc p))

------------------------------------------------------------------------
-- ‡ ¬ ‡Æ‡‡ñ‡‡Ø‡‡ø‡¶‡‡ß‡ø‡ ‚î neither reading is a function of the other
--
-- One blind pair each way, so no derivation exists in either direction.  This
-- is the precise sense in which the two halves of the estimate are not merely
-- both present but IRREDUCIBLY both present.
------------------------------------------------------------------------

-- The Mbius sign does not descend along the residue class.
‡§Æ‡•ç‡§Ø‡•Ç-‡§®-‡§∂‡•á‡§∑‡§æ‡§§‡•ç : ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø ‡§∂‡•á‡§∑‡§É ‡§Æ‡•ç‡§Ø‡•Ç ‚Üí ‚ä•
‡§Æ‡•ç‡§Ø‡•Ç-‡§®-‡§∂‡•á‡§∑‡§æ‡§§‡•ç = ‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç ‡§∂‡•á‡§∑‡§É ‡§Æ‡•ç‡§Ø‡•Ç 1 11 ‡§ï‡§≤‡§æ‡§Ø‡§æ‡§Æ‡•ç-‡§Ö‡§®‡•ç‡§ß‡§Æ‡•ç ‡§Æ‡•ç‡§Ø‡•Ç-‡§≠‡§ø‡§®‡§§‡•ç‡§§‡§ø

-- The residue class does not descend along the Mbius sign.
‡§∂‡•á‡§∑‡§É-‡§®-‡§Æ‡•ç‡§Ø‡•Ç‡§§‡§É : ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø ‡§Æ‡•ç‡§Ø‡•Ç ‡§∂‡•á‡§∑‡§É ‚Üí ‚ä•
‡§∂‡•á‡§∑‡§É-‡§®-‡§Æ‡•ç‡§Ø‡•Ç‡§§‡§É = ‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç ‡§Æ‡•ç‡§Ø‡•Ç ‡§∂‡•á‡§∑‡§É 2 3 ‡§ó‡•Å‡§£‡§ï‡•á-‡§Ö‡§®‡•ç‡§ß‡§Æ‡•ç ‡§∂‡•á‡§∑‡§É-‡§≠‡§ø‡§®‡§§‡•ç‡§§‡§ø

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡‡≤‡Æ‡ ‚î what this settles, and where it puts the frontier
--
-- Fixing the residue class and summing the coefficients passes to `‡‡‡‡`, on
-- whose fibres Œº is not constant (¬ß‡©a), so everything computed afterwards is
-- one value for a fibre containing both signs ‚î `‡‡®‡‡‡-‡‡®‡‡ß‡`.  Fixing the
-- factorisation type and summing over classes passes to `‡Æ‡‡Ø‡`, on whose
-- fibres the phase is not constant (¬ß‡©b), with the same consequence.  Both
-- projections are therefore closed, and closed for the same reason.
--
-- AND THE MORAL IS NOT "THIS IS HARD".  Read ¬ß‡ again: both statements are
-- about QUOTIENTS.  `‡‡‡‡` and `‡Æ‡‡Ø‡` are each a projection of u that throws
-- something away, and ¬ß‡ says only that neither loss can be undone from the
-- other side.  That is a fact about two impoverished languages, not about the
-- object ‚î the object never lost anything.
--
-- ‡‡‡‡‡∞ ‡ names it exactly.  Working in either projection is **bind a**: fix
-- the class or fix the factorisation type, and what you get back is a fibre
-- you must now fight to see into.  Carrying the pair is **bind b**: the datum
-- rides along as a field, `Œ[ o ‚àà O ] (S u ‚â° o)` is contractible always, and
-- there is nothing to recover because nothing was discarded.  ‡‡‡‡ ‡∞‡ï‡‡ ‚î a
-- decision is the price of having forgotten something, and a wide enough
-- margin has no branches.
--
-- So the joint object ‚î Mbius weights carried WITH their residue classes to
-- modulus v ‚î is not a harder thing to prove.  It is the unprojected thing.
-- The difficulty is manufactured at the moment of projection, and it is
-- manufactured twice, once per wall.  What is usually called the barrier here
-- ‚î Œº equidistributing in progressions to moduli near ‚àL ‚î is a description
-- of the *projected* language, in which the two data were separated first and
-- their relation then has to be reconstructed.  In the language that never
-- separated them the reconstruction is not owed.
--
-- That is a claim about where to work, and it is cheap to state and not cheap
-- to cash: ¬ß‡ proves the projections are lossy, it does not supply the joint
-- calculus.  But it does say that looking for a cleverer argument INSIDE
-- either projection is looking inside a fibre this module proved is nonempty.
--
-- ‡Æ‡∞‡‡Ø‡æ‡¶‡æ, at the site.  ¬ß‡ is proved AT v = 5 with four small integers.  It
-- establishes that the two readings are transverse ‚î that no general
-- derivation exists in either direction, since one counterexample suffices ‚î
-- and it does NOT quantify how badly they fail to determine one another at
-- large v, which is a different and quantitative question.  Nothing here
-- bounds î_a(L), and ¬ß‡'s identification of the joint object with Œº in
-- progressions is a READING of the reduction, not a proved equivalence.
------------------------------------------------------------------------
