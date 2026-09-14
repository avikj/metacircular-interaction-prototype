# Segmentation.bend — the spatial molecule field, second presentation of the SAME
# machine.  A transcript point field P; a segmentation s : P -> C.  Nothing is
# chosen: the fibre law gives P ≃ Σ (c : C). fib_s(c) for every s, the cell-by-gene
# matrix is a count of that fibre, and each downstream reading either descends
# through s (segmentation-invariant biology) or is refused (biology that depends
# on the unresolved molecule-to-cell assignment).  Two segmentations of one field
# are two presentations, and moving between them is transport, residue included.
#
# HONEST SCOPE: a toy field (six transcripts on an integer grid) and two toy
# segmentations (bands in x, bands in y).  The constructions are Descent.bend's,
# unchanged from the perturbation file.
import Descent

type Mol:
  case @mol:
    gene: Nat
    x: Nat
    y: Nat

def geneOf(m: Mol) -> Nat:
  match m:
    case @mol{g, x, y}: g

# bands of width three: a cell is a band
def band(n: Nat) -> Nat:
  match n:
    case 0n: 0n
    case 1n + p:
      match p:
        case 0n: 0n
        case 1n + q:
          match q:
            case 0n: 0n
            case 1n + r: 1n + band(r)

# two segmentations of one field
def s1(m: Mol) -> Nat:
  match m:
    case @mol{g, x, y}: band(x)
def s2(m: Mol) -> Nat:
  match m:
    case @mol{g, x, y}: band(y)

def Rs1(a: Mol, b: Mol) -> Set:
  Path(Nat, s1(a), s1(b))
def Rs2(a: Mol, b: Mol) -> Set:
  Path(Nat, s2(a), s2(b))
def C1() -> Set:
  Quotient(Mol, lambda a. lambda b. Rs1(a, b))
def C2() -> Set:
  Quotient(Mol, lambda a. lambda b. Rs2(a, b))
def q1(m: Mol) -> C1:
  @cl{m}
def q2(m: Mol) -> C2:
  @cl{m}

# ---- the fibre law, twice: P ≃ Σ (c : C_i). fib(c)
def field_by_s1() -> Equiv(Mol, Total(Mol, C1, lambda m. q1(m))):
  totalEquiv(Mol, C1, lambda m. q1(m))
def field_by_s2() -> Equiv(Mol, Total(Mol, C2, lambda m. q2(m))):
  totalEquiv(Mol, C2, lambda m. q2(m))
# re-segmentation is transport: back along one law, forward along the other,
# and it computes on the nose (ua β both ways) — the residue rides along
def reseg(w: Total(Mol, C1, lambda m. q1(m))) -> Total(Mol, C2, lambda m. q2(m)):
  coe(lambda i. totalPath(Mol, C2, lambda m. q2(m)) @ i, i0, i1,
      coe(lambda i. totalPath(Mol, C1, lambda m. q1(m)) @ i, i1, i0, w))
def reseg_computes(m: Mol) -> Path(Total(Mol, C2, lambda m2. q2(m2)), reseg(total_to(Mol, C1, lambda m2. q1(m2), m)), total_to(Mol, C2, lambda m2. q2(m2), m)):
  <_> total_to(Mol, C2, lambda m2. q2(m2), m)

# ---- readings, classified by descent
# the gene of a transcript does NOT descend through a segmentation: a cell holds
# transcripts of several genes (so "cell-level expression" is a count of the
# fibre, never a reading of the class)
def ma() -> Mol:
  @mol{0n, 0n, 0n}
def mb() -> Mol:
  @mol{1n, 1n, 0n}
def gene_not_through_s1(d: Descends(Mol, lambda a. lambda b. Rs1(a, b), Nat, lambda m. geneOf(m))) -> Empty:
  refuse(Mol, lambda a. lambda b. Rs1(a, b), lambda m. geneOf(m), ma(), mb(), <_> 0n, lambda e. e, d)
def gene_not_through_s2(d: Descends(Mol, lambda a. lambda b. Rs2(a, b), Nat, lambda m. geneOf(m))) -> Empty:
  refuse(Mol, lambda a. lambda b. Rs2(a, b), lambda m. geneOf(m), ma(), mb(), <_> 0n, lambda e. e, d)
