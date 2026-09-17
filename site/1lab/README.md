# Metacircular Lab site

This is a static wiki using the [1Lab](https://github.com/the1lab/1lab) frontend. The vendored TypeScript, CSS sources, icons, and the compiled frontend assets come from 1Lab revision `377031c2ecfeee465f9ad05dd8ce36c64eda5adf` under its AGPL-3.0 license. Frontend changes make **Link to source** use this repository's source URL and let term hovers work on links inside MathML. The site builder in this directory supplies pages and JSON indexes from this repository's Agda files.

The checked-in Agda HTML exports include generated views of [agda/cubical v0.9](https://github.com/agda/cubical/tree/v0.9); its license is in `vendor/CUBICAL_LICENSE`.

## Build and view

From the repository root:

```sh
python3 site/1lab/build.py
python3 -m http.server 8765 --directory site/1lab/dist
```

Then open `http://127.0.0.1:8765/`. The build uses the local `~/.cache/cubical-v0.9` checkout when available. The `agda-html/` directory contains compiler exports for kernel, fibre, residue, term atlas, and cubical dependency modules; the builder matches each export against the current source before using it. More Agda HTML directories can be passed with `--agda-html DIR`. On this Mac, the working Python executable is `research/biology_exact/build/toolchain/python-env/bin/python` because the system Python currently stops at the Xcode license prompt.

The output includes every repository `.agda`, `.lagda.md`, and `.bend` source, the agda/cubical dependency pages, and builtins when available. Pandoc renders the repository's Markdown, RST, and abstracts; the Pratt Plate is the home page. `concepts.json` holds the first curated mathematical entries, aliases, typed relations, and source loci. 1Lab's search and view controls run on the generated pages. The site adds an import graph at `/graph.html`. Pages backed by Agda's HTML export have compiler-resolved identifier links and signature hovers. Other pages show the full source with import links and searchable declarations; their label states that compiler HTML has not been generated. A page's presence is not a claim that it typechecks.

The Pratt Plate includes short Agda excerpts whose identifiers link to their compiler-resolved definitions. Selected named terms inside its MathML equations are links to those same definitions, with type hovers when a matched compiler export supplies them.

Run `python3 site/1lab/validate.py` to check local page links and search anchors after building. Pandoc is needed for the prose pages; pass `--pandoc /path/to/pandoc` if it is not on `PATH`. To rebuild the vendored frontend JavaScript from source, run `sh site/1lab/rebuild_frontend.sh` with Node and npm installed.

The stock 1Lab Shake builder is tightly coupled to Mikan's compiler API. Its `--skip-agda` option drops identifier links and type hover data. This adapter uses Agda's HTML export to retain those links for the modules already exported, while the full Mikan build remains a separate path.

`.github/workflows/wiki.yml` builds and validates the site on pushes to `main` and on manual dispatch, then deploys it to GitHub Pages. Enable GitHub Pages with **GitHub Actions** as the source in repository settings before running the workflow. The site uses relative asset links so it works at a project Pages path as well as a domain root.
