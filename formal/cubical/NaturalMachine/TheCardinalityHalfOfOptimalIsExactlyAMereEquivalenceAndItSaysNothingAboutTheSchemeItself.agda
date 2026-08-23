{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- The object audited here is `NaturalMachine.OptimalObservation`'s
-- DEFINITION of `Optimal`, which is that module's own construction.
-- Its three INSTANCES are Piṅgala's *Chandaḥśāstra* uddiṣṭa (c. 300
-- BCE), Virahāṅka's mātrāmeru (c. 600–800), and a CRT residue decode;
-- those sources are named here in that order, before any later name,
-- and **nothing below is a claim about them** — the instances are
-- untouched.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/`
-- and `notes/` grepped first.  `--guardedness` carried; infective.
--
-- ────────────────────────────────────────────────────────────────────
-- 0.  HOW THIS WAS FOUND — the standing proxy heuristic
--
-- Three cycles in a row turned up a hypothesis stated as a NUMBER whose
-- real content was structural: coverage needs the fuel to EXHAUST, not
-- to exceed a length (4e2a577d); a delivery discipline's strength is the
-- RELATION, not its edge count (a5881b77); a scope goes global by being
-- TOTAL, not by being large (35d8ab9a).  So this cycle grepped the
-- corpus for hypotheses phrased as a size or a count.  `Optimal` is one:
--
--     Optimal X Y obs  =  Lossless X Y obs  ×  (card Y ≡ card X)
--
-- **and here the answer is the opposite of the previous three, which is
-- why it is worth a module.**  The count is NOT a lossy proxy.  v0.5's
-- `Cubical.Data.FinSet.Cardinality` carries
--
--     card≡MereEquiv : (card X ≡ card Y) ≡ ∥ X .fst ≃ Y .fst ∥₁
--
-- so on `FinSet` the numeral equation IS the structural statement,
-- exactly — merely, i.e. propositionally truncated.  §2 states that in
-- the form the audited definition needs.
--
-- **WHAT THAT MAKES VISIBLE, AND IT IS THE FINDING.**  Unfolded,
-- `Optimal X Y obs` is
--
--     `obs` is injective   AND   SOME equivalence `X ≃ Y` exists,
--
-- and the second conjunct is **not about `obs`**.  A reader of "loses
-- nothing and wastes nothing" will take the definition to say that
-- `obs` is a bijection.  It does not say that.  Whether the two
-- conjuncts together force it is a pigeonhole theorem — an injection
-- between finite sets of equal cardinality is surjective — which is
-- **not proved in the audited module and is not proved here**; §4 says
-- so and leaves it open rather than asserting either way.
--
-- ────────────────────────────────────────────────────────────────────
-- 1.  AND SECTION 3'S HEADING NAMES A THEOREM SECTION 3 DOES NOT HAVE
--
-- `OptimalObservation` §3 is headed *"An isomorphism gives an optimal
-- scheme"* and contains exactly one declaration, `isoInjective`, which
-- gives INJECTIVITY.  The `card` half is never derived from the
-- isomorphism; at each of the three instances it is discharged by
-- `refl`, because each `FinSet` was BUILT with the same numeral.  So
-- the heading's statement is true and absent.  §3 below is it, in one
-- line, from `cardEquiv`.
--
-- WHAT IS PROVED
--
--   optimalGivesAMereEquivalence   `Optimal X Y obs → ∥ X .fst ≃ Y .fst ∥₁`
--   mereEquivalenceGivesTheCount   the converse half, so the `card`
--                                  conjunct and the mere equivalence are
--                                  interderivable — not merely related
--   isoGivesOptimal                §3's heading, discharged: an `Iso`
--                                  between the carriers gives BOTH
--                                  conjuncts, so the three instances'
--                                  `refl` was an accident of how their
--                                  `FinSet`s were written, not the reason
--
-- WHAT IS NOT CLAIMED.  **`OptimalObservation` is NOT amended and NOT
-- retracted** — `optimal→minimal`, `lossless-needs-room` and all three
-- instances are true as written and are used or left alone here.  It is
-- NOT claimed that `Optimal obs` fails to make `obs` an equivalence;
-- that is the open pigeonhole above, and no counterexample is offered
-- because on `FinSet` none can exist.  Nothing here concerns infinite
-- families (where `card` does not exist), uniqueness of optimal schemes
-- (the audited header already denies it), or the COST of the decode,
-- which is `Laghava`'s subject.  No claim whatever is made about
-- Piṅgala's, Virahāṅka's or the CRT instance's mathematics.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv ; isEquiv)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.FinSet using (FinSet ; card)
open import Cubical.Data.FinSet.Cardinality using (cardEquiv ; cardInj)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁ ; map)

open import NaturalMachine.OptimalObservation
  using (Injective ; Lossless ; Optimal ; isoInjective)

------------------------------------------------------------------------
-- 2.  The count conjunct IS a mere equivalence, both ways
------------------------------------------------------------------------

optimalGivesAMereEquivalence :
    (X Y : FinSet ℓ-zero) (obs : X .fst → Y .fst)
  → Optimal X Y obs → ∥ X .fst ≃ Y .fst ∥₁
optimalGivesAMereEquivalence X Y obs (_ , tight) =
  cardInj {X = X} {Y = Y} (sym tight)

mereEquivalenceGivesTheCount :
    (X Y : FinSet ℓ-zero)
  → ∥ X .fst ≃ Y .fst ∥₁ → card Y ≡ card X
mereEquivalenceGivesTheCount X Y e = sym (cardEquiv X Y e)

-- so a lossless scheme plus ANY equivalence of the carriers is optimal —
-- and the equivalence supplied need not be the scheme
losslessPlusAnyEquivalenceIsOptimal :
    (X Y : FinSet ℓ-zero) (obs : X .fst → Y .fst)
  → Lossless X Y obs → ∥ X .fst ≃ Y .fst ∥₁ → Optimal X Y obs
losslessPlusAnyEquivalenceIsOptimal X Y obs inj e =
  inj , mereEquivalenceGivesTheCount X Y e

------------------------------------------------------------------------
-- 3.  "An isomorphism gives an optimal scheme" — the audited §3's
--     heading, now with the theorem under it
------------------------------------------------------------------------

isoGivesOptimal :
    (X Y : FinSet ℓ-zero) (i : Iso (X .fst) (Y .fst))
  → Optimal X Y (Iso.fun i)
isoGivesOptimal X Y i =
  isoInjective i , mereEquivalenceGivesTheCount X Y ∣ isoToEquiv i ∣₁

-- and symmetrically, since `Iso` inverts
isoGivesOptimalBackwards :
    (X Y : FinSet ℓ-zero) (i : Iso (X .fst) (Y .fst))
  → Optimal Y X (Iso.inv i)
isoGivesOptimalBackwards X Y i =
  isoInjective (record { fun = Iso.inv i ; inv = Iso.fun i
                       ; rightInv = Iso.leftInv i ; leftInv = Iso.rightInv i })
  , mereEquivalenceGivesTheCount Y X (map invEquiv ∣ isoToEquiv i ∣₁)

------------------------------------------------------------------------
-- 4.  What is left open, stated as a type and not as a hope
--
-- The pigeonhole direction — that the two conjuncts of `Optimal` force
-- `obs` ITSELF to be an equivalence — is exactly the statement below.
-- It is NOT proved here and NOT refuted; on `FinSet` it should hold, and
-- the point of writing the type is that nothing in the audited module
-- or in this one supplies it, so no theorem may quietly assume it.
------------------------------------------------------------------------

TheOpenPigeonhole : Type₁
TheOpenPigeonhole =
  (X Y : FinSet ℓ-zero) (obs : X .fst → Y .fst)
  → Optimal X Y obs → isEquiv obs
