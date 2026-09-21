{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡‡‡‡‡æ‡≤‡Æ‡ ‚î ‡‡®‡‡‡ã‡ ‡‡‡∞‡Ø‡ã ‡®‡ø‡∞‡‡‡Ø‡æ‡ ; isContr ‡¶‡‡µ‡ ‡Æ‡‡≤‡Ø‡‡ø ‡
--
-- (the fiber has three verdicts, and `isContr` merges two of them.)
--
-- WHAT THIS IS FOR.  It is the CODOMAIN of a census.  A tool that walks this
-- corpus asking "is this datum determined?" needs somewhere to put its
-- answer, and if that somewhere is `Bool` the tool commits the very collapse
-- the corpus exists to refuse.  `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` proves it: ANY
-- two-valued verdict on three seeds identifies two of them.  ¬ß‡ instantiates
-- that at the fiber, so the claim is not an analogy.
--
-- THE THREE VERDICTS, and the whole content is that they are THREE.
--
--   ‡∞‡ø‡ï‡‡‡Æ‡  the fiber is EMPTY.  ‡®‡‡‡ü‡ø / ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡: there is no return, and
--          there is nothing to carry.  No `Carrier`, no `ua`, nothing to
--          transport.  ¬ß‡ of ‡‡‡ø‡‡‡æ-‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞‡: ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡Æ‡.
--   ‡‡ï‡Æ‡    the fiber is CONTRACTIBLE.  ‡‡‡®‡∞‡æ‡ó‡Æ‡®: the datum is determined,
--          rides free, and `singl` gives it with no hypothesis whatever.
--   ‡‡‡     the fiber has TWO DISTINCT POINTS.  Not a failure ‚î the fiber is
--          the SUBJECT.  `TheFiberIsTheSubject`: the
--          obstruction reading calls it a barrier and stops; the ‡‡æ‡µ‡®‡æ
--          reading calls it a set with a group acting on it and computes.
--
-- WHICH VERDICT YOU GET IS DECIDED BY WHICH SIDE OF `f a ‚â° b` IS BOUND, and
-- that is the one-line criterion five independent lines of work in this
-- corpus arrived at separately:
--
--   bind b :  Œ[ b ‚àà B ] (f a ‚â° b)  =  singl (f a)   ‚î ‡‡ï‡Æ‡, always, free.
--   bind a :  Œ[ a ‚àà A ] (f a ‚â° b)  =  fiber f b     ‚î any of the three.
--
-- ¬ß‡® is that sentence as two terms.  A determined datum carried as a FIELD
-- binds b; the same datum fixed as an INDEX binds a.  That is why
-- `Reduction A` is a Carrier and `SmithPresentation A B` is not, why the
-- kuaka's three slots refused, and why `Sol D k` is a level set rather
-- than a graph.
--
-- AND THE AGGREGATE IS ALREADY IN THE LIBRARY.  `isEquiv f` IS
-- `(b : B) ‚í isContr (fiber f b)` ‚î ‡‡ï‡Æ‡ at every point at once, which is
-- ‡‡ï‡≤‡æ‡¶‡‡ and not a search with a first step.  ¬ß‡ records that, and records
-- what it buys: when every fiber is ‡‡ï‡Æ‡, base and carried may be EXCHANGED,
-- so storing and generating are the same type ‚î ¬ß‡‡ß ‡‡æ‡∞‡‡ ‡µ‡æ ‡ï‡‡∞‡ø‡Ø‡æ as an
-- identity rather than a trade.
--
-- What exists in the corpus is
-- `NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn.‡‡‡∞‡‡‡‡æ‡∞‡`, and it gives
--
--     ‡‡‡∞‡‡‡‡æ‡∞‡ : (rs : List ‚ï) ‚í Iso (‡‡ô‡‡ï‡‡‡‡æ‡® rs) (Fin (‡‡ô‡‡ñ‡‡Ø‡æ rs))
--
-- ‚î a FINITE type, at each fixed ‡‡‡¶-‡‡‡‡ rs, from two separately proved
-- procedures (‡â‡¶‡‡¶‡ø‡‡‡ü by addition and multiplication, ‡®‡‡‡ü by division) with
-- no table stored.  By univalence that is `‡‡ô‡‡ï‡‡‡‡æ‡® rs ‚â° Fin (‡‡ô‡‡ñ‡‡Ø‡æ rs)`,
-- and at rs = [] it reads `Unit ‚â° Fin 1`.
--
-- The exchange claim is that at each rs the space of
-- stored patterns and the range of indices are equal AS TYPES, so keeping the
-- ‡‡æ‡∞‡‡ and running the ‡ï‡‡∞‡ø‡Ø‡æ are one object.  ¬ß‡‡ß is an identity.
------------------------------------------------------------------------

module Tantujala_TheFiberHasThreeVerdictsAndIsContrMergesTwoOfThem where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber ; isEquiv ; equivIsEquiv ; idEquiv)
open import Cubical.Data.Sigma using (Œ£ ; Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_‚äé_)
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

