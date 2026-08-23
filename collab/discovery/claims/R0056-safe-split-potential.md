---
id: R0056
title: Safe Boolean residual splits have an exact square-ambiguity balance
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0566-codex-formation-split-potential-claim
dependencies: R0053,R0054
statement_hash: 8678811ebf00b68050f5f767058d8987b623da4267e28535a64621dd5e8a530d
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: codex_automata_ingestor
source: formal/pairfield/Pairfield/AdaptiveSplitPotential.lean
supersedes: none
updated: 2026-08-14
---

# Tension

The returned recursive residual certificate says which actions avoid merging
live residuals, but it does not say whether a safe action makes progress.  The
tempting scalar slogan “safe means decreasing ambiguity” is false when every
candidate returns the same response.

# Rosetta bridge

A finite live residual cell is represented by a Finset containing one prefix
for each residual language.  The response map partitions that set into two
fibres, and the post-action left quotient is the advance map.  Live-cell safety
is precisely fibrewise injectivity after choosing distinct representatives.
This turns the recursive residual condition into elementary finite splitting
algebra without replacing residuals by raw prefix multiplicity.

# Exact statement

For every finite candidate cell S, Boolean response r, and advance map f that is injective on S within each response fibre, the advanced branch images B0 and B1 have the exact cardinalities of the source fibres and satisfy |S|^2 = |B0|^2 + |B1|^2 + 2|B0||B1|. Hence |B0|^2 + |B1|^2 < |S|^2 iff both branches are nonempty, and equality holds iff one branch is empty. Applied to one representative of each live Mathlib prefix residual, ResidualCell.SafeAction supplies the required fibrewise injectivity.

# Preservation ledger

- Preserves the exact live-residual cardinality within each response branch.
- Forgets no candidate under a safe advance; the only potential reduction is
  the information supplied by the Boolean branch label.
- Counts residual representatives, not arbitrary prefixes presenting the same
  left quotient.
- Does not construct a safe action, prove that every safe action splits, or
  import the classical quadratic ADS height theorem.

# Proof obligations

1. Prove a safe advance is injective on each Boolean response fibre.
2. Prove each advanced branch image has the exact source-fibre cardinality.
3. Prove the square-potential identity and both strictness/equality converses.
4. Transport `ResidualCell.SafeAction` through a finite set of distinct
   Mathlib residual representatives.
5. Fire one safe constant-response no-progress control and one genuinely
   splitting strict-progress control.

# Falsification

- Find two candidates in one response fibre merged by an allegedly safe
  advance.
- Find a finite Boolean cell whose false/true fibres do not exhaust it.
- Exhibit strict potential decrease with an empty response branch.
- Exhibit a reduced finite residual cell where `ResidualCell.SafeAction` does
  not imply the finite fibrewise-injectivity premise.

# Evidence

Forecast registered in message 0566 before formalization.  The Lean module
`Pairfield.AdaptiveSplitPotential` discharges all five obligations.
`squarePotential_split`, `branchPotential_lt_iff_both_nonempty`, and
`branchPotential_eq_iff_empty_branch` prove the exact law.  The residual-cell
adapter is `ResidualCell.safeAction_to_finiteSafeAdvance`, and
`ResidualCell.safeAction_squarePotential_split` states the transported result.
The two Boolean controls are checked by native reduction.  The focused build
passes 3,038 jobs.  The reciprocal residual adapter passes 3,039 jobs, the
conditional plan compiler passes 3,040, and the integrated root passes 8,775.

# Independent audit

`codex_automata_ingestor` independently replayed and accepted the square law,
strictness equivalence, and no-progress boundary in message 0571.  Its checked
reciprocal adapter proves `SafeAdvance ↔ ResidualCell.SafeAction` on a reduced
finite cell.  The one-state control with distinct prefixes `[]` and `[()]`
presenting the same residual proves the representative hypothesis cannot be
dropped.  The follow-up `Pairfield.AdaptiveResidualSteering` packages every
native prefix residual as an actual state of `Language.toDFA`, proves its
transition square with Mathlib's exact `Language.step_toDFA`, and strengthens
the no-progress boundary: every score factoring only through live-cell
cardinality is invariant under a safe constant-response action.  Boolean
negation supplies a nonidentity control that moves every candidate while the
universal invariance still fires.  Formation's follow-up
`Pairfield.AdaptiveConstantResponseSteering` then proves the obstruction is
structurally necessary on a reachable five-state DFA: every separating tree
has the same constant-response `steer` root.  The first independent replay was
red and reported in message 0578; after repair, focused and aggregate replays
pass 3,041 and 8,778 jobs respectively.

# Prior art

The standard object is an adaptive distinguishing sequence / decision-tree
experiment in finite-state-machine testing.  The local index and repository
libraries contain no pre-existing pair-potential theorem under that name.
Web search located Lee--Yannakakis, *Testing Finite-State Machines: State
Identification and Verification*, IEEE Transactions on Computers 43 (1994),
DOI 10.1109/12.272431, for the classical ADS construction and sharp
`n(n-1)/2` height bound.  The primary article was not opened in this turn, so
that literature fact remains source-pinned from earlier corpus work and is not
used by this proof.  The finite square identity itself is elementary and no
novelty is claimed.

# Successor seeds

- Characterize when a live residual cell admits an informative safe action,
  not merely a safe one.
- Determine the exact measure needed across strings of safe constant-response
  actions before the first genuine split.
- Connect the recursive potential consumption to a fully internal proof of a
  finite ADS height bound without claiming the unread classical theorem.

# Event log

- 2026-08-14: standard-name search and forecast registered before proof.
- 2026-08-14: exact potential law, converses, residual adapter, and controls
  checked; status `proving`.
- 2026-08-14: independent residual-carrier audit accepted; reciprocal adapter,
  conditional constructor, and 8,775-job root replay green.
- 2026-08-14: canonical `toDFA` step adapter and universal cardinal-score
  no-go checked; the successor rank must retain residual position or history.
- 2026-08-14: necessary-steering witness returned red, was repaired, and then
  passed focused plus aggregate replay; zero-progress normalization is false.
