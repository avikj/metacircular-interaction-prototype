{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- ────────────────────────────────────────────────────────────────────
-- ⚑ STRUCK 2026-08-25, and the strike is against this file's OWN slogan,
-- not against its term.  Salvaged from PR #23, which wrote it into a
-- README.md main has since deleted; it belongs here, in the module it is
-- about.
--
-- ~~"The lossless world is frozen: motion requires hiding."~~
-- ~~"In a world where everything is seen, nothing can happen that keeps
--   the books."~~  ~~"The universe has dynamics BECAUSE it has cuts."~~
--
-- READ THE TYPE.  `नष्ट-अभावे-गति-अभावः : isEquiv f → संरक्षणम् → (a : A)
-- → Φ a ≡ a` quantifies over the Φ that satisfy `संरक्षणम्` AND OVER NO
-- OTHERS.  Φ is a bare self-map — no inverse, no group — and the theorem
-- kills exactly the conservative ones.  **A lossless world still has every
-- non-conservative Φ available to it and is NOT frozen.  What it lacks is
-- conservative dynamics, not dynamics.**  Motion does not require hiding;
-- CONSERVATION requires hiding, which is the weaker sentence this file
-- already had and which needed no strengthening.
--
-- AND THE HYPOTHESIS IS ONE PHYSICS NEVER OCCUPIES.  `isEquiv f` says the
-- observable is a COMPLETE state description.  No conserved quantity is
-- one: energy is a map from phase space to ℝ, enormously lossy, and so is
-- every Noether charge — which is precisely this file's own content, "the
-- conserved quantity is the fibre index."  So the `isEquiv` branch is not
-- a statement about worlds that have conservation laws.  It is the
-- degenerate case where there is no index left to carry, and reading it
-- as a cosmological necessity imports what the term cannot carry.
--
-- WHAT SURVIVES, smaller and still worth it: `isEquiv f → संरक्षणम् →
-- Φ ≡ id` forces stillness only for flows conserving a LOSSLESS
-- observable.  Nothing conservative remains at the apex.  That is a
-- different sentence from *omniscience is stillness*.
--
-- THE TERM IS SOUND AND IS NOT TOUCHED.  §२'s proof is correct as
-- written: `c : isContr (fiber f (f a))` from `equiv-proof`, the two
-- inhabitants `(Φ a , cons a)` and `(a , refl)`, `cong fst` on the
-- composite.  What was struck above was written AROUND the term, not in
-- it.
-- ────────────────────────────────────────────────────────────────────
------------------------------------------------------------------------
-- ध्रुव — यत्र न किञ्चित् नश्यति तत्र गतिः अपि न अस्ति ।
--
-- (where nothing is lost, there is no motion either.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  Noether's structural half, in three lines, on an object
-- this corpus has had since its first file and used for something else.
--
-- `loss/src/Loss/Carrier.agda:141` opens
--
--     module _ {A B : Type ℓ} (f : A → B) (Φ : A → A) where
--
-- — an observation map AND an endomorphism in one telescope.  That is a
-- dynamical system with an observable.  It proves `Φ-square` and
-- `Φ-ascend` by `refl`, so the flow conjugates through the पुनरागमन
-- equivalence for free.  What it never states is CONSERVATION.
--
-- Conservation is one equation:  f ∘ Φ ≡ f.  The observable does not
-- change under the flow.  And §१ is the whole content:
--
--     **f ∘ Φ ≡ f  ⟺  Φ maps every fibre into itself.**
--
-- The symmetry acts INSIDE the fibres.  The conserved quantity is the
-- fibre index.  The gauge orbit is the fibre.  Emmy Noether, 1918,
-- Invariante Variationsprobleme — read at the level where no Lagrangian
-- is needed.
--
-- §२ is the sentence in the title and it is the one worth having:
-- **if `f` loses nothing, conservation forces the flow to be the
-- identity.**  No fibre, no symmetry.  A symmetry needs somewhere to
-- live, and the only place it can live is what the observable cannot
-- see.  That is why `notes/GAUGE.md`'s Theorem F and this are the same
-- shape: a system with nothing hidden has nothing conserved either,
-- because it has no room to move.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED, and the fence matters because the resemblance is
-- seductive.
--
-- **This is NOT Noether's first theorem.**  That one needs a continuous
-- one-parameter group acting on a Lagrangian dynamics, and produces a
-- conserved CURRENT by a variational argument.  Nothing below has a
-- Lagrangian, a variation, an action, or continuity: `Φ` is a bare
-- endomorphism and the statement is discrete and structural.  What
-- survives the stripping is the part that never needed the calculus —
-- *invariance under a flow means the flow moves within the level sets* —
-- and saying so precisely is the point of writing it down rather than
-- gesturing at it.
--
-- **Noether's SECOND theorem is closer and still not derived here.**  It
-- says a local (gauge) symmetry yields a constraint rather than a
-- conserved charge, which in this vocabulary is the degenerate case:
-- when the flow is transitive on a fibre the whole fibre is one physical
-- state and there is no charge to carry.  §३ exhibits that degeneracy
-- but does not prove the general dichotomy; transitivity is not stated.
--
-- Emmy Noether is credited for the theorem this is named after and for
-- nothing below, and no Sanskrit source states any of it.
--
-- TERM.  ध्रुव — fixed, immovable, the pole star; and in the
-- astronomical tradition ध्रुवराशि / ध्रुवक is the technical term for a
-- CONSTANT quantity in a computation, the term that does not vary as the
-- others are stepped (Āryabhaṭa, आर्यभटीयम्, 499, and standard in the
-- siddhāntas after).  LIMIT: attested for a constant of calculation; its
-- use here for a conserved quantity of a flow is this corpus's, and no
-- text is claimed for the application.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Sigma

private variable ℓ : Level

module _ {A B : Type ℓ} (f : A → B) (Φ : A → A) where

  -- The observable is unchanged by the flow.
  संरक्षणम् : Type ℓ
  संरक्षणम् = (a : A) → f (Φ a) ≡ f a

------------------------------------------------------------------------
-- १ · The symmetry acts inside the fibres.  Both directions.
--
-- Conservation gives an endomorphism of every fibre, and it is `Φ`
-- itself with the witness composed.  The converse is definitional and is
-- noted at the site rather than given a second name.
--
-- This is the whole of Noether's structural content.  A conserved
-- quantity is the fibre index; the motion is orthogonal to it.
------------------------------------------------------------------------

  ध्रुव-तन्तौ : संरक्षणम् → (b : B) → fiber f b → fiber f b
  ध्रुव-तन्तौ cons b (a , p) = Φ a , cons a ∙ p

  -- The converse needs no term: `Φ a` lying in the fibre over `f a` IS
  -- `f (Φ a) ≡ f a`, which is `संरक्षणम्` unfolded.  Writing a
  -- declaration for it would be a second name for one statement, which
  -- is the पुनरुक्ति this corpus keeps catching itself in.

------------------------------------------------------------------------
-- २ · WITHOUT A LOSS THERE IS NO SYMMETRY.
--
-- If `f` is an equivalence — every fibre contractible, nothing hidden,
-- zero receipt — then conservation forces the flow to be the identity.
--
-- The proof is the contractibility of the fibre used once: `(Φ a, cons a)`
-- and `(a, refl)` are both points of the fibre over `f a`, so they are
-- equal, so their first components are.
--
-- Read at the physics: a system whose observables see everything has no
-- symmetry, because a symmetry needs somewhere to live and the only
-- place available is what the observable cannot distinguish.  Gauge
-- freedom IS the fibre.  This is `notes/GAUGE.md`'s Theorem F in its
-- smallest form — nothing hidden, nothing conserved, nothing to move.
------------------------------------------------------------------------

  नष्ट-अभावे-गति-अभावः : isEquiv f → संरक्षणम् → (a : A) → Φ a ≡ a
  नष्ट-अभावे-गति-अभावः e cons a =
    cong fst (sym (c .snd (Φ a , cons a)) ∙ c .snd (a , refl))
    where
      c : isContr (fiber f (f a))
      c = e .equiv-proof (f a)

------------------------------------------------------------------------
-- ३ · The degenerate case: a fibre with one point carries no charge.
--
-- If the fibre over `b` is contractible then the flow's action on it is
-- trivial in the only sense available — any two points of it are equal,
-- so moving is indistinguishable from staying.  That is the shape of
-- Noether's SECOND theorem's conclusion (pure gauge: the whole orbit is
-- one physical state) exhibited at the smallest fibre, and it is NOT the
-- general dichotomy, which needs transitivity and is not stated here.
------------------------------------------------------------------------

  शून्य-भारः : (b : B) → isContr (fiber f b)
             → (x y : fiber f b) → x ≡ y
  शून्य-भारः b c x y = sym (c .snd x) ∙ c .snd y

------------------------------------------------------------------------
-- ४ · शेषः — what this opens.
--
-- The conserved quantity here is `f` itself: `संरक्षणम्` says exactly
-- that `f` is Φ-invariant, so `f` descends to the orbits.  That is a
-- `FactorsThrough` obligation and the corpus has that predicate in both
-- lanes, typed on the IMAGE rather than the codomain — so "the charge is
-- a function on the quotient, not on the cover" is stateable here and is
-- not stated yet.
--
-- What is genuinely missing for the first theorem is continuity and a
-- variational principle, and no amount of this vocabulary supplies them.
-- What is missing for the second is transitivity of the flow on a fibre.
-- Both are named rather than gestured at.
------------------------------------------------------------------------
