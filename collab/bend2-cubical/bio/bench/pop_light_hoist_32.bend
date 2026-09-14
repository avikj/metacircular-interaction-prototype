# generated (bio/bench/README.md) — N=32, mode=hoist: the program bound once, call-by-need, regime=light
type Cell:
  case @cell:
    tf: Nat
    tg: Nat
    rp: Nat
    hd: Nat
type Act:
  case @kdTF:
  case @kdTG:
  case @kdHD:
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: b
    case 1n + p: 1n + add(p, b)
def mul(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: 0n
    case 1n + p: add(b, mul(p, b))
def step(c: Cell, a: Act) -> Cell:
  match c:
    case @cell{tf, tg, rp, hd}:
      match a:
        case @kdTF{}: @cell{0n, add(tf, tg), rp, hd}
        case @kdTG{}: @cell{tf, 0n, add(tg, rp), hd}
        case @kdHD{}: @cell{tf, tg, rp, 0n}
def observe(c: Cell) -> Nat:
  match c:
    case @cell{tf, tg, rp, hd}: rp
def perturb(c: Cell, w: Act[]) -> Cell:
  match w:
    case []: c
    case a <> rest: perturb(step(c, a), rest)
def word() -> Act[]:
  [@kdTF, @kdTG, @kdHD, @kdTF, @kdTG, @kdTF, @kdTG, @kdHD]
def program() -> Act[]:
  word()
def prog(c: Cell) -> Nat:
  observe(perturb(c, program()))
def progW(w: Act[], c: Cell) -> Nat:
  observe(perturb(c, w))
def mapProg(cs: Cell[]) -> Nat[]:
  match cs:
    case []: []
    case c <> rest: prog(c) <> mapProg(rest)
def mapProgW(w: Act[], cs: Cell[]) -> Nat[]:
  match cs:
    case []: []
    case c <> rest: progW(w, c) <> mapProgW(w, rest)
def main() -> Nat[]:
  (lambda w. mapProgW(w, [@cell{1n, 0n, 0n, 0n}, @cell{2n, 2n, 1n, 1n}, @cell{3n, 0n, 0n, 2n}, @cell{1n, 2n, 1n, 3n}, @cell{2n, 0n, 0n, 4n}, @cell{3n, 2n, 1n, 0n}, @cell{1n, 0n, 0n, 1n}, @cell{2n, 2n, 1n, 2n}, @cell{3n, 0n, 0n, 3n}, @cell{1n, 2n, 1n, 4n}, @cell{2n, 0n, 0n, 0n}, @cell{3n, 2n, 1n, 1n}, @cell{1n, 0n, 0n, 2n}, @cell{2n, 2n, 1n, 3n}, @cell{3n, 0n, 0n, 4n}, @cell{1n, 2n, 1n, 0n}, @cell{2n, 0n, 0n, 1n}, @cell{3n, 2n, 1n, 2n}, @cell{1n, 0n, 0n, 3n}, @cell{2n, 2n, 1n, 4n}, @cell{3n, 0n, 0n, 0n}, @cell{1n, 2n, 1n, 1n}, @cell{2n, 0n, 0n, 2n}, @cell{3n, 2n, 1n, 3n}, @cell{1n, 0n, 0n, 4n}, @cell{2n, 2n, 1n, 0n}, @cell{3n, 0n, 0n, 1n}, @cell{1n, 2n, 1n, 2n}, @cell{2n, 0n, 0n, 3n}, @cell{3n, 2n, 1n, 4n}, @cell{1n, 0n, 0n, 0n}, @cell{2n, 2n, 1n, 1n}]))(program())
