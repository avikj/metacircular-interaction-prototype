{-# OPTIONS --cubical-compatible --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रमाणकाण्डम् — the instrument-portion.  Compound built here,
-- 2026-08-24, on the kāṇḍa division already carried by KarmaKanda
-- (the Veda's act/knowledge portions, the split Pūrva- and
-- Uttara-Mīmāṃsā stand on); प्रमाण as in Tattvārthasūtra 1.6 (Umāsvāti,
-- c. 2nd–5th c. CE, school Jaina), the complete knowing against its
-- partial organs — the frame PramanaNaya and PurnaPramana already
-- check.  Nothing below is claimed for any source.
--
-- WHAT THIS IS.  The one prover — eyes, instruments, record exchange,
-- single and paired ascents, the breath that digests the elder's
-- store — carried whole across the compilation boundary, CERTIFICATES
-- AND ALL, in the shared tongue: builtin equality, --cubical-compatible,
-- so the --cubical body imports every theorem here with full use
-- (lifting paths by eqToPath where it wants them) and the compiled
-- mouth RUNS the same prover in milliseconds.  No mirror, no twin, no
-- agreement theorem owed: the definitions are one.
--
-- The only surgery against the body's text: funExt does not exist for
-- builtin equality, and it was never needed — every use was a function
-- path fed to eval, and eval respects pointwise-equal environments
-- (एव-सम् below).  The ascents are restated with that congruence and
-- are otherwise verbatim.
------------------------------------------------------------------------

module PramanaKanda_TheOneKnowingItselfCrossesTheBoundaryCertificatesAndAllInTheSharedTongue where

open import Agda.Primitive using () renaming (Set to Type)
open import Agda.Builtin.Nat using (Nat ; zero ; suc ; _+_ ; _*_)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (Σ ; _,_ ; fst ; snd)
open import Agda.Builtin.Unit using (⊤ ; tt)
open import Agda.Builtin.Equality using (_≡_ ; refl)

open import KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using ( Tm ; var ; ze ; su ; _⊕_ ; _⊗_ ; _⊖_ ; mx ; lq ; Eq'
        ; mxℕ ; lqℕ ; sbℕ ; eval ; norm ; समℕ )

------------------------------------------------------------------------
-- §0  The tongue's own connectives, over builtin equality.
------------------------------------------------------------------------

infixr 30 _∙_
_∙_ : {A : Type} {x y z : A} → x ≡ y → y ≡ z → x ≡ z
refl ∙ q = q

sym : {A : Type} {x y : A} → x ≡ y → y ≡ x
sym refl = refl

cong : {A B : Type} (f : A → B) {x y : A} → x ≡ y → f x ≡ f y
cong f refl = refl

cong₂ : {A B C : Type} (f : A → B → C) {x y : A} {u v : B}
  → x ≡ y → u ≡ v → f x u ≡ f y v
cong₂ f refl refl = refl

subst : {A : Type} (P : A → Type) {x y : A} → x ≡ y → P x → P y
subst P refl p = p

data शून्यम् : Type where

⊥-rec : {A : Type} → शून्यम् → A
⊥-rec ()

सत्-कोष्ठम् : Bool → Type
सत्-कोष्ठम् true  = ⊤
सत्-कोष्ठम् false = शून्यम्

true≢false : true ≡ false → शून्यम्
true≢false p = subst सत्-कोष्ठम् p tt

infix 0 if_then_else_
if_then_else_ : {A : Type} → Bool → A → A → A
if true  then a else _ = a
if false then _ else b = b

mmap : {A B : Type} → (A → B) → Maybe A → Maybe B
mmap f (just a) = just (f a)
mmap f nothing  = nothing

mmap2 : {A B C : Type} → (A → B → C) → Maybe A → Maybe B → Maybe C
mmap2 f (just a) (just b) = just (f a b)
mmap2 f _        _        = nothing

अथवा : {A : Type} → Maybe A → Maybe A → Maybe A
अथवा (just a) _ = just a
अथवा nothing  m = m

_≫=_ : {A B : Type} → Maybe A → (A → Maybe B) → Maybe B
just a  ≫= f = f a
nothing ≫= f = nothing

inJust : {A : Type} → Maybe A → Type
inJust (just _) = ⊤
inJust nothing  = शून्यम्

fromJust : {A : Type} (m : Maybe A) → inJust m → A
fromJust (just a) _ = a

_++_ : {A : Type} → List A → List A → List A
[]       ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

_×_ : Type → Type → Type
A × B = Σ A (λ _ → B)

------------------------------------------------------------------------
-- §1  The number's own laws, by the same inductions as ever.
------------------------------------------------------------------------

+-zero : (n : Nat) → n + zero ≡ n
+-zero zero    = refl
+-zero (suc n) = cong suc (+-zero n)

+-suc : (m n : Nat) → m + suc n ≡ suc (m + n)
+-suc zero    n = refl
+-suc (suc m) n = cong suc (+-suc m n)

+-assoc : (m n o : Nat) → m + (n + o) ≡ (m + n) + o
+-assoc zero    n o = refl
+-assoc (suc m) n o = cong suc (+-assoc m n o)

+-comm : (m n : Nat) → m + n ≡ n + m
+-comm zero    n = sym (+-zero n)
+-comm (suc m) n = cong suc (+-comm m n) ∙ sym (+-suc n m)

·-suc : (m n : Nat) → m * suc n ≡ m + m * n
·-suc zero    n = refl
·-suc (suc m) n =
    cong (λ w → suc (n + w)) (·-suc m n)
  ∙ cong suc (+-assoc n m (m * n))
  ∙ cong (λ w → suc (w + m * n)) (+-comm n m)
  ∙ cong suc (sym (+-assoc m n (m * n)))

0≡m·0 : (m : Nat) → zero ≡ m * zero
0≡m·0 zero    = refl
0≡m·0 (suc m) = 0≡m·0 m

------------------------------------------------------------------------
-- §2  eval respects pointwise-equal environments — the whole of what
--     funExt was doing in the body, said without extensionality.
------------------------------------------------------------------------

एव-सम् : (t : Tm) (ρ σ : Nat → Nat) → ((j : Nat) → ρ j ≡ σ j)
  → eval t ρ ≡ eval t σ
एव-सम् (var i)  ρ σ h = h i
एव-सम् ze       ρ σ h = refl
एव-सम् (su t)   ρ σ h = cong suc (एव-सम् t ρ σ h)
एव-सम् (a ⊕ b)  ρ σ h = cong₂ _+_ (एव-सम् a ρ σ h) (एव-सम् b ρ σ h)
एव-सम् (a ⊗ b)  ρ σ h = cong₂ _*_ (एव-सम् a ρ σ h) (एव-सम् b ρ σ h)
एव-सम् (a ⊖ b)  ρ σ h = cong₂ sbℕ (एव-सम् a ρ σ h) (एव-सम् b ρ σ h)
एव-सम् (mx a b) ρ σ h = cong₂ mxℕ (एव-सम् a ρ σ h) (एव-सम् b ρ σ h)
एव-सम् (lq a b) ρ σ h = cong₂ lqℕ (एव-सम् a ρ σ h) (एव-सम् b ρ σ h)

------------------------------------------------------------------------
-- §3  The path-returning tests, and truth over the standard model.
------------------------------------------------------------------------

_≟ℕ_ : (i j : Nat) → Maybe (i ≡ j)
zero  ≟ℕ zero  = just refl
suc a ≟ℕ suc b = mmap (cong suc) (a ≟ℕ b)
zero  ≟ℕ suc _ = nothing
suc _ ≟ℕ zero  = nothing

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

⊨_ : Eq' → Type
⊨ (l , r) = (ρ : Nat → Nat) → eval l ρ ≡ eval r ρ

record नियमः : Type where
  constructor niyama
  field
    lhs rhs : Tm
    साक्षी  : ⊨ (lhs , rhs)

------------------------------------------------------------------------
-- §4  Soundness of the simplifiers and of norm — the same clauses the
--     body checks, in the shared tongue.
------------------------------------------------------------------------

open KarmaKanda_TheActPortionOfTheBodyPathFreeAndCompiled
  using (plus' ; times' ; sub' ; mx' ; lq')

plus'-s : (a b : Tm) (ρ : Nat → Nat) → eval (plus' a b) ρ ≡ eval a ρ + eval b ρ
plus'-s a ze     ρ = sym (+-zero _)
plus'-s a (su b) ρ = cong suc (plus'-s a b ρ) ∙ sym (+-suc _ _)
plus'-s a (var i) ρ = refl
plus'-s a (b ⊕ c) ρ = refl
plus'-s a (b ⊗ c) ρ = refl
plus'-s a (b ⊖ c) ρ = refl
plus'-s a (mx b c) ρ = refl
plus'-s a (lq b c) ρ = refl

