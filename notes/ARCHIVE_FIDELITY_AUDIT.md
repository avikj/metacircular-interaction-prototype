# Archive fidelity audit: how lossy are the four owner-transmission archives?

*Seed176, 2026-08-15. Persona lens: an archivist crossed with a proofreader who
collates against the exemplar and trusts no intermediate copy — except that here
**there is no exemplar**. That is the whole difficulty and it governs every verdict
below.*

**Scope.** `collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md`,
`D0017-owner-hieroglyphics-2026-08-14.md`, `D0018-owner-third-transmission-2026-08-14.md`,
`D0019-owner-fourth-transmission-2026-08-15.md`. This is a predicate on the **record**,
not on the mathematics: the ninth attack of `notes/ATTACK_SET_CALIBRATED.md` §2.2
(inscription-check), run on the archives themselves rather than on a note. **No claim in
any transmission is adjudicated here, and no owner mathematics is edited.**

**Substrate.** Reading and `grep`. No computation. No Python. No Agda or Lean authored.
No web fetch, no PDF. Every finding below was verified by opening the file, per standing
check (b) — the numeric screens are named as screens and each alarm was read.

---

## 0. Findings, first

1. **The archives are lossy, and now demonstrably at more than one site.** The
   $\Phi_{\mathrm{refl}}$ loss in D0016 §D (found by seed171, restored by the
   orchestrator) is **not isolated**. Four further sites where the archive's own triage
   or header refers to body material the body does not contain are recorded in §3. One
   of them (D0019 §J8) *quotes* a section that is entirely absent.
2. **The defect has a signature, and the signature is internal.** In every case the
   evidence is a **§J triage entry, or a provenance header, pointing at a display that is
   not in the body**. The triage was written against the original; the body is the
   transcription; where they disagree, the disagreement is a fossil of the loss. This is
   the only instrument available without the originals, and §4 states its false-positive
   mode honestly.
3. **The direction of loss is one-way in the sample.** All five sites are *absences from
   the body*. **No fabricated display was found** — every body display is either
   referenced by the triage or is unremarked-upon (which is not a defect). The
   orchestrator's error mode is omission, not invention, exactly as the tasking says.
4. **The lossiest archive is D0019** (three sites), not D0016 (one, already repaired).
   The seed171 catch has been treated as *the* incident; it was the first one found, and
   is the smallest.
5. **Nothing was restored.** Five gaps recorded, zero restorations. Where a copy of the
   lost display survives (D0018 $\chi_\alpha$ and D0019 $\rho(D\mathcal K)$ both survive
   inside their own §J5), it is the **orchestrator's** copy and cannot be promoted to the
   owner's section text. Standing check (e).

---

## 1. Internal completeness check: symbols named vs symbols defined

**Method.** For each archive's signature or component list, take every symbol named there
and ask whether the archive later gives it a defining display, a typing, or a table row.
A symbol named and never given one is reported; **whether it is the owner's own omission
or a transcription loss is not determinable from internal evidence, and is not guessed.**

### 1.1 D0016 §A — $\left\langle\Diamond,\partial,\delta,\Gamma,\Phi,\vee,\ulcorner-\urcorner,\otimes,\int,\operatorname{holim},\operatorname{hocolim}\right\rangle_\infty$

