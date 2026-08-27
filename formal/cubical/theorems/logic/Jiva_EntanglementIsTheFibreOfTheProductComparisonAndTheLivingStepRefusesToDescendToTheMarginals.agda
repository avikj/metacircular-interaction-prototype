{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- जीव — संश्लेषः तुलनातन्तुः, जीवनं च अवतरणस्य निषेधः ।
--
-- (entanglement is the fibre of the product comparison, and life is
--  the refusal of the descent.)
--
-- ONE MAP CARRIES THE WHOLE VOCABULARY.  A joint state of two parts is
-- a type J with two projections p : J → A and q : J → B, and everything
-- the words below name is an officer of the single comparison map
--
--     ⟨p,q⟩ : J → A × B.
--
-- §१ · INDEPENDENCE IS THE COMPARISON BEING AN EQUIVALENCE, exhibited
-- at the product pole: for J = A × B with the two projections, the
-- comparison is definitionally the identity (Σ-eta), so `idIsEquiv`
-- closes it with no path algebra.
--
-- §२ · ENTANGLEMENT IS THE FIBRE OF THE COMPARISON, and both failures
-- are POINTED AT rather than counted, in the discipline of abstract 18
-- (a blindness is a named identification, not a cardinality argument):
--   रिक्तम् — over the diagonal joint (J = Bool sitting in Bool × Bool
--   as j ↦ (j , j)) the fibre over (true , false) is EMPTY: a pair of
--   marginal readings the whole never realises.  The refutation is two
--   `cong`s and `true≢false`.
--   बहु — over the joint that outruns its marginals (J = Bool over
--   Unit × Unit) the fibre over the one reading holds TWO NAMED POINTS,
--   distinguished by `cong fst`: a hidden degree of freedom the two
--   marginals jointly cannot see.
--
-- §३ · CONDITIONAL CERTAINTY IS A RECONSTRUCTION, NOT A NUMBER.  On the
-- diagonal joint, either reading determines the other: the recovering
-- function is exhibited and the commuting square is `refl`.  This is
-- H(A|B) = 0 in its fibre form — what abstract 18 calls a
-- reconstruction — and on this joint it holds BOTH ways, so the joint
-- is the graph of a bijection: the pole where every bit of marginal
-- uncertainty is shared.  The two poles (§१ product, §३ graph) bracket
-- the same two-element alphabet.
--
-- §४ · A LIVING STEP IS ONE THAT REFUSES TO DESCEND TO THE MARGINALS.
-- Call a joint step `step : J → J` DECOHERENT along p when some
-- f : A → A satisfies f ∘ p ∼ p ∘ step, and LIVING when no such f
-- exists (so a fortiori no pair (f , g) simulates it).  Over the full
-- product joint the controlled-not step (a , b) ↦ (a ⊕ b , b) is
-- proved living: any candidate f is interrogated at the two named
-- configurations (true , false) and (true , true), where p agrees and
-- p ∘ step disagrees, and the collision is `true≢false`.  Beside it,
-- (a , b) ↦ (not a , b) is proved decoherent by `refl`.  The statics
-- of this joint are a product (§१); the dynamics entangle.  What the
-- marginal simulator cannot carry is exactly the fibre of p — the
-- environment's half — consulted by the step.
--
-- RELATION TO THE CORPUS, checked before writing.  `Tantutrayam_…` puts
-- the three fibre verdicts over ONE codomain with three maps; here the
-- same three verdicts (contractible / empty / two-point) occur as
-- readings of ONE construction, the product comparison, varying the
-- joint.  `Durnaya_CollapseIffEveryNayaAgrees` is the standpoint-level
-- statement of §२'s बहु: both-inhabited is not identifiable.  Abstract
-- 25's lossless completion applied to ⟨p,q⟩ is the purification: J
-- riding over A × B, its fibres carrying exactly what the marginals
-- forgot.
--
-- WHAT IS NOT CLAIMED.  No probability, no Hilbert space, no entropy
-- arithmetic: the statement I(A;B) = log(|A×B|/|J|) on uniform supports
-- is the cardinality SHADOW of §२'s fibre and is cited, not proved
-- here.  No claim that §४'s negative definition exhausts "life"; it
-- isolates one checkable ingredient — non-simulability by
-- non-interacting parts — at the smallest instance that has it.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9 — the repository pin.
-- --cubical --guardedness --safe, no postulates, no holes, exit 0.
------------------------------------------------------------------------

module Jiva_EntanglementIsTheFibreOfTheProductComparisonAndTheLivingStepRefusesToDescendToTheMarginals where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; fiber ; idIsEquiv ; equiv-proof)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- ० · the comparison map, for any joint.
------------------------------------------------------------------------

module _ {J A B : Type ℓ} (p : J → A) (q : J → B) where

  तुलना : J → A × B
  तुलना j = (p j , q j)

  -- independence IS this map being an equivalence; entanglement IS its
  -- fibre family.  Both words name the same object from the two sides.
  स्वातन्त्र्यम् : Type ℓ
  स्वातन्त्र्यम् = isEquiv तुलना

  संश्लेष-तन्तुः : A × B → Type ℓ
  संश्लेष-तन्तुः = fiber तुलना

