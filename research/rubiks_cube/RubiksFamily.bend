# A declarative Rubik-family state/action object.
#
# This file contains the puzzle construction only.  It does not implement a
# search or choose a factorization.  State is an exact labelled facelet object;
# legal moves are geometric layer actions; words and target predicates are
# ordinary mathematical data supplied to the existing coinductive process.
import FibreCoalgebra
import MyhillNerodeMinimalMachine

type Face:
  case @u:
  case @r:
  case @f:
  case @d:
  case @l:
  case @b:

type Axis:
  case @axisX:
  case @axisY:
  case @axisZ:

type Turn:
  case @quarter:
  case @inverse:
  case @half:

type Move:
  case @move:
    axis: Axis
    layer: U64
    turn: Turn

type Sticker:
  case @sticker:
    x: U64
    y: U64
    z: U64
    face: Face
    colour: U64

type CubeState:
  case @cubeState:
    size: U64
    stickers: Sticker[]

type Cuboid:
  case @cuboid:
    x: U64
    y: U64
    z: U64

type CuboidSticker:
  case @cuboidSticker:
    x: U64
    y: U64
    z: U64
    face: Face
    colour: U64

type CuboidState:
  case @cuboidState:
    dimensions: Cuboid
    stickers: CuboidSticker[]

type MinxSticker:
  case @minxSticker:
    face: U64
    index: U64
    colour: U64

type MinxState:
  case @minxState:
    faceSize: U64
    faceCount: U64
    faceColours: U64[]

type PuzzleInstance:
  case @cubeInstance:
    state: CubeState
  case @cuboidInstance:
    state: CuboidState
  case @minxInstance:
    state: MinxState

type PuzzleFamilyMember:
  case @cubeConstruction:
    size: U64
  case @cuboidConstruction:
    dimensions: Cuboid
  case @minxConstruction:
    faceSize: U64

type Word:
  case @word:
    moves: Move[]

def append(A: Set, xs: A[], ys: A[]) -> A[]:
  match xs:
    case []: ys
    case x <> rest: x <> append(A, rest, ys)

def mapList(A: Set, B: Set, f: A -> B, xs: A[]) -> B[]:
  match xs:
    case []: []
    case x <> rest: f(x) <> mapList(A, B, f, rest)

def row(n: U64, face: Face, colour: U64, y: U64, acc: Sticker[]) -> Sticker[]:
  if y === n:
    acc
  else:
    faceRow(n, face, colour, y, 0, acc)

def faceRow(n: U64, face: Face, colour: U64, y: U64, x: U64, acc: Sticker[]) -> Sticker[]:
  if x === n:
    row(n, face, colour, y + 1, acc)
  else:
    # The six faces use one common coordinate cube.  The generated facelets
    # are labelled by face and colour; move rotation updates both position and
    # face normal, so this is a complete state carrier for every N.
    match face:
      case @u: faceRow(n, face, colour, y, x + 1, @sticker{x, n - 1, y, face, colour} <> acc)
      case @d: faceRow(n, face, colour, y, x + 1, @sticker{x, 0, y, face, colour} <> acc)
      case @f: faceRow(n, face, colour, y, x + 1, @sticker{x, y, n - 1, face, colour} <> acc)
      case @b: faceRow(n, face, colour, y, x + 1, @sticker{x, y, 0, face, colour} <> acc)
      case @r: faceRow(n, face, colour, y, x + 1, @sticker{n - 1, y, x, face, colour} <> acc)
      case @l: faceRow(n, face, colour, y, x + 1, @sticker{0, y, x, face, colour} <> acc)

def face(n: U64, f: Face, colour: U64) -> Sticker[]:
  row(n, f, colour, 0, [])

def solvedStickers(n: U64) -> Sticker[]:
  append(Sticker, face(n, @u, 0),
    append(Sticker, face(n, @r, 1),
      append(Sticker, face(n, @f, 2),
        append(Sticker, face(n, @d, 3),
          append(Sticker, face(n, @l, 4), face(n, @b, 5))))))

