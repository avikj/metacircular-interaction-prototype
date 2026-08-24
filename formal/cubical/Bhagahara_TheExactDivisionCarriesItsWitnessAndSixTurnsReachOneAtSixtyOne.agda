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
-- भागहारः — हरः स्वं साक्षिणं वहति, षड्भिश्च वलयैः एकत्वम् ।
--
-- (the exact division carries its own witness; and six turns of the
--  wheel, at प्रकृति ६१, reach क्षेप one.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT WAS MISSING, NAMED EXACTLY, AND WHAT IS NOW HERE.
--
-- Two modules in this repository refuse, in identical words, to call
-- anything "the चक्रवाल", and both name the SAME missing ingredient:
--
--   `punaragamana/…/Bhavana_TheKsepaIsDeterminedByTheRootsAnd…`:
--     "It requires choosing m with k ∣ (a + b·m), and then dividing the
--      composed row through by k — exact division in ℤ, which needs a
--      divisibility witness carried alongside and is not done here."
--   `Vargaprakrtitantu_ThePellFibreIsInfinite…`:
--     "the cyclic step needs a chosen m with k ∣ (a + b·m) and an exact
--      division carrying its divisibility witness, and none of that is
--      done."
--   `Cakravala.agda` says the same in Sanskrit; `CakravalaDescent.agda`
--     supplies the step's identity over an arbitrary CommRing but takes
--     the three divisions as HYPOTHESES IN MULTIPLIED FORM, so no
--     division is ever performed there either.
--
-- That refusal was correct and the gap it names is one object.  §२ builds
-- it: `भागहारः j n` is the exact division of n by (suc j), presented as a
-- CARRIER — base = the pair (dividend, divisor), carried = the लब्धि
-- (quotient), witness = n ≡ suc j · लब्धि.  §२ proves the carried datum is
-- DETERMINED (`भागहार-एकः` : the type is a proposition), which is what
-- makes carrying it free.
--
-- AND THE DISTINCTION THAT MATTERS, which the क्षेप case hides.  For the
-- क्षेप the fibre is `singl` — contractible — because the roots determine
-- it TOTALLY: every pair has a क्षेप.  For the भागहार the fibre is a
-- proposition and NOT in general inhabited: division by k is PARTIAL, and
-- the inhabitant is exactly the divisibility.  So the missing ingredient
-- is not "a carried datum" in the same sense at all; it is the one place
-- in this whole construction where something must be SUPPLIED rather than
-- computed, and Bhāskara's choice of m is what supplies it.  Contractible
-- vs. merely propositional is the whole difference between the भावना
-- (free) and the चक्रवाल (not free).
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED HERE.
--
--   §३ `पद-प्रमाणम्` — THE TURN.  Given a row a² − D b² = ±K with K = suc j,
--     an m, a witness that m² − D = ±E, and the THREE exact divisions
--     K ∣ (a·m + D·b), K ∣ (a + b·m), K ∣ E, the new row (A , B) satisfies
--     A² − D B² = ±K' with the sign the product of the two.  All four sign
--     combinations, no case swept.  This is the step both modules refused
--     to claim.
--   §४ `पदम्` — the same as a total function on rows.  Total: once the
--     three भागहार are in hand there is no further obligation.
--   §५ THE RUN AT D = 61, Bhāskara's own example.  Six turns from (8,1,+3)
--     to (29718, 3805, −1), every divisibility witness discharged by
--     `refl` in the kernel — the divisions are PERFORMED, not assumed.
--   §६ `भावना-द्विगुण-ऋण` — Brahmagupta's composition of a k = −1 row with
--     itself, giving k = +1, and hence
--
--        1766319049² − 61 · 226153980² = 1.
--
--     Which is Bhāskara's answer, and the case the naive भावना orbit
--     inside the k=1 fibre cannot reach, because at D = 61 there is no
--     small k=1 row to seed it with.
--
-- WHAT IS *NOT* PROVED, so nobody has to guess.
--
--   * TERMINATION.  Nothing here says the wheel comes round for every D.
--     `CakravalaBound.agda` proves the invariant k² ≤ 4D that termination
--     would be built on; the step from a bounded state space to "the
--     wheel returns to k = ±1" is not taken, there or here.
--   * BHĀSKARA'S CHOICE RULE.  The six m's of §५ are supplied as data.
--     That each is the m his rule selects (minimise |m² − D| subject to
--     the congruence) is NOT checked here — and `CakravalaBound.agda` §७
--     already records that at least one published D = 61 run in this
--     repository gets that attribution wrong.  The turn is sound for ANY
--     m whose three divisions come out exact, which is what §३ states.
--   * EXISTENCE.  Nothing here says a solution exists for a general D.
--   * The three भागहार of §३ are HYPOTHESES of the theorem.  §५ discharges
--     them by computation for the six particular turns; no general
--     decision procedure for them is built.
--
-- SO WHAT MAY THIS BE CALLED.  The चक्रवाल STEP is formalised, and one
-- complete चक्रवाल RUN is executed in the kernel.  The चक्रवाल as an
-- ALGORITHM — a rule that chooses m and provably halts — is not, and this
-- module does not claim it.  The refusals quoted at the top are hereby
-- narrowed, not withdrawn.
--
-- ────────────────────────────────────────────────────────────────────
-- SOURCES.
--
--   BRAHMAGUPTA, ब्राह्मस्फुटसिद्धान्तः, अध्याय १८ (कुट्टकाध्यायः), 628 CE —
--   the भावना (§६ here), with प्रकृति for the multiplier D, ज्येष्ठ for the
--   greater root, कनिष्ठ for the lesser, क्षेप for the interpolator, and
--   धन / ऋण (asset / debt) for the two signs, which is why §१ names the
--   sign type with his two words rather than with a Bool.
--
--   JAYADEVA, c. 950 CE, surviving only inside UDAYADIVĀKARA's सुन्दरी
--   (1073) — the चक्रवाल.
--
--   BHĀSKARA II, बीजगणितम्, 1150 CE — the चक्रवाल in full, and D = 61 as
--   his worked example, with the answer §६ reaches.
--
--   भागहार (divisor / the act of dividing) and लब्धि (the quotient, "what
--   is obtained") are the कुट्टक vocabulary of the same chapter.
--
--   CITATIONS ARE SECOND-HAND AND ARE OWED AT VERSE LEVEL.  The author of
--   this file has not opened these texts.  NOT CLAIMED: that any of the
--   three stated any theorem below, or that the सन्धि of "carrier" with
--   भागहार is theirs.  What IS claimed is checkable: that the quantity
--   a² − D b² is what their algorithms carry beside the pair of roots,
--   and that their step's three divisions are exactly the three
--   hypotheses of §३.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.  ℕ throughout, never ℤ: cubical's ℤ product does
-- not reduce on numerals of this size, and §५ needs numbers up to
-- 3 · 10¹⁸ to actually compute in the kernel.  Signs are therefore
-- carried as धन / ऋण beside a magnitude, and every equation below is
-- subtraction-free.
------------------------------------------------------------------------

module Bhagahara_TheExactDivisionCarriesItsWitnessAndSixTurnsReachOneAtSixtyOne where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; isSetℕ)
open import Cubical.Data.Nat.Properties using (inj-+m ; inj-sm· ; +-assoc)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

------------------------------------------------------------------------
-- १ · धन and ऋण — Brahmagupta's two signs, and the equation split by them.
--
-- वर्गप्रकृतिः D a b धन K   is   a² = D b² + K      (a² − D b² = +K)
-- वर्गप्रकृतिः D a b ऋण K   is   a² + K = D b²      (a² − D b² = −K)
--
-- Both are subtraction-free, which is what lets ℕ state them and what
-- lets the kernel compute them at §५'s magnitudes.
------------------------------------------------------------------------

data चिह्न : Type₀ where
  धन ऋण : चिह्न

संयोग : चिह्न → चिह्न → चिह्न
संयोग धन t = t
संयोग ऋण धन = ऋण
संयोग ऋण ऋण = धन

वर्गप्रकृतिः : ℕ → ℕ → ℕ → चिह्न → ℕ → Type₀
वर्गप्रकृतिः D a b धन K = a · a ≡ D · (b · b) + K
वर्गप्रकृतिः D a b ऋण K = a · a + K ≡ D · (b · b)

-- the interpolator's own row, (m , 1): m² − D = ±E
अन्तरम् : चिह्न → ℕ → ℕ → ℕ → Type₀
अन्तरम् धन D m E = m · m ≡ D + E
अन्तरम् ऋण D m E = m · m + E ≡ D

record पङ्क्तिः (D : ℕ) : Type₀ where
  constructor रूपम्
  field
    ज्येष्ठ  : ℕ
    कनिष्ठ  : ℕ
    चिह्नम्  : चिह्न
    क्षेपः   : ℕ
    प्रमाणम् : वर्गप्रकृतिः D ज्येष्ठ कनिष्ठ चिह्नम् क्षेपः

open पङ्क्तिः public

------------------------------------------------------------------------
-- २ · भागहारः — THE MISSING INGREDIENT, as a carrier.
--
-- Base: the dividend n and the divisor suc j.  Carried: the लब्धि.
-- Witness: n ≡ suc j · लब्धि.  The divisor is written `suc j` and not
-- `k` with a side condition, because a zero divisor is not an omission
-- to be excluded later — it is a divisor that was never one.
--
-- `भागहार-एकः`: the type is a PROPOSITION.  The quotient is determined
-- by the base, so carrying it costs nothing; that is the same statement
-- as `Punaragamana.Carrier`'s contractible fibre, one h-level weaker.
--
-- And it is exactly one h-level weaker, which is the content: the क्षेप's
-- fibre is contractible because every pair HAS a क्षेप, and this one is
-- only propositional because not every n has a quotient.  The inhabitant
-- IS the divisibility.  That is the thing Bhāskara's choice of m buys and
-- the thing no amount of carrying can produce for free.
------------------------------------------------------------------------

record भागहारः (j n : ℕ) : Type₀ where
  constructor हृतम्
  field
    लब्धिः : ℕ                        -- the quotient
    साक्षी  : n ≡ suc j · लब्धिः       -- and the reason it is one

open भागहारः public

-- the carried datum is determined: at most one quotient, always.  That is
-- what makes carrying it free, and it is `Punaragamana.Carrier`'s
-- contractible fibre one h-level weaker — weaker exactly because the
-- division is partial.
भागहार-एकः : (j n : ℕ) → isProp (भागहारः j n)
भागहार-एकः j n (हृतम् q₁ w₁) (हृतम् q₂ w₂) i = हृतम् (p i) (w i)
  where
  p : q₁ ≡ q₂
  p = inj-sm· {m = j} (sym w₁ ∙ w₂)

  w : PathP (λ i → n ≡ suc j · p i) w₁ w₂
  w = isProp→PathP (λ i → isSetℕ n (suc j · p i)) w₁ w₂

------------------------------------------------------------------------
-- ३ · THE TURN'S ARITHMETIC.
--
-- The one identity everything rests on, with NO cancellation and NO
-- division: for all D a b m,
--
--   (a·m + D·b)² + (D·a² + (D·b²)·m²) = D·(a + b·m)² + (a²·m² + D·(D·b²))
--
-- which is the subtraction-free form of Brahmagupta's
--
--   (a·m + D·b)² − D·(a + b·m)² = (a² − D b²)·(m² − D).
--
-- Everything after it is bookkeeping of the two signs and one
-- cancellation of K².
------------------------------------------------------------------------

मूल-समता : (D a b m : ℕ)
  → (a · m + D · b) · (a · m + D · b) + (D · (a · a) + (D · (b · b)) · (m · m))
  ≡ D · ((a + b · m) · (a + b · m)) + ((a · a) · (m · m) + D · (D · (b · b)))
मूल-समता D a b m = solveℕ!

-- the four sign combinations, each a polynomial identity after the two
-- hypotheses have been substituted in.  P stands for D·b², A2 for a²,
-- M2 for m²; each is opaque to the solver, which is why the same four
-- lines carry all of §३.
private
  अङ्क-धनधन : (D P K E : ℕ)
    → (P + K) · (D + E) + D · P ≡ K · E + (D · (P + K) + P · (D + E))
  अङ्क-धनधन D P K E = solveℕ!

  अङ्क-धनऋण : (P K E M2 : ℕ)
    → ((P + K) · M2 + (M2 + E) · P) + K · E ≡ (M2 + E) · (P + K) + P · M2
  अङ्क-धनऋण P K E M2 = solveℕ!

  अङ्क-ऋणधन : (D A2 K E : ℕ)
    → (A2 · (D + E) + D · (A2 + K)) + K · E ≡ D · A2 + (A2 + K) · (D + E)
  अङ्क-ऋणधन D A2 K E = solveℕ!

  अङ्क-ऋणऋण : (A2 M2 K E : ℕ)
    → A2 · M2 + (M2 + E) · (A2 + K) ≡ K · E + ((M2 + E) · A2 + (A2 + K) · M2)
  अङ्क-ऋणऋण A2 M2 K E = solveℕ!

  -- pulling K² out, so that `inj-sm·` can put it back
  सङ्कोच-अ : (K A : ℕ) → (K · A) · (K · A) ≡ K · (K · (A · A))
  सङ्कोच-अ K A = solveℕ!

  सङ्कोच-आ : (K D B K' : ℕ)
           → D · ((K · B) · (K · B)) + K · (K · K') ≡ K · (K · (D · (B · B) + K'))
  सङ्कोच-आ K D B K' = solveℕ!

  सङ्कोच-इ : (K A K' : ℕ)
           → (K · A) · (K · A) + K · (K · K') ≡ K · (K · (A · A + K'))
  सङ्कोच-इ K A K' = solveℕ!

  सङ्कोच-ई : (K D B : ℕ) → D · ((K · B) · (K · B)) ≡ K · (K · (D · (B · B)))
  सङ्कोच-ई K D B = solveℕ!

  पुनर्विन्यास : (वामः Q भारः : ℕ) → (वामः + Q) + भारः ≡ (वामः + भारः) + Q
  पुनर्विन्यास वामः Q भारः = solveℕ!

-- the two shapes the conclusion can take.  `रूप-अ` produces a धन row,
-- `रूप-ब` an ऋण row; the last hypothesis of each is the sign-specific
-- arithmetic, and everything else is shared.
private
  module _ (D j a b m E A B K' : ℕ)
           (hA : a · m + D · b ≡ suc j · A)
           (hB : a + b · m ≡ suc j · B)
           (hE : E ≡ suc j · K')
    where
    private
      K भारः शेषः वामः दक्षिणः : ℕ
      K = suc j
      भारः = D · (a · a) + (D · (b · b)) · (m · m)
      शेषः = (a · a) · (m · m) + D · (D · (b · b))
      वामः = (K · A) · (K · A)
      दक्षिणः = D · ((K · B) · (K · B))

      -- the master identity, with both numerators replaced by K·(quotient)
      स्कन्ध : वामः + भारः ≡ दक्षिणः + शेषः
      स्कन्ध = sym (cong (λ z → z · z + भारः) hA)
             ∙ मूल-समता D a b m
             ∙ cong (λ z → D · (z · z) + शेषः) hB

    रूप-अ : शेषः ≡ K · E + भारः → A · A ≡ D · (B · B) + K'
    रूप-अ अङ्क =
      inj-sm· {m = j} (inj-sm· {m = j}
        (sym (सङ्कोच-अ K A) ∙ सार ∙ सङ्कोच-आ K D B K'))
      where
      सार : वामः ≡ दक्षिणः + K · (K · K')
      सार = inj-+m {m = भारः} (स्कन्ध ∙ cong (दक्षिणः +_) अङ्क ∙ +-assoc दक्षिणः (K · E) भारः)
          ∙ cong (λ z → दक्षिणः + K · z) hE

    रूप-ब : शेषः + K · E ≡ भारः → A · A + K' ≡ D · (B · B)
    रूप-ब अङ्क =
      inj-sm· {m = j} (inj-sm· {m = j}
        (sym (सङ्कोच-इ K A K') ∙ सार ∙ सङ्कोच-ई K D B))
      where
      अर्ध : वामः + K · E ≡ दक्षिणः
      अर्ध = inj-+m {m = भारः} (पुनर्विन्यास वामः (K · E) भारः
                            ∙ cong (_+ K · E) स्कन्ध
                            ∙ sym (+-assoc दक्षिणः शेषः (K · E))
                            ∙ cong (दक्षिणः +_) अङ्क)

      सार : वामः + K · (K · K') ≡ दक्षिणः
      सार = sym (cong (λ z → वामः + K · z) hE) ∙ अर्ध

------------------------------------------------------------------------
-- पद-प्रमाणम् — THE TURN.  All four sign combinations.
--
--   a² − D b² = ±K,   m² − D = ±E,   K ∣ (a·m + D·b),  K ∣ (a + b·m),
--   K ∣ E
--   ⟹  A² − D B² = ±K'   with the sign the product of the two.
--
-- No m-choice rule is used, and none is needed: any m whose three
-- divisions come out exact turns the wheel.  That is a weakening of
-- Bhāskara's rule, and the reader should not read more into it.
------------------------------------------------------------------------

पद-प्रमाणम् : (D j : ℕ) (s t : चिह्न) (a b m E A B K' : ℕ)
  → वर्गप्रकृतिः D a b s (suc j)
  → अन्तरम् t D m E
  → a · m + D · b ≡ suc j · A
  → a + b · m ≡ suc j · B
  → E ≡ suc j · K'
  → वर्गप्रकृतिः D A B (संयोग s t) K'

पद-प्रमाणम् D j धन धन a b m E A B K' ha hm hA hB hE =
  रूप-अ D j a b m E A B K' hA hB hE
    ( cong₂ (λ x y → x · y + D · (D · (b · b))) ha hm
    ∙ अङ्क-धनधन D (D · (b · b)) (suc j) E
    ∙ sym (cong₂ (λ x y → suc j · E + (D · x + (D · (b · b)) · y)) ha hm) )

पद-प्रमाणम् D j धन ऋण a b m E A B K' ha hm hA hB hE =
  रूप-ब D j a b m E A B K' hA hB hE
    ( cong (λ x → (x · (m · m) + D · (D · (b · b))) + suc j · E) ha
    ∙ cong (λ d → ((D · (b · b) + suc j) · (m · m) + d · (D · (b · b))) + suc j · E) (sym hm)
    ∙ अङ्क-धनऋण (D · (b · b)) (suc j) E (m · m)
    ∙ cong (λ d → d · (D · (b · b) + suc j) + (D · (b · b)) · (m · m)) hm
    ∙ cong (λ x → D · x + (D · (b · b)) · (m · m)) (sym ha) )

पद-प्रमाणम् D j ऋण धन a b m E A B K' ha hm hA hB hE =
  रूप-ब D j a b m E A B K' hA hB hE
    ( cong (λ y → ((a · a) · y + D · (D · (b · b))) + suc j · E) hm
    ∙ cong (λ p → ((a · a) · (D + E) + D · p) + suc j · E) (sym ha)
    ∙ अङ्क-ऋणधन D (a · a) (suc j) E
    ∙ cong (λ p → D · (a · a) + p · (D + E)) ha
    ∙ cong (λ y → D · (a · a) + (D · (b · b)) · y) (sym hm) )

पद-प्रमाणम् D j ऋण ऋण a b m E A B K' ha hm hA hB hE =
  रूप-अ D j a b m E A B K' hA hB hE
    ( cong (λ d → (a · a) · (m · m) + d · (D · (b · b))) (sym hm)
    ∙ cong (λ p → (a · a) · (m · m) + (m · m + E) · p) (sym ha)
    ∙ अङ्क-ऋणऋण (a · a) (m · m) (suc j) E
    ∙ cong (λ d → suc j · E + (d · (a · a) + (a · a + suc j) · (m · m))) hm
    ∙ cong (λ p → suc j · E + (D · (a · a) + p · (m · m))) ha )

------------------------------------------------------------------------
-- ४ · पदम् — the turn as a TOTAL function on rows.
--
-- Total, and that is the point.  The three भागहार are the whole of the
-- obligation; once they are in hand nothing else is owed, no side
-- condition survives, and the new row is a row.
------------------------------------------------------------------------

पदम् : (D j : ℕ) (a b : ℕ) (s : चिह्न)
     → वर्गप्रकृतिः D a b s (suc j)
     → (t : चिह्न) (m E : ℕ) → अन्तरम् t D m E
     → (हा : भागहारः j (a · m + D · b))
     → (हब : भागहारः j (a + b · m))
     → (हे : भागहारः j E)
     → पङ्क्तिः D
पदम् D j a b s ha t m E hm हा हब हे =
  रूपम् (लब्धिः हा) (लब्धिः हब) (संयोग s t) (लब्धिः हे)
    (पद-प्रमाणम् D j s t a b m E (लब्धिः हा) (लब्धिः हब) (लब्धिः हे)
      ha hm (साक्षी हा) (साक्षी हब) (साक्षी हे))

------------------------------------------------------------------------
-- ५ · चक्रवालम् at प्रकृति ६१ — BHĀSKARA'S OWN EXAMPLE.
--
-- Six turns.  Every `refl` below is a division actually carried out by
-- the kernel: `भागहारः 2 (8 · 7 + 61 · 1)` is inhabited by `39 , refl`
-- only because 8·7 + 61·1 and 3·39 are the same numeral.
--
-- D = 61 is the case the naive भावना orbit does not reach: there is no
-- small row with क्षेप 1 to seed it, and squaring a row multiplies its
-- क्षेप rather than reducing it.  The wheel gets there by going THROUGH
-- क्षेप 3, 4, 5, 5, 4, 3 and out at 1 — which is what a cycle is for.
------------------------------------------------------------------------

आदि : पङ्क्तिः 61                      -- 8² − 61·1² = 64 − 61 = +3
आदि = रूपम् 8 1 धन 3 refl

वलय-१ : पङ्क्तिः 61                     -- m = 7,  7² − 61 = −12
वलय-१ = पदम् 61 2 8 1 धन (प्रमाणम् आदि) ऋण 7 12 refl
          (हृतम् 39 refl) (हृतम् 5 refl) (हृतम् 4 refl)

वलय-२ : पङ्क्तिः 61                     -- m = 9,  9² − 61 = +20
वलय-२ = पदम् 61 3 39 5 ऋण (प्रमाणम् वलय-१) धन 9 20 refl
          (हृतम् 164 refl) (हृतम् 21 refl) (हृतम् 5 refl)

वलय-३ : पङ्क्तिः 61                     -- m = 6,  6² − 61 = −25
वलय-३ = पदम् 61 4 164 21 ऋण (प्रमाणम् वलय-२) ऋण 6 25 refl
          (हृतम् 453 refl) (हृतम् 58 refl) (हृतम् 5 refl)

वलय-४ : पङ्क्तिः 61                     -- m = 9,  9² − 61 = +20
वलय-४ = पदम् 61 4 453 58 धन (प्रमाणम् वलय-३) धन 9 20 refl
          (हृतम् 1523 refl) (हृतम् 195 refl) (हृतम् 4 refl)

वलय-५ : पङ्क्तिः 61                     -- m = 7,  7² − 61 = −12
वलय-५ = पदम् 61 3 1523 195 धन (प्रमाणम् वलय-४) ऋण 7 12 refl
          (हृतम् 5639 refl) (हृतम् 722 refl) (हृतम् 3 refl)

वलय-६ : पङ्क्तिः 61                     -- m = 8,  8² − 61 = +3
वलय-६ = पदम् 61 2 5639 722 ऋण (प्रमाणम् वलय-५) धन 8 3 refl
          (हृतम् 29718 refl) (हृतम् 3805 refl) (हृतम् 1 refl)

-- the wheel's own reading, turn by turn: (ज्येष्ठ , कनिष्ठ , क्षेप).
-- Each holds by `refl`, so these are the values the kernel computed and
-- not values a comment asserts.
दर्शनम्-१ : Path (ℕ × ℕ × ℕ) (ज्येष्ठ वलय-१ , कनिष्ठ वलय-१ , क्षेपः वलय-१) (39 , 5 , 4)
दर्शनम्-१ = refl

दर्शनम्-२ : Path (ℕ × ℕ × ℕ) (ज्येष्ठ वलय-२ , कनिष्ठ वलय-२ , क्षेपः वलय-२) (164 , 21 , 5)
दर्शनम्-२ = refl

दर्शनम्-३ : Path (ℕ × ℕ × ℕ) (ज्येष्ठ वलय-३ , कनिष्ठ वलय-३ , क्षेपः वलय-३) (453 , 58 , 5)
दर्शनम्-३ = refl

दर्शनम्-४ : Path (ℕ × ℕ × ℕ) (ज्येष्ठ वलय-४ , कनिष्ठ वलय-४ , क्षेपः वलय-४) (1523 , 195 , 4)
दर्शनम्-४ = refl

दर्शनम्-५ : Path (ℕ × ℕ × ℕ) (ज्येष्ठ वलय-५ , कनिष्ठ वलय-५ , क्षेपः वलय-५) (5639 , 722 , 3)
दर्शनम्-५ = refl

दर्शनम्-६ : Path (ℕ × ℕ × ℕ) (ज्येष्ठ वलय-६ , कनिष्ठ वलय-६ , क्षेपः वलय-६) (29718 , 3805 , 1)
दर्शनम्-६ = refl

-- and the sign at the exit is ऋण: 29718² + 1 = 61 · 3805².
चिह्न-६ : चिह्नम् वलय-६ ≡ ऋण
चिह्न-६ = refl

-- the exit row's equation, restated in its own numerals.  This is the
-- theorem of §३ applied six times, not a computation: it is `प्रमाणम्`.
वलय-षष्ठ-समीकरणम् : 29718 · 29718 + 1 ≡ 61 · (3805 · 3805)
वलय-षष्ठ-समीकरणम् = प्रमाणम् वलय-६

------------------------------------------------------------------------
-- ६ · भावना at the exit — Brahmagupta closes what Jayadeva opened.
--
-- The wheel delivers क्षेप −1, not +1.  Composing that row with ITSELF is
-- Brahmagupta's भावना, and the क्षेप multiplies: (−1)·(−1) = +1.  So the
-- last move of the चक्रवाल is 522 years older than the चक्रवाल.
--
--   (a² + D b²)² − D·(2ab)² = (a² − D b²)² = K²
--
-- proved here subtraction-free in the ऋण case, for any K.
------------------------------------------------------------------------

private
  वर्ग-योग : (वामः K : ℕ) → (वामः + (वामः + K)) · (वामः + (वामः + K)) ≡ 4 · (वामः · (वामः + K)) + K · K
  वर्ग-योग वामः K = solveℕ!

  तिर्यक्-समता : (D a b : ℕ)
    → D · ((a · b + a · b) · (a · b + a · b)) ≡ 4 · ((a · a) · (D · (b · b)))
  तिर्यक्-समता D a b = solveℕ!

भावना-द्विगुण-ऋण : (D a b K : ℕ)
  → a · a + K ≡ D · (b · b)
  → (a · a + D · (b · b)) · (a · a + D · (b · b))
  ≡ D · ((a · b + a · b) · (a · b + a · b)) + K · K
भावना-द्विगुण-ऋण D a b K h =
    subst (λ दक्षिणः → (a · a + दक्षिणः) · (a · a + दक्षिणः) ≡ 4 · ((a · a) · दक्षिणः) + K · K)
          h (वर्ग-योग (a · a) K)
  ∙ sym (cong (_+ K · K) (तिर्यक्-समता D a b))

------------------------------------------------------------------------
-- समाधानम् — THE ANSWER.  1766319049² − 61 · 226153980² = 1.
--
-- Bhāskara II's own stated answer to his own stated example.  Here it is
-- the exit row of §५ composed with itself by §६: the numerals
-- 1766319049 = 29718² + 61·3805² and 226153980 = 2·29718·3805 are not
-- written into the proof, they are what the two expressions reduce to.
------------------------------------------------------------------------

समाधानम् : पङ्क्तिः 61
समाधानम् =
  रूपम् 1766319049 226153980 धन 1
    (भावना-द्विगुण-ऋण 61 29718 3805 1 (प्रमाणम् वलय-६))

-- stated in its own numerals, and it is `प्रमाणम् समाधानम्` — derived,
-- not normalised into existence.
वर्गप्रकृति-६१ : 1766319049 · 1766319049 ≡ 61 · (226153980 · 226153980) + 1
वर्गप्रकृति-६१ = प्रमाणम् समाधानम्

दर्शनम्-समाधानम् : Path (ℕ × ℕ × ℕ) (ज्येष्ठ समाधानम् , कनिष्ठ समाधानम् , क्षेपः समाधानम्) (1766319049 , 226153980 , 1)
दर्शनम्-समाधानम् = refl
