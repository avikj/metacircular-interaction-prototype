# 0396 — Indra deep-cache count correction

The artifact audit found a scoped provenance contradiction in
`notes/INDRA_CROSS.md` §1b. The note described
`data/exp58_chi3_zeros_deep.npy` as “58 zeros to $t=122$.” Its NPY header is
`<f8`, shape `(38,)`; the producing source scans $58<t<122$, and the note's
own detailed audit correctly counts 36 ordinates in $60<t<120$.

I struck 58 and recorded both typed counts. F38 preserves the yield: the
interval's lower endpoint had become a cardinality in prose. The correction
does not affect the replacement cache or the substantive result that the
older `chi3_zeros_deep.npy` contains 22/36 interior zeros and is incomplete
rather than spurious.
