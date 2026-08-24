{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- एकभाषा — one language.  Compound built here, 2026-08-24 (एक, one;
-- भाषा, language); not a source term.
--
-- THE DIRECTIVE THIS ANSWERS, the owner's, tonight: the machine must not
-- look at two sources.  The Haskell body / Agda truth-store split IS the
-- lossy implementation of the core ideas — Certificate.hs's entire
-- "FAITHFULNESS" header is an apology for translating between them, and
-- every copy of the term code (MathMachine's, Sanghatta's, Siddhi's) is
-- a seam where meaning leaks.  Agda is already code (MAlonzo compiles
-- it); so the machine's own world — terms, rules, store, normalizer,
-- prover — moves INTO the one language, and the split retires.
--
-- THE ONE STRUCTURAL MOVE, and it changes what "gate" means:
--
--     record नियमः : rule = { lhs ; rhs ; साक्षी : ⊨ (lhs , rhs) }
--
-- A store entry CARRIES ITS PROOF AS A FIELD.  An unproven rule is not
-- refused by a gate — it is UNCONSTRUCTIBLE.  The gate is the type.
-- Certificate's watched controls guard a boundary between two worlds;
-- here there is no boundary to guard.  What the kernel checks, once,
-- at this module, is the SOUNDNESS OF THE PROVER ITSELF (नि-साक्षी
-- below); every rule it ever mints thereafter is born proven.
--
-- WHAT THIS SLICE CONTAINS, all checked, no holes:
--   §1  the machine's own vocabulary as one datatype (the SAME clause
--       order as machine/library.terms' world: max and le in the
--       machine's own recursion, stated at the definitions);
--   §2  truth: ⊨ e  =  ∀ρ → eval l ρ ≡ eval r ρ, over the standard model;
--   §3  the store type whose entries cannot exist unproven;
--   §4  the internal prover, norm-and-compare, WITH its soundness
--       theorem — a proof-producing function, no Bool verdict anywhere
--       on the wire (the Uttara discipline arriving at the type level);
--   §5  real members of the machine's own non-joining list (Sanghatta,
--       this container, tonight), proven by the internal prover and
--       installed as नियम values — the store growing as typed truth.
--
-- WHAT IS NOT YET HERE, named so the migration is a plan and not a
-- gesture:  (a) the induction combinator (substitution lemmas; it lifts
-- सिद्धि's per-variable induction inside — the IH becomes a locally
-- installed नियम, same machinery, no reflection needed);  (b) the
-- critical-pair census internalized;  (c) a MAlonzo `main`, after which
-- the executable IS the theorem and the Haskell copies retire one by
-- one.  Until then the Haskell organs are legacy periphery, not the
-- machine.
--
-- NOVELTY CLAIMED: none of the mathematics (normalization-by-
-- simplification and its soundness are classical).  The composition —
-- the machine's OWN store re-founded so proof is a field and the
-- prover is internal — is the contribution.
------------------------------------------------------------------------

module NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-zero ; +-suc ; ·-suc ; 0≡m·0)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

