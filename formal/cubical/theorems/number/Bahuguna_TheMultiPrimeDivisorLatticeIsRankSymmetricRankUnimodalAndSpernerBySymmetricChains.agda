{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Bahuguna_TheMultiPrimeDivisorLatticeIsRankSymmetricRankUnimodalAndSpernerBySymmetricChains
--
-- "bahuguṇa": of many strands.  The divisor lattice of an arbitrary
-- n = ∏_{i<m} p_i^{α i} is a product of m chains, and this module
-- closes the queue that SpernerFromSl2 leaves open at its §8.
--
-- THE ABSENCE, quoted from SpernerFromSl2 §8, verbatim:
--
--   "THE OPEN STATEMENT.  Uninhabited below, deliberately."
--        GeneralSperner : Type₁
--   "Likewise for the two intermediate steps, so the queue is explicit:
--    rank-unimodality is NOT degenerate in general and is not proved."
--        GeneralRankSymmetry : Type₀
--
-- and, from its header: "THE SCOPE, EXACTLY, and is stated as a type
-- with NO inhabitant (§8): the general case B_n = ⨂_i V_{α_i}, i.e. the
-- divisors of an arbitrary n.  There the conclusion is not degenerate —
-- W_k really varies, unimodality has content".
--
-- WHAT IS PROVED HERE (all --safe, no postulates, no holes, and with the
-- statements of SpernerFromSl2 imported, not restated):
--
--   §1  generalRankSymmetry : GeneralRankSymmetry.   The componentwise
--       mirror x_i ↦ α i − x_i (written with the cofactors, no ∸) is an
--       involution (mirrorM-mirrorM) carrying rank k to rank sum − k
--       (mirrorM-rank); the two maps RankM m α k ⇄ RankM m α j for
--       k + j ≡ sum m α are read off it.
--
--   §2  Symmetric unimodal ℕ-sequences (record SU: symmetry k + j ≡ R ⇒
--       s k ≡ s j, vanishing beyond R, and nestedness u ≤ v, u + v ≤ R ⇒
--       s u ≤ s v; su-inc / su-dec derive "non-decreasing up to half R,
--       non-increasing from half R on").  THE CONVOLUTION LEMMA, box-SU:
--       if s is SU of rank R then box a s, the convolution of s with the
--       all-ones sequence of length a + 1, is SU of rank R + a.  Proved
--       from the difference identity box-diff and the mirror identity
--       drop-mirror, over ℕ with explicit bounds; no real numbers.
--
--   §3  The rank-size sequence N m α (the coefficients of
--       ∏_{i<m} (1 + x + … + x^{α i})), and N-SU : SU (sum m α) (N m α):
--       symmetric (N-symmetric), non-decreasing up to half the sum
--       (N-nondecreasing), non-increasing after (N-nonincreasing),
--       vanishing beyond the sum (N-vanishes).  Instantiated by refl at
--       12 = 2²·3 (1, 2, 2, 1) and 360 = 2³·3²·5 (1, 3, 5, 6, 5, 3, 1).
--
--   §4  RankM-count : RankM m α k ≃ Fin (N m α k) × Tail m α, tying N to
--       the earlier module's own RankM.  A CAVEAT that the earlier module
--       does not state: its DivM m α constrains EVERY coordinate i ∈ ℕ,
--       not only i < m, so DivM m α is ∏_{i<m} [0, α i] × ∏_{i≥m} [0, α i]
--       and RankM m α k is (rank-k part of the finite product) × (tail),
--       the tail being independent of k.  N counts the finite part; when
--       α i = 0 for i ≥ m the tail is contractible and N m α k is the
--       size of RankM m α k outright.
--
--   §5  A symmetric chain decomposition (record SCD) of the product of
--       chains, scdProd, by the de Bruijn – Tengbergen – Kruyswijk step
--       (module Step): from an SCD of P to one of [0, a] × P, chain
--       (c , j) climbing the new coordinate over el c j and then the old
--       chain at height a − j.
--
--   §6  generalSperner : GeneralSperner, exactly as SpernerFromSl2 §8
--       types it: every prop-valued antichain of DivM m α injects into
--       RankM m α (half (sum m α)).  The injection sends x to the middle
--       point of the chain through its finite part, tail unchanged; two
--       elements with the same image lie on one chain, so are
--       comparable, so are equal by the antichain hypothesis.
--
-- WHAT IS NOT PROVED, and is not claimed: nothing here uses 𝔰𝔩₂.  The
-- route is the 1951 combinatorial one (symmetric chains), not Stanley's
-- hard-Lefschetz route through the injectivity of ε^{A−2k}; the CharZero
-- hypothesis of SpernerFromSl2 §7 is therefore never needed and never
-- assumed.  The "tensor product carries the coproduct triple" and
-- "ε^{A−2k} is injective on the weight space" steps of the note's
-- representation-theoretic chain remain exactly as open as before.
--
-- The lower bound "max antichain = W_{⌊Ω/2⌋}" is proved for the FINITE
-- product only (middleRank-isAntichainP, middle-count): the middle rank
-- of Prod m α is an antichain of size N m α (half (sum m α)).  It is
-- FALSE for the earlier module's DivM m α itself, because of the tail:
-- at m = 0 and α ≡ 1 every element has rank 0 = half 0, yet LeqM is the
-- product order on 2^ℕ, not an antichain.  This is a fact about that
-- module's encoding (all coordinates, rank on the first m) and is
-- recorded here rather than papered over.
--
-- PRIOR ART.  de Bruijn – van Ebbenhorst Tengbergen – Kruyswijk, Nieuw
-- Arch. Wiskunde (2) 23 (1951), 191–193, for the decomposition; the
-- unimodality of products of chains by convolution is classical.
-- Nothing here is new mathematics; what is new is the checked term.
------------------------------------------------------------------------

module Bahuguna_TheMultiPrimeDivisorLatticeIsRankSymmetricRankUnimodalAndSpernerBySymmetricChains where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc ; +-comm ; +-assoc
        ; inj-m+ ; inj-+m ; injSuc ; isSetℕ ; snotz ; znots
        ; m+n≡0→m≡0×n≡0)
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr ; ⊎-equiv)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

open import SpernerFromSl2
  using (Div ; rk ; co ; rk+co ; Div≡ ; _⊑_ ; ⊑-refl ; half ; half-split
        ; sum ; DivM ; rkM ; LeqM ; isAntichainM ; RankM
        ; GeneralSperner ; GeneralRankSymmetry)

------------------------------------------------------------------------
-- §0  Arithmetic bookkeeping, stated over variables so that the
--     ℕ-solver can discharge them; applied to arbitrary terms below.
------------------------------------------------------------------------

private
  interchange : (a b c d : ℕ) → (a + b) + (c + d) ≡ (a + c) + (b + d)
  interchange a b c d = solveℕ!

------------------------------------------------------------------------
-- §1  GeneralRankSymmetry: the componentwise mirror.
------------------------------------------------------------------------

sum-+ : (m : ℕ) (f g : ℕ → ℕ) → sum m (λ i → f i + g i) ≡ sum m f + sum m g
sum-+ zero f g = refl
sum-+ (suc m) f g =
  cong ((f zero + g zero) +_) (sum-+ m (λ i → f (suc i)) (λ i → g (suc i)))
  ∙ interchange (f zero) (g zero) (sum m (λ i → f (suc i))) (sum m (λ i → g (suc i)))

mirrorM : (m : ℕ) (α : ℕ → ℕ) → DivM m α → DivM m α
mirrorM m α (κ , c) = (λ i → fst (c i)) , (λ i → κ i , (+-comm (fst (c i)) (κ i) ∙ snd (c i)))

mirrorM-rank : (m : ℕ) (α : ℕ → ℕ) (x : DivM m α)
  → rkM m α (mirrorM m α x) + rkM m α x ≡ sum m α
mirrorM-rank m α (κ , c) =
  sym (sum-+ m (λ i → fst (c i)) κ)
  ∙ cong (sum m) (funExt (λ i → +-comm (fst (c i)) (κ i) ∙ snd (c i)))

mirrorM-mirrorM : (m : ℕ) (α : ℕ → ℕ) (x : DivM m α)
  → mirrorM m α (mirrorM m α x) ≡ x
mirrorM-mirrorM m α (κ , c) =
  ΣPathP (refl , funExt (λ i → Σ≡Prop (λ _ → isSetℕ _ _) refl))

