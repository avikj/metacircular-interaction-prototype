/* The corpus browser as an instance of the corpus's own calculus.
 *
 * Store  = content-addressed nodes (modules) + typed edges carrying their
 *          evidence route. Names are metadata; the address is the content.
 * View   = an observation (B, f : Store -> B). The filter rail composes
 *          observations; their conjunction is the meet, and the meet is
 *          computed, not simulated.
 * Trace  = the session derivation. Navigation appends; going back appends
 *          a reversal mark (grade-preserving) — history is never destroyed.
 *          The trace shows its grade (length) and its reversal-mark count:
 *          the two data the corpus proves every collapsed summary loses.
 */

import { Grapheme } from "./grapheme.js";

const isDark = () =>
  document.documentElement.dataset.theme === "dark" ||
  (document.documentElement.dataset.theme !== "light" &&
   matchMedia("(prefers-color-scheme: dark)").matches);

/** Tint an element by its token under the grapheme lens. */
const tint = (elm, token, strength = 1) => {
  if (!Grapheme.enabled || !token) return;
  const c = Grapheme.color(token, { dark: isDark(), strength });
  elm.style.color = c;
  elm.style.textDecorationColor = c;
};

const S = {
  idx: null,            // index.json
  nodes: [],
  byMod: new Map(),     // module name -> node
  byAddr: new Map(),
  out: new Map(),       // idx -> [[dst, type]]
  inn: new Map(),       // idx -> [[src, type]]
  names: {},            // declaration name -> [node idx]
  concepts: null,       // concept join table
  details: new Map(),   // shard key -> table (lazy)
  srcs: new Map(),      // shard key -> table (lazy)
  types: new Map(),     // area shard key -> { module: { name: type } } (lazy)
  filters: { area: null, verdict: null, motif: null, kind: null },
  trace: [],            // {op, arg, rev}
  focus: null,
  view: "focus",        // focus | graph | about
  graphColor: "verdict", // verdict | grapheme
};

