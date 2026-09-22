{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समानमार्गः — the hand road and the transport road are ONE path.
--
-- THE CLAIM.  `LosslessReturn_TheHandProofWasUnnecessary…agda` §5
-- states that its transport-built path (╗�) ≡ ������-������
-- is the same path the hand proof produced.  This module proves it.
--
-- HOW.  `ua` is (one leg of) an equivalence, hence injective; so it is
-- enough to compare what sits under each road.  The hand road is
-- `isoToPath iso = ua (isoToEquiv iso)`, one `ua`.  The transport road is
-- `ua (Carrier≃ योग) ∙ sym (ua विवेक≃वाहकः)`, which `uaInvEquiv` and
-- `uaCompEquiv` fold back into a single `ua` of one composite equivalence.
-- Those two equivalences have JUDGMENTALLY equal underlying functions —
-- the composite sends (s,l) to a record whose प्रमाण field is `sym refl`,
-- the hand map to the same record with प्रमाण = `refl`, and `sym refl` is
-- `refl` definitionally — so `equivEq (funExt λ _ → refl)` closes it and
-- `cong ua` lifts it to the paths.
------------------------------------------------------------------------

module SamanaMarga_TheHandPathAndTheTransportPathAreOnePath where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; _∙ₑ_ ; invEquiv ; equivEq)
open import Cubical.Foundations.Isomorphism using (isoToPath ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaCompEquiv ; uaInvEquiv)
open import Cubical.Data.Nat using (ℕ ; _+_)
open import Cubical.Data.Sigma using (_×_)

import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats as V
import LosslessReturn_TheHandProofWasUnnecessaryAndTransportGivesIt as P

------------------------------------------------------------------------
-- १ · The two equivalences underneath the two roads are the same map.
--
-- The composite  Carrier≃ योग  then  invEquiv विवेक≃वाहकः  equals, as an
-- equivalence, the hand-built  isoToEquiv isoℕ×ℕ-विवेक-प्रमाण.  Their
-- forward functions are judgmentally equal (the only difference is
-- `sym refl` versus `refl` in the प्रमाण component), so funext is refl.
------------------------------------------------------------------------

संक्रमण-तुल्यम् :
  (P.Carrier≃ P.योग ∙ₑ invEquiv P.विवेक≃वाहकः)
    ≡ isoToEquiv V.isoℕ×ℕ-विवेक-प्रमाण
संक्रमण-तुल्यम् = equivEq (funExt λ _ → refl)

------------------------------------------------------------------------
-- २ · Therefore the two roads are one path.
--
-- Reduce the transport road to a single `ua`, swap in the equal
-- equivalence, and land on the hand road — every step a univalence lemma
-- or `cong ua` of §1.
------------------------------------------------------------------------

समानमार्गः : V.ℕ×ℕ≡विवेक-प्रमाण ≡ P.ℕ×ℕ≡विवेक-प्रमाण
समानमार्गः =
    V.ℕ×ℕ≡विवेक-प्रमाण
  ≡⟨ refl ⟩                                       -- isoToPath = ua ∘ isoToEquiv
    ua (isoToEquiv V.isoℕ×ℕ-विवेक-प्रमाण)
  ≡⟨ cong ua (sym संक्रमण-तुल्यम्) ⟩
    ua (P.Carrier≃ P.योग ∙ₑ invEquiv P.विवेक≃वाहकः)
  ≡⟨ uaCompEquiv (P.Carrier≃ P.योग) (invEquiv P.विवेक≃वाहकः) ⟩
    ua (P.Carrier≃ P.योग) ∙ ua (invEquiv P.विवेक≃वाहकः)
  ≡⟨ cong (ua (P.Carrier≃ P.योग) ∙_) (uaInvEquiv P.विवेक≃वाहकः) ⟩
    ua (P.Carrier≃ P.योग) ∙ sym (ua P.विवेक≃वाहकः)
  ∎
