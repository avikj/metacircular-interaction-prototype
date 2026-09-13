{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- लीलावती — Bhāskara II's problem-book (1150 CE): mathematics posed as
-- problems to a reader, solved by method, answers checkable.  School
-- and text named; claimed of the source: the genre and its name —
-- problems POSED, then SOLVED — nothing else.
--
-- WHAT THIS IS.  The machine solves posed problems as optimization
-- problems: a problem is a SPEC term (what to compute, over named
-- inputs); the machine searches its vocabulary for programs, admits
-- only candidates it can PROVE equal to the spec (the certificate is
-- the admission ticket — no answer enters on a test-pass), and among
-- the certified it judges by the clock AT RELATIVE SCALES of the
-- inputs (कालम् at growing probe magnitudes — in the unary model the
-- input's value IS its size, so scale-relative cost is literal).
-- Where it can, it additionally PROVES dominance — le(cost answer,
-- cost spec) = 1 over EVERY input, stronger than any asymptotic claim
-- — and where it cannot, the verdict says "measured at scales", syāt,
-- claiming exactly what was earned.
--
-- The search is bounded by the posed spec (candidates no larger than
-- the problem): targeted solving, not a survey.  What stays outside
-- honestly: problems needing loops or arrays — the recursor frontier
-- named in Svarupa.
------------------------------------------------------------------------

module Lilavati_ThePosedProblemIsSolvedAsOptimizationTheAnswerCertifiedAndTheCostJudgedAtScales where

open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.Nat using (Nat ; zero ; suc ; _+_)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (Σ ; _,_ ; fst ; snd)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq ; gc ; Eq' ; eval ; समℕ ; समः ; _∧_)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using ( नियमः ; गूढ-दृक् ; संयुक्त-यन्त्रम् ; पूर्ण-प्रमाणम् ; इन्धनम्
        ; ⊨_ ; _++_ ; _×_ ; if_then_else_ ; _≤?_ ; mmap ; अथवा)
open import KalaDravya_TimeIsASubstanceInTheSameTongueAndTheMachineProvesCostAsItProvesTruth
  using (कालः ; कालम्)

------------------------------------------------------------------------
-- §1  The search space: every program the vocabulary can pose, up to
--     the problem's own size, over its two inputs.
------------------------------------------------------------------------

अणवः : List Tm
अणवः = var 0 ∷ var 1 ∷ ze ∷ []

जोडः : (Tm → Tm → Tm) → List Tm → List Tm → List Tm
जोडः f []       ys = []
जोडः f (x ∷ xs) ys = पङ्क्तिः ys ++ जोडः f xs ys
  where
  पङ्क्तिः : List Tm → List Tm
  पङ्क्तिः []       = []
  पङ्क्तिः (y ∷ ys') = f x y ∷ पङ्क्तिः ys'

विपर्ययः : {A : Type} → List A → List A → List A
विपर्ययः []       acc = acc
विपर्ययः (z ∷ zs) acc = विपर्ययः zs (z ∷ acc)

युगः : {A : Type} {B : Type} → List A → List B → List (A × B)
युगः []       _        = []
युगः (a ∷ as) []       = []
युगः (a ∷ as) (b ∷ bs) = (a , b) ∷ युगः as bs

ऊर्ध्वः : List Tm → List Tm
ऊर्ध्वः []       = []
ऊर्ध्वः (t ∷ ts) = su t ∷ ऊर्ध्वः ts

सर्व-जोडः : List (List Tm × List Tm) → List Tm
सर्व-जोडः [] = []
सर्व-जोडः ((ls , rs) ∷ ps) =
     (जोडः _⊕_ ls rs)
  ++ ((जोडः _⊗_ ls rs)
  ++ ((जोडः _⊖_ ls rs)
  ++ ((जोडः mx  ls rs)
  ++ ((जोडः lq  ls rs)
  ++ ((जोडः gc  ls rs)
  ++ सर्व-जोडः ps)))))

-- the next stratum from the strata so far (most recent first): su
-- lifts the top; binaries pair earlier strata whose sizes sum right
नूतनः : List (List Tm) → List Tm
नूतनः []           = अणवः
नूतनः (top ∷ rest) = ऊर्ध्वः top ++ सर्व-जोडः (युगः rest (विपर्ययः rest []))

स्तराः : Nat → List (List Tm)
स्तराः zero    = []
स्तराः (suc n) = नूतनः (स्तराः n) ∷ स्तराः n

सङ्ग्रहः : List (List Tm) → List Tm
सङ्ग्रहः []       = []
सङ्ग्रहः (l ∷ ls) = l ++ सङ्ग्रहः ls

सर्वे : Nat → List Tm
सर्वे n = सङ्ग्रहः (स्तराः n)

------------------------------------------------------------------------
-- §2  The screen (cheap agreement at probe inputs) and the scales.
------------------------------------------------------------------------

π₁ π₂ π₃ : Nat → Nat
π₁ zero = 2 ; π₁ (suc zero) = 5 ; π₁ _ = 1
π₂ zero = 7 ; π₂ (suc zero) = 3 ; π₂ _ = 0
π₃ zero = 1 ; π₃ (suc zero) = 4 ; π₃ _ = 2

तुल्य-दर्शनम् : Tm → Tm → Bool
तुल्य-दर्शनम् s t =
  समℕ (eval s π₁) (eval t π₁) ∧
  (समℕ (eval s π₂) (eval t π₂) ∧ समℕ (eval s π₃) (eval t π₃))

-- the cost criterion: the clock at three RELATIVE SCALES of the
-- inputs — small, medium, large — summed with the large scale
-- dominant simply because its numbers dominate the sum.
σ-लघु σ-मध्य σ-महा : Nat → Nat
σ-लघु _ = 3
σ-मध्य zero = 20 ; σ-मध्य _ = 15
σ-महा zero = 200 ; σ-महा _ = 150

मानम् : Tm → Nat
मानम् t = कालम् t σ-लघु + (कालम् t σ-मध्य + कालम् t σ-महा)

------------------------------------------------------------------------
-- §3  The solved problem: answer + certificate + cost verdict.
------------------------------------------------------------------------

data वेदना : Type where
  साधितम्  : वेदना        -- dominance PROVEN over every input
  दृष्टम्   : वेदना        -- cheaper at every probe scale, not proven
  तुल्यम्   : वेदना        -- no strictly cheaper certified form found

record समाधानम् (spec : Tm) : Type where
  constructor solved
  field
    उत्तरम्   : Tm
    साक्षी    : ⊨ (spec , उत्तरम्)
    निर्णयः   : वेदना

------------------------------------------------------------------------
-- §4  The solver: admit by proof, judge by the clock, claim by syāt.
------------------------------------------------------------------------

module _ (Γ : List नियमः) where


  ग्रहणम् : (spec : Tm) (cand : Tm) → Maybe (Σ Tm (λ u → ⊨ (spec , u)))
  ग्रहणम् spec cand with तुल्य-दर्शनम् spec cand
  ... | false = nothing
  ... | true  = mmap (λ pf → (cand , pf))
                     (पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् Γ इन्धनम् (spec , cand))

  -- walk the candidates, keep the certified-cheapest
  अन्वेषणम् : (spec : Tm) → List Tm
    → Σ Tm (λ u → ⊨ (spec , u)) → Σ Tm (λ u → ⊨ (spec , u))
  अन्वेषणम् spec []       best = best
  अन्वेषणम् spec (c ∷ cs) best with ग्रहणम् spec c
  ... | nothing = अन्वेषणम् spec cs best
  ... | just (u , pf) =
    if मानम् u ≤? मानम् (fst best)
    then (if मानम् (fst best) ≤? मानम् u
          then अन्वेषणम् spec cs best          -- ties keep the earlier find
          else अन्वेषणम् spec cs (u , pf))
    else अन्वेषणम् spec cs best

  -- dominance, attempted as a THEOREM: le(cost ans, cost spec) = 1
  आधिपत्यम् : (spec ans : Tm) → वेदना
  आधिपत्यम् spec ans with समः spec ans
  ... | true  = तुल्यम्        -- the spec kept itself: no vacuous dominance
  ... | false with पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् Γ इन्धनम्
                    ( lq (कालः ans) (कालः spec) , su ze )
  ...   | just _  = साधितम्
  ...   | nothing =
      if suc (मानम् ans) ≤? मानम् spec then दृष्टम् else तुल्यम्

  छात्रा : (spec : Tm) → ⊨ (spec , spec)   -- the spec solves itself
  छात्रा spec ρ = refl
    where open import Agda.Builtin.Equality using (refl)

  लीला : (माप-सीमा : Nat) (spec : Tm) → समाधानम् spec
  लीला k spec with अन्वेषणम् spec (सर्वे k) (spec , छात्रा spec)
  ... | (ans , pf) = solved ans pf (आधिपत्यम् spec ans)
