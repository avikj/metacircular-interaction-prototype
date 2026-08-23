# Random anchor 10 — balanced reweave as a checked Natural Machine seam

Anchor: batch-02 #10, `runtime/state/walk.json`, byte offset 4,913,987,
length 4,096.  The physical tracked-byte slice is entirely ASCII decimal
digits (`37`–`39` in hexadecimal); no semantic filtering or redraw was used.
The slice is therefore treated only as a perturbation of representation, not
as evidence about the walk's meaning.

The exact seam it selected is persistent reweaving.  A long stream of local
updates should preserve the root and the observable result while its history
is stored as a balanced binary plan.  `formal/executable/BalancedReweave.agda`
checks this directly:

* `insertTree-sound` proves one binary carry insertion is extensionally the
  old plan followed by the new endomorphism;
* `push-sound` lifts that to a root-preserving update;
* `update-read` proves every rooted observation sees the same transported
  action;
* `balancedCount-sound` and `linearPlanCount-sound` separate semantic
  equality from representation choice.

This is a finite executable seam, not a claim of a productive final
coalgebra.  The random digits supplied the collision/carry image; the Agda
term supplies the warrant.  The residual is cost: no theorem here establishes
that the balanced plan is faster in an evaluator, only that it is extensionally
correct and structurally logarithmic in its carry depth.

