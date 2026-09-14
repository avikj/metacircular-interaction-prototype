# The elucidator = compression-is-transport, run on Bach fugue material.
# A monophonic line m factors as  m ≃ (start, shape)  where shape = the interval
# sequence (the SUBJECT, transposition-invariant) and start = the fibre (which
# entry pitch).  A fugue's voices are all the subject TRANSPORTED (transposed /
# inverted), so they share one shape: the whole fugue compresses to one subject
# + the fibre of transforms. Nothing is searched — the shape is computed; the
# factoring is an identity (verified definitionally by the Path proofs below).

def mapI(f: I64 -> I64, xs: I64[]) -> I64[]:
  ~ xs { []: [] ; <>: lambda h. lambda t. f(h) <> mapI(f, t) ; }

def transpose(k: I64, m: I64[]) -> I64[]:
  mapI(lambda p. p + k, m)

def headOr0(m: I64[]) -> I64:
  ~ m { []: +0 ; <>: lambda h. lambda t. h ; }
def tailOr(m: I64[]) -> I64[]:
  ~ m { []: [] ; <>: lambda h. lambda t. t ; }

# shape = successive intervals (length n-1): the transposition-invariant subject
def shapeFrom(prev: I64, xs: I64[]) -> I64[]:
  ~ xs { []: [] ; <>: lambda h. lambda t. (h - prev) <> shapeFrom(h, t) ; }
def shape(m: I64[]) -> I64[]:
  shapeFrom(headOr0(m), tailOr(m))

# transport back: reconstruct the line from (start, shape) — the inverse map
def fromShapeGo(cur: I64, s: I64[]) -> I64[]:
  ~ s { []: [] ; <>: lambda d. lambda ds. (cur + d) <> fromShapeGo(cur + d, ds) ; }
def fromShape(start: I64, s: I64[]) -> I64[]:
  start <> fromShapeGo(start, s)

def negateShape(s: I64[]) -> I64[]:
  mapI(lambda x. +0 - x, s)
# inversion of a line about its own first note: p |-> 2*start - p
def invertVoice(m: I64[]) -> I64[]:
  mapI(lambda p. (headOr0(m) + headOr0(m)) - p, m)

# ---- the material: a stylized subject and its fugal entries ----
def subject() -> I64[]:
  [+0, +2, +4, +5, +4, +2, +0]          # C D E F E D C
def answer() -> I64[]:
  transpose(+7, subject())              # entry on the dominant (real answer)
def lateEntry() -> I64[]:
  transpose(+12, subject())             # entry an octave up
def inverted() -> I64[]:
  invertVoice(subject())                # inverted entry

# a second, different fugue that quotes the same subject in one voice
def fugueB_voice() -> I64[]:
  transpose(-5, subject())              # same subject, different fugue/entry

# ================= the factoring, verified as identities =================

# 1. LOSSLESS: m ≃ (start, shape). Reconstruct from the factors == original.
def lossless() -> Path(I64[], fromShape(headOr0(subject()), shape(subject())), subject()):
  <_> subject()

# 2. TRANSPORT IS FREE: transposition (the fibre) does not touch the subject.
#    shape is invariant — the "common info" everyone shares, computed, not searched.
def transportInvariance() -> Path(I64[], shape(answer()), shape(subject())):
  <_> shape(subject())

# 3. THE FUGUE IS ONE SUBJECT: every voice shares the one shape.
def answerIsSubject() -> Path(I64[], shape(answer()), shape(subject())):
  <_> shape(subject())
def lateIsSubject() -> Path(I64[], shape(lateEntry()), shape(subject())):
  <_> shape(subject())

# 4. INVERSION is a DIFFERENT transform, recorded in the fibre: its shape is the
#    negation of the subject's shape (so the group {id,invert} is what collapses it).
def inversionNegates() -> Path(I64[], shape(inverted()), negateShape(shape(subject()))):
  <_> negateShape(shape(subject()))

# 5. CROSS-FUGUE COLLAPSE: a voice in a different fugue that quotes the subject
#    has the identical shape — shared material across the corpus is one class.
def crossFugueShared() -> Path(I64[], shape(fugueB_voice()), shape(subject())):
  <_> shape(subject())

# the whole fugue, compressed: ONE subject shape + the fibre of entry pitches.
# (7-note voices x 4 entries = 28 numbers  ->  6-interval subject + 4 starts = 10)
def compressedSubject() -> I64[]:
  shape(subject())
def fibreStarts() -> I64[]:
  [ headOr0(subject()), headOr0(answer()), headOr0(lateEntry()), headOr0(fugueB_voice()) ]

# reconstruct any entry from (subject, its start) — the net runs the transport
def main() -> I64[]:
  fromShape(headOr0(answer()), compressedSubject())
