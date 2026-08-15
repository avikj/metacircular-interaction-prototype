# The three transmission ledgers reconciled against tonight's checked terms: 26 of 254, 9 full

*Hilbert lane, 2026-08-15. New note: `notes/LEDGERS_RECONCILED.md`. Pointer
blocks appended, **by addition only**, to `notes/OWNER_TRANSMISSIONS_LEDGER.md`
(§9), `notes/D0019_LEDGER.md` (§14), `notes/D0020_LEDGER.md` (§21). **No row of
any ledger was edited.** No Python, no `MATH_ALLOW_PYTHON`, no measurement, no
fitted constant, no web fetch, no PDF. No Agda authored.*

**Toolchain, stated because an exit code without one is a defect.** Every exit
code I report is my own run: `cd formal/cubical && LC_ALL=C.UTF-8 agda -i .
<M>.agda`, with `/usr/bin/agda` = **2.6.3** and cubical **v0.5**. The pin
(Agda 2.8.0 + cubical v0.9) **is not in this container**. Eighteen modules run;
seventeen EXIT=0. The one exception is `Sl2TensorProduct.agda`, EXIT=**42**
here (`Not in scope: ·IdR`) and green under the pin per commit `3f865d90` — the
**inverse** of the skew the standing checks warn about, flagged in its row and
not inherited silently.

**The count.** 254 scored claims (46 + 71 + 137). **26 now have a checked term:
9 full, 17 partial.** Per ledger: D0016–D0018 9 (3 full), D0019 7 (1 full),
D0020 10 (5 full). That is 10.2% with a term and 3.5% full — but of D0020's 14
PROVED-or-REFUTED rows, **9** have one. The 40 CLASSICAL rows cannot be
discharged by a term (a term is not a citation) and the 52 PROGRAMME rows cannot
have one until the notation denotes.

**Conservatism was applied literally.** A rank-one case, a finite model, an
abstract shape, or a certificate structure without its arithmetical hierarchy is
**PARTIAL**, and several modules say so in their own headers: `SpernerFromSl2`
writes `GeneralSperner` down as a type **with no term** and carries `CharZero`
in its hypotheses; `DecategorifiedDefect` calls its §2 "a FAITHFUL FINITE MODEL
of the $K_0$ argument and … not the derived-category statement";
`FillabilityCertificate` says "the arithmetical hierarchy itself is NOT
formalised"; `InflationVersusSubgroup` says its hom-sets are **declared**, not
proved exhaustive.

**The reverse direction is the interesting half — seven findings.**

1. **Gödel I is not a Lawvere instance.** `GodelSeparation.agda`:
   `tarskiUndefinability = cantor` (Tarski *is* Cantor's term);
   `goedelHalfOne` needs consistency and HBL D1 beyond Lawvere; `noHalfTwo`
   **refutes** every derivation of $T\nvdash\neg G$ by a four-sentence,
   $\omega$-inconsistent countermodel. This corrects
   `OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Cor 2.1, quoted at
   `OWNER_TRANSMISSIONS_LEDGER.md` §2.4 and inherited at §3.14. **The instance
   is the diagonal lemma.**
2. **And a module in this tree still says otherwise.**
   `NaturalMachine/Lawvere.agda`, added the same night, lists
   "`Gödel : B = provability, f = ¬ (incompleteness)`" among five instances in
   its header. Its terms assert nothing false and it typechecks; its **comment**
   repeats what a sibling module refutes. I did not edit it — another agent's
   live artifact — and recommend an additive amendment citing `noHalfTwo`.
3. **The dropped qualifier.** `InflationVersusSubgroup.agda` shows that under
   the **subgroup** reading $\Gamma\le G$ there is no $H^1(\Gamma,V)\to H^1(G,V)$
   for the theorem to be about; the canonical map runs the other way. D0019 B9's
   row is right; four sentences downstream of it in
   `EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` are not, and the defect has no
   lexical signature — no wrong word, one missing one.
4. **Arity, not zero.** `ArityOfRepair.agda` supersedes
   `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm A as the ground of
   `OWNER_TRANSMISSIONS_LEDGER.md` §3.8: $\Gamma_\Uparrow$ escapes Thm A and is
   still caught, by unarity alone. Verdict stands, reason replaced.
5. **"$\gg c$" was a constant without its dependence.** `InvarianceConstant.agda`
   replaces `MYSTERY_AND_DESCRIPTION_LENGTH.md` §1's $\gg c$ by exactly **$2c$**
   and proves it sharp both ways (`threshold-sharp`: at $2c$ the costs tie; at
   $2c-1$ the order reverses). This is `CLAUDE.md`'s own rule applied to the
   corpus's own prose.
6. **The apoha vacuity argument used excluded middle.** `PolarityClosure.agda`:
   $\mathrm{cl}\,\alpha=\neg\neg\alpha$ always; the identity holds **exactly on
   decidable $\alpha$**. `APOHA_AND_POLARITY.md`'s unrestricted
   $\alpha^{\perp\perp}=\alpha$ is not constructively provable. The vacuity claim
   survives in its Bool-valued form.
7. **The sharp form of the face-failure is variance-dependent.**
   `SimplicialDefectFailure.agda`: a theorem in the simplicial variance
   (`covariant⇒trivial`), **false** in the cosimplicial one
   (`Cosimplicial-sharp-fails-corpus`/`-archive`, on one chart, for both
   readings of the archive discrepancy, chosen between by neither).

**Two structural observations, offered for audit.** (a) Every FULL row is a
bracket identity, a counterexample, a monotonicity, a Galois connection or an
invariance constant — the terms cluster exactly where the mathematics was
already finite and exact, and nothing analytic, ordinal-ladder, gerbe or coend
acquired one. (b) Seven rows moved from prose to term; seven separate findings
correct or weaken something already on the record. **Tonight's terms were worth
more as referees than as certifiers.**

**Scope.** I read statements and headers, not proof terms — the typechecker read
those, under a toolchain the sources no longer track. Of the 45 modules added
tonight, fourteen carry ledger-relevant results and were read at their headers
and cited statements; the other thirty-one are listed, not judged.
`AGDA_COVERAGE_LEDGER.md` §0's finding is **not repaired here**: there is still
no green run of the root `NaturalMachine.agda` for the tree as it stands, under
either toolchain, so no row inherits greenness from the aggregate. The 26/254
partition is displayed in the note so it can be recounted; it is a count of a
closed set and has no error bars.
