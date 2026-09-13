{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कालद्रव्यम् — time as substance.  Umāsvāti, *Tattvārthasūtra* 5.38–39
-- (c. 2nd–5th c. CE): कालश्च — time too is a dravya, a substance among
-- the six, not a shadow cast by change.  School: Jaina.  Claimed of
-- the source: the name and the ontological move — time admitted as a
-- first-class object — nothing else.
--
-- WHAT THIS IS.  The machine as a model of computation closes over its
-- own cost.  The running time of every operator in the vocabulary is
-- expressible IN the vocabulary (unary arithmetic's recursion depths
-- are +, ∸, max, min = (a+b)∸max(a,b), all present), so TIME IS A
-- TERM: a translation कालः : Tm → Tm sends every program to a term
-- whose VALUE is its running time.  No second semantics, no new
-- prover: cost equations are equations, proved by the same one knowing
-- with the same certificates, refuted by the same exhibited
-- environments.  Correctness and efficiency — computer science's
-- founding distinction — become two questions in one tongue, and the
-- machine can hold them apart: x+y = y+x is a theorem of value and a
-- REFUTED claim of time (unary + recurses on its left argument), both
-- kernel-checked below.
--
-- THE COST MODEL, stated as design (the translation IS the
-- definition; what is honest or not is these clauses):
--   var, 0        cost 1 (a lookup, a constant)
--   su t          1 + cost t
--   a ⊕ b         cost a + cost b + a + 1          (+ recurses on left)
--   a ⊗ b         cost a + cost b + a·b + a + 1    (a additions of b)
--   a ⊖ b         cost a + cost b + min(a,b) + 1   (lockstep descent)
--   mx a b        cost a + cost b + min(a,b) + 1   (lockstep descent)
--   lq a b        cost a + cost b + min(a,b) + 1   (lockstep descent)
--   gc a b        cost a + cost b + (a+b) + 1      (the fuel BUDGET —
--                 an upper bound, stated as such, not the exact trace)
-- min(a,b) is written (a+b) ∸ max(a,b).
------------------------------------------------------------------------

module KalaDravya_TimeIsASubstanceInTheSameTongueAndTheMachineProvesCostAsItProvesTruth where

open import Agda.Builtin.Nat using (Nat ; zero ; suc ; _+_)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (_,_)
open import Agda.Builtin.Equality using (_≡_ ; refl)
open import Agda.Builtin.Unit using (⊤ ; tt)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq ; gc ; Eq' ; eval ; norm)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (नियमः ; गूढ-दृक् ; संयुक्त-यन्त्रम् ; पूर्ण-प्रमाणम् ; प्राणः ; इन्धनम् ; inJust ; fromJust ; ⊨_)

------------------------------------------------------------------------
-- §1  Small term abbreviations for the clock.
------------------------------------------------------------------------

एकः : Tm
एकः = su ze

लघु : Tm → Tm → Tm            -- min, in the vocabulary
लघु a b = (a ⊕ b) ⊖ mx a b

------------------------------------------------------------------------
-- §2  Time, as a term of the same tongue.
------------------------------------------------------------------------

कालः : Tm → Tm
कालः (var i)  = एकः
कालः ze       = एकः
कालः (su t)   = su (कालः t)
कालः (a ⊕ b)  = ((कालः a ⊕ कालः b) ⊕ a) ⊕ एकः
कालः (a ⊗ b)  = ((कालः a ⊕ कालः b) ⊕ ((a ⊗ b) ⊕ a)) ⊕ एकः
कालः (a ⊖ b)  = ((कालः a ⊕ कालः b) ⊕ लघु a b) ⊕ एकः
कालः (mx a b) = ((कालः a ⊕ कालः b) ⊕ लघु a b) ⊕ एकः
कालः (lq a b) = ((कालः a ⊕ कालः b) ⊕ लघु a b) ⊕ एकः
कालः (gc a b) = ((कालः a ⊕ कालः b) ⊕ (a ⊕ b)) ⊕ एकः

-- the clock reads a program at an input: a number, in the same model
कालम् : Tm → (Nat → Nat) → Nat
कालम् t ρ = eval (कालः t) ρ

------------------------------------------------------------------------
-- §3  Value and time come apart, and the machine holds both.
--     x+y = y+x is a theorem of VALUE; of TIME it is false, and the
--     refutation is an exhibited environment, kernel-computed.
------------------------------------------------------------------------

x y : Tm
x = var 0
y = var 1

ρ₀ : Nat → Nat                 -- x ↦ 0, y ↦ 3
ρ₀ zero = 0
ρ₀ _    = 3

-- same value at ρ₀ …
मूल्य-समम् : eval (x ⊕ y) ρ₀ ≡ eval (y ⊕ x) ρ₀
मूल्य-समम् = refl

-- … different time at ρ₀: computing 0+3 costs 3, computing 3+0 costs 6
काल-वामम् : कालम् (x ⊕ y) ρ₀ ≡ 3
काल-वामम् = refl

काल-दक्षिणम् : कालम् (y ⊕ x) ρ₀ ≡ 6
काल-दक्षिणम् = refl

------------------------------------------------------------------------
-- §4  The eye is an optimizer, and the machine PROVES the saving.
--     (x + 0) + 0 evaluates as x — and norm says so — while the raw
--     term pays for both additions.  The clock certifies the speedup.
------------------------------------------------------------------------

स्थूलम् : Tm                   -- the naive program
स्थूलम् = (x ⊕ ze) ⊕ ze

सूक्ष्मम् : Tm                 -- the eye's optimization of it
सूक्ष्मम् = norm स्थूलम्

दृक्-लाघवम् : सूक्ष्मम् ≡ x    -- the optimizer's output, read off
दृक्-लाघवम् = refl

ρ₁ : Nat → Nat
ρ₁ _ = 5

-- the optimization is semantically free … (same value)
मूल्य-रक्षा : eval स्थूलम् ρ₁ ≡ eval सूक्ष्मम् ρ₁
मूल्य-रक्षा = refl

-- … and temporally real: 15 ticks against 1, certified
स्थूल-कालः : कालम् स्थूलम् ρ₁ ≡ 15
स्थूल-कालः = refl

सूक्ष्म-कालः : कालम् सूक्ष्मम् ρ₁ ≡ 1
सूक्ष्म-कालः = refl

------------------------------------------------------------------------
-- §5  Cost claims are ordinary claims: the one prover proves a LAW OF
--     TIME over every environment — the clock of x+y never exceeds
--     the clock of y+x by more than… no: here, the exact law relating
--     the two clocks, minted through the same gate as every value law:
--     कालः(x⊕y) and कालः(y⊕x) differ by exactly (x, y) exchanged, and
--     le(काल(x⊕y), काल(y⊕x)) is NOT constant — but the SYMMETRIC claim
--     काल(x⊕y) ⊕ y  =  काल(y⊕x) ⊕ x  holds over EVERY environment,
--     and the machine proves it for itself, certificate minted:
------------------------------------------------------------------------

काल-विनिमय-सिद्धिः : ⊨ ( कालः (x ⊕ y) ⊕ y , कालः (y ⊕ x) ⊕ x )
काल-विनिमय-सिद्धिः =
  fromJust (पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् [] इन्धनम्
    ( कालः (x ⊕ y) ⊕ y , कालः (y ⊕ x) ⊕ x )) tt

------------------------------------------------------------------------
-- §6  लाघवम् — economy (the Pāṇinian criterion; the grammarians'
--     maxim that brevity is worth half a grandson is tradition's own
--     joke about how much it matters).  The ledger over the whole
--     inheritance measured the eyes optimizing for SIGHT, not time
--     (the heap eye's canonical forms cost MORE: 860 raw against 1231
--     canonicalized, at ρ(i)=i+2).  Canonical is not cheap — two
--     objectives, now held apart.  So the time-organ: among
--     certified-equal forms, take the one the clock prefers.  Sound
--     whichever way the comparison falls, because both candidates
--     already carry eval-preservation.
------------------------------------------------------------------------

open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (दृक् ; दृक्पातः ; दृक्पात-सत्यम् ; norm-sound ; _≤?_ ; if_then_else_ ; _∙_ ; sym)

σ₁ σ₂ : Nat → Nat
σ₁ i = suc i
σ₂ zero = 3 ; σ₂ (suc zero) = 1 ; σ₂ _ = 4

घटिका : Tm → Nat               -- the clock at the two probe inputs
घटिका t = कालम् t σ₁ + कालम् t σ₂

लाघव-नयनम् : Tm → Tm
लाघव-नयनम् t =
  if घटिका (दृक्पातः t) ≤? घटिका (norm t)
  then (if घटिका (दृक्पातः t) ≤? घटिका t then दृक्पातः t else t)
  else (if घटिका (norm t) ≤? घटिका t then norm t else t)

लाघव-सत्यम् : (t : Tm) (ρ : Nat → Nat) → eval (लाघव-नयनम् t) ρ ≡ eval t ρ
लाघव-सत्यम् t ρ with घटिका (दृक्पातः t) ≤? घटिका (norm t)
लाघव-सत्यम् t ρ | true  with घटिका (दृक्पातः t) ≤? घटिका t
लाघव-सत्यम् t ρ | true  | true  = दृक्पात-सत्यम् t ρ
लाघव-सत्यम् t ρ | true  | false = refl
लाघव-सत्यम् t ρ | false with घटिका (norm t) ≤? घटिका t
लाघव-सत्यम् t ρ | false | true  = norm-sound t ρ
लाघव-सत्यम् t ρ | false | false = refl

लाघव-दृक् : दृक्
लाघव-दृक् = लाघव-नयनम् , लाघव-सत्यम्
