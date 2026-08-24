{-# OPTIONS --safe --cubical-compatible #-}

------------------------------------------------------------------------
-- प्रस्ताव-हृदय — the classifier has ONE spelling, shared by the
-- proposer and the theorem.
--
-- TERM.  hṛdaya, the heart, the essential core — ordinary Sanskrit;
-- the compound is built here (2026-08-24) and claimed of no source.
--
-- WHY THIS FILE EXISTS.  Until now the AC classifier lived twice: as
-- with-blocks in the executable proposer (formal/executable/
-- Prastava.agda, extracted by MAlonzo and run) and as constructor-
-- dispatched helpers in the soundness theorem (PrastavaSatya_*.agda,
-- judged by the cubical kernel).  The two spellings were asserted —
-- never checked — to be one function; that assertion was the last
-- named debt of the PrastavaSatya landing.  This module erases the
-- debt structurally: it is checked with --cubical-compatible, so the
-- SAME clauses are imported by the plain --safe proposer (and
-- extracted: the code that runs) and by the --cubical theorem (the
-- code that is proved about).  There is nothing left to transcribe
-- and therefore nothing left to trust.
--
-- The spelling kept is the constructor-dispatched one (insGo / lvGo /
-- lex2 in place of where-blocks and with), because lemma clauses can
-- case on the same scrutinee and compute; the with-block spelling is
-- deleted at its source, not preserved beside this one.
--
-- Only Agda.Builtin modules are imported, so both worlds agree on ℕ,
-- List and Bool on the nose.
------------------------------------------------------------------------

module PrastavaHrdaya_TheClassifierHasOneSpellingSharedByProposerAndTheorem where

open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Bool using (Bool ; true ; false)

infixr 5 _++_
_++_ : {A : Set} → List A → List A → List A
[] ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

data Sym : Set where
  plus times monus leS maxS : Sym

data Tm : Set where
  V   : Nat → Tm
  Z   : Tm
  S   : Tm → Tm
  Bin : Sym → Tm → Tm → Tm

-- total comparison: 0 = less, 1 = equal, 2 = greater
cmpN : Nat → Nat → Nat
cmpN zero zero = 1
cmpN zero (suc _) = 0
cmpN (suc _) zero = 2
cmpN (suc a) (suc b) = cmpN a b

symCode : Sym → Nat
symCode plus = 0
symCode times = 1
symCode monus = 2
symCode leS = 3
symCode maxS = 4

lex2 : Nat → Nat → Nat
lex2 1 o = o
lex2 o _ = o

cmpTm : Tm → Tm → Nat
cmpTm (V i) (V j) = cmpN i j
cmpTm (V _) _ = 0
cmpTm Z (V _) = 2
cmpTm Z Z = 1
cmpTm Z _ = 0
cmpTm (S _) (V _) = 2
cmpTm (S _) Z = 2
cmpTm (S a) (S b) = cmpTm a b
cmpTm (S _) (Bin _ _ _) = 0
cmpTm (Bin _ _ _) (V _) = 2
cmpTm (Bin _ _ _) Z = 2
cmpTm (Bin _ _ _) (S _) = 2
cmpTm (Bin s a b) (Bin s' a' b') =
  lex2 (cmpN (symCode s) (symCode s')) (lex2 (cmpTm a a') (cmpTm b b'))

data Where : Set where lt eq gt : Where

whereOf : Nat → Where
whereOf 0 = lt
whereOf 1 = eq
whereOf _ = gt

-- constructor-dispatched helpers in place of with-blocks, so lemma
-- clauses can case on the same scrutinee and compute
mutual
  insGo : Where → Tm → Tm → List Tm → List Tm
  insGo gt t u us = u ∷ insertBy t us
  insGo lt t u us = t ∷ u ∷ us
  insGo eq t u us = t ∷ u ∷ us

  insertBy : Tm → List Tm → List Tm
  insertBy t [] = t ∷ []
  insertBy t (u ∷ us) = insGo (whereOf (cmpTm t u)) t u us

sortTm : List Tm → List Tm
sortTm [] = []
sortTm (t ∷ ts) = insertBy t (sortTm ts)

sameSym : Sym → Sym → Where
sameSym s s' = whereOf (cmpN (symCode s) (symCode s'))

mutual
  lvGo : Where → Sym → Tm → Tm → Sym → List Tm
  lvGo eq s a b s' = leavesOf s a ++ leavesOf s b
  lvGo lt s a b s' = Bin s' a b ∷ []
  lvGo gt s a b s' = Bin s' a b ∷ []

  leavesOf : Sym → Tm → List Tm
  leavesOf s (Bin s' a b) = lvGo (sameSym s s') s a b s'
  leavesOf s (V i) = V i ∷ []
  leavesOf s Z = Z ∷ []
  leavesOf s (S t) = S t ∷ []

rebuild : Sym → List Tm → Tm
rebuild s [] = Z
rebuild s (t ∷ []) = t
rebuild s (t ∷ u ∷ us) = Bin s t (rebuild s (u ∷ us))

acCanon : Tm → Tm
acCanon (V i) = V i
acCanon Z = Z
acCanon (S t) = S (acCanon t)
acCanon (Bin plus a b) =
  rebuild plus (sortTm (leavesOf plus (acCanon a) ++ leavesOf plus (acCanon b)))
acCanon (Bin times a b) =
  rebuild times (sortTm (leavesOf times (acCanon a) ++ leavesOf times (acCanon b)))
acCanon (Bin monus a b) = Bin monus (acCanon a) (acCanon b)
acCanon (Bin leS a b)   = Bin leS (acCanon a) (acCanon b)
acCanon (Bin maxS a b)  = Bin maxS (acCanon a) (acCanon b)

is1 : Nat → Bool
is1 1 = true
is1 _ = false

eqTm : Tm → Tm → Bool
eqTm a b = is1 (cmpTm a b)

acShuffle : Tm → Tm → Bool
acShuffle l r = eqTm (acCanon l) (acCanon r)
