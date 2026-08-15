{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WalkFastInstance
--
-- STATUS, 2026-08-15, second revision.  The header this file carried
-- until today claimed the instances and had never typechecked; the
-- retraction that replaced it was correct and is preserved at the foot
-- of this comment.  The claim is now MADE GOOD: the three instances
--
--   next-8  : next 8  ≡ 9     (the interval is empty)
--   next-9  : next 9  ≡ 11    (10 refuted by the decision procedure)
--   next-10 : next 10 ≡ 11    (the interval is empty)
--
-- typecheck, whole module 3 s, EXIT=0, no postulate and no hole.  What
-- was wrong was not the heap and not the exchange rate but the DIAGNOSIS,
-- and the fix is one `let`.
--
------------------------------------------------------------------------
-- WHAT ACTUALLY FORCES THE EVALUATION
--
-- Not the `with`.  `WalkFast` guessed that `with q ≟ next m` demanded the
-- scrutinee in weak head normal form; replacing it by antisymmetry (the
-- `¬<→≤` below, whose own case split is on VARIABLES) leaves the blow-up
-- exactly where it was.  The culprit is in the CONVERSION CHECKER:
--
--   Agda 2.6.3 weak-head-normalises both sides of a conversion problem
--   unless the two terms are already shared.  The goal type `next 8 ≡ 9`
--   contains one occurrence of `next 8`; a proof built by instantiating
--   a generic lemma at m := 8 contributes a SECOND, independently
--   elaborated occurrence; putting the two side by side runs the walk on
--   cap 8.
--
-- The expensive event is therefore not "using the walk" but "writing
-- `next 8` twice".  Bisection isolated it in statements with no walk
-- content at all: with
--
--     Box : ℕ → Type₀ ;  mk : (n : ℕ) → Box n ;  use : Box (cap 8) → ℕ
--
--   use x            for a bound variable x : Box (cap 8)     2.1 s
--   use (mk (cap 8))                                          8.9 s  <- reduces
--
-- — same type on both sides, same number of occurrences of `cap 8`; the
-- only difference is whether the second occurrence reaches the
-- comparison as a VARIABLE or as an APPLICATION.  Leaving the numeral
-- unknown is no escape either: `use {n = _} …` makes Agda report
-- `lcmList-exists (range1 _n) .fst = 840`, i.e. it normalised the rigid
-- side to the numeral before giving up on the meta.
--
-- THE ROUTE ROUND.  Metavariable positions are free: a meta is SOLVED by
-- assignment, never by reduction, so the goal's own occurrence of
-- `next 8` can be handed to the proof at no cost.  What must be avoided
-- is contributing a second occurrence.  Hence
--
--   * `facts` packages EVERYTHING the walk knows about its answer into
--     one value, so an instance needs exactly ONE application of a walk
--     lemma (`facts 8 1≤8`) rather than three;
--   * that application is bound by `let`, which makes it a variable;
--   * `conclude` takes the walk's answer as a plain variable `n`, so the
--     goal's `next 8` arrives as a metavariable and is solved, once, by
--     assignment from the goal itself.
--
-- Variable against goal is free; application against goal reduces.  That
-- is the whole difference between 2 s and 3.5 GB.
--
-- BISECTION LOG (Agda 2.6.3, cubical v0.5, -M512m unless noted; EXIT=251
-- is heap exhaustion, i.e. the walk ran).
--
--   generic machinery only, no instance                     3.0 s  ok
--   `next 8` merely MENTIONED in a type                     3.1 s  ok
--   `refl : next 8 ≡ next 8`                                3.1 s  ok
--   next-least 3 1≤3   (partial application)                2.4 s  ok
--   next-least 6 1≤6                                        3.9 s  ok  <- cap m
--   next-least 8 1≤8                                       48 s    EXIT=251
--   next-> 8 1≤8                                           19 s    EXIT=251
--   next-isPP 8                                            18 s    EXIT=251
--   next-pinned 8 9 1≤8 pp-9 8<9 none8  (args ALL named)   17 s    EXIT=251
--   next-characterised 8 9 1≤8 pp-9 8<9 none8  (the `with`) 17 s   EXIT=251
--   conclude 8 _ 9 (facts 8 1≤8) …                         17 s    EXIT=251
--   with-abstraction on (facts 8 1≤8)                      16 s    EXIT=251
--   F8 : Facts 8 (next 8) ; F8 = facts 8 1≤8   (top level) 17 s    EXIT=251
--   let F : Facts 8 (next 8) ; F = facts 8 1≤8 in …        17 s    EXIT=251
--   let F = facts 8 1≤8 in conclude 8 _ 9 F …               2.2 s  ok
--
-- The m = 3 / 6 / 8 rows are the proof that what is being run is the walk
-- itself: the cost tracks cap m = lcm(1..m), not the size of the answer.
-- The last two rows are the diagnosis in its sharpest form: the SAME
-- `let`, differing only by a type signature on the bound variable.  The
-- signature is a second elaboration of `next 8`, and a second
-- elaboration of `next 8` costs 3.5 GB.
--
-- TWO HYPOTHESES KILLED BY THE LOG.
--
--  (i) "It is the `with q ≟ next m`."  No: `next-characterised`, `with`
--      and all, fails exactly like the antisymmetry version, in the same
--      17 s, and neither is rescued by removing the `with`.  Both are
--      rescued by the `let`.  WalkFast's confessed suspect was innocent
--      and its header should say so.
--
-- (ii) "Inlined proof arguments get normalised in the elaboration
--      context; name them at top level."  Not here: rows 9-11 name every
--      argument (`1≤8`, `pp-9`, `8<9`, `none8` are all top-level
--      definitions with signatures) and still blow the heap.  Naming
--      helps only when the named term's own SIGNATURE is cheap; `F8 :
--      Facts 8 (next 8)` names the fact and loses, because its signature
--      is where the second `next 8` gets built.  The rule is not "name
--      it" but "do not elaborate `next 8` twice" — which is why the one
--      binder that works is the one with no type signature to write.
--
-- CONTROLS.  `next 8 ≡ 10` by the same recipe is rejected (`10 != 9`),
-- and feeding `facts 9` to the goal `next 8 ≡ 9` blows the heap rather
-- than being silently accepted: the `let` buys sharing, not laxity.
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-15.
-- No postulates, no holes.
--
-- CHECKED AGAIN UNDER THE PIN: Agda 2.8.0 + cubical v0.9, LC_ALL=C.UTF-8,
-- from a tree with no `_build` and no `.agdai`, 2026-08-15 (Landau-lineage
-- pass).  EXIT=0, 15 s wall, 11 modules, **peak RSS 333-388 MB (two clean runs)**.  Not one
-- character of this module was changed to obtain that: the `let` diagnosis
-- above is correct under 2.8.0's conversion checker as well as 2.6.3's.
--
-- The orphan sweep of the same day (notes/TOOLCHAIN_SKEW_AND_COVERAGE.md
-- §7.2) reported this module as **exit 137**, SIGKILL, and rightly refused
-- to read that as a typecheck verdict.  It was not one.  388 MB is not a
-- module that OOMs a 16 GB container; it is a module that was standing next
-- to several other agents' Agda processes when the kernel picked a victim.
-- The reported 137 is reproduced here as what it was — a fact about the
-- machine, at load ~4.5 — and is now superseded by a measured exit code.
--
-- Note for anyone re-measuring: background the *binary*, not a `cd … && …`
-- compound, or `$!` is the subshell's PID and you will meter bash at 5 MB
-- and conclude the run was free.  I did exactly that on my first two
-- attempts; the 388 MB above is from an `exec`ed wrapper.
--
------------------------------------------------------------------------
-- (retracted header of the first revision, kept so the claim, its
-- retraction and its repair stay together:)
--
-- > STATUS, 2026-08-15, WRITTEN BY THE AUTHOR OF THE OVERCLAIM BELOW.
-- > THIS MODULE HAS NEVER TYPECHECKED.  The run that was supposed to
-- > confirm it exhausted a 3 GB heap after ten minutes and was killed;
-- > the file was then committed by an over-broad `git add` glob, and a
-- > lane index read this header and recorded WalkFast's confessed gap as
-- > CLOSED.  It is not closed. […]  Measured facts, and the only facts
-- > here: `pp-9` with the generic machinery checks in 3 s; adding
-- > `next-8` blows the heap.  So the cost is in the APPLICATION at
-- > m = 8, not in the decision procedure — which refutes nothing above
-- > and confirms nothing either.
--
-- That last sentence was the right measurement and it is what this
-- revision followed: the cost is in the application, and the reason the
-- application costs anything is that it builds a second `next 8`.
------------------------------------------------------------------------

module NaturalMachine.WalkFastInstance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import NaturalMachine.CoprimeSplitting using (IsPrimePower)
open import NaturalMachine.WalkBridge using (next)
open import NaturalMachine.WalkFast
  using ( next-isPP ; next-> ; next-least
        ; decIsPrimePower ; acceptDec ; refuteDec ; noneIn )

------------------------------------------------------------------------
-- 1.  The case split, moved off the client's term.
------------------------------------------------------------------------

-- The only `with` in this file, and its scrutinee is a pair of
-- VARIABLES: it is reduced when this lemma is checked, never when it is
-- applied.  (It was never the bottleneck; it is still the right way to
-- write the lemma.)
¬<→≤ : (m n : ℕ) → ¬ (n < m) → m ≤ n
¬<→≤ m n h with m ≟ n
... | lt p = <-weaken p
... | eq p = subst (m ≤_) p ≤-refl
... | gt p = Empty.rec (h p)

------------------------------------------------------------------------
-- 2.  Everything the walk knows about its own answer, in ONE value.
--
-- Load-bearing, and for an arithmetic rather than an aesthetic reason:
-- each separate use of a walk lemma at a numeral builds its own copy of
-- `next 8`, and the second copy is what costs 3.5 GB.  `facts` is
-- generic in m, so it is checked once, against the variable m, for free.
------------------------------------------------------------------------

Facts : ℕ → ℕ → Type₀
Facts m n = (m < n)
          × (IsPrimePower n
          × ((q : ℕ) → m < q → q < n → ¬ IsPrimePower q))

facts : (m : ℕ) → 1 ≤ m → Facts m (next m)
facts m 1≤m = next-> m 1≤m , next-isPP m , next-least m 1≤m

------------------------------------------------------------------------
-- 3.  The exchange rate, with `next` abstracted away.
--
-- `conclude` says: two "least prime power above m" descriptions of a
-- number agree.  The walk's answer enters as the plain variable n, so a
-- client supplies the n of its own goal as a metavariable — solved by
-- assignment, not by reduction.  Antisymmetry throughout; nothing here
-- inspects a numeral.
------------------------------------------------------------------------

conclude : (m n q : ℕ) → Facts m n → IsPrimePower q → m < q
         → ((r : ℕ) → m < r → r < q → ¬ IsPrimePower r)
         → n ≡ q
conclude m n q (m<n , ippn , leastn) ippq m<q none =
  ≤-antisym (¬<→≤ n q (λ q<n → leastn q m<q q<n ippq))
            (¬<→≤ q n (λ n<q → none n m<n n<q ippn))

-- The exchange rate in the shape `WalkFast` states it: cheap to prove,
-- because m is a variable, and USELESS TO APPLY at a numeral —
-- `next-pinned 8 9 …` puts a freshly built `next 8` opposite the goal's
-- and runs the walk (17 s to heap exhaustion, row 9 of the log above).
-- The instances in §5 go through `conclude` and a `let` instead.  Kept
-- because it is the statement the surrounding notes quote.
next-pinned :
  (m q : ℕ) → 1 ≤ m →
  IsPrimePower q → m < q →
  ((r : ℕ) → m < r → r < q → ¬ IsPrimePower r) →
  next m ≡ q
next-pinned m q 1≤m ippq m<q none =
  conclude m (next m) q (facts m 1≤m) ippq m<q none

------------------------------------------------------------------------
-- 4.  The cheap side: prime-power-hood decided at the size of the
--     ANSWER, by the kernel, once per instance.
------------------------------------------------------------------------

pp-9 : IsPrimePower 9
pp-9 = acceptDec (decIsPrimePower 9) tt

pp-11 : IsPrimePower 11
pp-11 = acceptDec (decIsPrimePower 11) tt

¬pp-10 : ¬ IsPrimePower 10
¬pp-10 = refuteDec (decIsPrimePower 10) tt

1≤8 : 1 ≤ 8
1≤8 = suc-≤-suc zero-≤

1≤9 : 1 ≤ 9
1≤9 = suc-≤-suc zero-≤

1≤10 : 1 ≤ 10
1≤10 = suc-≤-suc zero-≤

8<9 : 8 < 9
8<9 = suc-≤-suc ≤-refl

9<11 : 9 < 11
9<11 = ≤-suc (suc-≤-suc ≤-refl)

10<11 : 10 < 11
10<11 = suc-≤-suc ≤-refl

-- the intervals, refuted rather than searched
none8 : (r : ℕ) → 8 < r → r < 9 → ¬ IsPrimePower r
none8 = noneIn 8 0 (λ i i<0 → Empty.rec (¬-<-zero i<0))

none9 : (r : ℕ) → 9 < r → r < 11 → ¬ IsPrimePower r
none9 = noneIn 9 1 gap
  where
  gap : (i : ℕ) → i < 1 → ¬ IsPrimePower (suc (9 + i))
  gap zero    _ = ¬pp-10
  gap (suc i) p = Empty.rec (¬-<-zero (pred-≤-pred p))

none10 : (r : ℕ) → 10 < r → r < 11 → ¬ IsPrimePower r
none10 = noneIn 10 0 (λ i i<0 → Empty.rec (¬-<-zero i<0))

------------------------------------------------------------------------
-- 5.  THE INSTANCES.  cap m = e^{ψ(m)} is never touched.
--
-- Read the `let` as the point of the file.  `facts m 1≤m` is the single
-- application that mentions the walk; binding it makes it a variable,
-- and the `_` is the goal's own `next m` arriving by assignment.  Write
-- `conclude m (next m) q (facts m 1≤m) …` instead, inlining the `let`,
-- and the same proof exhausts the heap.
------------------------------------------------------------------------

next-8 : next 8 ≡ 9
next-8 = let F = facts 8 1≤8 in conclude 8 _ 9 F pp-9 8<9 none8

next-9 : next 9 ≡ 11
next-9 = let F = facts 9 1≤9 in conclude 9 _ 11 F pp-11 9<11 none9

next-10 : next 10 ≡ 11
next-10 = let F = facts 10 1≤10 in conclude 10 _ 11 F pp-11 10<11 none10
