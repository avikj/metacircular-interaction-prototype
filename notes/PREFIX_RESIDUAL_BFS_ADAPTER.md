# Shortest executable witnesses for Mathlib prefix residuals

## Exact square

Let `M : DFA A X`, and let `u,v : List A` be input prefixes.  Mathlib's
`Language.leftQuotient_accepts_apply` identifies

\[
M.\operatorname{accepts}.\operatorname{leftQuotient}(u)
=M.\operatorname{acceptsFrom}(M.\operatorname{eval}(u)).       \tag{1}
\]

`Pairfield.MyhillNerodeAdapter` already transports (1) to equality under every
future word.  `Pairfield.ResidualBFS` now composes that theorem with the native
length-layered search in `Pairfield.BehavioralBFS`:

```text
prefix u --M.eval--> reached state --BehavioralBFS--> shortest suffix w
   |                                      |
   v                                      v
left quotient u -----------------> membership differs at w
```

The executable

```text
shortestLeftQuotientWitnessUpTo M alphabet u v fuel
```

returns either `some w` or `none`.  Lean proves:

1. `some w` implies `w.length <= fuel` and membership in the two Mathlib left
   quotients differs;
2. `none` is equivalent to membership agreement for every suffix of length at
   most `fuel`;
3. every returned word has minimum length among **all** residual-language
   separators, not only those below the requested fuel;
4. prefixes reaching the same state return `none` at every fuel;
5. replacing one complete alphabet enumeration by another cannot change the
   `none` verdict or the minimum returned length.

For finite `X`, the adapter now also constructs the synchronous product
monitor `residualPairDFA M u v` on `X × X`.  Its accepting states are exactly
the pairs whose acceptance observations disagree.  Mathlib's
`DFA.evalFrom_split` deletes a nonempty loop from every accepting run of length
at least `|X × X|`.  Strong induction therefore proves

\[
L_u\ne L_v\quad\Longrightarrow\quad
\text{some separating suffix has length }<|X|^2.                 \tag{2}
\]

Consequently Lean checks that search with fuel `Fintype.card X ^ 2` returns
`none` if and only if the two Mathlib left quotients are extensionally equal.
This is a finite executable decision procedure, not merely an existence
statement about a finite set of quotients.

The fifth theorem corrects an initially tempting reading of the executable
interface.  A complete list does not choose the control language: it enumerates
and orders the actions already present in the type `A`.  Control authority
lives in the action type or typed intervention interface.  List order can only
choose between equally short certificates.  This is the checked contact with
`CONTROL_INDEXED_PREDICTIVE_QUOTIENT.md`.

## Falsifier and replay

The internal three-state DFA has prefixes `[]` and `[false]` separated first by
the suffix `[true]`; Lean reduces the executable result to `some [true]` and
certifies residual-membership disagreement.  The control prefixes `[]` and
`[true]` reach the same state, and Lean proves the search returns `none`.

```sh
cd formal/pairfield
lake build Pairfield.ResidualBFS
```

This passes (`3012` jobs).  The module is imported by `Pairfield.lean`.  A full
`lake build Pairfield` reaches and replays it, then fails in the unrelated
existing `Pairfield.Lowenheim` Boolean-algebra proof; no green aggregate claim
is made.

## Rigor boundary

All statements and both controls are Lean-checked.  The result concerns left
quotients of prefixes reachable from `M.start`.  At arbitrary fuel, `none`
still means only bounded equality; at the proved quadratic horizon it means
full residual equality.  The theorem does not enumerate or remove unreachable
ambient states, prove the sharper linear distinguishing bound, construct the
quotient DFA, or prove full DFA minimality.  The present executable also
enumerates all words by length rather than maintaining a visited pair graph,
so finiteness is proved without claiming algorithmic efficiency.

No novelty claim is made: left quotients, Myhill--Nerode equivalence, and
breadth-first shortest witnesses are standard.  The contribution is a checked
adapter making Mathlib's extensional theorem executable inside this formal
corpus while preserving its scope.
