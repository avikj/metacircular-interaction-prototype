# Descent, RUN: the erased state is a point of the quotient; the descended
# readouts compute through the quotient recursor (@qrec) on HVM4.
import Perturb

def P3() -> Nat[][]:
  [[3n, 1n], [1n, 3n], [2n, 2n]]
# the erased state: the class of P3 in Pop / RStat
def erased() -> Quotient(Nat[][], RStat(natNum)):
  @cl{P3}
# the statistic and the pseudobulk read through the quotient
def statOfErased() -> Nat[]:
  statQ(natNum, isSetListNat, erased)
def pseudobulkOfErased() -> Nat[]:
  meanOfStat(natNum, statOfErased)
# the class after one up-shift, read in the minimal machine (mediate then quotObserve)
def Kex() -> Knowledge(natNum):
  Kup(natNum, lambda a. [1n, 0n])
def afterStep() -> vccMeaning(natNum, Kex):
  quotStep(Nat[][], Intervention, Nat[], stepK(natNum, Kex), stat(natNum), statMediate(natNum, natLaws, lambda a. [1n, 0n], erased), @kd{0})
def observedAfterStep() -> Nat[]:
  quotObserve(Nat[][], Intervention, Nat[], stepK(natNum, Kex), isSetListNat, stat(natNum), afterStep)
def main() -> Nat[][]:
  [statOfErased, pseudobulkOfErased, observedAfterStep]
