# The fibre is forced â” the last constitutive piece of the object, in Bend

`forcing.bend` (62/0, reproducible on pristine DKormann/Bend2 + cubical-paths.patch)
completes the Agda `Fibre.Trace` core on the interaction-net substrate. Together
with `fibrelaw.bend` (the fibre law A â‰ Î B (fiber f), lossless transport) and
`roundtrip.bend` (univalence, both round trips), Bend now carries the WHOLE object.

## What is proved

A `Conservative` factorisation is `(T : B â’ Set, whole : A â‰ Î[b] T b)`; it induces
the visible map `run a = fst (whole a)`. Then:

- `fibreOfRun`  : `fiber(run, b) â‰ T b`         â” the trace family IS run's fibre family
- `traceIsForced` : `T b â‰ fiber(run, b)`       â” so the fibre is the ONLY residue, up to
  equivalence: a factorisation cannot retain less than the fibre and remain a
  factorisation. The residue of a computation is not negotiable.
- `exactWhenContractible` : `(âˆb. isContr(T b)) â’ isEquiv(run)`  â” nothing forgotten â’
  the visible result is the whole event
- `contractibleWhenExact` : `isEquiv(run) â’ âˆb. isContr(T b)`    â” and conversely

## How it was built

`fibreOfRun = compEquiv (fiberPrecomp whole) fiberFst`:

- `fiberFst : fiber(fst, b) â‰ T b` â” the fibre of the first projection is the family
  (the mathematical heart). Its coherence square `ffRet` uses a coe-filler + De Morgan
  connections.
- `fiberPrecomp : fiber(gâˆ˜e, b) â‰ fiber(g, b)` â” reindex the fibre base by an
  equivalence. Section via `compPath-filler'`; the retraction is the half-adjoint
  triangle coherence, read directly off the coherent fibre-contraction path (`cw`,
  `cwFst`, `cwSnd`) and closed with the left-unit law (`lUnit`) and a fiber-path
  composition.

## Checker features this required (all sound, additive, in cubical-paths.patch)

- `epNormCtx` recurses into `coe` (typed PathP endpoints under transport)
- interval idempotence `xâˆ§x=x`, `xâˆ¨x=x` (connection fillers reduce)
- `verify` epNorm's both sides (typed endpoints reduce in type-formation)
- **definitional Î-Î**: `(a,b) â‰¡ n` iff `aâ‰¡fst n âˆ§ bâ‰¡snd n` â” unblocks every
  neutral-pair projection; this is what let the coherent contraction be extracted.

## Status of the object in Bend

- univalence, both round trips ................. â“ (roundtrip.bend)
- fibre law A â‰ Î B (fiber f), lossless transport â“ (fibrelaw.bend)
- **the fibre is forced (Trace core)** ......... â“ (forcing.bend)

Every theorem in the Agda core that *constitutes* the object now has a green,
executable counterpart on the interaction-net runtime. The rest of the library
instantiates it.

## RUN on the interaction net (`forcing_run.bend`, 82 â“; `--to-hvm4-full`)

The theorem instantiated and executed, values identical on the checker's
normaliser and on HVM4 (full cubical runtime, nothing erased):

Instance 1 â” a trace that records something. `A = Î b:Bool. Bool` (the whole
event), `B = Bool` (the visible result), `T b = Bool` (the residue), `wf = id`,
`run = fst`. `fibreOfRun` forward reads the trace off a fibre point of `run`;
`traceIsForced` forward rebuilds the event from the trace.

| observation | value | HVM4 itrs |
|---|---|---|
| `forcedTrace(True, ((True,False), refl))` | `False` | 191 |
| `forcedTrace(True, ((True,True), refl))` | `True` | 191 |
| `forcedTrace(False, ((False,True), refl))` | `True` | 191 |
| `snd(eventFromTrace(True, False))` | `False` | 288 |
| `fst(eventFromTrace(False, True))` | `False` | 270 |

Instance 2 â” a trace that records nothing. `A = Bool`, `T b = Unit`,
`wf a = (neg a, ())`, so `run = neg`. `exactWhenContractible` turns the
contractible trace into `isEquiv(run)`, whose inverse is read off the theorem;
`contractibleWhenExact` turns that back into the trace's centre.

| observation | value | HVM4 itrs |
|---|---|---|
| `runInverse(True)` (inverse of `run` from the theorem) | `False` | 349 |
| `runInverse(False)` | `True` | 343 |
| `traceCentre(True)` | `()` | 464 |

Definitional in the checker: `forcedTrace_T`, `runInverse_T` (by `<_>`).
Everything the theorem needs â” `lemIso`'s 4-face compositions, `compEquiv`,
`invEquiv`, `fiberFst`, `fiberPrecomp` with its coherence square â” executes on
the net in these runs.