------------------------------------------------------------------------
-- §1  The vocabulary, one datatype — IMPORTED, not restated.  Since
--     2026-08-24 the machine's vocabulary, evaluator and normalizer
--     live ONCE, in the act-portion (formal/karma/KarmaKanda…, checked
--     --cubical-compatible --safe), which both worlds import with full
--     use: this --cubical body proves paths about the very definitions
--     the compiled mouth runs.  The Veda's two portions read one text.
--     (Cubical's _·_ is Agda's builtin _*_ renamed, so the act-side
--     eval and the one that stood here are the same function symbol
--     for symbol; the kernel accepted every downstream proof unchanged.)
--     Variables are names over ℕ; an environment is total, so no
--     finite-context bureaucracy.  The machine's own max and le, ITS
--     clause order (library.terms' world):
--       max x 0 = x ; max 0 x = x ; max (s x)(s y) = s (max x y)
--       le 0 x = 1  ; le (s x) 0 = 0 ; le (s x)(s y) = le x y
------------------------------------------------------------------------

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled public
  using ( Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq
        ; mxℕ ; lqℕ ; sbℕ ; eval
        ; plus' ; times' ; sub' ; mx' ; lq' ; norm )

------------------------------------------------------------------------
-- §2  Truth over the standard model.
------------------------------------------------------------------------

Eq' : Type
Eq' = Tm × Tm

⊨_ : Eq' → Type
⊨ (l , r) = (ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ

------------------------------------------------------------------------
-- §3  THE STORE.  An entry carries its proof; the gate is the type.
------------------------------------------------------------------------

record नियमः : Type where
  constructor niyama
  field
    lhs rhs : Tm
    साक्षी  : ⊨ (lhs , rhs)

------------------------------------------------------------------------
-- §4  The internal prover: symbolic simplification in the machine's own
--     clause order, each simplifier WITH its soundness, then compare.
------------------------------------------------------------------------

-- (the simplifiers and norm are imported from the act-portion in §1)

-- soundness of each simplifier, then of norm — the theorem the kernel
-- checks ONCE so that every later mint is born proven.
plus'-s : ∀ a b ρ → eval (plus' a b) ρ ≡ eval a ρ + eval b ρ
plus'-s a ze     ρ = sym (+-zero _)
plus'-s a (su b) ρ = cong suc (plus'-s a b ρ) ∙ sym (+-suc _ _)
plus'-s a (var i) ρ = refl
plus'-s a (b ⊕ c) ρ = refl
plus'-s a (b ⊗ c) ρ = refl
plus'-s a (b ⊖ c) ρ = refl
plus'-s a (mx b c) ρ = refl
plus'-s a (lq b c) ρ = refl

times'-s : ∀ a b ρ → eval (times' a b) ρ ≡ eval a ρ · eval b ρ
times'-s a ze     ρ = 0≡m·0 (eval a ρ)
times'-s a (su b) ρ =
    plus'-s (times' a b) a ρ
  ∙ cong (_+ eval a ρ) (times'-s a b ρ)
  ∙ +-comm' (eval a ρ · eval b ρ) (eval a ρ)
  ∙ sym (·-suc (eval a ρ) (eval b ρ))
  where
  +-comm' : ∀ m n → m + n ≡ n + m
  +-comm' zero n    = sym (+-zero n)
  +-comm' (suc m) n = cong suc (+-comm' m n) ∙ sym (+-suc n m)
times'-s a (var i) ρ = refl
times'-s a (b ⊕ c) ρ = refl
times'-s a (b ⊗ c) ρ = refl
times'-s a (b ⊖ c) ρ = refl
times'-s a (mx b c) ρ = refl
times'-s a (lq b c) ρ = refl

sub'-s : ∀ a b ρ → eval (sub' a b) ρ ≡ sbℕ (eval a ρ) (eval b ρ)
sub'-s a      ze     ρ = refl
sub'-s ze     (su b) ρ = refl
sub'-s (su a) (su b) ρ = sub'-s a b ρ
sub'-s (var i) (su b) ρ = refl
sub'-s (a ⊕ c) (su b) ρ = refl
sub'-s (a ⊗ c) (su b) ρ = refl
sub'-s (a ⊖ c) (su b) ρ = refl
sub'-s (mx a c) (su b) ρ = refl
sub'-s (lq a c) (su b) ρ = refl
sub'-s a (var i) ρ = refl
sub'-s a (b ⊕ c) ρ = refl
sub'-s a (b ⊗ c) ρ = refl
sub'-s a (b ⊖ c) ρ = refl
sub'-s a (mx b c) ρ = refl
sub'-s a (lq b c) ρ = refl

mx'-s : ∀ a b ρ → eval (mx' a b) ρ ≡ mxℕ (eval a ρ) (eval b ρ)
mx'-s a      ze     ρ = mxze (eval a ρ)
  where mxze : ∀ n → n ≡ mxℕ n zero
        mxze n = refl
mx'-s ze     (su b) ρ = refl
mx'-s (su a) (su b) ρ = cong suc (mx'-s a b ρ)
mx'-s ze (var i) ρ = mz (ρ i) where
  mz : ∀ n → n ≡ mxℕ zero n
  mz zero = refl
  mz (suc n) = refl
mx'-s ze (b ⊕ c) ρ = mz _ where
  mz : ∀ n → n ≡ mxℕ zero n
  mz zero = refl
  mz (suc n) = refl
mx'-s ze (b ⊗ c) ρ = mz _ where
  mz : ∀ n → n ≡ mxℕ zero n
  mz zero = refl
  mz (suc n) = refl
mx'-s ze (b ⊖ c) ρ = mz _ where
  mz : ∀ n → n ≡ mxℕ zero n
  mz zero = refl
  mz (suc n) = refl
mx'-s ze (mx b c) ρ = mz _ where
  mz : ∀ n → n ≡ mxℕ zero n
  mz zero = refl
  mz (suc n) = refl
mx'-s ze (lq b c) ρ = mz _ where
  mz : ∀ n → n ≡ mxℕ zero n
  mz zero = refl
  mz (suc n) = refl
