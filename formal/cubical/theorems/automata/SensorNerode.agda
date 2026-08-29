{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SensorNerode
--
-- THE WALK'S MINIMAL STATE IS ITS LCM.
--
-- in prose that a family `S` of moduli observes `n` only through
-- `lcm(S)`, and calls the consequence the Nerode form: `S ↦ lcm S` IS
-- the quotient by observational equivalence, so the sensor list is a
-- redundant presentation of one number.  The note's §4 records the
-- whole of §1–§2 as "Not yet Agda".  §1 is now Agda; §2 is not, and the
-- reason is recorded below rather than hidden.
--
-- The proof carries NO ARITHMETIC.  That is not economy, it is the
-- content: `WalkCapacity`'s `IsLCM` is the universal property, and the
-- Nerode theorem is that property applied to one number — the distance
-- `dist a b` — rather than a computation about residues.  This is
-- that note describes it: "cubical v0.5's missing LCM module forced the
-- universal-property `lcm`, whose proof contains no arithmetic at all.
-- The construction hid the content."  Here is what the construction hid.
--
--
-- WHAT IS CHECKED
--
--   §1  `dist`               |a − b|, as `(a ∸ b) + (b ∸ a)`, and
--       `dist-0`             `dist n 0 ≡ n`.
--
--   §2  `Ind`                indistinguishability: every modulus in the
--       `Ind≡CommonMultiple`  family divides the distance.  The pivot of
--                            the whole file is that this is `refl` —
--                            `Ind S a b` IS `CommonMultiple S (dist a b)`
--                            definitionally.  Once seen, both halves of
--                            §3 are immediate, and that is the theorem.
--
--   §3  `ind→lcm`            THE NERODE THEOREM.  For any `L` with
--       `lcm→ind`            `IsLCM S L`:  `Ind S a b  ⟺  L ∣ dist a b`.
--       `nerode`             Forward is the universal property verbatim
--                            (the distance is a common multiple, so `L`
--                            divides it); backward is transitivity of
--                            divisibility along `L`.  Packaged as a path
--                            of types, since both sides are props.
--
--   §4  `same-lcm→same-obs`  COROLLARY (the note's headline): two sensor
--                            families with the same lcm induce the SAME
--                            indistinguishability relation — equal as
--                            types, pointwise, not merely inter-derivable.
--
--   §5  `obs→lcm≡`           MINIMALITY, which the note asserts and does
--       `nerode-unique`      not state: the relation DETERMINES the lcm.
--                            If two families induce the same relation
--                            then their lcms are equal, by testing at
--                            `(L , 0)` and applying antisymmetry of
--                            divisibility.  This is the uniqueness half
--                            of Myhill–Nerode — the minimal state is
--                            unique, not merely minimal — and §4 with §5
--                            together say `lcm` is a bijection from
--                            observational classes to state values.
--
--   §6  `nerode!`             the same three, UNCONDITIONAL, via
--       `same-lcm→same-obs!`  `LCMExists.lcmList-isLCM`.  Added as a
--       `nerode-unique!`      correction against this file: §§3–5 assume
--                             `IsLCM S L`, which is how the walk lane read
--                             *before* `LCMExists` closed that gap — I
--                             wrote them without having read the closure
--                             and re-inherited a discharged hypothesis.
--
--
-- SYĀT — THE CLAIM, EXACTLY
--
--  * **The residue bridge is not proved here.**  The note writes the
--    observation as `profile_S(n) = (n mod m)_{m∈S}`, and this file
--    works with `m ∣ dist a b` instead.  These agree — that is the
--    standard characterisation of congruence — but `_mod_` does not
--    appear below, so a reader should take §3 as a theorem about
--    divisibility of the distance, and the identification with equal
--    residues as an unchecked (if entirely standard) step.  `Cubical.
--    Data.Nat.Mod` has the machinery (`≡remainder+quotient`,
--    `mod+mod≡mod`); wiring it up is a separate, purely arithmetic job,
--    and doing it here would have put arithmetic into a file whose point
--    is that there is none.
--
--  * **§2 of the note — the divisor lattice — is NOT here.**  That the
--    reachable states at frontier `k` are exactly the divisors of
--    `cap k` needs the (⊇) direction, i.e. that every divisor of
--    `cap k` is `lcm` of a family of addresses in `[1,k]`.  The note's
--    proof factors the divisor into prime powers `p^{b_p} ≤ p^{a_p} ≤ k`.
--    That is genuinely arithmetic — it needs existence of the prime
--    factorisation and the `p`-adic valuation, neither of which is in
--    cubical v0.5 — so it is a real piece of work and not an oversight.
--    §3 below is independent of it.
--
--  * Nothing here is about which families are ADMISSIBLE.  `WalkCapacity`
--    owns the frontier condition; this file is about what a family sees,
--    for an arbitrary family, and never mentions `range1`.
--
--  * Not novel mathematics.  "Congruence modulo every element of S is
--    congruence modulo lcm S" is elementary and old.  What is new is
--    that it is now connected to this lane's `IsLCM` and to the corpus's
--    Myhill–Nerode material, with the minimality half stated.
------------------------------------------------------------------------

module SensorNerode where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isProp×)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; +-zero)
open import Cubical.Data.Nat.Divisibility
  using (_∣_ ; ∣-trans ; antisym∣ ; isProp∣)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)

