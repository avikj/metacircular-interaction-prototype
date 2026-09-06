{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- निर्माण — construction; the making of a thing to order.
--
-- WHY THIS FILE EXISTS.  The abstract "PRUNING BY OBSERVATIONAL
-- EQUIVALENCE COLLAPSES A FIBRE WE CONSTRUCT AND SHOW IS UNBOUNDED"
-- says, under WHAT IS NOT CLAIMED, that there is no specification
-- language, no example-based synthesis, no version space and no
-- enumerative search procedure in the development, and that the reading
-- as a statement about synthesisers is a reading.
--
-- All four are built here, and the statement about synthesisers becomes
-- three theorems: pruning by observational equivalence is COMPLETE
-- (§४), the class it collapses is UNBOUNDED (§५), and any choice made
-- inside that class is EXTRA-SEMANTIC (§६) — not merely unjustified by
-- the specification, but not a function of the full input-output
-- behaviour either.
--
-- WHAT IS CHECKED
--
--   §१  `Exp`, `eval`, `size`   the candidate language.
--   §२  `Spec`, `Satisfies`     THE SPECIFICATION LANGUAGE: a finite
--                               list of input–output examples, which is
--                               what programming-by-example means.
--       `VersionSpace`          the candidates consistent with a spec.
--   §३  `candidates`, `search`  THE ENUMERATIVE SEARCH PROCEDURE, and
--       `search-sound`          that what it returns satisfies the spec.
--   §४  `behaviour`, `prune`    pruning by observational equivalence,
--       `prune-covers`          every candidate has a survivor with its
--                               behaviour, and therefore
--       `prune-complete`        PRUNING NEVER LOSES A SOLUTION.
--   §५  `tower`, `tower-inj`    the collapsed class contains an
--       `fibre-unbounded`       injective copy of ℕ: what dedup removed
--                               was not a duplicate.
--   §६  `no-semantic-ranking`   and no function of the behaviour — not
--                               of the specification, of the WHOLE
--                               input-output function — recovers the
--                               size.  So size, cost and structural
--                               heuristics are choices about the
--                               residue, by theorem.
--
-- ONE IMPLEMENTATION FACT.  `anyWitness`, `prune-covers` and the
-- decision lambdas match on indexed families, so Agda warns they will
-- not REDUCE under a transport.  Harmless here — all of them produce
-- proofs that are never transported along — and said rather than left
-- to be discovered.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Nirmana_TheSpecificationLanguageTheVersionSpaceAndTheEnumerativeSearchAreBuiltAndPruningIsProvedComplete where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; discreteℕ ; injSuc ; znots)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Maybe using (Maybe ; just ; nothing)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map)
open import Cubical.Data.List.Properties using (discreteList)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

private
  absurd : {X : Type} → ⊥ → X
  absurd ()

------------------------------------------------------------------------
-- १ · the candidate language.
------------------------------------------------------------------------

data Exp : Type where
  var : Exp
  lit : ℕ → Exp
  add : Exp → Exp → Exp

eval : Exp → ℕ → ℕ
eval var       n = n
eval (lit k)   _ = k
eval (add a b) n = eval a n + eval b n

size : Exp → ℕ
size var       = 1
size (lit _)   = 1
size (add a b) = suc (size a + size b)

------------------------------------------------------------------------
-- २ · THE SPECIFICATION LANGUAGE, and the version space.
--
-- A specification is a finite list of input–output examples.  That is
-- what programming-by-example means, and it is the whole language: no
-- logical connectives, no types, no sketch.  The version space is the
-- subtype of candidates consistent with it.
------------------------------------------------------------------------

Example : Type
Example = ℕ × ℕ

Spec : Type
Spec = List Example

Satisfies : Exp → Spec → Type
Satisfies e []             = Unit
Satisfies e ((i , o) ∷ s) = (eval e i ≡ o) × Satisfies e s

VersionSpace : Spec → Type
VersionSpace s = Σ[ e ∈ Exp ] Satisfies e s

decSatisfies : (e : Exp) (s : Spec) → Dec (Satisfies e s)
decSatisfies e []             = yes tt
decSatisfies e ((i , o) ∷ s) with discreteℕ (eval e i) o | decSatisfies e s
... | yes p | yes q = yes (p , q)
... | yes p | no ¬q = no λ r → ¬q (snd r)
... | no ¬p | _     = no λ r → ¬p (fst r)

------------------------------------------------------------------------
-- ३ · THE ENUMERATIVE SEARCH PROCEDURE.
--
-- Candidates by depth, bottom up, with no pruning; then the first one
-- that passes every example.  This is the baseline every synthesiser
-- optimises away from, and §४ is the proof that the optimisation is
-- allowed.
------------------------------------------------------------------------

