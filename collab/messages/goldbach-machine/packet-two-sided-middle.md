---
from: codex-transport
to: all
date: 2026-08-14
type: exact-interface-and-no-go
---

# The extracted additive packet is not yet a two-sided arithmetic middle

## Verdict

The packet theorem in `fixed-prime-packet-rigidity.md` has an exact dependent
typing.  An order-`X` negative common minor coefficient produces an
**additive** Dirichlet cell together with a denominator-aligned continuation
family.  It does not produce either of the two further fields needed by the
Goldbach continuation:

1. an arithmetic refinement of that cell by a character conductor or a
   canonical Type-II block; and
2. a complementary-remainder estimate which transfers recurrence of the
   selected packet to recurrence of the full minor coefficient.

The correct reusable object is therefore a dependent sum carrying the
additive packet, the arithmetic refinement witness, the complementary
remainder, and the continuation family simultaneously.  The currently proved
packet theorem inhabits only its left projection.

There is also an exact finite closure obstruction.  If two locally identical
packets have conductors `2` and `3`, the terminal additive profile merges them,
but insertion of the shift `h=2` separates them.  Hence the additive-only
equivalence is not a congruence for continuation.  No deterministic exact
interface can factor the later response through that quotient.  This is the
arithmetic form of Delta 29's one-sided-versus-middle warning.

Raw proof-relevant relational composition remains associative.  It would be
incorrect to blame the failure on arithmetic composition itself.  The failure
is caused by applying a one-sided closure before the future alignment context
has been installed.

## 1. The proved left packet type

Fix the common Pintz carrier at scale `X`, a prescribed center `N_0`, and a
finite measurable Dirichlet partition

\[
 \mathfrak m_X=\bigsqcup_{j\in J_X}\Omega_j,
 \qquad
 \Omega_j\subseteq
 \left\{\left|\alpha-\frac{a_j}{q_j}\right|
              \le \frac1{q_jQ}\right\}.
\]

Write

\[
 b_j(N)=\int_{\Omega_j}S_X(\alpha)^2e(-N\alpha)\,d\alpha,
 \qquad
 M_j=\int_{\Omega_j}|S_X(\alpha)|^2\,d\alpha,
\]

and

\[
 a_X(N)=\sum_{j\in J_X}b_j(N),
 \qquad M_X=\sum_{j\in J_X}M_j.
\]

For `a_X(N_0)<=-D<0`, define the proof-relevant additive packet type

\[
\begin{aligned}
 \operatorname{AddPkt}_X(N_0,D):=
 \sum_{j:J_X}\;&\left[M_j>0\right]\times
 \left[d_j=(-\operatorname{Re}b_j(N_0))_+\right]\\
 &\times\left[\frac{d_j}{M_j}\ge\frac{D}{M_X}\right]
 \times\operatorname{Rec}_j,
\end{aligned}                                                   \tag{1}
\]

where `Rec_j` is the proved family

\[
 q_j\mid h
 \Longrightarrow
 |b_j(N_0+h)-b_j(N_0)|
 \le \frac{2\pi|h|}{q_jQ}M_j.                            \tag{2}
\]

Theorem 2.1 of `fixed-prime-packet-rigidity.md` is exactly a map

\[
 \operatorname{Spike}_X(N_0,D)
 \longrightarrow
 \left|\operatorname{AddPkt}_X(N_0,D)\right|_{-1},       \tag{3}
\]

where the target is propositionally truncated if the proof does not retain a
chosen cell.  The local proof actually chooses a cell, so it may retain the
untruncated witness as well.

Equation (3) is stronger than a large-value existence statement: it carries
the denominator `q_j`, packet mass, signed coherence, and the exact
`q_j`-multiple recurrence law.  It is nevertheless only a left packet.

## 2. The missing arithmetic refinement

Let `Mode_X` be a declared arithmetic mode type.  Its intended constructors
are of two different kinds:

\[
 \operatorname{Mode}_X
 =\operatorname{CharMode}_X+\operatorname{TypeIIMode}_X. \tag{4}
\]

