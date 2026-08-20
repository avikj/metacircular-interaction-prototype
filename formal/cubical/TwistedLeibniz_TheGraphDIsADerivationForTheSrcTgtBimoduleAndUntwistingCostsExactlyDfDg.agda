{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TwistedLeibniz_TheGraphDIsADerivationForTheSrcTgtBimoduleAndUntwistingCostsExactlyDfDg
--
-- WHY THIS FILE HAS NO SANSKRIT NAME.  CLAUDE.md's file-naming rule, note
-- 2: where the mathematics genuinely originates elsewhere, say so in the
-- header rather than invent a Sanskrit label, because a fabricated term
-- asserts a provenance nobody checked.  `cf-tessera-i-0` did the search
-- and reported the negative in
-- `KirchhoffIncidence_GraphLaplacianIsDivGradAndSummationByPartsIsExact`
-- and in message 2151: the Śulba-sūtras, the Jaina *Anuyogadvāra* and
-- *Sthānāṅga*, and Piṅgala with Halāyudha contain no signed incidence
-- structure and no difference-of-endpoints operator, and the
-- *meru-prastāra*'s rule is a summation along a DAG, not a signed
-- difference across an edge — "the sign is the whole difference".  The
-- object below is that sign, multiplied.  It is not Indian and it is not
-- given an Indian name here.
--
-- PROVENANCE, with text and date:
--
--   * G. Kirchhoff, Ann. Phys. Chem. 72 (1847) 497–508, for the operator
--     `d` itself — the signed difference across an edge, i.e. the
--     incidence matrix.  Established in the module this one imports.
--
--   * A. Dimakis and F. Müller-Hoissen, "Discrete differential calculus:
--     graphs, topologies, and gauge theory", J. Math. Phys. 35 (1994)
--     6703–6735.  This is where the graph `d` is given a *bimodule* of
--     1-forms with left and right actions of the function algebra
--     evaluated at the two ends of an edge, and a Leibniz rule for that
--     bimodule.  Everything in §1 below is their structure; nothing here
--     is new mathematics.  The claim is only that it is now a checked
--     term in this repository instead of an assertion in a header.
--
--   * S. L. Woronowicz, "Differential calculus on compact matrix
--     pseudogroups (quantum groups)", Comm. Math. Phys. 122 (1989)
--     125–170, is the general axiomatization: a first-order differential
--     calculus over an algebra A *is* an A-bimodule Ω¹ together with a
--     derivation d : A → Ω¹.  I could not reach a copy from this
--     container (egress is blocked here, as `cf-tessera-i-0` also
--     recorded), so the volume and page range are from memory and are
--     the one unverified thing in this header; the attribution of the
--     idea is not in doubt, the pagination is.
--
-- WHAT IS CHECKED, over an arbitrary commutative ring and an arbitrary
-- finite directed multigraph, reusing `Graph`'s own `grad`, `div`, `B`,
-- `src`, `tgt` rather than redefining them:
--
--   §1  `leibniz-twisted`      d(fg)(e) = df(e)·g(tgt e) + f(src e)·dg(e)
--       `leibniz-twisted-mirror`  ...   = df(e)·g(src e) + f(tgt e)·dg(e)
--       `leibniz-bimodule`     the same, as an equation of 1-cochains,
--                              d(fg) = (df ▹ g) +₁ (f ◃ dg), with the
--                              twist absorbed into the two actions
--       `◃-assoc`, `▹-assoc`, `◃▹-commute`, `◃-unit`, `▹-unit`
--                              — the bimodule axioms, so that the word
--                              "bimodule" is a theorem and not a label
--       `untwist-src-defect`   d(fg) = (df·g∘src + f∘src·dg) + df·dg
--       `untwist-tgt-defect`   d(fg) = (df·g∘tgt + f∘tgt·dg) − df·dg
--       `action-commutator`    (ω ▹ f) −₁ (f ◃ ω) = ω ·₁ df
--       `div-+`, `div-−`, `div-commutator`
--       `weak-leibniz`         the summed product rule for div
--
--   §2  the four concrete refutations over ℤ on two vertices, one edge.
--
-- WHAT IS REFUTED, and the first of these is the point of the file:
--
--   1. **The statement as it was actually written is false.**  Message
--      2151 line 146, and `notes/DISCRETE_CALCULUS_FOURTEEN_TOPICS_…`
--      §5.2, both assert
--          d(fg)(e) = (df)(e)·f(tgt e) + f(src e)·(dg)(e)
--      with an `f` in the first factor where a `g` belongs.  With `f`
--      there it is refuted by `header-leibniz-is-false` below: take the
--      one-edge graph, f = (0,1), g = 0, and the two sides are 0 and 1.
--      It is a typographical slip and not a mathematical error — the
--      rule with `g` is `leibniz-twisted` and holds — but it was
--      asserted in that form twice, and a statement asserted twice and
--      checked nowhere is exactly what this repository is for.  Its
--      author flagged it unprompted as the smallest genuinely absent
--      object left; the credit for the item is theirs.
--
--   2. **My own claim, formed and killed.**  I formed it as soon as I saw
--      the two actions: the coefficient ring is *commutative*, C⁰ is a
--      commutative algebra, so a *bi*module is bookkeeping and `f ◃ ω`
--      must equal `ω ▹ f`.  False — `actions-differ`.  The actions do not
--      agree, they differ by exactly `ω ·₁ df` (`action-commutator`),
--      and that is a statement about the *graph*, not about the ring:
--      commutativity of the coefficients is irrelevant, because the two
--      actions evaluate the same function at two different vertices.
--      This is the same failure of symmetry as the sign in `B`, one
--      level up.
--
--   3. `div` is neither a left nor a right module map for those actions
--      (`div-not-left-module-map`, `div-not-right-module-map`), which is
--      the negative half of the answer to "does δ obey a product rule".
--
-- WHAT IS NOT SETTLED: whether `div` obeys *no* pointwise product rule.
-- Two named candidates are refuted; "no rule of any shape" is not a
-- statement I can quantify over inside Agda, and the honest form of the
-- observation is a type-level one, recorded in the rigor boundary.
--
-- CHECKED: Agda 2.6.3, cubical library v0.5 — this container, not the
-- repository pin.  --cubical --safe, no postulates, no holes, EXIT 0.
-- One warning, of the same benign kind `cf-tessera-i-0` documented: none
-- here, because §2 uses the Kronecker delta instead of a match on
-- `FinData.Fin` to write down a non-constant vertex function.
--
-- Author: cf-tessera-n-0, 2026-08-20.
-- Item, and the disclosure that made it an item: cf-tessera-i-0.
------------------------------------------------------------------------

module TwistedLeibniz_TheGraphDIsADerivationForTheSrcTgtBimoduleAndUntwistingCostsExactlyDfDg where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.FinData using (Fin ; zero ; suc)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Algebra.CommRing.Base
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve)

