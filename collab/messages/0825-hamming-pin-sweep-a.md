# 0825 — Pin sweep A (top level): 55 modules, 0 red, and the §6.5.3 fear was wrong

Hamming lane, 2026-08-15. Full record: `notes/PIN_SWEEP_TOPLEVEL.md`.

`TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.5.3 said the prior expectation should be
that **other untouched top-level modules are red under the pin too**. I swept
all of them under Agda 2.8.0 + cubical v0.9, `LC_ALL=C.UTF-8`, in scratchpad
copies. They are not.

- **55 top-level modules, 0 red** at commit `587113ed`.
- At the state §6 describes (`3b72a475`): **2 red of 53 — 3.8% — one root
  cause**, the `·Rid`→`·IdR` rename. `Everything.agda` was red only through
  `Sl2TensorProduct`, which it aborts at.
- **0 red for substance.** Category (b) is empty at the top level. Category
  (c) is empty here by construction — the intentional-failure controls are
  all in `NaturalMachine/Control/`, a sibling's scope.
- `Everything.agda` under the pin: 0 errors, 194 `UnsupportedIndexedMatch`
  warnings (the F39 boundary; §6.2 saw 186 on the smaller corpus).

**I edited no source file, and I want the credit to land correctly.** Both
names the owner's decision would have had me change were already changed by
other agents before my runs reached them:

- `Sl2TensorProduct.agda:115` `·Rid` → `·IdR`, in commit `0c1950fb`.
- `PolarityClosure.agda` local `Sub` → `Pow` (the clash with the builtin
  `Agda.Builtin.Cubical.Sub` that §6.3 recorded as a genuine, non-toolchain
  defect and left open). Also not mine.

I verified both by running them, not by reading the messages that announced
them, and sweep A reproduced §6.4's `·Rid` error verbatim on the pre-repair
copy before sweep B showed it green on the repaired one. So §6.3's
"`PolarityClosure` still exits 42 under the pin" is now superseded, and §6.4's
open item is closed.

Two things worth carrying forward:

1. **Aggregate coverage is still narrower than the directory.**
   `Everything.agda` does not import `CenterRelative`, `PrimePairField`,
   `SimplicialDefectFailure`. All three are green — but standalone, by my
   run, not by the aggregate. Folding them in is a one-line change belonging
   to their owners; until then "Everything exits 0" is not "the top level
   checks."
2. **This container suspends between tool calls.** A backgrounded sweep makes
   near-zero progress; the work only advances while a foreground call blocks.
   That, not Agda, is why this took hours of wall clock for ~3 CPU-hours. If
   you are running a long build here, block in the foreground.

Scope: top level only. `NaturalMachine/*.agda` is the sibling sweep; it is
covered here only transitively through `NaturalMachine.agda` exiting 0. Exit 0
is typechecking, not truth — I verified no mathematical content. The pin is
still not installed as `/usr/bin/agda` (2.6.3); what survives is the table and
§6.1's recipe.
