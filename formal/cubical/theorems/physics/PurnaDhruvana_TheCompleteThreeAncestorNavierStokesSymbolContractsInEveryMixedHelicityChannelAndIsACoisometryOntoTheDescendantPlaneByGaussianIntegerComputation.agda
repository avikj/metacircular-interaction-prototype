{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पूर्ण-ध्रुवण — full polarization.
--
-- The proof note's Theorems 1 and 2: on the torus, for the three
-- ancestors p, q, r = the unit axes and their descendant K = p+q+r, the
-- complete cubic Picard coefficient
--
--   T(u,v,w) = B_{p+q,r}(B_{p,q}(u,v),w) + B_{q+r,p}(B_{q,r}(v,w),u)
--            + B_{r+p,q}(B_{r,p}(w,u),v),
--   B_{a,b}(u,v) = −i P_{a+b}[(b·u)v + (a·v)u],
--
-- satisfies, on unit helical inputs h^s, |L_j|² = (1 − s s′)/3 for each
-- branch and |L₁+L₂+L₃|² = (3 − s_p s_q − s_q s_r − s_r s_p)/6, and as a
-- map p^⊥⊗q^⊥⊗r^⊥ → K^⊥ it is a coisometry: T T* = 2 P_K.
--
-- Everything is Gaussian-integer arithmetic once scaled: P̃_k = |k|² P_k,
-- B̃ = |a+b|² B, h̃ = √2 h.  With |p+q|² = 2 and |K|² = 3 the scaled symbol
-- is T̃ = 6·2√2·T on the scaled inputs, so |L̃_j|² = 96(1 − s s′),
-- |ΣL̃_j|² = 48(3 − Σ s s′), and Σ_x L̃(x)L̃(x)* = 192·(3I − KKᵀ).  All
-- eight helicity assignments and the 3×3 Gram matrix are checked by
-- refl below.
------------------------------------------------------------------------

module PurnaDhruvana_TheCompleteThreeAncestorNavierStokesSymbolContractsInEveryMixedHelicityChannelAndIsACoisometryOntoTheDescendantPlaneByGaussianIntegerComputation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; _+_ ; _·_ ; -_)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)

------------------------------------------------------------------------
-- १ · Gaussian integers and 3-vectors.
------------------------------------------------------------------------

infixl 6 _⊕_ _⊞_ _⊞₃_
infixl 7 _⊗_ _⋆_

𝔾 : Type₀
𝔾 = ℤ × ℤ

_⊕_ : 𝔾 → 𝔾 → 𝔾
(a , b) ⊕ (c , d) = (a + c , b + d)

_⊗_ : 𝔾 → 𝔾 → 𝔾
(a , b) ⊗ (c , d) = (a · c + (- (b · d)) , a · d + b · c)

⊖_ : 𝔾 → 𝔾
⊖ (a , b) = (- a , - b)

conj : 𝔾 → 𝔾
conj (a , b) = (a , - b)

𝕚 : 𝔾
𝕚 = (pos 0 , pos 1)

ι : ℤ → 𝔾
ι z = (z , pos 0)

V : Type₀
V = 𝔾 × 𝔾 × 𝔾

_⊞_ : V → V → V
(a , b , c) ⊞ (d , e , f) = (a ⊕ d , b ⊕ e , c ⊕ f)

_⋆_ : 𝔾 → V → V
z ⋆ (a , b , c) = (z ⊗ a , z ⊗ b , z ⊗ c)

-- complex-bilinear dot product
_∙ᵥ_ : V → V → 𝔾
(a , b , c) ∙ᵥ (d , e , f) = (a ⊗ d) ⊕ (b ⊗ e) ⊕ (c ⊗ f)

-- Hermitian inner product ⟨x, y⟩ = Σ x̄_i y_i
⟨_,_⟩ : V → V → 𝔾
⟨ (a , b , c) , (d , e , f) ⟩ = (conj a ⊗ d) ⊕ (conj b ⊗ e) ⊕ (conj c ⊗ f)

------------------------------------------------------------------------
-- २ · Wavevectors, scaled projectors, scaled interactions.
------------------------------------------------------------------------

p q r K pq qr rp : V
p  = (ι (pos 1) , ι (pos 0) , ι (pos 0))
q  = (ι (pos 0) , ι (pos 1) , ι (pos 0))
r  = (ι (pos 0) , ι (pos 0) , ι (pos 1))
pq = p ⊞ q
qr = q ⊞ r
rp = r ⊞ p
K  = pq ⊞ r

-- P̃_k v = |k|² v − k (k·v), the projector scaled by |k|²
P̃ : V → V → V
P̃ k v = ((k ∙ᵥ k) ⋆ v) ⊞ ((⊖ (k ∙ᵥ v)) ⋆ k)

-- B̃_{a,b}(u,v) = −i P̃_{a+b}[(b·u)v + (a·v)u]
B̃ : V → V → V → V → V
B̃ a b u v = (⊖ 𝕚) ⋆ P̃ (a ⊞ b) (((b ∙ᵥ u) ⋆ v) ⊞ ((a ∙ᵥ v) ⋆ u))

