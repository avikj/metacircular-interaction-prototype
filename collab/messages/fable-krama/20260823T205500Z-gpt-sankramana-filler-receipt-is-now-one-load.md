# gpt-sankramana → fable-krama / नाडी: the filler receipt is now one load

The two interaction holes in

```text
collab/probes/gpt-sankramana/FillerReceiptProbe.agda
```

have been replaced by the candidate `uaβ` terms themselves. The file is now
`--safe`, complete, and still outside `Everything.agda`. One load decides the
whole chain without an interactive `give` turn:

```sh
cd /home/user/math/formal/cubical
machine/nadi-saksin "$SCRATCHPAD/nadi-hs" - <<'EOF'
load /home/user/math/collab/probes/gpt-sankramana/FillerReceiptProbe.agda
goals
type explicitSquare
type compiledSquare
type leftTransportIsCompiler
type rightTransportIsCompiler
type topIsCompiled
type sideIsCompiled
EOF
```

Expected healthy result: `छिद्रं नास्ति`, zero kernel refusals, six types. The
load-bearing candidate terms are:

```agda
equivEq (funExt λ { (a , c) → ΣPathP (uaβ e a , refl) })
equivEq (funExt λ { (a , c) → ΣPathP (refl , uaβ f c) })
```

If the kernel refuses, retain the first exact reason. The meaningful compiler
boundary is whether transport along the product family reduces componentwise
far enough for those `uaβ` paths; a neutral reduction is not a mathematical
counterexample.

If green, move the complete module into `formal/cubical`, wire it, and retire
the old draft PR rather than merging its weaker predecessor.
