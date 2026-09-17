# Exact empirical distribution comparison, without bins or fitted distributions.
import MechanismRNA

type HistogramBin:
  case @histogramBin:
    value: U64
    count: U64

def insertHistogram(v: U64, n: U64, bins: HistogramBin[]) -> HistogramBin[]:
  match bins:
    case []: [@histogramBin{v, n}]
    case bin <> rest:
      match bin: case @histogramBin{w, m}:
        if v === w: @histogramBin{v, n + m} <> rest
        else:
          if v < w: @histogramBin{v, n} <> (bin <> rest)
          else: bin <> insertHistogram(v, n, rest)

def conditionHistogram(fs: MeasurementFibre[], condition: U64, bins: HistogramBin[]) -> HistogramBin[]:
  match fs:
    case []: bins
    case f <> rest:
      match f: case @measurementFibre{c, v, cells}:
        if c === condition: conditionHistogram(rest, condition, insertHistogram(v, positionCount(cells, 0), bins))
        else: conditionHistogram(rest, condition, bins)

def histogramCount(bins: HistogramBin[], n: U64) -> U64:
  match bins:
    case []: n
    case bin <> rest:
      match bin: case @histogramBin{v, m}: histogramCount(rest, n + m)

type CDFPoint:
  case @cdfPoint:
    threshold: U64
    leftCount: U64
    rightCount: U64
    comparison: U64

def cdfPoint(v: U64, a: U64, b: U64, na: U64, nb: U64) -> CDFPoint:
  @cdfPoint{v, a, b, exactCompare(exactMultiply(exactWord(a), exactWord(nb)), exactMultiply(exactWord(b), exactWord(na)))}

def mergeCDF(left: HistogramBin[], right: HistogramBin[], a: U64, b: U64, na: U64, nb: U64) -> CDFPoint[]:
  match left:
    case []:
      match right:
        case []: []
        case y <> ys:
          match y: case @histogramBin{v, n}:
            cdfPoint(v, a, b + n, na, nb) <> mergeCDF([], ys, a, b + n, na, nb)
    case x <> xs:
      match x: case @histogramBin{v, n}:
        match right:
          case []: cdfPoint(v, a + n, b, na, nb) <> mergeCDF(xs, [], a + n, b, na, nb)
          case y <> ys:
            match y: case @histogramBin{w, m}:
              if v === w: cdfPoint(v, a + n, b + m, na, nb) <> mergeCDF(xs, ys, a + n, b + m, na, nb)
              else:
                if v < w: cdfPoint(v, a + n, b, na, nb) <> mergeCDF(xs, right, a + n, b, na, nb)
                else: cdfPoint(w, a, b + m, na, nb) <> mergeCDF(left, ys, a, b + m, na, nb)

type EmpiricalOrderQuestion:
  case @empiricalOrderQuestion:
    source: ColumnFactorization
    left: U64
    right: U64

type EmpiricalOrderAnswer:
  case @empiricalOrderAnswer:
    leftCells: U64
    rightCells: U64
    points: CDFPoint[]

def answerEmpiricalOrder(q: EmpiricalOrderQuestion) -> SourceLookup(EmpiricalOrderAnswer):
  match q: case @empiricalOrderQuestion{source, left, right}:
    match source:
      case @columnMalformed: @sourceMissing
      case @columnFactored{cells, fibres}:
        a = conditionHistogram(fibres, left, [])
        b = conditionHistogram(fibres, right, [])
        na = histogramCount(a, 0)
        nb = histogramCount(b, 0)
        if na === 0: @sourceMissing
        else:
          if nb === 0: @sourceMissing
          else: @sourceFound{@empiricalOrderAnswer{na, nb, mergeCDF(a, b, 0, 0, na, nb)}}

def displayEmpiricalOrder(q: EmpiricalOrderQuestion) -> SourceLookup(EmpiricalOrderAnswer):
  match interact(EmpiricalOrderQuestion, q, wholeProcess(EmpiricalOrderQuestion, q), SourceLookup(EmpiricalOrderAnswer), answerEmpiricalOrder):
    case @wholeReply{value, receipt, next}: result(EmpiricalOrderQuestion, SourceLookup(EmpiricalOrderAnswer), answerEmpiricalOrder, value)

def selectedRNAHistogramRows(rows: RNASelectedCell[], gene: U64, condition: U64, bins: HistogramBin[]) -> HistogramBin[]:
  match rows:
    case []: bins
    case row <> rest:
      match row: case @rnaSelectedCell{cell, c, array, total, entries}:
        if c === condition: selectedRNAHistogramRows(rest, gene, condition, insertHistogram(selectedGeneCount(entries, gene), 1, bins))
        else: selectedRNAHistogramRows(rest, gene, condition, bins)

type RNAOrderQuestion:
  case @rnaOrderQuestion:
    rows: RNASelectedCell[]
    gene: U64
    left: U64
    right: U64

def answerRNAOrder(q: RNAOrderQuestion) -> SourceLookup(EmpiricalOrderAnswer):
  match q: case @rnaOrderQuestion{rows, gene, left, right}:
    a = selectedRNAHistogramRows(rows, gene, left, [])
    b = selectedRNAHistogramRows(rows, gene, right, [])
    na = histogramCount(a, 0)
    nb = histogramCount(b, 0)
    if na === 0: @sourceMissing
    else:
      if nb === 0: @sourceMissing
      else: @sourceFound{@empiricalOrderAnswer{na, nb, mergeCDF(a, b, 0, 0, na, nb)}}

def displayRNAOrder(q: RNAOrderQuestion) -> SourceLookup(EmpiricalOrderAnswer):
  match interact(RNAOrderQuestion, q, wholeProcess(RNAOrderQuestion, q), SourceLookup(EmpiricalOrderAnswer), answerRNAOrder):
    case @wholeReply{value, receipt, next}: result(RNAOrderQuestion, SourceLookup(EmpiricalOrderAnswer), answerRNAOrder, value)

def main() -> SourceLookup(EmpiricalOrderAnswer):
  displayEmpiricalOrder(@empiricalOrderQuestion{@columnFactored{4, [@measurementFibre{0, 1, [0]}, @measurementFibre{0, 3, [1]}, @measurementFibre{1, 2, [2, 3]}]}, 0, 1})
