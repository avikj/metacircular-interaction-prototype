import RubiksFamily

# Proof-relevant declarative object for the 3x3 Rubik action.  The values in
# this file are the mathematical relation and its requested readouts; no
# bounded word list or guessed numeric answer is inserted here.

type Reachability3:
  case @reachability3:
    source: CubeState
    target: CubeState
    alphabet: Move[]
    accepts: Word -> Set
    cost: Word -> U64

def reach3(source: CubeState, target: CubeState, w: Word) -> Set:
  reaches(source, target, w)

def cost3(w: Word) -> U64:
  match w:
    case @word{moves}: wordLength(moves)

def relation3(source: CubeState, target: CubeState, alphabet: Move[]) -> Reachability3:
  @reachability3{source, target, alphabet, lambda w. reach3(source, target, w), lambda w. cost3(w)}

def relationAccepts3(r: Reachability3, w: Word) -> Set:
  match r:
    case @reachability3{source, target, alphabet, accepts, cost}: accepts(w)

def relationCost3(r: Reachability3, w: Word) -> U64:
  match r:
    case @reachability3{source, target, alphabet, accepts, cost}: cost(w)

# This is the proof object the universal least-witness map must return.
# `least` quantifies over the complete legal Word domain, so a finite depth
# cutoff cannot inhabit it.  `residual` is retained as a first-class result.
type LeastWitness3:
  case @leastWitness3:
    relation: Reachability3
    word: Word
    distance: U64
    reaches: Set
    least: all w: Word. relationAccepts3(relation, w) -> distance <= relationCost3(relation, w)
    residual: Set

# A MuDomain query names the relation and the exact proof-relevant codomain.
# The fibre's result is a LeastWitness3 inhabiting this query.
type MuDomainQuery3:
  case @muDomainQuery3:
    relation: Reachability3

def muDomain3(r: Reachability3) -> MuDomainQuery3:
  @muDomainQuery3{r}

type PairMinimumQuery3:
  case @pairMinimumQuery3:
    source: CubeState
    target: CubeState
    relation: Reachability3
    minimum: MuDomainQuery3

def pairMinimumQuery3(source: CubeState, target: CubeState, alphabet: Move[]) -> PairMinimumQuery3:
  @pairMinimumQuery3{source, target, relation3(source, target, alphabet),
    muDomain3(relation3(source, target, alphabet))}

type PairMinimumMapQuery3:
  case @pairMinimumMapQuery3:
    states: CubeState[]
    alphabet: Move[]
    minimum: CubeState -> CubeState -> PairMinimumQuery3
    residual: Set

def pairMapQuery3(states: CubeState[], alphabet: Move[]) -> PairMinimumMapQuery3:
  @pairMinimumMapQuery3{states, alphabet, lambda source. lambda target.
    pairMinimumQuery3(source, target, alphabet), all source: CubeState. all target: CubeState. all w: Word. relationAccepts3(relation3(source, target, alphabet), w)}

# The diameter query is the maximum of the actual pairwise MuDomain answers.
# Its codomain carries both required proof fields; the fibre supplies their
# inhabitants together with any residual obligation.
# This is the exact result type returned by the diameter readout.  The
# universal map inhabits it; it is not confused with the query below.
type DiameterWitness3:
  case @diameterWitness3:
    states: CubeState[]
    pairwise: PairMinimumMapQuery3
    diameter: U64
    realizingSource: CubeState
    realizingTarget: CubeState
    realizingMinimum: LeastWitness3
    upperBound: Set
    realizingEquality: Set
    residual: Set

type DiameterQuery3:
  case @diameterQuery3:
    states: CubeState[]
    pairwise: PairMinimumMapQuery3
    result: DiameterWitness3 -> Set

def diameterQuery3(states: CubeState[], alphabet: Move[]) -> DiameterQuery3:
  @diameterQuery3{states, pairMapQuery3(states, alphabet),
    lambda result. Path(DiameterWitness3, result, result)}

type Cube3Objective:
  case @cube3Objective:
    sourceObject: PuzzleFamilyPresentation
    relation: CubeState -> CubeState -> Reachability3
    pairwise: PairMinimumMapQuery3
    diameter: DiameterQuery3
    residual: Set

def cube3Objective(x: PuzzleFamilyPresentation) -> Cube3Objective:
  @cube3Objective{
    x,
    lambda source. lambda target. relation3(source, target, moveAlphabet(3)),
    pairMapQuery3(familyCubeStates(family()), moveAlphabet(3)),
    diameterQuery3(familyCubeStates(family()), moveAlphabet(3)),
    all source: CubeState. all target: CubeState. all w: Word. relationAccepts3(relation3(source, target, moveAlphabet(3)), w)}
