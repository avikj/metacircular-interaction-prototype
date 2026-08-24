{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Punarāgamana · सर्वत्र-गणना
--
-- ON THE NAME.  गणना ("counting, census") is used here in exactly the
-- sense `Punaragamana.SakalaVikalaDesa_…` already gives it in this
-- library — a pointwise diagnosis `(b : B) → देश f b` — and the usage is
-- carried from that module, not from a text.  सर्वत्र ("everywhere") is
-- ordinary Sanskrit and the compound सर्वत्र-गणना is BUILT HERE.  No
-- source is claimed for it, and nothing below is claimed to have been
-- proved by anyone in the Jaina or Pāṇinīya line.  What is borrowed is
-- the classification (सकलादेश / विकलादेश, and the three cells), which
-- `SakalaVikalaDesa_…` cites at ग्रेड·शब्द to Malliṣeṇa, *Syādvādamañjarī*,
-- 1292 CE, and which is owed at verse level there and equally here.
--
------------------------------------------------------------------------
-- WHY THIS MODULE EXISTS: ONE OBJECT, TWO VOCABULARIES, AND A
-- CONTRADICTION BETWEEN THEM.
--
-- This corpus censuses the fibre of a map TWICE, in two libraries that
-- cannot import each other, and the two disagree.
--
--   `formal/cubical/Tantujala_TheFibreHasThreeVerdictsAndIsContrMergesTwoOfThem`
--   carries THREE PREDICATES — रिक्तम् / एकम् / बहु — plus three separate
--   pairwise-exclusion lemmas (रिक्त-एक-विरोधः, रिक्त-बहु-विरोधः,
--   एक-बहु-विरोधः).
--
--   `Punaragamana.SakalaVikalaDesa_…` (this library) carries ONE
--   DATATYPE — देश, constructors नास्ति / सकलादेश / विकलादेश — whose
--   constructors carry their own evidence.
--
-- They are the same three cells of the same object.  §1 proves it: the
-- datatype and the three-fold sum of the predicates are isomorphic, both
-- round trips `refl`.  So the duality is not two results; it is one
-- result stated twice, and §2 derives Tantujala's three exclusion lemmas
-- from the single datatype, which is where they were always going to come
-- from.
--
-- AND THE TWO NAMINGS CONTRADICT, which is why the duplication was not
-- harmless.  Tantujala §४ reads the cells as saptabhaṅgī seeds —
-- *"रिक्तम् is अवक्तव्य, एकम् is अस्ति, बहु is नास्ति"*.  `SakalaVikalaDesa_…`
-- struck exactly that assignment on 2026-08-24, with a reason: अवक्तव्यम् is
-- the SIMULTANEOUS (yugapat) assertion of asti and nāsti, earned only
-- where a krama-pair recovers what one utterance cannot say
-- (`SaptabhangiNaya.avaktavya-does-not-factor`), and a plain unreached
-- point has none of that structure — it is नास्ति.  Under §1 the two
-- modules are censusing one object, so they cannot hold both readings.
-- The strike is recorded at Tantujala §४ in the same commit as this file;
-- the mathematics here is indifferent to the naming, which is the point —
-- the term settles which cell is which, and the prose then has to follow.
--
------------------------------------------------------------------------
-- WHAT IS NEW HERE, AND IT IS §3.
--
-- `SakalaVikalaDesa_…` argues that the diagnosis must be a TERM rather
-- than a verdict, and builds three instances by hand.  It does not say
-- WHY a census cannot simply be proved for every map — and if it could
-- be, the datatype would be a convenience rather than a necessity, and
-- every instance in this library would be redundant labour.
--
-- It cannot be.  §3 shows that a census available at every map and every
-- point DECIDES EVERY TYPE at that level:
--
--     सर्वत्र-गणना ℓ  →  (P : Type ℓ) → Dec P
--
-- and hence, restricted to propositions, is the law of excluded middle.
-- The proof is three clauses and needs no hypothesis on P: take the
-- unique map `P → Unit*` and census it at `tt*`.  नास्ति over that point
-- says precisely ¬P; सकलादेश and विकलादेश each EXHIBIT a point of the
-- residual, whose first component is a point of P.  Both non-empty cells
-- decide the same way, which is the content: the census's three-way
-- refinement is finer than decidability, and already at least as strong.
--
-- So the three cells are DATA and not a theorem, and the labour in this
-- library is not redundant: an agent that "just proves the census" for a
-- general map has assumed excluded middle, and this module is what will
-- catch it.
--
-- WHAT IS NOT CLAIMED.  (a) The converse.  `Dec (शेष f b)` does NOT
-- deliver `देश f b` — deciding whether the residual is inhabited says
-- nothing about contractible-versus-crowded — and no separation of the
-- two is exhibited here, so "exactly" is not written anywhere above.
-- What IS proved, in §3, is the easy half in the other direction:
-- a census at ONE point decides that ONE residual (देशात्-तन्तु-निर्णयः).
-- (b) Inconsistency.  `सर्वत्र-गणना` at a level is a hypothesis stated and
-- used, never assumed; whether it is refutable under univalence is not
-- addressed and is not asserted.
--
-- CHECKED: Agda 2.6.3, agda/cubical v0.5 — the library's declared pin,
-- via `punaragamana/check.sh`, which bootstrapped both from nothing.
-- --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module Punaragamana.SarvatraGanana_TheTotalCensusDecidesEveryTypeSoTheThreeCellsAreDataNotATheorem where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import Punaragamana.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph
  using (शेष)
open import Punaragamana.SakalaVikalaDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic
  using (देश ; नास्ति ; सकलादेश ; विकलादेश)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  ONE OBJECT.  The three predicates are the datatype.
--
-- These three are Tantujala's, transcribed rather than imported — the
-- two libraries are separate `.agda-lib`s on different cubical pins and
-- neither can see the other.  The transcription is exact: Tantujala
-- writes them over `fiber f b`, and `fiber f b` is `शेष f b`, the same Σ,
-- definitionally.  That is the whole of the duality this section removes.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) where

  रिक्तम् : B → Type ℓ
  रिक्तम् b = ¬ (शेष f b)

  एकम् : B → Type ℓ
  एकम् b = isContr (शेष f b)

  बहु : B → Type ℓ
  बहु b = Σ[ x ∈ शेष f b ] Σ[ y ∈ शेष f b ] (¬ (x ≡ y))

  -- The collapse.  Not an equivalence smuggled in by a lemma: both round
  -- trips are `refl`, because the datatype's constructors carry exactly
  -- the three predicates' evidence and nothing else.
  देश-विवेकः : (b : B) → Iso (देश f b) (रिक्तम् b ⊎ (एकम् b ⊎ बहु b))
  देश-विवेकः b = iso आगमः प्रत्यागमः दक्षिणम् वामम्
    where
      आगमः : देश f b → रिक्तम् b ⊎ (एकम् b ⊎ बहु b)
      आगमः (नास्ति ¬s)         = inl ¬s
      आगमः (सकलादेश c)         = inr (inl c)
      आगमः (विकलादेश x y x≢y)  = inr (inr (x , y , x≢y))

      प्रत्यागमः : रिक्तम् b ⊎ (एकम् b ⊎ बहु b) → देश f b
      प्रत्यागमः (inl ¬s)                = नास्ति ¬s
      प्रत्यागमः (inr (inl c))           = सकलादेश c
      प्रत्यागमः (inr (inr (x , y , p))) = विकलादेश x y p

      दक्षिणम् : (u : रिक्तम् b ⊎ (एकम् b ⊎ बहु b)) → आगमः (प्रत्यागमः u) ≡ u
      दक्षिणम् (inl _)             = refl
      दक्षिणम् (inr (inl _))       = refl
      दक्षिणम् (inr (inr _))       = refl

      वामम् : (d : देश f b) → प्रत्यागमः (आगमः d) ≡ d
      वामम् (नास्ति _)      = refl
      वामम् (सकलादेश _)     = refl
      वामम् (विकलादेश _ _ _) = refl

