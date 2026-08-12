# A sensor locates the witness; an addition chain forms it

For positive (a,b), prime (p), and (v=v_p(a+b)), the first positive
one-sided critical witness is the least positive representative

\[
r\equiv-a\pmod {p^{v+1}},\qquad 1\le r\le p^{v+1}.
\]

Residue arithmetic, CRT, or kuṭṭaka can determine this integer exactly. That
does not by itself form the integer inside an arithmetic life. A constructor
is still required.

## Binary addition-chain certificate

Write the binary expansion of (r) as (1b_2\cdots b_ell). Begin with the
formed unit (z=1). Reading the remaining bits left to right, replace

\[
z\leftarrow z+z,
\]

and, when the next bit is one, replace

\[
z\leftarrow z+1.
\]

Every operand in every step has already been formed. Induction on the binary
prefix proves that the current (z) is the integer represented by that prefix;
the terminal value is (r). The exact number of additions is

\[
L_2(r)=\lfloor\log_2r\rfloor+\operatorname{popcount}(r)-1.
\]

This is an explicit upper bound, not the optimal addition-chain length.

Successor alone takes (r-1) applications from (1). The binary chain ties
successor exactly for (r=1,2,3) and is strictly shorter for every (r\ge4).
Indeed, if (m=\lfloor\log_2r\rfloor\), then

\[
L_2(r)\le2m.
\]

For (m\ge2), (2m\le2^m\le r), with equality in the first inequality only
at (m=2). Directly at (r=4), (L_2(4)=2<3); for all other (r\ge4), the
inequality is also strict against (r-1). The cases below four are immediate.

## Composed witness certificate

The complete proof object has two typed halves:

1. **location:** (rin[1,p^{v+1}]) and (a+r\equiv0\pmod {p^{v+1}});
2. **construction:** a list of addition events beginning at (1), each using
   only earlier values, and ending at (r).

The first proves that the target is a critical witness. The second proves that
the organism possesses it. Neither half implies the other.

The addition count obeys

\[
L_2(r)\le 2\lfloor\log_2(p^{v+1})\rfloor,
\]

so earned addition turns the exponential successor bound in digit depth into
a linear upper bound in (v+1), with coefficient (2\log_2p). This counts
addition events, treating (z+z) as one use of the already primitive addition
operation. It makes no bit-complexity or parallel-depth claim.

Nor does it price reversible overwrite memory. Concurrent
`DEPTH_MEMORY_NONMONOTONICITY` proves that semantic depth and maximum chart
fiber size can move oppositely. The addition-chain length belongs to the
acquisition/construction coordinate; coherent memory must be recomputed from
the current fiber profile.

## Rigor boundary

The construction and comparison are proved above. Exact tests replay every
dependency and verify the critical congruence over bounded inputs. No claim is
made that the binary method is optimal, or that CRT/kuṭṭaka has been earned in
every state where addition has been earned.
