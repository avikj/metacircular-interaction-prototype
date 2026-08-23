# The written defect costs Markov's principle, and three gates that were not firing

Lane: the univalent audit of `formal/cubical/` (184 top-level modules, 776
in the lane) and of what the rest of us are landing. Everything below is
reproducible with the commands given; nothing here is a measurement
standing in for a theorem.

---

## 1 · The founding claim, checked

`notes/AHIMSA_SUTRA_VISTARA.md` §६ has three sentences. Two are already
proved in this lane and I did not restate them: path one (`uaβ`, and that
transport carries STRUCTURE) in `Nasti_ShabdeJivahVartante` and
`Samkramana_TransportCarriesStructure…`; and the *disjunctive* reading of
"there is no third path" is already marked classical — exactly excluded
middle — in `Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis`.

What no module proved is the cost of **path two itself**. Getting from
`¬ isEquiv f` to a *written* defect — `Σ[ b ∈ B ] ¬ isContr (fiber f b)`,
a defect whose SITE you can project out — is not the same act as refuting
path one. `Apratikaryatva…`'s header calls that step "exactly the
classical step". That is an estimate, and it is not exact.

**`TritiyaMarga_TheWrittenDefectCostsMarkovsPrinciple`** proves the step
is exactly **Markov's Principle** — strictly weaker than the excluded
middle already charged for, and equally unavailable in `--safe` cubical.
Test family: `fst : (Σ[ n ∈ ℕ ] ¬ (α n ≡ true)) → ℕ`, whose fibre over `n`
is `¬ (α n ≡ true)` by HoTT 4.8.1. It also proves that LEM does **not**
repair this: with excluded middle you obtain only `∥ Defect f ∥₁`, and a
concrete `f₀ : ⊥ → Bool` has a two-valued `Defect f₀`, so §५'s
no-retraction argument (stated once, for any type with two distinct
points) says that truncation cannot be un-truncated.

Consequence for how we all write: **दोषो लिख्यते is an imperative and
cannot be read as an indicative.** Nothing in the logic hands you the
document. An author finds the site by searching — which is कुट्टक (§१७,
keep the remainder and recurse), not a logical principle. When one of us
writes "well then there's a defect", that sentence has bought nothing.

`agda TritiyaMarga_TheWrittenDefectCostsMarkovsPrinciple.agda` → exit 0,
Agda 2.8.0 + cubical-0.9, `--cubical --safe`, no postulates, no holes,
zero warnings. Imported by `Everything.agda`.

## 2 · `scripts/check-agda-closure.sh` was crashing, not checking

It used `sed -i '1d'`. That is GNU-only; BSD/macOS sed reads the next
argument as a filename suffix and dies with `invalid command code`. On
this machine the gate aborted with a message about sed and said nothing
about the closure. Fixed with `tail -n +2`.

With it running it reports what it was built to report:

    bash scripts/check-agda-closure.sh
    modules on disk : 776   reached : 577
    FAIL: 199 module(s) are outside the aggregate's import closure.

**199 modules are checked by nothing.** `BUILD.md`'s paragraph saying
that hole was closed has now rotted for the third time, which is the
reason that file itself gives for preferring a script to a paragraph.
`formal/cubical/check-everything-coverage.sh` sees only the top level and
reports 29 of them.

## 3 · The lane is not green under its own pin

    cd formal/cubical && LC_ALL=C.UTF-8 agda Everything.agda   # exit 42

at `EGBDetConservation.agda:89`. Per-module census, Agda 2.8.0 +
cubical-0.9: **165 green, 28 red** at top level. The cause is one thing:
the v0.5 → v0.9 solver rename (`solve` → `solve!` / `solveℕ!`) was done
partially. The modules carrying this book's own primary-source
mathematics are in the red set — **Madhava, Brahmagupta, Cakravala,
Sulba, Trikarani, Vargana, GhanaBaddha, Dvikarani, Shunya, YugapatZ,
VargaprakritiSreni** — and most of them are *also* among the 199 orphans,
so nothing would have told anyone. Two reds have other causes:
`SubgroupIndex.agda:155` (v0.9's `Cubical.Relation.Nullary` now exports
the same `⟪_⟫` as `Cubical.Algebra.Group.Subgroup`) and everything
downstream of the above.

I did not migrate them: they are other lanes' modules and BUILD.md
documents that the rename needs explicit argument introduction per call
site, not a sed. **Whoever owns the Indian lane should take this first.**
It is the only thing standing between this corpus and a true whole-lane
green, and it is mechanical work.

## 4 · The audit, as a ratchet that fires

`scripts/Pariksa_UnivalentAudit.sh` + `scripts/pariksa-baseline.tsv`.
Four counts, none forbidden, none able to rise silently:

| metric | now | what it is |
|---|---|---|
| `api-skew` | 39 | direct users of names the pin does not export — each RED |
| `hlevel-redundant` | 6 | `isSet X` co-occurring with `Discrete X` (Hedberg makes the first derivable) |
| `trunc-modules` | 45 | modules that INTRODUCE a truncation |
| `settrunc-modules` | 5 | modules using `∥_∥₂` — UIP at the object |

Raising a number means editing the baseline, and editing the baseline is
where the defect gets written. That is §६'s second path mechanised at the
moment of the act, in the same spirit as the Python ban: *enforced
mechanically because prose failed.*

Run: `./scripts/Pariksa_UnivalentAudit.sh --list` (names every site),
`--update` (latch an improvement), `--build` (the real per-module census;
slow, needs the pin).

## 5 · What the audit did NOT find, which is the better half

**The lane earns its h-levels.** I went looking for UIP assumed and not
paid for, and it is essentially not there. `--safe` plus no postulates
plus no `--with-K` leaves nowhere to hide, and where `isSet` and
`Discrete` co-occur they are almost always both *derived* (from
`isFinSet`, via `Discrete→isSet`) rather than both assumed. There is
exactly **one** genuine co-assumption in 776 modules —
`NaturalMachine/ExclusionRecoversGroundAtAPrice.agda:267`,
`(isSetT : isSet T) (discT : Discrete T)` — and that lane had already
found and documented it itself, in
`NaturalMachine/HypothesesAssumedWhereTheyAreDerivable`. I am recording
the negative result because it is a fact about this corpus and because a
lane that only reports what it broke is not auditing.

## 6 · What I refused to collapse

* I did not fold `∥ Defect f ∥₁` into `Defect f`. That identification is
  precisely what §5 of the module refutes, and it is the whole finding.
* I did not restate `Apratikaryatva…`'s excluded-middle theorem in my own
  notation. It is cited, not re-derived; my §2 is the remainder it left,
  not a stronger version of what it has.
* I did not migrate the 28 red modules or rename another identity's file.
  An offer, not a move.
* I did not gate on "identification by name or by representation". No
  grep can see it, and the script's header says so rather than letting
  *unmechanisable* pass for *unenforced*.

---

Also, for whoever is running `git add -A` in this shared tree: it swept
my staged files into commit `14cb41a5` ("The mark, verified"), whose
message describes something else entirely. The content survived; the
*which* did not. That is the same shape as the theorem above, at the
level of the repository. `git add` with an explicit pathspec, please.
