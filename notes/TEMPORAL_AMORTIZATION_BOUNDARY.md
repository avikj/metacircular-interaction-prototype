# Temporal amortization boundary

**Status.** Exact natural-number cost accounting checked in Lean. This note
does not identify a cost unit with wall-clock time or mathematical value.

## Exact threshold

For natural-number costs, define

```text
oldCost C M       = M*C
installedCost F c M = F + M*c,
```

where `C` is the old per-use cost, `c` is the installed per-use cost, `F` is
one-time formation and verification cost, and `M` is the future reuse count.

When `c < C`, Lean proves the exact strict inequality

```text
installedCost F c M < oldCost C M
  ↔ F / (C-c) < M.
```

The proof first names the positive gap `C-c`, rewrites
`M*C = M*c + M*(C-c)`, cancels the common installed-use cost, and then applies
`Nat.div_lt_iff_lt_mul`. No rational-number interpretation or rounding
convention is hidden in the statement.

Therefore the least profitable natural-number reuse count is exactly

```text
leastProfitableReuse F c C = F / (C-c) + 1.
```

The leaf proves profitability at that count and rules it out at every smaller
count. Equality at break-even is not called a gain. It also proves the other
branch: if `C <= c`, no reuse horizon makes installation strictly cheaper,
even if formation cost is zero.

This formalizes the amortization part of the sampled
[`TEMPORAL_ACCELERATION_BOUNDS.md`](TEMPORAL_ACCELERATION_BOUNDS.md). The
product-span and critical-path discussions remain prose mathematics here;
they are not silently promoted by this leaf.

## Horizon-free obstruction

The retired certificate-walk example supplies one exact hostile pair:

```text
F = 72, C = 30, c = 8.
```

At three uses, keeping the old route costs `90` while installing costs `96`.
At four uses, keeping costs `120` while installing costs `104`. Lean proves
both strict comparisons.

`InstallDecision` has only `keep` and `install`; `OptimalAt` compares the
chosen total with the minimum of the two declared totals. The checked no-go is

```text
not exists decision,
  OptimalAt 3 decision and OptimalAt 4 decision.
```

Consequently any deterministic function that sees only `(F,C,c)`, and thus
must return the same decision on the shared pre-horizon state, fails to be
offline-optimal for one of the two continuations. This is not a software
failure: horizon, workload distribution, regret objective, or a competitive
policy is additional input.

The no-go is deliberately small. It does not rule out online policies with a
competitive guarantee, randomized decisions, a policy that observes use as it
arrives, or decisions made after the horizon is supplied.

## Relation to current formation results

R0066 constructs a nonadaptive global suffix vocabulary; R0068 corrects the
informative annotated-split count to at most `n-1` while leaving the lengths
of installed annotation words and constant-response steering unpriced. The
present leaf does not fill that cost gap. It says what follows only after one
has supplied commensurate `F`, `C`, `c`, and a reuse horizon: exact
profitability then has the threshold above. Shortcut metadata without future
use information still does not choose installation.

The formed-world correction is also preserved. Ambient sufficiency restricts
constructively; formed insufficiency yields a separator only with an explicit
witness or the checked search interface. An amortization comparison does not
manufacture either. The cyclotomic product adapter supplies an exact route,
but this leaf does not price its proof, evaluation, factor search, or reuse.

At the frozen Draw-18 origin, registry packets R0066--R0068 remain
fail-closed. R0066 has invalid `kind`/`certificate` enum values; R0067 also has
invalid status `claimed` and invalid certificate wording; R0068 uses valid
enum words but has no append-only events. None of R0066--R0068 has an event
directory. Numeric message collisions remain at 0600, 0604, and 0610; the
temporary 0614 formed-result collision was resolved by renumbering it to
0615. No packet status is a premise of this theorem.

## Scope fence

The cost variables are declared natural numbers in one unit. The leaf does
not measure annotation length, proof effort, historical content, energy,
latency, parallel critical paths, option value, or physical execution. It
does not prove that the repository is self-improving, that a shortcut will be
reused, or that semantic span is accomplished work. No retired Python was
run.

## Random provenance and verification

Draw 18 froze origin commit
`9e5d3e9061f97bddd941818d5351ad3b9d3fce2d` (tree
`cc4cd12def43c7f07f21221924c15135a47ad1c4`). The C-sorted tracked semantic
frame contained 1,067 `.agda`, `.lean`, and `.md` files under `formal/`,
`notes/`, and `papers/`, after excluding build products, Python, and all 17
prior samples. Its SHA-256 was
`5475ceb76a086900ba1f296768b0897217ab1cb30c5771a5e032653fc68f8f2c`.
The sole native `/dev/urandom` unsigned 32-bit draw was `14981660`, below the
unbiased acceptance limit `4294966291` (tail 1,005). It selected zero-based
index 980, one-based position 981, `notes/TEMPORAL_ACCELERATION_BOUNDS.md`,
blob `3f6270631111f8a18e4058d5aace660abfc1e0e7`. There was no redraw.

Focused replay:

```text
cd formal/pairfield
lake env lean Pairfield/TemporalAmortizationBoundary.lean
```

is the required focused replay. Pre-green attempts exposed three script-level
issues: a nonexistent pinned Mathlib module path, an implicit cancellation
that needed addition commuted explicitly, and a two-case contradiction tactic
that tried to simplify a hypothesis after its branch had already closed.
These were repaired without weakening any theorem. The final focused command
exits zero and the 8,706-job module build passes. Shannon independently
replayed the focused check and hostile-audited positivity, cancellation,
strict threshold/minimality, the no-profit branch, the two controls, the
fixed-decision quantifier, and every scope fence: PASS, no blocker.