| symbol | later display | site |
|---|---|---|
| $\Diamond$ | yes — the septuple | §A |
| $\partial$ | yes — $\partial\Diamond_\alpha:=\int^{(f,t)}e_\alpha(f,t)$ | §B |
| $\delta$ | yes — $\delta_\sigma:=\mathfrak H_\sigma\ominus1$, and the seven components | §B |
| $\Gamma$ | yes — typed $\Gamma_\alpha:\mathcal O_\alpha\to\operatorname{Cell}(\mathcal C_{\alpha+1})$ | §C |
| $\Phi$ | yes — the four-factor recut | §D |
| $\vee$ | yes — $e^\vee(t,f):=e(f,t)$ | §E |
| $\ulcorner-\urcorner$ | yes — typed $\mathcal C_\alpha\to\mathcal C_{\alpha+1}$ | §E |
| $\otimes$ | **no** — occurs only inside $\gamma_{y\otimes z}$ (§D) and $\mathfrak M_i$ (§I); no monoidal structure named | — |
| $\int$ | **no** — used as a coend in §B, §D, §E, §I; no ambient, no smallness | — |
| $\operatorname{holim}$ | **no** — one occurrence, §I, इन्द्रजालम् | — |
| $\operatorname{hocolim}$ | **no** — used in §C, §E, §I; never typed | — |

**11 named / 7 displayed / 4 undefined.** The four are exactly the ambient
category-theoretic apparatus, which is suggestive: a transcriber drops prose, not
notation, so the likelier reading is **the owner's own omission**, consistent with §J4
("no convergence, no smallness … as written these are a *program*"). **Suggestive is not
established**, and the archive now says so at §A.

### 1.2 D0018 — header enumeration + §B's $\Gamma_\kappa$

D0018 has no signature display. Its two enumerations are the provenance header's four
"new things" and §B's $\Gamma_\kappa\in\{\Gamma_\varnothing,\Gamma_\Uparrow,\Gamma_\circlearrowleft,\Gamma_{\widehat{\phantom X}}\}$.

- $\Gamma_\varnothing,\Gamma_\Uparrow,\Gamma_\circlearrowleft,\Gamma_{\widehat{\phantom X}}$ — **4/4**, each with a table row in §B.
- Header item 1 (repair modes) → §B ✓; item 2 (generability/reconstructibility) → §C ✓;
  item 3 (prime-pair kernel) → §G ✓; **item 4 ($\chi_\alpha$) → nowhere in the body.** ✗

**8 named / 7 displayed / 1 undefined**, and that one is §3.1's established gap.

### 1.3 D0019 §A and §B

