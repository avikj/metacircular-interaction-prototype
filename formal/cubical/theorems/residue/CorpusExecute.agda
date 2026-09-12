{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module CorpusExecute where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Unit
open import CorpusCalculus using (point ; step)
open import CorpusSelfPresentation using (present)

infixr 5 _++_
_++_ : {A : Set} → List A → List A → List A
[]       ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

vArg : Term → Arg Term
vArg t = arg (arg-info visible (modality relevant quantity-ω)) t

fieldNames : List (Arg Name) → List Name
fieldNames [] = []
fieldNames (arg _ n ∷ fs) = n ∷ fieldNames fs

expandOne : Name → TC (List Name)
expandOne n = bindTC (getDefinition n) λ where
  (data-type _ cs)   → returnTC (n ∷ cs)
  (record-type c fs) → returnTC (n ∷ c ∷ fieldNames fs)
  _                  → returnTC (n ∷ [])

expandAll : List Name → TC (List Name)
expandAll []       = returnTC []
expandAll (n ∷ ns) =
  bindTC (expandOne n) λ here →
  bindTC (expandAll ns) λ rest →
  returnTC (here ++ rest)

termOf : Name → TC Term
termOf n = bindTC (getDefinition n) λ where
  (data-cons _ _) → returnTC (con n [])
  _               → returnTC (def n [])

applyNamed : Name → Term → TC Term
applyNamed f x =
  bindTC (getDefinition f) λ where
    (data-cons _ _) → returnTC (con f (vArg x ∷ []))
    _               → returnTC (def f (vArg x ∷ []))

-- A checked term is immediately a point of the universal calculus.  `present`
-- is coinductive: this term denotes the entire productive future, not a finite
-- prefix.  The runner only prints its root as an inspectable handle.
coinductivePresentation : Term → Term
coinductivePresentation x =
  def (quote present)
    (vArg (def (quote point) (vArg x ∷ [])) ∷ [])

emitRoot : Term → TC ⊤
emitRoot x =
  let p = coinductivePresentation x in
  withReconstructed true
    (noConstraints
      (bindTC (inferType x) λ xty →
       bindTC (inferType p) λ pty →
       debugPrint "corpus.presentation" 1
         (strErr "LOCUS " ∷ termErr x ∷ strErr " : " ∷ termErr xty ∷
          strErr "  INFINITE_PRESENTATION " ∷ termErr p ∷
          strErr " : " ∷ termErr pty ∷ [])))

-- Immediate named continuations are shown only as the current finite view.
-- Their continuation is NOT recursively unfolded: it is the coinductive
-- `present (point app)` value carried on the edge.
emitEdge : Name → Term → TC ⊤
emitEdge f x =
  bindTC (termOf f) λ ft →
  bindTC (applyNamed f x) λ app →
  let stepWitness = def (quote step) (vArg x ∷ vArg ft ∷ [])
      future      = coinductivePresentation app
  in catchTC
    (withReconstructed true
      (noConstraints
        (bindTC (inferType app) λ aty →
         bindTC (inferType stepWitness) λ sty →
         bindTC (inferType future) λ fty →
         debugPrint "corpus.presentation" 1
           (strErr "  EDGE --" ∷ nameErr f ∷ strErr "→ " ∷ termErr app ∷
            strErr " : " ∷ termErr aty ∷
            strErr "  STEP " ∷ termErr stepWitness ∷ strErr " : " ∷ termErr sty ∷
            strErr "  CONTINUATION " ∷ termErr future ∷ strErr " : " ∷ termErr fty ∷ []))))
    (returnTC tt)

emitEdges : List Name → Term → TC ⊤
emitEdges []       x = returnTC tt
emitEdges (f ∷ fs) x = bindTC (emitEdge f x) λ _ → emitEdges fs x

seedLoop : List Name → List Name → TC ⊤
seedLoop all []       = returnTC tt
seedLoop all (n ∷ ns) =
  bindTC (termOf n) λ t →
  bindTC (emitRoot t) λ _ →
  bindTC (emitEdges all t) λ _ →
  seedLoop all ns

-- Whole checked corpus at once: enumeration supplies the finite seed support;
-- each seed is mapped to one INFINITE coinductive presentation.  There is no
-- depth parameter and no claim that a finite prefix determines the object.
runCorpus : List Name → TC ⊤
runCorpus ns = bindTC (expandAll ns) λ expanded → seedLoop expanded expanded
