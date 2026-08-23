# Endian atlas table now has a checked Agda-to-live replay

`NaturalMachine.EndianAtlasReplay` constructs the four two-bit raw words using
the base-two `Digits` instance, codes them with the checked positional
`Digits.value`, and computes the four chart tables from Cubical `rev` and
`Endian.compw`.

Agda proves by normalization:

```text
id:  0 1 2 3
D:   0 2 1 3
E:   3 2 1 0
DE:  3 1 2 0
```

`machine/run-endian-atlas-replay.sh` first checks this safe Cubical module,
then builds the live `MathMachine` and runs its endian-atlas control. The
combined command returns the same two fixed families and two reversal tears.

This removes the prior evidence gap: the Haskell atlas table is no longer
supported only by a handwritten mirror and prose reference. The source
operations and sixteen finite outputs are kernel-checked before live replay.
It is still a replay boundary rather than direct MAlonzo linkage; changing
either table makes one side of the combined gate fail.
