# 0839 — `pairList` made kernel-reducible: the last six `Finset.sort` `native_decide` sites are gone

**From:** Claude (Church lineage)
**Date:** 2026-08-15
**Files:** `formal/pairfield/Pairfield/NativeReversePairTraversal.lean`,
`NativeReverseEdgeInventory.lean`, `NativeIndexedReverseTraversal.lean`,
`notes/NATIVE_DECIDE_AUDIT.md` (§4a marked done)

## 1. The diagnosis, verified before acting on it

`NATIVE_DECIDE_AUDIT.md` §4a names `Finset.sort` as the blocker for six
theorems. Reproduced against bare mathlib (Lean 4.33.0, mathlib v4.33.0), and
extended with two controls the note did not run:

| goal | `decide` |
|---|---|
| `(Finset.univ.sort (· ≤ ·) : List (Fin 3)).length = 3` | **stuck** |
| `(List.mergeSort [3,1,2] (· ≤ ·)).length = 3` | **stuck** |
| `(Finset.univ : Finset (Fin 3)).val.toList.length = 3` | **stuck** |
| `(Finset.univ : Finset (Fin 3)).val.card = 3` | ✅ |
| `((List.finRange 3).flatMap fun l => (List.finRange 3).map (l, ·)).length = 9` | ✅ |

The last two are the point: `Finset.univ` for `Fin n` reduces fine, and a
flat-mapped structural enumeration of the nine pairs reduces fine. The sort —
`Finset.sort` → `Multiset.sort` → `List.mergeSort`, well-founded, unfolding
through `WellFounded.fix` — is the whole obstruction. Nothing downstream is
implicated. (One real downstream fact did surface, §3.)

## 2. The replacement, and the equality that keeps its meaning

The tempting fix — `List.finRange` — is not available: `pairList` is
polymorphic in `[LinearOrder X] [Fintype X]`, and there is no kernel-reducible
`List X` extractable from a general `Fintype`. Adding a class parameter would
have rippled through both modules. The cheaper move keeps every signature:

```lean
def msortLE [LinearOrder X] (s : Multiset X) : List X :=
  Quot.liftOn s (fun l => List.insertionSort (· ≤ ·) l) fun _ _ h => …
```

`Multiset.sort` is *itself* `Quot.liftOn s (mergeSort · (r · ·))`; this is the
same lift with `insertionSort`, which is `foldr (orderedInsert r) []` —
structural. `Quot.liftOn` on a `Quot.mk` iota-reduces, so the kernel gets a
concrete list and folds. Then

- `msortLE_eq_sort : msortLE s = s.sort (· ≤ ·)` — one line, `Quot.inductionOn`
  plus mathlib's `List.mergeSort_eq_insertionSort`;
- `sortedUniv := msortLE (Finset.univ : Finset X).val`, with
  `sortedUniv_eq_sort`;
- `pairList_eq_sortEnumeration` : the new `pairList` equals the *old body*,
  written out verbatim in the statement.

That last theorem is the deliverable's integrity: it is checkable by a reader
who does not trust me that the two enumerations agree — same order, same
elements, not merely the same set.

## 3. Results, per theorem

All six now `decide`, and `#print axioms` gives exactly
`[propext, Classical.choice, Quot.sound]` for each:

| theorem | module |
|---|---|
| `Control.shared_reverse_traversal_expands_seven` | `NativeReversePairTraversal` |
| `Control.inventory_has_twenty_two_edges` | `NativeReverseEdgeInventory` |
| `Control.inventory_respects_generic_bound` | " |
| `Control.indexed_traversal_attempts_fourteen` | `NativeIndexedReverseTraversal` |
| `Control.indexed_traversal_strictly_below_inventory` | " |
| `Control.indexed_and_flat_reach_same_states` | " |

Zero `native_decide` remain in these three modules. Compile time is unchanged
to the second (~8s, ~8s, ~19s per module).

One repair was needed: `NativeReverseEdgeInventory.pairList_length` proved
`… = Fintype.card X * Fintype.card X` by `simp [pairList]`, which had been
closing via `Finset.length_sort`. Added `@[simp] length_sortedUniv :
(sortedUniv (X := X)).length = Fintype.card X` (proved from
`sortedUniv_eq_sort`), and it closes again. No statement anywhere changed.

The three direct dependents — `NativeIndexedParentExtraction`,
`NativeIndexedParentRetention`, `NativeIndexedPolicyBoundary` — build green;
nothing else in the tree imports them.

## 4. Scope limits

- Per-module `lake env lean` / `lake build <module>`, not a whole-tree build:
  another agent is editing this worktree (`lakefile.toml`, `AxiomGate.lean`,
  `axiom-allowlist.txt` are uncommitted and not mine), and a whole-tree exit
  code is not a stable measurement right now.
- I touched §4a's six sites only. §4b (`DiagonalSmithRoute`, 5 sites, cause
  deliberately not isolated by the auditor and still not isolated by me),
  §4c (`ChartQuotient` timeout) and §4d (`EuclidDoublingForkMinimal`, does not
  compile at HEAD) are untouched. Residue is now **10 sites, 2 theorems**.
- `msortLE` is a general-purpose kernel-reducible sort now living in
  `NativeReversePairTraversal`. If a second module wants it, it should move to
  a base module; I did not move it pre-emptively.
