{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ApavadaVisaya_TheLineWorldCorollaryPinsItsObservableUpToScalar
--
-- àààµà¾à¦àµà¿àà¯ â” *the scope of the exception*.  à‰àààà°àà— / àààµà¾à¦, the general
-- rule and the special rule that blocks it, is Pini's (Adhyy, c. 500
-- BCE); àµà¿àà¯, the domain over which a rule actually applies, is the
-- commentators' term for the question this module answers (Patajali,
-- Mahbhya, c. 150 BCE, uses it throughout for a rule's field of
-- application). The  names the SHAPE of the question â” *a special
-- rule was promoted to a general one; what exactly was its scope?* â” because
-- the grammarians posed that question as a technical one and this corpus has
-- been posing it informally.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS MODULE ADDS, AND TO WHAT
--
-- `notes/ENCOUNTERED_WORLDS.md` Â§3.5 states, and proves:
--
--   **Theorem.**  If `T_E(x)` is a linear subspace `L âŠ (â/p)^n`, then
--   transport at `x` âŸº `grad f(x)|_L` is not identically zero.
--
--   **Corollary (line worlds).**  For `f = X+Y` and `E = {(a, sa)}`, the
--   tangent set is `span{(1,s)}` and `grad f|_L (t) = t(1+s)`.  So `E`
--   transports **iff `s â‰  -1 (mod p)`**.
--
-- `notes/FULL_READ_DRAW_5.md` Â§C2 records that a summary message dropped
-- the two words "For `f = X+Y`" under a Theorem quantified over all
-- integral `f`.  `NaturalMachine.LineWorldTransport` makes the corollary's
-- hypothesis part of a type, and exhibits ONE counterexample to the
-- dropped reading: for `f = X`, `grad f|_L(t) = t`, so every line world
-- transports, at `s = -1` included.
-- `NaturalMachine.Control.QuantifierDrop` is the must-fail control.
--
-- The corpus therefore records: *there exists an `f` for which the
-- corollary fails.*  It does not record HOW MANY, or WHICH.  That is the
-- àààµà¾à¦àµà¿àà¯ question, and it has an exact answer at every prime.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE THEOREM, FOR EVERY PRIME (written proof; Â§4 below checks p = 5
-- exhaustively as a closed computation)
--
-- Let `p` be prime, `f = câX + câY` a linear observable over â/p, and
-- `E = {(a, sa)}`.  By Â§3.5's Theorem, `E` transports iff
-- `grad f|_L â‰ 0`, i.e. iff `câ + câ s â‰ 0 (mod p)`.  Write
--
--     Z(f) = { s âˆˆ â/p : câ + câ s â‰¡ 0 }.
--
-- The corollary asserts `transports âŸº s â‰ -1`, so corollary and truth
-- agree at every slope exactly when `Z(f) = {-1}`.
--
--   * `câ â‰  0`.  â/p is a field, so `câ + câ s = 0` has the unique root
--     `s = -câcââ»Â` and `Z(f)` is a singleton.  It is `{-1}` iff
--     `-câcââ»Â = -1`, i.e. iff `câ = câ`.
--   * `câ = 0`, `câ â‰  0`.  `Z(f) = âˆ â‰  {-1}`.
--   * `câ = câ = 0`.  `Z(f) = â/p â‰  {-1}`, since `p â‰ 2`.
--
--     **The line-world corollary holds for `f = câX + câY` if and only
--     if `câ = câ â‰  0`** â” that is, iff `f` is a NONZERO SCALAR MULTIPLE
--     of `X+Y`.                                                      âˆ
--
-- So the hypothesis "For `f = X+Y`" is not merely sufficient.  Within the
-- linear family it is **necessary, and it pins `f` up to a scalar**: the
-- corollary is a complete characterisation of its own observable.  The
-- dropped-quantifier reading is false on exactly `pÂ² - (p-1)` of the `pÂ²`
-- linear observables â” 21 of 25 at `p = 5`.
--
-- This strictly strengthens `LineWorldTransport.dropped-hypothesis-false`,
-- which exhibits one witness.  It does not correct it; it locates it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHERE PRIMALITY ENTERS, AND TWO LITERATURES THAT SAY SO
--
-- Â§3.5's proof turns on one step: *"`{grad f(x)Âh : h âˆˆ L}` is a subgroup
-- of â/p, hence `{0}` or all of â/p."*  That dichotomy is primality and
-- nothing else.  In â/N with `N` composite, a nonzero `g` generates the
-- subgroup of index `gcd(g,N)`, so transport can fail with `grad â‰ 0`:
-- at `N = 4`, `g = 2`, target `3`, the attainable set is `{0,2}` and `3`
-- is not in it.  This is not a correction to Â§3.5 â” the note is p-adic
-- throughout â” it is a statement of where its hypothesis is load-bearing.
--
-- Two literatures had to confront exactly the
-- composite case the corpus never enters, and each records a result:
--
--   * **Music and tuning theory.**  A cyclic division into `N` steps, and
--     a fixed interval of `g` steps: the chain of that interval visits
--     `N / gcd(g,N)` pitch classes and then closes.  The tradition works
--     at composite `N` and therefore had to face this.  Bharata,
--     *Nyastra* ch. 28 (c. 200 BCE â“ 200 CE) establishes the 22
--     rutis by the *sra* procedure â” two vs identically tuned, one
--     displaced one ruti at a time, coincidences observed; the fourfold
--     form *sra-catuaya* is set out in Abhinavagupta's
--     *Abhinavabhrat* (c. 1000 CE) at N 28.26.  On the resulting
--     4-3-2-4-4-3-2 division, aja and pacama are separated by 13 of
--     the 22 steps, and `gcd(13,22) = 1`, so the chain of pacamas
--     exhausts all 22; a chain of 4 steps has `gcd(4,22) = 2` and closes
--     early into two disjoint circles.  rgadeva,
--     *Sagtaratnkara* I (c. 1210â“1247 CE), tabulates the division.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS MODULE DELIBERATELY DOES NOT DO
--
-- It does NOT widen `LineWorldTransport.Obs` from two constructors to the
-- full linear family, although that is where the mathematics wants to
-- live.  `Obs` is the quantification domain of the must-fail control
-- `Control/QuantifierDrop.agda`, whose designed failure is pinned to a
-- verbatim error message under two toolchains
-- (`notes/PIN_SWEEP_NATURALMACHINE.md` Â§4, Agda 2.8.0 + cubical v0.9;
-- and the container, Agda 2.6.3 + cubical v0.5).  Adding constructors to
-- `Obs` changes how `transports f s` reduces on an open `f` and can move
-- or destroy that error site.  So this module IMPORTS `Slope`, `mod5`,
-- `attains`, `crit`, `eqâ•` and works over its own `Lin`; every statement
-- below is about the corpus's own `attains` and `crit`, not about copies.
------------------------------------------------------------------------

