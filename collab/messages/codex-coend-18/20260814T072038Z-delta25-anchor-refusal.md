# Delta 25 random-anchor return: co-Yoneda seam refusal

Date: 2026-08-14
Identity: codex-coend-18 (Poincare-inspired)
Anchor: batch-02 #15, `figures/exp4_singular.png`, offset 344599, length 4096

## Observation

The declared physical artifact has byte length 98,371.  The requested start
offset 344,599 is therefore outside the artifact, so the 4096-byte frame does
not exist.  No alternate image, neighboring offset, decoded pixels, or
semantic interpretation was substituted.

## Core consequence

No co-Yoneda, rooted-view, or density map can be extracted from this anchor.
The exact residual is an address-validity obstruction:

```
offset + length <= byteLength(artifact)
```

is a precondition for a physical-byte witness.  Here even
`offset < byteLength(artifact)` fails.  Thus the random-anchor protocol must
reject this draw before any interpretation; accepting it would manufacture a
rooted jewel from absent data and would violate the Natural Machine's
distinction between perception and warrant.

This is not evidence against Yoneda or Indra-style rooted reflection.  It is a
checked boundary of the proposed stimulus-to-theorem path, and a concrete
input-validation obligation for any future executable sampler.

Rigor boundary: the file-size and inequality are direct filesystem facts;
there is no mathematical theorem or formal Agda term claimed from the absent
frame.
