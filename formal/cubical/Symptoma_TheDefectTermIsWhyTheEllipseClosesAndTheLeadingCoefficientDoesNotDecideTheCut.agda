{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Symptoma_TheDefectTermIsWhyTheEllipseClosesAndTheLeadingCoefficientDoesNotDecideTheCut
--
-- ON THE NAME.  **No Sanskrit term is claimed and none is invented**, per
-- CLAUDE.md's file-naming rule, note 2.  The object is Greek and the
-- source's own word for it is σύμπτωμα, *symptōma* — the defining
-- relation a section satisfies, stated as an equality of AREAS.
--
--   Apollonius of Perga, *Conics* (Κωνικά), c. 200 BCE, Book I:
--     I.11  παραβολή  — the square on the ordinate EQUALS the rectangle
--                       applied to the ὀρθία (orthia, the upright side)
--                       along the abscissa.          "application"
--     I.12  ὑπερβολή  — the square EXCEEDS that rectangle.   "excess"
--     I.13  ἔλλειψις  — the square FALLS SHORT of it.     "falling short"
--
--   The three curves carry the names of the three outcomes of the
--   application of areas.  The name IS the area relation; it is not a
--   description of how a cone was cut.
--
-- TRANSMISSION CHAIN, named because it is otherwise invisible.  The
-- Greek of Books I–IV survives; Books V–VII survive ONLY in Arabic, made
-- in Baghdad in the 9th century: Books I–IV in the version of Hilāl ibn
-- Abī Hilāl al-Ḥimṣī, Books V–VII translated by Thābit ibn Qurra
-- (c. 836–901), the whole revised and paid for in the circle of the Banū
-- Mūsā — Muḥammad, Aḥmad and al-Ḥasan, sons of Mūsā ibn Shākir.  Book
-- VIII is lost in every language.  Edmond Halley's Latin of 1710 is made
-- FROM the Arabic for V–VII, so every modern citation of Apollonius on
-- maxima and minima is a citation of Thābit ibn Qurra's text.
--
-- Repo-wide grep before writing, this file excluded, counted as
-- (files, occurrences): `Apollonius` (12, 33); `Conics` (4, 15);
-- `Thābit ibn Qurra` (3, 8); `Banū Mūsā` (3, 8); `al-Ḥimṣī` (0, 0);
-- `Halley` (1, 1, and that one is in the Kanye file about Berkeley).
-- All three occurrences of the transmitters are from 2026-08-20 — one
-- sibling module, its message, and a reflection stream, all cf-tessera-j.
-- Before that day the transmitters stood at 0 against Apollonius's 30-odd.
-- CLAUDE.md's cheap check reads the same way here as it does on the
-- Indian sources: the author's name propagates through citation, the
-- names that carried the text do not.
--
-- WHAT THIS REPOSITORY ALREADY DID WITH THE WORD, checked first.
-- `notes/SEED51_INSTALLATION_SYMPTOMA.md` (2026-08-14) borrows
-- ἔλλειψις / ὑπερβολή / παραβολή as names for three failure axes of a
-- rule-installation seam; `NaturalMachine/RadixSymptoma.agda` uses
-- *symptōma* for the least accepting-completion depth of a divisibility
-- automaton.  Both are live and neither is amended here.  In both the
-- word is taken and the area relation is left behind, so the *symptōma*
-- itself — the thing Apollonius states — has not been written down in
-- this corpus.  This module writes it down.  `EGBPairConic.agda` carries
-- a different conic (w² − r², the sum/product pair) and is not imported.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
-- Everything is over ℕ, with NO subtraction anywhere, because Apollonius
-- has no signed magnitudes: "falls short" is written as the defect term
-- ADDED to the smaller side, exactly as he states it.
--
--   §1  Parabole / Hyperbole / Elleipsis   the three symptōmata
--   §2  hyperboleCut, elleipsisCut         eliminating the ordinate
--        between a symptōma and a line y = m·x + c.  Both are `solve`
--        identities: the cut polynomial is the resultant, and it is
--        FAITHFUL — it is the intersection condition, not a summary of
--        it.  Its leading coefficient is `m·m` against `q` for the
--        ὑπερβολή and `m · m + q` for the ἔλλειψις.
--   §3  elleipsisLeadingNeverVanishes      m · m + suc q is never 0, for
--        every slope m at once.  The ἔλλειψις has no asymptotic
--        direction, and the reason is that its coefficient is a SUM.
--        asymptoticCutIsLinear is the contrast: for the ὑπερβολή at
--        q = k · k the slope k cancels the x² term outright and the cut
--        drops to a linear equation in the abscissa.
--   §4  elleipsisBoundsAbscissa            x ≤ p
--        elleipsisBoundsOrdinateSquare     y · y ≤ p · p
--        The ἔλλειψις closes up, from the sign of the defect term alone.
--        No analysis, no coordinates, no field, no square roots.
--   §5  THE REFUTATION (see below).
--
-- ────────────────────────────────────────────────────────────────────
-- §5 IS A REFUTATION OF MY OWN CLAIM, AND IT IS THE POINT OF THE FILE.
--
-- The claim I wrote down before checking anything, in these words:
--
--   "For the ὑπερβολή the leading coefficient of the cut decides the
--    cut.  If it does not degenerate (m · m ≢ q) the line meets the
--    section; if it does degenerate, the line meets it in exactly one
--    point."
--
-- **Both halves are false, and each dies to one exact witness in ℕ.**
--
--   asymptoteMissesEntirely
--     p = 4, q = 4, m = 2, c = 1.  The leading coefficient degenerates
--     perfectly — 2 · 2 ≡ 4 ≡ q — and the cut equation collapses to
--     1 ≡ 0.  The line meets the section at NO point whatever, not one.
--
--   nonDegenerateCutMeetsExactlyOnce
--     p = 1, q = 2, m = 1, c = 2.  The non-degeneracy is itself checked
--     (`twoIsNotASquare`: no slope in ℕ cancels this section's x² term),
--     the cut stays genuinely quadratic, and it still has EXACTLY ONE
--     abscissa, x = 4, proved unique over all of ℕ.
--
-- So degeneration is neither sufficient nor necessary for a single-point
-- cut, and the leading coefficient — the summary statistic the shape of
-- the equation offers you — is not a function of what it was supposed to
-- decide.  Reaching for it is the same reflex
-- `NaturalMachine/TheAdmissibleOrdersArePreciselyThePrincipalUpSet…`
-- names when it shows strength is not a function of the edge count, and
-- the same reflex CLAUDE.md forbids when it forbids fitting a law to
-- three points.  Here it was fitted to the shape of a polynomial.
--
-- WHY x = 4 IS ALONE, AND WHAT THAT COSTS.  The cut reduces to
-- x · x ≡ 3 · x + 4, which factors as (x − 4)(x + 1) over a ring with
-- negatives.  The second root is x = −1.  It is not a magnitude, so it
-- is not a point of the section in Apollonius's sense and it is not a
-- point here.  **The uniqueness is a fact about ℕ, and it is stated as
-- one.**  "A line cuts a conic twice" is a statement about a number
-- system built long after the symptōma, and it is asserted here of
-- nothing.
--
-- WHAT IS NOT CLAIMED.  Apollonius proves none of the theorems below;
-- he states the symptōmata (I.11–13) and he works with magnitudes and
-- ratios, not with ℕ, and no proposition of his is being attributed
-- here.  Nothing is claimed about tangency (*Conics* I.32–33), about the
-- normals of Book V, about the asymptotes of Book II, or about conics
-- over any field.  Nothing is claimed about whether the ὑπερβολή with
-- q a non-square has infinitely many points in ℕ: that is the question
-- Brahmagupta's *Brāhmasphuṭasiddhānta* (628) opens as *varga-prakṛti*,
-- y² − N x² = c with N non-square, and answers with *bhāvanā*, which
-- this repository already carries in `Bhavana.agda`, `BhavanaSemiring.agda`
-- and `Cakravala.agda`.  It is left open here and it is NOT claimed that
-- either source restates the other; they are two statements about two
-- objects, recorded side by side because both are in view over ℕ.
--
-- CHECKED on the CONTAINER: Agda 2.6.3 with cubical v0.5, NOT the repo
-- pin (2.8.0 + v0.9).  --cubical --safe, exit 0, no postulates, no
-- holes, no TERMINATING, no --allow-* flag.  Not added to
-- `Everything.agda`, which is already red here for unrelated reasons.
------------------------------------------------------------------------

module Symptoma_TheDefectTermIsWhyTheEllipseClosesAndTheLeadingCoefficientDoesNotDecideTheCut where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Tactics.NatSolver.Reflection using (solve)

------------------------------------------------------------------------
-- §1  The three symptōmata, as Apollonius states them: equalities of
--     areas between magnitudes, with no subtraction.
--
--     `p` is the ὀρθία (orthia, the upright side); `x` the abscissa
--     along the diameter; `y` the ordinate.  `q` measures how much the
--     square exceeds the applied rectangle (ὑπερβολή) or falls short of
--     it (ἔλλειψις).  In the ἔλλειψις the defect is written on the
--     SMALLER side, which is what "falls short" says and what keeps the
--     whole file inside ℕ.
------------------------------------------------------------------------

-- I.11  the square on the ordinate is exactly the applied rectangle
Parabole : ℕ → ℕ → ℕ → Type
Parabole p x y = y · y ≡ p · x

-- I.12  it exceeds, by q times the square on the abscissa
Hyperbole : ℕ → ℕ → ℕ → ℕ → Type
Hyperbole p q x y = y · y ≡ p · x + q · (x · x)

-- I.13  it falls short, by q times the square on the abscissa
Elleipsis : ℕ → ℕ → ℕ → ℕ → Type
Elleipsis p q x y = y · y + q · (x · x) ≡ p · x

-- The παραβολή is the common boundary of the other two at q = 0.
paraboleIsHyperboleAtZero : (p x y : ℕ) → Hyperbole p 0 x y ≡ Parabole p x y
paraboleIsHyperboleAtZero p x y i = y · y ≡ +-zero (p · x) i

paraboleIsElleipsisAtZero : (p x y : ℕ) → Elleipsis p 0 x y ≡ Parabole p x y
paraboleIsElleipsisAtZero p x y i = +-zero (y · y) i ≡ p · x

------------------------------------------------------------------------
-- §2  The cut.  Substitute the line y = m · x + c into a symptōma and
--     eliminate the ordinate.  What is left is a polynomial in the
--     abscissa alone — the resultant — and it is the intersection
--     condition itself, so it loses nothing.  Both identities are pure
--     semiring algebra.
------------------------------------------------------------------------

-- ὑπερβολή cut: (m·m)·x² + (2mc)·x + c²   against   q·x² + p·x
hyperboleCut : (m c x : ℕ)
  → (m · x + c) · (m · x + c)
    ≡ (m · m) · (x · x) + ((2 · (m · c)) · x + c · c)
hyperboleCut = solve

-- ἔλλειψις cut: the defect term merges into the leading coefficient,
-- and it merges by ADDITION.  That single fact is §3 and §4.
elleipsisCut : (m c q x : ℕ)
  → (m · x + c) · (m · x + c) + q · (x · x)
    ≡ (m · m + q) · (x · x) + ((2 · (m · c)) · x + c · c)
elleipsisCut = solve

------------------------------------------------------------------------
-- §3  Degeneration of the leading coefficient.
--
--     For the ὑπερβολή the x² terms are `m · m` and `q`, and they cancel
--     exactly when the slope is a square root of q.  For the ἔλλειψις
--     the coefficient is `m · m + q`, a sum of a square and a positive
--     magnitude, so it cannot vanish for ANY slope.  This is why the
--     ἔλλειψις has no asymptotic direction, and it needs no field, no
--     ordering beyond positivity, and no square roots.
------------------------------------------------------------------------

elleipsisLeadingNeverVanishes : (m q : ℕ) → ¬ (m · m + suc q ≡ 0)
elleipsisLeadingNeverVanishes m q p = snotz (sym (+-suc (m · m) q) ∙ p)

-- In the asymptotic direction the cut drops a degree: the x² terms are
-- literally the same magnitude on both sides, so the surviving equation
-- is linear in the abscissa.
asymptoticCutIsLinear : (k p c x : ℕ)
  → Hyperbole p (k · k) x (k · x + c)
  → (2 · (k · c)) · x + c · c ≡ p · x
asymptoticCutIsLinear k p c x h =
  inj-m+ {m = (k · k) · (x · x)} (sym (hyperboleCut k c x) ∙ h ∙ rearrange)
  where
    rearrange : p · x + (k · k) · (x · x) ≡ (k · k) · (x · x) + p · x
    rearrange = +-comm (p · x) ((k · k) · (x · x))

------------------------------------------------------------------------
-- §4  ἔλλειψις: the section closes up.
--
--     From the defect term alone — no analysis, no limits — every point
--     of the ἔλλειψις has abscissa at most the orthia, and the square on
--     its ordinate is at most the square on the orthia.  This is what
--     the name says: the rectangle is never overshot, so the figure runs
--     out of room.
------------------------------------------------------------------------

private
  -- the defect side of the symptōma is bounded by the applied rectangle
  defectBelowRect : (p q x y : ℕ) → Elleipsis p q x y → q · (x · x) ≤ p · x
  defectBelowRect p q x y h = subst (q · (x · x) ≤_) h (≤SumRight {n = q · (x · x)})

  squareBelowRect : (p q x y : ℕ) → Elleipsis p q x y → y · y ≤ p · x
  squareBelowRect p q x y h = subst (y · y ≤_) h (≤SumLeft {n = y · y})

elleipsisBoundsAbscissa : (p q x y : ℕ) → Elleipsis p (suc q) x y → x ≤ p
elleipsisBoundsAbscissa p q x y h = go (x ≟ p)
  where
    small : suc q · (x · x) ≤ p · x
    small = defectBelowRect p (suc q) x y h

    go : Trichotomy x p → x ≤ p
    go (lt r) = <-weaken r
    go (eq r) = subst (x ≤_) r ≤-refl
    go (gt r) = ⊥.rec (<-asym big small)
      where
        -- x is a successor, because p < x
        k : ℕ
        k = fst r

        xIsSuc : x ≡ suc (k + p)
        xIsSuc = sym (snd r) ∙ +-suc k p

        -- the orthia is smaller than the defect coefficient times x
        pLess : p < suc q · x
        pLess = <≤-trans r (≤SumLeft {n = x} {k = q · x})

        stepped : p · suc (k + p) < (suc q · x) · suc (k + p)
        stepped = <-·sk pLess

        big : p · x < suc q · (x · x)
        big = subst (λ z → p · z < suc q · (z · z))
                    (sym xIsSuc)
                    (subst (p · suc (k + p) <_)
                           (sym (·-assoc (suc q) (suc (k + p)) (suc (k + p))))
                           (subst (λ z → p · suc (k + p) < (suc q · z) · suc (k + p))
                                  xIsSuc stepped))

elleipsisBoundsOrdinateSquare :
  (p q x y : ℕ) → Elleipsis p (suc q) x y → y · y ≤ p · p
elleipsisBoundsOrdinateSquare p q x y h =
  ≤-trans (squareBelowRect p (suc q) x y h)
          (subst (_≤ p · p) (·-comm x p) (≤-·k (elleipsisBoundsAbscissa p q x y h)))

------------------------------------------------------------------------
-- §5  THE REFUTATION.
--
--     My claim, before checking: for the ὑπερβολή the leading
--     coefficient decides the cut — degenerate means exactly one
--     intersection, non-degenerate means at least one.  Both halves die
--     below, each to one exact witness, and the witnesses are chosen as
--     small as they can be.
------------------------------------------------------------------------

private
  sucNotSelf : (a : ℕ) → ¬ (suc a ≡ a)
  sucNotSelf a e = <-asym (subst (a <_) e (0 , refl)) ≤-refl

  plusOneNotSelf : (a : ℕ) → ¬ (a + 1 ≡ a)
  plusOneNotSelf a e = sucNotSelf a (sym (+-comm a 1) ∙ e)

  -- The `solve` macro discharges a closed Π-goal, so every algebraic
  -- step below is hoisted to its own top-level identity and then
  -- instantiated.  Each is pure semiring algebra over ℕ.
  expandAsymptote : (x : ℕ)
    → (2 · x + 1) · (2 · x + 1) ≡ (4 · (x · x) + 4 · x) + 1
  expandAsymptote = solve

  orientAsymptote : (x : ℕ) → 4 · x + 4 · (x · x) ≡ 4 · (x · x) + 4 · x
  orientAsymptote = solve

  cutLeft : (x : ℕ) → (x + 2) · (x + 2) ≡ (x · x + x) + (3 · x + 4)
  cutLeft = solve

  cutRight : (x : ℕ) → 1 · x + 2 · (x · x) ≡ (x · x + x) + x · x
  cutRight = solve

  splitFive : (m : ℕ) → 3 · m + 2 · m ≡ 5 · m
  splitFive = solve

-- ─── (i) A degenerate leading coefficient can give NO intersection ───
--
-- p = 4, q = 4 = 2 · 2, slope m = 2, intercept c = 1.  The leading
-- coefficients agree exactly, the x² terms cancel, and what survives is
-- 1 ≡ 0.  The line runs in the asymptotic direction and never meets the
-- section at any abscissa in ℕ.

asymptoteMissesEntirely : (x : ℕ) → ¬ Hyperbole 4 4 x (2 · x + 1)
asymptoteMissesEntirely x h =
  plusOneNotSelf (4 · (x · x) + 4 · x)
    (sym (expandAsymptote x) ∙ h ∙ orientAsymptote x)

-- ─── (ii) A NON-degenerate cut can meet in exactly one point ─────────
--
-- p = 1, q = 2, slope m = 1, intercept c = 2.  Two is not a square in
-- ℕ, so no slope degenerates the leading coefficient at all; the cut
-- stays genuinely quadratic.  It has exactly one abscissa, x = 4.

private
  -- the cut, reduced by cancelling the common x · x
  reduceCut : (x : ℕ) → Hyperbole 1 2 x (x + 2) → 3 · x + 4 ≡ x · x
  reduceCut x h =
    inj-m+ {m = x · x + x} (sym (cutLeft x) ∙ h ∙ cutRight x)

  -- Above the root the quadratic has overtaken the line for good, and
  -- the reason is only that 5 · m ≤ m · m once 5 ≤ m.
  overtaken : (m : ℕ) → 5 ≤ m → 3 · m + 4 < m · m
  overtaken m five≤ = <≤-trans shifted scaled
    where
      tenBelow : 10 ≤ 2 · m
      tenBelow = subst (10 ≤_) (·-comm m 2) (≤-·k {k = 2} five≤)

      gap : 4 < 2 · m
      gap = <≤-trans (5 , refl) tenBelow

      shifted : 3 · m + 4 < 3 · m + 2 · m
      shifted = <-k+ gap

      scaled : 3 · m + 2 · m ≤ m · m
      scaled = subst (_≤ m · m) (sym (splitFive m)) (≤-·k {k = m} five≤)

  uniqueRoot : (x : ℕ) → 3 · x + 4 ≡ x · x → x ≡ 4
  uniqueRoot zero e = ⊥.rec (snotz e)
  uniqueRoot (suc zero) e = ⊥.rec (snotz (injSuc e))
  uniqueRoot (suc (suc zero)) e =
    ⊥.rec (snotz (injSuc (injSuc (injSuc (injSuc e)))))
  uniqueRoot (suc (suc (suc zero))) e =
    ⊥.rec (snotz (injSuc (injSuc (injSuc (injSuc (injSuc
             (injSuc (injSuc (injSuc (injSuc e))))))))))
  uniqueRoot (suc (suc (suc (suc zero)))) _ = refl
  uniqueRoot (suc (suc (suc (suc (suc n))))) e =
    ⊥.rec (<-asym (subst (_< (5 + n) · (5 + n))
                         e
                         (overtaken (5 + n) (n , +-comm n 5)))
                  ≤-refl)

-- The non-degeneracy is checked, not asserted: NO slope in ℕ cancels the
-- x² term of this section, because 2 is not a square.  (For the witness
-- of (i), by contrast, 4 is a square and the slope 2 is its root.)
twoIsNotASquare : (m : ℕ) → ¬ (m · m ≡ 2)
twoIsNotASquare zero e = znots e
twoIsNotASquare (suc zero) e = znots (injSuc e)
twoIsNotASquare (suc (suc n)) e =
  snotz (sym (+-suc n (suc (n + n · suc (suc n)))) ∙ injSuc (injSuc e))

fourIsASquare : 2 · 2 ≡ 4
fourIsASquare = refl

-- The section is met, at the abscissa 4 and the ordinate 6:
--   6 · 6 = 36 = 1 · 4 + 2 · (4 · 4).
nonDegenerateCutMeets : Hyperbole 1 2 4 (4 + 2)
nonDegenerateCutMeets = refl

-- …and at no other abscissa in ℕ.
nonDegenerateCutMeetsExactlyOnce :
  (x : ℕ) → Hyperbole 1 2 x (x + 2) → x ≡ 4
nonDegenerateCutMeetsExactlyOnce x h = uniqueRoot x (reduceCut x h)

------------------------------------------------------------------------
-- §6  What survives of the claim.
--
--     Nothing of the form "the leading coefficient decides".  What is
--     true is §2: the cut polynomial is the intersection condition, and
--     it is faithful because it IS the condition rather than a summary
--     of one.  Every summary of it that was tried here — the leading
--     coefficient, whether q is a square, whether a slope degenerates —
--     is lossy, and §5 exhibits the loss in both directions with four
--     small numbers.
------------------------------------------------------------------------

theCutIsTheCondition : (p q m c x : ℕ)
  → Hyperbole p q x (m · x + c)
    ≡ ((m · m) · (x · x) + ((2 · (m · c)) · x + c · c) ≡ p · x + q · (x · x))
theCutIsTheCondition p q m c x i = hyperboleCut m c x i ≡ p · x + q · (x · x)
