# coinduction: a stream is a record whose tail is a delayed field, and a
# guarded self-call under that delay is productive. A bisimulation is a
# corecursive path, checked by its faces one unfolding at a time; a
# corecursive value prints one unfolding
import Base

type Stream<-A: Type> is Type:
  mk{hd: A, tl: Unit -> Stream<A>}

def ones() -> Stream<Nat>:
  mk{1n, _ => ones()}

def rep(+x: Nat) -> Stream<Nat>:
  mk{x, _ => rep(x)}

def from(+n: Nat) -> Stream<Nat>:
  mk{n, _ => from((1n + n : Nat))}

def take(k: Nat, s: Stream<Nat>) -> List<Nat>:
  match k s:
    case 0n mk{h, t}:
      []
    case 1n+p mk{h, t}:
      h <> take(p, t(Unit{}))

# a bisimulation: rep(1n) and ones() unfold alike, forever
law rep_ones:
  {rep(1n) == ones() : Stream<Nat>}

def rep_ones():
  i => mk{1n, _ => rep_ones()(i)}

# an observation of the corecursive proof at a face is the stream
law rep_ones_face:
  {rep_ones()(i0) == rep(1n) : Stream<Nat>}

def rep_ones_face(): {==}

def main() -> List<Nat> & Stream<Nat>:
  (take(3n, from(5n)), ones())

#|([5n, 6n, 7n], mk{1n, _ => ones})
