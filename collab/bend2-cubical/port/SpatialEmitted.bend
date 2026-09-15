# EMITTED by scripts/emit-spatial.py — do not edit; edit the table / rules.
# 8 molecules, genes ['GENE_A', 'GENE_B'], segmentations ['seg1', 'seg2'] over 3 cells
import SetQuotient

# §1 the presentation
type Gene:
  case @gene_a:
  case @gene_b:
type CellId:
  case @c0:
  case @c1:
  case @c2:
type Mol:
  case @mol:
    gene: Gene
    x: Nat
    y: Nat
def geneOf(m: Mol) -> Gene:
  match m: case @mol{g, x, y}: g
def xOf(m: Mol) -> Nat:
  match m: case @mol{g, x, y}: x
def yOf(m: Mol) -> Nat:
  match m: case @mol{g, x, y}: y
def ltN(a: Nat, b: Nat) -> Bool:
  match b:
    case 0n: False
    case 1n + q:
      match a:
        case 0n: True
        case 1n + p: ltN(p, q)
def P0() -> Mol[]:
  [@mol{@gene_a, 1n, 1n}, @mol{@gene_a, 2n, 1n}, @mol{@gene_b, 3n, 2n}, @mol{@gene_a, 5n, 2n}, @mol{@gene_b, 6n, 1n}, @mol{@gene_b, 7n, 3n}, @mol{@gene_a, 9n, 1n}, @mol{@gene_a, 10n, 2n}]
def seg1(m: Mol) -> CellId:
  match ltN(xOf(m), 4n):
    case True: @c0
    case False:
      match ltN(xOf(m), 8n):
        case True: @c1
        case False:
          @c2
def seg2(m: Mol) -> CellId:
  match ltN(xOf(m), 6n):
    case True: @c0
    case False:
      match ltN(xOf(m), 8n):
        case True: @c1
        case False:
          @c2

# §2 the fibre law at a segmentation (fibrelaw.bend, generic)
def Total(A: Set, B: Set, f: A -> B) -> Set:
  any b: B. fiber(A, B, f, b)
def tot(A: Set, B: Set, f: A -> B, a: A) -> Total(A, B, f):
  (f(a), a, <_> f(a))
