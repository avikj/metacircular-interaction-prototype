{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TerminalTraceCompression
--
-- A deterministic history carries no more quotient information than a
-- terminal record exactly when each observation factors through the other on
-- its realized image.  FiniteInformation already supplies the constructive
-- image descent.  This module composes the two descents into:
--
--   * an Iso of the two realized-output carriers;
--   * an Iso of their equality kernels; and
--   * an Iso of every pair of corresponding input fibers; and
--   * an Iso between their factorization witnesses for every set-valued
--     downstream target.
--
-- These are semantic information statements.  They do not identify query
-- latency, online stopping cost, quantum circuits, or histories in which an
-- intermediate outcome changes the state or the later admissible actions.
------------------------------------------------------------------------

module TerminalTraceCompression where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.HLevels using (isSetΣ ; isSet×)
open import Cubical.Foundations.Isomorphism using (Iso ; iso)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; true≢false ; isSetBool)
open import Cubical.Data.Sigma
  using (_×_ ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Functions.Image
  using (Image ; isPropIsInImage ; restrictToImage)
open import Cubical.Relation.Nullary using (¬_)
import FiniteInformation as FI

private
  variable
    ℓX ℓH ℓT ℓQ : Level

------------------------------------------------------------------------
-- 1. Mutual determination on realized images
------------------------------------------------------------------------

module MutualCompression
  {X : Type ℓX} {H : Type ℓH} {T : Type ℓT}
  (setH : isSet H)
  (setT : isSet T)
  (history : X → H)
  (terminal : X → T)
  (historyThroughTerminal : FI.FactorsThrough terminal history)
  (terminalThroughHistory : FI.FactorsThrough history terminal)
  where

  HistoryImage : Type _
  HistoryImage = Image history

  TerminalImage : Type _
  TerminalImage = Image terminal

  setHistoryImage : isSet HistoryImage
  setHistoryImage =
    isSetΣ setH
      (λ output → isProp→isSet (isPropIsInImage history output))

  setTerminalImage : isSet TerminalImage
  setTerminalImage =
    isSetΣ setT
      (λ output → isProp→isSet (isPropIsInImage terminal output))

  historyImageOf : X → HistoryImage
  historyImageOf = restrictToImage history

  terminalImageOf : X → TerminalImage
  terminalImageOf = restrictToImage terminal

  terminal-equality→history-equality :
      (x y : X)
    → terminal x ≡ terminal y
    → history x ≡ history y
  terminal-equality→history-equality =
    FI.factorsThrough→fiberConstant
      terminal history historyThroughTerminal

  history-equality→terminal-equality :
      (x y : X)
    → history x ≡ history y
    → terminal x ≡ terminal y
  history-equality→terminal-equality =
    FI.factorsThrough→fiberConstant
      history terminal terminalThroughHistory

  historyImage-constant-on-terminal :
    FI.FiberConstant terminal historyImageOf
  historyImage-constant-on-terminal x y same-terminal =
    FI.sameObservation→samePoint history
      (terminal-equality→history-equality x y same-terminal)

  terminalImage-constant-on-history :
    FI.FiberConstant history terminalImageOf
  terminalImage-constant-on-history x y same-history =
    FI.sameObservation→samePoint terminal
      (history-equality→terminal-equality x y same-history)

  historyImageThroughTerminal :
    FI.FactorsThrough terminal historyImageOf
  historyImageThroughTerminal =
    FI.fiberConstant→factorsThrough
      setHistoryImage terminal historyImageOf
      historyImage-constant-on-terminal

  terminalImageThroughHistory :
    FI.FactorsThrough history terminalImageOf
  terminalImageThroughHistory =
    FI.fiberConstant→factorsThrough
      setTerminalImage history terminalImageOf
      terminalImage-constant-on-history

  expand : TerminalImage → HistoryImage
  expand = fst historyImageThroughTerminal

  last : HistoryImage → TerminalImage
  last = fst terminalImageThroughHistory

  expand-terminal :
    (x : X) → expand (terminalImageOf x) ≡ historyImageOf x
  expand-terminal = snd historyImageThroughTerminal

  last-history :
    (x : X) → last (historyImageOf x) ≡ terminalImageOf x
  last-history = snd terminalImageThroughHistory

  historyRoundTripFactors :
    FI.FactorsThrough history historyImageOf
  historyRoundTripFactors =
    (λ output → expand (last output)) ,
    (λ x → cong expand (last-history x) ∙ expand-terminal x)

  historyIdentityFactors :
    FI.FactorsThrough history historyImageOf
  historyIdentityFactors = (λ output → output) , (λ x → refl)

  expand-last :
    (output : HistoryImage) → expand (last output) ≡ output
  expand-last output =
    funExt⁻
      (cong fst
        (FI.isPropFactorsThrough
          setHistoryImage history historyImageOf
          historyRoundTripFactors historyIdentityFactors))
      output

  terminalRoundTripFactors :
    FI.FactorsThrough terminal terminalImageOf
  terminalRoundTripFactors =
    (λ output → last (expand output)) ,
    (λ x → cong last (expand-terminal x) ∙ last-history x)

  terminalIdentityFactors :
    FI.FactorsThrough terminal terminalImageOf
  terminalIdentityFactors = (λ output → output) , (λ x → refl)

  last-expand :
    (output : TerminalImage) → last (expand output) ≡ output
  last-expand output =
    funExt⁻
      (cong fst
        (FI.isPropFactorsThrough
          setTerminalImage terminal terminalImageOf
          terminalRoundTripFactors terminalIdentityFactors))
      output

  realizedOutputIso : Iso HistoryImage TerminalImage
  Iso.fun realizedOutputIso = last
  Iso.inv realizedOutputIso = expand
  Iso.rightInv realizedOutputIso = last-expand
  Iso.leftInv realizedOutputIso = expand-last

------------------------------------------------------------------------
-- 2. The pointwise kernel and fiber consequences
------------------------------------------------------------------------

  kernelIso :
    (x y : X) → Iso (history x ≡ history y) (terminal x ≡ terminal y)
  Iso.fun (kernelIso x y) = history-equality→terminal-equality x y
  Iso.inv (kernelIso x y) = terminal-equality→history-equality x y
  Iso.rightInv (kernelIso x y) same-terminal =
    setT (terminal x) (terminal y) _ same-terminal
  Iso.leftInv (kernelIso x y) same-history =
    setH (history x) (history y) _ same-history

  correspondingFiberIso :
    (base : X)
    → Iso (fiber history (history base))
          (fiber terminal (terminal base))
  Iso.fun (correspondingFiberIso base) (candidate , same-history) =
    candidate ,
      history-equality→terminal-equality candidate base same-history
  Iso.inv (correspondingFiberIso base) (candidate , same-terminal) =
    candidate ,
      terminal-equality→history-equality candidate base same-terminal
  Iso.rightInv (correspondingFiberIso base) (candidate , same-terminal) =
    Σ≡Prop
      (λ point → setT (terminal point) (terminal base))
      refl
  Iso.leftInv (correspondingFiberIso base) (candidate , same-history) =
    Σ≡Prop
      (λ point → setH (history point) (history base))
      refl

------------------------------------------------------------------------
-- 3. Every set-valued downstream question is preserved
------------------------------------------------------------------------

  history-target→terminal-target :
    {Q : Type ℓQ} (setQ : isSet Q) (target : X → Q)
    → FI.FactorsThrough history target
    → FI.FactorsThrough terminal target
  history-target→terminal-target setQ target throughHistory =
    FI.fiberConstant→factorsThrough setQ terminal target
      (λ x y same-terminal →
        FI.factorsThrough→fiberConstant history target throughHistory x y
          (terminal-equality→history-equality x y same-terminal))

  terminal-target→history-target :
    {Q : Type ℓQ} (setQ : isSet Q) (target : X → Q)
    → FI.FactorsThrough terminal target
    → FI.FactorsThrough history target
  terminal-target→history-target setQ target throughTerminal =
    FI.fiberConstant→factorsThrough setQ history target
      (λ x y same-history →
        FI.factorsThrough→fiberConstant terminal target throughTerminal x y
          (history-equality→terminal-equality x y same-history))

  targetFactorizationIso :
    {Q : Type ℓQ} (setQ : isSet Q) (target : X → Q)
    → Iso (FI.FactorsThrough history target)
          (FI.FactorsThrough terminal target)
  Iso.fun (targetFactorizationIso setQ target) =
    history-target→terminal-target setQ target
  Iso.inv (targetFactorizationIso setQ target) =
    terminal-target→history-target setQ target
  Iso.rightInv (targetFactorizationIso setQ target) throughTerminal =
    FI.isPropFactorsThrough setQ terminal target _ throughTerminal
  Iso.leftInv (targetFactorizationIso setQ target) throughHistory =
    FI.isPropFactorsThrough setQ history target _ throughHistory

------------------------------------------------------------------------
-- 4. Positive control: a displayed one-step history and its terminal bit
------------------------------------------------------------------------

DisplayedHistory : Type₀
DisplayedHistory = Bool × Unit

setDisplayedHistory : isSet DisplayedHistory
setDisplayedHistory = isSet× isSetBool isSetUnit

displayedHistory : Bool → DisplayedHistory
displayedHistory bit = bit , tt

terminalBit : Bool → Bool
terminalBit bit = bit

displayedHistory-through-terminal :
  FI.FactorsThrough terminalBit displayedHistory
displayedHistory-through-terminal =
  (λ output → fst output , tt) , (λ bit → refl)

terminal-through-displayedHistory :
  FI.FactorsThrough displayedHistory terminalBit
terminal-through-displayedHistory =
  (λ output → fst (fst output)) , (λ bit → refl)

module DisplayedCompression =
  MutualCompression
    setDisplayedHistory isSetBool displayedHistory terminalBit
    displayedHistory-through-terminal terminal-through-displayedHistory

displayed-terminal-output-iso :
  Iso DisplayedCompression.HistoryImage DisplayedCompression.TerminalImage
displayed-terminal-output-iso = DisplayedCompression.realizedOutputIso

displayed-terminal-false-fiber-iso :
  Iso (fiber displayedHistory (displayedHistory false))
      (fiber terminalBit (terminalBit false))
displayed-terminal-false-fiber-iso =
  DisplayedCompression.correspondingFiberIso false

displayed-terminal-target-factorization-iso :
  Iso (FI.FactorsThrough displayedHistory terminalBit)
      (FI.FactorsThrough terminalBit terminalBit)
displayed-terminal-target-factorization-iso =
  DisplayedCompression.targetFactorizationIso isSetBool terminalBit

------------------------------------------------------------------------
-- 5. Hostile control: erasing a branch-changing bit is not compression
------------------------------------------------------------------------

collapsedTerminal : Bool → Unit
collapsedTerminal bit = tt

identityHistory : Bool → Bool
identityHistory bit = bit

terminal-through-identity-history :
  FI.FactorsThrough identityHistory collapsedTerminal
terminal-through-identity-history =
  (λ output → tt) , (λ bit → refl)

collapse-does-not-determine-history :
  ¬ FI.FactorsThrough collapsedTerminal identityHistory
collapse-does-not-determine-history through =
  true≢false
    (FI.factorsThrough→fiberConstant
      collapsedTerminal identityHistory through true false refl)
