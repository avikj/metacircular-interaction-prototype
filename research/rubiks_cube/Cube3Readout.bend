# 3x3 readout declaration.  The cube object/action lives in RubiksFamily.bend.
# The supplied map is the declarative minimum-path/diameter observation.
import RubiksFamily

type WordCandidate:
  case @wordCandidate:
    word: Word
    score: U64
    valid: Set
    least: Set

def greaterNat3(a: U64, b: U64) -> Bool:
  if a === b: False
  else:
    if a === 0: False
    else:
      if b === 0: True
      else: greaterNat3(a - 1, b - 1)

def betterWord(a: WordCandidate, b: WordCandidate) -> WordCandidate:
  match a:
    case @wordCandidate{wa, sa, va, la}:
      match b:
        case @wordCandidate{wb, sb, vb, lb}:
          if greaterNat3(sa, sb): b else: a

def argminWords(xs: WordCandidate[]) -> WordCandidate:
  match xs:
    case []: @wordCandidate{@word{[]}, 0, (), ()}
    case x <> rest: betterWord(x, argminWords(rest))

# 1. Exact word constructors over the declared move alphabet.
def prependMove(m: Move, w: Word) -> Word:
  match w:
    case @word{moves}: @word{m <> moves}

def prependMoveAll(m: Move, ws: Word[]) -> Word[]:
  match ws:
    case []: []
    case w <> rest: prependMove(m, w) <> prependMoveAll(m, rest)

# 2. All words of one declared length.
def wordsOfLength(alphabet: Move[], n: U64) -> Word[]:
  if n === 0:
    [@word{[]}]
  else:
    wordsOfLengthStep(alphabet, n, alphabet)

def wordsOfLengthStep(alphabet: Move[], n: U64, choices: Move[]) -> Word[]:
  if n === 0:
    [@word{[]}]
  else:
    match choices:
      case []: []
      case m <> rest:
        append(Word, prependMoveAll(m, wordsOfLength(alphabet, n - 1)),
          wordsOfLengthStep(alphabet, n, rest))

# 3. The finite candidate window used by one concrete readout.
def wordsUpTo(alphabet: Move[], n: U64) -> Word[]:
  if n === 0:
    [@word{[]}]
  else:
    append(Word, wordsUpTo(alphabet, n - 1), wordsOfLength(alphabet, n))

# 4. Attach the declared objective and proof-relevant reachability proposition.
def candidates3(source: CubeState, target: CubeState, alphabet: Move[], bound: U64) -> WordCandidate[]:
  candidateWords3(source, target, wordsUpTo(alphabet, bound))

def candidateWords3(source: CubeState, target: CubeState, ws: Word[]) -> WordCandidate[]:
  match ws:
    case []: []
    case w <> rest:
      @wordCandidate{w, wordCost(w), reaches3(source, target, w), ()}
      <> candidateWords3(source, target, rest)

type DiameterCandidate:
  case @diameterCandidate:
    source: CubeState
    target: CubeState
    value: U64
    witness: MinPath
    maximal: Set

def betterDiameter(a: DiameterCandidate, b: DiameterCandidate) -> DiameterCandidate:
  match a:
    case @diameterCandidate{srcA, at, av, aw, ap}:
      match b:
        case @diameterCandidate{bs, bt, bv, bw, bp}:
          if greaterNat3(av, bv): a else: b

def maximumDiameters(xs: DiameterCandidate[]) -> DiameterCandidate:
  match xs:
    case []: @diameterCandidate{solved(3), solved(3), 0, minPath3(solved(3), solved(3), moveAlphabet(3)), ()}
    case x <> rest: betterDiameter(x, maximumDiameters(rest))

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
  match argminWords(candidates3(source, target, alphabet, 2)):
    case @wordCandidate{word, distance, witness, least}:
      @minPath{source, target, distance, word, witness, least}

def diameter3(states: CubeState[], alphabet: Move[]) -> Diameter:
  match maximumDiameters([@diameterCandidate{solved(3), solved(3), 0, minPath3(solved(3), solved(3), alphabet), ()}]):
    case @diameterCandidate{source, target, value, witness, maximal}:
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
