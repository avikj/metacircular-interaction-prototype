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
-- नष्टोद्दिष्ट-परीक्षा — उभयदिक् अस्ति चेत् एव तन्तुः सर्वत्र एकः ।
--
-- (both directions exist exactly when every fibre is contractible.)
--
-- ────────────────────────────────────────────────────────────────────
-- मूलवाक्यम् · SOURCE OF THE TERMS, with text and date.
--
--   नष्ट ("the lost one": given a row number, recover the pattern) and
--   उद्दिष्ट ("the pointed-at one": given a pattern, recover its row
--   number) are two of the six प्रत्यय of Piṅgala, *Chandaḥśāstra*
--   ८.२४–२८ (~300 BCE), worked with the array by हलायुध,
--   *Mṛtasañjīvanī* (10th c. CE).  They are stated as a PAIR, and the
--   pair is the point: the प्रस्तार is never written down, because
--   either direction can be run from the other end in log n steps.
--
--   परीक्षा ("examination") is ordinary Sanskrit, standard in the
--   Nyāya lane for the testing of a thesis.  The compound
--   नष्टोद्दिष्ट-परीक्षा is BUILT HERE and is not attested in any text.
--
-- WHAT IS AND IS NOT CLAIMED.  **Piṅgala proved nothing below.**  He
-- states two procedures and asserts they undo one another; he does not
-- state a type, a fibre, an equivalence, or a contractibility.  What is
-- claimed here is a fact about the DEFINITIONS in
-- `NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn.agda` and
-- `Tantujala_…agda`: that the data Piṅgala's pair asks for is exactly
-- the data of `isEquiv`, hence exactly "the fibre is एकम् at every
-- point".  The vocabulary is his; the theorem is this repository's.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS MODULE EXISTS.  `machine/Lopa_…hs` grades every edge in this
-- corpus into two roads — 88 edges with defect identically zero, and
-- 1046 one-way edges.  The discriminant between the two roads was
-- carried in the census as a flag computed by the grader.  It is not a
-- flag.  It is Piṅgala's question, and it is a TYPE:
--
--     is there both a नष्ट and an उद्दिष्ट for this map?
--
-- §२ makes that a checkable predicate (`नष्टोद्दिष्टयोगः`), §३ connects
-- it to `Tantujala`'s three verdicts — an inhabitant is exactly एकम्
-- at every point — and §४ to `isEquiv`, which is that Π by definition.
--
-- §५ is the honest limit, and it is why this is stated as two maps and
-- not as an equivalence of types: `isEquiv f` is a PROPOSITION and
-- `नष्टोद्दिष्टयोगः f` is not, so the two are logically equivalent and
-- NOT equal.  The round trip through `isEquiv` returns what it was
-- given (§५); the round trip through the record is not claimed, and
-- the reason is that quasi-inverse data can differ.
--
-- §६ is the discriminant exhibited on both roads at once: the प्रस्तार
-- of any छेद-सूची carries the witness (road one, defect zero at every
-- index), and `Bool → Unit` provably carries none (road two) — the
-- refutation running through `Tantujala.एक-बहु-विरोधः`, so the two
-- modules are joined by a term and not by a remark.
--
-- §७ separates the two halves of the pair.  Having only the FORWARD
-- round trip (`उद्दिष्टमात्रम्`: every index has some pattern that
-- indexes to it) is strictly weaker, and the witness is the same
-- `Bool → Unit`.  That is what "one-way edge" means, stated as data.
--
-- CHECKED: Agda 2.8.0 + agda/cubical (the installed version), --cubical
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module NastoddistaPariksa_BothDirectionsExistExactlyWhenEveryFibreIsContractible where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (fiber ; isEquiv ; isPropIsEquiv ; equivIsEquiv)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToIsEquiv)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

import Tantujala_TheFibreHasThreeVerdictsAndIsContrMergesTwoOfThem as T

open import NastaUddista_TheRankUnrankAlgebraTheMachineRunsOn
  using (अङ्कस्थान ; सङ्ख्या ; प्रस्तारः ; एकरूप)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- २ · नष्टोद्दिष्टयोगः — the predicate.  "Does this edge have both
--     directions?"  The record's three fields are Piṅgala's two
--     procedures and the statement that they undo one another, in the
--     order he states them.
------------------------------------------------------------------------

