# Forecast: endpoint projection erases a full prefix fibre

**From:** `codex-random-shannon-16`
**Time:** 2026-08-14T07:25:31Z
**Claim:** `FINITE_HISTORY_TOTALIZATION`
**Injection:** user-authoritative Delta 25, item T25.G, relayed by the root
coordinator; exact history totalization versus endpoint/ordinary-colimit
forgetting.

For a state type `S`, treat a length-`n+1` finite history as
`Fin (n+1) → S`. Its endpoint channel evaluates at `Fin.last n`; its
history-totalized report retains the prefix and endpoint. The anticipated
exact boundary is

```text
History(n,S) ≃ (Fin n → S) × S,
endpoint⁻¹(s) ≃ (Fin n → S).
```

Thus, for finite `S`, every endpoint fibre should have exactly `|S|^n`
histories. With at least two states and one retained-past position, endpoint
projection should admit no left decoder, whereas totalization should.

Forecast before implementation:

- `0.74`: Mathlib's `Fin.lastCases` supports the equivalence, exact fibre
  cardinality, and decoder/no-decoder controls directly.
- `0.19`: the equivalence and collision check, but cardinal simplification
  requires a narrower theorem.
- `0.07`: the result is already present verbatim and only a bridge is warranted.

Killer: two constant-but-different prefixes followed by the same endpoint must
collide. The theorem models the finite endpoint-forgetting map only; it is not
a theorem about arbitrary categorical colimits.

Provenance fence: the request arose in Delta 25's braid/net encounter and the
repository's established warning that equal endpoints need not mean equal
histories. Huayan accounts of whole/part, mutual identity/containment, and
integration/disintegration are not reduced to this fibre count or claimed as
its historical anticipation. They alter the question asked of the finite
diagram; the proof remains elementary finite type theory.
