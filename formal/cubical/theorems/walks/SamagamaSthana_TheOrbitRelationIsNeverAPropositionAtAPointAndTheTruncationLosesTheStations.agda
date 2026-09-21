{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡Æ‡æ‡ó‡Æ-‡‡‡‡æ‡®‡Æ‡ ‚î ‡Æ‡‡≤‡®‡‡‡‡æ‡®‡ ‡¶‡‡µ‡, ‡® ‡‡‡∞‡‡ø‡‡‡û‡æ ‡‡ï‡æ ‡
--
-- (the meeting has two stations; it is not one proposition.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS.
--
-- `SamanaKaksya_‚¶agda` ¬ß‡ states, in these words:
--
--     "Unaddressed here: whether `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ` is valued in propositions
--      (it is not, in general ‚î the meeting stations are data), and
--      hence what `‡‡æ‡ó‡` is the quotient BY when the relation carries
--      content.  `SetQuotients` truncates it, which is the right move
--      for ¬ß‡ and is the wrong move for any groupoid-level reading of
--      the same orbit."
--
-- This file converts the parenthesis into a theorem, and finds that the
-- true statement is STRONGER than the one asserted.  "Not in general"
-- suggests a counterexample has to be hunted ‚î some particular `A`, some
-- particular `Œ¶`.  It does not.  ¬ß‡ß:
--
--     for EVERY type `A`, EVERY endomorphism `Œ¶`, and EVERY point `a`,
--     `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ Œ¶ a a` is not a proposition.
--
-- No hypothesis on `A` at all ‚î not `isSet`, not inhabitedness beyond the
-- point `a` that the statement already names.  The two witnesses are
-- `(0,0,refl)` ‚î stay put on both sides ‚î and `(1,1,refl)` ‚î step once on
-- both sides.  Both are meetings of `a` with itself; a path between them
-- would give `0 ‚â° 1` in ‚ï by `cong fst`.  The reason is structural and
-- has nothing to do with the dynamics of `Œ¶`: the DIAGONAL of the station
-- pair is always available, so the isotropy of ¬ß‡ß of that file always
-- contains a copy of ‚ï, before any period of the flow is asked for.
--
-- ¬ß‡® is the same fact stated as a loss rather than as a negation: the
-- station map `fst : ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ Œ¶ a a ‚í ‚ï` does NOT factor through the
-- propositional truncation.  Not "need not" ‚î cannot, and the proof is
-- three lines.  That is precisely "`SetQuotients` truncates it": the
-- truncation is exactly the operation that forgets which meeting.
--
-- ¬ß‡© measures the gap in a case where it can be measured on the nose:
-- for `A = Unit` and `Œ¶ = id` ‚î one point, no dynamics whatever, the most
-- degenerate flow there is ‚î `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ Œ¶ tt tt ‚â ‚ï ó ‚ï`.  The
-- SetQuotient identifies all of that with a point.  A relation whose
-- every instance is a copy of ‚ï ó ‚ï is being used as if it were `‚ä`.
--
-- ¬ß‡ is the positive half, and it is what the isotropy is FOR: a period
-- of the flow at `a` ‚î any `p` with `Œ¶µñ a ‚â° a` ‚î acts on the meetings at
-- `a` by shifting a station, on either side.  So periodicity of the flow
-- is literally an action on the isotropy type, and the truncation of ¬ß‡®
-- is what destroys it.  This holds for a bare endomorphism; no inverse.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERMS.  ‡‡Æ‡æ‡ó‡Æ ‚î "coming together, meeting", ordinary ,
-- classical and standard.  ‡‡‡‡æ‡® ‚î "station, place"; used in the
-- siddhntic astronomical texts for a position on an orbit (‡ï‡ï‡‡‡‡Ø‡æ,
-- ryabhaa, ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡, 499; and standard in the Sryasiddhnta after),
-- which is the sense borrowed here.  **The compound ‡‡Æ‡æ‡ó‡Æ-‡‡‡‡æ‡®‡Æ‡ in the
-- sense "the pair of iteration counts at which two forward trajectories
-- coincide" is BUILT HERE.**
-- The LIMIT on ‡ï‡ï‡‡‡‡Ø‡æ is carried in unchanged
-- from `Kaksya_‚¶agda`: attested for a planet's orbit, and its use for the
-- orbit of an endomorphism is this corpus's, not the tradition's.
------------------------------------------------------------------------

module SamagamaSthana_TheOrbitRelationIsNeverAPropositionAtAPointAndTheTruncationLosesTheStations where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; znots)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.HITs.PropositionalTruncation using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; squash‚ÇÅ)

