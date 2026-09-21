# Draft 1 — agda/cubical Discord + one GitHub issue (Mörtberg, Vezzosi, Cavallo)

Two separate messages. The first is a *user report* on the shared Discord
(agda/cubical · agda-unimath · 1lab). The second is a GitHub issue on
`agda/agda`, which is where Vezzosi will see it. Neither mentions the
programme. Send the Discord message first; open the issue a day later.

---

## 1a. Discord, in the agda/cubical channel

> Hi — I've been building a development on top of cubical v0.9 / Agda 2.8.0
> and have two small things that might be of interest, plus one question.
>
> **1. A SIP example that might be worth having in the library.** Base-b
> positional words with ripple-carry addition, proved a monoid, then
> `ℕ-Monoid ≡ CanWord-Monoid` by the structure identity principle, with a
> check that `cong ⟨_⟩` of the structure path is the carrier equivalence
> (`carrier-of-monoid-path`, and it is `refl`). 279 lines, `--safe`; library
> imports are `Cubical.Foundations.*`, `Cubical.Data.*`,
> `Cubical.Algebra.Monoid.Base` and the `NatSolver` tactic, plus two small
> project modules (`NaturalMachine.Digits`, `NaturalMachine.FreeMonoid`)
> that I'd inline for a library version.
> [link to `formal/cubical/NaturalMachine/Transport.agda` on the site, with
> the HTML export]. If a worked "univalence computes on a structure"
> example of this shape is wanted in `Cubical/Algebra/Monoid/Instances` or
> similar, I'd be glad to cut it down to library conventions and open a
> PR — tell me where it should live.
>
> **2. A checker observation.** One of my modules
> (`theorems/automata/Navapada_*`, a depth-4096 Rule 30 certificate)
> decides a single boolean and holds ~10 GB live doing it. Under GHC's
> default copying collector the process grows past a 15 GB machine and is
> killed; under `GHCRTS=-M12500m` the runtime switches to compacting
> collection near the cap and it finishes. I have a minimal-ish repro if
> that's useful to anyone working on Agda's evaluator — happy to open an
> issue on agda/agda with it.
>
> **3. Question.** My library carried `--cubical --safe` alone until
> recently and was unbuildable against v0.9 because v0.9 is built with
> `--guardedness` and InfectiveImport propagates it. Is the intended
> convention that downstream `.agda-lib` files always declare
> `--guardedness` when depending on cubical, or is there a way to depend
> on the non-coinductive part without it?
>
> Everything is `sh setup && sh check` from [repo link]; the pin is
> declared once in `setup`. Thanks for the library — the whole thing is
> built on `ua`/`uaβ` computing.

Notes for you: item 3 is a real question and an easy one for them to
answer; it gives them a reason to reply. Item 1 is the door. Item 2 is
what makes Vezzosi look.

---

## 1b. GitHub issue on `agda/agda` (only if 2 gets a "yes, please")

Title: `Memory profile of a large --cubical decision: 10 GB live for one boolean, OOM under copying GC, finishes under -M`

Body: Agda 2.8.0, cubical v0.9, `LC_ALL=C.utf8`. Module, command, `+RTS -s`
output with and without `-M12500m`, machine spec, time to result. Ask
whether this is expected for `Cubical.Data.Bool` decisions at this depth,
and whether there is a known evaluator setting. Attach the module or a
reduced version. Nothing else.
