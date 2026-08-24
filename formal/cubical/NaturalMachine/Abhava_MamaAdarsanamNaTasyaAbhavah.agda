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
-- मूलवाक्यम् · PROVENANCE OF THE NAME.
--
-- अभाव · abhāva — absence as a category in its own right: always the absence
-- OF something (its प्रतियोगिन्, counterpositive) and always somewhere.
-- **Kaṇāda, *Vaiśeṣikasūtra* 9.1 (~2nd c. BCE - 2nd c. CE); the fourfold
-- division systematised in Praśastapāda, *Padārthadharmasaṃgraha* (~6th c.);
-- stated compactly in Annaṃbhaṭṭa, *Tarkasaṅgraha* §§57, 80 (~1600).**
--
-- The title line मम-अदर्शनम् ≠ तस्य-अभावः is the अनुपलब्धि condition seen from
-- the other side, and that is MĪMĀṂSĀ, not Nyāya: non-apprehension counts as
-- knowledge only as योग्यानुपलब्धि, non-apprehension of what WOULD have been
-- apprehended — Kumārila Bhaṭṭa, *Ślokavārttika*, abhāvapariccheda (~660).
-- **The two schools do not agree here.**  Mīmāṃsā admits अनुपलब्धि as a
-- pramāṇa; Nyāya does not, and analyses the same cases through प्रतियोगिन्
-- and perception instead.  Taking the Naiyāyika अभाव apparatus and the
-- Mīmāṃsaka अनुपलब्धि as one toolkit is the move CLAUDE.md names — it keeps
-- from each the part that converts and drops the dispute, which here is the
-- content.  Name the school before the term.
--
-- **No claim is made that any of them proved anything below**, and see
-- notes/ABHAVA.md, a primary-text audit against *Tarkasaṅgraha* which
-- CORRECTS a reading of अन्योन्याभाव used elsewhere in this corpus: it is
-- non-identity, NOT observational separation by itself.
--
------------------------------------------------------------------------
-- NaturalMachine.Abhava_MamaAdarsanamNaTasyaAbhavah
--
-- मम-अदर्शनम् ≠ तस्य-अभावः — my not-seeing is not its absence.
--
-- The line is from the transmission captured as
-- `collab/upstream/raw/D0027-net-dm-adhyayana-transmission-2026-08-17.md`,
-- where it stands beside अनुत्तरितम् ≠ अनुत्तरम् (unanswered ≠ unanswerable)
-- and अपरिचितम् ≠ असत् (unfamiliar ≠ nonexistent).  That file is a TEACHING
-- TRANSMISSION and its own provenance note forbids promoting any line of it
-- to a result; nothing here claims to be its content.  What is claimed is
-- that this corpus kept making one particular inference and that the
-- inference is refutable, so the refutation is written down as a term.
--
-- WHY IT EXISTS.  On 2026-08-20 this repository's own machinery was found
-- making the step twice, in two registers, hours apart:
--
--   * `run_the_natural_machine_forever` stamped into the file everyone opens
--     first: "if you are reading this after that time, THE MACHINE IS NOT
--     RUNNING."  What the stamp observes is an absence of recorded cycles.
--     The verdict was false for three and a half days while 976 commits and
--     360 modules landed (5788c92a, 17c4c35f).
--   * and the agent reading it repeated the step to the owner as a report.
--
-- Navya-Nyāya has the discipline: **no bare absences.**  An abhāva carries
-- its *pratiyogin*, the counterpositive — the thing whose absence it is —
-- and, in the developed analysis, its *avacchedaka*, the limitor fixing the
-- respect in which it is absent (`AbhavaAvacchedaka`, in this corpus,
-- already makes the limitor a genuine dependent binder).  "No cycle since T"
-- carries its counterpositive.  "The machine is dead" does not.
--
-- §1 is the negative half: a bare absence does not transport between
-- standpoints.  §2 is the positive half and it is the point — absence DOES
-- transport exactly when the standpoints agree, which is
-- `AllNayasAgree` from `Durnaya_CollapseIffEveryNayaAgrees`.  So the
-- limitor's job is not decoration: it is the hypothesis that makes the
-- inference valid, and an absence reported without it is reporting a
-- standpoint as if it were the object.
--
-- CHECKED: exit code quoted in the commit message.  Agda 2.6.3 + cubical
-- v0.5 in this container, which is NOT the repository pin.
------------------------------------------------------------------------

module NaturalMachine.Abhava_MamaAdarsanamNaTasyaAbhavah where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.Anekanta
open import NaturalMachine.Durnaya_CollapseIffEveryNayaAgrees

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  The negative half.  Two standpoints; from one, nothing is seen.
--     That says nothing about the other.
------------------------------------------------------------------------

-- दृश्यम् — what is visible from a standpoint.  Empty from one, inhabited
-- from the other: the smallest honest picture of a partial view.
Drsya : Bool → Type₀
Drsya true  = ⊥
Drsya false = Unit

-- मम-अदर्शनम् — I do not see it (from the standpoint `true`).
adarsanam : ¬ (Drsya true)
adarsanam ()

-- तस्य-भावः — and it is there (from the standpoint `false`).
tasya-bhavah : Drsya false
tasya-bhavah = tt

-- The inference, refuted.  There is no rule taking not-seeing at one
-- standpoint to absence at another.
bare-absence-does-not-transport :
  ¬ ((s t : Bool) → ¬ (Drsya s) → ¬ (Drsya t))
bare-absence-does-not-transport f = f true false adarsanam tasya-bhavah

------------------------------------------------------------------------
-- 2.  The positive half, which is the content.  Absence transports
--     exactly under the hypothesis the reporter usually leaves out.
------------------------------------------------------------------------

absence-transports-when-the-nayas-agree :
  {S : Type ℓ} (P : S → Type ℓ') → AllNayasAgree P →
  (s t : S) → ¬ (P s) → ¬ (P t)
absence-transports-when-the-nayas-agree P a s t ¬ps pt =
  ¬ps (invEq (a s t) pt)

-- And the witness of §1 is precisely a family whose standpoints do not
-- agree, so the hypothesis of §2 is not idle.
Drsya-nayas-disagree : ¬ (AllNayasAgree Drsya)
Drsya-nayas-disagree a = equivFun (a false true) tt

------------------------------------------------------------------------
-- 3.  What this licenses, stated so it is not over-read.
--
-- LICENSED: report the absence and its counterpositive — "no cycle has
-- been recorded since T" — and stop.  Report the further claim only with
-- the agreement hypothesis discharged, which for an instrument means
-- showing that what it observes separates the states it is being used to
-- decide between.
--
-- NOT LICENSED: that every absence in this corpus is of the §1 kind.  §2
-- is a genuine sufficient condition and plenty of absences here meet it.
-- The claim is only that the hypothesis must be MENTIONED, because the
-- instrument that failed was not wrong about its stamp — it was silent
-- about its hypothesis.
--
-- NOT CLAIMED: any reading of Navya-Nyāya beyond the discipline named in
-- the header.  The pratiyogin/avacchedaka analysis is Gaṅgeśa's tradition
-- and the theorems here are this corpus's; `AbhavaAvacchedaka` is where
-- the limitor is actually modelled, and this module does not restate it.
------------------------------------------------------------------------
