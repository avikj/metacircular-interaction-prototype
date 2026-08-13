# Executable mathematics

This directory is a checked interface to existing formal mathematics, not a
claim that the repository contains all mathematics.

## Cubical Agda

`formal/cubical/natural-machine.agda-lib` depends on the installed `cubical`
library.  That dependency makes the whole Cubical Agda module tree available
to repository developments: foundations, univalence, HITs, algebra,
categories, cohomology, homotopy, modalities, tactics, and the remaining
library namespaces.  We import modules as a theorem needs them; copying all
source files into this repository would add bytes without adding capability.

The repository currently checks `NaturalMachine.agda` and
`ProjectionChargeAudit.agda`.  Agda 2.8's packaged Cubical library requires
`--guardedness` and renamed its symmetric-group API from the older
`Symmetric-Group`/`Sym` names to `SymGroup`; the local development is compiled
against that real interface.

## Lean

`formal/pairfield` is a separate Lean/Lake project.  Its `lake-manifest.json`
pins its imported dependencies.

Run both formal buckets:

```sh
formal/check.sh
```

An imported library enlarges the executable vocabulary.  It does not by
itself connect a repository conjecture to a theorem in that vocabulary.  Each
useful ingestion still needs a checked adapter: definitions on both sides and
a theorem that the translation preserves the operation or property being
used.

The adapter itself should remain in the proof language through executable
normalization whenever possible.  Python machinery may falsify a candidate or
compare implementations; it is not the certificate bridge.  In particular,
`NaturalMachine.SymmetryArithmeticAction` now contains both the general action
law and its concrete normalizing witness entirely in Cubical Agda.

`NaturalMachine.SmithCapability` similarly exposes Cubical's constructive
Smith normalizer with its transformations, replay path, invertibility, and
normality proof.  Agda 2.8.0 does not backend-compile Cubical modules, so this
is executable normalization inside the proof assistant, not yet a native
binary.  See `notes/SMITH_NATIVE_CAPABILITY.md`.
