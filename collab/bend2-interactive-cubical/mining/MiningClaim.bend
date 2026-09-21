# The mining predicate is the reading; the existing Carrier is its native
# lossless completion. The source, answer and path remain runtime values.
import Carrier
import MiningSha256

def btcCarrier(target: Bool[], header: Bool[]) -> Carrier(Bool[], Bool, lambda h. btcAccept(target, h)):
  carry_transport(Bool[], Bool, lambda h. btcAccept(target, h), header)

def btcRun(target: Bool[], header: Bool[]) -> any answer: Bool. any source: Bool[]. Path(Bool, btcAccept(target, source), answer):
  match btcCarrier(target, header):
    case @carry{source, answer, witness}:
      (answer, source, witness)

def btcRestore(target: Bool[], header: Bool[]) -> Bool[]:
  ascend(Bool[], Bool, lambda h. btcAccept(target, h), btcCarrier(target, header))

def main() -> Nat:
  0n
