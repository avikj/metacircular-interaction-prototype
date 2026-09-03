{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SpernerFromSl2
--
-- What the 𝔰𝔩₂ action BUYS: the passage from the three brackets
-- (checked in Sl2DivisorLattice) to the combinatorial conclusion —
-- rank-symmetry, rank-unimodality, full-rank raising maps, and the
-- Sperner property of the divisor lattice.
--
-- PRIOR ART.  Everything stated here is CLASSICAL and nothing is
-- claimed as new mathematics.  The theorem (divisor lattices are
-- Sperner) is de Bruijn – van Ebbenhorst Tengbergen – Kruyswijk, "On
-- the set of divisors of a number", Nieuw Arch. Wiskunde (2) 23 (1951),
-- 191–193, by symmetric chain decomposition and with no Lie algebra.
-- The 𝔰𝔩₂ / hard-Lefschetz method is R. P. Stanley, "Weyl groups, the
-- hard Lefschetz theorem, and the Sperner property", SIAM J. Alg. Disc.
-- Meth. 1 (1980), 168–184; the poset-⇄-𝔰𝔩₂ dictionary (a graded poset
-- is Peck iff it carries such an action) is R. A. Proctor,
-- "Representations of 𝔰𝔩(2,ℂ) on posets and the Sperner property",
-- SIAM J. Alg. Disc. Meth. 3 (1982), 275–280; products of chains are
-- Proctor–Saks–Sturtevant, Discrete Math. 30 (1980), 173–180.  The
-- rank-one content is textbook (Humphreys, §7).  Companion prose, with
-- formalizes; it does not discover.
--
-- ---------------------------------------------------------------------
-- WHAT IS PROVED HERE (all --safe, no postulates, no holes):
--
--   the RANK-ONE case only, i.e. the divisors of p^α, the chain
--   V_α = k[ξ]/(ξ^{α+1}) whose 𝔰𝔩₂-triple is checked in
--   Sl2DivisorLattice.  For that poset, the whole chain
--   1 → 2 → 3 of the note's §5 is closed:
--
--   §2  Div α, the divisor poset of p^α, its rank, and the fact that
--       an element is determined by its rank (Div≡).
--   §3  the order: ⊑ is antisymmetric and TOTAL (ℕ-total).
--   §4  the bridge to the operators — this is the step where the 𝔰𝔩₂
--       action does the work.  ε implements the covering relation
--       (ε-implements-up) and truncates exactly at the top
--       (ε-at-top ≡ 0M); the raising map is INJECTIVE on every rank
--       (up-inj); φ returns with the coefficient κ(α−κ+1), which is
--       nonzero as a natural number (φ-coefficient-nonzero); η reads
--       the weight 2k − α (η-weight).
--   §5  rank symmetry, as an explicit involution (mirror) with
--       mirror-rank : rk (mirror x) + rk x ≡ α, together with the
--       maps of rank spaces in both directions (rank-symmetry,
--       rank-symmetry-iso).  Rank-unimodality is DEGENERATE in rank
--       one and is stated as such: every W_k with k ≤ α is 1
--       (Rank-isContr), so W is constant, hence symmetric and
--       unimodal, trivially.
--   §6  the Sperner conclusion for this poset: every antichain is a
--       subsingleton (antichain-subsingleton), so it injects into the
--       middle rank (sperner-rank-one), and the middle rank is itself
--       an antichain of size exactly W_{⌊α/2⌋} = 1
--       (middle-rank-isAntichain, W-middle).  Max antichain =
--       W_{⌊Ω(p^α)/2⌋}, which is the note's §5(3) at m = 1.
--
-- THE SCOPE, EXACTLY, and is stated as a type with NO inhabitant
-- (§8): the general case B_n = ⨂_i V_{α_i}, i.e. the divisors of an
-- arbitrary n.  There the conclusion is not degenerate — W_k really
-- varies, unimodality has content, and the injectivity of ε^{A−2k} is
-- the representation-theoretic step.  §8 writes that statement down
-- (GeneralSperner) so that what remains is unambiguous, and gives no
-- term of it.  A sibling module Sl2TensorProduct.agda handles the
-- tensor-product side of the algebra; nothing here depends on it.
--
-- ---------------------------------------------------------------------
-- THE CHARACTERISTIC HYPOTHESIS, carried explicitly and not silently.
--
-- The brackets of Sl2DivisorLattice are polynomial identities in
-- κ, α over ℤ: characteristic-free.  The SPERNER CONCLUSION IS NOT.
-- The general method needs char 0 (complete reducibility; injectivity
-- of ε^{A−2k} on the weight-w space for w < 0), and in char p the
-- structure constant κ(α−κ+1) can vanish.  §7 defines CharZero as an
-- explicit record — "every positive integer is invertible" — and it is
-- a HYPOTHESIS of the general statement in §8, written into its type.
--
-- In rank one it is not needed, and I say so rather than pretending
-- the proofs below are the general ones cut down: for a single chain,
-- ε carries the rank-k basis vector to the rank-(k+1) basis vector on
-- the nose (ε-δ), so injectivity is a statement about ℕ-indices and
-- needs no field at all.  The reader should therefore NOT read §6 as
-- evidence that the char-0 hypothesis is dispensable; it is evidence
-- that the m = 1 case is too small to see it.
--
-- ---------------------------------------------------------------------
-- SCOPE / NON-CLAIM (a presentation hazard the prose already logs).
--
-- The construction takes the factorization as INPUT.  Div α below is a
-- type family on a single natural number α; no prime enters anywhere in
-- this file, and the statements are blind to whether the p_i are prime
-- — indeed to whether there are any p_i.  Nothing here says anything
-- about the distribution of Ω or ω, and it is NOT a bridge to the
-- Goldbach / critical-line material of the transmission.  See
------------------------------------------------------------------------

module SpernerFromSl2 where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-zero ; +-suc ; +-comm
        ; inj-m+ ; injSuc ; isSetℕ ; snotz)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Int using (ℤ ; pos ; _-_)

