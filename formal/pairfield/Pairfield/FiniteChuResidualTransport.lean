/- A checked transport law from Chu pairings to observational profiles. -/
import Pairfield.FiniteChuCalibration

namespace Pairfield.FiniteChu

variable {C D : FiniteChu}

/- The profile of a state records exactly which responses are paired with it.
   This is the finite Chu analogue of the residual observable carried by a
   state: the transport theorem below says that no profile information is
   lost when the response coordinate is bijectively renamed. -/
def pairProfile (C : FiniteChu) (x : C.state) : C.response → Prop :=
  fun r => C.pair x r

theorem Hom.pairProfile_naturality (f : Hom C D)
    (hresponse : Function.Bijective f.responseMap)
    (x y : C.state) :
    pairProfile C x = pairProfile C y ↔
      (∀ r : D.response,
        D.pair (f.stateMap x) r ↔ D.pair (f.stateMap y) r) := by
  constructor
  · intro h r
    obtain ⟨r', hr'⟩ := hresponse.2 r
    rw [← hr']
    rw [← f.pair_naturality, ← f.pair_naturality]
    simpa [pairProfile] using congrFun h r'
  · intro h
    funext r
    apply propext
    change C.pair x r ↔ C.pair y r
    rw [f.pair_naturality, f.pair_naturality]
    exact h (f.responseMap r)

theorem Hom.pairProfile_eq_of_eq (f : Hom C D)
    (hresponse : Function.Bijective f.responseMap)
    {x y : C.state} (hxy : pairProfile C x = pairProfile C y) :
    ∀ r : D.response,
      D.pair (f.stateMap x) r ↔ D.pair (f.stateMap y) r := by
  exact (f.pairProfile_naturality hresponse x y).1 hxy

theorem bitIdentity_pairProfile_transport (x y : bit.state) :
    pairProfile bit x = pairProfile bit y ↔
      ∀ r : bit.response, bit.pair x r ↔ bit.pair y r := by
  simpa [bitIdentity] using (bitIdentity.pairProfile_naturality
    (Function.bijective_id) x y)

end Pairfield.FiniteChu
