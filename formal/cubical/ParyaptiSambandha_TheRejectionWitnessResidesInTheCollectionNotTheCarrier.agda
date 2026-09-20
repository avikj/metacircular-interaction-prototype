{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ParyaptiSambandha_TheRejectionWitnessResidesInTheCollectionNotTheCarrier
--
-- cf-tessera-3, 2026-08-20.
--
--
-- **parypti-sambandha** â” the relation of complete occurrence â” is
-- Navya-Nyya's answer to a question about WHERE a property resides.
-- Number beyond unity (sakhy: dvitva, tritva) does not reside in each
-- member of a collection distributively; "this pot is two" is false of
-- every pot.  It resides in the collection TAKEN AS A WHOLE, and the
-- relation by which it does so is parypti.  The apparatus naming the
-- slots â” pratiyogin (counterpositive: WHAT is absent), anuyogin
-- (locus), avacchedaka (delimitor: under which qualification) â” is
-- Gagea, *Tattvacintmai*, c. 1325.  The parypti treatment of
-- number is developed by Raghuntha iromai, *Padrthatattvanirpaa*,
-- c. 1500, and by Gaddhara after him.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT WAS FOUND ALREADY DONE, AND IS NOT REDONE HERE
--
-- Grepped `notes/`, `collab/messages/`, `formal/` for the source text's
-- OWN name (`Tattvacintmai`, not just `Gagea`) BEFORE writing:
--
--   `formal/cubical/NaturalMachine/Abhava.agda`, `notes/NO_BARE_ABSENCES.md`
--       â” abhva with pratiyogin; the absence tower; `dec-collapses`.
--   `formal/cubical/AbhavaAvacchedaka.agda`
--       â” the avacchedaka as a genuine dependent binder, load-bearing.
--   `notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md`
--       â” **withdraws** Abhava's reading: `Â-always-stable` needs no
--         hypothesis, so the absence tower is two-tall for every `A`,
--         and decidability lands on the PRATIYOGIN, not on the absence.
--   `NaturalMachine.WhereTheTowerCanStillBeThree` Â§5
--       â” hence the live question is Î-SHAPED pratiyogins: "a decidable
--         Î is stable, so the floor's stability is exactly a SEARCH
--         question."
--   `NaturalMachine.CountingIsWhatDecidableEqualityBuysâ¦`
--       â” proves `Perm xs ys â’ count a xs â‰¡ count a ys`, and states that
--         the converse "must BUILD a permutation â¦ and that search is
--         where finiteness and decidability do real work."
--
-- **None of the above is re-derived.**  `Perm` does not appear here; the
-- relation below is `_âŠ_` (sub-multiset), which is not that module's
-- object, and no theorem of any of those files is used, altered, or
-- restated.  This file answers the question they leave open, on ONE
-- object: for a Î-shaped pratiyogin, WHAT BOUNDS THE SEARCH?
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE OBJECT (frontier: combinatorics of sub-multiset matching with
-- residue â” why the residue is sound)
--
-- `xs âŠ ys` â” every element of the multiset `xs` is matched to a
-- DISTINCT occurrence in `ys`.  A *residue test* rejects candidates
-- cheaply: map both sides into a commutative monoid by a homomorphism
-- and compare.  The received account of why such a test is sound is a
-- collision estimate (fingerprinting: a hash can only cause a false
-- ACCEPT, and here is the bound).
--
-- **Â§1 says the estimate is buying nothing.**  Soundness is the
-- homomorphism property and only that: `âŠ-sound` takes NO decidable
-- equality, NO finiteness of the carrier, NO injectivity of the residue,
-- and NO order on the monoid â” the order it produces is the ALGEBRAIC
-- one and it hands back the QUOTIENT as an explicit witness.  Every
-- estimate in that literature is buying COMPLETENESS.
--
-- **Â§1b prices that, and the price is sharp.**  If the residue monoid is
-- a GROUP, the quotient always exists, so `residue-rejects` is VACUOUS â”
-- a group-valued residue can never reject a containment, only an
-- equality of residues.  So the received "the fingerprint rejects, hence
-- no match" is, for every group-valued fingerprint, a rejection of a
-- DIFFERENT absence: its pratiyogin is a residue class, not an element.
-- Soundness's whole content is therefore *which* monoid, and this is
-- checked, not asserted.
--
-- **Â§2â“Â§4 say where the cost actually sits.**  The counterpositive of a
-- rejection â” `Î[ a âˆˆ A ] count a ys < count a xs` â” is Î-shaped and
-- ranges over the whole carrier `A`, which may be infinite and is not
-- assumed searchable.  `parypti` proves that Î has the same inhabitants
-- as the one delimited to membership in `xs`.  The unbounded existential
-- over the carrier collapses to a bounded one over the collection; only
-- then is it decidable, and only then is Markov's principle for it
-- DISCHARGED rather than assumed (Â§4).
--
-- One sentence: **soundness of the residue costs nothing; extracting a
-- witness from its failure costs exactly the delimitor.**
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
--  * NO COMPLETENESS.  Nothing here proves residue-domination implies
--    `âŠ`.  That is the converse and it is not attempted.
--  * NO UNDECIDABILITY.  Â§3 shows the delimited Î IS decidable given
--    `Discrete A`.  It does NOT show the undelimited Î is undecidable
--    without it â” that needs a countermodel and none is built.  What is
--    exhibited is that `Discrete A` appears in Â§2â“Â§4 and is absent from
--    Â§1: a statement about these proofs, not a lower bound.
--  * NO CLAIM ABOUT AGGREGATE RESIDUES.  Â§1 covers every monoid
--    homomorphism, a single sum-hash included.  Â§2â“Â§4 concern the
--    PER-ELEMENT counting residue.  Whether a rejection by an aggregate
--    residue yields an element witness is not settled here â” and for
--    `Discrete A` it trivially does, by ignoring the aggregate and
--    running Â§3, which is itself the point: the aggregate contributes
--    cost, not level.
--  * `_âŠ_` is one presentation of sub-multiset containment.  Its
--    agreement with any other presentation in this corpus is not proved.
--
-- CHECKED on the CONTAINER: Agda 2.6.3 + cubical v0.5 at
-- /root/agda-libs/cubical; `agda` with no CLI flags, `LC_ALL=C.UTF-8`.
-- NOT the repository's declared pin (Agda 2.8.0 + cubical v0.9); see
-- `notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md`.
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module ParyaptiSambandha_TheRejectionWitnessResidesInTheCollectionNotTheCarrier where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; discreteâ„•)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; zero-â‰¤ ; suc-â‰¤-suc ; â‰¤-trans ; Â¬-<-zero ; Â¬m<m ; <Dec)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as Empty using (âŠ¥ ; âŠ¥*)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Relation.Nullary
  using (Â¬_ ; Dec ; yes ; no ; Discrete ; Stable ; Decâ†’Stable ; mapDec)

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 0.  The relation: sub-multiset containment, by matching each element
--     of `xs` to a DISTINCT occurrence in `ys`.
--
--     `Remove a ys ys'` â” `ys'` is `ys` with one occurrence of `a`
--     deleted.  No decidable equality anywhere: the occurrence is
--     EXHIBITED, never found.
------------------------------------------------------------------------

