{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- चक्र — the wheel.
--
-- WHY THIS FILE EXISTS.  `SensorNerode` proves that a family of moduli
-- observes a natural only through the family's least common multiple,
-- and then declines two things in a WHAT IS NOT CLAIMED paragraph:
--
--   * the RESIDUE BRIDGE.  It works with `m ∣ dist a b` and says the
--     identification with equality of residues is "entirely standard"
--     and unchecked.
--   * the AUTOMATON.  It says there is no alphabet, no machine, no
--     language and no Myhill-Nerode theorem, and that the automata-
--     theoretic reading is a reading.
--
-- Both are closed here, as theorems.  And the first one is not what the
-- note assumed: the bridge is TRUE at every positive modulus and FALSE
-- at modulus zero, where the two readings of the same number sit at
-- opposite ends of the observability scale.  §३ exhibits the pair.  The
-- hypothesis is load-bearing, not decorative — which is exactly what an
-- unchecked "entirely standard" step can hide.
--
-- WHAT IS CHECKED
--
--   §१  the arithmetic: ∸ cancellation, and · over ∸.
--   §२  `bridge`         (suc n ∣ dist a b) ≡ (a mod suc n ≡ b mod suc n)
--   §३  `bridge-fails-at-zero`   …and it does not extend to 0.
--   §४  `ind→residues`   the family form: divisibility of the distance
--       `residues→ind`   is agreement of the whole residue profile.
--   §५  `Machine`        one letter, `Word ≅ ℕ` constructed, `Nerode`.
--   §६  `nerode-is-ind`  THE NERODE RELATION OF THE SENSOR MACHINE IS
--                        `Ind`, as an equality of types.
--   §८  `classify-sound` MYHILL-NERODE: the quotient is the L-wheel.
--       `classify-complete`
--       `classify-onto`
--       `simulates`      the wheel computes the same reports.
--       `full-turn`      L turns return every state …
--       `no-shorter-turn`… and no positive number below L returns one,
--                        so the order is exactly L and "the cyclic group
--                        of order the lcm" is a theorem, not a gloss.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Cakra_TheResidueBridgeIsProvedAndTheMinimalAcceptorIsTheCyclicGroupOfOrderTheLcm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isProp× ; isPropΠ)
open import Cubical.Foundations.Univalence using (hPropExt)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.List using (List ; [] ; _∷_ ; map ; cons-inj₁ ; cons-inj₂ ; isOfHLevelList)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)

open import WalkCapacity using (All ; CommonMultiple ; IsLCM)
open import LCMExists   using (lcmList ; lcmList-isLCM)
open import SensorNerode using (dist ; dist-0 ; Ind ; isPropInd ; ind→lcm ; lcm→ind)

------------------------------------------------------------------------
-- १ · the arithmetic the bridge needs, and nothing more.
------------------------------------------------------------------------

-- a ∸ (k + a) ≡ 0.  Induction on a; the step is definitional once the
-- successor is moved out of the second argument.
∸-shift-zero : (a k : ℕ) → a ∸ (k + a) ≡ 0
∸-shift-zero zero    k = zero∸ (k + zero)
∸-shift-zero (suc a) k = cong (suc a ∸_) (+-suc k a) ∙ ∸-shift-zero a k

≤→∸≡0 : {a b : ℕ} → a ≤ b → a ∸ b ≡ 0
≤→∸≡0 {a = a} (k , p) = subst (λ z → a ∸ z ≡ 0) p (∸-shift-zero a k)

-- a common prefix cancels out of a truncated subtraction.  Definitional
-- at every step: this is why the residue bridge costs so little.
+∸+ : (r x y : ℕ) → (r + x) ∸ (r + y) ≡ x ∸ y
+∸+ zero    x y = refl
+∸+ (suc r) x y = +∸+ r x y

-- multiplication distributes over truncated subtraction on the left.
·-∸-distribˡ : (k m n : ℕ) → (k · m) ∸ (k · n) ≡ k · (m ∸ n)
·-∸-distribˡ k zero n =
    cong (_∸ (k · n)) (sym (0≡m·0 k))
  ∙ zero∸ (k · n)
  ∙ 0≡m·0 k
  ∙ cong (k ·_) (sym (zero∸ n))
·-∸-distribˡ k (suc m) zero =
  cong ((k · suc m) ∸_) (sym (0≡m·0 k))
