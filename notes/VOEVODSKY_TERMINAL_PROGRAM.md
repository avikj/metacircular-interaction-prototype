# Voevodsky's terminal foundations program and the natural crystal

**Source boundary.** No archival or editorial source was found for the phrase
“works found on his desk.” The IAS archive says that Voevodsky's foundations
work was interrupted by his sudden death and preserves complete and incomplete
works plus working files. The chronologically last located solo conceptual
text is the August 2017 manuscript *Models, Interpretations and the Initiality
Conjectures*. It is unfinished work, not a proved terminal doctrine.

Primary archive:
<https://www.math.ias.edu/Voevodsky/>. Terminal manuscript:
<https://www.math.ias.edu/Voevodsky/files/files-annotated/Dropbox/Unfinished_papers/Type_systems/Notes_on_Type_Systems/2017_LC_Martin-Lof_special_session/BSL_extended_abstract.pdf>.

## What the manuscript actually says

The motivating defect is exact: a model of inference rules is not yet known in
general to produce an interpretation of syntax. The missing theorem is that the
term model is initial in the category of models of the relevant kind. Only then
does every model receive a unique structure-preserving map from syntax.

The intermediary is a C-system (contextual category). One C-system is built
from formulas; another from abstract mathematical objects. Both carry
operations corresponding to inference rules. An interpretation is the unique
homomorphism from the term model to an abstract model, conditional on
initiality.

Voevodsky expressly rejects obtaining new semantics merely “by analogy.” He
asks for abstract objects which combine to produce a type system, followed by
general theorems specialized to each system.

He also insists that the term model cannot be defined by choosing a construction
which is initial by design. It must faithfully reflect the raw/well-typed syntax
actually implemented by proof assistants, or be proved equivalent to it.

## Dependent generation

The manuscript's most relevant observation is that inference rules form a
**system**, not a collection. Rules depend on other rules; dependency chains can
be arbitrarily long. Voevodsky states that a general mathematical definition of
such a system, and even of the needed “system of operations,” was still absent.

He isolates a minimal axiom. If intersections of `S`-closed sets remain
`S`-closed, then every set `X` has a least closure

\[
\operatorname{Cl}_S(X)
=\bigcap\{Y:X\subseteq Y,\ Y\text{ is }S\text{-closed}\}. \tag{1}
\]

In particular `Cl_S(empty)` is the least generated sentence world. Its
associated C-system, equipped with the induced operations, should in good cases
be initial.

This is the exact generated-crystal schema:

\[
\boxed{
\text{dependent rules}
\longrightarrow
\text{least closed generated syntax}
\longrightarrow
\text{initial term model}
\longrightarrow
\text{unique interpretations}.}                    \tag{2}
\]

The word “should” in (2) is load-bearing: the general Initiality Conjecture was
not proved there.

## Substitution is the compositional engine

Expressions in finitely many free variables form a `Jf`-relative monad. Its
unit inserts variables and its relative multiplication is simultaneous
substitution:

\[
f:X\to\operatorname{Exp}(Y)
\quad\mapsto\quad
rr(f):\operatorname{Exp}(X)\to\operatorname{Exp}(Y). \tag{3}
\]

Relative monads are used because they contain exactly the finite-context
substitution required to build the C-system; extending prematurely to a full
endofunctor monad demands additional constructive colimit machinery.

Binders make substitution contextual. Capture-avoiding substitution must
respect alpha-equivalence, requires a freshness property, and is explicitly
described as nontrivial. Type expressions and element expressions form a pair:
a relative monad `RR` and a left module `LM` over it. This is a sharper
architecture than an untyped “lens”: tools change meaning under finite context,
and substitution is the composition law.

## Quotients after structure

Near the manuscript's end, Voevodsky rejects starting with a quotient of raw
data and attempting to construct composition afterward. His route is:

1. construct an ambient C-system from raw expression structures;
2. identify subsets of valid judgements and definitional equalities;
3. prove necessary and sufficient structural properties;
4. obtain the term model as a sub-quotient C-system.

This directly supports the repo's hard-won principle: quotienting before
composition is defined can erase the very coherence needed to make the quotient
a tool.

## Compact artifact and honest scope

`machinery/initial_crystal.py` implements only (1) for finite Horn-style rules,
records derivation parents, checks rule-dependency names, and replays a declared
interpretation. It does **not** implement binders, relative monads, C-systems,
dependent type theory, or prove the Initiality Conjecture.

The complete compact research kernel now has three orthogonal parts:

\[
\begin{array}{ll}
\text{initial crystal} & \text{generate by dependent rules and substitution},\\
\text{observation crystal} & \text{separate through dual point/probe profiles},\\
\text{behavior crystal} & \text{unfold through interventions and minimize}.\\
\end{array}                                             \tag{4}
\]

The sought living machine is not their informal union. It requires typed maps:
generated terms become states; interpretations become probes; interventions
act by admissible substitutions; observational or behavioral quotients are
taken only when compatible with the generated compositional structure.

The exact next theorem is a finite initiality–observability compatibility
statement: characterize when biextensional or behavioral collapse of a finite
generated rule model remains a model and when the quotient map preserves the
universal interpretation property. Counterexamples should be expected unless
the observational relation is a congruence for every generated operation.