module _ {A : Type â„“} where

  data Remove (a : A) : List A â†’ List A â†’ Type â„“ where
    rHere  : {ys : List A} â†’ Remove a (a âˆ· ys) ys
    rThere : {y : A} {ys ys' : List A}
           â†’ Remove a ys ys' â†’ Remove a (y âˆ· ys) (y âˆ· ys')

  data _âŠ‘_ : List A â†’ List A â†’ Type â„“ where
    âŠ‘nil  : {ys : List A} â†’ [] âŠ‘ ys
    âŠ‘cons : {x : A} {xs ys ys' : List A}
          â†’ Remove x ys ys' â†’ xs âŠ‘ ys' â†’ (x âˆ· xs) âŠ‘ ys

------------------------------------------------------------------------
-- 1.  SOUNDNESS IS THE HOMOMORPHISM PROPERTY, AND NOTHING ELSE.
--
--     Read the hypotheses of this module: a commutative monoid and a map
--     `A â’ Carrier`.  No `Discrete A`, no finiteness, no order (the
--     order is the algebraic one, produced), no injectivity.
------------------------------------------------------------------------

record CommMonoid (â„“'' : Level) : Type (â„“-suc â„“'') where
  field
    Carrier : Type â„“''
    Îµ       : Carrier
    _Â·_     : Carrier â†’ Carrier â†’ Carrier
    Â·assoc  : (x y z : Carrier) â†’ (x Â· y) Â· z â‰¡ x Â· (y Â· z)
    Â·comm   : (x y : Carrier) â†’ x Â· y â‰¡ y Â· x
    Â·unitl  : (x : Carrier) â†’ Îµ Â· x â‰¡ x

module Residue {A : Type â„“} (M : CommMonoid â„“') (Ï† : A â†’ CommMonoid.Carrier M) where
  open CommMonoid M

  -- the residue: the free-commutative-monoid fold.  This IS the
  -- homomorphism hypothesis, discharged by construction.
  Î¦ : List A â†’ Carrier
  Î¦ []       = Îµ
  Î¦ (x âˆ· xs) = Ï† x Â· Î¦ xs

  -- deleting one occurrence factors the residue by that element.
  Remove-Î¦ : {a : A} {ys ys' : List A} â†’ Remove a ys ys' â†’ Î¦ ys â‰¡ Ï† a Â· Î¦ ys'
  Remove-Î¦ rHere = refl
  Remove-Î¦ {a = a} (rThere {y = y} {ys' = ys'} r) =
      cong (Ï† y Â·_) (Remove-Î¦ r)
    âˆ™ sym (Â·assoc (Ï† y) (Ï† a) (Î¦ ys'))
    âˆ™ cong (_Â· Î¦ ys') (Â·comm (Ï† y) (Ï† a))
    âˆ™ Â·assoc (Ï† a) (Ï† y) (Î¦ ys')

  -- SOUNDNESS, with the quotient exhibited.
  âŠ‘-sound : {xs ys : List A} â†’ xs âŠ‘ ys â†’ Î£[ m âˆˆ Carrier ] (Î¦ xs Â· m â‰¡ Î¦ ys)
  âŠ‘-sound {ys = ys} âŠ‘nil = Î¦ ys , Â·unitl (Î¦ ys)
  âŠ‘-sound {xs = x âˆ· xs} (âŠ‘cons {x = x} r sub) =
    let q = âŠ‘-sound sub
    in fst q
     , Â·assoc (Ï† x) (Î¦ xs) (fst q) âˆ™ cong (Ï† x Â·_) (snd q) âˆ™ sym (Remove-Î¦ r)

  -- The contrapositive: a residue that does not divide REFUTES the
  -- embedding.  This is the whole of "why the residue is sound".
  residue-rejects : {xs ys : List A}
    â†’ Â¬ (Î£[ m âˆˆ Carrier ] (Î¦ xs Â· m â‰¡ Î¦ ys)) â†’ Â¬ (xs âŠ‘ ys)
  residue-rejects nd sub = nd (âŠ‘-sound sub)

  --------------------------------------------------------------------
  -- 1b.  AND HERE IS WHAT SOUNDNESS COSTS WHEN THE TARGET IS A GROUP:
  --      everything.  If every element is invertible, the quotient
  --      ALWAYS exists, so `residue-rejects` is vacuous â” a
  --      group-valued residue can never reject a containment.
  --
  --      It can still reject EQUALITY of the two residues.  But that is
  --      a DIFFERENT ABSENCE with a different pratiyogin: a residue
  --      class, not an element of `A`.  Reading a group-valued
  --      fingerprint's rejection as a rejection of containment is
  --      exactly the mislocation parypti names.
  --------------------------------------------------------------------

  module _ (inv : Carrier â†’ Carrier)
           (Â·invl : (x : Carrier) â†’ inv x Â· x â‰¡ Îµ) where

    group-residue-never-rejects :
      (xs ys : List A) â†’ Î£[ m âˆˆ Carrier ] (Î¦ xs Â· m â‰¡ Î¦ ys)
    group-residue-never-rejects xs ys =
        (inv (Î¦ xs) Â· Î¦ ys)
      , sym (Â·assoc (Î¦ xs) (inv (Î¦ xs)) (Î¦ ys))
      âˆ™ cong (_Â· Î¦ ys) (Â·comm (Î¦ xs) (inv (Î¦ xs)))
      âˆ™ cong (_Â· Î¦ ys) (Â·invl (Î¦ xs))
      âˆ™ Â·unitl (Î¦ ys)

------------------------------------------------------------------------
-- 2.  THE COUNTING RESIDUE, AND THE PARYPTI THEOREM.
--
--     From here on `Discrete A` is a hypothesis, and it is the ONLY
--     thing that changes between Â§1 and Â§2â“Â§4.
------------------------------------------------------------------------

module Counting {A : Type â„“} (_â‰Ÿ_ : Discrete A) where

  bump : A â†’ A â†’ â„• â†’ â„•
  bump a x n with a â‰Ÿ x
  ... | yes _ = suc n
  ... | no  _ = n

  count : A â†’ List A â†’ â„•
  count a []       = zero
  count a (x âˆ· xs) = bump a x (count a xs)

  -- Membership is defined by RECURSION on the list, not as an indexed
  -- family.  An indexed `_âˆˆ_` would force `searchList` below to match a
  -- constructor whose index is `a âˆ xs` against `x âˆ l`, which needs
  -- injectivity of `_âˆ_` â” unavailable in Cubical Agda, and the module
  -- would typecheck with a warning and fail to compute under transport.
  -- The recursive definition has no such step.
  _âˆˆ_ : A â†’ List A â†’ Type â„“
  a âˆˆ []       = âŠ¥* {â„“ = â„“}
  a âˆˆ (x âˆ· xs) = (a â‰¡ x) âŠŽ (a âˆˆ xs)

  -- THE PARYPTI STEP.  A positive count is not a property of the
  -- carrier: it LOCATES the element in the collection.
  paryÄpti : (a : A) (xs : List A) â†’ zero < count a xs â†’ a âˆˆ xs
  paryÄpti a []       h = Empty.rec (Â¬-<-zero h)
  paryÄpti a (x âˆ· xs) h with a â‰Ÿ x
  ... | yes p = inl p
  ... | no  _ = inr (paryÄpti a xs h)

  -- the excess: the counterpositive of a rejection, per element.
  Excess : List A â†’ List A â†’ A â†’ Typeâ‚€
  Excess xs ys a = count a ys < count a xs

  excessâ†’pos : (xs ys : List A) (a : A) â†’ Excess xs ys a â†’ zero < count a xs
  excessâ†’pos xs ys a h = â‰¤-trans (suc-â‰¤-suc (zero-â‰¤ {n = count a ys})) h

  ----------------------------------------------------------------------
  -- The two Î's, and the theorem that they have the same inhabitants.
  --
  --   Undelimited : Î over the CARRIER `A`.
  --   Delimited   : the same Î, delimited by membership in the
  --                 COLLECTION `xs` â” the avacchedaka.
  ----------------------------------------------------------------------

  Undelimited : List A â†’ List A â†’ Type â„“
  Undelimited xs ys = Î£[ a âˆˆ A ] Excess xs ys a

  Delimited : List A â†’ List A â†’ Type â„“
  Delimited xs ys = Î£[ a âˆˆ A ] ((a âˆˆ xs) Ã— Excess xs ys a)

  delimit : (xs ys : List A) â†’ Undelimited xs ys â†’ Delimited xs ys
  delimit xs ys (a , e) = a , paryÄpti a xs (excessâ†’pos xs ys a e) , e

  undelimit : (xs ys : List A) â†’ Delimited xs ys â†’ Undelimited xs ys
  undelimit xs ys (a , _ , e) = a , e

------------------------------------------------------------------------
-- 3.  BOUNDED SEARCH: the delimited Î is decidable, and the bound is the
--     COLLECTION.  `searchList` never mentions the size of `A` â” it
--     recurses on the list.
------------------------------------------------------------------------

  searchList : {P : A â†’ Type â„“'} â†’ ((a : A) â†’ Dec (P a)) â†’ (l : List A)
             â†’ Dec (Î£[ a âˆˆ A ] ((a âˆˆ l) Ã— P a))
  searchList d []            = no (Î» z â†’ Empty.rec* (fst (snd z)))
  searchList {P = P} d (x âˆ· l) with d x
  ... | yes px = yes (x , inl refl , px)
  ... | no Â¬px with searchList {P = P} d l
  ...   | yes (a , m , pa) = yes (a , inr m , pa)
  ...   | no Â¬found = no (Î» { (a , inl p , pa) â†’ Â¬px (subst P p pa)
                            ; (a , inr m , pa) â†’ Â¬found (a , m , pa) })

  ExcessDec : (xs ys : List A) (a : A) â†’ Dec (Excess xs ys a)
  ExcessDec xs ys a = <Dec (count a ys) (count a xs)

  -- decidable, with the search bounded by `xs`.
  Delimited-dec : (xs ys : List A) â†’ Dec (Delimited xs ys)
  Delimited-dec xs ys = searchList (ExcessDec xs ys) xs

  -- and hence the undelimited one is too â” THROUGH the parypti step,
  -- not by searching the carrier.
  Undelimited-dec : (xs ys : List A) â†’ Dec (Undelimited xs ys)
  Undelimited-dec xs ys =
    mapDec (undelimit xs ys) (Î» nd u â†’ nd (delimit xs ys u)) (Delimited-dec xs ys)

------------------------------------------------------------------------
-- 4.  MARKOV'S PRINCIPLE FOR THIS PRATIYOGIN IS DISCHARGED, NOT ASSUMED.
--
--     `notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md`: the absence `ÂA` is
--     always stable, and what is at issue is recoverability of the
--     COUNTERPOSITIVE.  `WhereTheTowerCanStillBeThree` Â§5: for a
--     Î-shaped counterpositive that is exactly a search question.
--     Here is the search, and here is what bounds it.
------------------------------------------------------------------------

  markov-discharged : (xs ys : List A) â†’ Stable (Undelimited xs ys)
  markov-discharged xs ys = Decâ†’Stable (Undelimited-dec xs ys)

------------------------------------------------------------------------
-- 5.  THE JOIN BACK TO Â§1, at the per-element counting residue, and the
--     refutation the witness carries.
------------------------------------------------------------------------

  bump-swap : (b y a : A) (n : â„•) â†’ bump b y (bump b a n) â‰¡ bump b a (bump b y n)
  bump-swap b y a n with b â‰Ÿ y | b â‰Ÿ a
  ... | yes _ | yes _ = refl
  ... | yes _ | no  _ = refl
  ... | no  _ | yes _ = refl
  ... | no  _ | no  _ = refl

  Remove-count : {a : A} (b : A) {ys ys' : List A}
    â†’ Remove a ys ys' â†’ count b ys â‰¡ bump b a (count b ys')
  Remove-count b rHere = refl
  Remove-count {a = a} b (rThere {y = y} {ys' = ys'} r) =
    cong (bump b y) (Remove-count b r) âˆ™ bump-swap b y a (count b ys')

  bump-cong : (b x : A) {m n : â„•} â†’ m â‰¤ n â†’ bump b x m â‰¤ bump b x n
  bump-cong b x h with b â‰Ÿ x
  ... | yes _ = suc-â‰¤-suc h
  ... | no  _ = h

  -- SOUNDNESS of the per-element counting residue (the Â§1 statement at
  -- `M = (â• , + , 0)`, proved directly because it is shorter than the
  -- instantiation).
  count-sound : {xs ys : List A} â†’ xs âŠ‘ ys â†’ (a : A) â†’ count a xs â‰¤ count a ys
  count-sound âŠ‘nil a = zero-â‰¤
  count-sound {xs = x âˆ· xs} (âŠ‘cons {x = x} r sub) a =
    subst (bump a x (count a xs) â‰¤_) (sym (Remove-count a r))
          (bump-cong a x (count-sound sub a))

  -- and therefore an excess element is a REFUTATION carrying its own
  -- counterpositive: not "no embedding", but "no embedding, counterposited
  -- on `a`, delimited by multiplicity".
  excess-refutes : (xs ys : List A) â†’ Undelimited xs ys â†’ Â¬ (xs âŠ‘ ys)
  excess-refutes xs ys (a , e) sub = Â¬m<m (â‰¤-trans e (count-sound sub a))

------------------------------------------------------------------------
-- 6.  NON-VACUITY.  Nothing above is empty: a concrete rejection with
--     its witness, and a concrete embedding.
------------------------------------------------------------------------

module Witness where
  open Counting discreteâ„•

  xs ys : List â„•
  xs = 1 âˆ· 1 âˆ· []
  ys = 1 âˆ· 2 âˆ· []

  counts : (count 1 xs â‰¡ 2) Ã— (count 1 ys â‰¡ 1)
  counts = refl , refl

  -- the counterpositive, named: `1`, delimited by multiplicity.
  excess : Undelimited xs ys
  excess = 1 , (0 , refl)

  -- it lies in the collection, by `parypti` and not by searching â•.
  excess-in-xs : Delimited xs ys
  excess-in-xs = delimit xs ys excess

  no-embedding : Â¬ (xs âŠ‘ ys)
  no-embedding = excess-refutes xs ys excess

  -- and `_âŠ_` is inhabited, so the refutation above is not about an
  -- empty relation.
  yes-embedding : (1 âˆ· []) âŠ‘ ys
  yes-embedding = âŠ‘cons rHere âŠ‘nil
