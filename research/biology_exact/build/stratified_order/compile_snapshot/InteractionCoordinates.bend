# Exact four-corner coordinates of the published single/pair interventions.
# This reads a retained factor; it does not replace cell distributions by means.
import ConditionalSummary
import ExactWords

type TargetPair:
  case @notTargetPair:
  case @targetPair:
    first: SourceText
    second: SourceText

def reverseLabel(xs: U64[], acc: U64[]) -> U64[]:
  match xs:
    case []: acc
    case x <> rest: reverseLabel(rest, x <> acc)

def splitTargetBytes(xs: U64[], acc: U64[]) -> TargetPair:
  match xs:
    case []: @notTargetPair
    case x <> rest:
      if x === 95: @targetPair{@sourceUtf8{reverseLabel(acc, [])}, @sourceUtf8{rest}}
      else: splitTargetBytes(rest, x <> acc)

def splitTargetLabel(published: SourceText) -> TargetPair:
  match published: case @sourceUtf8{bytes}: splitTargetBytes(bytes, [])

def findConditionCode(labels: SourceText[], wanted: SourceText, index: U64) -> SourceLookup(U64):
  match labels:
    case []: @sourceMissing
    case published <> rest:
      if sourceTextEqual(published, wanted): @sourceFound{index}
      else: findConditionCode(rest, wanted, index + 1)

def findConditionTotal(totals: ExactConditionTotal[], wanted: U64) -> SourceLookup(ExactConditionTotal):
  match totals:
    case []: @sourceMissing
    case t <> rest:
      match t: case @exactConditionTotal{c, n, hi, lo}:
        if c === wanted: @sourceFound{t}
        else: findConditionTotal(rest, wanted)

def namedConditionTotal(labels: SourceText[], totals: ExactConditionTotal[], name: SourceText) -> SourceLookup(ExactConditionTotal):
  match findConditionCode(labels, name, 0):
    case @sourceMissing: @sourceMissing
    case @sourceFound{code}: findConditionTotal(totals, code)

def timesThree(a: ExactWords, b: U64, c: U64, d: U64) -> ExactWords:
  exactTimesSmall(exactTimesSmall(exactTimesSmall(a, b), c), d)

type ExactPairCoordinate:
  case @missingPairCoordinate:
    published: SourceText
  case @exactPairCoordinate:
    published: SourceText
    numerator: ExactSigned
    denominator: ExactWords
    doubleCells: U64
    firstCells: U64
    secondCells: U64
    controlCells: U64

# μ(ab) - μ(a) - μ(b) + μ(control), computed as one signed rational.
# No rounded means, fitted coefficients, thresholding, or significance claim.
def fourCornerCoordinate(published: SourceText, ab: ExactConditionTotal, a: ExactConditionTotal, b: ExactConditionTotal, zero: ExactConditionTotal) -> ExactPairCoordinate:
  match ab: case @exactConditionTotal{cab, nab, hab, lab}:
    match a: case @exactConditionTotal{ca, na, ha, la}:
      match b: case @exactConditionTotal{cb, nb, hb, lb}:
        match zero: case @exactConditionTotal{c0, n0, h0, l0}:
          posPart = exactAdd(timesThree(exactFromLimbs(hab, lab), na, nb, n0), timesThree(exactFromLimbs(h0, l0), nab, na, nb))
          negPart = exactAdd(timesThree(exactFromLimbs(ha, la), nab, nb, n0), timesThree(exactFromLimbs(hb, lb), nab, na, n0));
          @exactPairCoordinate{published, exactDifference(posPart, negPart), timesThree(exactWord(nab), na, nb, n0), nab, na, nb, n0}

def derivePairCoordinate(labels: SourceText[], totals: ExactConditionTotal[], published: SourceText, first: SourceText, second: SourceText, zero: ExactConditionTotal) -> ExactPairCoordinate:
  match namedConditionTotal(labels, totals, published):
    case @sourceMissing: @missingPairCoordinate{published}
    case @sourceFound{ab}:
      match namedConditionTotal(labels, totals, first):
        case @sourceMissing: @missingPairCoordinate{published}
        case @sourceFound{a}:
          match namedConditionTotal(labels, totals, second):
            case @sourceMissing: @missingPairCoordinate{published}
            case @sourceFound{b}: fourCornerCoordinate(published, ab, a, b, zero)

