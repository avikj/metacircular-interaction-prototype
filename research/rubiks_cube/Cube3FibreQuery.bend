import RubiksFamily
import FibreElement
import FibreCoalgebra
import Cube3Optimization

# The complete typed cube object and its three readouts are sent to the
# existing coinductive fibre in one observation.  The map below is the query;
# no host-side search, candidate window, or special Rubik solver is inserted.
def cube3Map(x: PuzzleFamilyPresentation) -> Cube3Objective:
  cube3Objective(x)

def cube3Source(c: FibreElement(PuzzleFamilyPresentation, Cube3Objective, cube3Map)) -> PuzzleFamilyPresentation:
  ascend(PuzzleFamilyPresentation, Cube3Objective, cube3Map, c)

def observeCube3(x: PuzzleFamilyPresentation) -> FibreObservation(PuzzleFamilyPresentation, x, Cube3Objective, cube3Map):
  observe(PuzzleFamilyPresentation, x, fibreCoalgebra(PuzzleFamilyPresentation, x), Cube3Objective, cube3Map)

def cube3Value(c: FibreElement(PuzzleFamilyPresentation, Cube3Objective, cube3Map)) -> Cube3Objective:
  observedValue(FibreElement(PuzzleFamilyPresentation, Cube3Objective, cube3Map), Cube3Objective, cube3Map, c)

# Continue from the carried value through the same coinductive fibre.  This
# second observation is the residual readout, so the returned object retains
# the universal result and the source reconstruction path.
def cube3ResidualMap(c: FibreElement(PuzzleFamilyPresentation, Cube3Objective, cube3Map)) -> Cube3Objective:
  cube3Value(c)

def main() -> Cube3Objective:
  match observeCube3(familyPresentation()):
    case @fibreObservation{value, source, next}:
      match observe(FibreElement(PuzzleFamilyPresentation, Cube3Objective, cube3Map), value, next,
                    Cube3Objective, cube3ResidualMap):
        case @fibreObservation{second, receipt, more}:
          cube3Value(second)
