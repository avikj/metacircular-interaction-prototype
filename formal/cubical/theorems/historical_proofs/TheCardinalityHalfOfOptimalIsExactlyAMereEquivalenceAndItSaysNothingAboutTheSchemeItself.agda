{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
--
-- ON THE NAME.
-- The object audited here is `OptimalObservation`'s
-- DEFINITION of `Optimal`, which is that module's own construction.
-- Its three INSTANCES are Pigala's *Chandastra* uddia (c. 300
-- BCE), Virahāṅka's mātrāmeru (c. 600–800), and a CRT residue decode;
-- those sources are named here in that order.
--
-- ────────────────────────────────────────────────────────────────────
-- 0.  THE COUNT CONJUNCT
--
--     Optimal X Y obs  =  Lossless X Y obs  ×  (card Y ≡ card X)
--
-- The count is NOT a lossy proxy.  v0.5's
-- `Cubical.Data.FinSet.Cardinality` carries
--
--     card≡MereEquiv : (card X ≡ card Y) ≡ ∥ X .fst ≃ Y .fst ∥₁
--
-- so on `FinSet` the numeral equation IS the structural statement,
-- exactly — merely, i.e. propositionally truncated.  §2 states that in
-- the form the audited definition needs.
--
-- **WHAT THAT MAKES VISIBLE.**  Unfolded,
-- `Optimal X Y obs` is
--
--     `obs` is injective   AND   SOME equivalence `X ≃ Y` exists,
--
-- and the second conjunct is **not about `obs`**.  A reader of "loses
-- nothing and wastes nothing" will take the definition to say that
-- `obs` is a bijection.  It does not say that.  Whether the two
-- conjuncts together force it is a pigeonhole theorem — an injection
-- between finite sets of equal cardinality is surjective — which is
-- stated in section 4 as a type.
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
------------------------------------------------------------------------

module TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv ; isEquiv)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.FinSet using (FinSet ; card)
open import Cubical.Data.FinSet.Cardinality using (cardEquiv ; cardInj)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁ ; map)

open import OptimalObservation
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
-- 4.  The pigeonhole direction, stated as a type
--
-- The pigeonhole direction — that the two conjuncts of `Optimal` force
-- `obs` ITSELF to be an equivalence — is exactly the statement below.
------------------------------------------------------------------------

TheOpenPigeonhole : Type₁
TheOpenPigeonhole =
  (X Y : FinSet ℓ-zero) (obs : X .fst → Y .fst)
  → Optimal X Y obs → isEquiv obs
