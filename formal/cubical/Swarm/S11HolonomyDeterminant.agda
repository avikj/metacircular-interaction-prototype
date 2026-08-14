{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Swarm.S11HolonomyDeterminant   (swarm-0814-11, 2026-08-14)
--
-- THE CONSERVED QUANTITY OF SMITH PATH HOLONOMY.
--
-- notes/SMITH_PATH_HOLONOMY.md §3 lets `G` be the group of
-- automorphisms of coker(D) induced by target holonomies U_p U_{p0}⁻¹
-- and asks which cokernel data descend.  notes/RANK_R_PAYLOAD_NORMAL_-
-- FORM.md §3 shows the events form a REGULAR torsor: the payload
-- ranges over the whole stabilizer, "invisible to the endpoint".
-- Read together they suggest nothing is conserved.  Something is.
--
-- For D = diag(d₁, q·d₁), every H ∈ Γ₀(q) is a representative of the
-- automorphism it induces on coker(D), and so is every H + D·E.  The
-- determinant is therefore only defined modulo d₁ — `detShift` below
-- is that well-definedness, as an exact polynomial identity with the
-- shift written out.  But every H ∈ Γ₀(q) ⊂ GL₂(ℤ) has det H = ε with
-- ε² = 1.  Hence:
--
--   `inducedDet` :  the determinant of ANY representative of a
--                   holonomy-induced automorphism is ≡ ε (mod d₁),
--                   ε a square root of 1 in ℤ.
--
-- This is a nontrivial constraint exactly when (ℤ/d₁)ˣ ≠ {±1}, i.e.
-- exactly when d₁ ∉ {1,2,3,4,6}.  The smallest witness is d₁ = 5:
--
--   `noHolonomyForDiag2` :  D = diag(5,5), coker(D) = (ℤ/5)², and the
--                   automorphism diag(2,1) — determinant 2 — is
--                   induced by NO holonomy whatsoever.  The proof
--                   forces 5 ∣ 3 and refutes it in ℕ.
--
-- So the holonomy group G is neither the small cycle a fixed rewrite
-- schedule exhibits nor all of Aut(coker D): its image lies in the
-- preimage of {±1} under det : Aut(coker D) → (ℤ/d₁)ˣ.  (That this
-- preimage is the exact image, for every D, is proved in
-- collab/swarm/2026-08-14/swarm-0814-11-holonomy-determinant.md;
-- only the necessity half and the witness are machine-checked here.)
--
-- Conventions follow Gamma0Partner / Gamma0Converse: D = diag(d₁,
-- q·d₁), Γ₀(q) = matrices with lower-left entry q·k.  No postulates,
-- no holes; every algebraic step is `solve ℤCommRing`.
------------------------------------------------------------------------

module Swarm.S11HolonomyDeterminant where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; snotz ; injSuc ; +-comm)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.Nat.Divisibility using (m∣n→m≤n)
open import Cubical.Data.Int using (ℤ ; pos ; abs)
open import Cubical.Data.Int.Divisibility using (_∣_ ; ∣→∣ℕ)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open CommRingStr (ℤCommRing .snd)

R : Type
R = fst ℤCommRing

------------------------------------------------------------------------
-- 1.  The determinant is well defined modulo d₁ on representatives.
--
--     C ↦ C + D·E, D = diag(d₁, q·d₁), changes det by a multiple of
--     d₁ -- and the multiplier is exhibited, not merely existentially
--     asserted.
------------------------------------------------------------------------

detShift : (d1 q c11 c12 c21 c22 e11 e12 e21 e22 : R)
  → (c11 + d1 · e11) · (c22 + (q · d1) · e22)
      - (c12 + d1 · e12) · (c21 + (q · d1) · e21)
    ≡ (c11 · c22 - c12 · c21)
      + d1 · ( (e11 · c22 + q · (c11 · e22) + (q · d1) · (e11 · e22))
             - (e12 · c21 + q · (c12 · e21) + (q · d1) · (e12 · e21)) )
detShift = solve ℤCommRing

------------------------------------------------------------------------
-- 2.  Necessity: a holonomy-induced automorphism has determinant ≡ ε
--     (mod d₁) in EVERY representative, with ε = det H, ε² = 1.
--
--     H = (a, b, q·k, e) ∈ Γ₀(q); C = H + D·E is another
--     representative of the same endomorphism of coker(D).
------------------------------------------------------------------------

inducedDet :
    (d1 q a b k e ε e11 e12 e21 e22 : R)
  → a · e - b · (q · k) ≡ ε
  → Σ[ t ∈ R ]
      ( (a + d1 · e11) · (e + (q · d1) · e22)
          - (b + d1 · e12) · ((q · k) + (q · d1) · e21)
        ≡ ε + d1 · t )
