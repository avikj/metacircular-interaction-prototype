{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡¶‡ï‡ ‚î ‡Ø‡‡‡∞ ‡‡‡¶‡ï‡ã ‡¶‡‡∞‡‡‡ü‡æ ‡‡‡‡∞ ‡ó‡‡ø‡∞‡‡®‡æ‡‡‡‡ø ; ‡µ‡‡Ø‡æ‡‡ø‡‡‡µ‡ ‡‡ ‡® ‡ï‡ø‡Æ‡‡ø ‡¶‡¶‡æ‡‡ø ‡
--
-- (where the observable DISTINGUISHES, there is no motion; and being
--  onto contributes nothing.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.  A sharpening of the hypothesis of the corpus's own
-- Noether statement, arrived at by going down to the carrier law and
-- reading which half of it the proof actually consumes.
--
-- `Dhruva_‚¶agda` ¬ß‡® states:
--
--     ‡®‡‡‡ü-‡‡‡æ‡µ‡-‡ó‡‡ø-‡‡‡æ‡µ‡ : isEquiv f ‚í ‡‡‡∞‡ï‡‡‡‡Æ‡ ‚í (a : A) ‚í Œ¶ a ‚â° a
--
-- and its prose reads `isEquiv f` as "every fibre contractible, nothing
-- hidden, zero receipt".  **The proof uses `isEquiv f` at exactly one
-- point, `e .equiv-proof (f a)`, and `f a` is in the image of `f`.**  So
-- the fibres over non-image points are never consulted, and the
-- hypothesis is stronger than the argument.
--
-- What the argument actually needs is that `f` does not CONFLATE:
-- `isEmbedding f`.  ¬ß‡© proves the theorem under that hypothesis, and
-- ¬ß‡ recovers `Dhruva` ¬ß‡® from it in one line.  **Surjectivity of the
-- observable buys nothing.**  This is not a repair ‚î `Dhruva` ¬ß‡® is
-- true as stated ‚î it is the statement of what makes it true.
--
-- WHY THIS IS THE CARRIER LAW AND NOT A LEMMA ABOUT EMBEDDINGS.
-- `fibre/src/Loss/Carrier.agda` is built on one line:
-- the fibre `Œ[ b ‚àà B ] (f a ‚â° b) = singl (f a)` is contractible, always,
-- for any `f` whatever.  Its header names the converse as "the part that
-- does work": a NON-contractible fibre cannot be declared equivalent to
-- its base.  The two roads are the two sides of one equation:
--
--     bind the OUTPUT:  Œ[ b ‚àà B ] (f a ‚â° b)  = singl (f a)   ‚î free
--     bind the INPUT:   Œ[ x ‚àà A ] (f x ‚â° b)  = fiber f b     ‚î costly
--
-- ¬ß‡ß below is that asymmetry at the level the dynamics lane works at:
-- the OUTPUT-bound flow type `(a : A) ‚í singl (f a)` is CONTRACTIBLE ‚î
-- there is exactly one such flow and it is the identity, for every `f`,
-- with no hypothesis at all.  ¬ß‡® shows the input-bound flow type
-- `(a : A) ‚í fiber f (f a)` is contractible **exactly when `f` is an
-- embedding**, and that this is an equivalence of propositions, not a
-- pair of implications.
--
-- `SvaFiberVasa_‚¶agda` identifies the second type with the conserving
-- flows themselves ‚î `(Œ[ Œ¶ ] ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶) ‚â ((a : A) ‚í fiber f (f a))`.
-- That identification is ITS result and is not redone here; ¬ß‡®b instead
-- derives only the contractibility, directly through the library's
-- `Œ-Œ†-Iso`, so that this module does not depend on it (it needs
-- `solve!`, absent from the container's cubical ‚î a container fact, not
-- a mathematical one).
--
-- So the whole conserving-flow monoid ‚î the object `Apratiloma_‚¶` and
-- `SamraksakaGana_‚¶` are about ‚î is the price of flipping which side of
-- `f a ‚â° b` is bound, and the price is zero exactly when the observable
-- is injective.  Not bijective.  **The symmetry lives in what the
-- observable CONFLATES, and being onto has nothing to do with it.**
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- **The converse of ¬ß‡®b is not proved.**  `isContr ((a : A) ‚í fiber f
-- (f a))` does not obviously give pointwise contractibility ‚î one
-- cannot in general perturb a section at a single point without
-- decidable equality on `A` ‚î so "the monoid is trivial ‚í `f` is an
-- embedding" is NOT established here.  The pointwise ‚ü∫ of ¬ß‡®a is.
--
-- TERM.  ‡‡‡¶‡ï ‚î "differentiating, that which distinguishes", the
-- standard stric agentive of ‡‡‡¶ (difference, distinction), which is
-- the technical vocabulary of difference across Nyya-Vaieika and
-- Skhya alike.  LIMIT, and it is the important half: no single stra
-- is claimed for it, and none of these schools states anything below.
-- The word is taken in its ordinary stric sense and applied here to a
-- map that does not conflate its arguments; that application is this
-- corpus's.  Internal precedent for the pairing: `Kaksya_‚¶agda` ¬ß‡© names
-- its own blindness result `‡ï‡ï‡‡‡‡Ø‡æ-‡‡‡‡¶‡`, non-difference along the
-- orbit, so ‡‡‡¶‡ï is the word that file's negation already presupposes.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 ‚î the container, NOT the
-- repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes, exit 0.
------------------------------------------------------------------------

module Bhedaka_TheHypothesisIsInjectivityNotBijectivityAndTheSurjectivityInDhruvaIsUnused where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (isEquiv ; fiber ; isPropIsEquiv ; _‚âÉ_ ; propBiimpl‚ÜíEquiv)
open import Cubical.Foundations.Isomorphism using (Iso ; invIso)
open import Cubical.Foundations.HLevels
  using (isContrŒ† ; isOfHLevelRetractFromIso ; inhProp‚ÜíisContr ; isPropŒ†)
open import Cubical.Foundations.Function using (_‚àò_)
open import Cubical.Functions.Embedding
  using (isEmbedding ; isPropIsEmbedding ; isEmbedding‚ÜíhasPropFibers
        ; hasPropFibersOfImage‚ÜíisEmbedding ; isEquiv‚ÜíisEmbedding)
open import Cubical.Data.Sigma

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡ï‡ ‡‡®‡‡‡æ‡ ‚î THE OUTPUT-BOUND FLOW TYPE IS A POINT.
--
-- Bind the output side of `f a ‚â° b` and there is exactly ONE flow, for
-- every `f`, with no hypothesis whatever.  This is `Carrier.agda`'s one
-- line, read at the arity the dynamics lane uses.
--
-- The contrast with ¬ß‡® is the whole content: the same shape with the
-- other side bound is not a point, and measuring how far it is from
-- being one is what the rest of the lane does.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) where

  ‡§è‡§ï-‡§™‡§®‡•ç‡§•‡§æ‡§É : isContr ((a : A) ‚Üí singl (f a))
  ‡§è‡§ï-‡§™‡§®‡•ç‡§•‡§æ‡§É = isContrŒ† (Œª a ‚Üí isContrSingl (f a))

------------------------------------------------------------------------
-- ‡®a ¬ ‡‡‡¶‡ï‡‡‡µ‡Æ‡ ‚î THE INPUT-BOUND FIBRES ARE POINTS EXACTLY WHEN THE
--      OBSERVABLE DOES NOT CONFLATE.  An equivalence of propositions.
--
-- `fiber f (f a)` is always INHABITED, by `(a , refl)`.  So it is
-- contractible exactly when it is a proposition, and "every fibre over
-- the image is a proposition" is `isEmbedding` on the nose.
------------------------------------------------------------------------

  ‡§≠‡•á‡§¶‡§ï-‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É : isEmbedding f ‚Üí (a : A) ‚Üí isContr (fiber f (f a))
  ‡§≠‡•á‡§¶‡§ï-‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É emb a =
    inhProp‚ÜíisContr (a , refl) (isEmbedding‚ÜíhasPropFibers emb (f a))

  ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§æ‡§§‡•ç-‡§≠‡•á‡§¶‡§ï‡§É : ((a : A) ‚Üí isContr (fiber f (f a))) ‚Üí isEmbedding f
  ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§æ‡§§‡•ç-‡§≠‡•á‡§¶‡§ï‡§É h =
    hasPropFibersOfImage‚ÜíisEmbedding (Œª a ‚Üí isContr‚ÜíisProp (h a))

  -- both sides are propositions, so the biimplication IS an equivalence
  ‡§≠‡•á‡§¶‡§ï-‡§∏‡§Æ‡§§‡§æ : isEmbedding f ‚âÉ ((a : A) ‚Üí isContr (fiber f (f a)))
  ‡§≠‡•á‡§¶‡§ï-‡§∏‡§Æ‡§§‡§æ =
    propBiimpl‚ÜíEquiv
      isPropIsEmbedding
      (isPropŒ† (Œª _ ‚Üí isPropIsContr))
      ‡§≠‡•á‡§¶‡§ï-‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É
      ‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§æ‡§§‡•ç-‡§≠‡•á‡§¶‡§ï‡§É

------------------------------------------------------------------------
-- ‡®b ¬ ‡‡‡‡Æ‡æ‡‡ ‡‡‡∞‡µ‡æ‡‡æ ‡‡ï‡ ‚î and therefore the conserving flows collapse
--      to a single point when the observable distinguishes.
--
-- `Œ[ Œ¶ ‚àà A ‚í A ] ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶` unfolds to
-- `Œ[ Œ¶ ] ((a : A) ‚í f (Œ¶ a) ‚â° f a)`, which is `Œ-Œ†-Iso`'s right-hand
-- side for `C a x = f x ‚â° f a` ‚î and its left-hand side is
-- `(a : A) ‚í fiber f (f a)`.  So the collapse is ¬ß‡®a plus `isContrŒ†`,
-- transported across an iso whose both round trips are `refl`.
--
-- Compare ¬ß‡ß: the same Œ†, with the other side of the equation bound,
-- was a point unconditionally.  The entire symmetry monoid is the
-- distance between those two lines.
------------------------------------------------------------------------

  ‡§≠‡•á‡§¶‡§ï‡•á-‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§æ-‡§è‡§ï‡§É : isEmbedding f ‚Üí isContr (Œ£[ Œ¶ ‚àà (A ‚Üí A) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶)
  ‡§≠‡•á‡§¶‡§ï‡•á-‡§™‡•ç‡§∞‡§µ‡§æ‡§π‡§æ-‡§è‡§ï‡§É emb =
    isOfHLevelRetractFromIso 0
      (invIso (Œ£-Œ†-Iso {A = A} {B = Œª _ ‚Üí A} {C = Œª a x ‚Üí f x ‚â° f a}))
      (isContrŒ† (‡§≠‡•á‡§¶‡§ï-‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É emb))

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡¶‡ï‡ ‡ó‡‡ø-‡‡‡æ‡µ‡ ‚î WHERE THE OBSERVABLE DISTINGUISHES, THE FLOW IS
--     THE IDENTITY.
--
-- `Dhruva` ¬ß‡® with `isEquiv f` weakened to `isEmbedding f`.  The proof
-- is `Dhruva`'s own, with the contractibility now supplied by ¬ß‡®a
-- instead of by `equiv-proof`: `(Œ¶ a , cons a)` and `(a , refl)` are
-- two points of one contractible fibre.
--
-- Note that `Œ¶` is still a bare endomorphism, and that nothing about
-- the codomain outside the image of `f` is used or available.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A) where

  ‡§≠‡•á‡§¶‡§ï‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É : isEmbedding f ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (a : A) ‚Üí Œ¶ a ‚â° a
  ‡§≠‡•á‡§¶‡§ï‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É emb cons a =
    cong fst (sym (c .snd (Œ¶ a , cons a)) ‚àô c .snd (a , refl))
    where
      c : isContr (fiber f (f a))
      c = ‡§≠‡•á‡§¶‡§ï-‡§§‡§®‡•ç‡§§‡•Å-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É f emb a

------------------------------------------------------------------------
-- ‡ ¬ ‡µ‡‡Ø‡æ‡‡ø‡‡‡µ‡ ‡® ‡ï‡ø‡Æ‡‡ø ‡¶‡¶‡æ‡‡ø ‚î AND SURJECTIVITY BUYS NOTHING.
--
-- `Dhruva` ¬ß‡® falls out of ¬ß‡©, because an equivalence is an embedding.
-- The one line is the demonstration: everything `isEquiv f` contributed
-- to that theorem, `isEmbedding f` already contributed.
--
-- Read at the physics: "the observable sees everything" was the
-- informal gloss, and it was doing two jobs at once ‚î not conflating
-- (injective) and leaving no state unaddressed (onto).  Only the first
-- is load-bearing.  A partial observable that never confuses two states
-- freezes the dynamics just as hard as a total one.
------------------------------------------------------------------------

  ‡§®‡§∑‡•ç‡§ü-‡§Ö‡§≠‡§æ‡§µ‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É‚Ä≤ : isEquiv f ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (a : A) ‚Üí Œ¶ a ‚â° a
  ‡§®‡§∑‡•ç‡§ü-‡§Ö‡§≠‡§æ‡§µ‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É‚Ä≤ e = ‡§≠‡•á‡§¶‡§ï‡•á-‡§ó‡§§‡§ø-‡§Ö‡§≠‡§æ‡§µ‡§É (isEquiv‚ÜíisEmbedding e)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î what this leaves open, named rather than gestured at.
--
-- (a) The converse fenced above: does `isContr (Œ[ Œ¶ ] ‡‡‡∞‡ï‡‡‡‡Æ‡ f Œ¶)`
--     imply `isEmbedding f`?  Pointwise it would; the obstruction is
--     producing a section that differs from the identity at one point
--     and nowhere else, which needs `a` separated from the rest of `A`.
--     For `A` with decidable equality it should go through, and that is
--     a genuinely different hypothesis worth naming as one.
--
-- (b) `Kaksya` ¬ß‡ (`‡®‡‡‡ü‡æ‡‡æ‡µ‡-‡ï‡ï‡‡‡‡Ø‡æ-‡‡ï‡‡¶‡æ`, the whole forward orbit
--     collapses) is stated with `isEquiv f` and consumes `Dhruva` ¬ß‡®.
--     By ¬ß‡© it holds under `isEmbedding f` verbatim.  Not restated
--     here: it is another identity's file, and the substitution is
--     mechanical.  Whoever owns it may take it.
--
-- (c) The dual weakening is NOT available and the asymmetry is the
--     point.  There is no hypothesis on `f` that makes ¬ß‡ß fail: the
--     output-bound side is contractible for every map, which is why
--     road one is free and why `Carrier.agda` needs no hypothesis to
--     state `A ‚â Carrier f`.
------------------------------------------------------------------------