open import KirchhoffIncidence_GraphLaplacianIsDivGradAndSummationByPartsIsExact
  using (module Graph)

private variable ℓ : Level

------------------------------------------------------------------------
-- 1.  The first-order differential calculus of a finite directed
--     multigraph, over an arbitrary commutative ring.
--
--     `Graph` supplies C⁰, C¹, B, grad, div, by-parts and the sum
--     lemmas.  Nothing from it is redefined here.
------------------------------------------------------------------------

module Calculus (R' : CommRing ℓ) (n m : ℕ) (src tgt : Fin m → Fin n) where
  open Graph R' n m src tgt public
  private R = fst R'

  ----------------------------------------------------------------------
  -- 1.0  Pointwise algebra, and the two actions
  --
  --   C⁰ is a commutative ring under pointwise operations — vertices do
  --   not interact.  C¹ likewise.  The interesting structure is the pair
  --   of actions of C⁰ on C¹: a vertex function may be read at the tail
  --   of an edge or at its head, and those are different operations even
  --   though the ring is commutative.
  ----------------------------------------------------------------------

  infixl 7 _·₀_ _·₁_
  infixl 6 _+₁_ _−₁_
  infixr 7 _◃_
  infixl 7 _▹_

  _·₀_ : C⁰ → C⁰ → C⁰
  (f ·₀ g) v = f v · g v

  _·₁_ : C¹ → C¹ → C¹
  (ω ·₁ η) e = ω e · η e

  _+₁_ : C¹ → C¹ → C¹
  (ω +₁ η) e = ω e + η e

  _−₁_ : C¹ → C¹ → C¹
  (ω −₁ η) e = ω e − η e

  -- left action: read the vertex function at the TAIL of the edge
  _◃_ : C⁰ → C¹ → C¹
  (f ◃ ω) e = f (src e) · ω e

  -- right action: read it at the HEAD
  _▹_ : C¹ → C⁰ → C¹
  (ω ▹ g) e = ω e · g (tgt e)

  one⁰ : C⁰
  one⁰ _ = 1r

  ----------------------------------------------------------------------
  -- 1.1  Five identities in a commutative ring
  --
  --   Read a = f(tgt e), b = f(src e), c = g(tgt e), d = g(src e).  Then
  --   d(fg)(e) is a·c − b·d and df(e) is a − b, dg(e) is c − d.  Every
  --   theorem in §1.2 and §1.3 is one of these, instantiated.
  ----------------------------------------------------------------------

  private
    keyTgt : (a b c d : R) → (a · c) − (b · d) ≡ ((a − b) · c) + (b · (c − d))
    keyTgt = solve R'

    keySrc : (a b c d : R) → (a · c) − (b · d) ≡ ((a − b) · d) + (a · (c − d))
    keySrc = solve R'

    keyUntwistSrc : (a b c d : R)
      → (a · c) − (b · d)
      ≡ (((a − b) · d) + (b · (c − d))) + ((a − b) · (c − d))
    keyUntwistSrc = solve R'

    keyUntwistTgt : (a b c d : R)
      → (a · c) − (b · d)
      ≡ (((a − b) · c) + (a · (c − d))) − ((a − b) · (c − d))
    keyUntwistTgt = solve R'

    keyComm : (w a b : R) → (w · a) − (b · w) ≡ w · (a − b)
    keyComm = solve R'

    keySplit : (p c q r w : R)
      → ((p · c) + (q · r)) · w ≡ (p · (w · c)) + (r · (q · w))
    keySplit = solve R'

  ----------------------------------------------------------------------
  -- THEOREM 1.  The twisted Leibniz rule.  `d` is a derivation once each
  -- factor is read at the correct end of the edge: the differentiated
  -- factor's partner is read at the head in the first term and at the
  -- tail in the second.
  --
  --   d(fg)(e) = df(e)·g(tgt e) + f(src e)·dg(e)
  --
  -- This is the statement cf-tessera-i-0 asserted and did not check,
  -- with the `f` of that assertion corrected to a `g`.
  ----------------------------------------------------------------------

  leibniz-twisted : (f g : C⁰) (e : Fin m)
    → grad (f ·₀ g) e ≡ grad f e · g (tgt e) + f (src e) · grad g e
  leibniz-twisted f g e = keyTgt (f (tgt e)) (f (src e)) (g (tgt e)) (g (src e))

  ----------------------------------------------------------------------
  -- THEOREM 1′.  And the mirror twist holds too — read the partner at
  -- the tail in the first term and at the head in the second.  Both
  -- twists are exact; what is NOT exact is reading both at the same end
  -- (Theorem 3).  So the twist is not a choice between a right rule and
  -- a wrong one; it is the requirement that the two factors be read at
  -- OPPOSITE ends.
  ----------------------------------------------------------------------

  leibniz-twisted-mirror : (f g : C⁰) (e : Fin m)
    → grad (f ·₀ g) e ≡ grad f e · g (src e) + f (tgt e) · grad g e
  leibniz-twisted-mirror f g e =
    keySrc (f (tgt e)) (f (src e)) (g (tgt e)) (g (src e))

  ----------------------------------------------------------------------
  -- THEOREM 2.  The bimodule form.  With the two actions in place the
  -- rule loses its twist and becomes the ordinary Leibniz rule
  --
  --   d(fg) = (df) ▹ g  +  f ◃ (dg)
  --
  -- as an equation of 1-cochains.  This is the content of the twist:
  -- it is not a deformation of Leibniz, it is Leibniz for a bimodule
  -- whose two actions differ.  §1.4 shows they do differ.
  ----------------------------------------------------------------------

  leibniz-bimodule : (f g : C⁰) → grad (f ·₀ g) ≡ (grad f ▹ g) +₁ (f ◃ grad g)
  leibniz-bimodule f g = funExt (leibniz-twisted f g)

  ----------------------------------------------------------------------
  -- 1.2  The bimodule axioms, so that "bimodule" is a theorem.
  ----------------------------------------------------------------------

  ◃-assoc : (f g : C⁰) (ω : C¹) → (f ·₀ g) ◃ ω ≡ f ◃ (g ◃ ω)
  ◃-assoc f g ω = funExt (λ e → sym (·Assoc (f (src e)) (g (src e)) (ω e)))

  ▹-assoc : (ω : C¹) (f g : C⁰) → ω ▹ (f ·₀ g) ≡ (ω ▹ f) ▹ g
  ▹-assoc ω f g = funExt (λ e → ·Assoc (ω e) (f (tgt e)) (g (tgt e)))

  ◃▹-commute : (f : C⁰) (ω : C¹) (g : C⁰) → (f ◃ ω) ▹ g ≡ f ◃ (ω ▹ g)
  ◃▹-commute f ω g =
    funExt (λ e → sym (·Assoc (f (src e)) (ω e) (g (tgt e))))

  ◃-unit : (ω : C¹) → one⁰ ◃ ω ≡ ω
  ◃-unit ω = funExt (λ e → ·IdL (ω e))

  ▹-unit : (ω : C¹) → ω ▹ one⁰ ≡ ω
  ▹-unit ω = funExt (λ e → ·IdR (ω e))

  ----------------------------------------------------------------------
  -- THEOREM 3.  What untwisting costs, exactly.
  --
  --   Reading BOTH factors at the tail undershoots by df·dg; reading
  --   both at the head overshoots by df·dg.  The defect is the same
  --   quantity in both cases and it is the discrete second-order term —
  --   the product of the two differences, which is the thing continuous
  --   calculus discards as o(h) and a graph cannot, because an edge has
  --   no small parameter.
  ----------------------------------------------------------------------

  untwist-src-defect : (f g : C⁰) (e : Fin m)
    → grad (f ·₀ g) e
    ≡ (grad f e · g (src e) + f (src e) · grad g e) + grad f e · grad g e
  untwist-src-defect f g e =
    keyUntwistSrc (f (tgt e)) (f (src e)) (g (tgt e)) (g (src e))

  untwist-tgt-defect : (f g : C⁰) (e : Fin m)
    → grad (f ·₀ g) e
    ≡ (grad f e · g (tgt e) + f (tgt e) · grad g e) − grad f e · grad g e
  untwist-tgt-defect f g e =
    keyUntwistTgt (f (tgt e)) (f (src e)) (g (tgt e)) (g (src e))

  ----------------------------------------------------------------------
  -- THEOREM 4.  The two actions differ by exactly `ω ·₁ df`.
  --
  --   This is why the bimodule is not a module, over a commutative ring
  --   and with a commutative C⁰.  The obstruction to symmetry is not
  --   noncommutativity of the coefficients; it is that an edge has two
  --   ends.  Setting d = 0 (a graph all of whose edges are loops, or a
  --   constant f) collapses it.
  ----------------------------------------------------------------------

  action-commutator : (f : C⁰) (ω : C¹) → (ω ▹ f) −₁ (f ◃ ω) ≡ ω ·₁ grad f
  action-commutator f ω =
    funExt (λ e → keyComm (ω e) (f (tgt e)) (f (src e)))

  ----------------------------------------------------------------------
  -- 1.3  `div` is additive.  Needed below and true for the dull reason.
  ----------------------------------------------------------------------

  div-+ : (ω η : C¹) (v : Fin n) → div (ω +₁ η) v ≡ div ω v + div η v
  div-+ ω η v =
      ∑Ext (λ e → ·DistR+ (B v e) (ω e) (η e))
    ∙ ∑Split (λ e → B v e · ω e) (λ e → B v e · η e)

  div-− : (ω η : C¹) (v : Fin n) → div (ω −₁ η) v ≡ div ω v − div η v
  div-− ω η v =
      ∑Ext (λ e → ·DistR+ (B v e) (ω e) (- η e))
    ∙ ∑Split (λ e → B v e · ω e) (λ e → B v e · (- η e))
    ∙ cong (div ω v +_)
        (∑Ext (λ e → -DistR· (B v e) (η e)) ∙ ∑Dist- (λ e → B v e · η e))

  ----------------------------------------------------------------------
  -- THEOREM 5.  The only "product rule" `div` has pointwise is the image
  -- under `div` of Theorem 4:
  --
  --   div(ω ▹ f) − div(f ◃ ω) = div(ω ·₁ df).
  --
  -- Stated so that what it is can be seen: it is `div-−` composed with
  -- `action-commutator`, i.e. LINEARITY of div applied to a fact about
  -- d.  `div` contributes nothing to it.  That is the honest content —
  -- the asymmetry between d and δ is that d has a Leibniz rule of its
  -- own and δ has only the ones it inherits.
  ----------------------------------------------------------------------

  div-commutator : (f : C⁰) (ω : C¹) (v : Fin n)
    → div (ω ▹ f) v − div (f ◃ ω) v ≡ div (ω ·₁ grad f) v
  div-commutator f ω v =
      sym (div-− (ω ▹ f) (f ◃ ω) v)
    ∙ cong (λ σ → div σ v) (action-commutator f ω)

  ----------------------------------------------------------------------
  -- THEOREM 6.  The weak product rule for `div`, under the pairing.
  --
  --   ∑_v (fg)(v)·div ω(v) = ∑_v f(v)·div(ω ▹ g)(v) + ∑_v g(v)·div(f ◃ ω)(v)
  --
  -- `div` obeys no pointwise Leibniz rule (§2 refutes the two candidates
  -- that typecheck), but it obeys this one, and this one is exactly
  -- cf-tessera-i-0's `by-parts` conjugating Theorem 1.  The twist that
  -- was pointwise on the d side becomes, on the div side, the choice of
  -- WHICH ACTION each factor is moved through: g goes through ▹, f goes
  -- through ◃.  The sign survives the product only by being split
  -- between the two ends, and under the sum it survives as a choice of
  -- action rather than as a correction term.
  ----------------------------------------------------------------------

  weak-leibniz : (f g : C⁰) (ω : C¹)
    → ∑ (λ v → (f ·₀ g) v · div ω v)
    ≡ ∑ (λ v → f v · div (ω ▹ g) v) + ∑ (λ v → g v · div (f ◃ ω) v)
  weak-leibniz f g ω =
      sym (by-parts (f ·₀ g) ω)
    ∙ ∑Ext (λ e → cong (_· ω e) (leibniz-twisted f g e))
    ∙ ∑Ext (λ e → keySplit (grad f e) (g (tgt e)) (f (src e)) (grad g e) (ω e))
    ∙ ∑Split (λ e → grad f e · (ω ▹ g) e) (λ e → grad g e · (f ◃ ω) e)
    ∙ cong₂ _+_ (by-parts f (ω ▹ g)) (by-parts g (f ◃ ω))

------------------------------------------------------------------------
-- 2.  Two vertices, one edge, over ℤ: the refutations.
--
--   The smallest graph on which `src` and `tgt` differ.  Every claim
--   below is settled by computation on the vertex function φ = (0,1),
--   which is written as a column of the Kronecker delta rather than by a
--   match on `Fin 2`, so that nothing in this file warns.
------------------------------------------------------------------------

module OneEdge where
  u0 u1 : Fin 2
  u0 = zero
  u1 = suc zero

  s1 t1 : Fin 1 → Fin 2
  s1 _ = u0
  t1 _ = u1

  open Calculus ℤCommRing 2 1 s1 t1

  e0 : Fin 1
  e0 = zero

  -- φ u0 = 0, φ u1 = 1
  φ : C⁰
  φ v = δ v u1

  zero⁰ : C⁰
  zero⁰ _ = pos 0

  one¹ : C¹
  one¹ _ = pos 1

  private
    is1 : ℤ → Bool
    is1 (pos ℕ.zero)                    = false
    is1 (pos (ℕ.suc ℕ.zero))            = true
    is1 (pos (ℕ.suc (ℕ.suc _)))         = false
    is1 (negsuc _)                      = false

    isNeg : ℤ → Bool
    isNeg (pos _)    = false
    isNeg (negsuc _) = true

  ----------------------------------------------------------------------
  -- 2.1  THE HEADER'S VERSION IS FALSE AS WRITTEN.
  --
  --   Message 2151 and notes/DISCRETE_CALCULUS_FOURTEEN_TOPICS_… assert
  --       d(fg)(e) = (df)(e)·f(tgt e) + f(src e)·(dg)(e),
  --   with `f` where `g` belongs.  Take f = φ = (0,1) and g = 0.  Then
  --   fg = 0 so the left side is 0, while the right side is
  --   (1−0)·1 + 0·0 = 1.
  ----------------------------------------------------------------------

  HeaderLeibniz : Type₀
  HeaderLeibniz = (f g : C⁰) (e : Fin 1)
    → grad (f ·₀ g) e ≡ grad f e · f (t1 e) + f (s1 e) · grad g e

  header-leibniz-is-false : ¬ HeaderLeibniz
  header-leibniz-is-false h = true≢false (cong is1 (sym (h φ zero⁰ e0)))

  -- and the corrected statement holds on the same graph, by the general
  -- theorem, so the slip really is only a slip
  corrected-holds : grad (φ ·₀ zero⁰) e0
                  ≡ grad φ e0 · zero⁰ (t1 e0) + φ (s1 e0) · grad zero⁰ e0
  corrected-holds = leibniz-twisted φ zero⁰ e0

  ----------------------------------------------------------------------
  -- 2.2  IS THE TWIST NECESSARY?  Yes.  Both untwisted rules fail on
  --   this graph, with f = g = φ:  d(φ²)(e) = 1·1 − 0·0 = 1, while
  --   reading both factors at the tail gives 1·0 + 0·1 = 0 and reading
  --   both at the head gives 1·1 + 1·1 = 2.  The defect is 1 = df·dg in
  --   both directions, as Theorem 3 says it must be.
  ----------------------------------------------------------------------

  UntwistedSrc : Type₀
  UntwistedSrc = (f g : C⁰) (e : Fin 1)
    → grad (f ·₀ g) e ≡ grad f e · g (s1 e) + f (s1 e) · grad g e

  untwisted-src-is-false : ¬ UntwistedSrc
  untwisted-src-is-false h = true≢false (cong is1 (h φ φ e0))

  UntwistedTgt : Type₀
  UntwistedTgt = (f g : C⁰) (e : Fin 1)
    → grad (f ·₀ g) e ≡ grad f e · g (t1 e) + f (t1 e) · grad g e

  untwisted-tgt-is-false : ¬ UntwistedTgt
  untwisted-tgt-is-false h = true≢false (cong is1 (h φ φ e0))

  ----------------------------------------------------------------------
  -- 2.3  MY OWN CLAIM, AND ITS DEATH.
  --
  --   Claim, formed on first reading the two actions and believed long
  --   enough to start writing §1 without `▹`: the coefficient ring is
  --   commutative and C⁰ is a commutative algebra, so the left and right
  --   actions must agree and one of them is redundant.
  --
  --   False.  φ ◃ 1 reads φ at the tail and gets 0; 1 ▹ φ reads it at
  --   the head and gets 1.  Commutativity of the ring is not the
  --   relevant symmetry — the two actions apply the SAME element of the
  --   ring in the same order, and differ only in which vertex it was
  --   read at.  A bimodule over a commutative algebra is not
  --   automatically symmetric when the two actions factor through
  --   different algebra maps, and here they factor through φ ↦ φ∘src and
  --   φ ↦ φ∘tgt.
  ----------------------------------------------------------------------

  ActionsAgree : Type₀
  ActionsAgree = (f : C⁰) (ω : C¹) → f ◃ ω ≡ ω ▹ f

  actions-differ : ¬ ActionsAgree
  actions-differ h =
    true≢false (cong is1 (sym (cong (λ σ → σ e0) (h φ one¹))))

  -- what is true instead, on this graph, by the general theorem
  commutator-here : (one¹ ▹ φ) −₁ (φ ◃ one¹) ≡ one¹ ·₁ grad φ
  commutator-here = action-commutator φ one¹

  ----------------------------------------------------------------------
  -- 2.4  DOES `div` OBEY A PRODUCT RULE?  Not pointwise.
  --
  --   The two candidates that even typecheck say `div` is a module map
  --   for one of the actions.  Both are false on one edge.
  --
  --   ◃: with f = φ and ω = 1, (φ ◃ 1) is 0 on the only edge, so
  --   div(φ ◃ 1) is 0 at both vertices, while φ(u1)·div 1(u1) = 1·1 = 1.
  --
  --   ▹: with ω = 1 and f = φ, (1 ▹ φ) is 1, so div(1 ▹ φ)(u0) = −1,
  --   while φ(u0)·div 1(u0) = 0·(−1) = 0.
  ----------------------------------------------------------------------

  DivIsLeftModuleMap : Type₀
  DivIsLeftModuleMap = (f : C⁰) (ω : C¹) (v : Fin 2)
    → div (f ◃ ω) v ≡ f v · div ω v

  div-not-left-module-map : ¬ DivIsLeftModuleMap
  div-not-left-module-map h =
    true≢false (cong is1 (sym (h φ one¹ u1)))

  DivIsRightModuleMap : Type₀
  DivIsRightModuleMap = (ω : C¹) (f : C⁰) (v : Fin 2)
    → div (ω ▹ f) v ≡ f v · div ω v

  div-not-right-module-map : ¬ DivIsRightModuleMap
  div-not-right-module-map h =
    true≢false (cong isNeg (h one¹ φ u0))

  -- and the weak rule that survives, on this graph, by Theorem 6
  weak-holds-here : ∑ (λ v → (φ ·₀ φ) v · div one¹ v)
                  ≡ ∑ (λ v → φ v · div (one¹ ▹ φ) v)
                  + ∑ (λ v → φ v · div (φ ◃ one¹) v)
  weak-holds-here = weak-leibniz φ φ one¹

------------------------------------------------------------------------
-- Rigor boundary.
--
-- Checked generically, over any commutative ring and any finite directed
-- multigraph, with no connectivity, simplicity or loop-freeness
-- hypothesis: the two twisted Leibniz rules; the bimodule form and the
-- five bimodule axioms; the exact defect ±df·dg of the two untwisted
-- rules; the commutator of the actions; additivity of div; the
-- commutator identity for div; the weak (summed) product rule for div.
--
-- Checked concretely over ℤ on two vertices and one edge: the header's
-- version of the rule is false; both untwisted rules are false; the two
-- actions differ; div is neither a left nor a right module map.
--
-- NOT claimed, and this is the real limit of the file:
--
--   * That `div` obeys no pointwise product rule *at all*.  Two named
--     candidates are refuted.  The general statement is not a theorem I
--     can write, and the reason is a type-level one worth recording
--     plainly rather than dressing up: a Leibniz rule for div would have
--     to build a 0-cochain out of two 1-cochains, and the only ways this
--     calculus offers to do that are `div` of an edge-product and a
--     product of two divergences.  `d` has a Leibniz rule because C¹ is
--     a bimodule over C⁰; C⁰ is not, in any way this calculus supplies,
--     a module over C¹.  The asymmetry is that the arrow C⁰ → C¹ lands
--     in something with an action of its source and the arrow C¹ → C⁰
--     does not.  That is an observation about the available types, not a
--     proof of impossibility, and it is stated here as the former.
--
--   * Anything about d² or higher degrees.  A graph has no 2-cochains
--     here, so the question of whether the twisted rule is compatible
--     with d² = 0 does not arise in this file and is not answered by it.
--
--   * Any relation to the LQG holonomy Leibniz witness in
--     notes/LQG_HOLONOMY_REFINEMENT_SEAM.md.  That one is a group-valued
--     refinement rule and the resemblance is unexamined.  SEARCH.
------------------------------------------------------------------------
