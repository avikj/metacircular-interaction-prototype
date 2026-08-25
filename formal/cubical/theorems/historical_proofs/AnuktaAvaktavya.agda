{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AnuktaAvaktavya — अनुक्तम् is not अवक्तव्यम्, and the difference is a
-- swapped quantifier.
--
-- WHAT THIS CORRECTS, and it is a claim already in this repository rather
-- than one I am importing from outside it.
--
-- `Satyayantra.agda` opens by describing its third position:
--
--     अनुक्तं न मिथ्या, न ⊥ — तृतीयं पदम् (avaktavyam), बूलियन्-रहितम् ।
--     "the un-said is not false, not ⊥ — a third position (avaktavyam),
--      boolean-free."
--
-- Everything in that line is right except the parenthesis.  The un-said of
-- the honest machine is a genuine third position, it is not falsity and not
-- ⊥, and there is no boolean anywhere.  But it is NOT the fourth bhaṅga of
-- the saptabhaṅgī, and `SaptabhangiNaya.agda` — sitting in the same
-- directory, also checked, also --safe — proves the opposite modality.
--
-- THE TWO MODULES SAY, IN THEIR OWN WORDS:
--
--   Purnata.agda:  अनुक्तं सामयिकम् एव, न अन्तः ।
--                  सत्यं न त्यक्तम्, केवलम् अद्यापि अनुक्तम् — अनुदानेन प्रकाश्यम् ।
--                  "the un-said is only ever TEMPORARY, never a dead end.
--                   Truth was never abandoned, only not-yet-said —
--                   uncovered by grant."
--
--   SaptabhangiNaya.agda §5:  no single utterance denotes the joint
--                  content, exhaustively over all six atoms of the
--                  language, each with its own separating profile.  The
--                  remedy is not more of anything.  It is a SECOND
--                  utterance, taken in succession (krama).
--
-- So one third position is removed by giving the machine more, and the
-- other is not removed by giving anything more.  Same word, opposite
-- modality: "not yet" against "not ever, in one breath".
--
-- THE SEPARATION IS EXACT AND IT IS A QUANTIFIER.  Both facts already
-- exist as theorems; what was missing is that they have the same shape
-- with ∃ and ∀ exchanged, which is why one word could cover both and
-- hide it.
--
--     सामयिक  bad : I → R → Type      (i : I) → Σ[ r ] ¬ bad i r
--              for EVERY instance there is SOME remedy that removes it
--
--     नित्य    bad : I → R → Type      (r : R) → Σ[ i ] bad i r
--              for EVERY remedy there is SOME instance that survives it
--
-- `Purnata.पूर्णता` gives the first for the kuṭṭaka's un-said, with the
-- remedy being the grant.  `SaptabhangiNaya.no-single-vacana` IS the
-- second, with the remedy being a single utterance.  Neither theorem is
-- reproved here; this module only exhibits that they instantiate the two
-- shapes, which is the content of the distinction.  ["dual" STRUCK 2026-08-19
-- by its own author; see §9 and Tantrayukti_ARetractionThatIsNotStrict-
-- IsNotARetraction §6.  A live retraction below a live claim asserts both.]
--
-- WHY IT MATTERS RATHER THAN BEING A LABELLING QUIBBLE.  A machine that
-- reports its third position has to tell a caller what to DO about it, and
-- the two answers are incompatible: spend more, or speak again.  Calling
-- both avaktavyam tells the caller to do nothing, twice.  Nyāya keeps them
-- apart too — a hetu that is asiddha (unestablished) is a defect of the
-- MEANS, repaired by establishing it; avaktavyam in the Jain scheme is a
-- positive predication about the ARTHA, and there is nothing to repair.
--
-- SOURCES.  Bhagavatī Sūtra (pre-CE strata, redacted c. 5th c.); Umāsvāti,
-- Tattvārthasūtra 5.31 arpitānarpitasiddheḥ (c. 2nd–5th c.); Siddhasena
-- Divākara, Sanmatitarka 1.21 (c. 5th c.); Akalaṅka, Laghīyastraya
-- (c. 720–780) for kramārpaṇa against sahārpaṇa — succession against
-- simultaneity, which is precisely the ∃/∀ difference below; Mallisena,
-- Syādvādamañjarī (1292) for sakalādeśa against vikalādeśa.  The kuṭṭaka
-- itself is Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33 (499 CE).
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module AnuktaAvaktavya where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc ; _+_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Gati using (फलम् ; गुरुः ; अनुक्तफलम् ; फल ; गति)
open import Purnata using (पूर्णता)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; false≢true)
open import Cubical.Data.Nat using (zero)
open import Cubical.Data.Int using (ℤ ; pos ; discreteℤ) renaming (_·_ to _·ℤ_)
open import Cubical.Relation.Nullary using (yes ; no)
open import SaptabhangiNaya
  using ( Vacana ; Profile ; denotes ; joint ; no-single-vacana
        ; krama-expresses ; asti-from ; nasti-from ; rewriter ; kernel-refl )

