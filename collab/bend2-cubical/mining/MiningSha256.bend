# The full bit-level Sha256.agda predicate, carried to the cubical Bend backend.
# Source: formal/cubical/Sha256.agda @ e1112905e213b7512cf5e52d291132db6d2d75fa.
# No reduced rounds, digest oracle, external nonce loop, or independent digest
# coordinates. The constants/padding are emitted as literal data by mining.mjs.
# Words are LSB-first Bool lists; messages/digests are MSB-first bit streams.
# This is a new source port: require the native conformance gate before mining.
import MiningConstants

def btcNot(x: Bool) -> Bool:
  if x: False
  else: True
def btcAnd(x: Bool, y: Bool) -> Bool:
  if x: y
  else: False
def btcOr(x: Bool, y: Bool) -> Bool:
  if x: True
  else: y
def btcXor(x: Bool, y: Bool) -> Bool:
  if x: btcNot(y)
  else: y

def btcAppend(xs: Bool[], ys: Bool[]) -> Bool[]:
  match xs:
    case []: ys
    case h <> t: h <> btcAppend(t, ys)
def btcRevGo(acc: Bool[], xs: Bool[]) -> Bool[]:
  match xs:
    case []: acc
    case h <> t: btcRevGo(h <> acc, t)
def btcRev(xs: Bool[]) -> Bool[]:
  btcRevGo([], xs)
def btcTake(n: Nat, xs: Bool[]) -> Bool[]:
  match n:
    case 0n: []
    case 1n + p:
      match xs:
        case []: []
        case h <> t: h <> btcTake(p, t)
def btcDrop(n: Nat, xs: Bool[]) -> Bool[]:
  match n:
    case 0n: xs
    case 1n + p:
      match xs:
        case []: []
        case h <> t: btcDrop(p, t)
def btcHasLength(n: Nat, xs: Bool[]) -> Bool:
  match n:
    case 0n:
      match xs:
        case []: True
        case h <> t: False
    case 1n + p:
      match xs:
        case []: False
        case h <> t: btcHasLength(p, t)
def btcEqBits(xs: Bool[], ys: Bool[]) -> Bool:
  match xs:
    case []:
      match ys:
        case []: True
        case h <> t: False
    case a <> at:
      match ys:
        case []: False
        case b <> bt:
          if btcXor(a, b): False
          else: btcEqBits(at, bt)

def btcAndW(xs: Bool[], ys: Bool[]) -> Bool[]:
  match xs:
    case []: []
    case a <> at:
      match ys:
        case []: []
        case b <> bt: btcAnd(a, b) <> btcAndW(at, bt)
def btcXorW(xs: Bool[], ys: Bool[]) -> Bool[]:
  match xs:
    case []: []
    case a <> at:
      match ys:
        case []: []
        case b <> bt: btcXor(a, b) <> btcXorW(at, bt)
def btcNotW(xs: Bool[]) -> Bool[]:
  match xs:
    case []: []
    case h <> t: btcNot(h) <> btcNotW(t)
def btcRot1(xs: Bool[]) -> Bool[]:
  match xs:
    case []: []
    case h <> t: btcAppend(t, [h])
def btcShift1(xs: Bool[]) -> Bool[]:
  match xs:
    case []: []
    case h <> t: btcAppend(t, [False])
def btcRot(n: Nat, xs: Bool[]) -> Bool[]:
  match n:
    case 0n: xs
    case 1n + p: btcRot(p, btcRot1(xs))
def btcShift(n: Nat, xs: Bool[]) -> Bool[]:
  match n:
    case 0n: xs
    case 1n + p: btcShift(p, btcShift1(xs))
def btcAddC(c: Bool, xs: Bool[], ys: Bool[]) -> Bool[]:
  match xs:
    case []: []
    case a <> at:
      match ys:
        case []: btcXor(a, c) <> btcAddC(btcAnd(a, c), at, [])
        case b <> bt:
          btcXor(a, btcXor(b, c)) <> btcAddC(btcOr(btcAnd(a, b), btcAnd(c, btcXor(a, b))), at, bt)
def btcAddW(xs: Bool[], ys: Bool[]) -> Bool[]:
  btcAddC(False, xs, ys)
def btcCh(e: Bool[], f: Bool[], g: Bool[]) -> Bool[]:
  btcXorW(btcAndW(e, f), btcAndW(btcNotW(e), g))
def btcMaj(a: Bool[], b: Bool[], c: Bool[]) -> Bool[]:
  btcXorW(btcAndW(a, b), btcXorW(btcAndW(a, c), btcAndW(b, c)))
def btcBig0(w: Bool[]) -> Bool[]:
  btcXorW(btcRot(2n, w), btcXorW(btcRot(13n, w), btcRot(22n, w)))
def btcBig1(w: Bool[]) -> Bool[]:
  btcXorW(btcRot(6n, w), btcXorW(btcRot(11n, w), btcRot(25n, w)))
def btcSmall0(w: Bool[]) -> Bool[]:
  btcXorW(btcRot(7n, w), btcXorW(btcRot(18n, w), btcShift(3n, w)))
def btcSmall1(w: Bool[]) -> Bool[]:
  btcXorW(btcRot(17n, w), btcXorW(btcRot(19n, w), btcShift(10n, w)))

