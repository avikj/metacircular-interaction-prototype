/* The kernel, in the browser.
 *
 * Agda 2.8.0 (the repository pin) compiled to WebAssembly, run inside a
 * Web Worker under a WASI shim. Each request is a single-shot
 * interaction run: the IOTCM commands are pre-buffered on stdin (so
 * stdin never blocks), the module lives in an in-memory filesystem, and
 * stdout's JSON lines come back verbatim — the kernel's own words.
 *
 * Protocol (postMessage):
 *   {id, op: "boot"}                          → {id, ok, version}
 *   {id, op: "run", file, text, commands: []} → {id, lines: [...]}
 * Distribution: agda-opt.wasm ships as 3 chunks (agda.wasm.0..2),
 * reassembled here; the prim library ships as prim.json.
 */

import { WASI, File, OpenFile, Directory, PreopenDirectory, ConsoleStdout }
  from "./wasi/index.js";

/* Agda's interaction mode sets stdin nonblocking (fd_fdstat_set_flags);
 * the shim's OpenFile rejects that and Agda then exits before reading a
 * command. An in-memory file never blocks anyway, so accepting the flag
 * as a no-op is exact. */
class StdinFile extends OpenFile {
  fd_fdstat_set_flags(_flags) { return 0; }
  fd_fdstat_set_rights(_base, _inheriting) { return 0; }
}

let wasmModule = null;
let primFiles = null;
let libManifest = null;   // cubical interface pack manifest
let libBlob = null;       // concatenated .agdai bytes

const enc = new TextEncoder();
const dec = new TextDecoder();

/* Fetch through the Cache API so the kernel downloads once per device,
 * independent of HTTP cache policy. Falls back to plain fetch. */
async function fetchCached(url) {
  let cache = null;
  try { cache = await caches.open("agda-kernel-2.8.0"); } catch (e) {}
  if (cache) {
    const hit = await cache.match(url);
    if (hit) return hit;
  }
  const r = await fetch(url);
  if (!r.ok) throw new Error(url + ": " + r.status);
  if (cache) { try { await cache.put(url, r.clone()); } catch (e) {} }
  return r;
}

async function boot(base) {
  const chunks = await Promise.all([0, 1, 2].map((i) =>
    fetchCached(base + "kernel/agda.wasm." + i).then((r) => r.arrayBuffer())));
  const total = chunks.reduce((n, c) => n + c.byteLength, 0);
  const buf = new Uint8Array(total);
  let off = 0;
  for (const c of chunks) { buf.set(new Uint8Array(c), off); off += c.byteLength; }
  wasmModule = await WebAssembly.compile(buf);
  primFiles = await fetchCached(base + "kernel/prim.json").then((r) => r.json());
  try {
    libManifest = await fetchCached(base + "kernel/lib.pack.json").then((r) => r.json());
    libBlob = new Uint8Array(
      await fetchCached(base + "kernel/lib.pack.0").then((r) => r.arrayBuffer()));
  } catch (e) { libManifest = null; libBlob = null; }
}

function buildTree(extra) {
  // the whole in-memory root: /opt (lib/prim + the module), /tmp, /opt/.agda —
  // preopened at "/" so ".." resolution and temp files both work
  const mk = (tbl) => {
    const root = new Map();
    const dirOf = (parts) => {
      let cur = root;
      for (const p of parts) {
        if (!cur.has(p)) cur.set(p, new Map());
        cur = cur.get(p);
      }
      return cur;
    };
    for (const [path, data] of Object.entries(tbl)) {
      const parts = path.split("/");
      const fn = parts.pop();
      dirOf(parts).set(fn, new File(
        typeof data === "string" ? enc.encode(data) : data));
    }
    const toDir = (m) => {
      const contents = new Map();
      for (const [k, v] of m) contents.set(k, v instanceof Map ? toDir(v) : v);
      return new Directory(contents);
    };
    return toDir(root);
  };
  const tbl = {};
  for (const [p, t] of Object.entries(primFiles)) tbl["opt/" + p] = t;
  for (const [p, t] of Object.entries(extra)) tbl["opt/" + p] = t;
  if (libManifest) {
    for (const [p, t] of Object.entries(libManifest.sources)) tbl["cubical/" + p] = t;
    for (const [p, [off, len]] of Object.entries(libManifest.agdai))
      tbl["cubical/_build/2.8.0/agda/" + p] = libBlob.subarray(off, off + len);
    tbl["opt/.agda/libraries"] = "/cubical/cubical.agda-lib\n";
    tbl["opt/.agda/defaults"] = "cubical-0.9\n";
  }
  const rootDir = mk(tbl);
  rootDir.contents.set("tmp", new Directory(new Map()));
  if (!rootDir.contents.get("opt").contents.has(".agda"))
    rootDir.contents.get("opt").contents.set(".agda", new Directory(new Map()));
  return rootDir;
}

function run(fileName, text, commands) {
  const stdinText = commands.map((c) =>
    `IOTCM "/opt/${fileName}" None Indirect (${c})`).join("\n") + "\n";
  const stdinBytes = enc.encode(stdinText);
  const stdout = [];
  const stderr = [];

  const rootDir = buildTree({ [fileName]: text });
  const fds = [
    // fd 0: stdin as a plain in-memory file — EOF at end, never blocks
    new StdinFile(new File(stdinBytes)),
    ConsoleStdout.lineBuffered((l) => stdout.push(l)),
    ConsoleStdout.lineBuffered((l) => stderr.push(l)),
    new PreopenDirectory("/", rootDir.contents),
  ];
  const wasi = new WASI(
    ["agda", "--interaction-json", "+RTS", "-V1", "-RTS"],
    ["PWD=/opt", "HOME=/opt", "Agda_datadir=/opt", "AGDA_DIR=/opt/.agda"],
    fds, { debug: false });
  const inst = new WebAssembly.Instance(wasmModule, {
    wasi_snapshot_preview1: wasi.wasiImport,
  });
  try { wasi.start(inst); } catch (e) { stderr.push(String(e)); }
  return { lines: stdout, errs: stderr };
}

self.onmessage = async (ev) => {
  const { id, op } = ev.data;
  try {
    if (op === "boot") {
      await boot(ev.data.base || "../");
      self.postMessage({ id, ok: true });
    } else if (op === "run") {
      const r = run(ev.data.file, ev.data.text, ev.data.commands);
      self.postMessage({ id, ...r });
    }
  } catch (e) {
    self.postMessage({ id, error: String(e && e.message || e) });
  }
};
