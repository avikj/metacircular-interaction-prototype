# `FibreCoalgebra` is the coinductive source previously called `WholeProcess`.
# Its observation `(B, f)` is also a query, map, function, or morphism request;
# `f : A -> B` is the actual mathematical computation and B is its codomain.
# `FibreObservation` was previously called `WholeReply`; `FibreElement` was
# previously called `Carrier`. Those names remain in compatibility ports.
# Every observation retains the source in its new carried state.
import FibreElement

type FibreCoalgebra(A: Set, a: A):
  case @fibreCoalgebra:
    respond: all B: Set. all f: A -> B. FibreObservation(A, a, B, f)

type FibreObservation(A: Set, a: A, B: Set, f: A -> B):
  case @fibreObservation:
    value: FibreElement(A, B, f)
    source: Path(A, ascend(A, B, f, value), a)
    next: FibreCoalgebra(FibreElement(A, B, f), value)

def fibreObservation(A: Set, a: A, B: Set, f: A -> B,
               value: FibreElement(A, B, f), source: Path(A, ascend(A, B, f, value), a)) -> FibreObservation(A, a, B, f):
  @fibreObservation{value, source, fibreCoalgebra(FibreElement(A, B, f), value)}

def fibreCoalgebra(A: Set, a: A) -> FibreCoalgebra(A, a):
  @fibreCoalgebra{lambda B. lambda f. fibreObservation(A, a, B, f,
    descend(A, B, f, a), <_> a)}

# FibreElement.carry_transport_descend proves this beta reduction definitionally.
# Use that computed carrier in each continuing step; the generic univalent
# transport remains available, with the same value, in FibreElement.bend.

def observe(A: Set, a: A, p: FibreCoalgebra(A, a), B: Set, f: A -> B) -> FibreObservation(A, a, B, f):
  match p: case @fibreCoalgebra{respond}: respond(B, f)

def observedValue(A: Set, B: Set, f: A -> B, value: FibreElement(A, B, f)) -> B:
  match value: case @fibreCarry{base, carried, witness}: carried
