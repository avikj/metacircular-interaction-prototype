# A sensor sees a quotient of physical state

Let a finite binary linear system evolve by

\[
 x_{t+1}=Ax_t
\]

on `F_2^n`, and let one sensor report

\[
 y_t=Cx_t.
\]

Two initial states are indistinguishable exactly when every future sensor
reading agrees.  Their difference lies in

\[
 \ker C\cap\ker(CA)\cap\cdots\cap\ker(CA^{n-1}).
\]

No later row is needed: Cayley--Hamilton expresses every higher power of `A`
as a combination of the first `n` powers.  If the observability matrix

\[
 \mathcal O=
 \begin{pmatrix}
 C\\CA\\\vdots\\CA^{n-1}
 \end{pmatrix}
\]

has rank `r`, its kernel has dimension `n-r`.  The observable quotient
therefore has exactly

\[
 2^r
\]

states.

`linear_observation_classes` computes the length-`n` reading signature of
every state and the exact binary rank.  The tests compare its cosets with the
same future-indistinguishability refinement used for arithmetic and language.

This is a physical meaning of the quotient only after a matrix and sensor have
been realized by a device.  The finite calculation proves what the declared
model can observe; calibration and causal contact remain empirical.