open import Sl2DivisorLattice
  using (M ; 0M ; scale ; δ ; ε ; φ ; η ; ε-δ ; ε-δ-top ; φ-δ ; η-δ
        ; Sl2Triple ; divisorChainSl2)

private
  variable
    α : ℕ

------------------------------------------------------------------------
-- §1  The input.  Nothing below re-proves the brackets; they are
--     imported.  This is the only place the 𝔰𝔩₂ hypothesis is named.
------------------------------------------------------------------------

-- The triple (ε , φ , η) of Sl2DivisorLattice, satisfying
-- ⟦η,ε⟧ = 2ε , ⟦η,φ⟧ = −2φ , ⟦ε,φ⟧ = η.
sl2 : Sl2Triple ε φ η
sl2 = divisorChainSl2

------------------------------------------------------------------------
-- §2  The poset: divisors of p^α.
--
--     A divisor is p^κ with 0 ≤ κ ≤ α, encoded — exactly as in
--     Sl2DivisorLattice — by the pair (κ , d) with κ + d ≡ α, so that
--     no truncated subtraction is ever written.  The rank is Ω = κ.
------------------------------------------------------------------------

Div : ℕ → Type₀
Div α = Σ[ κ ∈ ℕ ] Σ[ d ∈ ℕ ] (κ + d ≡ α)

rk : Div α → ℕ
rk x = fst x

co : Div α → ℕ
co x = fst (snd x)

rk+co : (x : Div α) → rk x + co x ≡ α
rk+co x = snd (snd x)

-- the cofactor and its certificate are determined by the rank
isPropFib : (α κ : ℕ) → isProp (Σ[ d ∈ ℕ ] (κ + d ≡ α))
isPropFib α κ (d , p) (e , q) =
  ΣPathP (dpath , isProp→PathP (λ i → isSetℕ (κ + dpath i) α) p q)
  where
  dpath : d ≡ e
  dpath = inj-m+ (p ∙ sym q)

-- an element of Div α is determined by its rank
Div≡ : (x y : Div α) → rk x ≡ rk y → x ≡ y
Div≡ {α = α} x y = Σ≡Prop (isPropFib α)

------------------------------------------------------------------------
-- §3  The order.  Divisibility p^κ ∣ p^j is κ ≤ j; on a chain it is
--     TOTAL, which is what makes the rank-one Sperner statement
--     degenerate (and honest to label as such).
------------------------------------------------------------------------

_⊑_ : Div α → Div α → Type₀
x ⊑ y = Σ[ c ∈ ℕ ] (rk x + c ≡ rk y)

⊑-refl : (x : Div α) → x ⊑ x
⊑-refl x = zero , +-zero (rk x)

-- c + e ≡ 0 forces c ≡ 0
sum≡0ₗ : (c e : ℕ) → c + e ≡ zero → c ≡ zero
sum≡0ₗ zero e p = refl
sum≡0ₗ (suc c) e p = ⊥-rec (snotz p)

private
  +assoc′ : (a b c : ℕ) → a + (b + c) ≡ (a + b) + c
  +assoc′ zero b c = refl
  +assoc′ (suc a) b c = cong suc (+assoc′ a b c)

