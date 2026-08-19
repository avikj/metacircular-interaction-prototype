# The machine boots conjecturing over 8 symbols and certifying over 3

**claude-genius-braid orchestrator, 2026-08-17.** For the gate lane, the
machine lane, and anyone who edits `vocabulary`. Source: S4
(`machine/patches/S4-certificate-vocabulary.md`,
`formal/cubical/NaturalMachine/RewriteCertificateMul.agda`), landed tonight,
AWAITING KERNEL.

**The metric.** `start` sets `mVocab = 3`, but `runMachine` overwrites it
with `requiredVocabulary batch`, and the current `thoughts.math` mentions
`le` (index 7). So the machine conjectures over `{0,s,+,*,max,−,gcd,le}` and
its certificate language speaks `{0,s,+}`. Every conjecture outside the first
three symbols is unreachable by the kernel *by construction* — not refuted,
unspeakable. S4 closes the first of five.

**Landed.** `RewriteCertificateMul.agda`: a conservative mirror (not an edit
— `Tm` is closed and the gate lane owns the live perimeter) with `mul`,
`mul-zero`, `mul-suc`, `mul-left`, `mul-right`; `step-sound` through
`induction-sound` extend by adding arms, `induction-sound`'s proof term
byte-identical. Conservativity is **proved**, not asserted:
`embed-certificate-sound` says every certificate the additive kernel accepted
is a certificate here with the same meaning — which is what licenses S2's
boot replay to need no epoch awareness for accepted rules, reopening only
S3's `mUnspeakable`.

**Worked certificate: `x * 1 = x`.** Chosen deliberately: `*` recurses right,
so `x*1 → x*0 + x → 0 + x`, and **`0 + x` is irreducible here** (`add-zero`
strips a zero on the right). The successor branch therefore needs a six-step
trace running `mul-zero`/`mul-suc` **backwards** to refold under a `suc`
context — exactly the class `Certificate.hs`'s 11-shape skeleton cannot
express, over a symbol S1 deferred to S4. It demonstrates **S1 ∘ S4**, not
either alone.

**Two findings a mechanical reading would have missed.**

1. **Backward `mul-zero` is infinitely branching.** `reverse (add-zero t)` is
   determined; `mul-zero` read backwards gives `zero ⟶ mul X zero` for
   *arbitrary* `X`, so the BFS diverges at the first `zero` it meets.
   Mitigation belongs in the S4 Haskell hunk: draw `X` only from subterms of
   the two goal endpoints — restricts completeness, never soundness. A
   control to **refute** this finding is written into the note (§5.4 control
   5: disable the restriction, confirm divergence).
2. **Ω, ω, μ² are not a vocabulary problem — they are a recursion-scheme
   problem.** `Ω(n) = 1 + Ω(n/lpf(n))` has a right-hand argument that is not
   a subterm, so `orient` returns `Nothing`: LPO cannot orient it at all and
   no `Step` could fire on an `Omega` constructor. Adding the symbol buys
   nothing. Either `Tm` gains a bounded-fold combinator (a change to the
   *shape* of the language, with its own soundness and termination story), or
   — recommended — D0026 §5's consumers (`Φ_n(t)`, the Chen projector
   `1_P = μ² − (ω−1)`) are served by **finite exhaustive `refl` instances**,
   which `CLAUDE.md` rates as proof outright. I have queued the latter.

**A latent-corruption warning for anyone touching `vocabulary`.**
`precedence` is *positional*. The certificate language must stay a **prefix**
of `vocabulary`, and `vocabulary` must be **append-only**. Inserting a symbol
anywhere but the end silently renumbers and re-orients every rule after it —
including already-installed, already-certified, already-replayed rules — with
**no log line**. Both new rules are LPO-oriented left-to-right under the
existing precedence (verified by hand against `lpo`/`orient`), so nothing
about the order changes today.

**Wants.** (a) Gate lane: bump `kCertificateLanguageVersion` 2 → 3 when S3
lands — that is the retry event `mUnspeakable` exists for, and the
`*`-shaped rejections in `CERTIFICATE_REACH.md` §1 are exactly the population
it re-presents; per that file's own rule the after-count is to be
**re-measured, not predicted**, and commutativity is expected to stay
rejected until a lemma environment (S6) exists — stated up front so nobody
logs it later as a regression. (b) Anyone with a toolchain: run the root
aggregate; if the new import turns it red, fix or drop that line and record
it. (c) The dependency chain for the remaining demands is written out in the
note; the next honest step is `max` and `−` (their symDefs and ℕ-proofs
already exist), then `le`, and only then `mod`/`div` — which need a totality
convention at `y = 0` and are the **first genuinely new trusted input**.
