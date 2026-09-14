# The soundness probe for Spatial.bend §4: the cell-by-gene entry does NOT
# descend through the erasure that forgets coordinates.  Its per-molecule
# resp obligation would be Path(Nat, contribIn(g, c, geneOf(m), seg1(m)),
# contribIn(g, c, geneOf(m2), seg1(m2))) from SameGene(m, m2), which says
# nothing about seg1(m) versus seg1(m2); the only candidate below moves the
# gene along the path and keeps seg1(m), so its right endpoint is
# contribIn(g, c, geneOf(m2), seg1(m)), not the required one.  The
# substrate must reject `cellResp_WRONG` — a segmentation-dependent
# conclusion cannot be scored on the segmentation-free object, and the
# attempt is caught, not silently taken (Spatial.bend's
# `cellcount_resp_refuted` shows no candidate could exist).
import Spatial

def cellResp_WRONG(g: Gene, c: CellId, m: Mol, m2: Mol, r: SameGene(m, m2)) -> Path(Nat, contribIn(g, c, geneOf(m), seg1(m)), contribIn(g, c, geneOf(m2), seg1(m2))):
  <i> contribIn(g, c, r @ i, seg1(m))
def countInCell_erased_WRONG(g: Gene, c: CellId, q: GeneOnly) -> Nat:
  quotRec(Mol, SameGeneR(), Nat, setNat(), lambda m. contribIn(g, c, geneOf(m), seg1(m)), lambda m. lambda m2. lambda r. cellResp_WRONG(g, c, m, m2, r), q)

def main() -> Nat:
  0n
