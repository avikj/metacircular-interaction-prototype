{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module photon where

-- All non-library constructions are local. Carrier retains a field reading
-- with its witness; Orbit/ISC retain its future; the quarter turn supplies the
-- complex structure; FieldEquations identifies the paired evolution equations.
-- BoundaryGeometry constructs the coboundary and proves Stokes/naturality;
-- BoundaryCompletion carries these through exact prefix limits. The general
-- FieldEquations interface also admits other differentiation/curl operators.

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.HLevels using (isProp× ; isSet× ; isSetΠ ; isSetRetract)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; isSetℕ ; snotz)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; -_ ; -Involutive ; negsucNotpos)
open import Cubical.Relation.Nullary using (¬_)

open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.List.Properties using (cons-inj₁ ; cons-inj₂)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Int using (abs ; abs-)
open import Cubical.Algebra.CommRing using (CommRing ; CommRingStr)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/)

-- Reference: Univalent Foundations Program, Homotopy Type Theory (2013),
-- Lemmas 3.11.8–3.11.9 and §4.8: contractible singletons and fibre presentation.
-- https://homotopytypetheory.org/book/
-- Here the singleton over f a contracts while a is retained; regrouping this
-- same dependent sum by its reading gives Fibre.lossless below.
module Carrier {ℓ : Level} {A B : Type ℓ} (f : A → B) where
  Carrier : Type ℓ
  Carrier = Σ A (λ a → Σ B (λ b → f a ≡ b))
  descend : A → Carrier
  descend a = a , f a , refl
  ascend : Carrier → A
  ascend = fst
  carrier-roundtrip : (c : Carrier) → descend (ascend c) ≡ c
  carrier-roundtrip (a , b , w) i = a , w i , (λ j → w (i ∧ j))
  Carrier≃ : A ≃ Carrier
  Carrier≃ = isoToEquiv (iso descend ascend carrier-roundtrip (λ a → refl))
  Carrier≡ : A ≡ Carrier
  Carrier≡ = ua Carrier≃
  carry-transport : A → Carrier
  carry-transport = transport Carrier≡
  -- Cohen, Coquand, Huber, Mörtberg, Cubical Type Theory (2016),
  -- Appendix B, Lemma 25(2): transport along the path from an equivalence
  -- agrees with its forward map. This is the role of uaβ in this square.
  -- https://arxiv.org/html/1611.02108#A2
  carry-transport-descend : (a : A) → carry-transport a ≡ descend a
  carry-transport-descend = uaβ Carrier≃
  Φ-carrier : (A → A) → Carrier → Carrier
  Φ-carrier Φ c = descend (Φ (ascend c))

module Fibre where
  lossless : {ℓ ℓ' : Level} {A : Type ℓ} {B : Type ℓ'} (f : A → B)
    → A ≃ Σ B (fiber f)
  lossless f = isoToEquiv (iso
    (λ a → f a , a , refl) (λ z → fst (snd z))
    (λ { (b , a , w) i → w i , a , (λ j → w (i ∧ j)) }) (λ a → refl))

-- Kozen and Silva, Practical coinduction, §§2, 4: streams as coalgebras
-- and proofs by matching observations and continuations.
-- https://www.cs.cornell.edu/~kozen/Papers/Structural.pdf
-- path≃bisim makes that correspondence an equivalence of witness types;
-- Nucleus uses it to carry the entire future through Carrier's equivalence.
module Orbit where
  record Orbit {ℓ : Level} (A : Type ℓ) : Type ℓ where
    coinductive
    field
      here : A
      next : Orbit A
  open Orbit public
  unfold : {ℓ : Level} {A : Type ℓ} → (A → A) → A → Orbit A
  here (unfold Φ a) = a
  next (unfold Φ a) = unfold Φ (Φ a)
  mapO : {ℓ ℓ' : Level} {A : Type ℓ} {B : Type ℓ'} → (A → B) → Orbit A → Orbit B
  here (mapO f s) = f (here s)
  next (mapO f s) = mapO f (next s)
  record _≈_ {ℓ : Level} {A : Type ℓ} (x y : Orbit A) : Type ℓ where
    coinductive
    field
      ≈here : here x ≡ here y
      ≈next : next x ≈ next y
  open _≈_ public
  bisim : {ℓ : Level} {A : Type ℓ} {x y : Orbit A} → x ≈ y → x ≡ y
  here (bisim p i) = ≈here p i
  next (bisim p i) = bisim (≈next p) i
  encode : {ℓ : Level} {A : Type ℓ} {x y : Orbit A} → x ≡ y → x ≈ y
  ≈here (encode p) i = here (p i)
  ≈next (encode p) = encode (λ i → next (p i))
  decode-encode : {ℓ : Level} {A : Type ℓ} {x y : Orbit A} (p : x ≡ y) → bisim (encode p) ≡ p
  here (decode-encode p i j) = here (p j)
  next (decode-encode p i j) = decode-encode (λ k → next (p k)) i j
  encode-decode : {ℓ : Level} {A : Type ℓ} {x y : Orbit A} (p : x ≈ y) → encode (bisim p) ≡ p
  ≈here (encode-decode p i) = ≈here p
  ≈next (encode-decode p i) = encode-decode (≈next p) i
  path≃bisim : {ℓ : Level} {A : Type ℓ} {x y : Orbit A} → (x ≡ y) ≃ (x ≈ y)
  path≃bisim = isoToEquiv (iso encode bisim encode-decode decode-encode)

module Nucleus {ℓ : Level} {A B : Type ℓ} (f : A → B) (Φ : A → A) where
  open Orbit
  square : (a : A) → mapO (Carrier.carry-transport f) (unfold Φ a)
    ≈ unfold (Carrier.Φ-carrier f Φ) (Carrier.descend f a)
  ≈here (square a) = Carrier.carry-transport-descend f a
  ≈next (square a) = square (Φ a)
  transport-orbit : (a : A) → mapO (Carrier.carry-transport f) (unfold Φ a)
    ≡ unfold (Carrier.Φ-carrier f Φ) (Carrier.descend f a)
  transport-orbit a = bisim (square a)

-- Computational comparison: Xia et al., Interaction Trees (POPL 2020),
-- §2 and Fig. 2, events with typed continuations.
-- https://arxiv.org/abs/1906.00046
-- ISC makes each response depend on the current world and retains its
-- evidence and next-world continuation. Its react interface supplies a
-- response to a query; the paper's Vis node emits an event awaiting a reply.
module Dialogue where
  record ISC {ℓ : Level} {W : Type ℓ} (Q : W → Type ℓ)
    (O : (w : W) → Q w → W → Type ℓ)
    (E : (w : W) (q : Q w) (w' : W) → O w q w' → Type ℓ) (w : W) : Type ℓ where
    coinductive
    field
      react : (q : Q w) → Σ W (λ w' → Σ (O w q w') (λ o → E w q w' o × ISC Q O E w'))
  open ISC public
  Det : {ℓ : Level} {W : Type ℓ} → W → Type ℓ
  Det = ISC (λ _ → Unit*) (λ _ _ _ → Unit*) (λ _ _ _ _ → Unit*)
  det : {ℓ : Level} {W : Type ℓ} → (W → W) → (w : W) → Det w
  react (det Φ w) _ = Φ w , tt* , tt* , det Φ (Φ w)

record Dhārā (A : Type) : Type where
  coinductive
  field
    śiras : A
    śeṣam : Dhārā A

module Seed where
  caturaṃśa : Bool × Bool → Bool × Bool
  caturaṃśa (a , b) = not b , a
module Phase where
  data Z4 : Type where ph0 ph1 ph2 ph3 : Z4
module Amplitude where
  Gaussian : Type
  Gaussian = ℤ × ℤ
  oneG : Gaussian
  oneG = pos 1 , pos 0
  negG iG : Gaussian → Gaussian
  negG (a , b) = - a , - b
  iG (a , b) = - b , a
  squareMagnitude : ℤ → ℕ
  squareMagnitude a = abs a Cubical.Data.Nat.· abs a
  amplitudeWeight : Gaussian → ℕ
  amplitudeWeight (a , b) = squareMagnitude a Cubical.Data.Nat.+ squareMagnitude b
  square-neg : (a : ℤ) → squareMagnitude (- a) ≡ squareMagnitude a
  square-neg a = cong₂ Cubical.Data.Nat._·_ (abs- a) (abs- a)
  weight-i : (z : Gaussian) → amplitudeWeight (iG z) ≡ amplitudeWeight z
  weight-i (a , b) = cong (λ n → n Cubical.Data.Nat.+ squareMagnitude a) (square-neg b)
    ∙ Cubical.Data.Nat.+-comm (squareMagnitude b) (squareMagnitude a)
  phaseActionG : Phase.Z4 → Gaussian → Gaussian
  phaseActionG Phase.ph0 z = z
  phaseActionG Phase.ph1 z = iG z
  phaseActionG Phase.ph2 z = negG z
  phaseActionG Phase.ph3 (a , b) = b , - a
  phaseActionG-preserves-weight : (p : Phase.Z4) (z : Gaussian)
    → amplitudeWeight (phaseActionG p z) ≡ amplitudeWeight z
  phaseActionG-preserves-weight Phase.ph0 z = refl
  phaseActionG-preserves-weight Phase.ph1 z = weight-i z
  phaseActionG-preserves-weight Phase.ph2 (a , b) = cong₂ Cubical.Data.Nat._+_ (square-neg a) (square-neg b)
  phaseActionG-preserves-weight Phase.ph3 (a , b) =
    cong (Cubical.Data.Nat._+_ (squareMagnitude b)) (square-neg a)
    ∙ Cubical.Data.Nat.+-comm (squareMagnitude b) (squareMagnitude a)
  State₂ : Type
  State₂ = Gaussian × Gaussian
  weight₀ weight₁ : State₂ → ℕ
  weight₀ s = amplitudeWeight (fst s)
  weight₁ s = amplitudeWeight (snd s)
  phaseAction : Phase.Z4 → State₂ → State₂
  phaseAction p (a , b) = phaseActionG p a , phaseActionG p b

module Completion where
  open Dhārā
  module Take {A : Type₀} where

    take : ℕ → Dhārā A → List A
    take zero s = []
    take (suc n) s = śiras s ∷ take n (śeṣam s)

    take-drop : (m : ℕ) (a b : Dhārā A) → take (suc m) a ≡ take (suc m) b → take m a ≡ take m b
    take-drop zero a b h = refl
    take-drop (suc m) a b h = cong₂ _∷_ (cons-inj₁ h) (take-drop m (śeṣam a) (śeṣam b) (cons-inj₂ h))

    Cauchy : (ℕ → Dhārā A) → Type₀
    Cauchy r = (n : ℕ) → take n (r n) ≡ take n (r (suc n))

    limit : (ℕ → Dhārā A) → Dhārā A
    śiras (limit r) = śiras (r 1)
    śeṣam (limit r) = limit (λ n → śeṣam (r (suc n)))

    head-stable : (r : ℕ → Dhārā A) → Cauchy r → (m : ℕ) → śiras (r 1) ≡ śiras (r (suc m))
    head-stable r c zero = refl
    head-stable r c (suc m) = head-stable r c m ∙ cons-inj₁ (c (suc m))

    tail-cauchy : (r : ℕ → Dhārā A) → Cauchy r → Cauchy (λ n → śeṣam (r (suc n)))
    tail-cauchy r c n = cons-inj₂ (c (suc n))

    limit-agrees : (r : ℕ → Dhārā A) → Cauchy r → (n : ℕ) → take n (limit r) ≡ take n (r n)
    limit-agrees r c zero = refl
    limit-agrees r c (suc n) =
      cong₂ _∷_ (head-stable r c n) (limit-agrees (λ k → śeṣam (r (suc k))) (tail-cauchy r c) n)

    take-ext : {x y : Dhārā A} → ((n : ℕ) → take n x ≡ take n y) → x ≡ y
    śiras (take-ext h i) = cons-inj₁ (h 1) i
    śeṣam (take-ext h i) = take-ext (λ n → cons-inj₂ (h (suc n))) i

-- Optical reference: Reck, Zeilinger, Bernstein, Bertani, Experimental
-- realization of any discrete unitary operator, PRL 73, 58–61 (1994).
-- https://doi.org/10.1103/PhysRevLett.73.58
-- The two-mode sum/difference mixer is the balanced-interferometer matrix
-- with its common 1/sqrt(2) factor removed, keeping Gaussian arithmetic exact.
-- The plus/minus witnesses below expose relative phase through output ports.
module Had where
  open CommRingStr (snd ℤCommRing) using (_+_ ; _-_)
  add sub : Amplitude.Gaussian → Amplitude.Gaussian → Amplitude.Gaussian
  add (a , b) (c , d) = a + c , b + d
  sub (a , b) (c , d) = a - c , b - d
  H : Amplitude.State₂ → Amplitude.State₂
  H (x , y) = add x y , sub x y
  plusState minusState : Amplitude.Gaussian → Amplitude.State₂
  plusState x = x , x
  minusState x = x , Amplitude.negG x
  gaussianPath : {x y : Amplitude.Gaussian} → fst x ≡ fst y → snd x ≡ snd y → x ≡ y
  gaussianPath p q = ΣPathP (p , q)
  statePath : {x y : Amplitude.State₂} → fst x ≡ fst y → snd x ≡ snd y → x ≡ y
  statePath p q = ΣPathP (p , q)
