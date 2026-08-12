# Endpoint speed and developmental capacity are opposite projections

## 1. The finite process

Fix a horizon `H` and work in the finite cyclic state space

\[
X_H=\mathbb Z/(2\cdot3^H+1)\mathbb Z.
\]

For `0 <= k <= H`, let `A_k={0,1,2}^k`.  Define an open process

\[
P_k:X_H\times A_k\longrightarrow X_H,
\qquad
P_k(x;a_1,\ldots,a_k)
=x+3^k+[a_1\cdots a_k]_3,
\]

where the displayed ternary word is read from left to right:

\[
[a_1\cdots a_k]_3=3^{k-1}a_1+\cdots+3a_{k-1}+a_k.
\]

The finite modulus is larger than every displacement appearing through the
declared horizon, so no two displayed responses collide.

The base is `P_0(x)=x+1`.  The extension constructor is

\[
E(P)(x;a,d)=x+3(P(x;a)-x)+d.                 \tag{1}
\]

Consequently `E(P_k)=P_{k+1}`.  If all ports are set to zero, the contracted
endpoint is

\[
C(P_k)(x)=P_k(x;0,\ldots,0)=x+3^k=T_{3^k}(x). \tag{2}
\]

Thus the nominal member is exactly the action produced by the ternary
twelve-step compiler, while the open object retains the interventions that
the endpoint action forgets.

## 2. Exact theorem

**Theorem (developmental port complementarity).**  For the finite tower above:

1. for fixed `x`, `P_k(x;-)` has exactly `3^k` distinct responses;
2. if only a set `S` of ports remains live and all other ports are fixed to
   zero, the response capacity is exactly `3^|S|`;
3. the marginal capacity of one additional port after `s` retained ports is
   `2*3^s`, hence is strictly increasing rather than diminishing;
4. any exact deterministic evaluator of the open response must read every
   one of the `k` ports in the worst case, whereas the contracted nominal
   endpoint reads none;
5. if a depth-`k` process is contracted and then `h` new ports are added, its
   response capacity is `3^h`; uninterrupted extension has capacity
   `3^(k+h)`.  The lost factor `3^k` is never recovered merely by later
   extension;
6. contracting after every extension retains response capacity one, while the
   nominal endpoint displacement still grows as `3^k`.

**Proof.**  The ternary evaluation map sends `A_k` bijectively to
`{0,...,3^k-1}`.  The modulus is larger than the full response interval, so
this remains injective in `X_H`; (1) and (2) follow by direct substitution.
Fixing all but `|S|` digits leaves a mixed-radix injection of `3^|S|` inputs,
proving (1)--(2).  Therefore the marginal is

\[
3^{s+1}-3^s=2\cdot3^s,
\]

which proves (3).  If an evaluator fails to read port `i` along some complete
execution, changing only that trit leaves the execution transcript unchanged
but changes the output by a nonzero power of three, contradiction; this proves
(4).  After contraction the first `k` digits are fixed.  The `h` later live
digits therefore give `3^h` responses, versus `3^{k+h}` when all digits remain
live, proving (5).  Repeating contraction fixes every newly introduced digit
and gives (6).  ∎

At depth twelve, both the nominal displacement and the open response capacity
equal

\[
3^{12}=531441.
\]

They are equal numbers measuring different things.  One is primitive-equivalent
endpoint span; the other is the number of environmental histories to which the
process can still respond differently.

## 3. The proof-support join

Give the extension from level `i` to `i+1` the rule name `r_i`.  In the
sequential grammar generated only by (1), replay of the full open `P_k`
requires the single minimal support

\[
\{r_0,r_1,\ldots,r_{k-1}\}.
\]

The Boolean full-replay observable is therefore a conjunctive support.  By
`PROOF_SUPPORT_COMPLEMENTARITY`, it violates submodularity as soon as `k>=2`:
the last rule has no full-process value without its ancestors and unit value
after they are retained.  The quantitative response observable makes the same
curvature visible before the final threshold: `S |-> 3^|S|` has increasing
marginals.

This supplies an exact identity behind three earlier shadows:

- recursive compilation multiplies the nominal span;
- conjunctive derivations give retained rules increasing returns;
- adaptive-port contraction says endpoint equality cannot preserve a freely
  chosen later input.

The common carrier is the generated response family `P_k`, with its nominal
endpoint map, live port set, and recursive proof support kept as distinct
projections.

## 4. The opposite is also true

For the workload that asks only for the all-zero nominal response, contraction
is strictly preferable: it returns exactly the same answer without reading any
ports.  A port which no admitted future experiment can vary is overhead, not
latent wisdom.  There is no theorem here that memory, provenance, openness, or
biological complexity should always be maximized.

For an adaptive workload, the comparison reverses.  The contracted object has
one response and the open object has `3^k`; by the erased-port theorem no side
memory can restore a future input that has no causal route into the endpoint.

These are not contradictory rankings of one scalar.  They are the two exact
faces of a Pareto boundary:

\[
(\text{nominal query cost},\ \text{response capacity})
= (0,1)\quad\hbox{or}\quad(k,3^k),
\]

where query cost counts port reads.  A declared workload chooses a face; the
mathematics does not choose it in advance.

Nor is contraction absolute death.  A contracted depth-`k` object can accept
new ports later and grow again.  What it cannot do is regenerate the erased
`k`-port distinction merely by continuing the same extension law.  The exact
loss is persistent historical capacity, a factor `3^k`, not metaphysical
annihilation.

## 5. Executable witness

`machinery/developmental_ports.py` implements the finite tower, contraction,
partial retention, support replay, and the two future histories.  Six tests
check the recursive identity exhaustively through depth six, every retained
subset at depth six, the conjunctive support, the persistent loss ratio, and
the twelve-stage values.

```sh
cd machinery
python3 developmental_ports.py
python3 -m unittest test_developmental_ports.py -v
```

## Rigor boundary

**Proved and implemented:** all six finite statements above; the exact
endpoint/open comparison; the increasing marginal; the persistent loss ratio.

**Inherited:** the general erased-port and response-memory theorems from
`ADAPTIVE_PORT_CONTRACTION`; the general singleton-support iff from
`PROOF_SUPPORT_COMPLEMENTARITY`; the endpoint compiler interpretation from
`TWELVE_STEP_COMPILER`.

**Not claimed:** that all useful knowledge has ternary independent ports; that
wall time is endpoint span; that retained history always has value; that an
actual self-improving research organism has been built; or that twelve is
intrinsically privileged.  This is a finite joint carrier on which the
opposing claims become simultaneously exact.
