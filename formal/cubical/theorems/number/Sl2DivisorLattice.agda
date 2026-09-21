{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sl2DivisorLattice
--
-- The 𝔰𝔩₂-triple on a chain of the divisor lattice, machine-checked.
-- verdict: the mathematics is CLASSICAL — Stanley 1980, Proctor 1982,
-- and for the rank-one content textbook 𝔰𝔩₂ theory, Humphreys §7).
-- Nothing here is claimed as new mathematics; what is new is that the
-- three brackets are now a checked term rather than hand algebra.
--
-- WHAT IS FORMALIZED: the RANK-ONE case, V_α = k[ξ]/(ξ^{α+1}), with all
-- three brackets, the truncation, the basis laws and the grading.
-- WHAT IS NOT: the multi-index case B_n = ⨂_i V_{α_i} of the note's §1.
-- It is NOT proved below and no statement below refers to it.  See §6.
--
-- HEADLINE STATEMENTS (all checked, no postulates, no holes, --safe):
--
--  1. ε , φ , η : M → M      The three operators, on the bigraded
--                            coefficient module M = ℕ → ℕ → ℤ.  The
--                            truncation ξ^{α+1} = 0 is STRUCTURAL here:
--                            ε reads no coefficient at second index 0,
--                            so the top basis vector's ε-image is
--                            discarded, by the shape of the clauses and
--                            not by a side condition (§2, and ε-δ-top).
--
--  2. bracket-ηε             ⟦η,ε⟧ ≡ 2ε
--     bracket-ηφ             ⟦η,φ⟧ ≡ (−2)φ
--     bracket-εφ             ⟦ε,φ⟧ ≡ η
--                            The three 𝔰𝔩₂ relations, pointwise on every
--                            element of M, boundary cases included.  The
--                            note's delicate point — the off-diagonal
--                            cancellation — does not arise in rank one;
--                            the diagonal identity
--                            κ(α−κ+1) − (κ+1)(α−κ) = 2κ − α is what is
--                            actually discharged, as ℕ-identity
--                            (κ+1)(d+2) + (d+1) = (κ+1) + (κ+2)(d+1)
--                            with d = α − κ (see diag-ℕ), so no
--                            truncated subtraction appears anywhere.
--
--  3. ε-δ , ε-δ-top ,        The action on the monomial basis is
--     φ-δ , φ-δ-bot , η-δ    LITERALLY the note's display:
--                              ε ξ^κ = ξ^{κ+1}, and 0 at the top;
--                              φ ξ^κ = κ(α−κ+1) ξ^{κ−1}, and 0 at κ=0
--                                      with NO clause needed there;
--                              η ξ^κ = (2κ−α) ξ^κ.
--                            These are the bridge between the note's
--                            operators and the encoding used here, so
--                            they are stated, not assumed.
--
--  4. ε-grade , φ-grade ,    Each V_α ⊆ M is invariant: the bigrading is
--     η-grade                preserved, so M = ∏_α V_α as a module and
--                            every chain of the divisor lattice carries
--                            the action.  This is the note's §3(i) — the
--                            ideal is a submodule — in the dual picture.
--
-- ENCODING, and why (the one thing a reader must accept).
--
-- A basis vector of V_α is ξ^κ with 0 ≤ κ ≤ α.  It is indexed here by
-- the PAIR (κ , d) with d = α − κ, so that α = κ + d is carried by the
-- index and no truncated subtraction is ever written; the box condition
-- 0 ≤ κ ≤ α becomes the (vacuous) condition that both entries of the
-- pair are naturals.  The reindexing {κ : κ ≤ α} ≅ {(κ,d) : κ+d = α} is
-- immediate and is NOT itself formalized below.
--
-- A module element is its coefficient function v : ℕ → ℕ → ℤ, and an
-- operator T with T ξ_s = Σ_t c(t,s) ξ_t acts by (T v)(t) = Σ_s c(t,s)
-- v(s); this is a left action, composition in the same order, and for
-- these three operators every such sum has at most one term, so no
-- finite-sum machinery is needed.  Working with ALL of ℕ × ℕ at once
-- means every α is treated simultaneously; §4 shows the grading is
-- preserved, which is what cuts M down to the individual chains.
--
-- COEFFICIENTS: ℤ, i.e. the FREE ℤ-module on the box.  That is the
-- weakest choice: the structure constants are integers, so the operators
-- are defined over ℤ and every other coefficient ring is obtained by
-- base change ⊗_ℤ R, under which the checked bracket identities are
-- preserved.  (Characteristic 0 is needed only for the consequences of
-- the note's §5 — complete reducibility, Sperner — none of which is
-- claimed here.)
------------------------------------------------------------------------

