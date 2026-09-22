{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ ‚î ‡‡ï‡ï‡ï‡‡‡‡Ø‡‡‡µ‡ ‡‡Æ‡‡æ ‡‡µ, ‡µ‡‡Ø‡‡‡‡ï‡‡∞‡Æ‡ ‡µ‡ø‡®‡æ ‡
--
-- (lying on one orbit is already an equivalence relation, with no
--  inverse; and the charge descends to the quotient.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.
--
-- For a bare endomorphism `Œ¶`, the reachability relation `a ~ Œ¶‚ø a` is
-- reflexive and transitive and not symmetric, which suggests a fork:
-- either (a) require `Œ¶` to be an equivalence and take the groupoid it
-- generates, or (b) state descent along the reflexive-transitive
-- closure and accept a preorder rather than a quotient.
--
-- **The fork is over-specified, and neither rung is needed.**  The
-- reachability relation ‚î `a ~ b := Œ[ n ] Œ¶‚ø a ‚â° b`, "b is
-- downstream of a" ‚î is indeed not symmetric.  But that is not the
-- orbit relation; it is a different object.  Lying on ONE orbit is
--
--     a ‚âà b  :=  Œ[ m ‚àà ‚ï ] Œ[ n ‚àà ‚ï ] Œ¶µê a ‚â° Œ¶‚ø b,
--
-- "the two trajectories MEET".  This is symmetric by swapping the two
-- numbers and `sym` ‚î ¬ß‡® below is three symbols ‚î reflexive at
-- `(0,0,refl)`, and transitive by the commutation of iterates, which
-- holds for a bare endomorphism.  So the equivalence relation needs no
-- inverse at all: `Œ¶` stays a bare endomorphism throughout ¬ß‡ß‚ì¬ßÔøΩ.
--
-- With that, ¬ß‡ is the genuine descent statement:
-- for `B` a set, `f` factors as `fÃ ‚àò [_]` through `A / ‚âà`, and the
-- factorisation triangle is `refl` because `SetQuotients.rec` computes
-- on `[ a ]`.  That is "the charge is a function on the quotient, not
-- on the cover" with a quotient actually present, rather than stated on
-- the cover as in `Kaksya` ¬ß‡®‚ì¬ßÔøΩ.
--
-- ¬ß‡ then shows rung (a) is not a strengthening but a special case:
-- if `Œ¶` IS an equivalence, its inverse conserves automatically ‚î
-- conservation of `Œ¶` propagates backwards, one `sym` and one `cong`
-- ‚î and `Œ¶‚ª¬ a ‚âà a` holds by `(1, 0, secEq)`.  So the group of
-- `SamraksakaSamuha_‚¶` sits inside this, and ¬ß‡ß‚ì¬ß‡ do not use it.
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
-- from a" ‚î that is the asymmetric relation, and it is not the orbit's.
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
-- The charge is a function on the quotient, with the quotient present.
-- `fÃ` is defined on
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
-- Rung (a) proposed requiring `Œ¶` to be an equivalence.
-- If it is, two things follow and neither is needed above:
--
--   (a) conservation propagates BACKWARDS with no extra hypothesis ‚î
--       so the "conserving inverse" that `SamraksakaSamuha_‚¶` carries
--       as stored data is derivable whenever the flow is invertible;
--   (b) `Œ¶‚ª¬ a` and `a` lie on one orbit, at stations `(1, 0)`.
--
-- So the group of invertible conserving flows acts within the classes
-- of ¬ß‡®, and ¬ß‡ß‚ì¬ß‡ do not use it.
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
-- ‡ ¬ ‡‡‡‡ ‚î the converse, and the h-level of the relation.
--
-- The converse of ¬ß‡ ‚î that `‡‡µ‡‡‡∞‡ÔøΩ‡` is injective, i.e. equal charge
-- implies one orbit ‚î is the subject of
-- `Sankramana_TheFibreIsOneOrbitExactlyWhenTheChargeIs
-- InjectiveAndOneSidedReachabilityIsStrictlyStronger.agda`.  `Kaksya`
-- ¬ß‡'s one-sided `‡ÔøΩÔøΩ‡‡ï‡‡∞‡Æ‡ÔøΩ‡` is SUFFICIENT and NOT NECESSARY:
-- `A = Bool`, `B = Unit`, `f = Œª _ ‚í tt`, `Œ¶ = Œª _ ‚í true`.  Every pair
-- meets at stations `(1,1)`, so `‡‡µ‡‡‡∞‡‡‡` is an equivalence, while
-- `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ tt ‚í ‚ä` ‚î nothing ever reaches `false`.  The exact
-- hypothesis is the truncated two-sided one, and that module proves the
-- ‚ü∫ and the equivalence
-- `isEquiv fÃ ‚â (isSurjection f ó ‚à b ‚í ‚àtwo-sided‚à‚)`.
--
-- `‡ÔøΩ‡æ‡®‡ï‡ï‡‡‡‡ØÔøΩ` is not valued in propositions ‚î the meeting stations are
-- data.  `SamagamaSthana_TheOrbitRelationIsNeverAPropositionAtAPointAndThe
-- TruncationLosesTheStations.agda` ¬ß‡ß proves that `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ Œ¶ a a` is
-- not a proposition for EVERY `A`, EVERY `Œ¶` and EVERY `a`, because the
-- diagonal meetings `(0,0,refl)` and `(1,1,refl)` are always there.
-- ¬ß‡® there proves the station map does not factor through `‚à_‚à‚`, and
-- ¬ß‡© computes the gap exactly in the smallest case:
-- `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ id tt tt ‚â ‚ï ó ‚ï` on `Unit`.  `SetQuotients` truncates
-- the relation, which is the right move for ¬ßÔøΩ.
------------------------------------------------------------------------
