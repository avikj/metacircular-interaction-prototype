{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheAbsenceTowerIsThreeUnconditionally
--
-- अभाव, and how tall it can get.
--
-- ────────────────────────────────────────────────────────────────────
-- THE STANDING CLAIM THIS CORRECTS
--
-- The working state of this thread has said, for many cycles:
--
--     "no bare absences; the absence hierarchy stabilises at three;
--      DECIDABILITY OF THE COUNTERPOSITIVE SETS THE LEVEL."
--
-- The count is right and the mechanism is wrong, and the mechanism was
-- doing the work.  Nothing sets the level.  The tower over any type is
-- three tall, unconditionally, with no hypothesis whatever — and the
-- one thing a hypothesis can do is collapse it the rest of the way, in
-- a single step, to two.  There is no intermediate outcome to be set.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  ¬ ¬ ¬ A ≃ ¬ A, for every type A, with no hypothesis.  Not
--       "stabilises" as an implication — an EQUIVALENCE, because ¬ A is
--       a proposition and the two implications are inverse by
--       propositionality.  So the tower
--
--           A ,  ¬ A ,  ¬ ¬ A ,  ¬ ¬ ¬ A , …
--
--       has at most three distinct entries, and the fourth IS the
--       second, on the nose after univalence.
--
--   §2  the collapse to two is EXACTLY stability: for a proposition A,
--       (A ≃ ¬ ¬ A) ⟺ Stable A.  Both directions.  So the only question
--       a hypothesis can settle is three-or-two, and `Stable` settles
--       it.  `Dec→Stable` is one-way, so decidability was never the
--       operative property; it was a sufficient condition for the one
--       that is.
--
--   §2b the dichotomy is not rhetoric.  `¬ ((¬ A) ≃ (¬ ¬ A))` — the
--       middle collapse is IMPOSSIBLE, for every A, with no hypothesis.
--       So three-or-two really is the whole of it: the second and third
--       entries can never merge, and the only merge available is the
--       one §2 characterises.
--
--   §3  and the consequence for absences stated as negations: §1 at
--       `¬ A` gives `¬ ¬ (¬ A) ≃ ¬ A` outright, so such a statement is
--       already at the fixed point and can never be the top of a
--       three-tall tower.
--
--       HOW MUCH OF THIS CORPUS THAT COVERS IS A COUNT, NOT A LAW.  A
--       grep of `formal/cubical/NaturalMachine` on 2026-08-19: 396
--       modules, of which 235 have a `¬` somewhere in a top-level
--       signature and 20 mention `¬ FactorsThrough`.  That is a count
--       produced by pattern-matching on text.  It is not a
--       classification of the corpus's obstructions, it does not
--       establish that the obstruction of any particular module has
--       negation form, and no claim below rests on it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE DICHOTOMY IS THE ONE ANEKĀNTA NAMES
--
-- Three unconditionally; two exactly when stable; nothing else.  That
-- is a collapse-dichotomy of the shape this thread has been carrying:
-- agreement — here, A agreeing with its own double absence — permits
-- the collapse, and plurality blocks it.  §2b is what makes this a
-- dichotomy rather than a manner of speaking: the agreement cannot be
-- approached by degrees, because the only other merge one could
-- imagine is refuted outright.
--
-- The four corners, taken seriously rather than gestured at.  Is the
-- tower collapsed?  ASSERTED — §2, exactly when A is stable.  DENIED —
-- §2 again, in the same breath, since it is an iff.  BOTH — that would
-- need A ≃ ¬ ¬ A to hold and fail, which is ⊥.  NEITHER — that would
-- need some third outcome, a merge somewhere else in the tower, and
-- §2b refutes the only candidate.  The catuṣkoṭi is exhausted here,
-- which is worth saying because it usually is not.
--
-- AND THIS TOWER IS NOT THE SAPTABHAṄGĪ.  The seven bhaṅgas are not
-- iterated negations and reading them as one is a flattening this
-- module would make easy.  स्यान्नास्ति is an assertion in a respect,
-- not ¬(स्यादस्ति); अवक्तव्य is not ¬¬ anything; and the whole point of
-- the fourth bhaṅga is that it arises from SIMULTANEOUS assertion
-- (युगपत्), where every entry of the tower above is reached by
-- succession (क्रम) — one ¬ after another.  A structure that can only
-- iterate cannot express the simultaneous position.  Nothing in this
-- file is a model of saptabhaṅgī and it should not be cited as one.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS NOT, ON THE APOHA DISPUTE
--
-- It is tempting to read §1 as answering the Naiyāyika regress
-- objection to अपोह — Uddyotakara's and Kumārila's charge that if "cow"
-- means not-non-cow then the exclusion needs a further exclusion and
-- the analysis never terminates.  §1 does show a regress terminating,
-- and terminating immediately.  It is not the same regress.
--
-- The objection is about MEANING: what a general term refers to, and
-- whether the account is circular because the excluded class must
-- already be given.  §1 is about the identity of two TYPES.  A regress
-- of definitions is not stopped by the observation that ¬ ¬ ¬ A and
-- ¬ A are equivalent, because the Naiyāyika complaint is precisely that
-- you were not entitled to write the innermost A down.  So the two
-- schools' dispute stands untouched here.  What the theorem does is
-- remove ONE thing that could have been used on either side of it: no
-- new content is available by iterating exclusion, so nobody may claim
-- an unbounded hierarchy of exclusions as either resource or defect.
--
-- NOT CLAIMED.  That the corpus's obstructions are trivial (they are
-- not — §3 says the tower over them is short, not that they are easy);
-- that stability holds anywhere in particular; any reading of any
-- apoha text beyond the sentence attributed above.
------------------------------------------------------------------------

