# "All the fugue entries passed to it SIMULTANEOUSLY."  The entries are handed
# in as one superposition &0{...}. `shape` (the elucidator) commutes over the
# superposition â” the whole set is factored in a single parallel pass â” and the
# entries that are the same subject transported produce the SAME shape, which the
# net shares by DUP-SUP annihilation (the fibre discriminator). Common subject
# material across the corpus collapses to one class, automatically, at once.

def mapI(f: I64 -> I64, xs: I64[]) -> I64[]:
  ~ xs { []: [] ; <>: lambda h. lambda t. f(h) <> mapI(f, t) ; }
def transpose(k: I64, m: I64[]) -> I64[]:
  mapI(lambda p. p + k, m)
def headOr0(m: I64[]) -> I64:
  ~ m { []: +0 ; <>: lambda h. lambda t. h ; }
def tailOr(m: I64[]) -> I64[]:
  ~ m { []: [] ; <>: lambda h. lambda t. t ; }
def shapeFrom(prev: I64, xs: I64[]) -> I64[]:
  ~ xs { []: [] ; <>: lambda h. lambda t. (h - prev) <> shapeFrom(h, t) ; }
def shape(m: I64[]) -> I64[]:
  shapeFrom(headOr0(m), tailOr(m))

def subject() -> I64[]:
  [+0, +2, +4, +5, +4, +2, +0]

# four fugal entries â” subject, dominant answer, octave entry, cross-fugue
# quotation â” every one the subject transported, elucidated simultaneously into
# one superposition. On the net the equal results annihilate (DUP-SUP): the whole
# corpus's shared subject is a single shared node.
def factorAll() -> &0{I64[], &0{I64[], &0{I64[], I64[]}}}:
  &0{ shape(subject()),
      &0{ shape(transpose(+7, subject())),
          &0{ shape(transpose(+12, subject())),
              shape(transpose(-5, subject())) } } }

# proof that the simultaneous pass factors EVERY entry to the one subject shape:
# the whole superposition collapses to &0{S,&0{S,&0{S,S}}} with S = shape(subject).
def allCollapseToSubject()
  -> Path(&0{I64[], &0{I64[], &0{I64[], I64[]}}},
          factorAll(),
          &0{ shape(subject()),
              &0{ shape(subject()),
                  &0{ shape(subject()), shape(subject()) } } }):
  <_> &0{ shape(subject()),
          &0{ shape(subject()),
              &0{ shape(subject()), shape(subject()) } } }

def main() -> &0{I64[], &0{I64[], &0{I64[], I64[]}}}:
  factorAll()