generalRankSymmetry : GeneralRankSymmetry
generalRankSymmetry m α k j kj = fwd , bwd
  where
  lem : (x : DivM m α) → rkM m α x + rkM m α (mirrorM m α x) ≡ sum m α
  lem x = +-comm (rkM m α x) (rkM m α (mirrorM m α x)) ∙ mirrorM-rank m α x
  fwd : RankM m α k → RankM m α j
  fwd (x , q) = mirrorM m α x ,
    inj-m+ {m = k} (cong (_+ rkM m α (mirrorM m α x)) (sym q) ∙ lem x ∙ sym kj)
  bwd : RankM m α j → RankM m α k
  bwd (x , q) = mirrorM m α x ,
    inj-m+ {m = j} (cong (_+ rkM m α (mirrorM m α x)) (sym q) ∙ lem x ∙ sym (+-comm j k ∙ kj))

------------------------------------------------------------------------
-- §2  Symmetric unimodal ℕ-sequences and convolution with a chain.
------------------------------------------------------------------------

-- a sequence s : ℕ → ℕ is symmetric unimodal of total rank R
record SU (R : ℕ) (s : ℕ → ℕ) : Type₀ where
  field
    su-sym  : (k j : ℕ) → k + j ≡ R → s k ≡ s j
    su-van  : (t : ℕ) → s (suc R + t) ≡ zero
    su-nest : (u v : ℕ) → u ≤ v → u + v ≤ R → s u ≤ s v

  -- non-decreasing up to half the rank
  su-inc : (k : ℕ) → suc k + suc k ≤ R → s k ≤ s (suc k)
  su-inc k h = su-nest k (suc k) ≤-sucℕ (≤-trans (≤-+k {m = k} {n = suc k} {k = suc k} ≤-sucℕ) h)

  -- non-increasing from half the rank on
  su-dec : (k : ℕ) → R ≤ k + k → suc k ≤ R → s (suc k) ≤ s k
  su-dec k hR (k' , p) =
    subst2 _≤_ (sym e1) (sym e2) (su-nest k' (suc k') ≤-sucℕ nb)
    where
    e1 : s (suc k) ≡ s k'
    e1 = su-sym (suc k) k' (+-comm (suc k) k' ∙ p)
    e2 : s k ≡ s (suc k')
    e2 = su-sym k (suc k') (+-suc k k' ∙ cong suc (+-comm k k') ∙ sym (+-suc k' k) ∙ p)
    k'≤k : suc k' ≤ k
    k'≤k = ≤-+k-cancel {k = k} (subst (_≤ k + k) (sym p ∙ +-suc k' k) hR)
    nb : k' + suc k' ≤ R
    nb = subst (k' + suc k' ≤_) p (≤-k+ (suc-≤-suc (<-weaken k'≤k)))

open SU public

-- nestedness follows from symmetry and the one-step increase
module _ (R : ℕ) (s : ℕ → ℕ)
         (symm : (k j : ℕ) → k + j ≡ R → s k ≡ s j)
         (inc : (k : ℕ) → k + suc k ≤ R → s k ≤ s (suc k)) where

  private
    climb : (c u : ℕ) → (c + u) + (c + u) ≤ R → s u ≤ s (c + u)
    climb zero u h = ≤-refl
    climb (suc c) u h = ≤-trans (climb c u h') (inc (c + u) h'')
      where
      h' : (c + u) + (c + u) ≤ R
      h' = ≤-trans (≤-+-≤ {m = c + u} {n = suc (c + u)} {l = c + u} {k = suc (c + u)} ≤-sucℕ ≤-sucℕ) h
      h'' : (c + u) + suc (c + u) ≤ R
      h'' = ≤-trans (≤-+k {m = c + u} {n = suc (c + u)} {k = suc (c + u)} ≤-sucℕ) h

  nest-from-inc : (u v : ℕ) → u ≤ v → u + v ≤ R → s u ≤ s v
  nest-from-inc u v (c , cu) uv with splitℕ-≤ (v + v) R
  ... | inl h = subst (λ w → s u ≤ s w) cu (climb c u (subst (λ w → w + w ≤ R) (sym cu) h))
  ... | inr h = subst (s u ≤_) (sym sv) (subst (λ w → s u ≤ s w) c'v' (climb c' u half'))
    where
    v≤R : v ≤ R
    v≤R = ≤-k+-trans uv
    v' : ℕ
    v' = fst v≤R
    p : v' + v ≡ R
    p = snd v≤R
    sv : s v ≡ s v'
    sv = symm v v' (+-comm v v' ∙ p)
    u≤v' : u ≤ v'
    u≤v' = ≤-+k-cancel {k = v} (subst (u + v ≤_) (sym p) uv)
    c' : ℕ
    c' = fst u≤v'
    c'v' : c' + u ≡ v'
    c'v' = snd u≤v'
    sv'<v : suc v' ≤ v
    sv'<v = ≤-+k-cancel {k = v} (subst (_≤ v + v) (sym (cong suc p)) h)
    half' : (c' + u) + (c' + u) ≤ R
    half' = subst (λ w → w + w ≤ R) (sym c'v') (subst (v' + v' ≤_) p (≤-k+ (<-weaken sv'<v)))

mkSU : (R : ℕ) (s : ℕ → ℕ)
  → ((k j : ℕ) → k + j ≡ R → s k ≡ s j)
  → ((t : ℕ) → s (suc R + t) ≡ zero)
  → ((k : ℕ) → k + suc k ≤ R → s k ≤ s (suc k))
  → SU R s
mkSU R s symm van inc = record { su-sym = symm ; su-van = van ; su-nest = nest-from-inc R s symm inc }

-- convolution with the all-ones sequence of length a + 1:
--   box a s k = Σ_{j ≤ a, j ≤ k} s (k − j)   (the coefficients of (1 + x + … + x^a)·s)
box : ℕ → (ℕ → ℕ) → ℕ → ℕ
box zero s k = s k
box (suc a) s zero = s zero
box (suc a) s (suc k) = s (suc k) + box a s k

-- drop a s k = s (k − a), and 0 when k < a
drop : ℕ → (ℕ → ℕ) → ℕ → ℕ
drop zero s k = s k
drop (suc a) s zero = zero
drop (suc a) s (suc k) = drop a s k

box-zero : (a : ℕ) (s : ℕ → ℕ) → box a s zero ≡ s zero
box-zero zero s = refl
box-zero (suc a) s = refl

-- the difference identity: box a s (k+1) − box a s k = s (k+1) − s (k − a)
box-diff : (a : ℕ) (s : ℕ → ℕ) (k : ℕ)
  → box a s (suc k) + drop a s k ≡ box a s k + s (suc k)
box-diff zero s k = +-comm (s (suc k)) (s k)
box-diff (suc a) s zero =
  +-zero _ ∙ cong (s (suc zero) +_) (box-zero a s) ∙ +-comm (s (suc zero)) (s zero)
box-diff (suc a) s (suc k) =
  sym (+-assoc (s (suc (suc k))) (box a s (suc k)) (drop a s k))
  ∙ cong (s (suc (suc k)) +_) (box-diff a s k)
  ∙ +-comm (s (suc (suc k))) _
  ∙ cong (_+ s (suc (suc k))) (+-comm (box a s k) (s (suc k)))

drop-ge : (a : ℕ) (s : ℕ → ℕ) (t : ℕ) → drop a s (a + t) ≡ s t
drop-ge zero s t = refl
drop-ge (suc a) s t = drop-ge a s t

drop-lt : (k c : ℕ) (s : ℕ → ℕ) → drop (suc (k + c)) s k ≡ zero
drop-lt zero c s = refl
drop-lt (suc k) c s = drop-lt k c s

-- a ≤ k, with witness, or k < a, with witness
splitLE : (a k : ℕ) → (Σ[ t ∈ ℕ ] a + t ≡ k) ⊎ (Σ[ c ∈ ℕ ] suc (k + c) ≡ a)
splitLE zero k = inl (k , refl)
splitLE (suc a) zero = inr (a , refl)
splitLE (suc a) (suc k) with splitLE a k
... | inl (t , p) = inl (t , cong suc p)
... | inr (c , p) = inr (c , cong suc p)

private
  ar1 : (a t j : ℕ) → suc (a + t + j) ≡ a + (t + suc j)
  ar1 a t j = solveℕ!
  ar2 : (R k c : ℕ) → R + suc (k + c) ≡ suc (k + (R + c))
  ar2 R k c = solveℕ!
  ar3 : (a t : ℕ) → (a + t) + suc (a + t) ≡ a + (t + suc (a + t))
  ar3 a t = solveℕ!
  ar4 : (g B d : ℕ) → (g + B) + d ≡ B + (g + d)
  ar4 g B d = solveℕ!

