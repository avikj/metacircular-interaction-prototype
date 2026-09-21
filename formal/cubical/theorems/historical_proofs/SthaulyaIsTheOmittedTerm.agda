{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SthaulyaIsTheOmittedTerm
--
-- ààààà²àà¯ â” the coarseness of an àà¨àààà¯ààààà•à¾à° â” in closed form, for every
-- correction in the hierarchy at once.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS SETTLES
--
-- `AntyaSamskaraSthaulya` checks, one at a time, that the first four
-- end-corrections to Mdhava's series have ààààà²àà¯ numerator constant in
-- n.
-- This module proves it for every convergent, from the continued
-- fraction's determinant recurrence rather than from the list.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE STATEMENT
--
-- Take the continued fraction whose convergents the transmitted
-- corrections are (K. Krishna, arXiv:2405.11134),
--
--     1/(4n + 2Â²/(4n + 4Â²/(4n + 6Â²/(4n + â¦)))),
--
-- so the partial numerators are aâ = 1 and a_j = (2jâˆ’2)Â² for j â‰ 2, and
-- every partial denominator is 4n.  Generate its convergents h_k/k_k by
-- the standard recurrence and DO NOT reduce them.  Then for every k â‰ 1
-- and every n in every commutative ring,
--
--     (h_k(n)Âk_k(n+1) + h_k(n+1)Âk_k(n))Â(2n+1) âˆ’ k_k(n)Âk_k(n+1)
--        =  (âˆ’1)^(kâˆ’1) Â a_{k+1} Â (aâaââ‹¯a_k)
--        =  (âˆ’1)^(kâˆ’1) Â 4^k Â (k!)Â².
--
-- `sthaulya-closed` is the first equality, `sthaulya-value` the second,
-- and `sthaulya-independent` states the consequence bluntly: the left
-- side takes the same value at every n.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IT MEANS, AND WHY IT IS THE RIGHT SHAPE
--
-- The ààààà²àà¯ numerator is **the product of every partial numerator the
-- correction uses, times the first one it omits.**  Î_k is what was
-- taken; a_{k+1} is what was left behind.  A truncation error governed
-- by the first discarded term is the classical shape of a
-- continued-fraction remainder, and it is exactly what the Yuktibh's
-- criterion is selecting for: the text does not bound the error, it
-- names it and minimises it, and this is what it was minimising.
--
-- Two consequences, both immediate:
--
--   â CONSTANT IN n.  A correction that misses by a fixed integer is a
--     correction; one that misses by something growing with n is an
--     estimate.  All of them are corrections.
--   â EACH STEP IS THE LAST ONE TIMES THE TERM NEWLY OMITTED.
--     `sthaulya-ratio`: D_{k+1} = âˆ’a_{k+2}ÂD_k, an identity, no division
--     and no limit.  Unlike a residue this survives rescaling P and Q,
--     which is why Â§6 of the other module says no sequence of residues
--     can carry a law and this one can.
--
-- The order statement â” that the ààààà²àà¯ drops by two orders in n at each
-- step â” is the analytic gloss on the second bullet and is NOT proved
-- here.  It cannot be: see the closing section.
--
-- The proof is the determinant recurrence and nothing else.  The form
--
--     W(u,v) = (2n+1)(uâvâ + vâuâ) âˆ’ uâvâ
--
-- is bilinear in u = (h_i(n), k_i(n)) and v = (h_j(n+1), k_j(n+1)), so
-- the CF's three-term recurrence acts on the 2—2 block
--
--     ( W(k,k)    W(k,kâˆ’1)  )
--     ( W(kâˆ’1,k)  W(kâˆ’1,kâˆ’1))
--
-- by a transfer matrix on each side.  Carrying all four entries as one
-- invariant closes the induction; carrying only W(k,k) does not, which
-- is why the statement looked like it needed analysis and did not.  The
-- n-dependence cancels identically at each step â” `step11` is where it
-- happens â” and that cancellation IS the theorem.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- PROVENANCE
--
-- The corrections are transmitted in the Kerala texts, the *Yuktibh*
-- (Jyehadeva, c. 1530) and the *Tantrasagraha* tradition (Nlakaha,
-- 1501), attributed there to Mdhava (c. 1340â“1425).  The ààààà²àà¯
-- criterion is the tradition's.
-- The continued fraction
-- is Krishna's, who reports that the Kerala texts give no rationale for
-- the third correction.
--
------------------------------------------------------------------------

module SthaulyaIsTheOmittedTerm where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Sigma using (Î£ ; _,_ ; _Ã—_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
private variable â„“ : Level

module Sthaulya (R : CommRing â„“) where
  open CommRingStr (snd R)
  A : Type â„“
  A = fst R

  infixl 6 _âŠ–_
  _âŠ–_ : A â†’ A â†’ A
  x âŠ– y = x + (- y)

  two four : A
  two  = 1r + 1r
  four = two Â· two

  nat : â„• â†’ A
  nat zero    = 0r
  nat (suc k) = nat k + 1r

  sgn : â„• â†’ A
  sgn zero    = 1r
  sgn (suc k) = - (sgn k)

  pn : â„• â†’ A
  pn zero          = 0r
  pn (suc zero)    = 1r
  pn (suc (suc j)) = (two Â· nat (suc j)) Â· (two Â· nat (suc j))

  Î› : â„• â†’ A
  Î› zero    = 1r
  Î› (suc k) = Î› k Â· pn (suc k)

  hh kk : â„• â†’ A â†’ A
  hh zero          x = 0r
  hh (suc zero)    x = 1r
  hh (suc (suc i)) x = ((four Â· x) Â· hh (suc i) x) + (pn (suc (suc i)) Â· hh i x)
  kk zero          x = 1r
  kk (suc zero)    x = four Â· x
  kk (suc (suc i)) x = ((four Â· x) Â· kk (suc i) x) + (pn (suc (suc i)) Â· kk i x)

  mm : A â†’ A
  mm n = (two Â· n) + 1r

  W : â„• â†’ â„• â†’ A â†’ A
  W i j n = (mm n Â· ((hh i n Â· kk j (n + 1r)) + (hh j (n + 1r) Â· kk i n)))
            âŠ– (kk i n Â· kk j (n + 1r))

  ---------------------------------------------------------------- bilinearity

  bilin-l : (m x a p P q Q hj kj : A) â†’
      ((m Â· ((((x Â· p) + (a Â· P)) Â· kj) + (hj Â· ((x Â· q) + (a Â· Q)))))
        âŠ– (((x Â· q) + (a Â· Q)) Â· kj))
    â‰¡ (x Â· ((m Â· ((p Â· kj) + (hj Â· q))) âŠ– (q Â· kj)))
      + (a Â· ((m Â· ((P Â· kj) + (hj Â· Q))) âŠ– (Q Â· kj)))
  bilin-l m x a p P q Q hj kj = solve! R

  bilin-r : (m y a hi ki p' P' q' Q' : A) â†’
      ((m Â· ((hi Â· ((y Â· q') + (a Â· Q'))) + (((y Â· p') + (a Â· P')) Â· ki)))
        âŠ– (ki Â· ((y Â· q') + (a Â· Q'))))
    â‰¡ (y Â· ((m Â· ((hi Â· q') + (p' Â· ki))) âŠ– (ki Â· q')))
      + (a Â· ((m Â· ((hi Â· Q') + (P' Â· ki))) âŠ– (ki Â· Q')))
  bilin-r m y a hi ki p' P' q' Q' = solve! R

  W-left : (i j : â„•) (n : A) â†’
      W (suc (suc i)) j n
    â‰¡ ((four Â· n) Â· W (suc i) j n) + (pn (suc (suc i)) Â· W i j n)
  W-left i j n = bilin-l (mm n) (four Â· n) (pn (suc (suc i)))
                         (hh (suc i) n) (hh i n) (kk (suc i) n) (kk i n)
                         (hh j (n + 1r)) (kk j (n + 1r))

  W-right : (i j : â„•) (n : A) â†’
      W i (suc (suc j)) n
    â‰¡ ((four Â· (n + 1r)) Â· W i (suc j) n) + (pn (suc (suc j)) Â· W i j n)
  W-right i j n = bilin-r (mm n) (four Â· (n + 1r)) (pn (suc (suc j)))
                          (hh i n) (kk i n)
                          (hh (suc j) (n + 1r)) (hh j (n + 1r))
                          (kk (suc j) (n + 1r)) (kk j (n + 1r))

  ---------------------------------------------------------------- closed forms

  C00 C10 C01 C11 : â„• â†’ A â†’ A
  C00 k n = sgn (suc k) Â· Î› (suc k)
  C10 k n = (sgn (suc k) Â· Î› (suc k)) Â· (mm n âŠ– (two Â· nat (suc k)))
  C01 k n = (sgn (suc k) Â· Î› (suc k)) Â· (mm n + (two Â· nat (suc k)))
  C11 k n = (- (sgn (suc k))) Â· (Î› (suc k) Â· pn (suc (suc k)))

  ---------------------------------------------------------------- step identities

  step10 : (n s L Îº : A) â†’
      ((four Â· n) Â· ((- s) Â· (L Â· ((two Â· Îº) Â· (two Â· Îº)))))
      + (((two Â· Îº) Â· (two Â· Îº)) Â· ((s Â· L) Â· (((two Â· n) + 1r) + (two Â· Îº))))
    â‰¡ ((- s) Â· (L Â· ((two Â· Îº) Â· (two Â· Îº))))
      Â· (((two Â· n) + 1r) âŠ– (two Â· (Îº + 1r)))
  step10 n s L Îº = solve! R

  step01 : (n s L Îº : A) â†’
      ((four Â· (n + 1r)) Â· ((- s) Â· (L Â· ((two Â· Îº) Â· (two Â· Îº)))))
      + (((two Â· Îº) Â· (two Â· Îº)) Â· ((s Â· L) Â· (((two Â· n) + 1r) âŠ– (two Â· Îº))))
    â‰¡ ((- s) Â· (L Â· ((two Â· Îº) Â· (two Â· Îº))))
      Â· (((two Â· n) + 1r) + (two Â· (Îº + 1r)))
  step01 n s L Îº = solve! R

  step11 : (n s L Îº : A) â†’
      ((four Â· (n + 1r))
        Â· (((- s) Â· (L Â· ((two Â· Îº) Â· (two Â· Îº))))
            Â· (((two Â· n) + 1r) âŠ– (two Â· (Îº + 1r)))))
      + (((two Â· Îº) Â· (two Â· Îº))
        Â· (((four Â· n) Â· ((s Â· L) Â· (((two Â· n) + 1r) âŠ– (two Â· Îº))))
            + (((two Â· Îº) Â· (two Â· Îº)) Â· (s Â· L))))
    â‰¡ (- (- s)) Â· ((L Â· ((two Â· Îº) Â· (two Â· Îº)))
                    Â· ((two Â· (Îº + 1r)) Â· (two Â· (Îº + 1r))))
  step11 n s L Îº = solve! R

  ---------------------------------------------------------------- base

  base00 : (n : A) â†’ W 0 0 n â‰¡ C00 0 n
  base00 n = solve! R
  base10 : (n : A) â†’ W 1 0 n â‰¡ C10 0 n
  base10 n = solve! R
  base01 : (n : A) â†’ W 0 1 n â‰¡ C01 0 n
  base01 n = solve! R
  base11 : (n : A) â†’ W 1 1 n â‰¡ C11 0 n
  base11 n = solve! R

  ---------------------------------------------------------------- the induction

  Inv : â„• â†’ A â†’ Type â„“
  Inv k n = (W k k n â‰¡ C00 k n)
          Ã— ((W (suc k) k n â‰¡ C10 k n)
          Ã— ((W k (suc k) n â‰¡ C01 k n)
          Ã— (W (suc k) (suc k) n â‰¡ C11 k n)))

  inv : (k : â„•) (n : A) â†’ Inv k n
  inv zero n = base00 n , base10 n , base01 n , base11 n
  inv (suc k) n = e00' , e10' , e01' , e11'
    where
      ih  = inv k n
      e00 = fst ih
      e10 = fst (snd ih)
      e01 = fst (snd (snd ih))
      e11 = snd (snd (snd ih))

      e00' : W (suc k) (suc k) n â‰¡ C00 (suc k) n
      e00' = e11

      e10' : W (suc (suc k)) (suc k) n â‰¡ C10 (suc k) n
      e10' = W-left k (suc k) n
           âˆ™ congâ‚‚ (Î» u v â†’ ((four Â· n) Â· u) + (pn (suc (suc k)) Â· v)) e11 e01
           âˆ™ step10 n (sgn (suc k)) (Î› (suc k)) (nat (suc k))

      e01' : W (suc k) (suc (suc k)) n â‰¡ C01 (suc k) n
      e01' = W-right (suc k) k n
           âˆ™ congâ‚‚ (Î» u v â†’ ((four Â· (n + 1r)) Â· u) + (pn (suc (suc k)) Â· v)) e11 e10
           âˆ™ step01 n (sgn (suc k)) (Î› (suc k)) (nat (suc k))

      q : W (suc (suc k)) k n
        â‰¡ ((four Â· n) Â· C10 k n) + (pn (suc (suc k)) Â· C00 k n)
      q = W-left k k n
        âˆ™ congâ‚‚ (Î» u v â†’ ((four Â· n) Â· u) + (pn (suc (suc k)) Â· v)) e10 e00

      e11' : W (suc (suc k)) (suc (suc k)) n â‰¡ C11 (suc k) n
      e11' = W-right (suc (suc k)) k n
           âˆ™ congâ‚‚ (Î» u v â†’ ((four Â· (n + 1r)) Â· u) + (pn (suc (suc k)) Â· v)) e10' q
           âˆ™ step11 n (sgn (suc k)) (Î› (suc k)) (nat (suc k))

  ---------------------------------------------------------------- the theorem

  sthaulya-closed :
    (k : â„•) (n : A) â†’
      W (suc k) (suc k) n â‰¡ (- (sgn (suc k))) Â· (Î› (suc k) Â· pn (suc (suc k)))
  sthaulya-closed k n = snd (snd (snd (inv k n)))

  ---------------------------------------------------------------- explicit value

  fourPow : â„• â†’ A
  fourPow zero    = 1r
  fourPow (suc k) = four Â· fourPow k

  fct : â„• â†’ A
  fct zero    = 1r
  fct (suc k) = fct k Â· nat (suc k)

  Î›shift : (F f Î¼ : A) â†’
      (F Â· (f Â· f)) Â· ((two Â· Î¼) Â· (two Â· Î¼))
    â‰¡ (four Â· F) Â· ((f Â· Î¼) Â· (f Â· Î¼))
  Î›shift F f Î¼ = solve! R

  base-Î› : Î› 1 Â· pn 2 â‰¡ fourPow 1 Â· (fct 1 Â· fct 1)
  base-Î› = solve! R

  Î›-closed : (k : â„•) â†’
      Î› (suc k) Â· pn (suc (suc k)) â‰¡ fourPow (suc k) Â· (fct (suc k) Â· fct (suc k))
  Î›-closed zero    = base-Î›
  Î›-closed (suc k) =
      cong (_Â· ((two Â· nat (suc (suc k))) Â· (two Â· nat (suc (suc k))))) (Î›-closed k)
    âˆ™ Î›shift (fourPow (suc k)) (fct (suc k)) (nat (suc (suc k)))

  sthaulya-value :
    (k : â„•) (n : A) â†’
      W (suc k) (suc k) n
    â‰¡ (- (sgn (suc k))) Â· (fourPow (suc k) Â· (fct (suc k) Â· fct (suc k)))
  sthaulya-value k n = sthaulya-closed k n âˆ™ cong ((- (sgn (suc k))) Â·_) (Î›-closed k)

  sthaulya-independent :
    (k : â„•) (n n' : A) â†’ W (suc k) (suc k) n â‰¡ W (suc k) (suc k) n'
  sthaulya-independent k n n' = sthaulya-closed k n âˆ™ sym (sthaulya-closed k n')

  ----------------------------------------------------------------------
  -- The step law, which is the exact form of "the correction improves".
  --
  -- Each correction's coarseness is the previous one's, multiplied by
  -- MINUS THE TERM NEWLY OMITTED.  No division and no limit: it is an
  -- identity between the two ààààà²àà¯ numerators.
  ----------------------------------------------------------------------

  ratioLemma : (s L a A : A) â†’
      (- (- s)) Â· ((L Â· a) Â· A) â‰¡ (- A) Â· ((- s) Â· (L Â· a))
  ratioLemma s L a A = solve! R

  sthaulya-ratio :
    (k : â„•) (n : A) â†’
      W (suc (suc k)) (suc (suc k)) n
    â‰¡ (- (pn (suc (suc (suc k))))) Â· W (suc k) (suc k) n
  sthaulya-ratio k n =
      sthaulya-closed (suc k) n
    âˆ™ ratioLemma (sgn (suc k)) (Î› (suc k))
                 (pn (suc (suc k))) (pn (suc (suc (suc k))))
    âˆ™ cong ((- (pn (suc (suc (suc k))))) Â·_) (sym (sthaulya-closed k n))

------------------------------------------------------------------------
--
-- THE ORDER STATEMENT: that
-- the ààààà²àà¯ "drops by exactly two
-- orders in n at each step", on the ground that deg k_k = k makes it a
-- constant over a polynomial of degree 2k+1.
--
-- That statement is not checkable in this
-- lane.  Everything above is an identity between ring elements, and a
-- commutative ring has no notion of degree, of leading coefficient, or
-- of order at infinity.  Cross-multiplying is exactly the move that
-- discards them â” which is what makes the constancy theorem provable
-- without analysis, and what makes the order statement unavailable by
-- the same act.
--
-- `sthaulya-ratio` is the exact
-- statement the loose one was reaching for:
--
--     D_{k+1}  =  âˆ’a_{k+2} Â D_k
--
-- each coarseness is the previous one times minus the newly omitted
-- partial numerator.  "Two orders" is the analytic gloss on that; the
-- identity is the thing.
------------------------------------------------------------------------

open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)

open Sthaulya â„¤CommRing
  using (W ; sthaulya-closed ; sthaulya-value ; sthaulya-independent ; sthaulya-ratio)
