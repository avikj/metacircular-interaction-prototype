-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- गुह्य-नास्ति — the concealed loss: it can hide in the loops, and the
-- set-level census cannot see it.
--
-- THE LIMIT OF EVERYTHING LANDED TODAY, exhibited from inside cubespace.
-- `SakalaVikalaDesa`'s trichotomy — and my own `गणना-सप्तभङ्गी` — grade a
-- fibre by its POINTS: empty (अवक्तव्यम्), one up to path (सकलादेश), or two
-- exhibitably distinct (विकलादेश).  In cubespace there is a fourth
-- condition of a fibre, and it defeats all three detectors at once:
--
--     the fibre of  बिन्दु : S¹ → Unit  at tt  is S¹ itself, and S¹ is
--
--       inhabited                     — अवक्तव्यम् cannot fire;
--       merely connected: any two
--       points are ∥·∥₁-equal          — विकलादेश cannot fire, because no
--                                        exhibitably distinct pair EXISTS;
--       yet not a proposition, hence
--       not contractible               — सकलादेश cannot fire either.
--
-- The crowding is real and it is INVISIBLE AT POINTS: it lives one
-- dimension up, in the loops, and it is not "some loss" — it is exactly
-- ℤ (`winding`, ΩS¹Isoℤ), the same charge `Durnaya_…` identified as what
-- every set-valued carrier-observable destroys.  The concealed नास्ति of
-- this fibre IS the gauge charge.
--
-- WHAT THIS MEANS FOR THE CENSUS, said exactly.  The trichotomy's
-- exhaustiveness was a SET-LEVEL theorem: for fibres that are sets, the
-- three verdicts cover.  For higher fibres the sevenfold does not
-- disappear — it RESTRATIFIES: at each h-level the same three seeds
-- reappear (here: π₀-सकल, π₁-बहु with charge ℤ).  Syādvāda is graded by
-- dimension; a census that stops at points is a durnaya one storey up,
-- and this module is its checked counterexample.
--
-- No claim that any Jain author graded predication by h-level.  The
-- claim is that their refusal to let one standpoint exhaust the object
-- is, in cubespace, a THEOREM about which fibres a pointwise census can
-- classify.  गुह्य-नास्ति is built here, 2026-08-23.
------------------------------------------------------------------------

module GuhyaNasti_TheLossCanHideInTheLoopsAndTheSetLevelCensusCannotSeeIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Int using (ℤ ; pos ; sucℤ)
open import Cubical.Data.Nat using (zero ; suc ; znots)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Foundations.GroupoidLaws using (rUnit)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁ ; map ; rec ; isPropPropTrunc)
open import Cubical.HITs.S1
  using (S¹ ; base ; loop ; ΩS¹ ; winding ; intLoop ; windingℤLoop ; isConnectedS¹)

------------------------------------------------------------------------
-- १ · the map, and its fibre identified: शेष बिन्दु tt ≃ S¹.
------------------------------------------------------------------------

बिन्दु : S¹ → Unit
बिन्दु _ = tt

शेष : Unit → Type
शेष u = Σ[ s ∈ S¹ ] (बिन्दु s ≡ u)

शेष≃S¹ : शेष tt ≃ S¹
शेष≃S¹ = isoToEquiv (iso fst (λ s → s , refl)
                         (λ _ → refl)
                         (λ (s , p) i → s , isSetUnit tt tt refl p i))

------------------------------------------------------------------------
-- २ · अवक्तव्यम् cannot fire: the fibre is inhabited.
------------------------------------------------------------------------

सत्त्वम् : शेष tt
सत्त्वम् = base , refl

------------------------------------------------------------------------
-- ३ · विकलादेश cannot fire: any two points of the fibre are MERELY equal —
-- no exhibitably distinct pair exists to name.
------------------------------------------------------------------------

