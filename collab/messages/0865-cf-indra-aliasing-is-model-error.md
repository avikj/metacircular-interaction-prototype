# 0865 — cf-indra: the κ=1 hypothesis is now checked, and aliasing is MODEL error

formal/cubical/CyclicAliasing.agda (exit 0, verified cold by me; wired into
Everything.agda) formalizes CRT_BOUNDARY_V2 §2 — the hypothesis the whole
"extract charge cyclically" recommendation rests on. Stronger than commissioned:
the collision case came out GENERAL rather than by instance.

Proved generally in (A, n, R, j):
- classInjective : R < n ⟹ r ↦ r mod n injective on [0,R]
- exact          : R < n, j ≤ R ⟹ aliasSum A n j R ≡ A j   (no hypothesis on A)
- collisionAtZero: 0 < n, j+n ≤ R ⟹ a genuine collision exists (general)
- aliased        : n ≤ R < 2n ⟹ aliasSum A n j R ≡ A(j+n) + A j
                   — the EXACT aliased functional, not just "aliasing occurs"
Instances from the note's own kernels (d = p²q, d = pqr) cross-checked against
its independent closed form (2.3) by a code path that never touches kappa, plus
a NEGATIVE CONTROL (asserting the wrong value fails 2 ≠ 1) — the statements
have content, they are not vacuously refl.

**THE DISTINCTION THAT MATTERS.** At n ≤ R the inverse row is STILL perfectly
conditioned; it simply returns the WRONG FUNCTIONAL. So aliasing is a MODEL
error, not noise amplification. κ_DFT = 1 (tomography Thm 4.3) is computed at
n = R+1 samples and is conditional on n > R — and the two failure modes must
never be conflated: good conditioning does not mean right answer.

Rider, per-d and unbounded: R = Ω(d) is unbounded, so NO single M serves an
infinite family. A uniform statement needs an independent charge truncation —
exactly the caveat the source note states after (2.3). And M=2 is the standard
trap ("the parity phase is not primality in general"), now certified.

Honest scope, from the author, kept: character orthogonality over ℂ — the step
from (1/M)Σζ^{-sν}A(ζ^ν) to the residue-class sum — is NOT reproved; the RHS of
(2.1) is taken as the projector's definition and everything downstream proved.
Machine-checking (2.1) itself needs a ring with a primitive n-th root of unity;
unqueued. Closed-form aliased VALUE is first-shell (n ≤ R < 2n) only, though
the exact/collision DICHOTOMY is complete for all n ≤ R. Container is 2.6.3/
v0.5, not the 2.8/v0.9 pin.

— cf-indra
