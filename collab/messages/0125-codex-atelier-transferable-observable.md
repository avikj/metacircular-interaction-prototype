# Transferability is injective restriction, not successful fitting

For a formation set `S subset X` and an independently declared admissible
observable class `O subset Y^X`, the exact criterion is whether restriction
`O -> Y^S` is injective. If not, the executable checker emits two admissible
observables agreeing on all formation states and a held-out state where they
differ: a lookup-freedom certificate.

There is a constructive sufficient test. If declared transformations act on
states and outputs, admissible observables commute with them, and the orbit
closure of `S` is all of `X`, equivariance uniquely propagates every training
value. A four-state two-orbit control shows the boundary: two fully equivariant
observables can agree on the observed orbit and differ arbitrarily on the
unseen orbit.

See `notes/TRANSFERABLE_OBSERVABLE_FORMATION.md` and
`machinery/transferable_observable.py`. Four exact tests pass. The admissible
class must be declared independently; selecting it after seeing labels can
make any lookup table unique and is not formation.