import Saptabhangi as S

private
  variable
    ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡∞‡Ø‡ã ‡®‡ø‡∞‡‡‡Ø‡æ‡ ‚î the three, as types.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} {B : Type ‚Ñì'} (f : A ‚Üí B) where

  ‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç : B ‚Üí Type (‚Ñì-max ‚Ñì ‚Ñì')
  ‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç b = ¬¨ (fiber f b)

  ‡§è‡§ï‡§Æ‡•ç : B ‚Üí Type (‚Ñì-max ‚Ñì ‚Ñì')
  ‡§è‡§ï‡§Æ‡•ç b = isContr (fiber f b)

  ‡§¨‡§π‡•Å : B ‚Üí Type (‚Ñì-max ‚Ñì ‚Ñì')
  ‡§¨‡§π‡•Å b = Œ£[ x ‚àà fiber f b ] Œ£[ y ‚àà fiber f b ] (¬¨ (x ‚â° y))

  ----------------------------------------------------------------------
  -- ‡® ¬ ‡ï‡‡‡Æ‡ø‡®‡ ‡‡ï‡‡‡ ‡‡¶‡‡ß‡Æ‡ ‚î which side is bound.
  --
  -- Binding the SECOND coordinate is `singl`, contractible with no
  -- hypothesis at all.  Binding the FIRST is `fiber`, which is any of the
  -- three.  One equation, two readings, opposite verdicts ‚î and that is
  -- the whole criterion.
  ----------------------------------------------------------------------

  ‡§µ‡§π‡§®‡§Æ‡•ç : A ‚Üí Type ‚Ñì'
  ‡§µ‡§π‡§®‡§Æ‡•ç a = Œ£[ b ‚àà B ] (f a ‚â° b)      -- bind b: the graph fiber

  ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡§Æ‡•ç : B ‚Üí Type (‚Ñì-max ‚Ñì ‚Ñì')
  ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡§Æ‡•ç b = Œ£[ a ‚àà A ] (f a ‚â° b) -- bind a: the preimage

  ‡§µ‡§π‡§®‡§Æ‡•ç-‡§∏‡§¶‡§æ-‡§è‡§ï‡§Æ‡•ç : (a : A) ‚Üí isContr (‡§µ‡§π‡§®‡§Æ‡•ç a)
  ‡§µ‡§π‡§®‡§Æ‡•ç-‡§∏‡§¶‡§æ-‡§è‡§ï‡§Æ‡•ç a = isContrSingl (f a)

  -- and the preimage IS the fiber, definitionally: the two readings differ
  -- only in which variable the Œ binds.
  ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡§Æ‡•ç-‡§§‡§®‡•ç‡§§‡•Å‡§É : (b : B) ‚Üí ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡§Æ‡•ç b ‚â° fiber f b
  ‡§™‡•ç‡§∞‡§§‡§ø‡§¨‡§ø‡§Æ‡•ç‡§¨‡§Æ‡•ç-‡§§‡§®‡•ç‡§§‡•Å‡§É _ = refl

  ----------------------------------------------------------------------
  -- ‡© ¬ ‡‡∞‡‡‡‡∞-‡µ‡ø‡∞‡ã‡ß‡ ‚î the three exclude one another.
  ----------------------------------------------------------------------

  ‡§∞‡§ø‡§ï‡•ç‡§§-‡§è‡§ï-‡§µ‡§ø‡§∞‡•ã‡§ß‡§É : (b : B) ‚Üí ‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç b ‚Üí ‡§è‡§ï‡§Æ‡•ç b ‚Üí ‚ä•
  ‡§∞‡§ø‡§ï‡•ç‡§§-‡§è‡§ï-‡§µ‡§ø‡§∞‡•ã‡§ß‡§É b r e = r (e .fst)

  ‡§∞‡§ø‡§ï‡•ç‡§§-‡§¨‡§π‡•Å-‡§µ‡§ø‡§∞‡•ã‡§ß‡§É : (b : B) ‚Üí ‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç b ‚Üí ‡§¨‡§π‡•Å b ‚Üí ‚ä•
  ‡§∞‡§ø‡§ï‡•ç‡§§-‡§¨‡§π‡•Å-‡§µ‡§ø‡§∞‡•ã‡§ß‡§É b r m = r (m .fst)

  ‡§è‡§ï-‡§¨‡§π‡•Å-‡§µ‡§ø‡§∞‡•ã‡§ß‡§É : (b : B) ‚Üí ‡§è‡§ï‡§Æ‡•ç b ‚Üí ‡§¨‡§π‡•Å b ‚Üí ‚ä•
  ‡§è‡§ï-‡§¨‡§π‡•Å-‡§µ‡§ø‡§∞‡•ã‡§ß‡§É b e (x , y , x‚â¢y) =
    x‚â¢y (sym (e .snd x) ‚àô e .snd y)

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡‡∞‡‡®‡Ø‡ ‡‡®‡‡‡ ‚î THE POINT.  A two-valued verdict must merge two.
--
-- `Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡` says: any `f : ‡‡‡‡‡‡ô‡‡ó‡ ‚í ‡¶‡‡µ‡ø‡‡¶` identifies two of
-- ‡‡‡‡‡ø / ‡®‡æ‡‡‡‡ø / ‡‡µ‡ï‡‡‡µ‡‡Ø.  Read the three fiber verdicts as those three
-- seeds ‚î ‡∞‡ø‡ï‡‡‡Æ‡ is ‡‡µ‡ï‡‡‡µ‡‡Ø (nothing sayable), ‡‡ï‡Æ‡ is ‡‡‡‡‡ø, ‡‡‡ is ‡®‡æ‡‡‡‡ø ‚î
-- and the conclusion transfers verbatim: a census whose answer type has two
-- values CANNOT distinguish the three, whatever it computes.
--
-- Stated by instantiating the existing theorem rather than reproving it.
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§ø‡§™‡§¶-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡•ã-‡§Æ‡•á‡§≤‡§Ø‡§§‡§ø :
    (v : S.‡§∏‡§™‡•ç‡§§‡§≠‡§ô‡•ç‡§ó‡•Ä ‚Üí S.‡§¶‡•ç‡§µ‡§ø‡§™‡§¶)
  ‚Üí  (v S.‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø ‚â° v S.‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø)
  ‚äé ((v S.‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø ‚â° v S.‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç)
  ‚äé  (v S.‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø ‚â° v S.‡§∏‡•ç‡§Ø‡§æ‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç))
‡§¶‡•ç‡§µ‡§ø‡§™‡§¶-‡§®‡§ø‡§∞‡•ç‡§£‡§Ø‡•ã-‡§Æ‡•á‡§≤‡§Ø‡§§‡§ø = S.‡§¶‡•Å‡§∞‡•ç‡§®‡§Ø‡§É

------------------------------------------------------------------------
-- ‡ ¬ ‡®-‡‡ï‡Æ‡ ‡ï‡ø‡Æ‡ ‡‡‡ø ‡® ‡µ‡¶‡‡ø ‚î "not contractible" does not say which.
--
-- The load-bearing half.  Two maps, both failing ‡‡ï‡Æ‡ at a point, for
-- OPPOSITE reasons.  A verdict that reports only `¬ ‡‡ï‡Æ‡` has destroyed the
-- distinction between "nothing is there" and "the subject is there".
------------------------------------------------------------------------

-- ‡∞‡ø‡ï‡‡ side: the map ‚ä ‚í Unit misses tt.
‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : ‚ä• ‚Üí Unit
‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É ()

‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§Ö‡§§‡•ç‡§∞ : ‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§Ö‡§§‡•ç‡§∞ ()

-- ‡‡‡ side: the map Bool ‚í Unit collapses two points onto tt.
‡§∏‡§Æ‡§æ‡§π‡§æ‡§∞-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : Bool ‚Üí Unit
‡§∏‡§Æ‡§æ‡§π‡§æ‡§∞-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É _ = tt

‡§¨‡§π‡•Å-‡§Ö‡§§‡•ç‡§∞ : ‡§¨‡§π‡•Å ‡§∏‡§Æ‡§æ‡§π‡§æ‡§∞-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt
‡§¨‡§π‡•Å-‡§Ö‡§§‡•ç‡§∞ = (true , refl) , (false , refl) , Œª p ‚Üí true‚â¢false (cong fst p)

-- Both fail ‡‡ï‡Æ‡, and nothing in that failure separates them.
‡§â‡§≠‡§Ø‡§§‡•ç‡§∞-‡§®-‡§è‡§ï‡§Æ‡•ç : (¬¨ ‡§è‡§ï‡§Æ‡•ç ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt) √ó (¬¨ ‡§è‡§ï‡§Æ‡•ç ‡§∏‡§Æ‡§æ‡§π‡§æ‡§∞-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt)
‡§â‡§≠‡§Ø‡§§‡•ç‡§∞-‡§®-‡§è‡§ï‡§Æ‡•ç =
    (Œª e ‚Üí ‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§Ö‡§§‡•ç‡§∞ (e .fst))
  , (Œª e ‚Üí ‡§è‡§ï-‡§¨‡§π‡•Å-‡§µ‡§ø‡§∞‡•ã‡§ß‡§É ‡§∏‡§Æ‡§æ‡§π‡§æ‡§∞-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É tt e ‡§¨‡§π‡•Å-‡§Ö‡§§‡•ç‡§∞)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡ï‡≤‡æ‡¶‡‡‡ ‚î the aggregate, and it is already the library's.
--
-- `isEquiv f` is DEFINITIONALLY "‡‡ï‡Æ‡ at every b".  So the total verdict is
-- not a search with a first step ‚î it is a census over the whole codomain
-- at once, which is exactly ‡‡ï‡≤‡æ‡¶‡‡ against ‡µ‡ø‡ï‡≤‡æ‡¶‡‡.  It is a RECORD wrapping
-- that Œ† rather than the Œ† itself, so the two directions are one projection
-- and one copattern -- not refl, and saying so is the honest form.  Recorded here because
-- a seat of this corpus spent hours proposing a sequential diagnostic
-- before noticing the simultaneous one was the definition.
------------------------------------------------------------------------

‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂‡§É : {A : Type ‚Ñì} {B : Type ‚Ñì'} (f : A ‚Üí B)
         ‚Üí isEquiv f ‚Üí (b : B) ‚Üí ‡§è‡§ï‡§Æ‡•ç f b
‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂‡§É f = isEquiv.equiv-proof

‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§É : {A : Type ‚Ñì} {B : Type ‚Ñì'} (f : A ‚Üí B)
                  ‚Üí ((b : B) ‚Üí ‡§è‡§ï‡§Æ‡•ç f b) ‚Üí isEquiv f
isEquiv.equiv-proof (‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§É f g) = g

-- and when the census comes back ‡‡ï‡Æ‡ everywhere, base and carried may be
-- exchanged: `NastaUddista_‚¶.‡‡‡∞‡‡‡‡æ‡∞‡` gives `‡‡ô‡‡ï‡‡‡‡æ‡® rs ‚â° Fin (‡‡ô‡‡ñ‡‡Ø‡æ rs)`
-- from exactly this, so at each ‡‡‡¶-‡‡‡‡ storing and generating are one type.
-- The identity is the smallest instance.
‡§∏‡§Æ‡§§‡§æ-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : {A : Type ‚Ñì} ‚Üí (b : A) ‚Üí ‡§è‡§ï‡§Æ‡•ç (Œª (a : A) ‚Üí a) b
‡§∏‡§Æ‡§§‡§æ-‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É {A = A} b = isEquiv.equiv-proof (equivIsEquiv (idEquiv A)) b

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î what a census still cannot say, and it is not on this axis.
--
-- ‡∞‡ø‡ï‡‡‡Æ‡ is "the question was posed and the answer is nowhere".  It is NOT
-- "no question was posed" ‚î `interactive/Obstruction.hs` carries that as a
-- separate constructor (`Sthana = Position Bhanga | ADharmin`, "x != y has
-- no subject, so no bhanga"), and `Saptabhangi.‡‡Æ‡æ‡µ‡‡-‡‡‡¶‡` puts it in the
-- types as the `‚ä Unit`: ‡‡‡‡‡‡ô‡‡ó‡ plus one void profile, ‡-‡‡‡∞‡‡ø‡‡æ‡¶‡®‡Æ‡.
-- A fiber census reads a GIVEN map at a GIVEN point; where there is no
-- dharmin there is no map to take a fiber of, and this module is silent.
-- `Loss.Adharmin_‚¶` treats that case; the two are complements and
-- neither subsumes the other.
------------------------------------------------------------------------
