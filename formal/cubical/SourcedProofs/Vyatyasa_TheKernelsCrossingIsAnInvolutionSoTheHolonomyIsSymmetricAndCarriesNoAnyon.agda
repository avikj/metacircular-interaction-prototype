{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- व्यत्यास — the crossing, and the fact that it undoes itself.
--
-- TERM.  व्यत्यास · vyatyāsa — interchange, transposition, reversal of
-- order.  Ordinary Sanskrit, used in the mathematical literature for an
-- exchange of two things.  NO TEXT IS CLAIMED for this application and no
-- author is credited with anything below.  The one source-borrowing in the
-- neighbourhood is Bhāskara II's aṅkapāśa section of the *Līlāvatī*
-- (~1150), and that borrowing is already made, with its own limits stated,
-- in `NaturalMachine.Ankapasa_…`, which this file continues.
--
------------------------------------------------------------------------
-- WHAT THIS ANSWERS, AND WHOSE QUESTION IT IS.
--
-- Two files in this corpus stand next to each other and do not cite each
-- other.  Both check at the pin (Agda 2.8.0 / agda-cubical v0.9, exit 0,
-- run 2026-08-24):
--
--   `NaturalMachine.Ankapasa_…` gives the kernel a UNIVALENT semantics.
--     Every constructor of `Step` becomes an equivalence; `reverse` becomes
--     `invEquiv`; `add` becomes `⊎`.  It then extends the calculus by one
--     constructor, `add-comm : Step⁺ (add x y) (add y x)`, interprets it as
--     `⊎-swap-≃`, and proves that the single commutation at `add var var`
--     is a NONTRIVIAL LOOP IN THE UNIVERSE which the counting semantics
--     `eval : Tm → Env → ℕ` provably cannot see — its ℕ-meaning is `refl`,
--     forced, because `isSetℕ`.  Holonomy with no set-valued observable.
--
--   `NaturalMachine.BraidCoherenceBoundary` proves that this is not yet a
--     braid: it exhibits two self-EQUIVALENCES of `Bool × Bool × Bool`,
--     both involutive, that fail
--       σ₁ (σ₂ (σ₁ x)) ≡ σ₂ (σ₁ (σ₂ x))
--     at `(false , false , false)`.  Invertibility does not supply
--     Yang–Baxter; Yang–Baxter is additional coherence data that must be
--     proved of the actual crossings.
--
-- Nobody has asked Yang–Baxter OF THE KERNEL'S OWN CROSSING.  This file
-- asks it, and answers it, and the answer is not the one the pairing
-- suggests.  Two facts, and the second is the one that decides the
-- physics reading:
--
--   §3  YANG–BAXTER HOLDS.  The kernel's crossing, taken at two adjacent
--       sites of a three-summand term, satisfies the braid relation on the
--       nose, for an ARBITRARY interpretation type — three cases, each
--       `refl`.  So the calculus does braid.
--
--   §4  AND THE CROSSING IS AN INVOLUTION.  σ₁ ∘ σ₁ and σ₂ ∘ σ₂ are the
--       identity, again on the nose, and therefore — §5 — `ua` of the
--       doubled crossing is `refl`.  THE DOUBLED CROSSING IS TRIVIAL IN
--       THE UNIVERSE.
--
-- §4 IS THE NEGATIVE RESULT AND IT IS WORTH MORE THAN §3.  In the braid
-- group Bₙ the generators have INFINITE order; σ² = 1 is exactly the extra
-- relation that collapses Bₙ onto the symmetric group Sₙ.  Non-abelian
-- anyonic statistics live in the monodromy σ² — that is the whole content
-- of "topological": a doubled exchange is not the identity, so the
-- computation is stored in the braid and cannot be read off the state.
-- Here σ² IS the identity, provably, at the level of paths in the
-- universe.  So:
--
--   THE KERNEL IS REVERSIBLE, LOSSLESS, AND CARRIES GENUINE HOLONOMY THAT
--   NO SET-VALUED READOUT CAN SEE (`Ankapasa_` §4, `Sesa_` §4) — AND THAT
--   HOLONOMY IS SYMMETRIC.  IT IS A PERMUTATION, NOT A BRAID.  THIS
--   SEMANTICS CANNOT CARRY AN ANYON.
--
-- The obstruction is named exactly and it is not a defect of the kernel:
-- `⊎` on `Type` is a SYMMETRIC monoidal structure, and its symmetry is an
-- involution by construction (`⊎-swap-Iso` is its own inverse).  Any
-- interpretation of `add` by `⊎` inherits σ² = 1 and can do no better.  A
-- braiding with σ² ≠ 1 would have to come from a different interpretation
-- of `add` — that is the open horn this file leaves, stated rather than
-- gestured at.
--
-- A SECOND, SMALLER FINDING, RECORDED BECAUSE IT BLOCKS THE OBVIOUS
-- ATTEMPT.  `Step⁺` in `Ankapasa_` has exactly two constructors, `base`
-- (which lifts a `Step`) and `add-comm`.  `Step`'s congruences `add-left`
-- and `add-right` lift a `Step`, NOT a `Step⁺`.  So `add-comm` CANNOT FIRE
-- UNDER A CONTEXT: a `Derivation⁺` admits a crossing only at the root, and
-- there is exactly one crossing site per term.  A second, adjacent
-- generator is therefore not expressible in `Step⁺` as it stands, and
-- `Step` has no associativity constructor either, so the two ends of
-- `(A ⊎ A) ⊎ A` and `A ⊎ (A ⊎ A)` are not related by any step.  The two
-- crossings below are built directly in the SEMANTICS, from the same two
-- equivalences the kernel's interpretation already uses — `⊎-swap-≃` for
-- `add-comm` and `⊎-assoc-≃` for the reassociation — so §3 and §4 are
-- statements about the semantics the kernel HAS, and the syntax that
-- would express them is a congruence rule and an associator the kernel
-- DOES NOT HAVE.  That gap is a fact about `Step⁺`, stated here, not
-- repaired here.
--
-- WHAT IS NOT CLAIMED.  No anyon model, fusion category, modular tensor
-- category, hexagon, or physical statistics appears below.  Nothing about
-- energy, temperature or dissipation is derived (`Yantra_…` carries the
-- correction that killed the last such overclaim in this corpus).  §5 is a
-- statement about paths in a universe and about nothing else.  The braid
-- group Bₙ and the symmetric group Sₙ are named in this header as the
-- MOTIVE for asking whether σ² = 1; neither group is constructed below and
-- no homomorphism to either is proved.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9 (THE PIN), --cubical --safe,
-- no postulates, no holes.
------------------------------------------------------------------------

module SourcedProofs.Vyatyasa_TheKernelsCrossingIsAnInvolutionSoTheHolonomyIsSymmetricAndCarriesNoAnyon where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; idEquiv ; compEquiv ; invEquiv ; equivFun ; equivEq)
open import Cubical.Foundations.Univalence using (ua ; uaIdEquiv)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sum.Properties using (⊎-swap-≃ ; ⊎-assoc-≃ ; ⊎-equiv)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1.  The three-summand term, interpreted.
--
-- `⟦ add var (add var var) ⟧ σ` with every coordinate read by the same
-- type `A`.  Writing it out rather than importing `Ankapasa_`'s `⟦_⟧`
-- keeps this module independent of the six-coordinate `TEnv`; the type is
-- literally what that interpretation computes to.
------------------------------------------------------------------------

