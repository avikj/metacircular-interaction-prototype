#!/usr/bin/env python3
"""Per-definition differential: Core's checker (`bend FILE`) vs the checker on
the net (`bend FILE --check-net CHECKER` + `hvm OUT -s`).

usage: BEND=.. HVM=.. CHECKER=.. DIFF_OUT=dir python3 checknet.py [--no-run] [files...]
  With no files: every tracked *.bend in the repository.
Writes DIR/defs.tsv (one row per definition) and DIR/files.tsv, prints totals.

Net result codes: 0 checks, 1 mismatch, 2 cannot infer, >= 1000 not yet on the net.
Row classes: AGREE (Core ✓ net 0, or Core ✗ net 1/2), NET-REJECTS (Core ✓,
net 1/2), NET-ACCEPTS (Core ✗, net 0), NOT-YET (net >= 1000). File-level failures
(emit error, runtime crash/timeout) are recorded in files.tsv.
"""
import os, re, sys, subprocess, concurrent.futures as cf

DIR = os.environ.get("DIFF_OUT") or os.path.join(os.getcwd(), "checknet-out")
RAW = os.path.join(DIR, "raw")
REPO = subprocess.run(["git", "-C", os.path.dirname(os.path.abspath(__file__)), "rev-parse", "--show-toplevel"],
                      capture_output=True, text=True).stdout.strip()
TIMEOUT = os.environ.get("CHECKNET_TIMEOUT", "120")
ENV = dict(os.environ, LC_ALL="C.UTF-8", LANG="C.UTF-8")
ANSI = re.compile(r"\x1b\[[0-9;]*m")

def rid(path):
    return os.path.relpath(path, REPO).replace("/", "__")

def run(cmd, cwd, out, err):
    with open(out, "wb") as o, open(err, "wb") as e:
        return subprocess.run(["timeout", TIMEOUT] + cmd, cwd=cwd, stdout=o, stderr=e, env=ENV).returncode

def rd(p):
    try:
        return open(p, encoding="utf-8", errors="replace").read()
    except FileNotFoundError:
        return ""

def collect(path):
    b = os.path.join(RAW, rid(path))
    d, f = os.path.dirname(path), os.path.basename(path)
    rc = run([ENV["BEND"], f], d, b + ".core", b + ".core.err")
    open(b + ".core.rc", "w").write(f"{rc}\n")
    rc = run([ENV["BEND"], f, "--check-net", ENV["CHECKER"]], d, b + ".hvm4", b + ".hvm4.err")
    open(b + ".hvm4.rc", "w").write(f"{rc}\n")
    if rc == 0:
        rc = run([ENV["HVM"], b + ".hvm4", "-s"], d, b + ".run", b + ".run.err")
        open(b + ".run.rc", "w").write(f"{rc}\n")

def core_verdicts(text):
    out = {}
    for line in ANSI.sub("", text).splitlines():
        m = re.match(r"^([✓✗]) (\S+)(.*)$", line)
        if m and "[HIT:" not in m.group(3):
            out[m.group(2)] = m.group(1)
    return out

def net_verdicts(prog, run_out):
    root = [l for l in prog.splitlines() if l.startswith("@main = ")]
    if not root:
        return None
    names = re.findall(r"@@idof\(@D([A-Za-z0-9_]*)\)", root[-1])
    # ↑ is HVM's collapse-ordering wrapper (transparent to the value)
    line = run_out.split("\n")[0].replace("↑", "")
    # a verdict superposed over the program's own superpositions: equal
    # worlds collapse, different worlds are reported as such (code -1)
    sup = re.compile(r"&[A-Za-z0-9_]*\{(-?\d+),(-?\d+)\}")
    while sup.search(line):
        line = sup.sub(lambda m: m.group(1) if m.group(1) == m.group(2) else "-1", line)
    codes = re.findall(r"#Pair\{(\d+),(-?\d+)\}", line)
    if len(codes) != len(names):
        return None
    return {unesc(n): int(c) for n, (_, c) in zip(names, codes)}

def unesc(n):
    out, i = [], 0
    while i < len(n):
        if n[i] == "_" and i + 1 < len(n):
            out.append({"u": "_", "s": "/"}.get(n[i + 1], "?"))
            i += 2
        else:
            out.append(n[i])
            i += 1
    return "".join(out)

def classify(path):
    b = os.path.join(RAW, rid(path))
    core = core_verdicts(rd(b + ".core"))
    hrc = rd(b + ".hvm4.rc").strip()
    frow = {"file": os.path.relpath(path, REPO), "status": "OK", "detail": ""}
    if hrc != "0":
        frow["status"], frow["detail"] = "EMIT-FAIL", rd(b + ".hvm4.err").strip().splitlines()[-1:] or [""]
        frow["detail"] = frow["detail"][0][:160]
        return frow, []
    rrc = rd(b + ".run.rc").strip()
    net = net_verdicts(rd(b + ".hvm4"), rd(b + ".run"))
    if rrc != "0" or net is None:
        frow["status"] = "RUN-TIMEOUT" if rrc == "124" else "RUN-FAIL"
        frow["detail"] = (rd(b + ".run.err").strip().splitlines() or [""])[-1][:160]
        return frow, []
    rows = []
    for name, code in net.items():
        c = core.get(name, "?")
        if code >= 1000:
            cls = "NOT-YET"
        elif c == "✓":
            cls = "AGREE" if code == 0 else "NET-REJECTS"
        elif c == "✗":
            cls = "AGREE" if code != 0 else "NET-ACCEPTS"
        else:
            cls = "NO-CORE"
        rows.append({"file": frow["file"], "def": name, "core": c, "net": code, "cls": cls})
    return frow, rows

def main():
    args = sys.argv[1:]
    norun = "--no-run" in args
    files = [os.path.abspath(a) for a in args if a != "--no-run"]
    if not files:
        ls = subprocess.run(["git", "-C", REPO, "ls-files", "*.bend"], capture_output=True, text=True).stdout.split()
        files = [os.path.join(REPO, f) for f in ls]
    os.makedirs(RAW, exist_ok=True)
    if not norun:
        with cf.ThreadPoolExecutor(int(os.environ.get("CHECKNET_JOBS", "4"))) as ex:
            list(ex.map(collect, files))
    frows, drows = [], []
    for f in files:
        fr, dr = classify(f)
        frows.append(fr)
        drows.extend(dr)
    with open(os.path.join(DIR, "files.tsv"), "w") as o:
        o.write("file\tstatus\tdetail\n")
        for r in frows:
            o.write(f"{r['file']}\t{r['status']}\t{r['detail']}\n")
    with open(os.path.join(DIR, "defs.tsv"), "w") as o:
        o.write("file\tdef\tcore\tnet\tcls\n")
        for r in drows:
            o.write(f"{r['file']}\t{r['def']}\t{r['core']}\t{r['net']}\t{r['cls']}\n")
    from collections import Counter
    print("files:", dict(Counter(r["status"] for r in frows)))
    print("defs: ", dict(Counter(r["cls"] for r in drows)))

if __name__ == "__main__":
    main()
