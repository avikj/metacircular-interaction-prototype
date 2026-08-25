/-
# योग्यानुपलब्धिः — the axiom check states where it could have seen

## The term, and whose it is

*Anupalabdhi* — knowledge from non-apprehension — is the sixth pramāṇa in the
**Bhāṭṭa Mīmāṃsā** list (Kumārila Bhaṭṭa, *Ślokavārttika*, `abhāvapariccheda`,
c. 7th c.), carried on by Advaita. Its whole force sits in one qualification:
**yogyānupalabdhi**, non-apprehension *of what is fit to be apprehended*. "Not
seen" concludes nothing. "Not seen where, were it present, it would have been
seen" concludes absence.

Naming the school is not decoration, because the schools disagree here and the
disagreement is the content. **Nyāya rejects anupalabdhi as a separate
pramāṇa** — for the Naiyāyika (Gaṅgeśa, *Tattvacintāmaṇi*, `abhāvavāda`)
absence is perceived, the qualified locus is the object of an ordinary
`pratyakṣa`, and the *pratiyogin* — the counter-correlate, the very thing whose
absence is claimed — must be known first. **Jaina logicians** reject both
framings as one-sided: `syād-nāsti` is a standpoint, and asserting it while
concealing the standpoint makes it a **durnaya**.

What all three would say to this program is the same, and that is why the term
is on the file: *the sentence "no axiom outside the base was found" is not
knowledge until the program says where it was looking.* This file's `OK` line
therefore carries its own yogyatā, and the limits it cannot see past are named
in it and below, in the output itself, not only in a note.

## What it does

Imports **every** module under `Pairfield/` — discovered by walking the
directory, not by an import list that can rot — walks the resulting
environment, and for every non-internal constant **that came from one of those
modules** calls `Lean.collectAxioms`, the same function `#print axioms` calls.
A declaration passes iff its axiom set is a subset of

    {propext, Classical.choice, Quot.sound}

or it is named in the checked-in allowlist (`axiom-allowlist.txt`). Any other
dependency — a `native_decide`-generated axiom, `sorryAx`, a hand-written
`axiom`, or any future escape hatch — fails. The program is not taught the
*names* of the escape hatches, so a new one needs no edit here: three axioms
are allowed and everything else is refused.

## Two repairs over the 2026-08-19 version, and what each was worth

