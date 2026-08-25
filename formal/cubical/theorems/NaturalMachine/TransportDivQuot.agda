{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TransportDivQuot
--
-- EUCLIDEAN DIVISION ON THE CHART.  `Transport` carries `+`,
-- `TransportMul` carries `·`, `TransportDiv` carries the *residue*
-- (`modw n`, the Horner automaton).  This module carries the *quotient*.
--
-- WHAT IS DELIVERED.
--
--   * `divw : ℕ → Word → Word`, division of a digit word by a natural
--     number modulus, computed digit by digit.  It never mentions
--     `value`: the recursion threads one state r < n (the running
--     residue) from the least significant end, exactly as `modw` does,
--     and emits one quotient digit per input digit.
--
--   * `value-divw-euclid : value w ≡ suc n · value (divw (suc n) w)
--                                  + modw (suc n) w`
--     — the self-contained Euclidean identity, with the remainder being
--     literally `TransportDiv`'s automaton, together with
--     `modw-bound : modw (suc n) w < suc n`.
--
--   * `value-divw : value (divw n w) ≡ quotient (value w) / n`, for ALL
--     n including n = 0.  This is not a special case that had to be
--     bolted on: `Cubical.Data.Nat.Mod` defines `quotient x / 0 = 0`,
--     and `divw 0 w = []` has value 0, so the two silences agree.  The
--     Euclidean identity is stated only for positive moduli because at
--     n = 0 it is false, not because it is hard.
--
--   * A transport statement in the shape of the other two files:
--     `transport (λ i → ℕ≡CanWord i → ℕ≡CanWord i) (λ m → quotient m / suc n)
--        ≡ divC (suc n)`.
--
-- WHAT IS NOT DELIVERED.
--
--   * Full Word ÷ Word long division.  Only division by a ℕ modulus is
--     here.  The walk's divisibility test needs no more than this, and
--     the general algorithm needs a trial-digit estimate (Knuth D) whose
--     correctness proof is a different piece of work.
--
--   * CANONICITY OF THE QUOTIENT.  It is false, and pretending otherwise
--     would be the only dishonest thing this file could do.
--     `divw-length : length (divw (suc n) w) ≡ length w` — the quotient
--     occupies exactly as many digit positions as the input, so dividing
--     shrinks the value without shrinking the string, and the top
--     positions fill with zeros.  (Base 10, w = [2,1] i.e. 12, n = 5:
--     the quotient word is [2,0], and `Canonical [2,0]` is `0 < 0`.)
--     What is true and proved instead: `trimw` drops trailing zeros
--     (= leading zeros, the words being little-endian) with
--     `value-trimw : value (trimw w) ≡ value w`,
--     `canonical-trimw : Canonical (trimw w)`, and
--     `trimw-canonical : Canonical w → trimw w ≡ w`, so the trim is a
--     normalisation and not a second algorithm.  `divC` is
--     `trimw ∘ divw`, and it is `divC`, not `divw`, that lands in
--     `CanWord`.
--
--   * A ℕ-level cost model for the library's `quotient _/_`.  Two bounds
--     that do belong here are proved: the operand handed to the library
--     at each digit is `< b · suc n` (`digit-scale-bound`) and the digit
--     it returns is `< b` (`quotient-bound`).  So the per-digit work is
--     bounded by a function of the base and the modulus alone, uniformly
--     in the word — which is the entire reason this beats the unary test.
--     The constant itself is not formalised.
--
-- COST.  `divSteps w ≡ suc (length w)` and `divSteps w ≡ steps w`: the
-- quotient automaton visits each digit exactly once, with the same step
-- count as `TransportDiv`'s residue automaton, because it IS that
-- automaton with an extra output tape.  `remw-is-modw` records that the
-- single pass recomputes the residue, so nothing needs a second pass.
--
-- CHECKED: Agda 2.6.3, cubical (the /tmp/cubical checkout), --cubical
-- --safe, 2026-08-15.  No postulates, no holes, no TERMINATING.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module NaturalMachine.TransportDivQuot (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod
  using (_mod_ ; mod< ; modIndBase ; remainder_/_ ; quotient_/_
        ; ≡remainder+quotient)
open import Cubical.Data.Nat.Divisibility using (_∣_)
open import Cubical.Data.Fin using (Fin ; fzero ; toℕ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)

open import NaturalMachine.Digits k
open import SourcedProofs.TransportDiv k
  using (modw ; value-modw ; steps ; steps-is-length)

------------------------------------------------------------------------
-- DEPENDENCIES.  `Digits` and `TransportDiv`, and nothing else in the
-- lane.  Division by a modulus needs neither the ripple adder nor the
-- shift-and-add multiplier: the quotient digit comes from the library's
-- Euclidean division on a number bounded by b · n, so `addw` and `mulw`
-- never appear.  `valueC-inj` is restated here (it is two lines from
-- `Digits.value-inj`) rather than imported from `Transport`, so that
-- this module does not inherit `Transport`'s dependency on the
-- reflection-based semiring solver; the two place-value identities in §2
-- are proved by hand for the same reason.
------------------------------------------------------------------------

valueC-inj : (x y : CanWord) → valueC x ≡ valueC y → x ≡ y
valueC-inj (u , cu) (v , cv) p = Σ≡Prop isPropCanonical (value-inj u v cu cv p)

------------------------------------------------------------------------
-- 0.  Two facts about the library's Euclidean division that are used as
--     the digit-column primitive.  Neither is measured; both are the
--     defining identity `≡remainder+quotient` plus cancellation.
------------------------------------------------------------------------

-- If x is below c copies of the modulus, the quotient is below c.
-- (This is what makes a quotient *digit* a digit at all.)
quotient-bound : (n c x : ℕ) → x < c · suc n → (quotient x / suc n) < c
quotient-bound n c x h with splitℕ-< (quotient x / suc n) c
... | inl p = p
... | inr p = Empty.rec (¬m<m (≤<-trans big h))
  where
    q : ℕ
    q = quotient x / suc n

    qm≤x : suc n · q ≤ x
    qm≤x = (x mod suc n) , ≡remainder+quotient (suc n) x

    big : c · suc n ≤ x
    big = ≤-trans (subst (c · suc n ≤_) (·-comm q (suc n)) (≤-·k {k = suc n} p))
                  qm≤x

-- One digit joined to a residue stays below b copies of the modulus.
digit-scale-bound : (n : ℕ) (d : Digit) (r : ℕ)
                  → r < suc n → toℕ d + b · r < b · suc n
digit-scale-bound n d r rlt = <≤-trans (<-+k (snd d)) le
  where
    le : b + b · r ≤ b · suc n
    le = subst2 _≤_ (·-comm (suc r) b ∙ ·-suc b r) (·-comm (suc n) b)
                (≤-·k {k = b} rlt)

------------------------------------------------------------------------
-- 1.  The residue is bounded.  (`TransportDiv` proves the automaton is
--     the residue; the library proves the residue is small.)
------------------------------------------------------------------------

modw-bound : (n : ℕ) (w : Word) → modw (suc n) w < suc n
modw-bound n w = subst (_< suc n) (sym (value-modw (suc n) w)) (mod< n (value w))

------------------------------------------------------------------------
-- 2.  The quotient automaton.
--
-- One pass, least significant digit first, carrying a single state
-- r < suc n.  The certificate travels with the output, in the style of
-- `dsucΣ` and `addDigitΣ`: the Euclidean identity for the whole word and
-- the identification of the state with `modw` are produced by the same
-- recursion that produces the digits, so no `with`-abstraction can lose
-- them.
------------------------------------------------------------------------

DivMod : ℕ → Word → Type₀
DivMod n w =
  Σ[ q ∈ Word ] Σ[ r ∈ ℕ ]
    ((value w ≡ suc n · value q + r) × (r ≡ modw (suc n) w))

-- the two place-value identities, by hand (see DEPENDENCIES above)
shuffle : (a c z : ℕ) → a + (c + z) ≡ c + (a + z)
shuffle a c z = +-assoc a c z ∙ cong (_+ z) (+-comm a c) ∙ sym (+-assoc c a z)

divlem1 : (D bb M QQ R : ℕ)
        → D + bb · (M · QQ + R) ≡ bb · (M · QQ) + (D + bb · R)
divlem1 D bb M QQ R =
    cong (D +_) (sym (·-distribˡ bb (M · QQ) R))
  ∙ shuffle D (bb · (M · QQ)) (bb · R)

divlem2 : (bb M QQ S rr : ℕ)
        → bb · (M · QQ) + (M · S + rr) ≡ M · (S + bb · QQ) + rr
divlem2 bb M QQ S rr =
    cong (_+ (M · S + rr)) mulshift
  ∙ +-assoc (M · (bb · QQ)) (M · S) rr
  ∙ cong (_+ rr) ( +-comm (M · (bb · QQ)) (M · S)
                 ∙ ·-distribˡ M S (bb · QQ) )
  where
    mulshift : bb · (M · QQ) ≡ M · (bb · QQ)
    mulshift = ·-assoc bb M QQ
             ∙ cong (_· QQ) (·-comm bb M)
             ∙ sym (·-assoc M bb QQ)

divStep : (n : ℕ) (d : Digit) (w : Word) → DivMod n w → DivMod n (d ∷ w)
divStep n d w (q , r , cert , res) = (q₀ ∷ q) , (s mod suc n) , bigEq , bigRem
  where
    s : ℕ
    s = toℕ d + b · r

    rlt : r < suc n
    rlt = subst (_< suc n) (sym res) (modw-bound n w)

    q₀ : Digit
    q₀ = quotient s / suc n , quotient-bound n b s (digit-scale-bound n d r rlt)

    -- the digit-column certificate: s = (suc n)·digit + residue
    eucl : s ≡ suc n · toℕ q₀ + (s mod suc n)
    eucl = sym (≡remainder+quotient (suc n) s)
         ∙ +-comm (s mod suc n) (suc n · (quotient s / suc n))

    bigEq : toℕ d + b · value w ≡ suc n · (toℕ q₀ + b · value q) + (s mod suc n)
    bigEq = cong (λ z → toℕ d + b · z) cert
          ∙ divlem1 (toℕ d) b (suc n) (value q) r
          ∙ cong (b · (suc n · value q) +_) eucl
          ∙ divlem2 b (suc n) (value q) (toℕ q₀) (s mod suc n)

    bigRem : (s mod suc n) ≡ (toℕ d + b · modw (suc n) w) mod suc n
    bigRem = cong (λ z → (toℕ d + b · z) mod suc n) res

divmodΣ : (n : ℕ) (w : Word) → DivMod n w
divmodΣ n []      = [] , 0 , eqNil , remNil
  where
    eqNil : 0 ≡ suc n · 0 + 0
    eqNil = 0≡m·0 (suc n) ∙ sym (+-zero (suc n · 0))

    remNil : 0 ≡ 0 mod suc n
    remNil = sym (modIndBase n 0 (suc-≤-suc zero-≤))
divmodΣ n (d ∷ w) = divStep n d w (divmodΣ n w)

------------------------------------------------------------------------
-- 3.  The two projections, as ordinary (undecorated) programs.
------------------------------------------------------------------------

divw : ℕ → Word → Word
divw zero    w = []
divw (suc n) w = fst (divmodΣ n w)

remw : ℕ → Word → ℕ
remw zero    w = 0
remw (suc n) w = fst (snd (divmodΣ n w))

-- The single pass already computes the residue: `modw` need not be run
-- again.
remw-is-modw : (n : ℕ) (w : Word) → remw (suc n) w ≡ modw (suc n) w
remw-is-modw n w = snd (snd (snd (divmodΣ n w)))

------------------------------------------------------------------------
-- 4.  THE EUCLIDEAN IDENTITY.  Self-contained: it mentions only the two
--     digit automata and the modulus.
------------------------------------------------------------------------

value-divw-euclid : (n : ℕ) (w : Word)
                  → value w ≡ suc n · value (divw (suc n) w) + modw (suc n) w
value-divw-euclid n w =
    fst (snd (snd (divmodΣ n w)))
  ∙ cong (suc n · value (fst (divmodΣ n w)) +_) (snd (snd (snd (divmodΣ n w))))

value-divw-euclid' : (n : ℕ) (w : Word)
                   → value w ≡ suc n · value (divw (suc n) w) + remw (suc n) w
value-divw-euclid' n w = fst (snd (snd (divmodΣ n w)))

------------------------------------------------------------------------
-- 5.  The same statement in the library's quotient form, by uniqueness
--     of Euclidean division (cancellation, not a second algorithm).
------------------------------------------------------------------------

value-divw : (n : ℕ) (w : Word) → value (divw n w) ≡ quotient (value w) / n
value-divw zero    w = refl
value-divw (suc n) w = inj-sm· {m = n} step
  where
    Q Q' R : ℕ
    Q  = value (divw (suc n) w)
    Q' = quotient (value w) / suc n
    R  = modw (suc n) w

    e1 : value w ≡ suc n · Q + R
    e1 = value-divw-euclid n w

    e2 : R + suc n · Q' ≡ value w
    e2 = cong (_+ suc n · Q') (value-modw (suc n) w)
       ∙ ≡remainder+quotient (suc n) (value w)

    step : suc n · Q ≡ suc n · Q'
    step = inj-+m (sym e1 ∙ sym e2 ∙ +-comm R (suc n · Q'))

-- Divisibility read off the quotient, for a positive modulus.
divw-exact→∣ : (n : ℕ) (w : Word) → modw (suc n) w ≡ 0 → (suc n) ∣ value w
divw-exact→∣ n w h = ∣ value (divw (suc n) w) , q ∣₁
  where
    q : value (divw (suc n) w) · suc n ≡ value w
    q = ·-comm (value (divw (suc n) w)) (suc n)
      ∙ sym (+-zero (suc n · value (divw (suc n) w)))
      ∙ cong (suc n · value (divw (suc n) w) +_) (sym h)
      ∙ sym (value-divw-euclid n w)

------------------------------------------------------------------------
-- 6.  Canonicity.  The quotient word is NOT canonical in general; the
--     length law below is exactly why.  What is canonical is its trim.
------------------------------------------------------------------------

-- The quotient occupies one digit position per input digit.
divw-length : (n : ℕ) (w : Word) → length (divw (suc n) w) ≡ length w
divw-length n []      = refl
divw-length n (d ∷ w) = cong suc (divw-length n w)

-- Drop leading zeros (= trailing entries, little-endian).
-- The list argument is split first so that `trimCons d (e ∷ v)` reduces
-- without knowing d; the digit is only inspected at the top position.
trimCons : Digit → Word → Word
trimCons d           (e ∷ v) = d ∷ e ∷ v
trimCons (zero  , _) []      = []
trimCons (suc j , p) []      = (suc j , p) ∷ []

trimw : Word → Word
trimw []      = []
trimw (d ∷ w) = trimCons d (trimw w)

value-trimCons : (d : Digit) (u : Word)
               → value (trimCons d u) ≡ toℕ d + b · value u
value-trimCons d           (e ∷ v) = refl
value-trimCons (zero  , _) []      = 0≡m·0 b
value-trimCons (suc j , p) []      = refl

canonical-trimCons : (d : Digit) (u : Word)
                   → Canonical u → Canonical (trimCons d u)
canonical-trimCons d           (e ∷ v) c = c
canonical-trimCons (zero  , _) []      c = tt
canonical-trimCons (suc j , p) []      c = suc-≤-suc zero-≤

value-trimw : (w : Word) → value (trimw w) ≡ value w
value-trimw []      = refl
value-trimw (d ∷ w) =
  value-trimCons d (trimw w) ∙ cong (λ z → toℕ d + b · z) (value-trimw w)

canonical-trimw : (w : Word) → Canonical (trimw w)
canonical-trimw []      = tt
canonical-trimw (d ∷ w) = canonical-trimCons d (trimw w) (canonical-trimw w)

-- The trim is a normalisation, not a second algorithm: it is the
-- identity on words that were already canonical.
trimw-canonical : (w : Word) → Canonical w → trimw w ≡ w
trimw-canonical w c = value-inj (trimw w) w (canonical-trimw w) c (value-trimw w)

------------------------------------------------------------------------
-- 7.  Division on the canonical-word presentation.
------------------------------------------------------------------------

divTrim : ℕ → Word → Word
divTrim n w = trimw (divw n w)

canonical-divTrim : (n : ℕ) (w : Word) → Canonical (divTrim n w)
canonical-divTrim n w = canonical-trimw (divw n w)

value-divTrim : (n : ℕ) (w : Word) → value (divTrim n w) ≡ quotient (value w) / n
value-divTrim n w = value-trimw (divw n w) ∙ value-divw n w

-- the Euclidean identity survives the trim
value-divTrim-euclid : (n : ℕ) (w : Word)
                     → value w ≡ suc n · value (divTrim (suc n) w) + modw (suc n) w
value-divTrim-euclid n w =
    value-divw-euclid n w
  ∙ cong (λ z → suc n · z + modw (suc n) w) (sym (value-trimw (divw (suc n) w)))

divC : ℕ → CanWord → CanWord
divC n (w , _) = divTrim n w , canonical-divTrim n w

valueC-divC : (n : ℕ) (x : CanWord)
            → valueC (divC n x) ≡ quotient (valueC x) / n
valueC-divC n (w , _) = value-divTrim n w

------------------------------------------------------------------------
-- 8.  THE TRANSPORT STATEMENT for division by a fixed positive modulus.
--     Same three lines as `Transport.transport-+-is-⊕` and
--     `TransportMul.transport-·-is-⊗`; the only input is the value law.
------------------------------------------------------------------------

digitsC-div : (n m : ℕ) → digitsC (quotient m / suc n) ≡ divC (suc n) (digitsC m)
digitsC-div n m = valueC-inj _ _
  ( value-digits (quotient m / suc n)
  ∙ cong (λ z → quotient z / suc n) (sym (value-digits m))
  ∙ sym (valueC-divC (suc n) (digitsC m)) )

transport-div-is-divC : (n : ℕ) →
  transport (λ i → ℕ≡CanWord i → ℕ≡CanWord i) (λ m → quotient m / suc n)
    ≡ divC (suc n)
transport-div-is-divC n = funExt (λ x →
    transportUAop₁ ℕ≃CanWord (λ m → quotient m / suc n) x
  ∙ digitsC-div n (valueC x)
  ∙ cong (divC (suc n)) (retr x))
  where
    retr : (x : CanWord) → digitsC (valueC x) ≡ x
    retr (w , c) = Σ≡Prop isPropCanonical (digits-value w c)

-- The usable uniqueness boundary, as for `_⊗_`: any digit algorithm
-- whose value law is division by suc n IS this one, on canonical words.
value-law→division-path :
  (n : ℕ) (δ : CanWord → CanWord) →
  ((x : CanWord) → valueC (δ x) ≡ quotient (valueC x) / suc n) →
  δ ≡ divC (suc n)
value-law→division-path n δ h = funExt (λ x →
  valueC-inj (δ x) (divC (suc n) x) (h x ∙ sym (valueC-divC (suc n) x)))

------------------------------------------------------------------------
-- 9.  Cost: one step per digit, and the same step count as the residue
--     automaton of `TransportDiv`.
------------------------------------------------------------------------

divSteps : Word → ℕ
divSteps []      = 1
divSteps (d ∷ w) = suc (divSteps w)

divSteps-is-length : (w : Word) → divSteps w ≡ suc (length w)
divSteps-is-length []      = refl
divSteps-is-length (d ∷ w) = cong suc (divSteps-is-length w)

-- The quotient automaton is the residue automaton with an output tape:
-- same pass, same count.
divSteps-is-steps : (w : Word) → divSteps w ≡ steps w
divSteps-is-steps w = divSteps-is-length w ∙ sym (steps-is-length w)

-- and the output is as long as the input (§6), so the step count is
-- also one more than the length of the quotient.
divSteps-output : (n : ℕ) (w : Word)
                → divSteps w ≡ suc (length (divw (suc n) w))
divSteps-output n w = divSteps-is-length w ∙ cong suc (sym (divw-length n w))