------------------------------------------------------------------------
-- 2.  Tantujala's three exclusion lemmas, from the one datatype.
--
-- Three separate lemmas there; here they are what the constructors
-- already say.  Kept because §1 without them would leave the two lanes
-- looking merely isomorphic rather than redundant.
------------------------------------------------------------------------

  रिक्त-एक-विरोधः : (b : B) → रिक्तम् b → एकम् b → ⊥
  रिक्त-एक-विरोधः _ r e = r (e .fst)

  रिक्त-बहु-विरोधः : (b : B) → रिक्तम् b → बहु b → ⊥
  रिक्त-बहु-विरोधः _ r m = r (m .fst)

  एक-बहु-विरोधः : (b : B) → एकम् b → बहु b → ⊥
  एक-बहु-विरोधः _ e (x , y , x≢y) = x≢y (isContr→isProp e x y)

  -- and the easy half of §3, at one point: a census decides its residual.
  -- This direction is free; the other direction is §3's negative remark.
  देशात्-तन्तु-निर्णयः : (b : B) → देश f b → Dec (शेष f b)
  देशात्-तन्तु-निर्णयः _ (नास्ति ¬s)       = no ¬s
  देशात्-तन्तु-निर्णयः _ (सकलादेश c)       = yes (c .fst)
  देशात्-तन्तु-निर्णयः _ (विकलादेश x _ _)  = yes x

