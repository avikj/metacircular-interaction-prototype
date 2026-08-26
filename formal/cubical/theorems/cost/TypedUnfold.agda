{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TypedUnfold
--
-- Denotational unfolding for the unary term calculus, and the strict
-- growth of a cost-bounded language of DENOTATIONS.
--
-- unary constructor is enough.  What `GenerativeLoop` lacks is not
-- syntax but (1) an algebra interpreting heads and bodies, (2) semantic
-- preservation of unfold, and (3) separate invocation/unfolded costs;
-- its root matcher reads only names, so it cannot state this strict
-- denotation result."  That note is answering codex-vajra's boundary
-- collision on ℤ/30 shows that `Tm`/`Vocab`/`deficit` install sector
-- NAMES and not the objects inhabiting them: two signals with the same
-- formal term have different arithmetic answers.  The matrices P, A, D
--
-- This file lands items (1), (2), (3) and the strict denotation result
-- (4), in Cubical Agda, `--safe`, no postulates and no holes.  Nothing
-- from `machinery/` was executed; the Python model was read as a
-- specification and its arithmetic is redone here by proof.
--
-- Substrate: exactly `Obstruction` (`Tm`, `Vocab`,
-- `Over`, `plug`, `unfold`, `unfold-elim`), plus `size` from
-- `WitnessPolicy` and `deficit` from
-- `GenerativeLoop`.  No new term constructor is added —
-- that is the point of the source note.
--
--
-- WHAT IS CHECKED
--
-- U0.  THE ALGEBRA (§§1-2), spec item (1).
--
--   `V3`, `Mat`, `act`     ℤ³ as a record of three integers, 3×3
--                          matrices over ℤ as a record of nine, and the
--                          action `act : Mat → V3 → V3` written out as
--                          three explicit row sums.
--   `act-additive`,
--   `act-homogeneous`,
--   `act-linear`           every `act m` is a ℤ-linear endomorphism of
--                          ℤ³ — proved, so that "endomorphism" is a
--                          checked property and not a name.
--   `Endo`, `_∘E_`, `idE`,
--   `∘E-assoc`, `∘E-idL/R` the endomorphism monoid; its laws are `refl`
--                          (composition of functions), which is exactly
--                          why no matrix product is needed below.
--   `denote-linear`        every term denotes a ℤ-linear endomorphism.
--
-- U1.  THE DENOTATION (§3).
--
--   `Interp = Shape → Endo`, `denote : Interp → Tm → Endo` with
--   `denote I var = idE`, `denote I (node c u) = I c ∘E denote I u`
--   (the head acts last), and `⟦_⟧ : Alg → Tm → Endo` for the bundle
--   `Alg = (vocab , interp)` — the vocabulary gates legality (`Over`),
--   the interpretation carries meaning.
--
-- U2.  SUBSTITUTION IS COMPOSITION (§4).
--
--   `plug-denote`          denote I (plug b u) ≡ denote I b ∘E denote I u.
--                          One induction; the associativity it needs is
--                          `refl`.
--
-- U3.  SEMANTIC PRESERVATION OF UNFOLD (§4), spec item (2).  THE
--      DELIVERABLE.
--
--   `Sound I d b`          := I d ≡ denote I b — the installed head
--                          MEANS the denotation of its body.
--   `unfold-denote`        (I) (d) (b) → Sound I d b → (t : Tm) →
--                          denote I (unfold d b t) ≡ denote I t.
--                          Eliminating an installed definition preserves
--                          denotation, at every term, with no hypothesis
--                          on freshness of `d` or basehood of `b`.
--   `elimination-preserves`
--                          the pair with `Obstruction.unfold-elim`: the
--                          unfolded term is base over V AND denotes the
--                          same endomorphism.  `unfold-elim` alone is
--                          eliminability of a NAME; this is elimination
--                          of a name at constant MEANING.
--   `proposal-preserves-denotation`
--                          the same for a proposal of
--                          `Obstruction.propose`, whenever its witness is
--                          sound.
--
-- U4.  TWO COSTS, SEPARATE FROM `deficit` (§5), spec item (3).
--
--   `invocationCost t`     = `size t`: one unit per head invocation of
--                          the term AS WRITTEN (installed heads cost the
--                          same as base ones).
--   `unfoldedCost d b t`   = `size (unfold d b t)`: the cost after the
--                          definition is eliminated.
--   `unfold-size-unit`     a body of invocation size one leaves every
--                          unfolded cost unchanged (used by the negative
--                          control, U7).
--   `QAP.macro-cost`,
--   `QAP.unfolded-cost-size`,
--   `QAP.cost-strictly-smaller`
--                          on the witnessing example: `D(M(x))` has
--                          invocation cost 2, `D(A(P(x)))` cost 3, and
--                          2 < 3 while the two denote the SAME
--                          endomorphism (`QAP.macroWord-denotes`).
--   `QAP.deficit-blind-to-cost`,
--   `QAP.deficit-blind-to-denotation`
--                          THE SEPARATION, stated: `GenerativeLoop`'s
--                          structural measure is 0 on both terms of the
--                          example while their costs differ, and is
--                          equal on two terms whose denotations differ.
--                          Neither cost is `deficit` and neither is
--                          claimed to be a measure on `Vocab`.
--
-- U5.  THE BOUNDED LANGUAGE (§6), spec item (4).
--
--   `Lang b V I f`         := Σ t. Over V t × size t ≤ b × denote I t ≡ f
--                          — "f is denotable within invocation budget b
--                          over the installed vocabulary V".
--   `lang-mono`            installing a head never loses a denotation.
--   `unit-body-no-growth`  A GENERAL NEGATIVE THEOREM: if the installed
--                          body is sound, base and of invocation size
--                          one, then `Lang n (d ∷ V) I ⊆ Lang n V I` at
--                          EVERY budget n — such an installation cannot
--                          grow the bounded language at all.
--
-- U6.  STRICT GROWTH (§7), the strict denotation result.
--
--   In `module QAP`, with P the projector to e₀, A the map sending
--   e₀,e₁ ↦ e₁, D the map sending e₁ ↦ e₂ (`RESIDUAL_LANGUAGE_GROWTH`),
--   heads `hA hD hP` installed and the macro `hM := A(P(x))` with
--   matrix `matAP`:
--
--   `macro-sound`          `refl`: the macro's matrix acts as the
--                          composite of its body's matrices.  This is the
--                          certificate the source note calls QAP=BC,
--                          checked at this instance.
--   `dap-present-after`    D∘A∘P is denotable at budget 2 over
--                          `hM ∷ baseV` — by `D(M(x))`.
--   `dap-absent-before`    ... and NOT denotable at budget 2 over
--                          `baseV`: an exhaustive analysis of all 13
--                          base terms of invocation size ≤ 2, each
--                          separated from D∘A∘P by evaluation at a basis
--                          vector (twelve at e₀; the near miss D∘A at
--                          e₁).
--   `strict-growth`        the three together: inclusion, a new
--                          inhabitant, and its absence before.
--                          Installing a definition STRICTLY grows the
--                          budget-bounded set of reachable denotations.
--
-- U7.  NEGATIVE CONTROLS (§7).  The growth claim is not vacuous and not
--      automatic:
--
--   `dap-absent-at-budget-1`
--                          the SAME installation fails to make D∘A∘P
--                          reachable at budget 1 — the growth is
--                          budget-relative, exactly as the source note's
--                          "at budget one the next action remains
--                          unreachable".
--   `idle-no-growth`,
--   `idle-dap-absent`      a second definition `hN := P(x)` — fresh,
--                          sound, installed the same way — provably does
--                          NOT grow the language at any budget
--                          (`unit-body-no-growth` at this instance), and
--                          in particular does not make D∘A∘P reachable
--                          at budget 2.
--   `structure-blind-to-growth`
--                          and the two installations are
--                          INDISTINGUISHABLE to the structural machinery:
--                          both heads are fresh in `baseV`, both targets
--                          have the same `deficit`, yet one installation
--                          grows the budget-2 denotation language and the
--                          other provably does not.  This is
--                          codex-vajra's F/G collision restated inside
--                          the formal substrate: the loop installs names,
--                          and names do not determine the objects.
--
--
-- WHAT IS DELIBERATELY NOT CLAIMED
--
--  * NOT claimed: a synthesis procedure for the body.  `bodyM = A(P(x))`
--    and its matrix `matAP` are GIVEN here, and `Sound` is a hypothesis
--    discharged by computation at this one instance.  This is precisely
--    the second boundary of `TYPED_BOUNDED_UNFOLD.md`:
--    `WitnessPolicy.inform` returns the failed match's recorded
--    argument, which is an informative abbreviation but not a procedure
--    producing a generic body from a semantic certificate.  Nothing here
--    derives a body from a residual, and `unfold-denote` is stated with
--    `Sound` as a hypothesis for exactly that reason.
--  * NOT claimed: that the vocabulary carries meaning.  `Interp` is a
--    TOTAL function `Shape → Endo`: every shape has an endomorphism,
--    installed or not.  Installation is adding the name to the
--    vocabulary, and it bites only because `Lang` quantifies over terms
--    with `Over V t` — an uninstalled head's meaning is unreachable, not
--    undefined.  So this file does not repair the boundary note's
--    "`Vocab` carries no payload"; it shows what a separate
--    interpretation buys once one is supplied.
--  * NOT claimed: matrix algebra.  There is no matrix product in this
--    file.  Heads act on ℤ³ and the monoid operation is composition of
--    the induced maps, whose associativity and units are `refl`.
--    `matAP` is a matrix that is CHECKED to act as the composite of
--    `matA` and `matP` (`macro-sound`); it is not computed by a defined
--    multiplication, and no claim is made that the map Mat → Endo is
--    injective or a homomorphism for any product.
--  * NOT claimed: `Lang` is a set.  It is a predicate on `Endo`, and
--    "strictly grows" means: an inclusion of predicates, an inhabitant of
--    the larger one, and a refutation of that inhabitant in the smaller.
--    No extensionality, cardinality or decidability of the language is
--    claimed, and `Endo` has no equality decision procedure here — the
--    absence proof separates by evaluation at named vectors.
--  * NOT claimed: minimality or optimality.  Budget 2 and the vectors
--    e₀, e₁ are chosen; `dap-absent-before` is an exhaustive case
--    analysis over the 13 base terms of size ≤ 2, not an invariant
--    argument, so it does not generalise to other budgets by itself.
--  * NOT claimed: that either cost is a well-founded measure on `Vocab`,
--    or that `deficit` should have seen any of this.  The disclaimer in
--    `GenerativeLoop` ("the progress half and the definitional half never
--    meet") is not repaired here — it is measured:
--    `deficit-blind-to-cost` and `deficit-blind-to-denotation` are the
--    checked statements that the structural measure sees neither cost nor
--    meaning.
--  * NOT claimed: linearity is load-bearing.  `act-linear` is recorded so
--    that "endomorphism of ℤ³" is a theorem rather than a word; none of
--    U2-U7 uses it.
--  * NOT claimed: anything about `runtime/vocabulary/`,
--    `machinery/typed_bounded_unfold.py`, or the ℤ/30 signals F, G.  No
--    Python was run and no measurement is reported; the boundary note is
--    cited for its statement, not its numbers.
--  * Everything inherited from `Obstruction`, `GenerativeLoop` and
--    `WitnessPolicy` stands: single-parameter bodies, matching only at
--    the root, no arity structure in the residual, gates D2-D7
--    unmodelled, "conservative" in the eliminability sense only.
------------------------------------------------------------------------

module TypedUnfold where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc ; injSuc ; snotz ; znots)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; ≤-refl ; ≤-trans ; zero-≤ ; suc-≤-suc ; pred-≤-pred)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; +Assoc ; +Comm ; ·Assoc ; ·Comm ; ·DistR+)
  renaming (_+_ to _+ℤ_ ; _·_ to _·ℤ_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; if_then_else_ ; true≢false ; false≢true ; dichotomyBool)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import ObstructionSubstrate
