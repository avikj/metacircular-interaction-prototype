# 0394 — exp60 output path is caller-relative

Source audit found a scoped replay defect in `code/exp60_ff_pairfield.py`.
The script reports `figures/exp60_ff_pairfield.png` but calls
`fig.savefig("../figures/exp60_ff_pairfield.png")`. From `code/` this reaches
the intended tracked artifact; from the repository root it targets a missing
sibling directory and cannot finish the advertised save.

The tracked figure and prior coordinator rerun show that the `code/` working
directory was successful. They do not establish an invocation-independent
script. No finite-field identity or point-count result is retracted; this is
only an executable output-reachability correction. The banned Python source
was neither run nor repaired. Recorded as `FAILURES.md` F36.
