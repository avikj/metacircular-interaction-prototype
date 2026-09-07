"""cf-prime's Theorem-F test (msg 0110 SS1), run on the records we already have.

The prediction: audit channels are NOT exchangeable.  If some error class was
only ever caught by a channel *outside* the model distribution -- exact
computation, external literature, the human -- that class is the visible edge
of the invariant orbit, and same-lineage auditing cannot reach it.  If the
partition comes back uniform, SS1 is wrong and should be struck.

This classifies collab/FAILURES.md (the walk ledger) by the channel named in
each entry's cause-of-death.  It reads text, so it is a census of what the
ledger SAYS, not an independent determination of what happened.  Entries whose
cause names no channel are reported as UNATTRIBUTED rather than guessed at --
that count is the honest limit on the test.

Run: python3 collab/discovery/channel_partition.py
"""
import re
import sys
from collections import Counter, defaultdict

LEDGER = "collab/FAILURES.md"

# Channel signatures, most specific first.  A cause matching none is
# UNATTRIBUTED; a cause matching several is reported under all of them, since
# an error caught twice is evidence about both channels.
CHANNELS = [
    ("human",      r"\bupstream directive|\bhuman\b|\boperator\b|user (?:said|noted|corrected)"),
    ("literature", r"already known|prior art|prior-art|Effinger|Titchmarsh|Odlyzko|"
                   r"Knuth-?Bendix|Montgomery|classical|\(19\d\d\)|known result|"
                   r"rediscover"),
    ("exact",      r"\bcounterexample\b|explicit .*(?:counterexample|factor)|"
                   r"enumerat|exhaustive|no-?go|resultant|certificate|"
                   r"provably|exact theorem|is false when|bit-identical"),
    ("crosslin",   r"\bCodex\b|cross-?lineage|cross-?review|independent lineage|"
                   r"\bbreaker\b|red team"),
    ("samelin",    r"\baudit\b|re-?derivation|referee|self-?check|my own|"
                   r"internal review"),
]

def entries(text):
    """Split the ledger into F-entries, rejoining wrapped lines."""
    blocks = re.split(r"\n(?=F\d+ \[)", text)
    for b in blocks:
        m = re.match(r"(F\d+) \[([\d-]+)\] \[([^\]]*)\] — (.*)", b, re.S)
        if not m:
            continue
        tag, date, owner, body = m.groups()
        body = " ".join(body.split())
        cause = ""
        c = re.search(r"Died:\s*(.*?)(?:\s*Revive:|\s*Lesson:|$)", body, re.S)
        if c:
            cause = " ".join(c.group(1).split())
        yield tag, date, owner, body, cause

def classify(cause):
    hits = [name for name, pat in CHANNELS
            if re.search(pat, cause, re.I)]
    return hits or ["UNATTRIBUTED"]

def main():
    try:
        text = open(LEDGER).read()
    except OSError as e:
        print("cannot read %s: %s" % (LEDGER, e)); return 1

    rows = list(entries(text))
    tally = Counter()
    by_channel = defaultdict(list)
    unattributed = []
    for tag, date, owner, body, cause in rows:
        if not cause:
            unattributed.append((tag, "no 'Died:' clause"))
            tally["NO-CAUSE"] += 1
            continue
        for ch in classify(cause):
            tally[ch] += 1
            by_channel[ch].append((tag, cause[:64]))
        if classify(cause) == ["UNATTRIBUTED"]:
            unattributed.append((tag, cause[:64]))

    print("cf-prime's Theorem-F test, msg 0110 SS1")
    print("ledger: %s   entries parsed: %d\n" % (LEDGER, len(rows)))

    print("  %-14s %6s   %s" % ("channel", "count", "example"))
    for ch, n in tally.most_common():
        ex = by_channel[ch][0][0] + " " + by_channel[ch][0][1] if by_channel[ch] else ""
        print("  %-14s %6d   %s" % (ch, n, ex))

    model_side = tally["samelin"] + tally["crosslin"]
    outside = tally["exact"] + tally["literature"] + tally["human"]
    print("\n  inside the model distribution  (same+cross lineage): %d" % model_side)
    print("  outside it (exact/literature/human)                : %d" % outside)

    print("\n  UNATTRIBUTED or no cause clause: %d of %d  <- the honest limit"
          % (len(unattributed), len(rows)))
    for tag, why in unattributed:
        print("      %-5s %s" % (tag, why))

    print("\n  Reading: this is a census of what the ledger SAYS. It cannot")
    print("  distinguish 'caught by channel X' from 'written up citing X'.")
    print("  A uniform partition would strike SS1; a lopsided one is")
    print("  consistent with SS1 but does not establish it, because the")
    print("  ledger is itself authored inside the distribution under test.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
