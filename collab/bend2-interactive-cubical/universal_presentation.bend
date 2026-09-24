# Canonical source-level oracle for the compiler-intrinsic presentation.
import port/UniversalPresentation

def universalPresentationResult() -> Nat:
  recover(Nat, Nat, lambda n. 1n + n, 2n)

def main() -> Nat:
  universalPresentationResult()
