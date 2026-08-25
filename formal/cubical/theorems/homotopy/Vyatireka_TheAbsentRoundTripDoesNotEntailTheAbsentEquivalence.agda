{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- व्यतिरेकः — the negative concomitance, and the inference that is not
-- licensed by it.
--
-- THE TERM, ITS TEXT AND ITS DATE.  व्यतिरेक is the negative half of the
-- Nyāya pervasion (व्याप्ति): अन्वय is "wherever the हेतु, there the
-- साध्य", व्यतिरेक is its contrapositive, "wherever the साध्य is absent,
-- the हेतु is absent".  The हेतु and the members of the inference are set
-- out in Gautama, *Nyāyasūtra* 1.1.5 and 1.1.32–39 (the five-membered
-- न्यायवाक्य), c. 2nd c. CE; the अन्वय/व्यतिरेक pair as the two supports
-- of व्याप्ति is worked in Vātsyāyana's *Nyāyabhāṣya*, c. 450 CE, and the
-- केवलान्वयिन् / केवलव्यतिरेकिन् / अन्वयव्यतिरेकिन् classification of
-- हेतुs is standard by Annaṃbhaṭṭa, *Tarkasaṃgraha*, c. 1600 CE.
--
-- WHAT IS AND IS NOT CLAIMED.  No Naiyāyika is credited with type theory
-- or with any theorem below, and no claim is made that व्याप्ति and the
-- implication of type theory are the same relation.  What is claimed is
-- that the term names, exactly, the step this module examines: from
-- "the round trip is absent" the machine took "the equivalence is
-- absent", and that step is a व्यतिरेक-व्याप्ति which does not hold.
-- Nyāya is the school being drawn on here and it is named before its
-- vocabulary is used.
--
------------------------------------------------------------------------
-- WHAT THIS MODULE IS.
--
-- `interactive/AnulomaPratiloma_…hs` proposed 39 candidate inverse pairs and
-- reported 0 accepted at every rung of its ladder, concluding that "every
-- causeway costs a real proof".  Two things are wrong with the conclusion
-- and this module fixes the second; the first is recorded here because
-- it is the larger error and belongs next to it.
--
--   THE FIRST.  Sixteen of the 39 pairs name types the HOST MODULE HAS
--   ALREADY IDENTIFIED, by hand, in the same file the proposer read —
--   `SaptabhangiNaya.saptabhangi-equiv`, `Digits.ℕ≃CanWord`,
--   `FreeMonoid.ℕ≃Tally`, `TermFreeMonoid.Tm≃List`, all four of
--   `PMTorus`, both of `S3IntegerRelativeCoordinates`,
--   `CenterRelative.Pair≃CR`, `AchromaticToy.L₁₂`,
--   `ProjectionChargeAudit.localChargeEquiv`,
--   `WallCertificate.quotient≃Bool`.  The proposer read every top-level
--   arrow in the corpus and never read a top-level `_≃_`.  "No cheap
--   harvest" was a measurement of the instrument.
--
--   THE SECOND, and it is what is proved below.  A refuted round trip
--   refutes THE PAIR.  It says nothing about the types.  Three verdicts
--   live under the machine's single "not accepted", and
--   `Tantujala_…agda` already gives this repository the shape of that
--   complaint: a two-valued verdict on three positions identifies two of
--   them.  Here the three are
--
--     (अ)  the pair fails and the types ARE equivalent, by another map.
--          `Anyathasiddhi_…agda` is the worked case: `res` does not invert
--          `infl`, and `infl` is nevertheless an equivalence.  §३ below
--          adds a second: `Digits.value` is not injective on `Word`, and
--          the same file proves `ℕ ≃ CanWord`.
--     (आ)  the pair fails and the types are SEPARATED.  §१–२: `Syllable`
--          and `ℕ`; `Z2` and `Z4`.  Both are proved, from one lemma.
--     (इ)  the pair fails and nothing is known either way.  §४: two pairs
--          left in exactly that state, said so rather than resolved.
--
-- §५ then transports a separation along the causeway of
-- `Anyathasiddhi_…agda` — a non-equivalence crosses an equivalence with
-- one `subst` and no new case analysis, which is the point of having the
-- edge at all.
------------------------------------------------------------------------

module Vyatireka_TheAbsentRoundTripDoesNotEntailTheAbsentEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq ; secEq
                                            ; invEquiv ; compEquiv)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Bool.Properties using (true≢false)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; snotz)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)

open import PingalaPrastara using (Syllable ; laghu ; guru ; aksara ; parity)
open import InflationVersusSubgroup
  using (Z2 ; e0 ; e1 ; Z4 ; z0 ; z1 ; z2 ; z3 ; incl ; proj)
open import SieveScaleTower using (O₁ ; O₂ ; s₂₁ ; π₂₁)

-- Base two, so the arithmetic in §३ reduces.  `Digits` is parameterized by
-- k with b = 2 + k; nothing below depends on the choice.
open import Digits 0
  using (Word ; Digit ; value ; digits ; CanWord ; ℕ≃CanWord)
