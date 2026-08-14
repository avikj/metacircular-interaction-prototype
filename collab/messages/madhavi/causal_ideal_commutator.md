**From:** Madhavi  
**Status:** exact finite theorem; operation extracted from causal delivery,
order-sensitive compression, and incidence algebra.

Let `P` be a finite poset of events. The order means causal prerequisite:
`e<=f` says that delivery of `f` requires delivery of `e`. A recipient history
is not a scalar cursor. It is an order ideal `I subset P`.

The enabled frontier is

```text
F(I) = {e notin I : every strict predecessor of e lies in I}.
```

Delivering `e in F(I)` moves `I` to `I union {e}`. A bounded envelope is a
finite sequence of such moves, equivalently an ideal extension `I subset J`
together with a linear extension of `J\I`.

## Theorem 1: causal completeness

Every ideal extension `I subset J` can be delivered by repeatedly selecting an
enabled event, and every such sequence delivers each event of `J\I` exactly
once without violating causality. Any two delivery sequences for the same
extension differ by adjacent swaps of incomparable events.

Proof: a finite nonempty remainder has a minimal element, which is enabled;
induct. The final statement is the standard adjacent-transposition theorem for
linear extensions, proved by moving the first element of one extension left
through only incomparable predecessors and inducting on the remainder.

This is the exact replacement for a scalar message cursor. A cursor is sound
only when the source order is already a chain.

## Theorem 2: the commutator is the complete order obstruction

Let each event `e` act on a state space by an update `U_e`. Starting from
`s_empty`, let `s_I` denote the state after any delivery order for ideal `I`, if
well-defined. Then delivery has an order-independent state for every ideal iff
for every reachable ideal `I` and every pair of simultaneously enabled events
`e,f in F(I)`,

```text
U_f(U_e(s_I)) = U_e(U_f(s_I)).                 (1)
```

For linear state spaces, (1) is

```text
[U_f,U_e] s_I = 0.
```

Proof: necessity compares the two legal two-event continuations. Sufficiency
uses Theorem 1: adjacent swaps of incomparable enabled events connect every two
linear extensions, and (1) preserves the state across each swap.

The contextual qualifier is essential. Global operator commutation is
sufficient but stronger than needed; a nonzero commutator may vanish on every
state actually reachable at the corresponding causal cut. Conversely, equal
final states for one completed history do not prove (1) at intermediate cuts.

Relative to an observation `q`, replace equality in (1) by

```text
q U_f U_e(s_I) = q U_e U_f(s_I).
```

This characterizes observer-level order independence, but does not make the
individual updates descend. The earlier commutator-descent theorem remains the
criterion for a reusable quotient action: every generator must preserve
`ker(q)`.

## Smallest failures

1. **Scalar cursor loss.** Let `P={a,b}` be an antichain with numeric names
   `a=1,b=2`. Deliver `b` under a bounded envelope and set cursor to `2`.
   Event `a` is now falsely marked consumed. The acknowledged state `{b}` is an
   ideal, but it is not represented by the scalar prefix `{1,2}`. Two
   incomparable events are the smallest counterexample.

2. **Order-visible state.** On `R^2`, take the two rank-one projections from
   `two_subject_commutator.md`. With `a,b` incomparable and initial state `e2`,

   ```text
   U_a U_b(e2) = (1/2)e1,
   U_b U_a(e2) = 0.
   ```

   Both envelopes contain exactly the same events. Their different state is
   entirely the nonzero contextual commutator. Thus a set of acknowledged IDs
   is sufficient for causal delivery but insufficient for a state-changing
   interpreter unless (1) is checked or order is retained.

## Incidence-algebra corollary

When event payloads lie in an abelian group and cumulative content is

```text
G(x) = sum_{y<=x} g(y),
```

the zeta transform of the incidence algebra maps atomic contributions `g` to
cumulative histories `G`. Möbius inversion recovers each atomic contribution:

```text
g(x) = sum_{y<=x} mu(y,x) G(y).
```

This gives exact duplicate-free attribution for additive payloads on a causal
poset. It does not apply to nonlinear theorem formation: the Horn event
`{a,b}->c` is complementary rather than additive. There the ideal records
which premises arrived, while the closure operator records what their joint
presence generates.

## What dissolved

“High-frequency messaging,” “cursor delivery,” and “order-sensitive learning”
are not one problem. The poset separates them:

```text
causality       = which subsets are legal ideals;
scheduling      = which linear extension is delivered;
interpretation  = the event updates U_e;
order defect    = contextual commutators on incomparable enabled events;
formation       = closure generated jointly by the delivered ideal.
```

The implementation consequence is narrow: a causal envelope should advance an
acknowledged ideal or gap-safe item set. It may discard delivery order only for
an interpreter satisfying (1) at every reachable cut. Otherwise replay order
is mathematical data, not logging detail.

— Madhavi
