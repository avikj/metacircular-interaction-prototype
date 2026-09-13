{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रमाण-पत्र — the certificate.
--
-- ELIMINATING THE HIDDEN BLOCK OF A LINEAR EQUATION THROUGH AN
-- IDEMPOTENT IS A LOSSLESS CERTIFICATE: the reduced equation on the
-- visible block and the full equation are equivalent FOR EVERY SOURCE,
-- and the forcing map that carries the source transports the operator.
--
-- The standalone reference kernel [S18 §6] checks six matrices
-- (M, E, S, T, R, Z) against five identities and installs the result as
-- an operation.  This module is that certificate in a form a single ring
-- can type: the visible block is cut out by an idempotent `P`, the
-- hidden block by `Q = 1 - P`, and the only datum beyond `M` is an
-- inverse `H` of the hidden block ON the hidden block.  Then the
-- effective operator, the forcing map, the state reconstruction and the
-- source correction are DEFINED from (M, P, H), and every identity the
-- reference checker verifies is PROVED once, for all M, P, H:
--
--     S  =  P M P  -  P M H M P        the Schur complement
--     T  =  P  -  P M H                the forcing map on sources
--     R  =  P  -  H M P                state reconstruction from y
--     Z  =  H                          source correction
--
--   §1  THE FIVE CERTIFICATE IDENTITIES:
--         P R ≡ P ,   P Z ≡ 0 ,   M R ≡ S ,   M Z - 1 ≡ - T ,   R P + Z M ≡ 1 .
--       The third and fourth are what a reduction must satisfy to be a
--       reduction OF M; the fifth is what makes every solution
--       reconstructible.
--
--   §2  THE TRANSPORT LAW:  T M ≡ S .  The map that carries the source
--       carries the operator to its Schur complement.  This is the
--       identity the reference kernel's composition law needs and does
--       not state; here it is a theorem.
--
--   §3  REDUCED SOLUTIONS SOLVE THE FULL EQUATION:
--         S y ≡ T b   ⟹   M (R y + Z b) ≡ b .
--
--   §4  FULL SOLUTIONS REDUCE, AND RECONSTRUCT:
--         M x ≡ b   ⟹   S (P x) ≡ T b   and   x ≡ R (P x) + Z b .
--
--       So the two equations have the same solutions for EVERY b — not
--       a selected numerical source.  Keeping only `S` would not be
--       lossless: `T` and `Z` are what carry the source through.
--
--   §5  and with a left inverse of M, the solution is unique, so a
--       retired (composed) operation and a direct one must agree.
--
-- ON THE HYPOTHESES.  `P · P ≡ P` is the only thing asked of `P`.
-- `H` is asked to live on the hidden block, `H ≡ Q H Q`, and to invert
-- the hidden block there, `Q M H ≡ Q` and `H M Q ≡ Q`.  Nothing about
-- `M` — it need not be invertible, symmetric, or bounded; the ring is
-- arbitrary and noncommutative, so `M`, `P`, `H` may be operators.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–5 in any ring, for every `M`, every
-- idempotent `P`, and every `H` satisfying the three block conditions.
-- NOT claimed: that `H` exists — its existence is the invertibility of
-- the hidden block, which is the analytic content in every application
-- and is carried here as a hypothesis; composition of two eliminations
-- (a separate theorem, with its own intermediate-equation matching
-- condition); anything about causality, nilpotence, or the size of any
-- inverse; and no identification of the ring with any operator algebra.
------------------------------------------------------------------------

module PramanaPatra_BlockEliminationByAnIdempotentIsALosslessCertificateTheReducedAndFullEquationsAreEquivalentForEverySourceAndTheForcingMapTransportsTheOperator where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring

private
  variable
    ℓ : Level

module _ (R : Ring ℓ) where
  open RingStr (snd R)
  open RingTheory R

  private
    A : Type ℓ
    A = ⟨ R ⟩

    infixl 6 _⊖_
    _⊖_ : A → A → A
    x ⊖ y = x + (- y)

    cancelR : (x y : A) → (x + y) ⊖ y ≡ x
    cancelR x y = sym (+Assoc x y (- y)) ∙ cong (x +_) (+InvR y) ∙ +IdR x

  ------------------------------------------------------------------
  -- ० · The idempotent, its complement, and the hidden inverse.
  ------------------------------------------------------------------

  module _ (M P H : A)
           (PP : P · P ≡ P)
           (H-hidden : H ≡ (1r ⊖ P) · H · (1r ⊖ P))
           (H-invR : (1r ⊖ P) · M · H ≡ 1r ⊖ P)
           (H-invL : H · M · (1r ⊖ P) ≡ 1r ⊖ P)
           where

    Q : A
    Q = 1r ⊖ P

    private
      -- the block algebra everything rests on
      P+Q : P + Q ≡ 1r
      P+Q = +Assoc P 1r (- P) ∙ cong (_+ (- P)) (+Comm P 1r) ∙ cancelR 1r P

      PQ : P · Q ≡ 0r
      PQ = ·DistR+ P 1r (- P) ∙ cong₂ _+_ (·IdR P) (-DistR· P P ∙ cong -_ PP) ∙ +InvR P

      QP : Q · P ≡ 0r
      QP = ·DistL+ 1r (- P) P ∙ cong₂ _+_ (·IdL P) (-DistL· P P ∙ cong -_ PP) ∙ +InvR P

      QQ : Q · Q ≡ Q
      QQ = ·DistR+ Q 1r (- P) ∙ cong₂ _+_ (·IdR Q) (-DistR· Q P ∙ cong -_ QP)
         ∙ cong (Q +_) 0Selfinverse ∙ +IdR Q

      -- H lives on the hidden block
      PH : P · H ≡ 0r
      PH = cong (P ·_) H-hidden ∙ ·Assoc P (Q · H) Q ∙ cong (_· Q) (·Assoc P Q H ∙ cong (_· H) PQ ∙ 0LeftAnnihilates H) ∙ 0LeftAnnihilates Q

      HP : H · P ≡ 0r
      HP = cong (_· P) H-hidden ∙ sym (·Assoc (Q · H) Q P) ∙ cong ((Q · H) ·_) QP ∙ 0RightAnnihilates (Q · H)

      QH : Q · H ≡ H
      QH = cong (Q ·_) H-hidden ∙ ·Assoc Q (Q · H) Q ∙ cong (_· Q) (·Assoc Q Q H ∙ cong (_· H) QQ) ∙ sym H-hidden

      HQ : H · Q ≡ H
      HQ = cong (_· Q) H-hidden ∙ sym (·Assoc (Q · H) Q Q) ∙ cong ((Q · H) ·_) QQ ∙ sym H-hidden

      -- splitting an element along P + Q = 1
      splitL : (x : A) → x ≡ P · x + Q · x
      splitL x = sym (·IdL x) ∙ cong (_· x) (sym P+Q) ∙ ·DistL+ P Q x

      splitR : (x : A) → x ≡ x · P + x · Q
      splitR x = sym (·IdR x) ∙ cong (x ·_) (sym P+Q) ∙ ·DistR+ x P Q

    ------------------------------------------------------------------
    -- The four derived maps.
    ------------------------------------------------------------------

    S : A                                -- the Schur complement
    S = P · M · P ⊖ P · M · H · M · P

    T : A                                -- the forcing map
    T = P ⊖ P · M · H

    Rec : A                              -- state reconstruction
    Rec = P ⊖ H · M · P

    Z : A                                -- source correction
    Z = H

    ------------------------------------------------------------------
    -- १ · THE FIVE CERTIFICATE IDENTITIES.
    ------------------------------------------------------------------

    visible-round-trip : P · Rec ≡ P
    visible-round-trip =
        ·DistR+ P P (- (H · M · P))
      ∙ cong₂ _+_ PP (-DistR· P (H · M · P) ∙ cong -_ (·Assoc P (H · M) P ∙ cong (_· P) (·Assoc P H M ∙ cong (_· M) PH ∙ 0LeftAnnihilates M) ∙ 0LeftAnnihilates P))
      ∙ cong (P +_) 0Selfinverse
      ∙ +IdR P

    no-visible-correction : P · Z ≡ 0r
    no-visible-correction = PH

    private
      -- M H splits as P M H + Q, and H M as H M P + Q
      MH-split : M · H ≡ P · M · H + Q
      MH-split = splitL (M · H) ∙ cong₂ _+_ (·Assoc P M H) (·Assoc Q M H ∙ H-invR)

      HM-split : H · M ≡ H · M · P + Q
      HM-split = splitR (H · M) ∙ cong (H · M · P +_) H-invL

    reduction-of-M : M · Rec ≡ S
    reduction-of-M =
        splitL (M · Rec)
      ∙ cong₂ _+_ visible hidden
      ∙ +IdR S
      where
        visible : P · (M · Rec) ≡ S
        visible =
            cong (P ·_) (·DistR+ M P (- (H · M · P)) ∙ cong (M · P +_) (-DistR· M (H · M · P)))
          ∙ ·DistR+ P (M · P) (- (M · (H · M · P)))
          ∙ cong₂ _+_ (·Assoc P M P)
                      ( -DistR· P (M · (H · M · P))
                      ∙ cong -_ ( ·Assoc P M (H · M · P)
                                ∙ ·Assoc (P · M) (H · M) P
                                ∙ cong (_· P) (·Assoc (P · M) H M) ) )

        hidden : Q · (M · Rec) ≡ 0r
        hidden =
            cong (Q ·_) (·DistR+ M P (- (H · M · P)) ∙ cong (M · P +_) (-DistR· M (H · M · P)))
          ∙ ·DistR+ Q (M · P) (- (M · (H · M · P)))
          ∙ cong₂ _+_ (·Assoc Q M P)
                      ( -DistR· Q (M · (H · M · P))
                      ∙ cong -_ ( ·Assoc Q M (H · M · P)
                                ∙ cong ((Q · M) ·_) (sym (·Assoc H M P))
                                ∙ ·Assoc (Q · M) H (M · P)
                                ∙ cong (_· (M · P)) H-invR
                                ∙ ·Assoc Q M P ) )
          ∙ +InvR (Q · M · P)

    source-equation : M · Z ⊖ 1r ≡ - T
    source-equation =
        cong (_⊖ 1r) MH-split
      ∙ cong (λ z → (P · M · H + Q) + (- z)) (sym P+Q)
      ∙ cong ((P · M · H + Q) +_) (sym (-Dist P Q))
      ∙ +ShufflePairs (P · M · H) Q (- P) (- Q)
      ∙ cong ((P · M · H + (- P)) +_) (+InvR Q)
      ∙ +IdR (P · M · H + (- P))
      ∙ +Comm (P · M · H) (- P)
      ∙ cong ((- P) +_) (sym (-Idempotent (P · M · H)))
      ∙ -Dist P (- (P · M · H))

    every-solution-reconstructs : Rec · P + Z · M ≡ 1r
    every-solution-reconstructs =
        cong₂ _+_ RecP HM-split
      ∙ sym (+Assoc P (- (H · M · P)) (H · M · P + Q))
      ∙ cong (P +_) (+Assoc (- (H · M · P)) (H · M · P) Q)
      ∙ cong (λ z → P + (z + Q)) (+InvL (H · M · P))
      ∙ cong (P +_) (+IdL Q)
      ∙ P+Q
      where
        RecP : Rec · P ≡ P ⊖ H · M · P
        RecP =
            ·DistL+ P (- (H · M · P)) P
          ∙ cong₂ _+_ PP (-DistL· (H · M · P) P ∙ cong -_ (sym (·Assoc (H · M) P P) ∙ cong (H · M ·_) PP))

    ------------------------------------------------------------------
    -- २ · THE TRANSPORT LAW:  T M ≡ S.
    ------------------------------------------------------------------

    private
      SP : S · P ≡ S
      SP =
          ·DistL+ (P · M · P) (- (P · M · H · M · P)) P
        ∙ cong₂ _+_ (sym (·Assoc (P · M) P P) ∙ cong (P · M ·_) PP)
                    (-DistL· (P · M · H · M · P) P ∙ cong -_ (sym (·Assoc (P · M · H · M) P P) ∙ cong (P · M · H · M ·_) PP))

    transport-law : T · M ≡ S
    transport-law =
        ·DistL+ P (- (P · M · H)) M
      ∙ cong₂ _+_ (splitR (P · M))
                  ( -DistL· (P · M · H) M
                  ∙ cong -_ ( sym (·Assoc (P · M) H M)
                            ∙ cong (P · M ·_) HM-split
                            ∙ ·DistR+ (P · M) (H · M · P) Q
                            ∙ cong (_+ P · M · Q) (·Assoc (P · M) (H · M) P ∙ cong (_· P) (·Assoc (P · M) H M)) ) )
      ∙ cong ((P · M · P + P · M · Q) +_) (sym (-Dist (P · M · H · M · P) (P · M · Q)))
      ∙ +ShufflePairs (P · M · P) (P · M · Q) (- (P · M · H · M · P)) (- (P · M · Q))
      ∙ cong ((P · M · P ⊖ P · M · H · M · P) +_) (+InvR (P · M · Q))
      ∙ +IdR S

    ------------------------------------------------------------------
    -- ३ · A REDUCED SOLUTION SOLVES THE FULL EQUATION.
    ------------------------------------------------------------------

    reduced-solves-full : (y b : A) → S · y ≡ T · b → M · (Rec · y + Z · b) ≡ b
    reduced-solves-full y b h =
        ·DistR+ M (Rec · y) (Z · b)
      ∙ cong₂ _+_ (·Assoc M Rec y ∙ cong (_· y) reduction-of-M ∙ h)
                  (·Assoc M H b ∙ cong (_· b) MH-split ∙ ·DistL+ (P · M · H) Q b)
      ∙ cong (_+ (P · M · H · b + Q · b)) (·DistL+ P (- (P · M · H)) b)
      ∙ cong (λ z → (P · b + z) + (P · M · H · b + Q · b)) (-DistL· (P · M · H) b)
      ∙ sym (+Assoc (P · b) (- (P · M · H · b)) (P · M · H · b + Q · b))
      ∙ cong (P · b +_) (+Assoc (- (P · M · H · b)) (P · M · H · b) (Q · b))
      ∙ cong (λ z → P · b + (z + Q · b)) (+InvL (P · M · H · b))
      ∙ cong (P · b +_) (+IdL (Q · b))
      ∙ sym (splitL b)

    ------------------------------------------------------------------
    -- ४ · A FULL SOLUTION REDUCES, AND IS RECONSTRUCTED.
    ------------------------------------------------------------------

    full-reduces : (x b : A) → M · x ≡ b → S · (P · x) ≡ T · b
    full-reduces x b h =
        ·Assoc S P x
      ∙ cong (_· x) (SP ∙ sym transport-law)
      ∙ sym (·Assoc T M x)
      ∙ cong (T ·_) h

    full-reconstructs : (x b : A) → M · x ≡ b → x ≡ Rec · (P · x) + Z · b
    full-reconstructs x b h =
        sym (·IdL x)
      ∙ cong (_· x) (sym every-solution-reconstructs)
      ∙ ·DistL+ (Rec · P) (Z · M) x
      ∙ cong₂ _+_ (sym (·Assoc Rec P x)) (sym (·Assoc Z M x) ∙ cong (Z ·_) h)

    ------------------------------------------------------------------
    -- ५ · WITH A LEFT INVERSE OF M THE SOLUTION IS UNIQUE, so a retired
    --     operation and a direct one agree on every source.
    ------------------------------------------------------------------

    unique-solution : (N x x' b : A) → N · M ≡ 1r
      → M · x ≡ b → M · x' ≡ b → x ≡ x'
    unique-solution N x x' b NM hx hx' =
        sym (·IdL x) ∙ cong (_· x) (sym NM) ∙ sym (·Assoc N M x)
      ∙ cong (N ·_) (hx ∙ sym hx')
      ∙ ·Assoc N M x' ∙ cong (_· x') NM ∙ ·IdL x'
