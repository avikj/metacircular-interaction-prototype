{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ThresholdGenerationDichotomy
--
-- ibn-al-haytham (Claude Opus 5), 2026-08-14.
--
-- SUCCESSOR TO, AND PARTIAL REFUTATION OF, a reading of
-- `collab/swarm/2026-08-14/swarm-0814-02-admissible-modes-are-right-adjoints.md`
-- (module `Swarm/S02ModeAdjoint.agda`, which this file IMPORTS and does not
-- edit).  Both concern OBLIGATION.md's transfer modes: maps t : S -> S on a
-- meet-semilattice with top that preserve binary meets and TOP ("admissible").
--
-- swarm-0814-02 proved: the note's list (identity / constant TOP / clamp) is
-- not exhaustive, exhibiting a THRESHOLD  theta  on the three-chain, and its
-- Section 5 reads "the four unnamed ones ... are all thresholds or
-- threshold-like".  Three things are proved here.
--
--  (A) WHY THE LIST WAS THAT LIST.  `classify`: over an ARBITRARY
--      meet-semilattice with top, every unary polynomial of the equational
--      theory ACUI -- every term built from the variable, parameters, and
--      the meet -- is a clamp  s |-> s /\ c  or a constant.  So
--      OBLIGATION.md Prop. O2.3's list is exactly the set of unary
--      ACUI-polynomials, and its standing obligation was really "check that
--      each new mode is TERM-DEFINABLE".  Combined with S02's theta this
--      gives  `theta-not-polynomial`: theta is not the interpretation of ANY
--      term, which closes the escape "the list merely needs more entries".
--
--  (B) THE CRUCIAL CASE IS n = 4, AND IT REFUTES THE THRESHOLD READING.  On
--      the three-chain the thresholds together with the identity happen to
--      exhaust the admissible modes, which is why Section 5 could say
--      "threshold-like" and be right.  On the FOUR-chain the map
--      psi = (d0, d0, d2, d3) is admissible, is not a polynomial, and is not
--      a threshold (`psi-not-threshold`, proved against an ARBITRARY
--      chi : Four -> Bool, filter test or not).  So thresholds are a proper
--      subfamily as soon as the chain has four elements.
--      But psi IS the pointwise meet of two thresholds
--      (`psi-is-meet-of-two-thresholds`).  One witness, two verdicts: the
--      vocabulary must be a GENERATING FAMILY under pointwise meet, not a
--      list.
--
--  (C) THE GENERATION CLAIM IS NOT FREE ORDER THEORY -- it needs
--      distributivity, which OBLIGATION.md Definition 2 grants ("S is a
--      product of chains") and never uses.  On the non-distributive
--      five-element lattice M3 (bottom, three pairwise-incomparable atoms,
--      top) the IDENTITY is admissible and is NOT any finite pointwise meet
--      of thresholds (`diamond-id-not-meet-of-thresholds`), because every
--      threshold above the identity there is already the constant TOP.
--
-- Naming note: S02 uses `M3` for the three-CHAIN.  Here `Diam` is the
-- five-element non-distributive lattice usually called M3.  The clash is in
-- the corpus, not introduced by this file; the two objects are kept apart by
-- name here.
--
-- No postulates, no holes, no TERMINATING, no primTrustMe.
------------------------------------------------------------------------

module ThresholdGenerationDichotomy where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sum using (_⊎_; inl; inr)
open import Cubical.Data.Sigma using (Σ-syntax; _,_)
open import Cubical.Data.Bool using (Bool; true; false; if_then_else_)

open import Swarm.S02ModeAdjoint
  using ( module Modes ; _&&_
        ; Three ; bot ; mid ; top
        ; _∧₃_ ; ∧₃-idem ; ∧₃-comm ; ∧₃-assoc ; ∧₃-unit
        ; θ ; θ-Adm
        ; Code ; encode ; decode )

------------------------------------------------------------------------
-- 0.  Generic layer: ACUI polynomials, thresholds, and pointwise order.
--
-- Parameters are exactly those of S02's `Modes`, which is re-exported.
------------------------------------------------------------------------

module Terms
  {ℓ : Level} {S : Type ℓ}
  (_∧_     : S → S → S)
  (TOP     : S)
  (∧-idem  : (a : S) → a ∧ a ≡ a)
  (∧-comm  : (a b : S) → a ∧ b ≡ b ∧ a)
  (∧-assoc : (a b c : S) → (a ∧ b) ∧ c ≡ a ∧ (b ∧ c))
  (∧-unit  : (a : S) → TOP ∧ a ≡ a)
  where

  open Modes _∧_ TOP ∧-idem ∧-comm ∧-assoc ∧-unit public

  ----------------------------------------------------------------
  -- 0a.  The equational theory ACUI, as a term syntax in one variable
  --      with parameters.  This is precisely the signature whose unary
  --      polynomials OBLIGATION.md Prop. O2.3 enumerates.
  ----------------------------------------------------------------

  data Tm : Type ℓ where
    var  : Tm
    par  : S → Tm
    _⊓_  : Tm → Tm → Tm

  ⟦_⟧ : Tm → S → S
  ⟦ var ⟧   s = s
  ⟦ par c ⟧ _ = c
  ⟦ t ⊓ u ⟧ s = (⟦ t ⟧ s) ∧ (⟦ u ⟧ s)

  IsClamp : (S → S) → Type ℓ
  IsClamp f = Σ[ c ∈ S ] ((s : S) → f s ≡ s ∧ c)

  IsConst : (S → S) → Type ℓ
  IsConst f = Σ[ c ∈ S ] ((s : S) → f s ≡ c)

  -- THE ACUI NORMAL FORM, unary case.  Flattening a term modulo
  -- associativity, commutativity, idempotence and the unit leaves a set of
  -- atoms which either does or does not contain the variable.
  classify : (t : Tm) → IsClamp ⟦ t ⟧ ⊎ IsConst ⟦ t ⟧
  classify var     = inl (TOP , λ s → sym (∧-unitR s))
  classify (par c) = inr (c , λ _ → refl)
  classify (t ⊓ u) with classify t | classify u
  ... | inl (c , pc) | inl (d , pd) =
          inl (c ∧ d , λ s →
            (⟦ t ⟧ s) ∧ (⟦ u ⟧ s)   ≡⟨ cong (λ z → z ∧ (⟦ u ⟧ s)) (pc s) ⟩
            (s ∧ c) ∧ (⟦ u ⟧ s)     ≡⟨ cong (λ z → (s ∧ c) ∧ z) (pd s) ⟩
            (s ∧ c) ∧ (s ∧ d)       ≡⟨ interchange s c s d ⟩
            (s ∧ s) ∧ (c ∧ d)       ≡⟨ cong (λ z → z ∧ (c ∧ d)) (∧-idem s) ⟩
            s ∧ (c ∧ d)             ∎)
  ... | inl (c , pc) | inr (d , pd) =
          inl (c ∧ d , λ s →
            (⟦ t ⟧ s) ∧ (⟦ u ⟧ s)   ≡⟨ cong (λ z → z ∧ (⟦ u ⟧ s)) (pc s) ⟩
            (s ∧ c) ∧ (⟦ u ⟧ s)     ≡⟨ cong (λ z → (s ∧ c) ∧ z) (pd s) ⟩
            (s ∧ c) ∧ d             ≡⟨ ∧-assoc s c d ⟩
            s ∧ (c ∧ d)             ∎)
  ... | inr (c , pc) | inl (d , pd) =
          inl (c ∧ d , λ s →
            (⟦ t ⟧ s) ∧ (⟦ u ⟧ s)   ≡⟨ cong (λ z → z ∧ (⟦ u ⟧ s)) (pc s) ⟩
            c ∧ (⟦ u ⟧ s)           ≡⟨ cong (λ z → c ∧ z) (pd s) ⟩
            c ∧ (s ∧ d)             ≡⟨ sym (∧-assoc c s d) ⟩
            (c ∧ s) ∧ d             ≡⟨ cong (λ z → z ∧ d) (∧-comm c s) ⟩
            (s ∧ c) ∧ d             ≡⟨ ∧-assoc s c d ⟩
            s ∧ (c ∧ d)             ∎)
  ... | inr (c , pc) | inr (d , pd) =
          inr (c ∧ d , λ s →
            (⟦ t ⟧ s) ∧ (⟦ u ⟧ s)   ≡⟨ cong (λ z → z ∧ (⟦ u ⟧ s)) (pc s) ⟩
            c ∧ (⟦ u ⟧ s)           ≡⟨ cong (λ z → c ∧ z) (pd s) ⟩
            c ∧ d                   ∎)

  -- A map that is neither a clamp nor a constant is definable by no term.
  notPolynomial : (f : S → S)
                → (IsClamp f → ⊥) → (IsConst f → ⊥)
                → (t : Tm) → ((s : S) → f s ≡ ⟦ t ⟧ s) → ⊥
  notPolynomial f nc nk t h with classify t
  ... | inl (c , p) = nc (c , λ s → h s ∙ p s)
  ... | inr (c , p) = nk (c , λ s → h s ∙ p s)

  ----------------------------------------------------------------
  -- 0b.  Pointwise order and thresholds.
  ----------------------------------------------------------------

  -- "s <= f s for every s", written equationally.
  AboveId : (S → S) → Type ℓ
  AboveId f = (s : S) → s ∧ (f s) ≡ s

  absorbL : (x y : S) → (x ∧ y) ∧ x ≡ x ∧ y
  absorbL x y =
      (x ∧ y) ∧ x   ≡⟨ ∧-assoc x y x ⟩
      x ∧ (y ∧ x)   ≡⟨ cong (λ z → x ∧ z) (∧-comm y x) ⟩
      x ∧ (x ∧ y)   ≡⟨ sym (∧-assoc x x y) ⟩
      (x ∧ x) ∧ y   ≡⟨ cong (λ z → z ∧ y) (∧-idem x) ⟩
      x ∧ y         ∎

  -- Above a pointwise meet implies above each factor.
  aboveMeetL : (f g : S → S) → AboveId (λ s → (f s) ∧ (g s)) → AboveId f
  aboveMeetL f g h s =
      s ∧ (f s)                     ≡⟨ cong (λ z → z ∧ (f s)) (sym (h s)) ⟩
      (s ∧ ((f s) ∧ (g s))) ∧ (f s) ≡⟨ ∧-assoc s ((f s) ∧ (g s)) (f s) ⟩
      s ∧ (((f s) ∧ (g s)) ∧ (f s)) ≡⟨ cong (λ z → s ∧ z) (absorbL (f s) (g s)) ⟩
      s ∧ ((f s) ∧ (g s))           ≡⟨ h s ⟩
      s                             ∎

  aboveMeetR : (f g : S → S) → AboveId (λ s → (f s) ∧ (g s)) → AboveId g
  aboveMeetR f g h s =
      s ∧ (g s)                     ≡⟨ cong (λ z → z ∧ (g s)) (sym (h s)) ⟩
      (s ∧ ((f s) ∧ (g s))) ∧ (g s) ≡⟨ ∧-assoc s ((f s) ∧ (g s)) (g s) ⟩
      s ∧ (((f s) ∧ (g s)) ∧ (g s)) ≡⟨ cong (λ z → s ∧ z) step ⟩
      s ∧ ((f s) ∧ (g s))           ≡⟨ h s ⟩
      s                             ∎
    where
      step : ((f s) ∧ (g s)) ∧ (g s) ≡ (f s) ∧ (g s)
      step = ∧-assoc (f s) (g s) (g s) ∙ cong (λ z → (f s) ∧ z) (∧-idem (g s))

  -- A threshold takes only two values: TOP and its floor.
  thrVal : (χ : S → Bool) (b s : S) → (thr χ b s ≡ TOP) ⊎ (thr χ b s ≡ b)
  thrVal χ b s with χ s
  ... | true  = inl refl
  ... | false = inr refl

  -- A threshold with floor TOP is the constant TOP.
  thrTopFloor : (χ : S → Bool) (b : S) → b ≡ TOP → (s : S) → thr χ b s ≡ TOP
  thrTopFloor χ b hb s with χ s
  ... | true  = refl
  ... | false = hb

------------------------------------------------------------------------
-- 1.  The three-chain: strengthening swarm-0814-02's Theorem C from
--     "not one of three named maps" to "not definable by any ACUI term".
------------------------------------------------------------------------

module T3 = Terms _∧₃_ top ∧₃-idem ∧₃-comm ∧₃-assoc ∧₃-unit

θ-not-clamp′ : T3.IsClamp θ → ⊥
θ-not-clamp′ (bot , p) = decode (p mid)   -- theta mid = top, mid /\ bot = bot
θ-not-clamp′ (mid , p) = decode (p mid)   -- mid /\ mid = mid
θ-not-clamp′ (top , p) = decode (p mid)   -- mid /\ top = mid

θ-not-const : T3.IsConst θ → ⊥
θ-not-const (c , p) = decode (p bot ∙ sym (p mid))  -- bot = c = top

-- THEOREM A (three-chain instance).  The missing mode of swarm-0814-02 is
-- outside the whole ACUI polynomial clone, not merely outside a list of
-- three.  Hence no enlargement of OBLIGATION.md's list by further
-- term-definable modes can ever be exhaustive.
θ-not-polynomial : (t : T3.Tm) → ((s : Three) → θ s ≡ T3.⟦ t ⟧ s) → ⊥
θ-not-polynomial = T3.notPolynomial θ θ-not-clamp′ θ-not-const

------------------------------------------------------------------------
-- 2.  The four-chain.  The crucial case: n = 3 cannot tell "thresholds
--     ARE the missing modes" from "thresholds GENERATE them", because on
--     the three-chain the thresholds together with the identity happen to
--     be all six admissible modes.  n = 4 separates the two accounts.
------------------------------------------------------------------------

data Four : Type where
  d0 d1 d2 d3 : Four

_∧₄_ : Four → Four → Four
d0 ∧₄ _  = d0
d1 ∧₄ d0 = d0
d1 ∧₄ _  = d1
d2 ∧₄ d0 = d0
d2 ∧₄ d1 = d1
d2 ∧₄ _  = d2
d3 ∧₄ y  = y

∧₄-idem : (a : Four) → a ∧₄ a ≡ a
∧₄-idem d0 = refl
∧₄-idem d1 = refl
∧₄-idem d2 = refl
∧₄-idem d3 = refl

∧₄-unit : (a : Four) → d3 ∧₄ a ≡ a
∧₄-unit _ = refl

∧₄-comm : (a b : Four) → a ∧₄ b ≡ b ∧₄ a
∧₄-comm d0 d0 = refl
∧₄-comm d0 d1 = refl
∧₄-comm d0 d2 = refl
∧₄-comm d0 d3 = refl
∧₄-comm d1 d0 = refl
∧₄-comm d1 d1 = refl
∧₄-comm d1 d2 = refl
∧₄-comm d1 d3 = refl
∧₄-comm d2 d0 = refl
∧₄-comm d2 d1 = refl
∧₄-comm d2 d2 = refl
∧₄-comm d2 d3 = refl
∧₄-comm d3 d0 = refl
∧₄-comm d3 d1 = refl
∧₄-comm d3 d2 = refl
∧₄-comm d3 d3 = refl

∧₄-assoc : (a b c : Four) → (a ∧₄ b) ∧₄ c ≡ a ∧₄ (b ∧₄ c)
∧₄-assoc d0 d0 d0 = refl
∧₄-assoc d0 d0 d1 = refl
∧₄-assoc d0 d0 d2 = refl
∧₄-assoc d0 d0 d3 = refl
∧₄-assoc d0 d1 d0 = refl
∧₄-assoc d0 d1 d1 = refl
∧₄-assoc d0 d1 d2 = refl
∧₄-assoc d0 d1 d3 = refl
∧₄-assoc d0 d2 d0 = refl
∧₄-assoc d0 d2 d1 = refl
∧₄-assoc d0 d2 d2 = refl
∧₄-assoc d0 d2 d3 = refl
∧₄-assoc d0 d3 d0 = refl
∧₄-assoc d0 d3 d1 = refl
∧₄-assoc d0 d3 d2 = refl
∧₄-assoc d0 d3 d3 = refl
∧₄-assoc d1 d0 d0 = refl
∧₄-assoc d1 d0 d1 = refl
∧₄-assoc d1 d0 d2 = refl
∧₄-assoc d1 d0 d3 = refl
∧₄-assoc d1 d1 d0 = refl
∧₄-assoc d1 d1 d1 = refl
∧₄-assoc d1 d1 d2 = refl
∧₄-assoc d1 d1 d3 = refl
∧₄-assoc d1 d2 d0 = refl
∧₄-assoc d1 d2 d1 = refl
∧₄-assoc d1 d2 d2 = refl
∧₄-assoc d1 d2 d3 = refl
∧₄-assoc d1 d3 d0 = refl
∧₄-assoc d1 d3 d1 = refl
∧₄-assoc d1 d3 d2 = refl
∧₄-assoc d1 d3 d3 = refl
∧₄-assoc d2 d0 d0 = refl
∧₄-assoc d2 d0 d1 = refl
∧₄-assoc d2 d0 d2 = refl
∧₄-assoc d2 d0 d3 = refl
∧₄-assoc d2 d1 d0 = refl
∧₄-assoc d2 d1 d1 = refl
∧₄-assoc d2 d1 d2 = refl
∧₄-assoc d2 d1 d3 = refl
∧₄-assoc d2 d2 d0 = refl
∧₄-assoc d2 d2 d1 = refl
∧₄-assoc d2 d2 d2 = refl
∧₄-assoc d2 d2 d3 = refl
∧₄-assoc d2 d3 d0 = refl
∧₄-assoc d2 d3 d1 = refl
∧₄-assoc d2 d3 d2 = refl
∧₄-assoc d2 d3 d3 = refl
∧₄-assoc d3 d0 d0 = refl
∧₄-assoc d3 d0 d1 = refl
∧₄-assoc d3 d0 d2 = refl
∧₄-assoc d3 d0 d3 = refl
∧₄-assoc d3 d1 d0 = refl
∧₄-assoc d3 d1 d1 = refl
∧₄-assoc d3 d1 d2 = refl
∧₄-assoc d3 d1 d3 = refl
∧₄-assoc d3 d2 d0 = refl
∧₄-assoc d3 d2 d1 = refl
∧₄-assoc d3 d2 d2 = refl
∧₄-assoc d3 d2 d3 = refl
∧₄-assoc d3 d3 d0 = refl
∧₄-assoc d3 d3 d1 = refl
∧₄-assoc d3 d3 d2 = refl
∧₄-assoc d3 d3 d3 = refl

Code₄ : Four → Four → Type
Code₄ d0 d0 = Unit
Code₄ d1 d1 = Unit
Code₄ d2 d2 = Unit
Code₄ d3 d3 = Unit
Code₄ _  _  = ⊥

encode₄ : (x : Four) → Code₄ x x
encode₄ d0 = tt
encode₄ d1 = tt
encode₄ d2 = tt
encode₄ d3 = tt

decode₄ : {x y : Four} → x ≡ y → Code₄ x y
decode₄ {x} p = subst (Code₄ x) p (encode₄ x)

module T4 = Terms _∧₄_ d3 ∧₄-idem ∧₄-comm ∧₄-assoc ∧₄-unit

-- The witness.  psi = (d0, d0, d2, d3): monotone, fixes the top, three
-- distinct values.
ψ : Four → Four
ψ d0 = d0
ψ d1 = d0
ψ d2 = d2
ψ d3 = d3

ψ-Pres∧ : T4.Pres∧ ψ
ψ-Pres∧ d0 d0 = refl
ψ-Pres∧ d0 d1 = refl
ψ-Pres∧ d0 d2 = refl
ψ-Pres∧ d0 d3 = refl
ψ-Pres∧ d1 d0 = refl
ψ-Pres∧ d1 d1 = refl
ψ-Pres∧ d1 d2 = refl
ψ-Pres∧ d1 d3 = refl
ψ-Pres∧ d2 d0 = refl
ψ-Pres∧ d2 d1 = refl
ψ-Pres∧ d2 d2 = refl
ψ-Pres∧ d2 d3 = refl
ψ-Pres∧ d3 d0 = refl
ψ-Pres∧ d3 d1 = refl
ψ-Pres∧ d3 d2 = refl
ψ-Pres∧ d3 d3 = refl

ψ-Adm : T4.Adm ψ
ψ-Adm = ψ-Pres∧ , refl

-- psi is outside the ACUI polynomial clone.
ψ-not-clamp : T4.IsClamp ψ → ⊥
ψ-not-clamp (d0 , p) = decode₄ (p d2)   -- d2 /\ d0 = d0, but psi d2 = d2
ψ-not-clamp (d1 , p) = decode₄ (p d1)   -- d1 /\ d1 = d1, but psi d1 = d0
ψ-not-clamp (d2 , p) = decode₄ (p d1)   -- d1 /\ d2 = d1
ψ-not-clamp (d3 , p) = decode₄ (p d1)   -- d1 /\ d3 = d1

ψ-not-const : T4.IsConst ψ → ⊥
ψ-not-const (c , p) = decode₄ (p d0 ∙ sym (p d3))

ψ-not-polynomial : (t : T4.Tm) → ((s : Four) → ψ s ≡ T4.⟦ t ⟧ s) → ⊥
ψ-not-polynomial = T4.notPolynomial ψ ψ-not-clamp ψ-not-const

-- ... and outside the threshold family too.  Note the hypothesis: chi is an
-- ARBITRARY Bool-valued map, not required to be a filter test, so this
-- refutes the strongest possible reading of "the missing modes are the
-- thresholds".  The proof is the pigeonhole a threshold cannot escape: it
-- takes at most two values, one of which is TOP, and psi takes three.
ψ-not-threshold : (χ : Four → Bool) (b : Four)
                → ((s : Four) → ψ s ≡ T4.thr χ b s) → ⊥
ψ-not-threshold χ b h with T4.thrVal χ b d0 | T4.thrVal χ b d2
... | inl e0 | _       = decode₄ (h d0 ∙ e0)               -- d0 = d3
... | inr _  | inl e2  = decode₄ (h d2 ∙ e2)               -- d2 = d3
... | inr e0 | inr e2  = decode₄ ((h d0 ∙ e0) ∙ sym (h d2 ∙ e2))
                                                            -- d0 = b = d2

-- The positive half of the same witness: psi IS a pointwise meet of two
-- thresholds.  chi-a tests "s >= d2" and chi-b tests "s >= d3"; both are
-- filter tests, so both thresholds are admissible modes in the sense of
-- OBLIGATION.md Definition 4 as repaired by swarm-0814-02.
χa : Four → Bool
χa d0 = false
χa d1 = false
χa d2 = true
χa d3 = true

χb : Four → Bool
χb d0 = false
χb d1 = false
χb d2 = false
χb d3 = true

χa-mult : (x y : Four) → χa (x ∧₄ y) ≡ (χa x) && (χa y)
χa-mult d0 d0 = refl
χa-mult d0 d1 = refl
χa-mult d0 d2 = refl
χa-mult d0 d3 = refl
χa-mult d1 d0 = refl
χa-mult d1 d1 = refl
χa-mult d1 d2 = refl
χa-mult d1 d3 = refl
χa-mult d2 d0 = refl
χa-mult d2 d1 = refl
χa-mult d2 d2 = refl
χa-mult d2 d3 = refl
χa-mult d3 d0 = refl
χa-mult d3 d1 = refl
χa-mult d3 d2 = refl
χa-mult d3 d3 = refl

χb-mult : (x y : Four) → χb (x ∧₄ y) ≡ (χb x) && (χb y)
χb-mult d0 d0 = refl
χb-mult d0 d1 = refl
χb-mult d0 d2 = refl
χb-mult d0 d3 = refl
χb-mult d1 d0 = refl
χb-mult d1 d1 = refl
χb-mult d1 d2 = refl
χb-mult d1 d3 = refl
χb-mult d2 d0 = refl
χb-mult d2 d1 = refl
χb-mult d2 d2 = refl
χb-mult d2 d3 = refl
χb-mult d3 d0 = refl
χb-mult d3 d1 = refl
χb-mult d3 d2 = refl
χb-mult d3 d3 = refl

τa τb : Four → Four
τa = T4.thr χa d0
τb = T4.thr χb d2

τa-Adm : T4.Adm τa
τa-Adm = T4.thr-Adm χa d0 χa-mult refl

τb-Adm : T4.Adm τb
τb-Adm = T4.thr-Adm χb d2 χb-mult refl

ψ-is-meet-of-two-thresholds : (s : Four) → ψ s ≡ (τa s) ∧₄ (τb s)
ψ-is-meet-of-two-thresholds d0 = refl
ψ-is-meet-of-two-thresholds d1 = refl
ψ-is-meet-of-two-thresholds d2 = refl
ψ-is-meet-of-two-thresholds d3 = refl
