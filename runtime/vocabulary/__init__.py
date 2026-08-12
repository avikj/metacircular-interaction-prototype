"""``runtime/vocabulary`` -- letting the loop extend its own generative vocabulary.

The named ceiling this package attacks, in ``generate/README.md`` sec.7's own
words: *the construction schema is finite and human-written -- nothing inside
the loop invents a constructor family.*

Three files, three jobs:

``define.py``          definitional extension.  A new constructor arrives as
                       ``c(#0..#k-1) := body`` with its defining equation as a
                       kernel-checked ``Eq`` edge and an unfolding rule.
``propose.py``         where the constructors come from: recurring **objects**
                       in the loop's own derivation record, and proved
                       quotients.  Plus the matched-count null pool, labelled.
``conservativity.py``  the guard.  Seven admission gates, and the elimination
                       argument executed rather than cited: every theorem the
                       extended loop proves is unfolded and re-checked in the
                       base vocabulary.

Because a definitional extension is conservative it proves nothing new.  So
whatever the experiment in ``../demo/vocabulary_demo.py`` measures, it is
measuring **reachability under a budget** -- which is the claim that what you
can name determines what you can find, isolated from the claim that naming
proves things.  ``README.md`` reports what actually happened, including where
the new ceiling sits.
"""

from .define import (Definition, Vocabulary, VocabularyError, def_app,
                     def_symbols,
                     defining_edge, fold, is_base, is_def, kencode,
                     require_base, unfold, unfold_edge, vrender)
from .conservativity import (AdmissionReport, BaseAnswerReport, GATES,
                             Installation, Refusal, UnfoldReport, admissible,
                             admit, audit_theorems, base_answers_unchanged,
                             unfolds)
from .propose import (RANK_RULE, Candidate, History, VocabConfig,
                      VocabLeakageReport, VocabRound, VocabularyOrganism,
                      abstract_variables, null_pool_candidates,
                      propose_from_quotients, propose_from_subterms,
                      to_definition, vocab_leakage_report)

__all__ = [
    "Definition", "Vocabulary", "VocabularyError", "def_app", "def_symbols",
    "defining_edge", "fold", "is_base", "is_def", "kencode", "require_base",
    "unfold", "unfold_edge", "vrender",
    "AdmissionReport", "BaseAnswerReport", "GATES", "Installation", "Refusal",
    "UnfoldReport", "admissible", "admit", "audit_theorems",
    "base_answers_unchanged", "unfolds",
    "RANK_RULE", "Candidate", "History", "VocabConfig", "VocabLeakageReport",
    "VocabRound", "VocabularyOrganism", "abstract_variables",
    "null_pool_candidates", "propose_from_quotients", "propose_from_subterms",
    "to_definition", "vocab_leakage_report",
]
