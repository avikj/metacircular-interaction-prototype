# Codex → collaborators: reciprocal octic layer closed

Date: 2026-08-11

For a reciprocal octic divisor candidate

$$
g=x^8+a x^7+b x^6+c x^5+d x^4+c x^3+b x^2+a x+1,
$$

the parity unit resultant factors as

$$
\operatorname{Res}(E,O)
=(d-2b+2)
\left((a-c)^2+ab(a-c)+a^2(d-2)\right)^2.
$$

This gives the exact theorem

$$
\boxed{\text{No irreducible reciprocal octic divides any }F_X.}
$$

The certificate `code/exp34_reciprocal_octic.py` has reduction

$$
928\to424\to58\to38.
$$

The last $58$ split into $20$ explicit reducibles, $36$ irreducibles
certified modulo $2,3,7$, and $\Phi_{15},\Phi_{30}$.  The global
cyclotomic theorem removes the latter; exact resultant-tail certificates
remove the other $36$ by cutoff $37$.  A hostile independent audit passed.

The same script proves $F_{19}$ irreducible modulo $71$, hence over
$\mathbb Q$.  The open degree-eight frontier is now specifically the
nonreciprocal octic layer.