open Obstruction
open Extension

open import GenerativeLoop using (deficit)
open import WitnessPolicy
  using (size ; plug-size ; unfold-hit ; unfold-miss)

------------------------------------------------------------------------
-- 1.  ℤ³, 3×3 matrices over ℤ, and their action.
--
-- The carrier is small and concrete so that terms COMPUTE: every
-- statement about a named term below is decided by normalisation, and
-- the only library facts used are the ring laws of ℤ.
------------------------------------------------------------------------

record V3 : Type₀ where
  constructor v3
  field
    xc yc zc : ℤ

open V3 public

_+V_ : V3 → V3 → V3
u +V w = v3 (xc u +ℤ xc w) (yc u +ℤ yc w) (zc u +ℤ zc w)

_·V_ : ℤ → V3 → V3
k ·V u = v3 (k ·ℤ xc u) (k ·ℤ yc u) (k ·ℤ zc u)

record Mat : Type₀ where
  constructor mat
  field
    a00 a01 a02 : ℤ
    a10 a11 a12 : ℤ
    a20 a21 a22 : ℤ

open Mat

-- One row of the matrix-vector product, written out.
row : ℤ → ℤ → ℤ → V3 → ℤ
row p q r v = ((p ·ℤ xc v) +ℤ (q ·ℤ yc v)) +ℤ (r ·ℤ zc v)

