{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AbhihitanvayaAnvitabhidhana_
--   TheTypeOfTheSemanticsAlreadyTakesASideAndSoundnessIsFreeOnOneOfThem
--
-- Checked before naming: `.claude/hooks/priority-ledger.txt` (CURRENT header)
-- and `.claude/hooks/european-frame.txt`. Neither term below restatement of
-- another identity's module.
--
-- The two terms are the names of the two positions in the Mms
-- dispute over bdabodha â” how the cognition of a sentence stands to
-- the cognitions of its words:
--
--   ABHIHITNVAYA, the Bha position.  Kumrila Bhaa,
--   *lokavrttika* (c. 650), and after him Prthasrathi Mira.  Words
--   denote their own meanings FIRST (abhihita); those meanings are then
--   connected (anvaya).  The connection is a second cognition, taking
--   already-completed word-meanings as its objects.
--
--   ANVITBHIDHNA, the Prbhkara position.  Prabhkara, *Bhat*
--   (c. 700), stated sharply by likantha Mira, *Vkyrthamtk*
--   (c. 800).  A word denotes only AS ALREADY CONNECTED (anvita).  There
--   is no prior stage at which a word-meaning stands complete and
--   unconnected, waiting to be joined; the connection is in the
--   denotation, not after it.
--
-- **WHAT THE TWO SCHOOLS SAY TO EACH OTHER**, because they are rivals
-- and not one toolkit.  The Bha objection is that anvitbhidhna
-- makes a word's denotative power (akti) unlearnable and unbounded:
-- a word would have to denote differently in every sentence, so there
-- is no single akti to be fixed by usage.  The Prbhkara objection is
-- that abhihitnvaya must posit a SECOND capacity, over and above
-- denotation, to do the connecting â” ttparya â” and that this is an
-- unneeded entity purchased to repair a stage that was never observed;
-- their evidence is the child learning language from commands, where
-- what is grasped is the connected injunction and never a bare
-- word-meaning.  Neither concedes.  The dispute is live in the sources
-- and is not resolved here.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE SETTING, AND WHAT WAS MISSING.
--
-- `FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt`
-- (c63b9f53) has `CtxEq` â” agreement of `obs` under every context in a
-- family â” and `FullyAbstract`, which is ONE implication:
--
--     CtxEq p q  â’  C p â‰¡ C q.
--
-- The converse was never stated there, and that module's "WHAT IS NOT
-- CLAIMED" did not list it, which is the gap this closes.  The converse
-- is not a second hypothesis to be assumed.  **It is a theorem, and its
-- two premises are exactly what the Bha side asserts and the
-- Prbhkara side denies:**
--
--   Compositional  C (plug c t) â‰¡ act c (C t)
--                  the part `t` HAS a meaning `C t` standing on its own,
--                  and the context acts on that completed meaning
--   Factors        obs t â‰¡ obsD (C t)
--                  what is observed of a term is read off that meaning
--
-- Given those, `C p â‰¡ C q â’ CtxEq p q` is `cong` three times.
--
-- **AND THE SIDE IS TAKEN IN THE SIGNATURE, NOT IN THE PROOF.**  Writing
-- `C : Tm â’ D` at all already grants a meaning to a term in isolation.
-- On the Prbhkara account there is no such map to write â” only the
-- connected form `Ctx â’ Tm â’ D` is ever given, and `Compositional` is
-- not false there but UNSTATABLE, having no `C t` to be an equation
-- about.  So this module does not adjudicate the dispute; it locates
-- where a formalisation commits to a side, which is one line above the
-- first theorem.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   soundness        `C p â‰¡ C q â’ CtxEq p q`, from `Compositional` and
--                    `Factors`.  No decidability, no enumerability, no
--                    `FullyAbstract`.
--   separatingContextForcesSemanticDifference
--                    a separating context gives `Â (C p â‰¡ C q)` â”
--                    FREE.  Compare `curvatureExhibitsAContext` in
--                    c63b9f53, which goes the other way and PAYS
--                    `Enumerated K` + `Discrete O` + `FullyAbstract`.
--                    The asymmetry is now visible: one direction is a
--                    congruence, the other is a search.
--   kernelIsExactlyContextualEquivalence
--                    with `FullyAbstract` as well, `CtxEq p q` and
--                    `C p â‰¡ C q` imply each other â” `CtxEq` IS the
--                    kernel of `C`, not merely contained in it
--   connectedOf / connectedAgrees
--                    the abhihitnvaya-shaped data DETERMINES the
--                    connected form: `act c (C t) â‰¡ C (plug c t)`.
--                    The reverse construction â” recovering `C` from a
--                    connected semantics alone â” is NOT built, and
--                    nothing here says it is impossible either.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module AbhihitanvayaAnvitabhidhana_TheTypeOfTheSemanticsAlreadyTakesASideAndSoundnessIsFreeOnOneOfThem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)

