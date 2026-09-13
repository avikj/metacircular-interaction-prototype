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

const enc = new TextEncoder();
const dec = new TextDecoder();

async function boot(base) {
  const chunks = await Promise.all([0, 1, 2].map((i) =>
    fetch(base + "kernel/agda.wasm." + i).then((r) => {
      if (!r.ok) throw new Error("wasm chunk " + i + ": " + r.status);
      return r.arrayBuffer();
    })));
  const total = chunks.reduce((n, c) => n + c.byteLength, 0);
  const buf = new Uint8Array(total);
  let off = 0;
  for (const c of chunks) { buf.set(new Uint8Array(c), off); off += c.byteLength; }
  wasmModule = await WebAssembly.compile(buf);
  primFiles = await fetch(base + "kernel/prim.json").then((r) => r.json());
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
    for (const [path, text] of Object.entries(tbl)) {
      const parts = path.split("/");
      const fn = parts.pop();
      dirOf(parts).set(fn, new File(enc.encode(text)));
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
  const rootDir = mk(tbl);
  rootDir.contents.set("tmp", new Directory(new Map()));
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
