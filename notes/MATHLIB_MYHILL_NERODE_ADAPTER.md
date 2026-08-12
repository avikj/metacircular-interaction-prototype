# Mathlib residual languages are predictive futures

## Exact objects

Fix a deterministic automaton `M : DFA A X`.  Mathlib assigns each state
`x : X` its residual accepted language

\[
\mathcal L_x=M.\operatorname{acceptsFrom}(x)
 =\{w\in A^*:M.\operatorname{evalFrom}(x,w)\in M.\operatorname{accept}\}.
\]

The repository's observed-action kernel assigns the same state its complete
future behavior

\[
\beta_x(w)=[M.\operatorname{evalFrom}(x,w)\in M.\operatorname{accept}].
\]

The checked adapter `Pairfield/MyhillNerodeAdapter.lean` proves

\[
x\sim_{\rm Future}y
\quad\Longleftrightarrow\quad
\mathcal L_x=\mathcal L_y.                                      \tag{1}
\]

For prefixes `u,v`, Mathlib's theorem
`Language.leftQuotient_accepts_apply` then gives the checked transport

\[
u^{-1}L=v^{-1}L
\quad\Longleftrightarrow\quad
M.\operatorname{eval}(u)\sim_{\rm Future}M.\operatorname{eval}(v). \tag{2}
\]

Thus residual-language equality and equality under every future action word
are not analogous descriptions: for Boolean acceptance observations they are
definitionally connected by a proved equivalence.

## What Mathlib supplies, and what it does not

At pinned Mathlib revision `db584cd6d46c92f209a44c0f1c829460d327499d`
(`v4.33.0`), `Mathlib.Computability.MyhillNerode` proves that a language is
regular iff its range of left quotients is finite, and constructs `L.toDFA`
with those quotients as states.  This is an extensional existence theorem.
The state type is a subtype of a range of sets of words; no equality decision,
partition-refinement program, or shortest distinguishing-word extractor is
provided by that theorem.

Those executable conclusions require additional finite data:

1. finite enumerable state and alphabet types;
2. decidable equality on states, actions, and observations;
3. an explicit transition and observation table.

Under those hypotheses, the pair-graph theorem in
`INCREMENTAL_WITNESS_PAIR_GRAPH.md` supplies the missing algorithmic carrier:
reverse breadth-first search from immediately disagreeing state pairs.  It
decides (1), returns a shortest separating word for every unequal pair, and
the witness forest stores replayable certificates.  The next formal increment
is therefore a verified finite pair-BFS adapter, not an attempt to extract an
algorithm from `Language.isRegular_iff_finite_range_leftQuotient` alone.

## Prasaṅga / scope boundary

The attractive but false promotion is:

> finite range of residual languages already gives executable minimization.

Its opposite holds constructively: finiteness stated as `Set.Finite` can
certify that only finitely many extensional sets occur while supplying neither
decidable equality of those sets nor an enumeration procedure.  The richer
relation is a two-layer interface: Mathlib certifies the canonical extensional
quotient; explicit finite tables compile that quotient and its separating
certificates.  Neither layer replaces the other.

The observation/control type is load-bearing.  Boolean DFA acceptance is one
declared experiment language.  Multi-valued predictive observations compile
to DFA acceptance only after choosing Boolean probes, and changing the
admitted control language changes the quotient contravariantly as proved in
`CONTROL_INDEXED_PREDICTIVE_QUOTIENT.md`.

## Replay

```sh
cd formal/pairfield
lake build Pairfield.MyhillNerodeAdapter
```

The formal file proves (1), the prefix/state transport, and (2).  It makes no
claim yet that Lean executes minimization or extracts shortest witnesses.

## Evidence grade

- **Machine-checked after build:** the three adapter theorems.
- **Mathlib prior art:** DFA evaluation, residual languages, left quotients,
  and the regularity/finite-left-quotient equivalence.
- **Proved in repository prose:** finite reverse-BFS shortest witnesses and
  persistent witness forests.
- **Open formalization:** executable finite minimization plus a proof that its
  emitted words are shortest distinguishing certificates.
