{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EGBSpanWeave
--
-- Relation composition as span composition, with both middles kept.
--
-- Proof-relevant relations are type families R : A → B → Type ℓ.  The
-- composite (R ⋈ S) a c = Σ B (λ b → R a b × S b c) does NOT truncate:
-- an element of the composite carries the jewel b it passed through,
-- together with both witnesses.  This is EGB Delta-24 §5's gluing
-- discipline ("relation is retained without being misdeclared
-- identity") made into a checked operation.
--
-- Checked here:
--   _⋈_        span composition, middle retained
--   ⋈-assoc    associativity up to equivalence (a strict Σ-shuffle:
--              both round trips are refl)
--   ⋈-idL      the path relation Id a a' = (a ≡ a') is a LEFT unit up
--              to equivalence, by singleton contraction
--              (Σ-assoc-≃ then Σ-contractFst (isContrSingl a))
--   twoMiddles the Huayan separation: over Bool with R = S = the
--              total relation (λ _ _ → Unit), the composite
--              (Total ⋈ Total) true true has two DISTINCT inhabitants
--              (true , tt , tt) and (false , tt , tt), separated by
--              the Σ first projection and true≢false.  Composition
--              remembers WHICH jewel mediated the containment.
--   totalComposite≃Bool
--              the same composite is equivalent to Bool: the
--              composite IS the type of middles, nothing more and
--              nothing less, when the legs are trivial.
--
-- NOT claimed: no bicategory of spans, no right unit law, no
-- unit/counit coherence, no interchange.  One unit law and
-- associativity only; the boundary is stated in the message file
-- collab/messages/genius-braid/1-15-fazang.md.
------------------------------------------------------------------------

module EGBSpanWeave where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' ℓ'' ℓ''' ℓR ℓS ℓT : Level
    A : Type ℓ
    B : Type ℓ'
    C : Type ℓ''
    D : Type ℓ'''

------------------------------------------------------------------------
-- Composition with the middle retained

_⋈_ : (A → B → Type ℓR) → (B → C → Type ℓS)
    → A → C → Type _
_⋈_ {B = B} R S a c = Σ B (λ b → R a b × S b c)

infixr 30 _⋈_

------------------------------------------------------------------------
-- Associativity up to equivalence.  Both bracketings retain BOTH
-- middles (b : B and c : C); the equivalence merely reassociates the
-- record, so both round trips are refl.

module _ {R : A → B → Type ℓR} {S : B → C → Type ℓS}
         {T : C → D → Type ℓT} {a : A} {d : D} where

  ⋈-assoc-Iso : Iso (((R ⋈ S) ⋈ T) a d) ((R ⋈ (S ⋈ T)) a d)
  Iso.fun ⋈-assoc-Iso (c , (b , r , s) , t) = b , r , (c , s , t)
  Iso.inv ⋈-assoc-Iso (b , r , (c , s , t)) = c , (b , r , s) , t
  Iso.rightInv ⋈-assoc-Iso _ = refl
  Iso.leftInv ⋈-assoc-Iso _ = refl

  ⋈-assoc : (((R ⋈ S) ⋈ T) a d) ≃ ((R ⋈ (S ⋈ T)) a d)
  ⋈-assoc = isoToEquiv ⋈-assoc-Iso

------------------------------------------------------------------------
-- The path relation is a left unit up to equivalence.
--
-- (Id ⋈ R) a b = Σ A (λ x → (a ≡ x) × R x b).  Reassociating gives
-- Σ (singl a) (λ p → R (fst p) b), and the singleton is contractible
-- with centre (a , refl), so Σ-contractFst collapses the retained
-- middle onto a itself: the only jewel a path out of a can pass
-- through is (a, up to contractible choice), and the composite
-- remembers exactly that.

Id : (A : Type ℓ) → A → A → Type ℓ
Id A a a' = a ≡ a'

⋈-idL : {A : Type ℓ} {B : Type ℓ'} (R : A → B → Type ℓR)
        (a : A) (b : B)
      → ((Id A ⋈ R) a b) ≃ R a b
⋈-idL {A = A} R a b =
  compEquiv
    (invEquiv Σ-assoc-≃)
    (Σ-contractFst (isContrSingl a))

------------------------------------------------------------------------
-- The Huayan separation: composition does not forget its middle.
--
-- Total relation on Bool: every jewel contains every jewel, with a
-- trivial witness.  The composite Total ⋈ Total at (true , true)
-- nevertheless has TWO distinct elements — one through the middle
-- true, one through the middle false.  Collapsing the composite to a
-- proposition ("true is related to true: yes") would destroy exactly
-- this: the path of containment.

Total : Bool → Bool → Type₀
Total _ _ = Unit

throughTrue : (Total ⋈ Total) true true
throughTrue = true , tt , tt

throughFalse : (Total ⋈ Total) true true
throughFalse = false , tt , tt

twoMiddles : ¬ (throughTrue ≡ throughFalse)
twoMiddles p = true≢false (cong fst p)

-- With trivial legs the composite is exactly the type of middles:
-- (Total ⋈ Total) true true ≃ Bool.  The adjacency-matrix reading
-- ("related or not") would truncate this Bool to a point; the span
-- reading keeps it.

totalComposite≃Bool : ((Total ⋈ Total) true true) ≃ Bool
totalComposite≃Bool =
  Σ-contractSnd (λ _ → isContrUnit× )
  where
  isContrUnit× : isContr (Unit × Unit)
  isContrUnit× = (tt , tt) , λ _ → refl
