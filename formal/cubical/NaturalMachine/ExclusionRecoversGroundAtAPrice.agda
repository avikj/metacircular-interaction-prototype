{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ExclusionRecoversGroundAtAPrice
--
-- What a standpoint IS, when the only thing that can be said about it
-- is what it fails to distinguish.
--
-- ────────────────────────────────────────────────────────────────────
-- THE TWO POSITIONS, AND THAT THEY ARE OPPOSED
--
-- This module is written across a live disagreement between two
-- schools, and the disagreement is the content.  Naming only one of
-- them, or drawing on both as if they were one box of instruments,
-- would take from each the part that converts and discard the dispute.
--
--   BUDDHIST (Dignāga, Pramāṇasamuccaya V; Dharmakīrti, Pramāṇavārttika
--   svārthānumāna).  अपोह / अन्यापोह: a general term has no positive
--   referent.  "Cow" means not-non-cow.  A universal is an EXCLUSION,
--   and there is no further positive ground standing behind it.
--
--   NYĀYA–VAIŚEṢIKA (Uddyotakara, Nyāyavārttika; and from the Mīmāṃsā
--   side Kumārila, Ślokavārttika Apohavāda).  The objection is
--   circularity, and it is put in the school's own technical terms: an
--   अभाव is never bare.  Every absence carries a प्रतियोगिन्, the
--   counterpositive — the very thing whose absence it is — and an
--   अवच्छेदक delimiting it.  So "not-non-cow" already presupposes cow.
--   Exclusion cannot be the ground because exclusion needs a ground.
--
-- These are rivals.  The Naiyāyika does not accept apoha; the Buddhist
-- does not accept the realist universal the pratiyogin is taken to be.
-- Nothing below settles that, and nothing below should be read as one
-- side winning.  What is proved is narrower and, exactly because it is
-- narrower, it is something both sides can be located against:
--
--     exclusion recovers ground, and the recovery has a PRICE,
--     and the price can be paid in either of two places.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SETTING, WHICH IS ALREADY IN THIS CORPUS
--
-- A standpoint here is an observable `q : X → Y` — not an entry in an
-- enumeration of standpoints (that would assert the standpoints are
-- countable, which Sanmatitarka 1.28 denies), but a parameter.  Its
-- GROUND is the relation it identifies by,
--
--     Ground q x x'  =  q x ≡ q x'
--
-- and its EXCLUSION is the negation of that,
--
--     Excludes q x x'  =  ¬ (q x ≡ q x') .
--
-- `NaturalMachine.FiniteInformation` already proves that a target `t`
-- factors through `q` exactly when `t` is constant on the ground.  So
-- the ground is the whole of what the standpoint does — and the
-- question apoha asks, in this corpus's vocabulary, is whether the
-- EXCLUSION is also the whole of it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §2  ground ⟹ exclusion, free.  If q' identifies everything q does,
--       then q excludes everything q' does.  No hypothesis.
--
--   §3  ground transfers factoring.  Co-identification carries
--       FiberConstant, hence (T a set) FactorsThrough.
--
--   §4  ground is EXACTLY what transfers — the converse of §3, with no
--       counterexample needed and no classical principle: transfer for
--       every set-valued target is *equivalent* to co-identification.
--       Instantiate the target at `q` itself.
--
--   §5  PRICE, PAID AT THE COUNTERPOSITIVE.  Exclusion recovers ground
--       when `Ground q` is decidable.  §5 also says why this is NOT a
--       formalisation of the Naiyāyika condition on अभाव, which is a
--       condition on the specification of the absence and not on what
--       can be settled about it.
--
--   §6  PRICE, PAID AT THE TARGET.  Exclusion transfers factoring with
--       NO condition on Y at all, when the target T is discrete.  The
--       counterpositive may be wholly indeterminate; what is required
--       instead is that the thing being decoded can be READ.
--
--   §7  the two prices, and what each school gets to say about them.
--
-- NOT CLAIMED.  No reading of any apoha text beyond the two sentences
-- attributed above; no position on whether Dignāga's apoha is or is not
-- circular; no claim that either school possessed this distinction.  §5
-- and §6 are theorems about observables in a univalent type theory, and
-- the historical dispute is cited because it is where the question was
-- posed sharply, not because it is being adjudicated here.
------------------------------------------------------------------------

module NaturalMachine.ExclusionRecoversGroundAtAPrice where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import NaturalMachine.FiniteInformation
  using (FiberConstant ; FactorsThrough
        ; fiberConstant→factorsThrough ; factorsThrough→fiberConstant)

private
  variable
    ℓx ℓy ℓy' ℓt : Level

------------------------------------------------------------------------
-- 1.  Ground and exclusion
------------------------------------------------------------------------

-- What the standpoint identifies by.
Ground : {X : Type ℓx} {Y : Type ℓy} → (X → Y) → X → X → Type ℓy
Ground q x x' = q x ≡ q x'

-- What it keeps apart.  The absence is not bare: its counterpositive is
-- written into it, as the path type `q x ≡ q x'`.
Excludes : {X : Type ℓx} {Y : Type ℓy} → (X → Y) → X → X → Type ℓy
Excludes q x x' = ¬ (Ground q x x')