def untot(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> A:
  match w:
    case (b, a, q):
      a
def tot_sec(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> Path(Total(A, B, f), tot(A, B, f, untot(A, B, f, w)), w):
  match w:
    case (b, a, q):
      <i> (q @ i, a, <j> q @ iand(i, j))
def tot_ret(A: Set, B: Set, f: A -> B, a: A) -> Path(A, untot(A, B, f, tot(A, B, f, a)), a):
  <_> a
def totalEquiv(A: Set, B: Set, f: A -> B) -> Equiv(A, Total(A, B, f)):
  isoToEquiv(A, Total(A, B, f), tot(A, B, f), untot(A, B, f), tot_sec(A, B, f), tot_ret(A, B, f))
# the molecules ARE the sum over cells of seg1's fibres; the cell view is the projection
def lossless_seg1() -> Equiv(Mol, Total(Mol, CellId, seg1)):
  totalEquiv(Mol, CellId, seg1)
# the molecules ARE the sum over cells of seg2's fibres; the cell view is the projection
def lossless_seg2() -> Equiv(Mol, Total(Mol, CellId, seg2)):
  totalEquiv(Mol, CellId, seg2)

# §3 receivers as folds over the field
def sameGene(g: Gene, g2: Gene) -> Bool:
  match g:
    case @gene_a{}:
      match g2:
        case @gene_a{}: True
        case @gene_b{}: False
    case @gene_b{}:
      match g2:
        case @gene_a{}: False
        case @gene_b{}: True
def sameCell(c: CellId, c2: CellId) -> Bool:
  match c:
    case @c0{}:
      match c2:
        case @c0{}: True
        case @c1{}: False
        case @c2{}: False
    case @c1{}:
      match c2:
        case @c0{}: False
        case @c1{}: True
        case @c2{}: False
    case @c2{}:
      match c2:
        case @c0{}: False
        case @c1{}: False
        case @c2{}: True
def andB(a: Bool, b: Bool) -> Bool:
  match a:
    case True: b
    case False: False
def tick(b: Bool, n: Nat) -> Nat:
  match b:
    case True: 1n + n
    case False: n
def countGene(g: Gene, P: Mol[]) -> Nat:
  match P:
    case []: 0n
    case m <> rest: tick(sameGene(g, geneOf(m)), countGene(g, rest))
def countInCell(s: Mol -> CellId, g: Gene, c: CellId, P: Mol[]) -> Nat:
  match P:
    case []: 0n
    case m <> rest: tick(andB(sameGene(g, geneOf(m)), sameCell(c, s(m))), countInCell(s, g, c, rest))

# §4 the cell-by-gene matrices, as the emitter computes them, certified by refl
def cbg_seg1_gene_a_c0() -> Path(Nat, countInCell(seg1, @gene_a, @c0, P0()), 2n):
  <_> 2n
def cbg_seg1_gene_a_c1() -> Path(Nat, countInCell(seg1, @gene_a, @c1, P0()), 1n):
  <_> 1n
def cbg_seg1_gene_a_c2() -> Path(Nat, countInCell(seg1, @gene_a, @c2, P0()), 2n):
  <_> 2n
def cbg_seg1_gene_b_c0() -> Path(Nat, countInCell(seg1, @gene_b, @c0, P0()), 1n):
  <_> 1n
def cbg_seg1_gene_b_c1() -> Path(Nat, countInCell(seg1, @gene_b, @c1, P0()), 2n):
  <_> 2n
def cbg_seg1_gene_b_c2() -> Path(Nat, countInCell(seg1, @gene_b, @c2, P0()), 0n):
  <_> 0n
def cbg_seg2_gene_a_c0() -> Path(Nat, countInCell(seg2, @gene_a, @c0, P0()), 3n):
  <_> 3n
def cbg_seg2_gene_a_c1() -> Path(Nat, countInCell(seg2, @gene_a, @c1, P0()), 0n):
  <_> 0n
def cbg_seg2_gene_a_c2() -> Path(Nat, countInCell(seg2, @gene_a, @c2, P0()), 2n):
  <_> 2n
def cbg_seg2_gene_b_c0() -> Path(Nat, countInCell(seg2, @gene_b, @c0, P0()), 1n):
  <_> 1n
def cbg_seg2_gene_b_c1() -> Path(Nat, countInCell(seg2, @gene_b, @c1, P0()), 2n):
  <_> 2n
def cbg_seg2_gene_b_c2() -> Path(Nat, countInCell(seg2, @gene_b, @c2, P0()), 0n):
  <_> 0n
def total_gene_a() -> Path(Nat, countGene(@gene_a, P0()), 5n):
  <_> 5n
def total_gene_b() -> Path(Nat, countGene(@gene_b, P0()), 3n):
  <_> 3n

# §5 erasure = descent: the quotient forgetting coordinates
def SameGene(m: Mol, m2: Mol) -> Set:
  Path(Gene, geneOf(m), geneOf(m2))
def SameGeneR() -> Mol -> Mol -> Set:
  lambda m. lambda m2. SameGene(m, m2)
def GeneOnly() -> Set:
  Quotient(Mol, SameGeneR())
def setNat() -> isSet(Nat):
  lambda m. lambda n. lambda p. lambda q. isSetNat(m, n, p, q)
# the per-molecule gene contribution descends (it reads the gene only)
def contrib(g: Gene, m: Mol) -> Nat:
  tick(sameGene(g, geneOf(m)), 0n)
def contrib_descends(g: Gene, m: Mol, m2: Mol, r: SameGene(m, m2)) -> Path(Nat, contrib(g, m), contrib(g, m2)):
  <i> tick(sameGene(g, r @ i), 0n)
def contrib_erased(g: Gene, q: GeneOnly) -> Nat:
  quotRec(Mol, SameGeneR(), Nat, setNat(), lambda m. contrib(g, m), lambda m. lambda m2. lambda r. contrib_descends(g, m, m2, r), q)
def cellNum(c: CellId) -> Nat:
  match c:
    case @c0{}: 0n
    case @c1{}: 1n
    case @c2{}: 2n
# seg1: the cell assignment does not descend — two GENE_A molecules land in cells 0 and 1
def seg1_not_descending(h: all m: Mol. all m2: Mol. SameGene(m, m2) -> Path(CellId, seg1(m), seg1(m2))) -> Empty:
  natEncode(0n, 1n, <i> cellNum(h(@mol{@gene_a, 1n, 1n}, @mol{@gene_a, 5n, 2n}, <_> @gene_a) @ i))
# seg2: the cell assignment does not descend — two GENE_A molecules land in cells 0 and 2
def seg2_not_descending(h: all m: Mol. all m2: Mol. SameGene(m, m2) -> Path(CellId, seg2(m), seg2(m2))) -> Empty:
  natEncode(0n, 2n, <i> cellNum(h(@mol{@gene_a, 1n, 1n}, @mol{@gene_a, 9n, 1n}, <_> @gene_a) @ i))

# §6 segmentation dependence and invariance, on this field
def seg_dependent_gene_a_c0(p: Path(Nat, countInCell(seg1, @gene_a, @c0, P0()), countInCell(seg2, @gene_a, @c0, P0()))) -> Empty:
  natEncode(2n, 3n, p)
def seg_invariant_gene_b() -> Path(Nat[], [countInCell(seg1, @gene_b, @c0, P0()), countInCell(seg1, @gene_b, @c1, P0()), countInCell(seg1, @gene_b, @c2, P0())], [countInCell(seg2, @gene_b, @c0, P0()), countInCell(seg2, @gene_b, @c1, P0()), countInCell(seg2, @gene_b, @c2, P0())]):
  <_> [1n, 2n, 0n]

def main() -> Nat:
  countInCell(seg1, @gene_a, @c0, P0())