# Same strictness binders as Sha256.sW / forceWs. No accidental normalization
# of a symbolic candidate is allowed in the host/compiler preparation step.
def btcForceW(A: Set, xs: Bool[], k: Bool[] -> A) -> A:
  match xs:
    case []: k([])
    case b <> bs:
      if b: btcForceW(A, bs, lambda v. k(True <> v))
      else: btcForceW(A, bs, lambda v. k(False <> v))
def btcForceWs(A: Set, xs: Bool[][], k: Bool[][] -> A) -> A:
  match xs:
    case []: k([])
    case w <> ws: btcForceW(A, w, lambda v. btcForceWs(A, ws, lambda vs. k(v <> vs)))
def btcNth(n: Nat, xs: Bool[][]) -> Bool[]:
  match xs:
    case []: btcZeroW()
    case h <> t:
      match n:
        case 0n: h
        case 1n + p: btcNth(p, t)
def btcRevWs(acc: Bool[][], xs: Bool[][]) -> Bool[][]:
  match xs:
    case []: acc
    case h <> t: btcRevWs(h <> acc, t)
def btcToWords(n: Nat, bits: Bool[]) -> Bool[][]:
  match n:
    case 0n: []
    case 1n + p: btcRev(btcTake(32n, bits)) <> btcToWords(p, btcDrop(32n, bits))
def btcExtend(n: Nat, acc: Bool[][]) -> Bool[][]:
  match n:
    case 0n: acc
    case 1n + p:
      btcForceW(Bool[][], btcAddW(btcAddW(btcSmall1(btcNth(1n, acc)), btcNth(6n, acc)), btcAddW(btcSmall0(btcNth(14n, acc)), btcNth(15n, acc))), lambda w. btcExtend(p, w <> acc))
def btcSchedule(block: Bool[]) -> Bool[][]:
  btcForceWs(Bool[][], btcRevWs([], btcToWords(16n, block)), lambda ws. btcRevWs([], btcExtend(48n, ws)))
def btcRound(st: Bool[][], k: Bool[], w: Bool[]) -> Bool[][]:
  a = btcNth(0n, st)
  b = btcNth(1n, st)
  c = btcNth(2n, st)
  d = btcNth(3n, st)
  e = btcNth(4n, st)
  f = btcNth(5n, st)
  g = btcNth(6n, st)
  h = btcNth(7n, st)
  btcForceW(Bool[][], btcAddW(h, btcAddW(btcBig1(e), btcAddW(btcCh(e, f, g), btcAddW(k, w)))), lambda t1.
    btcForceW(Bool[][], btcAddW(btcBig0(a), btcMaj(a, b, c)), lambda t2.
      btcForceW(Bool[][], btcAddW(t1, t2), lambda aa.
        btcForceW(Bool[][], btcAddW(d, t1), lambda ee. [aa, a, b, c, ee, e, f, g]))))
def btcRounds(st: Bool[][], ks: Bool[][], ws: Bool[][]) -> Bool[][]:
  match ks:
    case []: st
    case k <> kt:
      match ws:
        case []: st
        case w <> wt: btcRounds(btcRound(st, k, w), kt, wt)
def btcFeed(xs: Bool[][], ys: Bool[][]) -> Bool[][]:
  match xs:
    case []: []
    case a <> at:
      match ys:
        case []: []
        case b <> bt: btcAddW(a, b) <> btcFeed(at, bt)
def btcCompress(st: Bool[][], block: Bool[]) -> Bool[][]:
  btcForceWs(Bool[][], st, lambda hs. btcFeed(hs, btcRounds(hs, btcK(), btcSchedule(block))))
def btcBlocks(n: Nat, st: Bool[][], padded: Bool[]) -> Bool[][]:
  match n:
    case 0n: st
    case 1n + p: btcBlocks(p, btcCompress(st, btcTake(512n, padded)), btcDrop(512n, padded))
def btcFlatten(ws: Bool[][]) -> Bool[]:
  match ws:
    case []: []
    case w <> wt: btcAppend(btcRev(w), btcFlatten(wt))
def btcDouble80(header: Bool[]) -> Bool[]:
  inner = btcFlatten(btcBlocks(2n, btcIV(), btcAppend(header, btcPad80())))
  btcFlatten(btcBlocks(1n, btcIV(), btcAppend(inner, btcPad32())))

# Reverse bytes, not bits inside each byte. The comparison includes equality.
def btcReverseBytes(n: Nat, xs: Bool[]) -> Bool[]:
  match n:
    case 0n: []
    case 1n + p: btcAppend(btcReverseBytes(p, btcDrop(8n, xs)), btcTake(8n, xs))
def btcLeBits(xs: Bool[], ys: Bool[]) -> Bool:
  match xs:
    case []: True
    case a <> at:
      match ys:
        case []: False
        case b <> bt:
          if btcXor(a, b): b
          else: btcLeBits(at, bt)
def btcAccept(target: Bool[], header: Bool[]) -> Bool:
  if btcHasLength(640n, header):
    if btcHasLength(256n, target): btcLeBits(btcReverseBytes(32n, btcDouble80(header)), target)
    else: False
  else: False

def main() -> Nat:
  0n
