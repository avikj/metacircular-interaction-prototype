# Source dossier: Rohan Pandey (@khoomeik) — published work, writings, positions

**Compiled by:** cf-tessera, 2026-08-12, at the user's request ("friend with
whom I've developed many ideas and found direction").  **Type:** historical
sourcing / provenance, NOT mathematical evidence.  Per the repository's
discipline, nothing here certifies a claim; this note records what was
fetched, from where, and what could not be accessed.

## Identity

Rohan Pandey, AI researcher.  Handles: `@khoomeik` (X), `KhoomeiK` (GitHub).
Carnegie Mellon University '23 (CS with honors; thesis on vision–language
semantics).  Career arc per fetched sources: Reworkd-era open-source agent
tooling → OpenAI Training team (model architecture; contributed to training
GPT-5-class models; joined Nov 2024) → left OpenAI (May 2025) to work on
Sanskrit OCR → Periodic Labs (autonomous science, from Sept 2025).

Disambiguation note: several unrelated academics share the name (e.g. a
2020 COVID/WASH NLP paper's Rohan Pandey appears to be a different person);
this dossier tracks only the @khoomeik identity, cross-confirmed by the
GitHub profile, personal site (rpandey.tech), and X announcements.

## Published papers (venues per personal-site/search listings)

1. **gzip Predicts Data-dependent Scaling Laws** (arXiv:2405.16684, 2024;
   was under review at NeurIPS 2024).  Fetched abstract: LM scaling laws
   are sensitive to data complexity; gzip-compressibility predicts the
   effect; proposes a data-dependent scaling law whose compute-optimal
   frontier shifts toward dataset size (over parameters) as data becomes
   harder to compress.  Code: github.com/KhoomeiK/complexity-scaling.
2. **Multimodal Learning Without Multimodal Data: Guarantees and
   Applications** (ICLR 2024).
3. **Towards Vision-Language Mechanistic Interpretability: a Causal
   Tracing Tool for BLIP** (ICCV 2023, CLVL workshop).
4. **Cross-modal Attention Congruence Regularization for Vision-Language
   Relation Alignment** (ACL 2023).
5. Additional venues claimed on the GitHub profile: EMNLP, EACL, NeurIPS
   (not individually enumerated by the fetched pages).

## Essays / long-form writing

- **"Taking the Bitter Lesson Seriously"** (Substack, 2025-09-30).
  Full text NOT directly fetchable from this container (egress-blocked);
  argument reconstructed from search snippets and the announcement thread:
  Sutton's bitter lesson implies research itself is compute-bound; RL lets
  an LLM hill-climb any problem where verification is easier than
  generation; the reliable path to advancing AI is more compute and more
  energy, so AI should be enabled to hill-climb compute & energy through
  experimentally verifiable science (the Periodic Labs thesis: an AI
  scientist working on RL, synthetic data, supercomputing).  Acknowledged
  draft readers include Dwarkesh Patel, Dylan Patel, Liam Fedus, Tamay
  Besiroglu, Anjney Midha, et al.

## Positions and projects visible on X (@khoomeik)

- **Scaling/bitter-lesson stance:** "bitterlessonpilled != scalingpilled —
  scaling compute is only the premise of the bitter lesson.  The
  implication of scaling is that we must develop methods that improve with
  scale" (Mar 2025).
- **OpenAI arc:** joined the Training team Nov 2024 to research model
  architecture ("Resident" under Borzunov/Clark et al.); left May 2025:
  "taking a break to solve OCR for Sanskrit so we can immortalize the
  classical Indian literary canon in the weights of superintelligence."
- **Sanskrit / Pāṇinian program:** runs a biweekly Sanskrit reading night
  in SF with talks on Pāṇinian grammar by traditionally and academically
  trained experts; position (per search-indexed posts): Pāṇini realized
  the structure of language in the mind is entirely computational and
  distilled it into <4,000 morphophonemic rules.
- **Vedic exegesis:** claims a reconstruction of the śakala's role in
  Agnimanthana, an open problem in Vedic ritual exegesis "since at least
  Sāyaṇa (1300s AD)" (Apr 2024 thread).
- **Interpretability interests:** called for real MoE interpretability
  work (Oct 2024); earlier: character-count-constrained decoding with
  Llama2-13B to propose de-redactions of length-constrained text (2024).

## Open-source projects (GitHub, fetched directly)

- **tarsier** (1.8k stars): vision utilities for web-interaction agents.
- **LlamaGym** (1.3k stars): fine-tune LLM agents with online RL.
- **bananalyzer** (327 stars): AI-agent evaluation framework for web tasks.
- **llama2d** (95 stars): 2D positional embeddings for webpage structure.
- **complexity-scaling** (35 stars): code for the gzip scaling-laws paper.
- **interrupting-cow** (148 stars): voice assistant that interrupts you.
- Profile also lists: BCI development with NSF funding; 10+ hackathon wins.

## Relevance hooks into this repository (directional, not evidential)

- The repository's inherited-construction list names **Pāṇinian
  derivation** as a live discipline; Pandey's position that Pāṇini's
  grammar is a computational system (~4k morphophonemic rules) is the
  same reading this repo operationalizes when it treats derivation
  systems as executable mathematics.  If the user wants, the Aṣṭādhyāyī-
  as-rewriting-system lane (rule ordering, conflict resolution =
  confluence questions) is the natural joint meeting this corpus's
  rewriting/Church–Rosser work.
- The **verification-easier-than-generation** framing of RL in his essay
  is structurally the certificate discipline of this repo (typed
  certificates; breaker audits) — a bridge worth making exact rather than
  metaphorical before any claim is built on it.
- The **gzip/data-complexity scaling** result is an empirical-ML claim;
  under this repo's rules it would be a `measurement`-kind packet with
  its error analysis owed — cited here as prior art only.

## Access log (what was and was not readable)

- FETCHED DIRECTLY: github.com/KhoomeiK (profile, pinned repos).
- FETCHED VIA SEARCH SNIPPETS (multiple independent queries, quotes as
  indexed): x.com/khoomeik posts; substack essay summary; personal-site
  publication list; arXiv abstract of 2405.16684; indiaweekly.biz item on
  the OpenAI departure.
- EGRESS-BLOCKED from this container: rpandey.tech, rohanpandey.substack
  .com, semanticscholar.org, arxiv.org, x.com direct fetch.  Full texts of
  the essay and papers were therefore NOT read end-to-end here; anything
  load-bearing must be re-fetched and read in full before use.

## Rigor boundary

Everything above is sourced testimony about a person's public output,
compiled 2026-08-12; no mathematical claim in this repository depends on
it.  The two candidate bridges (Pāṇinian rewriting ↔ confluence;
verification-asymmetry ↔ certificate discipline) are directions, unproved
and unformalized.  Quotes are as indexed by search and may elide context.
