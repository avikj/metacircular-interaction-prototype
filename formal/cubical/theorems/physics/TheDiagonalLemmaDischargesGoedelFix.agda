{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheDiagonalLemmaDischargesGoedelFix where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
open import GodelSeparation
  using ( Theory ; Sent ; Pf ; neg ; prov
        ; Consistent ; HBL1 ; GoedelFix ; OmegaBad ; goedelHalfOne )
open import IndependenceNeedsAnInternalImplication
  using (Independent)

------------------------------------------------------------------------
-- TheDiagonalLemmaDischargesGoedelFix
--
-- Closing the gap the previous module named: `GodelSeparation` takes
-- `GoedelFix` as a hypothesis and says, at that definition, that
-- obtaining it "needs the representability of prov, which is a
-- hypothesis about T".  Representability had never been written down.
-- This writes it down and discharges the hypothesis with it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT `Theory` HAS AND WHAT THE DIAGONAL LEMMA NEEDS
--
-- `Theory` carries `Sent`, `Pf`, `neg`, `prov`.  `prov : Sent → Sent`
-- is already "the formula applied at a code", so what is missing for a
-- diagonal lemma is (i) one-place formulas as a type, (ii) their
-- application to a sentence, and (iii) the fixed point itself.  §1
-- states all three, and states the fixed point as a PAIR of `Pf` of
-- implications rather than as a biconditional, because `Theory` has no
-- conjunction and inventing one would be adding structure the corpus
-- does not have.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  `HasDiagonal`: one-place formulas, application, and a fixed
--       point for each, in the corpus's own vocabulary plus the `imp`
--       and `mp` isolated at `c22194ab`.
--
--   §2  the diagonal lemma at the formula `¬ prov(−)` DISCHARGES
--       `GoedelFix`.  Two applications of modus ponens; no consistency,
--       no HBL1, no ω-consistency.  So the first of `GodelSeparation`'s
--       three hypotheses is not a hypothesis about the ambient
--       structure at all — it is representability, and this is the
--       term.
--
--   §3  what it still does NOT give: the second conjunct.  Getting
--       `Pf (imp (neg G) (prov G))` from the diagonal pair needs
--       contraposition AND double-negation elimination AND transitivity
--       INSIDE the theory.  §3 assumes exactly those three and derives
--       it, so the distance is measured rather than described.
--
--   §4  and then independence, from §2, §3 and ω-consistency.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ANSWER, SHARPENED FROM LAST CYCLE
--
-- At `c22194ab` the answer to "which lane" on this route was: a
-- connective former, not a theory object.  §3 sharpens it.  What the
-- lane needs is a PROPOSITIONAL FRAGMENT INTERNAL TO THE THEORY —
-- `imp`, `mp`, contraposition, double-negation elimination,
-- transitivity.  Stated exactly, since the careless version is wrong:
-- the FIRST conjunct needs `imp` and `mp` (they discharge `GoedelFix`
-- in §2) and needs NONE of contraposition, double-negation elimination
-- or transitivity; the SECOND needs all five, plus ω-consistency.  The asymmetry
-- between the two conjuncts, which `noHalfTwo` exhibits with a
-- countermodel, is exactly this fragment.
--
-- Internal double-negation elimination is a classicality assumption
-- about T.  It is named as such and not smuggled: a theory without it
-- does not get §3, and this file says nothing about whether that is a
-- defect of such a theory.
--
-- ────────────────────────────────────────────────────────────────────
-- NOT CLAIMED
--
-- That any actual theory satisfies `HasDiagonal` — that is Gödel's
-- arithmetisation and is not formalised here or anywhere in this corpus
-- that I could find.  That the five internal rules are independent of
-- each other, or minimal: they are what this proof uses, and a shorter
-- route may exist.  That `Pf` models a proof predicate.  §2 and §3 are
-- statements about the record, not about arithmetic.
--
-- PRIOR ART, by grepping the conclusion type: `GoedelFix` appears in
-- `GodelSeparation` only, always as a hypothesis (`goedelHalfOne`,
-- `noHalfTwo`, `witFix`); a grep of `formal/cubical` for
-- `Representab`, `representab` and `Diagonal` outside
-- `LawvereDiagonal` returns nothing, and `LawvereDiagonal` is
-- `Bool`-valued — the Cantor/Tarski side, with no `Sent`.  A diagonal
-- lemma phrased over a coding function rather than a formula type
-- would evade that grep.
------------------------------------------------------------------------

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  Representability, as the structure the diagonal lemma needs
------------------------------------------------------------------------

record HasDiagonal (T : Theory ℓ) : Type (ℓ-suc ℓ) where
  field
    imp  : Sent T → Sent T → Sent T
    mp   : (a b : Sent T) → Pf T (imp a b) → Pf T a → Pf T b
    Form : Type ℓ
    app  : Form → Sent T → Sent T
    -- the fixed point, as the two implications T proves.  No
    -- conjunction is used: `Theory` has none.
    fix  : (φ : Form)
         → Σ[ G ∈ Sent T ]
             (Pf T (imp G (app φ G)) × Pf T (imp (app φ G) G))
    -- the one formula Gödel's argument needs, and that it IS `¬ prov`.
    negProv    : Form
    negProv-is : (s : Sent T) → app negProv s ≡ neg T (prov T s)

open HasDiagonal public

------------------------------------------------------------------------
-- 2.  The diagonal lemma discharges GoedelFix
------------------------------------------------------------------------

module _ (T : Theory ℓ) (D : HasDiagonal T) where

  goedelSentence : Sent T
  goedelSentence = fst (fix D (negProv D))

  private
    fwdPf : Pf T (imp D goedelSentence (app D (negProv D) goedelSentence))
    fwdPf = fst (snd (fix D (negProv D)))

    bwdPf : Pf T (imp D (app D (negProv D) goedelSentence) goedelSentence)
    bwdPf = snd (snd (fix D (negProv D)))

  diagonalGivesGoedelFix : GoedelFix T goedelSentence
  diagonalGivesGoedelFix =
      (λ pG → subst (Pf T) (negProv-is D goedelSentence)
                (mp D goedelSentence _ fwdPf pG))
    , (λ pNP → mp D _ goedelSentence bwdPf
                (subst (Pf T) (sym (negProv-is D goedelSentence)) pNP))

------------------------------------------------------------------------
-- 3.  The second conjunct needs three more internal rules
--
-- From `Pf (imp (neg (prov G)) G)` — the backward half of the diagonal
-- pair — contraposition gives `Pf (imp (neg G) (neg (neg (prov G))))`,
-- internal double-negation elimination gives
-- `Pf (imp (neg (neg (prov G))) (prov G))`, and transitivity composes
-- them.  Each is assumed by name.
------------------------------------------------------------------------

module _ (T : Theory ℓ) (D : HasDiagonal T)
         (contra : (a b : Sent T)
                 → Pf T (imp D a b) → Pf T (imp D (neg T b) (neg T a)))
         (dne    : (a : Sent T) → Pf T (imp D (neg T (neg T a)) a))
         (trans  : (a b c : Sent T)
                 → Pf T (imp D a b) → Pf T (imp D b c) → Pf T (imp D a c))
         where

  private
    G : Sent T
    G = goedelSentence T D

    bwd : Pf T (imp D (app D (negProv D) G) G)
    bwd = snd (snd (fix D (negProv D)))

    bwd' : Pf T (imp D (neg T (prov T G)) G)
    bwd' = subst (λ s → Pf T (imp D s G)) (negProv-is D G) bwd

  internalFix : Pf T (imp D (neg T G) (prov T G))
  internalFix =
    trans (neg T G) (neg T (neg T (prov T G))) (prov T G)
      (contra (neg T (prov T G)) G bwd')
      (dne (prov T G))

  secondConjunct :
      (¬ Pf T G) → (¬ OmegaBad T G) → ¬ Pf T (neg T G)
  secondConjunct notG notOmega pNegG =
    notOmega (mp D (neg T G) (prov T G) internalFix pNegG , notG)

------------------------------------------------------------------------
-- 4.  Independence, assembled
------------------------------------------------------------------------

  independenceFromRepresentability :
      Consistent T → HBL1 T → (¬ OmegaBad T G) → Independent T G
  independenceFromRepresentability con d1 notOmega =
      goedelHalfOne T G con d1 (diagonalGivesGoedelFix T D)
    , secondConjunct
        (goedelHalfOne T G con d1 (diagonalGivesGoedelFix T D))
        notOmega
