# The CorpusSamvada question (B, f), completed through Carrier before
# continuing. Every response retains the previous whole in its new state.
import Carrier

type WholeProcess(A: Set, a: A):
  case @wholeProcess:
    respond: all B: Set. all f: A -> B. WholeReply(A, a, B, f)

type WholeReply(A: Set, a: A, B: Set, f: A -> B):
  case @wholeReply:
    value: Carrier(A, B, f)
    source: Path(A, ascend(A, B, f, value), a)
    next: WholeProcess(Carrier(A, B, f), value)

def wholeReply(A: Set, a: A, B: Set, f: A -> B,
               value: Carrier(A, B, f), source: Path(A, ascend(A, B, f, value), a)) -> WholeReply(A, a, B, f):
  @wholeReply{value, source, wholeProcess(Carrier(A, B, f), value)}

def wholeProcess(A: Set, a: A) -> WholeProcess(A, a):
  @wholeProcess{lambda B. lambda f. wholeReply(A, a, B, f,
    descend(A, B, f, a), <_> a)}

# Carrier.carry_transport_descend proves this beta reduction definitionally.
# Use that computed carrier in each continuing step; the generic univalent
# transport remains available, with the same value, in Carrier.bend.

def interact(A: Set, a: A, p: WholeProcess(A, a), B: Set, f: A -> B) -> WholeReply(A, a, B, f):
  match p: case @wholeProcess{respond}: respond(B, f)

def result(A: Set, B: Set, f: A -> B, value: Carrier(A, B, f)) -> B:
  match value: case @carry{base, carried, witness}: carried
