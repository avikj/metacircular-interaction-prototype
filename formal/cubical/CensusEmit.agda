{-# OPTIONS --cubical --guardedness #-}
------------------------------------------------------------------------
-- CensusEmit — serialize reflected corpus type-Terms to bend `Shape`
-- literals, so the corpus's own FutureEq quotient can be COMPUTED by
-- evaluation on the interaction-net runtime (census.bend), rather than
-- only proved total in Agda (where the SetQuotient OOMs).
--
-- headCode / children here are exactly the observation and step of
-- ReflectedFormation's future-behavior machine.  A `Shape` records, per
-- node, its headCode and the shapes of its children — everything (and
-- only what) FutureEq observes.
------------------------------------------------------------------------
module CensusEmit where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.String
open import Agda.Builtin.Nat
open import Agda.Builtin.Unit

-- the corpus modules whose declarations we reflect (kept small + real)
import AskingIsNotAPropertyOfTheFunction as M0

------------------------------------------------------------------------
-- observation (headCode) and step (children) — inlined to avoid the
-- two same-named ReflectedFormation modules clashing.
------------------------------------------------------------------------
headCode : Term → Nat
headCode (var _ _)      = 0
headCode (con _ _)      = 1
headCode (def _ _)      = 2
headCode (lam _ _)      = 3
headCode (pat-lam _ _)  = 4
headCode (pi _ _)       = 5
headCode (agda-sort _)  = 6
headCode (lit _)        = 7
headCode (meta _ _)     = 8
headCode unknown        = 9

argTerms : List (Arg Term) → List Term
argTerms []             = []
argTerms (arg _ t ∷ as) = t ∷ argTerms as

children : Term → List Term
children (var _ as)            = argTerms as
children (con _ as)            = argTerms as
children (def _ as)            = argTerms as
children (lam _ (abs _ t))     = t ∷ []
children (pat-lam _ as)        = argTerms as
children (pi (arg _ a) (abs _ b)) = a ∷ b ∷ []
children (agda-sort (set t))   = t ∷ []
children (agda-sort (prop t))  = t ∷ []
children (agda-sort _)         = []
children (lit _)               = []
children (meta _ as)           = argTerms as
children unknown               = []

------------------------------------------------------------------------
-- serialization to a bend Shape literal:  @N{<code>n, k1 <> k2 <> []}
------------------------------------------------------------------------
digit : Nat → String
digit 0 = "0n"
digit 1 = "1n"
digit 2 = "2n"
digit 3 = "3n"
digit 4 = "4n"
digit 5 = "5n"
digit 6 = "6n"
digit 7 = "7n"
digit 8 = "8n"
digit _ = "9n"

-- fuel-bounded (structurally terminating on the Nat).  Corpus type Terms
-- are far shallower than the fuel, so no truncation occurs in practice.
shapeStr : Nat → Term → String
kidsStr  : Nat → List Term → String
shapeStr zero    t = primStringAppend "@N{" (primStringAppend (digit (headCode t)) ", []}")
shapeStr (suc f) t = primStringAppend "@N{"
                     (primStringAppend (digit (headCode t))
                     (primStringAppend ", "
                     (primStringAppend (kidsStr f (children t)) "}")))
kidsStr _ []       = "[]"
kidsStr f (t ∷ ts) = primStringAppend (shapeStr f t)
                     (primStringAppend " <> " (kidsStr f ts))

------------------------------------------------------------------------
-- reflect a list of Names → one bend list literal of their type-shapes
------------------------------------------------------------------------
joinShapes : List Name → String → TC String
joinShapes [] acc = returnTC (primStringAppend acc "[]")
joinShapes (n ∷ ns) acc =
  bindTC (getType n) λ ty →
  joinShapes ns (primStringAppend acc
                 (primStringAppend (shapeStr 100 ty) " <> "))

macro
  emitShapes : List Name → Term → TC ⊤
  emitShapes ns _ =
    bindTC (joinShapes ns "") λ s →
    typeError (strErr "BEND_SHAPES_BEGIN\n" ∷ strErr s ∷ strErr "\nBEND_SHAPES_END" ∷ [])

-- Fire the emit.  The names are real corpus declarations; the type error
-- carries the serialized bend list on stderr, which census.bend consumes.
_emit_ : ⊤
_emit_ = emitShapes
  ( quote M0.verdict
  ∷ quote M0.ask
  ∷ quote M0.askℕ
  ∷ quote M0.askBool
  ∷ quote M0.peel
  ∷ quote M0.peel-step
  ∷ quote M0.peel-diagonal
  ∷ quote M0.peel-off
  ∷ quote M0.same
  ∷ quote M0.sameFunction
  ∷ quote M0.ask-step
  ∷ quote M0.run
  ∷ quote M0.asks
  ∷ [] )
