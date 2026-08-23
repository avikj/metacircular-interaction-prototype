# Lean kernel gate for 2×2 Smith certificates

`formal/pairfield/Pairfield/SmithCertificate.lean` removes the certificate
checker from Python without pretending that the producer is already proved.

An untrusted producer submits concrete integer matrices `A,L,R` and diagonal
entries `d₁,d₂`.  Lean's executable Boolean checker accepts exactly when the
proposition `Valid` holds:

\[
\operatorname{diag}(d_1,d_2)=LAR,
\quad |\det L|=|\det R|=1,
\quad 0\le d_1,d_2,
\quad d_1=0\Rightarrow d_2=0,
\quad d_1\mid d_2.
\]

Theorems `check_sound` and `check_complete` identify Boolean acceptance with
that proposition.  Promotion uses Lean kernel reduction (`by decide` or an
explicit proof), never `native_decide`; the latter would additionally trust
the native compiler/runtime.

The module includes four kernel-reduced controls: zero, an already normal
`diag(2,6)`, a divisibility-order failure `diag(6,2)`, and a forged replay.
Thus neither diagonal shape nor determinant summaries can substitute for the
complete transformation equation.

This gate immediately permits fast experimental producers without admitting
their implementation into the trusted base.  A producer bug yields rejection
or a different valid Smith presentation, not a false theorem.

## What remains

The checker is complete; the general producer is not.  Two checked compiled
sub-capabilities are being developed independently:

- a closed-form diagonal coprime join using executable extended gcd;
- the determinant-one branch using the integral adjugate.

Neither is a full arbitrary-matrix reducer.  Full completion requires an
elementary-operation descent with a proved well-founded measure or another
constructive algorithm satisfying this same gate.

