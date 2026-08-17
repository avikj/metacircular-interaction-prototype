# The repair torsor, as a term: `NaturalMachine/RepairTorsor.agda`

Seed 182, 2026-08-15. Persona: algebraist who formalizes.

`notes/NUMBER_TOWER_AS_REPAIR.md` closes with the only piece of it that is not
classical: the schema of §4.3, and Proposition 9. Both are category theory and
therefore checkable, and the note itself says nothing was typechecked. They now
are. **`formal/cubical/NaturalMachine/RepairTorsor.agda` checks, exit 0**,
Agda 2.6.3 + the container's cubical library, `--cubical --safe
--no-import-sorts`, no postulates, no holes, no warnings.

## What is a term now

For an arbitrary category `S` (the note's category of repairs — objects
`(Y , ι : X → Y)`, morphisms maps under `X`; the slice is *not* constructed,
because the schema never uses it and the note states it for a bare category):

1. `AutGroup y` — `Aut_S(y) = CatIso S y y` as a `Group`, via `makeGroup`.
2. `isTorsor f g : isContr (Σ[ a ∈ Aut y ] (f ⋆ a ≡ g))` — the action of
   `Aut y` on the comparisons `CatIso S x y` is **free and transitive**. The
   centre of contraction is the explicit `transporter f g = f⁻¹ ⋆ g`, so the
   witness is computed and not merely asserted; `actFree` states freeness
   separately.
3. `trivializeAut f₀ : Aut y ≃ CatIso S x y` — a **chosen** repair trivialises
   the torsor. This is the specialization the task asked for:
   `FOUR_REPAIR_MODES.md` Thm 3's "the set of completions is empty or a
   `V^Γ`-torsor, and a lift must be chosen" is this statement with the group
   named `V^Γ`; it is obtained by instantiating `S`, not by a second proof.
4. `rigid→isoUnique` — **the rigidity lemma**: `Aut_S(y)` trivial implies any
   two isomorphisms `x ≅ y` are *equal*, i.e. unique up to UNIQUE isomorphism;
   `rigid→isContrIso` upgrades an inhabitant to `isContr`; `nonRigid→twoIsos`
   is the converse direction (a nonidentity automorphism yields two distinct
   comparisons). This is the separation the note uses between tower steps 1–3
   and step 4.
5. `initial→AutTrivial`, `initial→isContrIso`, `nonRigid→notInitial` —
   Proposition 9 verbatim, both sentences.
6. A **computed finite instance**: the one-object groupoid on `Bool`
   (`id = false`, composition = xor). Two repairs, distinct
   (`twoRepairs-differ`), the unique automorphism carrying one to the other is
   `true` and *reduces* to it (`transporter-computes = refl`), the object is
   not rigid and hence not initial. This is the abstract shape of the note's
   Thm 6(iv) — two square roots of −1 interchanged by a group of order two —
   and it is not claimed to be `ℂ/ℝ`.

## Scope limits, stated

- **Aut(ℤ)=Aut(ℚ)=Aut(ℝ)=1 and Aut(ℂ/ℝ)≅ℤ/2 are NOT formalized** and were not
  attempted: they need real and complex analysis, out of reach of this lane.
  They are the note's cited inputs (Thm 6, proved there by hand); what is
  formalized is the general lemma they feed. The header says so in the file.
- Nothing of the note's §§1–3 is formalized — Ostrowski, the cardinality
  argument, the cocycle refutation are prose theorems and stay prose.
- No measurement, no numerics, no Python.

## Delta, not duplicate

`NaturalMachine/PathIsSymmetry.agda` already has `ℕ-algebra-Aut-trivial` and
`swap01-≢-id`. I read it before writing. That module shows *one* object is
rigid and another is not, in the category of types; it does not prove what
rigidity buys. `RepairTorsor` proves the general consequence — uniqueness of
the comparison isomorphism, and the torsor structure on the non-unique case —
for an arbitrary category, and imports nothing from it. `NaturalMachine/
StabilizerTorsor.agda` proves a *group-action* torsor (`isTorsorT`) for
transporters; the present statement is the *categorical* one (automorphisms of
an object acting on isomorphisms into it) and neither is an instance of the
other as stated, though both are `isContr`-shaped for the same reason.

## Build status, plainly

- `agda NaturalMachine/RepairTorsor.agda` → **exit 0**.
- It is imported by the root aggregate `NaturalMachine.agda` (so it is not an
  orphan in the sense BUILD.md names).
- **The root aggregate does NOT check in this container, and did not before my
  change.** `agda NaturalMachine.agda` fails at
  `NaturalMachine/PathIsSymmetry.agda:98` with `Not in scope: SymGroup`. I
  verified this on a clean tree (stash, rebuild, restore): identical failure,
  exit 42, with my import removed. The cause is the toolchain skew BUILD.md
  itself documents from the other side: BUILD.md pins **Agda 2.8.0 + cubical
  v0.9**, where `Symmetric-Group` was renamed `SymGroup`, and this container
  has **Agda 2.6.3 + the older cubical**, which still spells it
  `Symmetric-Group`. So the tree is v0.9 source against a v0.5-era library.
  **BUILD.md's "root exits 0" is not reproducible here**, and anyone quoting
  it should first check `agda --version`. My module is written to check under
  *this* container; I have not checked it under 2.8.0/v0.9 and do not claim it.

## Queue

- `PROVE` — the note's §7 item 1 asks for a third corpus defect where the
  schema decides and `FOUR_REPAIR_MODES.md` Thm 3 does not apply. Item 3 above
  makes the containment formal (Thm 3 is `trivializeAut` at a particular
  group), so the question is now sharp: exhibit a repair category whose `Aut`
  is not the invariants of any coefficient module.
- `DEMONSTRATE` — resolve the toolchain skew, one way or the other. A tree
  that checks against neither pinned toolchain nor the installed one is the
  same hole `Everything.agda` was written to close, one level further out.

*Credit: the tower, its defect-arrows and the test-case framing are the human
owner's (D0020). Prop 9 and the §4.3 schema are `NUMBER_TOWER_AS_REPAIR.md`'s.
This message and the Agda are mine; the mathematics was done before I started
and I redid none of it.*
