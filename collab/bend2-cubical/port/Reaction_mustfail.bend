# The soundness probe for Reaction.bend §5: forgetting the enzyme ENTIRELY
# (relation: A, B, C agree, nothing about E) is a reduction through which the
# generator does not descend — r3's effect depends on whether E is present.
# The resp obligation for `fire` at r3 would need Path(St, fire(x,r3),
# fire(y,r3)) from agreement on A,B,C alone; the constant path below has the
# wrong right endpoint whenever E differs, and the substrate must reject
# `fire_forgetE_WRONG`.
import Reaction

def AgreeABC(x: St, y: St) -> Set:
  any pa: Path(Nat, aOf(x), aOf(y)). any pb: Path(Nat, bOf(x), bOf(y)). Path(Nat, cOf(x), cOf(y))
def AgreeABCR() -> St -> St -> Set:
  lambda x. lambda y. AgreeABC(x, y)
def fireResp_WRONG(x: St, y: St, r: AgreeABC(x, y)) -> Path(Quotient(St, AgreeABCR()), @cl{fire(x, @r3)}, @cl{fire(y, @r3)}):
  <_> @cl{fire(x, @r3)}
def fire_forgetE_WRONG(m: Quotient(St, AgreeABCR())) -> Quotient(St, AgreeABCR()):
  quotRec(St, AgreeABCR(), Quotient(St, AgreeABCR()), squash(St, AgreeABCR()), lambda s. @cl{fire(s, @r3)}, fireResp_WRONG, m)

def main() -> Nat:
  0n