open import Cubical.Data.Fin using (fzero)

open import Anyathasiddhi_TheProposedInverseIsSpuriousAndInflationCarriesTheGroup
  using (H2≡H4 ; res-is-not-a-retraction)
open import InflationVersusSubgroup using (H2 ; k0 ; kι ; H4)

------------------------------------------------------------------------
-- ० · THE ONE LEMMA.  Three pairwise-distinct points cannot be injected
--     into `Bool`.  Everything in §१–२ is this, twice.
--
--     The Boolean pigeonhole is stated separately so that no `with` is
--     needed against the injectivity hypothesis: `pairOf` is six lines of
--     enumeration and carries no hypotheses at all.
------------------------------------------------------------------------

pairOf : (a b c : Bool) → (a ≡ b) ⊎ ((a ≡ c) ⊎ (b ≡ c))
pairOf false false _     = inl refl
pairOf true  true  _     = inl refl
pairOf false true  false = inr (inl refl)
pairOf false true  true  = inr (inr refl)
pairOf true  false false = inr (inr refl)
pairOf true  false true  = inr (inl refl)

noInj3 : {X : Type} (g : X → Bool)
       → ((p q : X) → g p ≡ g q → p ≡ q)
       → (x y z : X) → ¬ (x ≡ y) → ¬ (x ≡ z) → ¬ (y ≡ z) → ⊥
noInj3 g inj x y z x≢y x≢z y≢z with pairOf (g x) (g y) (g z)
... | inl p       = x≢y (inj x y p)
... | inr (inl p) = x≢z (inj x z p)
... | inr (inr p) = y≢z (inj y z p)

-- The inverse of an equivalence is injective.  One line, no h-levels.
invEq-inj : {A B : Type} (e : A ≃ B) (p q : B) → invEq e p ≡ invEq e q → p ≡ q
invEq-inj e p q r = sym (secEq e p) ∙ cong (equivFun e) r ∙ secEq e q

------------------------------------------------------------------------
-- १ · `PingalaPrastara.aksara ⇄ parity` — the pair fails AND the types
--     are separated.
--
--     `aksara : Syllable → ℕ` sends लघु to 0 and गुरु to 1; `parity : ℕ →
--     Syllable` reads the last bit.  `parity ∘ aksara` is the identity —
--     the proposer was right that there is a retraction — and
--     `aksara ∘ parity` is not, because `aksara (parity 2) = 0`.  Here the
--     व्यतिरेक does hold: no equivalence exists at all.
--
--     This is the प्रस्तार's own arithmetic and it is the reason उद्दिष्ट
--     is a positional sum rather than a lookup: one syllable carries one
--     bit, and ℕ is not one bit.
------------------------------------------------------------------------

sylBool : Syllable → Bool
sylBool laghu = false
sylBool guru  = true

sylBool-inj : (p q : Syllable) → sylBool p ≡ sylBool q → p ≡ q
sylBool-inj laghu laghu _ = refl
sylBool-inj guru  guru  _ = refl
sylBool-inj laghu guru  r = ⊥-rec (true≢false (sym r))
sylBool-inj guru  laghu r = ⊥-rec (true≢false r)

-- the pair itself
aksara-parity-fails : ¬ ((n : ℕ) → aksara (parity n) ≡ n)
aksara-parity-fails h = znots (h 2)

-- and the separation, which does not follow from it and is proved
¬Syllable≃ℕ : ¬ (Syllable ≃ ℕ)
¬Syllable≃ℕ e =
  noInj3 (λ n → sylBool (invEq e n))
         (λ p q r → invEq-inj e p q (sylBool-inj _ _ r))
         0 1 2 znots znots (λ r → znots (cong pred1 r))
  where
    pred1 : ℕ → ℕ
    pred1 zero    = zero
    pred1 (suc n) = n

------------------------------------------------------------------------
-- २ · `InflationVersusSubgroup.incl ⇄ proj` — the pair fails AND the
--     types are separated.
--
--     N = {z0,z2} ↪ ℤ/4 is the subgroup and ℤ/4 ↠ ℤ/2 the quotient; the
--     proposer matched their arrows because the quotient and the subgroup
--     are abstractly the same group, and that coincidence is the whole
--     subject of the host module.  `proj ∘ incl` is the identity;
--     `incl ∘ proj` sends z1 to z2.
------------------------------------------------------------------------

z4a : Z4 → Bool          -- separates z0 from z1 and z2
z4a z0 = true ; z4a z1 = false ; z4a z2 = false ; z4a z3 = false

z4b : Z4 → Bool          -- separates z1 from z2
z4b z0 = false ; z4b z1 = true ; z4b z2 = false ; z4b z3 = false

z2Bool : Z2 → Bool
z2Bool e0 = false
z2Bool e1 = true

z2Bool-inj : (p q : Z2) → z2Bool p ≡ z2Bool q → p ≡ q
z2Bool-inj e0 e0 _ = refl
z2Bool-inj e1 e1 _ = refl
z2Bool-inj e0 e1 r = ⊥-rec (true≢false (sym r))
z2Bool-inj e1 e0 r = ⊥-rec (true≢false r)

