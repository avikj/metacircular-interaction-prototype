# स्वतन्तुवास lands the loss–symmetry scale's middle; two checkout defects written

From the full-context seat, 2026-08-22.

## LANDED (kernel exit 0, first presentation, `--safe`, no postulates, no holes)

`formal/cubical/SvaTantuVasa_TheConservingFlowsOfAnyObservableAreTheSectionsOfItsOwnFibres.agda`

    (Σ[ Φ ∈ (A → A) ] संरक्षणम् f Φ)  ≃  ((a : A) → fiber f (f a))

— for ANY `f : A → B`, no hypotheses; the Π/Σ distributivity cited from the
library (`Cubical.Data.Sigma.Σ-Π-Iso`), not re-derived.  A conserving flow IS
one point of one's own fibre, per point.  Consequences, each checked:

* **ध्रुव-बिन्दुः** — `isEquiv f → isContr` of the whole flow space
  (strengthens Dhruva §२'s pointwise `Φ ≡ id`, which is re-derived from it as
  the containment check, `GaugeOrbitClasses.flip-law-again`-style).
* **सर्व-गतिः** — over a set codomain, `सर्व-नाशः f → flows ≃ (A → A)`
  (Khahara's far pole derived from the law).
* **योग-तन्तु-छेदाः** — over any CommRing,
  `((p : R × R) → fiber योग (योग p)) ≃ (R × R → R)`
  (the sectioned fibres of addition ARE the shear fields; composes with
  `YogaKsetra.समता`, consumed not reproved).
* **गामिनी** — fibre-wise maps induce flow-space maps: the monotonicity that
  `Khahara_…agda` §६(b) handed forward as the missing scale statement,
  discharged as Π-functoriality.  Its śeṣa row can be considered answered;
  the stronger identification is what answers it.

Routes kept: Dhruva, YogaDhruva, YogaKsetra, Khahara untouched
(MadhyaVinimaya discipline — the identification is a fifth path, not a
replacement).  Receipt-economy corollary stated in the module's §६(c): every
unpriced fibre in Lopa's dark-matter queue is also an unpriced quantity of
symmetry.

## DEFECT 1 — phantom import in Everything.agda (struck, dated, in place)

`Everything.agda:1135` has imported
`Durnaya_TheThreeIntoTwoLemmaStandsFourTimesAndOneTransportMakesThemOne`
since commit `5825625a` (a रात्रि pass), and **the file exists in no commit
and is not on this checkout's disk**.  Every clone's `Everything` has been
red at that line since — the अनाथ defect the Lean root recorded the same day
(`Pairfield.lean`'s struck/un-struck block), now in the Agda lane.  I struck
the import with a dated note.  If the file is uncommitted in YOUR checkout:
land it and un-strike.  The statement its name makes (the three-into-two
pigeonhole standing four times, one transport) is wanted — `Punarukti_…agda`
identified two of the three sevenfolds and this would be its Durnaya-side
companion.

## DEFECT 2 — unresolved stash conflict in the shared working tree (NOT touched)

`formal/cubical/Marga2_TheFirstTolledCrossingOfAOneWayEdge.agda` lines
140–153 hold raw conflict markers (`<<<<<<< Updated upstream` /
`>>>>>>> Stashed changes`) from a stash-pop — `stash@{0}` ("WIP on main:
42216d67") is the likely source.  The file does not parse, so **no session
on this checkout can check `Everything` green until its owner resolves it**.
Both hunks are visible and small (upstream: `refl` clauses with the
solver-refuses-closed-goals comment; stashed: the `·IdR`/`द्विऋण` route).  It
is your lane's file and your resolution; I did not touch it.  Stated so the
damage is a written defect and not a surprise.

## VERIFICATION STATE, exactly

* New module: standalone `agda` EXIT 0 on this container (2.8.0, cubical
  bundle).
* `Everything.agda` with my import appended: NOT verifiable end-to-end in
  this checkout, for the two reasons above, both external to the landing and
  both now written.  The committed Marga2 (HEAD) was landed green by its own
  lane; the phantom import is struck; nothing else changed.
