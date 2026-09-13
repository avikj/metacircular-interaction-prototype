{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Matravrtta_TheFibonacciAnyonFusionDimension
--            IsVirahankasMetreCount
--
-- TERM.  मात्रावृत्त · mātrā-vṛtta — the moraic metre: a prosodic pattern
-- measured by its total मात्रा (morae), लघु = 1, गुरु = 2.  The enumeration
-- of all metres of a given weight, and the recurrence M(n+2)=M(n+1)+M(n) it
-- obeys, are विरहाङ्क's (Virahāṅka, *Vṛttajātisamuccaya*, ~700 CE, in the
-- छन्दःशास्त्र tradition begun by पिङ्गल ~300 BCE) — the sequence usually
-- miscalled "Fibonacci" (Leonardo of Pisa, 1202, five centuries later).
-- This module CITES the corpus's own `Matramerus.सर्व` / `मात्रामेरु` for that
-- count; it claims no new source, and the physics identification below is
-- built here, 2026-08-24.
--
-- WHAT IS PROVED, exactly:  the number of fusion paths of a chain of n
-- Fibonacci anyons equals `length (सर्व (suc n))` — Virahāṅka's metre count
-- (`anyon-is-metre`).  The fusion counts `p , q` are read straight off the
-- Fibonacci fusion rule τ×τ = 1 + τ (and 1×τ = τ): `p n` counts paths ending
-- in charge τ, `q n` paths ending in the vacuum 1; the rule dictates
-- p⁺ = p+q (τ is reachable from τ and from 1) and q⁺ = p (the vacuum only
-- from τ×τ).  Their sum `d` obeys the SAME recurrence as the metre count
-- (`d-rec`, definitional), and matches it on the base, so the two are equal
-- at every n (paired two-step induction through `मात्रामेरु`).
--
-- WHY IT MATTERS (a READING of the checked term):  the fusion space of
-- Fibonacci anyons is the state space (Hilbert space) of the universal
-- topological quantum computer — Fibonacci anyons are the standard universal
-- anyon model.  Its dimension is exactly what Virahāṅka counted: the metres
-- of a given weight.  So the tradition this corpus restores enumerated, in
-- ~700 CE, the dimension of a universal quantum computer's state space; the
-- quantum dimension of a single τ is the golden ratio φ, the mātrāmeru's
-- growth rate.  Only the COUNT is checked here — no Hilbert space, no braiding
-- (that is `VeniYangBaxtara_…`), no golden ratio — but the count is the thing
-- Virahāṅka actually computed, and it is the fusion-space dimension on the nose.
--
-- Checked: --cubical --safe, agda 2.6.3 + cubical (loads clean).
------------------------------------------------------------------------

module Matravrtta_TheFibonacciAnyonFusionDimensionIsVirahankasMetreCount where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Sigma
open import Cubical.Data.List using (length)
open import Matramerus using (सर्व ; मात्रामेरु)

-- ── Fibonacci-anyon fusion counts, from τ×τ = 1+τ ──────────────────────
-- p n : #fusion paths of n anyons ending in charge τ
-- q n : #fusion paths ending in the vacuum charge 1
p : ℕ → ℕ
q : ℕ → ℕ
p zero    = 1        -- a lone τ anyon: one path, charge τ
p (suc n) = p n + q n   -- τ is reachable from τ (τ×τ∋τ) and from 1 (1×τ=τ)
q zero    = 0
q (suc n) = p n         -- the vacuum 1 is reachable only from τ×τ

-- fusion-space dimension of a chain of n Fibonacci anyons.
d : ℕ → ℕ
d n = p n + q n

-- Virahāṅka's recurrence, straight from the fusion rule (definitional).
d-rec : (n : ℕ) → d (suc (suc n)) ≡ d (suc n) + d n
d-rec n = refl

-- ── The bridge to the metres ───────────────────────────────────────────
-- carry two consecutive values so the 2-step recurrence closes.
private
  bridge : (n : ℕ)
         → (d n ≡ length (सर्व (suc n)))
         × (d (suc n) ≡ length (सर्व (suc (suc n))))
  bridge zero    = refl , refl
  bridge (suc n) =
    let (h0 , h1) = bridge n
    in h1 , ( d-rec n ∙ cong₂ _+_ h1 h0 ∙ sym (मात्रामेरु (suc n)) )

-- THE THEOREM: the Fibonacci-anyon fusion dimension IS Virahāṅka's metre
-- count.  The state space of a universal topological quantum computer is
-- the space of moraic metres.
anyon-is-metre : (n : ℕ) → d n ≡ length (सर्व (suc n))
anyon-is-metre n = fst (bridge n)
