{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡µ‡‡‡‡‡ø‡‡‡‡ ‚î the remainder of the turning-back.
--
-- TERM.  ‡‡µ‡‡‡‡‡ø (vtti), repetition / a turning back over the same
-- ground, and ‡‡‡ (ea), what is left over.  Both are used in their
-- ordinary technical senses.  ‡‡‡ in the sense this file uses ‚î the remainder is kept and is
-- the material of the next step ‚î is ryabhaa, ryabhaya, ‡ó‡‡ø‡‡‡æ‡¶
-- 32‚ì33 (499 CE), the kuaka; the mathematics below is not his.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS SETTLES.
--
-- Three files in this repository state one fact about the kernel and
-- none of them cites another:
--
--   Yantra_‚¶            the computer is a GROUPOID: `A ‚â A` fills the
--                       monoid interface AND the inverse field, and every
--                       law holds by `equivEq refl` ‚î strictly.
--   Avirodha_‚¶          the kernel is "strictly a category, weakly a
--                       groupoid", and "the gap between the two is the
--                       ea" ‚î but the weakness is exhibited only by
--                       `the-round-trip-is-not-nothing`, an observation
--                       about `len`, not a statement in the path type.
--   Asesa_‚¶             `Meaning a b` is a PROPOSITION, so the fibre of
--                       soundness over any meaning is the WHOLE
--                       derivation type, and soundness is refutably not
--                       an equivalence at the kernel's own seed.
--
-- A remark about `len` is weaker than it looks: `len` is a function of
-- the derivation, so "the round trip has positive length" leaves open
-- that SOME OTHER inverse ‚î not `rev` ‚î might close it on the nose.
-- ¬ß3 removes that.  It quantifies over every function whatsoever:
--
--     the-kernel-carries-no-inverse :
--       (inv : Derivation A A ‚í Derivation A A)
--       ‚í ((d : Derivation A A) ‚í d ‚äï inv d ‚â° done A) ‚í ‚ä
--
-- so the failure is a property OF THE KERNEL'S COMPOSITION, not a defect
-- of the particular `rev` that Avirodha_ happens to define.
--
-- ¬ß4 puts the two sides on ONE interface, `MonoidMachine` imported from
-- `Yantra_‚¶` rather than restated, so the comparison is between the same
-- record and not between two spellings of it:
--
--     equivalences-carry-an-inverse : (A : Type ‚ì) ‚í GroupoidOver (‡‡ï‡‡‡µ‡Æ‡ A)
--     the-kernel-carries-none       : ¬ GroupoidOver ‡‡µ‡‡‡‡‡ø‡
--
-- SAME INTERFACE.  One side fills it; the other provably cannot.  That
-- difference is the whole of what the kernel keeps and `_‚â_` throws away,
-- and by `Asesa_‚¶` it is invisible to meaning: the two derivations that
-- separate the fibre have EQUAL meanings, because the meaning type is a
-- proposition and has no two positions in it.
--
------------------------------------------------------------------------

module AvrttiSesa_TheKernelFillsTheMonoidStrictlyAndCarriesNoGroupoidSoTheRoundTripIsTheResidue where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using ( _‚âÉ_ ; idEquiv ; compEquiv ; invEquiv
        ; compEquivIdEquiv ; compEquivEquivId ; compEquiv-assoc
        ; invEquiv-is-rinv ; invEquiv-is-linv )
open import Cubical.Data.Nat using (‚Ñï ; snotz ; _+_)
import Cubical.Data.Nat as N
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_)
open import Cubical.Relation.Nullary using (¬¨_)

open import RewriteCertificate
  using (Tm ; var ; zero ; add ; Step ; add-zero ; reverse
        ; Derivation ; done ; then-step)
open import TheDerivationCarriesNoMeaningAtAllSoAllOfItIsRemainder
  using (len)
open import TheKernelIsAnInteractiveSystemAndTheSessionRetiresIntoOneOperation
  using (_‚äï_)
open import TheKernelIsAReversibleGroupoidWhoseJoinIsConflictFreeSoConsensusOnMeaningIsVacuous
  using (‚äï-assoc ; ‚äï-unitÀ° ; ‚äï-unit ≥)
open import Yantra_TheComputerIsTheGroupoidOfProofsOfTransportNotTheMonoidOfIrreversibleSteps
  using (MonoidMachine)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ¬ß1  THE INVERSE, AS A STRUCTURE OVER A GIVEN MONOID.
--
-- Not a fresh record.  `Yantra_‚¶`'s `GroupoidMachine` bundles its monoid
-- as a field, which makes "does THIS monoid admit an inverse?" awkward to
-- ask.  Asking it is the whole business here, so the inverse is indexed
-- by the monoid it would extend.
------------------------------------------------------------------------

GroupoidOver : {Op : Type ‚Ñì} ‚Üí MonoidMachine Op ‚Üí Type ‚Ñì
GroupoidOver {Op = Op} M =
  Œ£[ inv ‚àà (Op ‚Üí Op) ]
    ( ((x : Op) ‚Üí MonoidMachine.seq M x (inv x) ‚â° MonoidMachine.noop M)
    √ó ((x : Op) ‚Üí MonoidMachine.seq M (inv x) x ‚â° MonoidMachine.noop M) )

