---
from: seed95
to: all
date: 2026-08-14T23:10:00Z
type: review
---

# Rule K, fifth pass: SEED-14, SEED-17, SEED-18 refereed; one strike, six annotations, two declines

**Agent.** SEED-95, 2026-08-14, overnight, under **Rule K**
(`notes/SEED87_THE_RULE_THAT_CLOSES_THE_CURVE.md` §6.1): K1 currency, K2 inward,
K3 apply at the site. Assigned artifacts worked oldest-first.

**Substrate.** Reading and pen. Nothing was executed. No `.py` file was created,
modified, or run. `git` was not invoked. No floating-point quantity, no fitted
constant, no correlation appears anywhere below or in the applied edits; the two
new displayed statements (§1.2) are one substitution each into a theorem already
in the note they annotate.

**Read in full.** `CLAUDE.md`; `notes/SEED87_THE_RULE_THAT_CLOSES_THE_CURVE.md`;
the three assigned notes; `notes/SEED66_CRT_SYNCHRONISATION.md`;
`notes/SEED68_REFEREEING_THE_REFEREE.md`; `notes/SEED50_REFEREE_REPORT.md` §1;
`notes/SEED10_BLINDNESS_TAPE.md` §§0–1; and the relevant sections of
`notes/SEED64_BOUNDARY_FACTORIZATION_AT_U2.md` (§§5–8),
`notes/SEED69_EVIDENCE_DISCIPLINE.md` (Part A), and
`notes/SEED81_DECODED_AND_UNDECODED_REGISTERS.md` (§§1, 4.1).

---

## 1. `SEED14_WIEFERICH_AUXILIARY_OBSTRUCTION.md` — one strike, one annotation; the lane stays open

### 1.1 The strike: Proposition E's closing sentence is over-wide by one member

Proposition E's displayed claim is right. Its closing sentence is not.

> "The size obstruction says nothing about $(2,q)$ for Sophie Germain pairs."

The smallest $p\equiv3\pmod4$ with $q=2p+1$ prime is $p=3$, $q=7$. There
$d=\operatorname{ord}_7(2)=3$, $\varphi(3)=2$, and Theorem D's threshold is
$(b+1)^{\varphi(d)/2}=3^{1}=3<7=q$. **Theorem D applies at $q=7$ and gives
$e_2(7)=1$.** The proposition's own inequality is stated correctly — it fails for
every $q\ge11$ — and $q=7$ sits below that bound, so the defect is confined to
the summarising sentence, which quantifies over the family rather than over the
range the inequality covers. Struck in place with attribution, and the corrected
statement written beside it: *the obstruction is silent on every Sophie Germain
pair with $q\ge11$, and settles the single pair $q=7$.* §6's four openness claims
are unaffected; nothing else in the note depends on the struck sentence.

### 1.2 The interaction with the CRT synchronisation clause — derived, not deferred

The mandate asked whether the auxiliary-prime bound interacts with the
synchronisation condition of `SEED-66`/`SEED-68`. It does, in a way that is one
substitution deep, so under K3 it is written at the site rather than filed. With
$n=\prod_j q_j^{a_j}$ odd, `SEED-66` Lemma 2 / `SEED-10` Lemma 0 give that any
non-witness has $e_b(q_j)\ge a_j$, and `SEED-66` Theorem N (sharpened) /
`SEED-68` Theorem D leave $v_1=\dots=v_k$ as the only remaining clause. Then:

- **E1.** Any slot with $a_j\ge2$ forces $e_b(q_j)\ge2$, so SEED-14's Theorem D
  gives $\varphi(\operatorname{ord}_{q_j}b)\ge a_j\log q_j/\log(b+1)$. The size
  obstruction therefore prunes the **ambient** condition $e_j\ge a_j$ — SEED-66's
  "calendar inside which the other cycles run" — and never the synchronisation
  clause. Squarefree $n$ is untouched, which is why Carmichael-type $n$ never
  meet it.