def deriveAllPairs(remaining: SourceText[], labels: SourceText[], totals: ExactConditionTotal[], zero: ExactConditionTotal) -> ExactPairCoordinate[]:
  match remaining:
    case []: []
    case published <> rest:
      match splitTargetLabel(published):
        case @notTargetPair: deriveAllPairs(rest, labels, totals, zero)
        case @targetPair{first, second}: derivePairCoordinate(labels, totals, published, first, second, zero) <> deriveAllPairs(rest, labels, totals, zero)

type FactorMeaning:
  case @factorMeaning:
    labels: SourceText[]
    factor: ColumnFactorization

def interactionCoordinates(input: FactorMeaning) -> SourceLookup(ExactPairCoordinate[]):
  match input: case @factorMeaning{labels, factor}:
    totals = summarizeColumnFactor(factor)
    match namedConditionTotal(labels, totals, @sourceUtf8{[99,111,110,116,114,111,108]}):
      case @sourceMissing: @sourceMissing
      case @sourceFound{zero}: @sourceFound{deriveAllPairs(labels, labels, totals, zero)}

def coordinateProcess(input: FactorMeaning) -> WholeReply(FactorMeaning, input, SourceLookup(ExactPairCoordinate[]), interactionCoordinates):
  interact(FactorMeaning, input, wholeProcess(FactorMeaning, input), SourceLookup(ExactPairCoordinate[]), interactionCoordinates)

def displayCoordinates(input: FactorMeaning) -> SourceLookup(ExactPairCoordinate[]):
  match coordinateProcess(input):
    case @wholeReply{value, source, next}: result(FactorMeaning, SourceLookup(ExactPairCoordinate[]), interactionCoordinates, value)

def main() -> ExactPairCoordinate:
  fourCornerCoordinate(@sourceUtf8{[]}, @exactConditionTotal{3, 2, 0, 14}, @exactConditionTotal{1, 2, 0, 6}, @exactConditionTotal{2, 2, 0, 8}, @exactConditionTotal{0, 2, 0, 2})

# A previously evaluated receiver can be consumed without replaying its fold.
type TotalsMeaning:
  case @totalsMeaning:
    labels: SourceText[]
    totals: ExactConditionTotal[]

def coordinatesFromTotals(input: TotalsMeaning) -> SourceLookup(ExactPairCoordinate[]):
  match input: case @totalsMeaning{labels, totals}:
    match namedConditionTotal(labels, totals, @sourceUtf8{[99,111,110,116,114,111,108]}):
      case @sourceMissing: @sourceMissing
      case @sourceFound{zero}: @sourceFound{deriveAllPairs(labels, labels, totals, zero)}

def totalsCoordinateProcess(input: TotalsMeaning) -> SourceLookup(ExactPairCoordinate[]):
  match interact(TotalsMeaning, input, wholeProcess(TotalsMeaning, input), SourceLookup(ExactPairCoordinate[]), coordinatesFromTotals):
    case @wholeReply{value, source, next}: result(TotalsMeaning, SourceLookup(ExactPairCoordinate[]), coordinatesFromTotals, value)

def coordinateMagnitudeAtLeast(a: ExactPairCoordinate, b: ExactPairCoordinate) -> Bool:
  match a:
    case @missingPairCoordinate{label}: False
    case @exactPairCoordinate{label, num, den, nab, na, nb, n0}:
      match b:
        case @missingPairCoordinate{other}: True
        case @exactPairCoordinate{other, numB, denB, nAB, nA, nB, nZ}:
          match num: case @exactSigned{sign, magnitude}:
            match numB: case @exactSigned{signB, magnitudeB}:
              if exactCompare(exactMultiply(magnitude, denB), exactMultiply(magnitudeB, den)) === 1: False
              else: True

def insertCoordinate(x: ExactPairCoordinate, xs: ExactPairCoordinate[]) -> ExactPairCoordinate[]:
  match xs:
    case []: [x]
    case y <> rest:
      if coordinateMagnitudeAtLeast(x, y): x <> (y <> rest)
      else: y <> insertCoordinate(x, rest)

def rankCoordinates(xs: ExactPairCoordinate[]) -> ExactPairCoordinate[]:
  match xs:
    case []: []
    case x <> rest: insertCoordinate(x, rankCoordinates(rest))

def rankCoordinateResult(result: SourceLookup(ExactPairCoordinate[])) -> SourceLookup(ExactPairCoordinate[]):
  match result:
    case @sourceMissing: @sourceMissing
    case @sourceFound{xs}: @sourceFound{rankCoordinates(xs)}
