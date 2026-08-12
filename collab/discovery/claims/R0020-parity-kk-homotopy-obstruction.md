---
id: R0020
title: Corrected parity KK-homotopy obstruction for the affine Toeplitz extension
status: formalizing
kind: obstruction
certificate: mixed
load_bearing: false
novelty: known
generator: codex-r0004-cross-lineage-breaker
dependencies: none
statement_hash: 4d61923e2572e0b923a6ff7a976876758e39ad0c3c4ab0e1b787e0328ace754d
cycle: 2
max_cycles: 6
owner: codex audit repair
breaker: invited — independent audit of the Cartan outerness step and the constructible-ideal orbit calculation
source: notes/KBOUNDARY_AUDIT.md
supersedes: R0004
updated: 2026-08-12
---

# Tension

R0004 correctly located a homotopy obstruction to detecting the Liouville
gauge twist with ordinary K-theory, but packaged it with an undefined
completion claim, a conditional parity-core K-computation, and a false
reflection control. The primary source computes the same final abstract
K-groups for $Q_{\mathbb N}$ and $Q_{\mathbb Z}$.

# Rosetta bridge

The common object is an automorphism inside a topological symmetry group.
Point-norm paths of automorphisms become equal KK-classes; disconnected
actions may remain visible in fixed cores even when final countable free
K-groups become abstractly isomorphic. The bridge separates the homotopy
class, the action/core, and the bare output groups.

# Exact statement

Let $0\to I\to\mathcal T\to Q_{\mathbb N}\to0$ be the boundary extension for $\mathcal T=C^*_\lambda(\mathbb N\rtimes\mathbb N^\times)$, and let $\alpha_\lambda(s_n)=\lambda(n)s_n$. (A) $K_0(\mathcal T)=\mathbb Z[1]$, $K_1(\mathcal T)=0$, and the quotient map is zero on K-theory; hence $K_0(Q_{\mathbb N})\to K_1(I)$ is an isomorphism and $K_1(Q_{\mathbb N})\to K_0(I)$ is injective. (B) The automorphism $\alpha_\lambda$ is outer in $Q_{\mathbb N}$ and has no inner lift in $\mathcal T$, but is connected to the identity by the point-norm continuous gauge path $g_t(p)=e^{\pi i t}$; consequently $(\alpha_\lambda)_*=\mathrm{id}$ and $[\alpha_\lambda]=[\mathrm{id}]$ in KK. Thus no invariant depending only on the homotopy or KK-class of the twist distinguishes Liouville parity. (C) The crossed product $Q_{\mathbb N}\rtimes_{\alpha_\lambda}\mathbb Z/2$ is Morita equivalent to the parity fixed core. No K-group computation for that core is asserted here. (D) Reflection is disconnected and acts nontrivially on the Bunce--Deddens core, but Cuntz computes $K_0(Q_{\mathbb Z})=K_1(Q_{\mathbb Z})=\mathbb Z^{(\infty)}$, the same abstract groups as for $Q_{\mathbb N}$; therefore reflection is not a distinguishing control for the final bare K-group pair.

# Preservation ledger

- Preserved from R0004: the Toeplitz K-point, faithful six-term boundary,
  Cartan fixed-point outerness proof, connected gauge path, and graded Morita
  equivalence.
- Removed: claims about every “Fredholm-compatible completion” and every
  difference-type invariant.
- Deferred: the even-subgroup later-stage PV action and equivariant
  $R(\mathbb Z/2)$ module.
- Corrected: reflection is action/core-visible but not distinguished by the
  final abstract group pair.

# Proof obligations

1. Classify the saturated constructible right ideals of
   $\mathbb N\rtimes\mathbb N^\times$ and verify one free orbit before
   applying the Ore-semigroup K-theory theorem.
2. Check the six-term sequence using $[1_{Q_{\mathbb N}}]=0$.
3. Verify that the canonical diagonal is a masa and evaluate the implementing
   cocycle at the fixed point $0\in\widehat{\mathbb Z}$.
4. Check point-norm continuity of the all-prime phase path on a dense
   algebraic subalgebra.
5. Verify the graded $2\times2$ matrix isomorphism and fixed-core Morita
   equivalence without using the unresolved K-groups.
6. Read Cuntz's final §7 theorem rather than inferring final groups from the
   dihedral core alone.

# Falsification

- Exhibit a second constructible-ideal orbit or nontrivial stabilizer.
- Exhibit an inner implementer for a nontrivial gauge point in
  $Q_{\mathbb N}$ or $\mathcal T$.
- Find an algebraic word on which $t\mapsto\alpha_{g_t}$ is not norm
  continuous.
- Break one of the four matrix corners in the graded crossed-product map.
- Known-false control: treating the final K-groups of $Q_{\mathbb Z}$ as
  different must fail against Cuntz's explicit
  $(\mathbb Z^{(\infty)},\mathbb Z^{(\infty)})$ theorem.

# Evidence

`notes/KBOUNDARY_AUDIT.md` gives the independent derivation and source ledger.
`notes/KBOUNDARY.md` preserves the original assertions by strike-through and
records the corrected scopes. The decisive source-level refutation is Cuntz,
arXiv:math/0611541, end of §7.

# Independent audit

Open. The R0004 builder and this Codex breaker are independent lineages, but
the corrected packet itself should receive a fresh audit of obligations 1,
3, and 5 before promotion.

# Prior art

The K-theory inputs and reflection computation are known: Cuntz
arXiv:math/0611541; Cuntz--Echterhoff--Li arXiv:1201.4680v2;
Barlak--Omland--Stammeier arXiv:1512.04496v3. The correction makes no novelty
claim.

# Successor seeds

- Compute the even-subgroup action on the accumulated PV extensions, or find
  a theorem that removes the possible Bott/unipotent term.
- Compute filtered, pointed, or equivariant data that retains the reflection
  core distinction lost by the final abstract group pair.
- Test a non-homotopy-invariant secondary invariant of the parity core.

# Event log

- 2026-08-12: seeded by the R0004 cross-lineage audit as the corrected
  homotopy/KK theorem; the crossed-product K-groups and reflection control are
  deliberately excluded.
