{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ñ‡‡∞‡ ‚î ‡‡‡®‡‡Ø-‡‡∞-‡∞‡æ‡‡‡ ‡‡®‡‡‡‡ ‡ï‡‡‡‡‡‡®‡ ‡ï‡‡‡‡‡‡∞‡Æ‡, ‡‡∞‡‡µ-‡®‡æ‡‡ ‡‡∞‡‡µ-‡ó‡‡ø‡‡‡ ‡‡ï‡Æ‡ ‡
--
-- (khahara ‚î the fibre of the zero-divisor map is the whole domain, and
--  total loss is exactly total symmetry.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERM, TEXT, DATE.  ‡ñ‡‡∞ ¬ khahara, "having the void for divisor": a
-- quantity divided by nya, carried as an object rather than refused.
-- ‡‡æ‡‡‡ï‡∞ ‡¶‡‡µ‡ø‡‡‡Ø, *‡‡‡‡ó‡‡ø‡‡Æ‡* ‡®‡¶ (Bhskara II, Bjagaita 20, 1150 CE):
--
--     ‡‡‡‡Æ‡ø‡®‡ ‡µ‡ø‡ï‡æ‡∞‡ ‡ñ‡‡∞‡ ‡® ‡∞‡æ‡‡æ‡µ‡‡ø ‡‡‡∞‡µ‡ø‡‡‡ü‡‡‡‡µ‡‡ø ‡®‡ø‡‡‡‡‡‡‡ ‡
--     ‡‡‡‡‡‡µ‡‡ø ‡‡‡Ø‡æ‡≤‡‡≤‡Ø‡‡‡‡‡ü‡ø‡ï‡æ‡≤‡ ‡Ω‡®‡®‡‡‡ ‡Ω‡‡‡Ø‡‡‡ ‡‡‡‡ó‡‡‡‡ ‡Ø‡¶‡‡µ‡‡ ‡
--
--   "In this khahara quantity there is no change, though quantities
--    enter it and issue from it, however many ‚î as in the infinite and
--    unfallen (‡‡‡‡Ø‡‡) at the time of dissolution and creation, though
--    hosts of beings enter and go out."
--
-- The arithmetic rule is *‡≤‡‡≤‡æ‡µ‡‡* ‡‡‚ì‡‡, whose verse 47 worked example
-- (63 ‚í 14) cannot be solved without it.  The preceding statement is
-- ‡‡‡∞‡‡‡Æ‡ó‡‡‡‡, *‡‡‡∞‡æ‡‡‡Æ‡‡‡‡‡ü‡‡ø‡¶‡‡ß‡æ‡®‡‡* ‡ß‡Æ.‡©‡‚ì‡©‡ (628).  Citation as given
-- in `.claude/hooks/MulaVakya_SourceStatementsForTheTermsInOurFileNames.txt`
-- line 190, including its LIMIT: Bhskara does not distinguish n0 from
-- 00, and read as an arithmetic on a field the rule fails.  No
-- manuscript was opened here either.
--
-- ¬ß‡®‚ì¬ß‡ are not attributed to him.  The word ‡‡‡‡Ø‡‡ is his simile's
-- referent, not a technical term for a maximally lossy observation; the
-- application of it to that is this corpus's and is not in the text.
-- The substrate is cubical type theory (Voevodsky), this repository's
-- one admitted non-Indian frame.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS FILE EXISTS.  `machine/Lopa_‚¶hs`, run 2026-08-22 against the
-- tree at this commit, prints
--
--     1062  UNDECIDED       16  ‡‡‡       4  ‡∞‡ø‡ï‡‡‡Æ‡
--
-- and one of the 1062 is `[map] ‚ü®lib‚ü©.‚ ‚ü Khahara.‡ñ‡‡∞ ¬ Khahara.‡‡‡®‡‡Ø-‡‡∞‡`.
-- Its four deciding rules R1‚ìR4 key on the TARGET being `Unit`, `‚ä`, or a
-- propositional truncation, and on the SOURCE being `‚ä`.  None fires
-- here, because `‡ñ‡‡∞` is none of those.  The rules therefore miss the
-- most lossy map that can exist: a CONSTANT one, whose target happens to
-- have two constructors.  ¬ß‡ß‚ì¬ß‡® price that edge, and ¬ß‡ states the
-- census rule that would have caught it.
--
-- A receipt is an IDENTIFICATION of the fibre with a standard type,
-- never a bound (README, "the receipt economy").  ¬ß‡ß gives one:
-- `fiber ‡‡‡®‡‡Ø-‡‡∞‡ ‡‡®‡®‡‡ ‚â ‚`, on the nose, the whole domain.  Nothing
-- crosses this edge.  It is the far end of the scale whose near end is
-- `Dhruva_‚¶agda` ¬ß‡® (`isEquiv f ‚í ‡‡‡∞‡ï‡‡‡‡Æ‡ ‚í Œ¶ ‚â° id`: zero loss, zero
-- symmetry) and whose middle is `Lopa_TheSumsFibreIsExactlyNPlusOne‚¶`
-- (`fiber (_+_) n ‚â Fin (suc n)`: finite loss).
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE THEOREM THIS FILE IS FOR (¬ß‡©).  Dhruva proved NO LOSS ‚ü NO
-- SYMMETRY.  The other end is an EQUIVALENCE and not merely an
-- implication:
--
--     every endomorphism of A conserves f   ‚ü∫   f is constant
--
-- (the ‚ü direction free, the ‚ü direction needing only that A is
-- inhabited, by taking Œ¶ to be a constant map).  So the size of the
-- conserving monoid is not merely correlated with the loss ‚î at the two
-- ends it is DETERMINED by it, trivial monoid at zero loss and the full
-- endomorphism monoid at total loss.  ¬ß‡ shows the two ends meet only
-- on a proposition: a map that is both an equivalence and constant
-- forces its domain to have at most one point.
------------------------------------------------------------------------

module Khahara_TheZeroDivisorEdgeIsPricedAtItsWholeDomainAndTotalLossIsExactlyTotalSymmetry where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.HLevels
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sum.Properties using (isSet‚äé)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; isSet‚Ñ§) renaming (_+_ to _+‚Ñ§_)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Relation.Nullary using (¬¨_)

open import Khahara using (‡§ñ‡§π‡§∞ ; ‡§∏‡§∏‡•Ä‡§Æ ; ‡§Ö‡§®‡§®‡•ç‡§§ ; ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É ; ‡§Ö‡§®‡§®‡•ç‡§§-‡§®-‡§∏‡§∏‡•Ä‡§Æ‡§É)

private variable ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ‡¶ ¬ ‡ñ‡‡∞ is a set.  Needed because a fibre is a Œ over a PATH type, and
--     `Œ[ a ‚àà ‚ ] (‡‡®‡®‡‡ ‚â° ‡‡®‡®‡‡)` is ‚ only if that loop space is
--     contractible.  Two constructors, no path constructors, so the
--     forgetful Iso to `‚ ‚ä Unit` is definitional in all four clauses.
------------------------------------------------------------------------

‡§ñ‡§π‡§∞‚Üí‚äé : ‡§ñ‡§π‡§∞ ‚Üí ‚Ñ§ ‚äé Unit
‡§ñ‡§π‡§∞‚Üí‚äé (‡§∏‡§∏‡•Ä‡§Æ a) = inl a
‡§ñ‡§π‡§∞‚Üí‚äé ‡§Ö‡§®‡§®‡•ç‡§§     = inr tt

‚äé‚Üí‡§ñ‡§π‡§∞ : ‚Ñ§ ‚äé Unit ‚Üí ‡§ñ‡§π‡§∞
‚äé‚Üí‡§ñ‡§π‡§∞ (inl a) = ‡§∏‡§∏‡•Ä‡§Æ a
‚äé‚Üí‡§ñ‡§π‡§∞ (inr _) = ‡§Ö‡§®‡§®‡•ç‡§§

‡§ñ‡§π‡§∞-Iso : Iso ‡§ñ‡§π‡§∞ (‚Ñ§ ‚äé Unit)
Iso.fun      ‡§ñ‡§π‡§∞-Iso           = ‡§ñ‡§π‡§∞‚Üí‚äé
Iso.inv      ‡§ñ‡§π‡§∞-Iso           = ‚äé‚Üí‡§ñ‡§π‡§∞
Iso.rightInv ‡§ñ‡§π‡§∞-Iso (inl a)   = refl
Iso.rightInv ‡§ñ‡§π‡§∞-Iso (inr tt)  = refl
Iso.leftInv  ‡§ñ‡§π‡§∞-Iso (‡§∏‡§∏‡•Ä‡§Æ a)  = refl
Iso.leftInv  ‡§ñ‡§π‡§∞-Iso ‡§Ö‡§®‡§®‡•ç‡§§      = refl

isSet‡§ñ‡§π‡§∞ : isSet ‡§ñ‡§π‡§∞
isSet‡§ñ‡§π‡§∞ = isOfHLevelRetractFromIso 2 ‡§ñ‡§π‡§∞-Iso (isSet‚äé isSet‚Ñ§ isSetUnit)

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡ø‡‡‡û‡æ‡®‡Æ‡ ‚î THE RECEIPT.  The fibre over ‡‡®‡®‡‡ is ‚ itself.
--
--     fiber ‡‡‡®‡‡Ø-‡‡∞‡ ‡‡®‡®‡‡  ‚â  ‚
--
-- Not a bound.  An identification with a standard type, which is what
-- the corpus's rule demands of a receipt.  Read it as the price: the
-- edge `‚ ‚ü ‡ñ‡‡∞` costs its entire domain, and the verdict is ‡‡‡ with
-- the amount named.
------------------------------------------------------------------------

‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®-Iso : Iso (fiber ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É ‡§Ö‡§®‡§®‡•ç‡§§) ‚Ñ§
Iso.fun      ‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®-Iso (a , _) = a
Iso.inv      ‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®-Iso a       = a , refl
Iso.rightInv ‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®-Iso a       = refl
Iso.leftInv  ‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®-Iso (a , p) =
  Œ£PathP (refl , isSet‡§ñ‡§π‡§∞ ‡§Ö‡§®‡§®‡•ç‡§§ ‡§Ö‡§®‡§®‡•ç‡§§ refl p)

‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç : fiber ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É ‡§Ö‡§®‡§®‡•ç‡§§ ‚âÉ ‚Ñ§
‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç = isoToEquiv ‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®-Iso

------------------------------------------------------------------------
-- ‡® ¬ ‡∞‡ø‡ï‡‡‡Æ‡ ‚î and every OTHER fibre is empty.  So the image is a
--     single point and the three verdicts of `Avaccheda_‚¶agda` are both
--     realised by this one map: ‡‡‡ at ‡‡®‡®‡‡, ‡∞‡ø‡ï‡‡‡Æ‡ at every ‡‡‡‡Æ a.
--     `‡‡ï‡Æ‡` ‚î contractible ‚î occurs nowhere, which is the statement
--     that no information whatsoever crosses.
------------------------------------------------------------------------

‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§∏‡§∏‡•Ä‡§Æ‡•á : (a : ‚Ñ§) ‚Üí ¬¨ (fiber ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É (‡§∏‡§∏‡•Ä‡§Æ a))
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§∏‡§∏‡•Ä‡§Æ‡•á a (_ , p) = ‡§Ö‡§®‡§®‡•ç‡§§-‡§®-‡§∏‡§∏‡•Ä‡§Æ‡§É a p

------------------------------------------------------------------------
-- ‡© ¬ ‡‡∞‡‡µ-‡®‡æ‡‡ ‡‡∞‡‡µ-‡ó‡‡ø‡‡‡ ‚î TOTAL LOSS IS EXACTLY TOTAL SYMMETRY.
--
-- `Dhruva_‚¶agda` defines ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶ = (a : A) ‚í f (Œ¶ a) ‚â° f a, and
-- proves that zero loss forces Œ¶ = id.  Here is the other end, stated
-- for an arbitrary map between arbitrary types, no hypotheses beyond
-- inhabitedness where it is genuinely needed.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} {B : Type ‚Ñì'} (f : A ‚Üí B) where

  -- EVERY endomorphism of the domain conserves the observable.
  ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç : Type (‚Ñì-max ‚Ñì ‚Ñì')
  ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç = (Œ¶ : A ‚Üí A) (a : A) ‚Üí f (Œ¶ a) ‚â° f a

  -- The observable sees nothing at all.
  ‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É : Type (‚Ñì-max ‚Ñì ‚Ñì')
  ‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É = (x y : A) ‚Üí f x ‚â° f y

  -- ‚ü : a constant observable is conserved by everything.  Free.
  ‡§®‡§æ‡§∂‡§æ‡§§‡•ç-‡§ó‡§§‡§ø‡§É : ‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É ‚Üí ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç
  ‡§®‡§æ‡§∂‡§æ‡§§‡•ç-‡§ó‡§§‡§ø‡§É c Œ¶ a = c (Œ¶ a) a

  -- ‚ü : if everything conserves it, it is constant.  The witness is the
  -- constant flow: `Œ¶ = Œª _ ‚í x` moves a chosen basepoint to x, and
  -- conservation says the observable did not notice.  Inhabitedness of A
  -- is the whole hypothesis, and it is necessary: over A = ‚ä every map
  -- is vacuously conserved by everything and `‡‡∞‡‡µ-‡®‡æ‡‡` is vacuous too,
  -- so nothing is lost there either ‚î the statement is not about the
  -- empty domain and does not pretend to be.
  ‡§ó‡§§‡•á‡§É-‡§®‡§æ‡§∂‡§É : A ‚Üí ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‚Üí ‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É
  ‡§ó‡§§‡•á‡§É-‡§®‡§æ‡§∂‡§É a‚ÇÄ s x y = s (Œª _ ‚Üí x) a‚ÇÄ ‚àô sym (s (Œª _ ‚Üí y) a‚ÇÄ)

------------------------------------------------------------------------
-- ‡ ¬ The two ends meet only on a proposition.
--
-- Dhruva's hypothesis (isEquiv f ‚î nothing hidden) and this file's
-- (‡‡∞‡‡µ-‡®‡æ‡‡ ‚î everything hidden) are not merely different: holding both
-- collapses the domain.  So the scale really has two ends, and a map
-- sitting at both is a map on an object with at most one point.
------------------------------------------------------------------------

  ‡§â‡§≠‡§Ø‡§æ‡§®‡•ç‡§§‡•á-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç : isEquiv f ‚Üí ‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É ‚Üí (x y : A) ‚Üí x ‚â° y
  ‡§â‡§≠‡§Ø‡§æ‡§®‡•ç‡§§‡•á-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç e c x y =
    cong fst (sym (ctr .snd (x , refl)) ‚àô ctr .snd (y , c y x))
    where
      ctr : isContr (fiber f (f x))
      ctr = e .equiv-proof (f x)

  -- Contrapositive, in the form that is actually used: a domain with two
  -- provably distinct points admits no constant equivalence.
  ‡§®-‡§∏‡§Æ‡§§‡§æ : ‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É ‚Üí (x y : A) ‚Üí ¬¨ (x ‚â° y) ‚Üí ¬¨ (isEquiv f)
  ‡§®-‡§∏‡§Æ‡§§‡§æ c x y sep e = sep (‡§â‡§≠‡§Ø‡§æ‡§®‡•ç‡§§‡•á-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç e c x y)

------------------------------------------------------------------------
-- ‡ ¬ The instance: Bhskara's map sits at the far end.
------------------------------------------------------------------------

‡§ñ‡§π‡§∞-‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É : ‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É
‡§ñ‡§π‡§∞-‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É _ _ = refl

‡§ñ‡§π‡§∞-‡§∏‡§∞‡•ç‡§µ-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç : ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É
‡§ñ‡§π‡§∞-‡§∏‡§∞‡•ç‡§µ-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç = ‡§®‡§æ‡§∂‡§æ‡§§‡•ç-‡§ó‡§§‡§ø‡§É ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É ‡§ñ‡§π‡§∞-‡§∏‡§∞‡•ç‡§µ-‡§®‡§æ‡§∂‡§É

-- The verse, as the special case Œ¶ = (_+‚ k).  BG 20 states it of the
-- RESULT ‚î the khahara is unaltered when quantities enter and leave it ‚î
-- and `Khahara.‡ñ‡‡∞‡-‡®-‡µ‡ø‡ï‡æ‡∞‡-‡Ø‡ã‡ó‡` is that reading, already checked in
-- the file this one imports.  This is the DOMAIN reading, which is the
-- one the fibre law is about: the numerator may be moved arbitrarily and
-- the observation does not change.  Both are refl; that they are two
-- readings and not one is the point of writing the second.
‡§≠‡§æ‡§∏‡•ç‡§ï‡§∞-‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É : (k n : ‚Ñ§) ‚Üí ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É (n +‚Ñ§ k) ‚â° ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É n
‡§≠‡§æ‡§∏‡•ç‡§ï‡§∞-‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§É k n = refl

-- And the fibre statement of the same verse: every insertion stays inside
-- the one fibre, because the fibre is everything.  Stated through the
-- receipt so it is the identification that is doing the work.
‡§™‡•ç‡§∞‡§µ‡§ø‡§∑‡•ç‡§ü‡§Ç-‡§§‡§®‡•ç‡§§‡•å-‡§§‡§ø‡§∑‡•ç‡§†‡§§‡§ø : (k : ‚Ñ§) ‚Üí fiber ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É ‡§Ö‡§®‡§®‡•ç‡§§ ‚Üí fiber ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É ‡§Ö‡§®‡§®‡•ç‡§§
‡§™‡•ç‡§∞‡§µ‡§ø‡§∑‡•ç‡§ü‡§Ç-‡§§‡§®‡•ç‡§§‡•å-‡§§‡§ø‡§∑‡•ç‡§†‡§§‡§ø k (n , p) = (n +‚Ñ§ k) , p

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î what this opens, and one thing it hands to another lane.
--
-- (a) A CENSUS RULE, offered to `machine/Lopa_‚¶hs` and not applied here,
--     because that file is another lane's and an audit that rewrites its
--     subject is not an audit:
--
--       R5  a top-level definition whose every clause returns the SAME
--           closed term, with no occurrence of any pattern variable,
--           is CONSTANT.  Verdict ‡‡‡ at that value with fibre = the
--           whole source, and ‡∞‡ø‡ï‡‡‡Æ‡ at every other value of the target
--           IF the target is a set with decidable equality.
--
--     R1 is the special case target = Unit.  R5 subsumes it and would
--     have decided this edge.  How many of the 1062 UNDECIDED it decides
--     is NOT estimated here ‚î a count without a run is the fitted
--     constant CLAUDE.md opens with.
--
--     The companion move is
--     `Chandomudra_ThePratyayasFibresWereWrittenInProseAndTheCensusCalledThemUndecided`,
--     which prices undecided edges whose fibres the corpus ALREADY had,
--     defined by name fifteen lines below the map.  This one is the
--     other case: no fibre existed for this edge anywhere, and the
--     reason the census could not name it is not that it failed to look
--     up an answer but that its rule set has no rule for constancy.
--     Two different defects, and the second is not repaired by the first
--     one's remedy ("look it up before constructing").  Chandomudra
--     reports 1045 UNDECIDED and this file reports 1062 from a run on
--     2026-08-22; the census is a moving number and neither figure is
--     the corpus's, only that day's parse of it.
--
-- (b) NOT DONE.  The scale between the two ends is not a scale yet.
--     Dhruva's end and this one are both characterised; what is missing
--     is the statement that the conserving monoid `Œ[ Œ¶ ] ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶`
--     is MONOTONE in the fibres ‚î that a coarser f admits more flows.
--     "Coarser" needs an order on maps out of A (the quotient order),
--     and this file does not have one.  Naming it as absent rather than
--     gesturing at it.
--
-- (c) The 00 case is untouched.  Khahara.agda's CORRECTED block of
--     2026-08-19 separates it from ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ as a UNIQUENESS failure,
--     and `NonUniquenessAndInexpressibilityAreIndependent`
--     checks the independence.  Nothing here bears on that dispute; the
--     map priced above is the n0 branch only, and it is total on ‚
--     precisely because `Khahara.‡‡‡®‡‡Ø-‡‡∞‡` ignores its argument ‚î which
--     is the very degeneracy ¬ß‡ß is the receipt for, and is also the
--     LIMIT the source ledger's row states.
------------------------------------------------------------------------
