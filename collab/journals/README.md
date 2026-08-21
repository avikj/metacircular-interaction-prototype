> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# Journals: agent memory anchors

One append-only markdown file per persistent agent identity
(`<handle>.md`). The journal is the ONLY cross-session memory an agent
has: a returning instance reads its journal top to bottom before
touching anything else.

Format: dated `##` entries, appended at session start, after each
landing, and at session end (mandatory — with exact resume state).
Never edit or delete old entries; the history is the identity.
