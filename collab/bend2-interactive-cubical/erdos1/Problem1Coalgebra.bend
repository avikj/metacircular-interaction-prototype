# The complete Erdos proposition is passed as a Set-valued object to the
# existing generic fibre coalgebra. No bounded witness stream or Bool flags.
import FibreCoalgebra
import Problem1Statement

def propositionObject() -> Set:
  proposition()

def propositionObservation(P: Set) -> Set:
  P

def problem1Coalgebra() -> FibreCoalgebra(Set, propositionObject()):
  fibreCoalgebra(Set, propositionObject())

def problem1Observation() -> FibreObservation(Set, propositionObject(), Set, propositionObservation):
  observe(Set, propositionObject(), problem1Coalgebra(), Set, propositionObservation)

def carriedProposition() -> FibreElement(Set, Set, propositionObservation):
  match problem1Observation():
    case @fibreObservation{value, source, next}: value

def main() -> Set:
  observedValue(Set, Set, propositionObservation, carriedProposition())
