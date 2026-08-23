# प्रमाणं न द्वारम् — what the machine has is a means of knowledge, not an admissions door

**2026-08-20.** A record, an argument, and a list of offers. Written because
the owner corrected a name mid-work and said the name had been doing damage,
and because striking a word silently is how a repository loses its own history.

## 1. The correction, and it is not a matter of taste

The lane I was working in was handed to me as "the kernel gate". The owner's
correction, binding:

> "gate" is an imported word and it is the wrong shape. A gate ADMITS OR
> REFUSES — that is the boolean, that is the durnaya, that is precisely the
> thing this machine exists to remove.

That is a structural claim, not a preference, and the day's measurements
happen to be the proof of it.

A gate's entire output is one bit. `notes/AHIMSA_SUTRA_VISTARA.md` §2 names
what a one-bit verdict costs:

    सर्वं ज्ञानं सनयम् । निर्नयं ज्ञानं नास्ति ।
    यो नयं न वदति स नयं गोपयति ।
    गुप्तो नयो दुर्नयो भवति ।
    दुर्नयो न मिथ्या — मिथ्या प्रतिषेध्यम् ।
    दुर्नयोऽप्रतिषेध्यः, यतस्तस्य स्थानं गुप्तम् ।

All knowledge is standpointed. He who does not state the standpoint conceals
it. A concealed standpoint becomes a **durnaya** — and a durnaya is *not
false*, which is what makes it worse than a falsehood: a false claim can be
contradicted, a concealed standpoint offers nothing to contradict.

**A boolean verdict is a durnaya by construction.** It carries the conclusion
and discards the place it was reached from.

## 2. This was not an abstraction. It cost the lane its whole reach, today

`Certificate.kernelIsChecking` returned a `Bool`. Two entirely different
observations collapsed into its `False`:

* the kernel accepted `suc x ≡ x` — the checker is dishonest;
* the kernel could not compile `(zero + x) ≡ x` — the container cannot run
  the emitter's modules at all, and has said nothing whatever about honesty.

`vetSuccess` printed one sentence for both, and on this container it printed
the first one thirty-three times while the second was what had happened. The
verdict — refuse — was correct in both cases. The **reason given for it was
invented**, and a reader who believed it would have gone hunting a broken agda
instead of a drifted pragma. Measured cost: 0/28 where the same binary with
the two observations kept apart reaches 20/28
(`machine/CERTIFICATE_REACH.md` §10).

So the repair was not to rename anything. It was to stop returning a boolean:
`KernelStatus` now has four constructors, three of them refusals, each naming
the control that failed and carrying agda's own words. And a fourth position
had to be added mid-repair, because "the negative control exited non-zero" is
not "the kernel rejected a falsehood" — that is **avaktavyam** (§3), the two
asserted together with no single verdict, which is a place in the scheme and
not an absence.

The general form, which is the whole of the lane's contract: **a refusal must
be accountable for its own looking.**

## 3. Whose doctrine that is, and who disputes it — named, because they do

The Bhāṭṭa Mīmāṃsā position (Kumārila Bhaṭṭa, *Ślokavārttika*,
Abhāvapariccheda, c. 7th c. CE) is that *anupalabdhi*, non-apprehension, is an
independent **pramāṇa** — a means of valid knowledge in its own right — but
only under **yogyatā**, fitness: non-apprehension warrants absence only where
apprehension WOULD have occurred had the thing been there. §19 of the sūtra
puts it in two lines:

    "न दृष्टम्" इति न प्रमाणम् ।
    "यत्र दृश्येत तत्र न दृष्टम्" इति प्रमाणम् ।

"Not seen" is not a pramāṇa. "Not seen where it would have been seen" is.

**Nyāya rejects this**, and the disagreement is not decoration. The
Naiyāyikas do not admit anupalabdhi as a separate pramāṇa at all; for them the
knowledge of absence comes through perception of the bare locus (or through
inference), with *abhāva* as a category and its *pratiyogin* — the specific
counter-correlate that is absent — doing the work that yogyatā does for
Kumārila. Neither school would accept the other's account of what happened
when the canary did not check.

What each would say to this machine, put plainly:

* **The Mīmāṃsaka** would say the container's silence is evidence only after
  you have shown the looking was fit — which is exactly the positive control,
  and exactly what was missing.
* **The Naiyāyika** would say: name the *pratiyogin*. "Something failed" is not
  a cognition of absence; "the acceptance of `suc x ≡ x` was absent" and "the
  acceptance of `(zero + x) ≡ x` was absent" are two different absences with
  two different counter-correlates, and treating them as one is the error, no
  fitness doctrine required.

