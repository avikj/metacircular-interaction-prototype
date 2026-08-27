{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अन्वय — the lineage, the connected sequence.
--
-- WHY THIS FILE EXISTS.  The abstract "THE ANSWER DOES NOT DETERMINE THE
-- DERIVATION" proves that evaluation into a discrete domain factors
-- through the truncation of the derivation type, and then says, under
-- WHAT IS NOT CLAIMED, that there is no provenance semiring in the
-- development, no forgetful homomorphism to the boolean semiring, no
-- relational algebra and no query language, and that the reading as
-- how-provenance is a reading.
--
-- All four are built here, and the reading becomes the theorem of the
-- subject: query evaluation commutes with semiring homomorphisms
-- (§६), and the how ⊐ bag ⊐ set hierarchy is STRICT with a witness at
-- each collapse (§५).
--
-- ON EXHIBITING DISTINCTNESS IN A FREE COMMUTATIVE SEMIRING WITHOUT
-- BUILDING THE QUOTIENT.  How-provenance lives in ℕ[X], the free
-- commutative semiring on the tuple identifiers, which is the term
-- algebra modulo the semiring laws.  Constructing that quotient is not
-- needed to prove two elements DIFFERENT: two terms are equal in the
-- quotient exactly when every evaluation into every commutative
-- semiring agrees on them, so ONE evaluation that disagrees is a proof
-- of distinctness in ℕ[X] itself.  §५ uses exactly that, and it is why
-- no set-quotient appears below.
--
-- WHAT IS CHECKED
--
--   §१  `CommSemiring`, `Hom`     the structures.
--   §२  `Prov`, `eval`            provenance terms and the universal map.
--   §३  `hom-eval`                a homomorphism commutes with `eval`:
--                                  the universal property, as a term.
--   §४  `ℕ-semiring`              bag semantics (count the derivations),
--       `Bool-semiring`           set semantics (was there one),
--       `⌈_⌉`, `⌈⌉-hom`           THE FORGETFUL HOMOMORPHISM ℕ → 𝔹,
--       `set-factors-through-bag` and the factorisation it induces.
--   §५  `bag-does-not-determine-how`     STRICTNESS, twice, each with
--       `set-does-not-determine-bag`     an exhibited pair, plus the
--       `no-bag-from-set`                stronger "no function of the
--       `no-how-from-bag`                coarser annotation recovers
--                                        the finer one" in both places.
--   §६  the relational algebra and `query-hom`:
--                                 QUERY EVALUATION COMMUTES WITH
--                                 SEMIRING HOMOMORPHISMS, by induction
--                                 over the query language.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Anvaya_TheProvenanceSemiringTheBooleanHomomorphismAndTheQueryLanguageAreBuiltAndTheHierarchyIsStrict where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; _or_ ; _and_ ; true≢false ; false≢true
        ; or-comm ; or-assoc ; or-identityʳ ; and-comm ; and-assoc ; and-identityʳ)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; predℕ ; _+_ ; _·_ ; +-assoc ; +-comm ; +-zero ; snotz
        ; ·-assoc ; ·-comm ; ·-identityʳ ; ·-distribˡ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; Discrete ; yes ; no)

private
  absurd : {X : Type} → ⊥ → X
  absurd ()

------------------------------------------------------------------------
-- १ · commutative semirings, and their homomorphisms.
------------------------------------------------------------------------

record CommSemiring (R : Type) : Type where
  field
    𝟘 𝟙       : R
    _⊕_ _⊗_   : R → R → R
    ⊕assoc    : (x y z : R) → x ⊕ (y ⊕ z) ≡ (x ⊕ y) ⊕ z
    ⊕comm     : (x y : R) → x ⊕ y ≡ y ⊕ x
    ⊕unit     : (x : R) → x ⊕ 𝟘 ≡ x
    ⊗assoc    : (x y z : R) → x ⊗ (y ⊗ z) ≡ (x ⊗ y) ⊗ z
    ⊗comm     : (x y : R) → x ⊗ y ≡ y ⊗ x
    ⊗unit     : (x : R) → x ⊗ 𝟙 ≡ x
    ⊗annih    : (x : R) → 𝟘 ⊗ x ≡ 𝟘
    ⊗distrib  : (x y z : R) → (x ⊗ y) ⊕ (x ⊗ z) ≡ x ⊗ (y ⊕ z)

