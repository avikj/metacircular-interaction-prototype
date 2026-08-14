import Pairfield.CapabilityGraph
import Pairfield.GeneralSmith2x2

/-!
# Closing the first open typed joint of the capability graph

`Pairfield/CapabilityGraph.lean` recorded `ArbitrarySmithPresentation` as a
*type* with no inhabitant: an arbitrary integral `2×2` matrix reduced to a
declared Smith diagonal with all four normal-form side conditions.  Recording
an open edge as an uninhabited type rather than an asserted arrow is what makes
this closure checkable rather than rhetorical.

`Pairfield/GeneralSmith2x2.lean` supplies the inhabitant.

**Caveat, stated in the module rather than only in a note.** The first spelling
of the upstream type used `SmithPresentation A (.diagonal d₁ d₂) ×
(0 ≤ d₁ ∧ …)`. On a source-clean replay this fails because the second
factor is a `Prop` where `Prod` expects a `Type`. The capability graph now uses
the subtype form already carried by `Pairfield.arbitrarySmithPresentation'` in
`GeneralSmith2x2.lean`. See `notes/GENERAL_SMITH_PRODUCER.md` §11.
-/

namespace Pairfield.CapabilityGraph

/-- The previously open edge, closed by a total executable producer. -/
def arbitrarySmithPresentation : ArbitrarySmithPresentation := fun A =>
  ⟨(smith A).d₁, (smith A).d₂, (smith A).toPresentation,
    (smith A).nonneg₁, (smith A).nonneg₂, (smith A).zero_zero,
    (smith A).divides⟩

/-- The same producer's certificate passes the shared untrusted-producer gate
for *every* input, so the graph's producer stratum is no longer partial.  This
statement does not depend on the open-joint type and is checked regardless. -/
theorem arbitraryProducerToCheckedCertificate (A : IntMat2) :
    (smithCertificate A).source = A ∧ (smithCertificate A).check = true :=
  ⟨rfl, smithCertificate_check A⟩

end Pairfield.CapabilityGraph