·-∸-distribˡ k (suc m) (suc n) =
  (λ i → ·-suc k m i ∸ ·-suc k n i)
  ∙ +∸+ k (k · m) (k · n)
  ∙ ·-∸-distribˡ k m n

-- the distance is symmetric, and collapses to one subtraction on the
-- side where that subtraction is the whole of it.
dist-sym : (a b : ℕ) → dist a b ≡ dist b a
dist-sym a b = +-comm (a ∸ b) (b ∸ a)

dist-≥ : (a b : ℕ) → b ≤ a → dist a b ≡ a ∸ b
dist-≥ a b b≤a = cong ((a ∸ b) +_) (≤→∸≡0 b≤a) ∙ +-zero (a ∸ b)

------------------------------------------------------------------------
-- २ · THE RESIDUE BRIDGE, at a positive modulus.
--
-- `SensorNerode`'s note says the identification of `m ∣ dist a b` with
-- equality of residues is "entirely standard" and leaves it unchecked.
-- It is standard, it is true at every positive modulus, and here it is.
------------------------------------------------------------------------

module _ (n : ℕ) where
  private
    m : ℕ
    m = suc n

  -- ⇒, on the ordered side.  Write a as (a ∸ b) + b, push the mod
  -- through the sum, and kill the first summand: it is a multiple of m.
  ∸∣→mod≡ : (a b : ℕ) → b ≤ a → m ∣ (a ∸ b) → a mod m ≡ b mod m
  ∸∣→mod≡ a b b≤a d =
      cong (_mod m) (sym (≤-∸-+-cancel b≤a))
    ∙ mod-lCancel m (a ∸ b) b
    ∙ cong (λ z → (z + b) mod m) q0
    where
      c : ℕ
      c = fst (∣-untrunc d)
      ce : c · m ≡ a ∸ b
      ce = snd (∣-untrunc d)
      q0 : (a ∸ b) mod m ≡ 0
      q0 = cong (_mod m) (sym ce) ∙ zero-charac-gen m c

  -- ⇐, on the ordered side.  Both numbers split as residue plus a
  -- multiple of m; the residues are equal, so they cancel, and what is
  -- left is m times something.
  mod≡→∸∣ : (a b : ℕ) → b ≤ a → a mod m ≡ b mod m → m ∣ (a ∸ b)
  mod≡→∸∣ a b b≤a p = subst (m ∣_) (sym split≡) (∣-left (qa ∸ qb))
    where
      qa qb : ℕ
      qa = quotient a / m
      qb = quotient b / m
      ea : (a mod m) + m · qa ≡ a
      ea = ≡remainder+quotient m a
      eb : (b mod m) + m · qb ≡ b
      eb = ≡remainder+quotient m b
      split≡ : a ∸ b ≡ m · (qa ∸ qb)
      split≡ = (λ i → ea (~ i) ∸ eb (~ i))
         ∙ cong (λ z → ((a mod m) + m · qa) ∸ (z + m · qb)) (sym p)
         ∙ +∸+ (a mod m) (m · qa) (m · qb)
         ∙ ·-∸-distribˡ m qa qb

  -- …and the two, with the order hypothesis discharged by trichotomy.
  dist∣→mod≡ : (a b : ℕ) → m ∣ dist a b → a mod m ≡ b mod m
  dist∣→mod≡ a b d with splitℕ-≤ b a
  ... | inl b≤a = ∸∣→mod≡ a b b≤a (subst (m ∣_) (dist-≥ a b b≤a) d)
  ... | inr a<b = sym (∸∣→mod≡ b a (<-weaken a<b)
                        (subst (m ∣_) (dist-≥ b a (<-weaken a<b))
                               (subst (m ∣_) (dist-sym a b) d)))

  mod≡→dist∣ : (a b : ℕ) → a mod m ≡ b mod m → m ∣ dist a b
  mod≡→dist∣ a b p with splitℕ-≤ b a
  ... | inl b≤a = subst (m ∣_) (sym (dist-≥ a b b≤a)) (mod≡→∸∣ a b b≤a p)
  ... | inr a<b = subst (m ∣_) (sym (dist-sym a b))
                    (subst (m ∣_) (sym (dist-≥ b a (<-weaken a<b)))
                           (mod≡→∸∣ b a (<-weaken a<b) (sym p)))

  -- as an equality of types.  Both sides are propositions: divisibility
  -- is one by `isProp∣`, and residue equality is one because ℕ is a set.
  bridge : (a b : ℕ) → (m ∣ dist a b) ≡ (a mod m ≡ b mod m)
  bridge a b =
    hPropExt isProp∣ (isSetℕ (a mod m) (b mod m))
             (dist∣→mod≡ a b) (mod≡→dist∣ a b)

