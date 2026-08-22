# पुनरुक्तिः रात्रौ — the loop bound the path, and said one thing twenty-two times over

**दोषलेख. Road two, §६ of `AHIMSA_SUTRA_VISTARA.md`: लिखितो दोषो जीवति.** The
defect is in a running instrument of this repository, it is measured exactly by
two independent programs already in the tree, and it is repaired at the site.
Recorded 2026-08-22.

---

## १ · The count, from two instruments that do not know about each other

`scripts/Ratri_…sh` has landed **60 modules** into `formal/cubical/Ratri/`.

| | |
|---|---|
| modules landed | **60** |
| distinct mathematical statements among them | **38** |
| the same statement landed again under a fresh path | **22** |

The 22 are exact: comments and blank lines stripped, the positional probe tag
(`NirdharanaPthreeAD`, `…AF`, `…AH`) erased, module line removed, remaining
text byte-identical. Nine files carry three statements about `विवेक`
(`VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal`); four of
them are literally the pair `(सम 0, वाम 1, दक्षिण 0)` against
`(0,0,0)`, four are `(0,0,1)` against `(0,0,0)`, and one is the third.

**`machine/Nama_…hs` says the same thing from the other side without being
asked.** Its collision report over the whole corpus — 11,165 top-level
declarations, 10,485 addresses, 235 confirmed identical — has as its **second
largest group in the entire repository**:

```
487c173c93868188  ×14
    Ratri.Anirdharita_NaturalMachine-RewriteCertificate_Env . censusR0
    Ratri.Anirdharita_NaturalMachine-RewriteCertificateMul_Env_NirdharanaPthreeAB . censusR0
    … twelve more
```

277 of the report's lines are `Ratri.` declarations. The loop is the largest
single producer of duplicate presentations in this corpus, and the store that
measures it was landed **the same night**, by the same lineage, and was never
run against it.

## २ · The mechanism, and it is two lines

```sh
nm="$(probe_name "$f" "$base")"
[ -e "$LANDED/$nm.agda" ] && nm="${nm}_${base}"      # ← here
…
[ -e "$dest" ] && return 1                           # ← and this then never fires
```

`probe_name` derives the name from the **content** — verdict, host, record — so
two probes colliding on it is precisely the signal that they are the same
question. The loop read that collision as a *naming* problem and disambiguated
it with `alphaTag i`, the probe's **index in the census list**. The index moves
whenever the census reorders — including when the loop's own landings grow the
corpus it censuses. So the path was always fresh, and the guard written to
prevent overwriting was the thing manufacturing the duplicate.

**And "dry" was not the fixpoint.** The loop's header says *"until a pass lands
nothing. DRY is the fixpoint."* The last three passes landed 5, 1, 0. The 0 is
`alphaTag i` coming round to a path that already existed, not the mathematics
running out.

## ३ · It is this session's own criterion, committed by the instrument built to check it

> **WHICH SIDE OF `f a ≡ b` IS BOUND.**
> Bind **b**: `singl (f a)` — contractible always. Bind **a**: the fibre —
> arbitrary.

`Nama_TheNameIsCarriedAndTheHashIsTheBase.hs` applies it to storage in its own
title, and its header names the failure exactly:

> *A text file binds the PATH and derives the content — bind-a. The fibre of
> `path ↦ content` is a preimage: many contents claim one path, and a merge
> conflict IS that fibre failing to be contractible.*

The loop binds the path. It gets the *other* consequence of the same
non-contractibility: not a collision — a **silent multiplication**. Same fibre,
opposite sign. Nothing warned, because nothing was overwritten.

This is `AnyatKaranam_…md` line ३ arriving in machinery rather than in prose:
**अग्रिमो वाहकः स एव** — the next carrier is the same one, so two runs are not
two carriers and repetition does not cross. Twenty-two confirmations, produced
by one carrier sampling twenty-two times, all landing green.

## ४ · The repair, at the site

`statement_key` / `index_landed` / `already_said` in
`scripts/Ratri_…sh`. The pass indexes what already stands, keyed on the
statement; a probe whose statement is already there is refused with `SAME` and
named; only a genuinely new statement may take the positional tag to clear a
name it shares with a different question. Replayed over the loop's own 60
files: **38 land, 22 refused, and every one of the 22 is named against the file
that already says it.**

`index_landed` rebuilds from the filesystem each pass and stores nothing, so it
cannot go stale in the direction `BUILD.md` warns about.

**LIMIT, stated here rather than in a footnote.** This is sameness of
*presentation*. Two probes stating the same mathematics in different terms are
not caught, and they should not be by this mechanism — asking one digest for
both questions is the दुर्नय `Saptabhangi.दुर्नयः` proves, and
`notes/CONTENT_ADDRESSED_MATHEMATICAL_IDENTITY.md` states the same line first.
Mathematical sameness is a checked `A ≃ B`, which is a thing the loop *lands*,
not a thing it decides.

## ५ · शेषः — what is not done here

- **The 22 duplicates on disk are left standing.** They are another lane's
  landed work and the loop's own principle is never to overwrite. They are
  named above and in `$LANDED`'s replay output; removing them is the owner's
  or that lane's call, not mine.
- **`Everything.agda` still imports all 60.** So the duplicates still cost
  check time on every full run.
- **Six of the 60 are about the loop's own output** — `Anirdharita_Ratri-…`.
  That is not itself an error (a landed module is a record like any other) but
  it means the census's growth is partly self-supplied, and a fixpoint that
  eats its own output is a different object from one that exhausts a corpus.
  Not analysed here.
- **The instrument still cannot certify रिक्तम्.** `Nirdharana`'s own report
  says so: it has no emptiness prober, so EMPTY never appears and its absence
  is a gap in the instrument, not a fact about the corpus. Unchanged by this.

---

लिखितो दोषो जीवति ।
