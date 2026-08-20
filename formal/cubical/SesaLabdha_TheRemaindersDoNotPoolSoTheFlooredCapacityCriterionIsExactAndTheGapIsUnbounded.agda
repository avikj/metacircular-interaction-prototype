{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- शेष-लब्ध — SesaLabdha
--
-- THE SOURCE, WITH TEXT AND DATE.
--
--   Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda (499 CE).  The kuṭṭaka is stated
--   as a division that keeps two quantities apart and names both: the
--   **labdha** (लब्ध, "what is obtained" — the quotient) and the **śeṣa**
--   (शेष, "what is left" — the remainder).  The procedure's content is that
--   the śeṣa is *carried*, not discarded: one recurses on the śeṣa.
--
--   Brahmagupta, *Brāhmasphuṭasiddhānta* XVIII (628 CE) carries the same
--   two words through his treatment of the kuṭṭaka.
--
-- WHAT IS CLAIMED OF THOSE TEXTS: only the vocabulary and the distinction
-- it draws — that a division yields a labdha and a śeṣa, that these are two
-- quantities of different standing, and that the śeṣa is carried rather
-- than thrown away.  That distinction is what this module is about, one
-- level up: what happens when several śeṣas are *pooled* rather than each
-- being carried separately.
--
-- WHAT IS NOT CLAIMED: neither Āryabhaṭa nor Brahmagupta stated, proved,
-- considered, or would have recognised anything about capacity criteria,
-- box simplices, integer feasibility, or relaxations of them.  No theorem
-- below is theirs and none is attributed to them.  The name names the
-- object; nothing further is asserted of either text.  `purana` below is
-- the ordinary word pūraṇa, "filling"; it is a description, not a citation.
--
-- WHERE THE MATHEMATICS COMES FROM.  This repository's own:
--   `notes/LEAST_FACTOR_REFLECTION_TRANSPORT.md` §2 — Theorem 2 and
--   Remark 2.1 (note by codex-transport; Remark 2.1 added after the
--   opus-mira audit, exp64 Block D), and
--   `collab/discovery/claims/R0024-least-factor-reflection-capacity.md`.
--
-- Theorem 2's proof contains the sentence
--
--     "For integral capacities it is nonempty exactly when
--      sum_q C_q >= |S|; for real capacities replace each C_q by
--      floor(C_q)."
--
-- asserted in one line.  Remark 2.1 promotes the floored form to the
-- criterion (2.4) on the strength of ONE instance, C = (3/2,3/2), |S| = 3.
-- The R0024 audit checked the criterion by brute force over every capacity
-- vector in {0..3}^3 and every total in 0..9.  Nobody proved it.
--
-- Proved here, for capacities that are integers or half-integers, with the
-- greedy allocation as the *canonical element* of the feasibility type —
-- the witness a brute force can only report the existence of.  §7 then
-- kills a claim of my own about how far the two criteria can get apart.
--
-- Landed by `cf-tessera-q-1`, 2026-08-20.  Agda 2.6.3 + cubical v0.5.
-- Not added to `Everything.agda`.
------------------------------------------------------------------------

module SesaLabdha_TheRemaindersDoNotPoolSoTheFlooredCapacityCriterionIsExactAndTheGapIsUnbounded where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map ; length)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Tactics.NatSolver.Reflection using (solve)

------------------------------------------------------------------------
-- §1.  Order on ℕ, self-contained and recursive.
--
-- Given as a recursion rather than an indexed family so that no proof in
-- this module needs indexed pattern matching, which Cubical Agda supports
-- only with a warning.  Everything below is then a structural recursion.
------------------------------------------------------------------------

_≼_ : ℕ → ℕ → Type
zero  ≼ n     = Unit
suc m ≼ zero  = ⊥
suc m ≼ suc n = m ≼ n

≼-refl : (n : ℕ) → n ≼ n
≼-refl zero    = tt
≼-refl (suc n) = ≼-refl n

≼-trans : (a b c : ℕ) → a ≼ b → b ≼ c → a ≼ c
≼-trans zero    b       c       p q = tt
≼-trans (suc a) zero    c       p q = ⊥-rec p
≼-trans (suc a) (suc b) zero    p q = ⊥-rec q
≼-trans (suc a) (suc b) (suc c) p q = ≼-trans a b c p q

