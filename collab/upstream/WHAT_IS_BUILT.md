# The upstream corpus: what has been built from it

## Provenance, corrected 2026-08-17 — read this before treating any row as direction

This file used to open "the owner's design corpus … It is what to build."
That overstates what is known. The human owner has confirmed only that these
documents were **supplied** by him, not that he wrote them, and has asked that
nothing be attributed to him without a clear human-authored quote.

What is clearly human-authored is `collab/upstream/raw/U00*.txt` — twenty short
typed messages — plus decisions recorded second-hand (Python banned; one branch
`main`; keep the work private; live computation is not what this is for).

Everything else here is in the register of generated text, and one of them says
so outright: `U0006.txt` opens `update from chatgpt agent:`, and
`chatgptdump.md` states in its own front-matter that it was written for agents.
The `D00*` deltas and the ~83 documents in `library/raw/` share that register.
The header on `D0015` reading *"Owner-supplied, therefore upstream: this
outranks CLAUDE.md and PROTOCOL.md"* was written by an agent (`cf-archivist`)
about a document that agent did not author, and that inference has since been
copied into `README.md`, `AGENTS.md`, and the onboard skill as a standing
instruction.

So: these documents get no authority from provenance. They get exactly as much
as they can defend on inspection, like anything else in this repository. A row
moves from **nothing** to a filename when a checker accepts the mathematics,
not when a document asserts it.

## The two columns

What exists in code, and what does not. No grades, no process.

| design | built |
|---|---|
| Coordination Kernel §7, K2 local serialization | `formal/cubical/Coordination/Serialization.agda` — semantic half checked; combinatorial half is an un-inhabited record |
| EGB Factory IV Thm 58 (parity projector on the Chen envelope) | `formal/cubical/NaturalMachine/ChenProjector.agda` |
| EGB Factory IV §XI (projectors commute, information does not) | `formal/cubical/NaturalMachine/CornerProjectors.agda` |
| EGB Factory IV §X Thm 70 (mixed-corner descent) | `formal/cubical/NaturalMachine/MixedCornerDescent.agda` |
| EGB Factories VIII/IX skeleton (three channels, μ²−π₁) | `formal/cubical/NaturalMachine/ThreeChannels.agda` |
| Coordination Theorems 534/680 (SafeMod) | **nothing** |
| Coordination Kernel §56 (CertifiedRel, composition) | **nothing** |
| Coordination Kernel §38 (coordination compiler) | **nothing** |
| DSO: Isbell nucleus, quantale residuation, min-plus rank | **nothing** |
| DSO item 130: Chu object, selection monad, proof-relevant Bellman | **nothing** |
| Knowledge geometry Δ08 Thm 1 (install law, cone, redundancy gate) | **nothing** (prose only, `notes/PROOF_METRIC_COMPILER.md`) |
| Sufficient interfaces Δ01 (Suff, κ₀, the nerve, the join failure) | `formal/cubical/NaturalMachine/SufficientInterfaces.agda` — T1, T4, T7, T12, T13, P6, T8 checked; T3's NP-hardness not formalized (it is a claim about computing with the relation, not about the relation) |
| Sufficient interfaces Δ02–03 (τ*, C∞) | **nothing** |
| Proof-carrying relations Δ04 (V_R, evidence grades) | **nothing** |
| Circulation claim graph + typed edges | **nothing** (repo's own registry is broken: 12 of 49 packets fail their invariants) |
| GTER Δ37/38 | source text not exported |
| DSO Δ26–30 full texts | source text not exported |
