{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Punarāgamana · लब्धि
--
-- लब्धि (labdhi) — "what is obtained": the QUOTIENT a division hands
-- back, the companion of शेष, the remainder it keeps.  The pair
-- labdhi/śeṣa is the ordinary vocabulary of a division step in this
-- tradition's arithmetic.
--
-- WHAT IS NOT CLAIMED OF THE SOURCE.  No text is opened here and no
-- verse is cited.  The term names the OBJECT, and per CLAUDE.md's naming
-- rule note 2 that is stated rather than back-attributed.  शेष carries a
-- source one module over (Āryabhaṭīya, Gaṇitapāda 32–33, itself carried
-- second-hand and owed at verse level).  लब्धि has NO row in
-- `.claude/hooks/MulaVakya_SourceStatementsForTheTermsInOurFileNames.txt`
-- — grep returns only `anupalabdhi`, a different word — so this file
-- introduces a term whose row is owed, and says so rather than letting
-- the omission pass as coverage.
--
------------------------------------------------------------------------
-- WHY THIS MODULE EXISTS.
--
-- `Bhavana_TheKsepaIsDeterminedByTheRootsAndCompositionMultipliesIt`
-- writes its own defect down, verbatim:
--
--   "The चक्रवाल STEP ITSELF is not formalised.  It requires choosing m
--    with k ∣ (a + b·m), and then dividing the composed row through by
--    k — exact division in ℤ, which needs a divisibility witness carried
--    alongside and is not done here."
--
-- This module does not formalise that step.  It settles the STRUCTURAL
-- question the defect raises, which is prior to it:
--
--   IS THE DIVISIBILITY WITNESS A LEGAL CARRIED SLOT, OR IS IT NEW DATA?
--
-- By `Carrier`'s law that is the question whether its fibre is
-- contractible, and the answer is sharper than yes or no.  Run
-- `SakalaVikalaDesa_`'s three-valued census on multiplication by a
-- non-zero k, and ONE OF THE THREE ARMS IS UNINHABITABLE:
--
--   विकलादेश  two quotients, not identified   IMPOSSIBLE   §2, §4
--   नास्ति    no quotient over this n         possible     §5, exhibited
--   सकलादेश   the quotient rides free         the rest     §4
--
-- So the exact division the cakravāla needs can fail only by being
-- UNPOSED.  It can never be AMBIGUOUS.  In `Sesa_`'s vocabulary the
-- failure is always the धनात्मकम् arm — nothing destroyed, because there
-- was no source over the point — and never the नष्टिः arm, where two
-- distinct things are identified and the loss is अप्रतिकार्या.
--
-- Read back onto the algorithm: CHOOSING m IS EXACTLY AND ONLY THE ACT OF
-- MAKING THE FIBRE INHABITED.  It never also has to make it single, and
-- no choice rule could, because there is nothing to choose between.  The
-- congruence k ∣ (a + b·m) is a condition of posedness, not of
-- determinacy.
--
-- THE GENERAL REASON, §2, one line: the fibre of an injective map into a
-- set is a proposition, and a proposition cannot be crowded.  ℤ supplies
-- the injectivity by cancellation (`·lCancel`, agda/cubical v0.5).
--
-- WHAT THIS DOES NOT DO, so the header is not read as more than it is.
-- The cakravāla's step is still not formalised: nothing here produces m,
-- nothing here divides the composed row, and nothing here says the wheel
-- terminates.  Bhāskara II's minimality rule is absent.  What is settled
-- is which of the three census arms the division step can land in.
------------------------------------------------------------------------

module Fibre.Labdhi_TheQuotientSlotIsNeverCrowdedSoExactDivisionCanOnlyFailByBeingUnposed where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isProp× ; inhProp→isContr)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Int
  using (ℤ ; pos ; _·_ ; isSetℤ ; injPos ; ·lCancel)
