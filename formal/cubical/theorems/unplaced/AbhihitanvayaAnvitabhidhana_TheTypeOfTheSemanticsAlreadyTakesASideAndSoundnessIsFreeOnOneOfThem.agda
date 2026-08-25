{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AbhihitanvayaAnvitabhidhana_
--   TheTypeOfTheSemanticsAlreadyTakesASideAndSoundnessIsFreeOnOneOfThem
--
-- ON THE NAME, AND ON WHAT IS AND IS NOT CLAIMED OF THE SOURCES.
-- Checked before naming: `.claude/hooks/priority-ledger.txt` (CURRENT
-- header) and `.claude/hooks/european-frame.txt`.  Neither term below
-- appears anywhere in `formal/` or `notes/` — grepped; this is not a
-- restatement of another identity's module.
--
-- The two terms are the names of the two positions in the Mīmāṃsā
-- dispute over śābdabodha — how the cognition of a sentence stands to
-- the cognitions of its words:
--
--   ABHIHITĀNVAYA, the Bhāṭṭa position.  Kumārila Bhaṭṭa,
--   *Ślokavārttika* (c. 650), and after him Pārthasārathi Miśra.  Words
--   denote their own meanings FIRST (abhihita); those meanings are then
--   connected (anvaya).  The connection is a second cognition, taking
--   already-completed word-meanings as its objects.
--
--   ANVITĀBHIDHĀNA, the Prābhākara position.  Prabhākara, *Bṛhatī*
--   (c. 700), stated sharply by Śālikanātha Miśra, *Vākyārthamātṛkā*
--   (c. 800).  A word denotes only AS ALREADY CONNECTED (anvita).  There
--   is no prior stage at which a word-meaning stands complete and
--   unconnected, waiting to be joined; the connection is in the
--   denotation, not after it.
--
-- **WHAT THE TWO SCHOOLS SAY TO EACH OTHER**, because they are rivals
-- and not one toolkit.  The Bhāṭṭa objection is that anvitābhidhāna
-- makes a word's denotative power (śakti) unlearnable and unbounded:
-- a word would have to denote differently in every sentence, so there
-- is no single śakti to be fixed by usage.  The Prābhākara objection is
-- that abhihitānvaya must posit a SECOND capacity, over and above
-- denotation, to do the connecting — tātparya — and that this is an
-- unneeded entity purchased to repair a stage that was never observed;
-- their evidence is the child learning language from commands, where
-- what is grasped is the connected injunction and never a bare
-- word-meaning.  Neither concedes.  The dispute is live in the sources
-- and is not resolved here.
--
-- **WHAT IS NOT CLAIMED.**  Not that either doctrine IS a hypothesis of
-- this module, not that either school proved anything below, and not
-- that the mathematics is theirs.  The equational content here is three
-- lines of `cong` and belongs to nobody.  What IS claimed is one thing,
-- and it is about the mathematics, not about the history: **the QUESTION
-- the two positions disagree about is the question the type of a
-- semantics answers, and answering it is not optional — a signature
-- has already answered it before any theorem is stated.**
--
-- ────────────────────────────────────────────────────────────────────
-- THE SETTING, AND WHAT WAS MISSING.
--
-- `FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt`
-- (c63b9f53) has `CtxEq` — agreement of `obs` under every context in a
-- family — and `FullyAbstract`, which is ONE implication:
--
--     CtxEq p q  →  C p ≡ C q.
--
-- The converse was never stated there, and that module's "WHAT IS NOT
-- CLAIMED" did not list it, which is the gap this closes.  The converse
-- is not a second hypothesis to be assumed.  **It is a theorem, and its
-- two premises are exactly what the Bhāṭṭa side asserts and the
-- Prābhākara side denies:**
--
--   Compositional  C (plug c t) ≡ act c (C t)
--                  the part `t` HAS a meaning `C t` standing on its own,
--                  and the context acts on that completed meaning
--   Factors        obs t ≡ obsD (C t)
--                  what is observed of a term is read off that meaning
--
-- Given those, `C p ≡ C q → CtxEq p q` is `cong` three times.
--
-- **AND THE SIDE IS TAKEN IN THE SIGNATURE, NOT IN THE PROOF.**  Writing
-- `C : Tm → D` at all already grants a meaning to a term in isolation.
-- On the Prābhākara account there is no such map to write — only the
-- connected form `Ctx → Tm → D` is ever given, and `Compositional` is
-- not false there but UNSTATABLE, having no `C t` to be an equation
-- about.  So this module does not adjudicate the dispute; it locates
-- where a formalisation commits to a side, which is one line above the
-- first theorem.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   soundness        `C p ≡ C q → CtxEq p q`, from `Compositional` and
--                    `Factors`.  No decidability, no enumerability, no
--                    `FullyAbstract`.
--   separatingContextForcesSemanticDifference
--                    a separating context gives `¬ (C p ≡ C q)` —
--                    FREE.  Compare `curvatureExhibitsAContext` in
--                    c63b9f53, which goes the other way and PAYS
--                    `Enumerated K` + `Discrete O` + `FullyAbstract`.
--                    The asymmetry is now visible: one direction is a
--                    congruence, the other is a search.
--   kernelIsExactlyContextualEquivalence
--                    with `FullyAbstract` as well, `CtxEq p q` and
--                    `C p ≡ C q` imply each other — `CtxEq` IS the
--                    kernel of `C`, not merely contained in it
--   connectedOf / connectedAgrees
--                    the abhihitānvaya-shaped data DETERMINES the
--                    connected form: `act c (C t) ≡ C (plug c t)`.
--                    The reverse construction — recovering `C` from a
--                    connected semantics alone — is NOT built, and
--                    nothing here says it is impossible either.
--
-- WHAT IS ALSO NOT CLAIMED.  No term language, no contexts, no
-- semantics is CONSTRUCTED: `Tm`, `O`, `D`, `Ctx`, `plug`, `obs`, `C`,
-- `act`, `obsD` are all parameters, so nothing in the corpus is shown
-- to satisfy any of this.  `Compositional` and `Factors` are
-- hypotheses, not theorems about anything.  Nothing about HOLONOMY,
-- approximation, dropped witnesses, or incoherent interface updates.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module AbhihitanvayaAnvitabhidhana_TheTypeOfTheSemanticsAlreadyTakesASideAndSoundnessIsFreeOnOneOfThem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt
  using (CtxEq ; FullyAbstract)

------------------------------------------------------------------------
-- 1.  The two hypotheses, both of them abhihitānvaya-shaped
------------------------------------------------------------------------

module _ {Tm O D : Type} (Ctx : Type) (plug : Ctx → Tm → Tm) (obs : Tm → O)
         (C : Tm → D) (act : Ctx → D → D) (obsD : D → O)
  where

  Compositional : Type
  Compositional = (c : Ctx) (t : Tm) → C (plug c t) ≡ act c (C t)

  Factors : Type
  Factors = (t : Tm) → obs t ≡ obsD (C t)

  ----------------------------------------------------------------------
  -- 2.  The connected form is determined by them
  ----------------------------------------------------------------------

  connectedOf : Ctx → Tm → D
  connectedOf c t = act c (C t)

  connectedAgrees :
    Compositional → (c : Ctx) (t : Tm) → connectedOf c t ≡ C (plug c t)
  connectedAgrees comp c t = sym (comp c t)

  ----------------------------------------------------------------------
  -- 3.  Soundness, over any context family
  ----------------------------------------------------------------------

  module _ (K : Type) (ctxOf : K → Ctx) where

    soundness :
      Compositional → Factors
      → (p q : Tm) → C p ≡ C q → CtxEq Ctx plug obs K ctxOf p q
    soundness comp fac p q e k =
        fac (plug (ctxOf k) p)
      ∙ cong obsD ( comp (ctxOf k) p
                  ∙ cong (act (ctxOf k)) e
                  ∙ sym (comp (ctxOf k) q))
      ∙ sym (fac (plug (ctxOf k) q))

    ------------------------------------------------------------------
    -- 4.  So a separating context is free evidence of a semantic gap
    ------------------------------------------------------------------

    separatingContextForcesSemanticDifference :
      Compositional → Factors
      → (p q : Tm)
      → Σ[ k ∈ K ] (¬ (obs (plug (ctxOf k) p) ≡ obs (plug (ctxOf k) q)))
      → ¬ (C p ≡ C q)
    separatingContextForcesSemanticDifference comp fac p q (k , ¬e) e =
      ¬e (soundness comp fac p q e k)

    ------------------------------------------------------------------
    -- 5.  And with full abstraction, CtxEq is exactly the kernel of C
    ------------------------------------------------------------------

    kernelIsExactlyContextualEquivalence :
      Compositional → Factors
      → FullyAbstract Ctx plug obs K ctxOf C
      → (p q : Tm)
      → (CtxEq Ctx plug obs K ctxOf p q → C p ≡ C q)
      × (C p ≡ C q → CtxEq Ctx plug obs K ctxOf p q)
    kernelIsExactlyContextualEquivalence comp fac fa p q =
      fa p q , soundness comp fac p q
