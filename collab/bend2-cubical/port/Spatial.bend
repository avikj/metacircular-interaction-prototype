# Spatial omics (the SpatialData shape: a molecule field and its
# segmentations), as one ordinary evaluation of the interaction object — the
# second biological finite presentation fed to the calculus unchanged.
# Nothing here is a new construction: the file is the fibre law
# A ≃ Σ b:B. fiber f b (fibrelaw.bend, HoTT 4.8.2) at a segmentation, the
# receiver as a fold over the field (AdiBija), erasure = descent (the set
# quotient's resp obligation) at the quotient that forgets coordinates, and
# univalence (ua, transport computing) at a change of coordinate system —
# each instantiated at a transcript field instead of the rewrite kernel.
#
# THE FINITE PRESENTATION.  A molecule (a detected transcript) is a gene id
# with integer coordinates; a field P is the finite list of molecules — the
# actual object a Xenium run emits, before any image, label or shape layer.
# A segmentation is a function s : Mol -> CellId (the labels layer, read at
# the points); two of them here, by two x-thresholds, disagree on a
# molecule.  The panel is two genes and two cells — the SHAPE of a
# SpatialData object, not its data.  The real points table and the real
# segmentation masks enter by a front-end that emits this file's
# `Mol`/`P0`/`seg1`/`seg2`; the theorems below are stated for the shape and
# hold for any finite panel and any s.
#
#   §1  the presentation: Gene, Mol, the field, CellId, two segmentations
#       that differ on one molecule
#   §2  the fibre law, literally: Mol ≃ Σ c:CellId. fiber(s, c) for every
#       s (totalEquiv, generic in A, B, f), its ua path, transport computes
#       to the factoring; the per-cell view is the first projection —
#       the cell-by-gene matrix is visibly the projection that forgets the
#       molecule-level fibre.  Nothing was lost; it was placed in the fibre.
#   §3  receivers over the field, each a fold: gene count, the cell-by-gene
#       entry, molecules per cell; the total is the sum over cells of the
#       fibre sizes, for EVERY segmentation (induction on P, per-molecule
#       case split with plusSuc)
#   §4  segmentation-invariance = descent: the quotient by "same gene"
#       forgets coordinates and hence every segmentation.  countGene
#       descends (resp inhabited from the gene path); the segmentation and
#       the cell-by-gene entry do not (their resp obligations are REFUTED:
#       two same-gene molecules land in different cells; the bogus attempt
#       is Spatial_mustfail.bend, rejected by the substrate).  A statistic
#       reading only the fibre sizes summed over cells descends by §3 and
#       so is segmentation-invariant for every s1, s2; on the concrete
#       field the invariance is refl and the dependence of the raw entry
#       is a refutation — the fibre holds exactly the information the
#       segmentation-dependent conclusion depends on.
#   §5  change of presentation: a coordinate transform that is an
#       equivalence (swap x, y — an involution) is a PATH Mol = Mol by ua;
#       transport along it computes to the transform and the count is
#       invariant.  Where the transform is not an equivalence
#       (rasterisation to a pixel) there is no path; the fibre law says
#       exactly what the image forgot.
#   §6  main: one cell-by-gene entry of the concrete field.
import SetQuotient

# ---------------------------------------------------------------------------
# §1  The finite presentation.
# ---------------------------------------------------------------------------
type Gene:
  case @gA:
  case @gB:

def geneNum(g: Gene) -> Nat:
  match g:
    case @gA{}: 0n
    case @gB{}: 1n

# a molecule = a transcript of one gene detected at integer coordinates
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

# the field: the points table, a finite list
def Field() -> Set:
  Mol[]

# cell ids (the labels layer's values)
type CellId:
  case @c1:
  case @c2:

def cellNum(c: CellId) -> Nat:
  match c:
    case @c1{}: 0n
    case @c2{}: 1n

# a < b on Nat, structurally
def ltN(a: Nat, b: Nat) -> Bool:
  match b:
    case 0n: False
    case 1n + q:
      match a:
        case 0n: True
        case 1n + p: ltN(p, q)
def pick(b: Bool) -> CellId:
  match b:
    case True: @c1
    case False: @c2

# a segmentation reads the coordinates: x < t is cell 1, else cell 2
def segAt(t: Nat, m: Mol) -> CellId:
  pick(ltN(xOf(m), t))
def seg1(m: Mol) -> CellId:
  segAt(2n, m)
def seg2(m: Mol) -> CellId:
  segAt(3n, m)