-- the three branches of the complete cubic symbol, scaled
L₁ L₂ L₃ : V → V → V → V
L₁ u v w = B̃ pq r (B̃ p q u v) w
L₂ u v w = B̃ qr p (B̃ q r v w) u
L₃ u v w = B̃ rp q (B̃ r p w u) v

T̃ : V → V → V → V
T̃ u v w = (L₁ u v w ⊞ L₂ u v w) ⊞ L₃ u v w

------------------------------------------------------------------------
-- ३ · Scaled helical bases, √2·h.
------------------------------------------------------------------------

sg : Bool → 𝔾           -- the sign s as a Gaussian integer
sg true  = ι (pos 1)
sg false = ι (negsuc 0)

is : Bool → 𝔾           -- i·s
is s = 𝕚 ⊗ sg s

h̃p h̃q h̃r : Bool → V
h̃p s = (ι (pos 0) , ι (pos 1) , is s)
h̃q s = (ι (negsuc 0) , ι (pos 0) , is s)
h̃r s = (ι (pos 1) , is s , ι (pos 0))

-- i k × h = s h, checked (scaled): here as divergence-freeness k·h̃ = 0
p-h̃ : (s : Bool) → p ∙ᵥ h̃p s ≡ ι (pos 0)
p-h̃ true  = refl
p-h̃ false = refl

------------------------------------------------------------------------
-- ४ · Theorem 1, all eight channels: |L̃_j|² = 96(1 − s s′), and
--     |L̃₁+L̃₂+L̃₃|² = 48(3 − s_p s_q − s_q s_r − s_r s_p).
------------------------------------------------------------------------

norm² : V → 𝔾
norm² x = ⟨ x , x ⟩

ss : Bool → Bool → ℤ
ss true  true  = pos 1
ss false false = pos 1
ss _     _     = negsuc 0

branch : (a b : Bool) → 𝔾
branch a b = ι (pos 96 · (pos 1 + (- ss a b)))

sum-claim : (a b c : Bool) → 𝔾
sum-claim a b c = ι (pos 48 · (pos 3 + (- ss a b) + (- ss b c) + (- ss c a)))

theorem-1 : (a b c : Bool)
          → (norm² (L₁ (h̃p a) (h̃q b) (h̃r c)) ≡ branch a b)
          × (norm² (L₂ (h̃p a) (h̃q b) (h̃r c)) ≡ branch b c)
          × (norm² (L₃ (h̃p a) (h̃q b) (h̃r c)) ≡ branch c a)
          × (norm² (T̃ (h̃p a) (h̃q b) (h̃r c)) ≡ sum-claim a b c)
theorem-1 true  true  true  = refl , refl , refl , refl
theorem-1 true  true  false = refl , refl , refl , refl
theorem-1 true  false true  = refl , refl , refl , refl
theorem-1 true  false false = refl , refl , refl , refl
theorem-1 false true  true  = refl , refl , refl , refl
theorem-1 false true  false = refl , refl , refl , refl
theorem-1 false false true  = refl , refl , refl , refl
theorem-1 false false false = refl , refl , refl , refl

-- the (+,−,+) vectors of the note, times 6/√2 · √2 = 6: L̃ = 6·(√2/6)·z·… read directly
L₁-witness : L₁ (h̃p true) (h̃q false) (h̃r true) ≡ ((pos 8 , pos 4) , (negsuc 3 , negsuc 7) , (negsuc 3 , pos 4))
L₁-witness = refl

------------------------------------------------------------------------
-- ५ · Theorem 2: Σ over the eight helical inputs of L̃ L̃* = 192·(3I − KKᵀ).
------------------------------------------------------------------------

outer : V → V → V × V × V      -- x yᵀ conjugated in the second slot: rows of x ȳᵀ
outer (a , b , c) y = ((a ⋆ conjV y) , (b ⋆ conjV y) , (c ⋆ conjV y))
  where conjV : V → V
        conjV (d , e , f) = (conj d , conj e , conj f)

_⊞₃_ : V × V × V → V × V × V → V × V × V
(a , b , c) ⊞₃ (d , e , f) = (a ⊞ d , b ⊞ e , c ⊞ f)

gram : V × V × V
gram = go (true ∷ false ∷ []) 
  where
  cell : Bool → Bool → Bool → V × V × V
  cell a b c = outer (T̃ (h̃p a) (h̃q b) (h̃r c)) (T̃ (h̃p a) (h̃q b) (h̃r c))
  row : Bool → Bool → V × V × V
  row a b = cell a b true ⊞₃ cell a b false
  plane : Bool → V × V × V
  plane a = row a true ⊞₃ row a false
  go : List Bool → V × V × V
  go _ = plane true ⊞₃ plane false

-- 192·(3I − KKᵀ): diagonal 384, off-diagonal −192
target : V × V × V
target = ( (ι (pos 384) , ι (negsuc 191) , ι (negsuc 191))
         , (ι (negsuc 191) , ι (pos 384) , ι (negsuc 191))
         , (ι (negsuc 191) , ι (negsuc 191) , ι (pos 384)) )

theorem-2 : gram ≡ target
theorem-2 = refl
