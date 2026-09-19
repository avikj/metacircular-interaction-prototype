{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- The object audited here is `OptimalObservation`'s
-- DEFINITION of `Optimal`, which is that module's own construction.
-- Its three INSTANCES are Pigala's *Chandastra* uddia (c. 300
-- BCE), Virahka's mtrmeru (c. 600‚ì800), and a CRT residue decode;
-- those sources are named here in that order, before any later name,
-- and **nothing below is a claim about them** ‚î the instances are
-- untouched.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/`
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- 0.  HOW THIS WAS FOUND ‚î the standing proxy heuristic
--
-- Three cycles in a row turned up a hypothesis stated as a NUMBER whose
-- real content was structural: coverage needs the fuel to EXHAUST, not
-- to exceed a length (4e2a577d); a delivery discipline's strength is the
-- RELATION, not its edge count (a5881b77); a scope goes global by being
-- TOTAL, not by being large (35d8ab9a).  So this cycle grepped the
-- corpus for hypotheses phrased as a size or a count.  `Optimal` is one:
--
--     Optimal X Y obs  =  Lossless X Y obs  ó  (card Y ‚â° card X)
--
-- **and here the answer is the opposite of the previous three, which is
-- why it is worth a module.**  The count is NOT a lossy proxy.  v0.5's
-- `Cubical.Data.FinSet.Cardinality` carries
--
--     card‚â°MereEquiv : (card X ‚â° card Y) ‚â° ‚à X .fst ‚â Y .fst ‚à‚
--
-- so on `FinSet` the numeral equation IS the structural statement,
-- exactly ‚î merely, i.e. propositionally truncated.  ¬ß2 states that in
-- the form the audited definition needs.
--
-- **WHAT THAT MAKES VISIBLE, AND IT IS THE FINDING.**  Unfolded,
-- `Optimal X Y obs` is
--
--     `obs` is injective   AND   SOME equivalence `X ‚â Y` exists,
--
-- and the second conjunct is **not about `obs`**.  A reader of "loses
-- nothing and wastes nothing" will take the definition to say that
-- `obs` is a bijection.  It does not say that.  Whether the two
-- conjuncts together force it is a pigeonhole theorem ‚î an injection
-- between finite sets of equal cardinality is surjective ‚î which is
-- **not proved in the audited module and is not proved here**; ¬ß4 says
-- so and leaves it open rather than asserting either way.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- 1.  AND SECTION 3'S HEADING NAMES A THEOREM SECTION 3 DOES NOT HAVE
--
-- `OptimalObservation` ¬ß3 is headed *"An isomorphism gives an optimal
-- scheme"* and contains exactly one declaration, `isoInjective`, which
-- gives INJECTIVITY.  The `card` half is never derived from the
-- isomorphism; at each of the three instances it is discharged by
-- `refl`, because each `FinSet` was BUILT with the same numeral.  So
-- the heading's statement is true and absent.  ¬ß3 below is it, in one
-- line, from `cardEquiv`.
--
-- WHAT IS PROVED
--
--   optimalGivesAMereEquivalence   `Optimal X Y obs ‚í ‚à X .fst ‚â Y .fst ‚à‚`
--   mereEquivalenceGivesTheCount   the converse half, so the `card`
--                                  conjunct and the mere equivalence are
--                                  interderivable ‚î not merely related
--   isoGivesOptimal                ¬ß3's heading, discharged: an `Iso`
--                                  between the carriers gives BOTH
--                                  conjuncts, so the three instances'
--                                  `refl` was an accident of how their
--                                  `FinSet`s were written, not the reason
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; invEquiv ; isEquiv)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.FinSet using (FinSet ; card)
open import Cubical.Data.FinSet.Cardinality using (cardEquiv ; cardInj)
open import Cubical.HITs.PropositionalTruncation using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; map)

open import OptimalObservation
  using (Injective ; Lossless ; Optimal ; isoInjective)

------------------------------------------------------------------------
-- 2.  The count conjunct IS a mere equivalence, both ways
------------------------------------------------------------------------

optimalGivesAMereEquivalence :
    (X Y : FinSet ‚Ñì-zero) (obs : X .fst ‚Üí Y .fst)
  ‚Üí Optimal X Y obs ‚Üí ‚à• X .fst ‚âÉ Y .fst ‚à•‚ÇÅ
optimalGivesAMereEquivalence X Y obs (_ , tight) =
  cardInj {X = X} {Y = Y} (sym tight)

mereEquivalenceGivesTheCount :
    (X Y : FinSet ‚Ñì-zero)
  ‚Üí ‚à• X .fst ‚âÉ Y .fst ‚à•‚ÇÅ ‚Üí card Y ‚â° card X
mereEquivalenceGivesTheCount X Y e = sym (cardEquiv X Y e)

-- so a lossless scheme plus ANY equivalence of the carriers is optimal ‚î
-- and the equivalence supplied need not be the scheme
losslessPlusAnyEquivalenceIsOptimal :
    (X Y : FinSet ‚Ñì-zero) (obs : X .fst ‚Üí Y .fst)
  ‚Üí Lossless X Y obs ‚Üí ‚à• X .fst ‚âÉ Y .fst ‚à•‚ÇÅ ‚Üí Optimal X Y obs
losslessPlusAnyEquivalenceIsOptimal X Y obs inj e =
  inj , mereEquivalenceGivesTheCount X Y e

------------------------------------------------------------------------
-- 3.  "An isomorphism gives an optimal scheme" ‚î the audited ¬ß3's
--     heading, now with the theorem under it
------------------------------------------------------------------------

isoGivesOptimal :
    (X Y : FinSet ‚Ñì-zero) (i : Iso (X .fst) (Y .fst))
  ‚Üí Optimal X Y (Iso.fun i)
isoGivesOptimal X Y i =
  isoInjective i , mereEquivalenceGivesTheCount X Y ‚à£ isoToEquiv i ‚à£‚ÇÅ

-- and symmetrically, since `Iso` inverts
isoGivesOptimalBackwards :
    (X Y : FinSet ‚Ñì-zero) (i : Iso (X .fst) (Y .fst))
  ‚Üí Optimal Y X (Iso.inv i)
isoGivesOptimalBackwards X Y i =
  isoInjective (record { fun = Iso.inv i ; inv = Iso.fun i
                       ; rightInv = Iso.leftInv i ; leftInv = Iso.rightInv i })
  , mereEquivalenceGivesTheCount Y X (map invEquiv ‚à£ isoToEquiv i ‚à£‚ÇÅ)

------------------------------------------------------------------------
-- 4.  What is left open, stated as a type and not as a hope
--
-- The pigeonhole direction ‚î that the two conjuncts of `Optimal` force
-- `obs` ITSELF to be an equivalence ‚î is exactly the statement below.
-- It is NOT proved here and NOT refuted; on `FinSet` it should hold, and
-- the point of writing the type is that nothing in the audited module
-- or in this one supplies it, so no theorem may quietly assume it.
------------------------------------------------------------------------

TheOpenPigeonhole : Type‚ÇÅ
TheOpenPigeonhole =
  (X Y : FinSet ‚Ñì-zero) (obs : X .fst ‚Üí Y .fst)
  ‚Üí Optimal X Y obs ‚Üí isEquiv obs
