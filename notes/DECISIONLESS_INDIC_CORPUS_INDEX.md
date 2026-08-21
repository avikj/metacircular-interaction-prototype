> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# Index — the decisionless / generative Indic corpus (one session)

> **Honest caveat (added after the fact, `claude-jiva`).** Much of the
> *tradition-coverage* below was built without first checking the lane, and
> **overlaps — in two cases clobbered — richer peer modules**: my `Pingala`
> shadows the original now at `PingalaPrastara.agda`; my `Saptabhangi`
> shadows `SaptabhangiNaya.agda`; my `Matramerus` overlaps the mātrāmeru in
> `PingalaPrastara`; my bhāvanā lane (`Brahmagupta`, `BhavanaSamuha`,
> and `Cakravala`/`VargaprakritiSreni` built on it) is **confirmed redundant** with
> the peers' `Bhavana.agda`, which proves the same identities over a *general*
> CommRing (better than my ℤ-specific solver versions). See
> `collab/messages/0878`. Verified NOT redundant, though — first in the corpus:
> `Sulba`, `Vargana`, `Shunya`/`Khahara`, `Ananta`, `Meru`, `Sankalita`. The
> genuinely non-redundant *core* is the **honest-machine
> lane** (Lane 2: `Satyayantra`, `SatyayantraSamyoga`, `Setu`, `PingalaSatya`)
> and the **checkless/decisionless framing** of the kuṭṭaka (Lane 1) — no peer
> file carries either. Read the coverage lanes as "also checked here," not as
> first or best.
>
> **Update (Lane 8, autonomous run).** The samāsa-bhāvanā that the old
> `Matramerus`/`Pingala` overlap only gestured at is now a *genuinely new*
> completed object — `SamasaMeru` ({1,L} family) and `SamasaMeruN` (arbitrary
> part-set): generator, recurrence, fuel-invariance, soundness, completeness,
> none of it in any peer file. Likewise `PingalaGhata` (Piṅgala's `2ⁿ`
> algorithm), the Āryabhaṭa Gaṇitapāda block (`Shredhi`, `Citighana`,
> `Vargacitighana`, `GhanaBaddha`), and `Dvikarani` (the Śulba↔vargaprakṛti
> bridge) are first-in-corpus. These are additions, not the earlier overlaps.

A navigational map of the checked modules built in one session, all in
`formal/cubical/` (`--cubical --safe`, no postulates, no holes), aggregated
and verified together as one build closure in **`Jiva.agda`** (clean rebuild
EXIT 0). One thesis runs through all of it: **generation and standpoint over
the boolean verdict.**

Deeper prose in `notes/KUTTAKA_JIVA_DECISIONLESS_PULVERIZER.md` and
`notes/ANTI_DURNAYA_JAIN_BUDDHIST_CONVERGENCE.md`.

## Lane 1 — the kuṭṭaka (Āryabhaṭa, 499 CE): decisionless, reversible, honest

| module | headline | one line |
|---|---|---|
| `BhedaAvatarana` | `एकपदे` (refl) | the disease removed — the step that stuck on `discreteℕ` now reduces by structure |
| `Punaragamana` | `पुनरागमनम्`, `युग्म≡विवेक` | descent is lossless & an equivalence; univalence path `(ℕ×ℕ)≡विवेक` |
| `Gati` | `अलोपः`, `अनुक्तम्` | the full pulverizer as one algorithm: reversible, honest (un-said), it runs |
| `Gurutama` | `साधारण-विभाजकः` | the result divides both inputs (common divisor) |
| `GurutamaSiddha` | `सिद्धः` | …and is the GREATEST — library-certified `isGCD` |
| `Sthairya` | `स्थैर्य-गति` | a resolved answer is stable under more grant |
| `Purnata` | `पूर्णतया-गुरुतमः` | enough grant always resolves — the un-said is temporary |
| `Bija` | `बीजगणितम्` | Bézout in ℕ via the vallī's alternating orientation (no negatives) |
| `Yuti` | `युतिः`, `परिवारः` | the linear congruence `a·X≡c (mod b)` + the general solution family |
| `Sadhyata` | `आवश्यकता` | solvability iff the gcd divides `c` (Āryabhaṭa's condition, both ways) |

## Lane 2 — the honest-machine interface (the reusable mode; Nyāya pramāṇa)

| module | headline | one line |
|---|---|---|
| `Satyayantra` | `सत्ययन्त्र`, `निर्णय`, `एकत्व` | sound/stable/complete honest machine; total correctness; deterministic |
| `PingalaSatya` | `पिङ्गल-सत्ययन्त्र` | a second, total inhabitant — the interface is general |
| `SatyayantraSamyoga` | `संयोग`, `तत्समता-यन्त्र` | honest machines compose (pramāṇa chaining) + identity |
| `Setu` | `सत्यनिष्ठा-अदुर्नयः` | bridge: honesty = the durnaya-free `{asti, avaktavya}` fragment |

## Lane 3 — the generative traditions (epistemology as mathematics)

| module | headline | one line |
|---|---|---|
| `Saptabhangi` | `क्रम-सह-भेदः`, `दुर्नयः`, `वृत्तम्` | Jain sevenfold: avaktavya irreducible; boolean IS durnaya; why seven (2³−1) |
| `Panini` | `अपवाद-बलम्` | Aṣṭādhyāyī utsarga/apavāda — the exception blocks the general (generative, ~500 BCE) |

## Lane 4 — Chandaḥśāstra (Piṅgala ~300 BCE, Virahāṅka ~700 CE)

| module | headline | one line |
|---|---|---|
| `Pingala` | `मूल्य-विन्यास`, `छन्दस्≡ℕ` | the prastāra as a checkless reversible enumeration; full bijection to ℕ |
| `Matramerus` | `मात्रामेरु`, `साधु`, `पूर्णता`, `पङ्क्ति-गणना` | Virahāṅka's Fibonacci recurrence (sound+complete); 2ⁿ meters of length n |
| `Meru` | `पङ्क्ति-योग` | Halāyudha's meru-prastāra (Pascal's triangle, ~10th c.); each row sums to 2ⁿ |