open CommSemiring public

record Hom {R S : Type} (𝕣 : CommSemiring R) (𝕤 : CommSemiring S)
           (h : R → S) : Type where
  field
    h𝟘 : h (𝟘 𝕣) ≡ 𝟘 𝕤
    h𝟙 : h (𝟙 𝕣) ≡ 𝟙 𝕤
    h⊕ : (x y : R) → h (_⊕_ 𝕣 x y) ≡ _⊕_ 𝕤 (h x) (h y)
    h⊗ : (x y : R) → h (_⊗_ 𝕣 x y) ≡ _⊗_ 𝕤 (h x) (h y)

open Hom public

------------------------------------------------------------------------
-- २ · provenance terms, and the universal map out of them.
--
-- `Prov X` is the term algebra of the semiring signature over the tuple
-- identifiers X.  `eval` is the unique semiring map out of it once the
-- identifiers are given values — the universal property of ℕ[X], with
-- the quotient left implicit as explained in the header.
------------------------------------------------------------------------

data Prov (X : Type) : Type where
  var        : X → Prov X
  𝟎 𝟏        : Prov X
  _⊞_ _⊠_    : Prov X → Prov X → Prov X

eval : {X R : Type} → CommSemiring R → (X → R) → Prov X → R
eval 𝕣 ν (var x)  = ν x
eval 𝕣 ν 𝟎        = 𝟘 𝕣
eval 𝕣 ν 𝟏        = 𝟙 𝕣
eval 𝕣 ν (p ⊞ q) = _⊕_ 𝕣 (eval 𝕣 ν p) (eval 𝕣 ν q)
eval 𝕣 ν (p ⊠ q) = _⊗_ 𝕣 (eval 𝕣 ν p) (eval 𝕣 ν q)

-- equality in the free COMMUTATIVE SEMIRING, stated by its universal
-- property rather than by a quotient: two terms are the same polynomial
-- exactly when no evaluation can tell them apart.
_≐_ : {X : Type} → Prov X → Prov X → Type₁
_≐_ {X = X} p q =
  (R : Type) (𝕣 : CommSemiring R) (ν : X → R) → eval 𝕣 ν p ≡ eval 𝕣 ν q

------------------------------------------------------------------------
-- ३ · a homomorphism commutes with evaluation.
--
-- Five lines, one per constructor.  Everything in §४ and §६ is a
-- corollary of this and of the query induction.
------------------------------------------------------------------------

hom-eval : {X R S : Type} {𝕣 : CommSemiring R} {𝕤 : CommSemiring S}
           {h : R → S} → Hom 𝕣 𝕤 h
         → (ν : X → R) (p : Prov X)
         → h (eval 𝕣 ν p) ≡ eval 𝕤 (λ x → h (ν x)) p
hom-eval hm ν (var x)  = refl
hom-eval hm ν 𝟎        = h𝟘 hm
hom-eval hm ν 𝟏        = h𝟙 hm
hom-eval {𝕣 = 𝕣} {𝕤 = 𝕤} hm ν (p ⊞ q) =
    h⊕ hm (eval 𝕣 ν p) (eval 𝕣 ν q)
  ∙ cong₂ (_⊕_ 𝕤) (hom-eval hm ν p) (hom-eval hm ν q)
hom-eval {𝕣 = 𝕣} {𝕤 = 𝕤} hm ν (p ⊠ q) =
    h⊗ hm (eval 𝕣 ν p) (eval 𝕣 ν q)
  ∙ cong₂ (_⊗_ 𝕤) (hom-eval hm ν p) (hom-eval hm ν q)

