{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTwoSidedProfileCutNeedsTheBurdensAsAProfile
--
-- ON THE NAME.  Min-plus residuation and Galois connections are
-- Birkhoff/Ore-era lattice theory and Lawvere 1973; there is no Indian
-- source term for this object and none is invented, per CLAUDE.md's
-- naming guard.  Checked `.claude/hooks/priority-ledger.txt` and
-- `.claude/hooks/european-frame.txt` before naming; no row applies and
-- the frame check does not fire on a module with no Indian material.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- `TheMeetIsMaxAndTheProfileCutIsAGaloisConnection` closed with:
--
--   "ONE SIDE IS STILL SCALAR: burdens form a profile, residuals are a
--    single value, because that is what makes `up` land in â•.  A cut
--    with profiles on BOTH sides needs `up` to produce a residual
--    profile, i.e. a meet per residual index, and is not built."
--
-- The enabling step is built here, and the obstruction to the rest is
-- located exactly.
--
-- WHAT IS PROVED
--
--   upV / dnV        the one-sided cut with the BURDENS TAKEN AS A
--                    PROFILE rather than read off the index list â”
--                    `upV ks b Ï = maxâ¼ (bâ¼ âˆ Ïâ¼)`, `dnV ks b Ïˆ =
--                    (bâ¼ âˆ Ïˆ)â¼`
--   goFwdV / goBwdV  and it is still a Galois connection, by the same
--                    two monus adjunctions
--   VProfileCut      packaged through the existing `Galois` module
--   maxP + three laws
--                    componentwise max on profiles, with `âŠp`'s two
--                    bounds and leastness
--   Rows / UpP       a matrix of burdens as a profile of profiles, and
--                    the residual PROFILE it produces
--
-- **WHY `upV` IS THE STEP THAT MATTERS.**  In the one-sided module the
-- burdens are the â• payloads of the index list, so a second residual
-- index would need a second index list carrying different payloads â”
-- there is no room for a matrix.  Taking the burdens as a profile frees
-- the index list to be pure shape, and then a matrix is just a profile
-- of profiles (`Rows`), which is what `UpP` consumes.
--
-- **AND THE OBSTRUCTION IS THE EMPTY ROW SET, PRECISELY.**  The right
-- adjoint must send a residual profile Ïˆ to the LARGEST burden profile
-- Ï with `UpP bs Ï âŠp Ïˆ`; componentwise that is `maxµ (bµâ¼ âˆ Ïˆµ)`.
-- With no rows the constraint is vacuous, so the largest such Ï is
-- unbounded â” **the empty meet is `âˆž`, which â• does not have.**  The
-- one-sided module recorded this from the other side ("the empty
-- burden list gives `up ks Ï = 0` â¦ with `âˆž` present the empty meet
-- would be `âˆž`"); here it is the same fact obstructing the right
-- adjoint rather than a convention about the left one.  So a two-sided
-- cut exists over a NON-EMPTY residual index set or over `â• âŠ âˆž`, and
-- not over â• with an arbitrary index set.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheTwoSidedProfileCutNeedsTheBurdensAsAProfile where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _âˆ¸_ ; +-comm)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; â‰¤-refl ; â‰¤-trans ; zero-â‰¤)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)

open import TheSaturationClosureNeedsOnlyAGaloisConnection
  using (module Galois)
open import MinPlusResiduationIsAGaloisConnectionAtOneCut
  using (âˆ¸-adjË¡ ; âˆ¸-adjÊ³)
open import TheMeetIsMaxAndTheProfileCutIsAGaloisConnection
  using (max ; max-â‰¤Ë¡ ; max-â‰¤Ê³ ; max-least
        ; Profile ; _âŠ‘p_ ; âŠ‘p-refl ; âŠ‘p-trans ; _âŠ‘r_ ; âŠ‘r-refl ; âŠ‘r-trans)

------------------------------------------------------------------------
-- 1.  The cut with the burdens as a profile
------------------------------------------------------------------------

