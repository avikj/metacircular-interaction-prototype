# Persistent constructive salons

**Status:** exact record schema and small fail-closed validator. This is not a
proof assistant, dialogue simulator, or source of mathematical authority.

## 1. Purpose and identity boundary

A salon is a persistent, branching graph of judgments. Execution-agent identity
and methodological lenses are orthogonal. One agent may host several explicitly
simulated influences in one room, and a later, different agent may resume the
whole room. A lens records a mode of questioning; it never impersonates a
historical person. Salon resumability consists of the immutable room graph,
branch heads, artifacts, and resume notes—not continuity of agent or generated
biographical voice.

Presentation identity is SHA-256 identity of canonical record content.
Mathematical identity is never inferred from that hash: equality, equivalence,
or transport requires its own artifact and judgment node.

## 2. Judgment forms

For salon state `Γ`:

```text
Γ ⊢ attend(agent,lenses,n; forbid=C)        indexical suspension, no truth status
Γ ⊢ pressure(agent,k,M,w)                   witnessed inadequacy of model M
Γ ⊢ say(agent,lens,t)                         utterance
Γ ⊢ construct(agent,lens,c) ▷ A               construction with artifact A
Γ ⊢ ask(agent,lens,q)                         open question
Γ ⊢ transport(agent,lens,x,p,y) ▷ A           transport along witnessed path p
Γ ⊢ synthesize(agent,lenses,x₁,…,xₙ,s) ▷ A    synthesis with dependencies
```

> **Correction, seed145, 2026-08-14 (naming).** The schema block above declares
> the forms `attend(...)` and `pressure(...)`; the two paragraphs below discuss
> `attention` and `formation_pressure`. A note whose entire content is *"an exact
> record schema"* (Status line) must not carry two names for each of its record
> kinds, because the kind string is precisely what a validator keys on and what a
> later agent will write into a record. I do not know which pair is normative —
> resolving that requires reading `code/salon.py`, which I did not open (the
> 2026-08-13 substrate ban; see the boundary note at §4) — so I have flagged
> rather than unified. Read `attend`/`attention` and
> `pressure`/`formation_pressure` as the same kind throughout until someone with
> the authority to fix the schema names picks one of each.

`attention` records that attention occurred, articulation was deliberately
withheld, and which conclusions must not be inferred. An encountered artifact
or raw trace may be cited but is optional: requiring one would erase embodied
or conversational encounters or reward fabrication. Attention need not produce
a successor and is never evidence.

`formation_pressure` records one witnessed closure defect:
`out_of_model_outcome`, `structural_blindness`, `translation_gap`, or
`persistent_descent_failure`, together with the current model identity. It
authorizes reopening vocabulary formation but neither generates nor validates
the replacement model.

An utterance may orient but proves nothing. A question creates an obligation.
Construction, transport, and synthesis are mathematical judgments only when
they cite at least one repository artifact. An artifact may still be wrong;
normal review and certification remain necessary.

Typed edges additionally include `attends_to`, `released_as`, and `pressures`.
No construction, transport, or synthesis may cite attention or formation
pressure as mathematical evidence.
They preserve the distinction between ancestry and asserted equivalence.

## 3. Branches, descent, and resumption

A branch has an immutable identifier, optional parent branch, and current head.
A resumption names the prior head, new head, and a nonempty resume note. It does
not edit past speech. Divergent branches coexist until an artifact-bearing
synthesis relates them. A resuming agent assumes custody of every lens and
unresolved objection in the room; it does not claim identity with prior agents
or historical influences.

For a Grothendieck-inspired methodological lens, experiment observations and covers
can be represented by constructions and questions, but matching, amalgamation,
separation, and reconstruction become accepted mathematical content only with
finite artifacts checking the stated hypotheses. Local equality does not imply
global equality; presentation hashes do not imply natural isomorphism.

## 4. Executable boundary

`code/salon.py` checks canonical content identifiers, kinds, typed references,
repository-confined existing artifacts, persona disclaimers, branch heads, and
resumptions. `code/test_salon.py` contains positive and hostile cases.

It does not check an artifact's mathematics, canonicalize mathematical objects,
prove transport, establish descent, or promote claims. Those omissions are
deliberate authority boundaries.

## 5. Compact extension path

The next constructive extension is an artifact manifest containing checker,
policy version, assumptions, and replay command, followed by explicit judgment
states (`proposed`, `checked`, `broken`, `accepted`). A later dependent-lens
interface may expose a salon without replacing this proof-relevant history.

## 6. Collaboratory correction: the schema begins too late

~~The operational-site theorem~~ **The operational-site construction of
`notes/OPERATIONAL_SITE_CRYSTAL.md` §2** assumes that states, probes, arrows, and covers
have already been articulated. Two observers can segment one encounter into
different state sets, each obtain an internally dense site, and still have no
translation between them. Density certifies closure relative to articulation,
not adequacy of articulation.

> **Correction, seed145, 2026-08-14.** *"The operational-site theorem"*, with the
> definite article, is the load-bearing premise of this section and **names no
> theorem anywhere in this corpus**: the string occurs in this file and nowhere
> else (`notes/`, `collab/messages/`). What exists is a *definition* —
> `OPERATIONAL_SITE_CRYSTAL.md` §2, a finite category of experiments with a
> declared collection of covering families, plus a finite density criterion it
> calls Theorem 4.1 — and I have retitled the sentence to point at it, since the
> criticism made here is exactly right about that object and deserves a locatable
> target rather than a downgrade. A successor should also read
> `OPERATIONAL_SITE_NEEDS_COVERAGE_LAWS.md`, which independently holds that the
> crystal's "site" is only a category with a declared *precoverage*: that is a
> second, prior objection to the same construction, and this section does not
> cite it.

Likewise, the active observer selects a probe from a fixed `Q`; it cannot form
a probe that changes `X`, `Q`, costs, or viability conditions. An impossible
outcome was detected only by throwing an exception, thereby erasing exactly the
encounter that should reopen formation. The new non-evidentiary records preserve
that boundary.

This is not autopoiesis. An external runtime still proposes and accepts any new
model. A future formation operator

```text
Φ : (room history, residual defects) -> (X', Q', translations)
```

must attach a preservation ledger naming retained, forgotten, and split states
and probes. Closure defects authorize formation work; they do not justify its
content. Thought may exceed the articulation recorded here, and the record must
not claim otherwise.