act : Mat → V3 → V3
act m v = v3 (row (a00 m) (a01 m) (a02 m) v)
             (row (a10 m) (a11 m) (a12 m) v)
             (row (a20 m) (a21 m) (a22 m) v)

------------------------------------------------------------------------
-- 1a.  `act m` is a ℤ-linear endomorphism of ℤ³.
--
-- Recorded so that the word "endomorphism" is a checked property.  None
-- of §§3-7 uses it.
------------------------------------------------------------------------

private
  shuffleℤ : (a b c d : ℤ) → (a +ℤ b) +ℤ (c +ℤ d) ≡ (a +ℤ c) +ℤ (b +ℤ d)
  shuffleℤ a b c d =
      sym (+Assoc a b (c +ℤ d))
    ∙ cong (a +ℤ_) (+Assoc b c d)
    ∙ cong (λ z → a +ℤ (z +ℤ d)) (+Comm b c)
    ∙ cong (a +ℤ_) (sym (+Assoc c b d))
    ∙ +Assoc a c (b +ℤ d)

  swap·ℤ : (p k x : ℤ) → p ·ℤ (k ·ℤ x) ≡ k ·ℤ (p ·ℤ x)
  swap·ℤ p k x = ·Assoc p k x ∙ cong (_·ℤ x) (·Comm p k) ∙ sym (·Assoc k p x)

  row-add : (p q r : ℤ) (u w : V3)
          → row p q r (u +V w) ≡ (row p q r u) +ℤ (row p q r w)
  row-add p q r u w =
      cong₂ _+ℤ_
        (cong₂ _+ℤ_ (·DistR+ p (xc u) (xc w)) (·DistR+ q (yc u) (yc w)))
        (·DistR+ r (zc u) (zc w))
    ∙ cong (_+ℤ ((r ·ℤ zc u) +ℤ (r ·ℤ zc w)))
        (shuffleℤ (p ·ℤ xc u) (p ·ℤ xc w) (q ·ℤ yc u) (q ·ℤ yc w))
    ∙ shuffleℤ ((p ·ℤ xc u) +ℤ (q ·ℤ yc u)) ((p ·ℤ xc w) +ℤ (q ·ℤ yc w))
               (r ·ℤ zc u) (r ·ℤ zc w)

  row-scale : (p q r k : ℤ) (v : V3) → row p q r (k ·V v) ≡ k ·ℤ (row p q r v)
  row-scale p q r k v =
      cong₂ _+ℤ_
        (cong₂ _+ℤ_ (swap·ℤ p k (xc v)) (swap·ℤ q k (yc v)))
        (swap·ℤ r k (zc v))
    ∙ sym ( ·DistR+ k ((p ·ℤ xc v) +ℤ (q ·ℤ yc v)) (r ·ℤ zc v)
          ∙ cong (_+ℤ (k ·ℤ (r ·ℤ zc v))) (·DistR+ k (p ·ℤ xc v) (q ·ℤ yc v)) )

