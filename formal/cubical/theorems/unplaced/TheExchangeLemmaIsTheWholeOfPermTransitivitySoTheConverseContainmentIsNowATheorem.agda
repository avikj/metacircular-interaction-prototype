{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheExchangeLemmaIsTheWholeOfPermTransitivitySoTheConverseContainmentIsNowATheorem
--
-- ────────────────────────────────────────────────────────────────────
-- THE CONTAINMENT, BOTH DIRECTIONS.  `Perm` is contained in `≈`; the converse
-- reduces to one hypothesis, `PermTransitivity`, which needs an exchange lemma
-- moving an `Insert` past a `Perm`.  It is written here, and the containment
-- is a theorem in both directions.
--
-- WHAT IS PROVED
--
--   insertSwap    two insertions commute: `Insert x ds us` and
--                 `Insert y us cs` give a `ws` with `Insert y ds ws`
--                 and `Insert x ws cs`.  **This is the whole content.**
--                 Induction on the SECOND insertion, casing the first;
--                 three clauses, and the middle one is where the two
--                 insertions cross — `here` against `there k` returns
--                 `k` itself with `here`, i.e. the crossing is what
--                 makes the pair swap rather than nest.
--   insertPerm    an insertion moves past a permutation:
--                 `Insert x as bs → Perm bs cs`
--                 → `Σ ds (Perm as ds × Insert x ds cs)`.
--                 Inverting `Perm` is free — `pcons` is its only
--                 non-nil constructor — so this is `insertSwap` plus
--                 bookkeeping.
--   permTransitivity
--                 hence transitivity, by induction on the first
--                 derivation alone.
--   theConverseContainment
--                 `xs ≈ ys → Perm xs ys`, by discharging the
--                 hypothesis.
--   permutationAndAdjacencyAgree
--                 both directions in one statement, with
--                 `permIsAnAdjacentChain` as the other half.
--
-- **WHAT THE PROOF SAYS ABOUT THE TWO REPRESENTATIONS.**  `≈` has
-- transitivity as a CONSTRUCTOR while `Perm` builds it into the shape
-- of `pcons`, so the containment turns on exactly the constructor they
-- disagree about.  The cost of
-- `Perm`'s choice is **precisely `insertSwap`** — a commutation of two
-- insertions, three clauses, no arithmetic, no decidable equality, and
-- no assumption whatever on the element type.  Nothing about
-- permutations was at stake; the price of composing was.
--
-- **THIS MODULE IS NOT WARNING-FREE, AND THE WARNING IS THE SAME PRICE
-- AGAIN.**  Agda emits TEN clause warnings, on `insertSwap`, `insertPerm`
-- and `permTransitivity`:
--
--   "This clause uses pattern-matching features that are not yet
--    supported by Cubical Agda, the function to which it belongs will
--    not compute when applied to transports.
--    Reason: It relies on injectivity of the data constructor _∷_"
--
-- `Perm` and `Insert` are INDEXED BY LISTS, so inverting them unifies
-- `x ∷ xs` patterns, and cubical Agda does not yet support constructor
-- injectivity in that position.  **The propositions below are proved —
-- `--safe`, no postulates, no holes — and the functions simply do not
-- COMPUTE on transports.**
-- `Perm`'s formulation costs
-- `insertSwap` mathematically, and costs transport-computability
-- mechanically.
------------------------------------------------------------------------

module TheExchangeLemmaIsTheWholeOfPermTransitivitySoTheConverseContainmentIsNowATheorem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)

open import TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
  using ( Insert ; here ; there ; Perm ; pnil ; pcons ; _≈_
        ; permIsAnAdjacentChain )
open import TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree
  using ( PermTransitivity ; permTransitivityGivesTheConverse )

module _ {A : Type} where

  ------------------------------------------------------------------
  -- 1.  Two insertions commute — the whole content
  ------------------------------------------------------------------

  insertSwap :
    {x y : A} {ds us cs : List A}
    → Insert x ds us → Insert y us cs
    → Σ[ ws ∈ List A ] (Insert y ds ws × Insert x ws cs)
  insertSwap {y = y} {ds = ds} j here      = (y ∷ ds) , here , there j
  insertSwap here            (there k)     = _ , k , here
  insertSwap (there j)       (there k)     with insertSwap j k
  ... | ws , iy , ix                       = _ , there iy , there ix

  ------------------------------------------------------------------
  -- 2.  …so an insertion moves past a permutation
  ------------------------------------------------------------------

  insertPerm :
    {x : A} {as bs cs : List A}
    → Insert x as bs → Perm bs cs
    → Σ[ ds ∈ List A ] (Perm as ds × Insert x ds cs)
  insertPerm here      (pcons q ins) = _ , q , ins
  insertPerm (there i) (pcons q ins) with insertPerm i q
  ... | ds , pas , ix with insertSwap ix ins
  ...   | ws , iy , ixc = ws , pcons pas iy , ixc

  ------------------------------------------------------------------
  -- 3.  …and transitivity follows by induction on the first alone
  ------------------------------------------------------------------

  permTransitivity : PermTransitivity {A = A}
  permTransitivity pnil        pnil = pnil
  permTransitivity (pcons p i) q with insertPerm i q
  ... | ds , pys , ix = pcons (permTransitivity p pys) ix

  ------------------------------------------------------------------
  -- 4.  The converse containment, and the two directions together
  ------------------------------------------------------------------

  theConverseContainment : {xs ys : List A} → xs ≈ ys → Perm xs ys
  theConverseContainment = permTransitivityGivesTheConverse permTransitivity

  permutationAndAdjacencyAgree :
    {xs ys : List A} → (Perm xs ys → xs ≈ ys) × (xs ≈ ys → Perm xs ys)
  permutationAndAdjacencyAgree =
    permIsAnAdjacentChain , theConverseContainment