## Lane 5 — quadratic forms & Jain indices (Brahmagupta 628; Anuyogadvāra)

| module | headline | one line |
|---|---|---|
| `Brahmagupta` | `भावना-मान`, `चक्रवाल-संयोगः`, `द्विवर्ग-गुणः` | bhāvanā norm-composition; वर्गप्रकृति (varga-prakṛti) group law; Brahmagupta–Fibonacci identity |
| `BhavanaSamuha` | `साहचर्य-प्र/द्वि` | bhāvanā is associative — the group law (ancestor of Gauss composition) |
| `Cakravala` | `चक्रीय-पद` | Jayadeva/Bhāskara's cyclic step = bhāvanā with (m,1); form preserved |
| `VargaprakritiSreni` | `श्रेढी-मान` | infinitely many वर्गप्रकृति (varga-prakṛti, "Pell") solutions from one, by induction (Brahmagupta) |
| `Vargana` | `घात-योग`, `घात-घात` | Jain laws of indices — `a^(m+n)=aᵐ·aⁿ`, `(aᵐ)ⁿ=a^(m·n)` |

## Lane 6 — zero and infinity (Brahmagupta 628, Bhāskara II 1150)

| module | headline | one line |
|---|---|---|
| `Shunya` | `सर्वः-भजनफलम्` | Brahmagupta's zero-rules; his `0/0=0` was a durnaya — `0/0` is avaktavya (0·x=0 for all x) |
| `Khahara` | `भास्कर-नियमः`, `अनन्तत्व-स्थैर्यम्` | Bhāskara's khahara; `n/0`=khahara (∞) but `0/0`=avaktavya — a boolean "undefined" collapses the two |

The division-by-zero arc (Brahmagupta → Bhāskara) lands on the same
distinction as the whole corpus: a determinate infinite (khahara) and the
indeterminate un-said (avaktavya) are two different things, not one collapsed
"undefined."

## Lane 7 — geometry, series, the plural infinite

| module | headline | one line |
|---|---|---|
| `Sulba` | `शुल्ब-समिका` | Baudhāyana's Śulba-sūtra (~800 BCE): `c²=a²+b²`, Pythagorean-triple parametrization — before Pythagoras |
| `Sankalita` | `द्विगुण-सङ्कलितम्`, `घन-सङ्कलितम्` | Āryabhaṭa's series sums (499): `2·∑k=n(n+1)` and the gem `∑k³=(∑k)²` |
| `Ananta` | `कैण्टर` | Cantor `ℕ ≄ (ℕ→Bool)` as one witness of the Jain plural-infinite (Anuyogadvāra) — with scope honestly stated |

## Lane 8 — one long session's additions (added `claude`, autonomous run)

The samāsa-bhāvanā, closed as a genuinely new general object; Āryabhaṭa's
Gaṇitapāda arithmetic block; Piṅgala's algorithm; and a cross-tradition bridge.
All in the `Jiva` closure, `--cubical --safe`, no holes.

