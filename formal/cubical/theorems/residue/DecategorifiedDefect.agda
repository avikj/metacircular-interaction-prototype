{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DecategorifiedDefect
--
-- an invariant that detects a defect in ONE DIRECTION ONLY, and the
-- resulting unsoundness of the certificate "the invariant vanished,
-- therefore the construction is sufficient".
--
-- The note adjudicates D0020 §7's splicing defect ⋏_Σ₁ against D0019
-- §D's δ_𝔗.  Its Theorem 4.2, under the note's hypothesis (H), reads
--
--     ⋏_Σ₁ = [δ_𝔗]  in  K₀(ℬ(Σ₀,Σ₂)),    hence  δ_𝔗 ≃ 0 ⟹ ⋏ = 0,
--
-- and its §4.3 refutes the converse with the two-line witness in
-- D^b(Vect_k): α₀₁₂ = 0 between two copies of k gives
-- cofib(0) = k ⊕ k[1] ≄ 0 while χ(k ⊕ k[1]) = 1 − 1 = 0.  The note's
-- §4.3 conclusion — §7's own conditional "⋏ = 0 ⟹ Σ₁ sufficient" is
-- UNSOUND, its contrapositive sound — is what this module makes a term.
--
-- WHAT IS FORMALIZED, AND WHAT IS NOT
--
-- Formalized: the information-loss structure.  A "defect" valued in a
-- type D with a distinguished zero, an invariant χ : D → A killing that
-- zero, and the exact logical asymmetry between the two directions.
--
-- NOT formalized: stable ∞-categories, cofiber sequences, K₀, or the
-- Grothendieck group of D^b(Vect_k).  §2 below is a FAITHFUL FINITE
-- MODEL of the K₀ argument and is not the derived-category statement
-- itself: it replaces an object of D^b(Vect_k) with the pair of its
-- even/odd total ranks, ℕ × ℕ, replaces K₀ ≅ ℤ-by-Euler-characteristic
-- with the honest difference m − n : ℤ, and replaces the note's
-- k ⊕ k[1] with (1 , 1).  Under that replacement the note's witness is
-- reproduced exactly: the model's χ(1,1) = 1 − 1 = 0 while
-- (1,1) ≢ (0,0).  What the model does NOT show is that D^b(Vect_k)
-- realizes the pair (1,1) as a cofiber — that is the note's §4.3, done
-- with pen, and it is quoted here, not re-proved.  No claim of this
-- module depends on the derived-category reading; every claim of this
-- module is about the abstract shape, and the finite model is exhibited
-- only to show that shape is INHABITED, i.e. that the failure of the
-- converse is not vacuous.
--
-- CONTENTS
--
--   §1  the abstract setting and the two directions
--       vanishes→χ-vanishes   trivial direction: d ≡ 0 ⟹ χ d ≡ 0
--       ReflectsZero          the property the converse needs
--       reflects→converse     ... and with it, the converse
--       Unsound               a witness that the certificate is bad
--       unsound→¬reflects     a witness refutes reflection
--       sound-contrapositive  χ d ≢ 0 ⟹ d ≢ 0, unconditionally
--       unsound-certificate   the certificate rule "χ d ≡ 0 ⟹ d ≡ 0"
--                             is refuted by a witness
--
--   §2  the finite model, and the witness inside it
--       Rank, χℤ, witness-χ-vanishes, witness-nonzero, model-unsound
--
--   §3  exactly when χ reflects zero, in the model:
--       kernel-char : χℤ (m , n) ≡ 0  ≃-in-content-to  m ≡ n
--       — decategorification loses precisely the objects of vanishing
--       Euler characteristic, and no others.
--
--   §4  the abstract converse of §1's unsound→¬reflects, under ¬¬-
--       stability of the zero-test (which holds in the model, D being
--       discrete): no witness ⟹ ReflectsZero.  So "χ reflects zero"
--       and "there is no witness" are the same condition.
------------------------------------------------------------------------

module DecategorifiedDefect where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ ; snotz)
open import Cubical.Data.Int
  using (ℤ ; pos ; _-_ ; -Cancel ; -≡0 ; injPos ; discreteℤ)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Discrete ; yes ; no)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- §1.  A defect, a zero, and an invariant that kills the zero.
