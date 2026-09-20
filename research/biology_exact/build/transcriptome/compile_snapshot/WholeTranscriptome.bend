# Every gene, grouped by declared source cell addresses. No gene-panel filter.
# Each ExactConditionTotal uses its key for the gene index, its cells field
# for positive-count cells, and its two limbs for the exact UMI sum.
import MechanismRNA

type RNAAddress:
  case @rnaAddress:
    expectedCell: U64
    batch: RNARowFibre[]
    offset: U64

type TranscriptomeQuestion:
  case @transcriptomeQuestion:
    study: PairedStudy
    geneCount: U64
    rows: RNAAddress[]

type TranscriptomeAnswer:
  case @transcriptomeAnswer:
    geneCount: U64
    cells: U64[]
    totals: ExactConditionTotal[]

def genePositionsTotal(genes: U64[], value: U64, cell: U64, geneCount: U64, tree: KeyedMeasurement[]) -> SourceLookup(KeyedMeasurement[]):
  match genes:
    case []: @sourceFound{tree}
    case gene <> rest:
      if gene < geneCount:
        if value === 0: genePositionsTotal(rest, value, cell, geneCount, tree)
        else: genePositionsTotal(rest, value, cell, geneCount, @keyedMeasurement{gene, value, cell} <> tree)
      else: @sourceMissing

def geneFibresTotal(fibres: MeasurementFibre[], cell: U64, geneCount: U64, tree: KeyedMeasurement[]) -> SourceLookup(KeyedMeasurement[]):
  match fibres:
    case []: @sourceFound{tree}
    case f <> rest:
      match f: case @measurementFibre{unused, value, genes}:
        match genePositionsTotal(genes, value, cell, geneCount, tree):
          case @sourceMissing: @sourceMissing
          case @sourceFound{next}: geneFibresTotal(rest, cell, geneCount, next)

def appendGeneTotals(xs: ExactConditionTotal[], ys: ExactConditionTotal[]) -> ExactConditionTotal[]:
  match xs:
    case []: ys
    case x <> rest: x <> appendGeneTotals(rest, ys)

def geneLeafTotal(xs: KeyedMeasurement[], total: ExactConditionTotal) -> ExactConditionTotal:
  match xs:
    case []: total
    case x <> rest:
      match x: case @keyedMeasurement{gene, value, cell}: geneLeafTotal(rest, addWordToTotal(value, total))

def radixGeneTotals(xs: KeyedMeasurement[], mask: U64) -> ExactConditionTotal[]:
  match xs:
    case []: []
    case x <> rest:
      if mask === 32768:
        match x: case @keyedMeasurement{gene, value, cell}:
          [geneLeafTotal(x <> rest, @exactConditionTotal{gene, 0, 0, 0})]
      else:
        match partitionMeasurements(x <> rest, 0, mask, [], []):
          case @measurementPartition{left, right}:
            appendGeneTotals(radixGeneTotals(left, mask * 2), radixGeneTotals(right, mask * 2))

def transcriptomeRows(rows: RNAAddress[], geneCount: U64, cells: U64[], tree: KeyedMeasurement[]) -> SourceLookup(TranscriptomeAnswer):
  match rows:
    case []: @sourceFound{@transcriptomeAnswer{geneCount, cells, radixGeneTotals(tree, 1)}}
    case address <> rest:
      match address: case @rnaAddress{expected, batch, offset}:
        match sourceListAt(RNARowFibre, batch, offset):
          case @sourceMissing: @sourceMissing
          case @sourceFound{row}:
            match row: case @rnaRowFibre{cell, entries, fibres}:
              if cell === expected:
                match geneFibresTotal(fibres, cell, geneCount, tree):
                  case @sourceMissing: @sourceMissing
                  case @sourceFound{next}: transcriptomeRows(rest, geneCount, cell <> cells, next)
              else: @sourceMissing

def answerTranscriptome(q: TranscriptomeQuestion) -> SourceLookup(TranscriptomeAnswer):
  match q: case @transcriptomeQuestion{study, geneCount, rows}:
    if geneCount <= 32768: transcriptomeRows(rows, geneCount, [], [])
    else: @sourceMissing

