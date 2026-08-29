{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- उपकरण-वृद्धिः — instrument-growth.  Two theorems that close the gap
-- between ApurvaIndriyam's admission gate and the Parasparāśraya record.
--
-- §1  A DERIVED SENSE ADDS NO SEPARATION, AS AN EQUALITY OF TYPES.
--     For a sensorium S : X → O and a dashboard q = h ∘ S landing in a
--     set, the agreement type of the extended family {S, q} at any pair
--     is EQUAL — by univalence, not merely equivalent — to the agreement
--     type of S alone:
--
--         (S x ≡ S y)  ≡  (S x ≡ S y) × (q x ≡ q y).
--
--     The Nerode relation of the family with the dashboard adjoined is
--     the same type as without it (the abstract-15 idiom, "computed, not
--     characterised", at the level of instruments): buying a derived
--     reading buys no vision, and this is a path in the universe.
--
-- §2  AN INTERDEPENDENT PAIR IS NEVER SOURCE-AND-DASHBOARD.
--     A Parasparāśraya whose second sense factors through its first is
--     refuted outright.  Joint faithfulness plus a named blind pair for
--     the first sense forces the second to separate that pair
--     (dvitīya-paśyati), while factoring forces it blind there
--     (तन्तौ-अन्धः) — so the record and the derivation cannot coexist.
--     Contrapositively: EVERY interdependent pair's second member passes
--     ApurvaIndriyam's admission gate.  The second sense of an
--     interdependent type is necessarily a new sense; interdependence
--     certifies independence.
--
-- THE MOTIVIC SENTENCE, stated as the reading it is.  A comparison map
-- derived from realizations already held adds no conservativity — the
-- indistinguishability of motives under the extended family is the same
-- type (§1).  And a jointly faithful family in which each member has a
-- named blind pair is thereby proved to contain no derived member: each
-- realization is a genuinely new sense of the motive (§2).  Crystalline
-- is not a function of the ℓ-adic readings — that instance is a reading
-- and is not proved; the shape of it is §2 and is.
--
-- SYĀT — THE CLAIM, EXACTLY.  No realization functors, no motives, no
-- cohomology.  §1 needs only that the dashboard's codomain is a set;
-- §2 is generic in all three types.
------------------------------------------------------------------------

module UpakaranaVrddhi_ADerivedSenseAddsNoSeparationAndAnInterdependentPairIsNeverSourceAndDashboard where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibresSoASeparatedBlindPairCertifiesANewSense
  using (प्रवहति ; तन्तौ-अन्धः)
open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Parasparāśraya)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- १ · The dashboard adjoined: the same agreement type, as a path.
------------------------------------------------------------------------

module _ {X : Type ℓ} {O Q : Type ℓ'}
         (S : X → O) (q : X → Q) (setQ : isSet Q)
         (der : प्रवहति S q) where

  vṛddhi : (x y : X) → (S x ≡ S y) ≃ ((S x ≡ S y) × (q x ≡ q y))
  vṛddhi x y = isoToEquiv (iso saha kevala punar āvṛtti)
    where
      saha : S x ≡ S y → (S x ≡ S y) × (q x ≡ q y)
      saha p = p , तन्तौ-अन्धः S q der x y p

      kevala : (S x ≡ S y) × (q x ≡ q y) → S x ≡ S y
      kevala = fst

      punar : (pq : (S x ≡ S y) × (q x ≡ q y)) → saha (kevala pq) ≡ pq
      punar (p , qq) i =
        p , setQ (q x) (q y) (तन्तौ-अन्धः S q der x y p) qq i

      āvṛtti : (p : S x ≡ S y) → kevala (saha p) ≡ p
      āvṛtti p = refl

  -- The equality of types.  Adjoining the derived sense does not move
  -- the Nerode relation: the path is in the universe and transports.
  vṛddhi-abheda : (x y : X) → (S x ≡ S y) ≡ ((S x ≡ S y) × (q x ≡ q y))
  vṛddhi-abheda x y = ua (vṛddhi x y)

------------------------------------------------------------------------
-- २ · The collision: interdependence refuses derivation.
------------------------------------------------------------------------

open Parasparāśraya

na-praṇālī : {X : Type ℓ} {O₁ : Type ℓ'} {O₂ : Type ℓ''}
             (P : Parasparāśraya X O₁ O₂)
           → प्रवहति (dṛś₁ P) (dṛś₂ P) → ⊥
na-praṇālī P der =
  fst (snd (snd (andha₁ P)))
      (yugma P (fst (andha₁ P)) (fst (snd (andha₁ P)))
               (snd (snd (snd (andha₁ P))))
               (तन्तौ-अन्धः (dṛś₁ P) (dṛś₂ P) der
                  (fst (andha₁ P)) (fst (snd (andha₁ P)))
                  (snd (snd (snd (andha₁ P))))))

-- And symmetrically: the FIRST sense cannot be derived from the second.
na-praṇālī' : {X : Type ℓ} {O₁ : Type ℓ'} {O₂ : Type ℓ''}
              (P : Parasparāśraya X O₁ O₂)
            → प्रवहति (dṛś₂ P) (dṛś₁ P) → ⊥
na-praṇālī' P der =
  fst (snd (snd (andha₂ P)))
      (yugma P (fst (andha₂ P)) (fst (snd (andha₂ P)))
               (तन्तौ-अन्धः (dṛś₂ P) (dṛś₁ P) der
                  (fst (andha₂ P)) (fst (snd (andha₂ P)))
                  (snd (snd (snd (andha₂ P)))))
               (snd (snd (snd (andha₂ P)))))

-- Read together: an interdependent pair is irreducible in BOTH
-- directions — neither member is a post-processing of the other, and
-- the record itself is the certificate.  Interdependence is proved
-- mutual novelty, not shared redundancy.