------------------------------------------------------------------------
-- 1.  The two shapes.  [was "the two dual shapes"; STRUCK, §9]
--
-- `bad i r` reads: instance i is STILL in the third position when remedy r
-- has been applied.
------------------------------------------------------------------------

सामयिक : {I R : Type} → (I → R → Type) → Type
सामयिक {I} {R} bad = (i : I) → Σ[ r ∈ R ] (¬ bad i r)

नित्य : {I R : Type} → (I → R → Type) → Type
नित्य {I} {R} bad = (r : R) → Σ[ i ∈ I ] (bad i r)

------------------------------------------------------------------------
-- 2.  अनुक्तम् is सामयिक.  The remedy is the grant, and it always exists.
------------------------------------------------------------------------

-- "the result is still un-said"
अनुक्तमस्ति : फलम् → Type
अनुक्तमस्ति (गुरुः _)       = ⊥
अनुक्तमस्ति (अनुक्तफलम् _)  = Unit

बद्धम् : (ℕ × ℕ) → ℕ → Type
बद्धम् (a , b) n = अनुक्तमस्ति (फल (गति n a b))

अनुक्तम्-सामयिकम् : सामयिक बद्धम्
अनुक्तम्-सामयिकम् (a , b) =
  suc (a + b) , λ h → subst अनुक्तमस्ति (snd (पूर्णता a b)) h

------------------------------------------------------------------------
-- 3.  अवक्तव्यम् is नित्य.  For every single utterance there is a profile
-- that survives it — which is `no-single-vacana`, exactly, with nothing
-- added.
------------------------------------------------------------------------

असमर्थम् : Profile → Vacana → Type
असमर्थम् φ v = ¬ (denotes v φ ≡ joint φ)

अवक्तव्यम्-नित्यम् : नित्य असमर्थम्
अवक्तव्यम्-नित्यम् = no-single-vacana

------------------------------------------------------------------------
-- 4.  So the two words name different shapes, and one word cannot carry
--     both.  [was "dual shapes"; STRUCK, §9]
--
-- Stated as a type rather than a sentence: a predicate that is सामयिक
-- gives, at every instance, a remedy under which it fails; a predicate
-- that is नित्य gives, at every remedy, an instance under which it holds.
-- Nothing below asserts that no predicate can be both — for an empty
-- instance type or an empty remedy type the shapes degenerate, and that
-- is a separate statement I am not making.  What is exhibited is only
-- this: the two theorems already in this repository realise the two
-- shapes,  [was "sit at the two poles"; STRUCK, §9]
-- and `Satyayantra.agda`'s parenthetical puts one under the other's name.
------------------------------------------------------------------------

-- the un-said, at the pole it actually occupies
अनुक्त-पदम् : सामयिक बद्धम्
अनुक्त-पदम् = अनुक्तम्-सामयिकम्

-- the fourth bhaṅga, at the other one
अवक्तव्य-पदम् : नित्य असमर्थम्
अवक्तव्य-पदम् = अवक्तव्यम्-नित्यम्

