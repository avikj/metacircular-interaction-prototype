{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheRoundTripsCloseSoDecisionAndPredicateAreEquivalentTypes
--
-- THE ABSENCE CLOSED.  `TheTextPredicateIsUniqueSoExistsCarriesNoChoice`
-- says, in its SYĀT paragraph:
--
--   "The ROUND TRIP is not proved: `predicateGivesDecision ∘
--    decisionGivesPredicate` is not shown to be the identity, which
--    would need `Dec` to be a proposition and hence the same hypothesis
--    again."
--
-- Both maps are from `ATextPredicateExistsExactlyWhenTheSemanticProperty
-- IsDecidable` §2, abbreviated here as
--
--   Decision  = (t : Text) → Dec (Outside (denotes t))
--   Predicate = Σ[ p ∈ (Text → Bool) ] Correct Text Object denotes Outside p
--   toPredicate = decisionGivesPredicate   : Decision → Predicate
--   toDecision  = predicateGivesDecision   : Predicate → Decision
--
-- and the hypothesis named is that module's §2 one,
-- `po : (o : Object) → isProp (Outside o)`.
--
-- WHAT IS PROVED
--
--   Under `po` (§4):
--     decisionRoundTripByProp   toDecision (toPredicate d) ≡ d
--     predicateRoundTrip        toPredicate (toDecision P) ≡ P
--     decisionIsoPredicate      Iso Decision Predicate
--     decisionEquivPredicate    Decision ≃ Predicate   (via isoToEquiv)
--     decisionEquivPredicateByProp
--                               the same, via propBiimpl→Equiv, both
--                               sides being propositions (isPropDec
--                               pointwise; theTextPredicateIsUnique)
--
--   With NO hypothesis on `Outside` (§2, §3):
--     decisionRoundTrip         toDecision (toPredicate d) ≡ d
--                               — so the audit's "would need `Dec` to be
--                               a proposition" was too pessimistic for
--                               THIS direction: the `no` case needs only
--                               `isProp¬`, and the `yes` case reduces
--                               once `d t` is abstracted, the one
--                               residual (`correct t | d t` inside
--                               `go`'s closure) being discharged by
--                               `predicateWitnessAtYes` with the
--                               inspect idiom
--     predicateRoundTripFst     toPredicate (toDecision P) .fst ≡ P .fst
--                               — the Boolean predicate itself
--                               round-trips freely
--
--   Conditionally (§3b, module `GivenTheWitnessLemma`):
--     predicateRoundTripFree, decisionIsoPredicateFree,
--     decisionEquivPredicateFree — the full hypothesis-free round trip,
--     `Iso` and equivalence, from ONE extra lemma taken as a module
--     parameter (not a postulate):
--
--       decisionWitnessAtTrue :
--         (P : Predicate) (t : Text) (e : P .fst t ≡ true)
--         → toDecision P t ≡ yes (P .snd t .snd e)
--
-- WHAT IS NOT PROVED, EXACTLY.  `decisionWitnessAtTrue` itself, without
-- `po`.  It holds by reduction inside the audited module (`go true e =
-- yes (c t .snd e)`), but `go` is local to the clause
-- `predicateGivesDecision (p , c) t`, closes over `p`, and has `p t ≡ b`
-- as the type of its own second argument; so from outside, for a
-- general `P`, no with-abstraction of `p t` is well-typed (Agda reports
-- an ill-typed with-abstraction, `w != p t`), and case analysis on the
-- VALUE `toDecision P t` yields `yes o` with `o` opaque.  What the
-- `Correct` data forces about the value is exactly `decisionAtTrue`
-- (some witness) and `decisionAtFalse` (the given refutation, by
-- `isProp¬`), and those suffice for everything else above.  Under `po`
-- the lemma is immediate (`isPropDec`), which is why §4 needs no such
-- parameter.  Nothing here examines `Outside`, which remains a
-- parameter, and nothing is empirical.
--
-- CHECKED: Agda 2.8.0 + cubical v0.9, --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheRoundTripsCloseSoDecisionAndPredicateAreEquivalentTypes where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; propBiimpl→Equiv)
open import Cubical.Functions.FunExtEquiv using (funExtDep)
open import Cubical.Data.Bool using (Bool ; true ; false ; isSetBool ; true≢false ; false≢true)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (Dec ; yes ; no ; ¬_)
open import Cubical.Relation.Nullary.Properties using (isPropDec ; isProp¬)

open import ATextPredicateExistsExactlyWhenTheSemanticPropertyIsDecidable
  using (Correct ; decisionGivesPredicate ; predicateGivesDecision)
open import TheTextPredicateIsUniqueSoExistsCarriesNoChoice
  using (theTextPredicateIsUnique)

------------------------------------------------------------------------
-- 0.  Small kit: `yes` is injective, `no` is never `yes`, and the
--     inspect idiom (a `with` that remembers what it matched on)
------------------------------------------------------------------------

private
  yesInj : {A : Type} {a b : A} → yes a ≡ yes b → a ≡ b
  yesInj {a = a} e = cong pick e
    where
      pick : Dec _ → _
      pick (yes x) = x
      pick (no _)  = a

  no≢yes : {A : Type} {n : ¬ A} {a : A} → no n ≡ yes a → ⊥
  no≢yes e = false≢true (cong isYes e)
    where
      isYes : Dec _ → Bool
      isYes (yes _) = true
      isYes (no _)  = false

  record Seen {A : Type} {B : A → Type}
              (f : (x : A) → B x) (x : A) (y : B x) : Type where
    constructor seen
    field eq : f x ≡ y

  inspect : {A : Type} {B : A → Type} (f : (x : A) → B x) (x : A)
          → Seen f x (f x)
  inspect f x = seen refl

module _
  (Text Object : Type)
  (denotes : Text → Object)
  (Outside : Object → Type)
  where

  Decision : Type
  Decision = (t : Text) → Dec (Outside (denotes t))

  Predicate : Type
  Predicate = Σ[ p ∈ (Text → Bool) ] Correct Text Object denotes Outside p

  toPredicate : Decision → Predicate
  toPredicate = decisionGivesPredicate Text Object denotes Outside

  toDecision : Predicate → Decision
  toDecision = predicateGivesDecision Text Object denotes Outside

  ------------------------------------------------------------------
  -- 1.  What each map does at a text.  For `toPredicate` this is read
  --     off its clauses by abstracting `d t`.  For `toDecision` the
  --     clauses are NOT reachable (see the header), so only what the
  --     `Correct` data forces about its VALUE is available.
  ------------------------------------------------------------------

  predicateAtYes :
    (d : Decision) (t : Text) (o : Outside (denotes t))
    → d t ≡ yes o → toPredicate d .fst t ≡ true
  predicateAtYes d t o e with d t
  ... | yes _ = refl
  ... | no  _ = ⊥.rec (no≢yes e)

  predicateWitnessAtYes :
    (d : Decision) (t : Text) (o : Outside (denotes t))
    → d t ≡ yes o
    → (e : toPredicate d .fst t ≡ true) → toPredicate d .snd t .snd e ≡ o
  predicateWitnessAtYes d t o e₀ e with d t
  ... | yes _ = yesInj e₀
  ... | no  _ = ⊥.rec (no≢yes e₀)

  predicateAtNo :
    (d : Decision) (t : Text) (n : ¬ Outside (denotes t))
    → d t ≡ no n → toPredicate d .fst t ≡ false
  predicateAtNo d t n e with d t
  ... | yes _ = ⊥.rec (no≢yes (sym e))
  ... | no  _ = refl

  decisionAtTrue :
    (P : Predicate) (t : Text) → P .fst t ≡ true
    → Σ[ o ∈ Outside (denotes t) ] toDecision P t ≡ yes o
  decisionAtTrue P t e = byValue (toDecision P t) refl
    where
      byValue : (x : Dec (Outside (denotes t))) → toDecision P t ≡ x
              → Σ[ o ∈ Outside (denotes t) ] toDecision P t ≡ yes o
      byValue (yes o) q = o , q
      byValue (no n)  q = ⊥.rec (n (P .snd t .snd e))

  decisionAtFalse :
    (P : Predicate) (t : Text) → P .fst t ≡ false
    → (n : ¬ Outside (denotes t)) → toDecision P t ≡ no n
  decisionAtFalse P t e n = byValue (toDecision P t) refl
    where
      byValue : (x : Dec (Outside (denotes t))) → toDecision P t ≡ x
              → toDecision P t ≡ no n
      byValue (yes o) q = ⊥.rec (true≢false (sym (P .snd t .fst o) ∙ e))
      byValue (no n') q = q ∙ cong no (isProp¬ _ n' n)

  ------------------------------------------------------------------
  -- 2.  The decision-side round trip, with NO hypothesis on `Outside`
  ------------------------------------------------------------------

  decisionRoundTrip : (d : Decision) → toDecision (toPredicate d) ≡ d
  decisionRoundTrip d = funExt pointwise
    where
      pointwise : (t : Text) → toDecision (toPredicate d) t ≡ d t
      pointwise t with d t | inspect d t
      ... | yes o | seen e = cong yes (predicateWitnessAtYes d t o e _)
      ... | no  n | seen _ = cong no (isProp¬ _ _ n)

  ------------------------------------------------------------------
  -- 3.  The predicate-side round trip on the BOOLEAN component, with
  --     NO hypothesis on `Outside`
  ------------------------------------------------------------------

  predicateRoundTripFst :
    (P : Predicate) → toPredicate (toDecision P) .fst ≡ P .fst
  predicateRoundTripFst P = funExt (λ t → byBool t (P .fst t) refl)
    where
      byBool : (t : Text) (b : Bool) → P .fst t ≡ b
             → toPredicate (toDecision P) .fst t ≡ P .fst t
      byBool t true  e =
        predicateAtYes (toDecision P) t
          (decisionAtTrue P t e .fst) (decisionAtTrue P t e .snd)
        ∙ sym e
      byBool t false e =
        predicateAtNo (toDecision P) t n (decisionAtFalse P t e n) ∙ sym e
        where
          n : ¬ Outside (denotes t)
          n o = true≢false (sym (P .snd t .fst o) ∙ e)

  ------------------------------------------------------------------
  -- 3b. The ONE lemma that is missing for the full predicate-side
  --     round trip without any hypothesis, taken as a module parameter
  --     so that its exact shape is on record.  It is true by reduction
  --     inside the audited module (`go true e = yes (c t .snd e)`) but
  --     cannot be reached from outside: `go` is local to the clause
  --     `predicateGivesDecision (p , c) t`, closes over `p`, and has
  --     `p t ≡ b` as the type of its own argument, so no
  --     with-abstraction of `p t` is well-typed for a general `P`.
  ------------------------------------------------------------------

  module GivenTheWitnessLemma
    (decisionWitnessAtTrue :
      (P : Predicate) (t : Text) (e : P .fst t ≡ true)
      → toDecision P t ≡ yes (P .snd t .snd e))
    where

    predicateRoundTripFree :
      (P : Predicate) → toPredicate (toDecision P) ≡ P
    predicateRoundTripFree P =
      ΣPathP (predicateRoundTripFst P , λ i t → part1 t i , part2 t i)
      where
        Q = toPredicate (toDecision P)

        firstComp : (t : Text) → Q .fst t ≡ P .fst t
        firstComp t i = predicateRoundTripFst P i t

        part1 : (t : Text)
              → PathP (λ i → Outside (denotes t) → firstComp t i ≡ true)
                      (Q .snd t .fst) (P .snd t .fst)
        part1 t =
          isProp→PathP
            (λ i → isPropΠ (λ _ → isSetBool (firstComp t i) true)) _ _

        agree : (t : Text) (e₀ : Q .fst t ≡ true) (e₁ : P .fst t ≡ true)
              → Q .snd t .snd e₀ ≡ P .snd t .snd e₁
        agree t e₀ e₁ =
          predicateWitnessAtYes (toDecision P) t (P .snd t .snd e₁)
            (decisionWitnessAtTrue P t e₁) e₀

        part2 : (t : Text)
              → PathP (λ i → firstComp t i ≡ true → Outside (denotes t))
                      (Q .snd t .snd) (P .snd t .snd)
        part2 t = funExtDep (λ {e₀} {e₁} _ → agree t e₀ e₁)

    decisionIsoPredicateFree : Iso Decision Predicate
    decisionIsoPredicateFree =
      iso toPredicate toDecision predicateRoundTripFree decisionRoundTrip

    decisionEquivPredicateFree : Decision ≃ Predicate
    decisionEquivPredicateFree = isoToEquiv decisionIsoPredicateFree

  ------------------------------------------------------------------
  -- 4.  Under §2's pointwise-prop hypothesis: both round trips, the
  --     `Iso`, and the equivalence
  ------------------------------------------------------------------

  module _ (po : (o : Object) → isProp (Outside o)) where

    isPropDecision : isProp Decision
    isPropDecision = isPropΠ (λ t → isPropDec (po (denotes t)))

    isPropPredicate : isProp Predicate
    isPropPredicate = theTextPredicateIsUnique Text Object denotes Outside po

    decisionRoundTripByProp :
      (d : Decision) → toDecision (toPredicate d) ≡ d
    decisionRoundTripByProp d =
      funExt (λ t → isPropDec (po (denotes t)) _ (d t))

    predicateRoundTrip :
      (P : Predicate) → toPredicate (toDecision P) ≡ P
    predicateRoundTrip P = isPropPredicate _ P

    decisionIsoPredicate : Iso Decision Predicate
    decisionIsoPredicate =
      iso toPredicate toDecision predicateRoundTrip decisionRoundTrip

    decisionEquivPredicate : Decision ≃ Predicate
    decisionEquivPredicate = isoToEquiv decisionIsoPredicate

    decisionEquivPredicateByProp : Decision ≃ Predicate
    decisionEquivPredicateByProp =
      propBiimpl→Equiv isPropDecision isPropPredicate toPredicate toDecision