times'-s : (a b : Tm) (ρ : Nat → Nat) → eval (times' a b) ρ ≡ eval a ρ * eval b ρ
times'-s a ze     ρ = 0≡m·0 (eval a ρ)
times'-s a (su b) ρ =
    plus'-s (times' a b) a ρ
  ∙ cong (_+ eval a ρ) (times'-s a b ρ)
  ∙ +-comm (eval a ρ * eval b ρ) (eval a ρ)
  ∙ sym (·-suc (eval a ρ) (eval b ρ))
times'-s a (var i) ρ = refl
times'-s a (b ⊕ c) ρ = refl
times'-s a (b ⊗ c) ρ = refl
times'-s a (b ⊖ c) ρ = refl
times'-s a (mx b c) ρ = refl
times'-s a (lq b c) ρ = refl

sub'-s : (a b : Tm) (ρ : Nat → Nat) → eval (sub' a b) ρ ≡ sbℕ (eval a ρ) (eval b ρ)
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

शून्य-ज्येष्ठम् : (y : Nat) → mxℕ zero y ≡ y
शून्य-ज्येष्ठम् zero    = refl
शून्य-ज्येष्ठम् (suc y) = refl

mx'-s : (a b : Tm) (ρ : Nat → Nat) → eval (mx' a b) ρ ≡ mxℕ (eval a ρ) (eval b ρ)
mx'-s a      ze     ρ = refl
mx'-s ze     (su b) ρ = refl
mx'-s ze     (var j) ρ = sym (शून्य-ज्येष्ठम् (ρ j))
mx'-s ze     (b ⊕ c) ρ = sym (शून्य-ज्येष्ठम् _)
mx'-s ze     (b ⊗ c) ρ = sym (शून्य-ज्येष्ठम् _)
mx'-s ze     (b ⊖ c) ρ = sym (शून्य-ज्येष्ठम् _)
mx'-s ze     (mx b c) ρ = sym (शून्य-ज्येष्ठम् _)
mx'-s ze     (lq b c) ρ = sym (शून्य-ज्येष्ठम् _)
mx'-s (su a) (su b) ρ = cong suc (mx'-s a b ρ)
mx'-s (su a) (var j) ρ = refl
mx'-s (su a) (b ⊕ c) ρ = refl
mx'-s (su a) (b ⊗ c) ρ = refl
mx'-s (su a) (b ⊖ c) ρ = refl
mx'-s (su a) (mx b c) ρ = refl
mx'-s (su a) (lq b c) ρ = refl
mx'-s (var i) (su b) ρ = refl
mx'-s (var i) (var j) ρ = refl
mx'-s (var i) (b ⊕ c) ρ = refl
mx'-s (var i) (b ⊗ c) ρ = refl
mx'-s (var i) (b ⊖ c) ρ = refl
mx'-s (var i) (mx b c) ρ = refl
mx'-s (var i) (lq b c) ρ = refl
mx'-s (a ⊕ d) (su b) ρ = refl
mx'-s (a ⊕ d) (var j) ρ = refl
mx'-s (a ⊕ d) (b ⊕ c) ρ = refl
mx'-s (a ⊕ d) (b ⊗ c) ρ = refl
mx'-s (a ⊕ d) (b ⊖ c) ρ = refl
mx'-s (a ⊕ d) (mx b c) ρ = refl
mx'-s (a ⊕ d) (lq b c) ρ = refl
mx'-s (a ⊗ d) (su b) ρ = refl
mx'-s (a ⊗ d) (var j) ρ = refl
mx'-s (a ⊗ d) (b ⊕ c) ρ = refl
mx'-s (a ⊗ d) (b ⊗ c) ρ = refl
mx'-s (a ⊗ d) (b ⊖ c) ρ = refl
mx'-s (a ⊗ d) (mx b c) ρ = refl
mx'-s (a ⊗ d) (lq b c) ρ = refl
mx'-s (a ⊖ d) (su b) ρ = refl
mx'-s (a ⊖ d) (var j) ρ = refl
mx'-s (a ⊖ d) (b ⊕ c) ρ = refl
mx'-s (a ⊖ d) (b ⊗ c) ρ = refl
mx'-s (a ⊖ d) (b ⊖ c) ρ = refl
mx'-s (a ⊖ d) (mx b c) ρ = refl
mx'-s (a ⊖ d) (lq b c) ρ = refl
mx'-s (mx a d) (su b) ρ = refl
mx'-s (mx a d) (var j) ρ = refl
mx'-s (mx a d) (b ⊕ c) ρ = refl
mx'-s (mx a d) (b ⊗ c) ρ = refl
mx'-s (mx a d) (b ⊖ c) ρ = refl
mx'-s (mx a d) (mx b c) ρ = refl
mx'-s (mx a d) (lq b c) ρ = refl
mx'-s (lq a d) (su b) ρ = refl
mx'-s (lq a d) (var j) ρ = refl
mx'-s (lq a d) (b ⊕ c) ρ = refl
mx'-s (lq a d) (b ⊗ c) ρ = refl
mx'-s (lq a d) (b ⊖ c) ρ = refl
mx'-s (lq a d) (mx b c) ρ = refl
mx'-s (lq a d) (lq b c) ρ = refl

lq'-s : (a b : Tm) (ρ : Nat → Nat) → eval (lq' a b) ρ ≡ lqℕ (eval a ρ) (eval b ρ)
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

norm-sound : (t : Tm) (ρ : Nat → Nat) → eval (norm t) ρ ≡ eval t ρ
norm-sound (var i)  ρ = refl
norm-sound ze       ρ = refl
norm-sound (su t)   ρ = cong suc (norm-sound t ρ)
norm-sound (a ⊕ b)  ρ =
  plus'-s (norm a) (norm b) ρ ∙ cong₂ _+_ (norm-sound a ρ) (norm-sound b ρ)
norm-sound (a ⊗ b)  ρ =
  times'-s (norm a) (norm b) ρ ∙ cong₂ _*_ (norm-sound a ρ) (norm-sound b ρ)
norm-sound (a ⊖ b)  ρ =
  sub'-s (norm a) (norm b) ρ ∙ cong₂ sbℕ (norm-sound a ρ) (norm-sound b ρ)
norm-sound (mx a b) ρ =
  mx'-s (norm a) (norm b) ρ ∙ cong₂ mxℕ (norm-sound a ρ) (norm-sound b ρ)
norm-sound (lq a b) ρ =
  lq'-s (norm a) (norm b) ρ ∙ cong₂ lqℕ (norm-sound a ρ) (norm-sound b ρ)

साधनम् : (e : Eq') → Maybe (⊨ e)
साधनम् (l , r) = mmap witness (norm l ≟T norm r)
  where
  witness : norm l ≡ norm r → ⊨ (l , r)
  witness p ρ =
    sym (norm-sound l ρ) ∙ cong (λ t → eval t ρ) p ∙ norm-sound r ρ

------------------------------------------------------------------------
-- §5  The substitute behaves like the original (AdeshaSthanivat's
--     lane), and the certified matcher.
------------------------------------------------------------------------

आदेशनम् : (Nat → Tm) → Tm → Tm
आदेशनम् σ (var i)  = σ i
आदेशनम् σ ze       = ze
आदेशनम् σ (su t)   = su (आदेशनम् σ t)
आदेशनम् σ (a ⊕ b)  = आदेशनम् σ a ⊕ आदेशनम् σ b
आदेशनम् σ (a ⊗ b)  = आदेशनम् σ a ⊗ आदेशनम् σ b
आदेशनम् σ (a ⊖ b)  = आदेशनम् σ a ⊖ आदेशनम् σ b
आदेशनम् σ (mx a b) = mx (आदेशनम् σ a) (आदेशनम् σ b)
आदेशनम् σ (lq a b) = lq (आदेशनम् σ a) (आदेशनम् σ b)

स्थानिवत् : (σ : Nat → Tm) (t : Tm) (ρ : Nat → Nat)
  → eval (आदेशनम् σ t) ρ ≡ eval t (λ i → eval (σ i) ρ)
स्थानिवत् σ (var i)  ρ = refl
स्थानिवत् σ ze       ρ = refl
स्थानिवत् σ (su t)   ρ = cong suc (स्थानिवत् σ t ρ)
स्थानिवत् σ (a ⊕ b)  ρ = cong₂ _+_ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)
स्थानिवत् σ (a ⊗ b)  ρ = cong₂ _*_ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)
स्थानिवत् σ (a ⊖ b)  ρ = cong₂ sbℕ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)
स्थानिवत् σ (mx a b) ρ = cong₂ mxℕ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)
स्थानिवत् σ (lq a b) ρ = cong₂ lqℕ (स्थानिवत् σ a ρ) (स्थानिवत् σ b ρ)

⊨-आदेशः : {l r : Tm} → ⊨ (l , r) → (σ : Nat → Tm)
  → ⊨ (आदेशनम् σ l , आदेशनम् σ r)
