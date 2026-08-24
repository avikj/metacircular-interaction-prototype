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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ध्रुव — यत्र न किञ्चित् नश्यति तत्र गतिः अपि न अस्ति ।
--
-- (where nothing is lost, there is no motion either.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  Noether's structural half, in three lines, on an object
-- this corpus has had since its first file and used for something else.
--
-- `punaragamana/src/Punaragamana/Carrier.agda:141` opens
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
