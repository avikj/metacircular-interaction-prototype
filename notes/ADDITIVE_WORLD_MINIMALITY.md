# Additive generation restores every finite valuation witness

`FORMATION_SUFFICIENCY` proves a sharp non-attainment theorem: no finite set
of integer pairs preserves the ambient minimal prime-power depth at every
point. The obstruction is its maximal-valuation point. This note identifies
the opposite exact case. A full additive subgroup has no such top and contains
the witnesses ambient minimality requires.

Fix a prime `p` and a nonzero additive subgroup

\[
G=d\mathbb Z\subseteq\mathbb Z,\qquad d\ge1.
\]

On pairs `(a,b) in G²` with `a+b != 0`, use the residue chart

\[
q_k(a,b)=(a\bmod p^k,b\bmod p^k)
\]

and task `T(a,b)=v_p(a+b)`.

## Theorem: subgroup-relative and ambient depths agree

For every `(a,b) in G²` with nonzero sum,

\[
\boxed{k_{G^2}(a,b)=k_{\mathbb Z^2}(a,b)=v_p(a+b)+1.} \tag{1}
\]

**Proof.** Put `v=v_p(a+b)` and write

\[
d=p^t d_0,\quad (d_0,p)=1,\qquad a+b=p^v u,\quad p\nmid u.
\]

Since `d` divides both inputs, it divides their sum, hence `t<=v`. By the
Chinese remainder theorem choose an integer `C` satisfying

\[
C\equiv0\pmod {d_0},\qquad C\equiv-u\pmod p.       \tag{2}
\]

Choose its representative so that `C != -u`; adding a multiple of `p d_0`
preserves (2), so this is always possible. Define

\[
(a',b')=(a,b+C p^v).
\]

Because `t<=v` and `d_0|C`, we have `d|C p^v`, so `(a',b')` remains in `G²`.
It shares the depth-`v` residue chart with `(a,b)`. But

\[
a'+b'=p^v(u+C)
\]

is nonzero and divisible by `p^(v+1)`, so its task value is strictly larger
than `v`. Thus `G²` contains the witness required by the general transport
criterion of `FORMATION_SUFFICIENCY` at every point. Ambient minimality is
`v+1`, and sufficiency restricts downward, proving (1). `square`

## What the theorem says about formation

The finite no-go and (1) are not competing conclusions. They expose the exact
missing operation.

- Every finite formed world has a largest visible cancellation depth and
  therefore an unpayable minimality debt at its top.
- Closing under additive inverses and addition produces `dZ`, an infinite
  world. CRT constructs a witness at the next depth for every current point.
- The subgroup does not store an infinite witness table. Its operations
  regenerate the needed perturbation `C p^v` from `d,p,u`.

This is a narrow instance of mathematics changing future motion: closure under
an operation replaces an impossible finite certification problem by an exact
witness constructor.

The distinction between additive **group** and additive **monoid** is
load-bearing. The proof uses arbitrary integer multiples and the freedom to
change a CRT representative. It does not prove the same statement for a
positive numerical semigroup, a bounded arithmetic-life cache, or a formation
process lacking subtraction.

## Rigor boundary

The theorem is elementary and proved above; no novelty is claimed.
`machinery/additive_world_minimality.py` constructs and verifies witnesses for
declared instances. Those finite replays are controls, not the proof. The
result concerns a chain of prime-power residue charts and the task
`v_p(a+b)` only. It does not establish that an implemented arithmetic process
has formed all of `dZ`, nor that finite causal memory can certify the infinite
closure internally.