def displayTranscriptome(q: TranscriptomeQuestion) -> SourceLookup(TranscriptomeAnswer):
  match interact(TranscriptomeQuestion, q, wholeProcess(TranscriptomeQuestion, q), SourceLookup(TranscriptomeAnswer), answerTranscriptome):
    case @wholeReply{value, receipt, next}: result(TranscriptomeQuestion, SourceLookup(TranscriptomeAnswer), answerTranscriptome, value)

def addGeneTotal(a: ExactConditionTotal, b: ExactConditionTotal) -> ExactConditionTotal:
  match a: case @exactConditionTotal{gene, n, hi, lo}:
    match b: case @exactConditionTotal{other, m, upper, lower}:
      if lo > (4294967295 - lower):
        @exactConditionTotal{gene, n + m, (hi + upper) + 1, (lo - (4294967295 - lower)) - 1}
      else: @exactConditionTotal{gene, n + m, hi + upper, lo + lower}

type GeneTotalPartition:
  case @geneTotalPartition:
    left: ExactConditionTotal[]
    right: ExactConditionTotal[]

def partitionGeneTotals(xs: ExactConditionTotal[], mask: U64, left: ExactConditionTotal[], right: ExactConditionTotal[]) -> GeneTotalPartition:
  match xs:
    case []: @geneTotalPartition{left, right}
    case x <> rest:
      match x: case @exactConditionTotal{gene, n, hi, lo}:
        if ((gene / mask) % 2) === 0: partitionGeneTotals(rest, mask, x <> left, right)
        else: partitionGeneTotals(rest, mask, left, x <> right)

def sumGeneTotals(xs: ExactConditionTotal[], total: ExactConditionTotal) -> ExactConditionTotal:
  match xs:
    case []: total
    case x <> rest: sumGeneTotals(rest, addGeneTotal(x, total))

def radixMergeGeneTotals(xs: ExactConditionTotal[], mask: U64) -> ExactConditionTotal[]:
  match xs:
    case []: []
    case x <> rest:
      if mask === 32768: [sumGeneTotals(rest, x)]
      else:
        match partitionGeneTotals(x <> rest, mask, [], []):
          case @geneTotalPartition{left, right}:
            appendGeneTotals(radixMergeGeneTotals(left, mask * 2), radixMergeGeneTotals(right, mask * 2))

def appendGeneCells(xs: U64[], tail: U64[]) -> U64[]:
  match xs:
    case []: tail
    case x <> rest: x <> appendGeneCells(rest, tail)

def mergeTranscriptomeParts(parts: TranscriptomeAnswer[], geneCount: U64, cells: U64[], tree: ExactConditionTotal[]) -> SourceLookup(TranscriptomeAnswer):
  match parts:
    case []: @sourceFound{@transcriptomeAnswer{geneCount, cells, radixMergeGeneTotals(tree, 1)}}
    case p <> rest:
      match p: case @transcriptomeAnswer{ng, ids, totals}:
        if ng === geneCount: mergeTranscriptomeParts(rest, geneCount, appendGeneCells(ids, cells), appendGeneTotals(totals, tree))
        else: @sourceMissing

type TranscriptomeMerge:
  case @transcriptomeMerge:
    geneCount: U64
    parts: TranscriptomeAnswer[]

def answerTranscriptomeMerge(q: TranscriptomeMerge) -> SourceLookup(TranscriptomeAnswer):
  match q: case @transcriptomeMerge{ng, parts}:
    mergeTranscriptomeParts(parts, ng, [], [])

def displayTranscriptomeMerge(q: TranscriptomeMerge) -> SourceLookup(TranscriptomeAnswer):
  match interact(TranscriptomeMerge, q, wholeProcess(TranscriptomeMerge, q), SourceLookup(TranscriptomeAnswer), answerTranscriptomeMerge):
    case @wholeReply{value, receipt, next}: result(TranscriptomeMerge, SourceLookup(TranscriptomeAnswer), answerTranscriptomeMerge, value)

def main() -> Unit:
  ()