------------------------------------------------------------------------
-- ३ · AND AT ZERO IT IS FALSE.  Exhibited, not warned about.
--
-- The library defines `x mod 0 = 0`, so the modulus 0 read as a residue
-- sensor is BLIND — it reports the same thing about everything.  Read as
-- divisibility it is the opposite: `0 ∣ d` holds exactly when `d ≡ 0`,
-- so it is the PERFECT sensor, separating every pair.  The two readings
-- of "modulus 0" are not merely different, they are at opposite ends,
-- and the pair (0,1) is where they are pulled apart.
--
-- This is why §२ is stated at `suc n` and not at `m`.  The hypothesis is
-- not bookkeeping; without it the statement is refuted below.
------------------------------------------------------------------------

zero-as-residue-is-blind : (0 mod 0) ≡ (1 mod 0)
zero-as-residue-is-blind = refl

zero-as-divisor-is-sighted : ¬ (0 ∣ dist 0 1)
zero-as-divisor-is-sighted d = znots (∣-zeroˡ d)

-- so the bridge does not extend to modulus 0, and this is the witness.
bridge-fails-at-zero : ¬ ((a b : ℕ) → (0 ∣ dist a b) ≡ (a mod 0 ≡ b mod 0))
bridge-fails-at-zero h =
  zero-as-divisor-is-sighted (transport (sym (h 0 1)) zero-as-residue-is-blind)

------------------------------------------------------------------------
-- ४ · the FAMILY bridge: divisibility of the distance, for a family of
-- positive moduli, is agreement of the whole residue profile.
------------------------------------------------------------------------

Positive : List ℕ → Type
Positive = All (λ m → 0 < m)

SameResidues : List ℕ → ℕ → ℕ → Type
SameResidues S a b = All (λ m → a mod m ≡ b mod m) S

0<→suc : {x : ℕ} → 0 < x → Σ[ n ∈ ℕ ] x ≡ suc n
0<→suc (k , p) = k , sym p ∙ +-comm k 1

ind→residues : (S : List ℕ) → Positive S
             → (a b : ℕ) → Ind S a b → SameResidues S a b
ind→residues []       _         a b _        = tt
ind→residues (x ∷ S) (px , ps) a b (d , ds) =
    subst (λ z → a mod z ≡ b mod z) (sym q)
          (dist∣→mod≡ n a b (subst (_∣ dist a b) q d))
  , ind→residues S ps a b ds
  where
    n : ℕ
    n = fst (0<→suc px)
    q : x ≡ suc n
    q = snd (0<→suc px)

residues→ind : (S : List ℕ) → Positive S
             → (a b : ℕ) → SameResidues S a b → Ind S a b
residues→ind []       _         a b _        = tt
residues→ind (x ∷ S) (px , ps) a b (r , rs) =
    subst (_∣ dist a b) (sym q)
          (mod≡→dist∣ n a b (subst (λ z → a mod z ≡ b mod z) q r))
  , residues→ind S ps a b rs
  where
    n : ℕ
    n = fst (0<→suc px)
    q : x ≡ suc n
    q = snd (0<→suc px)

------------------------------------------------------------------------
-- ५ · THE ALPHABET, THE MACHINE, THE LANGUAGE.
--
-- A sensor array is driven by one event repeated: there is exactly one
-- letter, and a word over a one-letter alphabet IS a natural number.
-- So the alphabet is `Unit`, `Unit *` is `ℕ`, and a deterministic
-- machine with output is a step and an output map.  This is a Moore
-- machine, which is the right shape because a sensor array REPORTS
-- rather than accepts; taking `O` to be `Bool` gives the acceptor.
------------------------------------------------------------------------

Alphabet : Type
Alphabet = Unit

-- words over a one-letter alphabet, and the identification with ℕ that
-- makes this an automaton rather than an analogy.
Word : Type
Word = List Alphabet

len : Word → ℕ
len []       = 0
len (_ ∷ w) = suc (len w)

tally : ℕ → Word
tally zero    = []
tally (suc k) = tt ∷ tally k

