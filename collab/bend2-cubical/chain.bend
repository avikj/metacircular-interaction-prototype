# Transport across COMPOSITE equivalences, performed by the net.
# Every definition below is checked, then run in three ways: in-process
# (normaliser), --to-hvm4-raw (no pre-normalisation) and --to-hvm (HVM3).
def neg(x: Bool) -> Bool:
  if x:
    False
  else:
    True
def negLnv(x: Bool) -> Path(Bool, neg(neg(x)), x):
  if x:
    <_> True
  else:
    <_> False
def negPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, neg, neg, negLnv, negLnv)

# composition of universe paths (hcomp in Set): neg then neg
def negNeg() -> Path(Set, Bool, Bool):
  <i> hcomp(Set, i, <_> Bool, <k> negPath() @ k, negPath() @ i)
# three negations
def neg3() -> Path(Set, Bool, Bool):
  <i> hcomp(Set, i, <_> Bool, <k> negPath() @ k, negNeg() @ i)

def viaNegNeg(x: Bool) -> Bool:
  coe(lambda i. negNeg() @ i, i0, i1, x)
def viaNeg3(x: Bool) -> Bool:
  coe(lambda i. neg3() @ i, i0, i1, x)
def viaNeg3Bwd(x: Bool) -> Bool:
  coe(lambda i. neg3() @ i, i1, i0, x)
# inverse line
def viaInv(x: Bool) -> Bool:
  coe(lambda i. negPath() @ inot(i), i0, i1, x)
# Pi line: a function Bool -> Bool transported along (negPath -> Bool)
def viaPi(x: Bool) -> Bool:
  (coe(lambda i. (negPath() @ i) -> Bool, i0, i1, lambda y. y))(x)
# Sigma line: a pair transported componentwise along Σ (negPath) Bool
def viaSig(x: Bool) -> Bool:
  match coe(lambda i. any a: (negPath() @ i). Bool, i0, i1, (x, x)):
    case (a, b):
      a

# the laws on closed values, definitional in the checker (on a variable x,
# neg(neg(x)) = x is only propositional, as in cubical Agda)
def negNeg_T() -> Path(Bool, viaNegNeg(True), True):
  <_> True
def negNeg_F() -> Path(Bool, viaNegNeg(False), False):
  <_> False
def neg3_T() -> Path(Bool, viaNeg3(True), False):
  <_> False
def neg3Bwd_F() -> Path(Bool, viaNeg3Bwd(False), True):
  <_> True
def inv_T() -> Path(Bool, viaInv(True), False):
  <_> False
def pi_T() -> Path(Bool, viaPi(True), False):
  <_> False
def sig_T() -> Path(Bool, viaSig(True), False):
  <_> False

def main() -> Bool:
  viaNeg3(True)