≼-suc : (m n : ℕ) → m ≼ n → m ≼ suc n
≼-suc zero    n       p = tt
≼-suc (suc m) zero    p = ⊥-rec p
≼-suc (suc m) (suc n) p = ≼-suc m n p

-- weakening on the left summand
≼-+left : (k m n : ℕ) → m ≼ n → m ≼ (k + n)
≼-+left zero    m n p = p
≼-+left (suc k) m n p = ≼-suc m (k + n) (≼-+left k m n p)

-- weakening on the right summand
≼-+right : (x k : ℕ) → x ≼ (x + k)
≼-+right zero    k = tt
≼-+right (suc x) k = ≼-+right x k

+-mono-≼ : (a b c d : ℕ) → a ≼ b → c ≼ d → (a + c) ≼ (b + d)
+-mono-≼ zero    b       c d p q = ≼-+left b c d q
+-mono-≼ (suc a) zero    c d p q = ⊥-rec p
+-mono-≼ (suc a) (suc b) c d p q = +-mono-≼ a b c d p q

¬suc≼ : (n : ℕ) → ¬ (suc n ≼ n)
¬suc≼ zero    p = p
¬suc≼ (suc n) p = ¬suc≼ n p

------------------------------------------------------------------------
-- §2.  labdha and śeṣa: one division, two quantities.
--
-- A capacity C is carried as the natural number n = 2·C, so half-integer
-- capacities are representable and everything stays in ℕ.  `labdha₂ n` is
-- then ⌊C⌋ and `sesa₂ n` is the part of C that is left over and cannot be
-- spent, because an allocation is a count.
------------------------------------------------------------------------

labdha₂ : ℕ → ℕ
labdha₂ zero          = zero
labdha₂ (suc zero)    = zero
labdha₂ (suc (suc n)) = suc (labdha₂ n)

sesa₂ : ℕ → ℕ
sesa₂ zero          = zero
sesa₂ (suc zero)    = suc zero
sesa₂ (suc (suc n)) = sesa₂ n

-- भागहार — the division statement: labdha doubled, plus śeṣa, recovers the
-- dividend.  Nothing is lost by the split.
bhagahara : (n : ℕ) → (labdha₂ n + labdha₂ n) + sesa₂ n ≡ n
bhagahara zero          = refl
bhagahara (suc zero)    = refl
bhagahara (suc (suc n)) =
  cong suc ( cong (_+ sesa₂ n) (+-suc (labdha₂ n) (labdha₂ n))
           ∙ cong suc (bhagahara n) )

-- one śeṣa is never worth a whole unit
sesa-small : (n : ℕ) → sesa₂ n ≼ suc zero
sesa-small zero          = tt
sesa-small (suc zero)    = tt
sesa-small (suc (suc n)) = sesa-small n

------------------------------------------------------------------------
-- §3.  Pooling.  The one identity this module turns on.
--
-- Summing capacities and summing their labdhas are two different
-- operations and the difference is EXACTLY the pooled śeṣa.  Each śeṣa is
-- individually unspendable (§2 `sesa-small`); their sum is not small at
-- all, and the un-floored criterion silently grants it as capacity.
------------------------------------------------------------------------

sum : List ℕ → ℕ
sum []       = zero
sum (x ∷ xs) = x + sum xs

labdhaSum : List ℕ → ℕ
labdhaSum ns = sum (map labdha₂ ns)

sesaSum : List ℕ → ℕ
sesaSum ns = sum (map sesa₂ ns)

private
  shuffle : (x X r R : ℕ)
          → ((x + X) + (x + X)) + (r + R) ≡ ((x + x) + r) + ((X + X) + R)
  shuffle = solve

pooling : (ns : List ℕ) → (labdhaSum ns + labdhaSum ns) + sesaSum ns ≡ sum ns
pooling []       = refl
pooling (n ∷ ns) =
    shuffle (labdha₂ n) (labdhaSum ns) (sesa₂ n) (sesaSum ns)
  ∙ cong₂ _+_ (bhagahara n) (pooling ns)

------------------------------------------------------------------------
-- §4.  The box simplex, and its canonical element.
--
-- `Feasible fs S` is the type whose elements are integer allocations: a
-- list s of naturals, pointwise below the floored capacities fs, summing
-- to the demand S.  This is the type whose emptiness Theorem 2 is about.
--
-- Asking what a canonical element of that type looks like is what produces
-- `purana`, the greedy allocation, and `purana` is what turns the
-- criterion from an assertion checked on a box into a theorem.
------------------------------------------------------------------------