module Sl2DivisorLattice where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; +-zero ; +-suc ; +-comm ; +-assoc
        ; ·-suc ; ·-identityˡ ; ·-identityʳ ; discreteℕ)
  renaming (_+_ to _+ℕ_ ; _·_ to _·ℕ_)
open import Cubical.Data.Int
open import Cubical.Data.Empty renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)

------------------------------------------------------------------------
-- §0  Arithmetic in ℤ.  Five lemmas, all of them abelian-group or
--     distributivity bookkeeping; nothing here is about 𝔰𝔩₂.
------------------------------------------------------------------------

private

  -- x · 0 ≡ 0.  (0 · x ≡ 0 is definitional.)
  ·0ᵣ : (x : ℤ) → x · pos 0 ≡ pos 0
  ·0ᵣ x = ·Comm x (pos 0)

  -- A + E ≡ C + B  ⟹  A − B ≡ C − E, in any abelian group; here ℤ.
  subLemma : (A B C E : ℤ) → A + E ≡ C + B → A - B ≡ C - E
  subLemma A B C E p =
      cong (_- B) (sym (plusMinus E A))
    ∙ cong (λ z → (z - E) - B) p
    ∙ swapLast
    ∙ cong (_- E) collapse
    where
    swapLast : ((C + B) - E) - B ≡ ((C + B) - B) - E
    swapLast =
        sym (+Assoc (C + B) (- E) (- B))
      ∙ cong ((C + B) +_) (+Comm (- E) (- B))
      ∙ +Assoc (C + B) (- B) (- E)
    collapse : (C + B) - B ≡ C
    collapse = sym (+Assoc C B (- B)) ∙ cong (C +_) (-Cancel B)

  -- the same, transported along pos : ℕ → ℤ
  posDiff : (a b c e : ℕ) → a +ℕ e ≡ c +ℕ b
          → pos a - pos b ≡ pos c - pos e
  posDiff a b c e p =
    subLemma (pos a) (pos b) (pos c) (pos e)
      (sym (pos+ a e) ∙ cong pos p ∙ pos+ c b)

  -- (A − B) − C ≡ A − (B + C)
  sub-sub : (A B C : ℤ) → (A - B) - C ≡ A - (B + C)
  sub-sub A B C = sym (+Assoc A (- B) (- C)) ∙ cong (A +_) (sym (-Dist+ B C))

  -- (a − b) · x ≡ a·x − b·x
  ·DistL- : (a b x : ℤ) → (a - b) · x ≡ a · x - b · x
  ·DistL- a b x = ·DistL+ a (- b) x ∙ cong (a · x +_) (sym (-DistL· b x))

  -- the shape every bracket computation ends in: s·x − t·x ≡ u·x
  scalarStep : (s t u x : ℤ) → s ≡ u + t → s · x - t · x ≡ u · x
  scalarStep s t u x p =
      cong (λ z → z · x - t · x) p
    ∙ cong (_- t · x) (·DistL+ u t x)
    ∙ plusMinus (t · x) (u · x)

  -- d + 2 ≡ suc (suc d), in ℕ
  +two : (d : ℕ) → d +ℕ 2 ≡ suc (suc d)
  +two d = +-suc d 1 ∙ cong suc (+-suc d 0) ∙ cong (λ z → suc (suc z)) (+-zero d)

------------------------------------------------------------------------
-- §1  The module and the three operators.
------------------------------------------------------------------------

