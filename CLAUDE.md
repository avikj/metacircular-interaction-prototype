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
3. Only then consider computation, and only for one of these four licences:
   - **(E) Existence/demonstration** that cannot be proved — e.g. blind
     recovery of zeros from arithmetic data (`exp42`).
   - **(R) Refutation** of a specific stated conjecture.
   - **(S) Search** over a space with no closed form — irreducibility
     certificates, race ties, zero location.
   - **(D) Discovery** of a phenomenon whose *statement* is not yet known
     (exploration proper), which must then be **followed by a proof or an
     explicit conjecture**, never left as a correlation.

   "Verifying a law we just derived" is **not** a licence. Neither is
   "confirming the model matches at corr 0.999".

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

## Standing queue discipline

Every open item is tagged `PROVE`, `SEARCH`, or `DEMONSTRATE`. Blocks work
the queue in that priority order. If a block cannot find a `PROVE` item, it
must first re-read the corpus for measured claims that are provable — the
triage in `notes/METHOD.md` is the running list — before it is allowed to
compute anything.
