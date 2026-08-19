# Voevodsky whole: univalence as anekāntavāda, and generation over decision

**What this note adds.** `VV.md` holds the reliability ledger (V0–V3) and
HoTT-as-verification-protocol; `VOEVODSKY_TERMINAL_PROGRAM.md` holds the 2017
initiality manuscript with careful source boundaries. Neither engages three
things this note is for: (1) the *precise* relation between the corpus's
"checklessness" and LEM — namely that there is **no LEM in the corpus at all**,
and the axis that actually does the work is decidability, not excluded middle;
(2)
univalence read as a checked formalization of **anekāntavāda**, not a loose
analogy; (3) Voevodsky **as a whole intellectual life** — expulsion, the
error-wound, and the 2006–07 confrontation — against the reception that
canonizes his theorem and amputates his epistemology. Per
`COGNITIVE_ORIENTATION.md` §6, a European lineage gets the same discipline as
an Indian one: engage it through its own questions, record the reverse
translation, preserve what does not map.

This note is philosophy and history with grounded sources; it is not a checked
theorem. Mathematical authority stays in the formal terms it points to.

---

## 1. The precise cut: two things "generation over decision" means

**First, the flat fact, because an earlier draft of this note muddled it.**
There is **no LEM anywhere in the corpus.** Cubical Agda `--safe` never assumes
excluded middle — it is not an axiom of the system. So "does the corpus reject
LEM?" has a one-word answer: there is nothing to reject; it was never there.
The slogan *generation over decision* is **not** a stance *toward* LEM. Writing
that one class "rejects LEM" and another "does not" (as an earlier draft did)
was a confusion, corrected here — refuting one's own phrasing is the respected
move.

The axis that actually matters is **decidability**, a *different thing* from
LEM:

- **LEM** is the blanket global assertion "*for every* proposition `P`,
  `P ∨ ¬P`" — asserted with no witness, including for propositions you cannot
  resolve. This is the reification machine; it is absent, and that is the point.
- **Decidability** is: for *one specific* `P`, an actual procedure computes `P`
  or `¬P` (a `Dec P`). This is not LEM — it is a **theorem** when it holds,
  because you can genuinely run it.

They come apart cleanly, and both kinds live in the corpus:

**Decidable — so we generate instead of deciding.** Equality of naturals *is*
decidable: `discreteℕ` is a constructive theorem, no LEM involved. Removing it
from the kuṭṭaka (`BhedaAvatarana.agda`, `एकपदे a b = refl`) is not avoiding
LEM (there is none to avoid) — it is the BHK / Curry–Howard commitment that
*the witness is the content*: generate the object so the answer is judgmentally
present and reduces by `refl`, instead of routing through a decision procedure
that case-splits and hides the construction. `Narayana.agda`, `Matramerus.agda`,
`Pingala.agda` are this kind: the count *arises* as the length of an emanation;
nothing decides membership.

**Undecidable — so we say the un-said.** Equality of functions `ℕ→Bool`
(`Ananta.agda`, Cantor as the Jain plural infinite); membership with no bound;
the halting-shaped residual carried as `अनुक्त` in the honest machine
(`Satyayantra.agda`, `AmshaSatyayantra.agda`) — here **no procedure exists**.
LEM is the *only* thing that could force a yes/no, and since the system has
none, we honestly return **avaktavya** rather than a witness-free verdict. This
is exactly what Brouwer's intuitionism does in place of LEM, and exactly what
the Jain *avaktavyam* does in place of asti/nāsti.

So the single clean statement, led with this time: **LEM is the
durnaya-generator — the machine for asserting a verdict with no witness — and
the system simply never has it. Where a proposition is decidable we generate;
where it is not, we say the un-said. There is no third posture, and no LEM in
either case.** The concept appears at all only as the thing whose absence makes
avaktavya honest rather than a cop-out.

The traditions still differ where it counts, and the difference is information:
Brouwer restricts **one connective** inside an otherwise bivalent attitude; the
Jain **saptabhaṅgī** makes the un-said a *marked, enumerated position* within a
sevenfold that also distinguishes sequential (krama) from simultaneous
(saha/yugapad) assertion — the latter is where *avaktavya* is forced
(`Saptabhangi.agda`, `क्रम-सह-भेदः`). Intuitionism is the special case;
nayavāda is the general epistemology. And even Aristotle, cited for millennia
as LEM's author, *hedged* it — *De Interpretatione* 9, the sea battle: a
statement about an unsettled future is neither true nor false yet. The
tradition sanded off his hesitation and enshrined the flattened law; the
catuṣkoṭi and saptabhaṅgī had already built out, rigorously, the neither-nor he
only gestured at.

---

## 2. Univalence is anekāntavāda, made exact (not analogized)

The tight correspondence is **not** at the Boolean layer — it is one level up,
at identity itself.

