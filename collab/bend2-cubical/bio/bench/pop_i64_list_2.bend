# generated (bio/bench/README.md) — N=2, mode=list, regime=light, I64 fields
type Cell:
  case @cell:
    tf: I64
    tg: I64
    rp: I64
    hd: I64
type Act:
  case @kdTF:
  case @kdTG:
  case @kdHD:
def step(c: Cell, a: Act) -> Cell:
  match c:
    case @cell{tf, tg, rp, hd}:
      match a:
        case @kdTF{}: @cell{+0, tf + tg, rp, hd}
        case @kdTG{}: @cell{tf, +0, tg + rp, hd}
        case @kdHD{}: @cell{tf, tg, rp, +0}
def observe(c: Cell) -> I64:
  match c:
    case @cell{tf, tg, rp, hd}: rp
def perturb(c: Cell, w: Act[]) -> Cell:
  match w:
    case []: c
    case a <> rest: perturb(step(c, a), rest)
def program() -> Act[]:
  [@kdTF, @kdTG, @kdHD, @kdTF, @kdTG, @kdTF, @kdTG, @kdHD]
def prog(c: Cell) -> I64:
  observe(perturb(c, program()))
def mapProg(cs: Cell[]) -> I64[]:
  match cs:
    case []: []
    case c <> rest: prog(c) <> mapProg(rest)
def main() -> I64[]:
  mapProg([@cell{+1, +0, +0, +0}, @cell{+2, +2, +1, +1}])
