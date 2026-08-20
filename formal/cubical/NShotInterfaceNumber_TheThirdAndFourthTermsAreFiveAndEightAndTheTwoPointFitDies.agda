{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NShotInterfaceNumber_TheThirdAndFourthTermsAreFiveAndEightAndTheTwoPointFitDies
--
-- cf-tessera-r-0, 2026-08-20.  Agda 2.6.3 + cubical v0.5 (NOT the repo pin).
--
------------------------------------------------------------------------
-- ON THE NAME.  **No Sanskrit term is claimed and none is invented**
-- (CLAUDE.md, file-naming note 2).  The mathematics originates with the
-- owner, in
--
--   `collab/upstream/library/raw/SUFFICIENT_INTERFACES_DELTA_02_2026-08-13.md`
--
-- and the file leads with that source's own term.  Delta 02 §3, quoted:
--
--   "Define the n-shot interface number
--        κ_n(R)=κ0(R^{×n})."
--
-- The English after the underscore is the gloss.  Delta 02 §12 item 2 is
-- the standing request this module answers: "Compute κ_n exactly for the
-- triangle for n=3,4 if feasible; infer sequence."  Feasible; computed;
-- the inference is refused below and the reason is recorded.
--
------------------------------------------------------------------------
-- WHAT WAS ALREADY ESTABLISHED, AND BY WHOM.
--
-- The transmission was opened for the first time on 2026-08-20 by
-- cf-tessera-m-0, by uniform draw, and the module
--
--   `OuteMeizonOuteElasson_TheParallelInterfacePriceMultipliesExactlyWhereTheRegulatorHasNoChoice.agda`
--   (cf-tessera-m-0, commit 6e78c35b)
--
-- is imported here rather than restated.  From it, used and not re-derived:
--
--   κ₀(triangle) = 2 and κ₀(triangle²) = 3 as checked terms (Delta 02's
--   Theorems 1 and 2, the owner's);  `triSq-two-states-never-suffice`, the
--   exhaustion over all 81 two-element interfaces for the squared task;
--   `functionLike-⊗`, exact multiplicativity where the witness is forced;
--   the death of Claim M — strict submultiplicativity does NOT follow from
--   some input having ≥ 2 witnesses;  and the discipline that every
--   exhaustive negative carries an enumeration-size control, because
--   `any? p [] ≡ false` typechecks for every p.  §6 below carries mine.
--
-- m-0's exact words on the arithmetic left open, which is where this module
-- starts: "⌈(3/2)ⁿ⌉ fits n=1 and n=2.  Two points.  I did not state it as a
-- law and did not generate the next term; somebody should.  Counting alone
-- does not refuse 4 (four 2×2×2 rectangles hold 32 ≥ 27 points)."
--
------------------------------------------------------------------------
-- WHAT IS ESTABLISHED HERE.
--
--   κ₃ = 5   (§4: a five-state interface, by refl; no ≤ 4 ever suffices)
--   κ₄ = 8   (§5: an eight-state interface, by refl; no ≤ 7 ever suffices)
--
-- so the sequence of exact values is now  κ₁ κ₂ κ₃ κ₄ = 2 3 5 8.
--
--   ⌈(3/2)³⌉ = 4 and κ₃ = 5.  THE TWO-POINT FIT IS DEAD.
--   ⌈(3/2)⁴⌉ = 6 and κ₄ = 8.  It is dead twice.
--
-- Both bounds are proofs, not searches.  Counting does not refuse 4 and
-- neither does the LP: Delta 02 §9's Corollary 4.1 gives κ₃ ≥ τ*³ = 27/8,
-- i.e. ≥ 4, and κ₄ ≥ 81/16, i.e. ≥ 6.  The mechanism that does refuse them
-- is §3's peeling law, which is proved for an arbitrary tail task and is
-- what makes n = 4 reachable at all: the searches those bounds would
-- otherwise require are C(27,4) = 17550 and C(81,7) ≈ 3.5 × 10⁹ interfaces,
-- and in the enumeration idiom m-0's `exhaustive` uses (all tuples, with
-- repetition) they are 27⁴ = 531441 and 81⁷ ≈ 2.3 × 10¹³.  Neither is run.
--
-- THE PEELING LAW (§3), stated for the triangle's head coordinate and any
-- tail task S:  fix an input a of the head coordinate; the witnesses whose
-- head component admits a, stripped of that component, must already be a
-- sufficient interface for S.  Each of the 3 head inputs therefore demands
-- κ(S) tail-witnesses, while each witness supplies its tail to exactly 2 of
-- the 3 head inputs — every hyperedge of the triangle holds 2 of its 3
-- vertices.  So 2·|C| ≥ 3·κ(S), i.e.
--
--        κ(triangle ⊗ S) ≥ ⌈(3/2)·κ(S)⌉.
--
-- 2·4 = 8 < 9 = 3·3 kills 4 states at n = 3; 2·7 = 14 < 15 = 3·5 kills 7 at
-- n = 4.  The general form of the count is |A|/d, the vertex count over the
-- largest hyperedge, which for this hypergraph is exactly τ* = 3/2 — and
-- that coincidence is the subject of §7.
--
------------------------------------------------------------------------
-- MY OWN CLAIM, AND ITS DEATH (§6).
--
-- CLAIM R, which I held after §4 and which is the natural repair of the
-- fit m-0 declined to state:
--
--   "The integrality penalty is paid once.  κ₀ exceeds τ* by the one-shot
--    gap 4/3 and thereafter the price merely tracks the fractional rate:
--    κ_n = ⌈κ₀ · τ*^{n-1}⌉ = ⌈2·(3/2)^{n-1}⌉."
--
-- It fits THREE points: 2, 3, 5 for n = 1, 2, 3.  At n = 4 it predicts
-- ⌈27/4⌉ = 7 and §5 proves 8.  `claimR-refuted` is that death, checked.
--
-- WHAT KILLED IT.  The overhead κ_n/τ*ⁿ is not constant and does not
-- oscillate around a constant; over the four exact values it strictly
-- increases at every step where it can:
--
--        n        1      2       3        4
--        κ_n·2ⁿ   4     12      40      128
--        3ⁿ       3      9      27       81
--        ratio  4/3    4/3   40/27  128/81
--
-- and 4/3 < 40/27 < 128/81 in exact integers (`overhead-strictly-grows`).
-- A law of the form κ_n = ⌈c·τ*ⁿ⌉ asserts a bounded ratio.  The ratio here
-- is not known to be bounded and the data says it is climbing.
--
-- Note what is NOT refuted, because a fourth point does not decide either:
-- 2, 3, 5, 8 is also Virahāṅka's recurrence (Vṛttajātisamuccaya, c. 700;
-- the rule κ_n = κ_{n-1} + κ_{n-2} for the number of prosodic patterns of a
-- given duration, stated for mātrā-vṛtta and standardly cited as Fibonacci,
-- 1202).  It predicts κ₅ = 13.  §3's law gives κ₅ ≥ 12 and Delta 02 §8's
-- submultiplicativity with κ₂·κ₃ gives κ₅ ≤ 15, so 13 sits inside the
-- bracket and nothing checked here excludes it.  Two laws, four shared
-- points, first disagreement at the first unknown term.  That is what a fit
-- is.  What does exclude the recurrence — in the limit only, and from
-- outside this module — is Delta 03 §1: the rate would be log φ = 0.694 and
-- the rate is log(3/2) = 0.585.  So κ_n = κ_{n-1} + κ_{n-2} cannot hold for
-- all n.  It can still hold at n = 5, and no term here says otherwise.
--
------------------------------------------------------------------------
-- G∞ IS NOT OPEN, AND I FOUND THAT OUT LATE (§7).
--
-- Delta 02 §10 poses "LIVE FRONTIER: Prove or disprove G∞=0 for finite
-- witness hypergraphs under unrestricted block selectors."  The next file
-- in the same directory, same date —
--
--   `collab/upstream/library/raw/SUFFICIENT_INTERFACES_DELTA_03_2026-08-13.md`
--
-- — answers it.  §0: "ANSWER: YES."  §1 Theorem 1: lim κ0(R^{×n})^{1/n} =
-- τ*(H_R).  §2 Corollary 2: "G∞(R)=0 for every finite relation."  Delta 03
-- flags the hypergraph theorem itself as known prior art and claims only the
-- identification.  Located by cf-tessera-r-1, who swept 146 of the 147
-- upstream text artifacts; m-0 and I had each read Delta 02 and not the file
-- next to it.
--
-- I derived the same answer before reading Delta 03, from the greedy/LP
-- bound, so what follows is a REPLICATION and is reported as one.  Written
-- out because Delta 03's Theorem 1 cites a limit that is not the limit it
-- uses, and the argument that does close the gap is short:
--
--   (i) For any finite hypergraph with universe size N, greedy covering
--       gives τ ≤ τ*·(1 + ln N).  At each stage an optimal fractional cover
--       of weight τ* forces some edge to meet ≥ |R|/τ* of the uncovered
--       remainder R, so |R| falls by the factor (1 - 1/τ*) per step.
--       Sharp form: L. Lovász, "On the ratio of optimal integral and
--       fractional covers", Discrete Mathematics 13 (1975) 383-390, τ/τ* ≤
--       1 + ln d with d the largest edge; independently S. K. Stein, "Two
--       combinatorial covering theorems", JCTA 16 (1974) 391-397.  The title
--       of the 1975 paper is the ratio Delta 02 §10 asks about.
--
--  (ii) Delta 02 §9 Theorem 4 gives τ*(H^{×n}) = τ*(H)ⁿ, and H^{×n} has
--       universe size Nⁿ.  Substituting into (i):
--
--            τ*ⁿ ≤ κ_n ≤ τ*ⁿ·(1 + n·ln N),
--
--       so (1/n)log κ_n → log τ* and G∞ = 0 for every finite witness
--       hypergraph.  This is Delta 03 §2, with an explicit finite bound.
--
-- THE PROVENANCE REPAIR, stated as a question and not as a correction, since
-- I could not open the cited book.  Delta 03 §1 cites "asymptotic covering
-- number equals fractional covering number" (Fractional Graph Theory, given
-- as Thm 1.6.2).  In that literature the standard asymptotic covering
-- theorem is about k-FOLD covers of ONE hypergraph — τ_f = lim_k τ_k/k, an
-- LP-relaxation limit — whereas Theorem 1 needs the CARTESIAN-POWER limit
-- lim_n τ(H^{×n})^{1/n}.  Both statements are true and they are different
-- limits; the k-fold theorem does not imply the power theorem, and (i)+(ii)
-- above is a route that does.  Whether the cited numbering is the k-fold
-- statement I could not check: egress policy refuses arxiv.org, oeis.org,
-- dblp.org, zbmath.org and api.crossref.org (403/no route, 2026-08-20);
-- raw.githubusercontent.com answers 200 and is not a bibliographic index.
-- So the citation above is from memory and is marked as such, and what I
-- vouch for is the argument, which is reproduced in full and is two lines.
--
-- WHAT DELTA 03 DOES NOT SETTLE, and what stays correct.
--
--   * m-0's `G∞-is-not-decided-by-this-bracket` is a statement about the
--     bracket [6, 9] at n = 4 — that two integers sit inside it.  True, and
--     untouched: Delta 03 decides G∞ by another route entirely.  §5 here
--     closes that bracket to a point anyway: κ₄ = 8.
--
--   * Delta 02 §9's τ* multiplicativity is labelled there a "Candidate
--     theorem", and its primal half carries a visible hesitation in the
--     text — "(local? correction) / More precisely the local sum factors".
--     It is load-bearing for §9's own Corollary 4.1 and for Delta 03's
--     Theorem 1.  §3 below does not use it: the peeling law is integral,
--     LP-free, and for this hypergraph strictly stronger than Corollary 4.1
--     at every n ≥ 3 (κ₃ ≥ 5 against ≥ 4, κ₄ ≥ 8 against ≥ 6).
--
--   * Delta 03 §2: "There may remain subexponential overhead, but no
--     positive per-instance logarithmic penalty."  That remainder is where
--     the exact values land.  κ_n/τ*ⁿ over n = 1..4 is 4/3, 4/3, 40/27,
--     128/81 — climbing, not constant (§6).  The rate collapses; the count
--     of extra interface states does not.  Claim R above is exactly the
--     strongest reading of that clause, and it is false.
--
--   * Delta 03 §3: "Longer block codes approach log(3/2)."  κ₃ and κ₄ are
--     the first two exact points on that approach: (1/n)log κ_n runs
--     0.7925, 0.7740, 0.7500 bits at n = 2, 3, 4, against log(3/2) = 0.585.
--
-- Neither Lovász 1975 nor Stein 1974 occurs anywhere in `notes/` (grep,
-- 2026-08-20: "fractional cover" 0, "covering code" 0; the six notes naming
-- Lovász all name the theta function, a different object).
--
-- THE OTHER-DIRECTION SEARCH.  Established today by cf-tessera-i-0 and
-- reported again by m-0 for this exact object, and I re-ran it for the
-- minimisation rather than the incidence: the Śulba-sūtras, Anuyogadvāra,
-- Sthānāṅga and Piṅgala/Halāyudha enumerate and classify — bhaṅga
-- combinations, prastāra arrays generated by rule — but none of them poses
-- a minimum over subfamilies subject to a covering constraint, which is
-- what κ₀ is.  Virahāṅka appears above for the recurrence and for nothing
-- else: the coincidence of 2, 3, 5, 8 with mātrā-vṛtta counts is a
-- coincidence of four integers, it is named because it is the fit a reader
-- would otherwise make silently, and no claim whatever is made that the
-- Vṛttajātisamuccaya is about interface numbers.
------------------------------------------------------------------------

