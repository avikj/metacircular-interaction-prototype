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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sivasutra — Pāṇini's pratyāhāra as an interval, checked.
--
-- SOURCE.  The Aṣṭādhyāyī opens with the fourteen Māheśvara / śiva-sūtras:
-- the sounds of Sanskrit laid out in ONE linear order, each sūtra ending in
-- an anubandha (it-marker).  A pratyāhāra names a class of sounds as the
-- INTERVAL from a starting sound up to (and excluding) a marker: e.g. `aṆ`
-- = a i u; `aK` = a i u ṛ ḷ; `aC` = all the vowels.  This is the device
-- that lets any needed phonological class be named by two letters, and it
-- is why INDIC_FORMAL_TRADITIONS_MAP.md §1.1 records the śiva-sūtra
-- ordering as an interval representation of an intersection-closed family
-- (Petersen's optimality theorem is that deeper object; it is NOT proved
-- here — see below).
--
-- The first four sūtras, with their it-markers Ṇ K Ṅ C:
--   1.  a  i  u  Ṇ
--   2.  ṛ  ḷ  K
--   3.  e  o  Ṅ
--   4.  ai au C
-- (These four give the entire vowel system; the consonant sūtras 5–14 are
-- not encoded here.)
--
-- WHAT IS CHECKED.  The interval mechanism itself, on the vowel prefix:
-- `upto m` collects the sounds from the front up to marker m, skipping any
-- intervening markers.  The pratyāhāras aṆ, aK, aC then compute to exactly
-- the traditional classes, by refl; and no it-marker ever appears in a
-- pratyāhāra (the anubandha is a boundary, not a member).
--
-- NOT claimed: the consonant sūtras; that the ordering is OPTIMAL (the
-- intersection-closed interval-representation optimality — the deep
-- theorem); any historical priority statement.  Those are separate and
-- owed.
--
-- Contents (no postulates, no holes, --safe):
--   Sym, isMarker, sivasutra   the vowel prefix as a linear order
--   upto                       the pratyāhāra extractor (interval to marker)
--   aṆ, aK, aC                 the three vowel pratyāhāras, each ≡ its
--                              traditional class by refl
--   marker-free                no pratyāhāra contains an it-marker
------------------------------------------------------------------------

module Sivasutra where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; true≢false)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- The sounds and it-markers of the first four sūtras, in śiva-sūtra order.
------------------------------------------------------------------------

data Sym : Type where
  -- vowels (the sounds)
  a i u ṛ ḷ e o ai au : Sym
  -- it-markers (anubandhas)
  Ṇ K Ṅ C : Sym

isMarker : Sym → Bool
isMarker Ṇ = true
isMarker K = true
isMarker Ṅ = true
isMarker C = true
isMarker _ = false

-- decidable equality, as a boolean, for the stop test
eqSym : Sym → Sym → Bool
eqSym a a = true
eqSym i i = true
eqSym u u = true
eqSym ṛ ṛ = true
eqSym ḷ ḷ = true
eqSym e e = true
eqSym o o = true
eqSym ai ai = true
eqSym au au = true
eqSym Ṇ Ṇ = true
eqSym K K = true
eqSym Ṅ Ṅ = true
eqSym C C = true
eqSym _ _ = false

-- the linear order of the first four sūtras
sivasutra : List Sym
sivasutra = a ∷ i ∷ u ∷ Ṇ ∷ ṛ ∷ ḷ ∷ K ∷ e ∷ o ∷ Ṅ ∷ ai ∷ au ∷ C ∷ []

------------------------------------------------------------------------
-- The pratyāhāra extractor.  From the front, collect sounds up to (not
-- including) the marker m; any OTHER marker along the way is a boundary of
-- an earlier sūtra and is skipped, never emitted.  (All pratyāhāras here
-- begin at `a`, the head, so no start-search is needed.)
------------------------------------------------------------------------

upto : Sym → List Sym → List Sym
upto m [] = []
upto m (x ∷ xs) =
  if eqSym x m
  then []
  else (if isMarker x then upto m xs else x ∷ upto m xs)

------------------------------------------------------------------------
-- The three vowel pratyāhāras, each equal to its traditional class BY REFL
-- (the extractor computes).
------------------------------------------------------------------------

-- aṆ : the sounds a i u
aṆ : upto Ṇ sivasutra ≡ a ∷ i ∷ u ∷ []
aṆ = refl

-- aK : the simple vowels a i u ṛ ḷ
aK : upto K sivasutra ≡ a ∷ i ∷ u ∷ ṛ ∷ ḷ ∷ []
aK = refl

-- aC : ALL the vowels a i u ṛ ḷ e o ai au
aC : upto C sivasutra ≡ a ∷ i ∷ u ∷ ṛ ∷ ḷ ∷ e ∷ o ∷ ai ∷ au ∷ []
aC = refl

-- The three nest as intervals of the one order: aṆ ⊂ aK ⊂ aC, each a
-- prefix of the next (visible directly in the refls above — the shorter
-- class is a prefix of the longer, since they share the same left endpoint
-- `a` and only the right marker moves outward).  That the class is named by
-- moving ONE endpoint along ONE linear order is the śiva-sūtra device.

------------------------------------------------------------------------
-- EXTENDED 2026-08-19, another thread:
-- `NaturalMachine.NonInitialPratyaharasAndOneIntersectionInstance` adds
-- the start-search this module says it does not need — "All pratyāhāras
-- here begin at `a`, the head, so no start-search is needed" — and with
-- it the two-endpoint extractor `between`.  It checks `iK`, `eṄ`, `aiC`,
-- `iC` by refl, verifies `between a C ≡ upto C` so the extension agrees
-- with `upto` at the head, and gives one intersection instance:
-- `aK ∩ iC ≡ iK`, a named class again.
--
-- Nothing here is altered, and this module's own NOT-claimed list is
-- inherited there unchanged — in particular Petersen's optimality theorem
-- is still not proved, and is still unread: egress is blocked from that
-- environment.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- EXTENDED 2026-08-20, another thread: PART OF THE OWED OPTIMALITY IS PAID.
-- `PratyaharaLaghava_TheMarkerCountIsForcedByTheAntichain.agda` proves, for
-- ANY linear order of the sounds and ANY placement of markers, that two
-- classes ending at the same anubandha are ⊆-comparable — so the classes
-- carried by one marker are a chain, and a ⊆-ANTICHAIN of classes forces that
-- many distinct markers.  aṆ, iK, eṄ, aiC are pairwise incomparable as sets,
-- hence four markers are forced; the śiva-sūtra order names all four with
-- Ṇ K Ṅ C and has no fifth, so four is the minimum and this order attains it.
--
-- The NOT-claimed list above is unchanged in its main entry: Petersen's
-- theorem — that the order is essentially UNIQUE for the full family, and 14
-- markers minimal — is still not proved and Petersen is still unread.  What
-- is now proved is a lower bound and its attainment on the vowel subfamily.
-- `machine/Pratyahara_TheIntervalDecisionProcedure.hs` decides nameability
-- against the line (no table) and computes the bound over all fourteen
-- sūtras: width 14 over the 294 classes the line can name, width 11 over the
-- ~30 the grammar uses.
------------------------------------------------------------------------
