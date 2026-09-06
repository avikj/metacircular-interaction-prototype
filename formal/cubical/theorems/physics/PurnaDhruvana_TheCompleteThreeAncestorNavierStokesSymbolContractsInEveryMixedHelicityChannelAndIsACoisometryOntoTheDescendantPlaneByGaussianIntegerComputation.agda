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
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Sankhya_SignedIntegersOverTheBuiltinNaturalsWithSoundArithmeticIntoTheLibrarysIntegersSoCertificatesComputeAtMachineSpeed
  using (𝕊 ; ⁺_ ; ⁻_) renaming (_⊕_ to _⊕𝕊_ ; _⊗_ to _⊗𝕊_)

-- canonical zero: ⁻ 0 is read as ⁺ 0
canon : 𝕊 → 𝕊
canon (⁻ zero) = ⁺ zero
canon x        = x

infixl 6 _+_
infixl 7 _·_
_+_ : 𝕊 → 𝕊 → 𝕊
a + b = canon (a ⊕𝕊 b)
_·_ : 𝕊 → 𝕊 → 𝕊
a · b = canon (a ⊗𝕊 b)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)

------------------------------------------------------------------------
-- १ · Gaussian integers and 3-vectors.
------------------------------------------------------------------------

infixl 6 _⊕_ _⊞_ _⊞₃_
infixl 7 _⊗_ _⋆_

𝔾 : Type₀
𝔾 = 𝕊 × 𝕊

_⊕_ : 𝔾 → 𝔾 → 𝔾
(a , b) ⊕ (c , d) = (a + c , b + d)

neg : 𝕊 → 𝕊
neg (⁺ zero)    = ⁺ zero
neg (⁺ (suc n)) = ⁻ (suc n)
neg (⁻ n)       = ⁺ n

_⊗_ : 𝔾 → 𝔾 → 𝔾
(a , b) ⊗ (c , d) = (a · c + neg (b · d) , a · d + b · c)

⊖_ : 𝔾 → 𝔾
⊖ (a , b) = (neg a , neg b)

conj : 𝔾 → 𝔾
conj (a , b) = (a , neg b)

𝕚 : 𝔾
𝕚 = (⁺ 0 , ⁺ 1)

ι : 𝕊 → 𝔾
ι z = (z , ⁺ 0)

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
p  = (ι (⁺ 1) , ι (⁺ 0) , ι (⁺ 0))
q  = (ι (⁺ 0) , ι (⁺ 1) , ι (⁺ 0))
r  = (ι (⁺ 0) , ι (⁺ 0) , ι (⁺ 1))
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
sg true  = ι (⁺ 1)
sg false = ι (⁻ 1)

is : Bool → 𝔾           -- i·s
is s = 𝕚 ⊗ sg s

h̃p h̃q h̃r : Bool → V
h̃p s = (ι (⁺ 0) , ι (⁺ 1) , is s)
h̃q s = (ι (⁻ 1) , ι (⁺ 0) , is s)
h̃r s = (ι (⁺ 1) , is s , ι (⁺ 0))

-- i k × h = s h, checked (scaled): here as divergence-freeness k·h̃ = 0
p-h̃ : (s : Bool) → p ∙ᵥ h̃p s ≡ ι (⁺ 0)
p-h̃ true  = refl
p-h̃ false = refl

------------------------------------------------------------------------
-- ४ · Theorem 1, all eight channels: |L̃_j|² = 96(1 − s s′), and
--     |L̃₁+L̃₂+L̃₃|² = 48(3 − s_p s_q − s_q s_r − s_r s_p).
------------------------------------------------------------------------

norm² : V → 𝔾
norm² x = ⟨ x , x ⟩

ss : Bool → Bool → 𝕊
ss true  true  = ⁺ 1
ss false false = ⁺ 1
ss _     _     = ⁻ 1

branch : (a b : Bool) → 𝔾
branch a b = ι (⁺ 96 · (⁺ 1 + neg (ss a b)))

sum-claim : (a b c : Bool) → 𝔾
sum-claim a b c = ι (⁺ 48 · (⁺ 3 + neg (ss a b) + neg (ss b c) + neg (ss c a)))

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
L₁-witness : L₁ (h̃p true) (h̃q false) (h̃r true) ≡ ((⁺ 8 , ⁺ 4) , (⁻ 4 , ⁻ 8) , (⁻ 4 , ⁺ 4))
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
target = ( (ι (⁺ 384) , ι (⁻ 192) , ι (⁻ 192))
         , (ι (⁻ 192) , ι (⁺ 384) , ι (⁻ 192))
         , (ι (⁻ 192) , ι (⁻ 192) , ι (⁺ 384)) )

