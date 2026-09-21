{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- YonedaEquiv_WeaveIsASetAndThreadYonedaIsAnEquivalence
--
-- Closes the absence stated in `ThreadYoneda` (header, "WHAT IS NOT",
-- and §7):
--
--     The round trips give a bijection, not a `≃`: upgrading needs
--     `isSet (Weave i j)` so that naturality is a proposition and two
--     transformations agreeing pointwise are equal.  That is true
--     (Thread is built from equalities in ℕ, which is a set) and it is
--     not proved here.  Said plainly because "≃" is what T25.A asks for
--     and this is "↔".
--
-- WHAT IS PROVED (all `--safe`, no postulates, no holes):
--
--   * `isSetJewel`  : Jewel is a set (retract of ℕ × ℕ).
--   * `isSetThread` : every `Thread i j` is a set (retract of a sum of
--                     two propositions, namely paths in ℕ).
--   * `isSetWeave`  : every `Weave i j` is a set.  `Weave` is an
--                     indexed inductive family, so its h-level is not
--                     read off by a single library lemma; it is shown
--                     to be a retract of `Σ[ n ∈ ℕ ] Code n i j`, where
--                     `Code n i j` is the type of length-n chains of
--                     threads from i to j, and that type is a set by
--                     `isSetΣ`, `isSet×`, `isProp→isSet`, `isSetℕ`.
--   * `isPropNatural` : the naturality predicate of `ThreadYoneda` is
--                     a proposition (`isPropImplicitΠ2` + `isPropΠ2`
--                     over path types in the set `Weave l j`).
--   * `isSetTransformation`, `isSetNatTrans` : the transformations and
--                     the natural transformations form sets.
--   * `yonedaIso`   : `Iso (Weave i j) (NatTrans i j)` whose maps are
--                     exactly `yonedaTo` / `yonedaFrom` of `ThreadYoneda`
--                     and whose round trips are `yoneda-from-to` (on the
--                     nose) and `yoneda-to-from` (made into a path of
--                     Σ-types by `funExt` twice and `Σ≡Prop
--                     isPropNatural`).
--   * `yonedaEquiv` : `Weave i j ≃ NatTrans i j`, i.e. T25.A's
--                     `Map(x,y) ≃ Nat(y x, y y)` for this net, obtained
--                     by `isoToEquiv`.
--   * `yonedaPath`  : the corresponding path of types, by univalence
--                     (`isoToPath`), so the "≃" is also an "≡".
--
-- WHAT IS NOT.  Nothing in this file adds relations to `Weave`; it is
-- still the free category of `ThreadYoneda` §1, and the other two
-- items of §7 there (relations between the thread families, and the
-- tear) are untouched.  Only the first item of §7 is closed.
------------------------------------------------------------------------

module YonedaEquiv_WeaveIsASetAndThreadYonedaIsAnEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Nat
open import RootedNet
open import ThreadYoneda

------------------------------------------------------------------------
-- §1  Jewel and Thread are sets
------------------------------------------------------------------------

-- A jewel is a pair of naturals; the record has η, so the retraction
-- onto ℕ × ℕ is definitionally split.
isSetJewel : isSet Jewel
isSetJewel = isSetRetract
  (λ j → centre j , radius j)
  (λ p → jewel (fst p) (snd p))
  (λ _ → refl)
  (isSet× isSetℕ isSetℕ)

-- A thread is one of two witnesses, each a path in ℕ.  Paths in a set
-- are propositions, hence sets, and a sum of sets is a set.
ThreadCode : Jewel → Jewel → Type
ThreadCode i j = (trueCentre i ≡ trueCentre j) ⊎ (radius i ≡ radius j)

threadEncode : {i j : Jewel} → Thread i j → ThreadCode i j
threadEncode (sharedCentre e) = inl e
threadEncode (sharedRadius e) = inr e

threadDecode : {i j : Jewel} → ThreadCode i j → Thread i j
threadDecode (inl e) = sharedCentre e
threadDecode (inr e) = sharedRadius e

threadDecodeEncode : {i j : Jewel} (t : Thread i j)
                   → threadDecode (threadEncode t) ≡ t
threadDecodeEncode (sharedCentre e) = refl
threadDecodeEncode (sharedRadius e) = refl

isSetThreadCode : (i j : Jewel) → isSet (ThreadCode i j)
isSetThreadCode i j =
  isSet⊎ (isProp→isSet (isSetℕ _ _)) (isProp→isSet (isSetℕ _ _))

isSetThread : (i j : Jewel) → isSet (Thread i j)
isSetThread i j =
  isSetRetract threadEncode threadDecode threadDecodeEncode (isSetThreadCode i j)

------------------------------------------------------------------------
-- §2  Weave is a set
--
-- `Weave i j` is an indexed family, so it is compared with an
-- unindexed description: a length together with a chain of that many
-- threads, whose intermediate jewels are recorded explicitly.  The
-- length-0 chains from i to j are the identifications `i ≡ j`, which
-- is what lets `idPath : Weave i i` be recovered by transport.
------------------------------------------------------------------------

Code : ℕ → Jewel → Jewel → Type
Code zero    i j = i ≡ j
Code (suc n) i j = Σ[ k ∈ Jewel ] (Thread i k × Code n k j)

isSetCode : (n : ℕ) (i j : Jewel) → isSet (Code n i j)
isSetCode zero    i j = isProp→isSet (isSetJewel i j)
isSetCode (suc n) i j =
  isSetΣ isSetJewel (λ k → isSet× (isSetThread i k) (isSetCode n k j))

WeaveCode : Jewel → Jewel → Type
WeaveCode i j = Σ[ n ∈ ℕ ] Code n i j

isSetWeaveCode : (i j : Jewel) → isSet (WeaveCode i j)
isSetWeaveCode i j = isSetΣ isSetℕ (λ n → isSetCode n i j)

weaveEncode : {i j : Jewel} → Weave i j → WeaveCode i j
weaveEncode idPath    = zero , refl
weaveEncode (_◃_ {j = k} t p) =
  let (n , c) = weaveEncode p in suc n , (k , (t , c))

codeDecode : (n : ℕ) {i j : Jewel} → Code n i j → Weave i j
codeDecode zero    {i} e           = subst (Weave i) e idPath
codeDecode (suc n) (k , (t , c))   = t ◃ codeDecode n c

weaveDecode : {i j : Jewel} → WeaveCode i j → Weave i j
weaveDecode (n , c) = codeDecode n c

weaveDecodeEncode : {i j : Jewel} (p : Weave i j)
                  → weaveDecode (weaveEncode p) ≡ p
weaveDecodeEncode {i} idPath = substRefl {B = Weave i} idPath
weaveDecodeEncode (t ◃ p) = cong (t ◃_) (weaveDecodeEncode p)

isSetWeave : (i j : Jewel) → isSet (Weave i j)
isSetWeave i j =
  isSetRetract weaveEncode weaveDecode weaveDecodeEncode (isSetWeaveCode i j)

------------------------------------------------------------------------
-- §3  Naturality is a proposition; transformations form sets
------------------------------------------------------------------------

isPropNatural : {i j : Jewel} (η : Transformation i j) → isProp (Natural η)
isPropNatural {i} {j} η =
  isPropImplicitΠ2 (λ k l → isPropΠ2 (λ t p → isSetWeave l j _ _))

isSetTransformation : (i j : Jewel) → isSet (Transformation i j)
isSetTransformation i j = isSetΠ2 (λ k _ → isSetWeave k j)

-- The natural transformations `Nat(y i, y j)` of T25.A, as a type.
NatTrans : Jewel → Jewel → Type
NatTrans i j = Σ[ η ∈ Transformation i j ] Natural η

isSetNatTrans : (i j : Jewel) → isSet (NatTrans i j)
isSetNatTrans i j = isSetΣSndProp (isSetTransformation i j) isPropNatural

------------------------------------------------------------------------
-- §4  The upgrade: ↔ becomes ≃
--
-- The maps are those of `ThreadYoneda` §4 unchanged.  The only new
-- content is that the pointwise round trip `yoneda-to-from` becomes an
-- honest path in `NatTrans`: `funExt` twice for the transformation and
-- `Σ≡Prop isPropNatural` to dispose of the naturality component.
------------------------------------------------------------------------

yonedaIso : (i j : Jewel) → Iso (Weave i j) (NatTrans i j)
Iso.fun (yonedaIso i j) t = yonedaTo t , yonedaTo-natural t
Iso.inv (yonedaIso i j) (η , _) = yonedaFrom η
Iso.rightInv (yonedaIso i j) (η , nat) =
  Σ≡Prop isPropNatural (funExt (λ k → funExt (λ p → yoneda-to-from η nat k p)))
Iso.leftInv (yonedaIso i j) t = yoneda-from-to t

-- T25.A for this net:  Map(i,j) ≃ Nat(y i, y j).
yonedaEquiv : (i j : Jewel) → Weave i j ≃ NatTrans i j
yonedaEquiv i j = isoToEquiv (yonedaIso i j)

-- and, by univalence, the two types are identified.
yonedaPath : (i j : Jewel) → Weave i j ≡ NatTrans i j
yonedaPath i j = isoToPath (yonedaIso i j)

-- The forward map of the equivalence is literally `yonedaTo`, and its
-- inverse is literally `yonedaFrom`: nothing was renamed on the way up.
yonedaEquiv-fun : {i j : Jewel} (t : Weave i j)
                → fst (equivFun (yonedaEquiv i j) t) ≡ yonedaTo t
yonedaEquiv-fun t = refl

yonedaEquiv-inv : {i j : Jewel} (η : NatTrans i j)
                → invEq (yonedaEquiv i j) η ≡ yonedaFrom (fst η)
yonedaEquiv-inv η = refl
