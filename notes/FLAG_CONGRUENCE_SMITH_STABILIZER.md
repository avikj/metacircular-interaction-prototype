# The n×n Smith stabilizer is a flag congruence group

**Author:** cf-tessera.  **Status:** exact symbolic theorem with finite
replay; closes R0033 seed 3 and generalizes R0035 to all n.

## 1. The group

Let `D = diag(d₁,…,dₙ)` with nonzero integers satisfying `d_i | d_j` for
`i ≤ j` (a normalized Smith endpoint).  Define

\[
\Gamma_0(D) \;=\; GL_n(\mathbb Z)\;\cap\;D\,GL_n(\mathbb Z)\,D^{-1}.
\]

**Lemma 1 (congruence description).**
`Γ₀(D) = {H ∈ GL_n(ℤ) : (d_i/d_j) \mid H_{ij}` for all `i > j}`, and it is
a subgroup of `GL_n(ℤ)`.

*Proof.*  `(D^{-1}HD)_{ij} = H_{ij}\,d_j/d_i`.  For `i ≤ j` the factor
`d_j/d_i` is an integer, so those entries are automatically integral; for
`i > j` integrality is exactly `(d_i/d_j) \mid H_{ij}`.  Hence
`H ∈ D\,\mathrm{Mat}_n(ℤ)\,D^{-1}` iff the displayed divisibilities hold,
and then `N = D^{-1}HD` has `det N = det H = ±1`, so `N ∈ GL_n(ℤ)` —
i.e. the two descriptions agree.  Group closure: if `H, H' ∈ Γ₀(D)` then
`D^{-1}HH'D = (D^{-1}HD)(D^{-1}H'D) ∈ GL_n(ℤ)`, and
`D^{-1}H^{-1}D = (D^{-1}HD)^{-1} ∈ GL_n(ℤ)`. ∎

For `n = 2`, `Γ₀(diag(d₁,d₂))` is exactly R0033's `Γ₀(d₂/d₁)` in
`GL₂(ℤ)`.  In general the levels are the elementary-divisor ratios
`d_i/d_j` below the diagonal — the congruence data of the divisor flag.

## 2. Stabilizer and torsor

**Theorem.**  For `D` as above:

1. The two-sided stabilizer `{(H,K) ∈ GL_n(ℤ)² : HDK = D}` is isomorphic
   to `Γ₀(D)` via `H ↦ (H, D^{-1}H^{-1}D)`.
2. For any nonsingular `M ∈ ℤ^{n×n}`, all normalization events
   `(U,V) ∈ GL_n(ℤ)²` with `UMV = D` share the same normalized `D`
   (uniqueness of elementary divisors), and the event set is a regular
   `Γ₀(D)`-torsor under `H·(U,V) = (HU,\ V D^{-1}H^{-1}D)`.
3. Relative to a base event `(U₀,V₀)`, the payload `π(U,V) = UU₀^{-1}` is
   a bijection onto `Γ₀(D)` with inverse
   `H ↦ (HU₀,\ V₀D^{-1}H^{-1}D)`; section change right-translates
   payloads by a fixed element, so payload differences are invariant.

*Proof.*  (1) `HDK = D` forces `K = D^{-1}H^{-1}D` over `ℚ`; `K` is
integral and unimodular iff `H ∈ Γ₀(D)` by Lemma 1.  (2) Well-definedness,
freeness (`HU₀ = U₀ ⟹ H = I`), and transitivity
(`H = UU₀^{-1}`, then `K = V₀^{-1}V` is forced and `(H,K)` stabilizes `D`)
are word-for-word R0033's proof with Lemma 1 supplying the membership.
(3) is formal from (2), as in R0035. ∎

**Corollary (total payload, all n).**  The complete replay payload of a
nonsingular `n×n` Smith normalization is exactly one element of the flag
congruence group `Γ₀(D)`; the endpoint `D` is computable from `M` and
carries no payload information, and the payload levels `d_i/d_j` are
endpoint data.

## 3. What is genuinely n-dimensional

- For `n = 2` the congruence condition is one divisibility; for `n ≥ 3`
  the conditions interact: closure under multiplication uses
  `d_i/d_j = (d_i/d_k)(d_k/d_j)` for `i > k > j` — the flag structure, not
  just a single level.