------------------------------------------------------------------------
-- ४ · the two coarse semantics, and the forgetful homomorphism.
------------------------------------------------------------------------

ℕ-semiring : CommSemiring ℕ
𝟘        ℕ-semiring = 0
𝟙        ℕ-semiring = 1
_⊕_      ℕ-semiring = _+_
_⊗_      ℕ-semiring = _·_
⊕assoc   ℕ-semiring = +-assoc
⊕comm    ℕ-semiring = +-comm
⊕unit    ℕ-semiring = +-zero
⊗assoc   ℕ-semiring = ·-assoc
⊗comm    ℕ-semiring = ·-comm
⊗unit    ℕ-semiring = ·-identityʳ
⊗annih   ℕ-semiring _ = refl
⊗distrib ℕ-semiring = ·-distribˡ

Bool-semiring : CommSemiring Bool
𝟘        Bool-semiring = false
𝟙        Bool-semiring = true
_⊕_      Bool-semiring = _or_
_⊗_      Bool-semiring = _and_
⊕assoc   Bool-semiring = or-assoc
⊕comm    Bool-semiring = or-comm
⊕unit    Bool-semiring = or-identityʳ
⊗assoc   Bool-semiring = and-assoc
⊗comm    Bool-semiring = and-comm
⊗unit    Bool-semiring = and-identityʳ
⊗annih   Bool-semiring _ = refl
⊗distrib Bool-semiring false y z = refl
⊗distrib Bool-semiring true  y z = refl

-- THE FORGETFUL HOMOMORPHISM.  "How many derivations" ↦ "was there one".
⌈_⌉ : ℕ → Bool
⌈ zero  ⌉ = false
⌈ suc _ ⌉ = true

⌈⌉-or : (m n : ℕ) → ⌈ m + n ⌉ ≡ (⌈ m ⌉ or ⌈ n ⌉)
⌈⌉-or zero    n       = refl
⌈⌉-or (suc m) n       = refl

⌈⌉-and : (m n : ℕ) → ⌈ m · n ⌉ ≡ (⌈ m ⌉ and ⌈ n ⌉)
⌈⌉-and zero    n       = refl
⌈⌉-and (suc m) zero    = cong ⌈_⌉ (·-comm (suc m) zero)
⌈⌉-and (suc m) (suc n) = refl

⌈⌉-hom : Hom ℕ-semiring Bool-semiring ⌈_⌉
h𝟘 ⌈⌉-hom = refl
h𝟙 ⌈⌉-hom = refl
h⊕ ⌈⌉-hom = ⌈⌉-or
h⊗ ⌈⌉-hom = ⌈⌉-and

-- the two coarse readings of a provenance term …
bag : {X : Type} → Prov X → ℕ
bag = eval ℕ-semiring (λ _ → 1)

setb : {X : Type} → Prov X → Bool
setb = eval Bool-semiring (λ _ → true)

-- … and set semantics is bag semantics with the multiplicity forgotten.
set-factors-through-bag : {X : Type} (p : Prov X) → ⌈ bag p ⌉ ≡ setb p
set-factors-through-bag = hom-eval ⌈⌉-hom (λ _ → 1)

------------------------------------------------------------------------
-- ५ · THE HIERARCHY IS STRICT, twice, with witnesses.
--
-- how ⊐ bag ⊐ set.  At each step the coarser annotation identifies two
-- things the finer one separates, and — the sharper form, which is the
-- one that kills reconstruction — NO function of the coarser annotation
-- recovers the finer, for any function whatsoever.
------------------------------------------------------------------------

Id : Type
Id = Unit

-- one tuple used twice, against the same tuple used once.  Same count.
howA howB : Prov Id
howA = var tt ⊠ var tt
howB = var tt

