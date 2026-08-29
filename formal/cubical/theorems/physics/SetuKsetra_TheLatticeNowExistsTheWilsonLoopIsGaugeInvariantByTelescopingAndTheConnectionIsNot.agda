{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सेतु-क्षेत्र — the link field.
--
-- RESOLUTION TOWARD ABSTRACT 17.  That abstract computed a holonomy
-- and scoped away the gauge vocabulary: no lattice, no gauge group,
-- no connection form, no Wilson loop, no field.  Constructed here:
--
--   §1  The GAUGE GROUP is ℤ/2 — the booleans under xor, with unit,
--       self-inverse, commutativity and associativity from the pinned
--       library.  The LATTICE is a chain of links; the CONNECTION (the
--       field) assigns a group element to each link, carried with the
--       site value at its right end; a GAUGE TRANSFORMATION rewrites
--       each link by its two endpoint site values; the WILSON LOOP is
--       the ordered product of the links.
--
--   §2  THE TELESCOPING LAW: the Wilson line of the transformed chain
--       equals (start site) · (end site) · (original Wilson line) —
--       proved by induction with the middle site values cancelling in
--       pairs (madhya-lopa).  Hence THE WILSON LOOP IS GAUGE
--       INVARIANT: on a closed chain, where the final site value
--       returns to the initial one, the transformed loop equals the
--       original, for every connection and every transformation.
--
--   §3  THE CONNECTION IS NOT: a two-link closed chain and a
--       transformation under which the first link provably changes
--       while the loop, by §2, does not.  The gauge-dependent and the
--       observable are separated on one witness — the holonomy is
--       physical, the connection is coordinates, and both halves are
--       terms.
--
-- Read with abstract 17: its biconditional said an observable is
-- unmoved exactly when invariant; here is the lattice-side instance —
-- the loop is the invariant observable, the link is the moved
-- non-observable, and the two theorems bracket the same law from
-- both sides.
--
-- SYĀT — THE CLAIM, EXACTLY.  The group is ℤ/2 and the lattice is one
-- chain; larger gauge groups and higher-dimensional lattices are the
-- next constructions.  The lattice, group, connection, field, and
-- Wilson loop are no longer among the absences.
------------------------------------------------------------------------

module SetuKsetra_TheLatticeNowExistsTheWilsonLoopIsGaugeInvariantByTelescopingAndTheConnectionIsNot where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; notnot ; true≢false
       ; _⊕_ ; ⊕-identityʳ ; ⊕-comm ; ⊕-assoc)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Data.Empty using (⊥)

------------------------------------------------------------------------
-- १ · The group algebra we need beyond the library: self-cancellation,
-- the middle-cancel law, and the three-term swap.
------------------------------------------------------------------------

⊕-ātman : (a : Bool) → a ⊕ a ≡ false
⊕-ātman false = refl
⊕-ātman true  = refl

madhya-lopa : (a b c : Bool) → (a ⊕ b) ⊕ (b ⊕ c) ≡ a ⊕ c
madhya-lopa false false c = refl
madhya-lopa false true  c = notnot c
madhya-lopa true  false c = refl
madhya-lopa true  true  c = refl

trika-vinimaya : (a b c : Bool) → a ⊕ (b ⊕ c) ≡ b ⊕ (a ⊕ c)
trika-vinimaya a b c =
  ⊕-assoc a b c ∙ cong (_⊕ c) (⊕-comm a b) ∙ sym (⊕-assoc b a c)

------------------------------------------------------------------------
-- २ · The lattice, the field, the transformation, the loop.
--
-- A chain is a list of (link value, right-endpoint site value); the
-- left endpoint of each link is the previous entry's site value,
-- seeded by the start site h₀.
------------------------------------------------------------------------

Setu : Type₀
Setu = List (Bool × Bool)

-- The Wilson line: ordered product of link values.
wilson : List Bool → Bool
wilson []       = false
wilson (g ∷ gs) = g ⊕ wilson gs

-- The gauge transformation: each link conjugated by its endpoints.
parivartana : Bool → Setu → List Bool
parivartana h []               = []
parivartana h ((g , h') ∷ c) = (h ⊕ (g ⊕ h')) ∷ parivartana h' c

-- The final site value of the chain.
anta : Bool → Setu → Bool
anta h []              = h
anta h ((_ , h') ∷ c) = anta h' c

------------------------------------------------------------------------
-- ३ · The telescoping law, and gauge invariance of the loop.
------------------------------------------------------------------------

saṅkalana : (h : Bool) (c : Setu)
          → wilson (parivartana h c)
          ≡ h ⊕ (anta h c ⊕ wilson (map fst c))
saṅkalana h [] =
  sym (cong (h ⊕_) (⊕-identityʳ h) ∙ ⊕-ātman h)
saṅkalana h ((g , h') ∷ c) =
  cong ((h ⊕ (g ⊕ h')) ⊕_) (saṅkalana h' c)
  ∙ cong (_⊕ (h' ⊕ (anta h' c ⊕ wilson (map fst c)))) (⊕-assoc h g h')
  ∙ madhya-lopa (h ⊕ g) h' (anta h' c ⊕ wilson (map fst c))
  ∙ sym (⊕-assoc h g (anta h' c ⊕ wilson (map fst c)))
  ∙ cong (h ⊕_) (trika-vinimaya g (anta h' c) (wilson (map fst c)))

-- On a closed chain the loop is gauge invariant.
cakra-avikāra : (h : Bool) (c : Setu) → anta h c ≡ h
              → wilson (parivartana h c) ≡ wilson (map fst c)
cakra-avikāra h c band =
  saṅkalana h c
  ∙ cong (λ z → h ⊕ (z ⊕ wilson (map fst c))) band
  ∙ ⊕-assoc h h (wilson (map fst c))
  ∙ cong (_⊕ wilson (map fst c)) (⊕-ātman h)

------------------------------------------------------------------------
-- ४ · The connection is not invariant: the named witness.
--
-- Two links closing at start site false, transformed at the middle
-- site: the first link flips while the loop, by §3, cannot.
------------------------------------------------------------------------

sākṣi-setu : Setu
sākṣi-setu = (false , true) ∷ (false , false) ∷ []

-- The chain closes: its final site value is the start site.
sākṣi-baddha : anta false sākṣi-setu ≡ false
sākṣi-baddha = refl

-- The first link changes under the transformation: the transformed
-- connection is provably a different field than the original.
śiras : List Bool → Bool
śiras []      = false
śiras (b ∷ _) = b

saṃyojana-vikāra : parivartana false sākṣi-setu ≡ map fst sākṣi-setu → ⊥
saṃyojana-vikāra p = true≢false (cong śiras p)

setu-calita : parivartana false sākṣi-setu ≡ true ∷ true ∷ []
setu-calita = refl

setu-mūla : map fst sākṣi-setu ≡ false ∷ false ∷ []
setu-mūla = refl

-- …while the Wilson loop agrees on both sides, by reduction and by
-- the theorem at once.
loop-sthira : wilson (parivartana false sākṣi-setu)
            ≡ wilson (map fst sākṣi-setu)
loop-sthira = cakra-avikāra false sākṣi-setu refl
