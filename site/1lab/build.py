#!/usr/bin/env python3
"""Build a static 1Lab frontend over this repository's Agda corpus.

The frontend is vendored from the1lab/1lab. Agda's own HTML backend supplies
compiler-resolved links where an HTML export exists; other files retain a
source view and a searchable declaration index.
"""

from __future__ import annotations

import argparse
from bisect import bisect_right
import hashlib
import html
from html.parser import HTMLParser
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
from urllib.parse import quote, unquote


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
DIST = HERE / "dist"
EXTENSIONS = (".agda", ".lagda.md", ".bend")
MODULE = re.compile(r"^\s*module\s+([^\s]+)\s+where\b", re.M)
IMPORT = re.compile(r"^\s*(?:open\s+)?import\s+([^\s;()]+)", re.M)
SIGNATURE = re.compile(r"^(\s*)([^\s:]+)\s*:\s*(.+)$")
DECLARATION = re.compile(r"^\s*(?:data|record|pattern|module|postulate|primitive|macro)\s+([^\s:{()]+)")
BEND_DECLARATION = re.compile(r"^\s*(?:def|type)\s+([^\s:(]+)")
PRE = re.compile(r'<pre class="Agda">(.*?)</pre>', re.S)
HREF = re.compile(r'<a\b([^>]*?)href="([^"]+)"([^>]*)>')
HEADING = re.compile(r'<h([1-6]) id="([^"]+)"([^>]*)>(.*?)</h\1>', re.S)
SKIP_DIRS = {".git", ".agents", ".codex", "_build", "build", "dist", "node_modules", "site"}
# The wiki is an English presentation layer.  Keep the executable sources in
# the repository, while removing Indic script and transliteration marks from
# everything emitted into the public site (including vendored compiler HTML
# excerpts and search metadata).
SANSKRIT_SCRIPT = re.compile(r"[\u0900-\u097F]")
SANSKRIT_MARKS = re.compile(r"[ĀāĪīŪūṚṛṜṝḶḷḹṄṅÑñṆṇṬṭḌḍḎḏŚśṢṣḤḥṂṃṆṇ]")
SANSKRIT_LABEL = re.compile(r"\bSanskrit\b", re.I)
# Non Jain Sanskrit glosses and invented prefixes that must not appear in the
# public presentation. Jain vocabulary such as naya, pramana, karma, moksa,
# and saptabhangi is intentionally retained.
NON_JAIN_SANSKRIT = {
    "avataranika": "descent-note", "avatarana": "descent", "sesa": "residue",
    "samvada": "interaction", "krama": "order", "niyama": "rule",
    "yantra": "machine", "bhavana": "composition", "visvarupa": "universal",
    "punaragamana": "return", "punaragam": "return", "kosa": "shell",
    "ksitija": "horizon", "pratibimba": "reflection", "parivarta": "exchange",
    "vakra": "curved", "valaya": "loop", "sima": "boundary",
    "prastha": "block", "khanda": "segment", "adhah": "lower",
    "shunya": "zero", "garbha": "kernel", "upadhi": "qualifier",
    "kuttaka": "euclidean", "sthana": "position", "sankhya": "count",
    "sakala": "whole", "vikala": "partial", "desa": "region",
    "samagra": "total", "samata": "equality", "dvidha": "split",
    "tantu": "fiber", "srotas": "stream", "sanghata": "aggregate",
    "sankramana": "transport", "samuha": "set", "pratyahara": "contraction",
    "pratyaya": "evidence", "nirjara": "reduction", "kaivalya": "decoupling",
    "sutra": "rule-text", "pada": "term", "sakti": "capacity",
    "purna": "complete", "purnata": "completeness", "pariksa": "check",
    "pramanya": "warrant", "viveka": "distinction", "nucleus": "kernel",
}
NON_JAIN_SANSKRIT_RE = re.compile(r"\b(" + "|".join(map(re.escape, NON_JAIN_SANSKRIT)) + r")\b", re.I)