def solved(n: U64) -> CubeState:
  @cubeState{n, solvedStickers(n)}

def cuboidFace(n: U64, m: U64, f: Face, colour: U64, rowNo: U64, acc: CuboidSticker[]) -> CuboidSticker[]:
  if rowNo === m:
    acc
  else:
    cuboidRow(n, m, f, colour, rowNo, 0, acc)

def cuboidRow(n: U64, m: U64, f: Face, colour: U64, rowNo: U64, colNo: U64, acc: CuboidSticker[]) -> CuboidSticker[]:
  if colNo === n:
    cuboidFace(n, m, f, colour, rowNo + 1, acc)
  else:
    match f:
      case @u: cuboidRow(n, m, f, colour, rowNo, colNo + 1, @cuboidSticker{colNo, m - 1, rowNo, f, colour} <> acc)
      case @d: cuboidRow(n, m, f, colour, rowNo, colNo + 1, @cuboidSticker{colNo, 0, rowNo, f, colour} <> acc)
      case @f: cuboidRow(n, m, f, colour, rowNo, colNo + 1, @cuboidSticker{colNo, rowNo, m - 1, f, colour} <> acc)
      case @b: cuboidRow(n, m, f, colour, rowNo, colNo + 1, @cuboidSticker{colNo, rowNo, 0, f, colour} <> acc)
      case @r: cuboidRow(n, m, f, colour, rowNo, colNo + 1, @cuboidSticker{m - 1, rowNo, colNo, f, colour} <> acc)
      case @l: cuboidRow(n, m, f, colour, rowNo, colNo + 1, @cuboidSticker{0, rowNo, colNo, f, colour} <> acc)

def solvedCuboidFaces(d: Cuboid) -> CuboidSticker[]:
  match d:
    case @cuboid{x, y, z}:
      append(CuboidSticker, cuboidFace(x, z, @u, 0, 0, 0, []),
        append(CuboidSticker, cuboidFace(x, z, @d, 3, 0, 0, []),
          append(CuboidSticker, cuboidFace(x, y, @f, 2, 0, 0, []),
            append(CuboidSticker, cuboidFace(x, y, @b, 5, 0, 0, []),
              append(CuboidSticker, cuboidFace(z, y, @r, 1, 0, 0, []), cuboidFace(z, y, @l, 4, 0, 0, []))))))

def solvedCuboid(d: Cuboid) -> CuboidState:
  @cuboidState{d, solvedCuboidFaces(d)}

def solvedMinx(size: U64) -> MinxState:
  # A solved dodecahedral face is uniform.  The faceSize parameter determines
  # its finite facelet grid; one colour entry per face is the exact compact
  # solved-state presentation, with no unbounded numeric cursor to reduce.
  @minxState{size, 12, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]}

def onLayer(axis: Axis, layer: U64, s: Sticker) -> Bool:
  match s:
    case @sticker{x, y, z, f, c}:
      match axis:
        case @axisX: x === layer
        case @axisY: y === layer
        case @axisZ: z === layer

def turnFace(axis: Axis, f: Face) -> Face:
  match axis:
    case @axisX:
      match f:
        case @u: @b
        case @b: @d
        case @d: @f
        case @f: @u
        case @r: @r
        case @l: @l
    case @axisY:
      match f:
        case @f: @r
        case @r: @b
        case @b: @l
        case @l: @f
        case @u: @u
        case @d: @d
    case @axisZ:
      match f:
        case @u: @l
        case @l: @d
        case @d: @r
        case @r: @u
        case @f: @f
        case @b: @b

def quarter(n: U64, axis: Axis, s: Sticker) -> Sticker:
  match s:
    case @sticker{x, y, z, f, c}:
      match axis:
        case @axisX: @sticker{x, z, n - 1 - y, turnFace(axis, f), c}
        case @axisY: @sticker{n - 1 - z, y, x, turnFace(axis, f), c}
        case @axisZ: @sticker{y, n - 1 - x, z, turnFace(axis, f), c}

