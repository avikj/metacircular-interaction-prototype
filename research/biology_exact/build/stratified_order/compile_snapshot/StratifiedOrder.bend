# Ask conditional empirical order of the retained paired-cell observations.
import RationalOrder

type StratifiedRatioCell:
  case @stratifiedRatioCell:
    cell: U64
    stratum: U64
    marker: U64
    exposure: U64

def selectRatioStratum(rows: StratifiedRatioCell[], stratum: U64, unit: U64) -> CellRatio[]:
  match rows:
    case []: []
    case row <> rest:
      match row: case @stratifiedRatioCell{cell, s, marker, exposure}:
        if s === stratum:
          if unit === 0: @cellRatio{cell, marker, 1} <> selectRatioStratum(rest, stratum, unit)
          else: @cellRatio{cell, marker, exposure} <> selectRatioStratum(rest, stratum, unit)
        else: selectRatioStratum(rest, stratum, unit)

type StratifiedOrderQuestion:
  case @stratifiedOrderQuestion:
    left: StratifiedRatioCell[]
    right: StratifiedRatioCell[]
    stratum: U64
    unit: U64

def answerStratifiedOrder(q: StratifiedOrderQuestion) -> SourceLookup(RatioOrderAnswer):
  match q: case @stratifiedOrderQuestion{left, right, stratum, unit}:
    answerRatioOrder(@ratioOrderQuestion{selectRatioStratum(left, stratum, unit), selectRatioStratum(right, stratum, unit)})

def displayStratifiedOrder(q: StratifiedOrderQuestion) -> SourceLookup(RatioOrderAnswer):
  match interact(StratifiedOrderQuestion, q, wholeProcess(StratifiedOrderQuestion, q), SourceLookup(RatioOrderAnswer), answerStratifiedOrder):
    case @wholeReply{value, receipt, next}:
      result(StratifiedOrderQuestion, SourceLookup(RatioOrderAnswer), answerStratifiedOrder, value)

def main() -> Unit:
  ()