------------------------------------------------------------------------
-- १ · the product pole: the comparison is the identity, definitionally.
------------------------------------------------------------------------

घट-तुलना : Bool × Bool → Bool × Bool
घट-तुलना = तुलना fst snd

-- Σ-eta makes ⟨fst , snd⟩ definitionally the identity, so independence
-- of the product joint is `idIsEquiv` with nothing to transport.
घटः-स्वतन्त्रः : isEquiv घट-तुलना
घटः-स्वतन्त्रः = idIsEquiv (Bool × Bool)

------------------------------------------------------------------------
-- २ · the diagonal joint: an EMPTY fibre, named.
------------------------------------------------------------------------

-- J = Bool, both projections the identity: the support {(t,t),(f,f)}.
कर्ण-तुलना : Bool → Bool × Bool
कर्ण-तुलना = तुलना (λ j → j) (λ j → j)

-- the excluded reading: (true , false) is a pair of marginal readings
-- the whole never realises.  A fibre point would identify true with
-- false through its own base point.
रिक्तम् : ¬ fiber कर्ण-तुलना (true , false)
रिक्तम् (j , pth) = true≢false (sym (cong fst pth) ∙ cong snd pth)

-- so the diagonal joint is entangled: the comparison is no equivalence,
-- because an equivalence has an inhabited fibre over every point.
कर्णः-न-स्वतन्त्रः : ¬ isEquiv कर्ण-तुलना
कर्णः-न-स्वतन्त्रः e = रिक्तम् (e .equiv-proof (true , false) .fst)

------------------------------------------------------------------------
-- ३ · the joint that outruns its marginals: a TWO-POINT fibre, named.
------------------------------------------------------------------------

-- J = Bool over the one-point parts: two globally distinct situations
-- whose every marginal reading agrees.
गूढ-तुलना : Bool → Unit × Unit
गूढ-तुलना = तुलना (λ _ → tt) (λ _ → tt)

गूढ-सत्यम् गूढ-असत्यम् : fiber गूढ-तुलना (tt , tt)
गूढ-सत्यम्  = (true  , refl)
गूढ-असत्यम् = (false , refl)

-- the two residents are distinct, by the base point alone.
गूढौ-भिन्नौ : ¬ गूढ-सत्यम् ≡ गूढ-असत्यम्
गूढौ-भिन्नौ pth = true≢false (cong fst pth)

------------------------------------------------------------------------
-- ४ · conditional certainty is a reconstruction: H(A|B) = 0 as a term.
------------------------------------------------------------------------

-- on the diagonal joint, the reading of B determines A: the recovering
-- function is exhibited and the square commutes by refl.  By symmetry
-- of the construction the same term is the other direction, so the
-- joint is the graph of a bijection — the pole where the part's
-- uncertainty is entirely the whole's information.
प्रत्यानयनम् : Bool → Bool
प्रत्यानयनम् b = b

प्रत्यानयन-साक्षी : (j : Bool) → प्रत्यानयनम् (snd (कर्ण-तुलना j)) ≡ fst (कर्ण-तुलना j)
प्रत्यानयन-साक्षी j = refl

------------------------------------------------------------------------
-- ५ · the living step: no marginal endomap simulates it.
------------------------------------------------------------------------

_⊕_ : Bool → Bool → Bool
false ⊕ b = b
true  ⊕ b = not b

-- the controlled-not on the full product joint: the visible part is
-- rewritten by consulting the hidden part.
जीवन-पदम् : Bool × Bool → Bool × Bool
जीवन-पदम् (a , b) = (a ⊕ b , b)

-- descent along the visible projection: some f : Bool → Bool closing
-- the square f ∘ fst ∼ fst ∘ step.
अवतरणम् : (Bool × Bool → Bool × Bool) → Type
अवतरणम् step = Σ (Bool → Bool) (λ f → (j : Bool × Bool) → f (fst j) ≡ fst (step j))

-- THE THEOREM.  The two interrogating configurations share their
-- visible half and split their hidden half; any simulator must answer
-- both with one value, and the collision is true≢false.
जीवति : ¬ अवतरणम् जीवन-पदम्
जीवति (f , h) = true≢false (sym (h (true , false)) ∙ h (true , true))

-- a fortiori, no PAIR of marginal endomaps simulates the living step:
-- a pair simulation restricts to a descent along fst.
युगल-अवतरणम् : (Bool × Bool → Bool × Bool) → Type
युगल-अवतरणम् step =
  Σ (Bool → Bool) (λ f → Σ (Bool → Bool) (λ g →
    (j : Bool × Bool) → (f (fst j) , g (snd j)) ≡ step j))

जीवति-युगलेऽपि : ¬ युगल-अवतरणम् जीवन-पदम्
जीवति-युगलेऽपि (f , g , h) = जीवति (f , λ j → cong fst (h j))

------------------------------------------------------------------------
-- ६ · beside it, the decoherent step, and its descent by refl.
------------------------------------------------------------------------

मृत-पदम् : Bool × Bool → Bool × Bool
मृत-पदम् (a , b) = (not a , b)

विलयः : अवतरणम् मृत-पदम्
विलयः = not , λ j → refl

-- the contrast is the content: same joint, same projections, one step
-- provably inseparable and one separable, and the difference is not a
-- number but a term — whether the square closes.