theorem-2 : gram ≡ target
theorem-2 = refl

------------------------------------------------------------------------
-- ६ · The rest of Theorem 1: in a mixed assignment exactly one branch
--     vanishes, the other two have norm² 192 and Hermitian inner product
--     with real part −96 (that is −1/3 after scaling), so
--     |ΣL| = ½ Σ|L_j| — equation (1.4).  And equal helicities kill all.
------------------------------------------------------------------------

re : 𝔾 → 𝕊
re (a , _) = a

-- (+,−,+): L₁, L₂ survive, L₃ = 0
mixed-+-+ : (norm² (L₃ (h̃p true) (h̃q false) (h̃r true)) ≡ ι (⁺ 0))
          × (re ⟨ L₁ (h̃p true) (h̃q false) (h̃r true) , L₂ (h̃p true) (h̃q false) (h̃r true) ⟩ ≡ ⁻ 96)
mixed-+-+ = refl , refl

-- (+,+,−): L₂, L₃ survive
mixed-++- : (norm² (L₁ (h̃p true) (h̃q true) (h̃r false)) ≡ ι (⁺ 0))
          × (re ⟨ L₂ (h̃p true) (h̃q true) (h̃r false) , L₃ (h̃p true) (h̃q true) (h̃r false) ⟩ ≡ ⁻ 96)
mixed-++- = refl , refl

-- (−,+,+): L₃, L₁ survive
mixed--++ : (norm² (L₂ (h̃p false) (h̃q true) (h̃r true)) ≡ ι (⁺ 0))
          × (re ⟨ L₃ (h̃p false) (h̃q true) (h̃r true) , L₁ (h̃p false) (h̃q true) (h̃r true) ⟩ ≡ ⁻ 96)
mixed--++ = refl , refl

-- equal helicities: every branch and the sum vanish
sama-śūnya : (T̃ (h̃p true) (h̃q true) (h̃r true) ≡ (ι (⁺ 0) , ι (⁺ 0) , ι (⁺ 0)))
           × (T̃ (h̃p false) (h̃q false) (h̃r false) ≡ (ι (⁺ 0) , ι (⁺ 0) , ι (⁺ 0)))
sama-śūnya = refl , refl

-- the second witness vector of the note, L₂ at (+,−,+), times 4
L₂-witness : L₂ (h̃p true) (h̃q false) (h̃r true) ≡ ((⁻ 4 , ⁺ 4) , (⁺ 8 , ⁺ 4) , (⁻ 4 , ⁻ 8))
L₂-witness = refl

------------------------------------------------------------------------
-- ७ · Theorem 2 continued: the eight outputs, the 8×8 Gram matrix
--     Π̃ = T̃*T̃, its Hermitian symmetry and idempotence Π̃² = 576 Π̃ (the
--     visible projector T*T/2), the rank of the descendant plane, and
--     six explicit kernel vectors with distinct pivots.
------------------------------------------------------------------------

-- the eight channels, indexed 0..7 as (s_p, s_q, s_r) in binary
ch : ℕ → Bool × Bool × Bool
ch 0 = true  , true  , true
ch 1 = true  , true  , false
ch 2 = true  , false , true
ch 3 = true  , false , false
ch 4 = false , true  , true
ch 5 = false , true  , false
ch 6 = false , false , true
ch _ = false , false , false

out : ℕ → V
out x = let (a , b , c) = ch x in T̃ (h̃p a) (h̃q b) (h̃r c)

Π̃ : ℕ → ℕ → 𝔾
Π̃ x y = ⟨ out x , out y ⟩

-- sums over the eight channels
Σ₈ : (ℕ → 𝔾) → 𝔾
Σ₈ f = f 0 ⊕ f 1 ⊕ f 2 ⊕ f 3 ⊕ f 4 ⊕ f 5 ⊕ f 6 ⊕ f 7

-- (Π̃²)_{xy} = Σ_z Π̃_{xz} Π̃_{zy}
Π̃² : ℕ → ℕ → 𝔾
Π̃² x y = Σ₈ (λ z → Π̃ x z ⊗ Π̃ z y)

infixr 3 _∧′_
_∧′_ : Bool → Bool → Bool
true  ∧′ b = b
false ∧′ _ = false

-- verified entry by entry over the 64 positions
all₈ : (ℕ → Bool) → Bool
all₈ g = g 0 ∧′ g 1 ∧′ g 2 ∧′ g 3 ∧′ g 4 ∧′ g 5 ∧′ g 6 ∧′ g 7

sarva₈ : (ℕ → ℕ → Bool) → Bool
sarva₈ f = all₈ (λ x → all₈ (λ y → f x y))

