# Native reduction instrumentation smoke.
# The compiler-side test inspects this definition's Core term and requires
# NativeStep to expose the application reduction rather than only its endpoint.

def id(x: Nat) -> Nat:
  x

def main() -> Nat:
  id(2n)