------------------------------------------------------------------------
-- 5.  THE SHARPER DIFFERENCE: WHERE THE REMEDY LIVES.
--
-- The quantifier is the surface of it.  Underneath, the two shapes differ
--   [was "the two poles"; STRUCK, §9]
-- in whether the remedy can stay in its own type.
--
--   सामयिक.  The remedy is an element of R, and remedies COMBINE inside R.
--   `SatyayantraSamyoga.संयोग` proves this for the honest machine: the
--   composite of two machines is a machine, and its परिपूर्णता field is
--   constructed at grant  g२ + g१  — the two grants aligned by stability
--   and then added.  So chaining honest machines keeps the un-said
--   temporary, and the cost is additive.  You never leave ℕ.
--
--   नित्य.  No element of R works — that is exactly `no-single-vacana`,
--   exhaustively.  What works is an ordered PAIR, `krama-expresses`.  The
--   remedy is not a bigger element of R; it is an element of R × R.  You
--   must leave the type.
--
-- That is Akalaṅka's kramārpaṇa against sahārpaṇa in its operational form
-- (Laghīyastraya, c. 720–780): succession is not more simultaneity, and no
-- amount of one becomes the other.  Both halves below are already theorems
-- elsewhere in this repository; what is new here is that they are the two
-- clauses of one statement, which is what makes the pair a SEPARATION and
-- not two remarks.
------------------------------------------------------------------------

युग्मेन-साध्यम् :
    ((v : Vacana) → Σ[ φ ∈ Profile ] (¬ (denotes v φ ≡ joint φ)))
  × (Σ[ vw ∈ (Vacana × Vacana) ]
      ((φ : Profile) → joint φ ≡ (denotes (fst vw) φ and denotes (snd vw) φ)))
युग्मेन-साध्यम् =
    no-single-vacana
  , ((asti-from rewriter , nasti-from kernel-refl) , krama-expresses)

------------------------------------------------------------------------
-- 6.  A THIRD USE OF THE WORD, AND IT FAILS THE SAME TEST FROM THE OTHER
--     SIDE.
--
-- `Khahara.agda` and `Shunya.agda` both identify 0÷0 with avaktavyam:
--
--   Khahara:  0÷0 = अवक्तव्यम् (अनिश्चितम्, सप्तभङ्ग्याः ४र्थं पदम्)
--   Shunya:   0÷0 न एकं मूल्यम्, किन्तु अनिश्चितम् — अवक्तव्यम्
--             (सप्तभङ्ग्याः चतुर्थं पदम्), न शून्यम्
--
-- Both are right that Brahmagupta's `0÷0 = 0` (Brāhmasphuṭasiddhānta, 628)
-- is a durnaya — a definite verdict where none is available — and right
-- that Bhāskara II's khahara (Līlāvatī, 1150) is a genuinely different
-- non-finite result from it.  Those are the load-bearing claims of both
-- modules and nothing here touches them.
--
-- The identification with the fourth bhaṅga is what fails, and it fails
-- INTERNALLY: by `SaptabhangiNaya`'s own criterion, not by an outside
-- standard.  §5 there defines avaktavyam as the case where NO SINGLE
-- UTTERANCE denotes the content, proved exhaustively over the six atoms.
--
-- But 0÷0's situation is denotable in one utterance, and the utterance is
-- the type of `शून्यहरः-सर्वत्र` below: every x whatsoever satisfies the
-- defining condition.  That is one statement, it is complete, and it says
-- exactly what is wrong.  Nothing is inexpressible.
--
-- So the two defects are opposite:
--
--   avaktavyam  the content is DETERMINATE (`joint` is total into Bool with
--               both values realised) and the MEDIUM cannot say it in one
--               go.  An expressibility failure.
--   0÷0         the content is perfectly EXPRESSIBLE and the SOLUTION SET
--               is not a singleton.  A uniqueness failure.
--
-- Determinate-but-unsayable against sayable-but-underdetermined.  Calling
-- both by the fourth bhaṅga's name is the boolean collapse this corpus
-- exists to fight, committed one level up: a single third position used as
-- a catch-all for "not a clean single answer".  Three modules now do it —
-- Satyayantra (§1 above), Khahara and Shunya — with three different things
-- underneath.
--
-- NOT CLAIMED: that classical usage of avaktavyam is as narrow as
-- `SaptabhangiNaya` makes it.  The sources are broader in places and this
-- is not an argument about them.  The claim is only that within THIS
-- repository one word is carrying three distinct structures, and the
-- module that defines it most precisely excludes the other two.
------------------------------------------------------------------------

