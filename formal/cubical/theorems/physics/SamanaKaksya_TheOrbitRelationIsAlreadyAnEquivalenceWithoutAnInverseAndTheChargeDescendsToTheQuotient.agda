{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ ‚î ‡‡ï‡ï‡ï‡‡‡‡Ø‡‡‡µ‡ ‡‡Æ‡‡æ ‡‡µ, ‡µ‡‡Ø‡‡‡‡ï‡‡∞‡Æ‡ ‡µ‡ø‡®‡æ ‡
--
-- (lying on one orbit is already an equivalence relation, with no
--  inverse; and the charge descends to the quotient.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS, and it is a CORRECTION before it is an addition.
--
-- `Kaksya_TheChargeIsConstantAlongTheWholeOrbit‚¶agda` ¬ß‡ names its own
-- open item and, in naming it, states a fork:
--
--     "the orbit RELATION and its quotient, and `Œ¶` without an inverse
--      does not give an equivalence relation ‚î `a ~ Œ¶‚ø a` is reflexive
--      and transitive and not symmetric.  So the honest next rung is
--      either (a) require `Œ¶` to be an equivalence and take the
--      groupoid it generates, or (b) state descent along the
--      reflexive-transitive closure and accept a preorder rather than
--      a quotient."
--
-- `Dhruva_‚¶agda` ¬ß‡ names the same debt from its side: "'the charge is
-- a function on the quotient, not on the cover' is stateable here and
-- is not stated yet."
--
-- **The fork is over-specified, and neither rung is needed.**  The
-- relation that was tried ‚î `a ~ b := Œ[ n ] Œ¶‚ø a ‚â° b`, "b is
-- downstream of a" ‚î is indeed not symmetric.  But that is not the
-- orbit relation; it is the reachability relation, which is a
-- different object.  Lying on ONE orbit is
--
--     a ‚âà b  :=  Œ[ m ‚àà ‚ï ] Œ[ n ‚àà ‚ï ] Œ¶µê a ‚â° Œ¶‚ø b,
--
-- "the two trajectories MEET".  This is symmetric by swapping the two
-- numbers and `sym` ‚î ¬ß‡® below is three symbols ‚î reflexive at
-- `(0,0,refl)`, and transitive by the commutation of iterates, which
-- holds for a bare endomorphism.  So the equivalence relation the two
-- modules said needed an inverse needs nothing at all: `Œ¶` stays a
-- bare endomorphism throughout ¬ß‡ß‚ì¬ß‡, exactly as it was.
--
-- With that, ¬ß‡ is the genuine descent statement both files defer:
-- for `B` a set, `f` factors as `fÃ ‚àò [_]` through `A / ‚âà`, and the
-- factorisation triangle is `refl` because `SetQuotients.rec` computes
-- on `[ a ]`.  That is "the charge is a function on the quotient, not
-- on the cover" with a quotient actually present, not simulated on the
-- cover as `Kaksya` ¬ß‡®‚ì¬ß‡© had to do.
--
-- ¬ß‡ then shows rung (a) is not a strengthening but a special case:
-- if `Œ¶` IS an equivalence, its inverse conserves automatically ‚î
-- conservation of `Œ¶` propagates backwards, one `sym` and one `cong`
-- ‚î and `Œ¶‚ª¬ a ‚âà a` holds by `(1, 0, secEq)`.  So the group of
-- `SamraksakaSamuha_‚¶` sits inside this, and nothing in ¬ß‡ß‚ì¬ß‡ was
-- waiting on it.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- **`isSet B` is used only for the quotient** (¬ß‡), not for ¬ß‡ß‚ì¬ß‡©, and
-- `A` is not assumed to be a set anywhere.
--
-- TERMS.  ‡ï‡ï‡‡‡‡Ø‡æ ‚î orbit / orbital circle in the siddhntic
-- astronomical tradition (ryabhaa, ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡, 499, and standard in
-- the Sryasiddhnta after); the term is carried in unchanged from
-- `Kaksya_‚¶agda`, with its limit unchanged: attested for a planet's
-- orbit, and its use for the orbit of an endomorphism is this
-- corpus's.  ‡‡Æ‡æ‡® ‚î "same, equal", ordinary .  The compound
-- ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ, "same-orbit-ness", is BUILT HERE; no text is claimed for
-- it.  No source states anything below.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 ‚î the container, NOT the
-- repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes, exit 0.
------------------------------------------------------------------------

module SamanaKaksya_TheOrbitRelationIsAlreadyAnEquivalenceWithoutAnInverseAndTheChargeDescendsToTheQuotient where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; invEq ; secEq ; _‚âÉ_)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-comm)
open import Cubical.Data.Sigma
open import Cubical.HITs.SetQuotients using (_/_ ; [_] ; eq/) renaming (rec to /rec)

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç)
open import Kaksya_TheChargeIsConstantAlongTheWholeOrbitAndNotOnlyAcrossOneStep
  using (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ ; ‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡ï‡ï‡‡‡‡Ø‡æ-‡Ø‡ã‡ó‡ ‚î iterates add, and therefore commute.
--
-- Both are about `Œ¶` alone; `f` plays no part and no inverse is used.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} (Œ¶ : A ‚Üí A) where

  private
    -- `‡ï‡ï‡‡‡‡Ø‡æ` is stated for a pair (f , Œ¶); the observable is not used
    -- in its definition, so any codomain map will do to name it here.
    œÜ : ‚Ñï ‚Üí A ‚Üí A
    œÜ = ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ {B = A} (Œª a ‚Üí a) Œ¶

  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§Ø‡•ã‡§ó‡§É : (m n : ‚Ñï) (a : A) ‚Üí œÜ (m + n) a ‚â° œÜ m (œÜ n a)
  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§Ø‡•ã‡§ó‡§É zero    n a = refl
  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§Ø‡•ã‡§ó‡§É (suc m) n a = cong Œ¶ (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§Ø‡•ã‡§ó‡§É m n a)

  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡§É : (m n : ‚Ñï) (a : A) ‚Üí œÜ m (œÜ n a) ‚â° œÜ n (œÜ m a)
  ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡§É m n a =
    sym (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§Ø‡•ã‡§ó‡§É m n a) ‚àô cong (Œª k ‚Üí œÜ k a) (+-comm m n) ‚àô ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§Ø‡•ã‡§ó‡§É n m a