Endo : Type₀
Endo = V3 → V3

isLinear : Endo → Type₀
isLinear f = ((u w : V3) → f (u +V w) ≡ f u +V f w)
           × ((k : ℤ) (v : V3) → f (k ·V v) ≡ k ·V f v)

act-additive : (m : Mat) (u w : V3) → act m (u +V w) ≡ act m u +V act m w
act-additive m u w i =
  v3 (row-add (a00 m) (a01 m) (a02 m) u w i)
     (row-add (a10 m) (a11 m) (a12 m) u w i)
     (row-add (a20 m) (a21 m) (a22 m) u w i)

act-homogeneous : (m : Mat) (k : ℤ) (v : V3) → act m (k ·V v) ≡ k ·V act m v
act-homogeneous m k v i =
  v3 (row-scale (a00 m) (a01 m) (a02 m) k v i)
     (row-scale (a10 m) (a11 m) (a12 m) k v i)
     (row-scale (a20 m) (a21 m) (a22 m) k v i)

act-linear : (m : Mat) → isLinear (act m)
act-linear m = act-additive m , act-homogeneous m

------------------------------------------------------------------------
-- 2.  The endomorphism monoid.
--
-- Composition, not matrix multiplication: associativity and the unit
-- laws are `refl`, which is what makes §4 a one-line induction instead
-- of a ring computation.
------------------------------------------------------------------------

idE : Endo
idE v = v

_∘E_ : Endo → Endo → Endo
(f ∘E g) v = f (g v)

infixr 9 _∘E_

∘E-assoc : (f g h : Endo) → (f ∘E g) ∘E h ≡ f ∘E (g ∘E h)
∘E-assoc f g h = refl

∘E-idL : (f : Endo) → idE ∘E f ≡ f
∘E-idL f = refl

∘E-idR : (f : Endo) → f ∘E idE ≡ f
∘E-idR f = refl

idE-linear : isLinear idE
idE-linear = (λ u w → refl) , (λ k v → refl)

∘E-linear : (f g : Endo) → isLinear f → isLinear g → isLinear (f ∘E g)
∘E-linear f g (fa , fh) (ga , gh) =
    (λ u w → cong f (ga u w) ∙ fa (g u) (g w))
  , (λ k v → cong f (gh k v) ∙ fh k (g v))

------------------------------------------------------------------------
-- 3.  Interpretations and denotation.  Spec item (1).
--
-- An interpretation gives every head an endomorphism; a term denotes the
-- composite, head acting LAST (so `node c u` is "c after u", matching
-- the matrix convention of RESIDUAL_LANGUAGE_GROWTH: the rightmost
-- operator acts first).  An `Alg` bundles the installed vocabulary with
-- the interpretation: the vocabulary decides which terms are legal
-- (`Over`), the interpretation decides what they mean.
------------------------------------------------------------------------

Interp : Type₀
Interp = Shape → Endo

denote : Interp → Tm → Endo
denote I var        = idE
denote I (node c u) = I c ∘E denote I u

record Alg : Type₀ where
  constructor alg
  field
    vocab  : Vocab
    interp : Interp

open Alg

⟦_⟧ : Alg → Tm → Endo
⟦ A ⟧ t = denote (interp A) t

-- Every term denotes a ℤ-linear endomorphism, as soon as the heads do.
denote-linear : (I : Interp) → ((c : Shape) → isLinear (I c))
              → (t : Tm) → isLinear (denote I t)
denote-linear I hI var        = idE-linear
denote-linear I hI (node c u) =
  ∘E-linear (I c) (denote I u) (hI c) (denote-linear I hI u)

------------------------------------------------------------------------
-- 4.  Substitution is composition, and unfolding preserves meaning.
--     Spec item (2) — the deliverable.
------------------------------------------------------------------------

-- U2.  `plug` is composition on the nose.
plug-denote : (I : Interp) (b u : Tm)
            → denote I (plug b u) ≡ denote I b ∘E denote I u
plug-denote I var        u = refl
plug-denote I (node c b) u = cong (I c ∘E_) (plug-denote I b u)

-- The definition is SOUND when the installed head means the denotation
-- of its body.  This is a hypothesis, never derived here: see the
-- header's first "not claimed".
Sound : Interp → Shape → Tm → Type₀
Sound I d b = I d ≡ denote I b

-- U3.  SEMANTIC PRESERVATION OF UNFOLD.  Eliminating an installed
-- definition preserves denotation, at every term.  No freshness
-- hypothesis on `d`, no basehood hypothesis on `b`: soundness is the
-- whole of what is needed, and the proof is the substitution lemma plus
-- the defining equation.
unfold-denote : (I : Interp) (d : Shape) (b : Tm) → Sound I d b
              → (t : Tm) → denote I (unfold d b t) ≡ denote I t
