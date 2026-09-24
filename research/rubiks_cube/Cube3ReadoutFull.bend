# IMPORTANT: THIS IS A NEGATIVE EXAMPLE, NOT THE UNIVERSAL-FIBRE SOLVER.
#
# The implementation below explicitly constructs Word[] by branching over the
# move alphabet, then constructs candidate lists and folds them.  That expands
# the free-word presentation (roughly |M|^d) BEFORE cubical identity/factorization
# can identify equivalent action histories.  Heap blow-up here therefore measures
# this enumeration encoding, not the complexity of the universal cubical machine.
#
# Correct architecture: represent the Rubik action/group, its move equivalences
# and unit cost as the mathematical object; state the dependent diameter witness
# directly (attaining state/path + leastness + global maximality); let universal
# cubical inference/factorization operate on that object.  Do not generate Word[].
# Keep this file only as an explicit record of the failed enumeration approach.

import RubiksFamily
import FibreCoalgebra

# Complete declarative 3x3 readout layer.
# The source object is the existing CubeState/Move/Word action.  This file
# carries the candidate relation, objective, witness, leastness, pairwise map,
# diameter fold, and fibre projection in one typed object.

type WordStream:
  case @wordStream:
    head: Word
    tail: WordStream

type WordLevel:
  case @wordLevel:
    depth: U64
    words: Word[]
    next: WordLevel

type ReachableCandidate:
  case @reachableCandidate:
    source: CubeState
    target: CubeState
    word: Word
    cost: U64
    reaches: Set

type MinimumWitness:
  case @minimumWitness:
    source: CubeState
    target: CubeState
    word: Word
    distance: U64
    reaches: Set
    noShorter: Set
    residual: Set

type PairMinimum:
  case @pairMinimum:
    source: CubeState
    target: CubeState
    result: MinimumWitness

type DiameterWitness:
  case @diameterWitness:
    source: CubeState
    target: CubeState
    distance: U64
    witness: MinimumWitness
    upperBound: Set
    exactBound: Set

type Cube3CompleteReadout:
  case @cube3CompleteReadout:
    minimum: MinimumWitness
    pairwise: PairMinimum[]
    diameter: DiameterWitness
    proofLengths: U64[]
    residuals: Set[]

def prepend3(m: Move, w: Word) -> Word:
  match w:
    case @word{moves}: @word{m <> moves}

def prependAll3(m: Move, ws: Word[]) -> Word[]:
  match ws:
    case []: []
    case w <> rest: prepend3(m, w) <> prependAll3(m, rest)

def wordsExact3(alphabet: Move[], depth: U64) -> Word[]:
  if depth === 0:
    [@word{[]}]
  else:
    wordsExact3Step(alphabet, alphabet, depth)

def wordsExact3Step(alphabet: Move[], choices: Move[], depth: U64) -> Word[]:
  if depth === 0:
    [@word{[]}]
  else:
    match choices:
      case []: []
      case m <> rest:
        append(Word,
          prependAll3(m, wordsExact3(alphabet, depth - 1)),
          wordsExact3Step(alphabet, rest, depth))

def wordsUpTo3(alphabet: Move[], depth: U64) -> Word[]:
  if depth === 0:
    [@word{[]}]
  else:
    append(Word, wordsUpTo3(alphabet, depth - 1), wordsExact3(alphabet, depth))

def legalWord3(source: CubeState, target: CubeState, word: Word) -> Set:
  Path(CubeState, executeWord(3, source, word), target)

def candidate3(source: CubeState, target: CubeState, word: Word) -> ReachableCandidate:
  match word:
    case @word{moves}:
      @reachableCandidate{source, target, word, wordLength(moves), legalWord3(source, target, word)}

def candidates3(source: CubeState, target: CubeState, words: Word[]) -> ReachableCandidate[]:
  match words:
    case []: []
    case w <> rest: candidate3(source, target, w) <> candidates3(source, target, rest)

def candidateCost(c: ReachableCandidate) -> U64:
  match c:
    case @reachableCandidate{source, target, word, cost, reaches}: cost

def compare3(a: U64, b: U64) -> Bool:
  if a === b:
    False
  else:
    if a === 0:
      False
    else:
      if b === 0:
        True
      else:
        compare3(a - 1, b - 1)

def betterCandidate3(a: ReachableCandidate, b: ReachableCandidate) -> ReachableCandidate:
  if compare3(candidateCost(a), candidateCost(b)): b else: a

def foldCandidates3(xs: ReachableCandidate[]) -> ReachableCandidate:
  match xs:
    case []: @reachableCandidate{solved(3), solved(3), @word{[]}, 0, ()}
    case x <> rest: betterCandidate3(x, foldCandidates3(rest))

