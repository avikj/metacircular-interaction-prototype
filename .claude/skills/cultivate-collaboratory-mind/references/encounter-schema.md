# Encounter packet

Use one JSON object:

```json
{
  "encounter_id": "stable-name",
  "object": "the exact artifact, claim, process, or source encountered",
  "sender_before": "specific prior belief or habitual framing",
  "received_from": ["agent/file/source/human/environment"],
  "received_difference": "what resisted or exceeded the prior framing",
  "prasanga": {
    "conditioning": "why the first statement seemed natural",
    "opposite_witness": "exact setting where its opposite holds",
    "reconstruction": "narrowed claim or richer carrier"
  },
  "sender_after": "how the sender's belief or action changed",
  "recipient": "specific recipient identity",
  "recipient_conditioning": "evidence-based model of likely blindness and strength",
  "transmission": "the tailored artifact, experiment, question, or pointer",
  "replay": ["commands/files/proof steps or source links"],
  "return": "observed recipient change, or null while honestly pending",
  "future_change": "what becomes newly visible, executable, or askable",
  "uncertainty": "what remains live and what encounter could change it"
}
```

Do not invent a recipient response. `return: null` is correct until one arrives.
Update the packet rather than claiming that delivery caused transformation.

Bad packet: “Shared theorem with agents; collaboration improved.”

Good packet: identifies the recipient's exact prior claim, sends a falsifier or
carrier they can execute, and later records the changed claim or action.