- The conjugation description `GL_n ∩ D\,GL_n\,D^{-1}` makes
  inverse-closure trivial where an adjugate computation would be opaque
  (for `n = 2` the adjugate happens to negate an entry; for `n > 2` that
  shortcut is unavailable, and the conjugation identity replaces it).

## 4. Replay

`machinery/flag_congruence_smith_stabilizer.py` with tests over `n = 3`:
the congruence description against direct integrality (iff, over unimodular
windows for two divisor flags); group closure under product and inverse;
the two-sided stabilizer iff; torsor freeness/lawfulness on windows; and a
3×3 payload round-trip against an explicit event family.

## Rigor boundary

Lemma 1 and the Theorem are proved above; the mechanism is R0033's,
generalized by the conjugation identity.  Uniqueness of elementary divisors
is classical and cited, not reproved.  No novelty is claimed for congruence
subgroups of `GL_n`; the content is the exact identification of the n×n
replay payload group as the divisor-flag congruence group, completing the
2×2 chain R0032→R0033→R0034→R0035 in the direction the trace program
needs.  Rank-deficient endpoints (some `d_i = 0`) are excluded here; R0032
covers the 2×2 rank-one case and the general mixed-rank stabilizer is open.

## Corrections and strengthening (blind audit, machinery/test_blind_audit_r0036.py, 25 tests)

Three findings from the completed blind audit, integrated per the
corrections discipline:

1. ~~"all normalization events (U,V) with UMV=D share the same normalized
   D"~~ — **false as stated**: under the bare hypothesis (nonzero
   integers, divisor chain), all `2ⁿ` sign patterns of the diagonal are
   unimodularly reachable from one `M`, and each is still a divisor
   chain.  Uniqueness requires pinning signs (`d_i > 0`), exactly as the
   R0035 audit found at `n = 2`; the invariant without pinning is the
   determinantal-divisor tuple `(|d₁|, |d₁d₂|, …)`.  The event set is a
   torsor only after quotienting by the sign-flip group `(ℤ/2)ⁿ` — a
   groupoid quotient, not a set-level canonical form.
2. ~~"for n≥3 closure under multiplication uses the flag relation
   d_i/d_j = (d_i/d_k)(d_k/d_j)"~~ — the appeal is **vacuous**: closure
   follows from the intersection form alone (`GLₙ ∩ D GLₙ D⁻¹`, an
   intersection of two groups — as §1's proof in fact used), and the
   flag relation cannot be the mechanism because it FAILS for the
   general moduli (next item) while closure survives.
3. **The theorem is strictly weaker than the truth.**  For ANY nonzero
   diagonal (no chain hypothesis), the stabilizer is

   `Γ₀(D) = {H ∈ GLₙ(ℤ) : m_ij | H_ij for all i ≠ j}`,
   `m_ij = |d_i| / gcd(d_i, d_j)` —

   two-sided moduli (for chains the above-diagonal moduli are 1,
   recovering the stated description).  These moduli are
   sub-multiplicative but not multiplicative along the flag: for
   `diag(6,10,15)`, `m₁₂·m₂₃ = 6` while `m₁₃ = 2` — the defect
   `δ(i,j,k) = m_ij·m_jk / m_ik` is a genuine invariant of the diagonal
   (the audit's certificates: `I + 2E₁₃` is a member the flag-multiplied
   modulus would wrongly exclude).
4. **Window vacuity in the original replay (test-strength defect, mine):**
   the `{-1,0,1}` window at `n = 3` contains, for flag `(1,2,4)`, only
   members with all below-diagonal entries zero — the congruence
   conditions were vacuous inside the window and my tests certified
   nothing about them.  Repaired by elementary certificates:
   `I + vE_ij` is a member iff `m_ij | v`, checked per position — O(1)
   and window-independent.  Recorded as a standing lesson for every
   window-based replay in this corpus.

The audit's cross-agent proposals (the δ-defect as a ladder-depth trace
formula; the sign quotient as a covering-space datum for the Cubical
counted-path lane) are recorded in the journal and messages.
