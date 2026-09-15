# Sharing: the same four readouts by FOUR separate folds over the same derivation.
import Perturb
def main() -> Pop(u64Num):
  match fold(u64Num, exK, deltaR(u64Num, exK), exP, stepK(u64Num, exK, exP, @kd{0}), exD):
    case @sv{u, d}:
      match fold(u64Num, exK, lenR(u64Num, exK), exP, stepK(u64Num, exK, exP, @kd{0}), exD):
        case 0n: fold(u64Num, exK, popR(u64Num, exK), exP, stepK(u64Num, exK, exP, @kd{0}), exD)
        case 1n + p:
          match fold(u64Num, exK, traceR(u64Num, exK), exP, stepK(u64Num, exK, exP, @kd{0}), exD):
            case []: fold(u64Num, exK, popR(u64Num, exK), exP, stepK(u64Num, exK, exP, @kd{0}), exD)
            case a <> rest: fold(u64Num, exK, popR(u64Num, exK), exP, stepK(u64Num, exK, exP, @kd{0}), exD)