module _ (a : ℕ) (R : ℕ) (s : ℕ → ℕ) (S : SU R s) where

  box-top : box a s (R + a) ≡ s R
  box-top = go a
    where
    go : (b : ℕ) → box b s (R + b) ≡ s R
    go zero = cong s (+-zero R)
    go (suc b) = cong (box (suc b) s) (+-suc R b) ∙ cong₂ _+_ (su-van S b) (go b)

  box-van : (t : ℕ) → box a s (suc (R + a) + t) ≡ zero
  box-van = go a
    where
    go : (b : ℕ) (t : ℕ) → box b s (suc (R + b) + t) ≡ zero
    go zero t = cong (λ z → s (suc z + t)) (+-zero R) ∙ su-van S t
    go (suc b) t =
      cong₂ _+_ (cong (λ z → s (suc z)) (sym (+-assoc R (suc b) t)) ∙ su-van S (suc b + t))
                (cong (box b s) (cong (_+ t) (+-suc R b)) ∙ go b t)

  -- the dropped term is the mirror image of the entering term
  drop-mirror : (k j : ℕ) → suc (k + j) ≡ R + a → drop a s k ≡ s (suc j)
  drop-mirror k j p with splitLE a k
  ... | inl (t , q) =
    cong (drop a s) (sym q) ∙ drop-ge a s t
    ∙ su-sym S t (suc j) (inj-+m {m = a} (+-comm (t + suc j) a ∙ sym (ar1 a t j) ∙ cong (λ z → suc (z + j)) q ∙ p))
  ... | inr (c , q) =
    cong (λ z → drop z s k) (sym q) ∙ drop-lt k c s
    ∙ sym (cong s (cong suc jc) ∙ su-van S c)
    where
    jc : j ≡ R + c
    jc = inj-m+ {m = k} (injSuc (p ∙ cong (R +_) (sym q) ∙ ar2 R k c))

  box-sym : (k j : ℕ) → k + j ≡ R + a → box a s k ≡ box a s j
  box-sym zero j p =
    box-zero a s ∙ su-sym S zero R refl ∙ sym box-top ∙ cong (box a s) (sym p)
  box-sym (suc k) j p = inj-+m {m = s (suc j)} (D1 ∙ D2)
    where
    ih : box a s k ≡ box a s (suc j)
    ih = box-sym k (suc j) (+-suc k j ∙ p)
    E : drop a s k ≡ s (suc j)
    E = drop-mirror k j p
    F : drop a s j ≡ s (suc k)
    F = drop-mirror j k (cong suc (+-comm j k) ∙ p)
    D1 : box a s (suc k) + s (suc j) ≡ box a s k + s (suc k)
    D1 = cong (box a s (suc k) +_) (sym E) ∙ box-diff a s k
    D2 : box a s k + s (suc k) ≡ box a s j + s (suc j)
    D2 = cong₂ _+_ ih (sym F) ∙ box-diff a s j

  box-inc : (k : ℕ) → k + suc k ≤ R + a → box a s k ≤ box a s (suc k)
  box-inc k h = fst G , inj-+m {m = drop a s k}
    (ar4 (fst G) (box a s k) (drop a s k) ∙ cong (box a s k +_) (snd G) ∙ sym (box-diff a s k))
    where
    G : drop a s k ≤ s (suc k)
    G with splitLE a k
    ... | inl (t , q) = subst (λ z → drop a s z ≤ s (suc z)) q
      (subst (_≤ s (suc (a + t))) (sym (drop-ge a s t))
        (su-nest S t (suc (a + t)) (≤-suc ≤SumRight)
          (≤-k+-cancel {k = a} (subst (_≤ a + R) (ar3 a t) (subst ((a + t) + suc (a + t) ≤_) (+-comm R a) (subst (λ z → z + suc z ≤ R + a) (sym q) h))))))
    ... | inr (c , q) = subst (_≤ s (suc k)) (sym (cong (λ z → drop z s k) (sym q) ∙ drop-lt k c s)) zero-≤

  box-SU : SU (R + a) (box a s)
  box-SU = mkSU (R + a) (box a s) box-sym box-van box-inc

------------------------------------------------------------------------
-- §3  The rank-size sequence of the product of chains.
------------------------------------------------------------------------

delta : ℕ → ℕ
delta zero = suc zero
delta (suc _) = zero

delta-SU : SU zero delta
delta-SU = mkSU zero delta symm (λ _ → refl) inc
  where
  symm : (k j : ℕ) → k + j ≡ zero → delta k ≡ delta j
  symm k j p = cong delta (fst (m+n≡0→m≡0×n≡0 p) ∙ sym (snd (m+n≡0→m≡0×n≡0 p)))
  inc : (k : ℕ) → k + suc k ≤ zero → delta k ≤ delta (suc k)
  inc k h = ⊥-rec (snotz (sym (+-suc k k) ∙ ≤0→≡0 h))

-- N m α k = #{ x ∈ ∏_{i<m} [0, α i] : Σ x = k }, the coefficients of ∏_{i<m} (1 + x + … + x^{α i})
N : (m : ℕ) (α : ℕ → ℕ) → ℕ → ℕ
N zero α = delta
N (suc m) α = box (α zero) (N m (λ i → α (suc i)))

N-SU : (m : ℕ) (α : ℕ → ℕ) → SU (sum m α) (N m α)
N-SU zero α = delta-SU
N-SU (suc m) α =
  subst (λ R → SU R (N (suc m) α)) (+-comm (sum m (λ i → α (suc i))) (α zero))
        (box-SU (α zero) (sum m (λ i → α (suc i))) (N m (λ i → α (suc i))) (N-SU m (λ i → α (suc i))))

-- the three headline consequences, in the language of the task
N-symmetric : (m : ℕ) (α : ℕ → ℕ) (k j : ℕ) → k + j ≡ sum m α → N m α k ≡ N m α j
N-symmetric m α = su-sym (N-SU m α)

N-nondecreasing : (m : ℕ) (α : ℕ → ℕ) (k : ℕ) → suc k + suc k ≤ sum m α → N m α k ≤ N m α (suc k)
N-nondecreasing m α = su-inc (N-SU m α)

N-nonincreasing : (m : ℕ) (α : ℕ → ℕ) (k : ℕ) → sum m α ≤ k + k → suc k ≤ sum m α → N m α (suc k) ≤ N m α k
N-nonincreasing m α = su-dec (N-SU m α)

N-vanishes : (m : ℕ) (α : ℕ → ℕ) (t : ℕ) → N m α (suc (sum m α) + t) ≡ zero
N-vanishes m α = su-van (N-SU m α)

-- 12 = 2²·3 and 360 = 2³·3²·5
α12 : ℕ → ℕ
α12 zero = 2
α12 (suc zero) = 1
α12 (suc (suc _)) = 0

α360 : ℕ → ℕ
α360 zero = 3
α360 (suc zero) = 2
α360 (suc (suc zero)) = 1
α360 (suc (suc (suc _))) = 0

N12 : (k : ℕ) → ℕ
N12 = N 2 α12

_ : N12 0 ≡ 1
_ = refl
_ : N12 1 ≡ 2
_ = refl
_ : N12 2 ≡ 2
_ = refl
_ : N12 3 ≡ 1
_ = refl
_ : N12 4 ≡ 0
_ = refl

_ : sum 2 α12 ≡ 3
_ = refl

N360 : (k : ℕ) → ℕ
N360 = N 3 α360

_ : N360 0 ≡ 1
_ = refl
_ : N360 1 ≡ 3
_ = refl
_ : N360 2 ≡ 5
_ = refl
_ : N360 3 ≡ 6
_ = refl
_ : N360 4 ≡ 5
_ = refl
_ : N360 5 ≡ 3
_ = refl
_ : N360 6 ≡ 1
_ = refl
_ : N360 7 ≡ 0
_ = refl

_ : sum 3 α360 ≡ 6
_ = refl

------------------------------------------------------------------------
-- §4  Counting: N m α k is the size of the finite part of RankM m α k.
--
--     DivM m α of the earlier module constrains EVERY coordinate i ∈ ℕ
--     (not only i < m), so RankM m α k is  (finite part) × (tail), the
--     tail being the coordinates i ≥ m, which do not enter the rank.
------------------------------------------------------------------------

open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc ; SumFin⊎≃)

-- the finite part: exponent vectors on the coordinates i < m
Prod : (m : ℕ) (α : ℕ → ℕ) → Type₀
Prod zero α = Unit
Prod (suc m) α = Div (α zero) × Prod m (λ i → α (suc i))

