# Compiler-generated conductive entry smoke test.
#
# There is intentionally NO source-level call to fibreCoalgebra in main.
# Target.HVM4Full must emit:
#
#   @__whole_main = @fibreCoalgebra(#Nat, @main)
#
# because FibreCoalgebra is linked by the import and main is a checked Nat.
# This isolates the language-level entry seam from SAT or any application logic.

import port/FibreCoalgebra

def main() -> Nat:
  2n
