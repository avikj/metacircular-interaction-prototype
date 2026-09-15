# generated (bio/bench/README.md) — N=32, mode=supin, regime=light, I64 fields
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
def main() -> I64:
  prog(&0{&1{&2{&3{&4{@cell{+1, +0, +0, +0}, @cell{+2, +2, +1, +1}}, &4{@cell{+3, +0, +0, +2}, @cell{+1, +2, +1, +3}}}, &3{&4{@cell{+2, +0, +0, +4}, @cell{+3, +2, +1, +0}}, &4{@cell{+1, +0, +0, +1}, @cell{+2, +2, +1, +2}}}}, &2{&3{&4{@cell{+3, +0, +0, +3}, @cell{+1, +2, +1, +4}}, &4{@cell{+2, +0, +0, +0}, @cell{+3, +2, +1, +1}}}, &3{&4{@cell{+1, +0, +0, +2}, @cell{+2, +2, +1, +3}}, &4{@cell{+3, +0, +0, +4}, @cell{+1, +2, +1, +0}}}}}, &1{&2{&3{&4{@cell{+2, +0, +0, +1}, @cell{+3, +2, +1, +2}}, &4{@cell{+1, +0, +0, +3}, @cell{+2, +2, +1, +4}}}, &3{&4{@cell{+3, +0, +0, +0}, @cell{+1, +2, +1, +1}}, &4{@cell{+2, +0, +0, +2}, @cell{+3, +2, +1, +3}}}}, &2{&3{&4{@cell{+1, +0, +0, +4}, @cell{+2, +2, +1, +0}}, &4{@cell{+3, +0, +0, +1}, @cell{+1, +2, +1, +2}}}, &3{&4{@cell{+2, +0, +0, +3}, @cell{+3, +2, +1, +4}}, &4{@cell{+1, +0, +0, +0}, @cell{+2, +2, +1, +1}}}}}})
