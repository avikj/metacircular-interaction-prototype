-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- परिमाण-अन्धः — परिमाणं मूल्यं न पश्यति ।  अतः यत् किञ्चित् परिमाणेन साध्यते
-- तत् संहरणं न पश्यति ।
--
-- (the modulus standpoint cannot see the sign; so anything computed from
-- moduli alone cannot see cancellation, and this is a theorem, not a caution.)
--
-- WHY THIS EXISTS.  The bilinear organ the corpus keeps arriving at is
--
--     K_a(U,V;K) = Σ_{u≍U, v≍V, (u,v)=1} b_a(u) b_a(v) Σ_k c_k e(−2ak ū/v),
--
--     b_a(n) = μ(n) / Π_{p|n}(p−2),   B_a(s) = Π_{p∤2a}(1 − 1/((p−2)p^s)),
--
-- and the Euler comparison against ζ(s+1)^{-1} is exact:
--
--     1/((p−2)p^s) − 1/p^{s+1} = 2/(p^{s+1}(p−2))  ≍  p^{−s−2},
--
-- so B_a(s) = H_a(s)/ζ(s+1) with H_a absolutely convergent for Re s > −1.
-- The zeta cancellation is INSIDE the coefficients, before any analysis runs.
--
-- The standing observation is that treating b_a(u), b_a(v) as arbitrary
-- bounded coefficients — or summing |b_a| — discards that cancellation.  This
-- module upgrades the observation to a no-go, using the criterion landed in
-- `ApurvaIndriyam_…`: a reading that FACTORS through a coarser one is blind
-- inside that one's fibres, so a blind pair separated by the true quantity
-- proves no such reading exists.
--
-- THE STATEMENT.  Let S be the modulus standpoint — a coefficient vector read
-- through |·| — and let q be the signed sum.  §२ exhibits a blind pair: two
-- vectors with IDENTICAL moduli and different sums.  By `अपूर्वम्`, q does not
-- factor through S.  Hence:
--
--     no quantity computed from |b_a| alone is a function of Σ b_a,
--
-- and a bound proved through |·| assigns one value to a whole family whose
-- true sums differ — including a member with no cancellation at all.  On that
-- member the bound cannot beat the trivial one, so it cannot beat it on any
-- of them.  That is why the needed estimate must carry BOTH ζ(s+1)^{−1} and
-- ū/v: the modulus route provably cannot recover the first.
--
-- WHAT IS NOT CLAIMED.  Nothing here bounds K_a, and nothing here says the
-- absolute-value route is useless — it is exactly right whenever the trivial
-- bound suffices, and `ApurvaIndriyam.तन्तौ-अन्धः` is the theorem that it is
-- FAITHFUL to what it does read.  The claim is only that its fibre is
-- nonempty, which settles what it can never distinguish.  The blind pair is
-- exhibited at the smallest size that carries the phenomenon; scaling it to
-- an actual coefficient family is arithmetic this module does not do.
------------------------------------------------------------------------

module ParimanaAndha_TheModulusStandpointCannotSeeMobiusSoNoBoundThroughItSeparatesACancellingFamily where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibresSoASeparatedBlindPairCertifiesANewSense
  using (प्रवहति ; तन्तौ-अन्धः ; अपूर्वम्)

------------------------------------------------------------------------
-- १ · द्वे मानक्रमे — the two standpoints, at the smallest carrying size
--
-- A coefficient vector is a pair of signed units, which is the least
-- structure in which a Möbius sign can cancel.  `चिह्न` is the sign and
-- `परिमाण` the magnitude; the modulus standpoint keeps only the second.
------------------------------------------------------------------------

data चिह्नम् : Type where          -- +1 and −1, the values μ takes on squarefrees
  धन ऋण : चिह्नम्

गुणकः : Type
गुणकः = चिह्नम् × चिह्नम्            -- (b_a(u), b_a(v)) at unit magnitude

-- S : the modulus reading.  |±1| = 1, so it forgets everything here — which
-- is the point, and is what `Σ|b_a|` does at every size.
परिमाणम् : गुणकः → ℕ × ℕ
परिमाणम् _ = (1 , 1)

-- q : the signed sum, as a natural number of "surviving units" — 0 when the
-- two signs cancel, 2 when they reinforce.  Only the DIFFERENCE matters, so
-- ℕ suffices and no ℤ arithmetic is needed.
योगः : गुणकः → ℕ
योगः (धन , धन) = 2
योगः (ऋण , ऋण) = 2
योगः (धन , ऋण) = 0
योगः (ऋण , धन) = 0

------------------------------------------------------------------------
-- २ · अन्ध-युग्मम् — the blind pair
--
-- Identical under the modulus standpoint (`refl` — it reads the same thing
-- for both), different under the signed sum.  This is Möbius cancellation at
-- its minimum: same magnitudes, one family cancels and one does not.
------------------------------------------------------------------------

संहरत् : गुणकः                    -- cancels
संहरत् = (धन , ऋण)

न-संहरत् : गुणकः                  -- does not cancel
न-संहरत् = (धन , धन)

-- The modulus standpoint cannot tell them apart.
अन्धत्वम् : परिमाणम् संहरत् ≡ परिमाणम् न-संहरत्
अन्धत्वम् = refl