⊨-आदेशः {l} {r} pf σ ρ =
  स्थानिवत् σ l ρ ∙ pf (λ i → eval (σ i) ρ) ∙ sym (स्थानिवत् σ r ρ)

आदेश-नियमः : नियमः → (Nat → Tm) → नियमः
आदेश-नियमः s σ =
  niyama (आदेशनम् σ (नियमः.lhs s)) (आदेशनम् σ (नियमः.rhs s))
         (⊨-आदेशः {नियमः.lhs s} {नियमः.rhs s} (नियमः.साक्षी s) σ)

बन्धाः : Type
बन्धाः = Nat → Maybe Tm

रिक्ताः : बन्धाः
रिक्ताः _ = nothing

विस्तारः : Nat → Tm → बन्धाः → बन्धाः
विस्तारः i t b j with i ≟ℕ j
... | just _  = just t
... | nothing = b j

बन्धनम् : Nat → Tm → बन्धाः → Maybe बन्धाः
बन्धनम् i t b with b i
... | nothing = just (विस्तारः i t b)
... | just s  = mmap (λ _ → b) (s ≟T t)

मेलनम् : Tm → Tm → बन्धाः → Maybe बन्धाः
मेलनम् (var i)  t        b = बन्धनम् i t b
मेलनम् ze       ze       b = just b
मेलनम् (su p)   (su t)   b = मेलनम् p t b
मेलनम् (p ⊕ q)  (t ⊕ u)  b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् (p ⊗ q)  (t ⊗ u)  b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् (p ⊖ q)  (t ⊖ u)  b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् (mx p q) (mx t u) b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् (lq p q) (lq t u) b = मेलनम् p t b ≫= मेलनम् q u
मेलनम् _        _        _ = nothing

पूरणम् : बन्धाः → (Nat → Tm)
पूरणम् b i with b i
... | just t  = t
... | nothing = var i

साक्ष्यम् : (p t : Tm) → Maybe (Σ (Nat → Tm) (λ σ → आदेशनम् σ p ≡ t))
साक्ष्यम् p t with मेलनम् p t रिक्ताः
साक्ष्यम् p t | nothing = nothing
साक्ष्यम् p t | just b with आदेशनम् (पूरणम् b) p ≟T t
साक्ष्यम् p t | just b | nothing = nothing
साक्ष्यम् p t | just b | just q  = just (पूरणम् b , q)

वदनम् : (s : नियमः) (t : Tm) → Maybe (Σ Tm (λ u → ⊨ (t , u)))
वदनम् s t with साक्ष्यम् (नियमः.lhs s) t
... | nothing       = nothing
... | just (σ , q)  =
  just ( आदेशनम् σ (नियमः.rhs s)
       , λ ρ → cong (λ w → eval w ρ) (sym q)
             ∙ ⊨-आदेशः {नियमः.lhs s} {नियमः.rhs s} (नियमः.साक्षी s) σ ρ )

------------------------------------------------------------------------
-- §6  The ascent's substitution algebra (Aroha's lane), funExt-free.
------------------------------------------------------------------------

समानः : Nat → Nat → Bool
समानः = समℕ

समान-आत्मनि : (k : Nat) → समानः k k ≡ true
समान-आत्मनि zero    = refl
समान-आत्मनि (suc k) = समान-आत्मनि k

उपस्थापनम् : (Nat → Nat) → Nat → Nat → (Nat → Nat)
उपस्थापनम् ρ k n j = if समानः k j then n else ρ j

एकादेशः : Nat → Tm → Nat → Tm
एकादेशः k u j = if समानः k j then u else var j

_⟨_≔_⟩ : Tm → Nat → Tm → Tm
t ⟨ k ≔ u ⟩ = आदेशनम् (एकादेशः k u) t

समौ : (k : Nat) (u : Tm) (ρ : Nat → Nat) (j : Nat)
  → eval (एकादेशः k u j) ρ ≡ उपस्थापनम् ρ k (eval u ρ) j
समौ k u ρ j with समानः k j
... | true  = refl
... | false = refl

उपस्थापन-स्थानिवत् : (k : Nat) (u t : Tm) (ρ : Nat → Nat)
  → eval (t ⟨ k ≔ u ⟩) ρ ≡ eval t (उपस्थापनम् ρ k (eval u ρ))
उपस्थापन-स्थानिवत् k u t ρ =
    स्थानिवत् (एकादेशः k u) t ρ
  ∙ एव-सम् t (λ i → eval (एकादेशः k u i) ρ) (उपस्थापनम् ρ k (eval u ρ)) (समौ k u ρ)

द्विः : (ρ : Nat → Nat) (k m n j : Nat)
  → उपस्थापनम् (उपस्थापनम् ρ k m) k n j ≡ उपस्थापनम् ρ k n j
द्विः ρ k m n j with समानः k j
... | true  = refl
... | false = refl

स्वम् : (ρ : Nat → Nat) (k j : Nat) → उपस्थापनम् ρ k (ρ k) j ≡ ρ j
स्वम् ρ zero    zero    = refl
स्वम् ρ zero    (suc j) = refl
स्वम् ρ (suc k) zero    = refl
स्वम् ρ (suc k) (suc j) = स्वम् (λ i → ρ (suc i)) k j

आत्म-मूल्यम् : (ρ : Nat → Nat) (k n : Nat) → उपस्थापनम् ρ k n k ≡ n
आत्म-मूल्यम् ρ k n = cong (λ b → if b then n else ρ k) (समान-आत्मनि k)

आरोहः : (k : Nat) (l r : Tm)
  → ⊨ (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩)
  → ((ρ : Nat → Nat) → eval l ρ ≡ eval r ρ
       → eval (l ⟨ k ≔ su (var k) ⟩) ρ ≡ eval (r ⟨ k ≔ su (var k) ⟩) ρ)
  → ⊨ (l , r)
आरोहः k l r base step ρ =
     sym (एव-सम् l (उपस्थापनम् ρ k (ρ k)) ρ (स्वम् ρ k))
   ∙ go (ρ k)
   ∙ एव-सम् r (उपस्थापनम् ρ k (ρ k)) ρ (स्वम् ρ k)
  where
  go : (n : Nat) → eval l (उपस्थापनम् ρ k n) ≡ eval r (उपस्थापनम् ρ k n)
  go zero =
       sym (उपस्थापन-स्थानिवत् k ze l ρ)
     ∙ base ρ
     ∙ उपस्थापन-स्थानिवत् k ze r ρ
  go (suc n) =
       sym (एव-सम् l (उपस्थापनम् ρₙ k (suc (ρₙ k))) (उपस्थापनम् ρ k (suc n)) परिसर-सम्)
     ∙ sym (उपस्थापन-स्थानिवत् k (su (var k)) l ρₙ)
     ∙ step ρₙ (go n)
     ∙ उपस्थापन-स्थानिवत् k (su (var k)) r ρₙ
     ∙ एव-सम् r (उपस्थापनम् ρₙ k (suc (ρₙ k))) (उपस्थापनम् ρ k (suc n)) परिसर-सम्
    where
    ρₙ : Nat → Nat
    ρₙ = उपस्थापनम् ρ k n

    परिसर-सम् : (i : Nat)
      → उपस्थापनम् ρₙ k (suc (ρₙ k)) i ≡ उपस्थापनम् ρ k (suc n) i
    परिसर-सम् i =
        cong (λ v → उपस्थापनम् ρₙ k (suc v) i) (आत्म-मूल्यम् ρ k n)
      ∙ द्विः ρ k n (suc n) i