------------------------------------------------------------------------
-- ‡® ¬ ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ ‚î THE ORBIT RELATION, AND IT IS AN EQUIVALENCE.
--
-- `a ‚âà b` says the two forward trajectories MEET.  Not "b is reachable
-- from a" ‚î that is the asymmetric relation, and it is the one whose
-- asymmetry was mistaken for the orbit's.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} (Œ¶ : A ‚Üí A) where

  private
    œÜ : ‚Ñï ‚Üí A ‚Üí A
    œÜ = ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ {B = A} (Œª a ‚Üí a) Œ¶

  ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ : A ‚Üí A ‚Üí Type ‚Ñì
  ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ a b = Œ£[ m ‚àà ‚Ñï ] Œ£[ n ‚àà ‚Ñï ] (œÜ m a ‚â° œÜ n b)

  -- reflexive: stay put on both sides.
  ‡§∏‡§Æ‡§æ‡§®-‡§∏‡•ç‡§µ : (a : A) ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ a a
  ‡§∏‡§Æ‡§æ‡§®-‡§∏‡•ç‡§µ a = zero , zero , refl

  -- SYMMETRIC.  This is the whole of the correction: swap the two
  -- stations and reverse the meeting.  No inverse of `Œ¶` occurs.
  ‡§∏‡§Æ‡§æ‡§®-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡§É : (a b : A) ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ a b ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ b a
  ‡§∏‡§Æ‡§æ‡§®-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡§É a b (m , n , p) = n , m , sym p

  -- transitive: push each meeting along by the other's station, and
  -- use ¬ß‡ß's commutation to line them up.
  ‡§∏‡§Æ‡§æ‡§®-‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§É : (a b c : A) ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ a b ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ b c ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ a c
  ‡§∏‡§Æ‡§æ‡§®-‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§É a b c (m , n , p) (p' , q , r) =
    (p' + m) , (n + q) ,
      ( ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§Ø‡•ã‡§ó‡§É Œ¶ p' m a
      ‚àô cong (œÜ p') p
      ‚àô ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡§É Œ¶ p' n b
      ‚àô cong (œÜ n) r
      ‚àô sym (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§Ø‡•ã‡§ó‡§É Œ¶ n q c) )

------------------------------------------------------------------------
-- ‡© ¬ ‡ß‡‡∞‡‡µ‡ ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ‡Ø‡æ‡Æ‡ ‚î the charge cannot separate two points of
--     one orbit, in the two-sided sense ¬ß‡® now supplies.
--
-- `Kaksya` ¬ß‡© gives this for two stations of ONE trajectory.  Here the
-- two points need not be on one trajectory at all: it is enough that
-- their trajectories meet.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A) where

  ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡•á-‡§Ö‡§≠‡•á‡§¶‡§É : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí (a b : A) ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a b ‚Üí f a ‚â° f b
  ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡•á-‡§Ö‡§≠‡•á‡§¶‡§É cons a b (m , n , p) =
      sym (‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç f Œ¶ cons m a)
    ‚àô cong f p
    ‚àô ‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç f Œ¶ cons n b

------------------------------------------------------------------------
-- ‡ ¬ ‡‡µ‡‡∞‡‡Æ‡ ‚î THE CHARGE IS A FUNCTION ON THE QUOTIENT.
--
-- This is the statement `Dhruva` ¬ß‡ says is "stateable here and is not
-- stated yet", now with the quotient present.  `fÃ` is defined on
-- `A / ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ`, and the factorisation `f ‚â° fÃ ‚àò [_]` is `refl`,
-- because `SetQuotients.rec` computes on a point class.
--
-- `isSet B` is the quotient's requirement and nothing else's.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A)
         (setB : isSet B) (cons : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶) where

  ‡§≠‡§æ‡§ó‡§É : Type ‚Ñì
  ‡§≠‡§æ‡§ó‡§É = A / ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶

  ‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É : ‡§≠‡§æ‡§ó‡§É ‚Üí B
  ‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É = /rec setB f (‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡•á-‡§Ö‡§≠‡•á‡§¶‡§É f Œ¶ cons)

  -- the triangle, on the nose
  ‡§Ö‡§µ‡§§‡§∞‡§£-‡§§‡•ç‡§∞‡§ø‡§ï‡•ã‡§£‡§É : (a : A) ‚Üí ‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É [ a ] ‚â° f a
  ‡§Ö‡§µ‡§§‡§∞‡§£-‡§§‡•ç‡§∞‡§ø‡§ï‡•ã‡§£‡§É a = refl

------------------------------------------------------------------------
-- ‡ ¬ ‡µ‡‡Ø‡‡‡‡ï‡‡∞‡Æ‡ ‚î and the inverse case is a special case, not a
--     stronger hypothesis.
--
-- `Kaksya` ¬ß‡'s rung (a) proposed requiring `Œ¶` to be an equivalence.
-- If it is, two things follow and neither is needed above:
--
--   (a) conservation propagates BACKWARDS with no extra hypothesis ‚î
--       so the "conserving inverse" that `SamraksakaSamuha_‚¶` carries
--       as stored data is derivable whenever the flow is invertible;
--   (b) `Œ¶‚ª¬ a` and `a` lie on one orbit, at stations `(1, 0)`.
--
-- So the group of invertible conserving flows acts within the classes
-- of ¬ß‡®, and ¬ß‡ß‚ì¬ß‡ were never waiting on it.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A) (e : isEquiv Œ¶) where

  private
    Œµ : A ‚âÉ A
    Œµ = Œ¶ , e

  ‡§µ‡•ç‡§Ø‡•Å‡§§‡•ç‡§ï‡•ç‡§∞‡§Æ-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f (invEq Œµ)
  ‡§µ‡•ç‡§Ø‡•Å‡§§‡•ç‡§ï‡•ç‡§∞‡§Æ-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç cons a =
    sym (cons (invEq Œµ a)) ‚àô cong f (secEq Œµ a)

  ‡§µ‡•ç‡§Ø‡•Å‡§§‡•ç‡§ï‡•ç‡§∞‡§Æ‡§É-‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡•á : (a : A) ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ (invEq Œµ a) a
  ‡§µ‡•ç‡§Ø‡•Å‡§§‡•ç‡§ï‡•ç‡§∞‡§Æ‡§É-‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡•á a = suc zero , zero , secEq Œµ a

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î what stays open, stated so the next rung is not
--     over-specified again.
--
-- ~~The converse of ¬ß‡ ‚î that `‡‡µ‡‡‡∞‡‡‡` is injective, i.e. equal charge
-- implies one orbit ‚î is `Kaksya` ¬ß‡'s `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡` and is a genuine
-- hypothesis about the flow, not a missing definition.~~
--
-- **STRUCK, and by a checked counterexample, not by a re-reading.  Left
-- standing because striking silently is how this repository loses its
-- own history.**  `Sankramana_TheFibreIsOneOrbitExactlyWhenTheChargeIs
-- InjectiveAndOneSidedReachabilityIsStrictlyStronger.agda` shows
-- `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡` is SUFFICIENT and NOT NECESSARY, and exhibits the gap:
-- `A = Bool`, `B = Unit`, `f = Œª _ ‚í tt`, `Œ¶ = Œª _ ‚í true`.  Every pair
-- meets at stations `(1,1)`, so `‡‡µ‡‡‡∞‡‡‡` is an equivalence, while
-- `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ tt ‚í ‚ä` ‚î nothing ever reaches `false`.  I wrote
-- "is exactly" of a one-sided reachability hypothesis while the whole
-- point of ¬ß‡® above was that the orbit relation is two-sided, which is
-- the error ¬ß‡® exists to correct, committed four sections later in the
-- same file.  The exact hypothesis is the truncated two-sided one, and
-- that module proves the ‚ü∫ and the equivalence
-- `isEquiv fÃ ‚â (isSurjection f ó ‚à b ‚í ‚àtwo-sided‚à‚)`.
--
-- What ¬ß‡® shows is still that only the SYMMETRY half of the old fork
-- was a mirage; a transitivity-shaped hypothesis is real and remains
-- one ‚î but it is not the one named here.
--
-- Unaddressed here: whether `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ` is valued in propositions
-- (it is not, in general ‚î the meeting stations are data), and hence
-- what `‡‡æ‡ó‡` is the quotient BY when the relation carries content.
-- `SetQuotients` truncates it, which is the right move for ¬ß‡ and is
-- the wrong move for any groupoid-level reading of the same orbit.
--
-- [2026-08-23 ‚î ANSWERED, and the answer is stronger than the guess.
-- `SamagamaSthana_TheOrbitRelationIsNeverAPropositionAtAPointAndThe
-- TruncationLosesTheStations.agda` ¬ß‡ß proves that `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ Œ¶ a a` is
-- not a proposition for EVERY `A`, EVERY `Œ¶` and EVERY `a` ‚î not merely
-- "in general" ‚î because the diagonal meetings `(0,0,refl)` and
-- `(1,1,refl)` are always there.  ¬ß‡® there proves the station map does
-- not factor through `‚à_‚à‚`, and ¬ß‡© computes the gap exactly in the
-- smallest case: `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ id tt tt ‚â ‚ï ó ‚ï` on `Unit`.  What is
-- still open is the second half of the sentence above ‚î the
-- groupoid-level quotient itself ‚î and its shape is restated there.]
------------------------------------------------------------------------