- $\mathfrak U:=(\mathcal X,\mathcal O,\mathcal R,\mathcal P,\mathcal C,\mathcal Q)$ —
  **6/6** glossed on the following line ("state-possibility space; observation grammar;
  relation net; change flow; coherence laws; self-description capacity"). A gloss is not a
  definition, and five of the six never recur ($\mathcal Q$ alone returns, as
  $\mathcal Q_{\alpha+1}$ in §G) — but nothing is *named and then unaccounted for*, so
  none is counted undefined.
- $\operatorname{Class}(D)\in\{\mathsf{Top},\mathsf{Alg},\mathsf{Geom},\mathsf{Stat},\mathsf{Comp},\mathsf{Sem},\mathsf{Diag},\mathsf{Phys}\}$
  — **8/8**, each with a response in the table.

**14 named / 14 displayed / 0 undefined.** D0019's defects are not in its signature; they
are in §3.2–§3.4.

### 1.4 Denominator

**33 symbols named / 28 displayed or defined / 5 undefined**
($\otimes$, $\int$, $\operatorname{holim}$, $\operatorname{hocolim}$, $\chi_\alpha$).
Of the five, **four are unresolvable** by internal evidence (D0016's ambient notation) and
**one is resolved** as a transcription gap (§3.1). D0017 is excluded from this count: it
opens with a relation-to-D0016 paragraph naming a shared alphabet
($\partial,\delta,\Gamma,\Phi,\vee,\ulcorner-\urcorner$, all six displayed in its body)
rather than a signature of its own.

---

## 2. Cross-reference check: quotations against the archives

**Method.** Take every place in `notes/` or `collab/messages/` that attributes a display to
a *named section* of a named transmission, and check that section of the archive. The
largest and most auditable such set is `notes/OWNER_TRANSMISSIONS_LEDGER.md`, whose 46
numbered entries each headline a formula under a section pointer (§1.x = D0016, §2.x =
D0017, §3.x = D0018); D0019's quotations live in `notes/ATTACK_SET_CALIBRATED.md`,
`notes/TRANSLATION_GERBE_ADJUDICATED.md`, and the ledger's line 59.

Entries whose headline **declares itself derived** rather than quoted — ledger 1.3 ("not
in the transmission; the content"), 1.4, 1.5, 1.8 — are excluded from the denominator, not
counted as failures. That exclusion is stated so it can be re-drawn.

| source | checked | found | not found |
|---|---|---|---|
| ledger §1.x → D0016 | 10 | 10 | 0 |
| ledger §2.x → D0017 | 11 | 11 | 0 |
| ledger §3.x → D0018 | 21 | 20 | **1** (3.12, $\chi_\alpha$ under "§D") |
| D0019 quotations (`ATTACK_SET_CALIBRATED` ×9, `TRANSLATION_GERBE_ADJUDICATED` ×1, ledger l.59 ×1) | 11 | 9 | **2** |
| **total** | **53** | **50** | **3** |

The three failures, distinguished per the tasking's rule (a quotation appearing in several
*independent* notes is likelier a loss; one appearing once is likelier a misquote):

- **$\chi_\alpha$ attributed to D0018 §D** — appears in the ledger §3.12 *and* in five
  further notes' honesty ledgers *and* in D0018's own header and §J5. But those are **not
  independent**: every downstream occurrence traces to §J5, which reproduces the display.
  What makes this a **loss** rather than a misquote is not the count but that **two
  distinct parts of the archive itself** (provenance header item 4, and §J5) refer to it
  as §D material. §3.1.
- **$\rho(D\mathcal K)$ attributed to D0019 §C** — ledger line 59 and D0019 §J5. Here the
  ledger *is* downstream of J5, so this is a **single** in-archive reference: **candidate
  loss, not established**. §3.2.
- **$\mathbb U$, $\mathfrak F_\Omega$, $\mathfrak M_\infty$ attributed to D0019 §G** by
  `notes/TRANSLATION_GERBE_ADJUDICATED.md` — again downstream of §J7. §3.3.

**A finding about the corpus's citation habits, offered as such.** In all three failures
the downstream note cited **the archive's triage**, took the triage's section pointer at
face value, and never opened the section. That is a citation practice, not an accident,
and it is the mechanism by which one transcription loss becomes many notes' worth of
apparent corroboration.

---

## 3. Structural check: §J triage against the body

**Method, both directions.** (a) Every boxed display in the body must have a triage entry.
(b) Every triage entry must point at material that exists.

**Direction (a): 13 boxed displays / 13 with a triage entry / 0 unremarked.**
D0016 §G ×2 → J2; D0017 §C ×1, §F ×2 → J1, J2; D0018 §C ×1, §F ×1 → J2, J3;
D0019 §B ×2 → J3, §C ×1 → J2, §D ×1 → J1, §E ×1 → J4, §F ×1 → J6. No orphan in this
direction.

**Direction (b): 29 triage entries**, of which **4 are standing guards with no body
pointer** (D0016 J6, D0017 J6, D0018 J8, D0019 J9) and are not counted. Of the **25
pointing entries: 20 matched, 3 orphaned, 2 partially orphaned.**

### 3.1 D0018 §J5 → §D's $\chi_\alpha$ — **orphaned; established as a transcription gap**

J5 is headed "§D's ratio $\chi_\alpha$" and reproduces
$\chi_\alpha:=\Delta\operatorname{Reach}(\mathcal O_\alpha)/\Delta\operatorname{Kill}(\Gamma_\alpha)$
with the trichotomy at $1$ and the "स्वर्णसीमा" gloss. §D contains none of it. The
provenance header's item 4 independently announces $\chi_\alpha$ as one of the four new
things, "flagged below". **Two in-archive references to a §D display that §D lacks.** Same
pattern as the confirmed $\Phi_{\mathrm{refl}}$ loss. Recorded in the archive at §D.

### 3.2 D0019 §J5 → §C's $\rho(D\mathcal K)$ — **orphaned; candidate gap**

J5 is headed "§C's $\rho(D\mathcal K)$" and reproduces $\mathcal K:=\partial\circ\Gamma$
with the trichotomy and जीवनम् $\sim\rho(D\mathcal K)\approx1$. §C has no $\mathcal K$, no
$\rho$, no जीवनम्. One in-archive reference only, so **either** a dropped display **or** a
wrong section pointer in J5 — internal evidence does not separate them. Recorded at §C.

### 3.3 D0019 §J7 → §G — **partially orphaned**

J7 lists "$\Theta_\infty$, $\mathcal Q_\infty$, $\mathbb U$, $\mathfrak F_\Omega$, and
$\mathfrak M_\infty$". §G displays $\Theta_\alpha,\Theta_\lambda$ and
$\mathcal Q_{\alpha+1}$, so the first two are fair. **$\mathbb U$, $\mathfrak F_\Omega$,
$\mathfrak M_\infty$ occur nowhere in the archive**, and J7's "$\operatorname{Fix?}$ is
written with a question mark **by the author**" is an explicit claim about a body display
that is absent — the strongest kind of internal witness short of a quotation. Recorded
before §J.

### 3.4 D0019 §J8 → "the physics section" — **orphaned; the largest gap found**

J8 triages "§ Yoneda / Tate / path integral / Noether / entropy", **a section with no
counterpart in §§A–G**, and quotes from it: "$X\simeq Y\iff h_X\simeq h_Y$, वस्तु $=$
सम्बन्धप्रतिस्पन्दसम्पूर्णता", calling it "exact". A grep of `notes/` and
`collab/messages/` for that Sanskrit string and for D0019-attributed "Noether"/"path
integral" returns **nothing**: no copy of the section exists anywhere in this container.
**A whole section of an owner transmission is missing from the record and only its triage
entry survives.** Recorded before §J.

### 3.5 D0017 §J4 → §G — **partially orphaned**

J4 names "§G's $\mathfrak F$, the ordinal ladder, $\mathbb B=\operatorname{hocolim}\mathfrak F^n$,
the $\mathfrak F^{\langle n\rangle}$ tower, and the large commuting diagrams". The first
three are in §G. **The $\mathfrak F^{\langle n\rangle}$ tower and the diagrams are absent.**
Weakest of the five: D0017's own provenance header records that the LaTeX original
truncates mid-formula, so this archive is *known* partial, and diagrams are the expected
casualty of a prose transcription of a LaTeX document. Recorded at §G as a candidate.

### 3.6 What is *not* a defect

D0016's triage covers §F, §G, §B, §C, §E and stops: **§H (gem invariants) and §I (net,
garland) get no triage entry at all**, and §D is triaged only through $\operatorname{YB}_\delta$.
This is *incompleteness of coverage*, which J's own heading ("Triage — begun, not
finished") declares, and `notes/OWNER_TRANSMISSIONS_LEDGER.md` §1.14 independently records.
**Not a loss, and not counted as one.** Distinguishing declared incompleteness from silent
omission is the point of the check.

---

## 4. Repairs made, and the rule followed

**Five dated, attributed, in-place notes. Zero restorations.**

| archive | site | what was added | class |
|---|---|---|---|
| D0016 | §A | signature completeness table result: 7/11 displayed, four unresolvable | uncertainty recorded |
| D0017 | §G | $\mathfrak F^{\langle n\rangle}$ / diagrams gap; plus the standing "transcription, not original" warning D0016 §D carries and D0017 lacked | candidate gap |
| D0018 | §D | $\chi_\alpha$ gap, two in-archive witnesses; instruction to cite §J5's copy **as J5's**; standing warning | established gap |
| D0019 | §C | $\rho(D\mathcal K)$ gap, one witness | candidate gap |
| D0019 | before §J | §J7's three absent objects and $\operatorname{Fix?}$; §J8's absent section; standing warning | one candidate, one established |

**The rule, stated because it is the load-bearing decision.** For both $\chi_\alpha$ and
$\rho(D\mathcal K)$ a full display survives *inside the archive's own §J5*. It would have
been one edit to move it into the body. **It was not done, and must not be.** §J is the
orchestrator's triage, written *about* the transmission; its reproduction of a display
carries neither the owner's placement, nor his surrounding wording, nor whatever the body
said around it. Promoting a commentary's quotation to the position of source text
manufactures an original. That is precisely the failure the tasking forbids and precisely
what the corpus's own error here was **not** — the orchestrator omitted, it did not invent,
and the repair must not invert that. Each site instead tells the next agent where the
surviving copy is and what its status is.

---

## 5. Denominators

- **Symbols:** 33 named / 28 defined-or-displayed / **5 undefined**, of which 4 are
  unresolvable by internal evidence and 1 is an established gap.
- **Quotations:** 53 checked / 50 found / **3 not found**, of which 1 is an established
  loss, 1 a candidate loss-or-misattribution, 1 a candidate loss.
- **Triage entries:** 29 total, 4 standing guards excluded → 25 pointing / 20 matched /
  **3 orphaned + 2 partially orphaned**. Reverse direction: 13 boxed displays / 13 matched
  / 0 orphaned.

---

## 6. Scope limits and honesty ledger

- **No exemplar.** Every finding is internal. I have not seen the owner's originals and
  cannot diff. A defect invisible from inside — a display dropped that no header, triage or
  note ever refers to — is **undetectable by this method and its rate is unmeasured**. The
  five sites found are a lower bound on the loss, and the instrument's recall is unknown in
  exactly the way `ATTACK_SET_CALIBRATED.md` §1.3 warns.
- **The instrument's false-positive mode, named.** A triage-body mismatch has a benign
  cause: the triage author may cite from memory of the session, or mis-point a section.
  §3.2 is filed as *candidate* for exactly that reason, and §3.5 is weakened by D0017's
  declared truncation. Screen mechanically, then read — `ATTACK_SET_CALIBRATED.md` §2.2
  measured the numeric screen at one false positive in two alarms, and this audit read
  every alarm rather than counting them.
- **The quotation denominator is a choice.** 53 is the ledger's section-attributed entries
  plus D0019's quotations in two notes. A different frame — every `§`-bearing sentence in
  `notes/` — would give a larger denominator and probably a similar failure count, since
  the three failures are structural (they trace to §J5/§J7 pointers) rather than
  distributed. I did not run that frame; the count is not comparable to another pass's.
- **Nothing adjudicated.** $\chi_\alpha$ and $\rho(D\mathcal K)$ are not defined, measured,
  estimated or used here; their HAZARD dispositions (`CLAUDE.md`; ledger §3.12, §5(i)) are
  untouched and this note takes no position on whether they are the same quantity. No
  transmission claim is given a truth value. No owner mathematics was edited: the five
  edits are quoted-block annotations added adjacent to existing text, none of which was
  altered or removed.
- **§0's generalisation is subject to audit** (standing check (f)). "The orchestrator's
  error mode is omission, not invention" is supported by five sites in four archives, all
  one-directional, plus the seed171 incident — six observations, no counter-instance. It
  is a claim about this transcriber on these four files, **not** about transcription in
  general, and a single fabricated display found later would refute it.
- **Credit.** The transmissions are the human owner's. The $\Phi_{\mathrm{refl}}$ catch is
  seed171's (`notes/REFLECTION_FACTOR_ADJUDICATED.md` §1.0) and its restoration the
  orchestrator's; the ninth attack and its screen-then-read specification are seed166's
  (`notes/ATTACK_SET_CALIBRATED.md` §2.2). The four further sites, the three denominators,
  and the no-promotion rule of §4 are this note's.
