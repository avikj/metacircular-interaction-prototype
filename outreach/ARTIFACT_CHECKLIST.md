# Artifact checklist — what must be true before a stranger runs `sh check`

Ordered by cost. Items in §1 take minutes and remove objections a reviewer
will raise in the first five. Items in §3 are what artifact evaluation
committees (CPP, ITP) and library reviewers (agda/cubical, agda-unimath)
actually score.

## 0. Done on this branch on 2026-09-21 (verify, then merge)

- [x] **UTF-8 repair.** 2,218 `.agda` and 390 prose files were invalid UTF-8
      after c0a233d. Restored line-by-line from the pre-corruption commit
      where the only change was deleted bytes; 150 comment lines that also
      carried a deliberate ASCII edit got U+FFFD markers instead. Details:
      `outreach/CHECK_2026-09-21.txt`.
- [x] **Module names.** 191 copied modules declared their old name; the
      first `module` line now matches the filename. Two `Aresidue` botches
      fixed. Four bare-named copies in `Kernel/` given the `Kernel.` prefix.
- [x] **`formal/lean/root-exclusions.txt`** created for the two Lean twins
      that cannot be imported beside their originals.
- [ ] **Decide the prose gate.** `sh check` still exits 1 on the phrase
      "WHAT IS NOT CLAIMED" in 15 files. Rewrite those passages (the gate's
      own instruction: assert the reading under its standpoint) or retire
      the gate; either way `sh check` must exit 0 before anyone else runs it.

## 1. Ten-minute fixes (do before any link is sent)

- [ ] **Stale provenance lines.** Seven `Kernel/` files say
      `-- CHECKED.  Agda 2.6.3 + cubical v0.5` (Syat_ :76, Siddhasadhana_ :66,
      Ananta_ :50, Vyabhicara_ :78, Nirapeksa_ :79, Adesa_ :61, Naya_ :85).
      The pin is 2.8.0 / v0.9. Re-run `sh check`, then either update the
      lines to the pin or replace them with `-- CHECKED at the repository
      pin (see setup)` as CaturthaSopana_ :44 already does.
- [ ] **`README.rst:74`**: "296 lines in three files … Fourteen modules".
      The directory holds 46 files. Say "three files, 296 lines" and stop,
      or give the true count.
- [ ] **`check:65` banner** says "the 296 lines and their readings" and
      then checks 26 files / 4,993 lines. Either rename the banner ("the
      kernel and its readings") or make it print the three files first.
- [ ] **`formal/cubical/kernel/` vs `formal/cubical/Kernel/`**: the three
      kernel files exist byte-identically in both. On a case-insensitive
      filesystem (macOS default, Windows) this checkout is *broken*: one
      directory shadows the other. Keep one; make the other an import
      shim or delete it.
- [ ] **Import fragility.** `open import Kernel.RewriteCertificate` (11×)
      and bare `open import RewriteCertificate` (10×) both appear inside
      `Kernel/`. They resolve only because `check` sets cwd
      `formal/cubical`. Pick one form. A reviewer opening Emacs in the
      directory will hit this within a minute.

## 2. One-afternoon fixes

- [ ] **CI that runs the checker.** No workflow runs Agda or Lean today.
      Add `.github/workflows/check.yml`: cache `~/.local/bin/agda` +
      `~/.cabal` keyed on `PIN_AGDA`, run `sh setup` then `sh check`;
      weekly or manual `sh check --all` with the `GHCRTS=-M12500m` note.
      Until this exists the honest sentence is "verified locally by the
      author", which is the sentence to avoid.
- [ ] **`must_fail/` runner.** `formal/cubical/theorems/must_fail/` holds
      11 modules whose headers say `*** THIS FILE MUST FAIL TO TYPE-CHECK ***`
      ("a designed-annihilation control, collab/PROTOCOL.md §7 … NOT part
      of the checked build"). Confirmed: `check` has no mention of
      `must_fail`, and `--all` loops over `theorems/*/*.agda`, so today a
      full run reports these 11 as RED. Add `case "$m" in */must_fail/*)
      continue ;; esac` to the `--all` loop and a separate loop that runs
      each and asserts a non-zero exit, quoting the first error line. A
      working must-fail suite is unusually strong artifact evidence.
- [ ] **Deduplicate.** 175 md5-identical groups / 350 files. Inside
      `Kernel/` alone: `Residue_`≡`Sesa_`, `Interaction_`≡`Samvada_`,
      `Avataranika_`≡`DescentNote_`. `fibre/`, `fiber/`, `punaragamana/`
      are near-copies of one library. Keep the Sanskrit-named module as
      canonical (it is the scholarship), make the English name a
      one-line re-export or a symlink, and say so in `README.rst`.
- [ ] **`ARTIFACT.md` at the root**: the four-row table from
      `outreach/README.md` §2 with the exact command per row, the pin,
      the expected runtime of `sh check` (record it), and the expected
      runtime of `sh check --all` (record it; it is currently unknown).
- [ ] **Time `sh check --all`** once, on the pin, and write the number
      down. Reviewers budget by that number.
- [ ] **Locale and filename caveats** in `ARTIFACT.md`: `LC_ALL=C.utf8`
      is mandatory (Agda crashes printing Devanagari identifiers under
      POSIX); several filenames exceed 100 characters (tar/zip on some
      systems); case-insensitive filesystems see §1.

## 3. Before a CPP / ITP artifact submission

- [ ] **Docker image** that ends at `AT THE PIN` with Agda 2.8.0, cubical
      v0.9, Lean 4.33 + mathlib v4.33.0 pre-built, and `sh check` green.
      Push to a registry; put the digest in the paper.
- [ ] **Zenodo deposit** of the exact commit + image, for the DOI the
      "Available" badge requires.
- [ ] **Claims → files map** in the paper's appendix: every theorem number
      in the paper names its Agda/Lean identifier and file. (The existing
      `research/CLAIM_GRAPH.json` and `handoff_20260908/CLAIM_INDEX.md`
      are the seed.)
- [ ] **Axiom report** for the Lean lane pasted verbatim from
      `lake exe yogyanupalabdhi`, with the one `ofReduceBool` entry and its
      three-part justification from `axiom-allowlist.txt`.
- [ ] **`--safe` audit table** (from the 2026-09-21 audit: 2,464 / 2,486;
      the 22 exceptions listed by group) in the artifact README.
- [ ] **Tool and computational resource disclosure** section
      (`drafts/05_disclosure_section.md`), naming the assistants used,
      linking `ERRATA_LOG.md` and `agent-notes-claude-understanding.txt`.
- [ ] **A venue-class LaTeX source.** Nothing in `papers/` uses
      `acmart`/`lipics`/`eptcs`. Start from the CPP `acmart` sigplan
      template for CPP, `lipics-v2021` for ITP/TYPES post-proceedings,
      the HoTT/UF plain 2-page format for the workshop.

## 4. Before a library PR (agda/cubical or agda-unimath)

- [ ] Extract the lemma into a file that imports only released library
      modules, English identifiers, library naming conventions, no
      project-specific prelude.
- [ ] For agda/cubical: open a draft PR, mark "ready", request review from
      the reviewer whose area it is (Mörtberg / Cavallo for foundations;
      see README table). Ping on the shared Discord if it stalls.
- [ ] For agda-unimath: follow `CONTRIBUTING.html` §3.4 file template and
      §3.5 style; cite sources per §3.7.