len-tally : (k : ℕ) → len (tally k) ≡ k
len-tally zero    = refl
len-tally (suc k) = cong suc (len-tally k)

tally-len : (w : Word) → tally (len w) ≡ w
tally-len []          = refl
tally-len (tt ∷ w) = cong (tt ∷_) (tally-len w)

record Machine (Q : Type) (O : Type) : Type where
  constructor machine
  field
    step : Q → Q
    out  : Q → O

open Machine public

-- reading a word from a state is stepping once per letter.
reads : {Q O : Type} → Machine Q O → Word → Q → Q
reads M []       q = q
reads M (_ ∷ w) q = reads M w (step M q)

-- the behaviour of a state: what the machine reports after each word.
behaviour : {Q O : Type} → Machine Q O → Q → Word → O
behaviour M q w = out M (reads M w q)

-- THE NERODE RELATION: two states are equivalent when no word in the
-- language separates their reports.
Nerode : {Q O : Type} → Machine Q O → Q → Q → Type
Nerode M q q' = (w : Word) → behaviour M q w ≡ behaviour M q' w

isPropNerode : {Q : Type} {O : Type} → isSet O
             → (M : Machine Q O) (q q' : Q) → isProp (Nerode M q q')
isPropNerode sO M q q' = isPropΠ (λ w → sO _ _)

------------------------------------------------------------------------
-- ६ · THE SENSOR MACHINE, and its Nerode relation is `Ind`.
--
-- States are the naturals, the letter advances by one, and the report
-- is the residue profile.  This is the machine the abstract's last
-- paragraph describes; the theorem is that its Nerode relation is
-- exactly the indistinguishability relation `SensorNerode` studies.
------------------------------------------------------------------------

profile : List ℕ → ℕ → List ℕ
profile S x = map (x mod_) S

sensor : List ℕ → Machine ℕ (List ℕ)
step (sensor S) = suc
out  (sensor S) = profile S

reads-sensor : (S : List ℕ) (w : Word) (x : ℕ) → reads (sensor S) w x ≡ len w + x
reads-sensor S []          x = refl
reads-sensor S (tt ∷ w) x = reads-sensor S w (suc x) ∙ +-suc (len w) x

-- reading a word shifts the state, and the distance is shift-invariant,
-- so `Ind` is a right congruence — which is the property that makes a
-- Nerode argument possible at all.
dist-shift : (k a b : ℕ) → dist (k + a) (k + b) ≡ dist a b
dist-shift k a b i = +∸+ k a b i + +∸+ k b a i

Ind-shift : (S : List ℕ) (k a b : ℕ) → Ind S a b → Ind S (k + a) (k + b)
Ind-shift S k a b = subst (λ d → All (_∣ d) S) (sym (dist-shift k a b))

map≡→All : (S : List ℕ) (f g : ℕ → ℕ)
         → map f S ≡ map g S → All (λ m → f m ≡ g m) S
map≡→All []       f g p = tt
map≡→All (x ∷ S) f g p = cons-inj₁ p , map≡→All S f g (cons-inj₂ p)

All→map≡ : (S : List ℕ) (f g : ℕ → ℕ)
         → All (λ m → f m ≡ g m) S → map f S ≡ map g S
All→map≡ []       f g _        = refl
All→map≡ (x ∷ S) f g (q , qs) = cong₂ _∷_ q (All→map≡ S f g qs)

profile≡→residues : (S : List ℕ) (a b : ℕ)
                  → profile S a ≡ profile S b → SameResidues S a b
profile≡→residues S a b = map≡→All S (a mod_) (b mod_)

residues→profile≡ : (S : List ℕ) (a b : ℕ)
                  → SameResidues S a b → profile S a ≡ profile S b
residues→profile≡ S a b = All→map≡ S (a mod_) (b mod_)

------------------------------------------------------------------------
-- THE FIRST HALF OF MYHILL–NERODE, as a theorem about this machine:
-- the Nerode relation of the sensor machine IS `Ind`.
--
-- Forward is the empty word and nothing else — no word is needed to
-- separate what the report already separates.  Backward is where the
-- work is: `Ind` must survive reading an arbitrary word, and it does
-- because the distance is shift-invariant.
------------------------------------------------------------------------

nerode→ind : (S : List ℕ) → Positive S → (a b : ℕ)
           → Nerode (sensor S) a b → Ind S a b
