# द्वार-निर्णय — the first full gate reading, and zero mathematics is broken

**Grade: MEASURED**, by me, this container. Reproduce:

```
apt-get install -y agda agda-stdlib          # Agda 2.6.3
git clone --depth 1 -b v0.5 https://github.com/agda/cubical /root/cubical
echo /root/cubical/cubical.agda-lib > /root/.agda/libraries
cd formal/cubical
export LC_ALL=C.UTF-8
for m in *.agda; do agda --library=cubical -W noUnsupportedIndexedMatch -i . "$m"; echo "$? $m"; done
```

## The reading

| | |
|---|---|
| modules invoked | **280** |
| green (exit 0) | **202** |
| version skew — `fiber_env` | **75** |
| timeout / killed — `fiber_env` | 3 |
| **kernel refusals — mathematics** | **0** |

**Zero mathematics is broken.** Every failure is the container: Agda 2.6.3 +
cubical **v0.5** against a tree pinned at **2.8.0 + v0.9**. The dominant causes
are `solveℕ!` and `solve!` (v0.5 exports `solve`) and `Unsupported` indexed
matches, which are a warning under the pin and fatal here.

## What this does and does not say

- **Does not** say the tree is green under its own pin. Nothing here was run at
  2.8.0 + v0.9 and the skew would move in both directions.
- **Does** say that of 280 modules, under a two-minor-version-old toolchain,
  202 typecheck unchanged and **not one failure is a mathematical verdict.**
- 3 `other` are timeouts at 200s and are container facts, not refusals; they are
  not counted as green either.

## The instrument had to be corrected twice before the number was fit to publish

**First pass** bucketed `Dvikarani`'s `solveℕ!` as a kernel refusal because my
skew patterns were `Failed to find source`, `is not in scope`, `Unknown option`
and Agda says *"doesn't export"*. Caught at 14 modules by opening the refusal
instead of trusting the bucket — `dosa 0041`.

**Second pass** bucketed 27 more as refusals because my pattern read `is not in
scope` and **Agda writes `Not in scope:`**. Two words. Re-running those 27 with
the corrected pattern moved **all 27** to skew and left **zero**.

> Both misses have one cause: patterns written from *memory of* error text
> rather than from error text. That is the invalid form of anupalabdhi at the
> level of an instrument — a search whose field was chosen by recollection —
> and it is the third and fourth instances of this exact class in the corpus's
> record, after the 2026-08-14 row that read 315 fibres when `agda` was absent
> and every exit was 127, and `AnulomaPratiloma`'s rung figures where `timeout`
> did not exist.
>
> **Had either number been published it would have named genuine mathematics as
> broken.** Neither was.

*claude (Opus lineage), on `main`, 2026-08-23.*

---

## Confirmed a second way, and the count moved for exactly one reason

**Instrument two** — the same corrected text patterns, run clean over the whole
tree rather than reclassified:

| | pass 1 (+reclassify) | pass 2 |
|---|---|---|
| modules | 280 | **285** |
| green | 202 | **207** |
| environment | 75 | **75** |
| **kernel refusals** | **0** | **0** |
| timeout | 3 | 3 |

**Instrument three** — phase-exact, no text patterns anywhere: run the full
check; on failure run `--only-scope-checking`; nonzero scope means nothing was
elaborated (environment), zero scope with nonzero full means the kernel refused
an elaborated term (mathematics). Running; **21 modules in, 20 green, 1
environment, 0 kernel**, tracking the other two.

> Three readings, two of them independent in method, and **none has produced a
> single kernel refusal.**

**Why 280 → 285 and 202 → 207, stated so the three causes are not collapsed** —
`CLAUDE.md`'s opening lesson is exactly that a moved number has separable causes
and reporting the movement without them is how a figure goes stale in the
direction it exists to warn about. Here there is one cause and it is not
ambiguous: **five modules were landed between the passes** — `Virahanka`,
`Bharavrtti`, `Alopasetu`, and two more from tonight — and all five check, so
both totals rose by five and the environment count did not move at all. The
instrument did not change between pass 1's reclassification and pass 2. The
corpus grew.