-- coefficient functions on the bigraded basis {(κ , d)}; the chain V_α
-- sits on the diagonal κ + d = α (see §4).
M : Type₀
M = ℕ → ℕ → ℤ

0M : M
0M _ _ = pos 0

_⊖_ : M → M → M
(v ⊖ w) κ d = v κ d - w κ d

scale : ℤ → M → M
scale c v κ d = c · v κ d

-- ε(ξ^κ) = ξ^{κ+1}, truncated at the top.  Dually: the coefficient of
-- the target (κ,d) is read at the source (κ−1 , d+1); at κ = 0 there is
-- no source.  Note that the second index of the argument is never 0 on
-- the right: THAT is the truncation, and it is structural.
ε : M → M
ε v zero    d = pos 0
ε v (suc κ) d = v κ (suc d)

-- φ(ξ^κ) = κ(α−κ+1) ξ^{κ−1}.  With d = α − κ the coefficient is
-- κ(d+1); at the source (suc κ , d) that is (κ+1)(d+1).  No clause at
-- κ = 0 is needed — the note's first boundary convenience — because the
-- source of a nonzero contribution always has first index a successor.
φ : M → M
φ v κ zero    = pos 0
φ v κ (suc d) = pos (suc κ ·ℕ suc d) · v (suc κ) d

-- η(ξ^κ) = (2κ − α) ξ^κ = (κ − d) ξ^κ.
η : M → M
η v κ d = (pos κ - pos d) · v κ d

⟦_,_⟧ : (M → M) → (M → M) → M → M
⟦ S , T ⟧ v = S (T v) ⊖ T (S v)

------------------------------------------------------------------------
-- §2  The three brackets.
------------------------------------------------------------------------

-- ⟦η,ε⟧ ≡ 2ε
bracket-ηε : (v : M) → ⟦ η , ε ⟧ v ≡ scale (pos 2) (ε v)
bracket-ηε v = funExt (λ κ → funExt (λ d → go κ d))
  where
  go : (κ d : ℕ) → ⟦ η , ε ⟧ v κ d ≡ scale (pos 2) (ε v) κ d
  go zero d = ·0ᵣ (pos 0 - pos d) ∙ sym (·0ᵣ (pos 2))
  go (suc κ) d =
    scalarStep (pos (suc κ) - pos d) (pos κ - pos (suc d)) (pos 2)
               (v κ (suc d)) shift
    where
    shift : pos (suc κ) - pos d ≡ pos 2 + (pos κ - pos (suc d))
    shift =
        posDiff (suc κ) d (2 +ℕ κ) (suc d) (cong suc (+-suc κ d))
      ∙ cong (_- pos (suc d)) (pos+ 2 κ)
      ∙ sym (+Assoc (pos 2) (pos κ) (- pos (suc d)))

-- ⟦η,φ⟧ ≡ (−2)φ
bracket-ηφ : (v : M) → ⟦ η , φ ⟧ v ≡ scale (- pos 2) (φ v)
bracket-ηφ v = funExt (λ κ → funExt (λ d → go κ d))
  where
  go : (κ d : ℕ) → ⟦ η , φ ⟧ v κ d ≡ scale (- pos 2) (φ v) κ d
  go κ zero = ·0ᵣ (pos κ - pos 0) ∙ sym (·0ᵣ (- pos 2))
  go κ (suc d) =
      cong (_- (pos C · ((pos (suc κ) - pos d) · y))) (·Assoc S (pos C) y)
    ∙ cong (λ z → (S · pos C) · y - z) (·Assoc (pos C) (pos (suc κ) - pos d) y)
    ∙ scalarStep (S · pos C) (pos C · (pos (suc κ) - pos d))
                 ((- pos 2) · pos C) y sc
    ∙ sym (·Assoc (- pos 2) (pos C) y)
    where
    C : ℕ
    C = suc κ ·ℕ suc d
    y : ℤ
    y = v (suc κ) d
    S T : ℤ
    S = pos κ - pos (suc d)
    T = pos (suc κ) - pos d
    -- S ≡ (−2) + T, the rank-one weight drop
    weight : S ≡ (- pos 2) + T
    weight =
        posDiff κ (suc d) (suc κ) (suc (suc d)) (+-suc κ (suc d))
      ∙ cong (λ z → pos (suc κ) - z) (cong pos (sym (+two d)) ∙ pos+ d 2)
      ∙ sym (sub-sub (pos (suc κ)) (pos d) (pos 2))
      ∙ +Comm T (- pos 2)
    sc : S · pos C ≡ (- pos 2) · pos C + pos C · T
    sc =
        cong (_· pos C) weight
      ∙ ·DistL+ (- pos 2) T (pos C)
      ∙ cong ((- pos 2) · pos C +_) (·Comm T (pos C))

