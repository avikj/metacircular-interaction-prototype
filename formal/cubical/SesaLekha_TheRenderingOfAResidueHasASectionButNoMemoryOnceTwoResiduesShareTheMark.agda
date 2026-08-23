{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- शेष-लेखः — the writing of the remainder.  Compound built here,
-- 2026-08-23 (शेष, remainder; लेख, writing/record); it is not a source
-- term.  The DOCTRINE it checks is the corpus's own, stated in prose in
-- four places and as a term in none of them:
--
--   * Vipratisedha (machine/): "`Dosa` is the WRITING of the undecided
--     site … a caller handed only a `Dosa` can print the fourth position
--     and can do nothing else with it … none of it is computable from
--     the `Dosa` alone."
--   * Uttara (machine/): "a count is ∥·∥₁ of the list it replaces" —
--     naṣṭa must be named item by item, never counted.
--   * SaptabhangiGarbha (machine/): the label lane is a retract of the
--     record lane — proved for the standpoint families in
--     Arpitanarpita_…agda (section, homomorphism, no inverse).
--   * SesaMulya / Mulyankana (this lane): the fibre IS the amount; a
--     बहु flag is the collapse of the fibre that grounds it.
--
-- All four are one statement about one map, and this module is that
-- statement, checked once, generically:
--
--   the RENDERING  लेखः : R ⊎ S → R ⊎ Unit  — keep the resolved cases,
--   reduce every residue to the bare mark that one exists —
--
--   §1  HAS A SECTION as soon as one residue is in hand (पूरणम्): the
--       mark can always be FILLED, which is why a rendering looks
--       harmless — nothing appears to be missing from where the reader
--       stands;
--   §2  HAS NO LEFT INVERSE once two distinct residues share the mark
--       (स्मृति-अभावः / अ-प्रत्यागमः): any map back forces the two to
--       coincide.  The WHICH is not in the mark, and no post-processing
--       of the mark manufactures it — the same shape as
--       QuotientFiberLaw's `no-decision`, arriving at the answer type
--       instead of the transcript.
--
-- So a Dosa without its Sesa, a count without its list, a label without
-- its naya, a बहु without its fibre are all the same object: a mark
-- with a filler and no memory.  The filler is the trap — §1 is why the
-- collapse feels safe, §2 is why it is not.
--
-- RELATION TO WHAT IS ALREADY CHECKED, so this does not overclaim:
-- Apratikaryatva_…agda proves the WHOLE-TYPE case (a retraction of
-- ∣_∣ₕ is exactly an h-level hypothesis); Arpitanarpita_…agda proves
-- the standpoint-family instance.  This is the one-summand case those
-- two sit either side of, stated so the machine lane's prose sentences
-- have a term to point at.  NOVELTY CLAIMED: none of the mathematics —
-- every step is elementary; the content is the identification of the
-- four sites as instances.
--
-- §3 instantiates it at the fibre: Mulyankana's बहु at 0 (three
-- configurations under one mark) — the two exhibited residues are
-- distinct, so the count admits no way back, by the generic theorem
-- and nothing else.
------------------------------------------------------------------------

module SesaLekha_TheRenderingOfAResidueHasASectionButNoMemoryOnceTwoResiduesShareTheMark where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

open import Mulyankana_TheTwoOccupancyEdgesArePricedTheirFibreSpectraComputedAtEveryTarget
  using (g)

private
  variable
    ℓ ℓ' : Level

module _ {R : Type ℓ} {S : Type ℓ'} where

  -- the rendering: resolved cases survive whole; every residue becomes
  -- the bare mark that one exists.
  लेखः : R ⊎ S → R ⊎ Unit
  लेखः (inl r) = inl r
  लेखः (inr _) = inr tt

  ----------------------------------------------------------------------
  -- §1  The mark can be filled — one residue in hand gives a section.
  --     This is why a rendering looks harmless.
  ----------------------------------------------------------------------

  पूरणम् : S → (R ⊎ Unit → R ⊎ S)
  पूरणम् s₀ (inl r) = inl r
  पूरणम् s₀ (inr _) = inr s₀

  पूरण-साक्षिन् : (s₀ : S) (y : R ⊎ Unit) → लेखः (पूरणम् s₀ y) ≡ y
  पूरण-साक्षिन् s₀ (inl r) = refl
  पूरण-साक्षिन् s₀ (inr tt) = refl

  ----------------------------------------------------------------------
  -- §2  The mark has no memory — a left inverse forces any two residues
  --     to coincide, so once two distinct residues share the mark there
  --     is no way back at all.
  ----------------------------------------------------------------------

  स्मृति-अभावः : (h : R ⊎ Unit → R ⊎ S)
    → ((x : R ⊎ S) → h (लेखः x) ≡ x)
    → (s₁ s₂ : S) → s₁ ≡ s₂
  स्मृति-अभावः h ret s₁ s₂ =
    cong (प्रति s₁) (sym (ret (inr s₁)) ∙ ret (inr s₂))
    where
    प्रति : S → R ⊎ S → S
    प्रति d (inl _) = d
    प्रति d (inr s) = s

  अ-प्रत्यागमः : (s₁ s₂ : S) → ¬ s₁ ≡ s₂
    → ¬ (Σ[ h ∈ (R ⊎ Unit → R ⊎ S) ] ((x : R ⊎ S) → h (लेखः x) ≡ x))
  अ-प्रत्यागमः s₁ s₂ ne (h , ret) = ne (स्मृति-अभावः h ret s₁ s₂)

------------------------------------------------------------------------
-- §3  The fibre instance: Mulyankana's बहु at 0.  Two of the three
--     configurations under the one mark, distinct — so the count of
--     that fibre is a mark with no memory, by §2 alone.
------------------------------------------------------------------------

शेष-वाम शेष-दक्षिण : fiber g 0
शेष-वाम    = (true  , false) , refl
शेष-दक्षिण = (false , true ) , refl

शेष-भेदः : ¬ शेष-वाम ≡ शेष-दक्षिण
शेष-भेदः p = true≢false (cong (λ q → fst (fst q)) p)

-- the count cannot be undone: for ANY resolved side R, the rendering of
-- this fibre's residues admits no left inverse.
गणना-न-स्मरति : {R : Type ℓ}
  → ¬ (Σ[ h ∈ (R ⊎ Unit → R ⊎ fiber g 0) ]
        ((x : R ⊎ fiber g 0) → h (लेखः x) ≡ x))
गणना-न-स्मरति = अ-प्रत्यागमः शेष-वाम शेष-दक्षिण शेष-भेदः
