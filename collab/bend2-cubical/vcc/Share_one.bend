# Sharing: the four readouts of one derivation by ONE fold of the product receiver.
import Perturb
def main() -> Pop(u64Num):
  match elucidate(u64Num, exK, exP, stepK(u64Num, exK, exP, @kd{0}), exD):
    case (pop, rest):
      match rest:
        case (dl, rest2):
          match rest2:
            case (n, tr):
              match dl:
                case @sv{u, d}: pop
