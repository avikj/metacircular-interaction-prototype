{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- à²àà–à¾ â” the ledger's fold.  (lekh, "account/ledger": the term is the
-- repository's own â” àààµà‹ à²àà–à¾-à§à°à, sarakaa-stra à¨à§ â” chosen over a
-- Nyya attribution DELIBERATELY, see the provenance fence below.)
--
-- organism and mapped it onto the Vaieika fourfold of absence.  A
-- later audit STRUCK that mapping â” "these four struck equations were
-- modern constructions, not consequences of the fourfold â¦ the four
-- operational behaviours remain potentially useful as an independently
-- specified event algebra, but their names no longer provide evidence
-- for it.  Proof, refutation, scoped no-go, and separation must be
-- typed from the repository's own evidentiary semantics."
--
-- This module is that independently specified event algebra, checked.
-- It proves the operational claims the strike left standing, and it
-- claims NOTHING about prgabhva or pradhvasbhva â” the struck
-- reading is quoted in ABHAVA.md where it lives, with its strike.
--
-- The theorems, in the repository's own vocabulary:
--
--   1. PENDING IS MADELESS: the pending status holds exactly on the
--      empty log.  No event sustains "not yet decided"; it is what
--      there is before any event, and one proof ends it.
--   2. REFUTATION ABSORBS: once the fold reads refuted, no later
--      event changes the reading.  A refutation cannot be outvoted
--      by enthusiasm â” the absorbing law the organism's design
--      ("genuinely proven conclusions flood; refutations are
--      permanent") requires of its fold.
--   3. A BOOLEAN CANNOT CARRY IT: merge pending and refuted into one
--      "not proved" bit and no transition function on the bit can
--      simulate the fold â” [] and [refute] read equal and diverge
--      under prove.  The two-valued verdict on the three-valued
--      question cannot compute the future; refuted claims would come
--      back to life.  This is the typed zero's founding defect
--      (machinery/crystal's UNDECIDED split; Saptabhangi's à¦àà°àà¨à¯à),
--      here as a âŠ about the ledger itself.
--
-- Provenance fence: whether this algebra matches the Vaieika
-- temporal characterisations (andi/snta for prior absence,
-- sdi/ananta for posterior) is exactly the struck question, and this
-- module supplies no evidence either way.  If someone reopens it, the
-- study to check is named in ABHAVA.md A1 (Matilal 1968).
------------------------------------------------------------------------

module Lekha_TheAppendOnlyFoldAbsorbsRefutationAndABooleanCannotCarryIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List; []; _âˆ·_)
open import Cubical.Data.Bool using (Bool; true; false; trueâ‰¢false)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Data.Sigma using (Î£; _,_)

-- One claim's events.  The log grows at the head: newest first.
data Event : Typeâ‚€ where
  prove  : Event
  refute : Event

Log : Typeâ‚€
Log = List Event

-- The three-valued status â” the typed zero's smallest honest form.
data Status : Typeâ‚€ where
  pending     : Status   -- no event yet
  established : Status   -- proved, not refuted
  refuted     : Status   -- refuted, permanently

-- THE FOLD.  A refutation is terminal; a proof establishes what is
-- not already dead.
step : Status â†’ Status
step refuted = refuted
step _       = established

status : Log â†’ Status
status []             = pending
status (refute âˆ· _)   = refuted
status (prove  âˆ· log) = step (status log)

-- Discriminators, for the disequalities.
isPending isRefuted : Status â†’ Bool
isPending pending = true
isPending _       = false
isRefuted refuted = true
isRefuted _       = false

------------------------------------------------------------------------
-- 1 Â pending is madeless: it holds on the empty log â¦
pending-unbegun : status [] â‰¡ pending
pending-unbegun = refl

-- â¦ and nowhere else.  No event sustains it.
pending-forces-empty : (log : Log) â†’ status log â‰¡ pending â†’ log â‰¡ []
pending-forces-empty []             _ = refl
pending-forces-empty (refute âˆ· _)   p = Empty.rec (trueâ‰¢false (cong isRefuted p))
pending-forces-empty (prove  âˆ· log) p = Empty.rec (step-never-pending (status log) p)
  where
  step-never-pending : (s : Status) â†’ step s â‰¡ pending â†’ âŠ¥
  step-never-pending pending     q = trueâ‰¢false (cong isPending (sym q))
  step-never-pending established q = trueâ‰¢false (cong isPending (sym q))
  step-never-pending refuted     q = trueâ‰¢false (cong isRefuted q)

-- and one proof ends it:
pending-ends : status (prove âˆ· []) â‰¡ established
pending-ends = refl

------------------------------------------------------------------------
-- 2 Â refutation absorbs.  It never holds unbegun â¦
refuted-not-unbegun : status [] â‰¡ refuted â†’ âŠ¥
refuted-not-unbegun p = trueâ‰¢false (cong isPending p)

-- â¦ it begins exactly at a refute â¦
refuted-begins : (log : Log) â†’ status (refute âˆ· log) â‰¡ refuted
refuted-begins _ = refl

-- â¦ and whatever arrives later, it stays.  One case split.
refuted-absorbs : (log : Log) (e : Event)
  â†’ status log â‰¡ refuted â†’ status (e âˆ· log) â‰¡ refuted
refuted-absorbs log refute _ = refl
refuted-absorbs log prove  p = cong step p

------------------------------------------------------------------------
-- 3 Â a boolean cannot carry it.  Merge pending and refuted into one
-- "not proved" bit; no transition function on the bit simulates the
-- fold, because [] and [refute] read equal and diverge under prove.

boolRead : Status â†’ Bool     -- true = "not proved"
boolRead pending     = true
boolRead established = false
boolRead refuted     = true

no-boolean-fold :
  Î£ (Bool â†’ Event â†’ Bool)
    (Î» f â†’ (log : Log) (e : Event)
         â†’ boolRead (status (e âˆ· log)) â‰¡ f (boolRead (status log)) e)
  â†’ âŠ¥
no-boolean-fold (f , h) = trueâ‰¢false (sym on-dead âˆ™ on-fresh)
  where
  -- on the fresh claim, prove must send the bit true â¦ false â¦
  on-fresh : f true prove â‰¡ false
  on-fresh = sym (h [] prove)
  -- â¦ and on the refuted claim, prove must send true â¦ true.
  on-dead : f true prove â‰¡ true
  on-dead = sym (h (refute âˆ· []) prove)