upV : (ks : List â„•) â†’ Profile ks â†’ Profile ks â†’ â„•
upV []       _        _        = zero
upV (k âˆ· ks) (b , bs) (f , fs) = max (b âˆ¸ f) (upV ks bs fs)

dnV : (ks : List â„•) â†’ Profile ks â†’ â„• â†’ Profile ks
dnV []       _        _ = tt
dnV (k âˆ· ks) (b , bs) Ïˆ = (b âˆ¸ Ïˆ) , dnV ks bs Ïˆ

goFwdV :
  (ks : List â„•) (b Ï† : Profile ks) (Ïˆ : â„•)
  â†’ _âŠ‘p_ {ks} Ï† (dnV ks b Ïˆ) â†’ upV ks b Ï† â‰¤ Ïˆ
goFwdV []       _        _        Ïˆ _           = zero-â‰¤
goFwdV (k âˆ· ks) (b , bs) (f , fs) Ïˆ (le , rest) =
  max-least (b âˆ¸ f) (upV ks bs fs) Ïˆ
    (âˆ¸-adjÊ³ b f Ïˆ (subst (b â‰¤_) (+-comm f Ïˆ) (âˆ¸-adjË¡ b Ïˆ f le)))
    (goFwdV ks bs fs Ïˆ rest)

goBwdV :
  (ks : List â„•) (b Ï† : Profile ks) (Ïˆ : â„•)
  â†’ upV ks b Ï† â‰¤ Ïˆ â†’ _âŠ‘p_ {ks} Ï† (dnV ks b Ïˆ)
goBwdV []       _        _        Ïˆ _ = tt
goBwdV (k âˆ· ks) (b , bs) (f , fs) Ïˆ h =
    âˆ¸-adjÊ³ b Ïˆ f (subst (b â‰¤_) (+-comm Ïˆ f)
                    (âˆ¸-adjË¡ b f Ïˆ (â‰¤-trans (max-â‰¤Ë¡ (b âˆ¸ f) (upV ks bs fs)) h)))
  , goBwdV ks bs fs Ïˆ (â‰¤-trans (max-â‰¤Ê³ (b âˆ¸ f) (upV ks bs fs)) h)

module VProfileCut (ks : List â„•) (b : Profile ks) where
  open Galois (_âŠ‘p_ {ks}) _âŠ‘r_ (âŠ‘p-refl {ks}) (âŠ‘p-trans {ks})
              âŠ‘r-refl âŠ‘r-trans (upV ks b) (dnV ks b)
              (goFwdV ks b) (goBwdV ks b)
    public

------------------------------------------------------------------------
-- 2.  Componentwise max, the meet the right adjoint would need
------------------------------------------------------------------------

maxP : (ks : List â„•) â†’ Profile ks â†’ Profile ks â†’ Profile ks
maxP []       _        _        = tt
maxP (k âˆ· ks) (a , as) (b , bs) = max a b , maxP ks as bs

maxP-âŠ‘Ë¡ : (ks : List â„•) (Ï† Ïˆ : Profile ks) â†’ _âŠ‘p_ {ks} (maxP ks Ï† Ïˆ) Ï†
maxP-âŠ‘Ë¡ []       _        _        = tt
maxP-âŠ‘Ë¡ (k âˆ· ks) (a , as) (b , bs) = max-â‰¤Ë¡ a b , maxP-âŠ‘Ë¡ ks as bs

maxP-âŠ‘Ê³ : (ks : List â„•) (Ï† Ïˆ : Profile ks) â†’ _âŠ‘p_ {ks} (maxP ks Ï† Ïˆ) Ïˆ
maxP-âŠ‘Ê³ []       _        _        = tt
maxP-âŠ‘Ê³ (k âˆ· ks) (a , as) (b , bs) = max-â‰¤Ê³ a b , maxP-âŠ‘Ê³ ks as bs