def turnOnce(n: U64, m: Move, s: Sticker) -> Sticker:
  match m:
    case @move{axis, layer, turn}:
      if onLayer(axis, layer, s): quarter(n, axis, s) else: s

def turnTwice(n: U64, m: Move, xs: Sticker[]) -> Sticker[]:
  mapList(Sticker, Sticker, turnOnce(n, m), mapList(Sticker, Sticker, turnOnce(n, m), xs))

def turnMove(n: U64, m: Move, xs: Sticker[]) -> Sticker[]:
  match m:
    case @move{axis, layer, turn}:
      match turn:
        case @quarter: mapList(Sticker, Sticker, turnOnce(n, m), xs)
        case @half: turnTwice(n, m, xs)
        case @inverse: mapList(Sticker, Sticker, turnOnce(n, m), turnTwice(n, m, xs))

def inverseTurn(t: Turn) -> Turn:
  match t:
    case @quarter: @inverse
    case @inverse: @quarter
    case @half: @half

def inverseMove(m: Move) -> Move:
  match m:
    case @move{axis, layer, turn}: @move{axis, layer, inverseTurn(turn)}

def inverseMoves(xs: Move[]) -> Move[]:
  match xs:
    case []: []
    case m <> rest: append(Move, inverseMoves(rest), [inverseMove(m)])

def inverseWord(w: Word) -> Word:
  match w:
    case @word{moves}: @word{inverseMoves(moves)}

def applyWord(n: U64, xs: Sticker[], w: Move[]) -> Sticker[]:
  match w:
    case []: xs
    case m <> rest: applyWord(n, turnMove(n, m, xs), rest)

def executeWord(n: U64, s: CubeState, w: Word) -> CubeState:
  match s:
    case @cubeState{size, stickers}:
      match w:
        case @word{moves}: @cubeState{size, applyWord(n, stickers, moves)}

type PuzzleFamily:
  case @family:
    cubeSizes: U64[]
    cuboids: Cuboid[]
    minxSizes: U64[]

