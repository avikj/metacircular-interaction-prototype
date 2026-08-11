---
id: R0016
title: Finite-flip symmetrization closes the unconditional twisted eigenmeasure exotic zone
status: formalizing
kind: synthesis
certificate: mixed
load_bearing: false
novelty: searched-not-found
generator: R0011-cross-lineage-breaker-successor
dependencies: R0011
statement_hash: 5fbad1dd140c83593c60e25a45a2123af5cf88e1339c04d0a3f8896dc1cd375e
cycle: 2
max_cycles: 6
owner: codex-eigenmeasure-breaker (builder)
breaker: invited — independent hostile audit of Frantzikinakis Proposition 3.7 scope and the two-component eigenfunction patch
source: notes/TWISTED_EIGENMEASURE_CLOSURE.md
supersedes: none
updated: 2026-08-11
---

# Tension

R0011 left an apparent exotic horn: an ergodic unconditional twisted
eigenmeasure could have trivial rational spectrum but a nontrivial divisible
irrational spectrum.  Ordinary strongly stationary systems, however, have no
shift eigenvalue other than 1 even when they are nonergodic.  The twist seems
to prevent direct use of that theorem, while its finite global-flip orbit
suggests that the obstruction may disappear after one exact symmetrization.

Forecast registered before independent audit: outcome space
`{proof survives; Proposition 3.7 hypothesis mismatch; component patch fails;
exact result is prior art}` with credences `{0.72, 0.10, 0.08, 0.10}`.  The
largest suspect joint is the published Proposition 3.7 boundary: its statement
is exact, but the paper only sketches the long proof inherited from Jenvey.

# Rosetta bridge

The common object is the finite flip-orbit measure
`nu_bar = (nu + J_*nu)/2`.  Twisted dilation invariance of `nu` becomes
ordinary strong stationarity of `nu_bar`; the global flip becomes a morphism
between at most two ergodic components.  An eigenfunction on one component
transports through the flip and patches across the finite decomposition,
turning component spectrum into global spectrum.  Frantzikinakis's theorem
then removes it.

# Exact statement

Let Omega={-1,+1}^Z with shift S, dilations D_m(omega)(h)=omega(mh), and global flip J(omega)=-omega. Let epsilon:N->{-1,+1} be nontrivial, and let nu be an ergodic S-invariant Borel probability measure such that (D_m)_*nu=(J^((1-epsilon(m))/2))_*nu for every m>=1. Then nu is the uniform Bernoulli product measure. Consequently, if nu is the marginal of an ergodic conditional logarithmic eigenmeasure of R0011 with nontrivial sign data and trivial rational spectrum, R0011 Lemma 3.1 deconditions its transfer identities and the same conclusion follows.

# Preservation ledger

- The symmetrization forgets which of the two global-sign components was
  selected, but preserves their shared shift spectrum and all dilation laws.
- The component patch uses the fact that global flip commutes with the shift;
  it introduces no arithmetic input.
- Trivial rational spectrum is not needed for the unconditional theorem.  It
  is used only by R0011 Lemma 3.1 to pass from a conditional logarithmic
  eigenmeasure to unconditional dilation laws.
- The conclusion is the exact coordinate product law via R0011 Theorem 3.3,
  not merely an abstract Bernoulli isomorphism.
- No Cesaro claim is made: a renormalization orbit of laws is not a fixed law.

# Proof obligations

1. Verify directly that `(nu+J_*nu)/2` is invariant under every `D_m` and
   matches Definitions 3.1--3.2 of strong stationarity.
2. Source-audit Frantzikinakis, J. Analyse Math. 93 (2004), Proposition 3.7:
   its nonergodic scope, eigenvalue convention, and dependence on Jenvey.
3. Hostile-audit the measurable invariant component set and the flip-transport
   eigenfunction patch when `nu` and `J_*nu` are distinct.
4. Recheck that absence of nontrivial eigenvalues plus ergodicity is precisely
   weak mixing, and that R0011 Theorem 3.3 applies to the abstract
   unconditional law.
5. Re-run the nonergodic constant-mixture and untwisted biased-iid controls.
6. Replay the internal non-torsion proof in
   `notes/NON_TORSION_STRONG_STATIONARITY.md`; reconstruct Jenvey's separate
   root-of-unity branch before making the stronger unconditional theorem
   load-bearing.

# Falsification

- Exhibit an ergodic non-Bernoulli law satisfying all unconditional twisted
  dilation identities.
- Show that the flip symmetrization is not strongly stationary under the
  exact sequence-space definition.
- Give an eigenvalue of a component that cannot be patched measurably to the
  two-component mixture despite the flip conjugacy.
- Find an omitted hypothesis in Proposition 3.7 that the symmetrized law does
  not satisfy.
- Locate an exact prior-art theorem already proving the stated twisted result;
  this changes novelty to `known` but confirms the mathematics.

# Evidence

`notes/TWISTED_EIGENMEASURE_CLOSURE.md` contains the complete conditional
proof, component patch, averaging boundary, and false-model controls.
Primary source checked: N. Frantzikinakis, *The structure of strongly
stationary systems*, J. Analyse Math. 93 (2004), 359--388,
doi:10.1007/BF02789313, arXiv:math/0403453, especially Definitions 3.1--3.2
and Proposition 3.7.  R0011 supplies the independently rederived
deconditioning lemma and weak-mixing Walsh theorem.
`notes/NON_TORSION_STRONG_STATIONARITY.md` internally proves the only branch
of Proposition 3.7 needed by the trivial-rational logarithmic corollary.

# Independent audit

Two independent hostile audits ACCEPTED the proof chain, including the
literal-coordinate-iid scope of R0011 Theorem 3.3.  The fresh blind audit
also recomputed the registered statement hash, replayed the event chain, and
checked Frantzikinakis's nonergodic Proposition 3.7 against the author-hosted
paper.  The measurable patch is fully explicit: take `C=B\J(B)`, so `C` and
`J(C)` are disjoint, invariant, and conull for the two components.  This
packet remains deliberately `formalizing`, non-load-bearing, and separate
from R0011's immutable exact statement and event history.  Its residual
trust boundary applies only to the stronger unconditional theorem: the 2004
paper sketches rather than reprints the Jenvey-derived root-of-unity branch.
Two further independent audits ACCEPTED the full internal non-torsion
van-der-Corput induction used by the logarithmic corollary.

# Prior art

Known ingredients: Jenvey (J. Analyse Math. 73 (1997), 1--18) proves every
ergodic strongly stationary system is Bernoulli; Frantzikinakis Proposition
3.7 proves a general strongly stationary system has no eigenvalue other than
1; R0011 proves the twisted weak-mixing law is the fair coin.  Targeted public
searches for twisted strong stationarity, sign/global-flip symmetrization,
and finite ergodic components found no exact statement of this assembly.
Novelty is `searched-not-found`, never `novel`.

# Successor seeds

- Obtain and audit Jenvey's full proof, especially the root-of-unity case that
  the Frantzikinakis paper calls trickier.
- Generalize the finite-flip argument to a finite character group: determine
  when orbit symmetrization plus componentwise spectral transport forces each
  ergodic twisted component to be Bernoulli.
- If confirmed, write a new superseding R0011 successor rather than altering
  R0011's exact statement or historical events.

# Event log

- 2026-08-11: seeded from the outstanding Codex breaker pass on R0011 after
  exact rederivation of the transfer, deconditioning, weak-mixing, and
  divisibility arguments.
- 2026-08-11: formalizing — flip symmetrization and component-patching proof
  written with two false-model controls and an explicit Proposition 3.7
  literature boundary; independent hostile audit invited.