-- ⟦ε,φ⟧ ≡ η.  This is the identity that carries the content:
-- κ(α−κ+1) − (κ+1)(α−κ) = 2κ − α.
bracket-εφ : (v : M) → ⟦ ε , φ ⟧ v ≡ η v
bracket-εφ v = funExt (λ κ → funExt (λ d → go κ d))
  where
  -- the ℕ form of the diagonal identity, with d = α − κ:
  --   (κ+1)(d+2) + (d+1) ≡ (κ+1) + (κ+2)(d+1)
  diag-ℕ : (κ d : ℕ)
    → (suc κ ·ℕ suc (suc d)) +ℕ suc d ≡ suc κ +ℕ (suc (suc κ) ·ℕ suc d)
  diag-ℕ κ d =
      cong (_+ℕ suc d) (·-suc (suc κ) (suc d))
    ∙ sym (+-assoc (suc κ) (suc κ ·ℕ suc d) (suc d))
    ∙ cong (suc κ +ℕ_) (+-comm (suc κ ·ℕ suc d) (suc d))

  go : (κ d : ℕ) → ⟦ ε , φ ⟧ v κ d ≡ η v κ d
  go zero zero = refl
  go zero (suc d) =
      cong (λ z → pos 0 - (pos z · v zero (suc d))) (·-identityˡ (suc d))
    ∙ sym (minus≡0- (pos (suc d) · v zero (suc d)))
    ∙ -DistL· (pos (suc d)) (v zero (suc d))
    ∙ cong (_· v zero (suc d)) (minus≡0- (pos (suc d)))
  go (suc κ) zero = cong (λ z → pos z · v (suc κ) zero) (·-identityʳ (suc κ))
  go (suc κ) (suc d) =
      sym (·DistL- (pos (suc κ ·ℕ suc (suc d)))
                   (pos (suc (suc κ) ·ℕ suc d))
                   (v (suc κ) (suc d)))
    ∙ cong (_· v (suc κ) (suc d))
        (posDiff (suc κ ·ℕ suc (suc d)) (suc (suc κ) ·ℕ suc d)
                 (suc κ) (suc d) (diag-ℕ κ d))

------------------------------------------------------------------------
-- §3  The monomial basis, and the note's displays read off it.
--
-- δ κ d is the basis vector ξ^κ of V_{κ+d}.  The point of this section
-- is that the encoding of §1 really implements the note's operators:
-- everything here is a statement about ε, φ, η applied to a basis
-- vector, and it is proved, not assumed.
------------------------------------------------------------------------

kron : ℕ → ℕ → ℤ
kron zero    zero    = pos 1
kron zero    (suc _) = pos 0
kron (suc _) zero    = pos 0
kron (suc m) (suc n) = kron m n

δ : ℕ → ℕ → M
δ κ d a b = kron κ a · kron d b