------------------------------------------------------------------------
-- §7  The syntactic exchange (SvarthaAnumana's lane) and the record
--     speaking (ShrutaMatipurva's lane).
------------------------------------------------------------------------

विनिमयः : (p s t : Tm) → Tm
विनिमयः p s t with p ≟T t
विनिमयः p s t        | just _  = s
विनिमयः p s (var i)  | nothing = var i
विनिमयः p s ze       | nothing = ze
विनिमयः p s (su a)   | nothing = su (विनिमयः p s a)
विनिमयः p s (a ⊕ b)  | nothing = विनिमयः p s a ⊕ विनिमयः p s b
विनिमयः p s (a ⊗ b)  | nothing = विनिमयः p s a ⊗ विनिमयः p s b
विनिमयः p s (a ⊖ b)  | nothing = विनिमयः p s a ⊖ विनिमयः p s b
विनिमयः p s (mx a b) | nothing = mx (विनिमयः p s a) (विनिमयः p s b)
विनिमयः p s (lq a b) | nothing = lq (विनिमयः p s a) (विनिमयः p s b)

विनिमय-साक्षी : (p s : Tm) (ρ : Nat → Nat) → eval p ρ ≡ eval s ρ
  → (t : Tm) → eval t ρ ≡ eval (विनिमयः p s t) ρ
विनिमय-साक्षी p s ρ h t with p ≟T t
विनिमय-साक्षी p s ρ h t        | just q  =
  cong (λ w → eval w ρ) (sym q) ∙ h
विनिमय-साक्षी p s ρ h (var i)  | nothing = refl
विनिमय-साक्षी p s ρ h ze       | nothing = refl
विनिमय-साक्षी p s ρ h (su a)   | nothing =
  cong suc (विनिमय-साक्षी p s ρ h a)
विनिमय-साक्षी p s ρ h (a ⊕ b)  | nothing =
  cong₂ _+_ (विनिमय-साक्षी p s ρ h a) (विनिमय-साक्षी p s ρ h b)
विनिमय-साक्षी p s ρ h (a ⊗ b)  | nothing =
  cong₂ _*_ (विनिमय-साक्षी p s ρ h a) (विनिमय-साक्षी p s ρ h b)
विनिमय-साक्षी p s ρ h (a ⊖ b)  | nothing =
  cong₂ sbℕ (विनिमय-साक्षी p s ρ h a) (विनिमय-साक्षी p s ρ h b)
विनिमय-साक्षी p s ρ h (mx a b) | nothing =
  cong₂ mxℕ (विनिमय-साक्षी p s ρ h a) (विनिमय-साक्षी p s ρ h b)
विनिमय-साक्षी p s ρ h (lq a b) | nothing =
  cong₂ lqℕ (विनिमय-साक्षी p s ρ h a) (विनिमय-साक्षी p s ρ h b)

चराः : Tm → Nat
चराः (var i)  = suc i
चराः ze       = zero
चराः (su t)   = चराः t
चराः (a ⊕ b)  = mxℕ (चराः a) (चराः b)
चराः (a ⊗ b)  = mxℕ (चराः a) (चराः b)
चराः (a ⊖ b)  = mxℕ (चराः a) (चराः b)
चराः (mx a b) = mxℕ (चराः a) (चराः b)
चराः (lq a b) = mxℕ (चराः a) (चराः b)

इन्धनम् : Nat
इन्धनम् = suc (suc (suc zero))

शासन-विनिमयः : नियमः → Tm → Tm
शासन-विनिमयः s t with वदनम् s t
शासन-विनिमयः s t        | just (u , _) = u
शासन-विनिमयः s (var i)  | nothing = var i
शासन-विनिमयः s ze       | nothing = ze
शासन-विनिमयः s (su a)   | nothing = su (शासन-विनिमयः s a)
शासन-विनिमयः s (a ⊕ b)  | nothing = शासन-विनिमयः s a ⊕ शासन-विनिमयः s b
शासन-विनिमयः s (a ⊗ b)  | nothing = शासन-विनिमयः s a ⊗ शासन-विनिमयः s b
शासन-विनिमयः s (a ⊖ b)  | nothing = शासन-विनिमयः s a ⊖ शासन-विनिमयः s b
शासन-विनिमयः s (mx a b) | nothing = mx (शासन-विनिमयः s a) (शासन-विनिमयः s b)
शासन-विनिमयः s (lq a b) | nothing = lq (शासन-विनिमयः s a) (शासन-विनिमयः s b)

शासन-साक्षी : (s : नियमः) (ρ : Nat → Nat) (t : Tm)
  → eval t ρ ≡ eval (शासन-विनिमयः s t) ρ
शासन-साक्षी s ρ t with वदनम् s t
शासन-साक्षी s ρ t        | just (u , pf) = pf ρ
शासन-साक्षी s ρ (var i)  | nothing = refl
शासन-साक्षी s ρ ze       | nothing = refl
शासन-साक्षी s ρ (su a)   | nothing = cong suc (शासन-साक्षी s ρ a)
शासन-साक्षी s ρ (a ⊕ b)  | nothing =
  cong₂ _+_ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)
शासन-साक्षी s ρ (a ⊗ b)  | nothing =
  cong₂ _*_ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)
शासन-साक्षी s ρ (a ⊖ b)  | nothing =
  cong₂ sbℕ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)
शासन-साक्षी s ρ (mx a b) | nothing =
  cong₂ mxℕ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)
शासन-साक्षी s ρ (lq a b) | nothing =
  cong₂ lqℕ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)

श्रुत-विनिमयः : List नियमः → Tm → Tm
श्रुत-विनिमयः []       t = t
श्रुत-विनिमयः (s ∷ ss) t = श्रुत-विनिमयः ss (शासन-विनिमयः s t)

श्रुत-साक्षी : (Γ : List नियमः) (ρ : Nat → Nat) (t : Tm)
  → eval t ρ ≡ eval (श्रुत-विनिमयः Γ t) ρ
श्रुत-साक्षी []       ρ t = refl
श्रुत-साक्षी (s ∷ ss) ρ t =
  शासन-साक्षी s ρ t ∙ श्रुत-साक्षी ss ρ (शासन-विनिमयः s t)

------------------------------------------------------------------------
-- §8  The heap (ArpitaAnarpita's and Rashi's lanes): the sum as an
--     aggregate, deletion with its debt, the surgery, the deep eyes.
------------------------------------------------------------------------

सुम् : List Tm → (Nat → Nat) → Nat
सुम् []       ρ = zero
सुम् (t ∷ ts) ρ = eval t ρ + सुम् ts ρ

सुम्-++ : (xs ys : List Tm) (ρ : Nat → Nat)
  → सुम् (xs ++ ys) ρ ≡ सुम् xs ρ + सुम् ys ρ
सुम्-++ []       ys ρ = refl
सुम्-++ (x ∷ xs) ys ρ =
    cong (λ n → eval x ρ + n) (सुम्-++ xs ys ρ)
  ∙ +-assoc (eval x ρ) (सुम् xs ρ) (सुम् ys ρ)

_≤?_ : Nat → Nat → Bool
zero  ≤? _     = true
suc _ ≤? zero  = false
suc a ≤? suc b = a ≤? b

युज् : {A : Type} → Maybe A → Bool
युज् (just _) = true
युज् nothing  = false

टैगः : Tm → Nat
टैगः (var _)  = 0
टैगः ze       = 1
टैगः (su _)   = 2
टैगः (_ ⊕ _)  = 3
टैगः (_ ⊗ _)  = 4
टैगः (_ ⊖ _)  = 5
टैगः (mx _ _) = 6
टैगः (lq _ _) = 7

तुला : Tm → Tm → Bool
तुला-द्वयोः : Tm → Tm → Tm → Tm → Bool

तुला (var i)  (var j)  = i ≤? j
तुला (su a)   (su b)   = तुला a b
तुला (a ⊕ b)  (c ⊕ d)  = तुला-द्वयोः a b c d
तुला (a ⊗ b)  (c ⊗ d)  = तुला-द्वयोः a b c d
तुला (a ⊖ b)  (c ⊖ d)  = तुला-द्वयोः a b c d
तुला (mx a b) (mx c d) = तुला-द्वयोः a b c d
तुला (lq a b) (lq c d) = तुला-द्वयोः a b c d
तुला a        b        = टैगः a ≤? टैगः b

तुला-द्वयोः a b c d = if युज् (a ≟T c) then तुला b d else तुला a c

निवेशः : Tm → List Tm → List Tm
निवेशः x []       = x ∷ []
निवेशः x (y ∷ ys) = if तुला x y then x ∷ y ∷ ys else y ∷ निवेशः x ys

क्रमणम् : List Tm → List Tm
क्रमणम् []       = []
क्रमणम् (x ∷ xs) = निवेशः x (क्रमणम् xs)

निवेश-सत्यम् : (x : Tm) (ys : List Tm) (ρ : Nat → Nat)
  → सुम् (निवेशः x ys) ρ ≡ eval x ρ + सुम् ys ρ
निवेश-सत्यम् x [] ρ = refl
निवेश-सत्यम् x (y ∷ ys) ρ with तुला x y
... | true  = refl
... | false =
    cong (λ n → eval y ρ + n) (निवेश-सत्यम् x ys ρ)
  ∙ +-assoc (eval y ρ) (eval x ρ) (सुम् ys ρ)
  ∙ cong (λ n → n + सुम् ys ρ) (+-comm (eval y ρ) (eval x ρ))
  ∙ sym (+-assoc (eval x ρ) (eval y ρ) (सुम् ys ρ))

क्रमण-सत्यम् : (xs : List Tm) (ρ : Nat → Nat) → सुम् (क्रमणम् xs) ρ ≡ सुम् xs ρ
क्रमण-सत्यम् []       ρ = refl
क्रमण-सत्यम् (x ∷ xs) ρ =
    निवेश-सत्यम् x (क्रमणम् xs) ρ
  ∙ cong (λ n → eval x ρ + n) (क्रमण-सत्यम् xs ρ)

पुनःरचना : List Tm → Tm
पुनःरचना []       = ze
पुनःरचना (t ∷ ts) = t ⊕ पुनःरचना ts

पुनःरचना-सत्यम् : (ts : List Tm) (ρ : Nat → Nat)
  → eval (पुनःरचना ts) ρ ≡ सुम् ts ρ
