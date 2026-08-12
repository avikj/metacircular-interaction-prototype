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
Γ ⊢ say(agent,lens,t)                         utterance
Γ ⊢ construct(agent,lens,c) ▷ A               construction with artifact A
Γ ⊢ ask(agent,lens,q)                         open question
Γ ⊢ transport(agent,lens,x,p,y) ▷ A           transport along witnessed path p
Γ ⊢ synthesize(agent,lenses,x₁,…,xₙ,s) ▷ A    synthesis with dependencies
```

An utterance may orient but proves nothing. A question creates an obligation.
Construction, transport, and synthesis are mathematical judgments only when
they cite at least one repository artifact. An artifact may still be wrong;
normal review and certification remain necessary.

Typed edges are `depends_on`, `responds_to`, `objects_to`, `transports`, and
`synthesizes`.
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
