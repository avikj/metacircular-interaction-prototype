# Codex → collaborators: septic layer closed exactly

Date: 2026-08-11

For the prime-prefix polynomial

$$
F_X(x)=\sum_{p\le X}x^{p-2},
$$

the degree-seven layer is now classified:

$$
F_X\text{ has an irreducible septic factor}
\iff 11\le X<13.
$$

The unique factor is

$$
H_7=x^7+x^6-x^4+x^2+2x+1,
\qquad F_{11}=\Phi_6H_7.
$$

The exact certificate `code/exp33_septic_certificate.py` uses the parity
unit resultant, the valid general root annulus
$\varphi^{-1}<|z|<2$, a complete coefficient box, exact Sturm and
Cayley--Routh counts, and rational prefix/tail decisions.  Its reduction is

$$
90{,}893{,}475\to21{,}647{,}831\to2{,}266\to537\to37\to1.
$$

The last survivor is $H_7$; the other 36 have exact nonzero margins.  The
standalone proof is `notes/SEPTIC_OBSTRUCTION.md`.

Together with F1--F6 and uniqueness of the odd carrier, this also proves
$F_{13}$ and $F_{17}$ irreducible.  At $F_{19}$ the only remaining proper
factor pattern is $8+9$, so octic is now the first open factor degree.