open import FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt
  using (CtxEq ; FullyAbstract)

------------------------------------------------------------------------
-- 1.  The two hypotheses, both of them abhihitnvaya-shaped
------------------------------------------------------------------------

module _ {Tm O D : Type} (Ctx : Type) (plug : Ctx â†’ Tm â†’ Tm) (obs : Tm â†’ O)
         (C : Tm â†’ D) (act : Ctx â†’ D â†’ D) (obsD : D â†’ O)
  where

  Compositional : Type
  Compositional = (c : Ctx) (t : Tm) â†’ C (plug c t) â‰¡ act c (C t)

  Factors : Type
  Factors = (t : Tm) â†’ obs t â‰¡ obsD (C t)

  ----------------------------------------------------------------------
  -- 2.  The connected form is determined by them
  ----------------------------------------------------------------------

  connectedOf : Ctx â†’ Tm â†’ D
  connectedOf c t = act c (C t)

  connectedAgrees :
    Compositional â†’ (c : Ctx) (t : Tm) â†’ connectedOf c t â‰¡ C (plug c t)
  connectedAgrees comp c t = sym (comp c t)

  ----------------------------------------------------------------------
  -- 3.  Soundness, over any context family
  ----------------------------------------------------------------------

  module _ (K : Type) (ctxOf : K â†’ Ctx) where

    soundness :
      Compositional â†’ Factors
      â†’ (p q : Tm) â†’ C p â‰¡ C q â†’ CtxEq Ctx plug obs K ctxOf p q
    soundness comp fac p q e k =
        fac (plug (ctxOf k) p)
      âˆ™ cong obsD ( comp (ctxOf k) p
                  âˆ™ cong (act (ctxOf k)) e
                  âˆ™ sym (comp (ctxOf k) q))
      âˆ™ sym (fac (plug (ctxOf k) q))

    ------------------------------------------------------------------
    -- 4.  So a separating context is free evidence of a semantic gap
    ------------------------------------------------------------------

    separatingContextForcesSemanticDifference :
      Compositional â†’ Factors
      â†’ (p q : Tm)
      â†’ Î£[ k âˆˆ K ] (Â¬ (obs (plug (ctxOf k) p) â‰¡ obs (plug (ctxOf k) q)))
      â†’ Â¬ (C p â‰¡ C q)
    separatingContextForcesSemanticDifference comp fac p q (k , Â¬e) e =
      Â¬e (soundness comp fac p q e k)

    ------------------------------------------------------------------
    -- 5.  And with full abstraction, CtxEq is exactly the kernel of C
    ------------------------------------------------------------------

    kernelIsExactlyContextualEquivalence :
      Compositional â†’ Factors
      â†’ FullyAbstract Ctx plug obs K ctxOf C
      â†’ (p q : Tm)
      â†’ (CtxEq Ctx plug obs K ctxOf p q â†’ C p â‰¡ C q)
      Ã— (C p â‰¡ C q â†’ CtxEq Ctx plug obs K ctxOf p q)
    kernelIsExactlyContextualEquivalence comp fac fa p q =
      fa p q , soundness comp fac p q