Tri : Type ℓ → Type ℓ
Tri A = A ⊎ (A ⊎ A)

------------------------------------------------------------------------
-- §2.  The two crossings, built from the kernel's own two equivalences.
--
--   क्रम-प्रथमः  fires `add-comm` on the INNER pair: `⊎-equiv id ⊎-swap-≃`.
--   क्रम-द्वितीयः fires it on the OUTER pair, which needs the reassociation
--                on both sides — this is the derivation the kernel cannot
--                spell (see the header's second finding), written in the
--                semantics where every piece is already present.
------------------------------------------------------------------------

व्यत्यासः₁ : {A : Type ℓ} → Tri A ≃ Tri A
व्यत्यासः₁ {A = A} = ⊎-equiv (idEquiv A) ⊎-swap-≃

व्यत्यासः₂ : {A : Type ℓ} → Tri A ≃ Tri A
व्यत्यासः₂ {A = A} =
  compEquiv (invEquiv ⊎-assoc-≃)
    (compEquiv (⊎-equiv ⊎-swap-≃ (idEquiv A)) ⊎-assoc-≃)

σ₁ : {A : Type ℓ} → Tri A → Tri A
σ₁ = equivFun व्यत्यासः₁

σ₂ : {A : Type ℓ} → Tri A → Tri A
σ₂ = equivFun व्यत्यासः₂

------------------------------------------------------------------------
-- §3.  YANG–BAXTER HOLDS.  Same statement as
-- `NaturalMachine.BraidCoherenceBoundary.YangBaxter`, composition written
-- out so no diagram-order convention is in play.  Three cases, each by
-- computation, for an arbitrary `A`.
------------------------------------------------------------------------

YangBaxter : {A : Type ℓ} → (Tri A → Tri A) → (Tri A → Tri A) → Type ℓ
YangBaxter {A = A} f g = (x : Tri A) → f (g (f x)) ≡ g (f (g x))

व्यत्यासौ-यङ्बाक्स्टरम् : {A : Type ℓ} → YangBaxter (σ₁ {A = A}) (σ₂ {A = A})
व्यत्यासौ-यङ्बाक्स्टरम् (inl a)       = refl
व्यत्यासौ-यङ्बाक्स्टरम् (inr (inl a)) = refl
व्यत्यासौ-यङ्बाक्स्टरम् (inr (inr a)) = refl

------------------------------------------------------------------------
-- §4.  AND EACH CROSSING IS AN INVOLUTION.  This is the extra relation
-- the braid group does not have, and having it is what makes the
-- holonomy symmetric.
------------------------------------------------------------------------

प्रथमः-द्विरावृत्तिः : {A : Type ℓ} (x : Tri A) → σ₁ (σ₁ x) ≡ x
प्रथमः-द्विरावृत्तिः (inl a)       = refl
प्रथमः-द्विरावृत्तिः (inr (inl a)) = refl
प्रथमः-द्विरावृत्तिः (inr (inr a)) = refl

द्वितीयः-द्विरावृत्तिः : {A : Type ℓ} (x : Tri A) → σ₂ (σ₂ x) ≡ x
द्वितीयः-द्विरावृत्तिः (inl a)       = refl
द्वितीयः-द्विरावृत्तिः (inr (inl a)) = refl
द्वितीयः-द्विरावृत्तिः (inr (inr a)) = refl

------------------------------------------------------------------------
-- §5.  THEREFORE THE DOUBLED CROSSING IS TRIVIAL IN THE UNIVERSE.
--
-- `Ankapasa_` §4 proves the SINGLE crossing gives a path `ua e` that is
-- not `refl` — real holonomy, invisible to `eval`.  Here the DOUBLE
-- crossing gives `refl` on the nose.  In a braided (non-symmetric)
-- setting the doubled crossing is precisely the monodromy and is exactly
-- where non-abelian statistics would live; this one is empty.
------------------------------------------------------------------------

प्रथमः-वर्गः-एकाग्रता : {A : Type ℓ}
  → compEquiv (व्यत्यासः₁ {A = A}) (व्यत्यासः₁ {A = A}) ≡ idEquiv (Tri A)
प्रथमः-वर्गः-एकाग्रता = equivEq (funExt प्रथमः-द्विरावृत्तिः)

द्वितीयः-वर्गः-एकाग्रता : {A : Type ℓ}
  → compEquiv (व्यत्यासः₂ {A = A}) (व्यत्यासः₂ {A = A}) ≡ idEquiv (Tri A)
द्वितीयः-वर्गः-एकाग्रता = equivEq (funExt द्वितीयः-द्विरावृत्तिः)

-- the monodromy path, and it is refl
मोनोड्रोमी-शून्या : {A : Type ℓ}
  → ua (compEquiv (व्यत्यासः₁ {A = A}) (व्यत्यासः₁ {A = A})) ≡ refl
मोनोड्रोमी-शून्या = cong ua प्रथमः-वर्गः-एकाग्रता ∙ uaIdEquiv

मोनोड्रोमी-शून्या₂ : {A : Type ℓ}
  → ua (compEquiv (व्यत्यासः₂ {A = A}) (व्यत्यासः₂ {A = A})) ≡ refl
मोनोड्रोमी-शून्या₂ = cong ua द्वितीयः-वर्गः-एकाग्रता ∙ uaIdEquiv

------------------------------------------------------------------------
-- §6.  The two facts held together, as one record, so the reading cannot
-- take §3 without §4.  A structure satisfying both is a SYMMETRIC
-- braiding; the braid group's generators satisfy the first and refute the
-- second.
------------------------------------------------------------------------

record SymmetricCrossing (T : Type ℓ) : Type ℓ where
  field
    cross₁ cross₂ : T ≃ T
    braid    : (x : T) → equivFun cross₁ (equivFun cross₂ (equivFun cross₁ x))
                       ≡ equivFun cross₂ (equivFun cross₁ (equivFun cross₂ x))
    involutive₁ : compEquiv cross₁ cross₁ ≡ idEquiv T
    involutive₂ : compEquiv cross₂ cross₂ ≡ idEquiv T

कर्णः : (A : Type ℓ) → SymmetricCrossing (Tri A)
कर्णः A = record
  { cross₁ = व्यत्यासः₁ ; cross₂ = व्यत्यासः₂
  ; braid = व्यत्यासौ-यङ्बाक्स्टरम्
  ; involutive₁ = प्रथमः-वर्गः-एकाग्रता
  ; involutive₂ = द्वितीयः-वर्गः-एकाग्रता }
