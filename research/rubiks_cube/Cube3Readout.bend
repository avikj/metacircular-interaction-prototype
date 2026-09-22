# 3x3 readout declaration.  The cube object/action lives in RubiksFamily.bend.
# The supplied map is the declarative minimum-path/diameter observation.
import RubiksFamily

type MinPath:
  case @minPath:
    source: CubeState
    target: CubeState
    distance: U64
    word: Word
    reach: Set
    least: Set

type Diameter:
  case @diameter:
    distance: U64
    source: CubeState
    target: CubeState
    witness: MinPath
    maximal: Set

type Cube3Readout:
  case @cube3Readout:
    minimum: MinPath
    diameter: Diameter

def reaches3(source: CubeState, target: CubeState, word: Word) -> Set:
  Path(CubeState, executeWord(3, source, word), target)

def wordCost(word: Word) -> U64:
  match word:
    case @word{moves}: wordLength(moves)

def minPath3(source: CubeState, target: CubeState, alphabet: Move[]) -> MinPath:
  match argmin(Word, lambda word. reaches3(source, target, word), lambda word. wordCost(word), alphabet):
    case @argminResult{word, distance, witness, least}:
      @minPath{source, target, distance, word, witness, least}

def diameter3(states: CubeState[], alphabet: Move[]) -> Diameter:
  match maximum(CubeState, CubeState,
               lambda source. lambda target. minPath3(source, target, alphabet), states):
    case @maximumResult{source, target, value, witness, maximal}:
      @diameter{value, source, target, witness, maximal}

def cube3Readout(x: PuzzleFamilyPresentation) -> Cube3Readout:
  match x:
    case @familyObject{family, constructions, questions}:
      @cube3Readout{
        minPath3(executeWord(3, solved(3), canonicalScramble(3)), solved(3), moveAlphabet(3)),
        diameter3([solved(3)], moveAlphabet(3))
      }

def main() -> Cube3Readout:
  cube3Readout(familyPresentation())
