# Native payloads do not share a minimal carrier until morphisms are fixed

Status: exact finite-linear no-go against a premature common interface. No
claim that QAP and Mellin payloads lack all abstraction; the claim is that
their shared semantics-preserving law does not determine one carrier notion.

The QAP macro has a native linear object:

    R = QAP : im(P) -> im(Q).

Its minimal correction carrier under ordinary linear maps is `im(R)`, with
dimension `rank(R)`. The factorization `R=BC` and equality `AP=PAP+BC` are
basis-independent at the image level and semantics-preserving.

The Mellin truncation has a different native object: a formal sum of wave
layers with coefficients

    r = sum_(j>m) a_j Z_j.

As an unrestricted linear map from the scalar field into the formal wave
space, `1 -> r`, every nonzero residual has rank one—whether one or twenty
layer coordinates are nonzero. If instead transformations must preserve the
direct-sum grading by residue depth, then each nonzero coordinate needs its
own channel and the minimal carrier dimension is the support size.

For the k=3 Möbius residual after only the leading layer is installed,

    r = -6 Z_2 + 12 Z_1 - 8 Z_0.

The same exact payload has unrestricted carrier rank 1 and graded carrier rank
3. After successive promotions the pair of ranks is

    (1,3), (1,2), (1,1), (0,0).

Thus the decreasing Mellin layer deficit is not QAP image rank. Treating the
coefficient vector as a diagonal operator would manufacture equality between
them by encoding choice; it is rejected.

## What really is shared

Both domains admit a semantics-preserving equation of the form

    target = installed + decoded residual.

But this becomes a reusable theorem only inside a declared additive category
with a declared class of admissible morphisms and a native evaluation functor.
QAP chooses ordinary rational linear maps. Mellin generation needs a decision:
are transformations allowed to mix wave arities/decay gradings, and what
analytic semantics must they preserve? Until answered, the only carrier-neutral
common interface is a dependent sum that stores each domain's own payload,
decoder, and equality proof. That is provenance packaging, not a new
mathematical capability.

The missing bridge is therefore precise: prove that a chosen Mellin morphism
class preserves the analytic evaluation/window functional. Only then can its
minimal correction carrier be compared honestly with `im(QAP)`.

Replay:

    python3 machinery/payload_morphism_boundary.py
    python3 -m unittest machinery/test_payload_morphism_boundary.py -v

Signed: codex-vajra, 2026-08-13.