module NShotInterfaceNumber_TheThirdAndFourthTermsAreFiveAndEightAndTheTwoPointFitDies where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; _and_ ; _or_ ; false≢true)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; _^_ ; +-suc ; ·-comm ; ·-assoc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; ≤<-trans ; ≤-+-≤ ; ≤-·k ; ¬m<m
        ; splitℕ-≤)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Tactics.NatSolver.Reflection using (solve)

open import OuteMeizonOuteElasson_TheParallelInterfacePriceMultipliesExactlyWhereTheRegulatorHasNoChoice

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  Reading a Boolean search backwards.
--
-- m-0's `any?-of-member` turns a witness into a `true`.  The peeling law
-- needs the converse at both quantifiers: a `true` from `any?` must hand
-- back the element that produced it, and a `true` from `all?` must be
-- usable at a named input.  Nothing here is specific to the triangle.
------------------------------------------------------------------------

or-elim : (b c : Bool) → (b or c) ≡ true → (b ≡ true) ⊎ (c ≡ true)
or-elim true  c _ = inl refl
or-elim false c p = inr p

any?-elim : {X : Type ℓ} (p : X → Bool) (xs : List X)
          → any? p xs ≡ true → Σ[ x ∈ X ] ((x ∈ xs) × (p x ≡ true))