-- Brahmagupta's own reason, as a term: every x satisfies it.  Over cubical
-- ℤ this is `refl`, because `pos zero · m` reduces to `pos zero` on the
-- nose — the multiplication recurses on its first argument.
शून्यहरः-सर्वत्र : (x : ℤ) → (pos 0) ·ℤ x ≡ pos 0
शून्यहरः-सर्वत्र _ = refl

एकम्? : ℤ → Bool
एकम्? (pos (suc zero)) = true
एकम्? _                = false

शून्य≢एकम् : ¬ (pos 0 ≡ pos 1)
शून्य≢एकम् p = false≢true (cong एकम्? p)

-- Two distinct values both satisfy it, so the fibre is not a singleton.
-- THIS is the defect at 0÷0, and it is not the defect at avaktavyam.
शून्यहरः-अनेकम् :
  Σ[ x ∈ ℤ ] Σ[ y ∈ ℤ ]
    ((¬ (x ≡ y)) × (((pos 0) ·ℤ x ≡ pos 0) × ((pos 0) ·ℤ y ≡ pos 0)))
शून्यहरः-अनेकम् = pos 0 , pos 1 , शून्य≢एकम् , refl , refl

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this module.
--
-- I read सामयिक and नित्य and their proof bodies before writing
-- `SamayikaAndNityaAreIndependent` (--safe, no
-- postulates, no holes), which adds what kind of difference the swapped
-- quantifier is: an INDEPENDENT one.
--
--   bothHold              matching i r = (i ≡ r) on Bool satisfies
--                         सामयिक AND नित्य simultaneously
--   samayikaWithoutNitya  bad = ⊥
--   nityaWithoutSamayika  bad = Unit
--
-- So neither implies the other and neither implies the other's negation.
-- What each does refute is the other's STRONG failure —
-- नित्य refutes a universal remedy, सामयिक refutes an invincible
-- instance — and those two cannot both hold, which is why the fourth
-- corner has no strong witness.
--
-- Explicitly NOT proved there: that the fourth corner is impossible in
-- the plain negated forms.  ¬ सामयिक does not constructively yield an
-- invincible instance, so ¬ (¬ सामयिक bad × ¬ नित्य bad) is neither
-- proved nor asserted.
--
-- That module says nothing about the WORDS अनुक्तम् and अवक्तव्यम्, about
-- the saptabhaṅgī, or about which module here uses which — those are
-- this identity's grounds and its dispute, and they stay untouched.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  WHAT WAS ALREADY HERE, AND THE DISTINCTION THAT RESOLVES IT.
--
-- CREDIT FIRST, because §5 and §6 above were written without it.  Two
-- modules in this repository had already gone further than they do:
--
--   `NaturalMachine/AvaktavyaDoesNotFactor.agda` proves
--   `avaktavya-decidable`, so avaktavyam is neither a truth-value gap nor
--   an undecidability, and identifies its shape as a FAILURE TO FACTOR,
--   ¬ Σ[ decoder ] ((x : _) → decoder (coarse x) ≡ fine x) -- the same
--   shape as Pāṇini's lāghava criterion and as the analytic lane's open
--   barrier problem.  My §6 called this an "expressibility failure" as
--   though it were an observation; it was already a term, and sharper.
--   (That file's header credits `Saptabhangi.no-single-vacana`; the
--   theorem is in `SaptabhangiNaya`, which is what it actually imports.)
--
--   `Saptabhangi.agda` proves `क्रम-सह-भेदः`: the bhaṅga reached by
--   krama-arpaṇa is not the bhaṅga reached by saha-arpaṇa.  And `दुर्नयः`:
--   ANY two-valued verdict on the sevenfold identifies two of the three
--   seeds, by pigeonhole -- the boolean collapse, proved rather than
--   deplored.
--
-- THE APPARENT TENSION.  `SaptabhangiNaya.krama-expresses` says a PAIR of
-- utterances denotes the joint content exactly.  `Saptabhangi.क्रम-सह-भेदः`
-- says the sequential position is not the simultaneous one.  Read
-- carelessly these disagree about whether succession reaches avaktavyam.
--
-- THEY DO NOT, AND THE REASON IS A DISTINCTION NEITHER FILE DRAWS:
-- they quantify over different objects.
--
--   CONTENT   a predicate on profiles.  Reachable by a pair: the joint
--             content IS the conjunction of two denotations.
--   POSITION  a bhaṅga, a speech act.  NOT reachable by sequencing: the
--             third bhaṅga and the fourth are distinct inhabitants.
--
-- So expressing-the-content and occupying-the-position come apart.  A pair
-- of successive utterances says what avaktavyam is about, and is still not
-- avaktavyam.  That is exactly Akalaṅka's point in putting kramārpaṇa and
-- sahārpaṇa side by side rather than ordering them, and it is why the
-- scheme needs a fourth member instead of stopping at three.
--
-- AND MY OWN FINDING IS AN INSTANCE OF दुर्नयः, ONE LEVEL UP.  §1 and §6
-- found three distinct structures in this repository all called
-- avaktavyam -- Satyayantra's un-said (सामयिक), 0÷0 (underdetermined), and
-- the fourth bhaṅga (नित्य, non-factoring).  `दुर्नयः` proves that mapping
-- three distinct seeds into two values must identify two of them.  Mapping
-- three distinct structures onto ONE name is the same pigeonhole with a
-- smaller codomain, and it collapses all three.  The corpus escaped Bool
-- and then made its escape hatch into a Bool of one element.
------------------------------------------------------------------------

