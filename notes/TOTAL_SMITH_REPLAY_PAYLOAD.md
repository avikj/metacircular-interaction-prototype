# The total replay payload of a 2×2 Smith normalization event

**Author:** cf-tessera.  **Status:** exact symbolic theorem with finite
replay; synthesis of R0032/R0033/R0034.

The repository's replayable-normalizer lane asked for a signed, indexed,
replayable trace of Smith normalization.  R0033 gave the local answer for
one diagonal step; R0034 gave the global endpoint geometry.  This note
states the complete payload for a full normalization event and gives the
constructive section that makes it computable.

## 1. Events and the payload theorem

> **Naming correction (seed125 audit, 2026-08-14) — the noun, not the
> mathematics.** Every `Γ₀(m)` below means
> `Γ₀^±(m) = {H ∈ GL₂(ℤ) : m ∣ H₂₁}`, not the classical `Γ₀(m) ⊂ SL₂(ℤ)`.
> The note's own addendum exhibits `diag(1,−1)` as an element (§ "Addendum",
> item 1), and `det diag(1,−1) = −1`, so under the standard name the torsor
> claim (2) and the bijection (3) would both be false: `U U₀^{-1}` has
> determinant `±1`, not `1`. Under `Γ₀^±(m)` the Theorem is correct exactly as
> written, and the addendum's determinant-freedom claim is precisely the
> statement that `det : Γ₀^±(m) → {±1}` is onto. Inherited from R0033
> (`notes/DIAGONAL_SMITH_CONGRUENCE_TORSOR.md` §1), corrected there too.

Fix a nonsingular `M ∈ ℤ^{2×2}`.  A **normalization event** is a triple
`(U, V, D)` with `U, V ∈ GL₂(ℤ)`, `U M V = D`, and `D = diag(e₁, e₂)`
normalized (`e₁, e₂ ≥ 1`, `e₁ | e₂`).

**Theorem.**  Let `(e₁, e₂)` be the elementary divisors of `M` and
`m = e₂/e₁`.  Then:

1. Every event has the same `D = diag(e₁, e₂)` (uniqueness of Smith form),
   so events are pairs `(U, V)` with `U M V = diag(e₁,e₂)`.
2. The event set is a regular `Γ₀(m)`-torsor under
   `H·(U,V) = (HU, V D⁻¹H⁻¹D)` (R0033, Theorem 2 — its proof used only
   `d₁, d₂ ≠ 0`, not the classical Bézout cell).
3. Fixing any base event `(U₀, V₀)` — a **section** — the payload map

   \[
   \pi(U,V) \;=\; U U_0^{-1} \;\in\; \Gamma_0(m)
   \]

   is a bijection from events to `Γ₀(m)`, with explicit replay

   \[
   \pi^{-1}(H) \;=\; \bigl(H U_0,\; V_0\, D^{-1} H^{-1} D\bigr).
   \]

*Proof.*  (1) is the uniqueness of elementary divisors.  (2) is R0033
Theorem 2 verbatim.  (3): transitivity makes `π` surjective, freeness makes
it injective, and the displayed inverse is the torsor action at `H`. ∎

**Corollary (information split).**  The event decomposes as

\[
(U,V) \;\longleftrightarrow\; \underbrace{(e_1, e_2)}_{\text{endpoint, determined by } M}
\times \underbrace{H \in \Gamma_0(e_2/e_1)}_{\text{path, invisible to the endpoint}} ,
\]

and the two factors carry disjoint information: the endpoint is computable
from `M` alone (so a trace need not store it), while by R0027/R0032/R0033
no endpoint observation constrains `H`.  **The total replay payload of a
2×2 nonsingular Smith normalization is exactly one `Γ₀(e₂/e₁)` element
relative to a fixed section.**  It is *signed* (`H` determines `det U`,
which is not endpoint-recoverable), *indexed* (the congruence level
`m = e₂/e₁` is the elementary-divisor ratio), and *replayable* (the
displayed `π⁻¹`).

## 2. The constructive section

A section must itself be computable, else the payload is relative to
nothing.  The exact Euclidean normalizer `smith_2x2`
(`machinery/hecke_coset_smith_assembly.py`), a deterministic sequence of
row/column reductions, is such a section: for each `M` it returns one
`(U₀, V₀)` with `U₀ M V₀ = diag(e₁, e₂)`.  Determinism makes `π`
well-defined across runs; changing the section to `(U₀', V₀')` right-
translates every payload by the fixed element `g = U₀U₀'^{-1} ∈ Γ₀(m)`
(`π'(U,V) = π(U,V)\,g`), so payload *differences* `π(x)π(y)^{-1}` are
section-independent.

## 3. Composite events and cell payloads

A multi-step normalization (a composite of R0033 cells) multiplies its cell
transforms; the payload of the composite is the product of the images of
the cell payloads under the same `π`.  In particular the Bézout datum of a
classical diagonal cell enters as the unipotent part (R0033 Theorem 3), and
recording only Bézout data drops exactly the non-unipotent quotient — the
gap witness `diag(1,−1)` survives composition.

## 4. Boundary of the theorem

- `det M = 0` with `M ≠ 0` (rank one): the event set is the one-sided
  `D_∞`-torsor of R0032 extended by the free right factor; the two-sided
  statement above requires `e₂ ≠ 0`.  `M = 0` is fully degenerate
  (`GL₂ × GL₂`).
- `n × n` for `n > 2`: the expected stabilizer is the block congruence
  group of all ratios `e_j/e_i`; open (R0033 seed 3).

## 5. Replay

`machinery/total_smith_replay_payload.py` with tests: for a grid of
nonsingular `M`, every window event has the predicted `D`; payload/replay
round-trips both ways; payloads land in `Γ₀(m)` and differences are
section-independent; and a composite-of-cells payload multiplies.

## Rigor boundary

The theorem and corollary are proved above from R0033 Theorem 2 plus Smith
uniqueness; both ingredients are classical and the synthesis claims no
novelty.  The section-dependence analysis is exact.  The `n > 2` and
rank-degenerate boundaries are stated as open or referred to R0032.  The
Agda formalization of the payload type remains blocked on a local Agda 2.8
toolchain (CI does not check Agda; this container has none), and is the
recorded next formal step, not an assumption used anywhere above.

## Addendum (blind audit, msg 0444)

Precisions from the blind-context audit, all additions: (1) the
determinant pair obeys `det U · det V = sign(det M)` exactly, while each
factor separately is free (~~`diag(1,−1) ∈ Γ₀(m)`~~ `diag(1,−1) ∈ Γ₀^±(m)`,
see the naming correction at the head of §1) — this is the sharp form
of "the sign is payload data"; (2) "normalized" must state positive
diagonal entries: `diag(−e₁,e₂)` is unimodularly reachable and satisfies
integer divisibility, so positivity is load-bearing and a deterministic
section needs a sign-fix pass when `det M < 0`; (3) the section-change
translator is one fixed `Γ₀(m)` element per matrix `M`, not global; the
translation is on the right — the left version provably varies over
events; (4) certified minimal entry bounds for event windows reach 3
already for `diag(2,−3)`; small-window enumerations are not adequate in
general.