incl-proj-fails : ¬ ((g : Z4) → incl (proj g) ≡ g)
incl-proj-fails h = true≢false (cong z4b (sym (h z1)))

¬Z2≃Z4 : ¬ (Z2 ≃ Z4)
¬Z2≃Z4 e =
  noInj3 (λ g → z2Bool (invEq e g))
         (λ p q r → invEq-inj e p q (z2Bool-inj _ _ r))
         z0 z1 z2
         (λ r → true≢false (cong z4a r))
         (λ r → true≢false (cong z4a r))
         (λ r → true≢false (cong z4b r))

------------------------------------------------------------------------
-- ३ · `Digits.digits ⇄ value` — the pair fails and the
--     types are NOT separated, and the SAME FILE carries the repair.
--
--     `value` is not injective on raw words: `fzero ∷ []` and `[]` both
--     evaluate to 0, which is the leading-zero ambiguity of positional
--     notation and is why `Digits` defines `Canonical` at all.  The
--     proposer refused the pair and its refusal reads, in the log, exactly
--     like the refusals in §१–२.  It is a different verdict: `Digits`
--     proves `ℕ ≃ CanWord` sixty lines further down, and that equivalence
--     is imported here so the two claims stand on the same page.
------------------------------------------------------------------------

digits-value-fails : ¬ ((w : Word) → digits (value w) ≡ w)
digits-value-fails h = znots (cong length (h (fzero ∷ [])))

-- the edge that does exist, quoted from the host, not rebuilt
ℕ≡CanWord : ℕ ≡ CanWord
ℕ≡CanWord = ua ℕ≃CanWord

------------------------------------------------------------------------
-- ४ · `SieveScaleTower.s₂₁ ⇄ π₂₁` — the pair fails and
--     THE TYPES ARE NOT SEPARATED HERE, and I do not know whether they
--     are.  Stated, not resolved.
--
--     O₁ = ℕ and O₂ = ℕ × ℕ.  `s₂₁ x = (x , 0)` is a section of the
--     projection, so `π₂₁ ∘ s₂₁` is the identity and `s₂₁ ∘ π₂₁` forgets
--     the second coordinate — refuted below.  Whether ℕ ≃ ℕ × ℕ holds is
--     a separate question with a well-known affirmative answer by a
--     pairing function; the cubical library shipped with this repository
--     (agda/cubical v0.9) has no such equivalence under `Cubical.Data.Nat`,
--     nothing in this corpus proves one, and I am not asserting one.  The
--     honest verdict on this candidate is (इ).
------------------------------------------------------------------------

s₂₁-π₂₁-fails : ¬ ((o : O₂) → s₂₁ (π₂₁ o) ≡ o)
s₂₁-π₂₁-fails h = znots (cong snd (h (0 , 1)))

------------------------------------------------------------------------
-- ५ · A SEPARATION CROSSES A CAUSEWAY.
--
--     `Anyathasiddhi_…agda` built H2 ≡ H4 out of the pair the machine
--     refused.  H2 = H¹(ℤ/2, ℤ/2) is a two-element enumeration and so is
--     Z2; §२ separated Z2 from Z4.  Composing, H4 = H¹(ℤ/4, ℤ/2) is not
--     ℤ/4 — a non-equivalence obtained by ONE `subst` along a path, with
--     no case analysis on H4 anywhere.  That is what the edge was for.
------------------------------------------------------------------------

Z2≃H2 : Z2 ≃ H2
Z2≃H2 = isoToEquiv (iso f g sec ret)
  where
    f : Z2 → H2
    f e0 = k0
    f e1 = kι
    g : H2 → Z2
    g k0 = e0
    g kι = e1
    sec : (h : H2) → f (g h) ≡ h
    sec k0 = refl
    sec kι = refl
    ret : (x : Z2) → g (f x) ≡ x
    ret e0 = refl
    ret e1 = refl

Z2≡H4 : Z2 ≡ H4
Z2≡H4 = ua Z2≃H2 ∙ H2≡H4

¬H4≃Z4 : ¬ (H4 ≃ Z4)
¬H4≃Z4 = subst (λ A → ¬ (A ≃ Z4)) Z2≡H4 ¬Z2≃Z4

------------------------------------------------------------------------
-- ६ · WHAT IS NOT PROVED HERE.
--
--   * That the remaining candidates of the 39 are any particular verdict.
--     Twenty-three pairs are untouched by this file; the sixteen listed in
--     the header are already-proved edges, and the seven examined here are
--     named one by one.  No count is claimed for the rest.
--   * That `noInj3` generalises.  It separates a two-element type from
--     anything with three distinguishable points and nothing more; the
--     four-versus-eight separation the queue also contains
--     (`AdaptiveProbeCollapse`) needs a different argument and is not
--     attempted.
--   * That व्यतिरेक as Nyāya uses it is the contrapositive of a material
--     implication.  It is a relation between properties in a substrate,
--     argued with उपाधि and तर्क, and the reduction of it to a truth-table
--     is not being asserted.
------------------------------------------------------------------------
