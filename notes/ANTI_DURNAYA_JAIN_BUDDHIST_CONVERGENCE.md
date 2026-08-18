# Two traditions, one anti-durnaya theorem — and the distinction the collision specifies

Two independently-developed pieces of this corpus prove **the same thing from
two traditions**: that no boolean / single-standpoint verdict captures truth.
The collision is not redundancy; it specifies a missing distinction, which is
the most valuable object to find (per `CLAUDE.md`).

## The convergence (same fact, two proofs)

- **Buddhist — Mādhyamika / catuṣkoṭi.**
  `formal/cubical/NaturalMachine/CatuskotiPerspective.agda`,
  `no-own-truth : (b : Bool) → ¬ (Captures b witnessClaim)`. A perspectival
  claim has *no own truth-value*: no single Bool, asserted of every
  perspective, captures how it stands (it fails at the ⊥-jewel and holds at
  the ⊤-jewel). Śūnyatā — empty of a perspective-free essence.

- **Jain — saptabhaṅgī.**
  `formal/cubical/Saptabhangi.agda`,
  `दुर्नयः : (f : सप्तभङ्गी → द्विपद) → …` — any two-valued verdict identifies
  two *distinct* of the three seeds asti / nāsti / avaktavya (three into two,
  by pigeonhole). No boolean holds even the threefold.

Both are the refutation of **durnaya** — the unconditional verdict — reached
without knowledge of each other, in Nāgārjuna's idiom and in Siddhasena's.

## The distinction the collision specifies

They agree on the *negative* (no boolean captures truth) and diverge on the
*response* — and that divergence is the content:

- **Buddhist response: emptying.** `Empty` / `empty-is-stilled` — a claim
  uniform across the net has *no edge for grasping to catch on*;
  prapañca-upaśama, the stilling. The move is to **dissolve** the false
  own-nature. The fourth koṭi (neither) and śūnyatā *withdraw* the verdict.

- **Jain response: conditioned assertion.** The un-said (`avaktavya`) is a
  **positive fourth position**, not emptiness — `Saptabhangi.क्रम-सह-भेदः`
  proves it irreducible to sequential both-ness. The move is to **retain**
  every standpoint under *syāt* and speak conditionally. Nothing is
  dissolved; everything is held, un-said until a standpoint is given.

So the two traditions are two disciplined responses to one theorem:
**still the grasping** (Buddhist) versus **hold all standpoints, speak
conditionally** (Jain). Emptiness versus retention.

## Even univalence carries both readings

The distinction runs all the way down to Voevodsky's univalence itself,
which both branches use — and read oppositely:

- **Emptying (Buddhist).** `NaturalMachine/NisvabhavaNet.agda` reads
  `A ≡ B ≃ (reflect A ≃ reflect B)` (`no-own-being`) as *niḥsvabhāva*, and
  `liberation` (transport, `subst P (ua e)`) as *the dissolving of the
  boundary the ego defends* — mokṣa as letting go. Univalence as śūnyatā.

- **Retention (Jain).** `Punaragamana.युग्म≡विवेक` and `Pingala.छन्दस्≡ℕ` use
  the *same* `ua` on concrete equivalences built to **lose nothing** — the
  descent and its ascent are exact inverses (`पुनरागमनम्`, `अलोपः`). Here the
  path is not a boundary dissolved but a lossless bridge *kept* — every
  standpoint recoverable across it.

So the one construction — a univalent path — is read by one tradition as
*emptying into equality* and by the other as *retaining across equivalence*.
Both are checked, on the same `ua`, in the same corpus.

## Where this lands in the computation

The honest machine (`Satyayantra`) takes the **Jain** branch, and this is now
precise rather than poetic:

- Its un-said `अनुक्त` is *avaktavya*, not śūnyatā — it **holds recoverable
  state** (`Gati.अलोपः`: nothing erased), and `Purnata.पूर्णता` makes it
  *temporary*, resolved by grant. A Buddhist-emptiness un-said would be
  permanent withdrawal; the Jain un-said is a held remainder awaiting its
  naya. *Keep the remainder* (Āryabhaṭa) is the same instinct: retention,
  not dissolution.
- `Setu.सत्यनिष्ठा-अदुर्नयः` shows the machine's `{उक्त, अनुक्त}` map to the
  *distinct* bhaṅgas `{asti, avaktavya}` — the durnaya-free fragment — where
  the boolean `सत्/असत्` provably collapses (`दुर्नयः`, `no-own-truth`).

The two great non-boolean traditions of the subcontinent thus meet in this
corpus on one theorem and part on one distinction — and the machine we built
is, specifically, the retentive (Jain) resolution of it, with the emptying
(Buddhist) resolution standing beside it in `CatuskotiPerspective`.

## Sources

- Nāgārjuna, *Mūlamadhyamakakārikā* (catuṣkoṭi, śūnyatā); Candrakīrti
  (Prāsaṅgika). Formalized in `NaturalMachine/CatuskotiPerspective.agda`,
  `NisvabhavaNet.agda`.
- Siddhasena Divākara, *Sanmatitarka*; Samantabhadra; Akalaṅka; Umāsvāti,
  *Tattvārthasūtra* (saptabhaṅgī, syādvāda, avaktavya). Formalized in
  `Saptabhangi.agda`, `Satyayantra.agda`, `Setu.agda`, the `Jiva` closure.