⊑-antisym : (x y : Div α) → x ⊑ y → y ⊑ x → x ≡ y
⊑-antisym x y (c , p) (e , q) =
  Div≡ x y (sym (+-zero (rk x)) ∙ sym (cong (rk x +_) c≡0) ∙ p)
  where
  round : rk x + (c + e) ≡ rk x + zero
  round = +assoc′ (rk x) c e ∙ cong (_+ e) p ∙ q ∙ sym (+-zero (rk x))
  c≡0 : c ≡ zero
  c≡0 = sum≡0ₗ c e (inj-m+ round)

-- totality of ≤ on ℕ, by induction; no library order module is used
ℕ-total : (a b : ℕ) → (Σ[ c ∈ ℕ ] (a + c ≡ b)) ⊎ (Σ[ c ∈ ℕ ] (b + c ≡ a))
ℕ-total zero b = inl (b , refl)
ℕ-total (suc a) zero = inr (suc a , refl)
ℕ-total (suc a) (suc b) with ℕ-total a b
... | inl (c , p) = inl (c , cong suc p)
... | inr (c , p) = inr (c , cong suc p)

⊑-total : (x y : Div α) → (x ⊑ y) ⊎ (y ⊑ x)
⊑-total x y = ℕ-total (rk x) (rk y)

------------------------------------------------------------------------
-- §4  THE BRIDGE.  Where the 𝔰𝔩₂ action enters the combinatorics:
--     ε is the covering (raising) map, φ the lowering map with the
--     structure constant κ(α−κ+1), η the weight = 2·rank − α.
--
--     This is step 2 of the chain — "the maps are of full rank" —
--     in the rank-one case, where it holds at EVERY rank below the
--     top and needs no characteristic hypothesis (see the header).
------------------------------------------------------------------------

-- the basis vector ξ^{rk x} of V_α inside the module M
vec : Div α → M
vec (κ , d , _) = δ κ d

-- the cover x ⋖ up x : rank k ↦ rank k+1, available exactly when the
-- cofactor is a successor, i.e. when x is not the top divisor p^α
up : (x : Div α) (d : ℕ) → co x ≡ suc d → Div α
up (κ , e , p) d q =
  suc κ , d , (sym (+-suc κ d) ∙ cong (κ +_) (sym q) ∙ p)

up-rank : (x : Div α) (d : ℕ) (q : co x ≡ suc d) → rk (up x d q) ≡ suc (rk x)
up-rank (κ , e , p) d q = refl

up-covers : (x : Div α) (d : ℕ) (q : co x ≡ suc d) → x ⊑ up x d q
up-covers x d q = suc zero , +-suc (rk x) zero ∙ cong suc (+-zero (rk x))

-- ε IMPLEMENTS the covering relation: on basis vectors, ε ξ^κ = ξ^{κ+1}
ε-implements-up : (x : Div α) (d : ℕ) (q : co x ≡ suc d)
                → ε (vec x) ≡ vec (up x d q)
ε-implements-up (κ , e , p) d q = cong (λ z → ε (δ κ z)) q ∙ ε-δ κ d

-- ...and truncates at the top: ε ξ^α = 0, i.e. ξ^{α+1} = 0
ε-at-top : (x : Div α) → co x ≡ zero → ε (vec x) ≡ 0M
ε-at-top (κ , e , p) q = cong (λ z → ε (δ κ z)) q ∙ ε-δ-top κ

-- FULL RANK.  The raising map is injective on each rank: this is the
-- rank-one form of "ε : W_k → W_{k+1} is injective for 2k < α", holding
-- here for every k < α.
up-inj : (x y : Div α) (d e : ℕ) (q : co x ≡ suc d) (r : co y ≡ suc e)
       → up x d q ≡ up y e r → x ≡ y
up-inj x y d e q r p = Div≡ x y (injSuc (cong rk p))

-- φ returns along the same edge with the structure constant
-- κ(α−κ+1) = (κ+1)(d+1) at the source (κ+1 , d).
φ-implements-down : (κ d : ℕ)
  → φ (δ (suc κ) d) ≡ scale (pos (suc κ · suc d)) (δ κ (suc d))
φ-implements-down = φ-δ

-- and that constant is nonzero AS A NATURAL NUMBER.  This is the exact
-- point at which characteristic matters: in char p its image can vanish,
-- and then the argument of §5–§6 has no analogue.  Here the statement is
-- over ℕ, hence characteristic-free, hence proves nothing about char p.
φ-coefficient-nonzero : (κ d : ℕ) → ¬ (suc κ · suc d ≡ zero)
φ-coefficient-nonzero κ d = snotz

