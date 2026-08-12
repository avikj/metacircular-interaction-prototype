# Elementary operations earn the Smith path

A supplied identity `UAV=D` certifies a presentation change but does not show
how the arithmetic organism formed it. The first causal refinement is a path
of elementary integer-unimodular operations.

Three step types suffice for the present example:

- negate one row;
- add an integer multiple of one row to the other;
- add an integer multiple of one column to the other.

Every step has an explicit inverse: negation is self-inverse and a shear with
multiple `q` is inverted by the shear with `-q`. Row steps multiply on the
left and accumulate into `U`; column steps multiply on the right and
accumulate into `V`.

For

\[
A=\begin{pmatrix}2&4\\6&8\end{pmatrix},
\]

execute:

1. `R_2 <- -R_2`;
2. `R_2 <- R_2+3R_1`;
3. `C_2 <- C_2-2C_1`.

The intermediate matrix after step 2 is `diag(2,4)` except for its upper-right
entry 4; step 3 removes that entry. Accumulation gives exactly

\[
U=\begin{pmatrix}1&0\\3&-1\end{pmatrix},\qquad
V=\begin{pmatrix}1&-2\\0&1\end{pmatrix},\qquad
UAV=\operatorname{diag}(2,4).
\]

Reversing the step list and applying each stored inverse reconstructs `A`
exactly. Thus the final certificate is now earned by a replayable path. A
control replacing coefficient 3 by 2 misses the declared diagonal and is
rejected before any modular target is solved.

## Rigor boundary

The matrix multiplication and inverse formulas prove every transition. The
executable verifies each composition over the integers, not modulo a sampled
range. This is a certificate language and one path, not yet an algorithm for
choosing reducing steps or proving termination of a general Smith procedure.
