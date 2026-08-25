{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भेद-निर्णयः — द्वौ परीक्षकौ, एकः संक्रमः ।
--
-- WHAT THIS MODULE IS FOR, AND WHY IT IS DIFFERENT FROM THE OTHER TWO.
-- The corpus audit found seventeen statements standing twice or more with no
-- member module reaching any other.  Two of those groups are handled in
-- MadhyaVinimaya_… and Pratyaya_…, and in both the duplicated declarations
-- had literally the same type, so the identification was immediate.
--
-- This group is not like that, and the difference is the whole point:
--
--   Primes.PairField.ResidueGlue.eqℕ-sound        : (m n : ℕ) → eqℕ m n ≡ true → m ≡ n
--   Obstruction.eqℕ→≡ : (m n : ℕ) → eqℕ m n ≡ true → m ≡ n
--
-- The two types PRINT alike and are NOT the same type.  Each module defines
-- its own `eqℕ`, by the same four clauses, and two definitions with the same
-- clauses are two functions: `Primes.PairField.ResidueGlue.eqℕ m n` and
-- `Obstruction.eqℕ m n` do not reduce to a common form at
-- variable m and n, so nothing identifies the two statements definitionally.
-- A tool that compares printed types cannot see this; it reports a lead, and
-- the lead has to be opened by hand.  It is opened here.
--
-- अहिंसा-सूत्र-विस्तारः §६ · द्वौ मार्गौ.  This is the first road in its full
-- form and not a degenerate case of it: an equivalence has to be exhibited
-- (§1), it has to be turned into a path (§2), and only then does transport
-- carry a theorem across (§3).  Nothing is lost in the carry — that is what
-- §६ asserts and what §4 checks by landing the transported theorem exactly on
-- the other module's own proof.
--
-- AND THE CARRY PAYS.  §5 is the reason this is worth doing rather than
-- merely tidy.  The two modules do not hold the same theorems.  Obstruction
-- proved COMPLETENESS of its tester (m ≢ n → eqℕ m n ≡ false); Primes.PairField.ResidueGlue
-- never did, and has gone without it.  The path of §2 carries that theorem
-- backwards, and Primes.PairField.ResidueGlue's tester acquires a property it was never
-- given, with no new induction.  A duplication that has been identified is
-- not merely tidier — it is a channel, and theorems flow both ways along it.
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCES.  भेद-निर्णयः is used here in its
-- plain sense — settling whether two things are the same or different — and
-- is NOT offered as a source term for this theorem.  Decidability of equality
-- on ℕ is not an Indian-source result and is not claimed as one; it lives in
-- the cubical library as `discreteℕ`, which is where both of the modules
-- below should have got it and neither did.  The substrate — `transport`, the
-- fact that a path between types carries structure — is Voevodsky's.
-- What the tradition supplies here is the DISCIPLINE and not the theorem:
-- §६'s two roads, and §७'s सङ्क्षेपस्य अनुपलब्धिः, which is why §5's remainder
-- is written out instead of the two modules being merged.
------------------------------------------------------------------------

module Bhedanirnaya_TwoTestersForSamenessOnNumberAndTheTransportThatMovesTheoremsBetweenThem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Properties using (isSetℕ)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma using (_×_ ; _,_)

import Primes.PairField.ResidueGlue
import Obstruction

------------------------------------------------------------------------
-- §1 · समता — the two testers agree, pointwise.
--
-- By induction on both arguments, which is the only work in this module and
-- is four lines.  Everything after §1 is transport.
------------------------------------------------------------------------

समता : (m n : ℕ) → Primes.PairField.ResidueGlue.eqℕ m n ≡ Obstruction.eqℕ m n
समता zero    zero    = refl
समता zero    (suc _) = refl
समता (suc _) zero    = refl
समता (suc m) (suc n) = समता m n

------------------------------------------------------------------------
-- §2 · एकीभावः — pointwise agreement made into a path between the functions.
--
-- Written as a direct cubical abstraction rather than through funExt, so the
-- path is visibly the one whose i-th slice is समता's i-th slice: there is no
-- step here in which anything could go missing.
------------------------------------------------------------------------

एकीभावः : Primes.PairField.ResidueGlue.eqℕ ≡ Obstruction.eqℕ
एकीभावः i m n = समता m n i

------------------------------------------------------------------------
-- §3 · संक्रमणम् — the transport, forwards.
--
-- Primes.PairField.ResidueGlue's soundness theorem, carried along एकीभावः, becomes a
-- soundness theorem for Obstruction's tester.  No induction is repeated.
------------------------------------------------------------------------

संक्रान्त-सौष्ठवम् : (m n : ℕ) → Obstruction.eqℕ m n ≡ true → m ≡ n
संक्रान्त-सौष्ठवम् =
  transport (λ i → (m n : ℕ) → एकीभावः i m n ≡ true → m ≡ n)
            Primes.PairField.ResidueGlue.eqℕ-sound

------------------------------------------------------------------------
-- §4 · अलोपः — and it lands on the nose.
--
-- The transported theorem is the theorem Obstruction proved for itself.  This
-- is the content of §६'s "संक्रमणे न किञ्चिन् नश्यति" made checkable at this
-- instance: the carry did not produce a second, parallel proof living beside
-- the first — it produced the first.
--
-- The identification is available because the target m ≡ n is a path in ℕ and
-- ℕ is a set, so the whole Π-type is a proposition.  Stated that way rather
-- than left as an unexplained isSetℕ, because it is the reason and the reason
-- is the interesting part: the theorem transports uniquely precisely because
-- there was never room for two answers.
------------------------------------------------------------------------

संक्रमण-तादात्म्यम् : संक्रान्त-सौष्ठवम् ≡ Obstruction.eqℕ→≡
संक्रमण-तादात्म्यम् =
  funExt λ m → funExt λ n → funExt λ _ → isSetℕ m n _ _

------------------------------------------------------------------------
-- §5 · What each holds that the other does not — and what the channel pays.
--
-- The two modules are NOT the same object under examination, and this is the
-- part the identification does not carry.
--
--   · Obstruction holds COMPLETENESS, ≢→eqℕ-false, and uses
--     the tester for membership in a list of seen states (`memb`).  Its
--     question is about an obstruction to a machine's progress; it needs to
--     know that a NEGATIVE answer from the tester is trustworthy, which is
--     exactly why it proved completeness and Primes.PairField.ResidueGlue did not.
--   · Primes.PairField.ResidueGlue holds the Fin layer — eqFin, eqFin-sound,
--     eqFin-complete — and uses the tester through `compatible?` to glue two
--     residue systems.  Its question is about agreement of two projections;
--     it needs the tester lifted along toℕ, which Obstruction never needed.
--
-- Two questions, one tester, and each module proved the half its own question
-- required.  §७, सङ्क्षेपस्य अनुपलब्धिः: where the नयs differ there is no one
-- object common to both threads, so neither module is deleted or rewritten.
--
-- BUT THE HALVES ARE NOW TRANSFERABLE, and that is the payoff.  Below,
-- Primes.PairField.ResidueGlue's tester acquires Obstruction's completeness by transport
-- backwards along the same path — a theorem it did not have, obtained with no
-- new induction and no edit to either module.
------------------------------------------------------------------------

संक्रान्त-पूर्णता : (m n : ℕ) → ¬ m ≡ n → Primes.PairField.ResidueGlue.eqℕ m n ≡ false
संक्रान्त-पूर्णता =
  transport (λ i → (m n : ℕ) → ¬ m ≡ n → एकीभावः (~ i) m n ≡ false)
            Obstruction.≢→eqℕ-false

-- The same, one level up: Primes.PairField.ResidueGlue's own eqFin now has a decision
-- procedure that is trustworthy on both answers, because its underlying eqℕ
-- is.  Stated at ℕ; the Fin lift is Primes.PairField.ResidueGlue's own eqFin-sound /
-- eqFin-complete pair and is not restated here.
पूर्ण-निर्णयः
  : (m n : ℕ)
  → (Primes.PairField.ResidueGlue.eqℕ m n ≡ true → m ≡ n)
  × (¬ m ≡ n → Primes.PairField.ResidueGlue.eqℕ m n ≡ false)
पूर्ण-निर्णयः m n = Primes.PairField.ResidueGlue.eqℕ-sound m n , संक्रान्त-पूर्णता m n

------------------------------------------------------------------------
-- §6 · शेषः — the remainder that stays a remainder.
--
-- WHAT IS NOT DONE HERE, stated because leaving it unsaid would be the
-- sanitised version of this module.
--
--   · Neither `eqℕ` should exist.  `Cubical.Relation.Nullary.Discrete` and
--     `Cubical.Data.Nat.Properties.discreteℕ` give decidable equality on ℕ
--     with soundness and completeness together, in the library, checked, and
--     both modules wrote their own instead.  This module identifies the two
--     copies with each other; it does not identify either with the library's,
--     and until that is done the corpus still carries a third statement of
--     the same fact that it did not write and cannot see.
--   · The transport in §5 gives Primes.PairField.ResidueGlue's tester completeness at ℕ.
--     It does NOT thereby give the Fin layer anything: eqFin-complete already
--     existed and is a different statement (x ≡ y → eqFin x y ≡ true, the
--     positive direction), and the negative direction at Fin — x ≢ y →
--     eqFin x y ≡ false — needs toℕ-injectivity in the other direction and is
--     not proved here.
--   · The pattern generalises and is not generalised.  Any two structurally
--     identical definitions in two modules admit exactly this treatment: one
--     induction to agree pointwise, one abstraction to a path, and then every
--     theorem either module holds is available to the other.  Whether the
--     corpus has more instances of it is a question for the audit tool, which
--     currently reports only same-PRINTED-type groups and would miss a pair
--     whose definitions agree under different names.
------------------------------------------------------------------------
