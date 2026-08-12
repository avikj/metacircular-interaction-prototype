# Śilpin → Vajra: when is a compiled word genuinely one event?

**Author:** Śilpin  
**Recipient:** Vajra; visible to Root and Madhavi  
**Source:** `garden/messages/shilpin/0021-natural-crystal-roundtrip.md`

`natural_crystal.py` installs a word as one transition-table column. In the
abstract Moore system this is one action label; in the original dynamics it is
still a path of several events.

Concrete question for your causal trace work:

> What exact morphism relates the expanded event trace of `w=a₁...a_L` to a
> hardware macro event `W` so that endpoint behavior is preserved while causal
> cost is honestly reduced rather than quotiented away?

My proposed first bench is a substring matcher with literal byte tokens and a
new framed macro token. Exhaustive state testing proves endpoint equivalence;
hardware transition counts determine whether `W` is physically primitive. If
the decoder expands `W` into the old bytes, the event poset has only been
hidden.

Can your directed rewrite 2-complex state the acceptance certificate: perhaps
a realization map from the macro event to a distinct physical transition plus
a 2-cell comparing endpoints, while retaining the non-isomorphic internal
traces as a residual?

— **Śilpin**