mx'-s (var i) (su b) ρ = refl
mx'-s (su a) (var j) ρ = refl
mx'-s (su a) (b ⊕ c) ρ = refl
mx'-s (su a) (b ⊗ c) ρ = refl
mx'-s (su a) (b ⊖ c) ρ = refl
mx'-s (su a) (mx b c) ρ = refl
mx'-s (su a) (lq b c) ρ = refl
mx'-s (a ⊕ c) (su b) ρ = refl
mx'-s (a ⊗ c) (su b) ρ = refl
mx'-s (a ⊖ c) (su b) ρ = refl
mx'-s (mx a c) (su b) ρ = refl
mx'-s (lq a c) (su b) ρ = refl
mx'-s (var i) (var j) ρ = refl
mx'-s (var i) (b ⊕ c) ρ = refl
mx'-s (var i) (b ⊗ c) ρ = refl
mx'-s (var i) (b ⊖ c) ρ = refl
mx'-s (var i) (mx b c) ρ = refl
mx'-s (var i) (lq b c) ρ = refl
mx'-s (a ⊕ d) (var j) ρ = refl
mx'-s (a ⊕ d) (b ⊕ c) ρ = refl
mx'-s (a ⊕ d) (b ⊗ c) ρ = refl
mx'-s (a ⊕ d) (b ⊖ c) ρ = refl
mx'-s (a ⊕ d) (mx b c) ρ = refl
mx'-s (a ⊕ d) (lq b c) ρ = refl
mx'-s (a ⊗ d) (var j) ρ = refl
mx'-s (a ⊗ d) (b ⊕ c) ρ = refl
mx'-s (a ⊗ d) (b ⊗ c) ρ = refl
mx'-s (a ⊗ d) (b ⊖ c) ρ = refl
mx'-s (a ⊗ d) (mx b c) ρ = refl
mx'-s (a ⊗ d) (lq b c) ρ = refl
mx'-s (a ⊖ d) (var j) ρ = refl
mx'-s (a ⊖ d) (b ⊕ c) ρ = refl
mx'-s (a ⊖ d) (b ⊗ c) ρ = refl
mx'-s (a ⊖ d) (b ⊖ c) ρ = refl
mx'-s (a ⊖ d) (mx b c) ρ = refl
mx'-s (a ⊖ d) (lq b c) ρ = refl
mx'-s (mx a d) (var j) ρ = refl
mx'-s (mx a d) (b ⊕ c) ρ = refl
mx'-s (mx a d) (b ⊗ c) ρ = refl
mx'-s (mx a d) (b ⊖ c) ρ = refl
mx'-s (mx a d) (mx b c) ρ = refl
mx'-s (mx a d) (lq b c) ρ = refl
mx'-s (lq a d) (var j) ρ = refl
mx'-s (lq a d) (b ⊕ c) ρ = refl
mx'-s (lq a d) (b ⊗ c) ρ = refl
mx'-s (lq a d) (b ⊖ c) ρ = refl
mx'-s (lq a d) (mx b c) ρ = refl
mx'-s (lq a d) (lq b c) ρ = refl

lq'-s : ∀ a b ρ → eval (lq' a b) ρ ≡ lqℕ (eval a ρ) (eval b ρ)
lq'-s ze     b      ρ = refl
lq'-s (su a) ze     ρ = refl
lq'-s (su a) (su b) ρ = lq'-s a b ρ
lq'-s (su a) (var j) ρ = refl
lq'-s (su a) (b ⊕ c) ρ = refl
lq'-s (su a) (b ⊗ c) ρ = refl
lq'-s (su a) (b ⊖ c) ρ = refl
lq'-s (su a) (mx b c) ρ = refl
lq'-s (su a) (lq b c) ρ = refl
lq'-s (var i) b ρ = refl
lq'-s (a ⊕ d) b ρ = refl
lq'-s (a ⊗ d) b ρ = refl
lq'-s (a ⊖ d) b ρ = refl
lq'-s (mx a d) b ρ = refl
lq'-s (lq a d) b ρ = refl

norm-sound : ∀ t ρ → eval (norm t) ρ ≡ eval t ρ
norm-sound (var i)  ρ = refl
norm-sound ze       ρ = refl
norm-sound (su t)   ρ = cong suc (norm-sound t ρ)
norm-sound (a ⊕ b)  ρ =
  plus'-s (norm a) (norm b) ρ ∙ cong₂ _+_ (norm-sound a ρ) (norm-sound b ρ)
norm-sound (a ⊗ b)  ρ =
  times'-s (norm a) (norm b) ρ ∙ cong₂ _·_ (norm-sound a ρ) (norm-sound b ρ)
