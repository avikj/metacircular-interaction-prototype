type Stream:
  case @Cons:
    head: Nat
    tail: Stream
def ones() -> Stream:
  @Cons{1n, ones()}
def rep(n: Nat) -> Stream:
  @Cons{n, rep(n)}
def twos() -> Stream:
  @Cons{2n, twos()}
# UNGUARDED corecursive "proof": must be [unchecked] (refused by --total)
def cheat() -> Path(Stream, ones(), twos()):
  cheat()
# FALSE bisimulation: heads differ, must ✗
def wrong() -> Path(Stream, ones(), twos()):
  <i> @Cons{1n, wrong() @ i}
# guarded but through a non-constructor (tail of): must NOT be [productive]
def viaTail() -> Stream:
  match ones():
    case @Cons{h, t}:
      viaTail()
def main() -> Nat:
  0n