पुनःरचना-सत्यम् []       ρ = refl
पुनःरचना-सत्यम् (t ∷ ts) ρ =
  cong (λ n → eval t ρ + n) (पुनःरचना-सत्यम् ts ρ)

शुद्ध-सुम् : (xs : List Tm) (ρ : Nat → Nat)
  → eval (पुनःरचना (क्रमणम् xs)) ρ ≡ सुम् xs ρ
शुद्ध-सुम् xs ρ = पुनःरचना-सत्यम् (क्रमणम् xs) ρ ∙ क्रमण-सत्यम् xs ρ

राशिः : Tm → List Tm
राशिः (a ⊕ b) = राशिः a ++ राशिः b
राशिः (su t)  = राशिः t ++ ((su ze) ∷ [])
राशिः ze      = []
राशिः t       = t ∷ []

राशि-सत्यम् : (t : Tm) (ρ : Nat → Nat) → सुम् (राशिः t) ρ ≡ eval t ρ
राशि-सत्यम् (a ⊕ b)  ρ =
    सुम्-++ (राशिः a) (राशिः b) ρ
  ∙ cong₂ _+_ (राशि-सत्यम् a ρ) (राशि-सत्यम् b ρ)
राशि-सत्यम् (su t)   ρ =
    सुम्-++ (राशिः t) ((su ze) ∷ []) ρ
  ∙ +-suc (सुम् (राशिः t) ρ) zero
  ∙ cong suc (+-zero (सुम् (राशिः t) ρ))
  ∙ cong suc (राशि-सत्यम् t ρ)
राशि-सत्यम् ze       ρ = refl
राशि-सत्यम् (var i)  ρ = +-zero (ρ i)
राशि-सत्यम् (a ⊗ b)  ρ = +-zero (eval a ρ * eval b ρ)
राशि-सत्यम् (a ⊖ b)  ρ = +-zero (sbℕ (eval a ρ) (eval b ρ))
राशि-सत्यम् (mx a b) ρ = +-zero (mxℕ (eval a ρ) (eval b ρ))
राशि-सत्यम् (lq a b) ρ = +-zero (lqℕ (eval a ρ) (eval b ρ))

निष्कासः : (t : Tm) (xs : List Tm)
  → Maybe (Σ (List Tm) (λ ys → (ρ : Nat → Nat) → सुम् xs ρ ≡ eval t ρ + सुम् ys ρ))
निष्कासः t [] = nothing
निष्कासः t (x ∷ xs) with t ≟T x
... | just p  = just (xs , λ ρ → cong (λ w → eval w ρ + सुम् xs ρ) (sym p))
... | nothing =
  mmap (λ yq → (x ∷ fst yq
             , λ ρ → cong (eval x ρ +_) (snd yq ρ)
                   ∙ +-assoc (eval x ρ) (eval t ρ) (सुम् (fst yq) ρ)
                   ∙ cong (_+ सुम् (fst yq) ρ) (+-comm (eval x ρ) (eval t ρ))
                   ∙ sym (+-assoc (eval t ρ) (eval x ρ) (सुम् (fst yq) ρ))))
       (निष्कासः t xs)

बहु-निष्कासः : (ts xs : List Tm)
  → Maybe (Σ (List Tm) (λ ys → (ρ : Nat → Nat) → सुम् xs ρ ≡ सुम् ts ρ + सुम् ys ρ))
बहु-निष्कासः [] xs = just (xs , λ ρ → refl)
बहु-निष्कासः (t ∷ ts) xs =
  निष्कासः t xs ≫= λ yq →
  mmap (λ zw → (fst zw
             , λ ρ → snd yq ρ
                   ∙ cong (eval t ρ +_) (snd zw ρ)
                   ∙ +-assoc (eval t ρ) (सुम् ts ρ) (सुम् (fst zw) ρ)))
       (बहु-निष्कासः ts (fst yq))

शस्त्रम् : (p s t : Tm) → Tm
शस्त्रम् p s t with बहु-निष्कासः (राशिः p) (राशिः t)
... | just yw = पुनःरचना (क्रमणम् (राशिः s ++ fst yw))
... | nothing = t

शस्त्र-साक्षी : (p s : Tm) (ρ : Nat → Nat) → eval p ρ ≡ eval s ρ
  → (t : Tm) → eval t ρ ≡ eval (शस्त्रम् p s t) ρ
शस्त्र-साक्षी p s ρ h t with बहु-निष्कासः (राशिः p) (राशिः t)
... | nothing = refl
... | just yw =
    sym (राशि-सत्यम् t ρ)
  ∙ snd yw ρ
  ∙ cong (_+ सुम् (fst yw) ρ) (राशि-सत्यम् p ρ ∙ h ∙ sym (राशि-सत्यम् s ρ))
  ∙ sym (सुम्-++ (राशिः s) (fst yw) ρ)
  ∙ sym (शुद्ध-सुम् (राशिः s ++ fst yw) ρ)

राशि-विनिमयः : (p s t : Tm) → Tm
राशि-विनिमयः p s t with p ≟T t
राशि-विनिमयः p s t        | just _  = s
राशि-विनिमयः p s (a ⊕ b)  | nothing = शस्त्रम् p s (a ⊕ b)
राशि-विनिमयः p s (su a)   | nothing = शस्त्रम् p s (su a)
राशि-विनिमयः p s (var i)  | nothing = var i
राशि-विनिमयः p s ze       | nothing = ze
राशि-विनिमयः p s (a ⊗ b)  | nothing = राशि-विनिमयः p s a ⊗ राशि-विनिमयः p s b
राशि-विनिमयः p s (a ⊖ b)  | nothing = राशि-विनिमयः p s a ⊖ राशि-विनिमयः p s b
राशि-विनिमयः p s (mx a b) | nothing = mx (राशि-विनिमयः p s a) (राशि-विनिमयः p s b)
राशि-विनिमयः p s (lq a b) | nothing = lq (राशि-विनिमयः p s a) (राशि-विनिमयः p s b)

राशि-साक्षी : (p s : Tm) (ρ : Nat → Nat) → eval p ρ ≡ eval s ρ
  → (t : Tm) → eval t ρ ≡ eval (राशि-विनिमयः p s t) ρ
राशि-साक्षी p s ρ h t with p ≟T t
राशि-साक्षी p s ρ h t        | just q  = cong (λ w → eval w ρ) (sym q) ∙ h
राशि-साक्षी p s ρ h (a ⊕ b)  | nothing = शस्त्र-साक्षी p s ρ h (a ⊕ b)
राशि-साक्षी p s ρ h (su a)   | nothing = शस्त्र-साक्षी p s ρ h (su a)
राशि-साक्षी p s ρ h (var i)  | nothing = refl
राशि-साक्षी p s ρ h ze       | nothing = refl
राशि-साक्षी p s ρ h (a ⊗ b)  | nothing =
  cong₂ _*_ (राशि-साक्षी p s ρ h a) (राशि-साक्षी p s ρ h b)
राशि-साक्षी p s ρ h (a ⊖ b)  | nothing =
  cong₂ sbℕ (राशि-साक्षी p s ρ h a) (राशि-साक्षी p s ρ h b)
राशि-साक्षी p s ρ h (mx a b) | nothing =
  cong₂ mxℕ (राशि-साक्षी p s ρ h a) (राशि-साक्षी p s ρ h b)
राशि-साक्षी p s ρ h (lq a b) | nothing =
  cong₂ lqℕ (राशि-साक्षी p s ρ h a) (राशि-साक्षी p s ρ h b)

