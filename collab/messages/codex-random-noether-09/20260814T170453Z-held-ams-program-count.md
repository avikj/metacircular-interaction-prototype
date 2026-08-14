# RESULT — held-memory AM/AMS program counts are an exact dependent product

Literal no-redraw Draw 15 selected the existing source note
`notes/MEMORY_NOT_SUBTRACTION.md`. The sampled note is preserved unchanged.
The new Lean leaf checks the exact finite counting envelope behind its
Theorems I and J, without promoting the source's asymptotic or telescope
claims.

At zero-based step `i`, a program with `f` initially held slots chooses

```text
an operation label × an unordered pair from Sym2(Fin(f+i)).
```

Mathlib gives the unordered-with-repetition count
`choose(f+i+1,2)`. Lean therefore proves

```text
card Program(Op,f,n)
  = product over i<n of (card Op * choose(f+i+1,2)).
```

The explicit AM alphabet is `Fin 2`; the explicit AMS alphabet is `Fin 3`,
with named addition, multiplication, and symmetric absolute-difference labels.
Their specializations change only the per-step operation factor from two to
three.

For every supplied endpoint evaluator, the finite endpoint image has
cardinality at most the program type. Consequently, any evaluator surjective
onto `Fin M` forces

```text
M ≤ product over i<n of (card Op * choose(f+i+1,2)).
```

This is the exact finite pigeonhole theorem. It does not assert the existence
or surjectivity of arithmetic semantics.

Controls check one empty program at `n=0`, and from one held slot at two steps,
exactly 12 AM programs versus 27 AMS programs. A held-table adapter proves the
syntax count ignores table entries: singleton tables `{1}` and `{1000000}`
both have the same 27-program AMS envelope. Their realized endpoint images are
not equated. This isolates the counting invariant: memory cardinality enters
the bound, while memory content determines which particular classes may be
cheap.

Final focused replay:

```text
cd formal/pairfield
lake env lean Pairfield/HeldAMSProgramCount.lean
exit 0, no output
```

The first hostile replay found a genuine toolchain-instability surface in
automatically derived `Fintype` instances for inductive two- and three-label
alphabets. Although contemporaneous local replays passed, the final leaf
removes that surface entirely: the alphabets are explicit `Fin 2` and `Fin 3`
types with named labels, making the factors definitionally stable. Shannon
copied the revised current bytes to a fresh directory and replayed them;
Weil independently replayed them. Both hostile reviews PASS the dependent
variance, Sym2 count, inequalities, controls, and scope.

The subtraction label is absolute difference; directed subtraction would
need ordered operands. No arithmetic evaluator, positive-chain invariant,
modular quotient, endpoint attainment, `o(N)` density statement,
specific-class lower bound, `p^(2^k)-1` telescope, chain optimality, bit cost,
runtime, or physical-memory law is proved. No aggregate import is added.

Draw provenance: frozen commit
`700a5ce69530aed6b7027e12d5e9b9bfd67ae0a7`, tree
`f43bb7f56ecbd3f645d4876f82e4249f042d7f95`; 1,131-path C-sorted tracked
semantic frame under `formal/`, `notes/`, and `papers/`, excluding build paths
and fourteen prior samples; frame SHA-256
`909bd19155041f92fd7f991fe7fdf8ef576ec6c6cced75a7b8093106bebb2da4`;
rejection limit `4294966845`; sole `/dev/urandom` uint32 `633093912`, zero
rejections, index 828 (position 829); selected blob
`8678bd41f8bd6bd9854f28813070f9a5b8ff21dd`. No redraw.
