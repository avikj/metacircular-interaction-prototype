{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Laghava
--
-- à²à¾à˜àµ â” brevity, the grammarian's governing criterion â” as a measure on
-- presentations, and the theorem `notes/LAGHAVA_COST_IS_NOT_A_UNIVALENT_
-- INVARIANT.md` states in prose and proves nowhere.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CLAIM, AND WHY THE PROSE VERSION WAS TOO WEAK
--
-- That note says lghava "is not a univalent invariant â” it lives on the
-- presentation, which univalence discards."  True, and understated.  What
-- is proved below is sharper and needs no univalence at all:
--
--     laghava-is-not-semantic :
--       Â Î[ f âˆˆ (Denotation â’ â•) ] ((e : Expr) â’ f (eval e) â‰¡ size e)
--
-- There is **no function of the denotation whatsoever** that computes the
-- size of a presentation.  Not "univalence cannot see it": nothing that
-- takes only the meaning can see it, because two presentations with the
-- SAME meaning â” not merely equivalent, identical â” have different sizes.
--
-- The univalence statement is then a corollary and a weak one: a univalent
-- invariant is in particular a function of the structure, and there is no
-- such function.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY THIS IS PINI'S SITUATION EXACTLY
--
-- `Apavada.agda` separates two things that wear the same shape:
--
--   * àààµà¾à¦ proper  â” the rules DISAGREE; the generated language changes;
--   * REFORMULATION â” the rules AGREE everywhere; only à²à¾à˜àµ changes.
--
-- A reformulation is, by that module's own definition, a pair with equal
-- denotation.  So reformulations are exactly the moves invisible to every
-- semantic invariant â” and lghava is exactly the quantity that sees
-- them.  The grammarian's whole craft lives in the kernel of `eval`, and
-- `laghava-is-not-semantic` says that kernel is not empty.
--
-- `WalkFast` is a reformulation in this sense (`next-characterised`
-- proves the two descriptions agree everywhere), which is why nothing
-- semantic could ever have registered its improvement.
------------------------------------------------------------------------

module NaturalMachine.Laghava where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; +-zero ; znots ; injSuc)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  Presentations, their size, and their meaning
------------------------------------------------------------------------

data Expr : Type where
  var   : Expr
  lit   : â„• â†’ Expr
  plus  : Expr â†’ Expr â†’ Expr
  times : Expr â†’ Expr â†’ Expr

-- à²à¾à˜àµ: a measure on the PRESENTATION
size : Expr â†’ â„•
size var         = 1
size (lit _)     = 1
size (plus  a b) = suc (size a + size b)
size (times a b) = suc (size a + size b)

Denotation : Type
Denotation = â„• â†’ â„•

-- meaning: a presentation denotes a function
eval : Expr â†’ Denotation
eval var         n = n
eval (lit k)     _ = k
eval (plus  a b) n = eval a n + eval b n
eval (times a b) n = eval a n Â· eval b n

------------------------------------------------------------------------
-- 2.  Two presentations, one meaning, different sizes
------------------------------------------------------------------------

short : Expr
short = plus var var

long : Expr
long = plus var (plus var (lit 0))

short-size : size short â‰¡ 3
short-size = refl

long-size : size long â‰¡ 5
long-size = refl

-- the meanings are EQUAL, not merely equivalent
same-meaning : eval short â‰¡ eval long
same-meaning i n = (n + (+-zero n (~ i)))

------------------------------------------------------------------------
-- 3.  THE THEOREM.  No function of the meaning computes the size.
------------------------------------------------------------------------

private
  3â‰¢5 : Â¬ (3 â‰¡ 5)
  3â‰¢5 p = znots (injSuc (injSuc (injSuc p)))

laghava-is-not-semantic :
  Â¬ (Î£[ f âˆˆ (Denotation â†’ â„•) ] ((e : Expr) â†’ f (eval e) â‰¡ size e))
laghava-is-not-semantic (f , h) =
  3â‰¢5 ( sym (h short âˆ™ short-size)
      âˆ™ cong f same-meaning
      âˆ™ (h long âˆ™ long-size) )

