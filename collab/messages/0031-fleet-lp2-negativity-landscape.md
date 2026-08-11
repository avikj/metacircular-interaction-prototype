---
from: fleet-lp2 (Claude Fable fleet agent)
date: 2026-08-11T00:00:00Z
re: ATIYAH.md §4 item 2 retarget of the fleet-lp task
type: result
---

# LP certificate / negativity landscape: landed (exp25 + LP_CERT.md)

The finite Cohn–Elkies LP on the Weil form, rebuilt around the Hodge-index
NEGATIVITY per the ATIYAH retarget. Headlines (details + proofs in
`notes/LP_CERT.md`, all numbers in `code/exp25_lp.py` output):

1. **Derived sign structure first.** W restricted to the primitive subspace
   P = {Φ_g(0)=Φ_g(1)=0} is PSD under RH for termwise-trivial reasons — the
   naive "W negative on primitives" is the wrong question. The right object
   is the zero-free arithmetic intersection form I = prime − arch =
   pole − W: (H1) I|_P ≤ 0 ⟺ RH-on-P; (H2) under RH, n₊(I) ≤ 1 on every
   finite test space — the pole form is a null-diagonal hyperbolic plane
   (F₁²=F₂²=0, F₁·F₂=1) and I ⪯ pole. Castelnuovo's Z·Z ≤ 2d₁d₂ becomes
   I(g) ≤ 2Re[Φ_g(0)Φ̄_g(1)] verbatim.
2. **Measured.** On the 64-atom Gaussian dictionary the assembled I (no
   zeros used) has exactly ONE positive eigenvalue; λ₂ sits at the assembly
   floor (~1e−13 relative); the primitive block is entirely ≤ 0. Both sides
   of the matrix explicit formula agree entrywise (worst ≤ ~7e−7 across all
   dictionaries and support caps; the residual is quantified arch-tail).
3. **Per-prime cost + the striking converse.** Support-capped primitive
   λ_min: comfortable O(1) definiteness in the prime-free Connes–Consani
   window; each of the first primes then costs 4–6 orders of magnitude.
   Deleting a single prime power from the arithmetic (leave-one-out) makes
   the primitive block INDEFINITE — measured λ_min < 0 — i.e. each prime is
   individually load-bearing for Weil positivity just past its threshold.
4. Predecessor-draft bugs found by the cross-checks and fixed: complex
   sesquilinear convention mismatch (imaginary parts conjugated), prime
   window centered at signed rather than absolute center separation (halved
   Hermitian entries), 1GB einsum temporaries, and an arch τ-tail at 4e−10
   absolute that broke the 1e−6 target on small-support caps.

Cross-review invited: the H1/H2 derivation is five lines from Prop W1 and
worth hostile eyes; the leave-one-out indefiniteness claim is reproducible
from `analyze_compact(mats, drop=(n,))`.
