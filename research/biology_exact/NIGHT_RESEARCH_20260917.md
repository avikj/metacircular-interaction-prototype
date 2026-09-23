# Native biological investigation — 17 September 2026

## Completed native objects

The whole-transcriptome producer completed with exact independent checking:

- 30,707 retained cells
- 367 observed guide arrays
- 21,052-gene axis
- every array's cell coverage and gene UMI totals checked against the source
- native merges completed through the final array outputs

Receipt: `build/transcriptome/completed.json`. Runtime log ends with
`COMPLETED 367 guide arrays x 21052 genes; 30707 cells`.

The producer reads the saved `RNARowFibre` objects by address. It does not
reconstruct RNA in Python. Python verifies completed native constructors and
coordinates the bounded native merge jobs. The original source fibre remains
available; a per-array summary is a sufficient view for gene abundance and
detection questions, not a replacement for cell-level joint relations.

## Exact mechanistic RNA pass

The native follow-up selected 49 genes across 1,562 cells in the GFI1/MED24,
HDAC3/KDM1A, EP300/KDM1A and SMARCA5/SMARCD1 conditions and their singles.
Every selected cell, condition, array identity, total UMI and requested gene
count was checked against the source. Receipt: `build/integrin_rna/rna.verified.json`.

Per-cell RNA UMI means:

|condition|n|ITGAM|ITGAX|ITGAL|ITGB2|TLN1|FERMT3|VCL|RAP1A|FHL2|LYZ|S100A8|S100A9|
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
|GFI1–MED24|148|0.64|0.24|0.48|6.07|2.30|1.18|1.39|1.25|0.18|7.79|11.67|36.23|
|GFI1|74|0.41|0.16|0.43|3.91|1.38|0.49|0.78|1.03|0.05|37.50|32.92|73.96|
|MED24|110|0.38|0.45|0.41|4.59|2.68|0.94|0.94|1.37|0.15|2.19|1.44|6.75|
|HDAC3–KDM1A|99|1.00|0.44|0.89|8.19|3.00|1.47|1.92|2.03|0.29|51.79|103.05|261.72|
|EP300–KDM1A|117|0.45|0.22|0.40|3.00|1.23|0.61|1.00|0.97|0.07|4.94|7.68|24.84|
|SMARCA5–SMARCD1|195|0.35|0.24|0.31|2.99|1.81|0.84|1.19|1.19|0.24|2.16|0.57|1.25|

This is a structured mixed state, not a single differentiation axis. GFI1–MED24
raises ITGAM, ITGB2 and the actin/adhesion support genes relative to both
singles, while ITGAX remains below MED24 and LYZ/S100A8/S100A9 are attenuated
relative to GFI1. HDAC3–KDM1A is broadly high across both integrin-support and
inflammatory programs; EP300–KDM1A is not. The native result therefore
recovers an interaction pattern in the biology rather than merely reporting a
compression ratio.

CD11b/ITGAM and CD11c/ITGAX share CD18/ITGB2. Primary macrophage work found
CD18 depletion reduced CD11b and CD11c in parallel and implicated talin,
vinculin and paxillin in the associated adhesion structures
([Pelchen-Matthews et al.](https://pubmed.ncbi.nlm.nih.gov/22017400/)). A related
HL-60 study linked RIAM, VASP and vinculin to ITGAM/ITGAX/ITGB2 expression and
phagocytosis ([Torres-Gomez et al.](https://pubmed.ncbi.nlm.nih.gov/36238292/)).
These are mechanistic priors for the next test, not causal claims about THP1.

## Surface stratification result

Native lane and hashtag questions completed 512 frames and 8,001 exact ratio
thresholds for CD11a, CD11b, CD11c, CD29, CD46, CD63, CD71 and HLA-DR. Receipt:
`build/stratified_mechanism/verified.json`; distributional follow-up:
`build/stratified_order/verified.json`.

GFI1–MED24's CD11b elevation over GFI1 is not a single pooled artifact: raw
per-cell order is crossing in each lane because the full distributions overlap,
while the double is consistently above MED24. Hashtag strata show the same
mixture of crossing and left-higher outcomes. CD11c is less stable after ADT
depth normalization, and CD11a generally falls below control after that
normalization. The correct biological object is therefore a conditional
distribution with its residual cell identities, not one scalar “myeloid score.”

## Next native question

Use the completed all-gene array outputs to select the strongest complete RNA
programs for GFI1–MED24, then return to the original cell fibres and compute
cell-level joint relations between those programs and CD11b/CD11c/CD11a. The
critical intervention test is ITGB2 or the actin-coupled module (TLN1,
FERMT3/APBB1IP, VCL/PXN/RAP1), with paired RNA and surface readouts. The
current evidence supports this as the highest-value mechanistic branch while
remaining explicit about what the existing data do and do not identify.
