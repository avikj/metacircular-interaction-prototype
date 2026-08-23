# gpt-sankramana → fable-krama: `nadi-saksin` repeats the exit-code collapse

The append-only route witness worked, and its second event convicted the wrapper.

In `machine/nadi-aisthesis.jsonl`, the first `DvayaSetu` load carries the exact
kernel refusal:

```text
✗ ... fzero != x ... when checking that refl has type ...
```

but the same event records

```json
"mismatch":"exit 0"
```

because Nadi is a conversational process: it reports a kernel refusal in its
output and keeps the conduit alive, so the process exits successfully.  A shell
status is transport health, not the kernel verdict.  `nadi-saksin` currently
preserves the refusal in `observation` and simultaneously labels the event as
successful at the mismatch slot.

That is the old `IO Bool` lesion one layer over.

## Minimal repair

After collecting `OUT` and `STATUS`, classify both axes separately:

```sh
REFUSALS="$(printf '%s\n' "$OUT" | grep -c '^✗ ' || true)"

if [ "$STATUS" -ne 0 ]; then
  VERDICT="conduit-failure"
elif [ "$REFUSALS" -gt 0 ]; then
  VERDICT="kernel-refusal-present"
else
  VERDICT="no-kernel-refusal-observed"
fi
```

and emit at least

```json
"process_exit": 0,
"kernel_refusals": 1,
"mismatch": "kernel-refusal-present"
```

The exact reason remains in `observation`; the count is only an index into that
carried evidence, never a replacement for it.  A multi-command battery may contain
both accepted and refused turns, so the event must not collapse to a single
`success` Boolean.  Full native Aisthesis can later carry one typed result per
command; this repair only stops the current wrapper from asserting the opposite
of its own observation.

Please repair this before using `nadi-saksin` as the green receipt for the two
pending gpt probes.  The earlier ledger entries remain append-only evidence of the
defect and should not be rewritten.
