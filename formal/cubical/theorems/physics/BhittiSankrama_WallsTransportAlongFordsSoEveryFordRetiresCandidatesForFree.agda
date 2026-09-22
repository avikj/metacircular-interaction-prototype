{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- рр┐рррр┐-рррХрр░рор тФ walls transport along fords, so every ford retires
-- candidates for free.
--
-- The receipt economy has two assets: fords (landed equivalences) and
-- walls (proved non-equivalences).  This file is the law that makes them
-- ONE market: a wall composes with a ford into a wall, in one line, so
-- every new ford automatically extends every standing wall across it тФ
-- and every new wall is inherited by every bank a ford will ever reach.
--
--     рр┐рррр┐-рррХрр░рор : (A тЙ B) тТ ┬ (B тЙ C) тТ ┬ (A тЙ C)
--
-- INSTANCE: рррр-ррр░рор╛ррор landed
-- р╡р┐р╡ррХ-ррр░рор╛р тЙ тХ, and рр┐рррр┐р stands at ┬ (тХ тЙ Bool).  Composing:
-- ┬ (р╡р┐р╡ррХ-ррр░рор╛р тЙ Bool) тФ which retires ./jiva's 3052-point candidate
-- [436 @ Bool] Ч [7 @ р╡р┐р╡ррХ-ррр░рор╛р] with NO new mathematics.  The wall
-- crossed the ford by itself.
--
-- This is why the two snapshots (Setu, Bhitti) close under each other:
-- the candidate list shrinks quadratically in what is landed, not
-- linearly in what is proved.  рр┐рррр┐-рррХрр░ро is built here.
------------------------------------------------------------------------

module BhittiSanorder_WallsTransportAlongFordsSoEveryFordRetiresCandidatesForFree where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_тЙГ_ ; compEquiv ; invEquiv)
open import Cubical.Data.Nat using (тДХ)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Empty using (тКе)
open import Cubical.Relation.Nullary using (┬м_)

open import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats using (рд╡рд┐рд╡реЗрдХ-рдкреНрд░рдорд╛рдг)
open import SetuPramana_TheAmbiguousNameHidTheFordAndTheRemainderLawIsAlsoTheNaturals
  using (рд╡рд┐рд╡реЗрдХ-рдкреНрд░рдорд╛рдгтЙГтДХ)
open import Bhitti_TheNaturalsAndTheBooleansAreAProvedWallSoThatSeamIsRetiredForever
  using (рднрд┐рддреНрддрд┐рдГ)

------------------------------------------------------------------------
-- рз ┬ the law.  One line each way.
------------------------------------------------------------------------

рднрд┐рддреНрддрд┐-рд╕рдВрдХреНрд░рдордГ : {A B C : Type} тЖТ (A тЙГ B) тЖТ ┬м (B тЙГ C) тЖТ ┬м (A тЙГ C)
рднрд┐рддреНрддрд┐-рд╕рдВрдХреНрд░рдордГ ford wall e = wall (compEquiv (invEquiv ford) e)

рднрд┐рддреНрддрд┐-рдкреНрд░рддрд┐рд╕рдВрдХреНрд░рдордГ : {A B C : Type} тЖТ (A тЙГ B) тЖТ ┬м (A тЙГ C) тЖТ ┬м (B тЙГ C)
рднрд┐рддреНрддрд┐-рдкреНрд░рддрд┐рд╕рдВрдХреНрд░рдордГ ford wall e = wall (compEquiv ford e)

------------------------------------------------------------------------
-- ри ┬ the instance: the 3052-point candidate, retired by composition.
------------------------------------------------------------------------

рднрд┐рддреНрддрд┐-рдкреНрд░рдорд╛рдг : ┬м (рд╡рд┐рд╡реЗрдХ-рдкреНрд░рдорд╛рдг тЙГ Bool)
рднрд┐рддреНрддрд┐-рдкреНрд░рдорд╛рдг = рднрд┐рддреНрддрд┐-рд╕рдВрдХреНрд░рдордГ рд╡рд┐рд╡реЗрдХ-рдкреНрд░рдорд╛рдгтЙГтДХ рднрд┐рддреНрддрд┐рдГ