def family() -> PuzzleFamily:
  @family{[2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
          [@cuboid{4, 4, 6}],
          [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]}

type CubeQuestion:
  case @cubeQuestion:
    family: PuzzleFamily
    source: CubeState
    target: CubeState
    moveAlphabet: Move[]
    scramble: Word
    propositionForm: PropositionForm

type PuzzleFamilyPresentation:
  case @familyObject:
    family: PuzzleFamily
    constructions: PuzzleFamilyMember[]
    questions: CubeQuestion[]

type PropositionForm:
  # This is a selector for the map/proposition constructed below.  Equivalent
  # mathematical terms are observation form, query form, or objective form;
  # `PropositionForm` is used because not every case is an optimization.
  case @shortestDerivation:
  case @minimumDistance:
  case @familyDiameter:
  case @truthAndFalseConditions:

type RequestedObservation:
  # A requested readout is also a query or observation; the explicit name
  # distinguishes the requested projection from the map that computes it.
  case @allMinimumDistances:
  case @allShortestDerivations:
  case @allDiameters:
  case @allTrueConditions:
  case @allFalseConditions:
  case @allSymmetryRelations:
  case @allProofLengths:
  case @exactReconstruction:
  case @continuingInteraction:

type TwistyPuzzleSpecification:
  # Complete typed query specification: family presentation plus maps/readouts.
  case @masterQuery:
    object: PuzzleFamilyPresentation
    readouts: RequestedObservation[]

type ReachabilityProposition:
  case @minimumDistanceSpec:
    question: CubeQuestion
    reachesTarget: Word -> Set
  case @shortestDerivationSpec:
    question: CubeQuestion
    reachesTarget: Word -> Set
  case @diameterSpec:
    family: PuzzleFamily
    reachesTarget: CubeState -> CubeState -> Word -> Set
  case @conditionSpec:
    family: PuzzleFamily
    reachesTarget: CubeState -> CubeState -> Word -> Set

type QueryEvaluation:
  case @rubikEvaluation:
    object: PuzzleFamilyPresentation
    specifications: ReachabilityProposition[]
    readouts: RequestedObservation[]

type QueryObservation:
  case @masterReading:
    specificationCount: U64
    recovered: TwistyPuzzleSpecification

def canonicalScramble(n: U64) -> Word:
  # Use the outer layer for every order, including 2x2.  The same typed move
  # word therefore denotes a valid concrete scramble at every requested N.
  @word{@move{@axisZ, n - 1, @quarter} <> @move{@axisY, n - 1, @quarter} <>
        @move{@axisZ, n - 1, @inverse} <> @move{@axisY, n - 1, @inverse} <> []}

def moveAlphabet(n: U64) -> Move[]:
  # The declared action alphabet is the ordinary outer-face quarter/half-turn
  # metric, with both opposite layers represented for each spatial axis. All
  # three turn senses are explicit so a half-turn has unit move cost when the
  # supplied demand uses this alphabet.
  [@move{@axisX, 0, @quarter}, @move{@axisX, 0, @inverse}, @move{@axisX, 0, @half},
   @move{@axisX, n - 1, @quarter}, @move{@axisX, n - 1, @inverse}, @move{@axisX, n - 1, @half},
   @move{@axisY, 0, @quarter}, @move{@axisY, 0, @inverse}, @move{@axisY, 0, @half},
   @move{@axisY, n - 1, @quarter}, @move{@axisY, n - 1, @inverse}, @move{@axisY, n - 1, @half},
   @move{@axisZ, 0, @quarter}, @move{@axisZ, 0, @inverse}, @move{@axisZ, 0, @half},
   @move{@axisZ, n - 1, @quarter}, @move{@axisZ, n - 1, @inverse}, @move{@axisZ, n - 1, @half}]

def concreteQuestion(n: U64) -> CubeQuestion:
  @cubeQuestion{family(), executeWord(n, solved(n), canonicalScramble(n)), solved(n), moveAlphabet(n), canonicalScramble(n), @minimumDistance}

def shortestQuestion(n: U64) -> CubeQuestion:
  @cubeQuestion{family(), executeWord(n, solved(n), canonicalScramble(n)), solved(n), moveAlphabet(n), canonicalScramble(n), @shortestDerivation}

def diameterQuestion() -> CubeQuestion:
  @cubeQuestion{family(), solved(3), solved(3), moveAlphabet(3), @word{[]}, @familyDiameter}

def conditionQuestion() -> CubeQuestion:
  @cubeQuestion{family(), solved(3), solved(3), moveAlphabet(3), @word{[]}, @truthAndFalseConditions}

def concreteQueries() -> CubeQuestion[]:
  append(CubeQuestion, allConcreteQuestions([2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]),
    append(CubeQuestion, allShortestQuestions([2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]),
      [diameterQuestion(), conditionQuestion()]))

def allConcreteQuestions(ns: U64[]) -> CubeQuestion[]:
  match ns:
    case []: []
    case n <> rest: concreteQuestion(n) <> allConcreteQuestions(rest)

def allShortestQuestions(ns: U64[]) -> CubeQuestion[]:
  match ns:
    case []: []
    case n <> rest: shortestQuestion(n) <> allShortestQuestions(rest)

def cubeConstructions(ns: U64[]) -> PuzzleFamilyMember[]:
  match ns:
    case []: []
    case n <> rest: @cubeConstruction{n} <> cubeConstructions(rest)

def cuboidConstructions(ds: Cuboid[]) -> PuzzleFamilyMember[]:
  match ds:
    case []: []
    case d <> rest: @cuboidConstruction{d} <> cuboidConstructions(rest)

def minxConstructions(ns: U64[]) -> PuzzleFamilyMember[]:
  match ns:
    case []: []
    case n <> rest: @minxConstruction{n} <> minxConstructions(rest)

def constructions(f: PuzzleFamily) -> PuzzleFamilyMember[]:
  match f:
    case @family{cubeSizes, cuboids, minxSizes}:
      append(PuzzleFamilyMember, cubeConstructions(cubeSizes),
        append(PuzzleFamilyMember, cuboidConstructions(cuboids), minxConstructions(minxSizes)))

def cubeStates(ns: U64[]) -> CubeState[]:
  match ns:
    case []: []
    case n <> rest: solved(n) <> cubeStates(rest)

def cuboidStates(ds: Cuboid[]) -> CuboidState[]:
  match ds:
    case []: []
    case d <> rest: solvedCuboid(d) <> cuboidStates(rest)

def minxStates(ns: U64[]) -> MinxState[]:
  match ns:
    case []: []
    case n <> rest: solvedMinx(n) <> minxStates(rest)

def familyCubeStates(f: PuzzleFamily) -> CubeState[]:
  match f:
    case @family{cubeSizes, cuboids, minxSizes}: cubeStates(cubeSizes)

def familyCuboidStates(f: PuzzleFamily) -> CuboidState[]:
  match f:
    case @family{cubeSizes, cuboids, minxSizes}: cuboidStates(cuboids)

def familyMinxStates(f: PuzzleFamily) -> MinxState[]:
  match f:
    case @family{cubeSizes, cuboids, minxSizes}: minxStates(minxSizes)

def familyPresentation() -> PuzzleFamilyPresentation:
  # The family dimensions are retained as the parametric construction; the
  # question list materialises the requested concrete states.  This keeps the
  # object exact without eagerly expanding every N-sized facelet array before
  # the supplied coinductive computation receives it.
  @familyObject{family(), constructions(family()), concreteQueries()}

def allReadouts() -> RequestedObservation[]:
  [@allMinimumDistances, @allShortestDerivations, @allDiameters,
   @allTrueConditions, @allFalseConditions, @allSymmetryRelations,
   @allProofLengths, @exactReconstruction, @continuingInteraction]

def masterQuery() -> TwistyPuzzleSpecification:
  @masterQuery{familyPresentation(), allReadouts()}

# This is the Rubik analogue of SAT's `formula`.  A candidate word is
# accepted exactly when applying the declared geometric action to the complete
# source reaches the declared target.  The observedValue is a proof-relevant Path
# proposition, so the fibre receives the actual question rather than a label
# describing one.
def reachesTarget(q: CubeQuestion, w: Word) -> Set:
  match q:
    case @cubeQuestion{family, source, target, moveAlphabet, scramble, propositionForm}:
      match source:
        case @cubeState{size, stickers}: Path(CubeState, executeWord(size, source, w), target)

def reaches(source: CubeState, target: CubeState, w: Word) -> Set:
  match source:
    case @cubeState{size, stickers}: Path(CubeState, executeWord(size, source, w), target)

def propositionFor(q: CubeQuestion) -> ReachabilityProposition:
  match q:
    case @cubeQuestion{family, source, target, moveAlphabet, scramble, propositionForm}:
      match propositionForm:
        case @minimumDistance: @minimumDistanceSpec{q, lambda w. reachesTarget(q, w)}
        case @shortestDerivation: @shortestDerivationSpec{q, lambda w. reachesTarget(q, w)}
        case @familyDiameter: @diameterSpec{family(), lambda source. lambda target. lambda w. reaches(source, target, w)}
        case @truthAndFalseConditions: @conditionSpec{family(), lambda source. lambda target. lambda w. reaches(source, target, w)}

def propositions(qs: CubeQuestion[]) -> ReachabilityProposition[]:
  match qs:
    case []: []
    case q <> rest: propositionFor(q) <> propositions(rest)

def propositionCount(xs: ReachabilityProposition[]) -> U64:
  match xs:
    case []: 0
    case x <> rest: 1 + propositionCount(rest)

def evaluateSpecification(m: TwistyPuzzleSpecification) -> QueryEvaluation:
  match m:
    case @masterQuery{object, readouts}:
      match object:
        case @familyObject{family, constructions, questions}:
          @rubikEvaluation{object, propositions(questions), readouts}

# The complete construction and all demands are one source object.  The
# executable Rubik proposition below is the operation supplied to the generic
# fibre process; no host-side solver is interposed.
def presentationIdentity(x: PuzzleFamilyPresentation) -> PuzzleFamilyPresentation:
  x

def observePresentation(x: PuzzleFamilyPresentation) -> FibreObservation(PuzzleFamilyPresentation, x, PuzzleFamilyPresentation, presentationIdentity):
  observe(PuzzleFamilyPresentation, x, fibreCoalgebra(PuzzleFamilyPresentation, x), PuzzleFamilyPresentation, presentationIdentity)

def reconstructPresentation(c: FibreElement(PuzzleFamilyPresentation, PuzzleFamilyPresentation, presentationIdentity)) -> PuzzleFamilyPresentation:
  ascend(PuzzleFamilyPresentation, PuzzleFamilyPresentation, presentationIdentity, c)

# The native demo asks for the complete object, then asks the retained
# continuation to recover the source.  This forces the two interaction steps
# and returns the recovered typed object, while `observePresentation` remains
# the API that exposes the live FibreObservation/continuation itself.
def queryPresentation(x: PuzzleFamilyPresentation) -> PuzzleFamilyPresentation:
  match observePresentation(x):
    case @fibreObservation{value, source, next}:
      match observe(FibreElement(PuzzleFamilyPresentation, PuzzleFamilyPresentation, presentationIdentity), value, next,
                     PuzzleFamilyPresentation, reconstructPresentation):
        case @fibreObservation{second, receipt, more}:
          observedValue(FibreElement(PuzzleFamilyPresentation, PuzzleFamilyPresentation, presentationIdentity), PuzzleFamilyPresentation, reconstructPresentation, second)

def specificationIdentity(x: TwistyPuzzleSpecification) -> TwistyPuzzleSpecification:
  x

def observeSpecification(x: TwistyPuzzleSpecification) -> FibreObservation(TwistyPuzzleSpecification, x, QueryEvaluation, evaluateSpecification):
  observe(TwistyPuzzleSpecification, x, fibreCoalgebra(TwistyPuzzleSpecification, x), QueryEvaluation, evaluateSpecification)

def reconstructSpecification(c: FibreElement(TwistyPuzzleSpecification, QueryEvaluation, evaluateSpecification)) -> TwistyPuzzleSpecification:
  ascend(TwistyPuzzleSpecification, QueryEvaluation, evaluateSpecification, c)

def evaluateTwistySpecification(x: TwistyPuzzleSpecification) -> QueryObservation:
  match observeSpecification(x):
    case @fibreObservation{value, source, next}:
      match observe(FibreElement(TwistyPuzzleSpecification, QueryEvaluation, evaluateSpecification), value, next,
                     TwistyPuzzleSpecification, reconstructSpecification):
        case @fibreObservation{second, receipt, more}:
          @masterReading{
            match observedValue(FibreElement(TwistyPuzzleSpecification, QueryEvaluation, evaluateSpecification), QueryEvaluation, evaluateSpecification, value):
              case @rubikEvaluation{object, specifications, readouts}: propositionCount(specifications),
            observedValue(FibreElement(TwistyPuzzleSpecification, QueryEvaluation, evaluateSpecification), TwistyPuzzleSpecification, reconstructSpecification, second)}

def main() -> QueryObservation:
  evaluateTwistySpecification(masterQuery())
