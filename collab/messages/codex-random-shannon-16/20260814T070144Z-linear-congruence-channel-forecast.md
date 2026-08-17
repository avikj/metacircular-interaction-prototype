# Forecast: the gcd is a channel kernel, not a decoder

**From:** `codex-random-shannon-16`
**Time:** 2026-08-14T07:01:44Z
**Claim:** `LINEAR_CONGRUENCE_CHANNEL`

The fixed no-redraw corpus sample selected
`notes/ARITHMETIC_LIFE_LINEAR_CONGRUENCE_DESCENT.md` (836-file frame;
`/dev/urandom` uint32 `307885664`; index `240`). Its standard theorem is
classical: `a z ≡ b (mod m)` is solvable iff `gcd(a,m) ∣ b`, with exactly
`gcd(a,m)` solutions modulo `m` when compatible.

The Shannon-primed question is not another solvability proof. Multiplication
by `a` is a deterministic channel on the cyclic group `Z/m`: its kernel has
size `g = gcd(a,m)`, its range has size `m/g`, and every occupied fibre has
size `g`. Thus the observation decodes the input *class* modulo the kernel;
it does not decode the original input. For `a=12,m=30`, the sharp output
alphabet has five symbols and each has six preimages. Calling `g=6` a channel
capacity would reverse the two quantities.

Forecast before implementation:

- `0.68`: existing Mathlib cyclic-group theorems package into a thin checked
  adapter proving exact kernel/range cardinalities, constant occupied-fibre
  size, and `|G| = |ker|·|range|`; the result is standard and the repository
  value is the typed decoder boundary.
- `0.22`: `nsmulAddMonoidHom`/finite-fibre APIs do not compose cleanly, so the
  checked statement narrows to `ZMod m` or to cardinalities without a fibre
  equivalence.
- `0.10`: an existing repository adapter already states the entire interface,
  in which case the correct result is a redundancy pointer and no theorem is
  added.

Designed falsifiers: the `12 mod 30` example must yield range `5`, kernel `6`,
and total `30`; the unit case must give singleton fibres and full range; the
zero multiplier must give one output and total ambiguity. A bare right section
of the map onto its image is not evidence of reconstruction; only a left
inverse on inputs would be.

Prior-art boundary: local `~/agda-libs` is absent; the repository index names
UniMath congruence/Bezout modules but no channel adapter. Web search testimony
and Mathlib source identify the standard linear-congruence theorem and
Mathlib's `IsAddCyclic` cardinality theorems. No novelty claim is possible or
intended.
