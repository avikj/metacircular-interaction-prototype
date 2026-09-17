{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡æ‡‡‡ï‡‡‚ì‡®‡ø‡∞‡‡‡ï‡‡ ‚î ‡‡æ‡®‡ø‡‡‡‡∞‡ ‡® ‡Æ‡æ‡®‡‡ø‡‡‡∞‡‡‡Ø ‡ß‡∞‡‡Æ‡ ; ‡®‡ø‡∞‡‡‡ï‡‡‡ ‡‡∞‡ø‡‡‡‡‡¶‡
-- ‡‡‡µ‡æ‡∞‡‡‡‡ü‡æ‡‡‡ ‡‡µ ‡‡®‡‡‡ø ‡
--
-- (relative / absolute: the loss-level is not a property of the map, and
--  the criterion taken without its context is killed by its own archetype.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE TERM.  ‡‡æ‡‡‡ï‡‡ (with regard to) / ‡®‡ø‡∞‡‡‡ï‡‡ (without regard to) is
-- the Jaina pair that decides whether a naya is a naya or a ‡¶‡‡∞‡‡®‡Ø:
-- **Siddhasena Divkara, *Sanmatitarka* (Prakrit *Sammai-suttam*)
-- 1.21‚ì25, date disputed, c. 5th c. CE** ‚î a standpoint asserted
-- ‡®‡ø‡∞‡‡‡ï‡‡, apart from the others it stands among, is ‡Æ‡ø‡‡‡Ø‡æ.
--
-- ‡ó‡‡∞‡‡° ¬ ‡‡‡‡¶, declared.  No edition of the *Sanmatitarka* was opened by
-- me.  The attribution, the stra numbers and the date are carried from
-- this repository's own ledger
-- (`.claude/hooks/MulaVakya_SourceStatementsForTheTermsInOurFileNames.txt`
-- rows 120 and 121) and from
-- and are owed at verse level.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS REFUTES, and it is this author's own module from yesterday.
--
-- (recoverable only by outside supply) and ‡ (‡®‡‡‡ü‡ø‡, ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡æ) are
-- both crowded fibers; `Loss.WholePartialDesa_‚¶` refuses a fourth
-- constructor for `‡¶‡‡` because no criterion separated them.  The note
-- proposes one, in two halves:
--
--   level ‡ ‚î the fiber is the WHOLE source, and nothing anywhere sees
--             the difference;
--   level ‡© ‚î the fiber is a PROPER PART, and other maps out of the
--             source still see the difference.
--
-- `Avacchedaka_TheTruncationsFiberIsTheWholeSourceAndTheSeamHasItsCriterion`
-- (this lane, yesterday, mine) checked the load-bearing half ‚î every
-- fiber of `‚à_‚à‚` is equivalent to the whole source ‚î and wrote the
-- criterion down as `‡‡∞‡‡µ‡‡æ‡®‡ø‡ f b = fiber f b ‚â A`, with the sentence:
-- *"‡µ‡ø‡ï‡≤‡æ‡¶‡‡ says the fiber has two distinct points; that is true of a
-- map that drops one bit and equally true of a map that drops
-- everything.  ‡‡∞‡‡µ‡‡æ‡®‡ø‡ says which."*
--
-- **That sentence is false, and ¬ß‡ß is one line.**  `‡‡∞‡‡µ‡à‡ï‡Æ‡ : Bool ‚í Unit`
-- is the map that drops one bit ‚î `Residue_‚¶`'s own ¬ß5, and its struck
-- header names it "level ‡® of a five-level scale".  Its fiber over `tt`
-- is `Bool`, which IS the whole source.  So `‡‡∞‡‡µ‡‡æ‡®‡ø‡` holds of it, and
-- the criterion does not separate ‡ from ‡©; it does not separate ‡
-- from ‡®.
--
-- ¬ß‡® shows this is not a stray instance.  `‚à Bool ‚à‚ ‚â Unit`, and the
-- triangle commutes: at `A = Bool` the level-‡ ARCHETYPE **is** the
-- level-‡® archetype, up to an equivalence of the target.  ¬ß‡®'s last
-- theorem states the consequence in the census's own terms ‚î the two
-- maps' fiber censuses are pointwise equivalent ‚î so no reading of the
-- census whatsoever tells them apart.
--
-- ¬ß‡© kills the other half.  "Other maps out of the source still see the
-- difference" holds AT THE LEVEL-‡ ARCHETYPE: `idfun Bool` separates two
-- distinct points of `fiber ‚à_‚à‚ ‚à true ‚à‚`.  It is vacuous wherever the
-- fiber is crowded at all, because ‡µ‡ø‡ï‡≤‡æ‡¶‡‡'s own evidence ‚î two fiber
-- points and a proof they differ ‚î is already such a separation.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THE COLLISION NAMES, ¬ß‡, and this is the part worth keeping.
--
-- The two verdicts collide because "recoverable" was being asked of a
-- map ‡®‡ø‡∞‡‡‡ï‡‡.  Recovery is a question about a map TOGETHER WITH what
-- else the construction retained.  ¬ß‡ fixes the same map `‡‡∞‡‡µ‡à‡ï‡Æ‡` and
-- varies only the retained context:
--
--   retain `idfun Bool`  ‚í  ‚ü®‡‡∞‡‡µ‡à‡ï‡Æ‡ , id‚ü© is an EQUIVALENCE.  Nothing lost.
--   retain nothing       ‚í  ‚ü®‡‡∞‡‡µ‡à‡ï‡Æ‡ , ‡‡∞‡‡µ‡à‡ï‡Æ‡‚ü© is NOT.  The bit is gone.
--
-- One map, two verdicts, both checked.  So no predicate on `f` alone can
-- carry the level, and the scale as the note states it ‚î indexed by the
-- map ‚î cannot be completed by any criterion at all, this one included.
--
-- ¬ß‡ pushes it to the level-‡ archetype: `A ‚â ‚à A ‚à‚ ó A` for EVERY `A`.
-- Retaining the source recovers even the truncation.  ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡‡æ is a
-- statement about what is retained, not about `‚à_‚à‚`.
--
-- ¬ß‡ locates where the level-‡®/level-‡ collapse happens, so it is not
-- mistaken for a claim that truncation never loses: `‚à A ‚à‚ ‚â Unit`
-- exactly when `A` is merely inhabited.  The distinction the scale wants
-- lives in the QUANTIFIER ‚î uniformly in `A`, `‚à_‚à‚` has no section ‚î and
-- a per-instance fiber criterion cannot reach a quantifier.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS **NOT** CLAIMED HERE, said flatly because the refuted claim was
-- an overreach of exactly this kind.
--
--   * NOT claimed that levels ‡© and ‡ are the same thing, or that the
--     scale is wrong.  What is refuted is two proposed criteria and the
--     shape they share, not the distinction they were reaching for.
--   * NOT claimed that a context-indexed scale WOULD work.  ¬ß‡ exhibits
--     one map under two contexts.  Two contexts on one map is two
--     contexts on one map.
--   * NOT claimed that `‚à_‚à‚` is harmless.  ¬ß‡ recovers it only by
--     retaining the whole source, which is the trivial context; ¬ß‡ says
--     where the uniform statement lives and does not prove it.
--   * NOTHING is added to `‡¶‡‡`.  That datatype is in another library and
--     its author's refusal to extend it was a considered act ‚î and this
--     module is the reason the refusal was right.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module SapeksaNirapeksa_TheLossLevelIsNotAPropertyOfTheMapAloneAndTheFiberCriterionFailsOnItsOwnArchetype where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels using (isProp‚ÜíisContrPath)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.HITs.PropositionalTruncation
  using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; isPropPropTrunc)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡¶.  The criterion under test, restated here so this module is readable
--     without opening the one it refutes.  It is `Avacchedaka_‚¶`'s ¬ß‡©,
--     copied verbatim in content.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É : {A B : Type ‚Ñì} ‚Üí (A ‚Üí B) ‚Üí B ‚Üí Type ‚Ñì
‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É {A = A} f b = fiber f b ‚âÉ A

------------------------------------------------------------------------
-- ‡ß.  THE REFUTATION.  The level-‡® archetype satisfies the level-‡
--     criterion.
--
-- `‡‡∞‡‡µ‡à‡ï‡Æ‡` is `Residue_‚¶` ¬ß5's map, whose struck header calls it "level ‡® of
-- a five-level scale" and whose loss it prices at exactly one bit.  Its
-- fiber over the single target point is `Bool` ‚î the whole source ‚î
-- because `Unit` is a proposition, so the path component of the Œ is
-- contractible and contracts away.  The proof is the SAME PROOF as
-- `Avacchedaka_‚¶` ¬ß‡®'s, with `isPropUnit` in place of `isPropPropTrunc`,
-- which is the whole of why the criterion cannot discriminate: it is
-- reading propositionality of the target, and both targets are props.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç : Bool ‚Üí Unit
‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç _ = tt

‡§è‡§ï‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É : ‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç tt
‡§è‡§ï‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É = Œ£-contractSnd (Œª _ ‚Üí isProp‚ÜíisContrPath isPropUnit tt tt)

-- and it is genuinely crowded, so this is not the empty-fiber case:
-- two points of the fiber, produced as terms, provably distinct.
‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ : fiber ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç tt
‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ    = false , refl
‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£  = true  , refl

‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç : ¬¨ (‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ ‚â° ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£)
‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç p = false‚â¢true (cong fst p)

------------------------------------------------------------------------
-- ‡®.  WHY IT IS NOT A STRAY INSTANCE.  At `A = Bool` the level-‡
--     archetype IS the level-‡® archetype.
--
-- `‚à Bool ‚à‚` is an inhabited proposition, hence contractible, hence
-- equivalent to `Unit`; and the triangle over `Bool` commutes by `refl`.
-- So `‚à_‚à‚ : Bool ‚í ‚à Bool ‚à‚` and `‡‡∞‡‡µ‡à‡ï‡Æ‡ : Bool ‚í Unit` are one map
-- read through an equivalence of its target.
------------------------------------------------------------------------

‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-Bool‚âÉUnit : ‚à• Bool ‚à•‚ÇÅ ‚âÉ Unit
‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-Bool‚âÉUnit =
  isoToEquiv (iso (Œª _ ‚Üí tt) (Œª _ ‚Üí ‚à£ true ‚à£‚ÇÅ)
                  (Œª _ ‚Üí refl) (Œª x ‚Üí isPropPropTrunc _ x))

‡§§‡•ç‡§∞‡§ø‡§ï‡•ã‡§£‡§Æ‡•ç : (b : Bool) ‚Üí equivFun ‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-Bool‚âÉUnit ‚à£ b ‚à£‚ÇÅ ‚â° ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç b
‡§§‡•ç‡§∞‡§ø‡§ï‡•ã‡§£‡§Æ‡•ç _ = refl

-- The consequence, stated in the census's own terms.  Every fiber of the
-- level-‡ archetype at `Bool` is equivalent to the single fiber of the
-- level-‡® archetype.  A census is a function on fibers; two maps whose
-- censuses are pointwise equivalent cannot be told apart by one.
‡§ó‡§£‡§®‡§æ-‡§Ö‡§≠‡•á‡§¶‡§É : (x : ‚à• Bool ‚à•‚ÇÅ) ‚Üí fiber (‚à£_‚à£‚ÇÅ {A = Bool}) x ‚âÉ fiber ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç tt
‡§ó‡§£‡§®‡§æ-‡§Ö‡§≠‡•á‡§¶‡§É x =
  compEquiv (Œ£-contractSnd (Œª a ‚Üí isProp‚ÜíisContrPath isPropPropTrunc ‚à£ a ‚à£‚ÇÅ x))
            (invEquiv ‡§è‡§ï‡§¨‡§ø‡§®‡•ç‡§¶‡•Å-‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É)

------------------------------------------------------------------------
-- ‡©.  THE OTHER HALF, refuted by being satisfied where it must fail.
--
-- The note's level-‡© side reads: the fiber is a proper part, and *other
-- maps out of the source still see the difference* ‚î `‡‡æ‡ï‡‡‡ø-‡‡‡‡æ‡®‡Æ‡`
-- naming the lost standpoint.  Here is that condition holding at the
-- level-‡ archetype, where by hypothesis nothing anywhere sees the
-- difference: two distinct points of one fiber of `‚à_‚à‚`, and `idfun`
-- separating them.
--
-- It is vacuous, and the reason is structural rather than particular:
-- ‡µ‡ø‡ï‡≤‡æ‡¶‡‡'s evidence IS a separation.  To write the constructor at all
-- you must hand over two fiber points and a proof they differ, and for a
-- map into a set that proof already separates their sources.  A condition
-- discharged by the evidence of the case it is meant to classify
-- classifies nothing.
------------------------------------------------------------------------

‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§µ‡§æ‡§Æ ‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ : fiber (‚à£_‚à£‚ÇÅ {A = Bool}) ‚à£ true ‚à£‚ÇÅ
‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§µ‡§æ‡§Æ    = false , isPropPropTrunc _ _
‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£  = true  , refl

‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç : ¬¨ (‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§µ‡§æ‡§Æ ‚â° ‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£)
‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§¶‡•ç‡§µ‡§Ø‡§Æ‡•ç p = false‚â¢true (cong fst p)

-- a map out of the source that "still sees the difference", at level ‡
‡§∏‡§æ‡§ï‡•ç‡§∑‡•Ä-‡§®‡§ø‡§∑‡•ç‡§´‡§≤‡§É : ¬¨ (idfun Bool (fst ‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§µ‡§æ‡§Æ) ‚â° idfun Bool (fst ‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£))
‡§∏‡§æ‡§ï‡•ç‡§∑‡•Ä-‡§®‡§ø‡§∑‡•ç‡§´‡§≤‡§É = false‚â¢true

------------------------------------------------------------------------
-- ‡.  ‡‡æ‡‡‡ï‡‡‡‡æ ‚î one map, two contexts, two verdicts.
--
-- `‡Ø‡‡ó‡‡Æ‡Æ‡ f w` is the map paired with what the construction kept.  The
-- question "was the bit recovered" is a question about the PAIR, and the
-- pair's answer moves while `f` stands still.
------------------------------------------------------------------------

‡§Ø‡•Å‡§ó‡•ç‡§Æ‡§Æ‡•ç : {A B S : Type ‚Ñì} ‚Üí (A ‚Üí B) ‚Üí (A ‚Üí S) ‚Üí (A ‚Üí B √ó S)
‡§Ø‡•Å‡§ó‡•ç‡§Æ‡§Æ‡•ç f w a = f a , w a

-- context = retain the source.  Nothing is lost, as an equivalence.
‡§∏‡§æ‡§™‡•á‡§ï‡•ç‡§∑-‡§∏‡§Æ‡§§‡§æ : Bool ‚âÉ (Unit √ó Bool)
‡§∏‡§æ‡§™‡•á‡§ï‡•ç‡§∑-‡§∏‡§Æ‡§§‡§æ =
  isoToEquiv (iso (‡§Ø‡•Å‡§ó‡•ç‡§Æ‡§Æ‡•ç ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç (idfun Bool)) snd (Œª _ ‚Üí refl) (Œª _ ‚Üí refl))

‡§∏‡§æ‡§™‡•á‡§ï‡•ç‡§∑-‡§∏‡§Æ‡§§‡§æ-‡§Ø‡•Å‡§ó‡•ç‡§Æ‡§Æ‡•ç : (b : Bool) ‚Üí equivFun ‡§∏‡§æ‡§™‡•á‡§ï‡•ç‡§∑-‡§∏‡§Æ‡§§‡§æ b ‚â° ‡§Ø‡•Å‡§ó‡•ç‡§Æ‡§Æ‡•ç ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç (idfun Bool) b
‡§∏‡§æ‡§™‡•á‡§ï‡•ç‡§∑-‡§∏‡§Æ‡§§‡§æ-‡§Ø‡•Å‡§ó‡•ç‡§Æ‡§Æ‡•ç _ = refl

-- context = retain nothing.  The same `‡‡∞‡‡µ‡à‡ï‡Æ‡`, and the bit is gone.
‡§®‡§ø‡§∞‡§™‡•á‡§ï‡•ç‡§∑-‡§µ‡§æ‡§Æ ‡§®‡§ø‡§∞‡§™‡•á‡§ï‡•ç‡§∑-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ : fiber (‡§Ø‡•Å‡§ó‡•ç‡§Æ‡§Æ‡•ç ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç) (tt , tt)
‡§®‡§ø‡§∞‡§™‡•á‡§ï‡•ç‡§∑-‡§µ‡§æ‡§Æ   = false , refl
‡§®‡§ø‡§∞‡§™‡•á‡§ï‡•ç‡§∑-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ = true  , refl

‡§®‡§ø‡§∞‡§™‡•á‡§ï‡•ç‡§∑-‡§®-‡§∏‡§Æ‡§§‡§æ : ¬¨ (isEquiv (‡§Ø‡•Å‡§ó‡•ç‡§Æ‡§Æ‡•ç ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç))
‡§®‡§ø‡§∞‡§™‡•á‡§ï‡•ç‡§∑-‡§®-‡§∏‡§Æ‡§§‡§æ e =
  false‚â¢true
    (cong fst (isContr‚ÜíisProp (e .equiv-proof (tt , tt))
                              ‡§®‡§ø‡§∞‡§™‡•á‡§ï‡•ç‡§∑-‡§µ‡§æ‡§Æ ‡§®‡§ø‡§∞‡§™‡•á‡§ï‡•ç‡§∑-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£))

------------------------------------------------------------------------
-- ‡.  The same move at the level-‡ archetype, for every `A`.
--
-- Retaining the source recovers the truncation too: `A ‚â ‚à A ‚à‚ ó A`,
-- with no hypothesis on `A`.  The forward map is `‡Ø‡‡ó‡‡Æ‡Æ‡ ‚à_‚à‚ id`.
--
-- This does not say truncation is harmless.  It says ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡‡æ is not
-- readable off `‚à_‚à‚`, because the trivial context already discharges it,
-- exactly as it does for `‡‡∞‡‡µ‡à‡ï‡Æ‡` in ¬ß‡.
------------------------------------------------------------------------

‡§™‡•Ç‡§∞‡•ç‡§£-‡§∏‡§®‡•ç‡§¶‡§∞‡•ç‡§≠‡§É : {A : Type ‚Ñì} ‚Üí A ‚âÉ (‚à• A ‚à•‚ÇÅ √ó A)
‡§™‡•Ç‡§∞‡•ç‡§£-‡§∏‡§®‡•ç‡§¶‡§∞‡•ç‡§≠‡§É {A = A} =
  isoToEquiv (iso (‡§Ø‡•Å‡§ó‡•ç‡§Æ‡§Æ‡•ç ‚à£_‚à£‚ÇÅ (idfun A)) snd
    (Œª { (x , a) i ‚Üí isPropPropTrunc ‚à£ a ‚à£‚ÇÅ x i , a })
    (Œª _ ‚Üí refl))

------------------------------------------------------------------------
-- ‡.  Where ¬ß‡®'s collapse happens, so it is not mistaken for more.
--
-- `‚à A ‚à‚ ‚â Unit` exactly when `A` is merely inhabited.  ¬ß‡® used `Bool`,
-- which is inhabited, and that is the whole reason the level-‡ archetype
-- degenerated into the level-‡® one there.  For an `A` not known
-- inhabited the two maps are not comparable this way ‚î and that is a
-- statement with a quantifier in it, which no criterion evaluated at one
-- map and one point of its codomain can express.
--
-- The uniform statement the scale actually wants is about all `A` at
-- once.  It is not proved here and is not claimed here.
------------------------------------------------------------------------

‡§µ‡§æ‡§∏‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç‚Üí‡§è‡§ï‡§Æ‡•ç : {A : Type ‚Ñì} ‚Üí ‚à• A ‚à•‚ÇÅ ‚Üí (‚à• A ‚à•‚ÇÅ ‚âÉ Unit)
‡§µ‡§æ‡§∏‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç‚Üí‡§è‡§ï‡§Æ‡•ç x =
  isoToEquiv (iso (Œª _ ‚Üí tt) (Œª _ ‚Üí x) (Œª _ ‚Üí refl) (Œª y ‚Üí isPropPropTrunc x y))

‡§è‡§ï‡§Æ‡•ç‚Üí‡§µ‡§æ‡§∏‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç : {A : Type ‚Ñì} ‚Üí (‚à• A ‚à•‚ÇÅ ‚âÉ Unit) ‚Üí ‚à• A ‚à•‚ÇÅ
‡§è‡§ï‡§Æ‡•ç‚Üí‡§µ‡§æ‡§∏‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç e = invEq e tt
