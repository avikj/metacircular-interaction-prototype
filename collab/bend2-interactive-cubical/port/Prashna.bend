# theorems/residue/Prashna_TheInteractiveMachineStrictlyContainsTheTuringMachineAndDeterminismIsExactlyTheCollapse.agda,
# in Bend, on the ISC of HLevelOfInteraction: with the trivial question and a
# receipt event the process space is a point (the closed machine has exactly
# one execution); with a free question and no receipt it is not.
import HLevelOfInteraction

# the deterministic instance: one question, the receipt pins the successor
def uStep(n: Nat) -> Nat:
  1n + n
def DetISC(mc: Nat) -> Set:
  Netra(Nat, Unit, Unit, lambda w. lambda q. uStep(w), lambda w. lambda q. (), mc)
def turingISC(mc: Nat) -> DetISC(mc):
  netra(Nat, Unit, Unit, lambda w. lambda q. uStep(w), lambda w. lambda q. (), mc)
# determinism IS the collapse: the space of executions is contractible
def deterministic_collapse(mc: Nat) -> isContr(DetISC(mc)):
  oneEye(Nat, Unit, Unit, lambda w. lambda q. uStep(w), lambda w. lambda q. (), isSetNat, isSetUnit, mc)

# the free instance: the environment may ask to stay or to step, no receipt
def FreeISC(mc: Nat) -> Set:
  ISC(Nat, lambda w. Bool, lambda w. lambda q. lambda w2. Unit, lambda w. lambda q. lambda w2. lambda o. Unit, mc)
def stayer(mc: Nat) -> FreeISC(mc):
  @isc{lambda q. (mc, (), (), stayer(mc))}
def stepper(mc: Nat) -> FreeISC(mc):
  @isc{lambda q. (if q: uStep(mc) else: mc, (), (), stepper(if q: uStep(mc) else: mc))}
# the successor a process reports on the question True
def nextOn(mc: Nat, p: FreeISC(mc)) -> Nat:
  match p:
    case @isc{r}:
      match r(True):
        case (w2, o, e, t): w2
def nextOn_stayer(mc: Nat) -> Path(Nat, nextOn(mc, stayer(mc)), mc):
  <_> mc
def nextOn_stepper(mc: Nat) -> Path(Nat, nextOn(mc, stepper(mc)), 1n + mc):
  <_> 1n + mc
# interaction is strictly wider than the Turing machine: two lawful processes differ
def free_processes_differ(P: Path(FreeISC(0n), stayer(0n), stepper(0n))) -> Empty:
  nNotSuc(0n, <i> nextOn(0n, P @ i))
def interaction_is_strictly_wider(c: isContr(FreeISC(0n))) -> Empty:
  match c:
    case (centre, h):
      free_processes_differ(compPath(FreeISC(0n), stayer(0n), centre, stepper(0n), <i> h(stayer(0n)) @ inot(i), h(stepper(0n))))

def main() -> Nat:
  nextOn(3n, stepper(3n))