**1. Scope is by module, not by name.** The previous scan selected
declarations by the test `` `Pairfield |>.isPrefixOf n ``. A lane module that
opens no `namespace Pairfield` — or that declares anything before opening one
or after closing it — produces constants this test skips, and the run then
prints `OK` having never called `collectAxioms` on them. Scope is now
membership in the set of imported lane modules, which is the condition that
was actually meant and does not depend on what an author named things.

I expected this to be latent, wrote that it was, and it was measured and is
not. A probe run against the same 134 imported modules counts **3439**
non-internal constants attributed to a lane module, of which **2 carry no
`Pairfield` prefix and were therefore never passed to `collectAxioms` by any
run of the previous version**:

    Nat.gcd.eq_def
    Nat.gcd.eq_1

They are equation lemmas, generated on demand by `norm_num [..., Nat.gcd]` at
`Pairfield/IncrementalCRTAdapter.lean:336` and added to the environment under
the name of the function they unfold, not under the namespace of the file that
asked for them. Nothing about a `namespace` declaration is involved — which is
why the syntactic prediction failed. Both are clean, so no unsound term was
found hiding there; what was found is that the reach of the check was 2 short
of what it reported, and the reason had a mechanism nobody had named.

**2. Every constant kind, not three.** The previous scan looked at `theorem`,
`def` and `axiom` and passed over `opaque`, inductives, constructors and
recursors. The same probe counts **228** such constants in lane modules —
inductive types, their constructors and their recursors — none of which was
ever passed to `collectAxioms`. A constructor's or recursor's TYPE can mention
a tainted definition, so this was reach, not bookkeeping. Anything a lane
module puts in the environment is now examined.

Together the two repairs moved the check from 3209 constants to 3439 — 230
more, 6.7% — and all 3439 rest on the three axioms. What was wrong before was
the SCOPE, never the verdict; but an `OK` over a scope nobody had measured is
an absence reported without its yogyatā, which is precisely the failure the
term on this file names.

## What it still cannot see — the yogyatā, printed on every run

  * **Anonymous `example`s emit no constant.** There is nothing in the
    environment to walk, so an oracle inside one is invisible here. This is
    structural, not an oversight: `scripts/check-lean-example-oracles.sh`
    single `native_decide` sat in exactly that blind spot.
  * **Axioms, not statements.** A theorem may rest on the three axioms and
    still not say what the prose citing it says it says. That is a different
  * **The build, not the source.** It reads `.olean`s. A `.lean` file with no
    `.olean` is a hard error here (import fails), which is the intended
    behaviour, but it means a green presupposes a completed `lake build`.

## Allowlist rot

Reported, never fatal on its own — a rename must not turn a soundness check
red:

  * **stale** — an allowlisted declaration that is now clean;
  * **absent** — an allowlisted name that no longer exists.

Each is a standing instruction to edit the file, since an allowlist nobody
prunes is a rubber stamp.

Usage: `lake exe yogyanupalabdhi [srcDir] [allowlistFile]`, defaults `.` and
`./axiom-allowlist.txt`. Exit 0 clean, 1 residue, 2 usage/IO error.

History: this file was `AxiomGate.lean` / `lake exe axiom_gate` until
2026-08-20. Renamed on the owner's binding naming instruction — a gate admits
or refuses and is the boolean; a pramāṇa produces knowledge and carries its own
yogyānupalabdhi. The older name is still correct in `collab/messages/` and in
run then and are left as they are.
-/
import Lean

open Lean

/-- The three axioms of classical Lean. Everything else is a hole. -/
def baseAxioms : List Name := [``propext, ``Classical.choice, ``Quot.sound]

/-- Every `.lean` file under `dir`, recursively. -/
partial def leanFilesIn (dir : System.FilePath) : IO (Array System.FilePath) := do
  let mut out : Array System.FilePath := #[]
  for e in (← dir.readDir) do
    if (← e.path.isDir) then
      out := out ++ (← leanFilesIn e.path)
    else if e.path.extension == some "lean" then
      out := out.push e.path
  return out

/-- `Pairfield/Foo/Bar.lean` (relative to the source dir) ↦ `Pairfield.Foo.Bar`. -/
def pathToModule (rel : System.FilePath) : Option Name := Id.run do
  let s := rel.toString.replace "\\" "/"
  let s := if s.startsWith "./" then (s.drop 2).toString else s
  let parts := s.splitOn "."
  if parts.length < 2 then return none
  let base := String.intercalate "." (parts.dropLast)
  let comps := base.splitOn "/"
  if comps.isEmpty then return none
  return some <| comps.foldl (fun n c => Name.mkStr n c) Name.anonymous

/-- Parse the allowlist: `#`-comments and blank lines ignored, one name per line. -/
def readAllowlist (f : System.FilePath) : IO (Array Name) := do
  unless (← f.pathExists) do
    IO.eprintln s!"yogyanupalabdhi: no allowlist at {f}; treating it as empty"
    return #[]
  let mut out := #[]
  for line in (← IO.FS.lines f) do
    let line := (line.splitOn "#").headD "" |>.trimAscii.toString
    if line.isEmpty then continue
    out := out.push (line.splitOn "." |>.foldl (fun n c => Name.mkStr n c) Name.anonymous)
  return out

structure Finding where
  kind : String
  name : Name
  extra : Array Name
  mod : Name

/-- The kind label, for the report. Unlike the 2026-08-19 version this never
returns "skip": every constant kind a lane module can emit is examined. -/
def kindLabel : ConstantInfo → String
  | .thmInfo _     => "THM"
  | .defnInfo _    => "DEF"
  | .axiomInfo _   => "AXIOM"
  | .opaqueInfo _  => "OPAQUE"
  | .inductInfo _  => "INDUCTIVE"
  | .ctorInfo _    => "CTOR"
  | .recInfo _     => "REC"
  | .quotInfo _    => "QUOT"