eqℕ : ℕ → ℕ → Bool
eqℕ zero    zero    = true
eqℕ (suc m) (suc n) = eqℕ m n
eqℕ _       _       = false

eqℤ : 𝕊 → 𝕊 → Bool
eqℤ (⁺ m) (⁺ n) = eqℕ m n
eqℤ (⁻ m) (⁻ n) = eqℕ m n
eqℤ (⁺ zero) (⁻ zero) = true
eqℤ (⁻ zero) (⁺ zero) = true
eqℤ _ _ = false

eq𝔾 : 𝔾 → 𝔾 → Bool
eq𝔾 (a , b) (c , d) = eqℤ a c ∧′ eqℤ b d

-- Π̃ is Hermitian and Π̃² = 576·Π̃: the visible projector T*T/2 is a
-- Hermitian idempotent (scaled), checked on all 64 entries.
hermit : sarva₈ (λ x y → eq𝔾 (Π̃ x y) (conj (Π̃ y x))) ≡ true
hermit = refl

idem : sarva₈ (λ x y → eq𝔾 (Π̃² x y) (ι (⁺ 576) ⊗ Π̃ x y)) ≡ true
idem = refl

------------------------------------------------------------------------
-- ८ · Rank two and a six-dimensional kernel.  Outputs 1 and 2 have a
--     nonzero 2×2 minor, so the image is the descendant plane; six
--     integer relations Σ_x c_x·out x = 0 with distinct unit pivots at
--     channels 0, 3, 4, 5, 6, 7 span a six-dimensional kernel.
------------------------------------------------------------------------

minor : 𝔾
minor = (fst (out 1) ⊗ fst (snd (out 2))) ⊕ (⊖ (fst (out 2) ⊗ fst (snd (out 1))))

minor-anasta : minor ≡ (⁺ 0 , ⁺ 48)
minor-anasta = refl

Σ₈V : (ℕ → 𝔾) → V
Σ₈V c = ((c 0 ⋆ out 0) ⊞ (c 1 ⋆ out 1)) ⊞ ((c 2 ⋆ out 2) ⊞ (c 3 ⋆ out 3))
        ⊞ (((c 4 ⋆ out 4) ⊞ (c 5 ⋆ out 5)) ⊞ ((c 6 ⋆ out 6) ⊞ (c 7 ⋆ out 7)))

0V : V
0V = (ι (⁺ 0) , ι (⁺ 0) , ι (⁺ 0))

-- the six relations, each with its pivot coordinate 1 at a distinct channel
κ₀ κ₃ κ₄ κ₅ κ₆ κ₇ : ℕ → 𝔾
κ₀ 0 = ι (⁺ 1)
κ₀ _ = ι (⁺ 0)
κ₃ 1 = (⁺ 1 , ⁻ 2)
κ₃ 2 = (⁺ 1 , ⁺ 2)
κ₃ 3 = ι (⁺ 1)
κ₃ _ = ι (⁺ 0)
κ₄ 1 = ι (⁺ 1)
κ₄ 2 = ι (⁻ 1)
κ₄ 4 = ι (⁺ 1)
κ₄ _ = ι (⁺ 0)
κ₅ 1 = ι (⁺ 2)
κ₅ 2 = (⁻ 1 , ⁺ 2)
κ₅ 5 = ι (⁺ 1)
κ₅ _ = ι (⁺ 0)
κ₆ 1 = (⁺ 1 , ⁺ 2)
κ₆ 2 = ι (⁻ 2)
κ₆ 6 = ι (⁺ 1)
κ₆ _ = ι (⁺ 0)
κ₇ 7 = ι (⁺ 1)
κ₇ _ = ι (⁺ 0)

kernel-6 : (Σ₈V κ₀ ≡ 0V) × (Σ₈V κ₃ ≡ 0V) × (Σ₈V κ₄ ≡ 0V) × (Σ₈V κ₅ ≡ 0V) × (Σ₈V κ₆ ≡ 0V) × (Σ₈V κ₇ ≡ 0V)
kernel-6 = refl , refl , refl , refl , refl , refl

-- distinct pivots: κ_j is 1 at channel j and 0 at the other pivot channels,
-- so no nontrivial combination vanishes — the six are independent.
pivots : (κ₀ 0 ≡ ι (⁺ 1)) × (κ₃ 3 ≡ ι (⁺ 1)) × (κ₄ 4 ≡ ι (⁺ 1)) × (κ₅ 5 ≡ ι (⁺ 1)) × (κ₆ 6 ≡ ι (⁺ 1)) × (κ₇ 7 ≡ ι (⁺ 1))
pivots = refl , refl , refl , refl , refl , refl