# the two segmentations are genuinely different: the molecule at x = 2 is
# cell 2 under seg1 and cell 1 under seg2
def m_edge() -> Mol:
  @mol{@gA, 2n, 1n}
def segs_differ(p: Path(CellId, seg1(m_edge()), seg2(m_edge()))) -> Empty:
  natEncode(1n, 0n, <i> cellNum(p @ i))

# ---------------------------------------------------------------------------
# §2  The fibre law, literally (fibrelaw.bend's totalEquiv, generic in
#     A, B, f), then at Mol / CellId / a segmentation.
# ---------------------------------------------------------------------------
def Total(A: Set, B: Set, f: A -> B) -> Set:
  any b: B. fiber(A, B, f, b)
def total(A: Set, B: Set, f: A -> B, a: A) -> Total(A, B, f):
  (f(a), a, <_> f(a))
def untotal(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> A:
  match w:
    case (b, a, q): a
def total_sec(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> Path(Total(A, B, f), total(A, B, f, untotal(A, B, f, w)), w):
  match w:
    case (b, a, q): <i> (q @ i, a, <j> q @ iand(i, j))
def total_ret(A: Set, B: Set, f: A -> B, a: A) -> Path(A, untotal(A, B, f, total(A, B, f, a)), a):
  <_> a
def totalEquiv(A: Set, B: Set, f: A -> B) -> Equiv(A, Total(A, B, f)):
  isoToEquiv(A, Total(A, B, f), total(A, B, f), untotal(A, B, f), total_sec(A, B, f), total_ret(A, B, f))

# ...and therefore, by univalence, a path in Set; transport along it IS the
# factoring a ↦ (f a, a, refl) (uaβ), and back
def totalPath(A: Set, B: Set, f: A -> B) -> Path(Set, A, Total(A, B, f)):
  ua(A, Total(A, B, f), lambda a. total(A, B, f, a), lambda w. untotal(A, B, f, w),
     lambda a. total_ret(A, B, f, a), lambda w. total_sec(A, B, f, w))
def present(A: Set, B: Set, f: A -> B, a: A) -> Total(A, B, f):
  coe(lambda i. totalPath(A, B, f) @ i, i0, i1, a)
def retrieve(A: Set, B: Set, f: A -> B, w: Total(A, B, f)) -> A:
  coe(lambda i. totalPath(A, B, f) @ i, i1, i0, w)
def present_is_total(A: Set, B: Set, f: A -> B, a: A) -> Path(Total(A, B, f), present(A, B, f, a), total(A, B, f, a)):
  <_> total(A, B, f, a)
def retrieve_present(A: Set, B: Set, f: A -> B, a: A) -> Path(A, retrieve(A, B, f, present(A, B, f, a)), a):
  <_> a

# at a segmentation: the fibre over c is the molecules of cell c (with their
# membership witness); the total space is the field re-indexed by cell
def CellFibre(s: Mol -> CellId, c: CellId) -> Set:
  fiber(Mol, CellId, s, c)
def Segmented(s: Mol -> CellId) -> Set:
  Total(Mol, CellId, s)
def seg_fibre_law(s: Mol -> CellId) -> Equiv(Mol, Segmented(s)):
  totalEquiv(Mol, CellId, s)
def seg_path(s: Mol -> CellId) -> Path(Set, Mol, Segmented(s)):
  totalPath(Mol, CellId, s)
def seg1_fibre_law() -> Equiv(Mol, Segmented(seg1)):
  totalEquiv(Mol, CellId, seg1)
def seg2_fibre_law() -> Equiv(Mol, Segmented(seg2)):
  totalEquiv(Mol, CellId, seg2)

# the per-cell view is the first projection of the total space; the
# molecule is retrieved from the fibre.  The cell-by-gene matrix (§3) reads
# only cellOf and the gene: it is visibly the projection that forgets the
# molecule-level fibre.  Nothing was lost — it was placed in the fibre.
def cellOf(s: Mol -> CellId, w: Segmented(s)) -> CellId:
  match w:
    case (c, m, q): c
def molOf(s: Mol -> CellId, w: Segmented(s)) -> Mol:
  untotal(Mol, CellId, s, w)
def cell_by_gene_is_projection(s: Mol -> CellId, m: Mol) -> Path(CellId, cellOf(s, total(Mol, CellId, s, m)), s(m)):
  <_> s(m)
def nothing_lost(s: Mol -> CellId, m: Mol) -> Path(Mol, molOf(s, present(Mol, CellId, s, m)), m):
  <_> m

# ---------------------------------------------------------------------------
# §3  Receivers over the field: plain folds over the list.
# ---------------------------------------------------------------------------
def sameGene(g: Gene, g2: Gene) -> Bool:
  match g:
    case @gA{}:
      match g2:
        case @gA{}: True
        case @gB{}: False
    case @gB{}:
      match g2:
        case @gA{}: False
        case @gB{}: True
def sameCell(c: CellId, c2: CellId) -> Bool:
  match c:
    case @c1{}:
      match c2:
        case @c1{}: True
        case @c2{}: False
    case @c2{}:
      match c2:
        case @c1{}: False
        case @c2{}: True
def andB(a: Bool, b: Bool) -> Bool:
  match a:
    case True: b
    case False: False
def b2n(b: Bool) -> Nat:
  match b:
    case True: 1n
    case False: 0n

# one molecule's contribution to a gene count / to a cell-by-gene entry,
# written on the gene and the cell it was assigned (variables, so that the
# per-molecule case split of §3–§4 can match them)
def contrib(g: Gene, gm: Gene) -> Nat:
  b2n(sameGene(g, gm))
def contribIn(g: Gene, c: CellId, gm: Gene, cm: CellId) -> Nat:
  b2n(andB(sameGene(g, gm), sameCell(c, cm)))

# (a) the total count of gene g in the field (no segmentation read)
def countGene(g: Gene, P: Mol[]) -> Nat:
  match P:
    case []: 0n
    case m <> rest: add(contrib(g, geneOf(m)), countGene(g, rest))
# (b) the cell-by-gene entry: the size of the fibre of s over c, at gene g
def countGeneInCell(s: Mol -> CellId, g: Gene, c: CellId, P: Mol[]) -> Nat:
  match P:
    case []: 0n
    case m <> rest: add(contribIn(g, c, geneOf(m), s(m)), countGeneInCell(s, g, c, rest))
# the whole matrix, as the function of its two indices
def cellByGene(s: Mol -> CellId, P: Mol[]) -> Gene -> CellId -> Nat:
  lambda g. lambda c. countGeneInCell(s, g, c, P)
# (c) molecules per cell (the fibre size, all genes) and the field size
def molsInCell(s: Mol -> CellId, c: CellId, P: Mol[]) -> Nat:
  match P:
    case []: 0n
    case m <> rest: add(b2n(sameCell(c, s(m))), molsInCell(s, c, rest))
def nMols(P: Mol[]) -> Nat:
  length(Mol, P)

# THE TOTAL IS THE SUM OVER CELLS, for every segmentation: one molecule's
# contribution splits across the two cells (eight cases, each refl or one
# plusSuc), and the field follows by induction.
def cons_split(g: Gene, gm: Gene, cm: CellId, t: Nat, n1: Nat, n2: Nat, ih: Path(Nat, t, add(n1, n2))) -> Path(Nat, add(contrib(g, gm), t), add(add(contribIn(g, @c1, gm, cm), n1), add(contribIn(g, @c2, gm, cm), n2))):
  match g:
    case @gA{}:
      match gm:
        case @gA{}:
          match cm:
            case @c1{}: <i> 1n + (ih @ i)
            case @c2{}: compPath(Nat, 1n + t, 1n + add(n1, n2), add(n1, 1n + n2), <i> 1n + (ih @ i), sym(Nat, add(n1, 1n + n2), 1n + add(n1, n2), plusSuc(n1, n2)))
        case @gB{}: ih
    case @gB{}:
      match gm:
        case @gA{}: ih
        case @gB{}:
          match cm:
            case @c1{}: <i> 1n + (ih @ i)
            case @c2{}: compPath(Nat, 1n + t, 1n + add(n1, n2), add(n1, 1n + n2), <i> 1n + (ih @ i), sym(Nat, add(n1, 1n + n2), 1n + add(n1, n2), plusSuc(n1, n2)))
def total_is_sum_over_cells(s: Mol -> CellId, g: Gene, P: Mol[]) -> Path(Nat, countGene(g, P), add(countGeneInCell(s, g, @c1, P), countGeneInCell(s, g, @c2, P))):
  match P:
    case []: <_> 0n
    case m <> rest:
      cons_split(g, geneOf(m), s(m), countGene(g, rest), countGeneInCell(s, g, @c1, rest), countGeneInCell(s, g, @c2, rest), total_is_sum_over_cells(s, g, rest))

# ---------------------------------------------------------------------------
# §4  Segmentation-invariance = descent.  The quotient of Mol by "same
#     gene" forgets the coordinates, hence every segmentation (each reads
#     only coordinates).  A receiver runs on the erased field iff it
#     factors through the quotient — the recursor's resp obligation.
# ---------------------------------------------------------------------------
def SameGene(m: Mol, m2: Mol) -> Set:
  Path(Gene, geneOf(m), geneOf(m2))
def SameGeneR() -> Mol -> Mol -> Set:
  lambda m. lambda m2. SameGene(m, m2)
def GeneOnly() -> Set:
  Quotient(Mol, SameGeneR())
def erase(m: Mol) -> GeneOnly:
  @cl{m}
def setNat() -> isSet(Nat):
  lambda m. lambda n. lambda p. lambda q. isSetNat(m, n, p, q)

# the gene count descends: its per-molecule contribution reads the gene
# only, and the resp obligation is the gene path itself
def contribOf(g: Gene, m: Mol) -> Nat:
  contrib(g, geneOf(m))
def contrib_descends(g: Gene, m: Mol, m2: Mol, r: SameGene(m, m2)) -> Path(Nat, contribOf(g, m), contribOf(g, m2)):
  <i> contrib(g, r @ i)
def contrib_erased(g: Gene, q: GeneOnly) -> Nat:
  quotRec(Mol, SameGeneR(), Nat, setNat(), lambda m. contribOf(g, m), lambda m. lambda m2. lambda r. contrib_descends(g, m, m2, r), q)
def countGene_erased(g: Gene, Q: GeneOnly[]) -> Nat:
  match Q:
    case []: 0n
    case q <> rest: add(contrib_erased(g, q), countGene_erased(g, rest))
# and it computes on representatives: R = R̄ ∘ q, on the nose, fieldwise
def countGene_descends(g: Gene, P: Mol[]) -> Path(Nat, countGene_erased(g, map(Mol, GeneOnly, erase, P)), countGene(g, P)):
  match P:
    case []: <_> 0n
    case m <> rest: <i> add(contrib(g, geneOf(m)), countGene_descends(g, rest) @ i)

# the segmentation does NOT descend: its resp obligation is refuted by two
# same-gene molecules that seg1 puts in different cells...
def m_left() -> Mol:
  @mol{@gA, 0n, 0n}
def seg1_resp_refuted(resp: all m: Mol. all m2: Mol. all r: SameGene(m, m2). Path(CellId, seg1(m), seg1(m2))) -> Empty:
  natEncode(0n, 1n, <i> cellNum(resp(m_left(), m_edge(), <_> @gA) @ i))
# ...and so the cell-by-gene entry does not either: the same two molecules
# contribute 1 and 0 to the (gA, c1) entry.  (The attempt to write the
# recursor anyway is Spatial_mustfail.bend.)
def cellcount_resp_refuted(resp: all m: Mol. all m2: Mol. all r: SameGene(m, m2). Path(Nat, contribIn(@gA, @c1, geneOf(m), seg1(m)), contribIn(@gA, @c1, geneOf(m2), seg1(m2)))) -> Empty:
  natEncode(1n, 0n, resp(m_left(), m_edge(), <_> @gA))

# the positive side: a statistic that reads only the fibre SIZES per gene,
# summed over the cells, is the gene count by §3 — so it descends, and
# hence agrees on every pair of segmentations, for every field
def statistic(s: Mol -> CellId, g: Gene, P: Mol[]) -> Nat:
  add(countGeneInCell(s, g, @c1, P), countGeneInCell(s, g, @c2, P))
def statistic_erased(g: Gene, Q: GeneOnly[]) -> Nat:
  countGene_erased(g, Q)
def statistic_descends(s: Mol -> CellId, g: Gene, P: Mol[]) -> Path(Nat, statistic_erased(g, map(Mol, GeneOnly, erase, P)), statistic(s, g, P)):
  compPath(Nat, statistic_erased(g, map(Mol, GeneOnly, erase, P)), countGene(g, P), statistic(s, g, P),
    countGene_descends(g, P), total_is_sum_over_cells(s, g, P))
def seg_invariant_general(s1: Mol -> CellId, s2: Mol -> CellId, g: Gene, P: Mol[]) -> Path(Nat, statistic(s1, g, P), statistic(s2, g, P)):
  compPath(Nat, statistic(s1, g, P), countGene(g, P), statistic(s2, g, P),
    sym(Nat, countGene(g, P), statistic(s1, g, P), total_is_sum_over_cells(s1, g, P)),
    total_is_sum_over_cells(s2, g, P))

# the concrete field: five molecules; under seg1 gene gA has (1, 2) across
# the cells, under seg2 (2, 1).  The statistic agrees (refl: 3 = 3); the raw
# (gA, c1) entry does not (1 ≠ 2).  The fibre of s is exactly the
# information on which the segmentation-dependent conclusion depends.
def P0() -> Field:
  [@mol{@gA, 0n, 0n}, @mol{@gA, 2n, 1n}, @mol{@gB, 1n, 3n}, @mol{@gB, 4n, 0n}, @mol{@gA, 3n, 2n}]
def seg_invariant() -> Path(Nat, statistic(seg1, @gA, P0()), statistic(seg2, @gA, P0())):
  <_> 3n
def seg_dependent(p: Path(Nat, countGeneInCell(seg1, @gA, @c1, P0()), countGeneInCell(seg2, @gA, @c1, P0()))) -> Empty:
  natEncode(1n, 2n, p)
def total_gA() -> Path(Nat, countGene(@gA, P0()), 3n):
  <_> 3n

# ---------------------------------------------------------------------------
# §5  Change of presentation.  A coordinate transform that is an
#     equivalence is a path in Set by ua; transport along it computes to
#     the transform (uaβ); a receiver that does not read coordinates is
#     invariant.  Where the transform is not an equivalence (rasterisation)
#     there is no path, and the fibre law says what was lost.
# ---------------------------------------------------------------------------
def swap(m: Mol) -> Mol:
  match m:
    case @mol{g, x, y}: @mol{g, y, x}
def swap_swap(m: Mol) -> Path(Mol, swap(swap(m)), m):
  match m:
    case @mol{g, x, y}: <_> @mol{g, x, y}
def swapPath() -> Path(Set, Mol, Mol):
  ua(Mol, Mol, swap, swap, swap_swap, swap_swap)
def transportSwap(m: Mol) -> Mol:
  coe(lambda i. swapPath() @ i, i0, i1, m)
# transport along the univalent equality IS the transform
def transport_is_swap(m: Mol) -> Path(Mol, transportSwap(m), swap(m)):
  <_> swap(m)
def swap_field(P: Mol[]) -> Mol[]:
  map(Mol, Mol, transportSwap, P)
# the gene count is invariant under the transported field (it reads no
# coordinate); the segmentations are not — they are data in the fibre
def count_swap_invariant(g: Gene, P: Mol[]) -> Path(Nat, countGene(g, swap_field(P)), countGene(g, P)):
  match P:
    case []: <_> 0n
    case m <> rest:
      match m:
        case @mol{h, x, y}: <i> add(contrib(g, h), count_swap_invariant(g, rest) @ i)
def count_swap_P0() -> Path(Nat, countGene(@gA, swap_field(P0())), 3n):
  <_> 3n
# a segmentation in the new coordinates is the old one along the path back:
# its fibre law is the same theorem at s ∘ swap
def seg1_swapped(m: Mol) -> CellId:
  seg1(swap(m))
def seg1_swapped_fibre_law() -> Equiv(Mol, Segmented(seg1_swapped)):
  totalEquiv(Mol, CellId, seg1_swapped)

# rasterisation: the image forgets the gene.  Two molecules land on one
# pixel, so raster has no inverse and there is no path Mol = Pixel — but
# the fibre law still holds for it: Mol ≃ Σ p:Pixel. fiber(raster, p), and
# the fibre over the pixel is exactly what the image lost.
def Pixel() -> Set:
  any x: Nat. Nat
def raster(m: Mol) -> Pixel:
  (xOf(m), yOf(m))
def raster_fibre_law() -> Equiv(Mol, Total(Mol, Pixel, raster)):
  totalEquiv(Mol, Pixel, raster)
def raster_collides() -> Path(Pixel, raster(@mol{@gA, 1n, 1n}), raster(@mol{@gB, 1n, 1n})):
  <_> (1n, 1n)
def raster_forgets(p: Path(Mol, @mol{@gA, 1n, 1n}, @mol{@gB, 1n, 1n})) -> Empty:
  natEncode(0n, 1n, <i> geneNum(geneOf(p @ i)))

# ---------------------------------------------------------------------------
# §6  One cell-by-gene entry of the concrete field, computed.
# ---------------------------------------------------------------------------
def main() -> Nat:
  countGeneInCell(seg1, @gA, @c1, P0())
