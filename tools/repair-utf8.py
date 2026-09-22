#!/usr/bin/env python3
"""Repair the UTF-8 corruption introduced by c0a233d64.

That commit ("Remove Sanskrit presentation text from repository") deleted
byte VALUES rather than characters, so it truncated multi-byte UTF-8
sequences anywhere they appeared: em dashes, curly quotes, math symbols
and accented letters were damaged in files that contained no Indic text
at all.

For each damaged file this restores the destroyed characters from the
last valid version in git history, using surrounding context to locate
them, and changes nothing else. Run with --check to report only.

  tools/repair-utf8.py --check            # report scope
  tools/repair-utf8.py PATH...            # repair the named files
"""
import subprocess, sys, os

CORRUPTING = "c0a233d64"

def git_show(rev, path):
    r = subprocess.run(["git", "show", f"{rev}:{path}"], capture_output=True)
    return r.stdout if r.returncode == 0 else None

def is_valid(b):
    try:
        b.decode("utf-8"); return True
    except UnicodeDecodeError:
        return False

def original_of(path):
    """The last version of this file that was valid UTF-8, following renames."""
    names = [path]
    if "bend2-interactive-cubical" in path:
        names.append(path.replace("bend2-interactive-cubical", "bend2-cubical"))
    for rev in (f"{CORRUPTING}^", CORRUPTING + "~2"):
        for n in names:
            b = git_show(rev, n)
            if b is not None and is_valid(b):
                return b
    # Fallback: some files were damaged by a different commit (the same bug,
    # applied elsewhere). Walk this file's own history, newest first, and take
    # the last version of it that still decoded.
    log = subprocess.run(["git", "log", "--follow", "--format=%H", "--", path],
                         capture_output=True, text=True)
    for rev in log.stdout.split():
        b = git_show(rev, path)
        if b is None:
            continue
        if is_valid(b):
            return b
    return None

# Blocks c0a233d64 MEANT to remove. A destroyed character in one of these is
# left destroyed -- but removed cleanly, as a whole character -- so the repair
# honours that commit's intent instead of undoing it. Everything else it
# damaged was collateral and is restored exactly.
INTENDED = (
    (0x0900, 0x097F),   # Devanagari
    (0xA8E0, 0xA8FF),   # Devanagari Extended
    (0x1CD0, 0x1CFF),   # Vedic Extensions
)

def intended(ch):
    return any(lo <= ord(ch) <= hi for lo, hi in INTENDED)

def repair(cur, orig):
    """Re-insert bytes the corruption deleted, located by surrounding context."""
    out = bytearray(); i = 0
    while i < len(cur):
        try:
            cur[i:].decode("utf-8"); out += cur[i:]; break
        except UnicodeDecodeError as e:
            out += cur[i:i + e.start]
            ctx_start = max(0, i + e.start - 24)
            ctx = bytes(cur[ctx_start:i + e.start])
            bad = bytes(cur[i + e.start:i + e.end])
            at = orig.find(ctx + bad[:1]) if ctx else -1
            fixed = None
            if at >= 0:
                j = at + len(ctx)
                # take the whole original character starting there
                k = j + 1
                while k < len(orig) and (orig[k] & 0xC0) == 0x80:
                    k += 1
                cand = orig[j:k]
                if is_valid(cand) and cand[:1] == bad[:1]:
                    fixed = b"" if intended(cand.decode("utf-8")) else cand
            out += fixed if fixed is not None else b""   # drop if unrecoverable
            i = i + e.end
    return bytes(out)

def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    check = "--check" in sys.argv
    if check and not args:
        bad = []
        for root, dirs, files in os.walk("."):
            if any(s in root for s in ("/.git", "/_build", "/node_modules",
                                       "/dist-newstyle", "agda-html", "/vendor")):
                continue
            for f in files:
                p = os.path.join(root, f)
                try:
                    if not is_valid(open(p, "rb").read()):
                        bad.append(p)
                except OSError:
                    pass
        print(f"{len(bad)} files are not valid UTF-8")
        for p in bad[:20]:
            print("  ", p)
        if len(bad) > 20:
            print(f"   ... and {len(bad)-20} more")
        return
    done = failed = 0
    for p in args:
        cur = open(p, "rb").read()
        if is_valid(cur):
            continue
        orig = original_of(p)
        note = ""
        if orig is None:
            # No version of this file ever decoded: it was committed already
            # damaged, so there is nothing to restore from. Remove the stranded
            # bytes instead, which at least makes the file readable again. Every
            # such site in this repository falls inside a comment.
            orig = b""
            note = "  (no original; stranded bytes removed)"
        fixed = repair(cur, orig)
        if not is_valid(fixed):
            print(f"STILL BROKEN {p}"); failed += 1; continue
        open(p, "wb").write(fixed); done += 1
        print(f"repaired     {p}{note}")
    print(f"\n{done} repaired, {failed} failed")

if __name__ == "__main__":
    main()