open import WalkCapacity using (All ; CommonMultiple ; IsLCM)
open import LCMExists   using (lcmList ; lcmList-isLCM)

------------------------------------------------------------------------
-- 1.  The distance.
--
-- `dist a b` is |a − b| written without leaving ℕ: one of the two
-- truncated subtractions is zero, and the sum picks out the other.
------------------------------------------------------------------------

dist : ℕ → ℕ → ℕ
dist a b = (a ∸ b) + (b ∸ a)

zero∸ : (n : ℕ) → 0 ∸ n ≡ 0
zero∸ zero    = refl
zero∸ (suc n) = refl

dist-0 : (n : ℕ) → dist n 0 ≡ n
dist-0 n = cong (n +_) (zero∸ n) ∙ +-zero n

------------------------------------------------------------------------
-- 2.  Indistinguishability, and the pivot.
--
-- `a` and `b` are indistinguishable to the family `S` when every
-- modulus in `S` divides their distance.  The next line is the whole
-- mechanism of this file: that relation is, definitionally, the
-- statement that the distance is a COMMON MULTIPLE of `S`.  So the
-- question "what does S see?" is already, before any theorem, a question
-- about common multiples — and `IsLCM` answers questions about common
-- multiples by construction.
------------------------------------------------------------------------

Ind : List ℕ → ℕ → ℕ → Type
Ind S a b = All (λ m → m ∣ dist a b) S

Ind≡CommonMultiple : (S : List ℕ) (a b : ℕ)
                   → Ind S a b ≡ CommonMultiple S (dist a b)
Ind≡CommonMultiple S a b = refl

isPropInd : (S : List ℕ) (a b : ℕ) → isProp (Ind S a b)
isPropInd []      a b = isPropUnit
isPropInd (m ∷ S) a b = isProp× isProp∣ (isPropInd S a b)

-- Divisibility propagates through a family along a common multiple.
allTrans : (xs : List ℕ) {L d : ℕ} → All (_∣ L) xs → L ∣ d → All (_∣ d) xs
allTrans []       _        _ = tt
allTrans (x ∷ xs) (p , ps) q = ∣-trans p q , allTrans xs ps q

------------------------------------------------------------------------
-- 3.  THE NERODE THEOREM.
--
-- Everything a family of moduli can distinguish is decided by one
-- number.  Forward: the distance is a common multiple of `S`, so the
-- lcm divides it — this is `IsLCM`'s second component applied and
-- nothing else.  Backward: each modulus divides the lcm, which divides
-- the distance.
------------------------------------------------------------------------

ind→lcm : {S : List ℕ} {L : ℕ} → IsLCM S L
        → (a b : ℕ) → Ind S a b → L ∣ dist a b
ind→lcm isL a b ind = isL .snd (dist a b) ind

lcm→ind : {S : List ℕ} {L : ℕ} → IsLCM S L
        → (a b : ℕ) → L ∣ dist a b → Ind S a b
lcm→ind {S = S} isL a b q = allTrans S (isL .fst) q

-- As an equality of types: both sides are propositions.
nerode : {S : List ℕ} {L : ℕ} → IsLCM S L
       → (a b : ℕ) → Ind S a b ≡ (L ∣ dist a b)
nerode {S = S} isL a b =
  hPropExt (isPropInd S a b) isProp∣ (ind→lcm isL a b) (lcm→ind isL a b)
  where
  open import Cubical.Foundations.Univalence using (hPropExt)

------------------------------------------------------------------------
-- 4.  Two families with the same lcm see the same thing.
--
-- The note's headline, and now an equality of relations rather than a
-- pair of implications.  Nothing about the two families is compared;
-- everything factors through the single number they share.
------------------------------------------------------------------------