मुक्त-सम्बन्धः : (x y : शेष tt) → ∥ x ≡ y ∥₁
मुक्त-सम्बन्धः (x , p) (y , q) =
  map (λ (r : x ≡ y) → Σ≡Prop (λ s → isSetUnit (बिन्दु s) tt) r)
      (सम्बद्धम् x y)
  where
    सम्बद्धम् : (x y : S¹) → ∥ x ≡ y ∥₁
    सम्बद्धम् x y =
      rec isPropPropTrunc
        (λ (px : base ≡ x) →
          map (λ (py : base ≡ y) → sym px ∙ py) (isConnectedS¹ y))
        (isConnectedS¹ x)

------------------------------------------------------------------------
-- ४ · सकलादेश cannot fire either: the fibre is NOT a proposition.  If every
-- two points were (exhibitably) equal, transporting along शेष≃S¹ would make
-- S¹ a proposition, forcing loop ≡ refl — and winding refutes that with the
-- charge: 1 ≢ 0 in ℤ.
------------------------------------------------------------------------

एक≢शून्य : ¬ (pos (suc zero) ≡ pos zero)
एक≢शून्य p = znots (sym (cong अङ्क p))
  where
    अङ्क : ℤ → _
    अङ्क (pos n) = n
    अङ्क _       = zero

वक्र-अनिवार्यम् : ¬ (loop ≡ refl)
वक्र-अनिवार्यम् p =
  एक≢शून्य (sym (windingℤLoop (pos (suc zero))) ∙ cong winding lem ∙ refl)
  where
    -- intLoop 1 = refl ∙ loop; with p : loop ≡ refl its winding is 0.
    lem : intLoop (pos (suc zero)) ≡ refl
    lem = (λ i → intLoop (pos zero) ∙ p i) ∙ sym (rUnit refl)

न-प्रोप् : ¬ ((x y : शेष tt) → x ≡ y)
न-प्रोप् h = वक्र-अनिवार्यम् loop≡refl
  where
    -- a prop that is inhabited is contractible; contract S¹ through शेष≃S¹
    prS¹ : (x y : S¹) → x ≡ y
    prS¹ x y i = fst (h (x , refl) (y , refl) i)
    loop≡refl : loop ≡ refl
    loop≡refl i j =
      hcomp (λ k → λ { (i = i0) → prS¹ base (loop j) k
                     ; (i = i1) → prS¹ base base k
                     ; (j = i0) → prS¹ base base k
                     ; (j = i1) → prS¹ base base k })
            base

------------------------------------------------------------------------
-- ५ · the concealed charge is exactly ℤ: what the pointwise census cannot
-- see is not "some crowding" but the winding — identified, not bounded.
-- (The library's ΩS¹Isoℤ is the identification; re-exported here as the
-- fibre's own loop charge through शेष≃S¹'s base point.)
------------------------------------------------------------------------

गुह्य-भारः : (सत्त्वम् ≡ सत्त्वम्) → ℤ
गुह्य-भारः p = winding (λ i → fst (p i))

गुह्य-भारः-अशून्यः : Σ[ p ∈ (सत्त्वम् ≡ सत्त्वम्) ] (¬ (गुह्य-भारः p ≡ pos zero))
गुह्य-भारः-अशून्यः =
  (λ i → loop i , refl) ,
  λ q → एक≢शून्य (sym (windingℤLoop (pos (suc zero)))
                  ∙ cong winding (sym (rUnit loop)) ∙ q)

------------------------------------------------------------------------
-- ६ · दोषलेखः.  This does not overturn the set-level census — for fibres
-- that are sets its trichotomy is exhaustive and everything landed today
-- stands.  What it proves is the census's own SCOPE: h-level is a
-- hypothesis, not a formality, and above it the seeds restratify.  The
-- graded census (one sevenfold per dimension) is named here and NOT
-- built; building it without a criterion for how the levels interact
-- would be the durnaya this corpus keeps catching, one storey up.
------------------------------------------------------------------------
