{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Kernel.Vyabhicara_OneEnvironmentWhereItFailsForbidsTheDerivation
--                   EntirelySoTheSixCoordinatesAreNeverIdentified
--
-- TERM, AND THE SCHOOL IS NYĀYA, NAMED BEFORE THE TERM IS USED.
--
-- व्यभिचार · vyabhicāra -- straying, deviation.  A hetu that is found where
-- the sādhya is absent is सव्यभिचार, and Gautama's *Nyāyasūtra* (~2nd c. CE)
-- lists it first among the hetvābhāsas and defines it in three words:
--
--     अनैकान्तिकः सव्यभिचारः     anaikāntikaḥ savyabhicāraḥ
--
-- CORRECTED 2026-08-25 against the e-text.  I first wrote this as
-- ~~savyabhicāro 'naikāntikaḥ~~, THE WORDS IN REVERSE ORDER, from memory.
-- GRETIL's `sa_gautama-nyAyasUtra.txt` line 204 reads `1.2.5:
-- anaikāntikaḥ savyabhicāraḥ`, and line 200 is 1.2.4, the hetvābhāsa
-- list.  Cloned from the INDOLOGY/tokushige-koyasan GitHub mirror, since
-- GRETIL's own host answers 403 here.  This file's own thesis is that a
-- number propagates where words do not; I had the number right and the
-- words wrong, which is the same defect one level in.
--
-- I give the words rather than lean on the number, per this repository's
-- own finding that a sūtra's number propagates through citation while its
-- words appear only where someone opened the text.  The received placement
-- is in the hetvābhāsa passage of adhyāya 1, pāda 2; I do not pin it.  The
-- definitional apparatus for vyāpti and its defeat is much later --
-- Gaṅgeśa, *Tattvacintāmaṇi*, vyāptivāda (~1325) -- and none of it is
-- claimed for anything proved below.  `Vyapti_…` in this directory is the
-- sibling module and uses the same school's vocabulary.
--
-- AND THE DISPUTE, WHICH IS THE POINT AND MUST NOT BE FLATTENED.
--
-- Gautama's name for the fault is अनैकान्तिक · anaikāntika -- literally
-- not-one-endedness.  The Jainas' name for their central doctrine is
-- अनेकान्त · anekānta, the same root, and they mean it as the structure of
-- the real.  So the SAME CONFIGURATION -- a claim that holds under one
-- upādhi and fails under another -- is for the Naiyāyika a defect that
-- destroys the inference, and for the Jaina the first two bhaṅgas of the
-- saptabhaṅgī, both determinate, both retained.  The Jaina logicians were
-- answering the charge that anekānta is merely anaikāntika, at length, for
-- centuries; Akalaṅka and Vidyānanda are where that argument lives.
--
-- §2 BELOW IS THE NAIYĀYIKA READING AND IT IS A THEOREM.  §3 exhibits the
-- same pair under both upādhis, which is what the Jaina reading keeps.
-- NOTHING HERE ADJUDICATES BETWEEN THEM.  The two schools reject each
-- other's categories and this file does not blend them into one toolkit;
-- it states which reading each section is, and stops.
--
------------------------------------------------------------------------
-- WHAT WAS OPEN.
--
-- `RewriteCertificate` states a design rationale in a comment and never
-- proves it:
--
--     "Keeping all six coordinates distinct matters: identifying them
--      would prove only equality on the diagonal."
--
-- That is a claim about what this calculus CANNOT derive, and prose is not
-- a source for an absence.  Nothing in the corpus exhibits an uninhabited
-- `Derivation`.  §1 gives the general instrument in one line and §2 uses
-- it, so the comment becomes a checked non-existence with a command behind
-- it rather than a rationale nobody tested.
--
------------------------------------------------------------------------
-- WHAT IS PROVED.
--
--   §1  vyabhicara -- ONE environment at which the meanings differ forbids
--       a derivation entirely.  It is `derivation-sound` read backwards,
--       and it is one line, which is the whole reason the kernel's
--       soundness quantifies over every ρ instead of holding at one.
--   §2  var is derivably identified with none of the other five
--       coordinates; and yvar with zvar, so the fact is not about `var`.
--   §3  the same pair, asti at one upādhi and nāsti at another, both
--       checked -- the configuration §2 reads as a fault.
--
-- WHAT IS NOT PROVED, and each is an omission I am naming rather than a
-- gap I am hiding:
--   * THE REMAINING PAIRS.  Fifteen ordered-unordered pairs exist among
--     six coordinates and six are written out.  Every other one is the
--     same two lines with a different environment; I did not write them
--     and so I do not claim them.
--   * ANY UNDERIVABILITY THAT IS NOT SEMANTIC.  §1 defeats exactly those
--     claims that are false at some environment.  A pair that is true at
--     EVERY environment and still underivable -- commutativity of `add` is
--     the obvious candidate -- is out of this instrument's reach entirely,
--     and needs an invariant on `Step`, which is not here.  `Naya_…` in
--     this directory supplies exactly that invariant and settles it.
--   * nothing about `Step` for a fixed pair, and no decision procedure.
--
-- CHECKED.  Agda 2.6.3 + cubical v0.5, `--safe`, no postulates, no holes,
-- exit 0 at the previous module path.  Module name and imports were renamed
-- to `Kernel.*` to match this directory; that rename has not been re-run at
-- the repository pin (2.8.0 + v0.9).
------------------------------------------------------------------------

module Kernel.Vyabhicara_OneEnvironmentWhereItFailsForbidsTheDerivationEntirelySoTheSixCoordinatesAreNeverIdentified where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots)
import Cubical.Data.Empty as E

open import RewriteCertificate

------------------------------------------------------------------------
-- §1.  THE INSTRUMENT.  `derivation-sound` says a derivation holds at
--      EVERY environment.  Contrapose it: deviation at ONE forbids the
--      derivation at all.  This is why the quantifier in the kernel's
--      soundness is where it is -- move it inside and `install` would
--      accept operations that are false off one point.
------------------------------------------------------------------------

vyabhicara : {a b : Tm} (ρ : Env)
           → (eval a ρ ≡ eval b ρ → E.⊥)
           → Derivation a b → E.⊥
vyabhicara ρ ne d = ne (derivation-sound d ρ)

------------------------------------------------------------------------
-- §2.  THE COMMENT IN `RewriteCertificate`, PROVED.  One environment
--      separates each pair: set the first coordinate to 0 and the second
--      to 1 and leave the rest anywhere.
------------------------------------------------------------------------

var≢yvar : Derivation var yvar → E.⊥
var≢yvar = vyabhicara (env 0 1 0 0 0 0) znots

var≢zvar : Derivation var zvar → E.⊥
var≢zvar = vyabhicara (env 0 0 1 0 0 0) znots

var≢uvar : Derivation var uvar → E.⊥
var≢uvar = vyabhicara (env 0 0 0 1 0 0) znots

var≢vvar : Derivation var vvar → E.⊥
var≢vvar = vyabhicara (env 0 0 0 0 1 0) znots

var≢wvar : Derivation var wvar → E.⊥
var≢wvar = vyabhicara (env 0 0 0 0 0 1) znots

-- and it is not a fact about `var`.
yvar≢zvar : Derivation yvar zvar → E.⊥
yvar≢zvar = vyabhicara (env 0 0 1 0 0 0) znots

------------------------------------------------------------------------
-- §3.  THE SAME PAIR UNDER BOTH UPĀDHIS.  §2 is the Naiyāyika reading --
--      deviation, therefore no inference.  What the configuration itself
--      contains is this: a determinate holding, and a determinate failing,
--      of one claim about one pair, at two conditions.  Both are checked.
------------------------------------------------------------------------

asti : eval var (env 0 0 0 0 0 0) ≡ eval yvar (env 0 0 0 0 0 0)
asti = refl

nasti : eval var (env 0 1 0 0 0 0) ≡ eval yvar (env 0 1 0 0 0 0) → E.⊥
nasti = znots

-- Taken in succession those two are expressible by construction; taken
-- jointly they would be a square over a pair of environments, and this
-- calculus has no constructor for that.  Which of those two readings the
-- configuration deserves is the dispute named in the header, and is not
-- settled here.
