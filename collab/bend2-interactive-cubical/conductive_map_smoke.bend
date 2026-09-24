# Function-valued entry: the map itself is the first observation.
# The compiler must emit @conductiveMapMain without source fibre boilerplate.

def main(x: Bool) -> Bool:
  if x:
    False
  else:
    True
