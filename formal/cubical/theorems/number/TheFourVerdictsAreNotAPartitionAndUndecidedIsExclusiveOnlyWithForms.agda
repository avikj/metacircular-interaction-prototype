{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheFourVerdictsAreNotAPartitionAndUndecidedIsExclusiveOnlyWithForms
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Scoped descent verdicts and factorization-through-a-quotient are this
-- corpus's own construction; there is no source to cite and a
-- fabricated Sanskrit label would assert a provenance nobody checked.
-- Checked before naming: `.claude/hooks/priority-ledger.txt` (CURRENT
-- header) and `.claude/hooks/european-frame.txt`; no row applies and
-- the frame check's scope requires Indian material, of which this
-- module has none.  `formal/` and `notes/` grepped first.
-- `--guardedness` is carried because `VacuityVerdict` declares it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUDIT.  Target: `VacuityVerdict`, whose header
-- says:
--
--   "The finite runtime used four strings: FORMS, GENUINE, VACUOUS, and
--    UNDECIDED-VACUOUS.  **The distinction is not four labels.  It is
--    the difference between four types.**"
--
-- That is right, and it leaves the reader one inference short.  Four
-- constructors of one datatype read as a CLASSIFICATION — four boxes,
-- each object in one.  **`Verdict` is not a partition**, and which
-- pairs collide is not incidental: it is the whole epistemic content of
-- the fourth label.
--
-- WHAT IS PROVED — all six pairs, decided:
--
--   EXCLUSIVE (4).  Nothing can be `forms` and anything else, and
--   nothing can be `genuine` and `vacuous`:
--     formsExcludesUndecided   a local collision refutes the scoped
--                              factorization every other verdict carries
--     formsExcludesVacuous     hence this
--     formsExcludesGenuine     and this, through `global→scoped` —
--                              **the only one of the four needing a
--                              lemma rather than a projection**
--     genuineExcludesVacuous   an ambient collision refutes a global
--                              factorization
--
--   COMPATIBLE (2), and BOTH involve `undecided`:
--     vacuousGivesUndecided        `vacuous`'s payload CONTAINS
--                                  `undecided`'s — projection, no work
--     genuineGivesUndecided        and a global factorization restricts
--                                  to every scope
--     bothVerdictsAtOnce           exhibited on the module's own finite
--                                  control: `constantCarrier` /
--                                  `constantObservation` over
--                                  `OnlyFalse` carries a
--                                  `GlobalFactorization` AND a
--                                  `ScopedFactorization` simultaneously,
--                                  so `genuine …` and `undecided …` are
--                                  both derivable for one triple
--
-- **AND THE ASYMMETRY IS EXACTLY THE POINT THE HEADER WAS MAKING.**
-- `forms` and `genuine` and `vacuous` are claims about the OBJECT — a
-- collision exists, a descent exists, a descent exists but is
-- ambiently worthless.  `undecided` is a claim about **what the checker
-- was handed**: a scoped factorization and no ambient theorem either
-- way.  A statement about the evidence cannot exclude a statement about
-- the object, which is why it collides with two of the three, and it is
-- refuted only by `forms` — the one verdict that destroys the very
-- payload `undecided` carries.  The header's own sentence, *"it remains
-- `undecided` until an ambient theorem is supplied"*, says this; the
-- theorems below are that sentence with its quantifiers.
--
-- WHAT IS NOT CLAIMED.  **`VacuityVerdict` is NOT amended and NOT
-- retracted** — every definition and lemma there is used here exactly
-- as written, and nothing above says the four constructors are the
-- wrong four.  It is NOT claimed that `Verdict` should be changed: a
-- non-partitioned verdict type is the honest shape for evidence that
-- can be partial, and §"COMPATIBLE" is a description, not a defect
-- report.  Nothing here concerns the header's OTHER claim — that
-- checking a larger finite sample never constructs a
-- `GlobalFactorization` — which is a statement about a sampling
-- procedure, and no sampling procedure appears in that module or this
-- one.  No h-level is assumed of `X`, `Z`, `Y`, and no verdict is
-- shown to be a proposition.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheFourVerdictsAreNotAPartitionAndUndecidedIsExclusiveOnlyWithForms where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import VacuityVerdict
  using ( Scope ; LocalCollision ; AmbientCollision
        ; ScopedFactorization ; GlobalFactorization
        ; localCollision-refutes-scoped ; ambientCollision-refutes-global
        ; global→scoped
        ; OnlyFalse ; constantCarrier ; constantObservation
        ; constant-is-genuine )

private
  variable
    X Z Y : Type₀

------------------------------------------------------------------------
-- 1.  The four exclusions
------------------------------------------------------------------------

formsExcludesUndecided :
    (S : Scope X) (q : X → Z) (f : X → Y)
  → LocalCollision S q f → ¬ (ScopedFactorization S q f)
formsExcludesUndecided = localCollision-refutes-scoped

formsExcludesVacuous :
    (S : Scope X) (q : X → Z) (f : X → Y)
  → LocalCollision S q f
  → ¬ (ScopedFactorization S q f × AmbientCollision S q f)
formsExcludesVacuous S q f c p = localCollision-refutes-scoped S q f c (fst p)

-- the only exclusion that is not a projection away: a global
-- factorization must first be restricted to the scope
formsExcludesGenuine :
    (S : Scope X) (q : X → Z) (f : X → Y)
  → LocalCollision S q f → ¬ (GlobalFactorization q f)
formsExcludesGenuine S q f c g =
  localCollision-refutes-scoped S q f c (global→scoped S q f g)

genuineExcludesVacuous :
    (S : Scope X) (q : X → Z) (f : X → Y)
  → GlobalFactorization q f → ¬ (AmbientCollision S q f)
genuineExcludesVacuous S q f g c = ambientCollision-refutes-global S q f c g

------------------------------------------------------------------------
-- 2.  The two compatibilities, both with `undecided`
------------------------------------------------------------------------

vacuousGivesUndecided :
    (S : Scope X) (q : X → Z) (f : X → Y)
  → ScopedFactorization S q f × AmbientCollision S q f
  → ScopedFactorization S q f
vacuousGivesUndecided S q f = fst

genuineGivesUndecided :
    (S : Scope X) (q : X → Z) (f : X → Y)
  → GlobalFactorization q f → ScopedFactorization S q f
genuineGivesUndecided = global→scoped

------------------------------------------------------------------------
-- 3.  …and the compatibility is inhabited, on the audited module's own
--     finite control
------------------------------------------------------------------------

bothVerdictsAtOnce :
  GlobalFactorization constantCarrier constantObservation
  × ScopedFactorization OnlyFalse constantCarrier constantObservation
bothVerdictsAtOnce =
    constant-is-genuine
  , genuineGivesUndecided OnlyFalse constantCarrier constantObservation
      constant-is-genuine
