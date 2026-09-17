#!/usr/bin/env python3
"""Check generated pages, search targets, and local cross links."""

from collections import Counter
from html.parser import HTMLParser
import json
from pathlib import Path
from urllib.parse import unquote, urlsplit


DIST = Path(__file__).resolve().parent / "dist"


class Links(HTMLParser):
    def __init__(self):
        super().__init__()
        self.anchors = set()
        self.links = []
        self.math_depth = 0
        self.math_links = 0
        self.typed_math_links = 0

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "math":
            self.math_depth += 1
        if "id" in attrs:
            self.anchors.add(attrs["id"])
        if tag == "a" and "href" in attrs:
            self.links.append(attrs["href"])
            if self.math_depth:
                self.math_links += 1
                self.typed_math_links += attrs.get("data-type") == "true"

    def handle_endtag(self, tag):
        if tag == "math":
            self.math_depth -= 1


def main():
    pages = {}
    for path in DIST.glob("*.html"):
        parser = Links()
        parser.feed(path.read_text(encoding="utf-8"))
        pages[path.name] = parser
    problems = Counter()
    examples = {}

    def issue(kind, source, href):
        problems[kind] += 1
        examples.setdefault(kind, [])
        if len(examples[kind]) < 20:
            examples[kind].append((source, href))

    for filename, parser in pages.items():
        for href in parser.links:
            url = urlsplit(href)
            if url.scheme or url.netloc or href.startswith("mailto:"):
                continue
            target = unquote(url.path).lstrip("/") or filename
            if not target.endswith(".html"):
                continue
            if target not in pages:
                issue("missing page", filename, href)
            elif url.fragment and url.fragment not in pages[target].anchors:
                issue("missing anchor", filename, href)

    search = json.loads((DIST / "static/search.json").read_text(encoding="utf-8"))
    for entry in search:
        href = entry["idAnchor"]
        target, _, anchor = href.partition("#")
        if target not in pages:
            issue("missing search page", entry["idIdent"], href)
        elif anchor and anchor not in pages[target].anchors:
            issue("missing search anchor", entry["idIdent"], href)

    home = (DIST / "index.html").read_text(encoding="utf-8")
    if home.count('class="agda-example"') < 4:
        issue("missing linked Agda excerpts", "index.html", "Agda excerpts")
    if pages["index.html"].math_links < 3 or pages["index.html"].typed_math_links < 3:
        issue("missing linked MathML term", "index.html", "MathML term")

    print(f"{len(pages)} pages, {len(search)} search entries")
    for kind, count in problems.items():
        print(f"{kind}: {count}; examples: {examples[kind]}")
    return 1 if problems else 0


if __name__ == "__main__":
    raise SystemExit(main())
