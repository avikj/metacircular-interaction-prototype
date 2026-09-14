def neg(x: Bool) -> Bool:
  if x: False else: True
def negLnv(x: Bool) -> Path(Bool, neg(neg(x)), x):
  if x: <_> True else: <_> False
# carrier-agnostic relation, so Quot(ua@i, Rc) is well-typed at every interior i
# transport a class along a carrier line = ua(neg): coe [true] = [neg true] = [false]
def coeQuot() -> Quot(Bool, lambda a. lambda b. Unit):
  coe(lambda i. Quot(ua(Bool, Bool, neg, neg, negLnv, negLnv) @ i, lambda a. lambda b. Unit), i0, i1, qcl(True))
def boundary() -> Path(Quot(Bool, lambda a. lambda b. Unit), coeQuot(), qcl(False)):
  <_> qcl(False)
def coeConst() -> Path(Quot(Bool, lambda a. lambda b. Unit), coe(lambda i. Quot(Bool, lambda a. lambda b. Unit), i0, i1, qcl(True)), qcl(True)):
  <_> qcl(True)
def main() -> Nat:
  0n