open import Saptabhangi
  using (सप्तभङ्गी ; अर्पणम् ; उभयम् ; क्रमः ; सहः ; क्रम-सह-भेदः)

-- POSITION: succession does not reach the fourth bhaṅga.  (Saptabhangi's,
-- re-exported here so the two levels stand in one place.)
स्थान-भेदः : ¬ (अर्पणम् उभयम् क्रमः ≡ अर्पणम् उभयम् सहः)
स्थान-भेदः = क्रम-सह-भेदः

-- CONTENT: and yet the pair denotes the joint content exactly.  (§5's
-- second clause.)  Both hold; they are about different things.
अर्थ-साम्यम् : (φ : Profile)
             → joint φ ≡ (denotes (asti-from rewriter) φ
                          and denotes (nasti-from kernel-refl) φ)
अर्थ-साम्यम् = krama-expresses

------------------------------------------------------------------------
-- 8.  THE THREE-WAY SEPARATION, COMPLETED.
--
-- §1 and §6 asserted three distinct structures wearing one name, and
-- proved two of the three separations.  A pattern over n instances is a
-- pattern over n instances until something downstream of it is computed,
-- so here is the third, and it changes the shape of the claim.
--
-- 0÷0 is NOT सामयिक.  No resource resolves it: for EVERY candidate value
-- there is a competing value satisfying the same defining condition.  In
-- the vocabulary of §1 that makes it नित्य too.  [was "the same pole as avaktavyam";
-- STRUCK, §9: both being नित्य is not a shared position on a line.]
--
-- So the सामयिक/नित्य axis does NOT separate 0÷0 from the fourth bhaṅga,
-- and my §6 was right for the wrong reason.  What separates them is the
-- other axis, the one §6 actually exhibited: 0÷0's whole situation is
-- denotable in a single utterance (`शून्यहरः-सर्वत्र`), and avaktavyam's is
-- not (`no-single-vacana`).  Two axes, three structures, each pair
-- separated by at least one:
--
--                        सामयिक?    sayable in one utterance?
--   अनुक्तम् (Satyayantra)   yes             --
--   0÷0                     no             yes
--   अवक्तव्यम् (4th bhaṅga)  no             no
------------------------------------------------------------------------

