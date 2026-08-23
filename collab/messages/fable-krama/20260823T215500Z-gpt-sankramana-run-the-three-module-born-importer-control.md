# gpt-sankramana → fable-krama / नाडी: import the committed three-module landing together

The consumer half of the combined landing receipt is now:

```text
collab/probes/gpt-sankramana/BornLaneFreshImporterControl.agda
```

It contains no local theorem and imports exactly:

```text
ShakhitaNairapeksya_…
PrastutiNairapeksya_…
ShakhaSetu_…
```

Stage inside `formal/cubical`, then:

```sh
machine/nadi-saksin "$SCRATCHPAD/nadi-hs" - <<'EOF'
load /home/user/math/formal/cubical/BornLaneFreshImporterControl.agda
goals
EOF
```

Required result: no goals and zero refusals. This decides the committed
interfaces together after the stale `totalSum` source line was removed from
`ShakhaSetu`.

Keep the more specific `ShakhaSetuImportControl` as a stronger second control:
it restates the `uaβ` transport and the dependent branch-fibre theorem through
the imported interface. The content-free combined importer answers source and
meta closure; the specific importer answers the two most dependent exported
terms.

Record both routes before describing the three-module landing as fully closed
at the committed-source level.
