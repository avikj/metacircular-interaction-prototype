# Dependent rooted history fibres

> **Scope fence.** Huayan/Indra's Net is not reduced to category theory. This
> note proves one finite, discrete, type-valued analogue of a rooted-view
> total space. It does not formalize Huayan philosophy or practice.

## Exact result

[`FiniteHistoryTotalization.lean`](../formal/pairfield/Pairfield/FiniteHistoryTotalization.lean)
defines a length-`n` history, its endpoint and prefix, and the category of
elements of a type-valued family `Root : History State n -> Type`.

The earlier checked theorem specializes `Root` to the constant unit family.
The new leaf keeps the entire dependent payload. For every endpoint `final`
it constructs an explicit equivalence

```text
{ rooted : GrothendieckTotal n Root // endpoint rooted = final }
  ≃
Σ past : Fin n -> State, Root (assemble n final past).
```

The forward direction forgets the discrete wrapper, extracts the history's
prefix, and transports its root witness along the checked reconstruction path
`history = assemble n final past`. The inverse direction uses the inverse
prefix/endpoint equivalence and reconstructs the category-of-elements object.
The construction is an equivalence of full types: rooted witnesses are not
truncated, quotiented, or assumed proposition-valued.

When `State` is a `Fintype` and every rooted fibre is finite, `Nat.card_sigma`
then gives the weighted fibre equation

```text
Nat.card(endpoint fibre)
  = sum past, Nat.card (Root (assemble n final past)).
```

Thus the constant-unit count `|State|^n` is a special case, not a universal
count for dependent rooted views. The `n = 0` control reduces the endpoint
fibre to exactly the root payload over the uniquely determined empty prefix.

## What is new and what is inherited

The history/prefix equivalence, discrete diagram, Grothendieck total, endpoint
map, and constant-unit fibre theorem are inherited from
`FiniteHistoryTotalization`. The new checked content is the dependent fibre
transport and its finite weighted-cardinality corollary. It is a small exact
Grothendieck-fibre equation, not a new general result about categories of
elements.

The selected source's open T25.G direction asks for a nontrivial history
category and comparison with an ordinary colimit. This leaf deliberately
does not discharge it: the base category remains discrete, so there are no
history-extension arrows, transition maps, colimit cocones, or comparison
theorem. It also supplies no Braid coherence, no higher categorical
structure, no clock/later modality, and no analytic or physical claim.

## Verification and provenance

Draw 16 froze origin commit
`5bb6ccfc1a9dd52568e1776398897ea3e9dff7f5` (tree
`1dab61a6426e3b06a5ac366a4f50f9992c71ba9b`). The C-sorted tracked semantic
frame contained 1,061 `.agda`, `.lean`, and `.md` files under `formal/`,
`notes/`, and `papers/`, after excluding build products, Python, and the prior
15 samples. Its SHA-256 was
`c4ba3222acd197755760f68c35887a1f5f317950853793fb83097f0906898371`.
The sole native `/dev/urandom` unsigned 32-bit draw was `3399228941`; it was
below the unbiased acceptance limit `4294967257` and selected zero-based index
324 (one-based position 325),
`formal/pairfield/Pairfield/FiniteHistoryTotalization.lean`, blob
`295911bd389e40a68d9d85e1b968e77854da40ff`. There was no redraw.

The contemporaneous R0060--R0064 packet family remains fail-closed: invalid
schema enums/events are not repaired by the mathematical results around
pinning, CRT, or binomial bounds. In particular, R0060's unconditional
`M' <= M+k-1` forecast fails at equal depth; the exact always-valid estimate
is `M' <= M+k`, with the sharper `k-1` form requiring strict depth increase.
No packet status or theorem from that family is used here.

Focused Lean checking and `lake build Pairfield.DependentRootedHistoryFiber`
(1,022 jobs) both pass. An independent hostile audit replayed the focused
check and passed the equivalence orientation, proof-relevant fibre transport,
finite-cardinality hypotheses, zero-step control, and scope boundaries without
a blocker.
