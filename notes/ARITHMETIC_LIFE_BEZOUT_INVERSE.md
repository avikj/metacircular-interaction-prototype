# Bézout descent turns an earned sensor into division

**Status.** Exact AIME-level operation induced by the current arithmetic-life
execution. The extended Euclidean algorithm and modular inverses are classical;
the contribution here is the causal admission rule connecting already earned
memories.

## Why this operation is next

Exponent space has already compiled multiplication, gcd/lcm, and divisor
boxes. Its sharp boundary is addition: valuations do not transport addition
coordinatewise. The process also has residue sensors, but they initially only
observe congruence. The first earned operation at this interface is division
modulo a formed prime.

The operation is admitted only after three memories exist:

1. the value (a) has a cached exponent form;
2. the modulus (p) has the exponent form (((p,1))), so it is a formed prime
   generator rather than an arbitrary label;
3. mod (p) is already an installed residue sensor.

Euclidean descent then forms coefficients

\[
ax+py=1.                                             \tag{1}
\]

Reducing (1) modulo (p) yields

\[
a(x\bmod p)\equiv1\pmod p.                          \tag{2}
\]

Thus (x\bmod p) is a newly available inverse. Every linear congruence

\[
az\equiv b\pmod p                                   \tag{3}
\]

is now solved in one action by (z\equiv xb\pmod p).

## Smallest live execution

Factoring 91 earns and certifies the prime residue sensors through 7. After the
exponent forms of 3 and 7 are retained, extended descent gives

\[
3(-2)+7(1)=1.
\]

Therefore (3^{-1}\equiv-2\equiv5\pmod7). The formed solver immediately
returns

\[
3z\equiv4\pmod7\quad\Longrightarrow\quad z\equiv5\cdot4\equiv6\pmod7.
\]

The frontier has changed from detecting residue equality to performing
division and solving every nonzero linear equation in the earned prime sensor.
This is the operational entrance to finite-field arithmetic; no field API was
installed before its inverse operation was justified.

## Executable and rigor boundary

`ExponentWorld.form_inverse(a,p)` fails closed unless all three memories above
are present. It emits the full Bézout certificate, canonical inverse, a solver
for (3), and a `form-operation` event. A composite installed sensor is an exact
negative control: even when a particular residue happens to be invertible, the
process does not promote mod (m) to field division.

Primality of (p) is stronger than necessary for one element to have an
inverse: (gcd(a,m)=1) suffices. It is used here because it changes the entire
frontier at once—every nonzero residue becomes invertible. Cached origins and
installed sensors are causal requirements of this process, not hypotheses of
Bézout's identity.