Pointwise≼ : List ℕ → List ℕ → Type
Pointwise≼ []       []       = Unit
Pointwise≼ []       (y ∷ ys) = ⊥
Pointwise≼ (x ∷ xs) []       = ⊥
Pointwise≼ (x ∷ xs) (y ∷ ys) = (x ≼ y) × Pointwise≼ xs ys

Feasible : List ℕ → ℕ → Type
Feasible fs S = Σ[ s ∈ List ℕ ] (Pointwise≼ s fs × (sum s ≡ S))

least : ℕ → ℕ → ℕ
least zero    n       = zero
least (suc m) zero    = zero
least (suc m) (suc n) = suc (least m n)

sub : ℕ → ℕ → ℕ
sub m       zero    = m
sub zero    (suc n) = zero
sub (suc m) (suc n) = sub m n

least-≼-l : (m n : ℕ) → least m n ≼ m
least-≼-l zero    n       = tt
least-≼-l (suc m) zero    = tt
least-≼-l (suc m) (suc n) = least-≼-l m n

least-≼-r : (m n : ℕ) → least m n ≼ n
least-≼-r zero    n       = tt
least-≼-r (suc m) zero    = tt
least-≼-r (suc m) (suc n) = least-≼-r m n

-- the labdha/śeṣa split again, now for an arbitrary subtrahend: what is
-- taken plus what is left is what there was.
≼→+sub : (m n : ℕ) → m ≼ n → m + sub n m ≡ n
≼→+sub zero    n       p = refl
≼→+sub (suc m) zero    p = ⊥-rec p
≼→+sub (suc m) (suc n) p = cong suc (≼→+sub m n p)

-- THE CANONICAL ELEMENT.  Fill each coordinate as far as it goes and carry
-- the unmet demand forward: `keep the śeṣa and recurse on it`, applied to a
-- demand rather than to a dividend.
purana : List ℕ → ℕ → List ℕ
purana []       S = []
purana (f ∷ fs) S = least f S ∷ purana fs (sub S (least f S))

purana-≼ : (fs : List ℕ) (S : ℕ) → Pointwise≼ (purana fs S) fs
purana-≼ []       S = tt
purana-≼ (f ∷ fs) S = least-≼-l f S , purana-≼ fs (sub S (least f S))

-- the residual demand after a greedy step is still met by what is left
sub-least-≼ : (S f t : ℕ) → S ≼ (f + t) → sub S (least f S) ≼ t
sub-least-≼ S       zero    t p = p
sub-least-≼ zero    (suc f) t p = tt
sub-least-≼ (suc S) (suc f) t p = sub-least-≼ S f t p

purana-sum : (fs : List ℕ) (S : ℕ) → S ≼ sum fs → sum (purana fs S) ≡ S
purana-sum []       zero    p = refl
purana-sum []       (suc S) p = ⊥-rec p
purana-sum (f ∷ fs) S       p =
    cong (least f S +_)
         (purana-sum fs (sub S (least f S)) (sub-least-≼ S f (sum fs) p))
  ∙ ≼→+sub (least f S) S (least-≼-r f S)

sum-mono : (s fs : List ℕ) → Pointwise≼ s fs → sum s ≼ sum fs
sum-mono []       []       p       = tt
sum-mono []       (y ∷ ys) p       = ⊥-rec p
sum-mono (x ∷ xs) []       p       = ⊥-rec p
sum-mono (x ∷ xs) (y ∷ ys) (q , r) =
  +-mono-≼ x y (sum xs) (sum ys) q (sum-mono xs ys r)

-- (2.4), both directions, for arbitrary floored capacity lists.
criterion-if : (fs : List ℕ) (S : ℕ) → S ≼ sum fs → Feasible fs S
criterion-if fs S p = purana fs S , (purana-≼ fs S , purana-sum fs S p)

criterion-onlyif : (fs : List ℕ) (S : ℕ) → Feasible fs S → S ≼ sum fs
criterion-onlyif fs S (s , (q , e)) = subst (_≼ sum fs) e (sum-mono s fs q)