private
  kron-≠ : (m n : ℕ) → ¬ (m ≡ n) → kron m n ≡ pos 0
  kron-≠ zero zero ne = ⊥-rec (ne refl)
  kron-≠ zero (suc n) ne = refl
  kron-≠ (suc m) zero ne = refl
  kron-≠ (suc m) (suc n) ne = kron-≠ m n (λ p → ne (cong suc p))

  -- Any coefficient function may be evaluated at the basis index: off
  -- the index the Kronecker factor kills both sides.
  coefGen : (f : ℕ → ℕ → ℤ) (κ d a b : ℕ)
          → f a b · δ κ d a b ≡ f κ d · δ κ d a b
  coefGen f κ d a b with discreteℕ κ a | discreteℕ d b
  ... | yes p | yes q = λ i → f (p (~ i)) (q (~ i)) · δ κ d a b
  ... | no ¬p | _ =
        cong (f a b ·_) kill ∙ ·0ᵣ (f a b)
      ∙ sym (·0ᵣ (f κ d)) ∙ cong (f κ d ·_) (sym kill)
    where
    kill : δ κ d a b ≡ pos 0
    kill = cong (_· kron d b) (kron-≠ κ a ¬p)
  ... | yes _ | no ¬q =
        cong (f a b ·_) kill ∙ ·0ᵣ (f a b)
      ∙ sym (·0ᵣ (f κ d)) ∙ cong (f κ d ·_) (sym kill)
    where
    kill : δ κ d a b ≡ pos 0
    kill = cong (kron κ a ·_) (kron-≠ d b ¬q) ∙ ·0ᵣ (kron κ a)

-- ε ξ^κ = ξ^{κ+1} away from the top of the chain
ε-δ : (κ d : ℕ) → ε (δ κ (suc d)) ≡ δ (suc κ) d
ε-δ κ d = funExt (λ a → funExt (λ b → go a b))
  where
  go : (a b : ℕ) → ε (δ κ (suc d)) a b ≡ δ (suc κ) d a b
  go zero    b = refl
  go (suc a) b = refl

-- ...and 0 AT the top: this is ξ^{α+1} = 0, in force by the shape of ε.
ε-δ-top : (κ : ℕ) → ε (δ κ zero) ≡ 0M
ε-δ-top κ = funExt (λ a → funExt (λ b → go a b))
  where
  go : (a b : ℕ) → ε (δ κ zero) a b ≡ 0M a b
  go zero    b = refl
  go (suc a) b = ·0ᵣ (kron κ a)

-- φ ξ^κ = κ(α−κ+1) ξ^{κ−1}, with κ ↦ suc κ and α−κ ↦ d
φ-δ : (κ d : ℕ) → φ (δ (suc κ) d) ≡ scale (pos (suc κ ·ℕ suc d)) (δ κ (suc d))
φ-δ κ d = funExt (λ a → funExt (λ b → go a b))
  where
  go : (a b : ℕ) → φ (δ (suc κ) d) a b
                 ≡ scale (pos (suc κ ·ℕ suc d)) (δ κ (suc d)) a b
  go a zero =
    sym (cong (pos (suc κ ·ℕ suc d) ·_) (·0ᵣ (kron κ a))
         ∙ ·0ᵣ (pos (suc κ ·ℕ suc d)))
  go a (suc b) = coefGen (λ x y → pos (suc x ·ℕ suc y)) κ d a b

-- φ needs no clause at κ = 0: the coefficient κ(α−κ+1) vanishes there
-- on its own, so φ ξ^0 = 0 is a theorem and not a convention.
φ-δ-bot : (d : ℕ) → φ (δ zero d) ≡ 0M
φ-δ-bot d = funExt (λ a → funExt (λ b → go a b))
  where
  go : (a b : ℕ) → φ (δ zero d) a b ≡ 0M a b
  go a zero    = refl
  go a (suc b) = ·0ᵣ (pos (suc a ·ℕ suc b))

-- η ξ^κ = (2κ − α) ξ^κ = (κ − d) ξ^κ
η-δ : (κ d : ℕ) → η (δ κ d) ≡ scale (pos κ - pos d) (δ κ d)
η-δ κ d = funExt (λ a → funExt (λ b → coefGen (λ x y → pos x - pos y) κ d a b))

------------------------------------------------------------------------
-- §4  The grading: each chain V_α is invariant.
--
-- V_α is the set of coefficient functions supported on κ + d = α; it is
-- free of rank α+1 on {ξ^κ : 0 ≤ κ ≤ α}, i.e. on the divisors of
-- p^α.  The three lemmas say M = ∏_α V_α as a representation — the
-- dual form of the note's §3(i), that the ideal (ξ^{α+1}) is a
-- submodule for all three operators.
------------------------------------------------------------------------

