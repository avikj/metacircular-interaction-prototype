{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡ï‡‡∞‡Æ‡ ‚î ‡‡ï‡ ‡‡‡‡‡ ‡‡∞‡‡µ‡ ‡µ‡‡‡ø, ‡‡‡‡µ‡‡‡ ‡‡‡Ø‡‡‡‡Ø‡®‡‡‡ ‡
--
-- (one bridge carries everything, and bridges compose.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE ECONOMIC CLAIM OF THIS CORPUS, AS TERMS.  README's LAW section says
-- proof-of-transport "spends compute for an edge everybody uses forever",
-- and movement 55 says import IS identity, so one landed bridge amortizes
-- across every theorem of both banks.  Both sentences are exactly two
-- library facts standing together, and they are worth standing under one
-- name because the pair is the economics and neither alone is.
--
-- ¬ß‡ß ¬ ‡µ‡‡®‡Æ‡ ‚î a landed equivalence carries EVERY predicate.  There is no
-- hypothesis on `P`: not a set, not a prop, not decidable, not finite.
-- That absence is the non-rivalry: whatever anyone ever proves on one
-- bank crosses, including things nobody has stated yet.
--
-- ¬ß‡® ¬ ‡‡‡Ø‡ã‡ó‡ ‚î edges compose, and the composite is an edge.  So a route
-- is an edge, and a route of routes is an edge, and the toll of a
-- point about `Marga` calling a proof-length a toll).
--
-- ¬ß‡© ¬ ‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‚î and an edge inverts, so transport is two-way and the
-- round trip returns.  Road one is closed under composition and inverse.
------------------------------------------------------------------------

module Samkramana_AnEdgeCarriesEveryPredicateAndEdgesComposeSoTheRouteIsFree where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; compEquiv ; invEquiv ; idEquiv)
open import Cubical.Foundations.Univalence using (ua)

private variable ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡µ‡‡®‡Æ‡ ‚î one edge carries every predicate, with no hypothesis on it.
------------------------------------------------------------------------

‡§µ‡§π‡§®‡§Æ‡•ç : {A B : Type ‚Ñì} (P : Type ‚Ñì ‚Üí Type ‚Ñì') ‚Üí A ‚âÉ B ‚Üí P A ‚Üí P B
‡§µ‡§π‡§®‡§Æ‡•ç P e = subst P (ua e)

-- and back, because the edge inverts
‡§™‡•ç‡§∞‡§§‡§ø‡§µ‡§π‡§®‡§Æ‡•ç : {A B : Type ‚Ñì} (P : Type ‚Ñì ‚Üí Type ‚Ñì') ‚Üí A ‚âÉ B ‚Üí P B ‚Üí P A
‡§™‡•ç‡§∞‡§§‡§ø‡§µ‡§π‡§®‡§Æ‡•ç P e = subst P (sym (ua e))

------------------------------------------------------------------------
-- ‡® ¬ ‡‡‡Ø‡ã‡ó‡ ‚î a route is an edge.  Composition stays on road one, so
--     length costs nothing.
------------------------------------------------------------------------

‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : {A B C : Type ‚Ñì} ‚Üí A ‚âÉ B ‚Üí B ‚âÉ C ‚Üí A ‚âÉ C
‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É = compEquiv

-- a route of any length is still one edge: three, and the pattern is
-- visibly unbounded
‡§§‡•ç‡§∞‡§ø‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É : {A B C D : Type ‚Ñì} ‚Üí A ‚âÉ B ‚Üí B ‚âÉ C ‚Üí C ‚âÉ D ‚Üí A ‚âÉ D
‡§§‡•ç‡§∞‡§ø‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É e f g = ‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É (‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É e f) g

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‚î and the road is two-way, with the trivial edge at
--     every node.  Road one is closed under identity, composition and
--     inverse: it is a groupoid, and that is why routing on it is total.
------------------------------------------------------------------------

‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡§É : {A B : Type ‚Ñì} ‚Üí A ‚âÉ B ‚Üí B ‚âÉ A
‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡§É = invEquiv

‡§∏‡•ç‡§•‡§æ‡§®‡§Æ‡•ç : (A : Type ‚Ñì) ‚Üí A ‚âÉ A
‡§∏‡•ç‡§•‡§æ‡§®‡§Æ‡•ç = idEquiv

-- the round trip is an edge from a node to itself
‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç : {A B : Type ‚Ñì} ‚Üí A ‚âÉ B ‚Üí A ‚âÉ A
‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®‡§Æ‡•ç e = ‡§Æ‡§æ‡§∞‡•ç‡§ó‡§É e (‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡§É e)