------------------------------------------------------------------------
-- §5.  Guarding the exhaustion.
--
-- §4 is universally quantified over capacity lists INCLUDING the empty
-- one, where the statement is about nothing: at fs = [] the only feasible
-- demand is zero.  Recorded so that no reading of §4 mistakes a vacuous
-- instance for a real one; a non-vacuous witness follows, with its length
-- checked rather than assumed.
------------------------------------------------------------------------

pw-nil : (s : List ℕ) → Pointwise≼ s [] → sum s ≡ zero
pw-nil []       p = refl
pw-nil (x ∷ xs) p = ⊥-rec p

empty-forces-zero : (S : ℕ) → Feasible [] S → S ≡ zero
empty-forces-zero S (s , (q , e)) = sym e ∙ pw-nil s q

witness-caps : List ℕ
witness-caps = 2 ∷ 1 ∷ []

witness-caps-length : length witness-caps ≡ 2
witness-caps-length = refl

witness-feasible : Feasible witness-caps 3
witness-feasible = 2 ∷ 1 ∷ []
                 , ((≼-refl 2 , (≼-refl 1 , tt)) , refl)

-- and the canonical element agrees with it on the nose
witness-purana : purana witness-caps 3 ≡ 2 ∷ 1 ∷ []
witness-purana = refl

-- `purana` computes, and it is greedy rather than balanced: at demand 2
-- over three unit capacities it spends the first two and leaves the third
-- at zero.  Recorded because "a canonical element exists" is a weaker
-- statement than "here it is", and this module claims the second.
purana-computes-full : purana (1 ∷ 1 ∷ 1 ∷ []) 3 ≡ 1 ∷ 1 ∷ 1 ∷ []
purana-computes-full = refl

purana-computes-greedy : purana (1 ∷ 1 ∷ 1 ∷ []) 2 ≡ 1 ∷ 1 ∷ 0 ∷ []
purana-computes-greedy = refl

-- the floors of Remark 2.1's capacities really are (1,1): a demand of 2 is
-- met exactly, a demand of 3 is not met at all by the greedy fill.
remark-2-1-floors : map labdha₂ (3 ∷ 3 ∷ []) ≡ 1 ∷ 1 ∷ []
remark-2-1-floors = refl

remark-2-1-purana-falls-short : sum (purana (1 ∷ 1 ∷ []) 3) ≡ 2
remark-2-1-purana-falls-short = refl

------------------------------------------------------------------------
-- §6.  The two criteria, and the ordering between them.
--
--   FlooredOK ns S  —  criterion (2.4):  S ≤ Σ_q ⌊C_q⌋
--   RelaxedOK ns S  —  the R0024 packet's registered line:  S ≤ Σ_q C_q,
--                      written 2S ≤ Σ_q 2C_q so as to stay in ℕ.
--
-- Both read "no scalar contradiction is available".  `floored→relaxed`
-- says the floored criterion is the stronger detector: whatever the
-- floored one passes, the relaxed one passes.  The converse fails, and §7
-- says by how much.
------------------------------------------------------------------------

FlooredOK : List ℕ → ℕ → Type
FlooredOK ns S = S ≼ labdhaSum ns

RelaxedOK : List ℕ → ℕ → Type
RelaxedOK ns S = (S + S) ≼ sum ns

floored→relaxed : (ns : List ℕ) (S : ℕ) → FlooredOK ns S → RelaxedOK ns S
floored→relaxed ns S p =
  subst ((S + S) ≼_) (pooling ns)
    (≼-trans (S + S)
             (labdhaSum ns + labdhaSum ns)
             ((labdhaSum ns + labdhaSum ns) + sesaSum ns)
             (+-mono-≼ S (labdhaSum ns) S (labdhaSum ns) p p)
             (≼-+right (labdhaSum ns + labdhaSum ns) (sesaSum ns)))

-- Remark 2.1's own instance, checked: C = (3/2, 3/2), |S| = 3.
remark-2-1-caps : List ℕ
remark-2-1-caps = 3 ∷ 3 ∷ []

remark-2-1-relaxed : RelaxedOK remark-2-1-caps 3
remark-2-1-relaxed = ≼-refl 6

remark-2-1-not-floored : ¬ FlooredOK remark-2-1-caps 3
remark-2-1-not-floored p = p

-- so the integer box simplex really is empty there — the statement the
-- note needs and the packet's registered line does not deliver.
remark-2-1-infeasible : ¬ Feasible (map labdha₂ remark-2-1-caps) 3
remark-2-1-infeasible ft =
  remark-2-1-not-floored (criterion-onlyif (map labdha₂ remark-2-1-caps) 3 ft)