-- q' identifies at least as much as q does.
CoIdentify : {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'}
           → (X → Y) → (X → Y') → Type (ℓ-max ℓx (ℓ-max ℓy ℓy'))
CoIdentify {X = X} q q' = (x x' : X) → Ground q x x' → Ground q' x x'

-- q' excludes at least as much as q does.
CoExclude : {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'}
          → (X → Y) → (X → Y') → Type (ℓ-max ℓx (ℓ-max ℓy ℓy'))
CoExclude {X = X} q q' = (x x' : X) → Excludes q x x' → Excludes q' x x'

------------------------------------------------------------------------
-- 2.  Ground determines exclusion, free
--
-- Contraposition, nothing more.  Note the direction reverses: it is
-- q' identifying MORE that makes q exclude more.
------------------------------------------------------------------------

coIdentify→coExclude :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} (q : X → Y) (q' : X → Y')
  → CoIdentify q' q → CoExclude q q'
coIdentify→coExclude q q' h x x' nq g' = nq (h x x' g')

------------------------------------------------------------------------
-- 3.  Ground transfers factoring
------------------------------------------------------------------------

fiberConstant-transfer :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} {T : Type ℓt}
  (q : X → Y) (q' : X → Y') (t : X → T)
  → CoIdentify q' q → FiberConstant q t → FiberConstant q' t
fiberConstant-transfer q q' t h fc x x' g' = fc x x' (h x x' g')

factorsThrough-transfer :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} {T : Type ℓt}
  (isSetT : isSet T) (q : X → Y) (q' : X → Y') (t : X → T)
  → CoIdentify q' q → FactorsThrough q t → FactorsThrough q' t
factorsThrough-transfer isSetT q q' t h ft =
  fiberConstant→factorsThrough isSetT q' t
    (fiberConstant-transfer q q' t h (factorsThrough→fiberConstant q t ft))

------------------------------------------------------------------------
-- 4.  Ground is EXACTLY what transfers
--
-- The converse of §3, and the reason no counterexample is needed
-- anywhere in this module.  If transfer holds for every set-valued
-- target, take the target to be `q` itself — for which fiber constancy
-- is `refl` — and read off co-identification.
--
-- So a standpoint's ground is not merely sufficient for what it lets
-- descend: it is recoverable from it.  Two standpoints let exactly the
-- same targets descend iff they identify exactly the same states.
------------------------------------------------------------------------

TransfersAllTargets :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'}
  → (X → Y) → (X → Y') → Type (ℓ-max (ℓ-max ℓx (ℓ-suc ℓy)) ℓy')
TransfersAllTargets {ℓy = ℓy} {X = X} q q' =
  (T : Type ℓy) → isSet T → (t : X → T)
  → FiberConstant q t → FiberConstant q' t

transferAll→coIdentify :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} (q : X → Y) (q' : X → Y')
  → isSet Y → TransfersAllTargets q q' → CoIdentify q' q
transferAll→coIdentify q q' isSetY tr = tr _ isSetY q (λ _ _ p → p)

coIdentify→transferAll :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} (q : X → Y) (q' : X → Y')
  → CoIdentify q' q → TransfersAllTargets q q'
coIdentify→transferAll q q' h T _ t fc = fiberConstant-transfer q q' t h fc

------------------------------------------------------------------------
-- 5.  The price, paid at the counterpositive
--
-- Exclusion recovers ground exactly when the ground is decidable — i.e.
-- when, of every pair, it is settled whether the standpoint identifies
-- them.  The hypothesis is on `q` — the standpoint whose ground is
-- being RECOVERED — and without it the implication is not available in
-- this type theory.
--
-- WHAT THIS IS NOT.  It is tempting to call `Dec (Ground q x x')` the
-- Naiyāyika condition on अभाव, and that would be a flattening.  The
-- school's requirement is on the SPECIFICATION of the absence: an अभाव
-- is individuated by its प्रतियोगिन् under a प्रतियोगिता-अवच्छेदक, a
-- delimitor fixing under what description the counterpositive is
-- absent.  That is a condition on what the absence IS.  Decidability is
-- a condition on what can be SETTLED about it, and the two come apart:
-- `¬ (q x ≡ q x')` already has its counterpositive written into it, in
-- the school's sense fully determinate, and is still undecidable.  So
-- §5 does not formalise the pratiyogin requirement.  It occupies the
-- same position in the argument — the point where reasoning from an
-- absence needs something more than the absence itself — and the two
-- schools' dispute is over whether anything belongs there at all.
------------------------------------------------------------------------

coExclude→coIdentify :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} (q : X → Y) (q' : X → Y')
  → ((x x' : X) → Dec (Ground q x x'))
  → CoExclude q q' → CoIdentify q' q
coExclude→coIdentify q q' dec ce x x' g' with dec x x'
... | yes p = p
... | no  n = ⊥.rec (ce x x' n g')

