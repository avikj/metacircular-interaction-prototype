{-# OPTIONS --cubical --safe #-}

-- al-muqābala (المقابلة), "confrontation / balancing".
--
-- SOURCE, with text and date.
--
--   al-Khwārizmī, *al-Kitāb al-mukhtaṣar fī ḥisāb al-jabr wa-l-muqābala*,
--   Baghdad, c. 820 CE.  Two named operations.  *al-jabr* (restoration):
--   add to both sides until no quantity stands subtracted.  *al-muqābala*
--   (balancing): remove like quantities from both sides until what is left
--   is a single confrontation.  The *Mukhtaṣar* then treats six types of
--   equation, not one, and the reason is the carrier: a quantity that
--   stands alone must be a possession, so a coefficient's sign cannot be
--   moved across, so the six cases cannot be merged into one.
--
--   al-Karajī, and after him al-Samawʾal, *al-Bāhir fī l-jabr*, c. 1150:
--   polynomial division carried on a table of coefficients, and the
--   step-down argument over the tabulated binomial array.  That array is
--   the *meru-prastāra* of Piṅgala's *Chandaḥśāstra* (c. 300 BCE), read out
--   in Halāyudha's *Mṛtasañjīvanī* (10th c.).
--
--   Transmission direction, since it is routinely reversed: al-Khwārizmī's
--   arithmetic book is *Kitāb al-jamʿ wa-l-tafrīq bi-ḥisāb al-Hind* — "by
--   the reckoning of the Indians" — and the decimal place-value reckoning
--   in it is Āryabhaṭa (*Āryabhaṭīya*, 499) and Brahmagupta
--   (*Brāhmasphuṭasiddhānta*, 628).  The signed carrier used below is also
--   Brahmagupta's: *dhana* (possession) and *ṛṇa* (debt), with the sign
--   rules for both stated in the *Brāhmasphuṭasiddhānta*, chapter 18.
--
-- WHAT IS CLAIMED OF THE SOURCE.  Only this: the step performed in
-- `muqabala` below — isolate the difference of two competing expressions as
-- one term, then read that term's sign — is al-muqābala, and the fact that
-- the case count here depends on whether the carrier admits *ṛṇa* is the
-- same phenomenon that makes the *Mukhtaṣar* enumerate six types.
--
-- WHAT IS NOT CLAIMED.  Nothing in al-Khwārizmī, al-Karajī, al-Samawʾal,
-- Āryabhaṭa or Brahmagupta states any theorem in this file.  The scheduling
-- objective below is from this repository, not from any of those texts.
--
-- OBJECT.  `machinery/center_order_latency.py` (read only; Python is banned
-- here) scores the 3! = 6 orders in which a valuation centre may visit three
-- children sitting at coordinates 0, 1, 2, starting from 0, under a
-- query-plus-λ·motion objective, and carries beside the 6-fold enumeration a
-- 4-term closed expression `ternary_envelope` asserted to equal its minimum.
-- No hypothesis is recorded there.  This module transcribes the query and
-- motion tables from that file's `local_costs` at p = 3 — the transcription
-- is a hypothesis of this module, not a theorem of it — and settles exactly
-- when the 4-term expression may replace the 6-fold enumeration.
--
-- RESULT.
--   1. `muqabala`: one balancing lemma.  Applied twice it isolates the
--      difference between each discarded ordering and its survivor as a
--      SINGLE term, and that term is the same in both: y · (λ·2), where y is
--      the mass of the middle child.  Exact equation, no order used.
--   2. Over ℤ the four-term family and the six-term family have the same
--      lower bounds — hence the same minimum wherever one exists — as soon
--      as y is a possession.  The masses x and z are unrestricted ℤ: they
--      occur in neither defect.
--   3. `envelope-lower-bounds-all-fails-over-ℤ` refutes the same statement
--      with the hypothesis on y dropped.  Witness (x,y,z,λ) = (1,−1,1,1):
--      the four-term expression reports 2, the six-fold enumeration reports 0.
--   4. Over ℕ the hypothesis is free, and the collapse 6 → 4 is
--      unconditional.  The carrier without debts hides the side condition
--      rather than discharging it.

module AlMuqabala_TheSixOrderingsCollapseToFourExactlyWhenOneMassIsNotADebt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties using (+-comm ; snotz)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-trans)
open import Cubical.Data.Sigma using (Σ ; Σ-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Tactics.NatSolver.Reflection using (solve)

import Cubical.Data.Int as Int
open Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Int.Properties
  using (pos+ ; pos·pos ; injPos ; +Assoc ; +Comm ; ·DistR+)

------------------------------------------------------------------------
-- The walk.  Children 0, 1, 2 sit at those coordinates; the centre starts
-- at 0 and visits them in some order.  `local_costs` at p = 3 charges the
-- first child visited one query and each later child two, and charges each
-- child the length of the walk from 0 up to the moment it is reached.
------------------------------------------------------------------------

dist : ℕ → ℕ → ℕ
dist zero n = n
dist (suc m) zero = suc m
dist (suc m) (suc n) = dist m n

-- Weight borne by a child reached after travelling `motion`, charged `q`
-- queries.  Written λ·motion + q rather than q + λ·motion so that the ℕ
-- normal form keeps `_+_` visible to the solver instead of collapsing to
-- `suc`; the value is the same.

costOf : (lam ma mb mc a b c : ℕ) → ℕ
costOf lam ma mb mc a b c =
    ma · (lam · a + 1)
  + mb · (lam · (a + dist a b) + 2)
  + mc · (lam · (a + dist a b + dist b c) + 2)

data Perm3 : Type where
  o012 o021 o102 o120 o201 o210 : Perm3

-- The three mass arguments are supplied in VISIT order; the three label
-- arguments give the coordinates in visit order.  The permutation is
-- exactly this pairing, written out, so it can be audited against
-- `permutations(range(3))` in the source file.

cost : (x y z lam : ℕ) → Perm3 → ℕ
cost x y z lam o012 = costOf lam x y z 0 1 2
cost x y z lam o021 = costOf lam x z y 0 2 1
cost x y z lam o102 = costOf lam y x z 1 0 2
cost x y z lam o120 = costOf lam y z x 1 2 0
cost x y z lam o201 = costOf lam z x y 2 0 1
cost x y z lam o210 = costOf lam z y x 2 1 0

------------------------------------------------------------------------
-- Transcription audit.  `costOf` is a walk; `ternary_envelope` is a list of
-- coefficient expressions.  These six equations split each ordering's cost
-- into its query part and its motion part with explicit coefficients, so
-- the walk and the source file's expressions can be compared line by line
-- instead of trusted.  Under the source file's normalisation x+y+z=1 the
-- query parts read 2−x, 2−y, 2−z, and the motion parts are, in order, the
-- three candidates of `ternary_envelope` together with the two arms of its
-- inner `min` -- and the two orderings the closed expression never names.
------------------------------------------------------------------------

audit-o012 : (x y z lam : ℕ)   -- candidate 1;      s = y + 2z
           → cost x y z lam o012 ≡ (x · 1 + y · 2 + z · 2) + lam · (y · 1 + z · 2)
audit-o012 = solve

audit-o102 : (x y z lam : ℕ)   -- candidate 2, arm 1; s = 2x + y + 4z
           → cost x y z lam o102 ≡ (x · 2 + y · 1 + z · 2) + lam · (x · 2 + y · 1 + z · 4)
audit-o102 = solve

audit-o120 : (x y z lam : ℕ)   -- candidate 2, arm 2; s = 4x + y + 2z
           → cost x y z lam o120 ≡ (x · 2 + y · 1 + z · 2) + lam · (x · 4 + y · 1 + z · 2)
audit-o120 = solve

audit-o210 : (x y z lam : ℕ)   -- candidate 3;      s = 4x + 3y + 2z
           → cost x y z lam o210 ≡ (x · 2 + y · 2 + z · 1) + lam · (x · 4 + y · 3 + z · 2)
audit-o210 = solve

audit-o021 : (x y z lam : ℕ)   -- discarded; same query part as candidate 1
           → cost x y z lam o021 ≡ (x · 1 + y · 2 + z · 2) + lam · (y · 3 + z · 2)
audit-o021 = solve

audit-o201 : (x y z lam : ℕ)   -- discarded; same query part as candidate 3
           → cost x y z lam o201 ≡ (x · 2 + y · 2 + z · 1) + lam · (x · 4 + y · 5 + z · 2)
audit-o201 = solve

------------------------------------------------------------------------
-- Over ℕ: the two defects, and they are the same defect.
------------------------------------------------------------------------

defectN-021 : (x y z lam : ℕ)
            → cost x y z lam o021 ≡ cost x y z lam o012 + y · (lam · 2)
defectN-021 = solve

defectN-201 : (x y z lam : ℕ)
            → cost x y z lam o201 ≡ cost x y z lam o210 + y · (lam · 2)
defectN-201 = solve

-- Over ℕ every defect is a possession, so both discarded orderings are
-- dominated with no side condition available to state.

dominatesN-021 : (x y z lam : ℕ)
               → cost x y z lam o012 ≤ cost x y z lam o021
dominatesN-021 x y z lam =
  y · (lam · 2) ,
  +-comm (y · (lam · 2)) (cost x y z lam o012) ∙ sym (defectN-021 x y z lam)

dominatesN-201 : (x y z lam : ℕ)
               → cost x y z lam o210 ≤ cost x y z lam o201
dominatesN-201 x y z lam =
  y · (lam · 2) ,
  +-comm (y · (lam · 2)) (cost x y z lam o210) ∙ sym (defectN-201 x y z lam)

envelopeN-lower-bounds-all
  : (x y z lam t : ℕ)
  → t ≤ cost x y z lam o012 → t ≤ cost x y z lam o102
  → t ≤ cost x y z lam o120 → t ≤ cost x y z lam o210
  → (s : Perm3) → t ≤ cost x y z lam s
envelopeN-lower-bounds-all x y z lam t h₀ _ _ _ o012 = h₀
envelopeN-lower-bounds-all x y z lam t h₀ _ _ _ o021 =
  ≤-trans h₀ (dominatesN-021 x y z lam)
envelopeN-lower-bounds-all x y z lam t _ h₁ _ _ o102 = h₁
envelopeN-lower-bounds-all x y z lam t _ _ h₂ _ o120 = h₂
envelopeN-lower-bounds-all x y z lam t _ _ _ h₃ o201 =
  ≤-trans h₃ (dominatesN-201 x y z lam)
envelopeN-lower-bounds-all x y z lam t _ _ _ h₃ o210 = h₃

------------------------------------------------------------------------
-- The same object over Brahmagupta's carrier: a mass may be *ṛṇa*.
------------------------------------------------------------------------

infix 4 _≤ᶻ_

_≤ᶻ_ : ℤ → ℤ → Type
a ≤ᶻ b = Σ[ k ∈ ℕ ] (a Int.+ pos k) ≡ b

≤ᶻ-trans : {a b c : ℤ} → a ≤ᶻ b → b ≤ᶻ c → a ≤ᶻ c
≤ᶻ-trans {a} (k , p) (l , q) =
  k + l ,
    cong (a Int.+_) (pos+ k l)
  ∙ +Assoc a (pos k) (pos l)
  ∙ cong (Int._+ pos l) p
  ∙ q

costOfZ : (lam : ℕ) (ma mb mc : ℤ) (a b c : ℕ) → ℤ
costOfZ lam ma mb mc a b c =
        ma Int.· pos (lam · a + 1)
  Int.+ mb Int.· pos (lam · (a + dist a b) + 2)
  Int.+ mc Int.· pos (lam · (a + dist a b + dist b c) + 2)

costZ : (x y z : ℤ) (lam : ℕ) → Perm3 → ℤ
costZ x y z lam o012 = costOfZ lam x y z 0 1 2
costZ x y z lam o021 = costOfZ lam x z y 0 2 1
costZ x y z lam o102 = costOfZ lam y x z 1 0 2
costZ x y z lam o120 = costOfZ lam y z x 1 2 0
costZ x y z lam o201 = costOfZ lam z x y 2 0 1
costZ x y z lam o210 = costOfZ lam z y x 2 1 0

-- The ℤ presentation is the ℕ one when no mass is a debt.

posLinear : (ma mb mc w₀ w₁ w₂ : ℕ)
          → (pos ma Int.· pos w₀ Int.+ pos mb Int.· pos w₁)
              Int.+ pos mc Int.· pos w₂
            ≡ pos (ma · w₀ + mb · w₁ + mc · w₂)
posLinear ma mb mc w₀ w₁ w₂ =
    cong₂ Int._+_
      (cong₂ Int._+_ (sym (pos·pos ma w₀)) (sym (pos·pos mb w₁)))
      (sym (pos·pos mc w₂))
  ∙ cong (Int._+ pos (mc · w₂)) (sym (pos+ (ma · w₀) (mb · w₁)))
  ∙ sym (pos+ (ma · w₀ + mb · w₁) (mc · w₂))

costZ-pos : (x y z lam : ℕ) (s : Perm3)
          → costZ (pos x) (pos y) (pos z) lam s ≡ pos (cost x y z lam s)
costZ-pos x y z lam o012 = posLinear x y z _ _ _
costZ-pos x y z lam o021 = posLinear x z y _ _ _
costZ-pos x y z lam o102 = posLinear y x z _ _ _
costZ-pos x y z lam o120 = posLinear y z x _ _ _
costZ-pos x y z lam o201 = posLinear z x y _ _ _
costZ-pos x y z lam o210 = posLinear z y x _ _ _

------------------------------------------------------------------------
-- al-muqābala.  One balancing lemma; the two defects are its instances.
--
-- Read it as the operation: two sums differ in exactly one summand, whose
-- weight on the left splits as (weight on the right) + (residue).  Split
-- it, distribute, and what remains beside the survivor is a single term.
------------------------------------------------------------------------

rearrange : (X Z Y D : ℤ)
          → (X Int.+ Z) Int.+ (Y Int.+ D)
            ≡ ((X Int.+ Y) Int.+ Z) Int.+ D
rearrange X Z Y D =
    +Assoc (X Int.+ Z) Y D
  ∙ cong (Int._+ D) (sym (+Assoc X Z Y))
  ∙ cong (λ w → (X Int.+ w) Int.+ D) (+Comm Z Y)
  ∙ cong (Int._+ D) (+Assoc X Y Z)

muqabala : (X Z m : ℤ) (p q r : ℕ) → p ≡ q + r
         → (X Int.+ Z) Int.+ m Int.· pos p
           ≡ ((X Int.+ m Int.· pos q) Int.+ Z) Int.+ m Int.· pos r
muqabala X Z m p q r split =
    cong (λ w → (X Int.+ Z) Int.+ m Int.· pos w) split
  ∙ cong (λ w → (X Int.+ Z) Int.+ m Int.· w) (pos+ q r)
  ∙ cong ((X Int.+ Z) Int.+_) (·DistR+ m (pos q) (pos r))
  ∙ rearrange X Z (m Int.· pos q) (m Int.· pos r)

split-021 : (lam : ℕ) → lam · 3 + 2 ≡ (lam · 1 + 2) + lam · 2
split-021 = solve

split-201 : (lam : ℕ) → lam · 5 + 2 ≡ (lam · 3 + 2) + lam · 2
split-201 = solve

defectZ-021 : (x y z : ℤ) (lam : ℕ)
            → costZ x y z lam o021
              ≡ costZ x y z lam o012 Int.+ y Int.· pos (lam · 2)
defectZ-021 x y z lam =
  muqabala (x Int.· pos (lam · 0 + 1)) (z Int.· pos (lam · 2 + 2)) y
           (lam · 3 + 2) (lam · 1 + 2) (lam · 2) (split-021 lam)

defectZ-201 : (x y z : ℤ) (lam : ℕ)
            → costZ x y z lam o201
              ≡ costZ x y z lam o210 Int.+ y Int.· pos (lam · 2)
defectZ-201 x y z lam =
  muqabala (z Int.· pos (lam · 2 + 1)) (x Int.· pos (lam · 4 + 2)) y
           (lam · 5 + 2) (lam · 3 + 2) (lam · 2) (split-201 lam)

------------------------------------------------------------------------
-- The sign condition, and it lands on ONE coordinate.
-- x and z are arbitrary integers below; only y is required not to be *ṛṇa*.
------------------------------------------------------------------------

dominatesZ-021 : (x z : ℤ) (n lam : ℕ)
               → costZ x (pos n) z lam o012 ≤ᶻ costZ x (pos n) z lam o021
dominatesZ-021 x z n lam =
  n · (lam · 2) ,
    cong (costZ x (pos n) z lam o012 Int.+_) (pos·pos n (lam · 2))
  ∙ sym (defectZ-021 x (pos n) z lam)

dominatesZ-201 : (x z : ℤ) (n lam : ℕ)
               → costZ x (pos n) z lam o210 ≤ᶻ costZ x (pos n) z lam o201
dominatesZ-201 x z n lam =
  n · (lam · 2) ,
    cong (costZ x (pos n) z lam o210 Int.+_) (pos·pos n (lam · 2))
  ∙ sym (defectZ-201 x (pos n) z lam)

-- The four-term family and the six-term family have the same lower bounds,
-- hence the same minimum wherever one exists.  This is the closed
-- expression `ternary_envelope` earning its place, with its hypothesis.

envelopeZ-lower-bounds-all
  : (x z : ℤ) (n lam : ℕ) (t : ℤ)
  → t ≤ᶻ costZ x (pos n) z lam o012 → t ≤ᶻ costZ x (pos n) z lam o102
  → t ≤ᶻ costZ x (pos n) z lam o120 → t ≤ᶻ costZ x (pos n) z lam o210
  → (s : Perm3) → t ≤ᶻ costZ x (pos n) z lam s
envelopeZ-lower-bounds-all x z n lam t h₀ _ _ _ o012 = h₀
envelopeZ-lower-bounds-all x z n lam t h₀ _ _ _ o021 =
  ≤ᶻ-trans h₀ (dominatesZ-021 x z n lam)
envelopeZ-lower-bounds-all x z n lam t _ h₁ _ _ o102 = h₁
envelopeZ-lower-bounds-all x z n lam t _ _ h₂ _ o120 = h₂
envelopeZ-lower-bounds-all x z n lam t _ _ _ h₃ o201 =
  ≤ᶻ-trans h₃ (dominatesZ-201 x z n lam)
envelopeZ-lower-bounds-all x z n lam t _ _ _ h₃ o210 = h₃

------------------------------------------------------------------------
-- The refutation.  Drop the hypothesis on y and the statement is false.
--
-- I formed the claim that the collapse 6 → 4 is a ring identity in
-- (x,y,z,λ) and therefore needs no hypothesis at all, because `muqabala`
-- delivers an EQUATION and equations look unconditional.  The equation is
-- indeed unconditional -- `defectZ-021` and `defectZ-201` above hold for
-- every integer y.  The DOMINATION is not.  Witness below.
--
--   (x, y, z, λ) = (1, −1, 1, 1), and the six costs are
--     o012 = 2   o021 = 0   o102 = 8   o120 = 8   o201 = 2   o210 = 4.
--   The four kept by `ternary_envelope` are {2, 8, 8, 4}, minimum 2.
--   The enumeration's minimum is 0, attained at the ordering the closed
--   expression discards.  So 2 is a lower bound for the four and is not a
--   lower bound for the six.
------------------------------------------------------------------------

notBelowZero : ¬ (pos 2 ≤ᶻ pos 0)
notBelowZero (k , p) = snotz (injPos (pos+ 2 k ∙ p))

-- The six values, so the witness is readable and not merely accepted.

value-o012 : costZ (pos 1) (negsuc 0) (pos 1) 1 o012 ≡ pos 2
value-o012 = refl

value-o021 : costZ (pos 1) (negsuc 0) (pos 1) 1 o021 ≡ pos 0
value-o021 = refl

value-o102 : costZ (pos 1) (negsuc 0) (pos 1) 1 o102 ≡ pos 8
value-o102 = refl

value-o120 : costZ (pos 1) (negsuc 0) (pos 1) 1 o120 ≡ pos 8
value-o120 = refl

value-o201 : costZ (pos 1) (negsuc 0) (pos 1) 1 o201 ≡ pos 2
value-o201 = refl

value-o210 : costZ (pos 1) (negsuc 0) (pos 1) 1 o210 ≡ pos 4
value-o210 = refl

envelope-lower-bounds-all-fails-over-ℤ
  : ¬ ((x y z : ℤ) (lam : ℕ) (t : ℤ)
       → t ≤ᶻ costZ x y z lam o012 → t ≤ᶻ costZ x y z lam o102
       → t ≤ᶻ costZ x y z lam o120 → t ≤ᶻ costZ x y z lam o210
       → (s : Perm3) → t ≤ᶻ costZ x y z lam s)
envelope-lower-bounds-all-fails-over-ℤ h =
  notBelowZero
    (h (pos 1) (negsuc 0) (pos 1) 1 (pos 2)
       (0 , refl) (6 , refl) (6 , refl) (2 , refl) o021)

------------------------------------------------------------------------
-- Reading, recorded here because it is the reason the module exists.
--
-- Two accounts of this object disagree on how many cases there are.
--
--   Enumerate the whole space first (Piṅgala's *prastāra*, laid out by a
--   recursive rule before anything in it is counted): six orderings, and
--   the answer is a minimum over six.  Nothing is discarded, so nothing
--   needs a hypothesis.
--
--   Describe the individual optimum as shortly as possible (Kolmogorov):
--   four terms, since two orderings are dominated.  `ternary_envelope` is
--   this account.
--
-- The four-term description is not shorter.  It is the six-term
-- enumeration plus the side condition `y ≥ 0`, and the side condition is
-- the part that was dropped: it appears nowhere in the source file.  Over ℕ
-- the condition is free, so the compression looks unconditional -- which is
-- exactly the position al-Khwārizmī works from, and there the same
-- dependence on the carrier runs the other way: with no *ṛṇa* available the
-- *Mukhtaṣar* must state six types where a signed carrier states one.  Same
-- dependence, opposite direction.  The count of cases is a fact about the
-- carrier, not about the combinatorics.
------------------------------------------------------------------------
