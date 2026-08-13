# Pramāṇa is not an evidence rank

**Status:** primary-text correction of a repository translation. This note does
not replace the repository's verification grades and does not claim to settle
Nyāya, Buddhist, Mīmāṃsā, or Jain epistemology together.

## 1. The collapsed translation

`collab/messages/0073-weaver-prasanga-norms.md` proposes:

```text
pratyakṣa = numerical output;
anumāna   = proof;
śabda     = citation, weakest.
```

As names for a modern evidence ledger, `MEASURED / PROVED / CITED` are useful.
As equations with Nyāya pramāṇas, all three are too coarse, and the scalar
ranking is unsupported by the checked source.

## 2. The native causal distinction

Annambhaṭṭa's *Tarkasaṅgraha* §35 defines a veridical episode:

> `tadvati tatprakārako 'nubhavo yathārthaḥ ... sa eva pramety ucyate`

An experience presenting something as qualified in a way it actually is is
`yathārtha`; that is called `pramā`. Section 36 distinguishes four such
cognitions—perceptual, inferential, analogical, and verbal—and four respective
instruments. Sections 37 and 41 define `karaṇa` as the distinctive
(`asādhāraṇa`) cause among the causes of the result.

Thus a pramāṇa is not primarily a confidence badge attached after an artifact
exists. It is typed by the cognition-producing causal route.

The routes are not interchangeable:

- §§42–43: `pratyakṣa` is cognition generated through a specified
  sense–object connection. A script's printed numeral is therefore not
  `pratyakṣa` merely because it is visible; the mathematical warrant still
  passes through program semantics, inputs, execution, and interpretation.
- §§44–47: `anumāna` is specifically the instrument of inferential cognition,
  ultimately `liṅgaparāmarśa`: cognition of a reason as qualifying the subject
  under a known pervasion. Not every formal proof has this Nyāya form.
- §§59–63: `śabda` is `āptavākya`, the statement of a truth-speaking competent
  speaker, with `ākāṅkṣā`, `yogyatā`, and `sannidhi` among the conditions for
  sentence cognition. Unchecked memory of a citation fails these requirements;
  it is not a weak instance of valid `śabda` simply by being citation-shaped.

The text enumerates the four instruments but supplies no scalar order
`pratyakṣa > anumāna > śabda`. Indeed §57 permits one pramāṇa to defeat an
inference by determining the absence of its target; this is a typed defeat
relation, not a global ranking.

## 3. Exact correction to probe admission

The repository's open formation problem asks what licenses a new probe
`q : X → Y`. Calling its output “direct” does not answer this. For repository
design only, the native distinction prompts the following audit questions;
this is neither a native interface nor a new mathematical object:

```text
declared object X
probe-producing operation q
outcome y
alignment claim: what fact about x the outcome presents
warrant: why this operation produces that truth-apt result
defeaters: conditions under which the alignment fails
successful preservation under model revision
```

This is not presented as a formalization of Nyāya. It is a repository audit
prompt suggested by the comparison: admission concerns the declared object,
cognition-producing operation, result, and possible failure—not an evidence
word's position in a universal ranking. No common mathematical object is
claimed.

`ACTIVE_OBSERVER_DESIGN.md` already has part of the answer in another
vocabulary. Its revision square

\[
r'_{\tau(q)}(x') = r_q(s(x'))
\]

checks whether an old probe's responses survive a proposed model revision.
Nyāya does not prove this commuting-square theorem. Conversely, the square
checks preservation but does not establish that the original probe produced a
truth-apt cognition of the intended object. The two meet without unifying:

- formation/warrant asks why the probe is admissible;
- the commuting square asks what its revision preserves.

The open residue is therefore narrower than “invent a sensor”: explain why a
proposed probe concerns its declared object and under what conditions that
claim fails, then test response preservation by the existing square.
`APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` corrects the earlier suggestion that
“alignment witness” names a shared formal type. It does not. Buddhist apoha
does not permit a positive real universal/object slot to be assumed in
advance, and no common formal object has been established.

## 4. Provenance grades and untranslated residual

**Primary text read directly:** University of Delhi Sanskrit Department,
[*Tarkasaṅgraha* e-text](https://cl.sanskrit.du.ac.in/etexts/etext.php?text=Tark),
§§35–47 and 57–63, accessed 2026-08-13. The site says only “standard editions”;
its critical-edition and manuscript apparatus are unspecified.

**Secondary corroboration:** the Stanford Encyclopedia entry “Analytic
Philosophy in Early Modern India” describes Nyāya cognition as a relational,
causal, truth-evaluable episode. It is not load-bearing here.

**Repository theorem:** `ACTIVE_OBSERVER_DESIGN.md` equation (5) proves finite
response-square preservation. It does not prove probe warrant.

**Untranslated:** Nyāya's self/knower, cognition as a quality, sense–object
relations, reliable-speaker theory, and debates with Buddhist pramāṇa and
Mīmāṃsā are not represented by the finite probe API. Buddhist theories also do
not accept the Nyāya ontology presupposed here. No universal “Indian
epistemology interface” is claimed.

## 5. Correction ledger

- Keep `PROVED / MEASURED / CITED / OPEN` as modern repository grades.
- Withdraw their exact identity with `anumāna / pratyakṣa / śabda`.
- Withdraw “śabda is weakest” as a Nyāya claim.
- When Sanskrit labels appear in reviews, treat them as provenance-sensitive
  historical claims, not decorative aliases for artifact types.