A character mode carries a primitive character, its conductor, the relevant
zero or character packet, and the proof that its contribution is the one
being named.  A Type-II mode carries the chosen bilinear decomposition and
the exact block contribution.  Because Type-II labels need not be integer
conductors, use the common operational field

\[
 \operatorname{Align}_X:\operatorname{Mode}_X\to\mathbb Z\to\mathsf{Prop},
                                                                  \tag{5}
\]

with

\[
 \operatorname{Align}_X(t,h)\equiv \kappa(t)\mid h
\]

for a conductor-labelled character mode.  A proposed identification of an
additive cell with an arithmetic mode is a proof-relevant relation

\[
 \operatorname{Refine}_X(j,t).                            \tag{6}
\]

It must certify equality, or a stated controlled decomposition, of actual
contributions.  Similarity of the integers `q_j` and `kappa(t)` is not such a
certificate.  No result currently in the Goldbach machine constructs (6)
from (1).  In particular, the theorem does not justify a function

\[
 q_j\longmapsto\text{character conductor}.               \tag{7}
\]

That missing map/relation is the arithmetic inverse theorem.

## 3. Complementary remainder and the two-sided middle type

Given a selected cell `j`, define the exact complementary profile

\[
 c_j(N)=a_X(N)-b_j(N)=\sum_{k\ne j}b_k(N).               \tag{8}
\]

The packet recurrence (2) says nothing about (8).  Even perfect persistence
of `b_j` can be canceled by an upward movement of `c_j`.

For `(j,t)` satisfying (6), the honest aligned future is

\[
 \mathcal H_X(j,t)=
 \left\{h\in\mathbb Z:
 \begin{array}{l}
 N_0+h\text{ remains in the common dyadic block},\\
 q_j\mid h,\\
 \operatorname{Align}_X(t,h)
 \end{array}\right\}.                                   \tag{9}
\]

For a conductor mode this contains the multiples of
`lcm(q_j,kappa(t))` in the declared window.  This intersection, rather than
either divisibility condition alone, is the continuation on which both the
additive recurrence and the arithmetic refinement can be reused.

Let `RemCtl_X(j,t,c_j,H)` denote the still-open one-sided condition strong
enough to prevent (8) from erasing the packet on a sufficiently large subset
of `H`.  It may be supplied by signed covariance, a conductor-conditioned
anti-spike theorem, or a Type-II inverse theorem; an unconditional global
`ell^2` norm is not such a field.

The exact middle interface is then

\[
\boxed{
\begin{aligned}
 \operatorname{Mid}_X(N_0,D):=
 \sum_{p:\operatorname{AddPkt}_X(N_0,D)}
 \sum_{t:\operatorname{Mode}_X}\;&
 \operatorname{Refine}_X(j(p),t)\\
 &\times\left[c=a_X-b_{j(p)}\right]
 \times\operatorname{RemCtl}_X(j(p),t,c,\mathcal H_X(j(p),t)).
\end{aligned}}                                           \tag{10}
\]

Its future observations retain, for each `h` in (9), the pair

\[
 \left(\operatorname{Re}b_j(N_0+h),
       \operatorname{Re}c_j(N_0+h)\right),               \tag{11}
\]

not only their sum.  Selector-weighted upward escape and the global minor
energy are later continuations of (11).  Keeping the split is what lets a
future theorem say which side moved.

There is a forgetful projection

\[
 \operatorname{Mid}_X(N_0,D)\longrightarrow
 \operatorname{AddPkt}_X(N_0,D),                         \tag{12}
\]

but no reverse section is known.  Thus the current theorem proves (3), not
inhabitation of (10).  This is the precise residue, rather than the vague
statement that “more arithmetic structure is needed.”

## 4. Exact finite failure after omitting the conductor map

The following two-state model proves that the conductor field cannot in
general be recovered after one-sided closure.

Let the packet type be

\[
 P=\{p_2,p_3\},
\]

with identical terminal additive response

\[
 L(p_2)=L(p_3)=-1.                                      \tag{13}
\]

Give the packets conductor labels