open import Kaksya_TheChargeIsConstantAlongTheWholeOrbitAndNotOnlyAcrossOneStep
  using (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ)
open import SamanaKaksya_TheOrbitRelationIsAlreadyAnEquivalenceWithoutAnInverseAndTheChargeDescendsToTheQuotient
  using (‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ ; ‡§∏‡§Æ‡§æ‡§®-‡§∏‡•ç‡§µ)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡¶ ¬ the two diagonal meetings, named, because everything below is
--     about the pair of them.
--
-- `‡µ‡ø‡‡‡∞‡æ‡Æ` ‚î the meeting where neither side moves; it is `‡‡Æ‡æ‡®-‡‡‡µ`.
-- `‡‡¶‡à‡ï` ‚î the meeting where both sides take exactly one step.  Both are
-- meetings of `a` with itself, for any `Œ¶` at all.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} (Œ¶ : A ‚Üí A) (a : A) where

  ‡§µ‡§ø‡§∂‡•ç‡§∞‡§æ‡§Æ‡§É : ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a
  ‡§µ‡§ø‡§∂‡•ç‡§∞‡§æ‡§Æ‡§É = zero , zero , refl

  ‡§™‡§¶‡•à‡§ï‡§É : ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a
  ‡§™‡§¶‡•à‡§ï‡§É = suc zero , suc zero , refl

  -- the first station distinguishes them, on the nose
  ‡§∏‡•ç‡§•‡§æ‡§®‡§Æ‡•ç : ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a ‚Üí ‚Ñï
  ‡§∏‡•ç‡§•‡§æ‡§®‡§Æ‡•ç = fst

------------------------------------------------------------------------
-- ‡ß ¬ ‡® ‡‡‡∞‡‡ø‡‡‡û‡æ ‚î THE ORBIT RELATION IS NEVER A PROPOSITION AT A POINT.
--
-- `SamanaKaksya` ¬ß‡ says "it is not, in general".  It is not, ever ‚î at
-- any point of any type under any endomorphism.  The witnesses are the
-- two diagonal meetings of ¬ß‡¶, and the separation is `cong fst`.
------------------------------------------------------------------------

  ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§®-‡§™‡•ç‡§∞‡§§‡§ø‡§ú‡•ç‡§û‡§æ : isProp (‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a) ‚Üí ‚ä•
  ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§®-‡§™‡•ç‡§∞‡§§‡§ø‡§ú‡•ç‡§û‡§æ h = znots (cong ‡§∏‡•ç‡§•‡§æ‡§®‡§Æ‡•ç (h ‡§µ‡§ø‡§∂‡•ç‡§∞‡§æ‡§Æ‡§É ‡§™‡§¶‡•à‡§ï‡§É))

  -- and therefore the relation is not prop-valued as a relation
  ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§®-‡§™‡•ç‡§∞‡§§‡§ø‡§ú‡•ç‡§û‡§æ-‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ :
    ((x y : A) ‚Üí isProp (‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ x y)) ‚Üí ‚ä•
  ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§®-‡§™‡•ç‡§∞‡§§‡§ø‡§ú‡•ç‡§û‡§æ-‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ h = ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ-‡§®-‡§™‡•ç‡§∞‡§§‡§ø‡§ú‡•ç‡§û‡§æ (h a a)

