# Label-capture regression: Core evaluates main to 4 (1n+1n+1n+1n+0n). A
# SUP label is a dimension name; stock HVM4 reuses a definition's static
# labels in every δ-unfolding, so the two instances of `two` captured each
# other and the runtime returned λa.#Suc{a}. With hvm4-runtime.patch each
# unfolding gets fresh names: 4 in 27 interactions, exactly the count of
# distinct_definitions.bend (renaming bound dimensions is free).

def two(A: Set, f: A -> A, x: A) -> A:
  f(f(x))

def suc(n: Nat) -> Nat:
  1n + n

def main() -> Nat:
  two(Nat -> Nat, lambda g. two(Nat, g), suc, 0n)