joinL : List (List Exp) → List Exp
joinL []         = []
joinL (xs ∷ xss) = xs ++ joinL xss

candidates : ℕ → List Exp
candidates zero    = var ∷ lit 0 ∷ lit 1 ∷ []
candidates (suc n) =
  candidates n ++ joinL (map (λ a → map (add a) (candidates n)) (candidates n))

pick : {A : Type} → Dec A → Exp → Maybe Exp → Maybe Exp
pick (yes _) e _ = just e
pick (no  _) _ m = m

first : Spec → List Exp → Maybe Exp
first s []       = nothing
first s (e ∷ es) = pick (decSatisfies e s) e (first s es)

search : ℕ → Spec → Maybe Exp
search n s = first s (candidates n)

-- what the search returns satisfies the specification.
isJust : Maybe Exp → Type
isJust (just _) = Unit
isJust nothing  = ⊥

first-sound : (s : Spec) (es : List Exp) (e : Exp)
            → first s es ≡ just e → Satisfies e s
first-sound s []       e p = absurd (subst isJust (sym p) tt)
first-sound s (x ∷ es) e p with decSatisfies x s
... | yes sx = subst (λ z → Satisfies z s) (justInj p) sx
  where
    justInj : just x ≡ just e → x ≡ e
    justInj q = cong (λ { (just z) → z ; nothing → x }) q
... | no  _  = first-sound s es e p

search-sound : (n : ℕ) (s : Spec) (e : Exp) → search n s ≡ just e → Satisfies e s
search-sound n s = first-sound s (candidates n)

------------------------------------------------------------------------
-- ४ · PRUNING BY OBSERVATIONAL EQUIVALENCE, AND ITS COMPLETENESS.
--
-- The behaviour of a candidate on a specification is the vector of its
-- outputs at the specification's inputs.  Two candidates with the same
-- behaviour satisfy the same specifications — §४.१, which is the whole
-- justification for dedup — and pruning keeps one candidate per
-- behaviour, so it never loses a solution.
--
-- `prune-complete` is stated for ANY pruner that covers behaviours, so
-- it is a theorem about the pruning criterion and not about one
-- implementation; `prune` is then a concrete pruner satisfying it.
------------------------------------------------------------------------

behaviour : Spec → Exp → List ℕ
behaviour s e = map (λ p → eval e (fst p)) s

-- ४.१ · same behaviour, same satisfaction.  This is why dedup is sound.
behaviour→Satisfies : (s : Spec) (e e' : Exp) → behaviour s e ≡ behaviour s e'
                    → Satisfies e s → Satisfies e' s
behaviour→Satisfies []             e e' _ _        = tt
behaviour→Satisfies ((i , o) ∷ s) e e' b (p , ps) =
    (headEq b ∙ p)
  , behaviour→Satisfies s e e' (tailEq b) ps
  where
    headEq : behaviour ((i , o) ∷ s) e ≡ behaviour ((i , o) ∷ s) e'
           → eval e' i ≡ eval e i
    headEq q = cong (λ { [] → eval e i ; (x ∷ _) → x }) (sym q)
    tailEq : behaviour ((i , o) ∷ s) e ≡ behaviour ((i , o) ∷ s) e'
           → behaviour s e ≡ behaviour s e'
    tailEq q = cong (λ { [] → behaviour s e ; (_ ∷ xs) → xs }) q

data Any (P : Exp → Type) : List Exp → Type where
  anyHere  : {x : Exp} {xs : List Exp} → P x       → Any P (x ∷ xs)
  anyThere : {x : Exp} {xs : List Exp} → Any P xs → Any P (x ∷ xs)

data _∈_ : Exp → List Exp → Type where
  here  : {x : Exp} {xs : List Exp} → x ∈ (x ∷ xs)
  there : {x y : Exp} {xs : List Exp} → x ∈ xs → x ∈ (y ∷ xs)

SameB : Spec → Exp → Exp → Type
SameB s e e' = behaviour s e ≡ behaviour s e'

decSameB : (s : Spec) (e e' : Exp) → Dec (SameB s e e')
decSameB s e e' = discreteList discreteℕ (behaviour s e) (behaviour s e')

decAny : (s : Spec) (e : Exp) (xs : List Exp) → Dec (Any (SameB s e) xs)
decAny s e []       = no λ ()
decAny s e (x ∷ xs) with decSameB s e x | decAny s e xs
... | yes p | _      = yes (anyHere p)
... | no ¬p | yes q  = yes (anyThere q)
... | no ¬p | no ¬q  = no λ { (anyHere p) → ¬p p ; (anyThere q) → ¬q q }

anyWitness : (s : Spec) (e : Exp) (xs : List Exp) → Any (SameB s e) xs
           → Σ[ e' ∈ Exp ] (e' ∈ xs) × SameB s e e'