open import Cubical.Data.Int.IsEven using (trueIsEven)
open import Cubical.Data.Bool using (false≢true)
open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import Fibre.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph
  using (शेष)
open import Fibre.SakalaVikalaDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic
  using (देश ; नास्ति ; सकलादेश ; विकलादेश ; गणना)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  एकैक — injectivity, named, because it is the hypothesis that does
--     all the work below and it deserves to be visible at the call site.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) where

  एकैक : Type ℓ
  एकैक = {x y : A} → f x ≡ f y → x ≡ y

------------------------------------------------------------------------
-- 2.  THE GENERAL FACT.  An injective map into a set has propositional
--     fibres — so no fibre of it is crowded, and the census loses one of
--     its three arms.
--
--     `isSet B` is genuinely needed and is not bookkeeping: without it
--     the second component `f a ≡ b` is not a proposition and two points
--     of the fibre could differ in their WITNESS while agreeing in their
--     source.  That is a crowded fibre with an equal first coordinate,
--     and it is exactly the situation `Carrier` is built to keep visible.
------------------------------------------------------------------------

  एकैक→शेष-प्रज्ञप्तिः : isSet B → एकैक → (b : B) → isProp (शेष f b)
  एकैक→शेष-प्रज्ञप्तिः sB inj b u v =
    Σ≡Prop (λ a → sB (f a) b) (inj (snd u ∙ sym (snd v)))

  -- The crowded arm cannot be constructed.  Not "is not observed": the
  -- constructor `विकलादेश` demands two points AND a proof they differ,
  -- and that demand is contradictory here.
  विकलादेश-असम्भवः : isSet B → एकैक
                    → (b : B) (x y : शेष f b) → ¬ (x ≡ y) → ⊥
  विकलादेश-असम्भवः sB inj b x y x≢y = x≢y (एकैक→शेष-प्रज्ञप्तिः sB inj b x y)

  -- With inhabitation decided, the census is complete and two-valued.
  -- Decidability is a SEPARATE hypothesis, and that separation is the
  -- content: injectivity kills विकलादेश, deciding kills nothing but tells
  -- you which of the surviving two you are in.
  द्विधा-गणना : isSet B → एकैक → ((b : B) → Dec (शेष f b)) → गणना f
  द्विधा-गणना sB inj dec b with dec b
  ... | yes s  = सकलादेश (inhProp→isContr s (एकैक→शेष-प्रज्ञप्तिः sB inj b))
  ... | no ¬s  = नास्ति ¬s

------------------------------------------------------------------------
-- 3.  THE ARITHMETIC INSTANCE.  Multiplication by k, whose fibre over n
--     is precisely the divisibility witness the defect asks about:
--
--         शेष (गुणः k) n  =  Σ[ q ∈ ℤ ] (k · q ≡ n)
--
--     — a quotient together with the proof that it IS the quotient,
--     which is the शेष/लब्धि pair written as a type.
------------------------------------------------------------------------

गुणः : ℤ → ℤ → ℤ
गुणः k q = k · q

लब्धिः : ℤ → ℤ → Type
लब्धिः k n = शेष (गुणः k) n

