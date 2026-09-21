{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheUniformFormIsNotRefuted where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)
open import DeflationaryTest using (no-barrier-claim)
open import TheUnstableGroundCannotBeExhibited using (DNS)

------------------------------------------------------------------------
-- TheUniformFormIsNotRefuted
--
-- in its own words: "If a real barrier is wanted, the lane has to
-- change, and saying which lane is the next question."
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHERE THIS COMES FROM, AND WHAT WAS ALREADY DONE
--
-- That note runs the deflationary thread to a close.  Read in full
-- before this file was written.  Its result: every absence is stable
-- unconditionally, every obstruction in the lane is `Â`-headed or a Î 
-- of such, `Â ((Â Â A) — (Â A))` is contradictory, and the last
-- candidate barrier form `Â (Dec A)` is itself contradictory
-- (`DeflationaryTest.no-barrier-claim`).  It then states the boundary
-- exactly:
--
--     "Undecidability of a specific proposition is not something a
--      constructive development can assert at all.  What genuinely
--      undecidable results assert is something else: independence FROM
--      A THEORY, or non-existence of an algorithm UNIFORM IN A
--      PARAMETER.  Neither is `Â (Dec A)` for a fixed A."
--
-- The second of those two IS expressible here, and this file writes it
-- down and says exactly what separates it from the refuted forms.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THREE FORMS, AND ONLY ONE SURVIVES
--
-- For a family `P : X â’ Type`:
--
--   (a)  `Â (Dec (P n))` at a fixed `n`     â” refuted, Â§1.
--   (b)  `(n : X) â’ Â (Dec (P n))`          â” refuted, Â§2, given a
--                                             point of X.
--   (c)  `Â ((n : X) â’ Dec (P n))`          â” NOT refuted here, Â§3.
--
-- (c) is where the quantifier sits inside the negation: not "this
-- proposition is undecidable" but "there is no procedure deciding the
-- family".  Â§4 says precisely what would be needed to refute it â” a
-- double-negation shift at that family, and nothing weaker will do,
-- because Â§4's implication is an equivalence.
--
-- So the answer to "which lane": the lane in which the parameter is
-- quantified inside the negation.  The corpus's deflation is complete
-- for the pointwise forms and says nothing about the uniform one.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- That (c) is undecidability in the recursion-theoretic sense.  Without
-- a notion of algorithm distinct from "term of this type theory", `(n :
-- X) â’ Dec (P n)` is a function, not a procedure, and the two notions
-- coincide here only because the lane has no other.
--
-- That independence from a theory is reached.  It is not: that needs a
-- theory to be independent OF, an object this lane does not
-- carry.
--
-- ONE RESEMBLANCE, WITH ITS LIMIT STATED, BECAUSE THE ALTERNATIVE IS
-- DRESSING.
--
-- "a universal statement applied outside its ààµààààà¦à•", and observes
-- that the tradition has both a word for it and a slot in its data
-- structure to prevent it.  Forms (a)/(b) and form (c) above differ in
-- where the quantifier sits, which is a difference of the same
-- FAMILY â” a claim and its delimitor coming apart.
--
-- That is a resemblance and I am not claiming it is an identity.  An
-- ààµààààà¦à• limits a ààà°àà¿à¯à‹à—à¿àà¾ â” it fixes under what description the
-- counterpositive is absent â” and quantifier scope in a type theory is
-- not that.  Naming Â§3 an avacchedaka distinction would be an imported
-- notion in the tradition's clothes.  The note is cited because it names the failure mode this
-- file is about; nothing here translates it.
------------------------------------------------------------------------

private
  variable
    â„“ â„“x : Level

------------------------------------------------------------------------
-- 1.  The pointwise form is refuted, for every proposition
------------------------------------------------------------------------

fixedFormRefuted : {A : Type â„“} â†’ Â¬ Â¬ (Dec A)
fixedFormRefuted {A = A} = no-barrier-claim A

------------------------------------------------------------------------
-- 2.  The "undecidable at every point" form is refuted too, as soon as
--     there is a point to test it at
------------------------------------------------------------------------

everywhereFormRefuted :
  {X : Type â„“x} {P : X â†’ Type â„“}
  â†’ X â†’ Â¬ ((n : X) â†’ Â¬ (Dec (P n)))
everywhereFormRefuted x h = fixedFormRefuted (h x)

------------------------------------------------------------------------
-- 3.  The uniform form, written down
------------------------------------------------------------------------

UniformlyDecidable : {X : Type â„“x} (P : X â†’ Type â„“) â†’ Type _
UniformlyDecidable {X = X} P = (n : X) â†’ Dec (P n)

NoUniformProcedure : {X : Type â„“x} (P : X â†’ Type â„“) â†’ Type _
NoUniformProcedure P = Â¬ (UniformlyDecidable P)

-- it implies each pointwise decision, so it is genuinely stronger than
-- what Â§1 refutes â” and Â§1 does not touch it.
uniformâ†’pointwise :
  {X : Type â„“x} {P : X â†’ Type â„“}
  â†’ UniformlyDecidable P â†’ (n : X) â†’ Dec (P n)
uniformâ†’pointwise u = u

------------------------------------------------------------------------
-- 4.  Refuting it is exactly a double-negation shift at that family
--
-- The shift's hypothesis is Â§1, a theorem.  So the shift at this family
-- and the refutation of the uniform form are interderivable: neither is
-- available here, and they are not two open questions but one.
------------------------------------------------------------------------

shiftâ†’uniformRefuted :
  {X : Type â„“x} {P : X â†’ Type â„“}
  â†’ DNS X (Î» n â†’ Dec (P n))
  â†’ Â¬ (NoUniformProcedure P)
shiftâ†’uniformRefuted dns = dns (Î» _ â†’ fixedFormRefuted)

uniformRefutedâ†’shift :
  {X : Type â„“x} {P : X â†’ Type â„“}
  â†’ Â¬ (NoUniformProcedure P)
  â†’ DNS X (Î» n â†’ Dec (P n))
uniformRefutedâ†’shift nn _ = nn
