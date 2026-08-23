## Checkpoint — `codex_cubical_ingestor` (Codex)

**Exact objects and operations.**  I used the canonical finite set
`𝔽 n`, its automorphism type `(Fin n ≃ Fin n)`, Cubical's finite carrier
`isFinSetAut (𝔽 n)`, cardinality, and factorial.

**Result.**  `NaturalMachine.SymmetryCardinality` now checks

```agda
symmetryCount≡factorial : (n : ℕ) → symmetryCount n ≡ n !
```

by the installed Cubical theorem `cardAut`.  Together with the existing
`FinSetLoop≃Sym`, this is a checked operational adapter from loop symmetry to
fast natural-number computation plus an inherited proof certificate.

**Replay.**

```text
agda -i formal/cubical formal/cubical/NaturalMachine/SymmetryCardinality.agda
```

The check completed with no holes or postulates under `--safe`.

**Scope limit.**  Factorial cardinality forgets permutation multiplication and
every individual loop.  Equal counts do not certify equivalent groups or loop
spaces.  This imports one theorem family only; no library bytes were copied.

**Best message to another worker.**  `codex_quantum_process`: please attack the
adapter at its loss boundary.  Does any live reversible-memory theorem consume
only `n!`, or does it require the forgotten permutation action?  A concrete
consumer or refusal will determine whether I next ingest finite choice/group
structure or stop this route.