------------------------------------------------------------------------
-- §7.  MY OWN CLAIM, AND ITS REFUTATION.
--
-- Remark 2.1 exhibits one instance and it is a TIGHT one: Σ C_q = 3 = |S|
-- exactly, zero slack.  Reading it, I claimed the disagreement between the
-- two criteria is a boundary phenomenon — that the relaxed criterion can
-- only mislead when it passes with no slack, so a strictly slack relaxed
-- pass is safe.  That is the attractive claim, because it would make the
-- packet's registered line wrong only on a knife edge and the floors a
-- rounding detail.
--
-- It is false, and the gap is unbounded.
------------------------------------------------------------------------

GapOnlyAtTheBoundary : Type
GapOnlyAtTheBoundary =
  (ns : List ℕ) (S : ℕ) → RelaxedOK ns S → (¬ FlooredOK ns S)
  → sum ns ≼ (S + S)          -- "the relaxed pass had no slack"

-- the family: (2+n) capacities of 3/2 each, demand 3+n.
caps : ℕ → List ℕ
caps zero    = 3 ∷ 3 ∷ []
caps (suc n) = 3 ∷ caps n

caps-length : (n : ℕ) → length (caps n) ≡ 2 + n
caps-length zero    = refl
caps-length (suc n) = cong (1 +_) (caps-length n)

private
  step-lemma : (A k : ℕ)
             → suc (suc (suc ((A + A) + k))) ≡ ((suc A + suc A) + suc k)
  step-lemma A k =
      cong (λ z → suc (suc z)) (sym (+-suc (A + A) k))
    ∙ sym (cong (_+ suc k) (cong suc (+-suc A A)))

-- Σ_q 2C_q = 2·(demand) + n.  The relaxed criterion passes with slack
-- exactly n halves, i.e. n/2 units of capacity, growing without bound.
caps-sum : (n : ℕ) → sum (caps n) ≡ (((3 + n) + (3 + n)) + n)
caps-sum zero    = refl
caps-sum (suc n) = cong (3 +_) (caps-sum n) ∙ step-lemma (3 + n) n

caps-labdhaSum : (n : ℕ) → labdhaSum (caps n) ≡ 2 + n
caps-labdhaSum zero    = refl
caps-labdhaSum (suc n) = cong (1 +_) (caps-labdhaSum n)

caps-relaxed : (n : ℕ) → RelaxedOK (caps n) (3 + n)
caps-relaxed n =
  subst (((3 + n) + (3 + n)) ≼_) (sym (caps-sum n))
        (≼-+right ((3 + n) + (3 + n)) n)

caps-not-floored : (n : ℕ) → ¬ FlooredOK (caps n) (3 + n)
caps-not-floored n p =
  ¬suc≼ (2 + n) (subst ((3 + n) ≼_) (caps-labdhaSum n) p)

-- The theorem.  For every n: the relaxed criterion passes, the floored one
-- fails, the slack in the relaxed pass is exactly n, and the capacity list
-- has length 2+n — so no instance of this family is vacuous.
unbounded-gap : (n : ℕ)
  → RelaxedOK (caps n) (3 + n)
  × ((¬ FlooredOK (caps n) (3 + n))
  × ((sum (caps n) ≡ (((3 + n) + (3 + n)) + n))
  × (length (caps n) ≡ 2 + n)))
unbounded-gap n =
  caps-relaxed n , (caps-not-floored n , (caps-sum n , caps-length n))

private
  ¬9≼8 : ¬ (9 ≼ 8)
  ¬9≼8 p = p

-- KILLED, at n = 1: three capacities of 3/2, demand 4.  Σ C = 4.5 ≥ 4 with
-- slack 1/2, so the relaxed criterion passes and is NOT tight; Σ ⌊C⌋ = 3
-- < 4, so the integer box simplex is empty regardless.
myClaimIsFalse : ¬ GapOnlyAtTheBoundary
myClaimIsFalse h = ¬9≼8 (h (caps 1) 4 (caps-relaxed 1) (caps-not-floored 1))

-- What survives of the claim, stated exactly: the ordering of §6 and
-- nothing about distance.  The floored criterion is the stronger detector,
-- and how much stronger is bounded by nothing visible to the relaxed one.
------------------------------------------------------------------------