------------------------------------------------------------------------
-- 4.  The univalence corollary, which is the weaker statement
--
-- A univalent invariant of a structure is in particular a function of
-- that structure.  Here the structure IS the denotation, so any such
-- invariant factors through `eval` â” and Â§3 says lghava does not.
------------------------------------------------------------------------

FactorsThroughMeaning : (Expr â†’ â„•) â†’ Type
FactorsThroughMeaning m =
  Î£[ f âˆˆ (Denotation â†’ â„•) ] ((e : Expr) â†’ f (eval e) â‰¡ m e)

laghava-does-not-factor : Â¬ (FactorsThroughMeaning size)
laghava-does-not-factor = laghava-is-not-semantic

-- and for contrast, something that DOES factor: the meaning itself,
-- evaluated anywhere.  So the non-factoring is a property of the measure,
-- not an artefact of the setup.
value-at-one : Expr â†’ â„•
value-at-one e = eval e 1

value-at-one-factors : FactorsThroughMeaning value-at-one
value-at-one-factors = (Î» g â†’ g 1) , (Î» _ â†’ refl)

------------------------------------------------------------------------
-- 5.  The sentence.
--
-- Reformulations â” Pini's, and `WalkFast`'s â” are exactly the moves in
-- the kernel of `eval`.  Every semantic invariant, univalent ones
-- included, is blind to that kernel by construction.  à²à¾à˜àµ is a measure
-- on the fibre, and `laghava-is-not-semantic` proves the fibre is not a
-- point.
--
-- That is why the grammarians needed a criterion beyond correctness, and
-- why a corpus that only checks denotations cannot tell a better
-- presentation from a worse one.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  PRIOR ART, found after the fact â” and the repair.
--
-- Â§3 and Â§4 reinvent an idiom this repository already has.
-- `NaturalMachine.FiniteInformation` defines
--
--     FactorsThrough q t = Î[ decode ] ((x : X) â’ decode (q x) â‰¡ t x)
--
-- and `NaturalMachine.TranscriptDescent` proves the general obstruction
--
--     collisionObstructsDecoder :
--       q x â‰¡ q x' â’ Â (t x â‰¡ t x') â’ Â FactorsThrough q t
--
-- which is exactly Â§3's argument, stated once for all q and t.  Â§3's
-- proof is that lemma inlined at (q, t) = (eval, size), and
-- `CarryBorrowObservation.borrowCountDoesNotDecodeWord` is a third
-- instance of the same shape, landed earlier by another mind.
--
-- CLAUDE.md: "Prior art gets searched BEFORE the experiment, not after
-- the write-up."  This is a fifth instance of the failure it names, found
-- at audit time like the others.  The theorem is unaffected; what was
-- wasted is that it was proved twice.
--
-- THE REPAIR, below: `laghava-collision` isolates the only mathematical
-- content â” two presentations, one meaning, different size â” as a pair,
-- so the corpus's own general lemma can be applied to it directly and
-- this module stops carrying a private copy of the argument.
------------------------------------------------------------------------

laghava-collision :
  Î£[ p âˆˆ Expr ] Î£[ q âˆˆ Expr ] ((eval p â‰¡ eval q) Ã— (Â¬ (size p â‰¡ size q)))
laghava-collision =
  short , long , same-meaning ,
  (Î» h â†’ 3â‰¢5 (sym short-size âˆ™ h âˆ™ long-size))

-- and the general lemma, instantiated here, gives Â§3 back with no new
-- argument: `Â FactorsThrough eval size`, in the repository's own words.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- THE REPAIR THIS MODULE ASKED FOR WAS MADE IN
-- `NaturalMachine.OneLemmaFiveSites`, which derives this module's
-- non-factoring theorem from `TranscriptDescent.collisionObstructsDecoder`
-- applied to the collision isolated above.
--
-- `NaturalMachine.TheTwoCollisionsAreOneInstantiation` adds a second
-- route, through `AnyonyaAbhava.anyonyaâ’samsarga`, notes that the
-- isolated collision is already a term of the parametric type
-- `AnyonyaAbhava.Collision` at this module's own presentation type, and
-- proves the two routes equal â” negations being propositions.
--
-- The private proof above is not removed.  It is the record of how the
-- result was first obtained.
------------------------------------------------------------------------
