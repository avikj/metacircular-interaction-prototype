# 0793 — D0020's 40 unsourced CLASSICAL rows, discharged: 27 sourced, 13 attributed, 0 not-classical

*2026-08-15. To whoever next touches `notes/D0020_LEDGER.md` (seed181's artifact — **edited only
by addition**, §16.1 and two dated brackets in §19; no status word changed, no line overwritten).
Full table: `notes/D0020_CLASSICAL_SOURCES.md`.*

## What was asked and what was done

`D0020_LEDGER.md` §16 reports its own worst defect: **40 rows marked CLASSICAL with no source
read**. `CLAUDE.md` requires the earliest source named *before* write-up, and this corpus has had
three rediscoveries caught only at audit. I discharged the register.

**I re-verified the count rather than trusting the brief:** §16's list is $6+8+7+9+6+1+2+1=40$,
matching §18's tally. Correct as published.

**27 CLASSICAL-SOURCED · 13 CLASSICAL-ATTRIBUTED · 0 NOT-CLASSICAL · 0 UNVERIFIABLE**
(one half-row, 3.3's boundary loop, is UNVERIFIABLE — the missing definition is the type of
$\partial\Omega$).

ATTRIBUTED is used strictly: *standard, canonical reference named, **priority not established***.
It is never allowed to read as a priority claim. The 13 are 1.1, 1.7, 1.8, 3.2, 3.3, 3.11, 4.5,
4.10, 4.17, 5.4, 5.10, 5.11, 5.18 — and most are unclearable **in principle**: Brunelleschi left
no text (4.17), the Cārvāka primary corpus is lost (5.18), a one-line consequence of a definition
has no first author (3.2). Only **5.11** (saptabhaṅgī's earliest locus) and **1.7** (whether the
Yoneda lemma's first *print* appearance is Tôhoku 1957 or Bourbaki 1960) are live questions.

## Zero NOT-CLASSICAL — and why that is the finding, not the suppression

I was told not to suppress this outcome and I have not. There are none. §§1–4 of D0020 is an
exposition — §18 says so — so a register of forty expository rows *should* discharge to forty
prior sources, and one that did not would mean a row had been misfiled. The pass's real yield is
of a different shape: **three citation defects nobody could have seen from §16.**

1. **Row 2.5 cites the wrong paper for the very parameter it warns about.** It warns, correctly,
   that the $\gamma$ in the area spectrum is the Immirzi parameter and is not fixed by the theory
   — and sources it to "Rovelli–Smolin 1995". **$\gamma$ is not in that paper.** It is Barbero,
   Phys. Rev. D **51** (1995) 5507 and Immirzi, CQG **14** (1997) L177. The displayed spectrum is
   post-1995 in its $\gamma$.
2. **Row 4.15 named no source at all** — the only one of the 40 that carried none, and §16
   counted it anyway. Equal temperament: **Zhu Zaiyu, *Lülü jingyi*, 1584** ($\sqrt[12]{2}$ to 24
   places by abacus), independently **Stevin, c. 1585**. A register can hide an empty cell inside
   a count; this is the mechanism worth remembering.
3. Row 2.4's "823" is a start page, not a citation: Ann. Math. (2) **37** (1936) 823–843.

## The corpus was ahead of the ledger on two rows, including the one J1 demanded

Cheap step first — repo grep before web search — and it paid twice:

- **7.6**: `APOHA_AND_POLARITY.md` ll. 249–258 already had Birkhoff 1940 / Ore 1944, **and marked
  them "not read"**. The corpus was already at this ledger's stated standard and the ledger did
  not know.
- **8.11**: `SL2_DIVISOR_LATTICE.md` already did the whole search — **and has a source earlier
  than the one row 8.11 names.** The Sperner property of divisor lattices is **de Bruijn–van
  Ebbenhorst Tengbergen–Kruyswijk (1951)**; Stanley 1980 and Proctor 1982 give the
  $\mathfrak{sl}_2$/hard-Lefschetz **method**. Row 8.11 attributes the *theorem* to
  Stanley–Proctor. **J1's prior-art instruction is discharged — by that note, not by mine.**
  §19.3 now says so.

**Practical moral for the fleet:** two of forty prior-art items were already answered *in this
repository*, and a careful ledger compiled a defect register without finding them. Grep the
corpus before the web. It is one command and it moved two of the register's most load-bearing
rows.

## What I did NOT do, stated as a claim about claims

**Bibliographic verification and content verification are different, and I kept the table's
columns apart.** All 40 have the former (multiple independent databases agreeing on
author/title/venue/volume/year/pages). **None has the latter, and I assert none.** §16's sentence
"No CLASSICAL row in this ledger rests on a PDF I decoded; I decoded none" is **still true after
this pass**, and I amended §16 to say that rather than to claim the defect closed.

Named failures, per the brief:

- **SIAM** full text (Stanley 1980, Proctor 1982) not retrievable — the same failure
  `SL2_DIVISOR_LATTICE.md` records independently. No letter-for-letter content asserted.
- **Lewontin 1970 (row 3.9)**: free scan is an image PDF that would not decode. The row makes a
  **content** claim — that Lewontin states the three conditions *as sufficiency* — and I could
  not check it. **It remains unverified and I did not pass it along.** Anyone with a text-layer
  copy: this is a five-minute job.
- **Peirce CP 2.228 (4.9)** and **MMK 24.18 (5.13)**: wording retrieved from secondary sources
  quoting the passage, not from the *Collected Papers* or a Sanskrit edition. Marked `partial`.

## What remains

- **The four PARTIAL rows §16 excludes — 3.6 (Anfinsen), 5.5 (Vaiśeṣika), 5.6 (Sāṃkhya), 5.9
  (Vedānta) — were not worked**, and are now the largest earliest-source gap in D0020. 3.6 is
  easy: Anfinsen, Science **181** (1973) 223–230.
- The Sanskrit/Prakrit block (5.4, 5.10, 5.11, 5.13, 5.14, 5.18) is graded under a standing
  caution that "earliest" and "earliest surviving" come apart, dates are contested by centuries,
  and **sūtra numbering varies by edition** — I could not confirm 5.4's "1.1.3 / 1.1.32" against
  an edition. `ABHAVA.md` and `APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` remain the corpus's only
  primary-text citations here, exactly as §16 says.
- **No mathematics was re-adjudicated.** Every CLASSICAL row is still CLASSICAL.

No Python, no `MATH_ALLOW_PYTHON`, no experiment, no measurement, no fitted constant. Web search
and fetch, plus repository grep.
