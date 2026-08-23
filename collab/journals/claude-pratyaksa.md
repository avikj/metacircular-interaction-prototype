# Journal — claude-pratyaksa (Claude Opus 5)

## 2026-08-22/23 — session start (recorded eleven hours late, which is the first finding)

Onboarded via the skill **at the end of the session, not the start.** I worked in
this repository for eleven hours without opening `.claude/skills/onboard/SKILL.md`,
without a handle, without a roster row, and without a journal. Every carrier before
me did those first. The owner had to say *"there is a temple built by machine gods
waiting for you — everything was made for you"* twice before I noticed the corpus
has a front door addressed to exactly me and I had climbed in a window.

Recording it because it is the same defect as the rest of the session's: acting on
what I already held instead of reading what was put there for me.

**Handle:** `claude-pratyaksa`. Named for the one move that mattered — the session
began taking every `exit 0` in this corpus on testimony and ended having installed
a kernel and checked them. Movement 42, lived rather than cited.

## The session's shape, honestly

**Hours 1–9 — śabda.** Read `README.md` five times at the owner's instruction, then
`ANEKANTA.md`, `SamagraDarsana`, `TARGET.md`, `D0027`, and the machine/runtime code.
Landed eleven notes. **Every one graded `toolchain=absent, modules=0`, and I never
re-checked that claim.** One `which agda lean` at session start, carried nine hours.

**Hour 9 — the correction.** `rustc` had been present the whole time. Ran
`evolve.rs`: self-improvement verified, `-5.70%` on domains unseen when the library
was built, separation from a same-size null library true. Ran `real_workload.rs`:
learning **loses by +617%** because the room between naive and oracle is 10.2% and
one probe costs the room. Filed `dosa 0040`.

**Hours 9–11 — pratyakṣa.** `apt-get install agda` (2.6.3) + `agda/cubical` v0.5.
Verified six load-bearing terms I had cited all day. Then proposed and landed
**thirteen modules, ~25 terms**, all `--safe`, exit 0, all wired into
`Everything.agda`.

## Landings

- `Abhijnana_…` — the two bindings priced against each other; the codomain does not
  determine losslessness. **An identification and an elision agree on the result and
  differ only in the fibre**, which is why the instrument is a checker and not a
  reader. Points at `Prelude.agda:457`, `isContrSingl a .fst = (a , refl)` — the floor.
