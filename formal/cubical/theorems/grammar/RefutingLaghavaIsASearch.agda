{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RefutingLaghavaIsASearch
--
-- à²à¾à˜àµ, and what it costs to say a measure does NOT survive an
-- operation on presentations.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHERE THIS COMES FROM
--
-- The laghava results share one sentence:
-- cost is not a univalent invariant â” it lives on the presentation,
-- which univalence discards.  `Laghava` proves the
-- instance (`size` does not factor through meaning) and
-- `Anuvrtti` proves another (`cost` is not a function of
-- the rule SET).  Both are stated as `Â FactorsThrough`, and both are
-- PROVED THE SAME WAY: by exhibiting two presentations, `short`/`long`
-- and `abc`/`cab`.
--
-- That repeated shape is the object here: `laghava-is-not-semantic` reduces to
-- `3â‰5` applied to a chain through `short` and `long`, and
-- `anuvrtti-is-not-a-set-function` to `3â‰2` through `abc` and `cab`.
-- Both proofs are three lines and both are a named pair.
--
-- What that repetition is evidence FOR is the question Â§2 answers in
-- one case.  It is not evidence that no other route exists â” two
-- instances are two instances â” and the claim below is only that the
-- route taken has a general shape, and that the shape is the Î /Î
-- asymmetry that stopped the argument in
-- `WhereTheTowerCanStillBeThree` Â§5.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  a witness refutes invariance â” trivial, one line, and recorded
--       because it is the direction that is always available;
--
--   Â§2  the converse is a SEARCH.  Over a two-element presentation
--       space it is available and the proof is the search: decide at
--       each point, and if both decisions go the wrong way, assemble
--       the invariance that was assumed absent.  â•-valued measures make
--       every such decision available, so the whole cost is the
--       exhaustion;
--
--   Â§3  and the laghava collision, re-presented as exactly that search:
--       `Laghava.short` and `Laghava.long` are the two points, the
--       operation swapping them preserves meaning and moves size, and
--       Â§2 recovers the witness from the bare refutation.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE DISTINCTION THIS FILE IS ABOUT
--
-- Two things are being kept apart that the word "stable" would run
-- together, and the collision is in this corpus's own vocabulary:
--
--   ÂÂ-STABILITY â” `Â Â A â’ A`.  Does NOT live on the presentation:
--   `Stable-â”` (WhereTheTowerCanStillBeThree Â§1) transports it along a
--   bare logical equivalence, with no univalence and no h-level.
--
--   INVARIANCE OF A MEASURE under an operation on presentations.  Lives
--   on the presentation by construction; `Laghava` proves it is not
--   recoverable from the meaning.
--
-- They are not one notion at two sites.  Nothing below derives either
-- from the other, and aneknta is precise about when the collapse is
-- licensed: agreement permits it, plurality blocks it, and here there
-- is plurality.  What recurs is a third thing â” the Î /Î asymmetry â”
-- and it recurs because both statements are quantified, not because
-- the quantities are the same.
--
------------------------------------------------------------------------

module RefutingLaghavaIsASearch where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; discreteâ„• ; snotz ; injSuc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (Î£-syntax ; _,_)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import Laghava
  using (Expr ; size ; eval ; short ; long ; same-meaning)

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- 1.  Invariance, and the direction that is always available
------------------------------------------------------------------------

-- A measure survives an operation on presentations when the operation
-- does not move it.
InvariantUnder : {P : Type â„“} â†’ (P â†’ â„•) â†’ (P â†’ P) â†’ Type â„“
InvariantUnder {P = P} Î¼ op = (p : P) â†’ Î¼ (op p) â‰¡ Î¼ p

-- One moved presentation refutes it.  This is the direction both
-- existing laghava results use.
witnessâ†’Â¬invariant :
  {P : Type â„“} (Î¼ : P â†’ â„•) (op : P â†’ P)
  â†’ Î£[ p âˆˆ P ] (Â¬ (Î¼ (op p) â‰¡ Î¼ p))
  â†’ Â¬ InvariantUnder Î¼ op
witnessâ†’Â¬invariant Î¼ op (p , n) inv = n (inv p)

------------------------------------------------------------------------
-- 2.  The converse is the search
--
-- ààà¯à¾àà â” in the respect of a two-point presentation space, the
-- witness is recoverable from the bare refutation, and the proof IS
-- the exhaustion: â• makes each comparison decidable, so nothing is
-- spent except visiting both points.  Note where the work sits â” not
-- in the negation, which gives nothing back, but in the reassembly of
-- the invariance from its two instances, which is what the hypothesis
-- is then applied to.
--
-- The two-point restriction is a HYPOTHESIS of Â§2: `Bool` indexes two
-- particular presentations in Â§3 and nothing else.
------------------------------------------------------------------------

Â¬invariantâ†’witnessâ‚‚ :
  (Î¼ : Bool â†’ â„•) (op : Bool â†’ Bool)
  â†’ Â¬ InvariantUnder Î¼ op
  â†’ Î£[ b âˆˆ Bool ] (Â¬ (Î¼ (op b) â‰¡ Î¼ b))
Â¬invariantâ†’witnessâ‚‚ Î¼ op ni with discreteâ„• (Î¼ (op true)) (Î¼ true)
... | no  n = true , n
... | yes pt with discreteâ„• (Î¼ (op false)) (Î¼ false)
...   | no  n = false , n
...   | yes pf = âŠ¥.rec (ni assemble)
  where
    assemble : InvariantUnder Î¼ op
    assemble true  = pt
    assemble false = pf

------------------------------------------------------------------------
-- 3.  The laghava collision, re-presented as that search
--
-- `Laghava.short` and `Laghava.long` denote the same function and have
-- sizes 3 and 5.  Index them by `Bool`; the operation is the swap.
-- Meaning is invariant under it, size is not, and Â§2 hands the witness
-- back from the bare refutation â” which is to say the original proof
-- was already a two-point exhaustion, done by hand.
------------------------------------------------------------------------

pres : Bool â†’ Expr
pres true  = short
pres false = long

swap : Bool â†’ Bool
swap true  = false
swap false = true

sizeOf : Bool â†’ â„•
sizeOf = Î» b â†’ size (pres b)

-- meaning does not move under the swap â¦
meaning-invariant : (b : Bool) â†’ eval (pres (swap b)) â‰¡ eval (pres b)
meaning-invariant true  = sym same-meaning
meaning-invariant false = same-meaning

-- â¦ and size does, at both points.
size-moves : Â¬ InvariantUnder sizeOf swap
size-moves inv with discreteâ„• (sizeOf (swap true)) (sizeOf true)
... | yes p = âŠ¥.rec (snotz (injSuc (injSuc (injSuc p))))
... | no  n = n (inv true)

-- and the search recovers the moved presentation from the refutation.
laghava-witness : Î£[ b âˆˆ Bool ] (Â¬ (sizeOf (swap b) â‰¡ sizeOf b))
laghava-witness = Â¬invariantâ†’witnessâ‚‚ sizeOf swap size-moves
