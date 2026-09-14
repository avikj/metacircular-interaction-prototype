# The soundness probe for Perturbation.bend §6: the receiver that reads hk
# does NOT descend through the erasure that forgets hk.  Its resp obligation
# would be Path(Nat, hkOf(x), hkOf(y)) from AgreeVis(x, y), which says
# nothing about hk; the only candidate below is the constant path, whose
# right endpoint is hkOf(x), not hkOf(y).  The substrate must reject
# `hk_erased_WRONG` — an erasure that destroys a distinction the
# computation uses is caught, not silently taken.
import Perturbation

def hkResp_WRONG(x: Cell, y: Cell, r: AgreeVis(x, y)) -> Path(Nat, hkOf(x), hkOf(y)):
  <_> hkOf(x)
def hk_erased_WRONG(m: Erased) -> Nat:
  quotRec(Cell, AgreeVisR(), Nat, setNat(), hkOf, hkResp_WRONG, m)

def main() -> Nat:
  0n
