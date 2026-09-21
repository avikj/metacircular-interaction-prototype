{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TransportPrice
--
-- In `Anekanta`, collapse is settled (agreement permits it, plurality
-- blocks it); the question about two nayas is what a transport between
-- them COSTS.
--
-- It has an answer, and the answer is that the question is smaller than
-- it looks.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE THEOREM
--
-- Suppose a cost `c p q` on transports, subject only to the one thing any
-- cost must satisfy â” that going by way of a third standpoint costs the
-- sum:
--
--     c p q + c q r â‰¡ c p r.
--
-- Then, fixing any base standpoint b,
--
--     cocycleâ’coboundary :  c p q â‰¡ c b q âˆ’ c b p.
--
-- **Every additive transport price is the difference of a potential.**
-- There is no path-dependence to discover, no cheapest route between two
-- standpoints, no holonomy around a loop (`loop-is-free`).  All the
-- content is in the potential â” a number attached to each standpoint on
-- its own â” and choosing well means choosing an endpoint, never a route.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THE POTENTIAL IS
--
-- `Laghava` supplies it and also says what it cannot be:
--
--   * `size` is a potential: the price of a reformulation is the change
--     in à²à¾à˜àµ (`laghava-price` below);
--   * `laghava-is-not-semantic` proves no function of the DENOTATION
--     computes `size`.
--
-- Together: the price of a transport between two nayas is real, is
-- path-independent, and is invisible to every semantic invariant â” so a
-- corpus that checks only denotations has no access to it at all, while
-- a grammarian working on presentations has complete access.  That is the
-- whole of Pini's lghava discipline, in two theorems.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- AND WHY "PRICE" IS THE WRONG WORD FOR IT
--
-- The potential is not a fee anyone pays.  It is a coordinate on
-- presentations, and "the price of getting from p to q" is nothing but
-- the difference of two coordinates.  Nothing is spent; a reformulation
-- gains what the difference says and loses nothing, because by
-- `Apavada.Reformulation` the denotation is untouched.
-- `loop-is-free` is the theorem that
-- makes the objection precise.
------------------------------------------------------------------------

module TransportPrice where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (â„¤ ; pos ; _+_ ; _-_ ; -_)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import Laghava using (Expr ; size ; eval)

private
  variable
    â„“ : Level

private
  shift : (x y z : â„¤) â†’ x + y â‰¡ z â†’ y â‰¡ z - x
  shift x y z h = sym (lem x y) âˆ™ cong (_- x) h
    where
    lem : (a b : â„¤) â†’ (a + b) - a â‰¡ b
    lem a b = solve! â„¤CommRing

  idemâ†’zero : (x : â„¤) â†’ x + x â‰¡ x â†’ x â‰¡ pos 0
  idemâ†’zero x h = sym (lem x) âˆ™ cong (_- x) h âˆ™ self x
    where
    lem  : (a : â„¤) â†’ (a + a) - a â‰¡ a
    lem a = solve! â„¤CommRing
    self : (a : â„¤) â†’ a - a â‰¡ pos 0
    self a = solve! â„¤CommRing

------------------------------------------------------------------------
-- 1.  Additive costs on any type of standpoints
------------------------------------------------------------------------

Additive : {X : Type â„“} â†’ (X â†’ X â†’ â„¤) â†’ Type â„“
Additive {X = X} c = (p q r : X) â†’ c p q + c q r â‰¡ c p r

module _ {X : Type â„“} (c : X â†’ X â†’ â„¤) (add : Additive c) where

  -- staying put is free, and this is forced, not assumed
  self-is-free : (p : X) â†’ c p p â‰¡ pos 0
  self-is-free p = idemâ†’zero (c p p) (add p p p)

  -- THE THEOREM.  Every additive cost is the difference of a potential.
  cocycleâ†’coboundary : (b p q : X) â†’ c p q â‰¡ (c b q) - (c b p)
  cocycleâ†’coboundary b p q = shift (c b p) (c p q) (c b q) (add b p q)

  -- so a round trip costs nothing, whatever route it takes
  loop-is-free : (p q : X) â†’ c p q + c q p â‰¡ pos 0
  loop-is-free p q = add p q p âˆ™ self-is-free p

  -- and the reverse transport is the negation of the forward one
  reverse : (p q : X) â†’ c q p â‰¡ - (c p q)
  reverse p q = shift (c p q) (c q p) (pos 0) (loop-is-free p q) âˆ™ neg (c p q)
    where
    neg : (a : â„¤) â†’ (pos 0) - a â‰¡ - a
    neg a = solve! â„¤CommRing

------------------------------------------------------------------------
-- 2.  The potential, when the standpoints are presentations
------------------------------------------------------------------------

toâ„¤ : Expr â†’ â„¤
toâ„¤ e = pos (size e)

laghavaPrice : Expr â†’ Expr â†’ â„¤
laghavaPrice p q = (toâ„¤ q) - (toâ„¤ p)

laghava-additive : Additive laghavaPrice
laghava-additive p q r = tri (toâ„¤ p) (toâ„¤ q) (toâ„¤ r)
  where
  tri : (a b d : â„¤) â†’ (b - a) + (d - b) â‰¡ d - a
  tri a b d = solve! â„¤CommRing

-- so all four laws above hold of it, with no further work
laghava-loop-free : (p q : Expr) â†’ laghavaPrice p q + laghavaPrice q p â‰¡ pos 0
laghava-loop-free = loop-is-free laghavaPrice laghava-additive

------------------------------------------------------------------------
-- 3.  The answer, stated once.
--
-- What does a transport between two nayas cost?  Whatever the potential
-- says, and nothing else.  Additivity alone kills every path structure:
-- no route matters, no loop accumulates, and the reverse is the negation.
-- The question "what is the price of this transport" is therefore not a
-- question about the transport at all â” it is a question about the two
-- endpoints, asked in a roundabout way.
--
-- And by `Laghava.laghava-is-not-semantic`, the potential this corpus
-- actually cares about is not a function of the denotation.  So the
-- quantity is real, is entirely determined by where you are rather than
-- how you came, and is invisible to every check this repository performs.
------------------------------------------------------------------------
