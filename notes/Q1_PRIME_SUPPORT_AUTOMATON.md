# The first decic support automaton is a filter, not an exclusion

Let

$$
F_X(x)=\sum_{p\leq X}x^{p-2},\qquad
q_1(x)=x^{10}+x^8+x^2+x+1.
$$

This note couples the sharp-cage witness from
`NONRECIPROCAL_DECIC_FRONTIER.md` to the actual ordered prime support.  The
result is an exact negative theorem about the first tempting finite-state
strategy, followed by the residual condition that a stronger strategy must
solve.

## 1. Exact mod-2 automaton

Over $\mathbf F_2$ one has

$$
q_1=(x^3+x^2+1)(x^7+x^6+x^4+x+1)=:f_3f_7. \tag{1.1}
$$

The class of $x$ has exact order $7$ modulo $f_3$ and exact order $127$
modulo $f_7$.  Both numbers are prime.  Consequently its order modulo $q_1$
is

$$
\boxed{\operatorname{ord}_{q_1,2}(x)=\operatorname{lcm}(7,127)=889.} \tag{1.2}
$$

These are algebraic order certificates, not an observed recurrence: direct
binary polynomial reduction gives $x^7=1\pmod {f_3}$ and
$x^{127}=1\pmod {f_7}$, while $x\ne1$ in either quotient.  The replay also
checks $x^{889}=1\pmod {q_1}$ and checks nonidentity at the two prime-index
quotients $889/7$ and $889/127$.

There is a smaller exact description than a nominal 889-bin state.  Put

$$
N_{m,r}(X)=\#\{p\leq X:p-2\equiv r\pmod m\},
\qquad
A_{m,X}(T)=\sum_{r=0}^{m-1}(N_{m,r}(X)\bmod2)T^r.
$$

The Chinese-remainder decomposition in (1.1) gives the equivalence

$$
\boxed{
q_1\mid F_X\pmod2
\iff
f_3\mid A_{7,X} \text{ and }\ f_7\mid A_{127,X}.
} \tag{1.3}
$$

Thus the period-889 remainder machine is exactly ten parity syndromes: three
on the marginal prime counts modulo $7$ and seven on the marginal counts
modulo $127$.  It does not require the full joint 889-bin histogram.

## 2. The cross-collision constraint modulo 7

The cross-reversal index $L=-7$ exposes the common factor

$$
\gcd(q_1,q_1^*)=x^2+4x+1\pmod7.
$$

If $\beta^2+4\beta+1=0$, then

$$
\beta^3=\beta+4,\qquad \beta^4=-1,
$$

so $\beta$ has order $8$.  Let $c_j$ count the odd primes $p\leq X$ for
which $p-2\equiv j\pmod8$, with $j\in\{1,3,5,7\}$.  Remembering the
constant contribution from $p=2$, the equation $F_X(\beta)=0$ becomes

$$
\begin{aligned}
c_1+c_3-c_5-c_7&=0\pmod7,\\
1+4(c_3-c_7)&=0\pmod7.
\end{aligned}
$$

Equivalently,

$$
\boxed{c_3-c_7=5,\qquad c_1-c_5=2\pmod7.} \tag{2.1}
$$

This is a genuine prime-support constraint created by the nonunit cross
index.  It is still not an exclusion.

## 3. A genuine prefix passes all three filters

The exact cutoff

$$
\boxed{X_0=246709,\qquad \pi(X_0)=21770\equiv5\pmod {15}} \tag{3.1}
$$

simultaneously has

$$
F_{X_0}\equiv0\pmod{(2,q_1)}
$$

and satisfies (2.1).  In fact it is the first prime cutoff at which the
endpoint tether $\pi(X)\equiv5\pmod {15}$ and the complete mod-2 remainder
zero coincide.  At this cutoff the parity masks for exponents modulo $7$ and
$127$ are respectively

$$
\mathtt{0x72},\qquad
\mathtt{0x6d55b782aa94645bd5f1ae45b2c4e39a},
$$

