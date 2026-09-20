{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Pratyabhijna_TheNetworkSeesOnlyTheUnionOfItsQueries
--
-- ‡Æ‡‡≤‡µ‡æ‡ï‡‡Ø‡Æ‡ ¬ the term and where it is stated.
--
--   ‡‡‡∞‡‡‡Ø‡‡ø‡‡‡û‡æ ¬ pratyabhij ‚î RECOGNITIVE cognition, the judgement
--   "‡‡ã‡Ω‡Ø‡ ‡¶‡‡µ‡¶‡‡‡‡", *this is that same Devadatta*: the claim that a
--   thing now presented is the SAME as one presented before.  The term
--   and the stock sentence are common property of the daranas and the
--   dispute over them is live:
--
--     ¬ Naiyyikas class it under pratyaka qualified by memory and use
--       it against momentariness.  Jayanta Bhaa, *Nyyamajar*,
--       c. 9th c.; Vtsyyana, *Nyyabhya*, c. 450, on the tman
--       section of the *Nyyastra*.
--     ¬ Buddhist prama-vda DENIES that it is a prama at all: the
--       two particulars are momentary and distinct, and the "same" is
--       a vikalpa laid over them.  Dharmakrti, *Pramavrttika*,
--       7th c.
--     ¬ Utpaladeva, *varapratyabhijkrik*, c. 900-950, is the term
--       used as the title of a system; Abhinavagupta's *Vimarin*,
--       c. 1000, is its commentary.
--
--   ‡ó‡‡∞‡‡° ¬ abda, declared: no critical edition was opened for this
--   module.  Author, work and century above are reported at second
--   hand; NO stra or verse number is given here, because I have not
--   opened the text to fix one and a guessed number is a fabricated
--   provenance.  The row added to
--   `.claude/hooks/MulaVakya_SourceStatementsForTheTermsInOurFileNames.txt`
--   carries the same limit.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED HERE.  Two things, both short, neither new machinery.
--
-- ¬ß1  POOLING VALIDATORS ADDS NOTHING.  `QuotientFiberLaw`
--     proves that one observer with a finite query list cannot separate
--     a pair its queries are blind on.  A DECENTRALIZED network is a
--     LIST of such observers, and its pooled transcript is the
--     concatenation of theirs.  `blind-++` says blindness is closed
--     under append; `network-no-decision` therefore says: if EVERY
--     validator is blind on (x , y), then no post-processing of the
--     pooled transcript separates them ‚î and `Separates` quantifies
--     over EVERY function `List Bool ‚í Bool`, computable or not, so
--     "post-processing" includes every consensus rule: majority,
--     stake-weighting, reputation, a second round, an appeal.
--
--     This is the checked form of the sentence asserted but not proved
--     protocol can vote a theorem true", narrowed to the case where the
--     theorem in question is an identity: is this the same as that.
--
-- ¬ß2  `sees-exactly` upgrades QuotientFiberLaw's `obs-agree` to an IFF.
--     Blindness of the whole list is EQUIVALENT to equality of
--     transcripts, so the relation a network can see is exactly the
--     kernel of `obs (pool oss)` ‚î the word "exactly" in the law is a
--     theorem here and not an emphasis.
--
-- ¬ß3  ABHIJNA ‚î which side of `f a ‚â° b` is bound, for a digest.
--     Bind `b`: `Œ[ b ] (f a ‚â° b)` is contractible, so "what is the
--     address of this object" needs no consensus and never disagrees.
--     Bind `a`: `Address b = Œ[ a ] (f a ‚â° b)` is the PREIMAGE and is
--     arbitrary.  Content addressing is the assertion that THIS fibre
--     is contractible, and `addressed` decomposes that assertion into
--     its two independent halves: `Address b` inhabited is
--     AVAILABILITY, `isProp (Address b)` is COLLISION-FREEDOM.  Neither
--     implies the other and their conjunction is exactly `isContr`.
--
--     The empty / one / many trichotomy this exposes is NOT graded here
--     vyamNotNasti.md already grades it in five levels and shows that
--     `isContr`'s two-valued verdict merges the two ENDS.  This module
--     supplies only the network instance of its rows ‡¶ and ‡ß.
------------------------------------------------------------------------

module Pratyabhijna_TheNetworkSeesOnlyTheUnionOfItsQueries where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using (List ; [] ; _‚à∑_ ; _++_)
open import Cubical.Data.List.Properties using (cons-inj‚ÇÅ ; cons-inj‚ÇÇ)
open import Cubical.Relation.Nullary using (¬¨_)

open import QuotientFiberLaw using (module Law)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ¬ß1-2  ‡‡ô‡‡ò ‚î the assembly.  Many validators, one pooled transcript.
------------------------------------------------------------------------

module Sangha (X : Type ‚Ñì) where

  open Law X public

  -- A decentralized network, as far as identity is concerned, is just a
  -- list of read-sets.  Who runs them, in what order, under what stake,
  -- does not appear ‚î and that absence is the content of ¬ß1.
  Validators : Type ‚Ñì
  Validators = List (List Query)

  pool : Validators ‚Üí List Query
  pool []         = []
  pool (os ‚à∑ oss) = os ++ pool oss

  EachBlind : Validators ‚Üí X ‚Üí X ‚Üí Type
  EachBlind []         x y = Unit
  EachBlind (os ‚à∑ oss) x y = AllBlind os x y √ó EachBlind oss x y

  blind-++ : (os ps : List Query) (x y : X)
           ‚Üí AllBlind os x y ‚Üí AllBlind ps x y ‚Üí AllBlind (os ++ ps) x y
  blind-++ []       ps x y tt       q = q
  blind-++ (o ‚à∑ os) ps x y (b , bs) q = b , blind-++ os ps x y bs q

  blind-pool : (oss : Validators) (x y : X)
             ‚Üí EachBlind oss x y ‚Üí AllBlind (pool oss) x y
  blind-pool []         x y tt       = tt
  blind-pool (os ‚à∑ oss) x y (b , bs) =
    blind-++ os (pool oss) x y b (blind-pool oss x y bs)

  -- THE STATEMENT.  Every validator blind ‚í the ASSEMBLY is blind, and
  -- `Separates` quantifies over every possible reading of the pooled
  -- transcript, so no consensus rule whatsoever recovers the difference.
  network-no-decision : (oss : Validators) (x y : X)
                      ‚Üí EachBlind oss x y ‚Üí ¬¨ Separates (pool oss) x y
  network-no-decision oss x y bs =
    no-decision (pool oss) x y (blind-pool oss x y bs)

  -- ‚¶and the only repair is a NEW READ.  Adding a validator helps
  -- exactly when its query list is charged on the pair; this is
  -- `charged‚íseparator` applied to the pooled list, i.e. the assembly's
  -- power is the union of its members' queries and nothing else.
  --
  -- The converse half, `blind-of-obs`, is what makes "exactly" a
  -- theorem: the relation seen is precisely the kernel of the pooled
  -- transcript map.
  blind-of-obs : (os : List Query) (x y : X)
               ‚Üí obs os x ‚â° obs os y ‚Üí AllBlind os x y
  blind-of-obs []       x y p = tt
  blind-of-obs (o ‚à∑ os) x y p = cons-inj‚ÇÅ p , blind-of-obs os x y (cons-inj‚ÇÇ p)

  sees-exactly : (os : List Query) (x y : X)
               ‚Üí (AllBlind os x y ‚Üí obs os x ‚â° obs os y)
               √ó (obs os x ‚â° obs os y ‚Üí AllBlind os x y)
  sees-exactly os x y = obs-agree os x y , blind-of-obs os x y

------------------------------------------------------------------------
-- ¬ß3  ‡‡‡ø‡‡‡û‡æ‡® ‚î the token of recognition.  A digest, read as a fibre.
------------------------------------------------------------------------

module Abhijnana {A B : Type ‚Ñì} (f : A ‚Üí B) where

  -- Bind b.  "What is the address of this object?"  Contractible: one
  -- answer, and the space of answers has no further structure.  This is
  -- the ONLY question a Merkle DAG of bytes asks, and it is free.
  digest-isContr : (a : A) ‚Üí isContr (Œ£[ b ‚àà B ] (f a ‚â° b))
  digest-isContr a = isContrSingl (f a)

  -- Bind a.  "Which object does this address name?"  A preimage.  This
  -- is the question a network actually has to answer and nothing makes
  -- it contractible for free.
  Address : B ‚Üí Type ‚Ñì
  Address b = Œ£[ a ‚àà A ] (f a ‚â° b)

  -- Content addressing works at b ‚ü∫ this fibre is contractible, and
  -- that decomposes into two independent halves.
  available      : (b : B) ‚Üí isContr (Address b) ‚Üí Address b
  available b c = c .fst

  collision-free : (b : B) ‚Üí isContr (Address b) ‚Üí isProp (Address b)
  collision-free b = isContr‚ÜíisProp

  addressed : (b : B) ‚Üí Address b ‚Üí isProp (Address b) ‚Üí isContr (Address b)
  addressed b a p = a , p a
