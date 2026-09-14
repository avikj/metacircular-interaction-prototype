# generated (bio/bench/README.md) — N=8, mode=list: the program re-entered per cell, regime=heavy
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
# the shared generator is EXPENSIVE to construct: gated behind a full equality
# test on mul(30,30) (a head-only gate would be satisfied lazily in ~14 itrs)
def natEqb(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n: True
        case 1n + q: False
    case 1n + p:
      match b:
        case 0n: False
        case 1n + q: natEqb(p, q)
def program() -> Act[]:
  match natEqb(mul(30n, 30n), 900n):
    case True: word()
    case False: []
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
  mapProg([@cell{1n, 0n, 0n, 0n}, @cell{2n, 2n, 1n, 1n}, @cell{3n, 0n, 0n, 2n}, @cell{1n, 2n, 1n, 3n}, @cell{2n, 0n, 0n, 4n}, @cell{3n, 2n, 1n, 0n}, @cell{1n, 0n, 0n, 1n}, @cell{2n, 2n, 1n, 2n}])
