{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रेखा-समासः — the two-chart census, carried by the Chinese remainder
-- equivalence from the product carrier to the residue line mod p·q.
--
-- THE ABSENCE CLOSED.  क्षेत्र-समासः (KsetraSamasa_TheTwoChartSurvivor
-- CensusIsTheProductPMinusTwoTimesQMinusTwo) counts the joint survivor
-- set on the PRODUCT carrier Fin p × Fin q and says, verbatim:
--
--   "The identification of this product with the survivors inside
--    Fin (p·q) is the Chinese Remainder ring-iso (ℤ/pq ≃ ℤ/p × ℤ/q,
--    coprime), which is NOT proved here — this module works on the
--    product carrier directly, where the count is exact and needs no
--    CRT.  So the result is the DENSITY product, honestly on the
--    product carrier; the CRT identification with the residue line
--    mod p·q is the remaining, named, half of the atlas."
--
-- and in its दोषलेख: "the CRT identification of the product carrier
-- with the residue line mod p·q is the named other half."
--
-- That half already exists in the corpus: FinCardinality's
--
--   crtEquiv : (m n : ℕ) → isGCD (suc m) (suc n) 1
--            → Fin (suc m · suc n) ≃ (Fin (suc m) × Fin (suc n))
--
-- whose underlying function is the residue-pair map
-- resPair m n x = (x mod suc m , x mod suc n) — DEFINITIONALLY (the
-- equivalence is injSameCard→Equiv applied to resPair, so equivFun of
-- it is resPair by refl; अवशेष-साक्ष्यम् below records this as a refl).
--
-- WHAT IS PROVED, in KsetraSamasa's own terms (शिष्टम् a b is the set
-- of y in Fin p surviving both walls a ≢ y, b ≢ y):
--
--   रेखा-शिष्टम्  — the survivor predicate on the residue line: x in
--                 Fin (p·q) survives iff its reduction mod p survives
--                 (a₁,b₁) and its reduction mod q survives (a₂,b₂);
--   रेखा-अवरोधः  — crtEquiv RESTRICTS to an equivalence
--                 रेखा-शिष्टम् ≃ (शिष्टम् a₁ b₁ × शिष्टम् a₂ b₂),
--                 built as Σ-cong-equiv-fst over crtEquiv (which typechecks
--                 exactly because the residue-pair map IS the reduction
--                 pair) followed by the strict regrouping of a Σ over a
--                 product into a product of Σs;
--   अवरोध-साक्ष्यम् — that restriction, projected back to the carriers,
--                 is the reduction pair (refl);
--   रेखा-समासः    — the census on the residue line, as an equivalence:
--                 रेखा-शिष्टम् ≃ Fin (m · m'), i.e. (p−2)(q−2) survivors
--                 in Fin (p·q), by composing with क्षेत्र-समासः;
--   रेखा-गणना     — the same as a cardinality: card of the survivor
--                 FinSet (built by the library's closure constructors,
--                 not by the equivalence) is m · m', via cardEquiv;
--   the instance p = 5, q = 7 (walls ±1 mod 5 and ±2 mod 7): coprimality
--   by a closed gcd computation, the census Fin 15, and the residue 3 —
--   a survivor since 3 mod 5 ∉ {1,4} and 3 mod 7 ∉ {2,5} — sent to the
--   standard address 4 in Fin 15 by refl, i.e. the whole chain
--   (CRT reduction, two exchanges-and-elisions per chart, factorEquiv)
--   COMPUTES on a closed residue.
--
-- WHAT IS NOT PROVED.  Coprimality of p and q is a HYPOTHESIS (isGCD
-- p q 1), as in crtEquiv; nothing here derives it from primality — that
-- is DistinctPrimesAreCoprime's business, not repeated.  The merged-wall
-- case (p ∣ 2a, count p−1) and the atlas over a list of charts are still
-- KsetraSamasa's named next steps; this module closes exactly the
-- two-chart CRT half.  No claim about primes as such.
------------------------------------------------------------------------

module RekhaSamasa_TheChineseRemainderEquivalenceCarriesTheTwoChartCensusToTheResidueLineModPTimesQ where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; compEquiv)
open import Cubical.Data.Nat using (ℕ ; suc ; znots ; snotz ; injSuc)
  renaming (_·_ to _·ℕ_)
