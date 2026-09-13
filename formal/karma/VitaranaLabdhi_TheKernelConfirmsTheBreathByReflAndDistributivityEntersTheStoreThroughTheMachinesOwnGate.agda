{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}
-- the kernel's sitting: it recomputes the breath in the shared tongue,
-- confirms the binary's 102 by refl, and mints distributivity — the
-- machine's own first answer — as a store value through the same gate.
module VitaranaLabdhi_TheKernelConfirmsTheBreathByReflAndDistributivityEntersTheStoreThroughTheMachinesOwnGate where
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Unit using (⊤ ; tt)
open import Agda.Builtin.Sigma using (_,_)
open import Agda.Builtin.Equality using (_≡_ ; refl)
open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; Eq')
open import AgamaKanda_TheEldersStoreOnTheActSide using (आगमः)
open import PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue
  using (नियमः ; niyama ; गूढ-दृक् ; संयुक्त-यन्त्रम् ; पूर्ण-प्रमाणम् ; प्राणः ; इन्धनम् ; inJust ; fromJust)

दैर्घ्यम् : List नियमः → Nat
दैर्घ्यम् []       = zero
दैर्घ्यम् (_ ∷ ns) = suc (दैर्घ्यम् ns)

परम्परा : List नियमः
परम्परा = प्राणः 3 [] आगमः

-- the kernel counts what the binary counted: 108 since gcd crossed —
-- the whole store, nothing left with the elder but fresh constants
शताष्टकम् : दैर्घ्यम् परम्परा ≡ 108
शताष्टकम् = refl

x y z : Tm
x = var 0
y = var 1
z = var 2

-- distributivity, minted through the gate: compiles exactly when the
-- machine proves it for itself
वितरण-नियमः : नियमः
वितरण-नियमः = niyama (x ⊗ (y ⊕ z)) ((x ⊗ y) ⊕ (x ⊗ z))
  (fromJust (पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् परम्परा इन्धनम्
    ( x ⊗ (y ⊕ z) , (x ⊗ y) ⊕ (x ⊗ z) )) tt)
