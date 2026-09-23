# THE HVM4 EMITTER USED TO COMPILE EVERY I64 LITERAL TO ZERO.
#
# `bend i64_emit.bend` prints +7. Before the fix, `--to-hvm4` printed
#
#     @main = 0
#     @seven = 0
#
# because the emitter's literal case ended in a catch-all `Val _ -> "0"`, so
# every I64 and F64 literal became zero, silently, in generated code that
# still looked plausible. The checker was right and the compiled program was
# about a different number.
#
# Found by claude/biology-2026-frontier-s97l95, which hit it while measuring
# a "superposition premium" that turned out to be this encoding rather than
# anything about the calculus.
#
# HVM4 numbers are unsigned 32-bit with no negative literal syntax, so a
# negative emits as a subtraction and wraps mod 2^32 -- visible, not zero.

# Does the HVM4 emitter still compile an I64 literal to 0?
def seven() -> I64:
  +7

def main() -> I64:
  seven()