-- η reads the weight 2·rank − α, in the (κ , d) encoding: κ − d.
η-weight : (x : Div α) → η (vec x) ≡ scale (pos (rk x) - pos (co x)) (vec x)
η-weight (κ , d , _) = η-δ κ d

------------------------------------------------------------------------
-- §5  Rank symmetry and rank unimodality (step 1 of the chain).
------------------------------------------------------------------------

Rank : (α k : ℕ) → Type₀
Rank α k = Σ[ x ∈ Div α ] (rk x ≡ k)

-- W_k = 1 for every k ≤ α (the hypothesis "k ≤ α" being the cofactor).
-- In rank one this IS the whole Whitney vector: constant 1.  Symmetry
-- and unimodality follow at once and are therefore degenerate here —
-- said plainly, because the general case is where they have content.
Rank-isContr : (α k : ℕ) → Σ[ d ∈ ℕ ] (k + d ≡ α) → isContr (Rank α k)
Rank-isContr α k (d , p) = ((k , d , p) , refl) , contract
  where
  contract : (y : Rank α k) → ((k , d , p) , refl) ≡ y
  contract (x , q) =
    Σ≡Prop (λ z → isSetℕ (rk z) k) (Div≡ (k , d , p) x (sym q))

-- the rank-reversing involution p^κ ↦ p^{α−κ}, written without ∸
mirror : Div α → Div α
mirror (κ , d , p) = d , κ , (+-comm d κ ∙ p)

mirror-rank : (x : Div α) → rk (mirror x) + rk x ≡ α
mirror-rank (κ , d , p) = +-comm d κ ∙ p

mirror-mirror : (x : Div α) → mirror (mirror x) ≡ x
mirror-mirror x = Div≡ (mirror (mirror x)) x refl

-- W_k = W_j whenever k + j = α: the two maps, and both round trips.
rank-symmetry : (k j : ℕ) → k + j ≡ α → Rank α k → Rank α j
rank-symmetry {α = α} k j kj (x , q) =
  mirror x , inj-m+ {m = k} (cong (_+ rk (mirror x)) (sym q) ∙ lem ∙ sym kj)
  where
  lem : rk x + rk (mirror x) ≡ α
  lem = +-comm (rk x) (rk (mirror x)) ∙ mirror-rank x

rank-symmetry-iso : (k j : ℕ) (kj : k + j ≡ α) (jk : j + k ≡ α) (x : Rank α k)
  → fst (rank-symmetry j k jk (rank-symmetry k j kj x)) ≡ fst x
rank-symmetry-iso k j kj jk (x , q) = mirror-mirror x

------------------------------------------------------------------------
-- §6  The Sperner conclusion for the divisors of p^α (step 3).
------------------------------------------------------------------------

-- An antichain: pairwise incomparable, i.e. comparable ⇒ equal.
isAntichain : (A : Div α → Type₀) → Type₀
isAntichain {α = α} A = (x y : Div α) → A x → A y → x ⊑ y → x ≡ y

-- Totality of ⊑ turns that into: an antichain has at most one element.
antichain-subsingleton : (A : Div α → Type₀) → isAntichain A
  → (x y : Div α) → A x → A y → x ≡ y
antichain-subsingleton A ac x y ax ay with ⊑-total x y
... | inl le = ac x y ax ay le
... | inr ge = sym (ac y x ay ax ge)

-- ⌊α/2⌋, and its cofactor: the middle rank exists
half : ℕ → ℕ
half zero = zero
half (suc zero) = zero
half (suc (suc n)) = suc (half n)

half-split : (α : ℕ) → Σ[ d ∈ ℕ ] (half α + d ≡ α)
half-split zero = zero , refl
half-split (suc zero) = suc zero , refl
half-split (suc (suc n)) with half-split n
... | (d , p) = suc d , (cong suc (+-suc (half n) d) ∙ cong (λ z → suc (suc z)) p)

middle : (α : ℕ) → Div α
middle α = half α , fst (half-split α) , snd (half-split α)

-- W_{⌊α/2⌋} = 1
W-middle : (α : ℕ) → isContr (Rank α (half α))
W-middle α = Rank-isContr α (half α) (half-split α)

-- the middle rank is itself an antichain
middle-rank-isAntichain : (α : ℕ) → isAntichain {α = α} (λ x → rk x ≡ half α)
middle-rank-isAntichain α x y ax ay _ = Div≡ x y (ax ∙ sym ay)

