# the recursor needs a LOOP in the target, not just a point: refl on a
# different point is not a Path(B,b,b)
def bad(B: Set, b: B, c: B, p: Path(B, b, c)) -> B:
  srec(s1base, b, p)
# s1loop is not definitionally refl: S1 is not a set
def notRefl() -> Path(Path(S1, s1base, s1base), <i> s1loop @ i, <_> s1base):
  <_> <_> s1base
