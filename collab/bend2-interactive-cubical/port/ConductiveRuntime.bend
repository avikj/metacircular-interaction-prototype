# Canonical runtime semantics shared by the checked Bend implementation and
# Target.HVM4Full's intrinsic entry.
#
# IMPORTANT: this file is the specification/source of truth for the tiny HVM
# bootstrap spelling currently embedded in the full target. The bootstrap must
# be deleted once the compiler's standard-library linker can include this
# module directly; until then CI compares the same operations end-to-end.
#
# Representation:
#   FibreElement(A,B,f) = @fibreCarry{base:A, carried:B, witness:f(base)=carried}
#   FibreObservation    = @fibreObservation{value, source, next}
#   FibreCoalgebra      = @fibreCoalgebra{respond}
#
# Semantics:
#   descend a = (a,f(a),refl)
#   observation changes the whole from A to FibreElement(A,B,f)
#   next is fibreCoalgebra(FibreElement(...), value)
#   visible projection = carried
#   second observation by ascend recovers the source exactly.
#
# Do not add policy/search/optimization here. This is only THE LAW and its
# coinductive closure. All derivational/cubical structure remains ordinary
# structure of the object/type theory.

import FibreCoalgebra

def canonicalWhole(A: Set, a: A) -> FibreCoalgebra(A, a):
  fibreCoalgebra(A, a)

def canonicalVisible(A: Set, a: A) -> A:
  observe_visible(A, a, A, lambda x. x)

def canonicalRecover(A: Set, a: A) -> A:
  observe_recover(A, a, A, lambda x. x)

def canonicalVisibleBeta(A: Set, a: A) -> Path(A, canonicalVisible(A, a), a):
  <_> a

def canonicalRecoverBeta(A: Set, a: A) -> Path(A, canonicalRecover(A, a), a):
  <_> a

def main() -> Nat:
  canonicalRecover(Nat, 2n)
