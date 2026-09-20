{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡∞‡ø‡Æ‡æ‡-‡‡®‡‡ß‡ ‚î ‡‡∞‡ø‡Æ‡æ‡‡ ‡Æ‡‡≤‡‡Ø‡ ‡® ‡‡‡‡Ø‡‡ø ‡  ‡‡‡ ‡Ø‡‡ ‡ï‡ø‡û‡‡‡ø‡‡ ‡‡∞‡ø‡Æ‡æ‡‡‡® ‡‡æ‡ß‡‡Ø‡‡
-- ‡‡‡ ‡‡‡‡∞‡‡ ‡® ‡‡‡‡Ø‡‡ø ‡
--
-- (the modulus standpoint cannot see the sign; so anything computed from
-- moduli alone cannot see cancellation, and this is a theorem, not a caution.)
--
-- WHY THIS EXISTS.  The bilinear organ the corpus keeps arriving at is
--
--     K_a(U,V;K) = Œ_{u‚âU, v‚âV, (u,v)=1} b_a(u) b_a(v) Œ_k c_k e(‚àí2ak /v),
--
--     b_a(n) = Œº(n) / Œ†_{p|n}(p‚àí2),   B_a(s) = Œ†_{p‚à2a}(1 ‚àí 1/((p‚àí2)p^s)),
--
-- and the Euler comparison against Œ(s+1)^{-1} is exact:
--
--     1/((p‚àí2)p^s) ‚àí 1/p^{s+1} = 2/(p^{s+1}(p‚àí2))  ‚â  p^{‚àís‚àí2},
--
-- so B_a(s) = H_a(s)/Œ(s+1) with H_a absolutely convergent for Re s > ‚àí1.
-- The zeta cancellation is INSIDE the coefficients, before any analysis runs.
--
-- The standing observation is that treating b_a(u), b_a(v) as arbitrary
-- bounded coefficients ‚î or summing |b_a| ‚î discards that cancellation.  This
-- module upgrades the observation to a no-go, using the criterion landed in
-- `ApurvaIndriyam_‚¶`: a reading that FACTORS through a coarser one is blind
-- inside that one's fibres, so a blind pair separated by the true quantity
-- proves no such reading exists.
--
-- THE STATEMENT.  Let S be the modulus standpoint ‚î a coefficient vector read
-- through |¬| ‚î and let q be the signed sum.  ¬ß‡® exhibits a blind pair: two
-- vectors with IDENTICAL moduli and different sums.  By `‡‡‡‡∞‡‡µ‡Æ‡`, q does not
-- factor through S.  Hence:
--
--     no quantity computed from |b_a| alone is a function of Œ b_a,
--
-- and a bound proved through |¬| assigns one value to a whole family whose
-- true sums differ ‚î including a member with no cancellation at all.  On that
-- member the bound cannot beat the trivial one, so it cannot beat it on any
-- of them.  That is why the needed estimate must carry BOTH Œ(s+1)^{‚àí1} and
-- /v: the modulus route provably cannot recover the first.
--
------------------------------------------------------------------------

module ParimanaAndha_TheModulusStandpointCannotSeeMobiusSoNoBoundThroughItSeparatesACancellingFamily where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; znots)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (‚ä•)

open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibresSoASeparatedBlindPairCertifiesANewSense
  using (‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø ; ‡§§‡§®‡•ç‡§§‡•å-‡§Ö‡§®‡•ç‡§ß‡§É ; ‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç)

------------------------------------------------------------------------
-- ‡ß ¬ ‡¶‡‡µ‡ ‡Æ‡æ‡®‡ï‡‡∞‡Æ‡ ‚î the two standpoints, at the smallest carrying size
--
-- A coefficient vector is a pair of signed units, which is the least
-- structure in which a Mbius sign can cancel.  `‡‡ø‡‡‡®` is the sign and
-- `‡‡∞‡ø‡Æ‡æ‡` the magnitude; the modulus standpoint keeps only the second.
------------------------------------------------------------------------

data ‡§ö‡§ø‡§π‡•ç‡§®‡§Æ‡•ç : Type where          -- +1 and ‚àí1, the values Œº takes on squarefrees
  ‡§ß‡§® ‡§ã‡§£ : ‡§ö‡§ø‡§π‡•ç‡§®‡§Æ‡•ç

‡§ó‡•Å‡§£‡§ï‡§É : Type
‡§ó‡•Å‡§£‡§ï‡§É = ‡§ö‡§ø‡§π‡•ç‡§®‡§Æ‡•ç √ó ‡§ö‡§ø‡§π‡•ç‡§®‡§Æ‡•ç            -- (b_a(u), b_a(v)) at unit magnitude

-- S : the modulus reading.  |¬1| = 1, so it forgets everything here ‚î which
-- is the point, and is what `Œ|b_a|` does at every size.
‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç : ‡§ó‡•Å‡§£‡§ï‡§É ‚Üí ‚Ñï √ó ‚Ñï
‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç _ = (1 , 1)

