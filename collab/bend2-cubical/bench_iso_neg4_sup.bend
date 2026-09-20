def neg(x: Bool) -> Bool:
  if x:
    False
  else:
    True
def neg4(x: Bool) -> Bool:
  neg(neg(neg(neg(x))))
def neg16(x: Bool) -> Bool:
  neg4(neg4(neg4(neg4(x))))
def main() -> Bool:
  neg4(&0{True, False})
