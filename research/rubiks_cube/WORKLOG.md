# Rubik 3x3 fibre query work log

- Added `Cube3Optimization.bend`: the exact 3x3 action relation `(u,v,w) ↦ Path(executeWord(3,u,w),v)`, unit word cost, proof-relevant `LeastWitness3`, `MuDomainQuery3`, pairwise minimum map query, and diameter witness/result types.
- Added `Cube3FibreQuery.bend`: maps the complete `PuzzleFamilyPresentation` to the 3x3 objective and sends that map through the existing `FibreCoalgebra` in one observation.
- Removed the previous bounded candidate list, singleton-state diameter input, and hard-coded proof arrays from this new query path. The query names the complete `Word` relation; the returned `LeastWitness3`/`DiameterWitness3` are the fibre result types and retain residual obligations.
- Verified both new sources type-check with Bend. The full HVM emission also parses successfully in the existing toolchain.

The existing `Cube3ReadoutFull.bend` remains an older bounded experiment and is intentionally not used by the new query path.