# a region label coarser than s1 descends through s1...
def coarse(c: Nat) -> Nat:
  match c:
    case 0n: 0n
    case 1n + p:
      match p:
        case 0n: 0n
        case 1n + q: 1n + coarse(q)
def region1(m: Mol) -> Nat:
  coarse(s1(m))
def region1_through_s1() -> Descends(Mol, lambda a. lambda b. Rs1(a, b), Nat, lambda m. region1(m)):
  lambda a. lambda b. lambda r. <i> coarse(r @ i)
def region1_on_C1(c: C1) -> Nat:
  erase(Mol, lambda a. lambda b. Rs1(a, b), Nat, lambda m. lambda n. lambda p. lambda q. isSetNat(m, n, p, q), lambda m. region1(m), region1_through_s1(), c)
# ...and is refused by s2: it depends on the assignment s2 does not make
def mc() -> Mol:
  @mol{0n, 0n, 0n}
def md() -> Mol:
  @mol{0n, 6n, 0n}
def region1_not_through_s2(d: Descends(Mol, lambda a. lambda b. Rs2(a, b), Nat, lambda m. region1(m))) -> Empty:
  refuse(Mol, lambda a. lambda b. Rs2(a, b), lambda m. region1(m), mc(), md(), <_> 0n, lambda e. e, d)

# ---- the residue exhibited: the fibre over a cell holds distinct transcripts
def fib_a() -> fiber(Mol, C1, lambda m. q1(m), q1(ma())):
  (ma(), <_> q1(ma()))
def fib_b() -> fiber(Mol, C1, lambda m. q1(m), q1(ma())):
  (mb(), @eq{mb(), ma(), <_> 0n})
def ma_mb_distinct(p: Path(Mol, ma(), mb())) -> Empty:
  natEncode(0n, 1n, <i> geneOf(p @ i))
def fibre_holds_two(p: Path(fiber(Mol, C1, lambda m. q1(m), q1(ma())), fib_a(), fib_b())) -> Empty:
  ma_mb_distinct(<i> fst(Mol, lambda m. Path(C1, q1(m), q1(ma())), p @ i))

# ---- the cell-by-gene matrix is a count of the fibre; on one concrete field the
#      tissue total per gene is the same under both segmentations, the per-cell
#      entries are not
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
def andb(a: Bool, b: Bool) -> Bool:
  match a:
    case True: b
    case False: False
def countIf(f: Mol -> Bool, ms: Mol[]) -> Nat:
  match ms:
    case []: 0n
    case m <> rest:
      match f(m):
        case True: 1n + countIf(f, rest)
        case False: countIf(f, rest)
def cellByGene(s: Mol -> Nat, c: Nat, g: Nat, ms: Mol[]) -> Nat:
  countIf(lambda m. andb(natEqb(s(m), c), natEqb(geneOf(m), g)), ms)
def field() -> Mol[]:
  [@mol{0n, 0n, 0n}, @mol{1n, 1n, 0n}, @mol{0n, 4n, 1n}, @mol{1n, 5n, 4n}, @mol{0n, 5n, 5n}, @mol{1n, 4n, 4n}]
# gene 0: under s1 the two x-bands hold (1, 2); under s2 the two y-bands hold (2, 1)
def s1_gene0() -> Path(Nat, cellByGene(lambda m. s1(m), 0n, 0n, field()), 1n):
  <_> 1n
def s2_gene0() -> Path(Nat, cellByGene(lambda m. s2(m), 0n, 0n, field()), 2n):
  <_> 2n
def per_cell_depends_on_segmentation(p: Path(Nat, cellByGene(lambda m. s1(m), 0n, 0n, field()), cellByGene(lambda m. s2(m), 0n, 0n, field()))) -> Empty:
  natEncode(1n, 2n, p)
def tissue_total_invariant() -> Path(Nat, add(cellByGene(lambda m. s1(m), 0n, 0n, field()), cellByGene(lambda m. s1(m), 1n, 0n, field())), add(cellByGene(lambda m. s2(m), 0n, 0n, field()), cellByGene(lambda m. s2(m), 1n, 0n, field()))):
  <_> 3n

def main() -> Nat:
  cellByGene(lambda m. s1(m), 0n, 0n, field())
