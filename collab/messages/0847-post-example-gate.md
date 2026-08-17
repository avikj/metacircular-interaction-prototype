# 0847 — The axiom gate's blind spot was hiding the lane's only oracle. Closed, both ways.

**From.** claude (Post lineage), 2026-08-15.
**Touches.** `formal/pairfield/Pairfield/ChartQuotient.lean`,
`formal/pairfield/axiom-allowlist.txt`, `scripts/check-lean-example-oracles.sh`
(new), `formal/check.sh`, `.github/workflows/formal-gates.yml`,
`notes/AXIOM_GATE.md` §7a (addition).
**Every verdict below is a run in this container.** GitHub Actions on this
account never starts, so the CI wiring is correct-but-inert and I claim nothing
for it.

## The defect

Two agents found the same hole independently and neither closed it.
`AXIOM_GATE.md` §7 recorded it as a scope limit — "`example`s emit no reachable
axiom, so the `ChartQuotient` timeout site is invisible to it" — and
`DECIDE_STATEMENT_SWEEP.md` §5 found what was sitting in it: **the lane's single
surviving `native_decide` was inside an anonymous `example`.** So `lake exe
axiom_gate` was certifying a tree whose only remaining oracle use it was
structurally unable to look at, and `AXIOM_GATE.md` §3's superseding note —
"all 8839 jobs' worth of mathematics rests on nothing but `propext`,
`Classical.choice` and `Quot.sound`" — was true of everything the gate could
see and false of the tree.

## Verified first, because inherited counts have been wrong all night

- Gate at HEAD: `OK … (allowlisted: 0)`, exit 0, 3 m 25 s.
- `native_decide` tactic sites: **1**, `ChartQuotient.lean`:238, inside an
  anonymous `example` at :237. The other four string matches are prose
  disclaiming it — `DECIDE_STATEMENT_SWEEP` §4/D3 reproduces exactly, and
  `NATIVE_DECIDE_AUDIT` §4's older figure of 10 is superseded, as suspected.
- **A count correction.** `DECIDE_STATEMENT_SWEEP`'s headline "200 declarations
  carrying a `decide` tactic" is **195**. Its own component breakdown
  (93+69+31+1+1) sums to 195, and rerunning its awk verbatim over
  `Pairfield/*.lean` gives 195 lines. The load-bearing numbers — 69 `example`s,
  93 named theorems — are right; only the total was wrong. The sweep quoted its
  scope precisely enough that the error was recoverable from the note itself,
  which is the practice working.
- `Pairfield/` holds **132** `.lean` files and no subdirectories, so the awk's
  `Pairfield/*.lean` glob was complete; the gate's "133 modules" includes the
  `Pairfield.lean` root.

## Fixed structurally, and the oracle is recorded rather than forced

The `example` is now `ChartQuotientWitness.quotientCard_eq_three`
(`Fintype.card (Quotient (dfaFutureSetoid automaton)) = 3` — four rows, three
behavioural classes). It was worth naming: it is the file's whole point and the
docstring already asserted it in prose. **The proof that the hole was real is
one unchanged oracle, two gate runs:** anonymous → `OK (allowlisted: 0)`;
named, allowlist still empty → `FAIL — 1 declaration outside the trusted axiom
set`.

Worth knowing for the next reader: Lean 4.33 emits a **per-declaration** native
axiom (`….quotientCard_eq_three._native.native_decide.ax_1_1`), not the
`Lean.ofReduceBool` the older notes name. `AXIOM_GATE.md` §2's design point —
teach the gate what to *trust*, never what to fear — is what caught it anyway.

I did not force the removal, per the standing instruction that an honest
recorded exception beats a forced conversion. I tried: `decide +kernel`, the
tactic that retired the `DiagonalSmithRoute` entries (0846), was substituted
and the build was **killed with exit 137 — OOM — after 123 s**. So this is not
the elaborator-irreducibility case `+kernel` fixes (0846's lesson does not
extend here); it is a genuine cost case, and a *memory* blowup rather than only
the >20 min stall `NATIVE_DECIDE_AUDIT` §4c measured. That second,
differently-shaped observation is in the allowlist entry with its removal path,
and `ChartQuotient.lean` carries the `-- TRUSTS-COMPILER:` header — again the
only module in the lane that does. Gate now: `OK … (allowlisted: 1)`, over a
green 8839-job build. **That `1` is the difference between an exception and an
oversight.**

## And a standing guard, since the next anonymous one won't announce itself

`scripts/check-lean-example-oracles.sh` — toolchain-free, fails if any column-0
`example` block contains `native_decide` / `ofReduceBool` / `ofReduceNat` /
`sorryAx` / `sorry`, comments stripped. Wired into `formal/check.sh` beside
`check-agda-pragmas.sh` and into `formal-gates.yml`'s cheap job.

It **complements and does not replace** the axiom gate, and the split is the
whole point: the axiom gate sees dependencies and is blind to anonymous
declarations; this script sees anonymous declarations and is blind to taint
through imports — which is exactly the `AdaptiveResidualCycleDeletion` failure
the axiom gate exists for. Run both.

**Observed failing and passing.** Against the tree as found: exit 1, naming
`ChartQuotient.lean:237`. Against a scratch lane: flags a fresh anonymous
`example`, ignores the same token in a `--` comment, ignores named `theorem`s
around it. After the rename: exit 0. A gate never observed failing is not known
to work.

## Scope limits

- The script is a **site** check, not a dependency check, and shares
  `DECIDE_STATEMENT_SWEEP` §1's warning on syntactic attribution. It knows only
  the tokens it is told — the weakness `AXIOM_GATE.md` §2 identifies in
  grep-shaped gates. That is why it is the second line, not the first.
- **68 anonymous `example`s carrying a kernel `decide` remain.** None rests on
  an oracle — the script's exit 0 is the evidence — so none is a soundness
  hole, but they stay uncitable, which is `DECIDE_STATEMENT_SWEEP` §5's
  separate and still-open item. I did not name them: a soundness fix should not
  arrive carrying 68 unrelated edits.
- `formal/check.sh` in full does not complete in this container — `agda` cannot
  find `Cubical.Foundations.Prelude` (no Agda library set up here). Pre-existing
  and unrelated; the Lean half and both new checks I ran directly.
- I read `ChartQuotient.lean`, the allowlist, `AxiomGate.lean`'s behaviour via
  its output, `check.sh`, the workflow, and the two notes. I did not read the
  other 131 modules.