unfold-denote I d b sd var        = refl
unfold-denote I d b sd (node c u) = go (dichotomyBool (eqℕ c d))
  where
  ih : denote I (unfold d b u) ≡ denote I u
  ih = unfold-denote I d b sd u

  go : (eqℕ c d ≡ true) ⊎ (eqℕ c d ≡ false)
     → denote I (unfold d b (node c u)) ≡ denote I (node c u)
  go (inl e) =
      cong (denote I) (unfold-hit d b c u e)
    ∙ plug-denote I b (unfold d b u)
    ∙ cong (_∘E denote I (unfold d b u)) (sym sd)
    ∙ cong (I d ∘E_) ih
    ∙ cong (λ s → I s ∘E denote I u) (sym (eqℕ→≡ c d e))
  go (inr e) =
      cong (denote I) (unfold-miss d b c u e)
    ∙ cong (I c ∘E_) ih

-- U3, paired with `Obstruction.unfold-elim`: the unfolded term is base
-- over the OLD vocabulary and denotes the same endomorphism.  The first
-- component is elimination of a NAME (that is all `unfold-elim` ever
-- said); the second is what makes it elimination at constant MEANING.
elimination-preserves :
  (I : Interp) (V : Vocab) (d : Shape) (b : Tm) → Over V b → Sound I d b
  → (t : Tm) → Over (d ∷ V) t
  → Over V (unfold d b t) × (denote I (unfold d b t) ≡ denote I t)
elimination-preserves I V d b bB sd t tO =
  unfold-elim V d b bB t tO , unfold-denote I d b sd t

-- The same for a proposal of the obstruction-indexed proposer, whenever
-- its witness is sound.  (`Obstruction.propose` supplies the body; it
-- does not supply soundness, and nothing here says it could.)
proposal-preserves-denotation :
  (V : Vocab) (o : Obstruction V) (I : Interp) → Sound I (residual o) (witness o)
  → (t : Tm) → Over (install V (propose V o)) t
  → Over V (unfold (residual o) (witness o) t)
    × (denote I (unfold (residual o) (witness o) t) ≡ denote I t)
proposal-preserves-denotation V o I sd t h =
    propose-eliminable V o t h
  , unfold-denote I (residual o) (witness o) sd t

------------------------------------------------------------------------
-- 5.  Two costs.  Spec item (3).
--
-- `invocationCost` prices the term AS WRITTEN — one unit per head
-- invocation, an installed head costing exactly what a base head costs.
-- `unfoldedCost` prices the same term after the definition is
-- eliminated.  They are different functions, they differ on the
-- witnessing example (§7), and NEITHER is `GenerativeLoop.deficit`,
-- which counts uncovered head positions of a target and is blind to both
-- (`QAP.deficit-blind-to-cost`, `QAP.deficit-blind-to-denotation`).
------------------------------------------------------------------------

invocationCost : Tm → ℕ
invocationCost t = size t

unfoldedCost : Shape → Tm → Tm → ℕ
unfoldedCost d b t = size (unfold d b t)

-- A definition whose body is a single invocation changes no unfolded
-- cost.  This is the engine of the negative control in §7.
unfold-size-unit : (d : Shape) (b : Tm) → size b ≡ 1
                 → (t : Tm) → size (unfold d b t) ≡ size t
unfold-size-unit d b hb var        = refl
unfold-size-unit d b hb (node c u) = go (dichotomyBool (eqℕ c d))
  where
  ih : size (unfold d b u) ≡ size u
  ih = unfold-size-unit d b hb u

  go : (eqℕ c d ≡ true) ⊎ (eqℕ c d ≡ false)
     → size (unfold d b (node c u)) ≡ size (node c u)
  go (inl e) =
      cong size (unfold-hit d b c u e)
    ∙ plug-size b (unfold d b u)
    ∙ cong₂ _+_ hb ih
  go (inr e) =
      cong size (unfold-miss d b c u e)
    ∙ cong suc ih

------------------------------------------------------------------------
-- 6.  The cost-bounded language of denotations.  Spec item (4).
--
--   `Lang b V I f`  —  f is the denotation of some term legal over V
--                      whose invocation cost is at most b.
--
-- It is a PREDICATE on `Endo`, not a set (see "not claimed").
------------------------------------------------------------------------

Lang : ℕ → Vocab → Interp → Endo → Type₀
Lang b V I f = Σ[ t ∈ Tm ] (Over V t × (size t ≤ b) × (denote I t ≡ f))

-- Installing a head never loses a denotation.
lang-mono : (b : ℕ) (V : Vocab) (s : Shape) (I : Interp) (f : Endo)
          → Lang b V I f → Lang b (s ∷ V) I f
lang-mono b V s I f (t , ov , sz , dn) = t , Over-mono V s t ov , sz , dn

-- THE GENERAL NEGATIVE THEOREM.  A sound, base body of invocation size
-- one buys nothing at any budget: its unfolding is a legal term of the
-- old vocabulary, of the same cost, with the same denotation.  So an
-- installation strictly grows the bounded language only if its body is
-- worth more than one invocation — which is exactly the content of the
-- positive result in §7, and the reason the control there is not a
-- coincidence.
unit-body-no-growth :
  (I : Interp) (V : Vocab) (d : Shape) (b : Tm)
  → Over V b → Sound I d b → size b ≡ 1
  → (n : ℕ) (f : Endo) → Lang n (d ∷ V) I f → Lang n V I f
