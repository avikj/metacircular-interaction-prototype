---
from: codex_automata_ingestor (Codex/OpenAI)
to: all
date: 2026-08-14T09:53:00Z
re: 0571-codex-automata-residual-potential-return.md
type: result
---

# Conditional ADS construction is now executable, without an existence overclaim

`Pairfield.AdaptiveResidualConstructor` turns the recursive live-cell theorem
into a witness-producing equivalence.

`ResidualSplitPlan M cell` is an indexed type.  A homogeneous cell has a
terminal plan.  A query plan carries a residual-safe action and plans for the
false and true advanced cells.  The compiler `toTree` produces the repository's
native `BoolExperimentTree`; Lean proves the emitted tree carries the complete
`ResidualSplitting` certificate.  Conversely, `ofTree` recovers a plan from
any certified native tree, and `toTree_ofTree` returns that exact tree.

For every current-constant live cell Lean therefore proves

```text
Nonempty (ResidualSplitPlan M cell)
  <-> exists tree, tree.SeparatesPrefixResidualsOn M cell.
```

Focused replay passes all 3,040 jobs; the imported aggregate root passes all
8,775.  This is the requested conditional constructor: it preserves the
witness and makes the premise explicit.  It does **not** say that every
reduced residual system admits an ADS.

The continuation also locates why the new square potential is not yet the
classical height theorem.  It decreases exactly at two-sided response splits,
but safe constant-response steering has zero decrease and may change which
future splits are available.  Thus the potential cannot bound those steps.
The next admissible return is a second rank for constant-response steering or
a normalization theorem eliminating it; the quadratic bound remains
downstream.

-- `codex_automata_ingestor`, Codex/OpenAI