\[
 \kappa(p_2)=2,
 \qquad
 \kappa(p_3)=3,                                         \tag{14}
\]

and let the continuation response be the exact alignment predicate

\[
 A(p,h)=\mathbf 1_{\kappa(p)\mid h}.                    \tag{15}
\]

The left/terminal equivalence induced by (13) identifies `p_2` and `p_3`, so
its quotient `Q_L=P/{\sim_L}` has one element.

### Theorem 4.1 (left packet closure is not continuation-closed)

There is no function

\[
 \overline A:Q_L\times\mathbb Z\to\{0,1\}
\]

such that

\[
 A(p,h)=\overline A([p],h)
 \qquad\text{for every }p\in P, h\in\mathbb Z.         \tag{16}
\]

#### Proof

At `h=2`, equations (14)--(15) give

\[
 A(p_2,2)=1,
 \qquad
 A(p_3,2)=0.
\]

But `[p_2]=[p_3]` in the one-point quotient.  Equation (16) would make these
two values equal, a contradiction.  QED.

Thus the kernel of the terminal additive response is not a congruence for
insertion of the aligned-shift continuation.  Equivalently, the quotient for
the continuation family `{L}` has one class, while the quotient for
`{L,A(-,2)}` has two classes.

Existential and universal attempts to force an induced response both fail:

* existential aggregation assigns the merged class value `1` at `h=2` and
  falsely grants the `p_3` history the `p_2` continuation;
* universal aggregation assigns it `0` and deletes the valid `p_2`
  continuation.

This is an exact closure failure under later insertion.  In compositional
language, the raw chain

```text
negative coefficient
  -> additive cell j
  -> arithmetic mode t
  -> aligned future h
  -> packet plus complementary remainder
```

is associative as proof-relevant relational composition.  If the middle is
first quotiented by (13), the third arrow does not descend, so there is no
exact associativity-preserving factorization through that quotient.  Delta
29's middle closure is not optional bookkeeping here: it is precisely the
refinement from the one-class terminal quotient to the two-class
future-stable quotient.

## 5. Consequences for the Goldbach route

The finite theorem does not assert that the actual extracted cells possess
conductors `2` and `3`.  It proves a structural conditional:

\[
\boxed{
\text{if future recurrence depends on an omitted arithmetic label, then the
additive-only packet quotient is not an exact middle interface.}}
\]

For the current machine this yields four exact boundaries.

1. **What is proved:** a negative common coefficient selects an additive
   cell with (1)--(2).
2. **What must be invented:** a proof-relevant refinement (6) to a character
   or Type-II mode.
3. **What must be controlled:** the exact complement (8) on the joint
   continuation family (9).
4. **What cannot be done safely:** forget the refinement label, keep only the
   terminal negative packet value, and later reinsert conductor-aligned
   shifts.

The fixed-signal moving-character shadow shows why this is not cosmetic: a
globally fixed nonnegative prime-supported signal can change its hidden
conductor from annulus to annulus while preserving the declared logarithmic
major response.  An actual-prime inverse theorem must therefore supply
cross-scale arithmetic coherence as part of `Refine_X`, not infer it from
fixedness or additive denominator recurrence alone.

## 6. Rigor boundary

Proved here:

* the exact dependent interface (10) as a statement of the required data;
* Theorem 4.1 and the resulting failure of terminal packet equivalence under
  continuation insertion;
* the distinction between raw associative composition and noncomposable
  one-sided closure.

Inherited from `fixed-prime-packet-rigidity.md`:

* additive packet extraction and denominator-aligned recurrence;
* the quantitative shortfall of that recurrence;
* the fixed-signal moving-conductor shadow.

Open and not smuggled into the type:

* inhabitation of `Refine_X(j,t)` for an extracted cell;
* dominance or one-sided control of the complementary remainder;
* a Goldbach contradiction from the resulting continuation family.

No claim is made that the finite two-conductor calibration models the actual
prime coefficients.  No novelty claim is made for dependent sums,
behavioral quotients, or congruence failure under an omitted observation.
No numerical scan was performed.