any?-elim p []       q = Empty.rec (false≢true q)
any?-elim p (x ∷ xs) q with or-elim (p x) (any? p xs) q
... | inl h = x , (here , h)
... | inr h = fst r , (there (fst (snd r)) , snd (snd r))
  where r = any?-elim p xs h

-- Matching on the membership proof, never on the list: splitting the list
-- first would need injectivity of _∷_, which Cubical Agda does not support.
all?-lookup : {X : Type ℓ} (p : X → Bool) {x : X} {xs : List X}
            → x ∈ xs → all? p xs ≡ true → p x ≡ true
all?-lookup p here      q = fst (and-split _ _ q)
all?-lookup p (there m) q = all?-lookup p m (snd (and-split _ _ q))

all?-intro : {X : Type ℓ} (p : X → Bool) (xs : List X)
           → ((x : X) → x ∈ xs → p x ≡ true) → all? p xs ≡ true
all?-intro p []       f = refl
all?-intro p (x ∷ xs) f =
  and-both (f x here) (all?-intro p xs (λ y m → f y (there m)))

-- Sufficiency only ever grows.
suffices-mono : {A : Type ℓ} {B : Type ℓ'} (R : Rel A B) (as : List A)
                (S S′ : List B)
              → ((b : B) → b ∈ S → b ∈ S′)
              → suffices R as S ≡ true → suffices R as S′ ≡ true
suffices-mono R as S S′ incl h =
  all?-intro _ as
    (λ a m →
      let w = any?-elim (λ b → R a b) S (all?-lookup _ m h)
      in any?-of-member (λ b → R a b)
           (incl (fst w) (fst (snd w))) (snd (snd w)))

-- Padding, so that an exhaustion at one exact size speaks about every
-- smaller size.  (m-0's exhaustions are stated at `length S ≡ n`.)
copies : {X : Type ℓ} → ℕ → X → List X
copies zero    x = []
copies (suc n) x = x ∷ copies n x

length-copies-++ : {X : Type ℓ} (n : ℕ) (x : X) (xs : List X)
                 → length (copies n x ++ xs) ≡ n + length xs
length-copies-++ zero    x xs = refl
length-copies-++ (suc n) x xs = cong suc (length-copies-++ n x xs)

exact→≤ : {A : Type ℓ} {X : Type ℓ'} (R : Rel A X) (as : List A) (x₀ : X)
          (n : ℕ)
        → ((T : List X) → length T ≡ n → ¬ (suffices R as T ≡ true))
        → (T : List X) → length T ≤ n → ¬ (suffices R as T ≡ true)
exact→≤ R as x₀ n none T (d , p) h =
  none (copies d x₀ ++ T)
       (length-copies-++ d x₀ T ∙ p)
       (suffices-mono R as T (copies d x₀ ++ T)
         (λ b m → ∈-++ʳ (copies d x₀) m) h)

------------------------------------------------------------------------
-- 2.  Peeling the head coordinate.
--
-- `peel a C` keeps the tails of exactly those witnesses whose head
-- component admits the head input a.
------------------------------------------------------------------------

peelCons : {X : Type₀} → Bool → X → List X → List X
peelCons true  t ts = t ∷ ts
peelCons false t ts = ts

peel : {X : Type₀} → A₃ → List (W₃ × X) → List X
peel a []      = []
peel a (c ∷ C) = peelCons (tri a (fst c)) (snd c) (peel a C)

∈-peelCons : {X : Type₀} (b : Bool) (t′ : X) {t : X} {ts : List X}
           → t ∈ ts → t ∈ peelCons b t′ ts
∈-peelCons true  t′ m = there m
∈-peelCons false t′ m = m

∈-peel : {X : Type₀} {a : A₃} {c : W₃ × X} {C : List (W₃ × X)}
       → c ∈ C → tri a (fst c) ≡ true → snd c ∈ peel a C
∈-peel {a = a} {c = c} (here {xs = C}) h =
  subst (λ b → snd c ∈ peelCons b (snd c) (peel a C)) (sym h) here
∈-peel {a = a} (there {y = c′} m) h =
  ∈-peelCons (tri a (fst c′)) (snd c′) (∈-peel m h)

allA₃-complete : (a : A₃) → a ∈ allA₃
allA₃-complete α₁ = here
allA₃-complete α₂ = there here
allA₃-complete α₃ = there (there here)

------------------------------------------------------------------------
-- 3.  THE PEELING LAW.
--
-- Two halves, both for an arbitrary tail task S over arbitrary carriers.
--
--   (a) every peel of a sufficient interface is a sufficient interface for
--       the tail task;
--   (b) the three peels have 2·|C| elements between them, because every
--       hyperedge of the triangle holds exactly 2 of its 3 vertices.
--
-- Together: 3·κ(S) ≤ 2·|C|.
------------------------------------------------------------------------

peel-suffices :
  {A′ : Type₀} {W′ : Type₀} (S : Rel A′ W′) (as′ : List A′)
  (C : List (W₃ × W′)) (a : A₃)
  → suffices (tri ⊗ᴿ S) (pairsOf allA₃ as′) C ≡ true
  → suffices S as′ (peel a C) ≡ true
peel-suffices S as′ C a h =
  all?-intro _ as′
    (λ a′ m′ →
      let hit = all?-lookup _ (∈-pairsOf (allA₃-complete a) m′) h
          w   = any?-elim (λ c → (tri ⊗ᴿ S) (a , a′) c) C hit
          sp  = and-split (tri a (fst (fst w))) (S a′ (snd (fst w)))
                  (snd (snd w))
      in any?-of-member (λ t → S a′ t)
           (∈-peel (fst (snd w)) (fst sp)) (snd sp))

-- The counting half.  Arithmetic first.
lem-a : (x y w : ℕ) → suc x + (suc y + w) ≡ suc (suc (x + (y + w)))
lem-a x y w = cong suc (+-suc x (y + w))

lem-b : (x y w : ℕ) → suc x + (y + suc w) ≡ suc (suc (x + (y + w)))
lem-b x y w = cong suc (cong (x +_) (+-suc y w) ∙ +-suc x (y + w))

lem-c : (x y w : ℕ) → x + (suc y + suc w) ≡ suc (suc (x + (y + w)))
lem-c x y w =
  cong (x +_) (cong suc (+-suc y w))
  ∙ +-suc x (suc (y + w))
  ∙ cong suc (+-suc x (y + w))

lem-r : (n : ℕ) → suc n + suc n ≡ suc (suc (n + n))
lem-r n = cong suc (+-suc n n)

peelSum-step :
  {X : Type₀} (w : W₃) (t : X) (C : List (W₃ × X))
  → length (peel α₁ C) + (length (peel α₂ C) + length (peel α₃ C))
    ≡ length C + length C
  → length (peelCons (tri α₁ w) t (peel α₁ C))
      + ( length (peelCons (tri α₂ w) t (peel α₂ C))
        + length (peelCons (tri α₃ w) t (peel α₃ C)) )
    ≡ suc (length C) + suc (length C)
peelSum-step e₁₂ t C ih =
    lem-a (length (peel α₁ C)) (length (peel α₂ C)) (length (peel α₃ C))
  ∙ cong suc (cong suc ih) ∙ sym (lem-r (length C))
peelSum-step e₁₃ t C ih =
    lem-b (length (peel α₁ C)) (length (peel α₂ C)) (length (peel α₃ C))
  ∙ cong suc (cong suc ih) ∙ sym (lem-r (length C))
peelSum-step e₂₃ t C ih =
    lem-c (length (peel α₁ C)) (length (peel α₂ C)) (length (peel α₃ C))
  ∙ cong suc (cong suc ih) ∙ sym (lem-r (length C))

peelSum : {X : Type₀} (C : List (W₃ × X))
        → length (peel α₁ C) + (length (peel α₂ C) + length (peel α₃ C))
          ≡ length C + length C
peelSum []      = refl
peelSum (c ∷ C) = peelSum-step (fst c) (snd c) C (peelSum C)

-- THE LAW.  If no interface of size ≤ k suffices for the tail task, and
-- 2·m < 3·(k+1), then no interface of size ≤ m suffices for the parallel
-- task.  Instantiated at (k,m) = (2,4) and (4,7) below.
peel-lower :
  {A′ : Type₀} {W′ : Type₀} (S : Rel A′ W′) (as′ : List A′) (k m : ℕ)
  → ((T : List W′) → length T ≤ k → ¬ (suffices S as′ T ≡ true))
  → (m + m) < (suc k + (suc k + suc k))
  → (C : List (W₃ × W′)) → length C ≤ m
  → ¬ (suffices (tri ⊗ᴿ S) (pairsOf allA₃ as′) C ≡ true)
peel-lower S as′ k m none small C lenC h =
  ¬m<m (≤<-trans (≤-trans sum≥ le) small)
  where
  big : (a : A₃) → suc k ≤ length (peel a C)
  big a with splitℕ-≤ (length (peel a C)) k
  ... | inl le′ = Empty.rec (none (peel a C) le′ (peel-suffices S as′ C a h))
  ... | inr gt  = gt

  sum≥ : suc k + (suc k + suc k) ≤ length C + length C
  sum≥ = subst (suc k + (suc k + suc k) ≤_) (peelSum C)
           (≤-+-≤ (big α₁) (≤-+-≤ (big α₂) (big α₃)))

  le : length C + length C ≤ m + m
  le = ≤-+-≤ lenC lenC

------------------------------------------------------------------------
-- 4.  κ₃ = 5.
------------------------------------------------------------------------

A₂₇ : Type₀
A₂₇ = A₃ × A₉

W₂₇ : Type₀
W₂₇ = W₃ × W₉

allA₂₇ : List A₂₇
allA₂₇ = pairsOf allA₃ allA₉

triCube : Rel A₂₇ W₂₇
triCube = tri ⊗ᴿ triSq

-- UPPER BOUND.  Five product witnesses.  In the complement coordinates —
-- each hyperedge is named by the single vertex it omits, e₂₃ ↔ α₁,
-- e₁₃ ↔ α₂, e₁₂ ↔ α₃ — this family is
--
--        111, 122, 212, 221, 333,
--
-- i.e. the even-weight words of {α₁,α₂}³ together with the constant α₃.
-- An input is covered by a witness exactly when it disagrees with that
-- witness's omitted vertex in every coordinate.
cube5 : List W₂₇
cube5 = (e₂₃ , (e₂₃ , e₂₃))
      ∷ (e₂₃ , (e₁₃ , e₁₃))
      ∷ (e₁₃ , (e₂₃ , e₁₃))
      ∷ (e₁₃ , (e₁₃ , e₂₃))
      ∷ (e₁₂ , (e₁₂ , e₁₂))
      ∷ []

cube-five-suffices : suffices triCube allA₂₇ cube5 ≡ true
cube-five-suffices = refl

-- LOWER BOUND.  m-0's exhaustion at exactly two states, extended to ≤ 2 by
-- padding, then peeled.  2·4 = 8 < 9 = 3·3.
square-≤2-fails :
  (T : List W₉) → length T ≤ 2 → ¬ (suffices triSq allA₉ T ≡ true)
square-≤2-fails =
  exact→≤ triSq allA₉ (e₁₂ , e₁₂) 2 triSq-two-states-never-suffice

cube-≤4-fails :
  (C : List W₂₇) → length C ≤ 4 → ¬ (suffices triCube allA₂₇ C ≡ true)
cube-≤4-fails = peel-lower triSq allA₉ 2 4 square-≤2-fails (0 , refl)

-- κ₃ = 5, both sides.
κ₃-is-five :
  ((length cube5 ≡ 5) × (suffices triCube allA₂₇ cube5 ≡ true))
  × ((C : List W₂₇) → length C ≤ 4 → ¬ (suffices triCube allA₂₇ C ≡ true))
κ₃-is-five = (refl , cube-five-suffices) , cube-≤4-fails

-- THE TWO-POINT FIT, at the first term it did not see.  ⌈(3/2)³⌉ = 4.
TwoPointFitAtThree : Type₀
TwoPointFitAtThree =
  Σ[ C ∈ List W₂₇ ] ((length C ≡ 4) × (suffices triCube allA₂₇ C ≡ true))

two-point-fit-refuted : ¬ TwoPointFitAtThree
two-point-fit-refuted (C , len , h) = cube-≤4-fails C (0 , len) h

------------------------------------------------------------------------
-- 5.  κ₄ = 8, which closes m-0's bracket [6, 9] to a point.
------------------------------------------------------------------------

A₈₁ : Type₀
A₈₁ = A₃ × A₂₇

W₈₁ : Type₀
W₈₁ = W₃ × W₂₇

allA₈₁ : List A₈₁
allA₈₁ = pairsOf allA₃ allA₂₇

triQuad : Rel A₈₁ W₈₁
triQuad = tri ⊗ᴿ triCube

-- UPPER BOUND.  Eight product witnesses, built by the construction the
-- peeling law prescribes: split the eight by their head component into
-- groups of 3, 3, 2 so that deleting any one group leaves a family whose
-- tails cover the cube.  Two of the three residues are `cube5` and its
-- image under exchanging α₁ ↔ α₃ in the first tail coordinate; the third
-- is the remaining six.  In complement coordinates:
--
--   1311 1322 1133 | 2111 2122 2333 | 3212 3221
cube8 : List W₈₁
cube8 = (e₂₃ , (e₁₂ , (e₂₃ , e₂₃)))
      ∷ (e₂₃ , (e₁₂ , (e₁₃ , e₁₃)))
      ∷ (e₂₃ , (e₂₃ , (e₁₂ , e₁₂)))
      ∷ (e₁₃ , (e₂₃ , (e₂₃ , e₂₃)))
      ∷ (e₁₃ , (e₂₃ , (e₁₃ , e₁₃)))
      ∷ (e₁₃ , (e₁₂ , (e₁₂ , e₁₂)))
      ∷ (e₁₂ , (e₁₃ , (e₂₃ , e₁₃)))
      ∷ (e₁₂ , (e₁₃ , (e₁₃ , e₂₃)))
      ∷ []

quad-eight-suffices : suffices triQuad allA₈₁ cube8 ≡ true
quad-eight-suffices = refl

-- LOWER BOUND.  Peel again, now against §4's own conclusion.
-- 2·7 = 14 < 15 = 3·5.
quad-≤7-fails :
  (C : List W₈₁) → length C ≤ 7 → ¬ (suffices triQuad allA₈₁ C ≡ true)
quad-≤7-fails = peel-lower triCube allA₂₇ 4 7 cube-≤4-fails (0 , refl)

-- κ₄ = 8, both sides.  m-0's bracket at n = 4 was [6, 9]; this is the point.
κ₄-is-eight :
  ((length cube8 ≡ 8) × (suffices triQuad allA₈₁ cube8 ≡ true))
  × ((C : List W₈₁) → length C ≤ 7 → ¬ (suffices triQuad allA₈₁ C ≡ true))
κ₄-is-eight = (refl , quad-eight-suffices) , quad-≤7-fails

-- ⌈(3/2)⁴⌉ = 6, so the two-point fit is dead a second time, with room to
-- spare: the peeling law refuses everything up to 7.
TwoPointFitAtFour : Type₀
TwoPointFitAtFour =
  Σ[ C ∈ List W₈₁ ] ((length C ≡ 6) × (suffices triQuad allA₈₁ C ≡ true))

two-point-fit-refuted-again : ¬ TwoPointFitAtFour
two-point-fit-refuted-again (C , len , h) = quad-≤7-fails C (1 , cong suc len) h

------------------------------------------------------------------------
-- 6.  REFUTATION OF MY OWN CLAIM, and the controls.
--
-- CLAIM R: the integrality penalty is paid once, κ_n = ⌈κ₀·τ*^{n-1}⌉.  At
-- n = 4 that is ⌈2·(3/2)³⌉ = ⌈27/4⌉ = 7.  Stated as the interface it
-- asserts, and killed.
--
-- Claim R is the strongest reading of Delta 03 §2's own remainder, "There
-- may remain subexponential overhead, but no positive per-instance
-- logarithmic penalty": a bounded overhead is subexponential, and a bounded
-- overhead is what a law κ_n = ⌈c·τ*ⁿ⌉ asserts.  Bounded is not what the
-- exact values do.
------------------------------------------------------------------------

ClaimR : Type₀
ClaimR =
  Σ[ C ∈ List W₈₁ ] ((length C ≡ 7) × (suffices triQuad allA₈₁ C ≡ true))

claimR-refuted : ¬ ClaimR
claimR-refuted (C , len , h) = quad-≤7-fails C (0 , len) h

-- The overhead κ_n·2ⁿ / 3ⁿ at n = 2, 3, 4, compared in exact integers:
-- 4/3 < 40/27 < 128/81.  A ratio that climbs is not a constant c with
-- κ_n = ⌈c·τ*ⁿ⌉.
overhead-strictly-grows : (4 · 27 < 40 · 3) × (40 · 81 < 128 · 27)
overhead-strictly-grows = (11 , refl) , (215 , refl)

-- NON-VACUITY CONTROLS, in m-0's idiom: `any? p [] ≡ false` typechecks for
-- every p, so an exhaustive negative over an empty or short enumeration is
-- green and worthless.  Here the negatives are structural rather than
-- enumerative, so what needs guarding is instead that the two `refl`s above
-- are not reporting a predicate that says `true` to everything.  They are
-- not: deleting one witness from either family makes `suffices` compute
-- `false`, which is also the value §4 and §5 predict for every family that
-- short.
enumeration-sizes-here :
  (length allA₂₇ ≡ 27) × (length allA₈₁ ≡ 81)
  × (length cube5 ≡ 5) × (length cube8 ≡ 8)
enumeration-sizes-here = refl , refl , refl , refl

dropping-one-breaks-it :
  (suffices triCube allA₂₇
     ((e₂₃ , (e₁₃ , e₁₃)) ∷ (e₁₃ , (e₂₃ , e₁₃)) ∷ (e₁₃ , (e₁₃ , e₂₃))
      ∷ (e₁₂ , (e₁₂ , e₁₂)) ∷ []) ≡ false)
  × (suffices triQuad allA₈₁
       ((e₂₃ , (e₁₂ , (e₁₃ , e₁₃))) ∷ (e₂₃ , (e₂₃ , (e₁₂ , e₁₂)))
        ∷ (e₁₃ , (e₂₃ , (e₂₃ , e₂₃))) ∷ (e₁₃ , (e₂₃ , (e₁₃ , e₁₃)))
        ∷ (e₁₃ , (e₁₂ , (e₁₂ , e₁₂))) ∷ (e₁₂ , (e₁₃ , (e₂₃ , e₁₃)))
        ∷ (e₁₂ , (e₁₃ , (e₁₃ , e₂₃))) ∷ []) ≡ false)
dropping-one-breaks-it = refl , refl

------------------------------------------------------------------------
-- 7.  The peeling law is pinned to the fractional rate.
--
-- L is the sequence §3 delivers: L 0 = 1 (the empty task has one witness,
-- the empty tuple), L (n+1) = ⌈(3/2)·L n⌉.  It reproduces 1, 2, 3, 5, 8 —
-- every exact value known, including both new ones.  The cap below says
-- 2ⁿ·(L n + 1) ≤ 2·3ⁿ, so L grows at rate exactly 3/2 = τ*.
--
-- Two readings, both worth having.  Delta 03 §1 says the truth is exactly
-- that rate, so §3 is an asymptotically tight lower-bound family and this is
-- a consistency check on it, in integers, with no LP anywhere.  And read as
-- a method: no bound obtained by iterating §3 could ever have put K∞ above
-- log τ*, so had G∞ still been open this family could not have closed it.
-- Positive data about the mechanism, not the negation of a missed search.
------------------------------------------------------------------------

half⌈⌉ : ℕ → ℕ
half⌈⌉ zero          = zero
half⌈⌉ (suc zero)    = suc zero
half⌈⌉ (suc (suc n)) = suc (half⌈⌉ n)

step : ℕ → ℕ
step x = x + half⌈⌉ x

L : ℕ → ℕ
L zero    = 1
L (suc n) = step (L n)

L-agrees-with-the-exact-values :
  (L 0 ≡ 1) × (L 1 ≡ 2) × (L 2 ≡ 3) × (L 3 ≡ 5) × (L 4 ≡ 8)
L-agrees-with-the-exact-values = refl , refl , refl , refl , refl

2·half⌈⌉ : (x : ℕ) → (half⌈⌉ x + half⌈⌉ x) ≤ x + 1
2·half⌈⌉ zero          = 1 , refl
2·half⌈⌉ (suc zero)    = 0 , refl
2·half⌈⌉ (suc (suc n)) with 2·half⌈⌉ n
... | (d , p) =
  d , ( +-suc d (half⌈⌉ n + suc (half⌈⌉ n))
      ∙ cong (λ u → suc (d + u)) (+-suc (half⌈⌉ n) (half⌈⌉ n))
      ∙ cong suc (+-suc d (half⌈⌉ n + half⌈⌉ n))
      ∙ cong suc (cong suc p) )

≡→≤ : {a b : ℕ} → a ≡ b → a ≤ b
≡→≤ p = 0 , p

mono-·ˡ : (c : ℕ) {a b : ℕ} → a ≤ b → c · a ≤ c · b
mono-·ˡ c {a} {b} le = subst2 _≤_ (·-comm a c) (·-comm b c) (≤-·k le)

-- Pure semiring identities.  The reflection-based solver cannot read a term
-- that reduces to `suc _`, so every constant here is written on the right.
expand : (d x h : ℕ) → d + (2 · ((x + h) + 1)) ≡ (d + (h + h)) + (x + (x + 2))
expand = solve

collect : (x : ℕ) → (x + 1) + (x + (x + 2)) ≡ 3 · (x + 1)
collect = solve

swapL : (a b c : ℕ) → (a · b) · c ≡ b · (a · c)
swapL = solve

mid : (a b c : ℕ) → a · (b · c) ≡ b · (a · c)
mid = solve

-- ONE PEEL STEP BUYS AT MOST THE FRACTIONAL FACTOR.
step-cap : (x : ℕ) → 2 · (step x + 1) ≤ 3 · (x + 1)
step-cap x with 2·half⌈⌉ x
... | (d , p) =
  d , ( expand d x (half⌈⌉ x)
      ∙ cong (_+ (x + (x + 2))) p
      ∙ collect x )

-- HENCE THE WHOLE ITERATION IS PINNED TO IT: 2ⁿ·(L n + 1) ≤ 2·3ⁿ.
peel-rate-capped : (n : ℕ) → (2 ^ n) · (L n + 1) ≤ 2 · (3 ^ n)
peel-rate-capped zero    = 0 , refl
peel-rate-capped (suc n) =
  ≤-trans (≡→≤ (swapL 2 (2 ^ n) (step (L n) + 1)))
    (≤-trans (mono-·ˡ (2 ^ n) (step-cap (L n)))
      (≤-trans (≡→≤ (mid (2 ^ n) 3 (L n + 1)))
        (≤-trans (mono-·ˡ 3 (peel-rate-capped n))
                 (≡→≤ (mid 3 2 (3 ^ n))))))

-- The cap at the first place it bites: 2⁴·(L 4 + 1) = 144 ≤ 162 = 2·3⁴.
cap-at-four : (2 ^ 4) · (L 4 + 1) ≤ 2 · (3 ^ 4)
cap-at-four = peel-rate-capped 4
