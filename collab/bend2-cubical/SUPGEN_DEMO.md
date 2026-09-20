# Superposed synthesis on the HVM4 C runtime

The frontier capability the cubical port exists to enable, demonstrated
directly on the real interaction-net runtime (build: `clang -O2 -o hvm
src/hvm.c` in HigherOrderCO/HVM4).

## What it shows

A candidate program space is held as ONE superposed value. A spec runs over
the whole superposition in a single evaluation with shared work; `collapse`
(`-C`) enumerates the branches; failing branches erase (`&{}` annihilates them),
so only spec-satisfying universes survive. This is SupGen/NeoGen's mechanism �
proof/program search as evaluation, not external loop � and it runs on the
optimal reducer, where the common substructure of all candidates is computed
once.

## enumerate (`supgen_enumerate.hvm4`)

    @cand  = &L{λx.x, &L{λx.(1 - x), &L{λx.1, λx.0}}}
    @probe = λ&f. #P{f(0), f(1)}
    @main  = @probe(@cand)

`hvm supgen_enumerate.hvm4 -C10` yields all four candidate behaviors in ONE
run (36 interactions total, not four separate executions):

    #P{0,1}   id
    #P{1,0}   not
    #P{1,1}   const 1
    #P{0,0}   const 0

## synthesize (`supgen_synthesize.hvm4`)

    @cand = &L{λx.x, &L{λx.(1 - x), &L{λx.1, λx.0}}}
    @keep = λ&f. λ{ 0: &{} ; _: λp. #OK{f} }((f(0) == 1) .&. (f(1) == 0))
    @main = @keep(@cand)

Spec: `f(0)=1 ∧ f(1)=0` (synthesize NOT by example). `hvm � -C10` returns
exactly the survivor:

    #OK{λa.(1 - a)}          -- 91 interactions

The three failing candidates annihilated; the type/spec-correct universe is
the only one collapse emits. The answer arrives certified (it passed the spec
by construction) and the certificate is the erasure of the alternatives.

## Why this is the frontier

- It is proof/program search *inside evaluation* � the thing LLM generation
  structurally cannot do (no certificate) and classical synthesizers cannot do
  cheaply (no sharing across candidates).
- The affine-variable requirement (`λ&f` to use `f` more than once) is the
  corpus's "determined structure remains present with its determining path"
  showing up as a syntactic obligation of the runtime.
- With the cubical layer's `Sup � Path` rule, such a search is transportable
  across a `ua`: search one representation, obtain the answer in every
  equivalent one. That is the piece no other system has.

Next: scale the candidate space (recursive program grammars), and drive the
search from a Bend2 spec-as-type via the HVM4 emitter, so the survivor arrives
with an erasing type-theoretic certificate rather than a boolean test.