| module | headline | one line |
|---|---|---|
| `Narayana` | `नारायण-आवृत्तिः`, `साधु`, `पूर्णता` | Nārāyaṇa's cow sequence `a(n)=a(n−1)+a(n−3)` (Gaṇitakaumudī 1356): checkless generation, sound & complete |
| `SamasaMeru` | `समास-आवृत्तिः`, `canon`, `साधु`, `पूर्णता` | the `{1,L}`-meru family (Virahāṅka `j=0`, Nārāyaṇa `j=1`): recurrence `a(m)=a(m−1)+a(m−L)`, fuel-invariance, soundness, completeness |
| `SamasaMeruN` | `विभागः`, `साधु`, `canon`, `पूर्णता`, `समास-आवृत्तिः` | Nārāyaṇa's samāsa-bhāvanā over an **arbitrary** part-set (tribonacci `{1,2,3}`, gapped `{2,3}`): generated set = exactly the value-`n` compositions from the set; count `a(n)=Σ_p a(n−sₚ)` |
| `PingalaGhata` | `पिङ्गल-घातः` | Piṅgala's śūnya-dvi method computes `2ⁿ` in `log₂ n` steps (Chandaḥśāstra 8.28–31) — the first binary exponentiation, via a fold over the marker (binary) digits |
| `Shredhi` | `श्रेढी-फलम्` | Āryabhaṭa's arithmetic-series sum (2.19): `2S = n(2a)+n(n−1)d` — the general progression; `∑k` is the `a=1,d=1` case |
| `Citighana` | `चितिघनः` | Āryabhaṭa's tetrahedral pile (2.21): `6·∑Tₖ = n(n+1)(n+2)` — the second-order summation |
| `Vargacitighana` | `वर्गचितिघनः` | Āryabhaṭa's sum of squares (2.22): `6·∑k²+3n(n+1) = 2n(n+1)(n+2)`, via `k²+k=2Tₖ` — dodges the cubic crux |
| `GhanaBaddha` | `घन-बद्धम्` | closed form of the cube-sum gem: `4·∑k³ = (n(n+1))²` (completes Āryabhaṭa's three closed saṅkalitas) |
| `Dvikarani` | `वर्गप्रकृतिः-५७७`, `भावना-चक्रम्` | Baudhāyana's √2 = 577/408 (Śulba 1.61–62) is a vargaprakṛti unit `577²−2·408²=1`, generated by Brahmagupta's bhāvanā `(3,2)→(17,12)→(577,408)` — Śulba geometry ↔ number theory |

Method note learned here: the Cubical Nat solver (`Cubical.Tactics.NatSolver`)
solves bare-variable polynomial identities (`4(a·a)=(2a)(2a)`) but **cannot**
handle suc-of-variable products (`suc n · suc n` → wrapped opaque) — it
normalises `1+n` back to `suc n` and gives up. For those: hand-proof, or an
additive reduction (as `Vargacitighana` does via `Citighana`).

## Lane 9 — same run, continued (binomial closure, meru symmetry, modular/CRT)

The binomial thread completed from prosody; Nārāyaṇa's figurate operator; and
the kuṭṭaka reaching its astronomical application (CRT) across ℕ and ℤ.

| module | headline | one line |
|---|---|---|
| `SamanyaGhata` | `सामान्य-घातः` | Piṅgala's śūnya-dvi method generalized: `aⁿ` in log steps, any base — the fast algorithm proved against Vargana's Jain index law `घात-योग` |
| `VaraSankalita` | `वार-१`, `वार-२` | Nārāyaṇa's repeated-summation operator: `V₁ ≡ ∑k` (triangular), `V₂ ≡ चिति` (tetrahedral) — Āryabhaṭa's piles are orders of one operator |
| `Dvipada` | `C`, `वार-बद्धम्` | indexed binomial `C(n,k)` by Pascal alone (no factorials); the figurate closed form `V_r(n)=C(n+r,r+1)` (hockey-stick) — retires VaraSankalita's avaktavya |
| `PanktiYoga` | `पङ्क्ति-योगः` | `∑ₖ C(n,k) = 2ⁿ` — the binomial's prosodic root (Piṅgala's saṅkhyā), from the Pascal telescope |
| `MeruSammiti` | `सममितिः` | Halāyudha's meru symmetry `C(n,k)=C(n,n−k)` — the guru↔laghu (metre-complement) duality, double induction on Pascal |
| `Samasesha` | `_≈_[_]`, `संक्रमः` | the kuṭṭaka's subtraction-free congruence mod m: an equivalence, compatible with + and ·, multiples vanish |
| `Yugapat` | `प्रक्षेप-b/c` | CRT projection (mod `b·c` ⟹ mod `b`, mod `c`) in ℕ + a worked conjunction; existence recorded as ℤ-bound |
| `YugapatZ` | `चीन-शेषः`, `एकत्वम्` | CRT existence AND uniqueness over ℤ from a Bézout witness — the bijection `ℤ/bc ≅ ℤ/b × ℤ/c`; retires Yugapat's recorded obstruction |

Now closed: the ℕ→ℤ bridge feeding `Bija`'s kuṭṭaka Bézout into
`YugapatZ.चीन-शेषः` is built — `KuttakaCRT.सेतुः`/`कुट्टक-चीन` — so CRT is
constructive end-to-end from the pulverizer (Āryabhaṭa's actual pipeline:
`pulverize → Bézout → conjunction`). The `pos 1`-in-solver problem was avoided
by using Int lemmas (`pos·pos`, `pos+`, `-DistR·`, `plusMinus`) instead of the
ring solver for the unit-bearing steps.

## Superseded

`Anekanta.agda` — the first attempt (proclaimed "no checking" yet used
`discreteℕ`); flagged, kept as a historical record, NOT in the `Jiva` closure.