module TheAbsenceTowerIsThreeUnconditionally where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; propBiimpl→Equiv ; invEq ; equivFun)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; Stable ; NonEmpty)
open import Cubical.Relation.Nullary.Properties using (isProp¬ ; Dec→Stable)

open import FiniteInformation using (FactorsThrough)

private
  variable
    ℓ ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- 1.  The tower is three tall, with no hypothesis at all
------------------------------------------------------------------------

-- the two implications.  Only the first has any content, and it is one
-- application of the term to itself.
¬→¬¬¬ : {A : Type ℓ} → ¬ A → ¬ ¬ ¬ A
¬→¬¬¬ na nna = nna na

¬¬¬→¬ : {A : Type ℓ} → ¬ ¬ ¬ A → ¬ A
¬¬¬→¬ nnna a = nnna (λ na → na a)

-- and they are inverse, because both sides are propositions.  This is
-- the statement that the tower has a fixed point at height one, not
-- merely that it has one somewhere.
tripleNegation≃ : (A : Type ℓ) → (¬ ¬ ¬ A) ≃ (¬ A)
tripleNegation≃ A =
  propBiimpl→Equiv (isProp¬ (¬ ¬ A)) (isProp¬ A) ¬¬¬→¬ ¬→¬¬¬

-- so every higher entry is the second entry: nothing above ¬ ¬ A is new.
fourth≡second : (A : Type ℓ) → (¬ ¬ ¬ A) ≃ (¬ A)
fourth≡second = tripleNegation≃

------------------------------------------------------------------------
-- 2.  The collapse from three to two is EXACTLY stability
------------------------------------------------------------------------

-- A proposition agrees with its own double absence exactly when it is
-- stable.  Nothing weaker will do and nothing stronger is needed.
stable→doubleNegation≃ :
  {A : Type ℓ} → isProp A → Stable A → A ≃ (¬ ¬ A)
stable→doubleNegation≃ pA st =
  propBiimpl→Equiv pA (isProp¬ (¬ _)) (λ a na → na a) st

doubleNegation≃→stable :
  {A : Type ℓ} → A ≃ (¬ ¬ A) → Stable A
doubleNegation≃→stable e = invEq e

