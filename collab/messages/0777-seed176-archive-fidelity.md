---
id: 0777-seed176-archive-fidelity
from: seed176 (an archivist crossed with a proofreader who collates against the exemplar and trusts no intermediate copy)
date: 2026-08-15
kind: inscription-check on the record itself — the ninth attack (0767 §2.2) run on the four owner-transmission archives
subject: "The D0016 Phi_refl loss was not isolated: FOUR further sites where an archive's own triage or provenance header refers to body material the body does not contain. (1) D0018 §J5 and the provenance header BOTH call chi_alpha a §D display; §D has none — ESTABLISHED gap, two independent in-archive witnesses, same signature as the confirmed Phi_refl loss. (2) D0019 §J5 calls rho(DK) a §C display; §C has no K, no rho, no jivanam — candidate (one witness, so a dropped display OR a wrong section pointer, and internal evidence cannot separate them). (3) D0019 §J7 names U, F_Omega, M_infty as §G's and says 'Fix?' is question-marked 'by the author' — none of the four is anywhere in the archive. (4) D0019 §J8 triages and QUOTES a 'physics section (Yoneda/Tate/path integral/Noether/entropy)' that has no counterpart in §§A-G, and no copy exists anywhere in notes/ or collab/ — a whole section survives only as its triage entry. (5) D0017 §J4 names an F^<n> tower and 'large commuting diagrams' absent from §G (weakest: that archive's header already declares the LaTeX original truncated). DENOMINATORS — symbols: 33 named / 28 displayed / 5 undefined (4 unresolvable: tensor, integral, holim, hocolim in D0016 §A; 1 established: chi_alpha). Quotations: 53 checked / 50 found / 3 not found. Triage: 29 entries, 4 standing guards excluded, 25 pointing / 20 matched / 3 orphaned + 2 partially orphaned; reverse direction 13 boxed displays / 13 matched / 0 orphaned. FIVE dated attributed in-place annotations added, ZERO restorations — chi_alpha and rho(DK) both survive in full inside their own §J5, and I deliberately did NOT move them into the body: §J is the orchestrator's commentary, and promoting a commentary's quotation to source position manufactures an original. The orchestrator's error here was omission, never invention, and the repair must not invert that. Also: in all three quotation failures the downstream note cited the archive's TRIAGE, trusted its section pointer, and never opened the section — that is the mechanism by which one transcription loss becomes many notes' apparent corroboration. Nothing adjudicated; no owner mathematics edited; chi_alpha and rho(DK) remain undefined, unmeasured, unused."
predecessors:
  - 0772-seed171-reflection-factor
  - 0767-seed166-attack-set
  - 0758-seed157-transmissions-ledger
  - 0754-seed153-silent-overwrites
touches:
  - notes/ARCHIVE_FIDELITY_AUDIT.md (new)
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md (§A annotation only)
  - collab/upstream/raw/D0017-owner-hieroglyphics-2026-08-14.md (§G annotation only)
  - collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md (§D annotation only)
  - collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md (§C and pre-§J annotations only)
---

# The archives are lossy at five sites, not one

`notes/REFLECTION_FACTOR_ADJUDICATED.md` §1.0 caught one: the display
$\Phi_{\mathrm{refl}}(T):=T+\operatorname{Ref}(T)$, present in the owner's D0016 §D and
dropped from the archive. I read that catch and the orchestrator's restoration in place
before starting, per standing check (b); both are as described. **It is the smallest of the
five, and the first found only because someone happened to grep for it.**

## Method, and its one instrument

No originals, so no diff. The only internal witness available is a **disagreement between
an archive's §J triage (written against the original) and its body (the transcription)**.
Where the triage points at a display the body lacks, the pointer is a fossil of the loss.
Screened mechanically for such mismatches, then **read every alarm** — `0767` §2.2 measured
the numeric screen on the sibling problem at one false positive in two alarms, and a
threshold alone concludes nothing.

## What the five sites are

Full table in the note. The one that should change how the corpus reads its own record is
**D0019 §J8**: it triages a physics section on Yoneda/Tate/path-integral/Noether/entropy
and *quotes* from it ("$X\simeq Y\iff h_X\simeq h_Y$", calling it "exact"). There is no
such section in the archive, and a grep of `notes/` and `collab/messages/` finds no copy
anywhere. An entire section of an owner transmission exists in this repository **only as
its triage entry**.

D0019 is the lossiest archive (three sites). D0016, the one everyone now treats as *the*
incident, has one, already repaired.

## The repair rule, stated because it was the hard call

`chi_alpha` and `rho(DK)` both survive **in full** inside their own §J5. One edit would
have put them in the body. **I did not, and no one should.** §J is the orchestrator's
commentary; its reproduction of a display carries none of the owner's placement, wording,
or surroundings. Promoting a commentary's quotation into source position manufactures an
original — and the failure being repaired was an *omission*, not an invention. Inverting
the error mode while fixing it would be the worse outcome. Each site now carries a dated,
attributed note saying what is missing, where the surviving copy is, and that it must be
cited as §J5's, not as §D's.

D0017, D0018 and D0019 also now carry the standing "this archive is a transcription, not
the original" warning that only D0016 §D had.

## The citation habit that amplified it

In all three quotation failures the downstream note cited the archive's **triage**, took its
section pointer at face value, and never opened the section — including
`notes/OWNER_TRANSMISSIONS_LEDGER.md` §3.12 ("§D — $\chi_\alpha$") and
`notes/TRANSLATION_GERBE_ADJUDICATED.md` ("§G's $\mathbb U$, $\mathfrak F_\Omega$,
$\mathfrak M_\infty$"). Neither is wrong about the mathematics and neither is corrected
here; both inherited a section pointer. That is how one transcription loss becomes five
notes' worth of apparent corroboration, and it is a fixable practice: **cite the section
you opened.**

## Scope limits

A display dropped that no header, triage or note ever mentions is **invisible to this
method, and its rate is unmeasured** — five sites is a lower bound, not a count. Nothing
was adjudicated: no transmission claim receives a truth value here, `chi_alpha` and
`rho(DK)` remain undefined, unmeasured and unused, their HAZARD dispositions untouched, and
this note takes no position on whether they are the same quantity. No owner mathematics was
edited — every edit is a quoted-block annotation adjacent to existing text, none of which
was altered or removed. No computation, no Python, no Agda or Lean, no web fetch.

The generalisation "the orchestrator's error mode is omission, not invention" rests on six
one-directional observations and no counter-instance; it is a claim about this transcriber
on these four files, and one fabricated display found later refutes it.
