{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कोश — the treasury; the repository.
--
-- WHY THIS FILE EXISTS.  `PairwiseCommutationGivesEveryOrder` proves
-- that pairwise commutation of steps gives order-independence of every
-- permutation of a run.  Its abstract then says, under WHAT IS NOT
-- CLAIMED, that there is no working tree, no file, no line-based diff,
-- no blame algorithm and no repository format in the development — that
-- a patch is a step on an abstract state, and that COMMUTATION IS A
-- HYPOTHESIS DISCHARGED BY THE CALLER.
--
-- That last clause is the one that matters, and it is closed here by
-- exhibiting a calculus in which commutation is a THEOREM.  A caller
-- supplies distinctness of locations — a decidable, checkable property
-- of a patch list — and gets commutation, order-independence and blame
-- back.  Nothing is passed out to be assumed.
--
-- The module's own WHAT IS NOT CLAIMED also records that its
-- commutation hypothesis is GLOBAL, quantified over every step of the
-- type rather than over the steps in the list, and that localising it
-- "is possible but NOT done".  §६ does it: the hypothesis here is
-- carried through the swap and transitivity cases by a membership
-- index, so it constrains only the patches that actually appear.
--
-- THE REPOSITORY FORMAT is the one git actually uses: a tree is a map
-- from locations to contents, not a list of lines carrying its own
-- length.  A location is a path together with a line number, so "line-
-- based" is literal — a patch names the file and the line.
--
-- WHAT IS CHECKED
--
--   §१  `Tree`, `Loc`, `Patch`, `apply`   the working tree and the edit.
--   §२  `commute`        DISTINCT LOCATIONS COMMUTE — proved, no
--                        hypothesis, for every tree and every content.
--   §३  `same-location-does-not-commute`
--                        …and the distinctness is not removable: two
--                        writes to one location are exhibited failing.
--   §४  `blame`          the last writer at each location, and
--       `blame-explains` the theorem that it explains the tree: the
--                        content after a run is exactly what blame says
--                        wrote it.
--   §५  `diff`, `diff-correct`
--                        the line-based diff over a finite location
--                        set, and that applying it transports one tree
--                        to the other there.
--   §६  `permInvariant`  EVERY ORDER AGREES, with the commutation
--                        hypothesis localised to the patches in the
--                        list, and
--       `distinct→commuting`
--                        that hypothesis discharged from distinctness.
--
-- ONE IMPLEMENTATION FACT, stated because it is real.  `~∈` and
-- `diff-correct` pattern match on an indexed family, so Agda warns that
-- they will not REDUCE when applied to a transport.  That costs nothing
-- here — both produce equalities between trees and neither is ever
-- transported along — but it is a property of the definitions and is
-- said rather than left for a reader to discover.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Kosa_TheWorkingTreeTheLineDiffAndTheBlameAreBuiltAndCommutationIsProvedNotAssumed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Data.Maybe using (Maybe ; just ; nothing)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

private
  absurd : {X : Type} → ⊥ → X
  absurd ()

------------------------------------------------------------------------
-- १ · the repository format, the working tree, and the edit.
--
-- A location is a path and a line number.  A tree assigns content to
-- every location; the empty repository is the constant absent content,
-- and nothing here needs a length or a bounds check.
------------------------------------------------------------------------

Loc : Type
Loc = ℕ × ℕ

discreteLoc : Discrete Loc
discreteLoc (p , i) (q , j) with discreteℕ p q | discreteℕ i j
... | yes e | yes f = yes (cong₂ _,_ e f)
... | yes e | no ¬f = no λ r → ¬f (cong snd r)
... | no ¬e | _     = no λ r → ¬e (cong fst r)

module Repo (Content : Type) where

  Tree : Type
  Tree = Loc → Content

  record Patch : Type where
    constructor patch
    field
      at  : Loc
      put : Content

  open Patch public

  -- the branch is a function of the decision, so it reduces wherever
  -- the decision does — which is what makes §२ a case analysis and not
  -- a rewriting argument.
  choose : {A : Type} → Dec A → Content → Content → Content
  choose (yes _) c d = c
  choose (no  _) c d = d

  apply : Patch → Tree → Tree
  apply p t l = choose (discreteLoc l (at p)) (put p) (t l)

  applyAll : List Patch → Tree → Tree
  applyAll []       t = t
  applyAll (p ∷ ps) t = applyAll ps (apply p t)

  ------------------------------------------------------------------
  -- २ · COMMUTATION, PROVED.
  --
  -- Two patches at distinct locations commute, for every tree.  The
  -- proof is a case analysis on the two decisions at each location, and
  -- the only awkward case — both fire — is exactly the one the
  -- distinctness hypothesis forbids.
  ------------------------------------------------------------------

  commute : (p q : Patch) → ¬ (at p ≡ at q)
          → (t : Tree) → apply p (apply q t) ≡ apply q (apply p t)
  commute p q d t = funExt lemma
    where
      lemma : (l : Loc) → apply p (apply q t) l ≡ apply q (apply p t) l
      lemma l with discreteLoc l (at p) | discreteLoc l (at q)
      ... | yes ep | yes eq = absurd (d (sym ep ∙ eq))
      ... | yes ep | no  _  = refl
      ... | no  _  | yes eq = refl
      ... | no  _  | no  _  = refl

  ------------------------------------------------------------------
  -- ३ · blame, and the theorem that it explains the tree.
  --
  -- The blame of a location after a run is the LAST patch in the run
  -- that named it.  `blame-explains` is the correctness statement a
  -- blame algorithm owes and rarely states: the content you observe is
  -- exactly what blame says put it there, and where blame is silent the
  -- content is the one the run started with.
  ------------------------------------------------------------------

  orElse : Maybe Patch → Maybe Patch → Maybe Patch
  orElse (just q) _ = just q
  orElse nothing  m = m

  pickIf : {A : Type} → Dec A → Patch → Maybe Patch
  pickIf (yes _) r = just r
  pickIf (no  _) r = nothing

  blame : List Patch → Loc → Maybe Patch
  blame []       l = nothing
  blame (p ∷ ps) l = orElse (blame ps l) (pickIf (discreteLoc l (at p)) p)

  resolve : Maybe Patch → Content → Content
  resolve (just q) _ = put q
  resolve nothing  c = c

  blame-explains : (ps : List Patch) (t : Tree) (l : Loc)
                 → applyAll ps t l ≡ resolve (blame ps l) (t l)
  blame-explains []       t l = refl
  blame-explains (p ∷ ps) t l with blame ps l | blame-explains ps (apply p t) l
  ... | just q  | ih = ih
  ... | nothing | ih with discreteLoc l (at p)
  ...   | yes _ = ih
  ...   | no  _ = ih

  ------------------------------------------------------------------
  -- ४ · the line-based diff.
  --
  -- Over a finite set of locations, the diff of two trees is the list
  -- of writes carrying the first to the second, and `diff-correct` is
  -- the property a diff owes: applying it lands you on the target, at
  -- every location the diff names.
  --
  -- The induction runs on the invariant `diff-preserves`: once a
  -- location holds its target content, no later write in the diff can
  -- move it, because every write in a diff writes the target.
  ------------------------------------------------------------------

  data _∈_ : Loc → List Loc → Type where
    here  : {l : Loc} {ls : List Loc} → l ∈ (l ∷ ls)
    there : {l m : Loc} {ls : List Loc} → l ∈ ls → l ∈ (m ∷ ls)

  diff : List Loc → Tree → List Patch
  diff ls u = map (λ l → patch l (u l)) ls

  apply-at : (p : Patch) (t : Tree) → apply p t (at p) ≡ put p
  apply-at p t with discreteLoc (at p) (at p)
  ... | yes _  = refl
  ... | no  ¬e = absurd (¬e refl)

  diff-preserves : (ls : List Loc) (u t : Tree) (l : Loc) → t l ≡ u l
                 → applyAll (diff ls u) t l ≡ u l
  diff-preserves []       u t l h = h
  diff-preserves (m ∷ ls) u t l h =
    diff-preserves ls u (apply (patch m (u m)) t) l step
    where
      step : apply (patch m (u m)) t l ≡ u l
      step with discreteLoc l m
      ... | yes e = cong u (sym e)
      ... | no  _ = h

  diff-correct : (ls : List Loc) (t u : Tree) (l : Loc) → l ∈ ls
               → applyAll (diff ls u) t l ≡ u l
  diff-correct (m ∷ ls) t u l here =
    diff-preserves ls u (apply (patch m (u m)) t) m (apply-at (patch m (u m)) t)
  diff-correct (m ∷ ls) t u l (there mem) =
    diff-correct ls (apply (patch m (u m)) t) u l mem

  ------------------------------------------------------------------
  -- ५ · EVERY ORDER AGREES, with the hypothesis localised.
  --
  -- `Commuting xs` constrains only the patches that appear in `xs`;
  -- the membership index is carried through the swap and transitivity
  -- cases, which is what the earlier module records as possible and
  -- not done.  `~∈` is what makes the transitivity case go through:
  -- a permutation cannot introduce a patch that was not there.
  ------------------------------------------------------------------

  data _∈ₚ_ : Patch → List Patch → Type where
    hereₚ  : {p : Patch} {ps : List Patch} → p ∈ₚ (p ∷ ps)
    thereₚ : {p q : Patch} {ps : List Patch} → p ∈ₚ ps → p ∈ₚ (q ∷ ps)

  data _~_ : List Patch → List Patch → Type where
    ~nil   : [] ~ []
    ~cons  : {p : Patch} {xs ys : List Patch} → xs ~ ys → (p ∷ xs) ~ (p ∷ ys)
    ~swap  : {p q : Patch} {xs : List Patch} → (p ∷ q ∷ xs) ~ (q ∷ p ∷ xs)
    ~trans : {xs ys zs : List Patch} → xs ~ ys → ys ~ zs → xs ~ zs

  ~∈ : {xs ys : List Patch} → xs ~ ys → {p : Patch} → p ∈ₚ ys → p ∈ₚ xs
  ~∈ ~nil          m                    = m
  ~∈ (~cons h)     hereₚ                = hereₚ
  ~∈ (~cons h)     (thereₚ m)           = thereₚ (~∈ h m)
  ~∈ ~swap         hereₚ                = thereₚ hereₚ
  ~∈ ~swap         (thereₚ hereₚ)       = hereₚ
  ~∈ ~swap         (thereₚ (thereₚ m))  = thereₚ (thereₚ m)
  ~∈ (~trans h₁ h₂) m                   = ~∈ h₁ (~∈ h₂ m)

  Commuting : List Patch → Type
  Commuting xs = (p q : Patch) → p ∈ₚ xs → q ∈ₚ xs
               → (t : Tree) → apply p (apply q t) ≡ apply q (apply p t)

  permInvariant : {xs ys : List Patch} → xs ~ ys → Commuting xs
                → (t : Tree) → applyAll xs t ≡ applyAll ys t
  permInvariant ~nil                       c t = refl
  permInvariant (~cons {p = p} h)          c t =
    permInvariant h (λ a b ma mb → c a b (thereₚ ma) (thereₚ mb)) (apply p t)
  permInvariant (~swap {p = p} {q = q} {xs = xs}) c t =
    cong (applyAll xs) (c q p (thereₚ hereₚ) hereₚ t)
  permInvariant (~trans h₁ h₂)             c t =
      permInvariant h₁ c t
    ∙ permInvariant h₂ (λ a b ma mb → c a b (~∈ h₁ ma) (~∈ h₁ mb)) t

  -- AND THE HYPOTHESIS IS DISCHARGED.  The caller supplies "no two
  -- patches in this list name one location without being the same
  -- patch" — a property of the list, decidable wherever content
  -- equality is — and gets commutation, and therefore every order.
  distinct→commuting : (xs : List Patch)
                     → ((p q : Patch) → p ∈ₚ xs → q ∈ₚ xs → at p ≡ at q → p ≡ q)
                     → Commuting xs
  distinct→commuting xs h p q mp mq t with discreteLoc (at p) (at q)
  ... | no  d = commute p q d t
  ... | yes e =
      cong (λ r → apply p (apply r t)) (sym pq)
    ∙ cong (λ r → apply r (apply p t)) pq
    where
      pq : p ≡ q
      pq = h p q mp mq e

  every-order-agrees : (xs ys : List Patch) → xs ~ ys
                     → ((p q : Patch) → p ∈ₚ xs → q ∈ₚ xs → at p ≡ at q → p ≡ q)
                     → (t : Tree) → applyAll xs t ≡ applyAll ys t
  every-order-agrees xs ys perm d = permInvariant perm (distinct→commuting xs d)

------------------------------------------------------------------------
-- ६ · AND THE DISTINCTNESS IS NOT REMOVABLE.
--
-- Two writes to one location, with different content, do not commute.
-- So §२ is not a theorem waiting to be generalised: the hypothesis it
-- carries is exactly the boundary, and here is the pair that sits on
-- the far side of it.
------------------------------------------------------------------------

open Repo Bool

conflict₁ conflict₂ : Patch
conflict₁ = patch (0 , 0) true
conflict₂ = patch (0 , 0) false

same-location-does-not-commute :
  ¬ ((t : Tree) → apply conflict₁ (apply conflict₂ t) ≡ apply conflict₂ (apply conflict₁ t))
same-location-does-not-commute h =
  true≢false (funExt⁻ (h (λ _ → true)) (0 , 0))