-- q : the signed sum, as a natural number of "surviving units" ‚î 0 when the
-- two signs cancel, 2 when they reinforce.  Only the DIFFERENCE matters, so
-- ‚ï suffices and no ‚ arithmetic is needed.
‡§Ø‡•ã‡§ó‡§É : ‡§ó‡•Å‡§£‡§ï‡§É ‚Üí ‚Ñï
‡§Ø‡•ã‡§ó‡§É (‡§ß‡§® , ‡§ß‡§®) = 2
‡§Ø‡•ã‡§ó‡§É (‡§ã‡§£ , ‡§ã‡§£) = 2
‡§Ø‡•ã‡§ó‡§É (‡§ß‡§® , ‡§ã‡§£) = 0
‡§Ø‡•ã‡§ó‡§É (‡§ã‡§£ , ‡§ß‡§®) = 0

------------------------------------------------------------------------
-- ‡® ¬ ‡‡®‡‡ß-‡Ø‡‡ó‡‡Æ‡Æ‡ ‚î the blind pair
--
-- Identical under the modulus standpoint (`refl` ‚î it reads the same thing
-- for both), different under the signed sum.  This is Mbius cancellation at
-- its minimum: same magnitudes, one family cancels and one does not.
------------------------------------------------------------------------

‡§∏‡§Ç‡§π‡§∞‡§§‡•ç : ‡§ó‡•Å‡§£‡§ï‡§É                    -- cancels
‡§∏‡§Ç‡§π‡§∞‡§§‡•ç = (‡§ß‡§® , ‡§ã‡§£)

‡§®-‡§∏‡§Ç‡§π‡§∞‡§§‡•ç : ‡§ó‡•Å‡§£‡§ï‡§É                  -- does not cancel
‡§®-‡§∏‡§Ç‡§π‡§∞‡§§‡•ç = (‡§ß‡§® , ‡§ß‡§®)

-- The modulus standpoint cannot tell them apart.
‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç : ‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç ‡§∏‡§Ç‡§π‡§∞‡§§‡•ç ‚â° ‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç ‡§®-‡§∏‡§Ç‡§π‡§∞‡§§‡•ç
‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç = refl

-- The signed sum can: 0 ‚â 2.
‡§≠‡•á‡§¶‡§É : ‡§Ø‡•ã‡§ó‡§É ‡§∏‡§Ç‡§π‡§∞‡§§‡•ç ‚â° ‡§Ø‡•ã‡§ó‡§É ‡§®-‡§∏‡§Ç‡§π‡§∞‡§§‡•ç ‚Üí ‚ä•
‡§≠‡•á‡§¶‡§É p = znots p

------------------------------------------------------------------------
-- ‡© ¬ ‡Æ‡‡ñ‡‡Ø‡‡ø‡¶‡‡ß‡ø‡ ‚î the signed sum is NOT a function of the moduli
--
-- One blind pair refutes every possible derivation at once: no h whatsoever
-- takes the modulus reading to the signed sum.  This is `‡‡‡‡∞‡‡µ‡Æ‡` applied,
-- and it is the exact sense in which "summing absolute values discards the
-- cancellation" is a no-go rather than a heuristic.
------------------------------------------------------------------------

‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§æ‡§§‡•ç-‡§®-‡§Ø‡•ã‡§ó‡§É : ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø ‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç ‡§Ø‡•ã‡§ó‡§É ‚Üí ‚ä•
‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§æ‡§§‡•ç-‡§®-‡§Ø‡•ã‡§ó‡§É =
  ‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç ‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç ‡§Ø‡•ã‡§ó‡§É ‡§∏‡§Ç‡§π‡§∞‡§§‡•ç ‡§®-‡§∏‡§Ç‡§π‡§∞‡§§‡•ç ‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç ‡§≠‡•á‡§¶‡§É

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡‡≤‡Æ‡ ‚î what this settles about the bilinear organ
--
-- Read `‡‡∞‡ø‡Æ‡æ‡‡Æ‡` as the step |b_a(u) b_a(v)| ‚â 1, and `‡Ø‡ã‡ó‡` as the quantity
-- actually wanted.  ¬ß‡© says the second is not recoverable from the first ‚î
-- so any argument whose only use of the coefficients is through their moduli
-- assigns ONE value to both members of the pair.  Since `‡®-‡‡‡‡∞‡‡` has no
-- cancellation to find, that shared value is the no-cancellation value.
--
-- Hence the two halves the estimate must carry are not two conveniences:
--
--     Œ(s+1)^{‚àí1}  lives in the SIGNS ‚î invisible to ‡‡∞‡ø‡Æ‡æ‡‡Æ‡ by ¬ß‡©;
--     e(‚àí2ak /v)  lives in the PHASE ‚î invisible to the coefficients.
--
-- An argument that drops either half has passed to a standpoint whose fibre
-- contains a member with nothing to prove, and inherits that member's bound.
-- The needed theorem is the one that refuses both projections at once.
--
-- ‡Æ‡∞‡‡Ø‡æ‡¶‡æ, at the site.  ¬ß‡© is a statement about |¬| ALONE.  It says nothing
-- against arguments that use moduli TOGETHER with sign information kept
-- elsewhere ‚î those do not factor through ‡‡∞‡ø‡Æ‡æ‡‡Æ‡ and ¬ß‡© does not reach
-- them.  Distinguishing "used the modulus" from "used only the modulus" is
-- exactly the `‡‡‡∞‡µ‡‡‡ø` datum: an argument that can exhibit its h is refuted
-- here, and one that cannot has not claimed to be a modulus argument.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- ‡ ¬ ‡µ‡ø‡ï‡‡‡‡‡ ‡‡¶‡‡µ ‚î the same blindness after DISPERSION, where it bites
--
-- Squaring in a wall variable sends
--
--     (u‚, u‚, v, k) ‚üº (u‚u‚, h, v, k),   h = u‚ ‚àí u‚,
--     e(‚àí2ak(‚ ‚àí ‚)/v) = e(‚àí2akh¬overline(u‚u‚)/v),
--
-- since ‚ ‚àí ‚ ‚â° (u‚‚àíu‚)¬overline(u‚u‚) (mod v) ‚î multiply by u‚u‚ and both
-- sides are u‚ ‚àí u‚.  The additive displacement is REGENERATED inside the
-- multiplicative form, and the coefficients survive as the product
-- b_a(u‚)b_a(u‚), whose Mellin transform still carries
-- Œ(s+1)^{‚àí1} Œ(t+1)^{‚àí1}.
--
-- So dispersion does not destroy the zeta organ.  What destroys it is the
-- step that usually accompanies dispersion: the Cauchy‚ìSchwarz that frees the
-- coefficients is precisely where |b_a| is inserted, and ¬ß‡© applies verbatim
-- to the post-dispersion pair ‚î `‡ó‡‡‡ï‡` reads equally well as
-- (b_a(u‚), b_a(u‚)).  The blind pair is the SAME pair.
--
-- The consequence is sharp for the diagonal/off-diagonal question.  h = 0
-- carries energy and no destructive phase; h ‚â† 0 carries the oscillation, and
-- a proof must show the off-diagonal cannot point coherently against the
-- diagonal.  If the off-diagonal is bounded through |b_a|, ¬ß‡© says that bound
-- is simultaneously a bound for `‡®-‡‡‡‡∞‡‡` ‚î a family with the same moduli and
-- NO cancellation, where the off-diagonal is as large as its magnitudes
-- permit.  The bound therefore cannot be smaller than that, whatever the true
-- signs do.
--
-- Blindness is inherited by everything downstream, which is `‡‡®‡‡‡-‡‡®‡‡ß‡`
-- again: any function of a blind reading is blind on the same fibre.
------------------------------------------------------------------------

-- Whatever the argument computes AFTER passing to moduli ‚î a Cauchy‚ìSchwarz
-- factor, a dispersion bound, a final estimate ‚î it is one value for the whole
-- fibre.  Composition cannot recover what the first step discarded.
‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç-‡§Ö‡§™‡§ø-‡§Ö‡§®‡•ç‡§ß‡§É : {Q : Type} (g : ‚Ñï ‚Üí Q)
                 ‚Üí (g (‡§Ø‡•ã‡§ó‡§É ‡§∏‡§Ç‡§π‡§∞‡§§‡•ç) ‚â° g (‡§Ø‡•ã‡§ó‡§É ‡§®-‡§∏‡§Ç‡§π‡§∞‡§§‡•ç) ‚Üí ‚ä•)
                 ‚Üí ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø ‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç ‡§Ø‡•ã‡§ó‡§É ‚Üí ‚ä•
‡§™‡§∂‡•ç‡§ö‡§æ‡§§‡•ç-‡§Ö‡§™‡§ø-‡§Ö‡§®‡•ç‡§ß‡§É g sep fac =
  ‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç ‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç ‡§Ø‡•ã‡§ó‡§É ‡§∏‡§Ç‡§π‡§∞‡§§‡•ç ‡§®-‡§∏‡§Ç‡§π‡§∞‡§§‡•ç ‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç
    (Œª p ‚Üí sep (cong g p)) fac

-- The faithfulness half, recorded so the no-go is not read as a dismissal:
-- whatever IS computed from the moduli is correctly computed for the whole
-- fibre at once.  That is `‡‡®‡‡‡-‡‡®‡‡ß‡`, and it is why the modulus route is
-- sound wherever the trivial bound is what is wanted.
‡§™‡§∞‡§ø‡§Æ‡§æ‡§£-‡§∏‡§§‡•ç‡§Ø‡§§‡§æ : (h : ‚Ñï √ó ‚Ñï ‚Üí ‚Ñï) (x y : ‡§ó‡•Å‡§£‡§ï‡§É)
              ‚Üí ‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç x ‚â° ‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç y
              ‚Üí h (‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç x) ‚â° h (‡§™‡§∞‡§ø‡§Æ‡§æ‡§£‡§Æ‡•ç y)
‡§™‡§∞‡§ø‡§Æ‡§æ‡§£-‡§∏‡§§‡•ç‡§Ø‡§§‡§æ h x y = cong h
