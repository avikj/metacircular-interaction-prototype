import Pairfield.ComputableSmith2x2Adapter
import Pairfield.DirectSmith2x2
import Pairfield.MyhillNerodeAdapter
import Pairfield.RankOneSmith2x2
import Pairfield.FiniteChuCalibration

/-!
# Checked capability joints

This module is an executable index: every closed edge below is a term whose
type names both endpoints.  Import reachability alone does not count as an
edge.  Open edges are represented only by their required input type; this file
does not inhabit them by assertion.
-/

namespace Pairfield.CapabilityGraph

universe u v

/-- A typed edge in the capability graph. -/
abbrev Edge (source : Sort u) (target : source → Sort v) :=
  (x : source) → target x

/-! ## Chu calibration → executable adaptive capability -/

/-- The executable interface exposed by a finite Chu object: one can run a
finite action word and read the resulting response.  The interface keeps the
pairing available as a certified observation predicate rather than silently
turning it into an unproved quotient. -/
structure ExecutableChuCapability (C : FiniteChu) where
  run : C.state → List C.action → C.state
  read : C.state → C.response
  run_nil : ∀ x, run x [] = x
  run_cons : ∀ x a w, run x (a :: w) = run (C.step x a) w
  read_pair : ∀ x r, C.pair x r ↔ read x = r

/-- A *calibrated* Chu datum is one whose pairing is the graph of its
observation.  `FiniteChu.pair` is an arbitrary `Prop`-valued relation, so this
is a genuine hypothesis, not a triviality: nothing in the structure forces
`pair` and `observe` to agree.

Repair note (claude, de Bruijn lineage, 2026-08-15): this hypothesis was
absent, and `chuToExecutableCapability` was stated for *every* `C : FiniteChu`
with `read_pair` discharged by `rfl`.  That statement is not merely unproved,
it is false — take `pair := fun _ _ => True` on a `C` with at least two
responses.  The kernel rejected it (`C.pair x r` not defeq to
`C.observe x = r`), which is why this module was among the three that never
compiled.  Adding the hypothesis is the smallest change that makes the
statement true; the conclusion is unchanged. -/
def Calibrated (C : FiniteChu) : Prop := ∀ x r, C.pair x r ↔ C.observe x = r

/-- A checked, calibrated Chu datum is an executable capability.  This is the
safe link: it transports only the supplied dynamics and pairing, and does not
infer a selection policy or a finite quotient. -/
def chuToExecutableCapability (C : FiniteChu) (hC : Calibrated C) :
    ExecutableChuCapability C where
  run := fun x w => w.foldl C.step x
  read := C.observe
  run_nil := by intro x; rfl
  run_cons := by
    intro x a w
    induction w generalizing x with
    | nil => rfl
    | cons b w ih => simp only [List.foldl]
  read_pair := hC

/-- The two-state Chu object is calibrated: its pairing is equality and its
observation is the identity. -/
theorem bit_calibrated : Calibrated FiniteChu.bit := by
  intro x r; rfl

def bitChuCapability : ExecutableChuCapability FiniteChu.bit :=
  chuToExecutableCapability FiniteChu.bit bit_calibrated

/-! ## Smith producer → presentation → certificate → checker -/

def diagonalProducerToPresentation :
    Edge ComputableSmith2x2.CoprimeFactors (fun f =>
      SmithPresentation
        (ComputableSmith2x2.toIntMat2
          (ComputableSmith2x2.diag (f.g * f.p) (f.g * f.q)))
        (IntMat2.diagonal f.g (f.g * f.p * f.q))) :=
  ComputableSmith2x2.toPresentation

def diagonalProducerToCertificate :
    Edge ComputableSmith2x2.CoprimeFactors (fun _ => SmithCertificate2) :=
  ComputableSmith2x2.toSmithCertificate

theorem diagonalCertificateToChecked
    (f : ComputableSmith2x2.CoprimeFactors)
    (hg : 0 ≤ f.g) (hd : 0 ≤ f.g * f.p * f.q) :
    (diagonalProducerToCertificate f).check = true :=
  ComputableSmith2x2.toSmithCertificate_check f hg hd

/-- The direct producer is closed on the complete unimodular stratum. -/
theorem unimodularProducerToValidCertificate
    (A : DirectSmith2x2.Mat2) (h : A.det.natAbs = 1) :
    ∃ c : SmithCertificate2,
      c.source = DirectSmith2x2.toIntMat2 A ∧ c.Valid ∧ c.check = true := by
  have hpm : A.det = 1 ∨ A.det = -1 := by omega
  rcases hpm with hdet | hdet
  · let c := DirectSmith2x2.unitDetCertificate A hdet
    have hc : c.Valid := DirectSmith2x2.unitDetCertificate_valid A hdet
    exact ⟨c, rfl, hc, SmithCertificate2.check_complete c hc⟩
  · let c := DirectSmith2x2.negUnitDetCertificate A hdet
    have hc : c.Valid := DirectSmith2x2.negUnitDetCertificate_valid A hdet
    exact ⟨c, rfl, hc, SmithCertificate2.check_complete c hc⟩

/-- Explicit outer-product and Bézout data close the rank-one branch through
the same checker.  Extracting this witness from a bare singular matrix remains
a separate open edge. -/
theorem rankOneWitnessToCheckedCertificate
    (w : RankOneSmith2x2.Witness) : w.certificate.check = true :=
  w.certificate_check

/-! ## observed action → residual language → quotient consumer -/

def futureToResidualLanguage {A : Type u} {X : Type v} (M : DFA A X) :
    ∀ x y, FutureEq M.step (fun state => state ∈ M.accept) x y ↔
      stateLanguage M x = stateLanguage M y :=
  futureEq_iff_stateLanguage_eq M

def residualStepSquare {A : Type u} {X : Type v} (M : DFA A X) :
    ∀ x action,
      stateLanguage M (M.step x action) =
        (stateLanguage M x).leftQuotient [action] :=
  quotient_action_residual M

def behavioralConsumer {A : Type u} {X : Type v} (M : DFA A X)
    (policy : X → A)
    (sound : ∀ ⦃x y⦄,
      FutureEq M.step (fun state => state ∈ M.accept) x y →
        policy x = policy y) :
    BehavioralState M → A :=
  selectNext M policy sound

/-!
The first missing Lean joint is deliberately a type, not a fake edge:
arbitrary integer `2×2` input must be reduced to some diagonal presentation.
An inhabitant would complete the current Smith producer graph.
-/
def ArbitrarySmithPresentation :=
  (A : IntMat2) →
    Σ d₁ d₂ : Int,
      { _p : SmithPresentation A (.diagonal d₁ d₂) //
        0 ≤ d₁ ∧ 0 ≤ d₂ ∧ (d₁ = 0 → d₂ = 0) ∧ d₁ ∣ d₂ }

end Pairfield.CapabilityGraph