anyWitness s e (x ∷ xs) (anyHere p)  = x , here , p
anyWitness s e (x ∷ xs) (anyThere q) =
  let (e' , m , p) = anyWitness s e xs q in e' , there m , p

pruneStep : {A : Type} → Dec A → Exp → List Exp → List Exp
pruneStep (yes _) e rest = rest
pruneStep (no  _) e rest = e ∷ rest

prune : Spec → List Exp → List Exp
prune s []       = []
prune s (e ∷ es) = pruneStep (decAny s e (prune s es)) e (prune s es)

-- everything that was in the list has a survivor with its behaviour.
prune-covers : (s : Spec) (xs : List Exp) (e : Exp) → e ∈ xs
             → Σ[ e' ∈ Exp ] (e' ∈ prune s xs) × SameB s e e'
prune-covers s (x ∷ xs) e here with decAny s x (prune s xs)
... | yes a = anyWitness s x (prune s xs) a
... | no  _ = x , here , refl
prune-covers s (x ∷ xs) e (there m) with decAny s x (prune s xs)
... | yes _ = prune-covers s xs e m
... | no  _ =
  let (e' , mm , p) = prune-covers s xs e m in e' , there mm , p

-- …hence pruning never loses a solution: the theorem a synthesiser
-- silently relies on every time it deduplicates.
prune-complete : (s : Spec) (xs : List Exp) (e : Exp) → e ∈ xs → Satisfies e s
               → Σ[ e' ∈ Exp ] (e' ∈ prune s xs) × Satisfies e' s
prune-complete s xs e m sat =
  let (e' , mm , b) = prune-covers s xs e m
  in  e' , mm , behaviour→Satisfies s e e' b sat

------------------------------------------------------------------------
-- ५ · AND WHAT IT COLLAPSED WAS NOT A DUPLICATE.
--
-- The class of candidates that are constantly zero contains an
-- injective copy of ℕ.  A synthesiser that keeps one representative is
-- not removing redundancy; it is selecting one element of an unbounded
-- fibre and discarding the rest.
------------------------------------------------------------------------

tower : ℕ → Exp
tower zero    = lit 0
tower (suc n) = add (lit 0) (tower n)

tower-eval : (n : ℕ) (i : ℕ) → eval (tower n) i ≡ 0
tower-eval zero    i = refl
tower-eval (suc n) i = tower-eval n i

-- every member of the family has the same behaviour, on every spec …
tower-sameB : (s : Spec) (m n : ℕ) → SameB s (tower m) (tower n)
tower-sameB []             m n = refl
tower-sameB ((i , o) ∷ s) m n =
  cong₂ _∷_ (tower-eval m i ∙ sym (tower-eval n i)) (tower-sameB s m n)

-- … and they are pairwise distinct, because their sizes are.
depth : Exp → ℕ
depth var       = 0
depth (lit _)   = 0
depth (add _ b) = suc (depth b)

tower-depth : (n : ℕ) → depth (tower n) ≡ n
tower-depth zero    = refl
tower-depth (suc n) = cong suc (tower-depth n)

tower-inj : (m n : ℕ) → tower m ≡ tower n → m ≡ n
tower-inj m n p = sym (tower-depth m) ∙ cong depth p ∙ tower-depth n

fibre-unbounded : Σ[ f ∈ (ℕ → Exp) ]
                    ((s : Spec) (m n : ℕ) → SameB s (f m) (f n))
                  × ((m n : ℕ) → f m ≡ f n → m ≡ n)
fibre-unbounded = tower , tower-sameB , tower-inj

------------------------------------------------------------------------
-- ६ · AND THE CHOICE INSIDE THE CLASS IS EXTRA-SEMANTIC.
--
-- Stronger than "the specification does not determine it": the WHOLE
-- input-output function does not.  `tower 0` and `tower 1` are equal as
-- functions ℕ → ℕ and differ in size, so no functional of the semantics
-- computes the size.  Size, cost and structural heuristics are
-- therefore choices about the residue, and this is a theorem about them
-- rather than a caution.
------------------------------------------------------------------------

tower01-same-function : eval (tower 0) ≡ eval (tower 1)
tower01-same-function = funExt λ i → tower-eval 0 i ∙ sym (tower-eval 1 i)

one≢three : ¬ (1 ≡ 3)
one≢three p = znots (injSuc p)

no-semantic-ranking :
  ¬ (Σ[ f ∈ ((ℕ → ℕ) → ℕ) ] ((e : Exp) → f (eval e) ≡ size e))
no-semantic-ranking (f , sound) =
  one≢three (sym (sound (tower 0))
           ∙ cong f tower01-same-function
           ∙ sound (tower 1))