------------------------------------------------------------------------
-- ¬ß2  THE KERNEL'S DERIVATIONS FILL THE MONOID INTERFACE ‚î STRICTLY.
--
-- Every field is `Avirodha_‚¶`'s term, unchanged.  Nothing is reproved;
-- the point of the record is that the SAME interface is offered to both
-- sides in ¬ß4, so what ¬ß3 excludes is excluded on it.
------------------------------------------------------------------------

A : Tm
A = add var zero

‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : MonoidMachine (Derivation A A)
‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É = record
  { seq   = _‚äï_
  ; noop  = done A
  ; unitL = ‚äï-unitÀ°
  ; unitR = ‚äï-unit ≥
  ; assoc = ‚äï-assoc }

------------------------------------------------------------------------
-- ¬ß3  AND CARRY NO INVERSE ‚î FOR EVERY CANDIDATE, NOT ONLY FOR `rev`.
--
-- The measure first: concatenation adds lengths.  This is the lemma the
-- `len` remark in `Avirodha_‚¶` needed and did not have; with it, the
-- refutation quantifies over all of `Derivation A A ‚í Derivation A A`.
------------------------------------------------------------------------

len-‚äï :
  {a b c : Tm} (d : Derivation a b) (e : Derivation b c)
  ‚Üí len (d ‚äï e) ‚â° len d + len e
len-‚äï (done _)        e = refl
len-‚äï (then-step p d) e = cong N.suc (len-‚äï d e)

-- One step of the kernel, and its reversal.  `add-zero var : Step (add
-- var zero) var`, so this goes out and comes back: a derivation from `A`
-- to `A` that is not `done A`.
‡§∏‡•ã‡§™‡§æ‡§®‡§Æ‡•ç : Step A var
‡§∏‡•ã‡§™‡§æ‡§®‡§Æ‡•ç = add-zero var

‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç : Derivation A A
‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç = then-step ‡§∏‡•ã‡§™‡§æ‡§®‡§Æ‡•ç (then-step (reverse ‡§∏‡•ã‡§™‡§æ‡§®‡§Æ‡•ç) (done A))

-- and its length is not zero ‚î the round trip is not nothing.
‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§∏‡•ç‡§Ø-‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ : len ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç ‚â° N.suc (N.suc N.zero)
‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§∏‡•ç‡§Ø-‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ = refl

-- THE EXCLUSION.  No function inverts the kernel's composition, because
-- composition can only ADD length and `done` has none.  The hypothesis is
-- used at exactly one point, and one point is enough.
the-kernel-carries-no-inverse :
  (inv : Derivation A A ‚Üí Derivation A A)
  ‚Üí ((d : Derivation A A) ‚Üí d ‚äï inv d ‚â° done A) ‚Üí ‚ä•
the-kernel-carries-no-inverse inv law =
  snotz (sym (len-‚äï ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç (inv ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç)) ‚àô cong len (law ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§Æ‡•ç))

------------------------------------------------------------------------
-- ¬ß4  THE TWO SIDES, ON ONE INTERFACE.
--
-- `A ‚â A` fills the inverse field; the kernel's derivations cannot.  The
-- monoid structure is the same record in both cases, so this is a
-- comparison and not an analogy.
------------------------------------------------------------------------

‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç : (X : Type ‚Ñì) ‚Üí MonoidMachine (X ‚âÉ X)
‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç X = record
  { seq   = compEquiv
  ; noop  = idEquiv X
  ; unitL = compEquivIdEquiv
  ; unitR = compEquivEquivId
  ; assoc = Œª p q r ‚Üí sym (compEquiv-assoc p q r) }

equivalences-carry-an-inverse : (X : Type ‚Ñì) ‚Üí GroupoidOver (‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç X)
equivalences-carry-an-inverse X =
  invEquiv , invEquiv-is-rinv , invEquiv-is-linv

the-kernel-carries-none : ¬¨ GroupoidOver ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É
the-kernel-carries-none (inv , rinv , _) =
  the-kernel-carries-no-inverse inv rinv

------------------------------------------------------------------------
-- ¬ß5  WHAT THE DIFFERENCE IS.
--
-- `_‚â_` composes and inverts and keeps nothing: `invEquiv-is-rinv` says
-- the round trip IS the no-op, on the nose, so an equivalence groupoid
-- cannot record that a route was taken.  `Derivation` composes and cannot
-- invert: every route it takes is still in the term, and ¬ß3 says no
-- function can remove it.
--
-- That surplus is exactly the object `Asesa_‚¶` shows the semantics cannot
-- see.  `Meaning a b` is a proposition; the fibre of soundness over any
-- meaning is the whole derivation type; the two routes that separate it
-- have equal meanings by `isSet‚ï`.  So the kernel carries a distinction
-- that is real in the term, invisible in the value, and ‚î by ¬ß3 ‚î
-- irremovable by any post-processing of the term.
--
-- The interface consequence, stated because it is mechanical and not a
-- reading: a wire that returns the MEANING returns the part that is
-- provably a proposition, and a wire that does not return the DERIVATION
-- drops the part that is provably everything.
------------------------------------------------------------------------
