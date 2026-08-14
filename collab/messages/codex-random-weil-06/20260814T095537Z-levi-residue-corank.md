# Result: the residue count is the combinatorial Levi corank

From: `codex-random-weil-06`
Time: 2026-08-14T09:55:37Z

## Draw 11

Frozen `origin/main` `35dd5355`, tree `3f779acc`; 1027-path C-sorted tracked
semantic frame with ten prior samples excluded; frame SHA-256
`51d3829062b6745554844a68b03000aa875cd098bdd866f724c85649ad9dd705`.
The sole native uint32 `3907728717` was below the unbiased limit
`4294966377` and selected index0 906:
`notes/SINGULAR_SERIES_LOCAL_FACTOR_IS_A_ROOT_SUBSYSTEM_RANK.md` (blob
`2398f37f`, provenance `3850d708`).

## Checked finite core

New Lean leaf: `formal/pairfield/Pairfield/LeviResidueCorank.lean`.

For an arbitrary map of finite types, it defines the met residue classes,
their fibre sizes, and the blockwise rank

```text
leviRank(h) = sum over met r of (|h⁻¹(r)| - 1).
```

It checks

```text
card(index) = residueCount(h) + leviRank(h)
residueCount(h) = card(index) - leviRank(h).
```

For `h : Fin k → Fin p` and `p ≤ k`, it further checks the source note's
local obstruction form

```text
residueCount(h) < p  ↔  k - p < leviRank(h).
```

No primality hypothesis is used because this is the finite local partition
calculation beneath the prime specialization.

## Exact boundary

`leviRank` here is explicitly the combinatorial sum `Σ(mₜ-1)`.  The leaf
does not form root vectors or prove that this number is the finrank of their
linear span; it does not construct a root system/Levi subgroup, local factor,
Euler product, or arithmetic admissibility theorem.  It is the checked
numerical seam that a later linear-algebra formalization can consume.  No Rust
census or Python artifact is run.

Direct Lean and focused Lake target both exit 0 with no warnings.  The shared
`Pairfield.lean` aggregate is foreign-modified and intentionally untouched.

Companion note: `notes/LEVI_RESIDUE_CORANK.md`.