------------------------------------------------------------------------
-- 3.  THE SHARP ONE.  A census everywhere decides every type.
------------------------------------------------------------------------

-- The hypothesis, named so it is visibly a hypothesis and never a fact:
-- a census available for EVERY map at a level, at EVERY point.
सर्वत्र-गणना : (ℓ : Level) → Type (ℓ-suc ℓ)
सर्वत्र-गणना ℓ = (A B : Type ℓ) (f : A → B) (b : B) → देश f b

-- the unique map to the unit type at the same level
सर्वैकम् : (P : Type ℓ) → P → Unit* {ℓ}
सर्वैकम् _ _ = tt*

-- Three clauses, no hypothesis on P.  नास्ति over `tt*` IS ¬P; the other
-- two cells each exhibit a point of the residual, and its first component
-- is a point of P.  Both non-empty cells decide the same way.
देशात्-निर्णयः : (P : Type ℓ) → देश (सर्वैकम् P) tt* → Dec P
देशात्-निर्णयः _ (नास्ति ¬s)       = no (λ p → ¬s (p , refl))
देशात्-निर्णयः _ (सकलादेश c)       = yes (c .fst .fst)
देशात्-निर्णयः _ (विकलादेश x _ _)  = yes (x .fst)

सर्वत्र-निर्णयः : सर्वत्र-गणना ℓ → (P : Type ℓ) → Dec P
सर्वत्र-निर्णयः {ℓ = ℓ} g P =
  देशात्-निर्णयः P (g P (Unit* {ℓ}) (सर्वैकम् P) tt*)

-- and restricted to propositions, that is excluded middle.
विवेक-नियमः : (ℓ : Level) → Type (ℓ-suc ℓ)
विवेक-नियमः ℓ = (P : Type ℓ) → isProp P → P ⊎ (¬ P)

निर्णयात्-विकल्पः : {P : Type ℓ} → Dec P → P ⊎ (¬ P)
निर्णयात्-विकल्पः (yes p) = inl p
निर्णयात्-विकल्पः (no ¬p) = inr ¬p

सर्वत्र-विवेकः : सर्वत्र-गणना ℓ → विवेक-नियमः ℓ
सर्वत्र-विवेकः g P _ = निर्णयात्-विकल्पः (सर्वत्र-निर्णयः g P)
