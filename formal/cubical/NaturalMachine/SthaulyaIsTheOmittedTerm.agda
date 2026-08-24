-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.SthaulyaIsTheOmittedTerm
--
-- स्थौल्य — the coarseness of an अन्त्यसंस्कार — in closed form, for every
-- correction in the hierarchy at once.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS SETTLES
--
-- `AntyaSamskaraSthaulya` checks, one at a time, that the first four
-- end-corrections to Mādhava's series have स्थौल्य numerator constant in
-- n, and says in §7 that the general statement — every convergent, not
-- just four — "is not proved here and is not being asserted from four
-- cases.  It is what the four cases make worth proving, and the proof
-- would have to come from the continued fraction's determinant
-- recurrence, not from the list."
--
-- This module is that proof.  Not from the list, and not four more
-- cases: the degree-10 identity for k = 5 does not get past the ring
-- solver in twenty minutes, which is the checker saying that generating
-- instances was the wrong move.
--
-- ────────────────────────────────────────────────────────────────────
-- THE STATEMENT
--
-- Take the continued fraction whose convergents the transmitted
-- corrections are (K. Krishna, arXiv:2405.11134),
--
--     1/(4n + 2²/(4n + 4²/(4n + 6²/(4n + …)))),
--
-- so the partial numerators are a₁ = 1 and a_j = (2j−2)² for j ≥ 2, and
-- every partial denominator is 4n.  Generate its convergents h_k/k_k by
-- the standard recurrence and DO NOT reduce them.  Then for every k ≥ 1
-- and every n in every commutative ring,
--
--     (h_k(n)·k_k(n+1) + h_k(n+1)·k_k(n))·(2n+1) − k_k(n)·k_k(n+1)
--        =  (−1)^(k−1) · a_{k+1} · (a₁a₂⋯a_k)
--        =  (−1)^(k−1) · 4^k · (k!)².
--
-- `sthaulya-closed` is the first equality, `sthaulya-value` the second,
-- and `sthaulya-independent` states the consequence bluntly: the left
-- side takes the same value at every n.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IT MEANS, AND WHY IT IS THE RIGHT SHAPE
--
-- The स्थौल्य numerator is **the product of every partial numerator the
-- correction uses, times the first one it omits.**  Λ_k is what was
-- taken; a_{k+1} is what was left behind.  A truncation error governed
-- by the first discarded term is the classical shape of a
-- continued-fraction remainder, and it is exactly what the Yuktibhāṣā's
-- criterion is selecting for: the text does not bound the error, it
-- names it and minimises it, and this is what it was minimising.
--
-- Two consequences, both immediate:
--
--   • CONSTANT IN n.  A correction that misses by a fixed integer is a
--     correction; one that misses by something growing with n is an
--     estimate.  All of them are corrections.
--   • EACH STEP IS THE LAST ONE TIMES THE TERM NEWLY OMITTED.
--     `sthaulya-ratio`: D_{k+1} = −a_{k+2}·D_k, an identity, no division
--     and no limit.  Unlike a residue this survives rescaling P and Q,
--     which is why §6 of the other module says no sequence of residues
--     can carry a law and this one can.
--
-- The order statement — that the स्थौल्य drops by two orders in n at each
-- step — is the analytic gloss on the second bullet and is NOT proved
-- here.  It cannot be: see the closing section.
--
-- The proof is the determinant recurrence and nothing else.  The form
--
--     W(u,v) = (2n+1)(u₁v₂ + v₁u₂) − u₂v₂
--
-- is bilinear in u = (h_i(n), k_i(n)) and v = (h_j(n+1), k_j(n+1)), so
-- the CF's three-term recurrence acts on the 2×2 block
--
--     ( W(k,k)    W(k,k−1)  )
--     ( W(k−1,k)  W(k−1,k−1))
--
-- by a transfer matrix on each side.  Carrying all four entries as one
-- invariant closes the induction; carrying only W(k,k) does not, which
-- is why the statement looked like it needed analysis and did not.  The
-- n-dependence cancels identically at each step — `step11` is where it
-- happens — and that cancellation IS the theorem.
--
-- ────────────────────────────────────────────────────────────────────
-- PROVENANCE
--
-- The corrections are transmitted in the Kerala texts, the *Yuktibhāṣā*
-- (Jyeṣṭhadeva, c. 1530) and the *Tantrasaṅgraha* tradition (Nīlakaṇṭha,
-- 1501), attributed there to Mādhava (c. 1340–1425).  The स्थौल्य
-- criterion is the tradition's; I have it from secondary sources and
-- have read no primary text — `notes/MADHAVA_THE_SERIES_AND_ITS_END_CORRECTION.md`
-- itemises exactly what was and was not read.  The continued fraction
-- is Krishna's, who reports that the Kerala texts give no rationale for
-- the third correction.  The theorem below is not in either place as far
-- as I know, and if it is, this is a rediscovery and the citation
-- belongs here.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.SthaulyaIsTheOmittedTerm where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ ; _,_ ; _×_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
private variable ℓ : Level

