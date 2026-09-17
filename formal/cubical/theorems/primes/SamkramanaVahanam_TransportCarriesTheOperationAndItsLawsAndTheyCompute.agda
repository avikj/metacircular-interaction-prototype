{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ààà•àà°à®à-àµàà¨à®à â” the concurrence carries the WHOLE structure, and the
-- carried structure COMPUTES.
--
-- `Samkramana` identified the pair â• — â• with the triple
-- ri-traya by univalence â” `yugmaâ‰¡ri-traya = ua (anuloma , viloma)` â”
-- and carried the successor `Î¦` across it.  A point rode the return.
--
-- This module rides an ALGEBRA across the same identity:
--
--   * a commutative monoid on â• — â• (componentwise addition, unit (0,0)),
--   * `transport`ed along `yugmaâ‰¡ri-traya` to an operation on
--     ri-traya, `_âŠµ_`;
--   * whose value is the anuloma/viloma-conjugated operation `_âŠ_`
--     (`carried-is-conjugate`), so it acts on the triples exactly as
--     Brahmagupta's sakramaa would demand â” and on concrete numerals it
--     REDUCES (`_ = refl`), which is cubical transport = uaÎ² made to run;
--   * and its associativity, commutativity and unit laws, transported
--     along the SAME path, so the laws on ri-traya are NOT reproved by
--     induction on the triple: they are the â• proofs MOVED.
--
-- This is NisvabhavaNet's `liberation` (transport of a predicate) raised
-- to a structure: where two standpoints are equivalent, everything
-- transports â” the points, the operations on them, AND the equations they
-- satisfy.  ààà¨à°àà•ààà¿à°à à¨ â” the theorem is carried, not copied; that is
-- the ààà¿ààà¾ move (ààà¿ààà¾-ààààà° Â§à: transport carrying its equivalence),
-- made total over an algebra.
--
-- CHECKED: Agda 2.8.0, cubical v0.9, --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module SamkramanaVahanam_TransportCarriesTheOperationAndItsLawsAndTheyCompute where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Transport using (transportâ»Transport)
open import Cubical.Data.Nat using (â„• ; zero ; _+_ ; +-assoc ; +-comm ; +-zero)
open import Cubical.Data.Sigma using (Î£PathP)

open import Samkramana
  using ( rÄÅ›i-traya ; anuloma ; viloma ; yugmaâ‰¡rÄÅ›i-traya ; _Ã—_ )

private
  P : (â„• Ã— â„•) â‰¡ rÄÅ›i-traya
  P = yugmaâ‰¡rÄÅ›i-traya

------------------------------------------------------------------------
-- The shapes a monoid is built from, as families over a type.  Each is
-- transported along `P` below; that is the whole point â” one path, and
-- the operation and every law ride it.
------------------------------------------------------------------------

Op : Type â†’ Type
Op T = T â†’ T â†’ T

Assoc : (T : Type) â†’ Op T â†’ Type
Assoc T _Â·_ = (x y z : T) â†’ ((x Â· y) Â· z) â‰¡ (x Â· (y Â· z))

Comm : (T : Type) â†’ Op T â†’ Type
Comm T _Â·_ = (x y : T) â†’ (x Â· y) â‰¡ (y Â· x)

LUnit : (T : Type) â†’ Op T â†’ T â†’ Type
LUnit T _Â·_ e = (x : T) â†’ (e Â· x) â‰¡ x

------------------------------------------------------------------------
-- The monoid on the PAIR side â” plain componentwise addition on â• — â•.
-- Associativity and commutativity are â•'s, componentwise; the unit is
-- (0 , 0) and the left-unit law is +-zero-free (0 + x â‰¡ x is `refl` in
-- this library's â•, so LUnit holds by ÎPathP of two refls).
------------------------------------------------------------------------

_âŠ_ : Op (â„• Ã— â„•)
(s , l) âŠ (s' , l') = (s + s') , (l + l')

âŠ-assoc : Assoc (â„• Ã— â„•) _âŠ_
âŠ-assoc (a , b) (c , d) (e , f) =
  Î£PathP (sym (+-assoc a c e) , sym (+-assoc b d f))

âŠ-comm : Comm (â„• Ã— â„•) _âŠ_
âŠ-comm (a , b) (c , d) = Î£PathP (+-comm a c , +-comm b d)

âŠ-lunit : LUnit (â„• Ã— â„•) _âŠ_ (zero , zero)
âŠ-lunit (a , b) = refl

------------------------------------------------------------------------
-- The carry.  Each object rides `P` by `transport`; the paths `âŠ-path`
-- etc. are the `transport-filler`s that connect the pair-side object to
-- its ri-traya image, and are the families along which the LAWS are
-- transported.
------------------------------------------------------------------------

_âŠáµ£_ : Op rÄÅ›i-traya
_âŠáµ£_ = transport (Î» i â†’ Op (P i)) _âŠ_

âŠ-path : PathP (Î» i â†’ Op (P i)) _âŠ_ _âŠáµ£_
âŠ-path = transport-filler (Î» i â†’ Op (P i)) _âŠ_

Îµáµ£ : rÄÅ›i-traya
Îµáµ£ = transport (Î» i â†’ P i) (zero , zero)

Îµ-path : PathP (Î» i â†’ P i) (zero , zero) Îµáµ£
Îµ-path = transport-filler (Î» i â†’ P i) (zero , zero)

-- the laws, MOVED â” no induction on ri-traya anywhere below.
âŠáµ£-assoc : Assoc rÄÅ›i-traya _âŠáµ£_
âŠáµ£-assoc = transport (Î» i â†’ Assoc (P i) (âŠ-path i)) âŠ-assoc

âŠáµ£-comm : Comm rÄÅ›i-traya _âŠáµ£_
âŠáµ£-comm = transport (Î» i â†’ Comm (P i) (âŠ-path i)) âŠ-comm

âŠáµ£-lunit : LUnit rÄÅ›i-traya _âŠáµ£_ Îµáµ£
âŠáµ£-lunit = transport (Î» i â†’ LUnit (P i) (âŠ-path i) (Îµ-path i)) âŠ-lunit

------------------------------------------------------------------------
-- The carried operation IS the conjugated one.  `_âŠ_` is what one writes
-- by hand: pull both triples back to pairs with viloma, add, push forward
-- with anuloma.  The transported `_âŠµ_` equals it â” the transport did the
-- conjugation itself.
------------------------------------------------------------------------

_âŠ›_ : Op rÄÅ›i-traya
u âŠ› v = anuloma ((viloma u) âŠ (viloma v))

carried-is-conjugate : (u v : rÄÅ›i-traya) â†’ (u âŠáµ£ v) â‰¡ (u âŠ› v)
carried-is-conjugate u v = refl

------------------------------------------------------------------------
-- And it RUNS.  The carried operation applied to concrete triples reduces
-- to the concrete answer by `refl` â” the type-checker normalises the
-- transport, so this is uaÎ² computing, not a lemma invoked.
------------------------------------------------------------------------

_ : (anuloma (3 , 4) âŠáµ£ anuloma (1 , 2)) â‰¡ anuloma (4 , 6)
_ = refl

_ : (anuloma (3 , 4) âŠ› anuloma (1 , 2)) â‰¡ anuloma (4 , 6)
_ = refl

-- the transported unit really is a left unit, on a concrete triple, by the
-- MOVED law â” not a fresh computation:
_ : (Îµáµ£ âŠáµ£ anuloma (5 , 6)) â‰¡ anuloma (5 , 6)
_ = âŠáµ£-lunit (anuloma (5 , 6))

------------------------------------------------------------------------
-- ààààà° à§à â” ààà¨à°à¾à—à®à¨à ààà¨àà¯-àµàà¯à¯àà¨ ààµ : the return is only at zero cost.
--
-- Carry the operation FORWARD along P to ri-traya, then BACK along
-- sym P, and it returns EXACTLY â” `âŠ-return` is a `refl`-free identity
-- proving the whole round trip is the identity on the operation.  The
-- identification is lossless: no receipt is owed for going across and
-- back.  This is à®àà•ààà¿à ààà¨àà¯-àµàà¯à¯à‹ à®à¾à°àà—à (ààààà° à§à) at the level of the
-- structure â” transport is the null path, and the null path conserves.
------------------------------------------------------------------------

âŠ-return : transport (Î» i â†’ Op (P (~ i))) _âŠáµ£_ â‰¡ _âŠ_
âŠ-return = transportâ»Transport (Î» i â†’ Op (P i)) _âŠ_