same-lcm→same-obs :
  {S T : List ℕ} {L : ℕ} → IsLCM S L → IsLCM T L
  → (a b : ℕ) → Ind S a b ≡ Ind T a b
same-lcm→same-obs isS isT a b =
  nerode isS a b ∙ sym (nerode isT a b)

------------------------------------------------------------------------
-- 5.  MINIMALITY: the relation determines the lcm.
--
-- §4 says the state determines the behaviour.  This says the behaviour
-- determines the state, which is the half that makes `lcm` the MINIMAL
-- realization rather than merely a sufficient one.  The test point is
-- `(L , 0)`: a family's own lcm is always indistinguishable from zero
-- to it, and any family that agrees must therefore have an lcm dividing
-- it.  Antisymmetry of divisibility closes both directions.
------------------------------------------------------------------------

-- A family cannot tell its own lcm from 0.
self-blind : {S : List ℕ} {L : ℕ} → IsLCM S L → Ind S L 0
self-blind {S = S} {L = L} isL =
  subst (CommonMultiple S) (sym (dist-0 L)) (isL .fst)

obs→lcm≡ :
  {S T : List ℕ} {L L′ : ℕ} → IsLCM S L → IsLCM T L′
  → ((a b : ℕ) → Ind S a b → Ind T a b)
  → ((a b : ℕ) → Ind T a b → Ind S a b)
  → L ≡ L′
obs→lcm≡ {S = S} {T = T} {L = L} {L′ = L′} isS isT S→T T→S =
  antisym∣ L∣L′ L′∣L
  where
  -- T cannot tell L from 0, so T's lcm divides L.
  L′∣L : L′ ∣ L
  L′∣L = isT .snd L (subst (CommonMultiple T) (dist-0 L) (S→T L 0 (self-blind isS)))

  -- ... and symmetrically.
  L∣L′ : L ∣ L′
  L∣L′ = isS .snd L′ (subst (CommonMultiple S) (dist-0 L′) (T→S L′ 0 (self-blind isT)))

-- The two halves together: `lcm` is a bijection from observational
-- behaviour to state value.  Same behaviour ⟺ same state.
nerode-unique :
  {S T : List ℕ} {L L′ : ℕ} → IsLCM S L → IsLCM T L′
  → ((a b : ℕ) → Ind S a b ≡ Ind T a b)
  → L ≡ L′
nerode-unique isS isT h =
  obs→lcm≡ isS isT
    (λ a b x → transport (h a b) x)
    (λ a b x → transport (sym (h a b)) x)

------------------------------------------------------------------------
-- 6.  UNCONDITIONAL FORMS.
--
-- CORRECTION, same day, and it is against this file.  §§3–5 above take
-- `IsLCM S L` as a HYPOTHESIS, which is how the whole walk lane was
-- phrased *until* `LCMExists` closed exactly that gap:
-- `lcmList-isLCM : (xs : List ℕ) → IsLCM xs (lcmList xs)`, no hypothesis,
-- no positivity restriction.  `WALK_FORCING_LAW.md` records the closure
-- under the heading "The conditionality gap is CLOSED (same day)"; I
-- wrote §§3–5 without having read it, and so re-inherited a conditionality
-- the lane had already discharged.
--
-- Nothing above is wrong and nothing above is deleted — the hypothetical
-- forms are the general statements and are what a caller with its own
-- lcm witness wants.  What follows is the instantiation, which is what
-- the walk actually has.
------------------------------------------------------------------------

-- The Nerode theorem, with the lcm supplied rather than assumed.
nerode! : (S : List ℕ) (a b : ℕ) → Ind S a b ≡ (lcmList S ∣ dist a b)
nerode! S = nerode (lcmList-isLCM S)

-- Two families with the same lcm see the same thing …
same-lcm→same-obs! : (S T : List ℕ) → lcmList S ≡ lcmList T
                   → (a b : ℕ) → Ind S a b ≡ Ind T a b
same-lcm→same-obs! S T p a b =
  nerode! S a b ∙ cong (_∣ dist a b) p ∙ sym (nerode! T a b)

-- … and conversely the relation determines the lcm.  Together: `lcmList`
-- is a bijection from observational behaviour to state value, with no
-- hypothesis anywhere.
nerode-unique! : (S T : List ℕ)
               → ((a b : ℕ) → Ind S a b ≡ Ind T a b)
               → lcmList S ≡ lcmList T
nerode-unique! S T = nerode-unique (lcmList-isLCM S) (lcmList-isLCM T)