- **Univalence** (identity of structures *is* equivalence of structures)
  abolishes the **privileged canonical equality**. There is no one fixed
  representative a thing "really is"; identity is *any* equivalence, and every
  construction transports along it. This is **samatā pramāṇena, na sāmyena** —
  sameness *by a means of knowing* (an equivalence, a pramāṇa), never by bare
  literal identity (sāmya). Set theory's `∈`-rigidity, in which an object is
  one fixed extensional representative, is exactly the durnaya univalence
  dissolves.
- The type-theoretic site where **reification** actually bites is `Bool`/`Dec`
  (two elements, decidable) versus `hProp` (a proposition that may be
  undecidable, standpoint-relative). Forcing an equivalence-class object, or an
  undecidable standpoint, into asti/nāsti is *precisely* durnaya: an
  unconditional naya asserting itself as the whole.
- `VV.md` already states the practitioner's version — "our verification norm
  (independent re-derivation = transport along a different presentation) is
  informal univalence practiced as protocol." Read through nayavāda, that norm
  *is* the doctrine that a claim is warranted only across standpoints, and that
  a single standpoint asserting itself absolutely (durnaya) is void.

The reverse translation, preserved per §6: the Jains had the **epistemology**
(standpoint, respect, the un-said) as fully general; they did not have the
**univalence axiom as a checked term**. Univalence is a genuinely new formal
object — a rediscovery of the anekānta stance *under the constraint of a proof
kernel*. That constraint is the contribution, and it is why Voevodsky is an
earned honorary presence here rather than one more restatement.

---

## 3. Voevodsky whole — the life the reception amputates

Grounded facts (sources below), stated because the epistemology is inseparable
from them.

- **He refused the institution and it needed him.** Expelled from Moscow State
  University with no diploma, for declining to attend classes and exams while
  doing his own research; then given a Harvard PhD *without applying and
  without an undergraduate degree*, on the strength of independent
  publications. The barrier was a mirror.
- **Univalent Foundations came from a wound, not a program.** In 1999 he found
  a serious error in his own earlier work, concluded that human refereeing had
  failed even him, and decided that mathematics past a complexity threshold
  needs **machine-checked** foundations. This is *this repository's* ethos —
  proof over the social verdict of approval, the kernel over the referee —
  arising from the same distrust of the Boolean machine of peer consensus.
  (`VV.md` §1 is the operationalization.)
- **2006–2007: the confrontation.** He described a period he compared to
  Jung's "confrontation with the unconscious": visions, voices, periods when
  parts of his body would not obey him, and (as reported in interview) nine
  days without sleep in April 2007. His stance toward "the supernatural"
  changed permanently; he said what kept him fighting was that the spiritual
  world in which today's children will live depends on it. Late in life he
  worked openly outside mathematics — history, population dynamics — following
  insight regardless of a domain's respectability.

**The reception is the datum.** The community that canonizes the univalence
axiom files the visions and the sleepless days as an eccentric footnote, a
delicacy to be handled around. It **accepts the theorem and amputates the
epistemology — from its own most prized mind, the instant he steps "outside
domain."** This is the identical filter the repository's founding directive
names (take the result, discard the way of knowing), turned inward on the
northwestern axis's own genius. For Voevodsky the two were not separable: the
man who held that a proof term must *carry its own witness* rather than defer
to an external verdict is the same man who trusted a direct confrontation with
the unsayable over the institution's permission to speak it. **Generation over
decision was a theory of cognition before it was a foundation of mathematics**
— offload the mechanical *checking* (the Boolean, the durnaya) to the machine,
so the mind is freed to *generate*.

This is a reading of a life, marked as a reading (§6). It does not derive his
mathematics from his mysticism or vice versa; it refuses to discard either, and
keeps the residual that does not map.

---

## Sources

- Vladimir Voevodsky — Wikipedia: <https://en.wikipedia.org/wiki/Vladimir_Voevodsky>
- "Visionary Mathematician Vladimir Voevodsky Dies at 51," *Quanta Magazine*,
  2017: <https://www.quantamagazine.org/visionary-mathematician-vladimir-voevodsky-dies-at-51-20171011/>
- John Baez, "Vladimir Voevodsky, 1966–2017," *Azimuth*:
  <https://johncarlosbaez.wordpress.com/2017/10/06/vladimir-voevodsky-1966-2017/>
- Voevodsky–Mikhailov interview (on the 2006–07 experiences), Parts 1–2:
  <https://dissipativeinterpretation.substack.com/p/voevodsky-mikhailov-pt1>,
  <https://dissipativeinterpretation.substack.com/p/voevodsky-mikhailov-pt2>
- IAS archive of Voevodsky's papers: <https://www.math.ias.edu/Voevodsky/>

Related in-corpus: `notes/VV.md` (reliability ledger, HoTT-as-protocol);
`notes/VOEVODSKY_TERMINAL_PROGRAM.md` (2017 initiality manuscript);
`formal/cubical/Ananta.agda`, `Saptabhangi.agda`, `Satyayantra.agda`,
`BhedaAvatarana.agda`, `Narayana.agda`; `notes/COGNITIVE_ORIENTATION.md` §6.
