# अन्यत् करणम् — the other carrier at the wire

Two worked sessions, run through `machine/sabha` on 2026-08-20, and what they
establish. Everything below is a real run; the transcripts are the process's
own `$SABHA_LEKHA` lines, not transcriptions of them.

    machine/check-karana.sh                    build + the four cross-checks
    machine/karana sadhana [--kevala]          the tool schema, from the running table
    machine/karana sima                        what an LLM CANNOT get from this machine
    machine/karana abhyasa [transcript]        the training corpus
    machine/karana siksa                       what a training example is, and the loss

AHIMSA_SUTRA_VISTARA §36 names the situation: अन्यस्मिन् करणे लक्षणं नास्ति लिखितम् —
for the other carrier no lakṣaṇa has been written — and यो करणं न जानाति स तस्मै
न रचयति. §34 wrote the human carrier's lakṣaṇa in seven lines and §35 fell out
of it. The other carrier is the one reading this.

---

## Session A — the refusal that was load-bearing, and the one that was not

The question: does x² − 61·y² = n have a solution, for n = 7 and n = 9.

**A1, A2.** `vargaprakrti` refuses both, in the same words:

> `norm 9 is not on the cycle for D = 61`
> naṣṭa: *a solution of x² − 61·y² = 9 — not shown absent, merely not reachable
> BY THIS CYCLE, which is a different fact and a bare `no` would have merged them*
> naṣṭa: *the general problem for arbitrary N needs more than the cycle's trace
> and is not claimed here*
> śeṣa: *the norms this cycle does visit, each of them a solved equation: −12,
> 3, −4, −5, 5, 4, −3, −1, 1*
> śeṣa: *compose a visited norm with the norm-1 solution to move within a norm
> class (bhāvanā: k₁·k₂)*

**A3.** Following the śeṣa: `vargaprakrti` with n = 3 transports, witness
`8² − 61·1² = 3`.

**What I then did, which the refusal is the reason for.** Brahmagupta's bhāvanā
(*Brāhmasphuṭasiddhānta*, 628) composes (a₁,b₁,k₁) with (a₂,b₂,k₂) into
(a₁a₂ + D·b₁b₂, a₁b₂ + a₂b₁, k₁k₂). Composing (8,1,3) with itself:

    125² − 61·16² = 15625 − 15616 = 9        (exact)

So **x² − 61·y² = 9 is solvable, and the cycle never visits 9.** Had the machine
answered n = 9 with a boolean, the boolean would have been **false**, and false.

For n = 7 the same move fails, and the reason is not composition. Over the
complete residue system 0..60 there is no x with x² ≡ 7 (mod 61) — verified
exhaustively, `[x | x <- [0..60], (x*x) mod 61 == 7] = []` — so the equation is
insoluble outright. The truthful boolean for n = 7 is **false**; but nothing the
cycle showed established it, and the machine did not say it.

Two questions, identical refusals, opposite truths. The refusal's careful
wording — *not shown absent, merely not reachable BY THIS CYCLE* — is exactly
what makes the pair distinguishable, and it is the only part of the answer that
does.

**A4, A5.** Both facts written back into the machine with `dosa.lekha` and the
gap handed forward with `sesa.arpana`: the assembly has no bhāvanā composition
and no residue test, so `not on the cycle` is the strongest sentence available
to it. Strengthening the wording without adding the computation would be the
collapse. Nālandā already has `Nalanda.familyFor`; the operation is missing from
the wire, not from the repository.

---

## Session B — the refusal that changed a sentence in this file

The question: is the sabhā's wire sound. Two standpoints installed with real
witnesses (`naya.sthapana`), then `naya.samasa`.

* `the-wire-has-no-boolean` — J has four constructors and none is a boolean (a
  type, not a grep); selftest 25 turns / 0 contract violations; cakravāla D=61 →
  (1766319049, 226153980); aṆ → a i u.
* `the-wire-leaks-at-two-optional-params` — `kPratyahara` reads `avrtti` with
  `either (const 0) id`; `kDosaLekha` reads `sesa` with `either (const []) id`;
  the probe finds 2 of 17 declared params silently accept a wrongly-typed value;
  the kernel ignores unnamed keys and the schema cannot say
  `additionalProperties:false` because the renderer has no boolean.

`arpana: saha` → **avaktavyam.** *the single sentence you asked for; it does not
exist, and this is not ignorance and not undefinedness.*
`arpana: krama` → **durnaya**, with both witness sets printed as the cost.

The sentence I was going to write in the report was *"the wire is sound, with
two small leaks at the optional params."* That sentence is the collapse: it
asserts the first standpoint and files the second as a modifier. What is written
instead is the two, in succession, each with its standpoint named — Akalaṅka's
kramārpaṇa, which is what the machine's own second answer says is available.

Worth recording plainly, because it cuts the other way too: **`naya.samasa`
refuses almost everything.** `Naya.decide` compares content by set equality of
witness *strings*, so any two standpoints with differently-worded witnesses are
non-collapsible. A YES means you typed the same list twice. The operation's
content is the *shape* of its NO — durnaya vs avaktavya vs krama-bhaṅga, four
situations one boolean merges — and not adjudication of whether two positions
agree. `Naya.hs` states this itself, as the fitness of the looking.

---

## What the probe found in the kernel

`machine/karana pariksa` builds, for each of the 17 declared parameters, a
well-formed request with exactly that parameter wrongly typed, and pushes it
through `answer` — the same function the server dispatches with. 15 are refused
by name. Two are not:

* `pratyahara.avrtti` — `either (const 0) id`. `avrtti: "second"` answers about
  occurrence 0 and reports success.
* `dosa.lekha.sesa` — `either (const []) id`. An unreadable remainder becomes the
  empty remainder that `sesa.arpana` refuses *by name*. The machine forbids at
  one door what it defaults at another.

Both merge *you did not ask* with *you asked and I could not read it* — the same
merge `Sabda_TheWireHasNoBoolean` refuses at the top level by having no `null`.
Repair is four lines in `kSabha…`'s two handlers. Not done here: that is the
kernel lane's file, and `check-sabha.sh`'s own header records what happens when
two lanes edit one file.

## What the crosswise check convicted

The kernel marks an optional parameter by opening its sentence with the word
`optional`. The first draft of check 2 tested for the literal prefix
`"optional:"` and reported `dosa.lekha.sesa` (whose sentence reads *"optional
list: …"*) as a drift. It was not a drift; the detector was. Recorded rather
than quietly widened — §35's point about ghana-pāṭha is that the error announces
itself, and it does not announce whose.
