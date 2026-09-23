import WholeProcess

# A concrete configuration constraint: exactly one of two features is enabled.
type Assignment:
  case @assignment:
    x: Bool
    y: Bool

def formula(a: Assignment) -> Bool:
  match a:
    case @assignment{x, y}:
      if x: if y: False else: True
      else: y

# The carrier includes a path from the computed answer to the reading.
def present(a: Assignment) -> Carrier(Assignment, Bool, formula):
  carry_transport(Assignment, Bool, formula, a)

def exact(a: Assignment) -> Path(Assignment, ascend(Assignment, Bool, formula, present(a)), a):
  <_> a

type Reading:
  case @reading:
    x: Bool
    y: Bool
    answer: Bool

# Demand a second response from the retained continuation: recover the
# assignment after asking whether it satisfies the formula.
def query(a: Assignment) -> Reading:
  match interact(Assignment, a, wholeProcess(Assignment, a), Bool, formula):
    case @wholeReply{value, source, next}:
      match interact(Carrier(Assignment, Bool, formula), value, next,
                     Assignment, lambda c. ascend(Assignment, Bool, formula, c)):
        case @wholeReply{second, receipt, more}:
          match result(Carrier(Assignment, Bool, formula), Assignment,
                       lambda c. ascend(Assignment, Bool, formula, c), second):
            case @assignment{x, y}:
              @reading{x, y, result(Assignment, Bool, formula, value)}

def main() -> Reading:
  query(@assignment{&100{False, True}, &101{False, True}})