open import Cubical.Data.Nat.GCD using (isGCD ; gcd≡→isGCD)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Sigma
  using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ-cong-equiv-fst)
open import Cubical.Data.FinSet using (FinSet ; card)
open import Cubical.Data.FinSet.Constructors
  using (isFinSetΣ ; isFinSet× ; isFinSet¬ ; isFinSet≡)
open import Cubical.Data.FinSet.Cardinality using (cardEquiv)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)

open import FinCardinality using (resPair ; crtEquiv ; FinSetFin)
open import KsetraSamasa_TheTwoChartSurvivorCensusIsTheProductPMinusTwoTimesQMinusTwo
  using (शिष्टम् ; क्षेत्र-समासः)

------------------------------------------------------------------------
-- ० · the local two-wall condition, exactly the fibre of KsetraSamasa's
-- शिष्टम् (so शिष्टम् a b ≡ Σ y. भित्ति-द्वयम् a b y definitionally).
------------------------------------------------------------------------

भित्ति-द्वयम् : {m : ℕ} (a b y : Fin (suc (suc m))) → Type
भित्ति-द्वयम् a b y = (¬ a ≡ y) × (¬ b ≡ y)

------------------------------------------------------------------------
-- १ · the residue line mod p·q and its reduction pair.  p = 2+m,
-- q = 2+m' as in KsetraSamasa; in crtEquiv's indexing these are
-- suc (suc m) and suc (suc m').
------------------------------------------------------------------------

रेखा : (m m' : ℕ) → Type
रेखा m m' = Fin (suc (suc m) ·ℕ suc (suc m'))

अवशेषौ : (m m' : ℕ) → रेखा m m' → Fin (suc (suc m)) × Fin (suc (suc m'))
अवशेषौ m m' = resPair (suc m) (suc m')

-- the CRT equivalence at these moduli, and the receipt that its
-- function is the reduction pair — by refl, nothing to transport.
चीन-तुल्यता : (m m' : ℕ) → isGCD (suc (suc m)) (suc (suc m')) 1
            → रेखा m m' ≃ (Fin (suc (suc m)) × Fin (suc (suc m')))
चीन-तुल्यता m m' cop = crtEquiv (suc m) (suc m') cop

अवशेष-साक्ष्यम् : (m m' : ℕ) (cop : isGCD (suc (suc m)) (suc (suc m')) 1)
               → equivFun (चीन-तुल्यता m m' cop) ≡ अवशेषौ m m'
अवशेष-साक्ष्यम् m m' cop = refl

------------------------------------------------------------------------
-- २ · the survivor predicate on the residue line: x survives iff both
-- of its reductions survive their chart's two walls.
------------------------------------------------------------------------

रेखा-शिष्टम् : (m m' : ℕ) (a₁ b₁ : Fin (suc (suc m))) (a₂ b₂ : Fin (suc (suc m')))
            → Type
