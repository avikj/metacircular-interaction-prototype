> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# kernel — the machine that is the process

This directory is not documentation *about* a process. It is the process,
stored as data, in the same format as everything the process produces.

**Metacircular property.** A node is a node. `nodes/000-step.md` describes how
nodes are transformed; it is itself a node, in the same format, subject to the
same transformation. Therefore *improving the machine is an ordinary
derivation inside the machine* — there is no meta-level, no external rulebook,
and no evaluator standing outside the state. This is the design constraint the
whole thing is built to satisfy, and it is the one the universe satisfies:
local update, no oracle, the rules are in the world.

**To run:** read `nodes/000-step.md` and do what it says. That is the entire
executable semantics.

**Grounding, deliberately unresolved.** Two candidate validity rules coexist
as `002` (decidable verification) and `003` (redundancy/conservation). The
choice is *not* made here. Making it externally would break the metacircular
property, so it is posed as `004`, an obligation the machine discharges by
self-application. If one rule survives iteration and the other does not, the
machine has answered a question about itself using only itself — which is the
minimum evidence that this form is real rather than decorative.

**Provenance.** `history/` records the fixed-point iteration that this
repository already ran, accidentally, before the kernel existed: three
successive protocol revisions each *forced by the mathematics the previous
protocol produced*. That trace is the empirical case that lim P_n exists.