rkP : (m : ℕ) (α : ℕ → ℕ) → Prod m α → ℕ
rkP zero α _ = zero
rkP (suc m) α (x , p) = rk x + rkP m (λ i → α (suc i)) p

-- the tail: the coordinates i ≥ m, all of ℕ shifted by m
Tail : (m : ℕ) (α : ℕ → ℕ) → Type₀
Tail m α = DivM zero (λ i → α (m + i))

-- prepending a coordinate
consD : {B : ℕ → Type₀} → B zero → ((i : ℕ) → B (suc i)) → (i : ℕ) → B i
consD b f zero = b
consD b f (suc i) = f i

consD-η-pt : {B : ℕ → Type₀} (f : (i : ℕ) → B i) (i : ℕ) → consD {B = B} (f zero) (λ j → f (suc j)) i ≡ f i
consD-η-pt f zero = refl
consD-η-pt f (suc i) = refl

consD-η : {B : ℕ → Type₀} (f : (i : ℕ) → B i) → consD {B = B} (f zero) (λ j → f (suc j)) ≡ f
consD-η {B = B} f = funExt (consD-η-pt {B = B} f)

module _ (m : ℕ) (α : ℕ → ℕ) where
  private
    α' : ℕ → ℕ
    α' i = α (suc i)

  cons-fun : DivM (suc m) α → Div (α zero) × DivM m α'
  cons-fun (κ , c) = (κ zero , c zero) , ((λ i → κ (suc i)) , (λ i → c (suc i)))

  cons-inv : Div (α zero) × DivM m α' → DivM (suc m) α
  cons-inv ((k , dp) , (κ' , c')) =
    consD {B = λ _ → ℕ} k κ' , consD {B = λ i → Σ[ d ∈ ℕ ] (consD {B = λ _ → ℕ} k κ' i + d ≡ α i)} dp c'

  cons-inv-fun : (x : DivM (suc m) α) → cons-inv (cons-fun x) ≡ x
  cons-inv-fun (κ , c) = ΣPathP (consD-η {B = λ _ → ℕ} κ , λ j i → lem i j)
    where
    lem : (i : ℕ) → PathP (λ j → Σ[ d ∈ ℕ ] (consD-η {B = λ _ → ℕ} κ j i + d ≡ α i))
                          (consD {B = λ i → Σ[ d ∈ ℕ ] (consD {B = λ _ → ℕ} (κ zero) (λ i → κ (suc i)) i + d ≡ α i)} (c zero) (λ i → c (suc i)) i)
                          (c i)
    lem zero = refl
    lem (suc i) = refl

-- the m-fold split of DivM m α into its finite part and its tail
toP : (m : ℕ) (α : ℕ → ℕ) → DivM m α → Prod m α × Tail m α
toP zero α x = tt , x
toP (suc m) α x =
  let y = cons-fun m α x
      z = toP m (λ i → α (suc i)) (snd y)
  in (fst y , fst z) , snd z

fromP : (m : ℕ) (α : ℕ → ℕ) → Prod m α × Tail m α → DivM m α
fromP zero α (_ , x) = x
fromP (suc m) α ((x , p) , t) = cons-inv m α (x , fromP m (λ i → α (suc i)) (p , t))

toP-fromP : (m : ℕ) (α : ℕ → ℕ) (y : Prod m α × Tail m α) → toP m α (fromP m α y) ≡ y
toP-fromP zero α (tt , x) = refl
toP-fromP (suc m) α ((x , p) , t) =
  cong (λ z → (x , fst z) , snd z) (toP-fromP m (λ i → α (suc i)) (p , t))

fromP-toP : (m : ℕ) (α : ℕ → ℕ) (x : DivM m α) → fromP m α (toP m α x) ≡ x
fromP-toP zero α x = refl
fromP-toP (suc m) α x =
  cong (λ z → cons-inv m α (fst (cons-fun m α x) , z)) (fromP-toP m (λ i → α (suc i)) (snd (cons-fun m α x)))
  ∙ cons-inv-fun m α x

-- the rank only sees the finite part
toP-rk : (m : ℕ) (α : ℕ → ℕ) (x : DivM m α) → rkM m α x ≡ rkP m α (fst (toP m α x))
toP-rk zero α x = refl
toP-rk (suc m) α (κ , c) = cong (κ zero +_) (toP-rk m (λ i → α (suc i)) ((λ i → κ (suc i)) , (λ i → c (suc i))))

-- the finite rank set
Cnt : (m : ℕ) (α : ℕ → ℕ) (k : ℕ) → Type₀
Cnt m α k = Σ[ p ∈ Prod m α ] (rkP m α p ≡ k)

RankM-split : (m : ℕ) (α : ℕ → ℕ) (k : ℕ) → Iso (RankM m α k) (Cnt m α k × Tail m α)
RankM-split m α k = iso f g fg gf
  where
  f : RankM m α k → Cnt m α k × Tail m α
  f (x , q) = (fst (toP m α x) , sym (toP-rk m α x) ∙ q) , snd (toP m α x)
  g : Cnt m α k × Tail m α → RankM m α k
  g ((p , q) , t) = fromP m α (p , t) ,
    toP-rk m α (fromP m α (p , t)) ∙ cong (λ z → rkP m α (fst z)) (toP-fromP m α (p , t)) ∙ q
  fg : (y : Cnt m α k × Tail m α) → f (g y) ≡ y
  fg ((p , q) , t) =
    ≡-× (Σ≡Prop (λ _ → isSetℕ _ _) (cong fst (toP-fromP m α (p , t)))) (cong snd (toP-fromP m α (p , t)))
  gf : (x : RankM m α k) → g (f x) ≡ x
  gf (x , q) = Σ≡Prop (λ _ → isSetℕ _ _) (fromP-toP m α x)

-- the recursion box (suc a) s (suc k) = s (suc k) + box a s k, on types
module _ (Q : Type₀) (rq : Q → ℕ) (s : ℕ → ℕ) (e : (n : ℕ) → (Σ[ q ∈ Q ] (rq q ≡ n)) ≃ Fin (s n)) where

  private
    Box : (a k : ℕ) → Type₀
    Box a k = Σ[ xq ∈ Div a × Q ] (rk (fst xq) + rq (snd xq) ≡ k)

    rk0 : (x : Div zero) → rk x ≡ zero
    rk0 x = fst (m+n≡0→m≡0×n≡0 (rk+co x))

    box0 : (k : ℕ) → Iso (Box zero k) (Σ[ q ∈ Q ] (rq q ≡ k))
    box0 k = iso f g fg gf
      where
      f : Box zero k → Σ[ q ∈ Q ] (rq q ≡ k)
      f ((x , q) , p) = q , (cong (_+ rq q) (sym (rk0 x)) ∙ p)
      g : Σ[ q ∈ Q ] (rq q ≡ k) → Box zero k
      g (q , p) = ((zero , zero , refl) , q) , p
      fg : (y : _) → f (g y) ≡ y
      fg (q , p) = Σ≡Prop (λ _ → isSetℕ _ _) refl
      gf : (y : Box zero k) → g (f y) ≡ y
      gf ((x , q) , p) = Σ≡Prop (λ _ → isSetℕ _ _) (≡-× (Div≡ _ x (sym (rk0 x))) refl)

    boxS0 : (a : ℕ) → Iso (Box (suc a) zero) (Σ[ q ∈ Q ] (rq q ≡ zero))
    boxS0 a = iso f g fg gf
      where
      f : Box (suc a) zero → Σ[ q ∈ Q ] (rq q ≡ zero)
      f ((x , q) , p) = q , snd (m+n≡0→m≡0×n≡0 p)
      g : Σ[ q ∈ Q ] (rq q ≡ zero) → Box (suc a) zero
      g (q , p) = ((zero , suc a , refl) , q) , p
      fg : (y : _) → f (g y) ≡ y
      fg (q , p) = Σ≡Prop (λ _ → isSetℕ _ _) refl
      gf : (y : Box (suc a) zero) → g (f y) ≡ y
      gf ((x , q) , p) =
        Σ≡Prop (λ _ → isSetℕ _ _) (≡-× (Div≡ _ x (sym (fst (m+n≡0→m≡0×n≡0 p)))) refl)

    boxSS : (a k : ℕ) → Iso (Box (suc a) (suc k)) ((Σ[ q ∈ Q ] (rq q ≡ suc k)) ⊎ Box a k)
    boxSS a k = iso f g fg gf
      where
      f : Box (suc a) (suc k) → (Σ[ q ∈ Q ] (rq q ≡ suc k)) ⊎ Box a k
      f (((zero , d , p) , q) , r) = inl (q , r)
      f (((suc κ , d , p) , q) , r) = inr (((κ , d , injSuc p) , q) , injSuc r)
      g : (Σ[ q ∈ Q ] (rq q ≡ suc k)) ⊎ Box a k → Box (suc a) (suc k)
      g (inl (q , r)) = ((zero , suc a , refl) , q) , r
      g (inr (((κ , d , p) , q) , r)) = ((suc κ , d , cong suc p) , q) , cong suc r
      fg : (y : _) → f (g y) ≡ y
      fg (inl (q , r)) = refl
      fg (inr (((κ , d , p) , q) , r)) =
        cong inr (Σ≡Prop (λ _ → isSetℕ _ _) (≡-× (Div≡ _ _ refl) refl))
      gf : (y : Box (suc a) (suc k)) → g (f y) ≡ y
      gf (((zero , d , p) , q) , r) = Σ≡Prop (λ _ → isSetℕ _ _) (≡-× (Div≡ _ _ refl) refl)
      gf (((suc κ , d , p) , q) , r) = Σ≡Prop (λ _ → isSetℕ _ _) (≡-× (Div≡ _ _ refl) refl)

  boxCount : (a k : ℕ) → (Σ[ xq ∈ Div a × Q ] (rk (fst xq) + rq (snd xq) ≡ k)) ≃ Fin (box a s k)
  boxCount zero k = isoToEquiv (box0 k) ∙ₑ e k
  boxCount (suc a) zero = isoToEquiv (boxS0 a) ∙ₑ e zero
  boxCount (suc a) (suc k) =
    isoToEquiv (boxSS a k) ∙ₑ ⊎-equiv (e (suc k)) (boxCount a k) ∙ₑ SumFin⊎≃ (s (suc k)) (box a s k)

