# The erasure verdict as a type-checking event (erasure.bend): under the floor
# effect the population may NOT be erased to its statistic. Two attempts to
# force it must be REJECTED — the substrate computes descent, not a heuristic.
import Perturb

# attempt 1: claim RStat is a step-congruence for the knockdown knowledge by
# handing back the hypothesis itself (it is not: [[0],[2]] and [[1],[1]] part ways)
def fakeStepResp(x: Nat[][], y: Nat[][], a: Intervention, r: RStat(natNum, x, y)) -> RStat(natNum, stepK(natNum, Kdown, x, a), stepK(natNum, Kdown, y, a)):
  r
def erase_bad_floor() -> isBehavioralCongruence(Nat[][], Intervention, Nat[], stepK(natNum, Kdown), stat(natNum), RStat(natNum)):
  @congruence{lambda x. lambda y. lambda r. statResp(natNum, x, y, r), fakeStepResp}

# attempt 2: run the distributional readout (energy cross term to Q0) after erasing
# the population to its statistic, with a resp that pretends it is constant
def fakeCrossResp(x: Nat[][], y: Nat[][], r: RStat(natNum, x, y)) -> Path(Nat, crossL1(natNum, x, Q0), crossL1(natNum, y, Q0)):
  <_> crossL1(natNum, x, Q0)
def erase_bad_distributional(q: Quotient(Nat[][], RStat(natNum))) -> Nat:
  quotRec(Nat[][], RStat(natNum), Nat, isSetNat, lambda x. crossL1(natNum, x, Q0), fakeCrossResp, q)

# the one that DOES go through: pseudobulk after erasure (a readout of the statistic)
def erase_good_pseudobulk(q: Quotient(Nat[][], RStat(natNum))) -> Nat[]:
  meanOfStat(natNum, statQ(natNum, isSetListNat, q))

def main() -> Nat:
  0n