nerode→ind S pos a b h =
  residues→ind S pos a b (profile≡→residues S a b (h []))

ind→nerode : (S : List ℕ) → Positive S → (a b : ℕ)
           → Ind S a b → Nerode (sensor S) a b
ind→nerode S pos a b ind w =
    cong (profile S) (reads-sensor S w a)
  ∙ residues→profile≡ S (len w + a) (len w + b)
      (ind→residues S pos (len w + a) (len w + b)
        (Ind-shift S (len w) a b ind))
  ∙ cong (profile S) (sym (reads-sensor S w b))

nerode-is-ind : (S : List ℕ) → Positive S → (a b : ℕ)
              → Nerode (sensor S) a b ≡ Ind S a b
nerode-is-ind S pos a b =
  hPropExt (isPropNerode (isOfHLevelList 0 isSetℕ) (sensor S) a b)
           (isPropInd S a b)
           (nerode→ind S pos a b) (ind→nerode S pos a b)

------------------------------------------------------------------------
-- ७ · the order facts the minimality argument runs on.
------------------------------------------------------------------------

absurd : {X : Type} → ⊥ → X
absurd ()

∸≡0→≤ : (a b : ℕ) → a ∸ b ≡ 0 → a ≤ b
∸≡0→≤ zero    b       _ = zero-≤
∸≡0→≤ (suc a) zero    p = absurd (snotz p)
∸≡0→≤ (suc a) (suc b) p = suc-≤-suc (∸≡0→≤ a b p)

dist≡0→≡ : (i j : ℕ) → dist i j ≡ 0 → i ≡ j
dist≡0→≡ i j p with splitℕ-≤ j i
... | inl j≤i = ≤-antisym (∸≡0→≤ i j (sym (dist-≥ i j j≤i) ∙ p)) j≤i
... | inr i<j = ≤-antisym (<-weaken i<j)
                  (∸≡0→≤ j i (sym (dist-≥ j i (<-weaken i<j))
                              ∙ sym (dist-sym i j) ∙ p))

dist<bound : (B i j : ℕ) → i < B → j < B → dist i j < B
dist<bound B i j i<B j<B with splitℕ-≤ j i
... | inl j≤i = ≤<-trans (subst (_≤ i) (sym (dist-≥ i j j≤i)) (∸-≤ i j)) i<B
... | inr i<j = ≤<-trans (subst (_≤ j) (sym (dist-≥ j i (<-weaken i<j))
                                        ∙ sym (dist-sym i j)) (∸-≤ j i)) j<B

∣→<→≡0 : (D d : ℕ) → D ∣ d → d < D → d ≡ 0
∣→<→≡0 D d dv d<D with discreteℕ d 0
... | yes p  = p
... | no ¬p = absurd (<-asym d<D (m∣n→m≤n ¬p dv))

Ind-sym : (S : List ℕ) (a b : ℕ) → Ind S a b → Ind S b a
Ind-sym S a b = subst (λ d → All (_∣ d) S) (dist-sym a b)

------------------------------------------------------------------------
-- ८ · THE MINIMAL ACCEPTOR IS THE CYCLIC GROUP OF ORDER THE LCM.
--
-- Everything below is about one machine: states `{0,…,L−1}`, one letter,
-- and the letter turns the wheel by one notch.  The three facts that
-- make it THE minimal machine — and not merely A machine with the right
-- behaviour — are `classify-sound`, `classify-complete` and
-- `classify-onto`.  §८.४ then shows the wheel really is a wheel of
-- order exactly L: L turns return every state, and no fewer than L do.
------------------------------------------------------------------------

