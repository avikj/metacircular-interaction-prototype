---
id: R0022
title: Zero commutator for finite charged additive fibers
status: proving
kind: obstruction
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: charged-euler-radon-hostile-audit
dependencies: none
statement_hash: 0be98640adcc9e99e241eaacdbcabe9f78d6a81ce004bc5d67a78497cbbda4a2
cycle: 3
max_cycles: 4
owner: codex-noether
breaker: opus-mira (Claude Opus 5 lineage, 2026-08-12) — cross-lineage audit CONFIRMED; registered statement correct as written, Fourier side verified as an exact Laurent-coefficient identity; three operator-domain defects found in the surrounding prose and repaired in place (exp65, msg 0109)
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

**2026-08-12 cross-lineage breaker audit — opus-mira (Claude Opus 5).**
Verdict CONFIRMED. Evidence: `code/exp65_mira_audit_r0022.py`
(falsifier-only, exact integer/rational arithmetic, known-false control in
every block); msg 0109. The registered `Exact statement` above is correct as
written and needs no amendment.

The Fourier side was verified **exactly**, not numerically. For integer
frequencies, orthogonality on `R/Z` is literally coefficient extraction from a
product of Laurent polynomials in `x=e(alpha)`, so
`int_0^1 A(alpha)B(alpha)e(-N alpha) d alpha = [x^N](A(x)B(x))` is an identity
in `Z[z,w][x,x^-1]` and was checked as such. No quadrature enters the audit.

Survived independent re-derivation and exact replay:

- **Theorem 1** — `G_N(z,w) = sum_{r,s} R_{r,s}(N) z^{r-1} w^{s-1}` for all
  `N` in `[4,300]`, assembled two independent ways and compared as integer
  bidegree dictionaries. `G_N(0,0) = R_{1,1}(N)` is the *ordered* count with
  both parts `>=2`; the unordered count is a control that disagrees, so the
  endpoint/ordering convention is pinned rather than assumed.
- **Theorem 2 / (2.1)** — exact for all `N` in `[4,200]`; both paths of the
  commuting square return `R_{1,1}(N)`. Control: projecting at frequency
  `N+1` returns a different answer, so the identity is not vacuous.
- **All-bidegree commutation** — verified over 3,126 bidegree/modulus pairs,
  not merely at `(0,0)`.
- **Section 4 arbitrary-coloring control** — Theorems 1 and 2 hold verbatim
  under a deterministic arithmetic-content-free coloring, and its color-one
  layer differs from the prime layer (49 vs 16 at `N=200`), so the
  proves-too-much control genuinely has teeth.

**Three operator-domain defects in the surrounding prose** (the invited
breaker task). None touches the registered statement or the no-go; all three
are repaired in place in the source note.

1. *Typing of Theorem 2* (note Remark 2.3). `E_{0,0}P_N = P_N E_{0,0}` reads
   as an operator identity on one space, but the two `E_{0,0}` have different
   domains — `Z[z,w]` on the left, `Z[z]`-valued exponential sums legwise on
   the right. The true statement is that a square commutes. Content correct,
   notation overstated. Why it holds is worth recording: `z` lives only in
   leg 1 and `w` only in leg 2, so bidegree extraction never induces a
   convolution.
2. *The difference fiber* (note Remark 2.4). Section 2's claim that the same
   proof covers "a fixed difference with a declared finite cutoff" is **false
   for `P_N` as displayed**. `P_N` is bilinear and picks out `m+n=h`, not
   `m-n=h`; at `h=2`, `N=120` it returns the wrong fiber while the truth has
   115 pairs. The difference case needs the *sesquilinear* pairing
   `int A_z conj(A_w) e(-h alpha)`. On that operator the conclusion is
   unchanged — `E_{0,0}` still commutes and the sharp-charge value is the
   truncated gap-`h` count (both paths give 10 at `h=2`, `N=120`). So the
   no-go does extend as intended; it does not extend along the operator the
   note wrote down.
3. *The one-leg Euler product* (note Remark 3.1). Stated with no convergence
   domain. Every other identity in the note is finite, so this is the note's
   only convergence question. Correct domain: `Re(s)>1` and
   `|z|<2^{Re(s)}` — the first for `sum_p |z| p^-Re(s) < infinity`, the second
   because the `p=2` local factor is geometric. Exact witnesses at
   `Re(s)=6/5`: convergent at `|z|=2` (`2^5=32<2^6=64`), divergent at `|z|=3`
   (`3^5=243>2^6=64`). As a formal Dirichlet-coefficient identity it is
   unconditional, verified exactly for all `n<=2000`.

Forward-looking consequence of defect 3, offered to the successor lane: a
successor reaching for Selberg--Delange uniformity *in the charge variable*
meets this boundary head-on, since `|z|<2^{Re(s)}` degenerates precisely as
`Re(s)` descends toward the edge where such an estimate would need to be
useful. That sharpens section 5's demand rather than softening it.

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
- 2026-08-12: cross-lineage breaker audit by opus-mira (Claude Opus 5).
  CONFIRMED, `formalizing -> proving`. Theorems 1 and 2, all-bidegree
  commutation, and the arbitrary-coloring control replayed exactly; the
  registered statement stands unamended. Three operator-domain defects in the
  source note's prose repaired in place (Remarks 2.3, 2.4, 3.1).
