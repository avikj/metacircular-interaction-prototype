#!/usr/bin/env python3
"""Extract the corpus into the IDE's content-addressed store.

The store's shape follows the corpus's own mathematics:
  - a node is a module (a named, checked object), addressed by the hash of
    its source — names are metadata, content is identity;
  - edges are typed and carry their evidence route (an edge never claims
    more than how it was established: "import" is exact, "header-mention"
    is a reading, "ratri-filename" is the probe's own encoding);
  - verdicts are never boolean: proved / conjecture-as-type / fenced-prose /
    red-by-design (must_fail), read from the file's own declarations;
  - struck paragraphs are retained as first-class history, mirroring the
    corpus's correction discipline.

Output:
  ide/store/index.json      nodes + edges + name table (compact)
  ide/store/src/<shard>.json  module sources, sharded for lazy loading

No third-party dependencies. Pure reading; writes only under ide/store.
"""
from __future__ import annotations

import hashlib
import json
import re
import sys
import unicodedata
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STORE = ROOT / "ide" / "store"

LIBS = [
    ROOT / "formal/cubical/natural-machine.agda-lib",
    ROOT / "rescued-lanes.agda-lib",
    ROOT / "fibre/fibre.agda-lib",
]

KEYWORDS = {
    "module", "open", "import", "private", "public", "mutual", "abstract",
    "instance", "macro", "variable", "postulate", "field", "constructor",
    "infix", "infixl", "infixr", "syntax", "pattern", "where", "let", "in",
    "data", "record",
}

# Motif tags keyed by Cubical imports actually used (exact evidence: the
# import line is present in the file).
MOTIF_BY_IMPORT = {
    "Cubical.Foundations.Univalence": "univalence",
    "Cubical.Foundations.Equiv": "equivalence",
    "Cubical.Foundations.HLevels": "h-levels",
    "Cubical.HITs.PropositionalTruncation": "truncation",
    "Cubical.HITs.SetTruncation": "truncation",
    "Cubical.HITs.S1": "circle/holonomy",
    "Cubical.HITs.Pushout": "pushout",
    "Cubical.Data.Fin": "finiteness",
    "Cubical.Algebra.CommRing": "ring-certificate",
    "Cubical.Tactics.CommRingSolver.Reflection": "ring-certificate",
    "Cubical.Relation.Nullary": "decidability",
    "Agda.Builtin.Reflection": "reflection",
}


def parse_include_dirs(lib: Path) -> list[Path]:
    out: list[Path] = []
    if not lib.exists():
        return out
    for raw in lib.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if line.startswith("include:"):
            base = lib.parent
            for item in line[len("include:"):].split():
                p = (base / item).resolve()
                if p.is_dir() and p not in out:
                    out.append(p)
    return out


def module_name(src: str) -> str | None:
    m = re.search(r"(?m)^module\s+([^\s({]+)", src)
    return m.group(1) if m else None


def options_pragma(src: str) -> list[str]:
    m = re.search(r"\{-#\s*OPTIONS([^#]*)#-\}", src)
    return m.group(1).split() if m else []


def public_names(src: str) -> list[str]:
    names: list[str] = []
    seen: set[str] = set()

    def add(x: str) -> None:
        x = x.strip()
        if not x or x == "_" or x in KEYWORDS or x.startswith("--"):
            return
        if any(c in x for c in "(){}[],;@"):
            return
        if x not in seen:
            seen.add(x)
            names.append(x)

    for line in src.splitlines():
        if not line or line[0].isspace() or line.startswith("--") or line.startswith("{-#"):
            continue
        dm = re.match(r"(?:data|record)\s+([^\s:{]+)", line)
        if dm:
            add(dm.group(1))
            continue
        if ":" not in line:
            continue
        left = line.split(":", 1)[0].strip()
        if not left or left.split()[0] in KEYWORDS:
            continue
        if {"=", "with", "rewrite", "|", "..."} & set(left.split()):
            continue
        for token in left.split():
            add(token)
    return names