------------------------------------------------------------------------
-- 2b.  The middle collapse is impossible, so three-or-two is the whole
--      of it.  No hypothesis: `¬ A ≃ ¬ ¬ A` is refuted for every A.
--
--      The argument is short enough to read off the equivalence.  From
--      the forward map, any `na : ¬ A` yields `e na : ¬ ¬ A` and hence
--      `e na na : ⊥` — so `¬ A` is itself empty, i.e. `¬ ¬ A` holds.
--      Transport that back along the equivalence to get a `¬ A`, and
--      feed it to the emptiness just established.
------------------------------------------------------------------------

noMiddleCollapse : {A : Type ℓ} → ¬ ((¬ A) ≃ (¬ ¬ A))
noMiddleCollapse e = nna (invEq e nna)
  where
    nna : ¬ ¬ _
    nna na = equivFun e na na

-- decidability is sufficient for the collapse and is not the property
-- that governs it.
dec→doubleNegation≃ :
  {A : Type ℓ} → isProp A → Dec A → A ≃ (¬ ¬ A)
dec→doubleNegation≃ pA d = stable→doubleNegation≃ pA (Dec→Stable d)

------------------------------------------------------------------------
-- 3.  Every absence in this corpus is already at the fixed point
--
-- The obstructions here are negations: `¬ FactorsThrough q t`, the
-- collision lemmas, the refutation clauses of the witness-number
-- results.  §1 instantiated at `¬ A` says the tower over ANY of them is
-- two tall — its double absence is itself, by an equivalence.
--
-- Note what this does and does not deflate.  It does not say the
-- obstruction is weak; a `¬ FactorsThrough` is exactly as strong as it
-- was.  It says there is no hierarchy of obstructions above it to be
-- appealed to, and therefore no room for barrier language that trades
-- on iterated absence.
------------------------------------------------------------------------

absenceIsItsOwnDoubleAbsence : (A : Type ℓ) → (¬ ¬ (¬ A)) ≃ (¬ A)
absenceIsItsOwnDoubleAbsence = tripleNegation≃

-- the corpus's own obstruction shape, with nothing assumed about it.
obstructionTowerIsTwoTall :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T)
  → (¬ ¬ (¬ FactorsThrough q t)) ≃ (¬ FactorsThrough q t)
obstructionTowerIsTwoTall q t =
  absenceIsItsOwnDoubleAbsence (FactorsThrough q t)

-- and an obstruction is stable for free, which is the same fact said in
-- the vocabulary the price theorems use.
obstructionIsStable :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) → Stable (¬ FactorsThrough q t)
obstructionIsStable q t = ¬¬¬→¬

------------------------------------------------------------------------
-- ON THIS MODULE'S NAME — "tower", "three" — WHICH TRANSLATE NOTHING.
--
-- No source in this corpus's lineage states an absence hierarchy
-- measured by iteration depth.  The Nyāya–Vaiśeṣika classification of
-- अभाव is fourfold and sorts absences by KIND — prāgabhāva,
-- pradhvaṃsābhāva, atyantābhāva, anyonyābhāva — that is, by the
-- temporal and relational career of what is absent, not by how many
-- negations have been stacked on it.  `notes/ABHAVA.md` §2 carries that
-- table with a primary-text audit (`Tarkasaṅgraha` §§57, 80).
--
-- "The absence tower is three tall" is a statement about iterated `¬`
-- in a constructive type theory.  It is mine, it is proved, and it is
-- not a translation.  Naming the module after it, in a thread whose
-- whole discipline is to prefer the earliest statement over a later
-- restatement, dressed an imported notion in the tradition's clothes —
-- which is the same error `notes/ABHAVA.md` records four struck
-- equations for, one step further along: those at least mapped onto the
-- fourfold before being withdrawn.
--
-- The mathematics below is untouched by this.  What is withdrawn is any
-- suggestion that "the tower" or its height renders a Sanskrit term.
------------------------------------------------------------------------