bag-agrees : bag howA ≡ bag howB
bag-agrees = refl

four≢two : ¬ (4 ≡ 2)
four≢two p = snotz (cong predℕ (cong predℕ p))

bag-does-not-determine-how : ¬ (howA ≐ howB)
bag-does-not-determine-how eq = four≢two (eq ℕ ℕ-semiring (λ _ → 2))

-- two derivations of the same fact, against one.  Same existence.
bagA bagB : Prov Id
bagA = var tt ⊞ var tt
bagB = var tt

set-agrees : setb bagA ≡ setb bagB
set-agrees = refl

set-does-not-determine-bag : ¬ (bag bagA ≡ bag bagB)
set-does-not-determine-bag p = snotz (cong predℕ p)

-- the sharper forms.  Not "the obvious reconstruction fails" — NO
-- function of the coarser annotation agrees with the finer one.
no-bag-from-set : ¬ (Σ[ f ∈ (Bool → ℕ) ] ((p : Prov Id) → f (setb p) ≡ bag p))
no-bag-from-set (f , q) =
  set-does-not-determine-bag (sym (q bagA) ∙ cong f set-agrees ∙ q bagB)

no-how-from-bag : ¬ (Σ[ f ∈ (ℕ → Prov Id) ] ((p : Prov Id) → f (bag p) ≐ p))
no-how-from-bag (f , q) =
  bag-does-not-determine-how
    (λ R 𝕣 ν → sym (q howA R 𝕣 ν)
             ∙ cong (λ n → eval 𝕣 ν (f n)) bag-agrees
             ∙ q howB R 𝕣 ν)

------------------------------------------------------------------------
-- ६ · THE RELATIONAL ALGEBRA, AND THE THEOREM OF THE SUBJECT.
--
-- An annotated relation sends each tuple to its provenance.  Union adds,
-- join multiplies, selection keeps or annihilates, projection sums over
-- the fibre.  That is the positive relational algebra, annotated.
--
-- `query-hom` is the theorem the whole apparatus exists for: query
-- evaluation COMMUTES WITH SEMIRING HOMOMORPHISMS.  Applied to `⌈_⌉` it
-- says the set-semantics answer to a query can be computed either by
-- running the query and forgetting, or by forgetting and then running —
-- and applied to §५ it says forgetting FIRST is the step that cannot be
-- undone.
------------------------------------------------------------------------

Rel : Type → Type → Type
Rel T R = T → R

bigsum : {R : Type} → CommSemiring R → List R → R
bigsum 𝕣 []       = 𝟘 𝕣
bigsum 𝕣 (x ∷ xs) = _⊕_ 𝕣 x (bigsum 𝕣 xs)

pick : {R U : Type} → CommSemiring R → {u v : U} → Dec (u ≡ v) → R → R
pick 𝕣 (yes _) x = x
pick 𝕣 (no  _) _ = 𝟘 𝕣

keep : {R : Type} → CommSemiring R → Bool → R → R
keep 𝕣 true  x = x
keep 𝕣 false _ = 𝟘 𝕣