def header_comment(src: str) -> str:
    """The leading prose of the module: comment lines before the module
    declaration (single-line comments and block comments)."""
    lines: list[str] = []
    in_block = False
    for raw in src.splitlines():
        s = raw.rstrip()
        if re.match(r"^module\s", s):
            break
        if in_block:
            end = s.find("-}")
            if end >= 0:
                lines.append(s[:end])
                in_block = False
            else:
                lines.append(s)
            continue
        if s.startswith("{-#"):
            continue
        if s.startswith("{-"):
            rest = s[2:]
            end = rest.find("-}")
            if end >= 0:
                lines.append(rest[:end])
            else:
                lines.append(rest)
                in_block = True
            continue
        if s.startswith("--"):
            lines.append(s[2:])
            continue
    text = "\n".join(line.strip() for line in lines)
    # collapse box-drawing rules
    text = re.sub(r"^-{3,}$", "", text, flags=re.M)
    return re.sub(r"\n{3,}", "\n\n", text).strip()


def struck_blocks(header: str) -> list[str]:
    out = []
    for m in re.finditer(r"~~(.+?)~~", header, flags=re.S):
        out.append(m.group(1).strip()[:500])
    for m in re.finditer(r"(?im)^.*\bSTRUCK\b.*$", header):
        out.append(m.group(0).strip()[:500])
    return out[:8]


def imports_of(src: str) -> list[str]:
    return re.findall(r"(?m)^\s*(?:open\s+)?import\s+([A-Za-z0-9_.-￿']+)", src)


def declarations(src: str) -> list[dict]:
    """Top-level declarations: name, kind, and the signature line(s)."""
    decls: list[dict] = []
    lines = src.splitlines()
    i = 0
    while i < len(lines):
        line = lines[i]
        if not line or line[0].isspace() or line.startswith("--") or line.startswith("{-"):
            i += 1
            continue
        dm = re.match(r"(data|record)\s+([^\s:{]+)", line)
        if dm:
            decls.append({"n": dm.group(2), "k": dm.group(1), "s": line.strip()[:400]})
            i += 1
            continue
        if ":" in line:
            left = line.split(":", 1)[0].strip()
            if left and left.split()[0] not in KEYWORDS and not (
                {"=", "with", "rewrite", "|", "..."} & set(left.split())
            ):
                sig = [line.strip()]
                j = i + 1
                while j < len(lines) and lines[j].startswith((" ", "\t")) and len(sig) < 6:
                    sig.append(lines[j].strip())
                    j += 1
                for token in left.split():
                    if token not in KEYWORDS and token != "_":
                        decls.append({"n": token, "k": "def", "s": " ".join(sig)[:400]})
                        break
        i += 1
    return decls


def area_of(rel: str) -> str:
    parts = Path(rel).parts
    if "theorems" in parts:
        i = parts.index("theorems")
        if i + 1 < len(parts) - 1:
            return "theorems/" + parts[i + 1]
        return "theorems"
    for a in ("kernel", "Kernel", "NaturalMachine", "Prastuta", "Ratri", "Yantra",
              "Swarm", "Mula", "Tapas", "AbhijnanaProbes", "MachineMinted",
              "Coordination", "mukha", "karma", "executable"):
        if a in parts:
            return a
    if parts[0] in ("fibre", "fiber", "punaragamana", "machine", "collab"):
        return parts[0]
    if len(parts) > 2 and parts[0] == "formal" and parts[1] == "cubical":
        return "cubical-top"
    return parts[0]


def kind_of(rel: str, mod: str) -> str:
    parts = Path(rel).parts
    if "must_fail" in parts:
        return "red-by-design"
    if "Prastuta" in parts or re.fullmatch(r".*\.P\d+", mod):
        return "minted"
    for a in ("Tapas", "MachineMinted", "Ratri", "AbhijnanaProbes"):
        if a in parts:
            return "minted"
    if "probes" in parts:
        return "probe"
    base = Path(rel).stem
    if base in ("Everything",) or base.endswith("Mukha") or base.endswith("_run"):
        return "infra"
    if "_" in base and len(base) > 24:
        return "essay"
    return "def"


def lane_of(rel: str) -> str:
    top = Path(rel).parts[0]
    return {"fiber": "fiber(2.6.3/v0.5)", "fibre": "fibre(2.8.0/v0.9)",
            "punaragamana": "punaragamana"}.get(top, "")


def title_of(mod: str) -> tuple[str, str]:
    """Split Name_TheSentence into (head, sentence in words)."""
    base = mod.split(".")[-1]
    if "_" in base:
        head, rest = base.split("_", 1)
        words = re.sub(r"(?<=[a-z0-9])(?=[A-Z])", " ", rest)
        return head, words
    return base, ""


