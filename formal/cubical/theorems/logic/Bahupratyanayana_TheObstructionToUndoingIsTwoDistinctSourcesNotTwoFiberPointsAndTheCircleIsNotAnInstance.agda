{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ ‚î ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡‡‡Ø ‡‡‡∞‡‡ø‡‡®‡‡ß‡ã ‡¶‡‡µ‡ ‡‡ø‡®‡‡®‡ ‡Æ‡‡≤‡, ‡® ‡‡ ‡¶‡‡µ‡ ‡‡®‡‡‡-‡‡ø‡®‡‡¶‡ ‡
--
-- (the obstruction to undoing a map is two distinct SOURCES over one
--  target ‚î not two points of the fiber; and the circle is not an
--  instance of it.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- sector, found exactly ONE theorem of the form "this loss cannot be
-- undone" ‚î `SetTruncationDescentBoundary.noDescentS¬` ‚î and closed with
-- the instruction that the next build should not be a better extractor
-- but *more theorems of that kind*, because "the bottleneck is the
-- mathematics, not the extraction."
--
-- This file is the GENERATOR of that kind, at the level of points, plus
-- the exact statement of what it cannot reach.
--
--   ¬ß‡®  the law   : two points of one fiber WITH DISTINCT SOURCES kill
--                   every retraction.  Four lines, no h-level, no
--                   decidability, no finiteness, arbitrary A and B.
--                   Positive form: a retraction makes every fiber
--                   source-thin.
--   ¬ß‡©  instance  : the discrete log has NO LEFT INVERSE.  0 and 3 both
--                   land on Œµ, so no `r : C‚ ‚í ‚ï` undoes `powg`.  This is
--                   the corpus's second irreversibility theorem and its
--                   first outside homotopy.
--   ¬ß‡  instance  : `‡‡∞‡‡µ‡à‡ï‡Æ‡ : Bool ‚í Unit`, the standing archetype.
--   ¬ß‡  THE BOUNDARY, and it is the point of the file: `Fiberjala`'s
--       ‡‡‡ ‚î two distinct points of a fiber ‚î IS NOT ENOUGH.  Exhibited:
--       `‡‡ï‡µ‡‡‡‡‡Æ‡ : Unit ‚í S¬`, `tt ‚¶ base`, HAS a retraction, and its
--       fiber over `base` is `Œ©S¬ ‚â ‚`, so ‡‡‡ holds of it.  Its two
--       fiber points differ only in their WITNESS; their sources are
--       equal.  So ‡‡‡ does not obstruct undoing, and ¬ß‡®'s hypothesis is
--       strictly stronger than ‡‡‡ ‚î which no module in this corpus had
--       said.
--   ¬ß‡  therefore `noDescentS¬` is NOT an instance of ¬ß‡® and cannot be
--       made one: S¬ is connected, so it has no two distinct points to
--       feed the law.  Its obstruction is œ‚ ‚î one level up.  **The
--       corpus has two kinds of irreversibility and neither reduces to
--       the other**, and ¬ß‡ is the witness that the reduction fails.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- RELATION TO WHAT IS ALREADY HERE, so nothing is silently re-proved.
--
--   `Fiberjala_‚¶`            ‡‡‡ as one of three fiber verdicts.  ¬ß‡
--                            sharpens it: ‡‡‡ is not the obstruction to
--                            undoing.  The three-verdict codomain is
--                            untouched and remains correct for what it
--                            classifies.
--   `Residue_‚¶` ¬ß5              prices `‡‡∞‡‡µ‡à‡ï‡Æ‡`'s loss at one bit and proves
--                            `¬ isEquiv`.  ¬ß‡ here is the RETRACTION
--                            statement, which is different and weaker
--                            than `¬ isEquiv` in general.
--   `GhataFiber_‚¶`           exhibits the two exponents.  ¬ß‡© consumes
--                            them; the fiber analysis is not re-done.
--   `Nirdharana_TheReturnLocus‚¶`  the SECTION side: with `q ‚àò s ‚â° id` the
--                            return locus is `im s`.  This file is the
--                            other side: when no RETRACTION exists at
--                            all.  The two are not the same direction and
--                            neither implies the other.
--   `Arpitanarpita_‚¶.‡®-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡` and `AHIMSA_SUTRA`'s
--   `‡®‡æ‡‡‡‡ø-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡`      are two hand-proved instances of the same
--                            shape.  ¬ß‡® is the law they are instances of;
--                            both are left standing and neither is
--                            rewritten (ROUTES KEPT).
--
-- ¬ß‡© is a checked no-return theorem the corpus did not have, and that ¬ß‡
-- is a counterexample separating it from `Fiberjala`'s ‡‡‡.  No physics.
-- No computational hardness: ¬ß‡© is about a three-element group and says
-- nothing about difficulty.  ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡® is the corpus's existing word
-- (AHIMSA_SUTRA ¬ß‡); no text is claimed for the compound or for any
-- statement below.
--
-- CHECKED: exit code in the session log; --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module Bahupratyanayana_TheObstructionToUndoingIsTwoDistinctSourcesNotTwoFiberPointsAndTheCircleIsNotAnInstance where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Nat.Properties using (znots)
open import Cubical.Data.Sigma using (Œ£ ; Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Data.Int using (‚Ñ§ ; pos)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.HITs.S1 using (S¬π ; base ; loop ; winding)

open import GhataFiber_TheDiscreteLogIsTheFiberOfPingalasPowerAndShorsPeriodQueryIsWhatReadsIt
  using (powg ; ŒµC ; ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§É ; ‡§§‡•ç‡§∞‡§Ø‡§É)
open import BijamulaKrida_AConcreteKeypairRunsInACyclicGroupWhereTheModThatExhaustsTheHeapIsNotNeeded
  using (C‚ÇÉ)

private variable ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡ ‚î the undo.  A left inverse: run f, then r, and be
--     back where you started.  (Not a section ‚î that is the other
--     direction, and `Nirdharana_TheReturnLocus‚¶` treats it.)
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç : {A : Type ‚Ñì} {B : Type ‚Ñì'} ‚Üí (A ‚Üí B) ‚Üí Type (‚Ñì-max ‚Ñì ‚Ñì')
‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç {A = A} f = Œ£[ r ‚àà (_ ‚Üí A) ] ((a : A) ‚Üí r (f a) ‚â° a)

------------------------------------------------------------------------
-- ‡® ¬ THE LAW.  Two distinct SOURCES over one target kill every undo.
--
-- No hypothesis on A or B: no h-level, no decidability, no finiteness.
-- The proof is the retraction used twice with the two witnesses glued
-- between.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} {B : Type ‚Ñì'} (f : A ‚Üí B) where

  -- positive form: an undo makes every fiber THIN IN THE SOURCE.
  ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§§‡§®‡•Å‡§É : ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç f
                   ‚Üí (b : B) (x y : fiber f b) ‚Üí fst x ‚â° fst y
  ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§§‡§®‡•Å‡§É (r , ret) b (a‚ÇÅ , p‚ÇÅ) (a‚ÇÇ , p‚ÇÇ) =
    sym (ret a‚ÇÅ) ‚àô cong r (p‚ÇÅ ‚àô sym p‚ÇÇ) ‚àô ret a‚ÇÇ

  -- the generator, as the contrapositive: distinct sources, no undo.
  ‡§¨‡§π‡•Å-‡§Æ‡•Ç‡§≤‡§Æ‡•ç-‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç : (b : B) (x y : fiber f b)
                          ‚Üí ¬¨ (fst x ‚â° fst y) ‚Üí ¬¨ (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç f)
  ‡§¨‡§π‡•Å-‡§Æ‡•Ç‡§≤‡§Æ‡•ç-‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç b x y ne ret =
    ne (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç-‡§§‡§®‡•Å‡§É ret b x y)

------------------------------------------------------------------------
-- ‡© ¬ THE DISCRETE LOG HAS NO LEFT INVERSE.
--
-- `GhataFiber` exhibits 0 and 3 over Œµ.  Their sources are 0 and 3, and
-- `znots` separates them.  So no `r : C‚ ‚í ‚ï` undoes `powg` ‚î checked,
-- and it is not a hardness statement: it is that the undo DOES NOT
-- EXIST, for the same reason `Bool ‚í Unit`'s does not.
------------------------------------------------------------------------

‡§ò‡§æ‡§§‡§É-‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡•Ä‡§Ø‡§É : ¬¨ (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç powg)
‡§ò‡§æ‡§§‡§É-‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡•Ä‡§Ø‡§É =
  ‡§¨‡§π‡•Å-‡§Æ‡•Ç‡§≤‡§Æ‡•ç-‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç powg ŒµC ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§É ‡§§‡•ç‡§∞‡§Ø‡§É znots

------------------------------------------------------------------------
-- ‡ ¬ The standing archetype, for free from the same law.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç : Bool ‚Üí Unit
‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç _ = tt

‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç-‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡•Ä‡§Ø‡§Æ‡•ç : ¬¨ (‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç)
‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç-‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡•Ä‡§Ø‡§Æ‡•ç =
  ‡§¨‡§π‡•Å-‡§Æ‡•Ç‡§≤‡§Æ‡•ç-‡§®-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç tt (false , refl) (true , refl) false‚â¢true

------------------------------------------------------------------------
-- ‡ ¬ THE BOUNDARY.  ‡‡‡ IS NOT THE OBSTRUCTION.
--
-- `‡‡ï‡µ‡‡‡‡‡Æ‡ : Unit ‚í S¬` sending tt to base HAS an undo (`r _ = tt`,
-- and `r (f tt) ‚â° tt` is refl).  Its fiber over `base` is `Œ[Unit] Œ©S¬`,
-- which has two distinct points ‚î `(tt , refl)` and `(tt , loop)`,
-- distinct because `winding` separates them in ‚.  So `Fiberjala`'s ‡‡‡
-- holds of a map that is perfectly undoable.
--
-- The two fiber points differ only in their WITNESS; their sources are
-- both `tt`.  ¬ß‡®'s hypothesis is therefore STRICTLY STRONGER than ‡‡‡,
-- and the strengthening is exactly the difference between a path in the
-- base and a point of the source.
------------------------------------------------------------------------

‡§è‡§ï‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç : Unit ‚Üí S¬π
‡§è‡§ï‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç _ = base

‡§è‡§ï‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡•Ä‡§Ø‡§Æ‡•ç : ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡§Æ‡•ç ‡§è‡§ï‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç
‡§è‡§ï‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§®‡§Ø‡§®‡•Ä‡§Ø‡§Æ‡•ç = (Œª _ ‚Üí tt) , (Œª _ ‚Üí refl)

private
  -- a predicate separating pos 0 from pos 1, so the two loops differ
  ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç? : ‚Ñ§ ‚Üí Type
  ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç? (pos zero) = Unit
  ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç? _          = ‚ä•

‡§µ‡•É‡§§‡•ç‡§§-‡§µ‡§æ‡§Æ ‡§µ‡•É‡§§‡•ç‡§§-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ : fiber ‡§è‡§ï‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç base
‡§µ‡•É‡§§‡•ç‡§§-‡§µ‡§æ‡§Æ    = tt , refl
‡§µ‡•É‡§§‡•ç‡§§-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£  = tt , loop

‡§µ‡•É‡§§‡•ç‡§§-‡§¨‡§π‡•Å : ¬¨ (‡§µ‡•É‡§§‡•ç‡§§-‡§µ‡§æ‡§Æ ‚â° ‡§µ‡•É‡§§‡•ç‡§§-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£)
‡§µ‡•É‡§§‡•ç‡§§-‡§¨‡§π‡•Å p = subst ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç? (cong (Œª z ‚Üí winding (snd z)) p) tt

-- ‚¶and yet the sources agree, which is why the undo survives.
‡§µ‡•É‡§§‡•ç‡§§-‡§Æ‡•Ç‡§≤-‡§Ö‡§≠‡•á‡§¶‡§É : fst ‡§µ‡•É‡§§‡•ç‡§§-‡§µ‡§æ‡§Æ ‚â° fst ‡§µ‡•É‡§§‡•ç‡§§-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£
‡§µ‡•É‡§§‡•ç‡§§-‡§Æ‡•Ç‡§≤-‡§Ö‡§≠‡•á‡§¶‡§É = refl

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î why `noDescentS¬` is a different theorem, stated and not
--     proved here.
--
-- ¬ß‡® needs two points of A that are provably distinct.  S¬ is connected,
-- so it has none: `base ‚â° base` is inhabited by `refl`, and the law
-- cannot fire anywhere on it.  `SetTruncationDescentBoundary.noDescentS¬`
-- obstructs the truncation's retraction all the same, and the reason is
-- œ‚ ‚î the loop, not the points.  ¬ß‡ is the witness that the reduction
-- genuinely fails rather than merely being unfound: there the loop-level
-- distinctness is present, the point-level distinctness is absent, and
-- the retraction EXISTS.  So the corpus's two no-return theorems live at
-- two levels and neither implies the other.
--
-- NOT PROVED HERE: that S¬ has no two distinct points (that is
-- connectedness, in the library, and is not invoked); and nothing about
-- higher levels ‚î whether the pattern continues at œ‚ and above is not
-- addressed and no conjecture is offered.
------------------------------------------------------------------------
