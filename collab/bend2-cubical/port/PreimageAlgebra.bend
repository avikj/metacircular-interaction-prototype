# A finite Boolean preimage algebra in the fibre calculus.
# The map is the 2-bit parity predicate; the Carrier result retains the
# source and its equality receipt instead of projecting to the verdict.
import Carrier

def xor(x: Bool, y: Bool) -> Bool:
  if x:
    if y: False
    else: True
  else:
    y

def parity2(x: Bool[], y: Bool) -> Bool:
  match x:
    case []: y
    case h <> t: parity2(t, xor(h, y))

def preimage(source: Bool[]) -> Bool:
  parity2(source, False)

def carryPreimage(source: Bool[]) -> Carrier(Bool[], Bool, preimage):
  carry_transport(Bool[], Bool, preimage, source)

def witness(source: Bool[]) -> Bool:
  match carryPreimage(source):
    case @carry{source, carried, witness}: carried

def main() -> Bool:
  witness([True, False, True, True])
