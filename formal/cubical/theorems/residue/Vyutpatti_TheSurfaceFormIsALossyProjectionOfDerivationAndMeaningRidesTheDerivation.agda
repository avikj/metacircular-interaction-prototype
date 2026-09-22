{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àµàà¯àààààààà¿ â” the surface form is a lossy projection of derivation,
-- and meaning rides the derivation, not the surface.
--
-- (vyutpatti: the derivational formation of a word â” dhtu, root, plus
-- pratyaya, affix.  Classical vykaraa vocabulary, used for the objects
-- it names; the theorems are this corpus's, not attributed to any text.)
--
-- THE BRIDGE, stated as this machine's own law applied to language.
-- Human language reaches the machine at the SURFACE â” strings.  But in
-- the grammatical tradition a word IS its formation: dhtu + affixes,
-- with the meaning composed along the derivation (the kt and taddhita
-- pratyayas each carrying their semantic contribution).  That is
-- content-addressing: àµàà¯àààààààà¿ is the claim that the word's identity
-- is the hash of its construction â” which is this machine's identity
-- law, arrived at from the other end, ~2,500 years earlier.
--
-- The obstruction to the bridge is exactly a fibre: the map
--
--     surface : Derivation â’ String
--
-- is NOT injective â” sandhi and homonymy collapse distinct derivations
-- onto one string.  A pun (lea) is a two-point fibre of `surface`,
-- played deliberately.  So meaning CANNOT factor through the surface
-- (this module's theorem à¨: any factoring through a surface with a
-- collision forces two different meanings equal â” refuted by
-- exhibition), while meaning DOES factor through derivation by
-- construction (theorem à§: artha is a fold over the derivation).
--
-- Consequence for the endeavor: the humanâ”machine bridge cannot be
-- string-to-term; it must be derivation-to-term â” carry the vyutpatti,
-- not the spelling.  The Adhyy engine (interactive/Astadhyayi.hs)
-- already holds the lost material alongside the surface (sthnivadbhva,
-- lopa channels); this module is the abstract statement of WHY that
-- design is forced: recover-from-surface is exactly a section of a map
-- with inhabited multi-point fibres, and no such section exists.
--
-- The concrete witness is kept small and abstract (two derivations, one
-- surface, two arthas); a real  lea instantiates it â” the
-- classical stock example is the dual reading of `go` (cow / speech /
-- earth in compound contexts):
-- the mathematics needs only that ONE collision exists, and the engine's
-- own corpus supplies collisions mechanically (GhanaPatha prints them).
------------------------------------------------------------------------

module Vyutpatti_TheSurfaceFormIsALossyProjectionOfDerivationAndMeaningRidesTheDerivation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; true; false; trueâ‰¢false)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Data.Sigma using (Î£; _,_; _Ã—_)

-- A minimal derivational syntax: roots and one layer of affixation.
-- (The real tree is interactive/Astadhyayi.hs's; two constructors suffice
-- for the theorems, which are about the SHAPE of the situation.)
data Dhatu : Typeâ‚€ where
  dhA dhB : Dhatu

data Pratyaya : Typeâ‚€ where
  pK : Pratyaya

data Derivation : Typeâ‚€ where
  root  : Dhatu â†’ Derivation
  affix : Pratyaya â†’ Derivation â†’ Derivation

-- Meaning composes along the derivation â” a fold.  This is theorem à§
-- by construction: artha factors through Derivation.
data Artha : Typeâ‚€ where
  cowness speechness : Artha
  agentOf : Artha â†’ Artha

artha : Derivation â†’ Artha
artha (root dhA)     = cowness
artha (root dhB)     = speechness
artha (affix pK d)   = agentOf (artha d)

-- The surface: sandhi/homonymy collapse.  Both roots surface as the
-- same string â” the lea situation, minimally.
data Surface : Typeâ‚€ where
  go  : Surface            -- the colliding surface form
  gok : Surface            -- the affixed form (collapsed likewise)

surface : Derivation â†’ Surface
surface (root _)      = go
surface (affix pK _)  = gok

-- the collision, exhibited:
collision : surface (root dhA) â‰¡ surface (root dhB)
collision = refl

-- and the meanings genuinely differ:
isCow : Artha â†’ Bool
isCow cowness    = true
isCow _          = false

artha-differs : artha (root dhA) â‰¡ artha (root dhB) â†’ âŠ¥
artha-differs p = trueâ‰¢false (cong isCow p)

------------------------------------------------------------------------
-- à¨ Â MEANING CANNOT FACTOR THROUGH THE SURFACE.  Any m with
-- m âˆ˜ surface â‰¡ artha would equate the two arthas across the collision.
no-surface-semantics :
  Î£ (Surface â†’ Artha) (Î» m â†’ (d : Derivation) â†’ m (surface d) â‰¡ artha d)
  â†’ âŠ¥
no-surface-semantics (m , h) =
  artha-differs (sym (h (root dhA)) âˆ™ cong m collision âˆ™ h (root dhB))

------------------------------------------------------------------------
-- à© Â NO SECTION RECOVERS THE DERIVATION.  A reader of surfaces cannot
-- reconstruct the formation: any s with surface âˆ˜ s â‰¡ id picks ONE
-- point of each fibre, and the collision fibre has two â” so some
-- derivation is not recovered.  Stated as: no section can be right
-- about both colliding roots.
no-faithful-reader :
  Î£ (Surface â†’ Derivation)
    (Î» s â†’ (s go â‰¡ root dhA) Ã— (s go â‰¡ root dhB))
  â†’ âŠ¥
no-faithful-reader (s , hA , hB) = rootsDiffer (sym hA âˆ™ hB)
  where
  isA : Derivation â†’ Bool
  isA (root dhA) = true
  isA _          = false
  rootsDiffer : root dhA â‰¡ root dhB â†’ âŠ¥
  rootsDiffer p = trueâ‰¢false (cong isA p)