/-- The scan, and the whole soundness claim of the lane.

`lane` is the set of module names walked off the disk. Scope is membership in
it — NOT a `Pairfield` name prefix, which is what the previous version used and
which a module declaring outside `namespace Pairfield` slips past silently. -/
def scanEnv (lane : Std.HashSet Name) (allow : Array Name) :
    CoreM (Array Finding × Array Name × Nat) := do
  let env ← getEnv
  let mods := env.header.moduleNames
  let mut findings : Array Finding := #[]
  let mut clean : Array Name := #[]
  let mut examined : Nat := 0
  for (n, ci) in env.constants.toList do
    if n.isInternal then continue
    let some idx := env.getModuleIdxFor? n | continue
    let some mod := mods[idx.toNat]? | continue
    unless lane.contains mod do continue
    examined := examined + 1
    let axs ← collectAxioms n
    let extra := axs.filter (fun a => !(baseAxioms.contains a))
    if extra.isEmpty then
      if allow.contains n then clean := clean.push n
    else
      unless allow.contains n do
        findings := findings.push { kind := kindLabel ci, name := n, extra, mod }
  return (findings, clean, examined)

def main (args : List String) : IO UInt32 := do
  let srcDir : System.FilePath := System.FilePath.mk (args[0]?.getD ".")
  let allowFile : System.FilePath :=
    match args[1]? with
    | some p => System.FilePath.mk p
    | none => srcDir / "axiom-allowlist.txt"
  let pfRoot := srcDir / "Pairfield"
  unless (← pfRoot.isDir) do
    IO.eprintln s!"yogyanupalabdhi: {pfRoot} is not a directory (run from formal/lean)"
    return 2
  let files := (← leanFilesIn pfRoot).push (srcDir / "Pairfield.lean")
  let mods := files.filterMap fun f =>
    pathToModule (System.FilePath.mk (f.toString.drop (srcDir.toString.length + 1)).toString)
  -- Files found on disk vs modules named: if these differ, something under
  -- `Pairfield/` is not a module and the difference is printed, not swallowed.
  IO.println s!"yogyanupalabdhi: {files.size} .lean file(s) under Pairfield/ \
(counting the root), {mods.size} resolved to module names; importing them"
  let lane : Std.HashSet Name := mods.foldl (fun s m => s.insert m) {}
  let allow ← readAllowlist allowFile
  initSearchPath (← findSysroot)
  let env ← importModules (mods.map fun m => { module := m }) {} (trustLevel := 0)
  let ((findings, cleanAllowed, examined), _) ←
    (scanEnv lane allow).toIO { fileName := "<yogyanupalabdhi>", fileMap := default } { env }
  -- allowlist rot
  for a in allow do
    unless (env.contains a) do
      IO.println s!"ALLOWLIST-ABSENT\t{a}\t(no such declaration; prune it)"
  for a in cleanAllowed do
    IO.println s!"ALLOWLIST-STALE\t{a}\t(now clean; prune it)"
  if findings.isEmpty then
    IO.println s!"yogyanupalabdhi: OK — {examined} non-internal constant(s) from \
{mods.size} lane module(s) rest on {baseAxioms} (allowlisted: {allow.size})"
    IO.println "yogyanupalabdhi: yogyatā of this OK — scope is module membership, \
not a name prefix, so a declaration outside `namespace Pairfield` is still seen; \
every constant kind is examined, not only thm/def/axiom. NOT seen: anonymous \
`example`s (they emit no constant — scripts/check-lean-example-oracles.sh is the \
complement), and whether a statement says what the prose citing it says \
    return 0
  IO.println s!"yogyanupalabdhi: FAIL — {findings.size} declaration(s) outside the \
trusted axiom set, out of {examined} examined"
  for f in findings.qsort (fun a b => a.name.toString < b.name.toString) do
    IO.println s!"  {f.kind}\t{f.name}\n      module: {f.mod}\n      axioms: {f.extra.toList}"
  return 1