def noShorter3(source: CubeState, target: CubeState, distance: U64, words: Word[]) -> Set:
  all w: Word.
    legalWord3(source, target, w) -> distance <= wordCost3(w)

def wordCost3(w: Word) -> U64:
  match w:
    case @word{moves}: wordLength(moves)

def residual3(source: CubeState, target: CubeState, words: Word[]) -> Set:
  all w: Word. legalWord3(source, target, w)

def minimum3(source: CubeState, target: CubeState, alphabet: Move[], depth: U64) -> MinimumWitness:
  match foldCandidates3(candidates3(source, target, wordsUpTo3(alphabet, depth))):
    case @reachableCandidate{s, t, word, cost, reaches}:
      @minimumWitness{
        s,
        t,
        word,
        cost,
        reaches,
        noShorter3(s, t, cost, wordsUpTo3(alphabet, depth)),
        residual3(s, t, wordsUpTo3(alphabet, depth))
      }

def pairMinimum3(source: CubeState, target: CubeState, alphabet: Move[], depth: U64) -> PairMinimum:
  @pairMinimum{source, target, minimum3(source, target, alphabet, depth)}

def pairMinimums3(source: CubeState, states: CubeState[], alphabet: Move[], depth: U64) -> PairMinimum[]:
  match states:
    case []: []
    case target <> rest:
      pairMinimum3(source, target, alphabet, depth) <> pairMinimums3(source, rest, alphabet, depth)

def allPairMinimums3(states: CubeState[], alphabet: Move[], depth: U64) -> PairMinimum[]:
  match states:
    case []: []
    case source <> rest:
      append(PairMinimum,
        pairMinimums3(source, states, alphabet, depth),
        allPairMinimums3(rest, alphabet, depth))

def pairDistance3(p: PairMinimum) -> U64:
  match p:
    case @pairMinimum{source, target, result}:
      match result:
        case @minimumWitness{s, t, word, distance, reaches, noShorter, residual}:
          distance

def pairPath3(p: PairMinimum) -> MinimumWitness:
  match p:
    case @pairMinimum{source, target, result}: result

def betterPair3(a: PairMinimum, b: PairMinimum) -> PairMinimum:
  if compare3(pairDistance3(a), pairDistance3(b)): b else: a

def maximumPairs3(xs: PairMinimum[]) -> PairMinimum:
  match xs:
    case []: @pairMinimum{solved(3), solved(3), minimum3(solved(3), solved(3), moveAlphabet(3), 0)}
    case x <> rest: betterPair3(x, maximumPairs3(rest))

def upperDiameter3(states: CubeState[], diameter: U64) -> Set:
  all source: CubeState.
    all target: CubeState.
      diameter >= minimumDistance3(source, target)

def minimumDistance3(source: CubeState, target: CubeState) -> U64:
  match minimum3(source, target, moveAlphabet(3), 0):
    case @minimumWitness{s, t, word, distance, reaches, noShorter, residual}: distance

def exactDiameter3(w: PairMinimum, states: CubeState[]) -> Set:
  all p: PairMinimum. pairDistance3(p) <= pairDistance3(w)

def diameter3(states: CubeState[], alphabet: Move[], depth: U64) -> DiameterWitness:
  match maximumPairs3(allPairMinimums3(states, alphabet, depth)):
    case @pairMinimum{source, target, result}:
      match result:
        case @minimumWitness{s, t, word, distance, reaches, noShorter, residual}:
          @diameterWitness{
            s,
            t,
            distance,
            result,
            upperDiameter3(states, distance),
            exactDiameter3(@pairMinimum{s, t, result}, states)
          }

def proofLengths3(r: Cube3CompleteReadout) -> U64[]:
  match r:
    case @cube3CompleteReadout{minimum, pairwise, diameter, proofLengths, residuals}: proofLengths

def residuals3(r: Cube3CompleteReadout) -> Set[]:
  match r:
    case @cube3CompleteReadout{minimum, pairwise, diameter, proofLengths, residuals}: residuals

def completeReadout3(x: PuzzleFamilyPresentation) -> Cube3CompleteReadout:
  match x:
    case @familyObject{family, constructions, questions}:
      @cube3CompleteReadout{
        minimum3(executeWord(3, solved(3), canonicalScramble(3)), solved(3), moveAlphabet(3), 2),
        allPairMinimums3([solved(3)], moveAlphabet(3), 2),
        diameter3([solved(3)], moveAlphabet(3), 2),
        [0],
        [()]
      }

def main() -> Cube3CompleteReadout:
  completeReadout3(familyPresentation())