inducedDet d1 q a b k e ε e11 e12 e21 e22 p =
    ( ( (e11 · e + q · (a · e22) + (q · d1) · (e11 · e22))
      - (e12 · (q · k) + q · (b · e21) + (q · d1) · (e12 · e21)) )
    , detShift d1 q a b (q · k) e e11 e12 e21 e22
      ∙ cong (_+ d1 · ( (e11 · e + q · (a · e22) + (q · d1) · (e11 · e22))
                      - (e12 · (q · k) + q · (b · e21) + (q · d1) · (e12 · e21)) ))
             p )

------------------------------------------------------------------------
-- 3.  The obstruction bites.  d₁ = 5, q = 1, D = diag(5,5).
--
--     `diag(2,1)` is an automorphism of coker(D) = (ℤ/5)²: it is the
--     class of the matrix (2,0,0,1), and 2·3 ≡ 1 (mod 5).  Suppose
--     some H = (a,b,k,e) ∈ GL₂(ℤ) induced it, i.e. H ≡ (2,0,0,1)
--     entrywise mod 5, with det H = ε and ε² = 1.  Then ε = 2 + 5·t,
--     so 1 = ε² = 4 + 20t + 25t², i.e. (-(4t + 5·t·t))·5 = 3.
------------------------------------------------------------------------

-- ℕ side: 5 does not divide 3.
no5≤3 : ¬ (5 ≤ 3)
no5≤3 (k , p) = snotz (injSuc (injSuc (injSuc (+-comm 5 k ∙ p))))

¬5∣3 : ¬ (pos 5 ∣ pos 3)
¬5∣3 h = no5≤3 (m∣n→m≤n snotz (∣→∣ℕ h))

-- ℤ side: the congruence + unimodularity force exactly that division.
five three : R
five = pos 5
three = pos 3

sqStep : (t : R) → (2 + five · t) · (2 + five · t) ≡ 1
       → (- (4 · t + five · (t · t))) · five ≡ three
sqStep t h = lem t ∙ cong (λ z → 4 - z) (sym h) ∙ arith (2 + five · t)
  where
    lem : (u : R) → (- (4 · u + five · (u · u))) · five
                    ≡ 4 - (2 + five · u) · (2 + five · u)
    lem = solve ℤCommRing
    arith : (v : R) → 4 - 1 ≡ three
    arith _ = refl

noHolonomyForDiag2 :
    (a b k e ε e11 e12 e21 e22 : R)
  → a ≡ 2 + five · e11
  → b ≡ 0 + five · e12
  → k ≡ 0 + five · e21
  → e ≡ 1 + five · e22
  → a · e - b · (1 · k) ≡ ε
  → ε · ε ≡ 1
  → ⊥
noHolonomyForDiag2 a b k e ε e11 e12 e21 e22 pa pb pk pe pdet psq =
  ¬5∣3 ∣ ( - (4 · t + five · (t · t)) , sqStep t εIs ) ∣₁
  where
    t : R
    t = ( (e11 · 1 + 1 · (2 · e22) + (1 · five) · (e11 · e22))
        - (e12 · (1 · 0) + 1 · (0 · e21) + (1 · five) · (e12 · e21)) )

    -- det of the representative (2,0,0,1) shifted by five·E, computed
    -- two ways: through `detShift`, and through the hypotheses.
    viaShift :
      (2 + five · e11) · (1 + (1 · five) · e22)
        - (0 + five · e12) · (0 + (1 · five) · e21)
      ≡ (2 · 1 - 0 · 0) + five · t
    viaShift = detShift five 1 2 0 0 1 e11 e12 e21 e22

    reindex : (2 · 1 - 0 · 0) + five · t ≡ 2 + five · t
    reindex = cong (_+ five · t) two
      where
        two : (2 · 1 - 0 · 0) ≡ 2
        two = solve ℤCommRing

    fromHyp : a · e - b · (1 · k)
            ≡ (2 + five · e11) · (1 + (1 · five) · e22)
                - (0 + five · e12) · (0 + (1 · five) · e21)
    fromHyp i = shape (pa i) (pb i) (pk i) (pe i)
      where
        shape : R → R → R → R → R
        shape A B K E = A · E - B · (1 · K)
        -- at i = i1 the entries are the shifted ones, up to the
        -- ring-normal rearrangement below.

    fix : (2 + five · e11) · (1 + five · (1 · e22))
            - (0 + five · e12) · (0 + (1 · five) · e21)
        ≡ (2 + five · e11) · (1 + (1 · five) · e22)
            - (0 + five · e12) · (0 + (1 · five) · e21)
    fix = solve ℤCommRing

    εIs : (2 + five · t) · (2 + five · t) ≡ 1
    εIs = cong (λ z → z · z)
            (sym (sym pdet ∙ fromHyp ∙ viaShift ∙ reindex))
          ∙ psq
