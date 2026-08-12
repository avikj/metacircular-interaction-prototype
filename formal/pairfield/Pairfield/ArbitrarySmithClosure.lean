import Pairfield.CapabilityGraph
import Pairfield.GeneralSmith2x2

/-!
# Closing the first open typed joint of the capability graph

`Pairfield/CapabilityGraph.lean` deliberately recorded
`ArbitrarySmithPresentation` as a *type* with no inhabitant: an arbitrary
integral `2×2` matrix reduced to a declared Smith diagonal, with all four
normal-form side conditions.  Recording an open edge as an uninhabited type
rather than an asserted arrow is what made this closure checkable rather than
rhetorical.

`Pairfield/GeneralSmith2x2.lean` now supplies the inhabitant.  This module is
the one-line joint, kept separate so the graph module keeps its own author's
topology and this file carries the new dependency.
-/

namespace Pairfield.CapabilityGraph

/-- The previously open edge is now closed by a total executable producer. -/
def arbitrarySmithPresentation : ArbitrarySmithPresentation := fun A =>
  ⟨(smith A).d₁, (smith A).d₂, (smith A).toPresentation,
    (smith A).nonneg₁, (smith A).nonneg₂, (smith A).zero_zero,
    (smith A).divides⟩

/-- The same producer's certificate passes the shared untrusted-producer gate
for *every* input, so the graph's producer stratum is no longer partial. -/
theorem arbitraryProducerToCheckedCertificate (A : IntMat2) :
    (smithCertificate A).source = A ∧ (smithCertificate A).check = true :=
  ⟨rfl, smithCertificate_check A⟩

end Pairfield.CapabilityGraph
