# Research protocol for this repository — binding on all agents

This repo produced ~30 numerical experiments in its first sessions, of which
roughly five earned their keep. The rest measured quantities that a page of
algebra determines exactly. One of them (`exp27`) published a *fitted*
constant, $0.362$–$0.421$, where the true value is exactly $\tfrac14$; the
error propagated into two notes, a paper section, and a round of
cross-review. This file exists so that does not recur.

## The rule

**Before running any computation, write down the theorem it would replace.**
Then:

1. If the statement follows from Stirling, the explicit formula, stationary
   phase, a Mellin/Laplace transform, an integral-domain argument, or a
   standard asymptotic (Mertens, Hardy's Ramanujan expansion, …) — **write
   the proof**. Do not run the experiment. These have produced *every*
   structural law in this corpus (D‴, G, E2, H, H′, I1, I2); each was
   measured first and proved later, always in less space than the
   experiment took.
2. If the statement is a **closed-form constant**, derive it. Fitted
   coefficients over one decade are not results; they are noise with error
   bars omitted.
3. **Floating-point measurement is not a licence for anything.** The
   four-licence scheme in the first version of this file was still too
   permissive and has been withdrawn. What survives is a single
   distinction:

   - **Exact / certified symbolic computation is proof** and is always
     allowed: an irreducibility certificate over $\mathbb{Q}$, a finite
     exhaustive verification, a resultant, a factorization. These produce
     mathematical objects, not measurements.
   - **Everything else — correlations, fitted exponents, "the model matches
     at 0.9999", empirical constants — is standing in for an error
     analysis you have not done.** In every instance in this corpus, the
     derivable quantity behind the measurement existed and was shorter than
     the experiment.

   The operative test: *a correlation coefficient has no content; the
   content is the error term.* If you cannot derive the error term you do
   not understand the object, and if you can, you do not need the run.

   Corollary, learned the hard way (`HOLOGRAM.md` §7): measuring a constant
   at one scale hides its scaling. The "measured" noise floor
   $\varepsilon\approx10^{-3}$ was $X^{-1/2}$; deriving it changed the
   depth-law exponent from $T\log^2T$ to $T^{1/2}\log^{3/2}T$. A number
   without its $X$-dependence is worse than no number, because it looks
   like knowledge.

## Consequences for how results are written

- A note reporting a correlation coefficient must state which theorem the
  correlation is standing in for, and why the theorem is unavailable.
- No claim of the form "measured slope $\approx x$" survives if the slope is
  derivable. Derive it, then quote the exact value.
- Honesty ledgers stay, but they are not a substitute: labelling a
  heuristic as heuristic does not license leaving it heuristic when a proof
  is a page away.
- Prior art gets searched **before** the experiment, not after the write-up
  (three results here were rediscoveries found only at audit time).

## The substrate: Agda, not Python

**Python is banned in this repository** (human owner, 2026-08-13). Mathematics
is written in **Agda** (`formal/cubical/`, `--cubical --safe`, no postulates,
no holes) or **Lean** (`formal/pairfield/`) for the analytic lane.

The Lean lane carries the same discipline, stated here because until
2026-08-15 it was stated nowhere and consequently enforced nowhere
(`notes/LEAN_LANE_AUDIT.md`): **no `sorry`, no `admit`, no `axiom`
declaration** — all three are currently absent from all 131 modules and must
stay absent. **`native_decide` is not free**: it bypasses the kernel for the
compiler and emits a fresh axiom per use, so every `#print axioms` downstream
of it names a generated `._native.native_decide.ax`. Prefer kernel `decide`
wherever it terminates; where `native_decide` is genuinely needed, say so at
the use site, and never let a note describe such a theorem as "checked"
without the qualification. Finally: a module that is not in `Pairfield.lean`'s
import closure is built by nothing, so "the lane builds" says nothing about
it — check `globs` before believing a green.

This is the rule above, taken seriously rather than restated. This file already
says that exact/certified symbolic computation *is* proof and that everything
else stands in for an error analysis you have not done. A Python script that
prints a number is exactly that "everything else": the reader must trust the
script, its author, and the run. A checked term is the object itself, and it
is still there tomorrow.

The ban is enforced mechanically because prose failed — a hook on tool use
(`.claude/hooks/no-python.sh`), a `pre-commit` hook (`.githooks/`, enabled
repo-wide via `core.hooksPath`), and CI
(`.github/workflows/no-python.yml`). The 660 existing `.py` files are legacy:
deletions always pass, additions and modifications do not.

`MATH_ALLOW_PYTHON=1` overrides every layer. It exists so that in-flight work
is never destroyed (PROTOCOL §5), not so new Python gets written. Using it
without recording it in your journal and a message is lying to the
collaboration.

### A missing kernel is not a licence either (added 2026-08-15)

The banned substrate has three enforcement layers. The *required* substrate had
none, and on 2026-08-15 a session shipped four hand proofs with the ledger line
*"agda is not installed in this session, so any module I wrote would ship
unchecked"* — while `formal/cubical/BUILD.md` carried the install recipe and
nothing ran it. Absence of the kernel had quietly become an argument for not
using it.

**"The toolchain was unavailable" is not an acceptable reason for a checkable
statement to stay unchecked.** Install it:

```sh
sh formal/cubical/ensure-toolchain.sh            # check;  exit 0 iff usable
sh formal/cubical/ensure-toolchain.sh --install  # install what is missing
```

`.claude/hooks/agda-ready.sh` runs the check at every session start and begins
the install in the background if it fails, so the first turn of every session
knows the state of its own kernel. If the install is still running, block on
it. Prose proofs remain welcome on their own merits — what is forbidden is
letting a missing binary decide the grade of the result.

## Standing queue discipline

Every open item is tagged `PROVE`, `SEARCH`, or `DEMONSTRATE`. Blocks work
the queue in that priority order. If a block cannot find a `PROVE` item, it
must first re-read the corpus for measured claims that are provable — the
triage in `notes/METHOD.md` is the running list — before it is allowed to
compute anything.
