# Rosetta engine: a calculus for discovering mathematics by changing language

The useful denial of "unrelated" is not the claim that everything is
isomorphic.  It is the stricter claim that **absence of a map is relative to a
chosen category of objects and observations**.  When two descriptions resist
comparison, the first mathematical question is which change of category makes
their common structure visible.

This note makes that stance operational.  It complements `METALOOP`: the
metaloop schedules research roles; the Rosetta engine generates and types the
bridges those roles investigate.

## 1. The eight bridge generators

Many productive translations in this repository factor through the following
heuristic, nonexhaustive set of moves.

| move | diagram | proof obligation | characteristic failure |
|---|---|---|---|
| common lift | $A\leftarrow L\rightarrow B$ | exhibit $L$ and both maps | lift adds unconstrained structure |
| common quotient | $A\rightarrow Q\leftarrow B$ | compute both kernels/fibers | shared shadow mistaken for equivalence |
| dualize/transform | $A\leftrightarrow A^\vee$ | inversion or full-faithfulness | phase, boundary, or domain is lost |
| localize | $A\to A[S^{-1}]$ | universal property and torsion kernel | local equivalence hides global obstruction |
| complete | $A\to\widehat A$ | topology and density/injectivity | formal limit invents solutions |
| deform/continue | $A_t$ | control singularities and endpoint | generic truth fails at the critical fiber |
| take boundary | bulk $\to$ boundary class | exact sequence/trace formula | boundary term silently discarded |
| change observer | state $\to$ accessible data | sufficiency and lost charge sectors | positivity or equality survives while truth does not |

Categorification and decategorification are iterations of lift and quotient;
linearization is a tangent/representation-valued lift followed by a quotient.
Renormalization is scale-indexed observer change plus a fixed-point question.

## 2. Tension is a residual, not a verdict

Given claims $P$ and $Q$ that appear incompatible, search for a square

$$
\begin{array}{ccc}
L&\longrightarrow&A\\
\downarrow&&\downarrow\\
B&\longrightarrow&Q
\end{array}
$$

and compute its residual:

- failure to commute suggests a cocycle, anomaly, or missing boundary term;
- a nontrivial kernel identifies information destroyed by an observer;
- agreement locally but not globally suggests an obstruction class;
- equal spectra but unequal objects suggests phase or extension data;
- opposite inequalities often indicate an indefinite form whose primitive
  subspace has the correct sign;
- distinct finite-size laws may be adjoint transforms of one delay or flow.

The residual is often the theorem.  "Goldbach and gaps are equivalent at every
finite place but diverge at infinity" is stronger than choosing either
description.  "Raw positivity is automatic but centered positivity detects
RH" locates the missing operation.  "Prime homometry looks algebraic until a
single parity character reconstructs the set" reveals the forgotten anchor.

Wolfram's observer language has one exact and useful translation here.  A lens
is an explicit quotient $q$ on states or expressions.  A transformation $T$
is well-defined through that lens precisely when

$$q(x)=q(y)\quad\Longrightarrow\quad q(Tx)=q(Ty).$$

Failure is a noncongruence witness, equivalently a commutator/round-trip defect
when the setting is linear.  Multiway paths may enumerate alternative
translations, but their branches merge only under a declared exact quotient
(normal form, proved equality, finite character data), never merely because a
general simplifier says the endpoints look alike.

## 3. Typed composition

Agents may compose bridges only with the following discipline.

1. Exact equivalences compose as exact equivalences.
2. A theorem transports only after every hypothesis is translated and checked.
3. A projection composes with a cumulative preservation ledger: lost
   information never reappears without an explicit new observable.
4. Local statements transport globally only with a vanishing obstruction.
5. Analogies generate packets, never conclusions.
6. An open bridge inside a path makes the entire transported conclusion open.
7. A counterexample terminates the packet; a repaired statement receives a new
   identifier.

This is the epistemic type system missing from an unqualified "Indra's net."
The net is generative because every object may illuminate every other; it
remains mathematics because every strand declares what it preserves.

## 4. The executable discovery grammar

For any pair of corpus results, an agent emits:

```text
OBJECTS:       A, B
TENSION:       the precise mismatch
COMMON OBJECT: lift L or quotient Q
MAP TYPES:     equivalence / theorem / projection / obstruction / analogy
INVARIANT:     quantity preserved on both paths
RESIDUAL:      kernel, cocycle, boundary term, charge, or scale defect
STATEMENT:     smallest exact proposition suggested by the residual
CERTIFICATE:   what could settle it
FALSIFIER:     cheapest decisive attack
SOLVED TWIN:   nearest case where the bridge is already a theorem
PROOF DIFF:    structure present in the twin and absent here
```

The output becomes a packet under `collab/discovery/claims/`; builder,
breaker, transporter, and librarian agents operate on that persistent state.
`code/discovery_loop.py` currently routes packets and checks limited state
consistency. It does not yet certify that claims cannot outrun their evidence.

## 5. Selection without a human bottleneck

The proposed autonomous scheduler should prefer, in order:

1. a contradiction or audit failure that can become a corrected theorem;
2. a tension whose residual is already computable;
3. an open case with a genuinely solved isomorph and a short proof difference;
4. an exact numerical constant with a stable basis and independent precision;
5. a language rotation outside the corpus's dominant vocabulary.

It should stop a branch when the available observable provably cannot
determine the target, the certificate type exceeds the method, or prior art
shows the statement is only repackaging.  Stopping is productive: the no-go,
missing observable, or exact novelty boundary becomes the result.

The loop therefore optimizes neither number of conjectures nor apparent
intelligence.  It optimizes the rate at which tensions become **typed,
audited, reusable mathematical structure**.
