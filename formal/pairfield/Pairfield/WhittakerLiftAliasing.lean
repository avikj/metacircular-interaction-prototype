import Pairfield.FiniteKloostermanCompletion
import Pairfield.KuznetsovSingleKernelBoundary

/-!
# Residue-frequency aliasing at the Whittaker seam

Finite Fourier completion supplies a first Kloosterman index only modulo the
modulus.  A classical `GL₂` Kuznetsov formula uses an integer Whittaker index,
and its archimedean Bessel argument changes when that integer is replaced by
a different lift of the same residue.

The modulus-five control below isolates this missing datum.  It does not say
that no coherent lift/sum over lifts can be constructed; it says that the
finite residue identity itself has not constructed one.
-/

namespace Pairfield.WhittakerLiftAliasing

open FiniteKloostermanCompletion
open KuznetsovSingleKernelBoundary

/-- Integer frequencies one and six alias modulo five. -/
theorem one_eq_six_mod_five : (1 : ZMod 5) = 6 := by decide

/-- Consequently the finite Kloosterman sum cannot distinguish these two
integer representatives. -/
theorem kloosterman_one_eq_six_mod_five (n : ZMod 5) :
    kloostermanSum (1 : ZMod 5) n = kloostermanSum (6 : ZMod 5) n := by
  rw [one_eq_six_mod_five]

/-- The two possible integer lifts, with the same second index and modulus. -/
def integerLiftOne : ModeIndex := ⟨1, 1, 5⟩
def integerLiftSix : ModeIndex := ⟨6, 1, 5⟩

/-- Their archimedean Bessel coordinates are different. -/
theorem besselArgument_distinguishes_lifts :
    Pairfield.KuznetsovSingleKernelBoundary.besselArgumentSquared
        integerLiftOne ≠
      Pairfield.KuznetsovSingleKernelBoundary.besselArgumentSquared
        integerLiftSix := by
  norm_num [Pairfield.KuznetsovSingleKernelBoundary.besselArgumentSquared,
    integerLiftOne, integerLiftSix]

/-- No residue-level decoder can recover every nonnegative integer frequency.
This is the exact aliasing obstruction before any automorphic analysis. -/
theorem no_exact_integer_lift_decoder :
    ¬∃ decode : ZMod 5 → ℕ, ∀ frequency : ℕ,
      decode (frequency : ZMod 5) = frequency := by
  rintro ⟨decode, replay⟩
  have one : decode (1 : ZMod 5) = 1 := by simpa using replay 1
  have six : decode (6 : ZMod 5) = 6 := by simpa using replay 6
  have collision : decode (1 : ZMod 5) = decode (6 : ZMod 5) :=
    congrArg decode one_eq_six_mod_five
  omega

end Pairfield.WhittakerLiftAliasing