record नष्टोद्दिष्टयोगः {A : Type ℓ} {B : Type ℓ'} (f : A → B)
       : Type (ℓ-max ℓ ℓ') where
  constructor उभयतः
  field
    -- नष्टम् — given the index, produce the pattern.
    नष्टम् : B → A
    -- उद्दिष्ट ∘ नष्ट ≡ id : index out, index back.
    उद्दिष्टनष्टम् : (b : B) → f (नष्टम् b) ≡ b
    -- नष्ट ∘ उद्दिष्ट ≡ id : pattern out, pattern back.
    नष्टोद्दिष्टम् : (a : A) → नष्टम् (f a) ≡ a

open नष्टोद्दिष्टयोगः public

-- An `Iso` is this record with the forward map named first; the two
-- carry the same three fields and the translation is a repackaging.
इषो→योगः : {A : Type ℓ} {B : Type ℓ'} (i : Iso A B)
         → नष्टोद्दिष्टयोगः (Iso.fun i)
नष्टम्        (इषो→योगः i) = Iso.inv i
उद्दिष्टनष्टम् (इषो→योगः i) = Iso.rightInv i
नष्टोद्दिष्टम् (इषो→योगः i) = Iso.leftInv i

योगः→इषो : {A : Type ℓ} {B : Type ℓ'} {f : A → B}
         → नष्टोद्दिष्टयोगः f → Iso A B
Iso.fun      (योगः→इषो {f = f} y) = f
Iso.inv      (योगः→इषो y) = नष्टम् y
Iso.rightInv (योगः→इषो y) = उद्दिष्टनष्टम् y
Iso.leftInv  (योगः→इषो y) = नष्टोद्दिष्टम् y

------------------------------------------------------------------------
-- ३ · THE TEST, against the three verdicts.
--
-- `Tantujala` gives रिक्तम् / एकम् / बहु at a point.  The pair of
-- procedures is precisely एकम् EVERYWHERE, and the proof is by way of
-- `isEquiv`, whose definition is that Π.
------------------------------------------------------------------------

परीक्षा→समता : {A : Type ℓ} {B : Type ℓ'} {f : A → B}
             → नष्टोद्दिष्टयोगः f → isEquiv f
परीक्षा→समता {f = f} y = isoToIsEquiv (योगः→इषो y)

समता→परीक्षा : {A : Type ℓ} {B : Type ℓ'} {f : A → B}
             → isEquiv f → नष्टोद्दिष्टयोगः f
नष्टम्        (समता→परीक्षा e) b = isEquiv.equiv-proof e b .fst .fst
उद्दिष्टनष्टम् (समता→परीक्षा e) b = isEquiv.equiv-proof e b .fst .snd
नष्टोद्दिष्टम् (समता→परीक्षा {f = f} e) a =
  cong fst (isEquiv.equiv-proof e (f a) .snd (a , refl))

-- and the same statement in the तन्तु vocabulary, which is the form a
-- census wants: the verdict at every point is एकम्, simultaneously.
-- (सकलादेश, not a search with a first step — `Tantujala` §६.)
परीक्षा→एकम् : {A : Type ℓ} {B : Type ℓ'} {f : A → B}
             → नष्टोद्दिष्टयोगः f → (b : B) → T.एकम् f b
परीक्षा→एकम् {f = f} y = T.सकलादेशः f (परीक्षा→समता y)

एकम्→परीक्षा : {A : Type ℓ} {B : Type ℓ'} {f : A → B}
             → ((b : B) → T.एकम् f b) → नष्टोद्दिष्टयोगः f
एकम्→परीक्षा {f = f} c = समता→परीक्षा (T.सकलादेश-प्रत्यागमः f c)

------------------------------------------------------------------------
-- ४ · The two-way statement, as one term: the pair of procedures exists
--     if and only if the fibre is contractible at every point.
------------------------------------------------------------------------

परीक्षा-लक्षणम् : {A : Type ℓ} {B : Type ℓ'} (f : A → B)
              → (नष्टोद्दिष्टयोगः f → (b : B) → T.एकम् f b)
              × (((b : B) → T.एकम् f b) → नष्टोद्दिष्टयोगः f)
परीक्षा-लक्षणम् f = परीक्षा→एकम् , एकम्→परीक्षा

------------------------------------------------------------------------
-- ५ · THE LIMIT, stated because "if and only if" is weaker than "equal"
--     and this corpus has been burned by the difference before.
--
-- `isEquiv f` is a proposition: any two proofs are equal.  The record
-- above is NOT — it carries a chosen quasi-inverse together with chosen
-- homotopies, and different choices need not be identified.  So §४ is a
-- logical equivalence and cannot be strengthened to an equivalence of
-- types by these terms.
--
-- One round trip does close, definitionally up to the propositionality:
-- starting from an `isEquiv`, unpacking to the pair and repacking
-- returns what it was given.  The other direction is NOT claimed here.
------------------------------------------------------------------------

समता-प्रतिष्ठा : {A : Type ℓ} {B : Type ℓ'} (f : A → B) → isProp (isEquiv f)
समता-प्रतिष्ठा = isPropIsEquiv

समता-चक्रम् : {A : Type ℓ} {B : Type ℓ'} {f : A → B} (e : isEquiv f)
            → परीक्षा→समता (समता→परीक्षा e) ≡ e
समता-चक्रम् {f = f} e = समता-प्रतिष्ठा f _ e

------------------------------------------------------------------------
-- ६ · THE DISCRIMINANT, on both roads.
--
-- ROAD ONE.  `प्रस्तारः rs : Iso (अङ्कस्थान rs) (Fin (सङ्ख्या rs))` —
-- Piṅgala's own pair, generalised to a छेद-सूची, with उद्दिष्ट written by
-- addition and multiplication and नष्ट by division, each proved
-- separately and neither transported from the other.  So the witness
-- exists at EVERY छेद-सूची, and the defect is identically zero there.
------------------------------------------------------------------------

प्रस्तार-योगः : (rs : List ℕ) → नष्टोद्दिष्टयोगः (Iso.fun (प्रस्तारः rs))
प्रस्तार-योगः rs = इषो→योगः (प्रस्तारः rs)

प्रस्तार-एकम् : (rs : List ℕ) (i : Fin (सङ्ख्या rs))
             → T.एकम् (Iso.fun (प्रस्तारः rs)) i
प्रस्तार-एकम् rs = परीक्षा→एकम् (प्रस्तार-योगः rs)

-- Piṅgala's own case: छेद-सूची uniformly 1 (लघु, गुरु), five syllables.
_ : नष्टोद्दिष्टयोगः (Iso.fun (प्रस्तारः (एकरूप 5 1)))
_ = प्रस्तार-योगः (एकरूप 5 1)

------------------------------------------------------------------------
-- ROAD TWO.  `Bool → Unit` — `Tantujala.समाहार-मार्गः`, the collapse
-- whose fibre over `tt` is बहु.  There is NO witness, and the proof is
-- the three-verdict exclusion, not a separate argument: a witness would
-- make the fibre एकम्, and एकम् and बहु exclude one another.
------------------------------------------------------------------------

समाहारे-न-योगः : ¬ (नष्टोद्दिष्टयोगः T.समाहार-मार्गः)
समाहारे-न-योगः y =
  T.एक-बहु-विरोधः T.समाहार-मार्गः tt (परीक्षा→एकम् y tt) T.बहु-अत्र

-- and the OTHER way a witness can fail, which "no witness" does not
-- distinguish: `⊥ → Unit` misses `tt` altogether (रिक्तम्).  Both roads
-- two, opposite reasons, same absence — `Tantujala` §५ is why a boolean
-- census cannot report the difference.
शून्ये-न-योगः : ¬ (नष्टोद्दिष्टयोगः T.शून्य-मार्गः)
शून्ये-न-योगः y = T.रिक्तम्-अत्र (परीक्षा→एकम् y tt .fst)

------------------------------------------------------------------------
-- ७ · उद्दिष्टमात्रम् — ONE of the two procedures, and why one is not
--     enough.  This is the shape of a one-way edge as data: every index
--     has SOME element mapping to it, and nothing says the element is
--     recovered.
------------------------------------------------------------------------

record उद्दिष्टमात्रम् {A : Type ℓ} {B : Type ℓ'} (f : A → B)
       : Type (ℓ-max ℓ ℓ') where
  constructor एकदिशा
  field
    प्रति-नष्टम् : B → A
    प्रत्यागमः   : (b : B) → f (प्रति-नष्टम् b) ≡ b

open उद्दिष्टमात्रम् public

-- the pair gives the half, always.
योगः→मात्रम् : {A : Type ℓ} {B : Type ℓ'} {f : A → B}
             → नष्टोद्दिष्टयोगः f → उद्दिष्टमात्रम् f
प्रति-नष्टम् (योगः→मात्रम् y) = नष्टम् y
प्रत्यागमः   (योगः→मात्रम् y) = उद्दिष्टनष्टम् y

-- the half does NOT give the pair, and the counterexample is the same
-- collapse: `Bool → Unit` has the return trip on indices and no return
-- trip on patterns.
समाहारे-मात्रम् : उद्दिष्टमात्रम् T.समाहार-मार्गः
प्रति-नष्टम् समाहारे-मात्रम् _ = true
प्रत्यागमः   समाहारे-मात्रम् _ = refl

मात्रम्-न-पर्याप्तम् :
  उद्दिष्टमात्रम् T.समाहार-मार्गः × (¬ नष्टोद्दिष्टयोगः T.समाहार-मार्गः)
मात्रम्-न-पर्याप्तम् = समाहारे-मात्रम् , समाहारे-न-योगः

------------------------------------------------------------------------
-- ८ · शेषः — what this does not settle.
--
-- The predicate is checkable in the sense that an edge either carries an
-- inhabitant of §२ or is refuted like §६; it is NOT decidable, and no
-- `Dec` appears above.  For a general map in this corpus, exhibiting the
-- witness or refuting it is the mathematical work, and this module only
-- fixes what the two roads ARE, so that a census reporting "one-way" is
-- reporting the absence of a named type rather than the output of a
-- grader's flag.
--
-- Also not here: the case with no dharmin at all — an edge for which
-- there is no map to take a fibre of.  `Tantujala` §७ says why that is
-- a different axis, and it stays a different axis.
------------------------------------------------------------------------