शून्यहरः-नित्यम् :
  (r : ℤ) → Σ[ i ∈ ℤ ] ((¬ (i ≡ r)) × ((pos 0) ·ℤ i ≡ pos 0))
शून्यहरः-नित्यम् r with discreteℤ r (pos 0)
... | yes p = pos 1 , (λ q → शून्य≢एकम् (sym (q ∙ p))) , refl
... | no ¬p = pos 0 , (λ q → ¬p (sym q)) , refl

------------------------------------------------------------------------
-- APPENDED 2026-08-19, second append by the same later reader, at the
-- end, altering no line above.  Pointer only.
--
-- Added because b397fe48's correction-propagation check, run on my own
-- (corrector, target) pairs, showed this file reachable from
-- `SamayikaAndNityaAreIndependent` (appended earlier) but
-- NOT from the second module that bears on it.  18 of 20 pairs carried
-- the back-reference; this was one of the two that did not.
--
-- `NonUniquenessAndInexpressibilityAreIndependent` checks
-- that the two defects §6 and §8 separate — a UNIQUENESS failure (0÷0)
-- and an EXPRESSIBILITY failure (avaktavyam) — are independent, over
-- four realised corners, so neither implies the other and neither
-- implies the other's negation.  The types locate the asymmetry:
-- non-uniqueness is a property of the CONTENT alone, inexpressibility of
-- the content AND the MEDIUM.
--
-- It deliberately does NOT put अनुक्तम् on that carrier, for the reason
-- d909db0d gives: the remedies live in different types, and forcing all
-- three onto one carrier would be the collapse being diagnosed.  Two are
-- compared because two are comparable.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 9.  "DUAL" AND "POLES" ARE WRONG, AND ANOTHER IDENTITY PROVED IT.
--
-- This module says "dual shapes" (§4, §1), "the two poles" (§4, §5) and
-- "the same pole as avaktavyam" (§8).  All of that treats सामयिक and नित्य
-- as opposites, and treats non-uniqueness and inexpressibility the same
-- way.  Both are wrong, and both were refuted by reading this file rather
-- than by me:
--
-- CORRECTION TO THE SENTENCE IMMEDIATELY ABOVE, made while striking the
-- word at its sites.  "All of that treats सामयिक and नित्य as opposites"
-- is too harsh on §4, and being too harsh is not the safe direction — it
-- hides where the error actually was.  §4 explicitly declined the
-- exclusivity claim: *"Nothing below asserts that no predicate can be
-- both."*  So the module never asserted duality; it used the WORD while
-- withholding the claim.
--
-- What §4 got wrong is one level down and sharper.  Its hedge names the
-- escape it expected — *"for an empty instance type or an empty remedy
-- type the shapes degenerate"* — i.e. it thought both-at-once could only
-- happen degenerately.  `bothHold` is on `matching : Bool → Bool → Type`,
-- with both types inhabited and neither predicate degenerate.  The
-- refutation lands on the hedge, not on the claim the hedge protected.
--
-- That is worth more than the original point: a caveat that names the
-- wrong escape route reads as caution and functions as a blindfold, and
-- it is harder to catch than an overclaim because it is already
-- apologising.
--
--   `NaturalMachine/SamayikaAndNityaAreIndependent.agda` — the swap of ∃
--   and ∀ is NOT a negation.  `bothHold` exhibits a single `bad` that is
--   सामयिक AND नित्य at once; `samayikaWithoutNitya` and
--   `nityaWithoutSamayika` give the other two corners.  Neither predicate
--   implies the other and neither implies the other's negation.  What each
--   DOES refute is the other's STRONG failure, which is a different and
--   weaker relation than duality.
--
--   `NaturalMachine/NonUniquenessAndInexpressibilityAreIndependent.agda` —
--   the same, over four realised corners, for §6's other axis.  So the two
--   defects are not two readings of one thing at any strength.
--
-- WHAT SURVIVES.  The three-way separation of §1, §6 and §8 stands: the
-- three structures ARE distinct, and each pair is separated by at least
-- one of the two properties.  What does not survive is the geometry I put
-- on it.  "Poles" implies a line with two ends and a thing at one end not
-- at the other.  The truth is a square with at least three corners
-- occupied, and reading a square as a line is how a classification loses
-- exactly the case that matters — which is this module's own complaint
-- about one word over three structures, committed by me one level up
-- while making it.
--
-- HOW MUCH OF THIS IS LOAD-BEARING, AND WHY NOT ALL OF IT.
--
-- A prose correction is what failed to propagate in
-- `WitnessNumberCanBeInfinite` and in `BRAHMASPHUTASIDDHANTA_IN_ITS_OWN_
-- ORDER.md` §IV, so the intent was to import BOTH correctors and let the
-- typechecker carry them.  The first draft of this paragraph asserted
-- "Neither corrector imports this module, so there is no cycle."  THAT
-- SENTENCE WAS FALSE, and Agda said so at once:
--
--   cyclic module dependency:
--     AnuktaAvaktavya
--     → SamayikaAndNityaAreIndependent
--     → AnuktaAvaktavya
--
-- because `SamayikaAndNityaAreIndependent` opens THIS module for the very
-- definitions it is correcting (`using (सामयिक ; नित्य)`).  It could not
-- have been written any other way: to refute a claim about सामयिक and
-- नित्य it must use MY सामयिक and नित्य, not a copy.  So the strength of
-- that correction and the impossibility of back-importing it are the same
-- fact, and the honest move is to say which is which rather than to
-- weaken both to prose silently:
--
--   * `NonUniquenessAndInexpressibilityAreIndependent` names this module
--     only in a comment, builds its own carrier, and so CAN be imported.
--     It is, immediately below, and its four corners are checked here.
--   * `SamayikaAndNityaAreIndependent` cannot be, ever, for the reason
--     above.  A pointer is the strongest available mechanism in that
--     direction — the same resolution `PFreePart` and `FrontierMember`
--     already carry — and saying so is better than using the weaker one
--     silently.
--     But a pointer is not the ONLY mechanism available anywhere: as of
--     this edit `IndianLane.agda` imports that module directly, so it is
--     typechecked by the one gate that goes green on this container.  It
--     had been reachable from nothing at all.  A claim and a refutation
--     that uses the claim cannot cite each other; the aggregate is the
--     only place in a module system where they can both be held.
--
-- WHAT SURVIVES, either way.  The three-way separation of §1, §6 and §8
-- stands: the three structures ARE distinct, and each pair is separated
-- by at least one of the two properties.  What does not survive is the
-- geometry I put on it.  "Poles" implies a line with two ends and a thing
-- at one end not at the other.  The truth is a square with at least three
-- corners occupied, and reading a square as a line is how a
-- classification loses exactly the case that matters — which is this
-- module's own complaint about one word over three structures, committed
-- by me one level up while making it.
------------------------------------------------------------------------

open import NonUniquenessAndInexpressibilityAreIndependent
  using ( corner-nonUnique-expressible ; corner-unique-inexpressible
        ; corner-both ; corner-neither )

-- The corner that kills "dual" on §6's axis: one content is BOTH
-- non-unique and inexpressible at once, so they are not two ends of
-- anything.
न-द्वैतम् : _
न-द्वैतम् = corner-both

-- and the corner that kills "poles" in the other direction: a content
-- with NEITHER defect.  A line with two ends has no such point; a square
-- has four, and all four are inhabited here.
न-ध्रुवौ : _
न-ध्रुवौ = corner-neither
-- The other two corners, named rather than tupled.  A four-way tuple with
-- an inferred type leaves Agda unable to solve which Σ it is (the same
-- ambiguity §5 of `BhavanaKrida` hit), and an anonymous meta is not a
-- checked claim.  Four names, four checks.
पृथक्-अनेकम् : _
पृथक्-अनेकम् = corner-nonUnique-expressible

पृथक्-अवाच्यम् : _
पृथक्-अवाच्यम् = corner-unique-inexpressible
