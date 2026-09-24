# Well-typed, but unary `not` on Bool is type-directed and the emitter does
# not yet carry the operand type: --to-hvm4-full must refuse it and emit
# nothing, never miscompile it.
def main() -> Bool:
  not True
