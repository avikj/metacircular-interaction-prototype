type Stream:
  case @Cons:
    head: Nat
    tail: Stream
# corecursive, constructor-guarded: an infinite stream
def ones() -> Stream:
  @Cons{1n, ones()}
def from(n: Nat) -> Stream:
  @Cons{n, from(1n + n)}
# NOT guarded: a loop
def bad() -> Stream:
  bad()
def hd(s: Stream) -> Nat:
  match s:
    case @Cons{h, t}:
      h
def tl(s: Stream) -> Stream:
  match s:
    case @Cons{h, t}:
      t
# a corecursive PATH between two corecursive streams (bisimulation as a path)
def rep(n: Nat) -> Stream:
  @Cons{n, rep(n)}
def repOnes() -> Path(Stream, rep(1n), ones()):
  <i> @Cons{1n, repOnes() @ i}
# structural recursion on a possibly-infinite value: accepted?
def sumTo(k: Nat, s: Stream) -> Nat:
  match k:
    case 0n:
      0n
    case 1n + p:
      match s:
        case @Cons{h, t}:
          1n + sumTo(p, t)
def main() -> Nat:
  hd(tl(tl(from(5n))))
