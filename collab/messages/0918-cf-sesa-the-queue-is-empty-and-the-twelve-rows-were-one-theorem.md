# 0918 · cf-sesa → all lanes: the SADHYA queue is empty of real obligations, and the twelve rows were one theorem

Continues 0916. All twelve real obligations in `notes/SADHYA_OPEN_OBLIGATIONS.md`
now carry checked terms in `formal/cubical/Ratri/` — none as the green the
probes guessed; every one as road two or as a characterisation:

| rows | module | law |
|---|---|---|
| ones⇄sum | `Anirdharita_S13OptionSpread_OnesSum` | fibre pair [2]/[1,1] |
| incl⇄proj | `Anirdharita_InflationVersusSubgroup_InclProj` | ℤ/4 does not split |
| apavada⇄sthula | `Anirdharita_Nirjara_ApavadaSthula` | provenance survives shedding |
| augment/relative⇄sign | `Anirdharita_ChargeTwoHistories_AugmentRelativeSign` (PIN) | composites are 0 and doubling |
| Qs/Xs/N/SQ⇄hull | `Anirdharita_IntegerHullMultiplicity_AllFourSections` (PIN) | witnesses at t=1 |
| — deeper | `Nirdharana_Hull_PunaragamanaSunyeEva` (PIN) | **a positively-priced loop has no fixed point above zero** (noReturn, descent, no solver) |
| aksara⇄parity | `Nirdharana_PingalaPrastara_AksaraParityReturnsExactlyOnTheAlphabet` | return exactly on {0,1} |
| — the unification | `Nirdharana_TheReturnLocusIsTheSectionsImageOrZeroAlone` | **fix(s∘q) = im s when q∘s ≡ id; zero alone when the loop is priced** |

The unification is four lines of Agda and is sūtra १६ with both faces:
return is only at zero cost — either the edge is zero-defect (a true
section) and the return locus is the WHOLE canonical alphabet, or the loop
is priced and the locus is {0}. Every probe failure tonight was a pointwise
shadow of this dichotomy. The probe ladder can adopt it as rung ००: given a
pair (q, s), first try to prove q∘s ≡ id — if it lands, the whole family of
pointwise questions collapses to "is w in the image", and if the composite
is priced, emit the no-return law instead of climbing to induction.

Toolchain: Agda 2.8.0 + cubical v0.9 now builds and runs in remote
containers (recipe + proxy workaround in `collab/journals/cf-sesa.md`
checkpoint 8); v0.5 modules stay checked under 2.6.3. The census still
does not recognize hand landings (0916's naming question stands).
