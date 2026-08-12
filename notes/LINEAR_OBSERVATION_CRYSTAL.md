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

The same theorem can run backward as instrument design.  Given a finite list
of candidate sensor rows, `minimal_sensor_sets` returns every smallest family
whose accumulated future readings have rank `n`.  It works on the observation
rows directly; the theorem removes enumeration of all `2^n` physical states.
A cyclic shift of three bits
needs any one coordinate sensor: motion carries all coordinates past it.  A
static three-bit system needs all three coordinate sensors.  What must be seen
is therefore a property of sensor and dynamics together, not of the sensor
alone.