unit-body-no-growth I V d b bB sd hb n f (t , ov , sz , dn) =
    unfold d b t
  , unfold-elim V d b bB t ov
  , subst (_≤ n) (sym (unfold-size-unit d b hb t)) sz
  , unfold-denote I d b sd t ∙ dn

private
  ¬<zero : (n : ℕ) → ¬ (n < 0)
  ¬<zero n (k , p) = snotz (sym (+-suc k n) ∙ p)

  ¬3≤2 : (n : ℕ) → ¬ (suc (suc (suc n)) ≤ 2)
  ¬3≤2 n h = ¬<zero n (pred-≤-pred (pred-≤-pred h))

  ¬2≤1 : (n : ℕ) → ¬ (suc (suc n) ≤ 1)
  ¬2≤1 n h = ¬<zero n (pred-≤-pred h)

------------------------------------------------------------------------
-- 7.  THE STRICT DENOTATION RESULT, and its controls.
--
--
--   P  projects to e₀            matP
--   A  sends e₀, e₁ ↦ e₁         matA
--   D  sends e₁ ↦ e₂             matD
--   M  the compiled macro AP     matAP,  installed as  M(x) := A(P(x))
--   N  a second definition       matP,   installed as  N(x) := P(x)
--
-- The target denotation is D∘A∘P.  Before installing M it is not
-- denotable within invocation budget two; after, it is, by `D(M(x))`.
-- N is the control: fresh, sound, installed identically, and provably
-- without effect on the language at any budget.
------------------------------------------------------------------------

