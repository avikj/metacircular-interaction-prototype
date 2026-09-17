{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Kernel.Siddhasadhana_InstallingWhatYouCanAlreadyReachIsAPlateau
--                      SoTheKernelsOwnLibraryCannotGrowItsReach
--
-- TERM.  ‡‡ø‡¶‡‡ß‡‡æ‡ß‡® ¬ siddhasdhana -- establishing what is already
-- established; in the Nyya debate literature a defect of a would-be proof,
-- because the sdhya is already siddha for the opponent, so the inference
-- accomplishes nothing.  Discussed under the ‡®‡ø‡ó‡‡∞‡‡‡‡‡æ‡® / ‡‡æ‡‡ø apparatus
-- descending from Gautama's *Nyyastra* (~2nd c. CE) book 5 and developed
-- in the later Naiyyika manuals; I have not established a first use of the
-- compound with a date I checked, and I am not supplying one.
--
------------------------------------------------------------------------
-- WHAT WAS OPEN.
--
-- `NaturalMachine.Obstruction` proves a separation on ITS substrate (unary
-- terms, a vocabulary of head shapes):
--
--   plateau : FreqChain V W ‚í Matches W ‚â° Matches V
--
-- A proposer that installs what it can already match leaves the matcher
-- EQUAL AS A FUNCTION, after any number of steps; and `obs-step-strict`
-- says one obstruction-indexed step cannot.  `Avataranika_` ¬ß7 records that
-- no file imports both `Obstruction` and `RewriteCertificate`, so it was
-- open whether that separation says anything about the kernel at all.
--
-- THIS FILE ANSWERS THE FIRST HALF: the plateau transfers, and it is not a
-- port.  Obstruction's proof runs through `extend-absorbed` on a Bool
-- membership test.  The kernel's runs through `control-sound`, which is a
-- different fact about a different object: the control of `install d` at t‚≤
-- IS an identification t‚≤ ‚â° t, so a library extended by a theorem it could
-- already reach enables nothing it could not already enable.
--
------------------------------------------------------------------------
-- WHAT IS PROVED.
--
--   ¬ß1  InstallChain -- the kernel's analogue of FreqChain: extend the
--       library with a derivation from a context already enabled.
--   ¬ß2  install-chain-plateau -- reach is invariant along any such chain.
--   ¬ß3  kernel-install-chains-cannot-reach-a-tower -- the concrete
--       corollary, on the kernel's OWN library.  Exact analogue of
--       Obstruction.frequency-cannot-reach.
--
-- THE FRONTIER THIS OPENS ‚î the live questions it makes precise:
--   * NO ANTI-PLATEAU IS PROVED HERE.  Obstruction's separation has two
--     halves and this is one.  What escapes the plateau on the kernel side
--     is Vyapti_'s `SchematicOperation` -- `no-native-operation-does-this`
--     shows one schema fires where no NativeOperation can -- but a schema
--     is not a NativeOperation and cannot be installed, so the escape is
--     not yet a step of any chain.  `Adesa_` supplies the certificate a
--     schema would need; the record change does not exist.
--   * NOTHING HERE IS AN OBSTRUCTION, and the scope of that is narrow.
--     `InstallChain`'s step is restricted to `install`, whose control is the
--     trivial family `t ‚â° lhs`.  `Control : Tm ‚í Type‚` is a FIELD and the
--     caller may supply ANY type family, so this plateau is a theorem about
--     the one trivial instance and says nothing about what an arbitrary
--     control can enable.  Obstruction's own residual-reading is a
--     projection only because its terms are unary; on the kernel's `Tm` the
--     corresponding question is not asked here.
--   * `SomeEnabled` is restated here from Vyapti_ rather than imported, so
--     that this module depends on the kernel and not on that module's
--     other machinery; the definition is identical.
--
-- CHECKED.  Agda 2.6.3 + cubical v0.5, `--safe`, no postulates, no holes,
-- exit 0 at the previous module path.  Module name and imports were renamed
-- to `Kernel.*` to match this directory; that rename has not been re-run at
-- the repository pin (2.8.0 + v0.9).
------------------------------------------------------------------------

module Kernel.Siddhasadhana_InstallingWhatYouCanAlreadyReachIsAPlateauSoTheKernelsOwnLibraryCannotGrowItsReach where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Data.Nat using (‚Ñï)

open import RewriteCertificate
open import ControlledGrammar
open import GenerativeKernel using (direct-operation ; detour-operation)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)

