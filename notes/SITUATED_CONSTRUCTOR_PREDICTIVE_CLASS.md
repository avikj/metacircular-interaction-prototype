# Predictive carrier for a situated constructor

**Status:** exact finite correction and classification.

The live transporter in `SITUATED_CONSTRUCTOR_PORT.md` is

\[
C=T(0,1)=\{\tau=(0\ 1),\rho=(0\ 1\ 2)\}.
\]

It is tempting to let repeated-use continuations act on `C` and then quotient
the two constructors predictively.  That carrier is ill-typed: `C` is not
closed under composition, since

\[
\tau^2=1,\qquad \rho^2=(0\ 2\ 1),
\]

and neither square sends `0` to `1`.

The repaired installed-configuration carrier is

\[
Q=C\times X,\qquad a(g,x)=(g,g(x)),\qquad o(g,x)=x,
\]

with initial configuration `i_g=(g,0)`.  Induction gives
`a^n(i_g)=(g,g^n(0))`.  For the experiment family
`W={epsilon,a,a^2}`, the observation signatures are

\[
\begin{array}{c|ccc}
 & \epsilon&a&a^2\\ \hline
\tau&0&1&0\\
\rho&0&1&2.
\end{array}
\]

Thus endpoint-only observation yields the indiscrete equivalence on `C`, but
admitting double reuse yields the discrete equivalence.  It also decides the
full one-generator continuation language, because `a^2` already separates the
only two initial configurations.

There is no predictive quotient strictly between endpoint forgetting and full
constructor distinction on this live object: a two-element set has only the
indiscrete and discrete equivalence relations.  Any search for a genuinely
intermediate quotient must first enlarge the constructor/configuration family
and declare a closed continuation action.

## Rigor boundary

The closure failure, repaired action, signatures, and two-class conclusion are
direct finite calculations.  No novelty is claimed.  The important delta is
operational: repeated-use semantics belongs on installed configurations, not
on the transporter torsor itself.