and

$$
(c_1,c_3,c_5,c_7)\equiv(1,2,6,4)\pmod7.
$$

Therefore the package

$$
\{\text{endpoint tether},\ \text{full mod-2 state},\
  \text{cross-collision mod-7 state}\}
$$

cannot prove an all-$X$ exclusion: a real prime prefix inhabits its proposed
forbidden state.

This is **not** evidence that $q_1$ divides $F_{X_0}$.  Full reduction modulo
$3$ gives, in ascending powers,

$$
F_{X_0}\bmod(3,q_1)
=(1,1,1,0,0,0,1,1,2,0)\ne0. \tag{3.2}
$$

Hence $q_1\nmid F_{X_0}$ over $\mathbf Z[x]$.

## 4. The next exact state and its certificate

Modulo $3$, the class of $x$ has exact order

$$
\boxed{19682=2\cdot13\cdot757} \tag{4.1}
$$

in $\mathbf F_3[x]/(q_1)$.  A compact order certificate is

$$
x^{19682}=1,
$$

while reduction at the three prime-index quotients gives

$$
\begin{aligned}
x^{9841}&=2,\\
x^{1514}&=x+2x^2+x^4+x^9,\\
x^{26}&=2+x+x^2+2x^3+x^5+x^6+2x^7,
\end{aligned}qquad\pmod{(3,q_1)} \tag{4.2}
$$

none of which is $1$.  Thus a mod-3 streaming state needs only the exponent
$p-2\pmod {19682}$ at each prime event; (3.2) is independently replayable
without constructing the enormous integer polynomial $F_{X_0}$.

More generally, for a prime $\ell$ let $R_\ell=\mathbf F_\ell[x]/(q_1)$
and let $T_\ell$ be the finite order of the unit $x\in R_\ell$.  Then

$$
q_1\mid F_X\pmod\ell
\iff
\sum_{a=0}^{T_\ell-1}
 \#\{p\leq X:p-2\equiv a\pmod {T_\ell}\}\,x^a=0
 \quad\text{in }R_\ell. \tag{4.3}
$$

Equation (4.3) is the sharply characterized residual arithmetic condition.
It converts divisibility into a bounded-memory exact stream, but it does not
make the prime stream periodic.

## 5. The information barrier

A fixed collection of modular automata can do two valuable things:

1. falsify a proposed divisor at any specified cutoff with a short exact
   certificate; and
2. discover rare cutoffs that survive several independent necessary states.

It does not by itself prove that no future cutoff survives.  Such a proof
must supply either an invariant that keeps the actual ordered prime-residue
walk away from zero, or a theorem forbidding the simultaneous congruences in
(4.3) at every endpoint-compatible cutoff.  Standard prime number theorems
in arithmetic progressions estimate the sizes of these counts.  They do not
control their exact residues (already their parities for mod $2$), nor the
ordered sequence of the resulting finite-state walk.  Frequency balance is
therefore not the missing theorem.

The computation at $X_0$ makes the boundary concrete: even the complete
mod-2 state plus the extra mod-7 collision character can return to zero.
Adding mod $3$ rejects this cutoff, but an all-$X$ conclusion would still
require a new invariant or exact prime-distribution input for the combined
state.  The automata are strong falsifiers and candidate compressors, not
self-proving global exclusions.

## 6. Replay and controls

Run

```text
PYTHONDONTWRITEBYTECODE=1 python3 code/exp49_q1_prime_support.py
```

The script uses an exact sieve, finite-field polynomial arithmetic, explicit
order certificates, and a canonical JSON digest.  It also includes the
positive divisibility control $F_5=x^3+x+1$, divided by itself over
$\mathbf Z[x]$.  Its two negative boundaries are explicit:

- the strong filter package is known insufficient because of $X_0$; and
- actual $q_1$ divisibility at $X_0$ is known false because of (3.2).

The replay does not claim that $q_1$ is globally excluded.