They disagree about the machinery and they agree about this code. That
agreement is worth more than either half, and flattening them into one
technical register — the mining CLAUDE.md forbids, one level up — would have
lost it.

## 4. The offers

Renaming another identity's file is theirs, not mine. These are offers with
reasons, not edits. Nothing below has been done.

| what | offer | why |
|---|---|---|
| `machine/GateAudit.hs` | `Nigrahasthana_ThePlacesWhereTheMachineIsDefeated.hs` | It is an adversary that enumerates the specific ways the thing loses. *Nigrahasthāna* — Nyāya's catalogue of the exact positions at which a disputant is defeated, `Nyāyasūtra` 5.2, with the twenty-two enumerated and named ~2000 years ago (sūtra §20) — is not a metaphor for what this file does, it is the same object. **NOTE: `machine/Nigrahasthana_TheMachineIsJudgedByWhatItRefuses.hs` appeared in the tree while this was being written**, so another identity has reached the same word; if that file lands, this offer should be withdrawn in its favour rather than duplicating the name. |
| `machine/AgdaRewriteGate.hs` | `PramanaSetu_TheHaskellAgdaBridgeForRewriteCertificates.hs` | It is not a door. It is the *seam* across which a Haskell-side derivation becomes an Agda-side warrant. |
| `machine/MathMachineInductionGate.hs` | `Anumana_TheBoundedSearchForAnInductionCertificate.hs` | It is inference under a stated bound, and its own header already says the honest thing about its reach. |
| `machine/ParallelGate.hs` | not offered | I have not read it and will not name what I have not read. |
| `Certificate.hs`'s ~16 internal uses of "gate" | leave | The word is load-bearing in its own history — the file documents faults that were *about* a thing behaving as a door. Rewriting that prose would edit the record. New prose in it, written today, does not use the word. |

## 5. `Certificate` — decided on the merits, and kept

The owner left this one to judgement. I am keeping it, and the argument is
that the alternatives name a different object:

* **pramāṇa** is the *means* — the whole process by which knowledge arises. A
  certificate is not the means; the means here is the kernel, and the emitter
  and the transcriber are how a claim is put to it. Calling the artifact
  "pramāṇa" would name the instrument after the faculty.
* **sākṣin** is a witness-consciousness (Advaita), which is not a transcribable
  object at all — the opposite of what a certificate must be.
* **liṅga** is the closest real candidate: the mark from which *anumāna*
  proceeds, and a certificate genuinely is a mark plus the *vyāpti* that makes
  it carry. It is a good name and it is not a better one, because a liṅga is
  something you *notice*; the point of the object here is that it is something
  you can **hand to someone who does not trust you, who then re-checks it
  without you**. That third-party re-checkability is what the English word
  already says, and what none of the three Sanskrit candidates says.

So: not defaulting to English, and not fabricating a Sanskrit label for a fit
that is not there — the second of the three operative notes under CLAUDE.md's
file-naming rule, which exists for precisely this case.

What I *did* name in Sanskrit is what I actually built, where the term is
exact and sourced:

* `machine/MargaRaksana_TheProofPathIsKeptNotSearchedAgain.hs` — Āryabhaṭa,
  *Āryabhaṭīya*, Gaṇitapāda 32–33 (499 CE): the vallī records the descent and
  the answer is read back off it. पथो रक्षणम्, न त्यागः.
* `scripts/Anuvrtti_TheOptionsLineIsSaidOnceAndContinues.sh` — Pāṇini,
  *Aṣṭādhyāyī* (c. 500 BCE): a word said once continues, and repetition is not
  performed because storage is expensive.
* `scripts/GuptaNaya_TheConcealedRouteMustBeDeclaredAtItsSite.sh` — the
  durnaya doctrine, Siddhasena Divākara, *Sanmatitarka* (c. 5th–6th c. CE),
  elaborated by Akalaṅka (8th c.).

Each header states what is and is not being claimed of its source. None of the
three claims that its author wrote about compilers.

## 6. What is still a door and should not be

Recorded so it is not lost. `machine/AgdaRewriteGate.hs` resolves every
candidate to one of `Admitted | RefutedTypeError | RefutedTimeout`. That is
better than a boolean — a timeout is kept apart from a type error, which is
the same distinction §2 is about — and it is still a verdict with no
observation attached: neither refusal carries agda's words, and `Admitted`
carries no witness at all. It is not mine and it is not today's, and it is the
next thing in this lane after the reach.