रेखा-शिष्टम् m m' a₁ b₁ a₂ b₂ =
  Σ[ x ∈ रेखा m m' ]
    ( भित्ति-द्वयम् a₁ b₁ (fst (अवशेषौ m m' x))
    × भित्ति-द्वयम् a₂ b₂ (snd (अवशेषौ m m' x)) )

------------------------------------------------------------------------
-- ३ · a Σ over a product carrier with a split predicate is the product
-- of the two Σs — strict in both directions.
------------------------------------------------------------------------

वियोगः : {A B : Type} {P : A → Type} {Q : B → Type}
       → (Σ[ ab ∈ A × B ] (P (fst ab) × Q (snd ab))) ≃ (Σ A P × Σ B Q)
वियोगः =
  isoToEquiv
    (iso (λ s → (fst (fst s) , fst (snd s)) , (snd (fst s) , snd (snd s)))
         (λ t → (fst (fst t) , fst (snd t)) , (snd (fst t) , snd (snd t)))
         (λ _ → refl)
         (λ _ → refl))

------------------------------------------------------------------------
-- ४ · रेखा-अवरोधः — crtEquiv restricts to the survivors.  The first step
-- typechecks because the family on the product carrier, precomposed with
-- equivFun (crtEquiv), IS the family on the line: the residue-pair map is
-- the reduction pair, definitionally.
------------------------------------------------------------------------

रेखा-अवरोधः :
    (m m' : ℕ) (cop : isGCD (suc (suc m)) (suc (suc m')) 1)
    (a₁ b₁ : Fin (suc (suc m))) (a₂ b₂ : Fin (suc (suc m')))
  → रेखा-शिष्टम् m m' a₁ b₁ a₂ b₂ ≃ (शिष्टम् a₁ b₁ × शिष्टम् a₂ b₂)
रेखा-अवरोधः m m' cop a₁ b₁ a₂ b₂ =
  compEquiv
    (Σ-cong-equiv-fst
       {B = λ ab → भित्ति-द्वयम् a₁ b₁ (fst ab) × भित्ति-द्वयम् a₂ b₂ (snd ab)}
       (चीन-तुल्यता m m' cop))
    वियोगः

-- the restriction, projected to the carriers, is the reduction pair.
अवरोध-साक्ष्यम् :
    (m m' : ℕ) (cop : isGCD (suc (suc m)) (suc (suc m')) 1)
    (a₁ b₁ : Fin (suc (suc m))) (a₂ b₂ : Fin (suc (suc m')))
    (s : रेखा-शिष्टम् m m' a₁ b₁ a₂ b₂)
  → ( fst (fst (equivFun (रेखा-अवरोधः m m' cop a₁ b₁ a₂ b₂) s))
    , fst (snd (equivFun (रेखा-अवरोधः m m' cop a₁ b₁ a₂ b₂) s)) )
    ≡ अवशेषौ m m' (fst s)
अवरोध-साक्ष्यम् m m' cop a₁ b₁ a₂ b₂ s = refl

------------------------------------------------------------------------
-- ५ · रेखा-समासः — the census on the residue line: (p−2)(q−2) survivors
-- in Fin (p·q), as an equivalence with Fin (m · m').
------------------------------------------------------------------------

रेखा-समासः :
    (m m' : ℕ) (cop : isGCD (suc (suc m)) (suc (suc m')) 1)
    (a₁ b₁ : Fin (suc (suc m)))  → (¬ a₁ ≡ b₁)
  → (a₂ b₂ : Fin (suc (suc m'))) → (¬ a₂ ≡ b₂)
  → रेखा-शिष्टम् m m' a₁ b₁ a₂ b₂ ≃ Fin (m ·ℕ m')
रेखा-समासः m m' cop a₁ b₁ ne₁ a₂ b₂ ne₂ =
  compEquiv (रेखा-अवरोधः m m' cop a₁ b₁ a₂ b₂) (क्षेत्र-समासः a₁ b₁ ne₁ a₂ b₂ ne₂)

------------------------------------------------------------------------
-- ६ · the same as a cardinality.  The survivor set is a FinSet by the
-- library's closure constructors alone (Σ over Fin (p·q) of products of
-- negations of identity types in Fin p, Fin q) — its finiteness proof
-- does not use the census — and cardEquiv then reads the count off ५.
------------------------------------------------------------------------

रेखा-शिष्ट-गणः :
    (m m' : ℕ) (a₁ b₁ : Fin (suc (suc m))) (a₂ b₂ : Fin (suc (suc m')))
  → FinSet ℓ-zero
रेखा-शिष्ट-गणः m m' a₁ b₁ a₂ b₂ =
    रेखा-शिष्टम् m m' a₁ b₁ a₂ b₂
  , isFinSetΣ (FinSetFin (suc (suc m) ·ℕ suc (suc m')))
      (λ x → _ , isFinSet× (_ , wall (FinSetFin (suc (suc m)))  a₁ b₁ (fst (अवशेषौ m m' x)))
                           (_ , wall (FinSetFin (suc (suc m'))) a₂ b₂ (snd (अवशेषौ m m' x))))
  where
    wall : (X : FinSet ℓ-zero) (a b y : X .fst) → _
    wall X a b y =
      isFinSet× (_ , isFinSet¬ (_ , isFinSet≡ X a y))
                (_ , isFinSet¬ (_ , isFinSet≡ X b y))

रेखा-गणना :
    (m m' : ℕ) (cop : isGCD (suc (suc m)) (suc (suc m')) 1)
    (a₁ b₁ : Fin (suc (suc m)))  → (¬ a₁ ≡ b₁)
  → (a₂ b₂ : Fin (suc (suc m'))) → (¬ a₂ ≡ b₂)
  → card (रेखा-शिष्ट-गणः m m' a₁ b₁ a₂ b₂) ≡ m ·ℕ m'
रेखा-गणना m m' cop a₁ b₁ ne₁ a₂ b₂ ne₂ =
  cardEquiv (रेखा-शिष्ट-गणः m m' a₁ b₁ a₂ b₂) (FinSetFin (m ·ℕ m'))
    ∣ रेखा-समासः m m' cop a₁ b₁ ne₁ a₂ b₂ ne₂ ∣₁

------------------------------------------------------------------------
-- ७ · the instance p = 5, q = 7 (m = 3, m' = 5): walls ±1 mod 5 and
-- ±2 mod 7.  Coprimality is a closed gcd computation; the census is
-- Fin 15; and the residue 3 in Fin 35 — a survivor, since 3 mod 5 = 3
-- is neither 1 nor 4 and 3 mod 7 = 3 is neither 2 nor 5 — is sent to
-- the standard address 4 in Fin 15 by refl: the whole chain computes.
------------------------------------------------------------------------

५-७-सह-अभाज्यौ : isGCD 5 7 1
५-७-सह-अभाज्यौ = gcd≡→isGCD refl

-- the walls, as points of Fin 5 and Fin 7
१₅ ४₅ : Fin 5
१₅ = 1 , (3 , refl)
४₅ = 4 , (0 , refl)

२₇ ५₇ : Fin 7
२₇ = 2 , (4 , refl)
५₇ = 5 , (1 , refl)

१≢४ : ¬ १₅ ≡ ४₅
१≢४ p = snotz (injSuc (sym (cong fst p)))

२≢५ : ¬ २₇ ≡ ५₇
२≢५ p = snotz (injSuc (injSuc (sym (cong fst p))))

-- the census at (5, 7): Fin 15 = Fin ((5−2)·(7−2))
५-७-समासः : रेखा-शिष्टम् 3 5 १₅ ४₅ २₇ ५₇ ≃ Fin 15
५-७-समासः = रेखा-समासः 3 5 ५-७-सह-अभाज्यौ १₅ ४₅ १≢४ २₇ ५₇ २≢५

५-७-गणना : card (रेखा-शिष्ट-गणः 3 5 १₅ ४₅ २₇ ५₇) ≡ 15
५-७-गणना = रेखा-गणना 3 5 ५-७-सह-अभाज्यौ १₅ ४₅ १≢४ २₇ ५₇ २≢५

-- the residue 3 mod 35 survives both charts …
३₃₅ : रेखा-शिष्टम् 3 5 १₅ ४₅ २₇ ५₇
३₃₅ = (3 , (31 , refl))
    , ( (λ p → snotz (injSuc (sym (cong fst p))))
      , (λ p → snotz (injSuc (injSuc (injSuc (cong fst p))))) )
    , ( (λ p → snotz (injSuc (injSuc (sym (cong fst p)))))
      , (λ p → snotz (injSuc (injSuc (injSuc (cong fst p))))) )

-- … and its standard address is 4: chart 1 sends 3 ↦ 1 in Fin 3 (elide
-- 1, then the image 3 of the wall 4), chart 2 sends 3 ↦ 1 in Fin 5, and
-- factorEquiv places (1 , 1) at 1 + 3·1 = 4.  This is a closed computation
-- through crtEquiv's residue-pair map, four exchanges, and factorEquiv.
३-पदम् : fst (equivFun ५-७-समासः ३₃₅) ≡ 4
३-पदम् = refl
