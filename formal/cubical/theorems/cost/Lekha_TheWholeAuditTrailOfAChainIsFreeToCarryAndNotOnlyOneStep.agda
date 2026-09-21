{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡≤‡‡ñ‡æ ‚î ‡‡∞‡‡µ‡æ ‡≤‡‡ñ‡æ ‡Æ‡‡ï‡‡‡æ, ‡® ‡ï‡‡µ‡≤‡Æ‡ ‡‡ï‡ ‡‡¶‡Æ‡ ‡
--
-- (the whole ledger rides free, not just one step.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- `fibre/src/Loss/Carrier.agda` proves ONE step free: the
-- datum and its witness contribute zero degrees of freedom, because
-- `singl (f a)` is contractible.  Everything downstream in this corpus ‚î
-- that a receipted mathematics is affordable at all, that proof-of-
-- transport is cheap, that Bennett's garbage tape is the constructive
-- witness ‚î is a claim about CHAINS, and one step does not give it.  A
-- reader could reasonably fear the trail accumulates.
--
-- It does not.  ¬ß‡®: a point carried through TWO maps, dragging both
-- intermediate values and both witnesses, is equivalent to the bare
-- point.  Not small ‚î EQUAL, and the equivalence is `Œ`-contraction
-- twice with no hypothesis on `A`, `B`, `C`, `f` or `g`.
--
-- READ AT BENNETT.  Reversible computation pays for its garbage tape in
-- space, per execution, which is why it stayed theoretical.  Here the
-- trail is contractible, so what is stored is not the intermediates but
-- WHICH standard trail they are, and ¬ß‡® is the statement that this holds
-- at length two exactly as at length one.  README movement 5's identity ‚î
-- the reversible computer's garbage tape and the constructive proof's
-- carried witness are one object ‚î is that sentence, and ¬ß‡® is the part
-- of it that has to be true for the economics to work.
------------------------------------------------------------------------

module Lekha_TheWholeAuditTrailOfAChainIsFreeToCarryAndNotOnlyOneStep where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Foundations.HLevels using (isOfHLevelŒ£ ; isContrŒ£)
open import Cubical.Data.Sigma
  using (Œ£-syntax ; _,_ ; fst ; snd ; Œ£-contractSnd)

private variable ‚Ñì : Level

module _ {A B C : Type ‚Ñì} (f : A ‚Üí B) (g : B ‚Üí C) where

------------------------------------------------------------------------
-- ‡ß ¬ ‡≤‡‡ñ‡æ ‚î the full trail: the point, both images it passes through,
--     and the witness at each step that it IS that image.
------------------------------------------------------------------------

  ‡§≤‡•á‡§ñ‡§æ : Type ‚Ñì
  ‡§≤‡•á‡§ñ‡§æ = Œ£[ a ‚àà A ] Œ£[ p ‚àà singl (f a) ] singl (g (p .fst))

------------------------------------------------------------------------
-- ‡® ¬ ‡≤‡‡ñ‡æ ‡Æ‡‡ï‡‡‡æ ‚î AND IT IS THE POINT.
--
-- Both intermediates and both witnesses contract away.  No hypothesis on
-- anything: arbitrary types, arbitrary maps, however lossy.
------------------------------------------------------------------------

  ‡§≤‡•á‡§ñ‡§æ-‡§Æ‡•Å‡§ï‡•ç‡§§‡§æ : ‡§≤‡•á‡§ñ‡§æ ‚âÉ A
  ‡§≤‡•á‡§ñ‡§æ-‡§Æ‡•Å‡§ï‡•ç‡§§‡§æ = Œ£-contractSnd Œª a ‚Üí isOfHLevelŒ£ 0 (isContrSingl (f a))
                                              (Œª p ‚Üí isContrSingl (g (p .fst)))


------------------------------------------------------------------------
-- ‡© ¬ ‡‡®‡®‡‡-‡≤‡‡ñ‡æ ‚î AND AT EVERY LENGTH, by induction.
--
-- ¬ß‡® fenced itself at two steps and named the n-fold version as an
-- induction nobody had written.  This writes it, for the iterated case:
-- one endomorphism, a trail of `n` steps, every intermediate and every
-- witness carried.  Contractible for every `n`.
--
-- So the audit trail of an arbitrarily long computation is informationally
-- free ‚î which is the statement the whole per-edge economics rests on, and
-- it is four lines.  What is bounded is not the trail; it is what the
-- MAPS destroy, and that is the other binding entirely.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Unit using (Unit ; isContrUnit)

module _ {A : Type ‚Ñì} (h : A ‚Üí A) where

  -- the trail of n steps from a, with every image and every witness
  ‡§Ö‡§®‡§®‡•ç‡§§-‡§≤‡•á‡§ñ‡§æ : ‚Ñï ‚Üí A ‚Üí Type ‚Ñì
  ‡§Ö‡§®‡§®‡•ç‡§§-‡§≤‡•á‡§ñ‡§æ zero    a = Unit*
    where open import Cubical.Data.Unit using (Unit*)
  ‡§Ö‡§®‡§®‡•ç‡§§-‡§≤‡•á‡§ñ‡§æ (suc n) a = Œ£[ p ‚àà singl (h a) ] ‡§Ö‡§®‡§®‡•ç‡§§-‡§≤‡•á‡§ñ‡§æ n (p .fst)

  ‡§Ö‡§®‡§®‡•ç‡§§-‡§≤‡•á‡§ñ‡§æ-‡§Æ‡•Å‡§ï‡•ç‡§§‡§æ : (n : ‚Ñï) (a : A) ‚Üí isContr (‡§Ö‡§®‡§®‡•ç‡§§-‡§≤‡•á‡§ñ‡§æ n a)
  ‡§Ö‡§®‡§®‡•ç‡§§-‡§≤‡•á‡§ñ‡§æ-‡§Æ‡•Å‡§ï‡•ç‡§§‡§æ zero    a = isContrUnit*
    where open import Cubical.Data.Unit using (isContrUnit*)
  ‡§Ö‡§®‡§®‡•ç‡§§-‡§≤‡•á‡§ñ‡§æ-‡§Æ‡•Å‡§ï‡•ç‡§§‡§æ (suc n) a =
    isContrŒ£ (isContrSingl (h a)) (Œª p ‚Üí ‡§Ö‡§®‡§®‡•ç‡§§-‡§≤‡•á‡§ñ‡§æ-‡§Æ‡•Å‡§ï‡•ç‡§§‡§æ n (p .fst))