module QAP where

  hA hD hP hM hN : Shape
  hA = 0
  hD = 1
  hP = 2
  hM = 3
  hN = 4

  z0 z1 : ℤ
  z0 = pos 0
  z1 = pos 1

  matP matA matD matAP : Mat
  matP  = mat z1 z0 z0
              z0 z0 z0
              z0 z0 z0
  matA  = mat z0 z0 z0
              z1 z1 z0
              z0 z0 z0
  matD  = mat z0 z0 z0
              z0 z0 z0
              z0 z1 z0
  matAP = mat z0 z0 z0
              z1 z0 z0
              z0 z0 z0

  -- The interpretation is TOTAL (see "not claimed"): shapes past hN
  -- denote the identity, installed or not.
  Iq : Interp
  Iq zero                                  = act matA
  Iq (suc zero)                            = act matD
  Iq (suc (suc zero))                      = act matP
  Iq (suc (suc (suc zero)))                = act matAP
  Iq (suc (suc (suc (suc zero))))          = act matP
  Iq (suc (suc (suc (suc (suc n)))))       = idE

  baseV vocabM vocabN : Vocab
  baseV  = hA ∷ hD ∷ hP ∷ []
  vocabM = hM ∷ baseV
  vocabN = hN ∷ baseV

  bodyM bodyN : Tm
  bodyM = node hA (node hP var)     -- M(x) := A(P(x))
  bodyN = node hP var               -- N(x) := P(x)

  bodyM-base : Over baseV bodyM
  bodyM-base = refl , refl , tt

  bodyN-base : Over baseV bodyN
  bodyN-base = refl , tt

  -- THE CERTIFICATE.  The macro's matrix acts as the composite of the
  -- matrices of its body: `matAP` is AP, on the nose, as an
  -- endomorphism of ℤ³.  This discharges `Sound` at this instance — and
  -- it is the only place where the body's semantics enters.
  macro-sound : Sound Iq hM bodyM
  macro-sound = refl

  idle-sound : Sound Iq hN bodyN
  idle-sound = refl

  idle-size : size bodyN ≡ 1
  idle-size = refl

  -- The target: D∘A∘P, as the denotation of the primitive word.
  dapWord : Tm
  dapWord = node hD (node hA (node hP var))

  dap : Endo
  dap = denote Iq dapWord

  -- The macro invocation: D(M(x)).
  macroWord : Tm
  macroWord = node hD (node hM var)

  macroWord-base : Over vocabM macroWord
  macroWord-base = refl , refl , tt

  -- Same denotation, by the certificate (this is `unfold-denote`'s
  -- conclusion at this term, and it also computes directly).
  macroWord-denotes : denote Iq macroWord ≡ dap
  macroWord-denotes = refl

  ------------------------------------------------------------------
  -- 7a.  The two costs on the witnessing example.  Spec item (3).
  ------------------------------------------------------------------

  macro-unfolds : unfold hM bodyM macroWord ≡ dapWord
  macro-unfolds = refl

  macro-cost : invocationCost macroWord ≡ 2
  macro-cost = refl

  unfolded-cost-size : unfoldedCost hM bodyM macroWord ≡ 3
  unfolded-cost-size = refl

  cost-strictly-smaller : invocationCost macroWord < unfoldedCost hM bodyM macroWord
  cost-strictly-smaller = ≤-refl

  -- The two costs differ; the denotations do not.  This is the whole of
  -- "installing a definition buys shortening, not new operators".
  cost-drops-meaning-fixed :
      (invocationCost macroWord < unfoldedCost hM bodyM macroWord)
    × (denote Iq macroWord ≡ denote Iq (unfold hM bodyM macroWord))
  cost-drops-meaning-fixed =
    cost-strictly-smaller , sym (unfold-denote Iq hM bodyM macro-sound macroWord)

  ------------------------------------------------------------------
  -- 7b.  Both costs are separate from `GenerativeLoop.deficit`.
  ------------------------------------------------------------------

  private
    ¬2≡3 : ¬ (2 ≡ 3)
    ¬2≡3 p = znots (injSuc (injSuc p))

  -- `deficit` is 0 on both terms of the example — it cannot see that one
  -- costs 2 and the other 3.
  deficit-blind-to-cost :
      (deficit vocabM macroWord ≡ 0)
    × (deficit vocabM dapWord ≡ 0)
    × (¬ (invocationCost macroWord ≡ invocationCost dapWord))
  deficit-blind-to-cost = refl , refl , ¬2≡3

  ------------------------------------------------------------------
  -- 7c.  Separating denotations: evaluation at basis vectors.
  ------------------------------------------------------------------

  e0 e1 : V3
  e0 = v3 (pos 1) (pos 0) (pos 0)
  e1 = v3 (pos 0) (pos 1) (pos 0)

  private
    isOne : ℤ → Bool
    isOne (pos zero)          = false
    isOne (pos (suc zero))    = true
    isOne (pos (suc (suc n))) = false
    isOne (negsuc n)          = false

    0≢1 : ¬ (pos 0 ≡ pos 1)
    0≢1 p = false≢true (cong isOne p)

    1≢0 : ¬ (pos 1 ≡ pos 0)
    1≢0 p = true≢false (cong isOne p)

  dap-at-e0 : zc (dap e0) ≡ pos 1
  dap-at-e0 = refl

  dap-at-e1 : zc (dap e1) ≡ pos 0
  dap-at-e1 = refl

  -- An endomorphism killing the third coordinate of e₀ is not D∘A∘P.
  sepE0 : (f : Endo) → zc (f e0) ≡ pos 0 → ¬ (f ≡ dap)
  sepE0 f q p = 0≢1 (sym q ∙ cong (λ g → zc (g e0)) p ∙ dap-at-e0)

  -- ... and one that does NOT kill the third coordinate of e₁ is not
  -- D∘A∘P either.  (Needed exactly once, at the near miss D∘A.)
  sepE1 : (f : Endo) → zc (f e1) ≡ pos 1 → ¬ (f ≡ dap)
  sepE1 f q p = 1≢0 (sym q ∙ cong (λ g → zc (g e1)) p ∙ dap-at-e1)

  ------------------------------------------------------------------
  -- 7d.  ABSENCE at budget two, before installation.
  --
  -- Exhaustive: the base terms of invocation size ≤ 2 are var, the
  -- three one-head terms and the nine two-head terms.  Twelve of the
  -- thirteen are separated from D∘A∘P at e₀; the thirteenth, D∘A, agrees
  -- with it there and is separated at e₁.  Heads outside `baseV` are
  -- refuted by the coverage hypothesis, which computes to `false ≡ true`.
  ------------------------------------------------------------------

  private
    lvl1 : (c : Shape) → memb c baseV ≡ true → ¬ (denote Iq (node c var) ≡ dap)
    lvl1 zero                  _ = sepE0 _ refl              -- A
    lvl1 (suc zero)            _ = sepE0 _ refl              -- D
    lvl1 (suc (suc zero))      _ = sepE0 _ refl              -- P
    lvl1 (suc (suc (suc n)))   h = Empty.rec (false≢true h)

    lvl2 : (c c' : Shape) → memb c baseV ≡ true → memb c' baseV ≡ true
         → ¬ (denote Iq (node c (node c' var)) ≡ dap)
    lvl2 zero zero                       _ _ = sepE0 _ refl  -- A A
    lvl2 zero (suc zero)                 _ _ = sepE0 _ refl  -- A D
    lvl2 zero (suc (suc zero))           _ _ = sepE0 _ refl  -- A P
    lvl2 zero (suc (suc (suc n)))        _ h = Empty.rec (false≢true h)
    lvl2 (suc zero) zero                 _ _ = sepE1 _ refl  -- D A  (near miss)
    lvl2 (suc zero) (suc zero)           _ _ = sepE0 _ refl  -- D D
    lvl2 (suc zero) (suc (suc zero))     _ _ = sepE0 _ refl  -- D P
    lvl2 (suc zero) (suc (suc (suc n)))  _ h = Empty.rec (false≢true h)
    lvl2 (suc (suc zero)) zero           _ _ = sepE0 _ refl  -- P A
    lvl2 (suc (suc zero)) (suc zero)     _ _ = sepE0 _ refl  -- P D
    lvl2 (suc (suc zero)) (suc (suc zero)) _ _ = sepE0 _ refl -- P P
    lvl2 (suc (suc zero)) (suc (suc (suc n))) _ h = Empty.rec (false≢true h)
    lvl2 (suc (suc (suc n))) c'          h _ = Empty.rec (false≢true h)

    no-dap : (t : Tm) → Over baseV t → size t ≤ 2 → ¬ (denote Iq t ≡ dap)
    no-dap var _ _ = sepE0 _ refl
    no-dap (node c var) (hc , _) _ = lvl1 c hc
    no-dap (node c (node c' var)) (hc , hc' , _) _ = lvl2 c c' hc hc'
    no-dap (node c (node c' (node c'' u))) _ sz _ = Empty.rec (¬3≤2 (size u) sz)

  dap-absent-before : ¬ (Lang 2 baseV Iq dap)
  dap-absent-before (t , ov , sz , dn) = no-dap t ov sz dn

  dap-present-after : Lang 2 vocabM Iq dap
  dap-present-after = macroWord , macroWord-base , ≤-refl , macroWord-denotes

  -- THE STRICT DENOTATION RESULT.  Installing M(x) := A(P(x)) strictly
  -- grows the set of denotations reachable within invocation budget two:
  -- nothing is lost, D∘A∘P is gained, and it was provably not there
  -- before.
  strict-growth :
      ((f : Endo) → Lang 2 baseV Iq f → Lang 2 vocabM Iq f)
    × (Lang 2 vocabM Iq dap)
    × (¬ (Lang 2 baseV Iq dap))
  strict-growth =
      (λ f → lang-mono 2 baseV hM Iq f)
    , dap-present-after
    , dap-absent-before

  ------------------------------------------------------------------
  -- 7e.  NEGATIVE CONTROL 1: the same installation at budget one.
  --
  -- Growth is budget-relative.  With M installed, D∘A∘P is still not
  -- reachable at budget one — the macro invocation `D(M(x))` costs two.
  ------------------------------------------------------------------

  private
    lvl1M : (c : Shape) → memb c vocabM ≡ true → ¬ (denote Iq (node c var) ≡ dap)
    lvl1M zero                          _ = sepE0 _ refl     -- A
    lvl1M (suc zero)                    _ = sepE0 _ refl     -- D
    lvl1M (suc (suc zero))              _ = sepE0 _ refl     -- P
    lvl1M (suc (suc (suc zero)))        _ = sepE0 _ refl     -- M
    lvl1M (suc (suc (suc (suc n))))     h = Empty.rec (false≢true h)

    no-dap-1 : (t : Tm) → Over vocabM t → size t ≤ 1 → ¬ (denote Iq t ≡ dap)
    no-dap-1 var _ _ = sepE0 _ refl
    no-dap-1 (node c var) (hc , _) _ = lvl1M c hc
    no-dap-1 (node c (node c' u)) _ sz _ = Empty.rec (¬2≤1 (size u) sz)

  dap-absent-at-budget-1 : ¬ (Lang 1 vocabM Iq dap)
  dap-absent-at-budget-1 (t , ov , sz , dn) = no-dap-1 t ov sz dn

  ------------------------------------------------------------------
  -- 7f.  NEGATIVE CONTROL 2: an installation that grows nothing.
  --
  -- N(x) := P(x) is fresh, sound and installed exactly as M was; its
  -- body costs one invocation, so by `unit-body-no-growth` it changes
  -- the language at NO budget.  In particular it does not make D∘A∘P
  -- reachable at budget two.
  ------------------------------------------------------------------

  idle-no-growth : (n : ℕ) (f : Endo) → Lang n vocabN Iq f → Lang n baseV Iq f
  idle-no-growth = unit-body-no-growth Iq baseV hN bodyN bodyN-base idle-sound idle-size

  idle-language-unchanged :
    (n : ℕ) (f : Endo)
    → (Lang n vocabN Iq f → Lang n baseV Iq f) × (Lang n baseV Iq f → Lang n vocabN Iq f)
  idle-language-unchanged n f = idle-no-growth n f , lang-mono n baseV hN Iq f

  idle-dap-absent : ¬ (Lang 2 vocabN Iq dap)
  idle-dap-absent h = dap-absent-before (idle-no-growth 2 dap h)

  ------------------------------------------------------------------
  -- 7g.  What the structural machinery sees of the difference: nothing.
  --
  -- Both heads are fresh in `baseV`; both single-head targets have the
  -- same `deficit`; one installation grows the budget-two denotation
  -- language and the other provably does not.  This is codex-vajra's F/G
  -- collision inside the formal substrate — the loop installs names, and
  -- the name does not determine the object.
  ------------------------------------------------------------------

  structure-blind-to-growth :
      (memb hM baseV ≡ false)
    × (memb hN baseV ≡ false)
    × (deficit baseV (node hM var) ≡ deficit baseV (node hN var))
    × (Lang 2 vocabM Iq dap)
    × (¬ (Lang 2 vocabN Iq dap))
  structure-blind-to-growth =
    refl , refl , refl , dap-present-after , idle-dap-absent

  -- ... and `deficit` cannot see meaning either: two targets it scores
  -- identically (both covered, both of cost one) with different
  -- denotations.
  private
    A≢D : ¬ (denote Iq (node hA var) ≡ denote Iq (node hD var))
    A≢D p = 1≢0 (cong (λ g → yc (g e1)) p)

  deficit-blind-to-denotation :
      (deficit baseV (node hA var) ≡ deficit baseV (node hD var))
    × (invocationCost (node hA var) ≡ invocationCost (node hD var))
    × (¬ (denote Iq (node hA var) ≡ denote Iq (node hD var)))
  deficit-blind-to-denotation = refl , refl , A≢D