गुणः-एकैक : (k : ℤ) → ¬ (k ≡ pos 0) → एकैक (गुणः k)
गुणः-एकैक k k≢0 {q} {q'} p = ·lCancel k q q' p k≢0

------------------------------------------------------------------------
-- 4.  THE STATEMENT.  For k ≠ 0 the quotient is determined; where it
--     exists at all it is contractible, hence a legal carried slot by
--     `Carrier`'s law, contributing no degree of freedom.
------------------------------------------------------------------------

लब्धिः-प्रज्ञप्तिः : (k : ℤ) → ¬ (k ≡ pos 0) → (n : ℤ) → isProp (लब्धिः k n)
लब्धिः-प्रज्ञप्तिः k k≢0 =
  एकैक→शेष-प्रज्ञप्तिः (गुणः k) isSetℤ (गुणः-एकैक k k≢0)

लब्धिः-सम्पूर्णा : (k : ℤ) → ¬ (k ≡ pos 0) → (n : ℤ)
                → लब्धिः k n → isContr (लब्धिः k n)
लब्धिः-सम्पूर्णा k k≢0 n l = inhProp→isContr l (लब्धिः-प्रज्ञप्तिः k k≢0 n)

-- and the crowded arm is uninhabitable at every n at once.
लब्धिः-न-विकला : (k : ℤ) → ¬ (k ≡ pos 0) → (n : ℤ)
               → (x y : लब्धिः k n) → ¬ (x ≡ y) → ⊥
लब्धिः-न-विकला k k≢0 =
  विकलादेश-असम्भवः (गुणः k) isSetℤ (गुणः-एकैक k k≢0)

-- THE READING FOR THE CAKRAVĀLA.  One turn divides TWO coordinates by
-- the same k.  Both quotients are determined, jointly: the pair of
-- witnesses is a proposition, so the turn as a whole has no ambiguity to
-- resolve, only a posedness condition to satisfy.
अवतरण-लब्धी : (k : ℤ) → ¬ (k ≡ pos 0) → (n₁ n₂ : ℤ)
            → isProp (लब्धिः k n₁ × लब्धिः k n₂)
अवतरण-लब्धी k k≢0 n₁ n₂ =
  isProp× (लब्धिः-प्रज्ञप्तिः k k≢0 n₁) (लब्धिः-प्रज्ञप्तिः k k≢0 n₂)

------------------------------------------------------------------------
-- 5.  THE OTHER ARM, EXHIBITED RATHER THAN ASSERTED.  नास्ति is not
--     hypothetical: 2 does not divide 1, so that fibre is empty and the
--     census entry there is a term.  An absence without a witness is a
--     rumour.
------------------------------------------------------------------------

द्वि≢शून्यम् : ¬ (pos 2 ≡ pos 0)
द्वि≢शून्यम् p = snotz (injPos p)

-- Σ[ q ] 2 · q ≡ 1 would make 1 even, and `isEven 1` computes to false.
द्वि-न-भजति-एकम् : ¬ (लब्धिः (pos 2) (pos 1))
द्वि-न-भजति-एकम् (q , p) = false≢true (trueIsEven (pos 1) (q , sym p))

गणना-द्वि-एकम् : देश (गुणः (pos 2)) (pos 1)
गणना-द्वि-एकम् = नास्ति द्वि-न-भजति-एकम्

-- and the other arm, at a point where the division IS posed: 2 · 2 = 4.
गणना-द्वि-चतुर् : देश (गुणः (pos 2)) (pos 4)
गणना-द्वि-चतुर् =
  सकलादेश (लब्धिः-सम्पूर्णा (pos 2) द्वि≢शून्यम् (pos 4) (pos 2 , refl))

------------------------------------------------------------------------
-- 6.  WHAT IS OWED.  Written, not left to be discovered.
--
--   * The MulaVakya row for लब्धि — the term, a text, a date.  Owed by
--     this file, stated in its own header.
--   * `द्विधा-गणना` is never instantiated at `गुणः k`, because that needs
--     `(n : ℤ) → Dec (लब्धिः k n)`.  `Cubical.Data.Int.Divisibility.dec∣`
--     decides the PROPOSITIONALLY TRUNCATED `_∣_`, and `∣→∣'` untruncates
--     it only after a case split on the shape of the divisor, which an
--     abstract `¬ k ≡ pos 0` does not give.  So the complete census for
--     multiplication by an arbitrary non-zero k is NOT built here; §5
--     exhibits both arms at a concrete k instead.  Named, not done.
--   * The step itself, per this module's opening: m, the division, the
--     minimality rule, termination.  All still open, all still
--     `Bhavana_`'s defect and `CakravalaBound`'s.
------------------------------------------------------------------------
