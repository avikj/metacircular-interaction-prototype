{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Kernel.Vyabhicara_OneEnvironmentWhereItFailsForbidsTheDerivation
--                   EntirelySoTheSixCoordinatesAreNeverIdentified
--
-- TERM, AND THE SCHOOL IS NYYA, NAMED BEFORE THE TERM IS USED.
--
-- ‡µ‡‡Ø‡‡ø‡‡æ‡∞ ¬ vyabhicra -- straying, deviation.  A hetu that is found where
-- the sdhya is absent is ‡‡µ‡‡Ø‡‡ø‡‡æ‡∞, and Gautama's *Nyyastra* (~2nd c. CE)
-- lists it first among the hetvbhsas and defines it in three words:
--
--     ‡‡®‡à‡ï‡æ‡®‡‡‡ø‡ï‡ ‡‡µ‡‡Ø‡‡ø‡‡æ‡∞‡     anaikntika savyabhicra
--
-- CORRECTED 2026-08-25 against the e-text.  I first wrote this as
-- ~~savyabhicro 'naikntika~~, THE WORDS IN REVERSE ORDER, from memory.
-- GRETIL's `sa_gautama-nyAyasUtra.txt` line 204 reads `1.2.5:
-- anaikntika savyabhicra`, and line 200 is 1.2.4, the hetvbhsa
-- list.  Cloned from the INDOLOGY/tokushige-koyasan GitHub mirror, since
-- GRETIL's own host answers 403 here.  This file's own thesis is that a
-- number propagates where words do not; I had the number right and the
-- words wrong, which is the same defect one level in.
--
-- I give the words rather than lean on the number, per this repository's
-- own finding that a stra's number propagates through citation while its
-- words appear only where someone opened the text.  The received placement
-- is in the hetvbhsa passage of adhyya 1, pda 2; I do not pin it.  The
-- definitional apparatus for vypti and its defeat is much later --
-- Gagea, *Tattvacintmai*, vyptivda (~1325) -- and none of it is
-- claimed for anything proved below.  `Vyapti_‚¶` in this directory is the
-- sibling module and uses the same school's vocabulary.
--
-- AND THE DISPUTE, WHICH IS THE POINT AND MUST NOT BE FLATTENED.
--
-- Gautama's name for the fault is ‡‡®‡à‡ï‡æ‡®‡‡‡ø‡ï ¬ anaikntika -- literally
-- not-one-endedness.  The Jainas' name for their central doctrine is
-- ‡‡®‡‡ï‡æ‡®‡‡ ¬ aneknta, the same root, and they mean it as the structure of
-- the real.  So the SAME CONFIGURATION -- a claim that holds under one
-- updhi and fails under another -- is for the Naiyyika a defect that
-- destroys the inference, and for the Jaina the first two bhagas of the
-- saptabhag, both determinate, both retained.  The Jaina logicians were
-- answering the charge that aneknta is merely anaikntika, at length, for
-- centuries; Akalaka and Vidynanda are where that argument lives.
--
-- ¬ß2 BELOW IS THE NAIYYIKA READING AND IT IS A THEOREM.  ¬ß3 exhibits the
-- same pair under both updhis, which is what the Jaina reading keeps.
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
-- `Derivation`.  ¬ß1 gives the general instrument in one line and ¬ß2 uses
-- it, so the comment becomes a checked non-existence with a command behind
-- it rather than a rationale nobody tested.
--
------------------------------------------------------------------------
-- WHAT IS PROVED.
--
--   ¬ß1  vyabhicara -- ONE environment at which the meanings differ forbids
--       a derivation entirely.  It is `derivation-sound` read backwards,
--       and it is one line, which is the whole reason the kernel's
--       soundness quantifies over every œ instead of holding at one.
--   ¬ß2  var is derivably identified with none of the other five
--       coordinates; and yvar with zvar, so the fact is not about `var`.
--   ¬ß3  the same pair, asti at one updhi and nsti at another, both
--       checked -- the configuration ¬ß2 reads as a fault.
--
-- CHECKED.  Agda 2.6.3 + cubical v0.5, `--safe`, no postulates, no holes,
-- exit 0 at the previous module path.  Module name and imports were renamed
-- to `Kernel.*` to match this directory; that rename has not been re-run at
-- the repository pin (2.8.0 + v0.9).
------------------------------------------------------------------------

module Kernel.Vyabhicara_OneEnvironmentWhereItFailsForbidsTheDerivationEntirelySoTheSixCoordinatesAreNeverIdentified where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; znots)
import Cubical.Data.Empty as E

open import RewriteCertificate

------------------------------------------------------------------------
-- ¬ß1.  THE INSTRUMENT.  `derivation-sound` says a derivation holds at
--      EVERY environment.  Contrapose it: deviation at ONE forbids the
--      derivation at all.  This is why the quantifier in the kernel's
--      soundness is where it is -- move it inside and `install` would
--      accept operations that are false off one point.
------------------------------------------------------------------------

vyabhicara : {a b : Tm} (œÅ : Env)
           ‚Üí (eval a œÅ ‚â° eval b œÅ ‚Üí E.‚ä•)
           ‚Üí Derivation a b ‚Üí E.‚ä•
vyabhicara œÅ ne d = ne (derivation-sound d œÅ)

------------------------------------------------------------------------
-- ¬ß2.  THE COMMENT IN `RewriteCertificate`, PROVED.  One environment
--      separates each pair: set the first coordinate to 0 and the second
--      to 1 and leave the rest anywhere.
------------------------------------------------------------------------

var‚â¢yvar : Derivation var yvar ‚Üí E.‚ä•
var‚â¢yvar = vyabhicara (env 0 1 0 0 0 0) znots

var‚â¢zvar : Derivation var zvar ‚Üí E.‚ä•
var‚â¢zvar = vyabhicara (env 0 0 1 0 0 0) znots

var‚â¢uvar : Derivation var uvar ‚Üí E.‚ä•
var‚â¢uvar = vyabhicara (env 0 0 0 1 0 0) znots

var‚â¢vvar : Derivation var vvar ‚Üí E.‚ä•
var‚â¢vvar = vyabhicara (env 0 0 0 0 1 0) znots

var‚â¢wvar : Derivation var wvar ‚Üí E.‚ä•
var‚â¢wvar = vyabhicara (env 0 0 0 0 0 1) znots

-- and it is not a fact about `var`.
yvar‚â¢zvar : Derivation yvar zvar ‚Üí E.‚ä•
yvar‚â¢zvar = vyabhicara (env 0 0 1 0 0 0) znots

------------------------------------------------------------------------
-- ¬ß3.  THE SAME PAIR UNDER BOTH UPDHIS.  ¬ß2 is the Naiyyika reading --
--      deviation, therefore no inference.  What the configuration itself
--      contains is this: a determinate holding, and a determinate failing,
--      of one claim about one pair, at two conditions.  Both are checked.
------------------------------------------------------------------------

asti : eval var (env 0 0 0 0 0 0) ‚â° eval yvar (env 0 0 0 0 0 0)
asti = refl

nasti : eval var (env 0 1 0 0 0 0) ‚â° eval yvar (env 0 1 0 0 0 0) ‚Üí E.‚ä•
nasti = znots

-- Taken in succession those two are expressible by construction; taken
-- jointly they would be a square over a pair of environments, and this
-- calculus has no constructor for that.  Which of those two readings the
-- configuration deserves is the dispute named in the header, and is not
-- settled here.