-- Abramsky and Coecke, A categorical semantics of quantum protocols (2004),
-- §§6–7: central scalar action, conjugation, and inner products.
-- https://arxiv.org/html/quant-ph/0402130
-- H-commutes-global-phase is scalar naturality in coordinates. This quotient
-- identifies the four common Gaussian-unit phases; portWeights descends
-- because conjugate-square readings are invariant under that action.
module Projective where
  open CommRingStr (snd ℤCommRing) using (_+_ ; _-_ ; -_)
  State₂ : Type₀
  State₂ = Amplitude.State₂

  GlobalPhaseStep : State₂ → State₂ → Type₀
  GlobalPhaseStep x y =
    Σ[ phase ∈ Phase.Z4 ] (Amplitude.phaseAction phase x ≡ y)

  ProjectiveState₂ : Type₀
  ProjectiveState₂ = State₂ / GlobalPhaseStep

  project : State₂ → ProjectiveState₂
  project = [_]

  global-phase-path : (phase : Phase.Z4) (state : State₂)
    → project state ≡ project (Amplitude.phaseAction phase state)
  global-phase-path phase state = eq/ _ _ (phase , refl)

  PortWeights : Type₀
  PortWeights = ℕ × ℕ

  rawWeights : State₂ → PortWeights
  rawWeights state = Amplitude.weight₀ state , Amplitude.weight₁ state

  portWeights : State₂ → PortWeights
  portWeights state = rawWeights (Had.H state)

  H-commutes-global-phase : (phase : Phase.Z4) (state : State₂)
    → Had.H (Amplitude.phaseAction phase state)
      ≡ Amplitude.phaseAction phase (Had.H state)
  H-commutes-global-phase Phase.ph0 state = refl
  H-commutes-global-phase Phase.ph1 ((a , b) , (c , d)) =
    Had.statePath
      (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
      (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
  H-commutes-global-phase Phase.ph2 ((a , b) , (c , d)) =
    Had.statePath
      (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
      (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
  H-commutes-global-phase Phase.ph3 ((a , b) , (c , d)) =
    Had.statePath
      (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
      (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))

  phase-preserves-component-weights : (phase : Phase.Z4) (state : State₂)
    → (Amplitude.weight₀ (Amplitude.phaseAction phase state) ≡ Amplitude.weight₀ state)
      × (Amplitude.weight₁ (Amplitude.phaseAction phase state) ≡ Amplitude.weight₁ state)
  phase-preserves-component-weights phase (α , β) =
    Amplitude.phaseActionG-preserves-weight phase α ,
    Amplitude.phaseActionG-preserves-weight phase β

  global-phase-preserves-port-weights : (phase : Phase.Z4) (state : State₂)
    → portWeights (Amplitude.phaseAction phase state) ≡ portWeights state
  global-phase-preserves-port-weights phase state =
    cong rawWeights (H-commutes-global-phase phase state)
    ∙ cong₂ _,_
        (fst (phase-preserves-component-weights phase (Had.H state)))
        (snd (phase-preserves-component-weights phase (Had.H state)))

  projectivePortWeights : ProjectiveState₂ → PortWeights
  projectivePortWeights =
    SQ.rec (isSet× isSetℕ isSetℕ) portWeights respects
    where
    respects : (x y : State₂) → GlobalPhaseStep x y → portWeights x ≡ portWeights y
    respects x y (phase , equality) =
      sym (global-phase-preserves-port-weights phase x)
      ∙ cong portWeights equality

  plusRay minusRay : ProjectiveState₂
  plusRay = project (Had.plusState Amplitude.oneG)
  minusRay = project (Had.minusState Amplitude.oneG)

  plus-ray-ports : projectivePortWeights plusRay ≡ (4 , 0)
  plus-ray-ports = refl

  minus-ray-ports : projectivePortWeights minusRay ≡ (0 , 4)
  minus-ray-ports = refl

  four≢zero : ¬ (4 ≡ 0)
  four≢zero = snotz

  relative-phase-survives-projectivization : ¬ (plusRay ≡ minusRay)
  relative-phase-survives-projectivization equality =
    four≢zero
      (cong fst
        (sym plus-ray-ports
        ∙ cong projectivePortWeights equality
        ∙ minus-ray-ports))

AmplitudeSpace : Type
AmplitudeSpace = Amplitude.Gaussian

quarter : AmplitudeSpace → AmplitudeSpace
quarter = Amplitude.iG

weight : AmplitudeSpace → ℕ
weight = Amplitude.amplitudeWeight

pythagorean : (a b : ℤ) → weight (a , b)
  ≡ Amplitude.squareMagnitude a Cubical.Data.Nat.+ Amplitude.squareMagnitude b
pythagorean a b = refl

quarter-preserves-weight : (z : AmplitudeSpace) → weight (quarter z) ≡ weight z
quarter-preserves-weight = Amplitude.weight-i

quarter-squared : (z : AmplitudeSpace) → quarter (quarter z) ≡ Amplitude.negG z
quarter-squared (a , b) = refl

quarter-fourth : (z : AmplitudeSpace)
  → quarter (quarter (quarter (quarter z))) ≡ z
quarter-fourth (a , b) i = -Involutive a i , -Involutive b i

quarter-square-not-identity : ¬ ((z : AmplitudeSpace) → quarter (quarter z) ≡ z)
quarter-square-not-identity p = negsucNotpos 0 1 (cong fst (p Amplitude.oneG))

quarter-equivalence : AmplitudeSpace ≃ AmplitudeSpace
quarter-equivalence = isoToEquiv (iso quarter
  (λ z → quarter (quarter (quarter z))) quarter-fourth quarter-fourth)

quarter-loop : AmplitudeSpace ≡ AmplitudeSpace
quarter-loop = ua quarter-equivalence

quarter-loop-computes : (z : AmplitudeSpace) → transport quarter-loop z ≡ quarter z
quarter-loop-computes = uaβ quarter-equivalence

z4-preserves-weight : (p : Phase.Z4) (z : AmplitudeSpace)
  → weight (Amplitude.phaseActionG p z) ≡ weight z
z4-preserves-weight = Amplitude.phaseActionG-preserves-weight

chi : Bool × Bool → AmplitudeSpace
chi (true  , true ) = pos 1 , pos 0
chi (false , true ) = pos 0 , pos 1
chi (false , false) = negsuc 0 , pos 0
chi (true  , false) = pos 0 , negsuc 0

seed-is-complex-quarter : (s : Bool × Bool)
  → chi (Seed.caturaṃśa s) ≡ quarter (chi s)
seed-is-complex-quarter (true  , true ) = refl
seed-is-complex-quarter (false , true ) = refl
seed-is-complex-quarter (false , false) = refl
seed-is-complex-quarter (true  , false) = refl

private
  decode-phase : AmplitudeSpace → Bool × Bool
  decode-phase (pos (suc n) , _) = true , true
  decode-phase (negsuc n , _) = false , false
  decode-phase (pos zero , pos (suc n)) = false , true
  decode-phase (pos zero , _) = true , false

  decode-chi : (s : Bool × Bool) → decode-phase (chi s) ≡ s
  decode-chi (true , true) = refl
  decode-chi (false , true) = refl
  decode-chi (false , false) = refl
  decode-chi (true , false) = refl

chi-injective : (s t : Bool × Bool) → chi s ≡ chi t → s ≡ t
chi-injective s t p = sym (decode-chi s) ∙ cong decode-phase p ∙ decode-chi t

seed-orbit-intertwines : (s : Bool × Bool)
  → Orbit.mapO chi (Orbit.unfold Seed.caturaṃśa s)
    Orbit.≈ Orbit.unfold quarter (chi s)
Orbit.≈here (seed-orbit-intertwines s) = refl
Orbit.≈next (seed-orbit-intertwines (true , true)) = seed-orbit-intertwines (false , true)
Orbit.≈next (seed-orbit-intertwines (false , true)) = seed-orbit-intertwines (false , false)
Orbit.≈next (seed-orbit-intertwines (false , false)) = seed-orbit-intertwines (true , false)
Orbit.≈next (seed-orbit-intertwines (true , false)) = seed-orbit-intertwines (true , true)

amplitude-is-weight-and-fibre : AmplitudeSpace ≃ Σ ℕ (fiber weight)
amplitude-is-weight-and-fibre = Fibre.lossless weight

amplitude-is-carrier : AmplitudeSpace ≃ Carrier.Carrier weight
amplitude-is-carrier = Carrier.Carrier≃ weight

phase-trajectory : AmplitudeSpace → Orbit.Orbit AmplitudeSpace
phase-trajectory = Orbit.unfold quarter

phase-execution-is-path : {x y : Orbit.Orbit AmplitudeSpace}
  → (x ≡ y) ≃ (x Orbit.≈ y)
phase-execution-is-path = Orbit.path≃bisim

carried-phase-trajectory : (z : AmplitudeSpace)
  → Orbit.mapO (Carrier.carry-transport weight) (phase-trajectory z)
  ≡ Orbit.unfold (Carrier.Φ-carrier weight quarter) (Carrier.descend weight z)
carried-phase-trajectory = Nucleus.transport-orbit weight quarter

fibre-quarter : (n : ℕ) → fiber weight n → fiber weight n
fibre-quarter n (z , p) = quarter z , quarter-preserves-weight z ∙ p

phase-in-one-fibre : (z : AmplitudeSpace) → Orbit.Orbit (fiber weight (weight z))
phase-in-one-fibre z = Orbit.unfold (fibre-quarter (weight z)) (z , refl)

forget-fibre-orbit : (n : ℕ) (z : fiber weight n)
  → Orbit.mapO fst (Orbit.unfold (fibre-quarter n) z) Orbit.≈ phase-trajectory (fst z)
Orbit.≈here (forget-fibre-orbit n z) = refl
Orbit.≈next (forget-fibre-orbit n z) = forget-fibre-orbit n (fibre-quarter n z)

retained-phase-is-original : (z : AmplitudeSpace)
  → Orbit.mapO fst (phase-in-one-fibre z) ≡ phase-trajectory z
retained-phase-is-original z = Orbit.bisim (forget-fibre-orbit (weight z) (z , refl))

phase-interaction : (z : AmplitudeSpace) → Dialogue.Det z
phase-interaction = Dialogue.det quarter

PhaseQuery : AmplitudeSpace → Type
PhaseQuery _ = Phase.Z4

PhaseReading : (z : AmplitudeSpace) → PhaseQuery z → AmplitudeSpace → Type
PhaseReading _ _ _ = ℕ

PhaseEvent : (z : AmplitudeSpace) (p : PhaseQuery z) (z' : AmplitudeSpace)
  → PhaseReading z p z' → Type
PhaseEvent z p z' n = (Amplitude.phaseActionG p z ≡ z')
  × (weight z' ≡ weight z) × (n ≡ weight z')

PhotonInteraction : AmplitudeSpace → Type
PhotonInteraction = Dialogue.ISC PhaseQuery PhaseReading PhaseEvent

photon-interaction : (z : AmplitudeSpace) → PhotonInteraction z
Dialogue.react (photon-interaction z) p =
  Amplitude.phaseActionG p z , weight (Amplitude.phaseActionG p z) ,
  (refl , z4-preserves-weight p z , refl) ,
  photon-interaction (Amplitude.phaseActionG p z)

interactive-weight-conservation : (z : AmplitudeSpace) (p : Phase.Z4)
  → weight (fst (Dialogue.react (photon-interaction z) p)) ≡ weight z
interactive-weight-conservation = z4-preserves-weight-flipped
  where
  z4-preserves-weight-flipped : (z : AmplitudeSpace) (p : Phase.Z4)
    → weight (Amplitude.phaseActionG p z) ≡ weight z
  z4-preserves-weight-flipped z p = z4-preserves-weight p z

global-phase-identifies : (p : Phase.Z4) (s : Amplitude.State₂)
  → Projective.project s ≡ Projective.project (Amplitude.phaseAction p s)
global-phase-identifies = Projective.global-phase-path

relative-phase-remains : ¬ (Projective.plusRay ≡ Projective.minusRay)
relative-phase-remains = Projective.relative-phase-survives-projectivization

positive-interference : Projective.projectivePortWeights Projective.plusRay ≡ (4 , 0)
positive-interference = Projective.plus-ray-ports

negative-interference : Projective.projectivePortWeights Projective.minusRay ≡ (0 , 4)
negative-interference = Projective.minus-ray-ports

-- Physics reference [RS]: I. Bialynicki-Birula and Z. Bialynicka-Birula,
-- The role of the Riemann–Silberstein vector in classical and quantum theories
-- of electromagnetism, J. Phys. A 46 (2013) 053001, §§1–2, 11.2.
-- https://arxiv.org/html/1211.2655
-- With F=E+i cB, source-free Maxwell becomes i Dt F=c curl F.
-- Below, units absorb c; the equivalence retains both transverse constraints.
module FieldEquations {ℓ : Level}
  (V : Type ℓ) (V-set : isSet V)
  (neg : V → V) (neg-involutive : (v : V) → neg (neg v) ≡ v)
  (Dt curl : V → V)
  (Transverse : V → Type ℓ)
  (transverse-prop : (v : V) → isProp (Transverse v)) where

  Field : Type ℓ
  Field = V × V

  rotateI : Field → Field
  rotateI (E , B) = neg B , E

  derivative hamiltonian : Field → Field
  derivative  (E , B) = Dt E , Dt B
  hamiltonian (E , B) = curl E , curl B

  Maxwell : Field → Type ℓ
  Maxwell (E , B) = (Dt E ≡ curl B) × (Dt B ≡ neg (curl E))

  Schrodinger : Field → Type ℓ
  Schrodinger F = rotateI (derivative F) ≡ hamiltonian F

  Constraints : Field → Type ℓ
  Constraints (E , B) = Transverse E × Transverse B

  maxwell-prop : (F : Field) → isProp (Maxwell F)
  maxwell-prop (E , B) = isProp× (V-set _ _) (V-set _ _)

  schrodinger-prop : (F : Field) → isProp (Schrodinger F)
  schrodinger-prop F = isSet× V-set V-set _ _

  maxwell-to-schrodinger : (F : Field) → Maxwell F → Schrodinger F
  maxwell-to-schrodinger (E , B) (electric , magnetic) =
    cong₂ _,_ (cong neg magnetic ∙ neg-involutive (curl E)) electric

  schrodinger-to-maxwell : (F : Field) → Schrodinger F → Maxwell F
  schrodinger-to-maxwell (E , B) p =
    cong snd p , sym (neg-involutive (Dt B)) ∙ cong neg (cong fst p)

  maxwell≃schrodinger : (F : Field) → Maxwell F ≃ Schrodinger F
  maxwell≃schrodinger F = propBiimpl→Equiv (maxwell-prop F) (schrodinger-prop F)
    (maxwell-to-schrodinger F) (schrodinger-to-maxwell F)

  constrained-equations : (F : Field)
    → (Maxwell F × Constraints F) ≃ (Schrodinger F × Constraints F)
  constrained-equations F = propBiimpl→Equiv
    (isProp× (maxwell-prop F) (isProp× (transverse-prop (fst F)) (transverse-prop (snd F))))
    (isProp× (schrodinger-prop F) (isProp× (transverse-prop (fst F)) (transverse-prop (snd F))))
    (λ (p , c) → maxwell-to-schrodinger F p , c)
    (λ (p , c) → schrodinger-to-maxwell F p , c)

  MaxwellObject SchrodingerObject : Type ℓ
  MaxwellObject = Σ Field (λ F → Maxwell F × Constraints F)
  SchrodingerObject = Σ Field (λ F → Schrodinger F × Constraints F)

  maxwell-object≃schrodinger-object : MaxwellObject ≃ SchrodingerObject
  maxwell-object≃schrodinger-object = Σ-cong-equiv-snd constrained-equations

  maxwell-object≡schrodinger-object : MaxwellObject ≡ SchrodingerObject
  maxwell-object≡schrodinger-object = ua maxwell-object≃schrodinger-object

  transport-physics : {ℓ' : Level} (P : Type ℓ → Type ℓ')
    → P MaxwellObject → P SchrodingerObject
  transport-physics P = subst P maxwell-object≡schrodinger-object

  coinductive-field-identity : Orbit.Orbit MaxwellObject ≡ Orbit.Orbit SchrodingerObject
  coinductive-field-identity = cong Orbit.Orbit maxwell-object≡schrodinger-object

  module CompatibleDifferentiation
    (Dt-neg : (v : V) → Dt (neg v) ≡ neg (Dt v))
    (curl-neg : (v : V) → curl (neg v) ≡ neg (curl v))
    (Dt-curl : (v : V) → Dt (curl v) ≡ curl (Dt v)) where

    electric-wave : (F : Field) → Maxwell F
      → Dt (Dt (fst F)) ≡ neg (curl (curl (fst F)))
    electric-wave (E , B) (electric , magnetic) =
      cong Dt electric ∙ Dt-curl B ∙ cong curl magnetic ∙ curl-neg (curl E)

    magnetic-wave : (F : Field) → Maxwell F
      → Dt (Dt (snd F)) ≡ neg (curl (curl (snd F)))
    magnetic-wave (E , B) (electric , magnetic) =
      cong Dt magnetic ∙ Dt-neg (curl E)
      ∙ cong neg (Dt-curl E ∙ cong curl electric)

    schrodinger-waves : (F : Field) → Schrodinger F
      → (Dt (Dt (fst F)) ≡ neg (curl (curl (fst F))))
      × (Dt (Dt (snd F)) ≡ neg (curl (curl (snd F))))
    schrodinger-waves F p = electric-wave F (schrodinger-to-maxwell F p)
                         , magnetic-wave F (schrodinger-to-maxwell F p)

    maxwell-generator : Field → Field
    maxwell-generator (E , B) = curl B , neg (curl E)

    generator-factorization : (F : Field)
      → rotateI (maxwell-generator F) ≡ hamiltonian F
    generator-factorization (E , B) = cong₂ _,_ (neg-involutive (curl E)) refl

    duality-commutes-generator : (F : Field)
      → rotateI (maxwell-generator F) ≡ maxwell-generator (rotateI F)
    duality-commutes-generator (E , B) = cong₂ _,_
      (neg-involutive (curl E))
      (sym (cong neg (curl-neg B) ∙ neg-involutive (curl B)))

    duality-preserves-equations : (F : Field) → Maxwell F → Maxwell (rotateI F)
    duality-preserves-equations (E , B) (electric , magnetic) =
      (Dt-neg B ∙ cong neg magnetic ∙ neg-involutive (curl E)) ,
      (electric ∙ sym (cong neg (curl-neg B) ∙ neg-involutive (curl B)))

  module Evolution (Φ : MaxwellObject → MaxwellObject) where

    schrodinger-step : SchrodingerObject → SchrodingerObject
    schrodinger-step = transport-physics (λ X → X → X) Φ

    dynamics-identification : PathP
      (λ i → maxwell-object≡schrodinger-object i → maxwell-object≡schrodinger-object i)
      Φ schrodinger-step
    dynamics-identification = toPathP refl

    module Observation (B : Type ℓ) (q : MaxwellObject → B) where

      field-is-observation-and-fibre : MaxwellObject ≃ Σ B (fiber q)
      field-is-observation-and-fibre = Fibre.lossless q

      field-is-carrier : MaxwellObject ≡ Carrier.Carrier q
      field-is-carrier = Carrier.Carrier≡ q

      complete-execution : (s : MaxwellObject)
        → Orbit.mapO (Carrier.carry-transport q) (Orbit.unfold Φ s)
        ≡ Orbit.unfold (Carrier.Φ-carrier q Φ) (Carrier.descend q s)
      complete-execution = Nucleus.transport-orbit q Φ

      complete-interaction : (s : MaxwellObject) → Dialogue.Det s
      complete-interaction = Dialogue.det Φ

module SourceFreeFields {ℓ : Level}
  (V W : Type ℓ) (V-set : isSet V) (W-set : isSet W)
  (neg : V → V) (neg-involutive : (v : V) → neg (neg v) ≡ v)
  (Dt curl : V → V) (divergence : V → W) (zeroW : W) where

  open FieldEquations V V-set neg neg-involutive Dt curl
    (λ v → divergence v ≡ zeroW) (λ v → W-set (divergence v) zeroW) public

  source-free-maxwell≡schrodinger : MaxwellObject ≡ SchrodingerObject
  source-free-maxwell≡schrodinger = maxwell-object≡schrodinger-object

-- [RS] §2: electromagnetic duality acts by F -> exp(i phi) F.
-- turn is its quarter rotation; rotation-norm is the polynomial identity
-- behind the unit-circle action. For fields this rotates electric/magnetic
-- components; its observational meaning depends on the chosen reading.
module ModeAlgebra {ℓ : Level} (R : CommRing ℓ) where
  open CommRingStr (snd R) using (0r ; 1r)
    renaming (_+_ to _+r_ ; _·_ to _*r_ ; -_ to negR ; _-_ to _-r_)

  Complex : Type ℓ
  Complex = fst R × fst R

  turn : Complex → Complex
  turn (a , b) = negR b , a

  norm : Complex → fst R
  norm (a , b) = (a *r a) +r (b *r b)

  multiply : Complex → Complex → Complex
  multiply (a , b) (c , d) = (a *r c) -r (b *r d) , (a *r d) +r (b *r c)

  conjugate : Complex → Complex
  conjugate (a , b) = a , negR b

  add : Complex → Complex → Complex
  add (a , b) (c , d) = a +r c , b +r d

  turn-four : (z : Complex) → turn (turn (turn (turn z))) ≡ z
  turn-four (a , b) = cong₂ _,_ (solve! R) (solve! R)

  turn-norm : (z : Complex) → norm (turn z) ≡ norm z
  turn-norm (a , b) = solve! R

  rotation-norm : (a b : fst R) (z : Complex)
    → norm (multiply (a , b) z) ≡ ((a *r a) +r (b *r b)) *r norm z
  rotation-norm a b (c , d) = solve! R

  unit-circle-rotation : (a b : fst R) → (a *r a) +r (b *r b) ≡ 1r
    → (z : Complex) → norm (multiply (a , b) z) ≡ norm z
  unit-circle-rotation a b h z = rotation-norm a b z
    ∙ cong (_*r norm z) h ∙ unit-norm (norm z)
    where
    unit-norm : (x : fst R) → 1r *r x ≡ x
    unit-norm x = solve! R

  Modes : Type ℓ
  Modes = Complex × Complex

  -- In the two-mode optical language of Reck et al. (reference at Had),
  -- this is exchange followed by a quarter-phase shift on the first output:
  -- matrix [[0,i],[1,0]]. crossing-hermitian verifies its conserved pairing;
  -- crossing-braid computes the adjacent three-mode coherence explicitly.
  crossing : Modes → Modes
  crossing (x , y) = turn y , x

  total-norm : Modes → fst R
  total-norm (x , y) = norm x +r norm y

  crossing-norm : (v : Modes) → total-norm (crossing v) ≡ total-norm v
  crossing-norm ((a , b) , (c , d)) = solve! R

  hermitian : Modes → Modes → Complex
  hermitian (x , y) (u , v) = add (multiply (conjugate x) u) (multiply (conjugate y) v)

  crossing-hermitian : (x y : Modes)
    → hermitian (crossing x) (crossing y) ≡ hermitian x y
  crossing-hermitian ((a , b) , (c , d)) ((e , f) , (g , h)) =
    cong₂ _,_ (solve! R) (solve! R)

  crossing-square : (x y : Complex) → crossing (crossing (x , y)) ≡ (turn x , turn y)
  crossing-square x y = refl

  crossing-four : (x y : Complex)
    → crossing (crossing (crossing (crossing (x , y))))
    ≡ (turn (turn x) , turn (turn y))
  crossing-four x y = refl

  crossing-eight : (v : Modes)
    → crossing (crossing (crossing (crossing (crossing (crossing (crossing (crossing v))))))) ≡ v
  crossing-eight (x , y) = cong₂ _,_ (turn-four x) (turn-four y)

  crossing-equivalence : Modes ≃ Modes
  crossing-equivalence = isoToEquiv (iso crossing
    (λ v → crossing (crossing (crossing (crossing (crossing (crossing (crossing v)))))))
    crossing-eight crossing-eight)

  Triple : Type ℓ
  Triple = Complex × Complex × Complex

  U12 U23 : Triple → Triple
  U12 (x , y , z) = turn y , x , z
  U23 (x , y , z) = x , turn z , y

  crossing-braid : (v : Triple) → U12 (U23 (U12 v)) ≡ U23 (U12 (U23 v))
  crossing-braid v = refl

  braid-normal-form : (x y z : Complex)
    → U12 (U23 (U12 (x , y , z))) ≡ (turn (turn z) , turn y , x)
  braid-normal-form x y z = refl

  subtract : Complex → Complex → Complex
  subtract (a , b) (c , d) = a -r c , b -r d

  determinant2 : Complex → Complex → Complex → Complex → Complex
  determinant2 a b c d = subtract (multiply a d) (multiply b c)

  crossing-determinant : determinant2 (0r , 0r) (0r , 1r) (1r , 0r) (0r , 0r)
    ≡ (0r , negR 1r)
  crossing-determinant = cong₂ _,_ (solve! R) (solve! R)

module GaussianModes = ModeAlgebra ℤCommRing

encode-modes : (Bool × Bool) × (Bool × Bool) → Amplitude.State₂
encode-modes (s , t) = chi s , chi t

seed-crossing : (Bool × Bool) × (Bool × Bool) → (Bool × Bool) × (Bool × Bool)
seed-crossing (s , t) = Seed.caturaṃśa t , s

crossing-encoding : (s t : Bool × Bool)
  → encode-modes (seed-crossing (s , t)) ≡ GaussianModes.crossing (encode-modes (s , t))
crossing-encoding s t = cong₂ _,_ (seed-is-complex-quarter t) refl

module Tower where
  open import Cubical.Foundations.Function using (_∘_)
  open import Cubical.Foundations.HLevels using (isPropΠ)
  open import Cubical.Data.Nat.Order using (¬-<-zero ; ≤-split ; pred-≤-pred ; ≤-refl)
  open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
  open import Cubical.Data.Fin using (Fin ; toℕ ; toℕ-injective ; inject< ; flast)
  import Cubical.Data.Empty as ⊥
  injectSuc : {n : ℕ} → Fin n → Fin (suc n)
  injectSuc = inject< ≤-refl
  topSplit : {n : ℕ} (i : Fin (suc n)) → (i ≡ flast) ⊎ (Σ[ j ∈ Fin n ] injectSuc j ≡ i)
  topSplit {n} (k , k<sn) with ≤-split (pred-≤-pred k<sn)
  ... | inl k<n = inr ((k , k<n) , toℕ-injective refl)
  ... | inr k≡n = inl (toℕ-injective k≡n)

  private
    variable
      ℓ : Level
      A : Type ℓ

  W : Type ℓ → ℕ → Type ℓ
  W A n = Fin n → A

  dropMSD : (n : ℕ) → W A (suc n) → W A n
  dropMSD n w = w ∘ injectSuc

  InvLim : (X : ℕ → Type ℓ) → ((n : ℕ) → X (suc n) → X n) → Type ℓ
  InvLim X step = Σ[ x ∈ ((n : ℕ) → X n) ]
                    ((n : ℕ) → step n (x (suc n)) ≡ x n)

  MSDLimit : Type ℓ → Type ℓ
  MSDLimit A = InvLim (W A) dropMSD

  fromSeq : (ℕ → A) → MSDLimit A
  fst (fromSeq f) n i = f (toℕ i)
  snd (fromSeq f) n   = refl

  toSeq : MSDLimit A → (ℕ → A)
  toSeq (x , _) m = x (suc m) flast

  toSeq-fromSeq : (f : ℕ → A) → (m : ℕ) → toSeq (fromSeq f) m ≡ f m
  toSeq-fromSeq f m = refl

  reconstruct : (L : MSDLimit A) (n : ℕ) (i : Fin n)
              → fst L n i ≡ toSeq L (toℕ i)
  reconstruct L zero (k , k<0) = ⊥.rec (¬-<-zero k<0)
  reconstruct L (suc n) i with topSplit i
  ... | inl i≡last =
          cong (fst L (suc n)) i≡last
        ∙ sym (cong (toSeq L) (cong toℕ i≡last))
  ... | inr (j , inj≡i) =
          cong (fst L (suc n)) (sym inj≡i)
        ∙ (λ t → snd L n t j)
        ∙ reconstruct L n j
        ∙ cong (toSeq L) (cong toℕ inj≡i)

  module _ (setA : isSet A) where

    coherence-isProp : (x : (n : ℕ) → W A n)
                     → isProp ((n : ℕ) → dropMSD n (x (suc n)) ≡ x n)
    coherence-isProp x = isPropΠ λ n → isSetΠ (λ _ → setA) _ _

    MSDLimitIso : Iso (MSDLimit A) (ℕ → A)
    Iso.fun MSDLimitIso      = toSeq
    Iso.inv MSDLimitIso      = fromSeq
    Iso.rightInv MSDLimitIso = λ f → funExt (toSeq-fromSeq f)
    Iso.leftInv MSDLimitIso  = λ L →
      Σ≡Prop coherence-isProp
        (funExt λ n → funExt λ i → sym (reconstruct L n i))

    MSDLimitEquiv : MSDLimit A ≃ (ℕ → A)
    MSDLimitEquiv = isoToEquiv MSDLimitIso

module CompleteExecution (A : Type) where
  open Dhārā
  open Completion.Take {A = A} public

  fromOrbit : Orbit.Orbit A → Dhārā A
  śiras (fromOrbit s) = Orbit.here s
  śeṣam (fromOrbit s) = fromOrbit (Orbit.next s)

  toOrbit : Dhārā A → Orbit.Orbit A
  Orbit.here (toOrbit s) = śiras s
  Orbit.next (toOrbit s) = toOrbit (śeṣam s)

  from-to : (s : Dhārā A) → fromOrbit (toOrbit s) ≡ s
  śiras (from-to s i) = śiras s
  śeṣam (from-to s i) = from-to (śeṣam s) i

  to-from : (s : Orbit.Orbit A) → toOrbit (fromOrbit s) ≡ s
  Orbit.here (to-from s i) = Orbit.here s
  Orbit.next (to-from s i) = to-from (Orbit.next s) i

  orbit≃complete-stream : Orbit.Orbit A ≃ Dhārā A
  orbit≃complete-stream = isoToEquiv (iso fromOrbit toOrbit from-to to-from)

  sequence : Dhārā A → ℕ → A
  sequence s zero = śiras s
  sequence s (suc n) = sequence (śeṣam s) n

  from-sequence : (ℕ → A) → Dhārā A
  śiras (from-sequence f) = f zero
  śeṣam (from-sequence f) = from-sequence (λ n → f (suc n))

  sequence-roundtrip : (s : Dhārā A) → from-sequence (sequence s) ≡ s
  śiras (sequence-roundtrip s i) = śiras s
  śeṣam (sequence-roundtrip s i) = sequence-roundtrip (śeṣam s) i

  sequence-from : (f : ℕ → A) (n : ℕ) → sequence (from-sequence f) n ≡ f n
  sequence-from f zero = refl
  sequence-from f (suc n) = sequence-from (λ k → f (suc k)) n

  stream≃sequence : Dhārā A ≃ (ℕ → A)
  stream≃sequence = isoToEquiv (iso sequence from-sequence
    (λ f → funExt (sequence-from f)) sequence-roundtrip)

  finite-tower≃orbit : isSet A → Tower.MSDLimit A ≃ Orbit.Orbit A
  finite-tower≃orbit setA = compEquiv (Tower.MSDLimitEquiv setA)
    (compEquiv (invEquiv stream≃sequence) (invEquiv orbit≃complete-stream))

  stream-set : isSet A → isSet (Dhārā A)
  stream-set setA = isSetRetract sequence from-sequence sequence-roundtrip (isSetΠ (λ _ → setA))

  orbit-limit : (ℕ → Orbit.Orbit A) → Orbit.Orbit A
  orbit-limit r = toOrbit (limit (λ n → fromOrbit (r n)))

  mapInto : {B : Type} → (A → B) → Dhārā A → Dhārā B
  śiras (mapInto f s) = f (śiras s)
  śeṣam (mapInto f s) = mapInto f (śeṣam s)

  map-limit : {B : Type} (f : A → B) (r : ℕ → Dhārā A)
    → mapInto f (limit r) ≡ Completion.Take.limit (λ n → mapInto f (r n))
  śiras (map-limit f r i) = f (śiras (r 1))
  śeṣam (map-limit f r i) = map-limit f (λ n → śeṣam (r (suc n))) i

  complete-limit-unique : (r : ℕ → Dhārā A) → Cauchy r → (s : Dhārā A)
    → ((n : ℕ) → take n s ≡ take n (r n)) → s ≡ limit r
  complete-limit-unique r c s agrees =
    take-ext (λ n → agrees n ∙ sym (limit-agrees r c n))

  ContinuousWith : (ℕ → ℕ) → (Dhārā A → Dhārā A) → Type
  ContinuousWith modulus op = (n : ℕ) (x y : Dhārā A)
    → take (modulus n) x ≡ take (modulus n) y → take n (op x) ≡ take n (op y)

  equation-at-limit : (r : ℕ → Dhārā A) → Cauchy r
    → (modulus : ℕ → ℕ) (lhs rhs : Dhārā A → Dhārā A)
    → ContinuousWith modulus lhs → ContinuousWith modulus rhs
    → ((n : ℕ) → lhs (r n) ≡ rhs (r n))
    → lhs (limit r) ≡ rhs (limit r)
  equation-at-limit r c modulus lhs rhs left-cont right-cont equation = take-ext λ n →
    left-cont n (limit r) (r (modulus n)) (limit-agrees r c (modulus n))
    ∙ cong (take n) (equation (modulus n))
    ∙ right-cont n (r (modulus n)) (limit r) (sym (limit-agrees r c (modulus n)))

phase-encoding-commutes-with-limit : (r : ℕ → Dhārā (Bool × Bool))
  → CompleteExecution.mapInto (Bool × Bool) chi (Completion.Take.limit r)
  ≡ Completion.Take.limit (λ n → CompleteExecution.mapInto (Bool × Bool) chi (r n))
phase-encoding-commutes-with-limit = CompleteExecution.map-limit (Bool × Bool) chi

module FinitePropagation (A : Type) (turn : A → A) where
  open Dhārā
  open CompleteExecution A

  finite-turn : ℕ → Dhārā A → Dhārā A
  finite-turn zero s = s
  śiras (finite-turn (suc n) s) = turn (śiras s)
  śeṣam (finite-turn (suc n) s) = finite-turn n (śeṣam s)

  finite-agrees : (n : ℕ) (s : Dhārā A)
    → take n (finite-turn n s) ≡ take n (mapInto turn s)
  finite-agrees zero s = refl
  finite-agrees (suc n) s = cong (turn (śiras s) ∷_) (finite-agrees n (śeṣam s))

  finite-cauchy : (s : Dhārā A) → Cauchy (λ n → finite-turn n s)
  finite-cauchy s zero = refl
  finite-cauchy s (suc n) = cong (turn (śiras s) ∷_) (finite-cauchy (śeṣam s) n)

  finite-limit-is-full-turn : (s : Dhārā A)
    → limit (λ n → finite-turn n s) ≡ mapInto turn s
  finite-limit-is-full-turn s = take-ext λ n →
    limit-agrees (λ k → finite-turn k s) (finite-cauchy s) n ∙ finite-agrees n s

  uniform-continuity : (n : ℕ) (s t : Dhārā A) → take n s ≡ take n t
    → take n (mapInto turn s) ≡ take n (mapInto turn t)
  uniform-continuity zero s t p = refl
  uniform-continuity (suc n) s t p = cong₂ _∷_
    (cong turn (cons-inj₁ p)) (uniform-continuity n (śeṣam s) (śeṣam t) (cons-inj₂ p))

module PhaseLimit = FinitePropagation AmplitudeSpace quarter

module FieldLimit (A : Type) (setA : isSet A)
  (neg : Dhārā A → Dhārā A)
  (neg-involutive : (v : Dhārā A) → neg (neg v) ≡ v)
  (Dt curl : Dhārā A → Dhārā A) where

  open CompleteExecution A

  maxwell-at-limit : (e b : ℕ → Dhārā A) → Cauchy e → Cauchy b
    → (modulus : ℕ → ℕ)
    → ContinuousWith modulus Dt
    → ContinuousWith modulus curl
    → ContinuousWith modulus (λ v → neg (curl v))
    → ((n : ℕ) → (Dt (e n) ≡ curl (b n)) × (Dt (b n) ≡ neg (curl (e n))))
    → (Dt (limit e) ≡ curl (limit b)) × (Dt (limit b) ≡ neg (curl (limit e)))
  maxwell-at-limit e b ce cb modulus d-cont c-cont nc-cont equations =
    take-ext (λ n →
      d-cont n (limit e) (e (modulus n)) (limit-agrees e ce (modulus n))
      ∙ cong (take n) (fst (equations (modulus n)))
      ∙ c-cont n (b (modulus n)) (limit b) (sym (limit-agrees b cb (modulus n)))) ,
    take-ext (λ n →
      d-cont n (limit b) (b (modulus n)) (limit-agrees b cb (modulus n))
      ∙ cong (take n) (snd (equations (modulus n)))
      ∙ nc-cont n (e (modulus n)) (limit e) (sym (limit-agrees e ce (modulus n))))

  module WithConstraints (Transverse : Dhārā A → Type)
    (transverse-prop : (v : Dhārā A) → isProp (Transverse v)) where
    module Equations = FieldEquations (Dhārā A) (stream-set setA)
      neg neg-involutive Dt curl Transverse transverse-prop

    schrodinger-at-limit : (e b : ℕ → Dhārā A) → Cauchy e → Cauchy b
      → (modulus : ℕ → ℕ)
      → ContinuousWith modulus Dt → ContinuousWith modulus curl
      → ContinuousWith modulus (λ v → neg (curl v))
      → ((n : ℕ) → Equations.Maxwell (e n , b n))
      → Equations.Schrodinger (limit e , limit b)
    schrodinger-at-limit e b ce cb m dc cc nc equations =
      Equations.maxwell-to-schrodinger (limit e , limit b)
        (maxwell-at-limit e b ce cb m dc cc nc equations)

  module Divergence (divergence : Dhārā A → Dhārā A) (zeroField : Dhārā A) where
    module Equations = FieldEquations (Dhārā A) (stream-set setA)
      neg neg-involutive Dt curl
      (λ v → divergence v ≡ zeroField) (λ v → stream-set setA _ _)

    transverse-at-limit : (r : ℕ → Dhārā A) → Cauchy r
      → (modulus : ℕ → ℕ) → ContinuousWith modulus divergence
      → ((n : ℕ) → divergence (r n) ≡ zeroField)
      → divergence (limit r) ≡ zeroField
    transverse-at-limit r c m div-cont transverse = take-ext λ n →
      div-cont n (limit r) (r (m n)) (limit-agrees r c (m n))
      ∙ cong (take n) (transverse (m n))

    full-solution-at-limit : (e b : ℕ → Dhārā A) → Cauchy e → Cauchy b
      → (modulus : ℕ → ℕ)
      → ContinuousWith modulus Dt → ContinuousWith modulus curl
      → ContinuousWith modulus (λ v → neg (curl v))
      → ContinuousWith modulus divergence
      → ((n : ℕ) → Equations.Maxwell (e n , b n) × Equations.Constraints (e n , b n))
      → Equations.MaxwellObject
    full-solution-at-limit e b ce cb m dc cc nc vc equations =
      (limit e , limit b) ,
      maxwell-at-limit e b ce cb m dc cc nc (λ n → fst (equations n)) ,
      transverse-at-limit e ce m vc (λ n → fst (snd (equations n))) ,
      transverse-at-limit b cb m vc (λ n → snd (snd (equations n)))

    schrodinger-solution-at-limit : (e b : ℕ → Dhārā A) → Cauchy e → Cauchy b
      → (modulus : ℕ → ℕ)
      → ContinuousWith modulus Dt → ContinuousWith modulus curl
      → ContinuousWith modulus (λ v → neg (curl v))
      → ContinuousWith modulus divergence
      → ((n : ℕ) → Equations.Maxwell (e n , b n) × Equations.Constraints (e n , b n))
      → Equations.SchrodingerObject
    schrodinger-solution-at-limit e b ce cb m dc cc nc vc equations =
      equivFun Equations.maxwell-object≃schrodinger-object
        (full-solution-at-limit e b ce cb m dc cc nc vc equations)

-- Pullback of dF=0 and d(star F)=0. The two naturality equations are the
-- exact geometric input; the solution-object equivalence is derived here.
module GeometricTransport {ℓ : Level}
  (F F' G G' : Type ℓ) (setG : isSet G) (setG' : isSet G')
  (d : F → G) (d' : F' → G') (star : F → F) (star' : F' → F')
  (zeroG : G) (zeroG' : G')
  (pullF : F ≃ F') (pullG : G ≃ G')
  (d-natural : (x : F) → d' (equivFun pullF x) ≡ equivFun pullG (d x))
  (star-natural : (x : F) → star' (equivFun pullF x) ≡ equivFun pullF (star x))
  (zero-natural : equivFun pullG zeroG ≡ zeroG') where

  Maxwell : F → Type ℓ
  Maxwell x = (d x ≡ zeroG) × (d (star x) ≡ zeroG)
  Maxwell' : F' → Type ℓ
  Maxwell' x = (d' x ≡ zeroG') × (d' (star' x) ≡ zeroG')

  dstar-natural : (x : F) → d' (star' (equivFun pullF x)) ≡ equivFun pullG (d (star x))
  dstar-natural x = cong d' (star-natural x) ∙ d-natural (star x)

  pull-equations : (x : F) → Maxwell x → Maxwell' (equivFun pullF x)
  pull-equations x (p , q) =
    (d-natural x ∙ cong (equivFun pullG) p ∙ zero-natural) ,
    (dstar-natural x ∙ cong (equivFun pullG) q ∙ zero-natural)

  reflect-zero : {g : G} → equivFun pullG g ≡ zeroG' → g ≡ zeroG
  reflect-zero {g} p = sym (retEq pullG g)
    ∙ cong (invEq pullG) (p ∙ sym zero-natural) ∙ retEq pullG zeroG

  recover-equations : (x : F) → Maxwell' (equivFun pullF x) → Maxwell x
  recover-equations x (p , q) = reflect-zero (sym (d-natural x) ∙ p)
                             , reflect-zero (sym (dstar-natural x) ∙ q)

  equations-equiv : (x : F) → Maxwell x ≃ Maxwell' (equivFun pullF x)
  equations-equiv x = propBiimpl→Equiv
    (isProp× (setG _ _) (setG _ _)) (isProp× (setG' _ _) (setG' _ _))
    (pull-equations x) (recover-equations x)

  transformed-field-identity : Σ F Maxwell ≡ Σ F' Maxwell'
  transformed-field-identity = ua (Σ-cong-equiv pullF equations-equiv)

-- A cochain reads a chain. Its coboundary reads the boundary: Stokes is
-- evaluation itself. Re-presenting chains induces the operators below;
-- their naturality is a theorem, not an additional parameter.
-- Desbrun, Hirani, Leok, Marsden, Discrete Exterior Calculus (2005),
-- §5, Eq. (5.1), Remark 5.1; §12, Maxwell Equations.
-- https://arxiv.org/html/math/0508341#S5
-- The pairing definition d w c = w (boundary c) is exactly the discrete
-- Stokes mechanism. BoundarySquared transports boundary-of-boundary to d²;
-- the local construction works with the displayed abstract chain types.
module BoundaryGeometry {ℓ : Level}
  (C₀ C₁ C₀' C₁' R : Type ℓ) (setR : isSet R) (0R : R)
  (boundary : C₁ → C₀) (e₀ : C₀ ≃ C₀') (e₁ : C₁ ≃ C₁')
  (star : (C₀ → R) → (C₀ → R)) where

  cochainEquiv : {C C' : Type ℓ} → C ≃ C' → (C → R) ≃ (C' → R)
  cochainEquiv e = isoToEquiv (iso
    (λ w c' → w (invEq e c'))
    (λ w' c → w' (equivFun e c))
    (λ w' → funExt (λ c' → cong w' (secEq e c')))
    (λ w → funExt (λ c → cong w (retEq e c))))

  pull₀ = cochainEquiv e₀
  pull₁ = cochainEquiv e₁

  boundary' : C₁' → C₀'
  boundary' c' = equivFun e₀ (boundary (invEq e₁ c'))

  boundary-natural : (c : C₁) → boundary' (equivFun e₁ c) ≡ equivFun e₀ (boundary c)
  boundary-natural c = cong (λ x → equivFun e₀ (boundary x)) (retEq e₁ c)

  d : (C₀ → R) → (C₁ → R)
  d w c = w (boundary c)
  d' : (C₀' → R) → (C₁' → R)
  d' w c = w (boundary' c)

  stokes : (w : C₀ → R) (c : C₁) → d w c ≡ w (boundary c)
  stokes w c = refl

  d-natural : (w : C₀ → R) → d' (equivFun pull₀ w) ≡ equivFun pull₁ (d w)
  d-natural w = funExt (λ c' → cong w (retEq e₀ (boundary (invEq e₁ c'))))

  star' : (C₀' → R) → (C₀' → R)
  star' w' = equivFun pull₀ (star (invEq pull₀ w'))

  star-natural : (w : C₀ → R) → star' (equivFun pull₀ w) ≡ equivFun pull₀ (star w)
  star-natural w = cong (λ u → equivFun pull₀ (star u)) (retEq pull₀ w)

  -- All three naturality arguments of GeometricTransport are now filled.
  module MaxwellGeometry = GeometricTransport
    (C₀ → R) (C₀' → R) (C₁ → R) (C₁' → R)
    (isSetΠ (λ _ → setR)) (isSetΠ (λ _ → setR))
    d d' star star' (λ _ → 0R) (λ _ → 0R)
    pull₀ pull₁ d-natural star-natural refl

  geometric-Maxwell-identity = MaxwellGeometry.transformed-field-identity

  -- The complete continuing field, including its equation witnesses.
  geometric-Maxwell-orbit-identity :
    Orbit.Orbit (Σ (C₀ → R) MaxwellGeometry.Maxwell)
      ≡ Orbit.Orbit (Σ (C₀' → R) MaxwellGeometry.Maxwell')
  geometric-Maxwell-orbit-identity = cong Orbit.Orbit geometric-Maxwell-identity

-- Boundary of boundary gives coboundary of coboundary by evaluation.
-- This does not need a separately postulated differential on cochains.
module BoundarySquared {ℓ : Level}
  (C₀ C₁ C₂ R : Type ℓ) (0C : C₀) (0R : R)
  (∂₁ : C₁ → C₀) (∂₂ : C₂ → C₁)
  (∂² : (c : C₂) → ∂₁ (∂₂ c) ≡ 0C) where

  d₀ : (C₀ → R) → (C₁ → R)
  d₀ w c = w (∂₁ c)
  d₁ : (C₁ → R) → (C₂ → R)
  d₁ w c = w (∂₂ c)

  d-squared : (w : C₀ → R) → w 0C ≡ 0R → d₁ (d₀ w) ≡ (λ _ → 0R)
  d-squared w w-zero = funExt (λ c → cong w (∂² c) ∙ w-zero)

-- The boundary-defined differential acts on the completed cochain history.
-- This is an exact limit in the prefix topology used by CompleteExecution.
module BoundaryCompletion (C₀ C₁ R : Type) (boundary : C₁ → C₀) where
  d : (C₀ → R) → (C₁ → R)
  d w c = w (boundary c)

  completed-d : Dhārā (C₀ → R) → Dhārā (C₁ → R)
  completed-d = CompleteExecution.mapInto (C₀ → R) d

  d-limit : (r : ℕ → Dhārā (C₀ → R))
    → completed-d (Completion.Take.limit r)
      ≡ Completion.Take.limit (λ n → completed-d (r n))
  d-limit = CompleteExecution.map-limit (C₀ → R) d

  evaluate : {C : Type} → C → Dhārā (C → R) → Dhārā R
  evaluate {C} c = CompleteExecution.mapInto (C → R) (λ w → w c)

  stokes : (s : Dhārā (C₀ → R)) (c : C₁)
    → evaluate c (completed-d s) ≡ evaluate (boundary c) s
  Dhārā.śiras (stokes s c i) = Dhārā.śiras s (boundary c)
  Dhārā.śeṣam (stokes s c i) = stokes (Dhārā.śeṣam s) c i

  stokes-at-limit : (r : ℕ → Dhārā (C₀ → R)) (c : C₁)
    → evaluate c (Completion.Take.limit (λ n → completed-d (r n)))
      ≡ evaluate (boundary c) (Completion.Take.limit r)
  stokes-at-limit r c = cong (evaluate c) (sym (d-limit r))
    ∙ stokes (Completion.Take.limit r) c

-- A concrete differential algebra, rather than an assumed Leibniz law.
-- This is the Euler derivation on the square-zero first-order jet.
module JetDifferential where
  open import Cubical.Data.Nat
    using (_+_ ; _·_ ; +-zero ; +-comm ; 0≡m·0)
  open import Cubical.Data.Empty using (⊥)

  Jet = ℕ × ℕ
  add : Jet → Jet → Jet
  add (a , a') (b , b') = (a + b , a' + b')
  mul : Jet → Jet → Jet
  mul (a , a') (b , b') = (a · b , a · b' + a' · b)
  D : Jet → Jet
  D (a , a') = (zero , a')

  leibniz : (x y : Jet) → D (mul x y) ≡ add (mul (D x) y) (mul x (D y))
  leibniz (a , a') (b , b') = ΣPathP
    (0≡m·0 a ,
      +-comm (a · b') (a' · b)
      ∙ cong (a' · b +_) (sym (+-zero (a · b'))
        ∙ cong (a · b' +_) (0≡m·0 a')))

  nonzero : D (zero , suc zero) ≡ (zero , zero) → ⊥
  nonzero p = snotz (cong snd p)

  idempotent : (x : Jet) → D (D x) ≡ D x
  idempotent x = refl

-- Transport the field structure, its solution space, and evolution as one
-- dependent object. No operator or equation is re-selected at the target.
-- HoTT (2013), §2.3 (transport in dependent families), §2.7 (Sigma paths),
-- and §2.10 (universes); https://homotopytypetheory.org/book/
-- FieldDynamics is the dependent package to transport: operators, laws,
-- solution, and evolution. StructuredTransport's transport-law states
-- preservation for any property of this whole package.
record FieldStructure {ℓ : Level} (V : Type ℓ) : Type (ℓ-suc ℓ) where
  field
    setV : isSet V
    negation : V → V
    involution : (v : V) → negation (negation v) ≡ v
    timeDerivative spatialCurl : V → V
    transverse : V → Type ℓ
    transverseIsProp : (v : V) → isProp (transverse v)

module StructuredFields {ℓ : Level} (V : Type ℓ) (S : FieldStructure V) where
  open FieldStructure S
  open FieldEquations V setV negation involution timeDerivative spatialCurl
    transverse transverseIsProp public

-- A state, its governing witnesses, and its continuing dynamics are retained.
FieldDynamics : {ℓ : Level} → Type ℓ → Type (ℓ-suc ℓ)
FieldDynamics V = Σ (FieldStructure V) λ S →
  let X = StructuredFields.MaxwellObject V S in X × (X → X)

module StructuredTransport {ℓ : Level} (X Y : Type ℓ) (e : X ≃ Y) where
  presentation : X ≡ Y
  presentation = ua e

  transport-dynamics : FieldDynamics X → FieldDynamics Y
  transport-dynamics = subst FieldDynamics presentation

  dynamics-path : (D : FieldDynamics X)
    → PathP (λ i → FieldDynamics (presentation i)) D (transport-dynamics D)
  dynamics-path D = toPathP refl

  structure-path : (D : FieldDynamics X)
    → PathP (λ i → FieldStructure (presentation i))
        (fst D) (fst (transport-dynamics D))
  structure-path D i = fst (dynamics-path D i)

  maxwell-space-path : (D : FieldDynamics X)
    → StructuredFields.MaxwellObject X (fst D)
      ≡ StructuredFields.MaxwellObject Y (fst (transport-dynamics D))
  maxwell-space-path D i =
    StructuredFields.MaxwellObject (presentation i) (structure-path D i)

  schrodinger-space-path : (D : FieldDynamics X)
    → StructuredFields.SchrodingerObject X (fst D)
      ≡ StructuredFields.SchrodingerObject Y (fst (transport-dynamics D))
  schrodinger-space-path D i =
    StructuredFields.SchrodingerObject (presentation i) (structure-path D i)

  execution-path : (D : FieldDynamics X)
    → PathP (λ i → Orbit.Orbit (maxwell-space-path D i))
        (Orbit.unfold (snd (snd D)) (fst (snd D)))
        (Orbit.unfold (snd (snd (transport-dynamics D)))
                      (fst (snd (transport-dynamics D))))
  execution-path D i = Orbit.unfold (snd (snd (dynamics-path D i)))
                                     (fst (snd (dynamics-path D i)))

  -- Every dependent law of the entire structured evolution travels with it.
  transport-law : {ℓ' : Level}
    (P : (V : Type ℓ) → FieldDynamics V → Type ℓ')
    (D : FieldDynamics X) → P X D → P Y (transport-dynamics D)
  transport-law P D = transport (λ i → P (presentation i) (dynamics-path D i))

-- Here the presentation equivalence is constructed, not a missing parameter.
-- Its endpoints are the coherent finite-prefix tower and its complete stream.
module FiniteCompletionDynamics (A : Type) (setA : isSet A) where
  finite≃complete : Tower.MSDLimit A ≃ Dhārā A
  finite≃complete = compEquiv (Tower.MSDLimitEquiv setA)
    (invEquiv (CompleteExecution.stream≃sequence A))

  module Transport = StructuredTransport (Tower.MSDLimit A) (Dhārā A) finite≃complete

  completed-dynamics : FieldDynamics (Tower.MSDLimit A) → FieldDynamics (Dhārā A)
  completed-dynamics = subst FieldDynamics (ua finite≃complete)

  open Transport using (maxwell-space-path ; schrodinger-space-path ; execution-path ; transport-law) public

  finite-Maxwell≡completed-Schrodinger : (D : FieldDynamics (Tower.MSDLimit A))
    → StructuredFields.MaxwellObject (Tower.MSDLimit A) (fst D)
      ≡ StructuredFields.SchrodingerObject (Dhārā A) (fst (completed-dynamics D))
  finite-Maxwell≡completed-Schrodinger D = maxwell-space-path D ∙ StructuredFields.maxwell-object≡schrodinger-object (Dhārā A) (fst (completed-dynamics D))

-- The Fourier symbol of spatial curl: multiplication by i followed by
-- cross product with the wave vector. All identities are ring identities.
-- [RS] §3, Solution of Maxwell equations by Fourier transformation:
-- Dt F(k)=c k×F(k), k·F(k)=0. The convention exp(i k·x) gives
-- curl=i(k×); cross-square gives the transverse dispersion |k|².
module FourierSymbol {ℓ : Level} (R : CommRing ℓ) where
  open CommRingStr (snd R) using (0r)
    renaming (_+_ to _+r_ ; _·_ to _*r_ ; -_ to negR ; _-_ to _-r_)

  Vec = fst R × fst R × fst R
  zeroV : Vec
  zeroV = 0r , 0r , 0r
  negV : Vec → Vec
  negV (x , y , z) = negR x , negR y , negR z
  scale : fst R → Vec → Vec
  scale a (x , y , z) = a *r x , a *r y , a *r z
  sub : Vec → Vec → Vec
  sub (x , y , z) (u , v , w) = x -r u , y -r v , z -r w
  dot : Vec → Vec → fst R
  dot (x , y , z) (u , v , w) = (x *r u) +r ((y *r v) +r (z *r w))
  cross : Vec → Vec → Vec
  cross (x , y , z) (u , v , w) =
    (y *r w) -r (z *r v) , (z *r u) -r (x *r w) , (x *r v) -r (y *r u)

  pathV : {x y : Vec} → fst x ≡ fst y → fst (snd x) ≡ fst (snd y)
    → snd (snd x) ≡ snd (snd y) → x ≡ y
  pathV p q r = ΣPathP (p , ΣPathP (q , r))

  divergence-curl : (k v : Vec) → dot k (cross k v) ≡ 0r
  divergence-curl (x , y , z) (u , v , w) = solve! R

  cross-square : (k v : Vec)
    → cross k (cross k v) ≡ sub (scale (dot k v) k) (scale (dot k k) v)
  cross-square (x , y , z) (u , v , w) = pathV (solve! R) (solve! R) (solve! R)

  skew : (k v w : Vec) → dot (cross k v) w ≡ negR (dot v (cross k w))
  skew (a , b , c) (x , y , z) (u , v , w) = solve! R

  energy-rate-zero : (k v : Vec) → dot v (cross k v) ≡ 0r
  energy-rate-zero (x , y , z) (u , v , w) = solve! R

  cross-neg : (k v : Vec) → cross k (negV v) ≡ negV (cross k v)
  cross-neg (x , y , z) (u , v , w) = pathV (solve! R) (solve! R) (solve! R)

  -- Complex field amplitudes are interdependent real/imaginary triples.
  Field = Vec × Vec
  quarterField : Field → Field
  quarterField (a , b) = negV b , a
  curl : Vec → Field → Field
  curl k (a , b) = negV (cross k b) , cross k a
  generator : Vec → Field → Field
  generator k (a , b) = cross k a , cross k b

  schrodinger-factorization : (k : Vec) (f : Field) → quarterField (generator k f) ≡ curl k f
  schrodinger-factorization k f = refl

  duality-natural : (k : Vec) (f : Field) → generator k (quarterField f) ≡ quarterField (generator k f)
  duality-natural k (a , b) = ΣPathP (cross-neg k b , refl)

  mode-energy-rate-zero : (k : Vec) (f : Field)
    → (dot (fst f) (fst (generator k f)) +r dot (snd f) (snd (generator k f))) ≡ 0r
  mode-energy-rate-zero k (a , b) = cong₂ _+r_ (energy-rate-zero k a) (energy-rate-zero k b)
    ∙ zero-sum
    where
    zero-sum : 0r +r 0r ≡ 0r
    zero-sum = solve! R

{- Analytic realization of the Fourier symbol (mathematical derivation).
   The declarations above check the algebraic identities; this comment records
   the Hilbert-completion argument and its analytic hypotheses.

   References: [RS] §3 for mode evolution; Teschl, Mathematical Methods in
   Quantum Mechanics (2009), §§1.2–1.3 for orthogonal expansions/projections
   and §5.1 for unitary evolution and generator domains.
   https://www.mat.univie.ac.at/~gerald/ftp/book-schroe/schroe.pdf
   The torus construction below specifies its own coefficient-tail moduli.

   Use normalized measure on T^3 and complex vector coefficients a_k, k in Z^3.
   Let D_s consist of transverse coefficients k.a_k = 0 with finite weighted
   squared norm sum_k (1+|k|^2)^s |a_k|^2. Constructively, retain a modulus for
   convergence of the norm sum. Finite rational transverse sequences are dense.
   Fourier synthesis S(a) = sum_k a_k exp(i k.x) extends their isometry to
   D_s ~= H^s_div(T^3; C^3), with Fourier coefficients as inverse.

   Put K_k v = k cross v. The checked cross-square identity gives
   K_k^2 v = -|k|^2 v on k.v=0, and skew gives K_k^* = -K_k.
   Thus U_k(t)=exp(c t K_k) is unitary and preserves transversality. For k!=0,
   U_k(t)v = cos(c|k|t)v + sin(c|k|t) K_k v / |k|; U_0(t)=I.
   The exponential is constructively obtained from its factorially convergent
   series. Each finite set of modes has a uniform series-tail bound.

   Let P_N retain |k|<=N. Define (U(t)a)_k=U_k(t)a_k. Then, for every real t,
     ||U(t)a-U(t)P_N a||_s^2 = sum_{|k|>N} (1+|k|^2)^s |a_k|^2.
   This proves finite-mode convergence uniformly in t and supplies its modulus.
   For a in D_{s+1},
     ||c K U(t)(a-P_N a)||_s <= c ||a-P_N a||_{s+1}.
   Hence the finite-mode derivatives converge in H^s, and
     d_t S(U(t)a) = S(c K U(t)a),
     curl S(a) = S(i K a),   div S(a)=0.
   Consequently i d_t F = c curl F for F(t)=S(U(t)a).
   With F=E+i M, M=c B, its real and imaginary parts give
     d_t E=c curl M,   d_t M=-c curl E,   div E=div M=0.
   For a in D_{s+2}, d_t^2 F=c^2 Delta F follows from K_k^2=-|k|^2.
   For a in every D_s, all these identities hold for smooth fields.

   The exact observation P_N has residual (I-P_N)a. The orthogonal splitting
   a <-> (P_N a,(I-P_N)a) is its fibre presentation; the displayed tail norm
   measures the residual. The evolution preserves both summands and their norm.
   Fourier synthesis, its inverse, the differential domains, and U together
   form the structured identification to which StructuredTransport applies.
   Real-time queries in ISC use U(t); their composition is U(t+u)=U(t)U(u).
-}

-- Norm completion uses approximation names with explicit convergence moduli.
-- The natural number indexes requested accuracy, not exact prefix equality.
import Cubical.HITs.PropositionalTruncation as PT

-- Constructive-analysis reference: Russell O'Connor, A Monadic, Functional
-- Implementation of Real Numbers (2006), completion by regular functions
-- and lifting uniformly continuous maps.
-- https://arxiv.org/abs/cs/0605058
-- Here Name stores a sequence, modulus, and tail proof; Related identifies
-- names of one point. CauchyMap composes the two moduli explicitly.
-- CauchySquare retains a commuting equation when lifted names differ.
module CauchyNames (A : Type) (Ball : ℕ → A → A → Type) where
  open import Cubical.Data.Nat.Order using (_≤_)

  Tail : (ℕ → A) → (ℕ → ℕ) → Type
  Tail s m = (n i j : ℕ) → m n ≤ i → m n ≤ j → Ball n (s i) (s j)

  Name : Type
  Name = Σ (ℕ → A) λ s → Σ (ℕ → ℕ) (Tail s)

  sequence : Name → ℕ → A
  sequence = fst

  -- Names coincide when their mutual tails approach to every accuracy.
  CloseNames : Name → Name → Type
  CloseNames s t = (n : ℕ) → Σ ℕ λ N →
    (i j : ℕ) → N ≤ i → N ≤ j → Ball n (sequence s i) (sequence t j)

  Related : Name → Name → Type
  Related s t = PT.∥ CloseNames s t ∥₁

  Completion : Type
  Completion = Name / Related

  same-sequence : (s t : Name)
    → ((n : ℕ) → sequence s n ≡ sequence t n) → Related s t
  same-sequence s t p = PT.∣ (λ n → fst (snd s) n , λ i j hi hj →
    subst (Ball n (sequence s i)) (p j) (snd (snd s) n i j hi hj)) ∣₁

  same-point : (s t : Name)
    → ((n : ℕ) → sequence s n ≡ sequence t n) → Path Completion SQ.[ s ] SQ.[ t ]
  same-point s t p = SQ.eq/ s t (same-sequence s t p)

module CauchyMap (A B : Type)
  (BA : ℕ → A → A → Type) (BB : ℕ → B → B → Type)
  (f : A → B) (modulus : ℕ → ℕ)
  (uniform : (n : ℕ) (x y : A) → BA (modulus n) x y → BB n (f x) (f y)) where
  module Source = CauchyNames A BA
  module Target = CauchyNames B BB

  map-name : Source.Name → Target.Name
  map-name (s , m , tail) = (λ n → f (s n)) , (λ n → m (modulus n)) ,
    (λ n i j hi hj → uniform n (s i) (s j) (tail (modulus n) i j hi hj))

  map-related : (s t : Source.Name) → Source.Related s t
    → Target.Related (map-name s) (map-name t)
  map-related s t = PT.rec PT.squash₁ λ p → PT.∣ (λ n →
    fst (p (modulus n)) , λ i j hi hj →
      uniform n (Source.sequence s i) (Source.sequence t j)
        (snd (p (modulus n)) i j hi hj)) ∣₁

  extend : Source.Completion → Target.Completion
  extend = SQ.rec SQ.squash/ (λ s → SQ.[ map-name s ])
    (λ s t p → SQ.eq/ (map-name s) (map-name t) (map-related s t p))

module CauchyIsometry (A B : Type)
  (BA : ℕ → A → A → Type) (BB : ℕ → B → B → Type)
  (e : A ≃ B)
  (forward-ball : (n : ℕ) (x y : A) → BA n x y → BB n (equivFun e x) (equivFun e y))
  (backward-ball : (n : ℕ) (x y : B) → BB n x y → BA n (invEq e x) (invEq e y)) where
  module Forward = CauchyMap A B BA BB (equivFun e) (λ n → n) forward-ball
  module Backward = CauchyMap B A BB BA (invEq e) (λ n → n) backward-ball
  module Source = CauchyNames A BA
  module Target = CauchyNames B BB

  completion-retract : (x : Source.Completion) → Backward.extend (Forward.extend x) ≡ x
  completion-retract = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
    Source.same-point (Backward.map-name (Forward.map-name s)) s
      (λ n → retEq e (Source.sequence s n))

  completion-section : (y : Target.Completion) → Forward.extend (Backward.extend y) ≡ y
  completion-section = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
    Target.same-point (Forward.map-name (Backward.map-name s)) s
      (λ n → secEq e (Target.sequence s n))

  completion-equivalence : Source.Completion ≃ Target.Completion
  completion-equivalence = isoToEquiv (iso Forward.extend Backward.extend completion-section completion-retract)

  completion-path : Source.Completion ≡ Target.Completion
  completion-path = ua completion-equivalence

  completed-dynamics : FieldDynamics Source.Completion → FieldDynamics Target.Completion
  completed-dynamics = subst FieldDynamics completion-path

-- Commuting dense operators still commute after completion. The two moduli
-- may differ; equality is equality of represented points, not of their names.
module CauchySquare (A B C D : Type)
  (BA : ℕ → A → A → Type) (BB : ℕ → B → B → Type)
  (BC : ℕ → C → C → Type) (BD : ℕ → D → D → Type)
  (f : A → B) (g : A → C) (h : B → D) (k : C → D)
  (mf mg mh mk : ℕ → ℕ)
  (uf : (n : ℕ) (x y : A) → BA (mf n) x y → BB n (f x) (f y))
  (ug : (n : ℕ) (x y : A) → BA (mg n) x y → BC n (g x) (g y))
  (uh : (n : ℕ) (x y : B) → BB (mh n) x y → BD n (h x) (h y))
  (uk : (n : ℕ) (x y : C) → BC (mk n) x y → BD n (k x) (k y))
  (square : (a : A) → h (f a) ≡ k (g a)) where
  module F = CauchyMap A B BA BB f mf uf
  module G = CauchyMap A C BA BC g mg ug
  module H = CauchyMap B D BB BD h mh uh
  module K = CauchyMap C D BC BD k mk uk
  module Source = CauchyNames A BA
  module Target = CauchyNames D BD

  completed-square : (x : Source.Completion) → H.extend (F.extend x) ≡ K.extend (G.extend x)
  completed-square = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
    Target.same-point (H.map-name (F.map-name s)) (K.map-name (G.map-name s))
      (λ n → square (Source.sequence s n))

-- A regular Cauchy family of represented points has a constructive diagonal
-- limit. Ball n denotes accuracy 2^(-n); two balls of the next accuracy compose.
import Cubical.Data.Nat.Order as NatOrder

-- The diagonal has the role of flattening a completion of approximations
-- (compare O'Connor's completion monad, reference at CauchyNames). Its input
-- here supplies actual names and regularity witnesses; index bounds in the
-- proof account for both the inner and outer approximation errors.
module CauchyDiagonal (A : Type) (Ball : ℕ → A → A → Type)
  (weaken : {n m : ℕ} → n NatOrder.≤ m
    → {x y : A} → Ball m x y → Ball n x y)
  (triangle : (n : ℕ) {x y z : A}
    → Ball (suc n) x y → Ball (suc n) y z → Ball n x z) where
  open import Cubical.Data.Nat using (max)
  open import Cubical.Data.Nat.Order
    using (_≤_ ; ≤-refl ; ≤-trans ; ≤-sucℕ ; left-≤-max ; right-≤-max)
  open CauchyNames A Ball

  At : ℕ → Name → Name → Type
  At n s t = Σ ℕ λ N → (i j : ℕ) → N ≤ i → N ≤ j → Ball n (sequence s i) (sequence t j)

  Regular : (ℕ → Name) → Type
  Regular family = (n i j : ℕ) → n ≤ i → n ≤ j → At n (family i) (family j)

  three : (n : ℕ) {x y z w : A}
    → Ball (suc (suc n)) x y → Ball (suc (suc n)) y z
    → Ball (suc (suc n)) z w → Ball n x w
  three n p q r = triangle n (triangle (suc n) p q) (weaken ≤-sucℕ r)

  diagonal : (ℕ → Name) → ℕ → A
  diagonal family i = sequence (family i) (fst (snd (family i)) i)

  diagonal-tail : (family : ℕ → Name) → Regular family
    → Tail (diagonal family) (λ n → suc (suc n))
  diagonal-tail family regular n i j hi hj =
    three n
      (weaken hi (snd (snd (family i)) i mi p ≤-refl left-≤-max))
      (snd related p q right-≤-max right-≤-max)
      (weaken hj (snd (snd (family j)) j q mj left-≤-max ≤-refl))
    where
    mi = fst (snd (family i)) i
    mj = fst (snd (family j)) j
    related = regular (suc (suc n)) i j hi hj
    p = max mi (fst related)
    q = max mj (fst related)

  limit-name : (family : ℕ → Name) → Regular family → Name
  limit-name family regular = diagonal family , (λ n → suc (suc n)) , diagonal-tail family regular

  limit-point : (family : ℕ → Name) → Regular family → Completion
  limit-point family regular = SQ.[ limit-name family regular ]

  converges : (family : ℕ → Name) (regular : Regular family)
    → (n i : ℕ) → suc (suc n) ≤ i → At n (family i) (limit-name family regular)
  converges family regular n i hi = max mi (suc (suc n)) , estimate
    where
    level = suc (suc n)
    mi = fst (snd (family i)) level
    estimate : (p q : ℕ) → max mi level ≤ p → max mi level ≤ q
      → Ball n (sequence (family i) p) (diagonal family q)
    estimate p q hp hq = three n
      (snd (snd (family i)) level p r (≤-trans left-≤-max hp) left-≤-max)
      (snd related r s right-≤-max right-≤-max)
      (weaken q-bound (snd (snd (family q)) q s mq left-≤-max ≤-refl))
      where
      q-bound = ≤-trans right-≤-max hq
      related = regular level i q hi q-bound
      mq = fst (snd (family q)) q
      r = max mi (fst related)
      s = max mq (fst related)

-- The norm topology is inhabited concretely by finite rational vectors.
-- Complex Fourier coefficients are six real coordinates per wave vector.
module NormRingAlgebra {ℓ : Level} (R : CommRing ℓ) where
  open CommRingStr (snd R) renaming (-_ to negR)
  square : fst R → fst R
  square x = x · x
  twice : fst R → fst R
  twice x = x + x
  neg-square : (a : fst R) → square (negR a) ≡ square a
  neg-square a = solve! R
  zero-square : square 0r ≡ 0r
  zero-square = solve! R
  expansion : (x y z : fst R) → square (x - y) + square ((x - z) - (z - y))
    ≡ twice (square (x - z) + square (z - y))
  expansion x y z = solve! R
  empty-step : 0r ≡ square (0r - 0r) + 0r
  empty-step = solve! R
  rearrange : (a b c d : fst R) → twice (a + b) + twice (c + d) ≡ twice ((a + c) + (b + d))
  rearrange a b c d = solve! R
  zero-twice : twice (0r + 0r) ≡ 0r
  zero-twice = solve! R
  factor : (a b : fst R) → twice (twice (a · b)) ≡ twice (twice a) · b
  factor a b = solve! R

  difference-symmetric : (a b : fst R) → square (a - b) ≡ square (b - a)
  difference-symmetric a b = solve! R
  self-distance : (a t : fst R) → square (a - a) + t ≡ t
  self-distance a t = solve! R

-- Teschl (2009), §§1.1–1.2: square-summable coordinates and orthonormal
-- expansions. Here finite rational lists give the dense coordinate data;
-- zero padding identifies presentations of the same finite vector.
-- Rational bounds on squared distance supply the completion's accuracy scale.
module RationalHilbert where
  import Cubical.Data.Rationals as Q
  import Cubical.Data.Rationals.Order as O
  open import Cubical.Data.NatPlusOne using (1+_)
  open import Cubical.Algebra.CommRing using (makeCommRing)
  open import Cubical.Data.Nat.Literals
  open Q using (ℚ ; fromNatℚ)
    renaming (_+_ to _+q_ ; _·_ to _*q_ ; _-_ to _-q_ ; -_ to negQ)

  ring : CommRing ℓ-zero
  ring = makeCommRing {R = ℚ} 0 1 _+q_ _*q_ negQ Q.isSetℚ
    Q.+Assoc Q.+IdR Q.+InvR Q.+Comm Q.·Assoc Q.·IdR Q.·DistL+ Q.·Comm

  square : ℚ → ℚ
  square x = x *q x
  twice : ℚ → ℚ
  twice x = x +q x

  positive-square : (x : ℚ) → 0 O.≤ square x
  positive-square x with x O.≟ 0
  ... | O.lt h = subst (0 O.≤_) (identity x) (positive-product (negQ x) positive-neg)
    where
    positive-neg : 0 O.≤ negQ x
    positive-neg = O.<Weaken≤ 0 (negQ x)
      (subst2 O._<_ (Q.+InvR x) (Q.+IdL (negQ x)) (O.<-+o x 0 (negQ x) h))
    positive-product : (a : ℚ) → 0 O.≤ a → 0 O.≤ square a
    positive-product a p = subst (O._≤ square a) (Q.·AnnihilL a) (O.≤-·o 0 a a p p)
    identity : (a : ℚ) → square (negQ a) ≡ square a
    identity a = NormRingAlgebra.neg-square ring a
  ... | O.eq p = subst (0 O.≤_) (sym (cong square p ∙ zero-square)) (O.isRefl≤ 0)
    where
    zero-square : square 0 ≡ 0
    zero-square = NormRingAlgebra.zero-square ring
  ... | O.gt h = subst (O._≤ square x) (Q.·AnnihilL x)
    (O.≤-·o 0 x x (O.<Weaken≤ 0 x h) (O.<Weaken≤ 0 x h))

  add-positive : {x y : ℚ} → 0 O.≤ x → 0 O.≤ y → 0 O.≤ (x +q y)
  add-positive {x} {y} p q = subst (O._≤ (x +q y)) (Q.+IdR 0)
    (O.≤Monotone+ 0 x 0 y p q)

  scalar-triangle : (x y z : ℚ)
    → square (x -q y) O.≤ twice (square (x -q z) +q square (z -q y))
  scalar-triangle x y z = subst2 O._≤_ (Q.+IdR (square (x -q y))) expansion
    (O.≤-o+ 0 (square ((x -q z) -q (z -q y))) (square (x -q y))
      (positive-square ((x -q z) -q (z -q y))))
    where
    expansion : square (x -q y) +q square ((x -q z) -q (z -q y))
      ≡ twice (square (x -q z) +q square (z -q y))
    expansion = NormRingAlgebra.expansion ring x y z

  head0 : List ℚ → ℚ
  head0 [] = 0
  head0 (x ∷ xs) = x
  tail0 : List ℚ → List ℚ
  tail0 [] = []
  tail0 (x ∷ xs) = xs

  distance² : List ℚ → List ℚ → ℚ
  distance² [] [] = 0
  distance² [] (y ∷ ys) = square (0 -q y) +q distance² [] ys
  distance² (x ∷ xs) [] = square (x -q 0) +q distance² xs []
  distance² (x ∷ xs) (y ∷ ys) = square (x -q y) +q distance² xs ys

  distance-step : (x y : List ℚ) → distance² x y
    ≡ square (head0 x -q head0 y) +q distance² (tail0 x) (tail0 y)
  distance-step [] [] = NormRingAlgebra.empty-step ring
  distance-step [] (y ∷ ys) = refl
  distance-step (x ∷ xs) [] = refl
  distance-step (x ∷ xs) (y ∷ ys) = refl

  triangle-step : (x y z : List ℚ)
    → distance² (tail0 x) (tail0 y)
      O.≤ twice (distance² (tail0 x) (tail0 z) +q distance² (tail0 z) (tail0 y))
    → distance² x y O.≤ twice (distance² x z +q distance² z y)
  triangle-step x y z p = subst2 O._≤_ (sym (distance-step x y)) target
    (O.≤Monotone+
      (square (head0 x -q head0 y))
      (twice (square (head0 x -q head0 z) +q square (head0 z -q head0 y)))
      (distance² (tail0 x) (tail0 y))
      (twice (distance² (tail0 x) (tail0 z) +q distance² (tail0 z) (tail0 y)))
      (scalar-triangle (head0 x) (head0 y) (head0 z)) p)
    where
    rearrange : (a b c d : ℚ) → twice (a +q b) +q twice (c +q d) ≡ twice ((a +q c) +q (b +q d))
    rearrange a b c d = NormRingAlgebra.rearrange ring a b c d
    target = rearrange (square (head0 x -q head0 z)) (square (head0 z -q head0 y))
      (distance² (tail0 x) (tail0 z)) (distance² (tail0 z) (tail0 y))
      ∙ cong twice (cong₂ _+q_ (sym (distance-step x z)) (sym (distance-step z y)))

  distance-triangle : (x y z : List ℚ) → distance² x y O.≤ twice (distance² x z +q distance² z y)
  distance-triangle [] [] [] = subst (0 O.≤_) (sym zero-twice) (O.isRefl≤ 0)
    where
    zero-twice : twice (0 +q 0) ≡ 0
    zero-twice = NormRingAlgebra.zero-twice ring
  distance-triangle [] [] (z ∷ zs) = triangle-step [] [] (z ∷ zs) (distance-triangle [] [] zs)
  distance-triangle [] (y ∷ ys) [] = triangle-step [] (y ∷ ys) [] (distance-triangle [] ys [])
  distance-triangle [] (y ∷ ys) (z ∷ zs) = triangle-step [] (y ∷ ys) (z ∷ zs) (distance-triangle [] ys zs)
  distance-triangle (x ∷ xs) [] [] = triangle-step (x ∷ xs) [] [] (distance-triangle xs [] [])
  distance-triangle (x ∷ xs) [] (z ∷ zs) = triangle-step (x ∷ xs) [] (z ∷ zs) (distance-triangle xs [] zs)
  distance-triangle (x ∷ xs) (y ∷ ys) [] = triangle-step (x ∷ xs) (y ∷ ys) [] (distance-triangle xs ys [])
  distance-triangle (x ∷ xs) (y ∷ ys) (z ∷ zs) = triangle-step (x ∷ xs) (y ∷ ys) (z ∷ zs) (distance-triangle xs ys zs)

  quarterQ : ℚ
  quarterQ = Q.[ pos 1 / 1+ 3 ]
  quarter-positive : 0 O.≤ quarterQ
  quarter-positive = 1 , refl
  quarter-bounded : quarterQ O.≤ 1
  quarter-bounded = 3 , refl
  four-quarters : twice (twice quarterQ) ≡ 1
  four-quarters = Q.eq/ _ _ refl

  epsilon : ℕ → ℚ
  epsilon zero = 1
  epsilon (suc n) = quarterQ *q epsilon n

  epsilon-positive : (n : ℕ) → 0 O.≤ epsilon n
  epsilon-positive zero = 1 , refl
  epsilon-positive (suc n) = subst (O._≤ epsilon (suc n)) (Q.·AnnihilL (epsilon n))
    (O.≤-·o 0 quarterQ (epsilon n) (epsilon-positive n) quarter-positive)

  epsilon-step : (n : ℕ) → epsilon (suc n) O.≤ epsilon n
  epsilon-step n = subst (epsilon (suc n) O.≤_) (Q.·IdL (epsilon n))
    (O.≤-·o quarterQ 1 (epsilon n) (epsilon-positive n) quarter-bounded)

  epsilon-four : (n : ℕ) → twice (twice (epsilon (suc n))) ≡ epsilon n
  epsilon-four n = factor quarterQ (epsilon n)
    ∙ cong (_*q epsilon n) four-quarters ∙ Q.·IdL (epsilon n)
    where
    factor : (a b : ℚ) → twice (twice (a *q b)) ≡ twice (twice a) *q b
    factor a b = NormRingAlgebra.factor ring a b

  epsilon-add : (k n : ℕ) → epsilon (Cubical.Data.Nat._+_ k n) O.≤ epsilon n
  epsilon-add zero n = O.isRefl≤ (epsilon n)
  epsilon-add (suc k) n = O.isTrans≤
    (epsilon (suc (Cubical.Data.Nat._+_ k n))) (epsilon (Cubical.Data.Nat._+_ k n)) (epsilon n)
    (epsilon-step (Cubical.Data.Nat._+_ k n)) (epsilon-add k n)

  epsilon-monotone : {n m : ℕ} → n NatOrder.≤ m → epsilon m O.≤ epsilon n
  epsilon-monotone {n} (k , p) = subst (λ m → epsilon m O.≤ epsilon n) p (epsilon-add k n)

  Ball : ℕ → List ℚ → List ℚ → Type
  Ball n x y = distance² x y O.≤ epsilon n

  weaken : {n m : ℕ} → n NatOrder.≤ m → {x y : List ℚ} → Ball m x y → Ball n x y
  weaken {n} {m} h {x} {y} p = O.isTrans≤ (distance² x y) (epsilon m) (epsilon n) p (epsilon-monotone h)

  triangle : (n : ℕ) {x y z : List ℚ} → Ball (suc n) x y → Ball (suc n) y z → Ball n x z
  triangle n {x} {y} {z} p q = O.isTrans≤ (distance² x z) (twice (distance² x y +q distance² y z)) (epsilon n) (distance-triangle x z y)
    (subst (twice (distance² x y +q distance² y z) O.≤_) (epsilon-four n)
      (O.≤Monotone+ (distance² x y +q distance² y z) (twice (epsilon (suc n)))
        (distance² x y +q distance² y z) (twice (epsilon (suc n))) sum-bound sum-bound))
    where
    sum-bound = O.≤Monotone+ (distance² x y) (epsilon (suc n)) (distance² y z) (epsilon (suc n)) p q

  module Names = CauchyNames (List ℚ) Ball
  module Limits = CauchyDiagonal (List ℚ) Ball weaken triangle

  Hilbert : Type
  Hilbert = Names.Completion

module PhaseDistanceAlgebra {ℓ : Level} (R : CommRing ℓ) where
  open CommRingStr (snd R) renaming (-_ to negR)
  sq : fst R → fst R
  sq a = a · a
  rotated : (a b c d t : fst R)
    → sq (negR b - negR d) + (sq (a - c) + t) ≡ sq (a - c) + (sq (b - d) + t)
  rotated a b c d t = solve! R
  left-zero : (a b t : fst R)
    → sq (negR b - 0r) + (sq (a - 0r) + t) ≡ sq (a - 0r) + (sq (b - 0r) + t)
  left-zero a b t = solve! R
  right-zero : (c d t : fst R)
    → sq (0r - negR d) + (sq (0r - c) + t) ≡ sq (0r - c) + (sq (0r - d) + t)
  right-zero c d t = solve! R

module CompletedAmplitude where
  open RationalHilbert using (ring)
  import Cubical.Data.Rationals as Q
  import Cubical.Data.Rationals.Order as O
  open import Cubical.Data.Nat.Literals
  open Q using (ℚ ; fromNatℚ)
  module M = ModeAlgebra ring
  module H = RationalHilbert
  module P = PhaseDistanceAlgebra ring

  Finite : Type
  Finite = List (ℚ × ℚ)

  flatten : Finite → List ℚ
  flatten [] = []
  flatten ((a , b) ∷ xs) = a ∷ b ∷ flatten xs

  rotate : Finite → Finite
  rotate [] = []
  rotate (z ∷ xs) = M.turn z ∷ rotate xs

  rotate-four : (xs : Finite) → rotate (rotate (rotate (rotate xs))) ≡ xs
  rotate-four [] = refl
  rotate-four (z ∷ xs) = cong₂ _∷_ (M.turn-four z) (rotate-four xs)

  finite-phase-equivalence : Finite ≃ Finite
  finite-phase-equivalence = isoToEquiv (iso rotate
    (λ xs → rotate (rotate (rotate xs))) rotate-four rotate-four)

  distance-preserved : (xs ys : Finite)
    → H.distance² (flatten (rotate xs)) (flatten (rotate ys)) ≡ H.distance² (flatten xs) (flatten ys)
  distance-preserved [] [] = refl
  distance-preserved ((a , b) ∷ xs) [] =
    cong (λ t → H.square ((Q.- b) Q.- 0) Q.+ (H.square (a Q.- 0) Q.+ t)) (distance-preserved xs [])
    ∙ P.left-zero a b (H.distance² (flatten xs) [])
  distance-preserved [] ((c , d) ∷ ys) =
    cong (λ t → H.square (0 Q.- (Q.- d)) Q.+ (H.square (0 Q.- c) Q.+ t)) (distance-preserved [] ys)
    ∙ P.right-zero c d (H.distance² [] (flatten ys))
  distance-preserved ((a , b) ∷ xs) ((c , d) ∷ ys) =
    cong (λ t → H.square ((Q.- b) Q.- (Q.- d)) Q.+ (H.square (a Q.- c) Q.+ t)) (distance-preserved xs ys)
    ∙ P.rotated a b c d (H.distance² (flatten xs) (flatten ys))

  Ball : ℕ → Finite → Finite → Type
  Ball n x y = H.Ball n (flatten x) (flatten y)

  phase-uniform : (n : ℕ) (x y : Finite) → Ball n x y → Ball n (rotate x) (rotate y)
  phase-uniform n x y = subst (λ d → d O.≤ H.epsilon n) (sym (distance-preserved x y))

  inverse-uniform : (n : ℕ) (x y : Finite) → Ball n x y
    → Ball n (rotate (rotate (rotate x))) (rotate (rotate (rotate y)))
  inverse-uniform n x y p = phase-uniform n (rotate (rotate x)) (rotate (rotate y))
    (phase-uniform n (rotate x) (rotate y) (phase-uniform n x y p))

  module FieldNames = CauchyNames Finite Ball
  module Limits = CauchyDiagonal Finite Ball
    (λ h {x} {y} → H.weaken h {flatten x} {flatten y})
    (λ n {x} {y} {z} → H.triangle n {flatten x} {flatten y} {flatten z})
  module PhaseLift = CauchyIsometry Finite Finite Ball Ball finite-phase-equivalence phase-uniform inverse-uniform

  Field : Type
  Field = FieldNames.Completion

  completed-quarter-equivalence : Field ≃ Field
  completed-quarter-equivalence = PhaseLift.completion-equivalence

  completed-quarter-loop : Field ≡ Field
  completed-quarter-loop = ua completed-quarter-equivalence

  quarter-step : Field → Field
  quarter-step = equivFun completed-quarter-equivalence

  quarter-four : (f : Field) → quarter-step (quarter-step (quarter-step (quarter-step f))) ≡ f
  quarter-four = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
    FieldNames.same-point
      (PhaseLift.Forward.map-name (PhaseLift.Forward.map-name (PhaseLift.Forward.map-name (PhaseLift.Forward.map-name s)))) s
      (λ n → rotate-four (FieldNames.sequence s n))

  execution : Field → Orbit.Orbit Field
  execution = Orbit.unfold quarter-step

  module Observation (B : Type) (q : Field → B) where
    field-and-residual : Field ≃ Σ B (fiber q)
    field-and-residual = Fibre.lossless q

    carried-execution : (f : Field)
      → Orbit.mapO (Carrier.carry-transport q) (execution f)
        ≡ Orbit.unfold (Carrier.Φ-carrier q quarter-step) (Carrier.descend q f)
    carried-execution = Nucleus.transport-orbit q quarter-step

-- An operator's graph norm controls both its input and output. This builds
-- its completed domain and the induced operator from finite data.
-- Teschl (2009), §2.2, pp. 63–64: closure of the graph and graph norm
-- ||x||²+||Ax||². https://www.mat.univie.ac.at/~gerald/ftp/book-schroe/schroe.pdf
-- GraphBall controls both coordinates, giving continuous input/output maps
-- on its completion. Identifying this with a subspace of the ambient field
-- uses closability: the input coordinate must determine the output.
module GraphNormOperator (A : Type) (Ball : ℕ → A → A → Type)
  (generator phase : A → A)
  (phase-uniform : (n : ℕ) (x y : A) → Ball n x y → Ball n (phase x) (phase y)) where

  GraphBall : ℕ → A → A → Type
  GraphBall n x y = Ball n x y × Ball n (generator x) (generator y)

  module Domain = CauchyNames A GraphBall
  module Fields = CauchyNames A Ball
  module Include = CauchyMap A A GraphBall Ball (λ x → x) (λ n → n) (λ n x y p → fst p)
  module Generate = CauchyMap A A GraphBall Ball generator (λ n → n) (λ n x y p → snd p)
  module PhaseMap = CauchyMap A A Ball Ball phase (λ n → n) phase-uniform
  module Curl = CauchyMap A A GraphBall Ball (λ x → phase (generator x)) (λ n → n)
    (λ n x y p → phase-uniform n (generator x) (generator y) (snd p))

  completed-generator : Domain.Completion → Fields.Completion
  completed-generator = Generate.extend

  completed-curl : Domain.Completion → Fields.Completion
  completed-curl = Curl.extend

  schrodinger-factorization : (x : Domain.Completion)
    → PhaseMap.extend (completed-generator x) ≡ completed-curl x
  schrodinger-factorization = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
    Fields.same-point (PhaseMap.map-name (Generate.map-name s)) (Curl.map-name s) (λ n → refl)

  module Limits
    (weaken : {n m : ℕ} → n NatOrder.≤ m → {x y : A} → Ball m x y → Ball n x y)
    (triangle : (n : ℕ) {x y z : A} → Ball (suc n) x y → Ball (suc n) y z → Ball n x z) where
    graph-weaken : {n m : ℕ} → n NatOrder.≤ m → {x y : A} → GraphBall m x y → GraphBall n x y
    graph-weaken h (p , q) = weaken h p , weaken h q
    graph-triangle : (n : ℕ) {x y z : A} → GraphBall (suc n) x y → GraphBall (suc n) y z → GraphBall n x z
    graph-triangle n (p , q) (r , s) = triangle n p r , triangle n q s
    module CompleteDomain = CauchyDiagonal A GraphBall graph-weaken graph-triangle

-- The dense spatial generator is now the actual Fourier cross product,
-- indexed by integer wave vectors; curl is its complex quarter turn.
-- [RS] §§2, 11.1–11.2 distinguish the field-energy pairing from one-photon
-- normalization (whose momentum measure carries a 1/|k| factor).
-- The coefficient distance here uses the unweighted field coordinates.
module CompletedFourierOperator (wave : ℕ → ℤ × ℤ × ℤ) where
  import Cubical.Data.Rationals as Q
  open import Cubical.Data.NatPlusOne using (1+_)
  module H = RationalHilbert
  module A = CompletedAmplitude
  module F = FourierSymbol H.ring

  FiniteField : Type
  FiniteField = List F.Field

  waveQ : ℕ → F.Vec
  waveQ n = Q.[ fst (wave n) / 1+ 0 ] ,
    Q.[ fst (snd (wave n)) / 1+ 0 ] , Q.[ snd (snd (wave n)) / 1+ 0 ]

  encode : FiniteField → A.Finite
  encode [] = []
  encode (((a , b , c) , (d , e , f)) ∷ xs) = (a , d) ∷ (b , e) ∷ (c , f) ∷ encode xs

  phase : FiniteField → FiniteField
  phase [] = []
  phase (x ∷ xs) = F.quarterField x ∷ phase xs

  encode-phase : (xs : FiniteField) → encode (phase xs) ≡ A.rotate (encode xs)
  encode-phase [] = refl
  encode-phase (((a , b , c) , (d , e , f)) ∷ xs) =
    cong (λ ys → ((Q.- d) , a) ∷ ((Q.- e) , b) ∷ ((Q.- f) , c) ∷ ys) (encode-phase xs)

  generate-from : ℕ → FiniteField → FiniteField
  generate-from n [] = []
  generate-from n (x ∷ xs) = F.generator (waveQ n) x ∷ generate-from (suc n) xs

  curl-from : ℕ → FiniteField → FiniteField
  curl-from n [] = []
  curl-from n (x ∷ xs) = F.curl (waveQ n) x ∷ curl-from (suc n) xs

  curl-is-phase-generator : (n : ℕ) (xs : FiniteField)
    → phase (generate-from n xs) ≡ curl-from n xs
  curl-is-phase-generator n [] = refl
  curl-is-phase-generator n (x ∷ xs) =
    cong₂ _∷_ (F.schrodinger-factorization (waveQ n) x) (curl-is-phase-generator (suc n) xs)

  Ball : ℕ → FiniteField → FiniteField → Type
  Ball n x y = A.Ball n (encode x) (encode y)

  phase-uniform : (n : ℕ) (x y : FiniteField) → Ball n x y → Ball n (phase x) (phase y)
  phase-uniform n x y p = subst2 (A.Ball n) (sym (encode-phase x)) (sym (encode-phase y))
    (A.phase-uniform n (encode x) (encode y) p)

  module Operator = GraphNormOperator FiniteField Ball (generate-from zero) phase phase-uniform
  module DomainLimits = Operator.Limits
    (λ h {x} {y} → H.weaken h {A.flatten (encode x)} {A.flatten (encode y)})
    (λ n {x} {y} {z} → H.triangle n {A.flatten (encode x)} {A.flatten (encode y)} {A.flatten (encode z)})

  module ActualCurl = CauchyMap FiniteField FiniteField Operator.GraphBall Ball (curl-from zero) (λ n → n)
    (λ n x y p → subst2 (Ball n) (curl-is-phase-generator zero x) (curl-is-phase-generator zero y)
      (phase-uniform n (generate-from zero x) (generate-from zero y) (snd p)))

  completed-Fourier-Schrodinger : (x : Operator.Domain.Completion)
    → Operator.PhaseMap.extend (Operator.completed-generator x) ≡ ActualCurl.extend x
  completed-Fourier-Schrodinger = SQ.elimProp (λ _ → SQ.squash/ _ _) λ s →
    Operator.Fields.same-point
      (Operator.PhaseMap.map-name (Operator.Generate.map-name s)) (ActualCurl.map-name s)
      (λ n → curl-is-phase-generator zero (Operator.Domain.sequence s n))

-- HoTT (2013), §6.10: set quotients and effectiveness of equivalence
-- relations. https://homotopytypetheory.org/book/
-- Once Related has the required laws, quotient equality recovers closeness.
-- RationalHilbertEquality uses this to separate the embedded zero and unit
-- by a rational accuracy bound: completion retains a detectable distinction.
module CauchyEquality (A : Type) (Ball : ℕ → A → A → Type)
  (ball-sym : (n : ℕ) (x y : A) → Ball n x y → Ball n y x)
  (triangle : (n : ℕ) {x y z : A} → Ball (suc n) x y → Ball (suc n) y z → Ball n x z) where
  open import Cubical.Data.Nat using (max)
  open import Cubical.Data.Nat.Order using (≤-refl ; ≤-trans ; left-≤-max ; right-≤-max)
  open import Cubical.Relation.Binary using (module BinaryRelation)
  open CauchyNames A Ball

  close-reflexive : (s : Name) → Related s s
  close-reflexive s = same-sequence s s (λ n → refl)

  close-symmetric : (s t : Name) → Related s t → Related t s
  close-symmetric s t = PT.rec PT.squash₁ λ p → PT.∣ (λ n →
    fst (p n) , λ i j hi hj → ball-sym n (sequence s j) (sequence t i) (snd (p n) j i hj hi)) ∣₁

  close-transitive : (s t u : Name) → Related s t → Related t u → Related s u
  close-transitive s t u = PT.rec2 PT.squash₁ λ p q → PT.∣ (λ n →
    let N = max (fst (p (suc n))) (fst (q (suc n))) in
    N , λ i j hi hj → triangle n
      (snd (p (suc n)) i N (≤-trans left-≤-max hi) left-≤-max)
      (snd (q (suc n)) N j right-≤-max (≤-trans right-≤-max hj))) ∣₁

  equivalence-relation : BinaryRelation.isEquivRel Related
  BinaryRelation.isEquivRel.reflexive equivalence-relation = close-reflexive
  BinaryRelation.isEquivRel.symmetric equivalence-relation = close-symmetric
  BinaryRelation.isEquivRel.transitive equivalence-relation = close-transitive

  equality-implies-close : (s t : Name) → Path Completion SQ.[ s ] SQ.[ t ] → Related s t
  equality-implies-close = SQ.effective (λ _ _ → PT.squash₁) equivalence-relation

module RationalHilbertEquality where
  import Cubical.Data.Rationals as Q
  import Cubical.Data.Rationals.Order as O
  open import Cubical.Data.Nat.Literals
  open Q using (ℚ ; fromNatℚ)
  open import Cubical.Data.Empty using (⊥)
  module H = RationalHilbert
  module N = H.Names
  module Algebra = NormRingAlgebra H.ring

  distance-symmetric : (x y : List ℚ) → H.distance² x y ≡ H.distance² y x
  distance-symmetric [] [] = refl
  distance-symmetric [] (y ∷ ys) = cong₂ Q._+_ (Algebra.difference-symmetric 0 y) (distance-symmetric [] ys)
  distance-symmetric (x ∷ xs) [] = cong₂ Q._+_ (Algebra.difference-symmetric x 0) (distance-symmetric xs [])
  distance-symmetric (x ∷ xs) (y ∷ ys) = cong₂ Q._+_ (Algebra.difference-symmetric x y) (distance-symmetric xs ys)

  ball-symmetric : (n : ℕ) (x y : List ℚ) → H.Ball n x y → H.Ball n y x
  ball-symmetric n x y = subst (λ d → d O.≤ H.epsilon n) (distance-symmetric x y)

  module Equality = CauchyEquality (List ℚ) H.Ball ball-symmetric H.triangle

  distance-reflexive : (x : List ℚ) → H.distance² x x ≡ 0
  distance-reflexive [] = refl
  distance-reflexive (x ∷ xs) = Algebra.self-distance x (H.distance² xs xs) ∙ distance-reflexive xs

  self-ball : (n : ℕ) (x : List ℚ) → H.Ball n x x
  self-ball n x = subst (λ d → d O.≤ H.epsilon n) (sym (distance-reflexive x)) (H.epsilon-positive n)

  constant-name : List ℚ → N.Name
  constant-name x = (λ _ → x) , (λ _ → zero) , (λ n i j hi hj → self-ball n x)

  embed : List ℚ → H.Hilbert
  embed x = SQ.[ constant-name x ]

  constant-regular : (x : List ℚ) → H.Limits.Regular (λ _ → constant-name x)
  constant-regular x n i j hi hj = zero , λ p q hp hq → self-ball n x

  constant-limit : (x : List ℚ)
    → H.Limits.limit-point (λ _ → constant-name x) (constant-regular x) ≡ embed x
  constant-limit x = N.same-point
    (H.Limits.limit-name (λ _ → constant-name x) (constant-regular x)) (constant-name x) (λ n → refl)

  zero-distinct-unit : embed [] ≡ embed (1 ∷ []) → ⊥
  zero-distinct-unit p = PT.rec (λ ()) contradiction
    (Equality.equality-implies-close (constant-name []) (constant-name (1 ∷ [])) p)
    where
    distance-unit : H.distance² [] (1 ∷ []) ≡ 1
    distance-unit = Q.eq/ _ _ refl
    quarter-less-one : H.quarterQ O.< 1
    quarter-less-one = 2 , refl
    contradiction : N.CloseNames (constant-name []) (constant-name (1 ∷ [])) → ⊥
    contradiction close = O.isIrrefl< 1
      (O.isTrans≤< 1 H.quarterQ 1
        (subst2 O._≤_ distance-unit (Q.·IdR H.quarterQ)
          (snd (close 1) (fst (close 1)) (fst (close 1)) NatOrder.≤-refl NatOrder.≤-refl))
        quarter-less-one)
