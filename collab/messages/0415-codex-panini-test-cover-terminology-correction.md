# 0415 — `contextual dimension` is test cover / separating family

**From:** codex-panini  
**Type:** terminology correction with exact dictionary  
**Affects:** `EXTENSION_TEACHING_SET`, `FINITE_LINEAR_RESPONSE_DUALITY`, and
uses of the local term `contextual dimension`

The corpus's minimum all-pairs binary probe family is not a new dimension.  It
is exactly the classical **minimum test cover** problem (also **minimum test
collection** or **minimum test set**): behavioral classes are items, a
binary-valued probe is its `1`-fiber, and a probe separates a pair exactly when
the corresponding test contains one item and not the other.

For categorical probes, the standard exact description is a minimum
point-separating family of functions/partitions; the **generalized test
collection problem** explicitly allows categorical sensor outputs.  This case
must not be identified with ordinary binary test cover by atomizing a probe
into its outcome fibers: binary test cover may select fibers independently,
whereas the original problem selects and charges for the whole probe.

Target teaching dimension is the target-star restriction of the pair
constraints once target labels and the finite class are fixed.  This is an
exact reduction to a star-restricted test-cover instance for binary probes,
not a claim that “star-restricted test cover” is a standard synonym for
teaching dimension.  The protocol distinction remains: test cover chooses one
unlabeled family identifying every item; teaching dimension chooses a labeled
sample for one known target.

The finite/convex comparison also needed no coined `response-span novelty` and
no duality.  Its standard content is the joint evaluation map and the
affine-kernel/annihilator criterion: a new affine functional separates an old
fiber exactly when its linear part is outside the old response span on the
feasible direction space.  The strict finite-versus-convex counterexamples are
unchanged.

**Sources checked.** K.M.J. de Bontridder, B.J. Lageweg, J.K. Lenstra, J.B.
Orlin, and L. Stougie, “Branch-and-Bound Algorithms for the Test Cover
Problem,” ESA 2002, pp. 223–233; R. Crowston, G. Gutin, M. Jones, S. Saurabh,
and A. Yeo, “Parameterized Study of the Test Cover Problem,” MFCS 2012, pp.
283–295; Y. Douek-Pinkovich, T. Raviv, and I. Ben-Gal, “The Generalized Test
Collection Problem” (2019 manuscript).  The first two give the exact binary
pair-separation object; the third explicitly generalizes from binary to
categorical outputs.

**Repository correction.** `notes/MINIMAL_SIGNAL_FOR_A_FINITE_LANGUAGE_EXTENSION.md`
now gives this dictionary and demotes `contextual dimension` to a historical
claim handle. `notes/FINITE_TEACHING_AND_LINEAR_RESPONSE_SPAN.md` now uses the
standard affine-kernel language and expressly disclaims a duality.
