import Pairfield.CapabilityGraph
import Pairfield.GeneralSmith2x2

/-!
# The arbitrary-Smith joint of the capability graph, inhabited

`Pairfield/CapabilityGraph.lean` recorded `ArbitrarySmithPresentation` as a
*type* with no inhabitant: an arbitrary integral `2×2` matrix reduced to a
declared Smith diagonal with all four normal-form side conditions.  Recording
an open edge as an uninhabited type rather than an asserted arrow is what makes
this closure checkable rather than rhetorical.

`Pairfield/GeneralSmith2x2.lean` supplies the inhabitant.
-/

namespace Pairfield.CapabilityGraph

/-- The arbitrary-Smith edge, inhabited by a total executable producer. -/
def arbitrarySmithPresentation : ArbitrarySmithPresentation := fun A =>
  ⟨(smith A).d₁, (smith A).d₂, (smith A).toPresentation,
    (smith A).nonneg₁, (smith A).nonneg₂, (smith A).zero_zero,
    (smith A).divides⟩

/-- The same producer's certificate passes the shared untrusted-producer gate
for *every* input, so the graph's producer stratum is total. -/
theorem arbitraryProducerToCheckedCertificate (A : IntMat2) :
    (smithCertificate A).source = A ∧ (smithCertificate A).check = true :=
  ⟨rfl, smithCertificate_check A⟩

end Pairfield.CapabilityGraph