Supported : ℕ → M → Type₀
Supported α v = (κ d : ℕ) → ¬ (κ +ℕ d ≡ α) → v κ d ≡ pos 0

ε-grade : (α : ℕ) (v : M) → Supported α v → Supported α (ε v)
ε-grade α v s zero    d ne = refl
ε-grade α v s (suc κ) d ne =
  s κ (suc d) (λ p → ne (sym (+-suc κ d) ∙ p))

φ-grade : (α : ℕ) (v : M) → Supported α v → Supported α (φ v)
φ-grade α v s κ zero    ne = refl
φ-grade α v s κ (suc d) ne =
    cong (pos (suc κ ·ℕ suc d) ·_)
         (s (suc κ) d (λ p → ne (+-suc κ d ∙ p)))
  ∙ ·0ᵣ (pos (suc κ ·ℕ suc d))

η-grade : (α : ℕ) (v : M) → Supported α v → Supported α (η v)
η-grade α v s κ d ne =
  cong ((pos κ - pos d) ·_) (s κ d ne) ∙ ·0ᵣ (pos κ - pos d)

------------------------------------------------------------------------
-- §5  The triple, packaged.
------------------------------------------------------------------------

record Sl2Triple (e f h : M → M) : Type₀ where
  field
    he : (v : M) → ⟦ h , e ⟧ v ≡ scale (pos 2) (e v)
    hf : (v : M) → ⟦ h , f ⟧ v ≡ scale (- pos 2) (f v)
    ef : (v : M) → ⟦ e , f ⟧ v ≡ h v

divisorChainSl2 : Sl2Triple ε φ η
divisorChainSl2 = record { he = bracket-ηε ; hf = bracket-ηφ ; ef = bracket-εφ }

------------------------------------------------------------------------
-- §5′  Controls.  The brackets above would also hold for a vacuous
-- encoding (all three operators zero), so here are the operators
-- evaluated on ξ² and ξ⁰ and ξ³ inside V₃ = k[ξ]/(ξ⁴), i.e. on the
-- divisor lattice of p³.  Each is `refl`: the values are definitional,
-- not asserted.  In the note's notation, α = 3.
------------------------------------------------------------------------

private
  -- η ξ² = (2·2 − 3) ξ² = ξ²
  control-η2 : η (δ 2 1) 2 1 ≡ pos 1
  control-η2 = refl

  -- η ξ⁰ = (0 − 3) ξ⁰ = −3 ξ⁰
  control-η0 : η (δ 0 3) 0 3 ≡ negsuc 2
  control-η0 = refl

  -- φ ξ² = 2·(3−2+1) ξ¹ = 4 ξ¹   (NOT 2 ξ¹: the coefficient is the
  -- unnormalized one, which is what makes the ideal φ-stable)
  control-φ2 : φ (δ 2 1) 1 2 ≡ pos 4
  control-φ2 = refl

  -- φ ξ⁰ = 0, with no clause for it in the definition of φ
  control-φ0 : φ (δ 0 3) 0 3 ≡ pos 0
  control-φ0 = refl

  -- ε ξ² = ξ³
  control-ε2 : ε (δ 2 1) 3 0 ≡ pos 1
  control-ε2 = refl

  -- ε ξ³ = 0 : the truncation ξ⁴ = 0, at the top of the chain
  control-ε3 : ε (δ 3 0) 4 0 ≡ pos 0
  control-ε3 = refl

------------------------------------------------------------------------
-- §6  Scope limit, stated because it would otherwise be papered over.
--
-- The multi-index module B_n = k[ξ₁,…,ξ_m]/(ξ_i^{α_i+1}) = ⨂_i V_{α_i}
-- is the note's §2(c) off-diagonal cancellation (which is the step that
-- only exists when m ≥ 2).  What is above is the rank-one case in full.
-- The structural route to the general case is the note's §3(ii): a sum
-- of pairwise commuting single-factor triples is again a triple, plus
-- induction on m.  That lemma is operator algebra over an abelian group
-- and is independent of everything above; it is not written here, so
-- nothing above may be quoted for m ≥ 2.
------------------------------------------------------------------------
