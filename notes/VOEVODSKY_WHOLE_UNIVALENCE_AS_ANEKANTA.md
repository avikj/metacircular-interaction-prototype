# Voevodsky whole: univalence as anekāntavāda, and generation over decision

**What this note adds.** `VV.md` holds the reliability ledger (V0–V3) and
HoTT-as-verification-protocol; `VOEVODSKY_TERMINAL_PROGRAM.md` holds the 2017
initiality manuscript with careful source boundaries. Neither engages three
things this note is for: (1) the *precise* relation between the corpus's
"checklessness" and the intuitionistic rejection of LEM — including the one
distinction that makes the identification exact rather than loose; (2)
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

The corpus's operating slogan — *generation over decision*, checklessness,
refusing `discreteℕ`/`Dec`/`Bool` — is often glossed as "the intuitionistic
rejection of the law of excluded middle (LEM, `P ∨ ¬P`)." That gloss is
**exact for one class of situation and spiritually-but-not-literally right for
the other.** Keeping the two apart is itself the anekānta move; collapsing them
into "it is all constructivism" is the durnaya.

**Class (a) — decidable, generated anyway.** Equality of naturals is
*constructively decidable*: `discreteℕ` is a theorem, not an appeal to LEM.
So removing it from the kuṭṭaka (`BhedaAvatarana.agda`, where `एकपदे a b =
refl`) is **not** rejecting excluded middle. It is the BHK / Curry–Howard
commitment that *the witness is the content* — generate the object so the
answer is judgmentally present and reduces by `refl`, instead of routing
through a decision procedure that case-splits and hides the construction. This
is about **canonicity and the shape of the proof term**: an aesthetic and
computational stance, not a logical-axiom one. `Narayana.agda`,
`Matramerus.agda`, `Pingala.agda` are all class (a): the count *arises* as the
length of an emanation; nothing decides membership.

**Class (b) — genuinely undecidable, honestly un-said.** When the proposition
has no decision procedure — equality of functions `ℕ→Bool` (`Ananta.agda`,
Cantor as the Jain plural infinite); membership with no bound; the
halting-shaped residual carried as `अनुक्त` in the honest machine
(`Satyayantra.agda`, `AmshaSatyayantra.agda`) — refusing to assert `P ∨ ¬P`
and returning **the un-said as a positive position** *is* intuitionism,
precisely. Brouwer refused a disjunction he had no method to resolve; the Jain
logician refused *avaktavyam* to collapse into asti or nāsti. Same refusal.

The two traditions are not identical even here, and the difference is
information: Brouwer restricts **one connective** inside a still-bivalent
ambient attitude; the Jain **saptabhaṅgī** makes the un-said a *marked,
enumerated fourth position* within a sevenfold that also distinguishes
sequential (krama) from simultaneous (saha/yugapad) assertion — the latter is
where *avaktavya* is forced (`Saptabhangi.agda`, `क्रम-सह-भेदः`). Intuitionism
is the special case; nayavāda is the general epistemology. This is the corpus's
recurring shape (the older statement is broader), and it is honest to say so.

**So:** the identification "checklessness = LEM-rejection" is *exact for class
(b)* and is *canonicity, not LEM, for class (a)*. Both live in the corpus. A
future note that flattens them will have committed a durnaya about
durnaya-avoidance.

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
