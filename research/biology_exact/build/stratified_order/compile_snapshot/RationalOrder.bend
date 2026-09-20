# Empirical order of exact per-cell marker/exposure fractions.
import EmpiricalOrder

type RatioBin:
  case @ratioBin:
    numerator: U64
    denominator: U64
    count: U64

def compareRatioBins(a: RatioBin, b: RatioBin) -> U64:
  match a: case @ratioBin{p, q, n}:
    match b: case @ratioBin{r, s, m}:
      exactCompare(exactMultiply(exactWord(p), exactWord(s)), exactMultiply(exactWord(r), exactWord(q)))

def insertRatioBin(bin: RatioBin, bins: RatioBin[]) -> RatioBin[]:
  match bins:
    case []: [bin]
    case x <> rest:
      order = compareRatioBins(bin, x)
      if order === 1: bin <> (x <> rest)
      else:
        if order === 0:
          match bin: case @ratioBin{p, q, n}:
            match x: case @ratioBin{r, s, m}: @ratioBin{p, q, n + m} <> rest
        else: x <> insertRatioBin(bin, rest)

def ratioHistogram(rows: RatioBin[], acc: RatioBin[]) -> SourceLookup(RatioBin[]):
  match rows:
    case []: @sourceFound{acc}
    case row <> rest:
      match row: case @ratioBin{p, q, n}:
        if q === 0: @sourceMissing
        else: ratioHistogram(rest, insertRatioBin(row, acc))

def ratioPopulation(bins: RatioBin[], n: U64) -> U64:
  match bins:
    case []: n
    case bin <> rest:
      match bin: case @ratioBin{p, q, m}: ratioPopulation(rest, n + m)

type RatioCDFPoint:
  case @ratioCDFPoint:
    numerator: U64
    denominator: U64
    leftCount: U64
    rightCount: U64
    comparison: U64

def ratioCDFPoint(bin: RatioBin, a: U64, b: U64, na: U64, nb: U64) -> RatioCDFPoint:
  match bin: case @ratioBin{p, q, n}:
    @ratioCDFPoint{p, q, a, b, exactCompare(exactMultiply(exactWord(a), exactWord(nb)), exactMultiply(exactWord(b), exactWord(na)))}

def mergeRatioCDF(left: RatioBin[], right: RatioBin[], a: U64, b: U64, na: U64, nb: U64) -> RatioCDFPoint[]:
  match left:
    case []:
      match right:
        case []: []
        case y <> ys:
          match y: case @ratioBin{p, q, m}:
            ratioCDFPoint(y, a, b + m, na, nb) <> mergeRatioCDF([], ys, a, b + m, na, nb)
    case x <> xs:
      match x: case @ratioBin{p, q, n}:
        match right:
          case []: ratioCDFPoint(x, a + n, b, na, nb) <> mergeRatioCDF(xs, [], a + n, b, na, nb)
          case y <> ys:
            match y: case @ratioBin{r, s, m}:
              order = compareRatioBins(x, y)
              if order === 0: ratioCDFPoint(x, a + n, b + m, na, nb) <> mergeRatioCDF(xs, ys, a + n, b + m, na, nb)
              else:
                if order === 1: ratioCDFPoint(x, a + n, b, na, nb) <> mergeRatioCDF(xs, right, a + n, b, na, nb)
                else: ratioCDFPoint(y, a, b + m, na, nb) <> mergeRatioCDF(left, ys, a, b + m, na, nb)

type CellRatio:
  case @cellRatio:
    cell: U64
    marker: U64
    exposure: U64

def cellRatioBins(rows: CellRatio[]) -> RatioBin[]:
  match rows:
    case []: []
    case row <> rest:
      match row: case @cellRatio{cell, marker, exposure}:
        @ratioBin{marker, exposure, 1} <> cellRatioBins(rest)

type RatioOrderQuestion:
  case @ratioOrderQuestion:
    left: CellRatio[]
    right: CellRatio[]

type RatioOrderAnswer:
  case @ratioOrderAnswer:
    leftCells: U64
    rightCells: U64
    points: RatioCDFPoint[]

def answerRatioOrder(q: RatioOrderQuestion) -> SourceLookup(RatioOrderAnswer):
  match q: case @ratioOrderQuestion{left, right}:
    match ratioHistogram(cellRatioBins(left), []):
      case @sourceMissing: @sourceMissing
      case @sourceFound{a}:
        match ratioHistogram(cellRatioBins(right), []):
          case @sourceMissing: @sourceMissing
          case @sourceFound{b}:
            na = ratioPopulation(a, 0)
            nb = ratioPopulation(b, 0)
            if na === 0: @sourceMissing
            else:
              if nb === 0: @sourceMissing
              else: @sourceFound{@ratioOrderAnswer{na, nb, mergeRatioCDF(a, b, 0, 0, na, nb)}}

def displayRatioOrder(q: RatioOrderQuestion) -> SourceLookup(RatioOrderAnswer):
  match interact(RatioOrderQuestion, q, wholeProcess(RatioOrderQuestion, q), SourceLookup(RatioOrderAnswer), answerRatioOrder):
    case @wholeReply{value, receipt, next}: result(RatioOrderQuestion, SourceLookup(RatioOrderAnswer), answerRatioOrder, value)

def main() -> Unit:
  ()
