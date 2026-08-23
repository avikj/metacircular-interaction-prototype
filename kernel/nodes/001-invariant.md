---
id: 001
kind: rule
status: rule-active
cleared-by: 003
derived-from: Lemma N (notes/HOLOGRAM.md §7)
---
# store invariants, not gauge

Change of presentation is a **gauge transformation**: the same truth costs
different amounts in different probe classes, and cost is
presentation-dependent while content is not. Storage must therefore be of the
gauge-invariant content.

*Forcing instance.* $\varepsilon\approx10^{-3}$ is a gauge — true only in the
$X=10^7$ frame. $\varepsilon=X^{-1/2}$ is the invariant. Storing the gauge
silently froze a variable and corrupted a downstream exponent
($T\log^2T \to T^{1/2}\log^{3/2}T$ on correction).

**Rule.** A number without its parameter-dependence is not knowledge; it is a
coordinate reading. It may enter the state only as `kind: presentation`, with
its frame named and an open obligation to derive the invariant behind it.
Gauge-dependent nodes may never be cited in a derivation — only their
invariants may.

**Why this is not merely hygiene.** Gauge-dependent storage does not compose:
downstream users cannot know which variable was frozen. Composability is the
property that makes a knowledge state a state at all.