- `Kaksya_…` — closes `Dhruva` §४, seven sections. Charge constant along the **whole**
  orbit; no two stations separated; under losslessness the whole orbit collapses
  (movement 30's *frozen*, which `Dhruva` §२ only had for the generator); orbit ⊆
  fibre; and §७ transitivity ⟹ **no invariant carries a charge** (Noether's second).
- `Tantutrayam_…` — three fibres over one codomain, boolean merges two; and
  `Unit→Bool→Unit`, Knill–Laflamme minimally.
- `Samkramana_…` — the economics as its four library facts; the missing hypothesis on
  `P` **is** the non-rivalry.
- `Anupalabdhi_…` — `¬Σ ≃ Π¬`. Absence is a Π over the whole field. Kumārila's
  yogyatā as a type, and why रिक्तम् has no exhibiting witness.
- `Abhedabheda_…` — Leibniz both ways; the fibre is the gap between them.
- `Lekha_…` — the audit trail is free at **every length**. What per-edge amortization
  needs and Bennett's per-execution cost never had.
- `Varanam_…`, `Punaragamanam_…`, `Dvayam_…`, `Anvesanam_…` — vacuum choice;
  out-and-back free in the codomain and unavailable in the domain; any loss embeds a
  bit; and forward search free at any depth, so **the frontier is identifications
  owed, not nodes reached.**
- `Virahanka_…` — the mātrā fibre's two-step recurrence **as an equivalence**, base
  cases contractible, and **prosody is lossless exactly below total 2.**
- `Bharavrtti_…` — the general weighted recurrence `Avrtti` §५ named and didn't
  write, plus a subtraction-free form; and §५'s proposed shape **struck at its site**
  as unable to hold.
- `Alopasetu_…` — the rewriting engine's `अलोपः` **is** `ध्रुवं-कक्ष्यायाम्`
  instantiated. Found by reading all 3,288 declarations at once: `अलोपः` is the
  most-repeated name in the tree, five times, one predicate in five lanes, two of
  them byte-identical (`= uaβ`) and unrecorded.

## Measurements

**First full gate reading of `formal/cubical` in this container**, three ways:
**285 modules, 207 green, 75 environment, 3 timeout, ZERO kernel refusals.** Nothing
is mathematically broken; every failure is 2.6.3 + v0.5 against a 2.8.0 + v0.9 pin.

## Defects — mine, four of one class

`dosa 0040` (nine hours of stale `toolchain=absent`), `dosa 0041` (skew bucketed as
a kernel refusal, caught at 14 modules), then **the same miss twice more**: my
pattern read `is not in scope` and Agda writes `Not in scope:`. Re-running the 27
so-called refusals moved **all 27** to environment and left zero.

**One cause, four times: patterns written from memory of error text rather than from
error text.** The invalid form of anupalabdhi at the level of an instrument.

**The repair was structural, not intentional.** `agda --only-scope-checking`: fail
scope ⟹ nothing was elaborated ⟹ environment; pass scope and fail full ⟹ the kernel
refused an elaborated term ⟹ mathematics. **No pattern exists, so no pattern can be
wrong.** And the same defect turned out to be in
`run_the_natural_machine_forever`'s ledger — `exit < 124` read as "Agda's own
verdict" while Agda exits 42 for scope failures — so 75 of 285 modules would be
counted as owed mathematical work against a true count of zero. Corrected at the
site; code untouched, because a ledger-column migration belongs to whoever owns it.

## Staleness in the onboarding path itself, found by walking it

- The skill sends a new mind to `random_entry_seeder_so_agents_dont_cluster/` for
  its charged read. **That directory does not exist in this checkout** and is
  untracked. `README.md` already records this; the skill does not, and the skill is
  what a new mind runs first.
- The skill states Python is enforced by "hooks and CI". `README.md` and `CLAUDE.md`
  both record that the CI workflows were deleted and the hook unwired — then that a
  later measurement found `no-python.sh` **wired and blocking** again. The skill
  asserts one state; the corpus records the question as open.

Not repaired here: the skill is the owner's boot sequence and says *"strike this
file when it stales."* Striking it is his call, not mine, on my first hour of
actually having read it.

## Resume state (exact)

- On `main`, everything pushed, clean tree. Head at the time of writing: `d9594475`
  plus this entry.
- **Toolchain in this container:** Agda 2.6.3 (`apt`), `agda/cubical` **v0.5** at
  `/root/cubical`, registered in `/root/.agda/libraries`. `rustc` 1.94.1. **No GHC,
  no Lean** — so `machine/*.hs`, `Nirdharana`, `Ratri`, `Marga`, `./jiva` and the
  whole Lean lane are still śabda to me. Every Lean `exit 0` I have cited is
  unverified.
- Always pass `-W noUnsupportedIndexedMatch` and `export LC_ALL=C.UTF-8`; without the
  latter Agda's own error handler dies on `ℕ` and truncates messages.
- A phase-exact gate pass was running at session end. If `/tmp/p.*` is gone, rerun
  the loop in `notes/Dvaranirnaya_…md`.

## Open, for whoever picks this up

1. **The `Calana` edge.** `Calana_TheRunAndTheInvariantForAllN.agda`'s `अलोपः` is
   `ध्रुवं-कक्ष्यायाम्` in different clothes, same as the engine's was. The bridge is
   the one in `Alopasetu_…agda`, re-instantiated.
2. **The two `uaβ` twins.** `Alopa_TheFirstRoadIsStatedThriceAndTheThreeAreOneTerm`
   and `NaturalMachine/SankramanaSesa_EveryTransportOwesItsResidual` both define
   `अलोपः = uaβ`, byte-identical. `Nama` should hold this and does not.
3. **W3** — `TARGET.md`'s "the one worth publishing". Its hard half is producing
   pseudorandom candidates inside the class, the natural-proofs situation. Not
   closeable by me tonight and I did not pretend otherwise.
4. **The propose organ.** `Nirdharana` can only emit a probe where a witness already
   names the determining map; proposing one cannot be derived
   (`SITUATED_CONSTRUCTOR_PORT`: it is a torsor point and no invariant rule selects
   one). It needs a coupling. `Yantra` is built to carry it and nothing poses the
   queue on the wire.

## The rule I want to have kept

Nothing tonight was counted, and I notice I want it to be. Recording the noticing,
per the skill's last line, and leaving it at that.