module Algebra (Sym : Type → Type) where

  data Query : Type → Type₁ where
    base : {T : Type} → Sym T → Query T
    _∪_  : {T : Type} → Query T → Query T → Query T
    _⋈_  : {T U : Type} → Query T → Query U → Query (T × U)
    σ    : {T : Type} → (T → Bool) → Query T → Query T
    π    : {T U : Type} → Discrete U → (T → U) → List T → Query T → Query U

  Env : Type → Type₁
  Env R = {T : Type} → Sym T → Rel T R

  run : {R : Type} (𝕣 : CommSemiring R) → Env R → {T : Type} → Query T → Rel T R
  run 𝕣 E (base s)   t       = E s t
  run 𝕣 E (q₁ ∪ q₂) t       = _⊕_ 𝕣 (run 𝕣 E q₁ t) (run 𝕣 E q₂ t)
  run 𝕣 E (q₁ ⋈ q₂) (t , u) = _⊗_ 𝕣 (run 𝕣 E q₁ t) (run 𝕣 E q₂ u)
  run 𝕣 E (σ φ q)    t       = keep 𝕣 (φ t) (run 𝕣 E q t)
  run 𝕣 E (π dU f ts q) u    =
    bigsum 𝕣 (map (λ t → pick 𝕣 (dU (f t) u) (run 𝕣 E q t)) ts)

  -- the induction that carries a homomorphism through a summation.
  hom-bigsum-map :
    {A R S : Type} {𝕣 : CommSemiring R} {𝕤 : CommSemiring S} {h : R → S}
    → Hom 𝕣 𝕤 h → (F : A → R) (G : A → S) → ((a : A) → h (F a) ≡ G a)
    → (as : List A) → h (bigsum 𝕣 (map F as)) ≡ bigsum 𝕤 (map G as)
  hom-bigsum-map hm F G pf []       = h𝟘 hm
  hom-bigsum-map {𝕣 = 𝕣} {𝕤 = 𝕤} hm F G pf (a ∷ as) =
      h⊕ hm (F a) (bigsum 𝕣 (map F as))
    ∙ cong₂ (_⊕_ 𝕤) (pf a) (hom-bigsum-map hm F G pf as)

  hom-pick : {R S U : Type} {𝕣 : CommSemiring R} {𝕤 : CommSemiring S} {h : R → S}
           → Hom 𝕣 𝕤 h → {u v : U} (d : Dec (u ≡ v)) (x : R)
           → h (pick 𝕣 d x) ≡ pick 𝕤 d (h x)
  hom-pick hm (yes _) x = refl
  hom-pick hm (no  _) x = h𝟘 hm

  hom-keep : {R S : Type} {𝕣 : CommSemiring R} {𝕤 : CommSemiring S} {h : R → S}
           → Hom 𝕣 𝕤 h → (b : Bool) (x : R)
           → h (keep 𝕣 b x) ≡ keep 𝕤 b (h x)
  hom-keep hm true  x = refl
  hom-keep hm false x = h𝟘 hm

  -- THE THEOREM.  Query evaluation commutes with semiring homomorphisms.
  query-hom :
    {R S : Type} {𝕣 : CommSemiring R} {𝕤 : CommSemiring S} {h : R → S}
    → Hom 𝕣 𝕤 h → (E : Env R)
    → {T : Type} (q : Query T) (t : T)
    → h (run 𝕣 E q t) ≡ run 𝕤 (λ s → λ u → h (E s u)) q t
  query-hom hm E (base s) t = refl
  query-hom {𝕤 = 𝕤} hm E (q₁ ∪ q₂) t =
      h⊕ hm _ _ ∙ cong₂ (_⊕_ 𝕤) (query-hom hm E q₁ t) (query-hom hm E q₂ t)
  query-hom {𝕤 = 𝕤} hm E (q₁ ⋈ q₂) (t , u) =
      h⊗ hm _ _ ∙ cong₂ (_⊗_ 𝕤) (query-hom hm E q₁ t) (query-hom hm E q₂ u)
  query-hom hm E (σ φ q) t =
      hom-keep hm (φ t) _ ∙ cong (keep _ (φ t)) (query-hom hm E q t)
  query-hom {𝕣 = 𝕣} {𝕤 = 𝕤} {h = h} hm E (π dU f ts q) u =
    hom-bigsum-map hm
      (λ t → pick 𝕣 (dU (f t) u) (run 𝕣 E q t))
      (λ t → pick 𝕤 (dU (f t) u) (run 𝕤 (λ s → λ v → h (E s v)) q t))
      (λ t → hom-pick hm (dU (f t) u) (run 𝕣 E q t)
           ∙ cong (pick 𝕤 (dU (f t) u)) (query-hom hm E q t))
      ts
