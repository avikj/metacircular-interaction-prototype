# Compiler-generated universal execution smoke test.
# No fibre/derivation imports: the compiler must expose both the native
# reduction event and the lossless observation companions.

def id(x: Nat) -> Nat:
  x

def main() -> Nat:
  id(2n)
