{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- शेष-समवाय — the inherence of the remainder.
--
-- THE GENERATIVITY CLAUSE, at full generality.  The śeṣa trilaw says a
-- projection's residue is conserved, inaccessible from below, and IS
-- the structure of the level above.  The first two clauses are the
-- corpus's standing theorems.  This file proves the third, for any
-- family whatsoever:
--
--   THE SYMMETRIES OVER THE BASE ARE EXACTLY THE ASSEMBLED RESIDUE
--   FAMILIES.  For any base B and family F:
--
--   §1  Every family of fibre endomaps assembles into an endomap of
--       the total space that is over the base BY REFL (ā-kriyā,
--       ūrdhva-refl): residue structure acts above, for free.
--
--   §2  Every endomap over the base IS such an assembly, pointwise
--       (sarva): from the over-ness witness, the residue family is
--       extracted (pratyāhāra) and the original map is recovered at
--       every point, with no hypothesis on B or F.  Nothing acts over
--       the base except through the residues.
--
--   §3  The extraction retracts the assembly (punar): the residue
--       family is recoverable from its action, up to the transport
--       filler.  Assembly is a split injection: distinct residue
--       structures act distinctly.
--
-- So "the level above" is not a metaphor: the maps of the total space
-- that respect the projection are precisely the residue's own
-- endomap families, assembled — the fibres are not what the level
-- above forgets, they are what it is MADE OF.  PurnaModa is the braid
-- instance: the center acts fibrewise (an assembled family — the
-- global half-wave), while the crossings MOVE the base, which is
-- exactly why braiding is more than vertical structure: coherence
-- beyond the residue level is base motion, and the residue level is
-- everything that is not.
--
-- SYĀT — THE CLAIM, EXACTLY.  Endomaps, one fixed projection; the
-- groupoid version (over-equivalences, and the full Aut(E/B) ≃ Π-Aut
-- of fibres as a group identity) is the next construction.
------------------------------------------------------------------------

module SesaSamavaya_TheResidueStructureExhaustsTheSymmetriesOverTheBaseEveryOverMapIsAnAssembledFibreFamily where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd ; ΣPathP)

private
  variable
    ℓ ℓ' : Level

module _ {B : Type ℓ} {F : B → Type ℓ'} where

  -- The residue structure: a family of fibre endomaps.
  Vṛtti : Type (ℓ-max ℓ ℓ')
  Vṛtti = (b : B) → F b → F b

  -- §1 · Assembly, over the base by refl.
  ā-kriyā : Vṛtti → Σ B F → Σ B F
  ā-kriyā h (b , x) = b , h b x

  ūrdhva-refl : (h : Vṛtti) (s : Σ B F) → fst (ā-kriyā h s) ≡ fst s
  ūrdhva-refl h s = refl

  -- §2 · Extraction, and exhaustion: every over-map is an assembly.
  pratyāhāra : (g : Σ B F → Σ B F)
             → ((s : Σ B F) → fst (g s) ≡ fst s)
             → Vṛtti
  pratyāhāra g ūrdhva b x = subst F (ūrdhva (b , x)) (snd (g (b , x)))

  sarva : (g : Σ B F → Σ B F)
          (ūrdhva : (s : Σ B F) → fst (g s) ≡ fst s)
          (s : Σ B F)
        → g s ≡ ā-kriyā (pratyāhāra g ūrdhva) s
  sarva g ūrdhva (b , x) =
    ΣPathP (ūrdhva (b , x)
           , subst-filler F (ūrdhva (b , x)) (snd (g (b , x))))

  -- §3 · The retraction: the residue family is recoverable from its
  -- own action.
  punar : (h : Vṛtti) → pratyāhāra (ā-kriyā h) (λ _ → refl) ≡ h
  punar h = funExt λ b → funExt λ x → transportRefl (h b x)