Cnt-count : (m : ℕ) (α : ℕ → ℕ) (k : ℕ) → Cnt m α k ≃ Fin (N m α k)
Cnt-count zero α zero = isoToEquiv (iso (λ _ → fzero) (λ _ → tt , refl) fg gf)
  where
  fg : (y : Fin 1) → fzero ≡ y
  fg (inl tt) = refl
  fg (inr y) = ⊥-rec y
  gf : (y : Cnt zero α zero) → (tt , refl) ≡ y
  gf (tt , p) = Σ≡Prop (λ _ → isSetℕ _ _) refl
Cnt-count zero α (suc k) = isoToEquiv (iso (λ y → znots (snd y)) ⊥-rec (λ y → ⊥-rec y) (λ y → ⊥-rec (znots (snd y))))
Cnt-count (suc m) α k =
  boxCount (Prod m (λ i → α (suc i))) (rkP m (λ i → α (suc i))) (N m (λ i → α (suc i)))
           (Cnt-count m (λ i → α (suc i))) (α zero) k

-- THE COUNTING STATEMENT for the module's own rank sets:
--   RankM m α k  ≃  Fin (N m α k) × Tail m α,
-- with the tail independent of k; so N m α is the Whitney sequence of the
-- finite product ∏_{i<m} [0, α i] and is symmetric unimodal by §3.
RankM-count : (m : ℕ) (α : ℕ → ℕ) (k : ℕ) → RankM m α k ≃ (Fin (N m α k) × Tail m α)
RankM-count m α k = isoToEquiv (RankM-split m α k) ∙ₑ ≃-× (Cnt-count m α k) (idEquiv _)

------------------------------------------------------------------------
-- §5  Symmetric chain decompositions (de Bruijn – Tengbergen – Kruyswijk).
------------------------------------------------------------------------

open import Cubical.Foundations.HLevels using (isProp× ; isPropΣ)
open import Cubical.Data.Sum using (isProp⊎)
open import SpernerFromSl2 using (isPropFib ; ℕ-total)

-- the order on the finite part, componentwise
LeqP : (m : ℕ) (α : ℕ → ℕ) → Prod m α → Prod m α → Type₀
LeqP zero α _ _ = Unit
LeqP (suc m) α xp yq = (fst xp ⊑ fst yq) × LeqP m (λ i → α (suc i)) (snd xp) (snd yq)

LeqP-refl : (m : ℕ) (α : ℕ → ℕ) (p : Prod m α) → LeqP m α p p
LeqP-refl zero α _ = tt
LeqP-refl (suc m) α (x , p) = ⊑-refl x , LeqP-refl m (λ i → α (suc i)) p

⊑-trans : {a : ℕ} (x y z : Div a) → x ⊑ y → y ⊑ z → x ⊑ z
⊑-trans x y z (c , p) (e , q) = c + e , +-assoc (rk x) c e ∙ cong (_+ e) p ∙ q

LeqP-trans : (m : ℕ) (α : ℕ → ℕ) (p q r : Prod m α) → LeqP m α p q → LeqP m α q r → LeqP m α p r
LeqP-trans zero α _ _ _ _ _ = tt
LeqP-trans (suc m) α (x , p) (y , q) (z , r) (xy , pq) (yz , qr) =
  ⊑-trans x y z xy yz , LeqP-trans m (λ i → α (suc i)) p q r pq qr

-- a symmetric chain decomposition of a graded set (P , rk) of total rank R,
-- ordered by Leq: a family of chains, indexed by Idx, chain c running from
-- rank st c to rank st c + ln c with st c + ln c + st c ≡ R; every element
-- lies on a chain, and distinct chains are disjoint.
record SCD (P : Type₀) (rkQ : P → ℕ) (Leq : P → P → Type₀) (R : ℕ) : Type₁ where
  field
    Idx      : Type₀
    st ln    : Idx → ℕ
    balance  : (c : Idx) → (st c + ln c) + st c ≡ R
    el       : Idx → ℕ → P
    el-rk    : (c : Idx) (t : ℕ) → t ≤ ln c → rkQ (el c t) ≡ st c + t
    el-step  : (c : Idx) (t : ℕ) → suc t ≤ ln c → Leq (el c t) (el c (suc t))
    locate   : (p : P) → Σ[ c ∈ Idx ] Σ[ t ∈ ℕ ] ((t ≤ ln c) × (el c t ≡ p))
    disjoint : (c c' : Idx) (t t' : ℕ) → t ≤ ln c → t' ≤ ln c' → el c t ≡ el c' t' → c ≡ c'

-- the one-point poset
scd-unit : SCD Unit (λ _ → zero) (λ _ _ → Unit) zero
scd-unit = record
  { Idx = Unit ; st = λ _ → zero ; ln = λ _ → zero
  ; balance = λ _ → refl
  ; el = λ _ _ → tt
  ; el-rk = λ _ t h → sym (≤0→≡0 h)
  ; el-step = λ _ t h → ⊥-rec (snotz (≤0→≡0 h))
  ; locate = λ _ → tt , zero , ≤-refl , refl
  ; disjoint = λ _ _ _ _ _ _ _ → refl }

-- the split t ≤ e (witnessed) or e < t (witnessed), and its uniqueness
Sp : (t e : ℕ) → Type₀
Sp t e = (Σ[ u ∈ ℕ ] (t + u ≡ e)) ⊎ (Σ[ u ∈ ℕ ] (suc (e + u) ≡ t))

