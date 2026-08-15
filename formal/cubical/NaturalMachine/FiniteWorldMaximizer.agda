{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.FiniteWorldMaximizer
--
-- The general finite no-go of `notes/ENCOUNTERED_WORLDS.md` §2 WITH ITS
-- NONVANISHING HYPOTHESIS MADE PART OF THE TYPE.
--
-- SOURCE STATEMENT (`notes/ENCOUNTERED_WORLDS.md:62`, verbatim):
--
--   **Theorem.** For every integral polynomial `f`, every finite `E`
--   with `f != 0` on `E` has a point that fails to transport: any point
--   maximizing `v_p(f)`.
--
-- The audit `notes/FULL_READ_DRAW_5.md` §C1 records that the summary
-- message `workers/20260812T090934.276887Z--claude_ananta--0005.md` §3
-- restates it as "For **every** integral polynomial, every finite `E`
-- has a point that cannot transport — any maximizer of `v_p(f)`",
-- dropping the clause "with `f != 0` on `E`".  Like §C2 (instrumented
-- by `LineWorldTransport` / `Control/QuantifierDrop`) the drop has no
-- lexical signature: the shortened sentence contains no wrong word,
-- only a missing clause.
--
-- WHAT KIND OF DEFECT THIS IS — stated because it differs from C2's and
-- the difference bounds what the instrument can show.  C2's dropped
-- hypothesis makes the surviving sentence FALSE, and `LineWorldTransport`
-- exhibits the counterexample.  C1's dropped hypothesis makes the
-- surviving sentence ILL-FORMED: with `f ≡ 0` on `E` every point has
-- `v_p(f) = ∞`, so the phrase "any maximizer of `v_p(f)`" — which is
-- the message's entire proof — denotes nothing.  The audit says exactly
-- this ("not even well formed").  Accordingly this file makes the
-- nonvanishing certificate an ARGUMENT that the maximizer-producing
-- term cannot be built without, and the control exhibits the checker
-- refusing to build it.  It does NOT claim the conclusion is false
-- without the hypothesis; that would be a different and unavailable
-- claim.
--
-- THIS IS A MODEL, NOT THE FULL SETTING.  Formalized here is the
-- smallest world that carries the distinction:
--
--   * `E` is a two-point set `Pt`; a world is a valuation
--     `W : Pt → Val` with `Val = fin ℕ ⊎ ∞`, where `∞` is `v_p(0)`,
--     the valuation at a point where `f` vanishes;
--   * `NonVanishing W` is the note's clause "`f != 0` on `E`", i.e.
--     every point has finite valuation;
--   * `maximizer` produces, from a world AND that certificate, a point
--     together with a proof that no point of `E` exceeds it — the
--     "point maximizing `v_p(f)`" the theorem's proof names.
--
-- Everything below is a closed computation or a two-case induction on
-- ℕ; there is no fitting and no sampling (CLAUDE.md).  What the model
-- does NOT contain: the transport criterion itself, the Lemma
-- (`y ≡ x mod p^e ⇒ f(y) ≡ f(x) mod p^e`), or any statement about
-- infinite `E`.  It contains exactly the step the summary broke — that
-- the maximizer exists — and nothing else.
--
-- HEADLINE TERMS
--   maximizer               the theorem's witness, hypothesis in the type
--   vanishing-world         the world `f ≡ 0` on `E`
--   vanishing-has-no-certificate   it satisfies no nonvanishing hypothesis
--   dropped-hypothesis-unbuildable  a hypothesis-free maximizer would give one
------------------------------------------------------------------------

module NaturalMachine.FiniteWorldMaximizer where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Bool.Properties using (true≢false)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)

------------------------------------------------------------------------
-- 0.  Order on ℕ, as a computed Bool, with the two facts needed.

le : ℕ → ℕ → Bool
le zero    _       = true
le (suc _) zero    = false
le (suc a) (suc b) = le a b

le-refl : (a : ℕ) → le a a ≡ true
le-refl zero    = refl
le-refl (suc a) = le-refl a

le-flip : (a b : ℕ) → le a b ≡ false → le b a ≡ true
le-flip zero    b       q = ⊥-rec (true≢false q)
le-flip (suc a) zero    _ = refl
le-flip (suc a) (suc b) q = le-flip a b q

dich : (b : Bool) → (b ≡ true) ⊎ (b ≡ false)
dich true  = inl refl
dich false = inr refl

------------------------------------------------------------------------
-- 1.  Worlds.  `E = {x₁,x₂}`; `Val` is ℕ ∪ {∞}, and `∞ = v_p(0)` is the
--     valuation at a point where the observable vanishes.

data Pt : Type where
  x₁ x₂ : Pt

data Val : Type where
  fin : ℕ → Val
  ∞   : Val

World : Type
World = Pt → Val

-- The note's clause "`f != 0` on `E`", pointwise.
IsFin : Val → Type
IsFin (fin _) = Unit
IsFin ∞       = ⊥

NonVanishing : World → Type
NonVanishing W = (q : Pt) → IsFin (W q)

-- The valuation as a number — available only where `f` does not vanish.
num : (v : Val) → IsFin v → ℕ
num (fin n) _ = n

------------------------------------------------------------------------
-- 2.  The theorem's witness: a point no other point exceeds.  The
--     nonvanishing certificate is an argument, so the term cannot be
--     written without it — which is the whole content of the clause the
--     summary dropped.

IsMax : (W : World) (h : NonVanishing W) → Pt → Type
IsMax W h m = (q : Pt) → le (num (W q) (h q)) (num (W m) (h m)) ≡ true

maximizer : (W : World) (h : NonVanishing W) → Σ[ m ∈ Pt ] IsMax W h m
maximizer W h = go (dich (le (num (W x₁) (h x₁)) (num (W x₂) (h x₂))))
  where
  a = num (W x₁) (h x₁)
  b = num (W x₂) (h x₂)
  go : (le a b ≡ true) ⊎ (le a b ≡ false) → Σ[ m ∈ Pt ] IsMax W h m
  go (inl q) = x₂ , λ { x₁ → q ; x₂ → le-refl b }
  go (inr q) = x₁ , λ { x₁ → le-refl a ; x₂ → le-flip a b q }

------------------------------------------------------------------------
-- 3.  The degenerate world the dropped clause was excluding: `f ≡ 0` on
--     `E`, where every point has valuation ∞ and no maximizer exists.

vanishing-world : World
vanishing-world _ = ∞

vanishing-has-no-certificate : NonVanishing vanishing-world → ⊥
vanishing-has-no-certificate h = h x₁

-- Vanishing at a single point is already enough.
half-vanishing-world : World
half-vanishing-world x₁ = fin 3
half-vanishing-world x₂ = ∞

half-vanishing-has-no-certificate : NonVanishing half-vanishing-world → ⊥
half-vanishing-has-no-certificate h = h x₂

------------------------------------------------------------------------
-- 4.  Therefore the hypothesis-dropped reading cannot be a theorem of
--     this model: a maximizer-producing term needing no certificate
--     would produce, at `vanishing-world`, a `num` of `∞`.  Stated as
--     the derivation the control's assertion would license:
--     `NaturalMachine/Control/MaximizerWithoutNonvanishing.agda`
--     asserts exactly the antecedent below and must fail to type-check.

dropped-hypothesis-unbuildable :
  ((W : World) → Σ[ m ∈ Pt ] ((q : Pt) → IsFin (W q))) → ⊥
dropped-hypothesis-unbuildable g with g vanishing-world
... | (_ , h) = h x₁
