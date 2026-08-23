# The least mixed control on the mod-five predictive carrier

Start from the autonomous multiplier process on `Z/5Z`. Its complete response
quotient under `zero/one/other` observation is

`{0}`, `{1}`, `{4}`, `{2,3}`.

Now expose one additional selectable left-multiplication control `mu_b`, while
retaining autonomous self-use of the installed multiplier `mu_a`. Since
multiplication modulo five is commutative, every mixed word acts on seed one
as

`b^i a^j mod 5`.

Powers through four exhaust all such responses.

## Classification theorem

For `b in {0,1,4}`, the mixed predictive quotient remains

`{0}`, `{1}`, `{4}`, `{2,3}`,

of exact dimension four. For `b in {2,3}`, it becomes the discrete
five-class quotient.

**Proof.** Only the pair `a=2,3` can refine. If `b=0`, every positive use of
the foreign control maps both to zero; without it their autonomous traces
agree. If `b=1`, nothing changes. If `b=4=-1`, multiplying either power trace
by `1` or `-1` preserves the coarse distinction `0/1/other`: when one of the
two histories reaches `1`, so does the other at the same autonomous exponent;
otherwise both remain in `other`. Thus `2,3` stay equivalent.

For `b=2`, one foreign use at autonomous exponent one sends installed `2,3`
to `4,1`, observed as `other,one`; `b=3` is symmetric. Hence either splits the
last pair. All other classes were singleton already, so the quotient becomes
discrete. QED.

## Quantum/process consequence

There is no proper predictive quotient strictly between the autonomous and
full-intervention endpoints on this carrier: the autonomous quotient already
has four classes on five states. Any capability-changing control must complete
the quotient. The minimum number of newly exposed controls is one, and the
capability-changing choices are exactly `2` and `3`.

The zero-error quantum memory dimension therefore jumps discretely from four
to five. Controls `0,1,4` are predictively inert for this declared task even
after arbitrary composition with autonomous evolution; controls `2,3` each
add one exact orthogonal response law.

This answers the request for a mixed language without choosing a compromise by
fiat. A live caller asking to distinguish the residual inverse pair earns
either control `2` or `3`. Without that need, adding it stores and exposes an
unused distinction. Algebra predicts both consequences but still does not
authorize installation.

## Rigor boundary

The theorem classifies every single scalar control and its generated mixed
language. It is finite deterministic process theory and zero-error state
dimension, not coherent query advantage, a physical process tensor,
thermodynamics, indefinite causal order, or spacetime.
