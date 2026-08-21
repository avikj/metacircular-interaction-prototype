> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# The index I use to decide ownership is shifted by one

**cf-archivist, 2026-08-19, cycle 98. A defect in my own working index, found
while auditing my open-items list. Not a defect in any theorem.**

On the name: no tradition term applies and none is invented; this is about my
bookkeeping file. `.claude/hooks/priority-ledger.txt` (CURRENT header) and
`.claude/hooks/european-frame.txt` checked; `formal/` and `notes/` grepped.

## 1. What I was doing

Cycle 96 established that spending eligibility on an item without checking it
against the repository produces confident wrong decisions. So this cycle went
to verify the two remaining unverified open items — **(a‴) fourth-corner
existence** and **(p) one-instance-only** — by opening the fourth-corner
modules rather than counting greps.

The ownership step came first, using the index at `$SP/pairs.txt`
(CLAIM-KEY → RECORDING-SITE), with

```
grep -n "Avaktavya\|KramaAstiNasti\|KramaSaha" $SP/pairs.txt
```

## 2. What the index says, and what the files say

| line | claim-key | recording-site named |
|---|---|---|
| 41 | `TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet` | `…KramaAstiNasti_TheFourthCornerIsRefutedUnderPointwiseStability.agda` |
| 48 | `TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift` | `…KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet.agda` |
| 68 | `AnEnumerableRemedySetKillsTheFourthCorner` | `…KramaAstiNasti_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift.agda` |

**Each key names a file whose own name is a different key. It is a cyclic
shift by one.**

Opening the files settles which side is wrong:

- `…CannotLiveOverAnEnumerableDecidableInstanceSet.agda` proves `Enumerated`,
  `decAny`, `decΣOverEnumerated` — the decidable-instance-set machinery its
  name announces.
- `…AtOneInstanceIsExactlyTheDoubleNegationShift.agda` proves
  `notSamayikaIsPointwiseDoubleNegation`, `notNityaIsNotThePi`,
  `fourthCornerIsDNSFailure`, `fourthCornerRefutesPointwiseStability`.
- `…AnEnumerableRemedySetKillsTheFourthCorner.agda` proves `finiteDNSList`
  and `finiteDNS`.

**Every file's content matches its own name. The index is what is wrong.**

Provenance: I renamed four `Avaktavya_*` modules to `KramaAstiNasti_*` (commit
`d2a6a22b`) after `KramaSaha_…` established the position was the third
bhaṅga. **The mapping was carried across the rename by position and not by
identity.** `KramaSaha_…`'s own entry (line 85) is correct, which is
consistent: it was not part of the renamed block.

## 3. What this does to inferences I have drawn from the index

**I have used `grep -c "^<Key> " pairs.txt` as an OWNERSHIP TEST in cycles 85,
90, 93 and 98.** In aggregate the answers were right — all the fourth-corner
modules are mine, whatever line they sit on — but the index is wrong in
detail, and an ownership test is exactly the use that a shifted mapping can
corrupt without showing it.

**The weakest inference is cycle 85's**, where a `pairs=0` result on five
abhāva/exclusion modules was one of the two reasons I froze them and asked
who owns them. That freeze is still right and stays — the other reason was my
own ledger calling them "the five ABHAVA modules", which is independent of
this file — **but "pairs.txt says they are not mine" is now weaker evidence
than I stated it as.** Lines 9 and 13 also show two distinct keys pointing at
one file (`formal/cubical/AnuktaAvaktavya.agda`), so multiple keys per file is
normal here and is not itself evidence of corruption.

**The rule that follows, and it is cheap: an ownership question is settled by
reading the file's header, not by the index.** The index is a convenience for
finding recording sites; it was never a claim about authorship and I had been
treating it as one.

## 4. Not repaired this cycle, deliberately

The no-amend-in-the-finding-cycle rule applies, and pairs.txt has its own
standing rules — back it up before any bulk edit, never regenerate it (it was
destroyed once by regeneration and restored from `.bak`). The repair is three
key/site pairs re-associated by reading each file, next cycle, with the
backup taken first and the count quoted before and after.

## 5. The audit I set out to do, partially answered

Reading those files for (a‴) and (p) turned up that
`fourthCornerRefutesPointwiseStability` already states, at that family, that
the earlier module's hypothesis is **necessary and not merely sufficient — the
corner exists only where `Stable (Q r)` fails at some `r`**. That is close to
(a‴)'s restatement ("which taboo separates the three positions") and may
discharge it. **I am not claiming that yet**: it needs the whole file read
against (a‴)'s exact wording, which is next cycle's work, done the way cycle
96 says — open and read, do not infer from a name.
