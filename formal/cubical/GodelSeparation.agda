{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- GodelSeparation
--
-- Which sentences does Lawvere's theorem prove, and which does it not?
--
-- `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Cor 2.1 says that
-- "Cantor's diagonal, Russell, Gödel's first incompleteness theorem,
-- Turing's halting argument and Tarski's undefinability are all
-- instances of" Lawvere's fixed-point theorem.  Three of those five are
-- instances.  Gödel's first incompleteness theorem is not, and this
-- module says so with a term rather than a paragraph.
--
-- The split, exactly:
--
--   * Cantor and Tarski are the SAME TERM as `LawvereDiagonal.cantor`,
--     read under two different glosses of the enumeration `e`.  No
--     hypothesis about a theory is used.  (§1 below.)
--
--   * Gödel's first incompleteness theorem splits into two conjuncts.
--     - T ⊬ G follows from the Lawvere fixed point together with TWO
--       hypotheses Lawvere does not supply: consistency, and the first
--       Hilbert–Bernays–Löb condition D1.  `goedelHalfOne`.
--     - T ⊬ ¬G does NOT follow from those hypotheses at all.
--       `noHalfTwo` refutes every would-be derivation, by exhibiting a
--       four-sentence structure satisfying consistency, D1 and the
--       Gödel fixed point in which ¬G IS provable.  The refutation is a
--       finite exhaustive verification, discharged by the typechecker.
--
-- The countermodel is not a curiosity: it is ω-inconsistent in exactly
-- the arithmetic sense — it proves `prov g` while not proving `g` — and
-- that is the failure mode Gödel 1931 excluded by assuming ω-consistency
-- and Rosser 1936 removed by changing the fixed point.  Changing the
-- fixed point is a choice of ν, not a consequence of the theorem about ν.
--
-- Prior art: Lawvere 1969; Pavlović, Arch. Math. Logic 31 (1992) 397–406;
-- Yanofsky, Bull. Symbolic Logic 9 (2003) 362–386; Roberts,
-- Compositionality (2023), arXiv:2110.00239.  See
-- notes/GODEL_BRIDGE_ADJUDICATED.md for what was and was not read.
------------------------------------------------------------------------

module GodelSeparation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Bool
open import Cubical.Data.Unit
open import Cubical.Data.Empty renaming (rec to absurd)
open import Cubical.Data.Sum
open import Cubical.Relation.Nullary

open import LawvereDiagonal

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1.  Tarski is Cantor's term.
--
-- Read A as the type of codes of formulas in one free variable and
-- `sat a x` as "the formula coded by a is satisfied by x".  A truth
-- definition inside the language is exactly a weak point-surjection: it
-- would realise every A-indexed Bool-valued behaviour as some row.  The
-- fixed-point-free ν is negation on truth values, as in Tarski 1933.
-- The term is `cantor`, unchanged — that identity IS the content.
------------------------------------------------------------------------

tarskiUndefinability : {A : Type ℓ} (sat : A → A → Bool) → ¬ WkPtSurj sat
tarskiUndefinability = cantor

------------------------------------------------------------------------
-- §2.  No stage of the diagonal tower is terminal.
--
-- The geometric obstruction tower is GRADED: the obstruction to
-- extending a section over the (n+1)-skeleton lies in H^{n+1}(X;π_n F),
-- and on a finite-dimensional complex the tower dies above dim X.  The
-- diagonal tower does not: adjoining the escaping observation D to the
-- stage A produces A ⊎ D, at which the very same theorem applies again,
-- at the same type level.  Ungraded and non-terminating, against graded
-- and terminating: a second discriminator, independent of the locality
-- one in notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md Thm 4.
------------------------------------------------------------------------

noTerminalStage : {A D : Type ℓ} (e : (A ⊎ D) → (A ⊎ D) → Bool)
  → ¬ WkPtSurj e
noTerminalStage = cantor

------------------------------------------------------------------------
-- §3.  Theories, abstractly: just enough to state Gödel I.
------------------------------------------------------------------------

record Theory (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    Sent : Type ℓ           -- sentences
    Pf   : Sent → Type ℓ    -- Pf s  is inhabited iff  T ⊢ s
    neg  : Sent → Sent      -- negation
    prov : Sent → Sent      -- the internal provability predicate at a code

open Theory public

-- T is consistent: never both s and ¬s.
Consistent : Theory ℓ → Type ℓ
Consistent T = (s : Sent T) → Pf T s → Pf T (neg T s) → ⊥

-- First Hilbert–Bernays–Löb condition: T ⊢ s implies T ⊢ Prov(⌜s⌝).
HBL1 : Theory ℓ → Type ℓ
HBL1 T = (s : Sent T) → Pf T s → Pf T (prov T s)

-- A Gödel fixed point for G: T ⊢ G ↔ ¬Prov(⌜G⌝).
-- This is ALL Lawvere's theorem delivers on the logical side; obtaining
-- it needs the representability of prov, which is a hypothesis about T,
-- not about the ambient cartesian closed structure.
GoedelFix : (T : Theory ℓ) → Sent T → Type ℓ
GoedelFix T G =
  (Pf T G → Pf T (neg T (prov T G))) × (Pf T (neg T (prov T G)) → Pf T G)

-- ω-inconsistency, in the one instance that matters here: T proves that
-- G is provable, and does not prove G.
OmegaBad : (T : Theory ℓ) → Sent T → Type ℓ
OmegaBad T G = Pf T (prov T G) × (¬ Pf T G)

------------------------------------------------------------------------
-- §4.  The half that follows: T ⊬ G.
--
-- Uses the forward direction of the fixed point, HBL1, and consistency.
-- It does NOT use ω-consistency, and it does not use the fixed point's
-- backward direction.
------------------------------------------------------------------------

goedelHalfOne : (T : Theory ℓ) (G : Sent T)
  → Consistent T → HBL1 T → GoedelFix T G
  → ¬ Pf T G
goedelHalfOne T G con d1 (fwd , _) pG =
  con (prov T G) (d1 G pG) (fwd pG)

------------------------------------------------------------------------
-- §5.  The half that does not: T ⊬ ¬G is underivable from those data.
--
-- The witness.  Four sentences: ⊤, ⊥, g, ¬g.  Negation swaps the pairs.
-- The provability predicate is constantly ⊤ — a legitimate `prov` for a
-- structure this small, and the only clause HBL1 constrains.  Provable:
-- exactly ⊤ and ¬g.
------------------------------------------------------------------------

data W : Type₀ where
  wtop wbot wg wng : W

wneg : W → W
wneg wtop = wbot
wneg wbot = wtop
wneg wg   = wng
wneg wng  = wg

wPf : W → Type₀
wPf wtop = Unit
wPf wbot = ⊥
wPf wg   = ⊥
wPf wng  = Unit

Wit : Theory ℓ-zero
Sent Wit = W
Pf   Wit = wPf
neg  Wit = wneg
prov Wit = λ _ → wtop

-- Consistency, by exhaustion over the four sentences.
witCon : Consistent Wit
witCon wtop _ b = b
witCon wbot a _ = a
witCon wg   a _ = a
witCon wng  _ b = b

-- HBL1: the consequent is `wPf wtop = Unit`, always inhabited.
witHBL1 : HBL1 Wit
witHBL1 _ _ = tt

-- The Gödel fixed point at g: both sides are ⊥, so both directions are
-- vacuous.  (wPf wg = ⊥ and wPf (wneg wtop) = wPf wbot = ⊥.)
witFix : GoedelFix Wit wg
witFix = absurd , absurd

-- …and yet ¬g is provable.
witProvesNegG : wPf (wneg wg)
witProvesNegG = tt

-- Therefore no derivation of the second conjunct of Gödel I from
-- {consistency, HBL1, Gödel fixed point} exists.  A negative with a
-- witness: any such derivation, applied to Wit, yields ⊥.
noHalfTwo :
  ((T : Theory ℓ-zero) (G : Sent T)
     → Consistent T → HBL1 T → GoedelFix T G
     → ¬ Pf T (neg T G))
  → ⊥
noHalfTwo half2 = half2 Wit wg witCon witHBL1 witFix witProvesNegG

-- The witness fails exactly where Gödel 1931 assumed ω-consistency: it
-- proves `prov g` and does not prove `g`.
witOmegaBad : OmegaBad Wit wg
witOmegaBad = tt , goedelHalfOne Wit wg witCon witHBL1 witFix

------------------------------------------------------------------------
-- §6.  Summary, as types.
--
--   Cantor              LawvereDiagonal.cantor          — an instance
--   Tarski              tarskiUndefinability (= cantor) — an instance
--   Gödel I, conjunct 1 goedelHalfOne                   — instance + 2 hyps
--   Gödel I, conjunct 2 noHalfTwo                       — NOT an instance
--
-- The corpus claim "Gödel's first incompleteness theorem is an instance
-- of Lawvere's fixed-point theorem" is therefore false-grounds: what is
-- an instance is the diagonal lemma.  The theorem is the diagonal lemma
-- plus arithmetic hypotheses that no cartesian closed category supplies.
------------------------------------------------------------------------