module NaturalMachine.ApavadaVisaya_TheLineWorldCorollaryPinsItsObservableUpToScalar where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_)
open import Cubical.Data.Bool.Properties using (trueâ‰¢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

open import NaturalMachine.LineWorldTransport
  using (Slope ; s0 ; s1 ; s2 ; s3 ; s4 ; val ; mod5 ; eqâ„• ; attains ; crit)

private
  eqB : Bool â†’ Bool â†’ Bool
  eqB true  true  = true
  eqB false false = true
  eqB _     _     = false

  falseâ‰¢true : Â¬ (false â‰¡ true)
  falseâ‰¢true q = trueâ‰¢false (sym q)

------------------------------------------------------------------------
-- 1.  THE FULL LINEAR OBSERVABLE FAMILY over â/5.
--
-- `LineWorldTransport.Obs` carries two observables, the two the audit
-- contrasted.  A linear observable `f = câX + câY` is exactly its pair of
-- gradient coefficients, and over â/5 there are 25 of them.  Coefficients
-- are reused as `Slope` because both range over â/5.

Lin : Type
Lin = Slope Ã— Slope

-- `grad f|_L(1) = câ + câÂs`, the same computation as
-- `LineWorldTransport.grad`, over the full family.
gradL : Lin â†’ Slope â†’ â„•
gradL (a , b) s = mod5 (val a + val b Â· val s)

transportsL : Lin â†’ Slope â†’ Bool
transportsL f s = attains (gradL f s)

------------------------------------------------------------------------
-- 2.  àà¾à°àà¾ â” WHICH CHAINS EXHAUST THE CYCLE.
--
-- `attains g` asks whether the target `-1 = 4` lies in `{tÂg : t âˆˆ â/5}`,
-- i.e. whether the chain of the interval `g` reaches a given step of the
-- cycle.  At a PRIME modulus the answer is degenerate: every nonzero
-- interval exhausts the cycle, so `attains` is just "`g` is nonzero".
--
-- This is the whole content of Â§3.5's step "hence `{0}` or all of â/p",
-- and it is where primality does its work.  In the tuning literature the
-- modulus is composite (12, 22) and the corresponding statement is the
-- gcd law, which does not degenerate; see the header.

sarana-at-a-prime : (s : Slope) â†’ attains (val s) â‰¡ not (eqâ„• (val s) 0)
sarana-at-a-prime s0 = refl
sarana-at-a-prime s1 = refl
sarana-at-a-prime s2 = refl
sarana-at-a-prime s3 = refl
sarana-at-a-prime s4 = refl

------------------------------------------------------------------------
-- 3.  THE TWO PREDICATES BEING COMPARED.
--
-- `agrees f` : does the corollary's criterion `s â‰ -1` agree with actual
-- transport at every one of the five slopes?  Decided by exhaustion, so
-- every proof below is a closed computation and `refl`.
--
-- `scalarOfXY f` : is `f` a nonzero scalar multiple of `X+Y`, i.e.
-- `câ = câ â‰  0`?

agrees : Lin â†’ Bool
agrees f =
      eqB (transportsL f s0) (crit s0)
  and eqB (transportsL f s1) (crit s1)
  and eqB (transportsL f s2) (crit s2)
  and eqB (transportsL f s3) (crit s3)
  and eqB (transportsL f s4) (crit s4)

scalarOfXY : Lin â†’ Bool
scalarOfXY (a , b) = eqâ„• (val a) (val b) and not (eqâ„• (val a) 0)

------------------------------------------------------------------------
-- 4.  THE àààµà¾à¦àµà¿àà¯ THEOREM at p = 5, exhaustively: the corollary's
--     criterion is correct for a linear observable EXACTLY WHEN that
--     observable is a nonzero scalar multiple of `X+Y`.
--
--     Twenty-five closed cases, twenty-five `refl`.  This is the p = 5
--     instance of the written proof in the header.

visaya : (f : Lin) â†’ agrees f â‰¡ scalarOfXY f
visaya (s0 , s0) = refl
visaya (s0 , s1) = refl
visaya (s0 , s2) = refl
visaya (s0 , s3) = refl
visaya (s0 , s4) = refl
visaya (s1 , s0) = refl
visaya (s1 , s1) = refl
visaya (s1 , s2) = refl
visaya (s1 , s3) = refl
visaya (s1 , s4) = refl
visaya (s2 , s0) = refl
visaya (s2 , s1) = refl
visaya (s2 , s2) = refl
visaya (s2 , s3) = refl
visaya (s2 , s4) = refl
visaya (s3 , s0) = refl
visaya (s3 , s1) = refl
visaya (s3 , s2) = refl
visaya (s3 , s3) = refl
visaya (s3 , s4) = refl
visaya (s4 , s0) = refl
visaya (s4 , s1) = refl
visaya (s4 , s2) = refl
visaya (s4 , s3) = refl
visaya (s4 , s4) = refl

-- The corollary's own observable is in scope, as the corpus has it.
XY-is-in-the-visaya : agrees (s1 , s1) â‰¡ true
XY-is-in-the-visaya = refl

-- And so are its three nonzero scalar multiples â” the corollary does NOT
-- pin `f` on the nose, only up to a scalar.
2XY-is-in-the-visaya : agrees (s2 , s2) â‰¡ true
2XY-is-in-the-visaya = refl

3XY-is-in-the-visaya : agrees (s3 , s3) â‰¡ true
3XY-is-in-the-visaya = refl

4XY-is-in-the-visaya : agrees (s4 , s4) â‰¡ true
4XY-is-in-the-visaya = refl

-- Anything with `câ â‰  câ`, or with `câ = câ = 0`, is outside it.
outside-the-visaya : (f : Lin) â†’ agrees f â‰¡ true â†’ scalarOfXY f â‰¡ true
outside-the-visaya f h = sym (visaya f) âˆ™ h

------------------------------------------------------------------------
-- 5.  THE FAILURE HAS SHAPES, NOT A SHAPE.
--
-- `LineWorldTransport` records that the criterion "names the wrong set"
-- for `f = X`.  It names a DIFFERENT wrong set for each observable
-- outside the viaya, and the sets are not nested.  `disagreeAt f` is the
-- indicator of the disagreement, slope by slope.

disagreeAt : Lin â†’ Bool Ã— Bool Ã— Bool Ã— Bool Ã— Bool
disagreeAt f = d s0 , d s1 , d s2 , d s3 , d s4
  where
  d : Slope â†’ Bool
  d s = not (eqB (transportsL f s) (crit s))

-- `f = X`, gradient `(1,0)`: the criterion is wrong at `s = -1` only.
shape-X : disagreeAt (s1 , s0) â‰¡ (false , false , false , false , true)
shape-X = refl

-- `f = Y`, gradient `(0,1)`: wrong at `s = 0` AND at `s = -1`.
shape-Y : disagreeAt (s0 , s1) â‰¡ (true , false , false , false , true)
shape-Y = refl

-- `f = 0`, gradient `(0,0)`: wrong at every slope EXCEPT `s = -1`, the
-- one slope the criterion excludes.  The criterion is exactly inverted.
shape-zero : disagreeAt (s0 , s0) â‰¡ (true , true , true , true , false)
shape-zero = refl

-- The three are pairwise distinct, so "the criterion names the wrong set"
-- is a family of statements, not one.
Xâ‰ Y : Â¬ (disagreeAt (s1 , s0) â‰¡ disagreeAt (s0 , s1))
Xâ‰ Y q = falseâ‰¢true (cong fst q)

Xâ‰ zero : Â¬ (disagreeAt (s1 , s0) â‰¡ disagreeAt (s0 , s0))
Xâ‰ zero q = falseâ‰¢true (cong fst q)

Yâ‰ zero : Â¬ (disagreeAt (s0 , s1) â‰¡ disagreeAt (s0 , s0))
Yâ‰ zero q = falseâ‰¢true (cong (Î» t â†’ fst (snd t)) q)

------------------------------------------------------------------------
-- 6.  THE SENTENCE.
--
-- The dropped hypothesis was not a hypothesis that happened to be needed.
-- It was a complete description of the corollary's viaya: the criterion
-- `s â‰ -1` is correct for a linear observable if and only if that
-- observable is a nonzero scalar multiple of the one named in the
-- hypothesis.  Dropping "For `f = X+Y`" from the corollary does not
-- overreach by a margin.  It overreaches onto 21 of 25 observables at
-- `p = 5`, and onto `pÂ² - (p-1)` of `pÂ²` at every prime, in `pÂ²-p+1`
-- distinct failure shapes at most â” one per distinct zero-set of a
-- linear form, plus the constant.
--
-- `Control/QuantifierDrop.agda` is therefore testing a maximal claim: the
-- statement it asserts is false as widely as a statement of that form can
-- be, and remains false however `Obs` is enlarged inside the linear
-- family, since the corollary's truth set is fixed at four observables.
------------------------------------------------------------------------
