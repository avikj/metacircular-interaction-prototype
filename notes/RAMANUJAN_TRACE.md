# Ramanujan sums: divisor convolution is a cyclotomic trace

Status: exact CPU certificate for a classical identity. No novelty claim.

For a primitive `q`-th root of unity `zeta_q`, the Ramanujan sum has two
native presentations:

    c_q(n) = sum_(d | gcd(q,n)) d mu(q/d)
           = Tr_(Q(zeta_q)/Q)(zeta_q^n).

The first is an arithmetic divisor convolution. The second is a spectral
trace: multiplication by `zeta_q^n` acts on the cyclotomic field, and its
eigenvalues over the complex numbers are the primitive-character phases
`zeta_q^(an)` for units `a mod q`. Their sum is `c_q(n)`.

The executable construction does not use floating-point roots. It builds the
cyclotomic polynomial recursively from

    x^q - 1 = product_(d|q) Phi_d(x),

reduces `x^n` in the exact integer basis of `Q[x]/Phi_q`, constructs its
multiplication operator, and takes the integer matrix trace. Independently it
computes the divisor-convolution formula using exact Möbius values.

For `q=12`, `Phi_12=x^4-x^2+1`, and both routes return

    (c_12(0),...,c_12(11))
      = (4,0,2,0,-2,0,-4,0,-2,0,2,0).

This is more structured than the preceding permutation trace. The spectral
carrier has dimension `phi(q)`, selects precisely the primitive frequencies,
and the Möbius weights are the arithmetic projector onto that primitive
spectrum.

## False control: the carrier matters

Replacing `Q[x]/Phi_q` by the full group algebra `Q[x]/(x^q-1)` includes all
`q`-th roots. Its regular trace of multiplication by `x^n` is `q` when
`q|n` and zero otherwise. At `q=12`, the trace vector begins `(12,0,...)`, not
`(4,0,2,...)`. ~~Thus Fourier language alone is insufficient:~~ the cyclotomic
primitive-spectrum projection is the exact content.

> **Struck (SEED-105, Rule K1/K3, 2026-08-14, applying
> `notes/SEED53_PRATIYOGIN_OF_THE_PRIMITIVE_PROJECTOR.md` §4.3, produced
> 2026-08-14 and not applied here).** Same defect as
> `PRIMITIVE_CHARACTER_PROJECTOR.md`'s "Fourier phases alone also do not
> suffice", and struck for the same reason: the Ramanujan sum *is* a Fourier
> sum, and SEED-53 Theorem Ψ writes the whole projector in closed form inside
> `ℤ[x]`. What fails is the **carrier** — an unweighted finite `C_q`-set — not
> the language. Corrected sentence: *the full group algebra's unweighted
> regular trace is `(q,0,…)`, so no unweighted finite `C_q`-set realises `c_q`;
> the cyclotomic primitive-spectrum projection is the exact content.*
> Note also SEED-53 §4.4: this note's carrier `ℚ[x]/Φ_q` and `e_prim`'s image
> `ℚ[x]/(x^q−1)·e_prim` are the **same** `ℚ`-algebra, Theorem Ψ being the
> isomorphism; the two notes are one theorem and neither said so.

This is a finite character/trace identity, not Atiyah–Singer or a claim of a
new trace formula.

Replay:

    python3 machinery/ramanujan_trace.py
    python3 -m unittest machinery/test_ramanujan_trace.py -v

Signed: codex-vajra, 2026-08-12.
