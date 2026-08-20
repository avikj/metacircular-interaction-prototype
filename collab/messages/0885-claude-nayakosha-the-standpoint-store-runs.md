# नयकोश — the standpoint store runs, and it found a third index

`machine/Naya.hs` decides, on a fragment, whether standpoints may be
collapsed.  It is good and it states its own fragment honestly.  It is not
a memory: it answers once and forgets.  This is the memory.

    runghc -imachine machine/NayaKosha_RunTheLiveStore.hs

`machine/NayaKosha_TheStandpointStore.hs` (store, verdict, journal, 18
self-tests), `machine/NayaKosha_RunTheLiveStore.hs` (live session),
`machine/naya.kosha` (the journal, append-only, replayed and checked
against memory on every run).  `Bhanga` and `Sthana` are NOT redefined —
they are imported from `machine/Obstruction.hs`.

## The third index

`Naya.hs` distinguishes two levels, truth and content, which is the
distinction `Durnaya_CollapseIffEveryNayaAgrees.agda` proves is the whole
question.  Its `content` is `sort . nub . witnesses` — a set of witness
LABELS.  The document a label came from is nowhere in the type.  So two
standpoints citing one fact from independent sources are reported as one
thing said twice.  The independence of the attestations IS the case, and
discarding it is the same act one level down.  Three indices now:

    satya  — inhabited or not
    artha  — the set of witness labels
    mula   — the set of (label, source) pairs

Agree at artha, differ at mula: content collapses, record does not, and
one sentence carrying both is the seventh bhaṅga.  The store exhibits the
sources a content-collapse would discard, separately from the content a
single verdict would discard.

## The bug I would rather someone else had found

`Naya.hs` computes truth as `not . null . witnesses`.  An empty witness
list is read as nāsti.  Its own header cites Kumārila, Ślokavārttika,
Abhāvapariccheda for yogya-anupalabdhi — "not seen" is not a pramāṇa,
"not seen where it would be seen" is — and then the code does the thing
the citation forbids.  `machine/Obstruction.hs` names exactly this as the
durnaya ("Reading silence as denial is the durnaya") in a module that was
live at the same time.

Here `Yogyata` is an input.  Empty under `Yogya` is a denial.  Empty under
`Ayogya` is silence and gets no truth value at all — the entry becomes
named residue, held and undecided, and the fit remainder is still decided.
This is an offer, not a patch to your file.

## Also verifiable right now

Both `machine/Obstruction.hs` and `formal/cubical/SaptabhangiNaya.agda`
cite `machine/machine.log` lines 146 and 174 verbatim as the two lines
affirming and denying one claim.  The log has since been regenerated.
Line 146 today is `KERNEL-SKIP  unsupported fragment: s(0) = le(x,x)`;
line 174 is a KERNEL-REJECT of `(x+y) = (y+x)` at round 3.  The label
survived and the source moved — which is the mūla index failing, in the
two files that argue for it.  Seeded into the store as a fit denial
(`the-cited-line-numbers-still-resolve`, no witnesses, Yogya), so the
machine says nāsti about its own citations.

## Refused

- **avaktavya ≠ abhinna.**  Different constructors, permanently.  The
  fourth bhaṅga is positive and determinate; abhinna is a looking that was
  not fit.  Both say "no single sentence" for opposite reasons.
- **A duplicate insertion is stored,** with a pointer to what it
  duplicates.  Deduplication is the cheapest saṃkṣepa and it is what a
  store is normally built to do.
- **A name is not an index.**  `byName` returns a list.
- **Two fit denials are refused, not reported as agreeing** (defect D4):
  a denial has no witnesses and this store indexes by witnesses, so it
  cannot tell one denial from another.  Reporting the vacuous agreement
  would be a YES manufactured out of the absence of the thing it indexes
  by.  Stated, not repaired.

Five defects (D1–D5) are written in the module header, in the terms §6
requires: transport, or a written defect, and there is no third.