module _ (S : List ℕ) (pos : Positive S) (l : ℕ) (isL : IsLCM S (suc l)) where
  private
    L : ℕ
    L = suc l

  -- ८.१  exhaustiveness: every state is equivalent to its residue, so
  -- the classes are exhausted by the L residues.  No arithmetic: the
  -- residue of the residue is the residue, and §२ turns that into the
  -- divisibility the family needs.
  reduce : (x : ℕ) → Ind S x (x mod L)
  reduce x = lcm→ind isL x (x mod L)
               (mod≡→dist∣ l x (x mod L) (sym (mod-idempotent x)))

  -- ८.२  distinctness: two DIFFERENT residues are never equivalent, so
  -- there are no fewer than L classes.  This is the half that makes the
  -- machine minimal rather than merely correct.
  separate : (i j : ℕ) → i < L → j < L → Ind S i j → i ≡ j
  separate i j i<L j<L ind =
    dist≡0→≡ i j
      (∣→<→≡0 L (dist i j) (ind→lcm isL i j ind) (dist<bound L i j i<L j<L))

  -- ८.३  the machine, and the classifying map.
  Cakra : Type
  Cakra = Σ[ k ∈ ℕ ] (k < L)

  turn : Cakra → Cakra
  turn (k , _) = (suc k) mod L , mod< l (suc k)

  cyclic : Machine Cakra (List ℕ)
  step cyclic         = turn
  out  cyclic (k , _) = profile S k

  classify : ℕ → Cakra
  classify x = x mod L , mod< l x

  classify-step : (x : ℕ) → classify (suc x) ≡ turn (classify x)
  classify-step x = Σ≡Prop (λ _ → isProp≤) (mod-rCancel L 1 x)

  reads-classify : (w : Word) (x : ℕ)
                 → reads cyclic w (classify x) ≡ classify (len w + x)
  reads-classify []          x = refl
  reads-classify (tt ∷ w) x =
      cong (reads cyclic w) (sym (classify-step x))
    ∙ reads-classify w (suc x)
    ∙ cong classify (+-suc (len w) x)

  -- the wheel computes the same reports as the unbounded sensor: it is
  -- a correct implementation, and the state it keeps is one residue.
  simulates : (x : ℕ) (w : Word)
            → behaviour cyclic (classify x) w ≡ behaviour (sensor S) x w
  simulates x w =
      cong (out cyclic) (reads-classify w x)
    ∙ residues→profile≡ S ((len w + x) mod L) (len w + x)
        (ind→residues S pos ((len w + x) mod L) (len w + x)
          (Ind-sym S (len w + x) ((len w + x) mod L) (reduce (len w + x))))
    ∙ cong (profile S) (sym (reads-sensor S w x))

  -- MYHILL–NERODE.  The three together say the Nerode quotient of the
  -- sensor language is exactly the L-element wheel: `classify` is
  -- well-defined on classes, injective on them, and onto.
  classify-sound : (a b : ℕ) → Nerode (sensor S) a b → classify a ≡ classify b
  classify-sound a b h =
    Σ≡Prop (λ _ → isProp≤)
      (dist∣→mod≡ l a b (ind→lcm isL a b (nerode→ind S pos a b h)))

  classify-complete : (a b : ℕ) → classify a ≡ classify b → Nerode (sensor S) a b
  classify-complete a b p =
    ind→nerode S pos a b (lcm→ind isL a b (mod≡→dist∣ l a b (cong fst p)))

  classify-onto : (c : Cakra) → Σ[ x ∈ ℕ ] classify x ≡ c
  classify-onto (k , k<L) =
    k , Σ≡Prop (λ _ → isProp≤) (modIndBase l k k<L)

  -- ८.४  and the wheel is a wheel of order EXACTLY L.
  --
  -- L turns return every state …
  full-turn : (c : Cakra) → reads cyclic (tally L) c ≡ c
  full-turn c =
      cong (reads cyclic (tally L)) (sym (classify-onto c .snd))
    ∙ reads-classify (tally L) (classify-onto c .fst)
    ∙ Σ≡Prop (λ _ → isProp≤)
        (cong (λ z → (z + classify-onto c .fst) mod L) (len-tally L)
         ∙ sym (mod-lUnit L (classify-onto c .fst)))
    ∙ classify-onto c .snd

  -- … and no positive number of turns below L does.  So the order is L
  -- on the nose, and "the cyclic group of order the lcm" is a theorem
  -- about this machine and not a description of it.
  no-shorter-turn : (k : ℕ) → 0 < k → k < L
                  → ¬ (reads cyclic (tally k) (classify 0) ≡ classify 0)
  no-shorter-turn k 0<k k<L p =
    ¬-<-zero (subst (0 <_) (separate k 0 k<L (l , +-comm l 1) k∼0) 0<k)
    where
      cls : classify k ≡ classify 0
      cls = sym (cong (reads cyclic (tally k)) refl
                  ∙ reads-classify (tally k) 0
                  ∙ cong (λ z → classify (z + 0)) (len-tally k)
                  ∙ cong classify (+-zero k))
            ∙ p
      k∼0 : Ind S k 0
      k∼0 = nerode→ind S pos k 0 (classify-complete k 0 cls)