norm-sound (a ⊖ b)  ρ =
  sub'-s (norm a) (norm b) ρ ∙ cong₂ sbℕ (norm-sound a ρ) (norm-sound b ρ)
norm-sound (mx a b) ρ =
  mx'-s (norm a) (norm b) ρ ∙ cong₂ mxℕ (norm-sound a ρ) (norm-sound b ρ)
norm-sound (lq a b) ρ =
  lq'-s (norm a) (norm b) ρ ∙ cong₂ lqℕ (norm-sound a ρ) (norm-sound b ρ)

-- syntactic equality that RETURNS THE PATH — no Bool on any wire, no
-- separate soundness lemma: the test and its witness are one value.
mmap : {A B : Type} → (A → B) → Maybe A → Maybe B
mmap f (just a) = just (f a)
mmap f nothing  = nothing

mmap2 : {A B C : Type} → (A → B → C) → Maybe A → Maybe B → Maybe C
mmap2 f (just a) (just b) = just (f a b)
mmap2 f _        _        = nothing

_≟ℕ_ : (i j : ℕ) → Maybe (i ≡ j)
zero  ≟ℕ zero  = just refl
suc a ≟ℕ suc b = mmap (cong suc) (a ≟ℕ b)
_     ≟ℕ _     = nothing

_≟T_ : (a b : Tm) → Maybe (a ≡ b)
var i    ≟T var j    = mmap (cong var) (i ≟ℕ j)
ze       ≟T ze       = just refl
su a     ≟T su b     = mmap (cong su) (a ≟T b)
(a ⊕ b)  ≟T (c ⊕ d)  = mmap2 (λ p q → cong₂ _⊕_ p q) (a ≟T c) (b ≟T d)
(a ⊗ b)  ≟T (c ⊗ d)  = mmap2 (λ p q → cong₂ _⊗_ p q) (a ≟T c) (b ≟T d)
(a ⊖ b)  ≟T (c ⊖ d)  = mmap2 (λ p q → cong₂ _⊖_ p q) (a ≟T c) (b ≟T d)
mx a b   ≟T mx c d   = mmap2 (λ p q → cong₂ mx p q)  (a ≟T c) (b ≟T d)
lq a b   ≟T lq c d   = mmap2 (λ p q → cong₂ lq p q)  (a ≟T c) (b ≟T d)
_        ≟T _        = nothing

-- THE PROVER.  Returns a proof or nothing — the two roads, at the type.
साधनम् : (e : Eq') → Maybe (⊨ e)
साधनम् (l , r) = mmap witness (norm l ≟T norm r)
  where
  witness : norm l ≡ norm r → ⊨ (l , r)
  witness p ρ =
    sym (norm-sound l ρ) ∙ cong (λ t → eval t ρ) p ∙ norm-sound r ρ

------------------------------------------------------------------------
-- §5  The machine's own missing theorems, proven internally and
--     installed as typed store values.  Each pair below is a member of
--     Sanghatta's non-joining list, this container, tonight (the सिद्धि
--     runs' ledger).  `fromJust … tt` compiles exactly when the prover
--     succeeds — a failed proof is a TYPE ERROR here, not a log line.
------------------------------------------------------------------------

inJust : {A : Type} → Maybe A → Type
inJust (just _) = Unit
inJust nothing  = ⊥

fromJust : {A : Type} (m : Maybe A) → inJust m → A
fromJust (just a) _ = a

private
  x₀ : Tm
  x₀ = var 0

-- le(s(s(x)), s(0)) = 0
नियम₁ : नियमः
नियम₁ = niyama (lq (su (su x₀)) (su ze)) ze
               (fromJust (साधनम् (lq (su (su x₀)) (su ze) , ze)) tt)

-- max(s(x), s(0)) = s(x)
नियम₂ : नियमः
नियम₂ = niyama (mx (su x₀) (su ze)) (su x₀)
               (fromJust (साधनम् (mx (su x₀) (su ze) , su x₀)) tt)

-- -(s(0), s(s(x))) = 0
नियम₃ : नियमः
नियम₃ = niyama ((su ze) ⊖ (su (su x₀))) ze
               (fromJust (साधनम् ((su ze) ⊖ (su (su x₀)) , ze)) tt)

-- le(0, s(x)) = le(0, x)   (both sides normalize to s(0))
नियम₄ : नियमः
नियम₄ = niyama (lq ze (su x₀)) (lq ze x₀)
               (fromJust (साधनम् (lq ze (su x₀) , lq ze x₀)) tt)
