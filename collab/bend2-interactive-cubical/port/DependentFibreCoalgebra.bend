# Coinductive continuation for a dependent section f : (a:A) -> B(a).
import DependentFibreElement
import FibreCoalgebra

type DependentFibreObservation(A: Set, B: A -> Set,
                               f: all a: A. B(a), a: A):
  case @dependentFibreObservation:
    value: DependentFibreElement(A,B,f)
    source: Path(A, dependentAscend(A,B,f,value), a)
    next: FibreCoalgebra(DependentFibreElement(A,B,f), value)

def observeDependent(A: Set, B: A -> Set, f: all a: A. B(a), a: A) ->
  DependentFibreObservation(A,B,f,a):
  value = dependentDescend(A,B,f,a)
  @dependentFibreObservation{
    value,
    <_> a,
    fibreCoalgebra(DependentFibreElement(A,B,f), value)
  }