------------------------------------------------------------------------
-- ¬ß1.  The reach predicate, and the kernel's analogue of a FreqChain.
------------------------------------------------------------------------

-- Identical to Vyapti_'s definition; restated so this module's dependency
-- is the kernel itself.
SomeEnabled : List NativeOperation ‚Üí Tm ‚Üí Type‚ÇÄ
SomeEnabled []       t = ‚ä•
SomeEnabled (op ‚à∑ L) t = NativeOperation.Control op t ‚äé SomeEnabled L t

-- Obstruction.FreqChain installs `headShape W t m` -- a head read off a term
-- the vocabulary ALREADY matches.  The kernel's counterpart: install a
-- derivation starting at a context the library ALREADY enables.
data InstallChain (L : List NativeOperation) : List NativeOperation ‚Üí Type‚ÇÅ where
  done : InstallChain L L
  step : {M : List NativeOperation} ‚Üí InstallChain L M
       ‚Üí (t : Tm) ‚Üí SomeEnabled M t
       ‚Üí {b : Tm} (d : Derivation t b)
       ‚Üí InstallChain L (install d ‚à∑ M)

------------------------------------------------------------------------
-- ¬ß2.  THE PLATEAU.  One step first: the control of `install d` at t‚≤ is an
--      identification t‚≤ ‚â° t, and t was already enabled, so transporting
--      the old evidence backwards along it discharges the new branch.
------------------------------------------------------------------------

install-step-absorbed :
  (M : List NativeOperation) (t : Tm) (e : SomeEnabled M t)
  {b : Tm} (d : Derivation t b) (t' : Tm)
  ‚Üí SomeEnabled (install d ‚à∑ M) t' ‚Üí SomeEnabled M t'
install-step-absorbed M t e d t' (inl c) = subst (SomeEnabled M) (sym c) e
install-step-absorbed M t e d t' (inr s) = s

-- Hence along a whole chain.  Compare Obstruction.plateau: there the
-- conclusion is an equality of matchers; here it is that the reach of the
-- grown library is contained in the reach of the seed, which with
-- monotonicity is the same statement and is the half the corollary needs.
install-chain-plateau :
  {L M : List NativeOperation} ‚Üí InstallChain L M
  ‚Üí (t' : Tm) ‚Üí SomeEnabled M t' ‚Üí SomeEnabled L t'
install-chain-plateau done            t' s = s
install-chain-plateau (step ch t e d) t' s =
  install-chain-plateau ch t' (install-step-absorbed _ t e d t' s)

------------------------------------------------------------------------
-- ¬ß3.  THE COROLLARY, on the kernel's own two operations.  Both have source
--      `add var (suc zero)`; a tower has an outermost `suc`.  A head
--      discriminator kills the control, and ¬ß2 extends it to anything the
--      library builds from itself.
--
--      `Vyapti_` proves the seed case and is now a sibling in this
--      directory, so the import would resolve; the discriminator was
--      inlined when this module was written against a branch that predated
--      the reorganisation, and it is left inlined rather than changed
--      without a re-check.  The statement is the same either way.
------------------------------------------------------------------------

isAdd : Tm ‚Üí Bool
isAdd (add _ _) = true
isAdd _         = false

tower : ‚Ñï ‚Üí Tm
tower ‚Ñï.zero    = zero
tower (‚Ñï.suc n) = suc (tower n)

kernel-library : List NativeOperation
kernel-library = direct-operation ‚à∑ detour-operation ‚à∑ []

-- The seed case: neither of the kernel's two operations fires on a tower.
kernel-cannot-reach-a-tower :
  SomeEnabled kernel-library (tower (‚Ñï.suc (‚Ñï.suc (‚Ñï.suc ‚Ñï.zero)))) ‚Üí ‚ä•
kernel-cannot-reach-a-tower (inl p)       = true‚â¢false (sym (cong isAdd p))
kernel-cannot-reach-a-tower (inr (inl p)) = true‚â¢false (sym (cong isAdd p))

-- And by ¬ß2, nothing the library builds out of itself does either.
kernel-install-chains-cannot-reach-a-tower :
  {M : List NativeOperation} ‚Üí InstallChain kernel-library M
  ‚Üí SomeEnabled M (tower (‚Ñï.suc (‚Ñï.suc (‚Ñï.suc ‚Ñï.zero)))) ‚Üí ‚ä•
kernel-install-chains-cannot-reach-a-tower ch s =
  kernel-cannot-reach-a-tower (install-chain-plateau ch _ s)