private
  ar5 : (e u' u : ℕ) → suc (e + u') + u ≡ suc (u' + u) + e
  ar5 e u' u = solveℕ!

isPropSp : (t e : ℕ) → isProp (Sp t e)
isPropSp t e = isProp⊎ (isPropFib e t) right excl
  where
  right : isProp (Σ[ u ∈ ℕ ] (suc (e + u) ≡ t))
  right (u , p) (u' , q) = Σ≡Prop (λ _ → isSetℕ _ _) (inj-m+ {m = e} (injSuc (p ∙ sym q)))
  excl : (Σ[ u ∈ ℕ ] (t + u ≡ e)) → (Σ[ u ∈ ℕ ] (suc (e + u) ≡ t)) → ⊥
  excl (u , p) (u' , q) =
    snotz (Cubical.Data.Nat.m+n≡n→m≡0 (sym (ar5 e u' u) ∙ cong (_+ u) q ∙ p))

-- THE STEP: from a decomposition of P to one of [0, a] × P.  Chain (c , j),
-- 0 ≤ j ≤ min (ln c , a), climbs the new coordinate from 0 to a − j over
-- the point el c j, then climbs the old chain from j to ln c at height a − j.
module Step {P : Type₀} (rkQ : P → ℕ) (Leq : P → P → Type₀) (R : ℕ)
            (S : SCD P rkQ Leq R) (Leq-refl : (p : P) → Leq p p) (a : ℕ) where
  open SCD S

  P' : Type₀
  P' = Div a × P

  rk' : P' → ℕ
  rk' xp = rk (fst xp) + rkQ (snd xp)

  Leq' : P' → P' → Type₀
  Leq' xp yq = (fst xp ⊑ fst yq) × Leq (snd xp) (snd yq)

  Side : Idx × ℕ → Type₀
  Side cj = (Σ[ r ∈ ℕ ] (snd cj + r ≡ ln (fst cj))) × (Σ[ e ∈ ℕ ] (snd cj + e ≡ a))

  isPropSide : (cj : Idx × ℕ) → isProp (Side cj)
  isPropSide (c , j) = isProp× (isPropFib (ln c) j) (isPropFib a j)

  Idx' : Type₀
  Idx' = Σ (Idx × ℕ) Side

  st' : Idx' → ℕ
  st' ((c , j) , _) = st c + j

  ln' : Idx' → ℕ
  ln' (_ , (r , _) , (e , _)) = r + e

  private
    ar6 : (s j r e : ℕ) → ((s + j) + (r + e)) + (s + j) ≡ (j + e) + ((s + (j + r)) + s)
    ar6 s j r e = solveℕ!
    ar7 : (s j e u : ℕ) → e + (s + (j + suc u)) ≡ (s + j) + suc (e + u)
    ar7 s j e u = solveℕ!
    ar8 : (v e u : ℕ) → v + suc (e + u) ≡ (v + suc u) + e
    ar8 v e u = solveℕ!
    ar9 : (j v u : ℕ) → j + (v + suc u) ≡ v + (j + suc u)
    ar9 j v u = solveℕ!

  balance' : (idx : Idx') → (st' idx + ln' idx) + st' idx ≡ a + R
  balance' ((c , j) , (r , rp) , (e , ep)) =
    ar6 (st c) j r e ∙ cong₂ _+_ ep (cong (λ z → (st c + z) + st c) rp ∙ balance c)

  el'-aux : (c : Idx) (j r e : ℕ) (rp : j + r ≡ ln c) (ep : j + e ≡ a) (t : ℕ) → Sp t e → P'
  el'-aux c j r e rp ep t (inl (u , tu)) = (t , u + j , (+-assoc t u j ∙ cong (_+ j) tu ∙ +-comm e j ∙ ep)) , el c j
  el'-aux c j r e rp ep t (inr (u , eu)) = (e , j , (+-comm e j ∙ ep)) , el c (j + suc u)

  el' : Idx' → ℕ → P'
  el' ((c , j) , (r , rp) , (e , ep)) t = el'-aux c j r e rp ep t (splitLE t e)

  -- j ≤ ln c, and j + suc u ≤ ln c on the horizontal part
  j≤ln : (c : Idx) (j r : ℕ) → j + r ≡ ln c → j ≤ ln c
  j≤ln c j r rp = r , (+-comm r j ∙ rp)

  hbound : (c : Idx) (j r e : ℕ) → j + r ≡ ln c → (t u : ℕ) → t ≤ r + e → suc (e + u) ≡ t → j + suc u ≤ ln c
  hbound c j r e rp t u (v , vt) eu =
    v , (sym (ar9 j v u) ∙ cong (j +_) (inj-+m {m = e} (sym (ar8 v e u) ∙ cong (v +_) eu ∙ vt)) ∙ rp)

  el'-aux-rk : (c : Idx) (j r e : ℕ) (rp : j + r ≡ ln c) (ep : j + e ≡ a) (t : ℕ) (w : Sp t e)
    → t ≤ r + e → rk' (el'-aux c j r e rp ep t w) ≡ (st c + j) + t
  el'-aux-rk c j r e rp ep t (inl (u , tu)) h = cong (t +_) (el-rk c j (j≤ln c j r rp)) ∙ +-comm t (st c + j)
  el'-aux-rk c j r e rp ep t (inr (u , eu)) h =
    cong (e +_) (el-rk c (j + suc u) (hbound c j r e rp t u h eu)) ∙ ar7 (st c) j e u ∙ cong ((st c + j) +_) eu

  el'-rk : (idx : Idx') (t : ℕ) → t ≤ ln' idx → rk' (el' idx t) ≡ st' idx + t
  el'-rk ((c , j) , (r , rp) , (e , ep)) t h = el'-aux-rk c j r e rp ep t (splitLE t e) h

  -- rewriting the split to a chosen witness
  el'-at : (c : Idx) (j r e : ℕ) (rp : j + r ≡ ln c) (ep : j + e ≡ a) (t : ℕ) (w : Sp t e)
    → el' ((c , j) , (r , rp) , (e , ep)) t ≡ el'-aux c j r e rp ep t w
  el'-at c j r e rp ep t w = cong (el'-aux c j r e rp ep t) (isPropSp t e (splitLE t e) w)

  el'-step-aux : (c : Idx) (j r e : ℕ) (rp : j + r ≡ ln c) (ep : j + e ≡ a) (t : ℕ) (w : Sp t e)
    → suc t ≤ r + e → Leq' (el'-aux c j r e rp ep t w) (el' ((c , j) , (r , rp) , (e , ep)) (suc t))
  el'-step-aux c j r e rp ep t (inl (zero , tu)) h =
    subst (Leq' (el'-aux c j r e rp ep t (inl (zero , tu))))
          (sym (el'-at c j r e rp ep (suc t) (inr (zero , se))))
          ((zero , tu) , subst (λ z → Leq (el c j) (el c z)) (sym (+-suc j zero ∙ cong suc (+-zero j))) (el-step c j sj≤ln))
    where
    se : suc (e + zero) ≡ suc t
    se = cong suc (+-zero e ∙ sym (sym (+-zero t) ∙ tu))
    sj≤ln : suc j ≤ ln c
    sj≤ln = subst (_≤ ln c) (+-suc j zero ∙ cong suc (+-zero j)) (hbound c j r e rp (suc t) zero h se)
  el'-step-aux c j r e rp ep t (inl (suc u , tu)) h =
    subst (Leq' (el'-aux c j r e rp ep t (inl (suc u , tu))))
          (sym (el'-at c j r e rp ep (suc t) (inl (u , sym (+-suc t u) ∙ tu))))
          ((suc zero , +-suc t zero ∙ cong suc (+-zero t)) , Leq-refl (el c j))
  el'-step-aux c j r e rp ep t (inr (u , eu)) h =
    subst (Leq' (el'-aux c j r e rp ep t (inr (u , eu))))
          (sym (el'-at c j r e rp ep (suc t) (inr (suc u , se))))
          ((zero , +-zero e) , subst (λ z → Leq (el c (j + suc u)) (el c z)) (sym (+-suc j (suc u)))
                                 (el-step c (j + suc u) bnd))
    where
    se : suc (e + suc u) ≡ suc t
    se = cong suc (+-suc e u ∙ eu)
    bnd : suc (j + suc u) ≤ ln c
    bnd = subst (_≤ ln c) (+-suc j (suc u)) (hbound c j r e rp (suc t) (suc u) h se)

  el'-step : (idx : Idx') (t : ℕ) → suc t ≤ ln' idx → Leq' (el' idx t) (el' idx (suc t))
  el'-step ((c , j) , (r , rp) , (e , ep)) t h = el'-step-aux c j r e rp ep t (splitLE t e) h

  private
    ar10 : (y' u v : ℕ) → y' + (suc u + v) ≡ suc (y' + u) + v
    ar10 y' u v = solveℕ!
    ar11 : (v y u : ℕ) → v + (y + suc u) ≡ (suc u + v) + y
    ar11 v y u = solveℕ!

  locate' : (xp : P') → Σ[ idx ∈ Idx' ] Σ[ t ∈ ℕ ] ((t ≤ ln' idx) × (el' idx t ≡ xp))
  locate' ((y , y' , yy') , p) with locate p
  ... | (c , t , (v , vt) , et) with splitLE t y'
  ... | inl (u , tu) =
    ((c , t) , (v , rp) , (u + y , ep)) ,
    y , subst (y ≤_) (sym (+-assoc v u y)) ≤SumRight ,
    el'-at c t v (u + y) rp ep y (inl (u , +-comm y u)) ∙ ≡-× (Div≡ _ _ refl) et
    where
    rp : t + v ≡ ln c
    rp = +-comm t v ∙ vt
    ep : t + (u + y) ≡ a
    ep = +-assoc t u y ∙ cong (_+ y) tu ∙ +-comm y' y ∙ yy'
  ... | inr (u , yu) =
    ((c , y') , (suc u + v , rp) , (y , ep)) ,
    y + suc u , (v , ar11 v y u) ,
    el'-at c y' (suc u + v) y rp ep (y + suc u) (inr (u , sym (+-suc y u)))
    ∙ ≡-× (Div≡ _ _ refl) (cong (el c) (+-suc y' u ∙ yu) ∙ et)
    where
    rp : y' + (suc u + v) ≡ ln c
    rp = ar10 y' u v ∙ cong (_+ v) yu ∙ +-comm t v ∙ vt
    ep : y' + y ≡ a
    ep = +-comm y' y ∙ yy'

  private
    ar13 : (u' t u : ℕ) → suc (u' + u) + t ≡ suc u' + (t + u)
    ar13 u' t u = solveℕ!

  -- the chain index is determined by any of its points
  disjoint-aux : (c c' : Idx) (j r e : ℕ) (rp : j + r ≡ ln c) (ep : j + e ≡ a)
                 (j' r' e' : ℕ) (rp' : j' + r' ≡ ln c') (ep' : j' + e' ≡ a)
                 (t t' : ℕ) (w : Sp t e) (w' : Sp t' e') → t ≤ r + e → t' ≤ r' + e'
               → el'-aux c j r e rp ep t w ≡ el'-aux c' j' r' e' rp' ep' t' w'
               → (c , j) ≡ (c' , j')
  disjoint-aux c c' j r e rp ep j' r' e' rp' ep' t t' (inl (u , tu)) (inl (u' , tu')) h h' q =
    ≡-× cc' (inj-m+ {m = st c} (sym (el-rk c j (j≤ln c j r rp)) ∙ cong rkQ (cong snd q)
                                 ∙ el-rk c' j' (j≤ln c' j' r' rp') ∙ cong (_+ j') (sym (cong st cc'))))
    where
    cc' : c ≡ c'
    cc' = disjoint c c' j j' (j≤ln c j r rp) (j≤ln c' j' r' rp') (cong snd q)
  disjoint-aux c c' j r e rp ep j' r' e' rp' ep' t t' (inl (u , tu)) (inr (u' , eu')) h h' q =
    ⊥-rec (snotz (Cubical.Data.Nat.m+n≡n→m≡0 (ar13 u' t u ∙ cong (suc u' +_) tu ∙ sym ee' ∙ sym te')))
    where
    cc' : c ≡ c'
    cc' = disjoint c c' j (j' + suc u') (j≤ln c j r rp) (hbound c' j' r' e' rp' t' u' h' eu') (cong snd q)
    jj' : j ≡ j' + suc u'
    jj' = inj-m+ {m = st c} (sym (el-rk c j (j≤ln c j r rp)) ∙ cong rkQ (cong snd q)
                             ∙ el-rk c' (j' + suc u') (hbound c' j' r' e' rp' t' u' h' eu') ∙ cong (_+ (j' + suc u')) (sym (cong st cc')))
    te' : t ≡ e'
    te' = cong (rk ∘ fst) q
    -- j + e ≡ a ≡ j' + e', with j = j' + suc u':  e' ≡ suc u' + e
    ee' : e' ≡ suc u' + e
    ee' = inj-m+ {m = j'} (ep' ∙ sym ep ∙ cong (_+ e) jj' ∙ sym (+-assoc j' (suc u') e))
  disjoint-aux c c' j r e rp ep j' r' e' rp' ep' t t' (inr (u , eu)) (inl (u' , tu')) h h' q =
    sym (disjoint-aux c' c j' r' e' rp' ep' j r e rp ep t' t (inl (u' , tu')) (inr (u , eu)) h' h (sym q))
  disjoint-aux c c' j r e rp ep j' r' e' rp' ep' t t' (inr (u , eu)) (inr (u' , eu')) h h' q =
    ≡-× cc' (inj-+m {m = e} (ep ∙ sym ep' ∙ cong (j' +_) (sym ee')))
    where
    cc' : c ≡ c'
    cc' = disjoint c c' (j + suc u) (j' + suc u') (hbound c j r e rp t u h eu) (hbound c' j' r' e' rp' t' u' h' eu') (cong snd q)
    ee' : e ≡ e'
    ee' = cong (rk ∘ fst) q

  disjoint' : (idx idx' : Idx') (t t' : ℕ) → t ≤ ln' idx → t' ≤ ln' idx' → el' idx t ≡ el' idx' t' → idx ≡ idx'
  disjoint' ((c , j) , (r , rp) , (e , ep)) ((c' , j') , (r' , rp') , (e' , ep')) t t' h h' q =
    Σ≡Prop isPropSide (disjoint-aux c c' j r e rp ep j' r' e' rp' ep' t t' (splitLE t e) (splitLE t' e') h h' q)

  scd-step : SCD P' rk' Leq' (a + R)
  scd-step = record
    { Idx = Idx' ; st = st' ; ln = ln' ; balance = balance'
    ; el = el' ; el-rk = el'-rk ; el-step = el'-step
    ; locate = locate' ; disjoint = disjoint' }

-- the symmetric chain decomposition of the product of chains ∏_{i<m} [0, α i]
scdProd : (m : ℕ) (α : ℕ → ℕ) → SCD (Prod m α) (rkP m α) (LeqP m α) (sum m α)
scdProd zero α = scd-unit
scdProd (suc m) α =
  Step.scd-step (rkP m (λ i → α (suc i))) (LeqP m (λ i → α (suc i))) (sum m (λ i → α (suc i)))
                (scdProd m (λ i → α (suc i))) (LeqP-refl m (λ i → α (suc i))) (α zero)

------------------------------------------------------------------------
-- §6  From a symmetric chain decomposition to the Sperner property.
------------------------------------------------------------------------

half-≤ : (n : ℕ) → half n ≤ n
half-≤ zero = ≤-refl
half-≤ (suc zero) = zero-≤
half-≤ (suc (suc n)) = ≤-suc (suc-≤-suc (half-≤ n))

-- half (s + l + s) = s + half l
half-shift : (s l : ℕ) → half ((s + l) + s) ≡ s + half l
half-shift zero l = cong half (+-zero l)
half-shift (suc s) l =
  cong (λ z → half (suc z)) (+-suc (s + l) s) ∙ cong suc (half-shift s l)

module Sperner {P : Type₀} (rkQ : P → ℕ) (Leq : P → P → Type₀) (R : ℕ)
               (S : SCD P rkQ Leq R)
               (Leq-refl : (p : P) → Leq p p)
               (Leq-trans : (p q r : P) → Leq p q → Leq q r → Leq p r) where
  open SCD S

  -- the middle point of chain c
  middle : Idx → P
  middle c = el c (half (ln c))

  middle-rk : (c : Idx) → rkQ (middle c) ≡ half R
  middle-rk c = el-rk c (half (ln c)) (half-≤ (ln c)) ∙ sym (half-shift (st c) (ln c)) ∙ cong half (balance c)

  -- monotonicity along a chain
  el-≤ : (c : Idx) (t d : ℕ) → t + d ≤ ln c → Leq (el c t) (el c (t + d))
  el-≤ c t zero h = subst (λ z → Leq (el c t) (el c z)) (sym (+-zero t)) (Leq-refl (el c t))
  el-≤ c t (suc d) h =
    Leq-trans _ _ _ (el-≤ c t d (≤-trans (≤-k+ ≤-sucℕ) h))
      (subst (λ z → Leq (el c (t + d)) (el c z)) (sym (+-suc t d))
             (el-step c (t + d) (subst (_≤ ln c) (+-suc t d) h)))

  -- two points on one chain are comparable
  same-chain : (c : Idx) (t t' : ℕ) → t ≤ ln c → t' ≤ ln c → Leq (el c t) (el c t') ⊎ Leq (el c t') (el c t)
  same-chain c t t' h h' with ℕ-total t t'
  ... | inl (d , p) = inl (subst (λ z → Leq (el c t) (el c z)) p (el-≤ c t d (subst (_≤ ln c) (sym p) h')))
  ... | inr (d , p) = inr (subst (λ z → Leq (el c t') (el c z)) p (el-≤ c t' d (subst (_≤ ln c) (sym p) h)))

  -- the Sperner map: send each point to the middle of its chain
  g : P → P
  g p = middle (fst (locate p))

  g-rk : (p : P) → rkQ (g p) ≡ half R
  g-rk p = middle-rk (fst (locate p))

  -- points with the same image are comparable
  g-comparable : (p q : P) → g p ≡ g q → Leq p q ⊎ Leq q p
  g-comparable p q e =
    subst2 (λ x y → Leq x y ⊎ Leq y x) (snd (snd (snd (locate p)))) qeq
           (same-chain c t t' (fst (snd (snd (locate p)))) t'≤)
    where
    c : Idx
    c = fst (locate p)
    t : ℕ
    t = fst (snd (locate p))
    c' : Idx
    c' = fst (locate q)
    t' : ℕ
    t' = fst (snd (locate q))
    cc' : c ≡ c'
    cc' = disjoint c c' (half (ln c)) (half (ln c')) (half-≤ (ln c)) (half-≤ (ln c')) e
    t'≤ : t' ≤ ln c
    t'≤ = subst (λ z → t' ≤ ln z) (sym cc') (fst (snd (snd (locate q))))
    qeq : el c t' ≡ q
    qeq = subst (λ z → el z t' ≡ q) (sym cc') (snd (snd (snd (locate q))))

-- the finite-part order transports through fromP, with a fixed tail
fromP-mono : (m : ℕ) (α : ℕ → ℕ) (p p' : Prod m α) (t : Tail m α)
  → LeqP m α p p' → LeqM m α (fromP m α (p , t)) (fromP m α (p' , t))
fromP-mono zero α _ _ t _ i = zero , +-zero _
fromP-mono (suc m) α (x , p) (x' , p') t (xx' , pp') zero = xx'
fromP-mono (suc m) α (x , p) (x' , p') t (xx' , pp') (suc i) =
  fromP-mono m (λ j → α (suc j)) p p' t pp' i

-- THE GENERAL SPERNER PROPERTY, exactly as SpernerFromSl2 §8 states it.
generalSperner : GeneralSperner
generalSperner m α A propA ac = f , inj
  where
  module Sp = Sperner (rkP m α) (LeqP m α) (sum m α) (scdProd m α) (LeqP-refl m α) (LeqP-trans m α)

  pt : DivM m α → Prod m α × Tail m α
  pt = toP m α

  f : Σ[ x ∈ DivM m α ] A x → RankM m α (half (sum m α))
  f (x , _) = fromP m α (Sp.g (fst (pt x)) , snd (pt x)) ,
    toP-rk m α _ ∙ cong (λ z → rkP m α (fst z)) (toP-fromP m α (Sp.g (fst (pt x)) , snd (pt x))) ∙ Sp.g-rk (fst (pt x))

  inj : (u v : Σ[ x ∈ DivM m α ] A x) → f u ≡ f v → u ≡ v
  inj (x , ax) (y , ay) e = Σ≡Prop propA xy
    where
    e2 : (Sp.g (fst (pt x)) , snd (pt x)) ≡ (Sp.g (fst (pt y)) , snd (pt y))
    e2 = sym (toP-fromP m α _) ∙ cong (toP m α) (cong fst e) ∙ toP-fromP m α _
    gxy : Sp.g (fst (pt x)) ≡ Sp.g (fst (pt y))
    gxy = cong fst e2
    txy : snd (pt x) ≡ snd (pt y)
    txy = cong snd e2
    -- LeqP on the finite parts gives LeqM on the originals
    liftLe : LeqP m α (fst (pt x)) (fst (pt y)) → LeqM m α x y
    liftLe le = subst2 (LeqM m α) (fromP-toP m α x)
                     (cong (λ z → fromP m α (fst (pt y) , z)) txy ∙ fromP-toP m α y)
                     (fromP-mono m α (fst (pt x)) (fst (pt y)) (snd (pt x)) le)
    liftLe' : LeqP m α (fst (pt y)) (fst (pt x)) → LeqM m α y x
    liftLe' le = subst2 (LeqM m α)
                      (cong (λ z → fromP m α (fst (pt y) , z)) txy ∙ fromP-toP m α y) (fromP-toP m α x)
                      (fromP-mono m α (fst (pt y)) (fst (pt x)) (snd (pt x)) le)
    xy : x ≡ y
    xy with Sp.g-comparable (fst (pt x)) (fst (pt y)) gxy
    ... | inl le = ac x y ax ay (liftLe le)
    ... | inr le = sym (ac y x ay ax (liftLe' le))

------------------------------------------------------------------------
-- §7  The lower bound, for the finite product: the middle rank of
--     Prod m α is an antichain, of size N m α (half (sum m α)).
------------------------------------------------------------------------

rkP-mono : (m : ℕ) (α : ℕ → ℕ) (p q : Prod m α) → LeqP m α p q → rkP m α p ≤ rkP m α q
rkP-mono zero α _ _ _ = ≤-refl
rkP-mono (suc m) α (x , p) (y , q) ((c , xc) , pq) =
  ≤-+-≤ (c , (+-comm c (rk x) ∙ xc)) (rkP-mono m (λ i → α (suc i)) p q pq)

middleRank-isAntichainP : (m : ℕ) (α : ℕ → ℕ) (p q : Prod m α)
  → rkP m α p ≡ rkP m α q → LeqP m α p q → p ≡ q
middleRank-isAntichainP zero α p q _ _ = refl
middleRank-isAntichainP (suc m) α (x , p) (y , q) e ((c , xc) , pq) =
  ≡-× (Div≡ x y (sym (+-zero (rk x)) ∙ cong (rk x +_) (sym c0) ∙ xc))
      (middleRank-isAntichainP m (λ i → α (suc i)) p q pq-rk pq)
  where
  d : ℕ
  d = fst (rkP-mono m (λ i → α (suc i)) p q pq)
  dp : d + rkP m (λ i → α (suc i)) p ≡ rkP m (λ i → α (suc i)) q
  dp = snd (rkP-mono m (λ i → α (suc i)) p q pq)
  -- rk x + rkP p ≡ rk y + rkP q ≡ rk x + c + rkP q, so rkP p ≡ c + rkP q,
  -- and rkP q ≡ d + rkP p ≡ d + c + rkP q, so c + d ≡ 0
  step1 : rkP m (λ i → α (suc i)) p ≡ c + rkP m (λ i → α (suc i)) q
  step1 = inj-m+ {m = rk x} (e ∙ cong (_+ rkP m (λ i → α (suc i)) q) (sym xc) ∙ sym (+-assoc (rk x) c _))
  step2 : (d + c) + rkP m (λ i → α (suc i)) q ≡ rkP m (λ i → α (suc i)) q
  step2 = sym (+-assoc d c _) ∙ cong (d +_) (sym step1) ∙ dp
  c0 : c ≡ zero
  c0 = snd (m+n≡0→m≡0×n≡0 (Cubical.Data.Nat.m+n≡n→m≡0 step2))
  pq-rk : rkP m (λ i → α (suc i)) p ≡ rkP m (λ i → α (suc i)) q
  pq-rk = step1 ∙ cong (_+ rkP m (λ i → α (suc i)) q) c0

-- the size of the middle rank of the finite product
middle-count : (m : ℕ) (α : ℕ → ℕ) → Cnt m α (half (sum m α)) ≃ Fin (N m α (half (sum m α)))
middle-count m α = Cnt-count m α (half (sum m α))

------------------------------------------------------------------------
-- §8  Instances: 12 = 2²·3 and 360 = 2³·3²·5.
------------------------------------------------------------------------

-- the largest antichain of the divisors of 12 has 2 elements, of 360 has 6
_ : N 2 α12 (half (sum 2 α12)) ≡ 2
_ = refl

_ : N 3 α360 (half (sum 3 α360)) ≡ 6
_ = refl

sperner12 : (A : DivM 2 α12 → Type₀) → ((x : DivM 2 α12) → isProp (A x)) → isAntichainM 2 α12 A
  → Σ[ f ∈ (Σ[ x ∈ DivM 2 α12 ] A x → RankM 2 α12 1) ]
      ((u v : Σ[ x ∈ DivM 2 α12 ] A x) → f u ≡ f v → u ≡ v)
sperner12 = generalSperner 2 α12

sperner360 : (A : DivM 3 α360 → Type₀) → ((x : DivM 3 α360) → isProp (A x)) → isAntichainM 3 α360 A
  → Σ[ f ∈ (Σ[ x ∈ DivM 3 α360 ] A x → RankM 3 α360 3) ]
      ((u v : Σ[ x ∈ DivM 3 α360 ] A x) → f u ≡ f v → u ≡ v)
sperner360 = generalSperner 3 α360

-- the rank sets of 12 and 360 at the middle rank, counted
_ : RankM 2 α12 1 ≃ (Fin 2 × Tail 2 α12)
_ = RankM-count 2 α12 1

_ : RankM 3 α360 3 ≃ (Fin 6 × Tail 3 α360)
_ = RankM-count 3 α360 3