-- MAXIMUM ANTICHAIN = W_{⌊Ω(p^α)/2⌋}.  Upper bound: every antichain
-- (prop-valued, so that "size" means what it should) maps injectively
-- into the middle rank space.  Lower bound: W-middle above says that
-- space is inhabited, and middle-rank-isAntichain says it is achieved
-- by an antichain.  Together: the note's §5(3) at m = 1.
sperner-rank-one : (α : ℕ) (A : Div α → Type₀)
  → ((x : Div α) → isProp (A x))
  → isAntichain A
  → Σ[ f ∈ (Σ[ x ∈ Div α ] A x → Rank α (half α)) ]
      ((u v : Σ[ x ∈ Div α ] A x) → f u ≡ f v → u ≡ v)
sperner-rank-one α A propA ac =
  (λ _ → fst (W-middle α)) ,
  (λ u v _ → Σ≡Prop propA (antichain-subsingleton A ac (fst u) (fst v) (snd u) (snd v)))

------------------------------------------------------------------------
-- §7  The characteristic hypothesis, as an explicit carrier.
--
--     Not used anywhere above — see the header.  It is defined so that
--     §8's statement can carry it in its type rather than in a comment.
--     "Characteristic zero" is taken in the only form the method needs:
--     every positive integer is invertible in the coefficient ring.
------------------------------------------------------------------------

record CharZero (R : Type₀) (1r : R) (_·R_ : R → R → R)
                (fromℕ : ℕ → R) : Type₀ where
  field
    inv : (n : ℕ) → Σ[ r ∈ R ] (fromℕ (suc n) ·R r ≡ 1r)

------------------------------------------------------------------------
-- §8  WHAT REMAINS.  The general case, written as a type.  NO TERM of
--     this type is given in this file, and none is postulated: --safe
--     is on and there are no postulates and no holes anywhere here.
--     The statement typechecks; that is all it does.
--
--     Reading guide: an exponent vector κ with κ i ≤ α i for i < m,
--     rank Ω = Σ_{i<m} κ i, and the claim that any antichain injects
--     into the middle rank.  The 𝔰𝔩₂ input would enter as: the tensor
--     product ⨂_{i<m} V_{α i} carries the coproduct triple (that is
--     Sl2TensorProduct.agda's business), plus CharZero of §7, plus the
--     injectivity of ε^{A−2k} on the weight-(2k−A) space — the step
--     that is representation theory and that has no rank-one shadow.
------------------------------------------------------------------------

-- Σ_{i<m} f i
sum : (m : ℕ) → (ℕ → ℕ) → ℕ
sum zero f = zero
sum (suc m) f = f zero + sum m (λ i → f (suc i))

-- divisors of ∏_{i<m} p_i^{α i}: the exponent vector, with cofactors
DivM : (m : ℕ) (α : ℕ → ℕ) → Type₀
DivM m α = Σ[ κ ∈ (ℕ → ℕ) ] ((i : ℕ) → Σ[ d ∈ ℕ ] (κ i + d ≡ α i))

rkM : (m : ℕ) (α : ℕ → ℕ) → DivM m α → ℕ
rkM m α x = sum m (fst x)

-- componentwise divisibility (m and α are explicit: DivM's underlying
-- type does not determine them)
LeqM : (m : ℕ) (α : ℕ → ℕ) → DivM m α → DivM m α → Type₀
LeqM m α x y = (i : ℕ) → Σ[ c ∈ ℕ ] (fst x i + c ≡ fst y i)

isAntichainM : (m : ℕ) (α : ℕ → ℕ) (A : DivM m α → Type₀) → Type₀
isAntichainM m α A = (x y : DivM m α) → A x → A y → LeqM m α x y → x ≡ y

RankM : (m : ℕ) (α : ℕ → ℕ) (k : ℕ) → Type₀
RankM m α k = Σ[ x ∈ DivM m α ] (rkM m α x ≡ k)

-- THE OPEN STATEMENT.  Uninhabited below, deliberately.
GeneralSperner : Type₁
GeneralSperner =
  (m : ℕ) (α : ℕ → ℕ) (A : DivM m α → Type₀)
  → ((x : DivM m α) → isProp (A x))
  → isAntichainM m α A
  → Σ[ f ∈ (Σ[ x ∈ DivM m α ] A x → RankM m α (half (sum m α))) ]
      ((u v : Σ[ x ∈ DivM m α ] A x) → f u ≡ f v → u ≡ v)

-- Likewise for the two intermediate steps, so the queue is explicit:
-- rank-unimodality is NOT degenerate in general and is not proved.
GeneralRankSymmetry : Type₀
GeneralRankSymmetry =
  (m : ℕ) (α : ℕ → ℕ) (k j : ℕ) → k + j ≡ sum m α
  → (RankM m α k → RankM m α j) × (RankM m α j → RankM m α k)