class PlainText(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.parts: list[str] = []

    def handle_data(self, data: str) -> None:
        self.parts.append(data)


def text_of(markup: str) -> str:
    parser = PlainText()
    parser.feed(markup)
    return "".join(parser.parts)


def source_files(root: Path):
    for directory, dirs, files in os.walk(root):
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
        for name in files:
            if name.endswith(EXTENSIONS):
                yield Path(directory) / name


def collect(cubical: Path | None, builtin: Path | None, scope: str):
    paths = list(source_files(ROOT))
    if scope == "kernel":
        paths = [p for p in paths if p.is_relative_to(ROOT / "formal/cubical/Kernel")]
    if cubical and cubical.exists():
        paths += list(source_files(cubical / "Cubical"))
    if builtin and builtin.exists():
        paths += list(source_files(builtin / "Agda"))

    rows = []
    for path in sorted(set(paths)):
        try:
            source = path.read_text(encoding="utf-8")
        except (OSError, UnicodeError):
            continue
        bend = path.suffix == ".bend"
        match = MODULE.search(source) if not bend else None
        if not bend and not match:
            continue
        name = match.group(1) if match else "Bend." + path.relative_to(ROOT).with_suffix("").as_posix().replace("/", ".")
        if path.is_relative_to(ROOT):
            relative = path.relative_to(ROOT).as_posix()
            origin = "repository"
            url = "https://github.com/avikj/metacircular-interaction-prototype/blob/main/" + relative
        elif cubical and path.is_relative_to(cubical):
            relative = path.relative_to(cubical).as_posix()
            origin = "agda/cubical v0.9"
            url = "https://github.com/agda/cubical/blob/v0.9/" + relative
        else:
            relative = path.name
            origin = "Agda builtins"
            url = "https://github.com/agda/agda"
        rows.append(dict(path=path, relative=relative, origin=origin, url=url,
                         source=source, name=name, language="Bend" if bend else "Agda", imports=IMPORT.findall(source)))

    # A repository module wins over an installed-library module with the same
    # name. Duplicate local modules still receive distinct page URLs.
    rows.sort(key=lambda r: (r["name"], r["origin"] != "repository", r["relative"]))
    names = {}
    for row in rows:
        if row["name"] not in names:
            row["page"] = row["name"] + ".html"
            names[row["name"]] = row
        else:
            suffix = hashlib.sha256(row["relative"].encode()).hexdigest()[:8]
            row["page"] = row["name"] + "--" + suffix + ".html"
        row["declarations"] = declarations(row["source"], row["path"].name.endswith(".lagda.md"), row["language"] == "Bend")
        row["line_starts"] = [0] + [m.end() for m in re.finditer("\n", row["source"])]
    return rows, names


def declarations(source: str, literate: bool, bend: bool):
    result = []
    offset = 0
    seen = set()
    in_code = not literate
    for number, line in enumerate(source.splitlines(keepends=True), 1):
        body = line.rstrip("\r\n")
        if literate and body.lstrip().startswith("```"):
            in_code = not in_code if in_code else body.lstrip().startswith("```agda")
            offset += len(line)
            continue
        if not in_code:
            offset += len(line)
            continue
        sig = SIGNATURE.match(body) if not bend else None
        decl = (BEND_DECLARATION if bend else DECLARATION).match(body) if sig is None else None
        if sig:
            name = sig.group(2)
            kind = "signature"
            typ = sig.group(3).strip()
            position = offset + sig.start(2) + 1
        elif decl:
            name = decl.group(1)
            kind = "declaration"
            typ = body[decl.end():].strip().removeprefix(":").strip() if bend else ""
            position = offset + decl.start(1) + 1
        else:
            offset += len(line)
            continue
        if name in seen or name.startswith("--"):
            offset += len(line)
            continue
        seen.add(name)
        result.append(dict(name=name, type=typ, line=number, pos=position, kind=kind))
        offset += len(line)
    return result


def find_highlights(rows, html_dirs):
    cache = {}
    for directory in html_dirs:
        if not directory.exists():
            continue
        for path in directory.glob("*.html"):
            cache.setdefault(path.stem, []).append(path)
    for row in rows:
        row["highlight"] = None
        row["anchor_ids"] = set()
        for path in cache.get(row["name"], []):
            raw = path.read_text(encoding="utf-8")
            match = PRE.search(raw)
            if match and text_of(match.group(1)).rstrip() == row["source"].rstrip():
                row["highlight"] = match.group(1)
                row["anchor_ids"] = set(re.findall(r'\bid="(\d+)"', match.group(1)))
                break


def page_shell(title: str, module: str, source_url: str, body: str, toc: str = "") -> str:
    title_ = html.escape(title)
    mod_json = json.dumps(module, ensure_ascii=False)
    source_json = json.dumps(source_url, ensure_ascii=False)
    return f'''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title_} · Metacircular Lab</title>
<link rel="stylesheet" href="css/default.css"><link rel="stylesheet" href="css/site.css">
<script>Object.assign(window, {{baseUrl:location.pathname.substring(0, location.pathname.lastIndexOf('/')), source:{source_json}, module:{mod_json}}});</script>
<script src="start.js"></script><script defer src="main.js"></script>
</head><body class="text-page"><main><div id="post-toc-container">
<aside id="toc"><h3 class="Agda"><a class="Module" href="./">Metacircular Lab</a></h3>
<div class="mathpar"><a id="logo" href="./"><img alt="Home" src="static/cube-72x.png" width="32" height="32"></a></div>
<hr><div id="toc-container"><ul>{toc}</ul><hr>
<div class="search-form search-form-proxy mathpar js-only" role="form"><input id="search-box-proxy" type="text" placeholder="Search..." autocomplete="off" tabindex="0"></div>
<div class="site-nav"><a href="concepts.html">Concepts</a> · <a href="all-pages.html">All pages</a> · <a href="graph.html">Dependency graph</a> · <a href="{html.escape(source_url, quote=True)}">Source</a></div>
</div></aside>
<article><div class="narrow-only" id="article-nav"><div id="article-nav-left"><a id="logo" href="./"><img alt="Home" src="static/cube-72x.png" width="32" height="32"></a><button id="narrow-search-btn" class="js-only">🔍</button></div></div>
{body}</article><aside id="sidenote-container" style="visibility:hidden"></aside>
</div></main></body></html>'''


def header(title: str, anchor: str = "page") -> str:
    escaped = html.escape(title)
    return f'<h1 id="{anchor}"><a href="#{anchor}" class="header-link"><span>{escaped}</span><span class="header-link-emoji">🔗</span></a></h1>'


def link_for(module: str, names) -> str | None:
    row = names.get(unquote(module))
    return row["page"] if row else None


def highlighted(markup: str, names, types) -> str:
    def replace(match):
        before, href, after = match.groups()
        if href.startswith(("http:", "https:", "#")):
            return match.group(0)
        target, marker, fragment = href.partition("#")
        target_name = target.removesuffix(".html")
        target_row = names.get(unquote(target_name))
        if not target_row:
            if target_name.startswith("Cubical."):
                remote = "https://github.com/agda/cubical/blob/v0.9/Cubical/" + target_name.removeprefix("Cubical.").replace(".", "/") + ".agda"
                return f'<a{before}href="{html.escape(remote, quote=True)}"{after}>'
            if target_name.startswith("Agda."):
                remote = "https://github.com/agda/agda/blob/v2.8.0/src/data/lib/prim/" + target_name.replace(".", "/") + ".agda"
                return f'<a{before}href="{html.escape(remote, quote=True)}"{after}>'
            remote = "https://github.com/avikj/metacircular-interaction-prototype/search?q=" + quote(target_name) + "&type=code"
            return f'<a{before}href="{html.escape(remote, quote=True)}"{after}>'
        filename = target_row["page"]
        if fragment.isdigit() and fragment not in target_row["anchor_ids"]:
            line = bisect_right(target_row["line_starts"], int(fragment) - 1)
            fragment = "L" + str(max(1, line))
        rewritten = filename + ("#" + fragment if marker else "")
        if fragment.isdigit() and int(fragment) in types.get(target_name, {}):
            after += ' data-type="true"'
        return f'<a{before}href="{html.escape(rewritten, quote=True)}"{after}>'
    converted = HREF.sub(replace, markup)
    return "".join(f'<span id="L{i}"></span>{line}' for i, line in enumerate(converted.splitlines(keepends=True), 1))


def resolve_import(row, imported, names, paths):
    if row["language"] == "Bend":
        local = paths.get(row["path"].parent / (imported + ".bend"))
        if local:
            return local
        candidates = [r for r in paths.values() if r["language"] == "Bend" and r["path"].stem == imported]
        return candidates[0] if len(candidates) == 1 else None
    return names.get(imported)


def plain_source(row, names, paths) -> str:
    lines = []
    for number, line in enumerate(row["source"].splitlines(), 1):
        imp = IMPORT.match(line)
        if imp:
            target = resolve_import(row, imp.group(1), names, paths)
            page = target["page"] if target else None
            if page:
                line = (html.escape(line[:imp.start(1)])
                        + f'<a class="Module" href="{html.escape(page, quote=True)}">{html.escape(imp.group(1))}</a>'
                        + html.escape(line[imp.end(1):]))
            else:
                line = html.escape(line)
        else:
            line = html.escape(line)
            if row["language"] == "Bend":
                if line.lstrip().startswith("#"):
                    line = '<span class="Comment">' + line + '</span>'
                else:
                    line = re.sub(r"\b(def|type|case|match|lambda|all|any)\b", r'<span class="Keyword">\1</span>', line)
        lines.append(f'<span class="source-line" id="L{number}" data-line="{number}">{line}</span>')
    return '<pre class="Agda source-view">' + "\n".join(lines) + '</pre>'


def write_json(path: Path, value) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")


def scrub_public_output() -> None:
    """Remove Sanskrit characters from all public wiki artifacts.

    This runs after every page and index has been written, so compiler
    exports, prose rendered by Pandoc, source fallbacks, and JSON search data
    all follow the same presentation policy.  ASCII mathematical notation is
    retained; only Indic script, transliteration marks, and the language label
    itself are removed.
    """
    for path in DIST.rglob("*"):
        if not path.is_file() or path.suffix.lower() not in {".html", ".json", ".js", ".txt"}:
            continue
        try:
            content = path.read_text(encoding="utf-8")
        except (OSError, UnicodeError):
            continue
        cleaned = SANSKRIT_SCRIPT.sub("", content)
        cleaned = SANSKRIT_MARKS.sub("", cleaned)
        cleaned = SANSKRIT_LABEL.sub("", cleaned)
        cleaned = NON_JAIN_SANSKRIT_RE.sub(lambda m: NON_JAIN_SANSKRIT[m.group(1).lower()], cleaned)
        if cleaned != content:
            path.write_text(cleaned, encoding="utf-8")


def collect_docs():
    paths = []
    for directory, dirs, files in os.walk(ROOT):
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
        for name in files:
            path = Path(directory) / name
            if name.endswith((".md", ".rst")) or (path.parent == ROOT / "abstracts" and name.endswith(".txt")):
                paths.append(path)
    result = []
    for path in sorted(paths):
        relative = path.relative_to(ROOT).as_posix()
        content = path.read_text(encoding="utf-8", errors="replace")
        heading = re.search(r"^#\s+(.+)$", content, re.M)
        title = heading.group(1).strip() if heading else path.stem.replace("_", " ")
        page = "Doc." + hashlib.sha256(relative.encode()).hexdigest()[:12] + ".html"
        result.append(dict(path=path, relative=relative, title=title, page=page, content=content))
    return result


def declaration_link(row, name):
    definition = next((d for d in row["declarations"] if d["name"] == name), None)
    if not definition:
        return None
    fragment = str(definition["pos"]) if str(definition["pos"]) in row["anchor_ids"] else "L" + str(definition["line"])
    return row["page"] + "#" + fragment


def enrich_pratt(markup, rows, names, types):
    by_path = {row["relative"]: row for row in rows if row["origin"] == "repository"}
    anchors = {
        "Lossless": ("formal/cubical/theorems/residue/LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda", "Lossless"),
        "π": ("fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda", "π"),
        "LawfulStep": ("fibre/src/Fibre/TheVisibleStepNeedNotBeInvertibleAndItsResidueIsStillExactlyOneFibre.agda", "LawfulStep"),
        "ISC": ("fibre/src/Fibre/Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda", "ISC"),
    }
    links = {}
    for symbol, (path, name) in anchors.items():
        row = by_path.get(path)
        if row:
            href = declaration_link(row, name)
            if href:
                links[symbol] = (href, row["highlight"] is not None)

    def math_links(match):
        math = match.group(0)
        pi_one = '<msub><mi>π</mi><mn>1</mn></msub>'
        math = math.replace(pi_one, '__PRATT_FIRST_PROJECTION__')
        def token_link(token):
            symbol = html.unescape(token.group(2))
            if symbol not in links:
                return token.group(0)
            href, typed = links[symbol]
            attr = ' data-type="true"' if typed else ''
            return f'<a href="{html.escape(href, quote=True)}"{attr} role="link" tabindex="0">{token.group(0)}</a>'
        math = re.sub(r'(<(?:mi|mo)\b[^>]*>)(Lossless|π|LawfulStep)(</(?:mi|mo)>)', token_link, math)
        if "ISC" in links:
            href, typed = links["ISC"]
            attr = ' data-type="true"' if typed else ''
            math = re.sub(r'(<mrow><mi[^>]*>𝖨</mi><mi[^>]*>𝖲</mi><mi[^>]*>𝖢</mi></mrow>)',
                          lambda m: f'<a href="{html.escape(href, quote=True)}"{attr} role="link" tabindex="0">{m.group(1)}</a>', math)
        return math.replace('__PRATT_FIRST_PROJECTION__', pi_one)
    markup = re.sub(r'<math\b.*?</math>', math_links, markup, flags=re.S)

    examples = [
        ("kernel", anchors["Lossless"][0], 61, 65, "Lossless completion"),
        ("kernel", anchors["Lossless"][0], 218, 222, "Uniqueness theorem"),
        ("classifier", anchors["π"][0], 121, 125, "Universal family"),
        ("classifier", anchors["π"][0], 194, 195, "Classifier"),
        ("productive-interaction", anchors["ISC"][0], 79, 85, "Interactive coalgebra"),
        ("time-information", "formal/cubical/theorems/physics/Ksitija_TheCausalConeDescendsToTheHorizonAndFailsAtTheVeryNextStep.agda", 90, 92, "Causal future"),
        ("time-information", "formal/cubical/theorems/physics/Ksitija_TheCausalConeDescendsToTheHorizonAndFailsAtTheVeryNextStep.agda", 119, 130, "Horizon obstruction"),
        ("observation-residual-phase", "formal/cubical/theorems/residue/ActionResidualPhase.agda", 88, 104, "Residual phase"),
    ]
    grouped = {}
    for section, path, first, last, title in examples:
        row = by_path.get(path)
        if not row:
            continue
        if row["highlight"]:
            source = "".join(row["highlight"].splitlines(keepends=True)[first - 1:last])
            code = highlighted(source, names, types)
            code = re.sub(r'\s+id="(?:L)?\d+"', '', code)
        else:
            source = "".join(row["source"].splitlines(keepends=True)[first - 1:last])
            code = html.escape(source)
        href = row["page"] + "#L" + str(first)
        grouped.setdefault(section, []).append(
            f'<figure class="agda-example"><figcaption>{html.escape(title)} · '
            f'<a href="{html.escape(href, quote=True)}">full source</a></figcaption>'
            f'<pre class="Agda source-view">{code}</pre></figure>')
    for section, snippets in grouped.items():
        pattern = r'(<h2 id="' + re.escape(section) + r'"[^>]*>.*?</h2>)'
        markup = re.sub(pattern, lambda m: m.group(1) + ''.join(snippets), markup, count=1, flags=re.S)
    return markup


def render_docs(docs, rows, names, types, search, pandoc):
    if not pandoc:
        return 0, {}
    rendered = {}
    source_pages = {row["relative"]: row["page"] for row in rows if row["origin"] == "repository"}
    doc_pages = {doc["relative"]: doc["page"] for doc in docs}
    for doc in docs:
        kind = "rst" if doc["path"].suffix == ".rst" else "markdown+tex_math_single_backslash+tex_math_dollars"
        render_input = re.sub(r"\\rm\s+([A-Za-z]+)", r"\\mathrm{\1}", doc["content"])
        output = subprocess.run([pandoc, "--from=" + kind, "--to=html5", "--mathml", "--wrap=none"],
                                input=render_input, text=True, capture_output=True, check=True).stdout
        headings = []
        def heading(match):
            level, anchor, attrs, inside = match.groups()
            label = text_of(inside)
            headings.append((anchor, label, int(level)))
            return f'<h{level} id="{anchor}"{attrs}><a href="#{anchor}" class="header-link"><span>{inside}</span><span class="header-link-emoji">🔗</span></a></h{level}>'
        output = HEADING.sub(heading, output)
        def local_link(match):
            before, href, after = match.groups()
            url, mark, fragment = href.partition("#")
            if not url or url.startswith(("http:", "https:", "mailto:", "/")):
                return match.group(0)
            target = (doc["path"].parent / unquote(url)).resolve()
            if not target.is_relative_to(ROOT):
                return match.group(0)
            relative = target.relative_to(ROOT).as_posix()
            page = source_pages.get(relative) or doc_pages.get(relative)
            if page:
                return f'<a{before}href="{html.escape(page + ("#"+fragment if mark else ""), quote=True)}"{after}>'
            return match.group(0)
        output = HREF.sub(local_link, output)
        if doc["relative"] == "research/pratt/PRATT_PLATE_V2.md":
            output = enrich_pratt(output, rows, names, types)
        rendered[doc["relative"]] = output
        toc = ''.join(f'<li><a class="header-link" href="#{html.escape(anchor, quote=True)}">{html.escape(label)}</a></li>' for anchor, label, _ in headings[:80])
        body = header(doc["title"]) + '<p class="site-meta">' + html.escape(doc["relative"]) + '</p>' + output
        source_url = "https://github.com/avikj/metacircular-interaction-prototype/blob/main/" + doc["relative"]
        (DIST / doc["page"]).write_text(page_shell(doc["title"], doc["page"].removesuffix(".html"), source_url, body, toc), encoding="utf-8")
        search.append(dict(idIdent=doc["title"], idAnchor=doc["page"], idType=None, idDefines=None))
        for anchor, label, _ in headings:
            search.append(dict(idIdent=doc["title"] + " > " + label, idAnchor=doc["page"] + "#" + anchor,
                               idType=None, idDefines=None))
    return len(docs), rendered


def render_concepts(rows, docs, search):
    concepts = json.loads((HERE / "concepts.json").read_text(encoding="utf-8"))
    by_id = {concept["id"]: concept for concept in concepts}
    if len(by_id) != len(concepts):
        raise ValueError("Duplicate concept ID")
    edge_types = {"identical-to", "near-identical-to", "equivalent-to", "univalent-to", "dual-to",
                  "restriction-of", "truncation-of", "projection-of", "quotient-of", "pullback-of",
                  "classified-by", "specialization-of", "generalizes", "refines", "composes-with",
                  "transports-to", "implemented-by", "realized-by", "implies", "corollary-of",
                  "prerequisite-of", "counterexample-to", "historically-anticipated-by",
                  "historical-presentation-of", "computational-realization-of", "physical-realization-of",
                  "observational-shadow-of", "finite-shadow-of", "set-level-shadow-of",
                  "propositional-shadow-of", "carrier-for"}
    incoming = {ident: [] for ident in by_id}
    for concept in concepts:
        for edge in concept["relations"]:
            if edge["type"] not in edge_types or edge["target"] not in by_id:
                raise ValueError(f"Invalid concept relation: {concept['id']} {edge}")
            incoming[edge["target"]].append((concept["id"], edge["type"]))
    write_json(DIST / "static/concepts.json", concepts)
    source_pages = {row["relative"]: row["page"] for row in rows if row["origin"] == "repository"}
    source_pages.update({doc["relative"]: doc["page"] for doc in docs})
    source_rows = {row["relative"]: row for row in rows if row["origin"] == "repository"}
    for concept in concepts:
        ident = concept["id"]
        page = "Concept." + ident + ".html"
        search.append(dict(idIdent=concept["title"], idAnchor=page, idType=None, idDefines=concept["aliases"]))
        for alias in concept["aliases"]:
            search.append(dict(idIdent=alias, idAnchor=page, idType=None, idDefines=[concept["title"]]))
        sources = []
        for path in concept["sources"]:
            if path not in source_pages:
                raise ValueError(f"Missing concept source: {path}")
            source = source_rows.get(path)
            state = ("Agda compiler export, source matched" if source and source["highlight"] else
                     "source indexed" if source else "prose")
            sources.append(f'<li><a href="{html.escape(source_pages[path], quote=True)}">{html.escape(path)}</a> <small>({state})</small></li>')
        relations = []
        for edge in concept["relations"]:
            target = by_id.get(edge["target"])
            relations.append(f'<li><code>{html.escape(edge["type"])}</code> <a href="Concept.{html.escape(edge["target"], quote=True)}.html">{html.escape(target["title"])}</a></li>')
        for source_id, edge_type in incoming[ident]:
            source_concept = by_id[source_id]
            relations.append(f'<li><a href="Concept.{html.escape(source_id, quote=True)}.html">{html.escape(source_concept["title"])}</a> <code>{html.escape(edge_type)}</code> this concept</li>')
        body = (header(concept["title"])
                + '<p class="site-meta">Mathematical concept · curated source loci and vocabulary</p>'
                + f'<p><a href="./#' + html.escape(concept["pratt"], quote=True) + '">Pratt Plate context</a></p>'
                + '<h2 id="aliases">Other names</h2><p>' + ', '.join(html.escape(x) for x in concept["aliases"]) + '</p>'
                + '<h2 id="relations">Typed relations</h2><ul>' + ''.join(relations) + '</ul>'
                + '<h2 id="sources">Source loci</h2><ul>' + ''.join(sources) + '</ul>')
        (DIST / page).write_text(page_shell(concept["title"], page.removesuffix(".html"),
                                             "https://github.com/avikj/metacircular-interaction-prototype/blob/main/site/1lab/concepts.json",
                                             body), encoding="utf-8")
    cards = ''.join(f'<li><a href="Concept.{html.escape(c["id"], quote=True)}.html">{html.escape(c["title"])}</a></li>' for c in concepts)
    body = header("Mathematical concepts") + '<p>Canonical entry points with aliases, typed relations, and source loci.</p><ul class="concept-list">' + cards + '</ul>'
    (DIST / "concepts.html").write_text(page_shell("Mathematical concepts", "concepts",
                                             "https://github.com/avikj/metacircular-interaction-prototype/blob/main/site/1lab/concepts.json",
                                             body), encoding="utf-8")
    return len(concepts), cards


def build(args):
    cubical = Path(args.cubical).expanduser().resolve() if args.cubical else None
    builtin = Path(args.builtin).expanduser().resolve() if args.builtin else None
    rows, names = collect(cubical, builtin, args.scope)
    paths = {row["path"]: row for row in rows}
    docs = collect_docs() if args.scope == "all" else []
    html_dirs = [Path(p).expanduser().resolve() for p in args.agda_html]
    find_highlights(rows, html_dirs)
    if DIST.exists():
        shutil.rmtree(DIST)
    DIST.mkdir(parents=True)
    shutil.copytree(HERE / "assets", DIST, dirs_exist_ok=True)
    (DIST / "types").mkdir(exist_ok=True)
    search = []
    graph = set()
    backlinks = {row["name"]: set() for row in rows}
    types = {row["name"]: {d["pos"]: html.escape(d["type"]) for d in row["declarations"] if d["type"]} for row in rows}
    for row in rows:
        for imported in row["imports"]:
            target = resolve_import(row, imported, names, paths)
            if target and target is not row:
                graph.add((row["name"], target["name"]))
                backlinks.setdefault(target["name"], set()).add(row["name"])
    for row in rows:
        name, page = row["name"], row["page"]
        search.append(dict(idIdent=name, idAnchor=page, idType=None, idDefines=None))
        for d in row["declarations"]:
            anchor = str(d["pos"]) if str(d["pos"]) in row["anchor_ids"] else "L" + str(d["line"])
            search.append(dict(idIdent=name + "." + d["name"], idAnchor=page + "#" + anchor,
                               idType=d["type"] or None, idDefines=None))
        toc = '<li><a href="#page" class="header-link">' + html.escape(name) + '</a></li>'
        toc += '<li><a href="#declarations" class="header-link">Declarations</a></li>'
        toc += '<li><a href="#dependencies" class="header-link">Dependencies</a></li>'
        mark = ('Compiler linked Agda HTML' if row["highlight"] else
                ('Source view; Bend compiler export pending' if row["language"] == "Bend" else
                 'Source view; Agda HTML has not been generated for this file'))
        source_html = ('<pre class="Agda source-view">' + highlighted(row["highlight"], names, types) + '</pre>'
                       if row["highlight"] else plain_source(row, names, paths))
        deps = sorted({target["name"] for x in row["imports"] if (target := resolve_import(row, x, names, paths))})
        dependent = sorted(backlinks.get(name, set()))
        def links(items):
            return ', '.join(f'<a href="{html.escape(names[x]["page"], quote=True)}">{html.escape(x)}</a>' for x in items) or 'None indexed'
        content = (header(name) + f'<p class="site-meta">{html.escape(row["language"])} · {html.escape(row["origin"])} · {html.escape(row["relative"])} · {mark}</p>'
                   + '<h2 id="declarations"><a href="#declarations" class="header-link"><span>Declarations</span></a></h2>'
                   + '<ul class="declaration-list">'
                   + ''.join(f'<li><a href="#{d["pos"] if str(d["pos"]) in row["anchor_ids"] else "L"+str(d["line"])}">{html.escape(d["name"])}</a>'
                             + (f' <code>{html.escape(d["type"])}</code>' if d["type"] else '') + '</li>' for d in row["declarations"])
                   + '</ul><h2 id="dependencies"><a href="#dependencies" class="header-link"><span>Dependencies</span></a></h2>'
                   + '<p><strong>Imports:</strong> ' + links(deps) + '</p><p><strong>Imported by:</strong> ' + links(dependent) + '</p>'
                   + '<h2 id="source"><a href="#source" class="header-link"><span>Source</span></a></h2>' + source_html)
        (DIST / page).write_text(page_shell(name, name, row["url"], content, toc), encoding="utf-8")
        if row["highlight"] and types[name]:
            positions = types[name]
            values = [None] * (max(positions) + 1)
            for pos, typ in positions.items():
                values[pos] = typ
            write_json(DIST / "types" / (name + ".json"), values)
    doc_count, rendered_docs = render_docs(docs, rows, names, types, search, args.pandoc)
    concept_count, concept_cards = render_concepts(rows, docs, search) if args.scope == "all" and doc_count else (0, "")
    write_json(DIST / "static/search.json", search)
    write_json(DIST / "static/links.json", sorted(map(list, graph)))
    ordered = sorted(rows, key=lambda r: (r["origin"] != "repository", r["relative"]))
    cards = ''.join(f'<li><a href="{html.escape(r["page"], quote=True)}">{html.escape(r["name"])}</a><small>{html.escape(r["relative"])}</small></li>' for r in ordered)
    doc_cards = ''.join(f'<li><a href="{html.escape(d["page"], quote=True)}">{html.escape(d["title"])}</a><small>{html.escape(d["relative"])}</small></li>' for d in docs) if doc_count else ''
    agda_count = sum(r["language"] == "Agda" for r in rows)
    bend_count = sum(r["language"] == "Bend" for r in rows)
    all_body = header("All pages") + f'<p>{concept_count} concept pages, {agda_count} Agda modules, {bend_count} Bend files, and {doc_count} prose pages. {sum(bool(r["highlight"]) for r in rows)} Agda pages have compiler linked HTML.</p>'
    all_body += '<h2 id="concepts">Concepts</h2><ul class="all-pages">' + concept_cards + '</ul>'
    all_body += '<h2 id="prose">Prose</h2><ul class="all-pages">' + doc_cards + '</ul><h2 id="code">Code</h2><ul class="all-pages">' + cards + '</ul>'
    (DIST / "all-pages.html").write_text(page_shell("All pages", "all-pages", "https://github.com/avikj/metacircular-interaction-prototype", all_body), encoding="utf-8")
    groups = {}
    for row in rows:
        if row["origin"] != "repository":
            continue
        group = row["relative"].split("/")[0]
        groups.setdefault(group, []).append(row)
    sections = ''.join(f'<h2>{html.escape(group)}</h2><p>{len(items)} modules · <a href="all-pages.html">Browse all</a></p><ul>'
                       + ''.join(f'<li><a href="{html.escape(r["page"], quote=True)}">{html.escape(r["name"])}</a></li>' for r in items[:12]) + '</ul>'
                       for group, items in sorted(groups.items()))
    pratt_path = "research/pratt/PRATT_PLATE_V2.md"
    pratt_source = "https://github.com/avikj/metacircular-interaction-prototype/blob/main/" + pratt_path
    home = '<p class="site-meta">A mathematical reference built on the 1Lab interface. Search every proof and document with Ctrl/⌘+K.</p>'
    home += rendered_docs.get(pratt_path, header("Pratt Plate"))
    home += '<h2 id="concepts">Mathematical concepts</h2><ul class="concept-list">' + concept_cards + '</ul>'
    home += '<h2 id="explore">Explore the codebase</h2><p><a href="concepts.html">Concepts</a> · <a href="all-pages.html">All pages</a> · <a href="graph.html">Dependency graph</a></p>'
    home += sections
    home_toc = ''.join(f'<li><a class="header-link" href="#{anchor}">{html.escape(text_of(label))}</a></li>'
                       for anchor, label in re.findall(r'<h[1-6] id="([^"]+)"[^>]*><a[^>]*><span>(.*?)</span>',
                                                       rendered_docs.get(pratt_path, ""), re.S))
    (DIST / "index.html").write_text(page_shell("Pratt Plate", "index", pratt_source, home, home_toc), encoding="utf-8")
    graph_body = header("Dependency graph") + '<p>Module imports are shown as directed links. Select a node to open its source page.</p><div id="graph"></div><script src="graph.js"></script>'
    (DIST / "graph.html").write_text(page_shell("Dependency graph", "graph", "https://github.com/avikj/metacircular-interaction-prototype", graph_body), encoding="utf-8")
    scrub_public_output()
    print(f"Built {concept_count} concept pages, {agda_count} Agda pages, {bend_count} Bend pages, {doc_count} prose pages; {sum(bool(r['highlight']) for r in rows)} Agda HTML pages; {len(search)} search entries; {len(graph)} dependency links -> {DIST}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--scope", choices=["all", "kernel"], default="all")
    parser.add_argument("--cubical", default=str(Path.home() / ".cache/cubical-v0.9"))
    parser.add_argument("--builtin", default=str(ROOT / "research/term-atlas/build/agda-data/lib/prim"))
    parser.add_argument("--agda-html", action="append", default=[str(HERE / "agda-html/term"), str(HERE / "agda-html/kernel"), str(HERE / "agda-html/fibre"), str(HERE / "agda-html/residue")])
    default_pandoc = shutil.which("pandoc") or "/private/tmp/pandoc/pandoc-3.11-arm64/bin/pandoc"
    parser.add_argument("--pandoc", default=default_pandoc if Path(default_pandoc).exists() else None)
    build(parser.parse_args())
