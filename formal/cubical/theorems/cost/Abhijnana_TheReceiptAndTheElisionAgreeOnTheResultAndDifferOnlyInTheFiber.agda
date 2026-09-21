{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡ø‡‡‡û‡æ‡® ‚î ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡ ‡≤‡ã‡‡‡‡ ‡‡≤‡ ‡® ‡‡ø‡¶‡‡Ø‡‡‡, ‡‡®‡‡‡ ‡‡µ ‡‡ø‡¶‡‡Ø‡‡‡ ‡
--
-- (an identification and an elision do not differ in the result;
--  they differ only in the fiber.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS, and it is one sentence.
--
-- A short proof can be short two ways: because a vast fiber was
-- IDENTIFIED, or because a step was DROPPED.  From inside ‚î from the
-- result ‚î those are the same experience, and no aesthetic has ever had
-- access to the difference, because the difference is not in the result.
-- It is in whether a term exists.
--
-- ¬ß‡ß prices the two bindings of one equation and shows the asymmetry is
-- not a matter of degree: one side is contractible with NO hypothesis,
-- and the other is exhibited non-contractible.  ¬ß‡® is the sentence
-- above, as a term: the codomain does not determine losslessness.
--
-- WHY ¬ß‡ß's SECOND HALF IS THE POINT.  `fiber/src/Fiber/
-- Carrier.agda` proves the free half ‚î `fiber a = singl (f a)`,
-- contractible, "the datum rides free" ‚î and its header states the
-- converse in prose: "a NON-contractible fiber cannot be declared
-- equivalent to its base."  Stated, and not exhibited.  A one-sided
-- asymmetry lets a reader believe the other binding is merely usually
-- harder.  `‡‡®‡‡‡‡-‡®-‡Æ‡‡ï‡‡‡` is the witness that it is not the same kind
-- of object at all.
--
-- WHY ¬ß‡® IS NOT `QuotientFiberLaw` AGAIN.  That law says an observation
-- class sees a quotient and no post-processing manufactures the fiber.
-- This says something smaller and sharper about the LOSSLESS case: two
-- maps into ONE codomain, one an equivalence and one not, and the
-- codomain is literally the same type.  Nothing about the result
-- distinguishes a receipt from an elision ‚î which is why a checker, and
-- not a reader, is what tells them apart.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- TERM.  ‡‡‡ø‡‡‡û‡æ‡® ‚î recognition, and the token by which what was lost is
-- known again; Klidsa's ‡‡‡ø‡‡‡û‡æ‡®‡‡æ‡ï‡‡®‡‡‡≤‡Æ‡ (c. 4th‚ì5th c.) turns on such
-- a token, the ring.  ‡≤‡ã‡ ‚î elision; Pini, ‡‡‡‡ü‡æ‡ß‡‡Ø‡æ‡Ø‡ 1.1.60, ‡‡¶‡∞‡‡‡®‡
-- ‡≤‡ã‡‡, and 1.1.62, where the operations conditioned by the elided affix
-- still apply.
------------------------------------------------------------------------

module Abhijnana_TheReceiptAndTheElisionAgreeOnTheResultAndDifferOnlyInTheFiber where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; fiber ; idIsEquiv)
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡®‡‡ß-‡µ‡à‡‡Æ‡‡Ø‡Æ‡ ‚î the two bindings of one equation, priced.
--
-- `f a ‚â° b`.  Bind `b` and the total space is `singl (f a)`: contractible
-- for every `f`, every `a`, arbitrary types, NO hypothesis ‚î because
-- `f a` was never separate from `a`.  Bind `a` and it is the fiber, and
-- the fiber is not that kind of object: below is one that is not
-- contractible, exhibited rather than asserted.
--
-- AND THE WITNESS OF "NEVER SEPARATE" IS ONE LINE OF THE LIBRARY, worth
-- naming because everything in this corpus stands on it:
--
--     isContrSingl a .fst = (a , refl)          -- Cubical/Foundations/Prelude.agda:457
--
-- The centre of the free receipt is the image PAIRED WITH THE ASSERTION
-- THAT IT IS THE IMAGE ‚î and that assertion asserts nothing.  That is the
-- whole reason carrying costs zero: there was never a second object to
-- carry.  Non-rivalry, per-edge amortization, a route being free at any
-- length, `ua` crossing without charge ‚î all of it is this line held up.
--
-- Two files contain the token `refl` ZERO times ‚î
-- `Lekha_‚¶agda` (the trail is free at every depth) and `Anvesanam_‚¶agda`
-- (forward search is free at every depth).  They never write it because
-- they are built out of `isContrSingl` and inherit it.  That is what it
-- looks like for a floor to be load-bearing: the things standing on it do
-- not mention it.
--
------------------------------------------------------------------------

  -- the free binding: the receipt costs nothing to carry
‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Ç-‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç : {A B : Type ‚Ñì} (f : A ‚Üí B) (a : A) ‚Üí isContr (singl (f a))
‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Ç-‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç f a = isContrSingl (f a)

  -- the other binding: the smallest elision there is
‡§≤‡•ã‡§™‡§É : Bool ‚Üí Unit
‡§≤‡•ã‡§™‡§É _ = tt

‡§¶‡•ç‡§µ‡§ø‡§™‡§¶‡§É ‡§Ö‡§®‡•ç‡§Ø‡§É : fiber ‡§≤‡•ã‡§™‡§É tt
‡§¶‡•ç‡§µ‡§ø‡§™‡§¶‡§É = true  , refl
‡§Ö‡§®‡•ç‡§Ø‡§É   = false , refl

‡§§‡§®‡•ç‡§§‡•Å‡§É-‡§®-‡§Æ‡•Å‡§ï‡•ç‡§§‡§É : ¬¨ (isContr (fiber ‡§≤‡•ã‡§™‡§É tt))
‡§§‡§®‡•ç‡§§‡•Å‡§É-‡§®-‡§Æ‡•Å‡§ï‡•ç‡§§‡§É c =
  false‚â¢true (cong fst (sym (c .snd ‡§Ö‡§®‡•ç‡§Ø‡§É) ‚àô c .snd ‡§¶‡•ç‡§µ‡§ø‡§™‡§¶‡§É))

------------------------------------------------------------------------
-- ‡® ¬ ‡‡≤‡ ‡® ‡®‡ø‡∞‡‡‡æ‡Ø‡ï‡Æ‡ ‚î THE RESULT DOES NOT DECIDE.
--
-- `idfun Unit : Unit ‚í Unit` is an equivalence: an identification, losing
-- nothing.  `‡≤‡ã‡‡ : Bool ‚í Unit` is not: an elision, losing exactly one
-- bit.  Their codomains are the same type.  So no rule reading only the
-- codomain can separate a receipt from an elision ‚î the witness is that
-- such a rule would make `‡≤‡ã‡‡` an equivalence, and ¬ß‡ß forbids it.
--
-- This is the whole of why the kernel is the instrument: what tells the
-- two apart is not in the result and is not available to inspection of
‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç : isEquiv (idfun Unit)
‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç = idIsEquiv Unit

‡§´‡§≤‡§Ç-‡§®-‡§®‡§ø‡§∞‡•ç‡§£‡§æ‡§Ø‡§ï‡§Æ‡•ç : ¬¨ ((A : Type‚ÇÄ) (g : A ‚Üí Unit) ‚Üí isEquiv g)
‡§´‡§≤‡§Ç-‡§®-‡§®‡§ø‡§∞‡•ç‡§£‡§æ‡§Ø‡§ï‡§Æ‡•ç h = ‡§§‡§®‡•ç‡§§‡•Å‡§É-‡§®-‡§Æ‡•Å‡§ï‡•ç‡§§‡§É (isEquiv.equiv-proof (h Bool ‡§≤‡•ã‡§™‡§É) tt)

