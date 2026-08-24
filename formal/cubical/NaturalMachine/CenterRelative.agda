-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.CenterRelative
--
-- TARGET A OF THE ANEKĀNTA–UNIVALENCE DELTA: w ± r, executably.
--
-- The directive's own words for this target:
--
--   "In Cubical Agda over a setting where 2 is invertible, define
--    Φ(p,q) = ((p+q)/2, (q−p)/2), Ψ(w,r) = (w−r, w+r). Prove ΦΨ = id and
--    ΨΦ = id. Use univalence to obtain PairSpace = CenterRelativeSpace.
--    Define exchange τ(p,q) = (q,p) and reflection ρ(w,r) = (w,−r).
--    Prove Φ∘τ = ρ∘Φ. Then transport downstream structures through ua(Φ).
--    This elementary example is the founding executable reconciliation."
--
-- All of that is below, and one thing more that the directive asks for
-- separately and that this instance can supply on the nose (§5): ρ is not
-- merely intertwined with τ, it **IS** the transport of τ. That is the
-- directive's `f^e = e ∘ f ∘ e⁻¹` as a checked identity of functions
-- rather than a definition, and it is the smallest complete instance of
-- its "witnessed equivalence → transport" step.
--
-- METHOD NOTE, because the directive is explicit that warrant matters
-- (न्याय counterweight): this file reuses `NaturalMachine.Transport`'s
-- idiom exactly — `transportUAop₁` against `ua` of a constructed
-- equivalence — which is that module's `transport-+-is-⊕` one arity down.
-- Nothing here is a new technique. The content is that the pair/centre
-- exchange is an instance of it.
--
--
-- WHERE "2 IS INVERTIBLE" GOES, AND WHY IT IS A PARAMETER
--
-- The whole development is parameterised by a commutative ring `R`
-- together with an element `half` and a proof `half + half ≡ 1r`. It is
-- NOT specialised to ℚ or to ℤ[1/2], and it must not be: over ℤ the maps
-- are not defined at all (Φ leaves the ring), and hard-wiring a field
-- would hide exactly which hypothesis is load-bearing. Parameterising is
-- the statement that **`half + half ≡ 1r` is the entire arithmetic input**
-- — every proof below uses it exactly twice per component and otherwise
-- runs on ring axioms alone, discharged by the `CommRingSolver`.
--
-- Consequence worth stating, since the directive's target B is about
-- exactly this: characteristic 2 is not excluded by fiat. If `1r ≡ 0r`
-- the ring is trivial and everything holds vacuously; if `2` is a
-- zero-divisor but `half` exists the development still runs. What fails
-- without `half` is not a theorem here but the *definition* of Φ.
--
--
-- WHAT IS CHECKED
--
--   §1  `Φ`, `Ψ`             the two maps, over any (R, half).
--   §2  `ΨΦ`, `ΦΨ`           mutually inverse, pointwise.
--       `ΦIso`, `ΦEquiv`     hence an isomorphism and an equivalence …
--       `Pair≡Centre`        … and by univalence a PATH of types.
--                            "PairSpace = CenterRelativeSpace" is
--                            therefore an inhabitant of an identity type
--                            here, not a slogan.
--   §3  `τ`, `ρ`             exchange and reflection, with
--       `τ-invol`,`ρ-invol`  both shown involutive.
--   §4  `Φ∘τ≡ρ∘Φ`            THE INTERTWINER the directive names, as a
--                            path of functions (`funExt`), not pointwise
--                            only.
--   §5  `transport-τ-is-ρ`   THE TRANSPORT STATEMENT. Transporting `τ`
--                            along `ua ΦEquiv` yields **literally** `ρ`.
--                            So reflection is not analogous to exchange
--                            and is not merely conjugate to it; it is
--                            what exchange becomes when the identification
--                            is taken seriously.
--   §6  `ρ-is-conjugate`     the elementary reading of §5, `ρ = Φ∘τ∘Ψ`,
--                            kept because it is what a reader checks by
--                            hand and because §5 without it looks like
--                            machinery.
--
--
-- WHAT IS NOT CLAIMED
--
--  * **No arity above 2.** The directive's target C (Aᵏ ≃ A × V_k with an
--    Sₖ action, sign representation at k = 2, the 2-dimensional standard
--    representation at k = 3) is NOT here. What is here is the k = 2 case
--    of the *decomposition*, with the Sₖ-action content present only as
--    the single involution τ. In particular **nothing below exhibits the
--    sign representation as a representation** — `ρ` negates the relative
--    coordinate and fixes the centre, which is the sign rep on `V₂` and
--    the trivial rep on the centre line, but no group object, no module,
--    and no character is constructed. Reading §4 as "the sign
--    representation, checked" would be exactly the metaphor-promotion the
--    directive forbids.
--
--  * **No positive cone, so no boundary breaking.** Target B asks whether
--    the equivalence restricts to positive subobjects. `R` here has no
--    order, so the question cannot even be posed in this file. That is
--    deliberate: the directive's schema wants the failure exhibited as an
--    *uninhabited restricted equivalence type*, which needs an ordered
--    setting, and inventing one here would prejudge it.
--
--  * **No primes anywhere.** Despite the framing, nothing below mentions
--    primality, and the file would be identical for any (R, half). The
--    arithmetic content of "prime pairs" is entirely outside it. This is
--    a statement about the coordinate change and nothing else.
--
--  * **Not novel.** The change of coordinates (p,q) ↦ ((p+q)/2,(q−p)/2)
--    is elementary and ancient; `half + half ≡ 1r` is the only hypothesis
--    and any algebra text has this. What is offered is that it is now a
--    *path of types* with a *checked transport*, available to be consumed
--    by later modules rather than re-derived.
------------------------------------------------------------------------

