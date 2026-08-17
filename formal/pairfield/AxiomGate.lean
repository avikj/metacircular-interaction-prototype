/-
# The axiom gate

Post-build soundness gate for the Lean lane, the counterpart of Agda's
`--safe` flag.  Recommended (and deliberately not imposed) by
`notes/NATIVE_DECIDE_AUDIT.md` §5; implemented here.

## What it does

Imports **every** module under `Pairfield/` (discovered by walking the
directory, not by an import list that can rot), walks the resulting
environment, and for every non-internal `Pairfield.*` declaration that is a
`theorem`, a `def` or an `axiom`, calls `Lean.collectAxioms` — the same
function `#print axioms` calls.  A declaration passes iff its axiom set is a
subset of

    {propext, Classical.choice, Quot.sound}

or the declaration is named in the checked-in allowlist
(`axiom-allowlist.txt`).  Any other dependency — a `native_decide`-generated
axiom, `sorryAx`, a hand-written `axiom`, or any future escape hatch — fails
the gate.

## Why this shape and not a grep

Two of the 28 modules tainted by `native_decide` at audit time contained no
occurrence of the token: they were tainted *through imports*
(`notes/NATIVE_DECIDE_AUDIT.md` §1).  A syntactic audit counts sites; only
the kernel counts dependencies.  The gate is also not taught the *names* of
the escape hatches, so it does not need updating when a new one appears: it
allows three axioms and rejects everything else.

## Reports

Besides failures the gate reports two kinds of allowlist rot, because an
allowlist nobody prunes becomes a rubber stamp:

  * **stale** entries — allowlisted declarations that are now clean;
  * **absent** entries — allowlisted names that no longer exist.

Both are reported; neither fails the gate on its own (a rename should not
turn a soundness gate red), but each is a standing instruction to edit the
file.

Usage: `lake exe axiom_gate [srcDir] [allowlistFile]`, defaults `.` and
`./axiom-allowlist.txt`.  Exit 0 clean, 1 residue, 2 usage/IO error.
-/
import Lean

open Lean

/-- The three axioms of classical Lean.  Everything else is a hole. -/
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
    IO.eprintln s!"axiom_gate: no allowlist at {f}; treating it as empty"
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

/-- The scan itself: 20 lines, and the whole soundness claim of the lane. -/
def scanEnv (allow : Array Name) : CoreM (Array Finding × Array Name) := do
  let env ← getEnv
  let mut findings : Array Finding := #[]
  let mut clean : Array Name := #[]
  for (n, ci) in env.constants.toList do
    if n.isInternal then continue
    unless (`Pairfield).isPrefixOf n do continue
    let kind :=
      match ci with
      | .thmInfo _ => "THM"
      | .defnInfo _ => "DEF"
      | .axiomInfo _ => "AXIOM"
      | _ => ""
    if kind.isEmpty then continue
    let axs ← collectAxioms n
    let extra := axs.filter (fun a => !(baseAxioms.contains a))
    if extra.isEmpty then
      if allow.contains n then clean := clean.push n
    else
      unless allow.contains n do
        let mod := match env.getModuleIdxFor? n with
          | some i => env.header.moduleNames[i.toNat]!
          | none => `«current»
        findings := findings.push { kind, name := n, extra, mod }
  return (findings, clean)

def main (args : List String) : IO UInt32 := do
  let srcDir : System.FilePath := System.FilePath.mk (args[0]?.getD ".")
  let allowFile : System.FilePath :=
    match args[1]? with
    | some p => System.FilePath.mk p
    | none => srcDir / "axiom-allowlist.txt"
  let pfRoot := srcDir / "Pairfield"
  unless (← pfRoot.isDir) do
    IO.eprintln s!"axiom_gate: {pfRoot} is not a directory (run from formal/pairfield)"
    return 2
  let files := (← leanFilesIn pfRoot).push (srcDir / "Pairfield.lean")
  let mods := files.filterMap fun f =>
    pathToModule (System.FilePath.mk (f.toString.drop (srcDir.toString.length + 1)).toString)
  IO.println s!"axiom_gate: importing {mods.size} modules under Pairfield/"
  let allow ← readAllowlist allowFile
  initSearchPath (← findSysroot)
  let env ← importModules (mods.map fun m => { module := m }) {} (trustLevel := 0)
  let ((findings, cleanAllowed), _) ←
    (scanEnv allow).toIO { fileName := "<axiom_gate>", fileMap := default } { env }
  -- allowlist rot
  let names := findings.map (·.name)
  for a in allow do
    unless (env.contains a) do
      IO.println s!"ALLOWLIST-ABSENT\t{a}\t(no such declaration; prune it)"
  for a in cleanAllowed do
    IO.println s!"ALLOWLIST-STALE\t{a}\t(now clean; prune it)"
  if findings.isEmpty then
    IO.println s!"axiom_gate: OK — every Pairfield declaration rests on {baseAxioms} (allowlisted: {allow.size})"
    return 0
  IO.println s!"axiom_gate: FAIL — {findings.size} declaration(s) outside the trusted axiom set"
  for f in findings.qsort (fun a b => a.name.toString < b.name.toString) do
    IO.println s!"  {f.kind}\t{f.name}\n      module: {f.mod}\n      axioms: {f.extra.toList}"
  let _ := names
  return 1
