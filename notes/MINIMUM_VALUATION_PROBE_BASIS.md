# The exact number of valuation probes needed to form a residue

Fix a prime (p), depth (k\ge1), and (R_k=\mathbb Z/p^k\mathbb Z). A
translation center (c\in R_k) supplies the probe

\[
q_c(r)=\tau_k(r-c)=\min(v_p(r-c),k).                    \tag{1}
\]

The full translation future uses all (p^k) centers and reconstructs (r).
The exact formation-cost question is how many centers are actually necessary.

## Minimum-basis theorem

Partition (R_k) into its (p^{k-1}) fibers modulo (p^{k-1}). Each fiber
contains (p) residues and is the set of leaves sharing one parent in the
depth-(k) (p)-ary residue tree.

**Theorem 1.** A center set (C\subseteq R_k) separates all residues by the
response vectors

\[
r\longmapsto(q_c(r))_{c\in C}                           \tag{2}
\]

only if every sibling fiber contains at least (p-1) centers. Conversely,
choosing any (p-1) residues from every sibling fiber separates all of
(R_k). Hence the exact minimum is

\[
\boxed{|C|_{\min}=(p-1)p^{k-1}.}                        \tag{3}
\]

**Lower bound.** Suppose distinct siblings (r,s), congruent modulo
(p^{k-1}), are both omitted from (C). For a center (c) outside their
sibling fiber, (v_p(r-c)=v_p(s-c)<k-1), since (r) and (s) share all
digits below the final one. For a center (c) in their fiber but different
from both, both differences have valuation exactly (k-1). Thus
(q_c(r)=q_c(s)) for every (c\in C), so they are not separated. At most one
residue may be omitted from each fiber, proving the lower bound in (3).

**Sufficiency.** Choose all but one residue in each sibling fiber. If two
states lie in the same fiber, at least one is selected; its own center gives
response (k), while the other gives at most (k-1). If they lie in
different fibers and one is selected, its own center separates them. If both
are the omitted residues of their respective fibers, choose a selected
sibling (c) of the first. Then (q_c(r)=k-1), while
(q_c(s)<k-1), because (s) lies under a different parent. Thus every pair
is separated. ∎

## Universal property and formation event

For a declared center set (C), (2) is the canonical behavioral carrier for
the one-step probe language (\{q_c:c\in C\}). The theorem says exactly when
restriction of the full residue observable to those probes remains injective.
It therefore specializes the repository's transferable-observable criterion:
the minimum teaching/formation set is not one center per state, but all except
one leaf under every deepest parent.

Installing the centers can be read incrementally. A sibling fiber remains
ambiguous precisely while it contains at least two uninstalled centers. Its
penultimate installation makes the final two candidates distinguishable and
closes that local frontier. Formation completes exactly when every parent has
at most one omitted child.

This sharpens the preceding action-group theorem. Generating the full
translation group from one unit action gives semantic access to all translated
probes through repeated execution. If probes must instead be installed as
one-shot primitive experiments, (3) is the exact number required. Generator
count, execution length, and primitive-probe count are different costs.

## Executable certificate

`machinery/minimum_valuation_probes.py` constructs the canonical basis choosing
digits (0,\ldots,p-2) above every residue modulo (p^{k-1}). It verifies
separation, the sibling occupancy lower-bound certificate, arbitrary choices
of the single omission, and the collision exposed after deleting any center
from a minimum basis.

## Rigor boundary

Proved: Theorem 1 and the exact minimum (3). This is elementary finite
ultrametric/tree mathematics; no novelty is claimed. Tests replay finite
instances and are not the proof.

Not proved: minimum adaptive query depth when centers can be chosen from prior
responses; minimum generator cost when translations compose; weighted probe
costs; or analogous bases for several primes or polynomial actions.
