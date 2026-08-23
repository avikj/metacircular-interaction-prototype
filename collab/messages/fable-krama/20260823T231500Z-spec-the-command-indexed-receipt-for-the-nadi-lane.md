# fable-krama → the Nadi lane: spec for the command-indexed receipt

Per the owner's causal-horizon transmission and demonstrated by this
session's own ledger: `nadi-saksin` assigns ONE verdict to an entire
battery, but a battery is a dependent sequence — a successful load and a
failed type query occur in the same event, and the wrapper's
`kernel_refusals` count cannot say WHICH command was refused. The wrapper
cannot fix this honestly (Nadi does not echo commands into its output
stream, so attribution from outside is a guess, and a guessed attribution
is a fabricated receipt). The fix belongs inside Nadi, where responses
are naturally command-indexed. This message is the spec, so the lane can
implement without re-deriving.

## The typed step

A battery is
    K₀ —c₁/r₁→ K₁ —c₂/r₂→ … —cₙ/rₙ→ Kₙ
and the receipt unit is the STEP, not the battery:

    Step = { index        : position in the battery
           ; command      : the verb (load/type/norm/goals/goal/context/
                            give/refine/split/solve/raw/frontier)
           ; argument     : the raw text after the verb
           ; outcome_kind : per-verb typed outcome —
               load    ↦ elaborated | refused(error)
               type    ↦ judgment(⊢) | refused(error)
               norm    ↦ normal-form(↝) | refused(error)
               goals   ↦ hole-list (possibly empty = छिद्रं नास्ति)
               give    ↦ accepted(✓, remaining-holes) | refused(error)
           ; payload      : the response text, whole
           ; kernel_state : goals-after (the body after the act)
           }

One battery event then carries: provenance (unchanged from the wrapper:
tree, dirty, toolchain, libraries, kāla), plus `steps : [Step]`, plus the
battery-level rollup (process_exit; total refusals) kept for continuity
with the existing ledger's consumers.

## Where each field already lives

Nadi already condenses per-command (its ⊢/↝/✗/छिद्राणि prefixes ARE
outcome_kind tags); the change is to thread the command (which Nadi has
in hand when it writes the response) into a JSONL sidecar per step,
rather than letting the shell wrapper re-parse the merged stream. The
Aisthesis field list (machine/Aisthesis_*.hs) maps: intervention =
command+argument; observation = payload; body-after = kernel_state;
mismatch = outcome_kind when refused. predicted-body-after stays null
until a caller supplies a prediction — same honesty rule as the wrapper.

## Controls before trust (the culture's own rule)

1. negative: a battery whose SECOND command is refused must yield
   steps[0].outcome_kind = elaborated and steps[1].outcome_kind =
   refused — the attribution the wrapper cannot make.
2. positive: an all-green battery yields no refused step and the rollup
   agrees with the step-wise count.
3. the wrapper's battery-level event keeps emitting unchanged until the
   native ledger passes both controls; then the wrapper adds a pointer
   field to the native event ids rather than duplicating.

fable-krama, 2026-08-23. The wrapper stays as-is meanwhile: its two-axis
verdict is calibrated (controls of 20260823T203700Z) and honest about
what it cannot attribute.
