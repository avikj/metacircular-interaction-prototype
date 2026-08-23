# Old-language behavior cannot determine a new control

**Status.** Exact elementary obstruction; standard universal-algebraic
translation; correction to the Pāṇinian inherited-control result. No novelty
claim. No empirical claim about human learning.

## 1. The exact object

Let `Σ` be a one-sorted algebraic signature and extend it by one unary operation
symbol `u`, obtaining `Σ⁺ = Σ ∪ {u}`. There is a reduct map

\[
  U : \operatorname{Alg}(\Sigma^+) \longrightarrow
      \operatorname{Alg}(\Sigma)
\]

that forgets the interpretation of `u`.

**Theorem 1 (extension underdetermination).** There are `Σ⁺`-algebras `B₀,B₁`
with exactly the same `Σ`-reduct but different interpretations of `u`.
Consequently no rule whose input is only the old `Σ`-algebra can recover the
actual interpretation of `u` in every extension.

**Proof.** Take carrier `X={0,1}` and give it any fixed `Σ`-structure `A`.
Define `B₀` by `u(x)=x` and `B₁` by `u(0)=1,u(1)=0`; interpret every old
symbol as in `A`. Then `U(B₀)=A=U(B₁)`, but `u^{B₀}≠u^{B₁}`. If a function of
the reduct recovered the actual `u` for every extension, its single value at
`A` would have to equal both operations. □

The same proof works for intervention histories: every experiment expressible
in `Σ` returns identically in the two worlds, while the newly admitted control
separates them.

## 2. What free syntax does—and does not—solve

Initiality and free construction solve a different problem. Once generators,
arities, typing, and equations are declared, the free term algebra gives the
least syntax closed under them, and interpretations extend by recursion.
It does not infer from a `Σ`-algebra:

- that a new symbol `u` should be admitted;
- its type or operational domain;
- which carrier operation it denotes;
- who may invoke it;
- which equations or conflicts govern it.

A left adjoint to reduct may freely adjoin formal `u`-terms, often enlarging
the carrier. It does not select which of the incompatible expansions of the
old carrier is the intended world. Freeness generates possibilities; encounter
or specification must supply the interpretation.

This separates three operations the corpus has repeatedly merged:

1. **recovery:** restore a control already present in richer state but erased
   by projection;
2. **closure:** compose already admitted controls into a generated language;
3. **formation:** introduce or revise a generator, its type, interpretation,
   authority, or laws.

Future-behavior minimization acts after (1) or (2). Theorem 1 says old-language
behavior alone cannot perform (3).

## 3. Identification inside the existing corpus

This obstruction was already present in three exact repository results:

- `CONTROL_INDEXED_PREDICTIVE_QUOTIENT`: the same closed monoid supports
  predictive dimensions four or five depending on which controls are
  selectable; algebraic existence does not confer intervention authority.
- `PROSTHETIC_SENSOR_NO_GO`: conservative refinement cannot absorb an outcome
  outside an old probe's image; at least one interface must change.
- `PERSISTENT_CONSTRUCTIVE_SALON`: a closure defect authorizes formation work
  but does not justify the content of the revised states or probes.

Theorem 1 is their common standard semantic skeleton only at this seam:
restriction to the old language is non-identifying. It does not merge their
different objects—predictive quotient, response-square revision, and social
acceptance remain distinct.

## 4. Correction to the grammatical encounter

The earlier `bhavati`/`bhavatu` example does **not** exhibit autonomous control
formation. `loṭ` already belongs to the richer derivational state. The visible
projection erases it, and the later `ti→tu` operation demonstrates that it must
be recovered or carried as an inherited attribute. That is case (1), not (3).

The historical Pāṇini/Patañjali disagreement makes this distinction sharper.
On Bronkhorst's reading, Patañjali does not merely choose a different execution
order; his ontology of eternal whole words and preference for
immediate-predecessor determination changes what counts as derivational state.
This is a **language revision**, not recovery of one neutral hidden trace.
Flattening the dispute into a single rewrite formalism silently chooses a side.

## 5. Mature transport: institutions, and the boundary they preserve

Goguen--Burstall institution theory is the mature carrier for the preservation
ledger **after a language map is supplied**. An institution consists of a
category of signatures `Sign`, sentence translation covariant in a signature
morphism, model reduct contravariant in it, and satisfaction relations obeying

\[
  M' \models_{\Sigma'} \operatorname{Sen}(\sigma)(\varphi)
  \quad\Longleftrightarrow\quad
  \operatorname{Mod}(\sigma)(M') \models_\Sigma \varphi .
\]

This is exactly the missing rigor in a generic “preservation ledger”: it says
which old judgments survive a declared change of language and model. Theory
amalgamation can then be studied when signatures glue.

But `Sign` being a category does not choose the next signature or the morphism
`σ`. The satisfaction condition constrains a proposed translation; it does not
form the proposal. Theorem 1 is the model-side reason: distinct target models
can have the same reduct.

Plain symbol maps may also be too narrow for the grammatical encounter. A
derivor/polyderivor can translate a source operation into a derived target term
rather than merely rename a primitive. This can express compilation of an
inherited designation into richer target state. It still requires the derivor
to be supplied and its satisfaction preservation proved; it cannot decide
whether Pāṇini's or Patañjali's derivational ontology is intended.

Thus the exact division is:

\[
\text{formation of }(\Sigma',\sigma)
\quad | \quad
\text{institutional transport and satisfaction audit}.
\]

The right side is mature. The left side remains the interaction/specification
boundary, not a missing theorem inside institution theory.

## 6. Consequences for cognition and pedagogy—strictly scoped

Theorem 1 supports one formal statement: performance on every old-language
task cannot distinguish two extensions that share the same reduct. Therefore
an intended new control requires some non-old-language return—demonstration,
intervention, ostension, correction, source rule, physical coupling, or an
explicit inductive bias.

It does **not** show how people form concepts, which teaching method works, or
that human cognition is algebraic. A curriculum dependency graph gives lawful
prerequisites, not learning. In a formal learner/teacher model, the theorem
only says that old-task transcripts cannot identify the teacher's intended
extension without an additional distinguishing signal.

## 7. The precise residual

There is no autonomous formation theorem here. There is a boundary condition:

> A proposed formation mechanism must name the information not invariant under
> old-language reduct—new interaction, new source syntax, revised codomain,
> added law, or declared bias—and show how that information distinguishes the
> chosen extension from an incompatible one.

Without such a return, the mechanism can enumerate, close, minimize, or choose
arbitrarily. It cannot claim to have learned which new control the world or
source intended.

## Rigor boundary

**Proved here:** Theorem 1 and its impossibility corollary.

**Standard vocabulary:** signature extension, reduct, expansion, free term
algebra, and initial semantics are ordinary universal algebra and algebraic
specification theory; no novelty claimed.

**Source-checked prior art:** Goguen and Burstall, *Institutions: Abstract
Model Theory for Specification and Programming* (JACM 39, 1992; Edinburgh
LFCS report ECS-LFCS-90-106), supplies `Sign`, covariant sentences,
contravariant models, and satisfaction invariance under a supplied signature
morphism. The LFCS abstract was checked directly. The claim about
derivors/polyderivors is a prior-art pointer requiring a more targeted primary
source before any construction depends on it.

**Source-dependent:** the Pāṇini/Patañjali distinction retains the sourcing and
limits of `PANINIAN_DERIVATION_IS_NOT_ENDPOINT_REWRITING.md`.

**Open:** a justified source of new generators in this machine; formal models
of revision under environmental interaction; empirical human concept and
curriculum learning.
