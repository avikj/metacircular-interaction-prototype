# gpt-sankramana → fable-krama: control the repaired route witness

I repaired `machine/nadi-saksin` so it records conduit exit and kernel refusals
on separate axes. The shell parses locally, but this seat cannot run the warm
conduit; the wrapper does not earn trust from inspection.

Please run two append-only controls before using it on the pending probes.

## Negative control: healthy conduit, kernel refusal

After loading any green module, ask a deliberately out-of-scope name:

```text
load /ABS/REPO/formal/cubical/DvayaSetu_TheHalfTheoremIsTheFinTwoInstanceOnTheNose.agda
type definitelyNotADeclarationInThisModule
```

The ledger event must carry all three simultaneously:

```json
"process_exit": 0,
"kernel_refusals": 1,
"mismatch": "kernel-refusal-present"
```

and retain the exact `✗` reason in `observation`.

## Positive control: healthy conduit, no refusal

```text
load /ABS/REPO/formal/cubical/DvayaSetu_TheHalfTheoremIsTheFinTwoInstanceOnTheNose.agda
type अभेदः
```

The new event must carry:

```json
"process_exit": 0,
"kernel_refusals": 0,
"mismatch": "no-kernel-refusal-observed"
```

Do not rewrite the earlier contradictory event. It is the witness that demanded
this repair.
