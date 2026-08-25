import Mathlib.MeasureTheory.Function.LpSpace.Basic
import Mathlib.MeasureTheory.Measure.Restrict

/-!
# Haar-null process boundary

A null-supported signal is the zero vector in `L²`.  Consequently no bounded
linear postprocessing internal to that Hilbert-space representation can recover
the null event.  The theorem is measure-theoretic; Haar measure is the intended
application, not an extra hypothesis.
-/

open Set
open scoped ENNReal

namespace Pairfield.HaarNullProcess

open MeasureTheory

variable {α H : Type*} [MeasurableSpace α]

/-- A signal supported by a null set is zero almost everywhere. -/
theorem nullSupported_ae_zero
    (μ : Measure α) (s : Set α) (f : α → ℂ) (hs : μ s = 0) :
    s.indicator f =ᵐ[μ] 0 :=
  indicator_meas_zero hs

/-- Whenever a null-supported signal defines an `L²` class, that class is zero. -/
theorem nullSupported_toLp_eq_zero
    (μ : Measure α) (s : Set α) (f : α → ℂ) (hs : μ s = 0)
    (hf : MemLp (s.indicator f) 2 μ) :
    hf.toLp (s.indicator f) = 0 := by
  have hzero : MemLp (0 : α → ℂ) 2 μ := MemLp.zero
  exact hf.toLp_congr hzero (nullSupported_ae_zero μ s f hs) |>.trans hzero.toLp_zero

/-- The null-supported class has exactly zero Hilbert-space norm. -/
theorem nullSupported_norm_eq_zero
    (μ : Measure α) (s : Set α) (f : α → ℂ) (hs : μ s = 0)
    (hf : MemLp (s.indicator f) 2 μ) :
    ‖hf.toLp (s.indicator f)‖ = 0 := by
  rw [nullSupported_toLp_eq_zero μ s f hs hf, norm_zero]

/-- Bounded linear processing cannot revive a null-supported `L²` signal. -/
theorem boundedPostprocess_nullSupported_eq_zero
    [NormedAddCommGroup H] [NormedSpace ℂ H]
    (μ : Measure α) (s : Set α) (f : α → ℂ) (hs : μ s = 0)
    (hf : MemLp (s.indicator f) 2 μ)
    (T : Lp ℂ 2 μ →L[ℂ] H) :
    T (hf.toLp (s.indicator f)) = 0 := by
  rw [nullSupported_toLp_eq_zero μ s f hs hf]
  exact T.map_zero

end Pairfield.HaarNullProcess