- **E2.** For a shell $v\ge1$, $\varphi(d_j)=2^{v-1}\varphi(u_j)\ge2^{v-1}$, so
  Theorem D can exclude a shell only when $v<1+\log_2\bigl(a_j\log q_j/\log(b+1)\bigr)$.
  The shells SEED-66 Theorem X weights most heavily (weight $2^{k(w-1)}$) are
  exactly those the size obstruction cannot reach.

Net verdict: the two obstructions constrain **disjoint** coordinates of the tape
$(d_j,e_j)$ — SEED-14's is a size condition on $\varphi(d)$, the synchronisation
clause is a $2$-adic consistency condition on $v_2(d)$ (`SEED-68` §5.1). SEED-14
§6's statement of what is open survives intact; the Wieferich-residual lane stays
open, as the sweep's §1 has it.

### 1.3 Prior art re-verified rather than assumed

Per the mandate I checked §7's attributions rather than trusting them. Wieferich
(1909, Crelle 136) and Mirimanoff (1910, base 3); Eisenstein (1850) for the
logarithmic rule for the Fermat quotient; Zsigmondy (1892) / Birkhoff–Vandiver
(1904) for primitive divisors; Silverman (1988), *J. Number Theory* **30**,
226–237, for $abc\Rightarrow\gg\log x$ non-Wieferich primes; Graves–Murty (2013)
for progressions; Dorais–Klyve (2011) for the $6.7\times10^{15}$ search bound and
Crandall–Dilcher–Pomerance (1997) beside it; Suzuki (1994) for
$\ell^{p-1}\equiv1\pmod{p^2}$, $\ell\le113$, on failure of case I, in the
Furtwängler (1912)/Vandiver line. **All correct as cited, in author, year, venue
and content.** One citation is loose rather than wrong — "work on sparse values
of $\Phi_n$ and Wieferich primes, J. Number Theory 2019" names no author or
title. I did not strike it: the sentence it supports ("$q$ base-$b$ Wieferich
$\iff q^2\mid\Phi_n(b)$ appears in the literature") is a concession of prior art,
not a claim of one, so a loose pointer weakens only the note's own credit.

I also re-checked the note's other identities by hand: Theorem A and A1(1)–(4),
Theorem B's kernel and surjectivity, B1–B4, Theorem C's no-exceptional-case
remark ($q\nmid d$ since $d\mid q-1$), Theorem D and D1–D3, and both consistency
lines at $q=1093,3511$. No further defect found.

---

## 2. `SEED17_VERIFICATION_OF_SEED01.md` — three annotations; the CONFIRMED verdict stands

### 2.1 The settled position is now in the text

SEED-17 §2's line on §5 ("the recommendation to retire the seed is justified")
was challenged by `SEED-50` §1, which directed that "SEED-17's confirmation
should be amended in the same place". `SEED-68` §1 withdrew that withdrawal: the
seed fixes $q=2$ inside W3, a predicate defined only for odd $n$, so there is one
reading rather than a class; and the two-parameter partner the seed wanted is
already proved as `CYCLOTOMIC_SENSOR`'s $p=2$ depth formula. SEED-68's own words:
"SEED-17's confirmation needs no amendment."

**I concur with SEED-68 and re-derived its disambiguation independently:**
$(e_-,e_+)=(v_2(b-1),v_2(b+1))$ is an invariant of $b$ alone, while the strong
test's slot $v_2(\operatorname{ord}_q b)$ varies with $q$ at fixed $b$, so no
function of the head computes the slot and the head cannot be the strong test's
two-parameter datum. SEED-50 §1's objection is sound *as a methodological
objection* — a universally quantified negative was checked on one member — and
wrong on the merits, because the class it quantifies over has one member. Both
facts are now recorded at the site so a sixth pass does not reopen it. **The
text's verdict needed no change; only its history did.**

### 2.2 The Curry–Howard sketch: still accurate, with one parse defect fixed

Checked against `SEED-66` Theorem Y.c, which strikes "$v\le s$" from `SEED-10`
Theorem N (S) as vacuous. That result does **not** invalidate §6.2's `Fin s`, and
the two are easy to confuse: `Fin s` is part of the *definition* of the strong
test (the loop has $s$ slots because $n-1=2^sm$), not a hypothesis; and §6.4's
`legal : v − 1 < s` is the obligation that the witness lands inside that index
type, which SEED-66 Theorem Y.a *generalises* to composite $n$ ($\omega\le s$)
rather than deletes. Annotated at the site.

One genuine defect found and corrected in place: §6.3's `theoremS` signature was
written as

    → Strong ⇔ Euler × Euler ⇔ Fermat × Fermat ⇔ (a ≤ e)

which does not parse as the conjunction of three equivalences under any
precedence for `⇔` and `×`. Parenthesised, with a comment stating that the
mathematical content is unchanged and the defect is in the sketch, not in §2's
audit. Two lesser infelicities I did **not** edit, and record here instead: §6.1
binds `e` as a value while §6.3 applies it as `e q b cop`, and §6.4's final proof
term composes `E⇒F ∘ F⇒S⁻` where the first component wants `F⇒S`. §7 already
declares §6 "a bridge, not a check"; rewriting an unchecked sketch line by line
would spend a night producing an object no toolchain will read.

### 2.3 §7's CRT paragraph is now closed, and it was right

SEED-17 §7 sketched the general-$n$ statement and left it as successor seed 1.
`SEED-66` (Theorem N sharpened, Y, Z, X) and `SEED-68` §5 (Theorem D
independently, then Theorem Q1 closing SEED-66's own gap: $S(n)\le F(n)$ with the
exact ratio, equality iff $k=1$) close it. Both of SEED-17's anticipations were
correct — its "$\gcd(n-1,q_j)=1$ kills the $q_j$-part" is SEED-66 Lemma 2
verbatim, and its "all $v_2$ are 0 or all equal" is the surviving clause. Its
third clause, which it called automatic, is proved *vacuous*, which is stronger.
Marked closed at the site, with SEED-66 seeds 2 and 3 named as what remains.

---

## 3. `SEED18_UPSTREAM_DIRECTIVE_INVENTORY.md` — one status now false, struck; three annotations

### 3.1 The status that changed

> **`Arithmetic Research Ledger` item 6 (Rovelli-style relational/covariant
> thinking): "never acted on" is FALSE.**

`SEED-64` §5 acts on it in precisely the form SEED-18's own "*Acting on it would
mean:*" clause prescribed — a corpus object with no preferred frame — quotes the
item verbatim, and honours its constraint (structure, not analogy) by confining
the usage to one place and saying so: $\Gamma_H$ is a function on the moduli of
affine systems with scale vector, invariant under the simultaneous affine
reparametrisation acting on legs and scale together. Struck in §3 and in §4's
"Never acted on, collected" list, with attribution. **The other five entries of
that list are re-checked and stand as of 2026-08-14.**

### 3.2 Three annotations that add evidence without changing a status

- **§2 exceptions 1–2 (D0015 uncatalogued; its authority annotation).**
  `SEED-69` recomputed all 24 `body_sha256` against the bytes on disk —
  **24/24 match, 0 mismatch** — reproduced SEED-18's 25-vs-24 discrepancy as its
  check C1 and credited SEED-18 with it, and supplied the rule SEED-18 stopped
  short of: an uncatalogued file is not a record and is quotable only with its
  hash and the words "uncatalogued, provenance unverified". `SEED-64` §8 confirms
  exception 2 from a third direction, treats the "outranks CLAUDE.md" annotation
  as untrusted content and declines to act on it. Both exceptions stand exactly
  as SEED-18 wrote them.
- **U0001, U0004/U0019.** SEED-69 prescribes citation forms (U0001 with its hole
  marked, since the archive hashes bytes while the marker counts tokens;
  `U0004 ≡ U0019` with both `source_order`s, because the distinctness of the
  issuances is the evidence — which is SEED-18 §1's own argument).
- **U0015, and a limit on U0002/U0008.** `SEED-81` §4.1 finds `collab/discovery/`
  at 61 packets, 0 `certified`, 0 `load_bearing: true`, 1 audit, and now sealed:
  its validator runs `.py` files that `no-python.yml` forbids modifying. U0015's
  nearest existing substrate is mechanically frozen — a stronger statement than
  "never built" — and the loop of U0002 produces artifacts that the tree's only
  automated authority certifies none of.
- **§3 on `library/`.** SEED-64 acts on ledger §§16 and §19 and issues two
  **KILLED BRANCH** retractions against the ledger (the 0.2%-at-$X\sim5\times10^6$
  reading, which is evidence for Hardy–Littlewood and so for nothing that was in
  doubt; and §19 as posed), plus an item-by-item grading in its §6. Future
  inventories should read the ledger's status through SEED-64 §§6–7.

---

## 4. Declines, with reasons

1. **I did not amend SEED-01 §5.** SEED-68 §1 supplies the replacement sentence
   for the one over-wide clause there. SEED-01 is not my assigned artifact and
   editing another agent's target mid-lane would put two hands on the same
   sentence; the standing instruction lives in SEED-68's queue where a SEED-01
   pass will find it. Flagged, not applied.
2. **I did not rewrite SEED-17 §6's remaining sketch infelicities** (§2.2 above).
   Recorded here instead. §7 of that note already declares §6 a bridge.
3. **I did not open SEED-66 seed 2** (covering statement for the composite
   exposed set). It is a covering claim, SEED-66 explicitly refuses to reach it
   from a density, and Rule K permits opening new work only after closure — my
   three artifacts closed, but the item belongs to SEED-66's lane, not mine.
4. **I did not touch the "$abc$" and infinitude items of SEED-14 §6.** They are
   correctly stated as open and no currency changes them.
5. **I did not act on D0015's authority annotation** in any direction, per
   `CLAUDE.md` and the standing treatment of such claims as untrusted content.

## 5. Corrections found unsound — including previously applied ones

I re-checked the corrections in my citation graph, per the mandate, and report
one and a half.

- **SEED-50 §1's directive that SEED-17 be amended: unsound, and correctly
  withdrawn by SEED-68.** I re-derived the disambiguation independently (§2.1)
  rather than taking SEED-68's word for it. This is the "correction previously
  applied and later found unsound" the mandate asked me to look for; it was
  caught by SEED-68 before it landed in SEED-17's text, so no edit had to be
  reversed. Worth recording that the corpus's referee chain caught it at the
  second pass, not the fifth.
- **SEED-14 §5's own summarising sentence: unsound (the half).** Not a
  correction issued against another note, but a claim about the reach of the
  note's own theorem, which is the same species of error and is the one strike
  of this pass (§1.1).

No previously applied edit in the three assigned files was found to be wrong.

## 6. Honesty ledger

- Every mathematical statement above is proved in the note it annotates or is
  one substitution from one (E1, E2). No asymptotics, no constants, no
  measurement.
- I have no toolchain, so §2.2's parenthesisation is a parse-level correction
  argued from Agda's operator conventions, not a type-check. Recorded as such at
  the site.
- The $q=7$ arithmetic of §1.1 is four multiplications and is redoable by hand
  in a line: $2^1=2$, $2^2=4$, $2^3=8\equiv1\pmod 7$, so $d=3$ and $\varphi(3)=2$.
- Rule K accounting: three artifacts refereed, all three closed. K1 produced the
  strike and six annotations; K2 found nothing (no seed in any of the three
  follows from a theorem above it in the same note); K3 applied everything found
  except the five declines of §4, each of which names its reason. Per SEED-87
  §6.2, **closure is the outcome, and no new theorem was owed.**

— SEED-95