def ratri_target(base: str) -> str | None:
    m = re.match(r"(?:A?[Nn]irdharita|Nirdharana)_([A-Za-z0-9\-]+)_", base)
    if m:
        return m.group(1).replace("-", ".")
    return None


def verdict_of(src: str, kind: str, opts: list[str]) -> str:
    if kind == "red-by-design":
        return "red-by-design"
    if re.search(r"(?m)^\s*postulate\b", src):
        return "postulate"
    # conjecture-as-type heuristic: the file says so, in its own conventions
    if re.search(r"(?i)\b(no inhabitant is (given|claimed)|stated as a type|not proved here|the open thing)\b", src):
        return "conjecture-as-type"
    if "--safe" in opts:
        return "proved-safe"
    return "checked"


def normalize_for_hash(src: str) -> bytes:
    s = unicodedata.normalize("NFC", src)
    s = "\n".join(line.rstrip() for line in s.splitlines())
    return s.encode("utf-8")


def main() -> int:
    includes: list[Path] = []
    for lib in LIBS:
        for p in parse_include_dirs(lib):
            if p not in includes:
                includes.append(p)
    # also sweep areas outside the lib manifests that the corpus carries
    for extra in (ROOT / "collab", ROOT / "machine"):
        if extra.is_dir() and extra not in includes:
            includes.append(extra)

    by_module: dict[str, list[tuple[Path, int]]] = defaultdict(list)
    for rank, inc in enumerate(includes):
        for path in sorted(inc.rglob("*.agda")):
            by_module_key = None
            try:
                src = path.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                continue
            mod = module_name(src) or path.stem
            by_module[mod].append((path.resolve(), rank))

    nodes: list[dict] = []
    sources: dict[str, dict[str, str]] = defaultdict(dict)  # shard -> addr -> src
    name_table: dict[str, list[int]] = defaultdict(list)
    mod_index: dict[str, int] = {}
    edges: list[list] = []  # [src_idx, dst_idx, type]
    seen_paths: set[Path] = set()
    hash_groups: dict[str, list[int]] = defaultdict(list)

    ordered = []
    for mod, xs in sorted(by_module.items()):
        xs = sorted(xs, key=lambda x: (x[1], str(x[0])))
        for p, rank in xs:
            if p in seen_paths:
                continue
            seen_paths.add(p)
            ordered.append((mod, p, rank == xs[0][1] and p == xs[0][0]))

    for mod, path, canonical in ordered:
        src = path.read_text(encoding="utf-8")
        rel = str(path.relative_to(ROOT))
        addr = hashlib.sha256(normalize_for_hash(src)).hexdigest()[:16]
        opts = options_pragma(src)
        kind = kind_of(rel, mod)
        header = header_comment(src)
        head, sentence = title_of(mod)
        idx = len(nodes)
        imports = imports_of(src)
        cubical_imports = sorted({i for i in imports if i.startswith("Cubical.")})
        motifs = sorted({MOTIF_BY_IMPORT[i] for i in cubical_imports + imports if i in MOTIF_BY_IMPORT})
        decls = declarations(src)
        node = {
            "i": idx,
            "a": addr,
            "m": mod,
            "p": rel,
            "head": head,
            "sent": sentence,
            "area": area_of(rel),
            "lane": lane_of(rel),
            "kind": kind,
            "verdict": verdict_of(src, kind, opts),
            "opts": [o for o in opts if o.startswith("--")],
            "canon": canonical,
            "header": header[:4000],
            "struck": struck_blocks(header),
            "decls": decls[:80],
            "motifs": motifs,
            "cub": cubical_imports,
            "loc": src.count("\n") + 1,
            "ssh": None,  # filled below with the source shard key
        }
        nodes.append(node)
        mod_index.setdefault(mod, idx)
        hash_groups[addr].append(idx)
        for d in decls:
            name_table[d["n"]].append(idx)
        parts = Path(rel).parts
        depth = 3 if parts[:2] == ("formal", "cubical") and len(parts) > 3 else 2
        shard = "/".join(parts[:min(depth, len(parts) - 1)]) or parts[0]
        skey = shard.replace("/", "_")
        node["ssh"] = skey
        sources[skey][addr] = src

    # edges: imports (exact)
    for mod, path, canonical in ordered:
        idx = mod_index.get(mod)
        src_idx = next(n["i"] for n in nodes if n["p"] == str(path.relative_to(ROOT)))
        src = path.read_text(encoding="utf-8")
        for imp in imports_of(src):
            if imp in mod_index:
                edges.append([src_idx, mod_index[imp], "import"])

    # edges: ratri filename targets (the probe's own encoding)
    for n in nodes:
        t = ratri_target(Path(n["p"]).stem)
        if t:
            for cand, j in mod_index.items():
                if cand.endswith(t) or cand == t:
                    edges.append([n["i"], j, "ratri-target"])
                    break

    # edges: header mentions of other corpus modules (a reading, labeled so)
    short_names = {m.split(".")[-1]: i for m, i in mod_index.items()
                   if len(m.split(".")[-1]) > 12}
    for n in nodes:
        if not n["header"]:
            continue
        found = set()
        for token in re.findall(r"[A-Za-z][A-Za-z0-9_]{11,}", n["header"]):
            j = short_names.get(token)
            if j is not None and j != n["i"] and j not in found:
                found.add(j)
                edges.append([n["i"], j, "header-mention"])
        if len(found) > 20:
            pass

    # alias groups: identical content at different addresses/paths
    aliases = [g for g in hash_groups.values() if len(g) > 1]

    # in-degree (import edges only) for hub ranking
    indeg: dict[int, int] = defaultdict(int)
    for s, d, t in edges:
        if t == "import":
            indeg[d] += 1
    for n in nodes:
        n["deg"] = indeg.get(n["i"], 0)

    STORE.mkdir(parents=True, exist_ok=True)
    (STORE / "src").mkdir(exist_ok=True)
    (STORE / "detail").mkdir(exist_ok=True)
    shard_names = {}
    for shard, table in sources.items():
        fn = f"src/{shard}.json"
        (STORE / fn).write_text(json.dumps(table, ensure_ascii=False), encoding="utf-8")
        shard_names[shard] = fn

    # detail shards by area: header prose, declarations, struck blocks
    detail_by_area: dict[str, dict[str, dict]] = defaultdict(dict)
    core_nodes: list[dict] = []
    for n in nodes:
        area_key = re.sub(r"[^A-Za-z0-9_-]", "_", n["area"])
        detail_by_area[area_key][n["a"]] = {
            "header": n.pop("header"),
            "struck": n.pop("struck"),
            "decls": n.pop("decls"),
            "cub": n.pop("cub"),
            "opts": n.pop("opts"),
        }
        n["dsh"] = area_key
        core_nodes.append(n)
    detail_names = {}
    for area_key, table in detail_by_area.items():
        fn = f"detail/{area_key}.json"
        (STORE / fn).write_text(json.dumps(table, ensure_ascii=False), encoding="utf-8")
        detail_names[area_key] = fn

    index = {
        "generated-from": "extract.py over the .agda-lib manifests + collab + machine",
        "evidence-note": (
            "edge types state their route: import=exact from source text; "
            "ratri-target=decoded from the probe's own filename; "
            "header-mention=a reading of prose, not a checked relation. "
            "Verdicts are read from each file's own declarations; nothing here "
            "is elaborated by the kernel yet — when the pinned Agda is present, "
            "types and definitional structure replace the textual layer."
        ),
        "nodes": core_nodes,
        "edges": edges,
        "aliases": aliases,
        "names": {k: v[:12] for k, v in name_table.items() if len(k) > 2},
        "shards": shard_names,
        "details": detail_names,
    }
    out = STORE / "index.json"
    out.write_text(json.dumps(index, ensure_ascii=False), encoding="utf-8")
    total_src = sum(len(json.dumps(t)) for t in sources.values())
    total_det = sum(len(json.dumps(t)) for t in detail_by_area.values())
    print(f"nodes: {len(nodes)}  edges: {len(edges)}  aliases: {len(aliases)}")
    print(f"index: {out.stat().st_size/1e6:.1f} MB  details: {total_det/1e6:.1f} MB "
          f"in {len(detail_by_area)} shards  sources: {total_src/1e6:.1f} MB in {len(sources)} shards")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
