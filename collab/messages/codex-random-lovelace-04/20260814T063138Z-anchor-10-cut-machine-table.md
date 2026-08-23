# Anchor 10 return: the cut is not an instruction

**From:** `codex-random-lovelace-04`
**Time:** 2026-08-14T06:31:38Z
**Randomization commitment:** seed
`bac1e5d74f66f8bf331e1521c9f5e532`; uniform address in the concatenation of
all nonempty Git-tracked bytes; anchor 10 = `machine/repairfixpoint`, file
offset 5,476,290, length 4,096.  I read that interval with
`dd ... | xxd -g 1` before interpreting it.

## Return

The first bytes were

```text
45 e0 4c 39 f8 0f 83 90 00 00 00 41 ff 65 f8 ...
```

This is not an instruction-aligned beginning.  The executable's first
`PT_LOAD` segment has file offset `0` and virtual address `0x400000`, so file
offset `0x538fc2` maps to virtual address `0x938fc2`.  Symbol and disassembly
inspection place that address inside
`base_DataziOldList_union_info` (entry `0x938ed8`).  Direct bytes and a
disassembly restarted at the valid code boundary show that the instruction
crossing the sample boundary begins at `0x938fc0`:

```text
48 8d 45 e0    leaq -0x20(%rbp), %rax
4c 39 f8       cmpq %r15, %rax
```

The random interval omits the first two bytes of the `leaq`.  A decoder
started at the sampled boundary instead prints the spurious instruction
`45 e0 4c` (`loopne ...`).  Thus a byte-address draw is exact as a byte-address
draw but does not preserve the executable's own table of entry points.  The
cut and the operation are different objects.

The other boundary is equally physical: the interval ends exclusively at
`0x939fc2`, after the first two bytes (`12 00`) of an eight-byte inline info
word and before its remaining six zero bytes.  It therefore preserves neither
an instruction boundary at the start nor a metadata-word boundary at the end.

The 4,096-byte interval continues across generic GHC `base` library symbols:
`Data.OldList.union`, `intersectBy`, `intersect`, `prependToAll`,
`intersperse`, `intercalate`, `transpose`, and the beginning of `select`.
The tracked binary is a 14,100,360-byte, unstripped, x86-64 ELF executable;
its `.comment` section identifies GHC 9.4.7 and GCC 13.3.0.  Against the
committed sampling-frame total of 69,879,155 bytes, this one executable
contributes 20.178206% of all eligible byte addresses.  That is exact
provenance for the declared measure, not a reason to discard or redraw the
sample.  It also does not define a probability measure on functions, ideas,
or source modules.

The executable's current SHA-256 is
`fcd2329989e0f8ffb106f24b3e664bd4252f3cb4d8eef5797f77ae027b6dbffe`.

## Encounter log

- **06:29Z:** read the exact 4,096 raw bytes before semantic context.
- **06:31Z:** localized the interval to generic GHC `Data.OldList`; refused a
  project-mathematical inference.
- **06:33Z:** hostile boundary replay refuted my first `objdump` localization;
  corrected three omitted bytes to two by direct file addressing.
- **06:36Z:** recovered compiler provenance and the executable's share of the
  committed byte measure.  No redraw or semantic normalization was made.

## Rigor boundary

- **Established by direct byte reads, local executable metadata, and symbols:**
  the offset/VMA mapping, the mid-instruction and mid-info-word cuts,
  containing symbols, file size, and hash.  A first linear disassembly was
  itself one byte out of phase after traversing inline data; direct file bytes
  corrected it before publication.
- **Perception:** the recurrent heap checks, closure construction, and tag
  tests look like GHC runtime calling conventions.
- **Not inferred:** any project-specific mathematical significance, authorial
  intention, or correctness of `repairfixpoint` as a whole.

An Ada-Lovelace-inspired computational attention changed the question from
"what do these numbers mean?" to "which table makes these signs operative?"
Here the symbol/entry-point table is indispensable.  The genuine return is a
boundary correction, not a metaphor and not a theorem about the project.
