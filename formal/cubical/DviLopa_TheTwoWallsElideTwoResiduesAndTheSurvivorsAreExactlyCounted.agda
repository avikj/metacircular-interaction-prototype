-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्वि-लोपः — the two walls elide two residues, and the survivors are
-- exactly counted: an equivalence, not a cardinality estimate.
--
-- THE LOCAL FACTOR OF THE MEAN FIELD, AS A TERM.  The centered two-wall
-- field (केन्द्रम्: क्षेत्रम् p a y = y ≢ ±a) removes, at each prime chart,
-- either two residues (walls distinct) or one (walls merged, exactly
-- when p ∣ 2a — केन्द्रम्'s भित्ति-सङ्गम/भेद iff).  कुट्टक-कोण's Lemma 2–3
-- prove in prose that each chart keeps p − ω_p ≥ 1 residues and the
-- period keeps ∏(p − ω_p).  This module carries the chart-level count
-- as an EQUIVALENCE on the abstract carrier:
--
--   एक-लोपः  :  (Σ[ j ∈ Fin (suc m) ] ¬ i ≡ j)              ≃ Fin m
--   द्वि-लोपः :  (Σ[ y ∈ Fin (2+m) ] (¬ a ≡ y) × (¬ b ≡ y))  ≃ Fin m
--                                                  (given ¬ a ≡ b)
--
-- — one wall leaves p−1, two distinct walls leave p−2, and "leave" is
-- an identification of the survivor set with a standard type, which is
-- what this corpus means by a receipt (सूत्र ८: अभिज्ञानं तादात्म्यम्, न
-- परिमाणम्).  The numerators of the singular series' local factors
-- (1 − ω_p/p) are the sizes of these types; here they are the types.
--
-- ON THE NAME.  लोपः — Pāṇini, Aṣṭādhyāyī 1.1.60, adarśanaṃ lopaḥ
-- (~500 BCE): elision is non-appearance; and 1.1.62, pratyayalope
-- pratyayalakṣaṇam: the operations conditioned by the elided element
-- STILL APPLY — deletion with an operative receipt.  That is exactly
-- what an equivalence-counted removal is: the residue is gone from the
-- carrier and its accounting continues to act (the equivalence carries
-- every survivor to its standard address).  No claim that Pāṇini counted
-- residue systems; the word is used for its precise content, as the
-- README's movement 9 already reads it.  द्वि-लोप built here, 2026-08-23.
--
-- THE INSTRUMENT is an involution, not an induction: विनिमयः exchanges
-- the wall with fzero (its own inverse, three decidable cases), the
-- zero-wall case is a pattern match on the underlying ℕ, and the
-- general case is the zero case conjugated by the exchange.  punchOut
-- (the library's) is not used: the exchange route needs no separate
-- section lemma because an involution is its own.
--
-- दोषलेखः, scope.  The walls here are abstract distinct points of
-- Fin p — that the arithmetic walls ±a (mod p) are distinct exactly
-- when p ∤ 2a is केन्द्रम्'s theorem on the ℤ side; the mod-p bridge
-- (ℤ → Fin p respecting the divisibility relations) is named, not
-- built.  The product over charts (the period count ∏(p − ω_p), the
-- CRT tensor of कुट्टक-कोण Lemma 3) is likewise named, not built: this
-- is the chart, not the atlas.
------------------------------------------------------------------------

module DviLopa_TheTwoWallsElideTwoResiduesAndTheSurvivorsAreExactlyCounted where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv ; invIso)
open import Cubical.Foundations.Equiv
  using (_≃_ ; equivFun ; invEq ; compEquiv ; invEquiv)
open import Cubical.Foundations.Equiv.Properties using (congEquiv)
open import Cubical.Foundations.Path using (compPathlEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots)
open import Cubical.Data.Nat.Order using (isProp≤ ; suc-≤-suc ; pred-≤-pred)
open import Cubical.Data.Fin using (Fin ; fzero ; discreteFin)
open import Cubical.Data.Sigma
  using ( Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ≡Prop ; Σ≡PropEquiv
        ; Σ-cong-equiv-fst ; Σ-cong-equiv-snd ; Σ-assoc-≃ )
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Relation.Nullary.Properties using (isProp¬)

private
  variable
    m : ℕ

------------------------------------------------------------------------
-- ० · negation respects equivalence (both sides propositions).
------------------------------------------------------------------------

निषेध-तुल्यता : {A B : Type} → A ≃ B → (¬ A) ≃ (¬ B)
निषेध-तुल्यता e =
  isoToEquiv (iso (λ na b → na (invEq e b))
                  (λ nb a → nb (equivFun e a))
                  (λ nb → isProp¬ _ _ nb)
                  (λ na → isProp¬ _ _ na))

------------------------------------------------------------------------
-- १ · विनिमयः — the exchange of a chosen point with fzero.  Its own
-- inverse; the three lemmas are the three decidable cases.
------------------------------------------------------------------------

-- decisions passed as arguments, so every clause reduces transparently
-- (a with-abstraction here is ill-typed: fzero's proof component occurs
-- in both scrutinee and goal in different normal forms).
विनिमयाङ्गम् : (i j : Fin (suc m)) → Dec (j ≡ i) → Dec (j ≡ fzero) → Fin (suc m)
विनिमयाङ्गम् i j (yes _) _       = fzero
विनिमयाङ्गम् i j (no _) (yes _)  = i
विनिमयाङ्गम् i j (no _) (no _)   = j

विनिमयः : (i : Fin (suc m)) → Fin (suc m) → Fin (suc m)
विनिमयः i j = विनिमयाङ्गम् i j (discreteFin j i) (discreteFin j fzero)

अङ्ग-स्वम् : (i : Fin (suc m)) (d₁ : Dec (i ≡ i)) (d₂ : Dec (i ≡ fzero))
          → विनिमयाङ्गम् i i d₁ d₂ ≡ fzero
अङ्ग-स्वम् i (yes _) _  = refl
अङ्ग-स्वम् i (no ¬p) _  = ⊥-rec (¬p refl)

वि-स्वम् : (i : Fin (suc m)) → विनिमयः i i ≡ fzero
वि-स्वम् i = अङ्ग-स्वम् i (discreteFin i i) (discreteFin i fzero)

अङ्ग-शून्यम् : (i : Fin (suc m)) (d₁ : Dec (fzero ≡ i)) (d₂ : Dec (fzero ≡ fzero))
            → विनिमयाङ्गम् i fzero d₁ d₂ ≡ i
अङ्ग-शून्यम् i (yes p) _       = p
अङ्ग-शून्यम् i (no _) (yes _)  = refl
अङ्ग-शून्यम् i (no _) (no ¬q)  = ⊥-rec (¬q refl)

वि-शून्यम् : (i : Fin (suc m)) → विनिमयः i fzero ≡ i
वि-शून्यम् i = अङ्ग-शून्यम् i (discreteFin fzero i) (discreteFin fzero fzero)

अङ्ग-अन्यः : {i j : Fin (suc m)} → ¬ j ≡ i → ¬ j ≡ fzero
          → (d₁ : Dec (j ≡ i)) (d₂ : Dec (j ≡ fzero))
          → विनिमयाङ्गम् i j d₁ d₂ ≡ j
अङ्ग-अन्यः nei nez (yes p) _       = ⊥-rec (nei p)
अङ्ग-अन्यः nei nez (no _) (yes q)  = ⊥-rec (nez q)
अङ्ग-अन्यः nei nez (no _) (no _)   = refl

द्वि-अङ्गम् : (i j : Fin (suc m)) (d₁ : Dec (j ≡ i)) (d₂ : Dec (j ≡ fzero))
           → विनिमयः i (विनिमयाङ्गम् i j d₁ d₂) ≡ j
द्वि-अङ्गम् i j (yes p) _       = वि-शून्यम् i ∙ sym p
द्वि-अङ्गम् i j (no _) (yes q)  = वि-स्वम् i ∙ sym q
द्वि-अङ्गम् i j (no ¬p) (no ¬q) =
  अङ्ग-अन्यः ¬p ¬q (discreteFin j i) (discreteFin j fzero)

वि-द्विः : (i j : Fin (suc m)) → विनिमयः i (विनिमयः i j) ≡ j
वि-द्विः i j = द्वि-अङ्गम् i j (discreteFin j i) (discreteFin j fzero)

विनिमय-तुल्यता : (i : Fin (suc m)) → Fin (suc m) ≃ Fin (suc m)
विनिमय-तुल्यता i =
  isoToEquiv (iso (विनिमयः i) (विनिमयः i) (वि-द्विः i) (वि-द्विः i))

------------------------------------------------------------------------
-- २ · शून्य-लोपः — eliding fzero: the base case, by pattern on the
-- underlying number.
------------------------------------------------------------------------

शून्य-लोपः : (Σ[ j ∈ Fin (suc m) ] (¬ fzero ≡ j)) ≃ Fin m
शून्य-लोपः {m = m} = isoToEquiv (iso अग्रे प्रत्यागमः दक्षिणा वामा)
  where
    अग्रे : (Σ[ j ∈ Fin (suc m) ] (¬ fzero ≡ j)) → Fin m
    अग्रे ((zero , h) , ne)  = ⊥-rec (ne (Σ≡Prop (λ _ → isProp≤) refl))
    अग्रे ((suc k , h) , ne) = k , pred-≤-pred h

    प्रत्यागमः : Fin m → Σ[ j ∈ Fin (suc m) ] (¬ fzero ≡ j)
    प्रत्यागमः (k , h) = (suc k , suc-≤-suc h) , λ p → znots (cong fst p)

    दक्षिणा : (k : Fin m) → अग्रे (प्रत्यागमः k) ≡ k
    दक्षिणा (k , h) = Σ≡Prop (λ _ → isProp≤) refl

    वामा : (s : Σ[ j ∈ Fin (suc m) ] (¬ fzero ≡ j)) → प्रत्यागमः (अग्रे s) ≡ s
    वामा ((zero , h) , ne)  = ⊥-rec (ne (Σ≡Prop (λ _ → isProp≤) refl))
    वामा ((suc k , h) , ne) =
      Σ≡Prop (λ j → isProp¬ (fzero ≡ j)) (Σ≡Prop (λ _ → isProp≤) refl)

------------------------------------------------------------------------
-- ३ · एक-लोपः — eliding ANY point: the base case conjugated by the
-- exchange.  One wall leaves p − 1 residues, identified.
------------------------------------------------------------------------

एक-लोपः : (i : Fin (suc m)) → (Σ[ j ∈ Fin (suc m) ] (¬ i ≡ j)) ≃ Fin m
एक-लोपः {m = m} i =
  compEquiv
    (Σ-cong-equiv-snd (λ j → निषेध-तुल्यता (मार्गः j)))
    (compEquiv (Σ-cong-equiv-fst (विनिमय-तुल्यता i)) शून्य-लोपः)
  where
    -- (i ≡ j) ≃ (fzero ≡ विनिमयः i j): exchange both sides, then slide
    -- the left endpoint along वि-स्वम्.
    मार्गः : (j : Fin (suc m)) → (i ≡ j) ≃ (fzero ≡ विनिमयः i j)
    मार्गः j =
      compEquiv (congEquiv (विनिमय-तुल्यता i))
                (compPathlEquiv (sym (वि-स्वम् i)))

------------------------------------------------------------------------
-- ४ · द्वि-लोपः — two distinct walls leave p − 2 residues, identified.
-- Elide the first wall; the second wall survives it (a ≢ b) and is
-- elided from the quotient carrier by the same instrument.
------------------------------------------------------------------------

द्वि-लोपः : (a b : Fin (suc (suc m))) → (a≢b : ¬ a ≡ b)
         → (Σ[ y ∈ Fin (suc (suc m)) ] ((¬ a ≡ y) × (¬ b ≡ y))) ≃ Fin m
द्वि-लोपः {m = m} a b a≢b =
  compEquiv (invEquiv Σ-assoc-≃)
    (compEquiv (Σ-cong-equiv-snd (λ s → निषेध-तुल्यता (मार्गः s)))
      (compEquiv (Σ-cong-equiv-fst (एक-लोपः a)) (एक-लोपः बहिः)))
  where
    शिष्टम् : Type
    शिष्टम् = Σ[ y ∈ Fin (suc (suc m)) ] (¬ a ≡ y)

    -- the second wall, as a survivor of the first elision, and its
    -- standard address in the quotient carrier.
    बहिः : Fin (suc m)
    बहिः = equivFun (एक-लोपः a) (b , a≢b)

    -- (b ≡ y) ≃ (बहिः ≡ image of s): lift to the survivor subtype (the
    -- membership proof is a proposition), then transport along the
    -- first elision.
    मार्गः : (s : शिष्टम्) → (b ≡ fst s) ≃ (बहिः ≡ equivFun (एक-लोपः a) s)
    मार्गः s =
      compEquiv (Σ≡PropEquiv (λ y → isProp¬ (a ≡ y)) {u = b , a≢b} {v = s})
                (congEquiv (एक-लोपः a))

------------------------------------------------------------------------
-- ५ · the census, read off: the survivor type of one wall in Fin (p) is
-- Fin (p−1); of two distinct walls, Fin (p−2) — कुट्टक-कोण's ω_p
-- dichotomy (= केन्द्रम्'s p ∣ 2a iff) carried as identifications.  The
-- singular series' local numerators are these types' names.
------------------------------------------------------------------------