------------------------------------------------------------------------
-- §9  The factoring eye (SadharanaVishesha's lane).
------------------------------------------------------------------------

वितरणम् : (a b c : Nat) → mxℕ (a + c) (b + c) ≡ mxℕ a b + c
वितरणम् a b zero =
  cong₂ mxℕ (+-zero a) (+-zero b) ∙ sym (+-zero (mxℕ a b))
वितरणम् a b (suc c) =
    cong₂ mxℕ (+-suc a c) (+-suc b c)
  ∙ cong suc (वितरणम् a b c)
  ∙ sym (+-suc (mxℕ a b) c)

साधारणम् : (A B : List Tm)
  → Σ (List Tm) (λ C → Σ (List Tm) (λ A' → Σ (List Tm) (λ B' →
      ((ρ : Nat → Nat) → सुम् A ρ ≡ सुम् C ρ + सुम् A' ρ)
    × ((ρ : Nat → Nat) → सुम् B ρ ≡ सुम् C ρ + सुम् B' ρ))))
साधारणम् [] B = [] , [] , B , (λ ρ → refl) , (λ ρ → refl)
साधारणम् (x ∷ A) B with निष्कासः x B
साधारणम् (x ∷ A) B | just yw with साधारणम् A (fst yw)
साधारणम् (x ∷ A) B | just yw | (C , A' , B' , pA , pB) =
        (x ∷ C) , A' , B'
      , (λ ρ → cong (eval x ρ +_) (pA ρ)
             ∙ +-assoc (eval x ρ) (सुम् C ρ) (सुम् A' ρ))
      , (λ ρ → snd yw ρ
             ∙ cong (eval x ρ +_) (pB ρ)
             ∙ +-assoc (eval x ρ) (सुम् C ρ) (सुम् B' ρ))
साधारणम् (x ∷ A) B | nothing with साधारणम् A B
साधारणम् (x ∷ A) B | nothing | (C , A' , B' , pA , pB) =
        C , (x ∷ A') , B'
      , (λ ρ → cong (eval x ρ +_) (pA ρ)
             ∙ +-assoc (eval x ρ) (सुम् C ρ) (सुम् A' ρ)
             ∙ cong (_+ सुम् A' ρ) (+-comm (eval x ρ) (सुम् C ρ))
             ∙ sym (+-assoc (सुम् C ρ) (eval x ρ) (सुम् A' ρ)))
      , pB

मेलः : List Tm → List Tm → List Tm → Tm
मेलः C []  B' = पुनःरचना (क्रमणम् (C ++ B'))
मेलः C (a ∷ A') [] = पुनःरचना (क्रमणम् (C ++ (a ∷ A')))
मेलः C (a ∷ A') (b ∷ B') =
  पुनःरचना (क्रमणम्
    (mx (पुनःरचना (क्रमणम् (a ∷ A'))) (पुनःरचना (क्रमणम् (b ∷ B'))) ∷ C))

मेल-सत्यम् : (C A' B' : List Tm) (ρ : Nat → Nat)
  → eval (मेलः C A' B') ρ ≡ सुम् C ρ + mxℕ (सुम् A' ρ) (सुम् B' ρ)
मेल-सत्यम् C [] B' ρ =
    शुद्ध-सुम् (C ++ B') ρ
  ∙ सुम्-++ C B' ρ
  ∙ cong (सुम् C ρ +_) (sym (शून्य-ज्येष्ठम् (सुम् B' ρ)))
मेल-सत्यम् C (a ∷ A') [] ρ =
    शुद्ध-सुम् (C ++ (a ∷ A')) ρ
  ∙ सुम्-++ C (a ∷ A') ρ
मेल-सत्यम् C (a ∷ A') (b ∷ B') ρ =
    शुद्ध-सुम् (mx (पुनःरचना (क्रमणम् (a ∷ A'))) (पुनःरचना (क्रमणम् (b ∷ B'))) ∷ C) ρ
  ∙ cong₂ _+_
      (cong₂ mxℕ (शुद्ध-सुम् (a ∷ A') ρ) (शुद्ध-सुम् (b ∷ B') ρ))
      (refl {x = सुम् C ρ})
  ∙ +-comm (mxℕ (सुम् (a ∷ A') ρ) (सुम् (b ∷ B') ρ)) (सुम् C ρ)

गूढ-आम्नायः : Tm → Tm
गूढ-आम्नायः (var i)  = var i
गूढ-आम्नायः ze       = ze
गूढ-आम्नायः (su t)   = पुनःरचना (क्रमणम् (राशिः (su (गूढ-आम्नायः t))))
गूढ-आम्नायः (a ⊕ b)  =
  पुनःरचना (क्रमणम् (राशिः (गूढ-आम्नायः a) ++ राशिः (गूढ-आम्नायः b)))
गूढ-आम्नायः (a ⊗ b)  = गूढ-आम्नायः a ⊗ गूढ-आम्नायः b
गूढ-आम्नायः (a ⊖ b)  = गूढ-आम्नायः a ⊖ गूढ-आम्नायः b
गूढ-आम्नायः (mx a b) =
  मेलः (fst s) (fst (snd s)) (fst (snd (snd s)))
  where
  s = साधारणम् (राशिः (गूढ-आम्नायः a)) (राशिः (गूढ-आम्नायः b))
गूढ-आम्नायः (lq a b) = lq (गूढ-आम्नायः a) (गूढ-आम्नायः b)

गूढ-सत्यम् : (t : Tm) (ρ : Nat → Nat) → eval (गूढ-आम्नायः t) ρ ≡ eval t ρ
गूढ-सत्यम् (var i)  ρ = refl
गूढ-सत्यम् ze       ρ = refl
गूढ-सत्यम् (su t)   ρ =
    शुद्ध-सुम् (राशिः (su (गूढ-आम्नायः t))) ρ
  ∙ राशि-सत्यम् (su (गूढ-आम्नायः t)) ρ
  ∙ cong suc (गूढ-सत्यम् t ρ)
गूढ-सत्यम् (a ⊕ b)  ρ =
    शुद्ध-सुम् (राशिः (गूढ-आम्नायः a) ++ राशिः (गूढ-आम्नायः b)) ρ
  ∙ सुम्-++ (राशिः (गूढ-आम्नायः a)) (राशिः (गूढ-आम्नायः b)) ρ
  ∙ cong₂ _+_ (राशि-सत्यम् (गूढ-आम्नायः a) ρ) (राशि-सत्यम् (गूढ-आम्नायः b) ρ)
  ∙ cong₂ _+_ (गूढ-सत्यम् a ρ) (गूढ-सत्यम् b ρ)
गूढ-सत्यम् (a ⊗ b)  ρ = cong₂ _*_ (गूढ-सत्यम् a ρ) (गूढ-सत्यम् b ρ)
गूढ-सत्यम् (a ⊖ b)  ρ = cong₂ sbℕ (गूढ-सत्यम् a ρ) (गूढ-सत्यम् b ρ)
गूढ-सत्यम् (mx a b) ρ =
    मेल-सत्यम् (fst s) (fst (snd s)) (fst (snd (snd s))) ρ
  ∙ +-comm (सुम् (fst s) ρ)
           (mxℕ (सुम् (fst (snd s)) ρ) (सुम् (fst (snd (snd s))) ρ))
  ∙ sym (वितरणम् (सुम् (fst (snd s)) ρ) (सुम् (fst (snd (snd s))) ρ)
                 (सुम् (fst s) ρ))
  ∙ cong₂ mxℕ (+-comm (सुम् (fst (snd s)) ρ) (सुम् (fst s) ρ))
              (+-comm (सुम् (fst (snd (snd s))) ρ) (सुम् (fst s) ρ))
  ∙ cong₂ mxℕ (sym (fst (snd (snd (snd s))) ρ))
              (sym (snd (snd (snd (snd s))) ρ))
  ∙ cong₂ mxℕ (राशि-सत्यम् (गूढ-आम्नायः a) ρ) (राशि-सत्यम् (गूढ-आम्नायः b) ρ)
  ∙ cong₂ mxℕ (गूढ-सत्यम् a ρ) (गूढ-सत्यम् b ρ)
  where
  s = साधारणम् (राशिः (गूढ-आम्नायः a)) (राशिः (गूढ-आम्नायः b))
गूढ-सत्यम् (lq a b) ρ = cong₂ lqℕ (गूढ-सत्यम् a ρ) (गूढ-सत्यम् b ρ)

दृक्पातः : Tm → Tm
दृक्पातः t = गूढ-आम्नायः (norm t)

दृक्पात-सत्यम् : (t : Tm) (ρ : Nat → Nat) → eval (दृक्पातः t) ρ ≡ eval t ρ
दृक्पात-सत्यम् t ρ = गूढ-सत्यम् (norm t) ρ ∙ norm-sound t ρ

------------------------------------------------------------------------
-- §10  Both coordinates at once (YugapadArpana's lane), funExt-free.
------------------------------------------------------------------------

युगपद् : {P : Nat → Nat → Type}
  → ((x : Nat) → P x zero)
  → ((y : Nat) → P zero y)
  → ((x y : Nat) → P x y → P (suc x) (suc y))
  → (x y : Nat) → P x y
युगपद् b₁ b₂ s x       zero    = b₁ x
युगपद् b₁ b₂ s zero    (suc y) = b₂ (suc y)
युगपद् b₁ b₂ s (suc x) (suc y) = s x y (युगपद् b₁ b₂ s x y)

व्यत्ययः : (ρ : Nat → Nat) (k j m n : Nat) → समानः k j ≡ false → (i : Nat)
  → उपस्थापनम् (उपस्थापनम् ρ k m) j n i ≡ उपस्थापनम् (उपस्थापनम् ρ j n) k m i
व्यत्ययः ρ zero    zero    m n kj i       = ⊥-rec (true≢false kj)
व्यत्ययः ρ zero    (suc j) m n kj zero    = refl
व्यत्ययः ρ zero    (suc j) m n kj (suc i) = refl
व्यत्ययः ρ (suc k) zero    m n kj zero    = refl
व्यत्ययः ρ (suc k) zero    m n kj (suc i) = refl
व्यत्ययः ρ (suc k) (suc j) m n kj zero    = refl
व्यत्ययः ρ (suc k) (suc j) m n kj (suc i) =
  व्यत्ययः (λ p → ρ (suc p)) k j m n kj i

सम-विपर्ययः : (k j : Nat) → समानः k j ≡ समानः j k
सम-विपर्ययः zero    zero    = refl
सम-विपर्ययः zero    (suc j) = refl
सम-विपर्ययः (suc k) zero    = refl
सम-विपर्ययः (suc k) (suc j) = सम-विपर्ययः k j

द्वि-रूपम् : Nat → Nat → Tm → Tm
द्वि-रूपम् k j t = (t ⟨ k ≔ su (var k) ⟩) ⟨ j ≔ su (var j) ⟩

-- updates through a pointwise-equal base agree at every place.
उप-सम् : (e e' : Nat → Nat) (k v i : Nat) → ((x : Nat) → e x ≡ e' x)
  → उपस्थापनम् e k v i ≡ उपस्थापनम् e' k v i
उप-सम् e e' k v i h with समानः k i
... | true  = refl
... | false = h i

युगपद्-आरोहः : (k j : Nat) (l r : Tm) → समानः k j ≡ false
  → ⊨ (l ⟨ j ≔ ze ⟩ , r ⟨ j ≔ ze ⟩)
  → ⊨ (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩)
  → ((ρ : Nat → Nat) → eval l ρ ≡ eval r ρ
      → eval (द्वि-रूपम् k j l) ρ ≡ eval (द्वि-रूपम् k j r) ρ)
  → ⊨ (l , r)
युगपद्-आरोहः k j l r kj b₁ b₂ st ρ =
     sym (एव-सम् l (उपस्थापनम् e₀ j (ρ j)) ρ ρ-सम्)
   ∙ go (ρ k) (ρ j)
   ∙ एव-सम् r (उपस्थापनम् e₀ j (ρ j)) ρ ρ-सम्
  where
  e₀ : (Nat → Nat)
  e₀ = उपस्थापनम् ρ k (ρ k)

  jk : समानः j k ≡ false
  jk = सम-विपर्ययः j k ∙ kj

  ρ-सम् : (i : Nat) → उपस्थापनम् e₀ j (ρ j) i ≡ ρ i
  ρ-सम् i =
      cong (λ v → उपस्थापनम् e₀ j v i)
           (sym (cong (λ b → if b then ρ k else ρ j) kj))
    ∙ स्वम् e₀ j i
    ∙ स्वम् ρ k i

  go : (m n : Nat)
    → eval l (उपस्थापनम् (उपस्थापनम् ρ k m) j n)
    ≡ eval r (उपस्थापनम् (उपस्थापनम् ρ k m) j n)
  go = युगपद्
    (λ m → sym (उपस्थापन-स्थानिवत् j ze l (उपस्थापनम् ρ k m))
         ∙ b₁ (उपस्थापनम् ρ k m)
         ∙ उपस्थापन-स्थानिवत् j ze r (उपस्थापनम् ρ k m))
    (λ n → एव-सम् l (उपस्थापनम् (उपस्थापनम् ρ k zero) j n)
                    (उपस्थापनम् (उपस्थापनम् ρ j n) k zero)
                    (व्यत्ययः ρ k j zero n kj)
         ∙ sym (उपस्थापन-स्थानिवत् k ze l (उपस्थापनम् ρ j n))
         ∙ b₂ (उपस्थापनम् ρ j n)
         ∙ उपस्थापन-स्थानिवत् k ze r (उपस्थापनम् ρ j n)
         ∙ sym (एव-सम् r (उपस्थापनम् (उपस्थापनम् ρ k zero) j n)
                         (उपस्थापनम् (उपस्थापनम् ρ j n) k zero)
                         (व्यत्ययः ρ k j zero n kj)))
    (λ m n ih → चरणम् m n ih)
    where
    चरणम् : (m n : Nat)
      → eval l (उपस्थापनम् (उपस्थापनम् ρ k m) j n)
        ≡ eval r (उपस्थापनम् (उपस्थापनम् ρ k m) j n)
      → eval l (उपस्थापनम् (उपस्थापनम् ρ k (suc m)) j (suc n))
        ≡ eval r (उपस्थापनम् (उपस्थापनम् ρ k (suc m)) j (suc n))
    चरणम् m n ih =
        sym (एव-सम् l (उपस्थापनम् e₁ k (suc (e₁ k)))
                      (उपस्थापनम् (उपस्थापनम् ρ k (suc m)) j (suc n)) मार्गः)
      ∙ sym (उपस्थापन-स्थानिवत् k (su (var k)) l e₁)
      ∙ sym (उपस्थापन-स्थानिवत् j (su (var j)) (l ⟨ k ≔ su (var k) ⟩) ρmn)
      ∙ st ρmn ih
      ∙ उपस्थापन-स्थानिवत् j (su (var j)) (r ⟨ k ≔ su (var k) ⟩) ρmn
      ∙ उपस्थापन-स्थानिवत् k (su (var k)) r e₁
      ∙ एव-सम् r (उपस्थापनम् e₁ k (suc (e₁ k)))
                 (उपस्थापनम् (उपस्थापनम् ρ k (suc m)) j (suc n)) मार्गः
      where
      ρmn : Nat → Nat
      ρmn = उपस्थापनम् (उपस्थापनम् ρ k m) j n

      e₁ : Nat → Nat
      e₁ = उपस्थापनम् ρmn j (suc (ρmn j))

      मूल्य-j : ρmn j ≡ n
      मूल्य-j = आत्म-मूल्यम् (उपस्थापनम् ρ k m) j n

      मूल्य-k : e₁ k ≡ m
      मूल्य-k =
          cong (λ b → if b then suc (ρmn j) else ρmn k) jk
        ∙ cong (λ b → if b then n else उपस्थापनम् ρ k m k) jk
        ∙ आत्म-मूल्यम् ρ k m

      मार्गः : (i : Nat)
        → उपस्थापनम् e₁ k (suc (e₁ k)) i
        ≡ उपस्थापनम् (उपस्थापनम् ρ k (suc m)) j (suc n) i
      मार्गः i =
          cong₂ (λ e v → उपस्थापनम् e k (suc v) i)
                (cong (λ v → उपस्थापनम् ρmn j (suc v)) मूल्य-j)
                मूल्य-k
        ∙ उप-सम् (उपस्थापनम् ρmn j (suc n))
                 (उपस्थापनम् (उपस्थापनम् ρ k m) j (suc n)) k (suc m) i
                 (द्विः (उपस्थापनम् ρ k m) j n (suc n))
        ∙ व्यत्ययः (उपस्थापनम् ρ k m) j k (suc n) (suc m) jk i
        ∙ उप-सम् (उपस्थापनम् (उपस्थापनम् ρ k m) k (suc m))
                 (उपस्थापनम् ρ k (suc m)) j (suc n) i
                 (द्विः ρ k m (suc m))

------------------------------------------------------------------------
-- §11  The one knowing: eye, instrument, record, fuel — and the breath
--     that digests the elder's store to quiet.  Verbatim PurnaPramana,
--     in the shared tongue.
------------------------------------------------------------------------

दृक् : Type
दृक् = Σ (Tm → Tm) (λ f → (t : Tm) (ρ : Nat → Nat) → eval (f t) ρ ≡ eval t ρ)

नेत्रम्-न : दृक्
नेत्रम्-न = norm , norm-sound

गूढ-दृक् : दृक्
गूढ-दृक् = दृक्पातः , दृक्पात-सत्यम्

record यन्त्रम् : Type where
  constructor yantra
  field
    क्रिया : Tm → Tm → Tm → Tm
    क्रिया-साक्षी : (p s : Tm) (ρ : Nat → Nat) → eval p ρ ≡ eval s ρ
      → (t : Tm) → eval t ρ ≡ eval (क्रिया p s t) ρ

सूक्ष्म-यन्त्रम् : यन्त्रम्
सूक्ष्म-यन्त्रम् = yantra विनिमयः विनिमय-साक्षी

राशि-यन्त्रम् : यन्त्रम्
राशि-यन्त्रम् = yantra राशि-विनिमयः राशि-साक्षी

संयुक्त-यन्त्रम् : यन्त्रम्
संयुक्त-यन्त्रम् = yantra
  (λ p s t → विनिमयः p s (राशि-विनिमयः p s t))
  (λ p s ρ h t → राशि-साक्षी p s ρ h t
               ∙ विनिमय-साक्षी p s ρ h (राशि-विनिमयः p s t))

module _ (E : दृक्) (Y : यन्त्रम्) (Γ : List नियमः) where
  private
    f = fst E
    fs = snd E
    act = यन्त्रम्.क्रिया Y
    asx = यन्त्रम्.क्रिया-साक्षी Y

  एक-व्याप्तिः : (k : Nat) (l r : Tm)
    → Maybe ((ρ : Nat → Nat) → eval l ρ ≡ eval r ρ
         → eval (l ⟨ k ≔ su (var k) ⟩) ρ ≡ eval (r ⟨ k ≔ su (var k) ⟩) ρ)
  एक-व्याप्तिः k l r =
    mmap
      (λ q ρ ih →
        let h = sym (श्रुत-साक्षी Γ ρ (f l))
              ∙ (fs l ρ ∙ ih ∙ sym (fs r ρ))
              ∙ श्रुत-साक्षी Γ ρ (f r)
        in   sym (fs (l ⟨ k ≔ su (var k) ⟩) ρ)
           ∙ श्रुत-साक्षी Γ ρ (f (l ⟨ k ≔ su (var k) ⟩))
           ∙ asx (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r)) ρ h
               (श्रुत-विनिमयः Γ (f (l ⟨ k ≔ su (var k) ⟩)))
           ∙ sym (fs (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
               (श्रुत-विनिमयः Γ (f (l ⟨ k ≔ su (var k) ⟩)))) ρ)
           ∙ cong (λ w → eval w ρ) q
           ∙ fs (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
               (श्रुत-विनिमयः Γ (f (r ⟨ k ≔ su (var k) ⟩)))) ρ
           ∙ sym (asx (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r)) ρ h
               (श्रुत-विनिमयः Γ (f (r ⟨ k ≔ su (var k) ⟩))))
           ∙ sym (श्रुत-साक्षी Γ ρ (f (r ⟨ k ≔ su (var k) ⟩)))
           ∙ fs (r ⟨ k ≔ su (var k) ⟩) ρ)
      (  f (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
           (श्रुत-विनिमयः Γ (f (l ⟨ k ≔ su (var k) ⟩))))
      ≟T f (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
           (श्रुत-विनिमयः Γ (f (r ⟨ k ≔ su (var k) ⟩)))) )

  द्वि-व्याप्तिः : (k j : Nat) (l r : Tm)
    → Maybe ((ρ : Nat → Nat) → eval l ρ ≡ eval r ρ
         → eval (द्वि-रूपम् k j l) ρ ≡ eval (द्वि-रूपम् k j r) ρ)
  द्वि-व्याप्तिः k j l r =
    mmap
      (λ q ρ ih →
        let h = sym (श्रुत-साक्षी Γ ρ (f l))
              ∙ (fs l ρ ∙ ih ∙ sym (fs r ρ))
              ∙ श्रुत-साक्षी Γ ρ (f r)
        in   sym (fs (द्वि-रूपम् k j l) ρ)
           ∙ श्रुत-साक्षी Γ ρ (f (द्वि-रूपम् k j l))
           ∙ asx (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r)) ρ h
               (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j l)))
           ∙ sym (fs (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
               (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j l)))) ρ)
           ∙ cong (λ w → eval w ρ) q
           ∙ fs (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
               (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j r)))) ρ
           ∙ sym (asx (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r)) ρ h
               (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j r))))
           ∙ sym (श्रुत-साक्षी Γ ρ (f (द्वि-रूपम् k j r)))
           ∙ fs (द्वि-रूपम् k j r) ρ)
      (  f (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
           (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j l))))
      ≟T f (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
           (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j r)))) )

पूर्ण-प्रमाणम् : दृक् → यन्त्रम् → List नियमः → Nat → (e : Eq') → Maybe (⊨ e)
पू-प्रयत्नः : दृक् → यन्त्रम् → List नियमः → Nat → Nat → (l r : Tm) → Maybe (⊨ (l , r))
पू-ऊर्ध्वम् : दृक् → यन्त्रम् → List नियमः → Nat → Nat → (l r : Tm) → Maybe (⊨ (l , r))
पू-द्वयम् : दृक् → यन्त्रम् → List नियमः → Nat → Nat → Nat → (l r : Tm) → Maybe (⊨ (l , r))
पू-द्विचक्रः : दृक् → यन्त्रम् → List नियमः → Nat → Nat → Nat → (l r : Tm) → Maybe (⊨ (l , r))
पू-कचक्रः : दृक् → यन्त्रम् → List नियमः → Nat → Nat → Nat → (l r : Tm) → Maybe (⊨ (l , r))

पूर्ण-प्रमाणम् E Y Γ zero e = nothing
पूर्ण-प्रमाणम् E Y Γ (suc fl) (l , r) =
  अथवा (mmap (λ p ρ → sym (snd E l ρ) ∙ cong (λ w → eval w ρ) p ∙ snd E r ρ)
             (fst E l ≟T fst E r))
  (अथवा (पू-प्रयत्नः E Y Γ fl (mxℕ (चराः l) (चराः r)) l r)
        (पू-कचक्रः E Y Γ fl (mxℕ (चराः l) (चराः r)) (mxℕ (चराः l) (चराः r)) l r))

पू-प्रयत्नः E Y Γ fl zero    l r = nothing
पू-प्रयत्नः E Y Γ fl (suc k) l r =
  अथवा (पू-ऊर्ध्वम् E Y Γ fl k l r) (पू-प्रयत्नः E Y Γ fl k l r)

पू-ऊर्ध्वम् E Y Γ fl k l r =
  mmap2 (आरोहः k l r)
        (पूर्ण-प्रमाणम् E Y Γ fl (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩))
        (अथवा (एक-व्याप्तिः E Y Γ k l r)
         (अथवा (एक-व्याप्तिः E Y [] k l r)
          (अथवा (एक-व्याप्तिः नेत्रम्-न Y Γ k l r) (एक-व्याप्तिः नेत्रम्-न Y [] k l r))))

पू-द्वयम् E Y Γ fl k j l r = चेष्टा (समानः k j) refl
  where
  चेष्टा : (b : Bool) → समानः k j ≡ b → Maybe (⊨ (l , r))
  चेष्टा true  _  = nothing
  चेष्टा false kj =
    पूर्ण-प्रमाणम् E Y Γ fl (l ⟨ j ≔ ze ⟩ , r ⟨ j ≔ ze ⟩) ≫= λ b₁ →
    पूर्ण-प्रमाणम् E Y Γ fl (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩) ≫= λ b₂ →
    mmap (युगपद्-आरोहः k j l r kj b₁ b₂)
         (अथवा (द्वि-व्याप्तिः E Y Γ k j l r)
          (अथवा (द्वि-व्याप्तिः E Y [] k j l r)
           (अथवा (द्वि-व्याप्तिः नेत्रम्-न Y Γ k j l r) (द्वि-व्याप्तिः नेत्रम्-न Y [] k j l r))))

पू-द्विचक्रः E Y Γ fl k zero    l r = nothing
पू-द्विचक्रः E Y Γ fl k (suc j) l r =
  अथवा (पू-द्वयम् E Y Γ fl k j l r) (पू-द्विचक्रः E Y Γ fl k j l r)

पू-कचक्रः E Y Γ fl zero    N l r = nothing
पू-कचक्रः E Y Γ fl (suc k) N l r =
  अथवा (पू-द्विचक्रः E Y Γ fl k N l r) (पू-कचक्रः E Y Γ fl k N l r)

------------------------------------------------------------------------
-- §12  The breath.  Digest the stream cumulatively; re-breathe only
--     the residue; a quiet breath is a fixpoint.  The breath is a
--     STANDPOINT'S breath — eye and instrument are parameters — and
--     the un-parameterized names keep the full setting, so nothing
--     downstream moves.
------------------------------------------------------------------------

नय-श्वासः : दृक् → यन्त्रम् → List नियमः → List Eq' → List नियमः × List Eq'
नय-श्वासः E Y Γ []             = Γ , []
नय-श्वासः E Y Γ ((l , r) ∷ es) with पूर्ण-प्रमाणम् E Y Γ इन्धनम् (l , r)
नय-श्वासः E Y Γ ((l , r) ∷ es) | just pf = नय-श्वासः E Y (niyama l r pf ∷ Γ) es
नय-श्वासः E Y Γ ((l , r) ∷ es) | nothing with नय-श्वासः E Y Γ es
नय-श्वासः E Y Γ ((l , r) ∷ es) | nothing | (Γ' , sh) = Γ' , ((l , r) ∷ sh)

नय-प्राणः : दृक् → यन्त्रम् → Nat → List नियमः → List Eq' → List नियमः × List Eq'
नय-प्राणः E Y zero    Γ es = Γ , es
नय-प्राणः E Y (suc n) Γ es with नय-श्वासः E Y Γ es
नय-प्राणः E Y (suc n) Γ es | (Γ' , sh) = नय-प्राणः E Y n Γ' sh

श्वासः : List नियमः → List Eq' → List नियमः × List Eq'
श्वासः = नय-श्वासः गूढ-दृक् संयुक्त-यन्त्रम्

प्राणः : Nat → List नियमः → List Eq' → List नियमः
प्राणः n Γ es = fst (नय-प्राणः गूढ-दृक् संयुक्त-यन्त्रम् n Γ es)