------------------------------------------------------------------------
-- ‡® ¬ ‡‡‡ï‡ã‡‡ ‡‡‡‡æ‡®-‡®‡æ‡‡ ‚î THE TRUNCATION DESTROYS THE STATION.
--
-- The same fact with its sign reversed.  ¬ß‡ß says the relation is not a
-- proposition; this says what is lost when it is forced to be one: the
-- station map does not factor through `‚à_‚à‚`.  Not "need not factor" ‚î
-- no factorisation exists.
--
-- This is the exact content of `SamanaKaksya` ¬ß‡'s "`SetQuotients`
-- truncates it".  `/rec` sees only `‚à R ‚à‚`-worth of the relation, so
-- every construction that reads a station is unavailable downstream of
-- the quotient.
------------------------------------------------------------------------

  ‡§∏‡•ç‡§•‡§æ‡§®‡§Ç-‡§®-‡§∏‡§Ç‡§ï‡•ã‡§ö‡§æ‡§§‡•ç :
    (g : ‚à• ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a ‚à•‚ÇÅ ‚Üí ‚Ñï)
    ‚Üí ((r : ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a) ‚Üí g ‚à£ r ‚à£‚ÇÅ ‚â° ‡§∏‡•ç‡§•‡§æ‡§®‡§Æ‡•ç r)
    ‚Üí ‚ä•
  ‡§∏‡•ç‡§•‡§æ‡§®‡§Ç-‡§®-‡§∏‡§Ç‡§ï‡•ã‡§ö‡§æ‡§§‡•ç g fact =
    znots ( sym (fact ‡§µ‡§ø‡§∂‡•ç‡§∞‡§æ‡§Æ‡§É)
          ‚àô cong g (squash‚ÇÅ ‚à£ ‡§µ‡§ø‡§∂‡•ç‡§∞‡§æ‡§Æ‡§É ‚à£‚ÇÅ ‚à£ ‡§™‡§¶‡•à‡§ï‡§É ‚à£‚ÇÅ)
          ‚àô fact ‡§™‡§¶‡•à‡§ï‡§É )

------------------------------------------------------------------------
-- ‡© ¬ ‡‡ï‡‡ø‡®‡‡¶‡ ‡‡‡ø ‚î THE GAP IS ‚ï ó ‚ï ALREADY ON ONE POINT.
--
-- `A = Unit`, `Œ¶ = id`: no room to move, no dynamics, nothing to
-- observe.  The orbit relation on it is still `‚ï ó ‚ï` ‚î every pair of
-- stations is a distinct meeting, because every station is the same
-- point and all the paths between them agree.
--
-- The SetQuotient of ¬ß‡ of `SamanaKaksya` sends all of this to one
-- element.  That is the size of the truncation gap in the smallest case
-- there is.
------------------------------------------------------------------------

private
  ‡§è‡§ï : Unit ‚Üí Unit
  ‡§è‡§ï u = u

  -- every meeting-path in `Unit` is the canonical one
  ‡§è‡§ï-‡§™‡§•‡§É : (x y : Unit) (p : x ‚â° y) ‚Üí p ‚â° isPropUnit x y
  ‡§è‡§ï-‡§™‡§•‡§É x y p = isProp‚ÜíisSet isPropUnit x y p (isPropUnit x y)

‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§∏‡§Æ‡§æ‡§ó‡§Æ‡§æ‡§É : Iso (‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ ‡§è‡§ï tt tt) (‚Ñï √ó ‚Ñï)
‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§∏‡§Æ‡§æ‡§ó‡§Æ‡§æ‡§É = iso to from (Œª _ ‚Üí refl) sect
  where
  œÜ : ‚Ñï ‚Üí Unit ‚Üí Unit
  œÜ = ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ {B = Unit} (Œª u ‚Üí u) ‡§è‡§ï

  to : ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ ‡§è‡§ï tt tt ‚Üí ‚Ñï √ó ‚Ñï
  to (m , n , _) = m , n

  from : ‚Ñï √ó ‚Ñï ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ ‡§è‡§ï tt tt
  from (m , n) = m , n , isPropUnit (œÜ m tt) (œÜ n tt)

  sect : (r : ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ ‡§è‡§ï tt tt) ‚Üí from (to r) ‚â° r
  sect (m , n , p) i = m , n , ‡§è‡§ï-‡§™‡§•‡§É (œÜ m tt) (œÜ n tt) p (~ i)

‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§∏‡§Æ‡§æ‡§ó‡§Æ‡§æ‡§É-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ : ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ ‡§è‡§ï tt tt ‚âÉ (‚Ñï √ó ‚Ñï)
‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§∏‡§Æ‡§æ‡§ó‡§Æ‡§æ‡§É-‡§§‡•Å‡§≤‡•ç‡§Ø‡§§‡§æ = isoToEquiv ‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§∏‡§Æ‡§æ‡§ó‡§Æ‡§æ‡§É

------------------------------------------------------------------------
-- ‡ ¬ ‡‡µ‡‡‡‡‡ø‡ ‡‡‡‡æ‡®‡‡‡ ‡µ‡∞‡‡‡‡ ‚î A PERIOD OF THE FLOW ACTS ON THE
--     MEETINGS.
--
-- This is the positive reading of ¬ß‡ß, and it is where the isotropy earns
-- its name.  Let `p` be a period of `Œ¶` at `a`: `Œ¶µñ a ‚â° a`.  Then `p`
-- acts on the meetings at `a` by adding `p` to a station ‚î on the left,
-- or on the right ‚î and the result is again a meeting.  No inverse of
-- `Œ¶` is used; `Œ¶` is a bare endomorphism throughout.
--
-- So the period structure of the flow is an action on `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ Œ¶ a a`
-- ‚î and ¬ß‡® says that action is exactly what the truncation cannot see.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} (Œ¶ : A ‚Üí A) where

  private
    œÜ : ‚Ñï ‚Üí A ‚Üí A
    œÜ = ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ {B = A} (Œª x ‚Üí x) Œ¶

  -- iterates add (the lemma `SamanaKaksya` ¬ß‡ß proves; restated locally
  -- so this module does not depend on that module's private `œ`)
  ‡§Ø‡•ã‡§ó‡§É : (m n : ‚Ñï) (a : A) ‚Üí œÜ (m + n) a ‚â° œÜ m (œÜ n a)
  ‡§Ø‡•ã‡§ó‡§É zero    n a = refl
  ‡§Ø‡•ã‡§ó‡§É (suc m) n a = cong Œ¶ (‡§Ø‡•ã‡§ó‡§É m n a)

  -- ‡‡µ‡‡‡‡‡ø‡ ‚î a period of the flow at `a`
  ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : A ‚Üí ‚Ñï ‚Üí Type ‚Ñì
  ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É a p = œÜ p a ‚â° a

  -- the period shifts the LEFT station
  ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø-‡§µ‡§æ‡§Æ‡§æ : (a : A) (p : ‚Ñï) ‚Üí ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É a p
              ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a
  ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø-‡§µ‡§æ‡§Æ‡§æ a p per (m , n , q) =
    (m + p) , n , (‡§Ø‡•ã‡§ó‡§É m p a ‚àô cong (œÜ m) per ‚àô q)

  -- and the RIGHT station, by the same three steps read backwards
  ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§æ : (a : A) (p : ‚Ñï) ‚Üí ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É a p
                 ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a ‚Üí ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a
  ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§æ a p per (m , n , q) =
    m , (n + p) , (q ‚àô sym (cong (œÜ n) per) ‚àô sym (‡§Ø‡•ã‡§ó‡§É n p a))

  -- and it genuinely moves the station: the shifted meeting's station is
  -- `m + p`, on the nose.  (`SamanaKaksya` ¬ß‡®'s `‡‡Æ‡æ‡®-‡‡‡µ` is the
  -- meeting the shift starts from when `m ‚â° 0`.)
  ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø-‡§∏‡•ç‡§•‡§æ‡§®‡§Æ‡•ç : (a : A) (p : ‚Ñï) (per : ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É a p)
                 (r : ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a a)
               ‚Üí fst (‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø-‡§µ‡§æ‡§Æ‡§æ a p per r) ‚â° fst r + p
  ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø-‡§∏‡•ç‡§•‡§æ‡§®‡§Æ‡•ç a p per r = refl
