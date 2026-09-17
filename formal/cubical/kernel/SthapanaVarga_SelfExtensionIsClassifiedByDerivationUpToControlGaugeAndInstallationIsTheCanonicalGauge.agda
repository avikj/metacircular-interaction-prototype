{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡‡æ‡‡®‡æ-‡µ‡∞‡‡ó ‚î the moduli of installations.
--
-- THE CLAIM (2026-09-03, the moduli conversation): the kernel is the
-- fixed point of the spec ‚í moduli ‚í motive tower ‚î the one object
-- that is simultaneously a point of its own moduli, because `install`
-- turns a theorem of the object into a structure map of the object.
-- For that sentence to be mathematics rather than mood, the kernel's
-- self-extensions must be CLASSIFIED, and the classification must
-- name what a self-extension is over and above the theorem it
-- installs.  Here is the classification, and the answer is: a gauge.
--
--   ¬ß1  INSTALLATION LOSES NOTHING: extracting the certificate from
--       an installed derivation returns the derivation, by refl.
--       install is a section of extract ‚î theorem ‚í operation ‚í
--       theorem is the identity.
--
--   ¬ß2  THE MODULI OF SELF-EXTENSIONS: a NativeOperation is exactly
--       a certificate together with a control gauge ‚î a predicate on
--       terms and a soundness witness pinning it to the source.  The
--       equivalence is exhibited (both round trips refl, by Œ), so
--       "what is an operation beyond its theorem?" has an exact
--       answer: a choice of gauge, nothing else.
--
--   ¬ß3  EVERY OPERATION FACTORS THROUGH ITS OWN INSTALLATION: for
--       any O, reindexing controls along control-sound carries O's
--       applicability into that of install (checked O), and both
--       apply and apply-checked commute with the reindexing ‚î each
--       agreement is refl.  So the image of install exhausts every
--       self-extension up to gauge: capability grows by one term per
--       theorem, as a factorization theorem, not a slogan.
--
--   ¬ß4  THE CANONICAL GAUGE IS THE WHOLE LOCUS: the applicability
--       space of install d is contractible with centre the source ‚î
--       the one point there is to fire at ‚î and ¬ß5: every gauge's
--       applicability space maps into that contractible locus over
--       the identity of terms.  However permissive the control, it
--       is a shadow of the one point.
--
-- Read together: self-extension is classified by derivation up to
-- control gauge; installation is the canonical ‚î total, terminal ‚î
-- gauge; and no gauge buys an application the certificate did not
-- already license (¬ß3, by refl).  The Maurer‚ìCartan reading of
-- conservative self-rewrite lands here already solved: the coherence
-- equation is control-sound, its solutions are the gauges, and gauge
-- equivalence classes of solutions are the derivations themselves.
--
------------------------------------------------------------------------

module SthapanaVarga_SelfExtensionIsClassifiedByDerivationUpToControlGaugeAndInstallationIsTheCanonicalGauge where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)

open import RewriteCertificate using (Tm ; Derivation)
open import ControlledGrammar using (NativeOperation ; install)

open NativeOperation

------------------------------------------------------------------------
-- ‡¶ ¬ The certificate of an operation, and its gauge.
------------------------------------------------------------------------

Certificate : Type‚ÇÄ
Certificate = Œ£[ l ‚àà Tm ] Œ£[ r ‚àà Tm ] Derivation l r

extract : NativeOperation ‚Üí Certificate
extract O = source O , target O , checked O

-- A control gauge at a source: a predicate on terms together with the
-- soundness witness pinning every satisfying term to that source.
Gauge : Tm ‚Üí Type‚ÇÅ
Gauge l = Œ£[ C ‚àà (Tm ‚Üí Type‚ÇÄ) ] ({t : Tm} ‚Üí C t ‚Üí t ‚â° l)

------------------------------------------------------------------------
-- ‡ß ¬ Installation is a section of extraction: nothing added, nothing
--     lost, on the theorem side ‚î by refl.
------------------------------------------------------------------------

install-section : {l r : Tm} (d : Derivation l r)
  ‚Üí extract (install d) ‚â° (l , r , d)
install-section d = refl

------------------------------------------------------------------------
-- ‡® ¬ The classification: an operation IS a certificate with a gauge.
------------------------------------------------------------------------

Extension : Type‚ÇÅ
Extension = Œ£[ c ‚àà Certificate ] Gauge (fst c)

assemble : Extension ‚Üí NativeOperation
source        (assemble ((l , r , d) , C , s)) = l
target        (assemble ((l , r , d) , C , s)) = r
checked       (assemble ((l , r , d) , C , s)) = d
Control       (assemble ((l , r , d) , C , s)) = C
control-sound (assemble ((l , r , d) , C , s)) = s

disassemble : NativeOperation ‚Üí Extension
disassemble O = extract O , Control O , control-sound O

classification : NativeOperation ‚âÉ Extension
classification = isoToEquiv (iso disassemble assemble (Œª _ ‚Üí refl) (Œª _ ‚Üí refl))

-- Under this equivalence, install d is the pair (its certificate, the
-- canonical gauge (Œª t ‚í t ‚â° l , id)); ¬ß1 is its first projection.

------------------------------------------------------------------------
-- ‡© ¬ Every operation factors through the installation of its own
--     certificate: reindex the control along its soundness witness,
--     and every application agrees ‚î definitionally.
------------------------------------------------------------------------

module _ (O : NativeOperation) where

  installed : NativeOperation
  installed = install (checked O)

  reindex : {t : Tm} ‚Üí Control O t ‚Üí Control installed t
  reindex = control-sound O

  apply-factors : (t : Tm) (c : Control O t)
    ‚Üí apply O t c ‚â° apply installed t (reindex c)
  apply-factors t c = refl

  apply-checked-factors : (t : Tm) (c : Control O t)
    ‚Üí apply-checked O t c ‚â° apply-checked installed t (reindex c)
  apply-checked-factors t c = refl

------------------------------------------------------------------------
-- ‡ ¬ The canonical gauge's applicability space is contractible with
--     centre the source: one theorem, one locus.
------------------------------------------------------------------------

locusContr : {l r : Tm} (d : Derivation l r)
  ‚Üí isContr (Œ£[ t ‚àà Tm ] Control (install d) t)
locusContr {l} d .fst = l , refl
locusContr {l} d .snd (t , p) i = p (~ i) , Œª j ‚Üí p (~ i ‚à® j)

------------------------------------------------------------------------
-- ‡ ¬ And every gauge is a shadow of it: the applicability space of
--     any operation maps into the canonical contractible locus, over
--     the identity of terms.
------------------------------------------------------------------------

intoLocus : (O : NativeOperation)
  ‚Üí Œ£[ t ‚àà Tm ] Control O t ‚Üí Œ£[ t ‚àà Tm ] Control (install (checked O)) t
intoLocus O (t , c) = t , control-sound O c

intoLocus-over-id : (O : NativeOperation) (x : Œ£[ t ‚àà Tm ] Control O t)
  ‚Üí fst (intoLocus O x) ‚â° fst x
intoLocus-over-id O x = refl