module Sthaulya (R : CommRing ℓ) where
  open CommRingStr (snd R)
  A : Type ℓ
  A = fst R

  infixl 6 _⊖_
  _⊖_ : A → A → A
  x ⊖ y = x + (- y)

  two four : A
  two  = 1r + 1r
  four = two · two

  nat : ℕ → A
  nat zero    = 0r
  nat (suc k) = nat k + 1r

  sgn : ℕ → A
  sgn zero    = 1r
  sgn (suc k) = - (sgn k)

  pn : ℕ → A
  pn zero          = 0r
  pn (suc zero)    = 1r
  pn (suc (suc j)) = (two · nat (suc j)) · (two · nat (suc j))

  Λ : ℕ → A
  Λ zero    = 1r
  Λ (suc k) = Λ k · pn (suc k)

  hh kk : ℕ → A → A
  hh zero          x = 0r
  hh (suc zero)    x = 1r
  hh (suc (suc i)) x = ((four · x) · hh (suc i) x) + (pn (suc (suc i)) · hh i x)
  kk zero          x = 1r
  kk (suc zero)    x = four · x
  kk (suc (suc i)) x = ((four · x) · kk (suc i) x) + (pn (suc (suc i)) · kk i x)

  mm : A → A
  mm n = (two · n) + 1r

  W : ℕ → ℕ → A → A
  W i j n = (mm n · ((hh i n · kk j (n + 1r)) + (hh j (n + 1r) · kk i n)))
            ⊖ (kk i n · kk j (n + 1r))

  ---------------------------------------------------------------- bilinearity

  bilin-l : (m x a p P q Q hj kj : A) →
      ((m · ((((x · p) + (a · P)) · kj) + (hj · ((x · q) + (a · Q)))))
        ⊖ (((x · q) + (a · Q)) · kj))
    ≡ (x · ((m · ((p · kj) + (hj · q))) ⊖ (q · kj)))
      + (a · ((m · ((P · kj) + (hj · Q))) ⊖ (Q · kj)))
  bilin-l m x a p P q Q hj kj = solve! R

  bilin-r : (m y a hi ki p' P' q' Q' : A) →
      ((m · ((hi · ((y · q') + (a · Q'))) + (((y · p') + (a · P')) · ki)))
        ⊖ (ki · ((y · q') + (a · Q'))))
    ≡ (y · ((m · ((hi · q') + (p' · ki))) ⊖ (ki · q')))
      + (a · ((m · ((hi · Q') + (P' · ki))) ⊖ (ki · Q')))
  bilin-r m y a hi ki p' P' q' Q' = solve! R

  W-left : (i j : ℕ) (n : A) →
      W (suc (suc i)) j n
    ≡ ((four · n) · W (suc i) j n) + (pn (suc (suc i)) · W i j n)
  W-left i j n = bilin-l (mm n) (four · n) (pn (suc (suc i)))
                         (hh (suc i) n) (hh i n) (kk (suc i) n) (kk i n)
                         (hh j (n + 1r)) (kk j (n + 1r))

  W-right : (i j : ℕ) (n : A) →
      W i (suc (suc j)) n
    ≡ ((four · (n + 1r)) · W i (suc j) n) + (pn (suc (suc j)) · W i j n)
  W-right i j n = bilin-r (mm n) (four · (n + 1r)) (pn (suc (suc j)))
                          (hh i n) (kk i n)
                          (hh (suc j) (n + 1r)) (hh j (n + 1r))
                          (kk (suc j) (n + 1r)) (kk j (n + 1r))

  ---------------------------------------------------------------- closed forms

  C00 C10 C01 C11 : ℕ → A → A
  C00 k n = sgn (suc k) · Λ (suc k)
  C10 k n = (sgn (suc k) · Λ (suc k)) · (mm n ⊖ (two · nat (suc k)))
  C01 k n = (sgn (suc k) · Λ (suc k)) · (mm n + (two · nat (suc k)))
  C11 k n = (- (sgn (suc k))) · (Λ (suc k) · pn (suc (suc k)))

  ---------------------------------------------------------------- step identities

  step10 : (n s L κ : A) →
      ((four · n) · ((- s) · (L · ((two · κ) · (two · κ)))))
      + (((two · κ) · (two · κ)) · ((s · L) · (((two · n) + 1r) + (two · κ))))
    ≡ ((- s) · (L · ((two · κ) · (two · κ))))
      · (((two · n) + 1r) ⊖ (two · (κ + 1r)))
  step10 n s L κ = solve! R

  step01 : (n s L κ : A) →
      ((four · (n + 1r)) · ((- s) · (L · ((two · κ) · (two · κ)))))
      + (((two · κ) · (two · κ)) · ((s · L) · (((two · n) + 1r) ⊖ (two · κ))))
    ≡ ((- s) · (L · ((two · κ) · (two · κ))))
      · (((two · n) + 1r) + (two · (κ + 1r)))
  step01 n s L κ = solve! R

  step11 : (n s L κ : A) →
      ((four · (n + 1r))
        · (((- s) · (L · ((two · κ) · (two · κ))))
            · (((two · n) + 1r) ⊖ (two · (κ + 1r)))))
      + (((two · κ) · (two · κ))
        · (((four · n) · ((s · L) · (((two · n) + 1r) ⊖ (two · κ))))
            + (((two · κ) · (two · κ)) · (s · L))))
    ≡ (- (- s)) · ((L · ((two · κ) · (two · κ)))
                    · ((two · (κ + 1r)) · (two · (κ + 1r))))
  step11 n s L κ = solve! R

  ---------------------------------------------------------------- base

  base00 : (n : A) → W 0 0 n ≡ C00 0 n
  base00 n = solve! R
  base10 : (n : A) → W 1 0 n ≡ C10 0 n
  base10 n = solve! R
  base01 : (n : A) → W 0 1 n ≡ C01 0 n
  base01 n = solve! R
  base11 : (n : A) → W 1 1 n ≡ C11 0 n
  base11 n = solve! R

  ---------------------------------------------------------------- the induction

  Inv : ℕ → A → Type ℓ
  Inv k n = (W k k n ≡ C00 k n)
          × ((W (suc k) k n ≡ C10 k n)
          × ((W k (suc k) n ≡ C01 k n)
          × (W (suc k) (suc k) n ≡ C11 k n)))

  inv : (k : ℕ) (n : A) → Inv k n
  inv zero n = base00 n , base10 n , base01 n , base11 n
  inv (suc k) n = e00' , e10' , e01' , e11'
    where
      ih  = inv k n
      e00 = fst ih
      e10 = fst (snd ih)
      e01 = fst (snd (snd ih))
      e11 = snd (snd (snd ih))

      e00' : W (suc k) (suc k) n ≡ C00 (suc k) n
      e00' = e11

      e10' : W (suc (suc k)) (suc k) n ≡ C10 (suc k) n
      e10' = W-left k (suc k) n
           ∙ cong₂ (λ u v → ((four · n) · u) + (pn (suc (suc k)) · v)) e11 e01
           ∙ step10 n (sgn (suc k)) (Λ (suc k)) (nat (suc k))

      e01' : W (suc k) (suc (suc k)) n ≡ C01 (suc k) n
      e01' = W-right (suc k) k n
           ∙ cong₂ (λ u v → ((four · (n + 1r)) · u) + (pn (suc (suc k)) · v)) e11 e10
           ∙ step01 n (sgn (suc k)) (Λ (suc k)) (nat (suc k))

      q : W (suc (suc k)) k n
        ≡ ((four · n) · C10 k n) + (pn (suc (suc k)) · C00 k n)
      q = W-left k k n
        ∙ cong₂ (λ u v → ((four · n) · u) + (pn (suc (suc k)) · v)) e10 e00

      e11' : W (suc (suc k)) (suc (suc k)) n ≡ C11 (suc k) n
      e11' = W-right (suc (suc k)) k n
           ∙ cong₂ (λ u v → ((four · (n + 1r)) · u) + (pn (suc (suc k)) · v)) e10' q
           ∙ step11 n (sgn (suc k)) (Λ (suc k)) (nat (suc k))

  ---------------------------------------------------------------- the theorem

  sthaulya-closed :
    (k : ℕ) (n : A) →
      W (suc k) (suc k) n ≡ (- (sgn (suc k))) · (Λ (suc k) · pn (suc (suc k)))
  sthaulya-closed k n = snd (snd (snd (inv k n)))

  ---------------------------------------------------------------- explicit value

  fourPow : ℕ → A
  fourPow zero    = 1r
  fourPow (suc k) = four · fourPow k

  fct : ℕ → A
  fct zero    = 1r
  fct (suc k) = fct k · nat (suc k)

  Λshift : (F f μ : A) →
      (F · (f · f)) · ((two · μ) · (two · μ))
    ≡ (four · F) · ((f · μ) · (f · μ))
  Λshift F f μ = solve! R

  base-Λ : Λ 1 · pn 2 ≡ fourPow 1 · (fct 1 · fct 1)
  base-Λ = solve! R

  Λ-closed : (k : ℕ) →
      Λ (suc k) · pn (suc (suc k)) ≡ fourPow (suc k) · (fct (suc k) · fct (suc k))
  Λ-closed zero    = base-Λ
  Λ-closed (suc k) =
      cong (_· ((two · nat (suc (suc k))) · (two · nat (suc (suc k))))) (Λ-closed k)
    ∙ Λshift (fourPow (suc k)) (fct (suc k)) (nat (suc (suc k)))

  sthaulya-value :
    (k : ℕ) (n : A) →
      W (suc k) (suc k) n
    ≡ (- (sgn (suc k))) · (fourPow (suc k) · (fct (suc k) · fct (suc k)))
  sthaulya-value k n = sthaulya-closed k n ∙ cong ((- (sgn (suc k))) ·_) (Λ-closed k)

  sthaulya-independent :
    (k : ℕ) (n n' : A) → W (suc k) (suc k) n ≡ W (suc k) (suc k) n'
  sthaulya-independent k n n' = sthaulya-closed k n ∙ sym (sthaulya-closed k n')

  ----------------------------------------------------------------------
  -- The step law, which is the exact form of "the correction improves".
  --
  -- Each correction's coarseness is the previous one's, multiplied by
  -- MINUS THE TERM NEWLY OMITTED.  No division and no limit: it is an
  -- identity between the two स्थौल्य numerators.
  ----------------------------------------------------------------------

  ratioLemma : (s L a A : A) →
      (- (- s)) · ((L · a) · A) ≡ (- A) · ((- s) · (L · a))
  ratioLemma s L a A = solve! R

  sthaulya-ratio :
    (k : ℕ) (n : A) →
      W (suc (suc k)) (suc (suc k)) n
    ≡ (- (pn (suc (suc (suc k))))) · W (suc k) (suc k) n
  sthaulya-ratio k n =
      sthaulya-closed (suc k) n
    ∙ ratioLemma (sgn (suc k)) (Λ (suc k))
                 (pn (suc (suc k))) (pn (suc (suc (suc k))))
    ∙ cong ((- (pn (suc (suc (suc k))))) ·_) (sym (sthaulya-closed k n))

------------------------------------------------------------------------
-- WHAT IS NOT PROVED HERE, AND WHY IT CANNOT BE
--
-- The commit that introduced this theorem, and §7 of
-- `AntyaSamskaraSthaulya`, both say that the स्थौल्य "drops by exactly two
-- orders in n at each step", on the ground that deg k_k = k makes it a
-- constant over a polynomial of degree 2k+1.
--
-- That sentence is not checked anywhere and it is not checkable in this
-- lane.  Everything above is an identity between ring elements, and a
-- commutative ring has no notion of degree, of leading coefficient, or
-- of order at infinity.  Cross-multiplying is exactly the move that
-- discards them — which is what makes the constancy theorem provable
-- without analysis, and what makes the order statement unavailable by
-- the same act.  Proving it needs the convergent denominators carried as
-- COEFFICIENT SEQUENCES rather than as ring-valued functions, together
-- with a vanishing-above-k lemma and the Horner link back to `kk`.  That
-- is a different development, and it is not this one.
--
-- The claim is elementary and I believe it: k₀ = 1, k₁ = 4n, and
-- k_{i+2} = 4n·k_{i+1} + a_{i+2}·k_i adds a degree-(i+2) term to a
-- degree-i one with no cancellation possible, the leading coefficient
-- being 4^k.  Believing it is not checking it, and it sits here labelled
-- rather than in a header stated as a consequence.
--
-- `sthaulya-ratio` is what survives the scoping, and it is the exact
-- statement the loose one was reaching for:
--
--     D_{k+1}  =  −a_{k+2} · D_k
--
-- each coarseness is the previous one times minus the newly omitted
-- partial numerator.  "Two orders" is the analytic gloss on that; the
-- identity is the thing.
------------------------------------------------------------------------

open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

open Sthaulya ℤCommRing
  using (W ; sthaulya-closed ; sthaulya-value ; sthaulya-independent ; sthaulya-ratio)
