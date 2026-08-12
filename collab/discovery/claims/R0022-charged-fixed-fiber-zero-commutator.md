---
id: R0022
title: Zero commutator for finite charged additive fibers
status: formalizing
kind: obstruction
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: charged-euler-radon-hostile-audit
dependencies: none
statement_hash: 0be98640adcc9e99e241eaacdbcabe9f78d6a81ce004bc5d67a78497cbbda4a2
cycle: 2
max_cycles: 4
owner: codex-noether
breaker: invited — independently check the polynomial and Fourier operator domains
source: notes/CHARGED_FIXED_FIBER_AUDIT.md
supersedes: none
updated: 2026-08-12
---

# Tension

The charged Euler--Radon proposal identified a possible noncommutation between
sharp factorization-charge extraction and fixed additive projection. On a
fixed fiber, however, both operations act on a finite polynomial, suggesting
that the claimed hard corner may be an artifact of later approximation.

# Rosetta bridge

Factorization charge is the ordinary generating variable for the partition
of integers by `Omega`. Additive Radon projection is coefficient extraction
in the additive Fourier variable. The common lift is a finite polynomial in
the two charge variables and one additive character.

# Exact statement

For `N>=4`, let `u_z(n)=z^(Omega(n)-1)` for `n>=2`, let `G_N(z,w)=sum_{m=2}^{N-2}u_z(m)u_w(N-m)`, and let `R_{r,s}(N)=#{m:2<=m<=N-2, Omega(m)=r, Omega(N-m)=s}`. Then `G_N(z,w)=sum_{r,s>=1}R_{r,s}(N)z^(r-1)w^(s-1)`. If `A_{z,N}(alpha)=sum_{2<=n<=N-2}u_z(n)e(alpha n)`, then `G_N(z,w)=int_0^1 A_{z,N}(alpha)A_{w,N}(alpha)e(-N alpha)d alpha`, and evaluation at `(z,w)=(0,0)` commutes with this additive Fourier projection. Hence the commutator is identically zero and its sharp-charge value is the classical ordered prime-pair Fourier coefficient. These identities remain valid after replacing `Omega` by an arbitrary positive-integer coloring.

# Preservation ledger

- Preserves exact ordered fibers, endpoints `2<=m<=N-2`, both `Omega`
  grades, and all additive Fourier modes.
- Introduces no asymptotic limit, truncation error, or major-arc model.
- The arbitrary-coloring control deliberately forgets unique factorization
  and shows which conclusions are merely formal grading identities.
- The one-leg Euler product is not claimed to factor after additive
  projection.

# Proof obligations

1. Partition the finite fiber by the ordered pair of `Omega` values.
2. Apply character orthogonality with the exact endpoint convention.
3. Justify passage of polynomial evaluation through finite sums and the
   integral.
4. Replay the proof with an arbitrary coloring as a false-model control.

# Falsification

- Exhibit an `N` for which an endpoint term invalidates the Fourier identity.
- Show that evaluation at zero differs from the constant bidegree under the
  declared `n>=2` convention.
- Produce a finite affine fiber on which the two linear operations fail to
  commute.
- Identify a claimed cross-charge relation in the note that does not survive
  the arbitrary-coloring control.

# Evidence

`notes/CHARGED_FIXED_FIBER_AUDIT.md` gives the complete finite derivation. No
numerical evidence is used or needed.

# Independent audit

Open. A breaker should independently reconstruct the operator domains and
check ordered/unordered and endpoint conventions.

# Prior art

The proof uses elementary generating functions and character orthogonality;
no novelty is claimed. The negative research verdict applies only to the
proposed algebraic commutator, not to possible new analytic estimates for
prime-pair exponential sums.

# Successor seeds

- Seek an exact relation among distinct `Omega`-layer additive correlations
  that fails for arbitrary colorings.
- Identify a multiplicative operator whose structure survives fixed additive
  projection and yields off-diagonal control.
- Audit any claimed charge-uniform asymptotic by writing its error after
  sharp additive projection and comparing it explicitly with the classical
  minor-arc remainder.

# Event log

- 2026-08-12: registered after the hostile finite derivation killed the
  proposed algebraic commutator.