--
-- `D` stands for the defect object (the note's δ_𝔗, an object of the
-- stable hom-category), `A` for the receptacle of the invariant (the
-- note's K₀), `χ` for the class map, `0D`/`0A` for the two zeros.  The
-- only hypothesis is χ-zero — which is the note's [0] = 0, Thm 4.2(3).
------------------------------------------------------------------------

module Invariant {D : Type ℓ} {A : Type ℓ'}
                 (0D : D) (0A : A) (χ : D → A)
                 (χ-zero : χ 0D ≡ 0A) where

  -- The easy direction.  This is Thm 4.2(3): δ_𝔗 ≃ 0 ⟹ ⋏ = 0.
  -- It needs nothing beyond functoriality; that is exactly why it is
  -- the direction that holds.
  vanishes→χ-vanishes : (d : D) → d ≡ 0D → χ d ≡ 0A
  vanishes→χ-vanishes d p = cong χ p ∙ χ-zero

  -- The property that the converse REQUIRES: χ is injective at the
  -- zero, i.e. reflects vanishing.  Nothing above supplies it.
  ReflectsZero : Type (ℓ-max ℓ ℓ')
  ReflectsZero = (d : D) → χ d ≡ 0A → d ≡ 0D

  reflects→converse : ReflectsZero → (d : D) → χ d ≡ 0A → d ≡ 0D
  reflects→converse r = r

  -- The sound half of the note's §4.3, unconditionally: the
  -- contrapositive of the easy direction.
  --   ⋏ ≠ 0 ⟹ Σ₁ insufficient.
  sound-contrapositive : (d : D) → ¬ (χ d ≡ 0A) → ¬ (d ≡ 0D)
  sound-contrapositive d h p = h (vanishes→χ-vanishes d p)

  -- A witness that the certificate "χ vanished, so the defect vanished"
  -- is bad: a defect the invariant cannot see.
  Unsound : Type (ℓ-max ℓ ℓ')
  Unsound = Σ[ d ∈ D ] ((χ d ≡ 0A) × (¬ (d ≡ 0D)))

  unsound→¬reflects : Unsound → ¬ ReflectsZero
  unsound→¬reflects (d , q , d≢0) r = d≢0 (r d q)

  -- The statement that matters, spelled without abbreviation: the
  -- inference rule "χ d ≡ 0A, therefore the construction is
  -- sufficient (d ≡ 0D)" is refuted by a witness.  §7's conditional
  -- certifies sufficiency it has not established.
  unsound-certificate : Unsound → ¬ ((d : D) → χ d ≡ 0A → d ≡ 0D)
  unsound-certificate = unsound→¬reflects

------------------------------------------------------------------------
-- §2.  THE WITNESS, in a faithful finite model of the note's §4.3.
--
-- Rank = (even total rank , odd total rank).  Zero object = (0 , 0).
-- Euler characteristic = the difference in ℤ.  The note's cofib(0) for
-- α₀₁₂ = 0 : k → k is k ⊕ k[1], whose ranks are (1 , 1) and whose
-- Euler characteristic is 1 − 1 = 0.
--
-- MODEL, NOT THE STATEMENT.  This does not prove anything about
-- D^b(Vect_k); it proves that the abstract shape of §1 is inhabited by
-- a concrete χ, which is all that is needed to make `Unsound` a
-- theorem rather than a hypothesis.
------------------------------------------------------------------------

Rank : Type₀
Rank = ℕ × ℕ

0Rank : Rank
0Rank = (0 , 0)

-- Euler characteristic: even rank minus odd rank.
χℤ : Rank → ℤ
χℤ (m , n) = pos m - pos n

χℤ-zero : χℤ 0Rank ≡ pos 0
χℤ-zero = refl

open Invariant 0Rank (pos 0) χℤ χℤ-zero public

-- The model of k ⊕ k[1]: one generator in even degree, one in odd.
kk1 : Rank
kk1 = (1 , 1)

-- χ(k ⊕ k[1]) = 1 − 1 = 0, by computation.
witness-χ-vanishes : χℤ kk1 ≡ pos 0
witness-χ-vanishes = refl

-- ... while k ⊕ k[1] ≄ 0.  In the model: (1,1) ≢ (0,0), because the
-- first components would have to agree.
witness-nonzero : ¬ (kk1 ≡ 0Rank)
witness-nonzero p = snotz (cong fst p)

-- Hence the certificate rule is unsound, as a term.
model-unsound : Unsound
model-unsound = kk1 , witness-χ-vanishes , witness-nonzero

model-certificate-unsound : ¬ ((d : Rank) → χℤ d ≡ pos 0 → d ≡ 0Rank)
model-certificate-unsound = unsound-certificate model-unsound

-- The sound half, in the model, is inherited from §1 and is not
-- vacuous: e.g. anything of nonzero Euler characteristic is nonzero.
model-sound-contrapositive :
  (d : Rank) → ¬ (χℤ d ≡ pos 0) → ¬ (d ≡ 0Rank)
model-sound-contrapositive = sound-contrapositive

------------------------------------------------------------------------
-- §3.  Exactly what the decategorification loses.
--
-- In the model the kernel of χ is precisely the diagonal: χ(m,n) = 0
-- iff m ≡ n.  So the objects invisible to the invariant are precisely
-- those of vanishing Euler characteristic, and the failure of the
-- converse is not an accident of one witness — it is the whole
-- diagonal, everything off (0,0) on it being a counterexample.
------------------------------------------------------------------------

χℤ-diag : (m : ℕ) → χℤ (m , m) ≡ pos 0
χℤ-diag m = -Cancel (pos m)

χℤ-kernel : (m n : ℕ) → χℤ (m , n) ≡ pos 0 → m ≡ n
χℤ-kernel m n p = injPos (-≡0 (pos m) (pos n) p)

-- Both directions at once: the kernel is the diagonal.
kernel-char : (m n : ℕ) → (χℤ (m , n) ≡ pos 0 → m ≡ n) × (m ≡ n → χℤ (m , n) ≡ pos 0)
kernel-char m n = χℤ-kernel m n , λ q → subst (λ k → χℤ (m , k) ≡ pos 0) q (χℤ-diag m)

-- Every off-zero point of the diagonal is a further witness; the one
-- of §2 is the least of them.
diag-unsound : (m : ℕ) → ¬ (m ≡ 0) → Unsound
diag-unsound m m≢0 = (m , m) , χℤ-diag m , λ p → m≢0 (cong fst p)

------------------------------------------------------------------------
-- §4.  When does χ reflect zero?  Exactly when there is no witness.
--
-- §1 gave one direction (a witness refutes reflection).  The converse
-- needs ¬¬-stability of the zero-test on D, which holds whenever D is
-- discrete — as it is in the model.  With it, "χ reflects zero" and
-- "no witness exists" are the same condition, so §2's witness is not
-- merely evidence against reflection: it is equivalent to its failure.
------------------------------------------------------------------------

module Characterization {D : Type ℓ} {A : Type ℓ'}
                        (0D : D) (0A : A) (χ : D → A)
                        (χ-zero : χ 0D ≡ 0A)
                        (stable : (d : D) → ¬ ¬ (d ≡ 0D) → d ≡ 0D) where

  -- named, not opened: the top level already has `Invariant`
  -- instantiated at the model, and an unqualified second copy would
  -- make every name below ambiguous.
  private module I = Invariant 0D 0A χ χ-zero

  no-witness→reflects :
    ((d : D) → ¬ ((χ d ≡ 0A) × (¬ (d ≡ 0D)))) → I.ReflectsZero
  no-witness→reflects h d q = stable d (λ d≢0 → h d (q , d≢0))

  reflects→no-witness :
    I.ReflectsZero → (d : D) → ¬ ((χ d ≡ 0A) × (¬ (d ≡ 0D)))
  reflects→no-witness r d (q , d≢0) = d≢0 (r d q)

-- The model satisfies the stability hypothesis, because Rank is
-- discrete; so in the model the characterization is unconditional.
discreteRank : Discrete Rank
discreteRank (m , n) (m' , n') with discreteℕ m m' | discreteℕ n n'
... | yes p | yes q = yes (λ i → p i , q i)
... | yes _ | no ¬q = no (λ r → ¬q (cong snd r))
... | no ¬p | _     = no (λ r → ¬p (cong fst r))

stableRank : (d : Rank) → ¬ ¬ (d ≡ 0Rank) → d ≡ 0Rank
stableRank d h with discreteRank d 0Rank
... | yes p = p
... | no ¬p = ⊥.rec (h ¬p)

module ModelCharacterization =
  Characterization 0Rank (pos 0) χℤ χℤ-zero stableRank

-- And so, closing the circle: in the model χ does NOT reflect zero,
-- and this is now known in the strong form — not "no proof was found",
-- but "reflection is refuted, and refuted by an explicit element".
model-¬reflects : ¬ ReflectsZero
model-¬reflects = unsound→¬reflects model-unsound
