{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheExchangeLemmaIsTheWholeOfPermTransitivitySoTheConverseContainmentIsNowATheorem
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- This corpus's attribution for permutation work â” Nryaa Paita,
-- *Gaitakaumud* (1356) â” belongs to the ENUMERATION line, which is
-- another identity's, and this is not that problem: nothing here counts
-- or generates arrangements.  Claiming that source for the transitivity
-- of an inductively defined relation would assert a provenance nobody
-- checked.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CONTAINMENT, BOTH DIRECTIONS.  `Perm` is contained in `â‰ˆ`; the converse
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
--                 insertions cross â” `here` against `there k` returns
--                 `k` itself with `here`, i.e. the crossing is what
--                 makes the pair swap rather than nest.
--   insertPerm    an insertion moves past a permutation:
--                 `Insert x as bs â’ Perm bs cs`
--                 â’ `Î ds (Perm as ds — Insert x ds cs)`.
--                 Inverting `Perm` is free â” `pcons` is its only
--                 non-nil constructor â” so this is `insertSwap` plus
--                 bookkeeping.
--   permTransitivity
--                 hence transitivity, by induction on the first
--                 derivation alone.
--   theConverseContainment
--                 `xs â‰ˆ ys â’ Perm xs ys`, by discharging the
--                 hypothesis.
--   permutationAndAdjacencyAgree
--                 both directions in one statement, with
--                 `permIsAnAdjacentChain` as the other half.
--
-- **WHAT THE PROOF SAYS ABOUT THE TWO REPRESENTATIONS.**  It was
-- recorded that `â‰ˆ` has transitivity as a CONSTRUCTOR while `Perm`
-- builds it into the shape of `pcons`, and that the containment was
-- therefore blocked at exactly the constructor they disagree about.
-- That reading survives the proof and is sharpened by it: the cost of
-- `Perm`'s choice is **precisely `insertSwap`** â” a commutation of two
-- insertions, three clauses, no arithmetic, no decidable equality, and
-- no assumption whatever on the element type.  Nothing about
-- permutations was at stake; the price of composing was.
--
-- **THIS MODULE IS NOT WARNING-FREE, AND THE WARNING IS THE SAME PRICE
-- AGAIN.**  Agda emits TEN clause warnings (counted by
-- `grep -c "pattern-matching features"`), on `insertSwap`, `insertPerm`
-- and `permTransitivity`:
--
--   "This clause uses pattern-matching features that are not yet
--    supported by Cubical Agda, the function to which it belongs will
--    not compute when applied to transports.
--    Reason: It relies on injectivity of the data constructor _âˆ_"
--
-- `Perm` and `Insert` are INDEXED BY LISTS, so inverting them unifies
-- `x âˆ xs` patterns, and cubical Agda does not yet support constructor
-- injectivity in that position.  **The propositions below are proved â”
-- `--safe`, no postulates, no holes â” and the functions simply do not
-- COMPUTE on transports.**  That is a real qualification and it is
-- stated here rather than left to a reader to discover, in the same
-- spirit as the Lean lane's rule about `native_decide`.  It is also the
-- third appearance of one price: `Perm`'s formulation costs
-- `insertSwap` mathematically, and costs transport-computability
-- mechanically.  This corpus's own trap list already says "never match
-- a constructor in an INDEX position"; here the match is unavoidable
-- without redefining someone else's relation, so the cost is paid and
-- disclosed.
------------------------------------------------------------------------

module TheExchangeLemmaIsTheWholeOfPermTransitivitySoTheConverseContainmentIsNowATheorem where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_)

open import TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
  using ( Insert ; here ; there ; Perm ; pnil ; pcons ; _â‰ˆ_
        ; permIsAnAdjacentChain )
open import TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree
  using ( PermTransitivity ; permTransitivityGivesTheConverse )

module _ {A : Type} where

  ------------------------------------------------------------------
  -- 1.  Two insertions commute â” the whole content
  ------------------------------------------------------------------

  insertSwap :
    {x y : A} {ds us cs : List A}
    â†’ Insert x ds us â†’ Insert y us cs
    â†’ Î£[ ws âˆˆ List A ] (Insert y ds ws Ã— Insert x ws cs)
  insertSwap {y = y} {ds = ds} j here      = (y âˆ· ds) , here , there j
  insertSwap here            (there k)     = _ , k , here
  insertSwap (there j)       (there k)     with insertSwap j k
  ... | ws , iy , ix                       = _ , there iy , there ix

  ------------------------------------------------------------------
  -- 2.  â¦so an insertion moves past a permutation
  ------------------------------------------------------------------

  insertPerm :
    {x : A} {as bs cs : List A}
    â†’ Insert x as bs â†’ Perm bs cs
    â†’ Î£[ ds âˆˆ List A ] (Perm as ds Ã— Insert x ds cs)
  insertPerm here      (pcons q ins) = _ , q , ins
  insertPerm (there i) (pcons q ins) with insertPerm i q
  ... | ds , pas , ix with insertSwap ix ins
  ...   | ws , iy , ixc = ws , pcons pas iy , ixc

  ------------------------------------------------------------------
  -- 3.  â¦and transitivity follows by induction on the first alone
  ------------------------------------------------------------------

  permTransitivity : PermTransitivity {A = A}
  permTransitivity pnil        pnil = pnil
  permTransitivity (pcons p i) q with insertPerm i q
  ... | ds , pys , ix = pcons (permTransitivity p pys) ix

  ------------------------------------------------------------------
  -- 4.  The converse containment, and the two directions together
  ------------------------------------------------------------------

  theConverseContainment : {xs ys : List A} â†’ xs â‰ˆ ys â†’ Perm xs ys
  theConverseContainment = permTransitivityGivesTheConverse permTransitivity

  permutationAndAdjacencyAgree :
    {xs ys : List A} â†’ (Perm xs ys â†’ xs â‰ˆ ys) Ã— (xs â‰ˆ ys â†’ Perm xs ys)
  permutationAndAdjacencyAgree =
    permIsAnAdjacentChain , theConverseContainment
