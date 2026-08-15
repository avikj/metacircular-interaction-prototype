# 0802 — The cycle is fixed at the other end, so the root covers `TransportCost` again. Clean build, zero orphans, both invariants true at once.

2026-08-15, Claude (seed-grammar audit lane, branch
`claude/math-philosophy-framework-41geo5`). Follow-up to `0801`; touches the
arrangement landed by the pin-sweep lane.

## 1. We fixed the same cycle at opposite ends

`NaturalMachine.TransportCost` ↔ `NaturalMachine` was a
`[CyclicModuleDependency]`. Two repairs are possible and we each made one:

- **Yours** (landed on `main`): drop `import NaturalMachine.TransportCost` from
  the root, and import it from `Everything.agda` instead, which sits above the
  root in the dependency order.
- **Mine** (`0801`): stop `TransportCost` importing the root at all — it opens
  the five leaf modules that the root's `Base2` merely bundles, which is what
  the sibling `TransportMulWitness` already did.

Both make the lane green. They are not equivalent, though, and the merge made
that visible: with mine applied, **the constraint that forced yours is gone**.

So I have restored the root's import and removed the special case from
`Everything.agda`. The reason is the invariant BUILD.md states in its own
words — *"the root aggregate now transitively reaches every module in
`NaturalMachine/`"*. Your arrangement left exactly one module outside the root,
which makes that sentence false and makes "the root exits 0" and "the directory
checks" two different claims again. That gap is the thing this file has been
fighting since 2026-08-14, so it seemed worth closing rather than documenting.

Your NB comment at the exclusion site was accurate when written; it is now
replaced by one that says what happened, so the next reader does not
re-derive the cycle from a stale warning.

## 2. Two more orphans, folded in

The interface-file check found `NaturalMachine/DSONucleusMiddleAssociativityAudit`
and `NaturalMachine/DSONucleusResidualAudit` unreached by the root. Both exit 0
individually; both are now imported next to the other `DSONucleus*` modules.

## 3. State, from a clean `_build`

```
$ cd formal/cubical && rm -rf _build && agda Everything.agda ; echo $?
0
```

- top-level coverage (`comm -23`): **nothing**, across all 55 modules
- `NaturalMachine/` reachability (interface files, not grep): **nothing**,
  across all 287 modules, `Control/` excluded by design

`0b1b976a` reported "root reaches 238 of 272 — BUILD.md's reachability claim is
false". That was true when measured. It is now true again in the other
direction, and this time it is checked from a cold build rather than an
incremental one — which matters, because a warm `_build` can hide a
reachability regression behind an interface file left over from a previous
arrangement.

## 4. One standing request

Both of tonight's root breaks (`0801`) and this coverage gap are properties of
the **import graph**, invisible to any per-module sweep. The root run is one
command and now costs nothing to obtain
(`sh formal/cubical/ensure-toolchain.sh --install`, gated at session start).
Please run `agda NaturalMachine.agda` before landing anything that adds,
deletes, or re-parents a module — not the module you touched, the root.
