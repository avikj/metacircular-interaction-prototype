# Control for same_definition_twice.bend: identical defs under two names get
# distinct static labels even on stock HVM4: #Suc^4 #Zer in 27 interactions.

def twoA(A: Set, f: A -> A, x: A) -> A:
  f(f(x))

def twoB(A: Set, f: A -> A, x: A) -> A:
  f(f(x))

def suc(n: Nat) -> Nat:
  1n + n

def main() -> Nat:
  twoA(Nat -> Nat, lambda g. twoB(Nat, g), suc, 0n)
