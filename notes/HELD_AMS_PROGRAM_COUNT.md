# Held-memory AM/AMS program count

Status: **checked finite syntax and image-cardinality theorem**.

`formal/pairfield/Pairfield/HeldAMSProgramCount.lean` formalizes the exact
finite counting kernel behind Theorems I and J of
`MEMORY_NOT_SUBTRACTION.md`. The sampled source remains unchanged.

At zero-based step `i`, a length-`n` program with `f` initially held values has
`f+i` available slots. One instruction consists of:

```text
an operation label × an unordered operand pair with repetition.
```

Mathlib's `Sym2 (Fin (f+i))` is exactly the unordered pair carrier, including
diagonal pairs, and has cardinality `choose(f+i+1,2)`. Lean therefore checks

```text
card Program(Op,f,n)
  = product over i<n of (card Op * choose(f+i+1,2)).
```

The AM alphabet has two labels (addition and multiplication). The AMS alphabet
has three (addition, multiplication, and symmetric absolute difference). Thus
the two specializations replace only the per-step factor `2` by `3`; the held
slot/pair structure is invariant.

## Endpoint consequence

For any supplied endpoint evaluator, Lean forms the finite image of all syntax
programs and proves

```text
card(endpoint image) ≤ card(programs).
```

If such an evaluator is surjective onto `Fin M`, then

```text
M ≤ product over i<n of
      (card Op * choose(f+i+1,2)).
```

This is the exact finite pigeonhole statement needed before any asymptotic
lower bound. It deliberately quantifies over a supplied evaluator rather than
asserting that every syntax object is a positive arithmetic chain.

## Controls

The leaf checks:

```text
card Program(Op,f,0) = 1;
card AMProgram(1,2)  = 12;
card AMSProgram(1,2) = 27.
```

It also attaches concrete values to a finite held-table index. The tables
`{1}` and `{1000000}` both yield the same 27-program AMS syntax envelope at
two steps. This is the killer boundary: the counting theorem depends on held
**cardinality**, not held **content**. Their realized endpoint images need not
agree, so the bound alone cannot prove that a particular held value makes its
related congruence class cheap.

## Scope

The subtraction label means absolute difference, for which unordered operands
are sound. Directed subtraction would require ordered pairs and has a different
count. The module does not define arithmetic evaluation, require positive
intermediates, quotient endpoints modulo a modulus, or prove that the upper
bound is attained. It proves no `o(N)` asymptotic, generic-class density,
specific-class lower bound, telescope construction of `p^(2^k)-1`, chain
optimality, bit-operation cost, runtime, or physical-memory law.

The previous checked `AdditionChainPredictiveMemory` leaf supplies two concrete
addition histories and a predictive-memory lower bound; it does not count
dependent AM/AMS syntax. `FiniteHistoryTotalization` counts unconstrained
state histories, not operation-and-operand programs. The present finite
program-cardinality theorem is therefore nonduplicate. No aggregate import is
added.

## Draw 15 provenance

Literal no-redraw Draw 15 froze commit
`700a5ce69530aed6b7027e12d5e9b9bfd67ae0a7`, tree
`f43bb7f56ecbd3f645d4876f82e4249f042d7f95`. The 1,131-path C-sorted tracked
`.agda`/`.lean`/`.md` frame under `formal/`, `notes/`, and `papers/` excluded
build paths and the fourteen prior sampled objects; SHA-256 was
`909bd19155041f92fd7f991fe7fdf8ef576ec6c6cced75a7b8093106bebb2da4`.
The rejection limit was `4294966845`; the sole `/dev/urandom` uint32
`633093912` was accepted with zero rejections at zero-based index 828
(position 829), selecting `notes/MEMORY_NOT_SUBTRACTION.md`, blob
`8678bd41f8bd6bd9854f28813070f9a5b8ff21dd`. There was no redraw.