-- The signed sum can: 0 ≢ 2.
भेदः : योगः संहरत् ≡ योगः न-संहरत् → ⊥
भेदः p = znots p

------------------------------------------------------------------------
-- ३ · मुख्यसिद्धिः — the signed sum is NOT a function of the moduli
--
-- One blind pair refutes every possible derivation at once: no h whatsoever
-- takes the modulus reading to the signed sum.  This is `अपूर्वम्` applied,
-- and it is the exact sense in which "summing absolute values discards the
-- cancellation" is a no-go rather than a heuristic.
------------------------------------------------------------------------

परिमाणात्-न-योगः : प्रवहति परिमाणम् योगः → ⊥
परिमाणात्-न-योगः =
  अपूर्वम् परिमाणम् योगः संहरत् न-संहरत् अन्धत्वम् भेदः

------------------------------------------------------------------------
-- ४ · तत्फलम् — what this settles about the bilinear organ
--
-- Read `परिमाणम्` as the step |b_a(u) b_a(v)| ≤ 1, and `योगः` as the quantity
-- actually wanted.  §३ says the second is not recoverable from the first —
-- so any argument whose only use of the coefficients is through their moduli
-- assigns ONE value to both members of the pair.  Since `न-संहरत्` has no
-- cancellation to find, that shared value is the no-cancellation value.
--
-- Hence the two halves the estimate must carry are not two conveniences:
--
--     ζ(s+1)^{−1}  lives in the SIGNS — invisible to परिमाणम् by §३;
--     e(−2ak ū/v)  lives in the PHASE — invisible to the coefficients.
--
-- An argument that drops either half has passed to a standpoint whose fibre
-- contains a member with nothing to prove, and inherits that member's bound.
-- The needed theorem is the one that refuses both projections at once.
--
-- मर्यादा, at the site.  §३ is a statement about |·| ALONE.  It says nothing
-- against arguments that use moduli TOGETHER with sign information kept
-- elsewhere — those do not factor through परिमाणम् and §३ does not reach
-- them.  Distinguishing "used the modulus" from "used only the modulus" is
-- exactly the `प्रवहति` datum: an argument that can exhibit its h is refuted
-- here, and one that cannot has not claimed to be a modulus argument.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- ५ · विक्षेपे तदेव — the same blindness after DISPERSION, where it bites
--
-- Squaring in a wall variable sends
--
--     (u₁, u₂, v, k) ⟼ (u₁u₂, h, v, k),   h = u₂ − u₁,
--     e(−2ak(ū₁ − ū₂)/v) = e(−2akh·overline(u₁u₂)/v),
--
-- since ū₁ − ū₂ ≡ (u₂−u₁)·overline(u₁u₂) (mod v) — multiply by u₁u₂ and both
-- sides are u₂ − u₁.  The additive displacement is REGENERATED inside the
-- multiplicative form, and the coefficients survive as the product
-- b_a(u₁)b_a(u₂), whose Mellin transform still carries
-- ζ(s+1)^{−1} ζ(t+1)^{−1}.
--
-- So dispersion does not destroy the zeta organ.  What destroys it is the
-- step that usually accompanies dispersion: the Cauchy–Schwarz that frees the
-- coefficients is precisely where |b_a| is inserted, and §३ applies verbatim
-- to the post-dispersion pair — `गुणकः` reads equally well as
-- (b_a(u₁), b_a(u₂)).  The blind pair is the SAME pair.
--
-- The consequence is sharp for the diagonal/off-diagonal question.  h = 0
-- carries energy and no destructive phase; h ≠ 0 carries the oscillation, and
-- a proof must show the off-diagonal cannot point coherently against the
-- diagonal.  If the off-diagonal is bounded through |b_a|, §३ says that bound
-- is simultaneously a bound for `न-संहरत्` — a family with the same moduli and
-- NO cancellation, where the off-diagonal is as large as its magnitudes
-- permit.  The bound therefore cannot be smaller than that, whatever the true
-- signs do.
--
-- Blindness is inherited by everything downstream, which is `तन्तौ-अन्धः`
-- again: any function of a blind reading is blind on the same fibre.
------------------------------------------------------------------------

-- Whatever the argument computes AFTER passing to moduli — a Cauchy–Schwarz
-- factor, a dispersion bound, a final estimate — it is one value for the whole
-- fibre.  Composition cannot recover what the first step discarded.
पश्चात्-अपि-अन्धः : {Q : Type} (g : ℕ → Q)
                 → (g (योगः संहरत्) ≡ g (योगः न-संहरत्) → ⊥)
                 → प्रवहति परिमाणम् योगः → ⊥
पश्चात्-अपि-अन्धः g sep fac =
  अपूर्वम् परिमाणम् योगः संहरत् न-संहरत् अन्धत्वम्
    (λ p → sep (cong g p)) fac

-- The faithfulness half, recorded so the no-go is not read as a dismissal:
-- whatever IS computed from the moduli is correctly computed for the whole
-- fibre at once.  That is `तन्तौ-अन्धः`, and it is why the modulus route is
-- sound wherever the trivial bound is what is wanted.
परिमाण-सत्यता : (h : ℕ × ℕ → ℕ) (x y : गुणकः)
              → परिमाणम् x ≡ परिमाणम् y
              → h (परिमाणम् x) ≡ h (परिमाणम् y)
परिमाण-सत्यता h x y = cong h
