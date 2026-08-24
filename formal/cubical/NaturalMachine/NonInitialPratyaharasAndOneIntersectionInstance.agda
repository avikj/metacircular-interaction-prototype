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

module NaturalMachine.NonInitialPratyaharasAndOneIntersectionInstance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Sivasutra using (Sym ; a ; i ; u ; ṛ ; ḷ ; e ; o ; ai ; au ; Ṇ ; K ; Ṅ ; C
                            ; isMarker ; eqSym ; sivasutra ; upto)

------------------------------------------------------------------------
-- NaturalMachine.NonInitialPratyaharasAndOneIntersectionInstance
--
-- `formal/cubical/Sivasutra.agda` (cf-sakshi, 2026-08-18) checks the
-- pratyāhāra device on the vowel prefix, and says so exactly in its own
-- comment: *"All pratyāhāras here begin at `a`, the head, so no
-- start-search is needed."*  Its `upto` moves ONE endpoint.
--
-- The device moves TWO.  `iK`, `eṄ`, `aiC` are pratyāhāras with
-- non-initial starts, and they are what makes the family of named classes
-- more than a chain: with both endpoints free the classes overlap rather
-- than merely nest, and an intersection can be a named class again.  That
-- overlap is the structure the intersection-closed-family reading of the
-- śiva-sūtras is about.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  `from`, the start-search, and `between` = `upto` after `from`;
--   §2  three non-initial pratyāhāras, each equal to its traditional
--       class BY REFL, and one initial one recomputed through `between`
--       to check the extension agrees with `Sivasutra.upto` where they
--       overlap;
--   §3  ONE INTERSECTION INSTANCE: the intersection of `aK` and `iC` is
--       `iK`, again a named pratyāhāra, by `refl`.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED, AND THE LIMIT IS THE INTERESTING PART
--
-- **Not Petersen's theorem.**  `Sivasutra.agda`'s header names it and
-- declines it in the same breath: *"NOT claimed … that the ordering is
-- OPTIMAL (the intersection-closed interval-representation optimality —
-- the deep theorem)"*.  That declining stands here unchanged.  Petersen
-- 2004 is `INDIC_FORMAL_TRADITIONS_MAP.md` §8's FIRST reading item, its
-- PDF is at a URL that note records, and egress is blocked from this
-- environment — arxiv.org was tested and refused 2026-08-19, and nothing
-- suggests `user.phil.hhu.de` would differ.  It has not been read.
--
-- **§3 is an instance, not closure.**  One intersection of two named
-- classes is again a named class.  That is a datum.  The family being
-- intersection-CLOSED is a universally quantified statement over all
-- pairs, and it is not proved here for any family — nor would proving it
-- on the vowel prefix say much, the prefix being nine sounds.
--
-- **The consonant sūtras are still absent**, as in the module extended.
-- The vowel prefix is where the device is visible cheaply; it is not
-- where the ordering problem lives, since the hard part of the
-- śiva-sūtra ordering is the consonants and the duplicated `h`.
--
-- **No historical priority statement**, per the extended module.
--
-- PRIOR ART, grep run and quoted: `grep -rn "between|NonInitial|iK|eṄ|aiC"
-- formal/cubical/Sivasutra.agda` returns nothing — the module has no
-- start-search and no non-initial pratyāhāra.  A version spelling the
-- start-search as `dropWhile` would evade that grep; I read the module in
-- full and there is none.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The start-search, and the two-endpoint extractor
------------------------------------------------------------------------

-- drop everything strictly before the start sound, keeping it.
from : Sym → List Sym → List Sym
from s [] = []
from s (x ∷ xs) = if eqSym x s then x ∷ xs else from s xs

-- a pratyāhāra with both endpoints named: start at `s`, stop at marker `m`.
between : Sym → Sym → List Sym → List Sym
between s m xs = upto m (from s xs)

------------------------------------------------------------------------
-- 2.  Non-initial pratyāhāras, each by refl
------------------------------------------------------------------------

-- iK : the simple vowels other than `a`
iK : between i K sivasutra ≡ i ∷ u ∷ ṛ ∷ ḷ ∷ []
iK = refl

-- eṄ : the guṇa vowels
eṄ : between e Ṅ sivasutra ≡ e ∷ o ∷ []
eṄ = refl

-- aiC : the vṛddhi diphthongs
aiC : between ai C sivasutra ≡ ai ∷ au ∷ []
aiC = refl

-- iC : every vowel but `a`
iC : between i C sivasutra ≡ i ∷ u ∷ ṛ ∷ ḷ ∷ e ∷ o ∷ ai ∷ au ∷ []
iC = refl

-- and the extension agrees with the one-endpoint version at the head.
betweenAgreesAtTheHead : between a C sivasutra ≡ upto C sivasutra
betweenAgreesAtTheHead = refl

------------------------------------------------------------------------
-- 3.  One intersection instance: aK ∩ iC ≡ iK
------------------------------------------------------------------------

mem : Sym → List Sym → Bool
mem s [] = false
mem s (x ∷ xs) = if eqSym x s then true else mem s xs

inter : List Sym → List Sym → List Sym
inter [] ys = []
inter (x ∷ xs) ys = if mem x ys then x ∷ inter xs ys else inter xs ys

-- the intersection of two named classes is again a named class, here.
aK∩iC≡iK : inter (upto K sivasutra) (between i C sivasutra)
         ≡ between i K sivasutra
aK∩iC≡iK = refl