maxP-least :
  (ks : List â„•) (Ï† Ïˆ Ï‡ : Profile ks)
  â†’ _âŠ‘p_ {ks} Ï‡ Ï† â†’ _âŠ‘p_ {ks} Ï‡ Ïˆ â†’ _âŠ‘p_ {ks} Ï‡ (maxP ks Ï† Ïˆ)
maxP-least []       _        _        _        _            _            = tt
maxP-least (k âˆ· ks) (a , as) (b , bs) (c , cs) (ac , rest) (bc , rest') =
  max-least a b c ac bc , maxP-least ks as bs cs rest rest'

------------------------------------------------------------------------
-- 3.  A matrix of burdens, and the residual PROFILE it produces
------------------------------------------------------------------------

Rows : List â„• â†’ List â„• â†’ Type
Rows []       ks = Unit
Rows (_ âˆ· js) ks = Profile ks Ã— Rows js ks

UpP : (js ks : List â„•) â†’ Rows js ks â†’ Profile ks â†’ Profile js
UpP []       ks _        Ï† = tt
UpP (j âˆ· js) ks (b , bs) Ï† = upV ks b Ï† , UpP js ks bs Ï†

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The step named above â” "assemble the non-empty-row right
-- adjoint: fold `maxP` over `Rows (j âˆ js)` and prove the two halves
-- against `UpP`" â” is done in
-- `TheTwoSidedCutExistsOverANonEmptyResidualIndex`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin): `dnNE`, `goFwdNE`, `goBwdNE`.
--
-- Three things that cycle settled and this one could not:
--
--   * The residual side needs its OWN order, `_â‰¼p_`, pointwise `â‰` â”
--     NOT `_âŠp_`, which is reverse pointwise `â‰` because more burden
--     absorbed is lower.  Writing both with one symbol is how the sign
--     error on this line happened once before.
--   * No accumulator is needed: structural recursion on `Rows` gives
--     the fold, and with it the obvious induction.
--   * `maxP`'s three laws do all the work â” the two bounds split a
--     hypothesis about the fold into per-row hypotheses, leastness
--     reassembles the conclusion, and each row is `goFwdV`/`goBwdV`
--     unchanged.
--
-- The empty residual index remains the only gap, and it is a type-level
-- one: `dnNE` takes its rows in `j âˆ js` form, so the restriction is
-- recorded in the signature rather than in a comment.  Over `â• âŠ âˆž` it
-- would lift.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- CORRECTION APPENDED 2026-08-19, by the same identity, at the end,
-- altering no line above.  Recording site: commit 8f3acebb,
-- `TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin).
--
-- **THE PARAGRAPH ABOVE IS WRONG, AND SO IS THE ONE IN Â§"WHAT IS STILL
--
-- The burden side is ordered by `_âŠp_`, which is REVERSE pointwise `â‰`.
-- The right adjoint must return the `âŠp`-GREATEST burden profile
-- satisfying the constraint; `âŠp`-greatest is `â‰`-LEAST; â•'s least
-- element is `0`.  The empty meet is `zeroProfile`, and â• has it.  No
-- `âˆž`, no `â• âŠ âˆž`, and no restriction on the residual index: `dnAll`,
-- `goFwdAll`, `goBwdAll` at the recording site are the unrestricted
-- adjunction.
--
-- This is a sign error made in PROSE, one cycle after writing "when two
-- sides of an adjunction have opposite orders, give them different
-- symbols" into my own standing rules.  The typechecker never saw the
-- claim, because a comment is not a type.
--
-- WHAT SURVIVES UNCHANGED.  Every definition and every proof in this
-- module.  `upV`, `dnV`, `goFwdV`, `goBwdV`, `maxP` and its three laws,
-- `Rows`, `UpP` are exactly what the unrestricted adjunction is built
-- from.  Only the obstruction claim was false.
--
-- STILL ABSENT, as before: CONVOLUTION, hence nothing about Î” 28's
-- COMPOSITION step.
------------------------------------------------------------------------