const $ = (s) => document.querySelector(s);
const el = (tag, cls, text) => {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (text !== undefined) e.textContent = text;
  return e;
};
const esc = (s) => s.replace(/[&<>]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;" }[c]));

/* ---------------- boot ---------------- */

async function boot() {
  const [idx, concepts] = await Promise.all([
    fetch("store/index.json").then((r) => r.json()),
    fetch("store/concepts.json").then((r) => r.json()).catch(() => null),
  ]);
  Grapheme.load();
  S.idx = idx;
  S.nodes = idx.nodes;
  S.names = idx.names;
  S.concepts = concepts;
  for (const n of S.nodes) {
    S.byMod.set(n.m, n);
    if (!S.byAddr.has(n.a)) S.byAddr.set(n.a, n);
  }
  for (const [s, d, t] of idx.edges) {
    if (!S.out.has(s)) S.out.set(s, []);
    if (!S.inn.has(d)) S.inn.set(d, []);
    S.out.get(s).push([d, t]);
    S.inn.get(d).push([s, t]);
  }
  $("#nstats").textContent =
    `${S.nodes.length} nodes · ${idx.edges.length} edges`;
  renderRail();
  window.addEventListener("hashchange", route);
  route();
  wireSearch();
  wireKeys();
}

function route() {
  const h = decodeURIComponent(location.hash.slice(1));
  if (!h) { openNode(defaultEntry(), true); return; }
  if (h === "~graph") { setView("graph"); return; }
  if (h === "~about") { setView("about"); return; }
  const n = S.byMod.get(h) || S.byAddr.get(h);
  if (n) openNode(n, true);
}

function defaultEntry() {
  // The corpus's own front doors, in preference order.
  const doors = [
    "WhatThisIsAndHowToDescendIntoTheMetacircularKernel",
    "Pravesa_TheFrontierTheoremsAsEntryPointsFromOtherFields",
  ];
  for (const d of doors) {
    for (const n of S.nodes) if (n.m.endsWith(d)) return n;
  }
  return S.nodes[0];
}

/* ---------------- trace (the derivation) ---------------- */

function traceStep(op, arg, rev = false) {
  S.trace.push({ op, arg, rev });
  renderTrace();
}

function goBack() {
  // reversal is a constructor, not deletion: append the reverse step.
  const last = [...S.trace].reverse().find((s) => s.op === "open" && !s._undone);
  if (!last) return;
  const prior = [...S.trace].reverse().filter((s) => s.op === "open");
  if (prior.length < 2) return;
  const target = prior[1].arg;
  last._undone = true;
  traceStep("open", target, true);
  const n = S.byMod.get(target);
  if (n) openNode(n, false, true);
}

function renderTrace() {
  const t = $("#trace");
  t.textContent = "";
  const tail = S.trace.slice(-14);
  const start = S.trace.length - tail.length;
  tail.forEach((s, i) => {
    const row = el("div", "step" + (s.rev ? " rev" : ""));
    row.append(el("span", "g", String(start + i + 1)));
    row.append(el("span", "", (s.rev ? "reverse → " : "") + s.op + " " +
      (s.arg || "").split(".").pop().slice(0, 34)));
    t.append(row);
  });
  const revs = S.trace.filter((s) => s.rev).length;
  const visited = new Set(S.trace.filter((s) => s.op === "open").map((s) => s.arg));
  $("#tracegrade").innerHTML =
    `grade <b>${S.trace.length}</b> · reversal marks <b>${revs}</b> · ` +
    `meet so far: <b>${visited.size}</b> nodes<br>` +
    `<span style="font-style:italic">the summary you see forgets the route; the trace above does not</span>`;
}

/* ---------------- observations (the filter rail) ---------------- */

function activeSet() {
  const f = S.filters;
  return S.nodes.filter((n) =>
    (!f.area || n.area === f.area) &&
    (!f.verdict || n.verdict === f.verdict) &&
    (!f.kind || n.kind === f.kind) &&
    (!f.motif || n.motifs.includes(f.motif)));
}

function renderRail() {
  const rail = $("#railbody");
  rail.textContent = "";
  const counts = (key, of) => {
    const c = new Map();
    for (const n of S.nodes) {
      for (const v of of(n)) c.set(v, (c.get(v) || 0) + 1);
    }
    return [...c.entries()].sort((a, b) => b[1] - a[1]);
  };
  const section = (title, key, entries, top = 14) => {
    rail.append(el("h3", "", title));
    for (const [v, c] of entries.slice(0, top)) {
      const row = el("div", "obs" + (S.filters[key] === v ? " on" : ""));
      const lab = el("span", "", v);
      if (key === "area" || key === "motif") tint(lab, v.split("/").pop(), 0.8);
      row.append(lab);
      row.append(el("span", "n", String(c)));
      row.onclick = () => {
        S.filters[key] = S.filters[key] === v ? null : v;
        traceStep("observe", `${key}=${v}`);
        renderRail();
      };
      rail.append(row);
    }
  };
  section("Areas", "area", counts("area", (n) => [n.area]), 18);
  section("Verdict", "verdict", counts("verdict", (n) => [n.verdict]), 8);
  section("Species", "kind", counts("kind", (n) => [n.kind]), 8);
  section("Motifs", "motif", counts("motif", (n) => n.motifs), 12);

  const act = activeSet();
  const on = Object.entries(S.filters).filter(([, v]) => v);
  $("#meetline").innerHTML = on.length
    ? `meet of ${on.length} observation${on.length > 1 ? "s" : ""}: <b>${act.length}</b> nodes ` +
      `<button id="showmeet" style="margin-left:6px">list</button>`
    : `no observation active — the whole corpus, <b>${S.nodes.length}</b> nodes`;
  const btn = $("#showmeet");
  if (btn) btn.onclick = () => showMeet(act);
}

function showMeet(act) {
  setView("focus");
  const f = $("#focus");
  f.textContent = "";
  f.append(el("div", "crumbs", "meet of active observations"));
  f.append(el("h1", "sentence", `${act.length} nodes in the meet`));
  const note = el("p", "about",
    "Each filter is an observation; running them jointly is their meet — " +
    "exact at points (conservation and separation decompose componentwise). " +
    "What a pair of views knows beyond this list is glue, and lives on paths, not here.");
  f.append(note);
  const list = el("section", "block");
  const sorted = [...act].sort((a, b) => b.deg - a.deg);
  for (const n of sorted.slice(0, 400)) list.append(nodeRow(n));
  f.append(list);
}

function nodeRow(n) {
  const row = el("div", "edge");
  row.append(el("span", "et", n.verdict === "red-by-design" ? "✕" : String(n.deg)));
  const m = el("span", "em", n.sent || n.head);
  row.append(m);
  row.onclick = () => openNode(n);
  return row;
}

/* ---------------- focus view ---------------- */

async function typesOf(n) {
  // kernel-computed types, present only where the elaboration has reached
  const key = n.dsh;
  if (!S.types.has(key)) {
    const t = await fetch("store/types/" + key + ".json")
      .then((r) => (r.ok ? r.json() : {}))
      .catch(() => ({}));
    S.types.set(key, t);
  }
  return S.types.get(key)[n.m] || null;
}

async function detailOf(n) {
  if (!S.details.has(n.dsh)) {
    const t = await fetch("store/" + S.idx.details[n.dsh]).then((r) => r.json());
    S.details.set(n.dsh, t);
  }
  return S.details.get(n.dsh)[n.a];
}

async function sourceOf(n) {
  const key = n.ssh;
  if (!key || !S.idx.shards[key]) return null;
  if (!S.srcs.has(key)) {
    const t = await fetch("store/" + S.idx.shards[key]).then((r) => r.json());
    S.srcs.set(key, t);
  }
  return S.srcs.get(key)[n.a] || null;
}

async function openNode(n, fromRoute = false, isReverse = false) {
  S.focus = n;
  setView("focus");
  if (!fromRoute) history.pushState(null, "", "#" + encodeURIComponent(n.m));
  if (!isReverse) traceStep("open", n.m);
  const f = $("#focus");
  f.textContent = "";

  f.append(el("div", "crumbs", `${n.p}  ·  ${n.a}`));
  const h1 = el("h1", "sentence");
  for (const w of (n.sent || n.head).split(/(\s+)/)) {
    if (/^\s+$/.test(w) || w.length < 4) { h1.append(w); continue; }
    const sp = el("span", "", w);
    tint(sp, w, 0.55);
    h1.append(sp);
  }
  f.append(h1);
  if (n.sent) {
    const hn = el("div", "headname");
    const hd = el("span", "", n.head);
    tint(hd, n.head, 1);
    hn.append(hd, "  ·  " + n.m);
    f.append(hn);
  }

  const badges = el("div", "badges");
  badges.append(el("span", "badge v-" + n.verdict, n.verdict));
  badges.append(el("span", "badge k-" + n.kind, n.kind));
  if (n.lane) badges.append(el("span", "badge", n.lane));
  badges.append(el("span", "badge", n.area));
  for (const m of n.motifs) badges.append(el("span", "badge", m));
  badges.append(el("span", "badge", n.loc + " lines"));
  f.append(badges);

  if (n.verdict === "red-by-design") {
    f.append(el("div", "redband",
      "Red by design: this module must FAIL to typecheck. Its content is the " +
      "located defect it pins; a successful compile would itself be the defect returning."));
  }

  const d = await detailOf(n);
  if (d && d.header) {
    const sec = el("section", "block");
    sec.append(el("h2", "", "The module speaks"));
    const prose = el("div", "prose");
    prose.innerHTML = linkifyProse(esc(d.header));
    sec.append(prose);
    f.append(sec);
  }
  if (d && d.struck && d.struck.length) {
    const sec = el("section", "block");
    sec.append(el("h2", "", "Struck, and retained"));
    sec.append(el("div", "strucknote",
      "Corrections are first-class history here — struck in place, never deleted."));
    for (const s of d.struck) sec.append(el("span", "struck", s));
    f.append(sec);
  }
  if (d && d.decls && d.decls.length) {
    const ktypes = await typesOf(n);
    const sec = el("section", "block");
    sec.append(el("h2", "",
      `Checked terms (${d.decls.length})` +
      (ktypes ? " — types computed by the kernel" : " — signatures read from text")));
    for (const dec of d.decls.slice(0, 40)) {
      const box = el("div", "decl");
      const kt = ktypes && ktypes[dec.n];
      const shown = kt ? `${dec.n} : ${kt}` : dec.s;
      box.innerHTML = esc(shown).replace(esc(dec.n),
        `<span class="dn" data-n="${esc(dec.n)}">${esc(dec.n)}</span>`);
      if (kt) box.classList.add("kernel");
      box.querySelectorAll(".dn").forEach((e) => {
        e.addEventListener("mouseenter", (ev) => conceptCard(ev, dec.n));
        tint(e, dec.n, 1);
      });
      sec.append(box);
    }
    f.append(sec);
  }

  // ---- the fibre of this presentation ----
  {
    const sec = el("section", "block");
    sec.append(el("h2", "", "The fibre — what this presentation hides"));
    const items = [];
    const base = n.m.split(".").pop().replace(/Fibre/g, "Fiber");
    const twins = S.nodes.filter((m) =>
      m.i !== n.i && m.m.split(".").pop().replace(/Fibre/g, "Fiber") === base);
    if (twins.length) items.push(
      `${twins.length} other spelling${twins.length > 1 ? "s" : ""}/lane${twins.length > 1 ? "s" : ""} of this module — this page shows one realization of its content.`);
    const cls = S.nodes.filter((m) =>
      m.area === n.area && m.verdict === n.verdict && m.kind === n.kind);
    items.push(
      `Under the rail's observations (area, verdict, species) this node is one of ` +
      `${cls.length} indistinguishable realizations — the filters cannot separate them; ` +
      `what separates them lives here, in the content.`);
    const revs = S.trace.filter((s) => s.rev).length;
    items.push(
      `The route that brought you here: grade ${S.trace.length}, ` +
      `${revs} reversal mark${revs === 1 ? "" : "s"} — absent from this page, held in the trace.`);
    if (d && d.struck && d.struck.length === 0) { /* nothing */ }
    for (const it of items) {
      const li = el("div", "fibreline", it);
      sec.append(li);
    }
    const btn2 = el("button", "", `list the ${cls.length} indistinguishables`);
    btn2.onclick = () => showMeet(cls);
    sec.append(btn2);
    f.append(sec);
  }

  const srcSec = el("section", "block");
  srcSec.append(el("h2", "", "Source (the object itself)"));
  const btn = el("button", "", "load source");
  srcSec.append(btn);
  btn.onclick = async () => {
    const src = await sourceOf(n);
    btn.remove();
    const box = el("div", "srcbox");
    box.innerHTML = highlight(src || "(source shard not found)");
    box.querySelectorAll(".id-link").forEach((e) => {
      e.addEventListener("click", () => jumpToName(e.dataset.n));
      e.addEventListener("mouseenter", (ev) => conceptCard(ev, e.dataset.n));
      tint(e, e.dataset.n, 0.9);
    });
    srcSec.append(box);
    traceStep("read-source", n.m);
  };
  f.append(srcSec);

  renderContext(n);
  f.scrollTop = 0;
}

function linkifyProse(text) {
  return text.replace(/([A-Za-z][A-Za-z0-9_]{11,})/g, (w) => {
    const hit = [...S.byMod.keys()].some((m) => m.endsWith("." + w) || m === w);
    return hit ? `<span class="modref" onclick="window.__openMod('${w}')">${w}</span>` : w;
  });
}
window.__openMod = (short) => {
  for (const [m, n] of S.byMod) {
    if (m === short || m.endsWith("." + short)) { openNode(n); return; }
  }
};

function highlight(src) {
  let out = esc(src);
  out = out.replace(/(\{-#[\s\S]*?#-\})/g, '<span class="cm">$1</span>');
  out = out.replace(/(--[^\n]*)/g, '<span class="cm">$1</span>');
  out = out.replace(/\b(module|open|import|data|record|where|let|in|field|constructor|private|postulate|macro|variable|mutual)\b/g,
    '<span class="kw">$1</span>');
  // identifier links for names known to the store (word-ish tokens > 3 chars)
  out = out.replace(/(?<![<\w"#-])([A-Za-zऀ-ॿ][A-Za-z0-9_'ऀ-ॿ\-]{3,})(?![^<]*>)/g,
    (w) => S.names[w] ? `<span class="id-link" data-n="${w}">${w}</span>` : w);
  return out;
}

function jumpToName(name) {
  const hits = S.names[name];
  if (!hits || !hits.length) return;
  const target = S.nodes[hits[0]];
  if (target) openNode(target);
}

/* ---------------- concept cards ---------------- */

let cardTimer = null;
function conceptCard(ev, name) {
  if (!S.concepts) return;
  const key = name.toLowerCase().replace(/[-_' ]/g, "");
  const cards = S.concepts.table[key];
  const box = $("#card");
  clearTimeout(cardTimer);
  if (!cards) { box.hidden = true; return; }
  box.textContent = "";
  const c = cards[0];
  box.append(el("h4", "", c.name));
  const links = el("div", "");
  const a1 = el("a", "", "agda-unimath"); a1.href = c.page; a1.target = "_blank"; a1.rel = "noopener";
  links.append(a1);
  if (c.wd) {
    const a2 = el("a", "", "wikidata " + c.wd);
    a2.href = "https://www.wikidata.org/wiki/" + c.wd; a2.target = "_blank"; a2.rel = "noopener";
    links.append(a2);
    const a3 = el("a", "", "mathswitch");
    a3.href = "https://mathswitch.xyz/concept/Wd/" + c.wd; a3.target = "_blank"; a3.rel = "noopener";
    links.append(a3);
  }
  box.append(links);
  box.append(el("div", "route", "route: " + S.concepts.route));
  const r = ev.target.getBoundingClientRect();
  box.style.left = Math.min(r.left, innerWidth - 340) + "px";
  box.style.top = (r.bottom + 8) + "px";
  box.hidden = false;
  const hide = () => { cardTimer = setTimeout(() => { box.hidden = true; }, 350); };
  ev.target.addEventListener("mouseleave", hide, { once: true });
  box.onmouseenter = () => clearTimeout(cardTimer);
  box.onmouseleave = () => { box.hidden = true; };
}

/* ---------------- context rail ---------------- */

const EDGE_EVIDENCE = {
  "import": "exact — read from the source text",
  "ratri-target": "decoded from the probe's own filename",
  "header-mention": "a reading of prose — not a checked relation",
};

function renderContext(n) {
  const c = $("#ctxbody");
  c.textContent = "";
  const outs = (S.out.get(n.i) || []);
  const inns = (S.inn.get(n.i) || []);
  const bucket = (title, pairs, dir) => {
    if (!pairs.length) return;
    c.append(el("h3", "", `${title} (${pairs.length})`));
    const byType = new Map();
    for (const [j, t] of pairs) {
      if (!byType.has(t)) byType.set(t, []);
      byType.get(t).push(j);
    }
    for (const [t, js] of byType) {
      c.append(el("div", "evroute", `${t}: ${EDGE_EVIDENCE[t] || t}`));
      const seen = new Set();
      for (const j of js.slice(0, 30)) {
        if (seen.has(j)) continue;
        seen.add(j);
        const m = S.nodes[j];
        const row = el("div", "edge");
        row.append(el("span", "et", dir));
        const em = el("span", "em", m.sent || m.head);
        tint(em, m.head, 0.6);
        row.append(em);
        row.onclick = () => openNode(m);
        c.append(row);
      }
    }
  };
  bucket("Feeds on", outs, "→");
  bucket("Fed by", inns, "←");

  // twins: same basename across lanes (fibre/fiber/punaragamana)
  const base = n.m.split(".").pop().replace(/Fibre/g, "Fiber");
  const twins = S.nodes.filter((m) =>
    m.i !== n.i && m.m.split(".").pop().replace(/Fibre/g, "Fiber") === base);
  if (twins.length) {
    c.append(el("h3", "", "Other lanes of this module"));
    for (const m of twins) {
      const row = el("div", "edge");
      row.append(el("span", "et", m.lane || m.area));
      row.append(el("span", "em", m.m));
      row.onclick = () => openNode(m);
      c.append(row);
    }
  }
}

/* ---------------- search ---------------- */

function wireSearch() {
  const q = $("#q");
  const res = $("#results");
  let sel = -1, hits = [];
  const run = () => {
    const v = q.value.trim().toLowerCase();
    res.textContent = ""; sel = -1; hits = [];
    if (v.length < 2) { res.hidden = true; return; }
    const scored = [];
    for (const n of S.nodes) {
      const hay = (n.sent + " " + n.head + " " + n.m + " " + n.area).toLowerCase();
      const pos = hay.indexOf(v);
      if (pos >= 0) scored.push([pos === 0 ? 0 : 1, -n.deg, n]);
    }
    // declaration names too
    for (const [name, js] of Object.entries(S.names)) {
      if (name.toLowerCase().includes(v)) {
        for (const j of js.slice(0, 2)) scored.push([2, -S.nodes[j].deg, S.nodes[j], name]);
      }
      if (scored.length > 400) break;
    }
    scored.sort((a, b) => a[0] - b[0] || a[1] - b[1]);
    const seen = new Set();
    for (const [, , n, name] of scored) {
      if (seen.has(n.i + (name || ""))) continue;
      seen.add(n.i + (name || ""));
      hits.push([n, name]);
      if (hits.length >= 24) break;
    }
    for (const [n, name] of hits) {
      const r = el("div", "r");
      const rm = el("div", "rm");
      if (name) { const nm = el("span", "", name); tint(nm, name, 1); rm.append(nm, "  ·  "); }
      const hd = el("span", "", n.m);
      tint(hd, n.head, 0.7);
      rm.append(hd);
      r.append(rm);
      r.append(el("div", "rs", n.sent || n.head));
      r.onclick = () => { res.hidden = true; q.blur(); traceStep("ask", v); openNode(n); };
      res.append(r);
    }
    res.hidden = hits.length === 0;
  };
  q.addEventListener("input", run);
  q.addEventListener("keydown", (e) => {
    if (e.key === "Escape") { res.hidden = true; q.blur(); }
    if (e.key === "ArrowDown" || e.key === "ArrowUp") {
      e.preventDefault();
      const rows = res.querySelectorAll(".r");
      if (!rows.length) return;
      sel = e.key === "ArrowDown" ? Math.min(sel + 1, rows.length - 1) : Math.max(sel - 1, 0);
      rows.forEach((r, i) => r.classList.toggle("sel", i === sel));
      rows[sel].scrollIntoView({ block: "nearest" });
    }
    if (e.key === "Enter" && sel >= 0 && hits[sel]) {
      res.hidden = true; q.blur();
      traceStep("ask", q.value.trim());
      openNode(hits[sel][0]);
    }
  });
  document.addEventListener("click", (e) => {
    if (!res.contains(e.target) && e.target !== q) res.hidden = true;
  });
}

function wireKeys() {
  document.addEventListener("keydown", (e) => {
    if ((e.metaKey || e.ctrlKey) && e.key === "k") { e.preventDefault(); $("#q").focus(); }
    if (e.key === "/" && document.activeElement !== $("#q")) { e.preventDefault(); $("#q").focus(); }
    if ((e.altKey) && e.key === "ArrowLeft") { e.preventDefault(); goBack(); }
  });
  $("#backbtn").onclick = goBack;
  $("#graphbtn").onclick = () => { location.hash = "~graph"; };
  $("#aboutbtn").onclick = () => { location.hash = "~about"; };
  $("#lensbtn").onclick = () => {
    Grapheme.toggle();
    $("#lensbtn").classList.toggle("on", Grapheme.enabled);
    route();
    renderRail();
  };
  $("#lensbtn").classList.toggle("on", Grapheme.enabled);
  $("#gcolorbtn").onclick = () => {
    S.graphColor = S.graphColor === "verdict" ? "grapheme" : "verdict";
    $("#gcolorbtn").textContent = "color: " + S.graphColor;
    drawGraph();
  };
  $("#themebtn").onclick = () => {
    const r = document.documentElement;
    const cur = r.dataset.theme;
    r.dataset.theme = cur === "dark" ? "light" : "dark";
  };
}

/* ---------------- views ---------------- */

function setView(v) {
  S.view = v;
  $("#focus").hidden = v === "graph";
  $("#graphwrap").hidden = v !== "graph";
  $("#graphbtn").classList.toggle("on", v === "graph");
  if (v === "graph") drawGraph();
  if (v === "about") renderAbout();
}

function renderAbout() {
  const f = $("#focus");
  f.textContent = "";
  f.append(el("h1", "sentence", "How this place is built"));
  const p = el("div", "about");
  p.innerHTML =
    `<p>${esc(S.idx["evidence-note"])}</p>
     <p>The store is content-addressed: a node's identity is the hash of its
     source, and its name is metadata. The filter rail composes observations;
     their conjunction is the meet, computed. Navigation appends to a trace
     whose reversals are marks, not deletions — the grade and the reversal
     count shown under the trace are exactly the two data any collapsed
     history summary provably loses.</p>
     <p>Concept cards join to agda-unimath's published concept index
     (name-normalized candidates, labeled as such) and out to Wikidata.
     When the pinned kernel joins this store, textual edges are replaced by
     elaborated ones, and hover shows computed types and normal forms.</p>
     <p><b>The grapheme lens.</b> Color here is a computed observation on
     spelling: a token's hue is the front-loaded blend of its graphemes'
     hues, so names sharing a root cohere in color and diverge as they
     diverge. It surfaces relation before reading. Paste your own
     configuration below — exact word colors, prefix colors, per-grapheme
     colors — and the whole place repaints to your mapping.</p>`;
  f.append(p);
  const ta = el("textarea");
  ta.id = "lenscfg";
  ta.style.cssText = "width:100%;max-width:72ch;height:130px;font:12px var(--mono);" +
    "background:var(--card);color:var(--ink);border:1px solid var(--line);border-radius:6px;padding:8px";
  ta.value = JSON.stringify(Grapheme.cfg, null, 1);
  const apply = el("button", "", "apply configuration");
  const msg = el("span", "", "");
  msg.style.marginLeft = "10px";
  apply.onclick = () => {
    try {
      Grapheme.save(ta.value);
      msg.textContent = "applied — the place repaints to your mapping";
      renderRail();
    } catch (err) {
      msg.textContent = "not valid JSON: " + err.message;
    }
  };
  f.append(ta, el("div"), apply, msg);
}

/* ---------------- graph ---------------- */

let G = null; // {pos: Float32Array, scale, tx, ty}

function layoutGraph() {
  // Deterministic radial layout: areas as sectors, radius by hub degree
  // (hubs central), angle within sector by stable hash of the module name.
  const areas = [...new Set(S.nodes.map((n) => n.area))].sort();
  const sector = new Map(areas.map((a, i) => [a, i]));
  const total = areas.length;
  const pos = new Float32Array(S.nodes.length * 2);
  const maxDeg = Math.max(...S.nodes.map((n) => n.deg), 1);
  for (const n of S.nodes) {
    const si = sector.get(n.area);
    let h = 0;
    for (const ch of n.m) h = (h * 31 + ch.charCodeAt(0)) >>> 0;
    const a0 = (si / total) * Math.PI * 2;
    const a1 = ((si + 1) / total) * Math.PI * 2;
    const ang = a0 + ((h % 1000) / 1000) * (a1 - a0) * 0.92 + 0.04 * (a1 - a0);
    const r = 120 + (1 - Math.sqrt(n.deg / maxDeg)) * 480 + ((h >> 10) % 60);
    pos[n.i * 2] = Math.cos(ang) * r;
    pos[n.i * 2 + 1] = Math.sin(ang) * r;
  }
  return pos;
}

const VERDICT_COLOR = {
  "proved-safe": "#2e6e4e", "checked": "#557a68",
  "conjecture-as-type": "#8a6d1f", "red-by-design": "#9e2b25",
  "postulate": "#9e2b25",
};

function drawGraph() {
  const canvas = $("#graph");
  const wrap = $("#graphwrap");
  const dpr = devicePixelRatio || 1;
  canvas.width = wrap.clientWidth * dpr;
  canvas.height = wrap.clientHeight * dpr;
  if (!G) G = { pos: layoutGraph(), scale: 0.55, tx: 0, ty: 0 };
  const ctx = canvas.getContext("2d");
  const dark = matchMedia("(prefers-color-scheme: dark)").matches ||
    document.documentElement.dataset.theme === "dark";
  const paint = () => {
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.translate(canvas.width / 2 + G.tx * dpr, canvas.height / 2 + G.ty * dpr);
    ctx.scale(G.scale * dpr, G.scale * dpr);
    // edges of the focus neighborhood, plus a faint global import skeleton
    ctx.globalAlpha = 0.10;
    ctx.strokeStyle = dark ? "#8f86c9" : "#3a3466";
    ctx.lineWidth = 0.5 / G.scale;
    ctx.beginPath();
    for (const [s, d, t] of S.idx.edges) {
      if (t !== "import") continue;
      ctx.moveTo(G.pos[s * 2], G.pos[s * 2 + 1]);
      ctx.lineTo(G.pos[d * 2], G.pos[d * 2 + 1]);
    }
    ctx.stroke();
    if (S.focus) {
      ctx.globalAlpha = 0.85;
      ctx.strokeStyle = dark ? "#d9a441" : "#b8860b";
      ctx.lineWidth = 1.4 / G.scale;
      ctx.beginPath();
      const around = [...(S.out.get(S.focus.i) || []), ...(S.inn.get(S.focus.i) || [])];
      for (const [j] of around) {
        ctx.moveTo(G.pos[S.focus.i * 2], G.pos[S.focus.i * 2 + 1]);
        ctx.lineTo(G.pos[j * 2], G.pos[j * 2 + 1]);
      }
      ctx.stroke();
    }
    ctx.globalAlpha = 1;
    const act = new Set(activeSet().map((n) => n.i));
    for (const n of S.nodes) {
      const x = G.pos[n.i * 2], y = G.pos[n.i * 2 + 1];
      const rr = 1.2 + Math.sqrt(n.deg) * 0.9;
      ctx.beginPath();
      ctx.arc(x, y, rr, 0, Math.PI * 2);
      ctx.fillStyle = S.graphColor === "grapheme"
        ? Grapheme.color(n.head, { dark, strength: 1 })
        : (VERDICT_COLOR[n.verdict] || "#777");
      ctx.globalAlpha = act.has(n.i) ? 0.95 : 0.15;
      ctx.fill();
      if (S.focus && n.i === S.focus.i) {
        ctx.globalAlpha = 1;
        ctx.strokeStyle = dark ? "#e8e3d8" : "#23212b";
        ctx.lineWidth = 1.5 / G.scale;
        ctx.stroke();
      }
    }
    ctx.globalAlpha = 1;
  };
  paint();

  let drag = null;
  canvas.onmousedown = (e) => { drag = [e.clientX, e.clientY]; canvas.classList.add("dragging"); };
  window.onmouseup = () => { drag = null; canvas.classList.remove("dragging"); };
  window.onmousemove = (e) => {
    if (!drag) return;
    G.tx += e.clientX - drag[0];
    G.ty += e.clientY - drag[1];
    drag = [e.clientX, e.clientY];
    paint();
  };
  canvas.onwheel = (e) => {
    e.preventDefault();
    const k = Math.exp(-e.deltaY * 0.0012);
    G.scale = Math.min(8, Math.max(0.08, G.scale * k));
    paint();
  };
  canvas.onclick = (e) => {
    const rect = canvas.getBoundingClientRect();
    const px = ((e.clientX - rect.left) * dpr - canvas.width / 2 - G.tx * dpr) / (G.scale * dpr);
    const py = ((e.clientY - rect.top) * dpr - canvas.height / 2 - G.ty * dpr) / (G.scale * dpr);
    let best = null, bd = 12 / G.scale;
    for (const n of S.nodes) {
      const dx = G.pos[n.i * 2] - px, dy = G.pos[n.i * 2 + 1] - py;
      const d2 = Math.hypot(dx, dy);
      if (d2 < bd) { bd = d2; best = n; }
    }
    if (best) { location.hash = encodeURIComponent(best.m); }
  };
}

boot();