-- and then §3 applies unchanged.
factorsThrough-transfer-from-exclusion :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} {T : Type ℓt}
  (isSetT : isSet T) (q : X → Y) (q' : X → Y') (t : X → T)
  → ((x x' : X) → Dec (Ground q x x'))
  → CoExclude q q' → FactorsThrough q t → FactorsThrough q' t
factorsThrough-transfer-from-exclusion isSetT q q' t dec ce =
  factorsThrough-transfer isSetT q q' t (coExclude→coIdentify q q' dec ce)

------------------------------------------------------------------------
-- 6.  The price, paid at the target instead
--
-- The counterpositive may be wholly indeterminate — no decidability on
-- Y or Y' anywhere — and exclusion still transfers factoring, provided
-- the TARGET is discrete.
--
-- The proof is the whole point: to show `t x ≡ t x'`, decide it in T.
-- If it fails, then `q` cannot identify x and x' either (fiber
-- constancy would have forced the equality), so co-exclusion says `q'`
-- does not identify them, contradicting the hypothesis.  The decision
-- that §5 demanded of the ground is manufactured, for the one pair that
-- matters, out of a decision about what is being read.
--
-- This is the corpus's own ceiling condition — a decoder needs a
-- discrete probe to read — arriving here as the price of an apoha step.
------------------------------------------------------------------------

fiberConstant-transfer-discreteTarget :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} {T : Type ℓt}
  (discT : Discrete T) (q : X → Y) (q' : X → Y') (t : X → T)
  → CoExclude q q' → FiberConstant q t → FiberConstant q' t
fiberConstant-transfer-discreteTarget discT q q' t ce fc x x' g'
  with discT (t x) (t x')
... | yes p = p
... | no  n = ⊥.rec (ce x x' (λ g → n (fc x x' g)) g')

factorsThrough-transfer-discreteTarget :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} {T : Type ℓt}
  (isSetT : isSet T) (discT : Discrete T)
  (q : X → Y) (q' : X → Y') (t : X → T)
  → CoExclude q q' → FactorsThrough q t → FactorsThrough q' t
factorsThrough-transfer-discreteTarget isSetT discT q q' t ce ft =
  fiberConstant→factorsThrough isSetT q' t
    (fiberConstant-transfer-discreteTarget discT q q' t ce
      (factorsThrough→fiberConstant q t ft))

------------------------------------------------------------------------
-- 7.  What each school gets to say
--
-- §2 is free and §5–§6 are priced.  That asymmetry is the whole result,
-- and it is not a verdict on the dispute; it is a place to stand while
-- reading it.
--
--   The Naiyāyika reading of §5.  The recovery of the positive ground
--   from the exclusions is not free: something must be supplied at the
--   absence before it will argue.  That is the school's standing point
--   about अभाव, though the thing §5 supplies is decidability and NOT
--   the प्रतियोगिन् requirement (§5, WHAT THIS IS NOT).  Nothing here
--   shows the ground is dispensable, and §4 sharpens the realist side:
--   the ground is not one description among several, it is recoverable
--   from the descent behaviour itself.
--
--   The Buddhist reading of §6.  The condition in §5 was never the only
--   one available.  §6 pays nothing at the counterpositive — the
--   identification relation on Y may be as undecidable as one likes —
--   and still gets every discrete target to descend.  For anything that
--   can actually be READ, the exclusions suffice: no positive ground is
--   supplied, appealed to, or reconstructed anywhere in that proof.
--   Whether अन्यापोह asserted this, more than this, or something the
--   present setting cannot state is not decided here — the texts are
--   arguing about universals and reference, and §6 is a statement about
--   observables.
--
--   What neither gets.  §4 says co-identification is EXACTLY transfer
--   for all set targets; §6 gives transfer only for DISCRETE ones.  So
--   the exclusions determine the standpoint on the readable part and
--   are, on this evidence, silent beyond it.  Whether that residue is a
--   real object or an artefact of the formulation is not settled by
--   anything in this file, and stating it as settled in either
--   direction would be a दुर्नय — a standpoint asserting itself by
--   denying the other.
--
--   The syād form, stated with the bhaṅga named correctly, since this
--   corpus has already proved that the two are not interchangeable
--   (`NaturalMachine.SaptabhangiNaya`, krama ≠ sahā):
--
--     स्यादस्ति — in the respect of discrete targets, exclusion is
--                 ground (§6);
--     स्यान्नास्ति — in the respect of arbitrary set targets, it is not
--                 shown to be (§4 characterises transfer by ground
--                 alone, and §6 does not reach that far);
--     and asserting these two IN SUCCESSION, which is what the two
--     lines above do, is क्रम — the third bhaṅga.  It is not युगपत्.
--
--   The युगपत् position would be a single assertion, not indexed to a
--   respect, holding both at once; in this setting that is precisely a
--   target that no one decoder expresses, i.e. a `¬ FactorsThrough`.
--   This file does not construct one.  Saying "the two respects differ"
--   is the successive reading wearing the simultaneous one's name, and
--   the fourth bhaṅga is not delivered by relabelling the third.
------------------------------------------------------------------------