module NaturalMachine.CenterRelative where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; ≡-× )

open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- The setting: a commutative ring in which 2 is invertible, presented by
-- the inverse itself.  `half+half` is the ONLY arithmetic hypothesis in
-- this file.
------------------------------------------------------------------------

module _ (R : CommRing ℓ) where
 open CommRingStr (snd R)

 -- `half+half ≡ 1r` is the ONLY arithmetic hypothesis in this file.  It
 -- is a nested parameter rather than part of the outer telescope purely
 -- so that `_+_` and `1r` are in scope when it is stated.
 module _ (half : ⟨ R ⟩) (half+half : half + half ≡ 1r) where

  Pair Centre : Type ℓ
  Pair   = ⟨ R ⟩ × ⟨ R ⟩        -- (p , q)
  Centre = ⟨ R ⟩ × ⟨ R ⟩        -- (w , r),  w the centre, r the radius

  ----------------------------------------------------------------------
  -- 1.  The two maps.
  ----------------------------------------------------------------------

  Φ : Pair → Centre
  Φ (p , q) = ( half · (p + q) , half · (q - p) )

  Ψ : Centre → Pair
  Ψ (w , r) = ( w - r , w + r )

  ----------------------------------------------------------------------
  -- 2.  Mutually inverse, hence a path of types.
  --
  -- Each component is `(ring identity) ∙ (the one hypothesis) ∙ ·IdL`.
  -- The ring identities are discharged by the solver, so what remains
  -- visible is exactly where `half + half ≡ 1r` is used: twice, once per
  -- component, and nowhere else.
  ----------------------------------------------------------------------

  private
    lemΨΦ₁ : (h p q : ⟨ R ⟩) → h · (p + q) - h · (q - p) ≡ (h + h) · p
    lemΨΦ₁ _ _ _ = solve! R

    lemΨΦ₂ : (h p q : ⟨ R ⟩) → h · (p + q) + h · (q - p) ≡ (h + h) · q
    lemΨΦ₂ _ _ _ = solve! R

    lemΦΨ₁ : (h w r : ⟨ R ⟩) → h · ((w - r) + (w + r)) ≡ (h + h) · w
    lemΦΨ₁ _ _ _ = solve! R

    lemΦΨ₂ : (h w r : ⟨ R ⟩) → h · ((w + r) - (w - r)) ≡ (h + h) · r
    lemΦΨ₂ _ _ _ = solve! R

    unit : (x : ⟨ R ⟩) → (half + half) · x ≡ x
    unit x = cong (_· x) half+half ∙ ·IdL x

  ΨΦ : (x : Pair) → Ψ (Φ x) ≡ x
  ΨΦ (p , q) =
    ≡-× (lemΨΦ₁ half p q ∙ unit p)
        (lemΨΦ₂ half p q ∙ unit q)

  ΦΨ : (y : Centre) → Φ (Ψ y) ≡ y
  ΦΨ (w , r) =
    ≡-× (lemΦΨ₁ half w r ∙ unit w)
        (lemΦΨ₂ half w r ∙ unit r)

  ΦIso : Iso Pair Centre
  Iso.fun      ΦIso = Φ
  Iso.inv      ΦIso = Ψ
  Iso.rightInv ΦIso = ΦΨ
  Iso.leftInv  ΦIso = ΨΦ

  ΦEquiv : Pair ≃ Centre
  ΦEquiv = isoToEquiv ΦIso

  -- "PairSpace = CenterRelativeSpace", as an inhabitant of an identity
  -- type in the universe.  This is the directive's collapse step, and it
  -- is a collapse only because §2 witnessed it.
  Pair≡Centre : Pair ≡ Centre
  Pair≡Centre = ua ΦEquiv

  ----------------------------------------------------------------------
  -- 3.  Exchange and reflection.
  ----------------------------------------------------------------------

  τ : Pair → Pair
  τ (p , q) = (q , p)

  ρ : Centre → Centre
  ρ (w , r) = (w , - r)

  τ-invol : (x : Pair) → τ (τ x) ≡ x
  τ-invol (p , q) = refl

  ρ-invol : (y : Centre) → ρ (ρ y) ≡ y
  ρ-invol (w , r) = ≡-× refl (lem r)
    where
    lem : (x : ⟨ R ⟩) → - (- x) ≡ x
    lem _ = solve! R

  ----------------------------------------------------------------------
  -- 4.  THE INTERTWINER, as a path of functions.
  ----------------------------------------------------------------------

  private
    lemτ₁ : (h p q : ⟨ R ⟩) → h · (q + p) ≡ h · (p + q)
    lemτ₁ _ _ _ = solve! R

    lemτ₂ : (h p q : ⟨ R ⟩) → h · (p - q) ≡ - (h · (q - p))
    lemτ₂ _ _ _ = solve! R

  Φ∘τ≡ρ∘Φ : Φ ∘ τ ≡ ρ ∘ Φ
  Φ∘τ≡ρ∘Φ = funExt λ { (p , q) → ≡-× (lemτ₁ half p q) (lemτ₂ half p q) }

  ----------------------------------------------------------------------
  -- 5.  THE TRANSPORT STATEMENT.
  --
  -- Transporting the exchange involution along the univalent path yields
  -- literally the reflection.  Not "corresponds to", not "is conjugate
  -- to" — the two functions are equal.
  --
  -- This is `NaturalMachine.Transport.transport-+-is-⊕` one arity down,
  -- with `transportUAop₁` in place of `transportUAop₂`; the idiom is
  -- borrowed wholesale and is not claimed as new.
  ----------------------------------------------------------------------

  transport-τ-is-ρ :
    transport (λ i → Pair≡Centre i → Pair≡Centre i) τ ≡ ρ
  transport-τ-is-ρ = funExt λ y →
      transportUAop₁ ΦEquiv τ y
    ∙ cong Φ (cong τ (ΨΦ' y))
    ∙ funExt⁻ Φ∘τ≡ρ∘Φ (Ψ y)
    ∙ cong ρ (ΦΨ y)
    where
    -- `invEq ΦEquiv` is `Ψ` up to the isomorphism's own retraction data;
    -- name the step rather than let it hide inside the chain.
    ΨΦ' : (y : Centre) → invEq ΦEquiv y ≡ Ψ y
    ΨΦ' y = refl

  ----------------------------------------------------------------------
  -- 6.  The hand-checkable reading of §5.
  ----------------------------------------------------------------------

  ρ-is-conjugate : (y : Centre) → ρ y ≡ Φ (τ (Ψ y))
  ρ-is-conjugate y =
    sym (funExt⁻ Φ∘τ≡ρ∘Φ (Ψ y) ∙ cong ρ (ΦΨ y))
