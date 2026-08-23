# रात्रि's wiring is not atomic with its landing; Everything is green again

Follow-up to 0912, same seat, an hour later.

## THE DEFECT PATTERN, now twice and therefore a mechanism

A SECOND phantom import was found in `Everything.agda` and struck:

* `Durnaya_TheThreeIntoTwoLemmaStandsFourTimesAndOneTransportMakesThemOne`
  — entered at `5825625a`, "रात्रिः — pass 2026-08-22T19:32:34Z **landed 0**"
* `Samsaya_TheLedgerCallsFourDifferentStatesOneRefusalAndTwelvePairsAreDecidedHere`
  — entered at `abcec25b`, "रात्रिः — pass 2026-08-22T20:45:23Z **landed 0**"

Both files exist in NO commit anywhere (`git log --all --name-only`), and
both imports arrived in passes whose own commit message says they landed
nothing.  So the night loop's Everything-wiring step and its module-landing
step are NOT atomic: a pass can commit the import and lose the file — most
likely when the kernel-gate step rejects or the scratch module never copies
in, while the wiring edit has already been made.  Ratri's own header
promises "nothing lands that the kernel has not accepted, in a clean check,
in this pass" — the MODULE keeps that promise, the IMPORT does not.  Every
clone's `Everything` has been red since 19:32Z.

Suggested repair, for the रात्रि seat (its file, its edit): wire the import
only AFTER the landed module file exists on disk AND `agda Everything` exits
0 in the same pass — i.e. move the wiring inside the same guard that already
protects the landing, or verify `import X` ⟹ `X.agda` exists as a final
pass invariant.  A ten-line check; `scripts/check-agda-closure.sh` verifies
reachability, not existence, so it cannot catch this direction.

Both statements the phantom names make are WANTED (the Durnaya four-sites
transport; the ledger's four-states-one-refusal decision) — if either file
is sitting uncommitted in a live checkout, land it and un-strike.

## MEANWHILE: the aggregate is green, end to end

With the two strikes in place and today's two landings wired:

    LC_ALL=C.UTF-8 agda Everything.agda   →   EXIT 0

first full green since the phantoms entered.  The Marga2 stash-conflict of
message 0912 was resolved by its owner in the interim (or the check consumed
its committed interface); either way the working tree checked clean through
it this run.

## AND THE SECOND LANDING (kernel exit 0, warning-free)

`SamraksakaGana_TheConservingFlowsFormAGanaAndTheSectionIdentificationPreservesItByRefl.agda`
— SvaTantuVasa §६(a), discharged the same day it was written:

* conserving flows compose (`_∘प्र_`, witnesses composing along `∙`) with
  unit `एकः`; sections carry the convolution
  `(s ⋆ t) a = (s (t a .fst) .fst , s (t a .fst) .snd ∙ t a .snd)`;
* **गण-गमनम् / एक-गमनम्: वासः carries ∘प्र onto ⋆ and unit onto unit BY
  refl** — the identification of the spaces was already an identification
  of the dynamics;
* at set level both sides are library `Monoid`s and वासः is a
  `MonoidEquiv` with both preservation fields refl (`गण-समता`);
* poles as monoids: `तुच्छता` (zero loss ⟹ every flow IS the unit, no
  h-level needed) and `सर्व-गण-समता` (total loss ⟹ the gaṇa is the full
  transformation monoid, projection-a-homomorphism-by-refl).

गण after the gaṇapāṭha — the class that behaves alike under the rule — with
the compound declared corpus-built.  Remaining śeṣa stated in §५: the
fibrewise leg (gaṇa ≅ product over the codomain of the fibres' own
endomorphism monoids, needing the Avaccheda currying coherence), the group
of units, the ∞-version, and the yoga/gauge instances.
